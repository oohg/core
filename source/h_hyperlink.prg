/*
 * $Id: h_hyperlink.prg $
 */
/*
 * ooHG source code:
 * HyperLink control
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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
#include "hbclass.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS THyperLink FROM TLabel

   DATA Type                      INIT "HYPERLINK" READONLY
   DATA URL                       INIT ""

   METHOD Define
   METHOD Address                 SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, cCaption, cURL, nWidth, nHeight, cFontName, nFontSize, lBold, lBorder, ;
               lClientEdge, lHScroll, lVScroll, lTransparent, aRGB_bk, aRGB_font, cToolTip, nHelpId, lInvisible, lItalic, ;
               lAutoSize, lHandCursor, lRtl ) CLASS THyperLink

   ASSIGN cURL        VALUE cURL        TYPE "CM" DEFAULT "https://oohg.github.io/"
   ASSIGN cCaption    VALUE cCaption    TYPE "CM" DEFAULT "oohg at github"
   ASSIGN aRGB_font   VALUE aRGB_font   TYPE "A"  DEFAULT BLUE
   ASSIGN lHandCursor VALUE lHandCursor TYPE "L"  DEFAULT .F.

   ::Super:Define( cControlName, uParentForm, nCol, nRow, cCaption, nWidth, nHeight, cFontName, ;
                   nFontSize, lBold, lBorder, lClientEdge, lHScroll, lVScroll, lTransparent, ;
                   aRGB_bk, aRGB_font, NIL, cToolTip, nHelpId, lInvisible, lItalic, .T., .F., ;
                   lAutoSize, .F., .F., lRtl, .F., .F., NIL, .F., .F., NIL )

   ::Address := cURL

   IF lHandCursor
      ::Cursor := IDC_HAND
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Address( cUrl ) CLASS THyperLink

   IF ValType( cUrl ) $ "CM"
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
