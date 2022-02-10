/*
 * $Id: i_altsyntax.ch $
 */
/*
 * ooHG source code:
 * Alternate syntax definitions
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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


/*---------------------------------------------------------------------------
AUXILIARY VARIABLES
---------------------------------------------------------------------------*/

#xtranslate _OOHG_ActiveControlName                   => _OOHG_ActiveControlInfo \( \) \[   1 \]
#xtranslate _OOHG_ActiveControlOf                     => _OOHG_ActiveControlInfo \( \) \[   2 \]
#xtranslate _OOHG_ActiveControlRow                    => _OOHG_ActiveControlInfo \( \) \[   3 \]
#xtranslate _OOHG_ActiveControlCol                    => _OOHG_ActiveControlInfo \( \) \[   4 \]
#xtranslate _OOHG_ActiveControlWidth                  => _OOHG_ActiveControlInfo \( \) \[   5 \]
#xtranslate _OOHG_ActiveControlHeight                 => _OOHG_ActiveControlInfo \( \) \[   6 \]
#xtranslate _OOHG_ActiveControlFont                   => _OOHG_ActiveControlInfo \( \) \[   7 \]
#xtranslate _OOHG_ActiveControlSize                   => _OOHG_ActiveControlInfo \( \) \[   8 \]
#xtranslate _OOHG_ActiveControlFontBold               => _OOHG_ActiveControlInfo \( \) \[   9 \]
#xtranslate _OOHG_ActiveControlFontItalic             => _OOHG_ActiveControlInfo \( \) \[  10 \]
#xtranslate _OOHG_ActiveControlFontStrikeOut          => _OOHG_ActiveControlInfo \( \) \[  11 \]
#xtranslate _OOHG_ActiveControlFontUnderLine          => _OOHG_ActiveControlInfo \( \) \[  12 \]
#xtranslate _OOHG_ActiveControlFontColor              => _OOHG_ActiveControlInfo \( \) \[  13 \]
#xtranslate _OOHG_ActiveControlBackColor              => _OOHG_ActiveControlInfo \( \) \[  14 \]
#xtranslate _OOHG_ActiveControlRtl                    => _OOHG_ActiveControlInfo \( \) \[  15 \]
#xtranslate _OOHG_ActiveControlValue                  => _OOHG_ActiveControlInfo \( \) \[  16 \]
#xtranslate _OOHG_ActiveControlTooltip                => _OOHG_ActiveControlInfo \( \) \[  17 \]
#xtranslate _OOHG_ActiveControlNoTabStop              => _OOHG_ActiveControlInfo \( \) \[  18 \]
#xtranslate _OOHG_ActiveControlInvisible              => _OOHG_ActiveControlInfo \( \) \[  19 \]
#xtranslate _OOHG_ActiveControlHelpId                 => _OOHG_ActiveControlInfo \( \) \[  20 \]
#xtranslate _OOHG_ActiveControlDisabled               => _OOHG_ActiveControlInfo \( \) \[  21 \]
#xtranslate _OOHG_ActiveControlOnLostFocus            => _OOHG_ActiveControlInfo \( \) \[  22 \]
#xtranslate _OOHG_ActiveControlOnGotFocus             => _OOHG_ActiveControlInfo \( \) \[  23 \]
#xtranslate _OOHG_ActiveControlOnChange               => _OOHG_ActiveControlInfo \( \) \[  24 \]
#xtranslate _OOHG_ActiveControlOnEnter                => _OOHG_ActiveControlInfo \( \) \[  25 \]
#xtranslate _OOHG_ActiveControlAssignObject           => _OOHG_ActiveControlInfo \( \) \[  26 \]
#xtranslate _OOHG_ActiveControlSubClass               => _OOHG_ActiveControlInfo \( \) \[  27 \]

#xtranslate _OOHG_ActiveControlCueBanner              => _OOHG_ActiveControlInfo \( \) \[  55 \]
#xtranslate _OOHG_ActiveControlNewAtRow               => _OOHG_ActiveControlInfo \( \) \[  56 \]
#xtranslate _OOHG_ActiveControlTimeOut                => _OOHG_ActiveControlInfo \( \) \[  57 \]
#xtranslate _OOHG_ActiveControlHeaderColors           => _OOHG_ActiveControlInfo \( \) \[  58 \]
#xtranslate _OOHG_ActiveControlValueIs                => _OOHG_ActiveControlInfo \( \) \[  59 \]
#xtranslate _OOHG_ActiveControlNoClone                => _OOHG_ActiveControlInfo \( \) \[  60 \]
#xtranslate _OOHG_ActiveControlOnBeforeInsert         => _OOHG_ActiveControlInfo \( \) \[  61 \]
#xtranslate _OOHG_ActiveControlOnHeadDblClick         => _OOHG_ActiveControlInfo \( \) \[  62 \]
#xtranslate _OOHG_ActiveControlContextMenu            => _OOHG_ActiveControlInfo \( \) \[  63 \]
#xtranslate _OOHG_ActiveControlActionTT               => _OOHG_ActiveControlInfo \( \) \[  64 \]
#xtranslate _OOHG_ActiveControlAction2TT              => _OOHG_ActiveControlInfo \( \) \[  65 \]
#xtranslate _OOHG_ActiveControlFileType               => _OOHG_ActiveControlInfo \( \) \[  66 \]
#xtranslate _OOHG_ActiveControlVersion                => _OOHG_ActiveControlInfo \( \) \[  67 \]
#xtranslate _OOHG_ActiveControlNoDestroy              => _OOHG_ActiveControlInfo \( \) \[  68 \]
#xtranslate _OOHG_ActiveControlRefresh                => _OOHG_ActiveControlInfo \( \) \[  69 \]
#xtranslate _OOHG_ActiveControlNoImagelist            => _OOHG_ActiveControlInfo \( \) \[  70 \]
#xtranslate _OOHG_ActiveControlNoPrintOver            => _OOHG_ActiveControlInfo \( \) \[  71 \]
#xtranslate _OOHG_ActiveControlTextAlignH             => _OOHG_ActiveControlInfo \( \) \[  72 \]
#xtranslate _OOHG_ActiveControlTextAlignV             => _OOHG_ActiveControlInfo \( \) \[  73 \]
#xtranslate _OOHG_ActiveControlTextMargin             => _OOHG_ActiveControlInfo \( \) \[  74 \]
#xtranslate _OOHG_ActiveControlFitTxt                 => _OOHG_ActiveControlInfo \( \) \[  75 \]
#xtranslate _OOHG_ActiveControlFitImg                 => _OOHG_ActiveControlInfo \( \) \[  76 \]
#xtranslate _OOHG_ActiveControlEditHeight             => _OOHG_ActiveControlInfo \( \) \[  77 \]
#xtranslate _OOHG_ActiveControlOptionsHeight          => _OOHG_ActiveControlInfo \( \) \[  78 \]
#xtranslate _OOHG_ActiveControlSolid                  => _OOHG_ActiveControlInfo \( \) \[  79 \]
#xtranslate _OOHG_ActiveControlMultiTab               => _OOHG_ActiveControlInfo \( \) \[  80 \]
#xtranslate _OOHG_ActiveControlShowHeaders            => _OOHG_ActiveControlInfo \( \) \[  81 \]
#xtranslate _OOHG_ActiveControlTitleFontColor         => _OOHG_ActiveControlInfo \( \) \[  82 \]
#xtranslate _OOHG_ActiveControlTitleBackColor         => _OOHG_ActiveControlInfo \( \) \[  83 \]
#xtranslate _OOHG_ActiveControlTrailingFontColor      => _OOHG_ActiveControlInfo \( \) \[  84 \]
#xtranslate _OOHG_ActiveControlBackgroundColor        => _OOHG_ActiveControlInfo \( \) \[  85 \]
#xtranslate _OOHG_ActiveControlBackground             => _OOHG_ActiveControlInfo \( \) \[  86 \]
#xtranslate _OOHG_ActiveControlBeforeEditCell         => _OOHG_ActiveControlInfo \( \) \[  87 \]
#xtranslate _OOHG_ActiveControlEditCellEnd            => _OOHG_ActiveControlInfo \( \) \[  88 \]
#xtranslate _OOHG_ActiveControlOnInsert               => _OOHG_ActiveControlInfo \( \) \[  89 \]
#xtranslate _OOHG_ActiveControlOnRClick               => _OOHG_ActiveControlInfo \( \) \[  90 \]
#xtranslate _OOHG_ActiveControlExtDblClick            => _OOHG_ActiveControlInfo \( \) \[  91 \]
#xtranslate _OOHG_ActiveControlExcludeArea            => _OOHG_ActiveControlInfo \( \) \[  92 \]
#xtranslate _OOHG_ActiveControlNoLoadTransparent      => _OOHG_ActiveControlInfo \( \) \[  93 \]
#xtranslate _OOHG_ActiveControlSearchLapse            => _OOHG_ActiveControlInfo \( \) \[  94 \]
#xtranslate _OOHG_ActiveControlInsertType             => _OOHG_ActiveControlInfo \( \) \[  95 \]
#xtranslate _OOHG_ActiveControlRClickOnCheckbox       => _OOHG_ActiveControlInfo \( \) \[  96 \]
#xtranslate _OOHG_ActiveControlClickOnCheckbox        => _OOHG_ActiveControlInfo \( \) \[  97 \]
#xtranslate _OOHG_ActiveControlOnHeaderRClick         => _OOHG_ActiveControlInfo \( \) \[  98 \]
#xtranslate _OOHG_ActiveControlNoShowEmptyRow         => _OOHG_ActiveControlInfo \( \) \[  99 \]
#xtranslate _OOHG_ActiveControlNoDIBSection           => _OOHG_ActiveControlInfo \( \) \[ 100 \]
#xtranslate _OOHG_ActiveControlUnSynchronized         => _OOHG_ActiveControlInfo \( \) \[ 101 \]
#xtranslate _OOHG_ActiveControlFixedCtrls             => _OOHG_ActiveControlInfo \( \) \[ 102 \]
#xtranslate _OOHG_ActiveControlDynamicCtrls           => _OOHG_ActiveControlInfo \( \) \[ 103 \]
#xtranslate _OOHG_ActiveControlDynamicBlocks          => _OOHG_ActiveControlInfo \( \) \[ 104 \]
#xtranslate _OOHG_ActiveControlSngBffer               => _OOHG_ActiveControlInfo \( \) \[ 105 \]
#xtranslate _OOHG_ActiveControlOnRefresh              => _OOHG_ActiveControlInfo \( \) \[ 106 \]
#xtranslate _OOHG_ActiveControlSourceOrder            => _OOHG_ActiveControlInfo \( \) \[ 107 \]
#xtranslate _OOHG_ActiveControlNoModalEdit            => _OOHG_ActiveControlInfo \( \) \[ 108 \]
#xtranslate _OOHG_ActiveControlUpdateColors           => _OOHG_ActiveControlInfo \( \) \[ 109 \]
#xtranslate _OOHG_ActiveControlEditLikeExcel          => _OOHG_ActiveControlInfo \( \) \[ 110 \]
#xtranslate _OOHG_ActiveControlUseButtons             => _OOHG_ActiveControlInfo \( \) \[ 111 \]
#xtranslate _OOHG_ActiveControlBeforeAutoFit          => _OOHG_ActiveControlInfo \( \) \[ 112 \]
#xtranslate _OOHG_ActiveControlAfterColSize           => _OOHG_ActiveControlInfo \( \) \[ 113 \]
#xtranslate _OOHG_ActiveControlBeforeColSize          => _OOHG_ActiveControlInfo \( \) \[ 114 \]
#xtranslate _OOHG_ActiveControlAfterColMove           => _OOHG_ActiveControlInfo \( \) \[ 115 \]
#xtranslate _OOHG_ActiveControlBeforeColMove          => _OOHG_ActiveControlInfo \( \) \[ 116 \]
#xtranslate _OOHG_ActiveControlFixedBlocks            => _OOHG_ActiveControlInfo \( \) \[ 117 \]
#xtranslate _OOHG_ActiveControlOnTextFilled           => _OOHG_ActiveControlInfo \( \) \[ 118 \]
#xtranslate _OOHG_ActiveControlDelayedLoad            => _OOHG_ActiveControlInfo \( \) \[ 119 \]
#xtranslate _OOHG_ActiveControlIncrementalSearch      => _OOHG_ActiveControlInfo \( \) \[ 120 \]
#xtranslate _OOHG_ActiveControlIntegralHeight         => _OOHG_ActiveControlInfo \( \) \[ 121 \]
#xtranslate _OOHG_ActiveControlAutoFit                => _OOHG_ActiveControlInfo \( \) \[ 122 \]
#xtranslate _OOHG_ActiveControlNo3DColors             => _OOHG_ActiveControlInfo \( \) \[ 123 \]
#xtranslate _OOHG_ActiveControlDefaultYear            => _OOHG_ActiveControlInfo \( \) \[ 124 \]
#xtranslate _OOHG_ActiveControlNoHideSel              => _OOHG_ActiveControlInfo \( \) \[ 125 \]
#xtranslate _OOHG_ActiveControlOnSelChange            => _OOHG_ActiveControlInfo \( \) \[ 126 \]
#xtranslate _OOHG_ActiveControlOnListDisplay          => _OOHG_ActiveControlInfo \( \) \[ 127 \]
#xtranslate _OOHG_ActiveControlOnListClose            => _OOHG_ActiveControlInfo \( \) \[ 128 \]
#xtranslate _OOHG_ActiveControlNoCheckDepth           => _OOHG_ActiveControlInfo \( \) \[ 129 \]
#xtranslate _OOHG_ActiveControlNoRedrawParent         => _OOHG_ActiveControlInfo \( \) \[ 130 \]
#xtranslate _OOHG_ActiveControlFixedWidths            => _OOHG_ActiveControlInfo \( \) \[ 131 \]
#xtranslate _OOHG_ActiveControlAbortEdit              => _OOHG_ActiveControlInfo \( \) \[ 132 \]
#xtranslate _OOHG_ActiveControlUpdateAll              => _OOHG_ActiveControlInfo \( \) \[ 133 \]
#xtranslate _OOHG_ActiveControlNoDeleteMsg            => _OOHG_ActiveControlInfo \( \) \[ 134 \]
#xtranslate _OOHG_ActiveControlFixedCols              => _OOHG_ActiveControlInfo \( \) \[ 135 \]
#xtranslate _OOHG_ActiveControlSynchronized           => _OOHG_ActiveControlInfo \( \) \[ 136 \]
#xtranslate _OOHG_ActiveControlPaintLeftMargin        => _OOHG_ActiveControlInfo \( \) \[ 137 \]
#xtranslate _OOHG_ActiveControlNoFocusRect            => _OOHG_ActiveControlInfo \( \) \[ 138 \]
#xtranslate _OOHG_ActiveControlFocusRect              => _OOHG_ActiveControlInfo \( \) \[ 139 \]
#xtranslate _OOHG_ActiveControlDblBffer               => _OOHG_ActiveControlInfo \( \) \[ 140 \]
#xtranslate _OOHG_ActiveControlOnCheckChange          => _OOHG_ActiveControlInfo \( \) \[ 141 \]
#xtranslate _OOHG_ActiveControlForceRefresh           => _OOHG_ActiveControlInfo \( \) \[ 142 \]
#xtranslate _OOHG_ActiveControlNoRefresh              => _OOHG_ActiveControlInfo \( \) \[ 143 \]
#xtranslate _OOHG_ActiveControlCheckBoxes             => _OOHG_ActiveControlInfo \( \) \[ 144 \]
#xtranslate _OOHG_ActiveControlKeys                   => _OOHG_ActiveControlInfo \( \) \[ 145 \]
#xtranslate _OOHG_ActiveControlSelectedColors         => _OOHG_ActiveControlInfo \( \) \[ 146 \]
#xtranslate _OOHG_ActiveControlByCell                 => _OOHG_ActiveControlInfo \( \) \[ 147 \]
#xtranslate _OOHG_ActiveControlItemImageNumber        => _OOHG_ActiveControlInfo \( \) \[ 148 \]
#xtranslate _OOHG_ActiveControlImageSource            => _OOHG_ActiveControlInfo \( \) \[ 149 \]
#xtranslate _OOHG_ActiveControlOnMouseMove            => _OOHG_ActiveControlInfo \( \) \[ 150 \]
#xtranslate _OOHG_ActiveControlImageMargin            => _OOHG_ActiveControlInfo \( \) \[ 151 \]
#xtranslate _OOHG_ActiveControlDrawBy                 => _OOHG_ActiveControlInfo \( \) \[ 152 \]
#xtranslate _OOHG_ActiveControlListWidth              => _OOHG_ActiveControlInfo \( \) \[ 153 \]
#xtranslate _OOHG_ActiveControl3State                 => _OOHG_ActiveControlInfo \( \) \[ 154 \]
#xtranslate _OOHG_ActiveControlMultiLine              => _OOHG_ActiveControlInfo \( \) \[ 155 \]
#xtranslate _OOHG_ActiveControlFullMove               => _OOHG_ActiveControlInfo \( \) \[ 156 \]
#xtranslate _OOHG_ActiveControlRowCount               => _OOHG_ActiveControlInfo \( \) \[ 157 \]
#xtranslate _OOHG_ActiveControlColCount               => _OOHG_ActiveControlInfo \( \) \[ 158 \]
#xtranslate _OOHG_ActiveControlOnLineUp               => _OOHG_ActiveControlInfo \( \) \[ 159 \]
#xtranslate _OOHG_ActiveControlOnLineDown             => _OOHG_ActiveControlInfo \( \) \[ 160 \]
#xtranslate _OOHG_ActiveControlOnPageUp               => _OOHG_ActiveControlInfo \( \) \[ 161 \]
#xtranslate _OOHG_ActiveControlOnPageDown             => _OOHG_ActiveControlInfo \( \) \[ 162 \]
#xtranslate _OOHG_ActiveControlOnTop                  => _OOHG_ActiveControlInfo \( \) \[ 163 \]
#xtranslate _OOHG_ActiveControlOnBottom               => _OOHG_ActiveControlInfo \( \) \[ 164 \]
#xtranslate _OOHG_ActiveControlOnThumb                => _OOHG_ActiveControlInfo \( \) \[ 165 \]
#xtranslate _OOHG_ActiveControlOnTrack                => _OOHG_ActiveControlInfo \( \) \[ 166 \]
#xtranslate _OOHG_ActiveControlOnEndTrack             => _OOHG_ActiveControlInfo \( \) \[ 167 \]
#xtranslate _OOHG_ActiveControlAttached               => _OOHG_ActiveControlInfo \( \) \[ 168 \]
#xtranslate _OOHG_ActiveControlLineSkip               => _OOHG_ActiveControlInfo \( \) \[ 169 \]
#xtranslate _OOHG_ActiveControlPageSkip               => _OOHG_ActiveControlInfo \( \) \[ 170 \]
#xtranslate _OOHG_ActiveControlAutoMove               => _OOHG_ActiveControlInfo \( \) \[ 171 \]
#xtranslate _OOHG_ActiveControlForceAlt               => _OOHG_ActiveControlInfo \( \) \[ 172 \]
#xtranslate _OOHG_ActiveControlFirstItem              => _OOHG_ActiveControlInfo \( \) \[ 173 \]
#xtranslate _OOHG_ActiveControlButtonWidth            => _OOHG_ActiveControlInfo \( \) \[ 174 \]
#xtranslate _OOHG_ActiveControlAction2                => _OOHG_ActiveControlInfo \( \) \[ 175 \]
#xtranslate _OOHG_ActiveControlSpeed                  => _OOHG_ActiveControlInfo \( \) \[ 176 \]
#xtranslate _OOHG_ActiveControlTextHeight             => _OOHG_ActiveControlInfo \( \) \[ 177 \]
#xtranslate _OOHG_ActiveControlImagesize              => _OOHG_ActiveControlInfo \( \) \[ 178 \]
#xtranslate _OOHG_ActiveControlWhiteBackground        => _OOHG_ActiveControlInfo \( \) \[ 179 \]
#xtranslate _OOHG_ActiveControlNoResize               => _OOHG_ActiveControlInfo \( \) \[ 180 \]
#xtranslate _OOHG_ActiveControlBuffer                 => _OOHG_ActiveControlInfo \( \) \[ 181 \]
#xtranslate _OOHG_ActiveControlHBitmap                => _OOHG_ActiveControlInfo \( \) \[ 182 \]
#xtranslate _OOHG_ActiveControlCtrlsAtLeft            => _OOHG_ActiveControlInfo \( \) \[ 183 \]
#xtranslate _OOHG_ActiveControlCancel                 => _OOHG_ActiveControlInfo \( \) \[ 184 \]
#xtranslate _OOHG_ActiveControlAlignment              => _OOHG_ActiveControlInfo \( \) \[ 185 \]
#xtranslate _OOHG_ActiveControlHeaderImages           => _OOHG_ActiveControlInfo \( \) \[ 186 \]
#xtranslate _OOHG_ActiveControlImagesAlign            => _OOHG_ActiveControlInfo \( \) \[ 187 \]
#xtranslate _OOHG_ActiveControlColumnInfo             => _OOHG_ActiveControlInfo \( \) \[ 188 \]
#xtranslate _OOHG_ActiveControlDescending             => _OOHG_ActiveControlInfo \( \) \[ 189 \]
#xtranslate _OOHG_ActiveControlShowAll                => _OOHG_ActiveControlInfo \( \) \[ 190 \]
#xtranslate _OOHG_ActiveControlShowMode               => _OOHG_ActiveControlInfo \( \) \[ 191 \]
#xtranslate _OOHG_ActiveControlShowName               => _OOHG_ActiveControlInfo \( \) \[ 192 \]
#xtranslate _OOHG_ActiveControlShowPosition           => _OOHG_ActiveControlInfo \( \) \[ 193 \]
#xtranslate _OOHG_ActiveControlFormat                 => _OOHG_ActiveControlInfo \( \) \[ 194 \]
#xtranslate _OOHG_ActiveControlField                  => _OOHG_ActiveControlInfo \( \) \[ 195 \]
#xtranslate _OOHG_ActiveControlOnAppend               => _OOHG_ActiveControlInfo \( \) \[ 196 \]
#xtranslate _OOHG_ActiveControlDeleteWhen             => _OOHG_ActiveControlInfo \( \) \[ 197 \]
#xtranslate _OOHG_ActiveControlDeleteMsg              => _OOHG_ActiveControlInfo \( \) \[ 198 \]
#xtranslate _OOHG_ActiveControlOnDelete               => _OOHG_ActiveControlInfo \( \) \[ 199 \]
#xtranslate _OOHG_ActiveControlRecCount               => _OOHG_ActiveControlInfo \( \) \[ 200 \]
#xtranslate _OOHG_ActiveControlEditControls           => _OOHG_ActiveControlInfo \( \) \[ 201 \]
#xtranslate _OOHG_ActiveControlWhen                   => _OOHG_ActiveControlInfo \( \) \[ 202 \]
#xtranslate _OOHG_ActiveControlReplaceFields          => _OOHG_ActiveControlInfo \( \) \[ 203 \]
#xtranslate _OOHG_ActiveControlDynamicForeColor       => _OOHG_ActiveControlInfo \( \) \[ 204 \]
#xtranslate _OOHG_ActiveControlDynamicBackColor       => _OOHG_ActiveControlInfo \( \) \[ 205 \]
#xtranslate _OOHG_ActiveControlEditCell               => _OOHG_ActiveControlInfo \( \) \[ 206 \]
#xtranslate _OOHG_ActiveControlHandCursor             => _OOHG_ActiveControlInfo \( \) \[ 207 \]
#xtranslate _OOHG_ActiveControlCenter                 => _OOHG_ActiveControlInfo \( \) \[ 208 \]
#xtranslate _OOHG_ActiveControlNoHScroll              => _OOHG_ActiveControlInfo \( \) \[ 209 \]
#xtranslate _OOHG_ActiveControlGripperText            => _OOHG_ActiveControlInfo \( \) \[ 210 \]
#xtranslate _OOHG_ActiveControlDisplayEdit            => _OOHG_ActiveControlInfo \( \) \[ 211 \]
#xtranslate _OOHG_ActiveControlDisplayChange          => _OOHG_ActiveControlInfo \( \) \[ 212 \]
#xtranslate _OOHG_ActiveControlNoVScroll              => _OOHG_ActiveControlInfo \( \) \[ 213 \]
#xtranslate _OOHG_ActiveControlForeColor              => _OOHG_ActiveControlInfo \( \) \[ 214 \]
#xtranslate _OOHG_ActiveControlDateType               => _OOHG_ActiveControlInfo \( \) \[ 215 \]
#xtranslate _OOHG_ActiveControlInPlaceEdit            => _OOHG_ActiveControlInfo \( \) \[ 216 \]
#xtranslate _OOHG_ActiveControlItemSource             => _OOHG_ActiveControlInfo \( \) \[ 217 \]
#xtranslate _OOHG_ActiveControlValueSource            => _OOHG_ActiveControlInfo \( \) \[ 218 \]
#xtranslate _OOHG_ActiveControlWrap                   => _OOHG_ActiveControlInfo \( \) \[ 219 \]
#xtranslate _OOHG_ActiveControlIncrement              => _OOHG_ActiveControlInfo \( \) \[ 220 \]
#xtranslate _OOHG_ActiveControlAddress                => _OOHG_ActiveControlInfo \( \) \[ 221 \]
#xtranslate _OOHG_ActiveControlItemCount              => _OOHG_ActiveControlInfo \( \) \[ 222 \]
#xtranslate _OOHG_ActiveControlOnQueryData            => _OOHG_ActiveControlInfo \( \) \[ 223 \]
#xtranslate _OOHG_ActiveControlAutoSize               => _OOHG_ActiveControlInfo \( \) \[ 224 \]
#xtranslate _OOHG_ActiveControlVirtual                => _OOHG_ActiveControlInfo \( \) \[ 225 \]
#xtranslate _OOHG_ActiveControlStretch                => _OOHG_ActiveControlInfo \( \) \[ 226 \]
#xtranslate _OOHG_ActiveControlCaption                => _OOHG_ActiveControlInfo \( \) \[ 227 \]
#xtranslate _OOHG_ActiveControlAction                 => _OOHG_ActiveControlInfo \( \) \[ 228 \]
#xtranslate _OOHG_ActiveControlFlat                   => _OOHG_ActiveControlInfo \( \) \[ 229 \]
#xtranslate _OOHG_ActiveControlOnRDblClick            => _OOHG_ActiveControlInfo \( \) \[ 230 \]
#xtranslate _OOHG_ActiveControlOnMDblClick            => _OOHG_ActiveControlInfo \( \) \[ 231 \]
#xtranslate _OOHG_ActiveControlPicture                => _OOHG_ActiveControlInfo \( \) \[ 232 \]
#xtranslate _OOHG_ActiveControlEditCellValue          => _OOHG_ActiveControlInfo \( \) \[ 233 \]
#xtranslate _OOHG_ActiveControlItems                  => _OOHG_ActiveControlInfo \( \) \[ 234 \]
#xtranslate _OOHG_ActiveControlKeysLikeClipper        => _OOHG_ActiveControlInfo \( \) \[ 235 \]
#xtranslate _OOHG_ActiveControlShowNone               => _OOHG_ActiveControlInfo \( \) \[ 236 \]
#xtranslate _OOHG_ActiveControlUpDown                 => _OOHG_ActiveControlInfo \( \) \[ 237 \]
#xtranslate _OOHG_ActiveControlRight                  => _OOHG_ActiveControlInfo \( \) \[ 238 \]
#xtranslate _OOHG_ActiveControlReadOnly               => _OOHG_ActiveControlInfo \( \) \[ 239 \]
#xtranslate _OOHG_ActiveControlMaxLength              => _OOHG_ActiveControlInfo \( \) \[ 240 \]
#xtranslate _OOHG_ActiveControlBreak                  => _OOHG_ActiveControlInfo \( \) \[ 241 \]
#xtranslate _OOHG_ActiveControlOpaque                 => _OOHG_ActiveControlInfo \( \) \[ 242 \]
#xtranslate _OOHG_ActiveControlHeaders                => _OOHG_ActiveControlInfo \( \) \[ 243 \]
#xtranslate _OOHG_ActiveControlWidths                 => _OOHG_ActiveControlInfo \( \) \[ 244 \]
#xtranslate _OOHG_ActiveControlOnDblClick             => _OOHG_ActiveControlInfo \( \) \[ 245 \]
#xtranslate _OOHG_ActiveControlOnMClick               => _OOHG_ActiveControlInfo \( \) \[ 246 \]
#xtranslate _OOHG_ActiveControlCellToolTip            => _OOHG_ActiveControlInfo \( \) \[ 247 \]
#xtranslate _OOHG_ActiveControlOnHeadClick            => _OOHG_ActiveControlInfo \( \) \[ 248 \]
#xtranslate _OOHG_ActiveControlNoLines                => _OOHG_ActiveControlInfo \( \) \[ 249 \]
#xtranslate _OOHG_ActiveControlImage                  => _OOHG_ActiveControlInfo \( \) \[ 250 \]
#xtranslate _OOHG_ActiveControlJustify                => _OOHG_ActiveControlInfo \( \) \[ 251 \]
#xtranslate _OOHG_ActiveControlNoToday                => _OOHG_ActiveControlInfo \( \) \[ 252 \]
#xtranslate _OOHG_ActiveControlNoTodayCircle          => _OOHG_ActiveControlInfo \( \) \[ 253 \]
#xtranslate _OOHG_ActiveControlWeekNumbers            => _OOHG_ActiveControlInfo \( \) \[ 254 \]
#xtranslate _OOHG_ActiveControlMultiSelect            => _OOHG_ActiveControlInfo \( \) \[ 255 \]
#xtranslate _OOHG_ActiveControlEdit                   => _OOHG_ActiveControlInfo \( \) \[ 256 \]
#xtranslate _OOHG_ActiveControlBorder                 => _OOHG_ActiveControlInfo \( \) \[ 257 \]
#xtranslate _OOHG_ActiveControlNoBorder               => _OOHG_ActiveControlInfo \( \) \[ 258 \]
#xtranslate _OOHG_ActiveControlFocusedPos             => _OOHG_ActiveControlInfo \( \) \[ 259 \]
#xtranslate _OOHG_ActiveControlClientEdge             => _OOHG_ActiveControlInfo \( \) \[ 260 \]
#xtranslate _OOHG_ActiveControlHScroll                => _OOHG_ActiveControlInfo \( \) \[ 261 \]
#xtranslate _OOHG_ActiveControlVscroll                => _OOHG_ActiveControlInfo \( \) \[ 262 \]
#xtranslate _OOHG_ActiveControlTransparent            => _OOHG_ActiveControlInfo \( \) \[ 263 \]
#xtranslate _OOHG_ActiveControlNoWordWrap             => _OOHG_ActiveControlInfo \( \) \[ 264 \]
#xtranslate _OOHG_ActiveControlNoPrefix               => _OOHG_ActiveControlInfo \( \) \[ 265 \]
#xtranslate _OOHG_ActiveControlSort                   => _OOHG_ActiveControlInfo \( \) \[ 266 \]
#xtranslate _OOHG_ActiveControlRangeLow               => _OOHG_ActiveControlInfo \( \) \[ 267 \]
#xtranslate _OOHG_ActiveControlRangeHigh              => _OOHG_ActiveControlInfo \( \) \[ 268 \]
#xtranslate _OOHG_ActiveControlVertical               => _OOHG_ActiveControlInfo \( \) \[ 269 \]
#xtranslate _OOHG_ActiveControlSmooth                 => _OOHG_ActiveControlInfo \( \) \[ 270 \]
#xtranslate _OOHG_ActiveControlOptions                => _OOHG_ActiveControlInfo \( \) \[ 271 \]
#xtranslate _OOHG_ActiveControlSpacing                => _OOHG_ActiveControlInfo \( \) \[ 272 \]
#xtranslate _OOHG_ActiveControlHorizontal             => _OOHG_ActiveControlInfo \( \) \[ 273 \]
#xtranslate _OOHG_ActiveControlNoTicks                => _OOHG_ActiveControlInfo \( \) \[ 274 \]
#xtranslate _OOHG_ActiveControlBoth                   => _OOHG_ActiveControlInfo \( \) \[ 275 \]
#xtranslate _OOHG_ActiveControlTop                    => _OOHG_ActiveControlInfo \( \) \[ 276 \]
#xtranslate _OOHG_ActiveControlLeft                   => _OOHG_ActiveControlInfo \( \) \[ 277 \]
#xtranslate _OOHG_ActiveControlUpperCase              => _OOHG_ActiveControlInfo \( \) \[ 278 \]
#xtranslate _OOHG_ActiveControlLowerCase              => _OOHG_ActiveControlInfo \( \) \[ 279 \]
#xtranslate _OOHG_ActiveControlNumeric                => _OOHG_ActiveControlInfo \( \) \[ 280 \]
#xtranslate _OOHG_ActiveControlPassword               => _OOHG_ActiveControlInfo \( \) \[ 281 \]
#xtranslate _OOHG_ActiveControlInputMask              => _OOHG_ActiveControlInfo \( \) \[ 282 \]
#xtranslate _OOHG_ActiveControlAutoSkip               => _OOHG_ActiveControlInfo \( \) \[ 283 \]
#xtranslate _OOHG_ActiveControlWorkArea               => _OOHG_ActiveControlInfo \( \) \[ 284 \]
#xtranslate _OOHG_ActiveControlFields                 => _OOHG_ActiveControlInfo \( \) \[ 285 \]
#xtranslate _OOHG_ActiveControlDelete                 => _OOHG_ActiveControlInfo \( \) \[ 286 \]
#xtranslate _OOHG_ActiveControlValid                  => _OOHG_ActiveControlInfo \( \) \[ 287 \]
#xtranslate _OOHG_ActiveControlValidMessages          => _OOHG_ActiveControlInfo \( \) \[ 288 \]
#xtranslate _OOHG_ActiveControlLock                   => _OOHG_ActiveControlInfo \( \) \[ 289 \]
#xtranslate _OOHG_ActiveControlAppendable             => _OOHG_ActiveControlInfo \( \) \[ 290 \]
#xtranslate _OOHG_ActiveControlFile                   => _OOHG_ActiveControlInfo \( \) \[ 291 \]
#xtranslate _OOHG_ActiveControlAutoPlay               => _OOHG_ActiveControlInfo \( \) \[ 292 \]
#xtranslate _OOHG_ActiveControlVCenter                => _OOHG_ActiveControlInfo \( \) \[ 293 \]
#xtranslate _OOHG_ActiveControlNoAutoSizeWindow       => _OOHG_ActiveControlInfo \( \) \[ 294 \]
#xtranslate _OOHG_ActiveControlNoAuotSizeMovie        => _OOHG_ActiveControlInfo \( \) \[ 295 \]
#xtranslate _OOHG_ActiveControlNoErrorDlg             => _OOHG_ActiveControlInfo \( \) \[ 296 \]
#xtranslate _OOHG_ActiveControlNoMenu                 => _OOHG_ActiveControlInfo \( \) \[ 297 \]
#xtranslate _OOHG_ActiveControlNoOpen                 => _OOHG_ActiveControlInfo \( \) \[ 298 \]
#xtranslate _OOHG_ActiveControlNoPlayBar              => _OOHG_ActiveControlInfo \( \) \[ 299 \]
#xtranslate _OOHG_ActiveControlCtrlAtLeft             => _OOHG_ActiveControlInfo \( \) \[ 300 \]

#xcommand _OOHG_ClearActiveControlInfo( <name> ) => ;
      _OOHG_ActiveControlInfo          := Array( 300 ) ;;
      _OOHG_ActiveControlName          := <name>       ;;
      _OOHG_ActiveControlOf            := NIL          ;;
      _OOHG_ActiveControlRow           := NIL          ;;
      _OOHG_ActiveControlCol           := NIL          ;;
      _OOHG_ActiveControlWidth         := NIL          ;;
      _OOHG_ActiveControlHeight        := NIL          ;;
      _OOHG_ActiveControlFont          := NIL          ;;
      _OOHG_ActiveControlSize          := NIL          ;;
      _OOHG_ActiveControlFontBold      := .F.          ;;
      _OOHG_ActiveControlFontItalic    := .F.          ;;
      _OOHG_ActiveControlFontStrikeOut := .F.          ;;
      _OOHG_ActiveControlFontUnderLine := .F.          ;;
      _OOHG_ActiveControlFontColor     := NIL          ;;
      _OOHG_ActiveControlBackColor     := NIL          ;;
      _OOHG_ActiveControlRtl           := .F.          ;;
      _OOHG_ActiveControlValue         := NIL          ;;
      _OOHG_ActiveControlTooltip       := NIL          ;;
      _OOHG_ActiveControlNoTabStop     := .F.          ;;
      _OOHG_ActiveControlInvisible     := .F.          ;;
      _OOHG_ActiveControlHelpId        := NIL          ;;
      _OOHG_ActiveControlDisabled      := .F.          ;;
      _OOHG_ActiveControlOnDblClick    := NIL          ;;
      _OOHG_ActiveControlOnLostFocus   := NIL          ;;
      _OOHG_ActiveControlOnGotFocus    := NIL          ;;
      _OOHG_ActiveControlOnChange      := NIL          ;;
      _OOHG_ActiveControlOnEnter       := NIL          ;;
      _OOHG_ActiveControlOnMouseMove   := NIL          ;;
      _OOHG_ActiveControlAssignObject  := NIL          ;;
      _OOHG_ActiveControlSubClass      := NIL

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

#xcommand TABSTOP <tabstop> ;
   => ;
      _OOHG_ActiveControlNoTabStop := ! ( <tabstop> )

#xcommand NOTABSTOP <notabstop> ;
   => ;
      _OOHG_ActiveControlNoTabStop := <notabstop>

#xcommand VISIBLE <visible> ;
   => ;
      _OOHG_ActiveControlInvisible := ! ( <visible> )

#xcommand INVISIBLE <invisible> ;
   => ;
      _OOHG_ActiveControlInvisible := <invisible>

#xcommand HELPID <helpid> ;
   => ;
      _OOHG_ActiveControlHelpId := <helpid>

#xcommand DISABLED <disabled> ;
   => ;
      _OOHG_ActiveControlDisabled := <disabled>

#xcommand ENABLED <enabled> ;
   => ;
      _OOHG_ActiveControlDisabled := ! ( <enabled> )

#xcommand ITEMSOURCE <itemsource> ;
   => ;
      _OOHG_ActiveControlItemSource := <(itemsource)>

#xcommand VALUESOURCE <valuesource> ;
   => ;
      _OOHG_ActiveControlValueSource := <(valuesource)>

#xcommand COLUMNCONTROLS <editcontrols> ;
   => ;
      _OOHG_ActiveControlEditControls := <editcontrols>

#xcommand ONEDITCELL <editcell> ;
   => ;
      _OOHG_ActiveControlEditCell := <editcell>

#xcommand ON EDITCELL <editcell> ;
   => ;
      _OOHG_ActiveControlEditCell := <editcell>

#xcommand ONEDITCELLEND <editend> ;
   => ;
      _OOHG_ActiveControlEditCellEnd := <editend>

#xcommand ON EDITCELLEND <editend> ;
   => ;
      _OOHG_ActiveControlEditCellEnd := <editend>

#xcommand ONBEFOREEDITCELL <beforedit> ;
   => ;
      _OOHG_ActiveControlBeforeEditCell := <beforedit>

#xcommand ON BEFOREEDITCELL <beforedit> ;
   => ;
      _OOHG_ActiveControlBeforeEditCell := <beforedit>

#xcommand ON ABORTEDIT <abortedit> ;
   => ;
      _OOHG_ActiveControlAbortEdit := <abortedit>

#xcommand ONABORTEDIT <abortedit> ;
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
      _OOHG_ActiveControlNoVScroll := ! ( <vs> )

#xcommand NOHSCROLLBAR <nvs> ;
   => ;
      _OOHG_ActiveControlNoHScroll := <nvs>

#xcommand HSCROLLBAR <vs> ;
   => ;
      _OOHG_ActiveControlNoHScroll := ! ( <vs> )

#xcommand INPLACEEDIT <inplaceedit> ;
   => ;
      _OOHG_ActiveControlInPlaceEdit := <inplaceedit>

#xcommand DATE <datetype> ;
   => ;
      _OOHG_ActiveControlDateType := <datetype>

#xcommand COLUMNVALID <valid> ;
   => ;
      _OOHG_ActiveControlValid := <valid>

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

/*---------------------------------------------------------------------------
FRAME
---------------------------------------------------------------------------*/

#xcommand DEFINE FRAME <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlCaption     := NIL    ;;
      _OOHG_ActiveControlTransparent := .F.    ;;
      _OOHG_ActiveControlOpaque      := .F.    ;;
      _OOHG_ActiveControlExcludeArea := NIL

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
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlTooltip, ;
            _OOHG_ActiveControlExcludeArea )

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

#xcommand COLUMNWHEN <aWhenFields> ;
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

/*---------------------------------------------------------------------------
LISTBOX
---------------------------------------------------------------------------*/

#xcommand DEFINE LISTBOX <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlItems       := NIL    ;;
      _OOHG_ActiveControlMultiSelect := .F.    ;;
      _OOHG_ActiveControlBreak       := .F.    ;;
      _OOHG_ActiveControlSort        := .F.    ;;
      _OOHG_ActiveControlImage       := NIL    ;;
      _OOHG_ActiveControlTextHeight  := NIL    ;;
      _OOHG_ActiveControlStretch     := .F.    ;;
      _OOHG_ActiveControlNoVScroll   := .F.    ;;
      _OOHG_ActiveControlMultiLine   := .F.    ;;
      _OOHG_ActiveControlFixedWidths := NIL    ;;
      _OOHG_ActiveControlMultiTab    := .F.    ;;
      _OOHG_ActiveControlWidths      := NIL

#xcommand SORT <sort> ;
   => ;
      _OOHG_ActiveControlSort := <sort>

#xcommand FIT <fit> ;
   => ;
      _OOHG_ActiveControlStretch := <fit>

#xcommand TEXTHEIGHT <textheight> ;
   => ;
      _OOHG_ActiveControlTextHeight := <textheight>

#xcommand MULTICOLUMN <multicolumn> ;
   => ;
      _OOHG_ActiveControlMultiLine := <multicolumn>

#xcommand COLUMNWIDTH <multicolumn> ;
   => ;
      _OOHG_ActiveControlFixedWidths := <multicolumn>

#xcommand MULTITAB <multitab> ;
   => ;
      _OOHG_ActiveControlMultiTab := <multitab>

#xcommand TABSWIDTH <aTabs> ;
   => ;
      _OOHG_ActiveControlWidths := <aTabs>

#xcommand DRAGITEMS <dragitems> ;
   => ;
      _OOHG_ActiveControlFullMove := <dragitems>

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
            _OOHG_ActiveControlNoVScroll, ;
            _OOHG_ActiveControlMultiLine, ;
            _OOHG_ActiveControlFixedWidths, ;
            _OOHG_ActiveControlMultiTab, ;
            _OOHG_ActiveControlWidths, ;
            _OOHG_ActiveControlFullMove )

/*---------------------------------------------------------------------------
CHECKLIST
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKLIST <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlItems          := NIL ;;
      _OOHG_ActiveControlImage          := NIL ;;
      _OOHG_ActiveControlJustify        := NIL ;;
      _OOHG_ActiveControlBreak          := .F. ;;
      _OOHG_ActiveControlSort           := .F. ;;
      _OOHG_ActiveControlDescending     := .F. ;;
      _OOHG_ActiveControlSelectedColors := NIL ;;
      _OOHG_ActiveControlDblBffer       := .T. ;;
      _OOHG_ActiveControlSngBffer       := .F. ;;
      _OOHG_ActiveControlAction         := NIL

#xcommand PAINTDOUBLEBUFFER <dblbffr> ;
   => ;
      _OOHG_ActiveControlDblBffer := <dblbffr>

#xcommand DOUBLEBUFFER <dblbffr> ;
   => ;
      _OOHG_ActiveControlDblBffer := <dblbffr>

#xcommand SINGLEBUFFER <sngbffr> ;
   => ;
      _OOHG_ActiveControlSngBffer := <sngbffr>

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
            iif( _OOHG_ActiveControlDblBffer, .T., iif( _OOHG_ActiveControlSngBffer, .F., .T. ) ), ;
            _OOHG_ActiveControlAction )

/*---------------------------------------------------------------------------
ANIMATEBOX
---------------------------------------------------------------------------*/

#xcommand DEFINE ANIMATEBOX <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlAutoPlay    := .F.    ;;
      _OOHG_ActiveControlCenter      := .F.    ;;
      _OOHG_ActiveControlTransparent := .F.    ;;
      _OOHG_ActiveControlFile        := NIL

#xcommand AUTOPLAY <autoplay> ;
   => ;
      _OOHG_ActiveControlAutoPlay := <autoplay>

#xcommand CENTER <center> ;
   => ;
      _OOHG_ActiveControlAlignment := "CENTER" ;;
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
            _OOHG_ActiveControlRtl, ;
            _OOHG_ActiveControlTooltip )

#xcommand DEFINE PLAYER <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )   ;;
      _OOHG_ActiveControlFile             := NIL ;;
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

/*---------------------------------------------------------------------------
PROGRESSBAR
---------------------------------------------------------------------------*/

#xcommand DEFINE PROGRESSBAR <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlRangeLow  := NIL      ;;
      _OOHG_ActiveControlRangeHigh := NIL      ;;
      _OOHG_ActiveControlVertical  := .F.      ;;
      _OOHG_ActiveControlSmooth    := .F.      ;;
      _OOHG_ActiveControlForeColor := NIL      ;;
      _OOHG_ActiveControlSpeed     := NIL

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

/*---------------------------------------------------------------------------
RADIOGROUP
---------------------------------------------------------------------------*/

#xcommand DEFINE RADIOGROUP <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlOptions     := NIL    ;;
      _OOHG_ActiveControlSpacing     := NIL    ;;
      _OOHG_ActiveControlTransparent := .F.    ;;
      _OOHG_ActiveControlAutoSize    := .F.    ;;
      _OOHG_ActiveControlDrawBy      := NIL    ;;
      _OOHG_ActiveControlHorizontal  := .F.    ;;
      _OOHG_ActiveControlBackground  := NIL    ;;
      _OOHG_ActiveControlLeft        := .F.    ;;
      _OOHG_ActiveControlReadOnly    := NIL    ;;
      _OOHG_ActiveControlNoFocusRect := .F.

#xcommand LEFTJUSTIFY <left> ;
   => ;
      _OOHG_ActiveControlLeft := <left>

#xcommand OPTIONS <aOptions> ;
   => ;
      _OOHG_ActiveControlOptions := <aOptions>

#xcommand SPACING <spacing> ;
   => ;
      _OOHG_ActiveControlSpacing := <spacing>

#xcommand HORIZONTAL <horizontal> ;
   => ;
      _OOHG_ActiveControlHorizontal := <horizontal>

#xcommand BACKGROUND <bkgrnd> ;
   => ;
      _OOHG_ActiveControlBackground := <bkgrnd>

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
            _OOHG_ActiveControlDrawBy, ;
            _OOHG_ActiveControlBackground, ;
            _OOHG_ActiveControlLeft, ;
            _OOHG_ActiveControlReadOnly, ;
            _OOHG_ActiveControlNoFocusRect )

/*---------------------------------------------------------------------------
SLIDER
---------------------------------------------------------------------------*/

#xcommand DEFINE SLIDER <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlRangeLow  := NIL      ;;
      _OOHG_ActiveControlRangeHigh := NIL      ;;
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
      _OOHG_ActiveControlAlignment := "TOP" ;;
      _OOHG_ActiveControlTop := <top>

#xcommand LEFT <left> ;
   => ;
      _OOHG_ActiveControlAlignment := "LEFT" ;;
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

/*---------------------------------------------------------------------------
TEXTBOX
---------------------------------------------------------------------------*/

#xcommand DEFINE TEXTBOX <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlField        := NIL   ;;
      _OOHG_ActiveControlMaxLength    := NIL   ;;
      _OOHG_ActiveControlUpperCase    := .F.   ;;
      _OOHG_ActiveControlLowerCase    := .F.   ;;
      _OOHG_ActiveControlNumeric      := .F.   ;;
      _OOHG_ActiveControlPassword     := .F.   ;;
      _OOHG_ActiveControlRight        := .F.   ;;
      _OOHG_ActiveControlReadonly     := .F.   ;;
      _OOHG_ActiveControlDateType     := .F.   ;;
      _OOHG_ActiveControlInputMask    := NIL   ;;
      _OOHG_ActiveControlPicture      := NIL   ;;
      _OOHG_ActiveControlFormat       := NIL   ;;
      _OOHG_ActiveControlNoBorder     := .F.   ;;
      _OOHG_ActiveControlAutoSkip     := .F.   ;;
      _OOHG_ActiveControlFocusedPos   := NIL   ;;
      _OOHG_ActiveControlValid        := NIL   ;;
      _OOHG_ActiveControlImage        := NIL   ;;
      _OOHG_ActiveControlWhen         := NIL   ;;
      _OOHG_ActiveControlAction       := NIL   ;;
      _OOHG_ActiveControlAction2      := NIL   ;;
      _OOHG_ActiveControlCenter       := NIL   ;;
      _OOHG_ActiveControlDefaultYear  := NIL   ;;
      _OOHG_ActiveControlOnTextFilled := NIL   ;;
      _OOHG_ActiveControlInsertType   := NIL   ;;
      _OOHG_ActiveControlCtrlAtLeft   := .F.   ;;
      _OOHG_ActiveControlContextMenu  := NIL   ;;
      _OOHG_ActiveControlActionTT     := NIL   ;;
      _OOHG_ActiveControlAction2TT    := NIL   ;;
      _OOHG_ActiveControlCueBanner    := NIL

#xcommand CUEBANNER <text>;
   => ;
   _OOHG_ActiveControlCueBanner := <text>

#xcommand PLACEHOLDER <text>;
   => ;
   _OOHG_ActiveControlCueBanner := <text>

#xcommand CTRLSATLEFT <atleft> ;
   => ;
      _OOHG_ActiveControlCtrlAtLeft := <atleft>

#xcommand INSERTTYPE <inserttype> ;
   => ;
      _OOHG_ActiveControlInsertType := <inserttype>

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

#xcommand ACTION2TT <tooltip> ;
   => ;
      _OOHG_ActiveControlAction2TT := <tooltip>

#xcommand ACTIONTT <tooltip> ;
   => ;
      _OOHG_ActiveControlActionTT := <tooltip>

#xcommand CONTEXTMENU <cm> ;
   => ;
      _OOHG_ActiveControlContextMenu := <cm>

#xcommand NOCONTEXTMENU <ncm> ;
   => ;
      _OOHG_ActiveControlContextMenu := ! ( <ncm> )

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
            _OOHG_ActiveControlRight, ;
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
            iif( _OOHG_ActiveControlInputMask == NIL, _OOHG_ActiveControlPicture, _OOHG_ActiveControlInputMask ), ;
            _OOHG_ActiveControlFormat, ;
            _OOHG_ActiveControlSubClass, ;
            _OOHG_ActiveControlAction, ;
            _OOHG_ActiveControlImage, ;
            _OOHG_ActiveControlButtonWidth, ;
            _OOHG_ActiveControlAction2, ;
            _OOHG_ActiveControlWhen, ;
            _OOHG_ActiveControlCenter, ;
            _OOHG_ActiveControlDefaultYear, ;
            _OOHG_ActiveControlOnTextFilled, ;
            _OOHG_ActiveControlInsertType, ;
            _OOHG_ActiveControlCtrlAtLeft, ;
            _OOHG_ActiveControlContextMenu, ;
            _OOHG_ActiveControlActionTT, ;
            _OOHG_ActiveControlAction2TT, ;
            _OOHG_ActiveControlCueBanner ), NIL, _OOHG_ActiveControlAssignObject )

/*---------------------------------------------------------------------------
MONTHCALENDAR
---------------------------------------------------------------------------*/

#xcommand DEFINE MONTHCALENDAR <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )    ;;
      _OOHG_ActiveControlNoToday           := .F. ;;
      _OOHG_ActiveControlNoTodayCircle     := .F. ;;
      _OOHG_ActiveControlWeekNumbers       := .F. ;;
      _OOHG_ActiveControlTitleFontColor    := NIL ;;
      _OOHG_ActiveControlTitleBackColor    := NIL ;;
      _OOHG_ActiveControlTrailingFontColor := NIL ;;
      _OOHG_ActiveControlBackgroundColor   := NIL ;;
      _OOHG_ActiveControlDisplayChange     := NIL

#xcommand ON VIEWCHANGE <viewchange> ;
   => ;
      _OOHG_ActiveControlDisplayChange := <{viewchange}>

#xcommand ONVIEWCHANGE <viewchange> ;
   => ;
      _OOHG_ActiveControlDisplayChange := <{viewchange}>

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

#xcommand BKGNDCOLOR <color> ;
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
            _OOHG_ActiveControlBackgroundColor, ;
            _OOHG_ActiveControlDisplayChange, ;
            _OOHG_ActiveControlOnGotFocus, ;
            _OOHG_ActiveControlOnLostFocus )

/*---------------------------------------------------------------------------
BUTTON
---------------------------------------------------------------------------*/

#xcommand DEFINE BUTTON <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )    ;;
      _OOHG_ActiveControlCaption           := NIL ;;
      _OOHG_ActiveControlAction            := NIL ;;
      _OOHG_ActiveControlFlat              := .F. ;;
      _OOHG_ActiveControlPicture           := NIL ;;
      _OOHG_ActiveControlNoLoadTransparent := .F. ;;
      _OOHG_ActiveControlNoPrefix          := .F. ;;
      _OOHG_ActiveControlBuffer            := NIL ;;
      _OOHG_ActiveControlHBitmap           := NIL ;;
      _OOHG_ActiveControlAutoFit           := .F. ;;
      _OOHG_ActiveControlCancel            := .F. ;;
      _OOHG_ActiveControlAlignment         := NIL ;;
      _OOHG_ActiveControlMultiLine         := .F. ;;
      _OOHG_ActiveControlDrawBy            := NIL ;;
      _OOHG_ActiveControlImageMargin       := NIL ;;
      _OOHG_ActiveControlNo3DColors        := .F. ;;
      _OOHG_ActiveControlAutoFit           := .F. ;;
      _OOHG_ActiveControlNoDIBSection      := .T. ;;
      _OOHG_ActiveControlNoToday           := .F. ;;
      _OOHG_ActiveControlSolid             := .F. ;;
      _OOHG_ActiveControlTextAlignH        := NIL ;;
      _OOHG_ActiveControlTextAlignV        := NIL ;;
      _OOHG_ActiveControlNoPrintOver       := .F. ;;
      _OOHG_ActiveControlTextMargin        := .F. ;;
      _OOHG_ActiveControlFitTxt            := .F. ;;
      _OOHG_ActiveControlFitImg            := .F. ;;
      _OOHG_ActiveControlImagesize         := .F. ;;
      _OOHG_ActiveControlTransparent       := .F. ;;
      _OOHG_ActiveControlNoFocusRect       := .F. ;;
      _OOHG_ActiveControlNoImagelist       := .F. ;;
      _OOHG_ActiveControlNoDestroy         := .F.

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

#xcommand ONMOUSEHOVER <onmousemove> ;
   => ;
      _OOHG_ActiveControlOnMouseMove := <{onmousemove}>

#xcommand ON MOUSEHOVER <onmousemove> ;
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

#xcommand SCALE <autofit> ;
   => ;
      _OOHG_ActiveControlAutoFit := <autofit>

#xcommand CANCEL <cancel> ;
   => ;
      _OOHG_ActiveControlCancel := <cancel>

#xcommand BOTTOM <bottom> ;
   => ;
      _OOHG_ActiveControlAlignment := "BOTTOM"

#xcommand RIGHT <right> ;
   => ;
      _OOHG_ActiveControlAlignment := "RIGHT" ;;
      _OOHG_ActiveControlRight := <right>

#xcommand TOPALIGN <top> ;
   => ;
      _OOHG_ActiveControlAlignment := "TOP" ;;
      _OOHG_ActiveControlTop := <top>

#xcommand BOTTOMALIGN <bottom> ;
   => ;
      _OOHG_ActiveControlAlignment := "BOTTOM"

#xcommand PICTALIGNMENT <imgalign: LEFT, RIGHT, TOP, BOTTOM, CENTER> ;
   => ;
      ALIGNMENT <imgalign>

#xcommand IMAGEALIGN <imgalign: LEFT, RIGHT, TOP, BOTTOM, CENTER> ;
   => ;
      ALIGNMENT <imgalign>

#xcommand ALIGNMENT LEFT ;
   => ;
      _OOHG_ActiveControlAlignment := "LEFT" ;;
      _OOHG_ActiveControlLeft := .T.

#xcommand ALIGNMENT RIGHT ;
   => ;
      _OOHG_ActiveControlAlignment := "RIGHT" ;;
      _OOHG_ActiveControlRight := .T.

#xcommand ALIGNMENT TOP ;
   => ;
      _OOHG_ActiveControlAlignment := "TOP" ;;
      _OOHG_ActiveControlTop := .T.

#xcommand ALIGNMENT BOTTOM ;
   => ;
      _OOHG_ActiveControlAlignment := "BOTTOM"

#xcommand ALIGNMENT CENTER ;
   => ;
      _OOHG_ActiveControlAlignment := "CENTER" ;;
      _OOHG_ActiveControlCenter := .T.

#xcommand MULTILINE <multiline> ;
   => ;
      _OOHG_ActiveControlMultiLine := <multiline>

#xcommand OOHGDRAW <oohgdraw> ;
   => ;
      _OOHG_ActiveControlDrawBy := <oohgdraw>

#xcommand WINDRAW <windraw> ;
   => ;
      _OOHG_ActiveControlDrawBy := ! ( <windraw> )

#xcommand IMAGEMARGIN <margin> ;
   => ;
      _OOHG_ActiveControlImageMargin := <margin>

#xcommand NO3DCOLORS <no3dcolors> ;
   => ;
      _OOHG_ActiveControlNo3DColors := <no3dcolors>

#xcommand NOIMAGELIST <noimglst> ;
   => ;
      _OOHG_ActiveControlNoImagelist := <noimglst>

#xcommand NODESTROY <nodestroy> ;
   => ;
      _OOHG_ActiveControlNoDestroy := <nodestroy>

#xcommand AUTOFIT <autofit> ;
   => ;
      _OOHG_ActiveControlAutoFit := <autofit>

#xcommand ADJUST <autofit: .T., .F.> ;
   => ;
      _OOHG_ActiveControlAutoFit := <autofit>

#xcommand DIBSECTION <dibsection> ;
   => ;
      _OOHG_ActiveControlNoDIBSection := ! ( <dibsection> )

#xcommand NOHOTLIGHT <nohotlight> ;
   => ;
      _OOHG_ActiveControlNoToday := <nohotlight>

#xcommand SOLID <solid> ;
   => ;
      _OOHG_ActiveControlSolid := <solid>

#xcommand TEXTALIGNH <textalignh> ;
   => ;
      _OOHG_ActiveControlTextAlignH := <textalignh>

#xcommand TEXTALIGNV <textalignv> ;
   => ;
      _OOHG_ActiveControlTextAlignV := <textalignv>

#xcommand NOPRINTOVER <noprintover> ;
   => ;
      _OOHG_ActiveControlNoPrintOver := <noprintover>

#xcommand TEXTMARGIN <margin> ;
   => ;
      _OOHG_ActiveControlTextMargin := <margin>

#xcommand FITTXT <fittxt> ;
   => ;
      _OOHG_ActiveControlFitTxt := <fittxt>

#xcommand FITIMG <fitimg> ;
   => ;
      _OOHG_ActiveControlFitImg := <fitimg>

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
            _OOHG_ActiveControlNoLoadTransparent, ;
            _OOHG_ActiveControlStretch, ;
            _OOHG_ActiveControlCancel, ;
            _OOHG_ActiveControlAlignment, ;
            _OOHG_ActiveControlMultiLine, ;
            _OOHG_ActiveControlDrawBy, ;
            _OOHG_ActiveControlImageMargin, ;
            _OOHG_ActiveControlOnMouseMove, ;
            _OOHG_ActiveControlNo3DColors, ;
            _OOHG_ActiveControlAutoFit, ;
            _OOHG_ActiveControlNoDIBSection, ;
            _OOHG_ActiveControlBackColor, ;
            _OOHG_ActiveControlNoToday, ;
            _OOHG_ActiveControlSolid, ;
            _OOHG_ActiveControlFontColor, ;
            { _OOHG_ActiveControlTextAlignH, _OOHG_ActiveControlTextAlignV }, ;
            _OOHG_ActiveControlNoPrintOver, ;
            _OOHG_ActiveControlTextMargin, ;
            _OOHG_ActiveControlFitTxt, ;
            _OOHG_ActiveControlFitImg, ;
            _OOHG_ActiveControlImagesize, ;
            _OOHG_ActiveControlTransparent, ;
            _OOHG_ActiveControlNoFocusRect, ;
            _OOHG_ActiveControlNoImagelist, ;
            _OOHG_ActiveControlNoDestroy )

/*---------------------------------------------------------------------------
IMAGE
---------------------------------------------------------------------------*/

#xcommand DEFINE IMAGE <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )    ;;
      _OOHG_ActiveControlPicture           := NIL ;;
      _OOHG_ActiveControlAction            := NIL ;;
      _OOHG_ActiveControlStretch           := .F. ;;
      _OOHG_ActiveControlNoResize          := .F. ;;
      _OOHG_ActiveControlBorder            := .F. ;;
      _OOHG_ActiveControlClientEdge        := .F. ;;
      _OOHG_ActiveControlImagesize         := .F. ;;
      _OOHG_ActiveControlBuffer            := NIL ;;
      _OOHG_ActiveControlHBitmap           := NIL ;;
      _OOHG_ActiveControlWhiteBackground   := NIL ;;
      _OOHG_ActiveControlNoDIBSection      := .F. ;;
      _OOHG_ActiveControlNo3DColors        := .F. ;;
      _OOHG_ActiveControlNoLoadTransparent := .F. ;;
      _OOHG_ActiveControlTransparent       := .F. ;;
      _OOHG_ActiveControlExcludeArea       := NIL ;;
      _OOHG_ActiveControlOnRClick          := NIL ;;
      _OOHG_ActiveControlOnMClick          := NIL ;;
      _OOHG_ActiveControlOnDblClick        := NIL ;;
      _OOHG_ActiveControlOnRDblClick       := NIL ;;
      _OOHG_ActiveControlOnMDblClick       := NIL ;;
      _OOHG_ActiveControlNoCheckDepth      := .F. ;;
      _OOHG_ActiveControlNoRedrawParent    := .F.

#xcommand STRETCH <stretch> ;
   => ;
      _OOHG_ActiveControlStretch := <stretch>

#xcommand IMAGESIZE <imagesize> ;
   => ;
      _OOHG_ActiveControlImagesize := <imagesize>

#xcommand WHITEBACKGROUND <whitebackground> ;
   => ;
      _OOHG_ActiveControlWhiteBackground := iif( <whitebackground>, 0xFFFFFF, _OOHG_ActiveControlBackColor )

#xcommand NOCHECKDEPTH <nocheckdepth> ;
   => ;
      _OOHG_ActiveControlNoCheckDepth := <nocheckdepth>

#xcommand NOPARENTREDRAW <noredraw> ;
   => ;
      _OOHG_ActiveControlNoRedrawParent := <noredraw>

#xcommand NORESIZE <noresize> ;
   => ;
      _OOHG_ActiveControlNoResize := <noresize>

#xcommand NODIBSECTION <nodib> ;
   => ;
      _OOHG_ActiveControlNoDIBSection := <nodib>

#xcommand NOLOADTRANSPARENT <noloadtransparent> ;
   => ;
      _OOHG_ActiveControlNoLoadTransparent := <noloadtransparent>

#xcommand EXCLUDEAREA <area> ;
   => ;
      _OOHG_ActiveControlExcludeArea := <area>

#xcommand ONMCLICK <dblclick> ;
   => ;
      _OOHG_ActiveControlOnMClick := <{dblclick}>

#xcommand ON MCLICK <dblclick> ;
   => ;
      _OOHG_ActiveControlOnMClick := <{dblclick}>

#xcommand ONRDBLCLICK <dblclick> ;
   => ;
      _OOHG_ActiveControlOnRDblClick := <{dblclick}>

#xcommand ON RDBLCLICK <dblclick> ;
   => ;
      _OOHG_ActiveControlOnRDblClick := <{dblclick}>

#xcommand ONMDBLCLICK <dblclick> ;
   => ;
      _OOHG_ActiveControlOnMDblClick := <{dblclick}>

#xcommand ON MDBLCLICK <dblclick> ;
   => ;
      _OOHG_ActiveControlOnMDblClick := <{dblclick}>

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
            ! _OOHG_ActiveControlNoResize, ;
            _OOHG_ActiveControlImagesize, ;
            _OOHG_ActiveControlTooltip, ;
            _OOHG_ActiveControlBorder, ;
            _OOHG_ActiveControlClientEdge, ;
            _OOHG_ActiveControlNoLoadTransparent, ;
            _OOHG_ActiveControlNo3DColors, ;
            _OOHG_ActiveControlNoDIBSection, ;
            _OOHG_ActiveControlTransparent, ;
            _OOHG_ActiveControlExcludeArea, ;
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlOnChange, ;
            _OOHG_ActiveControlOnRClick, ;
            _OOHG_ActiveControlOnMClick, ;
            _OOHG_ActiveControlOnDblClick, ;
            _OOHG_ActiveControlOnRDblClick, ;
            _OOHG_ActiveControlOnMDblClick, ;
            _OOHG_ActiveControlNoCheckDepth, ;
            _OOHG_ActiveControlNoRedrawParent )

/*---------------------------------------------------------------------------
ANIGIF
---------------------------------------------------------------------------*/

#xcommand DEFINE ANIGIF <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )  ;;
      _OOHG_ActiveControlFile            := NIL ;;
      _OOHG_ActiveControlAction          := NIL ;;
      _OOHG_ActiveControlWhiteBackground := NIL ;;
      _OOHG_ActiveControlBorder          := .F. ;;
      _OOHG_ActiveControlClientEdge      := .F.

#xcommand END ANIGIF ;
   => ;
      _OOHG_SelectSubClass( TAniGIF(), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
            _OOHG_ActiveControlName, ;
            _OOHG_ActiveControlOf, ;
            _OOHG_ActiveControlCol, ;
            _OOHG_ActiveControlRow, ;
            _OOHG_ActiveControlFile, ;
            _OOHG_ActiveControlWidth, ;
            _OOHG_ActiveControlHeight, ;
            _OOHG_ActiveControlAction, ;
            _OOHG_ActiveControlHelpId, ;
            _OOHG_ActiveControlInvisible, ;
            _OOHG_ActiveControlWhiteBackground, ;
            _OOHG_ActiveControlRtl, ;
            _OOHG_ActiveControlBackColor, ;
            _OOHG_ActiveControlTooltip, ;
            _OOHG_ActiveControlBorder, ;
            _OOHG_ActiveControlClientEdge, ;
            _OOHG_ActiveControlDisabled )

/*---------------------------------------------------------------------------
CHECKBOX
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKBOX <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlCaption     := NIL    ;;
      _OOHG_ActiveControlTransparent := .F.    ;;
      _OOHG_ActiveControlAutoSize    := .F.    ;;
      _OOHG_ActiveControlField       := NIL    ;;
      _OOHG_ActiveControl3State      := .F.    ;;
      _OOHG_ActiveControlDrawBy      := NIL    ;;
      _OOHG_ActiveControlLeft        := .F.    ;;
      _OOHG_ActiveControlBackground  := NIL    ;;
      _OOHG_ActiveControlNoFocusRect := .F.    ;;
      _OOHG_ActiveControlFocusRect   := .F.

#xcommand THREESTATE <threestate> ;
   => ;
      _OOHG_ActiveControl3State := <threestate>

#xcommand LEFTALIGN <left> ;
   => ;
      _OOHG_ActiveControlAlignment := "LEFT" ;;
      _OOHG_ActiveControlLeft := <left>

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
            _OOHG_ActiveControlLeft, ;
            _OOHG_ActiveControlDrawBy, ;
            _OOHG_ActiveControlBackground, ;
            iif( _OOHG_ActiveControlNoFocusRect, .T., iif( _OOHG_ActiveControlFocusRect, .F., NIL ) ) )

/*---------------------------------------------------------------------------
CHECKBUTTON
---------------------------------------------------------------------------*/

#xcommand DEFINE CHECKBUTTON <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlCaption           := NIL ;;
      _OOHG_ActiveControlPicture           := NIL ;;
      _OOHG_ActiveControlField             := NIL ;;
      _OOHG_ActiveControlBuffer            := NIL ;;
      _OOHG_ActiveControlHBitmap           := NIL ;;
      _OOHG_ActiveControlNoLoadTransparent := .F. ;;
      _OOHG_ActiveControlStretch           := .F. ;;
      _OOHG_ActiveControlNo3DColors        := .F. ;;
      _OOHG_ActiveControlAutoFit           := .F. ;;
      _OOHG_ActiveControlNoDIBSection      := .T. ;;
      _OOHG_ActiveControlDrawBy            := NIL ;;
      _OOHG_ActiveControlImageMargin       := NIL ;;
      _OOHG_ActiveControlOnMouseMove       := NIL ;;
      _OOHG_ActiveControlAlignment         := NIL ;;
      _OOHG_ActiveControlMultiLine         := .F. ;;
      _OOHG_ActiveControlFlat              := .F. ;;
      _OOHG_ActiveControlNoToday           := .F. ;;
      _OOHG_ActiveControlSolid             := .F. ;;
      _OOHG_ActiveControlTextAlignH        := NIL ;;
      _OOHG_ActiveControlTextAlignV        := NIL ;;
      _OOHG_ActiveControlNoPrintOver       := .F. ;;
      _OOHG_ActiveControlTextMargin        := .F. ;;
      _OOHG_ActiveControlFitTxt            := .F. ;;
      _OOHG_ActiveControlFitImg            := .F. ;;
      _OOHG_ActiveControlImagesize         := .F. ;;
      _OOHG_ActiveControlTransparent       := .F. ;;
      _OOHG_ActiveControlNoFocusRect       := .F. ;;
      _OOHG_ActiveControlNoImagelist       := .F.

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
            _OOHG_ActiveControlNoLoadTransparent, ;
            _OOHG_ActiveControlStretch, ;
            _OOHG_ActiveControlNo3DColors, ;
            _OOHG_ActiveControlAutoFit, ;
            _OOHG_ActiveControlNoDIBSection, ;
            _OOHG_ActiveControlBackColor, ;
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlDrawBy, ;
            _OOHG_ActiveControlImageMargin, ;
            _OOHG_ActiveControlOnMouseMove, ;
            _OOHG_ActiveControlAlignment, ;
            _OOHG_ActiveControlMultiLine, ;
            _OOHG_ActiveControlFlat, ;
            _OOHG_ActiveControlNoToday, ;
            _OOHG_ActiveControlSolid, ;
            _OOHG_ActiveControlFontColor, ;
            { _OOHG_ActiveControlTextAlignH, _OOHG_ActiveControlTextAlignV }, ;
            _OOHG_ActiveControlNoPrintOver, ;
            _OOHG_ActiveControlTextMargin, ;
            _OOHG_ActiveControlFitTxt, ;
            _OOHG_ActiveControlFitImg, ;
            _OOHG_ActiveControlImagesize, ;
            _OOHG_ActiveControlTransparent, ;
            _OOHG_ActiveControlNoFocusRect, ;
            _OOHG_ActiveControlNoImagelist )

/*---------------------------------------------------------------------------
COMBOBOX
---------------------------------------------------------------------------*/

#xcommand DEFINE COMBOBOX <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )     ;;
      _OOHG_ActiveControlItems             := NIL  ;;
      _OOHG_ActiveControlSort              := .F.  ;;
      _OOHG_ActiveControlItemSource        := NIL  ;;
      _OOHG_ActiveControlValueSource       := NIL  ;;
      _OOHG_ActiveControlBreak             := .F.  ;;
      _OOHG_ActiveControlGripperText       := ""   ;;
      _OOHG_ActiveControlDisplayEdit       := .F.  ;;
      _OOHG_ActiveControlDisplayChange     := NIL  ;;
      _OOHG_ActiveControlImage             := NIL  ;;
      _OOHG_ActiveControlTextHeight        := NIL  ;;
      _OOHG_ActiveControlStretch           := .F.  ;;
      _OOHG_ActiveControlFirstItem         := .F.  ;;
      _OOHG_ActiveControlListWidth         := NIL  ;;
      _OOHG_ActiveControlItemImageNumber   := NIL  ;;
      _OOHG_ActiveControlImageSource       := NIL  ;;
      _OOHG_ActiveControlDelayedLoad       := .F.  ;;
      _OOHG_ActiveControlIncrementalSearch := .F.  ;;
      _OOHG_ActiveControlIntegralHeight    := .F.  ;;
      _OOHG_ActiveControlRefresh           := NIL  ;;
      _OOHG_ActiveControlNoRefresh         := NIL  ;;
      _OOHG_ActiveControlSourceOrder       := NIL  ;;
      _OOHG_ActiveControlOnRefresh         := NIL  ;;
      _OOHG_ActiveControlSearchLapse       := NIL  ;;
      _OOHG_ActiveControlMaxLength         := NIL  ;;
      _OOHG_ActiveControlEditHeight        := NIL  ;;
      _OOHG_ActiveControlOptionsHeight     := NIL  ;;
      _OOHG_ActiveControlNoHScroll         := .F.  ;;
      _OOHG_ActiveControlNoClone           := .F.  ;;
      _OOHG_ActiveControlNoLoadTransparent := .F.  ;;
      _OOHG_ActiveControlCancel            := NIL  ;;
      _OOHG_ActiveControlValueIs           := NIL  ;;
      _OOHG_ActiveControlAutoSize          := .F.  ;;
      _OOHG_ActiveControlCueBanner         := NIL

#xcommand INDEXISVALUE <index> ;
   => ;
      _OOHG_ActiveControlValueIs := <index>

#xcommand SOURCEISVALUE <index> ;
   => ;
      _OOHG_ActiveControlValueIs := <index>

#xcommand NOCLONE <noclone> ;
   => ;
      _OOHG_ActiveControlNoClone := <noclone>

#xcommand DELAYEDLOAD <delayedload> ;
   => ;
      _OOHG_ActiveControlDelayedLoad := <delayedload>

#xcommand INCREMENTAL <incremental> ;
   => ;
      _OOHG_ActiveControlIncrementalSearch := <incremental>

#xcommand SEARCHLAPSE <lapse> ;
   => ;
      _OOHG_ActiveControlSearchLapse := <lapse>

#xcommand EDITHEIGHT <editheight> ;
   => ;
      _OOHG_ActiveControlEditHeight := <editheight>

#xcommand OPTIONSHEIGHT <optionsheight> ;
   => ;
      _OOHG_ActiveControlOptionsHeight := <optionsheight>

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

#xcommand ONLISTDISPLAY <enter> ;
   => ;
      _OOHG_ActiveControlOnListDisplay := <{enter}>

#xcommand ON LISTDISPLAY <enter> ;
   => ;
      _OOHG_ActiveControlOnListDisplay := <{enter}>

#xcommand ONLISTCLOSE <enter> ;
   => ;
      _OOHG_ActiveControlOnListClose := <{enter}>

#xcommand ON LISTCLOSE <enter> ;
   => ;
      _OOHG_ActiveControlOnListClose := <{enter}>

#xcommand FIRSTITEM <firstitem> ;
   => ;
      _OOHG_ActiveControlFirstItem := <firstitem>

#xcommand SOURCEORDER <sourceorder> ;
   => ;
      _OOHG_ActiveControlSourceOrder := <sourceorder>

#xcommand ONREFRESH <refresh> ;
   => ;
      _OOHG_ActiveControlOnRefresh := <{refresh}>

#xcommand ON REFRESH <refresh> ;
   => ;
      _OOHG_ActiveControlOnRefresh := <{refresh}>

#xcommand ONCANCEL <cancel> ;
   => ;
      _OOHG_ActiveControlCancel := <{cancel}>

#xcommand ON CANCEL <cancel> ;
   => ;
      _OOHG_ActiveControlCancel := <{cancel}>

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
            _OOHG_ActiveControlIntegralHeight, ;
            iif( _OOHG_ActiveControlRefresh == NIL, iif( _OOHG_ActiveControlNoRefresh == NIL, NIL, ! _OOHG_ActiveControlNoRefresh ), _OOHG_ActiveControlRefresh ), ;
            _OOHG_ActiveControlSourceOrder, ;
            _OOHG_ActiveControlOnRefresh, ;
            _OOHG_ActiveControlSearchLapse, ;
            _OOHG_ActiveControlMaxLength, ;
            _OOHG_ActiveControlEditHeight, ;
            _OOHG_ActiveControlOptionsHeight, ;
            _OOHG_ActiveControlNoHScroll, ;
            _OOHG_ActiveControlNoClone, ;
            _OOHG_ActiveControlNoLoadTransparent, ;
            _OOHG_ActiveControlCancel, ;
            _OOHG_ActiveControlValueIs, ;
            _OOHG_ActiveControlAutoSize, ;
            _OOHG_ActiveControlCueBanner )

/*---------------------------------------------------------------------------
DATEPICKER
---------------------------------------------------------------------------*/

#xcommand DEFINE DATEPICKER <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )    ;;
      _OOHG_ActiveControlShowNone          := .F. ;;
      _OOHG_ActiveControlUpDown            := .F. ;;
      _OOHG_ActiveControlRight             := .F. ;;
      _OOHG_ActiveControlField             := NIL ;;
      _OOHG_ActiveControlNoBorder          := .F. ;;
      _OOHG_ActiveControlRangeLow          := NIL ;;
      _OOHG_ActiveControlRangeHigh         := NIL ;;
      _OOHG_ActiveControlFormat            := NIL ;;
      _OOHG_ActiveControlValid             := NIL

#xcommand DATEFORMAT <format> ;
   => ;
      _OOHG_ActiveControlFormat := <format>

#xcommand SHOWNONE <shownone> ;
   => ;
      _OOHG_ActiveControlShowNone := <shownone>

#xcommand UPDOWN <updown> ;
   => ;
      _OOHG_ActiveControlUpDown := <updown>

#xcommand RIGHTALIGN <right> ;
   => ;
      _OOHG_ActiveControlAlignment := "RIGHT" ;;
      _OOHG_ActiveControlRight := <right>

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
            _OOHG_ActiveControlRight, ;
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
            _OOHG_ActiveControlRangeHigh, ;
            _OOHG_ActiveControlFormat, ;
            _OOHG_ActiveControlValid )

#xcommand DEFINE TIMEPICKER <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlShowNone := .F.       ;;
      _OOHG_ActiveControlField    := NIL       ;;
      _OOHG_ActiveControlNoBorder := .F.       ;;
      _OOHG_ActiveControlFormat   := NIL       ;;
      _OOHG_ActiveControlValid    := NIL

#xcommand TIMEFORMAT <format> ;
   => ;
      _OOHG_ActiveControlFormat := <format>

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
            .T., ;
            .F., ;
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
            _OOHG_ActiveControlFormat, ;
            _OOHG_ActiveControlValid )

/*---------------------------------------------------------------------------
EDITBOX
---------------------------------------------------------------------------*/

#xcommand DEFINE EDITBOX <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlReadonly   := .F.     ;;
      _OOHG_ActiveControlMaxLength  := NIL     ;;
      _OOHG_ActiveControlBreak      := .F.     ;;
      _OOHG_ActiveControlField      := NIL     ;;
      _OOHG_ActiveControlNoVScroll  := .F.     ;;
      _OOHG_ActiveControlNoHScroll  := .F.     ;;
      _OOHG_ActiveControlNoBorder   := .F.     ;;
      _OOHG_ActiveControlFocusedPos := NIL     ;;
      _OOHG_ActiveControlHScroll    := NIL     ;;
      _OOHG_ActiveControlVScroll    := NIL     ;;
      _OOHG_ActiveControlInsertType := NIL

#xcommand READONLYFIELDS <readonly> ;
   => ;
      _OOHG_ActiveControlReadOnly := <readonly>

#xcommand MAXLENGTH <maxlength> ;
   => ;
      _OOHG_ActiveControlMaxLength := <maxlength>

#xcommand SETBREAK <break> ;
   => ;
      _OOHG_ActiveControlBreak := <break>

#xcommand BREAK <break> ;
   => ;
      _OOHG_ActiveControlBreak := <break>

#xcommand ON HSCROLL <hscroll> ;
   => ;
      _OOHG_ActiveControlHScroll := <hscroll>

#xcommand ONHSCROLL <hscroll> ;
   => ;
      _OOHG_ActiveControlHScroll := <hscroll>

#xcommand ON VSCROLL <vscroll> ;
   => ;
      _OOHG_ActiveControlVScroll := <vscroll>

#xcommand ONVSCROLL <vscroll> ;
   => ;
      _OOHG_ActiveControlVScroll := <vscroll>

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
            _OOHG_ActiveControlFocusedPos, ;
            _OOHG_ActiveControlHScroll, ;
            _OOHG_ActiveControlVScroll, ;
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlInsertType )

/*---------------------------------------------------------------------------
RICHEDITBOX
---------------------------------------------------------------------------*/

#xcommand DEFINE RICHEDITBOX <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlReadonly    := .F.    ;;
      _OOHG_ActiveControlMaxLength   := NIL    ;;
      _OOHG_ActiveControlBreak       := .F.    ;;
      _OOHG_ActiveControlField       := NIL    ;;
      _OOHG_ActiveControlOnSelChange := NIL    ;;
      _OOHG_ActiveControlNoHideSel   := NIL    ;;
      _OOHG_ActiveControlNoVScroll   := .F.    ;;
      _OOHG_ActiveControlNoHScroll   := .F.    ;;
      _OOHG_ActiveControlFocusedPos  := NIL    ;;
      _OOHG_ActiveControlFile        := NIL    ;;
      _OOHG_ActiveControlFormat      := .F.    ;;
      _OOHG_ActiveControlFileType    := NIL    ;;
      _OOHG_ActiveControlHScroll     := NIL    ;;
      _OOHG_ActiveControlVScroll     := NIL    ;;
      _OOHG_ActiveControlInsertType  := NIL    ;;
      _OOHG_ActiveControlVersion     := NIL

#xcommand NOHIDESEL <nohidesel> ;
   => ;
      _OOHG_ActiveControlNoHideSel := <nohidesel>

#xcommand ONSELCHANGE <onselchange> ;
   => ;
      _OOHG_ActiveControlOnSelChange := <{onselchange}>

#xcommand ON SELCHANGE <onselchange> ;
   => ;
      _OOHG_ActiveControlOnSelChange := <{onselchange}>

#xcommand PLAINTEXT <plain> ;
   => ;
      _OOHG_ActiveControlFormat := <plain>

#xcommand FILETYPE <type> ;
   => ;
      _OOHG_ActiveControlFileType := <type>

#xcommand VERSION <ver> ;
   => ;
      _OOHG_ActiveControlVersion := <ver>

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
            _OOHG_ActiveControlNoHideSel, ;
            _OOHG_ActiveControlFocusedPos, ;
            _OOHG_ActiveControlNoVScroll, ;
            _OOHG_ActiveControlNoHScroll, ;
            _OOHG_ActiveControlFile, ;
            iif( _OOHG_ActiveControlFormat, 1, _OOHG_ActiveControlFileType ), ;
            _OOHG_ActiveControlHScroll, ;
            _OOHG_ActiveControlVScroll, ;
            _OOHG_ActiveControlInsertType, ;
            _OOHG_ActiveControlVersion )

/*---------------------------------------------------------------------------
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
      _OOHG_ActiveControlAction      := NIL    ;;
      _OOHG_ActiveControlRight       := .F.    ;;
      _OOHG_ActiveControlAutoSize    := .F.    ;;
      _OOHG_ActiveControlCenter      := .F.    ;;
      _OOHG_ActiveControlNoWordWrap  := .F.    ;;
      _OOHG_ActiveControlNoPrefix    := .F.    ;;
      _OOHG_ActiveControlInputMask   := NIL    ;;
      _OOHG_ActiveControlVCenter     := .F.    ;;
      _OOHG_ActiveControlOnDblClick  := NIL

#xcommand VCENTERALIGN <vcenter> ;
   => ;
      _OOHG_ActiveControlVCenter := <vcenter>

#xcommand CENTERALIGN <center> ;
   => ;
      _OOHG_ActiveControlAlignment := "CENTER" ;;
      _OOHG_ActiveControlCenter := <center>

#xcommand VCENTER <vcenter> ;
   => ;
      _OOHG_ActiveControlVCenter := <vcenter>

#xcommand ALIGNMENT VCENTER ;
   => ;
      _OOHG_ActiveControlVCenter := .T.

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
            _OOHG_ActiveControlRight, ;
            _OOHG_ActiveControlCenter, ;
            _OOHG_ActiveControlRtl, ;
            _OOHG_ActiveControlNoWordWrap, ;
            _OOHG_ActiveControlNoPrefix, ;
            _OOHG_ActiveControlInputMask, ;
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlVCenter, ;
            _OOHG_ActiveControlOnDblClick )

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
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlFontColor, ;
            _OOHG_ActiveControlBackColor )

/*---------------------------------------------------------------------------
GRID
---------------------------------------------------------------------------*/

#xcommand DEFINE GRID <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )   ;;
      _OOHG_ActiveControlHeaders          := NIL ;;
      _OOHG_ActiveControlWidths           := NIL ;;
      _OOHG_ActiveControlItems            := NIL ;;
      _OOHG_ActiveControlOnHeadClick      := NIL ;;
      _OOHG_ActiveControlNoLines          := .F. ;;
      _OOHG_ActiveControlImage            := NIL ;;
      _OOHG_ActiveControlJustify          := NIL ;;
      _OOHG_ActiveControlMultiSelect      := .F. ;;
      _OOHG_ActiveControlEdit             := .F. ;;
      _OOHG_ActiveControlBreak            := .F. ;;
      _OOHG_ActiveControlOnQueryData      := NIL ;;
      _OOHG_ActiveControlItemCount        := NIL ;;
      _OOHG_ActiveControlReadOnly         := NIL ;;
      _OOHG_ActiveControlVirtual          := .F. ;;
      _OOHG_ActiveControlInputMask        := NIL ;;
      _OOHG_ActiveControlOnAppend         := NIL ;;
      _OOHG_ActiveControlInPlaceEdit      := .F. ;;
      _OOHG_ActiveControlDynamicBackColor := NIL ;;
      _OOHG_ActiveControlDynamicForeColor := NIL ;;
      _OOHG_ActiveControlEditControls     := NIL ;;
      _OOHG_ActiveControlValid            := NIL ;;
      _OOHG_ActiveControlValidMessages    := NIL ;;
      _OOHG_ActiveControlEditCell         := NIL ;;
      _OOHG_ActiveControlEditCellEnd      := NIL ;;
      _OOHG_ActiveControlBeforeEditCell   := NIL ;;
      _OOHG_ActiveControlWhen             := NIL ;;
      _OOHG_ActiveControlShowHeaders      := NIL ;;
      _OOHG_ActiveControlHeaderImages     := NIL ;;
      _OOHG_ActiveControlImagesAlign      := NIL ;;
      _OOHG_ActiveControlFullMove         := .F. ;;
      _OOHG_ActiveControlByCell           := .F. ;;
      _OOHG_ActiveControlSelectedColors   := .F. ;;
      _OOHG_ActiveControlKeys             := NIL ;;
      _OOHG_ActiveControlCheckBoxes       := .F. ;;
      _OOHG_ActiveControlOnCheckChange    := NIL ;;
      _OOHG_ActiveControlDblBffer         := .T. ;;
      _OOHG_ActiveControlSngBffer         := .F. ;;
      _OOHG_ActiveControlPaintLeftMargin  := .F. ;;
      _OOHG_ActiveControlFocusRect        := .F. ;;
      _OOHG_ActiveControlNoFocusRect      := .F. ;;
      _OOHG_ActiveControlFixedCols        := .F. ;;
      _OOHG_ActiveControlAbortEdit        := NIL ;;
      _OOHG_ActiveControlAction           := NIL ;;
      _OOHG_ActiveControlFixedWidths      := .F. ;;
      _OOHG_ActiveControlBeforeColMove    := NIL ;;
      _OOHG_ActiveControlAfterColMove     := NIL ;;
      _OOHG_ActiveControlBeforeColSize    := NIL ;;
      _OOHG_ActiveControlAfterColSize     := NIL ;;
      _OOHG_ActiveControlBeforeAutoFit    := NIL ;;
      _OOHG_ActiveControlEditLikeExcel    := NIL ;;
      _OOHG_ActiveControlUseButtons       := NIL ;;
      _OOHG_ActiveControlNoDeleteMsg      := .F. ;;
      _OOHG_ActiveControlAppendable       := .F. ;;
      _OOHG_ActiveControlNoModalEdit      := .F. ;;
      _OOHG_ActiveControlFixedCtrls       := .F. ;;
      _OOHG_ActiveControlDynamicCtrls     := .F. ;;
      _OOHG_ActiveControlOnHeaderRClick   := NIL ;;
      _OOHG_ActiveControlRClickOnCheckbox := .T. ;;
      _OOHG_ActiveControlClickOnCheckbox  := .T. ;;
      _OOHG_ActiveControlExtDblClick      := .F. ;;
      _OOHG_ActiveControlDelete           := .F. ;;
      _OOHG_ActiveControlOnDelete         := NIL ;;
      _OOHG_ActiveControlDeleteWhen       := NIL ;;
      _OOHG_ActiveControlDeleteMsg        := NIL ;;
      _OOHG_ActiveControlAutoPlay         := .F. ;;
      _OOHG_ActiveControlAddress          := .F. ;;
      _OOHG_ActiveControlShowAll          := .F. ;;
      _OOHG_ActiveControlAutoSkip         := .F. ;;
      _OOHG_ActiveControlDisplayChange    := NIL ;;
      _OOHG_ActiveControlOnRClick         := NIL ;;
      _OOHG_ActiveControlOnInsert         := NIL ;;
      _OOHG_ActiveControlDisplayEdit      := .T. ;;
      _OOHG_ActiveControlEditCellValue    := NIL ;;
      _OOHG_ActiveControlKeysLikeClipper  := .F. ;;
      _OOHG_ActiveControlCellToolTip      := .F. ;;
      _OOHG_ActiveControlNoHScroll        := .F. ;;
      _OOHG_ActiveControlNoVScroll        := .F. ;;
      _OOHG_ActiveControlOnBeforeInsert   := NIL ;;
      _OOHG_ActiveControlOnHeadDblClick   := NIL ;;
      _OOHG_ActiveControlHeaderColors     := NIL ;;
      _OOHG_ActiveControlTimeOut          := NIL

#xcommand TIMEOUT <timeout> ;
   => ;
      _OOHG_ActiveControlTimeOut := <timeout>

#xcommand SILENT <silent> ;
   => ;
      _OOHG_ActiveControlAutoPlay := <silent>

#xcommand ENABLEALTA <alta> ;
   => ;
      _OOHG_ActiveControlAddress := <alta>

#xcommand DISABLEALTA <alta> ;
   => ;
      _OOHG_ActiveControlAddress := ! ( <alta> )

#xcommand NOSHOWALWAYS <show> ;
   => ;
      _OOHG_ActiveControlShowAll := <show>

#xcommand NONEUNSELS <noneunsels> ;
   => ;
      _OOHG_ActiveControlAutoSkip := <noneunsels>

#xcommand IGNORENONE <ignorenone> ;
   => ;
      _OOHG_ActiveControlAutoSkip := ! ( <ignorenone> )

#xcommand ONAPPEND <onappend> ;
   => ;
      _OOHG_ActiveControlOnAppend := <onappend>

#xcommand ON APPEND <onappend> ;
   => ;
      _OOHG_ActiveControlOnAppend := <onappend>

#xcommand HEADERCOLORS <aHeaderColors> ;
   => ;
      _OOHG_ActiveControlHeaderColors:= <aHeaderColors>

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

#xcommand ONBEFOREINSERT <beforeinsert> ;
   => ;
      _OOHG_ActiveControlOnBeforeInsert := <{beforeinsert}>

#xcommand ON BEFOREINSERT <beforeinsert> ;
   => ;
      _OOHG_ActiveControlOnBeforeInsert := <{beforeinsert}>

#xcommand ONHEADDBLCLICK <aHeadDblClick> ;
   => ;
      _OOHG_ActiveControlOnHeadDblClick := <aHeadDblClick>

#xcommand ON HEADDBLCLICK <aHeadDblClick> ;
   => ;
      _OOHG_ActiveControlOnHeadDblClick := <aHeadDblClick>

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

#xcommand NOMODALEDIT <nomodal> ;
   => ;
      _OOHG_ActiveControlNoModalEdit := <nomodal>

#xcommand FIXEDCONTROLS <fixed> ;
   => ;
      _OOHG_ActiveControlFixedCtrls := <fixed>

#xcommand DYNAMICCONTROLS <dynamic> ;
   => ;
      _OOHG_ActiveControlDynamicCtrls := <dynamic>

#xcommand ONHEADRCLICK <bheadrclick> ;
   => ;
      _OOHG_ActiveControlOnHeaderRClick := <{bheadrclick}>

#xcommand ON HEADRCLICK <bheadrclick> ;
   => ;
      _OOHG_ActiveControlOnHeaderRClick := <{bheadrclick}>

#xcommand NOCLICKONCHECKBOX <noclick> ;
   => ;
      _OOHG_ActiveControlClickOnCheckbox := ! ( <noclick> )

#xcommand NORCLICKONCHECKBOX <norclick> ;
   => ;
      _OOHG_ActiveControlRClickOnCheckbox := ! ( <norclick> )

#xcommand EXTDBLCLICK <extdbl> ;
   => ;
      _OOHG_ActiveControlExtDblClick := <extdbl>

#xcommand CHANGEBEFOREEDIT <cbe> ;
   => ;
      _OOHG_ActiveControlDisplayChange := <cbe>

#xcommand ONRCLICK <action> ;
   => ;
      _OOHG_ActiveControlOnRClick := <{action}>

#xcommand ON RCLICK <action> ;
   => ;
      _OOHG_ActiveControlOnRClick := <{action}>

#xcommand ONINSERT <action> ;
   => ;
      _OOHG_ActiveControlOnInsert := <{action}>

#xcommand ON INSERT <action> ;
   => ;
      _OOHG_ActiveControlOnInsert := <{action}>

#xcommand EDITFIRSTVISIBLE <efv> ;
   => ;
      _OOHG_ActiveControlDisplayEdit := ! ( <efv> )

#xcommand EDITCELLVALUE <edtval> ;
   => ;
      _OOHG_ActiveControlEditCellValue := <{edtval}>

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
            iif( _OOHG_ActiveControlDblBffer, .T., iif( _OOHG_ActiveControlSngBffer, .F., .T. ) ), ;
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
            _OOHG_ActiveControlDelete, ;
            _OOHG_ActiveControlOnDelete, ;
            _OOHG_ActiveControlDeleteWhen, ;
            _OOHG_ActiveControlDeleteMsg, ;
            _OOHG_ActiveControlNoDeleteMsg, ;
            _OOHG_ActiveControlAppendable, ;
            _OOHG_ActiveControlOnAppend, ;
            _OOHG_ActiveControlNoModalEdit, ;
            iif( _OOHG_ActiveControlFixedCtrls, .T., iif( _OOHG_ActiveControlDynamicCtrls, .F., NIL ) ), ;
            _OOHG_ActiveControlOnHeaderRClick, ;
            _OOHG_ActiveControlClickOnCheckbox, ;
            _OOHG_ActiveControlRClickOnCheckbox, ;
            _OOHG_ActiveControlExtDblClick, ;
            _OOHG_ActiveControlAutoPlay, ;
            _OOHG_ActiveControlAddress, ;
            _OOHG_ActiveControlShowAll, ;
            _OOHG_ActiveControlAutoSkip, ;
            _OOHG_ActiveControlDisplayChange, ;
            _OOHG_ActiveControlOnRClick, ;
            _OOHG_ActiveControlOnInsert, ;
            _OOHG_ActiveControlEditCellEnd, ;
            _OOHG_ActiveControlDisplayEdit, ;
            _OOHG_ActiveControlBeforeEditCell, ;
            _OOHG_ActiveControlEditCellValue, ;
            _OOHG_ActiveControlKeysLikeClipper, ;
            _OOHG_ActiveControlCellToolTip, ;
            _OOHG_ActiveControlNoHScroll, ;
            _OOHG_ActiveControlNoVScroll, ;
            _OOHG_ActiveControlOnBeforeInsert, ;
            _OOHG_ActiveControlOnHeadDblClick, ;
            _OOHG_ActiveControlHeaderColors, ;
            _OOHG_ActiveControlTimeOut )

/*---------------------------------------------------------------------------
BROWSE
---------------------------------------------------------------------------*/

#xcommand DEFINE BROWSE <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )   ;;
      _OOHG_ActiveControlHeaders          := NIL ;;
      _OOHG_ActiveControlWidths           := NIL ;;
      _OOHG_ActiveControlOnHeadClick      := NIL ;;
      _OOHG_ActiveControlNoLines          := .F. ;;
      _OOHG_ActiveControlImage            := NIL ;;
      _OOHG_ActiveControlJustify          := NIL ;;
      _OOHG_ActiveControlEdit             := .F. ;;
      _OOHG_ActiveControlBreak            := .F. ;;
      _OOHG_ActiveControlWorkArea         := NIL ;;
      _OOHG_ActiveControlFields           := NIL ;;
      _OOHG_ActiveControlDelete           := .F. ;;
      _OOHG_ActiveControlAppendable       := .F. ;;
      _OOHG_ActiveControlValid            := NIL ;;
      _OOHG_ActiveControlReadOnly         := NIL ;;
      _OOHG_ActiveControlLock             := .F. ;;
      _OOHG_ActiveControlValidMessages    := NIL ;;
      _OOHG_ActiveControlNoVScroll        := .F. ;;
      _OOHG_ActiveControlInputMask        := NIL ;;
      _OOHG_ActiveControlInPlaceEdit      := .F. ;;
      _OOHG_ActiveControlDynamicBackColor := NIL ;;
      _OOHG_ActiveControlDynamicForeColor := NIL ;;
      _OOHG_ActiveControlWhen             := NIL ;;
      _OOHG_ActiveControlOnAppend         := NIL ;;
      _OOHG_ActiveControlEditCell         := NIL ;;
      _OOHG_ActiveControlEditCellEnd      := NIL ;;
      _OOHG_ActiveControlBeforeEditCell   := NIL ;;
      _OOHG_ActiveControlEditControls     := NIL ;;
      _OOHG_ActiveControlReplaceFields    := NIL ;;
      _OOHG_ActiveControlShowHeaders      := NIL ;;
      _OOHG_ActiveControlDeleteWhen       := NIL ;;
      _OOHG_ActiveControlDeleteMsg        := NIL ;;
      _OOHG_ActiveControlOnDelete         := NIL ;;
      _OOHG_ActiveControlColumnInfo       := NIL ;;
      _OOHG_ActiveControlDescending       := .F. ;;
      _OOHG_ActiveControlRecCount         := .F. ;;
      _OOHG_ActiveControlHeaderImages     := NIL ;;
      _OOHG_ActiveControlImagesAlign      := NIL ;;
      _OOHG_ActiveControlFullMove         := .F. ;;
      _OOHG_ActiveControlSelectedColors   := .F. ;;
      _OOHG_ActiveControlKeys             := NIL ;;
      _OOHG_ActiveControlForceRefresh     := .F. ;;
      _OOHG_ActiveControlNoRefresh        := .F. ;;
      _OOHG_ActiveControlDblBffer         := .T. ;;
      _OOHG_ActiveControlSngBffer         := .F. ;;
      _OOHG_ActiveControlPaintLeftMargin  := .F. ;;
      _OOHG_ActiveControlFocusRect        := .F. ;;
      _OOHG_ActiveControlNoFocusRect      := .F. ;;
      _OOHG_ActiveControlSynchronized     := .F. ;;
      _OOHG_ActiveControlUnSynchronized   := .F. ;;
      _OOHG_ActiveControlFixedCols        := .F. ;;
      _OOHG_ActiveControlNoDeleteMsg      := .F. ;;
      _OOHG_ActiveControlUpdateAll        := .F. ;;
      _OOHG_ActiveControlAbortEdit        := NIL ;;
      _OOHG_ActiveControlAction           := NIL ;;
      _OOHG_ActiveControlFixedWidths      := .F. ;;
      _OOHG_ActiveControlFixedBlocks      := .F. ;;
      _OOHG_ActiveControlDynamicBlocks    := .F. ;;
      _OOHG_ActiveControlBeforeColMove    := NIL ;;
      _OOHG_ActiveControlAfterColMove     := NIL ;;
      _OOHG_ActiveControlBeforeColSize    := NIL ;;
      _OOHG_ActiveControlAfterColSize     := NIL ;;
      _OOHG_ActiveControlBeforeAutoFit    := NIL ;;
      _OOHG_ActiveControlEditLikeExcel    := NIL ;;
      _OOHG_ActiveControlUseButtons       := NIL ;;
      _OOHG_ActiveControlUpdateColors     := NIL ;;
      _OOHG_ActiveControlFixedCtrls       := .F. ;;
      _OOHG_ActiveControlDynamicCtrls     := .F. ;;
      _OOHG_ActiveControlOnHeaderRClick   := NIL ;;
      _OOHG_ActiveControlExtDblClick      := .F. ;;
      _OOHG_ActiveControlNoModalEdit      := .F. ;;
      _OOHG_ActiveControlByCell           := .F. ;;
      _OOHG_ActiveControlAutoPlay         := .F. ;;
      _OOHG_ActiveControlAddress          := .T. ;;
      _OOHG_ActiveControlShowAll          := .F. ;;
      _OOHG_ActiveControlAutoSkip         := .F. ;;
      _OOHG_ActiveControlDisplayChange    := NIL ;;
      _OOHG_ActiveControlOnRClick         := NIL ;;
      _OOHG_ActiveControlCheckBoxes       := .F. ;;
      _OOHG_ActiveControlOnCheckChange    := NIL ;;
      _OOHG_ActiveControlOnTextFilled     := NIL ;;
      _OOHG_ActiveControlDefaultYear      := NIL ;;
      _OOHG_ActiveControlDisplayEdit      := .T. ;;
      _OOHG_ActiveControlEditCellValue    := NIL ;;
      _OOHG_ActiveControlKeysLikeClipper  := .F. ;;
      _OOHG_ActiveControlCellToolTip      := .F. ;;
      _OOHG_ActiveControlNoHScroll        := .F. ;;
      _OOHG_ActiveControlOnHeadDblClick   := NIL ;;
      _OOHG_ActiveControlHeaderColors     := NIL ;;
      _OOHG_ActiveControlTimeOut          := NIL ;;
      _OOHG_ActiveControlNewAtRow         := NIL

#xcommand NEWATROW <nRow> ;
   => ;
      _OOHG_ActiveControlNewAtRow := <nRow>

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

#xcommand REFRESH <refresh> ;
   => ;
      _OOHG_ActiveControlRefresh := <refresh>

#xcommand SYNCHRONIZED <sync> ;
   => ;
      _OOHG_ActiveControlSynchronized := <sync>

#xcommand UNSYNCHRONIZED <sync> ;
   => ;
      _OOHG_ActiveControlUnSynchronized := <sync>

#xcommand NODELETEMSG <nodeletemsg> ;
   => ;
      _OOHG_ActiveControlNoDeleteMsg := <nodeletemsg>

#xcommand UPDATEALL <updall> ;
   => ;
      _OOHG_ActiveControlUpdateAll := <updall>

#xcommand FIXEDBLOCKS <fixedblocks> ;
   => ;
      _OOHG_ActiveControlFixedBlocks := <fixedblocks>

#xcommand DYNAMICBLOCKS <dynamicblocks> ;
   => ;
      _OOHG_ActiveControlDynamicBlocks := <dynamicblocks>

#xcommand UPDATECOLORS <upcols> ;
   => ;
      _OOHG_ActiveControlUpdateColors := <upcols>

#xcommand ONROWREFRESH <block> ;
   => ;
      _OOHG_ActiveControlOnTextFilled := <{block}>

#xcommand ON ROWREFRESH <block> ;
   => ;
      _OOHG_ActiveControlOnTextFilled := <{block}>

#xcommand DEFAULTVALUES <aDefVal> ;
   => ;
      _OOHG_ActiveControlDefaultYear := <aDefVal>

#xcommand KEYSLIKECLIPPER <klc> ;
   => ;
      _OOHG_ActiveControlKeysLikeClipper := <klc>

#xcommand CELLTOOLTIP <ctt> ;
   => ;
      _OOHG_ActiveControlCellToolTip := <ctt>

#xcommand END BROWSE ;
   => ;
      _OOHG_SelectSubClass( iif( _OOHG_ActiveControlByCell, TOBrowseByCell(), TOBrowse() ), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
            _OOHG_ActiveControlName, ;
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
            iif( _OOHG_ActiveControlForceRefresh, 0, iif( _OOHG_ActiveControlNoRefresh, 1, NIL ) ), ;
            iif( _OOHG_ActiveControlDblBffer, .T., iif( _OOHG_ActiveControlSngBffer, .F., .T. ) ), ;
            iif( _OOHG_ActiveControlNoFocusRect, .F., iif( _OOHG_ActiveControlFocusRect, .T., NIL ) ), ;
            _OOHG_ActiveControlPaintLeftMargin, ;
            iif( _OOHG_ActiveControlUnSynchronized, .F., iif( _OOHG_ActiveControlSynchronized, .T., NIL ) ), ;
            _OOHG_ActiveControlFixedCols, ;
            _OOHG_ActiveControlNoDeleteMsg, ;
            _OOHG_ActiveControlUpdateAll, ;
            _OOHG_ActiveControlAbortEdit, ;
            _OOHG_ActiveControlAction, ;
            _OOHG_ActiveControlFixedWidths, ;
            iif( _OOHG_ActiveControlFixedBlocks, .T., iif( _OOHG_ActiveControlDynamicBlocks, .F., NIL ) ), ;
            _OOHG_ActiveControlBeforeColMove, ;
            _OOHG_ActiveControlAfterColMove, ;
            _OOHG_ActiveControlBeforeColSize, ;
            _OOHG_ActiveControlAfterColSize, ;
            _OOHG_ActiveControlBeforeAutoFit, ;
            _OOHG_ActiveControlEditLikeExcel, ;
            _OOHG_ActiveControlUseButtons, ;
            _OOHG_ActiveControlUpdateColors, ;
            iif( _OOHG_ActiveControlFixedCtrls, .T., iif( _OOHG_ActiveControlDynamicCtrls, .F., NIL ) ), ;
            _OOHG_ActiveControlOnHeaderRClick, ;
            _OOHG_ActiveControlExtDblClick, ;
            _OOHG_ActiveControlNoModalEdit, ;
            _OOHG_ActiveControlAutoPlay, ;
            _OOHG_ActiveControlAddress, ;
            _OOHG_ActiveControlShowAll, ;
            _OOHG_ActiveControlAutoSkip, ;
            _OOHG_ActiveControlDisplayChange, ;
            _OOHG_ActiveControlOnRClick, ;
            _OOHG_ActiveControlCheckBoxes, ;
            _OOHG_ActiveControlOnCheckChange, ;
            _OOHG_ActiveControlOnTextFilled, ;
            _OOHG_ActiveControlDefaultYear, ;
            _OOHG_ActiveControlEditCellEnd, ;
            _OOHG_ActiveControlDisplayEdit, ;
            _OOHG_ActiveControlBeforeEditCell, ;
            _OOHG_ActiveControlEditCellValue, ;
            _OOHG_ActiveControlKeysLikeClipper, ;
            _OOHG_ActiveControlCellToolTip, ;
            _OOHG_ActiveControlNoHScroll, ;
            _OOHG_ActiveControlOnHeadDblClick, ;
            _OOHG_ActiveControlHeaderColors, ;
            _OOHG_ActiveControlTimeOut, ;
            _OOHG_ActiveControlNewAtRow )

/*---------------------------------------------------------------------------
XBROWSE
---------------------------------------------------------------------------*/

#xcommand DEFINE XBROWSE <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )   ;;
      _OOHG_ActiveControlHeaders          := NIL ;;
      _OOHG_ActiveControlWidths           := NIL ;;
      _OOHG_ActiveControlOnHeadClick      := NIL ;;
      _OOHG_ActiveControlNoLines          := .F. ;;
      _OOHG_ActiveControlImage            := NIL ;;
      _OOHG_ActiveControlJustify          := NIL ;;
      _OOHG_ActiveControlEdit             := .F. ;;
      _OOHG_ActiveControlBreak            := .F. ;;
      _OOHG_ActiveControlWorkArea         := NIL ;;
      _OOHG_ActiveControlFields           := NIL ;;
      _OOHG_ActiveControlDelete           := .F. ;;
      _OOHG_ActiveControlAppendable       := .F. ;;
      _OOHG_ActiveControlValid            := NIL ;;
      _OOHG_ActiveControlReadOnly         := NIL ;;
      _OOHG_ActiveControlLock             := .F. ;;
      _OOHG_ActiveControlValidMessages    := NIL ;;
      _OOHG_ActiveControlNoVScroll        := .F. ;;
      _OOHG_ActiveControlInputMask        := NIL ;;
      _OOHG_ActiveControlInPlaceEdit      := .F. ;;
      _OOHG_ActiveControlDynamicBackColor := NIL ;;
      _OOHG_ActiveControlDynamicForeColor := NIL ;;
      _OOHG_ActiveControlWhen             := NIL ;;
      _OOHG_ActiveControlOnAppend         := NIL ;;
      _OOHG_ActiveControlEditCell         := NIL ;;
      _OOHG_ActiveControlEditCellEnd      := NIL ;;
      _OOHG_ActiveControlBeforeEditCell   := NIL ;;
      _OOHG_ActiveControlEditControls     := NIL ;;
      _OOHG_ActiveControlReplaceFields    := NIL ;;
      _OOHG_ActiveControlShowHeaders      := NIL ;;
      _OOHG_ActiveControlDeleteWhen       := NIL ;;
      _OOHG_ActiveControlDeleteMsg        := NIL ;;
      _OOHG_ActiveControlOnDelete         := NIL ;;
      _OOHG_ActiveControlColumnInfo       := NIL ;;
      _OOHG_ActiveControlDescending       := .F. ;;
      _OOHG_ActiveControlRecCount         := .F. ;;
      _OOHG_ActiveControlHeaderImages     := NIL ;;
      _OOHG_ActiveControlImagesAlign      := NIL ;;
      _OOHG_ActiveControlFullMove         := .F. ;;
      _OOHG_ActiveControlSelectedColors   := .F. ;;
      _OOHG_ActiveControlKeys             := NIL ;
      _OOHG_ActiveControlDblBffer         := .T. ;;
      _OOHG_ActiveControlSngBffer         := .F. ;;
      _OOHG_ActiveControlPaintLeftMargin  := .F. ;;
      _OOHG_ActiveControlFocusRect        := .F. ;;
      _OOHG_ActiveControlNoFocusRect      := .F. ;;
      _OOHG_ActiveControlFixedCols        := .F. ;;
      _OOHG_ActiveControlAbortEdit        := NIL ;;
      _OOHG_ActiveControlAction           := NIL ;;
      _OOHG_ActiveControlFixedWidths      := .F. ;;
      _OOHG_ActiveControlFixedBlocks      := .F. ;;
      _OOHG_ActiveControlDynamicBlocks    := .F. ;;
      _OOHG_ActiveControlBeforeColMove    := NIL ;;
      _OOHG_ActiveControlAfterColMove     := NIL ;;
      _OOHG_ActiveControlBeforeColSize    := NIL ;;
      _OOHG_ActiveControlAfterColSize     := NIL ;;
      _OOHG_ActiveControlBeforeAutoFit    := NIL ;;
      _OOHG_ActiveControlEditLikeExcel    := NIL ;;
      _OOHG_ActiveControlUseButtons       := NIL ;;
      _OOHG_ActiveControlNoDeleteMsg      := .F. ;;
      _OOHG_ActiveControlFixedCtrls       := .F. ;;
      _OOHG_ActiveControlDynamicCtrls     := .F. ;;
      _OOHG_ActiveControlNoShowEmptyRow   := .F. ;;
      _OOHG_ActiveControlUpdateColors     := .F. ;;
      _OOHG_ActiveControlOnHeaderRClick   := NIL ;;
      _OOHG_ActiveControlExtDblClick      := .F. ;;
      _OOHG_ActiveControlNoModalEdit      := .F. ;;
      _OOHG_ActiveControlAutoPlay         := .F. ;;
      _OOHG_ActiveControlAddress          := .T. ;;
      _OOHG_ActiveControlShowAll          := .F. ;;
      _OOHG_ActiveControlDisplayChange    := NIL ;;
      _OOHG_ActiveControlOnRClick         := NIL ;;
      _OOHG_ActiveControlCheckBoxes       := .F. ;;
      _OOHG_ActiveControlOnCheckChange    := NIL ;;
      _OOHG_ActiveControlOnTextFilled     := NIL ;;
      _OOHG_ActiveControlDefaultYear      := NIL ;;
      _OOHG_ActiveControlDisplayEdit      := .T. ;;
      _OOHG_ActiveControlEditCellValue    := NIL ;;
      _OOHG_ActiveControlKeysLikeClipper  := .F. ;;
      _OOHG_ActiveControlCellToolTip      := .F. ;;
      _OOHG_ActiveControlNoHScroll        := .F. ;;
      _OOHG_ActiveControlOnHeadDblClick   := NIL ;;
      _OOHG_ActiveControlHeaderColors     := NIL ;;
      _OOHG_ActiveControlTimeOut          := NIL

#xcommand END XBROWSE ;
   => ;
      _OOHG_SelectSubClass( iif( _OOHG_ActiveControlByCell, TXBrowseByCell(), TXBrowse() ), _OOHG_ActiveControlSubClass, _OOHG_ActiveControlAssignObject ):Define( ;
            _OOHG_ActiveControlName, ;
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
            iif( _OOHG_ActiveControlDblBffer, .T., iif( _OOHG_ActiveControlSngBffer, .F., .T. ) ), ;
            iif( _OOHG_ActiveControlNoFocusRect, .F., iif( _OOHG_ActiveControlFocusRect, .T., NIL ) ), ;
            _OOHG_ActiveControlPaintLeftMargin, ;
            _OOHG_ActiveControlFixedCols, ;
            _OOHG_ActiveControlAbortEdit, ;
            _OOHG_ActiveControlAction, ;
            _OOHG_ActiveControlFixedWidths, ;
            iif( _OOHG_ActiveControlFixedBlocks, .T., iif( _OOHG_ActiveControlDynamicBlocks, .F., NIL ) ), ;
            _OOHG_ActiveControlBeforeColMove, ;
            _OOHG_ActiveControlAfterColMove, ;
            _OOHG_ActiveControlBeforeColSize, ;
            _OOHG_ActiveControlAfterColSize, ;
            _OOHG_ActiveControlBeforeAutoFit, ;
            _OOHG_ActiveControlEditLikeExcel, ;
            _OOHG_ActiveControlUseButtons, ;
            _OOHG_ActiveControlNoDeleteMsg, ;
            iif( _OOHG_ActiveControlFixedCtrls, .T., iif( _OOHG_ActiveControlDynamicCtrls, .F., NIL ) ), ;
            _OOHG_ActiveControlNoShowEmptyRow, ;
            _OOHG_ActiveControlUpdateColors, ;
            _OOHG_ActiveControlOnHeaderRClick, ;
            _OOHG_ActiveControlNoModalEdit, ;
            _OOHG_ActiveControlExtDblClick, ;
            _OOHG_ActiveControlAutoPlay, ;
            _OOHG_ActiveControlAddress, ;
            _OOHG_ActiveControlShowAll, ;
            _OOHG_ActiveControlOnRClick, ;
            _OOHG_ActiveControlCheckBoxes, ;
            _OOHG_ActiveControlOnCheckChange, ;
            _OOHG_ActiveControlOnTextFilled, ;
            _OOHG_ActiveControlDefaultYear, ;
            _OOHG_ActiveControlEditCellEnd, ;
            _OOHG_ActiveControlDisplayEdit, ;
            _OOHG_ActiveControlBeforeEditCell, ;
            _OOHG_ActiveControlEditCellValue, ;
            _OOHG_ActiveControlKeysLikeClipper, ;
            _OOHG_ActiveControlCellToolTip, ;
            _OOHG_ActiveControlNoHScroll, ;
            _OOHG_ActiveControlOnHeadDblClick, ;
            _OOHG_ActiveControlHeaderColors, ;
            _OOHG_ActiveControlTimeOut )

/*---------------------------------------------------------------------------
HYPERLINK
---------------------------------------------------------------------------*/

#xcommand DEFINE HYPERLINK <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlAddress     := NIL    ;;
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

/*---------------------------------------------------------------------------
SPINNER
---------------------------------------------------------------------------*/

#xcommand DEFINE SPINNER <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlRangeLow     := NIL   ;;
      _OOHG_ActiveControlRangeHigh    := NIL   ;;
      _OOHG_ActiveControlWrap         := .F.   ;;
      _OOHG_ActiveControlReadOnly     := .F.   ;;
      _OOHG_ActiveControlIncrement    := NIL   ;;
      _OOHG_ActiveControlNoBorder     := .F.   ;;
      _OOHG_ActiveControlOnTextFilled := .F.   ;;
      _OOHG_ActiveControlCueBanner    := NIL

#xcommand WRAP <wrap> ;
   => ;
      _OOHG_ActiveControlWrap := <wrap>

#xcommand INCREMENT <increment> ;
   => ;
      _OOHG_ActiveControlIncrement := <increment>

#xcommand BOUNDTEXT <bound> ;
   => ;
      _OOHG_ActiveControlOnTextFilled := <bound>

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
            _OOHG_ActiveControlNoBorder, ;
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlOnTextFilled, ;
            _OOHG_ActiveControlCueBanner )

/*---------------------------------------------------------------------------
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
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlInvisible )

/*---------------------------------------------------------------------------
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
            ! _OOHG_ActiveControlForceAlt )

/*---------------------------------------------------------------------------
PICTURE
---------------------------------------------------------------------------*/

#xcommand DEFINE PICTURE <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> )    ;;
      _OOHG_ActiveControlPicture           := NIL ;;
      _OOHG_ActiveControlImagesize         := .F. ;;
      _OOHG_ActiveControlBuffer            := NIL ;;
      _OOHG_ActiveControlHBitmap           := NIL ;;
      _OOHG_ActiveControlAction            := NIL ;;
      _OOHG_ActiveControlClientEdge        := .F. ;;
      _OOHG_ActiveControlImagesize         := .F. ;;
      _OOHG_ActiveControlBorder            := .F. ;;
      _OOHG_ActiveControlAutoFit           := .F. ;;
      _OOHG_ActiveControlStretch           := .F. ;;
      _OOHG_ActiveControlNoDIBSection      := .F. ;;
      _OOHG_ActiveControlNo3DColors        := .F. ;;
      _OOHG_ActiveControlNoLoadTransparent := .F. ;;
      _OOHG_ActiveControlTransparent       := .F. ;;
      _OOHG_ActiveControlExcludeArea       := NIL

#xcommand ICON <icon> ;
   => ;
      _OOHG_ActiveControlPicture := <icon>

#xcommand FORCESCALE <autofit> ;
   => ;
      _OOHG_ActiveControlAutoFit := <autofit>

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
            _OOHG_ActiveControlAutoFit, ;
            _OOHG_ActiveControlImagesize, ;
            _OOHG_ActiveControlBorder, ;
            _OOHG_ActiveControlClientEdge, ;
            _OOHG_ActiveControlBackColor, ;
            _OOHG_ActiveControlAction, ;
            _OOHG_ActiveControlTooltip, ;
            _OOHG_ActiveControlHelpId, ;
            _OOHG_ActiveControlRtl, ;
            _OOHG_ActiveControlInvisible, ;
            _OOHG_ActiveControlNoLoadTransparent, ;
            _OOHG_ActiveControlNo3DColors, ;
            _OOHG_ActiveControlNoDIBSection, ;
            _OOHG_ActiveControlTransparent, ;
            _OOHG_ActiveControlExcludeArea, ;
            _OOHG_ActiveControlDisabled )

/*---------------------------------------------------------------------------
PROGRESSMETER
---------------------------------------------------------------------------*/

#xcommand DEFINE PROGRESSMETER <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlRangeLow   := NIL     ;;
      _OOHG_ActiveControlRangeHigh  := NIL     ;;
      _OOHG_ActiveControlForeColor  := NIL     ;;
      _OOHG_ActiveControlAction     := NIL     ;;
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
            _OOHG_ActiveControlClientEdge, ;
            _OOHG_ActiveControlDisabled )

/*---------------------------------------------------------------------------
SCROLLBAR
---------------------------------------------------------------------------*/

#xcommand DEFINE SCROLLBAR <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlRangeLow   := NIL     ;;
      _OOHG_ActiveControlRangeHigh  := NIL     ;;
      _OOHG_ActiveControlOnLineUp   := NIL     ;;
      _OOHG_ActiveControlOnLineDown := NIL     ;;
      _OOHG_ActiveControlOnPageUp   := NIL     ;;
      _OOHG_ActiveControlOnPageDown := NIL     ;;
      _OOHG_ActiveControlOnTop      := NIL     ;;
      _OOHG_ActiveControlOnBottom   := NIL     ;;
      _OOHG_ActiveControlOnThumb    := NIL     ;;
      _OOHG_ActiveControlOnTrack    := NIL     ;;
      _OOHG_ActiveControlOnEndTrack := NIL     ;;
      _OOHG_ActiveControlAttached   := NIL     ;;
      _OOHG_ActiveControlLineSkip   := NIL     ;;
      _OOHG_ActiveControlPageSkip   := NIL     ;;
      _OOHG_ActiveControlAutoMove   := NIL     ;;
      _OOHG_ActiveControlVertical   := .F.     ;;
      _OOHG_ActiveControlHorizontal := .F.

#xcommand ONLINEUP <lineup> ;
   => ;
      _OOHG_ActiveControlOnLineUp := <{lineup}>

#xcommand ON LINEUP <lineup> ;
   => ;
      _OOHG_ActiveControlOnLineUp := <{lineup}>

#xcommand ONLINELEFT <lineup> ;
   => ;
      _OOHG_ActiveControlOnLineUp := <{lineup}>

#xcommand ON LINELEFT <lineup> ;
   => ;
      _OOHG_ActiveControlOnLineUp := <{lineup}>

#xcommand ONLINEDOWN <linedown> ;
   => ;
      _OOHG_ActiveControlOnLineDown := <{linedown}>

#xcommand ON LINEDOWN <linedown> ;
   => ;
      _OOHG_ActiveControlOnLineDown := <{linedown}>

#xcommand ONLINERIGHT <linedown> ;
   => ;
      _OOHG_ActiveControlOnLineDown := <{linedown}>

#xcommand ON LINERIGHT <linedown> ;
   => ;
      _OOHG_ActiveControlOnLineDown := <{linedown}>

#xcommand ONPAGEUP <pageup> ;
   => ;
      _OOHG_ActiveControlOnPageUp := <{pageup}>

#xcommand ON PAGEUP <pageup> ;
   => ;
      _OOHG_ActiveControlOnPageUp := <{pageup}>

#xcommand ONPAGELEFT <pageup> ;
   => ;
      _OOHG_ActiveControlOnPageUp := <{pageup}>

#xcommand ON PAGELEFT <pageup> ;
   => ;
      _OOHG_ActiveControlOnPageUp := <{pageup}>

#xcommand ONPAGEDOWN <pagedown> ;
   => ;
      _OOHG_ActiveControlOnPageDown := <{pagedown}>

#xcommand ON PAGEDOWN <pagedown> ;
   => ;
      _OOHG_ActiveControlOnPageDown := <{pagedown}>

#xcommand ONPAGERIGHT <pagedown> ;
   => ;
      _OOHG_ActiveControlOnPageDown := <{pagedown}>

#xcommand ON PAGERIGHT <pagedown> ;
   => ;
      _OOHG_ActiveControlOnPageDown := <{pagedown}>

#xcommand ONTOP <top> ;
   => ;
      _OOHG_ActiveControlOnTop := <{top}>

#xcommand ON TOP <top> ;
   => ;
      _OOHG_ActiveControlOnTop := <{top}>

#xcommand ONLEFT <top> ;
   => ;
      _OOHG_ActiveControlOnTop := <{top}>

#xcommand ON LEFT <top> ;
   => ;
      _OOHG_ActiveControlOnTop := <{top}>

#xcommand ONBOTTOM <bottom> ;
   => ;
      _OOHG_ActiveControlOnBottom := <{bottom}>

#xcommand ON BOTTOM <bottom> ;
   => ;
      _OOHG_ActiveControlOnBottom := <{bottom}>

#xcommand ON RIGHT <bottom> ;
   => ;
      _OOHG_ActiveControlOnBottom := <{bottom}>

#xcommand ONRIGHT <bottom> ;
   => ;
      _OOHG_ActiveControlOnBottom := <{bottom}>

#xcommand ONTHUMB <thumb> ;
   => ;
      _OOHG_ActiveControlOnThumb := <{thumb}>

#xcommand ON THUMB <thumb> ;
   => ;
      _OOHG_ActiveControlOnThumb := <{thumb}>

#xcommand ONTRACK <track> ;
   => ;
      _OOHG_ActiveControlOnTrack := <{track}>

#xcommand ON TRACK <track> ;
   => ;
      _OOHG_ActiveControlOnTrack := <{track}>

#xcommand ON ENDTRACK <endtrack> ;
   => ;
      _OOHG_ActiveControlOnEndTrack := <{endtrack}>

#xcommand ONENDTRACK <endtrack> ;
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
            iif( _OOHG_ActiveControlHorizontal, 0, iif( _OOHG_ActiveControlVertical, 1, NIL ) ), ;
            _OOHG_ActiveControlAttached, ;
            _OOHG_ActiveControlValue, ;
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlLineSkip, ;
            _OOHG_ActiveControlPageSkip, ;
            _OOHG_ActiveControlAutoMove )

/*---------------------------------------------------------------------------
TEXTARRAY
---------------------------------------------------------------------------*/

#xcommand DEFINE TEXTARRAY <name> ;
   => ;
      _OOHG_ClearActiveControlInfo( <(name)> ) ;;
      _OOHG_ActiveControlRowCount   := NIL     ;;
      _OOHG_ActiveControlColCount   := NIL     ;;
      _OOHG_ActiveControlBorder     := .F.     ;;
      _OOHG_ActiveControlClientEdge := .F.     ;;
      _OOHG_ActiveControlAction     := NIL

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
            _OOHG_ActiveControlDisabled, ;
            _OOHG_ActiveControlOnGotFocus, ;
            _OOHG_ActiveControlOnLostFocus )
