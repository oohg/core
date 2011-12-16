/*
 * $Id: tabdemo.prg,v 1.1 2011-12-16 00:17:21 guerra000 Exp $
 */

#include "oohg.ch"

PROCEDURE MAIN
   DEFINE WINDOW Main WIDTH 680 HEIGHT 600 CLIENTAREA ;
          NOSIZE NOMAXIMIZE ;
          TITLE "Dynamic TABs demo"

      @ 10,10 LABEL Title WIDTH 660 HEIGHT 40 CENTER ;
              VALUE "You can create TAB-like controls using any value-based one." + ;
                    CHR( 13 ) + CHR( 10 ) + ;
                    "Check out the following menu:"

      DEFINE TAB Menu AT 60,10 WIDTH 660 HEIGHT 530 VERTICAL SUBCLASS TTabRadio
         CreateTabPage( "Standard TAB", "TTab",        .F., .F., "Standard TAB control" )
         CreateTabPage( "Vertical TAB", "TTab",        .T., .F., "Vertical TAB control" )
         CreateTabPage( "Radiogroup",   "TTabRadio",   .F., .F., "Radiogroup control" )
         CreateTabPage( "Combobox",     "TTabCombo",   .F., .F., "Combobox control" )
         CreateTabPage( "Listbox",      "TTabList",    .F., .F., "Listbox control" )
         CreateTabPage( "Checkbox",     "TTabCheck",   .F., .T., "Checkbox control" )
         CreateTabPage( "Spinner",      "TTabSpinner", .F., .F., "Spinner control" )
         CreateTabPage( "Slider",       "TTabSlider",  .F., .F., "Slider control" )
      END TAB
      Main.Menu.SetFocus()
   END WINDOW
   CENTER WINDOW Main
   ACTIVATE WINDOW Main
RETURN

PROCEDURE CreateTabPage( cOption, cSubClass, lVertical, lCheckbox, cTitle )
STATIC nName := 0, nValue := 0
LOCAL cName
   nValue++
   If nValue > 4
      nValue := 1
   EndIf
   nName++
   cName := "Page" + STRZERO( nName, 2 )
   DEFINE PAGE cOption
      @  30,150 LABEL ( cName + "_Label" ) VALUE cTitle WIDTH 500
      @  60,150 FRAME ( cName + "_Frame" ) WIDTH 500 HEIGHT 460
      IF lVertical
         DEFINE TAB ( cName + "_Tab" ) AT 80,160 WIDTH 480 HEIGHT 430 VALUE nValue SUBCLASS &cSubClass VERTICAL
      ELSE
         DEFINE TAB ( cName + "_Tab" ) AT 80,160 WIDTH 480 HEIGHT 430 VALUE nValue SUBCLASS &cSubClass
      ENDIF
         DEFINE PAGE "One"
            @  30,150 LABEL ( cName + "_Page_1" ) VALUE "Page 1 " + cTitle WIDTH 320
         END PAGE
         DEFINE PAGE "Two"
            @  90,150 LABEL ( cName + "_Page_2" ) VALUE "Page 2 " + cTitle WIDTH 320
         END PAGE
         If ! lCheckbox
            DEFINE PAGE "Three"
               @ 150,150 LABEL ( cName + "_Page_3" ) VALUE "Page 3 " + cTitle WIDTH 320
            END PAGE
            DEFINE PAGE "Four"
               @ 210,150 LABEL ( cName + "_Page_4" ) VALUE "Page 4 " + cTitle WIDTH 320
            END PAGE
         EndIf
      END TAB
   END PAGE
RETURN





#include "hbclass.ch"

*-----------------------------------------------------------------------------*
CLASS TTabList FROM TMultiPage
   DATA Type                INIT "TAB" READONLY
   DATA lInternals          INIT .F.

   METHOD Define
ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals, Invisible, ;
               lDisabled, multiline ) CLASS TTabList

   ::Super:Define( ControlName, ParentForm, x, y, w, h, , , ;
                   FontName, FontSize, bold, italic, underline, strikeout, ;
                   Invisible, lDisabled, lRtl, change, value )

   // Unused...
   EMPTY( Buttons )
   EMPTY( Flat )
   EMPTY( HotTrack )
   EMPTY( Vertical )
   EMPTY( multiline )
   @ 0,0 LISTBOX 0 OBJ ::oContainerBase PARENT ( Self ) ;
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





*-----------------------------------------------------------------------------*
CLASS TTabCheck FROM TMultiPage
   DATA Type                INIT "TAB" READONLY
   DATA lInternals          INIT .F.

   METHOD Define
   METHOD ContainerValue             SETGET
   METHOD ContainerCaption
   METHOD ContainerItemCount         BLOCK { || ( ASCAN( ::aCaptions, NIL ) + 2 ) % 3 }
   METHOD InsertItem
   METHOD DeleteItem

   DATA   aCaptions                  INIT { NIL, NIL }
   METHOD VerifyCaption
ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals, Invisible, ;
               lDisabled, multiline ) CLASS TTabCheck

   ::Super:Define( ControlName, ParentForm, x, y, w, h, , , ;
                   FontName, FontSize, bold, italic, underline, strikeout, ;
                   Invisible, lDisabled, lRtl, change, value )

   // Unused...
   EMPTY( Buttons )
   EMPTY( Flat )
   EMPTY( HotTrack )
   EMPTY( multiline )
   EMPTY( Vertical )
   @ 0,0 CHECKBOX 0 OBJ ::oContainerBase PARENT ( Self ) ;
         TOOLTIP tooltip
   If HB_IsLogical( notabstop ) .and. notabstop
      ::oContainerBase:TabStop := .F.
   EndIf

   ASSIGN ::lInternals VALUE lInternals TYPE "L"
   If ::lInternals
      ::oPageClass := TTabPageInternal()
   EndIf

   ::CreatePages( aCaptions, Images, aPageMap, aMnemonic )

   ::oContainerBase:OnChange := { || ::Refresh() , ::VerifyCaption() , ::DoChange() }
Return Self

METHOD ContainerValue( nValue ) CLASS TTabCheck
   If HB_IsNumeric( nValue )
      ::oContainerBase:Value := ( nValue > 1 )
   EndIf
RETURN IF( ::oContainerBase == NIL, 0, IF( ::oContainerBase:Value, 2, 1 ) )

METHOD ContainerCaption( nPosition, xValue ) CLASS TTabCheck
LOCAL cCaption
   If VALTYPE( xValue ) $ "CM"
      ::aCaptions[ nPosition ] := xValue
      ::VerifyCaption()
   EndIf
   cCaption := ::aCaptions[ nPosition ]
RETURN IF( cCaption == NIL, "", cCaption )

METHOD InsertItem( nPosition, cCaption ) CLASS TTabCheck
   If ! HB_IsString( cCaption )
      cCaption := ""
   EndIf
   If ! HB_IsNumeric( nPosition ) .OR. nPosition < 1 .OR. nPosition > 2
      nPosition := ASCAN( ::aCaptions, NIL )
   EndIf
   AINS( ::aCaptions, nPosition )
   ::ContainerCaption( nPosition, cCaption )
Return nil

METHOD DeleteItem( nPosition ) CLASS TTabCheck
   ADEL( ::aCaptions, nPosition )
   ::VerifyCaption()
Return nil

METHOD VerifyCaption() CLASS TTabCheck
LOCAL cCaption
   cCaption := ::aCaptions[ ::ContainerValue ]
   ::oContainerBase:Caption := IF( cCaption == NIL, "", cCaption )
RETURN nil





*-----------------------------------------------------------------------------*
CLASS TTabSpinner FROM TMultiPage
   DATA Type                INIT "TAB" READONLY
   DATA lInternals          INIT .F.

   METHOD Define
   METHOD ContainerCaption           BLOCK { || "" }
   METHOD ContainerItemCount         BLOCK { |Self| ::oContainerBase:RangeMax }
   METHOD InsertItem
   METHOD DeleteItem
ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals, Invisible, ;
               lDisabled, multiline ) CLASS TTabSpinner

   ::Super:Define( ControlName, ParentForm, x, y, w, h, , , ;
                   FontName, FontSize, bold, italic, underline, strikeout, ;
                   Invisible, lDisabled, lRtl, change, value )

   // Unused...
   EMPTY( Buttons )
   EMPTY( Flat )
   EMPTY( HotTrack )
   EMPTY( multiline )
   EMPTY( Vertical )
   @ 0,0 SPINNER 0 OBJ ::oContainerBase PARENT ( Self ) ;
         RANGE 0, 0 TOOLTIP tooltip
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

METHOD InsertItem( nPosition, cCaption ) CLASS TTabSpinner
   ::oContainerBase:RangeMax++
   If ::oContainerBase:RangeMin == 0
      ::oContainerBase:RangeMin := 1
   EndIf
Return nil

METHOD DeleteItem( nPosition ) CLASS TTabSpinner
   If ::oContainerBase:RangeMax >= nPosition
      If ::oContainerBase:RangeMax == 1
         ::oContainerBase:RangeMin := 0
      EndIf
      ::oContainerBase:RangeMax--
   EndIf
Return nil





*-----------------------------------------------------------------------------*
CLASS TTabSlider FROM TMultiPage
   DATA Type                INIT "TAB" READONLY
   DATA lInternals          INIT .F.

   METHOD Define
   METHOD ContainerCaption           BLOCK { || "" }
   METHOD ContainerItemCount         BLOCK { |Self| ::oContainerBase:RangeMax }
   METHOD InsertItem
   METHOD DeleteItem
ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, aCaptions, aPageMap, ;
               value, fontname, fontsize, tooltip, change, Buttons, Flat, ;
               HotTrack, Vertical, notabstop, aMnemonic, bold, italic, ;
               underline, strikeout, Images, lRtl, lInternals, Invisible, ;
               lDisabled, multiline ) CLASS TTabSlider

   ::Super:Define( ControlName, ParentForm, x, y, w, h, , , ;
                   FontName, FontSize, bold, italic, underline, strikeout, ;
                   Invisible, lDisabled, lRtl, change, value )

   // Unused...
   EMPTY( Buttons )
   EMPTY( Flat )
   EMPTY( HotTrack )
   EMPTY( multiline )
   EMPTY( Vertical )
   @ 0,0 SLIDER 0 OBJ ::oContainerBase PARENT ( Self ) ;
         RANGE 0, 0 TOOLTIP tooltip
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

METHOD InsertItem( nPosition, cCaption ) CLASS TTabSlider
   ::oContainerBase:RangeMax++
   If ::oContainerBase:RangeMin == 0
      ::oContainerBase:RangeMin := 1
   EndIf
Return nil

METHOD DeleteItem( nPosition ) CLASS TTabSlider
   If ::oContainerBase:RangeMax >= nPosition
      If ::oContainerBase:RangeMax == 1
         ::oContainerBase:RangeMin := 0
      EndIf
      ::oContainerBase:RangeMax--
   EndIf
Return nil
