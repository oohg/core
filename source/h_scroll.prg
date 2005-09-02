/*
 * $Id: h_scroll.prg,v 1.4 2005-09-02 05:55:07 guerra000 Exp $
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

#include 'oohg.ch'
#include "hbclass.ch"
#include 'common.ch'
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
   DATA OnEndTrack   INIT nil
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

      _OOHG_EVAL( ::OnLineDown, Self )

   elseif Lo_wParam == SB_LINEUP

      _OOHG_EVAL( ::OnLineUp, Self )

   elseif Lo_wParam == SB_PAGEUP

      _OOHG_EVAL( ::OnPageUp, Self )

   elseif Lo_wParam == SB_PAGEDOWN

      _OOHG_EVAL( ::OnPageDown, Self )

   elseif Lo_wParam == SB_TOP

      _OOHG_EVAL( ::OnTop, Self )

   elseif Lo_wParam == SB_BOTTOM

      _OOHG_EVAL( ::OnBottom, Self )

   elseif Lo_wParam == SB_THUMBPOSITION

      _OOHG_EVAL( ::OnThumb, Self, HiWord( wParam ) )

   elseif Lo_wParam == SB_THUMBTRACK

      _OOHG_EVAL( ::OnTrack, Self, HiWord( wParam ) )

   elseif Lo_wParam == TB_ENDTRACK

      _OOHG_EVAL( ::OnEndTrack, Self, HiWord( wParam ) )

   else

      Return ::Super:Events_VScroll( wParam )

   EndIf

   ::DoEvent( ::OnChange )

Return ::Super:Events_VScroll( wParam )