/*
 * $Id: i_altsyntax.ch,v 1.91 2013-08-07 00:05:22 fyurisich Exp $
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

#xtranslate _OOHG_ActiveControlUpdateColors           => _OOHG_ActiveControlInfo \[ 109 \]
#xtranslate _OOHG_ActiveControlEditLikeExcel          => _OOHG_ActiveControlInfo \[ 110 \]
#xtranslate _OOHG_ActiveControlUseButtons             => _OOHG_ActiveControlInfo \[ 111 \]
#xtranslate _OOHG_ActiveControlBeforeAutoFit          => _OOHG_ActiveControlInfo \[ 112 \]
#xtranslate _OOHG_ActiveControlAfterColSize           => _OOHG_ActiveControlInfo \[ 113 \]
#xtranslate _OOHG_ActiveControlBeforeColSize          => _OOHG_ActiveControlInfo \[ 114 \]
#xtranslate _OOHG_ActiveControlAfterColMove           => _OOHG_ActiveControlInfo \[ 115 \]
#xtranslate _OOHG_ActiveControlBeforeColMove          => _OOHG_ActiveControlInfo \[ 116 \]
#xtranslate _OOHG_ActiveControlFixedBlocks            => _OOHG_ActiveControlInfo \[ 117 \]
#xtranslate _OOHG_ActiveControlOnTextFilled           => _OOHG_ActiveControlInfo \[ 118 \]
#xtranslate _OOHG_ActiveControlDelayedLoad            => _OOHG_ActiveControlInfo \[ 119 \]
#xtranslate _OOHG_ActiveControlIncrementalSearch      => _OOHG_ActiveControlInfo \[ 120 \]
#xtranslate _OOHG_ActiveControlIntegralHeight         => _OOHG_ActiveControlInfo \[ 121 \]
#xtranslate _OOHG_ActiveControlAutoFit                => _OOHG_ActiveControlInfo \[ 122 \]
#xtranslate _OOHG_ActiveControlNo3DColors             => _OOHG_ActiveControlInfo \[ 123 \]
#xtranslate _OOHG_ActiveControlDefaultYear            => _OOHG_ActiveControlInfo \[ 124 \]
#xtranslate _OOHG_ActiveControlNoHideSel              => _OOHG_ActiveControlInfo \[ 125 \]
#xtranslate _OOHG_ActiveControlOnSelChange            => _OOHG_ActiveControlInfo \[ 126 \]
#xtranslate _OOHG_ActiveControlOnListDisplay          => _OOHG_ActiveControlInfo \[ 127 \]
#xtranslate _OOHG_ActiveControlOnListClose            => _OOHG_ActiveControlInfo \[ 128 \]
#xtranslate _OOHG_ActiveControlSubClass               => _OOHG_ActiveControlInfo \[ 129 \]
#xtranslate _OOHG_ActiveControlAssignObject           => _OOHG_ActiveControlInfo \[ 130 \]
#xtranslate _OOHG_ActiveControlFixedWidths            => _OOHG_ActiveControlInfo \[ 131 \]
#xtranslate _OOHG_ActiveControlAbortEdit              => _OOHG_ActiveControlInfo \[ 132 \]
#xtranslate _OOHG_ActiveControlUpdateAll              => _OOHG_ActiveControlInfo \[ 133 \]
#xtranslate _OOHG_ActiveControlNoDeleteMsg            => _OOHG_ActiveControlInfo \[ 134 \]
#xtranslate _OOHG_ActiveControlFixedCols              => _OOHG_ActiveControlInfo \[ 135 \]
#xtranslate _OOHG_ActiveControlSynchronized           => _OOHG_ActiveControlInfo \[ 136 \]
#xtranslate _OOHG_ActiveControlPaintLeftMargin        => _OOHG_ActiveControlInfo \[ 137 \]
#xtranslate _OOHG_ActiveControlNoFocusRect            => _OOHG_ActiveControlInfo \[ 138 \]
#xtranslate _OOHG_ActiveControlFocusRect              => _OOHG_ActiveControlInfo \[ 139 \]
#xtranslate _OOHG_ActiveControlDblBffer               => _OOHG_ActiveControlInfo \[ 140 \]
#xtranslate _OOHG_ActiveControlOnCheckChange          => _OOHG_ActiveControlInfo \[ 141 \]
#xtranslate _OOHG_ActiveControlForceRefresh           => _OOHG_ActiveControlInfo \[ 142 \]
#xtranslate _OOHG_ActiveControlNoRefresh              => _OOHG_ActiveControlInfo \[ 143 \]
#xtranslate _OOHG_ActiveControlCheckBoxes             => _OOHG_ActiveControlInfo \[ 144 \]
#xtranslate _OOHG_ActiveControlKeys                   => _OOHG_ActiveControlInfo \[ 145 \]
#xtranslate _OOHG_ActiveControlSelectedColors         => _OOHG_ActiveControlInfo \[ 146 \]
#xtranslate _OOHG_ActiveControlByCell                 => _OOHG_ActiveControlInfo \[ 147 \]
#xtranslate _OOHG_ActiveControlItemImageNumber        => _OOHG_ActiveControlInfo \[ 148 \]
#xtranslate _OOHG_ActiveControlImageSource            => _OOHG_ActiveControlInfo \[ 149 \]
#xtranslate _OOHG_ActiveControlOnMouseMove            => _OOHG_ActiveControlInfo \[ 150 \]
#xtranslate _OOHG_ActiveControlImageMargin            => _OOHG_ActiveControlInfo \[ 151 \]
#xtranslate _OOHG_ActiveControlThemed                 => _OOHG_ActiveControlInfo \[ 152 \]
#xtranslate _OOHG_ActiveControlListWidth              => _OOHG_ActiveControlInfo \[ 153 \]
#xtranslate _OOHG_ActiveControl3State                 => _OOHG_ActiveControlInfo \[ 154 \]
#xtranslate _OOHG_ActiveControlMultiLine              => _OOHG_ActiveControlInfo \[ 155 \]
#xtranslate _OOHG_ActiveControlFullMove               => _OOHG_ActiveControlInfo \[ 156 \]
#xtranslate _OOHG_ActiveControlRowCount               => _OOHG_ActiveControlInfo \[ 157 \]
#xtranslate _OOHG_ActiveControlColCount               => _OOHG_ActiveControlInfo \[ 158 \]
#xtranslate _OOHG_ActiveControlOnLineUp               => _OOHG_ActiveControlInfo \[ 159 \]
#xtranslate _OOHG_ActiveControlOnLineDown             => _OOHG_ActiveControlInfo \[ 160 \]
#xtranslate _OOHG_ActiveControlOnPageUp               => _OOHG_ActiveControlInfo \[ 161 \]
#xtranslate _OOHG_ActiveControlOnPageDown             => _OOHG_ActiveControlInfo \[ 162 \]
#xtranslate _OOHG_ActiveControlOnTop                  => _OOHG_ActiveControlInfo \[ 163 \]
#xtranslate _OOHG_ActiveControlOnBottom               => _OOHG_ActiveControlInfo \[ 164 \]
#xtranslate _OOHG_ActiveControlOnThumb                => _OOHG_ActiveControlInfo \[ 165 \]
#xtranslate _OOHG_ActiveControlOnTrack                => _OOHG_ActiveControlInfo \[ 166 \]
#xtranslate _OOHG_ActiveControlOnEndTrack             => _OOHG_ActiveControlInfo \[ 167 \]
#xtranslate _OOHG_ActiveControlAttached               => _OOHG_ActiveControlInfo \[ 168 \]
#xtranslate _OOHG_ActiveControlLineSkip               => _OOHG_ActiveControlInfo \[ 169 \]
#xtranslate _OOHG_ActiveControlPageSkip               => _OOHG_ActiveControlInfo \[ 170 \]
#xtranslate _OOHG_ActiveControlAutoMove               => _OOHG_ActiveControlInfo \[ 171 \]
#xtranslate _OOHG_ActiveControlForceAlt               => _OOHG_ActiveControlInfo \[ 172 \]
#xtranslate _OOHG_ActiveControlFirstItem              => _OOHG_ActiveControlInfo \[ 173 \]
#xtranslate _OOHG_ActiveControlButtonWidth            => _OOHG_ActiveControlInfo \[ 174 \]
#xtranslate _OOHG_ActiveControlAction2                => _OOHG_ActiveControlInfo \[ 175 \]
#xtranslate _OOHG_ActiveControlSpeed                  => _OOHG_ActiveControlInfo \[ 176 \]
#xtranslate _OOHG_ActiveControlTextHeight             => _OOHG_ActiveControlInfo \[ 177 \]
#xtranslate _OOHG_ActiveControlImagesize              => _OOHG_ActiveControlInfo \[ 178 \]
#xtranslate _OOHG_ActiveControlWhiteBackground        => _OOHG_ActiveControlInfo \[ 179 \]
#xtranslate _OOHG_ActiveControlNoResize               => _OOHG_ActiveControlInfo \[ 180 \]
#xtranslate _OOHG_ActiveControlBuffer                 => _OOHG_ActiveControlInfo \[ 181 \]
#xtranslate _OOHG_ActiveControlHBitmap                => _OOHG_ActiveControlInfo \[ 182 \]
#xtranslate _OOHG_ActiveControlScale                  => _OOHG_ActiveControlInfo \[ 183 \]
#xtranslate _OOHG_ActiveControlCancel                 => _OOHG_ActiveControlInfo \[ 184 \]
#xtranslate _OOHG_ActiveControlAlignment              => _OOHG_ActiveControlInfo \[ 185 \]
#xtranslate _OOHG_ActiveControlHeaderImages           => _OOHG_ActiveControlInfo \[ 186 \]
#xtranslate _OOHG_ActiveControlImagesAlign            => _OOHG_ActiveControlInfo \[ 187 \]
#xtranslate _OOHG_ActiveControlColumnInfo             => _OOHG_ActiveControlInfo \[ 188 \]
#xtranslate _OOHG_ActiveControlDescending             => _OOHG_ActiveControlInfo \[ 189 \]
#xtranslate _OOHG_ActiveControlShowAll                => _OOHG_ActiveControlInfo \[ 190 \]
#xtranslate _OOHG_ActiveControlShowMode               => _OOHG_ActiveControlInfo \[ 191 \]
#xtranslate _OOHG_ActiveControlShowName               => _OOHG_ActiveControlInfo \[ 192 \]
#xtranslate _OOHG_ActiveControlShowPosition           => _OOHG_ActiveControlInfo \[ 193 \]
#xtranslate _OOHG_ActiveControlFormat                 => _OOHG_ActiveControlInfo \[ 194 \]
#xtranslate _OOHG_ActiveControlField                  => _OOHG_ActiveControlInfo \[ 195 \]
#xtranslate _OOHG_ActiveControlOnAppend               => _OOHG_ActiveControlInfo \[ 196 \]
#xtranslate _OOHG_ActiveControlDeleteWhen             => _OOHG_ActiveControlInfo \[ 197 \]
#xtranslate _OOHG_ActiveControlDeleteMsg              => _OOHG_ActiveControlInfo \[ 198 \]
#xtranslate _OOHG_ActiveControlOnDelete               => _OOHG_ActiveControlInfo \[ 199 \]
#xtranslate _OOHG_ActiveControlRecCount               => _OOHG_ActiveControlInfo \[ 200 \]
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
        _OOHG_ActiveControlFontBold      := .F.          ;;
        _OOHG_ActiveControlFontItalic    := .F.          ;;
        _OOHG_ActiveControlFontStrikeOut := .F.          ;;
        _OOHG_ActiveControlFontUnderLine := .F.          ;;
        _OOHG_ActiveControlFontColor     := Nil          ;;
        _OOHG_ActiveControlBackColor     := Nil          ;;
        _OOHG_ActiveControlRtl           := .F.          ;;
        _OOHG_ActiveControlValue         := Nil          ;;
        _OOHG_ActiveControlTooltip       := Nil          ;;
        _OOHG_ActiveControlNoTabStop     := .F.          ;;
        _OOHG_ActiveControlInvisible     := .F.          ;;
        _OOHG_ActiveControlHelpId        := Nil          ;;
        _OOHG_ActiveControlDisabled      := .F.          ;;
        _OOHG_ActiveControlOnDblClick    := Nil          ;;
        _OOHG_ActiveControlOnRDblClick   := Nil          ;;
        _OOHG_ActiveControlOnMDblClick   := Nil          ;;
        _OOHG_ActiveControlOnLostFocus   := Nil          ;;
        _OOHG_ActiveControlOnGotFocus    := Nil          ;;
        _OOHG_ActiveControlOnChange      := Nil          ;;
        _OOHG_ActiveControlOnEnter       := Nil          ;;
        _OOHG_ActiveControlOnMouseMove   := Nil          ;;
        _OOHG_ActiveControlAssignObject  := Nil          ;;
        _OOHG_ActiveControlSubClass      := Nil

#xcommand OBJECT <var> ;
        => ;
        _OOHG_ActiveControlAssignObject := { |_o_| <var> := _o_ }

#xcommand SUBCLASS <class> ;
        => ;
        _OOHG_ActiveControlSubClass := <class>()

#xcommand PARENT <of> ;
        => ;
        _OOHG_ActiveControlOf := <(of)>

#xcommand ROW <row> ;
        => ;
        _OOHG_ActiveControlRow := <row>

#xcommand COL <col> ;
        => ;
        _OOHG_ActiveControlCol := <col>

#xcommand WIDTH <width> ;
        => ;
        _OOHG_ActiveControlWidth := <width>

#xcommand HEIGHT <height> ;
        => ;
        _OOHG_ActiveControlHeight := <height>

#xcommand FONTNAME <font> ;
        => ;
        _OOHG_ActiveControlFont := <font>

#xcommand FONTSIZE <size> ;
        => ;
        _OOHG_ActiveControlSize := <size>

#xcommand FONTBOLD <bold> ;
   => ;
        _OOHG_ActiveControlFontBold := <bold>

#xcommand FONTITALIC <i> ;
   => ;
        _OOHG_ActiveControlFontItalic := <i>

#xcommand FONTSTRIKEOUT <s> ;
   => ;
        _OOHG_ActiveControlFontStrikeOut := <s>

#xcommand FONTUNDERLINE <u> ;
   => ;
        _OOHG_ActiveControlFontUnderline := <u>

#xcommand FONTCOLOR   <color> ;
   => ;
        _OOHG_ActiveControlFontColor := <color>

#xcommand BACKCOLOR <color> ;
   => ;
        _OOHG_ActiveControlBackColor := <color>

#xcommand RTL <l> ;
   => ;
        _OOHG_ActiveControlRtl := <l>

#xcommand VALUE <value> ;
   => ;
        _OOHG_ActiveControlValue := <value>

#xcommand TOOLTIP <tooltip> ;
        => ;
        _OOHG_ActiveControlTooltip := <tooltip>

#xcommand TABSTOP <notabstop> ;
        => ;
        _OOHG_ActiveControlNoTabStop := .NOT. <notabstop>

#xcommand VISIBLE <visible> ;
        => ;
        _OOHG_ActiveControlInvisible := .NOT. <visible>

#xcommand HELPID <helpid> ;
        => ;
        _OOHG_ActiveControlHelpId := <helpid>

#xcommand DISABLED <disabled> ;
        => ;
        _OOHG_ActiveControlDisabled := <disabled>

#xcommand ITEMSOURCE <itemsource> ;
        => ;
        _OOHG_ActiveControlItemSource := <(itemsource)>

#xcommand VALUESOURCE <valuesource> ;
        => ;
        _OOHG_ActiveControlValueSource := <(valuesource)>

#xcommand COLUMNCONTROLS <editcontrols> ;
        => ;
        _OOHG_ActiveControlEditControls := <editcontrols>

#xcommand EDITCELL <editcell> ;
        => ;
        _OOHG_ActiveControlEditCell := <editcell>

#xcommand ABORTEDIT <abortedit> ;
        => ;
        _OOHG_ActiveControlAbortEdit := <abortedit>

#xcommand WORKAREA <workarea> ;
        => ;
        _OOHG_ActiveControlWorkArea := <(workarea)>

#xcommand FIELD <field> ;
        => ;
        _OOHG_ActiveControlField := <(field)>

#xcommand FIELDS <fields> ;
        => ;
        _OOHG_ActiveControlFields := <fields>

#xcommand ALLOWDELETE <deletable> ;
        => ;
        _OOHG_ActiveControlDelete := <deletable>

#xcommand NOVSCROLLBAR <nvs> ;
        => ;
        _OOHG_ActiveControlNoVScroll := <nvs>

#xcommand VSCROLLBAR <vs> ;
        => ;
        _OOHG_ActiveControlNoVScroll := .NOT. <vs>

#xcommand NOHSCROLLBAR <nvs> ;
        => ;
        _OOHG_ActiveControlNoHScroll := <nvs>

#xcommand HSCROLLBAR <vs> ;
        => ;
        _OOHG_ActiveControlNoHScroll := .NOT. <vs>

#xcommand INPLACEEDIT <inplaceedit> ;
        => ;
        _OOHG_ActiveControlInPlaceEdit := <inplaceedit>

#xcommand DATE <datetype> ;
        => ;
        _OOHG_ActiveControlDateType := <datetype>

#xcommand VALID <valid> ;
        => ;
        _OOHG_ActiveControlValid := <valid>

#xcommand VALIDMESSAGES <validmessages> ;
        => ;
        _OOHG_ActiveControlValidMessages := <validmessages>

#xcommand READONLY <readonly> ;
        => ;
        _OOHG_ActiveControlReadOnly := <readonly>

#xcommand VIRTUAL <virtual> ;
        => ;
        _OOHG_ActiveControlVirtual := <virtual>

#xcommand LOCK <lock> ;
        => ;
        _OOHG_ActiveControlLock := <lock>

#xcommand ALLOWAPPEND <appendable> ;
        => ;
        _OOHG_ActiveControlAppendable := <appendable>

#xcommand AUTOSIZE <a> ;
        => ;
        _OOHG_ActiveControlAutoSize := <a>

#xcommand SHOWHEADERS <a> ;
        => ;
        _OOHG_ActiveControlShowHeaders := <a>

/*----------------------------------------------------------------------------
FRAME
---------------------------------------------------------------------------*/

#xcommand DEFINE FRAME <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlCaption     := Nil    ;;
        _OOHG_ActiveControlTransparent := .F.    ;;
        _OOHG_ActiveControlOpaque      := .F.

#xcommand OPAQUE <opaque> ;
        => ;
        _OOHG_ActiveControlOpaque := <opaque>

#xcommand END FRAME ;
        => ;
        _OOHG_SelectSubClass( TFrame(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlCaption, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlOpaque, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlDisabled )


#xcommand HEADERS <headers> ;
        => ;
        _OOHG_ActiveControlHeaders := <headers>

#xcommand HEADER <headers> ;
        => ;
        _OOHG_ActiveControlHeaders := <headers>

#xcommand WIDTHS <widths> ;
        => ;
        _OOHG_ActiveControlWidths := <widths>

#xcommand ONDBLCLICK <dblclick> ;
        => ;
        _OOHG_ActiveControlOnDblClick := <{dblclick}>

#xcommand ON DBLCLICK <dblclick> ;
        => ;
        _OOHG_ActiveControlOnDblClick := <{dblclick}>

#xcommand ONHEADCLICK <aHeadClick> ;
        => ;
        _OOHG_ActiveControlOnHeadClick := <aHeadClick>

#xcommand ON HEADCLICK <aHeadClick> ;
        => ;
        _OOHG_ActiveControlOnHeadClick := <aHeadClick>

#xcommand DYNAMICBACKCOLOR <aDynamicBackColor> ;
        => ;
        _OOHG_ActiveControlDynamicBackColor := <aDynamicBackColor>

#xcommand DYNAMICFORECOLOR <aDynamicForeColor> ;
        => ;
        _OOHG_ActiveControlDynamicForeColor := <aDynamicForeColor>

#xcommand WHEN <aWhenFields> ;
        => ;
        _OOHG_ActiveControlWhen := <aWhenFields>

#xcommand REPLACEFIELD <aReplaceFields> ;
        => ;
        _OOHG_ActiveControlReplaceFields := <aReplaceFields>

#xcommand NOLINES <nolines> ;
        => ;
        _OOHG_ActiveControlNoLines := <nolines>

#xcommand IMAGE <aImage> ;
        => ;
        _OOHG_ActiveControlImage := <aImage>

#xcommand JUSTIFY <aJustify> ;
        => ;
        _OOHG_ActiveControlJustify := <aJustify>

#xcommand MULTISELECT <multiselect> ;
        => ;
        _OOHG_ActiveControlMultiSelect := <multiselect>

#xcommand ALLOWEDIT <edit> ;
        => ;
        _OOHG_ActiveControlEdit := <edit>

/*----------------------------------------------------------------------------
LIST BOX
---------------------------------------------------------------------------*/

#xcommand DEFINE LISTBOX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlItems       := Nil    ;;
        _OOHG_ActiveControlMultiSelect := .F.    ;;
        _OOHG_ActiveControlBreak       := .F.    ;;
        _OOHG_ActiveControlSort        := .F.    ;;
        _OOHG_ActiveControlImage       := Nil    ;;
        _OOHG_ActiveControlTextHeight  := Nil    ;;
        _OOHG_ActiveControlStretch     := .F.    ;;
        _OOHG_ActiveControlNoVScroll   := .F.

#xcommand SORT <sort> ;
        => ;
        _OOHG_ActiveControlSort := <sort>

#xcommand FIT <fit> ;
        => ;
        _OOHG_ActiveControlStretch := <fit>

#xcommand TEXTHEIGHT <textheight> ;
        => ;
        _OOHG_ActiveControlTextHeight := <textheight>

#xcommand END LISTBOX ;
        => ;
        _OOHG_SelectSubClass( iif( _OOHG_ActiveControlMultiSelect, TListMulti(), TList() ), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlItems, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnDblClick, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlBreak, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlSort, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlImage, ;
                _OOHG_ActiveControlTextHeight, ;
                _OOHG_ActiveControlStretch, ;
                _OOHG_ActiveControlNoVScroll )

/*----------------------------------------------------------------------------
CHECKLIST
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKLIST <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlItems          := Nil ;;
        _OOHG_ActiveControlImage          := Nil ;;
        _OOHG_ActiveControlJustify        := Nil ;;
        _OOHG_ActiveControlBreak          := .F. ;;
        _OOHG_ActiveControlSort           := .F. ;;
        _OOHG_ActiveControlDescending     := .F. ;;
        _OOHG_ActiveControlSelectedColors := Nil ;;
        _OOHG_ActiveControlDblBffer       := .T. ;;
        _OOHG_ActiveControlAction         := Nil

#xcommand DOUBLEBUFFER <dblbffr> ;
        => ;
        _OOHG_ActiveControlDblBffer := <dblbffr>

#xcommand END CHECKLIST ;
        => ;
        _OOHG_SelectSubClass( TCheckList(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlItems, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlImage, ;
                _OOHG_ActiveControlJustify, ;
                _OOHG_ActiveControlBreak, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlSort, ;
                _OOHG_ActiveControlDescending, ;
                _OOHG_ActiveControlSelectedColors, ;
                _OOHG_ActiveControlDblBffer, ;
                _OOHG_ActiveControlAction )

/*----------------------------------------------------------------------------
ANIMATEBOX COMMANDS
---------------------------------------------------------------------------*/

#xcommand DEFINE ANIMATEBOX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlAutoPlay    := .F.    ;;
        _OOHG_ActiveControlCenter      := .F.    ;;
        _OOHG_ActiveControlTransparent := .F.    ;;
        _OOHG_ActiveControlFile        := Nil

#xcommand AUTOPLAY <autoplay> ;
        => ;
        _OOHG_ActiveControlAutoPlay := <autoplay>

#xcommand CENTER <center> ;
        => ;
        _OOHG_ActiveControlCenter := <center>

#xcommand FILE <file> ;
        => ;
        _OOHG_ActiveControlFile := <file>

#xcommand END ANIMATEBOX;
        => ;
        _OOHG_SelectSubClass( TAnimateBox(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlAutoPlay, ;
                _OOHG_ActiveControlCenter, ;
                _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlFile, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlRtl )

#xcommand DEFINE PLAYER <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> )   ;;
        _OOHG_ActiveControlFile             := Nil ;;
        _OOHG_ActiveControlNoAutoSizeWindow := .F. ;;
        _OOHG_ActiveControlNoAutoSizeMovie  := .F. ;;
        _OOHG_ActiveControlNoErrorDlg       := .F. ;;
        _OOHG_ActiveControlNoMenu           := .F. ;;
        _OOHG_ActiveControlNoOpen           := .F. ;;
        _OOHG_ActiveControlNoPlayBar        := .F. ;;
        _OOHG_ActiveControlShowAll          := .F. ;;
        _OOHG_ActiveControlShowMode         := .F. ;;
        _OOHG_ActiveControlShowName         := .F. ;;
        _OOHG_ActiveControlShowPosition     := .F.

#xcommand NOAUTOSIZEWINDOW <noautosizewindow> ;
        => ;
        _OOHG_ActiveControlNoAutoSizeWindow := <noautosizewindow>

#xcommand NOAUTOSIZEMOVIE <noautosizemovie> ;
        => ;
        _OOHG_ActiveControlNoAutoSizeMovie := <noautosizemovie>

#xcommand NOERRORDLG <noerrordlg> ;
        => ;
        _OOHG_ActiveControlNoErrorDlg := <noerrordlg>

#xcommand NOMENU <nomenu> ;
        => ;
        _OOHG_ActiveControlNoMenu := <nomenu>

#xcommand NOOPEN <noopen> ;
        => ;
        _OOHG_ActiveControlNoOpen := <noopen>

#xcommand NOPLAYBAR <noplaybar> ;
        => ;
        _OOHG_ActiveControlNoPlayBar := <noplaybar>

#xcommand SHOWALL <showall> ;
        => ;
        _OOHG_ActiveControlShowAll := <showall>

#xcommand SHOWMODE <showmode> ;
        => ;
        _OOHG_ActiveControlShowMode := <showmode>

#xcommand SHOWNAME <showname> ;
        => ;
        _OOHG_ActiveControlShowName := <showname>

#xcommand SHOWPOSITION <showposition> ;
        => ;
        _OOHG_ActiveControlShowPosition := <showposition>

#xcommand END PLAYER;
        => ;
        _OOHG_SelectSubClass( TPlayer(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlFile, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlNoAutoSizeWindow, ;
                _OOHG_ActiveControlNoAutoSizeMovie, ;
                _OOHG_ActiveControlNoErrorDlg, ;
                _OOHG_ActiveControlNoMenu, ;
                _OOHG_ActiveControlNoOpen, ;
                _OOHG_ActiveControlNoPlayBar, ;
                _OOHG_ActiveControlShowAll, ;
                _OOHG_ActiveControlShowMode, ;
                _OOHG_ActiveControlShowName, ;
                _OOHG_ActiveControlShowPosition, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlRtl )

/*----------------------------------------------------------------------------
PROGRESS BAR
---------------------------------------------------------------------------*/

#xcommand DEFINE PROGRESSBAR <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRangeLow  := Nil      ;;
        _OOHG_ActiveControlRangeHigh := Nil      ;;
        _OOHG_ActiveControlVertical  := .F.      ;;
        _OOHG_ActiveControlSmooth    := .F.      ;;
        _OOHG_ActiveControlForeColor := Nil      ;;
        _OOHG_ActiveControlSpeed     := Nil

#xcommand RANGEMIN <lo> ;
        => ;
        _OOHG_ActiveControlRangeLow := <lo>

#xcommand RANGEMAX <hi> ;
        => ;
        _OOHG_ActiveControlRangeHigh := <hi>

#xcommand VERTICAL <vertical> ;
        => ;
        _OOHG_ActiveControlVertical := <vertical>

#xcommand SMOOTH <smooth> ;
        => ;
        _OOHG_ActiveControlSmooth := <smooth>

#xcommand MARQUEE <speed> ;
        => ;
        _OOHG_ActiveControlSpeed := <speed>

#xcommand END PROGRESSBAR;
        => ;
        _OOHG_SelectSubClass( TProgressBar(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlRangeLow, ;
                _OOHG_ActiveControlRangeHigh, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlVertical, ;
                _OOHG_ActiveControlSmooth, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlForeColor, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlSpeed )

/*----------------------------------------------------------------------------
RADIO GROUP
---------------------------------------------------------------------------*/

#xcommand DEFINE RADIOGROUP <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlOptions     := Nil    ;;
        _OOHG_ActiveControlSpacing     := Nil    ;;
        _OOHG_ActiveControlTransparent := .F.    ;;
        _OOHG_ActiveControlAutoSize    := .F.    ;;
        _OOHG_ActiveControlThemed      := .F.    ;;
        _OOHG_ActiveControlHorizontal  := .F.

#xcommand OPTIONS <aOptions> ;
        => ;
        _OOHG_ActiveControlOptions := <aOptions>

#xcommand SPACING <spacing> ;
        => ;
        _OOHG_ActiveControlSpacing := <spacing>

#xcommand HORIZONTAL <horizontal> ;
        => ;
        _OOHG_ActiveControlHorizontal := <horizontal>

#xcommand END RADIOGROUP ;
        => ;
        _OOHG_SelectSubClass( TRadioGroup(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlOptions, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlSpacing, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlAutoSize, ;
                _OOHG_ActiveControlHorizontal, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlThemed )

/*----------------------------------------------------------------------------
SLIDER
---------------------------------------------------------------------------*/

#xcommand DEFINE SLIDER <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRangeLow  := Nil      ;;
        _OOHG_ActiveControlRangeHigh := Nil      ;;
        _OOHG_ActiveControlVertical  := .F.      ;;
        _OOHG_ActiveControlNoTicks   := .F.      ;;
        _OOHG_ActiveControlBoth      := .F.      ;;
        _OOHG_ActiveControlTop       := .F.      ;;
        _OOHG_ActiveControlLeft      := .F.

#xcommand NOTICKS <noticks> ;
        => ;
        _OOHG_ActiveControlNoTicks := <noticks>

#xcommand BOTH <both> ;
        => ;
        _OOHG_ActiveControlBoth := <both>

#xcommand TOP <top> ;
        => ;
        _OOHG_ActiveControlTop := <top>

#xcommand LEFT <left> ;
        => ;
        _OOHG_ActiveControlLeft := <left>

#xcommand END SLIDER ;
        => ;
        _OOHG_SelectSubClass( TSlider(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlRangeLow, ;
                _OOHG_ActiveControlRangeHigh, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlVertical, ;
                _OOHG_ActiveControlNoTicks, ;
                _OOHG_ActiveControlBoth, ;
                _OOHG_ActiveControlTop, ;
                _OOHG_ActiveControlLeft, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled )

/*----------------------------------------------------------------------------
TEXT BOX
---------------------------------------------------------------------------*/

#xcommand DEFINE TEXTBOX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlField        := Nil    ;;
        _OOHG_ActiveControlMaxLength    := Nil    ;;
        _OOHG_ActiveControlUpperCase    := .F.    ;;
        _OOHG_ActiveControlLowerCase    := .F.    ;;
        _OOHG_ActiveControlNumeric      := .F.    ;;
        _OOHG_ActiveControlPassword     := .F.    ;;
        _OOHG_ActiveControlRightAlign   := .F.    ;;
        _OOHG_ActiveControlReadonly     := .F.    ;;
        _OOHG_ActiveControlDateType     := .F.    ;;
        _OOHG_ActiveControlInputMask    := Nil    ;;
        _OOHG_ActiveControlPicture      := Nil    ;;
        _OOHG_ActiveControlFormat       := Nil    ;;
        _OOHG_ActiveControlNoBorder     := .F.    ;;
        _OOHG_ActiveControlAutoSkip     := .F.    ;;
        _OOHG_ActiveControlFocusedPos   := Nil    ;;
        _OOHG_ActiveControlValid        := Nil    ;;
        _OOHG_ActiveControlImage        := Nil    ;;
        _OOHG_ActiveControlWhen         := Nil    ;;
        _OOHG_ActiveControlAction       := Nil    ;;
        _OOHG_ActiveControlAction2      := Nil    ;;
        _OOHG_ActiveControlCenterAlign  := Nil    ;;
        _OOHG_ActiveControlDefaultYear  := Nil    ;;
        _OOHG_ActiveControlOnTextFilled := Nil

#xcommand UPPERCASE <uppercase> ;
        => ;
        _OOHG_ActiveControlUpperCase := <uppercase>

#xcommand LOWERCASE <lowercase> ;
        => ;
        _OOHG_ActiveControlLowerCase := <lowercase>

#xcommand NUMERIC <numeric> ;
        => ;
        _OOHG_ActiveControlNumeric := <numeric>

#xcommand PASSWORD <password> ;
        => ;
        _OOHG_ActiveControlPassword := <password>

#xcommand INPUTMASK <inputmask> ;
        => ;
        _OOHG_ActiveControlInputMask := <inputmask>

#xcommand FORMAT <format> ;
        => ;
        _OOHG_ActiveControlFormat := <format>

#xcommand AUTOSKIP <autoskip> ;
        => ;
        _OOHG_ActiveControlAutoSkip := <autoskip>

#xcommand NOBORDER <noborder> ;
        => ;
        _OOHG_ActiveControlNoBorder := <noborder>

#xcommand FOCUSEDPOS <focusedpos> ;
        => ;
        _OOHG_ActiveControlFocusedPos := <focusedpos>

#xcommand BUTTONWIDTH <buttonwidth> ;
        => ;
        _OOHG_ActiveControlButtonWidth := <buttonwidth>

#xcommand ACTION2 <action> ;
        => ;
        _OOHG_ActiveControlAction2 := <{action}>

#xcommand DEFAULTYEAR <year> ;
        => ;
        _OOHG_ActiveControlDefaultYear := <year>

#xcommand ONTEXTFILLED <ontextfilled> ;
        => ;
        _OOHG_ActiveControlOnTextFilled := <{ontextfilled}>

#xcommand ON TEXTFILLED <ontextfilled> ;
        => ;
        _OOHG_ActiveControlOnTextFilled := <{ontextfilled}>

#xcommand END TEXTBOX;
        => ;
        _OOHG_SelectSubClass( DefineTextBox( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlMaxLength, ;
                _OOHG_ActiveControlUpperCase, ;
                _OOHG_ActiveControlLowerCase, ;
                _OOHG_ActiveControlPassword, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlRightAlign, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlReadonly, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlField, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlAutoSkip, ;
                _OOHG_ActiveControlNoBorder, ;
                _OOHG_ActiveControlFocusedPos, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlValid, ;
                _OOHG_ActiveControlDateType, ;
                _OOHG_ActiveControlNumeric, ;
                _OOHG_ActiveControlInputMask, ;
                _OOHG_ActiveControlFormat, ;
                _OOHG_ActiveControlSubClass, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlImage, ;
                _OOHG_ActiveControlButtonWidth, ;
                _OOHG_ActiveControlAction2, ;
                _OOHG_ActiveControlWhen, ;
                _OOHG_ActiveControlCenterAlign, ;
                _OOHG_ActiveControlDefaultYear, ;
                _OOHG_ActiveControlOnTextFilled ), NIL, _OOHG_ActiveControlAssignObject )

/*----------------------------------------------------------------------------
MONTH CALENDAR
---------------------------------------------------------------------------*/

#xcommand DEFINE MONTHCALENDAR <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> )    ;;
        _OOHG_ActiveControlNoToday           := .F. ;;
        _OOHG_ActiveControlNoTodayCircle     := .F. ;;
        _OOHG_ActiveControlWeekNumbers       := .F. ;;
        _OOHG_ActiveControlTitleFontColor    := Nil ;;
        _OOHG_ActiveControlTitleBackColor    := Nil ;;
        _OOHG_ActiveControlTrailingFontColor := Nil ;;
        _OOHG_ActiveControlBackgroundColor   := Nil

#xcommand NOTODAY <notoday> ;
        => ;
        _OOHG_ActiveControlNoToday := <notoday>

#xcommand NOTODAYCIRCLE <notodaycircle> ;
        => ;
        _OOHG_ActiveControlNoTodayCircle := <notodaycircle>

#xcommand WEEKNUMBERS <weeknumbers> ;
        => ;
        _OOHG_ActiveControlWeekNumbers := <weeknumbers>

#xcommand TITLEFONTCOLOR <color> ;
        => ;
        _OOHG_ActiveControlTitleFontColor := <color>

#xcommand TITLEBACKCOLOR <color> ;
        => ;
        _OOHG_ActiveControlTitleBackColor := <color>

#xcommand TRAILINGFONTCOLOR <color> ;
        => ;
        _OOHG_ActiveControlTrailingFontColor := <color>

#xcommand BACKGROUNDCOLOR <color> ;
        => ;
        _OOHG_ActiveControlBackgroundColor := <color>

#xcommand END MONTHCALENDAR ;
        => ;
        _OOHG_SelectSubClass( TMonthCal(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlNoToday, ;
                _OOHG_ActiveControlNoTodayCircle, ;
                _OOHG_ActiveControlWeekNumbers, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
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
BUTTON
---------------------------------------------------------------------------*/

#xcommand DEFINE BUTTON <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlCaption     := Nil    ;;
        _OOHG_ActiveControlAction      := Nil    ;;
        _OOHG_ActiveControlFlat        := .F.    ;;
        _OOHG_ActiveControlPicture     := Nil    ;;
        _OOHG_ActiveControlTransparent := .T.    ;;
        _OOHG_ActiveControlNoPrefix    := .F.    ;;
        _OOHG_ActiveControlBuffer      := Nil    ;;
        _OOHG_ActiveControlHBitmap     := Nil    ;;
        _OOHG_ActiveControlScale       := .F.    ;;
        _OOHG_ActiveControlCancel      := .F.    ;;
        _OOHG_ActiveControlAlignment   := Nil    ;;
        _OOHG_ActiveControlMultiLine   := .F.    ;;
        _OOHG_ActiveControlThemed      := .F.    ;;
        _OOHG_ActiveControlImageMargin := Nil    ;;
        _OOHG_ActiveControlNo3DColors  := .F.    ;;
        _OOHG_ActiveControlAutoFit     := .F.

#xcommand CAPTION <caption> ;
        => ;
        _OOHG_ActiveControlCaption := <caption>

#xcommand ACTION <action> ;
        => ;
        _OOHG_ActiveControlAction := <{action}>

#xcommand ONCLICK <action> ;
        => ;
        _OOHG_ActiveControlAction := <{action}>

#xcommand ON CLICK <action> ;
        => ;
        _OOHG_ActiveControlAction := <{action}>

#xcommand ITEMCOUNT <itemcount> ;
        => ;
        _OOHG_ActiveControlItemCount := <itemcount>

#xcommand FLAT <flat> ;
        => ;
        _OOHG_ActiveControlFlat := <flat>

#xcommand ONMOUSEMOVE <onmousemove> ;
        => ;
        _OOHG_ActiveControlOnMouseMove := <{onmousemove}>

#xcommand ON MOUSEMOVE <onmousemove> ;
        => ;
        _OOHG_ActiveControlOnMouseMove := <{onmousemove}>

#xcommand ONGOTFOCUS <ongotfocus> ;
        => ;
        _OOHG_ActiveControlOnGotFocus := <{ongotfocus}>

#xcommand ON GOTFOCUS <ongotfocus> ;
        => ;
        _OOHG_ActiveControlOnGotFocus := <{ongotfocus}>

#xcommand ONLOSTFOCUS <onlostfocus> ;
        => ;
        _OOHG_ActiveControlOnLostFocus := <{onlostfocus}>

#xcommand ON LOSTFOCUS <onlostfocus> ;
        => ;
        _OOHG_ActiveControlOnLostFocus := <{onlostfocus}>

#xcommand PICTURE <picture> ;
        => ;
        _OOHG_ActiveControlPicture := <picture>

#xcommand TRANSPARENT <transparent> ;
        => ;
        _OOHG_ActiveControlTransparent := <transparent>

#xcommand BUFFER <buffer> ;
        => ;
        _OOHG_ActiveControlBuffer := <buffer>

#xcommand HBITMAP <hbitmap> ;
        => ;
        _OOHG_ActiveControlHBitmap := <hbitmap>

#xcommand SCALE <scale> ;
        => ;
        _OOHG_ActiveControlScale := <scale>

#xcommand CANCEL <cancel> ;
        => ;
        _OOHG_ActiveControlCancel := <cancel>

#xcommand ALIGNMENT <alignment:LEFT,RIGHT,TOP,BOTTOM,CENTER> ;
        => ;
        _OOHG_ActiveControlAlignment := <"alignment">

#xcommand MULTILINE <multiline> ;
        => ;
        _OOHG_ActiveControlMultiLine := <multiline>

#xcommand THEMED <themed> ;
        => ;
        _OOHG_ActiveControlThemed := <themed>

#xcommand IMAGEMARGIN <margin> ;
        => ;
        _OOHG_ActiveControlImageMargin := <margin>

#xcommand NO3DCOLORS <no3dcolors> ;
        => ;
        _OOHG_ActiveControlNo3DColors := <no3dcolors>

#xcommand AUTOFIT <autofit> ;
        => ;
        _OOHG_ActiveControlAutoFit := <autofit>

#xcommand ADJUST <autofit> ;
        => ;
        _OOHG_ActiveControlAutoFit := <autofit>

#xcommand END BUTTON ;
        => ;
        _OOHG_SelectSubClass( TButton(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlCaption, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlFlat, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlNoPrefix, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlBuffer, ;
                _OOHG_ActiveControlHBitmap, ;
                _OOHG_ActiveControlPicture, ;
                .NOT. _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlScale, ;
                _OOHG_ActiveControlCancel, ;
                _OOHG_ActiveControlAlignment, ;
                _OOHG_ActiveControlMultiLine, ;
                _OOHG_ActiveControlThemed, ;
                _OOHG_ActiveControlImageMargin, ;
                _OOHG_ActiveControlOnMouseMove, ;
                _OOHG_ActiveControlNo3DColors, ;
                _OOHG_ActiveControlAutoFit )

/*----------------------------------------------------------------------------
IMAGE
---------------------------------------------------------------------------*/

#xcommand DEFINE IMAGE <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> )  ;;
        _OOHG_ActiveControlPicture         := Nil ;;
        _OOHG_ActiveControlAction          := Nil ;;
        _OOHG_ActiveControlStretch         := .F. ;;
        _OOHG_ActiveControlNoResize        := .F. ;;
        _OOHG_ActiveControlBorder          := .F. ;;
        _OOHG_ActiveControlClientEdge      := .F. ;;
        _OOHG_ActiveControlImagesize       := .F. ;;
        _OOHG_ActiveControlBuffer          := Nil ;;
        _OOHG_ActiveControlHBitmap         := Nil ;;
        _OOHG_ActiveControlWhiteBackground := Nil

#xcommand STRETCH <stretch> ;
        => ;
        _OOHG_ActiveControlStretch := <stretch>

#xcommand IMAGESIZE <imagesize> ;
        => ;
        _OOHG_ActiveControlImagesize := <imagesize>

#xcommand WHITEBACKGROUND <whitebackground> ;
        => ;
        _OOHG_ActiveControlWhiteBackground := iif( <whitebackground>, 0xFFFFFF, _OOHG_ActiveControlBackColor )

#xcommand NORESIZE <noresize> ;
        => ;
        _OOHG_ActiveControlNoResize := <noresize>

#xcommand END IMAGE ;
        => ;
        _OOHG_SelectSubClass( TImage(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlPicture, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlStretch, ;
                _OOHG_ActiveControlWhiteBackground, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlBuffer, ;
                _OOHG_ActiveControlHBitmap, ;
                .NOT. _OOHG_ActiveControlNoResize, ;
                _OOHG_ActiveControlImagesize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlBorder, ;
                _OOHG_ActiveControlClientEdge )

/*----------------------------------------------------------------------------
CHECK BOX/BUTTON
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKBOX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlCaption     := Nil    ;;
        _OOHG_ActiveControlTransparent := .F.    ;;
        _OOHG_ActiveControlAutoSize    := .F.    ;;
        _OOHG_ActiveControlField       := Nil    ;;
        _OOHG_ActiveControl3State      := .F.    ;;
        _OOHG_ActiveControlThemed      := .F.    ;;
        _OOHG_ActiveControlRightAlign  := .T.

#xcommand THREESTATE <threestate> ;
        => ;
        _OOHG_ActiveControl3State := <threestate>

#xcommand LEFTALIGN <leftalign> ;
        => ;
        _OOHG_ActiveControlRightAlign := .NOT. <leftalign>

#xcommand DEFINE CHECKBUTTON <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlCaption     := Nil    ;;
        _OOHG_ActiveControlPicture     := Nil    ;;
        _OOHG_ActiveControlField       := Nil    ;;
        _OOHG_ActiveControlBuffer      := Nil    ;;
        _OOHG_ActiveControlHBitmap     := Nil    ;;
        _OOHG_ActiveControlTransparent := .T.    ;;
        _OOHG_ActiveControlScale       := .F.    ;;
        _OOHG_ActiveControlNo3DColors  := .F.    ;;
        _OOHG_ActiveControlAutoFit     := .F.

#xcommand ONCHANGE <onchange> ;
        => ;
        _OOHG_ActiveControlOnChange := <{onchange}>

#xcommand ON CHANGE <onchange> ;
        => ;
        _OOHG_ActiveControlOnChange := <{onchange}>

#xcommand ON QUERYDATA <onquerydata> ;
        => ;
        _OOHG_ActiveControlOnQueryData := <{onquerydata}>

#xcommand ONQUERYDATA <onquerydata> ;
        => ;
        _OOHG_ActiveControlOnQueryData := <{onquerydata}>

#xcommand END CHECKBOX ;
        => ;
        _OOHG_SelectSubClass( TCheckBox(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlCaption, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlField, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlAutoSize, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControl3State, ;
                .NOT. _OOHG_ActiveControlRightAlign, ;
                _OOHG_ActiveControlThemed )

#xcommand END CHECKBUTTON ;
        => ;
        _OOHG_SelectSubClass( TButtonCheck(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlCaption, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlField, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlPicture, ;
                _OOHG_ActiveControlBuffer, ;
                _OOHG_ActiveControlHBitmap, ;
                .NOT. _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlScale, ;
                _OOHG_ActiveControlNo3DColors, ;
                _OOHG_ActiveControlAutoFit )

/*----------------------------------------------------------------------------
COMBO BOX
---------------------------------------------------------------------------*/

#xcommand DEFINE COMBOBOX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlItems             := Nil  ;;
        _OOHG_ActiveControlSort              := .F.  ;;
        _OOHG_ActiveControlItemSource        := Nil  ;;
        _OOHG_ActiveControlValueSource       := Nil  ;;
        _OOHG_ActiveControlBreak             := .F.  ;;
        _OOHG_ActiveControlGripperText       := ""   ;;
        _OOHG_ActiveControlDisplayEdit       := .F.  ;;
        _OOHG_ActiveControlDisplayChange     := Nil  ;;
        _OOHG_ActiveControlImage             := Nil  ;;
        _OOHG_ActiveControlTextHeight        := Nil  ;;
        _OOHG_ActiveControlStretch           := .F.  ;;
        _OOHG_ActiveControlFirstItem         := Nil  ;;
        _OOHG_ActiveControlListWidth         := Nil  ;;
        _OOHG_ActiveControlItemImageNumber   := Nil  ;;
        _OOHG_ActiveControlImageSource       := Nil  ;;
        _OOHG_ActiveControlDelayedLoad       := Nil  ;;
        _OOHG_ActiveControlIncrementalSearch := Nil  ;;
        _OOHG_ActiveControlIntegralHeight    := Nil

#xcommand DELAYEDLOAD <delayedload> ;
        => ;
        _OOHG_ActiveControlDelayedLoad := <delayedload>

#xcommand INCREMENTAL <incremental> ;
        => ;
        _OOHG_ActiveControlIncrementalSearch := <incremental>

#xcommand INTEGRALHEIGHT <integralheight> ;
        => ;
        _OOHG_ActiveControlIntegralHeight := <integralheight>

#xcommand IMAGESOURCE <imagesource> ;
        => ;
        _OOHG_ActiveControlImageSource := <{imagesource}>

#xcommand ITEMIMAGENUMBER <itemimagenumber> ;
        => ;
        _OOHG_ActiveControlItemImageNumber := <{itemimagenumber}>

#xcommand LISTWIDTH <listwidth> ;
        => ;
        _OOHG_ActiveControlListWidth := <listwidth>

#xcommand DISPLAYEDIT <displayedit> ;
        => ;
        _OOHG_ActiveControlDisplayEdit := <displayedit>

#xcommand GRIPPERTEXT <grippertext> ;
        => ;
        _OOHG_ActiveControlGripperText := <grippertext>

#xcommand ON DISPLAYCHANGE <displaychange> ;
        => ;
        _OOHG_ActiveControlDisplayChange := <{displaychange}>

#xcommand ONDISPLAYCHANGE <displaychange> ;
        => ;
        _OOHG_ActiveControlDisplayChange := <{displaychange}>

#xcommand ITEM <aRows> ;
        => ;
        _OOHG_ActiveControlItems := <aRows>

#xcommand ITEMS <aRows> ;
        => ;
        _OOHG_ActiveControlItems := <aRows>

#xcommand ONENTER <enter> ;
        => ;
        _OOHG_ActiveControlOnEnter := <{enter}>

#xcommand ON ENTER <enter> ;
        => ;
        _OOHG_ActiveControlOnEnter := <{enter}>

#xcommand ON LISTDISPLAY <enter> ;
        => ;
        _OOHG_ActiveControlOnListDisplay := <{enter}>

#xcommand ON LISTCLOSE <enter> ;
        => ;
        _OOHG_ActiveControlOnListClose := <{enter}>

#xcommand FIRSTITEM <firstitem> ;
        => ;
        _OOHG_ActiveControlFirstItem := <firstitem>

#xcommand END COMBOBOX ;
        => ;
        _OOHG_SelectSubClass( TCombo(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlItems, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlSort, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlItemSource, ;
                _OOHG_ActiveControlValueSource, ;
                _OOHG_ActiveControlDisplayEdit, ;
                _OOHG_ActiveControlDisplayChange, ;
                _OOHG_ActiveControlBreak, ;
                _OOHG_ActiveControlGripperText, ;
                _OOHG_ActiveControlImage, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlTextHeight, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlFirstItem, ;
                _OOHG_ActiveControlStretch, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlListWidth, ;
                _OOHG_ActiveControlOnListDisplay, ;
                _OOHG_ActiveControlOnListClose, ;
                _OOHG_ActiveControlImageSource, ;
                _OOHG_ActiveControlItemImageNumber, ;
                _OOHG_ActiveControlDelayedLoad, ;
                _OOHG_ActiveControlIncrementalSearch, ;
                _OOHG_ActiveControlIntegralHeight )

/*----------------------------------------------------------------------------
DATEPICKER
---------------------------------------------------------------------------*/

#xcommand DEFINE DATEPICKER <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlShowNone   := .F.     ;;
        _OOHG_ActiveControlUpDown     := .F.     ;;
        _OOHG_ActiveControlRightAlign := .F.     ;;
        _OOHG_ActiveControlField      := Nil     ;;
        _OOHG_ActiveControlNoBorder   := .F.     ;;
        _OOHG_ActiveControlRangeLow  := Nil      ;;
        _OOHG_ActiveControlRangeHigh := Nil

#xcommand SHOWNONE <shownone> ;
        => ;
        _OOHG_ActiveControlShowNone := <shownone>

#xcommand UPDOWN <updown> ;
        => ;
        _OOHG_ActiveControlUpDown := <updown>

#xcommand RIGHTALIGN <rightalign> ;
        => ;
        _OOHG_ActiveControlRightAlign := <rightalign>

#xcommand END DATEPICKER ;
        => ;
        _OOHG_SelectSubClass( TDatePick(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlShowNone, ;
                _OOHG_ActiveControlUpDown, ;
                _OOHG_ActiveControlRightAlign, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlField, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlNoBorder, ;
                _OOHG_ActiveControlRangeLow, ;
                _OOHG_ActiveControlRangeHigh )

#xcommand DEFINE TIMEPICKER <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlShowNone   := .F.     ;;
        _OOHG_ActiveControlUpDown     := .F.     ;;
        _OOHG_ActiveControlRightAlign := .F.     ;;
        _OOHG_ActiveControlField      := Nil     ;;
        _OOHG_ActiveControlNoBorder   := .F.

#xcommand END TIMEPICKER ;
        => ;
        _OOHG_SelectSubClass( TTimePick(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlShowNone, ;
                _OOHG_ActiveControlUpDown, ;
                _OOHG_ActiveControlRightAlign, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlField, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlNoBorder )

/*----------------------------------------------------------------------------
EDIT BOX
---------------------------------------------------------------------------*/

#xcommand DEFINE EDITBOX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlReadonly   := .F.     ;;
        _OOHG_ActiveControlMaxLength  := Nil     ;;
        _OOHG_ActiveControlBreak      := .F.     ;;
        _OOHG_ActiveControlField      := Nil     ;;
        _OOHG_ActiveControlNoVScroll  := .F.     ;;
        _OOHG_ActiveControlNoHScroll  := .F.     ;;
        _OOHG_ActiveControlNoBorder   := .F.     ;;
        _OOHG_ActiveControlFocusedPos := Nil

#xcommand READONLYFIELDS <readonly> ;
        => ;
        _OOHG_ActiveControlReadOnly := <readonly>

#xcommand MAXLENGTH <maxlength> ;
        => ;
        _OOHG_ActiveControlMaxLength := <maxlength>

#xcommand SETBREAK <break> ;
        => ;
        _OOHG_ActiveControlBreak := <break>

#xcommand END EDITBOX ;
        => ;
        _OOHG_SelectSubClass( TEdit(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlMaxLength, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlReadOnly, ;
                _OOHG_ActiveControlBreak, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlField, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlNoVScroll, ;
                _OOHG_ActiveControlNoHScroll, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlNoBorder, ;
                _OOHG_ActiveControlFocusedPos )

/*----------------------------------------------------------------------------
RICH EDIT BOX
---------------------------------------------------------------------------*/

#xcommand DEFINE RICHEDITBOX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlReadonly    := .F.    ;;
        _OOHG_ActiveControlMaxLength   := Nil    ;;
        _OOHG_ActiveControlBreak       := .F.    ;;
        _OOHG_ActiveControlField       := Nil    ;;
        _OOHG_ActiveControlOnSelChange := Nil    ;;
        _OOHG_ActiveControlNoHideSel   := Nil

#xcommand NOHIDESEL <nohidesel> ;
        => ;
        _OOHG_ActiveControlNoHideSel := <nohidesel>

#xcommand ONSELCHANGE <onselchange> ;
        => ;
        _OOHG_ActiveControlOnSelChange := <{onselchange}>

#xcommand ON SELCHANGE <onselchange> ;
        => ;
        _OOHG_ActiveControlOnSelChange := <{onselchange}>

#xcommand END RICHEDITBOX ;
        => ;
        _OOHG_SelectSubClass( TEditRich(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlMaxLength, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlReadOnly, ;
                _OOHG_ActiveControlBreak, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlField, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlOnSelChange, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlNoHideSel )

/*----------------------------------------------------------------------------
LABEL
---------------------------------------------------------------------------*/

#xcommand DEFINE LABEL <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlBorder      := .F.    ;;
        _OOHG_ActiveControlClientEdge  := .F.    ;;
        _OOHG_ActiveControlHScroll     := .F.    ;;
        _OOHG_ActiveControlVScroll     := .F.    ;;
        _OOHG_ActiveControlTransparent := .F.    ;;
        _OOHG_ActiveControlAction      := Nil    ;;
        _OOHG_ActiveControlRightAlign  := .F.    ;;
        _OOHG_ActiveControlAutoSize    := .F.    ;;
        _OOHG_ActiveControlCenterAlign := .F.    ;;
        _OOHG_ActiveControlNoWordWrap  := .F.    ;;
        _OOHG_ActiveControlNoPrefix    := .F.    ;;
        _OOHG_ActiveControlInputMask   := Nil

#xcommand CENTERALIGN <centeralign> ;
        => ;
        _OOHG_ActiveControlCenterAlign := <centeralign>

#xcommand FORECOLOR <color> ;
        => ;
        _OOHG_ActiveControlForeColor := <color>

#xcommand BORDER <border> ;
        => ;
        _OOHG_ActiveControlBorder := <border>

#xcommand CLIENTEDGE <clientedge> ;
        => ;
        _OOHG_ActiveControlClientEdge := <clientedge>

#xcommand HSCROLL <hscroll> ;
        => ;
        _OOHG_ActiveControlHScroll := <hscroll>

#xcommand VSCROLL <vscroll> ;
        => ;
        _OOHG_ActiveControlVScroll := <vscroll>

#xcommand TRANSPARENT <transparent> ;
        => ;
        _OOHG_ActiveControlTransparent := <transparent>

#xcommand NOWORDWRAP <nowordwrap> ;
        => ;
        _OOHG_ActiveControlNoWordWrap := <nowordwrap>

#xcommand NOPREFIX <noprefix> ;
        => ;
        _OOHG_ActiveControlNoPrefix := <noprefix>

#xcommand END LABEL ;
        => ;
        _OOHG_SelectSubClass( TLabel(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlBorder, ;
                _OOHG_ActiveControlClientEdge, ;
                _OOHG_ActiveControlHScroll, ;
                _OOHG_ActiveControlVScroll, ;
                _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlAutoSize, ;
                _OOHG_ActiveControlRightAlign, ;
                _OOHG_ActiveControlCenterAlign, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlNoWordWrap, ;
                _OOHG_ActiveControlNoPrefix, ;
                _OOHG_ActiveControlInputMask )

#xcommand DEFINE IPADDRESS <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> )

#xcommand END IPADDRESS ;
        => ;
        _OOHG_SelectSubClass( TIPAddress(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled )

/*----------------------------------------------------------------------------
GRID
---------------------------------------------------------------------------*/

#xcommand DEFINE GRID <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> )   ;;
        _OOHG_ActiveControlHeaders          := Nil ;;
        _OOHG_ActiveControlWidths           := Nil ;;
        _OOHG_ActiveControlItems            := Nil ;;
        _OOHG_ActiveControlOnHeadClick      := Nil ;;
        _OOHG_ActiveControlNoLines          := .F. ;;
        _OOHG_ActiveControlImage            := Nil ;;
        _OOHG_ActiveControlJustify          := Nil ;;
        _OOHG_ActiveControlMultiSelect      := .F. ;;
        _OOHG_ActiveControlEdit             := .F. ;;
        _OOHG_ActiveControlBreak            := .F. ;;
        _OOHG_ActiveControlOnQueryData      := Nil ;;
        _OOHG_ActiveControlItemCount        := Nil ;;
        _OOHG_ActiveControlReadOnly         := Nil ;;
        _OOHG_ActiveControlVirtual          := .F. ;;
        _OOHG_ActiveControlInputMask        := Nil ;;
        _OOHG_ActiveControlOnAppend         := Nil ;;
        _OOHG_ActiveControlInPlaceEdit      := .F. ;;
        _OOHG_ActiveControlDynamicBackColor := Nil ;;
        _OOHG_ActiveControlDynamicForeColor := Nil ;;
        _OOHG_ActiveControlEditControls     := Nil ;;
        _OOHG_ActiveControlReadOnly         := Nil ;;
        _OOHG_ActiveControlValid            := Nil ;;
        _OOHG_ActiveControlValidMessages    := Nil ;;
        _OOHG_ActiveControlEditCell         := Nil ;;
        _OOHG_ActiveControlWhen             := Nil ;;
        _OOHG_ActiveControlShowHeaders      := Nil ;;
        _OOHG_ActiveControlHeaderImages     := Nil ;;
        _OOHG_ActiveControlImagesAlign      := Nil ;;
        _OOHG_ActiveControlFullMove         := .F. ;;
        _OOHG_ActiveControlByCell           := .F. ;;
        _OOHG_ActiveControlSelectedColors   := .F. ;;
        _OOHG_ActiveControlKeys             := Nil ;;
        _OOHG_ActiveControlCheckBoxes       := .F. ;;
        _OOHG_ActiveControlOnCheckChange    := Nil ;;
        _OOHG_ActiveControlDblBffer         := .T. ;;
        _OOHG_ActiveControlPaintLeftMargin  := .F. ;;
        _OOHG_ActiveControlFocusRect        := .F. ;;
        _OOHG_ActiveControlNoFocusRect      := .F. ;;
        _OOHG_ActiveControlFixedCols        := .F. ;;
        _OOHG_ActiveControlAbortEdit        := Nil ;;
        _OOHG_ActiveControlAction           := Nil ;;
        _OOHG_ActiveControlFixedWidths      := .F. ;;
        _OOHG_ActiveControlBeforeColMove    := Nil ;;
        _OOHG_ActiveControlAfterColMove     := Nil ;;
        _OOHG_ActiveControlBeforeColSize    := Nil ;;
        _OOHG_ActiveControlAfterColSize     := Nil ;;
        _OOHG_ActiveControlBeforeAutoFit    := Nil ;;
        _OOHG_ActiveControlEditLikeExcel    := Nil ;;
        _OOHG_ActiveControlUseButtons       := Nil ;;
        _OOHG_ActiveControlNoDeleteMsg      := .F. ;;
        _OOHG_ActiveControlAppendable       := .F.

#xcommand ONAPPEND <onappend> ;
        => ;
        _OOHG_ActiveControlOnAppend := <onappend>

#xcommand HEADERIMAGES <aHeaderImages> ;
        => ;
        _OOHG_ActiveControlHeaderImages := <aHeaderImages>

#xcommand IMAGESALIGN <aImgAlign> ;
        => ;
        _OOHG_ActiveControlImagesAlign := <aImgAlign>

#xcommand FULLMOVE <fullmove> ;
        => ;
        _OOHG_ActiveControlFullMove := <fullmove>

#xcommand NAVIGATEBYCELL <bycell> ;
        => ;
        _OOHG_ActiveControlByCell := <bycell>

#xcommand SELECTEDCOLORS <aSelectedColors> ;
        => ;
        _OOHG_ActiveControlSelectedColors := <aSelectedColors>

#xcommand EDITKEYS <aKeys> ;
        => ;
        _OOHG_ActiveControlKeys := <aKeys>

#xcommand CHECKBOXES <checkboxes> ;
        => ;
        _OOHG_ActiveControlCheckBoxes := <checkboxes>

#xcommand ONCHECKCHANGE <checkchange> ;
        => ;
        _OOHG_ActiveControlOnCheckChange := <{checkchange}>

#xcommand ON CHECKCHANGE <checkchange> ;
        => ;
        _OOHG_ActiveControlOnCheckChange := <{checkchange}>

#xcommand PAINTLEFTMARGIN <paintleftmargin> ;
        => ;
        _OOHG_ActiveControlPaintLeftMargin := <paintleftmargin>

#xcommand FOCUSRECT <focusrect> ;
        => ;
        _OOHG_ActiveControlFocusRect := <focusrect>

#xcommand NOFOCUSRECT <nofocusrect> ;
        => ;
        _OOHG_ActiveControlNoFocusRect := <nofocusrect>

#xcommand FIXEDCOLS <fixedcols> ;
        => ;
        _OOHG_ActiveControlFixedCols := <fixedcols>

#xcommand FIXEDWIDTHS <fixedwidths> ;
        => ;
        _OOHG_ActiveControlFixedWidths := <fixedwidths>

#xcommand BEFORECOLMOVE <bBefMov> ;
        => ;
        _OOHG_ActiveControlBeforeColMove := <{bBefMov}>

#xcommand AFTERCOLMOVE <bAftMov> ;
        => ;
        _OOHG_ActiveControlAfterColMove := <{bAftMov}>

#xcommand BEFORECOLSIZE <bBefSiz> ;
        => ;
        _OOHG_ActiveControlBeforeColSize := <{bBefSiz}>

#xcommand AFTERCOLSIZE <bAftSiz> ;
        => ;
        _OOHG_ActiveControlAfterColSize := <{bAftSiz}>

#xcommand BEFOREAUTOFIT <bBefAut> ;
        => ;
        _OOHG_ActiveControlBeforeAutoFit := <{bBefAut}>

#xcommand EDITLIKEEXCEL <excel> ;
        => ;
        _OOHG_ActiveControlEditLikeExcel := <excel>

#xcommand USEBUTTONS <buts> ;
        => ;
        _OOHG_ActiveControlUseButtons := <buts>

#xcommand END GRID ;
        => ;
        _OOHG_SelectSubClass( iif( _OOHG_ActiveControlByCell, TGridByCell(), iif( _OOHG_ActiveControlMultiSelect, TGridMulti(), TGrid() ) ), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlHeaders, ;
                _OOHG_ActiveControlWidths, ;
                _OOHG_ActiveControlItems, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnDblClick, ;
                _OOHG_ActiveControlOnHeadClick, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlNoLines, ;
                _OOHG_ActiveControlImage, ;
                _OOHG_ActiveControlJustify, ;
                _OOHG_ActiveControlBreak, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlVirtual, ;
                _OOHG_ActiveControlOnQueryData, ;
                _OOHG_ActiveControlItemCount, ;
                _OOHG_ActiveControlEdit, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlDynamicBackColor, ;
                _OOHG_ActiveControlDynamicForeColor, ;
                _OOHG_ActiveControlInputMask, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlInPlaceEdit, ;
                _OOHG_ActiveControlEditControls, ;
                _OOHG_ActiveControlReadOnly, ;
                _OOHG_ActiveControlValid, ;
                _OOHG_ActiveControlValidMessages, ;
                _OOHG_ActiveControlEditCell, ;
                _OOHG_ActiveControlWhen, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlShowHeaders, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlHeaderImages, ;
                _OOHG_ActiveControlImagesAlign, ;
                _OOHG_ActiveControlFullMove, ;
                _OOHG_ActiveControlSelectedColors, ;
                _OOHG_ActiveControlKeys, ;
                _OOHG_ActiveControlCheckBoxes, ;
                _OOHG_ActiveControlOnCheckChange, ;
                _OOHG_ActiveControlDblBffer, ;
                iif( _OOHG_ActiveControlNoFocusRect, .F., iif( _OOHG_ActiveControlFocusRect, .T., NIL ) ), ;
                _OOHG_ActiveControlPaintLeftMargin, ;
                _OOHG_ActiveControlFixedCols, ;
                _OOHG_ActiveControlAbortEdit, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlFixedWidths, ;
                _OOHG_ActiveControlBeforeColMove, ;
                _OOHG_ActiveControlAfterColMove, ;
                _OOHG_ActiveControlBeforeColSize, ;
                _OOHG_ActiveControlAfterColSize, ;
                _OOHG_ActiveControlBeforeAutoFit, ;
                _OOHG_ActiveControlEditLikeExcel, ;
                _OOHG_ActiveControlUseButtons, ;
                _OOHG_ActiveControlNoDeleteMsg, ;
                _OOHG_ActiveControlAppendable, ;
                _OOHG_ActiveControlOnAppend )

/*----------------------------------------------------------------------------
BROWSE
---------------------------------------------------------------------------*/

#xcommand DEFINE BROWSE <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> )   ;;
        _OOHG_ActiveControlHeaders          := Nil ;;
        _OOHG_ActiveControlWidths           := Nil ;;
        _OOHG_ActiveControlOnHeadClick      := Nil ;;
        _OOHG_ActiveControlNoLines          := .F. ;;
        _OOHG_ActiveControlImage            := Nil ;;
        _OOHG_ActiveControlJustify          := Nil ;;
        _OOHG_ActiveControlEdit             := .F. ;;
        _OOHG_ActiveControlBreak            := .F. ;;
        _OOHG_ActiveControlWorkArea         := Nil ;;
        _OOHG_ActiveControlFields           := Nil ;;
        _OOHG_ActiveControlDelete           := .F. ;;
        _OOHG_ActiveControlAppendable       := .F. ;;
        _OOHG_ActiveControlValid            := Nil ;;
        _OOHG_ActiveControlReadOnly         := Nil ;;
        _OOHG_ActiveControlLock             := .F. ;;
        _OOHG_ActiveControlValidMessages    := Nil ;;
        _OOHG_ActiveControlNoVScroll        := .F. ;;
        _OOHG_ActiveControlInputMask        := Nil ;;
        _OOHG_ActiveControlInPlaceEdit      := .F. ;;
        _OOHG_ActiveControlDynamicBackColor := Nil ;;
        _OOHG_ActiveControlDynamicForeColor := Nil ;;
        _OOHG_ActiveControlWhen             := Nil ;;
        _OOHG_ActiveControlOnAppend         := Nil ;;
        _OOHG_ActiveControlEditCell         := Nil ;;
        _OOHG_ActiveControlEditControls     := Nil ;;
        _OOHG_ActiveControlReplaceFields    := Nil ;;
        _OOHG_ActiveControlShowHeaders      := Nil ;;
        _OOHG_ActiveControlDeleteWhen       := Nil ;;
        _OOHG_ActiveControlDeleteMsg        := Nil ;;
        _OOHG_ActiveControlOnDelete         := Nil ;;
        _OOHG_ActiveControlColumnInfo       := Nil ;;
        _OOHG_ActiveControlDescending       := .F. ;;
        _OOHG_ActiveControlRecCount         := .F. ;;
        _OOHG_ActiveControlHeaderImages     := Nil ;;
        _OOHG_ActiveControlImagesAlign      := Nil ;;
        _OOHG_ActiveControlFullMove         := .F. ;;
        _OOHG_ActiveControlSelectedColors   := .F. ;;
        _OOHG_ActiveControlKeys             := Nil ;;
        _OOHG_ActiveControlForceRefresh     := .F. ;;
        _OOHG_ActiveControlNoRefresh        := .F. ;;
        _OOHG_ActiveControlDblBffer         := .T. ;;
        _OOHG_ActiveControlPaintLeftMargin  := .F. ;;
        _OOHG_ActiveControlFocusRect        := .F. ;;
        _OOHG_ActiveControlNoFocusRect      := .F. ;;
        _OOHG_ActiveControlSynchronized     := Nil ;;
        _OOHG_ActiveControlFixedCols        := .F. ;;
        _OOHG_ActiveControlNoDeleteMsg      := .F. ;;
        _OOHG_ActiveControlUpdateAll        := .F. ;;
        _OOHG_ActiveControlAbortEdit        := Nil ;;
        _OOHG_ActiveControlAction           := Nil ;;
        _OOHG_ActiveControlFixedWidths      := .F. ;;
        _OOHG_ActiveControlFixedBlocks      := .F. ;;
        _OOHG_ActiveControlBeforeColMove    := Nil ;;
        _OOHG_ActiveControlAfterColMove     := Nil ;;
        _OOHG_ActiveControlBeforeColSize    := Nil ;;
        _OOHG_ActiveControlAfterColSize     := Nil ;;
        _OOHG_ActiveControlBeforeAutoFit    := Nil ;;
        _OOHG_ActiveControlEditLikeExcel    := Nil ;;
        _OOHG_ActiveControlUseButtons       := Nil ;;
        _OOHG_ActiveControlUpdateColors     := NIL

#xcommand DELETEWHEN <delwhen> ;
        => ;
        _OOHG_ActiveControlDeleteWhen := <{delwhen}>

#xcommand DELETEMSG <delmsg> ;
        => ;
        _OOHG_ActiveControlDeleteMsg := <delmsg>

#xcommand ONDELETE <ondelete> ;
        => ;
        _OOHG_ActiveControlOnDelete := <{ondelete}>

#xcommand ON DELETE <ondelete> ;
        => ;
        _OOHG_ActiveControlOnDelete := <{ondelete}>

#xcommand COLUMNINFO <columninfo> ;
        => ;
        _OOHG_ActiveControlColumnInfo := <columninfo>

#xcommand DESCENDING <descending> ;
        => ;
        _OOHG_ActiveControlDescending := <descending>

#xcommand RECCOUNT <reccount> ;
        => ;
        _OOHG_ActiveControlRecCount := <reccount>

#xcommand FORCEREFRESH <forcerefresh> ;
        => ;
        _OOHG_ActiveControlForceRefresh := <forcerefresh>

#xcommand NOREFRESH <norefresh> ;
        => ;
        _OOHG_ActiveControlNoRefresh := <norefresh>

#xcommand SYNCHRONIZED <sync> ;
        => ;
        _OOHG_ActiveControlSynchronized := <sync>

#xcommand NODELETEMSG <nodeletemsg> ;
        => ;
        _OOHG_ActiveControlNoDeleteMsg := <nodeletemsg>

#xcommand UPDATEALL <updall> ;
        => ;
        _OOHG_ActiveControlUpdateAll := <updall>

#xcommand FIXEDBLOCKS <fixedblocks> ;
        => ;
        _OOHG_ActiveControlFixedBlocks := <fixedblocks>

#xcommand UPDATECOLORS <upcols> ;
        => ;
        _OOHG_ActiveControlUpdateColors := <upcols>

#xcommand END BROWSE ;
        => ;
        _OOHG_SelectSubClass( TOBrowse(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlHeaders, ;
                _OOHG_ActiveControlWidths, ;
                _OOHG_ActiveControlFields, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnDblClick, ;
                _OOHG_ActiveControlOnHeadClick, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlWorkArea, ;
                _OOHG_ActiveControlDelete, ;
                _OOHG_ActiveControlNoLines, ;
                _OOHG_ActiveControlImage, ;
                _OOHG_ActiveControlJustify, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlBreak, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlLock, ;
                _OOHG_ActiveControlInPlaceEdit, ;
                _OOHG_ActiveControlNoVScroll, ;
                _OOHG_ActiveControlAppendable, ;
                _OOHG_ActiveControlReadOnly, ;
                _OOHG_ActiveControlValid, ;
                _OOHG_ActiveControlValidMessages, ;
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
                _OOHG_ActiveControlRecCount, ;
                _OOHG_ActiveControlColumnInfo, ;
                _OOHG_ActiveControlShowHeaders, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlDescending, ;
                _OOHG_ActiveControlDeleteWhen, ;
                _OOHG_ActiveControlDeleteMsg, ;
                _OOHG_ActiveControlOnDelete, ;
                _OOHG_ActiveControlHeaderImages, ;
                _OOHG_ActiveControlImagesAlign, ;
                _OOHG_ActiveControlFullMove, ;
                _OOHG_ActiveControlSelectedColors, ;
                _OOHG_ActiveControlKeys, ;
                if( _OOHG_ActiveControlForceRefresh, 0, if( _OOHG_ActiveControlNoRefresh, 1, nil ) ), ;
                _OOHG_ActiveControlDblBffer, ;
                iif( _OOHG_ActiveControlNoFocusRect, .F., iif( _OOHG_ActiveControlFocusRect, .T., NIL ) ), ;
                _OOHG_ActiveControlPaintLeftMargin, ;
                _OOHG_ActiveControlSynchronized, ;
                _OOHG_ActiveControlFixedCols, ;
                _OOHG_ActiveControlNoDeleteMsg, ;
                _OOHG_ActiveControlUpdateAll, ;
                _OOHG_ActiveControlAbortEdit, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlFixedWidths, ;
                _OOHG_ActiveControlFixedBlocks, ;
                _OOHG_ActiveControlBeforeColMove, ;
                _OOHG_ActiveControlAfterColMove, ;
                _OOHG_ActiveControlBeforeColSize, ;
                _OOHG_ActiveControlAfterColSize, ;
                _OOHG_ActiveControlBeforeAutoFit, ;
                _OOHG_ActiveControlEditLikeExcel, ;
                _OOHG_ActiveControlUseButtons, ;
                _OOHG_ActiveControlEditLikeExcel, ;
                _OOHG_ActiveControlUseButtons, ;
                _OOHG_ActiveControlUpdateColors )

/*----------------------------------------------------------------------------
XBROWSE
---------------------------------------------------------------------------*/

#xcommand DEFINE XBROWSE <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> )   ;;
        _OOHG_ActiveControlHeaders          := Nil ;;
        _OOHG_ActiveControlWidths           := Nil ;;
        _OOHG_ActiveControlOnHeadClick      := Nil ;;
        _OOHG_ActiveControlNoLines          := .F. ;;
        _OOHG_ActiveControlImage            := Nil ;;
        _OOHG_ActiveControlJustify          := Nil ;;
        _OOHG_ActiveControlEdit             := .F. ;;
        _OOHG_ActiveControlBreak            := .F. ;;
        _OOHG_ActiveControlWorkArea         := Nil ;;
        _OOHG_ActiveControlFields           := Nil ;;
        _OOHG_ActiveControlDelete           := .F. ;;
        _OOHG_ActiveControlAppendable       := .F. ;;
        _OOHG_ActiveControlValid            := Nil ;;
        _OOHG_ActiveControlReadOnly         := Nil ;;
        _OOHG_ActiveControlLock             := .F. ;;
        _OOHG_ActiveControlValidMessages    := Nil ;;
        _OOHG_ActiveControlNoVScroll        := .F. ;;
        _OOHG_ActiveControlInputMask        := Nil ;;
        _OOHG_ActiveControlInPlaceEdit      := .F. ;;
        _OOHG_ActiveControlDynamicBackColor := Nil ;;
        _OOHG_ActiveControlDynamicForeColor := Nil ;;
        _OOHG_ActiveControlWhen             := Nil ;;
        _OOHG_ActiveControlOnAppend         := Nil ;;
        _OOHG_ActiveControlEditCell         := Nil ;;
        _OOHG_ActiveControlEditControls     := Nil ;;
        _OOHG_ActiveControlReplaceFields    := Nil ;;
        _OOHG_ActiveControlShowHeaders      := Nil ;;
        _OOHG_ActiveControlDeleteWhen       := Nil ;;
        _OOHG_ActiveControlDeleteMsg        := Nil ;;
        _OOHG_ActiveControlOnDelete         := Nil ;;
        _OOHG_ActiveControlColumnInfo       := Nil ;;
        _OOHG_ActiveControlDescending       := .F. ;;
        _OOHG_ActiveControlRecCount         := .F. ;;
        _OOHG_ActiveControlHeaderImages     := Nil ;;
        _OOHG_ActiveControlImagesAlign      := Nil ;;
        _OOHG_ActiveControlFullMove         := .F. ;;
        _OOHG_ActiveControlSelectedColors   := .F. ;;
        _OOHG_ActiveControlKeys             := Nil ;
        _OOHG_ActiveControlDblBffer         := .T. ;;
        _OOHG_ActiveControlPaintLeftMargin  := .F. ;;
        _OOHG_ActiveControlFocusRect        := .F. ;;
        _OOHG_ActiveControlNoFocusRect      := .F. ;;
        _OOHG_ActiveControlFixedCols        := .F. ;;
        _OOHG_ActiveControlAbortEdit        := Nil ;;
        _OOHG_ActiveControlAction           := Nil ;;
        _OOHG_ActiveControlFixedWidths      := .F. ;;
        _OOHG_ActiveControlFixedBlocks      := .F. ;;
        _OOHG_ActiveControlBeforeColMove    := Nil ;;
        _OOHG_ActiveControlAfterColMove     := Nil ;;
        _OOHG_ActiveControlBeforeColSize    := Nil ;;
        _OOHG_ActiveControlAfterColSize     := Nil ;;
        _OOHG_ActiveControlBeforeAutoFit    := Nil ;;
        _OOHG_ActiveControlEditLikeExcel    := Nil ;;
        _OOHG_ActiveControlUseButtons       := Nil ;;
        _OOHG_ActiveControlNoDeleteMsg      := .F.

#xcommand END XBROWSE ;
        => ;
        _OOHG_SelectSubClass( TXBrowse(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlHeaders, ;
                _OOHG_ActiveControlWidths, ;
                _OOHG_ActiveControlFields, ;
                _OOHG_ActiveControlWorkArea, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlDelete, ;
                _OOHG_ActiveControlLock, ;
                _OOHG_ActiveControlNoVScroll, ;
                _OOHG_ActiveControlAppendable, ;
                _OOHG_ActiveControlOnAppend, ;
                _OOHG_ActiveControlReplaceFields, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnDblClick, ;
                _OOHG_ActiveControlOnHeadClick, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlNoLines, ;
                _OOHG_ActiveControlImage, ;
                _OOHG_ActiveControlJustify, ;
                _OOHG_ActiveControlBreak, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlEdit, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlDynamicBackColor, ;
                _OOHG_ActiveControlDynamicForeColor, ;
                _OOHG_ActiveControlInputMask, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlInPlaceEdit, ;
                _OOHG_ActiveControlEditControls, ;
                _OOHG_ActiveControlReadOnly, ;
                _OOHG_ActiveControlValid, ;
                _OOHG_ActiveControlValidMessages, ;
                _OOHG_ActiveControlEditCell, ;
                _OOHG_ActiveControlWhen, ;
                _OOHG_ActiveControlRecCount, ;
                _OOHG_ActiveControlColumnInfo, ;
                _OOHG_ActiveControlShowHeaders, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlDescending, ;
                _OOHG_ActiveControlDeleteWhen, ;
                _OOHG_ActiveControlDeleteMsg, ;
                _OOHG_ActiveControlOnDelete, ;
                _OOHG_ActiveControlHeaderImages, ;
                _OOHG_ActiveControlImagesAlign, ;
                _OOHG_ActiveControlFullMove, ;
                _OOHG_ActiveControlSelectedColors, ;
                _OOHG_ActiveControlKeys, ;
                _OOHG_ActiveControlDblBffer, ;
                iif( _OOHG_ActiveControlNoFocusRect, .F., iif( _OOHG_ActiveControlFocusRect, .T., NIL ) ), ;
                _OOHG_ActiveControlPaintLeftMargin, ;
                _OOHG_ActiveControlFixedCols, ;
                _OOHG_ActiveControlAbortEdit, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlFixedWidths, ;
                _OOHG_ActiveControlFixedBlocks, ;
                _OOHG_ActiveControlBeforeColMove, ;
                _OOHG_ActiveControlAfterColMove, ;
                _OOHG_ActiveControlBeforeColSize, ;
                _OOHG_ActiveControlAfterColSize, ;
                _OOHG_ActiveControlBeforeAutoFit, ;
                _OOHG_ActiveControlEditLikeExcel, ;
                _OOHG_ActiveControlUseButtons, ;
                _OOHG_ActiveControlNoDeleteMsg )

/*----------------------------------------------------------------------------
HYPERLINK
---------------------------------------------------------------------------*/

#xcommand DEFINE HYPERLINK <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlAddress     := Nil    ;;
        _OOHG_ActiveControlAutoSize    := .F.    ;;
        _OOHG_ActiveControlBorder      := .F.    ;;
        _OOHG_ActiveControlClientEdge  := .F.    ;;
        _OOHG_ActiveControlHScroll     := .F.    ;;
        _OOHG_ActiveControlVScroll     := .F.    ;;
        _OOHG_ActiveControlTransparent := .F.    ;;
        _OOHG_ActiveControlHandCursor  := .F.

#xcommand ADDRESS <address> ;
        => ;
        _OOHG_ActiveControlAddress := <address>

#xcommand HANDCURSOR <handcursor> ;
        => ;
        _OOHG_ActiveControlHandCursor := <handcursor>

#xcommand END HYPERLINK ;
        => ;
        _OOHG_SelectSubClass( THyperLink(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlAddress, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlBorder, ;
                _OOHG_ActiveControlClientEdge, ;
                _OOHG_ActiveControlHScroll, ;
                _OOHG_ActiveControlVScroll, ;
                _OOHG_ActiveControlTransparent, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlAutosize, ;
                _OOHG_ActiveControlHandCursor, ;
                _OOHG_ActiveControlRtl )

/*----------------------------------------------------------------------------
SPINNER
---------------------------------------------------------------------------*/

#xcommand WRAP <wrap> ;
        => ;
        _OOHG_ActiveControlWrap := <wrap>

#xcommand INCREMENT <increment> ;
        => ;
        _OOHG_ActiveControlIncrement := <increment>

#xcommand DEFINE SPINNER <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRangeLow  := Nil      ;;
        _OOHG_ActiveControlRangeHigh := Nil      ;;
        _OOHG_ActiveControlWrap      := .F.      ;;
        _OOHG_ActiveControlReadOnly  := .F.      ;;
        _OOHG_ActiveControlIncrement := Nil      ;;
        _OOHG_ActiveControlNoBorder  := .F.

#xcommand END SPINNER;
        => ;
        _OOHG_SelectSubClass( TSpinner(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlRangeLow, ;
                _OOHG_ActiveControlRangeHigh, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlWrap, ;
                _OOHG_ActiveControlReadOnly, ;
                _OOHG_ActiveControlIncrement, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlNoBorder )

/*----------------------------------------------------------------------------
ACTIVEX
---------------------------------------------------------------------------*/

#xcommand DEFINE ACTIVEX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> )

#xcommand PROGID <progid> ;
        => ;
        _OOHG_ActiveControlValue := <progid>

#xcommand END ACTIVEX;
        => ;
        _OOHG_SelectSubClass( TActiveX(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlDisabled )

/*----------------------------------------------------------------------------
HOTKEYBOX
---------------------------------------------------------------------------*/

#xcommand DEFINE HOTKEYBOX <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlForceAlt := .T.

#xcommand FORCEALT <forcealt> ;
        => ;
        _OOHG_ActiveControlForceAlt := <forcealt>

#xcommand END HOTKEYBOX;
        => ;
        _OOHG_SelectSubClass( THotKeyBox(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlOnLostFocus, ;
                _OOHG_ActiveControlOnGotFocus, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnEnter, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlDisabled, ;
                .NOT. _OOHG_ActiveControlForceAlt )

/*----------------------------------------------------------------------------
PICTURE
---------------------------------------------------------------------------*/

#xcommand DEFINE PICTURE <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlPicture    := Nil     ;;
        _OOHG_ActiveControlImagesize  := .F.     ;;
        _OOHG_ActiveControlBuffer     := Nil     ;;
        _OOHG_ActiveControlHBitmap    := Nil     ;;
        _OOHG_ActiveControlAction     := Nil     ;;
        _OOHG_ActiveControlClientEdge := .F.     ;;
        _OOHG_ActiveControlImagesize  := .F.     ;;
        _OOHG_ActiveControlBorder     := .F.     ;;
        _OOHG_ActiveControlScale      := .F.     ;;
        _OOHG_ActiveControlStretch    := .F.

#xcommand ICON <icon> ;
        => ;
        _OOHG_ActiveControlPicture := <icon>

#xcommand FORCESCALE <scale> ;
        => ;
        _OOHG_ActiveControlScale := <scale>

#xcommand END PICTURE;
        => ;
        _OOHG_SelectSubClass( TPicture(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlPicture, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlBuffer, ;
                _OOHG_ActiveControlHBitmap, ;
                _OOHG_ActiveControlStretch, ;
                _OOHG_ActiveControlScale, ;
                _OOHG_ActiveControlImagesize, ;
                _OOHG_ActiveControlBorder, ;
                _OOHG_ActiveControlClientEdge, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlInvisible )

/*----------------------------------------------------------------------------
PROGRESSMETER
---------------------------------------------------------------------------*/

#xcommand DEFINE PROGRESSMETER <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRangeLow   := Nil     ;;
        _OOHG_ActiveControlRangeHigh  := Nil     ;;
        _OOHG_ActiveControlForeColor  := Nil     ;;
        _OOHG_ActiveControlAction     := Nil     ;;
        _OOHG_ActiveControlClientEdge := .F.

#xcommand END PROGRESSMETER;
        => ;
        _OOHG_SelectSubClass( TProgressMeter(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlRangeLow, ;
                _OOHG_ActiveControlRangeHigh, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlForeColor, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlClientEdge )

/*----------------------------------------------------------------------------
SCROLLBAR
---------------------------------------------------------------------------*/

#xcommand DEFINE SCROLLBAR <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRangeLow   := Nil     ;;
        _OOHG_ActiveControlRangeHigh  := Nil     ;;
        _OOHG_ActiveControlOnLineUp   := Nil     ;;
        _OOHG_ActiveControlOnLineDown := Nil     ;;
        _OOHG_ActiveControlOnPageUp   := Nil     ;;
        _OOHG_ActiveControlOnPageDown := Nil     ;;
        _OOHG_ActiveControlOnTop      := Nil     ;;
        _OOHG_ActiveControlOnBottom   := Nil     ;;
        _OOHG_ActiveControlOnThumb    := Nil     ;;
        _OOHG_ActiveControlOnTrack    := Nil     ;;
        _OOHG_ActiveControlOnEndTrack := Nil     ;;
        _OOHG_ActiveControlAttached   := Nil     ;;
        _OOHG_ActiveControlLineSkip   := Nil     ;;
        _OOHG_ActiveControlPageSkip   := Nil     ;;
        _OOHG_ActiveControlAutoMove   := Nil     ;;
        _OOHG_ActiveControlVertical   := .F.     ;;
        _OOHG_ActiveControlHorizontal := .F.

#xcommand ON LINEUP <lineup> ;
        => ;
        _OOHG_ActiveControlOnLineUp := <{lineup}>

#xcommand ON LINELEFT <lineup> ;
        => ;
        _OOHG_ActiveControlOnLineUp := <{lineup}>

#xcommand ON LINEDOWN <linedown> ;
        => ;
        _OOHG_ActiveControlOnLineDown := <{linedown}>

#xcommand ON LINERIGHT <linedown> ;
        => ;
        _OOHG_ActiveControlOnLineDown := <{linedown}>

#xcommand ON PAGEUP <pageup> ;
        => ;
        _OOHG_ActiveControlOnPageUp := <{pageup}>

#xcommand ON PAGELEFT <pageup> ;
        => ;
        _OOHG_ActiveControlOnPageUp := <{pageup}>

#xcommand ON PAGEDOWN <pagedown> ;
        => ;
        _OOHG_ActiveControlOnPageDown := <{pagedown}>

#xcommand ON PAGERIGHT <pagedown> ;
        => ;
        _OOHG_ActiveControlOnPageDown := <{pagedown}>

#xcommand ON TOP <top> ;
        => ;
        _OOHG_ActiveControlOnTop := <{top}>

#xcommand ON LEFT <top> ;
        => ;
        _OOHG_ActiveControlOnTop := <{top}>

#xcommand ON BOTTOM <bottom> ;
        => ;
        _OOHG_ActiveControlOnBottom := <{bottom}>

#xcommand ON THUMB <thumb> ;
        => ;
        _OOHG_ActiveControlOnThumb := <{thumb}>

#xcommand ON TRACK <track> ;
        => ;
        _OOHG_ActiveControlOnTrack := <{track}>

#xcommand ON ENDTRACK <endtrack> ;
        => ;
        _OOHG_ActiveControlOnEndTrack := <{endtrack}>

#xcommand ATTACHED <attached> ;
        => ;
        _OOHG_ActiveControlAttached := <attached>

#xcommand LINESKIP <lineskip> ;
        => ;
        _OOHG_ActiveControlLineSkip := <lineskip>

#xcommand PAGESKIP <pageskip> ;
        => ;
        _OOHG_ActiveControlPageSkip := <pageskip>

#xcommand AUTOMOVE <auto> ;
        => ;
        _OOHG_ActiveControlAutoMove := <auto>

#xcommand END SCROLLBAR;
        => ;
        _OOHG_SelectSubClass( TScrollBar(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlRangeLow, ;
                _OOHG_ActiveControlRangeHigh, ;
                _OOHG_ActiveControlOnChange, ;
                _OOHG_ActiveControlOnLineUp, ;
                _OOHG_ActiveControlOnLineDown, ;
                _OOHG_ActiveControlOnPageUp, ;
                _OOHG_ActiveControlOnPageDown, ;
                _OOHG_ActiveControlOnTop, ;
                _OOHG_ActiveControlOnBottom, ;
                _OOHG_ActiveControlOnThumb, ;
                _OOHG_ActiveControlOnTrack, ;
                _OOHG_ActiveControlOnEndTrack, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlRtl, ;
                iif( _OOHG_ActiveControlHorizontal, 0, iif( _OOHG_ActiveControlVertical, 1, nil ) ), ;
                _OOHG_ActiveControlAttached, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlDisabled, ;
                _OOHG_ActiveControlLineSkip, ;
                _OOHG_ActiveControlPageSkip, ;
                _OOHG_ActiveControlAutoMove )

/*----------------------------------------------------------------------------
TEXTARRAY
---------------------------------------------------------------------------*/

#xcommand DEFINE TEXTARRAY <name> ;
        => ;
        _OOHG_ClearActiveControlInfo( <(name)> ) ;;
        _OOHG_ActiveControlRowCount   := Nil     ;;
        _OOHG_ActiveControlColCount   := Nil     ;;
        _OOHG_ActiveControlBorder     := .F.     ;;
        _OOHG_ActiveControlClientEdge := .F.     ;;
        _OOHG_ActiveControlAction     := Nil

#xcommand ROWCOUNT <rowcount> ;
        => ;
        _OOHG_ActiveControlRowCount := <rowcount>

#xcommand COLCOUNT <colcount> ;
        => ;
        _OOHG_ActiveControlColCount := <colcount>

#xcommand END TEXTARRAY;
        => ;
        _OOHG_SelectSubClass( TTextArray(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
                _OOHG_ActiveControlName, ;
                _OOHG_ActiveControlOf, ;
                _OOHG_ActiveControlCol, ;
                _OOHG_ActiveControlRow, ;
                _OOHG_ActiveControlWidth, ;
                _OOHG_ActiveControlHeight, ;
                _OOHG_ActiveControlRowCount, ;
                _OOHG_ActiveControlColCount, ;
                _OOHG_ActiveControlBorder, ;
                _OOHG_ActiveControlClientEdge, ;
                _OOHG_ActiveControlFontColor, ;
                _OOHG_ActiveControlBackColor, ;
                _OOHG_ActiveControlAction, ;
                _OOHG_ActiveControlFont, ;
                _OOHG_ActiveControlSize, ;
                _OOHG_ActiveControlFontBold, ;
                _OOHG_ActiveControlFontItalic, ;
                _OOHG_ActiveControlFontUnderLine, ;
                _OOHG_ActiveControlFontStrikeOut, ;
                _OOHG_ActiveControlTooltip, ;
                _OOHG_ActiveControlHelpId, ;
                _OOHG_ActiveControlInvisible, ;
                _OOHG_ActiveControlRtl, ;
                _OOHG_ActiveControlValue, ;
                _OOHG_ActiveControlNoTabStop, ;
                _OOHG_ActiveControlDisabled )
