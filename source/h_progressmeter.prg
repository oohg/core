/*
 * $Id: h_progressmeter.prg,v 1.7 2006-07-19 03:46:04 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG progress meter functions
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

#include "oohg.ch"
#include "hbclass.ch"

CLASS TProgressMeter FROM TLabel
   DATA Type        INIT "PROGRESSMETER" READONLY
   DATA nRangeMin   INIT 0
   DATA nRangeMax   INIT 100
   DATA oLabel      INIT nil    // Left side label
   DATA nLeftWidth  INIT 0
   DATA nPercent    INIT 0
   DATA nValue      INIT 0

   METHOD Define
   METHOD Value               SETGET
   METHOD ReCalc

   METHOD RangeMin            SETGET
   METHOD RangeMax            SETGET
   METHOD FontColor           SETGET
   METHOD BackColor           SETGET
   METHOD Visible             SETGET
   METHOD SizePos
   METHOD SetFont
* fontname, fontsize, bold, italic, underline, strikeout
* tooltip, ProcedureName, HelpId, invisible, etc.
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, lo, hi, value, tooltip, ;
               fontname, fontsize, bold, italic, underline, strikeout, ;
               FontColor, BackColor, ProcedureName, HelpId, invisible, lRtl ) CLASS TProgressMeter
*-----------------------------------------------------------------------------*

   IF FontColor != NIL
      ::FontColor := FontColor
   ENDIF
   IF ::FontColor == NIL
      ::FontColor := { 0, 0, 255 }
   ENDIF

   IF BackColor != NIL
      ::BackColor := BackColor
   ENDIF
   IF ::BackColor == NIL
      ::BackColor := { 255, 255, 255 }
   ENDIF

   ::Super:Define( ControlName, ParentForm, x, y, "", w, h, fontname, ;
               fontsize, bold, .F., .F., .F., .F., ;
               .F., ::BackColor, ::FontColor, ProcedureName, tooltip, ;
               HelpId, invisible, italic, underline, strikeout, .F., ;
               .F., .F., lRtl, .T. )

   ::RangeMin := lo
   ::RangeMax := hi

   ::oLabel := TLabel():Define( "0", ::Parent:Name, ::Col, ::Row, "", ::Width, ::Height, ::cFontName, ;
               ::nFontSize, ::bold, .F., .F., .F., .F., ;
               .F., ::FontColor, ::BackColor, ::OnClick, ::ToolTip, ;
               ::HelpId, invisible, ::italic, ::underline, ::strikeout, .F., ;
               .F., .F., ::lRtl, .T., .F. )

   ::Value := If( Valtype( value ) == "N", value, ::RangeMin )
   ::ReCalc( .T. )

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ::nValue := uValue
      ::ReCalc()
   ENDIF
RETURN ::nValue

*------------------------------------------------------------------------------*
METHOD ReCalc( lForce ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
Local nPercent, nIntPercent, cText, nWidth
   IF ValType( ::oLabel ) != "O"
      Return nil
   ENDIF
   IF ValType( lForce ) != "L"
      lForce := .F.
   ENDIF
   // Percent text
   nPercent := ( ::nValue - ::RangeMin ) / ( ::RangeMax - ::RangeMin )
   nIntPercent := INT( nPercent * 100 )
   IF lForce .OR. ::nPercent != nIntPercent
      ::nPercent := nIntPercent
      cText := LTRIM( STR( nIntPercent ) ) + "%"
      nWidth := Int( Max( ( ::nWidth - GetTextWidth( 0, cText, ::FontHandle ) ) / 2, 0 ) / GetTextWidth( 0, " ", ::FontHandle ) )
      cText := Space( nWidth ) + cText
      ::Caption := cText
      ::oLabel:Caption := cText
   ENDIF
   // Displayed label
   nWidth := Int( ::Width * Min( Max( nPercent, 0 ), 1 ) )
   IF lForce .OR. nWidth != ::nLeftWidth
      ::nLeftWidth := nWidth
      ::oLabel:Width := nWidth
   ENDIF
RETURN nil

*------------------------------------------------------------------------------*
METHOD RangeMin( uValue ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ::nRangeMin := uValue
      ::ReCalc()
   ENDIF
RETURN ::nRangeMin

*------------------------------------------------------------------------------*
METHOD RangeMax( uValue ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF VALTYPE( uValue ) == "N"
      ::nRangeMax := uValue
      ::ReCalc()
   ENDIF
RETURN ::nRangeMax

*------------------------------------------------------------------------------*
METHOD FontColor( uValue ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ::Super:FontColor := uValue
      IF ValType( ::oLabel ) == "O"
         ::oLabel:BackColor := ::Super:FontColor
      Endif
   ENDIF
RETURN ::Super:FontColor

*------------------------------------------------------------------------------*
METHOD BackColor( uValue ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ::Super:BackColor := uValue
      IF ValType( ::oLabel ) == "O"
         ::oLabel:FontColor := ::Super:BackColor
      Endif
   ENDIF
RETURN ::Super:BackColor

*------------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TProgressMeter
*------------------------------------------------------------------------------*
   IF VALTYPE( lVisible ) == "L"
      ::Super:Visible := lVisible
      IF ValType( ::oLabel ) == "O"
         ::oLabel:Visible := lVisible
      Endif
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TProgressMeter
*-----------------------------------------------------------------------------*
Local uRet := ::Super:SizePos( Row, Col, Width, Height )
   IF ValType( ::oLabel ) == "O"
      ::oLabel:SizePos( ::Row, ::Col, ::Width, ::Height )
   Endif
   ::ReCalc( .T. )
Return uRet

*-----------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TProgressMeter
*-----------------------------------------------------------------------------*
Local uRet := ::Super:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout )
   IF ValType( ::oLabel ) == "O"
      ::oLabel:SetFont( ::cFontName, ::nFontSize, ::Bold, ::Italic, ::Underline, ::Strikeout )
   EndIf
   ::ReCalc( .T. )
Return uRet
