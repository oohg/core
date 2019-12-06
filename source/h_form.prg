/*
 * $Id: h_form.prg $
 */
/*
 * ooHG source code:
 * Forms handling functions
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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


#include "hbclass.ch"
#include "oohg.ch"
#include "i_windefs.ch"
#include "i_init.ch"

#define HOTKEY_ID       1
#define HOTKEY_MOD      2
#define HOTKEY_KEY      3
#define HOTKEY_ACTION   4

#define TYPE_OTHERS     0
#define TYPE_SPLITCHILD 1
#define TYPE_MDICLIENT  2
#define TYPE_MDICHILD   3
#define TYPE_MDIFRAME   4

STATIC _OOHG_aFormhWnd := {}, _OOHG_aFormObjects := {}               // TODO: thread safe: C-level is safe but scan, add and del at PRG-level are not.
STATIC _OOHG_UserWindow := nil       // User's window                // TODO: thread safe
STATIC _OOHG_ActiveModal := {}       // Modal windows' stack         // TODO: thread safe
STATIC _OOHG_ActiveForm := {}        // Forms under creation         // TODO: thread safe


#pragma BEGINDUMP

#include "oohg.h"
#include <hbvm.h>
#include <hbstack.h>
#include <hbapiitm.h>
#include <windowsx.h>

void _OOHG_SetMouseCoords( PHB_ITEM pSelf, int iCol, int iRow );

#pragma ENDDUMP


CLASS TForm FROM TWindow

   DATA oToolTip                  INIT NIL
   DATA Focused                   INIT .T.
   DATA LastFocusedControl        INIT 0
   DATA AutoRelease               INIT .F.
   DATA ActivateCount             INIT { 0, NIL, .T. }
   DATA oMenu                     INIT NIL
   DATA hWndClient                INIT NIL
   DATA oWndClient                INIT NIL
   DATA lInternal                 INIT .F.
   DATA lForm                     INIT .T.
   DATA nWidth                    INIT 300
   DATA nHeight                   INIT 300
   DATA lShowed                   INIT .F.
   DATA lStretchBack              INIT .T.
   DATA hBackImage                INIT NIL
   DATA lEnterSizeMove            INIT .F.
   DATA lDefined                  INIT .F.
   DATA uFormCursor               INIT IDC_ARROW
   DATA lRefreshDataOnActivate    INIT .T.

   DATA OnRelease                 INIT NIL
   DATA OnInit                    INIT NIL
   DATA OnMove                    INIT NIL
   DATA OnSize                    INIT NIL
   DATA OnPaint                   INIT NIL
   DATA OnScrollUp                INIT NIL
   DATA OnScrollDown              INIT NIL
   DATA OnScrollLeft              INIT NIL
   DATA OnScrollRight             INIT NIL
   DATA OnHScrollBox              INIT NIL
   DATA OnVScrollBox              INIT NIL
   DATA OnInteractiveClose        INIT NIL
   DATA OnMaximize                INIT NIL
   DATA OnMinimize                INIT NIL
   DATA OnRestore                 INIT NIL
   DATA InteractiveClose          INIT -1
   DATA nVirtualHeight            INIT 0
   DATA nVirtualWidth             INIT 0
   DATA RangeHeight               INIT 0
   DATA RangeWidth                INIT 0
   DATA MinWidth                  INIT 0
   DATA MaxWidth                  INIT 0
   DATA MinHeight                 INIT 0
   DATA MaxHeight                 INIT 0
   DATA ForceRow                  INIT NIL   // Must be NIL instead of 0
   DATA ForceCol                  INIT NIL   // Must be NIL instead of 0
   DATA GraphControls             INIT {}
   DATA GraphTasks                INIT {}
   DATA GraphCommand              INIT NIL
   DATA GraphData                 INIT {}
   DATA SplitChildList            INIT {}    // INTERNAL windows.
   DATA aChildPopUp               INIT {}    // POP UP windows.
   DATA lTopmost                  INIT .F.
   DATA aNotifyIcons              INIT {}

   METHOD Title                   SETGET
   METHOD Height                  SETGET
   METHOD Width                   SETGET
   METHOD Col                     SETGET
   METHOD Row                     SETGET
   METHOD Cursor                  SETGET
   METHOD BackColor               SETGET
   METHOD TopMost                 SETGET
   METHOD VirtualWidth            SETGET
   METHOD VirtualHeight           SETGET
   METHOD BackImage               SETGET
   METHOD AutoAdjust
   METHOD AdjustWindowSize
   METHOD ClientsPos
   METHOD Closable                SETGET
   METHOD FocusedControl
   METHOD SizePos
   METHOD Define
   METHOD Define2
   METHOD EndWindow
   METHOD Register
   METHOD Visible                 SETGET
   METHOD Show
   METHOD Hide
   METHOD Flash
   METHOD Activate
   METHOD Release
   METHOD ReleaseAttached
   METHOD RefreshData
   METHOD Center()                BLOCK { | Self | C_Center( ::hWnd ) }
   METHOD Restore()               BLOCK { | Self | Restore( ::hWnd ) }
   METHOD Minimize()              BLOCK { | Self | Minimize( ::hWnd ) }
   METHOD Maximize()              BLOCK { | Self | Maximize( ::hWnd ) }
   METHOD DefWindowProc( nMsg, wParam, lParam) BLOCK { | Self, nMsg, wParam, lParam | iif( ValidHandler( ::hWndClient ), ;
                                                                                           DefFrameProc( ::hWnd, ::hWndClient, nMsg, wParam, lParam ), ;
                                                                                           DefWindowProc( ::hWnd, nMsg, wParam, lParam ) ) }

   METHOD ToolTipWidth( nWidth )          BLOCK { | Self, nWidth | ::oToolTip:WindowWidth( nWidth ) }
   METHOD ToolTipMultiLine( lMultiLine )  BLOCK { | Self, lMultiLine | ::oToolTip:MultiLine( lMultiLine ) }
   METHOD ToolTipAutoPopTime( nMilliSec ) BLOCK { | Self, nMilliSec | ::oToolTip:AutoPopTime( nMilliSec ) }
   METHOD ToolTipInitialTime( nMilliSec ) BLOCK { | Self, nMilliSec | ::oToolTip:InitialTime( nMilliSec ) }
   METHOD ToolTipResetDelays( nMilliSec ) BLOCK { | Self, nMilliSec | ::oToolTip:ResetDelays( nMilliSec ) }
   METHOD ToolTipReshowTime( nMilliSec )  BLOCK { | Self, nMilliSec | ::oToolTip:ReshowTime( nMilliSec ) }
   METHOD ToolTipIcon( nIcon )            BLOCK { | Self, nIcon | ::oToolTip:Icon( nIcon ) }
   METHOD ToolTipTitle( cTitle )          BLOCK { | Self, cTitle | ::oToolTip:Title( cTitle ) }

   METHOD GetWindowState

   METHOD SetActivationFocus
   METHOD ProcessInitProcedure
   METHOD DeleteControl
   METHOD OnHideFocusManagement
   METHOD CheckInteractiveClose
   METHOD DoEvent

   METHOD Events
   METHOD Events_Destroy
   METHOD Events_VScroll
   METHOD Events_HScroll
   METHOD HelpButton              SETGET
   METHOD HelpTopic(lParam)       BLOCK { | Self, lParam | HelpTopic( GetControlObjectByHandle( GetHelpData( lParam ) ):HelpId, 2 ), Self, NIL }
   METHOD ScrollControls
   METHOD MessageLoop
   METHOD HasStatusBar            BLOCK { | Self | AScan( ::aControls, { |c| c:Type == "MESSAGEBAR" } ) > 0 }
   METHOD Inspector               BLOCK { | Self | Inspector( Self ) }

   METHOD NotifyIconObject
   METHOD NotifyIcon              SETGET
   METHOD NotifyToolTip           SETGET
   METHOD NotifyIconLeftClick     SETGET
   METHOD NotifyIconDblClick      SETGET
   METHOD NotifyIconRightClick    SETGET
   METHOD NotifyIconRDblClick     SETGET
   METHOD NotifyIconMidClick      SETGET
   METHOD NotifyIconMDblClick     SETGET
   METHOD NotifyMenu              SETGET
   METHOD cNotifyIconName         SETGET
   METHOD cNotifyIconToolTip      SETGET
   METHOD AddNotifyIcon

   ENDCLASS

METHOD Define( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, ;
               nosysmenu, nocaption, InitProcedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, noshow, topmost, ;
               icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, helpbutton, maximizeprocedure, ;
               minimizeprocedure, cursor, NoAutoRelease, oParent, ;
               InteractiveCloseProcedure, lRtl, child, mdi, clientarea, ;
               restoreprocedure, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, ;
               minwidth, maxwidth, minheight, maxheight, MoveProcedure, ;
               fontcolor, nodwp, nICL ) CLASS TForm

   Local nStyle := 0, nStyleEx := 0
   Local hParent

   If HB_IsLogical( child ) .AND. child
      ::Type := "C"
      oParent := ::SearchParent( oParent )
      IF HB_ISOBJECT( oParent )
         hParent := oParent:hWnd
      ENDIF
   Else
      ::Type := "S"
      hParent := 0
   EndIf

   nStyle += WS_POPUP

   ::Define2( FormName, Caption, x, y, w, h, hParent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              TYPE_OTHERS, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              MoveProcedure, fontcolor, nodwp, nICL )

   Return Self

METHOD Define2( FormName, Caption, x, y, w, h, hParent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
                nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, FontName, FontSize, aRGB, cursor, ;
                icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
                minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
                MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
                nWindowType, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
                DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
                MoveProcedure, fontcolor, nodwp, nICL ) CLASS TForm

   Local FormHandle, aRet

   If _OOHG_GlobalRTL()
      lRtl := .T.
   ElseIf ! HB_IsLogical( lRtl )
      lRtl := .F.
   Endif

   ::lRtl := lRtl

   If ! valtype( FormName ) $ "CM"
      FormName := _OOHG_TempWindowName
   Endif
   _OOHG_TempWindowName := ""

   FormName := _OOHG_GetNullName( FormName )

   If _IsWindowDefined( FormName )
      MsgOOHGError( "DEFINE WINDOW: " + FormName + " is already defined. Program terminated." )
   Endif

   If ! valtype( Caption ) $ "CM"
      Caption := ""
   Endif

   ASSIGN ::nVirtualHeight VALUE VirtualHeight TYPE "N"
   ASSIGN ::nVirtualWidth  VALUE VirtualWidth  TYPE "N"
   ASSIGN ::MinWidth       VALUE minwidth      TYPE "N"
   ASSIGN ::MaxWidth       VALUE maxwidth      TYPE "N"
   ASSIGN ::MinHeight      VALUE minheight     TYPE "N"
   ASSIGN ::MaxHeight      VALUE maxheight     TYPE "N"
   ASSIGN ::lTopmost       VALUE topmost       TYPE "L"
   ASSIGN mdi              VALUE mdi           TYPE "L" DEFAULT .F.
   ASSIGN ::NoDefWinProc   VALUE nodwp         TYPE "L"

   IF HB_ISNUMERIC( nICL ) .AND. nICL >= 0 .AND. nICL <= 3
      nICL := Int( nICL )
      IF nICL != 3 .OR. ::Type == "A"
         ::InteractiveClose := nICL
      ENDIF
   ENDIF

   If ! Valtype( aRGB ) $ 'AN'
      aRGB := -1
   Endif

   If HB_IsLogical( helpbutton ) .AND. helpbutton
      nStyleEx += WS_EX_CONTEXTHELP
   Else
      nStyle += iif( ! HB_ISLOGICAL( nominimize ) .OR. ! nominimize, WS_MINIMIZEBOX, 0 ) + ;
                iif( ! HB_ISLOGICAL( nomaximize ) .OR. ! nomaximize, WS_MAXIMIZEBOX, 0 )
   EndIf

   nStyle += iif( ! HB_ISLOGICAL( nosize ) .OR. ! nosize, WS_SIZEBOX, 0 ) + ;
             iif( ! HB_ISLOGICAL( nosysmenu ) .OR. ! nosysmenu, WS_SYSMENU, 0 ) + ;
             iif( ! HB_ISLOGICAL( nocaption )  .OR. ! nocaption, WS_CAPTION, 0 )

   IF ::lTopmost
      nStyleEx += WS_EX_TOPMOST
   ENDIF

   IF mdi
      nWindowType := TYPE_MDIFRAME
      nStyle += WS_CLIPSIBLINGS + WS_CLIPCHILDREN
      nStyleEx += WS_EX_CONTROLPARENT
   ELSEIF ::nVirtualWidth > 0 .OR. ::nVirtualHeight > 0
      nStyle += WS_CLIPSIBLINGS + WS_CLIPCHILDREN
      nStyleEx += WS_EX_COMPOSITED
   ENDIF

   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   If ::lInternal
      x := ::ContainerCol
      y := ::ContainerRow
   Else
      x := ::nCol
      y := ::nRow
   EndIf

   IF nWindowType == TYPE_MDICLIENT
      FormHandle := InitWindowMDIClient( Caption, x, y, ::nWidth, ::nHeight, hParent, "MDICLIENT", nStyle, nStyleEx, lRtl )
      IF ! ValidHandler( FormHandle )
         MsgOOHGError( "DEFINE WINDOW: MDICLIENT initialization failed. Program terminated." )
      ENDIF
   ELSE
      IF _OOHG_EnableClassUnreg
         _OOHG_AppObject():WinClassUnreg()
         aRet := _OOHG_AppObject():WinClassReg( icon, FormName, aRGB, nWindowType )
      ELSE
         UnRegisterWindow( FormName )
         aRet := RegisterWindow( icon, FormName, aRGB, nWindowType )   // Len( FormName ) must be < 256
      ENDIF
      IF aRet[ 2 ]
         MsgOOHGError( "DEFINE WINDOW: " + FormName + " registration failed with error " + LTrim( Str( _OOHG_GetLastError() ) ) + ". Program terminated." )
      ENDIF
      ::BrushHandle := aRet[ 1 ]
      ::IconHandle := aRet[ 3 ]
      FormHandle := InitWindow( Caption, x, y, ::nWidth, ::nHeight, hParent, FormName, nStyle, nStyleEx, lRtl )
      IF ! ValidHandler( FormHandle )
         MsgOOHGError( "DEFINE WINDOW: " + FormName + " initialization failed with error " + LTrim( Str( _OOHG_GetLastError() ) ) + ". Program terminated." )
      ENDIF
   ENDIF

   If ValType( cursor ) $ "CM"
      SetWindowCursor( FormHandle, cursor )
   EndIf

   ::Register( FormHandle, FormName )
   ::oToolTip := TToolTip():Define( NIL, Self )

   ASSIGN clientarea VALUE clientarea TYPE "L" DEFAULT .F.
   If clientarea
      ::SizePos( NIL, NIL, ::Width + ::nWidth - ::ClientWidth, ::Height + ::nHeight - ::ClientHeight )
   EndIf

   ::ParentDefaults( FontName, FontSize, FontColor )

   AADD( _OOHG_ActiveForm, Self )

   InitDummy( FormHandle )

   ::HScrollbar := TScrollBar():Define( "0", Self,,,,,,,, ;
                   { |Scroll| _OOHG_Eval( ::OnScrollLeft, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnScrollRight, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnHScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnHScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnHScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnHScrollBox, Scroll ) }, ;
                   { |Scroll,n| _OOHG_Eval( ::OnHScrollBox, Scroll, n ) }, ;
                   ,,,,,, SB_HORZ, .T. )
   ::HScrollBar:nLineSkip  := 1
   ::HScrollBar:nPageSkip  := 20

   ::VScrollbar := TScrollBar():Define( "0", Self,,,,,,,, ;
                   { |Scroll| _OOHG_Eval( ::OnScrollUp, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnScrollDown, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnVScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnVScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnVScrollBox, Scroll ) }, ;
                   { |Scroll| _OOHG_Eval( ::OnVScrollBox, Scroll ) }, ;
                   { |Scroll,n| _OOHG_Eval( ::OnVScrollBox, Scroll, n ) }, ;
                   ,,,,,, SB_VERT, .T. )
   ::VScrollBar:nLineSkip  := 1
   ::VScrollBar:nPageSkip  := 20

   ValidateScrolls( Self, .F. )

   ASSIGN ::OnRelease          VALUE ReleaseProcedure          TYPE "B"
   ASSIGN ::OnMove             VALUE MoveProcedure             TYPE "B"
   ASSIGN ::OnInit             VALUE InitProcedure             TYPE "B"
   ASSIGN ::OnSize             VALUE SizeProcedure             TYPE "B"
   ASSIGN ::OnClick            VALUE ClickProcedure            TYPE "B"
   ASSIGN ::OnRClick           VALUE RClickProcedure           TYPE "B"
   ASSIGN ::OnMClick           VALUE MClickProcedure           TYPE "B"
   ASSIGN ::OnDblClick         VALUE DblClickProcedure         TYPE "B"
   ASSIGN ::OnRDblClick        VALUE RDblClickProcedure        TYPE "B"
   ASSIGN ::OnMDblClick        VALUE MDblClickProcedure        TYPE "B"
   ASSIGN ::OnLostFocus        VALUE LostFocus                 TYPE "B"
   ASSIGN ::OnGotFocus         VALUE GotFocus                  TYPE "B"
   ASSIGN ::OnPaint            VALUE PaintProcedure            TYPE "B"
   ASSIGN ::OnMouseDrag        VALUE MouseDragProcedure        TYPE "B"
   ASSIGN ::OnMouseMove        VALUE MouseMoveProcedure        TYPE "B"
   ASSIGN ::OnScrollUp         VALUE ScrollUp                  TYPE "B"
   ASSIGN ::OnScrollDown       VALUE ScrollDown                TYPE "B"
   ASSIGN ::OnScrollLeft       VALUE ScrollLeft                TYPE "B"
   ASSIGN ::OnScrollRight      VALUE ScrollRight               TYPE "B"
   ASSIGN ::OnHScrollBox       VALUE HScrollBox                TYPE "B"
   ASSIGN ::OnVScrollBox       VALUE VScrollBox                TYPE "B"
   ASSIGN ::OnInteractiveClose VALUE InteractiveCloseProcedure TYPE "B"
   ASSIGN ::OnMaximize         VALUE MaximizeProcedure         TYPE "B"
   ASSIGN ::OnMinimize         VALUE MinimizeProcedure         TYPE "B"
   ASSIGN ::OnRestore          VALUE RestoreProcedure          TYPE "B"
   ::lVisible := ! ( HB_IsLogical( NoShow ) .AND. NoShow )
   ::BackColor := aRGB
   ::AutoRelease := ! ( HB_IsLogical( NoAutoRelease ) .AND. NoAutoRelease )

   If ! ::lInternal .AND. ValidHandler( hParent )
      AADD( GetFormObjectByHandle( hParent ):aChildPopUp, Self )
   EndIf

   _PushEventInfo()
   _OOHG_ThisForm      := Self
   _OOHG_ThisEventType := "WINDOW_DEFINE"
   _OOHG_ThisType      := "W"
   _OOHG_ThisControl   := NIL
   _OOHG_ThisObject    := Self

   Return Self

METHOD EndWindow() CLASS TForm

   LOCAL nPos

   nPos := ASCAN( _OOHG_ActiveForm, { |o| o:Name == ::Name .AND. o:hWnd == ::hWnd } )
   If nPos > 0
      ::nOldw := ::ClientWidth
      ::nOldh := ::ClientHeight
      ::nWindowState := ::GetWindowState()   ///obtiene el estado inicial de la ventana
      _OOHG_DeleteArrayItem( _OOHG_ActiveForm, nPos )
   EndIf
  _PopEventInfo()
  ::lDefined := .T.

   Return Nil

METHOD Register( hWnd, cName ) CLASS TForm

   Local mVar

   ::hWnd := hWnd
   ::StartInfo( hWnd )
   ::Name := cName

   AADD( _OOHG_aFormhWnd,    hWnd )
   AADD( _OOHG_aFormObjects, Self )

   mVar := "_" + cName
   PUBLIC &mVar. := Self

   RETURN NIL

METHOD Visible( lVisible, nFlags, nTime ) CLASS TForm

   ASSIGN nFlags VALUE nFlags TYPE "N"
   ASSIGN nTime  VALUE nTime  TYPE "N" DEFAULT 200

   IF HB_ISLOGICAL( lVisible )
      ::lVisible := lVisible
      IF ! ::ContainerVisible
         IF PCount() == 1
            HideWindow( ::hWnd )
         ELSE
            AnimateWindow( ::hWnd, nTime, nFlags, .T. )
         ENDIF
         ::OnHideFocusManagement()
      ELSE
         IF PCount() > 1
            AnimateWindow( ::hWnd, nTime, nFlags, .F. )
         ELSEIF ::Focused
            CShowControl( ::hWnd )
         ELSE
            ShowWindowNA( ::hWnd )
         ENDIF
         IF ! ::lShowed
            ::lShowed := .T.
            ::SetActivationFocus()
         ENDIF
         IF ::lProcMsgsOnVisible
            ProcessMessages()
         ENDIF
      ENDIF
      ::CheckClientsPos()
   ENDIF

   Return ::lVisible

METHOD Show( nFlags, nTime ) CLASS TForm

   IF PCount() == 0
      ::Visible := .T.
   ELSE
      ::Visible( .T., nFlags, nTime )
   ENDIF

   RETURN .T.

METHOD Hide( nFlags, nTime ) CLASS TForm

   IF PCount() == 0
      ::Visible := .F.
   ELSE
      ::Visible( .F., nFlags, nTime )
   ENDIF

   RETURN .T.

METHOD Activate( lNoStop, oWndLoop ) CLASS TForm

   IF ::Active
      MsgOOHGError( "ACTIVATE WINDOW: window " + ::Name + " is already active. Program terminated." )
   ENDIF

   ASSIGN lNoStop VALUE lNoStop TYPE "L" DEFAULT .F.

   IF _OOHG_ThisEventType == 'WINDOW_RELEASE' .AND. ! lNoStop
      MsgOOHGError( "ACTIVATE WINDOW: activation within a window's ON RELEASE is not allowed. Program terminated." )
   ENDIF

   TForm_WindowStructureClosed( Self )
   // If Len( _OOHG_ActiveForm ) > 0
   //    MsgOOHGError( "ACTIVATE WINDOW: DEFINE WINDOW structure is not closed. Program terminated." )
   // Endif

   IF _OOHG_ThisEventType == 'WINDOW_GOTFOCUS'
      MsgOOHGError( "ACTIVATE WINDOW: activation within a window's ON GOTFOCUS is not allowed. Program terminated." )
   ENDIF

   IF _OOHG_ThisEventType == 'WINDOW_LOSTFOCUS'
      MsgOOHGError( "ACTIVATE WINDOW: activation within a window's ON LOSTFOCUS is not allowed. Program terminated." )
   ENDIF

   // Checks for non-stop window
   IF ! HB_ISOBJECT( oWndLoop )
      oWndLoop := iif( lNoStop .AND. HB_ISOBJECT( _OOHG_Main ), _OOHG_Main, Self )
   ENDIF
   ::ActivateCount := oWndLoop:ActivateCount
   ::ActivateCount[ 1 ]++
   ::Active := .T.

   IF ::oWndClient !=  NIL
      ::oWndClient:Events_Size()
   ENDIF

   // Show window
   IF ::lVisible
      ::Show()
      _OOHG_UserWindow := Self
   ENDIF

   ::ProcessInitProcedure()

   ::ClientsPos()

   IF ::lRefreshDataOnActivate
      ::RefreshData()
   ENDIF

   // Starts the Message Loop
   IF ! lNoStop
      ::MessageLoop()
   ENDIF

   RETURN NIL

STATIC FUNCTION TForm_WindowStructureClosed( Self )

   If ASCAN( _OOHG_ActiveForm, { |o| o:Name == ::Name .AND. o:hWnd == ::hWnd } ) > 0
      MsgOOHGError( "ACTIVATE WINDOW: DEFINE WINDOW structure for window " + ::Name + " is not closed. Program terminated." )
   EndIf
   AEVAL( ::SplitChildList, { |o| TForm_WindowStructureClosed( o ) } )

   Return nil

   // Local lClosed, I
   //    lClosed := ( ASCAN( _OOHG_ActiveForm, { |o| o:Name == ::Name .AND. o:hWnd == ::hWnd } ) == 0 )
   //    I := LEN( ::SplitChildList )
   //    DO WHILE I > 0 .AND. lClosed
   //       lClosed := TForm_WindowStructureClosed( ::SplitChildList[ I ] )
   //       I--
   //    ENDDO
   // Return lClosed

METHOD MessageLoop() CLASS TForm

   IF ::ActivateCount[ 3 ] .AND. ::ActivateCount[ 1 ] > 0
      _OOHG_DoMessageLoop( ::ActivateCount )
   ENDIF

   RETURN NIL

METHOD Release() CLASS TForm

   IF ! ::lReleasing
      IF ! ::Active
         MsgOOHGError( "WINDOW RELEASE: " + ::Name + " is not active. Program terminated." )
      ENDIF
      ::lReleasing := .T.

      IF ValidHandler( ::hWnd )
         EnableWindow( ::hWnd )
         SendMessage( ::hWnd, WM_SYSCOMMAND, SC_CLOSE, 0 )
      ELSE
         _ReleaseWindowList( { Self } )
      ENDIF
   ENDIF

   RETURN NIL

METHOD RefreshData() CLASS TForm

   IF HB_ISBLOCK( ::Block )
      ::Value := Eval( ::Block )
   ENDIF
   AEval( ::aControls, { |o| iif( o:Container == NIL, o:RefreshData(), NIL ) } )

   RETURN NIL

METHOD SetActivationFocus() CLASS TForm

   Local Sp, nSplit

   nSplit := ASCAN( ::SplitChildList, { |o| o:Focused } )
   IF nSplit > 0
      ::SplitChildList[ nSplit ]:SetFocus()
   ELSEIF ::Focused
      Sp := GetFocus()
      IF ASCAN( ::aControls, { |o| o:hWnd == Sp } ) == 0
         SetFocus( GetNextDlgTabItem( ::hWnd, 0, .F. ) )
      ENDIF
   ENDIF

   Return nil

METHOD ProcessInitProcedure() CLASS TForm

   if HB_IsBlock( ::OnInit )
      ::DoEvent( ::OnInit, "WINDOW_INIT" )
   EndIf
   AEVAL( ::SplitChildList, { |o| o:ProcessInitProcedure() } )

   Return nil

METHOD NotifyIconObject() CLASS TForm

   IF LEN( ::aNotifyIcons ) == 0
      TNotifyIcon():Define( "0", Self )
   ENDIF

   RETURN ::aNotifyIcons[ 1 ]

METHOD NotifyIcon( IconName ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:Picture := IconName
   ENDIF

   RETURN ::NotifyIconObject:Picture

METHOD NotifyTooltip( TooltipText ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:ToolTip := TooltipText
   ENDIF

   RETURN ::NotifyIconObject:ToolTip

METHOD NotifyIconLeftClick( bClick ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:OnClick := bClick
   ENDIF

   RETURN ::NotifyIconObject:OnClick

METHOD NotifyIconDblClick( bClick ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:OnDblClick := bClick
   ENDIF

   RETURN ::NotifyIconObject:OnDblClick

METHOD NotifyIconRightClick( bClick ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:OnRClick := bClick
   ENDIF

   RETURN ::NotifyIconObject:OnRClick

METHOD NotifyIconRDblClick( bClick ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:OnRDblClick := bClick
   ENDIF

   RETURN ::NotifyIconObject:OnRDblClick

METHOD NotifyIconMidClick( bClick ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:OnMClick := bClick
   ENDIF

   RETURN ::NotifyIconObject:OnMClick

METHOD NotifyIconMDblClick( bClick ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:OnMDblClick := bClick
   ENDIF

   RETURN ::NotifyIconObject:OnMDblClick

METHOD NotifyMenu( oMenu ) CLASS TForm

   IF PCOUNT() > 0
      ::NotifyIconObject:ContextMenu := oMenu
   ENDIF

   RETURN ::NotifyIconObject:ContextMenu

METHOD cNotifyIconName( IconName ) CLASS TForm

   // Only for possible compatibility
   IF PCOUNT() > 0
      ::NotifyIconObject:Picture := IconName
   ENDIF

   RETURN ::NotifyIconObject:Picture

METHOD cNotifyIconToolTip( TooltipText ) CLASS TForm

   // Only for possible compatibility
   IF PCOUNT() > 0
      ::NotifyIconObject:ToolTip := TooltipText
   ENDIF
RETURN ::NotifyIconObject:ToolTip

METHOD AddNotifyIcon( cPicture, cToolTip, ProcedureName, ControlName ) CLASS TForm

   IF EMPTY( ControlName )
      ControlName := "0"
   ENDIF

   RETURN TNotifyIcon():Define( ControlName, Self, cPicture, cToolTip, ProcedureName )

METHOD Title( cTitle ) CLASS TForm

   Return ( ::Caption := cTitle )

METHOD Height( nHeight ) CLASS TForm

   if HB_IsNumeric( nHeight )
      ::SizePos( NIL, NIL, NIL, nHeight )
   endif

   Return GetWindowHeight( ::hWnd )

METHOD Width( nWidth ) CLASS TForm

   if HB_IsNumeric( nWidth )
      ::SizePos( NIL, NIL, nWidth )
   endif

   Return GetWindowWidth( ::hWnd )

METHOD Col( nCol ) CLASS TForm

   if HB_IsNumeric( nCol )
      ::SizePos( NIL, nCol )
   endif

   Return GetWindowCol( ::hWnd )

METHOD Row( nRow ) CLASS TForm

   If HB_IsNumeric( nRow )
      ::SizePos( nRow )
   EndIf

   Return GetWindowRow( ::hWnd )

METHOD VirtualWidth( nSize ) CLASS TForm

   If HB_IsNumeric( nSize )
      ::nVirtualWidth := nSize
      ValidateScrolls( Self, .T. )
   EndIf

   Return ::nVirtualWidth

METHOD VirtualHeight( nSize ) CLASS TForm

   If HB_IsNumeric( nSize )
      ::nVirtualHeight := nSize
      ValidateScrolls( Self, .T. )
   EndIf

   Return ::nVirtualHeight

METHOD FocusedControl() CLASS TForm

   Local hWnd, nPos

   hWnd := GetFocus()
   nPos := 0
   DO WHILE nPos == 0
      nPos := ASCAN( ::aControls, { |o| o:hWnd == hWnd } )
      IF nPos == 0
         hWnd := GetParent( hWnd )
         IF hWnd == ::hWnd .OR. ! ValidHandler( hWnd )
            EXIT
         ENDIF
      ENDIF
   ENDDO

   Return if( nPos == 0, "", ::aControls[ nPos ]:Name )

METHOD Cursor( uValue ) CLASS TForm

   IF uValue != nil
      IF SetWindowCursor( ::hWnd, uValue )
         ::uFormCursor := uValue
      ENDIF
   ENDIF

   Return ::uFormCursor

METHOD AutoAdjust( nDivH, nDivW ) CLASS TForm

   LOCAL lSwvisible, hImageWork

   lSwvisible := ::Visible
   If lSwvisible
      ::Hide()
   EndIf

   IF ::lStretchBack .AND. ValidHandler( ::hBackImage )
      hImageWork := _OOHG_ScaleImage( Self, ::hBackImage, ::ClientWidth, ::ClientHeight, .F., NIL, .F., 0, 0 )
      ::BackBitmap := hImageWork
      DeleteObject( hImageWork )
   ENDIF

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:AdjustResize( nDivH, nDivW ), ) } )

   IF lSwvisible
      ::Show()
   ENDIF

   RETURN nil

METHOD AdjustWindowSize( lSkip ) CLASS TForm

   LOCAL nWidth, nHeight, nOldWidth, nOldHeight, n, oControl, nHeightUsed

   nWidth  := ::ClientWidth
   nHeight := ::ClientHeight

   If HB_IsNumeric( ::nOldW ) .AND. HB_IsNumeric( ::nOldH )
      nOldWidth  := ::nOldW
      nOldHeight := ::nOldH
   Else
      nOldWidth  := nWidth
      nOldHeight := nHeight
   EndIf

   If _OOHG_AutoAdjust .AND. ::lAdjust .AND. ( ! HB_IsLogical( lSkip ) .OR. ! lSkip )
      ::nFixedHeightUsed := 0

      For n := 1 to Len( ::aControls )
         oControl := ::aControls[ n ]

         nHeightUsed := oControl:ClientHeightUsed
         If nHeightUsed > 0 .and. oControl:Container == Nil
            ::nFixedHeightUsed += nHeightUsed
         EndIf
      Next n

      ::AutoAdjust( (nHeight - ::nFixedHeightUsed) / (nOldHeight - ::nFixedHeightUsed), nWidth / nOldWidth )
   EndIf

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:AdjustAnchor( nHeight - nOldHeight, nWidth - nOldWidth ), ) } )

   ::ClientsPos()

   ::nOldW := nWidth
   ::nOldH := nHeight

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:Events_Size(), ) } )

   RETURN nil

METHOD ClientsPos() CLASS TForm

   Local aControls, nWidth, nHeight

   aControls := {}
   AEVAL( ::aControls, { |o| IF( o:Container == nil, AADD( aControls, o ), ) } )
   nWidth  := ::ClientWidth
   nHeight := ::ClientHeight

   Return ::ClientsPos2( aControls, nWidth, nHeight )


#pragma BEGINDUMP

HB_FUNC_STATIC( TFORM_BACKCOLOR )          /* METHOD BackColor( uColor ) CLASS TForm -> aRGB */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( oSelf->BrushHandle )
      {
         DeleteObject( oSelf->BrushHandle );
         oSelf->BrushHandle = NULL;
      }
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( oSelf->lBackColor != -1 )
         {
            oSelf->BrushHandle = CreateSolidBrush( oSelf->lBackColor );
            SetClassLongPtr( oSelf->hWnd, GCL_HBRBACKGROUND, ( LONG_PTR )  oSelf->BrushHandle );
         }
         else
         {
            SetClassLongPtr( oSelf->hWnd, GCL_HBRBACKGROUND, ( LONG_PTR ) ( COLOR_BTNFACE + 1 ) );
         }
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set by _OOHG_DetermineColorReturn()
}

HB_FUNC( SETFORMTOPMOST )
{
   HWND hWnd = HWNDparam( 1 );

   if( hb_parl( 2 ) )
   {
      SetWindowPos( hWnd, HWND_TOPMOST,   0, 0, 0, 0, SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE );
   }
   else
   {
      SetWindowPos( hWnd, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE | SWP_NOMOVE | SWP_NOSIZE );
   }
}

#pragma ENDDUMP


METHOD GetWindowState() CLASS TForm

  LOCAL uRet

  IF IsWindowMaximized( ::hWnd )
     uRet := FORM_MAXIMIZED
  ELSEIF IsWindowMinimized( ::hWnd )
     uRet := FORM_MINIMIZED
  ELSE
     uRet := FORM_NORMAL
  ENDIF

  RETURN uRet

METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TForm

   local xRet, actpos:= { 0, 0, 0, 0 }

   GetWindowRect( ::hWnd, actpos )
   If ! HB_IsNumeric( nCol )
      nCol := actpos[ 1 ]
   EndIf
   If ! HB_IsNumeric( nRow )
      nRow := actpos[ 2 ]
   EndIf
   If ! HB_IsNumeric( nWidth )
      nWidth := actpos[ 3 ] - actpos[ 1 ]
   EndIf
   If ! HB_IsNumeric( nHeight )
      nHeight := actpos[ 4 ] - actpos[ 2 ]
   EndIf
   xRet := MoveWindow( ::hWnd, nCol, nRow, nWidth, nHeight, .t. )
   //CGR
   ::CheckClientsPos()

   Return xRet

METHOD DeleteControl( oControl ) CLASS TForm

   Local nPos

   // Removes INTERNAL window from ::SplitChildList
   nPos := aScan( ::SplitChildList, { |o| o:hWnd == oControl:hWnd } )
   If nPos > 0
      _OOHG_DeleteArrayItem( ::SplitChildList, nPos )
   EndIf

   // Removes POPUP window from ::aChildPopUp
   nPos := aScan( ::aChildPopUp, { |o| o:hWnd == oControl:hWnd } )
   If nPos > 0
      _OOHG_DeleteArrayItem( ::aChildPopUp, nPos )
   EndIf

   Return ::Super:DeleteControl( oControl )

METHOD OnHideFocusManagement() CLASS TForm

   Return nil

METHOD Closable( lCloseable ) CLASS TForm

   Local lRet

   If IsWindowStyle( ::hWnd, WS_CAPTION ) .AND. IsWindowStyle( ::hWnd, WS_SYSMENU )
      lRet := MenuEnabled( GetSystemMenu( ::hWnd ), SC_CLOSE, lCloseable )
   Else
      lRet := .F.
   EndIf

   Return lRet

METHOD CheckInteractiveClose() CLASS TForm

   LOCAL lRet := .T.
   /*
   0 - close is not allowed
   1 - close is allowed, no question is asked before
   2 - close is allowed when question is answered yes
   */
   DO CASE
   CASE ::InteractiveClose == 0 .OR. ( ::InteractiveClose == -1 .AND. _OOHG_InteractiveClose == 0 )
      MsgStop( _OOHG_Messages( MT_MISCELL, 3 ) )
      lRet := .F.
   CASE ::InteractiveClose == 2 .OR. ( ::InteractiveClose == -1 .AND. _OOHG_InteractiveClose == 2 )
      lRet := MsgYesNo( _OOHG_Messages( MT_MISCELL, 1 ), _OOHG_Messages( MT_MISCELL, 2 ) )
   ENDCASE

   RETURN lRet

METHOD DoEvent( bBlock, cEventType, aParams ) CLASS TForm

   Local lRetVal := .F.

   If ::lDisableDoEvent
      lRetVal := .F.
   ElseIf HB_IsBlock( bBlock )
      _PushEventInfo()
      _OOHG_ThisForm      := Self
      _OOHG_ThisType      := "W"
      ASSIGN _OOHG_ThisEventType VALUE cEventType TYPE "CM" DEFAULT ""
      _OOHG_ThisControl   := NIL
      _OOHG_ThisObject    := Self
      lRetVal := _OOHG_Eval_Array( bBlock, aParams )
      _PopEventInfo()
   EndIf

   Return lRetVal

METHOD Events_Destroy() CLASS TForm

   LOCAL mVar, i

   IF ::lDestroyed
      RETURN NIL
   ENDIF
   ::lDestroyed := .T.

   IF ! ::lReleased
      ::ReleaseAttached()
      ::lReleased := .T.
   ENDIF

   // Update Form Index Variable
   IF ! Empty( ::Name )
      mVar := '_' + ::Name
      IF Type( mVar ) != 'U'
         __mvPut( mVar, 0 )
         __mvXRelease( mVar )
      ENDIF
   ENDIF

   // Removes from container
   IF ::Container != NIL
      ::Container:DeleteControl( Self )
   ENDIF

   // Removes from parent
   IF ::Parent != NIL
      ::Parent:DeleteControl( Self )
   ENDIF

   // Verify if window was multi-activated
   IF ::Active
      ::ActivateCount[ 1 ]--
      IF ::ActivateCount[ 1 ] < 1
         _MessageLoopEnd( ::ActivateCount[ 2 ] )
         ::ActivateCount[ 2 ] := NIL
         ::ActivateCount[ 3 ] := .T.
      ENDIF
   ENDIF

   // Remove from the arrays
   i := AScan( _OOHG_aFormhWnd, ::hWnd )
   IF i > 0
      _OOHG_DeleteArrayItem( _OOHG_aFormhWnd, i )
      _OOHG_aFormObjects[i] := NIL
      _OOHG_DeleteArrayItem( _OOHG_aFormObjects, i )
   ENDIF

   // Eliminates active modal
   IF Len( _OOHG_ActiveModal ) != 0 .AND. ATail( _OOHG_ActiveModal ):hWnd == ::hWnd
      _OOHG_DeleteArrayItem( _OOHG_ActiveModal, Len( _OOHG_ActiveModal ) )
   ENDIF

   IF _OOHG_UserWindow # NIL .AND. _OOHG_UserWindow:hWnd == ::hWnd
      _OOHG_UserWindow := NIL
   ENDIF

   ::Active := .F.

   ::Super:Release()

   ::hWnd := NIL

   /*
    * UnRegisterWindow( ::Name )
    *
    * This doesn't work because a class can't be unregistered
    * while a window of that class still exists.
    * After destroying the window at WM_CLOSE, we also can't do
    * that because we no longer have access to the form's object.
    * To circumvent this limitation we must unregister at ::Define
    * before registering the class again.
    * Unregistered classes will not leak because Windows automatically
    * disposes them at the end of the application.
    */

   RETURN NIL

METHOD ReleaseAttached CLASS TForm

   // Avoid problems with detached references
   ::OnRelease          := NIL
   ::OnInit             := NIL
   ::OnMove             := NIL
   ::OnSize             := NIL
   ::OnPaint            := NIL
   ::OnScrollUp         := NIL
   ::OnScrollDown       := NIL
   ::OnScrollLeft       := NIL
   ::OnScrollRight      := NIL
   ::OnHScrollBox       := NIL
   ::OnVScrollBox       := NIL
   ::OnInteractiveClose := NIL
   ::OnMaximize         := NIL
   ::OnMinimize         := NIL
   ::OnRestore          := NIL

   // Any data must be destroyed... regardless FORM is active or not.
   IF ! Empty( ::NotifyIcon )
      ::NotifyIconObject:Release()
   ENDIF
   IF ::oMenu != NIL
      ::oMenu:Release()
      ::oMenu := NIL
   ENDIF
   IF HB_ISOBJECT( ::oToolTip )
      ::oToolTip:Release()
   ENDIF
   ::oToolTip := NIL
   ::oWndClient := NIL

   DeleteObject( ::hBackImage )

   RETURN ::Super:ReleaseAttached()

METHOD Events_VScroll( wParam ) CLASS TForm

   Local uRet, nAt

   uRet := ::VScrollBar:Events_VScroll( wParam )
   ::RowMargin := - ::VScrollBar:Value
   ::ScrollControls()
   IF ( nAt := aScan( ::aControls, { |c| c:Type == "MESSAGEBAR" .AND. c:Visible } ) ) > 0
      ::aControls[ nAt ]:Redraw()
   ENDIF

   Return uRet

METHOD Events_HScroll( wParam ) CLASS TForm

   Local uRet

   uRet := ::HScrollBar:Events_HScroll( wParam )
   ::ColMargin := - ::HScrollBar:Value
   ::ScrollControls()

   Return uRet

METHOD ScrollControls() CLASS TForm

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:SizePos(), ) } )
   ReDrawWindow( ::hWnd )

   RETURN Self

METHOD Topmost( lTopmost ) CLASS TForm

   If HB_IsLogical( lTopmost )
      ::lTopmost := lTopmost
      SetFormTopmost( ::hWnd, lTopmost )
   EndIf

   Return ::lTopmost

METHOD HelpButton( lShow ) CLASS TForm

   If HB_IsLogical( lShow )
      If lShow
         WindowExStyleFlag( ::hWnd, WS_EX_CONTEXTHELP, WS_EX_CONTEXTHELP )
         WindowStyleFlag( ::hWnd, WS_MAXIMIZEBOX + WS_MINIMIZEBOX, 0 )
      Else
         WindowExStyleFlag( ::hWnd, WS_EX_CONTEXTHELP, 0 )
         WindowStyleFlag( ::hWnd, WS_MAXIMIZEBOX + WS_MINIMIZEBOX, WS_MAXIMIZEBOX + WS_MINIMIZEBOX )
      EndIf
      SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_FRAMECHANGED )
   EndIf

   Return IsWindowExStyle( ::hWnd, WS_EX_CONTEXTHELP )

METHOD BackImage( uBackImage ) CLASS TForm

   LOCAL hImageWork

   If PCount() > 0
      If ::hBackImage != NIL
         DeleteObject( ::hBackImage )
      Endif

      If ValType( uBackImage ) $ "CM"
         ::hBackImage := _OOHG_BitmapFromFile( Self, uBackImage, LR_CREATEDIBSECTION, .F. )
      ElseIf ValidHandler( uBackImage )
         ::hBackImage := uBackImage
      Else
         ::hBackImage := NIL
      EndIf

      If ::hBackImage == NIL
         ::BackBitmap := NIL
      Else
         If ::lStretchBack
            hImageWork := _OOHG_ScaleImage( Self, ::hBackImage, ::ClientWidth, ::ClientHeight, .F., NIL, .F., 0, 0 )
         Else
            hImageWork := _OOHG_CopyBitmap( ::hBackImage, 0, 0, LR_CREATEDIBSECTION )
         Endif
         ::BackBitmap := hImageWork
         DeleteObject( hImageWork )
      EndIf

      ReDrawWindow( ::hWnd )
   EndIf

   Return ::hBackImage

METHOD Flash( nWhat, nTimes, nMilliseconds ) CLASS TForm

   /*
    * nWhat            action
    * FLASHW_CAPTION   Flash the window caption.
    * FLASHW_TRAY      Flash the taskbar button.
    * FLASHW_ALL       Flash both the window caption and the taskbar button.
    * FLASHW_TIMER     Add to one the of the previous values to flash continuously until the FLASHW_STOP flag is set.
    * FLASHW_STOP      Stop flashing. The system restores the window to its original state.
    * FLASHW_TIMERNOFG Add to FLASHW_TRAY to continuously flash the taskbar button until the window comes to the foreground.
    *
    * nTimes           Number of times to flash the window.
    *                  Set to 0 when using FLASHW_TIMER to obtain non-stop flashing.
    *                  Set to 0 when using FLASHW_CAPTION, FLASHW_TRAY or FLASHW_ALL to toggle the current flash status.
    *
    * nMilliseconds    Flashing interval. 0 means use the default cursor blink rate
    *
    * If the window caption was drawn as active before the call, the return value is .T.
    * Otherwise, the return value is .F.
    */

   Return FlashWindowEx( ::hWnd, nWhat, nTimes, nMilliseconds )


#pragma BEGINDUMP

#ifndef WM_MOUSEHWHEEL
#define WM_MOUSEHWHEEL 0x020e
#endif

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TFORM_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TForm
// -----------------------------------------------------------------------------
{
   static PHB_SYMB s_Events2 = 0;

   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) HB_PARNL( 3 );
   LPARAM lParam  = ( LPARAM ) HB_PARNL( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_ERASEBKGND:
         {
            POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
            HBRUSH hBrush;
            RECT rect;
            GetClientRect( hWnd, &rect );
            hBrush = oSelf->BrushHandle ? oSelf->BrushHandle : ( HBRUSH ) ( COLOR_BTNFACE + 1 );
            FillRect( ( HDC ) wParam, &rect, hBrush );
            hb_retni( 1 );
         }
         break;

      case WM_LBUTTONUP:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         hb_ret();
         break;

      case WM_LBUTTONDOWN:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnClick, "CLICK", lParam );
         hb_ret();
         break;

      case WM_LBUTTONDBLCLK:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnDblClick, "DBLCLICK", lParam );
         hb_ret();
         break;

      case WM_RBUTTONUP:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnRClick, "RCLICK", lParam );
         hb_ret();
         break;

      case WM_RBUTTONDOWN:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         hb_ret();
         break;

      case WM_RBUTTONDBLCLK:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnRDblClick, "RDBLCLICK", lParam );
         hb_ret();
         break;

      case WM_MBUTTONUP:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnMClick, "MCLICK", lParam );
         hb_ret();
         break;

      case WM_MBUTTONDOWN:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         hb_ret();
         break;

      case WM_MBUTTONDBLCLK:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnMDblClick, "MDBLCLICK", lParam );
         hb_ret();
         break;

      case WM_MOUSEMOVE:
         _OOHG_SetMouseCoords( pSelf, GET_X_LPARAM( lParam ), GET_Y_LPARAM( lParam ) );
         if( wParam == MK_LBUTTON )
         {
            _OOHG_DoEventMouseCoords( pSelf, s_OnMouseDrag, "MOUSEDRAG", lParam );
         }
         else
         {
            _OOHG_DoEventMouseCoords( pSelf, s_OnMouseMove, "MOUSEMOVE", lParam );
         }
         hb_ret();
         break;

      case WM_NCMOUSEMOVE:
         if( wParam == HTMENU )
         {
            _OOHG_Send( pSelf, s_hWnd );
            hb_vmSend( 0 );
            if( ValidHandler( HWNDparam( -1 ) ) )
            {
               PHB_ITEM pMenu;
               _OOHG_Send( pSelf, s_oMenu );
               hb_vmSend( 0 );
               pMenu = hb_param( -1, HB_IT_OBJECT );
               if( pMenu )
               {
                  POCTRL oMenu;
                  HMENU hMenu;
                  oMenu = _OOHG_GetControlInfo( pMenu );
                  hMenu = ( HMENU ) oMenu->hWnd;
                  if( IsMenu( hMenu ) )
                  {
                     POINT ptScreen;
                     INT iPos;
                     MENUITEMINFO MenuItemInfo;
                     ptScreen.x = GET_X_LPARAM( lParam );
                     ptScreen.y = GET_Y_LPARAM( lParam );
                     iPos = MenuItemFromPoint( hWnd, hMenu, ptScreen );
                     if( iPos > -1 )
                     {
                        PHB_ITEM pMenuItem = hb_itemNew( NULL );
                        memset( &MenuItemInfo, 0, sizeof( MenuItemInfo ) );
                        MenuItemInfo.cbSize = sizeof( MenuItemInfo );
                        MenuItemInfo.fMask = MIIM_ID | MIIM_SUBMENU;
                        GetMenuItemInfo( hMenu, iPos, MF_BYPOSITION, &MenuItemInfo );
                        if( MenuItemInfo.hSubMenu )
                        {
                           hb_itemCopy( pMenuItem, GetControlObjectByHandle( ( HWND ) MenuItemInfo.hSubMenu, TRUE ) );
                        }
                        else
                        {
                           hb_itemCopy( pMenuItem, GetControlObjectById( MenuItemInfo.wID, hWnd ) );
                        }
                        _OOHG_Send( pMenuItem, s_Events_MenuHilited );
                        hb_vmSend( 0 );
                        hb_itemRelease( pMenuItem );
                     }
                  }
               }
            }
         }
         hb_ret();
         break;

      case WM_MOUSEHWHEEL:
         _OOHG_Send( pSelf, s_hWnd );
         hb_vmSend( 0 );
         if( ValidHandler( HWNDparam( -1 ) ) )
         {
            _OOHG_Send( pSelf, s_RangeWidth );
            hb_vmSend( 0 );
            if( hb_parnl( -1 ) > 0 )
            {
               if( GET_WHEEL_DELTA_WPARAM( wParam ) > 0 )
               {
                  _OOHG_Send( pSelf, s_Events_HScroll );
                  hb_vmPushLong( SB_LINERIGHT );
                  hb_vmSend( 1 );
               }
               else
               {
                  _OOHG_Send( pSelf, s_Events_HScroll );
                  hb_vmPushLong( SB_LINELEFT );
                  hb_vmSend( 1 );
               }
            }
         }
         hb_ret();
         break;

      case WM_MOUSEWHEEL:
         _OOHG_Send( pSelf, s_hWnd );
         hb_vmSend( 0 );
         if( ValidHandler( HWNDparam( -1 ) ) )
         {
            _OOHG_Send( pSelf, s_RangeHeight );
            hb_vmSend( 0 );
            if( hb_parnl( -1 ) > 0 )
            {
               if( GET_WHEEL_DELTA_WPARAM( wParam ) > 0 )
               {
                  _OOHG_Send( pSelf, s_Events_VScroll );
                  hb_vmPushLong( SB_LINEUP );
                  hb_vmSend( 1 );
               }
               else
               {
                  _OOHG_Send( pSelf, s_Events_VScroll );
                  hb_vmPushLong( SB_LINEDOWN );
                  hb_vmSend( 1 );
               }
            }
         }
         hb_ret();
         break;

      default:
         if( ! s_Events2 )
         {
            s_Events2 = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_TFORM_EVENTS2" ) );
         }
         hb_vmPushSymbol( s_Events2 );
         hb_vmPushNil();
         hb_vmPush( pSelf );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushNumInt( wParam );
         hb_vmPushNumInt( lParam );
         hb_vmDo( 5 );
         break;
   }
}

#pragma ENDDUMP


FUNCTION _OOHG_TForm_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TForm

   Local i, NextControlHandle, xRetVal
   Local oCtrl, lMinim, nOffset, nDesp

   Do Case

   case nMsg == WM_HOTKEY

      // Process HotKeys
      i := ASCAN( ::aHotKeys, { |a| a[ HOTKEY_ID ] == wParam } )
      If i > 0
         ::DoEvent( ::aHotKeys[ i ][ HOTKEY_ACTION ], "HOTKEY" )
      EndIf

      // Accelerators
      i := ASCAN( ::aAcceleratorKeys, { |a| a[ HOTKEY_ID ] == wParam } )
      If i > 0
         ::DoEvent( ::aAcceleratorKeys[ i ][ HOTKEY_ACTION ], "ACCELERATOR" )
      EndIf

   case nMsg == WM_ACTIVATE

      If LoWord(wparam) == 0      // WA_INACTIVE

         aeval( ::aHotKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )
         ::LastFocusedControl := GetFocus()
         If ! ::ContainerReleasing
            ::DoEvent( ::OnLostFocus, "WINDOW_LOSTFOCUS" )
         EndIf

      Else

         If ValidHandler( ::hWnd )
            UpdateWindow( ::hWnd )
         EndIf

      EndIf

   case nMsg == WM_SETFOCUS

      If ::Active .AND. ! ::lInternal
         _OOHG_UserWindow := Self
      EndIf
      aeval( ::aHotKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )
      aeval( ::aHotKeys, { |a| InitHotKey( ::hWnd, a[ HOTKEY_MOD ], a[ HOTKEY_KEY ], a[ HOTKEY_ID ] ) } )
      ::DoEvent( ::OnGotFocus, "WINDOW_GOTFOCUS" )
      If ! empty( ::LastFocusedControl )
         SetFocus( ::LastFocusedControl )
      EndIf

   case nMsg == WM_HELP

      Return ::HelpTopic( lParam )

   case nMsg == WM_TASKBAR

      i := ASCAN( ::aNotifyIcons, { |o| o:nTrayId == wParam } )
      If i > 0
         ::aNotifyIcons[ i ]:Events_TaskBar( lParam )
      EndIf

   case nMsg == WM_NEXTDLGCTL

      If LoWord( lParam ) != 0
         // wParam contains next control's handler
         NextControlHandle := wParam
      Else
         // wParam indicates next control's direction
         NextControlHandle := GetNextDlgTabItem( hWnd, GetFocus(), wParam )
      EndIf

      oCtrl := GetControlObjectByHandle( NextControlHandle )

      If oCtrl:hWnd == NextControlHandle
         oCtrl:SetFocus()
      Else
         SetFocus( NextControlHandle )
      Endif

      * To update the default pushbutton border!
      * To set the default control identifier!
      * Return 0

   case nMsg == WM_PAINT

      IF ! ::NoDefWinProc
         ::DefWindowProc( nMsg, wParam, lParam )
      ENDIF

      AEVAL( ::SplitChildList, { |o| AEVAL( o:GraphTasks, { |b| _OOHG_EVAL( b ) } ), _OOHG_EVAL( o:GraphCommand, o:hWnd, o:GraphData ) } )

      ::DoEvent( ::OnPaint, "WINDOW_PAINT" )

      AEVAL( ::GraphTasks, { |b| _OOHG_EVAL( b ) } )
      _OOHG_EVAL( ::GraphCommand, ::hWnd, ::GraphData )

      IF ::nBorders[ 1 ] + ::nBorders[ 2 ] + ::nBorders[ 3 ] > 0
         ::GetDc()
         // external border
         ::Fill( 0, 0, ::nBorders[ 1 ], ::ClientWidth, ::aBEColors[ 1 ] )
         ::Fill( 0, ::ClientWidth, ::ClientHeight - ::nBorders[ 1 ], ::ClientWidth - ::nBorders[ 1 ], ::aBEColors[ 2 ] )
         ::Fill( ::ClientHeight, ::ClientWidth, ::ClientHeight - ::nBorders[ 1 ], 0, ::aBEColors[ 3 ] )
         ::Fill( 0, 0, ::ClientHeight, ::nBorders[ 1 ], ::aBEColors[ 4 ] )
         //internal border
         nOffSet := ::nBorders[ 1 ] + ::nBorders[ 2 ]
         nDesp := ::nBorders[ 1 ] + ::nBorders[ 2 ] + ::nBorders[ 3 ]
         ::Fill( nOffSet, nOffSet, nDesp, ::ClientWidth - nOffSet, ::aBIColors[ 1 ] )
         ::Fill( nOffSet, ::ClientWidth - nOffSet, ::Clientheight - nOffSet, ::Clientwidth - nDesp, ::aBIColors[ 2 ] )
         ::Fill( ::ClientHeight - nOffSet, ::ClientWidth - nOffSet, ::ClientHeight - nDesp, nOffSet, ::aBIColors[ 3 ] )
         ::Fill( nOffSet, nOffSet, ::ClientHeight - nDesp, nDesp, ::aBIColors[4])
         ::ReleaseDc()
      EndIf

      RETURN iif( ::NoDefWinProc, NIL, 1 )

   case nMsg == WM_ENTERSIZEMOVE

      If ! ! _OOHG_AutoAdjust .OR. ! ::lAdjust
         ::lEnterSizeMove := .T.
      EndIf

   case nMsg == WM_MOVE

      ::DoEvent( ::OnMove, "WINDOW_MOVE" )

   case nMsg == WM_SIZE

      IF ! ::lEnterSizeMove
         ValidateScrolls( Self, .T. )
         If ::Active
            lMinim := .F.
            DO CASE
            CASE wParam == SIZE_MAXIMIZED
               ::DoEvent( ::OnMaximize, "WINDOW_MAXIMIZE" )

            CASE wParam == SIZE_MINIMIZED
               ::DoEvent( ::OnMinimize, "WINDOW_MINIMIZE" )
               lMinim := .T.

            CASE wParam == SIZE_RESTORED
               ::DoEvent( ::OnRestore, "WINDOW_RESTORE" )

            ENDCASE
            If ! lMinim
               ::AdjustWindowSize( lMinim )
            EndIf
            ::DoEvent( ::OnSize, "WINDOW_SIZE" )
         Else
            If ::lDefined
               ::AdjustWindowSize()
            Endif
         EndIf
      Endif

      If ::oWndClient != NIL
         // It was already done
         // ::oWndClient:Events_Size()
         Return 0
      EndIf

   case nMsg == WM_EXITSIZEMOVE    //// cuando se cambia el tamaño por reajuste con el mouse

      If ::Active .AND. ( ! _OOHG_AutoAdjust .OR. ! ::lAdjust .OR. ( ::nOldW # NIL .OR. ::nOldH # NIL ) .AND. ( ::nOldW # ::Width .OR. ::nOldH # ::Height ) )
         ::AdjustWindowSize()
         ::DoEvent( ::OnSize, "WINDOW_SIZE" )
      Endif
      ::lEnterSizeMove := .F.

   case nMsg == WM_SIZING

      If _TForm_Sizing( wParam, lParam, ::MinWidth, ::MaxWidth, ::MinHeight, ::MaxHeight )
         ::DefWindowProc( nMsg, wParam, lParam )
         Return 1
      EndIf

   case nMsg == WM_MOVING

      If _TForm_Moving( lParam, ::ForceRow, ::ForceCol )
         ::DefWindowProc( nMsg, wParam, lParam )
         Return 1
      EndIf

   case nMsg == WM_CLOSE

      // ::lReleasing must be checked every time because it can be changed by any process.
      If ! ::lReleasing .AND. HB_IsBlock( ::OnInteractiveClose )
         xRetVal := ::DoEvent( ::OnInteractiveClose, "WINDOW_ONINTERACTIVECLOSE" )
         If HB_IsLogical( xRetVal ) .AND. ! xRetVal
            Return 1
         EndIf
      EndIf

      If ! ::lReleasing .AND. ! ::CheckInteractiveClose()
         Return 1
      EndIf

      // Process AutoRelease property
      If ! ::lReleasing .AND. ! ::AutoRelease
         ::Hide()
         Return 1
      EndIf

      IF ::Type == "A"
         IF _OOHG_WinReleaseSameOrder
            // Destroy Main first
            _ReleaseWindowList( { Self } )
         ENDIF
         // Destroy other windows
         ReleaseAllWindows()
         // Processing will never reach this point
      ELSE
         // Destroy window
         _ReleaseWindowList( { Self } )
      ENDIF

      RETURN 0

      /*
       * This function must return 0 after processing WM_CLOSE so the
       * OS can do it's default processing. This processing ends with
       * (a) posting a WM_DESTROY message to the queue (will be
       * processed by this same function), immediately followed by
       * (b) sending a WM_NCDESTROY message to the form's WindowProc,
       * (there's no need to process it because all child control are
       * already released).
       */

   case nMsg == WM_DESTROY

      /*
       * This will be executed for all windows except MAIN
       * but only if ReleaseAllWindows() is not executed
       */
      ::Events_Destroy()

      RETURN 0

   otherwise

      return ::TWindow:Events( hWnd, nMsg, wParam, lParam )

   EndCase

   Return nil


#pragma BEGINDUMP

int _OOHG_AdjustSize( int iBorder, RECT * rect, int iMinWidth, int iMaxWidth, int iMinHeight, int iMaxHeight )
{
   int iWidth, iHeight;
   BOOL bChanged = 0;

   iWidth  = rect->right - rect->left;
   iHeight = rect->bottom - rect->top;

   if( iMinWidth > 0 && iMinWidth > iWidth )
   {
      iWidth = iMinWidth;
   }
   if( iMaxWidth > 0 && iMaxWidth < iWidth )
   {
      iWidth = iMaxWidth;
   }
   if( iWidth != ( rect->right - rect->left ) )
   {
      if( iBorder == WMSZ_BOTTOMLEFT || iBorder == WMSZ_LEFT || iBorder == WMSZ_TOPLEFT )
      {
         rect->left = rect->right - iWidth;
      }
      else
      {
         rect->right = rect->left + iWidth;
      }
      bChanged = 1;
   }

   if( iMinHeight > 0 && iMinHeight > iHeight )
   {
      iHeight = iMinHeight;
   }
   if( iMaxHeight > 0 && iMaxHeight < iHeight )
   {
      iHeight = iMaxHeight;
   }
   if( iHeight != ( rect->bottom - rect->top ) )
   {
      if( iBorder == WMSZ_TOPLEFT || iBorder == WMSZ_TOP || iBorder == WMSZ_TOPRIGHT )
      {
         rect->top = rect->bottom - iHeight;
      }
      else
      {
         rect->bottom = rect->top + iHeight;
      }
      bChanged = 1;
   }

   return bChanged;
}

HB_FUNC_STATIC( _TFORM_SIZING )   // wParam, lParam, nMinWidth, nMaxWidth, nMinHeight, nMaxHeight
{
   hb_retl( _OOHG_AdjustSize( hb_parni( 1 ), ( RECT * ) HB_PARNL( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ) ) );
}

int _OOHG_AdjustPosition( RECT * rect, int iForceRow, int iForceCol )
{
   BOOL bChanged = 0;

   if( iForceRow >= 0 && rect->top != iForceRow )
   {
      rect->bottom = iForceRow + ( rect->bottom - rect->top );
      rect->top = iForceRow;
      bChanged = 1;
   }

   if( iForceCol >= 0 && rect->left != iForceCol )
   {
      rect->right = iForceCol + ( rect->right - rect->left );
      rect->left = iForceCol;
      bChanged = 1;
   }

   return bChanged;
}

HB_FUNC_STATIC( _TFORM_MOVING )   // lParam, nForceRow, nForceCol
{
   int iForceRow, iForceCol;

   if( HB_ISNUM( 2 ) )
   {
      iForceRow = hb_parni( 2 );
   }
   else
   {
      iForceRow = -1;
   }

   if( HB_ISNUM( 3 ) )
   {
      iForceCol = hb_parni( 3 );
   }
   else
   {
      iForceCol = -1;
   }

   hb_retl( _OOHG_AdjustPosition( ( RECT * ) HB_PARNL( 1 ), iForceRow, iForceCol ) );
}

#pragma ENDDUMP


Procedure ValidateScrolls( Self, lMove )

   Local hWnd, nVirtualWidth, nVirtualHeight
   Local aRect, w, h, hscroll, vscroll

   If ! ValidHandler( ::hWnd ) .OR. ::HScrollBar == nil .OR. ::VScrollBar == nil
      Return
   EndIf

   // Initializes variables
   hWnd := ::hWnd
   nVirtualWidth := ::VirtualWidth
   nVirtualHeight := ::VirtualHeight
   If !HB_IsLogical( lMove )
      lMove := .F.
   EndIf
   vscroll := hscroll := .F.
   aRect := ARRAY( 4 )
   GetClientRect( hWnd, aRect )
   w := aRect[ 3 ] - aRect[ 1 ] + IF( IsWindowStyle( ::hWnd, WS_VSCROLL ), GetVScrollBarWidth(),  0 )
   h := aRect[ 4 ] - aRect[ 2 ] + IF( IsWindowStyle( ::hWnd, WS_HSCROLL ), GetHScrollBarHeight(), 0 )
   ::RangeWidth := ::RangeHeight := 0

   // Checks if there's space on the window
   If h < nVirtualHeight
      ::RangeHeight := nVirtualHeight - h
      vscroll := .T.
      w -= GetVScrollBarWidth()
   EndIf
   If w < nVirtualWidth
      ::RangeWidth := nVirtualWidth - w
      hscroll := .T.
      h -= GetHScrollBarHeight()
   EndIf
   If h < nVirtualHeight .AND. ! vscroll
      ::RangeHeight := nVirtualHeight - h
      vscroll := .T.
      w -= GetVScrollBarWidth()
   EndIf

   // Shows/hides scroll bars
   _SetScroll( hWnd, hscroll, vscroll )
   ::VScrollBar:lAutoMove := vscroll
   ::VScrollBar:nPageSkip := h
   ::HScrollBar:lAutoMove := hscroll
   ::HScrollBar:nPageSkip := w

   // Verifies there's no "extra" space derived from resize
   If vscroll
      ::VScrollBar:SetRange( 0, ::VirtualHeight )
      ::VScrollBar:Page := h
      If ::RangeHeight < ( - ::RowMargin )
         ::RowMargin := - ::RangeHeight
         ::VScrollBar:Value := ::RangeHeight
      Else
         vscroll := .F.
      EndIf
   ElseIf nVirtualHeight > 0 .AND. ::RowMargin != 0
      ::RowMargin := 0
      vscroll := .T.
   EndIf
   If hscroll
      ::HScrollBar:SetRange( 0, ::VirtualWidth )
      ::HScrollBar:Page := w
      If ::RangeWidth < ( - ::ColMargin )
         ::ColMargin := - ::RangeWidth
         ::HScrollBar:Value := ::RangeWidth
      Else
         hscroll := .F.
      EndIf
   ElseIf nVirtualWidth > 0 .AND. ::ColMargin != 0
      ::ColMargin := 0
      hscroll := .T.
   EndIf

   // Reubicates controls
   If lMove .AND. ( vscroll .OR. hscroll )
      ::ScrollControls()
   EndIf

   Return


CLASS TFormMain FROM TForm

   DATA Type           INIT "A" READONLY
   DATA lFirstActivate INIT .F.

   METHOD Define
   METHOD Activate
   METHOD Release

   METHOD CheckInteractiveClose

   ENDCLASS

METHOD Define( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, ;
               nosysmenu, nocaption, initprocedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, noshow, topmost, ;
               icon, fontname, fontsize, NotifyIconName, NotifyIconTooltip, ;
               NotifyIconLeftClick, GotFocus, LostFocus, virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, helpbutton, maximizeprocedure, ;
               minimizeprocedure, cursor, InteractiveCloseProcedure, lRtl, ;
               mdi, clientarea, restoreprocedure, RClickProcedure, ;
               MClickProcedure, DblClickProcedure, RDblClickProcedure, ;
               MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
               MoveProcedure, fontcolor, nodwp, nICL ) CLASS TFormMain

   Local nStyle := 0, nStyleEx := 0

   If _OOHG_Main != NIL
      MsgOOHGError( "Main window already defined. Program terminated." )
   Endif
   _OOHG_Main := Self

   ASSIGN icon VALUE icon TYPE "CM" DEFAULT _OOHG_Main_Icon

   nStyle += WS_POPUP

   ::Define2( FormName, Caption, x, y, w, h, 0, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NIL, nStyle, nStyleEx, ;
              TYPE_OTHERS, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              MoveProcedure, fontcolor, nodwp, nICL )

   ::NotifyIconObject:Picture := NotifyIconName
   ::NotifyIconObject:ToolTip := NotifyIconToolTip
   ::NotifyIconObject:OnClick := NotifyIconLeftClick

   Return Self

METHOD Activate( lNoStop, oWndLoop ) CLASS TFormMain

   ::lFirstActivate := .T.

   Return ::Super:Activate( lNoStop, oWndLoop )

METHOD Release() CLASS TFormMain

   ::Super:Release()
   // Processing will never reach this point

   RETURN NIL

METHOD CheckInteractiveClose() CLASS TFormMain

   LOCAL lRet

   IF ::InteractiveClose == 3 .OR. ( ::InteractiveClose == -1 .AND. _OOHG_InteractiveClose == 3 )
      lRet := MsgYesNo( _OOHG_Messages( MT_MISCELL, 1 ), _OOHG_Messages( MT_MISCELL, 2 ) )
   ELSE
      lRet := ::Super:CheckInteractiveClose()
   ENDIF

   RETURN lRet


CLASS TFormModal FROM TForm

   DATA Type           INIT "M" READONLY
   DATA LockedForms    INIT {}
   DATA oPrevWindow    INIT nil

   METHOD Define
   METHOD Visible      SETGET
   METHOD Activate
   METHOD Release
   METHOD OnHideFocusManagement

   ENDCLASS

METHOD Define( FormName, Caption, x, y, w, h, Parent, nosize, nosysmenu, ;
               nocaption, InitProcedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, icon, FontName, ;
               FontSize, GotFocus, LostFocus, virtualheight, VirtualWidth, ;
               scrollleft, scrollright, scrollup, scrolldown, hscrollbox, ;
               vscrollbox, helpbutton, cursor, noshow, NoAutoRelease, ;
               InteractiveCloseProcedure, lRtl, modalsize, mdi, topmost, ;
               clientarea, restoreprocedure, RClickProcedure, ;
               MClickProcedure, DblClickProcedure, RDblClickProcedure, ;
               MDblClickProcedure, nominimize, nomaximize, maximizeprocedure, ;
               minimizeprocedure, minwidth, maxwidth, minheight, maxheight, ;
               MoveProcedure, fontcolor, nodwp, nICL ) CLASS TFormModal

   LOCAL nStyle := 0, nStyleEx := 0
   LOCAL oParent, hParent

   Empty( modalsize )

   oParent := ::SearchParent( Parent )
   IF HB_ISOBJECT( oParent )
      hParent := oParent:hWnd
   ELSE
      hParent := 0   // TODO: Check
      // Must have a parent!!!!!
   ENDIF

   ::oPrevWindow := oParent

   nStyle += WS_POPUP

   ::Define2( FormName, Caption, x, y, w, h, hParent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              TYPE_OTHERS, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              MoveProcedure, fontcolor, nodwp, nICL )

   RETURN Self

METHOD Visible( lVisible ) CLASS TFormModal

   LOCAL hActive

   IF HB_ISLOGICAL( lVisible )
      IF lVisible
         // Find previous window
         hActive := GetActiveWindow()
         IF hActive == ::hWnd
            // It's already set
         ELSEIF AScan( _OOHG_aFormhWnd, hActive ) > 0
            ::oPrevWindow := GetFormObjectByHandle( hActive )
         ELSEIF _OOHG_UserWindow != NIL .AND. AScan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
            ::oPrevWindow := _OOHG_UserWindow
         ELSEIF Len( _OOHG_ActiveModal ) != 0 .AND. AScan( _OOHG_aFormhWnd, ATail( _OOHG_ActiveModal ):hWnd ) > 0
            ::oPrevWindow := ATail( _OOHG_ActiveModal )
         ELSEIF ::Parent != NIL .AND. AScan( _OOHG_aFormhWnd, ::Parent:hWnd ) > 0
            ::oPrevWindow := ::Parent
         ELSEIF _OOHG_Main != NIL .AND. _OOHG_Main:hWnd != ::hWnd
            ::oPrevWindow := _OOHG_Main
         ELSE
            ::oPrevWindow := NIL
         ENDIF

         AEval( _OOHG_aFormObjects, { |o| iif( ! o:lInternal .AND. o:hWnd != ::hWnd .AND. IsWindowEnabled( o:hWnd ), ( AAdd( ::LockedForms, o ), DisableWindow( o:hWnd ) ), ) } )

         IF Len( _OOHG_ActiveModal ) == 0  .OR. ATail( _OOHG_ActiveModal ):hWnd != ::hWnd
           AAdd( _OOHG_ActiveModal, Self )
         ENDIF
         EnableWindow( ::hWnd )
      ENDIF
   ENDIF

   RETURN ( ::Super:Visible := lVisible )

METHOD Activate( lNoStop, oWndLoop ) CLASS TFormModal

   // Checks for non-stop window
   IF !HB_IsLogical( lNoStop )
      lNoStop := .F.
   ENDIF
   IF lNoStop .AND. !HB_IsObject( oWndLoop ) .AND. HB_IsObject( ::oPrevWindow )
      oWndLoop := ::oPrevWindow
   ENDIF

   // Since this window disables all other windows, it must be visible!
   ::lVisible := .T.

   Return ::Super:Activate( lNoStop, oWndLoop )

METHOD Release() CLASS TFormModal

   If ! ::lReleasing
      If ( Len( _OOHG_ActiveModal ) == 0 .OR. ATAIL( _OOHG_ActiveModal ):hWnd <> ::hWnd ) .AND. IsWindowVisible( ::hWnd )
         MsgOOHGError( "Non top modal window *" + ::Name + "* can't be released. Program terminated." )
      EndIf
   EndIf

   Return ::Super:Release()

// ver que pasa si una modal crea otra modal

METHOD OnHideFocusManagement() CLASS TFormModal

   // Re-enables locked forms
   AEval( ::LockedForms, { |o| iif( ValidHandler( o:hWnd ), EnableWindow( o:hWnd ), NIL) } )
   ::LockedForms := {}

   IF ::oPrevWindow # NIL
      ::oPrevWindow:SetFocus()
   ENDIF

   RETURN ::Super:OnHideFocusManagement()


CLASS TFormInternal FROM TForm

   DATA Type           INIT "I" READONLY
   DATA lInternal      INIT .T.
   DATA lAdjust        INIT .F.
   DATA Focused        INIT .F.

   METHOD Define
   METHOD Define2
   METHOD SizePos
   METHOD Row       SETGET
   METHOD Col       SETGET

   METHOD ContainerRow        BLOCK { |Self| IF( ::Container != NIL, IF( ValidHandler( ::Container:ContainerhWndValue ), 0, ::Container:ContainerRow ) + ::Container:RowMargin, ::Parent:RowMargin ) + ::Row }
   METHOD ContainerCol        BLOCK { |Self| IF( ::Container != NIL, IF( ValidHandler( ::Container:ContainerhWndValue ), 0, ::Container:ContainerCol ) + ::Container:ColMargin, ::Parent:ColMargin ) + ::Col }

   ENDCLASS

METHOD Define( FormName, Caption, x, y, w, h, oParent, aRGB, fontname, fontsize, ;
               ClickProcedure, MouseDragProcedure, MouseMoveProcedure, ;
               PaintProcedure, noshow, icon, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, cursor, Focused, lRtl, mdi, clientarea, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
               minheight, maxheight, fontcolor, nodwp, nICL ) CLASS TFormInternal

   LOCAL nStyle := 0, nStyleEx := 0

   ::SearchParent( oParent )
   ::Focused := ( HB_ISLOGICAL( Focused ) .AND. Focused )

   nStyle += WS_GROUP + WS_CHILD
   IF ! HB_ISLOGICAL( mdi ) .OR. ! mdi
      nStyleEx += WS_EX_CONTROLPARENT
   ENDIF

   ::Define2( FormName, Caption, x, y, w, h, ::Parent:hWnd, .F., .T., .T., .T., .T., ;
              .T., virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, NIL, ;
              NIL, NIL, NIL, NIL, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, NIL, NIL, nStyle, nStyleEx, ;
              TYPE_OTHERS, lRtl, mdi, NIL, clientarea, NIL, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              NIL, fontcolor, nodwp, nICL )

   Return Self

METHOD Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
                nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
                icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
                minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
                MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
                nWindowType, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
                DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
                MoveProcedure, fontcolor, nodwp, nICL ) CLASS TFormInternal

   ::Super:Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
                    nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
                    icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
                    minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
                    MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
                    nWindowType, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
                    DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
                    MoveProcedure, fontcolor, nodwp, nICL )

   ::ActivateCount[ 1 ] += 999
   aAdd( ::Parent:SplitChildList, Self )
   ::Parent:AddControl( Self )
   ::Active := .T.
   If ::lVisible
      ShowWindow( ::hWnd )
   EndIf

   ::ContainerhWndValue := ::hWnd

   Return Self

METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TFormInternal

   Local uRet

   if HB_IsNumeric( nCol )
      ::nCol := nCol
   endif
   if HB_IsNumeric( nRow )
      ::nRow := nRow
   endif
   if !HB_IsNumeric( nWidth )
      nWidth := ::nWidth
   else
      ::nWidth := nWidth
   endif
   if !HB_IsNumeric( nHeight )
      nHeight := ::nHeight
   else
      ::nHeight := nHeight
   endif
   uRet := MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, nWidth, nHeight, .t. )
   //CGR
   ::CheckClientsPos()
   ValidateScrolls( Self, .T. )

   Return uRet

METHOD Col( nCol ) CLASS TFormInternal

   IF PCOUNT() > 0
      ::SizePos( NIL, nCol )
   ENDIF

   RETURN ::nCol

METHOD Row( nRow ) CLASS TFormInternal

   IF PCOUNT() > 0
      ::SizePos( nRow )
   ENDIF

   RETURN ::nRow


CLASS TFormSplit FROM TFormInternal

   DATA Type           INIT "X" READONLY

   METHOD Define

   ENDCLASS

METHOD Define( FormName, w, h, break, grippertext, nocaption, title, aRGB, ;
               fontname, fontsize, gotfocus, lostfocus, virtualheight, ;
               VirtualWidth, Focused, scrollleft, scrollright, scrollup, ;
               scrolldown, hscrollbox, vscrollbox, cursor, lRtl, mdi, ;
               clientarea, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, ;
               minwidth, maxwidth, minheight, maxheight, fontcolor, nodwp, nICL ) CLASS TFormSplit

   LOCAL nStyle := 0, nStyleEx := 0

   ::SearchParent()
   ::Focused := ( HB_ISLOGICAL( Focused ) .AND. Focused )

   IF ! ::SetSplitBoxInfo()
      MsgOOHGError( "SplitChild windows can be defined only inside SplitBox. Program terminated." )
   ENDIF

   nStyle += WS_GROUP + WS_CHILD
   nStyleEx += WS_EX_STATICEDGE + WS_EX_TOOLWINDOW
   IF ! HB_ISLOGICAL( mdi ) .OR. ! mdi
      nStyleEx += WS_EX_CONTROLPARENT
   ENDIF

   ::Define2( FormName, Title, 0, 0, w, h, ::Parent:hWnd, .F., .F., .F., .F., .F., ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              NIL, .F., gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, NIL, ;
              NIL, NIL, NIL, NIL, NIL, NIL, ;
              NIL, NIL, NIL, .F., nStyle, nStyleEx, ;
              TYPE_SPLITCHILD, lRtl, mdi, .F., clientarea, NIL, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              NIL, fontcolor, nodwp, nICL )

   IF ::Container:lForceBreak .AND. ! ::Container:lInverted
      Break := .T.
   ENDIF
   ::SetSplitBoxInfo( Break, GripperText )
   ::Container:AddControl( Self )

   RETURN Self


CLASS TFormMDIClient FROM TFormInternal

   DATA Type           INIT "D" READONLY
   DATA nWidth         INIT 0
   DATA nHeight        INIT 0

   METHOD Define
   METHOD DefWindowProc(nMsg,wParam,lParam) BLOCK { |Self,nMsg,wParam,lParam| DefMDIChildProc( ::hWnd, nMsg, wParam, lParam ) }
   METHOD Events_Size
   METHOD Release                           BLOCK { |Self| _OOHG_RemoveMdi( ::hWnd ), ::Super:Release() }
   METHOD Cascade
   METHOD TileHorizontal                    BLOCK { |Self| SendMessage( ::hWnd, WM_MDITILE, 1, 0 ) }
   METHOD TileVertical                      BLOCK { |Self| SendMessage( ::hWnd, WM_MDITILE, 0, 0 ) }
   METHOD IconArrange                       BLOCK { |Self| SendMessage( ::hWnd, WM_MDIICONARRANGE, 0, 0 ) }
   METHOD ActiveChild

   ENDCLASS

METHOD Define( FormName, Caption, x, y, w, h, MouseDragProcedure, ;
               ClickProcedure, MouseMoveProcedure, aRGB, PaintProcedure, ;
               icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, cursor, oParent, Focused, lRtl, ;
               clientarea, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, ;
               minwidth, maxwidth, minheight, maxheight, fontcolor, nodwp, nICL ) CLASS TFormMDIClient

   LOCAL nStyle := 0, nStyleEx := 0, aClientRect

   ::Focused := ( HB_ISLOGICAL( Focused ) .AND. Focused )
   ::SearchParent( oParent )

   nStyle += WS_GROUP + WS_CHILD + WS_CLIPCHILDREN
   nStyleEx += WS_EX_CONTROLPARENT

   aClientRect := { 0, 0, 0, 0 }
   GetClientRect( ::Parent:hWnd, aClientRect )
   IF ! HB_ISNUMERIC( x ) .AND. ::nCol == 0
      x := aClientRect[ 1 ]
   ENDIF
   IF ! HB_ISNUMERIC( y ) .AND. ::nRow == 0
      y := aClientRect[ 2 ]
   ENDIF
   IF ! HB_ISNUMERIC( w ) .AND. ::nWidth == 0
      w := aClientRect[ 3 ] - aClientRect[ 1 ]
   ENDIF
   IF ! HB_ISNUMERIC( h ) .AND. ::nHeight == 0
      h := aClientRect[ 4 ] - aClientRect[ 2 ]
   ENDIF

   ::Define2( FormName, Caption, x, y, w, h, ::Parent:hWnd, .F., .T., .T., .T., .T., ;
              .T., virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, .F., gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, NIL, ;
              NIL, NIL, NIL, NIL, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, NIL, .F., nStyle, nStyleEx, ;
              TYPE_MDICLIENT, lRtl, .F.,, clientarea, NIL, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              NIL, fontcolor, nodwp, nICL )

   ::Parent:hWndClient := ::hWnd
   ::Parent:oWndClient := Self

   _OOHG_AddMdi( ::hWnd, ::Parent:hWnd )

   ::Events_Size()

   RETURN Self

METHOD Events_Size() CLASS TFormMDIClient

   LOCAL aClientRect, nRow, nHeight, I, nTall

   aClientRect := { 0, 0, 0, 0 }
   GetClientRect( ::Parent:hWnd, aClientRect )
   nRow := aClientRect[ 2 ]
   nHeight := aClientRect[ 4 ] - aClientRect[ 2 ]
   FOR I := 1 TO LEN( ::Parent:aControls )
      nTall := ::Parent:aControls[ I ]:ClientHeightUsed
      IF     nTall > 0
         nRow    += nTall
         nHeight -= nTall
      ELSEIF nTall < 0
         nHeight += nTall
      ENDIF
   NEXT
   ::SizePos( nRow, aClientRect[ 1 ], aClientRect[ 3 ] - aClientRect[ 1 ], nHeight )
   ::DoEvent( ::OnSize, "WINDOW_SIZE" )

   RETURN NIL

METHOD Cascade( lSkipDisabled, lUseZOrder ) CLASS TFormMDIClient

   LOCAL nFlags := 0

   ASSIGN lSkipDisabled VALUE lSkipDisabled TYPE "L" DEFAULT .T.
   ASSIGN lUseZOrder    VALUE lUseZOrder    TYPE "L" DEFAULT .T.

   IF lSkipDisabled
      nFlags += 2
   ENDIF
   IF lUseZOrder
      nFlags += 4
   ENDIF

   RETURN SendMessage( ::hWnd, WM_MDICASCADE, nFlags, 0 )

METHOD ActiveChild() CLASS TFormMDIClient

   LOCAL nHandle, oWin

   nHandle := SendMessage( ::hWnd, WM_MDIGETACTIVE, 0, 0 )
   IF ValidHandler( nHandle )
      oWin := GetFormObjectByHandle( nHandle )
   ENDIF

   RETURN oWin


CLASS TFormMDIChild FROM TFormInternal

   DATA Type           INIT "L" READONLY

   METHOD Define
   METHOD DefWindowProc(nMsg,wParam,lParam) BLOCK { |Self,nMsg,wParam,lParam| DefMDIChildProc( ::hWnd, nMsg, wParam, lParam ) }
   METHOD IsActive                          BLOCK { |Self| ::Parent:ActiveChild:hWnd == ::hWnd }

   ENDCLASS

METHOD Define( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, ;
               nosysmenu, nocaption, initprocedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, noshow, ;
               icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, helpbutton, maximizeprocedure, ;
               minimizeprocedure, cursor, NoAutoRelease, oParent, ;
               InteractiveCloseProcedure, Focused, lRtl, clientarea, ;
               restoreprocedure, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, ;
               minwidth, maxwidth, minheight, maxheight, MoveProcedure, ;
               fontcolor, nodwp, nICL ) CLASS TFormMDIChild

   LOCAL nStyle := 0, nStyleEx := 0

   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   ::SearchParent( oParent )

   nStyle += WS_GROUP + WS_CHILD
   nStyleEx += WS_EX_MDICHILD + WS_EX_CONTROLPARENT

   // If MDIclient window doesn't exists, create it.
   IF ::Parent:oWndClient == NIL
      oParent := TFormMDIClient():Define( ,,,,,,,,,,,,,,,,,,,,,,,,, ::Parent )
      oParent:EndWindow()
   ELSE
      oParent := ::Parent:oWndClient
   ENDIF
   ::SearchParent( oParent )

   ::Define2( FormName, Caption, x, y, w, h, ::Parent:hWnd, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              TYPE_MDICHILD, lRtl,,, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              MoveProcedure, fontcolor, nodwp, nICL )

   ::ProcessInitProcedure()

   RETURN Self


FUNCTION DefineWindow( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, ;
                       nosysmenu, nocaption, initprocedure, ReleaseProcedure, ;
                       MouseDragProcedure, SizeProcedure, ClickProcedure, ;
                       MouseMoveProcedure, aRGB, PaintProcedure, noshow, topmost, ;
                       icon, fontname, fontsize, NotifyIconName, NotifyIconTooltip, ;
                       NotifyIconLeftClick, GotFocus, LostFocus, Virtualheight, ;
                       VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
                       hscrollbox, vscrollbox, helpbutton, maximizeprocedure, ;
                       minimizeprocedure, cursor, NoAutoRelease, oParent, ;
                       InteractiveCloseProcedure, Focused, Break, GripperText, lRtl, ;
                       main, splitchild, child, modal, modalsize, mdi, internal, ;
                       mdichild, mdiclient, subclass, clientarea, restoreprocedure, ;
                       RClickProcedure, MClickProcedure, DblClickProcedure, ;
                       RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
                       minheight, maxheight, MoveProcedure, cBackImage, lStretchBack, ;
                       fontcolor, nodwp, nICL )

   Local Self
   Local aError := {}

   ///////////////////// Check for non-"implemented" parameters at Tform's subclasses....

   If !HB_IsLogical( main )
      main := .F.
   ElseIf main
      AADD( aError, "MAIN" )
   EndIf
   If !HB_IsLogical( splitchild )
      splitchild := .F.
   ElseIf splitchild
      AADD( aError, "SPLITCHILD" )
   EndIf
   If !HB_IsLogical( child )
      child := .F.
   ElseIf child
      AADD( aError, "CHILD" )
   EndIf
   If !HB_IsLogical( modal )
      modal := .F.
   ElseIf modal
      AADD( aError, "MODAL" )
   EndIf
   If !HB_IsLogical( modalsize )
      modalsize := .F.
   ElseIf modalsize
      AADD( aError, "MODALSIZE" )
   EndIf
   If !HB_IsLogical( mdiclient )
      mdiclient := .F.
   ElseIf mdiclient
      AADD( aError, "MDICLIENT" )
   EndIf
   If !HB_IsLogical( mdichild )
      mdichild := .F.
   ElseIf mdichild
      AADD( aError, "MDICHILD" )
   EndIf
   If !HB_IsLogical( internal )
      internal := .F.
   ElseIf internal
      AADD( aError, "INTERNAL" )
   EndIf

   if Len( aError ) > 1
      MsgOOHGError( "Window: " + aError[ 1 ] + " and " + aError[ 2 ] + " clauses can't be used simultaneously. Program terminated." )
   endif

   If main
      Self := _OOHG_SelectSubClass( TFormMain(), subclass )
      IF HB_ISNUMERIC( nICL ) .AND. nICL == 3
         nICL := 4   // QUERY MAIN
      ENDIF
      ::Define( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, ;
               nosysmenu, nocaption, initprocedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, noshow, topmost, ;
               icon, fontname, fontsize, NotifyIconName, NotifyIconTooltip, ;
               NotifyIconLeftClick, GotFocus, LostFocus, virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, helpbutton, maximizeprocedure, ;
               minimizeprocedure, cursor, InteractiveCloseProcedure, lRtl, mdi, ;
               clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, ;
               minwidth, maxwidth, minheight, maxheight, MoveProcedure, ;
               fontcolor, nodwp, nICL )
   ElseIf splitchild
      Self := _OOHG_SelectSubClass( TFormSplit(), subclass )
      ::Define( FormName, w, h, break, grippertext, nocaption, caption, aRGB, ;
               fontname, fontsize, gotfocus, lostfocus, virtualheight, ;
               VirtualWidth, Focused, scrollleft, scrollright, scrollup, ;
               scrolldown, hscrollbox, vscrollbox, cursor, lRtl, mdi, clientarea, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
               minheight, maxheight, fontcolor, nodwp, nICL )
   ElseIf modal .OR. modalsize
      Self := _OOHG_SelectSubClass( TFormModal(), subclass )
      ::Define( FormName, Caption, x, y, w, h, oParent, nosize, nosysmenu, ;
               nocaption, InitProcedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, icon, FontName, ;
               FontSize, GotFocus, LostFocus, virtualheight, VirtualWidth, ;
               scrollleft, scrollright, scrollup, scrolldown, hscrollbox, ;
               vscrollbox, helpbutton, cursor, noshow, NoAutoRelease, ;
               InteractiveCloseProcedure, lRtl, .F., mdi, topmost, clientarea, ;
               restoreprocedure, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, ;
               nominimize, nomaximize, maximizeprocedure, minimizeprocedure, ;
               minwidth, maxwidth, minheight, maxheight, MoveProcedure, ;
               fontcolor, nodwp, nICL )
   ElseIf mdiclient
      Self := _OOHG_SelectSubClass( TFormMDIClient(), subclass )
      ::Define( FormName, Caption, x, y, w, h, MouseDragProcedure, ;
               ClickProcedure, MouseMoveProcedure, aRGB, PaintProcedure, ;
               icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, cursor, oParent, Focused, lRtl, clientarea, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
               minheight, maxheight, fontcolor, nodwp, nICL )
   ElseIf mdichild
      Self := _OOHG_SelectSubClass( TFormMDIChild(), subclass )
      ::Define( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, ;
               nosysmenu, nocaption, initprocedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, noshow, ;
               icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, helpbutton, maximizeprocedure, ;
               minimizeprocedure, cursor, NoAutoRelease, oParent, ;
               InteractiveCloseProcedure, Focused, lRtl, clientarea, restoreprocedure, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, ;
               maxheight, MoveProcedure, fontcolor, nodwp, nICL )
   ElseIf internal
      Self := _OOHG_SelectSubClass( TFormInternal(), subclass )
      ::Define( FormName, Caption, x, y, w, h, oParent, aRGB, fontname, fontsize, ;
               ClickProcedure, MouseDragProcedure, MouseMoveProcedure, ;
               PaintProcedure, noshow, icon, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, cursor, Focused, lRtl, mdi, clientarea, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, ;
               maxheight, fontcolor, nodwp, nICL )
   Else // Child and "S"
      Self := _OOHG_SelectSubClass( TForm(), subclass )
      ::Define( FormName, Caption, x, y, w, h, nominimize, nomaximize, nosize, ;
               nosysmenu, nocaption, initprocedure, ReleaseProcedure, ;
               MouseDragProcedure, SizeProcedure, ClickProcedure, ;
               MouseMoveProcedure, aRGB, PaintProcedure, noshow, topmost, ;
               icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, helpbutton, maximizeprocedure, ;
               minimizeprocedure, cursor, NoAutoRelease, oParent, ;
               InteractiveCloseProcedure, lRtl, child, mdi, clientarea, ;
               restoreprocedure, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, ;
               maxwidth, minheight, maxheight, MoveProcedure, fontcolor, nodwp, nICL )
   EndIf

   ::NotifyIconObject:Picture := NotifyIconName
   ::NotifyIconObject:ToolTip := NotifyIconToolTip
   ::NotifyIconObject:OnClick := NotifyIconLeftClick

   ::lStretchBack := lStretchBack
   ::BackImage := cBackImage

   Return Self

Function _EndWindow()

   If Len( _OOHG_ActiveForm ) > 0
      ATAIL( _OOHG_ActiveForm ):EndWindow()
   EndIf

   Return Nil

Function _OOHG_FormObjects()

   Return aClone( _OOHG_aFormObjects )

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _OOHG_Init_C_Vars()

/*
 * This procedure initializes C static variables that point to the arrays.
 * These pointers facilitate the access from C-level functions to
 * objects defined at PRG-level.
 *
 * DO NOT CALL this procedure directly !!!!
 *
 * It's called, automatically, the first time function
 * _OOHG_SearchFormHandleInArray() is executed.
 *
 * Function _OOHG_SearchFormHandleInArray() is called from
 * GetFormObjectByHandle() and _OOHG_GetExistingObject().
 *
 * Note that GetControlObjectByHandle() and _OOHG_GetExistingObject()
 * are mutex-protected but _OOHG_SearchFormHandleInArray() is not.
 */

   TForm()
   _OOHG_Init_C_Vars_C_Side( _OOHG_aFormhWnd, _OOHG_aFormObjects )

   RETURN

PROCEDURE _KillAllKeys()

   LOCAL i, hWnd

   FOR i := 1 TO Len( _OOHG_aFormhWnd )
      hWnd := _OOHG_aFormObjects[ i ]:hWnd
      AEval( _OOHG_aFormObjects[ i ]:aHotKeys, { |a| ReleaseHotKey( hWnd, a[ HOTKEY_ID ] ) } )
      AEval( _OOHG_aFormObjects[ i ]:aAcceleratorKeys, { |a| ReleaseHotKey( hWnd, a[ HOTKEY_ID ] ) } )
   NEXT

   RETURN

Function GetFormObject( FormName )

   Local mVar

   mVar := '_' + FormName

   Return IF( Type( mVar ) == "O", &mVar, TForm() )

Function GetExistingFormObject( FormName )

   Local mVar

   mVar := '_' + FormName
   If ! Type( mVar ) == "O"
      MsgOOHGError( "Window " + FormName + " not defined. Program terminated." )
   EndIf

   Return &mVar

Function _IsWindowActive( FormName )

   Return GetFormObject( FormName ):Active

Function _IsWindowDefined( FormName )

   Local mVar

   mVar := '_' + FormName

   Return ( Type( mVar ) == "O" )

FUNCTION _ActivateWindow( aForm, lNoWait, lDebugger )

   LOCAL z, aForm2, oWndActive, oWnd, lModal

   aForm2 := AClone( aForm )

   // Validates NOWAIT flag
   IF ! HB_ISLOGICAL( lNoWait )
      lNoWait := .F.
   ENDIF
   // Validates DEBUGGER flag
   IF ! HB_ISLOGICAL( lDebugger )
      lDebugger := .F.
   ENDIF
   oWndActive := iif( lNoWait .AND. HB_ISOBJECT( _OOHG_Main ) .AND. ! lDebugger, _OOHG_Main, GetFormObject( aForm2[ 1 ] ) )

   // Look for MAIN window and put it in the first place
   IF _OOHG_Main != NIL
      z := AScan( aForm2, { |c| GetFormObject( c ):hWnd == _OOHG_Main:hWnd } )
      IF z != 0
         AAdd( aForm2, NIL )
         AIns( aForm2, 1 )
         aForm2[ 1 ] := aForm2[ z + 1 ]
         _OOHG_DeleteArrayItem( aForm2, z + 1 )
         IF lNoWait
            oWndActive := GetFormObject( aForm2[ 1 ] )
         ENDIF
      ENDIF
   ENDIF

   // Activate windows
   lModal := .F.
   FOR z := 1 TO Len( aForm2 )
      oWnd := GetFormObject( aForm2[ z ] )
      IF ! ValidHandler( oWnd:hWnd )
         MsgOOHGError( "ACTIVATE WINDOW: Window " + aForm2[ z ] + " not defined. Program terminated." )
      ENDIF
      IF oWnd:Type == "M" .AND. oWnd:lVisible
         IF lModal
            MsgOOHGError( "ACTIVATE WINDOW: Only one initially visible modal window allowed. Program terminated." )
         ENDIF
         lModal := .T.
      ENDIF
      oWnd:Activate( .T., oWndActive )
   NEXT

   IF ! lNoWait
      GetFormObject( aForm2[ 1 ] ):MessageLoop()
   ENDIF

   RETURN NIL

FUNCTION _ActivateAllWindows()

   Local i, aForm := {}, oWnd, MainName := '', MainhWnd

   // Abort if a window is already active
   If ascan( _OOHG_aFormObjects, { |o| o:Active .AND. ! o:lInternal } ) > 0
      MsgOOHGError( "ACTIVATE WINDOW ALL: This command should be used at application startup only. Program terminated." )
   EndIf

   // Identify Main and force AutoRelease and Visible properties
   MainhWnd := _OOHG_Main:hWnd
   For i := 1 To LEN( _OOHG_aFormObjects )
      oWnd := _OOHG_aFormObjects[ i ]
      If oWnd:hWnd == MainhWnd
         oWnd:lVisible := .T.
         oWnd:AutoRelease := .T.
         MainName := oWnd:Name
      ElseIf ! oWnd:lInternal
         aadd( aForm, oWnd:Name )
      EndIf
   Next i

   If Empty( MainName )
      MsgOOHGError( "ACTIVATE WINDOW ALL: Main window is not defined. Program terminated." )
   EndIf

   aadd( aForm, MainName )

   _ActivateWindow( aForm )

   RETURN NIL

FUNCTION ReleaseAllWindows( lExit )

   _ReleaseWindowList( _OOHG_aFormObjects )
   IF _OOHG_ExitOnMainRelease .OR. ( HB_ISLOGICAL( lExit ) .AND. lExit )
      ExitProcess( _OOHG_ErrorLevel )
      // Processing will never reach this point
   ENDIF
   _OOHG_Main := NIL

   RETURN NIL

FUNCTION _ReleaseWindowList( aWindows )

   LOCAL i, oWnd

   IF _OOHG_WinReleaseSameOrder
      FOR i := 1 TO Len( aWindows )
         oWnd := aWindows[ i ]

         IF ! oWnd:lReleased
            oWnd:lReleasing := .T.

            IF oWnd:Active
               oWnd:DoEvent( oWnd:OnRelease, "WINDOW_RELEASE" )
            ENDIF

            // Disable form's doevent
            oWnd:lDisableDoEvent := .T.

            // Prepare all controls to be destroyed
            oWnd:PreRelease()

            // Release child windows
            _ReleaseWindowList( oWnd:aChildPopUp )
            oWnd:aChildPopUp := {}

            // Reassign focus
            oWnd:OnHideFocusManagement()

            // Destroy form
            DestroyWindow( oWnd:hWnd )
         ENDIF
      NEXT i
   ELSE
      // Reverse order: release first the latest defined forms
      FOR i := Len( aWindows ) TO 1 STEP -1
         oWnd := aWindows[ i ]

         IF ! oWnd:lReleased
            oWnd:lReleasing := .T.

            // Release child windows
            _ReleaseWindowList( oWnd:aChildPopUp )
            oWnd:aChildPopUp := {}

            IF oWnd:Active
               oWnd:DoEvent( oWnd:OnRelease, "WINDOW_RELEASE" )
            ENDIF

            // Disable form's doevent
            oWnd:lDisableDoEvent := .T.

            // Prepare all controls to be destroyed
            oWnd:PreRelease()

            // Reassign focus
            oWnd:OnHideFocusManagement()

            // Destroy form
            DestroyWindow( oWnd:hWnd )
         ENDIF
      NEXT i
   ENDIF

   RETURN NIL

Function SearchParentWindow( lInternal )

   LOCAL uParent, nPos

   uParent := nil

   If lInternal
      If LEN( _OOHG_ActiveForm ) > 0
         uParent := ATAIL( _OOHG_ActiveForm )
      ELSEIF _OOHG_ActiveFrame # NIL
         uParent := _OOHG_ActiveFrame
      EndIf

   Else

      // Checks _OOHG_UserWindow
      If _OOHG_UserWindow != NIL .AND. ValidHandler( _OOHG_UserWindow:hWnd ) .AND. ascan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
         uParent := _OOHG_UserWindow
      Else
         // Checks _OOHG_ActiveModal
         nPos := RASCAN( _OOHG_ActiveModal, { |o| ValidHandler( o:hWnd ) .AND. ascan( _OOHG_aFormhWnd, o:hWnd ) > 0 } )
         If nPos > 0
            uParent := _OOHG_ActiveModal[ nPos ]
         Else
            // Checks any active window
            nPos := RASCAN( _OOHG_aFormObjects, { |o| o:Active .AND. ValidHandler( o:hWnd ) .AND. ! o:lInternal } )
            If nPos > 0
               uParent := _OOHG_aFormObjects[ nPos ]
            Else
               // Checks _OOHG_ActiveForm
               nPos := RASCAN( _OOHG_ActiveForm, { |o| ValidHandler( o:hWnd ) .AND. ! o:lInternal .AND. ascan( _OOHG_aFormhWnd, o:hWnd ) > 0 } )
               If nPos > 0
                  uParent := _OOHG_ActiveForm[ nPos ]
               Else
                  uParent := GetFormObjectByHandle( GetActiveWindow() )
                  If ! ValidHandler( uParent:hWnd ) .OR. ! uParent:Active
                     If _OOHG_Main != nil
                        uParent := _OOHG_Main
                     Else
                        // Not mandatory MAIN
                        // NO PARENT DETECTED!
                        uParent := nil
                     EndIf
                  EndIf
               EndIf
            Endif
         Endif
      EndIf

   EndIf

   Return uParent

#ifndef __XHARBOUR__
STATIC FUNCTION RASCAN( aSource, bCode )

   LOCAL nPos

   nPos := LEN( aSource )
   DO WHILE nPos > 0 .AND. ! EVAL( bCode, aSource[ nPos ], nPos )
      nPos--
   ENDDO

   RETURN nPos
#endif

Function GetWindowType( FormName )

   Return GetFormObject( FormName ):Type

Function GetFormName( FormName )

   Return GetFormObject( FormName ):Name

Function GetFormToolTipHandle( FormName )

   Return GetFormObject( FormName ):oToolTip:hWnd

Function GetFormHandle( FormName )

   Return GetFormObject( FormName ):hWnd

Function _ReleaseWindow( FormName )

   Return GetFormObject( FormName ):Release()

Function _ShowWindow( FormName )

   Return GetFormObject( FormName ):Show()

Function _HideWindow( FormName )

   Return GetFormObject( FormName ):Hide()

Function _CenterWindow ( FormName )

   Return GetFormObject( FormName ):Center()

Function _RestoreWindow ( FormName )

   Return GetFormObject( FormName ):Restore()

Function _MaximizeWindow ( FormName )

   Return GetFormObject( FormName ):Maximize()

Function _MinimizeWindow ( FormName )

   Return GetFormObject( FormName ):Minimize()

Function _SetWindowSizePos( FormName, row, col, width, height )

   Return GetFormObject( FormName ):SizePos( row, col, width, height )


#pragma BEGINDUMP

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

// Thread safe, see _OOHG_INIT_C_VARS_C_SIDE, GetFormObjectByHandle() and _OOHG_GetExistingObject()
static PHB_SYMB _ooHG_Symbol_TForm = 0;
static PHB_ITEM _OOHG_aFormhWnd, _OOHG_aFormObjects;        

HB_FUNC( _OOHG_INIT_C_VARS_C_SIDE )
{
   // See _OOHG_Init_C_Vars() at h_form.prg
   _ooHG_Symbol_TForm = hb_dynsymSymbol( hb_dynsymFind( "TFORM" ) );
   _OOHG_aFormhWnd    = hb_itemNew( NULL );
   _OOHG_aFormObjects = hb_itemNew( NULL );
   hb_itemCopy( _OOHG_aFormhWnd,    hb_param( 1, HB_IT_ARRAY ) );
   hb_itemCopy( _OOHG_aFormObjects, hb_param( 2, HB_IT_ARRAY ) );
}

int _OOHG_SearchFormHandleInArray( HWND hWnd )
{
/*
 * This function must be called enclosed between
 * WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
 * and ReleaseMutex( _OOHG_GlobalMutex() ); calls.
 * See GetFormObjectByHandle() and _OOHG_GetExistingObject().
 */
   ULONG ulCount, ulPos = 0;

   if( ! _ooHG_Symbol_TForm )
   {
      hb_vmPushSymbol( hb_dynsymSymbol( hb_dynsymFind( "_OOHG_INIT_C_VARS" ) ) );
      hb_vmPushNil();
      hb_vmDo( 0 );
   }

   for( ulCount = 1; ulCount <= hb_arrayLen( _OOHG_aFormhWnd ); ulCount++ )
   {
      #ifdef OOHG_HWND_POINTER
         if( hWnd == ( HWND ) hb_arrayGetPtr( _OOHG_aFormhWnd, ulCount ) )
      #else
         if( (LONG_PTR) hWnd == HB_ARRAYGETNL( _OOHG_aFormhWnd, ulCount ) )
      #endif
      {
         ulPos = ulCount;
         ulCount = hb_arrayLen( _OOHG_aFormhWnd );
      }
   }

   return ulPos;
}

PHB_ITEM GetFormObjectByHandle( HWND hWnd, BOOL bMutex )
{
   PHB_ITEM pForm;
   ULONG ulPos;

   if( bMutex )
      WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   ulPos = _OOHG_SearchFormHandleInArray( hWnd );
   if( ulPos )
   {
      pForm = hb_arrayGetItemPtr( _OOHG_aFormObjects, ulPos );
   }
   else
   {
      hb_vmPushSymbol( _ooHG_Symbol_TForm );
      hb_vmPushNil();
      hb_vmDo( 0 );
      pForm = hb_param( -1, HB_IT_ANY );
   }

   if( bMutex )
      ReleaseMutex( _OOHG_GlobalMutex() );

   return pForm;
}

HB_FUNC( GETFORMOBJECTBYHANDLE )
{
   PHB_ITEM pReturn;

   pReturn = hb_itemNew( NULL );
   hb_itemCopy( pReturn, GetFormObjectByHandle( HWNDparam( 1 ), TRUE ) );

   hb_itemReturn( pReturn );
   hb_itemRelease( pReturn );
}

LRESULT APIENTRY _OOHG_WndProc( PHB_ITEM pSelf, HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc )
{
   PHB_ITEM pResult;
   LRESULT iReturn;
   static int iCall = 0;
   static int iNest = 0;
   int iCallLevel, iNestLevel;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   iNest++;
   iNestLevel = iNest;
   iCall++;
   iCallLevel = iCall;
   ReleaseMutex( _OOHG_GlobalMutex() );

   _OOHG_Send( pSelf, s_OverWndProc );
   hb_vmSend( 0 );
   pResult = hb_param( -1, HB_IT_BLOCK );
   // ::OverWndProc is a codeblock... execute it
   if( pResult )
   {
#ifdef __XHARBOUR__
      hb_vmPushSymbol( &hb_symEval );
#else
      hb_vmPushEvalSym();
#endif
      hb_vmPush( pResult );
      HWNDpush( hWnd );
      hb_vmPushLong( uiMsg );
      hb_vmPushNumInt( wParam );
      hb_vmPushNumInt( lParam );
      hb_vmPush( pSelf );
      hb_vmPushLong( iNestLevel );
      hb_vmPushLong( iCallLevel );
      hb_vmDo( 7 );
      pResult = hb_param( -1, HB_IT_NUMERIC );
   }

   // ::OverWndProc is NOT a codeblock, or it returns a non-numeric value... execute ::Events()
   if( ! pResult )
   {
      _OOHG_Send( pSelf, s_Events );
      HWNDpush( hWnd );
      hb_vmPushLong( uiMsg );
      hb_vmPushNumInt( wParam );
      hb_vmPushNumInt( lParam );
      hb_vmSend( 4 );
      pResult = hb_param( -1, HB_IT_NUMERIC );
   }

   if( pResult )
   {
      // Return value is numeric... return it to Windows
      iReturn = hb_itemGetNL( pResult );
   }
   else
   {
      // Return value is NOT numeric... execute default WindowProc
      iReturn = CallWindowProc( lpfnOldWndProc, hWnd, uiMsg, wParam, lParam );
   }

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   iNest--;
   ReleaseMutex( _OOHG_GlobalMutex() );
   return iReturn;
}

LRESULT APIENTRY _OOHG_WndProcCtrl( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc )
{
   PHB_ITEM pSave, pSelf;
   LRESULT iReturn;

   pSave = hb_itemNew( NULL );
   pSelf = hb_itemNew( NULL );
   hb_itemCopy( pSave, hb_param( -1, HB_IT_ANY ) );
   hb_itemCopy( pSelf, GetControlObjectByHandle( hWnd, TRUE ) );

   iReturn = _OOHG_WndProc( pSelf, hWnd, uiMsg, wParam, lParam, lpfnOldWndProc );

   hb_itemReturn( pSave );
   hb_itemRelease( pSave );
   hb_itemRelease( pSelf );

   return iReturn;
}

LRESULT APIENTRY _OOHG_WndProcForm( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc )
{
   PHB_ITEM pSave, pSelf;
   LRESULT iReturn;

   pSave = hb_itemNew( NULL );
   pSelf = hb_itemNew( NULL );
   hb_itemCopy( pSave, hb_param( -1, HB_IT_ANY ) );
   hb_itemCopy( pSelf, GetFormObjectByHandle( hWnd, TRUE ) );  

   iReturn = _OOHG_WndProc( pSelf, hWnd, uiMsg, wParam, lParam, lpfnOldWndProc );

   hb_itemReturn( pSave );
   hb_itemRelease( pSave );
   hb_itemRelease( pSelf );

   return iReturn;
}

LRESULT CALLBACK WndProc( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcForm( hWnd, message, wParam, lParam, DefWindowProc );
}

LRESULT CALLBACK WndProcMdiChild( HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcForm( hWnd, message, wParam, lParam, DefMDIChildProc );
}

LRESULT CALLBACK _OOHG_DefFrameProc( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam )
{
   _OOHG_Send( GetFormObjectByHandle( hWnd, TRUE ), s_hWndClient );
   hb_vmSend( 0 );
   return DefFrameProc( hWnd, HWNDparam( -1 ), uiMsg, wParam, lParam );
}

LRESULT CALLBACK WndProcMdi( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcForm( hWnd, uiMsg, wParam, lParam, _OOHG_DefFrameProc );
}

LRESULT CALLBACK WndProcMdiClient( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, uiMsg, wParam, lParam, _OOHG_DefFrameProc );
}

HB_FUNC( REGISTERWINDOW )
{
   WNDCLASS WndClass;
   HBRUSH hbrush = NULL;
   int iWindowType = hb_parni( 4 );
   LONG lColor;
   BOOL bError = FALSE;
   HICON hicon = NULL;

   WndClass.style         = CS_DBLCLKS;
   WndClass.lpszClassName = hb_parc( 2 );

   switch( iWindowType )
   {
      case 2:                           // MDI client
         WndClass.lpfnWndProc = WndProcMdiChild;
         break;

      case 3:                           // MDI child
         WndClass.lpfnWndProc = WndProcMdiChild;
         break;

      case 4:                           // MDI frame
         WndClass.lpfnWndProc = WndProcMdi;
         break;

      default:
      // case 0:                           //
      // case 1:                           // Splitchild
         WndClass.lpfnWndProc = WndProc;
         break;
   }
   WndClass.cbClsExtra = 0;
   WndClass.cbWndExtra = 0;
   WndClass.hInstance  = GetModuleHandle( NULL );
   WndClass.hIcon      = 0;
   if( hb_parclen( 1 ) )
   {
      WndClass.hIcon = LoadIcon( GetModuleHandle( NULL ), hb_parc( 1 ) );
      if( ! WndClass.hIcon )
      {
         hicon = ( HICON ) LoadImage( GetModuleHandle( NULL ), hb_parc( 1 ), IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE );
         WndClass.hIcon = hicon;
      }
   }
   if( ! WndClass.hIcon )
   {
      WndClass.hIcon = LoadIcon( NULL, IDI_APPLICATION );
   }
   WndClass.hCursor = LoadCursor( NULL, IDC_ARROW );

   lColor = -1;
   _OOHG_DetermineColor( hb_param( 3, HB_IT_ANY ), &lColor );
   if( lColor == -1 )
   {
      WndClass.hbrBackground = (HBRUSH)( COLOR_BTNFACE + 1 );
   }
   else
   {
      hbrush = CreateSolidBrush( lColor );
      WndClass.hbrBackground = hbrush;
   }

   WndClass.lpszMenuName = NULL;
   if( ! RegisterClass( &WndClass ) )
   {
      bError = TRUE;
   }

   hb_reta( 3 );
   HB_STORNL3( (LONG_PTR) hbrush, -1, 1 );
   HB_STORL( (int) bError, -1, 2 );
   HB_STORNL3( (LONG_PTR) hicon, -1, 3 );
}

HB_FUNC( UNREGISTERWINDOW )
{
   hb_retl( UnregisterClass( hb_parc( 1 ), GetModuleHandle( NULL ) ) );
}

HB_FUNC( INITDUMMY )
{
   HWNDret( CreateWindowEx( 0, "static", "", WS_CHILD, 0, 0, 0, 0, HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL ) );
}

HB_FUNC( INITWINDOW )
{
   HWND hwnd;
   INT Style, StyleEx;

   Style   = hb_parni( 8 );
   StyleEx = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 10 ) );

   hwnd = CreateWindowEx( StyleEx, hb_parc( 7 ), hb_parc( 1 ), Style,
                          hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                          HWNDparam( 6 ), NULL, GetModuleHandle( NULL ), NULL );
   HWNDret( hwnd );
}

HB_FUNC( INITWINDOWMDICLIENT )
{
   HWND hwnd;
   INT Style, StyleEx;
   CLIENTCREATESTRUCT ccs;

   Style   = hb_parni( 8 );
   StyleEx = hb_parni( 9 ) | _OOHG_RTL_Status( hb_parl( 10 ) );

   ccs.hWindowMenu = NULL;
   ccs.idFirstChild = 0;

   hwnd = CreateWindowEx( StyleEx, "MDICLIENT", hb_parc( 1 ), Style,
                          hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                          HWNDparam( 6 ), NULL, GetModuleHandle( NULL ), ( LPSTR ) &ccs );

   HWNDret( hwnd );
}

HB_FUNC( GETSYSTEMMENU )
{
   HMENUret( GetSystemMenu( HWNDparam( 1 ), FALSE ) );
}

#pragma ENDDUMP


FUNCTION Inspector( oWind )

   LOCAL oWnd, oGrd, oCombo, n
   LOCAL aControls, aControlsNames, aData := {}, s, ooObj_Data

   aControls := oWind:aControls
   aControlsNames := oWind:aControlsNames

   DEFINE WINDOW 0 OBJ oWnd ;
      AT 0,0 ;
      WIDTH 400 ;
      HEIGHT 300 ;
      TITLE 'Object Inspector' ;
      MODAL ;
      NOSIZE ;
      NOMAXIMIZE ;
      NOMINIMIZE

      @ 24,0 GRID 0 OBJ oGrd ;
         HEIGHT 240 ;
         WIDTH 394 ;
         HEADERS { "Data", "Values" } ;
         WIDTHS { 150, 180 } ;
         ON DBLCLICK { || ChangeObjValue( aControls[ oCombo:value ], ;
                                          aControlsNames[ oCombo:value ], ;
                                          ooObj_Data[ This.CellRowIndex ] ), ;
                          LoadObjData( aControls[ oCombo:value ], oGrd, @ooObj_Data ) }

#ifdef __XHARBOUR__
   #define ENUMINDEX hb_enumindex()
#else
   #define ENUMINDEX n:__enumindex
#endif

      FOR EACH n IN aControlsNames
         s := AllTrim( n )
         s := Left( s, Len( s ) - 1 )
         AAdd( aData, aControls[ ENUMINDEX ]:Type + ' >> ' + s )
         aControlsNames[ ENUMINDEX ] := s
      NEXT

      @ 0,0 COMBOBOX 0 OBJ oCombo;
         ITEMS aData ;
         VALUE 1 ;
         WIDTH 394 ;
         ON CHANGE LoadObjData( aControls[ oCombo:value ], oGrd, @ooObj_Data )

      LoadObjData( aControls[ 1 ], oGrd, @ooObj_Data )

   END WINDOW

   oWnd:Activate()

   RETURN NIL

STATIC FUNCTION LoadObjData( ooObj, oGrd, ooObj_Data )

   LOCAL aData:= {}, n

   oGrd:DeleteAllItems()

#ifdef __XHARBOUR__
   TRY
      aData := __objGetValueList( ooObj, .T. )
      IF Len( aData ) > 1
         FOR n := 1 to Len( aData )
            oGrd:AddItem( { aData[ n, 1 ], ValueToStr( aData[ n, 2 ] ) } )
         NEXT
      ENDIF
   CATCH
   END
#else
   BEGIN SEQUENCE
      aData := __objGetValueList( ooObj, .T. )
      IF Len( aData ) > 1
         FOR n := 1 TO Len( aData )
            oGrd:AddItem( { aData[ n, 1 ], ValueToStr( aData[ n, 2 ] ) } )
         NEXT
      END IF
   END SEQUENCE
#endif

   oGrd:ColumnsBetterAutoFit()

   ooObj_Data := aData

   RETURN NIL

STATIC FUNCTION ValueToStr( uValue )

   LOCAL cType, cRet

   cType := ValType( uValue )

   DO CASE
   CASE cType $'CSM' ; cRet := 'String "' + uValue + '"'
   CASE cType = 'N'  ; cRet := 'Numeric ' + Str( uValue )
   CASE cType = 'A'  ; cRet := 'Array, len ' + AllTrim( Str( Len( uValue ) ) )
   CASE cType = 'L'  ; cRet := 'Boolean : ' + iif( uValue, 'True', 'False' )
   CASE cType = 'B'  ; cRet := 'Codeblock {|| ... }'
   CASE cType = 'D'  ; cRet := 'Date ' + DToC( uValue )
   CASE cType = 'T'  ; cRet := 'DateTime ' + TToC( uValue )
   CASE cType = 'O'  ; cRet := 'Object, class ' + uValue:ClassName()
   OTHERWISE         ; cRet := 'Unknow type ...'
   END CASE

   RETURN cRet

STATIC FUNCTION ChangeObjValue( ooObj, cName, aValues )

   LOCAL oWnd, cType, lOk := .F., oGet

   cType := ValType( aValues[ 2 ] )
   IF cType $ "CNDL"
      DEFINE WINDOW 0 OBJ oWnd ;
         AT 50,50 ;
         WIDTH 400 ;
         HEIGHT 150 ;
         TITLE "Change value : " + cName + ' => ' + aValues[ 1 ] ;
         MODAL ;
         NOSIZE ;
         NOMAXIMIZE ;
         NOMINIMIZE

         @ 10,10 LABEL 0 ;
            VALUE "New value for " + cName + ' => ' + aValues[ 1 ] ;
            AUTOSIZE

         IF cType == 'C'
            @ 40,20 TEXTBOX 0 OBJ oGet VALUE aValues[ 2 ]
         ELSEIF cType == 'N'
            @ 40,20 TEXTBOX 0 OBJ oGet VALUE aValues[ 2 ] NUMERIC
         ELSEIF cType == 'D'
            @ 40,20 TEXTBOX 0 OBJ oGet VALUE aValues[ 2 ] DATE
         ELSEIF cType == 'L'
            @ 40,20 CHECKBOX 0 OBJ oGet VALUE aValues[ 2 ] CAPTION "Check for .T." AUTOSIZE
         ENDIF

         @ 70,10 BUTTON 0 CAPTION "Set value" ACTION ( aValues[ 2 ] := oGet:value, lOk := .T., oWnd:Release() )
         @ 70,150 BUTTON 0 CAPTION "Cancel" CANCEL ACTION oWnd:Release()
      END WINDOW

      oWnd:Activate()

      IF lOk
         __objSetValueList( ooObj, { aValues } )
         ooObj:Refresh()
      END
   ELSE
      MsgInfo( 'This value is not editable!' )
   ENDIF
   MsgInfo( cName + ' ' + aValues[ 1 ] + ' ' + ValueToStr( aValues[ 2 ] ) )

   RETURN NIL
