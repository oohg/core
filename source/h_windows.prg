/*
 * $Id: h_windows.prg $
 */
/*
 * ooHG source code:
 * TWindow class and window handling functions
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

EXTERN EVAL

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TWindow

   DATA aAcceleratorKeys          INIT {}                                     // Accelerator hotkeys: { Id, Mod, Key, Action }
   DATA aBEColors                 INIT {{0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}}   // outside color: up, right, bottom, left
   DATA aBIColors                 INIT {{0,0,0}, {0,0,0}, {0,0,0}, {0,0,0}}   // inside color: up, right, bottom, left
   DATA aControlInfo              INIT { Chr( 0 ) }
   DATA aControls                 INIT {}
   DATA aControlsNames            INIT {}
   DATA Active                    INIT .F.
   DATA aCtrlsTabIndxs            INIT {}
   DATA aHotKeys                  INIT {}                                     // OS controlled hotkeys: { Id, Mod, Key, Action }
   DATA aKeys                     INIT {}                                     // App-controlled hotkeys: { Id, Mod, Key, Action }
   DATA aProperties               INIT {}                                     // Pseudo-properties: { cProperty, xValue }
   DATA bKeyDown                  INIT NIL                                    // WM_KEYDOWN handler
   DATA Block                     INIT NIL
   DATA Bold                      INIT .F.
   DATA Cargo                     INIT NIL
   DATA cFocusFontName            INIT ""
   DATA cFontName                 INIT ""
   DATA ClientAdjust              INIT 0                                      // 0=none, 1=top, 2=bottom, 3=left, 4=right, 5=client
   DATA ClientHeightUsed          INIT 0
   DATA ColMargin                 INIT 0
   DATA Container                 INIT NIL
   DATA ContainerhWndValue        INIT NIL
   DATA ContextMenu               INIT NIL
   DATA cStatMsg                  INIT NIL
   DATA DefBkColorEdit            INIT NIL
   DATA DropEnabled               INIT .F.                                    // .T. if control accepts drops
   DATA FntAdvancedGM             INIT .F.
   DATA FntAngle                  INIT 0
   DATA FntCharset                INIT DEFAULT_CHARSET
   DATA FntOrientation            INIT 0
   DATA FntWidth                  INIT 0
   DATA FocusBackColor
   DATA FocusBold                 INIT .F.
   DATA FocusColor
   DATA FocusItalic               INIT .F.
   DATA FocusStrikeout            INIT .F.
   DATA FocusUnderline            INIT .F.
   DATA HasDragFocus              INIT .F.                                    // .T. when drag image is over a drop-enabled control
   DATA hDC                                                                   
   DATA hDynamicValues            INIT NIL
   DATA HScrollBar                INIT NIL
   DATA hWnd                      INIT 0
   DATA IsAdjust                  INIT .F.
   DATA Italic                    INIT .F.
   DATA lAdjust                   INIT .T.
   DATA lControlsAsProperties     INIT .F.
   DATA lDestroyed                INIT .F.
   DATA lDisableDoEvent           INIT .F.
   DATA lEnabled                  INIT .T.
   DATA lFixFont                  INIT .F.
   DATA lfixwidth                 INIT .F.
   DATA lForm                     INIT .F.
   DATA lInternal                 INIT .T.
   DATA lProcMsgsOnVisible        INIT .T.
   DATA lRedraw                   INIT .T.
   DATA lReleased                 INIT .F.
   DATA lReleasing                INIT .F.
   DATA lRtl                      INIT .F.
   DATA lVisible                  INIT .T.
   DATA lVisualStyled             INIT NIL PROTECTED
   DATA Name                      INIT ""
   DATA nAnchor                   INIT NIL
   DATA nBorders                  INIT {0,0,0}                                // size of outside border, size of gap, size of inside border.
   DATA nCol                      INIT 0
   DATA nDefAnchor                INIT 3
   DATA NestedClick               INIT .F.
   DATA nFixedHeightUsed          INIT 0
   DATA nFocusFontSize            INIT 0
   DATA nFontSize                 INIT 0
   DATA nHeight                   INIT 0
   DATA NoDefWinProc              INIT .F.                                    // See WM_PAINT message in h_form.prg
   DATA nOLdh                     INIT NIL
   DATA nOldw                     INIT NIL
   DATA nPaintCount                                                           // counter for GetDC and ReleaseDC methods
   DATA nRow                      INIT 0
   DATA nWidth                    INIT 0
   DATA nWindowState              INIT 0                                      // 0=normal 1=minimized 2=maximized
   DATA OnClick                   INIT NIL
   DATA OnDblClick                INIT NIL
   DATA OnDropFiles               INIT NIL
   DATA OnGotFocus                INIT NIL
   DATA OnLostFocus               INIT NIL
   DATA OnMClick                  INIT NIL
   DATA OnMDblClick               INIT NIL
   DATA OnMouseDrag               INIT NIL
   DATA OnMouseMove               INIT NIL
   DATA OnRClick                  INIT NIL
   DATA OnRDblClick               INIT NIL
   DATA OverWndProc               INIT NIL
   DATA Parent                    INIT NIL
   DATA RowMargin                 INIT 0
   DATA Strikeout                 INIT .F.
   DATA TabHandle                 INIT 0
   DATA Type                      INIT ""
   DATA Underline                 INIT .F.
   DATA VarName                   INIT ""
   DATA VScrollBar                INIT NIL
   DATA WndProc                   INIT NIL

   ERROR HANDLER Error

   METHOD AcceleratorKey                                                      // Accelerator hotkeys
   METHOD AcceptFiles             SETGET
   METHOD Action                  SETGET
   METHOD AddControl
   METHOD Adjust                  SETGET
   METHOD AdjustAnchor
   METHOD AdjustResize
   METHOD Anchor                  SETGET
   METHOD Arc
   METHOD ArcTo
   METHOD BackBitMap              SETGET
   METHOD BackColor               SETGET
   METHOD BackColorCode           SETGET
   METHOD BackColorSelected       SETGET
   METHOD Box
   METHOD BringToTop              BLOCK { |Self| BringWindowToTop( ::hWnd ) }
   METHOD BrushHandle             SETGET
   METHOD Caption                 SETGET
   METHOD CheckClientsPos
   METHOD Click                   BLOCK { |Self| ::DoEvent( ::OnClick, "CLICK" ) }
   METHOD Chord
   METHOD ClientHeight            SETGET
   METHOD ClientsPos
   METHOD ClientsPos2
   METHOD ClientWidth             SETGET
   METHOD ContainerEnabled        BLOCK { |Self| ::lEnabled .AND. iif( ::Container != NIL, ::Container:ContainerEnabled, .T. ) }
   METHOD ContainerReleasing      BLOCK { |Self| ::lReleasing .OR. iif( ::Container != NIL, ::Container:ContainerReleasing, iif( ::Parent != NIL, ::Parent:ContainerReleasing, .F. ) ) }
   METHOD ContainerVisible        BLOCK { |Self| ::lVisible .AND. iif( ::Container != NIL, ::Container:ContainerVisible, .T. ) }
   METHOD Control
   METHOD DebugMessageName
   METHOD DebugMessageNameCommand
   METHOD DebugMessageNameNotify
   METHOD DebugMessageQuery
   METHOD DebugMessageQueryNotify
   METHOD DefWindowProc( nMsg, wParam, lParam ) BLOCK { |Self, nMsg, wParam, lParam| DefWindowProc( ::hWnd, nMsg, wParam, lParam ) }
   METHOD DeleteControl
   METHOD Disable                 BLOCK { |Self| ::Enabled := .F. }
   METHOD DisableVisualStyle
   METHOD DynamicValues           BLOCK { |Self| iif( ::hDynamicValues == NIL, ::hDynamicValues := TDynamicValues():New( Self ), ::hDynamicValues ) }
   METHOD Ellipse
   METHOD Enable                  BLOCK { |Self| ::Enabled := .T. }
   METHOD Enabled                 SETGET
   METHOD Events
   METHOD Events_Color            BLOCK { || NIL }
   METHOD Events_Enter            BLOCK { || NIL }
   METHOD Events_HScroll          BLOCK { || NIL }
   METHOD Events_Size             BLOCK { || NIL }
   METHOD Events_TimeOut          BLOCK { |Self| ::DoEvent( ::OnClick, "TIMER" ) }
   METHOD Events_VScroll          BLOCK { || NIL }
   METHOD ExStyle                 SETGET
   METHOD Fill
   METHOD FontColor               SETGET
   METHOD FontColorCode           SETGET
   METHOD FontColorSelected       SETGET
   METHOD FontHandle              SETGET
   METHOD ForceHide               BLOCK { |Self| HideWindow( ::hWnd ), ::CheckClientsPos(), ProcessMessages() }
   METHOD GetBitMap( l )          BLOCK { |Self, l| _GetBitMap( ::hWnd, l ) }
   METHOD GetDC                   INLINE iif( ::hDC == NIL, ::hDC := GetDC( ::hWnd ), ), iif( ::nPaintCount == NIL, ::nPaintCount := 1, ::nPaintCount ++ ), ::hDC
   METHOD GetMaxCharsInWidth
   METHOD GetTextHeight
   METHOD GetTextWidth
   METHOD Hide                    BLOCK { |Self| ::Visible := .F. }
   METHOD HotKey                                                              // OS-controlled hotkeys
   METHOD IconHandle              SETGET
   METHOD ImageList               SETGET
   METHOD IsVisualStyled
   METHOD Line
   METHOD LookForKey
   METHOD Object                  BLOCK { |Self| Self }
   METHOD ParentDefaults
   METHOD Pie
   METHOD PolyBezier
   METHOD PolyBezierTo
   METHOD Polygon
   METHOD PreRelease
   METHOD Print
   METHOD Property                                                            // Pseudo-properties
   METHOD ReDraw                  BLOCK { |Self| RedrawWindow( ::hWnd ) }
   METHOD RefreshData
   METHOD Release
   METHOD ReleaseAttached
   METHOD ReleaseDC               INLINE iif( -- ::nPaintCount == 0, iif( ReleaseDC( ::hWnd, ::hDC ), ::hDC := NIL, NIL ), NIL )
   METHOD RoundBox
   METHOD RTL                     SETGET
   METHOD SaveAs
   METHOD SaveData
   METHOD SearchParent
   METHOD SetFocus
   METHOD SethWnd
   METHOD SetKey                                                              // Application-controlled hotkeys
   METHOD SetRedraw
   METHOD SetSplitBox             BLOCK { || .F. }                            // Specific hack
   METHOD SetSplitBoxInfo         BLOCK { |Self, a, b, c, d| iif( ::Container != NIL, ::Container:SetSplitBox( a, b, c, d ), .F. ) }   // Specific hack
   METHOD Show                    BLOCK { |Self| ::Visible := .T. }
   METHOD StartInfo
   METHOD Style                   SETGET
   METHOD TabStop                 SETGET
   METHOD Value                   BLOCK { || NIL }
   METHOD Visible                 SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD IsVisualStyled CLASS TWindow

   IF ::lVisualStyled == NIL
      ::lVisualStyled := _OOHG_UsesVisualStyle()
   ENDIF

   RETURN ::lVisualStyled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DisableVisualStyle CLASS TWindow

   IF ::IsVisualStyled
      IF DisableVisualStyle( ::hWnd )
         ::lVisualStyled := .F.
         ::Redraw()
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PreRelease() CLASS TWindow

   AEval( ::aControls, { |o| o:PreRelease() } )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Enabled( lEnabled ) CLASS TWindow

   IF HB_ISLOGICAL( lEnabled )
      ::lEnabled := lEnabled
      IF ::ContainerEnabled
         EnableWindow( ::hWnd )
      ELSE
         DisableWindow( ::hWnd )
      ENDIF
   ENDIF

   RETURN ::lEnabled

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TabStop( lTabStop ) CLASS TWindow

   IF HB_ISLOGICAL( lTabStop )
      WindowStyleFlag( ::hWnd, WS_TABSTOP, iif( lTabStop, WS_TABSTOP, 0 ) )
   ENDIF

   RETURN IsWindowStyle( ::hWnd, WS_TABSTOP )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Style( nStyle ) CLASS TWindow

   IF HB_ISNUMERIC( nStyle )
      SetWindowStyle( ::hWnd, nStyle )
   ENDIF

   RETURN GetWindowStyle( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ExStyle( nExStyle ) CLASS TWindow

   IF HB_ISNUMERIC( nExStyle )
      SetWindowExStyle( ::hWnd, nExStyle )
      SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE + SWP_NOZORDER + SWP_NOACTIVATE + SWP_FRAMECHANGED )
   ENDIF

   RETURN GetWindowExStyle( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RTL( lRTL ) CLASS TWindow

   IF HB_ISLOGICAL( lRTL )
      _UpdateRTL( ::hWnd, lRTL )
      ::lRtl := lRTL
   ENDIF

   RETURN ::lRtl

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Action( bAction ) CLASS TWindow

   IF PCount() > 0
      ::OnClick := bAction
   ENDIF

   RETURN ::OnClick

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SaveData() CLASS TWindow

   _OOHG_EVAL( ::Block, ::Value )
   AEval( ::aControls, { |o| iif( o:Container == NIL, o:SaveData(), NIL ) } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RefreshData() CLASS TWindow

   IF HB_ISBLOCK( ::Block )
      ::Value := Eval( ::Block )
   ENDIF
   AEval( ::aControls, { |o| o:RefreshData() } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Print( y, x, y1, x1, lAll, cType, nQuality, nColorDepth, lImageSize ) CLASS TWindow

   LOCAL myobject, cWork, cExt

   IF ValType( cType ) $ "CM"
     cType := Upper( cType )
   ELSE
     cType := "BMP"
   ENDIF
   IF cType == "BMP"
      cExt := ".bmp"
   ELSEIF cType == "JPEG" .OR. cType == "JPG"
      cExt := ".jpg"
   ELSEIF cType == "GIF"
      cExt := ".gif"
   ELSEIF cType == "TIFF" .OR. cType == "TIF"
      cExt := ".tif"
   ELSEIF cType == "PNG"
      cExt := ".png"
   ENDIF
   cWork := "_oohg_t" + AllTrim( Str( Int( hb_Random( 999999 ) ) ) ) + cExt
   DO WHILE File( cWork )
      cWork := "_oohg_t" + AllTrim( Str( Int( hb_Random( 999999 ) ) ) ) + cExt
   ENDDO

   ASSIGN y1 VALUE y1 TYPE "N" DEFAULT 44
   ASSIGN x1 VALUE x1 TYPE "N" DEFAULT 110
   ASSIGN x  VALUE x  TYPE "N" DEFAULT 1
   ASSIGN y  VALUE y  TYPE "N" DEFAULT 1

   ::SaveAs( cWork, lAll, cType, nQuality, nColorDepth ) //// save as BMP by default

   myobject := TPrint()

   WITH OBJECT myobject
      :Init()
      :SelPrinter( .T., .T., .T. )  /// select, preview, landscape
      IF ! :lPrError
         :BeginDoc( "ooHG printing" )
         :BeginPage()
         :PrintImage( y, x, y1, x1, cwork, NIL, lImageSize )
         :Endpage()
         :EndDoc()
      ENDIF
      :Release()
   END

   FErase( cWork )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SaveAs( cFile, lAll, cType, nQuality, nColorDepth ) CLASS TWindow

   LOCAL hBitMap, aSize

   IF ValType( cType ) $ "CM"
     cType := Upper( cType )
   ELSE
     cType := "BMP"
   ENDIF
   ::BringToTop()
   hBitMap := ::GetBitMap( lAll )
   aSize := _OOHG_SizeOfHBitmap( hBitMap )
   IF cType == "BMP"
      _SaveBitmap( hBitMap, cFile )
   ELSE
      IF gPlusInit()
         IF cType == "JPEG" .OR. cType == "JPG"
            IF ValType( nQuality ) != "N" .OR. nQuality < 0 .OR. nQuality > 100
              nQuality := 100
            ENDIF
            // JPEG images are always saved at 24 bpp color depth.
            gPlusSaveHBitmapToFile( hBitMap, cFile, aSize[ 1 ], aSize[ 2 ], "image/jpeg", nQuality, NIL )
         ELSEIF cType == "GIF"
            // GIF images do not support parameters.
            // GIF images are always saved at 8 bpp color depth.
            // GIF images are always compressed using LZW algorithm.
            gPlusSaveHBitmapToFile( hBitMap, cFile, aSize[ 1 ], aSize[ 2 ], "image/gif", NIL, NIL )
         ELSEIF cType == "TIFF" .OR. cType == "TIF"
            IF ValType( nQuality ) != "N" .OR. nQuality < 0 .OR. nQuality > 1
              // This the default value: LZW compression.
              nQuality := 1
            ENDIF
            IF ValType( nColorDepth ) != "N" .OR. ( nColorDepth # 1 .AND. nColorDepth # 4 .AND. nColorDepth # 8 .AND. nColorDepth # 24 .AND. nColorDepth # 32 )
              // This is the default value: 32 bpp.
              nColorDepth := 32
            ENDIF
            gPlusSaveHBitmapToFile( hBitMap, cFile, aSize[ 1 ], aSize[ 2 ], "image/tiff", nQuality, nColorDepth )
         ELSEIF cType == "PNG"
            // PNG images do not support parameters.
            // PNG images are always saved at 24 bpp color depth if they don't have transparecy
            // or at 32 bpp if they have it.
            // PNG images are always compressed using ZIP algorithm.
            gPlusSaveHBitmapToFile( hBitMap, cFile, aSize[ 1 ], aSize[ 2 ], "image/png", NIL, NIL )
         ENDIF
         gPlusDeInit()
      ENDIF
   ENDIF
   DeleteObject( hBitMap )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AddControl( oControl ) CLASS TWindow

   AAdd( ::aControls,      oControl )
   AAdd( ::aControlsNames, Upper( AllTrim( oControl:Name ) ) + Chr( 255 ) )
   AAdd( ::aCtrlsTabIndxs, Len( ::aControls ) )

   RETURN oControl

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteControl( oControl ) CLASS TWindow

   LOCAL nPos, nDelOrder

   nPos := AScan( ::aControlsNames, Upper( AllTrim( oControl:Name ) ) + Chr( 255 ) )
   IF nPos > 0
      _OOHG_DeleteArrayItem( ::aControls,       nPos )
      _OOHG_DeleteArrayItem( ::aControlsNames,  nPos )
      nDelOrder := ::aCtrlsTabIndxs[ nPos ]
      _OOHG_DeleteArrayItem( ::aCtrlsTabIndxs, nPos )
      // renumber to avoid gaps
      AEval( ::aCtrlsTabIndxs, { | nOrder, i | iif( nOrder > nDelOrder, ::aCtrlsTabIndxs[ i ] --, NIL ) } )
   ENDIF

   RETURN oControl

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SearchParent( uParent ) CLASS TWindow

   IF ValType( uParent ) $ "CM" .AND. ! Empty( uParent )
      IF ! _IsWindowDefined( uParent )
         MsgOOHGError( "Window: " + uParent + " is not defined. Program terminated." )
      ELSE
         uParent := GetFormObject( uParent )
      ENDIF
   ENDIF

   IF ! HB_ISOBJECT( uParent )
      uParent := SearchParentWindow( ::lInternal )
   ENDIF

   IF ::lInternal
      IF ! HB_ISOBJECT( uParent )
         MsgOOHGError( "Window: Parent is not defined. Program terminated." )
      ENDIF

      // NOTE: For INTERNALs, sets ::Parent and ::Container
      // Checks IF parent is a form or container
      IF uParent:lForm
         ::Parent := uParent
         // Checks for an open "control container" structure in the specified parent form
         ::Container := TApplication():Define():ActiveFrameContainer( ::Parent:hWnd )
      ELSE
         ::Container := uParent
         ::Parent := ::Container:Parent
      ENDIF
   ENDIF

   RETURN uParent

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ParentDefaults( cFontName, nFontSize, uFontColor, lNoProc ) CLASS TWindow

   // Font Name:
   IF ValType( cFontName ) == "C" .AND. ! Empty( cFontName )
      // Specified font
      ::cFontName := cFontName
   ELSEIF ValType( ::cFontName ) == "C" .AND. ! Empty( ::cFontName )
      // Pre-registered
   ELSEIF ::Container != NIL .AND. ValType( ::Container:cFontName ) == "C" .AND. ! Empty( ::Container:cFontName )
      // Container
      ::cFontName := ::Container:cFontName
   ELSEIF ::Parent != NIL .AND. ValType( ::Parent:cFontName ) == "C" .AND. ! Empty( ::Parent:cFontName )
      // Parent form
      ::cFontName := ::Parent:cFontName
   ELSE
       // Default
      ::cFontName := _OOHG_DefaultFontName
   ENDIF

   // Font Size:
   IF HB_ISNUMERIC( nFontSize ) .AND. nFontSize != 0
      // Specified size
      ::nFontSize := nFontSize
   ELSEIF HB_ISNUMERIC( ::nFontSize ) .AND. ::nFontSize != 0
      // Pre-registered
   ELSEIF ::Container != NIL .AND. HB_ISNUMERIC( ::Container:nFontSize ) .AND. ::Container:nFontSize != 0
      // Container
      ::nFontSize := ::Container:nFontSize
   ELSEIF ::Parent != NIL .AND. HB_ISNUMERIC( ::Parent:nFontSize ) .AND. ::Parent:nFontSize != 0
      // Parent form
      ::nFontSize := ::Parent:nFontSize
   ELSE
       // Default
      ::nFontSize := _OOHG_DefaultFontSize
   ENDIF

   // Font Color:
   IF ValType( uFontColor ) $ "ANCM"
      // Specified color
      ::FontColor := uFontColor
   ELSEIF ValType( ::FontColor ) $ "ANCM"
      // Pre-registered
      // To detect about "-1" !!!
   ELSEIF ::Container != NIL .AND. ValType( ::Container:FontColor ) $ "ANCM"
      // Container
      ::FontColor := ::Container:FontColor
   ELSEIF ::Parent != NIL .AND. ValType( ::Parent:FontColor ) $ "ANCM"
      // Parent form
      ::FontColor := ::Parent:FontColor
   ELSE
       // Default
       ::FontColor := _OOHG_DefaultFontColor
   ENDIF

   IF HB_ISLOGICAL( lNoProc )
      ::lProcMsgsOnVisible := ! lNoProc
   ELSEIF ::Container != NIL
      ::lProcMsgsOnVisible := ::Container:lProcMsgsOnVisible
   ELSEIF ::Parent != NIL
      ::lProcMsgsOnVisible := ::Parent:lProcMsgsOnVisible
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Error( xParam ) CLASS TWindow

   LOCAL nPos, cMessage

   cMessage := __GetMessage()

   nPos := AScan( ::aControlsNames, cMessage + Chr( 255 ) )
   IF nPos > 0
      IF ::lControlsAsProperties
         RETURN ::aControls[ nPos ]:Value
      ELSE
         RETURN ::aControls[ nPos ]
      ENDIF
   ENDIF

   IF PCount() >= 1 .AND. ::lControlsAsProperties .AND. Left( cMessage, 1 ) == "_"
      nPos := AScan( ::aControlsNames, SubStr( cMessage, 2 ) + Chr( 255 ) )
      IF nPos > 0
         RETURN ( ::aControls[ nPos ]:Value := xParam )
      ENDIF
   ENDIF

   IF PCount() >= 1
      nPos := AScan( ::aProperties, { |a| "_" + a[ 1 ] == cMessage } )
      IF nPos > 0
         ::aProperties[ nPos ][ 2 ] := xParam
         RETURN ::aProperties[ nPos ][ 2 ]
      ENDIF
   ELSE
      nPos := AScan( ::aProperties, { |a| a[ 1 ] == cMessage } )
      IF nPos > 0
         RETURN ::aProperties[ nPos ][ 2 ]
      ENDIF
   ENDIF

   RETURN ::MsgNotFound( cMessage )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Control( cControl ) CLASS TWindow

   LOCAL nPos

   nPos := AScan( ::aControlsNames, Upper( AllTrim( cControl ) ) + Chr( 255 ) )

   RETURN iif( nPos > 0, ::aControls[ nPos ], NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
#define HOTKEY_ID        1
#define HOTKEY_MOD       2
#define HOTKEY_KEY       3
#define HOTKEY_ACTION    4

METHOD HotKey( nKey, nFlags, bAction ) CLASS TWindow

   LOCAL nPos, nId, uRet := NIL

   nPos := AScan( ::aHotKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. a[ HOTKEY_MOD ] == nFlags } )
   IF nPos > 0
      uRet := ::aHotKeys[ nPos ][ HOTKEY_ACTION ]
   ENDIF
   IF PCount() > 2
      IF HB_ISBLOCK( bAction )
         IF nPos > 0
            ::aHotKeys[ nPos ][ HOTKEY_ACTION ] := bAction
         ELSE
            nId := _GetId()
            AAdd( ::aHotKeys, { nId, nFlags, nKey, bAction } )
            InitHotKey( ::hWnd, nFlags, nKey, nId )
         ENDIF
      ELSE
         IF nPos > 0
            ReleaseHotKey( ::hWnd, ::aHotKeys[ nPos ][ HOTKEY_ID ] )
            _OOHG_DeleteArrayItem( ::aHotKeys, nPos )
         ENDIF
      ENDIF
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetKey( nKey, nFlags, bAction ) CLASS TWindow

   LOCAL bCode

   bCode := _OOHG_SetKey( ::aKeys, nKey, nFlags )
   IF PCount() > 2
      _OOHG_SetKey( ::aKeys, nKey, nFlags, bAction )
   ENDIF

   RETURN bCode

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AcceleratorKey( nKey, nFlags, bAction ) CLASS TWindow

   LOCAL nPos, nId, uRet := NIL

   nPos := AScan( ::aAcceleratorKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. a[ HOTKEY_MOD ] == nFlags } )
   IF nPos > 0
      uRet := ::aAcceleratorKeys[ nPos ][ HOTKEY_ACTION ]
   ENDIF
   IF PCount() > 2
      IF HB_ISBLOCK( bAction )
         IF nPos > 0
            ::aAcceleratorKeys[ nPos ][ HOTKEY_ACTION ] := bAction
         ELSE
            nId := _GetId()
            AAdd( ::aAcceleratorKeys, { nId, nFlags, nKey, bAction } )
            InitHotKey( ::hWnd, nFlags, nKey, nId )
         ENDIF
      ELSE
         IF nPos > 0
            ReleaseHotKey( ::hWnd, ::aAcceleratorKeys[ nPos ][ HOTKEY_ID ] )
            _OOHG_DeleteArrayItem( ::aAcceleratorKeys, nPos )
         ENDIF
      ENDIF
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LookForKey( nKey, nFlags ) CLASS TWindow

   LOCAL lDone

   IF ::Active .AND. LookForKey_Check_HotKey( ::aKeys, nKey, nFlags, Self )
      lDone := .T.
   ELSEIF ::Active .AND. LookForKey_Check_bKeyDown( ::bKeyDown, nKey, nFlags, Self )
      lDone := .T.
   ELSEIF HB_ISOBJECT( ::Container )
      lDone := ::Container:LookForKey( nKey, nFlags )
   ELSEIF HB_ISOBJECT( ::Parent ) .AND. ::lInternal
      lDone := ::Parent:LookForKey( nKey, nFlags )
   ELSE
      IF LookForKey_Check_HotKey( _OOHG_HotKeys, nKey, nFlags, TForm() )
         lDone := .T.
      ELSEIF LookForKey_Check_bKeyDown( _OOHG_bKeyDown, nKey, nFlags, TForm() )   // Application-wide WM_KEYDOWN handler
         lDone := .T.
      ELSE
         lDone := .F.
      ENDIF
   ENDIF

   RETURN lDone

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION LookForKey_Check_HotKey( aKeys, nKey, nFlags, Self )

   LOCAL nPos, lDone

   nPos := AScan( aKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. nFlags == a[ HOTKEY_MOD ] } )
   IF nPos > 0
      ::DoEvent( aKeys[ nPos ][ HOTKEY_ACTION ], "HOTKEY", { nKey, nFlags } )
      lDone := .T.
   ELSE
      lDone := .F.
   ENDIF

   RETURN lDone

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION LookForKey_Check_bKeyDown( bKeyDown, nKey, nFlags, Self )

   LOCAL lDone

   IF HB_ISBLOCK( bKeyDown )
      lDone := ::DoEvent( bKeyDown, "KEYDOWN", { nKey, nFlags } )
      IF ! HB_ISLOGICAL( lDone )
         lDone := .F.
      ENDIF
   ELSE
      lDone := .F.
   ENDIF

   RETURN lDone

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Property( cProperty, xValue ) CLASS TWindow

   LOCAL nPos

   cProperty := Upper( AllTrim( cProperty ) )
   nPos := AScan( ::aProperties, { |a| a[ 1 ] == cProperty } )
   IF PCount() >= 2
      IF nPos > 0
         ::aProperties[ nPos ][ 2 ] := xValue
      ELSE
         AAdd( ::aProperties, { cProperty, xValue } )
      ENDIF
   ELSE
      IF nPos > 0
         xValue := ::aProperties[ nPos ][ 2 ]
      ELSE
         // RTE?
         xValue := NIL
      ENDIF
   ENDIF

   RETURN xValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseAttached() CLASS TWindow

   // Release hot keys commands
   AEval( ::aKeys, { |a| a[ HOTKEY_ACTION ] := NIL } )
   ::aKeys := {}

   // Release accelerator commands
   AEval( ::aHotKeys, { |a| ( ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ), a[ HOTKEY_ACTION ] := NIL ) } )
   ::aHotKeys := {}

   // Release application-wide hot keys commands
   AEval( ::aAcceleratorKeys, { |a| ( ReleaseHotKey( ::hWnd, a[ HOTKEY_ID ] ), a[ HOTKEY_ACTION ] := NIL ) } )
   ::aAcceleratorKeys := {}

   // Remove Child Controls
   DO WHILE Len( ::aControls ) > 0
      ATail( ::aControls ):Release()
   ENDDO

   ::HScrollBar := NIL
   ::VScrollBar := NIL

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetRedraw( lRedraw ) CLASS TWindow

   IF HB_ISLOGICAL( lRedraw )
      ::lRedraw := lRedraw
      IF lRedraw
         // When the window is hidden, this message shows it by adding WS_VISIBLE style to the window.
         SendMessage( ::hWnd, WM_SETREDRAW, 1, 0 )
      ELSE
         SendMessage( ::hWnd, WM_SETREDRAW, 0, 0 )
      ENDIF
   ENDIF

   RETURN ::lRedraw

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Visible( lVisible ) CLASS TWindow

   IF HB_ISLOGICAL( lVisible )
      ::lVisible := lVisible
      IF ::ContainerVisible
         cShowControl( ::hWnd )
      ELSE
         HideWindow( ::hWnd )
      ENDIF

      IF ::lProcMsgsOnVisible
         ProcessMessages()
      ENDIF

      ::CheckClientsPos()
   ENDIF

   RETURN ::lVisible

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetTextWidth( cString ) CLASS TWindow

   RETURN GetTextWidth( NIL, cString, ::FontHandle )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetTextHeight( cString ) CLASS TWindow

   RETURN GetTextHeight( NIL, cString, ::FontHandle )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ClientWidth( nWidth ) CLASS TWindow

   LOCAL aClientRect

   IF HB_ISNUMERIC( nWidth )
      aClientRect := { 0, 0, 0, 0 }
      GetClientRect( ::hWnd, aClientRect )
      ::Width := ::Width - ( aClientRect[ 3 ] - aClientRect[ 1 ] ) + nWidth
   ENDIF

   // Window may be greater than requested width... verify it again
   aClientRect := { 0, 0, 0, 0 }
   GetClientRect( ::hWnd, aClientRect )

   RETURN aClientRect[ 3 ] - aClientRect[ 1 ]

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ClientHeight( nHeight ) CLASS TWindow

   LOCAL aClientRect

   IF HB_ISNUMERIC( nHeight )
      aClientRect := { 0, 0, 0, 0 }
      GetClientRect( ::hWnd, aClientRect )
      ::Height := ::Height - ( aClientRect[ 4 ] - aClientRect[ 2 ] ) + nHeight
   ENDIF

   // Window may be greater than requested height... verify it again
   aClientRect := { 0, 0, 0, 0 }
   GetClientRect( ::hWnd, aClientRect )

   RETURN aClientRect[ 4 ] - aClientRect[ 2 ]

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TWindow

   LOCAL nFixedHeightUsed

   IF ::lAdjust
      //// nFixedHeightUsed = pixels used by non-scalable elements inside client area
      IF ::container == NIL
         nFixedHeightUsed := ::parent:nFixedHeightUsed
      ELSE
         nFixedHeightUsed := ::container:nFixedHeightUsed
      ENDIF

      ::Sizepos( ( ::Row - nFixedHeightUsed ) * nDivh + nFixedHeightUsed, ::Col * nDivw )

      IF _OOHG_AdjustWidth
         IF ! ::lFixWidth
            ::Sizepos( NIL, NIL, ::Width * nDivw, ::Height * nDivh )

            IF _OOHG_AdjustFont
               IF ! ::lFixFont
                  ::FontSize := ::FontSize * nDivw
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      IF ! HB_ISLOGICAL( lSelfOnly ) .OR. ! lSelfOnly
         AEval( ::aControls, { |o| o:AdjustResize( nDivh, nDivw ) } )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Anchor( xAnchor ) CLASS TWindow

   LOCAL nTop, nLeft, nBottom, nRight

   IF HB_ISNUMERIC( xAnchor )
      ::nAnchor := Int( xAnchor ) % 16
   ELSEIF HB_ISSTRING( xAnchor )
      xAnchor := Upper( AllTrim( xAnchor ) )
      IF xAnchor == "NONE"
         ::nAnchor := 0
      ELSEIF xAnchor == "ALL"
         ::nAnchor := 16
      ELSE
         nTop := nLeft := nBottom := nRight := 0
         DO WHILE ! Empty( xAnchor )
            IF     Left( xAnchor, 3 ) == "TOP"
               nTop := 1
               xAnchor := SubStr( xAnchor, 4 )
            ELSEIF Left( xAnchor, 4 ) == "LEFT"
               nLeft := 2
               xAnchor := SubStr( xAnchor, 5 )
            ELSEIF Left( xAnchor, 6 ) == "BOTTOM"
               nBottom := 4
               xAnchor := SubStr( xAnchor, 7 )
            ELSEIF Left( xAnchor, 5 ) == "RIGHT"
               nRight := 8
               xAnchor := SubStr( xAnchor, 6 )
            ELSE
               nTop := ::nAnchor
               nLeft := nBottom := nRight := 0
               EXIT
            ENDIF
         ENDDO
         ::nAnchor := nTop + nLeft + nBottom + nRight
      ENDIF
   ENDIF

   RETURN ::nAnchor

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AdjustAnchor( nDeltaH, nDeltaW ) CLASS TWindow

   LOCAL nAnchor, lTop, lLeft, lBottom, lRight, nRow, nCol, nWidth, nHeight, lChange

   IF ::nAnchor == NIL
      RETURN NIL
   ENDIF
   nAnchor := Int( ::nAnchor ) % 16
   IF nAnchor != 3 .AND. ( nDeltaH != 0 .OR. nDeltaW != 0 )
      lTop    := ( ( nAnchor %  2 ) >= 1 )
      lLeft   := ( ( nAnchor %  4 ) >= 2 )
      lBottom := ( ( nAnchor %  8 ) >= 4 )
      lRight  := ( ( nAnchor % 16 ) >= 8 )
      nRow    := ::Row
      nCol    := ::Col
      nWidth  := ::Width
      nHeight := ::Height
      lChange := .F.
      // Height checking
      IF nDeltaH == 0
         //
      ELSEIF lTop .AND. lBottom
         nHeight += nDeltaH
         lChange := .T.
      ELSEIF lBottom
         nRow += nDeltaH
         lChange := .T.
      ELSEIF ! lTop
         nRow += ( nDeltaH / 2 )
         lChange := .T.
      ENDIF
      // Width checking
      IF nDeltaW == 0
         //
      ELSEIF lLeft .AND. lRight
         nWidth += nDeltaW
         lChange := .T.
      ELSEIF lRight
         nCol += nDeltaW
         lChange := .T.
      ELSEIF ! lLeft
         nCol += ( nDeltaW / 2 )
         lChange := .T.
      ENDIF
      // Any change?
      IF lChange
         ::SizePos( nRow, nCol, nWidth, nHeight )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CheckClientsPos() CLASS TWindow

   IF ::ClientAdjust > 0
      IF ::Container != NIL
         ::Container:ClientsPos()
      ELSEIF ::Parent != NIL
         ::Parent:ClientsPos()
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ClientsPos() CLASS TWindow

   RETURN ::ClientsPos2( ::aControls, ::Width, ::Height )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ClientsPos2( aControls, nWidth, nHeight ) CLASS TWindow

   // ajusta los controles dentro de la ventana por ClientAdjust
   LOCAL n, nAdjust, oControl, nRow, nCol
   LOCAL nOffset // desplazamientos por borde

   IF ::IsAdjust
      RETURN self
   ENDIF
   nOffSet := ::nBorders[ 1 ] + ::nBorders[ 2 ] + ::nBorders[ 3 ]
   nOffset := iif( nOffset > 0, nOffset + 1, 0 )
   nRow    := nOffset
   nCol    := nOffset
   nWidth  := nWidth-2*nOffset
   nHeight := nHeight - 2 * nOffset
   ::IsAdjust := .T.
   // remove toolbar .and. statusbar
   FOR n := 1 TO Len( aControls )
      IF aControls[n]:Type == "TOOLBAR"
         IF aControls[ n ]:ltop
            nRow += aControls[ n ]:ClientHeightUsed()
            nHeight -= aControls[ n ]:ClientHeightUsed()
         ELSE
            nHeight -= aControls[n]:ClientHeightUsed()
         ENDIF
      ELSEIF aControls[ n ]:type == "MESSAGEBAR"
          nHeight += aControls[ n ]:ClientHeightUsed()
      ENDIF IF
   NEXT

   FOR n := 1 TO Len( aControls )
      oControl := aControls[ n ]
      nAdjust := oControl:ClientAdjust
      IF nAdjust > 0 .AND. nAdjust < 5 .AND. aControls[ n ]:ContainerVisible
         oControl:Hide()
         IF nAdjust == 1 // top
            oControl:Col := nCol
            oControl:Row := nRow
            oControl:Width := nWidth
            nRow := nRow + oControl:nHeight
            nHeight := nHeight - oControl:nHeight
         ELSEIF nAdjust == 2 // bottom
            oControl:Col := nCol
            oControl:Row := nHeight - oControl:nHeight + nRow
            oControl:Width := nWidth
            nHeight := nHeight - oControl:nHeight
         ELSEIF nAdjust == 3 //left
            oControl:Col := nCol
            oControl:Row := nRow
            oControl:Height := nHeight
            nCol := nCol + oControl:nWidth
            nWidth := nWidth - oControl:nWidth
         ELSEIF nAdjust == 4 //right
            oControl:Col := nWidth - oControl:nWidth + nCol
            oControl:Row := nRow
            oControl:Height := nHeight
            nWidth := nWidth - oControl:nWidth
         ENDIF

         //oControl:SizePos()
         oControl:Show()
      ENDIF
   NEXT
   FOR n := 1 TO Len( aControls )
      IF aControls[ n ]:ClientAdjust == 5 .AND. aControls[ n ]:Visible
         aControls[ n ]:Hide()
         aControls[ n ]:width := nWidth - 2
         aControls[ n ]:height := nHeight - 2
         aControls[ n ]:col := nCol
         aControls[ n ]:row := nRow
         aControls[ n ]:Show()
      ENDIF
   NEXT
   ::IsAdjust := .F.

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Adjust( nAdjust ) CLASS TWindow

   LOCAL Adjustpos, newAdjust

   IF PCount() > 0
      IF HB_ISSTRING( nAdjust )
         AdjustPos := Upper( AllTrim( nAdjust ) )
         IF AdjustPos == 'TOP'
            newAdjust := 1
         ELSEIF AdjustPos == 'BOTTOM'
            newAdjust := 2
         ELSEIF AdjustPos == 'LEFT'
            newAdjust := 3
         ELSEIF AdjustPos == 'RIGHT'
            newAdjust := 4
         ELSEIF AdjustPos == 'CLIENT'
            newAdjust := 5
         ELSE
            newAdjust := ::ClientAdjust
         ENDIF
         IF newAdjust <> ::ClientAdjust
            ::ClientAdjust := newAdjust
            ::CheckClientsPos()
         ENDIF
      ELSEIF HB_ISNUMERIC( nAdjust )
         IF nAdjust <> ::ClientAdjust
            ::ClientAdjust := nAdjust
            ::CheckClientsPos()
         ENDIF
      ENDIF
   ENDIF

   RETURN ::ClientAdjust

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetMaxCharsInWidth( cString, nWidth ) CLASS TWindow

   LOCAL nChars, nMin, nMax, nSize

   IF ! ValType( cString ) $ "CM" .OR. Len( cString ) == 0 .OR. ! HB_ISNUMERIC( nWidth ) .OR. nWidth <= 0
      nChars := 0
   ELSE
      nSize := ::GetTextWidth( cString )
      nMax := Len( cString )
      IF nSize <= nWidth
         nChars := nMax
      ELSE
         nMin := 0
         DO WHILE nMax != nMin + 1
            nChars := Int( ( nMin + nMax ) / 2 )
            nSize := ::GetTextWidth( Left( cString, nChars ) )
            IF nSize <= nWidth
               nMin := nChars
            ELSE
               nMax := nChars
            ENDIF
         ENDDO
         nChars := nMin
      ENDIF
   ENDIF

   RETURN nChars

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DebugMessageName( nMsg ) CLASS TWindow

   STATIC aNames := NIL
   LOCAL cName

   IF aNames == NIL
      aNames := { "WM_CREATE", "WM_DESTROY", "WM_MOVE", NIL, "WM_SIZE", ;
                  "WM_ACTIVATE", "WM_SETFOCUS", "WM_KILLFOCUS", NIL, "WM_ENABLE", ;
                  "WM_SETREDRAW", "WM_SETTEXT", "WM_GETTEXT", "WM_GETTEXTLENGTH", "WM_PAINT", ;
                  "WM_CLOSE", "WM_QUERYENDSESSION", "WM_QUIT", "WM_QUERYOPEN", "WM_ERASEBKGND", ;
                  "WM_SYSCOLORCHANGE", "WM_ENDSESSION", NIL, "WM_SHOWWINDOW", NIL, ;
                  "WM_WININICHANGE", "WM_DEVMODECHANGE", "WM_ACTIVATEAPP", "WM_FONTCHANGE", "WM_TIMECHANGE", ;
                  "WM_CANCELMODE", "WM_SETCURSOR", "WM_MOUSEACTIVATE", "WM_CHILDACTIVATE", "WM_QUEUESYNC", ;
                  "WM_GETMINMAXINFO", NIL, "WM_PAINTICON", "WM_ICONERASEBKGND", "WM_NEXTDLGCTL", ;
                  NIL, "WM_SPOOLERSTATUS", "WM_DRAWITEM", "WM_MEASUREITEM", "WM_DELETEITEM", ;
                  "WM_VKEYTOITEM", "WM_CHARTOITEM", "WM_SETFONT", "WM_GETFONT", "WM_SETHOTKEY", ;
                  "WM_GETHOTKEY", NIL, NIL, NIL, "WM_QUERYDRAGICON", ;
                  NIL, "WM_COMPAREITEM", NIL, NIL, NIL, ;
                  "WM_GETOBJECT", NIL, NIL, NIL, "WM_COMPACTING", ;
                  NIL, NIL, "WM_COMMNOTIFY", NIL, "WM_WINDOWPOSCHANGING", ;
                  "WM_WINDOWPOSCHANGED", "WM_POWER", NIL, "WM_COPYDATA", "WM_CANCELJOURNAL", ;
                  NIL, NIL, "WM_NOTIFY", NIL, "WM_INPUTLANGCHANGEREQUEST", ;
                  "WM_INPUTLANGCHANGE", "WM_TCARD", "WM_HELP", "WM_USERCHANGED", "WM_NOTIFYFORMAT", ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, "WM_CONTEXTMENU", "WM_STYLECHANGING", "WM_STYLECHANGED", ;
                  "WM_DISPLAYCHANGE", "WM_GETICON", "WM_SETICON", "WM_NCCREATE", "WM_NCDESTROY", ;
                  "WM_NCCALCSIZE", "WM_NCHITTEST", "WM_NCPAINT", "WM_NCACTIVATE", "WM_GETDLGCODE", ;
                  "WM_SYNCPAINT", NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, "WM_NCMOUSEMOVE", ;
                  "WM_NCLBUTTONDOWN", "WM_NCLBUTTONUP", "WM_NCLBUTTONDBLCLK", "WM_NCRBUTTONDOWN", "WM_NCRBUTTONUP", ;
                  "WM_NCRBUTTONDBLCLK", "WM_NCMBUTTONDOWN", "WM_NCMBUTTONUP", "WM_NCMBUTTONDBLCLK", NIL, ;
                  "WM_NCXBUTTONDOWN", "WM_NCXBUTTONUP", "WM_NCXBUTTONDBLCLK" }
      ASize( aNames, 1024 )

      AEval( { "WM_KEYFIRST", ;
               "WM_KEYUP", "WM_CHAR", "WM_DEADCHAR", "WM_SYSKEYDOWN", "WM_SYSKEYUP", ;
               "WM_SYSCHAR", "WM_SYSDEADCHAR", "WM_KEYLAST", NIL, NIL, ;
               NIL, NIL, "WM_IME_STARTCOMPOSITION", "WM_IME_ENDCOMPOSITION", "WM_IME_COMPOSITION", ;
               "WM_INITDIALOG", "WM_COMMAND", "WM_SYSCOMMAND", "WM_TIMER", "WM_HSCROLL", ;
               "WM_VSCROLL", "WM_INITMENU", "WM_INITMENUPOPUP", NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               "WM_MENUSELECT", "WM_MENUCHAR", "WM_ENTERIDLE", "WM_MENURBUTTONUP", "WM_MENUDRAG", ;
               "WM_MENUGETOBJECT", "WM_UNINITMENUPOPUP", "WM_MENUCOMMAND", "WM_CHANGEUISTATE", "WM_UPDATEUISTATE", ;
               "WM_QUERYUISTATE", NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, "WM_CTLCOLORMSGBOX", ;
               "WM_CTLCOLOREDIT", "WM_CTLCOLORLISTBOX", "WM_CTLCOLORBTN", "WM_CTLCOLORDLG", "WM_CTLCOLORSCROLLBAR", ;
               "WM_CTLCOLORSTATIC" }, ;
             { |c,i| aNames[ i + 0x0FF ] := c } )

      AEval( { "WM_MOUSEMOVE", ;
               "WM_LBUTTONDOWN", "WM_LBUTTONUP", "WM_LBUTTONDBLCLK", "WM_RBUTTONDOWN", "WM_RBUTTONUP", ;
               "WM_RBUTTONDBLCLK", "WM_MBUTTONDOWN", "WM_MBUTTONUP", "WM_MBUTTONDBLCLK", "WM_MOUSEWHEEL", ;
               "WM_XBUTTONDOWN", "WM_XBUTTONUP", "WM_XBUTTONDBLCLK", NIL, NIL, ;
               "WM_PARENTNOTIFY", "WM_ENTERMENULOOP", "WM_EXITMENULOOP", "WM_NEXTMENU", "WM_SIZING", ;
               "WM_CAPTURECHANGED", "WM_MOVING", NIL, "WM_POWERBROADCAST", "WM_DEVICECHANGE", ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, "WM_MDICREATE", "WM_MDIDESTROY", "WM_MDIACTIVATE", "WM_MDIRESTORE", ;
               "WM_MDINEXT", "WM_MDIMAXIMIZE", "WM_MDITILE", "WM_MDICASCADE", "WM_MDIICONARRANGE", ;
               "WM_MDIGETACTIVE", NIL, NIL, NIL, NIL, ;
               NIL, NIL, "WM_MDISETMENU", "WM_ENTERSIZEMOVE", "WM_EXITSIZEMOVE", ;
               "WM_DROPFILES", "WM_MDIREFRESHMENU" }, ;
             { |c,i| aNames[ i + 0x1FF ] := c } )

      AEval( { "WM_IME_SETCONTEXT", "WM_IME_NOTIFY", "WM_IME_CONTROL", "WM_IME_COMPOSITIONFULL", "WM_IME_SELECT", ;
               "WM_IME_CHAR", NIL, "WM_IME_REQUEST", NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               "WM_IME_KEYDOWN", "WM_IME_KEYUP", NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, "WM_NCMOUSEHOVER", "WM_MOUSEHOVER", "WM_NCMOUSELEAVE", "WM_MOUSELEAVE" }, ;
             { |c,i| aNames[ i + 0x280 ] := c } )

      AEval( { "WM_CUT", ;
               "WM_COPY", "WM_PASTE", "WM_CLEAR", "WM_UNDO", "WM_RENDERFORMAT", ;
               "WM_RENDERALLFORMATS", "WM_DESTROYCLIPBOARD", "WM_DRAWCLIPBOARD", "WM_PAINTCLIPBOARD", "WM_VSCROLLCLIPBOARD", ;
               "WM_SIZECLIPBOARD", "WM_ASKCBFORMATNAME", "WM_CHANGECBCHAIN", "WM_HSCROLLCLIPBOARD", "WM_QUERYNEWPALETTE", ;
               "WM_PALETTEISCHANGING", "WM_PALETTECHANGED", "WM_HOTKEY", NIL, NIL, ;
               NIL, NIL, "WM_PRINT", "WM_PRINTCLIENT", "WM_APPCOMMAND" }, ;
             { |c,i| aNames[ i + 0x2FF ] := c } )

      aNames[ 0x358 ] := "WM_HANDHELDFIRST"
      aNames[ 0x35F ] := "WM_HANDHELDLAST"
      aNames[ 0x360 ] := "WM_AFXFIRST"
      aNames[ 0x37F ] := "WM_AFXLAST"
      aNames[ 0x380 ] := "WM_PENWINFIRST"
      aNames[ 0x38F ] := "WM_PENWINLAST"

      aNames[ 0x400 ] := "WM_USER"

      // Edit control messages
      AEval( { "EM_GETSEL", ;
               "EM_SETSEL", "EM_GETRECT", "EM_SETRECT", "EM_SETRECTNP", "EM_SCROLL", ;
               "EM_LINESCROLL", "EM_SCROLLCARET", "EM_GETMODIFY", "EM_SETMODIFY", "EM_GETLINECOUNT", ;
               "EM_LINEINDEX", "EM_SETHANDLE", "EM_GETHANDLE", "EM_GETTHUMB", NIL, ;
               NIL, "EM_LINELENGTH", "EM_REPLACESEL", NIL, "EM_GETLINE", ;
               "EM_SETLIMITTEXT", "EM_CANUNDO", "EM_UNDO", "EM_FMTLINES", "EM_LINEFROMCHAR", ;
               NIL, "EM_SETTABSTOPS", "EM_SETPASSWORDCHAR", "EM_EmptyUNDOBUFFER", "EM_GETFIRSTVISIBLELINE", ;
               "EM_SETREADONLY", "EM_SETWORDBREAKPROC", "EM_GETWORDBREAKPROC", "EM_GETPASSWORDCHAR", "EM_SETMARGINS", ;
               "EM_GETMARGINS", "EM_GETLIMITTEXT", "EM_POSFROMCHAR", "EM_CHARFROMPOS", "EM_SETIMESTATUS", ;
               "EM_GETIMESTATUS" }, ;
             { |c,i| aNames[ i + 0xAF ] := c } )

      // Scroll bar messages
      AEval( { "SBM_SETPOS", ;
               "SBM_GETPOS", "SBM_SETRANGE", "SBM_GETRANGE", "SBM_ENABLE_ARROWS", NIL, ;
               "SBM_SETRANGEREDRAW", NIL, NIL, "SBM_SETSCROLLINFO", "SBM_GETSCROLLINFO" }, ;
             { |c,i| aNames[ i + 0xDF ] := c } )

      // Button control messages
      AEval( { "BM_GETCHECK", ;
               "BM_SETCHECK", "BM_GETSTATE", "BM_SETSTATE", "BM_SETSTYLE", "BM_CLICK", ;
               "BM_GETIMAGE", "BM_SETIMAGE" }, ;
             { |c,i| aNames[ i + 0xEF ] := c } )

      // Static control messages
      AEval( { "STM_SETICON", ;
               "STM_GETICON", "STM_SETIMAGE", "STM_GETIMAGE", "STM_MSGMAX" }, ;
             { |c,i| aNames[ i + 0x16F ] := c } )
   ENDIF
   IF nMsg == 0
      cName := "WM_NULL"
   ELSEIF Len( aNames ) >= nMsg .AND. aNames[ nMsg ] != NIL
      cName := aNames[ nMsg ]
   ELSE
      cName := "(unknown_" + _OOHG_HEX( nMsg ) + ")"
   ENDIF

   RETURN cName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DebugMessageQuery( nMsg, wParam, lParam ) CLASS TWindow

   LOCAL cValue, oControl

   IF nMsg == WM_COMMAND
      oControl := GetControlObjectById( LOWORD( wParam ) )
      IF oControl:Id == 0
         oControl := GetControlObjectByHandle( lParam )
      ENDIF
      cValue := ::Name + "." + oControl:Name + ": WM_COMMAND." + ;
                oControl:DebugMessageNameCommand( HIWORD( wParam ) )
   ELSEIF nMsg == WM_NOTIFY
      cValue := GetControlObjectByHandle( GethWndFrom( lParam ) ):DebugMessageQueryNotify( ::Name, wParam, lParam )
   ELSEIF nMsg == WM_CTLCOLORBTN
      oControl := GetControlObjectByHandle( lParam )
      cValue := ::Name + "." + oControl:Name + ": WM_CTLCOLORBTN   0x" + _OOHG_HEX( wParam, 8 )
                oControl:DebugMessageNameCommand( HIWORD( wParam ) )
   ELSEIF nMsg == WM_CTLCOLORSTATIC
      oControl := GetControlObjectByHandle( lParam )
      cValue := ::Name + "." + oControl:Name + ": WM_CTLCOLORSTATIC   0x" + _OOHG_HEX( wParam, 8 )
                oControl:DebugMessageNameCommand( HIWORD( wParam ) )
   ELSEIF nMsg == WM_CTLCOLOREDIT
      oControl := GetControlObjectByHandle( lParam )
      cValue := ::Name + "." + oControl:Name + ": WM_CTLCOLOREDIT   0x" + _OOHG_HEX( wParam, 8 )
                oControl:DebugMessageNameCommand( HIWORD( wParam ) )
   ELSEIF nMsg == WM_CTLCOLORLISTBOX
      oControl := GetControlObjectByHandle( lParam )
      cValue := ::Name + "." + oControl:Name + ": WM_CTLCOLORLISTBOX   0x" + _OOHG_HEX( wParam, 8 )
   ELSE
      cValue := iif( ::lForm, "", ::Parent:Name + "." ) + ::Name + ": " + ;
                "(0x" + _OOHG_HEX( nMsg, 4 ) + ") " + ::DebugMessageName( nMsg ) + ;
                " 0x" + _OOHG_HEX( wParam, 8 ) + " 0x" + _OOHG_HEX( lParam, 8 )
   ENDIF

   RETURN cValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DebugMessageNameCommand( nCommand ) CLASS TWindow

   RETURN _OOHG_HEX( nCommand, 4 )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DebugMessageNameNotify( nNotify ) CLASS TWindow

   LOCAL cName
   STATIC aNames := NIL

   IF aNames == NIL
      aNames := { "NM_OUTOFMEMORY", "NM_CLICK", "NM_DBLCLK", "NM_RETURN", "NM_RCLICK", ;
                  "NM_RDBLCLK", "NM_SETFOCUS", "NM_KILLFOCUS", NIL, NIL, ;
                  NIL, "NM_CUSTOMDRAW", "NM_HOVER", "NM_NCHITTEST", "NM_KEYDOWN", ;
                  "NM_RELEASEDCAPTURE", "NM_SETCURSOR", "NM_CHAR", "NM_TOOLTIPSCREATED", "NM_LDOWN", ;
                  "NM_RDOWN" }
      ASize( aNames, 200 )

      // Scroll bar messages
      AEval( { "LVN_ITEMCHANGING", ;
               "LVN_ITEMCHANGED", "LVN_INSERTITEM", "LVN_DELETEITEM", "LVN_DELETEALLITEMS", "LVN_BEGINLABELEDITA", ;
               "LVN_ENDLABELEDITA", NIL, "LVN_COLUMNCLICK", "LVN_BEGINDRAG", NIL, ;
               "LVN_BEGINRDRAG", NIL, "LVN_ODCACHEHINT", "LVN_ITEMACTIVATE", "LVN_ODSTATECHANGED", ;
               NIL, NIL, NIL, NIL, NIL, ;
               "LVN_HOTTRACK", NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, "LVN_GETDISPINFOA", ;
               "LVN_SETDISPINFOA", "LVN_ODFINDITEMA", NIL, NIL, "LVN_KEYDOWN", ;
               "LVN_MARQUEEBEGIN", "LVN_GETINFOTIPA", "LVN_GETINFOTIPW", NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, NIL, ;
               NIL, NIL, NIL, NIL, "LVN_BEGINLABELEDITW", ;
               "LVN_ENDLABELEDITW", "LVN_GETDISPINFOW", "LVN_SETDISPINFOW", "LVN_ODFINDITEMW" }, ;
             { |c,i| aNames[ i + 99 ] := c } )
   ENDIF
   IF nNotify < 0
      nNotify := - nNotify
   ENDIF
   IF nNotify > 0 .AND. Len( aNames ) >= nNotify .AND. aNames[ nNotify ] != NIL
      cName := aNames[ nNotify ]
   ELSE
      cName := _OOHG_HEX( 65536 - nNotify, 4 )
   ENDIF

   RETURN cName

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DebugMessageQueryNotify( cParentName, wParam, lParam ) CLASS TWindow

   LOCAL cValue

   Empty( wParam )
   cValue := cParentName + "." + ;
             iif( Empty( ::Name ), _OOHG_HEX( GethWndFrom( lParam ), 8 ), ::Name ) + ;
             ": WM_NOTIFY." + ::DebugMessageNameNotify( GetNotifyCode( lParam ) )

   RETURN cValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Line( nRow, nCol, nToRow, nToCol, nWidth, aColor, nStyle ) CLASS TWindow

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1
   ::GetDC()
   C_LINE( ::hDC, nRow, nCol, nToRow, nToCol, nWidth, aColor[ 1 ], ;
      aColor[ 2 ], aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Fill( nRow, nCol, nToRow, nToCol, aColor ) CLASS TWindow

   DEFAULT aColor TO {0, 0, 0}
   ::GetDC()
    C_FILL( ::hDC, nRow, nCol, nToRow, nToCol, aColor[ 1 ], aColor[ 2 ], aColor[ 3 ], .T. )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Box( nRow, nCol, nToRow, nToCol, nWidth, aColor, nStyle, nBrStyle, aBrColor ) CLASS TWindow

   LOCAL lBrColor

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1

   IF Empty(aBrColor)
      aBrColor := {0, 0, 0}
      lBrColor := .F.
   ELSE
      lBrColor := .T.
   ENDIF

   ::GetDC()
   C_RECTANGLE( ::hDC, nRow, nCol, nToRow, nToCol, nWidth, aColor[ 1 ], aColor[ 2 ], ;
      aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle, ! Empty( nBrStyle ), nBrStyle, ;
      lBrColor, aBrColor[ 1 ], aBrColor[ 2 ], aBrColor[ 3 ] )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RoundBox( nRow, nCol, nToRow, nToCol, nWidth, aColor, lStyle, nStyle, nBrStyle, aBrColor ) CLASS TWindow

   LOCAL lBrushColor

   HB_SYMBOL_UNUSED( lStyle )

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1

   IF Empty( aBrColor )
      aBrColor := {0, 0, 0}
      lBrushColor := .F.
   ELSE
      lBrushColor := .T.
   ENDIF

   ::GetDC()
    C_ROUNDRECTANGLE( ::hDC, nRow, nCol, nToRow, nToCol, nWidth, aColor[ 1 ], aColor[ 2 ], ;
       aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle, ! Empty( nBrStyle ), ;
       nBrStyle, lBrushColor, aBrColor[ 1 ], aBrColor[ 2 ], aBrColor[ 3 ] )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Ellipse( nRow, nCol, nToRow, nToCol, nWidth, aColor, lStyle, nStyle, nBrStyle, aBrColor ) CLASS TWindow

   LOCAL lBrushColor

   HB_SYMBOL_UNUSED( lStyle )

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1

   IF Empty( aBrColor )
      aBrColor := {0, 0, 0}
      lBrushColor := .F.
   ELSE
      lBrushColor := .T.
   ENDIF

   ::GetDC()
    C_ELLIPSE(::hDC, nRow, nCol, nToRow, nToCol, nWidth, aColor[ 1 ], aColor[ 2 ], ;
       aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle, ! Empty( nBrStyle ), ;
       nBrStyle, lBrushColor, aBrColor[ 1 ], aBrColor[ 2 ], aBrColor[ 3 ] )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Arc( nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, aColor, nStyle ) CLASS TWindow

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1
   ::GetDC()
   C_ARC( ::hDC, nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, aColor[1], ;
      aColor[ 2 ], aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ArcTo( nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, aColor, nStyle ) CLASS TWindow

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1
   ::GetDC()
   C_ARCTO( ::hDC, nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, aColor[1], ;
      aColor[ 2 ], aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Chord( nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, aColor, nStyle, nBrStyle, aBrColor ) CLASS TWindow

   LOCAL lBrushColor

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1

   IF Empty( aBrColor )
      aBrColor := {0, 0, 0}
      lBrushColor := .F.
   ELSE
      lBrushColor := .T.
   ENDIF

   ::GetDC()
   C_CHORD( ::hDC, nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, aColor[1], ;
      aColor[ 2 ], aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle, ! Empty( nBrStyle ), ;
      nBrStyle, lBrushColor, aBrColor[ 1 ], aBrColor[ 2 ], aBrColor[ 3 ] )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Pie( nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, aColor, lStyle, nStyle, nBrStyle, aBrColor ) CLASS TWindow

   LOCAL lBrushColor

   HB_SYMBOL_UNUSED( lStyle )

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1

   IF Empty( aBrColor )
      aBrColor := {0, 0, 0}
      lBrushColor := .F.
   ELSE
      lBrushColor := .T.
   ENDIF

   ::GetDC()
    C_PIE( ::hDC, nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, aColor[ 1 ], ;
       aColor[ 2 ], aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle, ! Empty( nBrStyle ), ;
      nBrStyle, lBrushColor, aBrColor[ 1 ], aBrColor[ 2 ], aBrColor[ 3 ] )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PolyBezier( aPoints, nWidth, aColor, lStyle, nStyle ) CLASS TWindow

   LOCAL aPx := {}, aPy := {}

   HB_SYMBOL_UNUSED( lStyle )

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1

   AEval( aPoints, { |p| AAdd( aPx, p[ 2 ] ), AAdd( aPy, p[ 1 ] ) } )

   ::GetDC()
   C_POLYBEZIER( ::hDC, aPy, aPx, nWidth, aColor[ 1 ], aColor[ 2 ], aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PolyBezierTo( aPoints, nWidth, aColor, lStyle, nStyle ) CLASS TWindow

   LOCAL aPx := {}, aPy := {}

   HB_SYMBOL_UNUSED( lStyle )

   DEFAULT aColor TO {0, 0, 0}
   DEFAULT nWidth TO 1

   AEval( aPoints, { |p| AAdd( aPx, p[ 2 ] ), AAdd( aPy, p[ 1 ] ) } )

   ::GetDC()
   C_POLYBEZIERTO( ::hDC, aPy, aPx, nWidth, aColor[ 1 ], aColor[ 2 ], aColor[ 3 ], .T., .T., ! Empty( nStyle ), nStyle )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Polygon( aPoints, nWidth, aColor, lStyle, nStyle, nBrStyle, aBrColor, nFillMode ) CLASS TWindow

   LOCAL lBrushColor, aPx := {}, aPy := {}

   HB_SYMBOL_UNUSED( lStyle )

   DEFAULT aColor    TO {0, 0, 0}
   DEFAULT nWidth    TO 1
   DEFAULT nFillMode TO 1

   AEval( aPoints, { |p| AAdd( aPx, p[ 2 ] ), AAdd( aPy, p[ 1 ] ) } )

   IF Empty( aBrColor )
      aBrColor := {0, 0, 0}
      lBrushColor := .F.
   ELSE
      lBrushColor := .T.
   ENDIF

   ::GetDC()
   C_POLYGON( ::hDC, aPy, aPx, nWidth, aColor[ 1 ], aColor[ 2 ], aColor[ 3 ], .T., ;
      .T., ! Empty( nStyle ), nStyle, ! Empty( nBrStyle ), nBrStyle, lBrushColor, ;
      aBrColor[ 1 ], aBrColor[ 2 ], aBrColor[ 3 ], nFillMode )
   ::ReleaseDC()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_AddFrame( oFrame )

   TApplication():Define():ActiveFramePush( oFrame )

   RETURN oFrame

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_DeleteFrame( cType )

   LOCAL oCtrl

   IF _OOHG_ActiveFrame == NIL
      // ERROR: No FRAME started
      RETURN .F.
   ENDIF
   oCtrl := _OOHG_ActiveFrame
   IF oCtrl:Type == cType
      TApplication():Define():ActiveFramePop()
   ELSE
      // ERROR: No FRAME started
      RETURN .F.
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_LastFrame()

   LOCAL cRet

   IF _OOHG_ActiveFrame == NIL
      cRet := ""
   ELSE
      cRet := _OOHG_ActiveFrame:Type
   ENDIF

   RETURN cRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_SelectSubClass( oClass, oSubClass, bAssign )

   LOCAL oObj

   oObj := iif( ValType( oSubClass ) == "O", oSubClass, oClass )
   IF ValType( bAssign ) == "B"
      EVAL( bAssign, oObj )
   ENDIF

   RETURN oObj

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION InputBox( cInputPrompt, cDialogCaption, cDefaultValue, nTimeout, cTimeoutValue, lMultiLine, nMaxLength )

   LOCAL RetVal, mo, oWin

   ASSIGN cInputPrompt   VALUE cInputPrompt   TYPE "C" DEFAULT ""
   ASSIGN cDialogCaption VALUE cDialogCaption TYPE "C" DEFAULT ""
   ASSIGN cDefaultValue  VALUE cDefaultValue  TYPE "C" DEFAULT ""
   ASSIGN nTimeout       VALUE nTimeout       TYPE "N" DEFAULT 0
   ASSIGN cTimeoutValue  VALUE cTimeoutValue  TYPE "C" DEFAULT NIL
   ASSIGN lMultiLine     VALUE lMultiLine     TYPE "L" DEFAULT .F.
   ASSIGN nMaxLength     VALUE nMaxLength     TYPE "N" DEFAULT 0

   RetVal := ''

   IF lMultiLine
      mo := 150
   ELSE
      mo := 0
   ENDIF

   DEFINE WINDOW 0 OBJ oWin ;
      AT 0, 0 ;
      WIDTH 350 ;
      HEIGHT 115 + mo + GetTitleHeight() ;
      TITLE cDialogCaption ;
      MODAL ;
      NOSIZE ;
      FONT 'Arial' ;
      SIZE 10 ;
      BACKCOLOR ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      ON KEY ESCAPE ACTION ( _OOHG_DialogCancelled := .T., iif( oWin:Active, oWin:Release(), NIL ) )

      @ 07, 10 LABEL _Label ;
         VALUE cInputPrompt ;
         WIDTH 280

      IF lMultiLine
         IF nMaxLength > 0
            @ 30, 10 EDITBOX _TextBox ;
               VALUE cDefaultValue ;
               HEIGHT 26 + mo ;
               WIDTH 320 ;
               MAXLENGTH nMaxLength
         ELSE
            @ 30, 10 EDITBOX _TextBox ;
               VALUE cDefaultValue ;
               HEIGHT 26 + mo ;
               WIDTH 320
         ENDIF
      ELSE
         IF nMaxLength > 0
            @ 30, 10 TEXTBOX _TextBox ;
               VALUE cDefaultValue ;
               HEIGHT 26 + mo ;
               WIDTH 320 ;
               ON ENTER ( _OOHG_DialogCancelled := .F., RetVal := oWin:_TextBox:Value, iif( oWin:Active, oWin:Release(), NIL ) ) ;
               MAXLENGTH nMaxLength
         ELSE
            @ 30, 10 TEXTBOX _TextBox ;
               VALUE cDefaultValue ;
               HEIGHT 26 + mo ;
               WIDTH 320 ;
               ON ENTER ( _OOHG_DialogCancelled := .F., RetVal := oWin:_TextBox:Value, iif( oWin:Active, oWin:Release(), NIL ) )
         ENDIF
      ENDIF

      @ 67 + mo, 120 BUTTON _Ok ;
         CAPTION _OOHG_Messages( MT_MISCELL, 6 ) ;
         ACTION ( _OOHG_DialogCancelled := .F., RetVal := oWin:_TextBox:Value, iif( oWin:Active, oWin:Release(), NIL ) )

      @ 67 + mo, 230 BUTTON _Cancel ;
         CAPTION _OOHG_Messages( MT_MISCELL, 7 ) ;
         ACTION ( _OOHG_DialogCancelled := .T., iif( oWin:Active, oWin:Release(), NIL ) )

      IF nTimeout > 0
         IF cTimeoutValue == NIL
            DEFINE TIMER _InputBox ;
               INTERVAL nTimeout ;
               ACTION oWin:Release()
         ELSE
            DEFINE TIMER _InputBox ;
               INTERVAL nTimeout ;
               ACTION  ( RetVal := cTimeoutValue, iif( oWin:Active, oWin:Release(), NIL ) )
         ENDIF
      ENDIF
   END WINDOW

   oWin:_TextBox:SetFocus()
   oWin:Center()
   owin:Activate()

   RETURN RetVal

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetWindowRgn( name, col, row, w, h, lx )

   RETURN C_SETWINDOWRGN( GetFormHandle( name ), col, row, w, h, lx )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetPolyWindowRgn( name, apoints, lx )

   LOCAL apx := {}, apy := {}

   AEval( apoints, {|x| AAdd( apx, x[ 1 ] ), AAdd(apy, x[ 2 ] ) } )

   RETURN C_SETPOLYWINDOWRGN( GetFormHandle( name ), apx, apy, lx )

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _SetNextFocus()

   LOCAL oCtrl, hControl

   hControl := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), .F. )
   oCtrl := GetControlObjectByHandle( hControl )
   IF oCtrl:hWnd == hControl
      oCtrl:SetFocus()
   ELSE
      InsertTab()
   ENDIF

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _SetPrevFocus()

   LOCAL oCtrl, hControl

   hControl := GetNextDlgTabITem( GetActiveWindow(), GetFocus(), .T. )
   oCtrl := GetControlObjectByHandle( hControl )
   IF oCtrl:hWnd == hControl
      oCtrl:SetFocus()
   ELSE
      InsertShiftTab()
   ENDIF

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION SetAppHotKeyByName( cKey, bAction )

   LOCAL aKey, bCode

   aKey := _DetermineKey( cKey )
   IF aKey[ 1 ] != 0
      bCode := SetAppHotKey( aKey[ 1 ], aKey[ 2 ], bAction )
   ELSE
      bCode := NIL
   ENDIF

   RETURN bCode

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_MacroCall( cMacro )

   LOCAL uRet, oError

   oError := ErrorBlock()
   ErrorBlock( { |e| _OOHG_MacroCall_Error( e ) } )
   BEGIN SEQUENCE
      uRet := &cMacro
   RECOVER
      uRet := NIL
   END SEQUENCE
   ErrorBlock( oError )

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION _OOHG_MacroCall_Error( oError )

   IF ! Empty( oError )
      BREAK oError
   ENDIF

   RETURN 1

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ExitProcess( nExit )

   dbCloseAll()
   IF HB_ISOBJECT( TApplication():Define() )
      TApplication():Define():Release()
   ENDIF

   RETURN _ExitProcess2( nExit )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_UsesVisualStyle()

   RETURN ( GetComCtl32Version() >= 6 .AND. IsAppThemed() )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetFontList( hDC, cFontFamilyName, nCharSet, nPitch, nFontType, lSortCaseSensitive, aFontName )

   LOCAL SortCodeBlock, aFontList, i

   IF HB_ISLOGICAL( lSortCaseSensitive ).AND. lSortCaseSensitive
      SortCodeBlock := { |x, y| x[ 1 ] < y[ 1 ] }
   ELSE
      SortCodeBlock := { |x, y| Upper( x[ 1 ] ) < Upper( y[ 1 ] ) }
   ENDIF

   /*
    * EnumFontsEx RETURNs aFontList: { { cFontName, nCharSet, nPitchAndFamily, nFontType }, ... }
    * with the details of the fonts that match the parameters.
    * It also RETURNs, by reference, aFontName: { cFontName1, cFontName2, ... }
    *
    * See i_font.ch for nCharSet and nPitch parameters values.
    * Set the parameters to NIL to avoid filtering for that parameter.
    * When hDC is NIL, the screen DC is assumed.
    */
   aFontList := EnumFontsEx( hDC, cFontFamilyName, nCharSet, nPitch, NIL, SortCodeBlock, @aFontName )

   IF HB_ISNUMERIC( nFontType )
      i := Len( aFontList )
      DO WHILE i > 0
         IF aFontList[ i, 4 ] # nFontType
            ADel( aFontList, i )
            ASize( aFontList, i - 1 )
            ADel( aFontName, i )
            ASize( aFontName, i - 1 )
         ENDIF
         i --
      ENDDO
   ENDIF

   RETURN aFontList

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_GetArrayItem( uaArray, nItem, uExtra1, uExtra2 )

   LOCAL uRet

   IF ! HB_ISARRAY( uaArray )
      uRet := uaArray
   ELSEIF Len( uaArray ) >= nItem .AND. nItem >= 1
      uRet := uaArray[ nItem ]
   ELSE
      uRet := NIL
   ENDIF
   IF HB_ISBLOCK( uRet )
      uRet := Eval( uRet, nItem, uExtra1, uExtra2 )
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_DeleteArrayItem( aArray, nItem )

#ifdef __XHARBOUR__
   RETURN ADel( aArray, nItem, .T. )
#else
   IF HB_ISARRAY( aArray ) .AND. Len( aArray ) >= nItem
      ADel( aArray, nItem )
      ASize( aArray, Len( aArray ) - 1 )
   ENDIF

   RETURN aArray
#endif

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_SetKey( aKeys, nKey, nFlags, bAction, nId )

   LOCAL nPos, uRet := NIL

   nPos := AScan( aKeys, { |a| a[ HOTKEY_KEY ] == nKey .AND. a[ HOTKEY_MOD ] == nFlags } )
   IF nPos > 0
      uRet := aKeys[ nPos ][ HOTKEY_ACTION ]
   ENDIF
   IF PCount() > 3
      IF HB_ISBLOCK( bAction )
         IF ! HB_ISNUMERIC( nId )
            nId := 0
         ENDIF
         IF nPos > 0
            aKeys[ nPos ] := { nId, nFlags, nKey, bAction }
         ELSE
            AAdd( aKeys, { nId, nFlags, nKey, bAction } )
         ENDIF
      ELSE
         IF nPos > 0
            _OOHG_DeleteArrayItem( aKeys, nPos )
         ENDIF
      ENDIF
   ENDIF

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _OOHG_CallDump( uTitle, cOutput )

   LOCAL nLevel, cText, oLog

   cText := ""
   nLevel := 1
   DO WHILE ! Empty( ProcName( nLevel ) )
      IF nLevel > 1
         cText += Chr( 13 ) + Chr( 10 )
      ENDIF
      cText += ProcName( nLevel ) + ;
               " (" + ;
               AllTrim( Str( ProcLine( nLevel ) ) ) + ;
               ")" + ;
               iif( Empty( ProcFile( nLevel ) ), "", " in " + ProcFile( nLevel ) )
      nLevel ++
   ENDDO

   ASSIGN cOutput VALUE cOutput TYPE "C" DEFAULT "S"
   cOutPut := Left( cOutPut, 1 )
   IF cOutput $ "FB"        // To File or Both
      oLog := OOHG_TErrorTxt():New()
      oLog:FileName := "DumpLog.txt"
      oLog:Write( AutoType( uTitle ) )
      oLog:Write( "" )
      oLog:Write( cText )
      oLog:Write( "" )
      oLog:Write( Replicate( "-", 40 ) )
      oLog:CreateLog()
   ENDIF
   IF cOutput $ "BS"        // To File or Screen
      MSGINFO( cText, AutoType( uTitle ) )
   ENDIF

   RETURN


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TDynamicValues

   DATA oWnd

   METHOD New
   ERROR HANDLER Error

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD New( oWnd ) CLASS TDynamicValues

   ::oWnd := oWnd

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Error( xParam ) CLASS TDynamicValues

   LOCAL nPos, cMessage

   cMessage := __GetMessage()

   IF PCount() >= 1 .AND. Left( cMessage, 1 ) == "_"
      nPos := AScan( ::oWnd:aControlsNames, SubStr( cMessage, 2 ) + Chr( 255 ) )
      IF nPos > 0
         RETURN ( ::oWnd:aControls[ nPos ]:Value := xParam )
      ENDIF
      nPos := AScan( ::oWnd:aProperties, { |a| "_" + a[ 1 ] == cMessage } )
      IF nPos > 0
         ::oWnd:aProperties[ nPos ][ 2 ] := xParam
         RETURN ::oWnd:aProperties[ nPos ][ 2 ]
      ENDIF
   ELSE
      nPos := AScan( ::oWnd:aControlsNames, cMessage + Chr( 255 ) )
      IF nPos > 0
         RETURN ::oWnd:aControls[ nPos ]:Value
      ENDIF
      nPos := AScan( ::oWnd:aProperties, { |a| a[ 1 ] == cMessage } )
      IF nPos > 0
         RETURN ::oWnd:aProperties[ nPos ][ 2 ]
      ENDIF
   ENDIF

   RETURN ::MsgNotFound( cMessage )

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#ifndef WINVER
   #define WINVER 0x0501
#endif
#if ( WINVER < 0x0501 )
   #undef WINVER
   #define WINVER 0x0501
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif

#include <windows.h>
#include <commctrl.h>
#include <olectl.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include "hbvm.h"
#include "hbstack.h"
#include "oohg.h"

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )  ( ( pDynSym )->pSymbol )
#endif

static INT _OOHG_ShowContextMenus = 1;      // TODO: Thread safe ?
static BOOL _OOHG_NestedSameEvent = FALSE;  // TRUE allows event nesting
static INT _OOHG_MouseCol = 0;              // TODO: Thread safe ?
static INT _OOHG_MouseRow = 0;              // TODO: Thread safe ?

/*--------------------------------------------------------------------------------------------------------------------------------*/
VOID _OOHG_SetMouseCoords( PHB_ITEM pSelf, INT iCol, INT iRow )
{
   PHB_ITEM pSelf2;

   pSelf2 = hb_itemNew( NULL );
   hb_itemCopy( pSelf2, pSelf );

   _OOHG_Send( pSelf2, s_ColMargin );
   hb_vmSend( 0 );
   _OOHG_MouseCol = iCol - hb_parni( -1 );

   _OOHG_Send( pSelf2, s_RowMargin );
   hb_vmSend( 0 );
   _OOHG_MouseRow = iRow - hb_parni( -1 );

   hb_itemRelease( pSelf2 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_SETMOUSECOORDS )          /* FUNCTION _OOHG_SetmouseCoords( nCol, nRow ) -> NIL */
{
   _OOHG_SetMouseCoords( ( PHB_ITEM ) hb_param( 1, HB_IT_ARRAY ), hb_parni( 2 ), hb_parni( 3 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_SETHWND )          /* METHOD SethWnd( hWnd ) CLASS TWindow -> hWnd */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 && HB_ISNUM( 1 ) )
   {
      oSelf->hWnd = HWNDparam( 1 );
   }

   HWNDret( oSelf->hWnd );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_RELEASE )          /* METHOD Release() CLASS TWindow -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HDC hdc;
   HBRUSH OldBrush;

   // ImageList
   ImageList_Destroy( oSelf->ImageList );
   oSelf->ImageList = NULL;

   // Auxiliar Buffer
   if( oSelf->AuxBuffer )
   {
      hb_xfree( oSelf->AuxBuffer );
      oSelf->AuxBuffer = NULL;
      oSelf->AuxBufferLen = 0;
   }

   // Icon handle
   DeleteObject( oSelf->IconHandle );
   oSelf->IconHandle = NULL;

   // Brush handle
   if( ValidHandler( oSelf->hWnd ) )
   {
      hdc = GetDC( oSelf->hWnd );
      if( ValidHandler( hdc ) )
      {
         OldBrush = SelectObject( hdc, oSelf->OriginalBrush );
         DeleteObject( OldBrush );
         DeleteObject( oSelf->BrushHandle );
         oSelf->BrushHandle = NULL;
         ReleaseDC( oSelf->hWnd, hdc );
      }
   }

   // Font handle
   DeleteObject( oSelf->hFontHandle );
   oSelf->hFontHandle = NULL;

   // Context menu
   _OOHG_Send( pSelf, s_ContextMenu );
   hb_vmSend( 0 );
   if( hb_param( -1, HB_IT_OBJECT ) )
   {
      _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Release );
      hb_vmSend( 0 );
      _OOHG_Send( pSelf, s__ContextMenu );
      hb_vmPushNil();
      hb_vmSend( 1 );
   }

   // ::hWnd := -1
   oSelf->hWnd = ( HWND )( ~0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_STARTINFO )          /* METHOD StartInfo( hWnd ) CLASS TWindow -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   oSelf->hWnd = HWNDparam( 1 );

   oSelf->lFontColor = -1;
   oSelf->lBackColor = -1;
   oSelf->lFontColorSelected = -1;
   oSelf->lBackColorSelected = -1;
   oSelf->lOldBackColor = -1;
   oSelf->lUseBackColor = -1;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_SETFOCUS )          /* METHOD SetFocus( hWnd ) CLASS TWindow -> Self */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   PHB_ITEM pReturn;

   if( ValidHandler( oSelf->hWnd ) )
   {
      SetFocus( oSelf->hWnd );
   }

   pReturn = hb_itemNew( NULL );
   hb_itemCopy( pReturn, pSelf );
   hb_itemReturn( pReturn );
   hb_itemRelease( pReturn );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_IMAGELIST )          /* METHOD Imagelist( handle ) CLASS TWindow -> handle */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      HIMAGELIST hImageList = ( HIMAGELIST ) HB_PARNL( 1 );

      if( oSelf->ImageList )
      {
         ImageList_Destroy( oSelf->ImageList );
      }
      oSelf->ImageList = hImageList;
   }

   HB_RETNL( ( LONG_PTR ) oSelf->ImageList );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_ICONHANDLE )          /* METHOD IconHandle( hIcon ) CLASS TWindow -> hIcon */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      HICON hIcon = ( HICON ) HB_PARNL( 1 );

      if( oSelf->IconHandle )
      {
         DeleteObject( oSelf->IconHandle );
      }
      oSelf->IconHandle = hIcon;
   }

   HB_RETNL( ( LONG_PTR ) oSelf->IconHandle );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_BRUSHHANDLE )          /* METHOD BrushHandle( hBrush ) CLASS TWindow -> hBrush */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      HBRUSH hBrush = ( HBRUSH ) HB_PARNL( 1 );

      if( oSelf->BrushHandle )
      {
         DeleteObject( oSelf->BrushHandle );
      }
      oSelf->BrushHandle = hBrush;
   }

   HB_RETNL( ( LONG_PTR ) oSelf->BrushHandle );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_FONTHANDLE )          /* METHOD FontHandle( hFont ) CLASS TWindow -> hFont */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      HFONT hFont = ( HFONT ) HB_PARNL( 1 );

      if( oSelf->hFontHandle )
      {
         DeleteObject( oSelf->hFontHandle );
      }
      oSelf->hFontHandle = hFont;
   }

   HB_RETNL( ( LONG_PTR ) oSelf->hFontHandle );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_FONTCOLOR )          /* METHOD FontColor( uColor ) CLASS TWindow -> aColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_FONTCOLORCODE )          /* METHOD FontColor( uColor ) CLASS TWindow -> nColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      if( ! _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor ) )
      {
         oSelf->lFontColor = -1;
      }
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   hb_retnl( oSelf->lFontColor );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_BACKCOLOR )          /* METHOD BackColor( uColor ) CLASS TWindow -> aColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_BACKCOLORCODE )          /* METHOD BackColorCode( uColor ) CLASS TWindow -> nColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( hb_pcount() >= 1 )
   {
      if( ! _OOHG_DetermineColor( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor ) )
      {
         oSelf->lBackColor = -1;
      }
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   hb_retnl( oSelf->lBackColor );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_FONTCOLORSELECTED )          /* METHOD FontColorSelected( uColor ) CLASS TWindow -> aColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColorSelected, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_BACKCOLORSELECTED )          /* METHOD BackColorSelected( uColor ) CLASS TWindow -> aColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColorSelected, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_BACKBITMAP )          /* METHOD BackBitmap( hBitmap ) CLASS TWindow -> hBrush */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   HBITMAP hBitMap;

   hBitMap = ( HBITMAP ) HWNDparam( 1 );
   if( ValidHandler( hBitMap ) )
   {
      if( oSelf->BrushHandle )
      {
         DeleteObject( oSelf->BrushHandle );
      }
      oSelf->BrushHandle = CreatePatternBrush( hBitMap );
   }

   HB_RETNL( ( LONG_PTR ) oSelf->BrushHandle );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_CAPTION )          /* METHOD Caption( cCaption ) CLASS TWindow -> cCaption */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   INT iLen;
   LPTSTR cText;

   if( HB_ISCHAR( 1 ) )
   {
      SetWindowText( oSelf->hWnd, ( LPCTSTR ) hb_parc( 1 ) );
   }

   iLen = GetWindowTextLength( oSelf->hWnd ) + 1;
   cText = ( LPTSTR ) hb_xgrab( iLen );
   GetWindowText( oSelf->hWnd, cText, iLen );
   hb_retc( cText );
   hb_xfree( cText );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_ACCEPTFILES )          /* METHOD AcceptFiles( lOnOff ) CLASS TWindow -> lOnOff */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( HB_ISLOG( 1 ) )
   {
      DragAcceptFiles( oSelf->hWnd, hb_parl( 1 ) );
   }

   hb_retl( ( GetWindowLongPtr( oSelf->hWnd, GWL_EXSTYLE ) & WS_EX_ACCEPTFILES ) == WS_EX_ACCEPTFILES );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static UINT _OOHG_ListBoxDragNotification = 0;            // It's thread safe because is set only once.

HB_FUNC( _GETDDLMESSAGE )          /* FUNCTION _GetDDLMessage() -> NIL */
{
   if( ! _OOHG_ListBoxDragNotification )
   {
      _OOHG_ListBoxDragNotification = ( UINT ) RegisterWindowMessage( DRAGLISTMSGSTRING );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TWINDOW_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TWindow -> nRet */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) HB_PARNL( 3 );
   LPARAM lParam  = ( LPARAM ) HB_PARNL( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_CTLCOLORBTN:
      case WM_CTLCOLORSTATIC:
         _OOHG_Send( _OOHG_GetExistingObject( ( HWND ) lParam, FALSE, TRUE ), s_Events_Color );
         hb_vmPushNumInt( wParam );
         hb_vmPushLong( COLOR_3DFACE );
         hb_vmPushNil();
         hb_vmSend( 3 );
         break;

      case WM_CTLCOLOREDIT:
      case WM_CTLCOLORLISTBOX:
         _OOHG_Send( _OOHG_GetExistingObject( ( HWND ) lParam, FALSE, TRUE ), s_Events_Color );
         hb_vmPushNumInt( wParam );
         hb_vmPushLong( COLOR_WINDOW );
         hb_vmPushNil();
         hb_vmSend( 3 );
         break;

      case WM_NOTIFY:
         _OOHG_Send( GetControlObjectByHandle( ( ( NMHDR FAR * ) lParam )->hwndFrom, TRUE ), s_Events_Notify );
         hb_vmPushNumInt( wParam );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 2 );
         break;

      case WM_COMMAND:
         // See https://support.microsoft.com/en-us/help/102589/how-to-use-the-enter-key-from-edit-controls-in-a-dialog-box
         if( wParam == IDOK )
         {
            // Enter key
            _OOHG_Send( _OOHG_GetExistingObject( GetFocus(), TRUE, TRUE ), s_Events_Enter );
            hb_vmSend( 0 );
         }
         else
         {
            if( lParam )
            {
               // From control by handle
               _OOHG_Send( _OOHG_GetExistingObject( ( HWND ) lParam, FALSE, TRUE ), s_Events_Command );
               hb_vmPushNumInt( wParam );
               hb_vmSend( 1 );
            }
            else
            {
               PHB_ITEM pControl, pOnClick;

               pControl = hb_itemNew( NULL );
               hb_itemCopy( pControl, GetControlObjectById( LOWORD( wParam ), hWnd ) );
               _OOHG_Send( pControl, s_Id );
               hb_vmSend( 0 );
               if( hb_parni( -1 ) != 0 )
               {
                  // From menu by Iid
                  BOOL bClicked = 0;

                  _OOHG_Send( pControl, s_NestedClick );
                  hb_vmSend( 0 );
                  if( ! hb_parl( -1 ) )
                  {
                     _OOHG_Send( pControl, s__NestedClick );
                     hb_vmPushLogical( ! _OOHG_NestedSameEvent );
                     hb_vmSend( 1 );

                     _OOHG_Send( pControl, s_OnClick );
                     hb_vmSend( 0 );
                     if( hb_param( -1, HB_IT_BLOCK ) )
                     {
                        pOnClick = hb_itemNew( NULL );
                        hb_itemCopy( pOnClick, hb_param( -1, HB_IT_ANY ) );
                        _OOHG_Send( pControl, s_DoEvent );
                        hb_vmPush( pOnClick );
                        hb_vmPushString( "CLICK", 5 );
                        EndMenu();
                        hb_vmSend( 2 );
                        hb_itemRelease( pOnClick );
                        bClicked = 1;
                     }

                     _OOHG_Send( pControl, s__NestedClick );
                     hb_vmPushLogical( 0 );
                     hb_vmSend( 1 );
                  }
                  hb_itemRelease( pControl );
                  if( bClicked )
                  {
                     hb_retni( 1 );
                  }
                  else
                  {
                     hb_ret();
                  }
               }
            }
         }
         break;

      case WM_TIMER:
         _OOHG_Send( GetControlObjectById( LOWORD( wParam ), hWnd ), s_Events_TimeOut );
         hb_vmSend( 0 );
         hb_ret();
         break;

      case WM_DRAWITEM:
         if( wParam )
         {
            // ComboBox and ListBox
            _OOHG_Send( GetControlObjectByHandle( ( ( LPDRAWITEMSTRUCT ) lParam )->hwndItem, TRUE ), s_Events_DrawItem );
         }
         else
         {
            // Menu
            _OOHG_Send( GetControlObjectById( ( ( MYITEM * ) ( ( ( LPDRAWITEMSTRUCT ) lParam )->itemData ) )->id, hWnd ), s_Events_DrawItem );
         }
         hb_vmPushNumInt( lParam );
         hb_vmSend( 1 );
         break;

      case WM_MEASUREITEM:
         if( wParam )
         {
            // ComboBox and ListBox
            _OOHG_Send( GetControlObjectById( ( LONG ) ( ( ( LPMEASUREITEMSTRUCT ) lParam )->CtlID ), hWnd ), s_Events_MeasureItem );
         }
         else
         {
            // Menu
            _OOHG_Send( GetControlObjectById( ( ( MYITEM * ) ( ( ( LPMEASUREITEMSTRUCT ) lParam )->itemData ) )->id, hWnd ), s_Events_MeasureItem );
         }
         hb_vmPushNumInt( lParam );
         hb_vmSend( 1 );
         break;

      case WM_CONTEXTMENU:
         if( _OOHG_ShowContextMenus )
         {
            PHB_ITEM pControl, pContext;

            // Sets mouse coords
            _OOHG_SetMouseCoords( pSelf, LOWORD( lParam ), HIWORD( lParam ) );

            SetFocus( ( HWND ) wParam );
            pControl = GetControlObjectByHandle( ( HWND ) wParam, TRUE );

            // Check if control have context menu
            _OOHG_Send( pControl, s_ContextMenu );
            hb_vmSend( 0 );
            pContext = hb_param( -1, HB_IT_OBJECT );
            if( ! pContext )
            {
               // TODO: Check for CONTEXTMENU at container control...

               // Check if form have context menu
               _OOHG_Send( pSelf, s_ContextMenu );
               hb_vmSend( 0 );
               pContext = hb_param( -1, HB_IT_OBJECT );
            }

            // If there's a context menu, show it
            if( pContext )
            {
               _OOHG_Send( pContext, s_Activate );
               hb_vmPushLong( HIWORD( lParam ) );
               hb_vmPushLong( LOWORD( lParam ) );
               hb_vmSend( 2 );
               hb_retni( 1 );
            }
            else
            {
               hb_ret();
            }
         }
         else
         {
            hb_ret();
         }
         break;

      case WM_INITMENUPOPUP:
         if( ! HIWORD( lParam ) )
         {
            _OOHG_Send( GetControlObjectByHandle( ( HWND ) ( HMENU ) wParam, TRUE ), s_Events_InitMenuPopUp );
            hb_vmPushLong( ( LONG ) LOWORD( lParam ) );
            hb_vmSend( 1 );
         }
         break;

      case WM_MENUSELECT:
         if( ( HIWORD( wParam ) & MF_SYSMENU ) != MF_SYSMENU )
         {
            if( ( HIWORD( wParam ) & MF_HILITE ) == MF_HILITE )
            {
               if( ( HIWORD( wParam ) & MF_POPUP ) == MF_POPUP )
               {
                  MENUITEMINFO MenuItemInfo;
                  PHB_ITEM pMenu = hb_itemNew( NULL );
                  hb_itemCopy( pMenu, GetControlObjectByHandle( ( HWND ) lParam, TRUE ) );
                  _OOHG_Send( pMenu, s_hWnd );
                  hb_vmSend( 0 );
                  if( ValidHandler( HWNDparam( -1 ) ) )
                  {
                     memset( &MenuItemInfo, 0, sizeof( MenuItemInfo ) );
                     MenuItemInfo.cbSize = sizeof( MenuItemInfo );
                     MenuItemInfo.fMask = MIIM_ID | MIIM_SUBMENU;
                     GetMenuItemInfo( ( HMENU ) lParam, LOWORD( wParam ), MF_BYPOSITION, &MenuItemInfo );
                     if( MenuItemInfo.hSubMenu )
                     {
                        hb_itemCopy( pMenu, GetControlObjectByHandle( ( HWND ) MenuItemInfo.hSubMenu, TRUE ) );
                     }
                     else
                     {
                        hb_itemCopy( pMenu, GetControlObjectById( MenuItemInfo.wID, hWnd ) );
                     }
                     _OOHG_Send( pMenu, s_Events_MenuHilited );
                     hb_vmSend( 0 );
                  }
                  hb_itemRelease( pMenu );
               }
               else
               {
                  PHB_ITEM pControl = hb_itemNew( NULL );
                  hb_itemCopy( pControl, GetControlObjectById( ( LONG ) LOWORD( wParam ), hWnd ) );
                  _OOHG_Send( pControl, s_ContextMenu );
                  hb_vmSend( 0 );
                  if( hb_param( -1, HB_IT_OBJECT ) )
                  {
                     hb_itemCopy( pControl, hb_param( -1, HB_IT_OBJECT ) );
                     _OOHG_Send( pControl, s_Events_MenuHilited );
                     hb_vmSend( 0 );
                  }
                  hb_itemRelease( pControl );
               }
            }
         }
         break;

      case WM_MENURBUTTONUP:
         {
            PHB_ITEM pMenu;
            MENUITEMINFO MenuItemInfo;
            POINT Point;

            pMenu = hb_itemNew( NULL );
            hb_itemCopy( pMenu, GetControlObjectByHandle( ( HWND ) lParam, TRUE ) );
            _OOHG_Send( pMenu, s_hWnd );
            hb_vmSend( 0 );
            if( ValidHandler( HWNDparam( -1 ) ) )
            {
               memset( &MenuItemInfo, 0, sizeof( MenuItemInfo ) );
               MenuItemInfo.cbSize = sizeof( MenuItemInfo );
               MenuItemInfo.fMask = MIIM_ID | MIIM_SUBMENU;
               GetMenuItemInfo( ( HMENU ) lParam, wParam, MF_BYPOSITION, &MenuItemInfo );
               if( MenuItemInfo.hSubMenu )
               {
                  hb_itemCopy( pMenu, GetControlObjectByHandle( ( HWND ) MenuItemInfo.hSubMenu, TRUE ) );
               }
               else
               {
                  hb_itemCopy( pMenu, GetControlObjectById( MenuItemInfo.wID, hWnd ) );
               }
               _OOHG_Send( pMenu, s_ContextMenu );
               hb_vmSend( 0 );
               if( hb_param( -1, HB_IT_OBJECT ) )
               {
                  hb_itemCopy( pMenu, hb_param( -1, HB_IT_OBJECT ) );
                  GetCursorPos( &Point );
                  _OOHG_Send( pMenu, s_hWnd );
                  hb_vmSend( 0 );
                  TrackPopupMenuEx( HMENUparam( -1 ), TPM_RECURSE, Point.x, Point.y, hWnd, 0 );
                  PostMessage( hWnd, WM_NULL, 0, 0 );
               }
            }
            hb_itemRelease( pMenu );
            hb_ret();
         }
         break;

      case WM_HSCROLL:
         if( lParam )
         {
            _OOHG_Send( GetControlObjectByHandle( ( HWND ) lParam, TRUE ), s_Events_HScroll );
            hb_vmPushNumInt( wParam );
            hb_vmSend( 1 );
         }
         else
         {
            _OOHG_Send( pSelf, s_Events_HScroll );
            hb_vmPushNumInt( wParam );
            hb_vmSend( 1 );
         }
         break;

      case WM_VSCROLL:
         if( lParam )
         {
            _OOHG_Send( GetControlObjectByHandle( ( HWND ) lParam, TRUE ), s_Events_VScroll );
            hb_vmPushNumInt( wParam );
            hb_vmSend( 1 );
         }
         else
         {
            _OOHG_Send( pSelf, s_Events_VScroll );
            hb_vmPushNumInt( wParam );
            hb_vmSend( 1 );
         }
         break;

      case WM_DROPFILES:
         {
            POINT mouse;
            HDROP hDrop;
            PHB_ITEM pArray, pFiles;
            UINT iCount, iPos, iLen, iLen2;
            BYTE *pBuffer;

            hDrop = ( HDROP ) wParam;
            DragQueryPoint( hDrop, ( LPPOINT ) &mouse );
            iCount = DragQueryFile( hDrop, ~0, NULL, 0 );
            iLen = 0;
            for( iPos = 0; iPos < iCount; iPos++ )
            {
               iLen2 = DragQueryFile( hDrop, iPos, NULL, 0 );
               if( iLen < iLen2 )
               {
                  iLen = iLen2;
               }
            }
            iLen++;
            pBuffer = (BYTE *) hb_xgrab( iLen + 1 );
            pArray = hb_itemNew( NULL );
            hb_arrayNew( pArray, 3 );
            hb_itemPutNI( hb_arrayGetItemPtr( pArray, 2 ), mouse.x );
            hb_itemPutNI( hb_arrayGetItemPtr( pArray, 3 ), mouse.x );
            pFiles = hb_arrayGetItemPtr( pArray, 1 );
            hb_arrayNew( pFiles, iCount );
            for( iPos = 0; iPos < iCount; iPos++ )
            {
               iLen2 = DragQueryFile( hDrop, iPos, ( char * ) pBuffer, iLen );
               hb_itemPutCL( hb_arrayGetItemPtr( pFiles, iPos + 1 ), ( char * ) pBuffer, iLen2 );
            }
            hb_xfree( pBuffer );
            _OOHG_DoEvent( pSelf, s_OnDropFiles, "DROPFILES", pArray );
            hb_itemRelease( pArray );
         }
         break;

      default:
         if( message == _OOHG_ListBoxDragNotification )
         {
            _OOHG_Send( GetControlObjectByHandle( ( (LPDRAGLISTINFO) lParam )->hWnd, TRUE ), s_Events_Drag );
            hb_vmPushNumInt( lParam );
            hb_vmSend( 1 );
         }
         else
         {
            _OOHG_Send( pSelf, s_WndProc );
            hb_vmSend( 0 );
            if( hb_param( -1, HB_IT_BLOCK ) )
            {
#ifdef __XHARBOUR__
               hb_vmPushSymbol( &hb_symEval );
#else
               hb_vmPushEvalSym();
#endif
               hb_vmPush( hb_param( -1, HB_IT_BLOCK ) );
               HWNDpush( hWnd );
               hb_vmPushLong( message );
               hb_vmPushNumInt( wParam );
               hb_vmPushNumInt( lParam );
               hb_vmPush( pSelf );
               hb_vmDo( 5 );
            }
            else
            {
               hb_ret();
            }
         }
         break;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( DISABLEVISUALSTYLE )          /* FUNCTION DisableVisualStyle() -> lSuccess */
{
   BOOL bRet = FALSE;

   if( _UxTheme_Init() )
   {
      if( ProcSetWindowTheme( HWNDparam( 1 ), L" ", L" " ) == S_OK )
      {
         bRet = TRUE;
      }
   }
   hb_retl( bRet );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_HEX )          /* FUNCTION _OOHG_Hex( nNum, nDigits ) -> cHexNum */
{
   CHAR cLine[ 50 ], cBuffer[ 50 ];
   UINT iNum;
   INT iCount, iLen, iDigit;

   iCount = 0;
   iNum = ( UINT ) hb_parni( 1 );
   iLen = hb_parni( 2 );
   while( iNum )
   {
      iDigit = iNum & 0xF;
      if( iDigit > 9 )
      {
         iDigit += 7;
      }
      cBuffer[ iCount++ ] = ( CHAR ) ( '0' + iDigit );
      iNum = iNum >> 4;
   }
   if( ! iCount )
   {
      cBuffer[ iCount++ ] = '0';
   }
   if( iLen > 0 )
   {
      if( iLen > 45 )
      {
         iLen = 45;
      }
      while( iCount < iLen )
      {
         cBuffer[ iCount++ ] = '0';
      }
      iCount = iLen;
   }
   iLen = 0;
   while( iCount )
   {
      cLine[ iLen++ ] = cBuffer[ --iCount ];
   }
   hb_retclen( cLine, iLen );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void _oohg_calldump( CHAR * cTitle, CHAR * cOutput )
{
   static PHB_SYMB s_Func = 0;

   if( ! s_Func )
   {
      s_Func = hb_dynsymSymbol( hb_dynsymFind( "_OOHG_CALLDUMP" ) );
   }
   hb_vmPushSymbol( s_Func );
   hb_vmPushNil();
   hb_vmPushString( cTitle, strlen( cTitle ) );
   hb_vmPushString( cOutput, strlen( cOutput ) );
   hb_vmDo( 2 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_EVAL )          /* FUNCTION _OOHG_Eval( bCodeblock ) -> uRet */
{
   if( HB_ISBLOCK( 1 ) )
   {
      HB_FUN_EVAL();
   }
   else
   {
      hb_ret();
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_EVAL_ARRAY )          /* FUNCTION _OOHG_Eval_Array( bCodeblock, aParams ) -> uRet */
{
   static PHB_SYMB s_Eval = 0;

   if( HB_ISBLOCK( 1 ) )
   {
      INT iCount, iLen;
      PHB_ITEM pArray, pItem;

      if( ! s_Eval )
      {
         s_Eval = hb_dynsymSymbol( hb_dynsymFind( "EVAL" ) );
      }
      hb_vmPushSymbol( s_Eval );
      hb_vmPushNil();
      hb_vmPush( hb_param( 1, HB_IT_BLOCK ) );
      pArray = hb_param( 2, HB_IT_ARRAY );
      iCount = 1;
      if( pArray )
      {
         iLen = hb_arrayLen( pArray );
         while( iCount <= iLen )
         {
            pItem = hb_itemArrayGet( pArray, iCount );
            hb_vmPush( pItem );
            hb_itemRelease( pItem );
            iCount ++;
         }
      }
      hb_vmDo( ( short ) iCount );
   }
   else
   {
      hb_ret();
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_SHOWCONTEXTMENUS )          /* FUNCTION _OOHG_ShowContextMenus( lOnOff ) -> lOnOff */
{
   if( HB_ISLOG( 1 ) )
   {
      _OOHG_ShowContextMenus = hb_parl( 1 );
   }
   hb_retl( _OOHG_ShowContextMenus );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_GLOBALRTL )          /* FUNCTION _OOHG_GlobalRTL( lOnOff ) -> lOnOff */
{
   static BOOL _OOHG_GlobalRTL = FALSE;             // TRUE forces RTL functionality on all forms and controls
   BOOL bRet;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( HB_ISLOG( 1 ) )
   {
      _OOHG_GlobalRTL = hb_parl( 1 );
   }
   bRet = _OOHG_GlobalRTL;
   ReleaseMutex( _OOHG_GlobalMutex() );

   hb_retl( bRet );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_NESTEDSAMEEVENT )          /* FUNCTION _OOHG_NestedSameEvent( lOnOff ) -> lOnOff */
{
   BOOL bRet;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ( hb_pcount() > 1 ) && ( HB_ISLOG( 1 ) ) )
   {
      _OOHG_NestedSameEvent = hb_parl( 1 );
   }
   bRet = _OOHG_NestedSameEvent;
   ReleaseMutex( _OOHG_GlobalMutex() );

   hb_retl( bRet );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( VALIDHANDLER )          /* FUNCTION ValidHandler( hWnd ) -> lValid */
{
   HWND hWnd;
   hWnd = HWNDparam( 1 );
   hb_retl( ValidHandler( hWnd ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_GETMOUSECOL )          /* FUNCTION _OOHG_GetMouseRow() -> nCol */
{
   hb_retni( _OOHG_MouseCol );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_GETMOUSEROW )          /* FUNCTION _OOHG_GetMouseRow() -> nRow */
{
   hb_retni( _OOHG_MouseRow );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_LINE )          /* FUNCTION C_Line( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: width
   // 7: R Color
   // 8: G Color
   // 9: B Color
   // 10: lWidth
   // 11: lColor
   // 12: lStyle
   // 13: nStyle

   INT r;
   INT g;
   INT b;
   INT x = hb_parni( 3 );
   INT y = hb_parni( 2 );
   INT tox = hb_parni( 5 );
   INT toy = hb_parni( 4 );
   INT width = 0;
   INT nStyle;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }

      // Color
      if( hb_parl( 11 ) )
      {
         r = hb_parni( 7 );
         g = hb_parni( 8 );
         b = hb_parni( 9 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hgdiobj = SelectObject( hdc, hpen );
      MoveToEx( hdc, x, y, NULL );
      LineTo( hdc, tox, toy );
      SelectObject( hdc, hgdiobj );
      DeleteObject( hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_FILL )          /* FUNCTION C_Fill( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: R Color
   // 7: G Color
   // 8: B Color
   // 9: lColor

   INT r;
   INT g;
   INT b;
   INT x = hb_parnl( 3 );
   INT y = hb_parnl( 2 );
   INT tox = hb_parnl( 5 );
   INT toy = hb_parnl( 4 );
   RECT rect;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HBRUSH hBrush;

   if( hdc != 0 )
   {
      // Color
      if( hb_parl( 9 ) )
      {
         r = hb_parni( 6 );
         g = hb_parni( 7 );
         b = hb_parni( 8 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      rect.left = x;
      rect.top = y;
      rect.right = tox;
      rect.bottom = toy;
      hBrush = CreateSolidBrush( ( COLORREF ) RGB(r, g, b) );
      hgdiobj = SelectObject( hdc, hBrush );
      FillRect( hdc, &rect, hBrush );
      SelectObject( hdc, hgdiobj );
      DeleteObject( hBrush );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_RECTANGLE )          /* FUNCTION C_Rectangle( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: width
   // 7: R Color
   // 8: G Color
   // 9: B Color
   // 10: lWidth
   // 11: lColor
   // 12: lStyle
   // 13: nStyle
   // 14: lBrusStyle
   // 15: nBrushStyle
   // 16: lBrushColor
   // 17: nColorR
   // 18: nColorG
   // 19: nColorB

   INT r;
   INT g;
   INT b;
   INT x = hb_parni( 3 );
   INT y = hb_parni( 2 );
   INT tox = hb_parni( 5 );
   INT toy = hb_parni( 4 );
   INT width;
   INT nStyle;
   INT br;
   INT bg;
   INT bb;
   INT nBr;
   LONG nBh;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 ;
      }

      // Color
      if( hb_parl( 11 ) )
      {
         r = hb_parni( 7 );
         g = hb_parni( 8 );
         b = hb_parni( 9 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      if( hb_parl( 14 ) )
      {
         nBh = hb_parni( 15 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 16 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

      if( hb_parl( 16 ) )
      {
         br = hb_parni( 17 );
         bg = hb_parni( 18 );
         bb = hb_parni( 19 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBr;
      pbr.lbColor = ( COLORREF ) RGB( br, bg, bb );
      pbr.lbHatch = nBh;
      hpen = CreatePen( nStyle,  width, ( COLORREF ) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( hdc, hpen );
      hgdiobj2 = SelectObject( hdc, hbr );
      Rectangle( hdc, x, y, tox, toy );
      SelectObject( hdc, hgdiobj );
      SelectObject( hdc, hgdiobj2 );
      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_ROUNDRECTANGLE )          /* FUNCTION C_RoundRectangle( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: width
   // 7: R Color
   // 8: G Color
   // 9: B Color
   // 10: lWidth
   // 11: lColor
   // 12: lStyle
   // 13: nStyle
   // 14: lBrusStyle
   // 15: nBrushStyle
   // 16: lBrushColor
   // 17: nColorR
   // 18: nColorG
   // 19: nColorB

   INT r;
   INT g;
   INT b;
   INT x = hb_parni( 3 );
   INT y = hb_parni( 2 );
   INT tox = hb_parni( 5 );
   INT toy = hb_parni( 4 );
   INT width;
   INT p;
   INT nStyle;
   INT br;
   INT bg;
   INT bb;
   INT nBr;
   LONG nBh;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 ;
      }

      // Color
      if( hb_parl( 11 ) )
      {
         r = hb_parni( 7 );
         g = hb_parni( 8 );
         b = hb_parni( 9 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      if( hb_parl( 14 ) )
      {
         nBh = hb_parni( 15 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 16 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

      if( hb_parl( 16 ) )
      {
         br = hb_parni( 17 );
         bg = hb_parni( 18 );
         bb = hb_parni( 19 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBr;
      pbr.lbColor = ( COLORREF ) RGB( br, bg, bb );
      pbr.lbHatch = nBh;
      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( hdc, hpen );
      hgdiobj2 = SelectObject( hdc, hbr );
      p = ( tox + toy ) / 2;
      p = p / 10;
      RoundRect( hdc, x, y, tox, toy, p, p );
      SelectObject( hdc, hgdiobj );
      SelectObject( hdc, hgdiobj2 );
      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_ELLIPSE )          /* FUNCTION C_Ellipse( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: width
   // 7: R Color
   // 8: G Color
   // 9: B Color
   // 10: lWidth
   // 11: lColor
   // 12: lStyle
   // 13: nStyle
   // 14: lBrusStyle
   // 15: nBrushStyle
   // 16: lBrushColor
   // 17: nColorR
   // 18: nColorG
   // 19: nColorB

   INT r;
   INT g;
   INT b;
   INT x = hb_parni( 3 );
   INT y = hb_parni( 2 );
   INT tox = hb_parni( 5 );
   INT toy = hb_parni( 4 );
   INT width;
   INT nStyle;
   INT br;
   INT bg;
   INT bb;
   INT nBr;
   LONG nBh;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // Color
      if( hb_parl( 11 ) )
      {
         r = hb_parni( 7 );
         g = hb_parni( 8 );
         b = hb_parni( 9 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      if( hb_parl( 14 ) )
      {
         nBh = hb_parni( 15 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 16 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

      if( hb_parl( 16 ) )
      {
         br = hb_parni( 17 );
         bg = hb_parni( 18 );
         bb = hb_parni( 19 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBr;
      pbr.lbColor = ( COLORREF ) RGB( br, bg, bb );
      pbr.lbHatch = nBh;
      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( hdc, hpen );
      hgdiobj2 = SelectObject( hdc, hbr );
      Ellipse( hdc, x, y, tox, toy );
      SelectObject( hdc, hgdiobj );
      SelectObject( hdc, hgdiobj2 );
      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_ARC )          /* FUNCTION C_Arc( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6-9, x1, y1, x2, y2
   // 10: width
   // 11: R Color
   // 12: G Color
   // 13: B Color
   // 14: lWidth
   // 15: lColor
   // 16: lStyle
   // 17: nStyle

   INT r;
   INT g;
   INT b;
   INT x = hb_parni( 3 );
   INT y = hb_parni( 2 );
   INT tox = hb_parni( 5 );
   INT toy = hb_parni( 4 );
   INT x1 = hb_parni( 7 );
   INT y1 = hb_parni( 6 );
   INT x2 = hb_parni( 9 );
   INT y2 = hb_parni( 8 );
   INT width = 0;
   INT nStyle;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 14 ) )
      {
         width = hb_parni( 10 );
      }

      // Color
      if( hb_parl( 15 ) )
      {
         r = hb_parni( 11 );
         g = hb_parni( 12 );
         b = hb_parni( 13 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 16 ) )
      {
         nStyle = hb_parni( 17 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hgdiobj = SelectObject( hdc, hpen );
      Arc( hdc, x, y, tox, toy, x1, y1, x2, y2 );
      SelectObject( hdc, hgdiobj );
      DeleteObject( hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_ARCTO )          /* FUNCTION C_ArcTo( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6-9, x1, y1, x2, y2
   // 10: width
   // 11: R Color
   // 12: G Color
   // 13: B Color
   // 14: lWidth
   // 15: lColor
   // 16: lStyle
   // 17: nStyle

   INT r;
   INT g;
   INT b;
   INT x = hb_parni( 3 );
   INT y = hb_parni( 2 );
   INT tox = hb_parni( 5 );
   INT toy = hb_parni( 4 );
   INT x1 = hb_parni( 7 );
   INT y1 = hb_parni( 6 );
   INT x2 = hb_parni( 9 );
   INT y2 = hb_parni( 8 );
   INT width = 0;
   INT nStyle;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 14 ) )
      {
         width = hb_parni( 10 );
      }

      // Color
      if( hb_parl( 15 ) )
      {
         r = hb_parni( 11 );
         g = hb_parni( 12 );
         b = hb_parni( 13 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 16 ) )
      {
         nStyle = hb_parni( 17 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hgdiobj = SelectObject( hdc, hpen );
      ArcTo( hdc, x, y, tox, toy, x1, y1, x2, y2 );
      SelectObject( hdc, hgdiobj );
      DeleteObject( hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_PIE )          /* FUNCTION C_Pie( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6-9, x1, y1, x2, y2
   // 10: width
   // 11: R Color
   // 12: G Color
   // 13: B Color
   // 14: lWidth
   // 15: lColor
   // 16: lStyle
   // 17: nStyle
   // 18: lBrusStyle
   // 19: nBrushStyle
   // 20: lBrushColor
   // 21: nColorR
   // 22: nColorG
   // 23: nColorB

   INT r;
   INT g;
   INT b;
   INT x = hb_parni( 3 );
   INT y = hb_parni( 2 );
   INT tox = hb_parni( 5 );
   INT toy = hb_parni( 4 );
   INT x1 = hb_parni( 7 );
   INT y1 = hb_parni( 6 );
   INT x2 = hb_parni( 9 );
   INT y2 = hb_parni( 8 );
   INT width = 0;
   INT nStyle;
   INT br;
   INT bg;
   INT bb;
   INT nBr;
   LONG nBh;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 14 ) )
      {
         width = hb_parni( 10 );
      }

      // Color
      if( hb_parl( 15 ) )
      {
         r = hb_parni( 11 );
         g = hb_parni( 12 );
         b = hb_parni( 13 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 16 ) )
      {
         nStyle = hb_parni( 17 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      if( hb_parl( 18 ) )
      {
         nBh = hb_parni( 19 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 20 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

      if( hb_parl( 20 ) )
      {
         br = hb_parni( 21 );
         bg = hb_parni( 22 );
         bb = hb_parni( 23 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBr;
      pbr.lbColor = ( COLORREF ) RGB( br, bg, bb );
      pbr.lbHatch = nBh;
      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( hdc, hpen );
      hgdiobj2 = SelectObject( hdc, hbr );
      Pie( hdc, x, y, tox, toy, x1, y1, x2, y2 );
      SelectObject( hdc, hgdiobj );
      SelectObject( hdc, hgdiobj2 );
      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_POLYBEZIER )          /* FUNCTION C_PolyBezier( ... ) -> NIL */
{
   // 1: hDC
   // 2: aPy
   // 3: aPx
   // 4: width
   // 5: R Color
   // 6: G Color
   // 7: B Color
   // 8: lWidth
   // 9: lColor
   // 10: lStyle
   // 11: nStyle

   INT r;
   INT g;
   INT b;
   INT width = 0;
   INT nStyle;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;
   DWORD i, number = ( DWORD ) hb_parinfa( 2, 0 );
   POINT apoints[ 1024 ];

   if( hdc != 0 )
   {
      for( i = 0; i <= number - 1; i++ )
      {
         apoints[ i ].y = HB_PARNI( 2, i + 1 );
         apoints[ i ].x = HB_PARNI( 3, i + 1 );
      }

      // Width
      if( hb_parl( 8 ) )
      {
         width = hb_parni( 4 );
      }

      // Color
      if( hb_parl( 9 ) )
      {
         r = hb_parni( 5 );
         g = hb_parni( 6 );
         b = hb_parni( 7 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 10 ) )
      {
         nStyle = hb_parni( 11 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hgdiobj = SelectObject( hdc, hpen );
      PolyBezier( hdc, apoints, number );
      SelectObject( hdc, hgdiobj );
      DeleteObject( hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_POLYBEZIERTO )          /* FUNCTION C_PolyBezierTo( ... ) -> NIL */
{
   // 1: hDC
   // 2: aPy
   // 3: aPx
   // 4: width
   // 5: R Color
   // 6: G Color
   // 7: B Color
   // 8: lWidth
   // 9: lColor
   // 10: lStyle
   // 11: nStyle

   INT r;
   INT g;
   INT b;
   INT width = 0;
   INT nStyle;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;
   DWORD i, number = ( DWORD ) hb_parinfa( 2, 0 );
   POINT apoints[ 1024 ];

   if( hdc != 0 )
   {
      for( i = 0; i <= number - 1; i++ )
      {
         apoints[ i ].y = HB_PARNI( 2, i + 1 );
         apoints[ i ].x = HB_PARNI( 3, i + 1 );
      }

      // Width
      if( hb_parl( 8 ) )
      {
         width = hb_parni( 4 );
      }

      // Color
      if( hb_parl( 9 ) )
      {
         r = hb_parni( 5 );
         g = hb_parni( 6 );
         b = hb_parni( 7 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 10 ) )
      {
         nStyle = hb_parni( 11 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hgdiobj = SelectObject( hdc, hpen );
      PolyBezierTo( hdc, apoints, number );
      SelectObject( hdc, hgdiobj );
      DeleteObject( hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_POLYGON )          /* FUNCTION C_Polygon( ... ) -> NIL */
{
   // 1: hDC
   // 2: aPy
   // 3: aPx
   // 4: width
   // 5: R Color
   // 6: G Color
   // 7: B Color
   // 8: lWidth
   // 9: lColor
   // 10: lStyle
   // 11: nStyle
   // 12: lBrusStyle
   // 13: nBrushStyle
   // 14: lBrushColor
   // 15: nColorR
   // 16: nColorG
   // 17: nColorB
   // 18: nFillMode

   INT r;
   INT g;
   INT b;
   INT width;
   INT nStyle;
   INT br;
   INT bg;
   INT bb;
   INT nBr;
   LONG nBh;
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;
   DWORD i, number;
   POINT apoints[ 1024 ];
   INT oldFillMode;
   INT newFillMode;
   HDC hdc = ( HDC ) HB_PARNL( 1 );

   if( hdc != 0 )
   {
      oldFillMode = GetPolyFillMode( hdc );
      if( hb_parni( 18 ) == 1 )
      {
         newFillMode = WINDING;
      }
      else
      {
         newFillMode = ALTERNATE;
      }

      number = ( DWORD ) hb_parinfa( 2, 0 );
      for( i = 0; i <= number - 1; i++ )
      {
         apoints[ i ].y = HB_PARNI( 2, i + 1 );
         apoints[ i ].x = HB_PARNI( 3, i + 1 );
      }

      // Width
      if( hb_parl( 8 ) )
      {
         width = hb_parni( 4 );
      }
      else
      {
         width = 0;
      }

      // Color
      if( hb_parl( 9 ) )
      {
         r = hb_parni( 5 );
         g = hb_parni( 6 );
         b = hb_parni( 7 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 10 ) )
      {
         nStyle = hb_parni( 11 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      if( hb_parl( 12 ) )
      {
         nBh = hb_parni( 13 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 14 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

      if( hb_parl( 14 ) )
      {
         br = hb_parni( 15 );
         bg = hb_parni( 16 );
         bb = hb_parni( 17 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBr;
      pbr.lbColor = ( COLORREF ) RGB( br, bg, bb );
      pbr.lbHatch = nBh;
      hbr = CreateBrushIndirect( &pbr );
      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hgdiobj = SelectObject( hdc, hpen );
      hgdiobj2 = SelectObject( hdc, hbr );
      SetPolyFillMode( hdc, newFillMode );
      Polygon( hdc, apoints, number );
      SetPolyFillMode( hdc, oldFillMode );
      SelectObject( hdc, hgdiobj );
      SelectObject( hdc, hgdiobj2 );
      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( C_CHORD )          /* FUNCTION C_Chord( ... ) -> NIL */
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6-9, x1, y1, x2, y2
   // 10: width
   // 11: R Color
   // 12: G Color
   // 13: B Color
   // 14: lWidth
   // 15: lColor
   // 16: lStyle
   // 17: nStyle
   // 18: lBrusStyle
   // 19: nBrushStyle
   // 20: lBrushColor
   // 21: nColorR
   // 22: nColorG
   // 23: nColorB

   INT r;
   INT g;
   INT b;
   INT x = hb_parni( 3 );
   INT y = hb_parni( 2 );
   INT tox = hb_parni( 5 );
   INT toy = hb_parni( 4 );
   INT x1 = hb_parni( 7 );
   INT y1 = hb_parni( 6 );
   INT x2 = hb_parni( 9 );
   INT y2 = hb_parni( 8 );
   INT width = 0;
   INT nStyle;
   INT br;
   INT bg;
   INT bb;
   INT nBr;
   LONG nBh;
   HDC hdc = ( HDC ) HB_PARNL( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 14 ) )
      {
         width = hb_parni( 10 );
      }

      // Color
      if( hb_parl( 15 ) )
      {
         r = hb_parni( 11 );
         g = hb_parni( 12 );
         b = hb_parni( 13 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      if( hb_parl( 16 ) )
      {
         nStyle = hb_parni( 17 );
      }
      else
      {
         nStyle = ( INT ) PS_SOLID;
      }

      if( hb_parl( 18 ) )
      {
         nBh = hb_parni( 19 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 20 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

      if( hb_parl( 20 ) )
      {
         br = hb_parni( 21 );
         bg = hb_parni( 22 );
         bb = hb_parni( 23 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBr;
      pbr.lbColor = ( COLORREF ) RGB( br, bg, bb );
      pbr.lbHatch = nBh;
      hpen = CreatePen( nStyle, width, ( COLORREF ) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( hdc, hpen );
      hgdiobj2 = SelectObject( hdc, hbr );
      Chord( hdc, x, y, tox, toy, x1, y1, x2, y2 );
      SelectObject( hdc, hgdiobj );
      SelectObject( hdc, hgdiobj2 );
      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

#pragma ENDDUMP
