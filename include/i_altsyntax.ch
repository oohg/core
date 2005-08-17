/*
 * $Id: i_altsyntax.ch,v 1.4 2005-08-17 06:05:40 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Alternate syntax definitions
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

/*---------------------------------------------------------------------------------------------------
Memvariables
----------------------------------------------------------------------------------------------------*/

MEMVAR _OOHG_ActiveControlHandCursor
MEMVAR _OOHG_ActiveControlCenterAlign
MEMVAR _OOHG_ActiveControlNoHScroll
MEMVAR _OOHG_ActiveControlGripperText
MEMVAR _OOHG_ActiveControlDisplayEdit
MEMVAR _OOHG_ActiveControlDisplayChange

MEMVAR  _OOHG_ActiveControlNoVScroll

MEMVAR  _OOHG_ActiveControlForeColor

MEMVAR  _OOHG_ActiveControlDateType

MEMVAR  _OOHG_ActiveControlInPlaceEdit
MEMVAR  _OOHG_ActiveControlItemSource
MEMVAR  _OOHG_ActiveControlValueSource

MEMVAR  _OOHG_ActiveControlWrap
MEMVAR  _OOHG_ActiveControlIncrement

MEMVAR _OOHG_ActiveControlAddress

MEMVAR _OOHG_ActiveControlItemCount

MEMVAR _OOHG_ActiveControlOnQueryData

MEMVAR _OOHG_ActiveControlAutoSize

MEMVAR _OOHG_ActiveControlVirtual

MEMVAR _OOHG_ActiveControlStretch
MEMVAR _OOHG_ActiveControlFontBold
MEMVAR _OOHG_ActiveControlFontItalic
MEMVAR _OOHG_ActiveControlFontStrikeOut
MEMVAR _OOHG_ActiveControlFontUnderLine

MEMVAR _OOHG_ActiveControlName
MEMVAR _OOHG_ActiveControlOf
MEMVAR _OOHG_ActiveControlCaption
MEMVAR _OOHG_ActiveControlAction
MEMVAR _OOHG_ActiveControlWidth
MEMVAR _OOHG_ActiveControlHeight
MEMVAR _OOHG_ActiveControlFont
MEMVAR _OOHG_ActiveControlSize
MEMVAR _OOHG_ActiveControlTooltip
MEMVAR _OOHG_ActiveControlFlat
MEMVAR _OOHG_ActiveControlOnGotFocus
MEMVAR _OOHG_ActiveControlOnLostFocus
MEMVAR _OOHG_ActiveControlNoTabStop
MEMVAR _OOHG_ActiveControlHelpId
MEMVAR _OOHG_ActiveControlInvisible
MEMVAR _OOHG_ActiveControlRow
MEMVAR _OOHG_ActiveControlCol
MEMVAR _OOHG_ActiveControlPicture

MEMVAR _OOHG_ActiveControlValue
MEMVAR _OOHG_ActiveControlOnChange

MEMVAR _OOHG_ActiveControlItems
MEMVAR _OOHG_ActiveControlOnEnter

MEMVAR _OOHG_ActiveControlShowNone
MEMVAR _OOHG_ActiveControlUpDown
MEMVAR _OOHG_ActiveControlRightAlign

MEMVAR _OOHG_ActiveControlReadOnly
MEMVAR _OOHG_ActiveControlMaxLength
MEMVAR _OOHG_ActiveControlBreak

MEMVAR _OOHG_ActiveControlOpaque

MEMVAR _OOHG_ActiveControlHeaders
MEMVAR _OOHG_ActiveControlWidths
MEMVAR _OOHG_ActiveControlOnDblClick
MEMVAR _OOHG_ActiveControlOnHeadClick
MEMVAR _OOHG_ActiveControlNoLines
MEMVAR _OOHG_ActiveControlImage
MEMVAR _OOHG_ActiveControlJustify

MEMVAR _OOHG_ActiveControlNoToday
MEMVAR _OOHG_ActiveControlNoTodayCircle
MEMVAR _OOHG_ActiveControlWeekNumbers

MEMVAR _OOHG_ActiveControlMultiSelect
MEMVAR _OOHG_ActiveControlEdit

MEMVAR _OOHG_ActiveControlBackColor
MEMVAR _OOHG_ActiveControlFontColor
MEMVAR _OOHG_ActiveControlBorder
MEMVAR _OOHG_ActiveControlClientEdge
MEMVAR _OOHG_ActiveControlHScroll
MEMVAR _OOHG_ActiveControlVscroll
MEMVAR _OOHG_ActiveControlTransparent

MEMVAR _OOHG_ActiveControlSort

MEMVAR _OOHG_ActiveControlRangeLow
MEMVAR _OOHG_ActiveControlRangeHigh
MEMVAR _OOHG_ActiveControlVertical
MEMVAR _OOHG_ActiveControlSmooth


MEMVAR _OOHG_ActiveControlOptions
MEMVAR _OOHG_ActiveControlSpacing

MEMVAR _OOHG_ActiveControlNoTicks
MEMVAR _OOHG_ActiveControlBoth
MEMVAR _OOHG_ActiveControlTop
MEMVAR _OOHG_ActiveControlLeft

MEMVAR _OOHG_ActiveControlUpperCase
MEMVAR _OOHG_ActiveControlLowerCase
MEMVAR _OOHG_ActiveControlNumeric
MEMVAR _OOHG_ActiveControlPassword
MEMVAR _OOHG_ActiveControlInputMask

MEMVAR _OOHG_ActiveControlWorkArea
MEMVAR _OOHG_ActiveControlFields
MEMVAR _OOHG_ActiveControlDelete
MEMVAR _OOHG_ActiveControlValid
MEMVAR _OOHG_ActiveControlValidMessages
MEMVAR _OOHG_ActiveControlLock
MEMVAR _OOHG_ActiveControlAppendable

MEMVAR _OOHG_ActiveControlFile
MEMVAR _OOHG_ActiveControlAutoPlay
MEMVAR _OOHG_ActiveControlCenter
MEMVAR _OOHG_ActiveControlNoAutoSizeWindow
MEMVAR _OOHG_ActiveControlNoAuotSizeMovie
MEMVAR _OOHG_ActiveControlNoErrorDlg
MEMVAR _OOHG_ActiveControlNoMenu
MEMVAR _OOHG_ActiveControlNoOpen
MEMVAR _OOHG_ActiveControlNoPlayBar
MEMVAR _OOHG_ActiveControlShowAll
MEMVAR _OOHG_ActiveControlShowMode
MEMVAR _OOHG_ActiveControlShowName
MEMVAR _OOHG_ActiveControlShowPosition

MEMVAR _OOHG_ActiveControlFormat
MEMVAR _OOHG_ActiveControlField


#xcommand ITEMSOURCE <itemsource>;
   =>;
   _OOHG_ActiveControlItemSource := <"itemsource">

#xcommand VALUESOURCE <valuesource>;
   =>;
   _OOHG_ActiveControlValueSource := <"valuesource">


#xcommand WORKAREA <workarea>;
	=>;
        _OOHG_ActiveControlWorkArea              := <"workarea">

#xcommand FIELD        <field>;
	=>;
        _OOHG_ActiveControlField            := <"field">

#xcommand FIELDS	<fields>;
	=>;
        _OOHG_ActiveControlFields                := <fields>

#xcommand ALLOWDELETE	<deletable>;
	=>;
        _OOHG_ActiveControlDelete                := <deletable>

#xcommand NOVSCROLLBAR	<nvs>;
	=>;
        _OOHG_ActiveControlNoVScroll             := <nvs>

#xcommand VSCROLLBAR	<vs>;
	=>;
        _OOHG_ActiveControlNoVScroll             := .not. <vs>

#xcommand NOHSCROLLBAR	<nvs>;
	=>;
        _OOHG_ActiveControlNoHScroll             := <nvs>

#xcommand HSCROLLBAR	<vs>;
	=>;
        _OOHG_ActiveControlNoHScroll             := .not. <vs>

#xcommand INPLACEEDIT	<inplaceedit>;
	=>;
        _OOHG_ActiveControlInPlaceEdit   := <inplaceedit>

#xcommand DATE	<datetype>;
	=>;
        _OOHG_ActiveControlDateType      := <datetype>

#xcommand VALID		<valid>;
	=>;
        _OOHG_ActiveControlValid         := <{valid}>

#xcommand VALIDMESSAGES <validmessages>;
	=>;
        _OOHG_ActiveControlValidMessages := <validmessages>

#xcommand READONLY      <readonly>;
	=>;
        _OOHG_ActiveControlReadOnly              := <readonly>

#xcommand VIRTUAL      <virtual>;
	=>;
        _OOHG_ActiveControlVirtual               := <virtual>

#xcommand LOCK		<lock>;
	=>;
        _OOHG_ActiveControlLock          := <lock>

#xcommand ALLOWAPPEND	<appendable>;
	=>;
        _OOHG_ActiveControlAppendable    := <appendable>

#xcommand FONTITALIC	<i>;
	=>;
        _OOHG_ActiveControlFontItalic    := <i>

#xcommand FONTSTRIKEOUT	<s>;
	=>;
        _OOHG_ActiveControlFontStrikeOut := <s>

#xcommand FONTUNDERLINE	<u>;
	=>;
        _OOHG_ActiveControlFontUnderline         := <u>

#xcommand AUTOSIZE		<a>;
	=>;
        _OOHG_ActiveControlAutoSize              := <a>


/*----------------------------------------------------------------------------
Frame
---------------------------------------------------------------------------*/


#xcommand DEFINE FRAME <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlCaption               := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlOpaque                := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.


#xcommand OPAQUE <opaque> ;
	=>;
        _OOHG_ActiveControlOpaque        := <opaque>

#xcommand END FRAME ;
	=>;
	_BeginFrame (;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlCaption,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlOpaque , _OOHG_ActiveControlFontBold , _OOHG_ActiveControlFontItalic , _OOHG_ActiveControlFontUnderLine , _OOHG_ActiveControlFontStrikeOut , _OOHG_ActiveControlBackColor , _OOHG_ActiveControlFontColor , _OOHG_ActiveControlTransparent )





#xcommand HEADERS <headers> ;
	=>;
        _OOHG_ActiveControlHeaders               := <headers>

#xcommand HEADER <headers> ;
	=>;
        _OOHG_ActiveControlHeaders               := <headers>

#xcommand WIDTHS <widths> ;
	=>;
        _OOHG_ActiveControlWidths                := <widths>

#xcommand ONDBLCLICK <dblclick> ;
	=>;
        _OOHG_ActiveControlOnDblClick    := <{dblclick}>

#xcommand ON DBLCLICK <dblclick> ;
	=>;
        _OOHG_ActiveControlOnDblClick    := <{dblclick}>

#xcommand ONHEADCLICK <aHeadClick> ;
	=>;
        _OOHG_ActiveControlOnHeadClick   := <{aHeadClick}>

#xcommand ON HEADCLICK <aHeadClick> ;
	=>;
        _OOHG_ActiveControlOnHeadClick   := <{aHeadClick}>

#xcommand NOLINES <nolines> ;
	=>;
        _OOHG_ActiveControlNoLines               := <nolines>

#xcommand IMAGE <aImage> ;
	=>;
        _OOHG_ActiveControlImage         := <aImage>

#xcommand JUSTIFY <aJustify> ;
	=>;
        _OOHG_ActiveControlJustify               := <aJustify>

#xcommand MULTISELECT <multiselect> ;
	=>;
        _OOHG_ActiveControlMultiSelect   := <multiselect>

#xcommand ALLOWEDIT <edit> ;
	=>;
        _OOHG_ActiveControlEdit          := <edit>

/*----------------------------------------------------------------------------
List Box
---------------------------------------------------------------------------*/
#xcommand DEFINE LISTBOX <name>;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlItems         := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlOnDblClick    := Nil          ;;
        _OOHG_ActiveControlMultiSelect   := .f.          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlBreak         := .f.          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlNoTabStop             := .f.          ;;
        _OOHG_ActiveControlSort          := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.

#xcommand SORT	<sort>	;
	=>;
        _OOHG_ActiveControlSort          := <sort>

#xcommand END LISTBOX	;
	=>;
	_DefineListBox(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlItems,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlOnDblClick,;
                _OOHG_ActiveControlOnGotFocus,;
                _OOHG_ActiveControlOnLostFocus,;
                _OOHG_ActiveControlBreak,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible,;
                _OOHG_ActiveControlNoTabStop,;
                _OOHG_ActiveControlSort , ;
                _OOHG_ActiveControlFontBold , ;
                _OOHG_ActiveControlFontItalic , ;
                _OOHG_ActiveControlFontUnderLine , ;
                _OOHG_ActiveControlFontStrikeOut , ;
                _OOHG_ActiveControlBackColor , ;
                _OOHG_ActiveControlFontColor , ;
                _OOHG_ActiveControlMultiSelect )

///////////////////////////////////////////////////////////////////////////////
// ANIMATEBOX COMMANDS
///////////////////////////////////////////////////////////////////////////////

#xcommand DEFINE ANIMATEBOX <name>;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlAutoPlay              := .f.          ;;
        _OOHG_ActiveControlCenter                := .f.          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlFile          := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil

#xcommand AUTOPLAY <autoplay>;
	=>;
        _OOHG_ActiveControlAutoPlay              := <autoplay>

#xcommand CENTER	<center>;
	=>;
        _OOHG_ActiveControlCenter                := <center>

#xcommand FILE		<file>;
	=>;
        _OOHG_ActiveControlFile          := <file>

#xcommand END ANIMATEBOX;
	=>;
	_DefineAnimateBox(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlAutoPlay,;
                _OOHG_ActiveControlCenter,;
                _OOHG_ActiveControlTransparent,;
                _OOHG_ActiveControlFile,;
                _OOHG_ActiveControlHelpId)

#xcommand DEFINE PLAYER <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlFile          := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlNoAutoSizeWindow      := .f.          ;;
        _OOHG_ActiveControlNoAutoSizeMovie       := .f.          ;;
        _OOHG_ActiveControlNoErrorDlg    := .f.          ;;
        _OOHG_ActiveControlNoMenu                := .f.          ;;
        _OOHG_ActiveControlNoOpen                := .f.          ;;
        _OOHG_ActiveControlNoPlayBar             := .f.          ;;
        _OOHG_ActiveControlShowAll               := .f.          ;;
        _OOHG_ActiveControlShowMode              := .f.          ;;
        _OOHG_ActiveControlShowName              := .f.          ;;
        _OOHG_ActiveControlShowPosition  := .f.          ;;
        _OOHG_ActiveControlHelpId                := Nil

#xcommand NOAUTOSIZEWINDOW	<noautosizewindow>;
	=>;
        _OOHG_ActiveControlNoAutoSizeWindow      := <noautosizewindow>

#xcommand NOAUTOSIZEMOVIE	<noautosizemovie>;
	=>;
        _OOHG_ActiveControlNoAutoSizeMovie       := <noautosizemovie>

#xcommand NOERRORDLG	<noerrordlg>;
	=>;
        _OOHG_ActiveControlNoErrorDlg    := <noerrordlg>

#xcommand NOMENU	<nomenu>;
	=>;
        _OOHG_ActiveControlNoMenu        := <nomenu>

#xcommand NOOPEN	<noopen>;
	=>;
        _OOHG_ActiveControlNoOpen        := <noopen>

#xcommand NOPLAYBAR	<noplaybar>;
	=>;
        _OOHG_ActiveControlNoPlayBar     := <noplaybar>

#xcommand SHOWALL	<showall>;
	=>;
        _OOHG_ActiveControlShowAll       := <showall>

#xcommand SHOWMODE	<showmode>;
	=>;
        _OOHG_ActiveControlShowMode      := <showmode>

#xcommand SHOWNAME	<showname>;
	=>;
        _OOHG_ActiveControlShowName      := <showname>

#xcommand SHOWPOSITION	<showposition>;
	=>;
        _OOHG_ActiveControlShowPosition  := <showposition>

#xcommand END PLAYER;
	=>;
	_DefinePlayer(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlFile,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlNoAutoSizeWindow,;
                _OOHG_ActiveControlNoAutoSizeMovie,;
                _OOHG_ActiveControlNoErrorDlg,;
                _OOHG_ActiveControlNoMenu,;
                _OOHG_ActiveControlNoOpen,;
                _OOHG_ActiveControlNoPlayBar,;
                _OOHG_ActiveControlShowAll,;
                _OOHG_ActiveControlShowMode,;
                _OOHG_ActiveControlShowName,;
                _OOHG_ActiveControlShowPosition,;
                _OOHG_ActiveControlHelpId)

/*----------------------------------------------------------------------------
Progress Bar
---------------------------------------------------------------------------*/


#xcommand DEFINE PROGRESSBAR <name>;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlRangeLow              := Nil          ;;
        _OOHG_ActiveControlRangeHigh             := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlVertical              := .f.          ;;
        _OOHG_ActiveControlSmooth                := .f.          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlForeColor             := Nil          ;;
        _OOHG_ActiveControlValue         := Nil

#xcommand RANGEMIN	<lo>;
	=>;
        _OOHG_ActiveControlRangeLow      := <lo>

#xcommand RANGEMAX	<hi>;
	=>;
        _OOHG_ActiveControlRangeHigh     := <hi>

#xcommand VERTICAL	<vertical>;
	=>;
        _OOHG_ActiveControlVertical      := <vertical>

#xcommand SMOOTH	<smooth>;
	=>;
        _OOHG_ActiveControlSmooth        := <smooth>

#xcommand END PROGRESSBAR;
	=>;
	_DefineProgressBar(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlRangeLow,;
                _OOHG_ActiveControlRangeHigh,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlVertical,;
                _OOHG_ActiveControlSmooth,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible,;
                _OOHG_ActiveControlValue , _OOHG_ActiveControlBackColor , _OOHG_ActiveControlForeColor )


/*----------------------------------------------------------------------------
Radio Group
---------------------------------------------------------------------------*/

#xcommand DEFINE RADIOGROUP <name>;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlOptions               := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlSpacing               := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlInvisible             := .F.          ;;
        _OOHG_ActiveControlNoTabStop             := .F.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlAutoSize      := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.

#xcommand OPTIONS	<aOptions>;
	=>;
        _OOHG_ActiveControlOptions               := <aOptions>

#xcommand SPACING	<spacing>;
	=>;
        _OOHG_ActiveControlSpacing               := <spacing>

#xcommand END RADIOGROUP;
	=>;
        TRadioGroup():Define( ;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlOptions,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlSpacing,;
                _OOHG_ActiveControlHelpId , ;
                _OOHG_ActiveControlInvisible ,;
                _OOHG_ActiveControlNoTabStop , ;
                _OOHG_ActiveControlFontBold , ;
                _OOHG_ActiveControlFontItalic , ;
                _OOHG_ActiveControlFontUnderLine , ;
                _OOHG_ActiveControlFontStrikeOut ,;
                _OOHG_ActiveControlBackColor,;
                _OOHG_ActiveControlFontColor  , ;
                _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlAutoSize  ;
		)


/*----------------------------------------------------------------------------
Slider
---------------------------------------------------------------------------*/

#xcommand DEFINE SLIDER <name>;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlRangeLow              := Nil          ;;
        _OOHG_ActiveControlRangeHigh             := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlVertical              := .f.          ;;
        _OOHG_ActiveControlNoTicks               := .f.          ;;
        _OOHG_ActiveControlBoth          := .f.          ;;
        _OOHG_ActiveControlTop           := .f.          ;;
        _OOHG_ActiveControlLeft          := .f.          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlInvisible             := .F.          ;;
        _OOHG_ActiveControlNoTabStop             := .F.          ;;
        _OOHG_ActiveControlHelpId                := Nil

#xcommand NOTICKS	<noticks>;
	=>;
        _OOHG_ActiveControlNoTicks       := <noticks>

#xcommand BOTH		<both>;
	=>;
        _OOHG_ActiveControlBoth  := <both>

#xcommand TOP		<top>;
	=>;
        _OOHG_ActiveControlTop   := <top>

#xcommand LEFT		<left>;
	=>;
        _OOHG_ActiveControlLeft  := <left>

#xcommand END SLIDER;
	=>;
	_DefineSlider(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlRangeLow,;
                _OOHG_ActiveControlRangeHigh,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlVertical,;
                _OOHG_ActiveControlNoTicks,;
                _OOHG_ActiveControlBoth,;
                _OOHG_ActiveControlTop,;
                _OOHG_ActiveControlLeft,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible ,;
                _OOHG_ActiveControlNoTabStop , ;
                _OOHG_ActiveControlBackColor )

/*----------------------------------------------------------------------------
Text Box
---------------------------------------------------------------------------*/

#xcommand DEFINE TEXTBOX <name>;
	=>;
        _OOHG_ActiveControlName := <"name">     ;;
        _OOHG_ActiveControlOf    := Nil          ;;
        _OOHG_ActiveControlCol   := Nil          ;;
        _OOHG_ActiveControlRow   := Nil          ;;
        _OOHG_ActiveControlWidth := Nil          ;;
        _OOHG_ActiveControlHeight        := Nil          ;;
        _OOHG_ActiveControlValue := Nil          ;;
        _OOHG_ActiveControlFont  := Nil          ;;
        _OOHG_ActiveControlField     := Nil          ;;
        _OOHG_ActiveControlSize  := Nil          ;;
        _OOHG_ActiveControlTooltip       := Nil          ;;
        _OOHG_ActiveControlMaxLength     := Nil          ;;
        _OOHG_ActiveControlUpperCase     := .f.          ;;
        _OOHG_ActiveControlLowerCase     := .f.          ;;
        _OOHG_ActiveControlNumeric       := .f.          ;;
        _OOHG_ActiveControlPassword      := .f.          ;;
        _OOHG_ActiveControlOnLostFocus := Nil    ;;
        _OOHG_ActiveControlOnGotFocus := Nil             ;;
        _OOHG_ActiveControlOnChange      := Nil          ;;
        _OOHG_ActiveControlOnEnter       := Nil          ;;
        _OOHG_ActiveControlRightAlign := .f.             ;;
        _OOHG_ActiveControlReadonly   := .f.         ;;
        _OOHG_ActiveControlDateType   := .f.         ;;
        _OOHG_ActiveControlHelpId    := Nil          ;;
        _OOHG_ActiveControlInputMask     := Nil          ;;
        _OOHG_ActiveControlFormat        := Nil          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlNoTabStop             := .f.          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.

#xcommand UPPERCASE <uppercase>;
	=>;
        _OOHG_ActiveControlUpperCase             := <uppercase>

#xcommand LOWERCASE <lowercase>;
	=>;
        _OOHG_ActiveControlLowerCase             := <lowercase>

#xcommand NUMERIC <numeric>;
	=>;
        _OOHG_ActiveControlNumeric               := <numeric>

#xcommand PASSWORD <password>;
	=>;
        _OOHG_ActiveControlPassword              := <password>

#xcommand INPUTMASK <inputmask>;
	=>;
        _OOHG_ActiveControlInputMask             := <inputmask>

#xcommand FORMAT <format>;
	=>;
        _OOHG_ActiveControlFormat                := <format>

#xcommand END TEXTBOX;
	=>;
        iif(_OOHG_ActiveControlInputMask == Nil .and. _OOHG_ActiveControlDateType == .F. ,;
                iif( _OOHG_ActiveControlNumeric, TTextNum(), TText() ):Define( ;
                        _OOHG_ActiveControlName,;
                        _OOHG_ActiveControlOf,;
                        _OOHG_ActiveControlCol,;
                        _OOHG_ActiveControlRow,;
                        _OOHG_ActiveControlWidth,;
                        _OOHG_ActiveControlHeight,;
                        _OOHG_ActiveControlValue,;
                        _OOHG_ActiveControlFont,;
                        _OOHG_ActiveControlSize,;
                        _OOHG_ActiveControlTooltip,;
                        _OOHG_ActiveControlMaxLength,;
                        _OOHG_ActiveControlUpperCase,;
                        _OOHG_ActiveControlLowerCase,;
                        _OOHG_ActiveControlPassword,;
                        _OOHG_ActiveControlOnLostFocus,;
                        _OOHG_ActiveControlOnGotFocus,;
                        _OOHG_ActiveControlOnChange,;
                        _OOHG_ActiveControlOnEnter,;
                        _OOHG_ActiveControlRightAlign,;
                        _OOHG_ActiveControlHelpId , ;
                        _OOHG_ActiveControlReadonly,;
                        _OOHG_ActiveControlFontBold , ;
                        _OOHG_ActiveControlFontItalic , ;
                        _OOHG_ActiveControlFontUnderLine , ;
                        _OOHG_ActiveControlFontStrikeOut , ;
                        _OOHG_ActiveControlField , ;
                        _OOHG_ActiveControlBackColor , ;
                        _OOHG_ActiveControlFontColor , ;
                        _OOHG_ActiveControlInvisible , ;
                        _OOHG_ActiveControlNoTabStop);
	,;
                if ( _OOHG_ActiveControlNumeric, ;
                     TTextMasked():Define( ;
                        _OOHG_ActiveControlName,;
                        _OOHG_ActiveControlOf,;
                        _OOHG_ActiveControlCol,;
                        _OOHG_ActiveControlRow,;
                        _OOHG_ActiveControlInputMask,;
                        _OOHG_ActiveControlWidth,;
                        _OOHG_ActiveControlValue,;
                        _OOHG_ActiveControlFont,;
                        _OOHG_ActiveControlSize,;
                        _OOHG_ActiveControlTooltip,;
                        _OOHG_ActiveControlOnLostFocus,;
                        _OOHG_ActiveControlOnGotFocus,;
                        _OOHG_ActiveControlOnChange,;
                        _OOHG_ActiveControlHeight,;
                        _OOHG_ActiveControlOnEnter,;
                        _OOHG_ActiveControlRightAlign,;
                        _OOHG_ActiveControlHelpId,;
                        _OOHG_ActiveControlFormat , ;
                        _OOHG_ActiveControlFontBold , ;
                        _OOHG_ActiveControlFontItalic , ;
                        _OOHG_ActiveControlFontUnderLine , ;
                        _OOHG_ActiveControlFontStrikeOut,;
                        _OOHG_ActiveControlField,_OOHG_ActiveControlBackColor,_OOHG_ActiveControlFontColor,_OOHG_ActiveControlReadonly,_OOHG_ActiveControlInvisible,_OOHG_ActiveControlNoTabStop) , ;
                     TTextCharMask():Define( _OOHG_ActiveControlName , _OOHG_ActiveControlOf, _OOHG_ActiveControlCol, _OOHG_ActiveControlRow, _OOHG_ActiveControlInputMask , _OOHG_ActiveControlWidth , _OOHG_ActiveControlValue , _OOHG_ActiveControlFont , _OOHG_ActiveControlSize , _OOHG_ActiveControlTooltip , _OOHG_ActiveControlOnLostFocus  , _OOHG_ActiveControlOnGotFocus , _OOHG_ActiveControlOnChange , _OOHG_ActiveControlHeight , _OOHG_ActiveControlOnEnter , _OOHG_ActiveControlRightAlign  , _OOHG_ActiveControlHelpId  , _OOHG_ActiveControlFontBold , _OOHG_ActiveControlFontItalic , _OOHG_ActiveControlFontUnderLine , _OOHG_ActiveControlFontStrikeOut , _OOHG_ActiveControlField , _OOHG_ActiveControlBackColor,_OOHG_ActiveControlFontColor,_OOHG_ActiveControlDateType,_OOHG_ActiveControlReadonly,_OOHG_ActiveControlInvisible,_OOHG_ActiveControlNoTabStop) ) ;
	)

/*----------------------------------------------------------------------------
Month Calendar
---------------------------------------------------------------------------*/

#xcommand DEFINE MONTHCALENDAR <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlNoToday               := .f.          ;;
        _OOHG_ActiveControlNoTodayCircle := .f.          ;;
        _OOHG_ActiveControlWeekNumbers   := .f.          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlNoTabStop             := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.

#xcommand NOTODAY	<notoday>;
	=>;
        _OOHG_ActiveControlNoToday               := <notoday>

#xcommand NOTODAYCIRCLE	<notodaycircle>;
	=>;
        _OOHG_ActiveControlNoTodayCircle := <notodaycircle>

#xcommand WEEKNUMBERS	<weeknumbers>;
	=>;
        _OOHG_ActiveControlWeekNumbers   := <weeknumbers>

#xcommand END MONTHCALENDAR;
	=>;
	_DefineMonthCal (;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
		0,;
		0,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlNoToday,;
                _OOHG_ActiveControlNoTodayCircle,;
                _OOHG_ActiveControlWeekNumbers,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible,;
                _OOHG_ActiveControlNoTabStop , _OOHG_ActiveControlFontBold , _OOHG_ActiveControlFontItalic , _OOHG_ActiveControlFontUnderLine , _OOHG_ActiveControlFontStrikeOut )

/*----------------------------------------------------------------------------
Button
---------------------------------------------------------------------------*/

#xcommand DEFINE BUTTON <name> ;
        =>;
        _OOHG_ActiveControlName             := <"name"> ;;
        _OOHG_ActiveControlOf                := Nil      ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlCaption           := Nil      ;;
        _OOHG_ActiveControlAction            := Nil      ;;
        _OOHG_ActiveControlWidth             := Nil      ;;
        _OOHG_ActiveControlHeight            := Nil      ;;
        _OOHG_ActiveControlFont              := Nil      ;;
        _OOHG_ActiveControlSize              := Nil      ;;
        _OOHG_ActiveControlTooltip           := Nil      ;;
        _OOHG_ActiveControlFlat              := .f.      ;;
        _OOHG_ActiveControlOnGotFocus        := Nil      ;;
        _OOHG_ActiveControlOnLostFocus       := Nil      ;;
        _OOHG_ActiveControlNoTabStop         := .f.      ;;
        _OOHG_ActiveControlHelpId            := Nil      ;;
        _OOHG_ActiveControlInvisible         := .f.      ;;
        _OOHG_ActiveControlRow               := Nil      ;;
        _OOHG_ActiveControlCol               := Nil      ;;
        _OOHG_ActiveControlPicture           := Nil      ;;
        _OOHG_ActiveControlTransparent     := .t.                ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.

#xcommand ROW <row> ;
        =>;
        _OOHG_ActiveControlRow := <row>

#xcommand COL  <col> ;
        =>;
        _OOHG_ActiveControlCol := <col>

#xcommand PARENT <of> ;
        =>;
        _OOHG_ActiveControlOf := <"of">

#xcommand CAPTION  <caption> ;
        =>;
        _OOHG_ActiveControlCaption := <caption>

#xcommand ACTION <action> ;
        =>;
        _OOHG_ActiveControlAction := <{action}>

#xcommand ONCLICK <action> ;
        =>;
        _OOHG_ActiveControlAction := <{action}>

#xcommand ON CLICK <action> ;
        =>;
        _OOHG_ActiveControlAction := <{action}>

#xcommand WIDTH <width> ;
        =>;
        _OOHG_ActiveControlWidth := <width>

#xcommand HEIGHT <height> ;
        =>;
        _OOHG_ActiveControlHeight := <height>

#xcommand FONTNAME <font> ;
        =>;
        _OOHG_ActiveControlFont := <font>

#xcommand FONTSIZE <size> ;
        =>;
        _OOHG_ActiveControlSize := <size>

#xcommand ITEMCOUNT <itemcount> ;
        =>;
        _OOHG_ActiveControlItemCount := <itemcount>

#xcommand TOOLTIP <tooltip> ;
        =>;
        _OOHG_ActiveControlTooltip := <tooltip>

#xcommand FLAT <flat> ;
        =>;
        _OOHG_ActiveControlFlat := <flat>

#xcommand ONGOTFOCUS <ongotfocus> ;
        =>;
        _OOHG_ActiveControlOnGotFocus := <{ongotfocus}>

#xcommand ON GOTFOCUS <ongotfocus> ;
        =>;
        _OOHG_ActiveControlOnGotFocus := <{ongotfocus}>

#xcommand ONLOSTFOCUS <onlostfocus> ;
        =>;
        _OOHG_ActiveControlOnLostFocus := <{onlostfocus}>

#xcommand ON LOSTFOCUS <onlostfocus> ;
        =>;
        _OOHG_ActiveControlOnLostFocus := <{onlostfocus}>

#xcommand TABSTOP <notabstop> ;
        =>;
        _OOHG_ActiveControlNoTabStop := .NOT. <notabstop>

#xcommand HELPID <helpid> ;
        =>;
        _OOHG_ActiveControlHelpId := <helpid>

#xcommand VISIBLE <visible> ;
        =>;
        _OOHG_ActiveControlInvisible := .NOT. <visible>

#xcommand PICTURE <picture> ;
        =>;
        _OOHG_ActiveControlPicture := <picture>

#xcommand TRANSPARENT <transparent> ;
        =>;
        _OOHG_ActiveControlTransparent := <transparent>

#xcommand END BUTTON ;
        =>;
        iif ( _OOHG_ActiveControlPicture == Nil ,;
	         _DefineButton (;
                    _OOHG_ActiveControlName,;
                    _OOHG_ActiveControlOf ,;
                    _OOHG_ActiveControlCol ,;
                    _OOHG_ActiveControlRow ,;
                    _OOHG_ActiveControlCaption ,;
                    _OOHG_ActiveControlAction ,;
                    _OOHG_ActiveControlWidth ,;
                    _OOHG_ActiveControlHeight ,;
                    _OOHG_ActiveControlFont ,;
                    _OOHG_ActiveControlSize ,;
                    _OOHG_ActiveControlTooltip ,;
                    _OOHG_ActiveControlOnGotFocus  ,;
                    _OOHG_ActiveControlOnLostFocus ,;
                    _OOHG_ActiveControlFlat ,;
                    _OOHG_ActiveControlNoTabStop  ,;
                    _OOHG_ActiveControlHelpId ,;
                    _OOHG_ActiveControlInvisible , _OOHG_ActiveControlFontBold , _OOHG_ActiveControlFontItalic , _OOHG_ActiveControlFontUnderLine , _OOHG_ActiveControlFontStrikeOut  ) ,;
		 _DefineImageButton (;
                    _OOHG_ActiveControlName,;
                    _OOHG_ActiveControlOf,;
                    _OOHG_ActiveControlCol,;
                    _OOHG_ActiveControlRow,;
		    "",;
                    _OOHG_ActiveControlAction ,;
                    _OOHG_ActiveControlWidth ,;
                    _OOHG_ActiveControlHeight ,;
                    _OOHG_ActiveControlPicture ,;
                    _OOHG_ActiveControlTooltip ,;
                    _OOHG_ActiveControlOnGotfocus  ,;
                    _OOHG_ActiveControlOnLostfocus  ,;
                    _OOHG_ActiveControlFlat  ,;
                     .not. _OOHG_ActiveControlTransparent ,;
                    _OOHG_ActiveControlHelpId ,;
                    _OOHG_ActiveControlInvisible , _OOHG_ActiveControlNoTabStop ) )

/*----------------------------------------------------------------------------
Image
---------------------------------------------------------------------------*/

#xcommand DEFINE IMAGE <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlPicture               := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlAction                := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlStretch               := .F.          ;;
        _OOHG_ActiveControlInvisible             := .f.

#xcommand END IMAGE ;
	=>;
	_DefineImage(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlPicture,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlAction,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible,;
                _OOHG_ActiveControlStretch,;
		.F.;
		)

#xcommand STRETCH		<stretch>;
	=>;
        _OOHG_ActiveControlStretch       := <stretch>


/*----------------------------------------------------------------------------
Check Box/Button
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKBOX <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlCaption               := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlNoTabStop         := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine     := .f.          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlAutoSize   := .f.          ;;
        _OOHG_ActiveControlField             := Nil


#xcommand DEFINE CHECKBUTTON <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCaption               := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlPicture           := Nil      ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine     := .f.          ;;
        _OOHG_ActiveControlNoTabStop         := .f.          ;;
        _OOHG_ActiveControlField             := Nil

#xcommand VALUE <value> ;
	=>;
        _OOHG_ActiveControlValue := <value>

#xcommand ONCHANGE <onchange> ;
	=>;
        _OOHG_ActiveControlOnChange      := <{onchange}>

#xcommand ON CHANGE <onchange> ;
	=>;
        _OOHG_ActiveControlOnChange      := <{onchange}>

#xcommand ON QUERYDATA <onquerydata> ;
	=>;
        _OOHG_ActiveControlOnQueryData   := <{onquerydata}>

#xcommand ONQUERYDATA <onquerydata> ;
	=>;
        _OOHG_ActiveControlOnQueryData   := <{onquerydata}>

#xcommand END CHECKBOX ;
	=>;
        TCheckBox():Define(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlCaption,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlOnLostFocus,;
                _OOHG_ActiveControlOnGotFocus,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible,;
                _OOHG_ActiveControlNoTabStop,;
                _OOHG_ActiveControlFontBold ,;
                _OOHG_ActiveControlFontItalic , ;
                _OOHG_ActiveControlFontUnderLine , ;
                _OOHG_ActiveControlFontStrikeOut,;
                _OOHG_ActiveControlField,;
                _OOHG_ActiveControlBackColor,;
                _OOHG_ActiveControlFontColor,;
                _OOHG_ActiveControlTransparent,;
                _OOHG_ActiveControlAutoSize )

#xcommand END CHECKBUTTON ;
	=>;
        IIF ( _OOHG_ActiveControlPicture == NIL , _DefineCheckButton (;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlCaption,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlOnLostFocus,;
                _OOHG_ActiveControlOnGotFocus,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible  , ;
                _OOHG_ActiveControlNoTabStop ,;
                _OOHG_ActiveControlFontBold , ;
                _OOHG_ActiveControlFontItalic , ;
                _OOHG_ActiveControlFontUnderLine , ;
                _OOHG_ActiveControlFontStrikeOut ) , ;
           _DefineImageCheckButton ( ;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlPicture,;
                _OOHG_ActiveControlValue ,;
		"" ,;
		0 , ;
                _OOHG_ActiveControlTooltip  , ;
                _OOHG_ActiveControlOnChange  , ;
                _OOHG_ActiveControlWidth , ;
                _OOHG_ActiveControlHeight , ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus , ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible ) )

/*----------------------------------------------------------------------------
Combo Box
---------------------------------------------------------------------------*/

#xcommand DEFINE COMBOBOX <name>;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight        := Nil          ;;
        _OOHG_ActiveControlItems         := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip       := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlNoTabStop     := .f.          ;;
        _OOHG_ActiveControlSort          := .f.          ;;
        _OOHG_ActiveControlOnChange      := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlOnEnter       := Nil          ;;
        _OOHG_ActiveControlHelpId        := Nil          ;;
        _OOHG_ActiveControlInvisible     := .f.          ;;
        _OOHG_ActiveControlFontBold      := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlItemSource   := Nil           ;;
        _OOHG_ActiveControlValueSource  := Nil           ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlBreak         := .f.          ;;
        _OOHG_ActiveControlGripperText   := ""           ;;
        _OOHG_ActiveControlDisplayEdit   := .f.          ;;
        _OOHG_ActiveControlDisplayChange := Nil          ;;
        _OOHG_ActiveControlFontUnderLine := .f.

#xcommand DISPLAYEDIT <displayedit> ;
	=>;
        _OOHG_ActiveControlDisplayEdit := <displayedit>

#xcommand GRIPPERTEXT <grippertext> ;
	=>;
        _OOHG_ActiveControlGripperText := <grippertext>

#xcommand ON DISPLAYCHANGE <displaychange> ;
	=>;
        _OOHG_ActiveControlDisplayChange := <{displaychange}>

#xcommand ONDISPLAYCHANGE <displaychange> ;
	=>;
        _OOHG_ActiveControlDisplayChange := <{displaychange}>

#xcommand ITEM <aRows> ;
	=>;
        _OOHG_ActiveControlItems := <aRows>

#xcommand ITEMS <aRows> ;
	=>;
        _OOHG_ActiveControlItems := <aRows>

#xcommand ONENTER <enter> ;
	=>;
        _OOHG_ActiveControlOnEnter       := <{enter}>

#xcommand ON ENTER <enter> ;
	=>;
        _OOHG_ActiveControlOnEnter       := <{enter}>

#xcommand END COMBOBOX ;
	=>;
	_DefineCombo (;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlItems,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlOnGotFocus,;
                _OOHG_ActiveControlOnLostFocus,;
                _OOHG_ActiveControlOnEnter,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible ,;
                _OOHG_ActiveControlNoTabStop,;
                _OOHG_ActiveControlSort,;
                _OOHG_ActiveControlFontBold,;
                _OOHG_ActiveControlFontItalic,;
                _OOHG_ActiveControlFontUnderLine,;
                _OOHG_ActiveControlFontStrikeOut,;
                _OOHG_ActiveControlItemSource,;
                _OOHG_ActiveControlValueSource , ;
                _OOHG_ActiveControlDisplayEdit , ;
                _OOHG_ActiveControlDisplayChange , ;
                _OOHG_ActiveControlBreak , ;
                _OOHG_ActiveControlGripperText ;
		)

/*----------------------------------------------------------------------------
Datepicker
---------------------------------------------------------------------------*/


#xcommand DEFINE DATEPICKER <name> ;
	=> ;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlShowNone              := .f.          ;;
        _OOHG_ActiveControlUpDown                := .f.          ;;
        _OOHG_ActiveControlRightAlign    := .f.          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlField             := Nil          ;;
        _OOHG_ActiveControlNoTabStop         := .f.          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlOnEnter               := Nil          ;;
        _OOHG_ActiveControlFontUnderLine := .f.


#xcommand SHOWNONE  <shownone> ;
	=> ;
        _OOHG_ActiveControlShowNone              := <shownone>

#xcommand UPDOWN  <updown> ;
	=> ;
        _OOHG_ActiveControlUpDown                := <updown>

#xcommand RIGHTALIGN  <rightalign> ;
	=> ;
        _OOHG_ActiveControlRightAlign    := <rightalign>


#xcommand END DATEPICKER ;
	=> ;
        _DefineDatePick (;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlOnLostFocus,;
                _OOHG_ActiveControlOnGotFocus,;
                _OOHG_ActiveControlShowNone,;
                _OOHG_ActiveControlUpDown,;
                _OOHG_ActiveControlRightAlign,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible , ;
                _OOHG_ActiveControlNoTabStop,;
                _OOHG_ActiveControlFontBold , ;
                _OOHG_ActiveControlFontItalic , ;
                _OOHG_ActiveControlFontUnderLine , ;
                _OOHG_ActiveControlFontStrikeOut,;
                _OOHG_ActiveControlField , _OOHG_ActiveControlOnEnter )



/*----------------------------------------------------------------------------
Edit Box
---------------------------------------------------------------------------*/

#xcommand DEFINE EDITBOX <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlReadonly              := .f.          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlMaxLength             := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlBreak         := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine     := .f.          ;;
        _OOHG_ActiveControlNoTabStop         := .f.          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlField             := Nil ;;
        _OOHG_ActiveControlNoVScroll         := .f.          ;;
        _OOHG_ActiveControlNoHScroll         := .f.

#xcommand READONLYFIELDS <readonly> ;
	=>;
        _OOHG_ActiveControlReadOnly              := <readonly>

#xcommand MAXLENGTH <maxlength> ;
	=>;
        _OOHG_ActiveControlMaxLength             := <maxlength>

#xcommand BREAK <break> ;
	=>;
        _OOHG_ActiveControlBreak         := <break>

#xcommand END EDITBOX ;
	=>;
		_DefineEditBox(;
                        _OOHG_ActiveControlName,;
                        _OOHG_ActiveControlOf,;
                        _OOHG_ActiveControlCol,;
                        _OOHG_ActiveControlRow,;
                        _OOHG_ActiveControlWidth,;
                        _OOHG_ActiveControlHeight,;
                        _OOHG_ActiveControlValue,;
                        _OOHG_ActiveControlFont,;
                        _OOHG_ActiveControlSize,;
                        _OOHG_ActiveControlTooltip,;
                        _OOHG_ActiveControlMaxLength,;
                        _OOHG_ActiveControlOnGotFocus,;
                        _OOHG_ActiveControlOnChange,;
                        _OOHG_ActiveControlOnLostFocus,;
                        _OOHG_ActiveControlReadOnly,;
                        _OOHG_ActiveControlBreak,;
                        _OOHG_ActiveControlHelpId,;
                        _OOHG_ActiveControlInvisible , ;
                        _OOHG_ActiveControlNoTabStop ,;
                        _OOHG_ActiveControlFontBold , ;
                        _OOHG_ActiveControlFontItalic , ;
                        _OOHG_ActiveControlFontUnderLine , ;
                        _OOHG_ActiveControlFontStrikeOut ,;
                        _OOHG_ActiveControlField, ;
                        _OOHG_ActiveControlBackColor, ;
                        _OOHG_ActiveControlFontColor, ;
                        _OOHG_ActiveControlNoVScroll, ;
                        _OOHG_ActiveControlNoHScroll )


/*----------------------------------------------------------------------------
Rich Edit Box
---------------------------------------------------------------------------*/

#xcommand DEFINE RICHEDITBOX <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlReadonly              := .f.          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlMaxLength             := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlBreak         := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine     := .f.          ;;
        _OOHG_ActiveControlNoTabStop         := .f.          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlField             := Nil

#xcommand END RICHEDITBOX ;
	=>;
		_DefineRichEditBox(;
                        _OOHG_ActiveControlName,;
                        _OOHG_ActiveControlOf,;
                        _OOHG_ActiveControlCol,;
                        _OOHG_ActiveControlRow,;
                        _OOHG_ActiveControlWidth,;
                        _OOHG_ActiveControlHeight,;
                        _OOHG_ActiveControlValue,;
                        _OOHG_ActiveControlFont,;
                        _OOHG_ActiveControlSize,;
                        _OOHG_ActiveControlTooltip,;
                        _OOHG_ActiveControlMaxLength,;
                        _OOHG_ActiveControlOnGotFocus,;
                        _OOHG_ActiveControlOnChange,;
                        _OOHG_ActiveControlOnLostFocus,;
                        _OOHG_ActiveControlReadOnly,;
                        _OOHG_ActiveControlBreak,;
                        _OOHG_ActiveControlHelpId,;
                        _OOHG_ActiveControlInvisible , ;
                        _OOHG_ActiveControlNoTabStop ,;
                        _OOHG_ActiveControlFontBold , ;
                        _OOHG_ActiveControlFontItalic , ;
                        _OOHG_ActiveControlFontUnderLine , ;
                        _OOHG_ActiveControlFontStrikeOut ,;
                        _OOHG_ActiveControlField,;
                        _OOHG_ActiveControlBackColor )

/*----------------------------------------------------------------------------
Label
---------------------------------------------------------------------------*/

#xcommand DEFINE LABEL <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlBorder                := .f.          ;;
        _OOHG_ActiveControlClientEdge    := .f.          ;;
        _OOHG_ActiveControlHScroll               := .f.          ;;
        _OOHG_ActiveControlVScroll               := .f.          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlAction                := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.          ;;
        _OOHG_ActiveControlTooltip           := Nil          ;;
        _OOHG_ActiveControlRightAlign    := .F.          ;;
        _OOHG_ActiveControlAutoSize              := .f. ;;
        _OOHG_ActiveControlCenterAlign := .F.

#xcommand BACKCOLOR	<color>;
	=>;
        _OOHG_ActiveControlBackColor             := <color>

#xcommand CENTERALIGN	<centeralign> ;
	=> ;
        _OOHG_ActiveControlCenterAlign           := <centeralign>

#xcommand FONTCOLOR	<color>;
	=>;
        _OOHG_ActiveControlFontColor             := <color>

#xcommand FORECOLOR	<color>;
	=>;
        _OOHG_ActiveControlForeColor             := <color>

#xcommand FONTBOLD	<bold>;
	=>;
        _OOHG_ActiveControlFontBold              := <bold>

#xcommand BORDER	<border>;
	=>;
        _OOHG_ActiveControlBorder                := <border>

#xcommand CLIENTEDGE	<clientedge>;
	=>;
        _OOHG_ActiveControlClientEdge    := <clientedge>

#xcommand HSCROLL	<hscroll>;
	=>;
        _OOHG_ActiveControlHScroll               := <hscroll>

#xcommand VSCROLL	<vscroll>;
	=>;
        _OOHG_ActiveControlVScroll               := <vscroll>

#xcommand TRANSPARENT	<transparent>;
	=>;
        _OOHG_ActiveControlTransparent   := <transparent>

#xcommand END LABEL ;
	=>;
        TLabel():Define( ;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlFontBold,;
                _OOHG_ActiveControlBorder,;
                _OOHG_ActiveControlClientEdge,;
                _OOHG_ActiveControlHScroll,;
                _OOHG_ActiveControlVScroll,;
                _OOHG_ActiveControlTransparent,;
                _OOHG_ActiveControlBackColor,;
                _OOHG_ActiveControlFontColor,;
                _OOHG_ActiveControlAction,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible , ;
                _OOHG_ActiveControlFontItalic , ;
                _OOHG_ActiveControlFontUnderLine , ;
                _OOHG_ActiveControlFontStrikeOut , ;
                _OOHG_ActiveControlAutoSize , ;
                _OOHG_ActiveControlRightAlign , ;
                _OOHG_ActiveControlCenterAlign )


#xcommand DEFINE IPADDRESS <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlInvisible             := .f.          ;;
        _OOHG_ActiveControlNoTabStop         := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.

#xcommand END IPADDRESS ;
=>;
   _DefineIPAddress( ;
      _OOHG_ActiveControlName , ;
      _OOHG_ActiveControlOf , ;
      _OOHG_ActiveControlCol , ;
      _OOHG_ActiveControlRow , ;
      _OOHG_ActiveControlWidth , ;
      _OOHG_ActiveControlHeight , ;
      _OOHG_ActiveControlValue , ;
      _OOHG_ActiveControlFont , ;
      _OOHG_ActiveControlSize , ;
      _OOHG_ActiveControlTooltip, ;
      _OOHG_ActiveControlOnLostFocus , ;
      _OOHG_ActiveControlOnGotFocus , ;
      _OOHG_ActiveControlOnChange , ;
      _OOHG_ActiveControlHelpId  , ;
        _OOHG_ActiveControlInvisible , ;
        _OOHG_ActiveControlNoTabStop ,;
        _OOHG_ActiveControlFontBold , ;
        _OOHG_ActiveControlFontItalic , ;
        _OOHG_ActiveControlFontUnderLine , ;
        _OOHG_ActiveControlFontStrikeOut )


/*----------------------------------------------------------------------------
Grid
---------------------------------------------------------------------------*/

#xcommand DEFINE GRID <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol               := Nil          ;;
        _OOHG_ActiveControlRow               := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlHeaders               := Nil          ;;
        _OOHG_ActiveControlWidths                := Nil          ;;
        _OOHG_ActiveControlItems         := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlOnDblClick    := Nil          ;;
        _OOHG_ActiveControlOnHeadClick   := Nil          ;;
        _OOHG_ActiveControlNoLines               := .f.          ;;
        _OOHG_ActiveControlImage         := Nil          ;;
        _OOHG_ActiveControlJustify               := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlMultiSelect   := .f.          ;;
        _OOHG_ActiveControlEdit              := .f.          ;;
        _OOHG_ActiveControlBreak             := .f.              ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.          ;;
        _OOHG_ActiveControlOnQueryData   := Nil          ;;
        _OOHG_ActiveControlItemCount             := Nil          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlReadOnly              := Nil          ;;
        _OOHG_ActiveControlVirtual               := .f.          ;;
        _OOHG_ActiveControlPicture := nil

#xcommand END GRID ;
	=>;
iif( _OOHG_ActiveControlMultiSelect, TGridMulti(), TGrid() ):Define( ;
                _OOHG_ActiveControlName ,  ;
                _OOHG_ActiveControlOf ,  ;
                _OOHG_ActiveControlCol ,         ;
                _OOHG_ActiveControlRow ,         ;
                _OOHG_ActiveControlWidth ,               ;
                _OOHG_ActiveControlHeight ,              ;
                _OOHG_ActiveControlHeaders ,     ;
                _OOHG_ActiveControlWidths ,      ;
                _OOHG_ActiveControlItems ,       ;
                _OOHG_ActiveControlValue ,       ;
                _OOHG_ActiveControlFont ,        ;
                _OOHG_ActiveControlSize ,        ;
                _OOHG_ActiveControlTooltip ,     ;
                _OOHG_ActiveControlOnChange ,    ;
                _OOHG_ActiveControlOnDblClick ,  ;
                _OOHG_ActiveControlOnHeadClick , ;
                _OOHG_ActiveControlOnGotFocus ,  ;
                _OOHG_ActiveControlOnLostFocus,  ;
                _OOHG_ActiveControlNoLines,      ;
                _OOHG_ActiveControlImage,        ;
                _OOHG_ActiveControlJustify  ,    ;
                _OOHG_ActiveControlBreak ,       ;
                _OOHG_ActiveControlHelpId ,      ;
                _OOHG_ActiveControlFontBold,     ;
                _OOHG_ActiveControlFontItalic,   ;
                _OOHG_ActiveControlFontUnderLine,        ;
                _OOHG_ActiveControlFontStrikeOut , ;
                _OOHG_ActiveControlVirtual , ;
                _OOHG_ActiveControlOnQueryData ,  ;
                _OOHG_ActiveControlItemCount ,   ;
                _OOHG_ActiveControlEdit ,  ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlPicture )

/*----------------------------------------------------------------------------
BROWSE
---------------------------------------------------------------------------*/

#xcommand DEFINE BROWSE <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol               := Nil          ;;
        _OOHG_ActiveControlRow               := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlHeaders               := Nil          ;;
        _OOHG_ActiveControlWidths                := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlOnDblClick    := Nil          ;;
        _OOHG_ActiveControlOnHeadClick   := Nil          ;;
        _OOHG_ActiveControlNoLines               := .f.          ;;
        _OOHG_ActiveControlImage         := Nil          ;;
        _OOHG_ActiveControlJustify               := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlEdit              := .f.          ;;
        _OOHG_ActiveControlBreak             := .f.              ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.          ;;
        _OOHG_ActiveControlWorkArea              := Nil          ;;
        _OOHG_ActiveControlFields                := Nil          ;;
        _OOHG_ActiveControlDelete                := .f.          ;;
        _OOHG_ActiveControlAppendable        := .f.              ;;
        _OOHG_ActiveControlValid         := Nil          ;;
        _OOHG_ActiveControlReadOnly              := Nil          ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlLock          := .f.          ;;
        _OOHG_ActiveControlValidMessages := Nil          ;;
        _OOHG_ActiveControlNoVScroll             := .f.          ;;
        _OOHG_ActiveControlPicture := nil                ;;
        _OOHG_ActiveControlInPlaceEdit   := .f.

#xcommand END BROWSE ;
	=>;
TBrowse():Define( _OOHG_ActiveControlName ,        ;
                _OOHG_ActiveControlOf ,  ;
                _OOHG_ActiveControlCol ,         ;
                _OOHG_ActiveControlRow ,         ;
                _OOHG_ActiveControlWidth ,               ;
                _OOHG_ActiveControlHeight ,              ;
                _OOHG_ActiveControlHeaders ,     ;
                _OOHG_ActiveControlWidths ,      ;
                _OOHG_ActiveControlFields ,      ;
                _OOHG_ActiveControlValue ,       ;
                _OOHG_ActiveControlFont ,        ;
                _OOHG_ActiveControlSize ,        ;
                _OOHG_ActiveControlTooltip ,     ;
                _OOHG_ActiveControlOnChange ,    ;
                _OOHG_ActiveControlOnDblClick  ,  ;
                _OOHG_ActiveControlOnHeadClick ,;
                _OOHG_ActiveControlOnGotFocus ,  ;
                _OOHG_ActiveControlOnLostFocus,  ;
                _OOHG_ActiveControlWorkArea ,    ;
                _OOHG_ActiveControlDelete,       ;
                _OOHG_ActiveControlNoLines ,     ;
                _OOHG_ActiveControlImage ,       ;
                _OOHG_ActiveControlJustify ,     ;
                _OOHG_ActiveControlHelpId  , ;
                _OOHG_ActiveControlFontBold , ;
                _OOHG_ActiveControlFontItalic , ;
                _OOHG_ActiveControlFontUnderLine , ;
                _OOHG_ActiveControlFontStrikeOut , ;
                _OOHG_ActiveControlBreak  , ;
                _OOHG_ActiveControlBackColor , ;
                _OOHG_ActiveControlFontColor , ;
                _OOHG_ActiveControlLock  , ;
                _OOHG_ActiveControlInPlaceEdit , ;
                _OOHG_ActiveControlNoVScroll , ;
                _OOHG_ActiveControlAppendable , ;
                _OOHG_ActiveControlReadOnly , ;
                _OOHG_ActiveControlValid , ;
                _OOHG_ActiveControlValidMessages , ;
                _OOHG_ActiveControlEdit, ;
                , ; // DynamicBackColor
                , ; // aWhenFields
                , ; // DynamicForeColor
                _OOHG_ActiveControlPicture )

/*----------------------------------------------------------------------------
Hyperlink
---------------------------------------------------------------------------*/

#xcommand DEFINE HYPERLINK <name> ;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol               := Nil          ;;
        _OOHG_ActiveControlRow               := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlAddress           := Nil          ;;
        _OOHG_ActiveControlValue             := Nil          ;;
        _OOHG_ActiveControlAutoSize          := .f.          ;;
        _OOHG_ActiveControlFont              := Nil          ;;
        _OOHG_ActiveControlSize              := Nil          ;;
        _OOHG_ActiveControlFontBold          := .f.          ;;
        _OOHG_ActiveControlFontItalic        := .f.          ;;
        _OOHG_ActiveControlTooltip           := Nil          ;;
        _OOHG_ActiveControlBackColor         := Nil          ;;
        _OOHG_ActiveControlFontColor         := Nil          ;;
        _OOHG_ActiveControlBorder            := .f.          ;;
        _OOHG_ActiveControlClientEdge        := .f.          ;;
        _OOHG_ActiveControlHScroll           := .f.          ;;
        _OOHG_ActiveControlVScroll           := .f.          ;;
        _OOHG_ActiveControlTransparent       := .f.          ;;
        _OOHG_ActiveControlHelpid            := Nil          ;;
        _OOHG_ActiveControlHandCursor            := .F.          ;;
        _OOHG_ActiveControlinvisible         := .f.

#xcommand ADDRESS   <address>;
	=>;
        _OOHG_ActiveControlAddress       := <address>

#xcommand HANDCURSOR   <handcursor>;
	=>;
        _OOHG_ActiveControlHandCursor       := <handcursor>

#xcommand END HYPERLINK ;
	=>;
        THyperLink():Define(     ;
        _OOHG_ActiveControlName ,;
        _OOHG_ActiveControlOf,;
        _OOHG_ActiveControlCol,;
        _OOHG_ActiveControlRow,;
        _OOHG_ActiveControlValue,;
        _OOHG_ActiveControlAddress,;
        _OOHG_ActiveControlWidth,;
        _OOHG_ActiveControlHeight,;
        _OOHG_ActiveControlFont ,    ;
        _OOHG_ActiveControlSize ,    ;
        _OOHG_ActiveControlFontBold,;
        _OOHG_ActiveControlBorder,;
        _OOHG_ActiveControlClientEdge,;
        _OOHG_ActiveControlHScroll,;
        _OOHG_ActiveControlVScroll,;
        _OOHG_ActiveControlTransparent,;
        _OOHG_ActiveControlBackColor,;
        _OOHG_ActiveControlFontColor,;
        _OOHG_ActiveControlTooltip,;
        _OOHG_ActiveControlHelpId,;
        _OOHG_ActiveControlInvisible,;
        _OOHG_ActiveControlFontItalic,;
        _OOHG_ActiveControlAutosize , ;
        _OOHG_ActiveControlHandCursor )


/*----------------------------------------------------------------------------
Spinner
---------------------------------------------------------------------------*/

#xcommand WRAP		<wrap>;
	=>;
        _OOHG_ActiveControlWrap  := <wrap>

#xcommand INCREMENT		<increment>;
	=>;
        _OOHG_ActiveControlIncrement     := <increment>

#xcommand DEFINE SPINNER <name>;
	=>;
        _OOHG_ActiveControlName         := <"name">     ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlRangeLow              := Nil          ;;
        _OOHG_ActiveControlRangeHigh             := Nil          ;;
        _OOHG_ActiveControlTooltip               := Nil          ;;
        _OOHG_ActiveControlOnChange              := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlHeight                := Nil          ;;
        _OOHG_ActiveControlHelpId                := Nil          ;;
        _OOHG_ActiveControlFontBold              := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.          ;;
        _OOHG_ActiveControlNoTabStop    := .f.   ;;
        _OOHG_ActiveControlBackColor             := Nil          ;;
        _OOHG_ActiveControlFontColor             := Nil          ;;
        _OOHG_ActiveControlWrap          := .F.          ;;
        _OOHG_ActiveControlReadOnly              := .F.          ;;
        _OOHG_ActiveControlIncrement             := Nil      ;;
        _OOHG_ActiveControlinvisible         := .f.   ;;
        _OOHG_ActiveControlNoTabStop             := .f.

#xcommand END SPINNER;
	=>;
	_DefineSpinner(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlRangeLow,;
                _OOHG_ActiveControlRangeHigh,;
                _OOHG_ActiveControlTooltip,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlOnLostFocus,;
                _OOHG_ActiveControlOnGotFocus,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlHelpId , ;
                _OOHG_ActiveControlinvisible , ;
                _OOHG_ActiveControlNoTabStop , ;
                _OOHG_ActiveControlFontBold , ;
                _OOHG_ActiveControlFontItalic , ;
                _OOHG_ActiveControlFontUnderLine , ;
                _OOHG_ActiveControlFontStrikeOut , ;
                _OOHG_ActiveControlWrap , ;
                _OOHG_ActiveControlReadOnly , ;
                _OOHG_ActiveControlIncrement ,;
                _OOHG_ActiveControlBackColor,;
                _OOHG_ActiveControlFontColor)