/*
 * $Id: h_tab.prg,v 1.57 2012-06-11 22:26:28 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Tab functions
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

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TTab FROM TTabMulti
ENDCLASS

CLASS TTabDirect FROM TTabRaw
   // DATA Type                  INIT "TAB" READONLY
   DATA aPages                INIT {}
   DATA lInternals            INIT .F.
   DATA nFirstValue           INIT nil

   METHOD Define
   METHOD EndTab
   METHOD EndPage             BLOCK { || _OOHG_DeleteFrame( "TABPAGE" ) }
   METHOD ItemCount           BLOCK { |Self| LEN( ::aPages ) }

   METHOD Refresh
   METHOD RefreshData
   METHOD Release
   METHOD SizePos
   METHOD Value               SETGET
   METHOD Enabled             SETGET
   METHOD Visible             SETGET
   METHOD ForceHide
   METHOD AdjustResize

   METHOD AddPage
   METHOD AddControl
   METHOD DeleteControl
   METHOD DeletePage

   METHOD RealPosition
   METHOD HidePage
   METHOD ShowPage

   METHOD Caption
   METHOD Picture
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals, Invisible, ;
               lDisabled, multiline ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL z, Caption, Image, aControls, Mnemonic

   ::Super:Define( ControlName, ParentForm, x, y, w, h, , ;
                   , fontname, fontsize, tooltip, , Buttons, Flat, ;
                   HotTrack, Vertical, notabstop, bold, italic, ;
                   underline, strikeout, , lRtl, Invisible, ;
                   lDisabled, multiline )

   ASSIGN ::lInternals VALUE lInternals TYPE "L"

   IF ! ::lInternals
      // Since we still can't set a TAB's backcolor, we assume it (and
      // internal controls) as system-default backcolor  :(
      ::BackColor := -1
   ENDIF

   If ! ::lInternals .AND. ! EMPTY( ::Container )
      SetWindowPos( ::hWnd, 0, 0, 0, 0, 0, 3 )
   EndIf

   _OOHG_AddFrame( Self )

   // Add page by page
   If ! HB_IsArray( aCaptions )
      aCaptions := {}
   EndIf
   If ! HB_IsArray( Images )
      Images := {}
   EndIf
   If ! HB_IsArray( aPageMap )
      aPageMap := {}
   EndIf
   If ! HB_IsArray( aMnemonic )
      aMnemonic := {}
   EndIf
   z := 1
   DO WHILE z <= LEN( aCaptions ) .AND. z <= LEN( Images ) .AND. z <= LEN( aPageMap )
      IF z <= LEN( aCaptions ) .AND. VALTYPE( aCaptions[ z ] ) $ "CM"
         Caption := aCaptions[ z ]
      ELSE
         Caption := ""
      ENDIF
      IF z <= LEN( Images ) .AND. VALTYPE( Images[ z ] ) $ "CM"
         Image := Images[ z ]
      ELSE
         Image := ""
      ENDIF
      IF z <= LEN( aPageMap ) .AND. HB_IsArray( aPageMap[ z ] )
         aControls := aPageMap[ z ]
      ELSE
         aControls := nil
      ENDIF
      IF z <= LEN( aMnemonic ) .AND. HB_IsBlock( aMnemonic[ z ] )
         Mnemonic := aMnemonic[ z ]
      ELSE
         Mnemonic := nil
      ENDIF
      ::AddPage( , Caption, Image, aControls, Mnemonic )
      z++
   ENDDO

   IF HB_IsNumeric( value )
      ::Value := value
   ELSE
      ::Value := 1
   ENDIF

   ASSIGN ::OnChange    VALUE Change    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD EndTab() CLASS TTabDirect
*-----------------------------------------------------------------------------*
   If _OOHG_LastFrame() == "TABPAGE"
      // ERROR: Last page not finished
      ::EndPage()
   EndIf
   _OOHG_DeleteFrame( ::Type )
   If HB_IsNumeric( ::nFirstValue ) .AND. ! ::Value == ::nFirstValue
      ::Value := ::nFirstValue
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TTabDirect
*-----------------------------------------------------------------------------*
Local nPage, nFocused
   nFocused := GetFocus()
   nPage := IF( ::Visible, ::Value, 0 )
   AEVAL( ::aPages, { |p,i| p:Position := i , p:ForceHide() } )
   IF nPage >= 1 .AND. nPage <= LEN( ::aPages )
      ::aPages[ nPage ]:Show()
   ENDIF
   //
   If ValidHandler( nFocused )
      If IsWindowVisible( nFocused )
         If ! GetFocus() == nFocused
            SetFocus( nFocused )
         EndIf
      Else
         ::SetFocus()
      EndIf
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TTabDirect
*-----------------------------------------------------------------------------*
   ::Super:RefreshData()
   AEVAL( ::aPages, { |o| o:RefreshData() } )
Return nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TTabDirect
*-----------------------------------------------------------------------------*
   AEVAL( ::aPages, { |o| o:Release() } )
Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
   ::Super:SizePos( Row, Col, Width, Height )
   AEVAL( ::aPages, { |o| o:Events_Size() } )
Return Nil

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL nPos, nCount
   IF HB_IsNumeric( nValue )
      nPos := ::RealPosition( nValue )
      IF nPos != 0
         TabCtrl_SetCurSel( ::hWnd, nPos )
         ::Refresh()
         ::DoChange()
      ENDIF
   ENDIF
   nPos := TABCTRL_GETCURSEL( ::hWnd )
   nCount := 0
   nValue := ASCAN( ::aPages, { |o| IF( o:lHidden, , nCount++ ), ( nCount == nPos ) } )
RETURN nValue

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL nPos
   IF HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      nPos := ::Value
      IF nPos <= LEN( ::aPages ) .AND. nPos >= 1
         ::aPages[ nPos ]:Enabled := ::aPages[ nPos ]:Enabled
      ENDIF
   ENDIF
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL nPos, aPages
   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      nPos := ::Value
      aPages := ::aPages
      IF nPos <= LEN( aPages ) .AND. nPos >= 1
         IF lVisible .AND. aPages[ nPos ]:Visible
            aPages[ nPos ]:Visible := .T.
         ELSE
            aPages[ nPos ]:ForceHide()
         ENDIF
      ENDIF
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD ForceHide() CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL nPos
   nPos := ::Value
   IF nPos <= LEN( ::aPages ) .AND. nPos >= 1
      ::aPages[ nPos ]:ForceHide()
   ENDIF
RETURN ::Super:ForceHide()

*-----------------------------------------------------------------------------*
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
   // Next sentence forces the page's width and height to be the same as the
   // container's, because it calls ::SizePos() who call ::Events_Size() for
   // each page. So, for each page, we only need to adjust/resize the controls.
   // .T. is needed to avoid calling ::AdjustResize() for the TTabRaw control.
   ::Super:AdjustResize( nDivh, nDivw, .T. )
   AEVAL( ::aPages, { |o| o:AdjustResize( nDivh, nDivw, lSelfOnly ) } )
RETURN nil

*-----------------------------------------------------------------------------*
METHOD AddPage( Position, Caption, Image, aControls, Mnemonic, Name, oSubClass ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
Local oPage, nPos

   IF !HB_IsNumeric( Position ) .OR. Position < 1 .OR. Position > LEN( ::aPages )
      Position := LEN( ::aPages ) + 1
   ENDIF

   If ! ValType( Image ) $ 'CM'
      Image := ''
   EndIf

   If ! ValType( Caption ) $ 'CM'
      Caption := ''
   Else
      IF ! EMPTY( Image ) .AND. IsXPThemeActive() .AND. At( '&' , Caption ) != 0
         Caption := Space( 3 ) + Caption
      ENDIF
   EndIf

   If HB_IsObject( oSubClass )
      oPage := oSubClass
   ElseIf ::lInternals
      oPage := TTabPageInternal()
   Else
      oPage := TTabPage()
   EndIf
   oPage:Define( Name, Self )

   oPage:Caption   := Caption
   oPage:Picture   := Image
   oPage:Position  := Position

   AADD( ::aPages, nil )
   AINS( ::aPages, Position )
   ::aPages[ Position ] := oPage

   oPage:Events_Size()

   IF ! Empty( Image )
      oPage:nImage := ::AddBitMap( Image ) - 1
   ENDIF

   ::InsertItem( ::RealPosition( Position ), Caption, oPage:nImage )

   If HB_IsArray( aControls )
      AEVAL( aControls, { |o| ::AddControl( o, Position ) } )
   EndIf

   nPos := At( '&', Caption )
   IF nPos > 0 .AND. nPos < LEN( Caption )
      IF !HB_IsBlock( Mnemonic )
         Mnemonic := { || oPage:SetFocus() }
      ENDIF
      DEFINE HOTKEY 0 PARENT ( ::Parent ) KEY "ALT+" + SubStr( Caption, nPos + 1, 1 ) ACTION ::DoEvent( Mnemonic, "CHANGE" )
   ENDIF

   If ::Value == Position
      ::Refresh()
   Else
      oPage:ForceHide()
   EndIf

Return oPage

*------------------------------------------------------------------------------*
Function _BeginTabPage( caption, image, Position, Name, oSubClass )
*------------------------------------------------------------------------------*
local oCtrl, oPage
   IF _OOHG_LastFrame() == "TABPAGE"
      // ERROR: Last page not finished
      _EndTabPage()
   ENDIF
   ///// IF _OOHG_LastFrame() == "TAB" ...
   oCtrl := ATAIL( _OOHG_ActiveFrame )
   oPage := oCtrl:AddPage( Position, Caption, Image,,, Name, oSubClass )
   _OOHG_AddFrame( oPage )
Return oPage

*------------------------------------------------------------------------------*
Function _EndTabPage()
*------------------------------------------------------------------------------*
   _OOHG_DeleteFrame( "TABPAGE" )
RETURN nil

*------------------------------------------------------------------------------*
Function _EndTab()
*------------------------------------------------------------------------------*
   IF _OOHG_LastFrame() == "TABPAGE"
      // ERROR: Last page not finished
      _EndTabPage()
   ENDIF
   ATAIL( _OOHG_ActiveFrame ):EndTab()
Return Nil

*-----------------------------------------------------------------------------*
METHOD AddControl( oCtrl , PageNumber , Row , Col ) CLASS TTabDirect
*-----------------------------------------------------------------------------*

   If ValType( oCtrl ) $ "CM"
      oCtrl := ::Parent:Control( oCtrl )
   EndIf

   IF !HB_IsNumeric( PageNumber ) .OR. PageNumber > LEN( ::aPages )
      PageNumber := LEN( ::aPages )
   ENDIF

   IF PageNumber < 1
      PageNumber := 1
   ENDIF

   IF !HB_IsNumeric( Row )
      Row := oCtrl:ContainerRow - ::ContainerRow
   ENDIF

   IF !HB_IsNumeric( Col )
      Col := oCtrl:ContainerCol - ::ContainerCol
   ENDIF

   ::aPages[ PageNumber ]:AddControl( oCtrl, Row, Col )

Return Nil

*-----------------------------------------------------------------------------*
METHOD DeletePage( Position ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
Local nValue, nRealPosition

   IF !HB_IsNumeric( Position ) .OR. Position < 1 .OR. Position > LEN( ::aPages )
      Position := LEN( ::aPages )
   ENDIF

   nValue := ::Value
   nRealPosition := ::RealPosition( Position )

   ::aPages[ Position ]:Release()
   _OOHG_DeleteArrayItem( ::aPages, Position )
   If nRealPosition != 0
      ::DeleteItem( nRealPosition )
   EndIf

   IF nValue == Position
      ::Refresh()
   ENDIF

Return Nil

*-----------------------------------------------------------------------------*
METHOD DeleteControl( oCtrl ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
Return AEVAL( ::aPages, { |o| o:DeleteControl( oCtrl ) } )

*-----------------------------------------------------------------------------*
METHOD RealPosition( nPage ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL nCount := 0
   IF nPage >= 1 .AND. nPage <= LEN( ::aPages ) .AND. ! ::aPages[ nPage ]:lHidden
      AEVAL( ::aPages, { |o| IF( o:lHidden, , nCount++ ) }, 1, nPage )
   ENDIF
RETURN nCount

*-----------------------------------------------------------------------------*
METHOD HidePage( nPage ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL nPos
   IF nPage >= 1 .AND. nPage <= LEN( ::aPages ) .AND. ! ::aPages[ nPage ]:lHidden
      nPos := ::Value
      // Disable hotkey!
      ::DeleteItem( ::RealPosition( nPage ) )
      ::aPages[ nPage ]:lHidden := .T.
      IF nPos > 0
         ::aPages[ nPos ]:ForceHide()
      ENDIF
      nPos := ASCAN( ::aPages, { |o| ! o:lHidden }, MAX( nPos, 1 ) )
      IF nPos == 0
         nPos := ASCAN( ::aPages, { |o| ! o:lHidden }, 1 )
      ENDIF
      IF nPos > 0
         ::Value := nPos
         ::aPages[ nPos ]:Show()
      ENDIF
   ENDIF
RETURN nil

*-----------------------------------------------------------------------------*
METHOD ShowPage( nPage ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL nRealPosition
   IF nPage >= 1 .AND. nPage <= LEN( ::aPages ) .AND. ::aPages[ nPage ]:lHidden
      ::aPages[ nPage ]:lHidden := .F.
      nRealPosition := ::RealPosition( nPage )
      ::InsertItem( nRealPosition, ::aPages[ nPage ]:Caption, ::aPages[ nPage ]:nImage )
      If ::Value == nPage
         ::Refresh()
      EndIf
      // Enable hotkey!
   ENDIF
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Caption( nColumn, uValue ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL nRealPosition
   nRealPosition := ::RealPosition( nColumn )
   If nRealPosition > 0
      If VALTYPE( uValue ) $ "CM"
         ::Super:Caption( nRealPosition, uValue )
      EndIf
      ::aPages[ nColumn ]:Caption := ::Super:Caption( nRealPosition )
   Else
      If VALTYPE( uValue ) $ "CM"
         ::aPages[ nColumn ]:Caption := uValue
      EndIf
   EndIf
Return ::aPages[ nColumn ]:Caption

*-----------------------------------------------------------------------------*
METHOD Picture( nColumn, uValue ) CLASS TTabDirect
*-----------------------------------------------------------------------------*
LOCAL oPage, nRealPosition
   oPage := ::aPages[ nColumn ]
   If VALTYPE( uValue ) $ "CM"
      oPage:Picture := uValue
      oPage:nImage := ::AddBitMap( uValue ) - 1
      nRealPosition := ::RealPosition( nColumn )
      If nRealPosition != 0
         SetTabPageImage( ::hWnd, nRealPosition, oPage:nImage )
         ::Refresh()
      EndIf
   EndIf
Return oPage:Picture





CLASS TTabCombo FROM TMultiPage
   DATA Type                INIT "TAB" READONLY
   DATA lInternals          INIT .F.

   METHOD Define
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals, Invisible, ;
               lDisabled, multiline ) CLASS TTabCombo
*-----------------------------------------------------------------------------*

   ::Super:Define( ControlName, ParentForm, x, y, w, h, , , ;
                   FontName, FontSize, bold, italic, underline, strikeout, ;
                   Invisible, lDisabled, lRtl, change, value )

   // Unused...
   EMPTY( Buttons )
   EMPTY( Flat )
   EMPTY( HotTrack )
   EMPTY( Vertical )
   EMPTY( multiline )
   @ 0,0 COMBOBOX 0 OBJ ::oContainerBase PARENT ( Self ) ;
         ITEMS {} TOOLTIP tooltip
   If HB_IsLogical( notabstop ) .and. notabstop
      ::oContainerBase:TabStop := .F.
   EndIf

   ASSIGN ::lInternals VALUE lInternals TYPE "L"
   If ::lInternals
      ::oPageClass := TTabPageInternal()
   EndIf

   ::CreatePages( aCaptions, Images, aPageMap, aMnemonic )

   ::oContainerBase:OnChange := { || ::Refresh() , ::DoChange() }
Return Self





CLASS TTabRadio FROM TMultiPage
   DATA Type                INIT "TAB" READONLY
   DATA lInternals          INIT .F.

   METHOD Define
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals, Invisible, ;
               lDisabled, multiline ) CLASS TTabRadio
*-----------------------------------------------------------------------------*

   ::Super:Define( ControlName, ParentForm, x, y, w, h, , , ;
                   FontName, FontSize, bold, italic, underline, strikeout, ;
                   Invisible, lDisabled, lRtl, change, value )

   // Unused...
   EMPTY( Buttons )
   EMPTY( Flat )
   EMPTY( HotTrack )
   EMPTY( multiline )
   @ 0,0 RADIO 0 OBJ ::oContainerBase PARENT ( Self ) ;
         OPTIONS {} TOOLTIP tooltip HORIZONTAL
   If HB_IsLogical( Vertical )
      ::oContainerBase:lHorizontal := ! Vertical
   EndIf
   If HB_IsLogical( notabstop ) .and. notabstop
      ::oContainerBase:TabStop := .F.
   EndIf

   ASSIGN ::lInternals VALUE lInternals TYPE "L"
   If ::lInternals
      ::oPageClass := TTabPageInternal()
   EndIf

   ::CreatePages( aCaptions, Images, aPageMap, aMnemonic )

   ::oContainerBase:OnChange := { || ::Refresh() , ::DoChange() }
Return Self





CLASS TTabMulti FROM TMultiPage
   DATA Type                INIT "TAB" READONLY
   DATA lInternals          INIT .F.

   METHOD Define
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals, Invisible, ;
               lDisabled, multiline ) CLASS TTabMulti
*-----------------------------------------------------------------------------*

   ::Super:Define( ControlName, ParentForm, x, y, w, h, , , ;
                   FontName, FontSize, bold, italic, underline, strikeout, ;
                   Invisible, lDisabled, lRtl, change, value )

   ::oContainerBase := TTabRaw()
   ::oContainerBase:Define( , Self, 0, 0, w, h, , ;
                            , , , tooltip, , Buttons, Flat, ;
                            HotTrack, Vertical, notabstop, , , ;
                            , , , , , ;
                            , multiline )

   ASSIGN ::lInternals VALUE lInternals TYPE "L"

   If ! ::lInternals
      // Since we still can't set a TAB's backcolor, we assume it (and
      // internal controls) as system-default backcolor  :(
      ::BackColor := -1

      If ! EMPTY( ::Container )
         SetWindowPos( ::oContainerBase:hWnd, 0, 0, 0, 0, 0, 3 )
      EndIf
   Else
      ::oPageClass := TTabPageInternal()
   EndIf

   ::CreatePages( aCaptions, Images, aPageMap, aMnemonic )

   ::oContainerBase:OnChange := { || ::Refresh() , ::DoChange() }
Return Self





CLASS TMultiPage FROM TControlGroup
   DATA Type                INIT "MULTIPAGE" READONLY
   DATA aPages              INIT {}
   DATA oContainerBase      INIT nil
   DATA oPageClass          INIT TTabPage()
   DATA nFirstValue         INIT nil

   METHOD Define
   METHOD CreatePages
   METHOD ItemCount         BLOCK { |Self| LEN( ::aPages ) }
   METHOD Refresh
   METHOD RefreshData
   METHOD Release
   METHOD SizePos
   METHOD Value             SETGET
   METHOD Enabled           SETGET
   METHOD Visible           SETGET
   METHOD ForceHide
   METHOD SetFocus          BLOCK { |Self| ::oContainerBase:SetFocus() }
   METHOD AdjustResize

   METHOD AddPage
   METHOD AddControl
   METHOD DeleteControl
   METHOD DeletePage

   METHOD RealPosition
   METHOD HidePage
   METHOD ShowPage

   METHOD Caption
   METHOD Picture

   METHOD EndPage           BLOCK { |Self| _OOHG_DeleteFrame( ::oPageClass:Type ) }
   METHOD EndTab

   // Control-specific methods
   METHOD ContainerValue             SETGET
   METHOD ContainerCaption(x,y)      BLOCK { |Self,x,y| ::oContainerBase:Caption(x,y) }
   METHOD ContainerItemCount         BLOCK { |Self| ::oContainerBase:ItemCount() }
   METHOD InsertItem(x,y,z)          BLOCK { |Self,x,y,z| ::oContainerBase:InsertItem(x,y,z) }
   METHOD DeleteItem
   METHOD hWnd                       BLOCK { |Self| IF( ::oContainerBase == NIL, 0, ::oContainerBase:hWnd ) }
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, FontColor, BackColor, ;
               FontName, FontSize, bold, italic, underline, strikeout, ;
               Invisible, lDisabled, lRtl, change, value ) CLASS TMultiPage
*-----------------------------------------------------------------------------*

   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nCol    VALUE x TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, FontColor, BackColor,, lRtl )
   ::InitStyle( ,, Invisible, , lDisabled )
   ::Register( 0 )
   ::SetFont( ,, bold, italic, underline, strikeout )

   If HB_IsNumeric( value )
      ::nFirstValue := value
   EndIf

   _OOHG_AddFrame( Self )

   ASSIGN ::OnChange    VALUE Change    TYPE "B"

   // ::oContainerBase is not created yet!
   // ::oContainerBase:OnChange := { || ::Refresh() , ::DoChange() }

Return Self

*-----------------------------------------------------------------------------*
METHOD CreatePages( aCaptions, Images, aPageMap, aMnemonic ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL z, Caption, Image, aControls, Mnemonic

   If ! HB_IsArray( aCaptions )
      aCaptions := {}
   EndIf
   If ! HB_IsArray( Images )
      Images := {}
   EndIf
   If ! HB_IsArray( aPageMap )
      aPageMap := {}
   EndIf
   If ! HB_IsArray( aMnemonic )
      aMnemonic := {}
   EndIf

   z := 1
   DO WHILE z <= LEN( aCaptions ) .AND. z <= LEN( Images ) .AND. z <= LEN( aPageMap )
      IF z <= LEN( aCaptions ) .AND. VALTYPE( aCaptions[ z ] ) $ "CM"
         Caption := aCaptions[ z ]
      ELSE
         Caption := ""
      ENDIF
      IF z <= LEN( Images ) .AND. VALTYPE( Images[ z ] ) $ "CM"
         Image := Images[ z ]
      ELSE
         Image := ""
      ENDIF
      IF z <= LEN( aPageMap ) .AND. HB_IsArray( aPageMap[ z ] )
         aControls := aPageMap[ z ]
      ELSE
         aControls := nil
      ENDIF
      IF z <= LEN( aMnemonic ) .AND. HB_IsBlock( aMnemonic[ z ] )
         Mnemonic := aMnemonic[ z ]
      ELSE
         Mnemonic := nil
      ENDIF
      ::AddPage( , Caption, Image, aControls, Mnemonic )
      z++
   ENDDO
Return nil

*-----------------------------------------------------------------------------*
METHOD Refresh() CLASS TMultiPage
*-----------------------------------------------------------------------------*
Local nPage, nFocused
   nFocused := GetFocus()
   nPage := IF( ::Visible, ::Value, 0 )
   AEVAL( ::aPages, { |p,i| p:Position := i , p:ForceHide() } )
   IF nPage >= 1 .AND. nPage <= LEN( ::aPages )
      ::aPages[ nPage ]:Show()
   ENDIF
   //
   If ValidHandler( nFocused )
      If IsWindowVisible( nFocused )
         If ! GetFocus() == nFocused
            SetFocus( nFocused )
         EndIf
      Else
         ::SetFocus()
      EndIf
   EndIf
Return Nil

*-----------------------------------------------------------------------------*
METHOD RefreshData() CLASS TMultiPage
*-----------------------------------------------------------------------------*
   ::Super:RefreshData()
   AEVAL( ::aPages, { |o| o:RefreshData() } )
Return nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TMultiPage
*-----------------------------------------------------------------------------*
   AEVAL( ::aPages, { |o| o:Release() } )
Return ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD SizePos( Row, Col, Width, Height ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
   ::Super:SizePos( Row, Col, Width, Height )
   If ! ::oContainerBase == NIL
      ::oContainerBase:SizePos( 0, 0, Width, Height )
   EndIf
   AEVAL( ::aPages, { |o| o:Events_Size() } )
Return Nil

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL nPos, nCount
   IF HB_IsNumeric( nValue )
      nPos := ::RealPosition( nValue )
      IF nPos != 0
         ::ContainerValue := nPos
      ENDIF
   ENDIF
   nPos := ::ContainerValue
   nCount := 0
   nValue := ASCAN( ::aPages, { |o| IF( o:lHidden, , nCount++ ), ( nCount == nPos ) } )
RETURN nValue

*-----------------------------------------------------------------------------*
METHOD Enabled( lEnabled ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL nPos
   IF HB_IsLogical( lEnabled )
      ::Super:Enabled := lEnabled
      nPos := ::Value
      IF nPos <= LEN( ::aPages ) .AND. nPos >= 1
         ::aPages[ nPos ]:Enabled := ::aPages[ nPos ]:Enabled
      ENDIF
   ENDIF
RETURN ::Super:Enabled

*-----------------------------------------------------------------------------*
METHOD Visible( lVisible ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL nPos, aPages
   IF HB_IsLogical( lVisible )
      ::Super:Visible := lVisible
      nPos := ::Value
      aPages := ::aPages
      IF nPos <= LEN( aPages ) .AND. nPos >= 1
         IF lVisible .AND. aPages[ nPos ]:Visible
            aPages[ nPos ]:Visible := .T.
         ELSE
            aPages[ nPos ]:ForceHide()
         ENDIF
      ENDIF
   ENDIF
RETURN ::lVisible

*-----------------------------------------------------------------------------*
METHOD ForceHide() CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL nPos
   nPos := ::Value
   IF nPos <= LEN( ::aPages ) .AND. nPos >= 1
      ::aPages[ nPos ]:ForceHide()
   ENDIF
RETURN ::Super:ForceHide()

*-----------------------------------------------------------------------------*
METHOD AdjustResize( nDivh, nDivw, lSelfOnly ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
   // Next sentence forces the page's width and height to be the same as the
   // container's, because it calls ::SizePos() who call ::Events_Size() for
   // each page. So, for each age, we only need to adjust/resize the controls.
   // .T. is needed to avoid calling ::AdjustResize() for the TTabRaw control.
   ::Super:AdjustResize( nDivh, nDivw, .T. )
   AEVAL( ::aPages, { |o| o:AdjustResize( nDivh, nDivw, lSelfOnly ) } )
RETURN nil

*-----------------------------------------------------------------------------*
METHOD AddPage( Position, Caption, Image, aControls, Mnemonic, Name, oSubClass ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
Local oPage, nPos

   IF !HB_IsNumeric( Position ) .OR. Position < 1 .OR. Position > LEN( ::aPages )
      Position := LEN( ::aPages ) + 1
   ENDIF

   If ! ValType( Image ) $ 'CM'
      Image := ''
   EndIf

   If ! ValType( Caption ) $ 'CM'
      Caption := ''
   Else
      If ! EMPTY( Image ) .AND. IsXPThemeActive() .AND. At( '&' , Caption ) != 0
         Caption := Space( 3 ) + Caption
      EndIf
   EndIf

   If HB_IsObject( oSubClass )
      oPage := oSubClass
   Else
      oPage := __clsInst( ::oPageClass:ClassH )
   EndIf
   oPage:Define( Name, Self )

   oPage:Caption   := Caption
   oPage:Picture   := Image
   oPage:Position  := Position

   AADD( ::aPages, nil )
   AINS( ::aPages, Position )
   ::aPages[ Position ] := oPage

   oPage:Events_Size()

   IF ! Empty( Image )
      oPage:nImage := ::oContainerBase:AddBitMap( Image ) - 1
   ENDIF

   ::InsertItem( ::RealPosition( Position ), Caption, oPage:nImage )

   If HB_IsArray( aControls )
      AEVAL( aControls, { |o| ::AddControl( o, Position ) } )
   EndIf

   nPos := At( '&', Caption )
   IF nPos > 0 .AND. nPos < LEN( Caption )
      IF !HB_IsBlock( Mnemonic )
         Mnemonic := { || oPage:SetFocus() }
      ENDIF
      DEFINE HOTKEY 0 PARENT ( ::Parent ) KEY "ALT+" + SubStr( Caption, nPos + 1, 1 ) ACTION ::DoEvent( Mnemonic, "CHANGE" )
   ENDIF

   If ::Value == Position
      ::Refresh()
   Else
      oPage:ForceHide()
   EndIf

Return oPage

*-----------------------------------------------------------------------------*
METHOD AddControl( oCtrl , PageNumber , Row , Col ) CLASS TMultiPage
*-----------------------------------------------------------------------------*

   If ValType( oCtrl ) $ "CM"
      oCtrl := ::Parent:Control( oCtrl )
   EndIf

   If LEN( ::aPages ) == 0
      Return ::Super:AddControl( oCtrl )
   EndIf

   IF !HB_IsNumeric( PageNumber ) .OR. PageNumber > LEN( ::aPages )
      PageNumber := LEN( ::aPages )
   ENDIF

   IF PageNumber < 1
      PageNumber := 1
   ENDIF

   IF !HB_IsNumeric( Row )
      Row := oCtrl:ContainerRow - ::ContainerRow
   ENDIF

   IF !HB_IsNumeric( Col )
      Col := oCtrl:ContainerCol - ::ContainerCol
   ENDIF

   ::aPages[ PageNumber ]:AddControl( oCtrl, Row, Col )

Return Nil

*-----------------------------------------------------------------------------*
METHOD DeleteControl( oCtrl ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
   AEVAL( ::aPages, { |o| o:DeleteControl( oCtrl ) } )
Return ::Super:DeleteControl( oCtrl )

*-----------------------------------------------------------------------------*
METHOD DeletePage( Position ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
Local nValue, nRealPosition

   If !HB_IsNumeric( Position ) .OR. Position < 1 .OR. Position > LEN( ::aPages )
      Position := LEN( ::aPages )
   EndIf

   nValue := ::Value
   nRealPosition := ::RealPosition( Position )

   ::aPages[ Position ]:Release()
   _OOHG_DeleteArrayItem( ::aPages, Position )
   If nRealPosition != 0
      ::DeleteItem( nRealPosition )
   EndIf

   If nValue == Position
      ::Refresh()
   EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD RealPosition( nPage ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL nCount := 0
   If nPage >= 1 .AND. nPage <= LEN( ::aPages ) .AND. ! ::aPages[ nPage ]:lHidden
      AEVAL( ::aPages, { |o| IF( o:lHidden, , nCount++ ) }, 1, nPage )
   EndIf
RETURN nCount

*-----------------------------------------------------------------------------*
METHOD HidePage( nPage ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL nPos
   IF nPage >= 1 .AND. nPage <= LEN( ::aPages ) .AND. ! ::aPages[ nPage ]:lHidden
      nPos := ::Value
      // Disable hotkey!
      ::DeleteItem( ::RealPosition( nPage ) )
      ::aPages[ nPage ]:lHidden := .T.
      IF nPos > 0
         ::aPages[ nPos ]:ForceHide()
      ENDIF
      nPos := ASCAN( ::aPages, { |o| ! o:lHidden }, MAX( nPos, 1 ) )
      IF nPos == 0
         nPos := ASCAN( ::aPages, { |o| ! o:lHidden }, 1 )
      ENDIF
      IF nPos > 0
         ::Value := nPos
         ::aPages[ nPos ]:Show()
      ENDIF
   ENDIF
RETURN nil

*-----------------------------------------------------------------------------*
METHOD ShowPage( nPage ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
   If nPage >= 1 .AND. nPage <= LEN( ::aPages ) .AND. ::aPages[ nPage ]:lHidden
      ::aPages[ nPage ]:lHidden := .F.
      ::InsertItem( ::RealPosition( nPage ), ::aPages[ nPage ]:Caption, ::aPages[ nPage ]:nImage )
      If ::Value == nPage
         ::Refresh()
      EndIf
      // Enable hotkey!
   EndIf
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Caption( nColumn, uValue ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL oPage, nRealPosition
   oPage := ::aPages[ nColumn ]
   nRealPosition := ::RealPosition( nColumn )
   If nRealPosition > 0
      If VALTYPE( uValue ) $ "CM"
         ::ContainerCaption( nRealPosition, uValue )
      EndIf
      oPage:Caption := ::ContainerCaption( nRealPosition )
   Else
      If VALTYPE( uValue ) $ "CM"
         oPage:Caption := uValue
      EndIf
   EndIf
Return oPage:Caption

*-----------------------------------------------------------------------------*
METHOD Picture( nColumn, uValue ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
LOCAL oPage, nRealPosition
   oPage := ::aPages[ nColumn ]
   nRealPosition := ::RealPosition( nColumn )
   If VALTYPE( uValue ) $ "CM"
      oPage:Picture := uValue
      oPage:nImage := ::oContainerBase:AddBitMap( uValue ) - 1
      If nRealPosition > 0
         ::oContainerBase:Picture( nRealPosition, oPage:nImage )
      EndIf
   EndIf
Return oPage:Picture

*-----------------------------------------------------------------------------*
METHOD EndTab() CLASS TMultiPage
*-----------------------------------------------------------------------------*
   IF _OOHG_LastFrame() == ::oPageClass:Type
      // ERROR: Last page not finished
      ::EndPage()
   ENDIF
   _OOHG_DeleteFrame( ::Type )
   If HB_IsNumeric( ::nFirstValue ) .AND. ! ::Value == ::nFirstValue
      ::Value := ::nFirstValue
   ElseIf ::Value == 0
      ::Value := 1
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD ContainerValue( nValue ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
   If HB_IsNumeric( nValue )
      ::oContainerBase:Value := nValue
   EndIf
Return IF( ::oContainerBase == NIL, 0, ::oContainerBase:Value )

*-----------------------------------------------------------------------------*
METHOD DeleteItem( nItem ) CLASS TMultiPage
*-----------------------------------------------------------------------------*
Local nValue
   nValue := ::ContainerValue
   ::oContainerBase:DeleteItem( nItem )
   If ::ContainerValue == 0
      ::ContainerValue := MIN( nValue, ::ContainerItemCount )
   EndIf
Return nil





CLASS TTabRaw FROM TControl
   DATA Type                INIT "TAB" READONLY
   DATA ImageListColor      INIT CLR_DEFAULT
   DATA ImageListFlags      INIT LR_LOADTRANSPARENT + LR_DEFAULTCOLOR + LR_LOADMAP3DCOLORS
   DATA SetImageListCommand INIT TCM_SETIMAGELIST
   DATA SetImageListWParam  INIT 0

   METHOD Define
   METHOD Value               SETGET

   METHOD ItemCount           BLOCK { |Self| TabCtrl_GetItemCount( ::hWnd ) }
   METHOD InsertItem
   METHOD DeleteItem

   METHOD Caption
   METHOD Picture

   METHOD Events_Notify
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, bold, italic, ;
               underline, strikeout, Images, lRtl, Invisible, ;
               lDisabled, multiline ) CLASS TTabRaw
*-----------------------------------------------------------------------------*
Local Caption, Image, z, nStyle
Local ControlHandle

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )

   If ! HB_IsArray( aCaptions )
      aCaptions := {}
   EndIf
   If ! HB_IsArray( Images )
      Images := {}
   EndIf

   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nCol    VALUE x TYPE "N"

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             if( ValType( Vertical ) == "L"  .AND. Vertical,   TCS_VERTICAL, 0 ) + ;
             if( ValType( HotTrack ) == "L"  .AND. HotTrack,   TCS_HOTTRACK, 0 ) + ;
             if( ValType( Flat ) == "L"      .AND. Flat,       TCS_FLATBUTTONS, 0 ) + ;
             if( ValType( Buttons ) == "L"   .AND. Buttons,    TCS_BUTTONS, 0 ) + ;
             if( ValType( multiline ) == "L" .AND. multiline,  TCS_MULTILINE, 0 )

   ControlHandle = InitTabControl( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, {}, value, nStyle, ::lRtl )

   ::Register( ControlHandle, ControlName, , , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   // Add page by page
   z := 1
   DO WHILE z <= LEN( aCaptions ) .AND. z <= LEN( Images )
      IF z <= LEN( Images ) .AND. VALTYPE( Images[ z ] ) $ "CM"
         Image := Images[ z ]
      ELSE
         Image := ""
      ENDIF
      IF z <= LEN( aCaptions ) .AND. VALTYPE( aCaptions[ z ] ) $ "CM"
         Caption := aCaptions[ z ]
      ELSE
         Caption := ""
      ENDIF
      ::InsertItem( ::ItemCount + 1, Caption, Image )
      z++
   ENDDO

   IF HB_IsNumeric( value )
      ::Value := value
   ELSE
      ::Value := 1
   ENDIF

   ASSIGN ::OnChange    VALUE Change    TYPE "B"

Return Self

*-----------------------------------------------------------------------------*
METHOD Value( nValue ) CLASS TTabRaw
*-----------------------------------------------------------------------------*
   IF HB_IsNumeric( nValue )
      TabCtrl_SetCurSel( ::hWnd, nValue )
      ::DoChange()
   ENDIF
RETURN TABCTRL_GETCURSEL( ::hWnd )

*-----------------------------------------------------------------------------*
METHOD InsertItem( nPosition, cCaption, xImage ) CLASS TTabRaw
*-----------------------------------------------------------------------------*
   TABCTRL_INSERTITEM( ::hWnd, nPosition - 1, cCaption )

   If VALTYPE( xImage ) $ "CM"
      xImage := ::AddBitMap( xImage ) - 1
   EndIf
   If HB_IsNumeric( xImage ) .AND. xImage >= 0
      SetTabPageImage( ::hWnd, nPosition, xImage )
   EndIf
RETURN nil

*-----------------------------------------------------------------------------*
METHOD DeleteItem( nPosition ) CLASS TTabRaw
*-----------------------------------------------------------------------------*
   TabCtrl_DeleteItem( ::hWnd, nPosition - 1 )
RETURN nil

*-----------------------------------------------------------------------------*
METHOD Caption( nColumn, uValue ) CLASS TTabRaw
*-----------------------------------------------------------------------------*
   IF VALTYPE( uValue ) $ "CM"
      SetTabCaption( ::hWnd, nColumn, uValue )
      ::Refresh()
   ENDIF
Return GetTabCaption( ::hWnd, nColumn )

*-----------------------------------------------------------------------------*
METHOD Picture( nColumn, uValue ) CLASS TTabRaw
*-----------------------------------------------------------------------------*
   If VALTYPE( uValue ) $ "CM"
      // ::Picture( nColumn ) := uValue
      uValue := ::AddBitMap( uValue ) - 1
   EndIf
   If HB_IsNumeric( uValue )
      SetTabPageImage( ::hWnd, nColumn, uValue )
      ::Refresh()
   EndIf
Return nil

*-----------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TTabRaw
*-----------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == TCN_SELCHANGE
      ::Refresh()
      ::DoChange()
      Return nil

   EndIf

Return ::Super:Events_Notify( wParam, lParam )





CLASS TTabPage FROM TControlGroup
   DATA Type      INIT "TABPAGE" READONLY
   DATA Picture   INIT ""
   DATA Position  INIT 0
   DATA nImage    INIT -1
   DATA Caption   INIT ""

   METHOD EndPage             BLOCK { |Self| _OOHG_DeleteFrame( ::Type ) }

   METHOD ContainerVisible

   METHOD SetFocus            BLOCK { |Self| ::Container:SetFocus() , ::Container:Value := ::Position , Self }
   METHOD Events_Size
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD ContainerVisible() CLASS TTabPage
*-----------------------------------------------------------------------------*
Local lRet := .F.
   IF ::Super:ContainerVisible
      lRet := ( ::Container:Value == ::Position )
   ENDIF
RETURN lRet

*-----------------------------------------------------------------------------*
METHOD Events_Size() CLASS TTabPage
*-----------------------------------------------------------------------------*
LOCAL oTab
   oTab := ::Container
   DO EVENTS
   ::SizePos( , , oTab:Width, oTab:Height )
Return Nil





CLASS TTabPageInternal FROM TFormInternal
   DATA Type       INIT "TABPAGE" READONLY
   DATA Picture    INIT ""
   DATA Position   INIT 0
   DATA nImage     INIT -1
   DATA lHidden    INIT .F.
   DATA Caption    INIT ""

   METHOD Define
   METHOD EndPage             BLOCK { |Self| _OOHG_DeleteFrame( ::Type ) }
   METHOD Events_Size

   METHOD SetFocus            BLOCK { |Self| ::Container:SetFocus() , ::Container:Value := ::Position , ::Super:SetFocus() , Self }
ENDCLASS

*-----------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm ) CLASS TTabPageInternal
*-----------------------------------------------------------------------------*
Local aArea

   ::SearchParent( ParentForm )
   aArea := _OOHG_TabPage_GetArea( ::Container )
   ::Super:Define( ControlName,, aArea[ 1 ], aArea[ 2 ], aArea[ 3 ], aArea[ 4 ], ParentForm )
   END WINDOW
   ::ContainerhWndValue := ::hWnd

   ::RowMargin := - aArea[ 2 ]
   ::ColMargin := - aArea[ 1 ]
Return Self

*-----------------------------------------------------------------------------*
METHOD Events_Size() CLASS TTabPageInternal
*-----------------------------------------------------------------------------*
Local aArea
   aArea := _OOHG_TabPage_GetArea( ::Container )
   ::RowMargin := - aArea[ 2 ]
   ::ColMargin := - aArea[ 1 ]
   ::SizePos( aArea[ 2 ], aArea[ 1 ], aArea[ 3 ], aArea[ 4 ] )
   ::ScrollControls()
Return NIL

STATIC FUNCTION _OOHG_TabPage_GetArea( oTab )
LOCAL aRect
   aRect := TabCtrl_GetItemRect( oTab:hWnd, 0 )
   aRect := { 2, aRect[ 4 ] + 2, oTab:Width - 2, oTab:Height - 2 }
RETURN { aRect[ 1 ], aRect[ 2 ], aRect[ 3 ] - aRect[ 1 ], aRect[ 4 ] - aRect[ 2 ] } // { Col, Row, Width, Height }





EXTERN InitTabControl, SetTabCaption
EXTERN TabCtrl_SetCurSel, TabCtrl_GetCurSel, TabCtrl_InsertItem, TabCtrl_DeleteItem, TabCtrl_GetItemRect

#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif
#if ( _WIN32_IE < 0x0400 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0400
#endif

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITTABCONTROL )
{
   PHB_ITEM hArray;
   HWND hbutton;
   TC_ITEM tie;
   int i;

   int Style = WS_CHILD | hb_parni( 9 );
   int iStyleEx = _OOHG_RTL_Status( hb_parl( 10 ) );

   hArray = hb_param( 7, HB_IT_ARRAY );
   Style |= WS_GROUP;

   hbutton = CreateWindowEx( iStyleEx, WC_TABCONTROL, NULL, Style,
                             hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                             HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   tie.mask = TCIF_TEXT ;
   tie.iImage = -1;

   for( i = hb_parinfa( 7, 0 ); i > 0; i-- )
   {
      tie.pszText = (LPTSTR) hb_arrayGetCPtr( hArray, i );
      TabCtrl_InsertItem( hbutton, 0, &tie );
   }

   TabCtrl_SetCurSel( hbutton, hb_parni( 8 ) - 1 );

   lpfnOldWndProc = ( WNDPROC ) SetWindowLong( ( HWND ) hbutton, GWL_WNDPROC, ( LONG ) SubClassFunc );

   HWNDret( hbutton );
}

HB_FUNC (TABCTRL_SETCURSEL)
{

	HWND hwnd;
	int s;

   hwnd = HWNDparam( 1 );

	s = hb_parni (2);

	TabCtrl_SetCurSel( hwnd , s-1 );

}

HB_FUNC( TABCTRL_GETCURSEL )
{
   hb_retni( TabCtrl_GetCurSel( HWNDparam( 1 ) ) + 1 ) ;
}

HB_FUNC( TABCTRL_GETITEMCOUNT )
{
   hb_retni( TabCtrl_GetItemCount( HWNDparam( 1 ) ) ) ;
}

HB_FUNC( TABCTRL_INSERTITEM )
{
   TC_ITEM tie;
   int i;

   i = hb_parni( 2 );

   tie.mask = TCIF_TEXT;
   tie.iImage = -1;
   tie.pszText = ( char * ) hb_parc( 3 );

   TabCtrl_InsertItem( HWNDparam( 1 ), i, &tie );
}

HB_FUNC( TABCTRL_DELETEITEM )
{
   TabCtrl_DeleteItem( HWNDparam( 1 ), hb_parni( 2 ) );
}

HB_FUNC( SETTABCAPTION )
{
   TC_ITEM tie;

   tie.mask = TCIF_TEXT ;
   tie.pszText = ( char * ) hb_parc(3) ;

   TabCtrl_SetItem( HWNDparam( 1 ), hb_parni( 2 ) - 1, &tie );
}

HB_FUNC( GETTABCAPTION )
{
   TC_ITEM tie;
   char cBuffer[ 1025 ];

   tie.mask = TCIF_TEXT ;
   tie.pszText = ( char * ) cBuffer;
   tie.cchTextMax = 1024;

   cBuffer[ 0 ] = 0;
   TabCtrl_GetItem( HWNDparam( 1 ), hb_parni( 2 ) - 1, &tie );
   cBuffer[ 1024 ] = 0;

   hb_retc( cBuffer );
}

HB_FUNC( SETTABPAGEIMAGE )
{
   TC_ITEM tie;

   tie.mask = TCIF_IMAGE ;
   tie.iImage = hb_parni( 3 );
   TabCtrl_SetItem( HWNDparam( 1 ), hb_parni( 2 ) - 1, &tie );
}

HB_FUNC( TABCTRL_GETITEMRECT )
{
   RECT rect;

   TabCtrl_GetItemRect( HWNDparam( 1 ), hb_parni( 2 ), &rect );
   hb_reta( 4 );
   HB_STORNI( rect.left,   -1, 1 );
   HB_STORNI( rect.top,    -1, 2 );
   HB_STORNI( rect.right,  -1, 3 );
   HB_STORNI( rect.bottom, -1, 4 );
}
#pragma ENDDUMP
