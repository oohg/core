/*
 * $Id: h_textbox.prg,v 1.2 2005-08-11 05:17:26 guerra000 Exp $
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


#include "common.ch"
#include "minigui.ch"
#include "i_windefs.ch"
#include "hbclass.ch"

CLASS TText FROM TLabel
   DATA Type          INIT "TEXT" READONLY

   METHOD TextChange  BLOCK { || nil }
   METHOD RefreshData

   METHOD Value       SETGET
   METHOD SetFocus
   METHOD Events_Enter
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TText
*-----------------------------------------------------------------------------*
Local uValue

   IF valtype( ::Block ) == "B"
      uValue := EVAL( ::Block )
      If valtype ( uValue ) == 'C'
         uValue := rtrim( uValue )
      EndIf
      ::Value := uValue
   ENDIF

Return NIL

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TText
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "C"
      ::TopValue := RTrim( uValue )
   ENDIF
RETURN ::TopValue

*------------------------------------------------------------------------------*
METHOD SetFocus() CLASS TText
*------------------------------------------------------------------------------*
Local uRet
   uRet := ::Super:SetFocus()
   SendMessage( ::hWnd, EM_SETSEL, 0 , -1 )
Return uRet

*------------------------------------------------------------------------------*
METHOD Events_Enter() CLASS TText
*------------------------------------------------------------------------------*
   _OOHG_SetFocusExecuted := .F.
   ::DoEvent( ::OnDblClick )
   If _OOHG_SetFocusExecuted == .F.
      If _OOHG_ExtendedNavigation == .T.
         _SetNextFocus()
      EndIf
   Else
      _OOHG_SetFocusExecuted := .F.
   EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TText
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )

   if Hi_wParam == EN_CHANGE

      If _OOHG_DateTextBoxActive == .T.

         _OOHG_DateTextBoxActive := .F.

      Else

         ::TextChange()

         If ::Transparent

            RedrawWindowControlRect( ::Parent:hWnd, ::ContainerRow, ::ContainerCol, ::ContainerRow + ::Height, ::ContainerCol + ::Width )

         EndIf

      EndIf

      ::DoEvent( ::OnChange )

      Return nil

   elseif Hi_wParam == EN_KILLFOCUS

      If _OOHG_InteractiveCloseStarted != .T.

         ::DoEvent( ::OnLostFocus )

      EndIf

      Return nil

   elseif Hi_wParam == EN_SETFOCUS

      ::DoEvent( ::OnGotFocus )

      Return nil

   Endif

Return ::Super:Events_Command( wParam )





*-----------------------------------------------------------------------------*
CLASS TTextNum FROM TText
*-----------------------------------------------------------------------------*
   DATA Type          INIT "NUMTEXT" READONLY

   METHOD TextChange
   METHOD Value       SETGET
ENDCLASS

*------------------------------------------------------------------------------*
METHOD TextChange() CLASS TTextNum
*------------------------------------------------------------------------------*
Local InBuffer , OutBuffer := '' , icp , x , CB , BackInBuffer , BadEntry := .F. , fnb

	// Store Initial CaretPos
   icp := HiWord ( SendMessage( ::hWnd, EM_GETSEL , 0 , 0 ) )

	// Get Current Content

   InBuffer := ::GetText()

	BackInBuffer := InBuffer

	// Find First Non-Blank Position

	For x := 1 To Len ( InBuffer )
		CB := SubStr (InBuffer , x , 1 )
		If CB != ' '
			fnb := x
			Exit
		EndIf
	Next x

	// Process Mask

	For x := 1 To Len(InBuffer)

		CB := SubStr(InBuffer , x , 1 )

		If IsDigit ( CB ) .Or. ( CB == '-' .And. x == fnb )
			OutBuffer := OutBuffer + CB
		Else
			BadEntry  := .t.
		EndIf

	Next x

	If BadEntry
      icp--
	EndIf

	// JK Replace Content

	If ! ( BackInBuffer == OutBuffer )
      ::SetText( OutBuffer )
	EndIf

	// Restore Initial CaretPos

   SendMessage( ::hWnd , EM_SETSEL , icp , icp )

RETURN nil

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TTextNum
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      uValue := Int( uValue )
      ::TopValue := AllTrim( Str( uValue ) )
   ELSE
      uValue := Int( Val( ::TopValue ) )
   ENDIF
RETURN uValue



*--------------------------------------------------------*
function _DefineTextBox( cControlName, cParentForm, nx, ny, nWidth, nHeight, ;
                        cValue, cFontName, nFontSize, cToolTip, nMaxLenght, ;
			lUpper, lLower, lNumeric, lPassword, ;
                        uLostFocus, uGotFocus, uChange , uEnter , right  , ;
			HelpId , readonly , bold, italic, underline, ;
			strikeout , field , backcolor , fontcolor , ;
			invisible , notabstop )
*--------------------------------------------------------*

	local nControlHandle := 0
Local Self

	// Asign STANDARD values to optional params.
	DEFAULT nWidth     TO 120
	DEFAULT nHeight    TO 24
	DEFAULT cValue     TO ""
	DEFAULT uChange    TO ""
	DEFAULT uGotFocus  TO ""
	DEFAULT uLostFocus TO ""
	DEFAULT nMaxLenght TO 255
	DEFAULT lUpper     TO .f.
	DEFAULT lLower     TO .f.
	DEFAULT lNumeric   TO .f.
	DEFAULT lPassword  TO .f.
	DEFAULT uEnter     TO ""

   Self := if( lNumeric, TTextNum(), TText() )
   ::SetForm( cControlName, cParentForm, cFontName, nFontSize, FontColor, BackColor, .T. )

	// Creates the control window.
   nControlHandle := InitTextBox( ::Parent:hWnd, 0, nx, ny, nWidth, nHeight, '', 0, nMaxLenght, ;
                                  lUpper, lLower, .f., lPassword , right , readonly , invisible , notabstop )

   ::New( nControlHandle, cControlName, HelpId, ! Invisible, cToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( ny, nx, nWidth, nHeight )

   ::OnLostFocus := uLostFocus
   ::OnGotFocus :=  uGotFocus
   ::OnChange   :=  uChange
   ::OnDblClick := uEnter

   If ValType( Field ) == 'C' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      cValue := EVAL( ::Block )
	EndIf

	// With NUMERIC clause, transform numeric value into a string.
	if ( lNumeric )
		If Valtype(cValue) != 'C'
			cValue := AllTrim( Str( cValue ) )
		EndIf
	EndIf

	// Fill the TEXTBOX with the text given.
	if ( Len( cValue ) > 0 )
      ::SetText( cValue )
	endif

	if valtype ( Field ) != 'U'
      aAdd ( ::Parent:BrowseList, Self )
	EndIf

return nil










*-----------------------------------------------------------------------------*
CLASS TTextMasked FROM TText
*-----------------------------------------------------------------------------*
   DATA Type          INIT "MASKEDTEXT" READONLY
   DATA Picture       INIT ""
   DATA PictureMask   INIT ""
   DATA lAllow        INIT .F.
   DATA lDot          INIT .T.

   METHOD TextChange
   METHOD GetNumFromText
   METHOD GetNumFromTextSP

   METHOD Value       SETGET
   METHOD Events_Command
ENDCLASS

*------------------------------------------------------------------------------*
METHOD TextChange() CLASS TTextMasked
*------------------------------------------------------------------------------*
Local InBuffer , OutBuffer := '' , icp , x , CB , CM , BadEntry := .F. , InBufferLeft , InBufferRight , Mask , OldChar , BackInbuffer
Local pc := 0
Local fnb := 0
Local dc := 0
Local pFlag := .F.
Local ncp := 0
Local NegativeZero := .F.
Local Output := ''
Local ol := 0

   IF Len ( ::PictureMask ) == 0 .OR. ! ::lAllow

      Return nil

   ENDIF

   Mask := ::PictureMask

	// Store Initial CaretPos

   icp := HiWord ( SendMessage( ::hWnd, EM_GETSEL , 0 , 0 ) )

	// Get Current Content

   InBuffer := ::GetText()

	// RL 104

	If Left ( AllTrim(InBuffer) , 1 ) == '-' .And. Val(InBuffer) == 0
		// Tone (1000,1)
		NegativeZero := .T.
	EndIf

   If ::lDot

		// Point Count For Numeric InputMask

		For x := 1 To Len ( InBuffer )
			CB := SubStr (InBuffer , x , 1 )
			If CB == '.'
			     pc++
			EndIf
		Next x

		// RL 89
		If left (InbuFfer,1) == '.'
			pFlag := .T.
		EndIf
		//

		// Find First Non-Blank Position

		For x := 1 To Len ( InBuffer )
			CB := SubStr (InBuffer , x , 1 )
			If CB != ' '
				fnb := x
				Exit
			EndIf
		Next x

	EndIf

	//

	BackInBuffer := InBuffer

	OldChar := SubStr ( InBuffer , icp+1 , 1 )

	If Len ( InBuffer ) < Len ( Mask )

		InBufferLeft := Left ( InBuffer , icp )

		InBufferRight := Right ( InBuffer , Len (InBuffer) - icp )

   // JK

                if CharMaskTekstOK(InBufferLeft + ' ' + InBufferRight,Mask) .and. CharMaskTekstOK(InBufferLeft + InBufferRight,Mask)==.f.
                  InBuffer := InBufferLeft + ' ' + InBufferRight
              else
                   InBuffer := InBufferLeft +InBufferRight
                endif

	EndIf

	If Len ( InBuffer ) > Len ( Mask )

		InBufferLeft := Left ( InBuffer , icp )

		InBufferRight := Right ( InBuffer , Len (InBuffer) - icp - 1 )

		InBuffer := InBufferLeft + InBufferRight

	EndIf

	// Process Mask

	For x := 1 To Len (Mask)

		CB := SubStr (InBuffer , x , 1 )
		CM := SubStr (Mask , x , 1 )

		Do Case
// JK
			Case (CM) == 'A' .or. (CM) == '!'

			        If IsAlpha ( CB ) .Or. CB == ' '

                                        if (CM)=="!"
                                           OutBuffer := OutBuffer + UPPER(CB)
                                        else
                                           OutBuffer := OutBuffer + CB
                                        endif

				Else

					if x == icp
						BadEntry := .T.
						OutBuffer := OutBuffer + OldChar
					Else
						OutBuffer := OutBuffer + ' '
					EndIf

				EndIf

			Case CM == '9'

				If IsDigit ( CB ) .Or. CB == ' ' .Or. ( CB == '-' .And. x == fnb .And. Pcount() > 1 )

					OutBuffer := OutBuffer + CB

				Else

					if x == icp
						BadEntry := .T.
						OutBuffer := OutBuffer + OldChar
					Else
						OutBuffer := OutBuffer + ' '
					EndIf

				EndIf

			Case CM == ' '

				If CB == ' '

					OutBuffer := OutBuffer + CB

				Else

					if x == icp
						BadEntry := .T.
						OutBuffer := OutBuffer + OldChar
					Else
						OutBuffer := OutBuffer + ' '
					EndIf

				EndIf


			OtherWise

				OutBuffer := OutBuffer + CM

		End Case

	Next x

	// Replace Content

	If ! ( BackInBuffer == OutBuffer )
      ::SetText( OutBuffer )
	EndIf

	If pc > 1

		// RL 104

		If NegativeZero == .T.

			// Tone (1000,1)

         Output := Transform ( ::GetNumFromText() , Mask )

			Output := Right (Output , ol - 1 )

			Output := '-' + Output

			// Replace Text

         ::SetText( Output )
               SendMessage( ::hWnd, EM_SETSEL , at('.',OutBuffer) + dc , at('.',OutBuffer) + dc )

		Else

         ::SetText( Transform ( ::GetNumFromText() , Mask ) )
               SendMessage( ::hWnd, EM_SETSEL , at('.',OutBuffer) + dc , at('.',OutBuffer) + dc )

		EndIf

	Else

		If pFlag == .T.
         ncp := at ( '.' , ::GetText() )
         SendMessage( ::hWnd, EM_SETSEL , ncp , ncp )

		Else

			// Restore Initial CaretPos

			If BadEntry
	      			icp--
			EndIf

               SendMessage( ::hWnd, EM_SETSEL , icp , icp )

			// Skip Protected Characters

			For x := 1 To Len (OutBuffer)

				CB := SubStr ( OutBuffer , icp+x , 1 )
				CM := SubStr ( Mask , icp+x , 1 )

				If ( .Not. IsDigit(CB) ) .And. ( .Not. IsAlpha(CB) ) .And. ( ( .Not. CB = ' ' ) .or. ( CB == ' ' .and. CM == ' ' ) )
                     SendMessage( ::hWnd, EM_SETSEL , icp+x , icp+x )
				Else
					Exit
				EndIf

			Next x

		EndIf

	EndIf

RETURN nil

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TTextMasked
*------------------------------------------------------------------------------*

   IF VALTYPE( uValue ) $ "CN"
      If GetFocus() == ::hWnd
         ::SetText( Transform( uValue , ::PictureMask ) )
		Else
         ::SetText( Transform( uValue , ::Picture ) )
		EndIf
      uValue := ::Value
   ENDIF
   IF "E" $ ::Picture
      uValue := ::GetText()
      If "." $ ::Picture
         Do Case
            Case At ( '.' , uValue ) >  At ( ',' , uValue )
               uValue :=  ::GetNumFromText()
            Case At ( ',' , uValue ) > At ( '.' , uValue )
               uValue :=  ::GetNumFromTextSp()
         EndCase
      Else
         Do Case
            Case At ( '.' , uValue ) !=  0
               uValue := ::GetNumFromTextSp()
            Case At ( ',' , uValue )  != 0
               uValue := ::GetNumFromText()
            OtherWise
               uValue := ::GetNumFromText()
         EndCase
      EndIf
   ELSE
      uValue := ::GetNumFromText()
   ENDIF
RETURN uValue

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TTextMasked
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
Local tmpstr, ts

   if Hi_wParam == EN_KILLFOCUS

         ::lAllow := .F.

         IF "E" $ ::Picture

            Ts := ::GetText()

            If "." $ ::PictureMask
               Do Case
                  Case At ( '.' , Ts ) >  At ( ',' , Ts )
                     ::SetText( Transform ( ::GetNumFromText()  , ::Picture ) )
                  Case At ( ',' , Ts ) > At ( '.' , Ts )
                     ::SetText( Transform ( ::GetNumFromTextSp()  , ::Picture ) )
               EndCase
            Else
               Do Case
                  Case At ( '.' , Ts ) !=  0
                     ::SetText( Transform ( ::GetNumFromTextSp() , ::Picture ) )
                  Case At ( ',' , Ts )  != 0
                     ::SetText( Transform ( ::GetNumFromText() , ::Picture ) )
                  OtherWise
                     ::SetText( Transform ( ::GetNumFromText() , ::Picture ) )
               EndCase
            EndIf
         ELSE
            ::SetText( Transform ( ::GetNumFromText() , ::Picture ) )
         ENDIF

      If _OOHG_InteractiveCloseStarted != .T.
         ::DoEvent( ::OnLostFocus )
      EndIf

      Return nil

   elseif Hi_wParam == EN_SETFOCUS

         IF "E" $ ::Picture

            Ts := ::GetText()

            If "." $ ::Picture
               Do Case
                  Case At ( '.' , Ts ) >  At ( ',' , Ts )
                     ::SetText( Transform ( ::GetNumFromText() , ::PictureMask ) )
                  Case At ( ',' , Ts ) > At ( '.' , Ts )
                     TmpStr := Transform ( ::GetNumFromTextSP() , ::PictureMask )
                     If Val ( TmpStr ) == 0
                        TmpStr := StrTran ( TmpStr , '0.' , ' .' )
                     EndIf
                     ::SetText( TmpStr )
               EndCase
            Else
               Do Case
                  Case At ( '.' , Ts ) !=  0
                     ::SetText( Transform ( ::GetNumFromTextSP() , ::PictureMask ) )
                  Case At ( ',' , Ts )  != 0
                     ::SetText( Transform ( ::GetNumFromText() , ::PictureMask ) )
                  OtherWise
                     ::SetText( Transform ( ::GetNumFromText() , ::PictureMask ) )
               EndCase
            EndIf
         ELSE
            TmpStr := Transform ( ::GetNumFromText() , ::PictureMask )

            If Val ( TmpStr ) == 0
               TmpStr := StrTran ( TmpStr , '0.' , ' .' )
            EndIf

            ::SetText( TmpStr )
         ENDIF

         SendMessage( ::hWnd, EM_SETSEL , 0 , -1 )

         ::lAllow := .T.

      ::DoEvent( ::OnGotFocus )

      Return nil

   Endif

Return ::Super:Events_Command( wParam )

*-----------------------------------------------------------------------------*
METHOD GetNumFromText() CLASS TTextMasked
*-----------------------------------------------------------------------------*
Local x , c , s
Local Text := ::GetText()

	s := ''

	For x := 1 To Len ( Text )

		c := SubStr(Text,x,1)

		If c='0' .or. c='1' .or. c='2' .or. c='3' .or. c='4' .or. c='5' .or. c='6' .or. c='7' .or. c='8' .or. c='9' .or. c='.' .or. c='-'
			s := s + c
		EndIf

	Next x

	If Left ( AllTrim(Text) , 1 ) == '(' .OR.  Right ( AllTrim(Text) , 2 ) == 'DB'
		s := '-' + s
	EndIf

   s := Transform ( Val(s) , ::PictureMask )

Return Val(s)

*------------------------------------------------------------------------------*
METHOD GETNumFromTextSP() CLASS TTextMasked
*------------------------------------------------------------------------------*
Local x , c , s
Local Text := ::GetText()

	s := ''

	For x := 1 To Len ( Text )

		c := SubStr(Text,x,1)

		If c='0' .or. c='1' .or. c='2' .or. c='3' .or. c='4' .or. c='5' .or. c='6' .or. c='7' .or. c='8' .or. c='9' .or. c=',' .or. c='-' .or. c = '.'

			if c == '.'
				c :=''
			endif

			IF C == ','
				C:= '.'
			ENDIF

			s := s + c

		EndIf

	Next x

	If Left ( AllTrim(Text) , 1 ) == '(' .OR.  Right ( AllTrim(Text) , 2 ) == 'DB'
		s := '-' + s
	EndIf

   s := Transform ( Val(s) , ::PictureMask )

Return Val(s)


*-----------------------------------------------------------------------------*
Function _DefineMaskedTextbox ( ControlName, ParentForm, x, y, inputmask , width , value , fontname, fontsize , tooltip , lostfocus ,gotfocus , change , height , enter , rightalign  , HelpId , Format , bold, italic, underline, strikeout , field  , backcolor , fontcolor , readonly  , invisible , notabstop )
*-----------------------------------------------------------------------------*
Local i, c
Local Self

// AJ
Local ControlHandle

* Unused Parameters
RightAlign := NIL
*

	if valtype(Format) == "U"
		Format := ""
	endif

	For i := 1 To Len (InputMask)

		c := SubStr ( InputMask , i , 1 )

        	if c!='9' .and.  c!='$' .and. c!='*' .and. c!='.' .and. c!= ','  .and. c != ' ' .and. c!='€'
         MsgOOHGError("@...TEXTBOX: Wrong InputMask Definition" )
		EndIf

	Next i

	For i := 1 To Len (Format)

		c := SubStr ( Format , i , 1 )

        	if c!='C' .and. c!='X' .and. c!= '('  .and. c!= 'E'
         MsgOOHGError("@...TEXTBOX: Wrong Format Definition" )
		EndIf

	Next i

	if valtype(change) == "U"
		change := ""
	endif

	if valtype(gotfocus) == "U"
		gotfocus := ""
	endif

	if valtype(enter) == "U"
		enter := ""
	endif

	if valtype(lostfocus) == "U"
		lostfocus := ""
	endif

	if valtype(Width) == "U"
		Width := 120
	endif

	if valtype(height) == "U"
		height := 24
	endif

	If .Not. Empty (Format)
		Format := '@' + AllTrim(Format)
	EndIf

	InputMask :=  Format + ' ' + InputMask

   Self := TTextMasked():SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T. )

   If ValType( Field ) == 'C' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      Value := EVAL( ::Block )
	EndIf

	if valtype(Value) == "U"
		Value := ""
	endif

	Value := Transform ( value , InputMask )

   ControlHandle := InitMaskedTextBox ( ::Parent:hWnd, 0, x, y, width , '' , 0  , 255 , .f. , .f. , height , .t. , readonly  , invisible , notabstop )

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, Width, Height )

   ::Picture :=   InputMask
   ::PictureMask :=  GetNumMask ( InputMask )
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change
   ::OnDblClick := enter
   ::lAllow := .F.

   ::SetText( value )

	if valtype ( Field ) != 'U'
      aAdd ( ::Parent:BrowseList, Self )
	EndIf

Return Nil

Function GetNumMask ( Text )
Local i , c , s

	s := ''

	For i := 1 To Len ( Text )

		c := SubStr(Text,i,1)

		If c='9' .or. c='.'
			s := s + c
		EndIf

		if c = '$' .or. c = '*'
			s := s+'9'
		EndIf

	Next i

Return s










*-----------------------------------------------------------------------------*
CLASS TTextCharMask FROM TTextMasked
*-----------------------------------------------------------------------------*
   DATA Type          INIT "CHARMASKTEXT" READONLY
   DATA lDate         INIT .F.
   DATA lAllow        INIT .T.
   DATA lDot          INIT .F.

   METHOD Value       SETGET
   METHOD SetFocus
   METHOD Events_Command
ENDCLASS

*-----------------------------------------------------------------------------*
Function _DefineCharMaskTextbox ( ControlName, ParentForm, x, y, inputmask , width , value , fontname, fontsize , tooltip , lostfocus ,gotfocus , change , height , enter , rightalign  , HelpId , bold, italic, underline, strikeout , field  , backcolor , fontcolor , date , readonly  , invisible , notabstop )
*-----------------------------------------------------------------------------*
Local dateformat
Local Self

// AJ
Local ControlHandle

	if valtype(date) == "U"
		date := .F.
	endif

	if valtype(change) == "U"
		change := ""
	endif

	if valtype(gotfocus) == "U"
		gotfocus := ""
	endif

	if valtype(enter) == "U"
		enter := ""
	endif

	if valtype(lostfocus) == "U"
		lostfocus := ""
	endif

	if valtype(Width) == "U"
		Width := 120
	endif

	if valtype(height) == "U"
		height := 24
	endif

	dateformat := set ( _SET_DATEFORMAT )

	if date == .t.
		if lower ( left ( dateformat , 4 ) ) == "yyyy"

			if '/' $ dateformat
				Inputmask := '9999/99/99'
			Elseif '.' $ dateformat
				Inputmask := '9999.99.99'
			Elseif '-' $ dateformat
				Inputmask := '9999-99-99'
			EndIf

		elseif lower ( right ( dateformat , 4 ) ) == "yyyy"

			if '/' $ dateformat
				Inputmask := '99/99/9999'
			Elseif '.' $ dateformat
				Inputmask := '99.99.9999'
			Elseif '-' $ dateformat
				Inputmask := '99-99-9999'
			EndIf

		else

			if '/' $ dateformat
				Inputmask := '99/99/99'
			Elseif '.' $ dateformat
				Inputmask := '99.99.99'
			Elseif '-' $ dateformat
				Inputmask := '99-99-99'
			EndIf

		endif
	endif

   Self := TTextCharMask():SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T. )

   If ValType( Field ) == 'C' .AND. ! empty( Field )
      ::VarName := alltrim( Field )
      ::Block := &( "{ |x| if( PCount() == 0, " + Field + ", " + Field + " := x ) }" )
      Value := EVAL( ::Block )
	EndIf

	if valtype(Value) == "U"
		if date == .F.
			Value := ""
		else
			Value := ctod ('  /  /  ')
		endif
	endif

   ControlHandle := InitCharMaskTextBox ( ::Parent:hWnd, 0, x, y, width , '' , 0  , 255 , .f. , .f. , height , rightalign , readonly  , invisible , notabstop )

   ::New( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, Width, Height )

   ::PictureMask := InputMask
   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change
   ::OnDblClick := enter
   ::lDate := date

   if ! date
      ::SetText( Value  )
	Else
      ::SetText( dtoc ( Value ) )
	endif

	if valtype ( Field ) != 'U'
      aAdd ( ::Parent:BrowseList, Self )
	EndIf

Return Nil

*------------------------------------------------------------------------------*
Function CharMaskTekstOK(cString,cMask)
*------------------------------------------------------------------------------*

Local lPassed:=.f.,CB,CM,x
For x := 1 To min(Len(cString),Len(cMask))
		CB := SubStr ( cString , x , 1 )
		CM := SubStr ( cMask , x , 1 )
	Do Case
		// JK
			Case (CM) == 'A' .or. (CM) == '!'
			        If IsAlpha ( CB ) .Or. CB == ' '
                                        lPassed:=.t.
				Else
				        lPassed:=.f.
                                        Return lPassed
				EndIf
			Case CM == '9'
				If IsDigit ( CB ) .Or. CB == ' '
					lPassed:=.t.
				Else
                                        lPassed:=.f.
                                        Return lPassed
				EndIf
			Case CM == ' '
				If CB == ' '
					lPassed:=.t.
				Else
				        lPassed:=.f.
                                        Return lPassed
				EndIf
			OtherWise
				lPassed:=.t.
		End Case
next i
Return lPassed

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TTextCharMask
*------------------------------------------------------------------------------*

   IF ::lDate
      IF VALTYPE( uValue ) == "D"
         ::TopValue := RTrim( dToc( uValue ) )
      ELSE
         uValue := cTod( AllTrim( ::TopValue ) )
      ENDIF
   ELSE
      uValue := ( ::TopValue := uValue )
   ENDIF

RETURN uValue

*------------------------------------------------------------------------------*
METHOD SetFocus() CLASS TTextCharMask
*------------------------------------------------------------------------------*
Local x, MaskStart
Local uRet

   uRet := ::Super:SetFocus()

   For x := 1 To Len ( ::PictureMask )
      If SubStr( ::PictureMask , x , 1 ) $ "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!"
         MaskStart := x
         Exit
      EndIf
   Next x

   If MaskStart == 1
      SendMessage( ::hWnd, EM_SETSEL , 0 , -1 )
   Else
      SendMessage( ::hWnd, EM_SETSEL , MaskStart - 1 , -1 )
   EndIf
Return uRet

*------------------------------------------------------------------------------*
METHOD Events_Command( wParam ) CLASS TTextCharMask
*------------------------------------------------------------------------------*
Local Hi_wParam := HIWORD( wParam )
Local x, maskstart

   if Hi_wParam == EN_KILLFOCUS

         if ::lDate
            _OOHG_DateTextBoxActive := .T.
            ::SetText( dtoc ( ctod ( ::GetText() ) ) )
         EndIf

      If _OOHG_InteractiveCloseStarted != .T.
         ::DoEvent( ::OnLostFocus )
      EndIf

      Return nil

   elseif Hi_wParam == EN_SETFOCUS

         For x := 1 To Len ( ::PictureMask )
            If IsDigit(SubStr ( ::PictureMask , x , 1 )) .Or. IsAlpha(SubStr ( ::PictureMask , x , 1 )) .Or. SubStr ( ::PictureMask , x , 1 ) == '!'
               MaskStart := x
               Exit
            EndIf
         Next x

         If MaskStart == 1
            SendMessage( ::hWnd, EM_SETSEL , 0 , -1 )
         Else
            SendMessage( ::hWnd, EM_SETSEL , MaskStart - 1 , -1 )
         EndIf

      ::DoEvent( ::OnGotFocus )

      Return nil

   Endif

Return ::Super:Events_Command( wParam )