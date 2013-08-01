/*
 * $Id: h_progressbar.prg,v 1.13 2013-08-01 01:27:11 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG progress bar functions
 *
 * Copyright 2005-2009 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TProgressBar FROM TControl
   DATA Type        INIT "PROGRESSBAR" READONLY
   DATA nRangeMin   INIT 0
   DATA nRangeMax   INIT 0
   DATA nVelocity   INIT 30
   DATA lRunning    INIT .F.

   METHOD Define
   METHOD Value               SETGET

   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET
   METHOD FontColor           SETGET
   METHOD BackColor           SETGET
   METHOD SetStyleMarquee
   METHOD SetStyleNormal
   METHOD IsStyleMarquee
   METHOD IsStyleNormal
   METHOD StartMarquee
   METHOD StopMarquee
   METHOD IsMarqueeRunning

   EMPTY( _OOHG_AllVars )
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, lo, hi, tooltip, ;
               vertical, smooth, HelpId, invisible, nValue, BackColor, ;
               BarColor, lRtl, nVelocity ) CLASS TProgressBar
*-----------------------------------------------------------------------------*
Local ControlHandle

   ASSIGN vertical  VALUE vertical  TYPE "L" DEFAULT .F.
   ASSIGN smooth    VALUE smooth    TYPE "L" DEFAULT .F.
   ASSIGN h         VALUE h         TYPE "N" DEFAULT if( vertical, 120, 25 )
   ASSIGN w         VALUE w         TYPE "N" DEFAULT if( vertical, 25, 120 )
   ASSIGN lo        VALUE lo        TYPE "N" DEFAULT 0
   ASSIGN hi        VALUE hi        TYPE "N" DEFAULT 100
   ASSIGN nValue    VALUE nValue    TYPE "N" DEFAULT 0
   ASSIGN invisible VALUE invisible TYPE "L" DEFAULT .F.

   ::SetForm( ControlName, ParentForm,,, BarColor, BackColor,, lRtl  )

   ControlHandle := InitProgressBar ( ::ContainerhWnd, 0, x, y, w, h ,lo ,hi, vertical, smooth, invisible, nValue, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId, ! Invisible, ToolTip )
   ::SizePos( y, x, w, h )

   ::nRangeMin := Lo
   ::nRangeMax := Hi

   if ::BackColor <> Nil
      SetProgressBarBkColor( ControlHandle, ::BackColor[1], ::BackColor[2], ::BackColor[3] )
   endif

   if ::FontColor <> Nil
      SetProgressBarBarColor( ControlHandle, ::FontColor[1], ::FontColor[2], ::FontColor[3] )
   endif

   if HB_IsNumeric( nVelocity )
      ::nVelocity := nVelocity
       
      ::SetStyleMarquee( nVelocity )
   endif

Return Self

*------------------------------------------------------------------------------*
METHOD SetStyleMarquee( nVelocity ) CLASS TProgressBar
*------------------------------------------------------------------------------*

   if ! IsWindowStyle( ::hWnd, PBS_MARQUEE )
     ::Style( ::Style() + PBS_MARQUEE )
   endif

   if HB_IsNumeric( nVelocity ) .and. nVelocity > 0
      ::nVelocity := nVelocity

      ::StartMarquee()
   else
      ::StopMarquee()
   endif

Return Nil

*------------------------------------------------------------------------------*
METHOD SetStyleNormal( uValue ) CLASS TProgressBar
*------------------------------------------------------------------------------*

   if IsWindowStyle( ::hWnd, PBS_MARQUEE )
      ::StopMarquee()

      ::Style( ::Style() - PBS_MARQUEE )
      
      if ! HB_IsNumeric( uValue ) .or. uValue < 0
        uValue := 0
      endif
      
      ::value := uValue
   endif

Return Nil

*------------------------------------------------------------------------------*
METHOD IsStyleMarquee() CLASS TProgressBar
*------------------------------------------------------------------------------*

Return IsWindowStyle( ::hWnd, PBS_MARQUEE )

*------------------------------------------------------------------------------*
METHOD IsStyleNormal() CLASS TProgressBar
*------------------------------------------------------------------------------*

Return ! IsWindowStyle( ::hWnd, PBS_MARQUEE )

*------------------------------------------------------------------------------*
METHOD StartMarquee() CLASS TProgressBar
*------------------------------------------------------------------------------*

   if IsWindowStyle( ::hWnd, PBS_MARQUEE )
      if ! ::lRunning
         ::lRunning := .T.
         
         if ::nVelocity <= 0
            ::nVelocity := 30
         endif

         // 1 => start
         SendMessage( ::hWnd, PBM_SETMARQUEE, 1, ::nVelocity )
      endif
   endif

Return Nil

*------------------------------------------------------------------------------*
METHOD StopMarquee() CLASS TProgressBar
*------------------------------------------------------------------------------*

   if IsWindowStyle( ::hWnd, PBS_MARQUEE )
      if ::lRunning
        ::lRunning := .F.
        
         if ::nVelocity <= 0
            ::nVelocity := 30
         endif

         // 0 => stop
         SendMessage( ::hWnd, PBM_SETMARQUEE, 0, ::nVelocity )
      endif
   endif

Return Nil

*------------------------------------------------------------------------------*
METHOD IsMarqueeRunning() CLASS TProgressBar
*------------------------------------------------------------------------------*

Return ::lRunning

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TProgressBar
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( uValue )
      SendMessage( ::hWnd, PBM_SETPOS, uValue, 0 )
   ENDIF
RETURN SendMessage( ::hWnd, PBM_GETPOS, 0, 0)

*------------------------------------------------------------------------------*
METHOD RangeMin( uValue ) CLASS TProgressBar
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( uValue )
      ::nRangeMin := uValue
      SetProgressBarRange( ::hWnd, uValue, ::nRangeMax )
   ENDIF
RETURN ::nRangeMin

*------------------------------------------------------------------------------*
METHOD RangeMax( uValue ) CLASS TProgressBar
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( uValue )
      ::nRangeMax := uValue
      SetProgressBarRange( ::hWnd, ::nRangeMin, uValue )
   ENDIF
RETURN ::nRangeMax

*------------------------------------------------------------------------------*
METHOD FontColor( uValue ) CLASS TProgressBar
*------------------------------------------------------------------------------*
   IF HB_IsNumeric( uValue )
      ::Super:FontColor := uValue
      SetProgressBarBarColor( ::hWnd, ::FontColor[1], ::FontColor[2], ::FontColor[3] )
   ENDIF
RETURN ::Super:FontColor

*------------------------------------------------------------------------------*
METHOD BackColor( uValue ) CLASS TProgressBar
*------------------------------------------------------------------------------*
   IF HB_IsArray( uValue )
      ::Super:BackColor := uValue
      SetProgressBarBkColor( ::hWnd, ::BackColor[1], ::BackColor[2], ::BackColor[3] )
   ENDIF
RETURN ::Super:BackColor
