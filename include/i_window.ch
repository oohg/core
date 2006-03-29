/*
 * $Id: i_window.ch,v 1.15 2006-03-29 05:54:14 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Windows definitions
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

// DECLARE WINDOW Translate Map (Semi-OOP Properties/Methods Access)

// 1.  Window Property Get
// 2.  Window Property Set
// 3.  Window Methods
// 4.  Control Property Get	(no arguments)
// 5.  Control Property Set	(no arguments)
// 6.  Control Property Get	(1 argument)
// 7.  Control Property Set	(1 argument)
// 8.  Control Methods		(no arguments)
// 9.  Control Methods		(1 argument)
// 10. Control Methods		(2 argument)
// 11. Control Methods		(3 argument)
// 12. Control Methods		(4 argument)
// 13. Control Property Get	(read only)
// 14. Control Property Set	(write only)
// 15. ToolBar Button Full Name Property Get
// 16. ToolBar Button Full Name Property Set
// 17-27. Tab Child Controls (same sequence of standard controls from 4 to 14)

#ifdef __XHARBOUR__

	#xcommand DECLARE WINDOW <w> ;
	=>;
        #xtranslate <w> . \<p:Name,Title,Height,Width,Col,Row,NotifyIcon,NotifyToolTip,BackColor,FocusedControl,hWnd,Object\> => GetProperty ( <(w)>, \<(p)> ) ;;
        #xtranslate <w> . \<p:Name,Title,Height,Width,Col,Row,NotifyIcon,NotifyToolTip,BackColor,FocusedControl,Cursor\> := \<n\> => SetProperty ( <(w)>, \<(p)> , \<n\> ) ;;
        #xtranslate <w> . \<p:Activate,Center,Release,Maximize,Minimize,Restore,Show,Hide,Print,SetFocus\> \[()\] => DoMethod ( <(w)>, \<(p)> ) ;;
        #xtranslate <w> . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontUnderline,FontItalic,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor\> => GetProperty ( <(w)>, \<(c)> , \<(p)> ) ;;
        #xtranslate <w> . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontUnderline,FontItalic,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor\> := \<n\> => SetProperty ( <(w)>, \<(c)> , \<(p)> , \<n\> ) ;;
        #xtranslate <w> . \<c\> . \<p:AllowAppend,AllowDelete,AllowEdit\> => GetProperty ( <(w)>, \<(c)> , \<(p)> ) ;;
        #xtranslate <w> . \<c\> . \<p:AllowAppend,AllowDelete,AllowEdit\> := \<n\> => SetProperty ( <(w)>, \<(c)> , \<(p)> , \<n\> ) ;;
        #xtranslate <w> . \<c\> . \<p:Caption,Header,Item,Icon,ColumnWidth\> (\<arg\>) => GetProperty ( <(w)>, \<(c)> , \<(p)> , \<arg\> ) ;;
        #xtranslate <w> . \<c\> . \<p:Caption,Header,Item,Icon,ColumnWidth\> (\<arg\>) := \<n\> => SetProperty ( <(w)>, \<(c)> , \<(p)> , \<arg\> , \<n\> ) ;;
        #xtranslate <w> . \<c\> . \<p:Cell\> (\<arg1\>,\<arg2\>) => GetProperty ( <(w)>, \<(c)> , \<(p)> , \<arg1\> , \<arg2\> ) ;;
        #xtranslate <w> . \<c\> . \<p:Cell\> (\<arg1\>,\<arg2\>) := \<n\> => SetProperty ( <(w)>, \<(c)> , \<(p)> , \<arg1\> , \<arg2\> , \<n\> ) ;;
        #xtranslate <w> . \<c\> . \<p:Refresh,SetFocus,DeleteAllItems,Release,Show,Save,Hide,Play,Stop,Close,Pause,Eject,OpenDialog,Resume,Action,OnClick,ColumnsAutoFit,ColumnsAutoFitH\> \[()\] => Domethod ( <(w)>, \<(c)> , \<(p)> ) ;;
        #xtranslate <w> . \<c\> . \<p:AddItem,DeleteItem,Open,DeletePage,DeleteColumn,Expand,Collapse,ColumnAutoFit,ColumnAutoFitH\> (\<a\>) => Domethod ( <(w)>, \<(c)> , \<(p)> , \<a\> ) ;;
        #xtranslate <w> . \<c\> . \<p:AddItem,AddPage\> (\<a1\> , \<a2\>) => Domethod ( <(w)>, \<(c)> , \<(p)> , \<a1\> , \<a2\> ) ;;
        #xtranslate <w> . \<c\> . \<p:AddItem,AddPage\> (\<a1\> , \<a2\> , \<a3\> ) => Domethod ( <(w)>, \<(c)> , \<(p)> , \<a1\> , \<a2\> , \<a3\> ) ;;
        #xtranslate <w> . \<c\> . \<p:AddItem,AddColumn,AddControl\> (\<a1\> , \<a2\> , \<a3\> , \<a4\> ) => Domethod ( <(w)>, \<(c)> , \<(p)> , \<a1\> , \<a2\> , \<a3\> , \<a4\> ) ;;
        #xtranslate <w> . \<c\> . \<p:Name,Length,hWnd,Object\> => GetProperty ( <(w)>, \<(c)> , \<(p)> ) ;;
        #xtranslate <w> . \<c\> . \<p:ReadOnly,Speed,Volume,Zoom\> := \<n\> => SetProperty ( <(w)>, \<(c)> , \<(p)> , \<n\> ) ;;
        #xtranslate <w> . \<x\> . \<c\> . \<p:Caption,Enabled\> => GetProperty ( <(w)> , \<(x)> , \<(c)> , \<(p)> ) ;;
        #xtranslate <w> . \<x\> . \<c\> . \<p:Caption,Enabled\> := \<n\> => SetProperty ( <(w)> , \<(x)> , \<(c)> , \<(p)> , \<n\> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor\> => GetProperty ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor\> := \<n\> => SetProperty ( <(w)> , \<(x)> , \<k\> , \<(c)> , \<(p)> , \<n\> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Caption,Header,Item,Icon\> (\<arg\>) => GetProperty ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> , \<arg\> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Caption,Header,Item,Icon\> (\<arg\>) := \<n\> => SetProperty ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> , \<arg\> , \<n\> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Refresh,SetFocus,DeleteAllItems,Release,Show,Save,Hide,Play,Stop,Close,Pause,Eject,OpenDialog,Resume,Action,OnClick\> \[()\] => Domethod ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:AddItem,DeleteItem,Open,DeletePage,DeleteColumn,Expand,Collapse,Seek\> (\<a\>) => Domethod ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> , \<a\> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:AddItem,AddPage\> (\<a1\> , \<a2\>) => Domethod ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> , \<a1\> , \<a2\> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:AddItem,AddPage\> (\<a1\> , \<a2\> , \<a3\> ) => Domethod ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> , \<a1\> , \<a2\> , \<a3\> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:AddItem,AddColumn,AddControl\> (\<a1\> , \<a2\> , \<a3\> , \<a4\> ) => Domethod ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> , \<a1\> , \<a2\> , \<a3\> , \<a4\> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:Name,Length,hWnd,Object\> => GetProperty ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> ) ;;
        #xtranslate <w> . \<x\> (\<k\>) . \<c\> . \<p:ReadOnly,Speed,Volume,Zoom\> := \<n\> => SetProperty ( <(w)>, \<(x)> , \<k\> , \<(c)> , \<(p)> , \<n\> )

        #xcommand DEFINE WINDOW <w> ;
                        [ OBJ <obj> ] ;
                        [ <dummy: OF, PARENT> <parent> ] ;
                        [ AT <row>,<col> ] ;
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
			[ ON RELEASE <ReleaseProcedure> ] ;
			[ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ON MOUSECLICK <ClickProcedure> ] ;
			[ ON MOUSEDRAG <MouseDragProcedure> ] ;
			[ ON MOUSEMOVE <MouseMoveProcedure> ] ;
			[ ON SIZE <SizeProcedure> ] ;
			[ ON MAXIMIZE <MaximizeProcedure> ] ;
			[ ON MINIMIZE <MinimizeProcedure> ] ;
			[ ON PAINT <PaintProcedure> ] ;
		        [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ NOTIFYICON <NotifyIcon> ] ;
			[ NOTIFYTOOLTIP <NotifyIconTooltip> ] ;
			[ ON NOTIFYCLICK <NotifyLeftClick> ] ;
			[ ON GOTFOCUS <GotFocusProcedure> ] ;
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
	=>;
        [ <obj> := ] ;
        DefineWindow( <(w)>, <title>, <col>, <row>, <wi>, <h>, <.nominimize.>, <.nomaximize.>, <.nosize.>, ;
                      <.nosysmenu.>, <.nocaption.>, <{InitProcedure}>, <{ReleaseProcedure}>, ;
                      <{MouseDragProcedure}>, <{SizeProcedure}>, <{ClickProcedure}>, ;
                      <{MouseMoveProcedure}>, <backcolor>, <{PaintProcedure}>, <.noshow.>, <.topmost.>, ;
                      <icon>, <FontName>, <FontSize>, <NotifyIcon>, <NotifyIconTooltip>, ;
                      <{NotifyLeftClick}>, <{GotFocusProcedure}>, <{LostFocusProcedure}>, <vHeight>, ;
                      <vWidth>, <{scrollleft}>, <{scrollright}>, <{scrollup}>, <{scrolldown}>, ;
                      <{hScrollBox}>, <{vScrollBox}>, <.helpbutton.>, <{MaximizeProcedure}>, ;
                      <{MinimizeProcedure}>, <cursor>, <.noautorelease.>, <parent>, ;
                      <{interactivecloseprocedure}>, <.focused.>, <.break.>, <grippertext>, <.rtl.>, ;
                      <.main.>, <.splitchild.>, <.child.>, <.modal.>, <.modalsize.>, <.mdi.>, <.internal.>, ;
                      <.mdichild.>, <.mdiclient.> ) ;;
        DECLARE WINDOW <w>

	#xcommand LOAD WINDOW <w> ;
	=> ;
        _OOHG_TempWindowName := <(w)>;;
        DECLARE WINDOW <w>;;
        #include \<<w>.fmg\>

	#xcommand LOAD WINDOW <ww> AS <w> ;
	=> ;
        _OOHG_TempWindowName := <(w)>;;
        DECLARE WINDOW <w>;;
        #include \<<ww>.fmg\>

#else

	#xcommand DECLARE WINDOW <w> ;
	=>;
        #xtranslate <w> . <p:Name,Title,Height,Width,Col,Row,NotifyIcon,NotifyToolTip,BackColor,FocusedControl,hWnd,Object> => GetProperty ( <(w)>, <(p)> ) ;;
        #xtranslate <w> . <p:Name,Title,Height,Width,Col,Row,NotifyIcon,NotifyToolTip,BackColor,FocusedControl,Cursor> := <n> => SetProperty ( <(w)>, <(p)> , <n> ) ;;
        #xtranslate <w> . <p:Activate,Center,Release,Maximize,Minimize,Restore,Show,Print,Hide,SetFocus> [()] => DoMethod ( <(w)>, <(p)> ) ;;
        #xtranslate <w> . <c> . <p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor> => GetProperty ( <(w)>, <(c)> , <(p)> ) ;;
        #xtranslate <w> . <c> . <p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor> := <n> => SetProperty ( <(w)>, <(c)> , <(p)> , <n> ) ;;
        #xtranslate <w> . <c> . <p:AllowAppend,AllowDelete,AllowEdit> => GetProperty ( <(w)>, <(c)> , <(p)> ) ;;
        #xtranslate <w> . <c> . <p:AllowAppend,AllowDelete,AllowEdit> := <n> => SetProperty ( <(w)>, <(c)> , <(p)> , <n> ) ;;
        #xtranslate <w> . <c> . <p:Caption,Header,Item,Icon,ColumnWidth> (<arg>) => GetProperty ( <(w)>, <(c)> , <(p)> , <arg> ) ;;
        #xtranslate <w> . <c> . <p:Caption,Header,Item,Icon,ColumnWidth> (<arg>) := <n> => SetProperty ( <(w)>, <(c)> , <(p)> , <arg> , <n> ) ;;
        #xtranslate <w> . <c> . <p:Cell> (<arg1>,<arg2>) => GetProperty ( <(w)>, <(c)> , <(p)> , <arg\> , <arg2> ) ;;
        #xtranslate <w> . <c> . <p:Cell> (<arg1>,<arg2>) := <n> => SetProperty ( <(w)>, <(c)> , <(p)> , <arg1> , <arg2> , <n> ) ;;
        #xtranslate <w> . <c> . <p:Refresh,SetFocus,DeleteAllItems,Release,Show,Save,Hide,Play,Stop,Close,Pause,Eject,OpenDialog,Resume,Action,OnClick,ColumnsAutoFit,ColumnsAutoFitH> [()] => Domethod ( <(w)>, <(c)> , <(p)> ) ;;
        #xtranslate <w> . <c> . <p:AddItem,DeleteItem,Open,DeletePage,DeleteColumn,Expand,Collapse,Seek,ColumnAutoFit,ColumnAutoFitH> (<a>) => Domethod ( <(w)>, <(c)> , <(p)> , <a> ) ;;
        #xtranslate <w> . <c> . <p:AddItem,AddPage> (<a1> , <a2>) => Domethod ( <(w)>, <(c)> , <(p)> , <a1> , <a2> ) ;;
        #xtranslate <w> . <c> . <p:AddItem,AddPage> (<a1> , <a2> , <a3> ) => Domethod ( <(w)>, <(c)> , <(p)> , <a1> , <a2> , <a3> ) ;;
        #xtranslate <w> . <c> . <p:AddItem,AddColumn,AddControl> (<a1> , <a2> , <a3> , <a4> ) => Domethod ( <(w)>, <(c)> , <(p)> , <a1> , <a2> , <a3> , <a4> ) ;;
        #xtranslate <w> . <c> . <p:Name,Length,hWnd,Object> => GetProperty ( <(w)>, <(c)> , <(p)> ) ;;
        #xtranslate <w> . <c> . <p:ReadOnly,Speed,Volume,Zoom> := <n> => SetProperty ( <(w)>, <(c)> , <(p)> , <n> ) ;;
        #xtranslate <w> . <x> . <c> . <p:Caption,Enabled> => GetProperty ( <(w)> , <(x)> , <(c)> , <(p)> ) ;;
        #xtranslate <w> . <x> . <c> . <p:Caption,Enabled> := <n> => SetProperty ( <(w)> , <(x)> , <(c)> , <(p)> , <n> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor> => GetProperty ( <(w)>, <(x)> , <k> , <(c)> , <(p)> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:Value,Name,Value,Address,BackColor,FontColor,Picture,ToolTip,FontName,FontSize,FontBold,FontItalic,FontUnderline,FontStrikeOut,Caption,Row,DisplayValue,Col,Width,Height,Visible,Enabled,Checked,ItemCount,RangeMin,RangeMax,Position,CaretPos,ForeColor> := <n> => SetProperty ( <(w)> , <(x)> , <k> , <(c)> , <(p)> , <n> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:Caption,Header,Item,Icon> (<arg>) => GetProperty ( <(w)>, <(x)> , <k> , <(c)> , <(p)> , <arg> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:Caption,Header,Item,Icon> (<arg>) := <n> => SetProperty ( <(w)>, <(x)> , <k> , <(c)> , <(p)> , <arg> , <n> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:Refresh,SetFocus,DeleteAllItems,Release,Show,Save,Hide,Play,Stop,Close,Pause,Eject,OpenDialog,Resume,Action,OnClick> [()] => Domethod ( <(w)>, <(x)> , <k> , <(c)> , <(p)> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:AddItem,DeleteItem,Open,DeletePage,DeleteColumn,Expand,Collapse,Seek> (<a>) => Domethod ( <(w)>, <(x)> , <k> , <(c)> , <(p)> , <a> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:AddItem,AddPage> (<a1> , <a2>) => Domethod ( <(w)>, <(x)> , <k> , <(c)> , <(p)> , <a1> , <a2> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:AddItem,AddPage> (<a1> , <a2> , <a3> ) => Domethod ( <(w)>, <(x)> , <k> , <(c)> , <(p)> , <a1> , <a2> , <a3> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:AddItem,AddColumn,AddControl> (<a1> , <a2> , <a3> , <a4> ) => Domethod ( <(w)>, <(x)> , <k> , <(c)> , <(p)> , <a1> , <a2> , <a3> , <a4> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:Name,Length,hWnd,Object> => GetProperty ( <(w)>, <(x)> , <k> , <(c)> , <(p)> ) ;;
        #xtranslate <w> . <x> (<k>) . <c> . <p:ReadOnly,Speed,Volume,Zoom> := <n> => SetProperty ( <(w)>, <(x)> , <k> , <(c)> , <(p)> , <n> )

        #xcommand DEFINE WINDOW <w> ;
                        [ OBJ <obj> ] ;
                        [ <dummy: OF, PARENT> <parent> ] ;
                        [ AT <row>,<col> ] ;
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
			[ ON RELEASE <ReleaseProcedure> ] ;
			[ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ON MOUSECLICK <ClickProcedure> ] ;
			[ ON MOUSEDRAG <MouseDragProcedure> ] ;
			[ ON MOUSEMOVE <MouseMoveProcedure> ] ;
			[ ON SIZE <SizeProcedure> ] ;
			[ ON MAXIMIZE <MaximizeProcedure> ] ;
			[ ON MINIMIZE <MinimizeProcedure> ] ;
			[ ON PAINT <PaintProcedure> ] ;
		        [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ NOTIFYICON <NotifyIcon> ] ;
			[ NOTIFYTOOLTIP <NotifyIconTooltip> ] ;
			[ ON NOTIFYCLICK <NotifyLeftClick> ] ;
			[ ON GOTFOCUS <GotFocusProcedure> ] ;
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
	=>;
        DECLARE WINDOW <w>  ;;
        [ <obj> := ] ;
        DefineWindow( <(w)>, <title>, <col>, <row>, <wi>, <h>, <.nominimize.>, <.nomaximize.>, <.nosize.>, ;
                      <.nosysmenu.>, <.nocaption.>, <{InitProcedure}>, <{ReleaseProcedure}>, ;
                      <{MouseDragProcedure}>, <{SizeProcedure}>, <{ClickProcedure}>, ;
                      <{MouseMoveProcedure}>, <backcolor>, <{PaintProcedure}>, <.noshow.>, <.topmost.>, ;
                      <icon>, <FontName>, <FontSize>, <NotifyIcon>, <NotifyIconTooltip>, ;
                      <{NotifyLeftClick}>, <{GotFocusProcedure}>, <{LostFocusProcedure}>, <vHeight>, ;
                      <vWidth>, <{scrollleft}>, <{scrollright}>, <{scrollup}>, <{scrolldown}>, ;
                      <{hScrollBox}>, <{vScrollBox}>, <.helpbutton.>, <{MaximizeProcedure}>, ;
                      <{MinimizeProcedure}>, <cursor>, <.noautorelease.>, <parent>, ;
                      <{interactivecloseprocedure}>, <.focused.>, <.break.>, <grippertext>, <.rtl.>, ;
                      <.main.>, <.splitchild.>, <.child.>, <.modal.>, <.modalsize.>, <.mdi.>, <.internal.>, ;
                      <.mdichild.>, <.mdiclient.> )

	#xcommand LOAD WINDOW <w> ;
	=> ;
	DECLARE WINDOW <w> ;;
        _OOHG_TempWindowName := <(w)> ;;
	#include <<w>.fmg>

	#xcommand LOAD WINDOW <ww> AS <w> ;
	=> ;
	DECLARE WINDOW <w> ;;
        _OOHG_TempWindowName := <(w)> ; #include <<ww>.fmg>

#endif

#command RELEASE WINDOW <name> ;
	=>;
        DoMethod ( <(name)> , 'Release' )

#command RELEASE WINDOW ALL  ;
	=>;
	ReleaseAllWindows()

#command RELEASE WINDOW MAIN  ;
	=>;
	ReleaseAllWindows()

#xtranslate EXIT PROGRAM  ;
	=>;
	ReleaseAllWindows()

#command ACTIVATE WINDOW <name, ...> [ <nowait: NOWAIT> ] ;
	=>;
    _ActivateWindow( \{<(name)>\}, <.nowait.> )

#command ACTIVATE WINDOW ALL ;
	=>;
    _ActivateAllWindows()

#command CENTER WINDOW <name> ;
	=>;
        DoMethod ( <(name)> , 'Center' )

#command MAXIMIZE WINDOW <name> ;
	=>;
        DoMethod ( <(name)> , 'Maximize' )

#command MINIMIZE WINDOW <name> ;
	=>;
        DoMethod ( <(name)> , 'Minimize' )

#command RESTORE WINDOW <name> ;
	=>;
        DoMethod ( <(name)> , 'Restore' )

#command SHOW WINDOW <name> ;
	=>;
        DoMethod ( <(name)> , 'Show' )

#command HIDE WINDOW <name> ;
	=>;
        DoMethod ( <(name)> , 'Hide' )

#command END WINDOW ;
	=>;
_EndWindow ()

#xcommand DO EVENTS => ProcessMessages()

#xtranslate FETCH [ PROPERTY ] [ WINDOW ] <Arg1> <Arg2> TO <Arg3> ;
=> ;
<Arg3> := GetProperty ( <(Arg1)> , <(Arg2)> )

#xtranslate MODIFY [ PROPERTY ] [ WINDOW ] <Arg1> <Arg2> <Arg3> ;
=> ;
SetProperty ( <(Arg1)> , <(Arg2)> , <Arg3> )

        #xcommand DEFINE WINDOW TEMPLATE ;
                        [ OBJ <obj> ] ;
                        [ <dummy: OF, PARENT> <parent> ] ;
                        [ AT <row>,<col> ] ;
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
			[ ON RELEASE <ReleaseProcedure> ] ;
			[ ON INTERACTIVECLOSE <interactivecloseprocedure> ] ;
			[ ON MOUSECLICK <ClickProcedure> ] ;
			[ ON MOUSEDRAG <MouseDragProcedure> ] ;
			[ ON MOUSEMOVE <MouseMoveProcedure> ] ;
			[ ON SIZE <SizeProcedure> ] ;
			[ ON MAXIMIZE <MaximizeProcedure> ] ;
			[ ON MINIMIZE <MinimizeProcedure> ] ;
			[ ON PAINT <PaintProcedure> ] ;
		        [ BACKCOLOR <backcolor> ] ;
			[ FONT <FontName> SIZE <FontSize> ] ;
			[ NOTIFYICON <NotifyIcon> ] ;
			[ NOTIFYTOOLTIP <NotifyIconTooltip> ] ;
			[ ON NOTIFYCLICK <NotifyLeftClick> ] ;
			[ ON GOTFOCUS <GotFocusProcedure> ] ;
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
	=>;
        [ <obj> := ] ;
        DefineWindow( , <title>, <col>, <row>, <wi>, <h>, <.nominimize.>, <.nomaximize.>, <.nosize.>, ;
                      <.nosysmenu.>, <.nocaption.>, <{InitProcedure}>, <{ReleaseProcedure}>, ;
                      <{MouseDragProcedure}>, <{SizeProcedure}>, <{ClickProcedure}>, ;
                      <{MouseMoveProcedure}>, <backcolor>, <{PaintProcedure}>, <.noshow.>, <.topmost.>, ;
                      <icon>, <FontName>, <FontSize>, <NotifyIcon>, <NotifyIconTooltip>, ;
                      <{NotifyLeftClick}>, <{GotFocusProcedure}>, <{LostFocusProcedure}>, <vHeight>, ;
                      <vWidth>, <{scrollleft}>, <{scrollright}>, <{scrollup}>, <{scrolldown}>, ;
                      <{hScrollBox}>, <{vScrollBox}>, <.helpbutton.>, <{MaximizeProcedure}>, ;
                      <{MinimizeProcedure}>, <cursor>, <.noautorelease.>, <parent>, ;
                      <{interactivecloseprocedure}>, <.focused.>, <.break.>, <grippertext>, <.rtl.>, ;
                      <.main.>, <.splitchild.>, <.child.>, <.modal.>, <.modalsize.>, <.mdi.>, <.internal.>, ;
                      <.mdichild.>, <.mdiclient.> )