/*
* $Id: h_editbox.prg $
*/
/*
* ooHG source code:
* EditBox control
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

CLASS TEdit FROM TText

   DATA Type             INIT "EDIT" READONLY
   DATA nOnFocusPos      INIT -4
   DATA OnHScroll        INIT Nil
   DATA OnVScroll        INIT Nil
   DATA nWidth           INIT 120
   DATA nHeight          INIT 240

   METHOD Define
   METHOD LookForKey
   METHOD Events_Command
   METHOD Events_Enter   BLOCK { || Nil }

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
      fontsize, tooltip, maxlength, gotfocus, change, lostfocus, ;
      readonly, break, HelpId, invisible, notabstop, bold, italic, ;
      underline, strikeout, field, backcolor, fontcolor, novscroll, ;
      nohscroll, lRtl, lNoBorder, OnFocusPos, OnHScroll, OnVScroll, ;
      lDisabled ) CLASS TEdit

   LOCAL nStyle := ES_MULTILINE + ES_WANTRETURN, nStyleEx := 0

   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   nStyle += IF( HB_IsLogical( novscroll ) .AND. novscroll, ES_AUTOVSCROLL, WS_VSCROLL ) + ;
      IF( HB_IsLogical( nohscroll ) .AND. nohscroll, 0,              WS_HSCROLL )

   ::SetSplitBoxInfo( Break )

   ::Define2( ControlName, ParentForm, x, y, ::nWidth, ::nHeight, value, ;
      fontname, fontsize, tooltip, maxlength, .f., ;
      lostfocus, gotfocus, change, nil, .f., HelpId, ;
      readonly, bold, italic, underline, strikeout, field, ;
      backcolor, fontcolor, invisible, notabstop, nStyle, lRtl, ;
      .F., nStyleEx, lNoBorder, OnFocusPos, lDisabled )

   ASSIGN ::OnHScroll VALUE OnHScroll TYPE "B"
   ASSIGN ::OnVScroll VALUE OnVScroll TYPE "B"

   RETURN Self

METHOD LookForKey( nKey, nFlags ) CLASS TEdit

   LOCAL lDone

   lDone := ::Super:LookForKey( nKey, nFlags )
   IF nKey == VK_ESCAPE .and. nFlags == 0
      lDone := .T.
   ENDIF

   RETURN lDone

METHOD Events_Command( wParam ) CLASS TEdit

   LOCAL Hi_wParam := HiWord( wParam )

   IF Hi_wParam == EN_HSCROLL
      ::DoEvent( ::OnHScroll, "HSCROLL" )

      RETURN NIL

   ELSEIF Hi_wParam == EN_VSCROLL
      ::DoEvent( ::OnVScroll, "VSCROLL" )

      RETURN NIL
   ENDIF

   RETURN ::Super:Events_Command( wParam )
