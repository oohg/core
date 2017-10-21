/*
 * $Id: h_scrsaver.prg,v 1.10 2017-10-01 15:52:27 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Screen saver functions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
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
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
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

Memvar _ActiveScrSaverName
Memvar _ScrSaverInstall
Memvar _ScrSaverFileName
Memvar _ScrSaverShow
Memvar _ScrSaverConfig

#define WM_SYSCOMMAND 274     // &H112
#define SC_SCREENSAVE 61760   // &HF140

#define SPI_SCREENSAVERRUNNING 97

#define MsgInfo( c ) MsgInfo( c, "Information" )

Function _BeginScrSaver( cSSaver, lNoShow, cInit, cRelease, cPaint, nTimer, aBackClr )

   Local a := {}, x := GetDesktopWidth(), y := GetDesktopHeight(), Dummy := ""

   Public _ActiveScrSaverName := cSSaver
   Public _ScrSaverInstall := .f.
   Public _ScrSaverFileName := 0
   Public _ScrSaverConfig := NIL

   DEFAULT nTimer TO 1
   /* HB_SYMBOL_UNUSED( _OOHG_AllVars ) */

   Set InterActiveClose Off

   IF lNoShow

   DEFINE WINDOW &cSsaver AT 0, 0 ;
      WIDTH x HEIGHT y ;
      MAIN NOSHOW ;
      TOPMOST NOSIZE NOCAPTION ;
      ON GOTFOCUS SetCursorPos(x / 2, y / 2) ;
      ON INIT (ShowCursor(.F.), ;
         SystemParametersInfo( SPI_SCREENSAVERRUNNING, 1, @Dummy, 0 )) ;
      ON RELEASE _ReleaseScrSaver(cRelease, cSSaver, cPaint) ;
      ON MOUSECLICK (IF(_lValidScrSaver(), DoMethod (cSSaver,'Release'), )) ;
      ON MOUSEMOVE (a := GetCursorPos(), IF( a[1] # y / 2 .AND. a[2] # x / 2, ;
         IF(_lValidScrSaver(), DoMethod(cSSaver,'Release') , ), )) ;
         BACKCOLOR aBackClr
   ELSE

   DEFINE WINDOW &cSsaver AT 0, 0 ;
      WIDTH x HEIGHT y ;
      MAIN ;
      TOPMOST NOSIZE NOCAPTION ;
      ON GOTFOCUS SetCursorPos(x / 2, y / 2) ;
      ON INIT (ShowCursor(.F.), ;
         SystemParametersInfo( SPI_SCREENSAVERRUNNING, 1, @Dummy, 0 )) ;
      ON RELEASE _ReleaseScrSaver(cRelease, cSSaver, cPaint) ;
      ON MOUSECLICK (IF(_lValidScrSaver(), DoMethod(cSSaver,'Release')  , )) ;
      ON MOUSEMOVE (a := GetCursorPos(), IF( a[1] # y / 2 .AND. a[2] # x / 2, ;
         IF(_lValidScrSaver(), DoMethod(cSSaver,'Release'), ), )) ;
         BACKCOLOR aBackClr
   ENDIF

   IF cPaint # NIL
      DEFINE TIMER Timer_SSaver ;
         INTERVAL nTimer * 1000 ;
         ACTION Eval(cPaint)
   ENDIF

   END WINDOW

   IF cInit # NIL

   Eval(cInit)

   ENDIF

   Return Nil

Function _ActivateScrSaver( aForm, cParam )

   Local cFileScr, cFileDes

   DEFAULT cParam TO if( _ScrSaverInstall, "-i", "-s" )

   cParam := Lower( cParam )

   DO CASE
   CASE cParam = "/s" .or. cParam = "-s"

      _ActivateWindow( aForm )

   CASE cParam = "/c" .or. cParam = "-c"

      IF _ScrSaverConfig # NIL
         Eval(_ScrSaverConfig)
      ELSE
         MsgInfo( "This screen saver has no options that you configure." )
      ENDIF

   CASE cParam = "/a" .or. cParam = "-a"

      ChangePassword(GetActiveWindow())

   CASE cParam = "/i" .or. cParam = "-i"

      cFileScr := GetModuleFileName( GetInstance() )
      cFileDes := GetSystemFolder() + "\" + ;
            If( valtype(_ScrSaverFileName) $ "CM", _ScrSaverFileName, ;
            cFileNoExt( cFileScr ) + ".SCR" )

      IF File( cFileDes )
         FErase( cFileDes )
      ENDIF

      Copy File (cFileScr) To (cFileDes)

      IF File( cFileDes )

         IF IsWinXP()
            EXECUTE FILE "Rundll32.exe" ;
               PARAMETERS "desk.cpl,InstallScreenSaver " + ;
               GetSystemFolder() + "\" + cFileNoExt( cFileScr ) + ".SCR"
         ELSE
            BEGIN INI FILE GetWindowsFolder() + "\" + 'system.ini'
               SET SECTION "boot" ENTRY "SCRNSAVE.EXE" TO cFileDes
            END INI
         ENDIF

         MsgInfo( cFileNoPath( cFileDes ) + " installation successfully." )

         IF _ScrSaverShow
            SendMessage( GetFormHandle(_ActiveScrSaverName), WM_SYSCOMMAND, SC_SCREENSAVE )
         ENDIF
      ELSE
         MsgStop( cFileNoPath( cFileDes ) + " installation no successfully.", "Error" )
      ENDIF

   ENDCASE

   Return Nil

Function _ReleaseScrSaver( cRelease, cSSaver, cPaint )

   Local Dummy := ""

   IF cRelease # NIL
      Eval(cRelease)
   ENDIF

   ShowCursor(.T.)

   IF cPaint # NIL
                SetProperty( cSSaver, "Timer_SSaver", "Enabled", .F. )
   ENDIF

   SystemParametersInfo( SPI_SCREENSAVERRUNNING, 0, @Dummy, 0 )

   Return Nil

Function _lValidScrSaver()

   Local oReg, nValue := 1, lRet

   OPEN REGISTRY oReg KEY HKEY_CURRENT_USER ;
      SECTION "Control Panel\Desktop"

   GET VALUE nValue NAME "ScreenSaveUsePassword" OF oReg

   CLOSE REGISTRY oReg

   IF nValue = 0 .AND. !IsWinXP()
      lRet := VerifyPassword(GetActiveWindow())
   ELSE
      lRet := .T.
   ENDIF

   Return lRet

Function IsWinXP()

   Return "XP" $ OS()
