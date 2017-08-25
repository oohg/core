/*
 * $Id: mgide.prg,v 1.36 2017-08-25 18:20:41 fyurisich Exp $
 */
/*
 * ooHG IDE+ form generator
 *
 * Copyright 2002-2017 Ciro Vargas Clemow <cvc@oohg.org>
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
#include "common.ch"
#include "i_windefs.ch"

#DEFINE CRLF hb_OSNewLine()
#DEFINE CR Chr(13)
#DEFINE LF Chr(10)
#DEFINE HTAB Chr(9)
#DEFINE APP_FULL_NAME "ooHG IDE Plus" + " v." + SubStr( __DATE__, 3, 2 ) + "." + Right( __DATE__, 4 )

//------------------------------------------------------------------------------
FUNCTION Main( rtl )
//------------------------------------------------------------------------------
LOCAL myIde

   SetAppHotKey( VK_F10, 0, { || _OOHG_CallDump() } )
   SetAppHotKey( VK_F11, 0, { || AutoMsgBox( &( InputBox( "Variable to inspect:", 'OOHG IDE+' ) ) ) } )

   IF rtl # NIL
      rtl := Upper( rtl )
      IF rtl == "RTL"
         SET GLOBALRTL ON
         rtl := NIL
      ENDIF
   ENDIF

   myIde := THMI()
   myIde:NewIde( rtl )
RETURN NIL

//------------------------------------------------------------------------------
CLASS THMI
//------------------------------------------------------------------------------
   DATA aEditors           INIT {}
   DATA aliner             INIT {}
   DATA aPositions         INIT { {0, 0}, {120, 0}, {120, GetDeskTopWidth() - 380} }
   DATA aSystemColor       INIT {215, 231, 244}
   DATA aSystemColorAux    INIT  {}
   DATA cBCCFolder         INIT ''
   DATA cExteditor         INIT ''
   DATA cFile              INIT ''
   DATA cFormDefFontColor  INIT '{0, 0, 0}'
   DATA cFormDefFontName   INIT 'MS Sans Serif'
   DATA cGuiHbBCC          INIT ''
   DATA cGuiHbMinGW        INIT ''
   DATA cGuiHbPelles       INIT ''
   DATA cGuixHbBCC         INIT ''
   DATA cGuixHbMinGW       INIT ''
   DATA cGuixHbPelles      INIT ''
   DATA cHbBCCFolder       INIT ''
   DATA cHbMinGWFolder     INIT ''
   DATA cHbPellFolder      INIT ''
   DATA cIDE_Folder        INIT ''
   DATA cItemFile          INIT ''
   DATA clib               INIT ""
   DATA cMinGWFolder       INIT ''
   DATA cOutFile           INIT ''
   DATA cPellFolder        INIT ''
   DATA cProjectName       INIT ''
   DATA cProjFolder        INIT ''
   DATA ctext              INIT ''
   DATA cxHbBCCFolder      INIT ''
   DATA cxHbMinGWFolder    INIT ''
   DATA cxHbPellFolder     INIT ''
   DATA Form_Edit          INIT NIL
   DATA Form_Prefer        INIT NIL
   DATA Form_Splash        INIT NIL
   DATA Form_Tree          INIT NIL
   DATA Form_Wait          INIT NIL
   DATA lCloseOnFormExit   INIT .F.
   DATA lHideTT            INIT .F.
   DATA lPsave             INIT .T.
   DATA lSave              INIT .T.
   DATA lSnap              INIT .F.
   DATA lTBuild            INIT 1
   DATA mainheight         INIT 50 + GetTitleHeight() + GetBorderHeight()
   DATA nActiveEditor      INIT 0
   DATA nCaretPos          INIT 0
   DATA nCompilerC         INIT 2
   DATA nCompxBase         INIT 1
   DATA ncrlf              INIT 0
   DATA nFormDefFontSize   INIT 10
   DATA nLabelHeight       INIT 0
   DATA npostext           INIT 0
   DATA nPxMove            INIT 5
   DATA nPxSize            INIT 1
   DATA nStdVertGap        INIT 24
   DATA nSyntax            INIT 1
   DATA ntemp              INIT 0
   DATA nTextBoxHeight     INIT 0
   DATA swsalir            INIT .F.
   DATA swvan              INIT .F.
   DATA van                INIT 0

   METHOD About
   METHOD AjustaFrame
   METHOD Analizar
   METHOD BldMinGW
   METHOD BldPellC
   METHOD BuildBcc
   METHOD CleanR
   METHOD DatabaseView
   METHOD DataMan
   METHOD DeleteItem
   METHOD EditorExit
   METHOD Exit
   METHOD GoLine
   METHOD InitializeProject
   METHOD LeaDatoLogicR
   METHOD LeaDatoR
   METHOD LookChanges
   METHOD ModifyItem
   METHOD myInputWindow
   METHOD NewCH
   METHOD NewForm
   METHOD NewIde
   METHOD NewPrg
   METHOD NewProject
   METHOD NewRC
   METHOD NewRpt
   METHOD NextSearch
   METHOD OkPrefer
   METHOD OpenFile
   METHOD OpenProject
   METHOD PosXY
   METHOD Preferences
   METHOD PrintIt
   METHOD ReadINI
   METHOD Reforma
   METHOD Report_Edit
   METHOD RunP
   METHOD SaveAndExit
   METHOD SaveFile
   METHOD SaveINI
   METHOD SaveProject
   METHOD SearchItem
   METHOD SearchText
   METHOD SearchType
   METHOD SplashDelay
   METHOD TxtSearch
   METHOD ViewErrors
   METHOD ViewSource
   METHOD xBldMinGW
   METHOD xBldPellC
   METHOD xBuildBCC

ENDCLASS

//------------------------------------------------------------------------------
METHOD NewIde( cParameter ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nPos, nRed, nGreen, nBlue, lIsProject := .F., pmgFolder, nEsquema, cvcx, cvcy, cAux1, cAux2

   SET CENTURY ON
   SET EXACT ON
   SET FONT TO "Verdana", 9
   SET INTERACTIVECLOSE OFF
   SET NAVIGATION EXTENDED
   SET BROWSESYNC ON
   SET TOOLTIPSTYLE BALLOON

   ::cProjFolder := GetCurrentFolder()
   ::cIDE_Folder := GetStartupFolder()

   IF cParameter # NIL
      nPos := At( ".", cParameter )
      IF nPos > 0
         cAux1 := SubStr( cParameter, 1, nPos - 1 )
         IF ! Empty( cAux1 )
            cAux2 := SubStr( cParameter, nPos + 1, 3 )
            IF Lower( cAux2 ) == "ch"
               ::cFile := cAux1 + "." + cAux2
            ELSEIF Lower( cAux2 ) == "fmg"
               ::cFile := cAux1 + "." + cAux2
            ELSEIF Lower( cAux2 ) == "pmg"
               lIsProject := .T.
               ::cFile := cAux1 + "." + cAux2
            ELSEIF Lower( cAux2 ) == "prg"
               ::cFile := cAux1 + "." + cAux2
            ELSEIF Lower( cAux2 ) == "rc"
               ::cFile := cAux1 + "." + cAux2
            ELSEIF Lower( cAux2 ) == "rpt"
               ::cFile := cAux1 + "." + cAux2
            ENDIF
         ENDIF
      ELSE
         ::cFile := cParameter + ".fmg"
      ENDIF
   ENDIF

   nEsquema := 4        // COLOR_MENU, Menu background color
   nRed     := GetRed( GetSysColor( nEsquema ) )
   nGreen   := GetGreen( GetSysColor( nEsquema ) )
   nBlue    := GetBlue( GetSysColor( nEsquema ) )
   ::aSystemColorAux := &( '{' + Str( nRed, 3 ) + ',' + Str( nGreen, 3 ) + ',' + Str( nBlue, 3 ) + '}' )

   cvcx := GetDesktopWidth()
   cvcy := GetDesktopHeight()

   IF cvcx < 800 .OR. cvcy < 600
      MsgInfo( 'Best viewed with 800x600 or higher resolution.', 'OOHG IDE+' )
   ENDIF

   DEFINE WINDOW Form_Tree OBJ ::Form_Tree ;
      AT 0, 0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE APP_FULL_NAME ;
      MAIN ;
      ICON 'IDE_EDIT' ;
      ON SIZE ::AjustaFrame() ;
      ON INTERACTIVECLOSE If( MsgYesNo( 'Exit program?', 'OOHG IDE+' ), ::Exit(), .F. ) ;
      NOSHOW ;
      BACKCOLOR ::aSystemColor

      DEFINE STATUSBAR FONT 'Verdana' SIZE 9
         STATUSITEM APP_FULL_NAME + '                                 F1 Help    F5 Build    F6 Build / Run    F7 Run    F8 Debug'
      END STATUSBAR

      DEFINE MAIN MENU
         POPUP '&File'
            ITEM '&New Project'          IMAGE 'IDE_NEW'     ACTION ::NewProject()
            ITEM '&Open Project'         IMAGE 'IDE_OPENPRJ' ACTION ::OpenProject()
            ITEM '&Save Project'         IMAGE 'IDE_SAVE'    ACTION ::SaveProject()
            SEPARATOR
            ITEM '&Preferences'          IMAGE 'IDE_CONFIG'  ACTION ::Preferences()
            SEPARATOR
            ITEM '&Exit'                 IMAGE 'IDE_EXIT'    ACTION ::Exit()
         END POPUP
         POPUP 'Pro&ject'
            POPUP 'Add Item' NAME 'Add'  IMAGE 'IDE_NEWITEM'
               ITEM 'Form'                                   ACTION ::NewForm( InputBox( 'Form module', 'Add Form module' ) )
               ITEM 'Prg'                                    ACTION ::NewPrg( InputBox( 'Prg Module', 'Add Prg Module' ) )
               ITEM 'CH'                                     ACTION ::NewCH( InputBox( 'CH Module', 'Add CH Module' ) )
               ITEM 'Rpt'                                    ACTION ::NewRpt( InputBox( 'Rpt Module', 'Add Rpt Module' ) )
               ITEM 'RC'                                     ACTION ::NewRC( InputBox( 'RC Module', 'Add RC Module' ) )
            END POPUP
            SEPARATOR
            ITEM "Modify Item"           IMAGE 'IDE_MOD'     ACTION ::Analizar()
            SEPARATOR
            ITEM 'Remove Item'           IMAGE 'IDE_DEL'     ACTION ::DeleteItem()
            SEPARATOR
            ITEM 'View / Print Item'     IMAGE 'IDE_PRINT'   ACTION ::PrintIt()
         END POPUP
         POPUP 'Build / Run / Debug'
            ITEM 'Build Project'         IMAGE 'IDE_BUILD'   ACTION CompileOptions( Self, 1 )
            ITEM 'Build and Run Project' IMAGE 'IDE_B_R'     ACTION CompileOptions( Self, 2 )
            ITEM 'Run Project'           IMAGE 'IDE_RUN'     ACTION CompileOptions( Self, 3 )
            ITEM 'Debug Project'         IMAGE 'IDE_DEBUG'   ACTION CompileOptions( Self, 4 )
         END POPUP
         POPUP 'Tools'
            ITEM 'Global Search Text'    IMAGE 'IDE_FIND'    ACTION ::SearchText()
            ITEM 'Quick Browse'          IMAGE 'IDE_BROWSE'  ACTION ::DatabaseView()
            ITEM 'Data Manager'          IMAGE 'IDE_DM'      ACTION ::DataMan()
         END POPUP
         POPUP '&Help'
            ITEM 'ooHG Syntax Help'      IMAGE 'IDE_OOHG'    ACTION _Execute( GetActiveWindow(), NIL, ::cIDE_Folder + "\oohg.chm", NIL, NIL, 5 )
            ITEM '&About'                IMAGE 'IDE_OIDE'    ACTION ::About()
         END POPUP
      END MENU

      ON KEY F1 ACTION Help_F1( 'PROJECT', Self )
      ON KEY F5 ACTION CompileOptions( Self, 1 )
      ON KEY F6 ACTION CompileOptions( Self, 2 )
      ON KEY F7 ACTION CompileOptions( Self, 3 )
      ON KEY F8 ACTION CompileOptions( Self, 4 )

      @ 65, 30 FRAME frame_tree WIDTH ( cvcx - 30 ) HEIGHT ( cvcy - 65 )

      DEFINE TREE Tree_1 ;
         AT 90, 50 ;
         WIDTH 200 ;
         HEIGHT ( cvcy -290 ) ;
         VALUE 1 ;
         TOOLTIP { || IIF( ::lHideTT, NIL, 'Double click to modify an item.' ) } ;
         ON DBLCLICK ::Analizar() ;
         NODEIMAGES { "IDE_CL_FL", "IDE_OP_FL" } ;
         ITEMIMAGES { "IDE_DOC", "IDE_DOC_FL" }

         NODE 'Project' IMAGES { "IDE_DOC" }
            TREEITEM 'Form module'
            TREEITEM 'Prg module'
            TREEITEM 'CH module'
            TREEITEM 'Rpt module'
            TREEITEM 'RC module'
         END NODE
      END TREE

      DEFINE SPLITBOX
         DEFINE TOOLBAR 0 ;
            BUTTONSIZE 16, 16 ;
            FLAT ;
            FONT 'Times new roman' ;
            SIZE 10

            BUTTON Button_13 ;
               TOOLTIP 'Exit' ;
               PICTURE 'IDE_EXIT' ;
               ACTION If( MsgYesNo( "Exit program?", 'OOHG IDE+' ), ::Exit(), NIL ) ;
               AUTOSIZE

            BUTTON Button_1b ;
               TOOLTIP 'Open...' ;
               PICTURE 'IDE_OPENPRJ' ;
               ACTION ::OpenProject() ;
               AUTOSIZE

            BUTTON Button_01 ;
               TOOLTIP 'Save...' ;
               PICTURE 'IDE_SAVE' ;
               ACTION ::SaveProject() ;
               AUTOSIZE ;
               SEPARATOR

            BUTTON Button_1 ;
               TOOLTIP 'Add...' ;
               PICTURE 'IDE_NEWITEM' ;
               ACTION ::NewForm( InputBox( 'Form module', 'Add Form module' ) ) ;
               DROPDOWN ;
               AUTOSIZE

            BUTTON Button_6 ;
               TOOLTIP 'Modify item' ;
               PICTURE 'IDE_MOD' ;
               ACTION ::Analizar() ;
               AUTOSIZE

            BUTTON Button_07 ;
               TOOLTIP 'Remove item' ;
               PICTURE 'IDE_DEL' ;
               ACTION ::DeleteItem() ;
               AUTOSIZE

            BUTTON Button_7a ;
               TOOLTIP 'View / Print item' ;
               PICTURE 'IDE_PRINT' ;
               ACTION ::PrintIt() ;
               AUTOSIZE ;
               SEPARATOR

            BUTTON Button_09 ;
               TOOLTIP 'Build project' ;
               PICTURE 'IDE_BUILD' ;
               ACTION CompileOptions( Self, 1 )

            BUTTON Button_10 ;
               TOOLTIP 'Build and run project' ;
               PICTURE 'IDE_B_R' ;
               ACTION CompileOptions( Self, 2 )

            BUTTON Button_11 ;
               TOOLTIP 'Run project' ;
               PICTURE 'IDE_RUN' ;
               ACTION CompileOptions( Self, 3 ) ;
               DROPDOWN ;
               AUTOSIZE ;
               SEPARATOR

            BUTTON Button_8 ;
               TOOLTIP 'Global search' ;
               PICTURE 'IDE_FIND' ;
               ACTION ::SearchText() ;
               AUTOSIZE

            BUTTON Button_qb ;
               TOOLTIP 'Quick browse' ;
               PICTURE 'IDE_BROWSE' ;
               ACTION ::databaseview() ;
               AUTOSIZE

            BUTTON Button_12 ;
               TOOLTIP 'Data manager' ;
               PICTURE 'IDE_DM' ;
               ACTION ::DataMan() ;
               AUTOSIZE
         END TOOLBAR

         DEFINE DROPDOWN MENU BUTTON Button_1
            ITEM 'Form' ACTION ::NewForm( InputBox( 'Form module', 'Add Form module' ) )
            ITEM 'Prg'  ACTION ::NewPrg( InputBox( 'Prg Module', 'Add Prg Module' ) )
            ITEM 'CH'   ACTION ::NewCH( InputBox( 'CH Module', 'Add CH Module' ) )
            ITEM 'Rpt'  ACTION ::NewRpt( InputBox( 'Rpt Module', 'Add Rpt Module' ) )
            ITEM 'RC'   ACTION ::NewRC( InputBox( 'RC Module', 'Add RC Module' ) )
         END MENU

         DEFINE DROPDOWN MENU BUTTON Button_11
            ITEM 'Run'   IMAGE 'IDE_B_R'   ACTION CompileOptions( Self, 3 )
            ITEM 'Debug' IMAGE 'IDE_DEBUG' ACTION CompileOptions( Self, 4 )
         END MENU
      END SPLITBOX

      @ 135, 280 IMAGE image_front ;
         PICTURE 'IDE_BACKIMG' ;
         WIDTH 420 ;
         HEIGHT 219
   END WINDOW

   DEFINE WINDOW Form_Splash OBJ ::Form_Splash ;
      AT 0, 0 ;
      WIDTH 584 ;
      HEIGHT 308 ;
      TITLE '' ;
      MODAL ;
      TOPMOST ;
      NOCAPTION ;
      ON INIT ::SplashDelay()

      @ 0, 0 IMAGE image_splash ;
         PICTURE 'IDE_SPLASH' ;
         WIDTH 584 ;
         HEIGHT 308
   END WINDOW

   CENTER WINDOW Form_Splash
   CENTER WINDOW Form_Tree

   // Default values from exe startup folder
   ::ReadINI( ::cIDE_Folder + '\hmi.ini' )

   DEFINE WINDOW Form_Wait OBJ ::Form_Wait  ;
      AT 10, 10 ;
      WIDTH 150 ;
      HEIGHT 100 ;
      TITLE "Information" ;
      CHILD ;
      NOSYSMENU ;
      NOCAPTION ;
      NOSHOW ;
      BACKCOLOR ::aSystemColor

      @ 35, 15 LABEL hmi_label_101 VALUE '              '  AUTOSIZE FONT 'Times new Roman' SIZE 14
   END WINDOW

   CENTER WINDOW Form_Wait

   IF lIsProject
      // Project
      pmgFolder := OnlyFolder( ::cFile )
      IF ! Empty( pmgFolder )
         ::cProjFolder := pmgFolder
         DirChange( pmgFolder )
      ENDIF
      ::InitializeProject( ::cFile )
      ::Form_Tree:Add:Enabled := .T.
      ::Form_Tree:Button_1:Enabled := .T.
      ACTIVATE WINDOW Form_Tree, Form_Wait, Form_Splash
   ELSEIF ! Empty( ::cFile )
      // Other files (ch, fmg, prg, rc, rpt)
      ::lCloseOnFormExit := .T.
      ::Form_Tree:Add:Enabled := .F.
      ::Form_Tree:Button_1:Enabled := .F.
      ::Form_Tree:Hide()
      ACTIVATE WINDOW Form_Tree, Form_Wait, Form_Splash NOWAIT
      ::Analizar( ::cFile )
   ELSE
      // None
      ::Form_Tree:Add:Enabled := .F.
      ::Form_Tree:Button_1:Enabled := .F.
      ACTIVATE WINDOW Form_Tree, Form_Wait, Form_Splash
   ENDIF
RETURN Self

//------------------------------------------------------------------------------
METHOD AjustaFrame() CLASS THMI
//------------------------------------------------------------------------------
LOCAL aInfo := Array( 4 )

   GetClientRect( ::Form_Tree:hWnd, aInfo )

   ::Form_Tree:frame_tree:Width  := aInfo[ 3 ] - 65
   ::Form_Tree:frame_tree:Height := aInfo[ 4 ] - 120
   ::Form_Tree:Tree_1:Height     := ::Form_Tree:frame_tree:Height - 50

   IF ( ::Form_Tree:frame_tree:Width < ( ::Form_Tree:image_front:Width + 270 ) ) .OR. ( ::Form_Tree:frame_tree:Height < ( ::Form_Tree:image_front:Height + 80 ) )
      ::Form_Tree:image_front:Hide()
   ELSE
      ::Form_Tree:image_front:Show()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION BorraTemp( cFolder )
//------------------------------------------------------------------------------
   IF File( cFolder + "\OBJ\nul" )
      ZapDirectory( cFolder + "\OBJ" + Chr(0) )
   ENDIF
   FErase( cFolder + '_aux.rc' )
   FErase( cFolder + '_build.bat' )
   FErase( cFolder + '_oohg_resconfig.h' )
   FErase( cFolder + '_temp.bc' )
   FErase( cFolder + '_temp.rc' )
   FErase( cFolder + 'b32.bc' )
   FErase( cFolder + 'comp.bat' )
   FErase( cFolder + 'error.lst' )
   FErase( cFolder + 'makefile.gcc' )
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION BorraObj()
//------------------------------------------------------------------------------
   LOCAL aOBJFilesB[aDir( 'OBJ\*.OBJ' )]
   LOCAL aCFiles[aDir( 'OBJ\*.C' )]
   LOCAL aOFiles[aDir( 'OBJ\*.O' )]
   LOCAL aRESFiles[aDir( 'OBJ\*.RES' )]
   LOCAL aMAPFiles[aDir( '*.MAP' )]
   LOCAL aTDSFiles[aDir( '*.TDS' )]
   LOCAL i

   aDir( 'OBJ\*.OBJ', aOBJFilesB )
   aDir( 'OBJ\*.C', aCFiles )
   aDir( 'OBJ\*.O', aOFiles )
   aDir( 'OBJ\*.RES', aRESFiles )
   aDir( '*.MAP', aMAPFiles )
   aDir( '*.TDS', aTDSFiles )

   For i := 1 To Len( aOBJFilesB )
      DELETE FILE ( 'OBJ\' +  aOBJFilesB[i] )
   NEXT i
   For i := 1 To Len( aCFiles )
      DELETE FILE ( 'OBJ\' + aCFiles[i] )
   NEXT i
   For i := 1 To Len( aOFiles )
      DELETE FILE ( 'OBJ\' + aOFiles[i] )
   NEXT i
   For i := 1 To Len( aRESFiles )
      DELETE FILE ( 'OBJ\' + aRESFiles[i] )
   NEXT i
   For i := 1 To Len( aMAPFiles )
      DELETE FILE ( aMAPFiles[i] )
   NEXT i
   For i := 1 To Len( aTDSFiles )
      DELETE FILE ( aTDSFiles[i] )
   NEXT i

   DirRemove( 'OBJ' )
RETURN NIL

//------------------------------------------------------------------------------
METHOD Analizar( cParameter ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL cParent, lWait, nPos, oEditor, cItem, cExt

   IF HB_IsString( cParameter )
      nPos := At( ".", cParameter )
      cExt := Lower( SubStr( cParameter, nPos + 1, 3 ) )
      DO CASE 
      CASE cExt == "ch"
         cParent := "CH module"
      CASE cExt == "fmg"
         cParent := "Form module"
      CASE cExt == "prg"
         cParent := 'Prg module'
      CASE cExt == "rc"
         cParent := "RC module"
      CASE cExt == "rpt"
         cParent := "Rpt module"
      OTHERWISE
         RETURN NIL
      ENDCASE
      cParameter := SubStr( cParameter, 1, nPos - 1 )
      cItem      := Lower( cParameter )
      cParameter := cParameter + "." + cExt
      lWait := .T.
   ELSEIF ::Form_Tree:Tree_1:Value > 0
      cParameter := ::Form_Tree:Tree_1:Item( ::Form_Tree:Tree_1:Value )
      cParent    := ::SearchType( ::Form_Tree:Tree_1:Value )
      DO CASE
      CASE cParent == 'CH module'
         cExt := 'ch'
      CASE cParent == 'Form module'
         cExt := 'fmg'
      CASE cParent == 'Prg module'
         cExt := 'prg'
      CASE cParent == 'RC module'
         cExt := 'rc'
      CASE cParent == 'Rpt module'
         cExt := 'rpt'
      OTHERWISE
         RETURN NIL
      ENDCASE
      cItem      := Lower( cParameter )
      cParameter := cParameter + "." + cExt
      lWait      := .F.
   ELSE
      RETURN NIL
   ENDIF

   IF ! cItem == 'project' .AND. ! cItem == 'ch module' .AND. ! cItem == 'form module' .AND. ! cItem == 'prg module' .AND. ! cItem == 'rc module' .AND. ! cItem == 'rpt module'
      IF cParent == 'Form module'
         IF Len( ::aEditors ) > 0                // TODO: more than one form at the same time
            MsgStop( "Sorry, the IDE can't -yet- edit more than one form at a time.", 'OOHG IDE+' )
         ELSE
            IF aScan( ::aEditors, { |x| Lower( x:cForm ) == cItem + '.fmg' } ) > 0
               MsgStop( 'Form is already open.', 'OOHG IDE+' )
            ELSE
               ::Form_Tree:button_07:enabled := .F.
               ::Form_Tree:button_09:enabled := .F.
               ::Form_Tree:button_10:enabled := .F.
               ::Form_Tree:button_11:enabled := .F.

               oEditor := TFormEditor()
               aAdd( ::aEditors, oEditor )
               ::nActiveEditor := Len( ::aEditors )
               oEditor:EditForm( Self, cParameter, ::nActiveEditor, lWait )
            ENDIF
         ENDIF
      ELSEIF cParent == 'Rpt module'
         ::Report_Edit( cParameter )
      ELSEIF cParent == 'Prg module' .OR. cParent == 'CH module' .OR. cParent == 'RC module'
         ::ModifyItem( cParameter, cParent )
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ReadINI( cFile ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL lSnap := 0, nPos := 0, lHideTT := 0

   IF Left( cFile, 1 ) == "\"
      cFile := SubStr( cFile, 2 )
   ENDIF

   IF ! File( cFile )
      HB_MemoWrit( cFile, '[PROJECT]' )
   ENDIF

   BEGIN INI FILE cFile
      // PROJECT
      GET ::cOutFile          SECTION 'PROJECT'   ENTRY "OUTFILE"         DEFAULT ''
      // EDITOR
      GET ::cExteditor        SECTION 'EDITOR'    ENTRY "EXTERNAL"        DEFAULT ''
      // FORM'S FONT
      GET ::cFormDefFontName   SECTION "FORMFONT" ENTRY "FONT"            DEFAULT ::cFormDefFontName
      IF ::cFormDefFontName == 'NIL'
         ::cFormDefFontName := ''
      ENDIF
      GET ::nFormDefFontSize   SECTION "FORMFONT" ENTRY "SIZE"            DEFAULT ::nFormDefFontSize
      ::nFormDefFontSize := Int( ::nFormDefFontSize )
      GET ::cFormDefFontColor  SECTION "FORMFONT" ENTRY "COLOR"           DEFAULT ::cFormDefFontColor
      // ****************** FORM'S METRICS
      GET ::nLabelHeight      SECTION "FORMMETRICS" ENTRY "LABELHEIGHT"   DEFAULT 0
      IF ::nLabelHeight < 0
         ::nLabelHeight := 0
      ENDIF
      GET ::nTextBoxHeight    SECTION "FORMMETRICS" ENTRY "TEXTBOXHEIGHT" DEFAULT 0
      IF ::nTextBoxHeight < 0
         ::nTextBoxHeight := 0
      ENDIF
      GET ::nStdVertGap       SECTION "FORMMETRICS" ENTRY "STDVERTGAP"    DEFAULT 24
      IF ::nStdVertGap < 0
         ::nStdVertGap := 24
      ENDIF
      GET ::nPxMove           SECTION "FORMMETRICS" ENTRY "PXMOVE"        DEFAULT 5
      IF ::nPxMove < 0
         ::nPxMove := 5
      ENDIF
      GET ::nPxSize           SECTION "FORMMETRICS" ENTRY "PXSIZE"        DEFAULT 1
      IF ::nPxSize < 0
         ::nPxSize := 1
      ENDIF
      // OOHG
      GET ::cGuiHbMinGW       SECTION 'GUILIB'    ENTRY "GUIHBMINGW"      DEFAULT 'c:\oohg'
      GET ::cGuiHbBCC         SECTION 'GUILIB'    ENTRY "GUIHBBCC"        DEFAULT 'c:\oohg'
      GET ::cGuiHbPelles      SECTION 'GUILIB'    ENTRY "GUIHBPELL"       DEFAULT 'c:\oohg'
      GET ::cGuixHbMinGW      SECTION 'GUILIB'    ENTRY "GUIXHBMINGW"     DEFAULT 'c:\oohg'
      GET ::cGuixHbBCC        SECTION 'GUILIB'    ENTRY "GUIXHBBCC"       DEFAULT 'c:\oohg'
      GET ::cGuixHbPelles     SECTION 'GUILIB'    ENTRY "GUIXHBPELL"      DEFAULT 'c:\oohg'
      // HARBOUR
      GET ::cHbMinGWFolder    SECTION 'HARBOUR'   ENTRY "HBMINGW"         DEFAULT 'c:\harbourm'
      GET ::cHbBCCFolder      SECTION 'HARBOUR'   ENTRY "HBBCC"           DEFAULT 'c:\harbourb'
      GET ::cHbPellFolder     SECTION 'HARBOUR'   ENTRY "HBPELLES"        DEFAULT 'c:\harbourp'
      // XHARBOUR
      GET ::cxHbMinGWFolder   SECTION 'HARBOUR'   ENTRY "XHBMINGW"        DEFAULT 'c:\xharbourm'
      GET ::cxHbBCCFolder     SECTION 'HARBOUR'   ENTRY "XHBBCC"          DEFAULT 'c:\xharbourb'
      GET ::cxHbPellFolder    SECTION 'HARBOUR'   ENTRY "XHBPELLES"       DEFAULT 'c:\xharbourp'
      // C COMPILER
      GET ::cMinGWFolder      SECTION 'COMPILER'  ENTRY "MINGWFOLDER"     DEFAULT 'c:\MinGW'
      GET ::cBCCFolder        SECTION 'COMPILER'  ENTRY "BCCFOLDER"       DEFAULT 'c:\Borland\BCC55'
      GET ::cPellFolder       SECTION 'COMPILER'  ENTRY "PELLESFOLDER"    DEFAULT 'c:\PellesC'
      // MODE
      GET ::nCompxBase        SECTION 'WHATCOMP'  ENTRY "XBASECOMP"       DEFAULT 1  // 1 Harbour  2 xHarbour
      GET ::nCompilerC        SECTION 'WHATCOMP'  ENTRY "CCOMPILER"       DEFAULT 1  // 1 MinGW    2 BCC   3 Pelles C
      // POSITION
      GET nPos                SECTION 'POSITION'  ENTRY "FORM_MAIN_ROW"   DEFAULT ::aPositions[1, 1]
      IF HB_IsNumeric( nPos ) .AND. nPos >= 0
         ::aPositions[1, 1] := nPos
      ENDIF
      GET nPos                SECTION 'POSITION'  ENTRY "FORM_MAIN_COL"   DEFAULT ::aPositions[1, 2]
      IF HB_IsNumeric( nPos ) .AND. nPos >= 0
         ::aPositions[1, 2] := nPos
      ENDIF
      GET nPos                SECTION 'POSITION'  ENTRY "CVCCNTRLS_ROW"   DEFAULT ::aPositions[2, 1]
      IF HB_IsNumeric( nPos ) .AND. nPos >= 0
         ::aPositions[2, 1] := nPos
      ENDIF
      GET nPos                SECTION 'POSITION'  ENTRY "CVCCNTRLS_COL"   DEFAULT ::aPositions[2, 2]
      IF HB_IsNumeric( nPos ) .AND. nPos >= 0
         ::aPositions[2, 2] := nPos
      ENDIF
      GET nPos                SECTION 'POSITION'  ENTRY "FORM_LIST_ROW"   DEFAULT ::aPositions[3, 1]
      IF HB_IsNumeric( nPos ) .AND. nPos >= 0
         ::aPositions[3, 1] := nPos
      ENDIF
      GET nPos                SECTION 'POSITION'  ENTRY "FORM_LIST_COL"   DEFAULT ::aPositions[3, 2]
      IF HB_IsNumeric( nPos ) .AND. nPos >= 0
         ::aPositions[3, 2] := nPos
      ENDIF
      // OTHER
      GET ::lTBuild           SECTION 'SETTINGS'  ENTRY "BUILD"           DEFAULT 2  // 1 Compile.bat 2 Own Make
      GET lSnap               SECTION 'SETTINGS'  ENTRY "SNAP"            DEFAULT 0
      ::lSnap := ( lSnap == 1 )
      GET ::clib              SECTION 'SETTINGS'  ENTRY "LIB"             DEFAULT ''
      GET ::nSyntax           SECTION 'SETTINGS'  ENTRY "SYNTAX"          DEFAULT 1
      GET lHideTT             SECTION 'SETTINGS'  ENTRY "HIDETT"          DEFAULT 0
      ::lHideTT := ( lHideTT == 1 )
   END INI
RETURN NIL

//------------------------------------------------------------------------------
METHOD SaveINI( cFile ) CLASS THMI
//------------------------------------------------------------------------------

   IF Left( cFile, 1 ) == "\"
      cFile := SubStr( cFile, 2 )
   ENDIF

   BEGIN INI FILE cFile
      // PROJECT
      SET SECTION 'PROJECT'     ENTRY "PROJFOLDER"    TO ::cProjFolder
      SET SECTION 'PROJECT'     ENTRY "OUTFILE"       TO ::cOutFile
      // EDITOR
      SET SECTION "EDITOR"      ENTRY "EXTERNAL"      TO ::cExteditor
      // FORM'S FONT
      SET SECTION "FORMFONT"    ENTRY "FONT"          TO If( Empty( ::cFormDefFontName ), 'NIL', ::cFormDefFontName )
      SET SECTION "FORMFONT"    ENTRY "SIZE"          TO LTrim( Str( ::nFormDefFontSize, 2, 0 ) )
      SET SECTION "FORMFONT"    ENTRY "COLOR"         TO ::cFormDefFontColor
      // FORM'S METRICS
      SET SECTION "FORMMETRICS" ENTRY "LABELHEIGHT"   TO LTrim( Str( ::nLabelHeight, 2, 0 ) )
      SET SECTION "FORMMETRICS" ENTRY "TEXTBOXHEIGHT" TO LTrim( Str( ::nTextBoxHeight, 2, 0 ) )
      SET SECTION "FORMMETRICS" ENTRY "STDVERTGAP"    TO LTrim( Str( ::nStdVertGap, 3, 0 ) )
      SET SECTION "FORMMETRICS" ENTRY "PXMOVE"        TO LTrim( Str( ::nPxMove, 2, 0 ) )
      SET SECTION "FORMMETRICS" ENTRY "PXSIZE"        TO LTrim( Str( ::nPxSize, 2, 0 ) )
      // OOHG
      SET SECTION 'GUILIB'      ENTRY "GUIHBMINGW"    TO ::cGuiHbMinGW
      SET SECTION 'GUILIB'      ENTRY "GUIHBBCC"      TO ::cGuiHbBCC
      SET SECTION 'GUILIB'      ENTRY "GUIHBPELL"     TO ::cGuiHBPelles
      SET SECTION 'GUILIB'      ENTRY "GUIXHBMINGW"   TO ::cGuixHbMinGW
      SET SECTION 'GUILIB'      ENTRY "GUIXHBBCC"     TO ::cGuixHbBCC
      SET SECTION 'GUILIB'      ENTRY "GUIXHBPELL"    TO ::cGuixHBPelles
      // HARBOUR
      SET SECTION 'HARBOUR'     ENTRY "HBMINGW"       TO ::cHbMinGWFolder
      SET SECTION 'HARBOUR'     ENTRY "HBBCC"         TO ::cHbBCCFolder
      SET SECTION 'HARBOUR'     ENTRY "HBPELLES"      TO ::cHbPellFolder
      // XHARBOUR
      SET SECTION 'HARBOUR'     ENTRY "XHBMINGW"      TO ::cxHbMinGWFolder
      SET SECTION 'HARBOUR'     ENTRY "XHBBCC"        TO ::cxHbBCCFolder
      SET SECTION 'HARBOUR'     ENTRY "XHBPELLES"     TO ::cxHbPellFolder
      // C COMPILER
      SET SECTION 'COMPILER'    ENTRY "MINGWFOLDER"   TO ::cMinGWFolder
      SET SECTION 'COMPILER'    ENTRY "BCCFOLDER"     TO ::cBCCFolder
      SET SECTION 'COMPILER'    ENTRY "PELLESFOLDER"  TO ::cPellFolder
      // MODE
      SET SECTION 'WHATCOMP'    ENTRY "XBASECOMP"     TO LTrim( Str( ::nCompxBase, 1, 0 ) )
      SET SECTION 'WHATCOMP'    ENTRY "CCOMPILER"     TO LTrim( Str( ::nCompilerC, 1, 0 ) )
      // POSITION
      SET SECTION 'POSITION'    ENTRY "FORM_MAIN_ROW" TO LTrim( Str( ::aPositions[1, 1], 6, 0 ) )
      SET SECTION 'POSITION'    ENTRY "FORM_MAIN_COL" TO LTrim( Str( ::aPositions[1, 2], 6, 0 ) )
      SET SECTION 'POSITION'    ENTRY "CVCCNTRLS_ROW" TO LTrim( Str( ::aPositions[2, 1], 6, 0 ) )
      SET SECTION 'POSITION'    ENTRY "CVCCNTRLS_COL" TO LTrim( Str( ::aPositions[2, 2], 6, 0 ) )
      SET SECTION 'POSITION'    ENTRY "FORM_LIST_ROW" TO LTrim( Str( ::aPositions[3, 1], 6, 0 ) )
      SET SECTION 'POSITION'    ENTRY "FORM_LIST_COL" TO LTrim( Str( ::aPositions[3, 2], 6, 0 ) )
      // OTHER
      SET SECTION "SETTINGS"    ENTRY "BUILD"         TO LTrim( Str( ::lTBuild, 1, 0 ) )
      SET SECTION "SETTINGS"    ENTRY "LIB"           TO ::clib
      SET SECTION "SETTINGS"    ENTRY "SNAP"          TO If( ::lSnap, "1", "0" )
      SET SECTION "SETTINGS"    ENTRY "SYNTAX"        TO LTrim( Str( ::nSyntax, 1, 0 ) )
      SET SECTION "SETTINGS"    ENTRY "HIDETT"        TO If( ::lHideTT, "1", "0" )
   END INI
RETURN NIL

//------------------------------------------------------------------------------
METHOD Exit() CLASS THMI
//------------------------------------------------------------------------------
   IF IsWindowDefined( Form_Edit )
      ::SaveAndExit()
   ENDIF

   DO WHILE Len( ::aEditors ) > 0
      aTail( ::aEditors ):Exit()
      ::nActiveEditor := Len( ::aEditors )
   ENDDO

   IF ! ::lPsave
      IF MsgYesNo( 'Project not saved, save it now?', 'OOHG IDE+' )
         ::SaveProject()
      ENDIF
   ENDIF

   IF IsWindowActive( Form_Tree )
      ::Form_Tree:Release()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD PrintIt() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cItem, cParent, cArch

   cItem := ::Form_Tree:Tree_1:Item( ::Form_Tree:Tree_1:Value )
   cParent := ::SearchType( ::Form_Tree:Tree_1:Value )
   IF cParent == 'Prg module' .AND. cItem # 'Prg module'
      cArch := MemoRead( cItem + '.prg' )
   ELSE
      IF cParent == 'Form module' .AND. cItem # 'Form module'
         cArch := MemoRead( cItem + '.fmg' )
      ELSE
         IF cParent == 'CH module' .AND. cItem # 'CH module'
            cArch := MemoRead( cItem + '.ch' )
         ELSE
            IF cParent == 'Rpt module' .AND. cItem # 'Rpt module'
               cArch := MemoRead( cItem + '.rpt' )
            ELSE
               IF cParent == 'RC module' .AND. cItem # 'RC module'
                  cArch := MemoRead( cItem + '.rc' )
               ELSE
                  MsgInfo( "This item can't be printed.", 'OOHG IDE+' )
                  RETURN NIL
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   ::ViewSource( cArch )
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION CompileOptions( myIde, nOpt )
//------------------------------------------------------------------------------

   Do Case
      Case nOpt = 1  // Only Make
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=1 )  // Harbour-MinGW
              myIde:BldMinGW(0)
           ENDIF
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=2 )  // Harbour-BCC
              myIde:BuildBcc(0)
           ENDIF
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=3 )  // Harbour-PellesC
              myIde:BldPellc(0)
           ENDIF

           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=1 )  // xHarbour-MinGW
              myIde:xBldMinGW(0)
           ENDIF
           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=2 )  // xHarbour-BCC
              myIde:xBuildBcc(0)
           ENDIF
           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=3 )  // xHarbour-PellesC
              myIde:xBldPellc(0)
           ENDIF

      Case nOpt = 2  // Make and Run
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=1 )  // Harbour-MinGW
              myIde:BldMinGW(1)
           ENDIF
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=2 )  // Harbour-BCC
              myIde:BuildBcc(1)
           ENDIF
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=3 )  // Harbour-PellesC
              myIde:BldPellc(1)
           ENDIF

           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=1 )  // xHarbour-MinGW
              myIde:xBldMinGW(1)
           ENDIF
           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=2 )  // xHarbour-BCC
              myIde:xBuildBcc(1)
           ENDIF
           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=3 )  // xHarbour-PellesC
              myIde:xBldPellc(1)
           ENDIF

      Case nOpt = 3  // Only Run
           myIde:RunP()

      Case nOpt = 4  // Debug
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=1 )  // Harbour-MinGW
              myIde:BldMinGW(2)
           ENDIF
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=2 )  // Harbour-BCC
              myIde:BuildBcc(2)
           ENDIF
           IF ( myIde:nCompxBase=1 .AND. myIde:nCompilerC=3 )  // Harbour-PellesC
              myIde:BldPellc(2)
           ENDIF

           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=1 )  // xHarbour-MinGW
              myIde:xBldMinGW(2)
           ENDIF
           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=2 )  // xHarbour-BCC
              myIde:xBuildBcc(2)
           ENDIF
           IF ( myIde:nCompxBase=2 .AND. myIde:nCompilerC=3 )  // xHarbour-PellesC
              myIde:xBldPellc(2)
           ENDIF

   Endcase
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION PrintItem( cArch )
//------------------------------------------------------------------------------
LOCAL oPrint, nCount, wPage, i

   IF ! HB_IsString ( cArch )
      RETURN NIL
   ENDIF
   oPrint := TPrint( "HBPRINTER" )
   oPrint:Init()
   oPrint:SelPrinter( .T., .T. )
   IF oPrint:lPrError
      MsgStop( 'Error detected while printing.', 'OOHG IDE+' )
      oPrint:Release()
      RETURN NIL
   ENDIF
   oPrint:BeginDoc()
   oPrint:SetPreviewSize( 1 )
   oPrint:BeginPage()
   oPrint:SetCPL( 120 )

   nCount := 1
   oPrint:PrintData( nCount, 0, Replicate( '-', 90 ) )
   wpage := 1
   FOR i := 1 TO MLCount( cArch )
      nCount ++
      oPrint:PrintData( nCount, 0, AllTrim( MemoLine( cArch, 500, i ) ) )
      IF nCount > 60
         nCount ++
         nCount ++
         oPrint:PrintData( nCount, 0, 'Page... ' + Str( wPage, 3 ) )
         nCount ++
         oPrint:PrintData( nCount, 0, Replicate( '-', 90 ) )
         oPrint:EndPage()
         oPrint:BeginPage()
         nCount := 1
         wPage ++
      ENDIF
   NEXT i
   nCount ++
   nCount ++
   oPrint:PrintData( nCount, 0, 'Page... ' + Str( wPage, 3 ) )
   nCount ++
   oPrint:PrintData( nCount, 0, Replicate( '-', 90 ) )
   nCount ++
   oPrint:PrintData( nCount, 0, 'End print ' )
   oPrint:EndPage()
   oPrint:EndDoc()
RETURN NIL

//------------------------------------------------------------------------------
METHOD About() CLASS THMI
//------------------------------------------------------------------------------
LOCAL about_form

   DEFINE WINDOW about_form obj about_form ;
      AT 0,0 ;
      WIDTH 450 ;
      HEIGHT 220 ;
      TITLE 'About ooHG IDE+ '  ;
      ICON 'IDE_EDIT' ;
      MODAL NOSIZE NOSYSMENU ;
      backcolor ::aSystemColor

      @ 1,1 FRAME FRAME1 ;
         WIDTH 437 ;
         HEIGHT 190

      @ 15,330 IMAGE Myphoto ;
         PICTURE 'IDE_CVCPHOTO' ;
         WIDTH 97 ;
         HEIGHT 69

      @ 85,330 IMAGE MYOOHG ;
         PICTURE 'IDE_ABOUT' ;
         WIDTH 97 ;
         HEIGHT 97

      @ 20,20 LABEL LB_NORM ;
         VALUE APP_FULL_NAME ;
         FONT "Times new Roman" ;
         SIZE 10  ;
         AUTOSIZE

      @ 40,20 HYPERLINK LB_MAIL ;
         VALUE "(c) 2002-" + LTrim( Str( Year( Date() ) ) ) + " Ciro Vargas Clemow" ;
         ADDRESS 'cvc@oohg.org' ;
         WIDTH 120 ;
         HEIGHT 24 ;
         AUTOSIZE ;
         FONT "Times new Roman" ;
         SIZE 10  ;
         TOOLTIP 'Click to e-mail me' ;
         HANDCURSOR ;

      @ 60,20 LABEL LB_NORM1 ;
         VALUE 'Original idea by Roberto López. (MiniGUI creator)' ;
         FONT "Times new Roman" ;
         SIZE 10  ;
         AUTOSIZE

      @ 80,20 LABEL LB_NORM2 ;
         VALUE MiniguiVersion() + " " + HB_COMPILER() + " " + Version() ;
         FONT "Times new Roman" ;
         SIZE 9  ;
         AUTOSIZE

      @ 100,20 LABEL LB_NORMooHG ;
         VALUE 'ooHG creator: Vicente Guerra' ;
         FONT "Times new Roman" ;
         SIZE 10  ;
         AUTOSIZE

      @ 120,20 HYPERLINK LB_HOMEPAGE ;
         VALUE '(c) 2002-' + LTrim( Str( Year( Date() ) ) ) + ' ooHG IDE+ Home page' ;
         ADDRESS 'http://sistemascvc.tripod.com' ;
         WIDTH 120 ;
         HEIGHT 24 ;
         AUTOSIZE ;
         FONT "Times new Roman" ;
         SIZE 10 ;
         TOOLTIP 'Click to go'  ;
         HANDCURSOR

      @ 140,20 LABEL LB_NORM3 ;
         VALUE 'Dedicated to my dear sons, Ciro Andrés, Santiago and Esteban.' ;
         FONT "Times new Roman" SIZE 9 ;
         AUTOSIZE

      @ 160,150 BUTTON button_1 ;
         CAPTION 'Ok' ;
         ACTION { || about_form:release } ;
         FLAT

   END WINDOW
   about_form:button_1:setfocus()
   CENTER WINDOW about_form
   playhand()
   ACTIVATE WINDOW about_form
RETURN NIL


//------------------------------------------------------------------------------
METHOD DataMan() CLASS THMI
//------------------------------------------------------------------------------
   IF ! IsWindowDefined( _dbu )
      DatabaseView1( Self )
   ELSE
      MsgInfo( 'Data manager is already running.', 'OOHG IDE+' )
   ENDIF
   ::Form_Tree:Maximize()
RETURN NIL

//------------------------------------------------------------------------------
METHOD SplashDelay() CLASS THMI
//------------------------------------------------------------------------------
LOCAL iTime

   CursorWait()
   iTime := Seconds()
   DO WHILE ( Seconds() - iTime ) < 1
   ENDDO
   ::Form_Splash:Release()
   ::Form_Tree:Maximize()
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Preferences() CLASS THMI
//------------------------------------------------------------------------------
LOCAL Folder
LOCAL aFont := { ::cFormDefFontName, ;
                 ::nFormDefFontSize, ;
                 .F., ;
                 .F., ;
                 &(::cFormDefFontColor), ;
                 .F., ;
                 .F., ;
                 0 }

   LOAD WINDOW form_prefer

   ::Form_Prefer := GetFormObject( "Form_prefer" )

   ::Form_Prefer:Backcolor := ::aSystemColor
   ::Form_Prefer:Title := "Preferences from " + ::cProjFolder + '\hmi.ini'

   ::Form_Prefer:text_3:value       := ::cProjFolder
   ::Form_Prefer:text_4:value       := ::cOutFile
   ::Form_Prefer:text_12:value      := ::cGuiHbMinGW
   ::Form_Prefer:text_9:value       := ::cGuiHbBCC
   ::Form_Prefer:text_11:value      := ::cGuiHbPelles
   ::Form_Prefer:text_16:value      := ::cGuixHbMinGW
   ::Form_Prefer:text_17:value      := ::cGuixHbBCC
   ::Form_Prefer:text_18:value      := ::cGuixHbPelles
   ::Form_Prefer:text_8:value       := ::cHbMinGWFolder
   ::Form_Prefer:text_2:value       := ::cHbBCCFolder
   ::Form_Prefer:text_7:value       := ::cHbPellFolder
   ::Form_Prefer:text_13:value      := ::cxHbMinGWFolder
   ::Form_Prefer:text_14:value      := ::cxHbBCCFolder
   ::Form_Prefer:text_15:value      := ::cxHbPellFolder
   ::Form_Prefer:text_10:value      := ::cMinGWFolder
   ::Form_Prefer:text_5:value       := ::cBCCFolder
   ::Form_Prefer:text_6:value       := ::cPellFolder
   ::Form_Prefer:radiogroup_1:value := ::nCompxBase
   ::Form_Prefer:radiogroup_2:value := ::nCompilerC
   ::Form_Prefer:text_19:value      := ::nLabelHeight
   ::Form_Prefer:text_21:value      := ::nTextBoxHeight
   ::Form_Prefer:text_22:value      := ::nStdVertGap
   ::Form_Prefer:text_23:value      := ::nPxMove
   ::Form_Prefer:text_24:value      := ::nPxSize
   ::Form_Prefer:text_1:value       := ::cExteditor
   ::Form_Prefer:text_font:value    := If( Empty( ::cFormDefFontName ), _OOHG_DefaultFontName, ::cFormDefFontName ) + ' ' + ;
                                       LTrim( Str( If( ::nFormDefFontSize > 0, ::nFormDefFontSize, _OOHG_DefaultFontSize ), 2, 0 ) ) + ;
                                       If( ::cFormDefFontColor == 'NIL', '', ', Color ' + ::cFormDefFontColor )
   ::Form_Prefer:Radiogroup_3:value := ::lTBuild
   ::Form_Prefer:text_lib:value     := ::cLib
   ::Form_Prefer:chk_HideTT:value   := ::lHideTT
   ::Form_Prefer:chk_Snap:value     := ::lSnap
   ::Form_Prefer:combo_26:value     := ::nSyntax

   ACTIVATE WINDOW Form_Prefer

RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION GetPreferredFont( Form_prefer, aFont )
//------------------------------------------------------------------------------
   aFont := GetFont( aFont[1], aFont[2], aFont[3], aFont[4], aFont[5], aFont[6], aFont[7], aFont[8] )
   Form_prefer:text_font:value := ;
      If( Empty( aFont[1] ), _OOHG_DefaultFontName, aFont[1] ) + " " + ;
      LTrim( Str( If( aFont[2] > 0, aFont[2], _OOHG_DefaultFontSize ) ) ) + ;
      If( aFont[3], " Bold", "" ) + ;
      If( aFont[4], " Italic", "" ) + ;
      If( aFont[6], " Underline", "" ) + ;
      If( aFont[7], " Strikeout", "" ) + ;
      If( aFont[5, 1] # NIL, ", Color " + '{ ' + LTrim( Str( aFont[5, 1] ) ) + ', ' + ;
                                                 LTrim( Str( aFont[5, 2] ) ) + ', ' + ;
                                                 LTrim( Str( aFont[5, 3] ) ) + ' }', "" )
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION ResetPreferredFont( Form_prefer, aFont )
//------------------------------------------------------------------------------
   aFont := { '', 0, .F., .F., NIL, .F., .F., 0 }
   Form_prefer:text_font:value := _OOHG_DefaultFontName + " " + LTrim( Str( _OOHG_DefaultFontSize ) )
RETURN NIL

//------------------------------------------------------------------------------
METHOD SearchText() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cTextsearch,i,nItems,cInput,cOutput,cItem,j
cTextsearch:=inputbox('Text','Search text')
if len(cTextsearch)=0
   RETURN NIL
ENDIF
cursorwait()
::Form_Wait:hmi_label_101:value:='Searching....'
::Form_Wait:Show()
nItems:=::Form_Tree:Tree_1:ItemCount
cOutput:=''
For i:= 1  to nItems

    cItem:=::Form_Tree:Tree_1:Item (i)

    IF ::SearchType( i ) == 'RC module' .AND. ! cItem == 'RC module'
       IF file(cItem+'.rc')
          cInput:=memoread(cItem+'.rc')
          for j:=1 to mlcount(cInput)
              IF at(upper(ctextsearch),upper(trim(memoline(cInput,500,j)))) > 0
                 cOutput += cItem+'  ==> RC module'+'  Line '+str(j,6)+CRLF
              ENDIF
          NEXT j
       ENDIF
    ELSE
    IF ::SearchType( i ) == 'CH module' .AND. ! cItem == 'CH module'
       IF file(cItem+'.ch')
          cInput:=memoread(cItem+'.ch')
          for j:=1 to mlcount(cInput)
              IF at(upper(ctextsearch),upper(trim(memoline(cInput,500,j)))) > 0
                 cOutput += cItem+'  ==> CH module'+'  Line '+str(j,6)+CRLF
              ENDIF
          NEXT j
       ENDIF
    ELSE
    IF (::SearchType( i ) == 'Prg module') .AND. ! cItem == 'Prg module'
       IF file(citem+'.prg')
          cInput:=memoread(cItem+'.prg')
          for j:=1 to mlcount(cInput)
              IF at(upper(ctextsearch),upper(trim(memoline(cInput,500,j)))) > 0
                 coutput += cItem+'  ==> Prg module '+'  Line '+str(j,6)+CRLF
              ENDIF
          NEXT j
       ENDIF
    ELSE
    IF (::SearchType( i ) == 'Form module') .AND. ! cItem == 'Form module'
       IF file(citem+'.fmg')
          cInput:=memoread(cItem+'.fmg')
          for j:=1 to mlcount(cInput)
              IF at(upper(ctextsearch),upper(trim(memoline(cInput,500,j)))) > 0
                 coutput += cItem+'  ==> Form module'+'  Line '+str(j,6)+CRLF
              ENDIF
          NEXT j
       ENDIF
    ELSE
    IF (::SearchType( i ) == 'Rpt module') .AND. ! cItem == 'Rpt module'
       IF file(citem+'.rpt')
          cInput:=memoread(cItem+'.rpt')
          for j:=1 to mlcount(cInput)
              IF at(upper(ctextsearch),upper(trim(memoline(cInput,500,j)))) > 0
                 coutput += cItem+'  ==> Rpt module'+'  Line '+str(j,6)+CRLF
              ENDIF
          NEXT j
       ENDIF
    ENDIF
    ENDIF
    ENDIF
    ENDIF
    ENDIF
NEXT i
::Form_Wait:Hide()
cursorarrow()
if coutput== ''
   MsgInfo( 'Text not found.', 'OOHG IDE+' )
ELSE
   MsgInfo( cTextsearch + ' found in: ' + CRLF + coutput, 'OOHG IDE+' )
ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD OkPrefer( aFont ) CLASS THMI
//------------------------------------------------------------------------------

   ::cOutFile           := ::Form_Prefer:text_4:Value
   ::cExteditor         := AllTrim( ::Form_Prefer:text_1:Value )
   ::cGuiHbMinGW        := ::Form_Prefer:text_12:Value
   ::cGuiHbBCC          := ::Form_Prefer:text_9:Value
   ::cGuiHbPelles       := ::Form_Prefer:text_11:Value
   ::cGuixHbMinGW       := ::Form_Prefer:text_16:Value
   ::cGuixHbBCC         := ::Form_Prefer:text_17:Value
   ::cGuixHbPelles      := ::Form_Prefer:text_18:Value
   ::cHbMinGWFolder     := ::Form_Prefer:text_8:Value
   ::cHbBCCFolder       := ::Form_Prefer:text_2:Value
   ::cHbPellFolder      := ::Form_Prefer:text_7:Value
   ::cxHbMinGWFolder    := ::Form_Prefer:text_13:Value
   ::cxHbBCCFolder      := ::Form_Prefer:text_14:Value
   ::cxHbPellFolder     := ::Form_Prefer:text_15:Value
   ::cMinGWFolder       := ::Form_Prefer:text_10:Value
   ::cBCCFolder         := ::Form_Prefer:text_5:Value
   ::cPellFolder        := ::Form_Prefer:text_6:Value
   ::nCompxBase         := ::Form_Prefer:radiogroup_1:Value
   ::nCompilerC         := ::Form_Prefer:radiogroup_2:Value
   ::lTBuild            := ::Form_Prefer:Radiogroup_3:Value
   ::lHideTT            := ::Form_Prefer:chk_HideTT:Value
   ::lSnap              := ::Form_Prefer:chk_Snap:Value
   ::cLib               := AllTrim( ::Form_Prefer:text_lib:Value )
   ::cFormDefFontName   := If( Empty( aFont[1] ), '', aFont[1] )
   ::nFormDefFontSize   := If( aFont[2] > 0, Int( aFont[2] ), 0 )
   ::cFormDefFontColor  := If( aFont[5] == NIL .OR. aFont[5,1] == NIL, ;
                               'NIL', ;
                               '{ ' + LTrim( Str( aFont[5, 1] ) ) + ', ' + ;
                                      LTrim( Str( aFont[5, 2] ) ) + ', ' + ;
                                      LTrim( Str( aFont[5, 3] ) ) + ' }' )
   ::nLabelHeight       := ::Form_Prefer:text_19:Value
   ::nTextBoxHeight     := ::Form_Prefer:text_21:Value
   ::nStdVertGap        := ::Form_Prefer:text_22:Value
   ::nPxMove            := ::Form_Prefer:text_23:Value
   ::nPxSize            := ::Form_Prefer:text_24:Value
   ::nSyntax            := ::Form_Prefer:combo_26:Value

   ::Form_Prefer:Release()

   IF Empty( ::cProjectName )
      ::SaveINI( ::cIDE_Folder + '\hmi.ini' )
   ELSE
      ::SaveINI( ::cProjFolder + '\hmi.ini' )
   ENDIF
RETURN NIL

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                     COMPILING WITH MINGW AND HARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

//------------------------------------------------------------------------------
METHOD BldMinGW( nOption ) CLASS THMI
//------------------------------------------------------------------------------
   LOCAL aPrgFiles
   LOCAL aRcFiles
   LOCAL cCompFolder := ::cMinGWFolder + '\'
   LOCAL cDosComm
   LOCAL cError
   LOCAL cError1
   LOCAL cExe
   LOCAL cFile
   LOCAL cHarbourFolder := ::cHbMinGWFolder + '\'
   LOCAL cMiniGuiFolder := ::cGUIHbMinGW + '\'
   LOCAL cOut
   LOCAL cPrgName
   LOCAL cFolder := ::cProjFolder + '\'
   LOCAL i
   LOCAL nItems
   LOCAL nPrgFiles

   ::Form_Tree:button_09:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      IF Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The MinGW folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-Hb-MinGW folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Harbour-MinGW folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      IF File( cExe )
         DELETE FILE ( cExe )
      ENDIF
      IF File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'OOHG IDE+' )
         Break
      ENDIF

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ELSEIF ::SearchType( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .AND. ! cFile == 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build make script
         // Variables
         cOut := ''
         cOut += 'PATH          = ' + cCompFolder + 'BIN' + CRLF
         cOut += 'PROJECTFOLDER = ' + DelSlash( cFolder ) + CRLF
         cOut += 'APP_NAME      = ' + cExe + CRLF
         cOut += 'OBJ_DIR       = ' + cFolder + 'OBJ' + CRLF
         cOut += 'OBJECTS       = '
         For i := 1 To nPrgFiles
            cOut += '\' + CRLF + '$(OBJ_DIR)\' + aPrgFiles[i] + '.o '
         NEXT i
         For i := 1 to Len( aRcFiles )
            cOut += '\' + CRLF + '$(OBJ_DIR)\_temp.o'
         NEXT i
         cOut += CRLF
         cOut += 'LINK_EXE      = GCC.EXE' + CRLF
         cOut += 'LINK_FLAGS    = -Wall -mwindows -O3 -Wl,--allow-multiple-definition' + CRLF
         cOut += 'LINK_SEARCH   = -L' + DelSlash( cFolder ) + ;
                                ' -L' + cCompFolder + 'LIB' + ;
                                ' -L' + cHarbourFolder + If( File( cHarbourFolder + 'LIB\WIN\MINGW\LIBHBRTL.A' ), 'LIB\WIN\MINGW', 'LIB' ) + ;
                                ' -L' + cMiniGUIFolder + If( File( cMiniGUIFolder + 'LIB\HB\MINGW\LIBOOHG.A' ), 'LIB\HB\MINGW', 'LIB' ) + CRLF
         cOut += 'LINK_LIBS     = -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui ' + ;
                                  '-lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbzebra -lhbziparc ' + ;
                                  '-lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lrddsql -lsddodbc ' + ;
                                  '-lodbc32 -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 ' + ;
                                  '-lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -lmsimg32 ' + ;
                                  If( nOption == 2, '-lgtwin ', '' ) + ;
                                  If( ! Empty( ::cLib ), ::cLib + ' ', '' ) + ;
                                  '-Wl,--end-group' + CRLF
         cOut += 'CC_EXE        = GCC.EXE' + CRLF
         cOut += 'CC_FLAGS      = -Wall -mwindows -O3' + CRLF
         cOut += 'CC_SEARCH     = -I' + DelSlash( cFolder ) + ;
                                ' -I' + cCompFolder + 'INCLUDE' + ;
                                ' -I' + cHarbourFolder + 'INCLUDE' + ;
                                ' -I' + cMiniGUIFolder + 'INCLUDE' + CRLF
         cOut += 'HRB_EXE       = ' + cHarbourFolder + 'BIN\HARBOUR.EXE' + CRLF
         cOut += 'HRB_FLAGS     = -n -q ' + If( nOption == 2, "-b ", "" ) + CRLF
         cOut += 'HRB_SEARCH    = -i' + DelSlash( cFolder ) + ;
                                ' -i' + cHarbourFolder + 'INCLUDE' + ;
                                ' -i' + cMiniGUIFolder + 'INCLUDE' + CRLF
         cOut += 'RC_COMP       = WINDRES.EXE' + CRLF
         cOut += CRLF
         // Rule for .exe building
         cOut += '$(APP_NAME) : $(OBJECTS)' + CRLF
         cOut += HTAB + '$(LINK_EXE) $(LINK_FLAGS) -o$(APP_NAME) $^ $(LINK_SEARCH) $(LINK_LIBS)' + CRLF
         cOut += CRLF
         // Rule for .c compiling
         For i := 1 To nPrgFiles
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.o : $(OBJ_DIR)\' + aPrgFiles[i] + '.c' + CRLF
            cOut += HTAB + '$(CC_EXE) $(CC_FLAGS) $(CC_SEARCH) -c $^ -o $@' + CRLF
            cOut += HTAB + '@echo #' + CRLF
         cOut += CRLF
         NEXT i
         cOut += CRLF
         // Rule for .prg compiling
         For i := 1 To nPrgFiles
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.c : $(PROJECTFOLDER)\' + aPrgFiles[i] + '.prg' + CRLF
            cOut += HTAB + '$(HRB_EXE) $^ $(HRB_FLAGS) $(HRB_SEARCH) -o$@' + CRLF
            cOut += HTAB + '@echo #' + CRLF
         NEXT i
         cOut += CRLF
         // Rule for .rc compiling
         cOut += '$(OBJ_DIR)\_temp.o : $(PROJECTFOLDER)\_temp.rc' + CRLF
         cOut += HTAB + '$(RC_COMP) -i $^ -o $@' + CRLF
         cOut += HTAB + '@echo #' + CRLF
         HB_MemoWrit( 'Makefile.Gcc', cOut )

         // Build batch to create RC temp file
         cOut := ''
         cOut += '@echo off' + CRLF
         cOut += 'echo #define oohgpath ' + cMiniGUIFolder + 'resources > ' + cFolder + '_oohg_resconfig.h' + CRLF
         cOut += 'copy /b ' + cMiniGUIFolder + 'resources\oohg.rc _temp.rc > NUL' + CRLF
         For i := 1 To Len( aRcFiles )
            IF File( aRcFiles[ i ] )
               cOut += 'copy /b _temp.rc _aux.rc > NUL' + CRLF
               cOut += 'copy /b _aux.rc + ' + aRcFiles[ i ] + ' _temp.rc > NUL' + CRLF
            ENDIF
         NEXT i

         // Build batch to launch make utility
         cOut += cCompFolder + 'BIN\mingw32-make.exe -f makefile.gcc 1 > error.lst 2 > &1 3 > &2' + CRLF
         HB_MemoWrit( '_build.bat', cOut )

         // Create temp folder for objects
         CreateFolder( cFolder + 'OBJ' )

         // Compile and link
         EXECUTE FILE '_build.bat' WAIT HIDE

      Case ::lTBuild == 1 // Compile.bat

         // Check for compile file
         IF ! File( 'compile.bat' ) .AND. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF
         cOut := ''
         For i := 1 To nPrgFiles
            cOut += "# include '" + aPrgFiles[i] + "'" + CRLF + CRLF
         NEXT i
         HB_MemoWrit( cPrgName + '.prg', cOut )

         // Compile and link
         cDosComm := '/c compile ' + cPrgName + ' /nr /l' + If( nOption == 2, " /d", "" )
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE

      EndCase

      // Check for errors
      cError := MemoRead( 'error.lst' )
      cError1 := Upper( cError )
      IF At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ELSEIF ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'OOHG IDE+' )
         Break
      ENDIF

      // Rename or move
      IF ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         IF Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         ENDIF
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         IF ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'OOHG IDE+' )
            Break
         ENDIF
         cExe := cOut
      ENDIF

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      IF nOption == 0
         MsgInfo( 'Project builded.', 'OOHG IDE+' )
      ELSEIF nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      ENDIF
   End Sequence

   CursorArrow()
   ::Form_Tree:button_09:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL

//------------------------------------------------------------------------------
METHOD RunP() CLASS THMI
//------------------------------------------------------------------------------
   LOCAL cExe

   ::Form_Tree:button_09:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.

   cExe := StrTran( AllTrim( DelExt( ::cProjectName ) ), " ", "_" ) + '.exe'
   IF File( cExe )
      EXECUTE FILE cExe
   ELSE
      MsgStop( 'EXE is missing.', 'OOHG IDE+' )
   ENDIF

   ::Form_Tree:button_09:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                   COMPILING WITH MINGW AND XHARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

//------------------------------------------------------------------------------
METHOD xBldMinGW( nOption ) CLASS THMI
//------------------------------------------------------------------------------
   LOCAL aPrgFiles
   LOCAL aRcFiles
   LOCAL cCompFolder := ::cMinGWFolder + '\'
   LOCAL cDosComm
   LOCAL cError
   LOCAL cError1
   LOCAL cExe
   LOCAL cFile
   LOCAL cHarbourFolder := ::cxHbMinGWFolder + '\'
   LOCAL cMiniGuiFolder := ::cGUIxHbMinGW + '\'
   LOCAL cOut
   LOCAL cPrgName
   LOCAL cFolder := ::cProjFolder + '\'
   LOCAL i
   LOCAL nItems
   LOCAL nPrgFiles

   ::Form_Tree:button_09:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      IF Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The MinGW folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-xHb-MinGW folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The xHarbour-MinGW folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      IF File( cExe )
         DELETE FILE ( cExe )
      ENDIF
      IF File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'OOHG IDE+' )
         Break
      ENDIF

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ELSEIF ::SearchType( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .AND. ! cFile == 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build make script
         // Variables
         cOut := ''
         cOut += 'PATH          = ' + cCompFolder + 'BIN' + CRLF
         cOut += 'PROJECTFOLDER = ' + DelSlash( cFolder ) + CRLF
         cOut += 'APP_NAME      = ' + cExe + CRLF
         cOut += 'OBJ_DIR       = ' + cFolder + 'OBJ' + CRLF
         cOut += 'OBJECTS       = '
         For i := 1 To nPrgFiles
            cOut += '\' + CRLF + '$(OBJ_DIR)\' + aPrgFiles[i] + '.o '
         NEXT i
         For i := 1 to Len( aRcFiles )
            cOut += '\' + CRLF + '$(OBJ_DIR)\_temp.o'
         NEXT i
         cOut += CRLF
         cOut += 'LINK_EXE      = GCC.EXE' + CRLF
         cOut += 'LINK_FLAGS    = -Wall -mwindows -O3 -Wl,--allow-multiple-definition' + CRLF
         cOut += 'LINK_SEARCH   = -L' + DelSlash( cFolder ) + ;
                                ' -L' + cCompFolder + 'LIB' + ;
                                ' -L' + cHarbourFolder + If( File( cHarbourFolder + 'LIB\WIN\MINGW\LIBHBRTL.A' ), 'LIB\WIN\MINGW', 'LIB' ) + ;
                                ' -L' + cMiniGUIFolder + If( File( cMiniGUIFolder + 'LIB\XHB\MINGW\LIBOOHG.A' ), 'LIB\XHB\MINGW', 'LIB' ) + CRLF
         cOut += 'LINK_LIBS     = -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui ' + ;
                                  '-lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbzebra -lhbziparc ' + ;
                                  '-lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lrddsql -lsddodbc ' + ;
                                  '-lodbc32 -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 ' + ;
                                  '-lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -lmsimg32 ' + ;
                                  If( nOption == 2, '-lgtwin ', '' ) + ;
                                  If( ! Empty( ::cLib ), ::cLib + ' ', '' ) + ;
                                  '-Wl,--end-group' + CRLF
         cOut += 'CC_EXE        = GCC.EXE' + CRLF
         cOut += 'CC_FLAGS      = -Wall -mwindows -O3' + CRLF
         cOut += 'CC_SEARCH     = -I' + DelSlash( cFolder ) + ;
                                ' -I' + cCompFolder + 'INCLUDE' + ;
                                ' -I' + cHarbourFolder + 'INCLUDE' + ;
                                ' -I' + cMiniGUIFolder + 'INCLUDE' + CRLF
         cOut += 'HRB_EXE       = ' + cHarbourFolder + 'BIN\HARBOUR.EXE' + CRLF
         cOut += 'HRB_FLAGS     = -n -q ' + If( nOption == 2, "-b ", "" ) + CRLF
         cOut += 'HRB_SEARCH    = -i' + DelSlash( cFolder ) + ;
                                ' -i' + cHarbourFolder + 'INCLUDE' + ;
                                ' -i' + cMiniGUIFolder + 'INCLUDE' + CRLF
         cOut += 'RC_COMP       = WINDRES.EXE' + CRLF
         cOut += CRLF
         // Rule for .exe building
         cOut += '$(APP_NAME) : $(OBJECTS)' + CRLF
         cOut += HTAB + '$(LINK_EXE) $(LINK_FLAGS) -o$(APP_NAME) $^ $(LINK_SEARCH) $(LINK_LIBS)' + CRLF
         cOut += CRLF
         // Rule for .c compiling
         For i := 1 To nPrgFiles
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.o : $(OBJ_DIR)\' + aPrgFiles[i] + '.c' + CRLF
            cOut += HTAB + '$(CC_EXE) $(CC_FLAGS) $(CC_SEARCH) -c $^ -o $@' + CRLF
            cOut += HTAB + '@echo #' + CRLF
         cOut += CRLF
         NEXT i
         cOut += CRLF
         // Rule for .prg compiling
         For i := 1 To nPrgFiles
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.c : $(PROJECTFOLDER)\' + aPrgFiles[i] + '.prg' + CRLF
            cOut += HTAB + '$(HRB_EXE) $^ $(HRB_FLAGS) $(HRB_SEARCH) -o$@' + CRLF
            cOut += HTAB + '@echo #' + CRLF
         NEXT i
         cOut += CRLF
         // Rule for .rc compiling
         cOut += '$(OBJ_DIR)\_temp.o : $(PROJECTFOLDER)\_temp.rc' + CRLF
         cOut += HTAB + '$(RC_COMP) -i $^ -o $@' + CRLF
         cOut += HTAB + '@echo #' + CRLF
         HB_MemoWrit( 'Makefile.Gcc', cOut )

         // Build batch to create RC temp file
         cOut := ''
         cOut += '@echo off' + CRLF
         cOut += 'echo #define oohgpath ' + cMiniGUIFolder + 'resources > ' + cFolder + '_oohg_resconfig.h' + CRLF
         cOut += 'copy /b ' + cMiniGUIFolder + 'resources\oohg.rc _temp.rc > NUL' + CRLF
         For i := 1 To Len( aRcFiles )
            IF File( aRcFiles[ i ] )
               cOut += 'copy /b _temp.rc _aux.rc > NUL' + CRLF
               cOut += 'copy /b _aux.rc + ' + aRcFiles[ i ] + ' _temp.rc > NUL' + CRLF
            ENDIF
         NEXT i

         // Build batch to launch make utility
         cOut += cCompFolder + 'BIN\mingw32-make.exe -f makefile.gcc 1 > error.lst 2 > &1 3 > &2' + CRLF
         HB_MemoWrit( '_build.bat', cOut )

         // Create temp folder for objects
         CreateFolder( cFolder + 'OBJ' )

         // Compile and link
         EXECUTE FILE '_build.bat' WAIT HIDE

      Case ::lTBuild == 1 // Compile.bat

         // Check for compile file
         IF ! File( 'compile.bat' ) .AND. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF
         cOut := ''
         For i := 1 To nPrgFiles
            cOut += "# include '" + aPrgFiles[i] + "'" + CRLF + CRLF
         NEXT i
         HB_MemoWrit( cPrgName + '.prg', cOut )

         // Compile and link
         cDosComm := '/c compile ' + cPrgName + ' /nr /l' + If( nOption == 2, " /d", "" )
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE

      EndCase

      // Check for errors
      cError := MemoRead( 'error.lst' )
      cError1 := Upper( cError )
      IF At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ELSEIF ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'OOHG IDE+' )
         Break
      ENDIF

      // Rename or move
      IF ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         IF Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         ENDIF
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         IF ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'OOHG IDE+' )
            Break
         ENDIF
         cExe := cOut
      ENDIF

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      IF nOption == 0
         MsgInfo( 'Project builded.', 'OOHG IDE+' )
      ELSEIF nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      ENDIF
   End Sequence

   CursorArrow()
   ::Form_Tree:button_09:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                 COMPILING WITH BORLAND C AND HARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

//------------------------------------------------------------------------------
METHOD BuildBCC( nOption ) CLASS THMI
//------------------------------------------------------------------------------
   LOCAL aPrgFiles
   LOCAL aRcFiles
   LOCAL cCompFolder := ::cBCCFolder + '\'
   LOCAL cDosComm
   LOCAL cError
   LOCAL cError1
   LOCAL cExe
   LOCAL cFile
   LOCAL cHarbourFolder := ::cHbBCCFolder + '\'
   LOCAL cMiniGuiFolder := ::cGuiHbBCC + '\'
   LOCAL cOut
   LOCAL cPrgName
   LOCAL cFolder := ::cProjFolder + '\'
   LOCAL i
   LOCAL nItems
   LOCAL nPrgFiles

   ::Form_Tree:button_09:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      IF Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The BCC folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-Hb-BCC folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Harbour-Borland C folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      IF File( cExe )
         DELETE FILE ( cExe )
      ENDIF
      IF File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'OOHG IDE+' )
         Break
      ENDIF

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ELSEIF ::SearchType( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .AND. ! cFile == 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build make script
         // Variables
         cOut := ''
         cOut += 'PROJECTFOLDER = ' + DelSlash( cFolder ) + CRLF
         cOut += 'APP_NAME      = ' + cExe + CRLF
         cOut += 'OBJ_DIR       = ' + cFolder + 'OBJ' + CRLF
         cOut += 'OBJECTS       = '
         For i := 1 To nPrgFiles
            cOut += '\' + CRLF + '$(OBJ_DIR)\' + aPrgFiles[i] + '.obj '
         NEXT i
         cOut += CRLF
         cOut += 'RESFILES      = '
         For i := 1 to Len( aRcFiles )
            cOut += '\' + CRLF + '$(OBJ_DIR)\' + aRcFiles[i] + '.res '
         NEXT i
         cOut += '\' + CRLF + cMiniGUIFolder + 'RESOURCES\oohg.res' + CRLF
         cOut += 'LINK_EXE      = ' + cCompFolder + 'BIN\ILINK32.EXE' + CRLF
         cOut += 'LINK_FLAGS    = -Gn -Tpe -x' + If( nOption == 2, "-ap", "-aa" ) + CRLF
         cOut += 'LINK_SEARCH   = -L' + DelSlash( cFolder ) + ;
                                ' -L' + cCompFolder + 'LIB' + ;
                                ' -L' + cHarbourFolder + If( File( cHarbourFolder + 'LIB\WIN\BCC\rtl.lib' ), 'LIB\WIN\BCC', 'LIB' ) + ;
                                ' -L' + cMiniGUIFolder + If( File( cMiniGUIFolder + 'LIB\HB\BCC\oohg.lib' ), 'LIB\HB\BCC', 'LIB' ) + CRLF
         cOut += 'LINK_LIBS     = '
         IF File( cMiniGuiFolder + 'LIB\HB\BCC\oohg.lib' )
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\HB\BCC\oohg.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\HB\BCC\hbprinter.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\HB\BCC\miniprint.lib'
         ELSE
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\oohg.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\hbprinter.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\miniprint.lib'
         ENDIF
         IF nOption == 2
            cOut += '\' + CRLF + cHarbourFolder + 'LIB\gtwin.lib'
         ENDIF
         cOut += '\' + CRLF + cHarbourFolder + 'LIB\gtgui.lib'
         For Each i In { "ace32.lib", ;
                         "codepage.lib", ;
                         "common.lib", ;
                         "ct.lib", ;
                         "dbfcdx.lib", ;
                         "dbfdbt.lib", ;
                         "dbffpt.lib", ;
                         "dbfntx.lib", ;
                         "debug.lib", ;
                         "dll.lib", ;
                         "hbcommon.lib", ;
                         "hbcpage.lib", ;
                         "hbct.lib", ;
                         "hbdebug.lib", ;
                         "hbhsx.lib", ;
                         "hblang.lib", ;
                         "hbmacro.lib", ;
                         "hboleaut.lib", ;
                         "hbpp.lib", ;
                         "hbrdd.lib", ;
                         "hbrtl.lib", ;
                         "hbsix.lib", ;
                         "hbvm.lib", ;
                         "hbwin.lib", ;
                         "hsx.lib", ;
                         "lang.lib", ;
                         "libmisc.lib", ;
                         "libmysqldll.lib", ;
                         "macro.lib", ;
                         "mysql.lib", ;
                         "odbc32.lib", ;
                         "pcrepos.lib", ;
                         "pp.lib", ;
                         "rdd.lib", ;
                         "rddads.lib", ;
                         "rddcdx.lib", ;
                         "rddfpt.lib", ;
                         "rddntx.lib", ;
                         "rtl.lib", ;
                         "tip.lib", ;
                         "vm.lib", ;
                         "xhb.lib", ;
                         "ziparchive.lib", ;
                         "zlib1.lib" }
            IF File( cHarbourFolder + 'LIB\' + i )
               cOut += '\' + CRLF + cHarbourFolder + 'LIB\' + i
            ENDIF
         NEXT
         IF ! Empty( ::cLib )
            cOut += '\' + CRLF + ::cLib
         ENDIF
         cOut += CRLF
         cOut += 'CC_EXE        = ' + cCompFolder + 'BIN\BCC32.EXE' + CRLF
         cOut += 'CC_FLAGS      = -c -O2 -tW -M' + CRLF
         cOut += 'CC_SEARCH     = -I' + DelSlash( cFolder ) + ';' + ;
                                        cCompFolder + 'INCLUDE;' + ;
                                        cHarbourFolder + 'INCLUDE;' + ;
                                        cMiniGUIFolder + 'INCLUDE;' + ;
                                 '-L' + cCompFolder + 'LIB;' + cCompFolder + 'LIB\PSDK;' + CRLF
         cOut += 'HRB_EXE       = ' + cHarbourFolder + 'BIN\HARBOUR.EXE' + CRLF
         cOut += 'HRB_FLAGS     = -n -q ' + If( nOption == 2, "-b ", "" ) + CRLF
         cOut += 'HRB_SEARCH    = -i' + DelSlash( cFolder ) + ;
                                ' -i' + cHarbourFolder + 'INCLUDE' + ;
                                ' -i' + cMiniGUIFolder + 'INCLUDE' + CRLF
         cOut += 'RC_COMP       = ' + cCompFolder + 'BIN\BRC32.EXE' + CRLF
         cOut += CRLF
         // Rule for .exe building
         cOut += '$(APP_NAME) : $(OBJECTS) $(RESFILES)' + CRLF
         cOut += HTAB + '$(LINK_EXE) $(LINK_SEARCH) $(LINK_FLAGS) c0w32.obj $(OBJECTS),$(APP_NAME),,$(LINK_LIBS) cw32.lib import32.lib msimg32.lib,,$(RESFILES)' + CRLF
         cOut += HTAB + '@echo.' + CRLF
         cOut += CRLF
         // Rule for .c compiling
         For i := 1 To nPrgFiles
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.obj : $(OBJ_DIR)\' + aPrgFiles[i] + '.c' + CRLF
            cOut += HTAB + '$(CC_EXE) $(CC_FLAGS) $(CC_SEARCH) -o$@ $**' + CRLF
            cOut += HTAB + '@echo.' + CRLF
            cOut += CRLF
         NEXT i
         // Rule for .prg compiling
         For i := 1 To nPrgFiles
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.c : $(PROJECTFOLDER)\' + aPrgFiles[i] + '.prg' + CRLF
            cOut += HTAB + '$(HRB_EXE) $(HRB_FLAGS) $(HRB_SEARCH) $** -o$@' + CRLF
            cOut += HTAB + '@echo.' + CRLF
            cOut += CRLF
         NEXT i
         // Rule for .rc compiling
         For i := 1 to Len( aRcFiles )
            cOut += '$(OBJ_DIR)\' + aRcFiles[i] + '.res : $(PROJECTFOLDER)\' + aRcFiles[i] + '.rc' + CRLF
            cOut += HTAB + '$(RC_COMP) -r -fo$@ $**' + CRLF
            cOut += HTAB + '@echo.' + CRLF
         NEXT i
         cOut += cMiniGUIFolder + 'RESOURCES\oohg.res : ' + cMiniGUIFolder + 'RESOURCES\oohg_bcc.rc' + CRLF
         cOut += HTAB + '$(RC_COMP) -r -fo$@ $**' + CRLF
         cOut += HTAB + '@echo.' + CRLF
         // Write make script
         HB_MemoWrit( '_temp.bc', cOut )

         // Build batch to launch make utility
         cOut := ''
         cOut += '@echo off' + CRLF
         cOut += cCompFolder + 'BIN\MAKE.EXE /f' + cFolder + '_temp.bc > ' + cFolder + 'error.lst' + CRLF
         HB_MemoWrit( '_build.bat', cOut )

         // Create temp folder for objects
         CreateFolder( cFolder + 'OBJ' )

         // Compile and link
         EXECUTE FILE '_build.bat' WAIT HIDE

      Case ::lTBuild == 1 // Compile.bat

         // Check for compile file
         IF ! File( 'compile.bat' ) .AND. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF
         cOut := ''
         For i := 1 To nPrgFiles
            cOut += "# include '" + aPrgFiles[i] + "'" + CRLF + CRLF
         NEXT i
         HB_MemoWrit( cPrgName + '.prg', cOut )

         // Compile and link
         cDosComm := '/c compile ' + cPrgName + ' /nr /l' + If( nOption == 2, " /d", "" )
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE

      EndCase

      // Check for errors
      cError := MemoRead( 'error.lst' )
      cError1 := Upper( cError )
      IF At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ELSEIF ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'OOHG IDE+' )
         Break
      ENDIF

      // Rename or move
      IF ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         IF Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         ENDIF
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         IF ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'OOHG IDE+' )
            Break
         ENDIF
         cExe := cOut
      ENDIF

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      IF nOption == 0
         MsgInfo( 'Project builded.', 'OOHG IDE+' )
      ELSEIF nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      ENDIF
   End Sequence

   CursorArrow()
   ::Form_Tree:button_09:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                  COMPILING CON BORLAND C Y XHARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

//------------------------------------------------------------------------------
METHOD xBuildBCC( nOption ) CLASS THMI
//------------------------------------------------------------------------------
   LOCAL aPrgFiles
   LOCAL aRcFiles
   LOCAL cCompFolder := ::cBCCFolder + '\'
   LOCAL cDosComm
   LOCAL cError
   LOCAL cError1
   LOCAL cExe
   LOCAL cFile
   LOCAL cHarbourFolder := ::cxHbBCCFolder + '\'
   LOCAL cMiniGuiFolder := ::cGuixHbBCC + '\'
   LOCAL cOut
   LOCAL cPrgName
   LOCAL cFolder := ::cProjFolder + '\'
   LOCAL i
   LOCAL nItems
   LOCAL nPrgFiles

   ::Form_Tree:button_09:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      IF Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The BCC folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-xHb-BCC folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The xHarbour-Borland C folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      IF File( cExe )
         DELETE FILE ( cExe )
      ENDIF
      IF File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'OOHG IDE+' )
         Break
      ENDIF

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ELSEIF ::SearchType( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .AND. ! cFile == 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build make script
         // Variables
         cOut := ''
         cOut += 'PROJECTFOLDER = ' + DelSlash( cFolder ) + CRLF
         cOut += 'APP_NAME      = ' + cExe + CRLF
         cOut += 'TDS_NAME      = ' + cPrgName + '.tds' + CRLF
         cOut += 'OBJ_DIR       = ' + cFolder + 'OBJ' + CRLF
         cOut += 'OBJECTS       = '
         For i := 1 To nPrgFiles
            cOut += '\' + CRLF + '$(OBJ_DIR)\' + aPrgFiles[i] + '.obj '
         NEXT i
         cOut += CRLF
         cOut += 'RESFILES      = '
         For i := 1 to Len( aRcFiles )
            cOut += '\' + CRLF + '$(OBJ_DIR)\' + aRcFiles[i] + '.res '
         NEXT i
         cOut += '\' + CRLF + cMiniGUIFolder + 'RESOURCES\oohg.res' + CRLF
         cOut += 'LINK_EXE      = ' + cCompFolder + 'BIN\ILINK32.EXE' + CRLF
         cOut += 'LINK_FLAGS    = -Gn -Tpe -x ' + If( nOption == 2, "-ap", "-aa" ) + CRLF
         cOut += 'LINK_SEARCH   = -L' + DelSlash( cFolder ) + ;
                                ' -L' + cCompFolder + 'LIB' + ;
                                ' -L' + cHarbourFolder + If( File( cHarbourFolder + 'LIB\WIN\BCC\rtl.lib' ), 'LIB\WIN\BCC', 'LIB' ) + ;
                                ' -L' + cMiniGUIFolder + If( File( cMiniGUIFolder + 'LIB\XHB\BCC\oohg.lib' ), 'LIB\XHB\BCC', 'LIB' ) + CRLF
         cOut += 'LINK_LIBS     = '
         IF File( cMiniGuiFolder + 'LIB\XHB\BCC\oohg.lib' )
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\XHB\BCC\oohg.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\XHB\BCC\hbprinter.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\XHB\BCC\miniprint.lib'
         ELSE
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\oohg.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\hbprinter.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\miniprint.lib'
         ENDIF
         IF nOption == 2
            cOut += '\' + CRLF + cHarbourFolder + 'LIB\gtwin.lib'
         ENDIF
         cOut += '\' + CRLF + cHarbourFolder + 'LIB\gtgui.lib'
         For Each i In { "ace32.lib", ;
                         "codepage.lib", ;
                         "common.lib", ;
                         "ct.lib", ;
                         "dbfcdx.lib", ;
                         "dbfdbt.lib", ;
                         "dbffpt.lib", ;
                         "dbfntx.lib", ;
                         "debug.lib", ;
                         "dll.lib", ;
                         "hbcommon.lib", ;
                         "hbcpage.lib", ;
                         "hbct.lib", ;
                         "hbdebug.lib", ;
                         "hbhsx.lib", ;
                         "hblang.lib", ;
                         "hbmacro.lib", ;
                         "hboleaut.lib", ;
                         "hbpp.lib", ;
                         "hbrdd.lib", ;
                         "hbrtl.lib", ;
                         "hbsix.lib", ;
                         "hbvm.lib", ;
                         "hbwin.lib", ;
                         "hsx.lib", ;
                         "lang.lib", ;
                         "libmisc.lib", ;
                         "libmysqldll.lib", ;
                         "macro.lib", ;
                         "mysql.lib", ;
                         "odbc32.lib", ;
                         "pcrepos.lib", ;
                         "pp.lib", ;
                         "rdd.lib", ;
                         "rddads.lib", ;
                         "rddcdx.lib", ;
                         "rddfpt.lib", ;
                         "rddntx.lib", ;
                         "rtl.lib", ;
                         "tip.lib", ;
                         "vm.lib", ;
                         "xhb.lib", ;
                         "ziparchive.lib", ;
                         "zlib1.lib" }
            IF File( cHarbourFolder + 'LIB\' + i )
               cOut += '\' + CRLF + cHarbourFolder + 'LIB\' + i
            ENDIF
         NEXT
         IF ! Empty( ::cLib )
            cOut += '\' + CRLF + ::cLib
         ENDIF
         cOut += CRLF
         cOut += 'CC_EXE        = ' + cCompFolder + 'BIN\BCC32.EXE' + CRLF
         cOut += 'CC_FLAGS      = -c -O2 -tW -M' + CRLF
         cOut += 'CC_SEARCH     = -I' + DelSlash( cFolder ) + ';' + ;
                                        cCompFolder + 'INCLUDE;' + ;
                                        cHarbourFolder + 'INCLUDE;' + ;
                                        cMiniGUIFolder + 'INCLUDE;' + ;
                                 '-L' + cCompFolder + 'LIB;' + cCompFolder + 'LIB\PSDK;' + CRLF
         cOut += 'HRB_EXE       = ' + cHarbourFolder + 'BIN\HARBOUR.EXE' + CRLF
         cOut += 'HRB_FLAGS     = -n -q ' + If( nOption == 2, "-b ", "" ) + CRLF
         cOut += 'HRB_SEARCH    = -i' + DelSlash( cFolder ) + ;
                                ' -i' + cHarbourFolder + 'INCLUDE' + ;
                                ' -i' + cMiniGUIFolder + 'INCLUDE' + CRLF
         cOut += 'RC_COMP       = ' + cCompFolder + 'BIN\BRC32.EXE' + CRLF
         cOut += CRLF
         // Rule for .exe building
         cOut += '$(APP_NAME) : $(OBJECTS) $(RESFILES)' + CRLF
         cOut += HTAB + '$(LINK_EXE) $(LINK_SEARCH) $(LINK_FLAGS) c0w32.obj $(OBJECTS),$(APP_NAME),,$(LINK_LIBS) cw32.lib import32.lib msimg32.lib,,$(RESFILES)' + CRLF
         cOut += HTAB + '@del $(TDS_NAME)' + CRLF
         cOut += HTAB + '@echo.' + CRLF
         cOut += CRLF
         // Rule for .c compiling
         For i := 1 To nPrgFiles
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.obj : $(OBJ_DIR)\' + aPrgFiles[i] + '.c' + CRLF
            cOut += HTAB + '$(CC_EXE) $(CC_FLAGS) $(CC_SEARCH) -o$@ $**' + CRLF
            cOut += HTAB + '@echo.' + CRLF
            cOut += CRLF
         NEXT i
         // Rule for .prg compiling
         For i := 1 To nPrgFiles
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.c : $(PROJECTFOLDER)\' + aPrgFiles[i] + '.prg' + CRLF
            cOut += HTAB + '$(HRB_EXE) $(HRB_FLAGS) $(HRB_SEARCH) $** -o$@' + CRLF
            cOut += HTAB + '@echo.' + CRLF
            cOut += CRLF
         NEXT i
         // Rule for .rc compiling
         For i := 1 to Len( aRcFiles )
            cOut += '$(OBJ_DIR)\' + aRcFiles[i] + '.res : $(PROJECTFOLDER)\' + aRcFiles[i] + '.rc' + CRLF
            cOut += HTAB + '$(RC_COMP) -r -fo$@ $**' + CRLF
            cOut += HTAB + '@echo.' + CRLF
         NEXT i
         cOut += cMiniGUIFolder + 'RESOURCES\oohg.res : ' + cMiniGUIFolder + 'RESOURCES\oohg_bcc.rc' + CRLF
         cOut += HTAB + '$(RC_COMP) -r -fo$@ $**' + CRLF
         cOut += HTAB + '@echo.' + CRLF
         // Write make script
         HB_MemoWrit( '_temp.bc', cOut )

         // Build batch to launch make utility
         cOut := ''
         cOut += '@echo off' + CRLF
         cOut += cCompFolder + 'BIN\MAKE.EXE /f' + cFolder + '_temp.bc > ' + cFolder + 'error.lst' + CRLF
         HB_MemoWrit( '_build.bat', cOut )

         // Create temp folder for objects
         CreateFolder( cFolder + 'OBJ' )

         // Compile and link
         EXECUTE FILE '_build.bat' WAIT HIDE

      Case ::lTBuild == 1 // Compile.bat

         // Check for compile file
         IF ! File( 'compile.bat' ) .AND. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF
         cOut := ''
         For i := 1 To nPrgFiles
            cOut += "# include '" + aPrgFiles[i] + "'" + CRLF + CRLF
         NEXT i
         HB_MemoWrit( cPrgName + '.prg', cOut )

         // Compile and link
         cDosComm := '/c compile ' + cPrgName + ' /nr /l' + If( nOption == 2, " /d", "" )
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE

      EndCase

      // Check for errors
      cError := MemoRead( 'error.lst' )
      cError1 := Upper( cError )
      IF At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ELSEIF ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'OOHG IDE+' )
         Break
      ENDIF

      // Rename or move
      IF ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         IF Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         ENDIF
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         IF ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'OOHG IDE+' )
            Break
         ENDIF
         cExe := cOut
      ENDIF

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      IF nOption == 0
         MsgInfo( 'Project builded.', 'OOHG IDE+' )
      ELSEIF nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      ENDIF
   End Sequence

   CursorArrow()
   ::Form_Tree:button_09:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                 COMPILING WITH PELLES C AND XHARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

//------------------------------------------------------------------------------
METHOD XBldPellC( nOption ) CLASS THMI
//------------------------------------------------------------------------------
   LOCAL aPrgFiles
   LOCAL aRcFiles
   LOCAL cCompFolder := ::cPellFolder + '\'
   LOCAL cDosComm
   LOCAL cError
   LOCAL cError1
   LOCAL cExe
   LOCAL cFile
   LOCAL cHarbourFolder := ::cxHbPellFolder + '\'
   LOCAL cMiniGuiFolder := ::cGuixHbPelles + '\'
   LOCAL cOut
   LOCAL cPrgName
   LOCAL cFolder := ::cProjFolder + '\'
   LOCAL i
   LOCAL nItems
   LOCAL nPrgFiles

   ::Form_Tree:button_09:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      IF Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Pelles C folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-xHb-Pelles C folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The xHarbour-Pelles C folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      IF File( cExe )
         DELETE FILE ( cExe )
      ENDIF
      IF File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'OOHG IDE+' )
         Break
      ENDIF

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ELSEIF ::SearchType( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .AND. ! cFile == 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build make script
         cOut := ''
         cOut += 'HARBOUR_EXE = ' + cHarbourFolder + 'BIN\HARBOUR.EXE' + CRLF
         cOut += 'CC = ' + cCompFolder + 'BIN\POCC.EXE' + CRLF
         cOut += 'ILINK_EXE = ' + cCompFolder + 'BIN\POLINK.EXE' + CRLF
         cOut += 'BRC_EXE = ' + cCompFolder + 'BIN\PORC.EXE' + CRLF
         cOut += 'APP_NAME = ' + cExe + CRLF
         cOut += 'INCLUDE_DIR = ' + cHarbourFolder + 'INCLUDE;' + cMiniGuiFolder + 'INCLUDE;' + DelSlash( cFolder ) + CRLF
         cOut += 'INCLUDE_C_DIR = ' + cHarbourFolder + 'INCLUDE -I' + cMiniGuiFolder + 'INCLUDE -I' + DelSlash( cFolder ) + ' -I' + cCompFolder + 'INCLUDE -I' + cCompFolder + 'INCLUDE\WIN' + CRLF
         cOut += 'CC_LIB_DIR = ' + cCompFolder + 'LIB' + CRLF
         cOut += 'HRB_LIB_DIR = ' + cHarbourFolder + 'LIB' + CRLF
         cOut += 'OBJ_DIR = ' + cFolder + 'OBJ' + CRLF
         cOut += 'C_DIR = ' + cFolder + 'OBJ' + CRLF
         cOut += 'USER_FLAGS =' + CRLF
         cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n /q0 ' + If( nOption == 2, "/b ", "" ) + '$(USER_FLAGS)' + CRLF
         cOut += 'COBJFLAGS = /Ze /Zx /Go /Tx86-coff /D__WIN32__ ' + '-I$(INCLUDE_C_DIR)' + CRLF
         cOut += CRLF
         cOut += '$(APP_NAME) : $(OBJ_DIR)\' + aPrgFiles[1] + '.obj'
         For i := 2 To nPrgFiles
            cOut += ' \' + CRLF
            cOut += '   $(OBJ_DIR)\' + aPrgFiles[i] + '.obj'
         NEXT i
         cOut += CRLF
         For i := 1 to Len( aRcFiles )
            cOut += '   $(BRC_EXE) /fo' + aRcFiles[i] + '.res ' + aRcFiles[i] + '.rc' + CRLF
         NEXT i
         For i := 1 To nPrgFiles
            cOut += '   echo $(OBJ_DIR)\' + aPrgFiles[i] + '.obj + >' + If( i > 1, '>', '' ) + ' b32.bc' + CRLF
         NEXT i
         cOut += '   echo /OUT:$(APP_NAME) >> b32.bc' + CRLF
         cOut += '   echo /FORCE:MULTIPLE >> b32.bc' + CRLF
         cOut += '   echo /LIBPATH:$(CC_LIB_DIR) >> b32.bc' + CRLF
         cOut += '   echo /LIBPATH:$(CC_LIB_DIR)\WIN >> b32.bc' + CRLF
         IF File( cMiniGuiFolder + 'LIB\XHB\PCC\oohg.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\XHB\BCC\oohg.lib >> b32.bc' + CRLF
         ELSE
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\oohg.lib >> b32.bc' + CRLF
         ENDIF
         IF File( cMiniGuiFolder + 'LIB\XHB\PCC\hbprinter.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\XHB\BCC\hbprinter.lib >> b32.bc' + CRLF
         ELSE
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\hbprinter.lib >> b32.bc' + CRLF
         ENDIF
         IF File( cMiniGuiFolder + 'LIB\XHB\PCC\miniprint.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\XHB\BCC\miniprint.lib >> b32.bc' + CRLF
         ELSE
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\miniprint.lib >> b32.bc' + CRLF
         ENDIF
         IF nOption == 2
            cOut += '   echo $(HRB_LIB_DIR)\gtwin.lib >> b32.bc' + CRLF
         ENDIF
         cOut += '   echo $(HRB_LIB_DIR)\gtgui.lib >> b32.bc' + CRLF
         For Each i In { "ace32.lib", ;
                         "codepage.lib", ;
                         "common.lib", ;
                         "ct.lib", ;
                         "dbfcdx.lib", ;
                         "dbfdbt.lib", ;
                         "dbffpt.lib", ;
                         "dbfntx.lib", ;
                         "debug.lib", ;
                         "dll.lib", ;
                         "hbcommon.lib", ;
                         "hbcpage.lib", ;
                         "hbct.lib", ;
                         "hbdebug.lib", ;
                         "hbhsx.lib", ;
                         "hblang.lib", ;
                         "hbmacro.lib", ;
                         "hboleaut.lib", ;
                         "hbpp.lib", ;
                         "hbrdd.lib", ;
                         "hbrtl.lib", ;
                         "hbsix.lib", ;
                         "hbvm.lib", ;
                         "hbwin.lib", ;
                         "hsx.lib", ;
                         "lang.lib", ;
                         "libmisc.lib", ;
                         "libmysqldll.lib", ;
                         "macro.lib", ;
                         "mysql.lib", ;
                         "odbc32.lib", ;
                         "pcrepos.lib", ;
                         "pp.lib", ;
                         "rdd.lib", ;
                         "rddads.lib", ;
                         "rddcdx.lib", ;
                         "rddfpt.lib", ;
                         "rddntx.lib", ;
                         "rtl.lib", ;
                         "tip.lib", ;
                         "vm.lib", ;
                         "xhb.lib", ;
                         "ziparchive.lib", ;
                         "zlib1.lib" }
            IF File( cHarbourFolder + 'LIB\' + i )
               cOut += '   echo $(HRB_LIB_DIR)\' + i + ' >> b32.bc' + CRLF
            ENDIF
         NEXT
         cOut += '   echo $(CC_LIB_DIR)\crt.lib >> b32.bc' + CRLF
         For Each i In { "kernel32.lib", ;
                         "winspool.lib", ;
                         "user32.lib", ;
                         "advapi32.lib", ;
                         "ole32.lib", ;
                         "uuid.lib", ;
                         "oleaut32.lib", ;
                         "mpr.lib", ;
                         "comdlg32.lib", ;
                         "comctl32.lib", ;
                         "gdi32.lib", ;
                         "olepro32.lib", ;
                         "shell32.lib", ;
                         "winmm.lib", ;
                         "vfw32.lib", ;
                         "wsock32.lib" }
            IF File( cHarbourFolder + 'LIB\' + i )
               cOut += '   echo ' + i + ' >> b32.bc' + CRLF
            ENDIF
         NEXT
         For i := 1 to Len( aRcFiles )
            cOut += '   echo ' + aRcFiles[i] + '.res >> b32.bc' + CRLF
         NEXT i
         cOut += '   echo ' + cMiniGUIFolder + 'resources\oohg.res >> b32.bc' + CRLF
         cOut += '   $(ILINK_EXE)  /SUBSYSTEM:' + If( nOption == 2, "CONSOLE", "WINDOWS" ) + ' @b32.bc' + CRLF
         cOut += CRLF
         For i := 1 To nPrgFiles
            cOut += CRLF
            cOut += '$(C_DIR)\' + aPrgFiles[i] + '.c : ' + cFolder + aPrgFiles[i] + '.prg' + CRLF
            cOut += '   $(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + CRLF
            cOut += CRLF
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.obj : $(C_DIR)\' + aPrgFiles[i] + '.c' + CRLF
            cOut += '   $(CC) $(COBJFLAGS) -Fo$@ $**' + CRLF
         NEXT i
         HB_MemoWrit( '_temp.bc', cOut )

         // Build batch
         cOut := ''
         cOut += '@echo off' + CRLF
         cOut += cCompFolder + 'BIN\POMAKE.EXE /F' + cFolder + '_temp.bc > ' + cFolder + 'error.lst' + CRLF
         HB_MemoWrit( '_build.bat', cOut )

         // Create folder for objects
         CreateFolder( cFolder + 'OBJ' )

         // Build
         EXECUTE FILE '_build.bat' WAIT HIDE

   CASE ::lTBuild == 1 // Compile.bat

         // Check for compile file
         IF ! File( 'compile.bat' ) .AND. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF
         cOut := ''
         For i := 1 To nPrgFiles
            cOut += "# include '" + aPrgFiles[i] + "'" + CRLF + CRLF
         NEXT i
         HB_MemoWrit( cPrgName + '.prg', cOut )

         // Compile and link
         cDosComm := '/c compile ' + cPrgName + ' /nr /l' + If( nOption == 2, " /d", "" )
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE

      EndCase

      // Check for errors
      cError := MemoRead( 'error.lst' )
      cError1 := Upper( cError )
      IF At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ELSEIF ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'OOHG IDE+' )
         Break
      ENDIF

      // Rename or move
      IF ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         IF Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         ENDIF
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         IF ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'OOHG IDE+' )
            Break
         ENDIF
         cExe := cOut
      ENDIF

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      IF nOption == 0
         MsgInfo( 'Project builded.', 'OOHG IDE+' )
      ELSEIF nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      ENDIF
   End Sequence

   CursorArrow()
   ::Form_Tree:button_09:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL


*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                 COMPILING WITH PELLES C AND HARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

//------------------------------------------------------------------------------
METHOD BldPellC(nOption) CLASS THMI
//------------------------------------------------------------------------------
   LOCAL aPrgFiles
   LOCAL aRcFiles
   LOCAL cCompFolder := ::cPellFolder + '\'
   LOCAL cDosComm
   LOCAL cError
   LOCAL cError1
   LOCAL cExe
   LOCAL cFile
   LOCAL cHarbourFolder := ::cHbPellFolder + '\'
   LOCAL cMiniGuiFolder := ::cGuiHbPelles + '\'
   LOCAL cOut
   LOCAL cPrgName
   LOCAL cFolder := ::cProjFolder + '\'
   LOCAL i
   LOCAL nItems
   LOCAL nPrgFiles

   ::Form_Tree:button_09:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      IF Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Pelles C folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-Hb-Pelles C folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      IF Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Harbour-Pelles C folder must be specified to build a project.', 'OOHG IDE+' )
         Break
      ENDIF

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      IF File( cExe )
         DELETE FILE ( cExe )
      ENDIF
      IF File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'OOHG IDE+' )
         Break
      ENDIF

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ELSEIF ::SearchType( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .AND. ! cFile == 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               IF aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build make script
         cOut := ''
         cOut += 'HARBOUR_EXE = ' + cHarbourFolder + 'BIN\HARBOUR.EXE' + CRLF
         cOut += 'CC = ' + cCompFolder + 'BIN\POCC.EXE' + CRLF
         cOut += 'ILINK_EXE = ' + cCompFolder + 'BIN\POLINK.EXE' + CRLF
         cOut += 'BRC_EXE = ' + cCompFolder + 'BIN\PORC.EXE' + CRLF
         cOut += 'APP_NAME = ' + cExe + CRLF
         cOut += 'INCLUDE_DIR = ' + cHarbourFolder + 'INCLUDE;' + cMiniGuiFolder + 'INCLUDE;' + DelSlash( cFolder ) + CRLF
         cOut += 'INCLUDE_C_DIR = ' + cHarbourFolder + 'INCLUDE -I' + cMiniGuiFolder + 'INCLUDE -I' + DelSlash( cFolder ) + ' -I' + cCompFolder + 'INCLUDE -I' + cCompFolder + 'INCLUDE\WIN' + CRLF
         cOut += 'CC_LIB_DIR = ' + cCompFolder + 'LIB' + CRLF
         cOut += 'HRB_LIB_DIR = ' + cHarbourFolder + If( File( cHarbourFolder + 'LIB\hbwin.lib' ), 'LIB', 'LIB\WIN\POCC' ) + CRLF
         cOut += 'OBJ_DIR = ' + cFolder + 'OBJ' + CRLF
         cOut += 'C_DIR = ' + cFolder + 'OBJ' + CRLF
         cOut += 'USER_FLAGS =' + CRLF
         cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n /q0 ' + If( nOption == 2, "/b ", "" ) + '$(USER_FLAGS)' + CRLF
         cOut += 'COBJFLAGS = /Ze /Zx /Go /Tx86-coff /D__WIN32__ ' + '-I$(INCLUDE_C_DIR)' + CRLF
         cOut += CRLF
         cOut += '$(APP_NAME) : $(OBJ_DIR)\' + aPrgFiles[1] + '.obj'
         For i := 2 To nPrgFiles
            cOut += ' \' + CRLF
            cOut += '   $(OBJ_DIR)\' + aPrgFiles[i] + '.obj'
         NEXT i
         cOut += CRLF
         For i := 1 to Len( aRcFiles )
            cOut += '   $(BRC_EXE) /fo' + aRcFiles[i] + '.res ' + aRcFiles[i] + '.rc' + CRLF
         NEXT i
         For i := 1 To nPrgFiles
            cOut += '   echo $(OBJ_DIR)\' + aPrgFiles[i] + '.obj + >' + If( i > 1, '>', '' ) + ' b32.bc' + CRLF
         NEXT i
         cOut += '   echo /OUT:$(APP_NAME) >> b32.bc' + CRLF
         cOut += '   echo /FORCE:MULTIPLE >> b32.bc' + CRLF
         cOut += '   echo /LIBPATH:$(CC_LIB_DIR) >> b32.bc' + CRLF
         cOut += '   echo /LIBPATH:$(CC_LIB_DIR)\WIN >> b32.bc' + CRLF
         IF File( cMiniGuiFolder + 'LIB\HB\PCC\oohg.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\HB\BCC\oohg.lib >> b32.bc' + CRLF
         ELSE
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\oohg.lib >> b32.bc' + CRLF
         ENDIF
         IF File( cMiniGuiFolder + 'LIB\HB\PCC\hbprinter.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\HB\BCC\hbprinter.lib >> b32.bc' + CRLF
         ELSE
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\hbprinter.lib >> b32.bc' + CRLF
         ENDIF
         IF File( cMiniGuiFolder + 'LIB\HB\PCC\miniprint.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\HB\BCC\miniprint.lib >> b32.bc' + CRLF
         ELSE
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\miniprint.lib >> b32.bc' + CRLF
         ENDIF
         IF nOption == 2
            cOut += '   echo $(HRB_LIB_DIR)\gtwin.lib >> b32.bc' + CRLF
         ENDIF
         cOut += '   echo $(HRB_LIB_DIR)\gtgui.lib >> b32.bc' + CRLF
         For Each i In { "ace32.lib", ;
                         "codepage.lib", ;
                         "common.lib", ;
                         "ct.lib", ;
                         "dbfcdx.lib", ;
                         "dbfdbt.lib", ;
                         "dbffpt.lib", ;
                         "dbfntx.lib", ;
                         "debug.lib", ;
                         "dll.lib", ;
                         "hbcommon.lib", ;
                         "hbcpage.lib", ;
                         "hbct.lib", ;
                         "hbdebug.lib", ;
                         "hbhsx.lib", ;
                         "hblang.lib", ;
                         "hbmacro.lib", ;
                         "hbmisc.lib", ;
                         "hbmzip.lib", ;
                         "hboleaut.lib", ;
                         "hbpcre.lib", ;
                         "hbpp.lib", ;
                         "hbrdd.lib", ;
                         "hbrtl.lib", ;
                         "hbsix.lib", ;
                         "hbtip.lib", ;
                         "hbvm.lib", ;
                         "hbwin.lib", ;
                         "hbzlib.lib", ;
                         "hsx.lib", ;
                         "lang.lib", ;
                         "libmisc.lib", ;
                         "libmysqldll.lib", ;
                         "macro.lib", ;
                         "minizip.lib", ;
                         "mysql.lib", ;
                         "odbc32.lib", ;
                         "pcrepos.lib", ;
                         "pp.lib", ;
                         "rdd.lib", ;
                         "rddads.lib", ;
                         "rddcdx.lib", ;
                         "rddfpt.lib", ;
                         "rddntx.lib", ;
                         "rtl.lib", ;
                         "tip.lib", ;
                         "vm.lib", ;
                         "xhb.lib", ;
                         "ziparchive.lib", ;
                         "zlib1.lib" }
            IF File( cHarbourFolder + 'LIB\' + i )
               cOut += '   echo $(HRB_LIB_DIR)\' + i + ' >> b32.bc' + CRLF
            ENDIF
         NEXT
         cOut += '   echo $(CC_LIB_DIR)\crt.lib >> b32.bc' + CRLF
         For Each i In { "kernel32.lib", ;
                         "winspool.lib", ;
                         "user32.lib", ;
                         "advapi32.lib", ;
                         "ole32.lib", ;
                         "uuid.lib", ;
                         "oleaut32.lib", ;
                         "mpr.lib", ;
                         "comdlg32.lib", ;
                         "comctl32.lib", ;
                         "gdi32.lib", ;
                         "olepro32.lib", ;
                         "shell32.lib", ;
                         "winmm.lib", ;
                         "vfw32.lib", ;
                         "wsock32.lib" }
            IF File( cHarbourFolder + 'LIB\' + i )
               cOut += '   echo ' + i + ' >> b32.bc' + CRLF
            ENDIF
         NEXT
         For i := 1 to Len( aRcFiles )
            cOut += '   echo ' + aRcFiles[i] + '.res >> b32.bc' + CRLF
         NEXT i
         cOut += '   echo ' + cMiniGUIFolder + 'resources\oohg.res >> b32.bc' + CRLF
         cOut += '   $(ILINK_EXE)  /SUBSYSTEM:' + If( nOption == 2, "CONSOLE", "WINDOWS" ) + ' @b32.bc' + CRLF
         cOut += CRLF
         For i := 1 To nPrgFiles
            cOut += CRLF
            cOut += '$(C_DIR)\' + aPrgFiles[i] + '.c : ' + cFolder + aPrgFiles[i] + '.prg' + CRLF
            cOut += '   $(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + CRLF
            cOut += CRLF
            cOut += '$(OBJ_DIR)\' + aPrgFiles[i] + '.obj : $(C_DIR)\' + aPrgFiles[i] + '.c' + CRLF
            cOut += '   $(CC) $(COBJFLAGS) -Fo$@ $**' + CRLF
         NEXT i
         HB_MemoWrit( '_temp.bc', cOut )

         // Build batch
         cOut := ''
         cOut += '@echo off' + CRLF
         cOut += cCompFolder + 'BIN\POMAKE.EXE /F' + cFolder + '_temp.bc > ' + cFolder + 'error.lst' + CRLF
         HB_MemoWrit( '_build.bat', cOut )

         // Create folder for objects
         CreateFolder( cFolder + 'OBJ' )

         // Build
         EXECUTE FILE '_build.bat' WAIT HIDE

   CASE ::lTBuild == 1 // Compile.bat

         // Check for compile file
         IF ! File( 'compile.bat' ) .AND. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'OOHG IDE+' )
            Break
         ENDIF

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            IF ::SearchType( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .AND. ! cFile == 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               IF aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               ENDIF
            ENDIF
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         IF nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'OOHG IDE+' )
            Break
         ENDIF
         cOut := ''
         For i := 1 To nPrgFiles
            cOut += "# include '" + aPrgFiles[i] + "'" + CRLF + CRLF
         NEXT i
         HB_MemoWrit( cPrgName + '.prg', cOut )

         // Compile and link
         cDosComm := '/c compile ' + cPrgName + ' /nr /l' + If( nOption == 2, " /d", "" )
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE

      EndCase

      // Check for errors
      cError := MemoRead( 'error.lst' )
      cError1 := Upper( cError )
      IF At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ELSEIF ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'OOHG IDE+' )
         Break
      ENDIF

      // Rename or move
      IF ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         IF Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         ENDIF
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         IF ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'OOHG IDE+' )
            Break
         ENDIF
         cExe := cOut
      ENDIF

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      IF nOption == 0
         MsgInfo( 'Project builded.', 'OOHG IDE+' )
      ELSEIF nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      ENDIF
   End Sequence

   CursorArrow()
   ::Form_Tree:button_09:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL

//------------------------------------------------------------------------------
METHOD ViewErrors( wr ) CLASS THMI
//------------------------------------------------------------------------------
   LOCAL Form_Errors, oEdit, oButt

   IF HB_IsString( wr )
      DEFINE WINDOW Form_Errors OBJ Form_Errors ;
         AT 10, 10 ;
         CLIENTAREA WIDTH 650 HEIGHT 480 ;
         TITLE 'Error Report' ;
         ICON 'IDE_EDIT' ;
         MODAL ;
         FONT "Times new Roman" ;
         SIZE 10 ;
         BACKCOLOR ::aSystemColor ;
         ON INIT ( oButt:Col := Form_Errors:ClientWidth - 40, ;
                   oEdit:Width := Form_Errors:ClientWidth - 45, ;
                   oEdit:Height := Form_Errors:ClientHeight ) ;
         ON SIZE ( oButt:Col := Form_Errors:ClientWidth - 40, ;
                   oEdit:Width := Form_Errors:ClientWidth - 45, ;
                   oEdit:Height := Form_Errors:ClientHeight ) ;

         @ 0, 0 EDITBOX Edit_1 ;
            OBJ oEdit ;
            WIDTH 590 ;
            HEIGHT 445 ;
            VALUE wr ;
            READONLY ;
            FONT 'FixedSys' ;
            SIZE 10 ;
            BACKCOLOR {255, 255, 235}

         @ 10, 595 Button Butt_1 ;
            OBJ oButt ;
            CAPTION 'Exit' ;
            ACTION Form_Errors:Release() ;
            WIDTH 35 ;
            FLAT
      END WINDOW

      CENTER WINDOW Form_Errors
      ACTIVATE WINDOW Form_Errors
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ViewSource( wr ) CLASS THMI
//------------------------------------------------------------------------------
   IF ! HB_IsString( wr )
      RETURN NIL
   ENDIF
   SET INTERACTIVECLOSE ON

   DEFINE WINDOW c_source ;
      AT 10,10 ;
      WIDTH 625 ;
      HEIGHT 460 ;
      TITLE 'Source code' ;
      ICON 'IDE_EDIT' ;
      MODAL ;
      FONT "Times new Roman" ;
      SIZE 10 ;
      BACKCOLOR ::aSystemColor

      @ 0,0 EDITBOX edit_1 ;
         WIDTH 573 ;
         HEIGHT 425 ;
         VALUE WR ;
         READONLY ;
         FONT 'FixedSys' ;
         SIZE 10 ;
         BACKCOLOR { 255, 255, 235 }

      @ 10,575 Button _exiterr ;
         CAPTION 'Exit' ;
         ACTION ThisWindow.Release() ;
         WIDTH 35

      @ 50,575 Button _prints ;
         CAPTION 'Print' ;
         ACTION PrintItem( wr ) ;
         WIDTH 35

     ON KEY ESCAPE ACTION ThisWindow.Release()
   END WINDOW

   CENTER WINDOW c_source
   ACTIVATE WINDOW c_source
   SET INTERACTIVECLOSE OFF
RETURN NIL

//------------------------------------------------------------------------------
METHOD NewProject() CLASS THMI
//------------------------------------------------------------------------------
   IF Len( ::aEditors ) > 0
      MsgStop( 'You can´t open a new project until the form being edited is closed.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF

   IF ! ::lPsave
      IF MsgYesNo( 'Current project not saved, save it now?', 'OOHG IDE+' )
         ::SaveProject()
      ENDIF
   ENDIF

   ::Form_Tree:Tree_1:DeleteAllItems()
   ::Form_Tree:Tree_1:AddItem( 'Project', 0 )
   ::Form_Tree:Tree_1:AddItem( 'Form module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'Prg module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'CH module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'Rpt module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'RC module', 1 )
   ::Form_Tree:Tree_1:Value := 1
   ::Form_Tree:Title := APP_FULL_NAME
   ::lPsave := .T.
   ::cProjectName := ''
   ::Form_Tree:Add:Enabled := .F.
   ::Form_Tree:Button_1:Enabled := .F.

   // Default values from exe startup folder
   ::ReadINI( ::cIDE_Folder + '\hmi.ini' )
RETURN NIL

//------------------------------------------------------------------------------
METHOD OpenProject() CLASS THMI
//------------------------------------------------------------------------------
LOCAL pmgFolder

   IF Len( ::aEditors ) > 0
      MsgStop( 'You can´t open another project until the form being edited is closed.', 'OOHG IDE+' )
      RETURN NIL
   ENDIF

   ::cFile := GetFile( { {'ooHG IDE+ project files *.pmg','*.pmg'} }, 'Open Project', "", .F., .F. )
   IF Len( ::cFile ) > 0
      pmgFolder := OnlyFolder( ::cFile )
      IF ! Empty( pmgFolder )
         ::cProjFolder := pmgFolder
         DirChange( pmgFolder )
      ENDIF
      ::InitializeProject( ::cFile )
      ::Form_Tree:Add:Enabled := .T.
      ::Form_Tree:Button_1:Enabled := .T.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD InitializeProject( cName ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL aLine[0], nCount, cItems, sw, i

   ::cProjectName := cName

   // From project folder
   ::ReadINI( ::cProjFolder + "\hmi.ini" )

   cItems := MemoRead( ::cProjectName )
   nCount := MLCount( cItems )

   ::Form_Tree:Title := APP_FULL_NAME + ' (' + ::cProjectName + ')'
   ::Form_Tree:Tree_1:DeleteAllItems()
   ::Form_Tree:Tree_1:AddItem( 'Project', 0 )
   ::Form_Tree:Tree_1:AddItem( 'Form module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'Prg module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'CH module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'Rpt module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'RC module', 1 )

   sw := 0
   FOR i := 1 TO nCount
      aAdd( aLine, RTrim( MemoLine( cItems, NIL, i ) ) )
      aLine[i] := StrTran( aLine[i], CHR( 10 ), "" )
      aLine[i] := StrTran( aLine[i], CHR( 13 ), "" )
      aLine[i] := RTrim( aLine[i] )

      DO CASE
      CASE aLine[i] == 'Project'
      CASE aLine[i] == 'Form module'
         sw := 1
      CASE aLine[i] == 'Prg module'
         sw := 2
      CASE aLine[i] == 'CH module'
         sw := 3
      CASE aLine[i] == 'Rpt module'
         sw := 4
      CASE aLine[i] == 'RC module'
         sw := 5
      OTHERWISE
         IF sw == 1
            ::NewForm( aLine[i] )
         ENDIF
         IF sw == 2
            ::NewPrg( aLine[i] )
         ENDIF
         IF sw == 3
            ::NewCH( aLine[i] )
         ENDIF
         IF sw == 4
            ::NewRpt( aLine[i] )
         ENDIF
         IF sw == 5
            ::NewRC( aLine[i] )
         ENDIF
      ENDCASE
   NEXT i

   ::Form_Tree:Tree_1:Value := 1
   ::Form_Tree:Tree_1:Expand( 1 )
   ::lPsave := .T.
RETURN NIL

//------------------------------------------------------------------------------
METHOD SaveProject() CLASS THMI
//------------------------------------------------------------------------------
LOCAL Output, nItems, i, cItem

   Output := ''
   nItems := ::Form_Tree:Tree_1:ItemCount
   For i := 1 To nItems
      cItem := ::Form_Tree:Tree_1:Item( i )
      Output += cItem + CRLF
   NEXT i
   Output += ''

   IF Empty( ::cProjectName )
      ::cProjectName := PutFile( { { 'ooHG IDE+ project files *.pmg', '*.pmg' } }, 'ooHG IDE+ - Save Project' )
      IF Upper( Right( ::cProjectName, 4 ) ) != '.PMG'
         ::cProjectName += '.pmg'
      ENDIF
      IF Upper( ::cProjectName ) == '.PMG'
         ::cProjectName := ''
      ENDIF
   ENDIF

   ::cProjFolder := OnlyFolder( ::cProjectName )
   ::Form_Tree:Title := APP_FULL_NAME + ' (' + ::cProjectName + ')'
   IF ! Empty( ::cProjectName )
      ::Form_Tree:Add:Enabled := .T.
      ::Form_Tree:Button_1:Enabled := .T.
   ENDIF

   IF Empty( ::cProjectName )
      MsgStop( 'Project not saved.', 'OOHG IDE+' )
   ELSE
      HB_MemoWrit( ::cProjectName, Output )
      ::SaveINI( ::cProjFolder + '\hmi.ini' )
      ::lPsave := .T.
      MsgInfo( 'Project saved.', 'OOHG IDE+' )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD NewForm( cForm ) CLASS THMI
//------------------------------------------------------------------------------

   IF Val( cForm ) > 0
      MsgStop( 'The name must begin with a letter.', 'OOHG IDE+' )
   ELSEIF Len( cForm ) > 0
      IF At( '.', cForm ) # 0
         MsgStop( 'The name must not contain a dot (.) in it.', 'OOHG IDE+' )
      ELSEIF ::SearchType( ::SearchItem( cForm, 'Form module' ) ) == 'Form module'
         MsgStop( 'This name is not allowed.', 'OOHG IDE+' )
      ELSE
         ::Form_Tree:Tree_1:AddItem( cForm, 2 )
         ::lPsave := .F.
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD NewPrg( cPrg ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nValue

   IF Val( cPrg ) > 0
      MsgStop( 'The name must begin with a letter.', 'OOHG IDE+' )
   ELSEIF Len( cPrg ) > 0
      IF At( '.', cPrg ) # 0
         MsgStop( 'The name must not contain a dot (.) in it.', 'OOHG IDE+' )
      ELSEIF ::SearchType( ::SearchItem( cPrg, 'Prg module' ) ) == 'Prg module'
         MsgStop( 'This name is not allowed.', 'OOHG IDE+' )
      ELSE
         nValue := ::SearchItem( 'Prg module', 'Prg module' )
         ::Form_Tree:Tree_1:AddItem( cPrg, nValue )
         ::lPsave := .F.
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD NewCH( cCH ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nValue

   IF Val( cCH ) > 0
      MsgStop( 'The name must begin with a letter.', 'OOHG IDE+' )
   ELSEIF Len( cCH ) > 0
      IF At( '.', cCH ) # 0
         MsgStop( 'The name must not contain a dot (.) in it.', 'OOHG IDE+' )
      ELSEIF ::SearchType( ::SearchItem( cCH, 'CH module' ) ) == 'CH module'
         MsgStop( 'This name is not allowed.', 'OOHG IDE+' )
      ELSE
         nValue := ::SearchItem( 'CH module', 'CH module' )
         ::Form_Tree:Tree_1:AddItem( cCH, nValue )
         ::lPsave := .F.
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD NewRC( cRC ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nValue

   IF Val( cRC ) > 0
      MsgStop( 'The name must begin with a letter.', 'OOHG IDE+' )
   ELSEIF Len( cRC ) > 0
      IF At( '.', cRC ) # 0
         MsgStop( 'The name must not contain a dot (.) in it.', 'OOHG IDE+' )
      ELSEIF ::SearchType( ::SearchItem( cRC, 'RC module' ) ) == 'RC module'
         MsgStop( 'This name is not allowed.', 'OOHG IDE+' )
      ELSE
         nValue := ::SearchItem( 'RC module', 'RC module' )
         ::Form_Tree:Tree_1:AddItem( cRC, nValue )
         ::lPsave := .F.
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD NewRpt( cRpt ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nValue

   IF Val( cRpt ) > 0
      MsgStop( 'The name must begin with a letter.', 'OOHG IDE+' )
   ELSEIF Len( cRpt ) > 0
      IF At( '.', cRpt ) # 0
         MsgStop( 'The name must not contain a dot (.) in it.', 'OOHG IDE+' )
      ELSEIF ::SearchType( ::SearchItem( cRpt, 'Rpt module' ) ) == 'Rpt module'
         MsgStop( 'This name is not allowed.', 'OOHG IDE+' )
      ELSE
         nValue := ::SearchItem( 'Rpt module', 'Rpt module' )
         ::Form_Tree:Tree_1:AddItem( cRpt, nValue )
         ::lPsave := .F.
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD DeleteItem() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cItem

   cItem := ::Form_Tree:Tree_1:Item( ::Form_Tree:Tree_1:Value )
   IF cItem == 'Form module' .OR. cItem == 'Prg module' .OR. cItem == 'Project' .OR. cItem == 'CH module' .OR. cItem == 'Rpt module' .OR. cItem == 'RC module'
      MsgStop( "This item can't be deleted.", 'OOHG IDE+' )
      RETURN NIL
   ENDIF

   IF MsgYesNo( 'Item ' + cItem + ' will be removed, are you sure?', 'OOHG IDE+' )
      ::Form_Tree:Tree_1:DeleteItem( ::Form_Tree:Tree_1:Value )
      ::lPsave := .F.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SearchItem( cNameItem, cParent ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nItems, i, cItem, sw := 0

   nItems := ::Form_Tree:Tree_1:ItemCount
   FOR i := 1 TO nItems
      cItem := ::Form_Tree:Tree_1:Item( i )
      IF cItem == cParent
         sw := 1
      ENDIF
      IF sw == 1
         IF Upper( cItem ) == Upper( cNameItem )
            RETURN i
         ENDIF
      ENDIF
   NEXT i
RETURN 0

//------------------------------------------------------------------------------
METHOD SearchType( nValue ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL i

   IF HB_IsNumeric( nValue ) .AND. nValue > 0 .AND. nValue <= ::Form_Tree:Tree_1:ItemCount
      FOR i := nValue TO 1 STEP -1
          IF ::Form_Tree:Tree_1:Item( i ) == 'Form module'
             RETURN 'Form module'
          ENDIF
          IF ::Form_Tree:Tree_1:Item( i ) == 'Prg module'
             RETURN 'Prg module'
          ENDIF
          IF ::Form_Tree:Tree_1:Item( i ) == 'CH module'
             RETURN 'CH module'
          ENDIF
          IF ::Form_Tree:Tree_1:Item( i ) == 'Rpt module'
             RETURN 'Rpt module'
          ENDIF
          IF ::Form_Tree:Tree_1:Item( i ) == 'RC module'
             RETURN 'RC module'
          ENDIF
      NEXT i
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ModifyItem( cParameter, cParent ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL Output, cItem := SubStr( cParameter, 1, At( ".", cParameter ) - 1 )

   IF cParent == 'Prg module'
      IF File( cParameter )
         ::OpenFile( cParameter )
      ELSE
         Output := '/*        IDE: ooHG IDE+' + CRLF
         Output += ' *     Project: ' + ::cProjectName + CRLF
         Output += ' *        Item: ' + cParameter + CRLF
         Output += ' * Description: ' + CRLF
         Output += ' *      Author: ' + CRLF
         Output += ' *        Date: ' + DtoC( Date() ) + CRLF
         Output += ' */' + CRLF + CRLF

         Output += "#include 'oohg.ch'" + CRLF + CRLF
         Output += "*------------------------------------------------------*" + CRLF
         IF ::SearchItem( cItem, cParent ) == ( ::SearchItem( cParent, cParent ) + 1 )
            Output += 'FUNCTION Main()' + CRLF
         ELSE
            Output += 'FUNCTION ' + cItem + '()' + CRLF
         ENDIF
         Output += "*------------------------------------------------------*" + CRLF + CRLF
         Output += 'RETURN NIL' + CRLF + CRLF
         HB_MemoWrit( cParameter, Output )
         ::OpenFile( cParameter )
      ENDIF
   ELSEIF cParent == 'CH module'
      IF File( cParameter )
         ::OpenFile( cParameter )
      ELSE
         Output := '/*        IDE: ooHG IDE+' + CRLF
         Output += ' *     Project: ' + ::cProjectName + CRLF
         Output += ' *        Item: ' + cParameter + CRLF
         Output += ' * Description:' + CRLF
         Output += ' *      Author:' + CRLF
         Output += ' *        Date: ' + DtoC( Date() ) + CRLF
         Output += ' */' + CRLF + CRLF
         Output += '#' + CRLF
         HB_MemoWrit( cParameter, Output )
         ::OpenFile( cParameter )
      ENDIF
   ELSEIF cParent == 'RC module'
      IF File( cParameter )
         ::OpenFile( cParameter )
      ELSE
         Output:='//         IDE: ooHG IDE+' + CRLF
         Output+='//     Project: ' + ::cProjectName + CRLF
         Output+='//        Item: ' + cParameter + CRLF
         Output+='// Description:' + CRLF
         Output+='//      Author:' + CRLF
         Output+='//        Date: ' + DToC( Date() ) + CRLF
         Output+='// Name    Format   Filename' + CRLF
         Output+='// MYBMP   BITMAP   res\Next.bmp' + CRLF
         Output+='// Last line of this file must end with a CRLF' + CRLF
         HB_MemoWrit( cParameter, Output )
         ::OpenFile( cParameter )
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD EditorExit( aPositions, nEditorIndex ) CLASS THMI
//------------------------------------------------------------------------------
   ::aPositions := aClone( aPositions )
   ::SaveINI( ::cProjFolder + '\hmi.ini' )

   _OOHG_DeleteArrayItem( ::aEditors, nEditorIndex )

   IF ::lCloseOnFormExit .AND. Len( ::aEditors ) == 0
      RELEASE WINDOW ALL
   ELSE
      // TODO: dejar siempre habilitados
      ::Form_Tree:button_07:Enabled := .T.
      ::Form_Tree:button_09:Enabled := .T.
      ::Form_Tree:button_10:Enabled := .T.
      ::Form_Tree:button_11:Enabled := .T.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SaveFile() CLASS THMI
//------------------------------------------------------------------------------
   IF AllTrim( ::Form_Edit:edit_1:Value ) == ''
      IF File( ::cItemFile )
         DELETE FILE ( ::cItemFile )
      ENDIF
      ::lSave := .T.
   ELSE
      IF HB_MemoWrit( ::cItemFile, AllTrim( ::Form_Edit:edit_1:Value ) )
         ::lSave := .T.
      ELSE
         MsgStop( 'Error writing ' + ::cItemFile + '.', 'OOHG IDE+' )
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD OpenFile( cFile ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL cOutput, nwidth, nheight, wq, nRAt, cRun, ll, i, cTextedit, nInterval

   CursorWait()
   ::lSave := .T.
   ::nPosText := 0
   ::cText := ''
   ::nTemp := 0
   ::Form_Wait:Show()
   ::Form_Wait:hmi_label_101:Value := 'Loading File ...'
   ::cItemFile := cFile

   IF Len( AllTrim( ::cExtEditor ) ) == 0
      cTextEdit := MemoRead( cFile )
      cTextEdit := StrTran( cTextEdit, Chr( 9 ), Space( 8 ) )
      cOutput := ''
      FOR i := 1 TO MLCount( cTextEdit )
          cOutput := cOutput + RTrim( MemoLine( cTextEdit, 500, i ) ) + CRLF
      NEXT i
      cTextEdit := RTrim( cOutput )
      DO WHILE .T.
         wq := SubStr( cOutput, Len( cTextEdit ) - 1, 1 )
         IF wq == Chr(13) .OR. wq = Chr( 10 )
            cTextEdit := Left( cTextEdit, Len( cTextEdit ) - 1 )
         ELSE
            cTextEdit := Left( cTextEdit, Len( cTextEdit ) - 1 ) + CRLF
            EXIT
         ENDIF
      ENDDO

      IF IsWindowDefined( Form_Edit )
         ::Form_Wait:Hide()
         MsgStop( "Sorry, the IDE can't edit more than one file at a time.", 'OOHG IDE+' )
         RETURN NIL
      ENDIF

      nWidth := ::Form_Tree:Width - ( ::Form_Tree:Width / 3.5 )
      nHeight := ::Form_Tree:Height - 160

      DEFINE WINDOW Form_Edit OBJ ::Form_Edit ;
         AT 109, 80 ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         TITLE APP_FULL_NAME + " " + cFile ;
         ICON 'IDE_EDIT' ;
         CHILD ;
         FONT "Courier New" ;
         SIZE 10 ;
         BACKCOLOR ::aSystemColor ;
         ON SIZE { || ::Form_Edit:Edit_1:Width := ::Form_Edit:Width - 15, ::Form_Edit:Edit_1:Height := ::Form_Edit:Height - 90 }

         @ 30, 2 RICHEDITBOX edit_1 ;
            WIDTH ::Form_Edit:Width - 15 ;
            HEIGHT ::Form_Edit:Height - 90 ;
            VALUE cTextEdit ;
            BACKCOLOR {255, 255, 235} ;
            MAXLENGTH 256000 ;
            ON CHANGE ::lSave := .F. ;
            ON GOTFOCUS ::PosXY()

         IF Len( ::Form_Edit:edit_1:Value ) > 100000
            MsgInfo( 'You should use another program editor.', 'OOHG IDE+' )
         ENDIF

         IF Len( ::Form_Edit:edit_1:Value ) > 250000
            MsgStop('You must use another program editor.', 'OOHG IDE+' )
            RETURN NIL
         ENDIF

         ll := MLCount( ::Form_Edit:edit_1:Value )
         IF ll <= 800
            nInterval := 1000
         ELSE
            nInterval := Int( ( ( ( ll - 800 ) / 800 ) + 1 ) * 2000 )
         ENDIF

         DEFINE TIMER Timit INTERVAL nInterval ACTION ::LookChanges()

         DEFINE SPLITBOX
            DEFINE TOOLBAR 0 BUTTONSIZE 20, 20 FLAT FONT 'Calibri' SIZE 9
               BUTTON button_2 TOOLTIP 'Exit (Esc)'        PICTURE 'IDE_EXIT'  ACTION ::SaveAndExit()
               BUTTON button_1 TOOLTIP 'Save (F2)'         PICTURE 'IDE_SAVE'  ACTION ::SaveFile()
               BUTTON button_3 TOOLTIP 'Find (Ctrl-F)'     PICTURE 'IDE_FIND'  ACTION ::TxtSearch()
               BUTTON button_4 TOOLTIP 'Next (F3)'         PICTURE 'IDE_NEXT'  ACTION ::NextSearch()
               BUTTON button_5 TOOLTIP 'Go (Ctrl-G)'       PICTURE 'IDE_GO'    ACTION ::GoLine()
               nRAt := RAt( '.prg', cFile )
               IF nRAt > 0
               BUTTON button_6 TOOLTIP 'Reformat (Ctrl-R)' PICTURE 'IDE_REFOR' ACTION ::Reforma( ::Form_Edit:edit_1:Value )
               ENDIF
            END TOOLBAR
         END SPLITBOX

         ON KEY F2     OF Form_Edit ACTION ::SaveFile()
         ON KEY F3     OF Form_Edit ACTION ::NextSearch()
         ON KEY CTRL+F OF Form_Edit ACTION ::TxtSearch()
         ON KEY CTRL+G OF Form_Edit ACTION ::GoLine()
         ON KEY ESCAPE OF Form_Edit ACTION ::SaveAndExit()
         IF nRAt > 0
         ON KEY CTRL+R OF Form_Edit ACTION ::Reforma( ::Form_Edit:edit_1:Value )
         ENDIF

         DEFINE STATUSBAR
            STATUSITEM " Lin:     Col:     Caret:     " WIDTH 20
            KEYBOARD
            DATE WIDTH 100
            CLOCK WIDTH 90
         END STATUSBAR

         DEFINE CONTEXT MENU
            MENUITEM 'Cut'        ACTION Send_Cut()
            MENUITEM 'Copy'       ACTION Send_Copy()
            MENUITEM 'Paste'      ACTION Send_Paste()
            MENUITEM 'Delete'     ACTION _PushKey( 32 )
            SEPARATOR
            MENUITEM 'Select all' ACTION Send_SelectAll()
         END MENU
      END WINDOW

      CENTER WINDOW Form_Edit
      ::Form_Wait:Hide()
      CursorArrow()
      ACTIVATE WINDOW Form_Edit
   ELSE
      cRun := ::cExteditor + ' ' + cFile

      ::Form_Wait:Hide()
      CursorArrow()
      EXECUTE FILE cRun WAIT
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Reforma( cContenido ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL ntab := 0
LOCAL lcero := 0
LOCAL coutput := ''
LOCAL swclase := 0
LOCAL cantlin := ''
LOCAL swcase := 0
LOCAL swc := 0
LOCAL i, clineaorig, clinea, cllinea, cdeslin, clinea1
LOCAL largo

   ::Form_Wait:hmi_label_101:value:='Reformating ....'
   ::Form_Wait:Show()

   ccontenido:=StrTran(ccontenido,chr(9),space(8))
   largo:=mlcount(ccontenido)
   for i := 1 to largo
       IF i > 0
          cantlin:=ltrim(rtrim(memoline(ccontenido,500,i-1)))
       ENDIF
       IF i < largo
          cdeslin:=ltrim(rtrim(memoline(ccontenido,500,i+1)))
       ENDIF
       clineaorig:=memoline(ccontenido,500,i)
       clinea1:=rtrim(clineaorig)
       clinea:=ltrim(rtrim(clineaorig))
       cllinea:=upper(clinea)
       do case
          case substr(cllinea,1,4)='CASE' .or. substr(cllinea,1,9)='OTHERWISE'
             IF swcase=0
                coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                ntab:=ntab+3
                swcase:=-1
             ELSE
                IF swcase=-1
                   ntab:=ntab-3
                   coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                   swcase:=1
                   ntab:=ntab+3
                ELSE
                   ntab:=ntab-3
                   coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                   swcase=-1
                   ntab:=ntab+3
                ENDIF
             ENDIF

          case substr(cllinea,1,9)='DO WHILE '
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3

          case substr(cllinea,1,17)='#PRAGMA BEGINDUMP'
             coutput:=coutput+replicate(' ',ntab)+clineaorig+CRLF
             swc:=1
          case substr(cllinea,1,15)='#PRAGMA ENDDUMP'
             coutput:=coutput+replicate(' ',ntab)+clineaorig+CRLF
             swc:=0
          case substr(cllinea,1,9)='BEGIN INI'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3

          case substr(cllinea,1,7)='END INI'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF

          case substr(cllinea,1,9)='FUNCTION '
             IF substr(cantlin,1,2) # '*-'
                coutput:=coutput+CRLF
                coutput:=coutput+'*-------------------------'+CRLF
             ENDIF
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             IF substr(cdeslin,1,2) # '*-'
                coutput:=coutput+'*-------------------------'+CRLF
             ENDIF
          case substr(cllinea,1,16)='STATIC FUNCTION '
             IF substr(cantlin,1,2) # '*-'
                coutput:=coutput+CRLF
                coutput:=coutput+'*-------------------------'+CRLF
             ENDIF
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             IF substr(cdeslin,1,2) # '*-'
                coutput:=coutput+'*-------------------------'+CRLF
             ENDIF

          case substr(cllinea,1,10)='PROCEDURE '
             IF substr(cantlin,1,2) # '*-'
                coutput:=coutput+CRLF
                coutput:=coutput+'*-------------------------'+CRLF
             ENDIF
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             IF substr(cdeslin,1,2) # '*-'
                coutput:=coutput+'*-------------------------'+CRLF
             ENDIF
          case substr(cllinea,1,9)='METHOD '
             IF swclase=0 .AND. substr(cantlin,1,2) # '*-'
                coutput:=coutput+CRLF
                coutput:=coutput+'*-------------------------'+CRLF
             ENDIF
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             IF swclase=0 .AND. substr(cdeslin,1,2) # '*-'
                coutput:=coutput+'*-------------------------'+CRLF
             ENDIF
          case substr(cllinea,1,5)='CLASS'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
             swclase:=1
          case substr(cllinea,1,7)='DO CASE'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
             swcase:=0
          case substr(cllinea,1,7)='ENDCASE'
             ntab:=ntab-6
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF

          case substr(cllinea,1,8)='ENDCLASS'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             swclase:=0
          case substr(cllinea,1,3)='IF '
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,5)='ENDIF' .or. substr(cllinea,1,6)='END IF'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,5)='ENDDO'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,6)='ELSEIF'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3

          case substr(cllinea,1,4)='ELSE'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,4)='FOR '
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+4
          case substr(cllinea,1,4)='NEXT'
             ntab:=ntab-4
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,14)='DEFINE WINDOW '
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3

          case substr(cllinea,1,15)='DEFINE SPLITBOX'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,10)='END WINDOW'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,12)='END SPLITBOX'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,16)='DEFINE STATUSBAR'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,13)='END STATUSBAR'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF

          case substr(cllinea,1,16)='DEFINE MAIN MENU'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,8)='END MENU'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF

          case substr(cllinea,1,5)='POPUP'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,9)='END POPUP'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF

          case substr(cllinea,1,11)='DEFINE TREE'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,8)='END TREE'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,14)='DEFINE TOOLBAR'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,11)='END TOOLBAR'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,20)='DEFINE DROPDOWN MENU'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,14)='DEFINE CONTEXT'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,12)='DEFINE LABEL'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,9)='END LABEL'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,14)='DEFINE TEXTBOX'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,11)='END TEXTBOX'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,14)='DEFINE EDITBOX'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,11)='END EDITBOX'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,13)='DEFINE BUTTON'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,10)='END BUTTON'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,15)='DEFINE CHECKBOX'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,12)='END CHECKBOX'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,14)='DEFINE LISTBOX'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,11)='END LISTBOX'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,15)='DEFINE COMBOBOX'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,12)='END COMBOBOX'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,18)='DEFINE CHECKBUTTON'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,15)='END CHECKBUTTON'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,11)='DEFINE GRID'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,8)='END GRID'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,13)='DEFINE SLIDER'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,10)='END SLIDER'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,14)='DEFINE SPINNER'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,11)='END SPINNER'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,12)='DEFINE IMAGE'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,9)='END IMAGE'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,17)='DEFINE DATEPICKER'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,14)='END DATEPICKER'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,13)='DEFINE BROWSE'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,10)='END BROWSE'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,17)='DEFINE RADIOGROUP'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,14)='END RADIOGROUP'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,12)='DEFINE FRAME'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,9)='END FRAME'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,10)='DEFINE TAB'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,7)='END TAB'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,17)='DEFINE ANIMATEBOX'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,14)='END ANIMATEBOX'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             //    case substr(cllinea,1,5)='PAGE '
             //         coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             //         ntab:=ntab+3
             //    case substr(cllinea,1,8)='END PAGE'
             //         ntab:=ntab-3
             //         coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,16)='DEFINE HYPERLINK'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,13)='END HYPERLINK'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,20)='DEFINE MONTHCALENDAR'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,17)='END MONTHCALENDAR'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,18)='DEFINE PROGRESSBAR'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,15)='END PROGRESSBAR'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,18)='DEFINE RICHEDITBOX'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,15)='END RICHEDITBOX'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,13)='DEFINE PLAYER'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,10)='END PLAYER'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          case substr(cllinea,1,16)='DEFINE IPADDRESS'
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             ntab:=ntab+3
          case substr(cllinea,1,13)='END IPADDRESS'
             ntab:=ntab-3
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
          otherwise
             IF len(clinea) > 0
                IF swc=0
                   coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                ELSE
                   coutput:=coutput+replicate(' ',ntab)+clinea1+CRLF
                ENDIF
                lcero:=0
             ELSE
                lcero++
                IF lcero < 10
                   coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                ENDIF
             ENDIF
       endcase
   NEXT i
   ::Form_Edit:edit_1:Value := cOutput
   ::Form_Wait:Hide()
   ::Form_Edit:edit_1:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD GoLine() CLASS THMI
//------------------------------------------------------------------------------
LOCAL i, nCount, nPos, nLine, cText

   nCount := MLCount( ::Form_Edit:edit_1:Value )
   nPos   := 0
   nLine  := Val( InputBox( 'Go to line:', 'Question' ) )
   IF nLine > nCount
      nLine := nCount
   ENDIF
   cText := ::Form_Edit:edit_1:Value
   ::Form_Edit:edit_1:SetFocus()
   FOR i := 1 TO nCount
       nPos := nPos + Len( RTrim( ( MemoLine( cText, 500, i ) ) ) )
       IF i == nLine
          ::Form_Edit:edit_1:SetFocus()
          ::Form_Edit:edit_1:CaretPos := nPos + ( i * 2 ) - i + 1 - 2 - Len( Trim( ( MemoLine( cText, 500, i ) ) ) )
          EXIT
       ENDIF
   NEXT i
RETURN NIL

//------------------------------------------------------------------------------
METHOD LookChanges() CLASS THMI
//------------------------------------------------------------------------------
   IF ::Form_Edit:edit_1:CaretPos # ::nCaretPos
      ::PosXY()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD PosXY() CLASS THMI
//------------------------------------------------------------------------------
LOCAL i, texto, long
LOCAL nCP := ::Form_Edit:edit_1:CaretPos, npos := 0, nposx := 0, nposy
   texto:=::Form_Edit:edit_1:value
   long:=mlcount(texto)
   ::nCaretPos := nCP
   nposy:=0
   for i:=1 to long
       npos:=npos+len(rtrim(( memoline(texto,500,i)   )))
       IF npos > ( nCP -(i-1) )
          nposx:=len((rtrim((memoline(texto,500,i)))))-(npos-(nCP-(i-1)))+1
          nposy:=i
          IF nposx=0
             nposy --
             nposx:=len((rtrim((memoline(texto,500,nposy)))))+1
          ENDIF
          exit
       ENDIF
    NEXT i
    ::Form_Edit:StatusBar:Item(1, ' Lin' + padr( str( nposy, 4), 4) + ' Col' + PADR( str( nposx, 4), 4) + ' Car' + padr( str( nCP, 4), 4) )
RETURN NIL

//------------------------------------------------------------------------------
METHOD txtsearch() CLASS THMI
//------------------------------------------------------------------------------
   ::nPosText := 0
   ::cText := AllTrim( InputBox( 'Text', 'Search' ) )
   IF Len( ::cText ) > 0
      ::NextSearch()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD NextSearch() CLASS THMI
//------------------------------------------------------------------------------
LOCAL texto
texto:=StrTran(::Form_Edit:edit_1:value,CR,"")
::npostext:=myat(upper(::ctext),upper(texto),::npostext+len(::ctext))
if ::npostext > 0
   ::Form_Edit:edit_1:setfocus()
   ::Form_Edit:edit_1:CaretPos := ::npostext-1
ELSE
   ::Form_Edit:edit_1:setfocus()
   MsgInfo( 'No more matches found.', 'OOHG IDE+' )
ENDIF
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION myat(cbusca,ctexto,ninicio)
//------------------------------------------------------------------------------
LOCAL i,nposluna
nposluna:=0
for i:= ninicio to len(ctexto)
    IF upper(substr(ctexto,i,len(cbusca)))=upper(cbusca)
       nposluna:=i
       exit
    ENDIF
NEXT i
RETURN nposluna

//------------------------------------------------------------------------------
METHOD SaveAndExit() CLASS THMI
//------------------------------------------------------------------------------
   IF ! ::lSave
      IF MsgYesNo( 'File not saved, save it now?', 'OOHG IDE+' )
         ::SaveFile()
      ENDIF
   ENDIF
   ::Form_Edit:Release()
RETURN NIL

//------------------------------------------------------------------------------
METHOD DatabaseView() CLASS THMI
//------------------------------------------------------------------------------
LOCAL curfol, curdrv, cFile, nPos, i, j

   curfol := CurDir()
   curdrv := CurDrive() + ':\'
   cFile := GetFile ( { { 'dbf files *.dbf', '*.dbf' } }, 'Open Dbf file', NIL, .F., .F. )
   IF Len( cFile ) > 0
      nPos := at( ".", cFile )
      cFile := Left( cFile, nPos - 1 )
      j := 0
      FOR i := 1 TO Len( cFile )
          IF SubStr( cFile, i, 1 ) == '\'
             j := i
          ENDIF
      NEXT i
      cFile := SubStr( cFile, j + 1, Len( cFile ) )
      USE ( cFile ) NEW
      SET INTERACTIVECLOSE ON
      EDIT EXTENDED WORKAREA ( cFile ) TITLE 'Browsing of ... ' + cFile
      SET INTERACTIVECLOSE OFF
      ( cFile )->( dbCloseArea() )
   ENDIF
   DirChange( curdrv + curfol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD myInputWindow( cTitle, aLabels, aValues, aFormats, bFunc1, bFunc2 ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL l, aResult, wyw, i, wHeight, _iw, ControlRow, cLblName, cCtrlName, oWin, lChange := .F.

   SET INTERACTIVECLOSE ON
   l := Len( aLabels )
   aResult := Array( l )

   wyw := ( GetTitleHeight() + GetBorderHeight() ) * 2 + 10
   FOR i := 1 TO l
      DO CASE
      CASE ValType( aValues[i] ) == 'L'
         wyw += 30
      CASE ValType( aValues[i] ) == 'D'
         wyw += 26
      CASE ValType( aValues[i] ) == 'N'
         IF ValType ( aFormats[i] ) == 'A'
            wyw += 26
         ELSEIF ValType ( aFormats[i] ) == 'C'
            IF At( '.', aFormats[i] ) > 0
               wyw += 26
            ELSE
               wyw += 26
            ENDIF
         ELSE
            wyw += 26
         ENDIF
      CASE ValType( aValues[i] ) == 'C'
         IF ValType( aFormats[i] ) == 'N'
            IF  aFormats[i] <= 32
               wyw += 26
            ELSE
               wyw += 42
            ENDIF
         ELSE
            wyw += 26
         ENDIF
      CASE ValType( aValues[i] ) == 'M'
         wyw += 92
      OTHERWISE
         wyw += 26
      ENDCASE
   NEXT i

   wHeight := Min( GetDeskTopRealHeight() - ::MainHeight - 46, wyw )

   DEFINE WINDOW _inputwindow OBJ _iw ;
      WIDTH 720 ;
      HEIGHT wHeight ;
      TITLE cTitle ;
      MODAL ;
      NOSIZE ;
      ICON 'IDE_EDIT' ;
      FONT 'Courier new' SIZE 9 ;
      BACKCOLOR ::aSystemColor ;
      ON INTERACTIVECLOSE If( lChange, MsgYesNo( "Close without saving?", 'OOHG IDE+' ), .T. )

      DEFINE STATUSBAR
         STATUSITEM " "
         IF HB_IsBlock( bFunc1 )
         STATUSITEM "Set Font/Colors ." WIDTH 115 ACTION Eval( bFunc1 ) TOOLTIP "Change font and colors."
         ENDIF
         IF HB_IsBlock( bFunc2 )
         STATUSITEM "Use Defaults    ." WIDTH 115 ACTION Eval( bFunc2 ) TOOLTIP "Use default font and default colors."
         ENDIF
         STATUSITEM "Ok              ." WIDTH 115 ACTION _myInputWindowOk( _iw, aResult, oWin ) TOOLTIP "Save changes."
         STATUSITEM "Cancel          ." WIDTH 115 ACTION _myInputWindowCancel( _iw, aResult, lChange ) TOOLTIP "Discard changes."
      END STATUSBAR

      DEFINE WINDOW Int_1 OBJ oWin ;
         AT 0, 0 ;
         WIDTH _iw:ClientWidth ;
         HEIGHT _iw:ClientHeight + _iw:StatusBar:ClientHeightUsed() ;
         INTERNAL ;
         VIRTUAL HEIGHT wyw ;
         FONT 'Courier new' SIZE 9 ;
         BACKCOLOR ::aSystemColor

         ControlRow := 10

         FOR i := 1 TO l
            cLblName  := 'Label_' + Alltrim(Str( i ))
            cCtrlName := 'Control_' + Alltrim(Str( i ))

            @ ControlRow + 3, 10 LABEL &cLblName VALUE aLabels[i] AUTOSIZE

            DO CASE
            CASE ValType ( aValues[i] ) == 'L'
               @ ControlRow, 180 CHECKBOX &cCtrlName CAPTION '' VALUE aValues[i] ON CHANGE lChange := .T.
               ControlRow := ControlRow + 30
            CASE ValType ( aValues[i] ) == 'D'
               @ ControlRow, 180 DATEPICKER &cCtrlName VALUE aValues[i] WIDTH 420 ON CHANGE lChange := .T.
               ControlRow := ControlRow + 26
            CASE ValType ( aValues[i] ) == 'N'
               IF ValType ( aFormats[i] ) == 'A'
                  @ ControlRow, 180 COMBOBOX &cCtrlName ITEMS aFormats[i] VALUE aValues[i] WIDTH 420  FONT 'Arial' SIZE 9 ON CHANGE lChange := .T.
                  ControlRow := ControlRow + 26
               ELSEIF  ValType ( aFormats[i] ) == 'C'
                  IF AT ( '.', aFormats[i] ) > 0
                     @ ControlRow, 180 TEXTBOX &cCtrlName VALUE aValues[i] WIDTH 120 FONT 'Courier new' SIZE 9 NUMERIC INPUTMASK aFormats[i] RIGHTALIGN ON CHANGE lChange := .T.
                     ControlRow := ControlRow + 26
                  ELSE
                     @ ControlRow, 180 TEXTBOX &cCtrlName VALUE aValues[i] WIDTH 120 FONT 'Courier new' SIZE 9 NUMERIC INPUTMASK aFormats[i] RIGHTALIGN ON CHANGE lChange := .T.
                     ControlRow := ControlRow + 26
                  ENDIF
               ELSE
                  ControlRow := ControlRow + 26
               ENDIF
            CASE ValType ( aValues[i] ) == 'C'
               IF ValType ( aFormats[i] ) == 'N'
                  IF  aFormats[i] <= 32
                     @ ControlRow, 180 TEXTBOX &cCtrlName VALUE aValues[i] WIDTH 270 FONT 'Courier new' SIZE 9 MAXLENGTH aFormats[i] ON CHANGE lChange := .T.
                     ControlRow := ControlRow + 26
                  ELSE
                     @ ControlRow, 180 EDITBOX &cCtrlName WIDTH 420 HEIGHT 40 VALUE aValues[i] FONT 'Courier new' SIZE 9 MAXLENGTH aFormats[i] NOVSCROLL ON CHANGE lChange := .T.
                     ControlRow := ControlRow + 42
                  ENDIF
               ELSE
                  ControlRow := ControlRow + 26
               ENDIF
            CASE ValType ( aValues[i] ) == 'M'
               @ ControlRow, 180 EDITBOX &cCtrlName WIDTH 420 HEIGHT 90 VALUE aValues[i] FONT 'Courier new' SIZE 9 ON CHANGE lChange := .T.
               ControlRow := ControlRow + 92
            OTHERWISE
               @ ControlRow, 180 TEXTBOX &cCtrlName NOBORDER BACKCOLOR ::aSystemColor NOTABSTOP READONLY WIDTH 270 FONT 'Courier new' SIZE 9 MAXLENGTH 10 ON CHANGE lChange := .T.
               ControlRow := ControlRow + 26
            ENDCASE
         NEXT i

      END WINDOW

      ON KEY ESCAPE OF _inputwindow ACTION _myInputWindowCancel( _iw, aResult, lChange )

   END WINDOW

   CENTER WINDOW _InputWindow
   ACTIVATE WINDOW _InputWindow

   SET INTERACTIVECLOSE OFF
RETURN aResult

//------------------------------------------------------------------------------
STATIC FUNCTION _myInputWindowOk( oInputWindow, aResult, oWin )
//------------------------------------------------------------------------------
LOCAL i, l

   l := Len( aResult )
   FOR i := 1 TO l
      aResult[ i ] := oWin:Control( 'Control_' + Alltrim( Str( i ) ) ):Value
   NEXT i
   oInputWindow:Release()
RETURN .T.

//------------------------------------------------------------------------------
STATIC FUNCTION _myInputWindowCancel( oInputWindow, aResult, lChange )
//------------------------------------------------------------------------------
   IF ! lChange .OR. MsgYesNo( "Close without saving?", 'OOHG IDE+' )
      aFill( aResult, NIL )
      oInputWindow:Release()
   ENDIF
RETURN .T.

//------------------------------------------------------------------------------
FUNCTION DelExt( cFileName )
//------------------------------------------------------------------------------
LOCAL nAt, cBase

   nAt := RAt( ".", cFileName )
   IF nAt > 0
      cBase := Left( cFileName, nAt - 1 )
   ELSE
      cBase := cFileName
   ENDIF
RETURN cBase

//------------------------------------------------------------------------------
FUNCTION DelPath( cFileName )
//------------------------------------------------------------------------------
RETURN SubStr( cFileName, RAt( '\', cFileName ) + 1 )

//------------------------------------------------------------------------------
FUNCTION AddSlash(cInFolder)
//------------------------------------------------------------------------------
  LOCAL cOutFolder := ALLTRIM(cInFolder)

  IF RIGHT(cOutfolder, 1) != '\'
    cOutFolder += '\'
  ENDIF
RETURN cOutFolder

//------------------------------------------------------------------------------
FUNCTION DelSlash( cInFolder )
//------------------------------------------------------------------------------
  LOCAL cOutFolder := AllTrim( cInFolder )

  IF Right( cOutfolder, 1 ) == '\'
     cOutFolder := Left( cOutFolder, Len( cOutFolder ) - 1 )
  ENDIF
RETURN cOutFolder

//------------------------------------------------------------------------------
FUNCTION OnlyFolder( cFile )
//------------------------------------------------------------------------------
LOCAL nPos, cFolder := NIL

   IF Len( cFile ) > 0
      nPos := RAt( '\', cFile )
      IF nPos > 1
         cFolder := Left( cFile, nPos - 1 )
      ENDIF
   ENDIF
RETURN cFolder

//------------------------------------------------------------------------------
FUNCTION IsFileInPath( cFileName )
//------------------------------------------------------------------------------
LOCAL cDir, cName, cExt

   hb_FNameSplit( cFileName, @cDir, @cName, @cExt )

   For Each cDir In hb_ATokens( GetEnv( "PATH" ), hb_osPathListSeparator(), .T., .T. )
      IF Left( cDir, 1 ) == '"' .AND. Right( cDir, 1 ) == '"'
         cDir := SubStr( cDir, 2, Len( cDir ) - 2 )
      ENDIF
      IF ! Empty( cDir )
         IF ! Right( cDir, 1 ) == "\"
            cDir += "\"
         ENDIF
         IF File( cDir + cFileName )
            RETURN .T.
         ENDIF
      ENDIF
   NEXT
RETURN .F.

//------------------------------------------------------------------------------
FUNCTION Help_F1( c_p, myIde )
//------------------------------------------------------------------------------
LOCAL wr

   DO CASE
   CASE c_p == 'PROJECT'
      wr := CRLF
      wr := wr + "CREATING PROJECTS" + CRLF
      wr := wr + "Select 'New Project' from menu File, and you'll have a new project" + CRLF
      wr := wr + "with basic elements and a main PRG." + CRLF + CRLF

      wr := wr + "CHANGING PREFERENCES" + CRLF
      wr := wr + "Select 'Preferences' from menu File." + CRLF
      wr := wr + "You can change Date Format, Compile mode (Tradtional or BRmake)" + CRLF
      wr := wr + "default Backcolor and linker options." + CRLF + CRLF

      wr := wr + "SAVING PROJECTS" + CRLF
      wr := wr + "Select 'Save Project' from File menu." + CRLF + CRLF

      wr := wr + "ADDING ITEMS TO PROJECT TREE" + CRLF
      wr := wr + "Add form, prg, ch, rpt and rc modules." + CRLF
      wr := wr + "Select 'ADD...' toolbar button or it's dropdown menu options." + CRLF + CRLF

      wr := wr + "MODIFY ITEMS" + CRLF
      wr := wr + "Simply double click over the item to modify it, or" + CRLF
      wr := wr + "select 'Modify item' toolbar button after selecting the item." + CRLF + CRLF

      wr := wr + "REMOVE ITEMS." + CRLF
      wr := wr + "Select 'Remove Item' toolbar button." + CRLF + CRLF

      wr := wr + "VIEW and PRINT ITEMS" + CRLF
      wr := wr + "Select 'View/Print Item' toolbar button." + CRLF + CRLF

      wr := wr + "BUILDING, RUNING and DEBUGGING" + CRLF
      wr := wr + "Select 'Build Project' toolbar button to build." + CRLF
      wr := wr + "Select 'Build and Run Project' toolbar button to build and run." + CRLF
      wr := wr + "Select 'Run Project' toolbar button to run." + CRLF
      wr := wr + "Select 'Debug Project' from 'Run Project' button's dropdown menu options." + CRLF + CRLF

      wr := wr + "SEARCHING TEXT" + CRLF
      wr := wr + "Select 'Global Search Text' toolbar button to search text all across the project." + CRLF + CRLF

      wr := wr + "QUICK BROWSING" + CRLF
      wr := wr + "Select 'Quick Browse' toolbar button to quick browse a DBF file." + CRLF + CRLF

      wr := wr + "DATA MANAGEMENT" + CRLF
      wr := wr + "Select 'Data Manager' toolbar button to create a new DBF file or to edit," + CRLF
      wr := wr + "change the structure, browse or zap and existing one." + CRLF + CRLF

   CASE c_p == 'FORMEDIT'
      wr := CRLF
      wr := wr + "EDITING FORMS AND CONTROLS" + CRLF + CRLF
      wr := wr + "FORM OPTIONS" + CRLF + CRLF
      wr := wr + "Menu Builder." + CRLF
      wr := wr + "Select dropedownmenu in form toolbar Menus button the apropiate option" + CRLF
      wr := wr + "Can build MAIN, CONTEXT or NOTIFY menus." + CRLF + CRLF
      wr := wr + "Form Properties." + CRLF
      wr := wr + "Select toolbar Properties button." + CRLF + CRLF
      wr := wr + "Form Events." + CRLF
      wr := wr + "Select toolbar Events button." + CRLF + CRLF
      wr := wr + "Form Font/Color and backcolor" + CRLF
      wr := wr + "Select toolbar Font/Color button." + CRLF + CRLF
      wr := wr + "Control Order (tab order)." + CRLF
      wr := wr + "Select toolbar Order button and move controls Up/down." + CRLF + CRLF
      wr := wr + "Toolbar builder." + CRLF
      wr := wr + "Select toolbar 'Toolbar' button." + CRLF + CRLF
      wr := wr + "Statusbar Builder." + CRLF
      wr := wr + "In order to use statusbar must be ON." + CRLF + CRLF + CRLF

      wr := wr + "CONTROL OPTIONS." + CRLF + CRLF
      wr := wr + "Adding controls." + CRLF
      wr := wr + "Select control type on left toolbar with mouse, and click over design form." + CRLF + CRLF

      wr := wr + "Change control properties in 2 ways." + CRLF
      wr := wr + "1) Selecting control with mouse, and push the toolbar control  button Properties" + CRLF
      wr := wr + "2) Selecting control with mouse, and select properties on context menu" + CRLF + CRLF

      wr := wr + "Change control events in 2 ways." + CRLF
      wr := wr + "1) Selecting control with mouse, and push the toolbar control  button Events" + CRLF
      wr := wr + "2) Selecting control with mouse, and select Events on context menu" + CRLF + CRLF

      wr := wr + "Change Font/Color and Backcolor in 2 ways." + CRLF
      wr := wr + "1) Selecting control with mouse, and push the toolbar control button Font/Colors" + CRLF
      wr := wr + "2) Selecting control with mouse, and select Font/Color on context menu" + CRLF + CRLF

      wr := wr + "Move controls in 4 ways." + CRLF
      wr := wr + "1) Selecting control with mouse, and push the toolbar button Interactive move" + CRLF
      wr := wr + "2) Selecting control with mouse, and select Interactive move on context menu" + CRLF
      wr := wr + "3) Selecting control with mouse, and push the toolbar button Manual move/size" + CRLF
      wr := wr + "4) Drag upper left corner" + CRLF
      wr := wr + "When use 1,2 or 3 option can move control with mouse or keyboard" + CRLF + CRLF

      wr := wr + "Resize controls in 4 ways." + CRLF
      wr := wr + "1) Selecting control with mouse, and push the toolbar button Interactive size" + CRLF
      wr := wr + "2) Selecting control with mouse, and select Interactive size on context menu" + CRLF
      wr := wr + "3) Selecting control with mouse, and push the toolbar button Manual move/size" + CRLF
      wr := wr + "4) Drag lower right corner" + CRLF
      wr := wr + "When use 1,2 or 3 option can resize control with mouse or keyboard" + CRLF + CRLF

      wr := wr + "Delete controls in 3 ways." + CRLF
      wr := wr + "1) Selecting control with mouse, and push the toolbar button delete" + CRLF
      wr := wr + "2) Selecting control with mouse, and select delete on context menu" + CRLF
      wr := wr + "3) Selecting control with mouse, and press the delete key" + CRLF + CRLF
   ENDCASE

   SET INTERACTIVECLOSE ON
   DEFINE WINDOW FAyuda ;
      AT 10, 10 ;
      WIDTH 620 HEIGHT 460 ;
      TITLE 'Help' ;
      ICON 'IDE_EDIT' ;
      MODAL ;
      BACKCOLOR myIde:aSystemColor

      ON KEY ESCAPE OF FAyuda ACTION FAyuda.Release()

      @ 0, 0 EDITBOX EDIT_1 ;
      WIDTH 613 ;
      HEIGHT 435 ;
      VALUE wr ;
      READONLY ;
      FONT 'Times new Roman' ;
      SIZE 12

   END WINDOW

   CENTER WINDOW FAyuda
   ACTIVATE WINDOW FAyuda
   SET INTERACTIVECLOSE OFF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Report_Edit( cFileRep ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nCount, i
LOCAL cTitle := ''
LOCAL aHeaders := '{},{}'
LOCAL aFields := '{}'
LOCAL aWidths := '{}'
LOCAL aTotals := ''
LOCAL nFormats := ''
LOCAL nLPP := 50
LOCAL nCPL := 80
LOCAL nLMargin := 0
LOCAL cPaperSize := 'DMPAPER_LETTER'
LOCAL cAlias := ''
LOCAL lDos := .F.
LOCAL lPreview := .F.
LOCAL lSelect := .F.
LOCAL lMul := .F.
LOCAL cGraphic := " '     ' at 0,0 to 0,0"
LOCAL cGrpBy := ''
LOCAL cHdrGrp := ''
LOCAL lLandscape := .F.
LOCAL Output
LOCAL aLabels
LOCAL aInitValues
LOCAL aFormats
LOCAL aResults
LOCAL cReport

   ::aLineR := {}
   cReport := MemoRead( cFileRep )
   IF File( cFileRep )
      nCount := MLCount( cReport )
      FOR i := 1 TO nCount
         aAdd( ::aLineR, MemoLine( cReport, 500, i ) )
      NEXT i
      cTitle     := ::LeaDatoR( 'REPORT', 'TITLE', '' )
      aHeaders   := ::LeaDatoR( 'REPORT', 'HEADERS', '{},{}' )
      aFields    := ::LeaDatoR( 'REPORT', 'FIELDS', '{}' )
      aWidths    := ::LeaDatoR( 'REPORT', 'WIDTHS', '{}' )
      aTotals    := ::LeaDatoR( 'REPORT', 'TOTALS', '' )
      nFormats   := ::LeaDatoR( 'REPORT', 'NFORMATS', '' )
      nLPP       := Val( ::LeaDatoR( 'REPORT', 'LPP', '55' ) )
      nCPL       := Val( ::LeaDatoR( 'REPORT', 'CPL', '80' ) )
      nLMargin   := Val( ::LeaDatoR( 'REPORT', 'LMARGIN', '' ) )
      cPaperSize := ::LeaDatoR( 'REPORT', 'PAPERSIZE', '' )
      cAlias     := ::LeaDatoR( 'REPORT', 'WORKAREA', '' )
      lDos       := ::LeaDatoLogicR( 'REPORT', 'DOSMODE', .F.)
      lPreview   := ::LeaDatoLogicR( 'REPORT', 'PREVIEW', .F.)
      lSelect    := ::LeaDatoLogicR( 'REPORT', 'SELECT', .F.)
      lMul       := ::LeaDatoLogicR( 'REPORT', 'MULTIPLE', .F.)
      cGraphic   := ::LeaDatoR( 'REPORT', 'IMAGE', '')
      cGrpBy     := ::LeaDatoR( 'REPORT', 'GROUPED BY', '' )
      cHdrGrp    := ::CleanR( ::LeaDatoR( 'REPORT', 'HEADRGRP', '' ) )
      lLandscape := ::LeaDatoLogicR( 'REPORT', 'LANDSCAPE', .F. )
   ENDIF

   aLabels     := { 'Title', 'Headers', 'Fields', 'Widths ', 'Totals', 'Nformats', 'Workarea', 'Lpp', 'Cpl', 'Lmargin', 'Dosmode', 'Preview', 'Select', 'Image / at - to', 'Multiple', 'Grouped by', 'Group header', 'Landscape', 'Papersize' }
   aInitValues := { cTitle,  aHeaders,  afields,  awidths,   atotals,  nformats,   calias,     nlpp,  ncpl,  nLMargin, ldos,      lpreview,  lselect,  cgraphic,          lmul,       cgrpby,       cHdrGrp,        lLandscape,   cpapersize }
   aFormats    := { 320,     320,       320,      160,       160,      320,        20,         '999', '999', '999',     .F.,       .T.,       .F.,      50,                .F.,        50,           28,             .F.,         30 }
   aResults    := ::myInputWindow( "Report parameters of " + cFileRep, aLabels, aInitValues, aFormats )
   IF aResults[1] == NIL
      RETURN NIL
   ENDIF

   Output := 'DO REPORT ;' + CRLF
   Output += "TITLE " + aResults[1] + ' ;' + CRLF
   Output += "HEADERS " + aResults[2] + ' ;' + CRLF
   Output += "FIELDS " + aResults[3] + ' ;' + CRLF
   Output += "WIDTHS " + aResults[4] + ' ;' + CRLF
   IF Len( aResults[5] ) > 0
      Output += "TOTALS " + aResults[5] + ' ;' + CRLF
   ENDIF
   IF Len( aResults[6] ) > 0
      Output += "NFORMATS " + aResults[6] + ' ;' + CRLF
   ENDIF
   Output += "WORKAREA " + aResults[7] + ' ;' + CRLF
   Output += "LPP " + Str( aResults[8], 3 ) + ' ;' + CRLF
   Output += "CPL " + Str( aResults[9], 3 ) + ' ;' + CRLF
   IF aResults[10] > 0
      Output += "LMARGIN " + Str( aResults[10], 3 ) + ' ;' + CRLF
   ENDIF
   IF Len( aResults[19] ) > 0
      Output += "PAPERSIZE " + Upper( aResults[19] ) + ' ;' + CRLF
   ENDIF
   IF aResults[11]
      Output += "DOSMODE " + ' ;' + CRLF
   ENDIF
   IF aResults[12]
      Output += "PREVIEW " + ' ;' + CRLF
   ENDIF
   IF aResults[13]
      Output += "SELECT " + ' ;' + CRLF
   ENDIF
   IF Len( aResults[14] ) > 0
      Output += "IMAGE " + aResults[14] + ' ;' + CRLF
   ENDIF
   IF aResults[15]
      Output += "MULTIPLE " + ' ;' + CRLF
   ENDIF
   IF Len( aResults[16] ) > 0
      Output += "GROUPED BY " + aResults[16] + ' ;' + CRLF
   ENDIF
   IF Len( aResults[17] ) > 0
      Output += "HEADRGRP " + "'" + aResults[17] + "'" + ' ;' + CRLF
   ENDIF
   IF aResults[18]
      Output += "LANDSCAPE " + ' ;' + CRLF
   ENDIF
   Output += CRLF + CRLF
   IF HB_MemoWrit( cFileRep, Output )
      MsgInfo( 'Report saved.', 'OOHG IDE+' )
   ELSE
      MsgInfo( 'Error saving report.', 'OOHG IDE+' )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD LeaDatoR( cName, cPropmet, cDefault ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL i, sw, cFValue, nPos

   sw := 0
   FOR i := 1 TO Len( ::aLineR )
      IF ! At( Upper( cName ) + ' ', Upper( ::aLineR[i] ) ) == 0
         sw := 1
      ELSE
         IF sw == 1
            nPos := At( Upper( cPropmet ) + ' ', Upper( ::aLineR[i] ) )
            IF Empty( ::aLineR[i] )
               RETURN cDefault
            ENDIF
            IF nPos > 0
               cFValue := SubStr( ::aLineR[i], nPos + Len( cPropmet ), Len( ::aLineR[i] ) )
               cFValue := AllTrim( cFValue )
               IF Right( cFValue, 1 ) == ';'
                  cFValue := SubStr( cFValue, 1, Len( cFValue ) - 1 )
               ELSE
                  cFValue := SubStr( cFValue, 1, Len( cFValue ) )
               ENDIF
               RETURN AllTrim( cFValue )
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD LeaDatoLogicR( cName, cPropmet, cDefault ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL i, sw := 0

   FOR i := 1 TO Len( ::aLineR )
      IF At( Upper( cName ) + ' ', Upper( ::aLineR[i] ) ) # 0
         sw := 1
      ELSE
         IF sw == 1
            IF At( Upper( cPropmet ) + ' ', Upper( ::aLineR[i] ) ) > 0
               RETURN .T.
            ENDIF
            IF Empty( ::aLineR[i] )
               RETURN cDefault
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD CleanR( cFValue ) CLASS THMI
//------------------------------------------------------------------------------
   cFValue  :=  StrTran( cFValue, '"', '' )
   cFValue  :=  StrTran( cFValue, "'", "" )
RETURN cFValue


#pragma BEGINDUMP

#include <windows.h>
#include <winuser.h>
#include "hbapi.h"

#define VK1_A 65
#define VK1_C 67
#define VK1_V 86
#define VK1_X 88

/* select all - ctrl-a */
HB_FUNC( SEND_SELECTALL )
{
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
   keybd_event(VK1_A, MapVirtualKey(VK1_A, 0), 0, 0);
   keybd_event(VK1_A, MapVirtualKey(VK1_A, 0), KEYEVENTF_KEYUP, 0);
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
}

/* copy - ctrl-c */
HB_FUNC( SEND_COPY )
{
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
   keybd_event(VK1_C, MapVirtualKey(VK1_C, 0), 0, 0);
   keybd_event(VK1_C, MapVirtualKey(VK1_C, 0), KEYEVENTF_KEYUP, 0);
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
}

/* paste - ctrl-v */
HB_FUNC( SEND_PASTE )
{
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
   keybd_event(VK1_V, MapVirtualKey(VK1_V, 0), 0, 0);
   keybd_event(VK1_V, MapVirtualKey(VK1_V, 0), KEYEVENTF_KEYUP, 0);
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
}

/* cut - ctrl-x */
HB_FUNC( SEND_CUT )
{
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
   keybd_event(VK1_X, MapVirtualKey(VK1_X, 0), 0, 0);
   keybd_event(VK1_X, MapVirtualKey(VK1_X, 0), KEYEVENTF_KEYUP, 0);
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
}

HB_FUNC ( ZAPDIRECTORY )
{
   SHFILEOPSTRUCT sh;

   sh.hwnd = GetActiveWindow();
   sh.wFunc = FO_DELETE;
   sh.pFrom = hb_parc( 1 );
   sh.pTo = NULL;
   sh.fFlags = FOF_NOCONFIRMATION | FOF_SILENT;
   sh.hNameMappings = 0;
   sh.lpszProgressTitle = NULL;

   SHFileOperation( &sh );
}

#pragma ENDDUMP


CLASS myTProgressBar FROM TProgressBar
   METHOD Events
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS myTProgressBar
*------------------------------------------------------------------------------*
   IF nMsg == WM_LBUTTONUP
      ::DoEventMouseCoords( ::OnClick, "CLICK" )
   ENDIF
RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )


CLASS myTRadioGroup FROM TRadioGroup
   METHOD DoChange
ENDCLASS

*------------------------------------------------------------------------------*
METHOD DoChange() CLASS myTRadioGroup
*------------------------------------------------------------------------------*
   _OOHG_Eval( ::OnRClick )
RETURN ::Super:DoChange()

/*
 * EOF
 */
