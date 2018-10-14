/*
 * $Id: i_window.ch $
 */
/*
 * ooHG source code:
 * Windows definitions
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
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
DECLARE WINDOW TRANSLATE MAP (SEMI-OOP PROPERTIES/METHODS ACCESS)
---------------------------------------------------------------------------*/

#xcommand DECLARE WINDOW <w> ;
   => ;
      #xtranslate <w> . \<p: Name, Title, Height, Width, ClientHeight, ;
            ClientWidth, VirtualHeight, VirtualWidth, Col, Row, BackColor, ;
            FocusedControl, hWnd, Object, Cursor, NotifyIcon, NotifyToolTip, ;
            SaveAs, MinWidth, MaxWidth, MinHeight, MaxHeight, Topmost, ;
            HelpButton, Closable, Handle, BackColorCode\> ;
            => GetExistingFormObject( <(w)> ):\<p\> ;;
      #xtranslate <w> . \<p: Activate, Center, Release, Maximize, Minimize, ;
            Restore, Show, Hide, Print, SetFocus, Redraw\> \[()\] ;
            => GetExistingFormObject( <(w)> ):\<p\> () ;;
      #xtranslate <w> . \<c\> . DisableEdit ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):ReadOnly ;;
      #xtranslate <w> . \<c\> . \<p: Value, Name, Address, BackColor, Spacing, ;
            FontColor, Picture, ToolTip, FontName, FontSize, FontBold, Col, ;
            FontUnderline, FontItalic, FontStrikeOut, Caption, Row, RePaint, ;
            Width, Height, Visible, Enabled, Checked, ItemCount, RangeMin, ;
            RangeMax, CaretPos, ForeColor, ScrollCaret, GetEditSel, Stretch, ;
            Indent, SelColor, OnChange, AllowAppend, AllowDelete, AllowEdit, ;
            Action, OnClick, Length, hWnd, Object, ReadOnly, Cargo, TabStop, ;
            ItemHeight, RichValue, OnGotFocus, OnLostFocus, OnDblClick, ;
            HBitMap, Handle, oBkGrnd, Transparent, Parent, Container, ;
            OnRClick\> ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\> ;;
      #xtranslate <w> . \<c: VScrollBar, HScrollBar\> . \<p\> ;
            => GetExistingFormObject( <(w)> ):\<c\>:\<p\> ;;
      #xtranslate <w> . \<c\> . Enabled( \<arg\> ) ;
            => GetExistingControlObject( \<(c)\>, ;
            <(w)> ):ItemEnabled( \<arg\> ) ;;
      #xtranslate <w> . \<c\> . \<p: Enabled\>( \<arg: .T., .F.\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\> := \<arg\> ;;
      #xtranslate <w> . \<c\> . Enabled( \<arg\> ) := \<n\> ;
            => GetExistingControlObject( \<(c)\>, ;
            <(w)> ):ItemEnabled( \<arg\>, \<n\> ) ;;
      #xtranslate <w> . \<c\> . \<p: DisplayValue, Position, ForeColor\> ;
            => GetProperty( <(w)>, \<(c)\>, \<(p)\> ) ;;
      #xtranslate <w> . \<c\> . \<p: DisplayValue, Position, ForeColor, ;
            CaretPos, OnChange\> := \<n\> ;
            => SetProperty( <(w)>, \<(c)\>, \<(p)\>, \<n\> ) ;;
      #xtranslate <w> . \<c\> . \<p: Caption, Header, Item, Icon, ColumnWidth, ;
            Picture, Image, Stretch, ItemReadonly, ItemEnabled, ItemDraggable, ;
            CheckItem, BoldItem\>( \<arg\> ) ;
            => GetProperty( <(w)>, \<(c)>, \<(p)>, \<arg\> ) ;;
      #xtranslate <w> . \<c\> . \<p: Caption, Header, Item, Icon, ColumnWidth, ;
            Picture, Image, Stretch, ItemReadonly, ItemEnabled, ItemDraggable, ;
            CheckItem, BoldItem\>( \<arg\> ) := \<n\> ;
            => SetProperty( <(w)>, \<(c)>, \<(p)>, \<arg\>, \<n\> ) ;;
      #xtranslate <w> . \<c\> . \<p: EnableUpdate, DisableUpdate\> ;
            => EMPTY( 0 ) ;;
      #xtranslate <w> . \<c\> . \<p:Cell\>( \<arg1\>, \<arg2\> ) ;
            => GetProperty( <(w)>, \<(c)>, \<(p)>, \<arg1\>, \<arg2\> ) ;;
      #xtranslate <w> . \<c\> . \<p: Cell\>( \<arg1\>, \<arg2\> ) := \<n\> ;
            => SetProperty( <(w)>, \<(c)>, \<(p)>, \<arg1\>, \<arg2\>, \<n\> ) ;;
      #xtranslate <w> . \<c\> . \<p: Refresh, SetFocus, DeleteAllItems, ;
            Release, Show, Hide, Play, Stop, Close, Pause, Eject, OpenDialog, ;
            Resume, ColumnsAutoFit, ColumnsAutoFitH, ColumnsBetterAutoFit, ;
            EditLabel, Up, Down, Left, Right, PageDown, PageUp, GoTop, ;
            GoBottom, Redraw\> \[()\] ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\>() ;;
      #xtranslate <w> . \<c\> . \<p: Save\> \[()\] ;
            => DoMethod( <(w)>, \<(c)\>, \<(p)> ) ;;
      #xtranslate <w> . \<c\> . \<p: Action, OnClick, OnGotFocus, OnLostFocus, ;
            OnDblClick, OnChange, OnRClick\>() ;
            => DoMethod( <(w)>, \<(c)\>, \<(p)> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddItem, DeleteItem, Open, DeletePage, ;
            DeleteColumn, Expand, Collapse, ColumnAutoFit, ColumnAutoFitH, ;
            ColumnBetterAutoFit, GetParent, GetChildren, HandleToItem, Action, ;
            OnClick, TabStop, HeaderImage, OnDblClick, OnRClick\>( \<a\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\> ( \<a\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddItem, Item, ItemReadonly, ItemEnabled, ;
            ItemDraggable, CheckItem, BoldItem, HeaderImage\>( \<arg1\>, ;
            \<arg2\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\>( \<arg1\>, ;
            \<arg2\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddPage, SetRange, SetEditSel\>( \<a1\>, ;
            \<a2\> ) ;
            => DoMethod( <(w)>, \<(c)>, \<(p)>, \<a1\>, \<a2\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddPage\>( \<a1\>, \<a2\>, \<a3\> ) ;
            => DoMethod( <(w)>, \<(c)>, \<(p)>, \<a1\>, \<a2\>, \<a3\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddPage\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\> ) ;
            => DoMethod( <(w)>, \<(c)>, \<(p)>, \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddPage\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\> ) ;
            => DoMethod( <(w)>, \<(c)>, \<(p)>, \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddPage\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\>, \<a6\> ) ;
            => DoMethod ( <(w)>, \<(c)>, \<(p)>, \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\>, \<a6\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddPage\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\>, \<a6\>, \<a7\> ) ;
            => DoMethod ( <(w)>, \<(c)>, \<(p)>, \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\>, \<a6\>, \<a7\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddItem, Item\>( \<a1\>, \<a2\>, \<a3\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\> ( \<a1\>, ;
            \<a2\>, \<a3\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddColumn, AddControl\>( \<a1\>, \<a2\>, ;
            \<a3\>, \<a4\> ) ;
            => DoMethod( <(w)>, \<(c)>, \<(p)>, \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddItem\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\> ( \<a1\>, ;
            \<a2\>, \<a3\>, \<a4\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddItem\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\>( \<a1\>, ;
            \<a2\>, \<a3\>, \<a4\>, \<a5\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddItem\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\>, \<a6\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\>( \<a1\>, ;
            \<a2\>, \<a3\>, \<a4\>, \<a5\>, \<a6\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddItem\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\>, \<a6\>, \<a7\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\>( \<a1\>, ;
            \<a2\>, \<a3\>, \<a4\>, \<a5\>, \<a6\>, \<a7\> ) ;;
      #xtranslate <w> . \<c\> . \<p: AddItem\>( \<a1\>, \<a2\>, \<a3\>, ;
            \<a4\>, \<a5\>, \<a6\>, \<a7\>, \<a8\> ) ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\> ( \<a1\>, ;
            \<a2\>, \<a3\>, \<a4\>, \<a5\>, \<a6\>, \<a7\>, \<a8\> ) ;;
      #xtranslate <w> . \<c\> . \<p: Speed, Volume, Zoom\> := \<n\> ;
            => GetExistingControlObject( \<(c)\>, <(w)> ):\<p\> ( \<n\> ) ;;
      #xtranslate <w> . \<x\> . \<c\> . \<p: Caption, Enabled\> ;
            => GetProperty( <(w)>, \<(x)>, \<(c)>, \<(p)> ) ;;
      #xtranslate <w> . \<x\> . \<c\> . \<p: Caption, Enabled\> := \<n\> ;
            => SetProperty( <(w)>, \<(x)>, \<(c)>, \<(p)>, \<n\> ) ;;
      #xtranslate <w> . \<x\>( \<k\> ) . \<c\> . \<p: Value, Name, Address, ;
            BackColor, FontColor, Picture, ToolTip, FontName, FontSize, ;
            FontBold, FontItalic, FontUnderline, FontStrikeOut, Caption, ;
            Row, DisplayValue, Col, Width, Height, Visible, Enabled, Checked, ;
            ItemCount, RangeMin, RangeMax, Position, CaretPos, ForeColor, ;
            ScrollCaret\> ;
            => <w> . \<c\> . \<p\> ;;
      #xtranslate <w> . \<x\>( \<k\> ) . \<c\> . \<p: Caption, Header, Item, ;
            Icon\>( \<arg\> ) ;
            => <w> . \<c\> . \<p\>( \<arg\> ) ;;
      #xtranslate <w> . \<x\>( \<k\> ) . \<c\> . \<p: Refresh, SetFocus, ;
            DeleteAllItems, Release, Show, Save, Hide, Play, Stop, Close, ;
            Pause, Eject, OpenDialog, Resume, Action, OnClick, OnRClick, ;
            OnDblClick\> \[()\] ;
            => <w> . \<c\> . \<p\> () ;;
      #xtranslate <w> . \<x\>( \<k\> ) . \<c\> . \<p: AddItem, DeleteItem, ;
            Open, DeletePage, DeleteColumn, Expand, Collapse, Seek\>( \<a\> ) ;
            => <w> . \<c\> . \<p\> ( \<a\> ) ;;
      #xtranslate <w> . \<x\>( \<k\> ) . \<c\> . \<p: AddItem, ;
            AddPage\>( \<a1\>, \<a2\> ) ;
            => <w> . \<c\> . \<p\> ( \<a1\>, \<a2\> ) ;;
      #xtranslate <w> . \<x\>( \<k\> ) . \<c\> . \<p: AddItem, ;
            AddPage\>( \<a1\>, \<a2\>, \<a3\> ) ;
            => <w> . \<c\> . \<p\> ( \<a1\>, \<a2\>, \<a3\> ) ;;
      #xtranslate <w> . \<x\>( \<k\> ) . \<c\> . \<p: AddItem, AddColumn, ;
            AddControl, AddPage\>( \<a1\>, \<a2\>, \<a3\>, \<a4\> ) ;
            => <w> . \<c\> . \<p\> ( \<a1\>, \<a2\>, \<a3\>, \<a4\> ) ;;
      #xtranslate <w> . \<x\>( \<k\> ) . \<c\> . \<p: Name, Length, hWnd, ;
            Object, ReadOnly, DisableEdit, Speed, Volume, Zoom, Handle\> ;
            => <w> . \<c\> . \<p\>

#xcommand DEFINE WINDOW <w> ;
      [ OBJ <obj> ] ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ AT <row>, <col> ] ;
      [ WIDTH <wi> ] ;
      [ HEIGHT <h> ] ;
      [ VIRTUAL WIDTH <vWidth> ] ;
      [ VIRTUAL HEIGHT <vHeight> ] ;
      [ TITLE <title> ] ;
      [ ICON <icon> ] ;
      [ <main:  MAIN> ] ;
      [ <child: CHILD> ] ;
      [ <modal: MODAL> ] ;
      [ <modalsize: MODALSIZE> ] ;
      [ <splitchild: SPLITCHILD> ] ;
      [ <mdi: MDI> ] ;
      [ <mdiclient: MDICLIENT> ] ;
      [ <mdichild: MDICHILD> ] ;
      [ <TabNav: MDITABNAV> ] ;
      [ <internal: INTERNAL> ] ;
      [ <noshow: NOSHOW> ] ;
      [ <topmost: TOPMOST> ] ;
      [ <noautorelease: NOAUTORELEASE> ] ;
      [ <nominimize: NOMINIMIZE> ] ;
      [ <nomaximize: NOMAXIMIZE> ] ;
      [ <nosize: NOSIZE> ] ;
      [ <nosysmenu: NOSYSMENU> ] ;
      [ <nocaption: NOCAPTION> ] ;
      [ CURSOR <cursor> ] ;
      [ ON INIT <InitProcedure> ] ;
      [ ON MOVE <MoveProcedure> ] ;
      [ ON RELEASE <ReleaseProcedure> ] ;
      [ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
      [ ON MOUSECLICK <ClickProcedure> ] ;
      [ ON MOUSEDRAG <MouseDragProcedure> ] ;
      [ ON MOUSEMOVE <MouseMoveProcedure> ] ;
      [ ON SIZE <SizeProcedure> ] ;
      [ ON MAXIMIZE <MaximizeProcedure> ] ;
      [ ON MINIMIZE <MinimizeProcedure> ] ;
      [ ON RESTORE <RestoreProcedure> ] ;
      [ ON PAINT <PaintProcedure> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONT <FontName> ] ;
      [ SIZE <FontSize> ] ;
      [ FONTCOLOR <FontColor> ] ;
      [ NOTIFYICON <NotifyIcon> ] ;
      [ NOTIFYTOOLTIP <NotifyIconTooltip> ] ;
      [ ON NOTIFYCLICK <NotifyLeftClick> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <GotFocusProcedure> ] ;
      [ ON LOSTFOCUS <LostFocusProcedure> ] ;
      [ ON SCROLLUP <scrollup> ] ;
      [ ON SCROLLDOWN <scrolldown> ] ;
      [ ON SCROLLLEFT <scrollleft> ] ;
      [ ON SCROLLRIGHT <scrollright> ] ;
      [ ON HSCROLLBOX <hScrollBox> ] ;
      [ ON VSCROLLBOX <vScrollBox> ] ;
      [ <helpbutton:  HELPBUTTON> ] ;
      [ <rtl: RTL> ] ;
      [ GRIPPERTEXT <grippertext> ] ;
      [ <break: BREAK> ] ;
      [ <focused: FOCUSED> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <clientarea: CLIENTAREA> ] ;
      [ ON RCLICK <RClickProcedure> ] ;
      [ ON MCLICK <MClickProcedure> ] ;
      [ ON DBLCLICK <DblClickProcedure> ] ;
      [ ON RDBLCLICK <RDblClickProcedure> ] ;
      [ ON MDBLCLICK <MDblClickProcedure> ] ;
      [ MINWIDTH <minwidth> ] ;
      [ MAXWIDTH <maxwidth> ] ;
      [ MINHEIGHT <minheight> ] ;
      [ MAXHEIGHT <maxheight> ] ;
      [ BACKIMAGE <backimage> [ <stretch: STRETCH> ] ] ;
   => ;
      DECLARE WINDOW <w> ;;
      [ <obj> := ] DefineWindow( <(w)>, <title>, <col>, <row>, <wi>, <h>, ;
            <.nominimize.>, <.nomaximize.>, <.nosize.>, <.nosysmenu.>, ;
            <.nocaption.>, <{InitProcedure}>, <{ReleaseProcedure}>, ;
            <{MouseDragProcedure}>, <{SizeProcedure}>, <{ClickProcedure}>, ;
            <{MouseMoveProcedure}>, <backcolor>, <{PaintProcedure}>, ;
            <.noshow.>, <.topmost.>, <icon>, <FontName>, <FontSize>, ;
            <NotifyIcon>, <NotifyIconTooltip>, <{NotifyLeftClick}>, ;
            <{GotFocusProcedure}>, <{LostFocusProcedure}>, <vHeight>, ;
            <vWidth>, <{scrollleft}>, <{scrollright}>, <{scrollup}>, ;
            <{scrolldown}>, <{hScrollBox}>, <{vScrollBox}>, <.helpbutton.>, ;
            <{MaximizeProcedure}>, <{MinimizeProcedure}>, <cursor>, ;
            <.noautorelease.>, <(parent)>, <{interactivecloseprocedure}>, ;
            <.focused.>, <.break.>, <grippertext>, <.rtl.>, <.main.>, ;
            <.splitchild.>, <.child.>, <.modal.>, <.modalsize.>, <.mdi.>, ;
            <.internal.>, <.mdichild.>, <.mdiclient.>, [ <subclass>() ], ;
            <.clientarea.>, <{RestoreProcedure}>, <{RClickProcedure}>, ;
            <{MClickProcedure}>, <{DblClickProcedure}>, ;
            <{RDblClickProcedure}>, <{MDblClickProcedure}>, <minwidth>, ;
            <maxwidth>, <minheight>, <maxheight>, <{MoveProcedure}>, ;
            <backimage>, <.stretch.>, <FontColor>, <.TabNav.> )

#xcommand LOAD WINDOW <w> ;
   => ;
      _OOHG_TempWindowName := <(w)> ;;
      DECLARE WINDOW <w> ;;
      #include \<<w>.fmg\>

#xcommand LOAD WINDOW <ww> AS <w: 0, NONAME, NIL, NULL, NONE> ;
   => ;
      _OOHG_TempWindowName := <(w)> ;;
      #include \<<ww>.fmg\>

#xcommand LOAD WINDOW <ww> AS <w> ;
   => ;
      _OOHG_TempWindowName := <(w)> ;;
      DECLARE WINDOW <w> ;;
      #include \<<ww>.fmg\>

#command RELEASE WINDOW <name> ;
   => ;
      DoMethod ( <(name)>, 'Release' )

#command RELEASE WINDOW ALL ;
   => ;
      ReleaseAllWindows()

#command RELEASE WINDOW MAIN ;
   => ;
      ReleaseAllWindows()

#xtranslate EXIT PROGRAM ;
   => ;
      ReleaseAllWindows()

#command ACTIVATE WINDOW <name, ...> [ <nowait: NOWAIT> ] ;
   => ;
      _ActivateWindow( \{<(name)>\}, <.nowait.> )

#command ACTIVATE WINDOW ALL ;
   => ;
      _ActivateAllWindows()

#command CENTER WINDOW <name> ;
   => ;
      DoMethod ( <(name)>, 'Center' )

#command MAXIMIZE WINDOW <name> ;
   => ;
      DoMethod ( <(name)>, 'Maximize' )

#command MINIMIZE WINDOW <name> ;
   => ;
      DoMethod ( <(name)>, 'Minimize' )

#command RESTORE WINDOW <name> ;
   => ;
      DoMethod ( <(name)>, 'Restore' )

#command SHOW WINDOW <name> ;
   => ;
      DoMethod ( <(name)>, 'Show' )

#command HIDE WINDOW <name> ;
   => ;
      DoMethod ( <(name)>, 'Hide' )

#command END WINDOW ;
   => ;
      _EndWindow ()

#xcommand FETCH [ PROPERTY ] [ WINDOW ] <Arg1> <Arg2> TO <Arg3> ;
   => ;
      <Arg3> := GetProperty( <(Arg1)>, <(Arg2)> )

#xcommand MODIFY [ PROPERTY ] [ WINDOW ] <Arg1> <Arg2> <Arg3> ;
   => ;
      SetProperty( <(Arg1)>, <(Arg2)>, <Arg3> )

#xcommand DEFINE WINDOW TEMPLATE ;
      [ OBJ <obj> ] ;
      [ <dummy: OF, PARENT> <parent> ] ;
      [ AT <row>, <col> ] ;
      [ WIDTH <wi> ] ;
      [ HEIGHT <h> ] ;
      [ VIRTUAL WIDTH <vWidth> ] ;
      [ VIRTUAL HEIGHT <vHeight> ] ;
      [ TITLE <title> ] ;
      [ ICON <icon> ] ;
      [ <main:  MAIN> ] ;
      [ <child: CHILD> ] ;
      [ <modal: MODAL> ] ;
      [ <modalsize: MODALSIZE> ] ;
      [ <splitchild: SPLITCHILD> ] ;
      [ <mdi: MDI> ] ;
      [ <mdiclient: MDICLIENT> ] ;
      [ <mdichild: MDICHILD> ] ;
      [ <TabNav: MDITABNAV> ] ;
      [ <internal: INTERNAL> ] ;
      [ <noshow: NOSHOW> ] ;
      [ <topmost: TOPMOST> ] ;
      [ <noautorelease: NOAUTORELEASE> ] ;
      [ <nominimize: NOMINIMIZE> ] ;
      [ <nomaximize: NOMAXIMIZE> ] ;
      [ <nosize: NOSIZE> ] ;
      [ <nosysmenu: NOSYSMENU> ] ;
      [ <nocaption: NOCAPTION> ] ;
      [ CURSOR <cursor> ] ;
      [ ON INIT <InitProcedure> ] ;
      [ ON MOVE <MoveProcedure> ] ;
      [ ON RELEASE <ReleaseProcedure> ] ;
      [ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
      [ ON MOUSECLICK <ClickProcedure> ] ;
      [ ON MOUSEDRAG <MouseDragProcedure> ] ;
      [ ON MOUSEMOVE <MouseMoveProcedure> ] ;
      [ ON SIZE <SizeProcedure> ] ;
      [ ON MAXIMIZE <MaximizeProcedure> ] ;
      [ ON MINIMIZE <MinimizeProcedure> ] ;
      [ ON RESTORE <RestoreProcedure> ] ;
      [ ON PAINT <PaintProcedure> ] ;
      [ BACKCOLOR <backcolor> ] ;
      [ FONT <FontName> ] ;
      [ SIZE <FontSize> ] ;
      [ FONTCOLOR <FontColor> ] ;
      [ NOTIFYICON <NotifyIcon> ] ;
      [ NOTIFYTOOLTIP <NotifyIconTooltip> ] ;
      [ ON NOTIFYCLICK <NotifyLeftClick> ] ;
      [ <dummy02: ONGOTFOCUS, ON GOTFOCUS> <GotFocusProcedure> ] ;
      [ ON LOSTFOCUS <LostFocusProcedure> ] ;
      [ ON SCROLLUP <scrollup> ] ;
      [ ON SCROLLDOWN <scrolldown> ] ;
      [ ON SCROLLLEFT <scrollleft> ] ;
      [ ON SCROLLRIGHT <scrollright> ] ;
      [ ON HSCROLLBOX <hScrollBox> ] ;
      [ ON VSCROLLBOX <vScrollBox> ] ;
      [ <helpbutton:  HELPBUTTON> ] ;
      [ <rtl: RTL> ] ;
      [ GRIPPERTEXT <grippertext> ] ;
      [ <break: BREAK> ] ;
      [ <focused: FOCUSED> ] ;
      [ SUBCLASS <subclass> ] ;
      [ <clientarea: CLIENTAREA> ] ;
      [ ON RCLICK <RClickProcedure> ] ;
      [ ON MCLICK <MClickProcedure> ] ;
      [ ON DBLCLICK <DblClickProcedure> ] ;
      [ ON RDBLCLICK <RDblClickProcedure> ] ;
      [ ON MDBLCLICK <MDblClickProcedure> ] ;
      [ MINWIDTH <minwidth> ] ;
      [ MAXWIDTH <maxwidth> ] ;
      [ MINHEIGHT <minheight> ] ;
      [ MAXHEIGHT <maxheight> ] ;
      [ BACKIMAGE <backimage> [ <stretch: STRETCH> ] ] ;
   => ;
      [ <obj> := ] DefineWindow(, <title>, <col>, <row>, <wi>, <h>, ;
            <.nominimize.>, <.nomaximize.>, <.nosize.>, <.nosysmenu.>, ;
            <.nocaption.>, <{InitProcedure}>, <{ReleaseProcedure}>, ;
            <{MouseDragProcedure}>, <{SizeProcedure}>, <{ClickProcedure}>, ;
            <{MouseMoveProcedure}>, <backcolor>, <{PaintProcedure}>, ;
            <.noshow.>, <.topmost.>, <icon>, <FontName>, <FontSize>, ;
            <NotifyIcon>, <NotifyIconTooltip>, <{NotifyLeftClick}>, ;
            <{GotFocusProcedure}>, <{LostFocusProcedure}>, <vHeight>, ;
            <vWidth>, <{scrollleft}>, <{scrollright}>, <{scrollup}>, ;
            <{scrolldown}>, <{hScrollBox}>, <{vScrollBox}>, <.helpbutton.>, ;
            <{MaximizeProcedure}>, <{MinimizeProcedure}>, <cursor>, ;
            <.noautorelease.>, <(parent)>, <{interactivecloseprocedure}>, ;
            <.focused.>, <.break.>, <grippertext>, <.rtl.>, <.main.>, ;
            <.splitchild.>, <.child.>, <.modal.>, <.modalsize.>, <.mdi.>, ;
            <.internal.>, <.mdichild.>, <.mdiclient.>, [ <subclass>() ], ;
            <.clientarea.>, <{RestoreProcedure}>, <{RClickProcedure}>, ;
            <{MClickProcedure}>, <{DblClickProcedure}>, ;
            <{RDblClickProcedure}>, <{MDblClickProcedure}>, <minwidth>, ;
            <maxwidth>, <minheight>, <maxheight>, <{MoveProcedure}>, ;
            <backimage>, <.stretch.>, <FontColor>, <.TabNav.> )

/*---------------------------------------------------------------------------
AUTOADJUST
---------------------------------------------------------------------------*/

#xtranslate SET AUTOADJUST ON ;
   => ;
      _OOHG_AutoAdjust := .T.

#xtranslate SET AUTOADJUST OFF ;
   => ;
      _OOHG_AutoAdjust := .F.

#xtranslate SET ADJUSTWIDTH ON ;
   => ;
      _OOHG_AdjustWidth := .T.

#xtranslate SET ADJUSTWIDTH OFF ;
   => ;
      _OOHG_AdjustWidth := .F.

#xtranslate SET ADJUSTFONT ON ;
   => ;
      _OOHG_AdjustFont := .T.

#xtranslate SET ADJUSTFONT OFF ;
   => ;
      _OOHG_AdjustFont := .F.

/*---------------------------------------------------------------------------
TRANSPARENCY
---------------------------------------------------------------------------*/

#xtranslate SET WINDOW <FormName> TRANSPARENT TO <nAlphaBlend> ;  // nAlphaBlend = 0 (transparent) to 255 (opaque)
   => ;
      SetLayeredWindowAttributes( GetFormHandle( <"FormName"> ), 0, <nAlphaBlend>, 0x02)   // LWA_ALPHA

#xtranslate SET WINDOW <FormName> [ TRANSPARENT ] TO OPAQUE ;
   => ;
      SetLayeredWindowAttributes( GetFormHandle( <"FormName"> ), 0, 255, 0x02)   // LWA_ALPHA

#xtranslate SET WINDOW <FormName> TRANSPARENT TO COLOR <aColor> ;
   => ;
      SetLayeredWindowAttributes( GetFormHandle( <"FormName"> ), RGB(<aColor>\[1\], <aColor>\[2\], <aColor>\[3\]), 0, 0x01 )  // LWA_COLORKEY

#xtranslate SET WINDOW <FormName> TRANSPARENT OFF ;
   => ;
      WindowExStyleFlag( GetFormHandle( <"FormName"> ), 0x00080000, 0 )   // WS_EX_LAYERED

/*---------------------------------------------------------------------------
FLASH
---------------------------------------------------------------------------*/

#xtranslate FLASH WINDOW <FormName> CAPTION COUNT <nTimes> INTERVAL <nMilliseconds> ;
   => ;
      FlashWindowEx( GetFormHandle( <"FormName"> ), 1, <nTimes>, <nMilliseconds> )   // FLASHW_CAPTION

#xtranslate FLASH WINDOW <FormName> TASKBAR COUNT <nTimes> INTERVAL <nMilliseconds> ;
   => ;
      FlashWindowEx( GetFormHandle( <"FormName"> ), 2, <nTimes>, <nMilliseconds> )   // FLASHW_TRAY

#xtranslate FLASH WINDOW <FormName> [ ALL ] COUNT <nTimes> INTERVAL <nMilliseconds> ;
   => ;
      FlashWindowEx( GetFormHandle( <"FormName"> ), 3, <nTimes>, <nMilliseconds> )   // FLASHW_ALL (FLASHW_CAPTION + FLASHW_TRAY)

/*---------------------------------------------------------------------------
WINDOW STATUS, see METHOD GetWindowState() CLASS TForm
---------------------------------------------------------------------------*/

#define FORM_MAXIMIZED 2
#define FORM_MINIMIZED 1
#define FORM_NORMAL    0
