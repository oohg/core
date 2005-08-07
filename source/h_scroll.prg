/*
 * $Id: h_scroll.prg,v 1.1 2005-08-07 00:12:12 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG scrollbars functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
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

#include "hbclass.ch"
#include 'common.ch'
#include 'minigui.ch'
#include 'i_windefs.ch'

CLASS TScrollBar FROM TControl
   DATA Type         INIT "SCROLLBAR" READONLY
   DATA OnLineUp     INIT nil
   DATA OnLineDown   INIT nil
   DATA OnPageUp     INIT nil
   DATA OnPageDown   INIT nil
   DATA OnTop        INIT nil
   DATA OnBottom     INIT nil
   DATA OnThumb      INIT nil
   DATA OnTrack      INIT nil
   DATA ScrollType   INIT SB_CTL
   DATA nRangeMin    INIT 0
   DATA nRangeMax    INIT 0

   METHOD Value               SETGET
   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET

   METHOD Events_VScroll
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   if valtype( nValue ) == "N"
      SetScrollPos( ::hWnd, ::ScrollType, nValue, 1 )
   endif
Return GetScrollPos( ::hWnd, ::ScrollType )

*-----------------------------------------------------------------------------*
METHOD RangeMin( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   if valtype( nValue ) == "N"
      ::nRangeMin := nValue
      SetScrollRange( ::hWnd, ::ScrollType, nValue, ::nRangeMax, 1 )
   endif
Return ::nRangeMin

*-----------------------------------------------------------------------------*
METHOD RangeMax( nValue ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
   if valtype( nValue ) == "N"
      ::nRangeMax := nValue
      SetScrollRange( ::hWnd, ::ScrollType, ::nRangeMin, nValue, 1 )
   endif
Return ::nRangeMax

*-----------------------------------------------------------------------------*
METHOD Events_VScroll( wParam ) CLASS TScrollBar
*-----------------------------------------------------------------------------*
Local Lo_wParam := LoWord( wParam )

   If Lo_wParam == SB_LINEDOWN

      if valtype( ::OnLineDown ) == "B"

         EVAL( ::OnLineDown, Self )

      endif

   elseif Lo_wParam == SB_LINEUP

      if valtype( ::OnLineUp ) == "B"

         EVAL( ::OnLineUp, Self )

      endif

   elseif Lo_wParam == SB_PAGEUP

      if valtype( ::OnPageUp ) == "B"

         EVAL( ::OnPageUp, Self )

      endif

   elseif Lo_wParam == SB_PAGEDOWN

      if valtype( ::OnPageDown ) == "B"

         EVAL( ::OnPageDown, Self )

      endif

   elseif Lo_wParam == SB_TOP

      if valtype( ::OnTop ) == "B"

         EVAL( ::OnTop, Self )

      endif

   elseif Lo_wParam == SB_BOTTOM

      if valtype( ::OnBottom ) == "B"

         EVAL( ::OnBottom, Self )

      endif

   elseif Lo_wParam == SB_THUMBPOSITION

      if valtype( ::OnThumb ) == "B"

         EVAL( ::OnThumb, Self, HiWord( wParam ) )

      endif

   elseif Lo_wParam == SB_THUMBTRACK

      if valtype( ::OnTrack ) == "B"

         EVAL( ::OnTrack, Self, HiWord( wParam ) )

      endif

   else

      Return ::Super:Events_VScroll( wParam )

   EndIf

   ::DoEvent( ::OnChange )

Return ::Super:Events_VScroll( wParam )