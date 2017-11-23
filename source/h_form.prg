/*
* $Id: h_form.prg $
*/
/*
* ooHG source code:
* Forms handling functions
* Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
* https://oohg.github.io/
* Portions of this project are based upon Harbour MiniGUI library.
* Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
* Portions of this project are based upon Harbour GUI framework for Win32.
* Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
* Copyright 2001 Antonio Linares <alinares@fivetech.com>
* Portions of this project are based upon Harbour Project.
* Copyright 1999-2017, https://harbour.github.io/
*/
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this software; see the file LICENSE.txt. If not, write to
* the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
* As a special exception, the ooHG Project gives permission for
* additional uses of the text contained in its release of ooHG.
* The exception is that, if you link the ooHG libraries with other
* files to produce an executable, this does not by itself cause the
* resulting executable to be covered by the GNU General Public License.
* Your use of that executable is in no way restricted on account of
* linking the ooHG library code into it.
* This exception does not however invalidate any other reasons why
* the executable file might be covered by the GNU General Public License.
* This exception applies only to the code released by the ooHG
* Project under the name ooHG. If you copy code from other
* ooHG Project or Free Software Foundation releases into a copy of
* ooHG, as the General Public License permits, the exception does
* not apply to the code that you add in this way. To avoid misleading
* anyone as to the status of such modified files, you must delete
* this exception notice from them.
* If you write modifications of your own for ooHG, it is your choice
* whether to permit this exception to apply to your modifications.
* If you do not wish that, delete this exception notice.
*/

#include "oohg.ch"
#include "i_windefs.ch"
#include "hbclass.ch"

#define HOTKEY_ID        1
#define HOTKEY_MOD       2
#define HOTKEY_KEY       3
#define HOTKEY_ACTION    4

STATIC _OOHG_aFormhWnd := {}, _OOHG_aFormObjects := {}               // TODO: Thread safe ?
STATIC _OOHG_UserWindow := nil       // User's window
STATIC _OOHG_InteractiveClose := 1   // Interactive close
STATIC _OOHG_ActiveModal := {}       // Modal windows' stack
STATIC _OOHG_ActiveForm := {}        // Forms under creation

#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef WINVER
   #define WINVER 0x0500
#endif
#if ( WINVER < 0x0500 )
   #undef WINVER
   #define WINVER 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif
#if ( _WIN32_WINNT < 0x0500 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0500
#endif

#include <hbapi.h>
#include <hbvm.h>
#include <hbstack.h>
#include <hbapiitm.h>
#include <windows.h>
#include <commctrl.h>
#include "oohg.h"

void _OOHG_SetMouseCoords( PHB_ITEM pSelf, int iCol, int iRow );

#pragma ENDDUMP

CLASS TForm FROM TWindow

   DATA oToolTip           INIT nil
   DATA Focused            INIT .T.
   DATA LastFocusedControl INIT 0
   DATA AutoRelease        INIT .F.
   DATA ActivateCount      INIT { 0, NIL, .T. }
   DATA oMenu              INIT nil
   DATA hWndClient         INIT NIL
   DATA oWndClient         INIT NIL
   DATA lInternal          INIT .F.
   DATA lForm              INIT .T.
   DATA nWidth             INIT 300
   DATA nHeight            INIT 300
   DATA lShowed            INIT .F.
   DATA lStretchBack       INIT .T.
   DATA hBackImage         INIT nil
   DATA lentersizemove     INIT .F.
   DATA ldefined           INIT .F.
   DATA uFormCursor        INIT IDC_ARROW

   DATA OnRelease          INIT nil
   DATA OnInit             INIT nil
   DATA OnMove             INIT nil
   DATA OnSize             INIT nil
   DATA OnPaint            INIT nil
   DATA OnScrollUp         INIT nil
   DATA OnScrollDown       INIT nil
   DATA OnScrollLeft       INIT nil
   DATA OnScrollRight      INIT nil
   DATA OnHScrollBox       INIT nil
   DATA OnVScrollBox       INIT nil
   DATA OnInteractiveClose INIT nil
   DATA OnMaximize         INIT nil
   DATA OnMinimize         INIT nil
   DATA OnRestore          INIT nil

   DATA nVirtualHeight INIT 0
   DATA nVirtualWidth  INIT 0
   DATA RangeHeight    INIT 0
   DATA RangeWidth     INIT 0
   DATA MinWidth       INIT 0
   DATA MaxWidth       INIT 0
   DATA MinHeight      INIT 0
   DATA MaxHeight      INIT 0
   DATA ForceRow       INIT nil     // Must be NIL instead of 0
   DATA ForceCol       INIT nil     // Must be NIL instead of 0

   DATA GraphControls  INIT {}
   DATA GraphTasks     INIT {}
   DATA GraphCommand   INIT nil
   DATA GraphData      INIT {}
   DATA SplitChildList INIT {}    // INTERNAL windows.
   DATA aChildPopUp    INIT {}    // POP UP windows.
   DATA lTopmost       INIT .F.
   DATA aNotifyIcons   INIT {}

   METHOD Title               SETGET
   METHOD Height              SETGET
   METHOD Width               SETGET
   METHOD Col                 SETGET
   METHOD Row                 SETGET
   METHOD Cursor              SETGET
   METHOD BackColor           SETGET
   METHOD TopMost             SETGET
   METHOD VirtualWidth        SETGET
   METHOD VirtualHeight       SETGET
   METHOD BackImage           SETGET
   METHOD AutoAdjust
   METHOD AdjustWindowSize
   METHOD ClientsPos
   METHOD Closable            SETGET
   METHOD FocusedControl
   METHOD SizePos
   METHOD Define
   METHOD Define2
   METHOD EndWindow
   METHOD Register
   METHOD Visible             SETGET
   METHOD Show
   METHOD Hide
   METHOD Flash
   METHOD Activate
   METHOD Release
   METHOD RefreshData
   METHOD Center()      BLOCK { | Self | C_Center( ::hWnd ) }
   METHOD Restore()     BLOCK { | Self | Restore( ::hWnd ) }
   METHOD Minimize()    BLOCK { | Self | Minimize( ::hWnd ) }
   METHOD Maximize()    BLOCK { | Self | Maximize( ::hWnd ) }
   METHOD DefWindowProc(nMsg,wParam,lParam)       BLOCK { |Self,nMsg,wParam,lParam| IF( ValidHandler( ::hWndClient ), ;
      DefFrameProc( ::hWnd, ::hWndClient, nMsg, wParam, lParam ) , ;
      DefWindowProc( ::hWnd, nMsg, wParam, lParam ) ) }

   METHOD ToolTipWidth( nWidth )          BLOCK { |Self, nWidth | ::oToolTip:WindowWidth( nWidth ) }
   METHOD ToolTipMultiLine( lMultiLine )  BLOCK { |Self,lMultiLine| ::oToolTip:MultiLine( lMultiLine ) }
   METHOD ToolTipAutoPopTime( nMilliSec ) BLOCK { |Self,nMilliSec| ::oToolTip:AutoPopTime( nMilliSec ) }
   METHOD ToolTipInitialTime( nMilliSec ) BLOCK { |Self,nMilliSec| ::oToolTip:InitialTime( nMilliSec ) }
   METHOD ToolTipResetDelays( nMilliSec ) BLOCK { |Self,nMilliSec| ::oToolTip:ResetDelays( nMilliSec ) }
   METHOD ToolTipReshowTime( nMilliSec )  BLOCK { |Self,nMilliSec| ::oToolTip:ReshowTime( nMilliSec ) }
   METHOD ToolTipIcon( nIcon )            BLOCK { |Self,nIcon| ::oToolTip:Icon( nIcon ) }
   METHOD ToolTipTitle( cTitle )          BLOCK { |Self,cTitle| ::oToolTip:Title( cTitle ) }

   METHOD GetWindowState()

   METHOD SetActivationFocus
   METHOD ProcessInitProcedure
   METHOD DeleteControl
   METHOD OnHideFocusManagement
   METHOD CheckInteractiveClose()
   METHOD DoEvent

   METHOD Events
   METHOD Events_Destroy
   METHOD Events_NCDestroy
   METHOD Events_VScroll
   METHOD Events_HScroll
   METHOD HelpButton          SETGET
   METHOD HelpTopic(lParam)   BLOCK { | Self, lParam | HelpTopic( GetControlObjectByHandle( GetHelpData( lParam ) ):HelpId , 2 ), Self, nil }
   METHOD ScrollControls
   METHOD MessageLoop
   METHOD HasStatusBar        BLOCK { | Self | aScan( ::aControls, { |c| c:Type == "MESSAGEBAR" } ) > 0 }
   METHOD Inspector           BLOCK { | Self | Inspector( Self ) }

   METHOD NotifyIconObject
   METHOD NotifyIcon            SETGET
   METHOD NotifyToolTip         SETGET
   METHOD NotifyIconLeftClick   SETGET
   METHOD NotifyIconDblClick    SETGET
   METHOD NotifyIconRightClick  SETGET
   METHOD NotifyIconRDblClick   SETGET
   METHOD NotifyIconMidClick    SETGET
   METHOD NotifyIconMDblClick   SETGET
   METHOD NotifyMenu            SETGET
   METHOD cNotifyIconName       SETGET
   METHOD cNotifyIconToolTip    SETGET
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
      fontcolor ) CLASS TForm

   LOCAL nStyle := 0, nStyleEx := 0
   LOCAL hParent

   IF HB_IsLogical( child ) .AND. child
      ::Type := "C"
      oParent := ::SearchParent( oParent )
      hParent := oParent:hWnd
   ELSE
      ::Type := "S"
      hParent := 0
   ENDIF

   nStyle   += WS_POPUP

   ::Define2( FormName, Caption, x, y, w, h, hParent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
      nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
      icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
      minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
      MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
      0, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
      DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
      MoveProcedure, fontcolor )

   RETURN Self

METHOD Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
      nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, FontName, FontSize, aRGB, cursor, ;
      icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
      minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
      MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
      nWindowType, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
      DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
      MoveProcedure, fontcolor ) CLASS TForm

   LOCAL Formhandle, aRet

   IF _OOHG_GlobalRTL()
      lRtl := .T.
   ELSEIF !HB_IsLogical( lRtl )
      lRtl := .F.
   ENDIF

   ::lRtl := lRtl

   IF ! valtype( FormName ) $ "CM"
      FormName := _OOHG_TempWindowName
   ENDIF
   _OOHG_TempWindowName := ""

   FormName := _OOHG_GetNullName( FormName )

   IF _IsWindowDefined( FormName )
      MsgOOHGError( "Window: " + FormName + " already defined. Program terminated." )
   ENDIF

   IF ! valtype( Caption ) $ "CM"
      Caption := ""
   ENDIF

   ASSIGN ::nVirtualHeight VALUE VirtualHeight TYPE "N"
   ASSIGN ::nVirtualWidth  VALUE VirtualWidth  TYPE "N"
   ASSIGN ::MinWidth       VALUE minwidth      TYPE "N"
   ASSIGN ::MaxWidth       VALUE maxwidth      TYPE "N"
   ASSIGN ::MinHeight      VALUE minheight     TYPE "N"
   ASSIGN ::MaxHeight      VALUE maxheight     TYPE "N"

   IF ! Valtype( aRGB ) $ 'AN'
      aRGB := -1
   ENDIF

   IF HB_IsLogical( helpbutton ) .AND. helpbutton
      nStyleEx += WS_EX_CONTEXTHELP
   ELSE
      nStyle += if( !HB_IsLogical( nominimize ) .OR. ! nominimize, WS_MINIMIZEBOX, 0 ) + ;
         if( !HB_IsLogical( nomaximize ) .OR. ! nomaximize, WS_MAXIMIZEBOX, 0 )
   ENDIF
   nStyle    += if( !HB_IsLogical( nosize )   .OR. ! nosize,    WS_SIZEBOX, 0 ) + ;
      if( !HB_IsLogical( nosysmenu ) .OR. ! nosysmenu, WS_SYSMENU, 0 ) + ;
      if( !HB_IsLogical( nocaption )  .OR. ! nocaption, WS_CAPTION, 0 )

   IF HB_IsLogical( topmost ) .AND. topmost
      ::lTopmost := .T.
      nStyleEx += WS_EX_TOPMOST
   ENDIF

   IF HB_IsLogical( mdi ) .AND. mdi
      IF nWindowType != 0
         *  mdichild .OR. mdiclient // .OR. splitchild
         * These windows' types can't be MDI FRAME
      ENDIF
      nWindowType := 4
      nStyle   += WS_CLIPSIBLINGS + WS_CLIPCHILDREN // + WS_THICKFRAME
   ELSE
      mdi := .F.
   ENDIF

   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   IF ::lInternal
      x := ::ContainerCol
      y := ::ContainerRow
   ELSE
      x := ::nCol
      y := ::nRow
   ENDIF
   IF nWindowType == 2
      Formhandle := InitWindowMDIClient( Caption, x, y, ::nWidth, ::nHeight, Parent, "MDICLIENT", nStyle, nStyleEx, lRtl )
   ELSE
      UnRegisterWindow( FormName )
      aRet := RegisterWindow( icon, FormName, aRGB, nWindowType )
      IF aRet[ 2 ]
         MsgOOHGError( "Window " + FormName + " registration failed. Program terminated." )
      ENDIF
      ::BrushHandle := aRet[ 1 ]
      Formhandle := InitWindow( Caption, x, y, ::nWidth, ::nHeight, Parent, FormName, nStyle, nStyleEx, lRtl )
   ENDIF

   IF Valtype( cursor ) $ "CM"
      SetWindowCursor( Formhandle , cursor )
   ENDIF

   ::Register( FormHandle, FormName )
   ::oToolTip := TToolTip():Define( , Self )

   ASSIGN clientarea VALUE clientarea TYPE "L" DEFAULT .F.
   IF clientarea
      ::SizePos( , , ::Width + ::nWidth - ::ClientWidth, ::Height + ::nHeight - ::ClientHeight )
   ENDIF

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

   IF ! ::lInternal .AND. ValidHandler( Parent )
      AADD( GetFormObjectByHandle( Parent ):aChildPopUp , Self )
   ENDIF

   _PushEventInfo()
   _OOHG_ThisForm      := Self
   _OOHG_ThisEventType := "WINDOW_DEFINE"
   _OOHG_ThisType      := "W"
   _OOHG_ThisControl   := NIL
   _OOHG_ThisObject    := Self

   RETURN Self

METHOD EndWindow() CLASS TForm

   LOCAL nPos

   nPos := ASCAN( _OOHG_ActiveForm, { |o| o:Name == ::Name .AND. o:hWnd == ::hWnd } )
   IF nPos > 0
      ::nOldw := ::ClientWidth
      ::nOldh := ::ClientHeight
      ::nWindowState := ::GetWindowState()   ///obtiene el estado inicial de la ventana
      _OOHG_DeleteArrayItem( _OOHG_ActiveForm, nPos )
   ENDIF
   _PopEventInfo()
   ::lDefined := .T.

   RETURN NIL

METHOD Register( hWnd, cName ) CLASS TForm

   LOCAL mVar

   ::hWnd := hWnd
   ::StartInfo( hWnd )
   ::Name := cName

   AADD( _OOHG_aFormhWnd,    hWnd )
   AADD( _OOHG_aFormObjects, Self )

   mVar := "_" + cName
   PUBLIC &mVar. := Self

   RETURN Self

METHOD Visible( lVisible, nFlags, nTime ) CLASS TForm

   ASSIGN nFlags VALUE nFlags TYPE "N"
   ASSIGN nTime  VALUE nTime  TYPE "N" DEFAULT 200
   IF HB_IsLogical( lVisible )
      ::lVisible := lVisible
      IF ! ::ContainerVisible
         IF PCOUNT() == 1
            HideWindow( ::hWnd )
         ELSE
            AnimateWindow( ::hWnd, nTime, nFlags, .T. )
         ENDIF
         ::OnHideFocusManagement()
      ELSE
         IF PCOUNT() > 1
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

   RETURN ::lVisible

METHOD Show( nFlags, nTime ) CLASS TForm

   IF PCOUNT() == 0
      ::Visible := .T.
   ELSE
      ::Visible( .T., nFlags, nTime )
   ENDIF

   RETURN .T.

METHOD Hide( nFlags, nTime ) CLASS TForm

   IF PCOUNT() == 0
      ::Visible := .F.
   ELSE
      ::Visible( .F., nFlags, nTime )
   ENDIF

   RETURN .T.

METHOD Activate( lNoStop, oWndLoop ) CLASS TForm

   IF ::Active
      MsgOOHGError( "Window: " + ::Name + " already active. Program terminated." )
   ENDIF

   ASSIGN lNoStop VALUE lNoStop TYPE "L" DEFAULT .F.

   IF _OOHG_ThisEventType == 'WINDOW_RELEASE' .AND. ! lNoStop
      MsgOOHGError( "ACTIVATE WINDOW: activate windows within an 'on release' window procedure is not allowed. Program terminated." )
   ENDIF

   TForm_WindowStructureClosed( Self )
   // If Len( _OOHG_ActiveForm ) > 0
   //    MsgOOHGError( "ACTIVATE WINDOW: DEFINE WINDOW structure is not closed. Program terminated." )
   // Endif

   IF _OOHG_ThisEventType == 'WINDOW_GOTFOCUS'
      MsgOOHGError( "ACTIVATE WINDOW / Activate(): Not allowed in window's GOTFOCUS event procedure. Program terminated." )
   ENDIF

   IF _OOHG_ThisEventType == 'WINDOW_LOSTFOCUS'
      MsgOOHGError( "ACTIVATE WINDOW / Activate(): Not allowed in window's LOSTFOCUS event procedure. Program terminated." )
   ENDIF

   // Checks for non-stop window
   IF !HB_IsObject( oWndLoop )
      oWndLoop := IF( lNoStop .AND. HB_IsObject( _OOHG_Main ) , _OOHG_Main, Self )
   ENDIF
   ::ActivateCount := oWndLoop:ActivateCount
   ::ActivateCount[ 1 ]++
   ::Active := .T.

   IF ! ::oWndClient == NIL
      ::oWndClient:Events_Size()
   ENDIF

   // Show window
   IF ::lVisible
      _OOHG_UserWindow := Self
      ::Show()
   ENDIF

   ::ProcessInitProcedure()
   // CGR
   ::ClientsPos()
   ::RefreshData()

   // Starts the Message Loop
   IF ! lNoStop
      ::MessageLoop()
   ENDIF

   RETURN NIL

STATIC FUNCTION TForm_WindowStructureClosed( Self )

   IF ASCAN( _OOHG_ActiveForm, { |o| o:Name == ::Name .AND. o:hWnd == ::hWnd } ) > 0
      MsgOOHGError( "ACTIVATE WINDOW: DEFINE WINDOW structure for window " + ::Name + " is not closed. Program terminated." )
   ENDIF
   AEVAL( ::SplitChildList, { |o| TForm_WindowStructureClosed( o ) } )

   RETURN NIL

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
         MsgOOHGError( "Window: " + ::Name + " is not active. Program terminated." )
      ENDIF

      _ReleaseWindowList( { Self } )

      // Release Window

      IF ValidHandler( ::hWnd )
         EnableWindow( ::hWnd )
         SendMessage( ::hWnd, WM_SYSCOMMAND, SC_CLOSE, 0 )
      ENDIF

      ::Events_Destroy()
   ENDIF

   RETURN NIL

METHOD RefreshData() CLASS TForm

   IF HB_IsBlock( ::Block )
      ::Value := _OOHG_EVAL( ::Block )
   ENDIF
   AEVAL( ::aControls, { |o| If( o:Container == nil, o:RefreshData(), ) } )

   RETURN NIL

METHOD SetActivationFocus() CLASS TForm

   LOCAL Sp, nSplit

   nSplit := ASCAN( ::SplitChildList, { |o| o:Focused } )
   IF nSplit > 0
      ////      ::SplitChildList:SetFocus()
      ::SplitChildList[ nSplit ]:SetFocus()
   ELSEIF ::Focused
      Sp := GetFocus()
      IF ASCAN( ::aControls, { |o| o:hWnd == Sp } ) == 0
         SetFocus( GetNextDlgTabItem( ::hWnd, 0, .F. ) )
      ENDIF
   ENDIF

   RETURN NIL

METHOD ProcessInitProcedure() CLASS TForm

   IF HB_IsBlock( ::OnInit )
      ::DoEvent( ::OnInit, "WINDOW_INIT" )
   ENDIF
   AEVAL( ::SplitChildList, { |o| o:ProcessInitProcedure() } )

   RETURN NIL

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

   RETURN ( ::Caption := cTitle )

METHOD Height( nHeight ) CLASS TForm

   IF HB_IsNumeric( nHeight )
      ::SizePos( , , , nHeight )
   ENDIF

   RETURN GetWindowHeight( ::hWnd )

METHOD Width( nWidth ) CLASS TForm

   IF HB_IsNumeric( nWidth )
      ::SizePos( , , nWidth )
   ENDIF

   RETURN GetWindowWidth( ::hWnd )

METHOD Col( nCol ) CLASS TForm

   IF HB_IsNumeric( nCol )
      ::SizePos( , nCol )
   ENDIF

   RETURN GetWindowCol( ::hWnd )

METHOD Row( nRow ) CLASS TForm

   IF HB_IsNumeric( nRow )
      ::SizePos( nRow )
   ENDIF

   RETURN GetWindowRow( ::hWnd )

METHOD VirtualWidth( nSize ) CLASS TForm

   IF HB_IsNumeric( nSize )
      ::nVirtualWidth := nSize
      ValidateScrolls( Self, .T. )
   ENDIF

   RETURN ::nVirtualWidth

METHOD VirtualHeight( nSize ) CLASS TForm

   IF HB_IsNumeric( nSize )
      ::nVirtualHeight := nSize
      ValidateScrolls( Self, .T. )
   ENDIF

   RETURN ::nVirtualHeight

METHOD FocusedControl() CLASS TForm

   LOCAL hWnd, nPos

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

   RETURN if( nPos == 0, "", ::aControls[ nPos ]:Name )

METHOD Cursor( uValue ) CLASS TForm

   IF uValue != nil
      IF SetWindowCursor( ::hWnd, uValue )
         ::uFormCursor := uValue
      ENDIF
   ENDIF

   RETURN ::uFormCursor

METHOD AutoAdjust( nDivH, nDivW ) CLASS TForm

   LOCAL lSwvisible

   lSwvisible := ::Visible
   IF lSwvisible
      ::Hide()
   ENDIF

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:AdjustResize( nDivH, nDivW ), ) } )

   IF lSwvisible
      ::Show()
   ENDIF

   RETURN NIL

METHOD AdjustWindowSize( lSkip ) CLASS TForm

   LOCAL nWidth, nHeight, nOldWidth, nOldHeight, n, oControl, nHeightUsed

   nWidth  := ::ClientWidth
   nHeight := ::ClientHeight

   IF HB_IsNumeric( ::nOldW ) .AND. HB_IsNumeric( ::nOldH )
      nOldWidth  := ::nOldW
      nOldHeight := ::nOldH
   ELSE
      nOldWidth  := nWidth
      nOldHeight := nHeight
   ENDIF

   IF _OOHG_AutoAdjust .AND. ::lAdjust .AND. ( ! HB_IsLogical( lSkip ) .OR. ! lSkip )
      ::nFixedHeightUsed := 0

      FOR n := 1 to Len( ::aControls )
         oControl := ::aControls[ n ]

         nHeightUsed := oControl:ClientHeightUsed
         IF nHeightUsed > 0 .and. oControl:Container == Nil
            ::nFixedHeightUsed += nHeightUsed
         ENDIF
      NEXT n

      ::AutoAdjust( (nHeight - ::nFixedHeightUsed) / (nOldHeight - ::nFixedHeightUsed), nWidth / nOldWidth )
   ENDIF

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:AdjustAnchor( nHeight - nOldHeight, nWidth - nOldWidth ), ) } )

   ::ClientsPos()

   ::nOldW := nWidth
   ::nOldH := nHeight

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:Events_Size(), ) } )

   RETURN NIL

METHOD ClientsPos() CLASS TForm

   LOCAL aControls, nWidth, nHeight

   aControls := {}
   AEVAL( ::aControls, { |o| IF( o:Container == nil, AADD( aControls, o ), ) } )
   nWidth  := ::ClientWidth
   nHeight := ::ClientHeight

   RETURN ::ClientsPos2( aControls, nWidth, nHeight )

#pragma BEGINDUMP

HB_FUNC_STATIC( TFORM_BACKCOLOR )
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
      if( oSelf->lBackColor != -1 )
      {
         oSelf->BrushHandle = CreateSolidBrush( oSelf->lBackColor );
      }
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
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

METHOD GetWindowstate( ) CLASS Tform

   IF IsWindowmaximized( ::Hwnd )

      RETURN 2
   ELSEIF IsWindowminimized( ::Hwnd )

      RETURN 1
   ELSE

      RETURN 0
   ENDIF

   RETURN NIL

METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TForm

   LOCAL xRet, actpos:= { 0, 0, 0, 0 }

   GetWindowRect( ::hWnd, actpos )
   IF ! HB_IsNumeric( nCol )
      nCol := actpos[ 1 ]
   ENDIF
   IF ! HB_IsNumeric( nRow )
      nRow := actpos[ 2 ]
   ENDIF
   IF ! HB_IsNumeric( nWidth )
      nWidth := actpos[ 3 ] - actpos[ 1 ]
   ENDIF
   IF ! HB_IsNumeric( nHeight )
      nHeight := actpos[ 4 ] - actpos[ 2 ]
   ENDIF
   xRet := MoveWindow( ::hWnd , nCol , nRow , nWidth , nHeight , .t. )
   //CGR
   ::CheckClientsPos()

   RETURN xRet

METHOD DeleteControl( oControl ) CLASS TForm

   LOCAL nPos

   // Removes INTERNAL window from ::SplitChildList
   nPos := aScan( ::SplitChildList, { |o| o:hWnd == oControl:hWnd } )
   IF nPos > 0
      _OOHG_DeleteArrayItem( ::SplitChildList, nPos )
   ENDIF

   // Removes POPUP window from ::aChildPopUp
   nPos := aScan( ::aChildPopUp, { |o| o:hWnd == oControl:hWnd } )
   IF nPos > 0
      _OOHG_DeleteArrayItem( ::aChildPopUp, nPos )
   ENDIF

   RETURN ::Super:DeleteControl( oControl )

METHOD OnHideFocusManagement() CLASS TForm

   RETURN NIL

METHOD Closable( lCloseable ) CLASS TForm

   LOCAL lRet

   IF IsWindowStyle( ::hWnd, WS_CAPTION ) .AND. IsWindowStyle( ::hWnd, WS_SYSMENU )
      lRet := MenuEnabled( GetSystemMenu( ::hWnd ), SC_CLOSE, lCloseable )
   ELSE
      lRet := .F.
   ENDIF

   RETURN lRet

METHOD CheckInteractiveClose() CLASS TForm

   LOCAL lRet := .T.

   /*
   0 - close is not allowed
   1 - close is allowed, no question is asked before
   2 - close is allowed when question is answered yes
   */
   DO CASE
   CASE _OOHG_InteractiveClose == 0
      MsgStop( _OOHG_Messages( 1, 3 ) )
      lRet := .F.
   CASE _OOHG_InteractiveClose == 2
      lRet := MsgYesNo( _OOHG_Messages( 1, 1 ), _OOHG_Messages( 1, 2 ) )
   ENDCASE

   RETURN lRet

METHOD DoEvent( bBlock, cEventType, aParams ) CLASS TForm

   LOCAL lRetVal := .F.

   IF ::lDestroyed
      lRetVal := .F.
   ELSEIF HB_IsBlock( bBlock )
      _PushEventInfo()
      _OOHG_ThisForm      := Self
      _OOHG_ThisType      := "W"
      ASSIGN _OOHG_ThisEventType VALUE cEventType TYPE "CM" DEFAULT ""
      _OOHG_ThisControl   := NIL
      _OOHG_ThisObject    := Self
      lRetVal := _OOHG_Eval_Array( bBlock, aParams )
      _PopEventInfo()
   ENDIF

   RETURN lRetVal

METHOD Events_Destroy() CLASS TForm

   LOCAL mVar

   ::ReleaseAttached()

   // Any data must be destroyed... regardless FORM is active or not.

   IF ::oMenu != NIL
      ::oMenu:Release()
      ::oMenu := nil
   ENDIF

   // Update Form Index Variable
   IF ! Empty( ::Name )
      mVar := '_' + ::Name
      IF type( mVar ) != 'U'
         __MVPUT( mVar , 0 )
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

   /*
   We can�t remove hWnd from the arrays at this point
   because we need to use GetFormObjectByHandle() to
   process WM_NCDESTROY message. See ::Events_NCDestroy
   and _OOHG_WndProcForm() function.

   // Removes WINDOW from the array
   i := Ascan( _OOHG_aFormhWnd, ::hWnd )
   IF i > 0
   _OOHG_DeleteArrayItem( _OOHG_aFormhWnd, I )
   _OOHG_DeleteArrayItem( _OOHG_aFormObjects, I )
   ENDIF
   */

   // Eliminates active modal
   IF Len( _OOHG_ActiveModal ) != 0 .AND. ATAIL( _OOHG_ActiveModal ):hWnd == ::hWnd
      _OOHG_DeleteArrayItem( _OOHG_ActiveModal, Len( _OOHG_ActiveModal ) )
   ENDIF

   ::Active := .F.
   ::Super:Release()

   RETURN NIL

METHOD Events_NCDestroy CLASS TForm

   LOCAL i

   /*
   * UnRegisterWindow( ::Name )
   * This doen't works because a class cant be
   * unregistered if a window of that class exists.
   * To avoid problems we must unregister in
   * ::Define before defining again.
   * Windows automatically unregisteres all
   * remaining classes at the end of the application.
   */

   i := aScan( _OOHG_aFormhWnd, ::hWnd )
   IF i > 0
      _OOHG_DeleteArrayItem( _OOHG_aFormhWnd, i )
      _OOHG_DeleteArrayItem( _OOHG_aFormObjects, i )
   ENDIF

   RETURN NIL

METHOD Events_VScroll( wParam ) CLASS TForm

   LOCAL uRet, nAt

   uRet := ::VScrollBar:Events_VScroll( wParam )
   ::RowMargin := - ::VScrollBar:Value
   ::ScrollControls()
   IF ( nAt := aScan( ::aControls, { |c| c:Type == "MESSAGEBAR" .AND. c:Visible } ) ) > 0
      ::aControls[ nAt ]:Redraw()
   ENDIF

   RETURN uRet

METHOD Events_HScroll( wParam ) CLASS TForm

   LOCAL uRet

   uRet := ::HScrollBar:Events_HScroll( wParam )
   ::ColMargin := - ::HScrollBar:Value
   ::ScrollControls()

   RETURN uRet

METHOD ScrollControls() CLASS TForm

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:SizePos(), ) } )
   ReDrawWindow( ::hWnd )

   RETURN Self

METHOD Topmost( lTopmost ) CLASS TForm

   IF HB_IsLogical( lTopmost )
      ::lTopmost := lTopmost
      SetFormTopmost( ::hWnd, lTopmost )
   ENDIF

   RETURN ::lTopmost

METHOD HelpButton( lShow ) CLASS TForm

   IF HB_IsLogical( lShow )
      IF lShow
         WindowExStyleFlag( ::hWnd, WS_EX_CONTEXTHELP, WS_EX_CONTEXTHELP )
         WindowStyleFlag( ::hWnd, WS_MAXIMIZEBOX + WS_MINIMIZEBOX, 0 )
      ELSE
         WindowExStyleFlag( ::hWnd, WS_EX_CONTEXTHELP, 0 )
         WindowStyleFlag( ::hWnd, WS_MAXIMIZEBOX + WS_MINIMIZEBOX, WS_MAXIMIZEBOX + WS_MINIMIZEBOX )
      ENDIF
      SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_FRAMECHANGED )
   ENDIF

   RETURN IsWindowExStyle( ::hWnd, WS_EX_CONTEXTHELP )

METHOD BackImage( uBackImage ) CLASS TForm

   LOCAL hImageWork

   IF PCount() > 0
      IF ::hBackImage != NIL
         DeleteObject( ::hBackImage )
      ENDIF

      IF ValType( uBackImage ) $ "CM"
         ::hBackImage := _OOHG_BitmapFromFile( Self, uBackImage, LR_CREATEDIBSECTION, .F. )
      ELSEIF ValidHandler( uBackImage )
         ::hBackImage := uBackImage
      ELSE
         ::hBackImage := NIL
      ENDIF

      IF ::hBackImage == NIL
         ::BackBitmap := NIL
      ELSE
         IF ::lStretchBack
            hImageWork := _OOHG_ScaleImage( Self, ::hBackImage, ::ClientWidth, ::ClientHeight, .F., NIL, .F., 0, 0 )
         ELSE
            hImageWork := _OOHG_CopyBitmap( ::hBackImage, 0, 0, LR_CREATEDIBSECTION )
         ENDIF
         ::BackBitmap := hImageWork
         DeleteObject( hImageWork )
      ENDIF

      ReDrawWindow( ::hWnd )
   ENDIF

   RETURN ::hBackImage

METHOD Flash( nWhat, nTimes, nMilliseconds ) CLASS TForm

   /*
   * nWhat            action
   * FLASHW_CAPTION   Flash the window caption.
   * FLASHW_TRAY      Flash the taskbar button.
   * FLASHW_ALL       Flash both the window caption and the taskbar button.
   * FLASHW_TIMER     Add to one the previous to flash continuously, until the FLASHW_STOP flag is set.
   * FLASHW_STOP      Stop flashing. The system restores the window to its original state.
   * FLASHW_TIMERNOFG Add to FLASHW_TRAY to continuously flash the taskbar button until the window comes to the foreground.
   * nTimes           Number of times to flash the window.
   *                  Set to 0 when using FLASHW_TIMER to obtain non-stop flashing.
   *                  Set to 0 when usingh FLASHW_CAPTION, FLASHW_TRAY or FLASHW_ALL to toggle the current flash status.
   * nMilliseconds    Flashing interval. 0 means use the default cursor blink rate
   * If the window caption was drawn as active before the call, the return value is .T.
   * Otherwise, the return value is .F.
   */

   RETURN FlashWindowEx( ::hWnd, nWhat, nTimes, nMilliseconds )

#pragma BEGINDUMP

// -----------------------------------------------------------------------------
HB_FUNC_STATIC( TFORM_EVENTS )   // METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TForm
// -----------------------------------------------------------------------------
{
   static PHB_SYMB s_Events2 = 0;

   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) hb_parni( 3 );
   LPARAM lParam  = ( LPARAM ) hb_parnl( 4 );
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
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         hb_ret();
         break;

      case WM_LBUTTONDOWN:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnClick, "CLICK", lParam );
         hb_ret();
         break;

      case WM_LBUTTONDBLCLK:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnDblClick, "DBLCLICK", lParam );
         hb_ret();
         break;

      case WM_RBUTTONUP:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnRClick, "RCLICK", lParam );
         hb_ret();
         break;

      case WM_RBUTTONDOWN:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         hb_ret();
         break;

      case WM_RBUTTONDBLCLK:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnRDblClick, "RDBLCLICK", lParam );
         hb_ret();
         break;

      case WM_MBUTTONUP:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnMClick, "MCLICK", lParam );
         hb_ret();
         break;

      case WM_MBUTTONDOWN:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         hb_ret();
         break;

      case WM_MBUTTONDBLCLK:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
         _OOHG_DoEventMouseCoords( pSelf, s_OnMDblClick, "MDBLCLICK", lParam );
         hb_ret();
         break;

      case WM_MOUSEMOVE:
         _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );
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

      case WM_MOUSEWHEEL:
         _OOHG_Send( pSelf, s_hWnd );
         hb_vmSend( 0 );
         if( ValidHandler( HWNDparam( -1 ) ) )
         {
            _OOHG_Send( pSelf, s_RangeHeight );
            hb_vmSend( 0 );
            if( hb_parnl( -1 ) > 0 )
            {
               if( ( short ) HIWORD( wParam ) > 0 )
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
         hb_vmPushLong( wParam );
         hb_vmPushLong( lParam );
         hb_vmDo( 5 );
         break;
   }
}

#pragma ENDDUMP

FUNCTION _OOHG_TForm_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TForm

   LOCAL i, NextControlHandle, xRetVal
   LOCAL oCtrl, lMinim, nOffset,nDesp

   DO CASE

   CASE nMsg == WM_HOTKEY

      // Process HotKeys
      i := ASCAN( ::aHotKeys, { |a| a[ HOTKEY_ID ] == wParam } )
      IF i > 0
         ::DoEvent( ::aHotKeys[ i ][ HOTKEY_ACTION ], "HOTKEY" )
      ENDIF

      // Accelerators
      i := ASCAN( ::aAcceleratorKeys, { |a| a[ HOTKEY_ID ] == wParam } )
      IF i > 0
         ::DoEvent( ::aAcceleratorKeys[ i ][ HOTKEY_ACTION ], "ACCELERATOR" )
      ENDIF

   CASE nMsg == WM_ACTIVATE

      IF LoWord(wparam) == 0      // WA_INACTIVE

         aeval( ::aHotKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )
         ::LastFocusedControl := GetFocus()
         IF ! ::ContainerReleasing
            ::DoEvent( ::OnLostFocus, "WINDOW_LOSTFOCUS" )
         ENDIF

      ELSE

         IF ValidHandler( ::hWnd )
            UpdateWindow( ::hWnd )
         ENDIF

      ENDIF

   CASE nMsg == WM_SETFOCUS

      IF ::Active .AND. ! ::lInternal
         _OOHG_UserWindow := Self
      ENDIF
      aeval( ::aHotKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )
      aeval( ::aHotKeys, { |a| InitHotKey( ::hWnd, a[ HOTKEY_MOD ], a[ HOTKEY_KEY ], a[ HOTKEY_ID ] ) } )
      ::DoEvent( ::OnGotFocus, "WINDOW_GOTFOCUS" )
      IF ! empty( ::LastFocusedControl )
         SetFocus( ::LastFocusedControl )
      ENDIF

   CASE nMsg == WM_HELP

      RETURN ::HelpTopic( lParam )

   CASE nMsg == WM_TASKBAR

      i := ASCAN( ::aNotifyIcons, { |o| o:nTrayId == wParam } )
      IF i > 0
         ::aNotifyIcons[ i ]:Events_TaskBar( lParam )
      ENDIF

   CASE nMsg == WM_NEXTDLGCTL

      IF LoWord( lParam ) != 0
         // wParam contains next control's handler
         NextControlHandle := wParam
      ELSE
         // wParam indicates next control's direction
         NextControlHandle := GetNextDlgTabItem( hWnd, GetFocus(), wParam )
      ENDIF

      oCtrl := GetControlObjectByHandle( NextControlHandle )

      IF oCtrl:hWnd == NextControlHandle
         oCtrl:SetFocus()
      ELSE
         SetFocus( NextControlHandle )
      ENDIF

      * To update the default pushbutton border!
      * To set the default control identifier!
      * Return 0

   CASE nMsg == WM_PAINT

      ::DefWindowProc( nMsg, wParam, lParam )

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
      ENDIF

      RETURN 1

   CASE nMsg == WM_ENTERSIZEMOVE

      IF ! ! _OOHG_AutoAdjust .OR. ! ::lAdjust
         ::lEnterSizeMove := .T.
      ENDIF

   CASE nMsg == WM_MOVE

      ::DoEvent( ::OnMove, "WINDOW_MOVE" )

   CASE nMsg == WM_SIZE

      IF ! ::lEnterSizeMove
         ValidateScrolls( Self, .T. )
         IF ::Active
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
            IF ! lMinim
               ::AdjustWindowSize( lMinim )
            ENDIF
            ::DoEvent( ::OnSize, "WINDOW_SIZE" )
         ELSE
            IF ::lDefined
               ::AdjustWindowSize()
            ENDIF
         ENDIF
      ENDIF

      IF ::oWndClient != NIL
         // It was already done
         // ::oWndClient:Events_Size()

         RETURN 0
      ENDIF

   CASE nMsg == WM_EXITSIZEMOVE    //// cuando se cambia el tama�o por reajuste con el mouse

      IF ::Active .AND. ( ! _OOHG_AutoAdjust .OR. ! ::lAdjust .OR. ( ::nOldW # NIL .OR. ::nOldH # NIL ) .AND. ( ::nOldW # ::Width .OR. ::nOldH # ::Height ) )
         ::AdjustWindowSize()
         ::DoEvent( ::OnSize, "WINDOW_SIZE" )
      ENDIF
      ::lEnterSizeMove := .F.

   CASE nMsg == WM_SIZING

      IF _TForm_Sizing( wParam, lParam, ::MinWidth, ::MaxWidth, ::MinHeight, ::MaxHeight )
         ::DefWindowProc( nMsg, wParam, lParam )

         RETURN 1
      ENDIF

   CASE nMsg == WM_MOVING

      IF _TForm_Moving( lParam, ::ForceRow, ::ForceCol )
         ::DefWindowProc( nMsg, wParam, lParam )

         RETURN 1
      ENDIF

   CASE nMsg == WM_CLOSE

      // ::lReleasing must be checked every time because it can be changed by any process.
      IF ! ::lReleasing .AND. HB_IsBlock( ::OnInteractiveClose )
         xRetVal := ::DoEvent( ::OnInteractiveClose, "WINDOW_ONINTERACTIVECLOSE" )
         IF HB_IsLogical( xRetVal ) .AND. ! xRetVal

            RETURN 1
         ENDIF
      ENDIF

      IF ! ::lReleasing .AND. ! ::CheckInteractiveClose()

         RETURN 1
      ENDIF

      // Process AutoRelease property
      IF ! ::lReleasing .AND. ! ::AutoRelease
         ::Hide()

         RETURN 1
      ENDIF

      // Destroy window
      _ReleaseWindowList( { Self } )

      IF ::Type == "A"
         // Main window
         ReleaseAllWindows()
      ELSE
         ::OnHideFocusManagement()
      ENDIF

      /*
      * This function must return NIL after processing WM_CLOSE so the
      * OS can do it's default processing. This processing ends with
      * (a) the posting of a WM_DESTROY message to the queue (will be
      * processed by this same function), immediately followed by
      * (b) the sending of a WM_NCDESTROY message to the form's
      * WindowProc (redirected to _OOHG_WndProcForm()).
      */

   CASE nMsg == WM_DESTROY

      ::Events_Destroy()

   OTHERWISE

      // return ::Super:Events( hWnd, nMsg, wParam, lParam )

      RETURN ::TWindow:Events( hWnd, nMsg, wParam, lParam )

   ENDCASE

   RETURN NIL

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
   hb_retl( _OOHG_AdjustSize( hb_parni( 1 ), ( RECT * ) hb_parnl( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ) ) );
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

   hb_retl( _OOHG_AdjustPosition( ( RECT * ) hb_parnl( 1 ), iForceRow, iForceCol ) );
}

#pragma ENDDUMP

PROCEDURE ValidateScrolls( Self, lMove )

   LOCAL hWnd, nVirtualWidth, nVirtualHeight
   LOCAL aRect, w, h, hscroll, vscroll

   IF ! ValidHandler( ::hWnd ) .OR. ::HScrollBar == nil .OR. ::VScrollBar == nil

      RETURN
   ENDIF

   // Initializes variables
   hWnd := ::hWnd
   nVirtualWidth := ::VirtualWidth
   nVirtualHeight := ::VirtualHeight
   IF !HB_IsLogical( lMove )
      lMove := .F.
   ENDIF
   vscroll := hscroll := .F.
   aRect := ARRAY( 4 )
   GetClientRect( hWnd, aRect )
   w := aRect[ 3 ] - aRect[ 1 ] + IF( IsWindowStyle( ::hWnd, WS_VSCROLL ), GetVScrollBarWidth(),  0 )
   h := aRect[ 4 ] - aRect[ 2 ] + IF( IsWindowStyle( ::hWnd, WS_HSCROLL ), GetHScrollBarHeight(), 0 )
   ::RangeWidth := ::RangeHeight := 0

   // Checks if there's space on the window
   IF h < nVirtualHeight
      ::RangeHeight := nVirtualHeight - h
      vscroll := .T.
      w -= GetVScrollBarWidth()
   ENDIF
   IF w < nVirtualWidth
      ::RangeWidth := nVirtualWidth - w
      hscroll := .T.
      h -= GetHScrollBarHeight()
   ENDIF
   IF h < nVirtualHeight .AND. ! vscroll
      ::RangeHeight := nVirtualHeight - h
      vscroll := .T.
      w -= GetVScrollBarWidth()
   ENDIF

   // Shows/hides scroll bars
   _SetScroll( hWnd, hscroll, vscroll )
   ::VScrollBar:lAutoMove := vscroll
   ::VScrollBar:nPageSkip := h
   ::HScrollBar:lAutoMove := hscroll
   ::HScrollBar:nPageSkip := w

   // Verifies there's no "extra" space derived from resize
   IF vscroll
      ::VScrollBar:SetRange( 0, ::VirtualHeight )
      ::VScrollBar:Page := h
      IF ::RangeHeight < ( - ::RowMargin )
         ::RowMargin := - ::RangeHeight
         ::VScrollBar:Value := ::RangeHeight
      ELSE
         vscroll := .F.
      ENDIF
   ELSEIF nVirtualHeight > 0 .AND. ::RowMargin != 0
      ::RowMargin := 0
      vscroll := .T.
   ENDIF
   IF hscroll
      ::HScrollBar:SetRange( 0, ::VirtualWidth )
      ::HScrollBar:Page := w
      IF ::RangeWidth < ( - ::ColMargin )
         ::ColMargin := - ::RangeWidth
         ::HScrollBar:Value := ::RangeWidth
      ELSE
         hscroll := .F.
      ENDIF
   ELSEIF nVirtualWidth > 0 .AND. ::ColMargin != 0
      ::ColMargin := 0
      hscroll := .T.
   ENDIF

   // Reubicates controls
   IF lMove .AND. ( vscroll .OR. hscroll )
      ::ScrollControls()
   ENDIF

   RETURN

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
      MoveProcedure, fontcolor ) CLASS TFormMain

   LOCAL nStyle := 0, nStyleEx := 0

   IF _OOHG_Main != nil
      MsgOOHGError( "Main window already defined. Program terminated." )
   ENDIF

   _OOHG_Main := Self
   nStyle += WS_POPUP
   ASSIGN icon VALUE icon TYPE "CM" DEFAULT _OOHG_Main_Icon

   ::Define2( FormName, Caption, x, y, w, h, 0, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
      nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
      icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
      minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
      MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, nil, nStyle, nStyleEx, ;
      0, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
      DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
      MoveProcedure, fontcolor )

   ::NotifyIconObject:Picture := NotifyIconName
   ::NotifyIconObject:ToolTip := NotifyIconToolTip
   ::NotifyIconObject:OnClick := NotifyIconLeftClick

   RETURN Self

METHOD Activate( lNoStop, oWndLoop ) CLASS TFormMain

   ::lFirstActivate := .T.

   RETURN ::Super:Activate( lNoStop, oWndLoop )

METHOD Release() CLASS TFormMain

   _ReleaseWindowList( { Self } )
   ReleaseAllWindows()

   RETURN ::Super:Release()

METHOD CheckInteractiveClose() CLASS TFormMain

   LOCAL lRet

   IF _OOHG_InteractiveClose == 3
      lRet := MsgYesNo( _OOHG_Messages( 1, 1 ), _OOHG_Messages( 1, 2 ) )
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
      MoveProcedure, fontcolor ) CLASS TFormModal

   LOCAL nStyle := WS_POPUP, nStyleEx := 0
   LOCAL oParent, hParent

   Empty( modalsize )

   oParent := ::SearchParent( Parent )
   IF HB_IsObject( oParent )
      hParent := oParent:hWnd
   ELSE
      hParent := 0
      * Must have a parent!!!!!
   ENDIF

   ::oPrevWindow := oParent

   ::Define2( FormName, Caption, x, y, w, h, hParent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
      nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
      icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
      minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
      MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
      0, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
      DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
      MoveProcedure, fontcolor )

   RETURN Self

METHOD Visible( lVisible ) CLASS TFormModal

   IF HB_IsLogical( lVisible )
      IF lVisible
         // Find Previous window
         IF aScan( _OOHG_aFormhWnd, GetActiveWindow() ) > 0
            ::oPrevWindow := GetFormObjectByHandle( GetActiveWindow() )
         ELSEIF _OOHG_UserWindow != NIL .AND. ascan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
            ::oPrevWindow := _OOHG_UserWindow
         ELSEIF Len( _OOHG_ActiveModal ) != 0 .AND. ascan( _OOHG_aFormhWnd, ATAIL( _OOHG_ActiveModal ):hWnd ) > 0
            ::oPrevWindow := ATAIL( _OOHG_ActiveModal )
         ELSEIF ::Parent != NIL .AND. ascan( _OOHG_aFormhWnd, ::Parent:hWnd ) > 0
            ::oPrevWindow := _OOHG_UserWindow
         ELSEIF _OOHG_Main != nil
            ::oPrevWindow := _OOHG_Main
         ELSE
            ::oPrevWindow := NIL
            // Not mandatory MAIN
            // NO PREVIOUS DETECTED!
         ENDIF

         AEVAL( _OOHG_aFormObjects, { |o| if( ! o:lInternal .AND. o:hWnd != ::hWnd .AND. IsWindowEnabled( o:hWnd ), ( AADD( ::LockedForms, o ), DisableWindow( o:hWnd ) ) , ) } )

         IF Len( _OOHG_ActiveModal ) == 0  .OR. aTail( _OOHG_ActiveModal ):hWnd != ::hWnd
            AADD( _OOHG_ActiveModal, Self )
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

   RETURN ::Super:Activate( lNoStop, oWndLoop )

METHOD Release() CLASS TFormModal

   IF ! ::lReleasing
      IF ( Len( _OOHG_ActiveModal ) == 0 .OR. ATAIL( _OOHG_ActiveModal ):hWnd <> ::hWnd ) .AND. IsWindowVisible( ::hWnd )
         MsgOOHGError( "Non top modal window *" + ::Name + "* can't be released. Program terminated." )
      ENDIF
   ENDIF

   RETURN ::Super:Release()

METHOD OnHideFocusManagement() CLASS TFormModal

   // Re-enables locked forms
   AEVAL( ::LockedForms, { |o| IF( ValidHandler( o:hWnd ), EnableWindow( o:hWnd ), ) } )
   ::LockedForms := {}

   IF ::oPrevWindow == nil
      // _OOHG_Main:SetFocus()
   ELSE
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
      minheight, maxheight, fontcolor ) CLASS TFormInternal

   LOCAL nStyle := 0, nStyleEx := 0

   nStyle += WS_GROUP
   ::SearchParent( oParent )
   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   nStyle += WS_CHILD
   nStyleEx += WS_EX_CONTROLPARENT

   ::Define2( FormName, Caption, x, y, w, h, ::Parent:hWnd, .F., .T., .T., .T., .T., ;
      .T., virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
      icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, nil, ;
      nil, nil, nil, nil, ClickProcedure, PaintProcedure, ;
      MouseMoveProcedure, MouseDragProcedure, nil, nil, nStyle, nStyleEx, ;
      0, lRtl, mdi,, clientarea, nil, RClickProcedure, MClickProcedure, DblClickProcedure, ;
      RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, nil, fontcolor )

   RETURN Self

METHOD Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
      nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
      icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
      minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
      MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
      nWindowType, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
      DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
      MoveProcedure, fontcolor ) CLASS TFormInternal

   ::Super:Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
      nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
      icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
      minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
      MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
      nWindowType, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
      DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
      MoveProcedure, fontcolor )

   ::ActivateCount[ 1 ] += 999
   aAdd( ::Parent:SplitChildList, Self )
   ::Parent:AddControl( Self )
   ::Active := .T.
   IF ::lVisible
      ShowWindow( ::hWnd )
   ENDIF

   ::ContainerhWndValue := ::hWnd

   RETURN Self

METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TFormInternal

   LOCAL uRet

   IF HB_IsNumeric( nCol )
      ::nCol := nCol
   ENDIF
   IF HB_IsNumeric( nRow )
      ::nRow := nRow
   ENDIF
   IF !HB_IsNumeric( nWidth )
      nWidth := ::nWidth
   ELSE
      ::nWidth := nWidth
   ENDIF
   IF !HB_IsNumeric( nHeight )
      nHeight := ::nHeight
   ELSE
      ::nHeight := nHeight
   ENDIF
   uRet := MoveWindow( ::hWnd, ::ContainerCol, ::ContainerRow, nWidth, nHeight, .t. )
   //CGR
   ::CheckClientsPos()
   ValidateScrolls( Self, .T. )

   RETURN uRet

METHOD Col( nCol ) CLASS TFormInternal

   IF PCOUNT() > 0
      ::SizePos( , nCol )
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
      minwidth, maxwidth, minheight, maxheight, fontcolor ) CLASS TFormSplit

   LOCAL nStyle := 0, nStyleEx := 0

   nStyle += WS_GROUP
   ::SearchParent()
   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   nStyle += WS_CHILD
   nStyleEx += WS_EX_STATICEDGE + WS_EX_TOOLWINDOW
   nStyleEx += WS_EX_CONTROLPARENT

   IF ! ::SetSplitBoxInfo()
      MsgOOHGError( "SplitChild windows can be defined only inside SplitBox. Program terminated." )
   ENDIF

   ::Define2( FormName, Title, 0, 0, w, h, ::Parent:hWnd, .F., .F., .F., .F., .F., ;
      nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
      nil, .F., gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, nil, ;
      nil, nil, nil, nil, nil, nil, ;
      nil, nil, nil, .F., nStyle, nStyleEx, ;
      1, lRtl, mdi, .F., clientarea, nil, RClickProcedure, MClickProcedure, DblClickProcedure, ;
      RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, nil, fontcolor )

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
   METHOD Release                           BLOCK { |Self| _OOHG_RemoveMdi( ::hWnd ) , ::Super:Release() }
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
      minwidth, maxwidth, minheight, maxheight, fontcolor ) CLASS TFormMDIClient

   LOCAL nStyle := 0, nStyleEx := 0, aClientRect

   nStyle += WS_GROUP
   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   ::SearchParent( oParent )

   // ventana MDI FRAME
   //      nStyle   += WS_CLIPSIBLINGS + WS_CLIPCHILDREN // + WS_THICKFRAME
   nStyle   += WS_CHILD + WS_CLIPCHILDREN

   aClientRect := { 0, 0, 0, 0 }
   GetClientRect( ::Parent:hWnd, aClientRect )
   IF ! HB_ISNUMERIC( x ) .AND. ::nCol    == 0
      x := aClientRect[ 1 ]
   ENDIF
   IF ! HB_ISNUMERIC( y ) .AND. ::nRow    == 0
      y := aClientRect[ 2 ]
   ENDIF
   IF ! HB_ISNUMERIC( w ) .AND. ::nWidth  == 0
      w := aClientRect[ 3 ] - aClientRect[ 1 ]
   ENDIF
   IF ! HB_ISNUMERIC( h ) .AND. ::nHeight == 0
      h := aClientRect[ 4 ] - aClientRect[ 2 ]
   ENDIF

   ::Define2( FormName, Caption, x, y, w, h, ::Parent:hWnd, .F., .T., .T., .T., .T., ;
      .T., virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
      icon, .F., gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, nil, ;
      nil, nil, nil, nil, ClickProcedure, PaintProcedure, ;
      MouseMoveProcedure, MouseDragProcedure, nil, .F., nStyle, nStyleEx, ;
      2, lRtl, .F.,, clientarea, nil, RClickProcedure, MClickProcedure, DblClickProcedure, ;
      RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, nil, fontcolor )

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
      minwidth, maxwidth, minheight, maxheight, MoveProcedure, fontcolor ) CLASS TFormMDIChild

   LOCAL nStyle := 0, nStyleEx := 0

   nStyle += WS_GROUP
   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   ::SearchParent( oParent )

   nStyle   += WS_CHILD
   nStyleEx += WS_EX_MDICHILD

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
      3, lRtl,,, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, DblClickProcedure, ;
      RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, MoveProcedure, fontcolor )

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
      fontcolor )

   //Local nStyle := 0, nStyleEx := 0
   LOCAL Self
   LOCAL aError := {}

   ///////////////////// Check for non-"implemented" parameters at Tform's subclasses....

   IF !HB_IsLogical( main )
      main := .F.
   ELSEIF main
      AADD( aError, "MAIN" )
   ENDIF
   IF !HB_IsLogical( splitchild )
      splitchild := .F.
   ELSEIF splitchild
      AADD( aError, "SPLITCHILD" )
   ENDIF
   IF !HB_IsLogical( child )
      child := .F.
   ELSEIF child
      AADD( aError, "CHILD" )
   ENDIF
   IF !HB_IsLogical( modal )
      modal := .F.
   ELSEIF modal
      AADD( aError, "MODAL" )
   ENDIF
   IF !HB_IsLogical( modalsize )
      modalsize := .F.
   ELSEIF modalsize
      AADD( aError, "MODALSIZE" )
   ENDIF
   IF !HB_IsLogical( mdiclient )
      mdiclient := .F.
   ELSEIF mdiclient
      AADD( aError, "MDICLIENT" )
   ENDIF
   IF !HB_IsLogical( mdichild )
      mdichild := .F.
   ELSEIF mdichild
      AADD( aError, "MDICHILD" )
   ENDIF
   IF !HB_IsLogical( internal )
      internal := .F.
   ELSEIF internal
      AADD( aError, "INTERNAL" )
   ENDIF

   IF Len( aError ) > 1
      MsgOOHGError( "Window: " + aError[ 1 ] + " and " + aError[ 2 ] + " clauses can't be used simultaneously. Program terminated." )
   ENDIF

   IF main
      Self := _OOHG_SelectSubClass( TFormMain(), subclass )
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
         fontcolor )
   ELSEIF splitchild
      Self := _OOHG_SelectSubClass( TFormSplit(), subclass )
      ::Define( FormName, w, h, break, grippertext, nocaption, caption, aRGB, ;
         fontname, fontsize, gotfocus, lostfocus, virtualheight, ;
         VirtualWidth, Focused, scrollleft, scrollright, scrollup, ;
         scrolldown, hscrollbox, vscrollbox, cursor, lRtl, mdi, clientarea, ;
         RClickProcedure, MClickProcedure, DblClickProcedure, ;
         RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
         minheight, maxheight, fontcolor )
   ELSEIF modal .OR. modalsize
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
         fontcolor )
   ELSEIF mdiclient
      Self := _OOHG_SelectSubClass( TFormMDIClient(), subclass )
      ::Define( FormName, Caption, x, y, w, h, MouseDragProcedure, ;
         ClickProcedure, MouseMoveProcedure, aRGB, PaintProcedure, ;
         icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
         VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
         hscrollbox, vscrollbox, cursor, oParent, Focused, lRtl, clientarea, ;
         RClickProcedure, MClickProcedure, DblClickProcedure, ;
         RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
         minheight, maxheight, fontcolor )
   ELSEIF mdichild
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
         maxheight, MoveProcedure, fontcolor )
   ELSEIF internal
      Self := _OOHG_SelectSubClass( TFormInternal(), subclass )
      ::Define( FormName, Caption, x, y, w, h, oParent, aRGB, fontname, fontsize, ;
         ClickProcedure, MouseDragProcedure, MouseMoveProcedure, ;
         PaintProcedure, noshow, icon, GotFocus, LostFocus, Virtualheight, ;
         VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
         hscrollbox, vscrollbox, cursor, Focused, lRtl, mdi, clientarea, ;
         RClickProcedure, MClickProcedure, DblClickProcedure, ;
         RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, ;
         maxheight, fontcolor )
   ELSE // Child and "S"
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
         maxwidth, minheight, maxheight, MoveProcedure, fontcolor )
   ENDIF

   ::NotifyIconObject:Picture := NotifyIconName
   ::NotifyIconObject:ToolTip := NotifyIconToolTip
   ::NotifyIconObject:OnClick := NotifyIconLeftClick

   ::lStretchBack := lStretchBack
   ::BackImage := cBackImage

   RETURN Self

FUNCTION _EndWindow()

   IF Len( _OOHG_ActiveForm ) > 0
      ATAIL( _OOHG_ActiveForm ):EndWindow()
   ENDIF

   RETURN NIL

FUNCTION _OOHG_FormObjects()

   RETURN aClone( _OOHG_aFormObjects )

   // Initializes C variables

PROCEDURE _OOHG_Init_C_Vars()

   TForm()
   _OOHG_Init_C_Vars_C_Side( _OOHG_aFormhWnd, _OOHG_aFormObjects )

   RETURN

PROCEDURE _KillAllKeys()

   LOCAL I, hWnd

   FOR I := 1 TO LEN( _OOHG_aFormhWnd )
      hWnd := _OOHG_aFormObjects[ I ]:hWnd
      AEVAL( _OOHG_aFormObjects[ I ]:aHotKeys, { |a| ReleaseHotKey( hWnd, a[ HOTKEY_ID ] ) } )
      AEVAL( _OOHG_aFormObjects[ I ]:aAcceleratorKeys, { |a| ReleaseHotKey( hWnd, a[ HOTKEY_ID ] ) } )
   NEXT

   RETURN

FUNCTION GetFormObject( FormName )

   LOCAL mVar

   mVar := '_' + FormName

   RETURN IF( Type( mVar ) == "O", &mVar, TForm() )

FUNCTION GetExistingFormObject( FormName )

   LOCAL mVar

   mVar := '_' + FormName
   IF ! Type( mVar ) == "O"
      MsgOOHGError( "Window " + FormName + " not defined. Program terminated." )
   ENDIF

   RETURN &mVar

FUNCTION _IsWindowActive( FormName )

   RETURN GetFormObject( FormName ):Active

FUNCTION _IsWindowDefined( FormName )

   LOCAL mVar

   mVar := '_' + FormName

   RETURN ( Type( mVar ) == "O" )

FUNCTION _ActivateWindow( aForm, lNoWait )

   LOCAL z, aForm2, oWndActive, oWnd, lModal

   aForm2 := ACLONE( aForm )

   // Validates NOWAIT flag
   IF !HB_IsLogical( lNoWait )
      lNoWait := .F.
   ENDIF
   oWndActive := IF( lNoWait .AND. HB_IsObject( _OOHG_Main ) , _OOHG_Main, GetFormObject( aForm2[ 1 ] ) )

   // Looks for MAIN window
   IF _OOHG_Main != NIL
      z := ASCAN( aForm2, { |c| GetFormObject( c ):hWnd == _OOHG_Main:hWnd } )
      IF z != 0
         AADD( aForm2, nil )
         AINS( aForm2, 1 )
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

   LOCAL i, aForm := {}, oWnd, MainName := '', MainhWnd

   // Abort if a window is already active
   IF ascan( _OOHG_aFormObjects, { |o| o:Active .AND. ! o:lInternal } ) > 0
      MsgOOHGError( "ACTIVATE WINDOW ALL: This command should be used at application startup only. Program terminated." )
   ENDIF

   // Identify Main and force AutoRelease and Visible properties
   MainhWnd := _OOHG_Main:hWnd
   FOR i := 1 To LEN( _OOHG_aFormObjects )
      oWnd := _OOHG_aFormObjects[ i ]
      IF oWnd:hWnd == MainhWnd
         oWnd:lVisible := .T.
         oWnd:AutoRelease := .T.
         MainName := oWnd:Name
      ELSEIF ! oWnd:lInternal
         aadd( aForm, oWnd:Name )
      ENDIF
   NEXT i

   IF Empty( MainName )
      MsgOOHGError( "ACTIVATE WINDOW ALL: Main window is not defined. Program terminated." )
   ENDIF

   aadd( aForm, MainName )

   _ActivateWindow( aForm )

   RETURN NIL

FUNCTION ReleaseAllWindows()

   _ReleaseWindowList( _OOHG_aFormObjects )
   dbcloseall()
   ExitProcess( _OOHG_ErrorLevel )

   RETURN NIL

FUNCTION _ReleaseWindowList( aWindows )

   LOCAL i, oWnd

   FOR i = 1 to len( aWindows )
      oWnd := aWindows[ i ]
      IF ! oWnd:lReleasing
         oWnd:lReleasing := .T.
         IF oWnd:Active
            oWnd:DoEvent( oWnd:OnRelease, "WINDOW_RELEASE" )
         ENDIF
         oWnd:lDestroyed := .T.
         oWnd:PreRelease()

         // ON RELEASE for child windows
         _ReleaseWindowList( oWnd:aChildPopUp )
         oWnd:aChildPopUp := {}
      ENDIF

      IF ! Empty( oWnd:NotifyIcon )
         oWnd:NotifyIconObject:Release()
      ENDIF

      aeval( oWnd:aHotKeys, { |a| ReleaseHotKey( oWnd:hWnd, a[ HOTKEY_ID ] ) } )
      oWnd:aHotKeys := {}
      aeval( oWnd:aAcceleratorKeys, { |a| ReleaseHotKey( oWnd:hWnd, a[ HOTKEY_ID ] ) } )
      oWnd:aAcceleratorKeys := {}

   NEXT i

   RETURN NIL

FUNCTION SearchParentWindow( lInternal )

   LOCAL uParent, nPos

   uParent := nil

   IF lInternal

      IF LEN( _OOHG_ActiveForm ) > 0
         uParent := ATAIL( _OOHG_ActiveForm )
      ELSEIF len( _OOHG_ActiveFrame ) > 0
         uParent := ATAIL( _OOHG_ActiveFrame )
      ENDIF

   ELSE

      // Checks _OOHG_UserWindow
      IF _OOHG_UserWindow != NIL .AND. ValidHandler( _OOHG_UserWindow:hWnd ) .AND. ascan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
         uParent := _OOHG_UserWindow
      ELSE
         // Checks _OOHG_ActiveModal
         nPos := RASCAN( _OOHG_ActiveModal, { |o| ValidHandler( o:hWnd ) .AND. ascan( _OOHG_aFormhWnd, o:hWnd ) > 0 } )
         IF nPos > 0
            uParent := _OOHG_ActiveModal[ nPos ]
         ELSE
            // Checks any active window
            nPos := RASCAN( _OOHG_aFormObjects, { |o| o:Active .AND. ValidHandler( o:hWnd ) .AND. ! o:lInternal } )
            IF nPos > 0
               uParent := _OOHG_aFormObjects[ nPos ]
            ELSE
               // Checks _OOHG_ActiveForm
               nPos := RASCAN( _OOHG_ActiveForm, { |o| ValidHandler( o:hWnd ) .AND. ! o:lInternal .AND. ascan( _OOHG_aFormhWnd, o:hWnd ) > 0 } )
               IF nPos > 0
                  uParent := _OOHG_ActiveForm[ nPos ]
               ELSE
                  uParent := GetFormObjectByHandle( GetActiveWindow() )
                  IF ! ValidHandler( uParent:hWnd ) .OR. ! uParent:Active
                     IF _OOHG_Main != nil
                        uParent := _OOHG_Main
                     ELSE
                        // Not mandatory MAIN
                        // NO PARENT DETECTED!
                        uParent := nil
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF

   ENDIF

   RETURN uParent

   #ifndef __XHARBOUR__

STATIC FUNCTION RASCAN( aSource, bCode )

   LOCAL nPos

   nPos := LEN( aSource )
   DO WHILE nPos > 0 .AND. ! EVAL( bCode, aSource[ nPos ], nPos )
      nPos--
   ENDDO

   RETURN nPos
   #endif

FUNCTION GetWindowType( FormName )

   RETURN GetFormObject( FormName ):Type

FUNCTION GetFormName( FormName )

   RETURN GetFormObject( FormName ):Name

FUNCTION GetFormToolTipHandle( FormName )

   RETURN GetFormObject( FormName ):oToolTip:hWnd

FUNCTION GetFormHandle( FormName )

   RETURN GetFormObject( FormName ):hWnd

FUNCTION _ReleaseWindow( FormName )

   RETURN GetFormObject( FormName ):Release()

FUNCTION _ShowWindow( FormName )

   RETURN GetFormObject( FormName ):Show()

FUNCTION _HideWindow( FormName )

   RETURN GetFormObject( FormName ):Hide()

FUNCTION _CenterWindow ( FormName )

   RETURN GetFormObject( FormName ):Center()

FUNCTION _RestoreWindow ( FormName )

   RETURN GetFormObject( FormName ):Restore()

FUNCTION _MaximizeWindow ( FormName )

   RETURN GetFormObject( FormName ):Maximize()

FUNCTION _MinimizeWindow ( FormName )

   RETURN GetFormObject( FormName ):Minimize()

FUNCTION _SetWindowSizePos( FormName, row, col, width, height )

   RETURN GetFormObject( FormName ):SizePos( row, col, width, height )

   EXTERN GetFormObjectByHandle

#pragma BEGINDUMP

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

static PHB_SYMB _ooHG_Symbol_TForm = 0;
static PHB_ITEM _OOHG_aFormhWnd, _OOHG_aFormObjects;           // TODO: Thread safe ?

HB_FUNC( _OOHG_INIT_C_VARS_C_SIDE )
{
   _ooHG_Symbol_TForm = hb_dynsymSymbol( hb_dynsymFind( "TFORM" ) );
   _OOHG_aFormhWnd    = hb_itemNew( NULL );
   _OOHG_aFormObjects = hb_itemNew( NULL );
   hb_itemCopy( _OOHG_aFormhWnd,    hb_param( 1, HB_IT_ARRAY ) );
   hb_itemCopy( _OOHG_aFormObjects, hb_param( 2, HB_IT_ARRAY ) );
}

int _OOHG_SearchFormHandleInArray( HWND hWnd )
{
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
         if( ( LONG ) hWnd == hb_arrayGetNL( _OOHG_aFormhWnd, ulCount ) )
      #endif
      {
         ulPos = ulCount;
         ulCount = hb_arrayLen( _OOHG_aFormhWnd );
      }
   }

   return ulPos;
}

PHB_ITEM GetFormObjectByHandle( HWND hWnd )
{
   PHB_ITEM pForm;
   ULONG ulPos;

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

   return pForm;
}

HB_FUNC( GETFORMOBJECTBYHANDLE )
{
   PHB_ITEM pReturn;

   pReturn = hb_itemNew( NULL );
   hb_itemCopy( pReturn, GetFormObjectByHandle( HWNDparam( 1 ) ) );

   hb_itemReturn( pReturn );
   hb_itemRelease( pReturn );
}

LRESULT APIENTRY _OOHG_WndProc( PHB_ITEM pSelf, HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc )
{
   PHB_ITEM pResult;
   LRESULT iReturn;
   static int iCall = 0;
   static int iNest = 0;

   iNest++;
   iCall++;

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
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
      hb_vmPush( pSelf );
      hb_vmPushLong( iNest );
      hb_vmPushLong( iCall );
      hb_vmDo( 7 );
      pResult = hb_param( -1, HB_IT_NUMERIC );
   }

   // ::OverWndProc is NOT a codeblock, or it returns a non-numeric value... execute ::Events()
   if( ! pResult )
   {
      _OOHG_Send( pSelf, s_Events );
      HWNDpush( hWnd );
      hb_vmPushLong( uiMsg );
      hb_vmPushLong( wParam );
      hb_vmPushLong( lParam );
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

   iNest--;

   return iReturn;
}

LRESULT APIENTRY _OOHG_WndProcCtrl( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc )
{
   PHB_ITEM pSave, pSelf;
   LRESULT iReturn;

   pSave = hb_itemNew( NULL );
   pSelf = hb_itemNew( NULL );
   hb_itemCopy( pSave, hb_param( -1, HB_IT_ANY ) );
   hb_itemCopy( pSelf, GetControlObjectByHandle( hWnd ) );

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
   hb_itemCopy( pSelf, GetFormObjectByHandle( hWnd ) );     // See ::Events_Destroy()

   iReturn = _OOHG_WndProc( pSelf, hWnd, uiMsg, wParam, lParam, lpfnOldWndProc );

   if( uiMsg == WM_NCDESTROY )
   {
      _OOHG_Send( pSelf, s_Events_NCDestroy );
      hb_vmSend( 0 );
   }

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
   _OOHG_Send( GetFormObjectByHandle( hWnd ), s_hWndClient );
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
   HBRUSH hbrush = 0;
   int iWindowType = hb_parni( 4 );
   LONG lColor;
   BOOL bError = FALSE;

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
         WndClass.hIcon = (HICON) LoadImage( GetModuleHandle( NULL ), hb_parc( 1 ) , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE );
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

   hb_reta( 2 );
   HB_STORNL( (LONG) hbrush, -1, 1 );
   HB_STORL( (LONG) bError, -1, 2 );
}

HB_FUNC( UNREGISTERWINDOW )
{
   hb_retl( UnregisterClass( hb_parc( 1 ), GetModuleHandle( NULL ) ) );
}

HB_FUNC( INITDUMMY )
{
   CreateWindowEx( 0, "static", "", WS_CHILD, 0, 0, 0, 0,
                   HWNDparam( 1 ), ( HMENU ) 0, GetModuleHandle( NULL ), NULL );
}

HB_FUNC( INITWINDOW )
{
   HWND hwnd;
   int Style   = hb_parni( 8 );
   int ExStyle = hb_parni( 9 );

   ExStyle |= _OOHG_RTL_Status( hb_parl( 10 ) );

/*
MDICLIENT:
   + Establecer el men� con los nombres de las ventanas
    icount = GetMenuItemCount(GetMenu(hwndparent));
    ccs.hWindowMenu  = GetSubMenu(GetMenu(hwndparent), icount-2);
    ccs.idFirstChild = 0;
    hwndMDIClient = CreateWindow("mdiclient", NULL, style, 0, 0, 0, 0, hwndparent, (HMENU)0xCAC, GetModuleHandle(NULL), (LPSTR) &ccs);

MDICHILD:
   + "T�tulo" autom�tico de la ventana... rgch[]
   mcs.szClass = "MdiChildWndClass";      // window class name
   mcs.szTitle = rgch;                    // window title
   mcs.hOwner  = GetModuleHandle(NULL);   // owner
   mcs.x       = hb_parni (3);            // x position
   mcs.y       = hb_parni (4);            // y position
   mcs.cx      = hb_parni (5);            // width
   mcs.cy      = hb_parni (6);            // height
   mcs.style   = Style;                   // window style
   mcs.lParam  = 0;                       // lparam
    hwndChild = ( HWND ) SendMessage( HWNDparam( 1 ), WM_MDICREATE, 0, (LPARAM)(LPMDICREATESTRUCT) &mcs);
*/
   hwnd = CreateWindowEx( ExStyle, hb_parc( 7 ), hb_parc( 1 ), Style,
                          hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                          HWNDparam( 6 ), ( HMENU ) NULL, GetModuleHandle( NULL ), NULL );

   if( ! hwnd )
   {
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "Window %s Creation Failed! Error %i", hb_parc( 7 ), ( int ) GetLastError() );
      MessageBox( 0, cBuffError, "Error!",
                  MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );

      return;
   }

   HWNDret( hwnd );
}

HB_FUNC( INITWINDOWMDICLIENT )
{
   HWND hwnd;
   int Style   = hb_parni( 8 );
   int ExStyle = hb_parni( 9 );
   CLIENTCREATESTRUCT ccs;

   ccs.hWindowMenu = NULL;
   ccs.idFirstChild = 0;

   ExStyle |= _OOHG_RTL_Status( hb_parl( 10 ) );

/*
MDICLIENT:
   + Establecer el men� con los nombres de las ventanas
    icount = GetMenuItemCount(GetMenu(hwndparent));
    ccs.hWindowMenu  = GetSubMenu(GetMenu(hwndparent), icount-2);
    ccs.idFirstChild = 0;
    hwndMDIClient = CreateWindow("mdiclient", NULL, style, 0, 0, 0, 0, hwndparent, (HMENU)0xCAC, GetModuleHandle(NULL), (LPSTR) &ccs);

MDICHILD:
   + "T�tulo" autom�tico de la ventana... rgch[]
   mcs.szClass = "MdiChildWndClass";      // window class name
   mcs.szTitle = rgch;                    // window title
   mcs.hOwner  = GetModuleHandle(NULL);   // owner
   mcs.x       = hb_parni (3);            // x position
   mcs.y       = hb_parni (4);            // y position
   mcs.cx      = hb_parni (5);            // width
   mcs.cy      = hb_parni (6);            // height
   mcs.style   = Style;                   // window style
   mcs.lParam  = 0;                       // lparam
    hwndChild = ( HWND ) SendMessage( HWNDparam( 1 ), WM_MDICREATE, 0, (LPARAM)(LPMDICREATESTRUCT) &mcs);
*/
   hwnd = CreateWindowEx( ExStyle, "MDICLIENT", hb_parc( 1 ), Style,
                          hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ),
                          HWNDparam( 6 ), ( HMENU ) NULL, GetModuleHandle( NULL ), ( LPSTR ) &ccs );

   if( ! hwnd )
   {
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "Window %s Creation Failed! Error %i", hb_parc( 7 ), ( int ) GetLastError() );
      MessageBox( 0, cBuffError, "Error!",
                  MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );

      return;
   }

   HWNDret( hwnd );
}

HB_FUNC( GETSYSTEMMENU )
{
   HMENUret( GetSystemMenu( HWNDparam( 1 ), FALSE ) );
}

#pragma ENDDUMP

FUNCTION SetInteractiveClose( nValue )

   LOCAL nRet := _OOHG_InteractiveClose

   IF HB_IsNumeric( nValue ) .AND. nValue >= 0 .AND. nValue <= 3
      _OOHG_InteractiveClose := INT( nValue )
   ENDIF

   RETURN nRet

FUNCTION inspector( oWind )

   LOCAL oWnd, oGrd, oCombo,n
   LOCAL aControls,aControlsNames,aData,s,ooobj_data

   aControls := owind:aControls
   aControlsNames:=owind:aControlsNames

   DEFINE WINDOW __OOHG_OBJ_INSPECTOR OBJ oWnd ;
         AT 0,0 ;
         WIDTH 400 ;
         HEIGHT 300 ;
         TITLE 'Object Inspector' ;
         MODAL NOSIZE nomaximize nominimize

      @ 24,0 grid __oohg_obj_Inspector_Grid obj oGrd ;
         height 240 width 394 ;
         headers {"DATA","Values"};
         widths {150,180};
         on dblclick (selecciona(aControls[oCombo:value],aControlsNames[oCombo:value],oooBj_Data[this.cellrowindex]),carga(aControls[oCombo:value],oGrd,@ooobj_data))

      aData := {}
      n:=''

      #ifdef __XHARBOUR__
      #define ENUMINDEX hb_enumindex()
      #else
      #define ENUMINDEX n:__enumindex
      #endif

      FOR EACH n in aControlsNames
         s:=alltrim(n)
         s:=left(s,len(s)-1)
         aadd (aData,aControls[ ENUMINDEX ]:type+' >> '+s)
         aControlsNames[ ENUMINDEX ]:=S
      NEXT

      @ 0,0 combobox __OOHG_OBJ_INSPECTOR_combo obj oCombo;
         items aData value 1 width 394;
         on change carga(aControls[oCombo:value],oGrd,@ooobj_data)
      carga(aControls[1],oGrd,@ooobj_data)

   END WINDOW
   ownd:activate()

   RETURN NIL

STATIC FUNCTION carga(oooBj,oGrd,oooBj_Data)

   LOCAL aData:={},n

   oGrd:DeleteAllItems()
   #ifdef __XHARBOUR__
   try
      aData  := __objGetValueList( oooBj, .T. )
      IF len(aData)>1
         FOR n:=1 to len ( aData )
            oGrd:additem({aData[n,1],valor(aData[n,2])})
         NEXT
      END IF
   CATCH
   end
   #else
   BEGIN sequence
      aData  := __objGetValueList( oooBj,.T.)
      IF len(aData)>1
         FOR n:=1 to len ( aData )
            oGrd:additem({aData[n,1],valor(aData[n,2])})
         NEXT
      END IF
   END SEQUENCE
   #endif
   oGrd:ColumnsBetterAutoFit()
   oooBj_Data:=aData // retorna en variable por referencia

   RETURN NIL

STATIC FUNCTION valor(xValue)

   LOCAL tipo,ret

   tipo := valtype(xValue)

   // TODO: use AutoType()
   DO CASE
   CASE tipo $'CSM' ; ret := 'String "' + xValue + '"'
   CASE tipo = 'N'  ; ret := 'Numeric ' + str( xValue )
   CASE tipo = 'A'  ; ret := 'Array, len ' + alltrim( str( len( xValue ) ) )
   CASE tipo = 'L'  ; ret := 'Boolean : ' + iif( xValue, 'True', 'False' )
   CASE tipo = 'B'  ; Ret := 'Codeblock {|| ... }'
   CASE tipo = 'D'  ; ret := 'Date ' + dtoc( xValue )
   CASE tipo = 't'  ; ret := 'DateTime ' + ttoc( xValue )
   CASE tipo = 'O'  ; ret := 'Object, class ' + xValue:Classname()
   OTHERWISE        ; Ret := 'Unknow type ...'
   END CASE

   RETURN ret

STATIC FUNCTION selecciona(ooBj,name,Values)

   LOCAL oWnd, tipo ,lOk:=.f., oget

   tipo=valtype(values[2])
   IF tipo$"CNDL"
      DEFINE WINDOW _oohg_change_value obj oWnd;
            at 50,50 width 400 height 150;
            title "Change value : "+name+'=>'+Values[1];
            modal NOSIZE nomaximize nominimize

         @ 10,10 label _oohg_change_value_lbl value "New value for "+name+'=>'+Values[1] autosize

         IF tipo='C'
            @ 40,20 textbox _oohg_change_value_txt obj oGet value Values[2]
         ELSEIF tipo='N'
            @ 40,20 textbox _oohg_change_value_txt obj oGet  value Values[2] numeric
         ELSEIF tipo='D'
            @ 40,20 textbox _oohg_change_value_txt obj oGet  value Values[2] date
         ELSEIF tipo='L'
            @ 40,20 checkbox _oohg_change_value_txt obj oGet  value Values[2] caption "( Checked for true value )" autosize
         end
         @ 70,10 button _oohg_change_value_btnOK caption "Set value" action (Values[2]:=oGet:value , lOk:=.t., oWnd:release())
         @ 70,150 button _oohg_change_value_btnno caption "Cancel" cancel action oWnd:release()
      END WINDOW
      oWnd:activate()
      IF lOk
         __ObjSetValueList( ooBj , {Values} )
         ooBj:refresh()
      end
   ELSE
      msginfo('This value is not editable')
   end
   msginfo(name+' '+Values[1]+' '+valor(Values[2]))

   RETURN NIL
