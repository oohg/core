/*
 * $Id: formedit.prg,v 1.40 2014-10-01 01:15:50 fyurisich Exp $
 */
/*
 * ooHG IDE+ form generator
 *
 * Copyright 2002-2014 Ciro Vargas Clemov <cvc@oohg.org>
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
 * along with this software. If not, visit the web site:
 * <http://www.gnu.org/licenses/>
 *
 */

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

#define UpperNIL( cValue ) IIF( Upper( AllTrim( cValue ) ) == 'NIL', 'NIL', cValue )
#define IDE_LAST_CTRL 38

//------------------------------------------------------------------------------
CLASS TFormEditor
//------------------------------------------------------------------------------
   // Miscelaneous editor's variables
   DATA aLine                INIT {}
   DATA cForm                INIT ''
   DATA CurrentControl       INIT 1
   DATA cvcControls          INIT NIL
   DATA Form_Main            INIT NIL
   DATA FormCtrlOrder        INIT NIL
   DATA lAddingNewControl    INIT .F.
   DATA lFSave               INIT .T.
   DATA FormList             INIT NIL
   DATA nIndexW              INIT 0           // Index in control's arrays of the control being dragged or sized
   DATA myIde                INIT NIL
   DATA myTbEditor           INIT NIL
   DATA myMMCtrl             INIT NIL
   DATA myCMCtrl             INIT NIL
   DATA myNMCtrl             INIT NIL
   DATA myDMCtrl             INIT {}
   DATA nControlW            INIT 0           // Number of controls in the form under design
   DATA nEditorIndex         INIT 0
   DATA nHandleA             INIT 0           // Index of the selected control into oDesignForm:aControls array
   DATA oContextMenu         INIT NIL
   DATA oCtrlList            INIT NIL
   DATA oDesignForm          INIT NIL
   DATA oWaitMsg             INIT NIL
   DATA swCursor             INIT 0           // 1 = control is being dragged   2 = control is being sized   0 = none
   DATA swTab                INIT .F.

   /*
      Arrays to hold the values of properties and events of the controls in the designed form.
      Each time a new property or event is added to a control, you must add a new DATA here (except when you use a existing one).
      In such a case, you must handle it in methods IniArray, SwapArray, DelArray, CopyControl, p(*****), Save, Properties_Click and Events_Click.
   */
   DATA a3State              INIT {}
   DATA aAction              INIT {}
   DATA aAction2             INIT {}
   DATA aAddress             INIT {}
   DATA aAfterColMove        INIT {}
   DATA aAfterColSize        INIT {}
   DATA aAppend              INIT {}
   DATA aAutoPlay            INIT {}
   DATA aBackColor           INIT {}
   DATA aBackground          INIT {}
   DATA aBackgroundColor     INIT {}
   DATA aBeforeAutoFit       INIT {}
   DATA aBeforeColMove       INIT {}
   DATA aBeforeColSize       INIT {}
   DATA aBold                INIT {}
   DATA aBorder              INIT {}
   DATA aBoth                INIT {}
   DATA aBreak               INIT {}
   DATA aBuffer              INIT {}
   DATA aButtons             INIT {}
   DATA aButtonWidth         INIT {}
   DATA aByCell              INIT {}
   DATA aCancel              INIT {}
   DATA aCaption             INIT {}
   DATA aCenter              INIT {}
   DATA aCenterAlign         INIT {}
   DATA aCheckBoxes          INIT {}
   DATA aClientEdge          INIT {}
   DATA aCObj                INIT {}
   DATA aColumnControls      INIT {}
   DATA aColumnInfo          INIT {}
   DATA aControlW            INIT {}          // Name of the controls in the designed form (real object's names, lowercased)
   DATA aCtrlType            INIT {}
   DATA aDate                INIT {}
   DATA aDefaultYear         INIT {}
   DATA aDelayedLoad         INIT {}
   DATA aDelete              INIT {}
   DATA aDeleteMsg           INIT {}
   DATA aDeleteWhen          INIT {}
   DATA aDescend             INIT {}
   DATA aDIBSection          INIT {}
   DATA aDisplayEdit         INIT {}
   DATA aDoubleBuffer        INIT {}
   DATA aDrag                INIT {}
   DATA aDrop                INIT {}
   DATA aDynamicBackColor    INIT {}
   DATA aDynamicCtrls        INIT {}
   DATA aDynamicForeColor    INIT {}
   DATA aDynBlocks           INIT {}
   DATA aEdit                INIT {}
   DATA aEditKeys            INIT {}
   DATA aEditLabels          INIT {}
   DATA aEnabled             INIT {}
   DATA aExclude             INIT {}
   DATA aExtDblClick         INIT {}
   DATA aField               INIT {}
   DATA aFields              INIT {}
   DATA aFile                INIT {}
   DATA aFileType            INIT {}
   DATA aFirstItem           INIT {}
   DATA aFit                 INIT {}
   DATA aFixBlocks           INIT {}
   DATA aFixedCols           INIT {}
   DATA aFixedCtrls          INIT {}
   DATA aFixedWidths         INIT {}
   DATA aFlat                INIT {}
   DATA aFocusedPos          INIT {}
   DATA aFocusRect           INIT {}
   DATA aFontColor           INIT {}
   DATA aFontItalic          INIT {}
   DATA aFontName            INIT {}
   DATA aFontSize            INIT {}
   DATA aFontStrikeout       INIT {}
   DATA aFontUnderline       INIT {}
   DATA aForceRefresh        INIT {}
   DATA aForceScale          INIT {}
   DATA aFull                INIT {}
   DATA aGripperText         INIT {}
   DATA aHandCursor          INIT {}
   DATA aHBitmap             INIT {}
   DATA aHeaderImages        INIT {}
   DATA aHeaders             INIT {}
   DATA aHelpID              INIT {}
   DATA aHotTrack            INIT {}
   DATA aImage               INIT {}
   DATA aImageMargin         INIT {}
   DATA aImagesAlign         INIT {}
   DATA aImageSize           INIT {}
   DATA aImageSource         INIT {}
   DATA aIncrement           INIT {}
   DATA aIncremental         INIT {}
   DATA aIndent              INIT {}
   DATA aInPlace             INIT {}
   DATA aInputMask           INIT {}
   DATA aInsertType          INIT {}
   DATA aIntegralHeight      INIT {}
   DATA aInvisible           INIT {}
   DATA aItemCount           INIT {}
   DATA aItemIDs             INIT {}
   DATA aItemImageNumber     INIT {}
   DATA aItemImages          INIT {}
   DATA aItems               INIT {}
   DATA aItemSource          INIT {}
   DATA aJustify             INIT {}
   DATA aLeft                INIT {}
   DATA aLikeExcel           INIT {}
   DATA aListWidth           INIT {}
   DATA aLock                INIT {}
   DATA aLowerCase           INIT {}
   DATA aMarquee             INIT {}
   DATA aMaxLength           INIT {}
   DATA aMultiLine           INIT {}
   DATA aMultiSelect         INIT {}
   DATA aName                INIT {}          // Name of the control in the fmg file, must be unique
   DATA aNo3DColors          INIT {}
   DATA aNoAutoSizeMovie     INIT {}
   DATA aNoAutoSizeWindow    INIT {}
   DATA aNoClickOnCheck      INIT {}
   DATA aNodeImages          INIT {}
   DATA aNoDelMsg            INIT {}
   DATA aNoErrorDlg          INIT {}
   DATA aNoFocusRect         INIT {}
   DATA aNoHeaders           INIT {}
   DATA aNoHideSel           INIT {}
   DATA aNoHScroll           INIT {}
   DATA aNoLines             INIT {}
   DATA aNoLoadTrans         INIT {}
   DATA aNoMenu              INIT {}
   DATA aNoModalEdit         INIT {}
   DATA aNoOpen              INIT {}
   DATA aNoPlayBar           INIT {}
   DATA aNoPrefix            INIT {}
   DATA aNoRClickOnCheck     INIT {}
   DATA aNoRefresh           INIT {}
   DATA aNoRootButton        INIT {}
   DATA aNoTabStop           INIT {}
   DATA aNoTicks             INIT {}
   DATA aNoToday             INIT {}
   DATA aNoTodayCircle       INIT {}
   DATA aNoVScroll           INIT {}
   DATA aNumber              INIT {}          // End line of control's definition in .fmg file
   DATA aNumeric             INIT {}
   DATA aOnAbortEdit         INIT {}
   DATA aOnAppend            INIT {}
   DATA aOnChange            INIT {}
   DATA aOnCheckChg          INIT {}
   DATA aOnDblClick          INIT {}
   DATA aOnDelete            INIT {}
   DATA aOnDisplayChange     INIT {}
   DATA aOnDrop              INIT {}
   DATA aOnEditCell          INIT {}
   DATA aOnEnter             INIT {}
   DATA aOnGotFocus          INIT {}
   DATA aOnHeadClick         INIT {}
   DATA aOnHeadRClick        INIT {}
   DATA aOnHScroll           INIT {}
   DATA aOnLabelEdit         INIT {}
   DATA aOnListClose         INIT {}
   DATA aOnListDisplay       INIT {}
   DATA aOnLostFocus         INIT {}
   DATA aOnMouseMove         INIT {}
   DATA aOnQueryData         INIT {}
   DATA aOnRefresh           INIT {}
   DATA aOnSelChange         INIT {}
   DATA aOnTextFilled        INIT {}
   DATA aOnVScroll           INIT {}
   DATA aOpaque              INIT {}
   DATA aPageNames           INIT {}
   DATA aPageObjs            INIT {}
   DATA aPageSubClasses      INIT {}
   DATA aPassWord            INIT {}
   DATA aPicture             INIT {}
   DATA aPlainText           INIT {}
   DATA aPLM                 INIT {}
   DATA aRange               INIT {}
   DATA aReadOnly            INIT {}
   DATA aReadOnlyB           INIT {}
   DATA aRecCount            INIT {}
   DATA aRefresh             INIT {}
   DATA aReplaceField        INIT {}
   DATA aRightAlign          INIT {}
   DATA aRTL                 INIT {}
   DATA aSearchLapse         INIT {}
   DATA aSelBold             INIT {}
   DATA aSelColor            INIT {}
   DATA aShowAll             INIT {}
   DATA aShowMode            INIT {}
   DATA aShowName            INIT {}
   DATA aShowNone            INIT {}
   DATA aShowPosition        INIT {}
   DATA aSingleBuffer        INIT {}
   DATA aSingleExpand        INIT {}
   DATA aSmooth              INIT {}
   DATA aSort                INIT {}
   DATA aSourceOrder         INIT {}
   DATA aSpacing             INIT {}
   DATA aSpeed               INIT {}          // Start line of control's definition in .fmg file
   DATA aStretch             INIT {}
   DATA aSubClass            INIT {}
   DATA aSync                INIT {}
   DATA aTabPage             INIT {}          // Each item is { cTabName, nPageCount }
   DATA aTarget              INIT {}
   DATA aTextHeight          INIT {}
   DATA aThemed              INIT {}
   DATA aTitleBackColor      INIT {}
   DATA aTitleFontColor      INIT {}
   DATA aToolTip             INIT {}
   DATA aTop                 INIT {}
   DATA aTrailingFontColor   INIT {}
   DATA aTransparent         INIT {}
   DATA aUnSync              INIT {}
   DATA aUpdate              INIT {}
   DATA aUpdateColors        INIT {}
   DATA aUpDown              INIT {}
   DATA aUpperCase           INIT {}
   DATA aValid               INIT {}
   DATA aValidMess           INIT {}
   DATA aValue               INIT {}
   DATA aValueL              INIT {}
   DATA aValueN              INIT {}
   DATA aValueSource         INIT {}
   DATA aVertical            INIT {}
   DATA aVirtual             INIT {}
   DATA aVisible             INIT {}
   DATA aWeekNumbers         INIT {}
   DATA aWhen                INIT {}
   DATA aWhiteBack           INIT {}
   DATA aWidths              INIT {}
   DATA aWorkArea            INIT {}
   DATA aWrap                INIT {}

   // Values of properties of the designed form.
   DATA cFBackcolor          INIT 'NIL'
   DATA cFBackImage          INIT ""
   DATA cFCursor             INIT ""
   DATA cFDblClickProcedure  INIT ""
   DATA cFFontColor          INIT 'NIL'
   DATA cFFontName           INIT ''
   DATA cFGripperText        INIT ""
   DATA cFIcon               INIT ""
   DATA cFMClickProcedure    INIT ""
   DATA cFMDblClickProcedure INIT ""
   DATA cFMoveProcedure      INIT ""
   DATA cFName               INIT ""
   DATA cFNotifyIcon         INIT ""
   DATA cFNotifyToolTip      INIT ""
   DATA cFObj                INIT ""
   DATA cFOnMaximize         INIT ""
   DATA cFOnMinimize         INIT ""
   DATA cFontColor           INIT ""
   DATA cFParent             INIT ""
   DATA cFRClickProcedure    INIT ""
   DATA cFRDblClickProcedure INIT ""
   DATA cFRestoreProcedure   INIT ""
   DATA cFSubClass           INIT ""
   DATA cFTitle              INIT ""
   DATA lFBreak              INIT .F.
   DATA lFChild              INIT .F.
   DATA lFClientArea         INIT .F.
   DATA lFFocused            INIT .F.
   DATA lFHelpButton         INIT .F.
   DATA lFInternal           INIT .F.
   DATA lFMain               INIT .F.
   DATA lFMDI                INIT .F.
   DATA lFMDIChild           INIT .F.
   DATA lFMDIClient          INIT .F.
   DATA lFModal              INIT .F.
   DATA lFModalSize          INIT .F.
   DATA lFNoAutoRelease      INIT .F.
   DATA lFNoCaption          INIT .F.
   DATA lFNoMaximize         INIT .F.
   DATA lFNoMinimize         INIT .F.
   DATA lFNoShow             INIT .F.
   DATA lFNoSize             INIT .F.
   DATA lFNoSysmenu          INIT .F.
   DATA lFRTL                INIT .F.
   DATA lFSplitChild         INIT .F.
   DATA lFStretch            INIT .F.
   DATA lFTopmost            INIT .F.
   DATA nFFontSize           INIT 0
   DATA nFMaxHeight          INIT 0
   DATA nFMaxWidth           INIT 0
   DATA nFMinHeight          INIT 0
   DATA nFMinWidth           INIT 0
   DATA nFVirtualH           INIT 0
   DATA nFVirtualW           INIT 0

   // Values of events of the designed form.
   DATA cFOnGotFocus         INIT ""
   DATA cFOnHScrollbox       INIT ""
   DATA cFOnInit             INIT ""
   DATA cFOnInteractiveClose INIT ""
   DATA cFOnLostFocus        INIT ""
   DATA cFOnMouseClick       INIT ""
   DATA cFOnMouseDrag        INIT ""
   DATA cFOnMouseMove        INIT ""
   DATA cFOnNotifyClick      INIT ""
   DATA cFOnPaint            INIT ""
   DATA cFOnRelease          INIT ""
   DATA cFOnScrollDown       INIT ""
   DATA cFOnScrollLeft       INIT ""
   DATA cFOnScrollRight      INIT ""
   DATA cFOnScrollUp         INIT ""
   DATA cFOnSize             INIT ""
   DATA cFOnVScrollbox       INIT ""

   // Values of properties and events of the statusbar of the designed form.
   DATA cSAction             INIT ''
   DATA cSAlign              INIT ''
   DATA cSCAction            INIT ''
   DATA cSCAlign             INIT ''
   DATA cSCaption            INIT ''
   DATA cSCImage             INIT ''
   DATA cSCObj               INIT ''
   DATA cSCStyle             INIT ''
   DATA cSCToolTip           INIT ''
   DATA cSDAction            INIT ''
   DATA cSDAlign             INIT ''
   DATA cSDStyle             INIT ''
   DATA cSDToolTip           INIT ''
   DATA cSFontName           INIT ''
   DATA cSIcon               INIT ''
   DATA cSKAction            INIT ''
   DATA cSKAlign             INIT ''
   DATA cSKImage             INIT ''
   DATA cSKStyle             INIT ''
   DATA cSKToolTip           INIT ''
   DATA cSStyle              INIT ''
   DATA cSSubClass           INIT ''
   DATA cSToolTip            INIT ''
   DATA cSWidth              INIT ''
   DATA lSBold               INIT .F.
   DATA lSCAmPm              INIT .F.
   DATA lSDate               INIT .F.
   DATA lSItalic             INIT .F.
   DATA lSKeyboard           INIT .F.
   DATA lSNoAutoAdjust       INIT .F.
   DATA lSStat               INIT .F.
   DATA lSStrikeout          INIT .F.
   DATA lSTime               INIT .F.
   DATA lSTop                INIT .F.
   DATA lSUnderline          INIT .F.
   DATA nSCWidth             INIT 0
   DATA nSDWidth             INIT 0
   DATA nSFontSize           INIT 0
   DATA nSKWidth             INIT 0

   // Lowercase needed
   DATA ControlPrefix        INIT { 'form_', 'button_', 'checkbox_', 'list_', 'combo_', 'checkbtn_', 'grid_', 'frame_', 'tab_', 'image_', 'animate_', 'datepicker_', 'text_', 'edit_', 'label_', 'player_', 'progressbar_', 'radiogroup_', 'slider_', 'spinner_', 'piccheckbutt_', 'picbutt_', 'timer_', 'browse_', 'tree_', 'ipaddress_', 'monthcal_',     'hyperlink_', 'richeditbox_', 'timepicker_', 'xbrowse_', 'activex_', 'checklist_', 'hotkeybox_', 'picture_', 'progressmeter_', 'scrollbar_', 'textarray_' }
   // Uppercase needed
   DATA ControlType          INIT { 'FORM',  'BUTTON',  'CHECKBOX',  'LIST',  'COMBO',  'CHECKBTN',  'GRID',  'FRAME',  'TAB',  'IMAGE',  'ANIMATE',  'DATEPICKER',  'TEXT',  'EDIT',  'LABEL',  'PLAYER',  'PROGRESSBAR',  'RADIOGROUP',  'SLIDER',  'SPINNER',  'PICCHECKBUTT',  'PICBUTT',  'TIMER',  'BROWSE',  'TREE',  'IPADDRESS',  'MONTHCALENDAR', 'HYPERLINK',  'RICHEDIT',     'TIMEPICKER',  'XBROWSE',  'ACTIVEX',  'CHECKLIST',  'HOTKEYBOX',  'PICTURE',  'PROGRESSMETER',  'SCROLLBAR',  'TEXTARRAY' }
   DATA ControlCount         INIT { 0,       0,         0,           0,       0,        0,           0,       0,        0,      0,        0,          0,             0,       0,       0,        0,         0,              0,             0,         0,          0,               0,          0,        0,         0,       0,            0,               0,            0,              0,             0,          0,          0,            0,            0,          0,                0,            0 }

   METHOD AddControl
   METHOD AddCtrlToTabPage
   METHOD AddTabPage
   METHOD CheckForFrame
   METHOD Clean
   METHOD Control_Click
   METHOD CopyControl
   METHOD CreateControl
   METHOD CreateStatusBar
   METHOD CrtlIsOfType
   METHOD CtrlFontColors
   METHOD Debug
   METHOD DelArray
   METHOD DeleteControl
   METHOD DeleteTabPage
   METHOD DrawOutline                         // Dibuja
   METHOD DrawPoints                          // MisPuntos
   METHOD Edit_Properties
   METHOD EditForm           CONSTRUCTOR
   METHOD Events_Click
   METHOD Exit
   METHOD FillListOfCtrls
   METHOD FillListOfGroups
   METHOD FrmEvents
   METHOD FrmFontColors
   METHOD FrmProperties
   METHOD GlobalVertGapChg
   METHOD GOtherColors
   METHOD IniArray
   METHOD IsUnique
   METHOD KeyboardMoveSize
   METHOD KeyHandler
   METHOD LoadControls
   METHOD MakeControls
   METHOD ManualMoveSize
   METHOD MinimizeForms
   METHOD MouseMoveSize
   METHOD MouseTrack
   METHOD MoveControl
   METHOD New
   METHOD Open
   METHOD Order_Down
   METHOD Order_Up
   METHOD OrderControls
   METHOD pActiveX
   METHOD pAnimateBox
   METHOD pBrowse
   METHOD pButton
   METHOD pCheckBox
   METHOD pCheckBtn
   METHOD pCheckList
   METHOD pComboBox
   METHOD pDatePicker
   METHOD pEditBox
   METHOD pForm
   METHOD pFrame
   METHOD pGrid
   METHOD pHotKeyBox
   METHOD pHypLink
   METHOD pImage
   METHOD pIPAddress
   METHOD pLabel
   METHOD pListBox
   METHOD pMonthCal
   METHOD pPicButt
   METHOD pPicCheckButt
   METHOD pPicture
   METHOD pPlayer
   METHOD pProgressBar
   METHOD pProgressMeter
   METHOD pRadioGroup
   METHOD pRichedit
   METHOD PrintBrief
   METHOD ProcesaControl
   METHOD Properties_Click
   METHOD pScrollBar
   METHOD pSlider
   METHOD pSpinner
   METHOD pTab
   METHOD pTextArray
   METHOD pTextBox
   METHOD pTimePicker
   METHOD pTimer
   METHOD pTree
   METHOD pXBrowse
   METHOD ReadCtrlCol                         // LeaCol
   METHOD ReadCtrlRow                         // LeaRow
   METHOD ReadCtrlType                        // LeaTipo
   METHOD ReadFormCol                         // LeaColF
   METHOD ReadFormRow                         // LeaRowF
   METHOD ReadLogicalData                     // LeaDatoLogic
   METHOD ReadOopData                         // LeaDato_Oop
   METHOD ReadStringData                      // LeaDato
   METHOD RecreateControl
   METHOD RefreshControlInspector
   METHOD ReorderTabs
   METHOD RestoreForms
   METHOD Save
   METHOD SelectControl
   METHOD SetBackColor
   METHOD SetDefaultBackColor
   METHOD SetDefaultFontType
   METHOD SetFontType
   METHOD ShowFormData
   METHOD SizeControl
   METHOD Snap
   METHOD StatPropEvents
   METHOD SwapArray                           // Swapea
   METHOD TabProperties
   METHOD ValCellPos
   METHOD ValGlobalPos
   METHOD VerifyBar
ENDCLASS

//------------------------------------------------------------------------------
METHOD EditForm( myIde, cFullName, nEditorIndex, lWait ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nPos, cName

   CursorWait()

   SET INTERACTIVECLOSE OFF

   ::myIde        := myIde
   ::nEditorIndex := nEditorIndex
   ::cFFontColor  := ::myIde:cFormDefFontColor
   ::cFFontName   := ::myIde:cFormDefFontName
   ::nFFontSize   := ::myIde:nFormDefFontSize
   ::myTbEditor   := TMyToolBarEditor():New( Self )


   DEFINE WINDOW 0 OBJ ::oWaitMsg ;
      AT 10, 10 ;
      WIDTH 150 ;
      HEIGHT 100 ;
      TITLE "Information" ;
      CHILD ;
      NOSHOW ;
      NOSYSMENU ;
      NOCAPTION ;
      BACKCOLOR ::myIde:aSystemColor ;
      ON INIT ::oWaitMsg:Center()

      @ 35, 15 LABEL label_1 ;
         VALUE 'Please wait ...' ;
         AUTOSIZE ;
         FONT 'Times new Roman' ;
         SIZE 14
   END WINDOW

   DEFINE WINDOW 0 OBJ ::Form_Main ;
      AT 0,0 ;
      WIDTH 689 ;
      HEIGHT 104 ;
      TITLE 'ooHG IDE Plus - Form designer' ;
      CHILD ;
      NOSHOW ;
      NOMAXIMIZE ;
      NOSIZE ;
      ICON "Edit" ;
      FONT 'MS Sans Serif' ;
      SIZE 10 ;
      BACKCOLOR ::myIde:aSystemColor ;
      ON MINIMIZE ::MinimizeForms() ;
      ON MAXIMIZE ::RestoreForms() ;
      ON RESTORE ::RestoreForms()

      @ 17,10 BUTTON exit ;
         PICTURE 'A1';
         ACTION ::Exit() ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Exit'

      @ 17,41 BUTTON save ;
         PICTURE 'A2';
         ACTION ::Save( 0 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Save'

      @ 17,73 BUTTON save_as ;
         PICTURE 'A3';
         ACTION ::Save( 1 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Save as'

      @ 17,112 BUTTON form_prop ;
         PICTURE 'A4';
         ACTION ::FrmProperties() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Properties'

      @ 17,144 BUTTON events_prop ;
         PICTURE 'A5';
         ACTION ::FrmEvents() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Events'

      @ 17,176 BUTTON form_mc ;
         PICTURE 'A6';
         ACTION ::FrmFontColors() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Fonts and Colors'

      @ 17,209 BUTTON tbc_fmms ;
         PICTURE 'A7';
         ACTION ::ManualMoveSize( 0 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Manual Move/Size'

      @ 17,240 BUTTON mmenu1 ;
         PICTURE 'A8';
         ACTION TMyMenuEditor():Edit( Self, 1 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Main Menu'

      @ 17,273 BUTTON mmenu2 ;
         PICTURE 'A9';
         ACTION TMyMenuEditor():Edit( Self, 2 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Context Menu'

      @ 17,303 BUTTON mmenu3 ;
         PICTURE 'A10';
         ACTION TMyMenuEditor():Edit( Self, 3 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Notify Menu'

      @ 17,337 BUTTON toolb ;
         PICTURE 'A11';
         ACTION ::myTbEditor:Edit() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Toolbar'

      @ 17,368 BUTTON form_co ;
         PICTURE 'A12';
         ACTION ::OrderControls() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Order'

      @ 17,400 BUTTON  butt_status ;
         PICTURE 'A13';
         ACTION ::VerifyBar() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Statusbar On/Off'

      @ 17,444 BUTTON tbc_prop ;
         PICTURE 'A4';
         ACTION ::Properties_Click() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Properties'

      @ 17,477 BUTTON tbc_events ;
         PICTURE 'A5';
         ACTION ::Events_Click() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Events'

      @ 17,510 BUTTON tbc_ifc ;
         PICTURE 'A6';
         ACTION ::CtrlFontColors() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Font and Colors'

      @ 17,540 BUTTON tbc_mms ;
         PICTURE 'A7';
         ACTION ::ManualMoveSize( 1 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Manual Move/Size'

      @ 17,572 BUTTON tbc_im ;
         PICTURE 'A17';
         ACTION ::MoveControl() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Interactive Move'

      @ 17,604 BUTTON tbc_is ;
         PICTURE 'A14';
         ACTION ::SizeControl() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Interactive Size'

      @ 17,634 BUTTON tbc_del ;
         PICTURE 'A16';
         ACTION ::DeleteControl() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Delete'

      @ 0,105 FRAME frame_1 ;
         CAPTION "Form : " + cFullName ;
         WIDTH 332 ;
         HEIGHT 65 ;
         SIZE 9

      @ 0,436 FRAME frame_2 ;
         CAPTION "Control : " ;
         WIDTH 236 ;
         HEIGHT 65 ;
         OPAQUE ;
         SIZE 9

      @ 0,4 FRAME frame_3 ;
         CAPTION "Action" ;
         WIDTH 105 ;
         HEIGHT 65 ;
         SIZE 9

      @ 48,115 LABEL label_1 ;
         WIDTH 120 ;
         HEIGHT 24 ;
         VALUE '' ;
         SIZE 9 ;
         AUTOSIZE

      @ 48,446 LABEL label_2 ;
         WIDTH 120 ;
         HEIGHT 24 ;
         VALUE 'r:    c:    w:    h: ' ;
         SIZE 9 ;
         AUTOSIZE

      @ 48,300 LABEL labelyx ;
         WIDTH 98 ;
         HEIGHT 24 ;
         VALUE '0000,0000' ;
         SIZE 9 ;
         AUTOSIZE

   END WINDOW

   DEFINE WINDOW 0 OBJ ::cvcControls ;
      AT ::myIde:MainHeight + 46, 0 ;
      WIDTH 86 ;
      HEIGHT 377 ;
      CLIENTAREA ;
      TITLE 'Controls' ;
      ICON 'VD' ;
      CHILD ;
      NOSHOW ;
      NOSIZE ;
      NOMAXIMIZE ;
      NOAUTORELEASE ;
      NOMINIMIZE ;
      NOSYSMENU ;
      BACKCOLOR ::myIde:aSystemColor

      @ 000, 00 CHECKBUTTON Control_01 ;
         PICTURE 'SELECT' ;
         VALUE .T. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Select Object' ;
         ON CHANGE ::Control_Click( 1 )

      @ 000, 29 CHECKBUTTON Control_02 ;
         PICTURE 'BUTTON1' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Button and ButtonMixed' ;
         ON CHANGE ::Control_Click( 2 )

      @ 000, 58 CHECKBUTTON Control_03 ;
         PICTURE 'CHECKBOX1' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'CheckBox' ;
         ON CHANGE ::Control_Click( 3 )

      @ 029, 00 CHECKBUTTON Control_04 ;
         PICTURE 'LISTBOX1' ; 
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ListBox' ;
         ON CHANGE ::Control_Click( 4 )

      @ 029, 29 CHECKBUTTON Control_05 ;
         PICTURE 'COMBOBOX1' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ComboBox' ;
         ON CHANGE ::Control_Click( 5 )

      @ 029, 58 CHECKBUTTON Control_06 ;
         PICTURE 'CHECKBUTTON' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'CheckButton' ;
         ON CHANGE ::Control_Click( 6 )

      @ 058, 00 CHECKBUTTON Control_07 ;
         PICTURE 'GRID' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Grid' ;
         ON CHANGE ::Control_Click( 7 )

      @ 058, 29 CHECKBUTTON Control_08 ;
         PICTURE 'FRAME' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Frame' ;
         ON CHANGE ::Control_Click( 8 )

      @ 058, 58 CHECKBUTTON Control_09 ;
         PICTURE 'TAB' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Tab' ;
         ON CHANGE ::Control_Click( 9 )

      @ 087, 00 CHECKBUTTON Control_10 ;
         PICTURE 'IMAGE' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Image' ;
         ON CHANGE ::Control_Click( 10 )

      @ 087, 29 CHECKBUTTON Control_11 ;
         PICTURE 'ANIMATEBOX' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'AnimateBox' ;
         ON CHANGE ::Control_Click( 11 )

      @ 087, 58 CHECKBUTTON Control_12 ;
         PICTURE 'DATEPICKER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'DatePicker' ;
         ON CHANGE ::Control_Click( 12 )

      @ 116, 00 CHECKBUTTON Control_13 ;
         PICTURE 'TEXTBOX' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'TextBox' ;
         ON CHANGE ::Control_Click( 13 )

      @ 116, 29 CHECKBUTTON Control_14 ;
         PICTURE 'EDITBOX' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'EditBox' ;
         ON CHANGE ::Control_Click( 14 )

      @ 116, 58 CHECKBUTTON Control_15 ;
         PICTURE 'LABEL' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Label' ;
         ON CHANGE ::Control_Click( 15 )

      @ 145, 00 CHECKBUTTON Control_16 ;
         PICTURE 'PLAYER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Player' ;
         ON CHANGE ::Control_Click( 16 )

      @ 145, 29 CHECKBUTTON Control_17 ;
         PICTURE 'PROGRESSBAR' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ProgressBar' ;
         ON CHANGE ::Control_Click( 17 )

      @ 145, 58 CHECKBUTTON Control_18 ;
         PICTURE 'RADIOGROUP' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'RadioGroup' ;
         ON CHANGE ::Control_Click( 18 )

      @ 174, 00 CHECKBUTTON Control_19 ;
         PICTURE 'SLIDER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Slider' ;
         ON CHANGE ::Control_Click( 19 )

      @ 174, 29 CHECKBUTTON Control_20 ;
         PICTURE 'SPINNER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Spinner' ;
         ON CHANGE ::Control_Click( 20 )

      @ 174, 58 CHECKBUTTON Control_21 ;
         PICTURE 'IMAGECHECKBUTTON' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Picture CheckButton' ;
         ON CHANGE ::Control_Click( 21 )

      @ 203, 00 CHECKBUTTON Control_22 ;
         PICTURE 'IMAGEBUTTON' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Picture Button' ;
         ON CHANGE ::Control_Click( 22 )

      @ 203, 29 CHECKBUTTON Control_23 ;
         PICTURE 'TIMER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Timer' ;
         ON CHANGE ::Control_Click( 23 )

      @ 203, 58 CHECKBUTTON Control_24 ;
         PICTURE 'BROWSE' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Browse' ;
         ON CHANGE ::Control_Click( 24 )

      @ 232, 00 CHECKBUTTON Control_25 ;
         PICTURE 'TREE' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Tree' ;
         ON CHANGE ::Control_Click( 25 )

      @ 232, 29 CHECKBUTTON Control_26 ;
         PICTURE 'IPAD' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'IPAddress' ;
         ON CHANGE ::Control_Click( 26 )

      @ 232, 58 CHECKBUTTON Control_27 ;
         PICTURE 'MONTHCAL' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'MonthCalendar' ;
         ON CHANGE ::Control_Click( 27 )

      @ 261, 00 CHECKBUTTON Control_28 ;
         PICTURE 'HYPLINK' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'HyperLink' ;
         ON CHANGE ::Control_Click( 28 )

      @ 261, 29 CHECKBUTTON Control_29 ;
         PICTURE 'RICHEDIT' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'RichEditBox' ;
         ON CHANGE ::Control_Click( 29 )

      @ 261, 58 CHECKBUTTON Control_30 ;
         PICTURE 'TIMEP' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'TimePicker' ;
         ON CHANGE ::Control_Click( 30 )

      @ 290, 00 CHECKBUTTON Control_31 ;
         PICTURE 'XBROWSE' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'XBrowse' ;
         ON CHANGE ::Control_Click( 31 )

      @ 290, 29 CHECKBUTTON Control_32 ;
         PICTURE 'ACTIVEX' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ActiveX' ;
         ON CHANGE ::Control_Click( 32 )

      @ 290, 58 CHECKBUTTON Control_33 ;
         PICTURE 'CHECKLIST' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'CheckList' ;
         ON CHANGE ::Control_Click( 33 )

      @ 319, 00 CHECKBUTTON Control_34 ;
         PICTURE 'HKB' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'HotKeyBox' ;
         ON CHANGE ::Control_Click( 34 )

      @ 319, 29 CHECKBUTTON Control_35 ;
         PICTURE 'PICTURE' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Picture' ;
         ON CHANGE ::Control_Click( 35 )

      @ 319, 58 CHECKBUTTON Control_36 ;
         PICTURE 'METER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ProgressMeter' ;
         ON CHANGE ::Control_Click( 36 )

      @ 348, 00 CHECKBUTTON Control_37 ;
         PICTURE 'SCRLLBR' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ScrollBar' ;
         ON CHANGE ::Control_Click( 37 )

      @ 348, 29 CHECKBUTTON Control_38 ;
         PICTURE 'ATEXT' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'TextArray' ;
         ON CHANGE ::Control_Click( 38 )

      @ 348, 58 CHECKBUTTON Control_Stabusbar ;
         PICTURE 'STAT' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'StatusBar' ;
         ON CHANGE ::StatPropEvents() ;
         INVISIBLE

   END WINDOW

   ::Form_Main:Activate( .T. )
   ::cvcControls:Activate( .T. )
   ::oWaitMsg:Activate( .T. )

// TODO: hide ::cvcControls and ::Form_Main when Form is not focused

   ::cForm := cFullName
   nPos := RAt( '\', cFullName )
   cName := SubStr( cFullName, nPos + 1 )
   nPos := RAt( ".", cName )
   IF nPos > 0
      cName := SubStr( cName, 1, nPos - 1 )
   ENDIF
   ::cFName := Lower( cName )

   ::lSStat := .F.
   IF File( cFullName )
      ::Open( cFullName, lWait )
   ELSE
      ::New( lWait )
   ENDIF
RETURN Self

//------------------------------------------------------------------------------
METHOD Open( cFMG, lWait )  CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, j, nContLin, cForma, nStart, nEnd, nFWidth, nFHeight, cName, aColor

   ::oWaitMsg:label_1:Value := 'Loading form ...'
   ::oWaitMsg:Show()

   DEFINE WINDOW 0 OBJ ::FormList ;
      AT ::myIde:MainHeight + 46, ( GetDeskTopWidth() - 380 ) ;
      WIDTH 370 ;
      HEIGHT 490 ;
      CLIENTAREA ;
      TITLE 'Control Inspector' ;
      ICON 'Edit' ;
      CHILD ;
      NOSHOW ;
      NOMAXIMIZE ;
      NOMINIMIZE ;
      NOSIZE ;
      NOSYSMENU ;
      BACKCOLOR ::myIde:aSystemColor ;
      ON INIT SetHeightForWholeRows( ::oCtrlList, 400 )

      @ 10, 10 GRID 0 OBJ ::oCtrlList ;
         WIDTH 350 ;
         HEIGHT 400 ;
         HEADERS { 'Name', 'Row', 'Col', 'Width', 'Height', 'int-name', 'Type' } ;
         WIDTHS { 80, 40, 40, 45, 50, 0, 70 } ;
         FONT "Arial" ;
         SIZE 10 ;
         INPLACE EDIT ;
         READONLY { .T., .F., .F., .F., .F., .T., .T. } ;
         JUSTIFY { GRID_JTFY_LEFT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_LEFT, GRID_JTFY_LEFT } ;
         ON HEADCLICK { {|| ::oCtrlList:SortColumn( 1, .F. ) }, {|| ::oCtrlList:SortColumn( 2, .F. ) }, {|| ::oCtrlList:SortColumn( 3, .F. ) }, {|| ::oCtrlList:SortColumn( 4, .F. ) }, {|| ::oCtrlList:SortColumn( 5, .F. ) }, NIL, {|| ::oCtrlList:SortColumn( 7, .F. ) } } ;
         FULLMOVE ;
         MULTISELECT ;
         ON EDITCELL ::ValCellPos() ;
         ON CHANGE ::SelectControl()
      ::oCtrlList:ColumnHide( 6 )

      DEFINE CONTEXT MENU CONTROL ( ::oCtrlList:Name ) OF ( ::FormList:Name ) OBJ ::oContextMenu
         ITEM 'Properties'             ACTION { |aParams| ::Edit_Properties( aParams ) }
         ITEM 'Events    '             ACTION ::Events_Click()
         ITEM 'Font/Colors'            ACTION ::CtrlFontColors()
         ITEM 'Manual Move/Size'       ACTION ::ManualMoveSize( 1 )
         ITEM 'Interactive Move'       ACTION ::MoveControl()
         ITEM 'Keyboard Move'          ACTION ::KeyboardMoveSize()
         ITEM 'Interactive Size'       ACTION ::SizeControl()
         SEPARATOR
         ITEM 'Global Row Align'       ACTION ::ValGlobalPos( 'ROW' )
         ITEM 'Global Col Align'       ACTION ::ValGlobalPos( 'COL' )
         ITEM 'Global Width Change'    ACTION ::ValGlobalPos( 'WID' )
         ITEM 'Global Height Change'   ACTION ::ValGlobalPos( 'HEI' )
         ITEM 'Global Vert Gap Change' ACTION ::GlobalVertGapChg()
         ITEM 'Global Hor/Ver Shift'   ACTION ::ValGlobalPos( 'SHI' )
         SEPARATOR
         ITEM 'Copy'                   ACTION ::CopyControl()
         ITEM 'Delete'                 ACTION ::DeleteControl()
         SEPARATOR
         ITEM 'Print Brief'            ACTION ::PrintBrief()
         SEPARATOR
         ITEM "Form's context menu"    ACTION IIF( HB_IsObject( ::myCMCtrl ), ::myCMCtrl:Activate(), MsgInfo( "Context menu is not defined !!!", 'OOHG IDE+' ) )
         ITEM "Form' notify menu"      ACTION IIF( HB_IsObject( ::myNMCtrl ), ::myNMCtrl:Activate(), MsgInfo( "Notify menu is not defined !!!", 'OOHG IDE+' ) )
      END MENU

      @ 420, 10 LABEL lop1 VALUE "Double click or Enter to modify the position or size of a control." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 435, 10 LABEL lop2 VALUE "Right click to access properties or events, or to do global" FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 450, 10 LABEL lop3 VALUE "align/resize of selected controls (use Ctrl+Click to select)." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 465, 10 LABEL lop4 VALUE "Click on the headers to change display order." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
   END WINDOW

   // Load form
   cForma := MemoRead( cFMG )
   nContLin := MLCount( cForma )

   FOR i := 1 TO nContLin
      aAdd( ::aLine, ' ' + MemoLine( cForma, 800, i ) )
      IF ::aLine[i] # NIL
         IF At( "DEFINE WINDOW", ::aLine[i] ) # 0 .OR. ( At( "@ ", ::aLine[i] ) > 0 .AND. At( ",", ::aLine[i] ) > 0 )
            IF At( "WINDOW", ::aLine[i] ) > 0
               // Form, after WINDOW should come TEMPLATE, but everything is accepted and ignored
               cName := "TEMPLATE"
            ELSE
               // Control, skip nCol
               nStart := At( ',', ::aLine[i] ) + 1
               FOR j := nStart TO Len( ::aLine[i] )
                  // Stop at the first letter
                  IF Asc( SubStr( ::aLine[i], j, 1 ) ) >= 65
                     EXIT
                  ENDIF
               NEXT j
               // Skip control type
               nStart := j
               FOR j := nStart TO Len( ::aLine[i] )
                  // Stop at the first space
                  IF SubStr( ::aLine[i], j, 1) == " "
                     EXIT
                  ENDIF
               NEXT j
               nEnd := j
               // Get name
               cName := SubStr( ::aLine[i], nEnd + 1 )
               cName := StrTran( cName, ";", "" )
               cName := StrTran( cName, chr(10), "" )
               cName := StrTran( cName, chr(13), "" )
               cName := StrTran( cName, " ", "" )
            ENDIF
            IF aScan( ::aControlW, Lower( cName ) ) > 0
                MsgStop( 'The fmg contains two controls named "' + cName + '" (the second one will be ignored).', 'OOHG IDE+' )
                // Add "empty" control to properly set ::aNumber
                cName := ''
            ENDIF
            // Initialize control's arrays
            ::IniArray( cName, '' )
            // Store starting line
            ::aSpeed[::nControlW] := i
         ENDIF
      ELSE
         EXIT
      ENDIF
   NEXT i

   // Store ending line
   FOR i := 1 TO ( ::nControlW - 1 )
       ::aNumber[i] := ::aSpeed[i + 1] - 1
   NEXT i
   ::aNumber[::nControlW] := nContLin

   // Delete "empty" controls
   FOR i := ::nControlW TO 1 STEP -1
      IF ::aControlW[i] == ''
         ::DelArray( i )
       ENDIF
   NEXT i

   // Do not force a font when form has none, use OOHG default
   ::cFFontName   := ::Clean( ::ReadStringData( 'WINDOW', 'FONT', '' ) )
   ::nFFontSize   := Val( ::ReadStringData( 'WINDOW', 'SIZE', '0' ) )
   ::cFBackcolor  := UpperNIL( ::ReadStringData( 'WINDOW', 'BACKCOLOR', 'NIL' ) )
   nFWidth        := Val( ::ReadStringData( 'WINDOW', 'WIDTH', '640' ) )
   nFHeight       := Val( ::ReadStringData( 'WINDOW', 'HEIGHT', '480' ) )
   ::nFVirtualW   := Val( ::ReadStringData( 'WINDOW', 'VIRTUAL WIDTH', '0' ) )
   ::nFVirtualH   := Val( ::ReadStringData( 'WINDOW', 'VIRTUAL HEIGHT', '0' ) )
   ::lFClientArea := ( ::ReadLogicalData( 'WINDOW', "CLIENTAREA", "F" ) == 'T' )

   // Create canvas
   cName := _OOHG_GetNullName( "0" )
   aColor := IIF( IsValidArray( ::cFBackcolor ), &( ::cFBackcolor ), NIL )

//      ON PAINT ::ShowFormData() ;

   DEFINE WINDOW ( cName ) OBJ ::oDesignForm ;
      AT ::myIde:MainHeight + 46, 66 ;
      WIDTH nFWidth ;
      HEIGHT nFHeight ;
      TITLE 'Title' ;
      ICON 'VD' ;
      CHILD ;
      NOSHOW ;
      ON RCLICK ::AddControl() ;
      ON MOUSECLICK ::AddControl() ;
      ON DBLCLICK ::Properties_Click() ;
      ON MOUSEMOVE ::MouseTrack() ;
      ON MOUSEDRAG ::MouseMoveSize() ;
      ON GOTFOCUS ::DrawPoints() ;
      ON RESTORE ::DrawPoints() ;
      ON SIZE ::DrawPoints() ;
      BACKCOLOR aColor ;
      FONT ::cFFontName ;
      SIZE ::nFFontSize ;
      FONTCOLOR &( ::cFFontColor ) ;
      NOMAXIMIZE ;
      NOMINIMIZE ;
      ON INIT { || ::RefreshControlInspector(), ;
                   IIF( ::oCtrlList:ItemCount > 0, ::oCtrlList:Value := { 1 }, NIL ) }

      IF ::lFClientArea
         ClientAreaResize( ::oDesignForm )
      ENDIF

      DEFINE CONTEXT MENU
         ITEM 'Properties'             ACTION ::Properties_Click()
         ITEM 'Events    '             ACTION ::Events_Click()
         ITEM 'Font/Colors'            ACTION ::CtrlFontColors()
         ITEM 'Manual Move/Size'       ACTION ::ManualMoveSize( 1 )
         ITEM 'Interactive Move'       ACTION ::MoveControl()
         ITEM 'Keyboard Move'          ACTION ::KeyboardMoveSize()
         ITEM 'Interactive Size'       ACTION ::SizeControl()
         SEPARATOR
         ITEM 'Global Row Align'       ACTION ::ValGlobalPos( 'ROW' )
         ITEM 'Global Col Align'       ACTION ::ValGlobalPos( 'COL' )
         ITEM 'Global Width Change'    ACTION ::ValGlobalPos( 'WID' )
         ITEM 'Global Height Change'   ACTION ::ValGlobalPos( 'HEI' )
         ITEM 'Global Vert Gap Change' ACTION ::GlobalVertGapChg()
         ITEM 'Global Hor/Ver Shift'   ACTION ::ValGlobalPos( 'SHI' )
         SEPARATOR
         ITEM 'Copy'                   ACTION ::CopyControl()
         ITEM 'Delete'                 ACTION ::DeleteControl()
         SEPARATOR
         ITEM 'Print Brief'            ACTION ::PrintBrief()
         SEPARATOR
         ITEM "Form's context menu"    ACTION IIF( HB_IsObject( ::myCMCtrl ), ::myCMCtrl:Activate(), MsgInfo( "Context menu is not defined !!!", 'OOHG IDE+' ) )
         ITEM "Form' notify menu"      ACTION IIF( HB_IsObject( ::myNMCtrl ), ::myNMCtrl:Activate(), MsgInfo( "Notify menu is not defined !!!", 'OOHG IDE+' ) )
      END MENU

      ON KEY ALT+D  ACTION ::Debug()
      ON KEY ALT+C  ACTION ::CopyControl()
      ON KEY DELETE ACTION ::DeleteControl()
      ON KEY F1     ACTION Help_F1( 'FORMEDIT', ::myIde )
   END WINDOW

   ::LoadControls()

   ::oWaitMsg:Hide()
   CursorArrow()

   ::Form_Main:Show()
   ::cvcControls:Show()
   ::FormList:Show()
   ::oDesignForm:Show()
   ::FormList:Activate( .T. )
   ::oDesignForm:Activate( ! lWait )
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION ClientAreaResize( oForm )
//------------------------------------------------------------------------------
   WITH OBJECT oForm
      :SizePos( NIL, NIL, :Width + :nWidth - :ClientWidth, :Height + :nHeight - :ClientHeight )
   END WITH
RETURN NIL

//------------------------------------------------------------------------------
METHOD New( lWait ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName

   ::oWaitMsg:label_1:Value := 'Creating form ...'
   ::oWaitMsg:Show()

   cName := _OOHG_GetNullName( "0" )

//    ON PAINT ::ShowFormData() ;

   DEFINE WINDOW ( cName ) OBJ ::oDesignForm ;
      AT ::myIde:MainHeight + 46, 66 ;
      WIDTH 700 ;
      HEIGHT 410 ;
      ICON 'VD' ;
      CHILD ;
      NOSHOW ;
      ON RCLICK ::AddControl() ;
      ON MOUSECLICK ::AddControl() ;
      ON DBLCLICK ::Properties_Click() ;
      ON MOUSEMOVE ::MouseTrack() ;
      ON MOUSEDRAG ::MouseMoveSize() ;
      ON GOTFOCUS ::DrawPoints() ;
      ON RESTORE ::DrawPoints() ;
      FONT ::cFFontName ;
      SIZE ::nFFontSize ;
      FONTCOLOR &( ::cFFontColor ) ;
      NOMAXIMIZE ;
      NOMINIMIZE

      DEFINE CONTEXT MENU
         ITEM 'Properties'             ACTION ::Properties_Click()
         ITEM 'Events    '             ACTION ::Events_Click()
         ITEM 'Font/Colors'            ACTION ::CtrlFontColors()
         ITEM 'Manual Move/Size'       ACTION ::ManualMoveSize( 1 )
         ITEM 'Interactive Move'       ACTION ::MoveControl()
         ITEM 'Keyboard Move'          ACTION ::KeyboardMoveSize()
         ITEM 'Interactive Size'       ACTION ::SizeControl()
         SEPARATOR
         ITEM 'Global Row Align'       ACTION ::ValGlobalPos( 'ROW' )
         ITEM 'Global Col Align'       ACTION ::ValGlobalPos( 'COL' )
         ITEM 'Global Width Change'    ACTION ::ValGlobalPos( 'WID' )
         ITEM 'Global Height Change'   ACTION ::ValGlobalPos( 'HEI' )
         ITEM 'Global Vert Gap Change' ACTION ::GlobalVertGapChg()
         ITEM 'Global Hor/Ver Shift'   ACTION ::ValGlobalPos( 'SHI' )
         SEPARATOR
         ITEM 'Copy'                   ACTION ::CopyControl()
         ITEM 'Delete'                 ACTION ::DeleteControl()
         SEPARATOR
         ITEM 'Print Brief'            ACTION ::PrintBrief()
         SEPARATOR
         ITEM "Form's context menu"    ACTION IIF( HB_IsObject( ::myCMCtrl ), ::myCMCtrl:Activate(), MsgInfo( "Context menu is not defined !!!", 'OOHG IDE+' ) )
         ITEM "Form' notify menu"      ACTION IIF( HB_IsObject( ::myNMCtrl ), ::myNMCtrl:Activate(), MsgInfo( "Notify menu is not defined !!!", 'OOHG IDE+' ) )
      END MENU

      ON KEY ALT+C  ACTION ::CopyControl()
      ON KEY DELETE ACTION ::DeleteControl()
      ON KEY F1     ACTION Help_F1( 'FORMEDIT', ::myIde )
      ON KEY ALT+D  ACTION ::Debug()
   END WINDOW

   DEFINE WINDOW 0 OBJ ::FormList ;
      AT ::myIde:MainHeight + 46, ( GetDeskTopWidth() - 380 ) ;
      WIDTH 370 ;
      HEIGHT 490 ;
      CLIENTAREA ;
      TITLE 'Control Inspector' ;
      ICON 'Edit' ;
      CHILD ;
      NOSHOW ;
      NOMAXIMIZE ;
      NOMINIMIZE ;
      NOSIZE ;
      NOSYSMENU ;
      BACKCOLOR ::myIde:aSystemColor ;
      ON INIT SetHeightForWholeRows( ::oCtrlList, 400 )

      @ 10, 10 GRID 0 OBJ ::oCtrlList ;
         WIDTH 350 ;
         HEIGHT 400 ;
         HEADERS { 'Name', 'Row', 'Col', 'Width', 'Height', 'int-name', 'Type' } ;
         WIDTHS { 80, 40, 40, 45, 50, 0, 70 } ;
         FONT "Arial" ;
         SIZE 10 ;
         INPLACE EDIT ;
         READONLY { .T., .F., .F., .F., .F., .T., .T. } ;
         JUSTIFY { GRID_JTFY_LEFT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_LEFT, GRID_JTFY_LEFT } ;
         ON HEADCLICK { {|| ::oCtrlList:SortColumn( 1, .F. ) }, {|| ::oCtrlList:SortColumn( 2, .F. ) }, {|| ::oCtrlList:SortColumn( 3, .F. ) }, {|| ::oCtrlList:SortColumn( 4, .F. ) }, {|| ::oCtrlList:SortColumn( 5, .F. ) }, NIL, {|| ::oCtrlList:SortColumn( 7, .F. ) } } ;
         FULLMOVE ;
         MULTISELECT ;
         ON EDITCELL ::ValCellPos() ;
         ON CHANGE ::SelectControl()
      ::oCtrlList:ColumnHide( 6 )

      DEFINE CONTEXT MENU CONTROL ( ::oCtrlList:Name ) OF ( ::FormList:Name ) OBJ ::oContextMenu
         ITEM 'Properties'             ACTION { |aParams| ::Edit_Properties( aParams ) }
         ITEM 'Events    '             ACTION ::Events_Click()
         ITEM 'Font/Colors'            ACTION ::CtrlFontColors()
         ITEM 'Manual Move/Size'       ACTION ::ManualMoveSize( 1 )
         ITEM 'Interactive Move'       ACTION ::MoveControl()
         ITEM 'Keyboard Move'          ACTION ::KeyboardMoveSize()
         ITEM 'Interactive Size'       ACTION ::SizeControl()
         SEPARATOR
         ITEM 'Global Row Align'       ACTION ::ValGlobalPos( 'ROW' )
         ITEM 'Global Col Align'       ACTION ::ValGlobalPos( 'COL' )
         ITEM 'Global Width Change'    ACTION ::ValGlobalPos( 'WID' )
         ITEM 'Global Height Change'   ACTION ::ValGlobalPos( 'HEI' )
         ITEM 'Global Vert Gap Change' ACTION ::GlobalVertGapChg()
         ITEM 'Global Hor/Ver Shift'   ACTION ::ValGlobalPos( 'SHI' )
         SEPARATOR
         ITEM 'Copy'                   ACTION ::CopyControl()
         ITEM 'Delete'                 ACTION ::DeleteControl()
         SEPARATOR
         ITEM 'Print Brief'            ACTION ::PrintBrief()
         SEPARATOR
         ITEM "Form's context menu"    ACTION IIF( HB_IsObject( ::myCMCtrl ), ::myCMCtrl:Activate(), MsgInfo( "Context menu is not defined !!!", 'OOHG IDE+' ) )
         ITEM "Form' notify menu"      ACTION IIF( HB_IsObject( ::myNMCtrl ), ::myNMCtrl:Activate(), MsgInfo( "Notify menu is not defined !!!", 'OOHG IDE+' ) )
      END MENU
      END MENU

      @ 420, 10 LABEL lop1 VALUE "Double click or Enter to modify the position or size of a control." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 435, 10 LABEL lop2 VALUE "Right click to access properties or events, or to do global" FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 450, 10 LABEL lop3 VALUE "align/resize of selected controls (use Ctrl+Click to select)." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 465, 10 LABEL lop4 VALUE "Click on the headers to change display order." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
   END WINDOW

   // Add first element
   ::IniArray( "TEMPLATE", 'FORM' )

   ::oWaitMsg:Hide()
   CursorArrow()

   ::Form_Main:Show()
   ::cvcControls:Show()
   ::FormList:Show()
   ::oDesignForm:Show()
   ::FormList:Activate( .T. )
   ::oDesignForm:Activate( ! lWait )
RETURN NIL

//------------------------------------------------------------------------------
METHOD Exit() CLASS TFormEditor
//------------------------------------------------------------------------------
   IF ! ::lFsave
      IF MsgYesNo( 'Form not saved, save it now?', 'ooHG IDE+' )
         ::Save( 0 )
      ENDIF
   ENDIF
   // TODO: save windows' positions and restore next time they're opened
   ::Form_Main:Release()
   ::cvcControls:Release()
   ::FormList:Release()
   ::oDesignForm:Release()
   _OOHG_DeleteArrayItem( ::myIde:aEditors, ::nEditorIndex )
   ::myIde:EditorExit()
RETURN NIL

//------------------------------------------------------------------------------
METHOD MinimizeForms() CLASS TFormEditor
//------------------------------------------------------------------------------
   ::Form_Main:Minimize()
   ::cvcControls:Minimize()
   ::FormList:Minimize()
RETURN NIL

//------------------------------------------------------------------------------
METHOD RestoreForms() CLASS TFormEditor
//------------------------------------------------------------------------------
   ::Form_Main:Restore()
   ::cvcControls:Restore()
   ::FormList:Restore()
RETURN NIL

//------------------------------------------------------------------------------
METHOD OrderControls() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName

   cName := _OOHG_GetNullName( "0" )
   SET INTERACTIVECLOSE ON
   LOAD WINDOW orderf AS ( cName )
   ::FormCtrlOrder := GetFormObject( cName )
   ON KEY ESCAPE OF ( ::FormCtrlOrder:Name ) ACTION ::FormCtrlOrder:Release()
   CENTER WINDOW ( cName )
   ACTIVATE WINDOW ( cName )
   SET INTERACTIVECLOSE OFF
   ::DrawPoints()
   ::RefreshControlInspector()
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD FillListOfGroups() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i

   ::FormCtrlOrder:List_Groups:DeleteAllItems()
   ::FormCtrlOrder:List_Groups:Additem( 'Form ' )
   FOR i := 2 TO ::nControlW
      IF ::aCtrlType[i] == 'TAB'
         ::FormCtrlOrder:List_Groups:AddItem( ::aControlW[i] )
      ENDIF
   NEXT i
   ::FormCtrlOrder:List_Groups:Value := 1
   ::FillListOfCtrls()
RETURN NIL

//------------------------------------------------------------------------------
METHOD FillListOfCtrls() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, CurrentPage, j, aCaptions, i

   CursorWait()
   ::FormCtrlOrder:List_Ctrls:DeleteAllitems()
   IF ::FormCtrlOrder:List_Groups:Value == 1
      // Form
      FOR i := 2 TO ::nControlW
         IF ! Empty( ::aControlW[i] ) .AND. ::aTabPage[i, 2] == 0
            IF ! ::aControlW[i] $ 'statusbar mainmenu contextmenu notifymenu'
               IF ! ::FormCtrlOrder:CheckBtn_Filter:Value .OR. ! ::aCtrlType[i] $ "LABEL FRAME TIMER IMAGE PICTURE ACTIVEX PROGRESSBAR PROGRESSMETER ANIMATE"
                  ::FormCtrlOrder:List_Ctrls:AddItem( ::aName[i] )
               ENDIF
            ENDIF
         ENDIF
      NEXT i
      ::FormCtrlOrder:List_Ctrls:Value := 1
   ELSE
      // Other containers
      cName := ::FormCtrlOrder:List_Groups:Item( ::FormCtrlOrder:List_Groups:Value )
      CurrentPage := 1
      j := aScan( ::aControlW, cName )
      aCaptions := &( ::aCaption[j] )
      ::FormCtrlOrder:List_Ctrls:AddItem( 'page ' + aCaptions[CurrentPage] )
      FOR i := 2 TO ::nControlW
         IF ::aTabPage[i, 1] == cName
            IF ::aTabPage[i, 2] > CurrentPage
               DO WHILE CurrentPage < ::aTabPage[i, 2]
                 CurrentPage ++
                 ::FormCtrlOrder:List_Ctrls:AddItem( 'page ' + aCaptions[CurrentPage] )
               ENDDO
            ENDIF
            IF ! ::FormCtrlOrder:CheckBtn_Filter:Value .OR. ! ::aCtrlType[i] $ "LABEL FRAME TIMER IMAGE PICTURE ACTIVEX PROGRESSBAR PROGRESSMETER ANIMATE"
               ::FormCtrlOrder:List_Ctrls:AddItem( '      ' + ::aName[i] )
            ENDIF
         ENDIF
      NEXT i
      DO WHILE CurrentPage < Len( aCaptions )
        CurrentPage ++
        ::FormCtrlOrder:List_Ctrls:AddItem( 'page ' + aCaptions[CurrentPage] )
      ENDDO
      ::FormCtrlOrder:List_Ctrls:Value := 2
   ENDIF
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Order_Up() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL t, iabajo, iarriba, cControl1, cControl2, iPosicion1, iPosicion2

   iabajo := ::FormCtrlOrder:List_Ctrls:Value
   IF iabajo == 1 .OR. iabajo == 0
      RETURN NIL
   ENDIF
   IF SubStr( ::FormCtrlOrder:List_Ctrls:Item( iabajo ), 1, 4 )== 'page'
      RETURN NIL
   ENDIF
   iarriba    := iabajo - 1
   cControl1  := AllTrim( ::FormCtrlOrder:List_Ctrls:Item( iabajo ) )
   cControl2  := AllTrim( ::FormCtrlOrder:List_Ctrls:Item( iarriba ) )
   iPosicion1 := aScan( ::aName, cControl1 )          
   iPosicion2 := aScan( ::aName, cControl2 )
   IF SubStr( ::FormCtrlOrder:List_Ctrls:Item( iarriba ), 1, 1) # ' ' .AND. ::aTabPage[iposicion1, 2] # 0
      RETURN NIL
   ENDIF
   CursorWait()
   ::SwapArray( iPosicion1, iPosicion2 )
   t := ::FormCtrlOrder:List_Ctrls:Item( iabajo )
   ::FormCtrlOrder:List_Ctrls:Item( iabajo, ::FormCtrlOrder:List_Ctrls:Item( iarriba ) )
   ::FormCtrlOrder:List_Ctrls:Item( iarriba, t )
   ::FormCtrlOrder:List_Ctrls:Value := iarriba
   ::lFSave := .F.
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Order_Down() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL t, iDown, iUp, cControl1, cControl2, iPos1, iPos2

   iUp := ::FormCtrlOrder:List_Ctrls:Value
   IF iUp == ::FormCtrlOrder:List_Ctrls:ItemCount() .OR. iUp == 0
      RETURN NIL
   ENDIF
   IF SubStr( ::FormCtrlOrder:List_Ctrls:Item( iUp ), 1, 4) == 'page'
      RETURN NIL
   ENDIF
   iDown     := iUp + 1
   cControl1 := AllTrim( ::FormCtrlOrder:List_Ctrls:Item( iUp ) )
   cControl2 := AllTrim( ::FormCtrlOrder:List_Ctrls:Item( iDown ) )
   iPos1     := aScan( ::aName, cControl1 )
   iPos2     := aScan( ::aName, cControl2 )
   IF SubStr( ::FormCtrlOrder:List_Ctrls:Item( iDown ), 1, 1 ) # ' ' .AND. ::aTabPage[iPos1, 2] # 0
      RETURN NIL
   ENDIF
   CursorWait()
   ::SwapArray( iPos1, iPos2 )
   t := ::FormCtrlOrder:List_Ctrls:Item( iUp )
   ::FormCtrlOrder:List_Ctrls:Item( iUp, ::FormCtrlOrder:List_Ctrls:Item( iDown ) )
   ::FormCtrlOrder:List_Ctrls:Item( iDown, t )
   ::FormCtrlOrder:List_Ctrls:Value := iDown
   ::lFSave := .F.
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD SwapArray( x1, x2 ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL t83, t84

   my_aSwap( ::a3State, x1, x2 )
   my_aSwap( ::aAction, x1, x2 )
   my_aSwap( ::aAction2, x1, x2 )
   my_aSwap( ::aAddress, x1, x2 )
   my_aSwap( ::aAfterColMove, x1, x2 )
   my_aSwap( ::aAfterColSize, x1, x2 )
   my_aSwap( ::aAppend, x1, x2 )
   my_aSwap( ::aAutoPlay, x1, x2 )
   my_aSwap( ::aBackColor, x1, x2 )
   my_aSwap( ::aBackground, x1, x2 )
   my_aSwap( ::aBeforeAutoFit, x1, x2 )
   my_aSwap( ::aBeforeColMove, x1, x2 )
   my_aSwap( ::aBeforeColSize, x1, x2 )
   my_aSwap( ::aBold, x1, x2 )
   my_aSwap( ::aBorder, x1, x2 )
   my_aSwap( ::aBoth, x1, x2 )
   my_aSwap( ::aBreak, x1, x2 )
   my_aSwap( ::aBuffer, x1, x2 )
   my_aSwap( ::aButtons, x1, x2 )
   my_aSwap( ::aButtonWidth, x1, x2 )
   my_aSwap( ::aByCell, x1, x2 )
   my_aSwap( ::aCancel, x1, x2 )
   my_aSwap( ::aCaption, x1, x2 )
   my_aSwap( ::aCenter, x1, x2 )
   my_aSwap( ::aCenterAlign, x1, x2 )
   my_aSwap( ::aCheckBoxes, x1, x2 )
   my_aSwap( ::aClientEdge, x1, x2 )
   my_aSwap( ::aCObj, x1, x2 )
   my_aSwap( ::aColumnControls, x1, x2 )
   my_aSwap( ::aColumnInfo, x1, x2 )
   my_aSwap( ::aControlW, x1, x2 )
   my_aSwap( ::aCtrlType, x1, x2 )
   my_aSwap( ::aDate, x1, x2 )
   my_aSwap( ::aDefaultYear, x1, x2 )
   my_aSwap( ::aDelayedLoad, x1, x2 )
   my_aSwap( ::aDelete, x1, x2 )
   my_aSwap( ::aDeleteMsg, x1, x2 )
   my_aSwap( ::aDeleteWhen, x1, x2 )
   my_aSwap( ::aDescend, x1, x2 )
   my_aSwap( ::aDIBSection, x1, x2 )
   my_aSwap( ::aDisplayEdit, x1, x2 )
   my_aSwap( ::aDoubleBuffer, x1, x2 )
   my_aSwap( ::aDrag, x1, x2 )
   my_aSwap( ::aDrop, x1, x2 )
   my_aSwap( ::aDynamicBackColor, x1, x2 )
   my_aSwap( ::aDynamicCtrls, x1, x2 )
   my_aSwap( ::aDynamicForeColor, x1, x2 )
   my_aSwap( ::aDynBlocks, x1, x2 )
   my_aSwap( ::aEdit, x1, x2 )
   my_aSwap( ::aEditKeys, x1, x2 )
   my_aSwap( ::aEditLabels, x1, x2 )
   my_aSwap( ::aEnabled, x1, x2 )
   my_aSwap( ::aExclude, x1, x2 )
   my_aSwap( ::aExtDblClick, x1, x2 )
   my_aSwap( ::aField, x1, x2 )
   my_aSwap( ::aFields, x1, x2 )
   my_aSwap( ::aFile, x1, x2 )
   my_aSwap( ::aFileType, x1, x2 )
   my_aSwap( ::aFirstItem, x1, x2 )
   my_aSwap( ::aFit, x1, x2 )
   my_aSwap( ::aFixBlocks, x1, x2 )
   my_aSwap( ::aFixedCols, x1, x2 )
   my_aSwap( ::aFixedCtrls, x1, x2 )
   my_aSwap( ::aFixedWidths, x1, x2 )
   my_aSwap( ::aFlat, x1, x2 )
   my_aSwap( ::aFocusedPos, x1, x2 )
   my_aSwap( ::aFocusRect, x1, x2 )
   my_aSwap( ::aFontColor, x1, x2 )
   my_aSwap( ::aFontItalic, x1, x2 )
   my_aSwap( ::aFontName, x1, x2 )
   my_aSwap( ::aFontSize, x1, x2 )
   my_aSwap( ::aFontStrikeout, x1, x2 )
   my_aSwap( ::aFontUnderline, x1, x2 )
   my_aSwap( ::aForceRefresh, x1, x2 )
   my_aSwap( ::aForceScale, x1, x2 )
   my_aSwap( ::aFull, x1, x2 )
   my_aSwap( ::aGripperText, x1, x2 )
   my_aSwap( ::aHandCursor, x1, x2 )
   my_aSwap( ::aHBitmap, x1, x2 )
   my_aSwap( ::aHeaderImages, x1, x2 )
   my_aSwap( ::aHeaders, x1, x2 )
   my_aSwap( ::aHelpID, x1, x2 )
   my_aSwap( ::aHotTrack, x1, x2 )
   my_aSwap( ::aImage, x1, x2 )
   my_aSwap( ::aImageMargin, x1, x2 )
   my_aSwap( ::aImagesAlign, x1, x2 )
   my_aSwap( ::aImageSize, x1, x2 )
   my_aSwap( ::aImageSource, x1, x2 )
   my_aSwap( ::aIncrement, x1, x2 )
   my_aSwap( ::aIncremental, x1, x2 )
   my_aSwap( ::aIndent, x1, x2 )
   my_aSwap( ::aInPlace, x1, x2 )
   my_aSwap( ::aInputMask, x1, x2 )
   my_aSwap( ::aInsertType, x1, x2 )
   my_aSwap( ::aIntegralHeight, x1, x2 )
   my_aSwap( ::aInvisible, x1, x2 )
   my_aSwap( ::aItemCount, x1, x2 )
   my_aSwap( ::aItemIDs, x1, x2 )
   my_aSwap( ::aItemImageNumber, x1, x2 )
   my_aSwap( ::aItemImages, x1, x2 )
   my_aSwap( ::aItems, x1, x2 )
   my_aSwap( ::aItemSource, x1, x2 )
   my_aSwap( ::aJustify, x1, x2 )
   my_aSwap( ::aLeft, x1, x2 )
   my_aSwap( ::aLikeExcel, x1, x2 )
   my_aSwap( ::aListWidth, x1, x2 )
   my_aSwap( ::aLock, x1, x2 )
   my_aSwap( ::aLowerCase, x1, x2 )
   my_aSwap( ::aMarquee, x1, x2 )
   my_aSwap( ::aMaxLength, x1, x2 )
   my_aSwap( ::aMultiLine, x1, x2 )
   my_aSwap( ::aMultiSelect, x1, x2 )
   my_aSwap( ::aName, x1, x2 )
   my_aSwap( ::aNo3DColors, x1, x2 )
   my_aSwap( ::aNoAutoSizeMovie, x1, x2 )
   my_aSwap( ::aNoAutoSizeWindow, x1, x2 )
   my_aSwap( ::aNoClickOnCheck, x1, x2 )
   my_aSwap( ::aNodeImages, x1, x2 )
   my_aSwap( ::aNoDelMsg, x1, x2 )
   my_aSwap( ::aNoErrorDlg, x1, x2 )
   my_aSwap( ::aNoFocusRect, x1, x2 )
   my_aSwap( ::aNoHeaders, x1, x2 )
   my_aSwap( ::aNoHideSel, x1, x2 )
   my_aSwap( ::aNoHScroll, x1, x2 )
   my_aSwap( ::aNoLines, x1, x2 )
   my_aSwap( ::aNoLoadTrans, x1, x2 )
   my_aSwap( ::aNoMenu, x1, x2 )
   my_aSwap( ::aNoModalEdit, x1, x2 )
   my_aSwap( ::aNoOpen, x1, x2 )
   my_aSwap( ::aNoPlayBar, x1, x2 )
   my_aSwap( ::aNoPrefix, x1, x2 )
   my_aSwap( ::aNoRClickOnCheck, x1, x2 )
   my_aSwap( ::aNoRefresh, x1, x2 )
   my_aSwap( ::aNoRootButton, x1, x2 )
   my_aSwap( ::aNoTabStop, x1, x2 )
   my_aSwap( ::aNoTicks, x1, x2 )
   my_aSwap( ::aNoToday, x1, x2 )
   my_aSwap( ::aNoTodayCircle, x1, x2 )
   my_aSwap( ::aNoVScroll, x1, x2 )
   my_aSwap( ::aNumber, x1, x2 )
   my_aSwap( ::aNumeric, x1, x2 )
   my_aSwap( ::aOnAbortEdit, x1, x2 )
   my_aSwap( ::aOnAppend, x1, x2 )
   my_aSwap( ::aOnChange, x1, x2 )
   my_aSwap( ::aOnCheckChg, x1, x2 )
   my_aSwap( ::aOnDblClick, x1, x2 )
   my_aSwap( ::aOnDelete, x1, x2 )
   my_aSwap( ::aOnDisplayChange, x1, x2 )
   my_aSwap( ::aOnDrop, x1, x2 )
   my_aSwap( ::aOnEditCell, x1, x2 )
   my_aSwap( ::aOnEnter, x1, x2 )
   my_aSwap( ::aOnGotFocus, x1, x2 )
   my_aSwap( ::aOnHeadClick, x1, x2 )
   my_aSwap( ::aOnHeadRClick, x1, x2 )
   my_aSwap( ::aOnHScroll, x1, x2 )
   my_aSwap( ::aOnLabelEdit, x1, x2 )
   my_aSwap( ::aOnListClose, x1, x2 )
   my_aSwap( ::aOnListDisplay, x1, x2 )
   my_aSwap( ::aOnLostFocus, x1, x2 )
   my_aSwap( ::aOnMouseMove, x1, x2 )
   my_aSwap( ::aOnQueryData, x1, x2 )
   my_aSwap( ::aOnRefresh, x1, x2 )
   my_aSwap( ::aOnSelChange, x1, x2 )
   my_aSwap( ::aOnTextFilled, x1, x2 )
   my_aSwap( ::aOnVScroll, x1, x2 )
   my_aSwap( ::aOpaque, x1, x2 )
   my_aSwap( ::aPageNames, x1, x2 )
   my_aSwap( ::aPageObjs, x1, x2 )
   my_aSwap( ::aPageSubClasses, x1, x2 )
   my_aSwap( ::aPassWord, x1, x2 )
   my_aSwap( ::aPicture, x1, x2 )
   my_aSwap( ::aPlainText, x1, x2 )
   my_aSwap( ::aPLM, x1, x2 )
   my_aSwap( ::aRange, x1, x2 )
   my_aSwap( ::aReadOnly, x1, x2 )
   my_aSwap( ::aReadOnlyB, x1, x2 )
   my_aSwap( ::aRecCount, x1, x2 )
   my_aSwap( ::aRefresh, x1, x2 )
   my_aSwap( ::aReplaceField, x1, x2 )
   my_aSwap( ::aRightAlign, x1, x2 )
   my_aSwap( ::aRTL, x1, x2 )
   my_aSwap( ::aSearchLapse, x1, x2 )
   my_aSwap( ::aSelBold, x1, x2 )
   my_aSwap( ::aSelColor, x1, x2 )
   my_aSwap( ::aShowAll, x1, x2 )
   my_aSwap( ::aShowMode, x1, x2 )
   my_aSwap( ::aShowName, x1, x2 )
   my_aSwap( ::aShowNone, x1, x2 )
   my_aSwap( ::aShowPosition, x1, x2 )
   my_aSwap( ::aSingleBuffer, x1, x2 )
   my_aSwap( ::aSingleExpand, x1, x2 )
   my_aSwap( ::aSmooth, x1, x2 )
   my_aSwap( ::aSort, x1, x2 )
   my_aSwap( ::aSourceOrder, x1, x2 )
   my_aSwap( ::aSpacing, x1, x2 )
   my_aSwap( ::aSpeed, x1, x2 )
   my_aSwap( ::aStretch, x1, x2 )
   my_aSwap( ::aSubClass, x1, x2 )
   my_aSwap( ::aSync, x1, x2 )
   my_aSwap( ::aTarget, x1, x2 )
   my_aSwap( ::aTextHeight, x1, x2 )
   my_aSwap( ::aThemed, x1, x2 )
   my_aSwap( ::aToolTip, x1, x2 )
   my_aSwap( ::aTop, x1, x2 )
   my_aSwap( ::aTransparent, x1, x2 )
   my_aSwap( ::aUnSync, x1, x2 )
   my_aSwap( ::aUpdate, x1, x2 )
   my_aSwap( ::aUpdateColors, x1, x2 )
   my_aSwap( ::aUpDown, x1, x2 )
   my_aSwap( ::aUpperCase, x1, x2 )
   my_aSwap( ::aValid, x1, x2 )
   my_aSwap( ::aValidMess, x1, x2 )
   my_aSwap( ::aValue, x1, x2 )
   my_aSwap( ::aValueL, x1, x2 )
   my_aSwap( ::aValueN, x1, x2 )
   my_aSwap( ::aValueSource, x1, x2 )
   my_aSwap( ::aVertical, x1, x2 )
   my_aSwap( ::aVirtual, x1, x2 )
   my_aSwap( ::aVisible, x1, x2 )
   my_aSwap( ::aWeekNumbers, x1, x2 )
   my_aSwap( ::aWhen, x1, x2 )
   my_aSwap( ::aWhiteBack, x1, x2 )
   my_aSwap( ::aWidths, x1, x2 )
   my_aSwap( ::aWorkArea, x1, x2 )
   my_aSwap( ::aWrap, x1, x2 )

   t83               := ::aTabPage[x1, 1]  // Name of the TAB where the control resides.
   t84               := ::aTabPage[x1, 2]  // Page number where the control resides.
   ::aTabPage[x1, 1] := ::aTabPage[x2, 1]
   ::aTabPage[x1, 2] := ::aTabPage[x2, 2]
   ::aTabPage[x2, 1] := t83
   ::aTabPage[x2, 2] := t84
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION my_aSwap( arreglo, x1, x2 )
//------------------------------------------------------------------------------
LOCAL t
   t           := arreglo[x1]
   arreglo[x1] := arreglo[x2]
   arreglo[x2] := t
RETURN NIL

//------------------------------------------------------------------------------
METHOD FrmFontColors() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, si := 0, FormFontColor

   cName := _OOHG_GetNullName( "0" )
   SET INTERACTIVECLOSE ON
   LOAD WINDOW fontclrs AS ( cName )
   FormFontColor := GetFormObject( cName )
   FormFontColor:label_1:Value := 'Form: ' + ::cFName
   ACTIVATE WINDOW ( cName )
   SET INTERACTIVECLOSE OFF
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD CtrlFontColors() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ia, si, cName, FormFontColor

   ia := ::nHandleA
   IF ia > 0
      IF ::CrtlIsOfType( ia, 'TIMER PLAYER ANIMATE ACTIVEX SCROLLBAR' )
         RETURN NIL
      ENDIF

      si := aScan( ::aControlW, Lower( ::oDesignForm:aControls[ia]:Name ) )
      IF si > 0
         cName := _OOHG_GetNullName( "0" )
         SET INTERACTIVECLOSE ON
         LOAD WINDOW fontclrs AS ( cName )
         FormFontColor := GetFormObject( cName )
         FormFontColor:label_1:Value := 'Control: ' + ::aName[si]
         IF ::aCtrlType[si] $ 'PROGRESSBAR PROGRESSMETER'
            FormFontColor:label_2:Visible := .T.
         ELSEIF ::aCtrlType[si] $ 'IMAGE PICTURE PICCHECKBUTT PICBUTT SLIDER'
            FormFontColor:button_101:Visible := .F.
         ELSEIF ::aCtrlType[si] == 'MONTHCALENDAR'
            FormFontColor:button_103:Visible := .T.
            FormFontColor:button_104:Visible := .T.
            FormFontColor:button_105:Visible := .T.
            FormFontColor:button_106:Visible := .T.
         ELSEIF ::aCtrlType[si] $ 'DATEPICKER TIMEPICKER'
            FormFontColor:button_102:Visible := .F.
            FormFontColor:button_107:Visible := .F.
         ENDIF
         ACTIVATE WINDOW ( cName )
         SET INTERACTIVECLOSE OFF
         ::oDesignForm:SetFocus()
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SetDefaultFontType( si ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName

   IF si == 0
      ::cFFontName  := ::myIde:cFormDefFontName
      ::nFFontSize  := ::myIde:nFormDefFontSize
      ::cFFontColor := ::myIde:cFormDefFontColor

      ::oDesignForm:cFontName := ::cFFontName
      ::oDesignForm:nFontSize := ::nFFontSize
      ::oDesignForm:FontColor := &( ::cFFontColor )
   ELSEIF si == -1
      cName := 'statusbar'

      ::cSFontName  := ''
      ::nSFontSize  := 0
      ::lSBold      := .F.
      ::lSItalic    := .F.
      ::lSUnderline := .F.
      ::lSStrikeout := .F.

      ::oDesignForm:&cName:FontName      := ''
      ::oDesignForm:&cName:FontSize      := 0
      ::oDesignForm:&cName:FontBold      := .F.
      ::oDesignForm:&cName:FontItalic    := .F.
      ::oDesignForm:&cName:FontUnderline := .F.
      ::oDesignForm:&cName:FontStrikeout := .F.
   ELSE
      cName := ::aControlW[si]

      ::aFontName[si]      := ''
      ::aFontSize[si]      := 0
      ::aFontColor[si]     := 'NIL'
      ::aBold[si]          := .F.
      ::aFontItalic[si]    := .F.
      ::aFontUnderline[si] := .F.
      ::aFontStrikeout[si] := .F.

      ::oDesignForm:&cName:Hide()
      ::oDesignForm:&cName:FontName      := ''
      ::oDesignForm:&cName:FontSize      := 0
      ::oDesignForm:&cName:FontColor     := NIL
      ::oDesignForm:&cName:FontBold      := .F.
      ::oDesignForm:&cName:FontItalic    := .F.
      ::oDesignForm:&cName:FontUnderline := .F.
      ::oDesignForm:&cName:FontStrikeout := .F.
      ::oDesignForm:&cName:Show()
   ENDIF
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD SetFontType( si )  CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, aFont, nRed, nGreen, nBlue, cColor, nFontColor, oCtrl

   IF si == 0
      aFont := GetFont( ::cFFontName, ::nFFontSize, .F. , .F. , { 0, 0, 0 } , .F., .F., 0 )
      IF aFont[1] == "" .AND. aFont[2] == 0 .AND. ( ! aFont[3] ) .AND.  ( ! aFont[4] ) .AND. ;
         aFont[5, 1] == NIL .AND. aFont[5,2] == NIL .AND.  aFont[5, 3] == NIL .AND. ;
         ( ! aFont[6] ) .AND. ( ! aFont[7]) .AND. aFont[8] == 0
         RETURN NIL
      ENDIF

      IF ! Empty( aFont[1] )
         ::cFFontName := aFont[1]
         ::oDesignForm:cFontName := aFont[1]
      ENDIF
      IF aFont[2] > 0
         ::nFFontSize := aFont[2]
         ::oDesignForm:nFontSize := aFont[2]
      ENDIF
      nRed := aFont[5,1]
      nGreen := aFont[5,2]
      nBlue := aFont[5,3]
      IF nRed <> NIL .AND. nGreen <> NIL .AND. nBlue <> NIL
         cColor := '{ ' + LTrim( Str( nRed ) ) + ', ' + ;
                          LTrim( Str( nGreen ) ) + ', ' + ;
                          LTrim( Str( nBlue ) ) + ' }'
         ::cFFontColor := cColor
         ::oDesignForm:FontColor := &cColor
      ENDIF
   ELSEIF si == -1
      // Statusbar colors
      aFont := GetFont( ::cSFontName, ::nSFontSize, ::lSBold, ::lSItalic, { 0, 0, 0 }, ::lSUnderline, ::lSStrikeout, 0 )
      IF aFont[1] == "" .AND. aFont[2] == 0 .AND. ( ! aFont[3] ) .AND.  ( ! aFont[4] ) .AND. ;
         aFont[5, 1] == NIL .AND. aFont[5,2] == NIL .AND.  aFont[5, 3] == NIL .AND. ;
         ( ! aFont[6] ) .AND. ( ! aFont[7]) .AND. aFont[8] == 0
         RETURN NIL
      ENDIF

      cName := 'statusbar'
      oCtrl := ::oDesignForm:&cName:Object()

      IF ! Empty( aFont[1] )
         ::cSFontName := aFont[1]
         oCtrl:FontName := aFont[1]
      ENDIF
      IF aFont[2] > 0
         ::nSFontSize := aFont[2]
         oCtrl:FontSize := aFont[2]
      ENDIF
      IF ::lSBold <> aFont[3]
         ::lSBold := aFont[3]
         oCtrl:FontBold := aFont[3]
      ENDIF
      IF ::lSItalic <> aFont[4]
         ::lSItalic := aFont[4]
         oCtrl:FontItalic := aFont[4]
      ENDIF
      IF ::lSUnderline <> aFont[6]
         ::lSUnderline := aFont[6]
         oCtrl:FontUnderline := aFont[6]
      ENDIF
      IF ::lSStrikeout <> aFont[7]
         ::lSStrikeout := aFont[7]
         oCtrl:FontStrikeout := aFont[7]
      ENDIF
   ELSE
      nFontColor := ::aFontColor[si]
      aFont := GetFont( ::aFontName[si], ::aFontSize[si], ::aBold[si], ::aFontItalic[si], &nFontColor, ::aFontUnderline[si], ::aFontStrikeout[si], 0 )
      IF aFont[1] == "" .AND. aFont[2] == 0 .AND. ( ! aFont[3] ) .AND.  ( ! aFont[4] ) .AND. ;
         aFont[5, 1] == NIL .AND. aFont[5,2] == NIL .AND.  aFont[5, 3] == NIL .AND. ;
         ( ! aFont[6] ) .AND. ( ! aFont[7]) .AND. aFont[8] == 0
         RETURN NIL
      ENDIF

      cName := ::aControlW[si]
      oCtrl := ::oDesignForm:&cName:Object()

      IF ! Empty( aFont[1] )
         ::aFontName[si] := aFont[1]
         oCtrl:FontName := aFont[1]
      ENDIF
      IF aFont[2] > 0
         ::aFontSize[si] := aFont[2]
         oCtrl:FontSize := aFont[2]
      ENDIF
      IF ::aBold[si] <> aFont[3]
         ::aBold[si] := aFont[3]
         oCtrl:FontBold := aFont[3]
      ENDIF
      IF ::aFontItalic[si] <> aFont[4]
         ::aFontItalic[si] := aFont[4]
         oCtrl:FontItalic := aFont[4]
      ENDIF
      nRed := aFont[5,1]
      nGreen := aFont[5,2]
      nBlue := aFont[5,3]
      IF nRed <> NIL .AND. nGreen <> NIL .AND. nBlue <> NIL
         cColor := '{ ' + LTrim( Str( nRed ) ) + ', ' + ;
                          LTrim( Str( nGreen ) ) + ', ' + ;
                          LTrim( Str( nBlue ) ) + ' }'
         ::aFontColor[si] := cColor
         oCtrl:FontColor := &cColor
      ENDIF
      IF ::aFontUnderline[si] <> aFont[6]
         ::aFontUnderline[si] := aFont[6]
         oCtrl:FontUnderline := aFont[6]
      ENDIF
      IF ::aFontStrikeout[si] <> aFont[7]
         ::aFontStrikeout[si] := aFont[7]
         oCtrl:FontStrikeout := aFont[7]
      ENDIF
   ENDIF
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD SetBackColor( si ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cCode, cBackColor, aColor, cName, i

   IF si == 0
     cBackColor := ::cFBackcolor
   ELSE
     cBackColor := ::aBackColor[si]
   ENDIF
   IF IsValidArray( cBackColor )
      aColor := GetColor( &cBackColor )
   ELSE
      aColor := GetColor()
   ENDIF
   IF aColor[1] == NIL .AND. aColor[2] == NIL .AND. aColor[3] == NIL
      RETURN NIL
   ENDIF
   cCode := '{ ' + LTrim( Str( aColor[1] ) ) + ", " + ;
                   LTrim( Str( aColor[2] ) ) + ", " + ;
                   LTrim( Str( aColor[3] ) ) + " }"
   IF si == 0
      ::cFBackcolor := cCode
      ::oDesignForm:BackColor := &cCode
      ::oDesignForm:Hide()
      FOR i := 2 to ::nControlW
         cName := ::aControlW[i]
         ::RecreateControl( ::oDesignForm:&cName:Object(), i )
      NEXT i
      EraseWindow( ::oDesignForm:Name )
      ::oDesignForm:Show()
      ::oCtrlList:SetFocus()
      ::oCtrlList:Value := {}
   ELSE
      cName := ::aControlW[si]
      ::aBackColor[si] := cCode
      ::oDesignForm:&cName:BackColor := &cCode
   ENDIF
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD SetDefaultBackColor( si ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, i

   IF si == 0
      ::cFBackcolor := 'NIL'
      ::oDesignForm:BackColor := NIL
      ::oDesignForm:Hide()
      FOR i := 2 to ::nControlW
         cName := ::aControlW[i]
         ::RecreateControl( ::oDesignForm:&cName:Object(), i )
      NEXT i
      ::oDesignForm:Show()
   ELSE
      cName := ::aControlW[si]
      ::aBackColor[si] := 'NIL'
      ::oDesignForm:&cName:BackColor := NIL
   ENDIF
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD GOtherColors( si, nColor ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cColor, aColor, cName

   IF ! ::aCtrlType[si] == 'MONTHCALENDAR'
      RETURN NIL
   ENDIF

   DO CASE
   CASE nColor == 1
      cColor := ::aTitleFontColor[si]
   CASE nColor == 2
      cColor := ::aTitleBackColor[si]
   CASE nColor == 3
      cColor := ::aTrailingFontColor[si]
   CASE nColor == 4
      cColor := ::aBackgroundColor[si]
   OTHERWISE
      RETURN NIL
   ENDCASE

   IF IsValidArray( cColor )
      aColor := GetColor( &cColor )
   ELSE
      aColor := GetColor()
   ENDIF
   IF aColor[1] == NIL .AND. aColor[2] == NIL .AND. aColor[3] == NIL
      RETURN NIL
   ENDIF
   cColor := '{ ' + LTrim( Str( aColor[1] ) ) + ", " + ;
                    LTrim( Str( aColor[2] ) ) + ", " + ;
                    LTrim( Str( aColor[3] ) ) + " }"

   IF ::aCtrlType[si] == 'MONTHCALENDAR'
      cName := ::aControlW[si]
      DO CASE
      CASE nColor == 1
         ::aTitleFontColor[si] := cColor
         ::oDesignForm:&cName:TitleFontColor := &cColor
      CASE nColor == 2
         ::aTitleBackColor[si] := cColor
         ::oDesignForm:&cName:TitleBackColor := &cColor
      CASE nColor == 3
         ::aTrailingFontColor[si] := cColor
         ::oDesignForm:&cName:TrailingFontColor := &cColor
      CASE nColor == 4
         ::aBackgroundColor[si] := cColor
         ::oDesignForm:&cName:BackgroundColor := &cColor
      OTHERWISE
         RETURN NIL
      ENDCASE
      ::lFSave := .F.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD VerifyBar() CLASS TFormEditor
//------------------------------------------------------------------------------
   IF ::lSStat
      ::cvcControls:Control_Stabusbar:Visible := .F.
      ::lSStat := .F.
      ::oDesignForm:Statusbar:Release()
   ELSE
      ::cvcControls:Control_Stabusbar:Visible := .T.
      ::lSStat := .T.
      ::CreateStatusBar()
   ENDIF
   ::lFSave := .F.
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateStatusBar() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aCaptions, aWidths, aActions, aIcons, aStyles, aToolTips, aAligns, nCant, i

   TMessageBar():Define( "StatusBar", ::oDesignForm:Name, 0, 0, 0, 0, NIL, NIL, ;
         IIF( Empty( ::cSFontName ), NIL, ::cSFontName ), IIF( ::nSFontSize > 0, ::nSFontSize, NIL ), ;
         NIL, .F., .F., .F., NIL, NIL, ::lSBold, ::lSItalic, ::lSUnderline, ::lSStrikeout, ;
         ::lSTop, ::lSNoAutoAdjust, NIL, NIL, NIL, NIL )

      aCaptions := IF( Empty( ::cSCaption ), {}, &( ::cSCaption ) )
      aWidths   := IF( Empty( ::cSWidth ), {}, &( ::cSWidth ) )
      aActions  := IF( Empty( ::cSAction ), {}, &( ::cSAction ) )
      aIcons    := IF( Empty( ::cSIcon ), {}, &( ::cSIcon ) )
      aStyles   := IF( Empty( ::cSStyle ), {}, &( ::cSStyle ) )
      aToolTips := IF( Empty( ::cSToolTip ), {}, &( ::cSToolTip ) )
      aAligns   := IF( Empty( ::cSAlign ), {}, &( ::cSAlign ) )

      nCant := Len( aCaptions )
      aSize( aWidths, nCant )
      aSize( aActions, nCant )
      aSize( aIcons, nCant )
      aSize( aStyles, nCant )
      aSize( aToolTips, nCant )
      aSize( aAligns, nCant )

      FOR i := 1 TO nCant
         _SetStatusItem( aCaptions[i], aWidths[i], NIL, aToolTips[i], aIcons[i], aStyles[i], aAligns[i] )
      NEXT i
      IF ::lSKeyboard
         _SetStatusKeybrd( ::nSKWidth, ::cSKToolTip, NIL, ::cSKImage, ::cSKStyle, ::cSKAlign )
      ENDIF
      IF ::lSDate
         _SetStatusItem( Dtoc( Date() ), IIF( ::nSDWidth > 0, ::nSDWidth, IIF( "yyyy" $ Lower( Set( _SET_DATEFORMAT ) ), 95, 75 ) ), NIL, ::cSDToolTip, NIL, ::cSDStyle, ::cSDAlign )
      ENDIF
      IF ::lSTime
         _SetStatusClock( ::nSCWidth, ::cSCToolTip, NIL, ::lSCAmPm, ::cSCImage, ::cSCStyle, ::cSCAlign )
      ENDIF
   END STATUSBAR
RETURN NIL

//------------------------------------------------------------------------------
METHOD StatPropEvents() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cTitle, aLabels, aInitValues, aFormats, aResults

   cTitle      := "Statusbar properties"
   aLabels     := { '**** STATUSBAR clauses', 'Obj',    'Top',   'NoAutoAdjust',   'SubClass',   '**** STATUSITEM clauses', 'Caption',  'Width',    'Action',   'Icon',   'Style',   'ToolTip',   'Align',   '**** DATE clauses', 'Date',   'Width',    'Action',    'ToolTip',    'Style',                                                             'Align',                                                                                              '**** CLOCK clauses', 'Clock',  'Width',    'Action',    'ToolTip',    'Icon',     'AmPm',    'Style',                                                             'Align',                                                                                              '**** KEYBOARD clauses', 'Keyboard',   'Width',    'Action',    'ToolTip',    'Icon',     'Style',                                                             'Align' }
   aInitValues := { NIL,                      ::cSCObj, ::lSTop, ::lSNoAutoAdjust, ::cSSubClass, NIL,                       ::cSCaption, ::cSWidth, ::cSAction, ::cSIcon, ::cSStyle, ::cSToolTip, ::cSAlign, NIL,                 ::lSDate, ::nSDWidth, ::cSDAction, ::cSDToolTip, IIF( ::cSDStyle == 'FLAT', 1, IIF( ::cSDStyle == 'RAISED', 2, 3 ) ), IIF( ::cSDAlign == 'CENTER', 1, IIF( ::cSDAlign == 'LEFT', 2, IIF( ::cSDAlign == 'RIGHT', 3, 4 ) ) ), NIL,                  ::lSTime, ::nSCWidth, ::cSCAction, ::cSCToolTip, ::cSCImage, ::lSCAmPm, IIF( ::cSCStyle == 'FLAT', 1, IIF( ::cSCStyle == 'RAISED', 2, 3 ) ), IIF( ::cSCAlign == 'CENTER', 1, IIF( ::cSCAlign == 'LEFT', 2, IIF( ::cSCAlign == 'RIGHT', 3, 4 ) ) ), NIL,                     ::lSKeyboard, ::nSKWidth, ::cSKAction, ::cSKToolTip, ::cSKImage, IIF( ::cSKStyle == 'FLAT', 1, IIF( ::cSKStyle == 'RAISED', 2, 3 ) ), IIF( ::cSKAlign == 'CENTER', 1, IIF( ::cSKAlign == 'LEFT', 2, IIF( ::cSKAlign == 'RIGHT', 3, 4 ) ) ) }
   aFormats    := { NIL,                      31,      .F.,    .F.,             250,             NIL,                       250,         250,       250,        250,      250,       250,         250,       NIL,                 .F.,      '9999',     250,         250,          { 'FLAT', 'RAISED', 'NONE' },                                        { 'CENTER', 'LEFT', 'RIGHT', 'NONE' },                                                                NIL,                  .F.,      '9999',     250,         250,          250,        .F.,       { 'FLAT', 'RAISED', 'NONE' },                                        { 'CENTER', 'LEFT', 'RIGHT', 'NONE' },                                                                NIL,                     .T.,          '9999',     250,         250,          250,        { 'FLAT', 'RAISED', 'NONE' },                                        { 'CENTER', 'LEFT', 'RIGHT', 'NONE' } }
   aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats, {|| ::SetFontType( -1 ) }, {|| ::SetDefaultFontType( -1 ) } )
   IF aResults[1] == NIL
      ::Control_Click( 1 )
      RETURN NIL
   ENDIF

   ::cSCObj         := aResults[02]
   ::lSTop          := aResults[03]
   ::lSNoAutoAdjust := aResults[04]
   ::cSSubClass     := aResults[05]
   ::cSCaption      := IIF( IsValidArray( aResults[07] ), aResults[07], ::cSCaption )
   ::cSWidth        := IIF( IsValidArray( aResults[08] ), aResults[08], ::cSWidth )
   ::cSAction       := IIF( IsValidArray( aResults[08] ), aResults[09], ::cSAction )
   ::cSIcon         := IIF( IsValidArray( aResults[10] ), aResults[10], ::cSIcon )
   ::cSStyle        := IIF( IsValidArray( aResults[11] ), aResults[11], ::cSStyle )
   ::cSToolTip      := IIF( IsValidArray( aResults[12] ), aResults[12], ::cSToolTip )
   ::cSAlign        := IIF( IsValidArray( aResults[13] ), aResults[13], ::cSAlign )
   ::lSDate         := aResults[15]
   ::nSDWidth       := aResults[16]
   ::cSDAction      := aResults[17]
   ::cSDToolTip     := aResults[18]
   ::cSDStyle       := IIF( aResults[19] == 1, 'FLAT', IIF( aResults[19] == 2, 'RAISED', '' ) )
   ::cSDAlign       := IIF( aResults[20] == 1, 'CENTER', IIF( aResults[20] == 2, 'LEFT', IIF( aResults[20] == 3, 'RIGHT', '' ) ) )
   ::lSTime         := aResults[22]
   ::nSCWidth       := aResults[23]
   ::cSCAction      := aResults[24]
   ::cSCToolTip     := aResults[25]
   ::cSCImage       := aResults[26]
   ::lSCAmPm        := aResults[27]
   ::cSCStyle       := IIF( aResults[28] == 1, 'FLAT', IIF( aResults[28] == 2, 'RAISED', '' ) )
   ::cSCAlign       := IIF( aResults[29] == 1, 'CENTER', IIF( aResults[29] == 2, 'LEFT', IIF( aResults[29] == 3, 'RIGHT', '' ) ) )
   ::lSKeyboard     := aResults[31]
   ::nSKWidth       := aResults[32]
   ::cSKAction      := aResults[33]
   ::cSKToolTip     := aResults[34]
   ::cSKImage       := aResults[35]
   ::cSKStyle       := IIF( aResults[36] == 1, 'FLAT', IIF( aResults[36] == 2, 'RAISED', '' ) )
   ::cSKAlign       := IIF( aResults[37] == 1, 'CENTER', IIF( aResults[37] == 2, 'LEFT', IIF( aResults[37] == 3, 'RIGHT', '' ) ) )

   ::oDesignForm:Statusbar:Release()
   ::CreateStatusBar()

   ::lFsave := .F.
   ::Control_Click( 1 )
RETURN NIL

//------------------------------------------------------------------------------
METHOD IsUnique( cName, nExclude ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i

   cName := Upper( AllTrim( cName ) )

   FOR i := 1 TO ::nControlW
      IF Upper( ::aName[i] ) == cName .AND. i # nExclude
         RETURN .F.
      ENDIF
   NEXT i
RETURN .T.

//------------------------------------------------------------------------------
METHOD IniArray( cControlName, cCtrlType ) CLASS TFormEditor
//------------------------------------------------------------------------------
   aAdd( ::a3State, .F. )
   aAdd( ::aAction, "" )
   aAdd( ::aAction2, "" )
   aAdd( ::aAddress, "" )
   aAdd( ::aAfterColMove, "" )
   aAdd( ::aAfterColSize, "" )
   aAdd( ::aAppend, .F. )
   aAdd( ::aAutoPlay, .F. )
   aAdd( ::aBackColor, 'NIL' )
   aAdd( ::aBackground, '' )
   aAdd( ::aBackgroundColor, 'NIL' )
   aAdd( ::aBeforeAutoFit, "" )
   aAdd( ::aBeforeColMove, "" )
   aAdd( ::aBeforeColSize, "" )
   aAdd( ::aBold, .F. )
   aAdd( ::aBorder, .F. )
   aAdd( ::aBoth, .F. )
   aAdd( ::aBreak, .F. )
   aAdd( ::aBuffer, "" )
   aAdd( ::aButtons, .F. )
   aAdd( ::aButtonWidth, 0 )
   aAdd( ::aByCell, .F. )
   aAdd( ::aCancel, .F. )
   aAdd( ::aCaption, "" )
   aAdd( ::aCenter, .F. )
   aAdd( ::aCenterAlign, .F. )
   aAdd( ::aCheckBoxes, .F. )
   aAdd( ::aClientEdge, .F. )
   aAdd( ::aCObj, '' )
   aAdd( ::aColumnControls, "" )
   aAdd( ::aColumnInfo, "" )
   aAdd( ::aControlW, Lower( cControlName ) )
   aAdd( ::aCtrlType, Upper( cCtrlType ) )
   aAdd( ::aDate, .F. )
   aAdd( ::aDefaultYear, 0 )
   aAdd( ::aDelayedLoad, .F. )
   aAdd( ::aDelete, .F. )
   aAdd( ::aDeleteMsg, "" )
   aAdd( ::aDeleteWhen, "" )
   aAdd( ::aDescend, .F. )
   aAdd( ::aDIBSection, .F. )
   aAdd( ::aDisplayEdit, .F. )
   aAdd( ::aDoubleBuffer, .F. )
   aAdd( ::aDrag, .F. )
   aAdd( ::aDrop, .F. )
   aAdd( ::aDynamicBackColor, "" )
   aAdd( ::aDynamicCtrls, .F. )
   aAdd( ::aDynamicForeColor, "" )
   aAdd( ::aDynBlocks, .F. )
   aAdd( ::aEdit, .F. )
   aAdd( ::aEditKeys, "" )
   aAdd( ::aEditLabels, .F. )
   aAdd( ::aEnabled, .T. )
   aAdd( ::aExclude, "" )
   aAdd( ::aExtDblClick, .F. )
   aAdd( ::aField, '' )
   aAdd( ::aFields, '' )
   aAdd( ::aFile, "" )
   aAdd( ::aFileType, 0 )
   aAdd( ::aFirstItem, .F. )
   aAdd( ::aFit, .F. )
   aAdd( ::aFixBlocks, .F. )
   aAdd( ::aFixedCols, .F. )
   aAdd( ::aFixedCtrls, .F. )
   aAdd( ::aFixedWidths, .F. )
   aAdd( ::aFlat, .F. )
   aAdd( ::aFocusedPos, 0 )
   aAdd( ::aFocusRect, .F. )
   aAdd( ::aFontColor, 'NIL' )
   aAdd( ::aFontItalic, .F. )
   aAdd( ::aFontName, "" )
   aAdd( ::aFontSize, 0 )
   aAdd( ::aFontStrikeout, .F. )
   aAdd( ::aFontUnderline, .F. )
   aAdd( ::aForceRefresh, .F. )
   aAdd( ::aForceScale, .F. )
   aAdd( ::aFull, .F. )
   aAdd( ::aGripperText, "" )
   aAdd( ::aHandCursor, .F. )
   aAdd( ::aHBitmap, "" )
   aAdd( ::aHeaderImages, "" )
   aAdd( ::aHeaders, "{ 'one', 'two' }" )
   aAdd( ::aHelpID, 0 )
   aAdd( ::aHotTrack, .F. )
   aAdd( ::aImage, '' )
   aAdd( ::aImageMargin, "" )
   aAdd( ::aImagesAlign, "" )
   aAdd( ::aImageSize, .F. )
   aAdd( ::aImageSource, "" )
   aAdd( ::aIncrement, 0 )
   aAdd( ::aIncremental, .F. )
   aAdd( ::aIndent, 0 )
   aAdd( ::aInPlace, .T. )
   aAdd( ::aInputMask, "" )
   aAdd( ::aInsertType, 0 )
   aAdd( ::aIntegralHeight, .F. )
   aAdd( ::aInvisible, .F. )
   aAdd( ::aItemCount, 0 )
   aAdd( ::aItemIDs, .F. )
   aAdd( ::aItemImageNumber, "" )
   aAdd( ::aItemImages, ''  )
   aAdd( ::aItems,  "" )
   aAdd( ::aItemSource, "" )
   aAdd( ::aJustify, '' )
   aAdd( ::aLeft, .F. )
   aAdd( ::aLikeExcel, .F. )
   aAdd( ::aListWidth, 0 )
   aAdd( ::aLock, .F. )
   aAdd( ::aLowerCase, .F. )
   aAdd( ::aMarquee, 0 )
   aAdd( ::aMaxLength, 30 )
   aAdd( ::aMultiLine, .F. )
   aAdd( ::aMultiSelect, .F. )
   aAdd( ::aName, cControlName )
   aAdd( ::aNo3DColors, .F. )
   aAdd( ::aNoAutoSizeMovie, .F. )
   aAdd( ::aNoAutoSizeWindow, .F. )
   aAdd( ::aNoClickOnCheck, .F. )
   aAdd( ::aNodeImages, '' )
   aAdd( ::aNoDelMsg, .F. )
   aAdd( ::aNoErrorDlg, .F. )
   aAdd( ::aNoFocusRect, .F. )
   aAdd( ::aNoHeaders, .F. )
   aAdd( ::aNoHideSel, .F. )
   aAdd( ::aNoHScroll, .F. )
   aAdd( ::aNoLines, .F. )
   aAdd( ::aNoLoadTrans, .F. )
   aAdd( ::aNoMenu, .F. )
   aAdd( ::aNoModalEdit, .F. )
   aAdd( ::aNoOpen, .F. )
   aAdd( ::aNoPlayBar, .F. )
   aAdd( ::aNoPrefix, .F. )
   aAdd( ::aNoRClickOnCheck, .F. )
   aAdd( ::aNoRefresh, .F. )
   aAdd( ::aNoRootButton, .F. )
   aAdd( ::aNoTabStop, .F. )
   aAdd( ::aNoTicks, .F. )
   aAdd( ::aNoToday, .F. )
   aAdd( ::aNoTodayCircle, .F. )
   aAdd( ::aNoVScroll, .F. )
   aAdd( ::aNumber, 0 )
   aAdd( ::aNumeric, .F. )
   aAdd( ::aOnAbortEdit, "" )
   aAdd( ::aOnAppend, "" )
   aAdd( ::aOnChange, "" )
   aAdd( ::aOnCheckChg, "" )
   aAdd( ::aOnDblClick, "" )
   aAdd( ::aOnDelete, "" )
   aAdd( ::aOnDisplayChange, "" )
   aAdd( ::aOnDrop, "" )
   aAdd( ::aOnEditCell, "" )
   aAdd( ::aOnEnter, '' )
   aAdd( ::aOnGotFocus, "" )
   aAdd( ::aOnHeadClick, '' )
   aAdd( ::aOnHeadRClick, "" )
   aAdd( ::aOnHScroll, "" )
   aAdd( ::aOnLabelEdit, "" )
   aAdd( ::aOnListClose, "" )
   aAdd( ::aOnListDisplay, "" )
   aAdd( ::aOnLostFocus, "" )
   aAdd( ::aOnMouseMove, "" )
   aAdd( ::aOnQueryData, "" )
   aAdd( ::aOnRefresh, "" )
   aAdd( ::aOnSelChange, "" )
   aAdd( ::aOnTextFilled, "" )
   aAdd( ::aOnVScroll, "" )
   aAdd( ::aOpaque, .F. )
   aAdd( ::aPageNames, "" )
   aAdd( ::aPageObjs, "" )
   aAdd( ::aPageSubClasses, "" )
   aAdd( ::aPassWord, .F. )
   aAdd( ::aPicture, "" )
   aAdd( ::aPlainText, .F. )
   aAdd( ::aPLM, .F. )
   aAdd( ::aRange, "" )
   aAdd( ::aReadOnly, .F. )
   aAdd( ::aReadOnlyB, '' )
   aAdd( ::aRecCount, .F. )
   aAdd( ::aRefresh, .F. )
   aAdd( ::aReplaceField, "" )
   aAdd( ::aRightAlign, .F. )
   aAdd( ::aRTL, .F. )
   aAdd( ::aSearchLapse, 0 )
   aAdd( ::aSelBold, .F. )
   aAdd( ::aSelColor, "" )
   aAdd( ::aShowAll, .F. )
   aAdd( ::aShowMode, .F. )
   aAdd( ::aShowName, .F. )
   aAdd( ::aShowNone, .F. )
   aAdd( ::aShowPosition, .F. )
   aAdd( ::aSingleBuffer, .F. )
   aAdd( ::aSingleExpand, .F. )
   aAdd( ::aSmooth, .F. )
   aAdd( ::aSort, .F. )
   aAdd( ::aSourceOrder, "" )
   aAdd( ::aSpacing, 25 )
   aAdd( ::aSpeed, 1 )
   aAdd( ::aStretch, .F. )
   aAdd( ::aSubClass, "" )
   aAdd( ::aSync, .F. )
   aAdd( ::aTabPage, { '', 0 } )
   aAdd( ::aTarget, "" )
   aAdd( ::aTextHeight, 0 )
   aAdd( ::aThemed, .F. )
   aAdd( ::aTitleBackColor, 'NIL' )
   aAdd( ::aTitleFontColor, 'NIL' )
   aAdd( ::aToolTip, "" )
   aAdd( ::aTop, .F. )
   aAdd( ::aTrailingFontColor, 'NIL' )
   aAdd( ::aTransparent, .T. )
   aAdd( ::aUnSync, .F. )
   aAdd( ::aUpdate, .F. )
   aAdd( ::aUpdateColors, .F. )
   aAdd( ::aUpDown, .F. )
   aAdd( ::aUpperCase, .F. )
   aAdd( ::aValid, '' )
   aAdd( ::aValidMess, '' )
   aAdd( ::aValue, "" )
   aAdd( ::aValueL, .F. )
   aAdd( ::aValueN, 0 )
   aAdd( ::aValueSource, "" )
   aAdd( ::aVertical, .F. )
   aAdd( ::aVirtual, .F. )
   aAdd( ::aVisible, .T. )
   aAdd( ::aWeekNumbers, .F. )
   aAdd( ::aWhen, '' )
   aAdd( ::aWhiteBack, .F. )
   aAdd( ::aWidths, '{ 60, 60 }' )
   aAdd( ::aWorkArea, 'Alias()' )
   aAdd( ::aWrap, .F. )

   ::nControlW ++
RETURN NIL

//------------------------------------------------------------------------------
METHOD DelArray( z ) CLASS TFormEditor
//------------------------------------------------------------------------------
   my_aDel( ::a3State, z )
   my_aDel( ::aAction, z )
   my_aDel( ::aAction2, z )
   my_aDel( ::aAddress, z )
   my_aDel( ::aAfterColMove, z )
   my_aDel( ::aAfterColSize, z )
   my_aDel( ::aAppend, z )
   my_aDel( ::aAutoPlay, z )
   my_aDel( ::aBackColor, z )
   my_aDel( ::aBackground, z )
   my_aDel( ::aBackgroundColor, z )
   my_aDel( ::aBeforeAutoFit, z )
   my_aDel( ::aBeforeColMove, z )
   my_aDel( ::aBeforeColSize, z )
   my_aDel( ::aBold, z )
   my_aDel( ::aBorder, z )
   my_aDel( ::aBoth, z )
   my_aDel( ::aBreak, z )
   my_aDel( ::aBuffer, z )
   my_aDel( ::aButtons, z )
   my_aDel( ::aButtonWidth, z )
   my_aDel( ::aByCell, z )
   my_aDel( ::aCancel, z )
   my_aDel( ::aCaption, z )
   my_aDel( ::aCenter, z )
   my_aDel( ::aCenterAlign, z )
   my_aDel( ::aCheckBoxes, z )
   my_aDel( ::aClientEdge, z )
   my_aDel( ::aCObj, z)
   my_aDel( ::aColumnControls, z )
   my_aDel( ::aColumnInfo, z )
   my_aDel( ::aControlW, z )
   my_aDel( ::aCtrlType, z )
   my_aDel( ::aDate, z )
   my_aDel( ::aDefaultYear, z )
   my_aDel( ::aDelayedLoad, z )
   my_aDel( ::aDelete, z )
   my_aDel( ::aDeleteMsg, z )
   my_aDel( ::aDeleteWhen, z )
   my_aDel( ::aDescend, z )
   my_aDel( ::aDIBSection, z )
   my_aDel( ::aDisplayEdit, z )
   my_aDel( ::aDoubleBuffer, z )
   my_aDel( ::aDrag, z )
   my_aDel( ::aDrop, z )
   my_aDel( ::aDynamicBackColor, z )
   my_aDel( ::aDynamicCtrls, z )
   my_aDel( ::aDynamicForeColor, z )
   my_aDel( ::aDynBlocks, z )
   my_aDel( ::aEdit, z )
   my_aDel( ::aEditKeys, z )
   my_aDel( ::aEditLabels, z )
   my_aDel( ::aEnabled, z )
   my_aDel( ::aExclude, z )
   my_aDel( ::aExtDblClick, z )
   my_aDel( ::aField, z )
   my_aDel( ::aFields, z )
   my_aDel( ::aFile, z )
   my_aDel( ::aFileType, z )
   my_aDel( ::aFirstItem, z )
   my_aDel( ::aFit, z )
   my_aDel( ::aFixBlocks, z )
   my_aDel( ::aFixedCols, z )
   my_aDel( ::aFixedCtrls, z )
   my_aDel( ::aFixedWidths, z )
   my_aDel( ::aFlat, z )
   my_aDel( ::aFocusedPos, z )
   my_aDel( ::aFocusRect, z )
   my_aDel( ::aFontColor, z )
   my_aDel( ::aFontItalic, z )
   my_aDel( ::aFontName, z )
   my_aDel( ::aFontSize, z )
   my_aDel( ::aFontStrikeout, z )
   my_aDel( ::aFontUnderline, z )
   my_aDel( ::aForceRefresh, z )
   my_aDel( ::aForceScale, z )
   my_aDel( ::aFull, z )
   my_aDel( ::aGripperText, z )
   my_aDel( ::aHandCursor, z )
   my_aDel( ::aHBitmap, z )
   my_aDel( ::aHeaderImages, z )
   my_aDel( ::aHeaders, z )
   my_aDel( ::aHelpID, z )
   my_aDel( ::aHotTrack, z )
   my_aDel( ::aImage, z )
   my_aDel( ::aImageMargin, z )
   my_aDel( ::aImagesAlign, z )
   my_aDel( ::aImageSize, z )
   my_aDel( ::aImageSource, z )
   my_aDel( ::aIncrement, z )
   my_aDel( ::aIncremental, z )
   my_aDel( ::aIndent, z )
   my_aDel( ::aInPlace, z )
   my_aDel( ::aInputMask, z )
   my_aDel( ::aInsertType, z )
   my_aDel( ::aIntegralHeight, z )
   my_aDel( ::aInvisible, z )
   my_aDel( ::aItemCount, z )
   my_aDel( ::aItemIDs, z )
   my_aDel( ::aItemImageNumber, z )
   my_aDel( ::aItemImages, z  )
   my_aDel( ::aItems,  z )
   my_aDel( ::aItemSource, z )
   my_aDel( ::aJustify, z )
   my_aDel( ::aLeft, z )
   my_aDel( ::aLikeExcel, z )
   my_aDel( ::aListWidth, z )
   my_aDel( ::aLock, z )
   my_aDel( ::aLowerCase, z )
   my_aDel( ::aMarquee, z )
   my_aDel( ::aMaxLength, z )
   my_aDel( ::aMultiLine, z )
   my_aDel( ::aMultiSelect, z )
   my_aDel( ::aName, z )
   my_aDel( ::aNo3DColors, z )
   my_aDel( ::aNoAutoSizeMovie, z )
   my_aDel( ::aNoAutoSizeWindow, z )
   my_aDel( ::aNoClickOnCheck, z )
   my_aDel( ::aNodeImages, z )
   my_aDel( ::aNoDelMsg, z )
   my_aDel( ::aNoErrorDlg, z )
   my_aDel( ::aNoFocusRect, z )
   my_aDel( ::aNoHeaders, z )
   my_aDel( ::aNoHideSel, z )
   my_aDel( ::aNoHScroll, z )
   my_aDel( ::aNoLines, z )
   my_aDel( ::aNoLoadTrans, z )
   my_aDel( ::aNoMenu, z )
   my_aDel( ::aNoModalEdit, z )
   my_aDel( ::aNoOpen, z )
   my_aDel( ::aNoPlayBar, z )
   my_aDel( ::aNoPrefix, z )
   my_aDel( ::aNoRClickOnCheck, z )
   my_aDel( ::aNoRefresh, z )
   my_aDel( ::aNoRootButton, z )
   my_aDel( ::aNoTabStop, z )
   my_aDel( ::aNoTicks, z )
   my_aDel( ::aNoToday, z )
   my_aDel( ::aNoTodayCircle, z )
   my_aDel( ::aNoVScroll, z )
   my_aDel( ::aNumber, z )
   my_aDel( ::aNumeric, z )
   my_aDel( ::aOnAbortEdit, z )
   my_aDel( ::aOnAppend, z )
   my_aDel( ::aOnChange, z )
   my_aDel( ::aOnCheckChg, z )
   my_aDel( ::aOnDblClick, z )
   my_aDel( ::aOnDelete, z )
   my_aDel( ::aOnDisplayChange, z )
   my_aDel( ::aOnDrop, z )
   my_aDel( ::aOnEditCell, z )
   my_aDel( ::aOnEnter, z )
   my_aDel( ::aOnGotFocus, z )
   my_aDel( ::aOnHeadClick, z )
   my_aDel( ::aOnHeadRClick, z )
   my_aDel( ::aOnHScroll, z )
   my_aDel( ::aOnLabelEdit, z )
   my_aDel( ::aOnListClose, z )
   my_aDel( ::aOnListDisplay, z )
   my_aDel( ::aOnLostFocus, z )
   my_aDel( ::aOnMouseMove, z )
   my_aDel( ::aOnQueryData, z )
   my_aDel( ::aOnRefresh, z )
   my_aDel( ::aOnSelChange, z )
   my_aDel( ::aOnTextFilled, z )
   my_aDel( ::aOnVScroll, z )
   my_aDel( ::aOpaque, z )
   my_aDel( ::aPageNames, z )
   my_aDel( ::aPageObjs, z )
   my_aDel( ::aPageSubClasses, z )
   my_aDel( ::aPassWord, z )
   my_aDel( ::aPicture, z )
   my_aDel( ::aPlainText, z )
   my_aDel( ::aPLM, z )
   my_aDel( ::aRange, z )
   my_aDel( ::aReadOnly, z )
   my_aDel( ::aReadOnlyB, z )
   my_aDel( ::aRecCount, z )
   my_aDel( ::aRefresh, z )
   my_aDel( ::aReplaceField, z )
   my_aDel( ::aRightAlign, z )
   my_aDel( ::aRTL, z )
   my_aDel( ::aSearchLapse, z )
   my_aDel( ::aSelBold, z )
   my_aDel( ::aSelColor, z )
   my_aDel( ::aShowAll, z )
   my_aDel( ::aShowMode, z )
   my_aDel( ::aShowName, z )
   my_aDel( ::aShowNone, z )
   my_aDel( ::aShowPosition, z )
   my_aDel( ::aSingleBuffer, z )
   my_aDel( ::aSingleExpand, z )
   my_aDel( ::aSmooth, z )
   my_aDel( ::aSort, z )
   my_aDel( ::aSourceOrder, z )
   my_aDel( ::aSpacing, z )
   my_aDel( ::aSpeed, z )
   my_aDel( ::aStretch, z )
   my_aDel( ::aSubClass, z )
   my_aDel( ::aSync, z )
   my_aDel( ::aTabPage, z )
   my_aDel( ::aTarget, z )
   my_aDel( ::aTextHeight, z )
   my_aDel( ::aThemed, z )
   my_aDel( ::aTitleBackColor, z )
   my_aDel( ::aTitleFontColor, z )
   my_aDel( ::aToolTip, z )
   my_aDel( ::aTop, z )
   my_aDel( ::aTrailingFontColor, z )
   my_aDel( ::aTransparent, z )
   my_aDel( ::aUnSync, z )
   my_aDel( ::aUpdate, z )
   my_aDel( ::aUpdateColors, z )
   my_aDel( ::aUpDown, z )
   my_aDel( ::aUpperCase, z )
   my_aDel( ::aValid, z )
   my_aDel( ::aValidMess, z )
   my_aDel( ::aValue, z )
   my_aDel( ::aValueL, z )
   my_aDel( ::aValueN, z )
   my_aDel( ::aValueSource, z )
   my_aDel( ::aVertical, z )
   my_aDel( ::aVirtual, z )
   my_aDel( ::aVisible, z )
   my_aDel( ::aWeekNumbers, z )
   my_aDel( ::aWhen, z )
   my_aDel( ::aWhiteBack, z )
   my_aDel( ::aWidths, z )
   my_aDel( ::aWorkArea, z )
   my_aDel( ::aWrap, z )

   ::nControlW --
   IF ::nControlW == 1
      ::nIndexW := 0
      ::nHandleA := 0
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION my_aDel( arreglo, z )
//------------------------------------------------------------------------------
   aDel( arreglo, z )
   aSize( arreglo, Len( arreglo ) - 1 )
RETURN NIL

//------------------------------------------------------------------------------
METHOD MouseMoveSize() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, ia, cName, nOldRow, nOldCol, nNewRow, nNewCol, nNewWidth
LOCAL nNewHeight, nOldHeight, iw, oLabel
STATIC lBusy := .F.

   IF lBusy
      RETURN NIL
   ENDIF
   lBusy := .T.

   IF ::swCursor == 1                  // drag
      iw := ::nIndexW
      IF iw > 0
         IF ( ia := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == ::aControlW[iw] } ) ) == 0
            lBusy := .F.
            RETURN NIL
         ENDIF
         oControl := ::oDesignForm:aControls[ia]

         IF oControl:Type == 'RADIOGROUP'
            oControl:Hide()
            EraseWindow( ::oDesignForm:Name )
            ::DrawPoints()
            @ oControl:Row, oControl:Col LABEL 0 ;
               OBJ oLabel ;
               VALUE oControl:Name ;
               PARENT ( ::oDesignForm:Name ) ;
               WIDTH oControl:GroupWidth ;
               HEIGHT oControl:GroupHeight ;
               BORDER
            nOldRow := GetWindowRow( oLabel:hWnd )
            nOldCol := GetWindowCol( oLabel:hWnd )
            InteractiveMoveHandle( oLabel:hWnd )
            // the assignment of ::Row changes ::Col and viceversa, so
            // we need to calculate before assigning
            nNewRow := oControl:Row + GetWindowRow( oLabel:hWnd ) - nOldRow
            nNewCol := oControl:Col + GetWindowCol( oLabel:hWnd ) - nOldCol
            oLabel:Release()
            oControl:Show()
            oControl:Row := nNewRow
            oControl:Col := nNewCol
            ::Snap( oControl )
            ::lFSave := .F.
            IF ::aTabPage[iw, 2] > 0
               cName := ::aTabPage[iw, 1]
               ::oDesignForm:&cName:Show()
            ENDIF
            ::DrawOutline( oControl )

         ELSEIF ValidHandler( oControl:hWnd )
            nOldRow  := GetWindowRow( oControl:hWnd )
            nOldCol  := GetWindowCol( oControl:hWnd )
            EraseWindow( ::oDesignForm:Name )
            ::DrawPoints()
            InteractiveMoveHandle( oControl:hWnd )
            // the assignment of ::Row changes ::Col and viceversa, so
            // we need to calculate before assigning
            nNewRow := oControl:Row + GetWindowRow( oControl:hWnd ) - nOldRow
            nNewCol := oControl:Col + GetWindowCol( oControl:hWnd ) - nOldCol
            oControl:Row := nNewRow
            oControl:Col := nNewCol
            ::Snap( oControl )
            ::lFSave := .F.
            IF ::aTabPage[iw, 2] > 0
               cName := ::aTabPage[iw, 1]
               ::oDesignForm:&cName:Show()
            ENDIF
            ::DrawOutline( oControl )

         ELSE
            MsgStop( "This control can't be moved interactively.", "OOHG IDE+" )
         ENDIF
      ENDIF
      ::swCursor := 0
   ELSEIF ::swCursor == 2              // size
      iw := ::nIndexW
      IF iw > 0
         IF ( ia := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == ::aControlW[iw] } ) ) == 0
            lBusy := .F.
            RETURN NIL
         ENDIF
         oControl := ::oDesignForm:aControls[ia]

         IF oControl:Type == 'RADIOGROUP'
            oControl:Hide()
            EraseWindow( ::oDesignForm:Name )
            ::DrawPoints()
            @ oControl:Row, oControl:Col LABEL 0 ;
               OBJ oLabel ;
               VALUE oControl:Name ;
               PARENT ( ::oDesignForm:Name ) ;
               WIDTH oControl:GroupWidth ;
               HEIGHT oControl:GroupHeight ;
               BORDER
            InteractiveSizeHandle( oLabel:hWnd )
            // the assignment of ::Width changes ::Height and viceversa, so
            // we need to calculate before assigning
            IF oControl:lHorizontal
               nNewHeight      := GetWindowHeight( oLabel:hWnd )
               oControl:Height := nNewHeight
            ELSE
               nNewWidth       := GetWindowWidth( oLabel:hWnd )
               oControl:Width  := nNewWidth
            ENDIF
            oLabel:Release()
            oControl:Show()
            ::lFSave := .F.
            IF ::aTabPage[iw, 2] > 0
               cName := ::aTabPage[iw, 1]
               ::oDesignForm:&cName:Show()
            ENDIF
            ::DrawOutline( oControl )

         ELSEIF ValidHandler( oControl:hWnd )
            nOldHeight := oControl:Height
            InteractiveSizeHandle( oControl:hWnd )
            IF ::CrtlIsOfType( ia, 'RADIOGROUP COMBO' )
               oControl:Width  := GetWindowWidth ( oControl:hWnd )
               oControl:Height := nOldHeight
            ELSE
               // the assignment of ::Width changes ::Height and viceversa, so
               // we need to calculate before assigning
               nNewWidth       := GetWindowWidth( oControl:hWnd )
               nNewHeight      := GetWindowHeight( oControl:hWnd )
               oControl:Width  := nNewWidth
               oControl:Height := nNewHeight
            ENDIF
            ::lFSave := .F.
            IF ::aTabPage[iw, 2] > 0
               cName := ::aTabPage[iw, 1]
               ::oDesignForm:&cName:Show()
            ENDIF
            ::DrawOutline( oControl )

         ELSE
            MsgStop( "This control can't be sized interactively.", "OOHG IDE+" )
         ENDIF
      ENDIF
      ::swCursor := 0
   ENDIF

   lBusy := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD CopyControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ia, oControl, z, i, ControlName, oNewCtrl := NIL, cTab, oTab

   ia := ::nHandleA
   IF ia > 0
      oControl := ::oDesignForm:aControls[ia]
      z := aScan( ::aControlW, Lower( oControl:Name ) )

      i := aScan( ::ControlType, ::aCtrlType[z] )
      IF i > 0
         ::ControlCount[i] ++
         ControlName := ::ControlPrefix[i] + LTrim( Str( ::ControlCount[i] ) )
         Do While _IsControlDefined( ControlName, ::oDesignForm:Name )
            ::ControlCount[i] ++
            ControlName := ::ControlPrefix[i] + LTrim( Str( ::ControlCount[i] ) )
         ENDDO
         ::nControlW ++

         aAdd( ::a3State,            ::a3State[z] )
         aAdd( ::aAction,            ::aAction[z] )
         aAdd( ::aAction2,           ::aAction2[z] )
         aAdd( ::aAddress,           ::aAddress[z] )
         aAdd( ::aAfterColMove,      ::aAfterColMove[z] )
         aAdd( ::aAfterColSize,      ::aAfterColSize[z] )
         aAdd( ::aAppend,            ::aAppend[z] )
         aAdd( ::aAutoPlay,          ::aAutoPlay[z] )
         aAdd( ::aBackColor,         ::aBackColor[z] )
         aAdd( ::aBackground,        ::aBackground[z] )
         aAdd( ::aBackgroundColor,   ::aBackgroundColor[z] )
         aAdd( ::aBeforeAutoFit,     ::aBeforeAutoFit[z] )
         aAdd( ::aBeforeColMove,     ::aBeforeColMove[z] )
         aAdd( ::aBeforeColSize,     ::aBeforeColSize[z] )
         aAdd( ::aBold,              ::aBold[z] )
         aAdd( ::aBorder,            ::aBorder[z] )
         aAdd( ::aBoth,              ::aBoth[z] )
         aAdd( ::aBreak,             ::aBreak[z] )
         aAdd( ::aBuffer,            ::aBuffer[z] )
         aAdd( ::aButtons,           ::aButtons[z] )
         aAdd( ::aButtonWidth,       ::aButtonWidth[z] )
         aAdd( ::aByCell,            ::aByCell[z] )
         aAdd( ::aCancel,            ::aCancel[z] )
         aAdd( ::aCaption,           ::aCaption[z] )
         aAdd( ::aCenter,            ::aCenter[z] )
         aAdd( ::aCenterAlign,       ::aCenterAlign[z] )
         aAdd( ::aCheckBoxes,        ::aCheckBoxes[z] )
         aAdd( ::aClientEdge,        ::aClientEdge[z] )
         aAdd( ::aCObj,              ::aCObj[z] )
         aAdd( ::aColumnControls,    ::aColumnControls[z] )
         aAdd( ::aColumnInfo,        ::aColumnInfo[z] )
         aAdd( ::aControlW,          Lower( ControlName ) )
         aAdd( ::aCtrlType,          ::aCtrlType[z] )
         aAdd( ::aDate,              ::aDate[z] )
         aAdd( ::aDefaultYear,       ::aDefaultYear[z] )
         aAdd( ::aDelayedLoad,       ::aDelayedLoad[z] )
         aAdd( ::aDelete,            ::aDelete[z] )
         aAdd( ::aDeleteMsg,         ::aDeleteMsg[z] )
         aAdd( ::aDeleteWhen,        ::aDeleteWhen[z] )
         aAdd( ::aDescend,           ::aDescend[z] )
         aAdd( ::aDIBSection,        ::aDIBSection[z] )
         aAdd( ::aDisplayEdit,       ::aDisplayEdit[z] )
         aAdd( ::aDoubleBuffer,      ::aDoubleBuffer[z] )
         aAdd( ::aDrag,              ::aDrag[z] )
         aAdd( ::aDrop,              ::aDrop[z] )
         aAdd( ::aDynamicBackColor,  ::aDynamicBackColor[z] )
         aAdd( ::aDynamicCtrls,      ::aDynamicCtrls[z] )
         aAdd( ::aDynamicForeColor,  ::aDynamicForeColor[z] )
         aAdd( ::aDynBlocks,         ::aDynBlocks[z] )
         aAdd( ::aEdit,              ::aEdit[z] )
         aAdd( ::aEditKeys,          ::aEditKeys[z] )
         aAdd( ::aEditLabels,        ::aEditLabels[z] )
         aAdd( ::aEnabled,           ::aEnabled[z] )
         aAdd( ::aExclude,           ::aExclude[z] )
         aAdd( ::aExtDblClick,       ::aExtDblClick[z] )
         aAdd( ::aField,             ::aField[z] )
         aAdd( ::aFields,            ::aFields[z] )
         aAdd( ::aFile,              ::aFile[z] )
         aAdd( ::aFileType,          ::aFileType[z] )
         aAdd( ::aFirstItem,         ::aFirstItem[z] )
         aAdd( ::aFit,               ::aFit[z] )
         aAdd( ::aFixBlocks,         ::aFixBlocks[z] )
         aAdd( ::aFixedCols,         ::aFixedCols[z] )
         aAdd( ::aFixedCtrls,        ::aFixedCtrls[z] )
         aAdd( ::aFixedWidths,       ::aFixedWidths[z] )
         aAdd( ::aFlat,              ::aFlat[z] )
         aAdd( ::aFocusedPos,        ::aFocusedPos[z] )
         aAdd( ::aFocusRect,         ::aFocusRect[z] )
         aAdd( ::aFontColor,         ::aFontColor[z] )
         aAdd( ::aFontItalic,        ::aFontItalic[z] )
         aAdd( ::aFontName,          ::aFontName[z] )
         aAdd( ::aFontSize,          ::aFontSize[z] )
         aAdd( ::aFontStrikeout,     ::aFontStrikeout[z] )
         aAdd( ::aFontUnderline,     ::aFontUnderline[z] )
         aAdd( ::aForceRefresh,      ::aForceRefresh[z] )
         aAdd( ::aForceScale,        ::aForceScale[z] )
         aAdd( ::aFull,              ::aFull[z] )
         aAdd( ::aGripperText,       ::aGripperText[z] )
         aAdd( ::aHandCursor,        ::aHandCursor[z] )
         aAdd( ::aHBitmap,           ::aHBitmap[z] )
         aAdd( ::aHeaderImages,      ::aHeaderImages[z] )
         aAdd( ::aHeaders,           ::aHeaders[z] )
         aAdd( ::aHelpID,            ::aHelpID[z] )
         aAdd( ::ahottrack,          ::ahottrack[z] )
         aAdd( ::aImage,             ::aImage[z] )
         aAdd( ::aImageMargin,       ::aImageMargin[z] )
         aAdd( ::aImagesAlign,       ::aImagesAlign[z] )
         aAdd( ::aImageSize,         ::aImageSize[z] )
         aAdd( ::aImageSource,       ::aImageSource[z] )
         aAdd( ::aIncrement,         ::aIncrement[z] )
         aAdd( ::aIncremental,       ::aIncremental[z] )
         aAdd( ::aIndent,            ::aIndent[z] )
         aAdd( ::aInPlace,           ::aInPlace[z] )
         aAdd( ::aInputMask,         ::aInputMask[z] )
         aAdd( ::aInsertType,        ::aInsertType[z] )
         aAdd( ::aIntegralHeight,    ::aIntegralHeight[z] )
         aAdd( ::aInvisible,         ::aInvisible[z] )
         aAdd( ::aItemCount,         ::aItemCount[z] )
         aAdd( ::aItemIDs,           ::aItemIDs[z] )
         aAdd( ::aItemImageNumber,   ::aItemImageNumber[z] )
         aAdd( ::aItemImages,        ::aItemImages[z] )
         aAdd( ::aItems,             ::aItems[z] )
         aAdd( ::aItemSource,        ::aItemSource[z] )
         aAdd( ::aJustify,           ::aJustify[z] )
         aAdd( ::aLeft,              ::aLeft[z] )
         aAdd( ::aLikeExcel,         ::aLikeExcel[z] )
         aAdd( ::aListWidth,         ::aListWidth[z] )
         aAdd( ::aLock,              ::aLock[z] )
         aAdd( ::aLowerCase,         ::aLowerCase[z] )
         aAdd( ::aMarquee,           ::aMarquee[z] )
         aAdd( ::aMaxLength,         ::aMaxLength[z] )
         aAdd( ::aMultiLine,         ::aMultiLine[z] )
         aAdd( ::aMultiSelect,       ::aMultiSelect[z] )
         aAdd( ::aName,              ControlName )
         aAdd( ::aNo3DColors,        ::aNo3DColors[z] )
         aAdd( ::aNoAutoSizeMovie,   ::aNoAutoSizeMovie[z] )
         aAdd( ::aNoAutoSizeWindow,  ::aNoAutoSizeWindow[z] )
         aAdd( ::aNoClickOnCheck,    ::aNoClickOnCheck[z] )
         aAdd( ::aNodeImages,        ::aNodeImages[z] )
         aAdd( ::aNoDelMsg,          ::aNoDelMsg[z] )
         aAdd( ::aNoErrorDlg,        ::aNoErrorDlg[z] )
         aAdd( ::aNoFocusRect,       ::aNoFocusRect[z] )
         aAdd( ::aNoHeaders,         ::aNoHeaders[z] )
         aAdd( ::aNoHideSel,         ::aNoHideSel[z] )
         aAdd( ::aNoHScroll,         ::aNoHScroll[z] )
         aAdd( ::anolines,           ::anolines[z] )
         aAdd( ::aNoLoadTrans,       ::aNoLoadTrans[z] )
         aAdd( ::aNoMenu,            ::aNoMenu[z] )
         aAdd( ::aNoModalEdit,       ::aNoModalEdit[z] )
         aAdd( ::aNoOpen,            ::aNoOpen[z] )
         aAdd( ::aNoPlayBar,         ::aNoPlayBar[z] )
         aAdd( ::aNoPrefix,          ::aNoPrefix[z] )
         aAdd( ::aNoRClickOnCheck,   ::aNoRClickOnCheck[z] )
         aAdd( ::aNoRefresh,         ::aNoRefresh[z] )
         aAdd( ::aNoRootButton,      ::aNoRootButton[z] )
         aAdd( ::aNoTabStop,         ::aNoTabStop[z] )
         aAdd( ::aNoTicks,           ::aNoTicks[z] )
         aAdd( ::aNoToday,           ::aNoToday[z] )
         aAdd( ::aNoTodayCircle,     ::aNoTodayCircle[z] )
         aAdd( ::Anovscroll,         ::Anovscroll[z] )
         aAdd( ::aNumber,            ::aNumber[z] )
         aAdd( ::aNumeric,           ::aNumeric[z] )
         aAdd( ::aOnAbortEdit,       ::aOnAbortEdit[z] )
         aAdd( ::aOnAppend,          ::aOnAppend[z] )
         aAdd( ::aOnChange,          ::aOnChange[z] )
         aAdd( ::aOnCheckChg,        ::aOnCheckChg[z] )
         aAdd( ::aOnDblClick,        ::aOnDblClick[z] )
         aAdd( ::aOnDelete,          ::aOnDelete[z] )
         aAdd( ::aOnDisplayChange,   ::aOnDisplayChange[z] )
         aAdd( ::aOnDrop,            ::aOnDrop[z] )
         aAdd( ::aOnEditCell,        ::aOnEditCell[z] )
         aAdd( ::aonenter,           ::aonenter[z] )
         aAdd( ::aOnGotFocus,        ::aOnGotFocus[z] )
         aAdd( ::aOnHeadClick,       ::aOnHeadClick[z] )
         aAdd( ::aOnHeadRClick,      ::aOnHeadRClick[z] )
         aAdd( ::aOnHScroll,         ::aOnHScroll[z] )
         aAdd( ::aOnLabelEdit,       ::aOnLabelEdit[z] )
         aAdd( ::aOnListClose,       ::aOnListClose[z] )
         aAdd( ::aOnListDisplay,     ::aOnListDisplay[z] )
         aAdd( ::aOnLostFocus,       ::aOnLostFocus[z] )
         aAdd( ::aOnMouseMove,       ::aOnMouseMove[z] )
         aAdd( ::aOnQueryData,       ::aOnQueryData[z] )
         aAdd( ::aOnRefresh,         ::aOnRefresh[z] )
         aAdd( ::aOnSelChange,       ::aOnSelChange[z] )
         aAdd( ::aOnTextFilled,      ::aOnTextFilled[z] )
         aAdd( ::aOnVScroll,         ::aOnVScroll[z] )
         aAdd( ::aOpaque,            ::aOpaque[z] )
         aAdd( ::aPageNames,         ::aPageNames[z] )
         aAdd( ::aPageObjs,          ::aPageObjs[z] )
         aAdd( ::aPageSubClasses,    ::aPageSubClasses[z] )
         aAdd( ::aPassWord,          ::aPassWord[z] )
         aAdd( ::aPicture,           ::aPicture[z] )
         aAdd( ::aPlainText,         ::aPlainText[z] )
         aAdd( ::aPLM,               ::aPLM[z] )
         aAdd( ::aRange,             ::aRange[z] )
         aAdd( ::aReadOnly,          ::aReadOnly[z] )
         aAdd( ::aReadOnlyB,         ::aReadOnlyB[z] )
         aAdd( ::aRecCount,          ::aRecCount[z] )
         aAdd( ::aRefresh,           ::aRefresh[z] )
         aAdd( ::aReplaceField,      ::aReplaceField[z] )
         aAdd( ::aRightAlign,        ::aRightAlign[z] )
         aAdd( ::aRTL,               ::aRTL[z] )
         aAdd( ::aSearchLapse,       ::aSearchLapse[z] )
         aAdd( ::aSelBold,           ::aSelBold[z] )
         aAdd( ::aSelColor,          ::aSelColor[z] )
         aAdd( ::aShowAll,           ::aShowAll[z] )
         aAdd( ::aShowMode,          ::aShowMode[z] )
         aAdd( ::aShowName,          ::aShowName[z] )
         aAdd( ::aShowNone,          ::aShowNone[z] )
         aAdd( ::aShowPosition,      ::aShowPosition[z] )
         aAdd( ::aSingleBuffer,      ::aSingleBuffer[z] )
         aAdd( ::aSingleExpand,      ::aSingleExpand[z] )
         aAdd( ::aSmooth,            ::aSmooth[z] )
         aAdd( ::aSort,              ::aSort[z] )
         aAdd( ::aSourceOrder,       ::aSourceOrder[z] )
         aAdd( ::aSpacing,           ::aSpacing[z] )
         aAdd( ::aSpeed,             ::aSpeed[z] )
         aAdd( ::aStretch,           ::aStretch[z] )
         aAdd( ::aSubClass,          ::aSubClass[z] )
         aAdd( ::aSync,              ::aSync[z] )
         aAdd( ::aTabPage,           ::aTabPage[z] )
         aAdd( ::aTarget,            ::aTarget[z] )
         aAdd( ::aTextHeight,        ::aTextHeight[z] )
         aAdd( ::aThemed,            ::aThemed[z] )
         aAdd( ::aTitleBackColor,    ::aTitleBackColor[z] )
         aAdd( ::aTitleFontColor,    ::aTitleFontColor[z] )
         aAdd( ::aToolTip,           ::aToolTip[z] )
         aAdd( ::aTop,               ::aTop[z] )
         aAdd( ::aTrailingFontColor, ::aTrailingFontColor[z] )
         aAdd( ::aTransparent,       ::aTransparent[z] )
         aAdd( ::aUnSync,            ::aUnSync[z] )
         aAdd( ::aUpdate,            ::aUpdate[z] )
         aAdd( ::aUpdateColors,      ::aUpdateColors[z] )
         aAdd( ::aUpDown,            ::aUpDown[z] )
         aAdd( ::aUpperCase,         ::aUpperCase[z] )
         aAdd( ::avalid,             ::avalid[z] )
         aAdd( ::aValidMess,         ::aValidMess[z] )
         aAdd( ::aValue,             ::aValue[z] )
         aAdd( ::aValueL,            ::aValueL[z] )
         aAdd( ::aValueN,            ::aValueN[z] )
         aAdd( ::aValueSource,       ::aValueSource[z] )
         aAdd( ::aVertical,          ::aVertical[z] )
         aAdd( ::aVirtual,           ::aVirtual[z] )
         aAdd( ::aVisible,           ::aVisible[z] )
         aAdd( ::aWeekNumbers,       ::aWeekNumbers[z] )
         aAdd( ::aWhen,              ::aWhen[z] )
         aAdd( ::aWhiteBack,         ::aWhiteBack[z] )
         aAdd( ::aWidths,            ::aWidths[z] )
         aAdd( ::aWorkArea,          ::aWorkArea[z] )
         aAdd( ::aWrap,              ::aWrap[z] )

         oNewCtrl := ::CreateControl( i, ::nControlW, oControl:Width, oControl:Height, NIL )
         oNewCtrl:Row := oControl:Row + 10
         oNewCtrl:Col := oControl:Col + 10

         IF ::aTabPage[::nControlW, 1] # '' .AND. ::aTabPage[::nControlW, 2] > 0
            IF ( i := aScan( ::aName, { |c| Lower( c ) == ::aTabPage[::nControlW, 1] } ) ) > 0
               cTab := ::aControlW[i]
               IF ( i := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == cTab } ) ) > 0
                  oTab := ::oDesignForm:aControls[i]
                  oTab:AddControl( ControlName, ::aTabPage[::nControlW, 2], oNewCtrl:Row, oNewCtrl:Col )
                  ::ReorderTabs()
               ELSE
                  ::aTabPage[::nControlW, 1] := ''
                  ::aTabPage[::nControlW, 2] := 0
               ENDIF
            ELSE
               ::aTabPage[::nControlW, 1] := ''
               ::aTabPage[::nControlW, 2] := 0
            ENDIF
         ENDIF

         ::DrawOutline( oNewCtrl )
         ::lFSave := .F.
      ENDIF
   ENDIF
RETURN oNewCtrl

//------------------------------------------------------------------------------
METHOD ReorderTabs CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL k, k1

   // Order controls in TABs by TAB name
   FOR k := 2 TO ::nControlW
      FOR k1 := k + 1 TO ::nControlW
         IF ::aTabPage[k, 1] # '' .AND. ::aTabPage[k1, 1] # ''
            IF ::aTabPage[k, 1] > ::aTabPage[k1, 1]
               ::SwapArray( k, k1 )
            ENDIF
         ENDIF
      NEXT k1
   NEXT k
   // Order controls in each TAB by page
   FOR k := 2 TO ::nControlW
      FOR k1 := k + 1 TO ::nControlW
         IF ::aTabPage[k, 1] # '' .AND. ::aTabPage[k1, 1] # ''
            IF ::aTabPage[k, 1] == ::aTabPage[k1, 1]
               IF ::aTabPage[k, 2] > ::aTabPage[k1, 2]
                  ::SwapArray( k, k1 )
               ENDIF
            ENDIF
         ENDIF
      NEXT k1
   NEXT k
RETURN NIL

//------------------------------------------------------------------------------
METHOD CheckForFrame() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, oControl, SupMin, w_OOHG_MouseRow, w_OOHG_MouseCol, oCtrl

   w_OOHG_MouseRow := _OOHG_MouseRow
   w_OOHG_MouseCol := _OOHG_MouseCol
   SupMin          := 99999999
   oCtrl           := NIL

   FOR i := 1 TO Len( ::oDesignForm:aControls )
      oControl := ::oDesignForm:aControls[i]
      IF oControl:Row == oControl:ContainerRow .AND. oControl:Col == oControl:ContainerCol
         IF w_OOHG_MouseRow >= oControl:Row .AND. w_OOHG_MouseRow <= oControl:Row + oControl:Height .AND. ;
            w_OOHG_MouseCol >= oControl:Col .AND. w_OOHG_MouseCol <= oControl:Col + oControl:Width .AND. ;
            oControl:Type == 'FRAME' .AND. IsWindowVisible( oControl:hWnd )
            IF SupMin > oControl:Height * oControl:Width
               SupMin := oControl:Height * oControl:Width
               oCtrl  := oControl
            ENDIF
         ENDIF
      ELSE
         IF w_OOHG_MouseRow >= oControl:ContainerRow .AND. w_OOHG_MouseRow <= oControl:ContainerRow + oControl:Height .AND. ;
            w_OOHG_MouseCol >= oControl:ContainerCol .AND. w_OOHG_MouseCol <= oControl:ContainerCol+ oControl:Width .AND. ;
            oControl:Type == 'FRAME' .AND. IsWindowVisible( oControl:hWnd )
            IF SupMin > oControl:Height * oControl:Width
               SupMin := oControl:Height * oControl:Width
               oCtrl  := oControl
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN oCtrl

//------------------------------------------------------------------------------
METHOD AddControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oFrame, cName, oNewCtrl := NIL, i, j, oTab, nTabRow, nTabCol, nTabpage
LOCAL nWidth := NIL, nHeight := NIL

   IF ::CurrentControl == 1
      IF ( oFrame := ::CheckForFrame() ) # NIL
         ::DrawOutline( oFrame )
      ENDIF
      RETURN NIL
   ELSEIF ::CurrentControl >= 2 .AND. ::CurrentControl <= IDE_LAST_CTRL
      ::ControlCount[::CurrentControl] ++
      cName := ::ControlPrefix[::CurrentControl] + LTrim( Str( ::ControlCount[::CurrentControl] ) )
      Do While _IsControlDefined( cName, ::oDesignForm:Name )
         ::ControlCount[::CurrentControl] ++
         cName := ::ControlPrefix[::CurrentControl] + LTrim( Str( ::ControlCount[::CurrentControl] ) )
      ENDDO
      ::IniArray( cName, ::ControlType[::CurrentControl] )

      DO CASE
      CASE ::CurrentControl == 2
         // 'BUTTON'
         ::aCaption[::nControlW]   := cName
         ::aAction[::nControlW]    := "MsgInfo( 'Button pressed' )"
         ::aBackColor[::nControlW] := ::cFBackcolor            // TODO:: Check if this is needed

      CASE ::CurrentControl == 3
         // 'CHECKBOX'
         ::aValue[::nControlW] := 'NIL'

      CASE ::CurrentControl == 4
         // 'LIST'

      CASE ::CurrentControl == 5
         // 'COMBO'

      CASE ::CurrentControl == 6
         // 'CHECKBTN'

      CASE ::CurrentControl == 7
         // 'GRID'

      CASE ::CurrentControl == 8
         // 'FRAME'

      CASE ::CurrentControl == 9
         // 'TAB'
         ::aCaption[::nControlW]        := "{ 'Page 1', 'Page 2' }"
         ::aImage[::nControlW]          := "{ '', '' }"
         ::aPageNames[::nControlW]      := "{ '', '' }"
         ::aPageObjs[::nControlW]       := "{ '', '' }"
         ::aPageSubClasses[::nControlW] := "{ '', '' }"

      CASE ::CurrentControl == 10
         // 'IMAGE'

      CASE ::CurrentControl == 11
         // 'ANIMATE'
         nWidth  := 100
         nHeight := 100

      CASE ::CurrentControl == 12
         // 'DATEPICKER'

      CASE ::CurrentControl == 13
         // 'TEXT'
         ::aFocusedPos[::nControlW] := -2

      CASE ::CurrentControl == 14
         // 'EDIT'
         nWidth  := 120
         nHeight := 240
         ::aFocusedPos[::nControlW] := -4

      CASE ::CurrentControl == 15
         // 'LABEL'

      CASE ::CurrentControl == 16
         // 'PLAYER'
         nWidth  := 100
         nHeight := 100

      CASE ::CurrentControl == 17
         // 'PROGRESSBAR'
         nWidth  := NIL
         nHeight := NIL

      CASE ::CurrentControl == 18
         // 'RADIOGROUP'
         ::aItems[::nControlW]       := "{ 'option 1', 'option 2' }"
         ::aSpacing[::nControlW]     := 25
         ::aTransparent[::nControlW] := .F.

      CASE ::CurrentControl == 19
         // 'SLIDER'

      CASE ::CurrentControl == 20
         // 'SPINNER'

      CASE ::CurrentControl == 21
         // 'PICCHECKBUTT'
         ::aPicture[::nControlW] := 'A4'
         nWidth                  := 30
         nHeight                 := 30

      CASE ::CurrentControl == 22
         // 'PICBUTT'
         ::aAction[::nControlW]  := "MsgInfo( 'Pic button pressed.' )"
         nWidth                  := 30
         nHeight                 := 30
         ::aPicture[::nControlW] := 'A4'

      CASE ::CurrentControl == 23
         // 'TIMER'
         nWidth  := 100
         nHeight := 20

      CASE ::CurrentControl == 24
         // 'BROWSE'

      CASE ::CurrentControl == 25
         // 'TREE'

      CASE ::CurrentControl == 26
         // 'IPADDRESS'
         nWidth  := 100
         nHeight := 24

      CASE ::CurrentControl == 27
         // 'MONTHCALENDAR'

      CASE ::CurrentControl == 28
         // 'HYPERLINK'

      CASE ::CurrentControl == 29
         // 'RICHEDIT'
         nWidth  := 120
         nHeight := 240
         ::aFocusedPos[::nControlW] := -4
         ::aMaxLength[::nControlW]  := 0

      CASE ::CurrentControl == 30
         // 'TIMEPICKER'

      CASE ::CurrentControl == 31
         // 'XBROWSE'

      CASE ::CurrentControl == 32
         // 'ACTIVEX'
         nWidth  := 100
         nHeight := 100

      CASE ::CurrentControl == 33
         // 'CHECKLIST'

      CASE ::CurrentControl == 34
         // 'HOTKEYBOX'
         nWidth  := 120
         nHeight := 40

      CASE ::CurrentControl == 35
         // 'PICTURE'

      CASE ::CurrentControl == 36
         // 'PROGRESSMETER'
         ::aValueN[::nControlW] := 30

      CASE ::CurrentControl == 37
         // 'SCROLLBAR'
         nHeight := 100

      CASE ::CurrentControl == 38
         // 'TEXTARRAY'
         nWidth  := 100
         nHeight := 100

      ENDCASE

      oNewCtrl := ::CreateControl( ::CurrentControl, ::nControlW, nWidth, nHeight, NIL )

      IF ::CurrentControl == 13
         // TEXT
         IF ::myIde:nTextBoxHeight > 0
            oNewCtrl:Height := ::myIde:nTextBoxHeight
         ENDIF
      ENDIF

      // TODO: add a tab inside another tab
      IF ::CurrentControl # 9
         // Add to container
         i := 2
         DO WHILE i < ::nControlW
            IF ::aCtrlType[i] == 'TAB'
               IF ( j := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == ::aControlW[i] } ) ) > 0
                  oTab := ::oDesignForm:aControls[j]
                  nTabRow := oTab:Row
                  nTabCol := oTab:Col
                  IF ( oNewCtrl:Row > nTabRow ) .AND. ( oNewCtrl:Row < nTabRow + oTab:Height ) .AND. ;
                     ( oNewCtrl:Col > nTabCol ) .AND. ( oNewCtrl:Col < nTabCol + oTab:Width )
                     nTabpage := oTab:Value
                     oTab:AddControl( oNewCtrl:Name, nTabpage, oNewCtrl:Row - nTabRow, oNewCtrl:Col - nTabCol )
   //                oCN:BackColor := ::myIde:aSystemColorAux         // TODO: Check
                     ::aTabPage[::nControlW, 1] := Lower( oTab:Name )
                     ::aTabPage[::nControlW, 2] := nTabpage
                     ::ReorderTabs()
                   CHideControl( oTab:hWnd )      // TODO: Check
                   CShowControl( oTab:hWnd )
                     EXIT
                  ENDIF
               ENDIF
            ENDIF
            i ++
         ENDDO
      ENDIF

      ::RefreshControlInspector()
      ::Control_Click( 1 )
      ::oCtrlList:SetFocus()
      ::oCtrlList:Value := { ::oCtrlList:ItemCount }
      oNewCtrl:SetFocus()
      ::oDesignForm:SetFocus()
      ::lFSave := .F.
   ENDIF
RETURN oNewCtrl

//------------------------------------------------------------------------------
METHOD CreateControl( nControlType, i, nWidth, nHeight, aCtrls ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, oCtrl, aImages, aItems, nMin, nMax, j, aCaptions, nCnt, oPage, lRed

   cName := ::aControlW[i]
   oCtrl := NIL
   IF ( lRed := ::oDesignForm:SetRedraw() )
      ::oDesignForm:SetRedraw( .F. )
   ENDIF

   DO CASE
   CASE nControlType == 2            // 'BUTTON'
      oCtrl := TButton(): Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  ::aCaption[i], { || ::DrawOutline( oCtrl ) }, nWidth, nHeight, ;
                  NIL, NIL, ::aToolTip[i], { || ::DrawOutline( oCtrl ) }, NIL, ;
                  ::aFlat[i], .F., NIL, NIL, ::aBold[i], ::aFontItalic[i], ;
                  ::aFontUnderline[i], ::aFontStrikeout[i], ::aRTL[i], ;
                  ::aNoPrefix[i], NIL, NIL, NIL, ::aPicture[i], ;
                  ::aNoLoadTrans[i], ::aForceScale[i], .F., ::aJustify[i], ;
                  ::aMultiLine[i], ::aThemed[i], ;
                  IIF( IsValidArray( ::aImageMargin[i] ), &( ::aImageMargin[i] ), NIL ), ;
                  NIL, ::aNo3DColors[i], ::aFit[i], ! ::aDIBSection[i], NIL )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 3            // 'CHECKBOX'
      oCtrl := TCheckBox():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( Empty( ::aCaption[i] ), cName, ::aCaption[i] ), ;
                  &( ::aValue[i] ), NIL, NIL, ::aToolTip[i], ;
                  { || ::DrawOutline( oCtrl ) }, nWidth, nHeight, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, .F., .F., ::aBold[i], ;
                  ::aFontItalic[i], ::aFontUnderline[i], ::aFontStrikeout[i], ;
                  NIL, NIL, NIL, ::aTransparent[i], ::aAutoPlay[i], ::aRTL[i], ;
                  .F., ::a3State[i], ::aLeft[i], ::aThemed[i] )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 4            // 'LIST'
      IF ::aMultiSelect[i]
         oCtrl := TListMulti():Define( cName, ::oDesignForm:Name, ;
                     _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ;
                     IIF( IsValidArray( ::aItems[i] ), ::aItems[i], { cName } ), ;
                     ::aValueN[i], NIL, NIL, ::aToolTip[i], ;
                     { || ::DrawOutline( oCtrl ) }, NIL, ;
                     { || ::DrawOutline( oCtrl ) }, NIL, .F., ;
                     NIL, .F., .F., ::aSort[i], ::aBold[i], ::aFontItalic[i], ;
                     ::aFontUnderline[i], ::aFontStrikeout[i], NIL, NIL, ;
                     ::aRTL[i], .F., NIL, ::aImage[i], ::aTextHeight[i], ;
                     ::aFit[i], ::aNoVScroll[i] )
      ELSE
         oCtrl := TList():Define( cName, ::oDesignForm:Name, ;
                     _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ;
                     IIF( IsValidArray( ::aItems[i] ), ::aItems[i], { cName } ), ;
                     ::aValueN[i], NIL, NIL, ::aToolTip[i], ;
                     { || ::DrawOutline( oCtrl ) }, NIL, ;
                     { || ::DrawOutline( oCtrl ) }, NIL, .F., ;
                     NIL, .F., .F., ::aSort[i], ::aBold[i], ::aFontItalic[i], ;
                     ::aFontUnderline[i], ::aFontStrikeout[i], NIL, NIL, ;
                     ::aRTL[i], .F., NIL, ::aImage[i], ::aTextHeight[i], ;
                     ::aFit[i], ::aNoVScroll[i] )
      ENDIF
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 5            // 'COMBO'
      oCtrl := TCombo():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, ;
                  IIF( IsValidArray( ::aItems[i] ), &( ::aItems[i] ), { cName, 'combo' } ), ;
                  Max( ::aValueN[i], 1 ), NIL, NIL, ::aToolTip[i], ;
                  { || ::DrawOutline( oCtrl ) }, nHeight, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, NIL, NIL, ;
                  .F., .F., ::aSort[i], ::aBold[i], ::aFontItalic[i], ;
                  ::aFontUnderline[i], ::aFontStrikeout[i], NIL, NIL, ;
                  .F., NIL, .F., ::aGripperText[i], ::aImage[i], ::aRTL[i], ;
                  ::aTextHeight[i], .F., ::aFirstItem[i], ::aFit[i], NIL, NIL, ;
                  ::aListWidth[i], NIL, NIL, NIL, NIL, .F., ::aIncremental[i], ;
                  ::aIntegralHeight[i], .F., NIL, NIL, ::aSearchLapse[i] )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 6            // 'CHECKBTN'
      oCtrl := TButtonCheck():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( Empty( ::aCaption[i] ), cName, ::aCaption[i] ), ;
                  ::aValueL[i], NIL, NIL, ::aToolTip[i], ;
                  { || ::DrawOutline( oCtrl ) }, ;
                  nWidth, nHeight, NIL, { || ::DrawOutline( oCtrl ) }, NIL, ;
                  .F., .F., ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], NIL, ::aRTL[i], ::aPicture[i], ;
                  NIL, NIL, ::aNoLoadTrans[i], ::aForceScale[i], ;
                  ::aNo3DColors[i], ::aFit[i], ! ::aDIBSection[i], NIL, ;
                  .F., ::aThemed[i], ::aImageMargin[i], NIL, ::aJustify[i], ;
                  ::aMultiLine[i], ::aFlat[i] )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 7            // 'GRID'
      oCtrl := TGrid():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ;
                  { 'one', 'two' }, { 140, 60 }, { { cName, '' } }, 1, NIL, NIL, ;
                  IIF( Empty( ::aToolTip[i] ), 'Right click on header area to change properties and events or to move/size.', ::aToolTip[i] ), ;
                  { || ::DrawOutline( oCtrl ) }, NIL, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, ::aNoLines[i], NIL, NIL, ;
                  .F., NIL, ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], .F., NIL, NIL, .F., NIL, NIL, NIL, NIL, ;
                  NIL, ::aRTL[i], .F., NIL, .T., NIL, NIL, NIL, NIL, .F., .F., ;
                  .F., ! ::aNoHeaders[i], NIL, NIL, NIL, .F., NIL,  NIL, .F., ;
                  NIL, .T., .T., ::aPLM[i], .T., NIL, ;
                  { || ::DrawOutline( oCtrl ) }, .T., NIL, NIL, NIL, NIL, NIL, ;
                  .F., .F., .F., NIL, NIL, NIL, .F., .F., NIL, .F., .T., ;
                  NIL, .F., .F., .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 8            // 'FRAME'
      oCtrl := TFrame():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseRow, _OOHG_MouseCol, nWidth, nHeight, ;
                  IIF( Empty( ::aCaption[i] ), cName, ::aCaption[i] ), NIL, ;
                  NIL, ::aOpaque[i], ::aBold[i], ::aFontItalic[i], ;
                  ::aFontUnderline[i], ::aFontStrikeout[i], NIL, NIL, ;
                  ::aTransparent[i], ::aRTL[i], .F., .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 9            // 'TAB'
      oCtrl := TTab():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ;
                  {}, {}, NIL, NIL, NIL, ;
                  IIF( Empty( ::aToolTip[i] ), 'To access Properties and Events right click on header area.', ::aToolTip[i] ), ;
                  { || oCtrl:SetFocus(), ::DrawOutline( oCtrl ) }, ;
                  ::aButtons[i], ::aFlat[i], ::aHotTrack[i], ::aVertical[i], ;
                  .F., NIL, ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], {}, ::aRTL[i], ::aVirtual[i], .F., .F., ;
                  ::aMultiLine[i] )
         // Add pages and controls
         aCaptions := &( ::aCaption[i] )
         nCnt      := Len( aCaptions )
         aImages   := &( ::aImage[i] )
         aSize( aImages, nCnt )
         FOR j := 1 TO nCnt
            // DEFINE PAGE
            oPage := _BeginTabPage( aCaptions[j], aImages[j] )
            END PAGE
            IF aCtrls # NIL
               aEval( aCtrls[j], { |c| oPage:AddControl( c, c:Row, c:Col ) } )
            ENDIF
         NEXT j
      END TAB
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      oCtrl:Value := ::aValueN[i]

   CASE nControlType == 10           // 'IMAGE'
      oCtrl := TImage():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( Empty( ::aPicture[i] ), 'ZZZ_AAAOOHG', ::aPicture[i] ), ;
                  nWidth, nHeight, { || ::DrawOutline( oCtrl ) }, NIL, .F., ;
                  IIF( Empty( ::aPicture[i] ), .T., ::aStretch[i] ), ;
                  ::aWhiteBack[i], ::aRTL[i], NIL, NIL, NIL, ! ::aFit[i], ;
                  ::aImageSize[i], ::aToolTip[i], ::aBorder[i], ;
                  ::aClientEdge[i], ::aNoLoadTrans[i], ::aNo3DColors[i], ;
                  ::aDIBSection[i], ::aTransparent[i], NIL, .F. )
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 11           // 'ANIMATE'
      oCtrl := TLabel():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, cName, nWidth, nHeight, ;
                  NIL, NIL, .F., .T., .F., .F., .F., .F., WHITE, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, ::aToolTip[i], ;
                  NIL, .F., .F., .F., .F., .F., .F., ::aCenter[i], ;
                  ::aRTL[i], .F., .F., NIL, .F. )
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }


   CASE nControlType == 12           // 'DATEPICKER'
      oCtrl := TDatePick():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ::aValue[i], ;
                  NIL, NIL, ::aToolTip[i], { || ::DrawOutline( oCtrl ) }, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, ::aShowNone[i], ::aUpDown[i], ;
                  ::aRightAlign[i], NIL, .F., .F., ::aBold[i], ;
                  ::aFontItalic[i], ::aFontUnderline[i], ::aFontStrikeout[i], ;
                  NIL, NIL, ::aRTL[i], .F., ::aBorder[i], NIL, NIL )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF

   CASE nControlType == 13           // 'TEXT'
      oCtrl := DefineTextBox( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ::aValue[i], ;
                  NIL, NIL, ::aToolTip[i], ::aMaxLength[i], ::aUpperCase[i], ;
                  ::aLowerCase[i], ::aPassWord[i], { || oCtrl:ContextMenu := NIL }, ;
                  { || oCtrl:ContextMenu := ::oContextMenu, ::DrawOutline( oCtrl ) }, ;
                  NIL, NIL, ::aRightAlign[i], ;
                  NIL, ::aReadOnly[i], ::aBold[i], ::aFontItalic[i], ;
                  ::aFontUnderline[i], ::aFontStrikeout[i], NIL, NIL, ;
                  NIL, .F., .F., ::aRTL[i], ::aAutoPlay[i], ::aBorder[i], ;
                  NIL, .F., NIL, ::aDate[i], ::aNumeric[i], ::aInputMask[i], ;
                  ::aFields[i], NIL, { || ::DrawOutline( oCtrl ) }, ;
                  ::aImage[i], ::aButtonWidth[i], NIL, NIL, ::aCenterAlign[i], ;
                  ::aDefaultYear[i], NIL, NIL )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 14           // 'EDIT'
      oCtrl := TEdit():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ;
                  IIF( Empty( ::aValue[i] ), cName, ::aValue[i] ), NIL, NIL, ;
                  ::aToolTip[i], ::aMaxLength[i], { || ::DrawOutline( oCtrl ) }, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, .F., .F., NIL, ;
                  .F., .F., ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], NIL, NIL, NIL, ::aNoVScroll[i], ;
                  ::aNoHScroll[i], ::aRTL[i], ::aBorder[i], ::aFocusedPos[i], ;
                  NIL, NIL, .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 15           // 'LABEL'
      oCtrl := TLabel():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( Empty( ::aValue[i] ), cName, ::aValue[i] ), nWidth, nHeight, ;
                  NIL, NIL, ::aBold[i], ::aBorder[i], ::aClientEdge[i], ;
                  ::aNoHScroll[i], ::aNoVScroll[i], ::aTransparent[i], NIL, ;
                  NIL, { || ::DrawOutline( oCtrl ) }, ::aToolTip[i], NIL, .F., ;
                  ::aFontItalic[i], ::aFontUnderline[i], ::aFontStrikeout[i], ::aAutoPlay[i], ;
                  ::aRightAlign[i], ::aCenterAlign[i], ::aRTL[i], ::aWrap[i], ;
                  ::aNoPrefix[i], ::aInputMask[i], .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 16           // 'PLAYER'
      oCtrl := TLabel():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, cName, nWidth, nHeight, NIL, ;
                  NIL, .F., .T., .F., .F., .F., .F., WHITE, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, NIL, .F., .F., .F., ;
                  .F., .F., .F., .F., ::aRTL[i], .F., .F., .F., .F. )
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 17           // 'PROGRESSBAR'
      IF ( j := At( ",", ::aRange[i] ) ) > 0
         nMin := Val( SubStr( ::aRange[i], 1, j - 1 ) )
         nMax := Val( SubStr( ::aRange[i], j + 1 ) )
         IF nMin >= nMax
            nMin := NIL
            nMax := NIL
         ENDIF
      ELSE
         nMin := NIL
         nMax := NIL
      ENDIF
      oCtrl := myTProgressBar():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, nMin, nMax, ;
                  ::aToolTip[i], ::aVertical[i], ::aSmooth[i], NIL, .F., ;
                  ::aValueN[i], NIL, NIL, ::aRTL[i], ::aMarquee[i] )
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnClick  := { || ::DrawOutline( oCtrl ) }
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }
      oCtrl:Value    := ::aName[i]

   CASE nControlType == 18           // 'RADIOGROUP'
      oCtrl := myTRadioGroup():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( IsValidArray( ::aItems[i] ), &( ::aItems[i] ), { cName, 'radiogroup' } ), ;
                  ::aValueN[i], NIL, NIL, ::aToolTip[i], ;
                  { || ::DrawOutline( oCtrl ) }, nWidth, ::aSpacing[i], NIL, ;
                  .F., .F., ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], NIL, NIL, ::aTransparent[i], ;
                  ::aAutoPlay[i], ::aFlat[i], .F., ::aRTL[i], nHeight, ;
                  ::aThemed[i], ::aBackground[i] )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnClick  := { || ::DrawOutline( oCtrl ) }
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 19           // 'SLIDER'
      IF ( j := At( ",", ::aRange[i] ) ) > 0
         nMin := Val( SubStr( ::aRange[i], 1, j - 1 ) )
         nMax := Val( SubStr( ::aRange[i], j + 1 ) )
         IF nMin >= nMax
            nMin := NIL
            nMax := NIL
         ENDIF
      ELSE
         nMin := NIL
         nMax := NIL
      ENDIF
      oCtrl := TSlider():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, nMin, nMax, ;
                  ::aValueN[i], ::aToolTip[i], { || ::DrawOutline( oCtrl ) }, ;
                  ::aVertical[i], ::aNoTicks[i], ::aBoth[i], ::aTop[i], ;
                  ::aLeft[i], NIL, .F., .F., NIL, ::aRTL[i], .F. )
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 20           // 'SPINNER'
      IF ( j := At( ",", ::aRange[i] ) ) > 0
         nMin := Val( SubStr( ::aRange[i], 1, j - 1 ) )
         nMax := Val( SubStr( ::aRange[i], j + 1 ) )
         IF nMin >= nMax
            nMin := NIL
            nMax := NIL
         ENDIF
      ELSE
         nMin := NIL
         nMax := NIL
      ENDIF
      oCtrl := TSpinner():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, ::aValueN[i], NIL, NIL, ;
                  nMin, nMax, ::aToolTip[i], { || ::DrawOutline( oCtrl ) }, ;
                  NIL, { || ::DrawOutline( oCtrl ) }, nHeight, NIL, .F., .F., ;
                  ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], ::aWrap[i], ::aReadOnly[i], ;
                  ::aIncrement[i], NIL, NIL, ::aRTL[i], ::aBorder[i], .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }
      oCtrl:ContextMenu := ::oContextMenu

   CASE nControlType == 21           // 'PICCHECKBUTT'
      oCtrl := TButtonCheck():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, NIL, ::aValueL[i], ;
                  NIL, NIL, ::aToolTip[i], { || ::DrawOutline( oCtrl ) }, ;
                  nWidth, nHeight, NIL, { || ::DrawOutline( oCtrl ) }, NIL, ;
                  .F., .F., .F., .F., .F., .F., NIL, .F., ::aPicture[i], ;
                  NIL, NIL, ::aNoLoadTrans[i], ::aForceScale[i], ;
                  ::aNo3DColors[i], ::aFit[i], ! ::aDIBSection[i], NIL, ;
                  .F., ::aThemed[i], ::aImageMargin[i], NIL, ::aJustify[i], ;
                  .F., ::aFlat[i] )
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 22           // 'PICBUTT'
      oCtrl := TButton(): Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  NIL, { || ::DrawOutline( oCtrl ) }, nWidth, nHeight, ;
                  NIL, NIL, ::aToolTip[i], { || ::DrawOutline( oCtrl ) }, ;
                  NIL, ::aFlat[i], .F., NIL, NIL, NIL, NIL, NIL, NIL, NIL, ;
                  NIL, NIL, NIL, NIL, ::aPicture[i], ::aNoLoadTrans[i], ;
                  ::aForceScale[i], .F., ::aJustify[i], .F., ::aThemed[i], ;
                  IIF( IsValidArray( ::aImageMargin[i] ), &( ::aImageMargin[i] ), NIL ), ;
                  NIL, ::aNo3DColors[i], ::aFit[i], ! ::aDIBSection[i], NIL )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 23           // 'TIMER'
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &cName OF ( ::oDesignForm:Name ) ;
         OBJ oCtrl ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         VALUE cName ;
         BORDER ;
         BACKCOLOR WHITE ;
         ACTION ::DrawOutline( oCtrl )
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 24           // 'BROWSE'
      oCtrl := TGrid():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ;
                  { 'one', 'two' }, { 140, 60 }, { { cName, '' } }, 1, NIL, NIL, ;
                  ::aToolTip[i], { || ::DrawOutline( oCtrl ) }, NIL, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, ::aNoLines[i], NIL, NIL, ;
                  .F., NIL, ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], .F., NIL, NIL, .F., NIL, NIL, NIL, NIL, ;
                  NIL, ::aRTL[i], .F., NIL, .T., NIL, NIL, NIL, NIL, .F., .F., ;
                  .F., ! ::aNoHeaders[i], NIL, NIL, NIL, .F., NIL,  NIL, .F., ;
                  NIL, .T., .T., ::aPLM[i], .T., NIL, ;
                  { || ::DrawOutline( oCtrl ) }, .T., NIL, NIL, NIL, NIL, NIL, ;
                  .F., .F., .F., NIL, NIL, NIL, .F., .F., NIL, .F., .T., ;
                  NIL, .F., .F., .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 25           // 'TREE'
      oCtrl := TTree():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseRow, _OOHG_MouseCol, nWidth, nHeight, ;
                  { || ::DrawOutline( oCtrl ) }, ::aToolTip[i], NIL, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, NIL, .F., NIL, NIL, ;
                  IIF( IsValidArray( ::aNodeImages[i] ), &( ::aNodeImages[i] ), NIL ), ;
                  IIF( IsValidArray( ::aItemImages[i] ), &( ::aItemImages[i] ), NIL ), ;
                  ::aNoRootButton[i], ::aBold[i], ::aFontItalic[i], ;
                  ::aFontUnderline[i], ::aFontStrikeout[i], .F., ::aRTL[i], ;
                  NIL, .F., .F., .F., NIL, NIL, .F., ::aCheckBoxes[i], ;
                  ::aFull[i], ::aNoHScroll[i], ::aNoVScroll[i], ::aHotTrack[i], ;
                  ::aNoLines[i], ::aButtons[i], .F., ::aSingleExpand[i], ::aBorder[i], ;
                  IIF( IsValidArray( ::aSelColor[i] ), &( ::aSelColor[i] ), NIL ), ;
                  NIL, NIL, NIL, ::aIndent[i], ::aSelBold[i], .F., NIL, NIL )

         NODE 'Tree'
         END NODE
         NODE 'Nodes'
         END NODE
      END TREE
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 26           // 'IPADDRESS'
      oCtrl := TLabel():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( Empty( ::aValue[i] ), cName, ::aValue[i] ), ;
                  nWidth, nHeight, NIL, NIL, ::aBold[i], .F., .T., .F., .F., .F., ;
                  WHITE, NIL, { || ::DrawOutline( oCtrl ) }, ::aToolTip[i], ;
                  NIL, .F., ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], .F., .F., .F., ::aRTL[i], .F., .F., ;
                  NIL, .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 27           // 'MONTHCALENDAR'
      oCtrl := TMonthCal():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ::aValue[i], ;
                  NIL, NIL, ::aToolTip[i], ::aNoToday[i], ::aNoTodayCircle[i], ;
                  ::aWeekNumbers[i], { || ::DrawOutline( oCtrl ) }, ;
                  NIL, .F., .F., ::aBold[i], ::aFontItalic[i], ;
                  ::aFontUnderline[i], ::aFontStrikeout[i], ::aRTL[i], .F., ;
                  NIL, NIL, NIL, NIL, NIL, NIL )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      IF IsValidArray( ::aTitleFontColor[i] )
         oCtrl:TitleFontColor := &( ::aTitleFontColor[i] )
      ENDIF
      IF IsValidArray( ::aTitleBackColor[i] )
         oCtrl:TitleBackColor := &( ::aTitleBackColor[i] )
      ENDIF
      IF IsValidArray( ::aTrailingFontColor[i] )
         oCtrl:TrailingFontColor := &( ::aTrailingFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackgroundColor[i] )
         oCtrl:BackgroundColor := &( ::aBackgroundColor[i] )
      ENDIF

   CASE nControlType == 28           // 'HYPERLINK'
      oCtrl := THyperLink():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( Empty( ::aValue[i] ), cName, ::aValue[i] ), ;
                  ::aAddress[i], nWidth, nHeight, NIL, NIL, ::aBold[i], ;
                  ::aBorder[i], ::aClientEdge[i], ::aNoHScroll[i], ;
                  ::aNoVScroll[i], ::aTransparent[i], NIL, NIL, ;
                  IIF( Empty( ::aToolTip[i] ), ::aAddress[i], ::aToolTip[i] ), ;
                  NIL, .F., ::aFontItalic[i], ::aAutoPlay[i], ;
                  ::aHandCursor[i], ::aRTL[i] )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnClick  := { || ::DrawOutline( oCtrl ) }
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 29           // 'RICHEDIT'
      oCtrl := TEditRich():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ;
                  IIF( Empty( ::aValue[i] ), cName, ::aValue[i] ), NIL, NIL, ;
                  ::aToolTip[i], ::aMaxLength[i], { || ::DrawOutline( oCtrl ) }, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, .F., .F., NIL, .F., ;
                  .F., ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], NIL, NIL, ::aRTL[i], .F., NIL, ;
                  NIL, ::aNoHideSel[i], ::aFocusedPos[i], ::aNoVScroll[i], ;
                  ::aNoHScroll[i], NIL, iif( ::aPlainText[i], 1, ;
                  ::aFileType[i] ), NIL, NIL )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 30           // 'TIMEPICKER'
      oCtrl := TTimePick():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ::aValue[i], ;
                  NIL, NIL, IIF( Empty( ::aToolTip[i] ), cName, ::aToolTip[i] ), ;
                  { || ::DrawOutline( oCtrl ) }, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, ::aShowNone[i], ::aUpDown[i], ;
                  ::aRightAlign[i], NIL, .F., .F., ::aBold[i], ::aFontItalic[i], ;
                  ::aFontUnderline[i], ::aFontStrikeout[i], NIL, NIL, ::aRTL[i], ;
                  .F., ::aBorder[i] )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 31           // 'XBROWSE'
      oCtrl := TGrid():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, ;
                  { 'one', 'two' }, { 140, 60 }, { { cName, '' } }, 1, NIL, NIL, ;
                  IIF( Empty( ::aToolTip[i] ), 'Right click on header area to change properties and events or to move/size.', ::aToolTip[i] ), ;
                  { || ::DrawOutline( oCtrl ) }, NIL, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, NIL, ::aNoLines[i], NIL, NIL, ;
                  .F., NIL, ::aBold[i], ::aFontItalic[i], ::aFontUnderline[i], ;
                  ::aFontStrikeout[i], .F., NIL, NIL, .F., NIL, NIL, NIL, NIL, ;
                  NIL, ::aRTL[i], .F., NIL, .T., NIL, NIL, NIL, NIL, .F., .F., ;
                  .F., ! ::aNoHeaders[i], NIL, NIL, NIL, .F., NIL,  NIL, .F., ;
                  NIL, .T., .T., ::aPLM[i], .T., NIL, ;
                  { || ::DrawOutline( oCtrl ) }, .T., NIL, NIL, NIL, NIL, NIL, ;
                  .F., .F., .F., NIL, NIL, NIL, .F., .F., NIL, .F., .T., ;
                  NIL, .F., .F., .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 32           // 'ACTIVEX'
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &cName OF ( ::oDesignForm:Name ) ;
         OBJ oCtrl ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         VALUE cName ;
         BORDER ;
         BACKCOLOR WHITE ;
         ACTION ::DrawOutline( oCtrl )
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 33           // 'CHECKLIST'
      If IsValidArray( ::aImage[i] ) .AND. Len( &( ::aImage[i] ) ) > 0
         aImages := &( ::aImage[i] )
         If IsValidArray( ::aItems[i] )
            aItems := &( ::aItems[i] )
            If aScan( aItems, { |a| ! HB_IsArray( a ) .OR. ;
                                    Len( a ) # 2 .OR. ;
                                    ! ValType( a[1] ) $ "CM" .OR. ;
                                    ValType( a[2] ) # "N" } ) > 0
               aItems := { ::aName[i] }
            EndIf
         Else
            aItems := { ::aName[i] }
         EndIf
      Else
         aImages := Nil
         If IsValidArray( ::aItems[i] )
            aItems := &( ::aItems[i] )
            If aScan( aItems, { |a| ! ValType( a ) $ "CM" } ) > 0
               aItems := { ::aName[i] }
            EndIf
         Else
            aItems := { ::aName[i] }
         EndIf
      EndIf
      oCtrl := TCheckList():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, aItems, ;
                  ::aValueN[i], NIL, NIL, ::aToolTip[i], ;
                  { || ::DrawOutline( oCtrl ) }, { || ::DrawOutline( oCtrl ) }, ;
                  NIL, aImages, ::aJustify[i], .F., NIL, ::aBold[i], ;
                  ::aFontItalic[i], ::aFontUnderline[i], ::aFontStrikeout[i], ;
                  NIL, NIL, ::aRTL[i], .F., .F., .F., ::aSort[i], ::aDescend[i], ;
                  IIF( IsValidArray( ::aSelColor[i] ), &( ::aSelColor[i] ), NIL ), ;
                  .T., { || ::DrawOutline( oCtrl ) } )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 34           // 'HOTKEYBOX'
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &cName OF ( ::oDesignForm:Name ) ;
         OBJ oCtrl ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         VALUE 'ALT + key' ;
         BORDER ;
         BACKCOLOR WHITE ;
         ACTION ::DrawOutline( oCtrl )
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 35           // 'PICTURE'
      oCtrl := TPicture():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( Empty( ::aPicture[i] ), 'ZZZ_AAAOOHG', ::aPicture[i] ), ;
                  nWidth, nHeight, NIL, NIL, ;
                  IIF( Empty( ::aPicture[i] ), .T., ::aStretch[i] ), ;
                  ::aForceScale[i], ::aImageSize[i], ::aBorder[i], ;
                  ::aClientEdge[i], NIL, { || ::DrawOutline( oCtrl ) }, ;
                  ::aToolTip[i], NIL, ::aRTL[i], .F., ::aNoLoadTrans[i], ;
                  ::aNo3DColors[i], ::aDIBSection[i], ::aTransparent[i], NIL, .F. )
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   CASE nControlType == 36           // 'PROGRESSMETER'
      IF ( j := At( ",", ::aRange[i] ) ) > 0
         nMin := Val( SubStr( ::aRange[i], 1, j - 1 ) )
         nMax := Val( SubStr( ::aRange[i], j + 1 ) )
         IF nMin >= nMax
            // Avoid RTE, use defaults
            nMin := NIL
            nMax := NIL
         ENDIF
      ELSE
         nMin := NIL
         nMax := NIL
      ENDIF
      oCtrl := TProgressMeter():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, nMin, nMax, ;
                  ::aValueN[i], ::aToolTip[i], NIL, NIL, ::aBold[i], ;
                  ::aFontItalic[i], ::aFontUnderline[i], ::aFontStrikeout[i], ;
                  NIL, NIL, { || ::DrawOutline( oCtrl ) }, NIL, .F., ::aRTL[i], ;
                  ::aClientEdge[i], .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 37           // 'SCROLLBAR'
      oCtrl := TScrollBar():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, nWidth, nHeight, NIL, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, { || ::DrawOutline( oCtrl ) }, ;
                  { || ::DrawOutline( oCtrl ) }, { || ::DrawOutline( oCtrl ) }, ;
                  { || ::DrawOutline( oCtrl ) }, { || ::DrawOutline( oCtrl ) }, ;
                  { || ::DrawOutline( oCtrl ) }, { || ::DrawOutline( oCtrl ) }, ;
                  { || ::DrawOutline( oCtrl ) }, { || ::DrawOutline( oCtrl ) }, ;
                  NIL, .F., ::aToolTip[i], ::aRTL[i], ;
                  IIF( ::aFlat[i], 0, IIF( ::aVertical[i], 1, NIL ) ), ;
                  .F., NIL, .F., NIL, NIL, .F. )
      oCtrl:OnRClick    := { || ::DrawOutline( oCtrl ) }
      oCtrl:ContextMenu := ::oContextMenu

   CASE nControlType == 38           // 'TEXTARRAY'
      oCtrl := TLabel():Define( cName, ::oDesignForm:Name, ;
                  _OOHG_MouseCol, _OOHG_MouseRow, ;
                  IIF( Empty( ::aValue[i] ), cName, ::aValue[i] ), nWidth, nHeight, ;
                  NIL, NIL, ::aBold[i], ::aBorder[i] .OR. ! ::aClientEdge[i], ;
                  ::aClientEdge[i], NIL, NIL, .F., NIL, NIL, ;
                  { || ::DrawOutline( oCtrl ) }, ::aToolTip[i], NIL, .F., ;
                  ::aFontItalic[i], ::aFontUnderline[i], ::aFontStrikeout[i], ;
                  .F., .F., .F., ::aRTL[i], .F., .F., NIL, .F. )
      IF ! Empty( ::aFontName[i] )
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      IF IsValidArray( ::aFontColor[i] )
         oCtrl:FontColor := &( ::aFontColor[i] )
      ENDIF
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ELSE
         oCtrl:BackColor := WHITE
      ENDIF
      oCtrl:OnRClick := { || ::DrawOutline( oCtrl ) }

   ENDCASE

   IF lRed
      ::oDesignForm:SetRedraw( .T. )
   ENDIF
RETURN oCtrl

//------------------------------------------------------------------------------
METHOD DrawOutline( oControl, lNoRefresh, lNoErase ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL l, nRow, nCol, cLabel, y, x, y1, x1, cTab, bAux, w, h
STATIC lBusy := .F.

   IF lBusy .OR. ::lAddingNewControl
      RETURN NIL
   ENDIF
   lBusy := .T.

   DEFAULT lNoErase TO .F.
   IF ! lNoErase
      EraseWindow( ::oDesignForm:Name )
      ::DrawPoints()
   ENDIF

   IF ( l := aScan( ::aControlW, Lower( oControl:Name ) ) ) > 0
      DEFAULT lNoRefresh TO .F.

      y :=  oControl:ContainerRow
      x :=  oControl:ContainerCol
      IF oControl:Type == 'RADIOGROUP'
         h :=  oControl:GroupHeight
         w :=  oControl:GroupWidth
      ELSE
         h :=  oControl:Height
         w :=  oControl:Width
      ENDIF
      y1 :=  oControl:ContainerRow + h
      x1 :=  oControl:ContainerCol + w

      DRAW RECTANGLE IN WINDOW ( ::oDesignForm:Name ) ;
         AT oControl:ContainerRow - 10, oControl:ContainerCol - 10 ;
         TO oControl:ContainerRow, oControl:ContainerCol ;
         PENCOLOR { 255, 0, 0 } ;
         FILLCOLOR { 255, 0, 0 }

      DRAW RECTANGLE IN WINDOW ( ::oDesignForm:Name ) ;
         AT y1 + 1, x1 + 1 ;
         TO y1 + 6, x1 + 6 ;
         PENCOLOR { 255, 0, 0 } ;
         FILLCOLOR { 255, 0, 0 }

      DRAW LINE IN WINDOW ( ::oDesignForm:Name ) ;
         AT y - 1, x - 1 ;
         TO y - 1 + h + 1, x - 1 ;
         PENCOLOR { 255, 0, 0 }

      DRAW LINE IN WINDOW ( ::oDesignForm:Name ) ;
         AT y - 1, x - 1 ;
         TO y - 1, x - 1 + w + 1 ;
         PENCOLOR { 255, 0, 0 }

      DRAW LINE IN WINDOW ( ::oDesignForm:Name ) ;
         AT y - 1 + h + 1, x - 1 ;
         TO y1, x1 + 1 ;
         PENCOLOR { 255, 0, 0 }

      DRAW LINE IN WINDOW ( ::oDesignForm:Name ) ;
         AT y - 1, x - 1 + w + 1 ;
         TO y1 + 1, x1 ;
         PENCOLOR { 255, 0, 0 }

      ::Form_Main:frame_2:Caption := "Control : "+  ::aName[l]
//      ::Form_Main:frame_2:Refresh()

      nRow    := oControl:Row
      nCol    := oControl:Col
      cLabel  := " r:" + Alltrim( Str( nRow, 4 ) ) + " c:" + AllTrim( Str( nCol, 4 ) ) + " w:" + AllTrim( Str( w, 4 ) ) + " h:" + AllTrim( Str( h, 4 ) )
      ::Form_Main:label_2:Value := cLabel

      ::nHandleA := aScan( ::oDesignForm:aControls, { |c| c:Name == oControl:Name } )

      IF ::aTabPage[l, 2] > 0
         cTab := ::aTabPage[l, 1]
         bAux := ::oDesignForm:&cTab:OnChange
         ::oDesignForm:&cTab:OnChange := NIL
         ::oDesignForm:&cTab:Value := ::aTabPage[l, 2]
         ::oDesignForm:&cTab:OnChange := bAux
      ENDIF

      IF ! lNoRefresh
         ::RefreshControlInspector( oControl:Name )
      ENDIF
   ELSE
      ::nHandleA := 0
      ::nIndexW := 0
      ::Form_Main:label_2:Value:= ' r:    c:    w:    h: '

      IF ! lNoRefresh
         ::RefreshControlInspector()
      ENDIF
      ::oCtrlList:Value := {}
   ENDIF

   lBusy := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD Edit_Properties( aParams ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ia

   IF HB_IsArray( aParams ) .AND. Len( aParams ) > 0 .AND. aParams[1] > 0
      IF ( ia := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == ::oCtrlList:Cell( aParams[1], 6 ) } ) ) > 0
         ::DrawOutline( ::oDesignForm:aControls[ia] )
         ::Properties_Click()
      ENDIF
   ELSE
      ia := ::nHandleA
      IF ia > 0
         ::DrawOutline( ::oDesignForm:aControls[ia] )
         ::Properties_Click()
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ManualMoveSize( nOption ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, nRow, nCol, nWidth, nHeight, cTitle, aLabels
LOCAL ia, aInitValues, aFormats, aResults, lChanged

   IF ::nControlW == 1
      RETURN NIL
   ENDIF
   lChanged := .F.
   IF nOption == 1
      ia := ::nHandleA
      IF ia > 0
         oControl := ::oDesignForm:aControls[ia]
         nRow     := oControl:Row
         nCol     := oControl:Col
         nWidth   := oControl:Width
         nHeight  := oControl:Height
         cTitle   := Lower( oControl:Name ) + " Move/Size properties"

         IF ::CrtlIsOfType( ia, 'RADIOGROUP' )
            aLabels     := { 'Row', 'Col', 'Width' }
            aInitValues := { nRow, nCol, nWidth }
            aFormats    := { '9999', '9999', '9999' }
            aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
            IF aResults[1] == NIL
               ::oDesignForm:SetFocus()
               RETURN NIL
            ENDIF
            IF aResults[1] >= 0
               lChanged := .T.
               oControl:Row := aResults[1]
            ENDIF
            IF aResults[2] >= 0
               lChanged := .T.
               oControl:Col := aResults[2]
            ENDIF
            IF aResults[3] >= 0
               lChanged := .T.
               oControl:Width := aResults[3]
            ENDIF
         ELSE
            aLabels     := { 'Row', 'Col', 'Width', 'Height' }
            aInitValues := { nRow, nCol, nWidth, nHeight }
            aFormats    := { '9999', '9999', '9999', '9999' }
            aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
            IF aResults[1] == NIL
               ::oDesignForm:SetFocus()
               RETURN NIL
            ENDIF
            IF aResults[1] >= 0
               lChanged := .T.
               oControl:Row := aResults[1]
            ENDIF
            IF aResults[2] >= 0
               lChanged := .T.
               oControl:Col := aResults[2]
            ENDIF
            IF ! ::CrtlIsOfType( ia, 'MONTHCALENDAR TIMER' )
               IF aResults[3] >= 0
                  lChanged := .T.
                  oControl:Width  := aResults[3]
               ENDIF
               IF aResults[4] >= 0
                  lChanged := .T.
                  oControl:Height := aResults[4]
               ENDIF
            ENDIF
         ENDIF
         IF lChanged
            ::Snap( oControl )
            ::DrawOutline( oControl )
            ::lFSave := .F.
         ENDIF
      ENDIF
   ELSE
      nRow := ::oDesignForm:Row
      nCol := ::oDesignForm:Col
      IF ::lFClientArea
         nWidth  := ::oDesignForm:ClientWidth
         nHeight := ::oDesignForm:ClientHeight
      ELSE
         nWidth  := ::oDesignForm:Width
         nHeight := ::oDesignForm:Height
      ENDIF
      cTitle  := " Form Move/Size properties"

      aLabels     := { 'Row', 'Col', 'Width', 'Height' }
      aInitValues := { nRow, nCol, nWidth, nHeight }
      aFormats    := { '9999', '9999', '9999', '9999' }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      IF aResults[1] >= 0
         lChanged := .T.
         ::oDesignForm:Row := aResults[1]
      ENDIF
      IF aResults[2] >= 0
         lChanged := .T.
         ::oDesignForm:Col := aResults[2]
      ENDIF
      IF aResults[3] >= 0
         lChanged := .T.
         IF ::lFClientArea
            ::oDesignForm:Width := aResults[3]
         ELSE
            ::oDesignForm:ClientWidth := aResults[3]
         ENDIF
      ENDIF
      IF aResults[4] >= 0
         lChanged := .T.
         IF ::lFClientArea
            ::oDesignForm:ClientHeight := aResults[4]
         ELSE
         ENDIF
      ENDIF
      IF lChanged
         ::lFSave := .F.
      ENDIF
   ENDIF
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD KeyboardMoveSize() CLASS TFormEditor
//------------------------------------------------------------------------------
   IF ::nHandleA == 0
      MsgStop( "You must select a control first.", "OOHG IDE+" )
      RETURN NIL
   ENDIF
   IF ::nControlW == 1
      RETURN NIL
   ENDIF

   ON KEY LEFT       OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "L" )
   ON KEY RIGHT      OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "R" )
   ON KEY UP         OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "U" )
   ON KEY DOWN       OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "D" )
   ON KEY ESCAPE     OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "E" )
	ON KEY CTRL+LEFT  OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "W-" )
   ON KEY CTRL+RIGHT OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "W+" )
   ON KEY CTRL+UP    OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "H-" )
   ON KEY CTRL+DOWN  OF ( ::oDesignForm:Name ) ACTION ::KeyHandler( "H+" )

   IF _IsControlDefined( "Statusbar", ::oDesignForm:Name )
      ::oDesignForm:Statusbar:Release()
   ENDIF
   DEFINE STATUSBAR OF ( ::oDesignForm:Name )
      STATUSITEM ""
   END STATUSBAR
   ::KeyHandler( "" )
RETURN NIL

//------------------------------------------------------------------------------
METHOD KeyHandler( cPar ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ia, nR, nC, oControl, hWnd

   ia := ::nHandleA
   IF ia == 0
      RETURN NIL
   ENDIF

   oControl := ::oDesignForm:aControls[ia]
   hWnd     := ::oDesignForm:hWnd
   nR       := oControl:Row + GetWindowRow( hWnd ) + GetTitleHeight() + ( GetBorderHeight() * 2 ) + 18
   nC       := oControl:Col + GetWindowCol( hWnd ) + GetBorderWidth() + ( oControl:Width / 2 )
   SetCursorPos( nC, nR )

   IF cPar == "E"
      RELEASE KEY LEFT   OF ( ::oDesignForm:Name )
      RELEASE KEY RIGHT  OF ( ::oDesignForm:Name )
      RELEASE KEY UP     OF ( ::oDesignForm:Name )
      RELEASE KEY DOWN   OF ( ::oDesignForm:Name )
      RELEASE KEY ESCAPE OF ( ::oDesignForm:Name )
      ::oDesignForm:StatusBar:Release()
      IF ::lSStat
         ::CreateStatusBar()
      ENDIF
      ::Snap( oControl )
   ELSE
      DO CASE
      CASE cPar == "L"
         oControl:Col := oControl:Col - IIF( ::myIde:lSnap, ::myIde:nPxMove, 1 )
         ::lFSave := .F.
      CASE cPar == "R"
         oControl:Col := oControl:Col + IIF( ::myIde:lSnap, ::myIde:nPxMove, 1 )
         ::lFSave := .F.
      CASE cPar == "U"
         oControl:Row := oControl:Row - IIF( ::myIde:lSnap, ::myIde:nPxMove, 1 )
         ::lFSave := .F.
      CASE cPar == "D"
         oControl:Row := oControl:Row + IIF( ::myIde:lSnap, ::myIde:nPxMove, 1 )
         ::lFSave := .F.
      CASE cPar == "W-"
         oControl:Width := oControl:Width - IIF( ::myIde:lSnap, ::myIde:nPxSize, 1 )
         ::lFSave := .F.
      CASE cPar == "W+"
         oControl:Width := oControl:Width + IIF( ::myIde:lSnap, ::myIde:nPxSize, 1 )
         ::lFSave := .F.
      CASE cPar == "H-"
         oControl:Height := oControl:Height - IIF( ::myIde:lSnap, ::myIde:nPxSize, 1 )
         ::lFSave := .F.
      CASE cPar == "H+"
         oControl:Height := oControl:Height + IIF( ::myIde:lSnap, ::myIde:nPxSize, 1 )
         ::lFSave := .F.
      ENDCASE
      ::oDesignForm:StatusBar:Item( 1, " Row = " + LTrim( Str( oControl:Row ) ) + ;
                                       "  Col = " + LTrim( Str( oControl:Col ) ) + ;
                                       "  Width = " + LTrim( Str( oControl:Width ) ) + ;
                                       "  Height = " + LTrim( Str( oControl:Col ) ) + ;
                                       "  Use Arrow Keys to Move and [Esc] To Exit Keyboard Move/Size" )
   ENDIF
   ::DrawOutline( oControl )
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ia, oControl, nRowAnterior, nColAnterior, nRowActual, nColActual

   ia := ::nHandleA
   IF ia > 0
      ::oDesignForm:SetFocus()
      oControl := ::oDesignForm:aControls[ia]
      nRowAnterior := GetWindowRow( oControl:hWnd )
      nColAnterior := GetWindowCol( oControl:hWnd )
      EraseWindow( ::oDesignForm:Name )
      ::DrawPoints()
      InteractiveMoveHandle( oControl:hWnd )
      nRowActual   := GetWindowRow( oControl:hWnd )
      nColActual   := GetWindowCol( oControl:hWnd )
      oControl:Row := oControl:Row + ( nRowActual - nRowAnterior )
      oControl:Col := oControl:Col + ( nColActual - nColAnterior )
      ::Snap( oControl )
      ::DrawOutline( oControl )
      ::lFSave := .F.
      ::oDesignForm:SetFocus()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SizeControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ia, oControl, nOldHeight, nNewWidth, nNewHeight

   ia := ::nHandleA
   IF ia > 0
      IF ::CrtlIsOfType( ia, 'MONTHCALENDAR TIMER COMBO' )
         RETURN NIL
      ENDIF
      oControl   := ::oDesignForm:aControls[ia]
      nOldHeight := oControl:Height
      InteractiveSizeHandle( oControl:hWnd )
      IF ::CrtlIsOfType( ia, 'RADIOGROUP COMBO' )
         oControl:Width  := GetWindowWidth ( oControl:hWnd )
         oControl:Height := nOldHeight
      ELSE
         // the assignment of ::Width changes ::Height and viceversa, so
         // we need to calculate before assigning
         nNewWidth       := GetWindowWidth( oControl:hWnd )
         nNewHeight      := GetWindowHeight( oControl:hWnd )
         oControl:Width  := nNewWidth
         oControl:Height := nNewHeight
      ENDIF
      ::lFSave := .F.
      ::DrawOutline( oControl )
      ::oDesignForm:SetFocus()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD GlobalVertGapChg() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aItemsSel, nLen, i, cName, oCtrl, aInput, aControls, nRow, nCol, nHeight

   aItemsSel := ::oCtrlList:Value
   nLen := Len( aItemsSel )
   IF nLen > 1
      CursorWait()

      aControls := {}
      FOR i := 1 TO nLen
         cName := ::oCtrlList:Cell( aItemsSel[i], 6 )
         oCtrl := ::oDesignForm:&cName:Object()
         aAdd( aControls, { oCtrl, oCtrl:Row } )
      NEXT
      aSort( aControls, NIL, NIL, { |x, y| x[2] < y[2] } )
      oCtrl  := aControls[1, 1]
      nRow   := oCtrl:Row
      nCol   := oCtrl:Col
      aInput := ::myIde:myInputWindow( 'Global Vert Gap Change', { 'New Gap Value', 'New Col Value' }, { ::myIde:nStdVertGap, nCol }, { '9999', '9999' } )

      IF aInput[1] # NIL
         ::oDesignForm:SetRedraw( .F. )
         ::oCtrlList:SetRedraw( .F. )

         FOR i := 1 TO nLen
            oCtrl     := aControls[i, 1]
            nHeight   := oCtrl:Height
            oCtrl:Row := nRow
            IF aInput[2] # 0
               oCtrl:Col := aInput[2]
            ENDIF
            ::ProcesaControl( oCtrl )
            nRow := nRow + aInput[1] + nHeight
         NEXT

         ::oCtrlList:SetRedraw( .T. )
         ::oCtrlList:Redraw()
         ::oDesignForm:SetRedraw( .T. )
         ::oDesignForm:Redraw()
      ENDIF

      CursorArrow()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ValCellPos() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL wValue, cName, oCtrl

   wValue := This.CellRowIndex
   cName  := ::oCtrlList:Cell( wValue, 6 )
   oCtrl  := ::oDesignForm:&cName:Object()

   DO CASE
   CASE This.CellColIndex == 2
      oCtrl:Row := Val( ::oCtrlList:Cell( wValue, 2 ) )
   CASE This.CellColIndex == 3
      oCtrl:Col := Val( ::oCtrlList:Cell( wValue, 3 ) )
   CASE This.CellColIndex == 4
      oCtrl:Width := Val( ::oCtrlList:Cell( wValue, 4 ) )
   CASE This.CellColIndex == 5
      oCtrl:Height := Val( ::oCtrlList:Cell( wValue, 5 ) )
   ENDCASE

   ::ProcesaControl( oCtrl )
RETURN NIL

//------------------------------------------------------------------------------
METHOD ValGlobalPos( cCual ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aItemsSel, aInput, nActRow, nActCol, nActWid, nActHei, i, nFila, cName
LOCAL oCtrl, nHShift, nVShift, nLen, ia

   aItemsSel := ::oCtrlList:Value
   nLen := Len( aItemsSel )

   IF nLen > 0
      DO CASE
      CASE cCual == 'ROW'
         nActRow := Val( ::oCtrlList:Cell( aItemsSel[1], 2 ) )
         aInput  := ::myIde:myInputWindow( 'Global Row Change', { 'New Row Value' }, { nActRow }, { '9999' } )
      CASE cCual == 'COL'
         nActCol := Val( ::oCtrlList:Cell( aItemsSel[1], 3 ) )
         aInput  := ::myIde:myInputWindow( 'Global Col Change', { 'New Col Value' }, { nActCol }, { '9999' } )
      CASE cCual == 'WID'
         nActWid := Val( ::oCtrlList:Cell( aItemsSel[1], 4 ) )
         aInput  := ::myIde:myInputWindow( 'Global Width Change', { 'New Width Value' }, { nActWid }, { '9999' } )
      CASE cCual == 'HEI'
         nActHei := Val( ::oCtrlList:Cell( aItemsSel[1], 5 ) )
         aInput  := ::myIde:myInputWindow( 'Global Height Change', { 'New Height Value'}, { nActHei }, { '9999' } )
      CASE cCual == 'SHI'
         nHShift := 0
         nVShift := 0
         aInput  := ::myIde:myInputWindow( 'Global Shift', { 'Horizontal Value', 'Vertical Value '}, { nHShift, nVShift }, { '9999', '9999' } )
      ENDCASE

      IF aInput[1] == NIL
         RETURN NIL
      ENDIF

      CursorWait()

      ::oDesignForm:SetRedraw( .F. )
      ::oCtrlList:SetRedraw( .F. )

      FOR i := 1 TO nLen
         nFila := aItemsSel[i]
         cName := ::oCtrlList:Cell( nFila, 6 )
         oCtrl := ::oDesignForm:&cName:Object()

         DO CASE
         CASE cCual == 'ROW'
              oCtrl:Row    := aInput[1]
         CASE cCual == 'COL'
              oCtrl:Col    := aInput[1]
         CASE cCual == 'WID'
              oCtrl:Width  := aInput[1]
         CASE cCual == 'HEI'
              oCtrl:Height := aInput[1]
         CASE cCual == 'SHI'
              oCtrl:Col    := oCtrl:Col + aInput[1]
              oCtrl:Row    := oCtrl:Row + aInput[2]
         ENDCASE

         ::ProcesaControl( oCtrl )
      NEXT

      EraseWindow( ::oDesignForm:Name )
      FOR i := 1 TO nLen
         IF ( ia := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == ::oCtrlList:Cell( aItemsSel[i], 6 ) } ) ) > 0
            ::DrawOutline( ::oDesignForm:aControls[ia], .T., .F. )
         ENDIF
      NEXT i
      ::DrawPoints()
      ::RefreshControlInspector()

      ::oCtrlList:SetRedraw( .T. )
      ::oCtrlList:Redraw()
      ::oDesignForm:SetRedraw( .T. )
      ::oDesignForm:Redraw()

      CursorArrow()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD PrintBrief() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aInput, aItems, i, nRow, nCol, nHeight, nWidth, uValue
LOCAL cName, oCtrl, cRealName, cType, oPrint, ContLin, wpage, lDynamicOnly
LOCAL aOptions := { 'Tab Order', 'Name', 'Type', 'Row', 'Col' }
LOCAL aOptionsN := { 0, 1, 7, 2, 3 }
LOCAL nIndice, cObj, nCantItems

   aItems := {}
   aInput := ::myIde:myInputWindow( 'Print Brief', { 'Filter Dynamic Controls','Print Events', 'Sort By', 'Draw Grid' }, { .T., .T., 1, .F. }, { NIL, NIL, aOptions, NIL } )
   IF aInput[1] == NIL
      RETURN NIL
   ENDIF

   CursorWait()

   DEFAULT aInput[3] TO 1
   lDynamicOnly := aInput[1]

   nCantItems := ::oCtrlList:ItemCount
   FOR i := 1 TO nCantItems
      aAdd( aItems, { ::oCtrlList:Cell( i, 1 ), ::oCtrlList:Cell( i, 2 ), ::oCtrlList:Cell( i, 3), ::oCtrlList:Cell( i, 4), ::oCtrlList:Cell( i, 5), ::oCtrlList:Cell( i, 6 ), ::oCtrlList:Cell( i, 7 ) } )
   NEXT
   nIndice := aOptionsN[aInput[3]]
   IF nIndice > 0
      IF nIndice # 2
         aSort( aItems, NIL, NIL, { |x, y| x[nIndice] < y[nIndice] } )
      ELSE
         aSort( aItems, NIL, NIL, { |x, y| x[2] + x[3] < y[2] + y[3] } )
      ENDIF
   ENDIF

   oPrint := TPrint( "HBPRINTER" )
   oPrint:Init()
   oPrint:SelPrinter( .T., .T., .T. )
   IF oPrint:lPrError
      oPrint:Release()
      CursorArrow()
      MsgStop( 'Error detected while printing.', 'ooHG IDE+' )
      RETURN NIL
   ENDIF
   oPrint:Begindoc()
   oPrint:SetFont( NIL, NIL, NIL, .T. )
   oPrint:SetPreviewSize( 2 )
   oPrint:BeginPage()
   oPrint:SetCPL( 120 )

   ContLin := 1
   wpage   := 1
   oPrint:PrintData( ContLin, 0, 'BRIEF OF ' + IIF( lDynamicOnly, 'DYNAMIC', 'ALL' ) + ' CONTROLS IN FORM: ' + ::oDesignForm:Title + ' OBJ: ' + ::cFObj )
   oPrint:PrintData( ContLin, 143, 'SORTED BY ' + Upper( aOptions[aInput[3]] ) )
   ContLin ++
   oPrint:PrintData( ContLin, 0, 'FILE: ' + ::cForm )
   oPrint:PrintData( ContLin, 143, Dtoc( Date() ) + ' ' + Time() )
   ContLin ++
   oPrint:PrintData( ContLin, 0, Replicate( '-', 162 ) )
   ContLin ++
   oPrint:PrintData( Contlin, 0, 'NAME                    TYPE        ROW    COL   WIDTH HEIGHT  VALUE                 OBJ                  NUM  DATE  RONLY  UPPER  RALIGN  MAXLEN  IMASK           ' )
   /*
   oPrint:Printdata( Contlin, 0, '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012' )
   ContLin ++
   oPrint:Printdata( Contlin, 0, '0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6  ' )
   ContLin ++
   */
   ContLin ++
   oPrint:PrintData( ContLin, 0, Replicate( '-', 162 ) )
   IF aInput[4]
      ContLin ++
   ENDIF
   FOR i := 1 TO nCantItems
      cRealName := aItems[i, 1]
      cName     := aItems[i, 6]
      cType     := aItems[i, 7]
      oCtrl     := ::oDesignForm:&cName:Object()
      nRow      := oCtrl:Row
      nCol      := oCtrl:Col
      nWidth    := oCtrl:Width
      nHeight   := oCtrl:Height
      uValue    := oCtrl:Value
      nIndice   := aScan( ::aControlW, cName )
      cObj      := ::aCObj[nIndice]

      IF Upper( cType ) $ "LABEL FRAME TIMER IMAGE PICTURE ACTIVEX PROGRESSBAR PROGRESSMETER ANIMATE" .AND. lDynamicOnly
      ELSE
         IF ! aInput[4]
            ContLin ++
         ENDIF
         oPrint:PrintData( ContLin, 000, Left( cRealName, 23 ) )
         oPrint:PrintData( ContLin, 024, Left( cType, 11 ) )
         oPrint:PrintData( ContLin, 036, StrZero( nRow, 3 ) )
         oPrint:PrintData( ContLin, 043, StrZero( nCol, 3 ) )
         oPrint:PrintData( ContLin, 050, StrZero( nWidth, 3 ) )
         oPrint:PrintData( ContLin, 056, StrZero( nHeight, 3 ) )
         oPrint:PrintData( ContLin, 063, Left( CStr( uValue ), 20 ) )
         oPrint:PrintData( ContLin, 085, Left( CStr( cObj ), 20 ) )
         oPrint:PrintData( ContLin, 108, IIF( ::aNumeric[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 113, IIF( ::aDate[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 120, IIF( ::aReadOnly[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 127, IIF( ::aUpperCase[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 134, IIF( ::aRightAlign[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 142, Transform( ::aMaxLength[nIndice], '999' ) )
         oPrint:PrintData( ContLin, 148, AllTrim( ::aInputMask[nIndice] ) )
         IF ! Empty( ::aField[nIndice] )
            oPrint:PrintData( ++ ContLin, 005, 'FIELD      : ' + AllTrim( ::aField[nIndice] ) )
         ENDIF
         IF ! Empty( ::aValid[nIndice] )
            oPrint:PrintData( ++ ContLin, 005, 'VALID      : ' + AllTrim( ::aValid[nIndice] ) )
         ENDIF
         IF ! Empty( ::aWhen[nIndice] )
            oPrint:PrintData( ++ Contlin, 005, 'WHEN       : ' + AllTrim( ::aWhen[nIndice] ) )
         ENDIF
         IF ContLin > 40
            ContLin ++
            oPrint:PrintData( ++ ContLin, 0, 'Page... ' + Ltrim( Str( wpage, 3 ) ) )
            oPrint:PrintData( ++ ContLin, 0,  Replicate( '-', 162 ) )
            oPrint:EndPage()
            oPrint:BeginPage()
            ContLin := 1
            wpage ++
         ENDIF
         IF aInput[2]
            IF ! Empty( ::aAction[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ACTION     : ' + AllTrim( CStr( ::aAction[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aAction2[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ACTION2    : ' + AllTrim( CStr( ::aAction2[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnDblClick[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONDBLCLICK : ' + AllTrim( CStr( ::aOnDblClick[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnChange[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONCHANGE   : ' + AllTrim( CStr( ::aOnChange[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnGotFocus[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONGOTFOCUS : ' + AllTrim( CStr( ::aOnGotFocus[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnLostFocus[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONLOSTFOCUS: ' + AllTrim( CStr( ::aOnLostFocus[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aonenter[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONENTER    : ' + AllTrim( CStr( ::aonenter[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnDisplayChange[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONDISP.CHG.: ' + AllTrim( CStr( ::aOnDisplayChange[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnHeadClick[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONHEADCLICK: ' + AllTrim( CStr( ::aOnHeadClick[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnEditCell[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONEDITCELL : ' + AllTrim( CStr( ::aOnEditCell[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnAppend[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONAPPEND   : ' + AllTrim( CStr( ::aOnAppend[nIndice] ) ) )
            ENDIF
            // TODO: Check if there are missing events
         ENDIF
         IF aInput[4]
            oPrint:PrintLine( ++ Contlin, 0, ContLin, 162 )
         ENDIF
      ENDIF
   NEXT

   ContLin ++
   oPrint:PrintData( ++ ContLin, 0, 'Page... ' + LTrim( Str( wpage, 3 ) ) )
   oPrint:PrintData( ++ ContLin, 0, Replicate( '-', 162 ) )
   oPrint:PrintData( ++ ContLin, 0, 'End print' )
   oPrint:EndPage()
   oPrint:EndDoc()

   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD ShowFormData() CLASS TFormEditor
//------------------------------------------------------------------------------
   ::Form_Main:label_1:Value := " r:" + AllTrim( Str( ::oDesignForm:Row, 4 ) ) + ;
                                " c:" + AllTrim( Str( ::oDesignForm:Col, 4 ) ) + ;
                                " w:" + AllTrim( Str( ::oDesignForm:Width, 4 ) ) + ;
                                " h:" + Alltrim( Str( ::oDesignForm:Height, 4 ) )
   ::DrawPoints()
RETURN NIL

//------------------------------------------------------------------------------
METHOD SelectControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aVal, nLen, i, ia

/*
   nFocus := GetFocus()
   IF nFocus > 0
      IF nFocus == ::oCtrlList:hWnd
      ENDIF
   ENDIF
*/
   EraseWindow( ::oDesignForm:Name )
   aVal := ::oCtrlList:Value
   IF ( nLen := Len( aVal ) ) > 0
      FOR i := 1 TO nLen
         IF ( ia := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == ::oCtrlList:Cell( aVal[i], 6 ) } ) ) > 0
            ::DrawOutline( ::oDesignForm:aControls[ia], .T., .T. )
         ENDIF
      NEXT i
   ENDIF
   ::DrawPoints()
RETURN NIL

//------------------------------------------------------------------------------
METHOD LoadControls() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, lItem, cType, cLine, nAt, nWidth, cAction, cIcon, lFlat, lRaised, lAmPm
LOCAL cToolTip, lCenter, lLeft, lRight, cCaption, nProcess

   ::oDesignForm:SetRedraw( .F. )

   // Load statusbar data
   FOR i := 1 TO Len( ::aLine )
      IF At( 'DEFINE STATUSBAR', Upper( ::aLine[i] ) ) # 0
         ::lSStat := .T.
         ::Form_Main:butt_status:Value := .T.
         ::cvcControls:Control_Stabusbar:Visible := .T.

         ::cSCObj         := ::ReadStringData( 'DEFINE STATUSBAR', 'OBJ', '' )
         ::lSTop          := ( ::ReadLogicalData( 'DEFINE STATUSBAR', 'TOP', "F" ) == "T" )
         ::lSNoAutoAdjust := ( ::ReadLogicalData( 'DEFINE STATUSBAR', 'NOAUTOADJUST', "F" ) == "T" )
         ::cSSubClass     := ::ReadStringData( 'DEFINE STATUSBAR', 'SUBCLASS', '' )
         ::cSFontName     := ::Clean( ::ReadStringData( 'DEFINE STATUSBAR', 'FONT', '' ) )
         ::nSFontSize     := Val( ::ReadStringData( 'DEFINE STATUSBAR', 'SIZE', '0' ) )
         ::lSBold         := ( ::ReadLogicalData( 'DEFINE STATUSBAR', 'BOLD', 'F' ) == "T" )
         ::lSItalic       := ( ::ReadLogicalData( 'DEFINE STATUSBAR', 'ITALIC', 'F' ) == "T" )
         ::lSUnderline    := ( ::ReadLogicalData( 'DEFINE STATUSBAR', 'UNDERLINE', 'F' ) == "T" )
         ::lSStrikeout    := ( ::ReadLogicalData( 'DEFINE STATUSBAR', 'STRIKEOUT', 'F' ) == "T" )
         lItem            := .F.
         ::cSCaption      := "{ "
         ::cSWidth        := "{ "
         ::cSAction       := "{ "
         ::cSIcon         := "{ "
         ::cSStyle        := "{ "
         ::cSToolTip      := "{ "
         ::cSAlign        := "{ "
         ::lSKeyboard     := .F.
         ::nSKWidth       := 0
         ::cSKAction      := ''
         ::cSKToolTip     := ''
         ::cSKImage       := ''
         ::cSKStyle       := ''
         ::cSKAlign       := ''
         ::lSDate         := .F.
         ::nSDWidth       := 0
         ::cSDAction      := ''
         ::cSDToolTip     := ''
         ::cSDStyle       := ''
         ::cSDAlign       := ''
         ::lSTime         := .F.
         ::nSCWidth       := 0
         ::cSCAction      := ''
         ::cSCToolTip     := ''
         ::lSCAmPm        := .F.
         ::cSCImage       := ''
         ::cSCStyle       := ''
         ::cSCAlign       := ''

         i ++
         DO WHILE i <= Len( ::aLine )
            cLine := Upper( ::aLine[i] )
            IF At( 'END STATUSBAR', cLine ) # 0
               EXIT
            ENDIF

            IF ( nAt := At( 'STATUSITEM ', cLine ) ) # 0
               lItem := .T.
               nProcess := 1
               cCaption := RTrim( SubStr( ::aLine[i], nAt + 11 ) )
            ELSEIF ( nAt := At( 'KEYBOARD ', cLine ) ) # 0 .AND. ! ::lSKeyboard
               ::lSKeyboard := .T.
               nProcess := 2
               cCaption := RTrim( SubStr( ::aLine[i], nAt + 9 ) )
            ELSEIF ( nAt := At( 'DATE ', cLine ) ) # 0 .AND. ! ::lSDate
               ::lSDate := .T.
               nProcess := 3
               cCaption := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
            ELSEIF ( nAt := At( 'CLOCK ', cLine ) ) # 0 .AND. ! ::lSTime
               ::lSTime := .T.
               nProcess := 4
               cCaption := RTrim( SubStr( ::aLine[i], nAt + 6 ) )
            ELSE
               nProcess := 0
            ENDIF

            IF nProcess > 0
               nWidth   := 0
               cAction  := ''
               cIcon    := ''
               lFlat    := .F.
               lRaised  := .F.
               cToolTip := ''
               lCenter  := .F.
               lLeft    := .F.
               lRight   := .F.
               lAmPm    := .F.

               IF Right( cCaption, 1 ) == ";"
                  cCaption := AllTrim( SubStr( cCaption, 1, Len( cCaption ) - 1 ) )

                  i ++
                  DO WHILE i <= Len( ::aLine )
                     cLine := Upper( ::aLine[i] )
                     IF At( 'END STATUSBAR', cLine ) # 0 .OR. At( 'STATUSITEM ', cLine ) # 0 .OR. At( 'KEYBOARD ', cLine ) # 0 .OR. At( 'DATE ', cLine ) # 0 .OR. At( 'CLOCK ', cLine ) # 0
                        EXIT
                     ELSEIF ( nAt := At( 'WIDTH ', cLine ) ) # 0
                        nWidth := RTrim( SubStr( ::aLine[i], nAt + 6 ) )
                        i ++
                        IF Right( nWidth, 1 ) == ";"
                           nWidth := Val( AllTrim( SubStr( nWidth, 1, Len( nWidth ) - 1 ) ) )
                        ELSE
                           nWidth := Val( AllTrim( nWidth ) )
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'ACTION ', cLine ) ) # 0
                        cAction := RTrim( SubStr( ::aLine[i], nAt + 7 ) )
                        i ++
                        IF Right( cAction, 1 ) == ";"
                           cAction := AllTrim( SubStr( cAction, 1, Len( cAction ) - 1 ) )
                        ELSE
                           cAction := AllTrim( cAction )
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'ICON ', cLine ) ) # 0
                        cIcon := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
                        i ++
                        IF Right( cIcon, 1 ) == ";"
                           cIcon := AllTrim( SubStr( cIcon, 1, Len( cIcon ) - 1 ) )
                        ELSE
                           cIcon := AllTrim( cIcon )
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'AMPM ', cLine ) ) # 0
                        lAmPm := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
                        i ++
                        IF Right( lAmPm, 1 ) == ";"
                           lAmPm := AllTrim( SubStr( lAmPm, 1, Len( lAmPm ) - 1 ) )
                           IF Empty( lAmPm )
                              lAmPm := .T.
                           ELSE
                              lAmPm := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lAmPm := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'FLAT ', cLine ) ) # 0
                        lFlat := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
                        i ++
                        IF Right( lFlat, 1 ) == ";"
                           lFlat := AllTrim( SubStr( lFlat, 1, Len( lFlat ) - 1 ) )
                           IF Empty( lFlat )
                              lFlat := .T.
                           ELSE
                              lFlat := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lFlat := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'RAISED ', cLine ) ) # 0
                        lRaised := RTrim( SubStr( ::aLine[i], nAt + 7 ) )
                        i ++
                        IF Right( lRaised, 1 ) == ";"
                           lRaised := AllTrim( SubStr( lRaised, 1, Len( lRaised ) - 1 ) )
                           IF Empty( lRaised )
                              lRaised := .T.
                           ELSE
                              lRaised := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lRaised := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'TOOLTIP ', cLine ) ) # 0
                        cToolTip := RTrim( SubStr( ::aLine[i], nAt + 8 ) )
                        i ++
                        IF Right( cToolTip, 1 ) == ";"
                           cToolTip := AllTrim( SubStr( cToolTip, 1, Len( cToolTip ) - 1 ) )
                        ELSE
                           cToolTip := AllTrim( cToolTip )
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'CENTER ', cLine ) ) # 0
                        lCenter := RTrim( SubStr( ::aLine[i], nAt + 7 ) )
                        i ++
                        IF Right( lCenter, 1 ) == ";"
                           lCenter := AllTrim( SubStr( lCenter, 1, Len( lCenter ) - 1 ) )
                           IF Empty( lCenter )
                              lCenter := .T.
                           ELSE
                              lCenter := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lCenter := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'LEFT ', cLine ) ) # 0
                        lLeft := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
                        i ++
                        IF Right( lLeft, 1 ) == ";"
                           lLeft := AllTrim( SubStr( lLeft, 1, Len( lLeft ) - 1 ) )
                           IF Empty( lLeft )
                              lLeft := .T.
                           ELSE
                              lLeft := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lLeft := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'RIGHT ', cLine ) ) # 0
                        lRight := RTrim( SubStr( ::aLine[i], nAt + 6 ) )
                        i ++
                        IF Right( lRight, 1 ) == ";"
                           lRight := AllTrim( SubStr( lRight, 1, Len( lRight ) - 1 ) )
                           IF Empty( lRight )
                              lRight := .T.
                           ELSE
                              lRight := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lRight := .T.
                           EXIT
                        ENDIF
                     ELSE
                        i ++
                        EXIT
                     ENDIF
                  ENDDO
               ELSE
                  cCaption := AllTrim( cCaption )
                  i ++
               ENDIF

               IF nProcess == 1          // STATUSITEM
                  ::cSCaption += IIF( Empty( cCaption ), "' '", cCaption ) + ", "
                  ::cSWidth   += IIF( nWidth > 0, LTrim( Str( nWidth ) ), "0" ) + ", "
                  ::cSAction  += IIF( Empty( cAction ), "''", StrToStr( cAction ) ) + ", "
                  ::cSIcon    += IIF( Empty( cIcon ), "''", cIcon ) + ", "
                  ::cSStyle   += IIF( lFlat, "'FLAT'", IIF( lRaised, "'RAISED'", "''" ) ) + ", "
                  ::cSToolTip += IIF( Empty( cToolTip ), "''", cToolTip ) + ", "
                  ::cSAlign   += IIF( lLeft, "'LEFT'", IIF( lRight, "'RIGHT'", IIF( lCenter, "'CENTER'", "''" ) ) ) + ", "
               ELSEIF nProcess == 2      // KEYBOARD
                  ::nSKWidth   := nWidth
                  ::cSKAction  := ::Clean( cAction )
                  ::cSKToolTip := ::Clean( cToolTip )
                  ::cSKImage   := ::Clean( cIcon )
                  ::cSKStyle   := IIF( lFlat, 'FLAT', IIF( lRaised, 'RAISED', '' ) )
                  ::cSKAlign   := IIF( lLeft, 'LEFT', IIF( lRight, 'RIGHT', IIF( lCenter, 'CENTER', '' ) ) )
               ELSEIF nProcess == 3      // DATE
                  ::nSDWidth   := nWidth
                  ::cSDAction  := ::Clean( cAction )
                  ::cSDToolTip := ::Clean( cToolTip )
                  ::cSDStyle   := IIF( lFlat, 'FLAT', IIF( lRaised, 'RAISED', '' ) )
                  ::cSDAlign   := IIF( lLeft, 'LEFT', IIF( lRight, 'RIGHT', IIF( lCenter, 'CENTER', '' ) ) )
               ELSE                      // CLOCK
                  ::nSCWidth   := nWidth
                  ::cSCAction  := ::Clean( cAction )
                  ::cSCToolTip := ::Clean( cToolTip )
                  ::lSCAmPm    := lAmPm
                  ::cSCImage   := ::Clean( cIcon )
                  ::cSCStyle   := IIF( lFlat, 'FLAT', IIF( lRaised, 'RAISED', '' ) )
                  ::cSCAlign   := IIF( lLeft, 'LEFT', IIF( lRight, 'RIGHT', IIF( lCenter, 'CENTER', '' ) ) )
               ENDIF
            ELSE
               i ++
            ENDIF
         ENDDO

         IF ! lItem
            ::cSCaption += "' ' }"
            ::cSWidth   += "'' }"
            ::cSAction  += "'' }"
            ::cSIcon    += "'' }"
            ::cSStyle   += "'' }"
            ::cSToolTip += "'' }"
            ::cSAlign   += "'' }"
         ELSE
            ::cSCaption := SubStr( ::cSCaption, 1, Len( ::cSCaption ) - 2 ) + " }"
            ::cSWidth   := SubStr( ::cSWidth, 1, Len( ::cSWidth ) - 2 ) + " }"
            ::cSAction  := SubStr( ::cSAction, 1, Len( ::cSAction ) - 2 ) + " }"
            ::cSIcon    := SubStr( ::cSIcon, 1, Len( ::cSIcon ) - 2 ) + " }"
            ::cSStyle   := SubStr( ::cSStyle, 1, Len( ::cSStyle ) - 2 ) + " }"
            ::cSToolTip := SubStr( ::cSToolTip, 1, Len( ::cSToolTip ) - 2 ) + " }"
            ::cSAlign   := SubStr( ::cSAlign, 1, Len( ::cSAlign ) - 2 ) + " }"
         ENDIF

         EXIT
      ELSE
         ::lSStat := .F.

         ::Form_Main:butt_status:Value := .F.
         ::cvcControls:Control_Stabusbar:Visible := .F.
      ENDIF
   NEXT i

   // Controls
   ::swTab := .F.

   FOR i := 1 TO ::nControlW
      IF i == 1
        cType := 'FORM'
      ELSE
        cType := ::ReadCtrlType( i )
      ENDIF

      /*
         For each new control you must add a CASE for calling the method that
         loads the control's properties and events from the fmg.
      */
      DO CASE
      CASE cType == 'DEFINE'
         ::aCtrlType[i] := 'STATUSBAR'
      CASE cType == 'FORM'
         ::pForm( i )
      CASE cType == 'BUTTON'
         ::pButton( i )
      CASE cType == "CHECKBOX"
         ::pCheckBox( i )
      CASE cType == "LISTBOX"
         ::pListBox( i )
      CASE cType == 'COMBOBOX'
         ::pComboBox( i )
      CASE cType == 'CHECKBTN'
         ::pCheckBtn( i )
      CASE cType == 'PICCHECKBUTT'
         ::pPicCheckButt( i )
      CASE cType == "PICBUTT"
         ::pPicButt( i )
      CASE cType == "IMAGE"
         ::pImage( i )
      CASE cType == "ANIMATEBOX"
         ::pAnimateBox( i )
      CASE cType == "DATEPICKER"
         ::pDatePicker( i )
      CASE cType == 'GRID'
         ::pGrid( i )
      CASE cType == 'BROWSE'
         ::pBrowse( i )
      CASE cType == 'FRAME'
         ::pFrame( i )
      CASE cType == "TEXTBOX"
         ::pTextBox( i )
      CASE cType == "EDITBOX"
         ::pEditBox( i )
      CASE cType == 'RADIOGROUP'
         ::pRadioGroup( i )
      CASE cType == "PROGRESSBAR"
         ::pProgressBar( i )
      CASE cType == 'SLIDER'
         ::pSlider( i )
      CASE cType == 'SPINNER'
         ::pSpinner( i )
      CASE cType == "PLAYER"
         ::pPlayer( i )
      CASE cType == 'LABEL'
         ::pLabel( i )
      CASE cType == "TIMER"
         ::pTimer( i )
      CASE cType == 'IPADDRESS'
         ::pIPAddress( i )
      CASE cType == 'MONTHCALENDAR'
         ::pMonthCal( i )
      CASE cType == 'HYPERLINK'
         ::pHypLink( i )
      CASE cType == 'TREE'
         ::pTree( i )
      CASE cType == 'RICHEDITBOX'
         ::pRichedit( i )
      CASE cType == 'TAB'
         ::swTab := .T.
         ::pTab( i )
      CASE cType == "TIMEPICKER"
         ::pTimePicker( i )
      CASE cType == 'XBROWSE'
         ::pXBrowse( i )
      CASE cType == 'ACTIVEX'
         ::pActiveX( i )
      CASE cType == 'CHECKLIST'
         ::pCheckList( i )
      CASE cType == 'HOTKEYBOX'
         ::pHotKeyBox( i )
      CASE cType == 'PICTURE'
         ::pPicture( i )
      CASE cType == 'PROGRESSMETER'
         ::pProgressMeter( i )
      CASE cType == 'SCROLLBAR'
         ::pScrollBar( i )
      CASE cType == 'TEXTARRAY'
         ::pTextArray( i )
      OTHERWISE
         ::pLabel( i )
      ENDCASE
   NEXT i

   // Toolbar
   ::myTbEditor:CreateToolbarFromFile()

   // Main menu
   TMyMenuEditor():CreateMenuFromFile( Self, 1 )

   // Context menu
   TMyMenuEditor():CreateMenuFromFile( Self, 2 )

   // Notify menu
   TMyMenuEditor():CreateMenuFromFile( Self, 3 )

   // Show statusbar
   IF ::lSStat
      ::CreateStatusBar()
   ENDIF

   IF ::nControlW == 1
      ::nIndexW := 0
      ::nHandleA := 0
   ENDIF

   ::oDesignForm:SetRedraw( .T. )
RETURN NIL

//------------------------------------------------------------------------------
METHOD Control_Click( wpar ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cControl, i
STATIC lIdle := .T.

   IF lIdle
      lIdle := .F.
      FOR i := 1 TO IDE_LAST_CTRL
         cControl := 'Control_' + StrZero( i, 2, 0 )
         ::cvcControls:&cControl:Value := .F.
      NEXT i
      ::CurrentControl := wpar
      cControl := 'Control_' + StrZero( wpar, 2, 0 )
      ::cvcControls:&cControl:Value := .T.
      IF wpar > 1 .AND. wpar <= IDE_LAST_CTRL
         EraseWindow( ::oDesignForm:Name )
         ::DrawPoints()
         ::oCtrlList:Value := {}
         ::lAddingNewControl := .T.
      ELSE
         ::lAddingNewControl := .F.
      ENDIF
      lIdle := .T.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ReadCtrlType( cvc ) CLASS TFormEditor
//------------------------------------------------------------------------------
Local q, r, s, cRegresa := '', zi, zl, cName

   cName := Upper( ::aControlW[cvc] )
   zi    := IIF( cvc > 0, ::aSpeed[cvc], 1)
   zl    := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )

   FOR q := zi TO zl
      s := At( ' ' + cName + ' ', Upper( ::aLine[q] ) )
      If s > 0
         FOR r := 1 TO s
            IF Asc( SubStr( ::aLine[q], r, 1 ) ) >= 65
               cRegresa := AllTrim( SubStr( ::aLine[q], r, s - r ) )
               EXIT
            ENDIF
         NEXT r
         EXIT
      ENDIF
   NEXT q

   IF Upper( cRegresa ) == 'CHECKBUTTON'
      IF ::ReadLogicalData( cName, 'CAPTION', 'F' ) == 'T'
         cRegresa := 'CHECKBTN'
      ELSE
         cRegresa := 'PICCHECKBUTT'
      ENDIF
   ENDIF
   IF Upper( cRegresa ) == 'BUTTON'
      IF ::ReadLogicalData( cName, 'CAPTION', 'F' ) == 'T'
         cRegresa := 'BUTTON'
      ELSE
         cRegresa := 'PICBUTT'
      ENDIF
   ENDIF
RETURN cRegresa

//------------------------------------------------------------------------------
METHOD ReadOopData( cName, cPropmet, cDefault ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, zi, zl, cvc, nPos, cValue

   cvc := aScan( ::aControlW, cName )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( ::cFName ) + '.' + Upper( cName ) + '.' + Upper( cPropmet ), Upper( ::aLine[i] ) ) > 0
         nPos := RAt( '=', ::aLine[i] ) + 1
         IF nPos > 1
            cValue := AllTrim( SubStr( ::aLine[i], nPos ) )
            IF Empty( cValue )
               RETURN cDefault
            ELSEIF Upper( cValue ) == 'NIL'
               RETURN 'NIL'
            ELSE
               RETURN cValue
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD ReadStringData( cName, cProp, cDefault ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, sw := 0, zi, cvc, zl, nPos, cFValue

   cvc := aScan( ::aControlW, cName )
   zi  := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl  := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      // Finds the control inside the fmg, and searchs for the property from there on
      IF At( ' ' + Upper( cName ) + ' ' , Upper( ::aLine[i] ) ) # 0 .AND. sw == 0  
         sw := 1
      ELSE
         IF sw == 1
            IF Len( RTrim( ::aLine[i] ) ) == 0
               RETURN cDefault
            ENDIF
            nPos := At( ' ' + Upper( cProp ) + ' ', Upper( ::aLine[i] ) )
            IF nPos > 0
               // cProp must be the first word of the line
               IF Empty( Left( ::aLine[i], nPos ) ) .OR. AllTrim( Left( ::aLine[i], nPos ) ) == "*****"
                  cFValue := SubStr( ::aLine[i], nPos + Len( cProp ) + 2 )
                  cFValue := RTrim( cFValue)
                  IF Right( cFValue, 1 ) == ";"
                     cFValue := SubStr( cFValue, 1, Len( cFValue ) - 1 )
                  ENDIF
                  cFValue := AllTrim( cFValue )
                  IF Len( cFValue ) == 0
                     RETURN cDefault
                  ELSEIF Upper( cFValue ) == 'NIL'
                     RETURN 'NIL'
                  ELSE
                     RETURN cFValue
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD ReadLogicalData( cName, cProp, cDefault ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, sw := 0, zi, cvc, zl, nPos

   IF ! cDefault $ "TF"
      cDefault := "F"
   ENDIF

   cvc := aScan( ::aControlW, cName )
   zi  := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl  := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ', Upper( ::aLine[i] ) ) # 0 .AND. sw == 0
         sw := 1
      ELSE
         IF sw == 1
            IF Len( RTrim( ::aLine[i] ) ) == 0
               RETURN cDefault
            ENDIF
            IF ( nPos := At( ' ' + Upper( cProp ) + ' ', Upper( ::aLine[i] ) ) ) > 0
               // cProp must be the first word of the line
               IF Empty( Left( ::aLine[i], nPos ) )
                  RETURN 'T'
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD ReadCtrlRow( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, nPos, nRow := '0', zi, zl, cvc

   cvc := aScan( ::aControlW, cName )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cname ) + ' ', Upper( ::aLine[i] ) ) # 0
         nPos := At( ",", ::aLine[i] )
         nRow := Left( ::aLine[i], nPos - 1 )
         nRow := StrTran( nRow, "@", "" )
         EXIT
      ENDIF
   NEXT i
RETURN nRow

//------------------------------------------------------------------------------
METHOD ReadFormRow( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, nPos1, nPos2, nRow := '0', zi, zl, cvc

   cvc := aScan( ::aControlW, cName )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( 'WINDOW' ) + ' ', Upper( ::aLine[i] ) ) # 0
         nPos1 := At( 'AT', Upper(::aLine[i + 1] ) )
         nPos2 := At( ",", ::aLine[i + 1])
         nRow := SubStr( ::aLine[i + 1], nPos1 + 3, Len( ::aLine[i + 1] ) - nPos2 )
         EXIT
      ENDIF
   NEXT i
RETURN nRow

//------------------------------------------------------------------------------
METHOD ReadCtrlCol( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, nPos, nCol := '0', zi, zl, cvc

   cvc := aScan( ::aControlW, cName )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   For i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ', Upper( ::aLine[i] ) ) # 0
         nPos := At( ",", ::aLine[i] )
         nCol := SubStr( ::aLine[i], nPos + 1 )
         nCol := LTrim( nCol )
         FOR nPos := 1 TO Len( nCol )
            // Stop at the first letter
            IF Asc( SubStr( nCol, nPos, 1 ) ) >= 65
               EXIT
            ENDIF
         NEXT nPos
         nCol := SubStr( nCol, 1, nPos - 1 )
         EXIT
      ENDIF
   NEXT i
RETURN nCol

//------------------------------------------------------------------------------
METHOD ReadFormCol( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, nPos, nCol := '0', zi, zl, cvc

   cvc := aScan( ::aControlW, cName )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( 'WINDOW' ) + ' ', Upper( ::aLine[i] ) ) # 0
         nPos := At( ",", ::aLine[i + 1] )
         nCol := RTrim( SubStr( ::aLine[i + 1], nPos + 1 ) )
         IF Right( nCol, 1 ) == ";"
            nCol := SubStr( nCol, 1, Len( nCol ) - 1 )
         ENDIF
         EXIT
      ENDIF
   NEXT i
RETURN nCol

//------------------------------------------------------------------------------
METHOD Clean( cData ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cIni, cFin

   cIni := Left( cData, 1 )
   cFin := Right( cData, 1 )
   IF cIni == "'" .OR. cIni == '"'
      IF cIni == cFin
         cData := SubStr( cData, 2, Len( cData ) - 2 )
      ENDIF
   ENDIF
RETURN cData

//------------------------------------------------------------------------------
METHOD DrawPoints() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL hDC, nHeight, nWidth, i, j, nTop

   nHeight := ::oDesignForm:ClientHeight
   nWidth  := ::oDesignForm:ClientWidth

   IF _IsControlDefined( 'Statusbar', ::oDesignForm:Name )
      nHeight -= ::oDesignForm:Statusbar:ClientHeightUsed
   ENDIF
   IF HB_IsObject( ::myTbEditor:oToolbar )
      nTop := Round( ::myTbEditor:oToolbar:ClientHeightUsed(), -1 )
   ELSE
      nTop := 0
   ENDIF

   hDC := GetDC( ::oDesignForm:hWnd )

   FOR i := 0 TO nWidth STEP 10
      FOR j := nTop TO nHeight STEP 10
         SetPixel( hDC, i, j, RGB( 0, 0, 0 ) )
      NEXT
   NEXT

   ReleaseDC( ::oDesignForm:hWnd, hDC )

   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) AT 480, 001 TO 480, nWidth  PENCOLOR { 255, 0, 0 } PENWIDTH 1
   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) AT 600, 001 TO 600, nWidth  PENCOLOR { 255, 0, 0 } PENWIDTH 1
   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) AT 001, 640 TO nHeight, 640 PENCOLOR { 255, 0, 0 } PENWIDTH 1
   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) AT 001, 800 TO nHeight, 800 PENCOLOR { 255, 0, 0 } PENWIDTH 1
RETURN NIL

//------------------------------------------------------------------------------
METHOD pForm( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nFRow, nFCol, nFWidth, nFHeight

   ::aCtrlType[i]         := 'FORM'
   nFRow                  := Val( ::ReadFormRow( ::cFName ) )
   nFCol                  := Val( ::ReadFormCol( ::cFName ) )
   ::cFTitle              := ::Clean( ::ReadStringData( 'WINDOW', 'TITLE', '' ) )
   nFWidth                := Val( ::ReadStringData( 'WINDOW', 'WIDTH', '640' ) )
   nFHeight               := Val( ::ReadStringData( 'WINDOW', 'HEIGHT', '480' ) )
   ::cFObj                := ::ReadStringData( 'WINDOW', 'OBJ', '' )
   ::cFIcon               := ::Clean( ::ReadStringData( 'WINDOW', 'ICON', '' ) )
   ::nFVirtualW           := Val( ::ReadStringData( 'WINDOW', 'VIRTUAL WIDTH', '0' ) )
   ::nFVirtualH           := Val( ::ReadStringData( 'WINDOW', 'VIRTUAL HEIGHT', '0' ) )
   ::lFMain               := ( ::ReadLogicalData( 'WINDOW', "MAIN", "F" ) == 'T' )
   ::lFChild              := ( ::ReadLogicalData( 'WINDOW', "CHILD", "F" ) == 'T' )
   ::lFModal              := ( ::ReadLogicalData( 'WINDOW', "MODAL", "F" ) == 'T' )
   ::lFNoShow             := ( ::ReadLogicalData( 'WINDOW', "NOSHOW", "F" ) == 'T' )
   ::lFTopmost            := ( ::ReadLogicalData( 'WINDOW', "TOPMOST", "F" ) == 'T' )
   ::lFNominimize         := ( ::ReadLogicalData( 'WINDOW', "NOMINIMIZE", "F" ) == 'T' )
   ::lFNomaximize         := ( ::ReadLogicalData( 'WINDOW', "NOMAXIMIZE", "F" ) == 'T' )
   ::lFNoSize             := ( ::ReadLogicalData( 'WINDOW', "NOSIZE", "F" ) == 'T' )
   ::lFNoSysMenu          := ( ::ReadLogicalData( 'WINDOW', "NOSYSMENU", "F" ) == 'T' )
   ::lFNoCaption          := ( ::ReadLogicalData( 'WINDOW', "NOCAPTION", "F" ) == 'T' )
   ::lFNoAutoRelease      := ( ::ReadLogicalData( 'WINDOW', "NOAUTORELEASE", "F" ) == 'T' )
   ::lFHelpButton         := ( ::ReadLogicalData( 'WINDOW', "HELPBUTTON", "F" ) == 'T' )
   ::lFFocused            := ( ::ReadLogicalData( 'WINDOW', "FOCUSED", "F" ) == 'T' )
   ::lFBreak              := ( ::ReadLogicalData( 'WINDOW', "BREAK", "F" ) == 'T' )
   ::lFSplitchild         := ( ::ReadLogicalData( 'WINDOW', "SPLITCHILD", "F" ) == 'T' )
   ::cFGripperText        := ::ReadStringData( 'WINDOW', "GRIPPERTEXT", '' )
   ::cFOnInit             := ::ReadStringData( 'WINDOW', 'ON INIT', '' )
   ::cFOnRelease          := ::ReadStringData( 'WINDOW', 'ON RELEASE', '' )
   ::cFOnInteractiveClose := ::ReadStringData( 'WINDOW', 'ON INTERACTIVECLOSE', '' )
   ::cFOnMouseClick       := ::ReadStringData( 'WINDOW', 'ON MOUSECLICK', '' )
   ::cFOnMouseDrag        := ::ReadStringData( 'WINDOW', 'ON MOUSEDRAG', '' )
   ::cFOnMouseMove        := ::ReadStringData( 'WINDOW', 'ON MOUSEMOVE', '' )
   ::cFOnSize             := ::ReadStringData( 'WINDOW', 'ON SIZE', '' )
   ::cFOnPaint            := ::ReadStringData( 'WINDOW', 'ON PAINT', '' )
   ::cFBackcolor          := UpperNIL( ::ReadStringData( 'WINDOW', 'BACKCOLOR', 'NIL' ) )
   ::cFCursor             := ::Clean( ::ReadStringData( 'WINDOW', 'CURSOR', '' ) )
   ::cFFontName           := ::Clean( ::ReadStringData( 'WINDOW', 'FONT', '' ) )           // Do not force a font when form has none, use OOHG default
   ::nFFontSize           := Val( ::ReadStringData( 'WINDOW', 'SIZE', '0' ) )
   ::cFFontColor          := ::ReadStringData( 'WINDOW', 'FONTCOLOR', 'NIL' )
   ::cFFontColor          := UpperNIL( ::ReadOopData( 'WINDOW', 'FONTCOLOR', ::cFFontColor ) )
   ::cFNotifyIcon         := ::Clean( ::ReadStringData( 'WINDOW', 'NOTIFYICON', '' ) )
   ::cFNotifyToolTip      := ::Clean( ::ReadStringData( 'WINDOW', 'NOTIFYTOOLTIP', '' ) )
   ::cFOnNotifyClick      := ::ReadStringData( 'WINDOW', 'ON NOTIFYCLICK', '' )
   ::cFOnGotFocus         := ::ReadStringData( 'WINDOW', 'ON GOTFOCUS', '' )
   ::cFOnLostFocus        := ::ReadStringData( 'WINDOW', 'ON LOSTFOCUS', '' )
   ::cFOnScrollUp         := ::ReadStringData( 'WINDOW', 'ON SCROLLUP', '' )
   ::cFOnScrollDown       := ::ReadStringData( 'WINDOW', 'ON SCROLLDOWN', '' )
   ::cFOnScrollRight      := ::ReadStringData( 'WINDOW', 'ON SCROLLRIGHT', '' )
   ::cFOnScrollLeft       := ::ReadStringData( 'WINDOW', 'ON SCROLLLEFT', '' )
   ::cFOnHScrollbox       := ::ReadStringData( 'WINDOW', 'ON HSCROLLBOX', '' )
   ::cFOnVScrollbox       := ::ReadStringData( 'WINDOW', 'ON VSCROLLBOX', '' )
   ::cFOnMaximize         := ::ReadStringData( 'WINDOW', 'ON MAXIMIZE', '' )
   ::cFOnMinimize         := ::ReadStringData( 'WINDOW', 'ON MINIMIZE', '' )
   ::lFModalSize          := ( ::ReadLogicalData( 'WINDOW', "MODALSIZE", "F" ) == 'T' )
   ::lFMDI                := ( ::ReadLogicalData( 'WINDOW', "MDI", "F" ) == 'T' )
   ::lFMDIClient          := ( ::ReadLogicalData( 'WINDOW', "MDICLIENT", "F" ) == 'T' )
   ::lFMDIChild           := ( ::ReadLogicalData( 'WINDOW', "MDICHILD", "F" ) == 'T' )
   ::lFInternal           := ( ::ReadLogicalData( 'WINDOW', "INTERNAL", "F" ) == 'T' )
   ::cFMoveProcedure      := ::ReadStringData( 'WINDOW', 'ON MOVE', '' )
   ::cFRestoreProcedure   := ::ReadStringData( 'WINDOW', 'ON RESTORE', '' )
   ::lFRTL                := ( ::ReadLogicalData( 'WINDOW', "RTL", "F" ) == 'T' )
   ::lFClientArea         := ( ::ReadLogicalData( 'WINDOW', "CLIENTAREA", "F" ) == 'T' )
   ::cFRClickProcedure    := ::ReadStringData( 'WINDOW', 'ON RCLICK', '' )
   ::cFMClickProcedure    := ::ReadStringData( 'WINDOW', 'ON MCLICK', '' )
   ::cFDblClickProcedure  := ::ReadStringData( 'WINDOW', 'ON DBLCLICK', '' )
   ::cFRDblClickProcedure := ::ReadStringData( 'WINDOW', 'ON RDBLCLICK', '' )
   ::cFMDblClickProcedure := ::ReadStringData( 'WINDOW', 'ON MDBLCLICK', '' )
   ::nFMinWidth           := Val( ::ReadStringData( 'WINDOW', 'MINWIDTH', '0' ) )
   ::nFMaxWidth           := Val( ::ReadStringData( 'WINDOW', 'MAXWIDTH', '0' ) )
   ::nFMinHeight          := Val( ::ReadStringData( 'WINDOW', 'MINHEIGHT', '0' ) )
   ::nFMaxHeight          := Val( ::ReadStringData( 'WINDOW', 'MAXHEIGHT', '0' ) )
   ::cFBackImage          := ::Clean( ::ReadStringData( 'WINDOW', 'BACKIMAGE', '' ) )
   ::lFStretch            := ( ::ReadLogicalData( 'WINDOW', "STRETCH", "F" ) == 'T' )
   ::cFParent             := ::ReadStringData( 'WINDOW', 'PARENT', '' )
   ::cFSubClass           := ::ReadStringData( 'WINDOW', 'SUBCLASS', '' )

   ::oDesignForm:Row       := nFRow
   ::oDesignForm:Col       := nFCol
   ::oDesignForm:Width     := nFWidth
   ::oDesignForm:Height    := nFHeight
   ::oDesignForm:Title     := ::cFTitle
   ::oDesignForm:cFontName := IIF( Empty( ::cFFontName ), _OOHG_DefaultFontName, ::cFFontName )
   ::oDesignForm:nFontSize := IIF( ::nFFontSize > 0, ::nFFontSize, _OOHG_DefaultFontSize )
   ::oDesignForm:FontColor := &( ::cFFontColor )
   ::oDesignForm:BackColor := IIF( IsValidArray( ::cFBackcolor ), &( ::cFBackcolor ), NIL )
   IF ::lFClientArea
      ClientAreaResize( ::oDesignForm )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD pActiveX( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, nRow, nCol, cObj, nWidth, nHeight, cProgID, lNoTabStop, lVisible
LOCAL lEnabled, cSubClass, oCtrl

   // Load properties
   cName      := ::aControlW[i]
   nRow       := Val( ::ReadCtrlRow( cName ) )
   nCol       := Val( ::ReadCtrlCol( cName ) )
   cObj       := ::ReadStringData( cName, 'OBJ', '' )
   nWidth     := Val( ::ReadStringData( cName, 'WIDTH', '100' ) )
   nHeight    := Val( ::ReadStringData( cName, 'HEIGHT', '100' ) )
   cProgID    := ::ReadStringData( cName, 'PROGID', '' )
   lNoTabStop := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lVisible   := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cSubClass  := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]    := 'ACTIVEX'
   ::aCObj[i]        := cObj
   ::aAction[i]      := cProgID
   ::aNoTabStop[i]   := lNoTabStop
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled
   ::aSubClass[i]    := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pAnimatebox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nWidth, nHeight, cFile, lAutoplay, lCenter, lTrans, cSubClass
LOCAL cToolTip, lVisible, lEnabled, nHelpid, nRow, nCol, lRTL, lNoTabStop, oCtrl

   // Load properties
   cName      := ::aControlW[i]
   cObj       := ::ReadStringData( cName, 'OBJ', '' )
   nRow       := Val( ::ReadCtrlRow( cName ) )
   nCol       := Val( ::ReadCtrlCol( cName ) )
   nWidth     := Val( ::ReadStringData( cName, 'WIDTH', '100' ) )
   nHeight    := Val( ::ReadStringData( cName, 'HEIGHT', '100' ) )
   cFile      := ::Clean( ::ReadStringData( cName, 'FILE', '' ) )
   lAutoplay  := ( ::ReadLogicalData( cName, 'AUTOPLAY', 'F') == "T" )
   lCenter    := ( ::ReadLogicalData( cName, 'CENTER', 'F' ) == "T" )
   lTrans     := ( ::ReadLogicalData( cName, 'TRANSPARENT', 'F' ) == "T" )
   nHelpid    := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cToolTip   := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   lVisible   := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL       := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lNoTabStop := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == 'T' )
   cSubClass  := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]    := 'ANIMATE'
   ::aCObj[i]        := cObj
   ::aFile[i]        := cFile
   ::aAutoPlay[i]    := lAutoplay
   ::aCenter[i]      := lCenter
   ::aTransparent[i] := lTrans
   ::aHelpID[i]      := nHelpId
   ::aToolTip[i]     := cToolTip
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled
   ::aRTL[i]         := lRTL
   ::aNoTabStop[i]   := lNoTabStop
   ::aSubClass[i]    := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pBrowse( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cHeaders, cWidths, cWorkArea
LOCAL cFields, nValue, cFontName, nFontSize, cToolTip, cInputMask, cDynBackColor
LOCAL cDynForecolor, cColControls, cOnChange, cOnGotFocus, cOnLostFocus
LOCAL cOnDblClick, cOnEnter, cOnHeadClick, cOnEditCell, cOnAppend, cWhen, cValid
LOCAL cValidMess, cReadOnly, lLock, lDelete, lAppend, lInPlace, lEdit, lNoLines
LOCAL cImage, cJustify, nHelpId, lBold, lItalic, lUnderline, lStrikeout
LOCAL aBackColor, aFontColor, cAction, lBreak, lRTL, lNoTabStop, lVisible
LOCAL lEnabled, lFull, lButtons, lNoHeaders, cHeaderImages, cImagesAlign
LOCAL aSelColor, cEditKeys, lDoubleBuffer, lSingleBuffer, lFocusRect
LOCAL lNoFocusRect, lPLM, lFixedCols, cOnAbortEdit, lFixedWidths, cBeforeColMove
LOCAL cAfterColMove, cBeforeColSize, cAfterColSize, cBeforeAutoFit, lLikeExcel
LOCAL cDeleteWhen, cDeleteMsg, cOnDelete, lNoDeleteMsg, lFixedCtrls
LOCAL lDynamicCtrls, cOnHeadRClick, lExtDblClick, lNoVScroll, lNoRefresh
LOCAL cReplaceField, cSubClass, lRecCount, cColumnInfo, lDescending
LOCAL lForceRefresh, lSync, lUnSync, lUpdateAll, lFixedBlocks, lDynamicBlocks
LOCAL lUpdateColors, oCtrl

   // Load properties
   cName          := ::aControlW[i]
   cObj           := ::ReadStringData( cName, 'OBJ', '' )
   nRow           := Val( ::ReadCtrlRow( cName ) )
   nCol           := Val( ::ReadCtrlCol( cName ) )
   nWidth         := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TOBrowse():nWidth ) ) ) )
   nHeight        := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TOBrowse():nHeight ) ) ) )
   cHeaders       := ::ReadStringData( cName, 'HEADERS', "{ '','' } ")
   cWidths        := ::ReadStringData( cName, 'WIDTHS', "{ 100, 60 }")
   cWorkArea      := ::ReadStringData( cName, 'WORKAREA', "ALIAS()" )
   cFields        := ::ReadStringData( cName, 'FIELDS', "{ 'field1', 'field2' }" )
   nValue         := Val( ::ReadStringData( cName, 'VALUE', '' ) )
   cFontName      := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize      := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cToolTip       := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cInputMask     := ::ReadStringData( cName, 'INPUTMASK', "")
   cDynBackColor  := ::ReadStringData( cName, "DYNAMICBACKCOLOR", '' )
   cDynForecolor  := ::ReadStringData( cName, "DYNAMICFORECOLOR", '' )
   cColControls   := ::ReadStringData( cName, "COLUMNCONTROLS", "" )
   cOnChange      := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus    := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus   := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick    := ::ReadStringData( cName, 'ON DBLCLICK', '' )
   cOnEnter       := ::ReadStringData( cName, 'ON ENTER', '' )
   cOnHeadClick   := ::ReadStringData( cName, 'ON HEADCLICK', '' )
   cOnEditCell    := ::ReadStringData( cName, 'ON EDITCELL', '' )
   cOnAppend      := ::ReadStringData( cName, 'ON APPEND', '' )
   cWhen          := ::ReadStringData( cName, 'WHEN', "" )
   cWhen          := ::ReadStringData( cName, 'COLUMNWHEN', cWhen )
   cValid         := ::ReadStringData( cName, 'VALID', "" )
   cValidMess     := ::ReadStringData( cName, 'VALIDMESSAGES', "" )
   cReadOnly      := ::ReadStringData( cName, 'READONLY', "")
   lLock          := ( ::ReadLogicalData( cName, 'LOCK', "F" ) == "T" )
   lDelete        := ( ::ReadLogicalData( cName, 'DELETE', "F" ) == "T" )
   lAppend        := ( ::ReadLogicalData( cName, 'APPEND', "F" ) == "T" )
   lInPlace       := ( ::ReadLogicalData( cName, 'INPLACE', "F" ) == "T" )
   lEdit          := ( ::ReadLogicalData( cName, 'EDIT', "F" ) == "T" )
   lNoLines       := ( ::ReadLogicalData( cName, 'NOLINES', "F" ) == "T" )
   cImage         := ::ReadStringData( cName, 'IMAGE', "" )
   cJustify       := ::ReadStringData( cName, 'JUSTIFY', "" )
   nHelpId        := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lBold          := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor     := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor     := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   cAction        := ::ReadStringData( cName, 'ACTION', "" )
   cAction        := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction        := ::ReadStringData( cName, 'ONCLICK', cAction )
   lBreak         := ( ::ReadLogicalData( cName, "BREAK", "F" ) == "T" )
   lRTL           := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lNoTabStop     := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lVisible       := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled       := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lFull          := ( ::ReadLogicalData( cName, 'FULLMOVE', "F" ) == "T" )
   lButtons       := ( ::ReadLogicalData( cName, 'USEBUTTONS', "F" ) == "T" )
   lNoHeaders     := ( ::ReadLogicalData( cName, 'NOHEADERS', "F" ) == "T" )
   cHeaderImages  := ::ReadStringData( cName, 'HEADERIMAGES', '' )
   cImagesAlign   := ::ReadStringData( cName, 'IMAGESALIGN', '' )
   aSelColor      := UpperNIL( ::ReadStringData( cName, 'SELECTEDCOLORS', '' ) )
   cEditKeys      := ::ReadStringData( cName, 'EDITKEYS', '' )
   lDoubleBuffer  := ( ::ReadLogicalData( cName, 'DOUBLEBUFFER', "F" ) == "T" )
   lSingleBuffer  := ( ::ReadLogicalData( cName, 'SINGLEBUFFER', "F" ) == "T" )
   lFocusRect     := ( ::ReadLogicalData( cName, 'FOCUSRECT', "F" ) == "T" )
   lNoFocusRect   := ( ::ReadLogicalData( cName, 'NOFOCUSRECT', "F" ) == "T" )
   lPLM           := ( ::ReadLogicalData( cName, 'PAINTLEFTMARGIN', "F" ) == "T" )
   lFixedCols     := ( ::ReadLogicalData( cName, 'FIXEDCOLS', "F" ) == "T" )
   cOnAbortEdit   := ::ReadStringData( cName, 'ON ABORTEDIT', '' )
   lFixedWidths   := ( ::ReadLogicalData( cName, 'FIXEDWIDTHS', "F" ) == "T" )
   cBeforeColMove := ::ReadStringData( cName, 'BEFORECOLMOVE', '' )
   cAfterColMove  := ::ReadStringData( cName, 'AFTERCOLMOVE', '' )
   cBeforeColSize := ::ReadStringData( cName, 'BEFORECOLSIZE', '' )
   cAfterColSize  := ::ReadStringData( cName, 'AFTERCOLSIZE', '' )
   cBeforeAutoFit := ::ReadStringData( cName, 'BEFOREAUTOFIT', '' )
   lLikeExcel     := ( ::ReadLogicalData( cName, 'EDITLIKEEXCEL', "F" ) == "T" )
   cDeleteWhen    := ::ReadStringData( cName, 'DELETEWHEN', '' )
   cDeleteMsg     := ::ReadStringData( cName, 'DELETEMSG', '' )
   cOnDelete      := ::ReadStringData( cName, 'ON DELETE', '' )
   lNoDeleteMsg   := ( ::ReadLogicalData( cName, 'NODELETEMSG', "F" ) == "T" )
   lFixedCtrls    := ( ::ReadLogicalData( cName, 'FIXEDCONTROLS', "F" ) == "T" )
   lDynamicCtrls  := ( ::ReadLogicalData( cName, 'DYNAMICCONTROLS', "F" ) == "T" )
   cOnHeadRClick  := ::ReadStringData( cName, 'ON HEADRCLICK', '' )
   lExtDblClick   := ( ::ReadLogicalData( cName, 'EXTDBLCLICK', "F" ) == "T" )
   lNoVScroll     := ( ::ReadLogicalData( cName, "NOVSCROLL", "F" ) == "T" )
   lNoRefresh     := ( ::ReadLogicalData( cName, "NOREFRESH", "F" ) == "T" )
   cReplaceField  := ::ReadStringData( cName, 'REPLACEFIELD', '' )
   cSubClass      := ::ReadStringData( cName, 'SUBCLASS', '' )
   lRecCount      := ( ::ReadLogicalData( cName, "RECCOUNT", "F" ) == "T" )
   cColumnInfo    := ::ReadStringData( cName, 'COLUMNINFO', '' )
   lDescending    := ( ::ReadLogicalData( cName, "DESCENDING", "F" ) == "T" )
   lForceRefresh  := ( ::ReadLogicalData( cName, "FORCEREFRESH", "F" ) == "T" )
   lSync          := ( ::ReadLogicalData( cName, "SYNCHRONIZED", "F" ) == "T" )
   lUnSync        := ( ::ReadLogicalData( cName, "UNSYNCHRONIZED", "F" ) == "T" )
   lUpdateAll     := ( ::ReadLogicalData( cName, "UPDATEALL", "F" ) == "T" )
   lFixedBlocks   := ( ::ReadLogicalData( cName, "FIXEDBLOCKS", "F" ) == "T" )
   lDynamicBlocks := ( ::ReadLogicalData( cName, "DYNAMICBLOCKS", "F" ) == "T" )
   lUpdateColors  := ( ::ReadLogicalData( cName, "UPDATECOLORS", "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]         := 'BROWSE'
   ::aCObj[i]             := cObj
   ::aHeaders[i]          := cHeaders
   ::aWidths[i]           := cWidths
   ::aWorkArea[i]         := cWorkArea
   ::aFields[i]           := cFields
   ::aValueN[i]           := nValue
   ::aFontName[i]         := cFontName
   ::aFontSize[i]         := nFontSize
   ::aToolTip[i]          := cToolTip
   ::aInputMask[i]        := cInputMask
   ::aDynamicBackColor[i] := cDynBackColor
   ::aDynamicForeColor[i] := cDynForecolor
   ::aColumnControls[i]   := cColControls
   ::aOnChange[i]         := cOnChange
   ::aOnGotFocus[i]       := cOnGotFocus
   ::aOnLostFocus[i]      := cOnLostFocus
   ::aOnDblClick[i]       := cOnDblClick
   ::aOnEnter[i]          := cOnEnter
   ::aOnHeadClick[i]      := cOnHeadClick
   ::aOnEditCell[i]       := cOnEditCell
   ::aOnAppend[i]         := cOnAppend
   ::aWhen[i]             := cWhen
   ::aValid[i]            := cValid
   ::aValidMess[i]        := cValidMess
   ::aReadOnlyB[i]        := cReadOnly
   ::aLock[i]             := lLock
   ::aDelete[i]           := lDelete
   ::aAppend[i]           := lAppend
   ::aInPlace[i]          := lInPlace
   ::aEdit[i]             := lEdit
   ::aNoLines[i]          := lNoLines
   ::aImage[i]            := cImage
   ::aJustify[i]          := cJustify
   ::aHelpID[i]           := nHelpId
   ::aBold[i]             := lBold
   ::aFontItalic[i]       := lItalic
   ::aFontUnderline[i]    := lUnderline
   ::aFontStrikeout[i]    := lStrikeout
   ::aBackColor[i]        := aBackColor
   ::aFontColor[i]        := aFontColor
   ::aAction[i]           := cAction
   ::aBreak[i]            := lBreak
   ::aRTL[i]              := lRTL
   ::aNoTabStop[i]        := lNoTabStop
   ::aVisible[i]          := lVisible
   ::aEnabled[i]          := lEnabled
   ::aFull[i]             := lFull
   ::aButtons[i]          := lButtons
   ::aNoHeaders[i]        := lNoHeaders
   ::aHeaderImages[i]     := cHeaderImages
   ::aImagesAlign[i]      := cImagesAlign
   ::aSelColor[i]         := aSelColor
   ::aEditKeys[i]         := cEditKeys
   ::aDoubleBuffer[i]     := lDoubleBuffer
   ::aSingleBuffer[i]     := lSingleBuffer
   ::aFocusRect[i]        := lFocusRect
   ::aNoFocusRect[i]      := lNoFocusRect
   ::aPLM[i]              := lPLM
   ::aFixedCols[i]        := lFixedCols
   ::aOnAbortEdit[i]      := cOnAbortEdit
   ::aFixedWidths[i]      := lFixedWidths
   ::aBeforeColMove[i]    := cBeforeColMove
   ::aAfterColMove[i]     := cAfterColMove
   ::aBeforeColSize[i]    := cBeforeColSize
   ::aAfterColSize[i]     := cAfterColSize
   ::aBeforeAutoFit[i]    := cBeforeAutoFit
   ::aLikeExcel[i]        := lLikeExcel
   ::aDeleteWhen[i]       := cDeleteWhen
   ::aDeleteMsg[i]        := cDeleteMsg
   ::aOnDelete[i]         := cOnDelete
   ::aNoDelMsg[i]         := lNoDeleteMsg
   ::aFixedCtrls[i]       := lFixedCtrls
   ::aDynamicCtrls[i]     := lDynamicCtrls
   ::aOnHeadRClick[i]     := cOnHeadRClick
   ::aExtDblClick[i]      := lExtDblClick
   ::aNoVScroll[i]        := lNoVScroll
   ::aNoRefresh[i]        := lNoRefresh
   ::aReplaceField[i]     := cReplaceField
   ::aSubClass[i]         := cSubClass
   ::aRecCount[i]         := lRecCount
   ::aColumnInfo[i]       := cColumnInfo
   ::aDescend[i]          := lDescending
   ::aForceRefresh[i]     := lForceRefresh
   ::aSync[i]             := lSync
   ::aUnSync[i]           := lUnSync
   ::aUpdate[i]           := lUpdateAll
   ::aFixBlocks[i]        := lFixedBlocks
   ::aDynBlocks[i]        := lDynamicBlocks
   ::aUpdateColors[i]     := lUpdateColors

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pButton( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, lBold
LOCAL lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip
LOCAL cOnGotFocus, cOnLostFocus, nHelpId, cCaption, cPicture, cAction, lNoTabStop
LOCAL lFlat, lTop, lBottom, lLeft, lRight, lCenter, cOnMouseMove, lRTL, lNoPrefix
LOCAL lNoLoadTrans, lForceScale, lCancel, lMultiLine, lThemed, lNo3DColors, lFit
LOCAL lDIBSection, cBuffer, cHBitmap, cImgMargin, cSubClass, oCtrl

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::ReadStringData( cName, 'OBJ', '' )
   nRow          := Val( ::ReadCtrlRow( cName ) )
   nCol          := Val( ::ReadCtrlCol( cName ) )
   nWidth        := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TButton():nWidth ) ) ) )
   nHeight       := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TButton():nHeight ) ) ) )
   cFontName     := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize     := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   lBold         := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold         := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic       := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic       := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline    := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline    := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout    := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout    := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor    := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible      := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip      := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnGotFocus   := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus  := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   nHelpId       := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cCaption      := ::Clean( ::ReadStringData( cName, 'CAPTION', cName ) )
   cPicture      := ::Clean( ::ReadStringData( cName, 'PICTURE', '' ) )
   cAction       := ::ReadStringData( cName, 'ACTION', "MsgInfo( 'Button pressed' )" )
   cAction       := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction       := ::ReadStringData( cName, 'ONCLICK', cAction )
   lNoTabStop    := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   lFlat         := ( ::ReadLogicalData( cName, 'FLAT', "F" ) == "T" )
   lTop          := ( ::ReadLogicalData( cName, 'TOP', "F" ) == "T" )
   lBottom       := ( ::ReadLogicalData( cName, 'BOTTOM', "F" ) == "T" )
   lLeft         := ( ::ReadLogicalData( cName, 'LEFT', "F" ) == "T" )
   lRight        := ( ::ReadLogicalData( cName, 'RIGHT', "F" ) == "T" )
   lCenter       := ( ::ReadLogicalData( cName, 'CENTER', "F" ) == "T" )
   cOnMouseMove  := ::ReadStringData( cName, 'ON MOUSEMOVE', '' )
   lRTL          := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lNoPrefix     := ( ::ReadLogicalData( cName, 'NOPREFIX', "F" ) == "T" )
   lNoLoadTrans  := ( ::ReadLogicalData( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lForceScale   := ( ::ReadLogicalData( cName, 'FORCESCALE', "F" ) == "T" )
   lCancel       := ( ::ReadLogicalData( cName, 'CANCEL', "F" ) == "T" )
   lMultiLine    := ( ::ReadLogicalData( cName, 'MULTILINE', "F" ) == "T" )
   lThemed       := ( ::ReadLogicalData( cName, 'THEMED', "F" ) == "T" )
   lNo3DColors   := ( ::ReadLogicalData( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit          := ::ReadLogicalData( cName, 'AUTOFIT', "F" )
   lFit          := ( ::ReadLogicalData( cName, 'ADJUST', lFit ) == "T" )
   lDIBSection   := ( ::ReadLogicalData( cName, 'DIBSECTION', "F" ) == "T" )
   cBuffer       := ::ReadStringData( cName, 'BUFFER', "" )
   cHBitmap      := ::ReadStringData( cName, 'HBITMAP', "" )
   cImgMargin    := ::ReadStringData( cName, 'IMAGEMARGIN', "" )
   cSubClass     := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'BUTTON'
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpId
   ::aCaption[i]       := cCaption
   ::aPicture[i]       := cPicture
   ::aAction[i]        := cAction
   ::aNoTabStop[i]     := lNoTabStop
   ::aFlat[i]          := lFlat
   ::aJustify[i]       := IIF( lTop, "TOP", IIF( lBottom, "BOTTOM", IIF( lLeft, "LEFT", IIF( lRight, "RIGHT", IIF( lCenter, "CENTER", "" ) ) ) ) )
   ::aOnMouseMove[i]   := cOnMouseMove
   ::aRTL[i]           := lRTL
   ::aNoPrefix[i]      := lNoPrefix
   ::aNoLoadTrans[i]   := lNoLoadTrans
   ::aForceScale[i]    := lForceScale
   ::aCancel[i]        := lCancel
   ::aMultiLine[i]     := lMultiLine
   ::aThemed[i]        := lThemed
   ::aNo3DColors[i]    := lNo3DColors
   ::aFit[i]           := lFit
   ::aDIBSection[i]    := lDIBSection
   ::aBuffer[i]        := cBuffer
   ::aHBitmap[i]       := cHBitmap
   ::aImageMargin[i]   := cImgMargin
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pCheckBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, cToolTip
LOCAL cCaption, cOnChange, cField, cOnGotFocus, cOnLostFocus, nHelpID, lTrans
LOCAL lNoTabStop, cValue, lBold, lItalic, lUnderline, lStrikeout, aBackColor
LOCAL aFontColor, lVisible, lEnabled, lRTL, lThemed, lAutoSize, lLeft, l3State
LOCAL cSubClass, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TCheckBox():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TCheckBox():nHeight ) ) ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cCaption     := ::Clean( ::ReadStringData( cName, 'CAPTION', '' ) )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cField       := ::ReadStringData( cName, 'FIELD', '' )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   nHelpID      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lTrans       := ( ::ReadLogicalData( cName, "TRANSPARENT", "F" ) == "T" )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lThemed      := ( ::ReadLogicalData( cName, 'THEMED', "F" ) == "T" )
   lAutoSize    := ( ::ReadLogicalData( cName, "AUTOSIZE", "F" ) == "T" )
   lLeft        := ( ::ReadLogicalData( cName, 'LEFTALIGN', "F" ) == "T" )
   l3State      := ( ::ReadLogicalData( cName, 'THREESTATE', "F" ) == "T" )
   cValue       := ::ReadStringData( cName, 'VALUE', "NIL" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'CHECKBOX'
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aCaption[i]       := cCaption
   ::aOnChange[i]      := cOnChange
   ::aField[i]         := cField
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpID
   ::aTransparent[i]   := lTrans
   ::aNoTabStop[i]     := lNoTabStop
   ::aValue[i]         := cValue
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aThemed[i]        := lThemed
   ::aAutoPlay[i]      := lAutoSize
   ::aLeft[i]          := lLeft
   ::a3State[i]        := l3State
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pCheckBtn( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cCaption, cFontName, nFontSize
LOCAL lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnGotFocus, cOnLostFocus, nHelpId, lRTL, cPicture, cBuffer
LOCAL cHBitmap, lNoLoadTrans, lForceScale, cField, lNo3DColors, lFit, lMultiLine
LOCAL lDIBSection, lNoTabStop, cOnChange, lValue, oCtrl, cSubClass, lThemed
LOCAL cImgMargin, cOnMouseMove, lTop, lBottom, lLeft, lRight, lCenter, lFlat

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TButtonCheck():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TButtonCheck():nHeight ) ) ) )
   cCaption     := ::Clean( ::ReadStringData( cName, 'CAPTION', cName ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cPicture     := ::Clean( ::ReadStringData( cName, 'PICTURE', '' ) )
   cBuffer      := ::ReadStringData( cName, 'BUFFER', "" )
   cHBitmap     := ::ReadStringData( cName, 'HBITMAP', "" )
   lNoLoadTrans := ( ::ReadLogicalData( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lForceScale  := ( ::ReadLogicalData( cName, 'FORCESCALE', "F" ) == "T" )
   cField       := ::ReadStringData( cName, 'FIELD', '' )
   lNo3DColors  := ( ::ReadLogicalData( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit         := ::ReadLogicalData( cName, 'AUTOFIT', "F" )
   lFit         := ( ::ReadLogicalData( cName, 'ADJUST', lFit ) == "T" )
   lDIBSection  := ( ::ReadLogicalData( cName, 'DIBSECTION', "F" ) == "T" )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   lValue       := ( ::ReadStringData( cName, 'VALUE', ".F." ) == ".T." )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )
   lThemed      := ( ::ReadLogicalData( cName, 'THEMED', "F" ) == "T" )
   cImgMargin   := ::ReadStringData( cName, 'IMAGEMARGIN', "" )
   cOnMouseMove := ::ReadStringData( cName, 'ON MOUSEMOVE', '' )
   lTop         := ( ::ReadLogicalData( cName, 'TOP', "F" ) == "T" )
   lBottom      := ( ::ReadLogicalData( cName, 'BOTTOM', "F" ) == "T" )
   lLeft        := ( ::ReadLogicalData( cName, 'LEFT', "F" ) == "T" )
   lRight       := ( ::ReadLogicalData( cName, 'RIGHT', "F" ) == "T" )
   lCenter      := ( ::ReadLogicalData( cName, 'CENTER', "F" ) == "T" )
   lMultiLine   := ( ::ReadLogicalData( cName, 'MULTILINE', "F" ) == "T" )
   lFlat        := ( ::ReadLogicalData( cName, 'FLAT', "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]      := 'CHECKBTN'
   ::aCObj[i]          := cObj
   ::aCaption[i]       := cCaption
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpId
   ::aRTL[i]           := lRTL
   ::aPicture[i]       := cPicture
   ::aBuffer[i]        := cBuffer
   ::aHBitmap[i]       := cHBitmap
   ::aNoLoadTrans[i]   := lNoLoadTrans
   ::aForceScale[i]    := lForceScale
   ::aField[i]         := cField
   ::aNo3DColors[i]    := lNo3DColors
   ::aFit[i]           := lFit
   ::aDIBSection[i]    := lDIBSection
   ::aNoTabStop[i]     := lNoTabStop
   ::aOnChange[i]      := cOnChange
   ::aValueL[i]        := lValue
   ::aSubClass[i]      := cSubClass
   ::aThemed[i]        := lThemed
   ::aImageMargin[i]   := cImgMargin
   ::aOnMouseMove[i]   := cOnMouseMove
   ::aJustify[i]       := IIF( lTop, "TOP", IIF( lBottom, "BOTTOM", IIF( lLeft, "LEFT", IIF( lRight, "RIGHT", IIF( lCenter, "CENTER", "" ) ) ) ) )
   ::aMultiLine[i]     := lMultiLine
   ::aFlat[i]          := lFlat

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pCheckList( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cSubClass, cItems, cImage
LOCAL nValue, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout
LOCAL cJustify, lRTL, aBackColor, aFontColor, aSelColor, cToolTip, cOnChange
LOCAL cOnGotFocus, cOnLostFocus, cAction, lBreak, nHelpId, lEnabled, lVisible
LOCAL lNoTabStop, lSort, lDescending, lDoubleBuffer, lSingleBuffer, oCtrl

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::ReadStringData( cName, 'OBJ', '' )
   nRow          := Val( ::ReadCtrlRow( cName ) )
   nCol          := Val( ::ReadCtrlCol( cName ) )
   nWidth        := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TCheckList():nWidth ) ) ) )
   nHeight       := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TCheckList():nHeight ) ) ) )
   cSubClass     := ::ReadStringData( cName, 'SUBCLASS', '' )
   cItems        := ::ReadStringData( cName, 'ITEMS', "")
   cImage        := ::ReadStringData( cName, 'IMAGE', "" )
   nValue        := Val( ::ReadStringData( cName, 'VALUE', '') )
   cFontName     := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize     := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   lBold         := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold         := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic       := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic       := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline    := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline    := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout    := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout    := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   cJustify      := ::ReadStringData( cName, 'JUSTIFY', "" )
   lRTL          := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   aBackColor    := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor    := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor    := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   aSelColor     := UpperNIL( ::ReadStringData( cName, 'SELECTEDCOLORS', '' ) )
   cToolTip      := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange     := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus   := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus  := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cAction       := ::ReadStringData( cName, 'ACTION', "" )
   cAction       := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction       := ::ReadStringData( cName, 'ONCLICK', cAction )
   lBreak        := ( ::ReadLogicalData( cName, "BREAK", "F" ) == "T" )
   nHelpId       := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lEnabled      := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lVisible      := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lNoTabStop    := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lSort         := ( ::ReadLogicalData( cName, 'SORT', "F" ) == "T" )
   lDescending   := ( ::ReadLogicalData( cName, "DESCENDING", "F" ) == "T" )
   lDoubleBuffer := ( ::ReadLogicalData( cName, 'DOUBLEBUFFER', "F" ) == "T" )
   lSingleBuffer := ( ::ReadLogicalData( cName, 'SINGLEBUFFER', "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]      := 'CHECKLIST'
   ::aCObj[i]          := cObj
   ::aSubClass[i]      := cSubClass
   ::aItems[i]         := cItems
   ::aImage[i]         := cImage
   ::aValueN[i]        := nValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aJustify[i]       := cJustify
   ::aRTL[i]           := lRTL
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aSelColor[i]      := aSelColor
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aAction[i]        := cAction
   ::aBreak[i]         := lBreak
   ::aHelpID[i]        := nHelpId
   ::aEnabled[i]       := lEnabled
   ::aVisible[i]       := lVisible
   ::aNoTabStop[i]     := lNoTabStop
   ::aSort[i]          := lSort
   ::aDescend[i]       := lDescending
   ::aDoubleBuffer[i]  := lDoubleBuffer
   ::aSingleBuffer[i]  := lSingleBuffer

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pComboBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, cFontName, nFontSize, aFontColor, lBold
LOCAL lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip
LOCAL cOnChange, cOnGotFocus, cOnLostFocus, cOnEnter, cOnDisplayChange, cItems
LOCAL cItemSource, nValue, cValueSource, nHelpId, lNoTabStop, lSort, lBreak
LOCAL lDisplayEdit, lRTL, cImage, lFit, nTextHeight, cItemImageNumber, nHeight
LOCAL cImageSource, lFirstItem, nListWidth, cOnListDisplay, cOnListClose
LOCAL lDelayedLoad, lIncremental, lIntegralHeight, lRefresh, lNoRefresh
LOCAL cSourceOrder, cOnRefresh, nSearchLapse, cGripperText, cSubClass, oCtrl

   // Load properties
   cName            := ::aControlW[i]
   cObj             := ::ReadStringData( cName, 'OBJ', '' )
   nRow             := Val( ::ReadCtrlRow( cName ) )
   nCol             := Val( ::ReadCtrlCol( cName ) )
   nWidth           := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TCombo():nWidth ) ) ) )
   nHeight          := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TCombo():nHeight ) ) ) )
   cFontName        := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize        := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor       := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor       := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold            := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold            := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic          := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic          := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline       := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline       := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout       := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout       := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor       := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor       := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible         := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible         := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled         := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled         := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip         := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange        := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus      := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus     := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnEnter         := ::ReadStringData( cName, 'ON ENTER', '' )
   cOnDisplayChange := ::ReadStringData( cName, 'ON DISPLAYCHANGE', '' )
   cItems           := ::ReadStringData( cName, 'ITEMS', '' )
   cItemSource      := ::ReadStringData( cName, 'ITEMSOURCE', '' )
   nValue           := Val( ::ReadStringData( cName, 'VALUE', '0' ) )
   cValueSource     := ::ReadStringData( cName, 'VALUESOURCE', '' )
   nHelpId          := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lNoTabStop       := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   lSort            := ( ::ReadLogicalData( cName, 'SORT', "F" ) == "T" )
   lBreak           := ( ::ReadLogicalData( cName, 'BREAK', "F" ) == "T" )
   lDisplayEdit     := ( ::ReadLogicalData( cName, 'DISPLAYEDIT', "F" ) == "T" )
   lRTL             := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cImage           := ::Clean( ::ReadStringData( cName, 'IMAGE', '' ) )
   lFit             := ( ::ReadLogicalData( cName, 'FIT', "F" ) == "T" )
   nTextHeight      := Val( ::ReadStringData( cName, 'TEXTHEIGHT', '0' ) )
   cItemImageNumber := ::ReadStringData( cName, 'ITEMIMAGENUMBER', '' )
   cImageSource     := ::ReadStringData( cName, 'IMAGESOURCE', '' )
   lFirstItem       := ( ::ReadLogicalData( cName, 'FIRSTITEM', "F" ) == "T" )
   nListWidth       := Val( ::ReadStringData( cName, 'LISTWIDTH', '0' ) )
   cOnListDisplay   := ::ReadStringData( cName, 'ON LISTDISPLAY', '' )
   cOnListClose     := ::ReadStringData( cName, 'ON LISTCLOSE', '' )
   lDelayedLoad     := ( ::ReadLogicalData( cName, 'DELAYEDLOAD', "F" ) == "T" )
   lIncremental     := ( ::ReadLogicalData( cName, 'INCREMENTAL', "F" ) == "T" )
   lIntegralHeight  := ( ::ReadLogicalData( cName, 'INTEGRALHEIGHT', "F" ) == "T" )
   lRefresh         := ( ::ReadLogicalData( cName, 'REFRESH', "F" ) == "T" )
   lNoRefresh       := ( ::ReadLogicalData( cName, 'NOREFRESH', "F" ) == "T" )
   cSourceOrder     := ::ReadStringData( cName, 'SOURCEORDER', '' )
   cOnRefresh       := ::ReadStringData( cName, 'ON REFRESH', '' )
   nSearchLapse     := Val( ::ReadStringData( cName, 'SEARCHLAPSE', '0' ) )
   cGripperText     := ::ReadStringData( cName, 'GRIPPERTEXT', '' )
   cSubClass        := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]        := 'COMBO'
   ::aCObj[i]            := cObj
   ::aFontName[i]        := cFontName
   ::aFontSize[i]        := nFontSize
   ::aFontColor[i]       := aFontColor
   ::aBold[i]            := lBold
   ::aFontItalic[i]      := lItalic
   ::aFontUnderline[i]   := lUnderline
   ::aFontStrikeout[i]   := lStrikeout
   ::aBackColor[i]       := aBackColor
   ::aVisible[i]         := lVisible
   ::aEnabled[i]         := lEnabled
   ::aToolTip[i]         := cToolTip
   ::aOnChange[i]        := cOnChange
   ::aOnGotFocus[i]      := cOnGotFocus
   ::aOnLostFocus[i]     := cOnLostFocus
   ::aOnEnter[i]         := cOnEnter
   ::aOnDisplayChange[i] := cOnDisplayChange
   ::aItems[i]           := cItems
   ::aItemSource[i]      := cItemSource
   ::aValueN[i]          := nValue
   ::aValueSource[i]     := cValueSource
   ::aHelpID[i]          := nHelpId
   ::aNoTabStop[i]       := lNoTabStop
   ::aSort[i]            := lSort
   ::aBreak[i]           := lBreak
   ::aDisplayEdit[i]     := lDisplayEdit
   ::aRTL[i]             := lRTL
   ::aImage[i]           := cImage
   ::aFit[i]             := lFit
   ::aTextHeight[i]      := nTextHeight
   ::aItemImageNumber[i] := cItemImageNumber
   ::aImageSource[i]     := cImageSource
   ::aFirstItem[i]       := lFirstItem
   ::aListWidth[i]       := nListWidth
   ::aOnListDisplay[i]   := cOnListDisplay
   ::aOnListClose[i]     := cOnListClose
   ::aDelayedLoad[i]     := lDelayedLoad
   ::aIncremental[i]     := lIncremental
   ::aIntegralHeight[i]  := lIntegralHeight
   ::aRefresh[i]         := lRefresh
   ::aNoRefresh[i]       := lNoRefresh
   ::aSourceOrder[i]     := cSourceOrder
   ::aOnRefresh[i]       := cOnRefresh
   ::aSearchLapse[i]     := nSearchLapse
   ::aGripperText[i]     := cGripperText
   ::aSubClass[i]        := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pDatePicker( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, nRow, nCol, nWidth, cFontName, nFontSize, cToolTip, cOnGotFocus
LOCAL cField, cValue, cOnLostFocus, cOnChange, cOnEnter, lShowNone, lUpDown
LOCAL lRightAlign, nHelpID, cObj, lBold, lItalic, lUnderline, lStrikeout, cRange
LOCAL lVisible, lEnabled, lRTL, lNoTabStop, lNoBorder, cSubClass, nHeight, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TDatePick():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TDatePick():nHeight ) ) ) )
   cFontName    := ::Clean( ::ReadStringData(cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '')
   cField       := ::Clean( ::ReadStringData( cName, 'FIELD', '' ) )
   cValue       := ::ReadStringData( cName, 'VALUE', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnEnter     := ::ReadStringData( cName, 'ON ENTER', '' )
   lShowNone    := ( ::ReadLogicalData( cName, 'SHOWNONE', "F" ) == "T" )
   lUpDown      := ( ::ReadLogicalData( cName, 'UPDOWN', "F" ) == "T" )
   lRightAlign  := ( ::ReadLogicalData( cName, 'RIGHTALIGN', "F" ) == "T" )
   nHelpID      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == 'T' )
   cRange       := ::ReadStringData( cName, 'RANGE', '' )
   lNoBorder    := ( ::ReadLogicalData( cName, "NOBORDER", "F" ) == "T" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'DATEPICKER'
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aField[i]         := cField
   ::aValue[i]         := cValue
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnChange[i]      := cOnChange
   ::aonenter[i]       := cOnEnter
   ::aShowNone[i]      := lShowNone
   ::aUpDown[i]        := lUpDown
   ::aRightAlign[i]    := lRightAlign
   ::aHelpID[i]        := nHelpID
   ::aCObj[i]          := cObj
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aNoTabStop[i]     := lNoTabStop
   ::aRange[i]         := cRange
   ::aBorder[i]        := lNoBorder
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pEditbox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aFontColor
LOCAL lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnChange, cOnGotFocus, cOnLostFocus, cOnVScroll, cOnHScroll
LOCAL nFocusedPos, lNoBorder, lRTL, cValue, cField, nMaxLength, lReadonly
LOCAL lBreak, nHelpID, lNoTabStop, lNoVScroll, lNoHScroll, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TEdit():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TEdit():nHeight ) ) ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnVScroll   := ::ReadStringData( cName, 'ON VSCROLL', '' )
   cOnHScroll   := ::ReadStringData( cName, 'ON HSCROLL', '' )
   nFocusedPos  := Val( ::ReadStringData( cName, 'FOCUSEDPOS', '-4' ) )
   lNoBorder    := ( ::ReadLogicalData( cName, "NOBORDER", "F" ) == "T" )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cValue       := ::Clean( ::ReadStringData( cName, 'VALUE', '' ) )
   cField       := ::ReadStringData( cName, 'FIELD', '' )
   nMaxLength   := Val( ::ReadStringData( cName, 'MAXLENGTH', '0' ) )
   lReadonly    := ( ::ReadLogicalData( cName, "READONLY", "F" ) == "T" )
   lBreak       := ( ::ReadLogicalData( cName, "BREAK", "F" ) == "T" )
   nHelpID      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lNoTabStop   := ( ::ReadLogicalData( cName, "NOTABSTOP", "F" ) == "T" )
   lNoVScroll   := ( ::ReadLogicalData( cName, "NOVSCROLL", "F" ) == "T" )
   lNoHScroll   := ( ::ReadLogicalData( cName, "NOHSCROLL", "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]      := 'EDIT'
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cTooltip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnVScroll[i]     := cOnVScroll
   ::aOnHScroll[i]     := cOnHScroll
   ::aFocusedPos[i]    := nFocusedPos
   ::aBorder[i]        := lNoBorder
   ::aRTL[i]           := lRTL
   ::aValue[i]         := cValue
   ::aField[i]         := cField
   ::aMaxLength[i]     := nMaxLength
   ::aReadOnly[i]      := lReadonly
   ::aBreak[i]         := lBreak
   ::aHelpID[i]        := nHelpID
   ::aNoTabStop[i]     := lNoTabStop
   ::aNoVScroll[i]     := lNoVScroll
   ::aNoHScroll[i]     := lNoHScroll

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pFrame( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cCaption, lOpaque, lTrans
LOCAL cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout
LOCAL aBackColor, lVisible, lEnabled, lRTL, cSubClass, oCtrl

   // Load properties
   cName      := ::aControlW[i]
   cObj       := ::ReadStringData( cName, 'OBJ', '' )
   nRow       := Val( ::ReadCtrlRow( cName ) )
   nCol       := Val( ::ReadCtrlCol( cName ) )
   nWidth     := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TFrame():nWidth ) ) ) )
   nHeight    := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TFrame():nHeight ) ) ) )
   cCaption   := ::Clean( ::ReadStringData( cName, 'CAPTION', '' ) )
   lOpaque    := ( ::ReadLogicalData( cName, "OPAQUE", "F") == "T" )
   lTrans     := ( ::ReadLogicalData( cName, "TRANSPARENT", "F" ) == "T" )
   cFontName  := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize  := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold      := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold      := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic    := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic    := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible   := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL       := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cSubClass  := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'FRAME'
   ::aCObj[i]          := cObj
   ::aCaption[i]       := cCaption
   ::aTransparent[i]   := lTrans
   ::aOpaque[i]        := lOpaque
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pGrid( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aFontColor
LOCAL lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnChange, cOnGotFocus, cOnLostFocus, cOnDblClick, cOnEnter
LOCAL cOnHeadClick, cOnEditCell, cOnCheckChg, nHelpId, cHeaders, cWidths, cItems
LOCAL nValue, cDynBackColor, cDynForecolor, cColControls, cReadOnly, cInputMask
LOCAL lMultiSelect, lNoLines, lInPlace, cImage, cJustify, lBreak, lEdit, cValid
LOCAL cWhen, cValidMess, lRTL, lNoTabStop, lFull, lCheckBoxes, aSelColor
LOCAL cAction, lButtons, lDelete, lAppend, cOnAppend, lVirtual, nItemCount
LOCAL cOnQueryData, lNoHeaders, cHeaderImages, cImagesAlign, lByCell, cEditKeys
LOCAL lDoubleBuffer, lSingleBuffer, lFocusRect, lNoFocusRect, lPLM, lFixedCols
LOCAL cOnAbortEdit, lFixedWidths, cBeforeColMove, cAfterColMove, cBeforeColSize
LOCAL cAfterColSize, cBeforeAutoFit, lLikeExcel, cDeleteWhen, cDeleteMsg
LOCAL cOnDelete, lNoDeleteMsg, lNoModalEdit, lFixedCtrls, lDynamicCtrls, oCtrl
LOCAL cOnHeadRClick, lNoClickOnChk, lNoRClickOnChk, lExtDblClick, cSubClass

   // Load properties
   cName          := ::aControlW[i]
   cObj           := ::ReadStringData( cName, 'OBJ', '' )
   nRow           := Val( ::ReadCtrlRow( cName ) )
   nCol           := Val( ::ReadCtrlCol( cName ) )
   nWidth         := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TGrid():nWidth ) ) ) )
   nHeight        := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TGrid():nHeight ) ) ) )
   cFontName      := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize      := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor     := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold          := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor     := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible       := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled       := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip       := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange      := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus    := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus   := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick    := ::ReadStringData( cName, 'ON DBLCLICK', '' )
   cOnEnter       := ::ReadStringData( cName, 'ON ENTER', '' )
   cOnHeadClick   := ::ReadStringData( cName, 'ON HEADCLICK', '' )
   cOnEditCell    := ::ReadStringData( cName, 'ON EDITCELL', '' )
   cOnCheckChg    := ::ReadStringData( cName, 'ON CHECKCHANGE', '' )
   nHelpId        := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cHeaders       := ::ReadStringData( cName, 'HEADERS', "{ 'one', 'two' }")
   cWidths        := ::ReadStringData( cName, 'WIDTHS', "{ 80, 60 }")
   cItems         := ::ReadStringData( cName, 'ITEMS', "")
   nValue         := Val( ::ReadStringData( cName, 'VALUE', '') )
   cDynBackColor  := ::ReadStringData( cName, "DYNAMICBACKCOLOR", '' )
   cDynForecolor  := ::ReadStringData( cName, "DYNAMICFORECOLOR", '' )
   cColControls   := ::ReadStringData( cName, "COLUMNCONTROLS", "" )
   cReadOnly      := ::ReadStringData( cName, 'READONLY', "")
   cInputMask     := ::ReadStringData( cName, 'INPUTMASK', "")
   lMultiSelect   := ( ::ReadLogicalData( cName, 'MULTISELECT', "F" ) == "T" )
   lNoLines       := ( ::ReadLogicalData( cName, 'NOLINES', "F" ) == "T" )
   lInPlace       := ( ::ReadLogicalData( cName, 'INPLACE', "F" ) == "T" )
   cImage         := ::ReadStringData( cName, 'IMAGE', "" )
   cJustify       := ::ReadStringData( cName, 'JUSTIFY', "" )
   lBreak         := ( ::ReadLogicalData( cName, "BREAK", "F" ) == "T" )
   lEdit          := ( ::ReadLogicalData( cName, 'EDIT', "F" ) == "T" )
   cValid         := ::ReadStringData( cName, 'VALID', "" )
   cWhen          := ::ReadStringData( cName, 'WHEN', "" )
   cValidMess     := ::ReadStringData( cName, 'VALIDMESSAGES', "" )
   lRTL           := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lNoTabStop     := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lFull          := ( ::ReadLogicalData( cName, 'FULLMOVE', "F" ) == "T" )
   lCheckBoxes    := ( ::ReadLogicalData( cName, 'CHECKBOXES', "F" ) == "T" )
   aSelColor      := UpperNIL( ::ReadStringData( cName, 'SELECTEDCOLORS', '' ) )
   cAction        := ::ReadStringData( cName, 'ACTION', "" )
   cAction        := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction        := ::ReadStringData( cName, 'ONCLICK', cAction )
   lButtons       := ( ::ReadLogicalData( cName, 'USEBUTTONS', "F" ) == "T" )
   lDelete        := ( ::ReadLogicalData( cName, 'DELETE', "F" ) == "T" )
   lAppend        := ( ::ReadLogicalData( cName, 'APPEND', "F" ) == "T" )
   cOnAppend      := ::ReadStringData( cName, 'ON APPEND', '' )
   lVirtual       := ( ::ReadLogicalData( cName, 'VIRTUAL', "F" ) == "T" )
   nItemCount     := Val( ::ReadStringData( cName, 'ITEMCOUNT', '0' ) )
   cOnQueryData   := ::ReadStringData( cName, 'ON QUERYDATA', '' )
   lNoHeaders     := ( ::ReadLogicalData( cName, 'NOHEADERS', "F" ) == "T" )
   cHeaderImages  := ::ReadStringData( cName, 'HEADERIMAGES', '' )
   cImagesAlign   := ::ReadStringData( cName, 'IMAGESALIGN', '' )
   lByCell        := ( ::ReadLogicalData( cName, 'NAVIGATEBYCELL', "F" ) == "T" )
   cEditKeys      := ::ReadStringData( cName, 'EDITKEYS', '' )
   lDoubleBuffer  := ( ::ReadLogicalData( cName, 'DOUBLEBUFFER', "F" ) == "T" )
   lSingleBuffer  := ( ::ReadLogicalData( cName, 'SINGLEBUFFER', "F" ) == "T" )
   lFocusRect     := ( ::ReadLogicalData( cName, 'FOCUSRECT', "F" ) == "T" )
   lNoFocusRect   := ( ::ReadLogicalData( cName, 'NOFOCUSRECT', "F" ) == "T" )
   lPLM           := ( ::ReadLogicalData( cName, 'PAINTLEFTMARGIN', "F" ) == "T" )
   lFixedCols     := ( ::ReadLogicalData( cName, 'FIXEDCOLS', "F" ) == "T" )
   cOnAbortEdit   := ::ReadStringData( cName, 'ON ABORTEDIT', '' )
   lFixedWidths   := ( ::ReadLogicalData( cName, 'FIXEDWIDTHS', "F" ) == "T" )
   cBeforeColMove := ::ReadStringData( cName, 'BEFORECOLMOVE', '' )
   cAfterColMove  := ::ReadStringData( cName, 'AFTERCOLMOVE', '' )
   cBeforeColSize := ::ReadStringData( cName, 'BEFORECOLSIZE', '' )
   cAfterColSize  := ::ReadStringData( cName, 'AFTERCOLSIZE', '' )
   cBeforeAutoFit := ::ReadStringData( cName, 'BEFOREAUTOFIT', '' )
   lLikeExcel     := ( ::ReadLogicalData( cName, 'EDITLIKEEXCEL', "F" ) == "T" )
   cDeleteWhen    := ::ReadStringData( cName, 'DELETEWHEN', '' )
   cDeleteMsg     := ::ReadStringData( cName, 'DELETEMSG', '' )
   cOnDelete      := ::ReadStringData( cName, 'ON DELETE', '' )
   lNoDeleteMsg   := ( ::ReadLogicalData( cName, 'NODELETEMSG', "F" ) == "T" )
   lNoModalEdit   := ( ::ReadLogicalData( cName, 'NOMODALEDIT', "F" ) == "T" )
   lFixedCtrls    := ( ::ReadLogicalData( cName, 'FIXEDCONTROLS', "F" ) == "T" )
   lDynamicCtrls  := ( ::ReadLogicalData( cName, 'DYNAMICCONTROLS', "F" ) == "T" )
   cOnHeadRClick  := ::ReadStringData( cName, 'ON HEADRCLICK', '' )
   lNoClickOnChk  := ( ::ReadLogicalData( cName, 'NOCLICKONCHECKBOX', "F" ) == "T" )
   lNoRClickOnChk := ( ::ReadLogicalData( cName, 'NORCLICKONCHECKBOX', "F" ) == "T" )
   lExtDblClick   := ( ::ReadLogicalData( cName, 'EXTDBLCLICK', "F" ) == "T" )
   cSubClass      := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]         := 'GRID'
   ::aCObj[i]             := cObj
   ::aFontName[i]         := cFontName
   ::aFontSize[i]         := nFontSize
   ::aFontColor[i]        := aFontColor
   ::aBold[i]             := lBold
   ::aFontItalic[i]       := lItalic
   ::aFontUnderline[i]    := lUnderline
   ::aFontStrikeout[i]    := lStrikeout
   ::aBackColor[i]        := aBackColor
   ::aVisible[i]          := lVisible
   ::aEnabled[i]          := lEnabled
   ::aToolTip[i]          := cToolTip
   ::aOnChange[i]         := cOnChange
   ::aOnGotFocus[i]       := cOnGotFocus
   ::aOnLostFocus[i]      := cOnLostFocus
   ::aOnDblClick[i]       := cOnDblClick
   ::aOnEnter[i]          := cOnEnter
   ::aOnHeadClick[i]      := cOnHeadClick
   ::aOnEditCell[i]       := cOnEditCell
   ::aOnCheckChg[i]       := cOnCheckChg
   ::aHelpID[i]           := nHelpId
   ::aHeaders[i]          := cHeaders
   ::aWidths[i]           := cWidths
   ::aItems[i]            := cItems
   ::aValueN[i]           := nValue
   ::aDynamicBackColor[i] := cDynBackColor
   ::aDynamicForeColor[i] := cDynForecolor
   ::aColumnControls[i]   := cColControls
   ::aReadOnlyB[i]        := cReadOnly
   ::aInputMask[i]        := cInputMask
   ::aMultiSelect[i]      := lMultiSelect
   ::aNoLines[i]          := lNoLines
   ::aInPlace[i]          := lInPlace
   ::aImage[i]            := cImage
   ::aJustify[i]          := cJustify
   ::aBreak[i]            := lBreak
   ::aEdit[i]             := lEdit
   ::aValid[i]            := cValid
   ::aWhen[i]             := cWhen
   ::aValidMess[i]        := cValidMess
   ::aRTL[i]              := lRTL
   ::aNoTabStop[i]        := lNoTabStop
   ::aFull[i]             := lFull
   ::aCheckBoxes[i]       := lCheckBoxes
   ::aSelColor[i]         := aSelColor
   ::aAction[i]           := cAction
   ::aButtons[i]          := lButtons
   ::aDelete[i]           := lDelete
   ::aAppend[i]           := lAppend
   ::aOnAppend[i]         := cOnAppend
   ::aVirtual[i]          := lVirtual
   ::aItemCount[i]        := nItemCount
   ::aOnQueryData[i]      := cOnQueryData
   ::aNoHeaders[i]        := lNoHeaders
   ::aHeaderImages[i]     := cHeaderImages
   ::aImagesAlign[i]      := cImagesAlign
   ::aByCell[i]           := lByCell
   ::aEditKeys[i]         := cEditKeys
   ::aDoubleBuffer[i]     := lDoubleBuffer
   ::aSingleBuffer[i]     := lSingleBuffer
   ::aFocusRect[i]        := lFocusRect
   ::aNoFocusRect[i]      := lNoFocusRect
   ::aPLM[i]              := lPLM
   ::aFixedCols[i]        := lFixedCols
   ::aOnAbortEdit[i]      := cOnAbortEdit
   ::aFixedWidths[i]      := lFixedWidths
   ::aBeforeColMove[i]    := cBeforeColMove
   ::aAfterColMove[i]     := cAfterColMove
   ::aBeforeColSize[i]    := cBeforeColSize
   ::aAfterColSize[i]     := cAfterColSize
   ::aBeforeAutoFit[i]    := cBeforeAutoFit
   ::aLikeExcel[i]        := lLikeExcel
   ::aDeleteWhen[i]       := cDeleteWhen
   ::aDeleteMsg[i]        := cDeleteMsg
   ::aOnDelete[i]         := cOnDelete
   ::aNoDelMsg[i]         := lNoDeleteMsg
   ::aNoModalEdit[i]      := lNoModalEdit
   ::aFixedCtrls[i]       := lFixedCtrls
   ::aDynamicCtrls[i]     := lDynamicCtrls
   ::aOnHeadRClick[i]     := cOnHeadRClick
   ::aNoClickOnCheck[i]   := lNoClickOnChk
   ::aNoRClickOnCheck[i]  := lNoRClickOnChk
   ::aExtDblClick[i]      := lExtDblClick
   ::aSubClass[i]         := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pHotKeyBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cSubClass, cValue, cFontName
LOCAL nFontSize, lBold, lItalic, lUnderline, lStrikeout, lRTL, aBackColor
LOCAL aFontColor, cToolTip, cOnChange, cOnGotFocus, cOnLostFocus, cOnEnter
LOCAL nHelpId, lEnabled, lVisible, lNoTabStop, lNoAlt, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( THotKeyBox():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( THotKeyBox():nHeight ) ) ) )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )
   cValue       := ::ReadStringData( cName, 'VALUE', '')
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnEnter     := ::ReadStringData( cName, 'ON ENTER', '' )
   nHelpId      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lNoAlt       := ( ::ReadLogicalData( cName, 'NOALT', "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]      := 'HOTKEYBOX'
   ::aCObj[i]          := cObj
   ::aSubClass[i]      := cSubClass
   ::aValue[i]         := cValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aRTL[i]           := lRTL
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnEnter[i]       := cOnEnter
   ::aHelpID[i]        := nHelpId
   ::aEnabled[i]       := lEnabled
   ::aVisible[i]       := lVisible
   ::aNoTabStop[i]     := lNoTabStop
   ::aNoPrefix[i]      := lNoAlt

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pHyplink( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cValue, cAddress, cFontName
LOCAL nFontSize, aFontColor, lBold, lItalic, aBackColor
LOCAL lVisible, lEnabled, cToolTip, nHelpID, lHandCursor, lAutoSize, lBorder
LOCAL lClientEdge, lHScroll, lVScroll, lTrans, lRTL, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( THyperLink():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( THyperLink():nHeight ) ) ) )
   cValue       := ::Clean( ::ReadStringData( cName, 'VALUE', 'ooHG Home' ) )
   cAddress     := ::Clean( ::ReadStringData( cName, 'ADDRESS', 'https://sourceforge.net/projects/oohg/' ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   nHelpID      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lHandCursor  := ( ::ReadLogicalData( cName, 'HANDCURSOR', 'F' ) == 'T' )
   lAutoSize    := ( ::ReadLogicalData( cName, "AUTOSIZE", "F" ) == "T" )
   lBorder      := ( ::ReadLogicalData( cName, "BORDER", "F" ) == "T" )
   lClientEdge  := ( ::ReadLogicalData( cName, "CLIENTEDGE", "F") == "T" )
   lHScroll     := ( ::ReadLogicalData( cName, "HSCROLL", "F" ) == "T" )
   lVScroll     := ( ::ReadLogicalData( cName, "VSCROLL", "F" ) == "T" )
   lTrans       := ( ::ReadLogicalData( cName, "TRANSPARENT", "F" ) == "T" )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]      := 'HYPERLINK'
   ::aCObj[i]          := cObj
   ::aValue[i]         := cValue
   ::aAddress[i]       := cAddress
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aHelpID[i]        := nHelpId
   ::aHandCursor[i]    := lHandCursor
   ::aAutoPlay[i]      := lAutoSize
   ::aBorder[i]        := lBorder
   ::aClientEdge[i]    := lClientEdge
   ::aNoHScroll[i]     := lHScroll
   ::aNoVScroll[i]     := lVScroll
   ::aTransparent[i]   := lTrans
   ::aRTL[i]           := lRTL

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pImage( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cAction, cPicture, lStretch
LOCAL cToolTip, lBorder, lClientEdge, lVisible, lEnabled, lTrans, nHelpId
LOCAL aBackColor, lRTL, cBuffer, cHBitmap, lNoLoadTrans, lNoDIBSection
LOCAL lNo3DColors, lFit, lWhiteBack, lImageSize, cExclude, cSubClass, oCtrl

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::ReadStringData( cName, 'OBJ', '' )
   nRow          := Val( ::ReadCtrlRow( cName ) )
   nCol          := Val( ::ReadCtrlCol( cName ) )
   nWidth        := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TImage():nWidth ) ) ) )
   nHeight       := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TImage():nHeight ) ) ) )
   cAction       := ::ReadStringData( cName, 'ACTION', "" )
   cAction       := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction       := ::ReadStringData( cName, 'ONCLICK', cAction )
   cPicture      := ::Clean( ::ReadStringData(cName, 'PICTURE', '' ) )
   lStretch      := ( ::ReadLogicalData( cName, 'STRETCH', "F") == "T" )
   cToolTip      := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   lBorder       := ( ::ReadLogicalData( cName, "BORDER", "F" ) == "T" )
   lClientEdge   := ( ::ReadLogicalData( cName, "CLIENTEDGE", "F") == "T" )
   lVisible      := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lTrans        := ( ::ReadLogicalData( cName, "TRANSPARENT", "F" ) == "T" )
   nHelpId       := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   aBackColor    := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lRTL          := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cBuffer       := ::ReadStringData( cName, 'BUFFER', "" )
   cHBitmap      := ::ReadStringData( cName, 'HBITMAP', "" )
   lNoLoadTrans  := ( ::ReadLogicalData( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lNoDIBSection := ( ::ReadLogicalData( cName, 'NODIBSECTION', "F" ) == "T" )
   lNo3DColors   := ( ::ReadLogicalData( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit          := ( ::ReadLogicalData( cName, 'NORESIZE', "F" ) == "T" )
   lWhiteBack    := ( ::ReadLogicalData( cName, 'WHITEBACKGROUND', "F" ) == "T" )
   lImageSize    := ( ::ReadLogicalData( cName, 'IMAGESIZE', "F" ) == "T" )
   cExclude      := ::ReadStringData( cName, 'EXCLUDEAREA', "" )
   cSubClass     := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]    := 'IMAGE'
   ::aCObj[i]        := cObj
   ::aAction[i]      := cAction
   ::aPicture[i]     := cPicture
   ::aStretch[i]     := lStretch
   ::aToolTip[i]     := cToolTip
   ::aBorder[i]      := lBorder
   ::aClientEdge[i]  := lClientEdge
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled
   ::aTransparent[i] := lTrans
   ::aHelpID[i]      := nHelpid
   ::aBackColor[i]   := aBackColor
   ::aRTL[i]         := lRTL
   ::aBuffer[i]      := cBuffer
   ::aHBitmap[i]     := cHBitmap
   ::aNoLoadTrans[i] := lNoLoadTrans
   ::aDIBSection[i]  := lNoDIBSection
   ::aNo3DColors[i]  := lNo3DColors
   ::aFit[i]         := lFit
   ::aWhiteBack[i]   := lWhiteBack
   ::aImageSize[i]   := lImageSize
   ::aExclude[i]     := cExclude
   ::aSubClass[i]    := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pIpAddress( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cValue, cFontName, nFontSize
LOCAL aFontColor, lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible
LOCAL lEnabled, cToolTip, cOnChange, cOngotfocus, cOnLostfocus, nHelpId
LOCAL lNoTabStop, lRTL, cSubClass, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TIpAddress():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TIpAddress():nHeight ) ) ) )
   cValue       := ::Clean( ::ReadStringData( cName, 'VALUE', '' ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotfocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostfocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'IPADDRESS'
   ::aCObj[i]          := cObj
   ::aValue[i]         := cValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpId
   ::aNoTabStop[i]     := lNoTabStop
   ::aRTL[i]           := lRTL
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pLabel( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cAction, cToolTip, lBorder
LOCAL lClientEdge, lVisible, lEnabled, lTrans, nHelpId, aBackColor, cValue
LOCAL cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout
LOCAL lRightAlign, lCenterAlign, lAutoSize, cInputMask, lHScroll, lVScroll
LOCAL lRTL, lNoWrap, lNoPrefix, cSubClass, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TLabel():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TLabel():nHeight ) ) ) )
   cAction      := ::ReadStringData( cName, 'ACTION', "" )
   cAction      := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction      := ::ReadStringData( cName, 'ONCLICK', cAction )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   lBorder      := ( ::ReadLogicalData( cName, "BORDER", "F" ) == "T" )
   lClientEdge  := ( ::ReadLogicalData( cName, "CLIENTEDGE", "F") == "T" )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper(  ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper(  ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lTrans       := ( ::ReadLogicalData( cName, "TRANSPARENT", "F" ) == "T" )
   nHelpId      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   cValue       := ::Clean( ::ReadStringData( cName, 'VALUE', '' ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lRightAlign  := ( ::ReadLogicalData( cName, "RIGHTALIGN", "F" ) == "T" )
   lCenterAlign := ( ::ReadLogicalData( cName, "CENTERALIGN", "F" ) == "T" )
   lAutoSize    := ( ::ReadLogicalData( cName, "AUTOSIZE", "F" ) == "T" )
   cInputMask   := ::ReadStringData( cName, 'INPUTMASK', "" )
   lHScroll     := ( ::ReadLogicalData( cName, "HSCROLL", "F" ) == "T" )
   lVScroll     := ( ::ReadLogicalData( cName, "VSCROLL", "F" ) == "T" )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lNoWrap      := ( ::ReadLogicalData( cName, 'NOWORDWRAP', "F" ) == "T" )
   lNoPrefix    := ( ::ReadLogicalData( cName, 'NOPREFIX', "F" ) == "T" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'LABEL'
   ::aCObj[i]          := cObj
   ::aAction[i]        := cAction
   ::aToolTip[i]       := cToolTip
   ::aBorder[i]        := lBorder
   ::aClientEdge[i]    := lClientEdge
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aTransparent[i]   := lTrans
   ::aHelpID[i]        := nHelpid
   ::aBackColor[i]     := aBackColor
   ::aValue[i]         := cValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aRightAlign[i]    := lRightAlign
   ::aCenterAlign[i]   := lCenterAlign
   ::aAutoPlay[i]      := lAutoSize
   ::aInputMask[i]     := cInputMask
   ::aNoHScroll[i]     := lHScroll
   ::aNoVScroll[i]     := lVScroll
   ::aRTL[i]           := lRTL
   ::aWrap[i]          := lNoWrap
   ::aNoPrefix[i]      := lNoPrefix
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pListBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cToolTip, nHelpId, cFontName
LOCAL nFontSize, lBold, lItalic, lUnderline, lStrikeout, aBackColor, aFontColor
LOCAL lVisible, lEnabled, lRTL, cOnEnter, lNoVScroll, cImage, lFit, nTextHeight
LOCAL cOnGotFocus, cOnLostFocus, cOnChange, cOnDblClick, cItems, nValue
LOCAL lMultiSelect, lNoTabStop, lBreak, lSort, cSubClass, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TList():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TList():nHeight ) ) ) )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   nHelpId      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cOnEnter     := ::ReadStringData( cName, 'ON ENTER', '' )
   lNoVScroll   := ( ::ReadLogicalData( cName, "NOVSCROLL", "F" ) == "T" )
   cImage       := ::Clean( ::ReadStringData( cName, 'IMAGE', '' ) )
   lFit         := ( ::ReadLogicalData( cName, 'FIT', "F" ) == "T" )
   nTextHeight  := Val( ::ReadStringData( cName, 'TEXTHEIGHT', '0' ) )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnDblClick  := ::ReadStringData( cName, 'ON DBLCLICK', '' )
   cItems       := ::ReadStringData( cName, 'ITEMS', '' )
   nValue       := Val( ::ReadStringData( cName, 'VALUE', '0' ) )
   lMultiSelect := ( ::ReadLogicalData( cName, 'MULTISELECT', "F" ) == "T" )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   lBreak       := ( ::ReadLogicalData( cName, 'BREAK', "F" ) == "T" )
   lSort        := ( ::ReadLogicalData( cName, 'SORT', "F" ) == "T" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'LIST'
   ::aCObj[i]          := cObj
   ::aToolTip[i]       := cToolTip
   ::aHelpID[i]        := nHelpid
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aOnEnter[i]       := cOnEnter
   ::aNoVScroll[i]     := lNoVScroll
   ::aImage[i]         := cImage
   ::aFit[i]           := lFit
   ::aTextHeight[i]    := nTextHeight
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnChange[i]      := cOnChange
   ::aOnDblClick[i]    := cOnDblClick
   ::aItems[i]         := cItems
   ::aValueN[i]        := nValue
   ::aMultiSelect[i]   := lMultiSelect
   ::aNoTabStop[i]     := lNoTabStop
   ::aBreak[i]         := lBreak
   ::aSort[i]          := lSort
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pMonthcal( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, cValue, cFontName, nFontSize, aFontColor, lBold
LOCAL lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip
LOCAL nHelpID, cOnChange, aBckgrndClr, lNoTodayCircle, lWeekNumbers, lNoTabStop
LOCAL lRTL, lNoToday, aTitleFntClr, aTitleBckClr, aTrlngFntClr, cSubClass, oCtrl

   // Load properties
   cName          := ::aControlW[i]
   cObj           := ::ReadStringData( cName, 'OBJ', '' )
   nRow           := Val( ::ReadCtrlRow( cName ) )
   nCol           := Val( ::ReadCtrlCol( cName ) )
   cValue         :=  ::ReadStringData( cName, 'VALUE', '' )
   cFontName      := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize      := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor     := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold          := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor     := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible       := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled       := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip       := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   nHelpID        := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cOnChange      := ::ReadStringData( cName, 'ON CHANGE', '' )
   lNoToday       := ( ::ReadLogicalData( cName, 'NOTODAY', 'F' ) == 'T' )
   lNoTodayCircle := ( ::ReadLogicalData( cName, 'NOTODAYCIRCLE', 'F' ) == 'T' )
   lWeekNumbers   := ( ::ReadLogicalData( cName, 'WEEKNUMBERS', 'F' ) == 'T' )
   lNoTabStop     := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == 'T' )
   lRTL           := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cSubClass      := ::ReadStringData( cName, 'SUBCLASS', '' )
   aTitleFntClr   := ::ReadStringData( cName, 'TITLEFONTCOLOR', 'NIL' )
   aTitleBckClr   := ::ReadStringData( cName, 'TITLEBACKCOLOR', 'NIL' )
   aTrlngFntClr   := ::ReadStringData( cName, 'TRAILINGFONTCOLOR', 'NIL' )
   aBckgrndClr    := ::ReadStringData( cName, 'BACKGROUNDCOLOR', 'NIL' )

   // Save properties
   ::aCtrlType[i]          := 'MONTHCALENDAR'
   ::aCObj[i]              := cObj
   ::aValue[i]             := cValue
   ::aFontName[i]          := cFontName
   ::aFontSize[i]          := nFontSize
   ::aFontColor[i]         := aFontColor
   ::aBold[i]              := lBold
   ::aFontItalic[i]        := lItalic
   ::aFontUnderline[i]     := lUnderline
   ::aFontStrikeout[i]     := lStrikeout
   ::aBackColor[i]         := aBackColor
   ::aVisible[i]           := lVisible
   ::aEnabled[i]           := lEnabled
   ::aToolTip[i]           := cToolTip
   ::aHelpID[i]            := nHelpId
   ::aOnChange[i]          := cOnChange
   ::aNoToday[i]           := lNoToday
   ::aNoTodayCircle[i]     := lNoTodayCircle
   ::aWeekNumbers[i]       := lWeekNumbers
   ::aNoTabStop[i]         := lNoTabStop
   ::aRTL[i]               := lRTL
   ::aSubClass[i]          := cSubClass
   ::aTitleFontColor[i]    := aTitleFntClr
   ::aTitleBackColor[i]    := aTitleBckClr
   ::aTrailingFontColor[i] := aTrlngFntClr
   ::aBackgroundColor[i]   := aBckgrndClr

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, 0, 0, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pPicButt( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnGotFocus, cOnLostFocus, nHelpId, cPicture, cAction
LOCAL lNoTabStop, lFlat, cBuffer, cHBitmap, lNoLoadTrans, lForceScale
LOCAL lNo3DColors, lFit, lDIBSection, cOnMouseMove, lThemed, cImgMargin, lTop
LOCAL lBottom, lLeft, lRight, lCenter, lCancel, cSubClass, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TButton():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TButton():nHeight ) ) ) )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cPicture     := ::Clean( ::ReadStringData( cName, 'PICTURE', '' ) )
   cPicture     := IIF( Empty( cPicture ), 'A4', cPicture )
   cAction      := ::ReadStringData( cName, 'ACTION', "MsgInfo( 'Button pressed' )" )
   cAction      := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction      := ::ReadStringData( cName, 'ONCLICK', cAction )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   lFlat        := ( ::ReadLogicalData( cName, 'FLAT', "F" ) == "T" )
   cBuffer      := ::ReadStringData( cName, 'BUFFER', "" )
   cHBitmap     := ::ReadStringData( cName, 'HBITMAP', "" )
   lNoLoadTrans := ( ::ReadLogicalData( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lForceScale  := ( ::ReadLogicalData( cName, 'FORCESCALE', "F" ) == "T" )
   lNo3DColors  := ( ::ReadLogicalData( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit         := ::ReadLogicalData( cName, 'AUTOFIT', "F" )
   lFit         := ( ::ReadLogicalData( cName, 'ADJUST', lFit ) == "T" )
   lDIBSection  := ( ::ReadLogicalData( cName, 'DIBSECTION', "F" ) == "T" )
   cOnMouseMove := ::ReadStringData( cName, 'ON MOUSEMOVE', '' )
   lThemed      := ( ::ReadLogicalData( cName, 'THEMED', "F" ) == "T" )
   cImgMargin   := ::ReadStringData( cName, 'IMAGEMARGIN', "" )
   lTop         := ( ::ReadLogicalData( cName, 'TOP', "F" ) == "T" )
   lBottom      := ( ::ReadLogicalData( cName, 'BOTTOM', "F" ) == "T" )
   lLeft        := ( ::ReadLogicalData( cName, 'LEFT', "F" ) == "T" )
   lRight       := ( ::ReadLogicalData( cName, 'RIGHT', "F" ) == "T" )
   lCenter      := ( ::ReadLogicalData( cName, 'CENTER', "F" ) == "T" )
   lCancel      := ( ::ReadLogicalData( cName, 'CANCEL', "F" ) == "T" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]    := 'PICBUTT'
   ::aCObj[i]        := cObj
   ::aBackColor[i]   := aBackColor
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled
   ::aToolTip[i]     := cToolTip
   ::aOnGotFocus[i]  := cOnGotFocus
   ::aOnLostFocus[i] := cOnLostFocus
   ::aHelpID[i]      := nHelpId
   ::aPicture[i]     := cPicture
   ::aAction[i]      := cAction
   ::aNoTabStop[i]   := lNoTabStop
   ::aFlat[i]        := lFlat
   ::aBuffer[i]      := cBuffer
   ::aHBitmap[i]     := cHBitmap
   ::aNoLoadTrans[i] := lNoLoadTrans
   ::aForceScale[i]  := lForceScale
   ::aNo3DColors[i]  := lNo3DColors
   ::aFit[i]         := lFit
   ::aDIBSection[i]  := lDIBSection
   ::aOnMouseMove[i] := cOnMouseMove
   ::aThemed[i]      := lThemed
   ::aImageMargin[i] := cImgMargin
   ::aJustify[i]     := IIF( lTop, "TOP", IIF( lBottom, "BOTTOM", IIF( lLeft, "LEFT", IIF( lRight, "RIGHT", IIF( lCenter, "CENTER", "" ) ) ) ) )
   ::aCancel[i]      := lCancel
   ::aSubClass[i]    := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pPicCheckButt( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cPicture, lValue, cToolTip
LOCAL lNoTabStop, cOnChange, cOnGotFocus, cOnLostFocus, nHelpId, lEnabled
LOCAL lVisible, cBuffer, cHBitmap, lNoLoadTrans, lForceScale, cField, oCtrl
LOCAL lNo3DColors, lFit, lDIBSection, lThemed, aBackColor, cOnMouseMove
LOCAL cImgMargin, lFlat, lTop, lBottom, lLeft, lRight, lCenter, cSubClass

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TButtonCheck():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TButtonCheck():nHeight ) ) ) )
   cPicture     := ::Clean( ::ReadStringData( cName, 'PICTURE', 'A4' ) )
   cPicture     := IIF( Empty( cPicture ), 'A4', cPicture )
   lValue       := ( ::ReadLogicalData( cName, 'VALUE', 'F' ) == "T" )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   cBuffer      := ::ReadStringData( cName, 'BUFFER', "" )
   cHBitmap     := ::ReadStringData( cName, 'HBITMAP', "" )
   lNoLoadTrans := ( ::ReadLogicalData( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lForceScale  := ( ::ReadLogicalData( cName, 'FORCESCALE', "F" ) == "T" )
   cField       := ::ReadStringData( cName, 'FIELD', '' )
   lNo3DColors  := ( ::ReadLogicalData( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit         := ::ReadLogicalData( cName, 'AUTOFIT', "F" )
   lFit         := ( ::ReadLogicalData( cName, 'ADJUST', lFit ) == "T" )
   lDIBSection  := ( ::ReadLogicalData( cName, 'DIBSECTION', "F" ) == "T" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )
   lThemed      := ( ::ReadLogicalData( cName, 'THEMED', "F" ) == "T" )
   cImgMargin   := ::ReadStringData( cName, 'IMAGEMARGIN', "" )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   cOnMouseMove := ::ReadStringData( cName, 'ON MOUSEMOVE', '' )
   lFlat        := ( ::ReadLogicalData( cName, 'FLAT', "F" ) == "T" )
   lTop         := ( ::ReadLogicalData( cName, 'TOP', "F" ) == "T" )
   lBottom      := ( ::ReadLogicalData( cName, 'BOTTOM', "F" ) == "T" )
   lLeft        := ( ::ReadLogicalData( cName, 'LEFT', "F" ) == "T" )
   lRight       := ( ::ReadLogicalData( cName, 'RIGHT', "F" ) == "T" )
   lCenter      := ( ::ReadLogicalData( cName, 'CENTER', "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]    := 'PICCHECKBUTT'
   ::aCObj[i]        := cObj
   ::aPicture[i]     := cPicture
   ::aValueL[i]      := lValue
   ::aToolTip[i]     := cToolTip
   ::aNoTabStop[i]   := lNoTabStop
   ::aOnChange[i]    := cOnChange
   ::aOnGotFocus[i]  := cOnGotFocus
   ::aOnLostFocus[i] := cOnLostFocus
   ::aHelpID[i]      := nHelpId
   ::aEnabled[i]     := lEnabled
   ::aVisible[i]     := lVisible
   ::aBuffer[i]      := cBuffer
   ::aHBitmap[i]     := cHBitmap
   ::aNoLoadTrans[i] := lNoLoadTrans
   ::aForceScale[i]  := lForceScale
   ::aField[i]       := cField
   ::aNo3DColors[i]  := lNo3DColors
   ::aFit[i]         := lFit
   ::aDIBSection[i]  := lDIBSection
   ::aThemed[i]      := lThemed
   ::aBackColor[i]   := aBackColor
   ::aOnMouseMove[i] := cOnMouseMove
   ::aImageMargin[i] := cImgMargin
   ::aFlat[i]        := lFlat
   ::aJustify[i]     := IIF( lTop, "TOP", IIF( lBottom, "BOTTOM", IIF( lLeft, "LEFT", IIF( lRight, "RIGHT", IIF( lCenter, "CENTER", "" ) ) ) ) )
   ::aSubClass[i]    := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pPicture( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cAction, cPicture, lStretch
LOCAL cToolTip, lBorder, lClientEdge, lVisible, lEnabled, lTrans, nHelpId
LOCAL aBackColor, lRTL, cBuffer, cHBitmap, lNoLoadTrans, lNoDIBSection
LOCAL lNo3DColors, lForceScale, lImageSize, cExclude, cSubClass, oCtrl

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::ReadStringData( cName, 'OBJ', '' )
   nRow          := Val( ::ReadCtrlRow( cName ) )
   nCol          := Val( ::ReadCtrlCol( cName ) )
   nWidth        := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TPicture():nWidth ) ) ) )
   nHeight       := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TPicture():nHeight ) ) ) )
   cAction       := ::ReadStringData( cName, 'ACTION', "" )
   cAction       := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction       := ::ReadStringData( cName, 'ONCLICK', cAction )
   cPicture      := ::Clean( ::ReadStringData(cName, 'PICTURE', '' ) )
   lStretch      := ( ::ReadLogicalData( cName, 'STRETCH', "F") == "T" )
   cToolTip      := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   lBorder       := ( ::ReadLogicalData( cName, "BORDER", "F" ) == "T" )
   lClientEdge   := ( ::ReadLogicalData( cName, "CLIENTEDGE", "F") == "T" )
   lVisible      := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lTrans        := ( ::ReadLogicalData( cName, "TRANSPARENT", "F" ) == "T" )
   nHelpId       := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   aBackColor    := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lRTL          := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cBuffer       := ::ReadStringData( cName, 'BUFFER', "" )
   cHBitmap      := ::ReadStringData( cName, 'HBITMAP', "" )
   lNoLoadTrans  := ( ::ReadLogicalData( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lNoDIBSection := ( ::ReadLogicalData( cName, 'NODIBSECTION', "F" ) == "T" )
   lNo3DColors   := ( ::ReadLogicalData( cName, 'NO3DCOLORS', "F" ) == "T" )
   lForceScale   := ( ::ReadLogicalData( cName, 'FORCESCALE', "F" ) == "T" )
   lImageSize    := ( ::ReadLogicalData( cName, 'IMAGESIZE', "F" ) == "T" )
   cExclude      := ::ReadStringData( cName, 'EXCLUDEAREA', "" )
   cSubClass     := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]    := 'PICTURE'
   ::aCObj[i]        := cObj
   ::aAction[i]      := cAction
   ::aPicture[i]     := cPicture
   ::aStretch[i]     := lStretch
   ::aToolTip[i]     := cToolTip
   ::aBorder[i]      := lBorder
   ::aClientEdge[i]  := lClientEdge
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled
   ::aTransparent[i] := lTrans
   ::aHelpID[i]      := nHelpid
   ::aBackColor[i]   := aBackColor
   ::aRTL[i]         := lRTL
   ::aBuffer[i]      := cBuffer
   ::aHBitmap[i]     := cHBitmap
   ::aNoLoadTrans[i] := lNoLoadTrans
   ::aDIBSection[i]  := lNoDIBSection
   ::aNo3DColors[i]  := lNo3DColors
   ::aForceScale[i]  := lForceScale
   ::aImageSize[i]   := lImageSize
   ::aExclude[i]     := cExclude
   ::aSubClass[i]    := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pPlayer( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, nHelpId, cFile, lNoTabStop
LOCAL lVisible, lEnabled, lRTL, lNoAutoSizeW, lNoAutoSizeM, lNoErrorDlg, lNoMenu
LOCAL lNoOpen, lNoPlayBar, lShowAll, lShowMode, lShowName, lShowPosition
LOCAL cSubClass, oCtrl

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::ReadStringData( cName, 'OBJ', '' )
   nRow          := Val( ::ReadCtrlRow( cName ) )
   nCol          := Val( ::ReadCtrlCol( cName ) )
   nWidth        := Val( ::ReadStringData( cName, 'WIDTH', '100' ) )
   nHeight       := Val( ::ReadStringData( cName, 'HEIGHT', '100' ) )
   nHelpId       := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cFile         := ::Clean( ::ReadStringData( cName, 'FILE', '' ) )
   lNoTabStop    := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lVisible      := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper(  ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper(  ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL          := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lNoAutoSizeW  := ( ::ReadLogicalData( cName, 'NOAUTOSIZEWINDOW', "F" ) == "T" )
   lNoAutoSizeM  := ( ::ReadLogicalData( cName, 'NOAUTOSIZEMOVIE', "F" ) == "T" )
   lNoErrorDlg   := ( ::ReadLogicalData( cName, 'NOERRORDLG', "F" ) == "T" )
   lNoMenu       := ( ::ReadLogicalData( cName, 'NOMENU', "F" ) == "T" )
   lNoOpen       := ( ::ReadLogicalData( cName, 'NOOPEN', "F" ) == "T" )
   lNoPlayBar    := ( ::ReadLogicalData( cName, 'NOPLAYBAR', "F" ) == "T" )
   lShowAll      := ( ::ReadLogicalData( cName, 'SHOWALL', "F" ) == "T" )
   lShowMode     := ( ::ReadLogicalData( cName, 'SHOWMODE', "F" ) == "T" )
   lShowName     := ( ::ReadLogicalData( cName, 'SHOWNAME', "F" ) == "T" )
   lShowPosition := ( ::ReadLogicalData( cName, 'SHOWPOSITION', "F" ) == "T" )
   cSubClass     := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]         := 'PLAYER'
   ::aCObj[i]             := cObj
   ::aHelpID[i]           := nHelpid
   ::aFile[i]             := cFile
   ::aNoTabStop[i]        := lNoTabStop
   ::aVisible[i]          := lVisible
   ::aEnabled[i]          := lEnabled
   ::aRTL[i]              := lRTL
   ::aNoAutoSizeWindow[i] := lNoAutoSizeW
   ::aNoAutoSizeMovie[i]  := lNoAutoSizeM
   ::aNoErrorDlg[i]       := lNoErrorDlg
   ::aNoMenu[i]           := lNoMenu
   ::aNoOpen[i]           := lNoOpen
   ::aNoPlayBar[i]        := lNoPlayBar
   ::aShowAll[i]          := lShowAll
   ::aShowMode[i]         := lShowMode
   ::aShowName[i]         := lShowName
   ::aShowPosition[i]     := lShowPosition
   ::aSubClass[i]         := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pProgressbar( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, lVertical, nWidth, nHeight, cRange, cToolTip
LOCAL lSmooth, nHelpId, lVisible, lEnabled, aBackColor, aFontColor, nValue
LOCAL lRTL, nMarquee, oCtrl

   // Load properties
   cName      := ::aControlW[i]
   cObj       := ::ReadStringData( cName, 'OBJ', '' )
   nRow       := Val( ::ReadCtrlRow( cName ) )
   nCol       := Val( ::ReadCtrlCol( cName ) )
   lVertical  := ( ::ReadLogicalData( cName, 'VERTICAL', 'F' ) == "T" )
   IF lVertical
      nWidth  := Val( ::ReadStringData( cName, 'WIDTH', '25' ) )
      nHeight := Val( ::ReadStringData( cName, 'HEIGHT', '120' ) )
   ELSE
      nWidth  := Val( ::ReadStringData( cName, 'WIDTH', '120' ) )
      nHeight := Val( ::ReadStringData( cName, 'HEIGHT', '25' ) )
   ENDIF
   cRange     := ::ReadStringData( cName, 'RANGE', '' )
   cToolTip   := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   lSmooth    := ( ::ReadLogicalData( cName, 'SMOOTH', 'F' ) == "T" )
   nHelpId    := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lVisible   := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper(  ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper(  ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor := ::ReadStringData( cName, 'FORECOLOR', 'NIL' )
   aFontColor := UpperNIL( ::ReadOopData( cName, 'FORECOLOR', aFontColor ) )
   nValue     := Val( ::ReadStringData( cName, 'VALUE', '0' ) )
   lRTL       := ( ::ReadLogicalData( cName, 'RTL', 'F' ) == "T" )
   nMarquee   := Val( ::ReadStringData( cName, 'MARQUEE', '0' ) )

   // Save properties
   ::aCtrlType[i]    := 'PROGRESSBAR'
   ::aCObj[i]        := cObj
   ::aVertical[i]    := lVertical
   ::aRange[i]       := cRange
   ::aToolTip[i]     := cToolTip
   ::aSmooth[i]      := lSmooth
   ::aHelpID[i]      := nHelpID
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled
   ::aBackColor[i]   := aBackColor
   ::aFontColor[i]   := aFontColor
   ::aValueN[i]      := nValue
   ::aRTL[i]         := lRTL
   ::aMarquee[i]     := nMarquee

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pProgressMeter( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cAction, cToolTip, lClientEdge
LOCAL lVisible, lEnabled, nHelpId, aBackColor, lRTL, cSubClass, nValue
LOCAL cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout
LOCAL cRange, oCtrl

   // Load properties
   cName       := ::aControlW[i]
   cObj        := ::ReadStringData( cName, 'OBJ', '' )
   nRow        := Val( ::ReadCtrlRow( cName ) )
   nCol        := Val( ::ReadCtrlCol( cName ) )
   nWidth      := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TProgressMeter():nWidth ) ) ) )
   nHeight     := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TProgressMeter():nHeight ) ) ) )
   cAction     := ::ReadStringData( cName, 'ACTION', "" )
   cAction     := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction     := ::ReadStringData( cName, 'ONCLICK', cAction )
   cToolTip    := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   lClientEdge := ( ::ReadLogicalData( cName, "CLIENTEDGE", "F") == "T" )
   lVisible    := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible    := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled    := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled    := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   nHelpId     := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   aBackColor  := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor  := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lRTL        := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cSubClass   := ::ReadStringData( cName, 'SUBCLASS', '' )
   nValue      := Val( ::ReadStringData( cName, 'VALUE', '0') )
   cFontName   := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize   := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor  := ::ReadStringData( cName, 'FORECOLOR', 'NIL' )
   aFontColor  := UpperNIL( ::ReadOopData( cName, 'FORECOLOR', aFontColor ) )
   lBold       := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold       := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic     := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic     := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline  := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline  := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout  := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout  := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   cRange      := ::ReadStringData( cName, 'RANGE', '' )

   // Save properties
   ::aCtrlType[i]      := 'PROGRESSMETER'
   ::aCObj[i]          := cObj
   ::aAction[i]        := cAction
   ::aToolTip[i]       := cToolTip
   ::aClientEdge[i]    := lClientEdge
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aHelpID[i]        := nHelpid
   ::aBackColor[i]     := aBackColor
   ::aRTL[i]           := lRTL
   ::aSubClass[i]      := cSubClass
   ::aValueN[i]        := nValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aRange[i]         := cRange

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pRadiogroup( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nValue, nSpacing, cFontName, nFontSize
LOCAL cToolTip, cOnChange, lTrans, nHelpid, cItems, lVisible, lEnabled, lBold
LOCAL lItalic, lUnderline, lStrikeout, aBackColor, aFontColor, lRTL, lNoTabStop
LOCAL lAutoSize, lHorizontal, lThemed, cBackground, cSubClass, oCtrl, nHeight

   // Load properties
   cName       := ::aControlW[i]
   cObj        := ::ReadStringData( cName, 'OBJ', '' )
   nRow        := Val( ::ReadCtrlRow( cName ) )
   nCol        := Val( ::ReadCtrlCol( cName ) )
   nWidth      := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TRadioGroup():nWidth ) ) ) )
   nHeight     := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TRadioGroup():nHeight ) ) ) )
   nValue      := Val( ::ReadStringData( cName, 'VALUE', '0' ) )
   nSpacing    := Val( ::ReadStringData( cName, 'SPACING', '0' ) )
   cFontName   := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize   := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cToolTip    := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange   := ::ReadStringData( cName, 'ON CHANGE', '' )
   lTrans      := ( ::ReadLogicalData( cName, "TRANSPARENT", "F" ) == "T" )
   nHelpid     := Val( ::ReadStringData(cName, 'HELPID', "0" ) )
   cItems      := ::ReadStringData( cName, 'OPTIONS', "{ 'option 1', 'option 2' }" )
   lVisible    := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible    := ( Upper(  ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled    := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled    := ( Upper(  ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lBold       := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold       := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic     := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic     := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline  := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline  := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout  := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout  := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor  := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor  := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor  := ::ReadStringData( cName, 'FORECOLOR', 'NIL' )
   aFontColor  := UpperNIL( ::ReadOopData( cName, 'FORECOLOR', aFontColor ) )
   lRTL        := ( ::ReadLogicalData( cName, 'RTL', 'F' ) == "T" )
   lNoTabStop  := ( ::ReadLogicalData( cName, "NOTABSTOP", "F" ) == "T" )
   lAutoSize   := ( ::ReadLogicalData( cName, "AUTOSIZE", "F" ) == "T" )
   lHorizontal := ( ::ReadLogicalData( cName, 'HORIZONTAL', "F" ) == "T" )
   lThemed     := ( ::ReadLogicalData( cName, 'THEMED', "F" ) == "T" )
   cBackground := ::ReadStringData( cName, 'BACKGROUND', '' )
   cSubClass   := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'RADIOGROUP'
   ::aCObj[i]          := cObj
   ::aValueN[i]        := nValue
   ::aSpacing[i]       := nSpacing
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aTransparent[i]   := lTrans
   ::aHelpID[i]        := nHelpID
   ::aItems[i]         := cItems
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderLine
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aRTL[i]           := lRTL
   ::aNoTabStop[i]     := lNoTabStop
   ::aAutoPlay[i]      := lAutoSize
   ::aFlat[i]          := lHorizontal
   ::aThemed[i]        := lThemed
   ::aBackground[i]    := cBackground
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pRichedit( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, cValue
LOCAL cField, cToolTip, nMaxLength, lReadonly, lBreak, lNoTabStop, nHelpID
LOCAL cOnChange, cOnGotFocus, cOnLostFocus, lVisible, lEnabled, lBold, lItalic
LOCAL lUnderline, lStrikeout, aFontColor, aBackColor, lRTL, nFocusedPos
LOCAL lNoVScroll, cOnVScroll, cOnHScroll, cFile, cSubClass, cOnSelChange
LOCAL lNoHideSel, lPlainText, nFileType, lNoHScroll, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TEditRich():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TEditRich():nHeight ) ) ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cValue       := ::Clean( ::ReadStringData( cName, 'VALUE', '' ) )
   cField       := ::ReadStringData( cName, 'FIELD', '' )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   nMaxLength   := Val( ::ReadStringData( cName, 'MAXLENGTH', '0' ) )
   lReadonly    := ( ::ReadLogicalData( cName, "READONLY", "F" ) == "T" )
   lBreak       := ( ::ReadLogicalData( cName, "BREAK", "F" ) == "T" )
   lNoTabStop   := ( ::ReadLogicalData( cName, "NOTABSTOP", "F" ) == "T" )
   nHelpID      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   nFocusedPos  := Val( ::ReadStringData( cName, 'FOCUSEDPOS', '-4' ) )
   lNoVScroll   := ( ::ReadLogicalData( cName, "NOVSCROLL", "F" ) == "T" )
   lNoHScroll   := ( ::ReadLogicalData( cName, "NOHSCROLL", "F" ) == "T" )
   cOnVScroll   := ::ReadStringData( cName, 'ON VSCROLL', '' )
   cOnHScroll   := ::ReadStringData( cName, 'ON HSCROLL', '' )
   cFile        := ::Clean( ::ReadStringData( cName, 'FILE', '' ) )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )
   cOnSelChange := ::ReadStringData( cName, 'ON SELCHANGE', '' )
   lNoHideSel   := ( ::ReadLogicalData( cName, "NOHIDESEL", "F" ) == "T" )
   lPlainText   := ( ::ReadLogicalData( cName, "PLAINTEXT", "F" ) == "T" )
   nFileType    := Val( ::ReadLogicalData( cName, "FILETYPE", "0" ) )

   // Save properties
   ::aCtrlType[i]      := 'RICHEDIT'
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aValue[i]         := cValue
   ::aField[i]         := cField
   ::aToolTip[i]       := cTooltip
   ::aMaxLength[i]     := nMaxLength
   ::aReadOnly[i]      := lReadonly
   ::aBreak[i]         := lBreak
   ::aNoTabStop[i]     := lNoTabStop
   ::aHelpID[i]        := nHelpID
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aFontColor[i]     := aFontColor
   ::aBackColor[i]     := aBackColor
   ::aRTL[i]           := lRTL
   ::aFocusedPos[i]    := nFocusedPos
   ::aNoVScroll[i]     := lNoVScroll
   ::aNoHScroll[i]     := lNoHScroll
   ::aOnVScroll[i]     := cOnVScroll
   ::aOnHScroll[i]     := cOnHScroll
   ::aFile[i]          := cFile
   ::aSubClass[i]      := cSubClass
   ::aOnSelChange[i]   := cOnSelChange
   ::aNoHideSel[i]     := lNoHideSel
   ::aPlainText[i]     := lPlainText
   ::aFileType[i]      := nFileType

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pScrollBar( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cToolTip, nValue, cRange, lRTL
LOCAL cOnChange, cOnLineUp, cOnLineDown, cOnPageUp, cOnPageDown, cOnTop, oCtrl
LOCAL cOnBottom, cOnThumb, cOnTrack, cOnEndTrack, lAutoMove, lAttached, lVisible
LOCAL lVertical, lHorizontal, nLineSkip, nPageSkip, nHelpId, cSubClass, lEnabled

   // Load properties
   cName       := ::aControlW[i]
   cObj        := ::ReadStringData( cName, 'OBJ', '' )
   nRow        := Val( ::ReadCtrlRow( cName ) )
   nCol        := Val( ::ReadCtrlCol( cName ) )
   cToolTip    := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   nValue      := Val( ::ReadStringData( cName, 'VALUE', '0') )
   cRange      := ::ReadStringData( cName, 'RANGE', '' )
   cOnChange   := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnLineUp   := ::ReadStringData( cName, 'ON LINEUP', '' )
   cOnLineUp   := ::ReadStringData( cName, 'ON LINELEFT', cOnLineUp )
   cOnLineDown := ::ReadStringData( cName, 'ON LINEDOWN', '' )
   cOnLineDown := ::ReadStringData( cName, 'ON LINERIGHT', cOnLineDown )
   cOnPageUp   := ::ReadStringData( cName, 'ON PAGEUP', '' )
   cOnPageUp   := ::ReadStringData( cName, 'ON PAGELEFT', cOnPageUp )
   cOnPageDown := ::ReadStringData( cName, 'ON PAGEDOWN', '' )
   cOnPageDown := ::ReadStringData( cName, 'ON PAGERIGHT', cOnPageDown )
   cOnTop      := ::ReadStringData( cName, 'ON TOP', '' )
   cOnTop      := ::ReadStringData( cName, 'ON LEFT', cOnTop )
   cOnBottom   := ::ReadStringData( cName, 'ON BOTTOM', '' )
   cOnBottom   := ::ReadStringData( cName, 'ON RIGHT', cOnBottom )
   cOnThumb    := ::ReadStringData( cName, 'ON THUMB', '' )
   cOnTrack    := ::ReadStringData( cName, 'ON TRACK', '' )
   cOnEndTrack := ::ReadStringData( cName, 'ON ENDTRACK', '' )
   lAutoMove   := ( ::ReadLogicalData( cName, 'AUTOMOVE', "F" ) == "T" )
   lAttached   := ( ::ReadLogicalData( cName, 'ATTACHED', "F" ) == "T" )
   lVertical   := ( ::ReadLogicalData( cName, 'VERTICAL', "F" ) == "T" )
   lHorizontal := ( ::ReadLogicalData( cName, 'HORIZONTAL', "F" ) == "T" )
   nLineSkip   := Val( ::ReadStringData( cName, 'LINESKIP', '0') )
   nPageSkip   := Val( ::ReadStringData( cName, 'PAGESKIP', '0') )
   nHelpId     := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lRTL        := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cSubClass   := ::ReadStringData( cName, 'SUBCLASS', '' )
   lVisible    := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible    := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled    := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled    := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   IF lHorizontal
      nWidth   := Val( ::ReadStringData( cName, 'WIDTH', '100' ) )
      nHeight  := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( GetHScrollBarHeight() ) ) ) )
   ELSE
      nWidth   := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( GetVScrollBarWidth() ) ) ) )
      nHeight  := Val( ::ReadStringData( cName, 'HEIGHT', '100' ) )
   ENDIF

   // Save properties
   ::aCtrlType[i]    := 'SCROLLBAR'
   ::aCObj[i]        := cObj
   ::aToolTip[i]     := cToolTip
   ::aValueN[i]      := nValue
   ::aRange[i]       := cRange
   ::aOnChange[i]    := cOnChange
   ::aOnDblClick[i]  := cOnLineUp
   ::aOnDelete[i]    := cOnLineDown
   ::aOnDrop[i]      := cOnPageUp
   ::aOnEditCell[i]  := cOnPageDown
   ::aOnEnter[i]     := cOnTop
   ::aOnGotFocus[i]  := cOnBottom
   ::aOnHScroll[i]   := cOnThumb
   ::aOnLabelEdit[i] := cOnTrack
   ::aOnListClose[i] := cOnEndTrack
   ::aFlat[i]        := lHorizontal
   ::aVertical[i]    := lVertical
   ::aAutoPlay[i]    := lAutoMove
   ::aAppend[i]      := lAttached
   ::aIncrement[i]   := nLineSkip
   ::aIndent[i]      := nPageSkip
   ::aHelpID[i]      := nHelpid
   ::aRTL[i]         := lRTL
   ::aSubClass[i]    := cSubClass
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pSlider( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cRange, nValue, cToolTip
LOCAL cOnChange, lVertical, lNoTicks, lBoth, lTop, lLeft, nHelpId, aBackColor
LOCAL lVisible, lEnabled, lNoTabStop, lRTL, cSubClass, oCtrl

   // Load properties
   cName      := ::aControlW[i]
   cObj       := ::ReadStringData( cName, 'OBJ', '' )
   nRow       := Val( ::ReadCtrlRow( cName ) )
   nCol       := Val( ::ReadCtrlCol( cName ) )
   nWidth     := Val( ::ReadStringData( cName, 'WIDTH', '0' ) )
   nHeight    := Val( ::ReadStringData( cName, 'HEIGHT', '0' ) )
   cRange     := ::ReadStringData( cName, 'RANGE', '' )
   nValue     := Val( ::ReadStringData( cName, 'VALUE', '0' ) )
   cToolTip   := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange  := ::ReadStringData( cName, 'ON CHANGE', '' )
   lVertical  := ( ::ReadLogicalData( cName, 'VERTICAL', 'F' ) == "T" )
   lNoTicks   := ( ::ReadLogicalData( cName, 'NOTICKS', 'F' ) == "T" )
   lBoth      := ( ::ReadLogicalData( cName, 'BOTH', 'F' ) == "T" )
   lTop       := ( ::ReadLogicalData( cName, 'TOP', 'F' ) == "T" )
   lLeft      := ( ::ReadLogicalData( cName, 'LEFT', 'F' ) == "T" )
   nHelpId    := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   aBackColor := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible   := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper(  ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper(  ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lNoTabStop := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lRTL       := ( ::ReadLogicalData( cName, 'RTL', 'F' ) == "T" )
   cSubClass  := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]  := 'SLIDER'
   ::aCObj[i]      := cObj
   ::aRange[i]     := cRange
   ::aValueN[i]    := nValue
   ::aToolTip[i]   := cToolTip
   ::aOnChange[i]  := cOnChange
   ::aVertical[i]  := lVertical
   ::aNoTicks[i]   := lNoTicks
   ::aBoth[i]      := lBoth
   ::aTop[i]       := lTop
   ::aLeft[i]      := lLeft
   ::aHelpID[i]    := nHelpID
   ::aBackColor[i] := aBackColor
   ::aVisible[i]   := lVisible
   ::aEnabled[i]   := lEnabled
   ::aNoTabStop[i] := lNoTabStop
   ::aRTL[i]       := lRTL
   ::aSubClass[i]  := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pSpinner( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cRange, nValue, cFontName
LOCAL nFontSize, cToolTip, cOnChange, cOnGotfocus, cOnLostfocus, nHelpId, oCtrl
LOCAL lNoTabStop, lRTL, lWrap, lReadOnly, nIncrement, lVisible, lEnabled
LOCAL aBackColor, aFontColor, lBold, lItalic, lUnderline, lStrikeout, lNoBorder

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TSpinner():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TSpinner():nHeight ) ) ) )
   cRange       := ::ReadStringData( cName, 'RANGE', '' )
   nValue       := Val( ::ReadStringData( cName, 'VALUE', '0' ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotfocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostfocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lWrap        := ( ::ReadLogicalData( cName, 'WRAP', "F" ) == "T" )
   lReadOnly    := ( ::ReadLogicalData( cName, 'READONLY', "F" ) == "T" )
   nIncrement   := Val( ::ReadStringData( cName, 'INCREMENT', '0' ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper(  ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper(  ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lNoBorder    := ( ::ReadLogicalData( cName, "NOBORDER", "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]      := 'SPINNER'
   ::aCObj[i]          := cObj
   ::aRange[i]         := cRange
   ::aValueN[i]        := nValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotfocus
   ::aOnLostFocus[i]   := cOnLostfocus
   ::aHelpID[i]        := nHelpId
   ::aNoTabStop[i]     := lNoTabStop
   ::aRTL[i]           := lRTL
   ::aWrap[i]          := lWrap
   ::aReadOnly[i]      := lReadOnly
   ::aIncrement[i]     := nIncrement
   ::aEnabled[i]       := lEnabled
   ::aVisible[i]       := lVisible
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderLine
   ::aFontStrikeout[i] := lStrikeout
   ::aBorder[i]        := lNoBorder

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTab( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, nValue
LOCAL cToolTip, cOnChange, lFlat, lVertical, lButtons, lHotTrack, lBold
LOCAL lItalic, lUnderline, lStrikeout, aFontColor, lVisible, lEnabled
LOCAL lNoTabStop, lRTL, lMultiLine, cSubClass, lInternals, cPObj, nPosSub, cPSub
LOCAL cPCaptions, cPImages, cPNames, cPObjs, cPSubs, nPageCount, j, oCtrl
LOCAL nPosPage, cPCaption, cPName, nPosImage, cPImage, nPosName, nPosObj

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::ReadStringData( cName, 'OBJ', '' )
   nRow          := Val( ::ReadStringData( cName, 'AT', '100' ) )
   nCol          := Val( ::ReadCtrlCol( cName ) )
   nWidth        := Val( ::ReadStringData( cName, 'WIDTH', '0' ) )
   nHeight       := Val( ::ReadStringData( cName, 'HEIGHT', '0' ) )
   cFontName     := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize     := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   nValue        := Val( ::ReadStringData( cName, 'VALUE', '0' ) )
   cToolTip      := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange     := ::ReadStringData( cName, 'ON CHANGE', '' )
   lFlat         := ( ::ReadLogicalData( cName, 'FLAT', "F" ) == "T" )
   lVertical     := ( ::ReadLogicalData( cName, 'VERTICAL', "F" ) == "T" )
   lButtons      := ( ::ReadLogicalData( cName, 'BUTTONS', "F" ) == "T" )
   lHotTrack     := ( ::ReadLogicalData( cName, 'HOTTRACK', "F" ) == "T" )
   lBold         := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold         := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic       := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic       := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline    := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline    := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout    := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout    := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aFontColor    := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor    := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lVisible      := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lNoTabStop    := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lRTL          := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lMultiLine    := ( ::ReadLogicalData( cName, 'MULTILINE', "F" ) == "T" )
   cSubClass     := ::ReadStringData( cName, 'SUBCLASS', '' )
   lInternals    := ( ::ReadLogicalData( cName, 'INTERNALS', "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]       := 'TAB'
   ::aCObj[i]           := cObj
   ::aFontName[i]       := cFontName
   ::aFontSize[i]       := nFontSize
   ::aValueN[i]         := nValue
   ::aToolTip[i]        := cToolTip
   ::aOnChange[i]       := cOnChange
   ::aFlat[i]           := lFlat
   ::aVertical[i]       := lVertical
   ::aButtons[i]        := lButtons
   ::aHotTrack[i]       := lHotTrack
   ::aBold[i]           := lBold
   ::aFontItalic[i]     := lItalic
   ::aFontUnderline[i]  := lUnderline
   ::aFontStrikeout[i]  := lStrikeout
   ::aFontColor[i]      := aFontColor
   ::aVisible[i]        := lVisible
   ::aEnabled[i]        := lEnabled
   ::aNoTabStop[i]      := lNoTabStop
   ::aRTL[i]            := lRTL
   ::aMultiLine[i]      := lMultiLine
   ::aSubClass[i]       := cSubClass
   ::aVirtual[i]        := lInternals
   ::aCaption[i]        := "{}"
   ::aImage[i]          := "{}"
   ::aPageNames[i]      := "{}"
   ::aPageObjs[i]       := "{}"
   ::aPageSubClasses[i] := "{}"

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   // Load pages
   cPCaptions := '{ '
   cPImages   := '{ '
   cPNames    := '{ '
   cPObjs     := '{ '
   cPSubs     := '{ '
   nPageCount := 0

   j := 1
   DO WHILE j <= Len( ::aLine ) .AND. At( ' ' + Upper( cName ) + ' ', Upper( ::aLine[j] ) ) == 0
     j ++
   ENDDO

   DO WHILE j <= Len( ::aLine ) .AND. At( 'END TAB', Upper( ::aLine[j] ) ) == 0
      IF ( nPosPage := At( 'DEFINE PAGE ', Upper( ::aLine[j] ) ) ) # 0
         nPageCount ++

         cPCaption := AllTrim( SubStr( ::aLine[j], nPospage + 11, Len( ::aLine[j] ) ) )
         IF Right( cPCaption, 1 ) == ";"
            cPCaption := AllTrim( SubStr( cPCaption, 1, Len( cPCaption ) - 1 ) )
         ENDIF
         cPCaption := ::Clean( cPCaption )
         j ++

         cPImage := ''
         cPName  := ''
         cPObj   := ''
         cPSub   := ''

         DO WHILE j <= Len( ::aLine ) .AND. At( 'END TAB', Upper( ::aLine[j] ) ) == 0 .AND. At( 'END PAGE ', Upper( ::aLine[j] ) ) == 0 .AND. ! ( At( "@ ", ::aLine[j] ) > 0 .AND. At( ",", ::aLine[j] ) > 0 )
            DO CASE
            CASE ( nPosImage := At( 'IMAGE ', Upper( ::aLine[j] ) ) ) > 0
               cPImage := AllTrim( SubStr( ::aLine[j], nPosImage + 6, Len( ::aLine[j] ) ) )
               IF Right( cPImage, 1 ) == ";"
                  cPImage := AllTrim( SubStr( cPImage, 1, Len( cPImage ) - 1 ) )
               ENDIF
               cPImage := ::Clean( AllTrim( SubStr( cPImage, 1, Len( ::aLine[j] ) ) ) )
            CASE ( nPosName := At( 'NAME ', Upper( ::aLine[j] ) ) ) > 0
               cPName := AllTrim( SubStr( ::aLine[j], nPosName + 5, Len( ::aLine[j] ) ) )
               IF Right( cPName, 1 ) == ";"
                  cPName := AllTrim( SubStr( cPName, 1, Len( cPName ) - 1 ) )
               ENDIF
               cPName := ::Clean( AllTrim( SubStr( cPName, 1, Len( ::aLine[j] ) ) ) )
            CASE ( nPosObj := At( 'OBJ ', Upper( ::aLine[j] ) ) ) > 0
               cPObj := AllTrim( SubStr( ::aLine[j], nPosObj + 4, Len( ::aLine[j] ) ) )
               IF Right( cPObj, 1 ) == ";"
                  cPObj := AllTrim( SubStr( cPObj, 1, Len( cPObj ) - 1 ) )
               ENDIF
               cPObj := ::Clean( AllTrim( SubStr( cPObj, 1, Len( ::aLine[j] ) ) ) )
            CASE ( nPosSub := At( 'SUBCLASS ', Upper( ::aLine[j] ) ) ) > 0
               cPSub := AllTrim( SubStr( ::aLine[j], nPosSub + 9, Len( ::aLine[j] ) ) )
               IF Right( cPSub, 1 ) == ";"
                  cPSub := AllTrim( SubStr( cPSub, 1, Len( cPSub ) - 1 ) )
               ENDIF
               cPSub := ::Clean( AllTrim( SubStr( cPSub, 1, Len( ::aLine[j] ) ) ) )
            ENDCASE

            j ++
         ENDDO

         IF ! Empty( cPCaption )
            oCtrl:AddPage( nPageCount, cPCaption, cPImage )

            cPCaptions := cPCaptions + "'" + cPCaption + "', "
            cPImages   := cPImages + "'" + cPImage + "', "
            cPNames    := cPNames + "'" + cPName + "', "
            cPObjs     := cPObjs + "'" + cPObj + "', "
            cPSubs     := cPSubs + "'" + cPSub + "', "
         ENDIF
      ELSE
         j ++
      ENDIF
   ENDDO

   cPCaptions := SubStr( cPCaptions, 1, Len( cPCaptions ) - 2 ) + ' }'
   cPImages   := SubStr( cPImages, 1, Len( cPImages ) - 2 ) + ' }'
   cPNames    := SubStr( cPNames, 1, Len( cPNames ) - 2 ) + ' }'
   cPObjs     := SubStr( cPObjs, 1, Len( cPObjs ) - 2 ) + ' }'
   cPSubs     := SubStr( cPSubs, 1, Len( cPSubs ) - 2 ) + ' }'

   ::aCaption[i]        := cPCaptions
   ::aImage[i]          := cPImages
   ::aPageNames[i]      := cPNames
   ::aPageObjs[i]       := cPObjs
   ::aPageSubClasses[i] := cPSubs

   oCtrl:Value := ::aValueN[i]
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTextArray( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, cValue
LOCAL cToolTip, nHelpID, lNoTabStop, cAction, cSubClass, lBold, lItalic
LOCAL lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, aFontColor, lRTL
LOCAL lClientEdge, lBorder, nRowCount, nColCount, oCtrl

   // Load properties
   cName       := ::aControlW[i]
   cObj        := ::ReadStringData( cName, 'OBJ', '' )
   nRow        := Val( ::ReadCtrlRow( cName ) )
   nCol        := Val( ::ReadCtrlCol( cName ) )
   nWidth      := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TText():nWidth ) ) ) )
   nHeight     := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TText():nHeight ) ) ) )
   cFontName   := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize   := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cValue      := ::Clean( ::ReadStringData( cName, 'VALUE', '' ) )
   cToolTip    := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   nHelpID     := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lNoTabStop  := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   cAction     := ::ReadStringData( cName, 'ACTION', '' )
   cSubClass   := ::ReadStringData( cName, 'SUBCLASS', '' )
   lBold       := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold       := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic     := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic     := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline  := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline  := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout  := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout  := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor  := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor  := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible    := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible    := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled    := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled    := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   aFontColor  := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor  := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lRTL        := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lClientEdge := ( ::ReadLogicalData( cName, "CLIENTEDGE", "F") == "T" )
   lBorder     := ( ::ReadLogicalData( cName, "BORDER", "F" ) == "T" )
   nRowCount   := Val( ::ReadStringData( cName, 'ROWCOUNT', '0' ) )
   nColCount   := Val( ::ReadStringData( cName, 'COLCOUNT', '0' ) )

   // Save properties
   ::aCtrlType[i]      := 'TEXTARRAY'
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aValue[i]         := cValue
   ::aToolTip[i]       := cToolTip
   ::aHelpID[i]        := nHelpId
   ::aNoTabStop[i]     := lNoTabStop
   ::aAction[i]        := cAction
   ::aSubClass[i]      := cSubClass
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aFontColor[i]     := aFontColor
   ::aRTL[i]           := lRTL
   ::aClientEdge[i]    := lClientEdge
   ::aBorder[i]        := lBorder
   ::aItemCount[i]     := nRowCount
   ::aIncrement[i]     := nColCount

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTextBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, cValue
LOCAL cField, cToolTip, nMaxLength, nHelpID, lUpperCase, lLowerCase, lPassword
LOCAL lNumeric, lRightAlign, lNoTabStop, lDate, cInputMask, cFormat, cOnEnter
LOCAL cOnChange, cOnGotFocus, cOnLostFocus, lReadonly, nFocusedPos, cValid
LOCAL cAction, cAction2, cImage, cWhen, lNoBorder, cSubClass, lBold, lItalic
LOCAL lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, aFontColor
LOCAL lCenterAlign, lRTL, lAutoSkip, cOnTextFill, nDefaultYear, nButtonWidth
LOCAL nInsertType, oCtrl

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TText():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TText():nHeight ) ) ) )
   cFontName    := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cValue       := ::Clean( ::ReadStringData( cName, 'VALUE', '' ) )
   cField       := ::ReadStringData( cName, 'FIELD', '' )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   nMaxLength   := Val( ::ReadStringData( cName, 'MAXLENGTH', '0' ) )
   nHelpID      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lUpperCase   := ( ::ReadLogicalData( cName, "UPPERCASE", "F" ) == "T" )
   lLowerCase   := ( ::ReadLogicalData( cName, "LOWERCASE", "F" ) == "T" )
   lPassword    := ( ::ReadLogicalData( cName, "PASSWORD", "F" ) == "T" )
   lNumeric     := ( ::ReadLogicalData( cName, "NUMERIC", "F" ) == "T" )
   lRightAlign  := ( ::ReadLogicalData( cName, "RIGHTALIGN", "F" ) == "T" )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', "F" ) == "T" )
   lDate        := ( ::ReadLogicalData( cName, 'DATE', "F" ) == "T" )
   cInputMask   := ::Clean( ::ReadStringData( cName, 'INPUTMASK', "" ) )
   cFormat      := ::Clean( ::ReadStringData( cName, 'FORMAT', "" ) )
   cOnEnter     := ::ReadStringData( cName, 'ON ENTER', '' )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   lReadonly    := ( ::ReadLogicalData( cName, 'READONLY', "F" ) == "T" )
   nFocusedPos  := Val( ::ReadStringData( cName, 'FOCUSEDPOS', '-2' ) )
   cValid       := ::ReadStringData( cName, 'VALID', '' )
   cAction      := ::ReadStringData( cName, 'ACTION', '' )
   cAction2     := ::ReadStringData( cName, 'ACTION2', '' )
   cImage       := ::ReadStringData( cName, 'IMAGE', '' )
   cWhen        := ::ReadStringData( cName, 'WHEN', '' )
   lNoBorder    := ( ::ReadLogicalData( cName, "NOBORDER", "F" ) == "T" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   aFontColor   := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lCenterAlign := ( ::ReadLogicalData( cName, "CENTERALIGN", "F" ) == "T" )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lAutoSkip    :=  ( ::ReadLogicalData( cName, 'AUTOSKIP', "F" ) == "T" )
   cOnTextFill  := ::ReadStringData( cName, 'ON TEXTFILLED', '' )
   nDefaultYear := Val( ::ReadStringData( cName, 'DEFAULTYEAR', '0' ) )
   nButtonWidth := Val( ::ReadStringData( cName, 'BUTTONWIDTH', '0' ) )
   nInsertType  := Val( ::ReadStringData( cName, 'INSERTTYPE', '0' ) )
   IF lDate .OR. ! Empty( cInputMask )
      nMaxLength := 0
   ENDIF
   IF lUpperCase
      cValue := Upper( cValue )
      lLowerCase := .F.
   ELSEIF lLowerCase
      cValue := Lower( cValue )
   ENDIF

   // Save properties
   ::aCtrlType[i]      := 'TEXT'
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aValue[i]         := cValue
   ::aField[i]         := cField
   ::aToolTip[i]       := cToolTip
   ::aMaxLength[i]     := nMaxLength
   ::aHelpID[i]        := nHelpId
   ::aUpperCase[i]     := lUpperCase
   ::aLowerCase[i]     := lLowerCase
   ::aPassWord[i]      := lPassword
   ::aNumeric[i]       := lNumeric
   ::aRightAlign[i]    := lRightAlign
   ::aNoTabStop[i]     := lNoTabStop
   ::aDate[i]          := lDate
   ::aInputMask[i]     := cInputMask
   ::aFields[i]        := cFormat
   ::aOnEnter[i]       := cOnEnter
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aReadOnly[i]      := lReadonly
   ::aFocusedPos[i]    := nFocusedPos
   ::aValid[i]         := cValid
   ::aAction[i]        := cAction
   ::aAction2[i]       := cAction2
   ::aImage[i]         := cImage
   ::aWhen[i]          := cWhen
   ::aBorder[i]        := lNoBorder
   ::aSubClass[i]      := cSubClass
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aFontColor[i]     := aFontColor
   ::aCenterAlign[i]   := lCenterAlign
   ::aRTL[i]           := lRTL
   ::aAutoPlay[i]      := lAutoSkip
   ::aOnTextFilled[i]  := cOnTextFill
   ::aDefaultYear[i]   := nDefaultYear
   ::aButtonWidth[i]   := nButtonWidth
   ::aInsertType[i]    := nInsertType

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTimePicker( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, nRow, nCol, nWidth, cFontName, nFontSize, cToolTip, cOnGotFocus
LOCAL cField, cValue, cOnLostFocus, cOnChange, cOnEnter, lShowNone, lUpDown
LOCAL lRightAlign, nHelpID, cObj, lBold, lItalic, lUnderline, lStrikeout, oCtrl
LOCAL lVisible, lEnabled, lRTL, lNoTabStop, lNoBorder, cSubClass, nHeight

   cName        := ::aControlW[i]
   nRow         := Val( ::ReadCtrlRow( cName ) )
   nCol         := Val( ::ReadCtrlCol( cName ) )
   nWidth       := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TDatePick():nWidth ) ) ) )
   nHeight      := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TDatePick():nHeight ) ) ) )
   cFontName    := ::Clean( ::ReadStringData(cName,'FONT',''))
   nFontSize    := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   cToolTip     := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnGotFocus  := ::ReadStringData( cName, 'ON GOTFOCUS', '')
   cField       := ::Clean( ::ReadStringData( cName, 'FIELD', '' ) )
   cValue       := ::ReadStringData( cName, 'VALUE', '' )
   cOnLostFocus := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnChange    := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnEnter     := ::ReadStringData( cName, 'ON ENTER', '' )
   lShowNone    := ( ::ReadLogicalData( cName, 'SHOWNONE', "F" ) == "T" )
   lUpDown      := ( ::ReadLogicalData( cName, 'UPDOWN', "F" ) == "T" )
   lRightAlign  := ( ::ReadLogicalData( cName, 'RIGHTALIGN', "F" ) == "T" )
   nHelpID      := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   cObj         := ::ReadStringData( cName, 'OBJ', '' )
   lBold        := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lVisible     := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   lNoTabStop   := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == 'T' )
   lNoBorder    := ( ::ReadLogicalData( cName, "NOBORDER", "F" ) == "T" )
   cSubClass    := ::ReadStringData( cName, 'SUBCLASS', '' )

   ::aCtrlType[i]      := 'TIMEPICKER'
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aField[i]         := cField
   ::aValue[i]         := cValue
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnChange[i]      := cOnChange
   ::aonenter[i]       := cOnEnter
   ::aShowNone[i]      := lShowNone
   ::aUpDown[i]        := lUpDown
   ::aRightAlign[i]    := lRightAlign
   ::aHelpID[i]        := nHelpID
   ::aCObj[i]          := cObj
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aNoTabStop[i]     := lNoTabStop
   ::aBorder[i]        := lNoBorder
   ::aSubClass[i]      := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTimer( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, lEnabled, nInterval, cAction, cSubClass, oCtrl

   // Load properties
   cName     := ::aControlW[i]
   cObj      := ::ReadStringData( cName, 'OBJ', '' )
   nRow      := Val( ::ReadStringData( cName, 'ROW', '0' ) )
   nCol      := Val( ::ReadStringData( cName, 'COL', '0' ) )
   lEnabled  := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled  := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   nInterval := Val( ::ReadStringData( cName, 'INTERVAL', '1000' ) )
   cAction   := ::ReadStringData( cName, 'ACTION', '' )
   cSubClass := ::ReadStringData( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i] := 'TIMER'
   ::aCObj[i]     := cObj
   ::aValueN[i]   := nInterval
   ::aAction[i]   := cAction
   ::aEnabled[i]  := lEnabled
   ::aSubClass[i] := cSubClass

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, NIL, NIL, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTree( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aFontColor
LOCAL lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnChange, cOnGotFocus, cOnLostFocus, cOnDblClick, cNodeimages
LOCAL cItemImages, lNoRootButton, lItemIds, nHelpId, lFull, nValue, lRTL
LOCAL cOnEnter, lBreak, lNoTabStop, aSelColor, lSelBold, lCheckBoxes
LOCAL lEditLabels, lNoHScroll, lNoScroll, lHotTrack, lButtons, lEnableDrag
LOCAL lEnableDrop, aTarget, lSingleExpand, lNoBorder, cOnLabelEdit, cValid
LOCAL cOnCheckChg, nIndent, cOnDrop, lNoLines, oCtrl

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::ReadStringData( cName, 'OBJ', '' )
   nRow          := Val( ::ReadStringData( cName, 'AT', '100' ) )
   nCol          := Val( ::ReadCtrlCol( cName ) )
   nWidth        := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TTree():nWidth ) ) ) )
   nHeight       := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TTree():nHeight ) ) ) )
   cFontName     := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize     := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   aFontColor    := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor    := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   lBold         := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold         := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic       := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic       := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline    := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline    := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout    := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout    := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor    := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   lVisible      := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip      := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   cOnChange     := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnGotFocus   := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus  := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick   := ::ReadStringData( cName, 'ON DBLCLICK', '' )
   cNodeImages   := ::ReadStringData( cName, 'NODEIMAGES', '' )
   cItemImages   := ::ReadStringData( cName, 'ITEMIMAGES', '' )
   lNoRootButton := ( ::ReadLogicalData( cName, 'NOROOTBUTTON', "F" ) == "T" )
   lItemIds      := ( ::ReadLogicalData( cName, 'ITEMIDS', "F" ) == "T" )
   nHelpId       := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lFull         := ( ::ReadLogicalData( cName, 'FULLROWSELECT', "F" ) == "T" )
   nValue        := Val( ::ReadStringData( cName, 'VALUE', '0' ) )
   lRTL          := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cOnEnter      := ::ReadStringData( cName, 'ON ENTER', '' )
   lBreak        := ( ::ReadLogicalData( cName, "BREAK", "F" ) == "T" )
   lNoTabStop    := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   aSelColor     := UpperNIL( ::ReadStringData( cName, 'SELCOLOR', 'NIL' ) )
   lSelBold      := ( ::ReadLogicalData( cName, 'SELBOLD', "F" ) == "T" )
   lCheckBoxes   := ( ::ReadLogicalData( cName, 'CHECKBOXES', "F" ) == "T" )
   lEditLabels   := ( ::ReadLogicalData( cName, 'EDITLABELS', "F" ) == "T" )
   lNoHScroll    := ( ::ReadLogicalData( cName, "NOHSCROLL", "F" ) == "T" )
   lNoScroll     := ( ::ReadLogicalData( cName, "NOSCROLL", "F" ) == "T" )
   lHotTrack     := ( ::ReadLogicalData( cName, "HOTTRACKING", "F" ) == "T" )
   lButtons      := ( ::ReadLogicalData( cName, "NOBUTTONS", "F" ) == "T" )
   lEnableDrag   := ( ::ReadLogicalData( cName, "ENABLEDRAG", "F" ) == "T" )
   lEnableDrop   := ( ::ReadLogicalData( cName, "ENABLEDROP", "F" ) == "T" )
   aTarget       := ::ReadStringData( cName, 'TARGET', '' )
   lSingleExpand := ( ::ReadLogicalData( cName, "SINGLEEXPAND", "F" ) == "T" )
   lNoBorder     := ( ::ReadLogicalData( cName, "BORDERLESS", "F" ) == "T" )
   cOnLabelEdit  := ::ReadStringData( cName, 'ON LABELEDIT', '' )
   cValid        := ::ReadStringData( cName, 'VALID', "" )
   cOnCheckChg   := ::ReadStringData( cName, 'ON CHECKCHANGE', '' )
   nIndent       := Val( ::ReadStringData( cName, 'INDENT', '' ) )
   cOnDrop       := ::ReadStringData( cName, 'ON DROP', '' )
   lNoLines      := ( ::ReadLogicalData( cName, 'NOLINES', "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]      := 'TREE'
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnDblClick[i]    := cOnDblClick
   ::aNodeImages[i]    := cNodeImages
   ::aItemImages[i]    := cItemImages
   ::aNoRootButton[i]  := lNoRootButton
   ::aItemIDs[i]       := lItemIds
   ::aHelpID[i]        := nHelpId
   ::aFull[i]          := lFull
   ::aValueN[i]        := nValue
   ::aRTL[i]           := lRTL
   ::aOnEnter[i]       := cOnEnter
   ::aBreak[i]         := lBreak
   ::aNoTabStop[i]     := lNoTabStop
   ::aSelColor[i]      := aSelColor
   ::aSelBold[i]       := lSelBold
   ::aCheckBoxes[i]    := lCheckBoxes
   ::aEditLabels[i]    := lEditLabels
   ::aNoHScroll[i]     := lNoHScroll
   ::aNoVScroll[i]     := lNoScroll
   ::aHotTrack[i]      := lHotTrack
   ::aButtons[i]       := lButtons
   ::aDrag[i]          := lEnableDrag
   ::aDrop[i]          := lEnableDrop
   ::aTarget[i]        := aTarget
   ::aSingleExpand[i]  := lSingleExpand
   ::aBorder[i]        := lNoBorder
   ::aOnLabelEdit[i]   := cOnLabelEdit
   ::aValid[i]         := cValid
   ::aOnCheckChg[i]    := cOnCheckChg
   ::aIndent[i]        := nIndent
   ::aOnDrop[i]        := cOnDrop
   ::aNoLines[i]       := lNoLines

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pXBrowse( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cHeaders, cWidths, cWorkArea
LOCAL cFields, cInputMask, nValue, cFontName, nFontSize, lBold, lItalic
LOCAL lUnderline, lStrikeout, cToolTip, aBackColor, cDynBackColor, cDynForecolor
LOCAL aFontColor, cOnGotFocus, cOnChange, cOnLostFocus, cOnDblClick, cAction
LOCAL lEdit, lInPlace, lAppend, cOnHeadClick, cWhen, cValid, cValidMess
LOCAL cReadOnly, lLock, lDelete, lNoLines, cImage, cJustify, lNoVScroll, nHelpId
LOCAL lBreak, lRTL, cOnAppend, cOnEditCell, cColControls, cReplaceField
LOCAL cSubClass, lRecCount, cColumnInfo, lNoHeaders, cOnEnter, lEnabled
LOCAL lNoTabStop, lVisible, lDescending, cDeleteWhen, cDeleteMsg, cOnDelete
LOCAL cHeaderImages, cImagesAlign, lFull, aSelColor, cEditKeys, lDoubleBuffer
LOCAL lSingleBuffer, lFocusRect, lNoFocusRect, lPLM, lFixedCols, cOnAbortEdit
LOCAL lFixedWidths, lFixedBlocks, lDynamicBlocks, cBeforeColMove, cAfterColMove
LOCAL cBeforeColSize, cAfterColSize, cBeforeAutoFit, lLikeExcel, lButtons
LOCAL lNoDeleteMsg, lFixedCtrls, lDynamicCtrls, lNoShowEmpty, lUpdateColors
LOCAL cOnHeadRClick, lNoModalEdit, lByCell, lExtDblClick, oCtrl

   // Load properties
   cName          := ::aControlW[i]
   cObj           := ::ReadStringData( cName, 'OBJ', '' )
   nRow           := Val( ::ReadCtrlRow( cName ) )
   nCol           := Val( ::ReadCtrlCol( cName ) )
   nWidth         := Val( ::ReadStringData( cName, 'WIDTH', LTrim( Str( TXBrowse():nWidth ) ) ) )
   nHeight        := Val( ::ReadStringData( cName, 'HEIGHT', LTrim( Str( TXBrowse():nHeight ) ) ) )
   cHeaders       := ::ReadStringData( cName, 'HEADERS', "{ '','' } ")
   cWidths        := ::ReadStringData( cName, 'WIDTHS', "{ 100, 60 }")
   cWorkArea      := ::ReadStringData( cName, 'WORKAREA', "ALIAS()" )
   cFields        := ::ReadStringData( cName, 'FIELDS', "{ 'field1', 'field2' }" )
   cInputMask     := ::ReadStringData( cName, 'INPUTMASK', "")
   nValue         := Val( ::ReadStringData( cName, 'VALUE', '' ) )
   cFontName      := ::Clean( ::ReadStringData( cName, 'FONT', '' ) )
   nFontSize      := Val( ::ReadStringData( cName, 'SIZE', '0' ) )
   lBold          := ( ::ReadLogicalData( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( ::ReadOopData( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( ::ReadLogicalData( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( ::ReadOopData( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( ::ReadLogicalData( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( ::ReadOopData( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( ::ReadLogicalData( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( ::ReadOopData( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip       := ::Clean( ::ReadStringData( cName, 'TOOLTIP', '' ) )
   aBackColor     := ::ReadStringData( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := UpperNIL( ::ReadOopData( cName, 'BACKCOLOR', aBackColor ) )
   cDynBackColor  := ::ReadStringData( cName, "DYNAMICBACKCOLOR", '' )
   cDynForecolor  := ::ReadStringData( cName, "DYNAMICFORECOLOR", '' )
   aFontColor     := ::ReadStringData( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := UpperNIL( ::ReadOopData( cName, 'FONTCOLOR', aFontColor ) )
   cOnGotFocus    := ::ReadStringData( cName, 'ON GOTFOCUS', '' )
   cOnChange      := ::ReadStringData( cName, 'ON CHANGE', '' )
   cOnLostFocus   := ::ReadStringData( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick    := ::ReadStringData( cName, 'ON DBLCLICK', '' )
   cAction        := ::ReadStringData( cName, 'ACTION', "" )
   cAction        := ::ReadStringData( cName, 'ON CLICK',cAction )
   cAction        := ::ReadStringData( cName, 'ONCLICK', cAction )
   lEdit          := ( ::ReadLogicalData( cName, 'EDIT', "F" ) == "T" )
   lInPlace       := ( ::ReadLogicalData( cName, 'INPLACE', "F" ) == "T" )
   lAppend        := ( ::ReadLogicalData( cName, 'APPEND', "F" ) == "T" )
   cOnHeadClick   := ::ReadStringData( cName, 'ON HEADCLICK', '' )
   cWhen          := ::ReadStringData( cName, 'WHEN', "" )
   cWhen          := ::ReadStringData( cName, 'COLUMNWHEN', cWhen )
   cValid         := ::ReadStringData( cName, 'VALID', "" )
   cValidMess     := ::ReadStringData( cName, 'VALIDMESSAGES', "" )
   cReadOnly      := ::ReadStringData( cName, 'READONLY', "")
   lLock          := ( ::ReadLogicalData( cName, 'LOCK', "F" ) == "T" )
   lDelete        := ( ::ReadLogicalData( cName, 'DELETE', "F" ) == "T" )
   lNoLines       := ( ::ReadLogicalData( cName, 'NOLINES', "F" ) == "T" )
   cImage         := ::ReadStringData( cName, 'IMAGE', "" )
   cJustify       := ::ReadStringData( cName, 'JUSTIFY', "" )
   lNoVScroll     := ( ::ReadLogicalData( cName, "NOVSCROLL", "F" ) == "T" )
   nHelpId        := Val( ::ReadStringData( cName, 'HELPID', '0' ) )
   lBreak         := ( ::ReadLogicalData( cName, "BREAK", "F" ) == "T" )
   lRTL           := ( ::ReadLogicalData( cName, 'RTL', "F" ) == "T" )
   cOnAppend      := ::ReadStringData( cName, 'ON APPEND', '' )
   cOnEditCell    := ::ReadStringData( cName, 'ON EDITCELL', '' )
   cColControls   := ::ReadStringData( cName, "COLUMNCONTROLS", "" )
   cReplaceField  := ::ReadStringData( cName, 'REPLACEFIELD', '' )
   cSubClass      := ::ReadStringData( cName, 'SUBCLASS', '' )
   lRecCount      := ( ::ReadLogicalData( cName, "RECCOUNT", "F" ) == "T" )
   cColumnInfo    := ::ReadStringData( cName, 'COLUMNINFO', '' )
   lNoHeaders     := ( ::ReadLogicalData( cName, 'NOHEADERS', "F" ) == "T" )
   cOnEnter       := ::ReadStringData( cName, 'ON ENTER', '' )
   lEnabled       := ( ::ReadLogicalData( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( ::ReadOopData( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lNoTabStop     := ( ::ReadLogicalData( cName, 'NOTABSTOP', 'F' ) == "T" )
   lVisible       := ( ::ReadLogicalData( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( ::ReadOopData( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lDescending    := ( ::ReadLogicalData( cName, "DESCENDING", "F" ) == "T" )
   cDeleteWhen    := ::ReadStringData( cName, 'DELETEWHEN', '' )
   cDeleteMsg     := ::ReadStringData( cName, 'DELETEMSG', '' )
   cOnDelete      := ::ReadStringData( cName, 'ON DELETE', '' )
   cHeaderImages  := ::ReadStringData( cName, 'HEADERIMAGES', '' )
   cImagesAlign   := ::ReadStringData( cName, 'IMAGESALIGN', '' )
   lFull          := ( ::ReadLogicalData( cName, 'FULLMOVE', "F" ) == "T" )
   aSelColor      := UpperNIL( ::ReadStringData( cName, 'SELECTEDCOLORS', '' ) )
   cEditKeys      := ::ReadStringData( cName, 'EDITKEYS', '' )
   lDoubleBuffer  := ( ::ReadLogicalData( cName, 'DOUBLEBUFFER', "F" ) == "T" )
   lSingleBuffer  := ( ::ReadLogicalData( cName, 'SINGLEBUFFER', "F" ) == "T" )
   lFocusRect     := ( ::ReadLogicalData( cName, 'FOCUSRECT', "F" ) == "T" )
   lNoFocusRect   := ( ::ReadLogicalData( cName, 'NOFOCUSRECT', "F" ) == "T" )
   lPLM           := ( ::ReadLogicalData( cName, 'PAINTLEFTMARGIN', "F" ) == "T" )
   lFixedCols     := ( ::ReadLogicalData( cName, 'FIXEDCOLS', "F" ) == "T" )
   cOnAbortEdit   := ::ReadStringData( cName, 'ON ABORTEDIT', '' )
   lFixedWidths   := ( ::ReadLogicalData( cName, 'FIXEDWIDTHS', "F" ) == "T" )
   lFixedBlocks   := ( ::ReadLogicalData( cName, "FIXEDBLOCKS", "F" ) == "T" )
   lDynamicBlocks := ( ::ReadLogicalData( cName, "DYNAMICBLOCKS", "F" ) == "T" )
   cBeforeColMove := ::ReadStringData( cName, 'BEFORECOLMOVE', '' )
   cAfterColMove  := ::ReadStringData( cName, 'AFTERCOLMOVE', '' )
   cBeforeColSize := ::ReadStringData( cName, 'BEFORECOLSIZE', '' )
   cAfterColSize  := ::ReadStringData( cName, 'AFTERCOLSIZE', '' )
   cBeforeAutoFit := ::ReadStringData( cName, 'BEFOREAUTOFIT', '' )
   lLikeExcel     := ( ::ReadLogicalData( cName, 'EDITLIKEEXCEL', "F" ) == "T" )
   lButtons       := ( ::ReadLogicalData( cName, 'USEBUTTONS', "F" ) == "T" )
   lNoDeleteMsg   := ( ::ReadLogicalData( cName, 'NODELETEMSG', "F" ) == "T" )
   lFixedCtrls    := ( ::ReadLogicalData( cName, 'FIXEDCONTROLS', "F" ) == "T" )
   lDynamicCtrls  := ( ::ReadLogicalData( cName, 'DYNAMICCONTROLS', "F" ) == "T" )
   lNoShowEmpty   := ( ::ReadLogicalData( cName, 'NOSHOWEMPTYROW', "F" ) == "T" )
   lUpdateColors  := ( ::ReadLogicalData( cName, "UPDATECOLORS", "F" ) == "T" )
   cOnHeadRClick  := ::ReadStringData( cName, 'ON HEADRCLICK', '' )
   lNoModalEdit   := ( ::ReadLogicalData( cName, 'NOMODALEDIT', "F" ) == "T" )
   lByCell        := ( ::ReadLogicalData( cName, 'NAVIGATEBYCELL', "F" ) == "T" )
   lExtDblClick   := ( ::ReadLogicalData( cName, 'EXTDBLCLICK', "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]         := 'XBROWSE'
   ::aCObj[i]             := cObj
   ::aHeaders[i]          := cHeaders
   ::aWidths[i]           := cWidths
   ::aWorkArea[i]         := cWorkArea
   ::aFields[i]           := cFields
   ::aInputMask[i]        := cInputMask
   ::aValueN[i]           := nValue
   ::aFontName[i]         := cFontName
   ::aFontSize[i]         := nFontSize
   ::aBold[i]             := lBold
   ::aFontItalic[i]       := lItalic
   ::aFontUnderline[i]    := lUnderline
   ::aFontStrikeout[i]    := lStrikeout
   ::aToolTip[i]          := cToolTip
   ::aBackColor[i]        := aBackColor
   ::aDynamicBackColor[i] := cDynBackColor
   ::aDynamicForeColor[i] := cDynForecolor
   ::aFontColor[i]        := aFontColor
   ::aOnGotFocus[i]       := cOnGotFocus
   ::aOnChange[i]         := cOnChange
   ::aOnLostFocus[i]      := cOnLostFocus
   ::aOnDblClick[i]       := cOnDblClick
   ::aAction[i]           := cAction
   ::aEdit[i]             := lEdit
   ::aInPlace[i]          := lInPlace
   ::aAppend[i]           := lAppend
   ::aOnHeadClick[i]      := cOnHeadClick
   ::aWhen[i]             := cWhen
   ::aValid[i]            := cValid
   ::aValidMess[i]        := cValidMess
   ::aReadOnlyB[i]        := cReadOnly
   ::aLock[i]             := lLock
   ::aDelete[i]           := lDelete
   ::aNoLines[i]          := lNoLines
   ::aImage[i]            := cImage
   ::aJustify[i]          := cJustify
   ::aNoVScroll[i]        := lNoVScroll
   ::aHelpID[i]           := nHelpId
   ::aBreak[i]            := lBreak
   ::aRTL[i]              := lRTL
   ::aOnAppend[i]         := cOnAppend
   ::aOnEditCell[i]       := cOnEditCell
   ::aColumnControls[i]   := cColControls
   ::aReplaceField[i]     := cReplaceField
   ::aSubClass[i]         := cSubClass
   ::aRecCount[i]         := lRecCount
   ::aColumnInfo[i]       := cColumnInfo
   ::aNoHeaders[i]        := lNoHeaders
   ::aOnEnter[i]          := cOnEnter
   ::aEnabled[i]          := lEnabled
   ::aNoTabStop[i]        := lNoTabStop
   ::aVisible[i]          := lVisible
   ::aDescend[i]          := lDescending
   ::aDeleteWhen[i]       := cDeleteWhen
   ::aDeleteMsg[i]        := cDeleteMsg
   ::aOnDelete[i]         := cOnDelete
   ::aHeaderImages[i]     := cHeaderImages
   ::aImagesAlign[i]      := cImagesAlign
   ::aFull[i]             := lFull
   ::aSelColor[i]         := aSelColor
   ::aEditKeys[i]         := cEditKeys
   ::aDoubleBuffer[i]     := lDoubleBuffer
   ::aSingleBuffer[i]     := lSingleBuffer
   ::aFocusRect[i]        := lFocusRect
   ::aNoFocusRect[i]      := lNoFocusRect
   ::aPLM[i]              := lPLM
   ::aFixedCols[i]        := lFixedCols
   ::aOnAbortEdit[i]      := cOnAbortEdit
   ::aFixedWidths[i]      := lFixedWidths
   ::aFixBlocks[i]        := lFixedBlocks
   ::aDynBlocks[i]        := lDynamicBlocks
   ::aBeforeColMove[i]    := cBeforeColMove
   ::aAfterColMove[i]     := cAfterColMove
   ::aBeforeColSize[i]    := cBeforeColSize
   ::aAfterColSize[i]     := cAfterColSize
   ::aBeforeAutoFit[i]    := cBeforeAutoFit
   ::aLikeExcel[i]        := lLikeExcel
   ::aButtons[i]          := lButtons
   ::aNoDelMsg[i]         := lNoDeleteMsg
   ::aFixedCtrls[i]       := lFixedCtrls
   ::aDynamicCtrls[i]     := lDynamicCtrls
   ::aShowNone[i]         := lNoShowEmpty
   ::aUpdateColors[i]     := lUpdateColors
   ::aOnHeadRClick[i]     := cOnHeadRClick
   ::aNoModalEdit[i]      := lNoModalEdit
   ::aByCell[i]           := lByCell
   ::aExtDblClick[i]      := lExtDblClick

   // Create control
   oCtrl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i, nWidth, nHeight, NIL )
   oCtrl:Row := nRow
   oCtrl:Col := nCol

   ::AddCtrlToTabPage( i, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD AddCtrlToTabPage( z, nRow, nCol ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nStartLine, nPageCount, i, nPos, cTabName

   IF ::swTab
      nStartLine := ::aSpeed[z]
      nPageCount := 0
      cTabName   := ''

      FOR i := nStartLine TO 1 STEP -1
         IF At( Upper( 'END TAB' ), Upper( ::aLine[i] ) ) # 0
            RETURN NIL
         ENDIF

         IF At( Upper( 'DEFINE PAGE ' ), Upper( ::aLine[i] ) ) # 0
            nPageCount ++
         ELSE
            IF ( nPos := At( Upper( 'DEFINE TAB ' ), Upper( ::aLine[i] ) ) ) # 0
               cTabName := Lower( Alltrim( SubStr( ::aLine[i], nPos + 11 ) ) )
               IF RIGHT( cTabName, 1 ) == ";"
                  cTabName := AllTrim( SubStr( cTabName, 1, Len( cTabName ) - 1 ) )
               ENDIF
               EXIT
            ENDIF
         ENDIF
      NEXT i

      IF cTabName # '' .AND. nPageCount > 0
         ::aTabPage[z, 1] := cTabName
         ::aTabPage[z, 2] := nPageCount
         ::oDesignForm:&cTabName:AddControl( ::aControlW[z], nPageCount, nRow, nCol )
         IF ::aBackColor[z] == 'NIL'
//            ::oDesignForm:&cName:BackColor := ::myIde:aSystemColorAux         // TODO: Check
         ENDIF
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ProcesaControl( oControl ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oPage, oTab, nPos

   IF oControl:Row # oControl:ContainerRow .OR. oControl:Col # oControl:ContainerCol
      oPage      := oControl:Container
      oTab       := oPage:Container
      nPos       := oPage:Position
      oTab:Value := nPos
   ENDIF
   ::DrawOutline( oControl, .T. )
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD RefreshControlInspector( ControlName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, aSelCtrl, aVal, cControl, cName, cType, nl, j, oControl, nRow, nCol
LOCAL nWidth, nHeight, bOnChange
STATIC lBusy := .F.

   IF lBusy
      RETURN NIL
   ENDIF
   lBusy := .T.

   IF HB_IsString( ControlName ) .AND. ! Empty( ControlName )
      aSelCtrl := { Lower( ControlName ) }
   ELSE
      aSelCtrl := {}
      aVal := ::oCtrlList:Value
      FOR i := 1 to Len( aVal )
        aAdd( aSelCtrl, ::oCtrlList:Cell( aVal[i], 6 ) )
      NEXT i
   ENDIF

   ::oCtrlList:SetRedraw( .F. )

   bOnChange := ::oCtrlList:OnChange
   ::oCtrlList:OnChange := NIL

   ::oCtrlList:DeleteAllItems()
   FOR i := 2 TO ::nControlW
      IF ! Empty( ::aControlW[i] ) 
         cControl := ::aControlW[i]
         cName    := ::aName[i]
         cType    := ::aCtrlType[i]
         IF ( nl := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == cControl } ) ) > 0
            oControl := ::oDesignForm:aControls[nl]
            nRow     := oControl:Row
            nCol     := oControl:Col
            nWidth   := oControl:Width
            nHeight  := oControl:Height
            ::oCtrlList:AddItem( { cName, Str( nRow, 4 ), Str( nCol, 4 ), Str( nWidth, 4 ), Str( nHeight, 4 ), cControl, cType } )
         ENDIF
      ENDIF
   NEXT i

   aVal := {}
   IF Len( aSelCtrl ) > 0
      nl := ::oCtrlList:ItemCount
      FOR i := 1 TO nl
         j := aScan( aSelCtrl, ::oCtrlList:Cell( i, 6 ) )
         IF j > 0
            aAdd( aVal, i )
         ENDIF
      NEXT i
   ENDIF
   ::oCtrlList:Value := aVal

   SetHeightForWholeRows( ::oCtrlList, 400 )

   ::oCtrlList:SetRedraw( .T. )

   ::oCtrlList:OnChange := bOnChange

   lBusy := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD DeleteControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ia, j, jk, oControl, cName

   IF Len( ::oCtrlList:Value ) > 1
      MsgStop( "Can't delete more than one control at a time.", "OOHG IDE+" )
      RETURN NIL
      // TODO: Add support for deleting multiple controls
   ENDIF

   ia := ::nHandleA
   IF ia > 0
      oControl := ::oDesignForm:aControls[ia]
      cName := Lower( oControl:Name )
      jk := aScan( ::aControlW, cName )
      IF jk > 1
         IF ! MsgYesNo( 'Are you sure you want to delete control ' + ::aName[jk] + ' ?', "OOHG IDE+" )
            RETURN NIL
         ENDIF
         IF ::CrtlIsOfType( ia, 'TAB')
            FOR j := ::nControlW TO 1 STEP -1
               IF ::aTabPage[j, 1] == cName
                  ::DelArray( j )
               ENDIF
            NEXT j
         ENDIF
         ::DelArray( jk )
         ::nHandleA := 0
         ::nIndexW  := 0
         oControl:Release()
         ::lFsave := .F.
         ::oCtrlList:Value := {}
         EraseWindow( ::oDesignForm:Name )
         ::DrawPoints()
         ::RefreshControlInspector()
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD MouseTrack() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL iMin, w_OOHG_MouseRow, w_OOHG_MouseCol, i, cControl, oControl, ia

   w_OOHG_MouseRow := _ooHG_MouseRow
   w_OOHG_MouseCol := _ooHG_MouseCol
   ::Form_Main:labelyx:Value := StrZero( w_OOHG_MouseRow, 4 ) + ',' + StrZero( w_OOHG_MouseCol, 4 )

   // Check to see if mouse is over the red square at top-left corner
   iMin := 0
   FOR i := 2 TO ::nControlW
      cControl := Lower( ::aControlW[i] )
      IF ::aCtrlType[i] # 'STATUSBAR' .AND. ( ia := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == cControl } ) ) > 0
         oControl := ::oDesignForm:aControls[ia]
         IF oControl:Row == oControl:ContainerRow .AND. oControl:Col == oControl:ContainerCol
            IF ( w_OOHG_MouseRow >= oControl:Row - 10 ) .AND. ;
               ( w_OOHG_MouseRow <= oControl:Row ) .AND. ;
               ( w_OOHG_MouseCol >= oControl:Col - 10 ) .AND. ;
               ( w_OOHG_MouseCol <= oControl:Col ) .AND. ;
               ( ! Lower( oControl:Name ) $ 'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .AND. ;
               ( oControl:Type # 'HOTKEY' )
               iMin := i
               EXIT
            ENDIF
         ELSE
            IF ( w_OOHG_MouseRow >= oControl:ContainerRow - 10 ) .AND. ;
               ( w_OOHG_MouseRow <= oControl:ContainerRow )  .AND. ;
               ( w_OOHG_MouseCol >= oControl:ContainerCol - 10 ) .AND. ;
               ( w_OOHG_MouseCol <= oControl:ContainerCol ) .AND. ;
               ( ! Lower( oControl:Name ) $ 'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .AND. ;
               (  oControl:Type # 'HOTKEY' )
               iMin := i
               EXIT
            ENDIF
         ENDIF
      ENDIF
   NEXT i

   IF iMin > 0
      CursorHand()
      ::swCursor := 1                      // drag
      ::nIndexW  := iMin
      RETURN NIL
   ENDIF

   // Check to see if mouse is over the red square at bottom-right corner
   iMin := 0
   FOR i := 2 TO ::nControlW
      cControl := Lower( ::aControlW[i] )
      IF ::aCtrlType[i] # 'STATUSBAR'.AND. ( ia := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == cControl } ) ) > 0
         oControl := ::oDesignForm:aControls[ia]
         IF ::aCtrlType[i] == "RADIOGROUP"
            IF ( w_OOHG_MouseRow >= oControl:Row + oControl:GroupHeight ) .AND. ;
               ( w_OOHG_MouseRow <= oControl:Row + oControl:GroupHeight + 5 ) .AND. ;
               ( w_OOHG_MouseCol >= oControl:Col + oControl:GroupWidth ) .AND. ;
               ( w_OOHG_MouseCol <= oControl:Col + oControl:GroupWidth + 5 )
               iMin := i
               EXIT
            ENDIF
         ELSEIF ! oControl:Type $ 'TOOLBAR MONTHCALENDAR TIMER'
            IF oControl:Row == oControl:ContainerRow .AND. oControl:Col == oControl:ContainerCol
               IF ( w_OOHG_MouseRow >= oControl:Row + oControl:Height ) .AND. ;
                  ( w_OOHG_MouseRow <= oControl:Row + oControl:Height + 5 ) .AND. ;
                  ( w_OOHG_MouseCol >= oControl:Col + oControl:Width ) .AND. ;
                  ( w_OOHG_MouseCol <= oControl:Col + oControl:Width + 5 ) .AND. ;
                  ( ! Lower( oControl:Name ) $ 'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .AND. ;
                  ( oControl:Type # 'HOTKEY' )
                  iMin := i
                  EXIT
               ENDIF
            ELSE
               IF ( w_OOHG_MouseRow >= oControl:ContainerRow + oControl:Height ) .AND. ;
                  ( w_OOHG_MouseRow <= oControl:ContainerRow + oControl:Height + 5 ) .AND. ;
                  ( w_OOHG_MouseCol >= oControl:ContainerCol + oControl:Width ) .AND. ;
                  ( w_OOHG_MouseCol <= oControl:ContainerCol + oControl:Width + 5 ) .AND. ;
                  ( ! Lower( oControl:Name ) $ 'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .AND. ;
                  ( oControl:Type # 'HOTKEY' )
                  iMin := i
                  EXIT
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT i

   IF iMin > 0
      CursorSizeNWSE()
      ::swCursor := 2                      // size
      ::nIndexW  := iMin
   ELSE
      CursorArrow()
      ::swCursor := 0                      // none
      ::nIndexW  := 0
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Debug() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, cs

   cs := '# of controls: ' + Str( ::nControlW - 1, 4 ) + CRLF
   FOR i := 2 TO ::nControlW
       IF ::aTabPage[i, 1] # ''
          cs := cs + ::aControlW[i] + ' | ' + ::aCtrlType[i] + ' | ' + Str( ::aTabPage[i, 2] )+ ' | ' + ::aTabPage[i, 1] + CRLF
       ELSE
          cs := cs + ::aControlW[i] + ' | ' + ::aCtrlType[i] + ' |-> ' + ::aCaption[i] + CRLF
       ENDIF
   NEXT i
   MsgInfo( cs )
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION cHideControl( x )
//------------------------------------------------------------------------------
RETURN HideWindow( x )        // TODO: Check

//------------------------------------------------------------------------------
STATIC FUNCTION SetHeightForWholeRows( oGrid, nMaxHeight )
//------------------------------------------------------------------------------
LOCAL nAreaUsed, nItemHeight, nNewHeight
STATIC nOldHeight := 0

   nItemHeight := oGrid:ItemHeight()
   IF nItemHeight <= 0
      nNewHeight := nMaxHeight
   ELSE
      nAreaUsed := oGrid:HeaderHeight + ;
                   IF( IsWindowStyle( oGrid:hWnd, WS_HSCROLL ), ;
                       GetHScrollBarHeight(), ;
                       0 ) + ;
                   IF( IsWindowExStyle( oGrid:hWnd, WS_EX_CLIENTEDGE ), ;
                       GetEdgeHeight() * 2, ;
                       0 )
      nNewHeight := ( Int( ( nMaxHeight - nAreaUsed ) / nItemHeight ) * nItemHeight + nAreaUsed )
   ENDIF
   IF nNewHeight # nOldHeight
      oGrid:Height := nNewHeight
      nOldHeight := nNewHeight
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Save( lSaveAs ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL BaseRow, BaseCol, Output, nSpacing := 3, aCaptions, aWidths
LOCAL CurrentPage, aActions, aIcons, aStyles, aToolTips, aAligns
LOCAL i, j, nCtrlPos, k, nRow, nCol, nWidth, nHeight
LOCAL caCaptions, caImages, caPageNames, caPageObjs, caPageSubClasses
LOCAL aImages, aPageNames, aPageObjs, aPageSubClasses, nCount

   CursorWait()
   ::oWaitMsg:label_1:Value := 'Saving form ...'

   BaseRow := GetWindowRow( ::oDesignForm:hWnd )   // screen coordinates
   BaseCol := GetWindowCol( ::oDesignForm:hWnd )

   /*
      All keywords, properties and control names must be followed by a space.
   */

   //***************************  Header
   Output := '' + CRLF
   Output += '* ooHG IDE Plus form generated code' + CRLF
   Output += '* (c)2003-2014 Ciro Vargas Clemow <pcman2010@yahoo.com > ' + CRLF
   Output += CRLF

   //***************************  Form start
   Output += 'DEFINE WINDOW TEMPLATE ;' + CRLF
   // Must be always the second line
   Output += Space( nSpacing ) + 'AT ' + LTrim( Str( BaseRow ) ) + ', ' + LTrim( Str( BaseCol ) ) + ' ;' + CRLF
   Output += IIF( ! Empty( ::cfobj ), Space( nSpacing ) + 'OBJ ' + AllTrim( ::cfobj ) + " ;" + CRLF, '')
   IF ::lFClientArea
      Output += Space( nSpacing ) + 'WIDTH ' + LTrim( Str( ::oDesignForm:ClientWidth ) ) + ' ;' + CRLF
      Output += Space( nSpacing ) + 'HEIGHT ' + LTrim( Str( ::oDesignForm:ClientHeight ) )
   ELSE
      Output += Space( nSpacing ) + 'WIDTH ' + LTrim( Str( ::oDesignForm:Width ) ) + ' ;' + CRLF
      Output += Space( nSpacing ) + 'HEIGHT ' + LTrim( Str( ::oDesignForm:Height ) )
   ENDIF
   IF ! Empty( ::cFParent )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'PARENT ' + StrToStr( ::cFParent )
   ENDIF
   IF ::nfvirtualw > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'VIRTUAL WIDTH ' + LTrim( Str( ::nfvirtualw ) )
   ENDIF
   IF ::nfvirtualh > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'VIRTUAL HEIGHT ' + LTrim( Str( ::nfvirtualh ) )
   ENDIF
   IF ! Empty( ::cFTitle )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'TITLE ' + StrToStr( ::cFTitle )
   ENDIF
   IF ! Empty( ::cFIcon )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ICON ' + StrToStr( ::cFIcon )
   ENDIF
   Output += IIF( ::lfmain, ' ;' + CRLF + Space( nSpacing ) + 'MAIN ', '' )
   Output += IIF( ::lfsplitchild, ' ;' + CRLF + Space( nSpacing ) + 'SPLITCHILD ', '' )
   Output += IIF( ::lfchild, ' ;' + CRLF + Space( nSpacing ) + 'CHILD ', '' )
   Output += IIF( ::lfmodal, ' ;' + CRLF + Space( nSpacing ) + 'MODAL ', '' )
   Output += IIF( ::lfnoshow, ' ;' + CRLF + Space( nSpacing ) + 'NOSHOW ', '' )
   Output += IIF( ::lftopmost, ' ;' + CRLF + Space( nSpacing ) + 'TOPMOST ', '' )
   Output += IIF( ::lfnoautorelease, ' ;' + CRLF + Space( nSpacing ) + 'NOAUTORELEASE ', '' )
   Output += IIF( ::lfnominimize, ' ;' + CRLF + Space( nSpacing ) + 'NOMINIMIZE ', '' )
   Output += IIF( ::lfnomaximize, ' ;' + CRLF + Space( nSpacing ) + 'NOMAXIMIZE ', '' )
   Output += IIF( ::lfnosize, ' ;' + CRLF + Space( nSpacing ) + 'NOSIZE ', '' )
   Output += IIF( ::lfnosysmenu, ' ;' + CRLF + Space( nSpacing ) + 'NOSYSMENU ', '' )
   Output += IIF( ::lfnocaption, ' ;' + CRLF + Space( nSpacing ) + 'NOCAPTION ', '' )
   IF ! Empty( ::cFCursor )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'CURSOR ' + StrToStr( ::cFCursor )
   ENDIF
   IF ! Empty( ::cFOnInit )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON INIT ' + AllTrim( ::cFOnInit )
   ENDIF
   IF ! Empty( ::cFOnRelease )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RELEASE ' + AllTrim( ::cFOnRelease )
   ENDIF
   IF ! Empty( ::cFOnInteractiveClose )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON INTERACTIVECLOSE ' + AllTrim( ::cFOnInteractiveClose )
   ENDIF
   IF ! Empty( ::cFOnMouseClick )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSECLICK ' + AllTrim( ::cFOnMouseClick )
   ENDIF
   IF ! Empty( ::cFOnMouseDrag )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSEDRAG ' + AllTrim( ::cFOnMouseDrag )
   ENDIF
   IF ! Empty( ::cFOnMouseMove )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSEMOVE ' + AllTrim( ::cFOnMouseMove )
   ENDIF
   IF ! Empty( ::cFOnSize )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SIZE ' + AllTrim( ::cFOnSize )
   ENDIF
   IF ! Empty( ::cFOnPaint )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON PAINT ' + AllTrim( ::cFOnPaint )
   ENDIF
   IF ::cFBackcolor # 'NIL'
      Output += ' ;' + CRLF + Space( nSpacing ) + 'BACKCOLOR ' + ::cFBackcolor
   ENDIF
   IF ! Empty( ::cFFontName )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'FONT ' + StrToStr( ::cFFontName )
   ENDIF
   IF ::nFFontSize > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'SIZE ' + LTrim( Str( ::nFFontSize ) )
   ENDIF
   IF ::cFFontColor # 'NIL'
      Output += ' ;' + CRLF + Space( nSpacing ) + 'FONTCOLOR ' + ::cFFontColor
   ENDIF
   IF ! Empty( ::cFGripperText )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'GRIPPERTEXT ' + StrToStr( ::cFGripperText )
   ENDIF
   IF ! Empty( ::cFNotifyIcon )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'NOTIFYICON ' + StrToStr( ::cFNotifyIcon )
   ENDIF
   IF ! Empty( ::cFNotifyToolTip )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'NOTIFYTOOLTIP ' + StrToStr( ::cFNotifyToolTip )
   ENDIF
   IF ! Empty( ::cFOnNotifyClick )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON NOTIFYCLICK ' + AllTrim( ::cFOnNotifyClick )
   ENDIF
   Output += IIF( ::lFBreak, ' ;' + CRLF + Space( nSpacing ) + 'BREAK ', '')
   Output += IIF( ::lFFocused, ' ;' + CRLF + Space( nSpacing ) + 'FOCUSED ', '')
   IF ! Empty( ::cFOnGotFocus )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON GOTFOCUS ' + AllTrim( ::cFOnGotFocus )
   ENDIF
   IF ! Empty( ::cFOnLostFocus )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON LOSTFOCUS ' + AllTrim( ::cFOnLostFocus )
   ENDIF
   IF ! Empty( ::cFOnScrollUp )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLUP ' + AllTrim( ::cFOnScrollUp )
   ENDIF
   IF ! Empty( ::cFOnScrollDown )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLDOWN ' + AllTrim( ::cFOnScrollDown )
   ENDIF
   IF ! Empty( ::cFOnScrollRight )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLRIGHT ' + AllTrim( ::cFOnScrollRight )
   ENDIF
   IF ! Empty( ::cFOnScrollLeft )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLLEFT ' + AllTrim( ::cFOnScrollLeft )
   ENDIF
   IF ! Empty( ::cFOnHScrollbox )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON HSCROLLBOX ' + AllTrim( ::cFOnHScrollbox )
   ENDIF
   IF ! Empty( ::cFOnVScrollbox )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON VSCROLLBOX ' + AllTrim( ::cFOnVScrollbox )
   ENDIF
   Output += IIF( ::lfhelpbutton, ' ;' + CRLF + Space( nSpacing ) + 'HELPBUTTON ', '')
   IF ! Empty( ::cfonmaximize )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MAXIMIZE ' + AllTrim( ::cfonmaximize )
   ENDIF
   IF ! Empty( ::cfonminimize )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MINIMIZE ' + AllTrim( ::cfonminimize )
   ENDIF
   Output += IIF( ::lFModalSize, ' ;' + CRLF + Space( nSpacing ) + 'MODALSIZE ', '')
   Output += IIF( ::lFMDI, ' ;' + CRLF + Space( nSpacing ) + 'MDI ', '')
   Output += IIF( ::lFMDIClient, ' ;' + CRLF + Space( nSpacing ) + 'MDICLIENT ', '')
   Output += IIF( ::lFMDIChild, ' ;' + CRLF + Space( nSpacing ) + 'MDICHILD ', '')
   Output += IIF( ::lFInternal, ' ;' + CRLF + Space( nSpacing ) + 'INTERNAL ', '')
   IF ! Empty( ::cFMoveProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOVE ' + AllTrim( ::cFMoveProcedure )
   ENDIF
   IF ! Empty( ::cFRestoreProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RESTORE ' + AllTrim( ::cFRestoreProcedure )
   ENDIF
   Output += IIF( ::lFRTL, ' ;' + CRLF + Space( nSpacing ) + 'RTL ', '')
   Output += IIF( ::lFClientArea, ' ;' + CRLF + Space( nSpacing ) + 'CLIENTAREA ', '')
   IF ! Empty( ::cFRClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RCLICK ' + AllTrim( ::cFRClickProcedure )
   ENDIF
   IF ! Empty( ::cFMClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MCLICK ' + AllTrim( ::cFMClickProcedure )
   ENDIF
   IF ! Empty( ::cFDblClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON DBLCLICK ' + AllTrim( ::cFDblClickProcedure )
   ENDIF
   IF ! Empty( ::cFRDblClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RDBLCLICK ' + AllTrim( ::cFRDblClickProcedure )
   ENDIF
   IF ! Empty( ::cFMDblClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MDBLCLICK ' + AllTrim( ::cFMDblClickProcedure )
   ENDIF
   IF ::nFMinWidth > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'MINWIDTH ' + LTrim( Str( ::nFMinWidth ) )
   ENDIF
   IF ::nFMaxWidth > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'MAXWIDTH ' + LTrim( Str( ::nFMaxWidth ) )
   ENDIF
   IF ::nFMinHeight > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'MINHEIGHT ' + LTrim( Str( ::nFMinHeight ) )
   ENDIF
   IF ::nFMaxHeight > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'MAXHEIGHT ' + LTrim( Str( ::nFMaxHeight ) )
   ENDIF
   IF ! Empty( ::cFBackImage )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'BACKIMAGE ' + StrToStr( ::cFBackImage )
      Output += IIF( ::lFStretch, ' ;' + CRLF + Space( nSpacing ) + 'STRETCH ', '')
   ENDIF
   IF ! Empty( ::cFSubClass )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RESTORE ' + AllTrim( ::cFSubClass )
   ENDIF
   Output += CRLF + CRLF

   //***************************  Statusbar
   IF ::lSStat
      Output += Space( nSpacing ) + 'DEFINE STATUSBAR '
      IF ! Empty( ::cSCObj )
         Output += ';' + CRLF + Space( nSpacing * 2 ) + 'OBJ ' + AllTrim( ::cSCObj )
      ENDIF
      IF ::lSTop
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'TOP '
      ENDIF
      IF ::lSNoAutoAdjust
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'NOAUTOADJUST '
      ENDIF
      IF ! Empty( ::cSSubClass )
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SUBCLASS ' + AllTrim( ::cSSubClass )
      ENDIF
      IF ! Empty( ::cSFontName )
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'FONT ' + StrToStr( ::cSFontName )
      ENDIF
      IF ::nSFontSize > 0
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SIZE ' + LTrim( Str( ::nSFontSize ) )
      ENDIF
      IF ::lSBold
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOLD '
      ENDIF
      IF ::lSItalic
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'ITALIC '
      ENDIF
      IF ::lSUnderline
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'UNDERLINE '
      ENDIF
      IF ::lSStrikeout
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'STRIKEOUT '
      ENDIF
      Output += CRLF + CRLF

      aCaptions := &( ::cSCaption )
      aWidths   := &( ::cSWidth )
      aActions  := &( ::cSAction )
      aIcons    := &( ::cSIcon )
      aStyles   := &( ::cSStyle )
      aToolTips := &( ::cSToolTip )
      aAligns   := &( ::cSAlign )
      FOR i := 1 TO Len( aCaptions )
         IF ! HB_IsString( aCaptions[i] ) .OR. Empty( aCaptions[i] )
            Output += Space( nSpacing * 2 ) + 'STATUSITEM ' + "' '"
         ELSE
            Output += Space( nSpacing * 2 ) + 'STATUSITEM ' + StrToStr( aCaptions[i] )
         ENDIF
         IF HB_IsNumeric( aWidths[i] ) .AND. aWidths[i] > 0
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( aWidths[i] ) )
         ENDIF
         IF HB_IsString( aActions[i] ) .AND. ! Empty( aActions[i] )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( aActions[i] )
         ENDIF
         IF HB_IsString( aIcons[i] ) .AND. ! Empty( aIcons[i] )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ICON ' + StrToStr( aIcons[i] )
         ENDIF
         IF HB_IsString( aStyles[i] )
            IF aStyles[i] == 'FLAT'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'FLAT '
            ELSEIF aStyles[i] == 'RAISED'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RAISED '
            ENDIF
         ENDIF
         IF HB_IsString( aToolTips[i] ) .AND. ! Empty( aToolTips[i] )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( aToolTips[i] )
         ENDIF
         IF HB_IsString( aAligns[i] )
            IF aAligns[i] == 'LEFT'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'LEFT '
            ELSEIF aAligns[i] == 'RIGHT'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RIGHT '
            ELSEIF aAligns[i] == 'CENTER'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CENTER '
            ENDIF
         ENDIF
         Output += CRLF + CRLF
      NEXT i

      IF ::lSKeyboard
         Output += Space( nSpacing * 2 ) + 'KEYBOARD '
         IF ::nSKWidth > 0
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( ::nSKWidth ) )
         ENDIF
         IF ! Empty( ::cSKAction )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( ::cSKAction )
         ENDIF
         IF ! Empty( ::cSKToolTip )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( ::cSKToolTip )
         ENDIF
         IF ! Empty( ::cSKImage )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ICON ' + StrToStr( ::cSKImage )
         ENDIF
         IF ::cSKStyle == 'FLAT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'FLAT '
         ELSEIF ::cSKStyle == 'RAISED'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RAISED '
         ENDIF
         IF ::cSKAlign == 'LEFT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'LEFT '
         ELSEIF ::cSKAlign == 'RIGHT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RIGHT '
         ELSEIF ::cSKAlign == 'CENTER'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CENTER '
         ENDIF
         Output += CRLF + CRLF
      ENDIF

      IF ::lSDate
         Output += Space( nSpacing * 2 ) + 'DATE '
         IF ::nSDWidth > 0
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( ::nSDWidth ) )
         ENDIF
         IF ! Empty( ::cSDAction )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( ::cSDAction )
         ENDIF
         IF ! Empty( ::cSDToolTip )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( ::cSDToolTip )
         ENDIF
         IF ::cSDStyle == 'FLAT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'FLAT '
         ELSEIF ::cSDStyle == 'RAISED'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RAISED '
         ENDIF
         IF ::cSDAlign == 'LEFT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'LEFT '
         ELSEIF ::cSDAlign == 'RIGHT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RIGHT '
         ELSEIF ::cSDAlign == 'CENTER'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CENTER '
         ENDIF
         Output += CRLF + CRLF
      ENDIF

      IF ::lSTime
         Output += Space( nSpacing * 2 ) + 'CLOCK '
         IF ::nSCWidth > 0
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( ::nSCWidth ) )
         ENDIF
         IF ! Empty( ::cSCAction )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( ::cSCAction )
         ENDIF
         IF ! Empty( ::cSCToolTip )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( ::cSCToolTip )
         ENDIF
         IF ! Empty( ::cSCImage )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ICON ' + StrToStr( ::cSCImage )
         ENDIF
         IF ::lSCAmPm
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'AMPM '
         ENDIF
         IF ::cSCStyle == 'FLAT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'FLAT '
         ELSEIF ::cSCStyle == 'RAISED'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RAISED '
         ENDIF
         IF ::cSCAlign == 'LEFT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'LEFT '
         ELSEIF ::cSCAlign == 'RIGHT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RIGHT '
         ELSEIF ::cSCAlign == 'CENTER'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CENTER '
         ENDIF
         Output += CRLF + CRLF
      ENDIF

      Output += Space( nSpacing ) + 'END STATUSBAR '
      Output += CRLF + CRLF
   ENDIF

   //***************************  Main menu
   Output += TMyMenuEditor():FmgOutput( Self, 1, nSpacing )

   //***************************  Context menu
   Output += TMyMenuEditor():FmgOutput( Self, 2, nSpacing )

   //***************************  Notify menu
   Output += TMyMenuEditor():FmgOutput( Self, 3, nSpacing )

   //***************************  Toolbar
   Output += ::myTbEditor:FmgOutput( nSpacing )

   //***************************  Form's controls
   j := 2
   DO WHILE j <= ::nControlW
      IF ::aControlW[j] == '' .OR. ::aControlW[j] $ 'statusbar mainmenu contextmenu notifymenu'
         j ++
         LOOP
      ENDIF

      nCtrlPos := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == ::aControlW[j] } )
      IF nCtrlPos == 0
         j ++
         LOOP
      ENDIF

      nRow    := ( ::oDesignForm:aControls[nCtrlPos] ):Row
      nCol    := ( ::oDesignForm:aControls[nCtrlPos] ):Col
      nWidth  := ( ::oDesignForm:aControls[nCtrlPos] ):Width
      nHeight := ( ::oDesignForm:aControls[nCtrlPos] ):Height

      //***************************  Tab start
      IF ::aCtrlType[j] == 'TAB'
         // Do not delete next line, it's needed to load the fmg properly.
         Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TAB ' + ::aName[j] + ' ;' + CRLF
         Output += Space( nSpacing ) + 'DEFINE TAB ' + ::aName[j] + ' ;' + CRLF
         IF ! Empty( ::aCObj[j] )
            Output += Space( nSpacing * 2 ) + 'OBJ ' + ::aCObj[j] + ' ;' + CRLF
         ENDIF
         Output += Space( nSpacing * 2 ) + 'AT ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' ;' + CRLF
         Output += Space( nSpacing * 2 ) + 'WIDTH ' + LTrim( Str( nWidth ) ) + ' ;' + CRLF
         Output += Space( nSpacing * 2 ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
         IF ::aValueN[j] > 0
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
         ENDIF
         IF ! Empty( ::aFontName[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'FONT ' + StrToStr( ::aFontName[j] )
         ENDIF
         IF ::aFontSize[j] > 0
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
         ENDIF
         IF ! Empty( ::aToolTip[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
         ENDIF
         IF ::aButtons[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'BUTTONS '
         ENDIF
         IF ::aFlat[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'FLAT '
         ENDIF
         IF ::ahottrack[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'HOTTRACK '
         ENDIF
         IF ::aVertical[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'VERTICAL '
         ENDIF
         IF ! Empty( ::aOnChange[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'ON CHANGE ' + ::aOnChange[j]
         ENDIF
         IF ::aBold[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOLD '
         ENDIF
         IF ::aFontItalic[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'ITALIC '
         ENDIF
         IF ::aFontUnderline[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'UNDERLINE '
         ENDIF
         IF ::aFontStrikeout[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'STRIKEOUT '
         ENDIF
         IF ::aNoTabStop[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'NOTABSTOP '
         ENDIF
         IF ::aRTL[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'RTL '
         ENDIF
         IF ! ::aEnabled[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'DISABLED '
         ENDIF
         IF ! ::aVisible[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'INVISIBLE '
         ENDIF
         IF ::aMultiLine[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'MULTILINE '
         ENDIF
         IF ! Empty( ::aSubClass[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
         ENDIF
         IF ::aVirtual[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'INTERNALS '
         ENDIF
         Output += CRLF + CRLF

         //***************************  Tab pages
         caCaptions       := ::aCaption[j]
         caImages         := ::aImage[j]
         caPageNames      := ::aPageNames[j]
         caPageObjs       := ::aPageObjs[j]
         caPageSubClasses := ::aPageSubClasses[j]

         IF IsValidArray( caCaptions )
            aCaptions := &caCaptions
            nCount := Len( aCaptions )

            IF IsValidArray( caImages )
               aImages := &caImages
               aSize( aImages, nCount )
            ELSE
               aImages := Array( nCount )
            ENDIF
            IF IsValidArray( caPageNames )
               aPageNames := &caPageNames
               aSize( aPageNames, nCount )
            ELSE
               aPageNames := Array( nCount )
            ENDIF
            IF IsValidArray( caPageObjs )
               aPageObjs := &caPageObjs
               aSize( aPageObjs, nCount )
            ELSE
               aPageObjs := Array( nCount )
            ENDIF
            IF IsValidArray( caPageSubClasses )
               aPageSubClasses := &caPageSubClasses
               aSize( aPageSubClasses, nCount )
            ELSE
               aPageSubClasses := Array( nCount )
            ENDIF

            FOR CurrentPage := 1 TO nCount
               Output += Space( nSpacing * 2) + 'DEFINE PAGE ' + StrToStr( aCaptions[CurrentPage] )
               IF ! Empty( aImages[CurrentPage] ) .AND. HB_IsString( aImages[CurrentPage] )
                  Output += ' ;' + CRLF + Space( nSpacing * 3) + 'IMAGE ' + StrToStr( aImages[CurrentPage] )
               ENDIF
               IF ! Empty( aPageNames[CurrentPage] ) .AND. HB_IsString( aPageNames[CurrentPage] )
                  Output += ' ;' + CRLF + Space( nSpacing * 3) + 'NAME ' + AllTrim( aPageNames[CurrentPage] )
               ENDIF
               IF ! Empty( aPageObjs[CurrentPage] ) .AND. HB_IsString( aPageObjs[CurrentPage] )
                  Output += ' ;' + CRLF + Space( nSpacing * 3) + 'OBJ ' + AllTrim( aPageObjs[CurrentPage] )
               ENDIF
               IF ! Empty( aPageSubClasses[CurrentPage] ) .AND. HB_IsString( aPageSubClasses[CurrentPage] )
                  Output += ' ;' + CRLF + Space( nSpacing * 3) + 'SUBCLASS ' + AllTrim( aPageSubClasses[CurrentPage] )
               ENDIF
               Output += CRLF + CRLF

               FOR k := 2 TO ::nControlW
                  IF ::aTabPage[k, 1] == ::aControlW[j]
                     IF ::aTabPage[k, 2] == CurrentPage
                        //***************************  Tab page controls
                        nCtrlPos := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == ::aControlW[k] } )
                        IF nCtrlPos > 0
                           nRow    := ::oDesignForm:aControls[nCtrlPos]:Row
                           nCol    := ::oDesignForm:aControls[nCtrlPos]:Col
                           nWidth  := ::oDesignForm:aControls[nCtrlPos]:Width
                           nHeight := ::oDesignForm:aControls[nCtrlPos]:Height
                           Output  := ::MakeControls( k, Output, nRow, nCol, nWidth, nHeight, nSpacing, 3)
                        ENDIF
                     ELSEIF ::aTabPage[k, 2] > CurrentPage
                        EXIT
                     ENDIF
                  ENDIF
               NEXT k

               Output += Space( nSpacing * 2) + 'END PAGE ' + CRLF + CRLF
            NEXT i
         ENDIF

         //***************************  Tab end
         Output += Space( nSpacing ) + "END TAB " + CRLF + CRLF
      ELSE
         //***************************  Other controls
         IF ::aCtrlType[j] # 'TAB' .AND. ::aTabPage[j, 2] == 0
            Output := ::MakeControls( j, Output, nRow, nCol, nWidth, nHeight, nSpacing, 1 )
         ENDIF
      ENDIF
      j ++
   ENDDO

   //***************************  Form's end
   Output += 'END WINDOW ' + CRLF + CRLF
   Output := StrTran( Output, "  ;", " ;" )

   ::oWaitMsg:Hide()

   //***************************  Save FMG
   IF lSaveAs == 1
      IF ! HB_MemoWrit( PutFile( { { 'Form files *.fmg', '*.fmg' } }, 'Save Form As', , .T. ), Output )
         CursorArrow()
         MsgStop( 'Error writing FMG file.', 'OOHG IDE+' )
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
   ELSE
      IF ! HB_MemoWrit( ::cForm, Output )
         CursorArrow()
         MsgStop( 'Error writing ' + ::cForm + ".", 'OOHG IDE+' )
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::lFSave := .T.
   ENDIF

   ::oDesignForm:SetFocus()
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION StrToStr( cData )
//------------------------------------------------------------------------------
LOCAL cRet

   IF ! "'" $ cData
      cRet := "'" + AllTrim( cData ) + "'"
   ELSEIF ! '"' $ cData
      cRet := '"' + AllTrim( cData ) + '"'
   ELSEIF ! '[' $ cData .AND. ! ']' $ cData
      cRet := '[' + AllTrim( cData ) + ']'
   ELSE
      cRet := "'" + AllTrim( cData ) + "'"
      // We can't assure that cRet is properly formed
      // This may cause a compiler error
   ENDIF
RETURN cRet

//------------------------------------------------------------------------------
METHOD MakeControls( j, Output, nRow, nCol, nWidth, nHeight, nSpacing, nLevel ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cValue

   IF ::aCtrlType[j] == 'BROWSE'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BROWSE ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aHeaders[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + AllTrim( ::aHeaders[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + "{ '', '' }"
      ENDIF
      IF ! Empty( ::aWidths[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + AllTrim( ::aWidths[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + "{ 90, 60 }"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WORKAREA ' + AllTrim( ::aWorkArea[j] )
      IF ! Empty( ::aFields[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + AllTrim( ::aFields[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + "{ 'field1', 'field2' }"
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aInputMask[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( ::aInputMask[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicBackColor[j] ) ) .AND. UpperNIL( ::aDynamicBackColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBACKCOLOR ' + AllTrim( ::aDynamicBackColor[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicForeColor[j] ) ) .AND. UpperNIL( ::aDynamicForeColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICFORECOLOR ' + AllTrim( ::aDynamicForeColor[j] )
      ENDIF
      IF ! Empty( ::aColumnControls[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNCONTROLS ' + AllTrim( ::aColumnControls[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ! Empty( ::aOnHeadClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADCLICK ' + AllTrim( ::aOnHeadClick[j] )
      ENDIF
      IF ! Empty( ::aOnEditCell[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON EDITCELL ' + AllTrim( ::aOnEditCell[j] )
      ENDIF
      IF ! Empty( ::aOnAppend[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON APPEND ' + AllTrim( ::aOnAppend[j] )
      ENDIF
      IF ! Empty( ::aWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( ::aWhen[j] )
      ENDIF
      IF ! Empty( ::avalid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::avalid[j] )
      ENDIF
      IF ! Empty( ::aValidMess[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALIDMESSAGES ' + AllTrim( ::aValidMess[j] )
      ENDIF
      IF ! Empty( ::aReadOnlyB[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY ' + AllTrim( ::aReadOnlyB[j] )
      ENDIF
      IF ::aLock[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LOCK '
      ENDIF
      IF ::aDelete[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELETE '
      ENDIF
      IF ::aInPlace[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPLACE '
      ENDIF
      IF ::aEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDIT '
      ENDIF
      IF ::anolines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( ::aJustify[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aAppend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'APPEND '
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aFull[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FULLMOVE '
      ENDIF
      IF ::aButtons[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'USEBUTTONS '
      ENDIF
      IF ::aNoHeaders[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHEADERS '
      ENDIF
      IF ! Empty( ::aHeaderImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERIMAGES ' + AllTrim( ::aHeaderImages[j] )
      ENDIF
      IF ! Empty( ::aImagesAlign[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESALIGN ' + AllTrim( ::aImagesAlign[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELECTEDCOLORS ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ! Empty( ::aEditKeys[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDITKEYS ' + AllTrim( ::aEditKeys[j] )
      ENDIF
      IF ::aDoubleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DOUBLEBUFFER '
      ENDIF
      IF ::aSingleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEBUFFER '
      ENDIF
      IF ::aFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSRECT '
      ENDIF
      IF ::aNoFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOFOCUSRECT '
      ENDIF
      IF ::aPLM[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PAINTLEFTMARGIN '
      ENDIF
      IF ::aFixedCols[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCOLS '
      ENDIF
      IF ! Empty( ::aOnAbortEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ABORTEDIT ' + AllTrim( ::aOnAbortEdit[j] )
      ENDIF
      IF ::aFixedWidths[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDWIDTHS '
      ENDIF
      IF ! Empty( ::aBeforeColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLMOVE ' + AllTrim( ::aBeforeColMove[j] )
      ENDIF
      IF ! Empty( ::aAfterColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLMOVE ' + AllTrim( ::aAfterColMove[j] )
      ENDIF
      IF ! Empty( ::aBeforeColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLSIZE ' + AllTrim( ::aBeforeColSize[j] )
      ENDIF
      IF ! Empty( ::aAfterColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLSIZE ' + AllTrim( ::aAfterColSize[j] )
      ENDIF
      IF ! Empty( ::aBeforeAutoFit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFOREAUTOFIT ' + AllTrim( ::aBeforeAutoFit[j] )
      ENDIF
      IF ::aLikeExcel[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'EDITLIKEEXCEL '
      ENDIF
      IF ! Empty( ::aDeleteWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEWHEN ' + AllTrim( ::aDeleteWhen[j] )
      ENDIF
      IF ! Empty( ::aDeleteMsg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEMSG ' + AllTrim( ::aDeleteMsg[j] )
      ENDIF
      IF ! Empty( ::aOnDelete[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DELETE ' + AllTrim( ::aOnDelete[j] )
      ENDIF
      IF ::aNoDelMsg[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NODELETEMSG '
      ENDIF
      IF ::aFixedCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCONTROLS '
      ENDIF
      IF ::aDynamicCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICCONTROLS '
      ENDIF
      IF ! Empty( ::aOnHeadRClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADRCLICK ' + AllTrim( ::aOnHeadRClick[j] )
      ENDIF
      IF ::aExtDblClick[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXTDBLCLICK '
      ENDIF
      IF ::anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ::aNoRefresh[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOREFRESH '
      ENDIF
      IF ! Empty( ::aReplaceField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'REPLACEFIELD ' + AllTrim( ::aReplaceField[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aRecCount[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RECCOUNT '
      ENDIF
      IF ! Empty( ::aColumnInfo[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNINFO ' + AllTrim( ::aColumnInfo[j] )
      ENDIF
      IF ::aDescend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DESCENDING '
      ENDIF
      IF ::aForceRefresh[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCEREFRESH '
      ENDIF
      IF ::aSync[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SYNCHRONIZED '
      ELSEIF ::aUnSync[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNSYNCHRONIZED '
      ENDIF
      IF ::aUpdate[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDATEALL '
      ENDIF
      IF ::aFixBlocks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDBLOCKS '
      ELSEIF ::aDynBlocks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBLOCKS '
      ENDIF
      IF ::aUpdateColors[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDATECOLORS '
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'BUTTON'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BUTTON ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aCaption[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aCaption[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aName[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + "MsgInfo( 'Button Pressed' )"
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aFlat[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FLAT '
      ENDIF
      IF ! Empty( ::aJustify[j] ) .AND. ! Empty( ::aPicture[j] ) .AND. ! Empty( ::aCaption[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + Upper( AllTrim( ::aJustify[j] ) ) + " "
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnMouseMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON MOUSEMOVE ' + AllTrim( ::aOnMouseMove[j] )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aBuffer[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ! Empty( ::aImageMargin[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGEMARGIN ' + AllTrim( ::aImageMargin[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aNoPrefix[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOPREFIX '
      ENDIF
      IF ::aNoLoadTrans[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ::aCancel[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CANCEL '
      ENDIF
      IF ::aMultiLine[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTILINE '
      ENDIF
      IF ::aThemed[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ::aNo3DColors[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aFit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOFIT '
      ENDIF
      IF ::aDIBSection[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DIBSECTION '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBTN'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBUTTON ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aCaption[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aCaption[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aName[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ::aValueL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnMouseMove[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON MOUSEMOVE ' + AllTrim( ::aOnMouseMove[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ENDIF
      IF ! Empty( ::aBuffer[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aNoLoadTrans[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ::aNo3DColors[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aFit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOFIT '
      ENDIF
      IF ::aDIBSection[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DIBSECTION '
      ENDIF
      IF ::aThemed[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ! Empty( ::aImageMargin[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGEMARGIN ' + AllTrim( ::aImageMargin[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + Upper( AllTrim( ::aJustify[j] ) ) + " "
      ENDIF
      IF ::aMultiLine[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTILINE '
      ENDIF
      IF ::aFlat[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FLAT '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBOX'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBOX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aCaption[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aCaption[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + "'" + "'"
      ENDIF
      IF ::aValue[j] == ".T."
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSEIF ::aValue[j] == ".F."
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
       ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aHelpID[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ::aLeft[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LEFTALIGN '
      ENDIF
      IF ::a3State[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THREESTATE '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'COMBO'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' COMBOBOX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      // Do not include HEIGHT
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( ::aItems[j] )
      ENDIF
      IF ! Empty( ::aItemSource[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMSOURCE ' + AllTrim( ::aItemSource[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( ::aValueSource[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUESOURCE ' + AllTrim( ::aValueSource[j] )
      ENDIF
      IF ::aDisplayEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISPLAYEDIT '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ! Empty( ::aOnDisplayChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DISPLAYCHANGE ' + AllTrim( ::aOnDisplayChange[j] )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aSort[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SORT '
      ENDIF
      IF ! Empty( ::aItemImageNumber[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMIMAGENUMBER ' + AllTrim( ::aItemImageNumber[j] )
      ENDIF
      IF ! Empty( ::aImageSource[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESOURCE ' + AllTrim( ::aImageSource[j] )
      ENDIF
      IF ::aFirstItem[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIRSTITEM '
      ENDIF
      IF ::aListWidth[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LISTWIDTH ' + LTrim( Str( ::aListWidth[j] ) )
      ENDIF
      IF ! Empty( ::aOnListDisplay[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LISTDISPLAY ' + AllTrim( ::aOnListDisplay[j] )
      ENDIF
      IF ! Empty( ::aOnListClose[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LISTCLOSE ' + AllTrim( ::aOnListClose[j] )
      ENDIF
      IF ::aDelayedLoad[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELAYEDLOAD '
      ENDIF
      IF ::aIncremental[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INCREMENTAL '
      ENDIF
      IF ::aIntegralHeight[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INTEGRALHEIGHT '
      ENDIF
      IF ::aRefresh[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'REFRESH '
      ENDIF
      IF ::aNoRefresh[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOREFRESH '
      ENDIF
      IF ! Empty( ::aSourceOrder[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SOURCEORDER ' + AllTrim( ::aSourceOrder[j] )
      ENDIF
      IF ! Empty( ::aOnRefresh[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON REFRESH ' + AllTrim( ::aOnRefresh[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aSearchLapse[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SEARCHLAPSE ' + LTrim( Str( ::aSearchLapse[j] ) )
      ENDIF
      IF ! Empty( ::aGripperText[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'GRIPPERTEXT ' + AllTrim( ::aGripperText[j] )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + AllTrim( ::aFontColor[j] )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aTextHeight[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TEXTHEIGHT ' + LTrim( Str( ::aTextHeight[j] ) )
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIT '
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'DATEPICKER'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' DATEPICKER ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::aValue[j] )
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + StrToStr( ::aField[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aShowNone[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWNONE '
      ENDIF
      IF ::aUpDown[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDOWN '
      ENDIF
      IF ::aRightAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TIMEPICKER'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TIMEPICKER ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::aValue[j] )
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + StrToStr( ::aField[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aShowNone[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWNONE '
      ENDIF
      IF ::aUpDown[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDOWN '
      ENDIF
      IF ::aRightAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'EDIT'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' EDITBOX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::aValue[j] )
      ENDIF
      IF ::aReadOnly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aMaxLength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( ::aMaxLength[j] ) )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHSCROLL '
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      IF ::aFocusedPos[j] <> -4            // default value, see DATA nOnFocusPos in h_editbox.prg
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSEDPOS ' + LTrim( Str( ::aFocusedPos[j] ) )
      ENDIF
      IF ! Empty( ::aOnHScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HSCROLL ' + AllTrim( ::aOnHScroll[j] )
      ENDIF
      IF ! Empty( ::aOnVScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON VSCROLL ' + AllTrim( ::aOnVScroll[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'FRAME'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' FRAME ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aCaption[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "CAPTION " + StrToStr( ::aCaption[j] )
      ENDIF
      IF ::aOpaque[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OPAQUE '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( ::aBackColor[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'GRID'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' GRID ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + AllTrim( ::aHeaders[j] )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + AllTrim( ::aWidths[j] )
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( ::aItems[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicBackColor[j] ) ) .AND. UpperNIL( ::aDynamicBackColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBACKCOLOR ' + AllTrim( ::aDynamicBackColor[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicForeColor[j] ) ) .AND. UpperNIL( ::aDynamicForeColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICFORECOLOR ' + AllTrim( ::aDynamicForeColor[j] )
      ENDIF
      IF ! Empty( ::aColumnControls[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNCONTROLS ' + AllTrim( ::aColumnControls[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] ) + ' ;' +CRLF
      ENDIF
      IF ! Empty( ::aOnHeadClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADCLICK ' + AllTrim( ::aOnHeadClick[j] )
      ENDIF
      IF ! Empty( ::aOnEditCell[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON EDITCELL ' + AllTrim( ::aOnEditCell[j] )
      ENDIF
      IF ::aMultiSelect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTISELECT '
      ENDIF
      IF ::anolines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF ::aInPlace[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPLACE '
      ENDIF
      IF ::aEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDIT '
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( ::aJustify[j] )
      ENDIF
      IF ! Empty( ::aWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( ::aWhen[j] )
      ENDIF
      IF ! Empty( ::avalid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::avalid[j] )
      ENDIF
      IF ! Empty( ::aValidMess[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALIDMESSAGES ' + AllTrim( ::aValidMess[j] )
      ENDIF
      IF ! Empty( ::aReadOnlyB[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY ' + AllTrim( ::aReadOnlyB[j] )
      ENDIF
      IF ! Empty( ::aInputMask[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( ::aInputMask[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aFull[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FULLMOVE '
      ENDIF
      IF ::aCheckBoxes[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CHECKBOXES '
      ENDIF
      IF ! Empty( ::aOnCheckChg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHECKCHANGE ' + AllTrim( ::aOnCheckChg[j] )
      ENDIF
      IF ::aButtons[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'USEBUTTONS '
      ENDIF
      IF ::aDelete[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELETE '
      ENDIF
      IF ::aAppend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'APPEND '
      ENDIF
      IF ! Empty( ::aOnAppend[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON APPEND ' + AllTrim( ::aOnAppend[j] )
      ENDIF
      IF ::aVirtual[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VIRTUAL '
      ENDIF
      IF ::aItemCount[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMCOUNT ' + LTrim( Str( ::aItemCount[j] ) )
      ENDIF
      IF ! Empty( ::aOnQueryData[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON QUERYDATA ' + AllTrim( ::aOnQueryData[j] )
      ENDIF
      IF ::aNoHeaders[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHEADERS '
      ENDIF
      IF ! Empty( ::aHeaderImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERIMAGES ' + AllTrim( ::aHeaderImages[j] )
      ENDIF
      IF ! Empty( ::aImagesAlign[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESALIGN ' + AllTrim( ::aImagesAlign[j] )
      ENDIF
      IF ::aByCell[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NAVIGATEBYCELL '
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELECTEDCOLORS ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ! Empty( ::aEditKeys[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDITKEYS ' + AllTrim( ::aEditKeys[j] )
      ENDIF
      IF ::aDoubleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DOUBLEBUFFER '
      ENDIF
      IF ::aSingleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEBUFFER '
      ENDIF
      IF ::aFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSRECT '
      ENDIF
      IF ::aNoFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOFOCUSRECT '
      ENDIF
      IF ::aPLM[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PAINTLEFTMARGIN '
      ENDIF
      IF ::aFixedCols[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCOLS '
      ENDIF
      IF ! Empty( ::aOnAbortEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ABORTEDIT ' + AllTrim( ::aOnAbortEdit[j] )
      ENDIF
      IF ::aFixedWidths[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDWIDTHS '
      ENDIF
      IF ! Empty( ::aBeforeColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLMOVE ' + AllTrim( ::aBeforeColMove[j] )
      ENDIF
      IF ! Empty( ::aAfterColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLMOVE ' + AllTrim( ::aAfterColMove[j] )
      ENDIF
      IF ! Empty( ::aBeforeColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLSIZE ' + AllTrim( ::aBeforeColSize[j] )
      ENDIF
      IF ! Empty( ::aAfterColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLSIZE ' + AllTrim( ::aAfterColSize[j] )
      ENDIF
      IF ! Empty( ::aBeforeAutoFit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFOREAUTOFIT ' + AllTrim( ::aBeforeAutoFit[j] )
      ENDIF
      IF ::aLikeExcel[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'EDITLIKEEXCEL '
      ENDIF
      IF ! Empty( ::aDeleteWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEWHEN ' + AllTrim( ::aDeleteWhen[j] )
      ENDIF
      IF ! Empty( ::aDeleteMsg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEMSG ' + AllTrim( ::aDeleteMsg[j] )
      ENDIF
      IF ! Empty( ::aOnDelete[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DELETE ' + AllTrim( ::aOnDelete[j] )
      ENDIF
      IF ::aNoDelMsg[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NODELETEMSG '
      ENDIF
      IF ::aNoModalEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NOMODALEDIT '
      ENDIF
      IF ::aFixedCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCONTROLS '
      ENDIF
      IF ::aDynamicCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICCONTROLS '
      ENDIF
      IF ! Empty( ::aOnHeadRClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADRCLICK ' + AllTrim( ::aOnHeadRClick[j] )
      ENDIF
      IF ::aNoClickOnCheck[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOCLICKONCHECKBOX '
      ENDIF
      IF ::aNoRClickOnCheck[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NORCLICKONCHECKBOX '
      ENDIF
      IF ::aExtDblClick[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXTDBLCLICK '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'HYPERLINK'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' HYPERLINK ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::aValue[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + "'ooHG Home'"
      ENDIF
      IF ! Empty( ::aAddress[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ADDRESS ' + StrToStr( ::aAddress[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ADDRESS ' + "'https://sourceforge.net/projects/oohg/'"
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aHandCursor[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HANDCURSOR '
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HSCROLL '
      ENDIF
      IF ::aNoVScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VSCROLL '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'IMAGE'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' IMAGE ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ::aStretch[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRETCH '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NODIBSECTION '
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NORESIZE '
      ENDIF
      IF ::aWhiteBack[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHITEBACKGROUND '
      ENDIF
      IF ::aImageSize[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESIZE '
      ENDIF
      IF ! Empty( ::aExclude[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXCLUDEAREA ' + AllTrim( ::aExclude[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'IPADDRESS'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' IPADDRESS ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::aValue[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aNoTabStop[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'LABEL'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' LABEL ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      ENDIF
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::aValue[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aHelpID[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aCenterAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CENTERALIGN '
      ENDIF
      IF ::aRightAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! Empty( ::aInputMask[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( ::aInputMask[j] )
      ENDIF
      IF ::aNoVScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VSCROLL '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HSCROLL '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aWrap[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOWORDWRAP '
      ENDIF
      IF ::aNoPrefix[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOPREFIX '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'LIST'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' LISTBOX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( ::aItems[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ::aMultiSelect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTISELECT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aSort[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SORT '
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aOnEnter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aOnEnter[j] )
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
         IF ::aFit[j]
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIT '
         ENDIF
      ENDIF
      IF ::aTextHeight[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TEXTHEIGHT ' + LTrim( Str( ::aTextHeight[j] ) )
      ENDIF
      IF ::anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'ANIMATE'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' ANIMATEBOX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFile[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FILE ' + StrToStr( ::aFile[j] )
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOPLAY '
      ENDIF
      IF ::aCenter[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CENTER '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PLAYER'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' PLAYER ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FILE ' + StrToStr( ::aFile[j] )
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aNoAutoSizeWindow[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOAUTOSIZEWINDOW '
      ENDIF
      IF ::aNoAutoSizeMovie[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOAUTOSIZEMOVIE '
      ENDIF
      IF ::aNoErrorDlg[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOERRORDLG '
      ENDIF
      IF ::aNoMenu[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOMENU '
      ENDIF
      IF ::aNoOpen[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOOPEN '
      ENDIF
      IF ::aNoPlayBar[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOPLAYBAR '
      ENDIF
      IF ::aShowAll[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWALL '
      ENDIF
      IF ::aShowMode[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWMODE '
      ENDIF
      IF ::aShowName[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWNAME '
      ENDIF
      IF ::aShowPosition[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWPOSITION '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'MONTHCALENDAR'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' MONTHCALENDAR ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::aValue[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoToday[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTODAY '
      ENDIF
      IF ::aNoTodayCircle[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTODAYCIRCLE '
      ENDIF
      IF ::aWeekNumbers[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WEEKNUMBERS '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aTitleFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TITLEFONTCOLOR ' + ::aTitleFontColor[j]
      ENDIF
      IF ::aTitleBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TITLEBACKCOLOR ' + ::aTitleBackColor[j]
      ENDIF
      IF ::aTrailingFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRAILINGFONTCOLOR ' + ::aTrailingFontColor[j]
      ENDIF
      IF ::aBackgroundColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKGROUNDCOLOR ' + ::aBackgroundColor[j]
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PICBUTT'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BUTTON ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE " + StrToStr( ::aPicture[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE " + "'" + "'"
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + "MsgInfo( 'Button Pressed' )"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aFlat[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FLAT '
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOFIT '
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DIBSECTION '
      ENDIF
      IF ! Empty( ::aOnMouseMove[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON MOUSEMOVE ' + AllTrim( ::aOnMouseMove[j] )
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ! Empty( ::aImageMargin[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGEMARGIN ' + AllTrim( ::aImageMargin[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + Upper( AllTrim( ::aJustify[j] ) ) + " "
      ENDIF
      IF ::aCancel[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CANCEL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PICCHECKBUTT'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBUTTON ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + "'" + "'"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ::aValueL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnMouseMove[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON MOUSEMOVE ' + AllTrim( ::aOnMouseMove[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOFIT '
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DIBSECTION '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ::aFlat[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FLAT '
      ENDIF
      IF ! Empty( ::aImageMargin[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGEMARGIN ' + AllTrim( ::aImageMargin[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + Upper( AllTrim( ::aJustify[j] ) ) + " "
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PROGRESSBAR'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' PROGRESSBAR ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aVertical[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VERTICAL '
      ENDIF
      IF ::aSmooth[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SMOOTH '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORECOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aMarquee[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MARQUEE ' + LTrim( Str( ::aMarquee[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'RADIOGROUP'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' RADIOGROUP ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "OPTIONS " + AllTrim( ::aItems[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      // Do no include HEIGHT
      IF ::aSpacing[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "SPACING " + LTrim( Str( ::aSpacing[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ::aTransparent[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ENDIF
      IF ::aFlat[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HORIZONTAL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ! Empty( ::aBackground[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKGROUND ' + AllTrim( ::aBackground[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'RICHEDIT'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' RICHEDITBOX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::aValue[j] )
      ENDIF
      IF ::aReadOnly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aMaxLength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( ::aMaxLength[j] ) )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! Empty( ::aOnSelChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON SELCHANGE ' + AllTrim( ::aOnSelChange[j] )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoHideSel[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHIDESEL '
      ENDIF
      IF ::aFocusedPos[j] <> -4            // default value, see DATA nOnFocusPos in h_textbox.prg
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSEDPOS ' + LTrim( Str( ::aFocusedPos[j] ) )
      ENDIF
      IF ::aNoVScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHSCROLL '
      ENDIF
      IF ! Empty( ::aFile[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FILE ' + StrToStr( ::aFile[j] )
      ENDIF
      IF ::aPlainText[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PLAINTEXT '
      ENDIF
      IF ::aFileType[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FILETYPE ' + LTrim( Str( ::aFileType[j] ) )
      ENDIF
      IF ! Empty( ::aOnVScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON VSCROLL ' + AllTrim( ::aOnVScroll[j] )
      ENDIF
      IF ! Empty( ::aOnHScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HSCROLL ' + AllTrim( ::aOnHScroll[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'SLIDER'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' SLIDER ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE 1, 100'
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ::aVertical[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VERTICAL '
      ENDIF
      IF ::aNoTicks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTICKS '
      ENDIF
      IF ::aBoth[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOTH '
      ENDIF
      IF ::aTop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOP '
      ENDIF
      IF ::aLeft[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LEFT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'SPINNER'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' SPINNER ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aWrap[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WRAP '
      ENDIF
      IF ::aReadOnly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF ::aIncrement[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INCREMENT ' + LTrim( Str( ::aIncrement[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TEXT'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TEXTBOX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ::aValue[j] == NIL
         cValue := ''
      ELSE
         cValue := AllTrim( ::aValue[j] )
      ENDIF
      IF ! Empty( cValue )
         IF ::aNumeric[j]
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + cValue
         ELSE
            IF ::aDate[j]
               Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + cValue
            ELSE
               Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( cValue )
            ENDIF
         ENDIF
      ENDIF
      IF ::aReadOnly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF ::aPassWord[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PASSWORD '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aNumeric[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NUMERIC '
         IF ! Empty( ::aInputMask[j] )
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + StrToStr( ::aInputMask[j] )
         ENDIF
      ELSE
         IF ! Empty( ::aInputMask[j] )
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + StrToStr( ::aInputMask[j] )
         ENDIF
      ENDIF
      IF ! Empty( ::aFields[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORMAT ' + StrToStr( ::aFields[j] )
      ENDIF
      IF ::aDate[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DATE '
      ENDIF
      IF ::aMaxLength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( ::aMaxLength[j] ) )
      ENDIF
      IF ::aUpperCase[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPPERCASE '
      ELSEIF ::aLowerCase[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LOWERCASE '
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aCenterAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CENTERALIGN '
      ELSEIF ::aRightAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aFocusedPos[j] <> -2            // default value, see DATA nOnFocusPos in h_textbox.prg
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSEDPOS ' + LTrim( Str( ::aFocusedPos[j] ) )
      ENDIF
      IF ! Empty( ::avalid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::avalid[j] )
      ENDIF
      IF ! Empty( ::aWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( ::aWhen[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ! Empty( ::aAction2[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION2 ' + AllTrim( ::aAction2[j] )
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSKIP '
      ENDIF
      IF ! Empty( ::aOnTextFilled[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON TEXTFILLED ' + AllTrim( ::aOnTextFilled[j] )
      ENDIF
      IF ::aDefaultYear[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DEFAULTYEAR ' + LTrim( Str( ::aDefaultYear[j] ) )
      ENDIF
      IF ::aButtonWidth[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUTTONWIDTH ' + LTrim( Str( ::aButtonWidth[j] ) )
      ENDIF
      IF ::aInsertType[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INSERTTYPE ' + LTrim( Str( ::aInsertType[j] ) )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TIMER'
      // Do not delete next 3 lines, they are needed to load the control properly.
      Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TIMER ' + ::aName[j] + ' ;' + CRLF
      Output += Space( nSpacing ) + '*****' + Space( nSpacing ) + 'ROW ' + LTrim( Str( nRow ) ) + ' ;' + CRLF
      Output += Space( nSpacing ) + '*****' + Space( nSpacing ) + 'COL ' + LTrim( Str( nCol ) ) + CRLF
      Output += Space( nSpacing * nLevel ) + 'DEFINE TIMER ' + ::aName[j]
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ::aValueN[j] > 999
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INTERVAL ' + LTrim( Str( ::aValueN[j] ) )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INTERVAL ' + LTrim( Str( 1000 ) )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + '_dummy()'
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TREE'
      // Do not delete next line, it's needed to load the fmg properly.
      Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TREE ' + ::aName[j] + ' ;' + CRLF
      Output += Space( nSpacing * nLevel ) + 'DEFINE TREE ' + ::aName[j]
      IF ! Empty( ::aCObj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AT ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ! Empty( ::aNodeImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NODEIMAGES ' + AllTrim( ::aNodeImages[j] )
      ENDIF
      IF ! Empty( ::aItemImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMIMAGES ' + AllTrim( ::aItemImages[j] )
      ENDIF
      IF ::aNoRootButton[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOROOTBUTTON '
      ENDIF
      IF ::aItemIDs[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMIDS '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aFull[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FULLROWSELECT '
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aOnEnter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aOnEnter[j] )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELCOLOR ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELBOLD '
      ENDIF
      IF ::aCheckBoxes[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CHECKBOXES '
      ENDIF
      IF ::aEditLabels[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDITLABELS '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHSCROLL '
      ENDIF
      IF ::aNoVScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOSCROLL '
      ENDIF
      IF ::aHotTrack[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HOTTRACKING '
      ENDIF
      IF ::aButtons[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBUTTONS '
      ENDIF
      IF ::aDrag[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ENABLEDRAG '
      ENDIF
      IF ::aDrop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ENABLEDROP '
      ENDIF
      IF ! Empty( ::aTarget[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TARGET ' + AllTrim( ::aTarget[j] )
      ENDIF
      IF ::aSingleExpand[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEEXPAND '
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDERLESS '
      ENDIF
      IF ! Empty( ::aOnLabelEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LABELEDIT ' + AllTrim( ::aOnLabelEdit[j] )
      ENDIF
      IF ! Empty( ::aValid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::aValid[j] )
      ENDIF
      IF ! Empty( ::aOnCheckChg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHECKCHANGE ' + AllTrim( ::aOnCheckChg[j] )
      ENDIF
      IF ::aIndent[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INDENT ' + LTrim( Str( ::aIndent[j] ) )
      ENDIF
      IF ! Empty( ::aOnDrop[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DROP ' + AllTrim( ::aOnDrop[j] )
      ENDIF
      IF ::aNoLines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
/*
   TODO: Add

   #xcommand DEFINE NODE <text> ;
      [ IMAGES <aImage> ] ;
      [ ID <id> ] ;
      [ <checked: CHECKED> ] ;
      [ <readonly: READONLY> ] ;
      [ <bold: BOLD> ] ;
      [ <disabled: DISABLED> ] ;
      [ <nodrag: NODRAG> ] ;
      [ <autoid: AUTOID> ] ;

   #xcommand TREEITEM <text> ;
      [ IMAGES <aImage> ] ;
      [ ID <id> ] ;
      [ <checked: CHECKED> ] ;
      [ <readonly: READONLY> ] ;
      [ <bold: BOLD> ] ;
      [ <disabled: DISABLED> ] ;
      [ <nodrag: NODRAG> ] ;
      [ <autoid: AUTOID> ] ;
*/
      Output += Space( nSpacing * nLevel ) + "END TREE " + CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'XBROWSE'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' XBROWSE ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aHeaders[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + AllTrim( ::aHeaders[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + "{ '', '' }"
      ENDIF
      IF ! Empty( ::aWidths[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + AllTrim( ::aWidths[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + "{ 90, 60 }"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WORKAREA ' + AllTrim( ::aWorkArea[j] )
      IF ! Empty( ::aFields[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + AllTrim( ::aFields[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + "{ 'field1', 'field2' }"
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aInputMask[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( ::aInputMask[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicBackColor[j] ) ) .AND. UpperNIL( ::aDynamicBackColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBACKCOLOR ' + AllTrim( ::aDynamicBackColor[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicForeColor[j] ) ) .AND. UpperNIL( ::aDynamicForeColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICFORECOLOR ' + AllTrim( ::aDynamicForeColor[j] )
      ENDIF
      IF ! Empty( ::aColumnControls[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNCONTROLS ' + AllTrim( ::aColumnControls[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ! Empty( ::aOnHeadClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADCLICK ' + AllTrim( ::aOnHeadClick[j] )
      ENDIF
      IF ! Empty( ::aOnEditCell[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON EDITCELL ' + AllTrim( ::aOnEditCell[j] )
      ENDIF
      IF ! Empty( ::aOnAppend[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON APPEND ' + AllTrim( ::aOnAppend[j] )
      ENDIF
      IF ! Empty( ::aWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( ::aWhen[j] )
      ENDIF
      IF ! Empty( ::avalid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::avalid[j] )
      ENDIF
      IF ! Empty( ::aValidMess[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALIDMESSAGES ' + AllTrim( ::aValidMess[j] )
      ENDIF
      IF ! Empty( ::aReadOnlyB[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY ' + AllTrim( ::aReadOnlyB[j] )
      ENDIF
      IF ::aLock[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LOCK '
      ENDIF
      IF ::aDelete[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELETE '
      ENDIF
      IF ::aInPlace[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPLACE '
      ENDIF
      IF ::aEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDIT '
      ENDIF
      IF ::anolines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( ::aJustify[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aAppend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'APPEND '
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aFull[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FULLMOVE '
      ENDIF
      IF ::aButtons[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'USEBUTTONS '
      ENDIF
      IF ::aNoHeaders[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHEADERS '
      ENDIF
      IF ! Empty( ::aHeaderImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERIMAGES ' + AllTrim( ::aHeaderImages[j] )
      ENDIF
      IF ! Empty( ::aImagesAlign[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESALIGN ' + AllTrim( ::aImagesAlign[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELECTEDCOLORS ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ! Empty( ::aEditKeys[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDITKEYS ' + AllTrim( ::aEditKeys[j] )
      ENDIF
      IF ::aDoubleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DOUBLEBUFFER '
      ENDIF
      IF ::aSingleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEBUFFER '
      ENDIF
      IF ::aFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSRECT '
      ENDIF
      IF ::aNoFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOFOCUSRECT '
      ENDIF
      IF ::aPLM[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PAINTLEFTMARGIN '
      ENDIF
      IF ::aFixedCols[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCOLS '
      ENDIF
      IF ! Empty( ::aOnAbortEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ABORTEDIT ' + AllTrim( ::aOnAbortEdit[j] )
      ENDIF
      IF ::aFixedWidths[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDWIDTHS '
      ENDIF
      IF ! Empty( ::aBeforeColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLMOVE ' + AllTrim( ::aBeforeColMove[j] )
      ENDIF
      IF ! Empty( ::aAfterColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLMOVE ' + AllTrim( ::aAfterColMove[j] )
      ENDIF
      IF ! Empty( ::aBeforeColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLSIZE ' + AllTrim( ::aBeforeColSize[j] )
      ENDIF
      IF ! Empty( ::aAfterColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLSIZE ' + AllTrim( ::aAfterColSize[j] )
      ENDIF
      IF ! Empty( ::aBeforeAutoFit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFOREAUTOFIT ' + AllTrim( ::aBeforeAutoFit[j] )
      ENDIF
      IF ::aLikeExcel[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'EDITLIKEEXCEL '
      ENDIF
      IF ! Empty( ::aDeleteWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEWHEN ' + AllTrim( ::aDeleteWhen[j] )
      ENDIF
      IF ! Empty( ::aDeleteMsg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEMSG ' + AllTrim( ::aDeleteMsg[j] )
      ENDIF
      IF ! Empty( ::aOnDelete[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DELETE ' + AllTrim( ::aOnDelete[j] )
      ENDIF
      IF ::aNoDelMsg[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NODELETEMSG '
      ENDIF
      IF ::aFixedCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCONTROLS '
      ENDIF
      IF ::aDynamicCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICCONTROLS '
      ENDIF
      IF ! Empty( ::aOnHeadRClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADRCLICK ' + AllTrim( ::aOnHeadRClick[j] )
      ENDIF
      IF ::aExtDblClick[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXTDBLCLICK '
      ENDIF
      IF ::anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ! Empty( ::aReplaceField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'REPLACEFIELD ' + AllTrim( ::aReplaceField[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aRecCount[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RECCOUNT '
      ENDIF
      IF ! Empty( ::aColumnInfo[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNINFO ' + AllTrim( ::aColumnInfo[j] )
      ENDIF
      IF ::aDescend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DESCENDING '
      ENDIF
      IF ::aFixBlocks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDBLOCKS '
      ELSEIF ::aDynBlocks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBLOCKS '
      ENDIF
      IF ::aUpdateColors[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDATECOLORS '
      ENDIF
      IF ::aShowNone[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOSHOWEMPTYROW '
      ENDIF
      IF ::aNoModalEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NOMODALEDIT '
      ENDIF
      IF ::aByCell[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NAVIGATEBYCELL '
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'ACTIVEX'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' ACTIVEX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PROGID ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PROGID ' + StrToStr( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'CHECKLIST'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKLIST ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( ::aItems[j] )
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( ::aJustify[j] )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELECTEDCOLORS ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aSort[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SORT '
      ENDIF
      IF ::aDescend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DESCENDING '
      ENDIF
      IF ::aDoubleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DOUBLEBUFFER '
      ENDIF
      IF ::aSingleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEBUFFER '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'HOTKEYBOX'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' HOTKEYBOX ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::aValue[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnEnter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aOnEnter[j] )
      ENDIF
      IF ::aNoPrefix[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOALT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PICTURE'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' PICTURE ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ::aStretch[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRETCH '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NODIBSECTION '
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ::aImageSize[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESIZE '
      ENDIF
      IF ! Empty( ::aExclude[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXCLUDEAREA ' + AllTrim( ::aExclude[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PROGRESSMETER'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' PROGRESSMETER ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'SCROLLBAR'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' SCROLLBAR ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aFlat[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HORIZONTAL '
      ELSEIF ::aVertical[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VERTICAL '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOMOVE '
      ENDIF
      IF ::aAppend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ATTACHED '
      ENDIF
      IF ::aIncrement[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LINESKIP ' + LTrim( Str( ::aIncrement[j] ) )
      ENDIF
      IF ::aIndent[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PAGESKIP ' + LTrim( Str( ::aIndent[j] ) )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         IF ::aFlat[j]   // HORIZONTAL
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LINELEFT ' + AllTrim( ::aOnDblClick[j] )
         ELSE
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LINEUP ' + AllTrim( ::aOnDblClick[j] )
         ENDIF
      ENDIF
      IF ! Empty( ::aOnDelete[j] )
         IF ::aFlat[j]   // HORIZONTAL
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LINERIGHT ' + AllTrim( ::aOnDelete[j] )
         ELSE
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LINEDOWN ' + AllTrim( ::aOnDelete[j] )
         ENDIF
      ENDIF
      IF ! Empty( ::aOnDrop[j] )
         IF ::aFlat[j]   // HORIZONTAL
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON PAGELEFT ' + AllTrim( ::aOnDrop[j] )
         ELSE
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON PAGEUP ' + AllTrim( ::aOnDrop[j] )
         ENDIF
      ENDIF
      IF ! Empty( ::aOnEditCell[j] )
         IF ::aFlat[j]   // HORIZONTAL
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON PAGERIGHT ' + AllTrim( ::aOnEditCell[j] )
         ELSE
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON PAGEDOWN ' + AllTrim( ::aOnEditCell[j] )
         ENDIF
      ENDIF
      IF ! Empty( ::aOnEnter[j] )
         IF ::aFlat[j]   // HORIZONTAL
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LEFT ' + AllTrim( ::aOnEnter[j] )
         ELSE
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON TOP ' + AllTrim( ::aOnEnter[j] )
         ENDIF
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         IF ::aFlat[j]   // HORIZONTAL
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON RIGHT ' + AllTrim( ::aOnGotFocus[j] )
         ELSE
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON BOTTOM ' + AllTrim( ::aOnGotFocus[j] )
         ENDIF
      ENDIF
      IF ! Empty( ::aOnHScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON THUMB ' + AllTrim( ::aOnHScroll[j] )
      ENDIF
      IF ! Empty( ::aOnLabelEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON TRACK ' + AllTrim( ::aOnLabelEdit[j] )
      ENDIF
      IF ! Empty( ::aOnListClose[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENDTRACK ' + AllTrim( ::aOnListClose[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TEXTARRAY'
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TEXTARRAY ' + ::aName[j] + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ::aItemCount[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ROWCOUNT ' + LTrim( Str( ::aItemCount[j] ) )
      ENDIF
      IF ::aIncrement[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLCOUNT ' + LTrim( Str( ::aIncrement[j] ) )
      ENDIF
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::aValue[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

/*
   TODO: Add this controls

   INTERNAL
   SPLITBOX
*/
RETURN Output

//------------------------------------------------------------------------------
METHOD Properties_Click() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, cName, j, cTitle, aLabels, aInitValues, cNameW, ia
LOCAL aFormats, aResults

   ia := ::nHandleA
   IF ia <= 0
      RETURN NIL
   ENDIF

   oControl := ::oDesignForm:aControls[ia]
   cName := Lower( oControl:Name )
   j := aScan( ::aControlW, cName )
   IF j <= 0
      RETURN NIL
   ENDIF

   cNameW := ::aName[j]

   IF ::aCtrlType[j] == 'TAB'
      DO WHILE .T.
         ::TabProperties( j, oControl )
         DO CASE
         CASE ! IsValidArray( ::aCaption[j] )
            MsgStop( "Pages' Caption is not a valid array !!!", 'OOHG IDE+' )
         CASE ! IsValidArray( ::aImage[j] )
            MsgStop( "Pages' Image is not a valid array !!!", 'OOHG IDE+' )
         CASE ! IsValidArray( ::aPageNames[j] )
            MsgStop( "Pages' Name is not a valid array !!!", 'OOHG IDE+' )
         CASE ! IsValidArray( ::aPageObjs[j] )
            MsgStop( "Pages' Obj is not a valid array !!!", 'OOHG IDE+' )
         CASE ! IsValidArray( ::aPageSubClasses[j] )
            MsgStop( "Pages' Subclass is not a valid array !!!", 'OOHG IDE+' )
         OTHERWISE
            EXIT
         ENDCASE
      ENDDO
   ENDIF

   IF ::aCtrlType[j] == 'FRAME'
     cTitle      := cNameW + " properties"
     aLabels     := { 'Name',     'Caption',     'Opaque',     'Transparent',     'Enabled',     'Visible',     'Obj',      'RTL',     'SubClass' }
     aInitValues := { ::aName[j], ::aCaption[j], ::aopaque[j], ::atransparent[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aSubClass[j] }
     aFormats    := { 30,         30,            .F.,          .F.,               .F.,           .F.,           31,         .F.,       250 }
     aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aCaption[j]          := aResults[02]
      ::aopaque[j]           := aResults[03]
      ::atransparent[j]      := aResults[04]
      ::aenabled[j]          := aResults[05]
      ::avisible[j]          := aResults[06]
      ::acobj[j]             := aResults[07]
      ::aRTL[j]              := aResults[08]
      ::aSubClass[j]         := aResults[09]
   ENDIF

   IF ::aCtrlType[j] == 'TEXT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'ToolTip',      'MaxLength',     'UpperCase',     'RightAlign',     'Value',     'Password',     'LowerCase',     'Numeric',     'InputMask',     'HelpID',     'Field',     'ReadOnly',     'Enabled',     'Visible',     'NoTabStop',     'Date',     'Format',     'FocusedPos',     'Valid',     'When',     'Obj',      'Action',     'Action2',     'Image',     'CenterAlign',     'RTL',     'NoBorder',   'AutoSkip',     'DefaultYear',     'ButtonWidth',     'InsertType',     'SubClass' }
      aInitValues := { ::aName[j], ::atooltip[j],  ::amaxlength[j], ::auppercase[j], ::arightalign[j], ::aValue[j], ::apassword[j], ::alowercase[j], ::anumeric[j], ::ainputmask[j], ::aHelpID[j], ::afield[j], ::areadonly[j], ::aenabled[j], ::avisible[j], ::aNoTabStop[j], ::adate[j], ::afields[j], ::afocusedpos[j], ::avalid[j], ::awhen[j], ::acobj[j], ::aaction[j], ::aaction2[j], ::aimage[j], ::aCenterAlign[j], ::aRTL[j], ::aBorder[j], ::aAutoPlay[j], ::aDefaultYear[j], ::aButtonWidth[j], ::aInsertType[j], ::aSubClass[j] }
      aFormats    := { 30,         120,            '999',           .F.,             .F.,              40,          .F.,            .F.,             .F.,           30,              '999',        250,         .F.,            .F.,           .F.,           .F.,             .F.,        30,           '99',             250,         250,        31,         250,          250,           250,         .F.,               .F.,       .F.,          .F.,            '9999',           '9999',             '9',              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aToolTip[j]          := aResults[02]
      ::aMaxLength[j]        := IIF( ! Empty( aResults[10] ) .OR. aResults[17], 0, Max( aResults[03], 0 ) )
      ::aUpperCase[j]        := aResults[04]
      ::aRightAlign[j]       := IIF( aResults[26], .F., aResults[05] )
      ::aValue[j]            := aResults[06]
      ::aPassword[j]         := aResults[07]
      ::aLowerCase[j]        := IIF( aResults[04], .F., aResults[08] )
      ::aNumeric[j]          := aResults[09]
      ::aInputMask[j]        := aResults[10]
      ::aHelpID[j]           := aResults[11]
      ::aField[j]            := aResults[12]
      ::aReadOnly[j]         := aResults[13]
      ::aEnabled[j]          := aResults[14]
      ::aVisible[j]          := aResults[15]
      ::aNoTabStop[j]        := aResults[16]
      ::aDate[j]             := aResults[17]
      ::aFields[j]           := aResults[18]           // FORMAT
      ::aFocusedPos[j]       := aResults[19]
      ::aValid[j]            := aResults[20]
      ::aWhen[j]             := aResults[21]
      ::aCObj[j]             := aResults[22]
      ::aAction[j]           := aResults[23]
      ::aAction2[j]          := aResults[24]
      ::aImage[j]            := aResults[25]
      ::aCenterAlign[j]      := aResults[26]
      ::aRTL[j]              := aResults[27]
      ::aBorder[j]           := aResults[28]
      ::aAutoPlay[j]         := aResults[29]
      ::aDefaultYear[j]      := aResults[30]
      ::aButtonWidth[j]      := aResults[31]
      ::aInsertType[j]       := aResults[32]
      ::aSubClass[j]         := aResults[33]
   ENDIF

   IF ::aCtrlType[j] == 'IPADDRESS'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'ToolTip',     'Value',     'HelpID',     'Enabled',     'Visible',     'NoTabStop',     'Obj',      "RTL",     'SubClass' }
      aInitValues := { ::aName[j], ::atooltip[j], ::aValue[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::aNoTabStop[j], ::acobj[j], ::aRTL[j], ::aSubClass[j] }
      aFormats    := { 30,         120,           30,          '999',        .T.,           .T.,           .F.,             31,         .F.,       250   }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aTooltip[j]          := aResults[02]
      ::aValue[j]            := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::aenabled[j]          := aResults[05]
      ::avisible[j]          := aResults[06]
      ::aNoTabStop[j]        := aResults[07]
      ::acobj[j]             := aResults[08]
      ::aRTL[j]              := aResults[09]
      ::aSubClass[j]         := aResults[10]
   ENDIF

   IF ::aCtrlType[j] == 'HYPERLINK'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'ToolTip',     'Value',     'HelpID',     'Enabled',     'Visible',     'Address',     'HandCursor',     'Obj',      'AutoSize',     'Border',     'ClientEdge',     'HScroll',       'VScroll',       'Transparent',     'RTL' }
      aInitValues := { ::aName[j], ::atooltip[j], ::aValue[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::aaddress[j], ::ahandcursor[j], ::acobj[j], ::aAutoPlay[j], ::aBorder[j], ::aClientEdge[j], ::aNoHScroll[j], ::aNoVScroll[j], ::aTransparent[j], ::aRTL[j] }
      aFormats    := { 30,         120,           30,          '999',        .T.,           .T.,           60,            .F.,              31,         .F.,            .F.,          .F.,              .F.,             .F.,             .F.,               .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aToolTip[j]          := aResults[02]
      ::aValue[j]            := IIF( Empty( aResults[03] ), ::aValue[j], aResults[03] )
      ::aHelpID[j]           := aResults[04]
      ::aEnabled[j]          := aResults[05]
      ::aVisible[j]          := aResults[06]
      ::aAddress[j]          := aResults[07]
      ::aHandCursor[j]       := aResults[08]
      ::aCObj[j]             := aResults[09]
      ::aAutoPlay[j]         := aResults[10]
      ::aBorder[j]           := aResults[11]
      ::aClientEdge[j]       := aResults[12]
      ::aNoHScroll[j]        := aResults[13]
      ::aNoVScroll[j]        := aResults[14]
      ::aTransparent[j]      := aResults[15]
      ::aRTL[j]              := aResults[16]
   ENDIF

   IF ::aCtrlType[j] == 'TREE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'ToolTip',     'Enabled',     'Visible',     'NodeImages',     'ItemImages',     'NoRootButton',     'ItemIDs',     'HelpID',     'Obj',      'FullRowSelect', 'Value',      'RTL',     'Break',     'NoTabStop',     'SelColor',     'SelBold',     'CheckBoxes',     'EditLabels',     'NoHScroll',     'NoScroll',      'HotTracking',  'NoButtons',   'EnableDrag', 'EnableDrop', 'TargeT',     'SingleExpand',     'BorderLess', 'Valid',     'Indent',     'NoLines',     'SubClass' }
      aInitValues := { ::aName[j], ::atooltip[j], ::aenabled[j], ::avisible[j], ::Anodeimages[j], ::aitemimages[j], ::anorootbutton[j], ::aitemids[j], ::aHelpID[j], ::acobj[j], ::aFull[j],      ::aValueN[j], ::aRTL[j], ::aBreak[j], ::aNoTabStop[j], ::aSelColor[j], ::aSelBold[j], ::aCheckBoxes[j], ::aEditLabels[j], ::aNoHScroll[j], ::aNoVScroll[j], ::aHotTrack[j], ::aButtons[j], ::aDrag[j],   ::aDrop[j],   ::aTarget[j], ::aSingleExpand[j], ::aBorder[j], ::aValid[j], ::aIndent[j], ::aNoLines[j], ::aSubClass[j] }
      aFormats    := { 60,         120,           .T.,           .T.,           60,               60,               .F.,                .F.,           '999',        31,         .F.,             '999999',     .F.,       .F.,         .F.,             250,            .F.,           .F.,              .F.,              .F.,             .F.,             .F.,            .F.,           .F.,          .F.,          250,          .F.,                .F.,          250,         '999',        .F.,           250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::atooltip[j]          := aResults[02]
      ::aenabled[j]          := aResults[03]
      ::avisible[j]          := aResults[04]
      ::anodeimages[j]       := aResults[05]
      ::aitemimages[j]       := aResults[06]
      ::anorootbutton[j]     := aResults[07]
      ::aitemids[j]          := aResults[08]
      ::aHelpID[j]           := aResults[09]
      ::acobj[j]             := aResults[10]
      ::aFull[j]             := aResults[11]           // FULLROWSELECT
      ::aValueN[j]           := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aBreak[j]            := aResults[14]
      ::aNoTabStop[j]        := aResults[15]
      ::aSelColor[j]         := aResults[16]
      ::aSelBold[j]          := aResults[17]
      ::aCheckBoxes[j]       := aResults[18]
      ::aEditLabels[j]       := aResults[19]
      ::aNoHScroll[j]        := aResults[20]
      ::aNoVScroll[j]        := aResults[21]
      ::aHotTrack[j]         := aResults[22]
      ::aButtons[j]          := aResults[23]           // NOBUTTONS
      ::aDrag[j]             := aResults[24]           // ENABLEDRAG
      ::aDrop[j]             := aResults[25]           // ENABLEDROP
      ::aTarget[j]           := aResults[26]
      ::aSingleExpand[j]     := aResults[27]
      ::aBorder[j]           := aResults[28]           // BORDERLESS
      ::aValid[j]            := aResults[29]
      ::aIndent[j]           := aResults[30]
      ::aNoLines[j]          := aResults[31]
      ::aSubClass[j]         := aResults[32]
   ENDIF

   IF ::aCtrlType[j] == 'EDIT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'ToolTip',     'MaxLength',     'ReadOnly',     'Value',     'HelpID',     'Break',     'Field',     'Enabled',     'Visible',     'NoTabStop',     'NoVScroll',     'NoHScroll',     'Obj',      'RTL',     'NoBorder',   'FocusedPos' }
      aInitValues := { ::aName[j], ::atooltip[j], ::amaxlength[j], ::areadonly[j], ::aValue[j], ::aHelpID[j], ::abreak[j], ::afield[j], ::aenabled[j], ::avisible[j], ::aNoTabStop[j], ::anovscroll[j], ::anohscroll[j], ::acobj[j], ::aRTL[j], ::aBorder[j], ::aFocusedPos[j] }
      aFormats    := { 30,         120,           '999999',        .F.,            800,         '999',        .F.,         250,         .F.,           .F.,           .F.,             .F.,             .F.,             31,         .F.,       .F.,          '99' }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::atooltip[j]          := aResults[02]
      ::amaxlength[j]        := Max( aResults[03],  0 )
      ::areadonly[j]         := aResults[04]
      ::aValue[j]            := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::abreak[j]            := aResults[07]
      ::afield[j]            := aResults[08]
      ::aenabled[j]          := aResults[09]
      ::avisible[j]          := aResults[10]
      ::aNoTabStop[j]        := aResults[11]
      ::anovscroll[j]        := aResults[12]
      ::anohscroll[j]        := aResults[13]
      ::acobj[j]             := aResults[14]
      ::aRTL[j]              := aResults[15]
      ::aBorder[j]           := aResults[16]           // NOBORDER
      ::aFocusedPos[j]       := aResults[17]
   ENDIF

   IF ::aCtrlType[j] == 'RICHEDIT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'ToolTip',     'MaxLength',     'ReadOnly',     'Value',     'HelpID',     'Break',     'Field',     'Enabled',     'Visible',     'NoTabStop',     'Obj',      'NoHideSel',     'PlainText',     'FileType',     'RTL',     'FocusedPos',     'NoVScroll',     'NoHScroll',     'File',     'SubClass' }
      aInitValues := { ::aName[j], ::atooltip[j], ::amaxlength[j], ::areadonly[j], ::aValue[j], ::aHelpID[j], ::abreak[j], ::afield[j], ::aenabled[j], ::avisible[j], ::aNoTabStop[j], ::acobj[j], ::aNoHideSel[j], ::aPlainText[j], ::aFileType[j], ::aRTL[j], ::aFocusedPos[j], ::aNoVScroll[j], ::aNoHScroll[j], ::aFile[j], ::aSubClass[j] }
      aFormats    := { 30,         120,           '999999',        .F.,            800,         '999',        .F.,         250,         .F.,           .F.,           .F.,             31,         .F.,             .F.,             '9',            .F.,       '99',             .F.,             .F.,             250,        250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aToolTip[j]          := aResults[02]
      ::aMaxLength[j]        := Max( aResults[03], 0 )
      ::aReadonly[j]         := aResults[04]
      ::aValue[j]            := IIF( Empty( aResults[05] ), "", aResults[05] )
      ::aHelpID[j]           := aResults[06]
      ::aBreak[j]            := aResults[07]
      ::aField[j]            := aResults[08]
      ::aEnabled[j]          := aResults[09]
      ::aVisible[j]          := aResults[10]
      ::aNoTabStop[j]        := aResults[11]
      ::aCObj[j]             := aResults[12]
      ::aNoHideSel[j]        := aResults[13]
      ::aPlainText[j]        := aResults[14]
      ::aFileType[j]         := aResults[15]
      ::aRTL[j]              := aResults[16]
      ::aFocusedPos[j]       := aResults[17]
      ::aNoVScroll[j]        := aResults[18]
      ::aNoHScroll[j]        := aResults[19]
      ::aFile[j]             := aResults[20]
      ::aSubClass[j]         := aResults[21]
   ENDIF

   IF ::aCtrlType[j] == 'GRID'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Headers',     'Widths',     'Items',     'Value',      'ToolTip',     'MultiSelect',     'NoLines',     'Image',     'HelpID',     'Break',     'Justify',     'Enabled',     'Visible',     "DynamicBackColor",     "DynamicForeColor",     "ColumnControls",     "Valid",     "ValidMessages", "When",     "ReadOnly",      "InPlace",     "InputMask",     "Edit",     'Obj',      'Virtual',     'ItemCount',     'NoHeaders',     'HeaderImages',     'ImagesAlign',     'NavigateByCell', 'SelectedColor', 'EditKeys',     'DoubleBuffer',     'SingleBuffer',     "FocusedRect",   'NoFocusedRect',   'PaintLeftMargin', 'FixedCols',     'FixedWidths',     'BeforeColMove',     'AfterColMove',     'BeforeColSize',     'AfterColSize',     'BeforeAutoFit',     'LikeExcel',     'DeleteWhen',     'DeleteMsg',     'NoDelMsg',     'NoModalExit',     'FixedControls',  'DynamicControls',  'NoClickOnCheckBox',  'NoRClickOnCheckbox',  'ExtDblClick',     'SubClass'}
      aInitValues := { ::aName[j], ::aheaders[j], ::awidths[j], ::aitems[j], ::aValueN[j], ::atooltip[j], ::amultiselect[j], ::anolines[j], ::aimage[j], ::aHelpID[j], ::abreak[j], ::ajustify[j], ::aenabled[j], ::avisible[j], ::adynamicbackcolor[j], ::adynamicforecolor[j], ::acolumncontrols[j], ::avalid[j], ::avalidmess[j], ::awhen[j], ::areadonlyb[j], ::ainplace[j], ::ainputmask[j], ::aedit[j], ::acobj[j], ::aVirtual[j], ::aItemCount[j], ::aNoHeaders[j], ::aHeaderImages[j], ::aImagesAlign[j], ::aByCell[j],     ::aSelColor[j],  ::aEditKeys[j], ::aDoubleBuffer[j], ::aSingleBuffer[j], ::aFocusRect[j], ::aNoFocusRect[j], ::aPLM[j],         ::aFixedCols[j], ::aFixedWidths[j], ::aBeforeColMove[j], ::aAfterColMove[j], ::aBeforeColSize[j], ::aAfterColSize[j], ::aBeforeAutoFit[j], ::aLikeExcel[j], ::aDeleteWhen[j], ::aDeleteMsg[j], ::aNoDelMsg[j], ::aNoModalEdit[j], ::aFixedCtrls[j], ::aDynamicCtrls[j], ::aNoClickOnCheck[j], ::aNoRClickOnCheck[j], ::aExtDblClick[j], ::aSubClass[j] }
      aFormats    := { 30,         800,           800,          800,         "999999",     250,           .F.,               .F.,           60,          '999',        .F.,         350,           .F.,           .F.,           350,                    350,                    800,                  800,         800,             800,        800,             .T.,           800,             .T.,        31,         .F.,           '9999',          .F.,             250,                250,               .F.,              250,             250,            .F.,                .F.,                .F.,             .F.,               .F.,               .F.,             .F.,               250,                 250,                250,                 250,                250,                 .F.,             250,              250,             250,            .F.,               .F.,              .F.,                .F.,                  .F.,                   .F.,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aheaders[j]          := aResults[02]
      ::awidths[j]           := aResults[03]
      ::aitems[j]            := aResults[04]
      ::aValueN[j]           := aResults[05]
      ::atooltip[j]          := aResults[06]
      ::amultiselect[j]      := aResults[07]
      ::anolines[j]          := aResults[08]
      ::aimage[j]            := aResults[09]
      ::aHelpID[j]           := aResults[10]
      ::aBreak[j]            := aResults[11]
      ::aJustify[j]          := IIF( Empty( aResults[12] ), ::aJustify[j], aResults[12] )
      ::aenabled[j]          := aResults[13]
      ::avisible[j]          := aResults[14]
      ::adynamicbackcolor[j] := aResults[15]
      ::adynamicforecolor[j] := aResults[16]
      ::acolumncontrols[j]   := aResults[17]
      ::avalid[j]            := aResults[18]
      ::avalidmess[j]        := aResults[19]
      ::awhen[j]             := aResults[20]
      ::areadonlyb[j]        := aResults[21]
      ::ainplace[j]          := aResults[22]
      ::ainputmask[j]        := aResults[23]
      ::aedit[j]             := aResults[24]
      ::acobj[j]             := aResults[25]
      ::aVirtual[j]          := aResults[26]
      ::aItemCount[j]        := aResults[27]
      ::aNoHeaders[j]        := aResults[28]
      ::aHeaderImages[j]     := aResults[29]
      ::aImagesAlign[j]      := aResults[30]
      ::aByCell[j]           := aResults[31]
      ::aSelColor[j]         := aResults[32]
      ::aEditKeys[j]         := aResults[33]
      ::aDoubleBuffer[j]     := aResults[34]
      ::aSingleBuffer[j]     := aResults[35]
      ::aFocusRect[j]        := aResults[36]
      ::aNoFocusRect[j]      := aResults[37]
      ::aPLM[j]              := aResults[38]
      ::aFixedCols[j]        := aResults[39]
      ::aFixedWidths[j]      := aResults[40]
      ::aBeforeColMove[j]    := aResults[41]
      ::aAfterColMove[j]     := aResults[42]
      ::aBeforeColSize[j]    := aResults[43]
      ::aAfterColSize[j]     := aResults[44]
      ::aBeforeAutoFit[j]    := aResults[45]
      ::aLikeExcel[j]        := aResults[46]
      ::aDeleteWhen[j]       := aResults[47]
      ::aDeleteMsg[j]        := aResults[48]
      ::aNoDelMsg[j]         := aResults[49]
      ::aNoModalEdit[j]      := aResults[50]
      ::aFixedCtrls[j]       := aResults[51]
      ::aDynamicCtrls[j]     := aResults[52]
      ::aNoClickOnCheck[j]   := aResults[53]
      ::aNoRClickOnCheck[j]  := aResults[54]
      ::aExtDblClick[j]      := aResults[55]
      ::aSubClass[j]         := aResults[56]
   ENDIF

   IF ::aCtrlType[j] == 'LABEL'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',     'HelpID',     'Transparent',     'CenterAlign',     'RightAlign',     'ToolTip',     'AutoSize',     "Enabled",     "Visible",     "ClientEdge",     "Border",    'Obj',      "InputMask",      'HScroll',       'VScroll',       'RTL',     'NoWrap',   'NoPrefix',     'SubClass' }
      aInitValues := { ::aName[j], ::aValue[j], ::aHelpID[j], ::atransparent[j], ::acenteralign[j], ::arightalign[j], ::atooltip[j], ::aautoplay[j], ::aenabled[j], ::avisible[j], ::aclientedge[j], ::aborder[j], ::acobj[j], ::ainputmask[j], ::aNoHScroll[j], ::aNoVScroll[j], ::aRTL[j], ::aWrap[j], ::aNoPrefix[j], ::aSubClass[j] }
      aFormats    := { 30,         300,         '999',        .F.,               .F.,               .F.,              120,           .F.,            .F.,           .F.,           .F.,              .F.,          31,         800,             .F.,             .F.,             .F.,       .F.,        .F.,            250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValue[j]            := aResults[02]
      ::aHelpID[j]           := aResults[03]
      ::aTransparent[j]      := aResults[04]
      ::aCenterAlign[j]      := aResults[05]
      ::aRightAlign[j]       := aResults[06]
      ::aToolTip[j]          := aResults[07]
      ::aAutoPlay[j]         := aResults[08]           // AUTOSIZE
      ::aEnabled[j]          := aResults[09]
      ::aVisible[j]          := aResults[10]
      ::aClientEdge[j]       := aResults[11]
      ::aBorder[j]           := aResults[12]
      ::aCObj[j]             := aResults[13]
      ::aInputMask[j]        := aResults[14]
      ::aNoHScroll[j]        := aResults[15]
      ::aNoVScroll[j]        := aResults[16]
      ::aRTL[j]              := aResults[17]
      ::aWrap[j]             := aResults[18]           // NOWRAP
      ::aNoPrefix[j]         := aResults[19]
      ::aSubClass[j]         := aResults[20]
   ENDIF

   IF ::aCtrlType[j] == 'PROGRESSBAR'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Range',     'ToolTip',     'Vertical',     'Smooth',     'HelpID',     'Enabled',     'Visible',     'Obj',      'Value',      'RTL',     'Marquee' }
      aInitValues := { ::aName[j], ::aRange[j], ::atooltip[j], ::avertical[j], ::asmooth[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aValueN[j], ::aRTL[j], ::aMarquee[j] }
      aFormats    := { 30,         20,          120,           .F.,            .F.,          '999',        .F.,           .F.,           31,         '9999',       .F.,       '9999' }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aRange[j]            := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aVertical[j]         := aResults[04]
      ::aSmooth[j]           := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::aEnabled[j]          := aResults[07]
      ::aVisible[j]          := aResults[08]
      ::aCObj[j]             := aResults[09]
      ::aValueN[j]           := aResults[10]
      ::aRTL[j]              := aResults[11]
      ::aMarquee[j]          := aResults[12]
   ENDIF

   IF ::aCtrlType[j] == 'SLIDER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Range',     'Value ',     'ToolTip',     'Vertical',     'Both',     'Top',     'Left',     'HelpID',     'Enabled',     'Visible',     'Obj',      'NoTicks',     'NoTabStop',     'RTL',     'SubClass' }
      aInitValues := { ::aName[j], ::aRange[j], ::aValueN[j], ::atooltip[j], ::avertical[j], ::aboth[j], ::atop[j], ::aleft[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::anoticks[j], ::aNoTabStop[j], ::aRTL[j], ::aSubClass[j] }
      aFormats    := { 30,         20,          '999',        120,           .F.,            .F.,        .F.,       .F.,        '999',        .F.,           .F.,           31,         .F.,           .F.,             .F.,       250  }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aRange[j]            := aResults[02]
      ::aValueN[j]           := aResults[03]
      ::aToolTip[j]          := aResults[04]
      ::aVertical[j]         := aResults[05]
      ::aBoth[j]             := aResults[06]
      ::aTop[j]              := aResults[07]
      ::aLeft[j]             := aResults[08]
      ::aHelpID[j]           := aResults[09]
      ::aEnabled[j]          := aResults[10]
      ::aVisible[j]          := aResults[11]
      ::aCObj[j]             := aResults[12]
      ::aNoTicks[j]          := aResults[13]
      ::aNoTabStop[j]        := aResults[14]
      ::aRTL[j]              := aResults[15]
      ::aSubClass[j]         := aResults[16]
   ENDIF

   IF ::aCtrlType[j] == 'SPINNER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Range',     'Value ',     'ToolTip',     'HelpID',     'NoTabStop',     'Wrap',     'ReadOnly',     'Increment',     'Enabled',     'Visible',     'Obj',      'RTL',     'NoBorder' }
      aInitValues := { ::aName[j], ::aRange[j], ::aValueN[j], ::atooltip[j], ::aHelpID[j], ::aNoTabStop[j], ::awrap[j], ::areadonly[j], ::aincrement[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aBorder[j] }
      aFormats    := { 30,         30,          '99999',      120,           '999',        .F.,             .F.,        .F.,            '999999',        .F.,           .F.,           31,         .F.,       .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aRange[j]            := aResults[02]
      ::aValueN[j]           := aResults[03]
      ::atooltip[j]          := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::aNoTabStop[j]        := aResults[06]
      ::awrap[j]             := aResults[07]
      ::areadonly[j]         := aResults[08]
      ::aincrement[j]        := aResults[09]
      ::aenabled[j]          := aResults[10]
      ::avisible[j]          := aResults[11]
      ::acobj[j]             := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aBorder[j]           := aResults[14]           // NOBORDER
   ENDIF

   IF ::aCtrlType[j] == 'BUTTON'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Caption',     'ToolTip',     'HelpID',     'NoTabStop',     'Enabled',     'Visible',     'Flat',     'Picture',     "Alignment",   'Obj',      "RTL",     "NoPrefix",     "NoLoadTransp.",   "ForceScale",     "Cancel",     "MultiLine",     "Themed",     "No3DColors",     "AutoFit", "DIB Section",    "Buffer",     "HBitmap",     "ImageMargin",     'SubClass' }
      aInitValues := { ::aName[j], ::aCaption[j], ::atooltip[j], ::aHelpID[j], ::aNoTabStop[j], ::aenabled[j], ::avisible[j], ::aflat[j], ::aPicture[j], ::Ajustify[j], ::acobj[j], ::aRTL[j], ::aNoPrefix[j], ::aNoLoadTrans[j], ::aForceScale[j], ::aCancel[j], ::aMultiLine[j], ::aThemed[j], ::aNo3DColors[j], ::aFit[j], ::aDIBSection[j], ::aBuffer[j], ::aHBitmap[j], ::aImageMargin[j], ::aSubClass[j] }
      aFormats    := { 30,         300,           120,           '999',        .F.,             .T.,           .T.,           .T.,        40,            20,            31,         .F.,       .F.,            .F.,               .F.,              .F.,          .F.,             .F.,          .F.,              .F.,       .F.,              300,          300,           300,               300 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aCaption[j]          := aResults[02]
      ::atooltip[j]          := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::aNoTabStop[j]        := aResults[05]
      ::aenabled[j]          := aResults[06]
      ::avisible[j]          := aResults[07]
      ::aflat[j]             := aResults[08]
      ::apicture[j]          := aResults[09]
      ::ajustify[j]          := aResults[10]           // ALIGNMENT
      ::acobj[j]             := aResults[11]
      ::aRTL[j]              := aResults[12]
      ::aNoPrefix[j]         := aResults[13]
      ::aNoLoadTrans[j]      := aResults[14]
      ::aForceScale[j]       := aResults[15]
      ::aCancel[j]           := aResults[16]
      ::aMultiLine[j]        := aResults[17]
      ::aThemed[j]           := aResults[18]
      ::aNo3DColors[j]       := aResults[19]
      ::aFit[j]              := aResults[20]           // AUTOFIT
      ::aDIBSection[j]       := aResults[21]
      ::aBuffer[j]           := aResults[22]
      ::aHBitmap[j]          := aResults[23]
      ::aImageMargin[j]      := aResults[24]
      ::aSubClass[j]         := aResults[25]
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBOX'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',                                                           'Caption',     'ToolTip',     'HelpID',     'Field',     'Transparent',     'Enabled',     'Visible',     "NoTabStop",     'Obj',      'AutoSize',     "RTL",     "ThreeState",  "Themed",     "LeftAlign" }
      aInitValues := { ::aName[j], IIF( ::aValue[j] == '.T.', 1, IIF( ::aValue[j] == '.F.', 2, 3 ) ), ::aCaption[j], ::atooltip[j], ::aHelpID[j], ::afield[j], ::atransparent[j], ::aenabled[j], ::avisible[j], ::aNoTabStop[j], ::acobj[j], ::aautoplay[j], ::aRTL[j], ::a3State[j],  ::aThemed[j], ::aLeft[j] }
      aFormats    := { 30,         { '.T.', '.F.', 'NIL' },                                           31,            120,           '999',        250,         .F.,               .F.,           .F.,           .F.,             31,         .F.,            .F.,       .F.,           .F.,          .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValue[j]            := IIF( aResults[02] == 1, '.T.', IIF( aResults[02] == 2 .OR. ! aResults[14], '.F.', 'NIL' ) )
      ::aCaption[j]          := aResults[03]
      ::aToolTip[j]          := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::aField[j]            := aResults[06]
      ::aTransparent[j]      := aResults[07]
      ::aEnabled[j]          := aResults[08]
      ::aVisible[j]          := aResults[09]
      ::aNoTabStop[j]        := aResults[10]
      ::aCObj[j]             := aResults[11]
      ::aAutoPlay[j]         := aResults[12]           // AUTOSIZE
      ::aRTL[j]              := aResults[13]
      ::a3State[j]           := aResults[14]
      ::aThemed[j]           := aResults[15]
      ::aLeft[j]             := aResults[16]           // LEFTALIGN
   ENDIF

   IF ::aCtrlType[j] == 'LIST'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',      'Items',     'ToolTip',     'MultiSelect',     'HelpID',     'Break',     'NoTabStop',     'Sort',     'Enabled',     'Visible',     'Obj',      'RTL',     'NoVScroll',     'Image',     'Fit',     'TextHeight',     'SubClass' }
      aInitValues := { ::aName[j], ::aValueN[j], ::aitems[j], ::atooltip[j], ::amultiselect[j], ::aHelpID[j], ::abreak[j], ::aNoTabStop[j], ::asort[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aNoVScroll[j], ::aImage[j], ::aFit[j], ::aTextHeight[j], ::aSubClass[j] }
      aFormats    := { 30,         '999',        800,         120,           .F.,               '999',        .F.,         .F.,             .F.,        .F.,           .F.,           31,         .F.,       .F.,             250,         .F.,       '999',            250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValueN[j]           := aResults[02]
      ::aitems[j]            := aResults[03]
      ::atooltip[j]          := aResults[04]
      ::amultiselect[j]      := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::abreak[j]            := aResults[07]
      ::aNoTabStop[j]        := aResults[08]
      ::asort[j]             := aResults[09]
      ::aenabled[j]          := aResults[10]
      ::avisible[j]          := aResults[11]
      ::acobj[j]             := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aNoVScroll[j]        := aResults[14]
      ::aImage[j]            := aResults[15]
      ::aFit[j]              := aResults[16]
      ::aTextHeight[j]       := aResults[17]
      ::aSubClass[j]         := aResults[18]
   ENDIF

   IF ::aCtrlType[j] == 'BROWSE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Headers',     'Widths',     'WorkArea',     'Fields',     'Value ',     'ToolTip',     'Valid',     'ValidMessages', 'ReadOnly',      'Lock',     'Delete',     'NoLines',     'Image',     'Justify',     'HelpID',     'Enabled',     'Visible',     "When",     "DynamicBackColor",     "DynamicForeColor",     "ColumnControls",     "InputMask",     "InPlace",     "Edit",     "Append",     'Obj',      'Break',     'RTL',     'NoTabStop',     'FullMove',  'UseButtons',  'NoHeaders',     'HeaderImages',     'ImagesAlign',     'SelectedColors', 'EditKeys',     'DoubleBuffer',     'SingleBuffer',     'FocusRect',     'NoFocusRect',     'PaintLeftMargin', 'FixedCols',     'FixedWidths',     'LikeExcel',     'DeleteWhen',     'DeleteMsg',     'NoDeleteMsg',  'FixedControls',  'DynamicControls',  'FixedBlocks',   'DynamicBlocks', 'BeforeColMove',     'AfterColMove',     'BeforeColSize',     'AfterColSize',     'BeforeAutoFit',     'ExtDblClick',     'NoVScroll',     'NoRefresh',     'ForceRefresh',     'ReplaceField',     'SubClass',     'ColumnInfo',     'RecCount',     'Descending',  'Synchronized', 'UnSynchronized', 'UpdateColors',     'UpdateAll' }
      aInitValues := { ::aName[j], ::aheaders[j], ::awidths[j], ::aworkarea[j], ::afields[j], ::aValueN[j], ::atooltip[j], ::avalid[j], ::avalidmess[j], ::areadonlyb[j], ::alock[j], ::adelete[j], ::anolines[j], ::aimage[j], ::ajustify[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::awhen[j], ::adynamicbackcolor[j], ::adynamicforecolor[j], ::acolumncontrols[j], ::ainputmask[j], ::ainplace[j], ::aedit[j], ::aappend[j], ::acobj[j], ::aBreak[j], ::aRTL[j], ::aNoTabStop[j], ::aFull[j],  ::aButtons[j], ::aNoHeaders[j], ::aHeaderImages[j], ::aImagesAlign[j], ::aSelColor[j],   ::aEditKeys[j], ::aDoubleBuffer[j], ::aSingleBuffer[j], ::aFocusRect[j], ::aNoFocusRect[j], ::aPLM[j],         ::aFixedCols[j], ::aFixedWidths[j], ::aLikeExcel[j], ::aDeleteWhen[j], ::aDeleteMsg[j], ::aNoDelMsg[j], ::aFixedCtrls[j], ::aDynamicCtrls[j], ::aFixBlocks[j], ::aDynBlocks[j], ::aBeforeColMove[j], ::aAfterColMove[j], ::aBeforeColSize[j], ::aAfterColSize[j], ::aBeforeAutoFit[j], ::aExtDblClick[j], ::anovscroll[j], ::aNoRefresh[j], ::aForceRefresh[j], ::aReplaceField[j], ::aSubClass[j], ::aColumnInfo[j], ::aRecCount[j], ::aDescend[j], ::aSync[j],     ::aUnSync[j],     ::aUpdateColors[j], ::aUpdate[j] }
      aFormats    := { 30,         800,           800,          80,             800,          '999999',     250,           800,         800,             800,             .T.,        .F.,          .F.,           800,         800,           '99999',      .F.,           .F.,           800,        800,                    800,                    800,                  800,             .F.,           .F.,        .F.,          31,         .F.,         .F.,       .F.,             .F.,         .F.,           .F.,             250,                250,               250,              250,            .F.,                .F.,                .F.,             .F.,               .F.,               .F.,             .F.,               .F.,             250,              250,             .F.,            .F.,              .F.,                .F.,             .F.,             250,                 250,                250,                 250,                250,                 .F.,               .F.,             .F.,             .F.,                250,                250,            250,              .F.,            .F.,           .F.,            .F.,              .F.,                .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aheaders[j]          := aResults[02]
      ::awidths[j]           := aResults[03]
      ::aworkarea[j]         := aResults[04]
      ::afields[j]           := aResults[05]
      ::aValueN[j]           := aResults[06]
      ::atooltip[j]          := aResults[07]
      ::avalid[j]            := aResults[08]
      ::avalidmess[j]        := aResults[09]
      ::areadonlyb[j]        := aResults[10]
      ::alock[j]             := aResults[11]
      ::adelete[j]           := aResults[12]
      ::anolines[j]          := aResults[13]
      ::aimage[j]            := aResults[14]
      ::ajustify[j]          := aResults[15]
      ::aHelpID[j]           := aResults[16]
      ::aenabled[j]          := aResults[17]
      ::avisible[j]          := aResults[18]
      ::awhen[j]             := aResults[19]
      ::adynamicbackcolor[j] := aResults[20]
      ::adynamicforecolor[j] := aResults[21]
      ::acolumncontrols[j]   := aResults[22]
      ::ainputmask[j]        := aResults[23]
      ::ainplace[j]          := aResults[24]
      ::aedit[j]             := aResults[25]
      ::aappend[j]           := aResults[26]
      ::acobj[j]             := aResults[27]
      ::aBreak[j]            := aResults[28]
      ::aRTL[j]              := aResults[29]
      ::aNoTabStop[j]        := aResults[30]
      ::aFull[j]             := aResults[31]           // FULLMOVE
      ::aButtons[j]          := aResults[32]
      ::aNoHeaders[j]        := aResults[33]
      ::aHeaderImages[j]     := aResults[34]
      ::aImagesAlign[j]      := aResults[35]
      ::aSelColor[j]         := aResults[36]
      ::aEditKeys[j]         := aResults[37]
      ::aDoubleBuffer[j]     := aResults[38]
      ::aSingleBuffer[j]     := aResults[39]
      ::aFocusRect[j]        := aResults[40]
      ::aNoFocusRect[j]      := aResults[41]
      ::aPLM[j]              := aResults[42]
      ::aFixedCols[j]        := aResults[43]
      ::aFixedWidths[j]      := aResults[44]
      ::aLikeExcel[j]        := aResults[45]
      ::aDeleteWhen[j]       := aResults[46]
      ::aDeleteMsg[j]        := aResults[47]
      ::aNoDelMsg[j]         := aResults[48]
      ::aFixedCtrls[j]       := aResults[49]
      ::aDynamicCtrls[j]     := aResults[50]
      ::aFixBlocks[j]        := aResults[51]
      ::aDynBlocks[j]        := aResults[52]
      ::aBeforeColMove[j]    := aResults[53]
      ::aAfterColMove[j]     := aResults[54]
      ::aBeforeColSize[j]    := aResults[55]
      ::aAfterColSize[j]     := aResults[56]
      ::aBeforeAutoFit[j]    := aResults[57]
      ::aExtDblClick[j]      := aResults[58]
      ::anovscroll[j]        := aResults[59]
      ::aNoRefresh[j]        := aResults[60]
      ::aForceRefresh[j]     := aResults[61]
      ::aReplaceField[j]     := aResults[62]
      ::aSubClass[j]         := aResults[63]
      ::aColumnInfo[j]       := aResults[64]
      ::aRecCount[j]         := aResults[65]
      ::aDescend[j]          := aResults[66]
      ::aSync[j]             := aResults[67]
      ::aUnSync[j]           := aResults[68]
      ::aUpdateColors[j]     := aResults[69]
      ::aUpdate[j]           := aResults[70]           // UPDATEALL
   ENDIF

   IF ::aCtrlType[j] == 'XBROWSE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Headers',     'Widths',     'WorkArea',     'Fields',     'Value ',     'ToolTip',     'Valid',     'ValidMessages',  'ReadOnly',      'Lock',     'Delete',     'NoLines',     'Image',     'Justify',     'HelpID',     'Enabled',     'Visible',     "When",     "DynamicBackColor",     "DynamicForeColor",     "ColumnControls",     "InputMask",     "InPlace",     "Edit",     "Append",     'Obj',      'Break',     'RTL',     'NoTabStop',     'FullMove',  'UseButtons',  'NoHeaders',     'HeaderImages',     'ImagesAlign',     'SelectedColors', 'EditKeys',     'DoubleBuffer',     'SingleBuffer',     'FocusRect',     'NoFocusRect',     'PaintLeftMargin', 'FixedCols',     'FixedWidths',     'LikeExcel',     'DeleteWhen',     'DeleteMsg',     'NoDeleteMsg',  'FixedControls',  'DynamicControls',  'FixedBlocks',   'DynamicBlocks', 'BeforeColMove',     'AfterColMove',     'BeforeColSize',     'AfterColSize',     'BeforeAutoFit',     'ExtDblClick',     'NoVScroll',     'ReplaceField',     'SubClass',     'ColumnInfo',     'RecCount',     'Descending',  'UpdateColors',     'NoShowEmptyRow', 'NoModalEdit',     'NavigateBycell' }
      aInitValues := { ::aName[j], ::aheaders[j], ::awidths[j], ::aworkarea[j], ::afields[j], ::aValueN[j], ::atooltip[j], ::avalid[j], ::avalidmess[j],  ::areadonlyb[j], ::alock[j], ::adelete[j], ::anolines[j], ::aimage[j], ::ajustify[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::awhen[j], ::adynamicbackcolor[j], ::adynamicforecolor[j], ::acolumncontrols[j], ::ainputmask[j], ::ainplace[j], ::aedit[j], ::aappend[j], ::acobj[j], ::aBreak[j], ::aRTL[j], ::aNoTabStop[j], ::aFull[j],  ::aButtons[j], ::aNoHeaders[j], ::aHeaderImages[j], ::aImagesAlign[j], ::aSelColor[j],   ::aEditKeys[j], ::aDoubleBuffer[j], ::aSingleBuffer[j], ::aFocusRect[j], ::aNoFocusRect[j], ::aPLM[j],         ::aFixedCols[j], ::aFixedWidths[j], ::aLikeExcel[j], ::aDeleteWhen[j], ::aDeleteMsg[j], ::aNoDelMsg[j], ::aFixedCtrls[j], ::aDynamicCtrls[j], ::aFixBlocks[j], ::aDynBlocks[j], ::aBeforeColMove[j], ::aAfterColMove[j], ::aBeforeColSize[j], ::aAfterColSize[j], ::aBeforeAutoFit[j], ::aExtDblClick[j], ::anovscroll[j], ::aReplaceField[j], ::aSubClass[j], ::aColumnInfo[j], ::aRecCount[j], ::aDescend[j], ::aUpdateColors[j], ::aShowNone[j],   ::aNoModalEdit[j], ::aByCell[j] }
      aFormats    := { 30,         800,           800,          80,             800,          '999999',     250,           800,         800,              800,             .T.,        .F.,          .F.,           800,         800,           '99999',      .F.,           .F.,           800,        800,                    800,                    800,                  800,             .F.,           .F.,        .F.,          31,         .F.,         .F.,       .F.,             .F.,         .F.,           .F.,             250,                250,               250,              250,            .F.,                .F.,                .F.,             .F.,               .F.,               .F.,             .F.,               .F.,             250,              250,             .F.,            .F.,              .F.,                .F.,             .F.,             250,                 250,                250,                 250,                250,                 .F.,               .F.,             250,                250,            250,              .F.,            .F.,           .F.,                .F.,              .F.,               .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aheaders[j]          := aResults[02]
      ::awidths[j]           := aResults[03]
      ::aworkarea[j]         := aResults[04]
      ::afields[j]           := aResults[05]
      ::aValueN[j]           := aResults[06]
      ::atooltip[j]          := aResults[07]
      ::avalid[j]            := aResults[08]
      ::avalidmess[j]        := aResults[09]
      ::areadonlyb[j]        := aResults[10]
      ::alock[j]             := aResults[11]
      ::adelete[j]           := aResults[12]
      ::anolines[j]          := aResults[13]
      ::aimage[j]            := aResults[14]
      ::ajustify[j]          := aResults[15]
      ::aHelpID[j]           := aResults[16]
      ::aenabled[j]          := aResults[17]
      ::avisible[j]          := aResults[18]
      ::awhen[j]             := aResults[19]
      ::adynamicbackcolor[j] := aResults[20]
      ::adynamicforecolor[j] := aResults[21]
      ::acolumncontrols[j]   := aResults[22]
      ::ainputmask[j]        := aResults[23]
      ::ainplace[j]          := aResults[24]
      ::aedit[j]             := aResults[25]
      ::aappend[j]           := aResults[26]
      ::acobj[j]             := aResults[27]
      ::aBreak[j]            := aResults[28]
      ::aRTL[j]              := aResults[29]
      ::aNoTabStop[j]        := aResults[30]
      ::aFull[j]             := aResults[31]           // FULLMOVE
      ::aButtons[j]          := aResults[32]
      ::aNoHeaders[j]        := aResults[33]
      ::aHeaderImages[j]     := aResults[34]
      ::aImagesAlign[j]      := aResults[35]
      ::aSelColor[j]         := aResults[36]
      ::aEditKeys[j]         := aResults[37]
      ::aDoubleBuffer[j]     := aResults[38]
      ::aSingleBuffer[j]     := aResults[39]
      ::aFocusRect[j]        := aResults[40]
      ::aNoFocusRect[j]      := aResults[41]
      ::aPLM[j]              := aResults[42]
      ::aFixedCols[j]        := aResults[43]
      ::aFixedWidths[j]      := aResults[44]
      ::aLikeExcel[j]        := aResults[45]
      ::aDeleteWhen[j]       := aResults[46]
      ::aDeleteMsg[j]        := aResults[47]
      ::aNoDelMsg[j]         := aResults[48]
      ::aFixedCtrls[j]       := aResults[49]
      ::aDynamicCtrls[j]     := aResults[50]
      ::aFixBlocks[j]        := aResults[51]
      ::aDynBlocks[j]        := aResults[52]
      ::aBeforeColMove[j]    := aResults[53]
      ::aAfterColMove[j]     := aResults[54]
      ::aBeforeColSize[j]    := aResults[55]
      ::aAfterColSize[j]     := aResults[56]
      ::aBeforeAutoFit[j]    := aResults[57]
      ::aExtDblClick[j]      := aResults[58]
      ::anovscroll[j]        := aResults[59]
      ::aReplaceField[j]     := aResults[60]
      ::aSubClass[j]         := aResults[61]
      ::aColumnInfo[j]       := aResults[62]
      ::aRecCount[j]         := aResults[63]
      ::aDescend[j]          := aResults[64]
      ::aUpdateColors[j]     := aResults[65]
      ::aShowNone[j]         := aResults[66]
      ::aNoModalEdit[j]      := aResults[67]
      ::aByCell[j]           := aResults[68]
   ENDIF

   IF ::aCtrlType[j] == 'RADIOGROUP'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',      'Options',   'ToolTip',     'Spacing',     'HelpID',     'Transparent',     'Enabled',     'Visible',     'Obj',      'RTL',     'NoTabStop',     'AutoSize',     'Horizontal', 'Themed',     'Background',     'SubClass' }
      aInitValues := { ::aName[j], ::aValueN[j], ::aitems[j], ::atooltip[j], ::aspacing[j], ::aHelpID[j], ::atransparent[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aNoTabStop[j], ::aAutoPlay[j], ::aFlat[j],   ::aThemed[j], ::aBackground[j], ::aSubClass[j] }
      aFormats    := { 30,         '999',        250,         120,           '999',         '999',        .F.,               .F.,           .F.,           31,         .F.,       .F.,             .F.,            .F.,          .F.,          250,              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValueN[j]           := aResults[02]
      ::aItems[j]            := aResults[03]           // OPTIONS
      ::aToolTip[j]          := aResults[04]
      ::aSpacing[j]          := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::aTransparent[j]      := aResults[07]
      ::aEnabled[j]          := aResults[08]
      ::aVisible[j]          := aResults[09]
      ::aCObj[j]             := aResults[10]
      ::aRTL[j]              := aResults[11]
      ::aNoTabStop[j]        := aResults[12]
      ::aAutoPlay[j]         := aResults[13]           // AUTOSIZE
      ::aFlat[j]             := aResults[14]           // HORIZONTAL
      ::aThemed[j]           := aResults[15]
      ::aBackground[j]       := aResults[16]
      ::aSubClass[j]         := aResults[17]
   ENDIF

   IF ::aCtrlType[j] == 'COMBO'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',      'Items',     'ToolTip',     'HelpID',     'NoTabStop',     'Sort',     'ItemSource',     'Enabled',     'Visible',     'Valuesource',     "DisplayEdit",     'Obj',      'ItemImageNumber',     'ImageSource',     'FirstItem',     'ListWidth',     'DelayedLoad',     'Incremental',     'IntegralHeight',     'Refresh',     'NoRefresh',     'SourceOrder',     'SearchLapse',     'SubClass',     'Break',     'GripperText' }
      aInitValues := { ::aName[j], ::aValueN[j], ::aitems[j], ::atooltip[j], ::aHelpID[j], ::aNoTabStop[j], ::asort[j], ::aitemsource[j], ::aenabled[j], ::avisible[j], ::aValueSource[j], ::adisplayedit[j], ::acobj[j], ::aItemImageNumber[j], ::aImageSource[j], ::aFirstItem[j], ::aListWidth[j], ::aDelayedLoad[j], ::aIncremental[j], ::aIntegralHeight[j], ::aRefresh[j], ::aNoRefresh[j], ::aSourceOrder[j], ::aSearchLapse[j], ::aSubClass[j], ::aBreak[j], ::aGripperText[j] }
      aFormats    := { 30,         '999',        250,         120,           '999',        .F.,             .F.,        100,              .T.,           .T.,           100,               .F.,               31,         250,                   250,               .F.,             '999999',        .F.,               .F.,               .F.,                  .F.,           .F.,             250,               '999999',          250,            .F.,         250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValueN[j]           := aResults[02]
      ::aItems[j]            := IIF( Empty( aResults[08] ), '', aResults[03] )
      ::atooltip[j]          := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::aNoTabStop[j]        := aResults[06]
      ::asort[j]             := aResults[07]
      ::aitemsource[j]       := aResults[08]
      ::aenabled[j]          := aResults[09]
      ::avisible[j]          := aResults[10]
      ::aValueSource[j]      := aResults[11]
      ::adisplayedit[j]      := aResults[12]
      ::acobj[j]             := aResults[13]
      ::aItemImageNumber[j]  := aResults[14]
      ::aImageSource[j]      := aResults[15]
      ::aFirstItem[j]        := aResults[16]
      ::aListWidth[j]        := aResults[17]
      ::aDelayedLoad[j]      := aResults[18]
      ::aIncremental[j]      := aResults[19]
      ::aIntegralHeight[j]   := aResults[20]
      ::aRefresh[j]          := aResults[21]
      ::aNoRefresh[j]        := aResults[22]
      ::aSourceOrder[j]      := aResults[23]
      ::aSearchLapse[j]      := aResults[24]
      ::aSubClass[j]         := aResults[25]
      ::aBreak[j]            := aResults[26]
      ::aGripperText[j]      := aResults[27]
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBTN'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',      'Caption',     'ToolTip',     'HelpID',     'Enabled',     'Visible',     "NoTabStop",     'Obj',      'RTL',     'Picture',     'Buffer',     'HBitmap',     'NoLoadTransparent', 'ForceScale',     'Field',     'No3DColors',     'Fit',     'DIBSection',     'Themed',     "MultiLine",     'Flat',     'SubClass',     'ImageMargin',     'Align'                                                                                                                                                                                        }
      aInitValues := { ::aName[j], ::aValueL[j], ::aCaption[j], ::atooltip[j], ::aHelpID[j], ::aEnabled[j], ::aVisible[j], ::aNoTabStop[j], ::aCObj[j], ::aRTL[j], ::aPicture[j], ::aBuffer[j], ::aHBitmap[j], ::aNoLoadTrans[j],   ::aForceScale[j], ::aField[j], ::aNo3DColors[j], ::aFit[j], ::aDIBSection[j], ::aThemed[j], ::aMultiLine[j], ::aFlat[j], ::aSubClass[j], ::aImageMargin[j], IIF( ::aJustify[j] == "BOTTOM",  1,  IIF( ::aJustify[j] == "CENTER",  2,  IIF( ::aJustify[j] == "LEFT",  3,  IIF( ::aJustify[j] == "RIGHT",  4,  IIF( ::aJustify[j] == "TOP",  5,  6 ) ) ) ) ) }
      aFormats    := { 30,         .F.,          31,            120,           '999',        .F.,           .F.,           .F.,             31,         .F.,       250,           250,          250,           .F.,                 .F.,              250,         .F.,              .F.,       .F.,              .F.,          .F.,             .F.,        250,            250,               { 'BOTTOM',  'CENTER',  'LEFT',  'RIGHT',  'TOP',  'NONE' }                                                                                                                                    }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValueL[j]           := aResults[02]
      ::aCaption[j]          := aResults[03]
      ::aToolTip[j]          := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aNoTabStop[j]        := aResults[08]
      ::aCObj[j]             := aResults[09]
      ::aRTL[j]              := aResults[10]
      ::aPicture[j]          := aResults[11]
      ::aBuffer[j]           := aResults[12]
      ::aHBitmap[j]          := aResults[13]
      ::aNoLoadTrans[j]      := aResults[14]
      ::aForceScale[j]       := aResults[15]
      ::aField[j]            := aResults[16]
      ::aNo3DColors[j]       := aResults[17]
      ::aFit[j]              := aResults[18]
      ::aDIBSection[j]       := aResults[19]
      ::aThemed[j]           := aResults[20]
      ::aMultiLine[j]        := aResults[21]
      ::aFlat[j]             := aResults[22]
      ::aSubClass[j]         := aResults[23]
      ::aImageMargin[j]      := aResults[24]
      ::aJustify[j]          := IIF( aResults[25] == 1, 'BOTTOM', ;
                                IIF( aResults[25] == 2, 'CENTER', ;
                                IIF( aResults[25] == 3, 'LEFT', ;
                                IIF( aResults[25] == 4, 'RIGHT', ;
                                IIF( aResults[25] == 5, 'TOP', '' ) ) ) ) )    // ALIGN
   ENDIF

   IF ::aCtrlType[j] == 'PICCHECKBUTT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',      'Picture',     'ToolTip',     'HelpID',     'Enabled',     'Visible',     "NoTabStop",     'Obj',      'SubClass',     'Buffer',     'HBitmap',     'NoLoadTransparent', 'ForceScale',     'Field',     'No3DColors',     'AutoFit', 'DIBSection',     'Themed',     'Flat',     'ImageMargin',     'Align' }
      aInitValues := { ::aName[j], ::aValueL[j], ::apicture[j], ::atooltip[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::aNoTabStop[j], ::acobj[j], ::aSubClass[j], ::aBuffer[j], ::aHBitmap[j], ::aNoLoadTrans[j],   ::aForceScale[j], ::aField[j], ::aNo3DColors[j], ::aFit[j], ::aDIBSection[j], ::aThemed[j], ::aFlat[j], ::aImageMargin[j],  IIF( ::aJustify[j] == "BOTTOM",  1,  IIF( ::aJustify[j] == "CENTER",  2,  IIF( ::aJustify[j] == "LEFT",  3,  IIF( ::aJustify[j] == "RIGHT",  4,  IIF( ::aJustify[j] == "TOP",  5,  6 ) ) ) ) ) }
      aFormats    := { 30,         .F.,          31,            250,           '999',        .F.,           .F.,           .F.,             31,         250,            250,          250,            .F.,                .F.,              250,         .F.,              .F.,       .F.,              .F.,          .F.,        250,               { 'BOTTOM',  'CENTER',  'LEFT',  'RIGHT',  'TOP',  'NONE' } }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValueL[j]           := aResults[02]
      ::aPicture[j]          := aResults[03]
      ::aToolTip[j]          := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aNoTabStop[j]        := aResults[08]
      ::aCObj[j]             := aResults[09]
      ::aSubClass[j]         := aResults[10]
      ::aBuffer[j]           := aResults[11]
      ::aHBitmap[j]          := aResults[12]
      ::aNoLoadTrans[j]      := aResults[13]
      ::aForceScale[j]       := aResults[14]
      ::aField[j]            := aResults[15]
      ::aNo3DColors[j]       := aResults[16]
      ::aFit[j]              := aResults[17]           // AUTOFIT
      ::aDIBSection[j]       := aResults[18]
      ::aThemed[j]           := aResults[19]
      ::aFlat[j]             := aResults[20]
      ::aImageMargin[j]      := aResults[21]
      ::aJustify[j]          := IIF( aResults[22] == 1, 'BOTTOM', ;
                                IIF( aResults[22] == 2, 'CENTER', ;
                                IIF( aResults[22] == 3, 'LEFT', ;
                                IIF( aResults[22] == 4, 'RIGHT', ;
                                IIF( aResults[22] == 5, 'TOP', '' ) ) ) ) )    // ALIGN
   ENDIF

   IF ::aCtrlType[j] == 'PICBUTT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Picture',     'ToolTip',     'HelpID',     'NoTabStop',     'Enabled',     'Visible',     'Flat',     'Obj',      'Buffer',     'HBitmap',     'NoLoadTransparent', 'ForceScale',     'No3DColors',     'AutoFit', 'DIBSection',     'Themed',     'ImageMargin',     'Align',                                                                                                                                                                                         'Cancel',     'SubClass' }
      aInitValues := { ::aName[j], ::apicture[j], ::atooltip[j], ::aHelpID[j], ::aNoTabStop[j], ::aenabled[j], ::avisible[j], ::aflat[j], ::acobj[j], ::aBuffer[j], ::aHBitmap[j], ::aNoLoadTrans[j],   ::aForceScale[j], ::aNo3DColors[j], ::aFit[j], ::aDIBSection[j], ::aThemed[j], ::aImageMargin[j],  IIF( ::aJustify[j] == "BOTTOM",  1,  IIF( ::aJustify[j] == "CENTER",  2,  IIF( ::aJustify[j] == "LEFT",  3,  IIF( ::aJustify[j] == "RIGHT",  4,  IIF( ::aJustify[j] == "TOP",  5,  6 ) ) ) ) ), ::aCancel[j], ::aSubClass[j] }
      aFormats    := { 30,         30,            120,           '999',        .F.,             .T.,           .T.,           .F.,        31,         250,          250,           .F.,                 .F.,              .F.,              .F.,       .F.,              .F.,          120,               { 'BOTTOM',  'CENTER',  'LEFT',  'RIGHT',  'TOP',  'NONE' },                                                                                                                                     .F.,          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aPicture[j]          := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::aNoTabStop[j]        := aResults[05]
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aFlat[j]             := aResults[08]
      ::aCObj[j]             := aResults[09]
      ::aBuffer[j]           := aResults[10]
      ::aHBitmap[j]          := aResults[11]
      ::aNoLoadTrans[j]      := aResults[12]
      ::aForceScale[j]       := aResults[13]
      ::aNo3DColors[j]       := aResults[14]
      ::aFit[j]              := aResults[15]           // AUTOFIT
      ::aDIBSection[j]       := aResults[16]
      ::aThemed[j]           := aResults[17]
      ::aImageMargin[j]      := aResults[18]
      ::aJustify[j]          := IIF( aResults[19] == 1, 'BOTTOM', ;
                                IIF( aResults[19] == 2, 'CENTER', ;
                                IIF( aResults[19] == 3, 'LEFT', ;
                                IIF( aResults[19] == 4, 'RIGHT', ;
                                IIF( aResults[19] == 5, 'TOP', '' ) ) ) ) )    // ALIGN
      ::aCancel[j]           := aResults[20]
      ::aSubClass[j]         := aResults[21]
   ENDIF

   IF ::aCtrlType[j] == 'IMAGE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Picture',     'ToolTip',     'HelpID',     'Stretch',     'Enabled',     'Visible',     'Obj',      "ClientEdge",     "Border",     'Transparent',     'SubClass',     'RTL',     'Buffer',     'HBitmap',     'DIBSection',     'No3DColors',     'NoLoadTransparent', 'NoResize', 'WhiteBackground', 'ImageSize',     'ExcludeArea' }
      aInitValues := { ::aName[j], ::apicture[j], ::atooltip[j], ::aHelpID[j], ::astretch[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aclientedge[j], ::aborder[j], ::atransparent[j], ::aSubClass[j], ::aRTL[j], ::aBuffer[j], ::aHBitmap[j], ::aDIBSection[j], ::aNo3DColors[j], ::aNoLoadTrans[j],   ::aFit[j],  ::aWhiteBack[j],   ::aImageSize[j], ::aExclude[j] }
      aFormats    := { 30,         30,            120,           '999',        .F.,           .F.,           .F.,           31,         .F.,              .F.,          .F.,               250,            .F.,       250,          250,           .F.,              .F.,              .F.,                 .F.,        .F.,               .F.,             250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aPicture[j]          := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::aStretch[j]          := aResults[05]
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aCObj[j]             := aResults[08]
      ::aClientEdge[j]       := aResults[09]
      ::aBorder[j]           := aResults[10]
      ::aTransparent[j]      := aResults[11]
      ::aSubClass[j]         := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aBuffer[j]           := aResults[14]
      ::aHBitmap[j]          := aResults[15]
      ::aDIBSection[j]       := aResults[16]
      ::aNo3DColors[j]       := aResults[17]
      ::aNoLoadTrans[j]      := aResults[18]
      ::aFit[j]              := aResults[19]           // NORESIZE
      ::aWhiteBack[j]        := aResults[20]
      ::aImageSize[j]        := aResults[21]
      ::aExclude[j]          := aResults[22]
   ENDIF

   IF ::aCtrlType[j] == 'TIMER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Interval',   'Enabled',     'Obj',      'SubClass' }
      aInitValues := { ::aName[j], ::aValueN[j], ::aenabled[j], ::acobj[j], ::aSubClass[j] }
      aFormats    := { 30,         '9999999',    .F.,           31,         250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValueN[j]           := IIF( aResults[02] > 0, aResults[02], ::aValueN[j] )     // INTERVAL
      ::aEnabled[j]          := aResults[03]
      ::aCObj[j]             := aResults[04]
      ::aSubClass[j]         := aResults[05]
   ENDIF

   IF ::aCtrlType[j] == 'ANIMATE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'File',     'AutoPlay',     'Center ',    'Transparent',     'HelpID',     'ToolTip',     'Enabled',     'Visible',     'Obj',      'RTL',     'NoTabStop',     'SubClass' }
      aInitValues := { ::aName[j], ::afile[j], ::aautoplay[j], ::acenter[j], ::atransparent[j], ::aHelpID[j], ::atooltip[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aNoTabStop[j], ::aSubClass[j] }
      aFormats    := { 30,         30,         .F.,            .F.,          .F.,               '999',        120,           .F.,           .F.,           31,         .F.,       .F.,             250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aFile[j]             := aResults[02]
      ::aAutoPlay[j]         := aResults[03]
      ::aCenter[j]           := aResults[04]
      ::aTransparent[j]      := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::aToolTip[j]          := aResults[07]
      ::aEnabled[j]          := aResults[08]
      ::aVisible[j]          := aResults[09]
      ::aCObj[j]             := aResults[10]
      ::aRTL[j]              := aResults[11]
      ::aNoTabStop[j]        := aResults[12]
      ::aSubClass[j]         := aResults[13]
   ENDIF

   IF ::aCtrlType[j] == 'PLAYER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'File',     'HelpID',     'Enabled',     'Visible',     'Obj',      'NoTabStop',     'RTL',     'NoAutoSizeWindow',     'NoAutoSizeMovie',     'NoErrorDlg',     'NoMenu',     'NoOpen',     'NoPlayBar',     'ShowAll',     'ShowMode',     'ShowName',     'ShowPosition',     'SubClass' }
      aInitValues := { ::aName[j], ::afile[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aNoTabStop[j], ::aRTL[j], ::aNoAutoSizeWindow[j], ::aNoAutoSizeMovie[j], ::aNoErrorDlg[j], ::aNoMenu[j], ::aNoOpen[j], ::aNoPlayBar[j], ::aShowAll[j], ::aShowMode[j], ::aShowName[j], ::aShowPosition[j], ::aSubClass[j] }
      aFormats    := { 30,         30,         '999',        .F.,           .F.,           31,         .F.,             .F.,       .F.,                    .F.,                   .F.,              .F.,          .F.,          .F.,             .F.,           .F.,            .F.,            .F.,                250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aFile[j]             := aResults[02]
      ::aHelpID[j]           := aResults[03]
      ::aEnabled[j]          := aResults[04]
      ::aVisible[j]          := aResults[05]
      ::aCObj[j]             := aResults[06]
      ::aNoTabStop[j]        := aResults[07]
      ::aRTL[j]              := aResults[08]
      ::aNoAutoSizeWindow[j] := aResults[09]
      ::aNoAutoSizeMovie[j]  := aResults[10]
      ::aNoErrorDlg[j]       := aResults[11]
      ::aNoMenu[j]           := aResults[12]
      ::aNoOpen[j]           := aResults[13]
      ::aNoPlayBar[j]        := aResults[14]
      ::aShowAll[j]          := aResults[15]
      ::aShowMode[j]         := aResults[16]
      ::aShowName[j]         := aResults[17]
      ::aShowPosition[j]     := aResults[18]
      ::aSubClass[j]         := aResults[19]
   ENDIF

   IF ::aCtrlType[j] == 'DATEPICKER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',     'ToolTip',     'ShowNone',     'UpDown',     'RightAlign',     'HelpID',     'Field',     'Visible',     'Enabled',     'Obj',      'RTL',     'NoTabStop',     'Range',     'NoBorder',   'SubClass' }
      aInitValues := { ::aName[j], ::aValue[j], ::atooltip[j], ::ashownone[j], ::aupdown[j], ::arightalign[j], ::aHelpID[j], ::afield[j], ::avisible[j], ::aenabled[j], ::acobj[j], ::aRTL[j], ::aNoTabStop[j], ::aRange[j], ::aBorder[j], ::aSubClass[j] }
      aFormats    := { 30,         20,          120,           .F.,            .F.,          .F.,              '999',        250,         .T.,           .T.,           31,         .F.,       .F.,             250,         .F.,          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValue[j]            := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aShowNone[j]         := aResults[04]
      ::aUpDown[j]           := aResults[05]
      ::aRightAlign[j]       := aResults[06]
      ::aHelpID[j]           := aResults[07]
      ::aField[j]            := aResults[08]
      ::aVisible[j]          := aResults[09]
      ::aEnabled[j]          := aResults[10]
      ::aCObj[j]             := aResults[11]
      ::aRTL[j]              := aResults[12]
      ::aNoTabStop[j]        := aResults[13]
      ::aRange[j]            := aResults[14]
      ::aBorder[j]           := aResults[15]
      ::aSubClass[j]         := aResults[16]
   ENDIF

   IF ::aCtrlType[j] == 'TIMEPICKER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',     'ToolTip',     'ShowNone',     'UpDown',     'RightAlign',     'HelpID',     'Field',     'Visible',     'Enabled',     'Obj',      'RTL',     'NoTabStop',     'NoBorder',   'SubClass' }
      aInitValues := { ::aName[j], ::aValue[j], ::atooltip[j], ::ashownone[j], ::aupdown[j], ::arightalign[j], ::aHelpID[j], ::afield[j], ::avisible[j], ::aenabled[j], ::acobj[j], ::aRTL[j], ::aNoTabStop[j], ::aBorder[j], ::aSubClass[j] }
      aFormats    := { 30,         20,          120,           .F.,            .F.,          .F.,              '999',        250,         .T.,           .T.,           31,         .F.,       .F.,             .F.,          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValue[j]            := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aShowNone[j]         := aResults[04]
      ::aUpDown[j]           := aResults[05]
      ::aRightAlign[j]       := aResults[06]
      ::aHelpID[j]           := aResults[07]
      ::aField[j]            := aResults[08]
      ::aVisible[j]          := aResults[09]
      ::aEnabled[j]          := aResults[10]
      ::aCObj[j]             := aResults[11]
      ::aRTL[j]              := aResults[12]
      ::aNoTabStop[j]        := aResults[13]
      ::aBorder[j]           := aResults[14]           // NOBORDER
      ::aSubClass[j]         := aResults[15]
   ENDIF

   IF ::aCtrlType[j] == 'MONTHCALENDAR'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',     'ToolTip',     'NoToday',     'NoTodayCircle',     'WeekNumbers',     'HelpID',     'Visible',     'Enabled',     'Obj',      'NoTabStop',     'RTL',     'SubClass' }
      aInitValues := { ::aName[j], ::aValue[j], ::atooltip[j], ::anotoday[j], ::anotodaycircle[j], ::aweeknumbers[j], ::aHelpID[j], ::avisible[j], ::aenabled[j], ::acobj[j], ::aNoTabStop[j], ::aRTL[j], ::aSubClass[j] }
      aFormats    := { 30,         30,          120,           .F.,           .F.,                 .F.,               '999',        .T.,           .T.,           31,         .F.,             .F.,       250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValue[j]            := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aNoToday[j]          := aResults[04]
      ::aNoTodayCircle[j]    := aResults[05]
      ::aWeekNumbers[j]      := aResults[06]
      ::aHelpID[j]           := aResults[07]
      ::aVisible[j]          := aResults[08]
      ::aEnabled[j]          := aResults[09]
      ::aCObj[j]             := aResults[10]
      ::aNoTabStop[j]        := aResults[11]
      ::aRTL[j]              := aResults[12]
      ::aSubClass[j]         := aResults[13]
   ENDIF

   IF ::aCtrlType[j] == 'ACTIVEX'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'ProgID',     'Visible',     'Enabled',     'Obj',      'NoTabStop',     'SubClass' }
      aInitValues := { ::aName[j], ::aAction[j], ::avisible[j], ::aenabled[j], ::acobj[j], ::aNoTabStop[j], ::aSubClass[j] }
      aFormats    := { 30,         250,          .T.,           .T.,           31,         .F.,             250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aAction[j]           := aResults[02]           // PROGID
      ::aVisible[j]          := aResults[03]
      ::aEnabled[j]          := aResults[04]
      ::aCObj[j]             := aResults[05]
      ::aNoTabStop[j]        := aResults[06]
      ::aSubClass[j]         := aResults[07]
   ENDIF

   IF ::aCtrlType[j] == 'CHECKLIST'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Items',     'Value',      'ToolTip',     'Image',     'HelpID',     'Break',     'Justify',     'Enabled',     'Visible',     'Obj',      'SelectedColor', 'DoubleBuffer',     'SingleBuffer',     'SubClass',     'RTL',     'NoTabStop',     'Sort',     'Descending' }
      aInitValues := { ::aName[j], ::aItems[j], ::aValueN[j], ::aToolTip[j], ::aImage[j], ::aHelpID[j], ::aBreak[j], ::aJustify[j], ::aEnabled[j], ::aVisible[j], ::aCObj[j], ::aSelColor[j],  ::aDoubleBuffer[j], ::aSingleBuffer[j], ::aSubClass[j], ::aRTL[j], ::aNoTabStop[j], ::aSort[j], ::aDescend[j] }
      aFormats    := { 30,         800,         "999999",     250,           60,          '999',        .F.,         350,           .F.,           .F.,           31,         250,             .F.,                .F.,                250,            .F.,       .F.,             .F.,        .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aItems[j]            := aResults[02]
      ::aValueN[j]           := aResults[03]
      ::aToolTip[j]          := aResults[04]
      ::aImage[j]            := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::aBreak[j]            := aResults[07]
      ::aJustify[j]          := IIF( Empty( aResults[08] ), ::aJustify[j], aResults[08] )
      ::aEnabled[j]          := aResults[09]
      ::aVisible[j]          := aResults[10]
      ::aCObj[j]             := aResults[11]
      ::aSelColor[j]         := aResults[12]
      ::aDoubleBuffer[j]     := aResults[13]
      ::aSingleBuffer[j]     := aResults[14]
      ::aSubClass[j]         := aResults[15]
      ::aRTL[j]              := aResults[16]
      ::aNoTabStop[j]        := aResults[17]
      ::aSort[j]             := aResults[18]
      ::aDescend[j]          := aResults[19]
   ENDIF

   IF ::aCtrlType[j] == 'HOTKEYBOX'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',     'ToolTip',     'HelpID',     'Enabled',     'Visible',     'Obj',      'SubClass',     'RTL',     'NoTabStop',     'NoALT' }
      aInitValues := { ::aName[j], ::aValue[j], ::aToolTip[j], ::aHelpID[j], ::aEnabled[j], ::aVisible[j], ::aCObj[j], ::aSubClass[j], ::aRTL[j], ::aNoTabStop[j], ::aNoPrefix[j] }
      aFormats    := { 30,         250,         250,           '999',        .F.,           .F.,           31,         250,            .F.,       .F.,             .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValue[j]            := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::aEnabled[j]          := aResults[05]
      ::aVisible[j]          := aResults[06]
      ::aCObj[j]             := aResults[07]
      ::aSubClass[j]         := aResults[08]
      ::aRTL[j]              := aResults[09]
      ::aNoTabStop[j]        := aResults[10]
      ::aNoPrefix[j]         := aResults[11]           // NOALT
   ENDIF

   IF ::aCtrlType[j] == 'PICTURE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Picture',     'ToolTip',     'HelpID',     'Stretch',     'Enabled',     'Visible',     'Obj',      "ClientEdge",     "Border",     'Transparent',     'SubClass',     'RTL',     'Buffer',     'HBitmap',     'DIBSection',     'No3DColors',     'NoLoadTransparent', 'ForceScale',     'ImageSize',     'ExcludeArea' }
      aInitValues := { ::aName[j], ::aPicture[j], ::aToolTip[j], ::aHelpID[j], ::aStretch[j], ::aEnabled[j], ::aVisible[j], ::aCObj[j], ::aClientEdge[j], ::aBorder[j], ::aTransparent[j], ::aSubClass[j], ::aRTL[j], ::aBuffer[j], ::aHBitmap[j], ::aDIBSection[j], ::aNo3DColors[j], ::aNoLoadTrans[j],   ::aForceScale[j], ::aImageSize[j], ::aExclude[j] }
      aFormats    := { 30,         30,            120,           '999',        .F.,           .F.,           .F.,           31,         .F.,              .F.,          .F.,               250,            .F.,       250,          250,           .F.,              .F.,              .F.,                 .F.,              .F.,             250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aPicture[j]          := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::aStretch[j]          := aResults[05]
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aCObj[j]             := aResults[08]
      ::aClientEdge[j]       := aResults[09]
      ::aBorder[j]           := aResults[10]
      ::aTransparent[j]      := aResults[11]
      ::aSubClass[j]         := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aBuffer[j]           := aResults[14]
      ::aHBitmap[j]          := aResults[15]
      ::aDIBSection[j]       := aResults[16]
      ::aNo3DColors[j]       := aResults[17]
      ::aNoLoadTrans[j]      := aResults[18]
      ::aForceScale[j]       := aResults[19]
      ::aImageSize[j]        := aResults[20]
      ::aExclude[j]          := aResults[21]
   ENDIF

   IF ::aCtrlType[j] == 'PROGRESSMETER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Range',     'Value',      'ToolTip',     'HelpID',     'Enabled',     'Visible',     'Obj',      'SubClass',     'RTL',     'ClientEdge' }
      aInitValues := { ::aName[j], ::aRange[j], ::aValueN[j], ::aToolTip[j], ::aHelpID[j], ::aEnabled[j], ::aVisible[j], ::aCObj[j], ::aSubClass[j], ::aRTL[j], ::aClientEdge[j] }
      aFormats    := { 30,         20,          "999999",     250,           '999',        .F.,           .F.,           31,         250,            .F.,       .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aRange[j]            := aResults[02]
      ::aValueN[j]           := aResults[03]
      ::aToolTip[j]          := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aCObj[j]             := aResults[08]
      ::aSubClass[j]         := aResults[09]
      ::aRTL[j]              := aResults[10]
      ::aClientEdge[j]       := aResults[11]
   ENDIF

   IF ::aCtrlType[j] == 'SCROLLBAR'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Range',     'Value',      'ToolTip',     'HelpID',     'Enabled',     'Visible',     'Obj',      'SubClass',     'RTL',     'Horizontal', 'Vertical',     'AutoMove',     'Attached',   'LineSkip',      'PageSkip' }
      aInitValues := { ::aName[j], ::aRange[j], ::aValueN[j], ::aToolTip[j], ::aHelpID[j], ::aEnabled[j], ::aVisible[j], ::aCObj[j], ::aSubClass[j], ::aRTL[j], ::aFlat[j],   ::aVertical[j], ::aAutoPlay[j], ::aAppend[j], ::aIncrement[j], ::aIndent[j] }
      aFormats    := { 30,         20,          "999999",     250,           '999',        .F.,           .F.,           31,         250,            .F.,       .F.,           .F.,            .F.,            .F.,          '999999',        '999999' }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aRange[j]            := aResults[02]
      ::aValueN[j]           := aResults[03]
      ::aToolTip[j]          := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aCObj[j]             := aResults[08]
      ::aSubClass[j]         := aResults[09]
      ::aRTL[j]              := aResults[10]
      ::aFlat[j]             := aResults[11]           // HORIZONTAL
      ::aVertical[j]         := aResults[12]           // AUTOMOVE
      ::aAutoPlay[j]         := aResults[13]
      ::aAppend[j]           := aResults[14]           // ATTACHED
      ::aIncrement[j]        := aResults[15]           // LINESKIP
      ::aIndent[j]           := aResults[16]           // PAGESKIP
   ENDIF

   IF ::aCtrlType[j] == 'TEXTARRAY'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Name',     'Value',     'ToolTip',     'HelpID',     'Enabled',     'Visible',     'Obj',      'SubClass',     'RTL',     'NoTabStop',     'ClientEdge',     'Border',     'RowCount',      'ColCount' }
      aInitValues := { ::aName[j], ::aValue[j], ::aToolTip[j], ::aHelpID[j], ::aEnabled[j], ::aVisible[j], ::aCObj[j], ::aSubClass[j], ::aRTL[j], ::aNoTabStop[j], ::aClientEdge[j], ::aBorder[j], ::aItemCount[j], ::aIncrement[j] }
      aFormats    := { 30,         250,         250,           '999',        .F.,           .F.,           31,         250,            .F.,       .F.,             .F.,              .F.,          '999999',        '999999' }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aName[j]             := IIF( ! ::IsUnique( aResults[01], j ), ::aName[j], AllTrim( aResults[01] ) )
      ::aValue[j]            := aResults[02]
      ::aToolTip[j]          := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::aEnabled[j]          := aResults[05]
      ::aVisible[j]          := aResults[06]
      ::aCObj[j]             := aResults[07]
      ::aSubClass[j]         := aResults[08]
      ::aRTL[j]              := aResults[09]
      ::aNoTabStop[j]        := aResults[10]
      ::aClientEdge[j]       := aResults[11]
      ::aBorder[j]           := aResults[12]
      ::aItemCount[j]        := aResults[13]           // ROWCOUNT
      ::aIncrement[j]        := aResults[14]           // COLCOUNT
   ENDIF

   ::lFsave := .F.
   oControl := ::RecreateControl( oControl, j )
   ::DrawOutline( oControl )
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD RecreateControl( oControl, j ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nRow, nCol, nStyle, nWidth, nHeight, i, aCtrls, cTab, oTab

   nRow := oControl:Row
   nCol := oControl:Col

   IF ::aCtrlType[j] == 'SLIDER'
      nStyle := WindowStyleFlag( oControl:hWnd,  TBS_VERT )
      IF ( nStyle == TBS_HORZ .AND. ::aVertical[j] ) .OR. ( nStyle == TBS_VERT .AND. ! ::aVertical[j] )
         nWidth  := oControl:Height
         nHeight := oControl:Width
      ELSE
         nWidth  := oControl:Width
         nHeight := oControl:Height
      ENDIF
   ELSEIF ::aCtrlType[j] == 'PROGRESSBAR'
      nStyle := WindowStyleFlag( oControl:hWnd,  PBS_VERTICAL )
      IF ( nStyle # PBS_VERTICAL .AND. ::aVertical[j] ) .OR. ( nStyle == PBS_VERTICAL .AND. ! ::aVertical[j] )
         nWidth  := oControl:Height
         nHeight := oControl:Width
      ELSE
         nWidth  := oControl:Width
         nHeight := oControl:Height
      ENDIF
   ELSEIF ::aCtrlType[j] == 'TAB'
      aCtrls := Array( oControl:ItemCount )
      FOR i := 1 TO Len( aCtrls )
         aCtrls[i] := aClone( oControl:aPages[i]:aControls )
         aEval( aCtrls[i], { |c| oControl:aPages[i]:DeleteControl( c ) } )
      NEXT i
      nWidth  := oControl:Width
      nHeight := oControl:Height
   ELSE
      nWidth  := oControl:Width
      nHeight := oControl:Height
   ENDIF

   oControl:Release()

   oControl     := ::CreateControl( aScan( ::ControlType, ::aCtrlType[j] ), j, nWidth, nHeight, aCtrls )
   oControl:Row := nRow
   oControl:Col := nCol

   IF ::aTabPage[j, 1] # '' .AND. ::aTabPage[j, 2] > 0
      IF ( i := aScan( ::aName, { |c| Lower( c ) == ::aTabPage[j, 1] } ) ) > 0
         cTab := ::aControlW[i]
         IF ( i := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == cTab } ) ) > 0
            oTab := ::oDesignForm:aControls[i]
            oTab:AddControl( oControl:Name, ::aTabPage[j, 2], oControl:Row, oControl:Col )
         ELSE
            ::aTabPage[j, 1] := ''
            ::aTabPage[j, 2] := 0
         ENDIF
      ELSE
         ::aTabPage[j, 1] := ''
         ::aTabPage[j, 2] := 0
      ENDIF
   ENDIF
RETURN oControl

//------------------------------------------------------------------------------
METHOD TabProperties( i, oTab ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, oTabProp

   cName := _OOHG_GetNullName( "0" )
   SET INTERACTIVECLOSE ON
   LOAD WINDOW tabprop AS ( cName )
   ON KEY ESCAPE OF ( oTabProp:Name ) ACTION oTabProp:Release()
   oTabProp:Title          := ::aName[i] + ' properties '
   oTabProp:Text_1:Value   := ::aValue[i]
   oTabProp:Text_2:Value   := ::aName[i]
   oTabProp:Edit_3:Value   := ::aToolTip[i]
   oTabProp:Text_3:Value   := ::aCObj[i]
   oTabProp:Text_4:Value   := ::aSubClass[i]
   oTabProp:Check_2:Value  := ::aButtons[i]
   oTabProp:Check_5:Value  := ::aEnabled[i]
   oTabProp:Check_1:Value  := ::aFlat[i]
   oTabProp:Check_6:Value  := ::aVisible[i]
   oTabProp:Check_3:Value  := ::aHotTrack[i]
   oTabProp:Check_7:Value  := ::aRTL[i]
   oTabProp:Check_4:Value  := ::aVertical[i]
   oTabProp:Check_8:Value  := ::aNoTabStop[i]
   oTabProp:Check_9:Value  := ::aMultiLine[i]
   oTabProp:Check_10:Value := ::aVirtual[i]
   oTabProp:Text_101:Value := ::aCaption[i]
   oTabProp:Edit_2:Value   := ::aImage[i]
   oTabProp:Edit_4:Value   := ::aPageNames[i]
   oTabProp:Edit_5:Value   := ::aPageObjs[i]
   oTabProp:Edit_6:Value   := ::aPageSubClasses[i]
   CENTER WINDOW ( cName )
   ACTIVATE WINDOW ( cName )
   SET INTERACTIVECLOSE OFF
RETURN NIL

//------------------------------------------------------------------------------
METHOD AddTabPage( i, oTab, oTabProp ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nPages

   nPages := oTab:ItemCount

   ::aCaption[i]        := SubStr( ::aCaption[i], 1, Len( ::aCaption[i] ) - 2 ) + ", 'Page " + AllTrim( Str( nPages + 1 ) ) + "' }"
   ::aImage[i]          := SubStr( ::aImage[i], 1, Len( ::aImage[i] ) - 2 ) + ", '' }"
   ::aPageNames[i]      := SubStr( ::aPageNames[i], 1, Len( ::aPageNames[i] ) - 2 ) + ", '' }"
   ::aPageObjs[i]       := SubStr( ::aPageObjs[i], 1, Len( ::aPageObjs[i] ) - 2 ) + ", '' }"
   ::aPageSubClasses[i] := SubStr( ::aPageSubClasses[i], 1, Len( ::aPageSubClasses[i] ) - 2 ) + ", '' }"

   oTabProp:Text_101:Value := ::aCaption[i]
   oTabProp:Edit_2:Value   := ::aImage[i]
   oTabProp:Edit_4:Value   := ::aPageNames[i]
   oTabProp:Edit_5:Value   := ::aPageObjs[i]
   oTabProp:Edit_6:Value   := ::aPageSubClasses[i]

   oTab:Addpage( nPages + 1, 'Page ' + AllTrim( Str( nPages + 1 ) ) )
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD DeleteTabPage( i, oTab, oTabProp ) CLASS TFormEditor
*-----------------------------------------------------------------------------*
LOCAL nPages, cName, j

   nPages := oTab:ItemCount
   IF nPages <= 1
      RETURN NIL
   ENDIF

   ::aCaption[i]        := SubStr( ::aCaption[i], 1, Rat( ", ", ::aCaption[i] ) - 1 ) + " }"
   ::aImage[i]          := SubStr( ::aImage[i], 1, Rat( ", ", ::aImage[i] ) - 1 ) + " }"
   ::aPageNames[i]      := SubStr( ::aPageNames[i], 1, Rat( ", ", ::aPageNames[i] ) - 1 ) + " }"
   ::aPageObjs[i]       := SubStr( ::aPageObjs[i], 1, Rat( ", ", ::aPageObjs[i] ) - 1 ) + " }"
   ::aPageSubClasses[i] := SubStr( ::aPageSubClasses[i], 1, Rat( ", ", ::aPageSubClasses[i] ) - 1 ) + " }"

   oTabProp:Text_101:Value := ::aCaption[i]
   oTabProp:Edit_2:Value   := ::aImage[i]
   oTabProp:Edit_4:Value   := ::aPageNames[i]
   oTabProp:Edit_5:Value   := ::aPageObjs[i]
   oTabProp:Edit_6:Value   := ::aPageSubClasses[i]

   cName := ::aControlW[i]
   FOR j := ::nControlW TO 1 STEP -1
      IF ::aTabPage[j, 1] == cName .and. ::aTabPage[j, 2] == nPages
         ::DelArray( j )
       ENDIF
   NEXT j

   oTab:DeletePage( nPages )
   oTab:Visible := .F.
   oTab:Visible := .T.
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION ChgTabpageCaption( oTab, oTabProp )
//------------------------------------------------------------------------------
LOCAL i, aCaptions

   IF IsValidArray( oTabProp:text_101:Value )
      aCaptions := &( oTabProp:text_101:Value )
      FOR i := 1 TO Len( aCaptions )
         IF HB_IsString( aCaptions[i] )
            oTab:Caption( i, aCaptions[i] )
         ELSE
            MsgStop( "Caption for Page" + LTrim( Str( i ) ) + " must be a valid string !!!", 'ooHG IDE+' )
            RETURN .F.
         ENDIF
      NEXT i
      RETURN .T.
   ENDIF
   MsgStop( "Pages' Caption must be a valid array of strings !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
STATIC FUNCTION ChgTabpageImage( oTab, oTabProp )
//------------------------------------------------------------------------------
LOCAL i, aImages

   IF IsValidArray( oTabProp:Edit_2:Value )
      aImages := &( oTabProp:Edit_2:Value )
      FOR i := 1 TO Len( aImages )
         IF HB_IsString( aImages[i] )
            oTab:Picture( i, aImages[i] )
         ELSE
            MsgStop( "Image for Page" + LTrim( Str( i ) ) + " must be a valid string !!!", 'ooHG IDE+' )
            RETURN .F.
         ENDIF
      NEXT i
      RETURN .T.
   ENDIF
   MsgStop( "Pages' Image must be a valid array of strings !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
STATIC FUNCTION ChgTabpageName( oTabProp )
//------------------------------------------------------------------------------
LOCAL i, aNames

   IF IsValidArray( oTabProp:Edit_4:Value )
      aNames := &( oTabProp:Edit_4:Value )
      FOR i := 1 TO Len( aNames )
         IF ! HB_IsString( aNames[i] )
            MsgStop( "Name for Page" + LTrim( Str( i ) ) + " must be a valid string !!!", 'ooHG IDE+' )
            RETURN .F.
         ENDIF
      NEXT i
      RETURN .T.
   ENDIF
   MsgStop( "Pages' Name must be a valid array of strings !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
STATIC FUNCTION ChgTabpageObject( oTabProp )
//------------------------------------------------------------------------------
LOCAL i, aObjs

   IF IsValidArray( oTabProp:Edit_5:Value )
      aObjs := &( oTabProp:Edit_4:Value )
      FOR i := 1 TO Len( aObjs )
         IF ! HB_IsString( aObjs[i] )
            MsgStop( "Obj for Page" + LTrim( Str( i ) ) + " must be a valid string !!!", 'ooHG IDE+' )
            RETURN .F.
         ENDIF
      NEXT i
      RETURN .T.
   ENDIF
   MsgStop( "Pages' Obj must be a valid array of strings !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
STATIC FUNCTION ChgTabpageSubclass( oTabProp )
//------------------------------------------------------------------------------
LOCAL i, aSubs

   IF IsValidArray( oTabProp:Edit_6:Value )
      aSubs := &( oTabProp:Edit_4:Value )
      FOR i := 1 TO Len( aSubs )
         IF ! HB_IsString( aSubs[i] )
            MsgStop( "Subclass for Page" + LTrim( Str( i ) ) + " must be a valid string !!!", 'ooHG IDE+' )
            RETURN .F.
         ENDIF
      NEXT i
      RETURN .T.
   ENDIF
   MsgStop( "Pages' Subclass must be a valid array of strings!!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
STATIC FUNCTION IsValidArray( cArray )
//------------------------------------------------------------------------------
LOCAL nOpen, nClose, i

   nOpen := nClose := 0
   cArray := AllTrim( cArray )
   FOR i := 1 TO Len( cArray )
      IF SubStr( cArray, i, 1 ) == '{'
         nOpen ++
      ELSEIF SubStr( cArray, i, 1 ) == '}'
         nClose ++
      ENDIF
   NEXT i
   IF nOpen #1 .OR. nClose # 1
      RETURN .F.
   ENDIF
RETURN Type( cArray ) == "A"

//------------------------------------------------------------------------------
METHOD Events_Click() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, cName, j, cNameW, cTitle, aLabels, aInitValues, aFormats
LOCAL ia, aResults

   ia := ::nHandleA
   IF ia <= 0
      RETURN NIL
   ENDIF

   oControl := ::oDesignForm:aControls[ia]
   cName := Lower( oControl:Name )
   j := aScan( ::aControlW, cName )
   IF j <= 0
      RETURN NIL
   ENDIF

   cNameW := ::aName[j]

   IF ::aCtrlType[j] == 'TAB'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change' }
      aInitValues := { ::aOnChange[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aOnChange[j]        := aResults[1]
   ENDIF

   IF ::aCtrlType[j] == 'TEXT'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Enter',    'On Change',    'On GotFocus',    'On LostFocus',    'On TextFilled' }
      aInitValues := { ::aonenter[j], ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnTextFilled[j] }
      aFormats    := { 250,           250,            250,              250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonenter[j]         := aResults[1]
      ::aonchange[j]        := aResults[2]
      ::aongotfocus[j]      := aResults[3]
      ::aonlostfocus[j]     := aResults[4]
      ::aOnTextFilled[j]    := aResults[5]
   ENDIF

   IF ::aCtrlType[j] == 'BUTTON'
      cTitle      := cNameW + " events"
      aLabels     := { 'On GotFocus',    'On LostFocus',    'Action',     'On MouseMove' }
      aInitValues := { ::aongotfocus[j], ::aonlostfocus[j], ::aaction[j], ::aOnMouseMove[j] }
      aFormats    := { 250,              250,               250,          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aongotfocus[j]      := aResults[1]
      ::aonlostfocus[j]     := aResults[2]
      ::aaction[j]          := aResults[3]
      ::aOnMouseMove[j]     := aResults[4]
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBOX'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j] }
      aFormats    := { 250,           250,              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
   ENDIF

   IF ::aCtrlType[j] == 'IPADDRESS'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',  'On GotFocus',  'On LostFocus' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j]}
      aFormats    := { 250,           250,              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
   ENDIF

   IF ::aCtrlType[j] == 'GRID'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On Enter',    'On Headclcik',    "On EditCell",    "On QueryData",    "On AborEdit",    "On Delete",    "On HeadRClick" }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aondblclick[j], ::aOnEnter[j], ::aonheadclick[j], ::aoneditcell[j], ::aOnQueryData[j], ::aOnAborEdit[j], ::aOnDelete[j], ::aOnHeadRClick[j] }
      aFormats    := { 250,            250,              250,               250,              250,           250,               250,              250,               250,              250,            250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
      ::aondblclick[j]      := aResults[4]
      ::aonenter[j]         := aResults[5]
      ::aonheadclick[j]     := aResults[6]
      ::aoneditcell[j]      := aResults[7]
      ::aOnQueryData[j]     := aResults[8]
      ::aOnAbortEdit[j]     := aResults[9]
      ::aOnDelete[j]        := aResults[10]
      ::aOnHeadRClick[j]    := aResults[11]
   ENDIF

   IF ::aCtrlType[j] == 'TREE'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On Enter',    'On LabelEdit',    'On CheckChange',  'On Drop' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aondblclick[j], ::aOnEnter[j], ::aOnLabelEdit[j], ::aOnCheckChg[j],   ::aOnDrop[j] }
      aFormats    := { 250,            250,              250,               250,              250,           250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[01]
      ::aongotfocus[j]      := aResults[02]
      ::aonlostfocus[j]     := aResults[03]
      ::aondblclick[j]      := aResults[04]
      ::aOnEnter[j]         := aResults[05]
      ::aOnLabelEdit[j]     := aResults[06]
      ::aOnCheckChg[j]      := aResults[07]
      ::aOnDrop[j]          := aResults[08]
   ENDIF

   IF ::aCtrlType[j] == 'BROWSE'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On HeadClick',    'On EditCell',    'On Append',    'On Enter',    'Action',     'On AbortEdit',    'On Delete',    'On HeadRClick' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aondblclick[j], ::aonheadclick[j], ::aoneditcell[j], ::aonappend[j], ::aonenter[j], ::aAction[j], ::aOnAbortEdit[j], ::aOnDelete[j], ::aOnHeadRClick[j] }
      aFormats    := { 250,            250,              250,               250,              250,               250,              250,            250,           250,          250,               250,            250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[01]
      ::aongotfocus[j]      := aResults[02]
      ::aonlostfocus[j]     := aResults[03]
      ::aondblclick[j]      := aResults[04]
      ::aonheadclick[j]     := aResults[05]
      ::aoneditcell[j]      := aResults[06]
      ::aonappend[j]        := aResults[07]
      ::aonenter[j]         := aResults[08]
      ::aAction[j]          := aResults[09]
      ::aOnAbortEdit[j]     := aResults[10]
      ::aOnDelete[j]        := aResults[11]
      ::aOnHeadRClick[j]    := aResults[12]
   ENDIF

   IF ::aCtrlType[j] == 'XBROWSE'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On HeadClick',    'On EditCell',    'On Append',    'On Enter',    'Action',     'On AbortEdit',    'On Delete',    'On HeadRClick' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aondblclick[j], ::aonheadclick[j], ::aoneditcell[j], ::aonappend[j], ::aonenter[j], ::aAction[j], ::aOnAbortEdit[j], ::aOnDelete[j], ::aOnHeadRClick[j] }
      aFormats    := { 250,            250,              250,               250,              250,               250,              250,            250,           250,          250,               250,            250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[01]
      ::aongotfocus[j]      := aResults[02]
      ::aonlostfocus[j]     := aResults[03]
      ::aondblclick[j]      := aResults[04]
      ::aonheadclick[j]     := aResults[05]
      ::aoneditcell[j]      := aResults[06]
      ::aonappend[j]        := aResults[07]
      ::aonenter[j]         := aResults[08]
      ::aAction[j]          := aResults[09]
      ::aOnAbortEdit[j]     := aResults[10]
      ::aOnDelete[j]        := aResults[11]
      ::aOnHeadRClick[j]    := aResults[12]
   ENDIF

   IF ::aCtrlType[j] == 'SPINNER'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j] }
      aFormats    := { 250,            250,              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
   ENDIF

   IF ::aCtrlType[j] == 'LIST'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On Enter' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOndblclick[j], ::aOnEnter[j] }
      aFormats    := { 250,            250,              250,               250,              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
      ::aondblclick[j]      := aResults[4]
   ENDIF

   IF ::aCtrlType[j] == 'COMBO'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On Enter',    'On DisplayChange',    'On ListDisplay',    'On ListClose',    'On Refresh' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aonenter[j], ::aondisplaychange[j], ::aOnListDisplay[j], ::aOnListClose[j], ::aOnRefresh[j] }
      aFormats    := { 250,            250,              250,               250,           250,                   250,                 250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
      ::aonenter[j]         := aResults[4]
      ::aondisplaychange[j] := aResults[5]
      ::aOnListDisplay[j]   := aResults[6]
      ::aOnListClose[j]     := aResults[7]
      ::aOnRefresh[j]       := aResults[8]
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBTN'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On MouseMove' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnMouseMove[j] }
      aFormats    := { 250,            250,              250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aOnChange[j]        := aResults[01]
      ::aOnGotFocus[j]      := aResults[02]
      ::aOnLostFocus[j]     := aResults[03]
      ::aOnMouseMove[j]     := aResults[04]
   ENDIF

   IF ::aCtrlType[j] == 'PICCHECKBUTT'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On MouseMove' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnMouseMove[j] }
      aFormats    := { 250,            250,              250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aOnChange[j]        := aResults[01]
      ::aOnGotFocus[j]      := aResults[02]
      ::aOnLostFocus[j]     := aResults[03]
      ::aOnMouseMove[j]     := aResults[04]
   ENDIF

   IF ::aCtrlType[j] == 'PICBUTT'
      cTitle      := cNameW + " events"
      aLabels     := { 'On GotFocus',    'On LostFocus',    'Action',     'On MouseMove'}
      aInitValues := { ::aongotfocus[j], ::aonlostfocus[j], ::aaction[j], ::aOnMouseMove[j] }
      aFormats    := { 250,              250,               250,          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aongotfocus[j]      := aResults[01]
      ::aonlostfocus[j]     := aResults[02]
      ::aaction[j]          := aResults[03]
      ::aOnMouseMove[j]     := aResults[04]
   ENDIF

   IF ::aCtrlType[j] == 'IMAGE'
      cTitle      := cNameW + " events"
      aLabels     := { 'Action' }
      aInitValues := { ::aaction[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aaction[j]          := aResults[1]
   ENDIF

   IF ::aCtrlType[j] == 'MONTHCALENDAR'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change' }
      aInitValues := { ::aonchange[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
   ENDIF

   IF ::aCtrlType[j] == 'TIMER'
      cTitle      := cNameW + " events"
      aLabels     := { 'Action' }
      aInitValues := { ::aaction[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aaction[j]         := aResults[1]
   ENDIF

   IF ::aCtrlType[j] == 'LABEL'
      cTitle      := cNameW + " events"
      aLabels     := { 'Action' }
      aInitValues := { ::aaction[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aaction[j]          := aResults[1]
   ENDIF

   IF ::aCtrlType[j] == 'RADIOGROUP'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change' }
      aInitValues := { ::aonchange[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
   ENDIF

   IF ::aCtrlType[j] == 'SLIDER'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change' }
      aInitValues := { ::aonchange[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
   ENDIF

   IF ::aCtrlType[j] == 'DATEPICKER'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On Enter'  }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aonenter[j] }
      aFormats    := { 250,            250,              250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
      ::aonenter[j]         := aResults[4]
   ENDIF

   IF ::aCtrlType[j] == 'TIMEPICKER'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On Enter'  }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aonenter[j] }
      aFormats    := { 250,            250,              250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
      ::aonenter[j]         := aResults[4]
   ENDIF

   IF ::aCtrlType[j] == 'EDIT'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On HScroll',    'On VScroll' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnHScroll[j], ::aOnVScroll[j] }
      aFormats    := { 250,            250,              250,               250,              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aonchange[j]        := aResults[1]
      ::aongotfocus[j]      := aResults[2]
      ::aonlostfocus[j]     := aResults[3]
   ENDIF

   IF ::aCtrlType[j] == 'RICHEDIT'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On SelChange',    'On HScroll',    'On VScroll' }
      aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnSelChange[j], ::aOnHScroll[j], ::aOnVScroll[j] }
      aFormats    := { 250,            250,              250,               250,               250,              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aOnChange[j]        := aResults[01]
      ::aOnGotFocus[j]      := aResults[02]
      ::aOnLostFocus[j]     := aResults[03]
      ::aOnSelChange[j]     := aResults[04]
      ::aOnHScroll[j]       := aResults[05]
      ::aOnVScroll[j]       := aResults[06]
   ENDIF

   IF ::aCtrlType[j] == 'ACTIVEX'
      // Control has no events
   ENDIF

   IF ::aCtrlType[j] == 'CHECKLIST'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'Action' }
      aInitValues := { ::aOnChange[j], ::aOnGotFocus[j], ::aOnLostFocus[j], ::aAction[j] }
      aFormats    := { 250,            250,              250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aOnChange[j]        := aResults[01]
      ::aOnGotFocus[j]      := aResults[02]
      ::aOnLostFocus[j]     := aResults[03]
      ::aAction[j]          := aResults[04]
   ENDIF

   IF ::aCtrlType[j] == 'HOTKEYBOX'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On Enter' }
      aInitValues := { ::aOnChange[j], ::aOnGotFocus[j], ::aOnLostFocus[j], ::aOnEnter[j] }
      aFormats    := { 250,            250,              250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aOnChange[j]        := aResults[01]
      ::aOnGotFocus[j]      := aResults[02]
      ::aOnLostFocus[j]     := aResults[03]
      ::aOnEnter[j]         := aResults[04]
   ENDIF

   IF ::aCtrlType[j] == 'PICTURE'
      cTitle      := cNameW + " events"
      aLabels     := { 'Action' }
      aInitValues := { ::aAction[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aAction[j]          := aResults[01]
   ENDIF

   IF ::aCtrlType[j] == 'PROGRESSMETER'
      cTitle      := cNameW + " events"
      aLabels     := { 'Action' }
      aInitValues := { ::aAction[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aAction[j]          := aResults[01]
   ENDIF

   IF ::aCtrlType[j] == 'SCROLLBAR'
      cTitle      := cNameW + " events"
      aLabels     := { 'On Change',    'On LineLeft/LineUp', 'On LineRight/LineDown', 'On PageLeft/PageUp', 'On PageRight/PageDown', 'On Left/Top', 'On Right/Bottom', 'On Thumb',      'On Track',        'On EndTrack' }
      aInitValues := { ::aOnChange[j], ::aOnDblClick[j],     ::aOnDelete[j],          ::aOnDrop[j],         ::aOnEditCell[j],        ::aOnEnter[j], ::aOnGotFocus[j],  ::aOnHScroll[j], ::aOnLabelEdit[j], ::aOnListClose[j] }
      aFormats    := { 250,            250,                  250,                     250,                  250,                     250,           250,               250,             250,               250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aOnChange[j]        := aResults[01]
      ::aOnDblClick[j]      := aResults[02]
      ::aOnDelete[j]        := aResults[03]
      ::aOnDrop[j]          := aResults[04]
      ::aOnEditCell[j]      := aResults[05]
      ::aOnEnter[j]         := aResults[06]
      ::aOnGotFocus[j]      := aResults[07]
      ::aOnHScroll[j]       := aResults[08]
      ::aOnLabelEdit[j]     := aResults[08]
      ::aOnListClose[j]     := aResults[08]
   ENDIF

   IF ::aCtrlType[j] == 'TEXTARRAY'
      cTitle      := cNameW + " events"
      aLabels     := { 'Action' }
      aInitValues := { ::aAction[j] }
      aFormats    := { 250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         ::oDesignForm:SetFocus()
         RETURN NIL
      ENDIF
      ::aAction[j]          := aResults[01]
   ENDIF

   ::lFSave := .F.
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD FrmProperties() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cTitle, aLabels, aInitValues, aFormats, aResults

   cTitle      := 'Properties of Form ' + ::cFName
   aLabels     := { 'Title',   'Icon',   'Main',   'Child',   'NoShow',   'Topmost',   'NoMinimize',   'NoMaximize',   'NoSize',   'NoSysMenu',   'NoCaption',   'Modal',   'NotifyIcon',   'NotifyToolTip',   'NoAutoRelease',   'HelpButton',   'Focused',   'Break',   'SplitChild',   'GripperText',   'Cursor',   'VirtualHeight',  'VirtualWidth',  'Obj',   'ModalSize',   'MDI',   'MDIClient',   'MDIChild',   'Internal',   'RTL',   'ClientArea',   'MinWidth',   'MaxWidth',   'MinHeight',   'MaxHeight',   'BackImage',   'Stretch',   'Parent',   'SubClass' }
   aInitValues := { ::cFTitle, ::cficon, ::lfmain, ::lfchild, ::lfnoshow, ::lftopmost, ::lfnominimize, ::lfnomaximize, ::lfnosize, ::lfnosysmenu, ::lfnocaption, ::lfmodal, ::cfnotifyicon, ::cfnotifytooltip, ::lfnoautorelease, ::lfhelpbutton, ::lffocused, ::lfbreak, ::lfsplitchild, ::cFGripperText, ::cFCursor, ::nfvirtualh,     ::nfvirtualw,    ::cfobj, ::lFModalSize, ::lFMDI, ::lFMDIClient, ::lFMDIChild, ::lFInternal, ::lFRTL, ::lFClientArea, ::nFMinWidth, ::nFMaxWidth, ::nFMinHeight, ::nFMaxHeight, ::cFBackImage, ::lFStretch, ::cFParent, ::cFSubClass }
   aFormats    := { 200,       31,       .F.,      .F.,       .F.,        .F.,         .F.,            .F.,            .F.,        .F.,           .F.,           .F.,       120,            120,               .F.,               .F.,            .F.,         .F.,       .F.,            250,             31,         '9999',           '9999',          120,     .F.,           .F.,     .F.,           .F.,          .F.,          .F.,     .F.,            '99999',      '99999',      '99999',       '99999',       250,           .F.,         250,        250 }
   aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
   IF aResults[1] == NIL
      ::oDesignForm:SetFocus()
      RETURN NIL
   ENDIF

   ::cFTitle              := IIF( HB_IsString(  aResults[01] ), aResults[01], "" )
   ::cFIcon               := IIF( HB_IsString(  aResults[02] ), aResults[02], "" )
   ::lFMain               := IIF( HB_IsLogical( aResults[03] ), aResults[03], .F. )
   ::lFChild              := IIF( HB_IsLogical( aResults[04] ), aResults[04], .F. )
   ::lFNoShow             := IIF( HB_IsLogical( aResults[05] ), aResults[05], .F. )
   ::lFTopmost            := IIF( HB_IsLogical( aResults[06] ), aResults[06], .F. )
   ::lFNominimize         := IIF( HB_IsLogical( aResults[07] ), aResults[07], .F. )
   ::lFNomaximize         := IIF( HB_IsLogical( aResults[08] ), aResults[08], .F. )
   ::lFNoSize             := IIF( HB_IsLogical( aResults[09] ), aResults[09], .F. )
   ::lFNoSysMenu          := IIF( HB_IsLogical( aResults[10] ), aResults[10], .F. )
   ::lFNoCaption          := IIF( HB_IsLogical( aResults[11] ), aResults[11], .F. )
   ::lFModal              := IIF( HB_IsLogical( aResults[12] ), aResults[12], .F. )
   ::cFNotifyIcon         := IIF( HB_IsString(  aResults[13] ), aResults[13], "" )
   ::cFNotifyTooltip      := IIF( HB_IsString(  aResults[14] ), aResults[14], "" )
   ::lFNoAutoRelease      := IIF( HB_IsLogical( aResults[15] ), aResults[15], .F. )
   ::lFHelpButton         := IIF( HB_IsLogical( aResults[16] ), aResults[16], .F. )
   ::lFFocused            := IIF( HB_IsLogical( aResults[17] ), aResults[17], .F. )
   ::lFBreak              := IIF( HB_IsLogical( aResults[18] ), aResults[18], .F. )
   ::lFSplitchild         := IIF( HB_IsLogical( aResults[19] ), aResults[19], .F. )
   ::cFGripperText        := IIF( HB_IsString(  aResults[20] ), aResults[20], "" )
   ::cFCursor             := IIF( HB_IsString(  aResults[21] ), aResults[21], "" )
   ::nfvirtualh           := IIF( HB_IsNumeric( aResults[22] ), aResults[22], 0 )
   ::nfvirtualw           := IIF( HB_IsNumeric( aResults[23] ), aResults[23], 0 )
   ::cfobj                := IIF( HB_IsString(  aResults[24] ), aResults[24], "" )
   ::lFModalSize          := IIF( HB_IsLogical( aResults[25] ), aResults[25], .F. )
   ::lFMDI                := IIF( HB_IsLogical( aResults[26] ), aResults[26], .F. )
   ::lFMDIClient          := IIF( HB_IsLogical( aResults[27] ), aResults[27], .F. )
   ::lFMDIChild           := IIF( HB_IsLogical( aResults[28] ), aResults[28], .F. )
   ::lFInternal           := IIF( HB_IsLogical( aResults[29] ), aResults[29], .F. )
   ::lFRTL                := IIF( HB_IsLogical( aResults[30] ), aResults[30], .F. )
   ::lFClientArea         := IIF( HB_IsLogical( aResults[31] ), aResults[31], .F. )
   ::nFMinWidth           := IIF( HB_IsNumeric( aResults[32] ), aResults[32], 0 )
   ::nFMaxWidth           := IIF( HB_IsNumeric( aResults[33] ), aResults[33], 0 )
   ::nFMinHeight          := IIF( HB_IsNumeric( aResults[34] ), aResults[34], 0 )
   ::nFMaxHeight          := IIF( HB_IsNumeric( aResults[35] ), aResults[35], 0 )
   ::cFBackImage          := IIF( HB_IsString(  aResults[36] ), aResults[36], "" )
   ::lFStretch            := IIF( HB_IsLogical( aResults[37] ) .AND. ! Empty( ::cFBackImage ), aResults[37], .F. )
   ::cFParent             := IIF( HB_IsString(  aResults[38] ), aResults[38], "" )
   ::cFSubClass           := IIF( HB_IsString(  aResults[39] ), aResults[39], "" )

   ::oDesignForm:Title := ::cFTitle
   ::lFsave := .F.
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD FrmEvents() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cTitle, aLabels, aInitValues, aFormats, aResults

   cTitle      := 'Form ' + ::cFName + " events"
   aLabels     := { 'On Init',  'On Release',  'On MouseClick',  'On MouseMove',  'On MouseDrag',  'On GotFocus',  'On LostFocus',  'On ScrollUp',  'On ScrollDown',  'On ScrollLeft',  'On ScrollRight',  'On HScrollBox',  'On VScrollBox',  'On Size',  'On Paint',  'On NotifyClick',  "On InteractiveClose",  "On Maximize",  "On Minimize",  'On Move',         'On Restore',         'On RClick',         'On MClick',         'On DblClick',         'On RDblClick',         'On MDblClick' }
   aInitValues := { ::cfoninit, ::cfonrelease, ::cfonmouseclick, ::cfonmousemove, ::cfonmousedrag, ::cfongotfocus, ::cfonlostfocus, ::cfonscrollup, ::cfonscrolldown, ::cfonscrollleft, ::cfonscrollright, ::cfonhscrollbox, ::cfonvscrollbox, ::cfonsize, ::cfonpaint, ::cfonnotifyclick, ::cfoninteractiveclose, ::cfonmaximize, ::cfonminimize, ::cFMoveProcedure, ::cFRestoreProcedure, ::cFRClickProcedure, ::cFMClickProcedure, ::cFDblClickProcedure, ::cFRDblClickProcedure, ::cFMDblClickProcedure  }
   aFormats    := { 250,        250,           250,              250,             250,             250,            250,             250,            250,              250,              250,               250,              250,              250,        250,         250,               250,                    250,            250,            250,               250,                  250,                 250,                 250,                   250,                    250 }
   aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
   IF aResults[1] == NIL
      ::oDesignForm:SetFocus()
      RETURN NIL
   ENDIF

   ::cFOnInit             := aResults[01]
   ::cFOnRelease          := aResults[02]
   ::cFOnMouseClick       := aResults[03]
   ::cFOnMouseMove        := aResults[04]
   ::cFOnMouseDrag        := aResults[05]
   ::cFOnGotFocus         := aResults[06]
   ::cFOnLostFocus        := aResults[07]
   ::cFOnScrollUp         := aResults[08]
   ::cFOnScrollDown       := aResults[09]
   ::cFOnScrollLeft       := aResults[10]
   ::cFOnScrollRight      := aResults[11]
   ::cFOnHScrollbox       := aResults[12]
   ::cFOnVScrollbox       := aResults[13]
   ::cFOnSize             := aResults[14]
   ::cFOnPaint            := aResults[15]
   ::cFOnNotifyClick      := aResults[16]
   ::cFOnInteractiveClose := aResults[17]
   ::cFOnMaximize         := aResults[18]
   ::cFOnMinimize         := aResults[19]
   ::cFMoveProcedure      := aResults[20]
   ::cFRestoreProcedure   := aResults[21]
   ::cFRClickProcedure    := aResults[22]
   ::cFMClickProcedure    := aResults[23]
   ::cFDblClickProcedure  := aResults[24]
   ::cFRDblClickProcedure := aResults[25]
   ::cFMDblClickProcedure := aResults[26]

   ::lFSave := .F.
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Snap( oControl ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nRow, nCol
   IF ::myIde:lSnap
      nRow := oControl:Row
      nCol := oControl:Col
      DO WHILE Mod( nRow, 10 ) # 0
         nRow --
      ENDDO
      DO WHILE Mod( nCol, 10 ) # 0
         nCol --
      ENDDO
      oControl:Row := nRow
      oControl:Col := nCol
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD CrtlIsOfType( ia, cType ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i

   // ia must be numeric and > 0
   IF ( i := aScan( ::aControlW, Lower( ::oDesignForm:aControls[ia]:Name ) ) ) > 0
      // cType must be uppercase
      IF ::aCtrlType[i] $ cType
         RETURN .T.
      ENDIF
   ENDIF
RETURN .F.


#pragma BEGINDUMP

#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"

//------------------------------------------------------------------------------
HB_FUNC( SETPIXEL )
//------------------------------------------------------------------------------
{

  hb_retnl( (ULONG) SetPixel( (HDC) hb_parnl( 1 ),
                              hb_parni( 2 )      ,
                              hb_parni( 3 )      ,
                              (COLORREF) hb_parnl( 4 )
                            ) ) ;
}

//------------------------------------------------------------------------------
HB_FUNC ( INTERACTIVESIZEHANDLE )
//------------------------------------------------------------------------------
{
   keybd_event( VK_DOWN, 0, 0, 0 );
   keybd_event( VK_RIGHT, 0, 0, 0 );
   SendMessage( (HWND) hb_parnl( 1 ), WM_SYSCOMMAND, SC_SIZE, 0 );
}

//------------------------------------------------------------------------------
HB_FUNC ( INTERACTIVEMOVEHANDLE )
//------------------------------------------------------------------------------
{
   keybd_event( VK_RIGHT, 0, 0, 0 );
   keybd_event( VK_LEFT, 0, 0, 0 );
   SendMessage( (HWND) hb_parnl( 1 ), WM_SYSCOMMAND, SC_MOVE, 10 );
}

#pragma ENDDUMP

/*
 * EOF
 */

