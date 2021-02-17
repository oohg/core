/*
 * $Id: h_zip.prg $
 */
/*
 * ooHG source code:
 * HMG zip and unzip functions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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


PROCEDURE HMG_UNZIPFILE ( zipfile , block , extractpath )

   Local objZip
   Local Count
   Local objItem
   Local i

   #ifndef __XHARBOUR__
      IF ( objZip := win_oleCreateObject( "XStandard.Zip" ) ) == NIL
         MsgStop( "Zip interfase is not available, error: " + win_oleErrorText(), "Error" )
         RETURN
      ENDIF
   #else
      objZip := TOleAuto():New( "XStandard.Zip" )
      IF Ole2TxtError() != "S_OK"
         MsgStop( "Zip interfase is not available.","Error" )
         RETURN
      ENDIF
   #endif

   Count := objZip:Contents(zipfile):Count

   For i := 1 To Count

      objItem := objZip:Contents(zipfile):Item(i)

      if valtype (block) = 'B'
         Eval ( block , objItem:Name , i )
      endif

      objZip:UnPack( zipfile , extractpath , objItem:Name )

   Next i

   RETURN

PROCEDURE HMG_ZIPFILE( zipfile , afiles , level , block , ovr )

   LOCAL oZip
   LOCAL I

   oZip:=TOleAuto():New( "XStandard.Zip")

   if ovr == .t.
      if file (zipfile)
         delete file (zipfile)
      endif
   endif

   For i := 1 To Len (afiles)
      Eval ( block , aFiles [i] , i )
      oZip:pack( afiles [i] , zipfile , , , level )
   Next i

   RETURN
