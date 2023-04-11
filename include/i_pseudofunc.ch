/*
 * $Id: i_pseudofunc.ch $
 */
/*
 * OOHG source code:
 * Pseudo-functions definitions
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


#xtranslate DQM( <x> ) ;
   => ;
      ( '"' + <x> + '"' )

#xtranslate SQM( <x> ) ;
   => ;
      ( "'" + <x> + "'" )

#xtranslate BKT( <x> ) ;
   => ;
      ( "[" + <x> + "]")

#xtranslate SendMessageWideString( <hwnd>, <nmsg>, <wparam>, <lparam> ) ;
   => ;
      SendMessageStringW( <hwnd>, <nmsg>, <wparam>, <lparam> )

#if ( __HARBOUR__ - 0 < 0x030200 )
#xtranslate hb_osisWin10() ;
   => ;
      '10' $ WinVersion() \[ 1 ]
#endif

#if ( __HARBOUR__ - 0 > 0x030200 )
#xtranslate hb_osisWin10() ;
   => ;
      os_IsWin10()
#endif

#xtranslate IsControlDefined( <ControlName>, <FormName> ) ;
   => ;
      _IsControlDefined( <(ControlName)>, <(FormName)> )

#xtranslate IsWindowActive( <FormName> ) ;
   => ;
      _IsWindowActive( <(FormName)> )

#xtranslate IsWindowDefined( <FormName> ) ;
   => ;
      _IsWindowDefined( <(FormName)> )

#xtranslate IsContextMenuDefined( <FormName> ) ;
   => ;
      iif( IsWindowDefined( <FormName> ), GetExistingFormObject( <FormName> ):ContextMenu != NIL, .F. )

#xtranslate IsNotifyMenuDefined( <FormName> ) ;
   => ;
      iif( IsWindowDefined( <FormName> ), GetExistingFormObject( <FormName> ):NotifyMenu != NIL, .F. )

#xtranslate ArraysAreEqual( <array1>, <array2> ) ;
   => ;
      AEqual( <array1>, <array2> )

#command ASSIGN <var> VALUE <value> TYPE <type> ;
   => ;
      IF ValType( <value> ) $ ( <type> ) ;;
         <var> := ( <value> ) ;;
      ENDIF

#command ASSIGN <var> VALUE <value> TYPE <type> DEFAULT <default> ;
   => ;
      IF ValType( <value> ) $ ( <type> ) ;;
         <var> := ( <value> ) ;;
      ELSE ;;
         <var> := ( <default> ) ;;
      ENDIF

#xtranslate SetFontNameSize( [ <param, ...> ] ) ;
   => ;
      _SetFont( <param> )

#xtranslate GetDefaultFontName() ;
   => ;
      GetSystemFont() \[1\]

#xtranslate GetDefaultFontSize() ;
   => ;
      GetSystemFont() \[2\]

#xtranslate GetActiveHelpFile() ;
   => ;
      _OOHG_ActiveHelpFile

#xtranslate SetInteractiveClose( [ <nValue> ] ) ;
   => ;
      _OOHG_InteractiveClose [ := <nValue> ]

#xtranslate LB_String2Array( <cData> [, <Sep> ] ) ;
   => ;
      hb_ATokens( <cData>, iif( HB_ISSTRING( <Sep> ), <Sep>, Chr(9) ) )

#xtranslate IsWinXPOrLater() ;
   => ;
      OSIsWinXPOrLater()

#xtranslate IsVistaOrLater() ;
   => ;
      OSIsWinVistaOrLater()

#xtranslate IsSevenOrLater() ;
   => ;
      OSIsWinSevenOrLater()

#xtranslate IsEightOrLater() ;
   => ;
      OSIsWinEightOrLater()

#xtranslate IsWin10OrLater() ;
   => ;
      OSIsWinTenOrLater()

#xtranslate IsWin11OrLater() ;
   => ;
      OSIsWinElevenOrLater()

#xtranslate hb_osisWin11() ;
   => ;
      '11' $ WinVersion() \[ 1 ]

#xtranslate IsWin64() ;
   => ;
      IsExe64()

#xtranslate MsgAlert( <c>, <t> ) ;
   => ;
      MsgExclamation( <c>, <t> )

#xtranslate GetUserProfileFolder() ;
   => ;
      GetSpecialFolder( CSIDL_PROFILE )

#xtranslate GetUserTempFolder() ;
   => ;
      iif( IsVistaOrLater(), GetUserProfileFolder() + "\AppData\Local\Temp", cFilePath( GetTempDir() ) )

#xtranslate GetApplicationDataFolder() ;
   => ;
      GetSpecialFolder( CSIDL_APPDATA )

#xtranslate _OOHG_SetbKeyDown( [ <bValue> ] ) ;
   => ;
      _OOHG_bKeyDown [ := <bValue> ]

#xtranslate SetBrowseFixedBlocks( [ <lValue> ] ) ;
   => ;
      _OOHG_BrowseFixedBlocks [ := <lValue> ]

#xtranslate SetBrowseFixedControls( [ <lValue> ] ) ;
   => ;
      _OOHG_BrowseFixedControls [ := <lValue> ]

#xtranslate SetBrowseSync( [ <lValue> ] ) ;
   => ;
      _OOHG_BrowseSyncStatus [ := <lValue> ]

#xtranslate SetXBrowseFixedBlocks( [ <lValue> ] ) ;
   => ;
      _OOHG_XBrowseFixedBlocks [ := <lValue> ]

#xtranslate SetXBrowseFixedControls( [ <lValue> ] ) ;
   => ;
      _OOHG_XBrowseFixedControls := [ <lValue> ]

#xtranslate SetGridFixedControls( [ <lValue> ] ) ;
   => ;
      _OOHG_GridFixedControls := [ <lValue> ]

#xtranslate SetGridScrollOnWheel( [ <lValue> ] ) ;
   => ;
      _OOHG_GridScrollOnWheel := [ <lValue> ]

#xtranslate SetComboRefresh( [ <lValue> ] ) ;
   => ;
      _OOHG_ComboRefresh [ := <lValue> ]

#xtranslate MiniGuiVersion() ;
   => ;
      OOHGVersion()

#xtranslate OOHGVersion() ;
   => ;
      ( "OOHG Ver. " + OOHG_VER_DATE + "." + OOHG_VER_STATUS + iif( IsExe64(), " (64 bits)", " (32 bits)" ) )

#xtranslate _GetValue( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Value

#xtranslate _SetValue( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Value := <Value>

#xtranslate _AddItem( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):AddItem( <Value> )

#xtranslate _DeleteItem( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):DeleteItem( <Value> )

#xtranslate _DeleteAllItems( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):DeleteAllItems()

#xtranslate GetControlName( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):name

#xtranslate GetControlHandle( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):hwnd

#xtranslate GetControlContainerHandle( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Container:hwnd

#xtranslate GetControlParentHandle( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):ContainerhWnd

#xtranslate GetControlId( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):id

#xtranslate GetControlType( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):type

#xtranslate GetControlValue( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):value

#xtranslate _SetFocus( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFocus()

#xtranslate _DisableControl( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Enabled := .F.

#xtranslate _EnableControl( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Enabled := .T.

#xtranslate _ShowControl( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Show()

#xtranslate _HideControl( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Hide()

#xtranslate _SetItem( <ControlName>, <ParentForm>, <Item>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Item( <Item>, <Value> )

#xtranslate _GetItem( <ControlName>, <ParentForm>, <Item> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Item( <Item> )

#xtranslate _SetControlSizePos( <ControlName>, <ParentForm>, <row>, <col>, <width>, <height> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SizePos( <row>, <col>, <width>, <height> )

#xtranslate _GetItemCount( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):itemcount

#xtranslate _GetControlRow( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):row

#xtranslate _GetControlCol( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):col

#xtranslate _GetControlWidth( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):width

#xtranslate _GetControlHeight( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):height

#xtranslate _SetControlCol( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SizePos( NIL, <Value> )

#xtranslate _SetControlRow( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SizePos( <Value> )

#xtranslate _SetControlWidth( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SizePos( NIL, NIL, <Value> )

#xtranslate _SetControlHeight( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SizePos( NIL, NIL, NIL, <Value> )

#xtranslate _SetPicture( <ControlName>, <ParentForm>, <FileName> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Picture := <FileName>

#xtranslate _GetPicture( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Picture

#xtranslate _GetControlAction( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):OnClick

#xtranslate _GetToolTip( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):ToolTip

#xtranslate _SetToolTip( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):ToolTip := <Value>

#xtranslate _SetRangeMin( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):RangeMin := <Value>

#xtranslate _SetRangeMax( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):RangeMax := <Value>

#xtranslate _GetRangeMin( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):RangeMin

#xtranslate _GetRangeMax( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):RangeMax

#xtranslate _SetMultiCaption( <ControlName>, <ParentForm>, <Column>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Caption( <Column>, <Value> ) ;

#xtranslate _GetMultiCaption( <ControlName>, <ParentForm>, <Item> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Caption( <Item> )

#xtranslate _ReleaseControl( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):release() ;

#xtranslate _IsControlVisibleFromHandle( <Handle> ) ;
   => ;
      GetControlObjectByHandle( <Handle> ):ContainerVisible

#xtranslate _SetCaretPos( <ControlName>, <ParentForm>, <Pos> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):CaretPos := <Pos>

#xtranslate _GetCaretPos( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):CaretPos

#xtranslate _GetFontName( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):cFontName

#xtranslate _GetFontSize( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):nFontSize

#xtranslate _GetFontBold( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Bold

#xtranslate _GetFontItalic( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Italic

#xtranslate _GetFontUnderline( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Underline

#xtranslate _GetFontStrikeOut( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):Strikeout

#xtranslate _GetFontAngle( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):FntAngle

#xtranslate _GetFontCharset( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):FntCharset

#xtranslate _GetFontWidth( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):FntWidth

#xtranslate _GetFontOrientation( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):FntOrientation

#xtranslate _GetFontAdvancedGM( <ControlName>, <ParentForm> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):FntAdvancedGM

#xtranslate _SetFontName( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( <Value> )

#xtranslate _SetFontSize( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, <Value> )

#xtranslate _SetFontBold( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, <Value> )

#xtranslate _SetFontItalic( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, NIL, <Value> )

#xtranslate _SetFontUnderline( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, NIL, NIL, <Value> )

#xtranslate _SetFontStrikeOut( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, NIL, NIL, NIL, <Value> )

#xtranslate _SetFontAngle( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, NIL, NIL, NIL, NIL, <Value> )

#xtranslate _SetFontCharset( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, NIL, NIL, NIL, NIL, NIL, <Value> )

#xtranslate _SetFontWidth( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, <Value> )

#xtranslate _SetFontOrientation( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, <Value> )

#xtranslate _SetFontAdvancedGM( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):SetFont( NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, NIL, <Value> )

#xtranslate _SetFontColor( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):FontColor := <Value>

#xtranslate _SetBackColor( <ControlName>, <ParentForm>, <Value> ) ;
   => ;
      GetControlObject( <ControlName>, <ParentForm> ):backcolor := <Value>

#xtranslate _SetStatusIcon( <ControlName>, <ParentForm>, <Item>, <Icon> ) ;
   => ;
      SetStatusItemIcon( GetControlObject( <ControlName>, <ParentForm> ):hwnd, <Item>, <Icon> )

#xtranslate _GetCaption( <ControlName>, <ParentForm> ) ;
   => ;
      GetWindowText( GetControlObject( <ControlName>, <ParentForm> ):hwnd )

#xtranslate GetWindowsFolder() ;
   => ;
      GetWindowsDir()

#xtranslate GetSystemFolder() ;
   => ;
      GetSystemDir()

#xtranslate GetTempFolder() ;
   => ;
      GetTempDir()

#xtranslate GetMyDocumentsFolder() ;
   => ;
      GetSpecialFolder( CSIDL_PERSONAL )

#xtranslate GetDesktopFolder() ;
   => ;
      GetSpecialFolder( CSIDL_DESKTOPDIRECTORY )

#xtranslate GetProgramFilesFolder() ;
   => ;
      GetSpecialFolder( CSIDL_PROGRAM_FILES )

#xtranslate GetSpecialFolder( <nCSIDL> ) ;
   => ;
      C_GetSpecialFolder( <nCSIDL> )
