/*
 * $Id: h_help.prg,v 1.7 2016-05-22 23:53:22 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG help files functions
 *
 * Copyright 2005-2016 Vicente Guerra <vicente@guerra.com.mx>
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
#include "fileio.ch"

STATIC _OOHG_ActiveHelpFile := ""
*STATIC _OOHG_nTopic         := 0
*STATIC _OOHG_nMet           := 0

*-------------------------------------------------------------
Function SetHelpFile( cFile )
*-------------------------------------------------------------
LOCAL hFile

   _OOHG_ActiveHelpFile := ""

   if ! File( cFile )
      MsgInfo( "Help File " + cFile + " Not Found " )
      Return .F.
   endif

   hFile := FOpen( cFile, FO_READ + FO_SHARED )

   If FError() != 0
      MsgInfo( "Error opening Help file. DOS ERROR: " + Str( FError(), 2, 0 ) )
      Return .F.
   EndIf

   _OOHG_ActiveHelpFile := cFile

	FClose( hFile )

Return .T.

*-------------------------------------
Function HelpTopic( nTopic , nMet )
*-------------------------------------
Local ret:=0

   If ! empty( _OOHG_ActiveHelpFile )

      if !HB_IsNumeric( nTopic )
         nTopic := 0
      endif
      if !HB_IsNumeric( nMet )
         nMet := 0
      endif

*      _OOHG_nTopic := nTopic
*      _OOHG_nMet   := nMet

      if UPPER( Right( ALLTRIM( _OOHG_ActiveHelpFile ), 4 ) ) == '.CHM'
         ret := WinHelp( _OOHG_Main:hWnd, _OOHG_ActiveHelpFile, 0, nMet, nTopic )
      else
         ret := WinHelp( _OOHG_Main:hWnd, _OOHG_ActiveHelpFile, 1, nMet, nTopic )
      endif
   endif
Return ret

*-------------------------------------------------------------
Function GetActiveHelpFile()
*-------------------------------------------------------------
Return _OOHG_ActiveHelpFile

EXTERN WINHELP, WINHLP

#pragma BEGINDUMP
#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"
#if ! defined( __MINGW32__ )
   #include <Htmlhelp.h>
#endif
#include <commctrl.h>
#include "oohg.h"

HB_FUNC( WINHELP )
{
   DWORD context;
   UINT styl;
   BOOL rezult;

   switch( hb_parni( 4 ) )
   {
//      case 0:  styl = HELP_CONTENTS ;     context = 0 ;             break;
      case 0:  styl = HELP_FINDER ;       context = 0 ;             break;
      case 1:  styl = HELP_CONTEXT ;      context = hb_parni( 5 ) ; break;
      case 2:  styl = HELP_CONTEXTPOPUP ; context = hb_parni( 5 ) ; break;
      default: styl = HELP_CONTENTS ;     context = 0 ;             break;
   }

   if( hb_parni( 3 ) )
   {
//      HtmlHelp( HWNDparam( 1 ),  hb_parc( 2 ), HH_DISPLAY_TOPIC    ,0);
      rezult = WinHelp( HWNDparam( 1 ), ( LPCTSTR ) hb_parc( 2 ), styl, context );
   }
   else
   {
      rezult = WinHelp( HWNDparam( 1 ), ( LPCTSTR ) hb_parc( 2 ), styl, context );
   }
   hb_retni( rezult );
}

HB_FUNC( WINHLP )
{
   HB_FUNCNAME( WINHELP )();
}
#pragma ENDDUMP
