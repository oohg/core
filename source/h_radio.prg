/*
 * $Id: h_radio.prg $
 */
/*
 * ooHG source code:
 * RadioGroup control
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
 */
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 */


#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TRadioGroup FROM TLabel

   DATA Type                   INIT "RADIOGROUP" READONLY
   DATA TabStop                INIT .T.
   DATA IconWidth              INIT 19
   DATA nWidth                 INIT 120
   DATA nHeight                INIT 25
   DATA aOptions               INIT {}
   DATA TabHandle              INIT 0
   DATA lHorizontal            INIT .F.
   DATA nSpacing               INIT Nil
   DATA lLibDraw               INIT .F.
   DATA oBkGrnd                INIT Nil
   DATA LeftAlign              INIT .F.

   METHOD RowMargin            BLOCK { |Self| - ::Row }
   METHOD ColMargin            BLOCK { |Self| - ::Col }
   METHOD ReadOnly             SETGET
   METHOD Define
   METHOD SetFont
   METHOD SizePos
   METHOD Value                SETGET
   METHOD Enabled              SETGET
   METHOD SetFocus
   METHOD Visible              SETGET
   METHOD GroupHeight
   METHOD GroupWidth
   METHOD ItemCount            BLOCK { |Self| LEN( ::aOptions ) }
   METHOD AddItem
   METHOD InsertItem
   METHOD DeleteItem
   METHOD Caption
   METHOD AdjustResize
   METHOD ItemEnabled
   METHOD ItemReadOnly
   METHOD Spacing              SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, aOptions, Value, fontname, ;
               fontsize, tooltip, change, width, spacing, HelpId, invisible, ;
               notabstop, bold, italic, underline, strikeout, backcolor, ;
               fontcolor, transparent, autosize, horizontal, lDisabled, lRtl, ;
               height, drawby, bkgrnd, left, readonly ) CLASS TRadioGroup

   Local i, oItem, uToolTip, uReadOnly

   ASSIGN ::nCol        VALUE x           TYPE "N"
   ASSIGN ::nRow        VALUE y           TYPE "N"
   ASSIGN ::nWidth      VALUE width       TYPE "N"
   ASSIGN ::nHeight     VALUE height      TYPE "N"
   ASSIGN ::lAutoSize   VALUE autosize    TYPE "L"
   ASSIGN ::lHorizontal VALUE horizontal  TYPE "L"
   ASSIGN ::Transparent VALUE transparent TYPE "L"
   ASSIGN ::LeftAlign   VALUE left        TYPE "L"
   ASSIGN ::nSpacing    VALUE spacing     TYPE "N" DEFAULT Iif( ::lHorizontal, ::nWidth, ::nHeight )
   ASSIGN aOptions      VALUE aOptions    TYPE "A" DEFAULT {}
   ASSIGN ::lLibDraw    VALUE drawby      TYPE "L" DEFAULT _OOHG_UsesVisualStyle()

   If HB_IsObject( bkgrnd )
      ::oBkGrnd := bkgrnd
   EndIf

   IF HB_IsLogical( NoTabStop )
      ::TabStop := ! NoTabStop
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, , lRtl )
   ::InitStyle( , , Invisible, ! ::TabStop, lDisabled )
   ::Register( 0, , HelpId, , tooltip )

   ::aOptions := {}

   x := ::Col
   y := ::Row
   For i = 1 to LEN( aOptions )
      If HB_IsArray( tooltip ) .AND. LEN( tooltip ) >= i
         uToolTip := tooltip[ i ]
      Else
         uToolTip := ::ToolTip
      EndIf
      If HB_IsArray( readonly ) .AND. LEN( readonly ) >= i
         uReadOnly := readonly[ i ]
      Else
         uReadOnly := readonly
      EndIf

      oItem := TRadioItem():Define( , Self, x, y, ::nWidth, ::nHeight, ;
               aOptions[ i ], .F., ( i == 1 ), ;
               ::AutoSize, ::Transparent, , , ;
               , , , , , , ;
               uToolTip, ::HelpId, , .T., uReadOnly, , ;
               bkgrnd, ::LeftAlign )

      AADD( ::aOptions, oItem )
      If ::lHorizontal
         x += ::nSpacing
      Else
         y += ::nSpacing
      EndIf
   Next

   ::Value := Value

   If ! HB_IsNumeric( Value ) .AND. LEN( ::aOptions ) > 0
      ::aOptions[ 1 ]:TabStop := .T.
   EndIf

   ::SetFont( , , bold, italic, underline, strikeout )

   ASSIGN ::OnChange VALUE Change TYPE "B"

   Return Self

METHOD GroupHeight() CLASS TRadioGroup

   Local nRet, oFirst, oLast

   IF ::lHorizontal
      nRet := ::Height
   ELSE
      IF LEN( ::aOptions ) > 0
         oFirst := ::aOptions[ 1 ]
         oLast  := aTail( ::aOptions )
         nRet   := oLast:Row + oLast:Height - oFirst:Row
      ELSE
         nRet := 0
      ENDIF
   ENDIF

   RETURN nRet

METHOD GroupWidth() CLASS TRadioGroup

   Local nRet, oFirst, oLast

   IF ::lHorizontal
      IF LEN( ::aOptions ) > 0
         oFirst := ::aOptions[ 1 ]
         oLast  := aTail( ::aOptions )
         nRet   := oLast:Col + oLast:Width - oFirst:Col
      ELSE
         nRet := 0
      ENDIF
   ELSE
      nRet := ::Width
   ENDIF

   RETURN nRet

METHOD SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced ) CLASS TRadioGroup

   AEVAL( ::aOptions, { |o| o:SetFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced ) } )

   RETURN Nil

METHOD SizePos( Row, Col, Width, Height ) CLASS TRadioGroup

   Local nDeltaRow, nDeltaCol, uRet

   nDeltaRow := ::Row
   nDeltaCol := ::Col
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   nDeltaRow := ::Row - nDeltaRow
   nDeltaCol := ::Col - nDeltaCol
   AEVAL( ::aControls, { |o| o:Visible := .F., o:SizePos( o:Row + nDeltaRow, o:Col + nDeltaCol, Width, Height ), o:Visible := .T. } )

   RETURN uRet

METHOD Value( nValue ) CLASS TRadioGroup

   LOCAL i, lSetFocus

   If HB_IsNumeric( nValue )
      nValue := INT( nValue )
      lSetFocus := ( ASCAN( ::aOptions, { |o| o:hWnd == GetFocus() } ) > 0 )
      For i := 1 TO LEN( ::aOptions )
         ::aOptions[ i ]:Value := ( i == nValue )
      Next
      nValue := ::Value
      For i := 1 TO LEN( ::aOptions )
         ::aOptions[ i ]:TabStop := ( ::TabStop .AND. i == MAX( nValue, 1 ) )
      Next
      If lSetFocus
         If nValue > 0
            ::aOptions[ nValue ]:SetFocus()
         EndIf
      EndIf
      ::DoChange()
   EndIf

   RETURN ASCAN( ::aOptions, { |o| o:Value } )

METHOD Enabled( lEnabled ) CLASS TRadioGroup

   If HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   EndIf

   RETURN ::Super:Enabled

METHOD SetFocus() CLASS TRadioGroup

   Local nValue

   nValue := ::Value
   If nValue >= 1 .AND. nValue <= LEN( ::aOptions )
      ::aOptions[ nValue ]:SetFocus()
   Else
      ::aOptions[ 1 ]:SetFocus()
   EndIf

   Return Self

METHOD Visible( lVisible ) CLASS TRadioGroup

   If HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      If lVisible
         AEVAL( ::aControls, { |o| o:Visible := o:Visible } )
      Else
         AEVAL( ::aControls, { |o| o:ForceHide() } )
      EndIf
   EndIf

   RETURN ::lVisible

METHOD AddItem( cCaption, nImage, uToolTip ) CLASS TRadioGroup

   Return ::InsertItem( ::ItemCount + 1, cCaption, nImage, uToolTip )

   /*
   TODO:
   RadioItem with Image instead/and Text.

   Note that TMultiPage control expects an Image as third parameter.
   */

METHOD InsertItem( nPosition, cCaption, nImage, uToolTip, bkgrnd, uLeftAlign, uReadOnly ) CLASS TRadioGroup

   Local nPos2, Spacing, oItem, x, y, nValue, hWnd

   EMPTY( nImage )
   IF  ( ! VALTYPE( uToolTip ) $ "CM" .OR. EMPTY( uToolTip ) ) .AND. ! HB_IsBlock( uToolTip )
      uToolTip := ::ToolTip
   ENDIF
   ASSIGN bkgrnd VALUE bkgrnd TYPE "O" DEFAULT ::oBkGrnd

   nValue := ::Value

   If HB_IsNumeric( ::nSpacing )
      Spacing := ::nSpacing
   Else
      Spacing := IF( ::lHorizontal, ::nWidth, ::nHeight )
   EndIf

   nPosition := INT( nPosition )
   If nPosition < 1 .OR. nPosition > LEN( ::aOptions )
      nPosition := LEN( ::aOptions ) + 1
   EndIf

   AADD( ::aOptions, Nil )
   AINS( ::aOptions, nPosition )
   nPos2 := LEN( ::aOptions )
   DO WHILE nPos2 > nPosition
      If ::lHorizontal
         ::aOptions[ nPos2 ]:Col += Spacing
      Else
         ::aOptions[ nPos2 ]:Row += Spacing
      EndIf
      nPos2--
   ENDDO

   If nPosition == 1
      x := ::Col
      y := ::Row
      If LEN( ::aOptions ) > 1
         WindowStyleFlag( ::aOptions[ 2 ]:hWnd, WS_GROUP, 0 )
      EndIf
   Else
      x := ::aOptions[ nPosition - 1 ]:Col
      y := ::aOptions[ nPosition - 1 ]:Row
      If ::lHorizontal
         x += Spacing
      Else
         y += Spacing
      EndIf
   EndIf
   oItem := TRadioItem():Define( , Self, x, y, ::Width, ::Height, ;
            cCaption, .F., ( nPosition == 1 ), ;
            ::AutoSize, ::Transparent, , , ;
            , , , , , , ;
            uToolTip, ::HelpId, , .T., uReadOnly, , ;
            bkgrnd, uLeftAlign )
   ::aOptions[ nPosition ] := oItem

   If nPosition > 1
      SetWindowPos( oItem:hWnd, ::aOptions[ nPosition - 1 ]:hWnd, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   ElseIf LEN( ::aOptions ) >= 2
      hWnd:= GetWindow( ::aOptions[ 2 ]:hWnd, GW_HWNDPREV )
      SetWindowPos( oItem:hWnd, hWnd, 0, 0, 0, 0, SWP_NOSIZE + SWP_NOMOVE )
   Endif

   If nValue >= nPosition
      ::Value := ::Value
   EndIf

   Return Nil

METHOD DeleteItem( nItem ) CLASS TRadioGroup

   Local nValue

   nItem := INT( nItem )
   If nItem >= 1 .AND. nItem <= LEN( ::aOptions )
      nValue := ::Value
      ::aOptions[ nItem ]:Release()
      _OOHG_DeleteArrayItem( ::aOptions, nItem )
      If nItem == 1 .AND. LEN( ::aOptions ) > 0
         WindowStyleFlag( ::aOptions[ 1 ]:hWnd, WS_GROUP, WS_GROUP )
      EndIf
      If nValue >= nItem
         ::Value := nValue
      EndIf
   EndIf

   If nValue >= nItem
      ::Value := ::Value
   EndIf

   Return Nil

METHOD Caption( nItem, uValue ) CLASS TRadioGroup

   Return ( ::aOptions[ nItem ]:Caption := uValue )

METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TRadioGroup

   If HB_IsNumeric( ::nSpacing )
      If ::lHorizontal
         ::Spacing := ::nSpacing * nDivw
      Else
         ::Spacing := ::nSpacing * nDivh
      EndIf
   EndIf

   Return ::Super:AdjustResize( nDivh, nDivw, lSelfOnly )

METHOD Spacing( nSpacing ) CLASS TRadioGroup

   Local x, y, i, oCtrl

   If HB_IsNumeric( nSpacing )
      x := ::Col
      y := ::Row
      For i = 1 to LEN( ::aOptions )
         oCtrl := ::aOptions[ i ]
         oCtrl:Visible := .F.
         oCtrl:SizePos( y, x )
         oCtrl:Visible := .T.
         If ::lHorizontal
            x += nSpacing
         Else
            y += nSpacing
         EndIf
      Next
      ::nSpacing := nSpacing
   EndIf

   Return ::nSpacing

METHOD ItemEnabled( nItem, lEnabled ) CLASS TRadioGroup

   If HB_IsLogical( lEnabled )
      ::aOptions[ nItem ]:Enabled := lEnabled
   EndIf

   Return ::aOptions[ nItem ]:Enabled

METHOD ItemReadonly( nItem, lReadOnly ) CLASS TRadioGroup

   If HB_IsLogical( lReadOnly )
      ::aOptions[ nItem ]:Enabled := ! lReadOnly
   EndIf

   Return ! ::aOptions[ nItem ]:Enabled

METHOD ReadOnly( uReadOnly ) CLASS TRadioGroup

  Local i, aReadOnly

   If HB_IsLogical( uReadOnly )
      aReadOnly := ARRAY( LEN( ::aOptions ) )
      AFILL( aReadOnly, uReadOnly )
   ElseIf HB_IsArray( uReadOnly )
      aReadOnly := ARRAY( LEN( ::aOptions ) )
      For i := 1 TO LEN( uReadOnly )
         If HB_IsLogical( uReadOnly[ i ] )
            aReadOnly[ i ] := uReadOnly[ i ]
         EndIf
      Next i
   EndIf

   If HB_IsArray( aReadOnly )
      For i := 1 TO LEN( ::aOptions )
         If HB_IsLogical( aReadOnly[ i ] )
            ::aOptions[ i ]:Enabled := ! aReadOnly[ i ]
         EndIf
      Next i
   Else
      aReadOnly := ARRAY( LEN( ::aOptions ) )
   EndIf

   For i := 1 TO LEN( ::aOptions )
      aReadOnly[ i ] := ! ::aOptions[ i ]:Enabled
   Next i

   Return aReadOnly


CLASS TRadioItem FROM TLabel

   DATA Type          INIT "RADIOITEM" READONLY
   DATA nWidth        INIT 120
   DATA nHeight       INIT 25
   DATA IconWidth     INIT 19
   DATA TabHandle     INIT 0
   DATA oBkGrnd       INIT Nil
   DATA LeftAlign     INIT .F.

   METHOD Define
   METHOD Value             SETGET
   METHOD Events
   METHOD Events_Command
   METHOD Events_Color
   METHOD Events_Notify

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, width, height, ;
               caption, value, lFirst, ;
               autosize, transparent, fontcolor, backcolor, ;
               fontname, fontsize, bold, italic, underline, strikeout, ;
               tooltip, HelpId, invisible, notabstop, lDisabled, lRtl, ;
               bkgrnd, left ) CLASS TRadioItem

   Local ControlHandle, nStyle, oContainer

   ASSIGN ::nCol      VALUE x      TYPE "N"
   ASSIGN ::nRow      VALUE y      TYPE "N"
   ASSIGN ::nWidth    VALUE width  TYPE "N"
   ASSIGN ::nHeight   VALUE height TYPE "N"
   ASSIGN ::LeftAlign VALUE left   TYPE "L"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor,, lRtl )

   If HB_IsObject( bkgrnd )
      ::oBkGrnd := bkgrnd
   ElseIf ::Parent:Type == "RADIOGROUP"
      ::oBkGrnd := ::Parent:oBkGrnd
   Endif

   nStyle := ::InitStyle( ,, Invisible, notabstop, lDisabled )

   If HB_IsLogical( lFirst ) .AND. lFirst
      ControlHandle := InitRadioGroup( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl, ::Width, ::Height, ::LeftAlign )
   Else
      ControlHandle := InitRadioButton( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, nStyle, ::lRtl, ::Width, ::Height, ::LeftAlign )
   EndIf

   ::Register( ControlHandle,, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   If ::IsVisualStyled
      oContainer := ::Container
      DO WHILE ! oContainer == Nil
         If oContainer:Type == "TAB"
            ::TabHandle := oContainer:hWnd
            EXIT
         EndIf
         oContainer := oContainer:Container
      ENDDO
   EndIf

   ::Transparent := transparent
   ::AutoSize    := autosize
   ::Caption     := caption
   ::Value       := value

   Return Self

METHOD Value( lValue ) CLASS TRadioItem

   LOCAL lOldValue

   If HB_IsLogical( lValue )
      lOldValue := ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )
      If ! lValue == lOldValue
         SendMessage( ::hWnd, BM_SETCHECK, IF( lValue, BST_CHECKED, BST_UNCHECKED ), 0 )
      EndIf
   EndIf

   Return ( SendMessage( ::hWnd, BM_GETCHECK, 0, 0 ) == BST_CHECKED )

METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TRadioItem

   If nMsg == WM_LBUTTONDBLCLK
      If HB_IsBlock( ::OnDblClick )
         ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
      ElseIf ! ::Container == Nil
         ::Container:DoEventMouseCoords( ::Container:OnDblClick, "DBLCLICK" )
      EndIf
      Return Nil
   ElseIf nMsg == WM_RBUTTONUP
      If HB_IsBlock( ::OnRClick )
         ::DoEventMouseCoords( ::OnRClick, "RCLICK" )
      ElseIf ! ::Container == Nil
         ::Container:DoEventMouseCoords( ::Container:OnRClick, "RCLICK" )
      EndIf
      Return Nil
   EndIf

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD Events_Command( wParam ) CLASS TRadioItem

   Local Hi_wParam := HIWORD( wParam )
   /*
   Local lTab
   */
   If Hi_wParam == BN_CLICKED
      If ! ::Container == Nil
         /*
         lTab := ( ::Container:TabStop .AND. ::Value )
         If ! lTab == ::TabStop
            ::TabStop := lTab
         EndIf
         */
         ::Container:DoChange()
      EndIf
      Return Nil
   EndIf

   Return ::Super:Events_Command( wParam )

METHOD Events_Color( wParam, nDefColor ) CLASS TRadioItem

   Return Events_Color_InTab( Self, wParam, nDefColor )    // see h_controlmisc.prg

METHOD Events_Notify( wParam, lParam ) CLASS TRadioItem

   Local nNotify := GetNotifyCode( lParam )

   If nNotify == NM_CUSTOMDRAW
      If ! ::Container == Nil .AND. ::Container:lLibDraw .AND. ::Container:IsVisualStyled .AND. ::IsVisualStyled
         Return TRadioItem_Notify_CustomDraw( Self, lParam, ::Caption, HB_IsObject( ::oBkGrnd ), ::LeftAlign )
      EndIf
   EndIf

   Return ::Super:Events_Notify( wParam, lParam )


#pragma BEGINDUMP

#ifndef HB_OS_WIN_USED
   #define HB_OS_WIN_USED
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif

#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

#ifndef BST_HOT
   #define BST_HOT        0x0200
#endif

/*
This files are not present in BCC 551
#include <uxtheme.h>
#include <tmschema.h>
*/

typedef struct _MARGINS {
   int cxLeftWidth;
   int cxRightWidth;
   int cyTopHeight;
   int cyBottomHeight;
} MARGINS, *PMARGINS;

typedef HANDLE HTHEME;

typedef enum THEMESIZE {
  TS_MIN,
  TS_TRUE,
  TS_DRAW
} THEMESIZE;

#ifndef __MSABI_LONG
#  ifndef __LP64__
#    define __MSABI_LONG(x) x ## l
#  else
#    define __MSABI_LONG(x) x
#  endif
#endif

#define DTT_TEXTCOLOR (__MSABI_LONG(1U) << 0)
#define DTT_BORDERCOLOR (__MSABI_LONG(1U) << 1)
#define DTT_SHADOWCOLOR (__MSABI_LONG(1U) << 2)
#define DTT_SHADOWTYPE (__MSABI_LONG(1U) << 3)
#define DTT_SHADOWOFFSET (__MSABI_LONG(1U) << 4)
#define DTT_BORDERSIZE (__MSABI_LONG(1U) << 5)
#define DTT_FONTPROP (__MSABI_LONG(1U) << 6)
#define DTT_COLORPROP (__MSABI_LONG(1U) << 7)
#define DTT_STATEID (__MSABI_LONG(1U) << 8)
#define DTT_CALCRECT (__MSABI_LONG(1U) << 9)
#define DTT_APPLYOVERLAY (__MSABI_LONG(1U) << 10)
#define DTT_GLOWSIZE (__MSABI_LONG(1U) << 11)
#define DTT_CALLBACK (__MSABI_LONG(1U) << 12)
#define DTT_COMPOSITED (__MSABI_LONG(1U) << 13)
#define DTT_VALIDBITS (DTT_TEXTCOLOR | DTT_BORDERCOLOR | DTT_SHADOWCOLOR | DTT_SHADOWTYPE | DTT_SHADOWOFFSET | DTT_BORDERSIZE | \
                       DTT_FONTPROP | DTT_COLORPROP | DTT_STATEID | DTT_CALCRECT | DTT_APPLYOVERLAY | DTT_GLOWSIZE | DTT_COMPOSITED)

typedef int (WINAPI *DTT_CALLBACK_PROC)(HDC hdc,LPWSTR pszText,int cchText,LPRECT prc,UINT dwFlags,LPARAM lParam);

#ifdef __BORLANDC__
typedef BOOL WINBOOL;
#endif

typedef struct _DTTOPTS {
    DWORD dwSize;
    DWORD dwFlags;
    COLORREF crText;
    COLORREF crBorder;
    COLORREF crShadow;
    int iTextShadowType;
    POINT ptShadowOffset;
    int iBorderSize;
    int iFontPropId;
    int iColorPropId;
    int iStateId;
    WINBOOL fApplyOverlay;
    int iGlowSize;
    DTT_CALLBACK_PROC pfnDrawTextCallback;
    LPARAM lParam;
} DTTOPTS, *PDTTOPTS;

enum {
   BP_PUSHBUTTON = 1,
   BP_RADIOBUTTON = 2,
   BP_CHECKBOX = 3,
   BP_GROUPBOX = 4,
   BP_USERBUTTON = 5
};

enum {
   RBS_UNCHECKEDNORMAL = 1,
   RBS_UNCHECKEDHOT = 2,
   RBS_UNCHECKEDPRESSED = 3,
   RBS_UNCHECKEDDISABLED = 4,
   RBS_CHECKEDNORMAL = 5,
   RBS_CHECKEDHOT = 6,
   RBS_CHECKEDPRESSED = 7,
   RBS_CHECKEDDISABLED = 8
};

static WNDPROC lpfnOldWndProcA = 0, lpfnOldWndProcB = 0;

static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcA );
}

static LRESULT APIENTRY SubClassFuncB( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProcB );
}

HB_FUNC( INITRADIOGROUP )
{
   HWND hbutton;
   int Style   = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON | WS_GROUP;
   int StyleEx = _OOHG_RTL_Status( hb_parl( 5 ) );

   if( hb_parl( 8 ) )
      Style = Style | BS_LEFTTEXT;

   hbutton = CreateWindowEx( StyleEx, "button", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProcA = (WNDPROC) SetWindowLongPtr( hbutton, GWL_WNDPROC, (LONG_PTR) SubClassFuncA );

   HWNDret( hbutton );
}

HB_FUNC( INITRADIOBUTTON )
{
   HWND hbutton;
   int Style   = hb_parni( 4 ) | BS_NOTIFY | WS_CHILD | BS_AUTORADIOBUTTON;
   int StyleEx = _OOHG_RTL_Status( hb_parl( 5 ) );

   if( hb_parl( 8 ) )
      Style = Style | BS_LEFTTEXT;

   hbutton = CreateWindowEx( StyleEx, "button", "", Style,
                             hb_parni( 2 ), hb_parni( 3 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   lpfnOldWndProcB = (WNDPROC) SetWindowLongPtr( hbutton, GWL_WNDPROC, (LONG_PTR) SubClassFuncB );

   HWNDret( hbutton );
}

typedef int (CALLBACK *CALL_CLOSETHEMEDATA )( HTHEME );
typedef int (CALLBACK *CALL_DRAWTHEMEBACKGROUND )( HTHEME, HDC, int, int, const RECT*, const RECT* );
typedef int (CALLBACK *CALL_DRAWTHEMEPARENTBACKGROUND )( HWND, HDC, RECT* );
typedef int (CALLBACK *CALL_DRAWTHEMETEXTEX )( HTHEME, HDC, int, int, LPCWSTR, int, DWORD, const RECT*, const DTTOPTS *pOptions );
typedef int (CALLBACK *CALL_DRAWTHEMETEXT )( HTHEME, HDC, int, int, LPCWSTR, int, DWORD, DWORD, const RECT* );
typedef int (CALLBACK *CALL_GETTHEMEBACKGROUNDCONTENTRECT )( HTHEME, HDC, int, int, const RECT*, RECT* );
typedef int (CALLBACK *CALL_GETTHEMEPARTSIZE )( HTHEME, HDC, int, int, const RECT*, THEMESIZE, SIZE* );
typedef int (CALLBACK *CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT )( HTHEME, int, int );
typedef int (CALLBACK *CALL_OPENTHEMEDATA )( HWND, LPCWSTR );

int TRadioItem_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, LPCSTR cCaption, BOOL bDrawThemeParentBackground, BOOL bLeftAlign )
{
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPNMCUSTOMDRAW pCustomDraw = (LPNMCUSTOMDRAW) lParam;
   CALL_CLOSETHEMEDATA dwProcCloseThemeData;
   CALL_DRAWTHEMEBACKGROUND dwProcDrawThemeBackground;
   CALL_DRAWTHEMEPARENTBACKGROUND dwProcDrawThemeParentBackground;
   CALL_DRAWTHEMETEXT dwProcDrawThemeText;
   CALL_DRAWTHEMETEXTEX dwProcDrawThemeTextEx;
   CALL_GETTHEMEBACKGROUNDCONTENTRECT dwProcGetThemeBackgroundContentRect;
   CALL_GETTHEMEPARTSIZE dwProcGetThemePartSize;
   CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT dwProcIsThemeBackgroundPartiallyTransparent;
   CALL_OPENTHEMEDATA dwProcOpenThemeData;
   DTTOPTS pOptions;
   HMODULE hInstDLL;
   HTHEME hTheme;
   int state_id, checkState, drawState;
   LONG_PTR style, state;
   RECT content_rect, aux_rect;
   SIZE s;
   static const int rb_states[2][5] =
   {
      { RBS_UNCHECKEDNORMAL, RBS_UNCHECKEDHOT, RBS_UNCHECKEDPRESSED, RBS_UNCHECKEDDISABLED, RBS_UNCHECKEDNORMAL },
      { RBS_CHECKEDNORMAL,   RBS_CHECKEDHOT,   RBS_CHECKEDPRESSED,   RBS_CHECKEDDISABLED,   RBS_CHECKEDNORMAL }
   };

   if( pCustomDraw->dwDrawStage == CDDS_PREERASE || pCustomDraw->dwDrawStage == CDDS_PREPAINT )
   {
      hInstDLL = LoadLibrary( "UXTHEME.DLL" );
      if( ! hInstDLL )
      {
         return CDRF_DODEFAULT;
      }

      dwProcCloseThemeData = (CALL_CLOSETHEMEDATA) GetProcAddress( hInstDLL, "CloseThemeData" );
      dwProcDrawThemeBackground = (CALL_DRAWTHEMEBACKGROUND) GetProcAddress( hInstDLL, "DrawThemeBackground" );
      dwProcDrawThemeParentBackground = (CALL_DRAWTHEMEPARENTBACKGROUND) GetProcAddress( hInstDLL, "DrawThemeParentBackground" );
      dwProcDrawThemeText = (CALL_DRAWTHEMETEXT) GetProcAddress( hInstDLL, "DrawThemeText" );
      dwProcDrawThemeTextEx = (CALL_DRAWTHEMETEXTEX) GetProcAddress( hInstDLL, "DrawThemeTextEx" );
      dwProcGetThemeBackgroundContentRect = (CALL_GETTHEMEBACKGROUNDCONTENTRECT) GetProcAddress( hInstDLL, "GetThemeBackgroundContentRect" );
      dwProcGetThemePartSize = (CALL_GETTHEMEPARTSIZE) GetProcAddress( hInstDLL, "GetThemePartSize" );
      dwProcIsThemeBackgroundPartiallyTransparent = (CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT) GetProcAddress( hInstDLL, "IsThemeBackgroundPartiallyTransparent" );
      dwProcOpenThemeData = (CALL_OPENTHEMEDATA) GetProcAddress( hInstDLL, "OpenThemeData" );

      if( ! ( dwProcCloseThemeData &&
              dwProcDrawThemeBackground &&
              dwProcDrawThemeParentBackground &&
              dwProcGetThemeBackgroundContentRect &&
              dwProcGetThemePartSize &&
              dwProcIsThemeBackgroundPartiallyTransparent &&
              dwProcOpenThemeData &&
              ( dwProcDrawThemeText || dwProcDrawThemeTextEx ) ) )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      hTheme = (HTHEME) ( dwProcOpenThemeData )( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
         FreeLibrary( hInstDLL );
         return CDRF_DODEFAULT;
      }

      /* determine control's state, note that the order of these tests is significant */
      style = GetWindowLongPtr( pCustomDraw->hdr.hwndFrom, GWL_STYLE );
      state = SendMessage( pCustomDraw->hdr.hwndFrom, BM_GETSTATE, 0, 0 );
      if( state & BST_CHECKED )
      {
         checkState = 1;
      }
      else
      {
         checkState = 0;
      }
      if( style & WS_DISABLED )
      {
         drawState = 3;
      }
      else if( state & BST_HOT )
      {
         drawState = 1;
      }
      else if( state & BST_FOCUS )
      {
         drawState = 4;
      }
      else if( state & BST_PUSHED )
      {
         drawState = 2;
      }
      else
      {
         drawState = 0;
      }
      state_id = rb_states[checkState][drawState];

      if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
      {
         if( bDrawThemeParentBackground )
         {
            if( ( dwProcIsThemeBackgroundPartiallyTransparent )( hTheme, BP_RADIOBUTTON, state_id ) )
            {
               /* pCustomDraw->rc is the item´s client area */
               ( dwProcDrawThemeParentBackground )( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
            }
         }

         ( dwProcCloseThemeData )( hTheme );
         FreeLibrary( hInstDLL );

         return CDRF_DODEFAULT;
      }

      /* get button size */
      ( dwProcGetThemePartSize )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, NULL, TS_TRUE, &s );

      /* get content rectangle */
      ( dwProcGetThemeBackgroundContentRect )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, &pCustomDraw->rc, &content_rect );

      aux_rect = pCustomDraw->rc;
      aux_rect.top = aux_rect.top + (content_rect.bottom - content_rect.top - s.cy) / 2;
      aux_rect.bottom = aux_rect.top + s.cy;
      if( bLeftAlign )
      {
         aux_rect.left = aux_rect.right - s.cx;
         content_rect.right = aux_rect.left - 3;      // Arbitrary margin between text and button
      }
      else
      {
         aux_rect.right = aux_rect.left + s.cx;
         content_rect.left = aux_rect.right + 3;      // Arbitrary margin between text and button
      }

      /* aux_rect is the rect of the item's button area */
      ( dwProcDrawThemeBackground )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, &aux_rect, NULL );

      if( strlen( cCaption ) > 0 )
      {
         if( dwProcDrawThemeTextEx )
         {
            /* paint caption */
            memset( &pOptions, 0, sizeof( DTTOPTS ) );
            pOptions.dwSize = sizeof( DTTOPTS );
            if( oSelf->lFontColor != -1 )
            {
               pOptions.dwFlags |= DTT_TEXTCOLOR;
               pOptions.crText = (COLORREF) oSelf->lFontColor;
            }
            ( dwProcDrawThemeTextEx )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, &content_rect, &pOptions );

            /* paint focus rectangle */
            if( state & BST_FOCUS )
            {
               aux_rect = content_rect;
               pOptions.dwFlags = DTT_CALCRECT;
               ( dwProcDrawThemeTextEx )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE | DT_CALCRECT, &aux_rect, &pOptions );
               if( bLeftAlign )
               {
                  aux_rect.right += 1;
               }
               else
               {
                  aux_rect.left -= 1;
                  aux_rect.right += 1;
               }
               DrawFocusRect( pCustomDraw->hdc, &aux_rect );
            }
         }
         else
         {
            /* paint caption */
            ( dwProcDrawThemeText )( hTheme, pCustomDraw->hdc, BP_RADIOBUTTON, state_id, AnsiToWide( cCaption ), -1, DT_VCENTER | DT_LEFT | DT_SINGLELINE, 0, &content_rect );

            /* paint focus rectangle */
            if( state & BST_FOCUS )
            {
               aux_rect = content_rect;
               if( bLeftAlign )
               {
                  aux_rect.right += 1;
               }
               else
               {
                  aux_rect.left -= 1;
                  aux_rect.right += 1;
               }
               DrawFocusRect( pCustomDraw->hdc, &aux_rect );
            }
         }
      }

      /* cleanup */
      ( dwProcCloseThemeData )( hTheme );
      FreeLibrary( hInstDLL );

      return CDRF_SKIPDEFAULT;
   }

   return CDRF_SKIPDEFAULT;
}

HB_FUNC( TRADIOITEM_NOTIFY_CUSTOMDRAW)
{
   hb_retni( TRadioItem_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), (LPARAM) hb_parnl( 2 ), (LPCSTR) hb_parc( 3 ), (BOOL) hb_parl( 4 ), (BOOL) hb_parl( 5 ) ) );
}

#pragma ENDDUMP
