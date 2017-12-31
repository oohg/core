/*
* $Id: h_help.prg $
*/
/*
* ooHG source code:
* Help files functions
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
#include "fileio.ch"

STATIC _OOHG_ActiveHelpFile := ""

FUNCTION SetHelpFile( cFile )

   LOCAL hFile

   _OOHG_ActiveHelpFile := ""

   IF ! File( cFile )
      MsgInfo( "Help File " + cFile + " Not Found " )

      RETURN .F.
   ENDIF

   hFile := FOpen( cFile, FO_READ + FO_SHARED )

   IF FError() != 0
      MsgInfo( "Error opening Help file. DOS ERROR: " + Str( FError(), 2, 0 ) )

      RETURN .F.
   ENDIF

   _OOHG_ActiveHelpFile := cFile

   FClose( hFile )

   RETURN .T.

FUNCTION HelpTopic( nTopic , nMet )

   LOCAL ret:=0

   IF ! empty( _OOHG_ActiveHelpFile )

      IF !HB_IsNumeric( nTopic )
         nTopic := 0
      ENDIF
      IF !HB_IsNumeric( nMet )
         nMet := 0
      ENDIF

      IF UPPER( Right( ALLTRIM( _OOHG_ActiveHelpFile ), 4 ) ) == '.CHM'
         ret := WinHelp( _OOHG_Main:hWnd, _OOHG_ActiveHelpFile, 0, nMet, nTopic )
      ELSE
         ret := WinHelp( _OOHG_Main:hWnd, _OOHG_ActiveHelpFile, 1, nMet, nTopic )
      ENDIF
   ENDIF

   RETURN ret

FUNCTION GetActiveHelpFile()

   RETURN _OOHG_ActiveHelpFile

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
