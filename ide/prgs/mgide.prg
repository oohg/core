/*
 * $Id: mgide.prg,v 1.20 2014-09-29 02:17:18 fyurisich Exp $
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
#include "common.ch"
#include "i_windefs.ch"

#DEFINE CRLF hb_OSNewLine()
#DEFINE CR chr(13)
#DEFINE LF chr(10)
#DEFINE HTAB chr(9)
#DEFINE cNameApp "Harbour ooHG IDE Plus"+" v."+substr(__DATE__,3,2)+"."+right(__DATE__,4) 

#ifdef __HARBOUR__
   #xtranslate Curdrive() => hb_Curdrive()    
#endif

//------------------------------------------------------------------------------
FUNCTION Main( rtl )
//------------------------------------------------------------------------------
LOCAL myIde

   SetAppHotKey( VK_F10, 0, { || _OOHG_CallDump() } )
   SetAppHotKey( VK_F11, 0, { || AutoMsgBox( &( InputBox( "Variable to inspect:", "ooHG IDE+" ) ) ) } )

   If rtl # NIL
      rtl := Upper( rtl )
      If rtl == "RTL"
         SET GLOBALRTL ON
         rtl := NIL
      EndIf
   EndIf

   myIde := THMI()
   myIde:NewIde( rtl )
RETURN NIL

//------------------------------------------------------------------------------
CLASS THMI
//------------------------------------------------------------------------------
   DATA aEditors           INIT {}
   DATA aliner             INIT {}
   DATA aSystemColor       INIT {215, 231, 244}
   DATA aSystemColorAux    INIT  {}
   DATA cBCCFolder         INIT ''
   DATA cExteditor         INIT ''
   DATA cfile              INIT ''
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
   DATA clib               INIT ""
   DATA cMinGWFolder       INIT ''
   DATA cOutFile           INIT ''
   DATA cPellFolder        INIT ''
   DATA cprojectname       INIT ''
   DATA cProjFolder        INIT ''
   DATA ctext              INIT ''
   DATA cxHbBCCFolder      INIT ''
   DATA cxHbMinGWFolder    INIT ''
   DATA cxHbPellFolder     INIT ''
   DATA Form_Edit          INIT NIL
   DATA Form_Prefer        INIT NIL
   DATA Form_Splash        INIT NIL
   DATA Form_Tree          INIT NIL
   DATA lCloseOnFormExit   INIT .F.
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
   DATA ntemp              INIT 0
   DATA nTextBoxHeight     INIT 0
   DATA swsalir            INIT .F.
   DATA swvan              INIT .F.
   DATA van                INIT 0
   DATA Form_Wait          INIT NIL

   METHOD About
   METHOD AjustaFrame
   METHOD Analizar
   METHOD BldMinGW
   METHOD BldPellC
   METHOD BuildBcc
   METHOD CleanR
   METHOD DatabaseView
   METHOD DataMan
   METHOD DeleteItemP
   METHOD Disable_Button
   METHOD EditorExit
   METHOD Exit
   METHOD GoLine
   METHOD LeaDatoLogicR
   METHOD LeaDatoR
   METHOD LookChanges
   METHOD ModifyForm
   METHOD ModifyItem
   METHOD ModifyRpt
   METHOD myInputWindow
   METHOD NewCH
   METHOD NewCHFromAr
   METHOD NewForm
   METHOD NewFormFromAr
   METHOD NewIde
   METHOD NewPrg
   METHOD NewPrgFromAr
   METHOD NewProject
   METHOD NewRC
   METHOD NewRCFromAr
   METHOD NewRpt
   METHOD NewRptFromAr
   METHOD NextSearch
   METHOD OkPrefer
   METHOD OpenAuxi
   METHOD OpenFile
   METHOD OpenProject
   METHOD PosXY
   METHOD Preferences
   METHOD PrintIt
   METHOD ReadINI
   METHOD Reforma
   METHOD Repo_Edit
   METHOD RunP
   METHOD SaveAndExit
   METHOD SaveFile
   METHOD SaveINI
   METHOD SaveProject
   METHOD SearchItem
   METHOD SearchText
   METHOD SearchType
   METHOD SearchTypeAdd
   METHOD SplashDelay
   METHOD TxtSearch
   METHOD ViewErrors
   METHOD ViewSource
   METHOD xBldMinGW
   METHOD xBldPellC
   METHOD xBuildBCC

ENDCLASS

//------------------------------------------------------------------------------
METHOD NewIde( rtl ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nPos, nRed, nGreen, nBlue, lCorre, pmgFolder, nEsquema, cvcx, cvcy

   SET CENTURY ON
   SET EXACT ON
   SET INTERACTIVECLOSE OFF
   SET NAVIGATION EXTENDED
   SET BROWSESYNC ON

   ::cProjFolder := GetCurrentFolder()
   ::cIDE_Folder := GetStartupFolder()

   lCorre := .F.
   IF rtl # NIL
      rtl := Lower( rtl )
      nPos := At( ".", rtl )
      IF nPos > 0
         ::cFile := SubStr( rtl, 1, nPos - 1 )
         IF Lower( SubStr( rtl, nPos + 1, 3 ) ) == "pmg" .AND. ! Empty( ::cFile )
            lCorre := .T.
            ::cFile += ".pmg"
         ENDIF
      ELSE
         ::cFile := rtl + ".fmg"
      ENDIF
   ENDIF

   nEsquema := 4        // COLOR_MENU, Menu background color
   nRed     := GetRed( GetSysColor( nEsquema ) )
   nGreen   := GetGreen( GetSysColor( nEsquema ) )
   nBlue    := GetBlue( GetSysColor( nEsquema ) )
   ::aSystemColorAux := &( '{' + Str( nRed, 3 ) + ',' + Str( nGreen, 3 ) + ',' + Str( nBlue, 3 ) + '}' )

   cvcx :=getdesktopwidth()
   cvcy :=getdesktopheight()

   IF cvcx < 800 .OR. cvcy < 600
      MsgInfo( 'Best viewed with 800x600 or greater resolution.', 'ooHG IDE+' )
   ENDIF

   DEFINE WINDOW Form_Tree OBJ ::Form_Tree ;
      AT 0, 0 ;
      WIDTH 800 ;
      HEIGHT 600 ;
      TITLE cNameApp ;
      MAIN ;
      FONT "Times new Roman" SIZE 11 ;
      ICON "Edit" ;
      ON SIZE ::AjustaFrame() ;
      ON INTERACTIVECLOSE IIF( MsgYesNo( "Exit program?", 'ooHG IDE+' ), ::Exit(), .F. ) ;
      NOSHOW ;
      BACKCOLOR ::aSystemColor

      DEFINE STATUSBAR FONT "Verdana" SIZE 9       
         STATUSITEM cNameApp+"                                 F1 Help    F5 Build    F6 Build / Run    F7 Run    F8 Debug"
      END STATUSBAR

      DEFINE MAIN MENU
         POPUP '&File'
            ITEM '&New project ' ACTION ::newproject()
            ITEM '&Open Project' ACTION ::openproject()
            ITEM '&Save Project' ACTION ::saveproject()
            SEPARATOR
            ITEM '&Preferences' ACTION ::preferences()
            SEPARATOR
            ITEM '&Exit' ACTION ::exit()
         END POPUP
         POPUP 'Pro&ject'
            POPUP 'Add' NAME 'Add'                    
               ITEM 'Form ' ACTION ::newform()
               ITEM 'Prg  ' ACTION ::newprg()
               ITEM 'CH   ' ACTION ::newch()
               ITEM 'Rpt  ' ACTION ::newrpt()
               ITEM 'RC   ' ACTION ::newrc()
            END POPUP
            SEPARATOR
            ITEM "Modify item" Action ::Analizar()
            SEPARATOR
            ITEM 'Remove Item' ACTION ::deleteitemp()
            SEPARATOR
            ITEM 'View / Print Item' ACTION ::printit()
         END POPUP
         POPUP 'Build / Run / Debug'
            ITEM 'Build Project'         ACTION CompileOptions( Self, 1 )
            ITEM 'Build and Run Project' ACTION CompileOptions( Self, 2 )
            ITEM 'Run Project'           ACTION CompileOptions( Self, 3 )
            ITEM 'Debug Project'         ACTION CompileOptions( Self, 4 )
         END POPUP
         POPUP 'Tools'
            ITEM 'Global Search Text'  ACTION ::searchtext()
            ITEM 'Quickbrowse'  ACTION ::databaseview()
            ITEM 'Data Manager'  ACTION ::dataman()
         END POPUP

         POPUP '&Help'
            ITEM 'ooHG Syntax Help' ACTION _Execute( GetActiveWindow(), Nil, ::cIDE_Folder + "\oohg.chm", Nil, Nil, 5 )
            ITEM '&About' ACTION ::about()
            ITEM 'Shell info' ACTION shellabout(cNameApp,"Shell info")
         END POPUP
      END MENU

      ON KEY F1 ACTION Help_F1( 'PROJECT', Self )
      ON KEY F5 ACTION CompileOptions( Self, 1 )
      ON KEY F6 ACTION CompileOptions( Self, 2 )
      ON KEY F7 ACTION CompileOptions( Self, 3 )
      ON KEY F8 ACTION CompileOptions( Self, 4 )

      @ 65,30 FRAME frame_tree WIDTH cvcx-30 HEIGHT cvcy-65

      DEFINE TREE Tree_1 AT 90,50 WIDTH 200 HEIGHT cvcy-290 VALUE 1 ;
         TOOLTIP 'Double click to modify items'   ;
         ON DBLCLICK ::Analizar() ;
         NODEIMAGES { "cl_fl", "op_fl"};
         ITEMIMAGES { "doc", "doc_fl" };

         NODE 'Project'  IMAGES { "doc" }
            TREEITEM 'Form module'
            TREEITEM 'Prg module'
            TREEITEM 'CH module'
            TREEITEM 'Rpt module'
            TREEITEM 'RC module'
         END NODE

      END TREE

      DEFINE SPLITBOX
         DEFINE TOOLBAR ToolBar_1y BUTTONSIZE 16,16 FLAT ;
            FONT 'Times new roman' SIZE 10 ITALIC

            BUTTON Button_13 ;
            TOOLTIP 'Exit ' ;
            PICTURE 'M1';
            ACTION If( MsgYesNo( "Exit program?", 'ooHG IDE+' ), ::exit(), Nil ) AUTOSIZE

            BUTTON Button_1 ;
            TOOLTIP 'New...' ;
            PICTURE 'M2';
            ACTION ::newform() DROPDOWN AUTOSIZE

            BUTTON Button_1b ;
            TOOLTIP 'Open...' ;
            PICTURE 'M3';
            ACTION ::openproject() AUTOSIZE

            BUTTON Button_01 ;
            TOOLTIP 'Save...' ;
            PICTURE 'M4';
            ACTION ::saveproject() AUTOSIZE

            BUTTON Button_7 ;
            TOOLTIP 'Remove Item' ;
            PICTURE 'M5' ;
            ACTION ::deleteitemp() AUTOSIZE

            BUTTON Button_7a ;
            TOOLTIP 'View / Print Item' ;
            Picture 'M6' ;
            ACTION ::printit() separator AUTOSIZE

            BUTTON Button_9 ;
            TOOLTIP 'Build project' ;
            PICTURE 'M7';
            ACTION CompileOptions( Self, 1 )

            BUTTON Button_10 ;
            TOOLTIP 'Build / Run' ;
            PICTURE 'M8' ;
            ACTION CompileOptions( Self, 2 )

            BUTTON Button_11 ;
            TOOLTIP 'Run' ;
            PICTURE 'M9';
            ACTION CompileOptions( Self, 3 ) DROPDOWN AUTOSIZE separator

            BUTTON Button_8 ;
            TOOLTIP 'Global Search Text' ;
            PICTURE 'M10';
            ACTION ::Searchtext() separator AUTOSIZE

            BUTTON Button_qb ;
            TOOLTIP 'Quick Browse' ;
            PICTURE 'M11';
            ACTION ::databaseview() AUTOSIZE

            BUTTON Button_12 ;
            TOOLTIP 'Data Manager' ;
            PICTURE 'M12';
            ACTION ::dataman() AUTOSIZE
         END TOOLBAR

         DEFINE DROPDOWN MENU BUTTON Button_1
            ITEM 'Form'    ACTION ::newform()
            ITEM 'Prg'     ACTION ::newprg()
            ITEM 'CH'      ACTION ::newch()
            ITEM 'Rpt'     ACTION ::newrpt()
            ITEM 'RC'      ACTION ::newrc()
         END MENU

         DEFINE DROPDOWN MENU BUTTON Button_11
            ITEM 'Run  ' ACTION CompileOptions( Self, 3 )
            ITEM 'Debug' ACTION CompileOptions( Self, 4 )
         END MENU
      END SPLITBOX

      @ 135,280 IMAGE image_front ;
         PICTURE 'hmiq' ;
         WIDTH 420 ;
         HEIGHT 219

      ::Form_Tree:tree_1:fontitalic:=.T.

      IF Empty( rtl )
         ::Form_Tree:Add:Enabled := .F.
         ::Form_Tree:Button_1:Enabled := .F.
      ELSE
         ::Form_Tree:Add:Enabled := .T.
         ::Form_Tree:Button_1:Enabled := .T.
      ENDIF
   END WINDOW

   DEFINE WINDOW Form_Splash OBJ ::Form_Splash ;
      AT 0,0 ;
      WIDTH 584 HEIGHT 308 ;
      TITLE '';
      MODAL TOPMOST NOCAPTION ;
      ON INIT ::SplashDelay()

      @ 0,0 IMAGE image_splash PICTURE 'hmi'  ;
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
      TITLE "Information"  ;
      CHILD ;
      NOSYSMENU ;
      NOCAPTION ;
      NOSHOW  ;
      BACKCOLOR ::aSystemColor

      @ 35, 15 LABEL hmi_label_101 VALUE '              '  AUTOSIZE FONT 'Times new Roman' SIZE 14
   END WINDOW

   CENTER WINDOW Form_Wait

   IF lCorre
      // Project
      pmgFolder := OnlyFolder( ::cFile )
      IF ! Empty( pmgFolder )
         ::cProjFolder := pmgFolder
         DirChange( pmgFolder )
      ENDIF
      ::OpenAuxi()
      ACTIVATE WINDOW Form_Tree, Form_Wait, Form_Splash
   ELSEIF rtl # NIL
      // Form
      ::lCloseOnFormExit := .T.
      ::ReadINI( ::cProjFolder + "\hmi.ini" )
      ::Form_Tree:Hide()
      ACTIVATE WINDOW Form_Tree, Form_Wait, Form_Splash NOWAIT
      ::Analizar( ::cFile )
   ELSE
      // None
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
   If File( cFolder + "\OBJ\nul" )
      ZapDirectory( cFolder + "\OBJ" + Chr(0) )
   EndIf
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
METHOD Analizar( cForm ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL cItem, cParent, lWait

   IF HB_IsString( cForm )
      cItem   := cForm
      cParent := "Form module"
      lWait   := .T.
   ELSE
      cItem   := ::Form_Tree:Tree_1:Item( ::Form_Tree:Tree_1:value )
      cParent := ::SearchType( cItem )
      lWait   := .F.
   ENDIF
   IF cParent == 'Form module' .AND. cItem # cParent .AND. cItem # 'Project'
      IF Len( ::aEditors ) > 0                // TODO: more than one form at the same time
         MsgStop( "Sorry, the IDE can't edit more than one form at a time.", 'ooHG IDE+' )
      ELSE
         ::ModifyForm( cItem, cParent, lWait )
      ENDIF
   ELSEIF ( cParent == 'Prg module' .AND. cItem # cParent .AND. cItem # 'Project' ) .OR. ;
          ( cParent == 'CH module' .AND. cItem # cParent )  .OR. ;
          ( cParent == 'RC module' .AND. cItem # cParent )
      ::ModifyItem( cItem, cParent )
   ELSEIF cParent == 'Rpt module' .AND. cItem # cParent .AND. cItem # 'Project'
      ::ModifyRpt( cItem, cParent )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ReadINI( cFile ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL lSnap

   IF ! File( cFile )
      HB_MemoWrit( cFile, '[PROJECT]' )
   ENDIF

   BEGIN INI FILE cFile
      //****************** PROJECT
      GET ::cOutFile          SECTION 'PROJECT'   ENTRY "OUTFILE"         DEFAULT ''
      //****************** EDITOR
      GET ::cExteditor        SECTION 'EDITOR'    ENTRY "EXTERNAL"        DEFAULT ''
      //****************** FORM'S FONT
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
      //****************** OOHG
      GET ::cGuiHbMinGW       SECTION 'GUILIB'    ENTRY "GUIHBMINGW"      DEFAULT 'c:\oohg'
      GET ::cGuiHbBCC         SECTION 'GUILIB'    ENTRY "GUIHBBCC"        DEFAULT 'c:\oohg'
      GET ::cGuiHbPelles      SECTION 'GUILIB'    ENTRY "GUIHBPELL"       DEFAULT 'c:\oohg'
      GET ::cGuixHbMinGW      SECTION 'GUILIB'    ENTRY "GUIXHBMINGW"     DEFAULT 'c:\oohg'
      GET ::cGuixHbBCC        SECTION 'GUILIB'    ENTRY "GUIXHBBCC"       DEFAULT 'c:\oohg'
      GET ::cGuixHbPelles     SECTION 'GUILIB'    ENTRY "GUIXHBPELL"      DEFAULT 'c:\oohg'
      //****************** HARBOUR
      GET ::cHbMinGWFolder    SECTION 'HARBOUR'   ENTRY "HBMINGW"         DEFAULT 'c:\harbourm'
      GET ::cHbBCCFolder      SECTION 'HARBOUR'   ENTRY "HBBCC"           DEFAULT 'c:\harbourb'
      GET ::cHbPellFolder     SECTION 'HARBOUR'   ENTRY "HBPELLES"        DEFAULT 'c:\harbourp'
      //****************** XHARBOUR
      GET ::cxHbMinGWFolder   SECTION 'HARBOUR'   ENTRY "XHBMINGW"        DEFAULT 'c:\xharbourm'
      GET ::cxHbBCCFolder     SECTION 'HARBOUR'   ENTRY "XHBBCC"          DEFAULT 'c:\xharbourb'
      GET ::cxHbPellFolder    SECTION 'HARBOUR'   ENTRY "XHBPELLES"       DEFAULT 'c:\xharbourp'
      //****************** C COMPILER
      GET ::cMinGWFolder      SECTION 'COMPILER'  ENTRY "MINGWFOLDER"     DEFAULT 'c:\MinGW'
      GET ::cBCCFolder        SECTION 'COMPILER'  ENTRY "BCCFOLDER"       DEFAULT 'c:\Borland\BCC55'
      GET ::cPellFolder       SECTION 'COMPILER'  ENTRY "PELLESFOLDER"    DEFAULT 'c:\PellesC'
      //****************** MODE
      GET ::nCompxBase        SECTION 'WHATCOMP'  ENTRY "XBASECOMP"       DEFAULT 1  // 1 Harbour  2 xHarbour
      GET ::nCompilerC        SECTION 'WHATCOMP'  ENTRY "CCOMPILER"       DEFAULT 1  // 1 MinGW    2 BCC   3 Pelles C
      //****************** OTHER
      GET ::lTBuild           SECTION 'SETTINGS'  ENTRY "BUILD"           DEFAULT 2  // 1 Compile.bat 2 Own Make
      GET lSnap               SECTION 'SETTINGS'  ENTRY "SNAP"            DEFAULT 0
      ::lSnap := ( lSnap == 1 )
      GET ::clib              SECTION 'SETTINGS'  ENTRY "LIB"             DEFAULT ''
   END INI
RETURN NIL

//------------------------------------------------------------------------------
METHOD SaveINI( cFile ) CLASS THMI
//------------------------------------------------------------------------------

   BEGIN INI FILE cFile
      //****************** PROJECT
      SET SECTION 'PROJECT'     ENTRY "PROJFOLDER"    TO ::cProjFolder
      SET SECTION 'PROJECT'     ENTRY "OUTFILE"       TO ::cOutFile
      //****************** EDITOR
      SET SECTION "EDITOR"      ENTRY "EXTERNAL"      TO ::cExteditor
      //****************** FORM'S FONT
      SET SECTION "FORMFONT"    ENTRY "FONT"          TO IIF( Empty( ::cFormDefFontName ), 'NIL', ::cFormDefFontName )
      SET SECTION "FORMFONT"    ENTRY "SIZE"          TO LTrim( Str( ::nFormDefFontSize, 2, 0 ) )
      SET SECTION "FORMFONT"    ENTRY "COLOR"         TO ::cFormDefFontColor
      // ****************** FORM'S METRICS
      SET SECTION "FORMMETRICS" ENTRY "LABELHEIGHT"   TO LTrim( Str( ::nLabelHeight, 2, 0 ) )
      SET SECTION "FORMMETRICS" ENTRY "TEXTBOXHEIGHT" TO LTrim( Str( ::nTextBoxHeight, 2, 0 ) )
      SET SECTION "FORMMETRICS" ENTRY "STDVERTGAP"    TO LTrim( Str( ::nStdVertGap, 3, 0 ) )
      SET SECTION "FORMMETRICS" ENTRY "PXMOVE"        TO LTrim( Str( ::nPxMove, 2, 0 ) )
      SET SECTION "FORMMETRICS" ENTRY "PXSIZE"        TO LTrim( Str( ::nPxSize, 2, 0 ) )
      //****************** OOHG
      SET SECTION 'GUILIB'      ENTRY "GUIHBMINGW"    TO ::cGuiHbMinGW
      SET SECTION 'GUILIB'      ENTRY "GUIHBBCC"      TO ::cGuiHbBCC
      SET SECTION 'GUILIB'      ENTRY "GUIHBPELL"     TO ::cGuiHBPelles
      SET SECTION 'GUILIB'      ENTRY "GUIXHBMINGW"   TO ::cGuixHbMinGW
      SET SECTION 'GUILIB'      ENTRY "GUIXHBBCC"     TO ::cGuixHbBCC
      SET SECTION 'GUILIB'      ENTRY "GUIXHBPELL"    TO ::cGuixHBPelles
      //****************** HARBOUR
      SET SECTION 'HARBOUR'     ENTRY "HBMINGW"       TO ::cHbMinGWFolder
      SET SECTION 'HARBOUR'     ENTRY "HBBCC"         TO ::cHbBCCFolder
      SET SECTION 'HARBOUR'     ENTRY "HBPELLES"      TO ::cHbPellFolder
      //****************** XHARBOUR
      SET SECTION 'HARBOUR'     ENTRY "XHBMINGW"      TO ::cxHbMinGWFolder
      SET SECTION 'HARBOUR'     ENTRY "XHBBCC"        TO ::cxHbBCCFolder
      SET SECTION 'HARBOUR'     ENTRY "XHBPELLES"     TO ::cxHbPellFolder
      //****************** C COMPILER
      SET SECTION 'COMPILER'    ENTRY "MINGWFOLDER"   TO ::cMinGWFolder
      SET SECTION 'COMPILER'    ENTRY "BCCFOLDER"     TO ::cBCCFolder
      SET SECTION 'COMPILER'    ENTRY "PELLESFOLDER"  TO ::cPellFolder
      //****************** MODE
      SET SECTION 'WHATCOMP'    ENTRY "XBASECOMP"     TO LTrim( Str( ::nCompxBase, 1, 0 ) )
      SET SECTION 'WHATCOMP'    ENTRY "CCOMPILER"     TO LTrim( Str( ::nCompilerC, 1, 0 ) )
      //****************** OTHER
      SET SECTION "SETTINGS"    ENTRY "BUILD"         TO LTrim( Str( ::ltbuild, 1, 0 ) )
      SET SECTION "SETTINGS"    ENTRY "LIB"           TO ::clib
      SET SECTION "SETTINGS"    ENTRY "SNAP"          TO IIF( ::lSnap, 1, 0 )
   END INI
RETURN NIL

//------------------------------------------------------------------------------
METHOD Exit() CLASS THMI
//------------------------------------------------------------------------------
   IF ! ::lPsave
      IF MsgYesNo( 'Project not saved, save it now?', 'ooHG IDE+' )
         ::SaveProject()
      ENDIF
   ENDIF
   IF IsWindowActive( Form_Tree )
      ::Form_Tree:Release()
   endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD PrintIt() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cItem, cParent, cArch

   cItem := ::Form_Tree:Tree_1:Item( ::Form_Tree:Tree_1:value )
   cParent := ::SearchType( cItem )
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
                  MsgInfo( "This item can't be printed.", 'ooHG IDE+' )
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
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=1 )  // Harbour-MinGW
              myIde:BldMinGW(0)
           Endif
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=2 )  // Harbour-BCC
              myIde:BuildBcc(0)
           Endif
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=3 )  // Harbour-PellesC
              myIde:BldPellc(0)
           Endif

           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=1 )  // xHarbour-MinGW
              myIde:xBldMinGW(0)
           Endif
           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=2 )  // xHarbour-BCC
              myIde:xBuildBcc(0)
           Endif
           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=3 )  // xHarbour-PellesC
              myIde:xBldPellc(0)
           Endif

      Case nOpt = 2  // Make and Run
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=1 )  // Harbour-MinGW
              myIde:BldMinGW(1)
           Endif
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=2 )  // Harbour-BCC
              myIde:BuildBcc(1)
           Endif
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=3 )  // Harbour-PellesC
              myIde:BldPellc(1)
           Endif

           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=1 )  // xHarbour-MinGW
              myIde:xBldMinGW(1)
           Endif
           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=2 )  // xHarbour-BCC
              myIde:xBuildBcc(1)
           Endif
           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=3 )  // xHarbour-PellesC
              myIde:xBldPellc(1)
           Endif

      Case nOpt = 3  // Only Run
           myIde:runp()

      Case nOpt = 4  // Debug
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=1 )  // Harbour-MinGW
              myIde:BldMinGW(2)
           Endif
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=2 )  // Harbour-BCC
              myIde:BuildBcc(2)
           Endif
           If ( myIde:nCompxBase=1 .and. myIde:nCompilerC=3 )  // Harbour-PellesC
              myIde:BldPellc(2)
           Endif

           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=1 )  // xHarbour-MinGW
              myIde:xBldMinGW(2)
           Endif
           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=2 )  // xHarbour-BCC
              myIde:xBuildBcc(2)
           Endif
           If ( myIde:nCompxBase=2 .and. myIde:nCompilerC=3 )  // xHarbour-PellesC
              myIde:xBldPellc(2)
           Endif

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
   if oPrint:lPrError
      MsgStop( 'Error detected while printing.', 'ooHG IDE+' )
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
      ICON 'Edit' ;
      MODAL NOSIZE NOSYSMENU ;
      backcolor ::aSystemColor

      @ 1,1    FRAME FRAME1 WIDTH 437 HEIGHT 190

      @ 15,330 Image Myphoto PICTURE 'cvcbmp' width 97 height 69

      @ 85,330 Image MYOOHG  PICTURE 'myoohg' WIDTH 97 HEIGHT 97

      @ 20,20  LABEL LB_NORM VALUE cNameApp ;
      FONT "Times new Roman"  SIZE 10  ;
      AUTOSIZE

      @ 40,20 HYPERLINK LB_MAIL ;
      VALUE "(c) 2002-2012 Ciro Vargas Clemow" ;
      ADDRESS 'pcman2010@yahoo.com' ;
      WIDTH 120 ;
      HEIGHT 24 ;
      AUTOSIZE ;
      FONT "Times new Roman" SIZE 10  ;
      TOOLTIP 'Click to email-me' HANDCURSOR ;

      @ 60,20  LABEL LB_NORM1 VALUE 'Original idea Roberto Lopez. (MiniGUI creator)' ;
      FONT "Times new Roman" SIZE 10  ;
      AUTOSIZE

      @ 80,20  LABEL LB_NORM2 VALUE 'Version '+miniguiversion() ;
      FONT "Times new Roman" SIZE 10  ;
      AUTOSIZE

      @ 100,20  LABEL LB_NORMooHG VALUE 'ooHG Creator  Vicente Guerra' ;
      FONT "Times new Roman" SIZE 10  ;
      AUTOSIZE

      @ 120,20 HYPERLINK LB_HOMEPAGE ;
      VALUE "(c) 2002-2014 ooHG IDE+ Home page" ;
      ADDRESS 'http://sistemascvc.tripod.com' ;
      WIDTH 120 ;
      HEIGHT 24 ;
      AUTOSIZE ;
      FONT "Times new Roman" SIZE 10  ;
      TOOLTIP 'Click to go'  ;
      HANDCURSOR

      @ 140,20  LABEL LB_NORM3 VALUE 'Dedicated to my dear sons, Ciro Andres , Santiago and Esteban.' ;
      FONT "Times new Roman" SIZE 9  ;
      AUTOSIZE

      @ 160,150 button button_1 caption 'Ok' action { || about_form:release } FLAT


   END WINDOW
   about_form:button_1:setfocus()
   CENTER WINDOW about_form
   playhand()
   ACTIVATE WINDOW about_form
RETURN NIL


//------------------------------------------------------------------------------
METHOD DataMan() CLASS THMI
//------------------------------------------------------------------------------
   If ! IsWindowDefined( _dbu )
      DatabaseView1( Self )
   Else
      MsgInfo( 'Data manager is already running.', 'ooHG IDE+' )
   EndIf
   ::Form_Tree:Maximize()
RETURN NIL

//------------------------------------------------------------------------------
METHOD SplashDelay() CLASS THMI
//------------------------------------------------------------------------------
LOCAL iTime

   CursorWait()
   iTime := Seconds()
   DO WHILE Seconds() - iTime < 1
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
   ::Form_Prefer:text_font:value    := IF( Empty( ::cFormDefFontName ), _OOHG_DefaultFontName, ::cFormDefFontName ) + ' ' + ;
                                       LTrim( Str( IF( ::nFormDefFontSize > 0, ::nFormDefFontSize, _OOHG_DefaultFontSize ), 2, 0 ) ) + ;
                                       IF( ::cFormDefFontColor == 'NIL', '', ', Color ' + ::cFormDefFontColor )
   ::Form_Prefer:Radiogroup_3:value := ::lTBuild
   ::Form_Prefer:text_lib:value     := ::cLib
   ::Form_Prefer:checkbox_105:value := ::lSnap

   ::Form_Prefer:checkbox_105:Backcolor := ::Form_Prefer:BackColor

   ACTIVATE WINDOW Form_Prefer

RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION GetPreferredFont( Form_prefer, aFont )
//------------------------------------------------------------------------------
   aFont := GetFont( aFont[1], aFont[2], aFont[3], aFont[4], aFont[5], aFont[6], aFont[7], aFont[8] )
   Form_prefer:text_font:value := ;
      IF( Empty( aFont[1] ), _OOHG_DefaultFontName, aFont[1] ) + " " + ;
      LTrim( Str( IF( aFont[2] > 0, aFont[2], _OOHG_DefaultFontSize ) ) ) + ;
      IF( aFont[3], " Bold", "" ) + ;
      IF( aFont[4], " Italic", "" ) + ;
      IF( aFont[6], " Underline", "" ) + ;
      IF( aFont[7], " Strikeout", "" ) + ;
      IF( aFont[5, 1] # NIL, ", Color " + '{ ' + LTrim( Str( aFont[5, 1] ) ) + ', ' + ;
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
endif
cursorwait()
::Form_Wait:hmi_label_101:value:='Searching....'
::Form_Wait:Show()
nItems:=::Form_Tree:Tree_1:ItemCount
cOutput:=''
For i:= 1  to nItems

    cItem:=::Form_Tree:Tree_1:Item (i)

    if ::searchtypeadd(i)=='RC module' .and. cItem<>'RC module'
       if file(cItem+'.rc')
          cInput:=memoread(cItem+'.rc')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 cOutput += cItem+'  ==> RC module'+'  Line '+str(j,6)+CRLF
              endif
          NEXT j
       endif
    else
    if ::searchtypeadd(i)=='CH module' .and. cItem<>'CH module'
       if file(cItem+'.ch')
          cInput:=memoread(cItem+'.ch')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 cOutput += cItem+'  ==> CH module'+'  Line '+str(j,6)+CRLF
              endif
          NEXT j
       endif
    else
    if (::searchtypeadd(i)=='Prg module') .and.( cItem<>'Prg module')
       if file(citem+'.prg')
          cInput:=memoread(cItem+'.prg')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 coutput += cItem+'  ==> Prg module '+'  Line '+str(j,6)+CRLF
              endif
          NEXT j
       endif
    else
    if (::searchtypeadd(i)=='Form module') .and.( cItem<>'Form module')
       if file(citem+'.fmg')
          cInput:=memoread(cItem+'.fmg')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 coutput += cItem+'  ==> Form module'+'  Line '+str(j,6)+CRLF
              endif
          NEXT j
       endif
    else
    if (::searchtypeadd(i)=='Rpt module') .and.( cItem<>'Rpt module')
       if file(citem+'.rpt')
          cInput:=memoread(cItem+'.rpt')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 coutput += cItem+'  ==> Rpt module'+'  Line '+str(j,6)+CRLF
              endif
          NEXT j
       endif
    endif
    endif
    endif
    endif
    endif
NEXT i
::Form_Wait:Hide()
cursorarrow()
if coutput==''
   MsgInfo( 'Text not found.', 'ooHG IDE+' )
else
   MsgInfo( cTextsearch + ' found in: ' + CRLF + coutput, 'ooHG IDE+' )
endif
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
   ::lSnap              := ::Form_Prefer:checkbox_105:Value
   ::cLib               := ::Form_Prefer:text_lib:Value
   ::cFormDefFontName   := IIF( Empty( aFont[1] ), '', aFont[1] )
   ::nFormDefFontSize   := IIF( aFont[2] > 0, Int( aFont[2] ), 0 )
   ::cFormDefFontColor  := IIF( aFont[5] == NIL .OR. aFont[5,1] == NIL, ;
                                'NIL', ;
                                '{ ' + LTrim( Str( aFont[5, 1] ) ) + ', ' + ;
                                       LTrim( Str( aFont[5, 2] ) ) + ', ' + ;
                                       LTrim( Str( aFont[5, 3] ) ) + ' }' )
   ::nLabelHeight       := ::Form_Prefer:text_19:Value
   ::nTextBoxHeight     := ::Form_Prefer:text_21:Value
   ::nStdVertGap        := ::Form_Prefer:text_22:Value
   ::nPxMove            := ::Form_Prefer:text_23:Value
   ::nPxSize            := ::Form_Prefer:text_24:Value

   ::Form_Prefer:Release()

   ::SaveINI( ::cProjFolder + '\hmi.ini' )

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

   ::Form_Tree:button_9:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      If Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The MinGW folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-Hb-MinGW folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Harbour-MinGW folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      If File( cExe )
         DELETE FILE ( cExe )
      EndIf
      If File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'ooHG IDE+' )
         Break
      EndIf

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            ElseIf ::SearchTypeAdd( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .and. cFile <> 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf

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
                                  '-lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc ' + ;
                                  '-lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc ' + ;
                                  '-lodbc32 -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 ' + ;
                                  '-lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 ' + ;
                                  If( nOption == 2, '-lgtwin ', '' ) + ;
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
            If File( aRcFiles[ i ] )
               cOut += 'copy /b _temp.rc _aux.rc > NUL' + CRLF
               cOut += 'copy /b _aux.rc + ' + aRcFiles[ i ] + ' _temp.rc > NUL' + CRLF
            EndIf
         NEXT i

         // Build batch to launch make utility
         cOut += cCompFolder + 'BIN\mingw32-make.exe -f makefile.gcc 1>error.lst 2>&1 3>&2' + CRLF
         HB_MemoWrit( '_build.bat', cOut )

         // Create temp folder for objects
         CreateFolder( cFolder + 'OBJ' )

         // Compile and link
         EXECUTE FILE '_build.bat' WAIT HIDE

      Case ::lTBuild == 1 // Compile.bat

         // Check for compile file
         If ! File( 'compile.bat' ) .and. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'ooHG IDE+' )
            Break
         EndIf

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf
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
      If At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ElseIf ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'ooHG IDE+' )
         Break
      EndIf

      // Rename or move
      If ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         If Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         EndIf
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         If ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'ooHG IDE+' )
            Break
         EndIf
         cExe := cOut
      EndIf

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      If nOption == 0
         MsgInfo( 'Project builded.', 'ooHG IDE+' )
      ElseIf nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      EndIf
   End Sequence

   CursorArrow()
   ::Form_Tree:button_9:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL

//------------------------------------------------------------------------------
METHOD RunP() CLASS THMI
//------------------------------------------------------------------------------
   LOCAL cExe

   ::Form_Tree:button_9:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.

   cExe := StrTran( AllTrim( DelExt( ::cProjectName ) ), " ", "_" ) + '.exe'
   If File( cExe )
      EXECUTE FILE cExe
   else
      MsgStop( 'EXE is missing.', 'ooHG IDE+' )
   endif

   ::Form_Tree:button_9:Enabled := .T.
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

   ::Form_Tree:button_9:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      If Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The MinGW folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-xHb-MinGW folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The xHarbour-MinGW folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      If File( cExe )
         DELETE FILE ( cExe )
      EndIf
      If File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'ooHG IDE+' )
         Break
      EndIf

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            ElseIf ::SearchTypeAdd( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .and. cFile <> 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf

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
                                  '-lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc ' + ;
                                  '-lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc ' + ;
                                  '-lodbc32 -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 ' + ;
                                  '-lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 ' + ;
                                  If( nOption == 2, '-lgtwin ', '' ) + ;
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
            If File( aRcFiles[ i ] )
               cOut += 'copy /b _temp.rc _aux.rc > NUL' + CRLF
               cOut += 'copy /b _aux.rc + ' + aRcFiles[ i ] + ' _temp.rc > NUL' + CRLF
            EndIf
         NEXT i

         // Build batch to launch make utility
         cOut += cCompFolder + 'BIN\mingw32-make.exe -f makefile.gcc 1>error.lst 2>&1 3>&2' + CRLF
         HB_MemoWrit( '_build.bat', cOut )

         // Create temp folder for objects
         CreateFolder( cFolder + 'OBJ' )

         // Compile and link
         EXECUTE FILE '_build.bat' WAIT HIDE

      Case ::lTBuild == 1 // Compile.bat

         // Check for compile file
         If ! File( 'compile.bat' ) .and. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'ooHG IDE+' )
            Break
         EndIf

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf
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
      If At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ElseIf ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'ooHG IDE+' )
         Break
      EndIf

      // Rename or move
      If ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         If Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         EndIf
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         If ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'ooHG IDE+' )
            Break
         EndIf
         cExe := cOut
      EndIf

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      If nOption == 0
         MsgInfo( 'Project builded.', 'ooHG IDE+' )
      ElseIf nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      EndIf
   End Sequence

   CursorArrow()
   ::Form_Tree:button_9:Enabled := .T.
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

   ::Form_Tree:button_9:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      If Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The BCC folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-Hb-BCC folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Harbour-Borland C folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      If File( cExe )
         DELETE FILE ( cExe )
      EndIf
      If File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'ooHG IDE+' )
         Break
      EndIf

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            ElseIf ::SearchTypeAdd( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .and. cFile <> 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf

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
         If File( cMiniGuiFolder + 'LIB\HB\BCC\oohg.lib' )
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\HB\BCC\oohg.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\HB\BCC\hbprinter.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\HB\BCC\miniprint.lib'
         Else
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\oohg.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\hbprinter.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\miniprint.lib'
         EndIf
         If nOption == 2
            cOut += '\' + CRLF + cHarbourFolder + 'LIB\gtwin.lib'
         EndIf
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
                         "hbodbc.lib", ;
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
            If File( cHarbourFolder + 'LIB\' + i )
               cOut += '\' + CRLF + cHarbourFolder + 'LIB\' + i
            EndIf
         NEXT
         cOut += CRLF
         cOut += 'CC_EXE        = ' + cCompFolder + 'BIN\BCC32.EXE' + CRLF
         cOut += 'CC_FLAGS      = -c -O2 -tW -M' + CRLF
         cOut += 'CC_SEARCH     = -I' + DelSlash( cFolder ) + ';' + ;
                                        cCompFolder + 'INCLUDE;' + ;
                                        cHarbourFolder + 'INCLUDE;' + ;
                                        cMiniGUIFolder + 'INCLUDE;' + ;
                                 '-L' + cCompFolder + 'LIB;' + CRLF
         cOut += 'HRB_EXE       = ' + cHarbourFolder + 'BIN\HARBOUR.EXE' + CRLF
         cOut += 'HRB_FLAGS     = -n -q ' + If( nOption == 2, "-b ", "" ) + CRLF
         cOut += 'HRB_SEARCH    = -i' + DelSlash( cFolder ) + ;
                                ' -i' + cHarbourFolder + 'INCLUDE' + ;
                                ' -i' + cMiniGUIFolder + 'INCLUDE' + CRLF
         cOut += 'RC_COMP       = ' + cCompFolder + 'BIN\BRC32.EXE' + CRLF
         cOut += CRLF
         // Rule for .exe building
         cOut += '$(APP_NAME) : $(OBJECTS) $(RESFILES)' + CRLF
         cOut += HTAB + '$(LINK_EXE) $(LINK_SEARCH) $(LINK_FLAGS) c0w32.obj $(OBJECTS),$(APP_NAME),,$(LINK_LIBS) cw32.lib import32.lib,,$(RESFILES)' + CRLF
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
         If ! File( 'compile.bat' ) .and. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'ooHG IDE+' )
            Break
         EndIf

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf
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
      If At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ElseIf ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'ooHG IDE+' )
         Break
      EndIf

      // Rename or move
      If ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         If Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         EndIf
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         If ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'ooHG IDE+' )
            Break
         EndIf
         cExe := cOut
      EndIf

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      If nOption == 0
         MsgInfo( 'Project builded.', 'ooHG IDE+' )
      ElseIf nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      EndIf
   End Sequence

   CursorArrow()
   ::Form_Tree:button_9:Enabled := .T.
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

   ::Form_Tree:button_9:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      If Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The BCC folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-xHb-BCC folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The xHarbour-Borland C folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      If File( cExe )
         DELETE FILE ( cExe )
      EndIf
      If File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'ooHG IDE+' )
         Break
      EndIf

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            ElseIf ::SearchTypeAdd( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .and. cFile <> 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf

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
         If File( cMiniGuiFolder + 'LIB\XHB\BCC\oohg.lib' )
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\XHB\BCC\oohg.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\XHB\BCC\hbprinter.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\XHB\BCC\miniprint.lib'
         Else
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\oohg.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\hbprinter.lib'
           cOut += '\' + CRLF + cMiniGuiFolder + 'LIB\miniprint.lib'
         EndIf
         If nOption == 2
            cOut += '\' + CRLF + cHarbourFolder + 'LIB\gtwin.lib'
         EndIf
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
                         "hbodbc.lib", ;
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
            If File( cHarbourFolder + 'LIB\' + i )
               cOut += '\' + CRLF + cHarbourFolder + 'LIB\' + i
            EndIf
         NEXT
         cOut += CRLF
         cOut += 'CC_EXE        = ' + cCompFolder + 'BIN\BCC32.EXE' + CRLF
         cOut += 'CC_FLAGS      = -c -O2 -tW -M' + CRLF
         cOut += 'CC_SEARCH     = -I' + DelSlash( cFolder ) + ';' + ;
                                        cCompFolder + 'INCLUDE;' + ;
                                        cHarbourFolder + 'INCLUDE;' + ;
                                        cMiniGUIFolder + 'INCLUDE;' + ;
                                 '-L' + cCompFolder + 'LIB;' + CRLF
         cOut += 'HRB_EXE       = ' + cHarbourFolder + 'BIN\HARBOUR.EXE' + CRLF
         cOut += 'HRB_FLAGS     = -n -q ' + If( nOption == 2, "-b ", "" ) + CRLF
         cOut += 'HRB_SEARCH    = -i' + DelSlash( cFolder ) + ;
                                ' -i' + cHarbourFolder + 'INCLUDE' + ;
                                ' -i' + cMiniGUIFolder + 'INCLUDE' + CRLF
         cOut += 'RC_COMP       = ' + cCompFolder + 'BIN\BRC32.EXE' + CRLF
         cOut += CRLF
         // Rule for .exe building
         cOut += '$(APP_NAME) : $(OBJECTS) $(RESFILES)' + CRLF
         cOut += HTAB + '$(LINK_EXE) $(LINK_SEARCH) $(LINK_FLAGS) c0w32.obj $(OBJECTS),$(APP_NAME),,$(LINK_LIBS) cw32.lib import32.lib,,$(RESFILES)' + CRLF
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
         If ! File( 'compile.bat' ) .and. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'ooHG IDE+' )
            Break
         EndIf

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf
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
      If At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ElseIf ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'ooHG IDE+' )
         Break
      EndIf

      // Rename or move
      If ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         If Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         EndIf
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         If ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'ooHG IDE+' )
            Break
         EndIf
         cExe := cOut
      EndIf

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      If nOption == 0
         MsgInfo( 'Project builded.', 'ooHG IDE+' )
      ElseIf nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      EndIf
   End Sequence

   CursorArrow()
   ::Form_Tree:button_9:Enabled := .T.
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

   ::Form_Tree:button_9:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      If Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Pelles C folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-xHb-Pelles C folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The xHarbour-Pelles C folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      If File( cExe )
         DELETE FILE ( cExe )
      EndIf
      If File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'ooHG IDE+' )
         Break
      EndIf

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            ElseIf ::SearchTypeAdd( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .and. cFile <> 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf

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
            cOut += '   echo $(OBJ_DIR)\' + aPrgFiles[i] + '.obj + >' + If( i > 1, '>', '' ) + 'b32.bc' + CRLF
         NEXT i
         cOut += '   echo /OUT:$(APP_NAME) >> b32.bc' + CRLF
         cOut += '   echo /FORCE:MULTIPLE >> b32.bc' + CRLF
         cOut += '   echo /LIBPATH:$(CC_LIB_DIR) >> b32.bc' + CRLF
         cOut += '   echo /LIBPATH:$(CC_LIB_DIR)\WIN >> b32.bc' + CRLF
         If File( cMiniGuiFolder + 'LIB\XHB\PCC\oohg.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\XHB\BCC\oohg.lib >> b32.bc' + CRLF
         Else
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\oohg.lib >> b32.bc' + CRLF
         EndIf
         If File( cMiniGuiFolder + 'LIB\XHB\PCC\hbprinter.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\XHB\BCC\hbprinter.lib >> b32.bc' + CRLF
         Else
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\hbprinter.lib >> b32.bc' + CRLF
         EndIf
         If File( cMiniGuiFolder + 'LIB\XHB\PCC\miniprint.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\XHB\BCC\miniprint.lib >> b32.bc' + CRLF
         Else
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\miniprint.lib >> b32.bc' + CRLF
         EndIf
         If nOption == 2
            cOut += '   echo $(HRB_LIB_DIR)\gtwin.lib >> b32.bc' + CRLF
         EndIf
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
                         "hbodbc.lib", ;
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
            If File( cHarbourFolder + 'LIB\' + i )
               cOut += '   echo $(HRB_LIB_DIR)\' + i + ' >> b32.bc' + CRLF
            EndIf
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
            If File( cHarbourFolder + 'LIB\' + i )
               cOut += '   echo ' + i + ' >> b32.bc' + CRLF
            EndIf
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

   CASE ::ltbuild==1 // Compile.bat

         // Check for compile file
         If ! File( 'compile.bat' ) .and. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'ooHG IDE+' )
            Break
         EndIf

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf
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
      If At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ElseIf ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'ooHG IDE+' )
         Break
      EndIf

      // Rename or move
      If ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         If Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         EndIf
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         If ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'ooHG IDE+' )
            Break
         EndIf
         cExe := cOut
      EndIf

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      If nOption == 0
         MsgInfo( 'Project builded.', 'ooHG IDE+' )
      ElseIf nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      EndIf
   End Sequence

   CursorArrow()
   ::Form_Tree:button_9:Enabled := .T.
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

   ::Form_Tree:button_9:Enabled := .F.
   ::Form_Tree:button_10:Enabled := .F.
   ::Form_Tree:button_11:Enabled := .F.
   CursorWait()
   ::Form_Wait:hmi_label_101:Value := 'Compiling ...'
   ::Form_Wait:Show()

   Begin Sequence
      // Check folders
      If Empty( ::cProjectName )
         ::Form_Wait:Hide()
         MsgStop( 'You must save the project before building it.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cCompFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Pelles C folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cMiniGuiFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The ooHG-Hb-Pelles C folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      If Empty( cHarbourFolder )
         ::Form_Wait:Hide()
         MsgStop( 'The Harbour-Pelles C folder must be specified to build a project.', 'ooHG IDE+' )
         Break
      EndIf

      // Prepare to build
      SetCurrentFolder( cFolder )
      BorraTemp( cFolder )
      cPrgName := StrTran( AllTrim( DelExt( DelPath( ::cProjectName ) ) ), " ", "_" )
      cExe := cPrgName + '.exe'
      If File( cExe )
         DELETE FILE ( cExe )
      EndIf
      If File( cExe )
         ::Form_Wait:Hide()
         MsgInfo( 'Error building project.' + CRLF + 'Is EXE running?', 'ooHG IDE+' )
         Break
      EndIf

      Do Case
      Case ::lTBuild == 2    // Own Make

         // Build list of source files
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         aRcFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            ElseIf ::SearchTypeAdd( ::SearchItem( cFile, 'RC module' ) ) == 'RC module' .and. cFile <> 'RC module'
               cFile := Upper( AllTrim( cFile ) )
               If aScan( aRcFiles, cFile ) == 0
                  aAdd( aRcFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf

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
            cOut += '   echo $(OBJ_DIR)\' + aPrgFiles[i] + '.obj + >' + If( i > 1, '>', '' ) + 'b32.bc' + CRLF
         NEXT i
         cOut += '   echo /OUT:$(APP_NAME) >> b32.bc' + CRLF
         cOut += '   echo /FORCE:MULTIPLE >> b32.bc' + CRLF
         cOut += '   echo /LIBPATH:$(CC_LIB_DIR) >> b32.bc' + CRLF
         cOut += '   echo /LIBPATH:$(CC_LIB_DIR)\WIN >> b32.bc' + CRLF
         If File( cMiniGuiFolder + 'LIB\HB\PCC\oohg.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\HB\BCC\oohg.lib >> b32.bc' + CRLF
         Else
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\oohg.lib >> b32.bc' + CRLF
         EndIf
         If File( cMiniGuiFolder + 'LIB\HB\PCC\hbprinter.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\HB\BCC\hbprinter.lib >> b32.bc' + CRLF
         Else
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\hbprinter.lib >> b32.bc' + CRLF
         EndIf
         If File( cMiniGuiFolder + 'LIB\HB\PCC\miniprint.lib' )
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\HB\BCC\miniprint.lib >> b32.bc' + CRLF
         Else
           cOut += '   echo ' + cMiniGuiFolder  + 'LIB\miniprint.lib >> b32.bc' + CRLF
         EndIf
         If nOption == 2
            cOut += '   echo $(HRB_LIB_DIR)\gtwin.lib >> b32.bc' + CRLF
         EndIf
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
                         "hbodbc.lib", ;
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
            If File( cHarbourFolder + 'LIB\' + i )
               cOut += '   echo $(HRB_LIB_DIR)\' + i + ' >> b32.bc' + CRLF
            EndIf
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
            If File( cHarbourFolder + 'LIB\' + i )
               cOut += '   echo ' + i + ' >> b32.bc' + CRLF
            EndIf
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

   CASE ::ltbuild==1 // Compile.bat

         // Check for compile file
         If ! File( 'compile.bat' ) .and. ! IsFileInPath( 'compile.bat' )
            ::Form_Wait:Hide()
            MsgInfo( 'Copy file COMPILE.BAT from ooHG root folder to the current' + CRLF + 'project folder, or add ooHG root folder to PATH.', 'ooHG IDE+' )
            Break
         EndIf

         // Build auxiliary source file
         nItems := ::Form_Tree:Tree_1:ItemCount
         aPrgFiles := {}
         For i := 1 To nItems
            cFile := ::Form_Tree:Tree_1:Item( i )
            If ::SearchTypeAdd( ::SearchItem( cFile, 'Prg module' ) ) == 'Prg module' .and. cFile <> 'Prg module'
               cFile := Upper( AllTrim( cFile + '.PRG' ) )
               If aScan( aPrgFiles, cFile ) == 0
                  aAdd( aPrgFiles, cFile )
               EndIf
            EndIf
         NEXT i
         nPrgFiles := Len( aPrgFiles )
         If nPrgFiles == 0
            ::Form_Wait:Hide()
            MsgStop( 'Project has no .PRG files.', 'ooHG IDE+' )
            Break
         EndIf
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
      If At( 'ERROR', cError1 ) > 0 .or. At( 'FATAL', cError1 ) > 0 .or. At( 'LD RETURNED 1 EXIT STATUS', cError1 ) > 0
         ::Form_Wait:Hide()
         ::ViewErrors( cError )
         Break
      ElseIf ! File( cExe )
         ::Form_Wait:Hide()
         MsgStop( 'EXE is missing.', 'ooHG IDE+' )
         Break
      EndIf

      // Rename or move
      If ! Empty( ::cOutFile )
         cOut := Upper( AllTrim( ::cOutFile ) )
         If Right( cOut, 4 ) != ".EXE"
            cOut += ".EXE"
         EndIf
         cDosComm := '/c move ' + cExe + ' ' + cOut
         EXECUTE FILE 'CMD.EXE' PARAMETERS cDosComm HIDE
         If ! File( cOut )
            ::Form_Wait:Hide()
            MsgStop( "Can't move or rename EXE file.", 'ooHG IDE+' )
            Break
         EndIf
         cExe := cOut
      EndIf

      // Cleanup
      BorraTemp( cFolder )
      ::Form_Wait:Hide()
      If nOption == 0
         MsgInfo( 'Project builded.', 'ooHG IDE+' )
      ElseIf nOption == 1 .or. nOption == 2
         EXECUTE FILE cExe
      EndIf
   End Sequence

   CursorArrow()
   ::Form_Tree:button_9:Enabled := .T.
   ::Form_Tree:button_10:Enabled := .T.
   ::Form_Tree:button_11:Enabled := .T.
RETURN NIL

//------------------------------------------------------------------------------
METHOD ViewErrors( wr ) CLASS THMI
//------------------------------------------------------------------------------
   LOCAL Form_Errors, oEdit, oButt

   If HB_IsString( wr )
      DEFINE WINDOW Form_Errors OBJ Form_Errors ;
         AT 10, 10 ;
         CLIENTAREA WIDTH 650 HEIGHT 480 ;
         TITLE 'Error Report' ;
         ICON 'Edit' ;
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
   EndIf
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
      ICON 'Edit' ;
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
   IF .NOT. ::lPsave
      IF MsgYesNo( 'Current project not saved, save it now?', 'ooHG IDE+' )
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
   ::Form_Tree:title := cNameApp
   ::lPsave := .F.
   ::cProjectName := ''
   ::Form_Tree:Add:Enabled := .F.
   ::Form_Tree:Button_1:Enabled := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD OpenProject() CLASS THMI
//------------------------------------------------------------------------------
LOCAL pmgFolder

   ::cFile := GetFile( { {'ooHG IDE+ project files *.pmg','*.pmg'} }, 'Open Project', "", .F., .F. )
   IF Len( ::cFile ) > 0
      pmgFolder := OnlyFolder( ::cFile )
      IF ! Empty( pmgFolder )
         ::cProjFolder := pmgFolder
         DirChange( pmgFolder )
      ENDIF
      ::Form_Tree:Add:Enabled := .T.
      ::Form_Tree:Button_1:Enabled := .T.
   ENDIF
   ::OpenAuxi()
RETURN NIL

//------------------------------------------------------------------------------
METHOD OpenAuxi() CLASS THMI
//------------------------------------------------------------------------------
LOCAL aLine[0], nContLin, cProject, sw, i

   // From project folder
   ::ReadINI( ::cProjFolder + "\hmi.ini" )

   ::cProjectName := ::cFile

   cProject := MemoRead( ::cFile )
   nContLin := MLCount( cProject )

   ::Form_Tree:Title := cNameApp + ' (' + ::cFile + ')'
   ::Form_Tree:Tree_1:DeleteAllItems()
   ::Form_Tree:Tree_1:AddItem( 'Project', 0 )
   ::Form_Tree:Tree_1:AddItem( 'Form module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'Prg module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'CH module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'Rpt module', 1 )
   ::Form_Tree:Tree_1:AddItem( 'RC module', 1 )

   sw := 0
   FOR i := 1 TO nContLin
      aAdd( aLine, RTrim( MemoLine( cProject, , i ) ) )
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
            ::NewFormFromAr( aLine[i] )
         ENDIF
         IF sw == 2
            ::NewPrgFromAr( aLine[i] )
         ENDIF
         IF sw == 3
            ::NewCHFromAr( aLine[i] )
         ENDIF
         IF sw == 4
            ::NewRptFromAr( aLine[i] )
         ENDIF
         IF sw == 5
            ::NewRCFromAr( aLine[i] )
         ENDIF
      ENDCASE
   NEXT i

   ::Form_Tree:Tree_1:Value := 1
   ::Form_Tree:Tree_1:Expand( 1 )
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
   ::Form_Tree:Title := cNameApp + ' (' + ::cProjectName + ')'
   IF ! Empty( ::cProjectName )
      ::Form_Tree:Add:Enabled := .T.
      ::Form_Tree:Button_1:Enabled := .T.
   ENDIF

   IF Empty( ::cProjectName )
      MsgStop( 'Project not saved.', 'ooHG IDE+' )
   ELSE
      HB_MemoWrit( ::cProjectName, Output )
      ::SaveINI( ::cProjFolder + '\hmi.ini' )
      ::lPsave := .T.
      MsgInfo( 'Project saved.', 'ooHG IDE+' )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD newform() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cPform
cPform:=inputbox('Form module','Add Form module')
if val(cPform)>0
   MsgStop( 'The name must begin with a letter.', 'ooHG IDE+' )
   RETURN NIL
endif
if at('.',cPform)#0
   MsgStop( 'The name must not contain a dot (.) in it.', 'ooHG IDE+' )
   RETURN NIL
endif

if len(cPform)>0
   if ::searchitem(cPform,'Form module')>0 .and. ::searchtypeadd(::searchitem(cPform,'Form module'))=='Form module'
      MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
      RETURN NIL
   endif
   ::Form_Tree:Tree_1:AddItem( cPform , 2 )
   ::lPsave:=.F.
endif
RETURN NIL


//------------------------------------------------------------------------------
METHOD newformfromar(cPform) CLASS THMI
//------------------------------------------------------------------------------
if len(cPform)>0
   if ::searchitem(cPform,'Form module')>0 .and. ::searchtypeadd(::searchitem(cPform,'Form module'))=='Form module'
      MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
      RETURN NIL
   endif
   ::Form_Tree:Tree_1:AddItem( cPform , 2 )
endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD Newprgfromar(cPprg) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nValue

   if len(cPprg)>0
      if ::searchitem(cPprg,"Prg module")>0 .and. ::searchtypeadd(::searchitem(cPprg,"Prg module"))=='Prg module'
         MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
         RETURN NIL
      endif
      nValue := ::searchitem('Prg module',"Prg module")
      ::Form_Tree:Tree_1:AddItem( cPprg , nValue)
   endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD Newchfromar(cPch) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nValue
if len(cPch)>0
   if ::searchitem(cPch,"CH module")>0 .and. ::searchtypeadd(::searchitem(Cpch,"CH module"))=='CH module'
      MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
      RETURN NIL
   endif
   nValue:=::searchitem('CH module',"CH module")
   ::Form_Tree:Tree_1:AddItem( cPch , nValue)
endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD Newrcfromar(cPrc) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nValue
if len(cPrc)>0
   if ::searchitem(cPrc,"RC module")>0 .and. ::searchtypeadd(::searchitem(Cprc,"RC module"))=='RC module'
      MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
      RETURN NIL
   endif
   nValue:=::searchitem('RC module',"RC module")
   ::Form_Tree:Tree_1:AddItem( cPrc , nValue)
endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD Newrptfromar(cPrpt) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nValue
if len(cPrpt)>0
   if ::searchitem(cPrpt,"Rpt module")>0 .and. ::searchtypeadd(::searchitem(Cprpt,"Rpt module"))=='Rpt module'
      MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
      RETURN NIL
   endif
   nValue:=::searchitem('Rpt module',"Rpt module")
   ::Form_Tree:Tree_1:AddItem( cPrpt , nValue)
endif
RETURN NIL


//------------------------------------------------------------------------------
METHOD Newprg() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cPprg, nValue

   cPprg := InputBox( 'Prg Module', 'Add Prg Module' )
   IF Val( cPprg ) > 0
      MsgStop( 'The name must begin with a letter.', 'ooHG IDE+' )
      RETURN NIL
   ENDIF
   IF At( '.', cPprg ) # 0
      MsgStop( 'The name must not contain a dot (.) in it.', 'ooHG IDE+' )
      RETURN NIL
   ENDIF
   IF Len( cPprg ) > 0
      IF ::SearchItem( cPprg, 'Prg module' ) > 0 .AND. ::SearchTypeAdd( ::SearchItem( cPprg, 'Prg module' ) ) == 'Prg module'
         MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
         RETURN NIL
      ENDIF
      nValue := ::SearchItem( 'Prg module', 'Prg module' )
      ::Form_Tree:Tree_1:AddItem( cPprg, nValue)
      ::lPsave := .F.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Newch() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cPch,nValue
cPch:=inputbox('CH Module','Add CH Module')
if val(cPch)>0
   MsgStop( 'The name must begin with a letter.', 'ooHG IDE+' )
   RETURN NIL
endif
if at('.',cPch)#0
   MsgStop( 'The name must not contain a dot (.) in it.', 'ooHG IDE+' )
   RETURN NIL
endif
if len(cPch)>0
   if ::searchitem(cPch,'CH module')>0 .and. ::searchtypeadd(::searchitem(Cpch,'CH module'))=='CH module'
      MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
      RETURN NIL
   endif
   nValue:=::searchitem('CH module','CH module')
   ::Form_Tree:Tree_1:AddItem( cPch , nValue)
   ::lPsave:=.F.
endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD Newrc() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cPrc,nValue
cPrc:=inputbox('RC Module','Add RC Module')
if val(cPrc)>0
   MsgStop( 'The name must begin with a letter.', 'ooHG IDE+' )
   RETURN NIL
endif
if at('.',cPrc)#0
   MsgStop( 'The name must not contain a dot (.) in it.', 'ooHG IDE+' )
   RETURN NIL
endif
if len(cPrc)>0
   if ::searchitem(cPrc,'RC module')>0 .and. ::searchtypeadd(::searchitem(Cprc,'RC module'))=='RC module'
      MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
      RETURN NIL
   endif
   nValue:=::searchitem('RC module','RC module')
   ::Form_Tree:Tree_1:AddItem( cPrc , nValue)
   ::lPsave:=.F.
endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD Newrpt() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cPrpt,nValue
cPrpt:=inputbox('Rpt Module','Add Rpt Module')
if val(cPrpt)>0
   MsgStop( 'The name must begin with a letter.', 'ooHG IDE+' )
   RETURN NIL
endif
if at('.',cPrpt)#0
   MsgStop( 'The name must not contain a dot (.) in it.', 'ooHG IDE+' )
   RETURN NIL
endif
if len(cPrpt)>0
   if ::searchitem(cPrpt,'Rpt module')>0 .and. ::searchtypeadd(::searchitem(Cprpt,'Rpt module'))=='Rpt module'
      MsgStop( 'This name is not allowed.', 'ooHG IDE+' )
      RETURN NIL
   endif
   nValue:=::searchitem('Rpt module','Rpt module')
   ::Form_Tree:Tree_1:AddItem( cPrpt , nValue)
   ::lPsave:=.F.
endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD DeleteItemP() CLASS THMI
//------------------------------------------------------------------------------
LOCAL cItem

   cItem := ::Form_Tree:Tree_1:Item( ::Form_Tree:Tree_1:Value )
   IF cItem == 'Form module' .OR. cItem == 'Prg module' .OR. cItem == 'Project' .OR. cItem == 'CH module' .OR. cItem == 'Rpt module' .OR. cItem == 'RC module'
      MsgStop( "This item can't be deleted.", 'ooHG IDE+' )
      RETURN NIL
   ENDIF

   IF MsgYesNo( 'Item ' + cItem + ' will be removed, are you sure?', 'ooHG IDE+' )
      ::Form_Tree:Tree_1:DeleteItem( ::Form_Tree:Tree_1:Value )
      ::lPsave := .F.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SearchItem( cNameItem, cParent ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nitems, i, cItem, sw

   sw := 0
   nItems := ::Form_Tree:Tree_1:ItemCount
   FOR i := 1 TO nItems
       cItem := ::Form_Tree:Tree_1:Item( i )
       IF cItem == cParent
          sw := 1
       ENDIF
       IF sw == 1
          IF Upper(cItem) == Upper( cNameItem )
             RETURN i
          ENDIF
       ENDIF
   NEXT i
RETURN 0

//------------------------------------------------------------------------------
METHOD searchtypeadd(nvalue) CLASS THMI
//------------------------------------------------------------------------------
LOCAL l
IF !HB_IsNumeric( nvalue)
   RETURN NIL
ENDIF
For l:= nValue to 1 step -1
    if ::Form_Tree:Tree_1:item(l) == 'Form module'
       RETURN 'Form module'
    endif
    if ::Form_Tree:Tree_1:item(l) == 'Prg module'
       RETURN 'Prg module'
    endif
    if ::Form_Tree:Tree_1:item(l) == 'CH module'
       RETURN 'CH module'
    endif
    if ::Form_Tree:Tree_1:item(l) == 'Rpt module'
       RETURN 'Rpt module'
    endif
    if ::Form_Tree:Tree_1:item(l) == 'RC module'
       RETURN 'RC module'
    endif
NEXT l
RETURN NIL

//------------------------------------------------------------------------------
METHOD searchtype() CLASS THMI
//------------------------------------------------------------------------------
LOCAL i, nValue

   nValue:= ::Form_Tree:Tree_1:Value
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
RETURN NIL

//------------------------------------------------------------------------------
METHOD ModifyItem( cItem, cParent ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL Output

   IF cItem == NIL
      cItem := ::Form_Tree:Tree_1:Item( ::Form_Tree:Tree_1:Value )
      cParent := ::SearchType( ::SearchItem( cItem, 'Form module' ) )
   ENDIF

   IF cParent == 'Prg module'
      IF File( cItem + '.prg' )
         ::OpenFile( cItem + '.prg' )
      else
         Output := '/*        IDE: ooHG IDE+' + CRLF
         Output += ' *     Project: ' + ::cProjectName + CRLF
         Output += ' *        Item: ' + cItem + '.prg' + CRLF
         Output += ' * Description: ' + CRLF
         Output += ' *      Author: ' + CRLF
         Output += ' *        Date: ' + DtoC( Date() ) + CRLF
         Output += ' */' + CRLF + CRLF

         Output += "#include 'oohg.ch'" + CRLF + CRLF
         Output += "*------------------------------------------------------*" + CRLF
         IF ::SearchItem( cItem, cParent )== ( ::SearchItem( cParent, cParent ) + 1 )
            Output += 'FUNCTION Main()' + CRLF
         ELSE
            Output += 'FUNCTION ' + cItem + '()' + CRLF
         ENDIF
         Output += "*------------------------------------------------------*" + CRLF + CRLF
         Output += 'RETURN Nil' + CRLF + CRLF
         HB_MemoWrit( cItem + '.prg', Output )
         ::Openfile( cItem + '.prg' )
      ENDIF
   ENDIF
   IF cParent == 'CH module'
      IF File( cItem + '.ch' )
         ::Openfile( cItem + '.ch' )
      else
         Output := '/*        IDE: ooHG IDE+' + CRLF
         Output += ' *     Project: ' + ::cProjectName + CRLF
         Output += ' *        Item: ' + cItem + '.ch' + CRLF
         Output += ' * Description:' + CRLF
         Output += ' *      Author:' + CRLF
         Output += ' *        Date: ' + DtoC( Date() ) + CRLF
         Output += ' */' + CRLF + CRLF
         Output += '#' + CRLF
         HB_MemoWrit( cItem + '.ch', Output )
         ::Openfile( cItem + '.ch' )
      ENDIF
   ENDIF
   IF cParent == 'RC module'
      IF File( cItem + '.rc' )
         ::Openfile(cItem+'.rc')
      ELSE
         Output:='//         IDE: ooHG IDE+'+CRLF
         Output+='//     Project: '+::cprojectname+CRLF
         Output+='//        Item: '+cItem+'.rc'+CRLF
         Output+='// Description:'+CRLF
         Output+='//      Author:'+CRLF
         Output+='//        Date: '+dtoc(date())+CRLF
         Output+='// Name    Format   Filename'+CRLF
         Output+='// MYBMP   BITMAP   res\Next.bmp'+CRLF
         Output+='// Last line of this file must end with a CRLF'+CRLF

         Output += MemoRead( 'auxi.rc' )
         HB_MemoWrit( cItem + '.rc', Output )
         ::Openfile( cItem + '.rc' )
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD modifyRpt(cItem,cparent) CLASS THMI
//------------------------------------------------------------------------------
   if citem=NIL
      cItem:=::Form_Tree:Tree_1:item(::Form_Tree:Tree_1:Value)
      cParent= ::searchtype(::searchitem(cItem,'Rpt module'))
   endif

   if cParent == 'Rpt module'
      ::Repo_Edit( cItem + '.rpt' )
   endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD ModifyForm( cItem, cParent, lWait ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nPos, oEditor
   IF cItem == NIL
      cItem := ::Form_Tree:Tree_1:Item( ::Form_Tree:Tree_1:Value )
      cParent := ::SearchType( ::SearchItem( cItem, 'Form module' ) )
   ENDIF
   cItem := Lower( cItem )
   DO WHILE ( nPos := At( ".", cItem ) ) > 0
      cItem := SubStr( cItem, 1, nPos - 1 )
   ENDDO
   IF cParent == 'Form module'
      ::Disable_Button()
      oEditor := TFormEditor()
      aAdd( ::aEditors, oEditor )
      ::nActiveEditor := Len( ::aEditors )
      oEditor:EditForm( Self, cItem + '.fmg', ::nActiveEditor, lWait )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD EditorExit() CLASS THMI
//------------------------------------------------------------------------------
   IF ::lCloseOnFormExit .AND. Len( ::aEditors ) == 0
      RELEASE WINDOW ALL
   ELSE
      // TODO: dejar siempre habilitados
      ::Form_Tree:button_7:Enabled := .T.
      ::Form_Tree:button_9:Enabled := .T.
      ::Form_Tree:button_10:Enabled := .T.
      ::Form_Tree:button_11:Enabled := .T.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SaveFile( cdfile ) CLASS THMI
//------------------------------------------------------------------------------
   If AllTrim( ::Form_Edit:edit_1:Value ) == ''
      If File( cdfile )
         DELETE FILE &cdfile
      EndIf
      ::lSave := .T.
   Else
      If HB_MemoWrit( cdfile, AllTrim( ::Form_Edit:edit_1:Value ) )
         ::lSave := .T.
      Else
         MsgStop( 'Error writing ' + cdfile + '.', 'ooHG IDE+' )
      EndIf
   EndIf
RETURN Nil

//------------------------------------------------------------------------------
METHOD OpenFile( cdfile ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL cOutput, nwidth, nheight, wq, nrat, cRun, ll, i, cTextedit, nInterval

   CursorWait()
   ::lSave := .T.
   ::nPosText := 0
   ::cText := ''
   ::nTemp := 0
   ::Form_Wait:Show()
   ::Form_Wait:hmi_label_101:Value := 'Loading File ...'
   IF Len( AllTrim( ::cExtEditor ) ) == 0
      cTextEdit := MemoRead( cdFile )
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
         MsgStop( "Sorry, the IDE can't edit more than one file at a time.", 'ooHG IDE+' )
         RETURN NIL
      ENDIF

      nWidth := ::Form_Tree:Width - ( ::Form_Tree:Width / 3.5 )
      nHeight := ::Form_Tree:Height - 160

      DEFINE WINDOW Form_Edit OBJ ::Form_Edit ;
         AT 109, 80 ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         TITLE cNameApp + " " + cdfile ;
         ICON 'EDIT' ;
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
            MsgInfo( 'You should use another program editor.', 'ooHG IDE+' )
         ENDIF

         IF Len( ::Form_Edit:edit_1:Value ) > 250000
            MsgStop('You must use another program editor.', 'ooHG IDE+' )
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

         DEFINE TOOLBAR ToolBar_1x BUTTONSIZE 20,20 FLAT FONT 'Calibri' SIZE 9

            BUTTON button_2 tooltip 'Exit(Esc)'    picture 'Exit'  ACTION ::SaveAndExit( cdfile )
            BUTTON button_1 tooltip 'Save(F2)'     Picture 'Save'  ACTION ::SaveFile( cdfile )
            BUTTON button_3 tooltip 'Find(Ctrl-F)' picture 'M10'   ACTION ::TxtSearch()
            BUTTON button_4 tooltip 'Next(F3)'     picture 'Next'  ACTION ::NextSearch()
            BUTTON button_5 tooltip 'Go(Ctrl-G)'   picture 'Go'    ACTION ::GoLine()
            nrat := RAt( '.prg', cdfile )
            IF nrat > 0
               BUTTON button_6 tooltip 'Reformat(Ctrl-R)' picture 'tbarb'  ACTION ::Reforma( ::Form_Edit:edit_1:Value )
            endif
         END TOOLBAR

         END SPLITBOX

         ON KEY F2     OF Form_Edit ACTION ::SaveFile( cdfile )
         ON KEY F3     OF Form_Edit ACTION ::NextSearch()
         ON KEY CTRL+F OF Form_Edit ACTION ::TxtSearch()
         ON KEY CTRL+G OF Form_Edit ACTION ::GoLine()
         ON KEY ESCAPE OF Form_Edit ACTION ::SaveAndExit( cdfile )
         IF nrat > 0
         ON KEY CTRL+R OF Form_Edit ACTION ::Reforma( ::Form_Edit:edit_1:Value )
         ENDIF

         DEFINE STATUSBAR
            STATUSITEM " Lin:     Col:     Caret:     " WIDTH 20
            KEYBOARD
            DATE WIDTH 100
            CLOCK WIDTH 90
         END STATUSBAR

         DEFINE CONTEXT MENU

            MENUITEM 'Cut' ACTION send_CUT()
            MENUITEM 'Copy' ACTION send_COPY()
            MENUITEM 'Paste' ACTION send_paste()
            MENUITEM 'Delete' action  _PushKey ( 32 )
            SEPARATOR
            MENUITEM 'Select all' ACTION send_selectall()

         END MENU

      END WINDOW

      CENTER WINDOW Form_Edit
      ::Form_Wait:Hide()
      CursorArrow()
      ACTIVATE WINDOW Form_Edit
   ELSE
      cRun := ::cExteditor + ' ' + cdfile

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
   for i=1 to largo
       if i>0
          cantlin:=ltrim(rtrim(memoline(ccontenido,500,i-1)))
       endif
       if i< largo
          cdeslin:=ltrim(rtrim(memoline(ccontenido,500,i+1)))
       endif
       clineaorig:=memoline(ccontenido,500,i)
       clinea1:=rtrim(clineaorig)
       clinea:=ltrim(rtrim(clineaorig))
       cllinea:=upper(clinea)
       do case
          case substr(cllinea,1,4)='CASE' .or. substr(cllinea,1,9)='OTHERWISE'
             if swcase=0
                coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                ntab:=ntab+3
                swcase:=-1
             else
                if swcase=-1
                   ntab:=ntab-3
                   coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                   swcase:=1
                   ntab:=ntab+3
                else
                   ntab:=ntab-3
                   coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                   swcase=-1
                   ntab:=ntab+3
                endif
             endif

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
             if substr(cantlin,1,2) # '*-'
                coutput:=coutput+CRLF
                coutput:=coutput+'*-------------------------'+CRLF
             endif
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             if substr(cdeslin,1,2) # '*-'
                coutput:=coutput+'*-------------------------'+CRLF
             endif
          case substr(cllinea,1,16)='STATIC FUNCTION '
             if substr(cantlin,1,2) # '*-'
                coutput:=coutput+CRLF
                coutput:=coutput+'*-------------------------'+CRLF
             endif
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             if substr(cdeslin,1,2) # '*-'
                coutput:=coutput+'*-------------------------'+CRLF
             endif

          case substr(cllinea,1,10)='PROCEDURE '
             if substr(cantlin,1,2) # '*-'
                coutput:=coutput+CRLF
                coutput:=coutput+'*-------------------------'+CRLF
             endif
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             if substr(cdeslin,1,2) # '*-'
                coutput:=coutput+'*-------------------------'+CRLF
             endif
          case substr(cllinea,1,9)='METHOD '
             if swclase=0 .and. substr(cantlin,1,2) # '*-'
                coutput:=coutput+CRLF
                coutput:=coutput+'*-------------------------'+CRLF
             endif
             coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
             if swclase=0 .and. substr(cdeslin,1,2) # '*-'
                coutput:=coutput+'*-------------------------'+CRLF
             endif
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
             if len(clinea)>0
                if swc=0
                   coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                else
                   coutput:=coutput+replicate(' ',ntab)+clinea1+CRLF
                endif
                lcero:=0
             else
                lcero++
                if lcero<10
                   coutput:=coutput+replicate(' ',ntab)+clinea+CRLF
                endif
             endif
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
          ::Form_Edit.edit_1.CaretPos := nPos + ( i * 2 ) - i + 1 - 2 - Len( Trim( ( MemoLine( cText, 500, i ) ) ) )
          EXIT
       ENDIF
   NEXT i
RETURN NIL

//------------------------------------------------------------------------------
METHOD lookchanges() CLASS THMI
//------------------------------------------------------------------------------
   IF ::Form_Edit.edit_1.CaretPos <> ::nCaretPos
      ::posxy()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD posxy() CLASS THMI
//------------------------------------------------------------------------------
LOCAL i, texto, long
LOCAL nCP := ::Form_Edit.edit_1.caretpos, npos := 0, nposx := 0, nposy
   texto:=::Form_Edit:edit_1:value
   long:=mlcount(texto)
   ::nCaretPos := nCP
   nposy:=0
   for i:=1 to long
       npos:=npos+len(rtrim(( memoline(texto,500,i)   )))
       if npos > ( nCP -(i-1) )
          nposx:=len((rtrim((memoline(texto,500,i)))))-(npos-(nCP-(i-1)))+1
          nposy:=i
          if nposx=0
             nposy --
             nposx:=len((rtrim((memoline(texto,500,nposy)))))+1
          endif
          exit
       endif
    NEXT i
    ::Form_Edit.StatusBar.Item(1) := ' Lin'+PADR(str(nposy,4),4)+' Col'+PADR(str(nposx,4),4)+' Car'+PADR(str(nCP,4),4)
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
METHOD nextsearch() CLASS THMI
//------------------------------------------------------------------------------
LOCAL texto
texto:=StrTran(::Form_Edit:edit_1:value,CR,"")
::npostext:=myat(upper(::ctext),upper(texto),::npostext+len(::ctext))
if ::npostext>0
   ::Form_Edit:edit_1:setfocus()
   ::Form_Edit.edit_1.caretpos:=::npostext-1
else
   ::Form_Edit:edit_1:setfocus()
   MsgInfo( 'No more matches found.', 'ooHG IDE+' )
endif
RETURN nil

//------------------------------------------------------------------------------
FUNCTION myat(cbusca,ctexto,ninicio)
//------------------------------------------------------------------------------
LOCAL i,nposluna
nposluna:=0
for i:= ninicio to len(ctexto)
    if upper(substr(ctexto,i,len(cbusca)))=upper(cbusca)
       nposluna:=i
       exit
    endif
NEXT i
RETURN nposluna

//------------------------------------------------------------------------------
METHOD SaveAndExit( cdfile ) CLASS THMI
//------------------------------------------------------------------------------
   IF .NOT. ::lSave
      IF MsgYesNo( 'File not saved, save it now?', 'ooHG IDE+' )
         ::SaveFile( cdfile )
      ENDIF
   ENDIF
   ::Form_Edit:Release()
RETURN NIL

//------------------------------------------------------------------------------
METHOD DatabaseView() CLASS THMI
//------------------------------------------------------------------------------
LOCAL curfol, curdrv, cdFile, nPos, i, j

   curfol := CurDir()
   curdrv := CurDrive() + ':\'
   cdFile := GetFile ( { { 'dbf files *.dbf', '*.dbf' } } , 'Open Dbf file', , .F., .F. )
   IF Len( cdFile ) > 0
      nPos := at( ".", cdFile )
      cdFile := Left( cdFile, nPos - 1 )
      j := 0
      FOR i := 1 TO Len( cdFile )
          IF SubStr( cdFile, i, 1 ) == '\'
             j := i
          ENDIF
      NEXT i
      cdFile := SubStr( cdFile, j + 1, Len( cdFile ) )
      USE ( cdFile ) NEW
      SET INTERACTIVECLOSE ON
      EDIT EXTENDED WORKAREA ( cdFile ) TITLE 'Browsing of ... ' + cdFile
      SET INTERACTIVECLOSE OFF
      ( cdFile )->( dbCloseArea() )
   ENDIF
   DirChange( curdrv + curfol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD Disable_Button() CLASS THMI
//------------------------------------------------------------------------------
   ::Form_Tree:button_7:enabled := .F.
   ::Form_Tree:button_9:enabled := .F.
   ::Form_Tree:button_10:enabled := .F.
   ::Form_Tree:button_11:enabled := .F.
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION DatabaseView2( myIde )
//------------------------------------------------------------------------------
LOCAL curfol, curdrv, cdfile, npos, i, j, lDeleted, oBrow, AfieldNames, aTypes
LOCAL aWidths, aDecimals, Form_Brow

   curfol := curdir()
   curdrv := curdrive()+':\'
   cdFile := GetFile ( { {'dbf files *.dbf','*.dbf'} }  , 'Open Dbf file',,.F.,.F. )
   IF Len( cdFile ) > 0
      npos := At( ".", cdfile )
      cdfile := Left( cdfile, npos - 1 )
      j := 0
      FOR i := 1 TO Len( cdfile )
          IF SubStr( cdfile, i, 1 ) == '\'
             j := i
          ENDIF
      NEXT i
      lDeleted := Set( _SET_DELETED, .F. )                  // make deleted records visible
      cdfile := SubStr( cdfile, j + 1, Len( cdfile ) )
      USE ( cdfile ) NEW
      aFieldNames := ( cdfile )->( Array( FCount() ) )
      aTypes      := ( cdfile )->( Array( FCount() ) )
      aWidths     := ( cdfile )->( Array( FCount() ) )
      aDecimals   := ( cdfile )->( Array( FCount() ) )
      ( cdfile )->( aFields( aFieldNames, aTypes, aWidths, aDecimals ) )

      aEval( aWidths, { |n, i| IIF( n <= 3, aWidths[i] := 30, aWidths[i] := n * 10 ) } )

      DEFINE WINDOW Form_Brow OBJ Form_Brow ;
         AT 0, 0 ;
         WIDTH 640 HEIGHT 480 ;
         TITLE 'Quick Browsing of ... ' + cdfile ;
         ICON 'Edit' ;
         CHILD NOMAXIMIZE   ;
         ON INIT Form_Brow:Maximize() ;
         BACKCOLOR myIde:aSystemColor

         @ 25,80 BROWSE Browse_1 ;
            OF form_brow OBJ oBrow ;
            WIDTH 640 ;
            HEIGHT 460 ;
            HEADERS aFieldNames ;
            WIDTHS awidths ;
            WORKAREA &cdfile ;
            FIELDS aFieldnames ;
            VALUE 0 ;
            TOOLTIP 'Dbl Click to modify' ;
            EDIT APPEND DELETE ;
            LOCK
         oBrow:BetterColumnsAutofit()

         @ 40,730 BUTTON button_sal ;
            CAPTION 'Exit'  ;
            ACTION oBrow:Release() ;
            WIDTH 60

         @ 490, 150 LABEL label_qb ;
            VALUE "ALT-A (Add record) - Delete (Delete record) - Dbl_click (Modify record)" ;
            WIDTH 500

      END WINDOW

      Form_Brow:Browse_1:SetFocus()

      CENTER WINDOW Form_Brow
      ACTIVATE WINDOW Form_Brow
      ( cdfile )->( dbCloseArea() )
      Set( _SET_DELETED, lDeleted )
   ENDIF
   DirChange( curdrv + curfol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD myInputWindow( cTitle, aLabels, aValues, aFormats, bFunc ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL l, aResult, wyw, i, wHeight, _iw, ControlRow, cLblName, cCtrlName

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
         If ValType ( aFormats[i] ) == 'A'
            wyw += 26
         ElseIf  ValType ( aFormats[i] ) == 'C'
            If AT ( '.', aFormats[i] ) > 0
               wyw += 26
            Else
               wyw += 26
            EndIf
         Else
            wyw += 26
         Endif
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
      VIRTUAL HEIGHT wyw ;
      TITLE cTitle ;
      MODAL ;
      NOSIZE ;
      ICON 'Edit' ;
      FONT 'Courier new' SIZE 9 ;
      BACKCOLOR ::aSystemColor

      ON KEY ESCAPE OF _inputwindow ACTION _myInputWindowCancel( _iw, aResult )

      ControlRow := 10

      FOR i := 1 TO l
         cLblName  := 'Label_' + Alltrim(Str(i))
         cCtrlName := 'Control_' + Alltrim(Str(i))

         @ ControlRow + 3, 10 LABEL &cLblName OF _inputwindow VALUE aLabels[i] AUTOSIZE

         DO CASE
         CASE ValType ( aValues[i] ) == 'L'
            @ ControlRow, 180 CHECKBOX &cCtrlName OF _inputwindow CAPTION '' VALUE aValues[i]
            ControlRow := ControlRow + 30
         CASE ValType ( aValues[i] ) == 'D'
            @ ControlRow, 180 DATEPICKER &cCtrlName OF _inputwindow VALUE aValues[i] WIDTH 420
            ControlRow := ControlRow + 26
         CASE ValType ( aValues[i] ) == 'N'
            If ValType ( aFormats[i] ) == 'A'
               @ ControlRow, 180 COMBOBOX &cCtrlName OF _inputwindow ITEMS aFormats[i] VALUE aValues[i] WIDTH 420  FONT 'Arial' SIZE 9
               ControlRow := ControlRow + 26
            ElseIf  ValType ( aFormats[i] ) == 'C'
               If AT ( '.', aFormats[i] ) > 0
                  @ ControlRow, 180 TEXTBOX &cCtrlName OF _inputwindow VALUE aValues[i] WIDTH 120 FONT 'Courier new' SIZE 9 NUMERIC INPUTMASK aFormats[i] RIGHTALIGN
                  ControlRow := ControlRow + 26
               Else
                  @ ControlRow, 180 TEXTBOX &cCtrlName OF _inputwindow VALUE aValues[i] WIDTH 120 FONT 'Courier new' SIZE 9 NUMERIC INPUTMASK aFormats[i] RIGHTALIGN
                  ControlRow := ControlRow + 26
               EndIf
            Else
               ControlRow := ControlRow + 26
            Endif
         CASE ValType ( aValues[i] ) == 'C'
            If ValType ( aFormats[i] ) == 'N'
               If  aFormats[i] <= 32
                  @ ControlRow, 180 TEXTBOX &cCtrlName OF _inputwindow VALUE aValues[i] WIDTH 270 FONT 'Courier new' SIZE 9 MAXLENGTH aFormats[i]
                  ControlRow := ControlRow + 26
               Else
                  @ ControlRow, 180 EDITBOX &cCtrlName OF _inputwindow WIDTH 420 HEIGHT 40 VALUE aValues[i] FONT 'Courier new' SIZE 9 MAXLENGTH aFormats[i] NOVSCROLL
                  ControlRow := ControlRow + 42
               EndIf
            Else
               ControlRow := ControlRow + 26
            EndIf
         CASE ValType ( aValues[i] ) == 'M'
            @ ControlRow, 180 EDITBOX &cCtrlName OF _inputwindow WIDTH 420 HEIGHT 90 VALUE aValues[i] FONT 'Courier new' SIZE 9
            ControlRow := ControlRow + 92
         OTHERWISE
            @ ControlRow, 180 TEXTBOX &cCtrlName OF _inputwindow NOBORDER BACKCOLOR ::aSystemColor NOTABSTOP READONLY WIDTH 270 FONT 'Courier new' SIZE 9 MAXLENGTH 10
            ControlRow := ControlRow + 26
         ENDCASE
      NEXT i

      DEFINE STATUSBAR
         STATUSITEM " "
         IF HB_IsBlock( bFunc )
         STATUSITEM "Font/Colors ." WIDTH 90 ACTION Eval( bFunc ) TOOLTIP "Change font and colors"
         ENDIF
         STATUSITEM "Ok          ." WIDTH 90 ACTION _myInputWindowOk( _iw, aResult )     TOOLTIP "Save changes"
         STATUSITEM "Cancel      ." WIDTH 90 ACTION _myInputWindowCancel( _iw, aResult ) TOOLTIP "Discard changes"
      END STATUSBAR

   END WINDOW

   CENTER WINDOW _InputWindow
   ACTIVATE WINDOW _InputWindow

   SET INTERACTIVECLOSE OFF
RETURN aResult

//------------------------------------------------------------------------------
STATIC FUNCTION _myInputWindowOk( oInputWindow, aResult )
//------------------------------------------------------------------------------
LOCAL i, l

   l := Len( aResult )
   FOR i := 1 TO l
      aResult[ i ] := oInputWindow:Control( 'Control_' + Alltrim( Str( i ) ) ):Value
   NEXT i
   oInputWindow:Release()
RETURN Nil

//------------------------------------------------------------------------------
STATIC FUNCTION _myInputWindowCancel( oInputWindow, aResult )
//------------------------------------------------------------------------------
   aFill( aResult, NIL )
   oInputWindow:Release()
RETURN Nil

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

  If Right( cOutfolder, 1 ) == '\'
     cOutFolder := Left( cOutFolder, Len( cOutFolder ) - 1 )
  EndIf

RETURN cOutFolder

//------------------------------------------------------------------------------
FUNCTION OnlyFolder( cFile )
//------------------------------------------------------------------------------
LOCAL i, nLen, cFolder, nPosFile

   IF Len( cFile ) > 0
      i := 1
      nLen := Len( cFile )
      DO WHILE ( nLen > i )
         if '\' $ Right( cFile, i - 1 )
            nPosFile := i - 1
            i := Len( cFile )
         ENDIF
         i ++
      ENDDO
      cFolder := Left( cFile,nLen - nPosfile )
   ELSE
      cFolder := NIL
   ENDIF
RETURN( cFolder )

//------------------------------------------------------------------------------
FUNCTION IsFileInPath( cFileName )
//------------------------------------------------------------------------------
LOCAL cDir, cName, cExt

   hb_FNameSplit( cFileName, @cDir, @cName, @cExt )

   For Each cDir In hb_ATokens( GetEnv( "PATH" ), hb_osPathListSeparator(), .T., .T. )
      If Left( cDir, 1 ) == '"' .AND. Right( cDir, 1 ) == '"'
         cDir := SubStr( cDir, 2, Len( cDir ) - 2 )
      EndIf
      If ! Empty( cDir )
         If ! Right( cDir, 1 ) == "\"
            cDir += "\"
         EndIf
         If File( cDir + cFileName )
            RETURN .T.
         EndIf
      EndIf
   NEXT
RETURN .F.

//------------------------------------------------------------------------------
FUNCTION Help_F1( c_p, myIde )
//------------------------------------------------------------------------------
LOCAL wr

   DO CASE
   CASE c_p == 'PROJECT'
      wr := CRLF
      wr := wr + "MANAGE PROJECTS" + CRLF + CRLF
      wr := wr + "CREATING PROJECTS" + CRLF
      wr := wr + "Select 'new projetc' from menu File, and you have a new project" + CRLF
      wr := wr + "with basic elements and a PRG main" + CRLF + CRLF

      wr := wr + "CHANGING PREFERENCES" + CRLF
      wr := wr + "Select 'preference' from menu File" + CRLF
      wr := wr + "Can change Date Format, Compile mode (Tradtional or BRmake)" + CRLF
      wr := wr + "Default Backcolor and linker options" + CRLF + CRLF

      wr := wr + "SAVING PROJECTS" + CRLF
      wr := wr + "Select 'Save projetc' from menu File" + CRLF + CRLF

      wr := wr + "ADDING ITEMS TO PROJECT TREE" + CRLF
      wr := wr + "Add forms,prg,ch,rpt,rc modules" + CRLF
      wr := wr + "Select the toolbar option ADD FORM or the dropdown menu option" + CRLF + CRLF

      wr := wr + "MODIFY ITEMS" + CRLF
      wr := wr + "Simply double click over item to modify" + CRLF + CRLF

      wr := wr + "REMOVE ITEMS." + CRLF
      wr := wr + "Select toolbar REMOVE ITEM button." + CRLF + CRLF

      wr := wr + "PRINT ITEMS." + CRLF
      wr := wr + "Select toolbar PRINT ITEM button." + CRLF + CRLF

      wr := wr + "BUILDING, RUNING AND DEBUGGING." + CRLF
      wr := wr + "to only build select toolbar BUILD PROJECT button." + CRLF
      wr := wr + "to build and run  select toolbar BUILD/RUN button." + CRLF
      wr := wr + "to only run select toolbar RUN button." + CRLF
      wr := wr + "to debug select toolbar dropdown menu DEBUG option." + CRLF + CRLF

      wr := wr + "SEARCHING TEXT." + CRLF
      wr := wr + "to search text over all project select toolbar GLOBAL SEARCH TEXT button." + CRLF + CRLF

      wr := wr + "QUICK BROWSING." + CRLF
      wr := wr + "to quick browse only select toolbar QUICK BROWSET button." + CRLF + CRLF

      wr := wr + "DATA MANAGEMENT." + CRLF
      wr := wr + "to more advanced browse, edit, modify select toolbar DATA MANAGER button." + CRLF + CRLF

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
      ICON 'Edit' ;
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
METHOD Repo_Edit( cFileRep ) CLASS THMI
//------------------------------------------------------------------------------
LOCAL nContLin, i
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
      nContLin := MLCount( cReport )
      FOR i := 1 TO nContLin
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
   IF aResults[1] == Nil
      RETURN Nil
   ENDIF

   Output := 'DO REPORT ;' + CRLF
   Output += "TITLE " + aResults[1] + ' ;' + CRLF
   Output += "HEADERS " + aResults[2] + ' ;' + CRLF
   Output += "FIELDS " + aResults[3] + ' ;' + CRLF
   Output += "WIDTHS " + aResults[4] + ' ;' + CRLF
   If Len( aResults[5] ) > 0
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
      MsgInfo( 'Report saved.', 'ooHG IDE+' )
   ELSE
      MsgInfo( 'Error saving report.', 'ooHG IDE+' )
   ENDIF
RETURN Nil

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
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP,
0);
}

/* copy - ctrl-c */
HB_FUNC( SEND_COPY )
{
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
   keybd_event(VK1_C, MapVirtualKey(VK1_C, 0), 0, 0);
   keybd_event(VK1_C, MapVirtualKey(VK1_C, 0), KEYEVENTF_KEYUP, 0);
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP,
0);
}

/* paste - ctrl-v */
HB_FUNC( SEND_PASTE )
{
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
   keybd_event(VK1_V, MapVirtualKey(VK1_V, 0), 0, 0);
   keybd_event(VK1_V, MapVirtualKey(VK1_V, 0), KEYEVENTF_KEYUP, 0);
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP,
0);
}

/* cut - ctrl-x */
HB_FUNC( SEND_CUT )
{
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
   keybd_event(VK1_X, MapVirtualKey(VK1_X, 0), 0, 0);
   keybd_event(VK1_X, MapVirtualKey(VK1_X, 0), KEYEVENTF_KEYUP, 0);
   keybd_event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP,
0);
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

   IF nMsg == WM_LBUTTONDOWN
      ::DoEventMouseCoords( ::OnClick, "CLICK" )
   ENDIF

RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

/*
 * EOF
 */
