/*
 * $Id: h_editbox.prg $
 */
/*
 * OOHG source code:
 * EditBox control
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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
#include "i_windefs.ch"
#include "hbclass.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TEdit FROM TText

   DATA Type                      INIT "EDIT" READONLY
   DATA nOnFocusPos               INIT -4
   DATA OnHScroll                 INIT Nil
   DATA OnVScroll                 INIT Nil
   DATA nWidth                    INIT 120
   DATA nHeight                   INIT 240

   METHOD Define
   METHOD Events_Command
   METHOD Events_Enter            BLOCK { || NIL }
   METHOD Value                   SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, cParentForm, nCol, nRow, nWidth, nHeight, cValue, cFontName, nFontSize, cToolTip, nMaxLength, ;
               bGotFocus, bChange, bLostFocus, lReadOnly, lBreak, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, lUnderline, ;
               lStrikeout, cField, uBackColor, uFontColor, lNoVScroll, lNoHScroll, lRtl, lNoBorder, nOnFocusPos, bOnHScroll, ;
               bOnVScroll, lDisabled, nInsType, lNoCntxtMnu, lUndo ) CLASS TEdit

   LOCAL nStyle := ES_MULTILINE + ES_WANTRETURN, nStyleEx := 0

   ASSIGN ::nWidth  VALUE nWidth  TYPE "N"
   ASSIGN ::nHeight VALUE nHeight TYPE "N"

   nStyle += iif( HB_ISLOGICAL( lNoVScroll ) .AND. lNoVScroll, ES_AUTOVSCROLL, WS_VSCROLL ) + ;
             iif( HB_ISLOGICAL( lNoHScroll ) .AND. lNoHScroll, 0, WS_HSCROLL )

   ::SetSplitBoxInfo( lBreak )

   ::Define2( cControlName, cParentForm, nCol, nRow, ::nWidth, ::nHeight, cValue, cFontName, nFontSize, cToolTip, nMaxLength, .F., ;
              bLostFocus, bGotFocus, bChange, NIL, .F., nHelpId, lReadOnly, lBold, lItalic, lUnderline, lStrikeout, ;
              cField, uBackColor, uFontColor, lInvisible, lNoTabStop, nStyle, lRtl, .F., nStyleEx, lNoBorder, ;
              nOnFocusPos, lDisabled, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, nInsType, ;
              .F., lNoCntxtMnu, NIL, NIL, NIL, lUndo )

   ASSIGN ::OnHScroll VALUE bOnHScroll TYPE "B"
   ASSIGN ::OnVScroll VALUE bOnVScroll TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Command( wParam ) CLASS TEdit

   LOCAL Hi_wParam := HIWORD( wParam )

   IF Hi_wParam == EN_HSCROLL
      ::DoEvent( ::OnHScroll, "HSCROLL" )
      RETURN NIL

   ELSEIF Hi_wParam == EN_VSCROLL
      ::DoEvent( ::OnVScroll, "VSCROLL" )
      RETURN NIL
   ENDIF

   RETURN ::Super:Events_Command( wParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( uValue ) CLASS TEdit

   LOCAL cRet

   IF ValType( uValue ) $ "CM"
      cRet := ::xStartValue := ::Caption := RTrim( uValue )
      ::DoChange()
   ELSE
      cRet := ::Caption
   ENDIF

   RETURN cRet
