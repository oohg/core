/*
 * $Id: i_var.ch $
 */
/*
 * OOHG source code:
 * Global pseudo-functions and variables
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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
APPLICATION WIDE PSEUDO-VARIABLES
---------------------------------------------------------------------------*/

#xtranslate _OOHG_ActiveControlInfo       => _OOHG_AppObject():Value_Pos01
#xtranslate _OOHG_ActiveToolBar           => _OOHG_AppObject():Value_Pos02
#xtranslate _OOHG_AdjustFont              => _OOHG_AppObject():Value_Pos03
#xtranslate _OOHG_AdjustWidth             => _OOHG_AppObject():Value_Pos04
#xtranslate _OOHG_AutoAdjust              => _OOHG_AppObject():Value_Pos05
#xtranslate _OOHG_DefaultFontColor        => _OOHG_AppObject():Value_Pos06
#xtranslate _OOHG_DefaultFontName         => _OOHG_AppObject():Value_Pos07
#xtranslate _OOHG_DefaultFontSize         => _OOHG_AppObject():Value_Pos08
#xtranslate _OOHG_DialogCancelled         => _OOHG_AppObject():Value_Pos09
#xtranslate _OOHG_ExtendedNavigation      => _OOHG_AppObject():Value_Pos10
#xtranslate _OOHG_Main                    => _OOHG_AppObject():Value_Pos11
#xtranslate _OOHG_SameEnterDblClick       => _OOHG_AppObject():Value_Pos12
#xtranslate _OOHG_TempWindowName          => _OOHG_AppObject():Value_Pos13
#xtranslate _OOHG_ThisControl             => _OOHG_AppObject():Value_Pos14
#xtranslate _OOHG_ThisEventType           => _OOHG_AppObject():Value_Pos15
#xtranslate _OOHG_ThisForm                => _OOHG_AppObject():Value_Pos16
#xtranslate _OOHG_ThisItemCellCol         => _OOHG_AppObject():Value_Pos17
#xtranslate _OOHG_ThisItemCellHeight      => _OOHG_AppObject():Value_Pos18
#xtranslate _OOHG_ThisItemCellRow         => _OOHG_AppObject():Value_Pos19
#xtranslate _OOHG_ThisItemCellValue       => _OOHG_AppObject():Value_Pos20
#xtranslate _OOHG_ThisItemCellWidth       => _OOHG_AppObject():Value_Pos21
#xtranslate _OOHG_ThisItemColIndex        => _OOHG_AppObject():Value_Pos22
#xtranslate _OOHG_ThisItemRowIndex        => _OOHG_AppObject():Value_Pos23
#xtranslate _OOHG_ThisObject              => _OOHG_AppObject():Value_Pos24
#xtranslate _OOHG_ThisQueryColIndex       => _OOHG_AppObject():Value_Pos25
#xtranslate _OOHG_ThisQueryData           => _OOHG_AppObject():Value_Pos26
#xtranslate _OOHG_ThisQueryRowIndex       => _OOHG_AppObject():Value_Pos27
#xtranslate _OOHG_ThisType                => _OOHG_AppObject():Value_Pos28
#xtranslate _OOHG_Main_Icon               => _OOHG_AppObject():Value_Pos29
#xtranslate _OOHG_MultipleInstances       => _OOHG_AppObject():Value_Pos30
#xtranslate _OOHG_ApplicationCargo        => _OOHG_AppObject():Value_Pos31
#xtranslate _OOHG_BrowseSyncStatus        => _OOHG_AppObject():Value_Pos32
#xtranslate _OOHG_BrowseFixedBlocks       => _OOHG_AppObject():Value_Pos33
#xtranslate _OOHG_BrowseFixedControls     => _OOHG_AppObject():Value_Pos34
#xtranslate _OOHG_XBrowseFixedBlocks      => _OOHG_AppObject():Value_Pos35
#xtranslate _OOHG_XBrowseFixedControls    => _OOHG_AppObject():Value_Pos36
#xtranslate _OOHG_GridFixedControls       => _OOHG_AppObject():Value_Pos37
#xtranslate _OOHG_ErrorLevel              => _OOHG_AppObject():Value_Pos38
#xtranslate _OOHG_WinReleaseSameOrder     => _OOHG_AppObject():Value_Pos39
#xtranslate _OOHG_InitTGridControlDatas   => _OOHG_AppObject():Value_Pos40
#xtranslate _OOHG_ComboRefresh            => _OOHG_AppObject():Value_Pos41
#xtranslate _OOHG_SaveAsDWORD             => _OOHG_AppObject():Value_Pos42
#xtranslate _OOHG_ActiveIniFile           => _OOHG_AppObject():Value_Pos43
#xtranslate _OOHG_ActiveMessageBar        => _OOHG_AppObject():Value_Pos44
#xtranslate _OOHG_bKeyDown                => _OOHG_AppObject():Value_Pos45
#xtranslate _OOHG_HotKeys                 => _OOHG_AppObject():Value_Pos46
#xtranslate _OOHG_DefaultStatusBarMsg     => _OOHG_AppObject():Value_Pos47
#xtranslate _OOHG_DefaultMenuParams       => _OOHG_AppObject():Value_Pos48
#xtranslate _OOHG_OwnerDrawMenus          => _OOHG_AppObject():Value_Pos49
#xtranslate _OOHG_SettingFocus            => _OOHG_AppObject():Value_Pos51
#xtranslate _OOHG_Validating              => _OOHG_AppObject():Value_Pos52
#xtranslate _OOHG_ActiveHelpFile          => _OOHG_AppObject():Value_Pos53
#xtranslate _OOHG_UseLibraryDraw          => _OOHG_AppObject():Value_Pos54
#xtranslate _OOHG_EnableClassUnreg        => _OOHG_AppObject():Value_Pos55
#xtranslate _OOHG_ExitOnMainRelease       => _OOHG_AppObject():Value_Pos56
#xtranslate _OOHG_LogFile                 => _OOHG_AppObject():Value_Pos57
#xtranslate _OOHG_InteractiveClose        => _OOHG_AppObject():Value_Pos58
#xtranslate _OOHG_ActiveTree              => _OOHG_AppObject():Value_Pos59
#xtranslate _OOHG_ComboIndexIsValueArray  => _OOHG_AppObject():Value_Pos60
#xtranslate _OOHG_ComboIndexIsValueDbf    => _OOHG_AppObject():Value_Pos61
#xtranslate _OOHG_DefaultFontBold         => _OOHG_AppObject():Value_Pos62
#xtranslate _OOHG_DefaultFontItalic       => _OOHG_AppObject():Value_Pos63
#xtranslate _OOHG_DefaultFontStrikeOut    => _OOHG_AppObject():Value_Pos64
#xtranslate _OOHG_DefaultFontUnderLine    => _OOHG_AppObject():Value_Pos65
#xtranslate _OOHG_DefaultFontCharSet      => _OOHG_AppObject():Value_Pos66
#xtranslate _OOHG_ActiveFrame             => _OOHG_AppObject():ActiveFrameGet()
#xtranslate _OOHG_ActiveGroupBox          => _OOHG_AppObject():ActiveGroupBoxGet()
#xtranslate _OOHG_LastDefinedForm         => ATail( _OOHG_RegisteredForms )
#xtranslate _OOHG_MouseCol                => _OOHG_GetMouseCol()
#xtranslate _OOHG_MouseRow                => _OOHG_GetMouseRow()
#xtranslate _OOHG_RegisteredForms         => _OOHG_FormObjects()
#xtranslate _OOHG_RegisteredControls      => _OOHG_ControlObjects()
#xtranslate _OOHG_LastDefinedControl      => ATail( _OOHG_RegisteredControls )

/*---------------------------------------------------------------------------
APPLICATION WIDE PSEUDO-FUNCTIONS
---------------------------------------------------------------------------*/

#xtranslate _OOHG_AddFrame( <obj> )       => _OOHG_AppObject():ActiveFramePush( <obj> )
#xtranslate _OOHG_LastFrameType()         => iif( _OOHG_ActiveFrame == NIL, "", _OOHG_ActiveFrame:Type )
#xtranslate _OOHG_AddGroupBox( <obj> )    => _OOHG_AppObject():ActiveGroupBoxPush( <obj> )
#xtranslate _OOHG_DeleteGroupBox()        => _OOHG_AppObject():ActiveGroupBoxPop()
#xtranslate GetFontHandle( <cFontID> )    => _OOHG_AppObject():GetLogFontHandle( <cFontID> )
#xtranslate GetFontParam( <hFont> )       => _OOHG_AppObject():GetLogFontParams( <hFont> )
#xtranslate GetFontParamByRef( <x, ...> ) => _OOHG_AppObject():GetLogFontParamsByRef( <x> )
#xtranslate _OOHG_GetNullName( [ <x> ] )  => _OOHG_AppObject():Value_Pos50( [ <x> ] )
#xtranslate _PushEventInfo()              => _OOHG_AppObject():EventInfoPush()
#xtranslate _PopEventInfo()               => _OOHG_AppObject():EventInfoPop()

#xtranslate _OOHG_DeleteFrame( <cType> ) ;
    => ;
       ( _OOHG_ActiveFrame != NIL .AND. _OOHG_ActiveFrame:Type == <cType> .AND. _OOHG_AppObject():ActiveFramePop() )

#xtranslate _OOHG_SetMultiple( [ <lMultiple>, <lWarning> ] ) ;
    => ;
       _OOHG_AppObject():MultipleInstances( [ <lMultiple>, <lWarning> ] )

#xtranslate SetAppHotKey( [ <nKey> [, <nFlags> [, <bAction> ] ] ] ) ;
    => ;
       _OOHG_AppObject():HotKeySet( <nKey>, <nFlags>, <bAction> )
