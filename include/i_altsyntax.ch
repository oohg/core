/*
 * $Id: i_altsyntax.ch,v 1.45 2010-05-15 21:05:04 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Alternate syntax definitions
 *
 * Copyright 2005-2010 Vicente Guerra <vicente@guerra.com.mx>
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

/*---------------------------------------------------------------------------------------------------
Memvariables
----------------------------------------------------------------------------------------------------*/

#xtranslate _OOHG_ActiveControlName                   => _OOHG_ActiveControlInfo \[   1 \]
#xtranslate _OOHG_ActiveControlOf                     => _OOHG_ActiveControlInfo \[   2 \]
#xtranslate _OOHG_ActiveControlRow                    => _OOHG_ActiveControlInfo \[   3 \]
#xtranslate _OOHG_ActiveControlCol                    => _OOHG_ActiveControlInfo \[   4 \]
#xtranslate _OOHG_ActiveControlWidth                  => _OOHG_ActiveControlInfo \[   5 \]
#xtranslate _OOHG_ActiveControlHeight                 => _OOHG_ActiveControlInfo \[   6 \]
#xtranslate _OOHG_ActiveControlFont                   => _OOHG_ActiveControlInfo \[   7 \]
#xtranslate _OOHG_ActiveControlSize                   => _OOHG_ActiveControlInfo \[   8 \]
#xtranslate _OOHG_ActiveControlFontBold               => _OOHG_ActiveControlInfo \[   9 \]
#xtranslate _OOHG_ActiveControlFontItalic             => _OOHG_ActiveControlInfo \[  10 \]
#xtranslate _OOHG_ActiveControlFontStrikeOut          => _OOHG_ActiveControlInfo \[  11 \]
#xtranslate _OOHG_ActiveControlFontUnderLine          => _OOHG_ActiveControlInfo \[  12 \]
#xtranslate _OOHG_ActiveControlFontColor              => _OOHG_ActiveControlInfo \[  13 \]
#xtranslate _OOHG_ActiveControlBackColor              => _OOHG_ActiveControlInfo \[  14 \]
#xtranslate _OOHG_ActiveControlRtl                    => _OOHG_ActiveControlInfo \[  15 \]
#xtranslate _OOHG_ActiveControlValue                  => _OOHG_ActiveControlInfo \[  16 \]
#xtranslate _OOHG_ActiveControlTooltip                => _OOHG_ActiveControlInfo \[  17 \]
#xtranslate _OOHG_ActiveControlNoTabStop              => _OOHG_ActiveControlInfo \[  18 \]
#xtranslate _OOHG_ActiveControlInvisible              => _OOHG_ActiveControlInfo \[  19 \]
#xtranslate _OOHG_ActiveControlHelpId                 => _OOHG_ActiveControlInfo \[  20 \]
#xtranslate _OOHG_ActiveControlDisabled               => _OOHG_ActiveControlInfo \[  21 \]
#xtranslate _OOHG_ActiveControlShowHeaders            => _OOHG_ActiveControlInfo \[  22 \]
#xtranslate _OOHG_ActiveControlTitleFontColor         => _OOHG_ActiveControlInfo \[  23 \]
#xtranslate _OOHG_ActiveControlTitleBackColor         => _OOHG_ActiveControlInfo \[  24 \]
#xtranslate _OOHG_ActiveControlTrailingFontColor      => _OOHG_ActiveControlInfo \[  25 \]
#xtranslate _OOHG_ActiveControlBackgroundColor        => _OOHG_ActiveControlInfo \[  26 \]

#xtranslate _OOHG_ActiveControlEditControls           => _OOHG_ActiveControlInfo \[ 201 \]
#xtranslate _OOHG_ActiveControlWhen                   => _OOHG_ActiveControlInfo \[ 202 \]
#xtranslate _OOHG_ActiveControlReplaceFields          => _OOHG_ActiveControlInfo \[ 203 \]
#xtranslate _OOHG_ActiveControlDynamicForeColor       => _OOHG_ActiveControlInfo \[ 204 \]
#xtranslate _OOHG_ActiveControlDynamicBackColor       => _OOHG_ActiveControlInfo \[ 205 \]
#xtranslate _OOHG_ActiveControlEditCell               => _OOHG_ActiveControlInfo \[ 206 \]

#xtranslate _OOHG_ActiveControlHandCursor             => _OOHG_ActiveControlInfo \[ 207 \]
#xtranslate _OOHG_ActiveControlCenterAlign            => _OOHG_ActiveControlInfo \[ 208 \]
#xtranslate _OOHG_ActiveControlNoHScroll              => _OOHG_ActiveControlInfo \[ 209 \]
#xtranslate _OOHG_ActiveControlGripperText            => _OOHG_ActiveControlInfo \[ 210 \]
#xtranslate _OOHG_ActiveControlDisplayEdit            => _OOHG_ActiveControlInfo \[ 211 \]
#xtranslate _OOHG_ActiveControlDisplayChange          => _OOHG_ActiveControlInfo \[ 212 \]

#xtranslate _OOHG_ActiveControlNoVScroll              => _OOHG_ActiveControlInfo \[ 213 \]

#xtranslate _OOHG_ActiveControlForeColor              => _OOHG_ActiveControlInfo \[ 214 \]

#xtranslate _OOHG_ActiveControlDateType               => _OOHG_ActiveControlInfo \[ 215 \]

#xtranslate _OOHG_ActiveControlInPlaceEdit            => _OOHG_ActiveControlInfo \[ 216 \]
#xtranslate _OOHG_ActiveControlItemSource             => _OOHG_ActiveControlInfo \[ 217 \]
#xtranslate _OOHG_ActiveControlValueSource            => _OOHG_ActiveControlInfo \[ 218 \]

#xtranslate _OOHG_ActiveControlWrap                   => _OOHG_ActiveControlInfo \[ 219 \]
#xtranslate _OOHG_ActiveControlIncrement              => _OOHG_ActiveControlInfo \[ 220 \]

#xtranslate _OOHG_ActiveControlAddress                => _OOHG_ActiveControlInfo \[ 221 \]

#xtranslate _OOHG_ActiveControlItemCount              => _OOHG_ActiveControlInfo \[ 222 \]

#xtranslate _OOHG_ActiveControlOnQueryData            => _OOHG_ActiveControlInfo \[ 223 \]

#xtranslate _OOHG_ActiveControlAutoSize               => _OOHG_ActiveControlInfo \[ 224 \]

#xtranslate _OOHG_ActiveControlVirtual                => _OOHG_ActiveControlInfo \[ 225 \]

#xtranslate _OOHG_ActiveControlStretch                => _OOHG_ActiveControlInfo \[ 226 \]

#xtranslate _OOHG_ActiveControlCaption                => _OOHG_ActiveControlInfo \[ 227 \]
#xtranslate _OOHG_ActiveControlAction                 => _OOHG_ActiveControlInfo \[ 228 \]
#xtranslate _OOHG_ActiveControlFlat                   => _OOHG_ActiveControlInfo \[ 229 \]
#xtranslate _OOHG_ActiveControlOnGotFocus             => _OOHG_ActiveControlInfo \[ 230 \]
#xtranslate _OOHG_ActiveControlOnLostFocus            => _OOHG_ActiveControlInfo \[ 231 \]
#xtranslate _OOHG_ActiveControlPicture                => _OOHG_ActiveControlInfo \[ 232 \]

#xtranslate _OOHG_ActiveControlOnChange               => _OOHG_ActiveControlInfo \[ 233 \]

#xtranslate _OOHG_ActiveControlItems                  => _OOHG_ActiveControlInfo \[ 234 \]
#xtranslate _OOHG_ActiveControlOnEnter                => _OOHG_ActiveControlInfo \[ 235 \]

#xtranslate _OOHG_ActiveControlShowNone               => _OOHG_ActiveControlInfo \[ 236 \]
#xtranslate _OOHG_ActiveControlUpDown                 => _OOHG_ActiveControlInfo \[ 237 \]
#xtranslate _OOHG_ActiveControlRightAlign             => _OOHG_ActiveControlInfo \[ 238 \]

#xtranslate _OOHG_ActiveControlReadOnly               => _OOHG_ActiveControlInfo \[ 239 \]
#xtranslate _OOHG_ActiveControlMaxLength              => _OOHG_ActiveControlInfo \[ 240 \]
#xtranslate _OOHG_ActiveControlBreak                  => _OOHG_ActiveControlInfo \[ 241 \]

#xtranslate _OOHG_ActiveControlOpaque                 => _OOHG_ActiveControlInfo \[ 242 \]

#xtranslate _OOHG_ActiveControlHeaders                => _OOHG_ActiveControlInfo \[ 243 \]
#xtranslate _OOHG_ActiveControlWidths                 => _OOHG_ActiveControlInfo \[ 244 \]
#xtranslate _OOHG_ActiveControlOnDblClick             => _OOHG_ActiveControlInfo \[ 245 \]
#xtranslate _OOHG_ActiveControlOnRDblClick            => _OOHG_ActiveControlInfo \[ 246 \]
#xtranslate _OOHG_ActiveControlOnMDblClick            => _OOHG_ActiveControlInfo \[ 247 \]
#xtranslate _OOHG_ActiveControlOnHeadClick            => _OOHG_ActiveControlInfo \[ 248 \]
#xtranslate _OOHG_ActiveControlNoLines                => _OOHG_ActiveControlInfo \[ 249 \]
#xtranslate _OOHG_ActiveControlImage                  => _OOHG_ActiveControlInfo \[ 250 \]
#xtranslate _OOHG_ActiveControlJustify                => _OOHG_ActiveControlInfo \[ 251 \]

#xtranslate _OOHG_ActiveControlNoToday                => _OOHG_ActiveControlInfo \[ 252 \]
#xtranslate _OOHG_ActiveControlNoTodayCircle          => _OOHG_ActiveControlInfo \[ 253 \]
#xtranslate _OOHG_ActiveControlWeekNumbers            => _OOHG_ActiveControlInfo \[ 254 \]

#xtranslate _OOHG_ActiveControlMultiSelect            => _OOHG_ActiveControlInfo \[ 255 \]
#xtranslate _OOHG_ActiveControlEdit                   => _OOHG_ActiveControlInfo \[ 256 \]

#xtranslate _OOHG_ActiveControlBorder                 => _OOHG_ActiveControlInfo \[ 257 \]
#xtranslate _OOHG_ActiveControlNoBorder               => _OOHG_ActiveControlInfo \[ 258 \]
#xtranslate _OOHG_ActiveControlFocusedPos             => _OOHG_ActiveControlInfo \[ 259 \]
#xtranslate _OOHG_ActiveControlClientEdge             => _OOHG_ActiveControlInfo \[ 260 \]
#xtranslate _OOHG_ActiveControlHScroll                => _OOHG_ActiveControlInfo \[ 261 \]
#xtranslate _OOHG_ActiveControlVscroll                => _OOHG_ActiveControlInfo \[ 262 \]
#xtranslate _OOHG_ActiveControlTransparent            => _OOHG_ActiveControlInfo \[ 263 \]
#xtranslate _OOHG_ActiveControlNoWordWrap             => _OOHG_ActiveControlInfo \[ 264 \]
#xtranslate _OOHG_ActiveControlNoPrefix               => _OOHG_ActiveControlInfo \[ 265 \]

#xtranslate _OOHG_ActiveControlSort                   => _OOHG_ActiveControlInfo \[ 266 \]

#xtranslate _OOHG_ActiveControlRangeLow               => _OOHG_ActiveControlInfo \[ 267 \]
#xtranslate _OOHG_ActiveControlRangeHigh              => _OOHG_ActiveControlInfo \[ 268 \]
#xtranslate _OOHG_ActiveControlVertical               => _OOHG_ActiveControlInfo \[ 269 \]
#xtranslate _OOHG_ActiveControlSmooth                 => _OOHG_ActiveControlInfo \[ 270 \]

#xtranslate _OOHG_ActiveControlOptions                => _OOHG_ActiveControlInfo \[ 271 \]
#xtranslate _OOHG_ActiveControlSpacing                => _OOHG_ActiveControlInfo \[ 272 \]
#xtranslate _OOHG_ActiveControlHorizontal             => _OOHG_ActiveControlInfo \[ 273 \]

#xtranslate _OOHG_ActiveControlNoTicks                => _OOHG_ActiveControlInfo \[ 274 \]
#xtranslate _OOHG_ActiveControlBoth                   => _OOHG_ActiveControlInfo \[ 275 \]
#xtranslate _OOHG_ActiveControlTop                    => _OOHG_ActiveControlInfo \[ 276 \]
#xtranslate _OOHG_ActiveControlLeft                   => _OOHG_ActiveControlInfo \[ 277 \]

#xtranslate _OOHG_ActiveControlUpperCase              => _OOHG_ActiveControlInfo \[ 278 \]
#xtranslate _OOHG_ActiveControlLowerCase              => _OOHG_ActiveControlInfo \[ 279 \]
#xtranslate _OOHG_ActiveControlNumeric                => _OOHG_ActiveControlInfo \[ 280 \]
#xtranslate _OOHG_ActiveControlPassword               => _OOHG_ActiveControlInfo \[ 281 \]
#xtranslate _OOHG_ActiveControlInputMask              => _OOHG_ActiveControlInfo \[ 282 \]
#xtranslate _OOHG_ActiveControlAutoSkip               => _OOHG_ActiveControlInfo \[ 283 \]

#xtranslate _OOHG_ActiveControlWorkArea               => _OOHG_ActiveControlInfo \[ 284 \]
#xtranslate _OOHG_ActiveControlFields                 => _OOHG_ActiveControlInfo \[ 285 \]
#xtranslate _OOHG_ActiveControlDelete                 => _OOHG_ActiveControlInfo \[ 286 \]
#xtranslate _OOHG_ActiveControlValid                  => _OOHG_ActiveControlInfo \[ 287 \]
#xtranslate _OOHG_ActiveControlValidMessages          => _OOHG_ActiveControlInfo \[ 288 \]
#xtranslate _OOHG_ActiveControlLock                   => _OOHG_ActiveControlInfo \[ 289 \]
#xtranslate _OOHG_ActiveControlAppendable             => _OOHG_ActiveControlInfo \[ 290 \]

#xtranslate _OOHG_ActiveControlFile                   => _OOHG_ActiveControlInfo \[ 291 \]
#xtranslate _OOHG_ActiveControlAutoPlay               => _OOHG_ActiveControlInfo \[ 292 \]
#xtranslate _OOHG_ActiveControlCenter                 => _OOHG_ActiveControlInfo \[ 293 \]
#xtranslate _OOHG_ActiveControlNoAutoSizeWindow       => _OOHG_ActiveControlInfo \[ 294 \]
#xtranslate _OOHG_ActiveControlNoAuotSizeMovie        => _OOHG_ActiveControlInfo \[ 295 \]
#xtranslate _OOHG_ActiveControlNoErrorDlg             => _OOHG_ActiveControlInfo \[ 296 \]
#xtranslate _OOHG_ActiveControlNoMenu                 => _OOHG_ActiveControlInfo \[ 297 \]
#xtranslate _OOHG_ActiveControlNoOpen                 => _OOHG_ActiveControlInfo \[ 298 \]
#xtranslate _OOHG_ActiveControlNoPlayBar              => _OOHG_ActiveControlInfo \[ 299 \]
#xtranslate _OOHG_ActiveControlShowAll                => _OOHG_ActiveControlInfo \[ 190 \]
#xtranslate _OOHG_ActiveControlShowMode               => _OOHG_ActiveControlInfo \[ 191 \]
#xtranslate _OOHG_ActiveControlShowName               => _OOHG_ActiveControlInfo \[ 192 \]
#xtranslate _OOHG_ActiveControlShowPosition           => _OOHG_ActiveControlInfo \[ 193 \]

#xtranslate _OOHG_ActiveControlFormat                 => _OOHG_ActiveControlInfo \[ 194 \]
#xtranslate _OOHG_ActiveControlField                  => _OOHG_ActiveControlInfo \[ 195 \]
#xtranslate _OOHG_ActiveControlOnAppend               => _OOHG_ActiveControlInfo \[ 196 \]

#xcommand _OOHG_ClearActiveControlInfo( <name> ) => ;
        _OOHG_ActiveControlInfo          := ARRAY( 300 ) ;;
        _OOHG_ActiveControlName          := <name>       ;;
        _OOHG_ActiveControlOf            := Nil          ;;
        _OOHG_ActiveControlRow           := Nil          ;;
        _OOHG_ActiveControlCol           := Nil          ;;
        _OOHG_ActiveControlWidth         := Nil          ;;
        _OOHG_ActiveControlHeight        := Nil          ;;
        _OOHG_ActiveControlFont          := Nil          ;;
        _OOHG_ActiveControlSize          := Nil          ;;
        _OOHG_ActiveControlFontBold      := .f.          ;;
        _OOHG_ActiveControlFontItalic    := .f.          ;;
        _OOHG_ActiveControlFontStrikeOut := .f.          ;;
        _OOHG_ActiveControlFontUnderLine := .f.          ;;
        _OOHG_ActiveControlFontColor     := Nil          ;;
        _OOHG_ActiveControlBackColor     := Nil          ;;
        _OOHG_ActiveControlRtl           := .f.          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlTooltip       := Nil          ;;
        _OOHG_ActiveControlNoTabStop     := .f.          ;;
        _OOHG_ActiveControlInvisible     := .f.          ;;
        _OOHG_ActiveControlHelpId        := Nil          ;;
        _OOHG_ActiveControlDisabled      := .f.          ;;
        _OOHG_ActiveControlOnDblClick    := Nil          ;;
        _OOHG_ActiveControlOnRDblClick   := Nil          ;;
        _OOHG_ActiveControlOnMDblClick   := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange      := Nil          ;;
        _OOHG_ActiveControlOnEnter       := nil

#xcommand PARENT <of> ;
        =>;
        _OOHG_ActiveControlOf := <(of)>

#xcommand ROW <row> ;
        =>;
        _OOHG_ActiveControlRow := <row>

#xcommand COL  <col> ;
        =>;
        _OOHG_ActiveControlCol := <col>

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

#xcommand FONTBOLD	<bold>;
	=>;
        _OOHG_ActiveControlFontBold              := <bold>

#xcommand FONTITALIC	<i>;
	=>;
        _OOHG_ActiveControlFontItalic    := <i>

#xcommand FONTSTRIKEOUT	<s>;
	=>;
        _OOHG_ActiveControlFontStrikeOut := <s>

#xcommand FONTUNDERLINE	<u>;
	=>;
        _OOHG_ActiveControlFontUnderline         := <u>

#xcommand FONTCOLOR	<color>;
	=>;
        _OOHG_ActiveControlFontColor             := <color>

#xcommand BACKCOLOR	<color>;
	=>;
        _OOHG_ActiveControlBackColor             := <color>

#xcommand RTL              <l>;
	=>;
        _OOHG_ActiveControlRtl              := <l>

#xcommand VALUE <value> ;
	=>;
        _OOHG_ActiveControlValue := <value>

#xcommand TOOLTIP <tooltip> ;
        =>;
        _OOHG_ActiveControlTooltip := <tooltip>

#xcommand TABSTOP <notabstop> ;
        =>;
        _OOHG_ActiveControlNoTabStop := .NOT. <notabstop>

#xcommand VISIBLE <visible> ;
        =>;
        _OOHG_ActiveControlInvisible := .NOT. <visible>

#xcommand HELPID <helpid> ;
        =>;
        _OOHG_ActiveControlHelpId := <helpid>

#xcommand DISABLED <disabled> ;
        =>;
        _OOHG_ActiveControlDisabled := <disabled>






#xcommand ITEMSOURCE <itemsource>;
   =>;
   _OOHG_ActiveControlItemSource := <(itemsource)>

#xcommand VALUESOURCE <valuesource>;
   =>;
   _OOHG_ActiveControlValueSource := <(valuesource)>

#xcommand COLUMNCONTROLS <editcontrols>;
   =>;
        _OOHG_ActiveControlEditControls := <editcontrols>

#xcommand EDITCELL <editcell>;
   =>;
        _OOHG_ActiveControlEditCell := <editcell>

#xcommand WORKAREA <workarea>;
	=>;
        _OOHG_ActiveControlWorkArea              := <(workarea)>

#xcommand FIELD        <field>;
	=>;
        _OOHG_ActiveControlField            := <(field)>

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

#xcommand AUTOSIZE		<a>;
	=>;
        _OOHG_ActiveControlAutoSize              := <a>

#xcommand SHOWHEADERS           <a>;
	=>;
        _OOHG_ActiveControlShowHeaders            := <a>


/*----------------------------------------------------------------------------
Frame
---------------------------------------------------------------------------*/


#xcommand DEFINE FRAME <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlCaption               := Nil          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlOpaque                := .f.


#xcommand OPAQUE <opaque> ;
	=>;
        _OOHG_ActiveControlOpaque        := <opaque>

#xcommand END FRAME ;
	=>;
        TFrame():Define(;
                _OOHG_ActiveControlName,;
                _OOHG_ActiveControlOf,;
                _OOHG_ActiveControlRow,;
                _OOHG_ActiveControlCol,;
                _OOHG_ActiveControlWidth,;
                _OOHG_ActiveControlHeight,;
                _OOHG_ActiveControlCaption,;
                _OOHG_ActiveControlFont,;
                _OOHG_ActiveControlSize,;
                _OOHG_ActiveControlOpaque,;
                _OOHG_ActiveControlFontBold,;
                _OOHG_ActiveControlFontItalic,;
                _OOHG_ActiveControlFontUnderLine,;
                _OOHG_ActiveControlFontStrikeOut,;
                _OOHG_ActiveControlBackColor,;
                _OOHG_ActiveControlFontColor,;
                _OOHG_ActiveControlTransparent,;
                _OOHG_ActiveControlRtl )


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
        _OOHG_ActiveControlOnHeadClick   := <aHeadClick>

#xcommand ON HEADCLICK <aHeadClick> ;
	=>;
        _OOHG_ActiveControlOnHeadClick   := <aHeadClick>

#xcommand DYNAMICBACKCOLOR <aDynamicBackColor> ;
        =>;
        _OOHG_ActiveControlDynamicBackColor := <aDynamicBackColor>

#xcommand DYNAMICFORECOLOR <aDynamicForeColor> ;
        =>;
        _OOHG_ActiveControlDynamicForeColor := <aDynamicForeColor>

#xcommand WHEN <aWhenFields> ;
        =>;
        _OOHG_ActiveControlWhen   := <aWhenFields>

#xcommand REPLACEFIELD <aReplaceFields> ;
        =>;
        _OOHG_ActiveControlReplaceFields := <aReplaceFields>

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
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlItems         := Nil          ;;
        _OOHG_ActiveControlMultiSelect   := .f.          ;;
        _OOHG_ActiveControlBreak         := .f.          ;;
        _OOHG_ActiveControlSort          := .f.

#xcommand SORT	<sort>	;
	=>;
        _OOHG_ActiveControlSort          := <sort>

#xcommand END LISTBOX	;
	=>;
        iif( _OOHG_ActiveControlMultiSelect, TListMulti(), TList() ):Define( ;
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
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlOnEnter )

///////////////////////////////////////////////////////////////////////////////
// ANIMATEBOX COMMANDS
///////////////////////////////////////////////////////////////////////////////

#xcommand DEFINE ANIMATEBOX <name>;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlAutoPlay              := .f.          ;;
        _OOHG_ActiveControlCenter                := .f.          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlFile          := Nil

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
        TAnimateBox():Define(;
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
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible,;
                _OOHG_ActiveControlNoTabStop,;
                _OOHG_ActiveControlDisabled,;
                _OOHG_ActiveControlRtl)

#xcommand DEFINE PLAYER <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlFile          := Nil          ;;
        _OOHG_ActiveControlNoAutoSizeWindow      := .f.          ;;
        _OOHG_ActiveControlNoAutoSizeMovie       := .f.          ;;
        _OOHG_ActiveControlNoErrorDlg    := .f.          ;;
        _OOHG_ActiveControlNoMenu                := .f.          ;;
        _OOHG_ActiveControlNoOpen                := .f.          ;;
        _OOHG_ActiveControlNoPlayBar             := .f.          ;;
        _OOHG_ActiveControlShowAll               := .f.          ;;
        _OOHG_ActiveControlShowMode              := .f.          ;;
        _OOHG_ActiveControlShowName              := .f.          ;;
        _OOHG_ActiveControlShowPosition  := .f.

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
        TPlayer():Define(;
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
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible,;
                _OOHG_ActiveControlNoTabStop,;
                _OOHG_ActiveControlDisabled,;
                _OOHG_ActiveControlRtl)

/*----------------------------------------------------------------------------
Progress Bar
---------------------------------------------------------------------------*/


#xcommand DEFINE PROGRESSBAR <name>;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRangeLow              := Nil          ;;
        _OOHG_ActiveControlRangeHigh             := Nil          ;;
        _OOHG_ActiveControlVertical              := .f.          ;;
        _OOHG_ActiveControlSmooth                := .f.          ;;
        _OOHG_ActiveControlForeColor             := Nil

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
        TProgressBar():Define(;
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
                _OOHG_ActiveControlValue,;
                _OOHG_ActiveControlBackColor,;
                _OOHG_ActiveControlForeColor,;
                _OOHG_ActiveControlRtl )


/*----------------------------------------------------------------------------
Radio Group
---------------------------------------------------------------------------*/

#xcommand DEFINE RADIOGROUP <name>;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlOptions               := Nil          ;;
        _OOHG_ActiveControlSpacing               := Nil          ;;
        _OOHG_ActiveControlTransparent           := .f.          ;;
        _OOHG_ActiveControlAutoSize              := .f.          ;;
        _OOHG_ActiveControlHorizontal            := .f.

#xcommand OPTIONS	<aOptions>;
	=>;
        _OOHG_ActiveControlOptions               := <aOptions>

#xcommand SPACING	<spacing>;
	=>;
        _OOHG_ActiveControlSpacing               := <spacing>

#xcommand HORIZONTAL    <horizontal>;
	=>;
        _OOHG_ActiveControlHorizontal            := <horizontal>

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
                _OOHG_ActiveControlAutoSize, ;
                _OOHG_ActiveControlHorizontal  ;
		)


/*----------------------------------------------------------------------------
Slider
---------------------------------------------------------------------------*/

#xcommand DEFINE SLIDER <name>;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRangeLow              := Nil          ;;
        _OOHG_ActiveControlRangeHigh             := Nil          ;;
        _OOHG_ActiveControlVertical              := .f.          ;;
        _OOHG_ActiveControlNoTicks               := .f.          ;;
        _OOHG_ActiveControlBoth          := .f.          ;;
        _OOHG_ActiveControlTop           := .f.          ;;
        _OOHG_ActiveControlLeft          := .f.

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
        TSlider():Define( ;
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
                _OOHG_ActiveControlBackColor , ;
                _OOHG_ActiveControlRtl , ;
                _OOHG_ActiveControlDisabled )

/*----------------------------------------------------------------------------
Text Box
---------------------------------------------------------------------------*/

#xcommand DEFINE TEXTBOX <name>;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlField         := Nil          ;;
        _OOHG_ActiveControlMaxLength     := Nil          ;;
        _OOHG_ActiveControlUpperCase     := .f.          ;;
        _OOHG_ActiveControlLowerCase     := .f.          ;;
        _OOHG_ActiveControlNumeric       := .f.          ;;
        _OOHG_ActiveControlPassword      := .f.          ;;
        _OOHG_ActiveControlRightAlign    := .f.          ;;
        _OOHG_ActiveControlReadonly      := .f.          ;;
        _OOHG_ActiveControlDateType      := .f.          ;;
        _OOHG_ActiveControlInputMask     := Nil          ;;
        _OOHG_ActiveControlPicture       := Nil          ;;
        _OOHG_ActiveControlFormat        := Nil          ;;
        _OOHG_ActiveControlNoBorder      := .f.          ;;
        _OOHG_ActiveControlAutoSkip      := .f.          ;;
        _OOHG_ActiveControlFocusedPos    := Nil          ;;
        _OOHG_ActiveControlValid         := Nil

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

#xcommand AUTOSKIP <autoskip> ;
	=>;
        _OOHG_ActiveControlAutoSkip              := <autoskip>

#xcommand NOBORDER        <noborder>;
	=>;
        _OOHG_ActiveControlNoBorder              := <noborder>

#xcommand FOCUSEDPOS      <focusedpos> ;
	=>;
        _OOHG_ActiveControlFocusedPos            := <focusedpos>

#xcommand END TEXTBOX;
	=>;
        DefineTextBox( ;
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
                        _OOHG_ActiveControlNoTabStop , ;
                        _OOHG_ActiveControlRtl , ;
                        _OOHG_ActiveControlAutoSkip , ;
                        _OOHG_ActiveControlNoBorder , ;
                        _OOHG_ActiveControlFocusedPos , ;
                        _OOHG_ActiveControlDisabled , ;
                        _OOHG_ActiveControlValid , ;
                        _OOHG_ActiveControlDateType , ;
                        _OOHG_ActiveControlNumeric , ;
                        _OOHG_ActiveControlInputMask , ;
                        _OOHG_ActiveControlFormat )

/*----------------------------------------------------------------------------
Month Calendar
---------------------------------------------------------------------------*/

#xcommand DEFINE MONTHCALENDAR <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlNoToday               := .f.          ;;
        _OOHG_ActiveControlNoTodayCircle         := .f.          ;;
        _OOHG_ActiveControlWeekNumbers           := .f.          ;;
        _OOHG_ActiveControlTitleFontColor        := nil          ;;
        _OOHG_ActiveControlTitleBackColor        := nil          ;;
        _OOHG_ActiveControlTrailingFontColor     := nil          ;;
        _OOHG_ActiveControlBackgroundColor       := nil

#xcommand NOTODAY	<notoday>;
	=>;
        _OOHG_ActiveControlNoToday               := <notoday>

#xcommand NOTODAYCIRCLE	<notodaycircle>;
	=>;
        _OOHG_ActiveControlNoTodayCircle := <notodaycircle>

#xcommand WEEKNUMBERS	<weeknumbers>;
	=>;
        _OOHG_ActiveControlWeekNumbers   := <weeknumbers>

#xcommand TITLEFONTCOLOR     <color>;
	=>;
        _OOHG_ActiveControlTitleFontColor        := <color>

#xcommand TITLEBACKCOLOR     <color>;
	=>;
        _OOHG_ActiveControlTitleBackColor        := <color>

#xcommand TRAILINGFONTCOLOR  <color>;
	=>;
        _OOHG_ActiveControlTrailingFontColor     := <color>

#xcommand BACKGROUNDCOLOR    <color>;
	=>;
        _OOHG_ActiveControlBackgroundColor       := <color>

#xcommand END MONTHCALENDAR;
	=>;
        TMonthCal():Define(;
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
                _OOHG_ActiveControlNoToday,;
                _OOHG_ActiveControlNoTodayCircle,;
                _OOHG_ActiveControlWeekNumbers,;
                _OOHG_ActiveControlOnChange,;
                _OOHG_ActiveControlHelpId,;
                _OOHG_ActiveControlInvisible,;
                _OOHG_ActiveControlNoTabStop,;
                _OOHG_ActiveControlFontBold,;
                _OOHG_ActiveControlFontItalic,;
                _OOHG_ActiveControlFontUnderLine,;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlTitleFontColor, ;
                _OOHG_ActiveControlTitleBackColor, ;
                _OOHG_ActiveControlTrailingFontColor, ;
                _OOHG_ActiveControlBackgroundColor )

/*----------------------------------------------------------------------------
Button
---------------------------------------------------------------------------*/

#xcommand DEFINE BUTTON <name> ;
        =>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlCaption           := Nil      ;;
        _OOHG_ActiveControlAction            := Nil      ;;
        _OOHG_ActiveControlFlat              := .f.      ;;
        _OOHG_ActiveControlPicture           := Nil      ;;
        _OOHG_ActiveControlTransparent       := .t.      ;;
        _OOHG_ActiveControlNoPrefix          := .F.

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

#xcommand ITEMCOUNT <itemcount> ;
        =>;
        _OOHG_ActiveControlItemCount := <itemcount>

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

#xcommand PICTURE <picture> ;
        =>;
        _OOHG_ActiveControlPicture := <picture>

#xcommand TRANSPARENT <transparent> ;
        =>;
        _OOHG_ActiveControlTransparent := <transparent>

#xcommand END BUTTON ;
        =>;
        TButton():Define( ;
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
                    _OOHG_ActiveControlInvisible ,;
                    _OOHG_ActiveControlFontBold ,;
                    _OOHG_ActiveControlFontItalic ,;
                    _OOHG_ActiveControlFontUnderLine, ;
                    _OOHG_ActiveControlFontStrikeOut, ;
                    _OOHG_ActiveControlRtl, ;
                    _OOHG_ActiveControlNoPrefix, ;
                    _OOHG_ActiveControlDisabled, ;
                    nil, ;
                    nil, ;
                    _OOHG_ActiveControlPicture, ;
                    .not. _OOHG_ActiveControlTransparent, ;
                    nil )

/*----------------------------------------------------------------------------
Image
---------------------------------------------------------------------------*/

#xcommand DEFINE IMAGE <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlPicture               := Nil          ;;
        _OOHG_ActiveControlAction                := Nil          ;;
        _OOHG_ActiveControlStretch               := .F.

#xcommand END IMAGE ;
	=>;
        TImage():Define(;
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
                .F.,;
                _OOHG_ActiveControlRtl ;
		)

#xcommand STRETCH		<stretch>;
	=>;
        _OOHG_ActiveControlStretch       := <stretch>


/*----------------------------------------------------------------------------
Check Box/Button
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKBOX <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlCaption               := Nil          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlAutoSize   := .f.          ;;
        _OOHG_ActiveControlField             := Nil


#xcommand DEFINE CHECKBUTTON <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlCaption               := Nil          ;;
        _OOHG_ActiveControlPicture           := Nil      ;;
        _OOHG_ActiveControlField             := Nil

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
        TButtonCheck():Define( ;
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
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlField, ;
                , .T., ;
                _OOHG_ActiveControlPicture )

/*----------------------------------------------------------------------------
Combo Box
---------------------------------------------------------------------------*/

#xcommand DEFINE COMBOBOX <name>;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlItems         := Nil          ;;
        _OOHG_ActiveControlSort          := .f.          ;;
        _OOHG_ActiveControlItemSource   := Nil           ;;
        _OOHG_ActiveControlValueSource  := Nil           ;;
        _OOHG_ActiveControlBreak         := .f.          ;;
        _OOHG_ActiveControlGripperText   := ""           ;;
        _OOHG_ActiveControlDisplayEdit   := .f.          ;;
        _OOHG_ActiveControlDisplayChange := Nil          ;;
        _OOHG_ActiveControlImage         := Nil

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
        TCombo():Define(;
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
                _OOHG_ActiveControlGripperText, ;
                _OOHG_ActiveControlImage, ;
                _OOHG_ActiveControlRtl ;
		)

/*----------------------------------------------------------------------------
Datepicker
---------------------------------------------------------------------------*/


#xcommand DEFINE DATEPICKER <name> ;
	=> ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlShowNone              := .f.          ;;
        _OOHG_ActiveControlUpDown                := .f.          ;;
        _OOHG_ActiveControlRightAlign    := .f.          ;;
        _OOHG_ActiveControlField             := Nil


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
        TDatePick():Define(;
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
                _OOHG_ActiveControlField , ;
                _OOHG_ActiveControlOnEnter , ;
                _OOHG_ActiveControlRtl )


#xcommand DEFINE TIMEPICKER <name> ;
	=> ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlShowNone              := .f.          ;;
        _OOHG_ActiveControlUpDown                := .f.          ;;
        _OOHG_ActiveControlRightAlign            := .f.          ;;
        _OOHG_ActiveControlField                 := Nil


#xcommand END TIMEPICKER ;
	=> ;
        TTimePick():Define(;
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
                _OOHG_ActiveControlField , ;
                _OOHG_ActiveControlOnEnter , ;
                _OOHG_ActiveControlRtl )


/*----------------------------------------------------------------------------
Edit Box
---------------------------------------------------------------------------*/

#xcommand DEFINE EDITBOX <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlReadonly      := .f.          ;;
        _OOHG_ActiveControlMaxLength     := Nil          ;;
        _OOHG_ActiveControlBreak         := .f.          ;;
        _OOHG_ActiveControlField         := Nil          ;;
        _OOHG_ActiveControlNoVScroll     := .f.          ;;
        _OOHG_ActiveControlNoHScroll     := .f.          ;;
        _OOHG_ActiveControlNoBorder      := .f.          ;;
        _OOHG_ActiveControlFocusedPos    := Nil

#xcommand READONLYFIELDS <readonly> ;
	=>;
        _OOHG_ActiveControlReadOnly              := <readonly>

#xcommand MAXLENGTH <maxlength> ;
	=>;
        _OOHG_ActiveControlMaxLength             := <maxlength>

#xcommand SETBREAK <break> ;
	=>;
        _OOHG_ActiveControlBreak         := <break>

#xcommand END EDITBOX ;
	=>;
                TEdit():Define(;
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
                        _OOHG_ActiveControlNoHScroll, ;
                        _OOHG_ActiveControlRtl, ;
                        _OOHG_ActiveControlNoBorder, ;
                        _OOHG_ActiveControlFocusedPos )


/*----------------------------------------------------------------------------
Rich Edit Box
---------------------------------------------------------------------------*/

#xcommand DEFINE RICHEDITBOX <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlReadonly              := .f.          ;;
        _OOHG_ActiveControlMaxLength             := Nil          ;;
        _OOHG_ActiveControlBreak                 := .f.          ;;
        _OOHG_ActiveControlField                 := Nil

#xcommand END RICHEDITBOX ;
	=>;
                TEditRich():Define(;
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
                        _OOHG_ActiveControlBackColor,;
                        _OOHG_ActiveControlRtl )

/*----------------------------------------------------------------------------
Label
---------------------------------------------------------------------------*/

#xcommand DEFINE LABEL <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlBorder        := .f.          ;;
        _OOHG_ActiveControlClientEdge    := .f.          ;;
        _OOHG_ActiveControlHScroll       := .f.          ;;
        _OOHG_ActiveControlVScroll       := .f.          ;;
        _OOHG_ActiveControlTransparent   := .f.          ;;
        _OOHG_ActiveControlAction        := Nil          ;;
        _OOHG_ActiveControlRightAlign    := .F.          ;;
        _OOHG_ActiveControlAutoSize      := .f.          ;;
        _OOHG_ActiveControlCenterAlign   := .F.          ;;
        _OOHG_ActiveControlNoWordWrap    := .F.          ;;
        _OOHG_ActiveControlNoPrefix      := .F.          ;;
        _OOHG_ActiveControlInputMask     := Nil

#xcommand CENTERALIGN	<centeralign> ;
	=> ;
        _OOHG_ActiveControlCenterAlign           := <centeralign>

#xcommand FORECOLOR	<color>;
	=>;
        _OOHG_ActiveControlForeColor             := <color>

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

#xcommand NOWORDWRAP   <nowordwrap>;
	=>;
        _OOHG_ActiveControlNoWordWrap   := <nowordwrap>

#xcommand NOPREFIX   <noprefix>;
	=>;
        _OOHG_ActiveControlNoPrefix     := <noprefix>

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
                _OOHG_ActiveControlCenterAlign , ;
                _OOHG_ActiveControlRtl , ;
                _OOHG_ActiveControlNoWordWrap , ;
                _OOHG_ActiveControlNoPrefix , ;
                _OOHG_ActiveControlInputMask )


#xcommand DEFINE IPADDRESS <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> )

#xcommand END IPADDRESS ;
=>;
   TIPAddress():Define( ;
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
        _OOHG_ActiveControlFontStrikeOut , ;
        _OOHG_ActiveControlRtl )


/*----------------------------------------------------------------------------
Grid
---------------------------------------------------------------------------*/

#xcommand DEFINE GRID <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlHeaders               := Nil          ;;
        _OOHG_ActiveControlWidths                := Nil          ;;
        _OOHG_ActiveControlItems         := Nil          ;;
        _OOHG_ActiveControlOnHeadClick   := Nil          ;;
        _OOHG_ActiveControlNoLines               := .f.          ;;
        _OOHG_ActiveControlImage         := Nil          ;;
        _OOHG_ActiveControlJustify               := Nil          ;;
        _OOHG_ActiveControlMultiSelect   := .f.          ;;
        _OOHG_ActiveControlEdit              := .f.          ;;
        _OOHG_ActiveControlBreak             := .f.              ;;
        _OOHG_ActiveControlOnQueryData   := Nil          ;;
        _OOHG_ActiveControlItemCount             := Nil          ;;
        _OOHG_ActiveControlReadOnly              := Nil          ;;
        _OOHG_ActiveControlVirtual               := .f.          ;;
        _OOHG_ActiveControlInputMask             := nil          ;;
        _OOHG_ActiveControlOnAppend              := nil          ;;
        _OOHG_ActiveControlInPlaceEdit           := .f.          ;;
        _OOHG_ActiveControlDynamicBackColor      := Nil          ;;
        _OOHG_ActiveControlDynamicForeColor      := Nil          ;;
        _OOHG_ActiveControlEditControls          := Nil          ;;
        _OOHG_ActiveControlReadOnly              := Nil          ;;
        _OOHG_ActiveControlValid                 := Nil          ;;
        _OOHG_ActiveControlValidMessages         := Nil          ;;
        _OOHG_ActiveControlEditCell              := Nil          ;;
        _OOHG_ActiveControlWhen                  := nil          ;;
        _OOHG_ActiveControlShowHeaders           := nil

#xcommand ONAPPEND    <onappend>;
	=>;
        _OOHG_ActiveControlOnAppend    := <onappend>

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
                _OOHG_ActiveControlDynamicBackColor, ;
                _OOHG_ActiveControlDynamicForeColor, ;
                _OOHG_ActiveControlInputMask, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlInPlaceEdit , ;
                _OOHG_ActiveControlEditControls, ;
                _OOHG_ActiveControlReadOnly , ;
                _OOHG_ActiveControlValid , ;
                _OOHG_ActiveControlValidMessages, ;
                _OOHG_ActiveControlEditCell, ;
                _OOHG_ActiveControlWhen, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlShowHeaders,  ;
                _OOHG_ActiveControlOnEnter )

/*----------------------------------------------------------------------------
BROWSE
---------------------------------------------------------------------------*/

#xcommand DEFINE BROWSE <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlHeaders               := Nil          ;;
        _OOHG_ActiveControlWidths                := Nil          ;;
        _OOHG_ActiveControlOnHeadClick   := Nil          ;;
        _OOHG_ActiveControlNoLines               := .f.          ;;
        _OOHG_ActiveControlImage         := Nil          ;;
        _OOHG_ActiveControlJustify               := Nil          ;;
        _OOHG_ActiveControlEdit              := .f.          ;;
        _OOHG_ActiveControlBreak             := .f.              ;;
        _OOHG_ActiveControlWorkArea              := Nil          ;;
        _OOHG_ActiveControlFields                := Nil          ;;
        _OOHG_ActiveControlDelete                := .f.          ;;
        _OOHG_ActiveControlAppendable        := .f.              ;;
        _OOHG_ActiveControlValid         := Nil          ;;
        _OOHG_ActiveControlReadOnly              := Nil          ;;
        _OOHG_ActiveControlLock          := .f.          ;;
        _OOHG_ActiveControlValidMessages := Nil          ;;
        _OOHG_ActiveControlNoVScroll             := .f.          ;;
        _OOHG_ActiveControlInputMask             := nil          ;;
        _OOHG_ActiveControlInPlaceEdit           := .f.          ;;
        _OOHG_ActiveControlDynamicBackColor      := Nil          ;;
        _OOHG_ActiveControlDynamicForeColor      := Nil          ;;
        _OOHG_ActiveControlWhen                  := nil          ;;
        _OOHG_ActiveControlOnAppend              := nil          ;;
        _OOHG_ActiveControlEditCell              := Nil          ;;
        _OOHG_ActiveControlEditControls          := Nil          ;;
        _OOHG_ActiveControlReplaceFields         := Nil          ;;
        _OOHG_ActiveControlShowHeaders           := nil

#xcommand END BROWSE ;
	=>;
TOBrowse():Define( _OOHG_ActiveControlName ,        ;
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
                _OOHG_ActiveControlDynamicBackColor, ;
                _OOHG_ActiveControlWhen, ;
                _OOHG_ActiveControlDynamicForeColor, ;
                _OOHG_ActiveControlInputMask, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlOnAppend, ;
                _OOHG_ActiveControlEditCell, ;
                _OOHG_ActiveControlEditControls, ;
                _OOHG_ActiveControlReplaceFields, ;
                ,, ;
                _OOHG_ActiveControlShowHeaders,  ;
                _OOHG_ActiveControlOnEnter )

/*----------------------------------------------------------------------------
Hyperlink
---------------------------------------------------------------------------*/

#xcommand DEFINE HYPERLINK <name> ;
	=>;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlAddress           := Nil          ;;
        _OOHG_ActiveControlAutoSize          := .f.          ;;
        _OOHG_ActiveControlBorder            := .f.          ;;
        _OOHG_ActiveControlClientEdge        := .f.          ;;
        _OOHG_ActiveControlHScroll           := .f.          ;;
        _OOHG_ActiveControlVScroll           := .f.          ;;
        _OOHG_ActiveControlTransparent       := .f.          ;;
        _OOHG_ActiveControlHandCursor        := .F.

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
        _OOHG_ActiveControlHandCursor,;
        _OOHG_ActiveControlRtl  )


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
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRangeLow      := Nil          ;;
        _OOHG_ActiveControlRangeHigh     := Nil          ;;
        _OOHG_ActiveControlWrap          := .F.          ;;
        _OOHG_ActiveControlReadOnly      := .F.          ;;
        _OOHG_ActiveControlIncrement     := Nil          ;;
        _OOHG_ActiveControlNoBorder      := .f.

#xcommand END SPINNER;
	=>;
        TSpinner():Define(;
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
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlNoBorder )
