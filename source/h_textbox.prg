/*
* $Id: h_textbox.prg $
*/
/*
* ooHG source code:
* TextBox control
* Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
* https://oohg.github.io/
* Portions of this project are based upon Harbour MiniGUI library.
* Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
* Portions of this project are based upon Harbour GUI framework for Win32.
* Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
* Copyright 2001 Antonio Linares <alinares@fivetech.com>
* Portions of this project are based upon Harbour Project.
* Copyright 1999-2017, https://harbour.github.io/
*/
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this software; see the file LICENSE.txt. If not, write to
* the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
* As a special exception, the ooHG Project gives permission for
* additional uses of the text contained in its release of ooHG.
* The exception is that, if you link the ooHG libraries with other
* files to produce an executable, this does not by itself cause the
* resulting executable to be covered by the GNU General Public License.
* Your use of that executable is in no way restricted on account of
* linking the ooHG library code into it.
* This exception does not however invalidate any other reasons why
* the executable file might be covered by the GNU General Public License.
* This exception applies only to the code released by the ooHG
* Project under the name ooHG. If you copy code from other
* ooHG Project or Free Software Foundation releases into a copy of
* ooHG, as the General Public License permits, the exception does
* not apply to the code that you add in this way. To avoid misleading
* anyone as to the status of such modified files, you must delete
* this exception notice from them.
* If you write modifications of your own for ooHG, it is your choice
* whether to permit this exception to apply to your modifications.
* If you do not wish that, delete this exception notice.
*/

#include "oohg.ch"
#include "common.ch"
#include "i_windefs.ch"
#include "hbclass.ch"
#include "set.ch"
#include "hblang.ch"

CLASS TText FROM TLabel

   DATA Type                      INIT "TEXT" READONLY
   DATA lSetting                  INIT .F.
   DATA nMaxLength                INIT 0
   DATA lAutoSkip                 INIT .F.
   DATA nOnFocusPos               INIT -2
   DATA nWidth                    INIT 120
   DATA nHeight                   INIT 24
   DATA OnTextFilled              INIT Nil
   DATA nDefAnchor                INIT 13   // TopBottomRight
   DATA bWhen                     INIT Nil
   DATA When_Processed            INIT .F.
   DATA When_Procesing            INIT .F.
   DATA lInsert                   INIT .T.
   DATA lFocused                  INIT .F.
   DATA xUndo                     INIT Nil
   DATA lPrevUndo                 INIT .F.
   DATA xPrevUndo                 INIT Nil
   DATA nInsertType               INIT 0
   DATA oButton1                  INIT Nil
   DATA oButton2                  INIT Nil

   METHOD Define
   METHOD Define2
   METHOD RefreshData
   METHOD Refresh                      BLOCK { |Self| ::RefreshData() }
   METHOD SizePos
   METHOD Enabled                      SETGET
   METHOD Visible                      SETGET
   METHOD AddControl
   METHOD DeleteControl
   METHOD AdjustResize( nDivh, nDivw ) BLOCK { |Self,nDivh,nDivw| ::Super:AdjustResize( nDivh, nDivw, .T. ) }
   METHOD Value                        SETGET
   METHOD SetFocus
   METHOD CaretPos                     SETGET
   METHOD ReadOnly                     SETGET
   METHOD MaxLength                    SETGET
   METHOD DoAutoSkip
   METHOD Events_Command
   METHOD Events
   METHOD ControlArea                  SETGET
   METHOD ScrollCaret                  BLOCK { |Self| SendMessage( ::hWnd, EM_SCROLLCARET, 0, 0 ) }
   METHOD GetSelection
   METHOD SetSelection
   METHOD GetSelText
   METHOD InsertStatus                 SETGET
   METHOD GetLine
   METHOD GetLineIndex( nLine )        BLOCK { |Self,nLine| SendMessage( ::hWnd, EM_LINEINDEX, nLine, 0 ) }
   METHOD GetFirstVisibleLine          BLOCK { |Self| SendMessage( ::hWnd, EM_GETFIRSTVISIBLELINE, 0, 0 ) }
   METHOD GetLineCount                 BLOCK { |Self| SendMessage( ::hWnd, EM_GETLINECOUNT, 0, 0 ) }
   METHOD GetLineFromChar( nChar )
   METHOD GetCurrentLine               BLOCK { |Self| ::GetLineFromChar( -1 ) }
   METHOD GetLineLength( nLine )       BLOCK { |Self,nLine| SendMessage( ::hWnd, EM_LINELENGTH, ::GetLineIndex( nLine ), 0 ) }
   METHOD GetLastVisibleLine
   METHOD GetCharFromPos
   METHOD GetRect

   ENDCLASS

METHOD Define( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
      cFontName, nFontSize, cToolTip, nMaxLength, lUpper, lLower, ;
      lPassword, uLostFocus, uGotFocus, uChange, uEnter, right, ;
      HelpId, readonly, bold, italic, underline, strikeout, field, ;
      backcolor, fontcolor, invisible, notabstop, lRtl, lAutoSkip, ;
      lNoBorder, OnFocusPos, lDisabled, bValid, bAction, aBitmap, ;
      nBtnwidth, bAction2, bWhen, lCenter, OnTextFilled, nInsType ) CLASS TText

   LOCAL nStyle := ES_AUTOHSCROLL, nStyleEx := 0

   nStyle += If( HB_IsLogical( lUpper ) .AND. lUpper, ES_UPPERCASE, 0 ) + ;
      If( HB_IsLogical( lLower ) .AND. lLower, ES_LOWERCASE, 0 )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
      cFontName, nFontSize, cToolTip, nMaxLength, lPassword, ;
      uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
      readonly, bold, italic, underline, strikeout, field, ;
      backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
      lAutoSkip, nStyleEx, lNoBorder, OnFocusPos, lDisabled, bValid, ;
      bAction, aBitmap, nBtnwidth, bAction2, bWhen, lCenter, ;
      OnTextFilled, nInsType )

   RETURN Self

METHOD Define2( cControlName, cParentForm, x, y, w, h, cValue, ;
      cFontName, nFontSize, cToolTip, nMaxLength, lPassword, ;
      uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
      readonly, bold, italic, underline, strikeout, field, ;
      backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
      lAutoSkip, nStyleEx, lNoBorder, OnFocusPos, lDisabled, ;
      bValid, bAction, aBitmap, nBtnwidth, bAction2, bWhen, ;
      lCenter, OnTextFilled, nInsType ) CLASS TText

   LOCAL nControlHandle
   LOCAL break := Nil

   // Assign STANDARD values to optional params.
   ASSIGN ::nCol         VALUE x        TYPE "N"
   ASSIGN ::nRow         VALUE y        TYPE "N"
   ASSIGN ::nWidth       VALUE w        TYPE "N"
   ASSIGN ::nHeight      VALUE h        TYPE "N"
   ASSIGN ::bWhen        VALUE bWhen    TYPE "B"
   ASSIGN ::nInsertType  VALUE nInsType TYPE "N"

   IF HB_IsNumeric( nMaxLength ) .AND. nMaxLength >= 0
      ::nMaxLength := Int( nMaxLength )
   ENDIF

   ASSIGN nStyle   VALUE nStyle   TYPE "N" DEFAULT 0
   ASSIGN nStyleEx VALUE nStyleEx TYPE "N" DEFAULT 0

   ::SetForm( cControlName, cParentForm, cFontName, nFontSize, FontColor, BackColor, .T., lRtl )

   IF HB_IsLogical( lCenter ) .AND. lCenter
      right := .F.
   ELSE
      lCenter := .F.
   ENDIF

   // Style definition
   nStyle += ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
      If( HB_IsLogical( lPassword ) .AND. lPassword, ES_PASSWORD,  0 ) + ;
      If( HB_IsLogical( right     ) .AND. right,     ES_RIGHT,     0 ) + ;
      If( HB_IsLogical( lCenter   ) .AND. lCenter,   ES_CENTER,    0 ) + ;
      If( HB_IsLogical( readonly  ) .AND. readonly,  ES_READONLY,  0 )

   nStyleEx += If( !HB_IsLogical( lNoBorder ) .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

   // Creates the control window.
   ::SetSplitBoxInfo( Break, )

   nControlHandle := InitTextBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, ::nMaxLength, ::lRtl, nStyleEx )

   ::Register( nControlHandle, cControlName, HelpId,, cToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::SetVarBlock( Field, cValue )

   ASSIGN ::OnLostFocus  VALUE uLostFocus   TYPE "B"
   ASSIGN ::OnGotFocus   VALUE uGotFocus    TYPE "B"
   ASSIGN ::OnChange     VALUE uChange      TYPE "B"
   ASSIGN ::OnEnter      VALUE uEnter       TYPE "B"
   ASSIGN ::OnTextFilled VALUE OnTextFilled TYPE "B"
   ASSIGN ::postBlock    VALUE bValid       TYPE "B"
   ASSIGN ::lAutoSkip    VALUE lAutoSkip    TYPE "L"
   ASSIGN ::nOnFocusPos  VALUE OnFocusPos   TYPE "N"
   ASSIGN nBtnwidth      VALUE nBtnwidth    TYPE "N" DEFAULT 20

   IF ! HB_IsArray( aBitmap )
      aBitmap := { aBitmap, Nil }
   ENDIF
   IF Len( aBitmap ) < 2
      aSize( aBitmap, 2 )
   ENDIF

   IF HB_IsBlock( bAction )
      IF Empty( aBitmap[ 1 ] )
         @ 2,::ClientWidth + 2 - nBtnwidth BUTTON 0 WIDTH nBtnwidth HEIGHT 100 ACTION Eval( bAction ) OF ( Self ) CAPTION '...' OBJ ::oButton1
      ELSE
         @ 2,::ClientWidth + 2 - nBtnwidth BUTTON 0 WIDTH nBtnwidth HEIGHT 100 ACTION Eval( bAction ) OF ( Self ) PICTURE aBitmap[ 1 ] OBJ ::oButton1
      ENDIF
   ENDIF

   IF HB_IsBlock( bAction2 )
      IF Empty( aBitmap[ 2 ] )
         @ 2,::ClientWidth + 2 - nBtnwidth BUTTON 0 WIDTH nBtnwidth HEIGHT 100 ACTION Eval( bAction2 ) OF ( Self ) CAPTION '...' OBJ ::oButton2
      ELSE
         @ 2,::ClientWidth + 2 - nBtnwidth BUTTON 0 WIDTH nBtnwidth HEIGHT 100 ACTION Eval( bAction2 ) OF ( Self ) PICTURE aBitmap[ 2 ] OBJ ::oButton2
      ENDIF
   ENDIF

   RETURN Self

METHOD RefreshData() CLASS TText

   LOCAL uValue

   IF HB_IsBlock( ::Block )
      uValue := Eval( ::Block )
      IF ValType ( uValue ) $ 'CM'
         uValue := RTrim( uValue )
      ENDIF
      ::Value := uValue
   ENDIF
   aEval( ::aControls, { |o| If( o:Container == Nil, o:RefreshData(), ) } )

   RETURN NIL

METHOD SizePos( Row, Col, Width, Height ) CLASS TText

   LOCAL xRet

   xRet := ::Super:SizePos( Row, Col, Width, Height )
   aEval( ::aControls, { |o| o:Redraw() } )

   RETURN xRet

METHOD Enabled( lEnabled ) CLASS TText

   IF HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      aEval( ::aControls, { |o| o:Enabled := o:Enabled } )
   ENDIF

   RETURN ::Super:Enabled

METHOD Visible( lVisible ) CLASS TText

   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      IF lVisible
         aEval( ::aControls, { |o| o:Visible := o:Visible } )
      ELSE
         aEval( ::aControls, { |o| o:ForceHide() } )
      ENDIF
   ENDIF

   RETURN ::lVisible

METHOD AddControl( oCtrl ) CLASS TText

   LOCAL aRect

   ::Super:AddControl( oCtrl )
   oCtrl:Container := Self
   ::ControlArea := ::ControlArea + oCtrl:Width
   aRect := { 0, 0, 0, 0 }
   GetClientRect( ::hWnd, @aRect )
   oCtrl:Visible := oCtrl:Visible
   oCtrl:SizePos( 2, ::ClientWidth + 2,, ::ClientHeight )
   oCtrl:Anchor := ::nDefAnchor

   RETURN NIL

METHOD DeleteControl( oCtrl ) CLASS TText

   LOCAL nCount

   nCount := Len( ::aControls )
   ::Super:DeleteControl( oCtrl )
   IF Len( ::aControls ) < nCount
      ::ControlArea := ::ControlArea - oCtrl:Width
      aEval( ::aControls, { |o| If( o:Col < oCtrl:Col + oCtrl:Width, o:Col += oCtrl:Width, ) } )
   ENDIF

   RETURN NIL

METHOD Value( uValue ) CLASS TText

   RETURN ( ::Caption := If( ValType( uValue ) $ "CM" , RTrim( uValue ), Nil ) )

METHOD SetFocus() CLASS TText

   LOCAL uRet, nLen

   uRet := ::Super:SetFocus()
   IF ::nOnFocusPos == -3
      nLen := Len( RTrim( ::Caption ) )
      SendMessage( ::hWnd, EM_SETSEL, 0, nLen )
   ELSEIF ::nOnFocusPos == -2
      SendMessage( ::hWnd, EM_SETSEL, 0, -1 )
   ELSEIF ::nOnFocusPos == -1
      nLen := Len( ::Caption )
      SendMessage( ::hWnd, EM_SETSEL, nLen, nLen )
   ELSEIF ::nOnFocusPos >= 0
      SendMessage( ::hWnd, EM_SETSEL, ::nOnFocusPos, ::nOnFocusPos )
   ENDIF

   RETURN uRet

METHOD CaretPos( nPos ) CLASS TText

   LOCAL aPos

   IF HB_IsNumeric( nPos )
      SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      ::ScrollCaret()
   ENDIF
   aPos := ::GetSelection()

   RETURN aPos[ 2 ]                                // nEnd

METHOD GetSelection() CLASS TText

   LOCAL aPos

   aPos := TText_GetSelectionData( ::hWnd )

   RETURN aPos                                     // { nStart, nEnd }

METHOD SetSelection( nStart, nEnd ) CLASS TText

   // Use nStart = 0 and nEnd = -1 to select all
   SendMessage( ::hWnd, EM_SETSEL, nStart, nEnd )

   RETURN ::GetSelection()

METHOD GetSelText CLASS TText

   LOCAL aPos := ::GetSelection()

   RETURN SubStr( ::Caption, aPos[1] + 1, aPos[2] - aPos[1] )

METHOD ReadOnly( lReadOnly ) CLASS TText

   IF HB_IsLogical( lReadOnly )
      SendMessage( ::hWnd, EM_SETREADONLY, If( lReadOnly, 1, 0 ), 0 )
   ENDIF

   RETURN IsWindowStyle( ::hWnd, ES_READONLY )

METHOD MaxLength( nLen ) CLASS TText

   IF HB_IsNumeric( nLen )
      ::nMaxLength := If( nLen >= 1, nLen, 0 )
      SendMessage( ::hWnd, EM_LIMITTEXT, ::nMaxLength, 0 )
   ENDIF

   RETURN SendMessage( ::hWnd, EM_GETLIMITTEXT, 0, 0 )

METHOD DoAutoSkip() CLASS TText

   IF HB_IsBlock( ::OnTextFilled )
      ::DoEvent( ::OnTextFilled, "TEXTFILLED" )
   ELSE
      _SetNextFocus()
   ENDIF

   RETURN NIL

METHOD Events_Command( wParam ) CLASS TText

   LOCAL Hi_wParam := HiWord( wParam )
   LOCAL lWhen

   IF Hi_wParam == EN_CHANGE
      IF ::Transparent
         RedrawWindowControlRect( ::ContainerhWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )
      ENDIF
      IF ::lSetting
         ::lSetting := .F.
      ELSE
         ::DoChange()
         IF ::lAutoSkip .AND. ::nMaxLength > 0 .AND. ::CaretPos >= ::nMaxLength
            ::DoAutoSkip()
         ENDIF
      ENDIF
      IF ::lPrevUndo
         ::xUndo := ::xPrevUndo
         ::lPrevUndo := .F.
      ENDIF

   ELSEIF Hi_wParam == EN_KILLFOCUS
      IF ! ::When_Procesing
         ::When_Processed := .F.
      ENDIF
      //::SetFont( ::cFontName, ::nFontSize, ::Bold, ::Italic, ::Underline, ::Strikeout )
      ::lFocused := .F.

      RETURN ::DoLostFocus()

   ELSEIF Hi_wParam == EN_SETFOCUS
      lWhen := .T.

      IF ! ::When_Processed
         ::When_Processed := .T.
         ::When_Procesing := .T.

         IF ! Empty( ::bWhen )
            lWhen := Eval ( ::bWhen, ::Value )
         ENDIF

         ::When_Procesing := .F.
      ENDIF

      IF ::When_Processed
         IF lWhen
            ::xPrevUndo := ::Value
            ::lPrevUndo := .T.

            ::lFocused := .T.

            IF ::nInsertType == 0
               ::InsertStatus := ( ::Type != "TEXTPICTURE" )
            ENDIF

            ::SetFocus()

            //::FontHandle := _SetFont( ::hWnd, ::cFocusFontName, ::nFocusFontSize, ::FocusBold, ::FocusItalic, ::FocusUnderline, ::FocusStrikeout )
            //::SetFont( ::cFocusFontName, ::nFocusFontSize, ::FocusBold, ::FocusItalic, ::FocusUnderline, ::FocusStrikeout )
         ELSE
            IF GetKeyState( VK_TAB ) < 0 .AND. GetKeyFlagState() == MOD_SHIFT
               _SetPrevFocus()
            ELSE
               _SetNextFocus()
            ENDIF
         ENDIF
      ENDIF

   ENDIF

   RETURN ::Super:Events_Command( wParam )

METHOD InsertStatus( lValue ) CLASS TText

   /*
   * ::nInsertType values
   * 0 = Default: each time the control gots focus, it's set to
   *     overwrite for TTextPicture and to insert for the rest.
   * 1 = Same as default for the first time the control gots focus,
   *     the next times the control got focus, it remembers the previous value.
   * 2 = The state of the INSERT key is used to set the type, instead of lInsert.
   */
   IF HB_IsLogical( lValue )
      // Set
      IF ::nInsertType != 2
         ::lInsert := lValue
      ENDIF
   ELSE
      // Get
      IF ::nInsertType == 2
         ::lInsert := IsInsertActive()
      ENDIF
   ENDIF

   RETURN ::lInsert

METHOD GetLineFromChar( nChar ) CLASS TText

   LOCAL nLine

   IF nChar > 64000
      nLine := SendMessage( ::hWnd, EM_EXLINEFROMCHAR, 0, nChar)
   ELSE
      nLine := SendMessage( ::hWnd, EM_LINEFROMCHAR, nChar, 0)
   ENDIF

   RETURN nLine

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
            iRet = HTTRANSPARENT;
         }

         hb_retni( iRet );
         break;
      }

      case WM_CHAR:
      case WM_KEYDOWN:
      case WM_LBUTTONDOWN:
      case WM_UNDO:
         if( ( GetWindowLong( hWnd, GWL_STYLE ) & ES_READONLY ) == 0 )
         {
            HB_FUNCNAME( TTEXT_EVENTS2 )();
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

   if( HB_ISNUM( 1 ) )
   {
      oSelf->lAux[ 0 ] = hb_parni( 1 );
      GetWindowRect( oSelf->hWnd, &rect );
      SetWindowPos( oSelf->hWnd, NULL, 0, 0, 0, 0, SWP_NOMOVE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_NOREDRAW | SWP_NOSIZE );
   }

   hb_retni( oSelf->lAux[ 0 ] );
}

// -----------------------------------------------------------------------------
HB_FUNC( TTEXT_GETSELECTIONDATA )
// -----------------------------------------------------------------------------
{
   DWORD wParam;
   DWORD lParam;

   SendMessage( HWNDparam( 1 ), EM_GETSEL, (WPARAM) &wParam, (LPARAM) &lParam );

   hb_reta( 2 );
   HB_STORNI( (int) wParam, -1, 1 );
   HB_STORNI( (int) lParam, -1, 2 );
}

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TTEXT_GETCHARFROMPOS )           // METHOD GetCharFromPos( nRow, nCol ) CLASS TText
// -----------------------------------------------------------------------------
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lRet;

   lRet = SendMessage( oSelf->hWnd, EM_CHARFROMPOS, 0, MAKELPARAM( hb_parni( 2 ), hb_parni( 1 ) ) );

   hb_reta( 2 );
   HB_STORNI( (int) LOWORD( lRet ), -1, 1 );        // zero-based index of the char
   HB_STORNI( (int) HIWORD( lRet ), -1, 2 );        // zero-based line containing the char
}

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TTEXT_GETRECT )           // METHOD GetRect() CLASS TText
// -----------------------------------------------------------------------------
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;

   SendMessage( oSelf->hWnd, EM_GETRECT, 0, (LPARAM) &rect );

   hb_reta( 4 );
   HB_STORNI( (int) rect.top, -1, 1 );
   HB_STORNI( (int) rect.left, -1, 2 );
   HB_STORNI( (int) rect.bottom, -1, 3 );
   HB_STORNI( (int) rect.right, -1, 4 );
}

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TTEXT_GETLASTVISIBLELINE )           // METHOD GetLastVisibleLine() CLASS TText
// -----------------------------------------------------------------------------
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   RECT rect;

   SendMessage( oSelf->hWnd, EM_GETRECT, 0, (LPARAM) &rect );

   hb_retni( HIWORD( SendMessage( oSelf->hWnd, EM_CHARFROMPOS, 0, MAKELPARAM( rect.left + 1, rect.bottom - 2 ) ) ) );
}

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TTEXT_GETLINE )           // METHOD GetLine( nLine ) CLASS TText
// -----------------------------------------------------------------------------
// Return the text of a specified line. Line number starts at 0.
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG nChar;
   WORD LenBuff;
   LPTSTR strBuffer;
   LPWORD pBuffer;
   LRESULT lResult;

   nChar = SendMessage( oSelf->hWnd, EM_LINEINDEX, (WPARAM) hb_parnl( 1 ), 0 );
   if( nChar < 0 )
   {
      hb_retc( "" );
   }
   else
   {
      LenBuff = (WORD) SendMessage( oSelf->hWnd, EM_LINELENGTH, nChar, 0 );
      if( LenBuff )
      {
         strBuffer = (LPTSTR) hb_xgrab( ( LenBuff + 1 ) * sizeof( TCHAR ) );
         pBuffer = (LPWORD) strBuffer;
         pBuffer[0] = LenBuff;
         strBuffer[LenBuff] = (TCHAR) 0;
         lResult = SendMessage( oSelf->hWnd, EM_GETLINE, (WPARAM) hb_parnl( 1 ), (LPARAM) strBuffer );
         if( lResult )
         {
            hb_retc( strBuffer );
         }
         else
         {
            hb_retc( "" );
         }
         hb_xfree( strBuffer );
      }
      else
      {
         hb_retc( "" );
      }
   }
}

#pragma ENDDUMP

FUNCTION TText_Events2( hWnd, nMsg, wParam, lParam )

   LOCAL Self := QSelf()
   LOCAL aPos, nStart, nEnd, cText

   IF nMsg == WM_CHAR .AND. wParam >= 32 .AND. ! ::InsertStatus
      aPos := ::GetSelection()
      nStart := aPos[ 1 ]
      nEnd := aPos[ 2 ]

      /* If some characters are selected or if the insertion point is
      * at the end of line then use control's default behavior.
      * Else, select the next character and invoke default behavior.
      */
      IF nEnd == nStart
         IF SubStr( ::Caption, nStart + 1, 2) != Chr(13) + Chr(10)
            SendMessage( ::hWnd, EM_SETSEL, nStart, nStart + 1)
         ENDIF
      ENDIF

   ELSEIF nMsg == WM_UNDO
      cText := ::Value
      ::Value := ::xUndo
      ::xUndo := cText

   ELSEIF nMsg == WM_LBUTTONDOWN
      IF ! ::lFocused
         ::SetFocus()
      ENDIF
      ::DoEventMouseCoords( ::OnClick, "CLICK" )

   ELSEIF nMsg == WM_KEYDOWN .AND. wParam == VK_INSERT .AND. GetKeyFlagState() == 0
      // Toggle insertion
      ::InsertStatus :=  ! ::InsertStatus

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

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
   DATA cDateFormat    INIT Nil
   DATA lToUpper       INIT .F.
   DATA lNumericScroll INIT .F.
   DATA nYear          INIT Nil

   METHOD Define
   METHOD Value       SETGET
   METHOD Picture     SETGET
   METHOD Events
   METHOD KeyPressed
   METHOD Events_Command

   ENDCLASS

METHOD Define( cControlName, cParentForm, nx, ny, nWidth, nHeight, uValue, ;
      cInputMask, cFontName, nFontSize, cToolTip, uLostFocus, ;
      uGotFocus, uChange, uEnter, right, HelpId, readonly, bold, ;
      italic, underline, strikeout, field, backcolor, fontcolor, ;
      invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos, ;
      lDisabled, bValid, lUpper, lLower, bAction, aBitmap, ;
      nBtnwidth, bAction2, bWhen, lCenter, nYear, OnTextFilled, ;
      nInsType ) CLASS TTextPicture

   LOCAL nStyle := ES_AUTOHSCROLL, nStyleEx := 0

   nStyle += If( HB_IsLogical( lUpper ) .AND. lUpper, ES_UPPERCASE, 0 ) + ;
      If( HB_IsLogical( lLower ) .AND. lLower, ES_LOWERCASE, 0 )

   ASSIGN ::nYear VALUE nYear TYPE "N" DEFAULT -1

   IF uValue == Nil
      uValue := ""
   ELSEIF HB_IsNumeric( uValue )
      right := .T.
      ::InsertStatus := .F.
      ::lNumericScroll := .T.
   ELSEIF HB_IsDate( uValue )
      ::lNumericScroll := .T.
   ENDIF

   IF ValType( cInputMask ) $ "CM"
      ::cPicture := cInputMask
   ENDIF
   ::Picture( ::cPicture, uValue )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, uValue, ;
      cFontName, nFontSize, cToolTip, 0, .F., ;
      uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
      readonly, bold, italic, underline, strikeout, field, ;
      backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
      lAutoSkip, nStyleEx, lNoBorder, OnFocusPos, lDisabled, bValid, ;
      bAction, aBitmap, nBtnwidth, bAction2, bWhen, lCenter, ;
      OnTextFilled, nInsType )

   RETURN Self

METHOD Picture( cInputMask, uValue ) CLASS TTextPicture

   LOCAL cType, cPicFun, cPicMask, nPos, nScroll, lOldCentury

   IF ValType( cInputMask ) $ "CM"
      IF uValue == Nil
         uValue := ::Value
      ENDIF

      lOldCentury := __SETCENTURY()
      ::cDateFormat := Set( _SET_DATEFORMAT )
      cType := ValType( uValue )

      IF ! ValType( cInputMask ) $ "CM"
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
         ELSE
            cPicMask := ""
            cInputMask := Upper( cInputMask )
         ENDIF

         DO WHILE "S" $ cInputMask
            nScroll := 0
            // It's automatic at textbox's width
            nPos := At( "S", cInputMask )
            cInputMask := Left( cInputMask, nPos - 1 ) + SubStr( cInputMask, nPos + 1 )
            DO WHILE Len( cInputMask ) >= nPos .AND. SubStr( cInputMask, nPos, 1 ) $ "0123456789"
               nScroll := ( nScroll * 10 ) + Val( SubStr( cInputMask, nPos, 1 ) )
               cInputMask := Left( cInputMask, nPos - 1 ) + SubStr( cInputMask, nPos + 1 )
            ENDDO
            IF cType $ "CM" .AND. Empty( cPicMask ) .AND. nScroll > 0
               cPicMask := Replicate( "X", nScroll )
            ENDIF
         ENDDO

         IF "A" $ cInputMask
            IF cType $ "CM" .AND. Empty( cPicMask )
               cPicMask := Replicate( "A", Len( uValue ) )
            ENDIF
            cInputMask := StrTran( cInputMask, "A", "" )
         ENDIF

         /*
         If "B" $ cInputMask
         cPicFun += "B"
         cInputMask := StrTran( cInputMask, "B", "" )
         EndIf
         */

         IF "2" $ cInputMask
            SET CENTURY OFF
            cInputMask := StrTran( cInputMask, "2", "" )
         ENDIF

         IF "4" $ cInputMask
            SET CENTURY ON
            cInputMask := StrTran( cInputMask, "4", "" )
         ENDIF

         ::cDateFormat := Set( _SET_DATEFORMAT )

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
            IF cType == "D"
               cPicMask := If( __SETCENTURY(), "dd/mm/yyyy", "dd/mm/yy" )
            ELSEIF cType != "N"
               cPicMask := If( __SETCENTURY(), "99/99/9999", "99/99/99" )
            ENDIF
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
            IF cType $ "CM" .AND. Empty( cPicMask )
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
      ELSE
         cPicMask := cInputMask
      ENDIF

      IF Empty( cPicMask )
         DO CASE
         CASE cType $ "CM"
            cPicMask := Replicate( "X", Len( uValue ) )
         CASE cType $ "N"
            cPicMask := Str( uValue )
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
      ENDIF

      IF cType $ "D"
         ::cDateFormat := cPicMask
         cPicMask := StrTran( StrTran( StrTran( StrTran( StrTran( StrTran( cPicMask, "Y", "9" ), "y", "9" ), "M", "9" ), "m", "9" ), "D", "9" ), "d", "9" )
      ENDIF

      ::PictureFunShow := cPicFun
      ::PictureFun     := If( ::lBritish, "E", "" ) + If( "R" $ cPicFun, "R", "" ) + If( ::lToUpper, "!", "" )
      IF ! Empty( ::PictureFun )
         ::PictureFun := "@" + ::PictureFun + " "
      ENDIF
      ::PictureShow    := cPicMask
      ::PictureMask    := cPicMask
      ::DataType       := If( cType == "M", "C", cType )
      ::nDecimal       := If( cType == "N", At( ".", cPicMask ), 0 )
      ::nDecimalShow   := If( cType == "N", At( ".", cPicMask ), 0 )
      ::ValidMask      := ValidatePicture( cPicMask )
      ::ValidMaskShow  := ValidatePicture( cPicMask )

      IF ::DataType == "N"
         ::PictureMask := StrTran( StrTran( StrTran( ::PictureMask, ",", "" ), "*", "9" ), "$", "9" )
         ::nDecimal    := At( ".", ::PictureMask )
         ::ValidMask   := ValidatePicture( ::PictureMask )
      ENDIF

      ::cPicture := ::PictureFunShow + ::PictureShow
      ::Value := uValue
      __SETCENTURY( lOldCentury )
   ENDIF

   RETURN ::cPicture

STATIC FUNCTION ValidatePicture( cPicture )

   LOCAL aValid, nPos
   LOCAL cValidPictures := "ANX9#LY!anxly$*"

   aValid := Array( Len( cPicture ) )
   FOR nPos := 1 To Len( cPicture )
      aValid[ nPos ] := ( SubStr( cPicture, nPos, 1 ) $ cValidPictures )
   NEXT

   RETURN aValid

METHOD Value( uValue ) CLASS TTextPicture

   LOCAL cType, cAux, cDateFormat, lOldCentury, nAt

   IF ! ValidHandler( ::hWnd )

      RETURN NIL
   ENDIF

   IF ::DataType == "D"
      cDateFormat := Set( _SET_DATEFORMAT )
      lOldCentury := __SETCENTURY()
      __SETCENTURY( ( "YYYY" $ Upper( ::cDateFormat ) ) )
      Set( _SET_DATEFORMAT, ::cDateFormat )
   ENDIF

   IF PCount() > 0
      cType := ValType( uValue )
      cType := If( cType == "M", "C", cType )
      IF cType == ::DataType
         IF cType == "D"
            cAux := Transform( uValue, "@D" )
            IF Len( cAux ) < Len( ::cDateFormat )
               cAux := cAux + Space( Len( ::cDateFormat ) - Len( cAux ) )
            ENDIF
         ELSEIF ::lFocused
            cAux := Transform( uValue, ::PictureFun + ::PictureMask )
            IF Len( cAux ) < Len( ::PictureMask )
               cAux := cAux + Space( Len( ::PictureMask ) - Len( cAux ) )
            ENDIF
         ELSE
            cAux := Transform( uValue, ::PictureFunShow + ::PictureShow )
            IF Len( cAux ) != Len( ::PictureShow )
               cAux := PADR( cAux, Len( ::PictureShow ) )
            ENDIF
         ENDIF
         ::Caption := cAux
      ELSE
         // Wrong data types
      ENDIF
   ENDIF
   cType := ::DataType

   // Removes mask
   DO CASE
   CASE cType == "C"
      uValue := If( ( "R" $ ::PictureFun ), xUnTransform( Self, ::Caption ), ::Caption )
   CASE cType == "N"
      uValue := Val( StrTran( xUnTransform( Self, ::Caption ), " ", "" ) )
   CASE cType == "D"
      uValue := ::Caption
      IF ::nYear >= 100 .and. ::nYear <= 2999
         nAt := At( "YY", upper(::cDateFormat) )
         IF nAt > 0
            cAux := Transform( uValue, "@D" )

            IF __SETCENTURY()
               IF Empty( SubStr( cAux, nAt, 4 ) )
                  uValue := Stuff( cAux, nAt, 4, StrZero( ::nYear, 4, 0 ) )
               ENDIF
            ELSE
               IF Empty( SubStr( cAux, nAt, 2 ) )
                  uValue := Stuff( cAux, nAt, 2, StrZero( ::nYear % 100, 2, 0 ) )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      uValue := CtoD( uValue )
   CASE cType == "L"
      uValue := ( Left( xUnTransform( Self, ::Caption ), 1 ) $ "YT" + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 1 ) )
   OTHERWISE
      // Wrong data type
      uValue := Nil
   ENDCASE

   IF ::DataType == "D"
      __SETCENTURY( lOldCentury )
      Set( _SET_DATEFORMAT, cDateFormat )
   ENDIF

   RETURN uValue

STATIC FUNCTION xUnTransform( Self, cCaption )

   LOCAL cRet

   IF ::lFocused
      cRet := _OOHG_UnTransform( cCaption, ::PictureFun + ::PictureMask, ::DataType )
   ELSE
      cRet := _OOHG_UnTransform( cCaption, ::PictureFunShow + ::PictureShow, ::DataType )
   ENDIF

   RETURN cRet

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

   LOCAL Self := QSelf()
   LOCAL nPos, nPos1, nPos2, cText, aPos
   LOCAL aValidMask := ::ValidMask

   IF nMsg == WM_CHAR .AND. wParam >= 32
      aPos := ::GetSelection()
      nPos1 := aPos[ 1 ]
      nPos2 := aPos[ 2 ]
      cText := ::Caption
      nPos := nPos1 + 1
      cText := TTextPicture_Clear( cText, nPos, nPos2 - nPos1, aValidMask, ::InsertStatus )
      IF TTextPicture_Events2_Key( Self, @cText, @nPos, Chr( wParam ), aValidMask, ::PictureMask, ::InsertStatus )
         ::Caption := cText
         IF ! ::lNumericScroll
            DO WHILE nPos < Len( aValidMask ) .AND. ! aValidMask[ nPos + 1 ]
               nPos++
            ENDDO
         ENDIF
         SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      ENDIF
      IF ::lAutoSkip .AND. nPos >= Len( aValidMask )
         ::DoAutoSkip()
      ENDIF

      RETURN 1

   ELSEIF nMsg == WM_KEYDOWN .AND. wParam == VK_DELETE .AND. GetKeyFlagState() == 0
      aPos := ::GetSelection()
      nPos1 := aPos[ 1 ]
      nPos2 := aPos[ 2 ]
      cText := ::Caption
      cText := TTextPicture_Delete( Self, cText, nPos1 + 1, Max( nPos2 - nPos1, 1 ) )
      ::Caption := cText
      SendMessage( ::hWnd, EM_SETSEL, nPos1, nPos1 )

      RETURN 1

   ELSEIF nMsg == WM_KEYDOWN .AND. wParam == VK_END .AND. GetKeyFlagState() == 0
      cText := ::Caption
      nPos := Len( aValidMask )
      DO WHILE nPos > 0 .AND. ( ! aValidMask[ nPos ] .OR. SubStr( cText, nPos, 1 ) == " " )
         nPos--
      ENDDO
      SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )

      RETURN 1

   ELSEIF nMsg == WM_PASTE
      aPos := ::GetSelection()
      nPos1 := aPos[ 1 ]
      nPos2 := aPos[ 2 ]
      cText := ::Caption
      nPos := nPos1
      cText := TTextPicture_Clear( cText, nPos + 1, nPos2 - nPos1, aValidMask, ::InsertStatus )
      IF TTextPicture_Events2_String( Self, @cText, @nPos, GetClipboardText(), aValidMask, ::PictureMask, ::InsertStatus )
         ::Caption := cText
         SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      ENDIF
      // Must ::lAutoSkip works when PASTE?
      // If ::lAutoSkip .AND. nPos >= Len( aValidMask )
      //    ::DoAutoSkip()
      // EndIf

      RETURN 1

   ELSEIF nMsg == WM_LBUTTONDOWN
      IF ::lFocused
         ::DoEventMouseCoords( ::OnClick, "CLICK" )
      ELSE
         ::SetFocus()
         ::DoEventMouseCoords( ::OnClick, "CLICK" )

         RETURN 1
      ENDIF

   ELSEIF nMsg == WM_UNDO .OR. ;
         ( nMsg == WM_KEYDOWN .AND. wParam == VK_Z .AND. GetKeyFlagState() == MOD_CONTROL )
      cText := ::Value
      ::Value := ::xUndo
      ::xUndo := cText

      // This is necesary to repaint with inputmask
      IF ::lFocused
         ::SetFocus()
      ENDIF

      RETURN 1

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

METHOD KeyPressed( cString, nPos ) CLASS TTextPicture

   IF ! ValType( cString ) $ "CM"
      cString := ""
   ENDIF
   IF ! HB_IsNumeric( nPos ) .OR. nPos < -2
      nPos := ::CaretPos
   ELSEIF nPos < 0
      nPos := Len( ::Caption )
   ENDIF

   RETURN TTextPicture_Events2_String( Self, @::Caption, @nPos, cString, ::ValidMask, ::PictureMask, ::InsertStatus )

STATIC FUNCTION TTextPicture_Events2_Key( Self, cText, nPos, cChar, aValidMask, cPictureMask, lInsert )

   LOCAL lChange := .F., nPos1, cMask

   IF ::nDecimal != 0 .AND. cChar $ If( ::lBritish, ",.", "." )
      cText := xUnTransform( Self, cText )
      nPos1 := If( Left( LTrim( cText ), 1 ) == "-", 1, 0 )
      cText := Transform( Val( StrTran( cText, " ", "" ) ), If( ::lBritish, "@E ", "" ) + cPictureMask )
      IF nPos1 == 1 .AND. Left( cText, 1 ) == " " .AND. ! "-" $ cText
         nPos1 := Len( cText ) - Len( LTrim( cText ) )
         cText := Left( cText, nPos1 - 1 ) + "-" + SubStr( cText, nPos1 + 1 )
      ENDIF
      nPos := ::nDecimal

      RETURN .T.
   ENDIF
   IF ::lNumericScroll .AND. nPos > 1 .AND. aValidMask[ nPos - 1 ]
      IF nPos > Len( cPictureMask ) .OR. ! aValidMask[ nPos ]
         nPos1 := nPos
         DO WHILE nPos1 > 1 .AND. aValidMask[ nPos1 - 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
            nPos1--
         ENDDO
         IF aValidMask[ nPos1 ] .AND. SubStr( cText, nPos1, 1 ) == " "
            cText := Left( cText, nPos1 - 1 ) + SubStr( cText, nPos1 + 1, nPos - nPos1 - 1 ) + " " + SubStr( cText, nPos )
            nPos--
         ENDIF
      ENDIF
   ENDIF
   DO WHILE nPos <= Len( cPictureMask ) .AND. ! aValidMask[ nPos ]
      nPos++
   ENDDO
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
         IF ::lNumericScroll
            IF SubStr( cText, nPos, 1 ) == " "
               cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
            ELSE
               nPos1 := nPos
               DO WHILE nPos1 < Len( cPictureMask ) .AND. aValidMask[ nPos1 + 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
                  nPos1++
               ENDDO
               IF SubStr( cText, nPos1, 1 ) == " "
                  cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos, nPos1 - nPos ) + SubStr( cText, nPos1 + 1 )
               ELSE
                  nPos1 := nPos
                  DO WHILE nPos1 > 1 .AND. aValidMask[ nPos1 - 1 ] .AND. ! SubStr( cText, nPos1, 1 ) == " "
                     nPos1--
                  ENDDO
                  IF SubStr( cText, nPos1, 1 ) == " "
                     cText := Left( cText, nPos1 - 1 ) + SubStr( cText, nPos1 + 1, nPos - nPos1 - 1 ) + cChar + SubStr( cText, nPos )
                     nPos--
                  ELSE
                     cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
                  ENDIF
               ENDIF
            ENDIF
         ELSEIF lInsert
            nPos1 := nPos
            DO WHILE nPos1 < Len( cPictureMask ) .AND. aValidMask[ nPos1 + 1 ]
               nPos1++
            ENDDO
            cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos, nPos1 - nPos ) + SubStr( cText, nPos1 + 1 )
         ELSE
            cText := Left( cText, nPos - 1 ) + cChar + SubStr( cText, nPos + 1 )
         ENDIF
         lChange := .T.
      ELSE
         nPos--
      ENDIF
   ENDIF

   RETURN lChange

FUNCTION TTextPicture_Events2_String( Self, cText, nPos, cString, aValidMask, cPictureMask, lInsert )

   LOCAL lChange := .F.

   DO WHILE Len( cString ) > 0 .AND. nPos < Len( cPictureMask )
      nPos++
      IF ! aValidMask[ nPos ] .AND. Left( cString, 1 ) == SubStr( cPictureMask, nPos, 1 )
         cText := Left( cText, nPos - 1 ) + Left( cString, 1 ) + SubStr( cText, nPos + 1 )
         lChange := .T.
      ELSE
         lChange := TTextPicture_Events2_Key( Self, @cText, @nPos, Left( cString, 1 ), aValidMask, cPictureMask, lInsert ) .OR. lChange
      ENDIF
      cString := SubStr( cString, 2 )
   ENDDO

   RETURN lChange

FUNCTION TTextPicture_Clear( cText, nPos, nCount, aValidMask, lInsert )

   LOCAL nClear, nBase

   nCount := Max( Min( nCount, ( Len( aValidMask ) - nPos + 1 ) ), 0 )
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
         ELSEIF nClear != 0
            // The clear area is out of the count's range
            DO WHILE nPos <= Len( aValidMask ) .AND. aValidMask[ nPos ]
               nPos++
            ENDDO
            cText := Left( cText, nBase ) + SubStr( cText, nBase + nClear + 1, nPos - nBase - nClear - 1 ) + Space( nClear ) + SubStr( cText, nPos )
         ENDIF
      ENDDO
   ELSE
      DO WHILE nCount > 0
         IF aValidMask[ nPos ]
            cText := Left( cText, nPos - 1 ) + " " + SubStr( cText, nPos + 1 )
         ENDIF
         nPos++
         nCount--
      ENDDO
   ENDIF

   RETURN cText

STATIC FUNCTION TTextPicture_Delete( Self, cText, nPos, nCount )

   LOCAL i, j

   // number of template characters to delete
   nCount := Max( Min( nCount, ( Len( ::ValidMask ) - nPos + 1 ) ), 0 )

   // process from right to left
   FOR i := nPos + nCount - 1 to nPos step -1

      // process template characters only
      IF ::ValidMask[ i ]

         // Delete character, shifting to the left all remaining characters
         // until end of line or until next non-template character (whatever
         // occurs first).
         FOR j := i + 1 to Len( cText )
            IF ! ::ValidMask[ j ]
               EXIT
            ENDIF
         NEXT j

         cText := Left( cText, i - 1 ) + SubStr( cText, i + 1, j - i - 1 ) + " " + SubStr( cText, j )
      ENDIF
   NEXT i

   RETURN cText

METHOD Events_Command( wParam ) CLASS TTextPicture

   LOCAL Hi_wParam := HIWORD( wParam )
   LOCAL cText, nPos, nPos2, cAux, aPos
   LOCAL cPictureMask, aValidMask

   IF Hi_wParam == EN_CHANGE
      cText := ::Caption
      cPictureMask := ::PictureMask
      IF Len( cText ) != Len( cPictureMask ) .AND. ! ::lSetting .AND. ::lFocused
         aValidMask := ::ValidMask
         aPos := ::GetSelection()
         nPos := aPos[ 2 ]
         IF Len( cText ) > Len( cPictureMask )
            nPos2 := Len( cPictureMask ) - ( Len( cText ) - nPos )
            cAux := SubStr( cText, nPos2 + 1, nPos - nPos2 )
            cText := Left( cText, nPos2 ) + SubStr( cText, nPos + 1 )
            TTextPicture_Events2_String( Self, @cText, @nPos2, cAux, aValidMask, cPictureMask, .F. )
         ELSE
            IF nPos > 0 .AND. nPos < Len( cPictureMask ) .AND. ! aValidMask[ nPos + 1 ]
               nPos--
            ENDIF
            nPos2 := nPos
            nPos := Len( cPictureMask ) - Len( cText )
            cText := Left( cText, nPos2 ) + Space( nPos ) + SubStr( cText, nPos2 + 1 )
            cText := TTextPicture_Clear( cText, nPos2 + 1, nPos, aValidMask, ::InsertStatus )
         ENDIF
         FOR nPos := 1 To Len( cPictureMask )
            IF ! aValidMask[ nPos ]
               cAux := SubStr( cPictureMask, nPos, 1 )
               IF cAux $ ",." .AND. ::lBritish
                  cAux := If( cAux == ",", ".", "," )
               ENDIF
               cText := Left( cText, nPos - 1 ) + cAux + SubStr( cText, nPos + 1 )
            ENDIF
         NEXT
         ::Caption := cText
         SendMessage( ::hWnd, EM_SETSEL , nPos2, nPos2 )
      ENDIF

   ELSEIF Hi_wParam == EN_KILLFOCUS
      // This is necesary to repaint with inputmask
      cText := ::Value
      ::lFocused := .F.
      ::lSetting := .T.
      ::Value := cText

   ELSEIF Hi_wParam == EN_SETFOCUS
      // This is necesary to repaint with inputmask
      cText := ::Value
      ::lFocused := .T.
      ::lSetting := .T.
      ::Value := cText

   ENDIF

   RETURN ::Super:Events_Command( wParam )

CLASS TTextNum FROM TText

   DATA Type          INIT "NUMTEXT" READONLY

   METHOD Define
   METHOD Value       SETGET
   METHOD Events_Command

   ENDCLASS

METHOD Define( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
      cFontName, nFontSize, cToolTip, nMaxLength, lUpper, lLower, ;
      lPassword, uLostFocus, uGotFocus, uChange , uEnter , right  , ;
      HelpId, readonly, bold, italic, underline, strikeout, field , ;
      backcolor , fontcolor , invisible , notabstop, lRtl, lAutoSkip, ;
      lNoBorder, OnFocusPos, lDisabled, bValid, bAction, aBitmap, ;
      nBtnwidth, bAction2, bWhen, lCenter, OnTextFilled, nInsType ) CLASS TTextNum

   LOCAL nStyle := ES_NUMBER + ES_AUTOHSCROLL, nStyleEx := 0

   Empty( lUpper )
   Empty( lLower )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
      cFontName, nFontSize, cToolTip, nMaxLength, lPassword, ;
      uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
      readonly, bold, italic, underline, strikeout, field, ;
      backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
      lAutoSkip, nStyleEx, lNoBorder, OnFocusPos, lDisabled, bValid, ;
      bAction, aBitmap, nBtnwidth, bAction2, bWhen, lCenter, ;
      OnTextFilled, nInsType )

   RETURN Self

METHOD Value( uValue ) CLASS TTextNum

   IF HB_IsNumeric( uValue )
      uValue := Int( uValue )
      ::Caption := AllTrim( Str( uValue ) )
   ELSE
      uValue := Int( Val( ::Caption ) )
   ENDIF

   RETURN uValue

METHOD Events_Command( wParam ) CLASS TTextNum

   LOCAL Hi_wParam := HIWORD( wParam )
   LOCAL cText, nPos, nCursorPos, lChange, aPos

   IF Hi_wParam == EN_CHANGE
      aPos := ::GetSelection()
      nCursorPos := aPos[ 2 ]
      lChange := .F.
      cText := ::Caption
      nPos := 1
      DO WHILE nPos <= Len( cText )
         IF IsDigit( SubStr( cText, nPos, 1 ) )
            nPos++
         ELSE
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
   ENDIF

   RETURN ::Super:Events_Command( wParam )

FUNCTION DefineTextBox( cControlName, cParentForm, x, y, Width, Height, ;
      Value, cFontName, nFontSize, cToolTip, nMaxLength, ;
      lUpper, lLower, lPassword, uLostFocus, uGotFocus, ;
      uChange, uEnter, right, HelpId, readonly, bold, ;
      italic, underline, strikeout, field, backcolor, ;
      fontcolor, invisible, notabstop, lRtl, lAutoSkip, ;
      lNoBorder, OnFocusPos, lDisabled, bValid, ;
      date, numeric, inputmask, format, subclass, bAction, ;
      aBitmap, nBtnwidth, bAction2, bWhen, lCenter, nYear, ;
      OnTextFilled, nInsType )

   LOCAL Self, lInsert

   // If format is specified, inputmask is enabled
   IF ValType( format ) $ "CM"
      IF ValType( inputmask ) $ "CM"
         inputmask := "@" + format + " " + inputmask
      ELSE
         inputmask := "@" + format
      ENDIF
   ENDIF

   // Checks for date textbox
   IF ( HB_IsLogical( date ) .AND. date ) .OR. HB_IsDate( value )
      lInsert := .F.
      numeric := .F.
      IF ValType( Value ) $ "CM"
         Value := CtoD( Value )
      ELSEIF !HB_IsDate( Value )
         Value := StoD( "" )
      ENDIF
      IF ! ValType( inputmask ) $ "CM"
         inputmask := "@D"
      ENDIF
   ENDIF

   // Checks for numeric textbox
   IF ! HB_IsLogical( numeric )
      numeric := .F.
   ELSEIF numeric
      lInsert := .F.
      IF ValType( Value ) $ "CM"
         Value := Val( Value )
      ELSEIF ! HB_IsNumeric( Value )
         Value := 0
      ENDIF
   ENDIF

   IF ValType( inputmask ) $ "CM"
      // If inputmask is defined, it's TTextPicture()
      Self := _OOHG_SelectSubClass( TTextPicture(), subclass )
      ::Define( cControlName, cParentForm, x, y, width, height, value, ;
         inputmask, cFontname, nFontsize, cTooltip, uLostfocus, ;
         uGotfocus, uChange, uEnter, right, HelpId, readonly, bold, ;
         italic, underline, strikeout, field, backcolor, fontcolor, ;
         invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos, ;
         lDisabled, bValid, lUpper, lLower, bAction, aBitmap, ;
         nBtnwidth, bAction2, bWhen, lCenter, nYear, OnTextFilled, ;
         nInsType )
   ELSE
      Self := _OOHG_SelectSubClass( If( numeric, TTextNum(), TText() ), subclass )
      ::Define( cControlName, cParentForm, x, y, Width, Height, Value, ;
         cFontName, nFontSize, cToolTip, nMaxLength, lUpper, lLower, ;
         lPassword, uLostFocus, uGotFocus, uChange, uEnter, right, ;
         HelpId, readonly, bold, italic, underline, strikeout, field, ;
         backcolor, fontcolor, invisible, notabstop, lRtl, lAutoSkip, ;
         lNoBorder, OnFocusPos, lDisabled, bValid, bAction, aBitmap, ;
         nBtnwidth, bAction2, bWhen, lCenter, OnTextFilled, nInsType )
   ENDIF

   ASSIGN ::InsertStatus VALUE lInsert TYPE "L"

   RETURN Self
