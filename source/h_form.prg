/*
 * $Id: h_form.prg,v 1.56 2014-07-26 19:30:45 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Forms handling functions
 *
 * Copyright 2005-2011 Vicente Guerra <vicente@guerra.com.mx>
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

#include "oohg.ch"
#include "i_windefs.ch"
#include "hbclass.ch"





// Duplicated from h_window.prg... must be moved
#define HOTKEY_ID        1
#define HOTKEY_MOD       2
#define HOTKEY_KEY       3
#define HOTKEY_ACTION    4





STATIC _OOHG_aFormhWnd := {}, _OOHG_aFormObjects := {}
STATIC _OOHG_UserWindow := nil       // User's window
STATIC _OOHG_InteractiveClose := 1   // Interactive close
STATIC _OOHG_ActiveModal := {}       // Modal windows' stack
STATIC _OOHG_ActiveForm := {}        // Forms under creation

#pragma BEGINDUMP

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

*------------------------------------------------------------------------------*
CLASS TForm FROM TWindow
*------------------------------------------------------------------------------*
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

   DATA NotifyIconLeftClick   INIT nil
   DATA NotifyIconDblClick    INIT nil
   DATA NotifyIconRightClick  INIT nil
   DATA NotifyIconRDblClick   INIT nil
   DATA NotifyIconMidClick    INIT nil
   DATA NotifyIconMDblClick   INIT nil
   DATA NotifyMenu            INIT nil
   DATA cNotifyIconName       INIT ""
   DATA cNotifyIconToolTip    INIT ""
   DATA lTopmost              INIT .F.

   METHOD NotifyIcon          SETGET
   METHOD NotifyToolTip       SETGET
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

   METHOD FocusedControl
   METHOD SizePos
   METHOD Define
   METHOD Define2
   METHOD EndWindow
   METHOD Register
   METHOD Visible       SETGET
   METHOD Show
   METHOD Hide
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
   METHOD ToolTipWidth       SETGET
   METHOD ToolTipMultiLine   SETGET

   METHOD getWindowState()

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
   // CGR
   METHOD Inspector BLOCK {|self|Inspector(Self)}

ENDCLASS

*------------------------------------------------------------------------------*
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
*------------------------------------------------------------------------------*
Local nStyle := 0, nStyleEx := 0
Local hParent

   If HB_IsLogical( child ) .AND. child
      ::Type := "C"
      oParent := ::SearchParent( oParent )
      hParent := oParent:hWnd
   Else
      ::Type := "S"
      hParent := 0
   EndIf

   nStyle   += WS_POPUP

   ::Define2( FormName, Caption, x, y, w, h, hParent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              0, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              MoveProcedure, fontcolor )

Return Self

*------------------------------------------------------------------------------*
METHOD Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
                nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, FontName, FontSize, aRGB, cursor, ;
                icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
                minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
                MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
                nWindowType, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
                DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
                MoveProcedure, FontColor ) CLASS TForm
*------------------------------------------------------------------------------*
Local Formhandle

   If _OOHG_GlobalRTL()
      lRtl := .T.
   ElseIf !HB_IsLogical( lRtl )
      lRtl := .F.
   Endif

   ::lRtl := lRtl

   If ! valtype( FormName ) $ "CM"
      FormName := _OOHG_TempWindowName
      _OOHG_TempWindowName := ""
   Endif

   FormName := _OOHG_GetNullName( FormName )

   If _IsWindowDefined( FormName )
      MsgOOHGError( "Window: " + FormName + " already defined. Program Terminated." )
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

   If ! Valtype( aRGB ) $ 'AN'
      aRGB := -1
   Endif

   If HB_IsLogical( helpbutton ) .AND. helpbutton
      nStyleEx += WS_EX_CONTEXTHELP
   Else
      nStyle += if( !HB_IsLogical( nominimize ) .OR. ! nominimize, WS_MINIMIZEBOX, 0 ) + ;
                if( !HB_IsLogical( nomaximize ) .OR. ! nomaximize, WS_MAXIMIZEBOX, 0 )
   EndIf
   nStyle    += if( !HB_IsLogical( nosize )   .OR. ! nosize,    WS_SIZEBOX, 0 ) + ;
                if( !HB_IsLogical( nosysmenu ) .OR. ! nosysmenu, WS_SYSMENU, 0 ) + ;
                if( !HB_IsLogical( nocaption )  .OR. ! nocaption, WS_CAPTION, 0 )

   If HB_IsLogical( topmost ) .AND. topmost
     ::lTopmost := .T.
     nStyleEx += WS_EX_TOPMOST
   EndIf

   If HB_IsLogical( mdi ) .AND. mdi
      If nWindowType != 0
         *  mdichild .OR. mdiclient // .OR. splitchild
         * These windows' types can't be MDI FRAME
      EndIf
      nWindowType := 4
      nStyle   += WS_CLIPSIBLINGS + WS_CLIPCHILDREN // + WS_THICKFRAME
* propiedad si es MDI????
   Else
      mdi := .F.
   EndIf

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
   If nWindowType == 2
      Formhandle := InitWindowMDIClient( Caption, x, y, ::nWidth, ::nHeight, Parent, "MDICLIENT", nStyle, nStyleEx, lRtl )
   Else
      UnRegisterWindow( FormName )
      ::BrushHandle := RegisterWindow( icon, FormName, aRGB, nWindowType )
      Formhandle := InitWindow( Caption, x, y, ::nWidth, ::nHeight, Parent, FormName, nStyle, nStyleEx, lRtl )
   EndIf

   If Valtype( cursor ) $ "CM"
      SetWindowCursor( Formhandle , cursor )
   EndIf

   ::Register( FormHandle, FormName )
   ::oToolTip := TToolTip():Define( , Self )

   ASSIGN clientarea VALUE clientarea TYPE "L" DEFAULT .F.
   If clientarea
      ::SizePos( , , ::Width + ::nWidth - ::ClientWidth, ::Height + ::nHeight - ::ClientHeight )
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

   If ! ::lInternal .AND. ValidHandler( Parent )
      AADD( GetFormObjectByHandle( Parent ):aChildPopUp , Self )
   EndIf

   // Assigns ThisForm the currently defined window
   _PushEventInfo()
   _OOHG_ThisForm := Self
   _OOHG_ThisEventType := "WINDOW_DEFINE"
   _OOHG_ThisType      := "W"
   _OOHG_ThisControl   := NIL
   _OOHG_ThisObject    := Self

Return Self

*------------------------------------------------------------------------------*
METHOD EndWindow() CLASS TForm
*------------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
METHOD Register( hWnd, cName ) CLASS TForm
*------------------------------------------------------------------------------*
Local mVar
   ::hWnd := hWnd
   ::StartInfo( hWnd )
   ::Name := cName

   AADD( _OOHG_aFormhWnd,    hWnd )
   AADD( _OOHG_aFormObjects, Self )

   mVar := "_" + cName
   Public &mVar. := Self
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible, nFlags, nTime ) CLASS TForm
*-----------------------------------------------------------------------------*
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
         ProcessMessages()    //// ojo con esto
      ENDIF

      //CGR
      ::CheckClientsPos()

   ENDIF
Return ::lVisible

*-----------------------------------------------------------------------------*
METHOD Show( nFlags, nTime ) CLASS TForm
*-----------------------------------------------------------------------------*
   IF PCOUNT() == 0
      ::Visible := .T.
   ELSE
      ::Visible( .T., nFlags, nTime )
   ENDIF
RETURN .T.

*-----------------------------------------------------------------------------*
METHOD Hide( nFlags, nTime ) CLASS TForm
*-----------------------------------------------------------------------------*
   IF PCOUNT() == 0
      ::Visible := .F.
   ELSE
      ::Visible( .F., nFlags, nTime )
   ENDIF
RETURN .T.

*-----------------------------------------------------------------------------*
METHOD Activate( lNoStop, oWndLoop ) CLASS TForm
*-----------------------------------------------------------------------------*

   If ::Active
      MsgOOHGError( "Window: " + ::Name + " already active. Program Terminated." )
   Endif

   ASSIGN lNoStop VALUE lNoStop TYPE "L" DEFAULT .F.

   If _OOHG_ThisEventType == 'WINDOW_RELEASE' .AND. ! lNoStop
      MsgOOHGError( "ACTIVATE WINDOW: activate windows within an 'on release' window procedure is not allowed. Program Terminated." )
   Endif

   TForm_WindowStructureClosed( Self )
   // If Len( _OOHG_ActiveForm ) > 0
   //    MsgOOHGError( "ACTIVATE WINDOW: DEFINE WINDOW structure is not closed. Program Terminated." )
   // Endif

   If _OOHG_ThisEventType == 'WINDOW_GOTFOCUS'
      MsgOOHGError( "ACTIVATE WINDOW / Activate(): Not allowed in window's GOTFOCUS event procedure. Program Terminated." )
   Endif

   If _OOHG_ThisEventType == 'WINDOW_LOSTFOCUS'
      MsgOOHGError( "ACTIVATE WINDOW / Activate(): Not allowed in window's LOSTFOCUS event procedure. Program Terminated." )
   Endif

   // Checks for non-stop window
   If !HB_IsObject( oWndLoop )
      oWndLoop := IF( lNoStop .AND. HB_IsObject( _OOHG_Main ) , _OOHG_Main, Self )
   EndIf
   ::ActivateCount := oWndLoop:ActivateCount
   ::ActivateCount[ 1 ]++
   ::Active := .T.

   If ! ::oWndClient == NIL
      ::oWndClient:Events_Size()
   EndIf

   // Show window
   If ::lVisible
      _OOHG_UserWindow := Self
      ::Show()
   EndIf

   ::ProcessInitProcedure()
   // CGR
   ::ClientsPos()
   //
   ::RefreshData()

   // Starts the Message Loop
   If ! lNoStop
      ::MessageLoop()
   EndIf

Return Nil

STATIC FUNCTION TForm_WindowStructureClosed( Self )
   If ASCAN( _OOHG_ActiveForm, { |o| o:Name == ::Name .AND. o:hWnd == ::hWnd } ) > 0
      MsgOOHGError( "ACTIVATE WINDOW: DEFINE WINDOW structure for window " + ::Name + " is not closed. Program Terminated." )
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

*-----------------------------------------------------------------------------*
METHOD MessageLoop() CLASS TForm
*-----------------------------------------------------------------------------*
   IF ::ActivateCount[ 3 ] .AND. ::ActivateCount[ 1 ] > 0
      _OOHG_DoMessageLoop( ::ActivateCount )
   ENDIF
Return nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TForm
*-----------------------------------------------------------------------------*
   If ! ::lReleasing
      If ! ::Active
         MsgOOHGError( "Window: " + ::Name + " is not active. Program Terminated." )
      Endif

      _ReleaseWindowList( { Self } )

      // Release Window

      If ValidHandler( ::hWnd )
         EnableWindow( ::hWnd )
         SendMessage( ::hWnd, WM_SYSCOMMAND, SC_CLOSE, 0 )
      EndIf

      ::Events_Destroy()
   Endif
Return Nil

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TForm
*-----------------------------------------------------------------------------*
   If HB_IsBlock( ::Block )
      ::Value := _OOHG_EVAL( ::Block )
   EndIf
   AEVAL( ::aControls, { |o| If( o:Container == nil, o:RefreshData(), ) } )
Return nil

*-----------------------------------------------------------------------------*
METHOD ToolTipWidth( nWidth ) CLASS TForm
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nWidth )
      ::oToolTip:WindowWidth := nWidth
   EndIf
Return ::oToolTip:WindowWidth

*-----------------------------------------------------------------------------*
METHOD ToolTipMultiLine( lMultiLine ) CLASS TForm
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lMultiLine )
      ::oToolTip:MultiLine := lMultiLine
   EndIf
Return ::oToolTip:MultiLine

*-----------------------------------------------------------------------------*
METHOD SetActivationFocus() CLASS TForm
*-----------------------------------------------------------------------------*
Local Sp, nSplit
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
Return nil

*-----------------------------------------------------------------------------*
METHOD ProcessInitProcedure() CLASS TForm
*-----------------------------------------------------------------------------*
   if HB_IsBlock( ::OnInit )
     ///  ProcessMessages()
      ::DoEvent( ::OnInit, "WINDOW_INIT" )
   EndIf
   AEVAL( ::SplitChildList, { |o| o:ProcessInitProcedure() } )
Return nil

*-----------------------------------------------------------------------------*
METHOD NotifyIcon( IconName ) CLASS TForm
*-----------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ChangeNotifyIcon( ::hWnd, LoadTrayIcon(GETINSTANCE(), IconName ) , ::NotifyTooltip )
      ::cNotifyIconName := IconName
   ENDIF
RETURN ::cNotifyIconName

*-----------------------------------------------------------------------------*
METHOD NotifyTooltip( TooltipText ) CLASS TForm
*-----------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ChangeNotifyIcon( ::hWnd, LoadTrayIcon(GETINSTANCE(), ::NotifyIcon ) , TooltipText )
      ::cNotifyIconTooltip := TooltipText
   ENDIF
RETURN ::cNotifyIconTooltip

*------------------------------------------------------------------------------*
METHOD Title( cTitle ) CLASS TForm
*------------------------------------------------------------------------------*
Return ( ::Caption := cTitle )

*------------------------------------------------------------------------------*
METHOD Height( nHeight ) CLASS TForm
*------------------------------------------------------------------------------*
   if HB_IsNumeric( nHeight )
      ::SizePos( , , , nHeight )
   endif
Return GetWindowHeight( ::hWnd )

*------------------------------------------------------------------------------*
METHOD Width( nWidth ) CLASS TForm
*------------------------------------------------------------------------------*
   if HB_IsNumeric( nWidth )
      ::SizePos( , , nWidth )
   endif
Return GetWindowWidth( ::hWnd )

*------------------------------------------------------------------------------*
METHOD Col( nCol ) CLASS TForm
*------------------------------------------------------------------------------*
   if HB_IsNumeric( nCol )
      ::SizePos( , nCol )
   endif
Return GetWindowCol( ::hWnd )

*------------------------------------------------------------------------------*
METHOD Row( nRow ) CLASS TForm
*------------------------------------------------------------------------------*
   If HB_IsNumeric( nRow )
      ::SizePos( nRow )
   EndIf
Return GetWindowRow( ::hWnd )

*------------------------------------------------------------------------------*
METHOD VirtualWidth( nSize ) CLASS TForm
*------------------------------------------------------------------------------*
   If HB_IsNumeric( nSize )
      ::nVirtualWidth := nSize
      ValidateScrolls( Self, .T. )
   EndIf
Return ::nVirtualWidth

*------------------------------------------------------------------------------*
METHOD VirtualHeight( nSize ) CLASS TForm
*------------------------------------------------------------------------------*
   If HB_IsNumeric( nSize )
      ::nVirtualHeight := nSize
      ValidateScrolls( Self, .T. )
   EndIf
Return ::nVirtualHeight

*------------------------------------------------------------------------------*
METHOD FocusedControl() CLASS TForm
*------------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
METHOD Cursor( uValue ) CLASS TForm
*------------------------------------------------------------------------------*
   IF uValue != nil
      SetWindowCursor( ::hWnd, uValue )
   ENDIF
Return nil

*------------------------------------------------------------------------------*
METHOD AutoAdjust( nDivH, nDivW ) CLASS TForm
*------------------------------------------------------------------------------*
LOCAL lSwvisible

   lSwvisible := ::Visible
   If lSwvisible
      ::Hide()
   EndIf

   AEVAL( ::aControls, { |o| If( o:Container == nil, o:AdjustResize( nDivH, nDivW ), ) } )

   IF lSwvisible
      ::Show()
   ENDIF

RETURN nil

*------------------------------------------------------------------------------*
METHOD AdjustWindowSize( lSkip ) CLASS TForm
*------------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
METHOD ClientsPos() CLASS TForm
*------------------------------------------------------------------------------*
Local aControls, nWidth, nHeight
   aControls := {}
   AEVAL( ::aControls, { |o| IF( o:Container == nil, AADD( aControls, o ), ) } )
   nWidth  := ::ClientWidth
   nHeight := ::ClientHeight
Return ::ClientsPos2( aControls, nWidth, nHeight )


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
         oSelf->BrushHandle = 0;
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


 *----------------------------------
Method GetWindowstate( ) CLASS Tform
*----------------------------------
  If IsWindowmaximized( ::Hwnd )
     Return 2
  elseif IsWindowminimized( ::Hwnd )
     Return 1
  else
     Return 0
  EndIf
Return nil

*------------------------------------------------------------------------------*
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TForm
*------------------------------------------------------------------------------*
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
   xRet := MoveWindow( ::hWnd , nCol , nRow , nWidth , nHeight , .t. )
   //CGR
   ::CheckClientsPos()
Return xRet

*-----------------------------------------------------------------------------*
METHOD DeleteControl( oControl ) CLASS TForm
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
METHOD OnHideFocusManagement() CLASS TForm
*-----------------------------------------------------------------------------*
Return nil

*-----------------------------------------------------------------------------*
METHOD CheckInteractiveClose() CLASS TForm
*-----------------------------------------------------------------------------*
Local lRet := .T.
   Do Case
      Case _OOHG_InteractiveClose == 0
         MsgStop( _OOHG_Messages( 1, 3 ) )
         lRet := .F.
      Case _OOHG_InteractiveClose == 2
         lRet := MsgYesNo( _OOHG_Messages( 1, 1 ), _OOHG_Messages( 1, 2 ) )
   EndCase
Return lRet

*-----------------------------------------------------------------------------*
METHOD DoEvent( bBlock, cEventType, aParams ) CLASS TForm
*-----------------------------------------------------------------------------*
Local lRetVal := .F.
   If ::lDestroyed
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

*-----------------------------------------------------------------------------*
METHOD Events_Destroy() CLASS TForm
*-----------------------------------------------------------------------------*
Local mVar

   ::ReleaseAttached()

   // Any data must be destroyed... regardless FORM is active or not.

   // Delete Notify icon
   ShowNotifyIcon( ::hWnd, .F. , 0, "" )
   If ::NotifyMenu != nil
      ::NotifyMenu:Release()
   EndIf

   If ::oMenu != NIL
      ::oMenu:Release()
      ::oMenu := nil
   EndIf

   // Update Form Index Variable
   If ! Empty( ::Name )
      mVar := '_' + ::Name
      if type( mVar ) != 'U'
         __MVPUT( mVar , 0 )
      EndIf
   EndIf

   // Removes from container
   If ::Container != NIL
      ::Container:DeleteControl( Self )
   EndIf

   // Removes from parent
   If ::Parent != NIL
      ::Parent:DeleteControl( Self )
   EndIf

   // Verify if window was multi-activated
   If ::Active
      ::ActivateCount[ 1 ]--
      If ::ActivateCount[ 1 ] < 1
         _MessageLoopEnd( ::ActivateCount[ 2 ] )
         ::ActivateCount[ 2 ] := NIL
         ::ActivateCount[ 3 ] := .F.
      Endif
   Endif

/*
   We can´t remove hWnd from the arrays at this point
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

Return nil

*-----------------------------------------------------------------------------*
METHOD Events_NCDestroy CLASS TForm
*-----------------------------------------------------------------------------*
Local i
   /*
    * UnRegisterWindow( ::Name )
    *
    * This doen't works because a class cant be
    * unregistered if a window of that class exists.
    * To avoid problems we must unregister in
    * ::Define before defining again.
    * Windows automatically unregisteres all
    * remaining classes at the end of the application.
    */

   i := aScan( _OOHG_aFormhWnd, ::hWnd )
   If i > 0
      _OOHG_DeleteArrayItem( _OOHG_aFormhWnd, i )
      _OOHG_DeleteArrayItem( _OOHG_aFormObjects, i )
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD Events_VScroll( wParam ) CLASS TForm
*-----------------------------------------------------------------------------*
Local uRet
   uRet := ::VScrollBar:Events_VScroll( wParam )
   ::RowMargin := - ::VScrollBar:Value
   ::ScrollControls()
Return uRet

*-----------------------------------------------------------------------------*
METHOD Events_HScroll( wParam ) CLASS TForm
*-----------------------------------------------------------------------------*
Local uRet
   uRet := ::HScrollBar:Events_HScroll( wParam )
   ::ColMargin := - ::HScrollBar:Value
   ::ScrollControls()
Return uRet

*-----------------------------------------------------------------------------*
METHOD ScrollControls() CLASS TForm
*-----------------------------------------------------------------------------*
   AEVAL( ::aControls, { |o| If( o:Container == nil, o:SizePos(), ) } )
   ReDrawWindow( ::hWnd )
RETURN Self

*-----------------------------------------------------------------------------*
METHOD Topmost( lTopmost ) CLASS TForm
*-----------------------------------------------------------------------------*
   If HB_IsLogical( lTopmost )
      ::lTopmost := lTopmost
      SetFormTopmost( ::hWnd, lTopmost )
   EndIf
Return ::lTopmost

*-----------------------------------------------------------------------------*
METHOD HelpButton( lShow ) CLASS TForm
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
METHOD BackImage( uBackImage ) CLASS TForm
*-----------------------------------------------------------------------------*
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
            hImageWork := _OOHG_ScaleImage( Self, ::hBackImage, ::ClientWidth, ::ClientHeight )
         Else
            hImageWork := _OOHG_CopyBitmap( ::hBackImage, 0, 0, LR_CREATEDIBSECTION )
         Endif
         ::BackBitmap := hImageWork
         DeleteObject( hImageWork )
      EndIf

      ReDrawWindow( ::hWnd )
   EndIf
Return ::hBackImage


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

*-----------------------------------------------------------------------------*
FUNCTION _OOHG_TForm_Events2( Self, hWnd, nMsg, wParam, lParam ) // CLASS TForm
*-----------------------------------------------------------------------------*
Local i, NextControlHandle, xRetVal
Local oCtrl, lMinim, nOffset,nDesp

   Do Case

   ***********************************************************************
   case nMsg == WM_HOTKEY
   ***********************************************************************

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

   ***********************************************************************
   case nMsg == WM_ACTIVATE
   ***********************************************************************

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

   ***********************************************************************
   case nMsg == WM_SETFOCUS
   ***********************************************************************

      If ::Active .AND. ! ::lInternal
         _OOHG_UserWindow := Self
      EndIf

      aeval( ::aHotKeys, { |a| ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ) } )

      aeval( ::aHotKeys, { |a| InitHotKey( ::hWnd, a[ HOTKEY_MOD ], a[ HOTKEY_KEY ], a[ HOTKEY_ID ] ) } )

      ::DoEvent( ::OnGotFocus, "WINDOW_GOTFOCUS" )

      If ! empty( ::LastFocusedControl )
         SetFocus( ::LastFocusedControl )
      EndIf

   ***********************************************************************
   case nMsg == WM_HELP
   ***********************************************************************

      Return ::HelpTopic( lParam )

   ***********************************************************************
   case nMsg == WM_TASKBAR
   ***********************************************************************

      If wParam == ID_TASKBAR .and. lParam # WM_MOUSEMOVE

         do case
            case lParam == WM_LBUTTONDOWN
               ::DoEvent( ::NotifyIconLeftClick, "WINDOW_NOTIFYLEFTCLICK" )

            case lParam == WM_RBUTTONDOWN .OR. lParam == WM_CONTEXTMENU
               If _OOHG_ShowContextMenus()
                  If ::NotifyMenu != nil
                     ::NotifyMenu:Activate()
                  Endif
               EndIf

            case lParam == WM_LBUTTONDBLCLK
               ::DoEvent( ::NotifyIconDblClick, "WINDOW_NOTIFYDBLCLICK" )

            case lParam == WM_RBUTTONDBLCLK
               ::DoEvent( ::NotifyIconRDblClick, "WINDOW_NOTIFYRDBLCLICK" )

            case lParam == WM_MBUTTONDOWN
               ::DoEvent( ::NotifyIconMidClick, "WINDOW_NOTIFYMIDCLICK" )

            case lParam == WM_MBUTTONDBLCLK
               ::DoEvent( ::NotifyIconMDblClick, "WINDOW_NOTIFYMDBLCLICK" )

         endcase
      EndIf

   ***********************************************************************
   case nMsg == WM_NEXTDLGCTL
   ***********************************************************************

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

   ***********************************************************************
   case nMsg == WM_PAINT
   ***********************************************************************

      ::DefWindowProc( nMsg, wParam, lParam )

      AEVAL( ::SplitChildList, { |o| AEVAL( o:GraphTasks, { |b| _OOHG_EVAL( b ) } ), _OOHG_EVAL( o:GraphCommand, o:hWnd, o:GraphData ) } )

      AEVAL( ::GraphTasks, { |b| _OOHG_EVAL( b ) } )
      _OOHG_EVAL( ::GraphCommand, ::hWnd, ::GraphData )

      ::DoEvent( ::OnPaint, "WINDOW_PAINT" )
	  //CGR
	  if ::nBorders[1]+::nBorders[2]+::nBorders[3] > 0
		//msginfo('borde')
		//dibujo el borde externo
		::GetDc() // Captura el canvas
		// nOffset := int((::nBorders[1]+1)/2)
		::Fill(0,0,::nBorders[1],::ClientWidth,::abecolors[1])
		::Fill(0,::ClientWidth,::Clientheight-::nBorders[1],::Clientwidth-::nBorders[1],::abecolors[2])
		::Fill(::ClientHeight,::clientwidth,::clientheight-::nBorders[1],0,::abecolors[3])
		::Fill(0,0,::ClientHeight,::nBorders[1],::abecolors[4])
		//dibujo el borde interno
		nOffSet:=::nBorders[1]+::nBorders[2]
		nDesp:=::nBorders[1]+::nBorders[2]+::nBorders[3]
		::Fill(nOffset,nOffset,nDesp,::ClientWidth-nOffset,::abicolors[1])
		::Fill(nOffSet,::ClientWidth-nOffSet,::Clientheight-nOffset,::Clientwidth-nDesp,::abicolors[2])
		::Fill(::ClientHeight-nOffSet,::clientwidth-nOffSet,::clientheight-nDesp,noffset,::abicolors[3])
		::Fill(nOffSet,nOffSet,::ClientHeight-nDesp,nDesp,::abicolors[4])
		::ReleaseDc() // libera el canvas
	  EndIf


      Return 1

   ***********************************************************************
   case nMsg == WM_ENTERSIZEMOVE
   ***********************************************************************

      If ! ! _OOHG_AutoAdjust .OR. ! ::lAdjust
         ::lEnterSizeMove := .T.
      EndIf

   ***********************************************************************
   case nMsg == WM_MOVE
   ***********************************************************************

      ::DoEvent( ::OnMove, "WINDOW_MOVE" )

   ***********************************************************************
   case nMsg == WM_SIZE
   ***********************************************************************

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

   ***********************************************************************
   case nMsg == WM_EXITSIZEMOVE    //// cuando se cambia el tamaño por reajuste con el mouse
   ***********************************************************************

      If ::Active .AND. ( ! _OOHG_AutoAdjust .OR. ! ::lAdjust .OR. ( ::nOldW # NIL .OR. ::nOldH # NIL ) .AND. ( ::nOldW # ::Width .OR. ::nOldH # ::Height ) )
         ::AdjustWindowSize()
         ::DoEvent( ::OnSize, "WINDOW_SIZE" )
      Endif
      ::lEnterSizeMove := .F.

   ***********************************************************************
   case nMsg == WM_SIZING
   ***********************************************************************

      If _TForm_Sizing( wParam, lParam, ::MinWidth, ::MaxWidth, ::MinHeight, ::MaxHeight )
         ::DefWindowProc( nMsg, wParam, lParam )
         Return 1
      EndIf

   ***********************************************************************
   case nMsg == WM_MOVING
   ***********************************************************************

      If _TForm_Moving( lParam, ::ForceRow, ::ForceCol )
         ::DefWindowProc( nMsg, wParam, lParam )
         Return 1
      EndIf

   ***********************************************************************
   case nMsg == WM_CLOSE
   ***********************************************************************

      NOTE : Since ::lReleasing could be changed on each process, it must be validated any time

      // Process Interactive Close Event / Setting
      If ! ::lReleasing .AND. HB_IsBlock( ::OnInteractiveClose )
         xRetVal := ::DoEvent( ::OnInteractiveClose, "WINDOW_ONINTERACTIVECLOSE" )
         If HB_IsLogical( xRetVal ) .AND. ! xRetVal
            Return 1
         EndIf
      EndIf

      If ! ::lReleasing .AND. ! ::CheckInteractiveClose()
         Return 1
      EndIf

      // Process AutoRelease Property
      If ! ::lReleasing .AND. ! ::AutoRelease
         ::Hide()
         Return 1
      EndIf

      // If Not AutoRelease Destroy Window

      _ReleaseWindowList( { Self } )

      If ::Type == "A"
         // Main window
         ReleaseAllWindows()
      Else
         ::OnHideFocusManagement()
      EndIf

      /*
       * This function must return NIL after processing WM_CLOSE so the
       * OS can do it's default processing. This processing ends with
       * (a) the posting of a WM_DESTROY message to the queue (will be
       * processed by this same function), immediately followed by
       * (b) the sending of a WM_NCDESTROY message to the form's
       * WindowProc (redirected to _OOHG_WndProcForm()).
       */

   ***********************************************************************
   case nMsg == WM_DESTROY
   ***********************************************************************

      ::Events_Destroy()

   ***********************************************************************
   otherwise
   ***********************************************************************

      // return ::Super:Events( hWnd, nMsg, wParam, lParam )
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
#pragma endDUMP

*-----------------------------------------------------------------------------*
Procedure ValidateScrolls( Self, lMove )
*-----------------------------------------------------------------------------*
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





*-----------------------------------------------------------------------------*
CLASS TFormMain FROM TForm
*-----------------------------------------------------------------------------*
   DATA Type           INIT "A" READONLY
   DATA lFirstActivate INIT .F.

   METHOD Define
   METHOD Activate
   METHOD Release

   METHOD CheckInteractiveClose
ENDCLASS

*-----------------------------------------------------------------------------*
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
*-----------------------------------------------------------------------------*
Local nStyle := 0, nStyleEx := 0

   If _OOHG_Main != nil
      MsgOOHGError( "Main Window Already Defined. Program Terminated." )
   Endif

   _OOHG_Main := Self
   nStyle += WS_POPUP

   ::Define2( FormName, Caption, x, y, w, h, 0, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, nil, nStyle, nStyleEx, ;
              0, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              MoveProcedure, fontcolor )

   if ! valtype( NotifyIconName ) $ "CM"
      NotifyIconName := ""
   Else
      ShowNotifyIcon( ::hWnd, .T. , LoadTrayIcon(GETINSTANCE(), NotifyIconName ), NotifyIconTooltip )
      ::NotifyIcon := NotifyIconName
      ::NotifyToolTip := NotifyIconToolTip
      ::NotifyIconLeftClick := NotifyIconLeftClick
   endif

Return Self

*-----------------------------------------------------------------------------*
METHOD Activate( lNoStop, oWndLoop ) CLASS TFormMain
*-----------------------------------------------------------------------------*
   ::lFirstActivate := .T.
Return ::Super:Activate( lNoStop, oWndLoop )

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TFormMain
*-----------------------------------------------------------------------------*
   _ReleaseWindowList( { Self } )
   ReleaseAllWindows()
Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD CheckInteractiveClose() CLASS TFormMain
*-----------------------------------------------------------------------------*
Local lRet
   If _OOHG_InteractiveClose == 3
      lRet := MsgYesNo( _OOHG_Messages( 1, 1 ), _OOHG_Messages( 1, 2 ) )
   Else
      lRet := ::Super:CheckInteractiveClose()
   EndIf
Return lRet




*-----------------------------------------------------------------------------*
CLASS TFormModal FROM TForm
*-----------------------------------------------------------------------------*
   DATA Type           INIT "M" READONLY
   DATA LockedForms    INIT {}
   DATA oPrevWindow    INIT nil

   METHOD Define
   METHOD Visible      SETGET
   METHOD Activate
   METHOD Release
   METHOD OnHideFocusManagement
ENDCLASS

*-----------------------------------------------------------------------------*
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
*-----------------------------------------------------------------------------*
Local nStyle := WS_POPUP, nStyleEx := 0
Local oParent, hParent

   Empty( modalsize )

   oParent := ::SearchParent( Parent )
   If HB_IsObject( oParent )
      hParent := oParent:hWnd
   ELSE
      hParent := 0
      * Must have a parent!!!!!
   EndIf

   ::oPrevWindow := oParent

   ::Define2( FormName, Caption, x, y, w, h, hParent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              0, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
              DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
              MoveProcedure, fontcolor )

Return Self

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TFormModal
*-----------------------------------------------------------------------------*
   IF HB_IsLogical( lVisible )
      IF lVisible
         // Find Previous window
         If     aScan( _OOHG_aFormhWnd, GetActiveWindow() ) > 0
            ::oPrevWindow := GetFormObjectByHandle( GetActiveWindow() )
         ElseIf _OOHG_UserWindow != NIL .AND. ascan( _OOHG_aFormhWnd, _OOHG_UserWindow:hWnd ) > 0
            ::oPrevWindow := _OOHG_UserWindow
         ElseIf Len( _OOHG_ActiveModal ) != 0 .AND. ascan( _OOHG_aFormhWnd, ATAIL( _OOHG_ActiveModal ):hWnd ) > 0
            ::oPrevWindow := ATAIL( _OOHG_ActiveModal )
         ElseIf ::Parent != NIL .AND. ascan( _OOHG_aFormhWnd, ::Parent:hWnd ) > 0
            ::oPrevWindow := _OOHG_UserWindow
         ElseIf _OOHG_Main != nil
            ::oPrevWindow := _OOHG_Main
         Else
            ::oPrevWindow := NIL
            // Not mandatory MAIN
            // NO PREVIOUS DETECTED!
         EndIf

         AEVAL( _OOHG_aFormObjects, { |o| if( ! o:lInternal .AND. o:hWnd != ::hWnd .AND. IsWindowEnabled( o:hWnd ), ( AADD( ::LockedForms, o ), DisableWindow( o:hWnd ) ) , ) } )

         If Len( _OOHG_ActiveModal ) == 0  .OR. aTail( _OOHG_ActiveModal ):hWnd != ::hWnd
           AADD( _OOHG_ActiveModal, Self )
         EndIf
         EnableWindow( ::hWnd )
      ENDIF
   ENDIF
RETURN ( ::Super:Visible := lVisible )

*-----------------------------------------------------------------------------*
METHOD Activate( lNoStop, oWndLoop ) CLASS TFormModal
*-----------------------------------------------------------------------------*
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

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TFormModal
*-----------------------------------------------------------------------------*
   If ! ::lReleasing
      If ( Len( _OOHG_ActiveModal ) == 0 .OR. ATAIL( _OOHG_ActiveModal ):hWnd <> ::hWnd ) .AND. IsWindowVisible( ::hWnd )
         MsgOOHGError( "Non top modal window *" + ::Name + "* can't be released. Program Terminated." )
      EndIf
	EndIf
Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD OnHideFocusManagement() CLASS TFormModal
*-----------------------------------------------------------------------------*
   // Re-enables locked forms
   AEVAL( ::LockedForms, { |o| IF( ValidHandler( o:hWnd ), EnableWindow( o:hWnd ), ) } )
   ::LockedForms := {}

   If ::oPrevWindow == nil
      // _OOHG_Main:SetFocus()
	Else
      ::oPrevWindow:SetFocus()
	EndIf
Return ::Super:OnHideFocusManagement()




*-----------------------------------------------------------------------------*
CLASS TFormInternal FROM TForm
*-----------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
METHOD Define( FormName, Caption, x, y, w, h, oParent, aRGB, fontname, fontsize, ;
               ClickProcedure, MouseDragProcedure, MouseMoveProcedure, ;
               PaintProcedure, noshow, icon, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, cursor, Focused, lRtl, mdi, clientarea, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
               minheight, maxheight, fontcolor ) CLASS TFormInternal
*------------------------------------------------------------------------------*
Local nStyle := 0, nStyleEx := 0

   nStyle += WS_GROUP
   ::SearchParent( oParent )
   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   nStyle += WS_CHILD
   If _OOHG_SetControlParent()
      // This is not working when there's a RADIO control :(
      nStyleEx += WS_EX_CONTROLPARENT
   EndIf

   ::Define2( FormName, Caption, x, y, w, h, ::Parent:hWnd, .F., .T., .T., .T., .T., ;
              .T., virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, nil, ;
              nil, nil, nil, nil, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, nil, nil, nStyle, nStyleEx, ;
              0, lRtl, mdi,, clientarea, nil, RClickProcedure, MClickProcedure, DblClickProcedure, ;
              RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, nil, fontcolor )

Return Self

*------------------------------------------------------------------------------*
METHOD Define2( FormName, Caption, x, y, w, h, Parent, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
                nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
                icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
                minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
                MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
                nWindowType, lRtl, mdi, topmost, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, ;
                DblClickProcedure, RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, ;
                MoveProcedure, fontcolor ) CLASS TFormInternal
*------------------------------------------------------------------------------*

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
   If ::lVisible
      ShowWindow( ::hWnd )
   EndIf

   ::ContainerhWndValue := ::hWnd

Return Self

*------------------------------------------------------------------------------*
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TFormInternal
*------------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
METHOD Col( nCol ) CLASS TFormInternal
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ::SizePos( , nCol )
   ENDIF
RETURN ::nCol

*------------------------------------------------------------------------------*
METHOD Row( nRow ) CLASS TFormInternal
*------------------------------------------------------------------------------*
   IF PCOUNT() > 0
      ::SizePos( nRow )
   ENDIF
RETURN ::nRow





*-----------------------------------------------------------------------------*
CLASS TFormSplit FROM TFormInternal
*-----------------------------------------------------------------------------*
   DATA Type           INIT "X" READONLY

   METHOD Define
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( FormName, w, h, break, grippertext, nocaption, title, aRGB, ;
               fontname, fontsize, gotfocus, lostfocus, virtualheight, ;
               VirtualWidth, Focused, scrollleft, scrollright, scrollup, ;
               scrolldown, hscrollbox, vscrollbox, cursor, lRtl, mdi, ;
               clientarea, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, ;
               minwidth, maxwidth, minheight, maxheight, fontcolor ) CLASS TFormSplit
*-----------------------------------------------------------------------------*
Local nStyle := 0, nStyleEx := 0

   nStyle += WS_GROUP
   ::SearchParent()
   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   nStyle += WS_CHILD
   nStyleEx += WS_EX_STATICEDGE + WS_EX_TOOLWINDOW
   If _OOHG_SetControlParent()
      // This is not working when there's a RADIO control :(
      nStyleEx += WS_EX_CONTROLPARENT
   EndIf

   If ! ::SetSplitBoxInfo()
      MsgOOHGError( "SplitChild Windows Can be Defined Only Inside SplitBox. Program Terminated." )
   EndIf

   ::Define2( FormName, Title, 0, 0, w, h, ::Parent:hWnd, .F., .F., .F., .F., .F., ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              nil, .F., gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, nil, ;
              nil, nil, nil, nil, nil, nil, ;
              nil, nil, nil, .F., nStyle, nStyleEx, ;
              1, lRtl, mdi, .F., clientarea, nil, RClickProcedure, MClickProcedure, DblClickProcedure, ;
              RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, nil, fontcolor )

   If ::Container:lForceBreak .AND. ! ::Container:lInverted
      Break := .T.
   EndIf
   ::SetSplitBoxInfo( Break, GripperText )
   ::Container:AddControl( Self )

Return Self

*-----------------------------------------------------------------------------*
CLASS TFormMDIClient FROM TFormInternal
*-----------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
METHOD Define( FormName, Caption, x, y, w, h, MouseDragProcedure, ;
               ClickProcedure, MouseMoveProcedure, aRGB, PaintProcedure, ;
               icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, cursor, oParent, Focused, lRtl, ;
               clientarea, RClickProcedure, MClickProcedure, ;
               DblClickProcedure, RDblClickProcedure, MDblClickProcedure, ;
               minwidth, maxwidth, minheight, maxheight, fontcolor ) CLASS TFormMDIClient
*------------------------------------------------------------------------------*
Local nStyle := 0, nStyleEx := 0, aClientRect

   nStyle += WS_GROUP
   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   ::SearchParent( oParent )

* ventana MDI FRAME
*      nStyle   += WS_CLIPSIBLINGS + WS_CLIPCHILDREN // + WS_THICKFRAME
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
Return Self

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





*-----------------------------------------------------------------------------*
CLASS TFormMDIChild FROM TFormInternal
*-----------------------------------------------------------------------------*
   DATA Type           INIT "L" READONLY

   METHOD Define
   METHOD DefWindowProc(nMsg,wParam,lParam) BLOCK { |Self,nMsg,wParam,lParam| DefMDIChildProc( ::hWnd, nMsg, wParam, lParam ) }
   METHOD IsActive                          BLOCK { |Self| ::Parent:ActiveChild:hWnd == ::hWnd }
ENDCLASS

*------------------------------------------------------------------------------*
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
*------------------------------------------------------------------------------*
Local nStyle := 0, nStyleEx := 0

   nStyle += WS_GROUP
   ::Focused := ( HB_IsLogical( Focused ) .AND. Focused )
   ::SearchParent( oParent )

   nStyle   += WS_CHILD
   nStyleEx += WS_EX_MDICHILD

   // If MDIclient window doesn't exists, create it.
   If ::Parent:oWndClient == NIL
      oParent := TFormMDIClient():Define( ,,,,,,,,,,,,,,,,,,,,,,,,, ::Parent )
      oParent:EndWindow()
   Else
      oParent := ::Parent:oWndClient
   EndIf
   ::SearchParent( oParent )

   ::Define2( FormName, Caption, x, y, w, h, ::Parent:hWnd, helpbutton, nominimize, nomaximize, nosize, nosysmenu, ;
              nocaption, virtualheight, virtualwidth, hscrollbox, vscrollbox, fontname, fontsize, aRGB, cursor, ;
              icon, noshow, gotfocus, lostfocus, scrollleft, scrollright, scrollup, scrolldown, maximizeprocedure, ;
              minimizeprocedure, initprocedure, ReleaseProcedure, SizeProcedure, ClickProcedure, PaintProcedure, ;
              MouseMoveProcedure, MouseDragProcedure, InteractiveCloseProcedure, NoAutoRelease, nStyle, nStyleEx, ;
              3, lRtl,,, clientarea, restoreprocedure, RClickProcedure, MClickProcedure, DblClickProcedure, ;
              RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, maxheight, MoveProcedure, fontcolor )

   ::ProcessInitProcedure()
Return Self





*------------------------------------------------------------------------------*
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
*------------------------------------------------------------------------------*
//Local nStyle := 0, nStyleEx := 0
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
      MsgOOHGError( "Window: " + aError[ 1 ] + " and " + aError[ 2 ] + " clauses can't be used Simultaneously. Program Terminated." )
   endif

   If main
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
   ElseIf splitchild
      Self := _OOHG_SelectSubClass( TFormSplit(), subclass )
      ::Define( FormName, w, h, break, grippertext, nocaption, caption, aRGB, ;
               fontname, fontsize, gotfocus, lostfocus, virtualheight, ;
               VirtualWidth, Focused, scrollleft, scrollright, scrollup, ;
               scrolldown, hscrollbox, vscrollbox, cursor, lRtl, mdi, clientarea, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
               minheight, maxheight, fontcolor )
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
               fontcolor )
   ElseIf mdiclient
      Self := _OOHG_SelectSubClass( TFormMDIClient(), subclass )
      ::Define( FormName, Caption, x, y, w, h, MouseDragProcedure, ;
               ClickProcedure, MouseMoveProcedure, aRGB, PaintProcedure, ;
               icon, fontname, fontsize, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, cursor, oParent, Focused, lRtl, clientarea, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, ;
               minheight, maxheight, fontcolor )
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
               maxheight, MoveProcedure, fontcolor )
   ElseIf internal
      Self := _OOHG_SelectSubClass( TFormInternal(), subclass )
      ::Define( FormName, Caption, x, y, w, h, oParent, aRGB, fontname, fontsize, ;
               ClickProcedure, MouseDragProcedure, MouseMoveProcedure, ;
               PaintProcedure, noshow, icon, GotFocus, LostFocus, Virtualheight, ;
               VirtualWidth, scrollleft, scrollright, scrollup, scrolldown, ;
               hscrollbox, vscrollbox, cursor, Focused, lRtl, mdi, clientarea, ;
               RClickProcedure, MClickProcedure, DblClickProcedure, ;
               RDblClickProcedure, MDblClickProcedure, minwidth, maxwidth, minheight, ;
               maxheight, fontcolor )
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
               maxwidth, minheight, maxheight, MoveProcedure, fontcolor )
   EndIf

   if ! valtype( NotifyIconName ) $ "CM"
      NotifyIconName := ""
   Else
      ShowNotifyIcon( ::hWnd, .T. , LoadTrayIcon(GETINSTANCE(), NotifyIconName ), NotifyIconTooltip )
      ::NotifyIcon := NotifyIconName
      ::NotifyToolTip := NotifyIconToolTip
      ::NotifyIconLeftClick := NotifyIconLeftClick
   endif

   ::lStretchBack := lStretchBack
   ::BackImage := cBackImage

Return Self

*-----------------------------------------------------------------------------*
Function _EndWindow()
*-----------------------------------------------------------------------------*
   If Len( _OOHG_ActiveForm ) > 0
      ATAIL( _OOHG_ActiveForm ):EndWindow()
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
Function _OOHG_FormObjects()
*-----------------------------------------------------------------------------*
Return aClone( _OOHG_aFormObjects )

// Initializes C variables
*-----------------------------------------------------------------------------*
Procedure _OOHG_Init_C_Vars()
*-----------------------------------------------------------------------------*
   TForm()
   _OOHG_Init_C_Vars_C_Side( _OOHG_aFormhWnd, _OOHG_aFormObjects )
Return

*-----------------------------------------------------------------------------*
Procedure _KillAllKeys()
*-----------------------------------------------------------------------------*
Local I, hWnd
   FOR I := 1 TO LEN( _OOHG_aFormhWnd )
      hWnd := _OOHG_aFormObjects[ I ]:hWnd
      AEVAL( _OOHG_aFormObjects[ I ]:aHotKeys, { |a| ReleaseHotKey( hWnd, a[ HOTKEY_ID ] ) } )
      AEVAL( _OOHG_aFormObjects[ I ]:aAcceleratorKeys, { |a| ReleaseHotKey( hWnd, a[ HOTKEY_ID ] ) } )
   NEXT
Return

*-----------------------------------------------------------------------------*
Function GetFormObject( FormName )
*-----------------------------------------------------------------------------*
Local mVar
   mVar := '_' + FormName
Return IF( Type( mVar ) == "O", &mVar, TForm() )

*-----------------------------------------------------------------------------*
Function GetExistingFormObject( FormName )
*-----------------------------------------------------------------------------*
Local mVar
   mVar := '_' + FormName
   If ! Type( mVar ) == "O"
      MsgOOHGError( "Window " + FormName + " not defined. Program Terminated." )
   EndIf
Return &mVar

*-----------------------------------------------------------------------------*
Function _IsWindowActive( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Active

*-----------------------------------------------------------------------------*
Function _IsWindowDefined( FormName )
*-----------------------------------------------------------------------------*
Local mVar
   mVar := '_' + FormName
Return ( Type( mVar ) == "O" )





*-----------------------------------------------------------------------------*
Function _ActivateWindow( aForm, lNoWait )
*-----------------------------------------------------------------------------*
Local z, aForm2, oWndActive, oWnd, lModal

   aForm2 := ACLONE( aForm )

   // Validates NOWAIT flag
   IF !HB_IsLogical( lNoWait )
      lNoWait := .F.
   ENDIF
   oWndActive := IF( lNoWait .AND. HB_IsObject( _OOHG_Main ) , _OOHG_Main, GetFormObject( aForm2[ 1 ] ) )

   // Looks for MAIN window
   If _OOHG_Main != NIL
      z := ASCAN( aForm2, { |c| GetFormObject( c ):hWnd == _OOHG_Main:hWnd } )
      IF z != 0
         AADD( aForm2, nil )
         AINS( aForm2, 1 )
         aForm2[ 1 ] := aForm2[ z + 1 ]
         _OOHG_DeleteArrayItem( aForm2, z + 1 )
         IF lNoWait
            oWndActive := GetFormObject( aForm2[ 1 ] )
         EndIf
      ENDIF
   ENDIF

   // Activate windows
   lModal := .F.
   FOR z := 1 TO Len( aForm2 )
      oWnd := GetFormObject( aForm2[ z ] )
      IF ! ValidHandler( oWnd:hWnd )
         MsgOOHGError( "ACTIVATE WINDOW: Window " + aForm2[ z ] + " not defined. Program Terminated." )
      ENDIF
      IF oWnd:Type == "M" .AND. oWnd:lVisible
         IF lModal
            MsgOOHGError( "ACTIVATE WINDOW: Only one initially visible modal window allowed. Program Terminated." )
         ENDIF
         lModal := .T.
      ENDIF
      oWnd:Activate( .T., oWndActive )
   NEXT

   If ! lNoWait
      GetFormObject( aForm2[ 1 ] ):MessageLoop()
   Endif

Return Nil

*-----------------------------------------------------------------------------*
Function _ActivateAllWindows()
*-----------------------------------------------------------------------------*
Local i
Local aForm := {}, oWnd
Local MainName := ''

   // Not mandatory MAIN
   // If _OOHG_Main == nil
   //    MsgOOHGError( "MAIN WINDOW not defined. Program Terminated." )
   // EndIf

	* If Already Active Windows Abort Command

   If ascan( _OOHG_aFormObjects, { |o| o:Active .AND. ! o:lInternal } ) > 0
      MsgOOHGError( "ACTIVATE WINDOW ALL: This Command Should Be Used At Application Startup Only. Program Terminated." )
	EndIf

// WHY???   * Force NoShow And NoAutoRelease Styles For Non Main Windows
	* ( Force AutoRelease And Visible For Main )

   For i := 1 To LEN( _OOHG_aFormObjects )
      oWnd := _OOHG_aFormObjects[ i ]
      If oWnd:hWnd == _OOHG_Main:hWnd
         oWnd:lVisible := .T.
         oWnd:AutoRelease := .T.
         MainName := oWnd:Name
      ElseIf ! oWnd:lInternal
//         oWnd:lVisible := .F.
//         oWnd:AutoRelease := .F.
         aadd( aForm , oWnd:Name )
      EndIf
	Next i

	aadd ( aForm , MainName )

	* Check For Error And Call Activate Window Command

   If Empty( MainName )
      MsgOOHGError( "ACTIVATE WINDOW ALL: Main Window Not Defined. Program Terminated." )
   ElseIf Len( aForm ) == 0
      MsgOOHGError( "ACTIVATE WINDOW ALL: No Windows Defined. Program Terminated." )
	Else
      _ActivateWindow( aForm )
	EndIf

Return Nil

*-----------------------------------------------------------------------------*
Function ReleaseAllWindows()
*-----------------------------------------------------------------------------*
   _ReleaseWindowList( _OOHG_aFormObjects )
   dbcloseall()
   ExitProcess( 0 )
Return Nil

*-----------------------------------------------------------------------------*
Function _ReleaseWindowList( aWindows )
*-----------------------------------------------------------------------------*
Local i, oWnd

   For i = 1 to len( aWindows )
      oWnd := aWindows[ i ]
      If ! oWnd:lReleasing
         oWnd:lReleasing := .T.
         If oWnd:Active
            oWnd:DoEvent( oWnd:OnRelease, "WINDOW_RELEASE" )
         EndIf
         oWnd:lDestroyed := .T.
         oWnd:PreRelease()

         // ON RELEASE for child windows
         _ReleaseWindowList( oWnd:aChildPopUp )
         oWnd:aChildPopUp := {}
      Endif

      If ! Empty( oWnd:NotifyIcon )
         oWnd:NotifyIcon := ""
         ShowNotifyIcon( oWnd:hWnd, .F., NIL, NIL )
      EndIf

      aeval( oWnd:aHotKeys, { |a| ReleaseHotKey( oWnd:hWnd, a[ HOTKEY_ID ] ) } )
      oWnd:aHotKeys := {}
      aeval( oWnd:aAcceleratorKeys, { |a| ReleaseHotKey( oWnd:hWnd, a[ HOTKEY_ID ] ) } )
      oWnd:aAcceleratorKeys := {}

   Next i

Return Nil

*-----------------------------------------------------------------------------*
Function SearchParentWindow( lInternal )
*-----------------------------------------------------------------------------*
LOCAL uParent, nPos
   uParent := nil

   If lInternal

      If LEN( _OOHG_ActiveForm ) > 0
         uParent := ATAIL( _OOHG_ActiveForm )
      ElseIf len( _OOHG_ActiveFrame ) > 0
         uParent := ATAIL( _OOHG_ActiveFrame )
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





*-----------------------------------------------------------------------------*
Function GetWindowType( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Type

*-----------------------------------------------------------------------------*
Function GetFormName( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Name

*-----------------------------------------------------------------------------*
Function GetFormToolTipHandle( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):oToolTip:hWnd

*-----------------------------------------------------------------------------*
Function GetFormHandle( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):hWnd

*-----------------------------------------------------------------------------*
Function _ReleaseWindow( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Release()

*-----------------------------------------------------------------------------*
Function _ShowWindow( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Show()

*-----------------------------------------------------------------------------*
Function _HideWindow( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Hide()

*-----------------------------------------------------------------------------*
Function _CenterWindow ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Center()

*-----------------------------------------------------------------------------*
Function _RestoreWindow ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Restore()

*-----------------------------------------------------------------------------*
Function _MaximizeWindow ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Maximize()

*-----------------------------------------------------------------------------*
Function _MinimizeWindow ( FormName )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):Minimize()

*-----------------------------------------------------------------------------*
Function _SetWindowSizePos( FormName , row , col , width , height )
*-----------------------------------------------------------------------------*
Return GetFormObject( FormName ):SizePos( row , col , width , height )

EXTERN GetFormObjectByHandle

#pragma BEGINDUMP

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

static PHB_SYMB _ooHG_Symbol_TForm = 0;
static PHB_ITEM _OOHG_aFormhWnd, _OOHG_aFormObjects;

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

   WndClass.style         = CS_DBLCLKS;
   WndClass.lpszClassName = hb_parc( 2 );

   switch( iWindowType )
   {
      case 2:                           // MDI client
         WndClass.lpfnWndProc   = WndProcMdiChild;
         // WndClass.lpszClassName = "MDICLIENT";
         break;

      case 3:                           // MDI child
         WndClass.lpfnWndProc   = WndProcMdiChild;
         break;

      case 4:                           // MDI frame
         WndClass.lpfnWndProc   = WndProcMdi;
         break;

      default:
      // case 0:                           //
      // case 1:                           // Splitchild
         WndClass.lpfnWndProc   = WndProc;
         break;
   }
   WndClass.cbClsExtra    = 0;
   WndClass.cbWndExtra    = 0;
//    WndClass.cbWndExtra    = 20;   MDICHILD!
   WndClass.hInstance     = GetModuleHandle( NULL );
   WndClass.hIcon         = 0;
   if( hb_parclen( 1 ) )
   {
      WndClass.hIcon      = LoadIcon( GetModuleHandle( NULL ), hb_parc( 1 ) );
      if( ! WndClass.hIcon )
      {
         WndClass.hIcon   = ( HICON ) LoadImage( GetModuleHandle( NULL ), hb_parc( 1 ) , IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE );
      }
   }
   if( ! WndClass.hIcon )
   {
       WndClass.hIcon     = LoadIcon( NULL, IDI_APPLICATION );
   }
   WndClass.hCursor       = LoadCursor( NULL, IDC_ARROW );

   lColor = -1;
   _OOHG_DetermineColor( hb_param( 3, HB_IT_ANY ), &lColor );
   if( lColor == -1 )
   {
      WndClass.hbrBackground = ( HBRUSH )( COLOR_BTNFACE + 1 );
   }
   else
   {
      hbrush = CreateSolidBrush( lColor );
      WndClass.hbrBackground = hbrush;
   }

   WndClass.lpszMenuName  = NULL;
   if( ! RegisterClass( &WndClass ) )
   {
      char cBuffError[ 1000 ];
      sprintf( cBuffError, "Window %s Registration Failed! Error %i", hb_parc( 2 ), ( int ) GetLastError() );
      MessageBox( 0, cBuffError, "Error!",
                  MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      ExitProcess( 0 );
   }

   HWNDret( ( HWND ) hbrush );
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
   + Establecer el menú con los nombres de las ventanas
    icount = GetMenuItemCount(GetMenu(hwndparent));
    ccs.hWindowMenu  = GetSubMenu(GetMenu(hwndparent), icount-2);
    ccs.idFirstChild = 0;
    hwndMDIClient = CreateWindow("mdiclient", NULL, style, 0, 0, 0, 0, hwndparent, (HMENU)0xCAC, GetModuleHandle(NULL), (LPSTR) &ccs);

MDICHILD:
   + "Título" automático de la ventana... rgch[]
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
   + Establecer el menú con los nombres de las ventanas
    icount = GetMenuItemCount(GetMenu(hwndparent));
    ccs.hWindowMenu  = GetSubMenu(GetMenu(hwndparent), icount-2);
    ccs.idFirstChild = 0;
    hwndMDIClient = CreateWindow("mdiclient", NULL, style, 0, 0, 0, 0, hwndparent, (HMENU)0xCAC, GetModuleHandle(NULL), (LPSTR) &ccs);

MDICHILD:
   + "Título" automático de la ventana... rgch[]
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




#pragma ENDDUMP





Function SetInteractiveClose( nValue )
Local nRet := _OOHG_InteractiveClose
   If HB_IsNumeric( nValue ) .AND. nValue >= 0 .AND. nValue <= 3
      _OOHG_InteractiveClose := INT( nValue )
   EndIf
Return nRet


//------------------- inspection
function inspector( oWind )
local oWnd, oGrd, oCombo,n
local aControls,aControlsNames,aData,s,ooobj_data

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

	for each n in aControlsNames
	    s:=alltrim(n)
		s:=left(s,len(s)-1)
                aadd (aData,aControls[ ENUMINDEX ]:type+' >> '+s)
                aControlsNames[ ENUMINDEX ]:=S
	next

	@ 0,0 combobox __OOHG_OBJ_INSPECTOR_combo obj oCombo;
		items aData value 1 width 394;
		on change carga(aControls[oCombo:value],oGrd,@ooobj_data)
	carga(aControls[1],oGrd,@ooobj_data)


	end window
	ownd:activate()
return nil


static function carga(oooBj,oGrd,oooBj_Data)
local aData:={},n
	oGrd:DeleteAllItems()
	#ifdef __XHARBOUR__
	try
    aData  := __objGetValueList( oooBj, .T. )
		if len(aData)>1
			for n:=1 to len ( aData )
				oGrd:additem({aData[n,1],valor(aData[n,2])})
			next
		end if
        catch
	end
	#else
	begin sequence
    aData  := __objGetValueList( oooBj,.T.)
		if len(aData)>1
			for n:=1 to len ( aData )
				oGrd:additem({aData[n,1],valor(aData[n,2])})
			next
		end if
	end sequence
	#endif
	oGrd:ColumnsBetterAutoFit()
	oooBj_Data:=aData // retorna en variable por referencia
return nil

static function valor(xValue)
local tipo,ret

tipo := valtype(xValue)

	do case
		case tipo$'CSM'
			ret:='String "'+xValue+'"'
		case tipo='N'
			ret:='Numeric '+str(xValue)
		case tipo='A'
			ret:='Array, len '+alltrim(str(len(xValue)))
		case tipo='L'
			ret:='Boolean : '+if(xValue,'True','False')
		case tipo='B'
			Ret:='Codeblock {|| ... }'
		case tipo='D'
			ret:='Date '+dtoc(xValue)
      case tipo='t'
         ret:='DateTime '+ttoc(xValue)
		case tipo='O'
			ret:='Object, class '+xValue:Classname()
		otherwise
			Ret:='Unknow type ...'
	end case
return ret

static function selecciona(ooBj,name,Values)
	local oWnd, tipo ,lOk:=.f., oget

	tipo=valtype(values[2])
	if tipo$"CNDL"
		Define window _oohg_change_value obj oWnd;
			at 50,50 width 400 height 150;
			title "Change value : "+name+'=>'+Values[1];
			modal NOSIZE nomaximize nominimize

		@ 10,10 label _oohg_change_value_lbl value "New value for "+name+'=>'+Values[1] autosize

		if tipo='C'
			@ 40,20 textbox _oohg_change_value_txt obj oGet value Values[2]
		elseif tipo='N'
			@ 40,20 textbox _oohg_change_value_txt obj oGet  value Values[2] numeric
		elseif tipo='D'
			@ 40,20 textbox _oohg_change_value_txt obj oGet  value Values[2] date
		elseif tipo='L'
			@ 40,20 checkbox _oohg_change_value_txt obj oGet  value Values[2] caption "( Checked for true value )" autosize
		end
		@ 70,10 button _oohg_change_value_btnOK caption "Set value" action (Values[2]:=oGet:value , lOk:=.t., oWnd:release())
		@ 70,150 button _oohg_change_value_btnno caption "Cancel" cancel action oWnd:release()
		end window
		oWnd:activate()
		if lOk
			__ObjSetValueList( ooBj , {Values} )
			ooBj:refresh()
		end
	Else
		msginfo('This value is not editable')
	end
	msginfo(name+' '+Values[1]+' '+valor(Values[2]))
return nil
