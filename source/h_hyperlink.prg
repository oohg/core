/*
* $Id: h_hyperlink.prg $
*/
/*
* ooHG source code:
* HyperLink control
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
#include "hbclass.ch"

CLASS THyperLink FROM TLabel

   DATA Type        INIT "HYPERLINK" READONLY
   DATA URL         INIT ""

   METHOD Define
   METHOD Address   SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, Caption, url, w, h, fontname, ;
      fontsize, bold, BORDER, CLIENTEDGE, HSCROLL, VSCROLL, ;
      TRANSPARENT, aRGB_bk, aRGB_font, tooltip, HelpId, invisible, ;
      italic, autosize, handcursor, lRtl ) CLASS THyperLink

   DEFAULT Url           TO "https://oohg.github.io/"
   DEFAULT Caption       TO "oohg at github"
   DEFAULT aRGB_font     TO {0,0,255}
   DEFAULT handcursor    TO .F.

   ::Super:Define( ControlName, ParentForm, x, y, Caption, w, h, fontname, ;
      fontsize, bold, BORDER, CLIENTEDGE, HSCROLL, VSCROLL, ;
      TRANSPARENT, aRGB_bk, aRGB_font, nil, tooltip, ;
      HelpId, invisible, italic, .T., .F., autosize, ;
      .F., .F., lRtl )

   ::Address := url

   IF handcursor
      ::Cursor := IDC_HAND
   ENDIF

   RETURN Self

METHOD Address( cUrl ) CLASS THyperLink

   IF HB_IsString( cUrl )
      IF Left( cUrl, 5 ) == "http:"
         ::OnClick := {|| ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cUrl, , 1 ) }
         ::URL := cUrl
      ELSEIF Left( cUrl, 6 ) == "https:"
         ::OnClick := {|| ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cUrl, , 1 ) }
         ::URL := cUrl
      ELSEIF Left( cUrl, 5 ) == "file:"
         ::OnClick := {|| ShellExecute( 0, "open", "explorer.exe", cUrl, , 1 ) }
         ::URL := cUrl
      ELSEIF Left( cUrl, 7 ) == "mailto:"
         ::OnClick := {|| ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler " + cUrl, , 1 ) }
         ::URL := cUrl
      ELSEIF At( "@", cUrl ) > 0
         ::OnClick := {|| ShellExecute( 0, "open", "rundll32.exe", "url.dll,FileProtocolHandler mailto:" + cUrl, , 1 ) }
         ::URL := cUrl
      ELSE
         MsgOOHGError( "Control: " + ::Name + " must have valid email or url defined. Program terminated." )
      ENDIF
   ENDIF

   RETURN ::URL
