/*
 * $Id: h_textbox.prg,v 1.26 2006-04-21 05:34:27 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG textbox functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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
   DATA nMaxLenght      INIT 0
   DATA lAutoSkip       INIT .F.
   DATA lSettingFocus   INIT .F.
   DATA nOnFocusPos     INIT -2

   METHOD Define
   METHOD Define2

   METHOD RefreshData

   METHOD Value       SETGET
   METHOD SetFocus
   METHOD CaretPos    SETGET
   METHOD Events_Enter
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
               cFontName, nFontSize, cToolTip, nMaxLenght, lUpper, lLower, ;
               lPassword, uLostFocus, uGotFocus, uChange, uEnter, right, ;
               HelpId, readonly, bold, italic, underline, strikeout, field, ;
               backcolor, fontcolor, invisible, notabstop, lRtl, lAutoSkip, ;
               lNoBorder, OnFocusPos ) CLASS TText
*-----------------------------------------------------------------------------*
Local nStyle := ES_AUTOHSCROLL, nStyleEx := 0

   nStyle += IF( Valtype( lUpper ) == "L" .AND. lUpper, ES_UPPERCASE, 0 ) + ;
             IF( Valtype( lLower ) == "L" .AND. lLower, ES_LOWERCASE, 0 )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
              cFontName, nFontSize, cToolTip, nMaxLenght, lPassword, ;
              uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
              readonly, bold, italic, underline, strikeout, field, ;
              backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
              lAutoSkip, nStyleEx, lNoBorder, OnFocusPos )

Return Self

*-----------------------------------------------------------------------------*
METHOD Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
                cFontName, nFontSize, cToolTip, nMaxLenght, lPassword, ;
                uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
                readonly, bold, italic, underline, strikeout, field, ;
                backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
                lAutoSkip, nStyleEx, lNoBorder, OnFocusPos ) CLASS TText
*-----------------------------------------------------------------------------*
Local nControlHandle
local break

   // Assign STANDARD values to optional params.
	DEFAULT nWidth     TO 120
	DEFAULT nHeight    TO 24
	DEFAULT uChange    TO ""
	DEFAULT uGotFocus  TO ""
	DEFAULT uLostFocus TO ""
	DEFAULT uEnter     TO ""

   If ValType( nMaxLenght ) == "N" .AND. nMaxLenght >= 0
      ::nMaxLenght := Int( nMaxLenght )
   EndIf

   IF ValType( nStyle ) != "N"
      nStyle := 0
   ENDIF
   IF ValType( nStyleEx ) != "N"
      nStyleEx := 0
   ENDIF

   IF ValType( invisible ) != "L"
      invisible := .F.
   ENDIF

   ::SetForm( cControlName, cParentForm, cFontName, nFontSize, FontColor, BackColor, .T., lRtl )

   // Style definition
   nStyle += IF( Valtype( lPassword ) == "L" .AND. lPassword, ES_PASSWORD,  0 ) + ;
             IF( Valtype( right     ) == "L" .AND. right,     ES_RIGHT,     0 ) + ;
             IF( Valtype( readonly  ) == "L" .AND. readonly,  ES_READONLY,  0 ) + ;
             IF( ! invisible,                                 WS_VISIBLE,   0 ) + ;
             IF( Valtype( notabstop ) != "L" .OR. !notabstop, WS_TABSTOP,   0 )

   nStyleEx += IF( Valtype( lNoBorder ) != "L" .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

	// Creates the control window.
   ::SetSplitBoxInfo( Break, )
   nControlHandle := InitTextBox( ::ContainerhWnd, 0, nx, ny, nWidth, nHeight, nStyle, ::nMaxLenght, ::lRtl, nStyleEx )

   ::Register( nControlHandle, cControlName, HelpId, ! Invisible, cToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( ny, nx, nWidth, nHeight )

   If ValType( Field ) $ 'CM' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      cValue := EVAL( ::Block )
      aAdd( ::Parent:BrowseList, Self )
	EndIf

   ::Value := cValue

   ::OnLostFocus := uLostFocus
   ::OnGotFocus :=  uGotFocus
   ::OnChange   :=  uChange
   ::OnDblClick := uEnter
   If ValType( lAutoSkip ) == "L"
      ::lAutoSkip := lAutoSkip
   EndIf
   If ValType( OnFocusPos ) == "N"
      ::nOnFocusPos := OnFocusPos
   EndIf

return Self

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TText
*-----------------------------------------------------------------------------*
Local uValue

   IF valtype( ::Block ) == "B"
      uValue := EVAL( ::Block )
      If valtype ( uValue ) $ 'CM'
         uValue := rtrim( uValue )
      EndIf
      ::Value := uValue
   ENDIF

Return NIL

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TText
*------------------------------------------------------------------------------*
Return ( ::Caption := IF( ValType( uValue ) $ "CM", RTrim( uValue ), NIL ) )

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
   ::lSettingFocus := .T.
Return uRet

*------------------------------------------------------------------------------*
METHOD CaretPos( nPos ) CLASS TText
*------------------------------------------------------------------------------*
   IF ValType( nPos ) == "N"
      SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
   ENDIF
Return HiWord( SendMessage( ::hWnd, EM_GETSEL, 0, 0 ) )

*------------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TText
*------------------------------------------------------------------------------*
   ::lSettingFocus := .F.
   ::DoEvent( ::OnDblClick )
   If ! ::lSettingFocus
      If _OOHG_ExtendedNavigation
         _SetNextFocus()
      EndIf
   Else
      ::lSettingFocus := .F.
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
         ::DoEvent( ::OnChange )
         If ::lAutoSkip .AND. ::nMaxLenght > 0 .AND. HiWord( SendMessage( ::hWnd, EM_GETSEL, 0, 0 ) ) >= ::nMaxLenght
            _SetNextFocus()
         EndIf
      EndIf
      Return nil

   elseif Hi_wParam == EN_KILLFOCUS
      ::DoEvent( ::OnLostFocus )
      Return nil

   elseif Hi_wParam == EN_SETFOCUS
      ::SetFocus()
      ::DoEvent( ::OnGotFocus )
      Return nil

   Endif

Return ::Super:Events_Command( wParam )





CLASS TTextPicture FROM TText
   DATA Type           INIT "TEXTPICTURE" READONLY
   DATA lBritish       INIT .F.

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

   METHOD Define

   METHOD Value       SETGET
   METHOD Events
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( cControlName, cParentForm, nx, ny, nWidth, nHeight, uValue, ;
               cInputMask, cFontName, nFontSize, cToolTip, uLostFocus, ;
               uGotFocus, uChange, uEnter, right, HelpId, readonly, bold, ;
               italic, underline, strikeout, field, backcolor, fontcolor, ;
               invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos ) CLASS TTextPicture
*-----------------------------------------------------------------------------*
Local nStyle := ES_AUTOHSCROLL, nStyleEx := 0

   IF ValType( uValue ) == "N"
      right := .T.
   ElseIf ValType( uValue ) == "U"
      uValue := ""
   ENDIF

   SetMask( Self, uValue, cInputMask )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, uValue, ;
              cFontName, nFontSize, cToolTip, 0, .F., ;
              uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
              readonly, bold, italic, underline, strikeout, field, ;
              backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
              lAutoSkip, nStyleEx, lNoBorder, OnFocusPos )

Return Self

STATIC PROCEDURE SetMask( Self, uValue, cInputMask )
Local cType, cPicFun, cPicMask, nPos, nScroll

   cType := ValType( uValue )

   IF ! ValType( cInputMask ) $ "CM"
      cInputMask := ""
   ENDIF
   ::lBritish := .F.

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

      IF "C" $ cInputMask
         cPicFun += "C"
         cInputMask := StrTran( cInputMask, "C", "" )
      ENDIF

      IF "D" $ cInputMask
         cPicMask := StrTran( StrTran( StrTran( StrTran( StrTran( StrTran( SET( _SET_DATEFORMAT ), "Y", "9" ), "y", "9" ), "M", "9" ), "m", "9" ), "D", "9" ), "d", "9" )
         cInputMask := StrTran( cInputMask, "D", "" )
      ENDIF

      IF "E" $ cInputMask
         ::lBritish := .T.
         If cType != "N"
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
            cPicMask := StrTran( StrTran( StrTran( StrTran( StrTran( StrTran( SET( _SET_DATEFORMAT ), "Y", "9" ), "y", "9" ), "M", "9" ), "m", "9" ), "D", "9" ), "d", "9" )
         CASE cType $ "L"
            cPicMask := "L"
         OTHERWISE
            // Invalid data type
      ENDCASE
   ENDIF

   ::PictureFunShow := cPicFun
   ::PictureFun     := IF( ::lBritish, "E", "" ) + IF( "R" $ cPicFun, "R", "" )
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

Return

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
Local cType, uDate
   IF PCount() > 0
      cType := ValType( uValue )
      cType := If( cType == "M", "C", cType )
      IF cType == ::DataType
         ::Caption := Transform( uValue, if( ::lFocused, ::PictureFun + ::PictureMask, ::PictureFunShow + ::PictureShow ) )
      Else
         // Wrong data types
      ENDIF
   ENDIF
   cType := ::DataType

   // Removes mask
   DO CASE
      CASE cType == "C"
         uValue := If( ( "R" $ ::PictureFun ), xUnTransform( Self, ::Caption ), ::Caption )
      CASE cType == "N"
         uValue := VAL( StrTran( xUnTransform( Self, ::Caption ), " ", "" ) )
      CASE cType == "D"
         If ::lBritish
            uDate := SET( _SET_DATEFORMAT )
            SET DATE BRITISH
            uValue := CTOD( ::Caption )
            SET( _SET_DATEFORMAT, uDate )
         Else
            uValue := CTOD( ::Caption )
         EndIf
      CASE cType == "L"
         uValue := ( Left( xUnTransform( Self, ::Caption ), 1 ) $ "YT" + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 1 ) )
      OTHERWISE
         // Wrong data type
         uValue := NIL
   ENDCASE
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
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include "../include/oohg.h"
#define s_Super s_TText

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TTEXTPICTURE_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TTextPicture
// -----------------------------------------------------------------------------
{
   HWND hWnd      = ( HWND )   hb_parnl( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_CHAR:
      case WM_PASTE:
      case WM_KEYDOWN:
         HB_FUNCNAME( TTEXTPICTURE_EVENTS2 )();
         break;

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
         DO WHILE nPos < Len( aValidMask ) .AND. ! aValidMask[ nPos + 1 ]
            nPos++
         ENDDO
         SendMessage( ::hWnd, EM_SETSEL, nPos, nPos )
      EndIf
      If ::lAutoSkip .AND. nPos >= LEN( aValidMask )
         _SetNextFocus()
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
      //    _SetNextFocus()
      // EndIf
      Return 1

   Endif
Return ::Super:Events( hWnd, nMsg, wParam, lParam )

STATIC FUNCTION TTextPicture_Events2_Key( Self, cText, nPos, cChar, aValidMask, cPictureMask, lInsert )
Local lChange := .F., nPos1, cMask
   IF ::nDecimal != 0 .AND. cChar $ if( ::lBritish, ",.", "." )
      cText := Transform( VAL( StrTran( xUnTransform( Self, cText ), " ", "" ) ), if( ::lBritish, "@E ", "" ) + cPictureMask )
      nPos := ::nDecimal
      Return .T.
   Endif
   DO WHILE nPos <= Len( cPictureMask ) .AND. ! aValidMask[ nPos ]
      nPos++
   ENDDO
   IF nPos <= Len( cPictureMask )
      cMask := Substr( cPictureMask, nPos, 1 )
      IF cMask $ "!lLyY"
         cChar := Upper( cChar )
      ENDIF
      IF ( cMask $ "Nn"  .AND. ( IsAlpha( cChar ) .OR. IsDigit( cChar ) .OR. cChar $ " " )  ) .OR. ;
         ( cMask $ "Aa"  .AND. ( IsAlpha( cChar ) .OR. cChar == " " ) ) .OR. ;
         ( cMask $ "#$*" .AND. ( IsDigit( cChar ) .OR. cChar == "-" ) ) .OR. ;
         ( cMask $ "9"   .AND. ( IsDigit( cChar ) .OR. ( cChar == "-" .AND. ::DataType == "N" ) ) ) .OR. ;
         ( cMask $ "Ll"  .AND. cChar $ ( "TFYN" + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 1 ) + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 2 ) ) ) .OR. ;
         ( cMask $ "Yy"  .AND. cChar $ ( "YN"   + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 1 ) + HB_LANGMESSAGE( HB_LANG_ITEM_BASE_TEXT + 2 ) ) ) .OR. ;
           cMask $ "Xx!"
         IF lInsert
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
      ::Caption := Transform( cText, ::PictureFunShow + ::PictureShow )

   elseif Hi_wParam == EN_SETFOCUS
      cText := ::Value
      ::lFocused := .T.
      ::lSetting := .T.
      ::Caption := Transform( cText, ::PictureFun + ::PictureMask )

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
               cFontName, nFontSize, cToolTip, nMaxLenght, lUpper, lLower, ;
               lPassword, uLostFocus, uGotFocus, uChange , uEnter , right  , ;
               HelpId, readonly, bold, italic, underline, strikeout, field , ;
               backcolor , fontcolor , invisible , notabstop, lRtl, lAutoSkip, ;
               lNoBorder, OnFocusPos ) CLASS TTextNum
*-----------------------------------------------------------------------------*
Local nStyle := ES_NUMBER + ES_AUTOHSCROLL, nStyleEx := 0

   Empty( lUpper )
   Empty( lLower )

   ::Define2( cControlName, cParentForm, nx, ny, nWidth, nHeight, cValue, ;
              cFontName, nFontSize, cToolTip, nMaxLenght, lPassword, ;
              uLostFocus, uGotFocus, uChange, uEnter, right, HelpId, ;
              readonly, bold, italic, underline, strikeout, field, ;
              backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
              lAutoSkip, nStyleEx, lNoBorder, OnFocusPos )

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TTextNum
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
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
CLASS TTextMasked FROM TTextPicture
*-----------------------------------------------------------------------------*
   DATA Type          INIT "MASKEDTEXT" READONLY

   METHOD Define
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, inputmask, width, value, ;
               fontname, fontsize, tooltip, lostfocus, gotfocus, change, ;
               height, enter, rightalign, HelpId, Format, bold, italic, ;
               underline, strikeout, field, backcolor, fontcolor, readonly, ;
               invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos ) CLASS TTextMasked
*------------------------------------------------------------------------------*

   If ValType( Value ) == "U"
      Value := 0
   EndIf

   rightalign := .T.

   IF ValType( Format ) $ "CM" .AND. ! Empty( Format )
      Format := "@" + Alltrim( Format ) + " "
   Else
      Format := ""
   ENDIF

   IF ! ValType( inputmask ) $ "CM" .OR. Empty( inputmask )
      inputmask := ""
   ENDIF

*         if c!='9' .and.  c!='$' .and. c!='*' .and. c!='.' .and. c!= ','  .and. c != ' ' .and. c!='€'
*         MsgOOHGError("@...TEXTBOX: Wrong InputMask Definition" )
*      EndIf

   ::Super:Define( ControlName, ParentForm, x, y, width, height, value, ;
               Format + inputmask, fontname, fontsize, tooltip, lostfocus, ;
               gotfocus, change, enter, rightalign, HelpId, readonly, bold, ;
               italic, underline, strikeout, field, backcolor, fontcolor, ;
               invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos )

   If ::DataType == "N"
      ::PictureMask := StrTran( ::PictureMask, ",", "" )
      ::nDecimal    := AT( ".", ::PictureMask )
      ::ValidMask   := ValidatePicture( ::PictureMask )
      ::Value       := value
      ::lInsert     := .F.
   Endif

Return Self





*-----------------------------------------------------------------------------*
CLASS TTextCharMask FROM TTextPicture
*-----------------------------------------------------------------------------*
   DATA Type          INIT "CHARMASKTEXT" READONLY

   METHOD Define
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, inputmask, width, value, ;
               fontname, fontsize, tooltip, lostfocus, gotfocus, change, ;
               height, enter, rightalign, HelpId, bold, italic, underline, ;
               strikeout, field, backcolor, fontcolor, date, readonly, ;
               invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos ) CLASS TTextCharMask
*------------------------------------------------------------------------------*

   IF ValType( date ) == "L" .AND. date
      ::lInsert := .F.
      inputmask := StrTran( StrTran( StrTran( StrTran( StrTran( StrTran( SET( _SET_DATEFORMAT ), "Y", "9" ), "y", "9" ), "M", "9" ), "m", "9" ), "D", "9" ), "d", "9" )
      If ValType( Value ) $ "CM"
         Value := CTOD( Value )
      ElseIf ValType( Value ) != "D"
         Value := STOD( "" )
      ENDIF
   ElseIf ValType( Value ) == "U"
      Value := ""
   ENDIF

   ::Super:Define( ControlName, ParentForm, x, y, width, height, value, ;
               inputmask, fontname, fontsize, tooltip, lostfocus, ;
               gotfocus, change, enter, rightalign, HelpId, readonly, bold, ;
               italic, underline, strikeout, field, backcolor, fontcolor, ;
               invisible, notabstop, lRtl, lAutoSkip, lNoBorder, OnFocusPos )

Return Self