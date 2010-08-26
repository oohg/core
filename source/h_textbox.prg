/*
 * $Id: h_textbox.prg,v 1.63 2010-08-26 20:00:55 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG textbox functions
 *
 * Copyright 2005-2010 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
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
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
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
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#include "oohg.ch"
#include "common.ch"
#include "i_windefs.ch"
#include "hbclass.ch"
#include "set.ch"
#include "hblang.ch"

CLASS TText FROM TLabel
   DATA Type            INIT "TEXT" READONLY
   DATA lSetting        INIT .F.
   DATA nMaxLength      INIT 0
   DATA lAutoSkip       INIT .F.
   DATA nOnFocusPos     INIT -2
   DATA nWidth          INIT 120
   DATA nHeight         INIT 24
   DATA OnTextFilled    INIT nil
   DATA nDefAnchor      INIT 13   // TopBottomRight

   METHOD Define
   METHOD Define2

   METHOD RefreshData
   METHOD Refresh             BLOCK { |Self| ::RefreshData() }
   METHOD SizePos
   METHOD Enabled             SETGET
   METHOD Visible             SETGET
   METHOD AddControl
   METHOD DeleteControl
   METHOD AdjustResize( nDivh, nDivw ) BLOCK { |Self,nDivh,nDivw| ::Super:AdjustResize( nDivh, nDivw, .T. ) }

   METHOD Value               SETGET
   METHOD SetFocus
   METHOD CaretPos            SETGET
   METHOD ReadOnly            SETGET
   METHOD MaxLength           SETGET
   METHOD DoAutoSkip
   METHOD Events_Command
   METHOD Events
   METHOD ControlArea         SETGET

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
               cFontName, nFontSize, cToolTip, nMaxLength, lUpper, lLower, ;
               lPassword, uLostFocus, uGotFocus, uChange, uEnter, right, ;
               HelpId, readonly, bold, italic, underline, strikeout, field, ;
               backcolor, fontcolor, invisible, notabstop, lRtl, lAutoSkip, ;
               lNoBorder, OnFocusPos, lDisabled, bValid, bAction, aBitmap, ;
               nBtnwidth, bAction2 ) CLASS TText
*-----------------------------------------------------------------------------*
Local nStyle := ES_AUTOHSCROLL, nStyleEx := 0

   nStyle += IF( HB_IsLogical( lUpper ) .AND. lUpper, ES_UPPERCASE, 0 ) + ;
             IF( HB_IsLogical( lLower ) .AND. lLower, ES_LOWERCASE, 0 )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
              cFontName, nFontSize, cToolTip, nMaxLength, lPassword, ;
              uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
              readonly, bold, italic, underline, strikeout, field, ;
              backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
              lAutoSkip, nStyleEx, lNoBorder, OnFocusPos, lDisabled, bValid, ;
              bAction, aBitmap, nBtnwidth, bAction2 )

Return Self

*-----------------------------------------------------------------------------*
METHOD Define2( cControlName, cParentForm, x, y, w, h, cValue, ;
                cFontName, nFontSize, cToolTip, nMaxLength, lPassword, ;
                uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
                readonly, bold, italic, underline, strikeout, field, ;
                backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
                lAutoSkip, nStyleEx, lNoBorder, OnFocusPos, lDisabled, ;
                bValid, bAction, aBitmap, nBtnwidth, bAction2 ) CLASS TText
*-----------------------------------------------------------------------------*
Local nControlHandle
local break

   // Assign STANDARD values to optional params.
   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   If HB_IsNumeric( nMaxLength ) .AND. nMaxLength >= 0
      ::nMaxLength := Int( nMaxLength )
   EndIf

   ASSIGN nStyle   VALUE nStyle   TYPE "N" DEFAULT 0
   ASSIGN nStyleEx VALUE nStyleEx TYPE "N" DEFAULT 0

   ::SetForm( cControlName, cParentForm, cFontName, nFontSize, FontColor, BackColor, .T., lRtl )

   // Style definition
   nStyle += ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             IF( HB_IsLogical( lPassword ) .AND. lPassword, ES_PASSWORD,  0 ) + ;
             IF( HB_IsLogical( right     ) .AND. right,     ES_RIGHT,     0 ) + ;
             IF( HB_IsLogical( readonly  ) .AND. readonly,  ES_READONLY,  0 )

   nStyleEx += IF( !HB_IsLogical( lNoBorder ) .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

   // Creates the control window.
   ::SetSplitBoxInfo( Break, )

   nControlHandle := InitTextBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::nMaxLength, ::lRtl, nStyleEx )

   ::Register( nControlHandle, cControlName, HelpId,, cToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::SetVarBlock( Field, cValue )

   ASSIGN ::OnLostFocus VALUE uLostFocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE uGotFocus  TYPE "B"
   ASSIGN ::OnChange    VALUE uChange    TYPE "B"
   ASSIGN ::OnEnter     VALUE uEnter     TYPE "B"
   ASSIGN ::postBlock   VALUE bValid     TYPE "B"
   ASSIGN ::lAutoSkip   VALUE lAutoSkip  TYPE "L"
   ASSIGN ::nOnFocusPos VALUE OnFocusPos TYPE "N"

   ASSIGN nBtnwidth     VALUE nBtnwidth  TYPE "N" DEFAULT 20
   IF ! HB_IsArray( aBitmap )
      aBitmap := { aBitmap, nil }
   ENDIF
   IF LEN( aBitmap ) < 2
      ASIZE( aBitmap, 2 )
   ENDIF

   IF HB_IsBlock( bAction )
      @ 2,::ClientWidth + 2 - nBtnwidth BUTTON 0 WIDTH nBtnwidth HEIGHT 100 ACTION EVAL( bAction )  OF ( Self ) PICTURE aBitmap[ 1 ]
   ENDIF

   IF HB_IsBlock( bAction2 )
      @ 2,::ClientWidth + 2 - nBtnwidth BUTTON 0 WIDTH nBtnwidth HEIGHT 100 ACTION EVAL( bAction2 ) OF ( Self ) PICTURE aBitmap[ 2 ]
   ENDIF

RETURN Self

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TText
*-----------------------------------------------------------------------------*
Local uValue
   IF HB_IsBlock( ::Block )
      uValue := EVAL( ::Block )
      If VALTYPE ( uValue ) $ 'CM'
         uValue := rtrim( uValue )
      EndIf
      ::Value := uValue
   ENDIF
   AEVAL( ::aControls, { |o| If( o:Container == nil, o:RefreshData(), ) } )
Return NIL

*------------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TText
*------------------------------------------------------------------------------*
LOCAL xRet
   xRet := ::Super:SizePos( Row, Col, Width, Height )
   AEVAL( ::aControls, { |o| o:Redraw() } )
Return xRet

*------------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TText
*------------------------------------------------------------------------------*
   IF HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      AEVAL( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF
RETURN ::Super:Enabled

*------------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TText
*------------------------------------------------------------------------------*
   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      IF lVisible
         AEVAL( ::aControls, { |o| o:Visible := o:Visible } )
      ELSE
         AEVAL( ::aControls, { |o| o:ForceHide() } )
      ENDIF
   ENDIF
RETURN ::Super:Visible

*------------------------------------------------------------------------------*
METHOD AddControl( oCtrl ) CLASS TText
*------------------------------------------------------------------------------*
LOCAL aRect
   ::Super:AddControl( oCtrl )
   oCtrl:Container := Self
   ::ControlArea := ::ControlArea + oCtrl:Width
   aRect := { 0, 0, 0, 0 }
   GetClientRect( ::hWnd, @aRect )
   oCtrl:Visible := oCtrl:Visible
   oCtrl:SizePos( 2, ::ClientWidth + 2,, ::ClientHeight )
   oCtrl:Anchor := ::nDefAnchor
Return Nil

*------------------------------------------------------------------------------*
METHOD DeleteControl( oCtrl ) CLASS TText
*------------------------------------------------------------------------------*
LOCAL nCount
   nCount := LEN( ::aControls )
   ::Super:DeleteControl( oCtrl )
   IF LEN( ::aControls ) < nCount
      ::ControlArea := ::ControlArea - oCtrl:Width
      AEVAL( ::aControls, { |o| IF( o:Col < oCtrl:Col + oCtrl:Width, o:Col += oCtrl:Width, ) } )
   ENDIF
Return Nil

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TText
*------------------------------------------------------------------------------*
Return ( ::Caption := IF( VALTYPE( uValue ) $ "CM" , RTrim( uValue ), NIL ) )

*------------------------------------------------------------------------------*
METHOD SetFocus() CLASS TText
*------------------------------------------------------------------------------*
Local uRet, nLen
   uRet := ::Super:SetFocus()
   If ::nOnFocusPos == -2
      SendMessage( ::hWnd, EM_SETSEL, 0, -1 )
   ElseIf ::nOnFocusPos == -1
      nLen := LEN( ::Caption )
      SendMessage( ::hWnd, EM_SETSEL, nLen, nLen )
   ElseIf ::nOnFocusPos >= 0
      SendMessage( ::hWnd, EM_SETSEL, ::nOnFocusPos, ::nOnFocusPos )
   EndIf
Return uRet

*------------------------------------------------------------------------------*
METHOD CaretPos( nPos ) CLASS TText
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( nPos )
      SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
   ENDIF
Return HiWord( SendMessage( ::hWnd, EM_GETSEL, 0, 0 ) )

*------------------------------------------------------------------------------*
METHOD ReadOnly( lReadOnly ) CLASS TText
*------------------------------------------------------------------------------*
   IF HB_IsLogical( lReadOnly )
      SendMessage( ::hWnd, EM_SETREADONLY, IF( lReadOnly, 1, 0 ), 0 )
   ENDIF
Return IsWindowStyle( ::hWnd, ES_READONLY )

*------------------------------------------------------------------------------*
METHOD MaxLength( nLen ) CLASS TText
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( nLen )
      ::nMaxLength := IF( nLen >= 1, nLen, 0 )
      SendMessage( ::hWnd, EM_LIMITTEXT, ::nMaxLength, 0 )
   ENDIF
Return SendMessage( ::hWnd, EM_GETLIMITTEXT, 0, 0 )

*------------------------------------------------------------------------------*
METHOD DoAutoSkip() CLASS TText
*------------------------------------------------------------------------------*
   If HB_IsBlock( ::OnTextFilled )
      ::DoEvent( ::OnTextFilled, "TEXTFILLED" )
   Else
      _SetNextFocus()
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TText
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   if Hi_wParam == EN_CHANGE
      If ::Transparent
         RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
      EndIf
      IF ::lSetting
         ::lSetting := .F.
      Else
         ::DoChange()
         If ::lAutoSkip .AND. ::nMaxLength > 0 .AND. ::CaretPos >= ::nMaxLength
            ::DoAutoSkip()
         EndIf
      EndIf
      Return nil

   elseif Hi_wParam == EN_KILLFOCUS
      Return ::DoLostFocus()

   elseif Hi_wParam == EN_SETFOCUS
      ::SetFocus()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )
      Return nil

   Endif

Return ::Super:Events_Command( wParam )

EXTERN INITTEXTBOX

#pragma BEGINDUMP
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITTEXTBOX )
{
   HWND hwnd;         // Handle of the parent window/form.
   HWND hedit;        // Handle of the child window/control.
   int StyleEx;

   StyleEx = hb_parni( 10 ) | _OOHG_RTL_Status( hb_parl( 9 ) );

   // Get the handle of the parent window/form.
   hwnd = HWNDparam( 1 );

   // Creates the child control.
   hedit = CreateWindowEx( StyleEx,
                           "EDIT",
                           "",
                           ( WS_CHILD | hb_parni( 7 ) ),
                           hb_parni( 3 ),
                           hb_parni( 4 ),
                           hb_parni( 5 ),
                           hb_parni( 6 ),
                           hwnd,
                           ( HMENU ) hb_parni( 2 ),
                           GetModuleHandle( NULL ),
                           NULL );

   if( hb_parni( 8 ) != 0 )
   {
      SendMessage( hedit, ( UINT ) EM_LIMITTEXT, ( WPARAM) hb_parni( 8 ), ( LPARAM ) 0 );
   }

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( hedit, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hedit );

}

#define s_Super s_TLabel

// oSelf->lAux[ 0 ] -> Client's area (width used by attached controls)

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TTEXT_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TText
// -----------------------------------------------------------------------------
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_NCCALCSIZE:
      {
         int iRet;
         RECT *rect2;
         POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

         iRet = DefWindowProc( hWnd, message, wParam, lParam );

         if( oSelf->lAux[ 0 ] )
         {

            rect2 = ( RECT * ) lParam;
            rect2->right = rect2->right - oSelf->lAux[ 0 ];
         }

         hb_retni( iRet );
         break;
      }

      case WM_NCHITTEST:
      {
         int iRet;

         iRet = DefWindowProc( hWnd, message, wParam, lParam );

         if( iRet == 0 )
         {
            iRet = -1;
         }

         hb_retni( iRet );
         break;
      }

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         hb_vmPushLong( ( LONG ) hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 4 );
         break;
	}
}

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TTEXT_CONTROLAREA )   // METHOD ControlArea( nWidth ) CLASS TText
// -----------------------------------------------------------------------------
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;

   if( ISNUM( 1 ) )
   {
      oSelf->lAux[ 0 ] = hb_parni( 1 );
      GetWindowRect( oSelf->hWnd, &rect );
      SetWindowPos( oSelf->hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOREDRAW | SWP_NOSIZE );
   }

   hb_retni( oSelf->lAux[ 0 ] );
}

#pragma ENDDUMP





CLASS TTextPicture FROM TText
   DATA Type           INIT "TEXTPICTURE" READONLY
   DATA lBritish       INIT .F.

   DATA cPicture       INIT ""
   DATA PictureFun     INIT ""
   DATA PictureFunShow INIT ""
   DATA PictureMask    INIT ""
   DATA PictureShow    INIT ""

   DATA ValidMask      INIT {}
   DATA ValidMaskShow  INIT {}
   DATA nDecimal       INIT 0
   DATA nDecimalShow   INIT 0
   DATA DataType       INIT "."
   DATA lInsert        INIT .T.
   DATA lFocused       INIT .F.
   DATA xUndo          INIT nil
   DATA cDateFormat    INIT nil
   DATA lToUpper       INIT .F.
   DATA lNumericScroll INIT .F.

   METHOD Define

   METHOD Value       SETGET
   METHOD Picture     SETGET
   METHOD Events
   METHOD KeyPressed
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( cControlName, cParentForm, nx, ny, nWidth, nHeight, uValue, ;
               cInputMask, cFontName, nFontSize, cToolTip, uLostFocus, ;
               uGotFocus, uChange, uEnter, right, HelpId, readonly, bold, ;
               italic, underline, strikeout, field, backcolor, fontcolor, ;
               invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos, ;
               lDisabled, bValid, lUpper, lLower, bAction, aBitmap, ;
               nBtnwidth, bAction2 ) CLASS TTextPicture
*-----------------------------------------------------------------------------*
Local nStyle := ES_AUTOHSCROLL, nStyleEx := 0

   nStyle += IF( HB_IsLogical( lUpper ) .AND. lUpper, ES_UPPERCASE, 0 ) + ;
             IF( HB_IsLogical( lLower ) .AND. lLower, ES_LOWERCASE, 0 )

   If uValue == nil
      uValue := ""
   ElseIf HB_IsNumeric( uValue )
      right := .T.
      ::lInsert := .F.
      ::lNumericScroll := .T.
   ElseIf HB_IsDate( uValue )
      ::lNumericScroll := .T.
   EndIf

   If ValType( cInputMask ) $ "CM"
      ::cPicture := cInputMask
   EndIf
   ::Picture( ::cPicture, uValue )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, uValue, ;
              cFontName, nFontSize, cToolTip, 0, .F., ;
              uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
              readonly, bold, italic, underline, strikeout, field, ;
              backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
              lAutoSkip, nStyleEx, lNoBorder, OnFocusPos, lDisabled, bValid, ;
              bAction, aBitmap, nBtnwidth, bAction2 )

Return Self

*------------------------------------------------------------------------------*
METHOD Picture( cInputMask, uValue ) CLASS TTextPicture
*------------------------------------------------------------------------------*
Local cType, cPicFun, cPicMask, nPos, nScroll, lOldCentury
   If VALTYPE( cInputMask ) $ "CM"
      IF uValue == nil
         uValue := ::Value
      ENDIF

      lOldCentury := __SETCENTURY()
      ::cDateFormat := SET( _SET_DATEFORMAT )
      cType := ValType( uValue )

      IF ! VALTYPE( cInputMask ) $ "CM"
         cInputMask := ""
      ENDIF
      ::lBritish := .F.
      ::lToUpper := .F.

      cPicFun := ""
      IF Left( cInputMask, 1 ) == "@"
         nPos := At( " ", cInputMask )
         IF nPos != 0
            cPicMask := Substr( cInputMask, nPos + 1 )
            cInputMask := Upper( Left( cInputMask, nPos - 1 ) )
         Else
            cPicMask := ""
            cInputMask := Upper( cInputMask )
         ENDIF

         DO WHILE "S" $ cInputMask
            nScroll := 0
            // It's automatic at textbox's width
            nPos := At( "S", cInputMask )
            cInputMask := Left( cInputMask, nPos - 1 ) + SubStr( cInputMask, nPos + 1 )
            DO WHILE Len( cInputMask ) >= nPos .AND. SubStr( cInputMask, nPos, 1 ) $ "0123456789"
               nScroll := ( nScroll * 10 ) + VAL( SubStr( cInputMask, nPos, 1 ) )
               cInputMask := Left( cInputMask, nPos - 1 ) + SubStr( cInputMask, nPos + 1 )
            ENDDO
            IF cType $ "CM" .AND. Empty( cPicMask ) .AND. nScroll > 0
               cPicMask := Replicate( "X", nScroll )
            ENDIF
         ENDDO

         IF "A" $ cInputMask
            IF cType $ "CM" .AND. EMPTY( cPicMask )
               cPicMask := Replicate( "A", Len( uValue ) )
            ENDIF
            cInputMask := StrTran( cInputMask, "A", "" )
         ENDIF

/*
         IF "B" $ cInputMask
            cPicFun += "B"
            cInputMask := StrTran( cInputMask, "B", "" )
         ENDIF
*/

         IF "2" $ cInputMask
            SET CENTURY OFF
            cInputMask := StrTran( cInputMask, "2", "" )
         ENDIF

         IF "4" $ cInputMask
            SET CENTURY ON
            cInputMask := StrTran( cInputMask, "4", "" )
         ENDIF

         ::cDateFormat := SET( _SET_DATEFORMAT )

         IF "C" $ cInputMask
            cPicFun += "C"
            cInputMask := StrTran( cInputMask, "C", "" )
         ENDIF

         IF "D" $ cInputMask
            cPicMask := ""
            cInputMask := StrTran( cInputMask, "D", "" )
         ENDIF

         IF "E" $ cInputMask
            ::lBritish := .T.
            If cType == "D"
               cPicMask := If( __SETCENTURY(), "dd/mm/yyyy", "dd/mm/yy" )
            ElseIf cType != "N"
               cPicMask := If( __SETCENTURY(), "99/99/9999", "99/99/99" )
            Endif
            cPicFun += "E"
            cInputMask := StrTran( cInputMask, "E", "" )
         ENDIF

         IF "K" $ cInputMask
            // Since all text is selected when textbox gets focus, it's automatic
            cInputMask := StrTran( cInputMask, "K", "" )
         ENDIF

         IF "R" $ cInputMask
            cPicFun += "R"
            cInputMask := StrTran( cInputMask, "R", "" )
         ENDIF

         IF "X" $ cInputMask
            cPicFun += "X"
            cInputMask := StrTran( cInputMask, "X", "" )
         ENDIF

         IF "Z" $ cInputMask
            cPicFun += "Z"
            cInputMask := StrTran( cInputMask, "Z", "" )
         ENDIF

         IF "(" $ cInputMask
            cPicFun += "("
            cInputMask := StrTran( cInputMask, "(", "" )
         ENDIF

         IF ")" $ cInputMask
            cPicFun += ")"
            cInputMask := StrTran( cInputMask, ")", "" )
         ENDIF

         IF "!" $ cInputMask
            ::lToUpper := .T.
            cPicFun += "!"
            IF cType $ "CM" .AND. EMPTY( cPicMask )
               cPicMask := Replicate( "!", Len( uValue ) )
            ENDIF
            cInputMask := StrTran( cInputMask, "!", "" )
         ENDIF

         IF ! cInputMask == "@"
            MsgOOHGError( "@...TEXTBOX: Wrong Format Definition" )
         ENDIF

         IF ! Empty( cPicFun )
            cPicFun := "@" + cPicFun + " "
         ENDIF

      Else
         cPicMask := cInputMask
      ENDIF

      IF Empty( cPicMask )
         DO CASE
            CASE cType $ "CM"
               cPicMask := Replicate( "X", Len( uValue ) )
            CASE cType $ "N"
               cPicMask := STR( uValue )
               nPos := At( ".", cPicMask )
               cPicMask := Replicate( "#", Len( cPicMask ) )
               IF nPos != 0
                  cPicMask := Left( cPicMask, nPos - 1 ) + "." + SubStr( cPicMask, nPos + 1 )
               ENDIF
            CASE cType $ "D"
               cPicMask := ::cDateFormat
            CASE cType $ "L"
               cPicMask := "L"
            OTHERWISE
               // Invalid data type
         ENDCASE
      EndIf

      If cType $ "D"
         ::cDateFormat := cPicMask
         cPicMask := StrTran( StrTran( StrTran( StrTran( StrTran( StrTran( cPicMask, "Y", "9" ), "y", "9" ), "M", "9" ), "m", "9" ), "D", "9" ), "d", "9" )
      EndIf

      ::PictureFunShow := cPicFun
      ::PictureFun     := IF( ::lBritish, "E", "" ) + IF( "R" $ cPicFun, "R", "" ) + IF( ::lToUpper, "!", "" )
      IF ! Empty( ::PictureFun )
         ::PictureFun := "@" + ::PictureFun + " "
      ENDIF
      ::PictureShow    := cPicMask
      ::PictureMask    := cPicMask
      ::DataType       := If( cType == "M", "C", cType )
      ::nDecimal       := If( cType == "N", AT( ".", cPicMask ), 0 )
      ::nDecimalShow   := If( cType == "N", AT( ".", cPicMask ), 0 )
      ::ValidMask      := ValidatePicture( cPicMask )
      ::ValidMaskShow  := ValidatePicture( cPicMask )

      If ::DataType == "N"
         ::PictureMask := StrTran( StrTran( StrTran( ::PictureMask, ",", "" ), "*", "9" ), "$", "9" )
         ::nDecimal    := AT( ".", ::PictureMask )
         ::ValidMask   := ValidatePicture( ::PictureMask )
      Endif

      ::cPicture := ::PictureFunShow + ::PictureShow
      ::Value := uValue
      __SETCENTURY( lOldCentury )
   EndIf

RETURN ::cPicture

STATIC FUNCTION ValidatePicture( cPicture )
Local aValid, nPos
Local cValidPictures := "ANX9#LY!anxly$*"
   aValid := ARRAY( Len( cPicture ) )
   FOR nPos := 1 TO Len( cPicture )
      aValid[ nPos ] := ( SubStr( cPicture, nPos, 1 ) $ cValidPictures )
   NEXT
Return aValid

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TTextPicture
*------------------------------------------------------------------------------*
Local cType, cAux, cDateFormat, lOldCentury
   If ! ValidHandler( ::hWnd )
      Return nil
   EndIf

   If ::DataType == "D"
      cDateFormat := SET( _SET_DATEFORMAT )
      lOldCentury := __SETCENTURY()
      __SETCENTURY( ( "YYYY" $ UPPER( ::cDateFormat ) ) )
      SET( _SET_DATEFORMAT, ::cDateFormat )
   EndIf

   If PCount() > 0
      cType := ValType( uValue )
      cType := If( cType == "M", "C", cType )
      If cType == ::DataType
         If cType == "D"
            cAux := Transform( uValue, "@D" )
            If LEN( cAux ) < LEN( ::cDateFormat )
               cAux := cAux + SPACE( LEN( ::cDateFormat ) - LEN( cAux ) )
            EndIf
         ElseIf ::lFocused
            cAux := Transform( uValue, ::PictureFun + ::PictureMask )
            If LEN( cAux ) < LEN( ::PictureMask )
               cAux := cAux + SPACE( LEN( ::PictureMask ) - LEN( cAux ) )
            EndIf
         Else
            cAux := Transform( uValue, ::PictureFunShow + ::PictureShow )
            If LEN( cAux ) != LEN( ::PictureShow )
               cAux := PADR( cAux, LEN( ::PictureShow ) )
            EndIf
         EndIf
         ::Caption := cAux
      Else
         // Wrong data types
      EndIf
   EndIf
   cType := ::DataType

   // Removes mask
   DO CASE
      CASE cType == "C"
         uValue := If( ( "R" $ ::PictureFun ), xUnTransform( Self, ::Caption ), ::Caption )
      CASE cType == "N"
         uValue := VAL( StrTran( xUnTransform( Self, ::Caption ), " ", "" ) )
      CASE cType == "D"
         uValue := CTOD( ::Caption )
      CASE cType == "L"
         uValue := ( Left( xUnTransform( Self, ::Caption ), 1 ) $ "YT" + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 1 ) )
      OTHERWISE
         // Wrong data type
         uValue := NIL
   ENDCASE

   If ::DataType == "D"
      __SETCENTURY( lOldCentury )
      SET( _SET_DATEFORMAT, cDateFormat )
   EndIf

Return uValue

STATIC FUNCTION xUnTransform( Self, cCaption )
Local cRet
   If ::lFocused
      cRet := _OOHG_UnTransform( cCaption, ::PictureFun + ::PictureMask, ::DataType )
   Else
      cRet := _OOHG_UnTransform( cCaption, ::PictureFunShow + ::PictureShow, ::DataType )
   EndIf
Return cRet

#pragma BEGINDUMP
#undef s_Super
#define s_Super s_TText

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TTEXTPICTURE_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TTextPicture
// -----------------------------------------------------------------------------
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_CHAR:
      case WM_PASTE:
      case WM_KEYDOWN:
      case WM_LBUTTONDOWN:
      case WM_UNDO:
         if( ( GetWindowLong( hWnd, GWL_STYLE ) & ES_READONLY ) == 0 )
         {
            HB_FUNCNAME( TTEXTPICTURE_EVENTS2 )();
            break;
         }

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         hb_vmPushLong( ( LONG ) hWnd );
         hb_vmPushLong( message );
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmSend( 4 );
         break;
	}
}
#pragma ENDDUMP

FUNCTION TTextPicture_Events2( hWnd, nMsg, wParam, lParam )
Local Self := QSelf()
Local nPos, nPos1, nPos2, cText
Local aValidMask := ::ValidMask

   If nMsg == WM_CHAR .AND. wParam >= 32
      nPos := SendMessage( ::hWnd, EM_GETSEL , 0 , 0 )
      nPos1 := LoWord( nPos )
      nPos2 := HiWord( nPos )
      cText := ::Caption
      nPos := nPos1 + 1
      cText := TTextPicture_Clear( cText, nPos, nPos2 - nPos1, aValidMask, ::lInsert )
      IF TTextPicture_Events2_Key( Self, @cText, @nPos, CHR( wParam ), aValidMask, ::PictureMask, ::lInsert )
         ::Caption := cText
         If ! ::lNumericScroll
            Do While nPos < Len( aValidMask ) .AND. ! aValidMask[ nPos + 1 ]
               nPos++
            EndDo
         EndIf
         SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      EndIf
      If ::lAutoSkip .AND. nPos >= LEN( aValidMask )
         ::DoAutoSkip()
      EndIf
      Return 1

   ElseIf nMsg == WM_KEYDOWN .AND. wParam == VK_END .AND. GetKeyFlagState() == 0
      cText := ::Caption
      nPos := Len( aValidMask )
      DO WHILE nPos > 0 .AND. ( ! aValidMask[ nPos ] .OR. SubStr( cText, nPos, 1 ) == " " )
         nPos--
      ENDDO
      SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      Return 1

   ElseIf nMsg == WM_PASTE
      nPos := SendMessage( ::hWnd, EM_GETSEL, 0, 0 )
      nPos1 := LoWord( nPos )
      nPos2 := HiWord( nPos )
      cText := ::Caption
      nPos := nPos1
      cText := TTextPicture_Clear( cText, nPos + 1, nPos2 - nPos1, aValidMask, ::lInsert )
      IF TTextPicture_Events2_String( Self, @cText, @nPos, GetClipboardText(), aValidMask, ::PictureMask, ::lInsert )
         ::Caption := cText
         SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      ENDIF
      // Must ::lAutoSkip works when PASTE?
      // If ::lAutoSkip .AND. nPos >= LEN( aValidMask )
      //    ::DoAutoSkip()
      // EndIf
      Return 1

   ElseIf nMsg == WM_LBUTTONDOWN
      If ! ::lFocused
         ::SetFocus()
         ::xUndo := ::Value
         Return 1
      EndIf

   ElseIf nMsg == WM_UNDO .OR. ;
          ( nMsg == WM_KEYDOWN .AND. wParam == VK_Z .AND. GetKeyFlagState() == MOD_CONTROL )
      cText := ::Value
      ::Value := ::xUndo
      ::xUndo := cText
      If ::lFocused
         ::SetFocus()
      EndIf
      Return 1

   Endif
Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*------------------------------------------------------------------------------*
METHOD KeyPressed( cString, nPos ) CLASS TTextPicture
*------------------------------------------------------------------------------*
   If ! VALTYPE( cString ) $ "CM"
      cString := ""
   EndIf
   If ! HB_ISNUMERIC( nPos ) .OR. nPos < -2
      nPos := ::CaretPos
   ElseIf nPos < 0
      nPos := LEN( ::Caption )
   EndIf
RETURN TTextPicture_Events2_String( Self, ::Caption, nPos, cString, ::ValidMask, ::PictureMask, ::lInsert )

STATIC FUNCTION TTextPicture_Events2_Key( Self, cText, nPos, cChar, aValidMask, cPictureMask, lInsert )
Local lChange := .F., nPos1, cMask
   If ::nDecimal != 0 .AND. cChar $ if( ::lBritish, ",.", "." )
      cText := xUnTransform( Self, cText )
      nPos1 := IF( LEFT( LTRIM( cText ), 1 ) == "-", 1, 0 )
      cText := Transform( VAL( StrTran( cText, " ", "" ) ), if( ::lBritish, "@E ", "" ) + cPictureMask )
      If nPos1 == 1 .AND. LEFT( cText, 1 ) == " " .AND. ! "-" $ cText
         nPos1 := LEN( cText ) - LEN( LTRIM( cText ) )
         cText := LEFT( cText, nPos1 - 1 ) + "-" + SUBSTR( cText, nPos1 + 1 )
      EndIf
      nPos := ::nDecimal
      Return .T.
   Endif
   If ::lNumericScroll .AND. nPos > 1 .AND. aValidMask[ nPos - 1 ]
      If nPos > Len( cPictureMask ) .OR. ! aValidMask[ nPos ]
         nPos1 := nPos
         Do While nPos1 > 1 .AND. aValidMask[ nPos1 - 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
            nPos1--
         EndDo
         If aValidMask[ nPos1 ] .AND. SubStr( cText, nPos1, 1 ) == " "
            cText := Left( cText, nPos1 - 1 ) + SubStr( cText, nPos1 + 1, nPos - nPos1 - 1 ) + " " + SubStr( cText, nPos )
            nPos--
         EndIf
      EndIf
   EndIf
   Do While nPos <= Len( cPictureMask ) .AND. ! aValidMask[ nPos ]
      nPos++
   EndDo
   IF nPos <= Len( cPictureMask )
      cMask := Substr( cPictureMask, nPos, 1 )
      IF ::lToUpper .OR. cMask $ "!lLyY"
         cChar := Upper( cChar )
      ENDIF
      IF ( cMask $ "Nn"  .AND. ( IsAlpha( cChar ) .OR. IsDigit( cChar ) .OR. cChar $ " " )  ) .OR. ;
         ( cMask $ "Aa"  .AND. ( IsAlpha( cChar ) .OR. cChar == " " ) ) .OR. ;
         ( cMask $ "#$*" .AND. ( IsDigit( cChar ) .OR. cChar == "-" ) ) .OR. ;
         ( cMask $ "9"   .AND. ( IsDigit( cChar ) .OR. ( cChar == "-" .AND. ::DataType == "N" ) ) ) .OR. ;
         ( cMask $ "Ll"  .AND. cChar $ ( "TFYN" + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 1 ) + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 2 ) ) ) .OR. ;
         ( cMask $ "Yy"  .AND. cChar $ ( "YN"   + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 1 ) + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 2 ) ) ) .OR. ;
           cMask $ "Xx!"
         If ::lNumericScroll
            If SubStr( cText, nPos, 1 ) == " "
               cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
            Else
               nPos1 := nPos
               Do While nPos1 < Len( cPictureMask ) .AND. aValidMask[ nPos1 + 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
                  nPos1++
               EndDo
               If SubStr( cText, nPos1, 1 ) == " "
                  cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos, nPos1 - nPos ) + SubStr( cText, nPos1 + 1 )
               Else
                  nPos1 := nPos
                  Do While nPos1 > 1 .AND. aValidMask[ nPos1 - 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
                     nPos1--
                  EndDo
                  If SubStr( cText, nPos1, 1 ) == " "
                     cText := Left( cText, nPos1 - 1 ) + SubStr( cText, nPos1 + 1, nPos - nPos1 - 1 ) + cChar + SubStr( cText, nPos )
                     nPos--
                  Else
                     cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
                  EndIf
               EndIf
            EndIf
         ElseIf lInsert
            nPos1 := nPos
            DO WHILE nPos1 < Len( cPictureMask ) .AND. aValidMask[ nPos1 + 1 ]
               nPos1++
            ENDDO
            cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos, nPos1 - nPos ) + SubStr( cText, nPos1 + 1 )
         Else
            cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
         Endif
         lChange := .T.
      Else
         nPos--
      ENDIF
   ENDIF
Return lChange

STATIC FUNCTION TTextPicture_Events2_String( Self, cText, nPos, cString, aValidMask, cPictureMask, lInsert )
Local lChange := .F.
   DO WHILE Len( cString ) > 0 .AND. nPos < Len( cPictureMask )
      nPos++
      IF ! aValidMask[ nPos ] .AND. Left( cString, 1 ) == SubStr( cPictureMask, nPos, 1 )
         cText := Left( cText, nPos - 1 ) + Left( cString, 1 ) + SubStr( cText, nPos + 1 )
         lChange := .T.
      Else
         lChange := TTextPicture_Events2_Key( Self, @cText, @nPos, Left( cString, 1 ), aValidMask, cPictureMask, lInsert ) .OR. lChange
      ENDIF
      cString := SubStr( cString, 2 )
   ENDDO
Return lChange

STATIC FUNCTION TTextPicture_Clear( cText, nPos, nCount, aValidMask, lInsert )
Local nClear, nBase
   nCount := Max( Min( nCount, ( LEN( aValidMask ) - nPos + 1 ) ), 0 )
   IF lInsert
      DO WHILE nCount > 0
         // Skip non-template characters
         DO WHILE nCount > 0 .AND. ! aValidMask[ nPos ]
            nPos++
            nCount--
         ENDDO
         // Count how many blank spaces
         nClear := 0
         nBase := nPos - 1
         DO WHILE nCount > 0 .AND. aValidMask[ nPos ]
            nPos++
            nCount--
            nClear++
         ENDDO
         IF nCount > 0
            // There's a non-template character
            cText := Left( cText, nBase ) + Space( nClear ) + SubStr( cText, nPos )
         ElseIf nClear != 0
            // The clear area is out of the count's range
            DO WHILE nPos <= LEN( aValidMask ) .AND. aValidMask[ nPos ]
               nPos++
            ENDDO
            cText := Left( cText, nBase ) + SubStr( cText, nBase + nClear + 1, nPos - nBase - nClear - 1 ) + Space( nClear ) + SubStr( cText, nPos )
         ENDIF
      ENDDO
   Else
      DO WHILE nCount > 0
         IF aValidMask[ nPos ]
            cText := Left( cText, nPos - 1 ) + " " + SubStr( cText, nPos + 1 )
         ENDIF
         nPos++
         nCount--
      ENDDO
   ENDIF
Return cText

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TTextPicture
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
Local cText, nPos, nPos2, cAux
Local cPictureMask, aValidMask

   if Hi_wParam == EN_CHANGE
      cText := ::Caption
      cPictureMask := ::PictureMask
      IF Len( cText ) != Len( cPictureMask ) .AND. ! ::lSetting .AND. ::lFocused
         aValidMask := ::ValidMask
         nPos := HiWord( SendMessage( ::hWnd, EM_GETSEL , 0 , 0 ) )
         IF Len( cText ) > Len( cPictureMask )
            nPos2 := Len( cPictureMask ) - ( Len( cText ) - nPos )
            cAux := SubStr( cText, nPos2 + 1, nPos - nPos2 )
            cText := Left( cText, nPos2 ) + SubStr( cText, nPos + 1 )
            TTextPicture_Events2_String( Self, @cText, @nPos2, cAux, aValidMask, cPictureMask, .F. )
         Else
            IF nPos > 0 .AND. nPos < Len( cPictureMask ) .AND. ! aValidMask[ nPos + 1 ]
               nPos--
            ENDIF
            nPos2 := nPos
            nPos := Len( cPictureMask ) - Len( cText )
            cText := Left( cText, nPos2 ) + Space( nPos ) + SubStr( cText, nPos2 + 1 )
            cText := TTextPicture_Clear( cText, nPos2 + 1, nPos, aValidMask, ::lInsert )
         ENDIF
         FOR nPos := 1 TO Len( cPictureMask )
            IF ! aValidMask[ nPos ]
               cAux := SubStr( cPictureMask, nPos, 1 )
               IF cAux $ ",." .AND. ::lBritish
                  cAux := if( cAux == ",", ".", "," )
               ENDIF
               cText := Left( cText, nPos - 1 ) + cAux + SubStr( cText, nPos + 1 )
            Endif
         NEXT
         ::Caption := cText
         SendMessage( ::hWnd, EM_SETSEL , nPos2, nPos2 )
      ENDIF

   elseif Hi_wParam == EN_KILLFOCUS
      cText := ::Value
      ::lFocused := .F.
      ::lSetting := .T.
      ::Value := cText

   elseif Hi_wParam == EN_SETFOCUS
      cText := ::Value
      ::lFocused := .T.
      ::lSetting := .T.
      ::Value := cText
      ::xUndo := ::Value

   Endif

Return ::Super:Events_Command( wParam )





*-----------------------------------------------------------------------------*
CLASS TTextNum FROM TText
*-----------------------------------------------------------------------------*
   DATA Type          INIT "NUMTEXT" READONLY

   METHOD Define
   METHOD Value       SETGET
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
               cFontName, nFontSize, cToolTip, nMaxLength, lUpper, lLower, ;
               lPassword, uLostFocus, uGotFocus, uChange , uEnter , right  , ;
               HelpId, readonly, bold, italic, underline, strikeout, field , ;
               backcolor , fontcolor , invisible , notabstop, lRtl, lAutoSkip, ;
               lNoBorder, OnFocusPos, lDisabled, bValid, bAction, aBitmap, ;
               nBtnwidth, bAction2 ) CLASS TTextNum
*-----------------------------------------------------------------------------*
Local nStyle := ES_NUMBER + ES_AUTOHSCROLL, nStyleEx := 0

   Empty( lUpper )
   Empty( lLower )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
              cFontName, nFontSize, cToolTip, nMaxLength, lPassword, ;
              uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
              readonly, bold, italic, underline, strikeout, field, ;
              backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
              lAutoSkip, nStyleEx, lNoBorder, OnFocusPos, lDisabled, bValid, ;
              bAction, aBitmap, nBtnwidth, bAction2 )

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TTextNum
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( uValue )
      uValue := Int( uValue )
      ::Caption := AllTrim( Str( uValue ) )
   ELSE
      uValue := Int( Val( ::Caption ) )
   ENDIF
RETURN uValue

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TTextNum
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
Local cText, nPos, nCursorPos, lChange

   if Hi_wParam == EN_CHANGE
      nCursorPos := HiWord( SendMessage( ::hWnd, EM_GETSEL , 0 , 0 ) )
      lChange := .F.
      cText := ::Caption
      nPos := 1
      DO WHILE nPos <= Len( cText )
         IF IsDigit( SubStr( cText, nPos, 1 ) )
            nPos++
         Else
            cText := Left( cText, nPos - 1 ) + SubStr( cText, nPos + 1 )
            lChange := .T.
            IF nCursorPos >= nPos
               nCursorPos--
            ENDIF
         ENDIF
      ENDDO

      IF lChange
         ::Caption := cText
         SendMessage( ::hWnd, EM_SETSEL, nCursorPos, nCursorPos )
      ENDIF
   EndIf

Return ::Super:Events_Command( wParam )





*-----------------------------------------------------------------------------*
FUNCTION DefineTextBox( cControlName, cParentForm, x, y, Width, Height, ;
                        Value, cFontName, nFontSize, cToolTip, nMaxLength, ;
                        lUpper, lLower, lPassword, uLostFocus, uGotFocus, ;
                        uChange, uEnter, right, HelpId, readonly, bold, ;
                        italic, underline, strikeout, field, backcolor, ;
                        fontcolor, invisible, notabstop, lRtl, lAutoSkip, ;
                        lNoBorder, OnFocusPos, lDisabled, bValid, ;
                        date, numeric, inputmask, format, subclass, bAction, ;
                        aBitmap, nBtnwidth, bAction2 )
*-----------------------------------------------------------------------------*
Local Self, lInsert

   // If format is specified, inputmask is enabled
   If VALTYPE( format ) $ "CM"
      If VALTYPE( inputmask ) $ "CM"
         inputmask := "@" + format + " " + inputmask
      Else
         inputmask := "@" + format
      EndIf
   EndIf

   lInsert := nil

   // Checks for date textbox
   If ( HB_IsLogical( date ) .AND. date ) .OR. HB_IsDate( value )
      lInsert := .F.
      numeric := .F.
      If VALTYPE( Value ) $ "CM"
         Value := CTOD( Value )
      ElseIf !HB_IsDate( Value )
         Value := STOD( "" )
      EndIf
      If ! VALTYPE( inputmask ) $ "CM"
         inputmask := "@D"
      EndIf
   EndIf

   // Checks for numeric textbox
   If ! HB_IsLogical( numeric )
      numeric := .F.
   ElseIf numeric
      lInsert := .F.
      If VALTYPE( Value ) $ "CM"
         Value := VAL( Value )
      ElseIf ! HB_IsNumeric( Value )
         Value := 0
      EndIf
   EndIf

   If VALTYPE( inputmask ) $ "CM"
      // If inputmask is defined, it's TTextPicture()
      Self := _OOHG_SelectSubClass( TTextPicture(), subclass )
      ASSIGN ::lInsert VALUE lInsert TYPE "L"
      ::Define( cControlName, cParentForm, x, y, width, height, value, ;
                inputmask, cFontname, nFontsize, cTooltip, uLostfocus, ;
                uGotfocus, uChange, uEnter, right, HelpId, readonly, bold, ;
                italic, underline, strikeout, field, backcolor, fontcolor, ;
                invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos, ;
                lDisabled, bValid, lUpper, lLower, bAction, aBitmap, ;
                nBtnwidth, bAction2 )
   Else
      Self := _OOHG_SelectSubClass( iif( numeric, TTextNum(), TText() ), subclass )
      ::Define( cControlName, cParentForm, x, y, Width, Height, Value, ;
                cFontName, nFontSize, cToolTip, nMaxLength, lUpper, lLower, ;
                lPassword, uLostFocus, uGotFocus, uChange, uEnter, right, ;
                HelpId, readonly, bold, italic, underline, strikeout, field, ;
                backcolor, fontcolor, invisible, notabstop, lRtl, lAutoSkip, ;
                lNoBorder, OnFocusPos, lDisabled, bValid, bAction, aBitmap, ;
                nBtnwidth, bAction2 )
   EndIf
Return Self
