/*
 * $Id: h_spinner.prg,v 1.10 2006-10-28 20:49:15 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG spinner functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
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
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TSpinner FROM TControl
   DATA Type      INIT "SPINNER" READONLY
   DATA nRangeMin   INIT 0
   DATA nRangeMax   INIT 0

   METHOD Define
   METHOD SizePos
   METHOD Visible             SETGET
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD ForceHide           BLOCK { |Self| HideWindow( ::AuxHandle ) , ::Super:ForceHide() }

   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, value, fontname, fontsize, ;
               rl, rh, tooltip, change, lostfocus, gotfocus, h, HelpId, ;
               invisible, notabstop, bold, italic, underline, strikeout, ;
               wrap, readonly, increment, backcolor, fontcolor, lRtl, ;
               lNoBorder ) CLASS TSpinner
*-----------------------------------------------------------------------------*
Local nStyle := ES_NUMBER + ES_AUTOHSCROLL, nStyleEx := 0
Local ControlHandle

   DEFAULT w         TO 120
   DEFAULT h         TO 24
   DEFAULT value     TO rl
   DEFAULT change    TO ""
   DEFAULT lostfocus TO ""
   DEFAULT gotfocus  TO ""
   DEFAULT wrap      TO FALSE
   DEFAULT readonly  TO FALSE
   DEFAULT increment TO 1

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor, .T., lRtl )

   nStyle += ::InitStyle( ,, Invisible, NoTabStop ) + ;
             if( ValType( readonly )  == "L" .AND.  readonly,  ES_READONLY, 0 )

   nStyleEx += IF( Valtype( lNoBorder ) != "L" .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

   ControlHandle := InitTextBox( ::ContainerhWnd, 0, x, y, w, h, nStyle, 0, ::lRtl, nStyleEx )

   ::AuxHandle := InitSpinner( ::ContainerhWnd, 0, x + w, y, 15, h, rl, rh , invisible, wrap, ControlHandle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::SizePos( y, x, w, h )

   ::OnLostFocus := LostFocus
   ::OnGotFocus :=  GotFocus
   ::OnChange   :=  Change
   ::RangeMin   :=   Rl
   ::RangeMax   :=   Rh

	if valtype(value) == "N"
      SetSpinnerValue ( ::AuxHandle, Value )
	endif

	if increment <> 1
      SetSpinnerIncrement( ::AuxHandle, increment )
	endif

Return Self

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TSpinner
*-----------------------------------------------------------------------------*
Local uRet
   uRet := ::Super:SizePos( Row, Col, Width, Height )
   MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, ::Width - 15, ::Height , .T. )
   MoveWindow( ::AuxHandle, ::ContainerCol + ::Width - 15, ::ContainerRow, 15, ::Height , .T. )
Return uRet

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      IF lVisible .AND. ::ContainerVisible
         CShowControl( ::AuxHandle )
      ELSE
         HideWindow( ::AuxHandle )
      ENDIF
   ENDIF
Return ::lVisible

*-----------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      SetSpinnerValue( ::AuxHandle, uValue )
   ENDIF
Return GetSpinnerValue( ::AuxHandle )

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF VALTYPE( lEnabled ) == "L"
      ::Super:Enabled := lEnabled
      IF ::Super:Enabled
         EnableWindow( ::AuxHandle )
      ELSE
         DisableWindow( ::AuxHandle )
      ENDIF
   ENDIF
Return ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD RangeMin( nValue ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF VALTYPE( nValue ) == "N"
      ::nRangeMin := nValue
      SetSpinnerRange( ::hWnd, ::nRangeMin, ::nRangeMax )
   ENDIF
Return ::nRangeMin

*-----------------------------------------------------------------------------*
METHOD RangeMax( nValue ) CLASS TSpinner
*-----------------------------------------------------------------------------*
   IF VALTYPE( nValue ) == "N"
      ::nRangeMax := nValue
      SetSpinnerRange( ::hWnd, ::nRangeMin, ::nRangeMax )
   ENDIF
Return ::nRangeMax
