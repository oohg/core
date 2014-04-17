/*
 * $Id: mgide.prg,v 1.2 2014-04-17 00:21:33 fyurisich Exp $
 */

#include "oohg.ch"
#include "hbclass.ch"
#include "common.ch"
#include "i_keybd.ch"

#DEFINE CRLF hb_OSNewLine()
#DEFINE CR chr(13)
#DEFINE LF chr(10)
#DEFINE cNameApp "Harbour ooHG IDE Plus"+" v."+substr(__DATE__,3,2)+"."+right(__DATE__,4) // MigSoft

#ifdef __HARBOUR__
   #xtranslate Curdrive() => hb_Curdrive()    // MigSoft
#endif

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                            Main Function
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

*-------------------------
FUNCTION MAIN(rtl1)
*-------------------------
public nhandlep := 0, whlp := ''
public myide,myform,exedir := ''
public rtl                 := rtl1
Public mgideFolder         := GetStartupFolder()        // MigSoft
Public pmgFolder           := ''                        // MigSoft
Public cDrive              := substr(GetExeFileName(),1,2)       /////// Current aplication Drive
private editbcvc

   SET CENTURY ON
   SET DELETED ON

SETAPPhotkey( VK_F10, 0, { || _OOHG_CallDump() } )
SetAppHotKey( VK_F11, 0, { || automsgbox(&(INPUTBOX("Que Variable desea saber","Pregunta"))) } )

   if rtl#NIL
      rtl = upper(rtl)
      if rtl="RTL"
         SET GLOBALRTL ON
         rtl:=NIL
      endif
   endif



   myide:=thmi()
   myide:newide(rtl)
   myide:end()
   release myide
RETURN NIL


*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                               THMI Class
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

CLASS THMI

   VAR cfile              INIT ''
   VAR cprojectname       INIT ''

   VAR cProjFolder        INIT ''
   VAR cOutFile           INIT ''

   VAR cExteditor         INIT ''

   VAR cGuiHbBCC          INIT ''
   VAR cGuiHbMinGW        INIT ''
   VAR cGuiHbPelles       INIT ''

   VAR cGuixHbBCC         INIT ''
   VAR cGuixHbMinGW       INIT ''
   VAR cGuixHbPelles      INIT ''

   VAR cHbBCCFolder       INIT ''
   VAR cHbMinGWFolder     INIT ''
   VAR cHbPellFolder      INIT ''

   VAR cxHbBCCFolder      INIT ''
   VAR cxHbMinGWFolder    INIT ''
   VAR cxHbPellFolder     INIT ''

   VAR cBCCFolder         INIT ''
   VAR cMinGWFolder       INIT ''
   VAR cPellFolder        INIT ''

   VAR nCompxBase         INIT 1
   VAR nCompilerC         INIT 2

   VAR ltbuild            INIT 1
   VAR lsnap              INIT 0
   VAR clib               INIT ""

   VAR asystemcolor       INIT {215,231,244}
   VAR asystemcoloraux    INIT  {}
   VAR swvan              INIT .F.
   VAR swsalir            INIT .F.
   VAR lPsave             INIT .T.
   VAR _ncaretpos         INIT  0
   VAR alinet             INIT {}
   VAR lsave              INIT .T.
   VAR npostext           INIT 0
   VAR ncrlf              INIT 0
   VAR van                INIT 0
   VAR ctext              INIT ''
   VAR ntemp              INIT 0
   VAR cdbackcolor        INIT 'NIL'

   VAR aliner             INIT {}
   VAR lvirtual           INIT .T.

   VAR mainheight         INIT 50 + GetTitleHeight() + GetBorderHeight()
   VAR form_activated     INIT .F.

   METHOD newide()  CONSTRUCTOR
   METHOD end()
   METHOD exit()
   METHOD deleteitemp()
   METHOD printit()
   METHOD about()
   METHOD dataman()
   METHOD splashdelay()
   METHOD preferences()
   METHOD okprefer()
   METHOD searchtext()
   METHOD BldMinGW( nOption )
   METHOD Buildbcc( nOption )
   METHOD BldPellC( nOption )
   METHOD xBldMinGW( nOption )
   METHOD xBuildBCC( nOption )
   METHOD xBldPellC( nOption )
   METHOD viewsource( wr )
   METHOD viewerrors( wr )
   METHOD runp()
   METHOD newproject()
   METHOD openproject()
   METHOD saveproject()

   METHOD newform()
   METHOD newformfromar(cPform)
   METHOD Newprgfromar(cPprg)
   METHOD Newchfromar(cPch)
   METHOD Newrcfromar(cPrc)
   METHOD Newrptfromar(cPrpt)

   METHOD Newprg()
   METHOD Newch()
   METHOD Newrc()
   METHOD Newrpt()

   METHOD searchitem(cnameitem,cparent)
   METHOD searchtypeadd(nvalue)
   METHOD searchtype()
   METHOD modifyitem()
   METHOD modifyRpt()
   METHOD modifyform()

   METHOD savefile(cdfile)
   METHOD Openfile(cdfile)
   METHOD goline()
   METHOD lookchanges()
   METHOD posxy()
   METHOD txtsearch()
   METHOD nextsearch()
   METHOD saveandexit(cdfile)
   METHOD databaseview()
   METHOD exitview()
   METHOD disable_button()
   METHOD exitform()
   METHOD setasmain()

ENDCLASS
RETURN NIL

*-------------------------
METHOD SETASMAIN( ) CLASS THMI
*-------------------------
//cnomain:=form_tree.tree_1.item(form_tree.tree_1.value)
///if searchtype(cnomain)# "Prg module"
///   return nil
///else
///   nnomain:=form_tree.tree_1.value
///endif
//nmain:=searchitem("Prg module","Prg module")
///nmain:=++
///if form_tree.tree_1.item(nmain)#"CH module"   //// todo ok
///   t:=cnomain
///   form_tree.tree_1.item(form_tree.tree_1.value):=form_tree.tree_1.item(nmain)
///   form_tree.tree_1.item(nmain):=t
//else

//endif
return nil

*-------------------------
METHOD NEWIDE(rtl) CLASS THMI
*-------------------------
local i,npos,capellido,cnombre
public csyscolor,cvccvar

SET DELETED ON
SET CENTURY ON
SET EXACT ON
SET INTERACTIVECLOSE OFF
SET NAVIGATION EXTENDED
set BROWSESYNC ON

DECLARE WINDOW form_tree
DECLARE WINDOW form_prefer
DECLARE WINDOW form_main
DECLARE WINDOW _errors
DECLARE WINDOW editbcvc
DECLARE WINDOW form_brow
DECLARE WINDOW cvcControls
DECLARE WINDOW waitmess
DECLARE WINDOW form_splash

cHelpdir := getcurrentfolder()
exedir   := mgidefolder                          // MigSoft
lCorre   := .F.   ///// no es proyecto

if rtl#NIL .and. rtl#"RTL"
   rtl:=lower(rtl)
   npos:=at(".",rtl)
   if npos>0
      capellido := substr(rtl,npos+1,3)
      cnombre   := substr(rtl,1,npos-1)
      if lower(capellido)="pmg"
         lcorre := .T.
      endif
   endif
else
   if file(exedir)
      cvccvar:=alltrim(memoread(exedir))
      dirchange(cvccvar)
   endif
endif

nesquema := 4
nRed     := GETRED(GETSYSCOLOR(nesquema))
nGreen   := GETGREEN(GETSYSCOLOR(nesquema))
nBlue    := GETBLUE(GETSYSCOLOR(nesquema))

csyscolor             :='{'+str(nred,3)+','+str(ngreen,3)+','+str(nblue,3)+'}'
myide:asystemcoloraux := &csyscolor
cvcx                  :=getdesktopwidth()
cvcy                  :=getdesktopheight()

if cvcx<800 .or. cvcy<600
   msginfo('800 x 600 or grater  Best viewed','Information')
endif

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                      Main Window -  760 x 500   30,134
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

DEFINE WINDOW form_tree OBJ Form_tree ;
   AT 0,0 ;
   WIDTH 800 ;
   HEIGHT 600 ;
   TITLE cNameApp ;
   MAIN ;
   FONT "Times new Roman" SIZE 11 ;
   ICON "Edit" ;
   ON SIZE AjustaFrame(oFrame,oTree) ;     // MigSoft
   ON INTERACTIVECLOSE IF(MsgYesNo("Exit Program ?",left(cNameApp,16)),myide:exit(), .F.) ;
   NOSHOW ;
   backcolor myide:asystemcolor

   DEFINE STATUSBAR FONT "Verdana" SIZE 9       // MigSoft
      STATUSITEM cNameApp+"                                 F1 Help    F5 Build    F6 Build / Run    F7 Run    F8 Debug"
   END STATUSBAR

   DEFINE MAIN MENU
      POPUP '&File'
         ITEM '&New project ' ACTION myide:newproject()
         ITEM '&Open Project' ACTION myide:openproject()
         ITEM '&Save Project' ACTION myide:saveproject()
         SEPARATOR
         ITEM '&Preferences' ACTION myide:preferences()
         SEPARATOR
         ITEM '&Exit' ACTION myide:exit()
      END POPUP
      POPUP 'Pro&ject'
         POPUP 'Add' NAME 'Add'                    // MigSoft
            ITEM 'Form ' ACTION myide:newform()
            ITEM 'Prg  ' ACTION myide:newprg()
            ITEM 'CH   ' ACTION myide:newch()
            ITEM 'Rpt  ' ACTION myide:newrpt()
            ITEM 'RC   ' ACTION myide:newrc()
         end popup
         SEPARATOR
         ITEM "Modify item" Action analizar()
         SEPARATOR
         ITEM 'Remove Item' ACTION myide:deleteitemp()
         SEPARATOR
         ITEM 'View / Print Item' ACTION myide:printit()
      END POPUP
      POPUP 'Build / Run / Debug'
         ITEM 'Build Project'       ACTION CompileOptions(1)
         ITEM 'Build / Run Project' ACTION CompileOptions(2)
         ITEM 'Run Project'         ACTION CompileOptions(3)
         ITEM 'Debug'               ACTION CompileOptions(4)
      END POPUP
      POPUP 'Tools'
         ITEM 'Global Search Text'  ACTION myide:searchtext()
         ITEM 'Quickbrowse'  ACTION myide:databaseview()
         ITEM 'Data Manager'  ACTION myide:dataman()
      END POPUP

      POPUP '&Help'
         ITEM 'ooHG Syntax Help' ACTION  ayuhelp()  ////////////  DISPLAY HELP MAIN
         ITEM '&About' ACTION myide:about()
         ITEM 'Shell info' ACTION shellabout(cNameApp,"Shell info")
      END POPUP
   END MENU

   ON KEY F1 action help_f1('PROJECT')
   ON KEY F5 action CompileOptions(1)
   ON KEY F6 action CompileOptions(2)
   ON KEY F7 action CompileOptions(3)
   ON KEY F8 action CompileOptions(4)

   @ 65,30 frame frame_tree OBJ oFrame width cvcx-30  height cvcy-65

   DEFINE TREE Tree_1 OBJ oTree AT 90,50 WIDTH 200 HEIGHT cvcy-290 VALUE 1 ;   // MigSoft
      TOOLTIP 'Double click to modify items'   ;
      ON DBLCLICK analizar() ;
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
      ACTION IF(MsgYesNo("Exit Program ?",left(cNameApp,16)),myide:exit(), Nil) AUTOSIZE

      BUTTON Button_1 ;
      TOOLTIP 'New...' ;
      PICTURE 'M2';
      ACTION myide:newform() DROPDOWN AUTOSIZE

      BUTTON Button_1b ;
      TOOLTIP 'Open...' ;
      PICTURE 'M3';
      ACTION myide:openproject() AUTOSIZE

      BUTTON Button_01 ;
      TOOLTIP 'Save...' ;
      PICTURE 'M4';
      ACTION myide:saveproject() AUTOSIZE

      BUTTON Button_7 ;
      TOOLTIP 'Remove Item' ;
      PICTURE 'M5' ;
      ACTION myide:deleteitemp() AUTOSIZE

      BUTTON Button_7a ;
      TOOLTIP 'View / Print Item' ;
      Picture 'M6' ;
      ACTION myide:printit() separator AUTOSIZE

      BUTTON Button_9 ;
      TOOLTIP 'Build project' ;
      PICTURE 'M7';
      ACTION CompileOptions(1)

      BUTTON Button_10 ;
      TOOLTIP 'Build / Run' ;
      PICTURE 'M8' ;
      ACTION CompileOptions(2)

      BUTTON Button_11 ;
      TOOLTIP 'Run' ;
      PICTURE 'M9';
      ACTION CompileOptions(3) DROPDOWN AUTOSIZE separator

      BUTTON Button_8 ;
      TOOLTIP 'Global Search Text' ;
      PICTURE 'M10';
      ACTION myide:Searchtext() separator AUTOSIZE

      BUTTON Button_qb ;
      TOOLTIP 'Quick Browse' ;
      PICTURE 'M11';
      ACTION myide:databaseview() AUTOSIZE

      BUTTON Button_12 ;
      TOOLTIP 'Data Manager' ;
      PICTURE 'M12';
      ACTION myide:dataman() AUTOSIZE

   END TOOLBAR

   DEFINE DROPDOWN MENU BUTTON Button_1
      ITEM 'Form'    ACTION myide:newform()
      ITEM 'Prg'     ACTION myide:newprg()
      ITEM 'CH'      ACTION myide:newch()
      ITEM 'Rpt'     ACTION myide:newrpt()
      ITEM 'RC'      ACTION myide:newrc()
   END MENU

   DEFINE DROPDOWN MENU BUTTON Button_11
      ITEM 'Run  ' ACTION CompileOptions(3)
      ITEM 'Debug' ACTION CompileOptions(4)
   END MENU

   END SPLITBOX

   @ 135,280 image image_front OBJ image_front ;
   picture 'hmiq'          ;
   width 420               ;
   height 219              ;

   form_tree:tree_1:fontitalic:=.T.

   If Empty(rtl)
      Desactiva(0)  // MigSoft
   Else
      Desactiva(1)  // MigSoft
   Endif

END WINDOW

   DEFINE WINDOW Form_Splash obj Form_splash ;
   AT 0,0 ;
   WIDTH 584 HEIGHT 308 ;
   TITLE '';
   MODAL TOPMOST NOCAPTION ;
   ON INIT myide:SplashDelay() ;

   @ 0,0 IMAGE image_splash PICTURE 'hmi'  ;
   WIDTH 584 ;
   HEIGHT 308

   END WINDOW

   CENTER WINDOW Form_Splash
   CENTER WINDOW form_tree

   IF .NOT. FILE('hmi.INI')
      a := MEMOWRIT('hmi.INI','[PROJECT]')
   ENDIF

   BEGIN INI FILE 'hmi.INI'

   //****************** PROJECT
   GET myide:cProjFolder     SECTION 'PROJECT'  ENTRY "PROJFOLDER"    default ''      // MigSoft
   GET myide:cOutFile        SECTION 'PROJECT'  ENTRY "OUTFILE"       default ''
   //****************** EDITOR
   GET myide:cExteditor      SECTION 'EDITOR'   ENTRY "EXTERNAL"      default ''
   //****************** OOHG
   GET myide:cGuiHbMinGW     SECTION 'GUILIB'   ENTRY "GUIHBMINGW"    default 'c:\oohg'
   GET myide:cGuiHbBCC       SECTION 'GUILIB'   ENTRY "GUIHBBCC"      default 'c:\oohg'
   GET myide:cGuiHbPelles    SECTION 'GUILIB'   ENTRY "GUIHBPELL"     default 'c:\oohg'
   GET myide:cGuixHbMinGW    SECTION 'GUILIB'   ENTRY "GUIXHBMINGW"   default 'c:\oohg'
   GET myide:cGuixHbBCC      SECTION 'GUILIB'   ENTRY "GUIXHBBCC"     default 'c:\oohg'
   GET myide:cGuixHbPelles   SECTION 'GUILIB'   ENTRY "GUIXHBPELL"    default 'c:\oohg'
   //****************** HARBOUR
   GET myide:cHbMinGWFolder  SECTION 'HARBOUR'  ENTRY "HBMINGW"       default 'c:\harbourm'
   GET myide:cHbBCCFolder    SECTION 'HARBOUR'  ENTRY "HBBCC"         default 'c:\harbourb'
   GET myide:cHbPellFolder   SECTION 'HARBOUR'  ENTRY "HBPELLES"      default 'c:\harbourp'
   //****************** XHARBOUR
   GET myide:cxHbMinGWFolder SECTION 'HARBOUR'  ENTRY "XHBMINGW"      default 'c:\xharbourm'
   GET myide:cxHbBCCFolder   SECTION 'HARBOUR'  ENTRY "XHBBCC"        default 'c:\xharbourb'
   GET myide:cxHbPellFolder  SECTION 'HARBOUR'  ENTRY "XHBPELLES"     default 'c:\xharbourp'
   //****************** C COMPILER
   GET myide:cMinGWFolder    SECTION 'COMPILER' ENTRY "MINGWFOLDER"   default 'c:\MinGW'
   GET myide:cBCCFolder      SECTION 'COMPILER' ENTRY "BCCFOLDER"     default 'c:\Borland\BCC55'
   GET myide:cPellFolder     SECTION 'COMPILER' ENTRY "PELLESFOLDER"  default 'c:\PellesC'
   //****************** MODE
   GET myide:nCompxBase      SECTION 'WHATCOMP' ENTRY "XBASECOMP"     default 1  // 1 Harbour  2 xHarbour
   GET myide:nCompilerC      SECTION 'WHATCOMP' ENTRY "CCOMPILER"     default 2  // 1 MinGW    2 BCC   3 Pelles C
   //****************** OTHER
   GET myide:ltbuild         SECTION 'SETTINGS' ENTRY "BUILD"         default 2  // 1 Compile.bat 2 Owm Make
   GET myide:lsnap           SECTION 'SETTINGS' ENTRY "SNAP"          default 0
   GET myide:clib            SECTION 'SETTINGS' ENTRY "LIB"           default ''

   END INI

    DEFINE WINDOW waitmess obj waitmess  ;
    AT 10,10  ;
    width 150 ;
    height 100 ;
    Title "Information"  CHILD NOSYSMENU NOCAPTION NOSHOW  ;
    backcolor myide:asystemcolor

    @ 35,15 label hmi_label_101 value '              '  autosize font 'Times new Roman'  SIZE 14

    END WINDOW

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                          Horizontal buttons
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

   DEFINE WINDOW  Form_main ;
   AT 0,0 ;
   WIDTH 689 ;
   HEIGHT 104 ;
   TITLE '' ;
   CHILD ;
   NOSHOW  ;
   NOMAXIMIZE ;
   NOSIZE ;
   OBJ Form_main ;
   ICON "Edit" ;
   FONT 'MS Sans Serif' ;
   SIZE 10 ;
   backcolor myide:asystemcolor ;
   ON MINIMIZE  minim() ;
   ON MAXIMIZE  maxim() ;
   ON RESTORE maxim()


   @ 17,10 BUTTON exit ;
   PICTURE 'A1';
   ACTION myide:exitform() ;
   WIDTH 28 ;
   HEIGHT 28 ;
   TOOLTIP 'Exit' ;

   @ 17,41 BUTTON save ;
   PICTURE 'A2';
   ACTION {|| myform:Save(0) } ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Save' ;

   @ 17,73 BUTTON save_as ;
   PICTURE 'A3';
   ACTION myform:save(1) ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Save as' ;

   @ 17,112 BUTTON form_prop ;
   PICTURE 'A4';
   ACTION frmproperties() ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Properties' ;

   @ 17,144 BUTTON events_prop ;
   PICTURE 'A5';
   ACTION frmevents() ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Events' ;

   @ 17,176 BUTTON form_mc ;
   PICTURE 'A6';
   ACTION intfoco(0) ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Fonts and Colors' ;

   @ 17,209 BUTTON tbc_fmms ;
   PICTURE 'A7';
   ACTION manualmosi(0) ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Manual Move/Size' ;

   @ 17,240 BUTTON mmenu1 ;
   PICTURE 'A8';
   ACTION tmymenu:menu_ed( 1 ) ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Main Menu' ;

   @ 17,273 BUTTON mmenu2 ;
   PICTURE 'A9';
   ACTION tmymenu:menu_ed( 2 ) ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Context Menu' ;

   @ 17,303 BUTTON mmenu3 ;
   PICTURE 'A10';
   ACTION tmymenu:menu_ed( 3 ) ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Notify Menu' ;

   @ 17,337 BUTTON toolb ;
   PICTURE 'A11';
   ACTION { || tmytoolb:tb_ed() } ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Toolbar' ;

   @ 17,368 BUTTON form_co ;
   PICTURE 'A12';
   ACTION ordercontrol() ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Order' ;

   @ 17,400 BUTTON  butt_status ;
   PICTURE 'A13';
   ACTION { || myform:verifybar() } ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Statusbar On/Off' ;

   @ 17,444 BUTTON tbc_prop ;
   PICTURE 'A4';
   ACTION properties_click() ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Properties' ;

   @ 17,477 BUTTON tbc_events ;
   PICTURE 'A5';
   ACTION events_click()  ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Events' ;

   @ 17,510 BUTTON tbc_ifc ;
   PICTURE 'A6';
   ACTION intfoco(1)  ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Font Color' ;

   @ 17,540 BUTTON tbc_mms  ;
   PICTURE 'A7';
   ACTION manualmosi(1)  ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Manual Move/Size' ;

   @ 17,572 BUTTON tbc_im ;
   PICTURE 'A17';
   ACTION movecontrol()  ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Interactive Move' ;

   @ 17,604 BUTTON tbc_is ;
   PICTURE 'A14';
   ACTION sizecontrol()  ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Interactive Size' ;

   @ 17,634 BUTTON tbc_del ;
   PICTURE 'A16';
   ACTION deletecontrol() ;
   WIDTH 30 ;
   HEIGHT 28 ;
   TOOLTIP 'Delete' ;

   @ 0,105 FRAME frame_1 ;
   CAPTION "Form : " ;
   WIDTH 332 ;
   HEIGHT 65 ;
   OPAQUE  ;
   TRANSPARENT  ;

   form_main.frame_1.fontcolor:= { 0,0,0 }
   form_main.frame_1.fontname:="MS Sans Serif"
   form_main.frame_1.fontsize:=9

   @ 0,436 FRAME frame_2 ;
   CAPTION "Control : " ;
   WIDTH 236 ;
   HEIGHT 65 ;
   OPAQUE ;

   form_main.frame_2.fontcolor:= { 0,0,0 }
   form_main.frame_2.fontname:="MS Sans Serif"
   form_main.frame_2.fontsize:=9

   @ 0,4 FRAME frame_3 ;
   CAPTION "Action" ;
   WIDTH 105 ;
   HEIGHT 65  ;

   form_main.frame_3.fontcolor:=  { 0,0,0 }
   form_main.frame_3.fontname:="MS Sans Serif"
   form_main.frame_3.fontsize:=9

   @ 48,115 LABEL label_1 ;
   WIDTH 120 ;
   HEIGHT 24 ;
   VALUE '' ;
   FONT 'MS Sans Serif' ;
   SIZE 9  ;
   AUTOSIZE  ;

   form_main.label_1.fontcolor:=  { 0,0,0 }

   @ 48,446 LABEL label_2 ;
   WIDTH 120 ;
   HEIGHT 24 ;
   VALUE 'r:    c:    w:    h: ' ;
   FONT 'MS Sans Serif' ;
   SIZE 9  ;
   AUTOSIZE ;

   form_main.label_2.fontcolor:=  { 0,0,0 }

   @ 48,300 LABEL labelyx ;
   WIDTH 98 ;
   HEIGHT 24 ;
   VALUE '0000,0000' ;
   FONT 'MS Sans Serif' ;
   SIZE 9  ;
   AUTOSIZE ;

   END WINDOW



////ON KEY ALT+D ACTION debug()

   tmymenu  := tmymenued()
   tmytoolb := tmytoolbared()

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                          Vertical Checkbuttons
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

public lsi := .T.   ///// variable publica que evita la recursividad del on change en el checkbutton
DEFINE WINDOW cvcControls obj cvcControls ;
   AT 120 , 0 ;
   WIDTH 65 ;
   HEIGHT 450 + GetTitleHeight() + GetBorderheight() ;
   TITLE 'Controls' ;
   ICON 'VD' ;
   CHILD NOSHOW ; // NOCAPTION ;
   NOSIZE NOMAXIMIZE ;
   NOAUTORELEASE ;
   NOMINIMIZE ;
   NOSYSMENU ;
   backcolor myide:asystemcolor

   @ 001,0 CHECKBUTTON Control_01 ;
   PICTURE 'SELECT' ;
   VALUE .T. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Select Object' ;
   ON CHANGE myform:Control_Click(1)

   @ 001,29 CHECKBUTTON Control_02 ;
   PICTURE 'BUTTON1' ;                     // Cambio en .RC
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Button and ButtonMixed' ;
   ON CHANGE myform:Control_Click(2)

   @ 030,0 CHECKBUTTON Control_03 ;
   PICTURE 'CHECKBOX1' ;                     // Cambio en .RC
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'CheckBox' ;
   ON CHANGE myform:Control_Click(3)

   @ 030,29 CHECKBUTTON Control_04 ;
   PICTURE 'LISTBOX1' ;                     // Cambio en .RC
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'ListBox' ;
   ON CHANGE myform:Control_Click(4)

   @ 060,0 CHECKBUTTON Control_05 ;
   PICTURE 'COMBOBOX1' ;                     // Cambio en .RC
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'ComboBox' ;
   ON CHANGE myform:Control_Click(5)

   @ 060,29 CHECKBUTTON Control_06 ;
   PICTURE 'CHECKBUTTON' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'CheckButton' ;
   ON CHANGE myform:Control_Click(6)

   @ 090,0 CHECKBUTTON Control_07 ;
   PICTURE 'GRID' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Grid' ;
   ON CHANGE myform:Control_Click(7)

   @ 090,29 CHECKBUTTON Control_08 ;
   PICTURE 'FRAME' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Frame' ;
   ON CHANGE  myform:Control_Click(8)

   @ 120,0 CHECKBUTTON Control_09 ;
   PICTURE 'TAB' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Tab' ;
   ON CHANGE myform:Control_Click(9)

   @ 120,29 CHECKBUTTON Control_10 ;
   PICTURE 'IMAGE' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Image' ;
   ON CHANGE myform:Control_Click(10)

   @ 150,0 CHECKBUTTON Control_11 ;
   PICTURE 'ANIMATEBOX' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'AnimateBox' ;
   ON CHANGE myform:Control_Click(11)

   @ 150,29 CHECKBUTTON Control_12 ;
   PICTURE 'DATEPICKER' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'DatePicker' ;
   ON CHANGE myform:Control_Click(12)

   @ 180,0 CHECKBUTTON Control_13 ;
   PICTURE 'TEXTBOX' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'TextBox' ;
   ON CHANGE myform:Control_Click(13)

   @ 180,29 CHECKBUTTON Control_14 ;
   PICTURE 'EDITBOX' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'EditBox' ;
   ON CHANGE myform:Control_Click(14)

   @ 210,0 CHECKBUTTON Control_15 ;
   PICTURE 'LABEL' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Label' ;
   ON CHANGE myform:Control_Click(15)

   @ 210,29 CHECKBUTTON Control_16 ;
   PICTURE 'PLAYER' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Player' ;
   ON CHANGE myform:Control_Click(16)

   @ 240,0 CHECKBUTTON Control_17 ;
   PICTURE 'PROGRESSBAR' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'ProgressBar' ;
   ON CHANGE myform:Control_Click(17)

   @ 240,29 CHECKBUTTON Control_18 ;
   PICTURE 'RADIOGROUP' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'RadioGroup' ;
   ON CHANGE myform:Control_Click(18)

   @ 270,0 CHECKBUTTON Control_19 ;
   PICTURE 'SLIDER' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Slider' ;
   ON CHANGE myform:Control_Click(19)

   @ 270,29 CHECKBUTTON Control_20 ;
   PICTURE 'SPINNER' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Spinner' ;
   ON CHANGE myform:Control_Click(20)

   @ 300,0 CHECKBUTTON Control_21 ;
   PICTURE 'IMAGECHECKBUTTON' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Picture CheckButton' ;
   ON CHANGE myform:Control_Click(21)

   @ 300,29 CHECKBUTTON Control_22 ;
   PICTURE 'IMAGEBUTTON' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Picture Button' ;
   ON CHANGE myform:Control_Click(22)

   @ 330,0 CHECKBUTTON Control_23 ;
   PICTURE 'TIMER' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Timer' ;
   ON CHANGE myform:Control_Click(23)

   @ 330,29 CHECKBUTTON Control_24 ;
   PICTURE 'GRID' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Browse' ;
   ON CHANGE myform:Control_Click(24)

   @ 360,0 CHECKBUTTON Control_25 ;
   PICTURE 'TREE' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Tree' ;
   ON CHANGE myform:Control_Click(25)

   @ 360,29 CHECKBUTTON Control_26 ;
   PICTURE 'IPAD' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'IPAddress' ;
   ON CHANGE myform:Control_Click(26)

   @ 390,0 CHECKBUTTON Control_27 ;
   PICTURE 'MONTHCAL' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Monthcalendar' ;
   ON CHANGE myform:Control_Click(27)

   @ 390,29 CHECKBUTTON Control_28 ;
   PICTURE 'HYPLINK' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Hyperlink' ;
   ON CHANGE myform:Control_Click(28)

   @ 420,0 CHECKBUTTON Control_29 ;
   PICTURE 'RICHEDIT' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'Richeditbox' ;
   ON CHANGE myform:Control_Click(29)

   @ 420,29 CHECKBUTTON Control_30 ;
   PICTURE 'stat' ;
   VALUE .F. WIDTH 28 HEIGHT 28 ;
   TOOLTIP 'StatusBar' ;
   ON CHANGE statpropevents()

END WINDOW

*waitmess:center()
CENTER WINDOW waitmess

   if lcorre
      openauxi(cnombre)
      RTL:=NIL
   endif


if rtl=NIL
   ACTIVATE WINDOW form_tree,form_main,waitmess,cvccontrols,form_splash
else
   form_tree.hide
   ACTIVATE WINDOW form_tree,form_main,waitmess,cvccontrols,form_splash nowait
   analizar(rtl)
endif
Return

Procedure AjustaFrame(oFrame,oTree) // MigSoft
   LOCAL aInfo
   aInfo := ARRAY( 4 )
   GetClientRect( form_tree:hWnd, aInfo )

   oframe:width  := aInfo[ 3 ] - 65
   oframe:height := aInfo[ 4 ] - 120
   oTree:height  := oframe:height - 50

   If ( oframe:width < ( image_front:width + 270 ) ) .OR. ( oframe:height < ( image_front:height + 80 ) )
      HIDE CONTROL image_front OF form_tree
   Else
      SHOW CONTROL image_front OF form_tree
   Endif

Return

function ayuhelp()
EXECUTE FILE CHELPDIR+"\oohg.chm"
return nil

Function Desactiva(nOp)   // MigSoft
   If nOp = 0
      SetProperty('Form_tree','Add','enabled',.F.)
      SetProperty('Form_tree','Button_1','enabled',.F.)
    Else
      SetProperty('Form_tree','Add','enabled',.T.)
      SetProperty('Form_tree','Button_1','enabled',.T.)
    Endif
Return Nil

Function BorraTemp()    // MigSoft

*   ferase('_temp.log')
*   ferase('_temp1.log')
   ferase('_Build.bat')
   ferase('Makefile.Gcc')
   ferase('error.lst')
   ferase('End.Txt')
   ferase('_temp.rc')
   ferase('b32.bc')
   ferase('_Temp.bc')

Return Nil

Procedure BorraObj()   // MigSoft

LOCAL aOBJFilesB[ADIR( 'OBJ\*.OBJ')]
LOCAL aCFiles[ADIR( 'OBJ\*.C')]
LOCAL aObjFiles[ADIR( 'OBJ\*.O')]
LOCAL aMapFiles[ADIR( '*.MAP')]
LOCAL aTdsFiles[ADIR(  '*.TDS')]
LOCAL i

	ADIR ( 'OBJ\*.OBJ' , aOBJFilesB )
	ADIR ( 'OBJ\*.C'   , aCFiles )
	ADIR ( 'OBJ\*.O'   , aObjFiles )
	ADIR ( '*.MAP'     , aMapFiles )
	ADIR ( '*.TDS'     , aTdsFiles )

        For i := 1 To Len (aCFiles)
            DELETE FILE ( 'OBJ\' + aCFiles[i] )
        Next i
        For i := 1 To Len (aObjFiles)
            DELETE FILE ( 'OBJ\' +  aObjFiles[i] )
        Next i
        For i := 1 To Len (aOBJFilesB)
            DELETE FILE ( 'OBJ\' + aOBJFilesB[i] )
        Next i
        For i := 1 To Len (aMapFiles)
            DELETE FILE ( aMapFiles[i] )
        Next i
        For i := 1 To Len (aTdsFiles)
            DELETE FILE ( aTdsFiles[i] )
        Next i

        DIRREMOVE('OBJ')  // MigSoft

Return

function refrefo()

local nrow:= form_1:row
local ncol:= form_1:col
local nwidth:= form_1:width
local nheight:= form_1:height
local clabel := "r:"+alltrim(str(nrow,4))+" c:"+alltrim(str(ncol,4))+" w:"+alltrim(str(nwidth,4))+" h:"+alltrim(str(nheight,4))
form_main:label_1:value :=  clabel
return nil

*------------------------------------------------------------------------------*
METHOD END() CLASS THMI
*------------------------------------------------------------------------------*
return self

*------------------------------------------------------------------------------*
Function analizar(cFormx)
*------------------------------------------------------------------------------*
Local cItem,cParent
cItem:= Form_tree:Tree_1:Item ( Form_tree:Tree_1:value )
cParent= myide:searchtype(citem)
if HB_IsString( cFormx )
   cParent:="Form module"
   cItem:=Cformx
endif
if cParent=='Form module' .and. cItem#cParent .and. cItem#'Project'
   if .not. myide:form_activated
*       HIDE WINDOW form_tree                                        // MigSoft
       form_main:frame_2:caption:="Control : "
       myide:modifyform(cItem,cParent)
*       SHOW WINDOW form_tree
   else
       msginfo('only one form can be edited at the same time','Information')
       return nil
   endif
endif
if ( cParent=='Prg module' .and. cItem#cParent .and. cItem#'Project') .or. ;
   ( cParent=='CH module' .and. cItem#cParent )  .or. ;
   ( cParent=='RC module' .and. cItem#cParent )
   myide:modifyitem(cItem,cParent)
endif
if cParent=='Rpt module' .and. cItem#cParent .and. cItem#'Project'
   myide:modifyrpt(cItem,cParent)
endif
return nil

*------------------------------------------------------------------------------*
METHOD Exit() CLASS THMI
*------------------------------------------------------------------------------*
local a
if .not. myide:lPsave
   if msgyesno('Project not saved (save ?)','Question')
      myide:saveproject()
   endif
endif
a:=memowrit(exedir,getcurrentfolder())
myide:end()
if iswindowactive(form_tree)
   form_tree:release()
endif
Return

*-------------------------
METHOD printit() CLASS THMI
*-------------------------
local citem,cParent,cArch,i,contlin
set interactiveclose on
public _oohg_printlibrary:="HBPRINTER"
cItem:= Form_tree:Tree_1:Item ( Form_tree:Tree_1:value )
cParent= myide:searchtype(citem)
if myide:searchtype(citem)=='Prg module' .and. cItem#'Prg module'
   cArch:=memoread(citem+'.prg')
else
   if myide:searchtype(citem)=='Form module' .and. cItem#'Form module'
      cArch:=memoread(citem+'.fmg')
   else
      if myide:searchtype(citem)=='CH module' .and. cItem#'CH module'
         cArch:=memoread(citem+'.ch')
      else
         if myide:searchtype(citem)=='Rpt module' .and. cItem#'Rpt module'
            cArch:=memoread(citem+'.rpt')
         else
            if myide:searchtype(citem)=='RC module' .and. cItem#'RC module'
               cArch:=memoread(citem+'.rc')
            else
               msginfo("This item Can't be printed",'Information')
               return
            endif
         endif
      endif
   endif
endif
myide:viewsource(cArch)
return nil

/**********************************************/
Procedure CompileOptions( nOpt )
/**********************************************/

   Do Case
      Case nOpt = 1  // Only Make
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=1 )  // Harbour-MinGW
              myide:BldMinGW(0)
           Endif
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=2 )  // Harbour-BCC
              myide:buildbcc(0)
           Endif
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=3 )  // Harbour-PellesC
              myide:BldPellc(0)
           Endif

           If ( myide:nCompxBase=2 .and. myide:nCompilerC=1 )  // xHarbour-MinGW
              myide:xBldMinGW(0)
           Endif
           If ( myide:nCompxBase=2 .and. myide:nCompilerC=2 )  // xHarbour-BCC
              myide:xbuildbcc(0)
           Endif
           If ( myide:nCompxBase=2 .and. myide:nCompilerC=3 )  // xHarbour-PellesC
              myide:xBldPellc(0)
           Endif

      Case nOpt = 2  // Make and Run
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=1 )  // Harbour-MinGW
              myide:BldMinGW(1)
           Endif
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=2 )  // Harbour-BCC
              myide:buildbcc(1)
           Endif
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=3 )  // Harbour-PellesC
              myide:BldPellc(1)
           Endif

           If ( myide:nCompxBase=2 .and. myide:nCompilerC=1 )  // xHarbour-MinGW
              myide:xBldMinGW(1)
           Endif
           If ( myide:nCompxBase=2 .and. myide:nCompilerC=2 )  // xHarbour-BCC
              myide:xbuildbcc(1)
           Endif
           If ( myide:nCompxBase=2 .and. myide:nCompilerC=3 )  // xHarbour-PellesC
              myide:xBldPellc(1)
           Endif

      Case nOpt = 3  // Only Run
           myide:runp()

      Case nOpt = 4  // Debug
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=1 )  // Harbour-MinGW
              myide:BldMinGW(2)
           Endif
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=2 )  // Harbour-BCC
              myide:buildbcc(2)
           Endif
           If ( myide:nCompxBase=1 .and. myide:nCompilerC=3 )  // Harbour-PellesC
              myide:BldPellc(2)
           Endif

           If ( myide:nCompxBase=2 .and. myide:nCompilerC=1 )  // xHarbour-MinGW
              myide:xBldMinGW(2)
           Endif
           If ( myide:nCompxBase=2 .and. myide:nCompilerC=2 )  // xHarbour-BCC
              myide:xbuildbcc(2)
           Endif
           If ( myide:nCompxBase=2 .and. myide:nCompilerC=3 )  // xHarbour-PellesC
              myide:xBldPellc(2)
           Endif

   Endcase
Return

*-------------------------
function printitem(carch)
*-------------------------
local oprint
IF !HB_IsString ( carch )
   Return nil
ENDIF
oprint:=tprint()
oprint:init()
oprint:selprinter(.T. , .T.  )  /// select,preview,land
if oprint:lprerror
   msgstop('Printing problem.')
   oprint:release()
   return nil
endif
oprint:begindoc()
oprint:setpreviewsize(1)  /// tama¤o del preview
oprint:beginpage()
oprint:setcpl(120)

contlin:=1
oprint:printdata(contlin,0, replicate('-',90))
wpage:=1
 for i:=1 to mlcount(carch)
    contlin++
    oprint:printdata(contlin,0,trim(MEMOLINE(CARCH,500,I) ) )
    IF contlin>60
       contlin++
       contlin++
       oprint:printdata(contlin,0,'Page... '+str(wpage,3) )
       contlin++
       oprint:printdata(contlin,0, replicate('-',90))
       oprint:endpage()
       oprint:beginpage()
       contlin:=1
       wpage++
    ENDIF
next i
 contlin++
contlin++
 oprint:printdata(contlin,0,'Page... '+str(wpage,3) )
contlin++
oprint:printdata(contlin,0, replicate('-',90))
contlin++
oprint:printdata(contlin,0,'End print ' )
oprint:endpage()
oprint:enddoc()
return nil

*-------------------------
METHOD about() CLASS THMI
*-------------------------
DEFINE WINDOW about_form obj about_form ;
   AT 0,0 ;
   WIDTH 450 ;
   HEIGHT 220 ;
   TITLE 'About ooHGIDE+ '  ;
   ICON 'Edit' ;
   MODAL NOSIZE NOSYSMENU ;
   backcolor myide:asystemcolor

   @ 1,1    FRAME FRAME1 WIDTH 437 HEIGHT 190

   @ 15,330 Image Myphoto PICTURE 'cvcbmp' width 97 height 69     // MigSoft

   @ 85,330 Image MYOOHG  PICTURE 'myoohg' WIDTH 97 HEIGHT 97     // MigSoft

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
   VALUE "(c) 2002-2011 ooHGIDE+ Home page" ;
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

   @ 160,150 button button_1 caption 'Ok' action {|| about_form:release } FLAT


END WINDOW
about_form:button_1:setfocus()
center window about_form
playhand()
activate window about_form
return


*-------------------------
METHOD dataman() CLASS THMI
*-------------------------
if .not. iswindowdefined(_dbu)
   databaseview1()
else
   msginfo('Data manager already running','Information')
endif
form_tree:maximize()
return
         

*-------------------------
METHOD SplashDelay() CLASS THMI
*-------------------------
local iTime
cursorwait()
iTime := Seconds()
Do While Seconds() - iTime < 1
EndDo
Form_Splash:release()
Form_tree:maximize()
cursorarrow()
Return

*-------------------------
METHOD preferences() CLASS THMI
*-------------------------
   load window form_prefer

   form_prefer                    := getformobject("form_prefer")

   form_prefer:backcolor          := myide:asystemcolor

   form_prefer:text_3:value       := myide:cProjFolder
   form_prefer:text_4:value       := myide:cOutFile

   form_prefer:text_12:value      := myide:cGuiHbMinGW
   form_prefer:text_9:value       := myide:cGuiHbBCC
   form_prefer:text_11:value      := myide:cGuiHbPelles

   form_prefer:text_16:value      := myide:cGuixHbMinGW
   form_prefer:text_17:value      := myide:cGuixHbBCC
   form_prefer:text_18:value      := myide:cGuixHbPelles

   form_prefer:text_8:value       := myide:cHbMinGWFolder
   form_prefer:text_2:value       := myide:cHbBCCFolder
   form_prefer:text_7:value       := myide:cHbPellFolder

   form_prefer:text_13:value      := myide:cxHbMinGWFolder
   form_prefer:text_14:value      := myide:cxHbBCCFolder
   form_prefer:text_15:value      := myide:cxHbPellFolder

   form_prefer:text_10:value      := myide:cMinGWFolder
   form_prefer:text_5:value       := myide:cBCCFolder
   form_prefer:text_6:value       := myide:cPellFolder

   form_prefer:radiogroup_1:value := myide:nCompxBase
   form_prefer:radiogroup_2:value := myide:nCompilerC

   form_prefer:text_1:value       := myide:cExteditor

   form_prefer:Radiogroup_3:value := myide:ltbuild
   form_prefer:text_lib:value     := myide:clib
   form_prefer:checkbox_105:value := iif(myide:lsnap=1,.T.,.F.)

   form_prefer:checkbox_105:backcolor := myide:asystemcolor
   form_prefer:button_101:backcolor   := myide:asystemcolor
   form_prefer:button_102:backcolor   := myide:asystemcolor

   ACTIVATE WINDOW form_prefer

return


*-------------------------
METHOD searchtext() CLASS THMI
*-------------------------
local cTextsearch,i,nItems,cInput,cOutput,cItem,j
cTextsearch:=inputbox('Text','Search text')
if len(cTextsearch)=0
   return nil
endif
cursorwait()
waitmess:hmi_label_101:value:='Searching....'
waitmess:show()
nItems:=Form_tree:Tree_1:ItemCount
cOutput:=''
For i:= 1  to nItems

    cItem:=Form_tree:Tree_1:Item (i)

    if myide:searchtypeadd(i)=='RC module' .and. cItem<>'RC module'
       if file(cItem+'.rc')
          cInput:=memoread(cItem+'.rc')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 cOutput += cItem+'  ==> RC module'+'  Line '+str(j,6)+CRLF
              endif
          next j
       endif
    else
    if myide:searchtypeadd(i)=='CH module' .and. cItem<>'CH module'
       if file(cItem+'.ch')
          cInput:=memoread(cItem+'.ch')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 cOutput += cItem+'  ==> CH module'+'  Line '+str(j,6)+CRLF
              endif
          next j
       endif
    else
    if (myide:searchtypeadd(i)=='Prg module') .and.( cItem<>'Prg module')
       if file(citem+'.prg')
          cInput:=memoread(cItem+'.prg')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 coutput += cItem+'  ==> Prg module '+'  Line '+str(j,6)+CRLF
              endif
          next j
       endif
    else
    if (myide:searchtypeadd(i)=='Form module') .and.( cItem<>'Form module')
       if file(citem+'.fmg')
          cInput:=memoread(cItem+'.fmg')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 coutput += cItem+'  ==> Form module'+'  Line '+str(j,6)+CRLF
              endif
          next j
       endif
    else
    if (myide:searchtypeadd(i)=='Rpt module') .and.( cItem<>'Rpt module')
       if file(citem+'.rpt')
          cInput:=memoread(cItem+'.rpt')
          for j:=1 to mlcount(cInput)
              if at(upper(ctextsearch),upper(trim(memoline(cInput,500,j))))>0
                 coutput += cItem+'  ==> Rpt module'+'  Line '+str(j,6)+CRLF
              endif
          next j
       endif
    endif
    endif
    endif
    endif
    endif
Next i
waitmess:hide()
cursorarrow()
if coutput==''
   msginfo('Text not found','Information')
else
   msginfo(coutput,cTextsearch+' Found in...')
endif
return

*-------------------------
METHOD okprefer() CLASS THMI
*-------------------------

   myide:cProjFolder     := pmgFolder                     // MigSoft
   myide:cOutFile        := form_prefer:text_4:value

   if len(trim(form_prefer:text_1:value))=0
      myide:cExteditor:=""
   else
      myide:cExteditor:=form_prefer:text_1:value
   endif

   myide:cGuiHbMinGW     := form_prefer:text_12:value
   myide:cGuiHbBCC       := form_prefer:text_9:value
   myide:cGuiHbPelles    := form_prefer:text_11:value
   myide:cGuixHbMinGW    := form_prefer:text_16:value
   myide:cGuixHbBCC      := form_prefer:text_17:value
   myide:cGuixHbPelles   := form_prefer:text_18:value

   myide:cHbMinGWFolder  := form_prefer:text_8:value
   myide:cHbBCCFolder    := form_prefer:text_2:value
   myide:cHbPellFolder   := form_prefer:text_7:value

   myide:cxHbMinGWFolder :=  form_prefer:text_13:value
   myide:cxHbBCCFolder   :=  form_prefer:text_14:value
   myide:cxHbPellFolder  :=  form_prefer:text_15:value

   myide:cMinGWFolder    := form_prefer:text_10:value
   myide:cBCCFolder      := form_prefer:text_5:value
   myide:cPellFolder     := form_prefer:text_6:value

   myide:nCompxBase      := form_prefer:radiogroup_1:value
   myide:nCompilerC      := form_prefer:radiogroup_2:value

   myide:ltbuild         := form_prefer:Radiogroup_3:value
   myide:lsnap           := iif(form_prefer:checkbox_105:value,1,0)
   myide:clib            := form_prefer:text_lib:value

   form_prefer:release()

   SetCurrentFolder(myide:cProjFolder)    // MigSoft

   BEGIN INI FILE 'hmi.INI'

         SET SECTION 'PROJECT'  ENTRY "PROJFOLDER"   TO myide:cProjFolder
         SET SECTION 'PROJECT'  ENTRY "OUTFILE"      TO myide:cOutFile

         SET SECTION "EDITOR"   ENTRY "EXTERNAL"     TO myide:cExteditor

         SET SECTION 'GUILIB'   ENTRY "GUIHBMINGW"   TO myide:cGuiHbMinGW
         SET SECTION 'GUILIB'   ENTRY "GUIHBBCC"     TO myide:cGuiHbBCC
         SET SECTION 'GUILIB'   ENTRY "GUIHBPELL"    TO myide:cGuiHBPelles
         SET SECTION 'GUILIB'   ENTRY "GUIXHBMINGW"  TO myide:cGuixHbMinGW
         SET SECTION 'GUILIB'   ENTRY "GUIXHBBCC"    TO myide:cGuixHbBCC
         SET SECTION 'GUILIB'   ENTRY "GUIXHBPELL"   TO myide:cGuixHBPelles

         SET SECTION 'HARBOUR'  ENTRY "HBMINGW"      TO myide:cHbMinGWFolder
         SET SECTION 'HARBOUR'  ENTRY "HBBCC"        TO myide:cHbBCCFolder
         SET SECTION 'HARBOUR'  ENTRY "HBPELLES"     TO myide:cHbPellFolder

         SET SECTION 'HARBOUR'  ENTRY "XHBMINGW"     TO myide:cxHbMinGWFolder
         SET SECTION 'HARBOUR'  ENTRY "XHBBCC"       TO myide:cxHbBCCFolder
         SET SECTION 'HARBOUR'  ENTRY "XHBPELLES"    TO myide:cxHbPellFolder

         SET SECTION 'COMPILER' ENTRY "MINGWFOLDER"  TO myide:cMinGWFolder
         SET SECTION 'COMPILER' ENTRY "BCCFOLDER"    TO myide:cBCCFolder
         SET SECTION 'COMPILER' ENTRY "PELLESFOLDER" TO myide:cPellFolder

         SET SECTION 'WHATCOMP' ENTRY "XBASECOMP"    TO myide:nCompxBase
         SET SECTION 'WHATCOMP' ENTRY "CCOMPILER"    TO myide:nCompilerC

         SET SECTION "SETTINGS" ENTRY "BUILD"        to myide:ltbuild
         SET SECTION "SETTINGS" ENTRY "LIB"          to myide:clib
         SET SECTION "SETTINGS" ENTRY "SNAP"         to myide:lsnap

   END INI

Return

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                     COMPILING WITH MINGW AND HARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

*-------------------------
METHOD BldMinGW(nOption) CLASS THMI
*-------------------------
local output,i,nitems,nPos,cprgname,cexe,cError
LOCAL aPrgFiles       := {}
LOCAL nPrgFiles   //////////////    := PrgFiles.List_1.ItemCount
LOCAL cMakeExe
LOCAL cParams
LOCAL cOut            := ''

LOCAL cProjFolder     := myide:cProjFolder+'\'
LOCAL cMinGWFolder    := myide:cMinGWFolder+'\'
LOCAL cMiniGuiFolder  := myide:cGUIHbMinGW+'\'
LOCAL cHarbourFolder  := myide:cHbMinGWFolder+'\'

LOCAL nFile
LOCAL lDebug := .F.

nItems:=Form_tree:Tree_1:ItemCount
*memowrit('error.lst'," ") ?
if len(alltrim(myide:cprojectname))=0
   msginfo('You must define a project name'+CRLF+'Build Premature end','Information')
   return
endif
cos=upper(gete('os'))
if len(cos)=0
   cos=gete('os_type')
endif
form_tree:button_9:enabled:=.F.
form_tree:button_10:enabled:=.F.
form_tree:button_11:enabled:=.F.
cursorwait()
do events
DO CASE
   CASE myide:ltbuild==2    // Owm Make MinGW
   //////////////////////////////////


  BEGIN SEQUENCE

   IF EMPTY(myide:cProjectname)     ////////    IF EMPTY(cProjName)
      MsgStop('You must save the project before building it.','ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cProjFolder) /////////////  .OR. EMPTY(PrgFiles.List_1.Item(1))
      MsgStop('You must open and save a project before building it.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cMinGWFolder)
      MsgStop('The BCC folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cMiniGuiFolder)
      MsgStop('The ooHG folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cHarbourFolder)
      MsgStop('The Harbour folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    SetCurrentFolder(cProjFolder)
    DELETE FILE(cProjFolder +  'End.Txt')
    waitmess:hmi_label_101:value:='Compiling....'
    waitmess:show()
    nPrgfiles:=0
    aArraux:={}
    For i:=nitems to 1  step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
             IF ascan(aArraux,upper(cItem+".PRG"))=0
                  AADD(aArraux, upper(ALLTRIM( cItem+'.prg' )))
                  nPrgfiles++
                endif
          endif
    NEXT i

    Aprgfiles:=aclone(aArraux)
    For i:=1 to Nprgfiles
        Aprgfiles[i]:=aArraux[Nprgfiles+1-i ]
    Next i

    DELETE FILE ( cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' ) +  'End.Txt' )

    CreateFolder(cProjFolder +  'OBJ')

    cOut += 'PATH = '+cMinGWFolder+'BIN;'+cMinGWFolder+'LIBEXEC\GCC\MINGW\3.4.5'+';'+ Left ( cProjFolder , Len(cProjFolder ) - 1 ) + CRLF
    cOut += 'MINGW = '+ Left ( cMinGWFolder , Len(cMinGWFolder ) - 1 )+CRLF
    cOut += 'HRB_DIR = '+ Left ( cHarbourFolder , Len(cHarbourFolder ) - 1 )+CRLF
    cOut += 'PROJECTFOLDER = '+ Left ( cProjFolder , Len(cProjFolder ) - 1 )+CRLF
    cOut += 'APP_NAME = ' + delext(myide:cprojectname) + '.exe' + CRLF
    cOut += 'INC_DIR = '+cMiniGUIFolder + If ( Right ( cMiniGUIFolder , 1 ) != '\' , '\' , '' ) + 'INCLUDE' + CRLF
    cOut += 'OBJ_DIR = '+cPROJFOLDER + If ( Right ( cPROJFOLDER , 1 ) != '\' , '\' , '' ) + 'OBJ'  + CRLF
    cOut += 'MINIGUI_INSTALL = ' + Left ( cMiniGUIFolder , Len(cMiniGUIFolder ) - 1 )+CRLF

    ///// cOut += 'CFLAGS =  -Wall -mwindows -mno-cygwin -O3' + CRLF
    cOut += 'CFLAGS = -Wall -mwindows -O3 -Wl,--allow-multiple-definition ' + CRLF
    cOut += CRLF

***** Resources make File .o

      cFilerc := Left ( aPrgFiles [1] , Len(aPrgFiles [1] ) - 4 )

      If File ( cPROJFOLDER + If ( Right ( cPROJFOLDER , 1 ) != '\' , '\' , '' ) +  cFilerc+'.rc' )  // Existe .RC
         DosComm1 := "/c copy /b "+cMiniGUIFolder+"\resources\oohg.rc+"+cFilerc+".rc+"+cMiniGUIFolder+"\resources\filler "+cMiniGUIFolder+"\resources\_temp.rc >NUL"
         EXECUTE FILE "CMD.EXE" PARAMETERS DosComm1 HIDE
      Else   // No existe .RC
         DosComm1 := "/c copy /b "+cMiniGUIFolder+"\resources\oohg.rc "+cMiniGUIFolder+"\resources\_temp.rc >NUL"
         EXECUTE FILE "CMD.EXE" PARAMETERS DosComm1 HIDE
      Endif

      DosComm2 := "/c "+cMinGWFolder+"BIN\windres -i "+cMiniGUIFolder+"\resources\_temp.rc -o "+cMiniGUIFolder+"\resources\_temp.o"
      EXECUTE FILE "CMD.EXE" PARAMETERS DosComm2 HIDE

*    cOut += 'SOURCE='+Left ( aPrgFiles [1] , Len(aPrgFiles [1] ) - 4 )+CRLF
    cOut += 'SOURCE='+delext(myide:cprojectname)+CRLF
    cOut += CRLF

    cfile1 := Left ( aPrgFiles [1] , Len(aPrgFiles [1] ) - 4 )
    cOut += 'all: '+cfile1+'.exe $(OBJ_DIR)/'+cfile1+'.o $(OBJ_DIR)/'+cfile1+'.c'

    For i := 2 To Len ( aPrgFiles)
        cfile := Left ( aPrgFiles [i] , Len(aPrgFiles [i] ) - 4 )
        cOut += ' $(OBJ_DIR)/'+cfile+'.o $(OBJ_DIR)/'+cfile+'.c'
    Next i

    If file(cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' )+cfile1+'.rc')
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    Else
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    Endif

    cOut += CRLF
    cOut += CRLF

    cOut += cfile1+'.exe  :'

    For i := 1 To Len ( aPrgFiles)
        cfile := Left ( aPrgFiles [i] , Len(aPrgFiles [i] ) - 4 )
        cOut += ' $(OBJ_DIR)/'+cfile+'.o '
    Next

    If file(cPROJFOLDER + If ( Right ( cPROJFOLDER , 1 ) != '\' , '\' , '' )+cfile1+'.rc')
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    else
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    Endif

    cOut += CRLF
    cOut += '	gcc -Wall -mno-cygwin -o$(SOURCE).exe '
    cOut += ' -mwindows '

    For i := 1 To Len ( aPrgFiles)
        cfile := Left ( aPRGFILES [i] , Len(aPRGFILES [i] ) - 4 )
        cOut += '$(OBJ_DIR)/'+cfile+'.o '
    Next

    If file(cPROJFOLDER + If ( Right ( cPROJFOLDER , 1 ) != '\' , '\' , '' )+cfile1+'.rc')
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    else
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    endif

    cOut += '-L$(MINGW)/lib -L$(HRB_DIR)/lib -L$(HRB_DIR)/lib/win/mingw -L$(MINIGUI_INSTALL)/lib -L$(MINIGUI_INSTALL)/lib/gcc -Wl,--start-group '  // MigSoft
    cOut += '-looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbpp -lhbrtl -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lhbodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32'
    cOut += ' -Wl,--end-group '

    cOut += CRLF
    cOut += CRLF

    For i := 1 To Len ( aPrgFiles)
        cfile := Left ( aPrgFiles [i] , Len(aPrgFiles [i] ) - 4 )
        cOut += '$(OBJ_DIR)/'+cfile+'.o    : $(OBJ_DIR)/'+cfile+'.c'+CRLF
        cOut += '	gcc $(CFLAGS)  -I$(INC_DIR) -I$(HRB_DIR)/include -I$(MINGW)/include -I$(MINGW)/LIB/GCC/MINGW32/3.4.5/include -c $(OBJ_DIR)/'+cfile+'.c -o $(OBJ_DIR)/'+cfile+'.o'+CRLF
    next

    cOut += CRLF

    For i := 1 To Len ( aPrgFiles)
        cfile := Left ( aPRGFILES [i] , Len(aPRGFILES [i] ) - 4 )
        cOut += '$(OBJ_DIR)/'+cfile+'.c   : $(PROJECTFOLDER)/'+cfile+'.prg'+CRLF
        cOut += '	$(HRB_DIR)/bin/harbour.exe $^ -n -w -I$(HRB_DIR)/include -I$(MINIGUI_INSTALL)/include -i$(INC_DIR) -I$(PROJECTFOLDER) -d__WINDOWS__ -o$@ $^'+CRLF
    next i

    cOut += CRLF

    if file(cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' )+cfile1+'.rc')
        cOut += '$(MINIGUI_INSTALL)/resources/_temp.o    : $(MINIGUI_INSTALL)/resources/_temp.rc'+CRLF
        cOut += '	windres -i $(MINIGUI_INSTALL)/resources/_temp.rc -o $(MINIGUI_INSTALL)/resources/_temp.o' +CRLF
    else
        cOut += '$(MINIGUI_INSTALL)/resources/oohg.o         : $(MINIGUI_INSTALL)/resources/oohg.rc'+CRLF
        cOut += '	windres -i $(MINIGUI_INSTALL)/resources/_temp.rc -o $(MINIGUI_INSTALL)/resources/_temp.o --include-dir $(MINIGUI_INSTALL)/resources ' +CRLF
    endif

    Memowrit ( cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' ) +  'Makefile.Gcc' , cOut )

    cMakeExe := cMinGWFolder+'BIN\mingw32-make.exe'
    cParams  := '-f  makefile.gcc 1>_temp.log 2>&1 3>&2'

    Memowrit ( cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' ) + '_Build.Bat' , 'REM @echo off' + CRLF +"REM SET PATH=;"+CRLF+ cMakeExe + ' ' + cParams +CRLF + 'Echo End > ' + cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' ) + 'End.Txt' + CRLF )

    lProcess := .Y.
    waitrun('_Build.bat', 0  )
    waitmess:hide()
     cError:=memoread('_temp.log')
     cError1:=memoread('_temp1.log')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError+cError1)    //// cvc
           /// myide:viewerrors(cError1)
            BREAK
         Else
            BorraTemp() // MigSoft
         endif
         if noption==0
            msginfo('Make Finished.','Information')
         endif
         if noption==1
            npos:=at(".",myide:cprojectname)
            cprgname:=substr(myide:cprojectname,1,npos-1)
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
         BorraObj()  // MigSoft
  END SEQUENCE


   CASE myide:ltbuild==1 // Compile.bat

      cursorwait()
      output=''
      For i:=1 to nitems  /////to 1 step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
                IF AT(upper(cItem+'.prg'),upper(output))=0
                   output += "# include  '"+citem+".prg'"+crlf+crlf
                endif
          endif
      next i
      output += CRLF+CRLF
      npos:=at(".",myide:cprojectname)
      cprgname:=substr(myide:cprojectname,1,npos-1)
      if memowrit(cprgname+'.prg',output)
         if .not. file('compile.bat') .and. ! IsFileInPath('compile.bat')
            msginfo('You must copy the compile.bat distributed with ooHG to the actual project directory, or put in current path','Information')
            cursorarrow()
            form_tree:button_9:enabled:=.T.
            form_tree:button_10:enabled:=.T.
            form_tree:button_11:enabled:=.T.
            return
         endif

         set printer to comp.bat
         set print on
         set console off
         ? "compile " + cprgname
         set console on
         set print off
         set printer to

         waitmess:hmi_label_101:value:='Compiling....'
         waitmess:show()
         if cos='WINDOWS_NT'
            waitrun("comp.bat",0)
         else
            EXECUTE FILE 'comp.bat'  WAIT
         endif
         waitmess:hide()
         cursorarrow()
         cError:=memoread('error.lst')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            return
         endif
         if noption=0
            msginfo('Project builded.','Information')
         endif
         if noption==1 .or. noption==2
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
      endif
ENDCASE
cursorarrow()
form_tree:button_9:enabled:=.T.
form_tree:button_10:enabled:=.T.
form_tree:button_11:enabled:=.T.
do events
Return

*-------------------------
METHOD runp() CLASS THMI
*-------------------------
form_tree:button_9:enabled:=.F.
form_tree:button_10:enabled:=.F.
form_tree:button_11:enabled:=.F.
npos:=at(".",myide:cprojectname)
cprgname:=substr(myide:cprojectname,1,npos-1)
cexe:=cprgname+'.exe'
if file(cexe)
   EXECUTE FILE cexe
else
   msgstop(cexe+' not found.','Information')
endif
form_tree:button_9:enabled:=.T.
form_tree:button_10:enabled:=.T.
form_tree:button_11:enabled:=.T.
return

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                   COMPILING WITH MINGW AND XHARBOUR                             // MigSoft
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

*-------------------------
METHOD xBldMinGW(nOption) CLASS THMI
*-------------------------
local output,i,nitems,nPos,cprgname,cexe,cError
LOCAL aPrgFiles       := {}
LOCAL nPrgFiles   //////////////    := PrgFiles.List_1.ItemCount
LOCAL cMakeExe
LOCAL cParams
LOCAL cOut            := ''

LOCAL cProjFolder     := myide:cProjFolder+'\'
LOCAL cMinGWFolder    := myide:cMinGWFolder+'\'
LOCAL cMiniGuiFolder  := myide:cGUIxHbMinGW+'\'
LOCAL cHarbourFolder  := myide:cxHbMinGWFolder+'\'

LOCAL nFile
LOCAL lDebug := .F.

nItems:=Form_tree:Tree_1:ItemCount
memowrit('error.lst'," ")
if len(alltrim(myide:cprojectname))=0
   msginfo('You must define a project name'+CRLF+'Build Premature end','Information')
   return
endif
cos=upper(gete('os'))
if len(cos)=0
   cos=gete('os_type')
endif
form_tree:button_9:enabled:=.F.
form_tree:button_10:enabled:=.F.
form_tree:button_11:enabled:=.F.
cursorwait()
do events
DO CASE
   CASE myide:ltbuild==2    // Owm Make MinGW
   //////////////////////////////////


  BEGIN SEQUENCE

   IF EMPTY(myide:cProjectname)     ////////    IF EMPTY(cProjName)
      MsgStop('You must save the project before building it.','ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cProjFolder) /////////////  .OR. EMPTY(PrgFiles.List_1.Item(1))
      MsgStop('You must open and save a project before building it.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cMinGWFolder)
      MsgStop('The BCC folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cMiniGuiFolder)
      MsgStop('The ooHG folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cHarbourFolder)
      MsgStop('The Harbour folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    SetCurrentFolder(cProjFolder)
    DELETE FILE(cProjFolder +  'End.Txt')
    waitmess:hmi_label_101:value:='Compiling....'
    waitmess:show()
    nPrgfiles:=0
    aArraux:={}
    For i:=nitems to 1  step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
             IF ascan(aArraux,upper(cItem+".PRG"))=0
                  AADD(aArraux, upper(ALLTRIM( cItem+'.prg' )))
                  nPrgfiles++
                endif
          endif
    NEXT i

    Aprgfiles:=aclone(aArraux)
    For i:=1 to Nprgfiles
        Aprgfiles[i]:=aArraux[Nprgfiles+1-i ]
    Next i

    DELETE FILE ( cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' ) +  'End.Txt' )

    CreateFolder(cProjFolder +  'OBJ')

    cOut += 'PATH = '+cMinGWFolder+'BIN;'+cMinGWFolder+'LIBEXEC\GCC\MINGW\3.4.5'+';'+ Left ( cProjFolder , Len(cProjFolder ) - 1 ) + CRLF
    cOut += 'MINGW = '+ Left ( cMinGWFolder , Len(cMinGWFolder ) - 1 )+CRLF
    cOut += 'HRB_DIR = '+ Left ( cHarbourFolder , Len(cHarbourFolder ) - 1 )+CRLF
    cOut += 'PROJECTFOLDER = '+ Left ( cProjFolder , Len(cProjFolder ) - 1 )+CRLF
    cOut += 'APP_NAME = ' + delext(myide:cprojectname) + '.exe' + CRLF
    cOut += 'INC_DIR = '+cMiniGUIFolder + If ( Right ( cMiniGUIFolder , 1 ) != '\' , '\' , '' ) + 'INCLUDE' + CRLF
    cOut += 'OBJ_DIR = '+cPROJFOLDER + If ( Right ( cPROJFOLDER , 1 ) != '\' , '\' , '' ) + 'OBJ'  + CRLF
    cOut += 'MINIGUI_INSTALL = ' + Left ( cMiniGUIFolder , Len(cMiniGUIFolder ) - 1 )+CRLF

    cOut += 'CFLAGS =  -Wall -mwindows -mno-cygwin -O3' + CRLF
    cOut += CRLF
    
***** Resources make File .o

      cFilerc := Left ( aPrgFiles [1] , Len(aPrgFiles [1] ) - 4 )

      If File ( cPROJFOLDER + If ( Right ( cPROJFOLDER , 1 ) != '\' , '\' , '' ) +  cFilerc+'.rc' )  // Existe .RC
         DosComm1 := "/c copy /b "+cMiniGUIFolder+"\resources\oohg.rc+"+cFilerc+".rc+"+cMiniGUIFolder+"\resources\filler _temp.rc >NUL"
         EXECUTE FILE "CMD.EXE" PARAMETERS DosComm1 HIDE
      Else   // No existe .RC
         DosComm1 := "/c copy /b "+cMiniGUIFolder+"\resources\oohg.rc _temp.rc >NUL"
         EXECUTE FILE "CMD.EXE" PARAMETERS DosComm1 HIDE
      Endif

      DosComm2 := "/c "+cMinGWFolder+"BIN\windres -i _temp.rc -o "+cMiniGUIFolder+"\resources\_temp.o"
      EXECUTE FILE "CMD.EXE" PARAMETERS DosComm2 HIDE

*****    cOut += 'SOURCE='+Left ( aPrgFiles [1] , Len(aPrgFiles [1] ) - 4 )+CRLF
    cOut += 'SOURCE='+delext(myide:cprojectname)+CRLF
    cOut += CRLF

    cfile1 := Left ( aPrgFiles [1] , Len(aPrgFiles [1] ) - 4 )
    cOut += 'all: '+cfile1+'.exe $(OBJ_DIR)/'+cfile1+'.o $(OBJ_DIR)/'+cfile1+'.c'

    For i := 2 To Len ( aPrgFiles)
        cfile := Left ( aPrgFiles [i] , Len(aPrgFiles [i] ) - 4 )
        cOut += ' $(OBJ_DIR)/'+cfile+'.o $(OBJ_DIR)/'+cfile+'.c'
    Next i

    If file(cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' )+cfile1+'.rc')
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    Else
       cOut += ' $(MINIGUI_INSTALL)/resources/oohg.o '
    Endif

    cOut += CRLF
    cOut += CRLF

    cOut += cfile1+'.exe  :'

    For i := 1 To Len ( aPrgFiles)
        cfile := Left ( aPrgFiles [i] , Len(aPrgFiles [i] ) - 4 )
        cOut += ' $(OBJ_DIR)/'+cfile+'.o '
    Next

    If file(cPROJFOLDER + If ( Right ( cPROJFOLDER , 1 ) != '\' , '\' , '' )+cfile1+'.rc')
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    else
       cOut += ' $(MINIGUI_INSTALL)/resources/oohg.o '
    Endif

    cOut += CRLF
    cOut += '	gcc -Wall -mno-cygwin -o$(SOURCE).exe '
    cOut += ' -mwindows '

    For i := 1 To Len ( aPrgFiles)
        cfile := Left ( aPRGFILES [i] , Len(aPRGFILES [i] ) - 4 )
        cOut += '$(OBJ_DIR)/'+cfile+'.o '
    Next

    If file(cPROJFOLDER + If ( Right ( cPROJFOLDER , 1 ) != '\' , '\' , '' )+cfile1+'.rc')
       cOut += ' $(MINIGUI_INSTALL)/resources/_temp.o '
    else
       cOut += ' $(MINIGUI_INSTALL)/resources/oohg.o '
    endif

    cOut += '-L$(MINGW)/lib -L$(HRB_DIR)/lib -L$(MINIGUI_INSTALL)/lib -Wl,--start-group '
    cOut += '-looHG -lhbprinter -lminiprint -lgtgui -lgtwin -lhbsix -lvm -lrdd -lmacro -lpp -lrtl -llang -lcommon -lnulsys -ldbfntx -ldbfcdx -ldbffpt -lct -llibmisc -lhbodbc -lodbc32 -luse_dll -lpcrepos -lcodepage -lzlib -ltip -lrdds -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32'
    cOut += ' -Wl,--end-group '

    cOut += CRLF
    cOut += CRLF

    For i := 1 To Len ( aPrgFiles)
        cfile := Left ( aPrgFiles [i] , Len(aPrgFiles [i] ) - 4 )
        cOut += '$(OBJ_DIR)/'+cfile+'.o    : $(OBJ_DIR)/'+cfile+'.c'+CRLF
        cOut += '	gcc $(CFLAGS)  -I$(INC_DIR) -I$(HRB_DIR)/include -I$(MINGW)/include -I$(MINGW)/LIB/GCC/MINGW32/3.4.5/include -c $(OBJ_DIR)/'+cfile+'.c -o $(OBJ_DIR)/'+cfile+'.o'+CRLF
    next

    cOut += CRLF

    For i := 1 To Len ( aPrgFiles)
        cfile := Left ( aPRGFILES [i] , Len(aPRGFILES [i] ) - 4 )
        cOut += '$(OBJ_DIR)/'+cfile+'.c   : $(PROJECTFOLDER)/'+cfile+'.prg'+CRLF
        cOut += '	$(HRB_DIR)/bin/harbour.exe $^ -n -w -I$(HRB_DIR)/include -I$(MINIGUI_INSTALL)/include -i$(INC_DIR) -I$(PROJECTFOLDER) -d__WINDOWS__ -o$@ $^'+CRLF
    next i

    cOut += CRLF

    if file(cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' )+cfile1+'.rc')
        cOut += '$(MINIGUI_INSTALL)/resources/_temp.o    : $(cProjectFolder)/'+CFILE1+'.rc'+CRLF
        cOut += '	windres -i $(cProjectFolder)/'+CFILE1+'.rc -o $(MINIGUI_INSTALL)/resources/_temp.o' +CRLF
    else
        cOut += '$(MINIGUI_INSTALL)/resources/oohg.o         : $(MINIGUI_INSTALL)/resources/oohg.rc'+CRLF
        cOut += '	windres -i $(MINIGUI_INSTALL)/resources/oohg.rc -o $(MINIGUI_INSTALL)/resources/oohg.o --include-dir $(MINIGUI_INSTALL)/resources ' +CRLF
    endif

    Memowrit ( cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' ) +  'Makefile.Gcc' , cOut )

    cMakeExe := cMinGWFolder+'BIN\mingw32-make.exe'
    cParams  := '-f  makefile.gcc 1>_temp.log 2>_temp1.log'

    Memowrit ( cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' ) + '_Build.Bat' , 'REM @echo off' + CRLF +"REM SET PATH=;"+CRLF+ cMakeExe + ' ' + cParams +CRLF + 'Echo End > ' + cProjFolder + If ( Right ( cProjFolder , 1 ) != '\' , '\' , '' ) + 'End.Txt'+CRLF)

    lProcess := .Y.
    waitrun('_Build.bat', 0  )
    waitmess:hide()
     cError:=memoread('_temp1.log')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            BREAK
         else
            BorraTemp() // MigSoft
         endif
         if noption==0
            msginfo('Make Finished.','Information')
         endif
         if noption==1
            npos:=at(".",myide:cprojectname)
            cprgname:=substr(myide:cprojectname,1,npos-1)
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
         BorraObj() //MigSoft
  END SEQUENCE


   CASE myide:ltbuild==1 // Compile.bat

      cursorwait()
      output=''
      For i:=1 to nitems  /////to 1 step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
                IF AT(upper(cItem+'.prg'),upper(output))=0
                   output += "# include  '"+citem+".prg'"+crlf+crlf
                endif
          endif
      next i
      output += CRLF+CRLF
      npos:=at(".",myide:cprojectname)
      cprgname:=substr(myide:cprojectname,1,npos-1)
      if memowrit(cprgname+'.prg',output)
         if .not. file('compile.bat') .and. ! IsFileInPath('compile.bat')
            msginfo('You must copy the compile.bat distributed with ooHG to the actual project directory, or put in current path','Information')
            cursorarrow()
            form_tree:button_9:enabled:=.T.
            form_tree:button_10:enabled:=.T.
            form_tree:button_11:enabled:=.T.
            return
         endif

         set printer to comp.bat
         set print on
         set console off
         ? "compile " + cprgname
         set console on
         set print off
         set printer to

         waitmess:hmi_label_101:value:='Compiling....'
         waitmess:show()
         if cos='WINDOWS_NT'
            waitrun("comp.bat",0)
         else
            EXECUTE FILE 'comp.bat'  WAIT
         endif
         waitmess:hide()
         cursorarrow()
         cError:=memoread('error.lst')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            return
         endif
         if noption=0
            msginfo('Project builded.','Information')
         endif
         if noption==1 .or. noption==2
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
      endif
ENDCASE
cursorarrow()
form_tree:button_9:enabled:=.T.
form_tree:button_10:enabled:=.T.
form_tree:button_11:enabled:=.T.
do events
Return

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                 COMPILING WITH BORLAND C AND HARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

*-------------------------
METHOD BuildBcc(nOption) CLASS THMI
*-------------------------
local output,i,nitems,nPos,cprgname,cexe,cError
LOCAL aPrgFiles       := {}
LOCAL nPrgFiles   //////////////    := PrgFiles.List_1.ItemCount
LOCAL cMakeExe
LOCAL cParams
LOCAL cOut            := ''

LOCAL cProjFolder     := myide:cProjFolder+'\'
LOCAL cBccFolder      := myide:cBCCFolder+'\'
LOCAL cMiniGuiFolder  := myide:cGuiHbBCC+'\'
LOCAL cHarbourFolder  := myide:cHbBCCFolder+'\'

LOCAL nFile
LOCAL lDebug := .F.

nItems:=Form_tree:Tree_1:ItemCount
memowrit('error.lst'," ")
if len(alltrim(myide:cprojectname))=0
   msginfo('You must define a project name'+CRLF+'Build Premature end','Information')
   return
endif
cos=upper(gete('os'))
if len(cos)=0
   cos=gete('os_type')
endif
form_tree:button_9:enabled:=.F.
form_tree:button_10:enabled:=.F.
form_tree:button_11:enabled:=.F.
cursorwait()
do events
DO CASE
   CASE myide:ltbuild==2 // Own Make BCC


  BEGIN SEQUENCE

   IF EMPTY(myide:cProjectname)     ////////    IF EMPTY(cProjName)
      MsgStop('You must save the project before building it.','ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cProjFolder) /////////////  .OR. EMPTY(PrgFiles.List_1.Item(1))
      MsgStop('You must open and save a project before building it.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cBccFolder)
      MsgStop('The BCC folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cMiniGuiFolder)
      MsgStop('The ooHG folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cHarbourFolder)
      MsgStop('The Harbour folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    SetCurrentFolder(cProjFolder)
    DELETE FILE(cProjFolder +  'End.Txt')
    waitmess:hmi_label_101:value:='Compiling....'
    waitmess:show()
    nPrgfiles:=0
    aArraux:={}
    For i:=nitems to 1  step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
             IF ascan(aArraux,upper(cItem+".PRG"))=0
                  AADD(aArraux, upper(ALLTRIM( cItem+'.prg' )))
                  nPrgfiles++
                endif
          endif
    NEXT i

    Aprgfiles:=aclone(aArraux)
    For i:=1 to Nprgfiles
        Aprgfiles[i]:=aArraux[Nprgfiles+1-i ]
    Next i

    CreateFolder(cProjFolder +  'OBJ')

    cOut += 'HARBOUR_EXE = ' + cHarbourFolder + 'BIN\HARBOUR.EXE'  + CRLF
    cOut += 'CC = ' + cBccFolder + 'BIN\BCC32.EXE'  + CRLF
    cOut += 'ILINK_EXE = ' + cBccFolder + 'BIN\ILINK32.EXE'  + CRLF
    cOut += 'BRC_EXE = ' + cBccFolder + 'BIN\BRC32.EXE'  + CRLF
    cOut += 'APP_NAME = ' + delext(myide:cprojectname) + '.exe' + CRLF
    cOut += 'RC_FILE = ' + cMiniGuiFolder + 'RESOURCES\oohg.RC' + CRLF
    cOut += 'INCLUDE_DIR = ' + cHarbourFolder + 'INCLUDE;' + ;
    cMiniGuiFolder + 'INCLUDE' + ';' + DelSlash(cProjFolder) + CRLF
    cOut += 'CC_LIB_DIR = ' + cBccFolder + 'LIB'  + CRLF
    cOut += 'HRB_LIB_DIR = ' + cHarbourFolder + 'LIB'  + CRLF
    cOut += 'OBJ_DIR = ' + cProjFolder + 'OBJ' + CRLF
    cOut += 'C_DIR = ' + cProjFolder + 'OBJ' + CRLF
    cOut += 'USER_FLAGS = ' + CRLF
    IF lDebug
      cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n /b $(USER_FLAGS)' + CRLF
    ELSE
      cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n $(USER_FLAGS)' + CRLF
    ENDIF
    cOut += 'COBJFLAGS =  -c -O2 -tW -M  -I' + ;
      cBccFolder + 'INCLUDE -I$(INCLUDE_DIR) -L' + cBccFolder + 'LIB' + CRLF
    cOut += CRLF
    if Nprgfiles>1
       cOut += '$(APP_NAME) : $(OBJ_DIR)\' + ;
       DelExt(aPrgFiles[1])  + '.obj \' + CRLF
       FOR nFile := 2 TO nPrgFiles
          IF nFile == nPrgFiles
             cOut += '    $(OBJ_DIR)\' + ;
             DelExt(aPrgFiles[nFile])  + '.obj' + CRLF
           ELSE
             cOut += '    $(OBJ_DIR)\' + ;
             DelExt(aPrgFiles[nFile])  + '.obj \' + CRLF
          ENDIF
       NEXT i
    else
    cOut += '$(APP_NAME) : $(OBJ_DIR)\' + ;
    DelExt(aPrgFiles[1])  + '.obj ' + CRLF
    endif

    cOut += CRLF
    IF FILE(delext(myide:cprojectname)  + '.rc')
       cOut += ' $(BRC_EXE) -d__BORLANDC__ -r -fo' +  ;
        delext(myide:cprojectname) + '.res ' + ;
        delext(myide:cprojectname) + '.rc ' + ;
        CRLF
    ENDIF

    FOR nFile := 1 To nPrgFiles
      cOut += '     echo $(OBJ_DIR)\' +  ;
        DelExt(aPrgFiles[nFile]) +  '.obj + >' + ;
        IF(nFile > 1, '>', '') +'b32.bc ' + CRLF
    NEXT i

    cOut += ' echo ' + cBccFolder + 'LIB\c0w32.obj, + >> b32.bc ' + CRLF
    cOut += ' echo $(APP_NAME),' + ;
      LEFT(aPrgFiles[1], LEN(aPrgFiles[1]) - 4) + '.map, + >> b32.bc' + CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\oohg.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dll.lib + >> b32.bc' + CRLF
    IF lDebug
      cOut += ' echo $(HRB_LIB_DIR)\gtwin.lib + >> b32.bc' + CRLF
    ENDIF
    cOut += ' echo $(HRB_LIB_DIR)\gtgui.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbcplr.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbrtl.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbvm.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hblang.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbcpage.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbmacro.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbrdd.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbhsx.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rddntx.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rddcdx.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rddfpt.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbwin.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbsix.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbcommon.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbdebug.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbct.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbtip.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbmisc.lib + >> b32.bc' + CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\hbprinter.lib + >> b32.bc' +CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\miniprint.lib + >> b32.bc' +CRLF
    cOut += ' echo $(HRB_LIB_DIR)\socket.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbodbc.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\odbc32.lib + >> b32.bc' + CRLF
    cOut += ' echo $(CC_LIB_DIR)\cw32.lib + >> b32.bc' + CRLF
    cOut += ' echo $(CC_LIB_DIR)\import32.lib, >> b32.bc' + CRLF

         IF FILE(delext(myide:cprojectname) + '.rc')
      cOut += '      echo ' + delext(myide:cprojectname) + '.res' + ;
        ' + >> b32.bc' + CRLF
    ENDIF

    cOut += '     echo ' + ;
    cMiniGuiFolder  + 'RESOURCES\oohg.res >> b32.bc' + CRLF

    IF lDebug
      cOut += ' $(ILINK_EXE)  -Gn -Tpe -ap -L'+ cBccFolder + 'LIB' + ' -L' + cHarbourFolder + 'LIB\win\bcc' + ; // MigSoft
              ' -L' + cHarbourFolder + 'LIB' + ' -L' + cMiniGuiFolder + 'LIB\bcc' + ' @b32.bc' + CRLF
    ELSE
      cOut += ' $(ILINK_EXE)  -Gn -Tpe -aa -L'+ cBccFolder + 'LIB' + ' -L'+ cHarbourFolder + 'LIB\win\bcc' +; // MigSoft
              ' -L' + cHarbourFolder + 'LIB' + ' -L' + cMiniGuiFolder + 'LIB\bcc' + ' @b32.bc' + CRLF
    ENDIF

    cOut += CRLF

    FOR nFile := 1 TO nPrgFiles
      cOut += CRLF
      cOut += '$(C_DIR)\' + DelExt(aPrgFiles[nFile]) + '.c : ' + ;
        cProjFolder + DelExt(aPrgFiles[nFile]) + '.prg' + ;
        CRLF
      cOut += '    $(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + CRLF
      cOut += CRLF
      cOut += '$(OBJ_DIR)\'  + ;
        DelExt(aPrgFiles[nFile]) + '.obj : $(C_DIR)\' + ;
        DelExt(aPrgFiles[nFile]) + '.c'  + CRLF
      cOut += '    $(CC) $(COBJFLAGS) -o$@ $**' + CRLF
    NEXT i

    MEMOWRIT(cProjFolder +  '_Temp.bc', cOut)

    cMakeExe := cBccFolder + 'BIN\MAKE.EXE'
    cParams  := '/f' + cProjFolder +  '_Temp.bc' + ;
      ' > ' + cProjFolder +  '_Temp.log'
    MEMOWRIT(cProjFolder + '_Build.bat', ;
      '@echo off' + CRLF + ;
      cMakeExe + ' ' + cParams + CRLF + ;
      'echo End > ' + cProjFolder + 'End.txt' + CRLF)

    lProcess            := .Y.
    waitrun('_Build.bat', 0  )
    waitmess:hide()
     cError:=memoread('_temp.log')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            BREAK
         else
            BorraTemp() // MigSoft
         endif
         if noption==0
            msginfo('Make Finished.','Information')
         endif
         if noption==1
            npos:=at(".",myide:cprojectname)
            cprgname:=substr(myide:cprojectname,1,npos-1)
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
         BorraObj()  // MigSoft
  END SEQUENCE

   CASE myide:ltbuild==1 // Compile.bat

      cursorwait()
      output=''
      For i:=1 to nitems  /////to 1 step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
                IF AT(upper(cItem+'.prg'),upper(output))=0
                   output += "# include  '"+citem+".prg'"+crlf+crlf
                endif
          endif
      next i
      output += CRLF+CRLF
      npos:=at(".",myide:cprojectname)
      cprgname:=substr(myide:cprojectname,1,npos-1)
      if memowrit(cprgname+'.prg',output)
         if .not. file('compile.bat') .and. ! IsFileInPath('compile.bat')
            msginfo('You must copy the compile.bat distributed with ooHGIDE+ sample to the actual project directory, or put in current path','Information')
            cursorarrow()
            form_tree:button_9:enabled:=.T.
            form_tree:button_10:enabled:=.T.
            form_tree:button_11:enabled:=.T.
            return
         endif

         set printer to comp.bat
         set print on
         set console off
         ? "compile " + cprgname
         set console on
         set print off
         set printer to

         waitmess:hmi_label_101:value:='Compiling....'
         waitmess:show()
         if cos='WINDOWS_NT'
            waitrun("comp.bat",0)
         else
            EXECUTE FILE 'comp.bat'  WAIT
         endif
         waitmess:hide()
         cursorarrow()
         cError:=memoread('error.lst')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            return
         endif
         if noption=0
            msginfo('Project builded.','Information')
         endif
         if noption==1 .or. noption==2
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
      endif
ENDCASE
cursorarrow()
form_tree:button_9:enabled:=.T.
form_tree:button_10:enabled:=.T.
form_tree:button_11:enabled:=.T.
do events
Return

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                  COMPILING CON BORLAND C Y XHARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

*-------------------------
METHOD xBuildBcc(nOption) CLASS THMI
*-------------------------
local output,i,nitems,nPos,cprgname,cexe,cError
LOCAL aPrgFiles       := {}
LOCAL nPrgFiles   //////////////    := PrgFiles.List_1.ItemCount
LOCAL cMakeExe
LOCAL cParams
LOCAL cOut            := ''

LOCAL cProjFolder     := myide:cProjFolder+'\'
LOCAL cBccFolder      := myide:cBCCFolder+'\'
LOCAL cMiniGuiFolder  := myide:cGuixHbBCC+'\'
LOCAL cHarbourFolder  := myide:cxHbBCCFolder+'\'

LOCAL nFile
LOCAL lDebug := .F.

nItems:=Form_tree:Tree_1:ItemCount
memowrit('error.lst'," ")
if len(alltrim(myide:cprojectname))=0
   msginfo('You must define a project name'+CRLF+'Build Premature end','Information')
   return
endif
cos=upper(gete('os'))
if len(cos)=0
   cos=gete('os_type')
endif
form_tree:button_9:enabled:=.F.
form_tree:button_10:enabled:=.F.
form_tree:button_11:enabled:=.F.
cursorwait()
do events
DO CASE
   CASE myide:ltbuild==2 // Own Make BCC


  BEGIN SEQUENCE

   IF EMPTY(myide:cProjectname)     ////////    IF EMPTY(cProjName)
      MsgStop('You must save the project before building it.','ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cProjFolder) /////////////  .OR. EMPTY(PrgFiles.List_1.Item(1))
      MsgStop('You must open and save a project before building it.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cBccFolder)
      MsgStop('The BCC folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cMiniGuiFolder)
      MsgStop('The ooHG folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cHarbourFolder)
      MsgStop('The Harbour folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    SetCurrentFolder(cProjFolder)
    DELETE FILE(cProjFolder +  'End.Txt')
    waitmess:hmi_label_101:value:='Compiling....'
    waitmess:show()
    nPrgfiles:=0
    aArraux:={}
    For i:=nitems to 1  step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
             IF ascan(aArraux,upper(cItem+".PRG"))=0
                  AADD(aArraux, upper(ALLTRIM( cItem+'.prg' )))
                  nPrgfiles++
                endif
          endif
    NEXT i

    Aprgfiles:=aclone(aArraux)
    For i:=1 to Nprgfiles
        Aprgfiles[i]:=aArraux[Nprgfiles+1-i ]
    Next i

    CreateFolder(cProjFolder +  'OBJ')

    cOut += 'HARBOUR_EXE = ' + cHarbourFolder + 'BIN\HARBOUR.EXE'  + CRLF
    cOut += 'CC = ' + cBccFolder + 'BIN\BCC32.EXE'  + CRLF
    cOut += 'ILINK_EXE = ' + cBccFolder + 'BIN\ILINK32.EXE'  + CRLF
    cOut += 'BRC_EXE = ' + cBccFolder + 'BIN\BRC32.EXE'  + CRLF
    cOut += 'APP_NAME = ' + delext(myide:cprojectname) + '.exe' + CRLF
    cOut += 'RC_FILE = ' + cMiniGuiFolder + 'RESOURCES\oohg.RC' + CRLF
    cOut += 'INCLUDE_DIR = ' + cHarbourFolder + 'INCLUDE;' + ;
    cMiniGuiFolder + 'INCLUDE' + ';' + DelSlash(cProjFolder) + CRLF
    cOut += 'CC_LIB_DIR = ' + cBccFolder + 'LIB'  + CRLF
    cOut += 'HRB_LIB_DIR = ' + cHarbourFolder + 'LIB'  + CRLF
    cOut += 'OBJ_DIR = ' + cProjFolder + 'OBJ' + CRLF
    cOut += 'C_DIR = ' + cProjFolder + 'OBJ' + CRLF
    cOut += 'USER_FLAGS = ' + CRLF
    IF lDebug
      cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n /b $(USER_FLAGS)' + CRLF
    ELSE
      cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n $(USER_FLAGS)' + CRLF
    ENDIF
    cOut += 'COBJFLAGS =  -c -O2 -tW -M  -I' + ;
      cBccFolder + 'INCLUDE -I$(INCLUDE_DIR) -L' + cBccFolder + 'LIB' + CRLF
    cOut += CRLF

    if Nprgfiles>1
       cOut += '$(APP_NAME) : $(OBJ_DIR)\' + ;
       DelExt(aPrgFiles[1])  + '.obj \' + CRLF
       FOR nFile := 2 TO nPrgFiles
          IF nFile == nPrgFiles
             cOut += '    $(OBJ_DIR)\' + ;
             DelExt(aPrgFiles[nFile])  + '.obj' + CRLF
           ELSE
             cOut += '    $(OBJ_DIR)\' + ;
             DelExt(aPrgFiles[nFile])  + '.obj \' + CRLF
          ENDIF
       NEXT i
    else
    cOut += '$(APP_NAME) : $(OBJ_DIR)\' + ;
    DelExt(aPrgFiles[1])  + '.obj ' + CRLF
    endif

    cOut += CRLF
    IF FILE(delext(myide:cprojectname)  + '.rc')
       cOut += ' $(BRC_EXE) -d__BORLANDC__ -r -fo' +  ;
        delext(myide:cprojectname) + '.res ' + ;
        delext(myide:cprojectname) + '.rc ' + ;
        CRLF
    ENDIF

    FOR nFile := 1 To nPrgFiles
      cOut += '     echo $(OBJ_DIR)\' +  ;
        DelExt(aPrgFiles[nFile]) +  '.obj + >' + ;
        IF(nFile > 1, '>', '') +'b32.bc ' + CRLF
    NEXT i

    cOut += ' echo ' + cBccFolder + 'LIB\c0w32.obj, + >> b32.bc ' + CRLF
    cOut += ' echo $(APP_NAME),' + ;
      LEFT(aPrgFiles[1], LEN(aPrgFiles[1]) - 4) + '.map, + >> b32.bc' + CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\oohg.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dll.lib + >> b32.bc' + CRLF
    IF lDebug
      cOut += ' echo $(HRB_LIB_DIR)\gtwin.lib + >> b32.bc' + CRLF
    ENDIF
    cOut += ' echo $(HRB_LIB_DIR)\gtgui.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rtl.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\vm.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\lang.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\codepage.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\macro.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rdd.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hsx.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\pcrepos.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rdd.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dbfcdx.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dbfntx.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dbffpt.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbsix.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\common.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\debug.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\ct.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\tip.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\libmisc.lib + >> b32.bc' + CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\hbprinter.lib + >> b32.bc' +CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\miniprint.lib + >> b32.bc' +CRLF
    cOut += ' echo $(HRB_LIB_DIR)\socket.lib + >> b32.bc' + CRLF

    cOut += ' echo $(HRB_LIB_DIR)\hbodbc.lib + >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\odbc32.lib + >> b32.bc' + CRLF

    cOut += ' echo $(CC_LIB_DIR)\cw32.lib + >> b32.bc' + CRLF
    cOut += ' echo $(CC_LIB_DIR)\import32.lib, >> b32.bc' + CRLF

         IF FILE(delext(myide:cprojectname) + '.rc')
      cOut += '      echo ' + delext(myide:cprojectname) + '.res' + ;
        ' + >> b32.bc' + CRLF
    ENDIF

    cOut += '     echo ' + ;
    cMiniGuiFolder  + 'RESOURCES\oohg.res >> b32.bc' + CRLF

    IF lDebug
      cOut += ' $(ILINK_EXE)  -Gn -Tpe -ap -L'+ cBccFolder + 'LIB' + ;
        ' @b32.bc' + CRLF
    ELSE
      cOut += ' $(ILINK_EXE)  -Gn -Tpe -aa -L'+ cBccFolder + 'LIB' + ;
        ' @b32.bc' + CRLF
    ENDIF

    cOut += CRLF

    FOR nFile := 1 TO nPrgFiles
      cOut += CRLF
      cOut += '$(C_DIR)\' + DelExt(aPrgFiles[nFile]) + '.c : ' + ;
        cProjFolder + DelExt(aPrgFiles[nFile]) + '.prg' + ;
        CRLF
      cOut += '    $(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + CRLF
      cOut += CRLF
      cOut += '$(OBJ_DIR)\'  + ;
        DelExt(aPrgFiles[nFile]) + '.obj : $(C_DIR)\' + ;
        DelExt(aPrgFiles[nFile]) + '.c'  + CRLF
      cOut += '    $(CC) $(COBJFLAGS) -o$@ $**' + CRLF
    NEXT i

    MEMOWRIT(cProjFolder +  '_Temp.bc', cOut)

    cMakeExe := cBccFolder + 'BIN\MAKE.EXE'
    cParams  := '/f' + cProjFolder +  '_Temp.bc' + ;
      ' > ' + cProjFolder +  '_Temp.log'
    MEMOWRIT(cProjFolder + '_Build.bat', ;
      '@echo off' + CRLF + ;
      cMakeExe + ' ' + cParams + CRLF + ;
      'echo End > ' + cProjFolder + 'End.txt' + CRLF)

    lProcess            := .Y.
    waitrun('_Build.bat', 0  )
    waitmess:hide()
     cError:=memoread('_temp.log')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            BREAK
         Else
            BorraTemp() // MigSoft
         endif
         if noption==0
            msginfo('Make Finished.','Information')
         endif
         if noption==1
            npos:=at(".",myide:cprojectname)
            cprgname:=substr(myide:cprojectname,1,npos-1)
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
         BorraObj()  // MigSoft
  END SEQUENCE

   CASE myide:ltbuild==1 // Compile.bat

      cursorwait()
      output=''
      For i:=1 to nitems  /////to 1 step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
                IF AT(upper(cItem+'.prg'),upper(output))=0
                   output += "# include  '"+citem+".prg'"+crlf+crlf
                endif
          endif
      next i
      output += CRLF+CRLF
      npos:=at(".",myide:cprojectname)
      cprgname:=substr(myide:cprojectname,1,npos-1)
      if memowrit(cprgname+'.prg',output)
         if .not. file('compile.bat') .and. ! IsFileInPath('compile.bat')
            msginfo('You must copy the compile.bat distributed with ooHGIDE+ sample to the actual project directory, or put in current path','Information')
            cursorarrow()
            form_tree:button_9:enabled:=.T.
            form_tree:button_10:enabled:=.T.
            form_tree:button_11:enabled:=.T.
            return
         endif

         set printer to comp.bat
         set print on
         set console off
         ? "compile " + cprgname
         set console on
         set print off
         set printer to

         waitmess:hmi_label_101:value:='Compiling....'
         waitmess:show()
         if cos='WINDOWS_NT'
            waitrun("comp.bat",0)
         else
            EXECUTE FILE 'comp.bat'  WAIT
         endif
         waitmess:hide()
         cursorarrow()
         cError:=memoread('error.lst')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            return
         endif
         if noption=0
            msginfo('Project builded.','Information')
         endif
         if noption==1 .or. noption==2
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
      endif
ENDCASE
cursorarrow()
form_tree:button_9:enabled:=.T.
form_tree:button_10:enabled:=.T.
form_tree:button_11:enabled:=.T.
do events
Return

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                 COMPILING WITH PELLES C AND XHARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

*-------------------------
METHOD XBldPellC(nOption) CLASS THMI
*-------------------------
local output,i,nitems,nPos,cprgname,cexe,cError
LOCAL aPrgFiles       := {}
LOCAL nPrgFiles   //////////////    := PrgFiles.List_1.ItemCount
LOCAL cMakeExe
LOCAL cParams
LOCAL cOut            := ''

LOCAL cProjFolder     := myide:cProjFolder+'\'
LOCAL cBccFolder      := myide:cPellFolder+'\'
LOCAL cMiniGuiFolder  := myide:cGuixHbPelles+'\'
LOCAL cHarbourFolder  := myide:cxHbPellFolder+'\'

LOCAL nFile
LOCAL lDebug := .F.

nItems:=Form_tree:Tree_1:ItemCount
memowrit('error.lst'," ")
if len(alltrim(myide:cprojectname))=0
   msginfo('You must define a project name'+CRLF+'Build Premature end','Information')
   return
endif
cos=upper(gete('os'))
if len(cos)=0
   cos=gete('os_type')
endif
form_tree:button_9:enabled:=.F.
form_tree:button_10:enabled:=.F.
form_tree:button_11:enabled:=.F.
cursorwait()
do events
DO CASE
   CASE myide:ltbuild==2 // Own Make BCC


  BEGIN SEQUENCE

   IF EMPTY(myide:cProjectname)     ////////    IF EMPTY(cProjName)
      MsgStop('You must save the project before building it.','ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cProjFolder) /////////////  .OR. EMPTY(PrgFiles.List_1.Item(1))
      MsgStop('You must open and save a project before building it.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cBccFolder)
      MsgStop('The BCC folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cMiniGuiFolder)
      MsgStop('The ooHG folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cHarbourFolder)
      MsgStop('The Harbour folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    SetCurrentFolder(cProjFolder)
    DELETE FILE(cProjFolder +  'End.Txt')
    waitmess:hmi_label_101:value:='Compiling....'
    waitmess:show()
    nPrgfiles:=0
    aArraux:={}
    For i:=nitems to 1  step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
             IF ascan(aArraux,upper(cItem+".PRG"))=0
                  AADD(aArraux, upper(ALLTRIM( cItem+'.prg' )))
                  nPrgfiles++
                endif
          endif
    NEXT i

    Aprgfiles:=aclone(aArraux)
    For i:=1 to Nprgfiles
        Aprgfiles[i]:=aArraux[Nprgfiles+1-i ]
    Next i

    CreateFolder(cProjFolder +  'OBJ')

    cOut += 'HARBOUR_EXE = ' + cHarbourFolder + 'BIN\HARBOUR.EXE'  + CRLF
    cOut += 'CC = ' + cBccFolder + 'BIN\POCC.EXE'  + CRLF
    cOut += 'ILINK_EXE = ' + cBccFolder + 'BIN\POLINK.EXE'  + CRLF
    cOut += 'BRC_EXE = ' + cBccFolder + 'BIN\PORC.EXE'  + CRLF
    cOut += 'APP_NAME = ' + delext(myide:cprojectname) + '.exe' + CRLF
    cOut += 'RC_FILE = ' + cMiniGuiFolder + 'RESOURCES\oohg.RC' + CRLF
    cOut += 'INCLUDE_DIR = ' + cHarbourFolder + 'INCLUDE;' + cMiniGuiFolder+'INCLUDE;'+DelSlash(cProjFolder) + CRLF
    cOut += 'INCLUDE_C_DIR = ' + cHarbourFolder+'INCLUDE -I'+cMiniGuiFolder+'INCLUDE -I'+DelSlash(cProjFolder)+;
             ' -I'+cBccFolder+'INCLUDE -I'+cBccFolder+'INCLUDE\WIN'+CRLF
    cOut += 'CC_LIB_DIR = ' + cBccFolder + 'LIB'  + CRLF
    cOut += 'HRB_LIB_DIR = ' + cHarbourFolder + 'LIB'  + CRLF
    cOut += 'OBJ_DIR = ' + cProjFolder + 'OBJ' + CRLF
    cOut += 'C_DIR = ' + cProjFolder + 'OBJ' + CRLF
    cOut += 'USER_FLAGS = ' + CRLF
    IF lDebug
      cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n /b $(USER_FLAGS)' + CRLF
    ELSE
      cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n $(USER_FLAGS)' + CRLF
    ENDIF
    cOut += 'COBJFLAGS =  /Ze /Zx /Go /Tx86-coff /D__WIN32__ ' + '-I$(INCLUDE_C_DIR)' + CRLF
    cOut += CRLF
    if Nprgfiles>1
       cOut += '$(APP_NAME) : $(OBJ_DIR)\' + ;
       DelExt(aPrgFiles[1])  + '.obj \' + CRLF
       FOR nFile := 2 TO nPrgFiles
          IF nFile == nPrgFiles
             cOut += '    $(OBJ_DIR)\' + ;
             DelExt(aPrgFiles[nFile])  + '.obj' + CRLF
           ELSE
             cOut += '    $(OBJ_DIR)\' + ;
             DelExt(aPrgFiles[nFile])  + '.obj \' + CRLF
          ENDIF
       NEXT i
    else
       cOut += '$(APP_NAME) : $(OBJ_DIR)\' + ;
       DelExt(aPrgFiles[1])  + '.obj ' + CRLF
    endif

    IF FILE(delext(myide:cprojectname)  + '.rc')
       cOut += ' $(BRC_EXE) /fo' +  ;
        delext(myide:cprojectname) + '.res ' + ;
        delext(myide:cprojectname) + '.rc ' + ;
        CRLF
    ENDIF

    FOR nFile := 1 To nPrgFiles
      cOut += ' echo $(OBJ_DIR)\' +  ;
        DelExt(aPrgFiles[nFile]) +  '.obj  >' + ;
        IF(nFile > 1, '>', '') +'b32.bc ' + CRLF
    NEXT i

    cOut += ' echo /OUT:$(APP_NAME) >> b32.bc '+ CRLF
    cOut += ' echo /FORCE:MULTIPLE >> b32.bc '+ CRLF
    cOut += ' echo /LIBPATH:$(CC_LIB_DIR) >> b32.bc '+ CRLF
    cOut += ' echo /LIBPATH:$(CC_LIB_DIR)\WIN >> b32.bc '+ CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\oohg.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dll.lib  >> b32.bc' + CRLF
    IF lDebug
      cOut += ' echo $(HRB_LIB_DIR)\gtwin.lib  >> b32.bc' + CRLF
    ENDIF
    cOut += ' echo $(HRB_LIB_DIR)\gtgui.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rtl.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\vm.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\lang.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\codepage.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\macro.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rdd.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hsx.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\pcrepos.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rdd.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dbfcdx.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dbfntx.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dbffpt.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbsix.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\common.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\debug.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\ct.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\tip.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\libmisc.lib  >> b32.bc' + CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\hbprinter.lib  >> b32.bc' +CRLF
    cOut += ' echo ' + cMiniGuiFolder  + 'LIB\miniprint.lib  >> b32.bc' +CRLF
    cOut += ' echo $(HRB_LIB_DIR)\socket.lib  >> b32.bc' + CRLF

    cOut += ' echo $(HRB_LIB_DIR)\hbodbc.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\odbc32.lib  >> b32.bc' + CRLF

    cOut += ' echo $(CC_LIB_DIR)\crt.lib  >> b32.bc' + CRLF
    cOut += ' echo kernel32.lib >> b32.bc' + CRLF
    cOut += ' echo winspool.lib >> b32.bc' + CRLF
    cOut += ' echo user32.lib >> b32.bc' + CRLF
    cOut += ' echo advapi32.lib >> b32.bc' + CRLF
    cOut += ' echo ole32.lib >> b32.bc' + CRLF
    cOut += ' echo uuid.lib >> b32.bc' + CRLF
    cOut += ' echo oleaut32.lib >> b32.bc' + CRLF
    cOut += ' echo mpr.lib >> b32.bc' + CRLF
    cOut += ' echo comdlg32.lib >> b32.bc' + CRLF
    cOut += ' echo comctl32.lib >> b32.bc' + CRLF
    cOut += ' echo gdi32.lib >> b32.bc' + CRLF
    cOut += ' echo olepro32.lib >> b32.bc' + CRLF
    cOut += ' echo shell32.lib >> b32.bc' + CRLF
    cOut += ' echo winmm.lib >> b32.bc' + CRLF
    cOut += ' echo vfw32.lib >> b32.bc' + CRLF
    cOut += ' echo wsock32.lib >> b32.bc' + CRLF

    IF FILE(delext(myide:cprojectname) + '.rc')
       cOut += '      echo ' + delext(myide:cprojectname) + '.res' + ;
        ' >> b32.bc' + CRLF                                               // MigSoft
    ENDIF

    cOut += '     echo ' + ;
    cMiniGuiFolder  + 'RESOURCES\oohg.res >> b32.bc' + CRLF

    IF lDebug
      cOut += ' $(ILINK_EXE)  /SUBSYSTEM:CONSOLE @b32.bc' + CRLF
    ELSE
      cOut += ' $(ILINK_EXE)  /SUBSYSTEM:WINDOWS @b32.bc' + CRLF
    ENDIF

    cOut += CRLF

    FOR nFile := 1 TO nPrgFiles
      cOut += CRLF
      cOut += '$(C_DIR)\' + DelExt(aPrgFiles[nFile]) + '.c : ' + ;
        cProjFolder + DelExt(aPrgFiles[nFile]) + '.prg' + ;
        CRLF
      cOut += '    $(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + CRLF
      cOut += CRLF
      cOut += '$(OBJ_DIR)\'  + ;
        DelExt(aPrgFiles[nFile]) + '.obj : $(C_DIR)\' + ;
        DelExt(aPrgFiles[nFile]) + '.c'  + CRLF
      cOut += '    $(CC) $(COBJFLAGS) -Fo$@ $**' + CRLF
    NEXT i

    HB_MEMOWRIT(cProjFolder +  '_Temp.bc', cOut)

    cMakeExe := cBccFolder + 'BIN\POMAKE.EXE'
    cParams  := '/F ' + cProjFolder +  '_Temp.bc' + ;
      ' > ' + cProjFolder +  '_Temp.log'
    HB_MEMOWRIT(cProjFolder + '_Build.bat', ;
      '@echo off' + CRLF + ;
      cMakeExe + ' ' + cParams + CRLF + ;
      'echo End > ' + cProjFolder + 'End.txt' + CRLF)

    lProcess            := .Y.
    waitrun('_Build.bat', 0  )
    waitmess:hide()
     cError:=memoread('_temp.log')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            BREAK
         Else
            BorraTemp() // MigSoft
         endif
         if noption==0
            msginfo('Make Finished.','Information')
         endif
         if noption==1
            npos:=at(".",myide:cprojectname)
            cprgname:=substr(myide:cprojectname,1,npos-1)
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
         BorraObj()  // MigSoft
  END SEQUENCE

   CASE myide:ltbuild==1 // Compile.bat

      cursorwait()
      output=''
      For i:=1 to nitems  /////to 1 step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
                IF AT(upper(cItem+'.prg'),upper(output))=0
                   output += "# include  '"+citem+".prg'"+crlf+crlf
                endif
          endif
      next i
      output += CRLF+CRLF
      npos:=at(".",myide:cprojectname)
      cprgname:=substr(myide:cprojectname,1,npos-1)
      if memowrit(cprgname+'.prg',output)
         if .not. file('compile.bat') .and. ! IsFileInPath('compile.bat')
            msginfo('You must copy the compile.bat distributed with ooHGIDE+ sample to the actual project directory, or put in current path','Information')
            cursorarrow()
            form_tree:button_9:enabled:=.T.
            form_tree:button_10:enabled:=.T.
            form_tree:button_11:enabled:=.T.
            return
         endif

         set printer to comp.bat
         set print on
         set console off
         ? "compile " + cprgname
         set console on
         set print off
         set printer to

         waitmess:hmi_label_101:value:='Compiling....'
         waitmess:show()
         if cos='WINDOWS_NT'
            waitrun("comp.bat",0)
         else
            EXECUTE FILE 'comp.bat'  WAIT
         endif
         waitmess:hide()
         cursorarrow()
         cError:=memoread('error.lst')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            return
         endif
         if noption=0
            msginfo('Project builded.','Information')
         endif
         if noption==1 .or. noption==2
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
      endif
ENDCASE
cursorarrow()
form_tree:button_9:enabled:=.T.
form_tree:button_10:enabled:=.T.
form_tree:button_11:enabled:=.T.
do events
Return

*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._
*                 COMPILING WITH PELLES C AND HARBOUR
*-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._.-._-._.-._.-._.-._.-._.-._.-._

*-------------------------
METHOD BldPellC(nOption) CLASS THMI
*-------------------------
local output,i,nitems,nPos,cprgname,cexe,cError
LOCAL aPrgFiles       := {}
LOCAL nPrgFiles   //////////////    := PrgFiles.List_1.ItemCount
LOCAL cMakeExe
LOCAL cParams
LOCAL cOut            := ''

LOCAL cProjFolder     := myide:cProjFolder+'\'
LOCAL cBccFolder      := myide:cPellFolder+'\'
LOCAL cMiniGuiFolder  := myide:cGuiHbPelles+'\'
LOCAL cHarbourFolder  := myide:cHbPellFolder+'\'

LOCAL nFile
LOCAL lDebug := .F.

nItems:=Form_tree:Tree_1:ItemCount
*memowrit('error.lst'," ")
if len(alltrim(myide:cprojectname))=0
   msginfo('You must define a project name'+CRLF+'Build Premature end','Information')
   return
endif
cos=upper(gete('os'))
if len(cos)=0
   cos=gete('os_type')
endif
form_tree:button_9:enabled:=.F.
form_tree:button_10:enabled:=.F.
form_tree:button_11:enabled:=.F.
cursorwait()
do events
DO CASE
   CASE myide:ltbuild==2 // Own Make BCC


  BEGIN SEQUENCE

   IF EMPTY(myide:cProjectname)     ////////    IF EMPTY(cProjName)
      MsgStop('You must save the project before building it.','ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cProjFolder) /////////////  .OR. EMPTY(PrgFiles.List_1.Item(1))
      MsgStop('You must open and save a project before building it.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cBccFolder)
      MsgStop('The BCC folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cMiniGuiFolder)
      MsgStop('The ooHG folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    IF EMPTY(cHarbourFolder)
      MsgStop('The Harbour folder must be specified to build a project.', 'ooHGIDE+')
      BREAK
    ENDIF

    SetCurrentFolder(cProjFolder)
    DELETE FILE(cProjFolder +  'End.Txt')
    waitmess:hmi_label_101:value:='Compiling....'
    waitmess:show()
    nPrgfiles:=0
    aArraux:={}
    For i:=nitems to 1  step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
             IF ascan(aArraux,upper(cItem+".PRG"))=0
                  AADD(aArraux, upper(ALLTRIM( cItem+'.prg' )))
                  nPrgfiles++
                endif
          endif
    NEXT i

    Aprgfiles:=aclone(aArraux)
    For i:=1 to Nprgfiles
        Aprgfiles[i]:=aArraux[Nprgfiles+1-i ]
    Next i

    CreateFolder(cProjFolder +  'OBJ')

    cOut += 'HARBOUR_EXE = ' + cHarbourFolder + 'BIN\HARBOUR.EXE'  + CRLF
    cOut += 'CC = ' + cBccFolder + 'BIN\POCC.EXE'  + CRLF
    cOut += 'ILINK_EXE = ' + cBccFolder + 'BIN\POLINK.EXE'  + CRLF
    cOut += 'BRC_EXE = ' + cBccFolder + 'BIN\PORC.EXE'  + CRLF
    cOut += 'APP_NAME = ' + delext(myide:cprojectname) + '.exe' + CRLF
    cOut += 'RC_FILE = ' + cMiniGuiFolder + 'RESOURCES\oohg.RC' + CRLF
    cOut += 'INCLUDE_DIR = ' + cHarbourFolder + 'INCLUDE;' + cMiniGuiFolder+'INCLUDE;'+DelSlash(cProjFolder) + CRLF
    cOut += 'INCLUDE_C_DIR = ' + cHarbourFolder+'INCLUDE -I'+cMiniGuiFolder+'INCLUDE -I'+DelSlash(cProjFolder)+;
             ' -I'+cBccFolder+'INCLUDE -I'+cBccFolder+'INCLUDE\WIN'+CRLF
    cOut += 'CC_LIB_DIR = ' + cBccFolder + 'LIB' + CRLF

    If file(cHarbourFolder + 'LIB\hbwin.lib')
       cOut += 'HRB_LIB_DIR = ' + cHarbourFolder + 'LIB'  + CRLF
    Else
       cOut += 'HRB_LIB_DIR = ' + cHarbourFolder + 'LIB\WIN\POCC' + CRLF
    Endif

    cOut += 'OBJ_DIR = ' + cProjFolder + 'OBJ' + CRLF
    cOut += 'C_DIR = ' + cProjFolder + 'OBJ' + CRLF
    cOut += 'USER_FLAGS = ' + CRLF
    IF lDebug
      cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n /b $(USER_FLAGS)' + CRLF
    ELSE
      cOut += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n $(USER_FLAGS)' + CRLF
    ENDIF
    cOut += 'COBJFLAGS =  /Ze /Zx /Go /Tx86-coff /D__WIN32__ ' + '/I$(INCLUDE_C_DIR)' + CRLF
    cOut += CRLF
    if Nprgfiles>1
       cOut += '$(APP_NAME) : $(OBJ_DIR)\' + ;
       DelExt(aPrgFiles[1])  + '.obj \' + CRLF
       FOR nFile := 2 TO nPrgFiles
          IF nFile == nPrgFiles
             cOut += '    $(OBJ_DIR)\' + ;
             DelExt(aPrgFiles[nFile])  + '.obj' + CRLF
           ELSE
             cOut += '    $(OBJ_DIR)\' + ;
             DelExt(aPrgFiles[nFile])  + '.obj \' + CRLF
          ENDIF
       NEXT i
    else
       cOut += '$(APP_NAME) : $(OBJ_DIR)\' + ;
       DelExt(aPrgFiles[1])  + '.obj ' + CRLF
    endif

    IF FILE(delext(myide:cprojectname)  + '.rc')
       cOut += ' $(BRC_EXE) /fo' +  ;
        delext(myide:cprojectname) + '.res ' + ;
        delext(myide:cprojectname) + '.rc ' + ;
        CRLF
    ENDIF

    FOR nFile := 1 To nPrgFiles
      cOut += ' echo $(OBJ_DIR)\' +  ;
        DelExt(aPrgFiles[nFile]) +  '.obj  >' + ;
        IF(nFile > 1, '>', '') +'b32.bc ' + CRLF
    NEXT i

    If File(cMiniGuiFolder+'LIB\oohg.lib')            // MigSoft
       cLib_ooHG      :='LIB\oohg.lib'
       cLib_Hbprinter :='LIB\hbprinter.lib'
       cLib_Miniprint :='LIB\miniprint.lib'
    Else
       cLib_ooHG      :='LIB\pocc\oohg.lib'
       cLib_Hbprinter :='LIB\pocc\hbprinter.lib'
       cLib_Miniprint :='LIB\pocc\miniprint.lib'
    Endif

    cOut += ' echo /OUT:$(APP_NAME) >> b32.bc '+ CRLF
    cOut += ' echo /FORCE:MULTIPLE >> b32.bc '+ CRLF
    cOut += ' echo /LIBPATH:$(CC_LIB_DIR) >> b32.bc '+ CRLF
    cOut += ' echo /LIBPATH:$(CC_LIB_DIR)\WIN >> b32.bc '+ CRLF
    cOut += ' echo ' + cMiniGuiFolder  + cLib_ooHG + ' >> b32.bc ' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\dll.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\gtwin.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\gtgui.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbrtl.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbvm.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hblang.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbcpage.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbmacro.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbrdd.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbhsx.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbpcre.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbrdd.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rddcdx.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rddntx.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\rddfpt.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbsix.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbcommon.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbdebug.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbct.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbtip.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbmisc.lib  >> b32.bc' + CRLF
    cOut += ' echo ' + cMiniGuiFolder  + cLib_Hbprinter + '  >> b32.bc' +CRLF
    cOut += ' echo ' + cMiniGuiFolder  + cLib_Miniprint + ' >> b32.bc' +CRLF
    cOut += ' echo $(HRB_LIB_DIR)\socket.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbwin.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbmzip.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\minizip.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbzlib.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\hbodbc.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\odbc32.lib  >> b32.bc' + CRLF
    cOut += ' echo $(HRB_LIB_DIR)\xhb.lib  >> b32.bc' + CRLF
    cOut += ' echo $(CC_LIB_DIR)\crt.lib  >> b32.bc' + CRLF
    cOut += ' echo kernel32.lib >> b32.bc' + CRLF
    cOut += ' echo winspool.lib >> b32.bc' + CRLF
    cOut += ' echo user32.lib >> b32.bc' + CRLF
    cOut += ' echo advapi32.lib >> b32.bc' + CRLF
    cOut += ' echo ole32.lib >> b32.bc' + CRLF
    cOut += ' echo uuid.lib >> b32.bc' + CRLF
    cOut += ' echo oleaut32.lib >> b32.bc' + CRLF
    cOut += ' echo mpr.lib >> b32.bc' + CRLF
    cOut += ' echo comdlg32.lib >> b32.bc' + CRLF
    cOut += ' echo comctl32.lib >> b32.bc' + CRLF
    cOut += ' echo gdi32.lib >> b32.bc' + CRLF
    cOut += ' echo olepro32.lib >> b32.bc' + CRLF
    cOut += ' echo shell32.lib >> b32.bc' + CRLF
    cOut += ' echo winmm.lib >> b32.bc' + CRLF
    cOut += ' echo vfw32.lib >> b32.bc' + CRLF
    cOut += ' echo wsock32.lib >> b32.bc' + CRLF

    IF FILE(delext(myide:cprojectname) + '.rc')
       cOut += '      echo ' + delext(myide:cprojectname) + '.res' + ;
        ' >> b32.bc' + CRLF                                               // MigSoft
    ENDIF

    cOut += '     echo ' + ;
    cMiniGuiFolder  + 'RESOURCES\oohg.res >> b32.bc' + CRLF

    IF lDebug
      cOut += ' $(ILINK_EXE)  /SUBSYSTEM:CONSOLE @b32.bc' + CRLF
    ELSE
      cOut += ' $(ILINK_EXE)  /SUBSYSTEM:WINDOWS @b32.bc' + CRLF
    ENDIF

    cOut += CRLF

    FOR nFile := 1 TO nPrgFiles
      cOut += CRLF
      cOut += '$(C_DIR)\' + DelExt(aPrgFiles[nFile]) + '.c : ' + ;
      cProjFolder + DelExt(aPrgFiles[nFile]) + '.prg' + CRLF
      cOut += '    $(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + CRLF
      cOut += CRLF
      cOut += '$(OBJ_DIR)\'  + ;
      DelExt(aPrgFiles[nFile]) + '.obj : $(C_DIR)\' + ;
      DelExt(aPrgFiles[nFile]) + '.c'  + CRLF
      cOut += '    $(CC) $(COBJFLAGS) -Fo$@ $**' + CRLF
      cOut += ''
    NEXT i

#ifndef __XHARBOUR__
  hb_MemoWrit(cProjFolder +  '_Temp.bc', cOut)
#else
  MemoWrit(cProjFolder +  '_Temp.bc', cOut, .N.)
#endif

    cMakeExe := cBccFolder + 'BIN\POMAKE.EXE'
    cParams  := '/F ' + cProjFolder +  '_Temp.bc' + ;
      ' > ' + cProjFolder +  '_Temp.log'
    HB_MEMOWRIT(cProjFolder + '_Build.bat', ;
      '@echo off' + CRLF + ;
      cMakeExe + ' ' + cParams + CRLF + ;
      'echo End > ' + cProjFolder + 'End.txt' + CRLF)

    lProcess            := .Y.
    waitrun('_Build.bat', 0  )
    waitmess:hide()
     cError:=memoread('_temp.log')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            BREAK
         Else
            BorraTemp() // MigSoft
         endif
         if noption==0
            msginfo('Make Finished.','Information')
         endif
         if noption==1
            npos:=at(".",myide:cprojectname)
            cprgname:=substr(myide:cprojectname,1,npos-1)
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
         BorraObj()  // MigSoft
  END SEQUENCE

   CASE myide:ltbuild==1 // Compile.bat

      cursorwait()
      output=''
      For i:=1 to nitems  /////to 1 step -1
          cItem:= Form_tree:Tree_1:Item ( i )
          if (myide:searchtypeadd(myide:searchitem(cItem,"Prg module"))=='Prg module') .and.( cItem<>'Prg module')
                IF AT(upper(cItem+'.prg'),upper(output))=0
                   output += "# include  '"+citem+".prg'"+crlf+crlf
                endif
          endif
      next i
      output += CRLF+CRLF
      npos:=at(".",myide:cprojectname)
      cprgname:=substr(myide:cprojectname,1,npos-1)
      if memowrit(cprgname+'.prg',output)
         if .not. file('compile.bat') .and. ! IsFileInPath('compile.bat')
            msginfo('You must copy the compile.bat distributed with ooHGIDE+ sample to the actual project directory, or put in current path','Information')
            cursorarrow()
            form_tree:button_9:enabled:=.T.
            form_tree:button_10:enabled:=.T.
            form_tree:button_11:enabled:=.T.
            return
         endif

         set printer to comp.bat
         set print on
         set console off
         ? "compile " + cprgname
         set console on
         set print off
         set printer to

         waitmess:hmi_label_101:value:='Compiling....'
         waitmess:show()
         if cos='WINDOWS_NT'
            waitrun("comp.bat",0)
         else
            EXECUTE FILE 'comp.bat'  WAIT
         endif
         waitmess:hide()
         cursorarrow()
         cError:=memoread('error.lst')
         if (at(upper('error'),upper(cError))>0).or.(at(upper('fatal'),upper(cError))>0)
            myide:viewerrors(cError)
            return
         endif
         if noption=0
            msginfo('Project builded.','Information')
         endif
         if noption==1 .or. noption==2
            cexe:=cprgname+'.exe'
            cursorwait()
            EXECUTE FILE cexe
            cursorarrow()
         endif
      endif
ENDCASE
cursorarrow()
form_tree:button_9:enabled:=.T.
form_tree:button_10:enabled:=.T.
form_tree:button_11:enabled:=.T.
do events

Return

*-------------------------
METHOD viewerrors(wr) CLASS THMI
*-------------------------
if !HB_IsString( wr )
   return nil
ENdif
DEFINE WINDOW c_errors obj c_errors  ;
   AT 10,10 ;
   WIDTH 650 HEIGHT 480 ;
   TITLE 'Error Report' ;
   ICON 'Edit' ;
   MODAL ;
   FONT "Times new Roman" ;
   SIZE 10 ;
   backcolor  myide:asystemcolor

   @ 0,0 EDITBOX EDIT_1 ;
   WIDTH 593 ;
   HEIGHT 445 ;
   VALUE WR ;
   READONLY ;
   FONT 'FixedSys' ;
   SIZE 10 ;
   backcolor {255,255,235}



   @ 10,595 Button _exiterr ;
   caption 'Exit' ;
   action {|| c_errors:release() } ;
   width 35 FLAT

END WINDOW
CENTER WINDOW c_errors
ACTIVATE WINDOW c_errors
form_tree:button_9:enabled:=.T.
form_tree:button_10:enabled:=.T.
form_tree:button_11:enabled:=.T.
return

*-------------------------
METHOD viewsource(wr) CLASS THMI
*-------------------------
if !HB_IsString( wr )
   return nil
ENdif
DEFINE WINDOW c_source obj c_source  ;
   AT 10,10 ;
   WIDTH 625 HEIGHT 460 ;
   TITLE 'Source code' ;
   ICON 'Edit' ;
   MODAL ;
   FONT "Times new Roman" ;
   SIZE 10 ;
   backcolor  myide:asystemcolor

   @ 0,0 EDITBOX EDIT_1 ;
   WIDTH 573 ;
   HEIGHT 425 ;
   VALUE WR ;
   READONLY ;
   FONT 'FixedSys' ;
   SIZE 10 ;
   backcolor {255,255,235}

   @ 10,575 Button _exiterr ;
   caption 'Exit' ;
   action {|| c_source:release() } ;
   width 35 FLAT

   @ 50,575 Button _prints ;
   caption 'Print' ;
   action {|| printitem(wr) } ;
   width 35 FLAT

END WINDOW
CENTER WINDOW c_source
ACTIVATE WINDOW c_source
return

*-------------------------
METHOD Newproject() CLASS THMI
*-------------------------
if .not. myide:lPsave
   if msgyesno('Actual Project not saved (save ?)','Question')
      myide:saveproject()
   endif
endif

form_tree:Tree_1:deleteAllitems()
Form_tree:Tree_1:AddItem( 'Project'   , 0 )
Form_tree:Tree_1:AddItem( 'Form module' , 1 )
Form_tree:Tree_1:AddItem( 'Prg module' , 1 )
Form_tree:Tree_1:AddItem( 'CH module' , 1 )
Form_tree:Tree_1:AddItem( 'Rpt module' , 1 )
Form_tree:Tree_1:AddItem( 'RC module' , 1 )
Form_tree:Tree_1:value := 1
Form_tree:title := cNameApp
myide:lPsave:=.F.
myide:cprojectname:=''
   Desactiva(0)           // MigSoft
return


*-------------------------
METHOD Openproject() CLASS THMI
*-------------------------
cos=upper(gete('os'))
if len(cos)=0
   cos=gete('os_type')
endif
******
if file(exedir)
   cvccvar:=alltrim(memoread(exedir))
   dirchange(cvccvar)
endif
*****
   myide:cFile := GetFile ( { {'ooHGIde+ project files *.pmg','*.pmg'} }  , 'Open Project',cvccvar,.F.,.F. )

If len(myide:cFile)=0
   return
Else                                          // MigSoft
   pmgFolder := OnlyFolder( myide:cFile )     // MigSoft
   Desactiva(1)                               // MigSoft
endif
openauxi()
return Nil

************
*-------------------------------------------
function openauxi(cvar)
*-------------------------------------------
local Aline [0]
local nContlin,nPosilin,nFinform,nValue
local cproject, chmi
nContlin:=0
nPosilin:=1
if cvar#NIL
   myide:cfile:=cvar+".pmg"
   pmgFolder := OnlyFolder( myide:cFile )     // MigSoft
   dirchange(pmgFolder)
   rtl:=NIL
endif
chmi := "hmi.INI"
IF .not. file(chmi)
   a:=memowrit(chmi,'[PROJECT]')
else

ENDIF
BEGIN INI FILE (chmi)

   GET myide:cProjFolder     SECTION 'PROJECT'  ENTRY "PROJFOLDER"    default ''   // MigSoft
   GET myide:cOutFile        SECTION 'PROJECT'  ENTRY "OUTFILE"       default ''

   GET myide:cExteditor      SECTION "EDITOR"   ENTRY "external"      default ''

   GET myide:cGuiHbMinGW     SECTION 'GUILIB'   ENTRY "GUIHBMINGW"    default 'c:\oohg'
   GET myide:cGuiHbBCC       SECTION 'GUILIB'   ENTRY "GUIHBBCC"      default 'c:\oohg'
   GET myide:cGuiHbPelles    SECTION 'GUILIB'   ENTRY "GUIHBPELL"     default 'c:\oohg'
   GET myide:cGuixHbMinGW    SECTION 'GUILIB'   ENTRY "GUIXHBMINGW"   default 'c:\oohg'
   GET myide:cGuixHbBCC      SECTION 'GUILIB'   ENTRY "GUIXHBBCC"     default 'c:\oohg'
   GET myide:cGuixHbPelles   SECTION 'GUILIB'   ENTRY "GUIXHBPELL"    default 'c:\oohg'

   GET myide:cHbMinGWFolder  SECTION 'HARBOUR'  ENTRY "HBMINGW"       default 'c:\oohg\harbour'
   GET myide:cHbBCCFolder    SECTION 'HARBOUR'  ENTRY "HBBCC"         default 'c:\harbourb'
   GET myide:cHbPellFolder   SECTION 'HARBOUR'  ENTRY "HBPELLES"      default 'c:\harbourp'

   GET myide:cxHbMinGWFolder SECTION 'HARBOUR'  ENTRY "XHBMINGW"      default 'c:\xharbourm'
   GET myide:cxHbBCCFolder   SECTION 'HARBOUR'  ENTRY "XHBBCC"        default 'c:\xharbourb'
   GET myide:cxHbPellFolder  SECTION 'HARBOUR'  ENTRY "XHBPELLES"     default 'c:\xharbourp'

   GET myide:cMinGWFolder    SECTION 'COMPILER' ENTRY "MINGWFOLDER"   default 'c:\oohg\MinGW'
   GET myide:cBCCFolder      SECTION 'COMPILER' ENTRY "BCCFOLDER"     default 'c:\oohg\BCC55'
   GET myide:cPellFolder     SECTION 'COMPILER' ENTRY "PELLESFOLDER"  default 'c:\oohg\PellesC'

   GET myide:nCompxBase      SECTION 'WHATCOMP' ENTRY "XBASECOMP"     default 1
   GET myide:nCompilerC      SECTION 'WHATCOMP' ENTRY "CCOMPILER"     default 1

   GET myide:ltbuild         SECTION 'SETTINGS' ENTRY "BUILD"         default 2
   GET myide:lsnap           SECTION 'SETTINGS' ENTRY "SNAP"          default 0
   GET myide:clib            SECTION 'SETTINGS' ENTRY "LIB"           default ''

END INI

************
myide:cprojectname:=myide:cFile
cproject:=memoread(myide:cFile)
form_tree:title := cNameApp+' ('+myide:cfile+')'
Form_tree:Tree_1:deleteAllitems()
ncontlin:=mlcount(cproject)
Form_tree:Tree_1:AddItem( 'Project'   , 0 )
Form_tree:Tree_1:AddItem( 'Form module' , 1 )
Form_tree:Tree_1:AddItem( 'Prg module' , 1 )
Form_tree:Tree_1:AddItem( 'CH module' , 1 )
Form_tree:Tree_1:AddItem( 'Rpt module' , 1 )
Form_tree:Tree_1:AddItem( 'RC module' , 1 )
sw:=0
For i:=1 to ncontlin
    aAdd(Aline,trim(memoline(cproject,,i)))
    aline[i]:=strtran(aline[i],chr(10),"")
    aline[i]:=strtran(aline[i],chr(13),"")
    aline[i]:=trim(aline[i])
    do case
       case Aline[i] =='Project'
       case Aline[i]=='Form module'
          sw:=1
       case  Aline[i]=='Prg module'
          sw:=2
       case Aline[i]=='CH module'
          sw:=3
       case Aline[i]=='Rpt module'
          sw:=4
       case Aline[i]=='RC module'
          sw:=5
       otherwise
          if sw==1
             myide:newformfromar(Aline[i])
          endif
          if sw==2
             myide:newprgfromar(Aline[i])
          endif
          if sw==3
             myide:newchfromar(Aline[i])
          endif
          if sw==4
             myide:newrptfromar(Aline[i])
          endif
          if sw==5
             myide:newrcfromar(Aline[i])
          endif
    endcase
Next i
Form_tree:Tree_1:value := 1
form_tree:tree_1:Expand ( 1 )
return


*-------------------------
METHOD Saveproject() CLASS THMI
*-------------------------
local Output,nIitems,i
Output := ''
nItems:=Form_tree:Tree_1:ItemCount
for i:=1 to nItems
    cItem:= Form_tree:Tree_1:Item ( i )
    Output += cItem +  CRLF
next i
Output += ''
**********
if len(trim(myide:cprojectname))=0
   myide:cprojectname:=PutFile ( { {'ooHGIDE+ project files *.pmg','*.pmg'} }  , 'Save Project' )
   if Upper ( Right (myide:cprojectname , 4 ) ) != '.PMG'
      myide:cprojectname:= myide:cprojectname + '.pmg'
      if upper(myide:cprojectname)=upper('.pmg')
         myide:cprojectname:=''
      endif
   endif
endif
memowrit (myide:cprojectname,output)
pmgFolder := OnlyFolder( myide:cprojectname )              // MigSoft
form_tree:title:=cNameApp+' ('+myide:cProjectname+')'
myide:lPsave:=.T.
   If Len(myide:cprojectname) > 0
      Desactiva(1)  // MigSoft
   Endif
return


*-------------------------
METHOD newform() CLASS THMI
*-------------------------
local cPform
cPform:=inputbox('Form module','Add Form module')
if val(cPform)>0
   msgstop('The name must begin with a letter.','Information')
   return
endif
if at('.',cPform)#0
   msgstop('The name must not have (.)','Information')
   return
endif

if len(cPform)>0
   if myide:searchitem(cPform,'Form module')>0 .and. myide:searchtypeadd(myide:searchitem(cPform,'Form module'))=='Form module'
      msgstop('This name is not permited.','Information')
      return
   endif
   Form_tree:Tree_1:AddItem( cPform , 2 )
   myide:lPsave:=.F.
endif
Return


*-------------------------
METHOD newformfromar(cPform) CLASS THMI
*-------------------------
if len(cPform)>0
   if myide:searchitem(cPform,'Form module')>0 .and. myide:searchtypeadd(myide:searchitem(cPform,'Form module'))=='Form module'
      msgstop('This name is not permited.','Information')
      return
   endif
   Form_tree:Tree_1:AddItem( cPform , 2 )
endif
Return


*-------------------------
METHOD Newprgfromar(cPprg) CLASS THMI
*-------------------------
local nValue
if len(cPprg)>0
   if myide:searchitem(cPprg,"Prg module")>0 .and. myide:searchtypeadd(myide:searchitem(cPprg,"Prg module"))=='Prg module'
      msgstop('This name is not permited.','Information')
      return
   endif
   nValue:=myide:searchitem('Prg module',"Prg module")
   Form_tree:Tree_1:AddItem( cPprg , nValue)
endif
Return


*-------------------------
METHOD Newchfromar(cPch) CLASS THMI
*-------------------------
local nValue
if len(cPch)>0
   if myide:searchitem(cPch,"CH module")>0 .and. myide:searchtypeadd(myide:searchitem(Cpch,"CH module"))=='CH module'
      msgstop('This name is not permited.','Information')
      return
   endif
   nValue:=myide:searchitem('CH module',"CH module")
   Form_tree:Tree_1:AddItem( cPch , nValue)
endif
Return


*-------------------------
METHOD Newrcfromar(cPrc) CLASS THMI
*-------------------------
local nValue
if len(cPrc)>0
   if myide:searchitem(cPrc,"RC module")>0 .and. myide:searchtypeadd(myide:searchitem(Cprc,"RC module"))=='RC module'
      msgstop('This name is not permited.','Information')
      return
   endif
   nValue:=myide:searchitem('RC module',"RC module")
   Form_tree:Tree_1:AddItem( cPrc , nValue)
endif
Return


*-------------------------
METHOD Newrptfromar(cPrpt) CLASS THMI
*-------------------------
local nValue
if len(cPrpt)>0
   if myide:searchitem(cPrpt,"Rpt module")>0 .and. myide:searchtypeadd(myide:searchitem(Cprpt,"Rpt module"))=='Rpt module'
      msgstop('This name is not permited.','Information')
      return
   endif
   nValue:=myide:searchitem('Rpt module',"Rpt module")
   Form_tree:Tree_1:AddItem( cPrpt , nValue)
endif
Return



*-------------------------
METHOD Newprg() CLASS THMI
*-------------------------
local cPprg,nValue
nvalue:=0
cPprg:=inputbox('Prg Module','Add Prg Module')
if val(cPprg)>0
   msgstop('The name must begin with a letter.','Information')
   return
endif
if at('.',cPprg)#0
   msgstop('The name must not have (.)','Information')
   return
endif
if len(cPprg)>0
   if myide:searchitem(cPprg,'Prg module')>0 .and. myide:searchtypeadd(myide:searchitem(cPprg,'Prg module'))=='Prg module'
      msgstop('This name is not permited.','Information')
      return
   endif
   nValue:=myide:searchitem('Prg module','Prg module')
   Form_tree:Tree_1:AddItem( cPprg , nValue)
   myide:lPsave:=.F.
endif
Return


*-------------------------
METHOD Newch() CLASS THMI
*-------------------------
local cPch,nValue
cPch:=inputbox('CH Module','Add CH Module')
if val(cPch)>0
   msgstop('The name must begin with a letter.','Information')
   return
endif
if at('.',cPch)#0
   msgstop('The name must not have (.)','Information')
   return
endif
if len(cPch)>0
   if myide:searchitem(cPch,'CH module')>0 .and. myide:searchtypeadd(myide:searchitem(Cpch,'CH module'))=='CH module'
      msgstop('This name is not permited.','Information')
      return
   endif
   nValue:=myide:searchitem('CH module','CH module')
   Form_tree:Tree_1:AddItem( cPch , nValue)
   myide:lPsave:=.F.
endif
Return


*-------------------------
METHOD Newrc() CLASS THMI
*-------------------------
local cPrc,nValue
cPrc:=inputbox('RC Module','Add RC Module')
if val(cPrc)>0
   msgstop('The name must begin with a letter.','Information')
   return
endif
if at('.',cPrc)#0
   msgstop('The name must not have (.)','Information')
   return
endif
if len(cPrc)>0
   if myide:searchitem(cPrc,'RC module')>0 .and. myide:searchtypeadd(myide:searchitem(Cprc,'RC module'))=='RC module'
      msgstop('This name is not permited.','Information')
      return
   endif
   nValue:=myide:searchitem('RC module','RC module')
   Form_tree:Tree_1:AddItem( cPrc , nValue)
   myide:lPsave:=.F.
endif
Return


*-------------------------
METHOD Newrpt() CLASS THMI
*-------------------------
local cPrpt,nValue
cPrpt:=inputbox('Rpt Module','Add Rpt Module')
if val(cPrpt)>0
   msgstop('The name must begin with a letter.','Information')
   return
endif
if at('.',cPrpt)#0
   msgstop('The name must not have (.)','Information')
   return
endif
if len(cPrpt)>0
   if myide:searchitem(cPrpt,'Rpt module')>0 .and. myide:searchtypeadd(myide:searchitem(Cprpt,'Rpt module'))=='Rpt module'
      msgstop('This name is not permited.','Information')
      return
   endif
   nValue:=myide:searchitem('Rpt module','Rpt module')
   Form_tree:Tree_1:AddItem( cPrpt , nValue)
   myide:lPsave:=.F.
endif
Return


*-------------------------
METHOD deleteitemp() CLASS THMI
*-------------------------
local cItem,cparent
cItem:=form_tree:Tree_1:item(form_tree:Tree_1:Value)
if cItem == 'Form module' .or. cItem=='Prg module' .or. cItem == 'Project' .or. cItem=='CH module' .or. cItem=='Rpt module' .or. cItem=='RC module'
   msgstop('This Item can not be deleted.','Information')
   return
endif

if msgyesno("Are you sure?","Confirm remove item "+cItem)
   Form_tree:Tree_1:DeleteItem( form_tree:Tree_1:Value )
   myide:lPsave:=.F.
endif
return

*-------------------------
METHOD searchitem(cnameitem,cparent) CLASS THMI
*-------------------------
local nitems,i,cItem,sw
sw:=0
nItems:=Form_tree:Tree_1:ItemCount
for i:=1 to nItems
    cItem:=Form_tree:Tree_1:Item ( i )
    if cItem==cparent
       sw:=1
    endif
    if sw=1
       if upper(cItem) == upper(cnameitem)
          return i
       endif
    endif
next i
return 0


*-------------------------
METHOD searchtypeadd(nvalue) CLASS THMI
*-------------------------
local l
IF !HB_IsNumeric( nvalue)
   Return NIL
ENDIF
For l:= nValue to 1 step -1
    if form_tree:Tree_1:item(l) == 'Form module'
       return ('Form module')
    endif
    if form_tree:Tree_1:item(l) == 'Prg module'
       return ('Prg module')
    endif
    if form_tree:Tree_1:item(l) == 'CH module'
       return ('CH module')
    endif
    if form_tree:Tree_1:item(l) == 'Rpt module'
       return ('Rpt module')
    endif
    if form_tree:Tree_1:item(l) == 'RC module'
       return ('RC module')
    endif
Next l
return nil


*-------------------------
METHOD searchtype() CLASS THMI
*-------------------------
local i
nValue:= form_tree:Tree_1:Value
For i:= nValue to 1 step -1
    if form_tree:Tree_1:item(i) == 'Form module'
       return ('Form module')
    endif
    if form_tree:Tree_1:item(i) == 'Prg module'
       return ('Prg module')
    endif
    if form_tree:Tree_1:item(i) == 'CH module'
       return ('CH module')
    endif
    if form_tree:Tree_1:item(i) == 'Rpt module'
       return ('Rpt module')
    endif
    if form_tree:Tree_1:item(i) == 'RC module'
       return ('RC module')
    endif
Next i
return nil


*-------------------------
METHOD modifyitem(cItem,cparent) CLASS THMI
*-------------------------
if citem=NIL
   cItem:=form_tree:Tree_1:item(form_tree:Tree_1:Value)
   cParent= myide:searchtype(myide:searchitem(cItem,'Form module'))
endif

if cParent == 'Prg module'                                    // MigSoft
   if file(citem+'.prg')
      myide:Openfile(cItem+'.prg')
      myide:alinet:={}
   else
      output:='/*        IDE: ooHGIDE+'+CRLF
      output+=' *     Project: '+myide:cprojectname+CRLF
      output+=' *        Item: '+cItem+'.prg'+CRLF
      output+=' * Description: '+CRLF
      output+=' *      Author: '+CRLF
      output+=' *        Date: '+dtoc(date())+CRLF
      output+=' */'+CRLF+CRLF

      output+="#include 'oohg.ch'"+CRLF                           // MigSoft
      output+=+CRLF
      output+="*------------------------------------------------------*"+CRLF
      if myide:searchitem(cItem,cParent)= (myide:searchitem(cParent,cParent)+1)
         output += 'Function Main()'+CRLF
      else
         output += 'Function '+cItem+'()'+CRLF                    // MigSoft
      endif
      output+="*------------------------------------------------------*"+CRLF+CRLF
      output += 'Return Nil'+CRLF+CRLF
      memowrit(cItem+'.prg',output)
      myide:Openfile(cItem+'.prg')
      myide:alinet:={}
   endif
endif
if cParent == 'CH module'
   if file(citem+'.ch')
      myide:Openfile(cItem+'.ch')
      myide:alinet:={}
   else
      output:='/*        IDE: ooHGIDE+'+CRLF
      output+=' *     Project: '+myide:cprojectname+CRLF
      output+=' *        Item: '+cItem+'.ch'+CRLF
      output+=' * Description:'+CRLF
      output+=' *      Author:'+CRLF
      output+=' *        Date: '+dtoc(date())+CRLF
      output+=' */'+CRLF+CRLF
      output += '#'+CRLF
      memowrit(cItem+'.ch',output)
      myide:Openfile(cItem+'.ch')
      myide:alinet:={}
   endif
endif
if cParent == 'RC module'
   if file(citem+'.rc')
      myide:Openfile(cItem+'.rc')
      myide:alinet:={}
   else
      output:='//         IDE: ooHGIDE+'+CRLF
      output+='//     Project: '+myide:cprojectname+CRLF
      output+='//        Item: '+cItem+'.rc'+CRLF
      output+='// Description:'+CRLF
      output+='//      Author:'+CRLF
      output+='//        Date: '+dtoc(date())+CRLF
      output+='// Name    Format   Filename'+CRLF
      output+='// MYBMP   BITMAP   res\Next.bmp'+CRLF

      wauxi:=memoread('auxi.rc')
/////////////// ojo
      output+= wauxi
      memowrit(cItem+'.rc',output)
      myide:Openfile(cItem+'.rc')
      myide:alinet:={}
   endif
endif
return nil


*-------------------------
METHOD modifyRpt(cItem,cparent) CLASS THMI
*-------------------------
if citem=NIL
   cItem:=form_tree:Tree_1:item(form_tree:Tree_1:Value)
   cParent= myide:searchtype(myide:searchitem(cItem,'Rpt module'))
endif

if cParent == 'Rpt module'
   repo_edit(cItem+'.rpt')
endif
return nil


*-------------------------
METHOD modifyform(citem,cparent) CLASS THMI
*-------------------------
local npos
if citem=NIL
   cItem:=form_tree:Tree_1:item(form_tree:Tree_1:Value)
   cParent= myide:searchtype(myide:searchitem(cItem,'Form module'))
endif
citem:=lower(citem)
do while (npos:=at(".",cItem))>0
   cItem:=substr(cItem,1,npos-1)
enddo
if cParent == 'Form module'
   myform:=tform1()
   myform:vd(cItem+'.fmg')
   close data
endif
return  nil

*-------------------------
METHOD savefile(cdfile) CLASS THMI
*-------------------------
if alltrim(editbcvc:edit_1:value)==''
   if file(Cdfile)
      delete file &cdfile
   endif
   myide:lsave:=.T.
   return  nil
endif
if memoWrit (cdfile,rtrim(editbcvc:edit_1:value))
   myide:lsave:=.T.
else
   msginfo('Error writing '+cdfile)
endif
return  nil


*-------------------------
METHOD Openfile(cdfile) CLASS THMI
*-------------------------
local nContlin,nPosilin,nFinform,nValue,coutput,nwidth,nheight
local cprg,wq,nrat
myide:lsave:=.T.
myide:npostext:=0
myide:ctext:=''
myide:ntemp:=0
cursorwait()
waitmess:show()
waitmess.hmi_label_101.value:='Loading File....'
IF len(alltrim(myide:cExteditor))=0
   cTextedit:=memoread(cdFile)
   cTextedit:=strtran(cTextedit,chr(9),space(8))  &&& replace tabs with space(8)
   coutput:=''
   for i:=1 to mlcount(ctextedit)
       coutput:=coutput+rtrim(memoline(cTextedit,500,i))+CRLF  &&& rtrim of each line
   next i
   cTextedit:=rtrim(coutput)
   ***   patras:=rat
   do while .t.
      wq:=substr(coutput,len(cTextedit)-1,1)
      if wq=chr(13) .or. wq=chr(10)
         cTextedit:=left(cTextedit,len(ctextedit)-1)
      else
         cTextedit:=left(cTextedit,len(ctextedit)-1)+CRLF
         exit
      endif
   enddo

   if iswindowdefined(editbcvc)
      waitmess:hide()
      msginfo('only one file can be edited at the same time','Information')
      return nil
   endif

   nwidth:=getformobject("form_tree"):width - (getformobject("form_tree"):width/3.5)
   nheight:=getformobject("form_tree"):height-160

          // Migsoft , cvc modified
   DEFINE WINDOW editbcvc obj editbcvc AT 109,80 WIDTH nWidth  HEIGHT nHeight TITLE cNameApp+" "+cdfile ICON 'EDIT' CHILD FONT "Courier New" SIZE 10 backcolor myide:asystemcolor ON SIZE AjustaEditor()

      @ 30,2 RICHEDITBOX edit_1 WIDTH editbcvc:width-15 HEIGHT editbcvc:height-90 VALUE cTextedit ;
             BACKCOLOR {255,255,235} MAXLENGTH 256000 ON CHANGE {|| myide:lsave:=.F.  } ;
             ON GOTFOCUS {|| myide:posxy() }                  // MigSoft

      if len(editbcvc:edit_1:value)>100000
         msginfo('You should use another program editor')
      endif

      if len(editbcvc:edit_1:value)>250000
         msgstop('You must use another program editor')
         return nil
      endif

      ll:=mlcount(editbcvc:edit_1:value)
      if ll<=800
         ninterval:=1000
      else
         ninterval:=int((((ll-800)/800)+1)*2000)
      endif

      DEFINE TIMER Timit INTERVAL ninterval ACTION myide:lookchanges()

      DEFINE SPLITBOX

      DEFINE TOOLBAR ToolBar_1x BUTTONSIZE 20,20 FLAT FONT 'Calibri' SIZE 9   // MigSoft

         BUTTON button_2 tooltip 'Exit(Esc)'    picture 'Exit'  ACTION myide:saveandexit(cdfile)
         BUTTON button_1 tooltip 'Save(F2)'     Picture 'Save'  ACTION myide:savefile(cdfile)
         BUTTON button_3 tooltip 'Find(Ctrl-F)' picture 'M10'   ACTION myide:txtsearch()
         BUTTON button_4 tooltip 'Next(F3)'     picture 'Next'  ACTION myide:nextsearch()
         BUTTON button_5 tooltip 'Go(Ctrl-G)'   picture 'Go'    ACTION myide:goline()
         nrat:=rat('.prg',cdfile)
         if nrat>0
            BUTTON button_6 tooltip 'Reformat(Ctrl-R)' picture 'tbarb'  ACTION reforma1(editbcvc:edit_1:value)
         endif
      END TOOLBAR

      END SPLITBOX

      on key F2 of editbcvc action myide:savefile(cdfile)
      on key F3 of editbcvc action myide:nextsearch()
      on key CTRL+F of editbcvc action myide:txtsearch()
      on key CTRL+G of editbcvc action myide:goline()
      on key ESCAPE of editbcvc action myide:saveandexit(cdfile)
      if nrat>0
            on key CTRL+R of editbcvc action reforma1(editbcvc:edit_1:value)
      endif

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

   center window editbcvc
   waitmess:hide()
   cursorarrow()
   ACTIVATE WINDOW editbcvc
ELSE
   cRun:=myide:cExteditor+' '+cdfile

   waitmess:hide()
   cursorarrow()
   EXECUTE FILE cRun WAIT

ENDIF
return nil

static function pulsatecla()
return nil

*---------------------------------------*
Procedure AjustaEditor()
*---------------------------------------*
   editbcvc.Edit_1.width  := editbcvc:width-15
   editbcvc.Edit_1.height := editbcvc:height-90

Return

*-------------------------
function reforma1(ccontenido)
*-------------------------
waitmess:hmi_label_101:value:='Reformating ....'
waitmess:show()
coutput:=reforma(ccontenido)
editbcvc:edit_1:value:=coutput
waitmess:hide()
editbcvc:edit_1:setfocus()
return nil

*-------------------------
function reforma(ccontenido)
*-------------------------
local ntab:=0
local lcero:=0
local coutput:=''
local swclase:=0
local cantlin:=''
local swcase:=0
local swc:=0
local i,clineaorig,clinea,cllinea,cdeslin
local largo
ccontenido:=strtran(ccontenido,chr(9),space(8))
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
next i
return coutput


*-------------------------
METHOD goline() CLASS THMI
*-------------------------
local i,long:=mlcount(editbcvc:edit_1:value)
local npos:=0,nposx:=0, nposy:=0,nline
nline:=val(inputbox('Go to line:','Question'))
if nline>long
   nline:=long  &&&& para que no se pase
endif
todo:=editbcvc:edit_1:value
editbcvc:edit_1:setfocus()
for i:=1 to long
    npos:=npos+len(rtrim((memoline(todo,500,i))))
    if i == nline
       editbcvc:edit_1:setfocus()
       editbcvc.edit_1.caretpos:=npos+(i*2)-i+1-2-len(trim((memoline(todo,500,i))))
       exit
    endif
next i
return nil


*-------------------------
METHOD lookchanges() CLASS THMI
*-------------------------
if editbcvc.edit_1.caretpos<>myide:_ncaretpos
   myide:posxy()
endif
return


*-------------------------
METHOD posxy() CLASS THMI
*-------------------------
local i,todo
local ncaretpos:=editbcvc.edit_1.caretpos, npos:=0,nposx:=0, nposy:=0
   todo:=editbcvc:edit_1:value
   long:=mlcount(todo)
   myide:_ncaretpos:=ncaretpos
   nposy:=0
   for i:=1 to long
       npos:=npos+len(rtrim(( memoline(todo,500,i)   )))
       if npos > ( ncaretpos -(i-1) )
          nposx:=len((rtrim((memoline(todo,500,i)))))-(npos-(ncaretpos-(i-1)))+1
          nposy:=i
          if nposx=0
             nposy --
             nposx:=len((rtrim((memoline(todo,500,nposy)))))+1
          endif
          exit
       endif
    next i
    editbcvc.StatusBar.Item(1) := ' Lin'+PADR(str(nposy,4),4)+' Col'+PADR(str(nposx,4),4)+' Car'+PADR(str(ncaretpos,4),4)  // MigSoft
return nil


*-------------------------
METHOD txtsearch() CLASS THMI
*-------------------------
myide:npostext:=0
myide:ctext:=rtrim(inputbox('text','Search'))
if len(myide:ctext)=0
   return
endif
myide:nextsearch()
return nil


*-------------------------
METHOD nextsearch() CLASS THMI
*-------------------------
local todo
todo:=strtran(editbcvc:edit_1:value,CR,"")
myide:npostext:=myat(upper(myide:ctext),upper(todo),myide:npostext+len(myide:ctext))
if myide:npostext>0
   editbcvc:edit_1:setfocus()
   editbcvc.edit_1.caretpos:=myide:npostext-1
else
   editbcvc:edit_1:setfocus()
   msginfo('End search','Information')
endif
return nil


*-------------------------
function myat(cbusca,ctodo,ninicio)
*-------------------------
local i,nposluna
nposluna:=0
for i:= ninicio to len(ctodo)
    if upper(substr(ctodo,i,len(cbusca)))=upper(cbusca)
       nposluna:=i
       exit
    endif
next i
return nposluna


*-------------------------
METHOD saveandexit(cdfile) CLASS THMI
*-------------------------
if .not. myide:lsave
   if msgyesno('File not saved (save ?)','Question')
      myide:savefile(cdfile)
   endif
endif
editbcvc:release()
return

*-------------------------
METHOD databaseview() CLASS THMI
*-------------------------
local cdfile,npos,i,j
if iswindowdefined(Form_brow)
   msginfo('Browse already running','Information')
   return nil
endif
***set interactiveclose on
curfol:=curdir()
curdrv:=curdrive()+':\'   //MigSoft
cdFile:=''
cdFile:=getFile ( { {'dbf files *.dbf','*.dbf'} }  , 'Open Dbf file',,.F.,.F. )
if len(cdFile)>0
   npos:=at(".",cdfile)
   cdfile:=left(cdfile,npos-1)
   J:=0
   for i:=1 to len(cdfile)
       if substr(cdfile,i,1)=='\'
          j:=i
       endif
   next i
   cdfile:=substr(cdfile,j+1,len(cdfile))
   use &cdfile SHARED
   SET DELETED ON
   EDIT EXTENDED WORKAREA &cdfile TITLE 'Browsing of ... '+cdfile ;

   Close data
endif
DIRCHANGE(curdrv+curfol)
return

*-------------------------
METHOD exitview() CLASS THMI
*-------------------------
form_brow:release()
return


*-------------------------
METHOD disable_button() CLASS THMI
*-------------------------
form_tree:button_7:enabled := .F.
form_tree:button_9:enabled := .F.
form_tree:button_10:enabled := .F.
form_tree:button_11:enabled := .F.
return


*-------------------------
METHOD exitform() CLASS THMI
*-------------------------
if .not. myform:lFsave
   if msgyesno('Form not saved (save ?)','Question')
      myform:save(0)
   endif

endif
   if RTL#NIL
      release window all
   endif
if iswindowactive(lista)
   release window lista
endif
if iswindowactive(form_1)
   release window form_1
endif


cvccontrols:hide()

form_main:hide()
form_tree:button_7:enabled := .T.
form_tree:button_9:enabled := .T.
form_tree:button_10:enabled := .T.
form_tree:button_11:enabled := .T.
myide:form_activated:=.F.
return

*-------------------------
static function databaseview2()
*-------------------------
local cdfile,npos,i,j
if iswindowdefined(Form_brow)
   msginfo('Browse already running','Information')
   return nil
endif
***set interactiveclose on
curfol:=curdir()
curdrv:=curdrive()+':\'   //MigSoft
cdFile:=''
cdFile:=getFile ( { {'dbf files *.dbf','*.dbf'} }  , 'Open Dbf file',,.F.,.F. )
if len(cdFile)>0
   npos:=at(".",cdfile)
   cdfile:=left(cdfile,npos-1)
   J:=0
   for i:=1 to len(cdfile)
       if substr(cdfile,i,1)=='\'
          j:=i
       endif
   next i
   cdfile:=substr(cdfile,j+1,len(cdfile))
   use &cdfile SHARED
   SET DELETED ON
   AfieldNames := &cdfile->(ARRAY(FCOUNT()))
   aTypes := &cdfile->(ARRAY(FCOUNT()))
   aWidths := &cdfile->(ARRAY(FCOUNT()))
   aDecimals := &cdfile->(ARRAY(FCOUNT()))
   &cdfile->(AFIELDS(aFieldNames, aTypes, aWidths, aDecimals))

   aeval( awidths, {|n,i| iif(awidths[i]<=3, awidths[i]:=30,awidths[i]:=awidths[i]*10) } )

   DEFINE WINDOW Form_brow obj Form_brow ;
      AT 0,0 ;
      WIDTH 640 HEIGHT 480 ;
      TITLE 'Quick Browsing of ... '+cdfile ;
      ICON 'Edit' ;
      child NOMAXIMIZE   ;
      on init {|| form_brow:maximize };
      backcolor myide:asystemcolor

      @ 25,80 BROWSE Browse_1 ;
      OF form_brow  OBJ Obrow ;
      WIDTH 640 ;
      HEIGHT 460 ;
      HEADERS aFieldNames ;
      WIDTHS awidths ;
      WORKAREA &cdfile ;
      FIELDS aFieldnames ;
      VALUE 0 ;
      TOOLTIP 'Dbl Click to modify' ;
      EDIT APPEND DELETE ;
      LOCK ;
      

      obrow:bettercolumnsautofit()

      @ 40,730 button button_sal ;
      caption 'Exit'  ;
      action ( myide:exitview() ) width 60 FLAT


      DEFINE LABEL LABEL_QB
         row 490
         col 150
         value  "ALT-A (Add record) - Delete (Delete record) - Dbl_click (Modify record)"
         width 500
      end label

   END WINDOW
   
   Form_brow:Browse_1:SetFocus()

   CENTER WINDOW Form_brow
   ACTIVATE WINDOW Form_brow
   Close all
endif
DIRCHANGE(curdrv+curfol)
return


*-------------------------
function mayusculas(wpaquetes,avalues,aformats)
*-------------------------
local i,t
apaquetes:=wpaquetes
aeval( apaquetes, {|a,i| apaquetes[i]:=upper(substr(apaquetes[i],1,1))+lower(substr(apaquetes[i],2))  } )
return { apaquetes,avalues,aformats }


*--------------------------------------------------------------------------------------------------------------------------*
Function myInputWindow ( Title , aLabels , aValues , aFormats , row , col , aValid , TmpNames , aValidMessages , aReadOnly )
*--------------------------------------------------------------------------------------------------------------------------*
local i , l , ControlRow , e := 0 ,LN , CN ,r , c , wHeight , diff, org
org:=mayusculas(alabels,avalues,aformats)
alabels:=org[1]
avalues:=org[2]
aformats:=org[3]
set interactiveclose on
l := Len ( aLabels )

Private aResult [l]

For i := 1 to l
    if ValType ( aValues[i] ) == 'C'
       if ValType ( aFormats[i] ) == 'N'
          If aFormats[i] > 32
             e++
          Endif
       EndIf
    EndIf
    if ValType ( aValues[i] ) == 'M'
       e++
    EndIf
Next i
if pcount() == 4
   r := 0
   c := 0
Else
   r := row
   c := col
   wHeight :=  (l*24) + 90 + (e*60)

   if r + wHeight > GetDeskTopHeight() - 35
      diff :=  r + wHeight - GetDeskTopHeight() + 35
      r := r - diff
   EndIf
EndIf
wminus:=0
if getdesktopheight()=480
   wminus=10
   myide:lvirtual=.T.
endif
   wyw:=(l*24) + 190 + (e*60)
   wheight:=getdesktopheight()-myide:mainheight-150-wminus
   *****           wheight:=getdesktopheight()-myide:mainheight-180-wminus
   if wyw < wheight
      wyw:= wheight + 1
   endif

      DEFINE WINDOW _inputwindow obj _iw ;
         WIDTH 720 ;
         HEIGHT wheight - 90 ;
         VIRTUAL HEIGHT wyw TITLE title MODAL NOSIZE ;
         ICON 'Edit' ;
         FONT 'Courier new' SIZE 9 ;
         backcolor  myide:asystemcolor
         
         on key ESCAPE of _inputwindow action {|| _myInputWindowCancel(_iw, aresult ), sale()}

         ControlRow :=  10

         For i := 1 to l
             LN := 'Label_' + Alltrim(Str(i))
             CN := 'Control_' + Alltrim(Str(i))

             @ ControlRow , 10 LABEL &LN OF _inputwindow VALUE aLabels [i] AUTOSIZE

             do case
                case ValType ( aValues [i] ) == 'L'
                   @ ControlRow , 116 CHECKBOX &CN OF _inputwindow CAPTION '' VALUE aValues[i]
                   ControlRow := ControlRow + 28
                case ValType ( aValues [i] ) == 'D'
                   @ ControlRow , 116 DATEPICKER &CN  OF _inputwindow VALUE aValues[i] WIDTH 420
                   ControlRow := ControlRow + 24
                case ValType ( aValues [i] ) == 'N'
                   If ValType ( aFormats [i] ) == 'A'
                      @ ControlRow , 116 COMBOBOX &CN  OF _inputwindow ITEMS aFormats[i] VALUE aValues[i] WIDTH 420  FONT 'Arial' SIZE 9
                      ControlRow := ControlRow + 24
                   ElseIf  ValType ( aFormats [i] ) == 'C'
                      If AT ( '.' , aFormats [i] ) > 0
                         @ ControlRow , 116 TEXTBOX &CN  OF _inputwindow VALUE aValues[i] WIDTH 120 FONT 'Courier new' SIZE 9 NUMERIC  INPUTMASK aFormats [i]  RIGHTALIGN
                      Else
                         // pb - comento esa linea y la cambio por la de abajo
                         //@ ControlRow , 116 TEXTBOX &CN  OF _inputwindow VALUE aValues[i] WIDTH 120 FONT 'Courier new' SIZE 9 MAXLENGTH Len(aFormats [i]) NUMERIC RIGHTALIGN
                         @ ControlRow , 116 TEXTBOX &CN  OF _inputwindow VALUE aValues[i] WIDTH 120 FONT 'Courier new' SIZE 9 NUMERIC  INPUTMASK aFormats [i]  RIGHTALIGN
                      EndIf
                      ControlRow := ControlRow + 24
                   Endif
                case ValType ( aValues [i] ) == 'C'
                   If ValType ( aFormats [i] ) == 'N'
                      If  aFormats [i] <= 32
                         @ ControlRow , 116 TEXTBOX &CN  OF _inputwindow VALUE aValues[i] WIDTH 270 FONT 'Courier new' SIZE 9 MAXLENGTH aFormats [i]
                         ControlRow := ControlRow + 24
                      Else
                         @ ControlRow , 116 EDITBOX &CN  OF _inputwindow WIDTH 420  HEIGHT 40 VALUE aValues[i] FONT 'Courier new' SIZE 9 MAXLENGTH aFormats[i] NOVSCROLL
                         ControlRow := ControlRow + 42
                      EndIf
                   EndIf
                case ValType ( aValues [i] ) == 'M'
                   @ ControlRow , 116 EDITBOX &CN  OF _inputwindow WIDTH 420 HEIGHT 90 VALUE aValues[i] FONT 'Courier new' SIZE 9
                   ControlRow := ControlRow + 88
             endcase

             If ValType ( aReadOnly ) != 'U'
                If aReadOnly [i] == .T.
                   _DisableControl ( CN ,'_inputwindow' )
                EndIf
             EndIf
         Next i

   DEFINE STATUSBAR     ///////////SIZE 10
       STATUSITEM " " WIDTH 500
      statusitem "Ok    " width 70 action { || _myInputWindowOk ( _iw ,  aresult ), sale() }  tooltip "Ok button"
      statusitem "Cancel " width 70 ACTION {||  _myInputWindowCancel(_iw, aresult ), sale()  }  tooltip "Cancel Button"

/////      statusitem "    "
   END STATUSBAR


      END WINDOW


   CENTER WINDOW _InputWindow

ACTIVATE WINDOW _InputWindow

myide:lvirtual:=.F.
set interactiveclose off
Return ( aResult )

*-----------------------------------------------------------------------------*
Function _myInputWindowOk( oInputWindow, aResult )
*-----------------------------------------------------------------------------*
Local i , l
   l := len( aResult )
   For i := 1 to l
      aResult[ i ] := oInputWindow:Control( 'Control_' + Alltrim( Str( i ) ) ):Value
   Next i
Return Nil

*-----------------------------------------------------------------------------*
Function _myInputWindowCancel( oInputWindow, aResult )
*-----------------------------------------------------------------------------*
   afill( aResult, NIL )
Return Nil


*-------------------------
function sale()
*-------------------------
release window _inputwindow
if iswindowdefined("form_1")
    mispuntos()
endif
return nil

FUNCTION DelExt(cFileName)

  LOCAL cBase := LEFT(cFileName, LEN(cFileName) - 4)

RETURN cBase

FUNCTION AddSlash(cInFolder)

  LOCAL cOutFolder := ALLTRIM(cInFolder)

  IF RIGHT(cOutfolder, 1) != '\'
    cOutFolder += '\'
  ENDIF

RETURN cOutFolder

//***************************************************************************

FUNCTION DelSlash(cInFolder)

  LOCAL cOutFolder := ALLTRIM(cInFolder)

  IF RIGHT(cOutfolder, 1) == '\'
    cOutFolder := LEFT(cOutFolder, LEN(cOutFolder) - 1)
  ENDIF

RETURN cOutFolder
//******************

*---------------------------------------------------------------*
Function OnlyFolder(cFile1)
*---------------------------------------------------------------*
   Local i,nLg,cFolder,nPosFile
   If Len(cFile1) > 0
      i := 1
      nLg :=  LEN(cFile1)
      do while ( nLg > i )
         if '\' $ Right(cFile1,i-1)
            nPosFile := i-1
            i := LEN(cFile1)
         endif
         i++
      enddo
      cFolder := Left(cFile1,nLg-nPosfile)
   Else
      cFolder := Nil
   Endif
Return(cFolder)

*---------------------------------------------------------------*
Function IsFileInPath( cFileName )
*---------------------------------------------------------------*
   Local cDir
   LOCAL cName
   LOCAL cExt
   LOCAL cFullName
   LOCAL aExt

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
            Return .T.
         EndIf
      EndIf
   Next
Return .F.


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

/*
HB_FUNC ( GETWINDOWTEXT )
{
  int iLen = GetWindowTextLength( ( HWND ) hb_parnl( 1 ) ) + 1;
       char *cText = (char*) hb_xgrab( iLen+1 ) ;
       GetWindowText(
              (HWND) hb_parnl (1),
                      (LPTSTR) cText,
                            iLen
                      );

                             hb_retc( cText );
                              hb_xfree( cText );
  }
*/
 HB_FUNC ( GETEXEFILENAME )
{
   unsigned char pBuf[250];

   GetModuleFileName( GetModuleHandle(NULL), (LPTSTR) pBuf, 249 );

   hb_retc( (char*) pBuf );
}


#pragma ENDDUMP
