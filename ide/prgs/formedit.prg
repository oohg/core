/*
 * $Id: formedit.prg,v 1.2 2014-06-19 18:53:30 fyurisich Exp $
 */

/*
 * Copyright 2003-2014 Ciro Vargas Clemow <pcman2010@yahoo.com>
 * http://sistemasvc.tripod.com/
 */

#include "oohg.ch"
#include "hbclass.ch"
#DEFINE CRLF CHR(13)+CHR(10)
#DEFINE CR CHR(13)
#DEFINE LF CHR(10)
#DEFINE WM_PAINT   15

//------------------------------------------------------------------------------
CLASS TForm1
//------------------------------------------------------------------------------
   // variables varias
   DATA Designform           INIT 'Form_1'
   DATA CurrentControl       INIT 0
   DATA nform                INIT 1
   DATA ncontrolw            INIT 0
   DATA lfsave               INIT .T.
   DATA cform                INIT ''
   DATA aline                INIT {}
   DATA acontrolw            INIT {}
   DATA actrltype            INIT {}
   DATA swtab                INIT .F.
   DATA myIde                INIT Nil

   // variables de propiedades y eventos
   DATA afontsize            INIT {}
   DATA afontname            INIT {}
   DATA abold                INIT {}
   DATA afontcolor           INIT {}
   DATA afontitalic          INIT {}
   DATA afontunderline       INIT {}
   DATA afontstrikeout       INIT {}
   DATA abackcolor           INIT {}
   DATA avalue               INIT {}
   DATA avaluen              INIT {}
   DATA avaluel              INIT {}
   DATA aspeed               INIT {}
   DATA Avalue               INIT {}
   DATA Avaluen              INIT {}
   DATA Avaluel              INIT {}
   DATA Acaption             INIT {}
   DATA Apicture             INIT {}
   DATA Afield               INIT {}
   DATA Apassword            INIT {}
   DATA Anumeric             INIT {}
   DATA AinputmasK           INIT {}
   DATA Auppercase           INIT {}
   DATA Alowercase           INIT {}
   DATA Aopaque              INIT {}
   DATA Anoticks             INIT {}
   DATA Aboth                INIT {}
   DATA Atop                 INIT {}
   DATA Aleft                INIT {}
   DATA Ainvisible           INIT {}
   DATA Anotabstop           INIT {}
   DATA Awrap                INIT {}
   DATA Aincrement           INIT {}
   DATA Asort                INIT {}
   DATA Astretch             INIT {}
   DATA Afile                INIT {}
   DATA Aautoplay            INIT {}
   DATA Acenter              INIT {}
   DATA Acenteralign         INIT {}
   DATA Ashownone            INIT {}
   DATA Aupdown              INIT {}
   DATA Areadonly            INIT {}
   DATA Abreak               INIT {}
   DATA Aitems               INIT {}
   DATA Aitemsource          INIT {}
   DATA Avaluesource         INIT {}
   DATA Aheaders             INIT {}
   DATA Awidths              INIT {}
   DATA Aonheadclick         INIT {}
   DATA Amultiselect         INIT {}
   DATA Anolines             INIT {}
   DATA Aimage               INIT {}
   DATA Aworkarea            INIT {}
   DATA Afields              INIT {}
   DATA Avalid               INIT {}
   DATA Awhen                INIT {}
   DATA Avalidmess           INIT {}
   DATA Areadonlyb           INIT {}
   DATA Alock                INIT {}
   DATA Adelete              INIT {}
   DATA Ajustify             INIT {}
   DATA Ahelpid              INIT {}
   DATA Arightalign          INIT {}
   DATA Atooltip             INIT {}
   DATA Amaxlength           INIT {}
   DATA Aongotfocus          INIT {}
   DATA Aonchange            INIT {}
   DATA Aonlostfocus         INIT {}
   DATA Aonenter             INIT {}
   DATA Aondisplaychange     INIT {}
   DATA Aondblclick          INIT {}
   DATA Aaction              INIT {}
   DATA Arange               INIT {}
   DATA Avertical            INIT {}
   DATA Asmooth              INIT {}
   DATA Aspacing             INIT {}
   DATA Avisible             INIT {}
   DATA Aenabled             INIT {}
   DATA Atransparent         INIT {}
   DATA Adate                INIT {}
   DATA Anotoday             INIT {}
   DATA Anotodaycircle       INIT {}
   DATA Aweeknumbers         INIT {}
   DATA Aaddress             INIT {}
   DATA Ahandcursor          INIT {}
   DATA Atabpage             INIT {}
   DATA Aname                INIT {}
   DATA Anumber              INIT {}
   DATA Aflat                INIT {}
   DATA Abuttons             INIT {}
   DATA Ahottrack            INIT {}
   DATA Adisplayedit         INIT {}
   DATA Anodeimages          INIT {}
   DATA Aitemimages          INIT {}
   DATA ANorootbutton        INIT {}
   DATA AItemids             INIT {}
   DATA Anovscroll           INIT {}
   DATA Anohscroll           INIT {}
   DATA Adynamicbackcolor    INIT {}
   DATA Adynamicforecolor    INIT {}
   DATA Acolumncontrols      INIT {}
   DATA Aoneditcell          INIT {}
   DATA Aonappend            INIT {}
   DATA Ainplace             INIT {}
   DATA Aedit                INIT {}
   DATA Aappend              INIT {}
   DATA Aclientedge          INIT {}
   DATA afocusedpos          INIT {}  // pb

   // variables de forms
   DATA Cftitle              INIT ""
   DATA cfname               INIT ""
   DATA cficon               INIT ""
   DATA lfmain               INIT ""
   DATA lfchild              INIT .F.
   DATA lfmodal              INIT .F.
   DATA lfnoshow             INIT .F.
   DATA lftopmost            INIT .F.
   DATA lfnominimize         INIT .F.
   DATA lfnomaximize         INIT .F.
   DATA lfnosize             INIT .F.
   DATA lfnosysmenu          INIT .F.
   DATA lfnocaption          INIT .F.
   DATA lfnoautorelease      INIT .F.
   DATA lfhelpbutton         INIT .F.
   DATA lffocused            INIT .F.
   DATA lfbreak              INIT .F.
   DATA lfsplitchild         INIT .F.
   DATA lfgrippertext        INIT .F.
   DATA cfbackcolor          INIT "{212,208,200}"
   DATA cfcursor             INIT ""
   DATA cffontname           INIT "MS Sans Serif"
   DATA nffontsize           INIT 9
   DATA nfvirtualw           INIT 0
   DATA nfvirtualh           INIT 0
   DATA cfontcolor           INIT ""
   DATA cbackcolor           INIT ""
   DATA cfnotifyicon         INIT ""
   DATA cfnotifytooltip      INIT ""
   DATA cfobj                INIT ""

   // variables de events
   DATA cfoninit             INIT ""
   DATA cfonrelease          INIT ""
   DATA cfoninteractiveclose INIT ""
   DATA cfonmouseclick       INIT ""
   DATA cfonmousemove        INIT ""
   DATA cfonmousedrag        INIT ""
   DATA cfongottfocus        INIT ""
   DATA cfonlostfocus        INIT ""
   DATA cfonscrollup         INIT ""
   DATA cfonscrolldown       INIT ""
   DATA cfonscrollleft       INIT ""
   DATA cfonscrollright      INIT ""
   DATA cfonhscrollbox       INIT ""
   DATA cfonvscrollbox       INIT ""
   DATA cfonnotifyclick      INIT ""
   DATA cfonsize             INIT ""
   DATA cfonpaint            INIT ""
   DATA cfoninit             INIT ""
   DATA cfonrelease          INIT ""
   DATA cfonmouseclick       INIT ""
   DATA cfonmousedrag        INIT ""
   DATA cfonmousemove        INIT ""
   DATA cfonsize             INIT ""
   DATA cfonpaint            INIT ""
   DATA cfongotfocus         INIT ""
   DATA cfonlostfocus        INIT ""

   // variables de statusbar
   DATA cscaption            INIT ''
   DATA csfontname           INIT 'MS Sans Serif'
   DATA nsfontsize           INIT 9
   DATA cscolor              INIT ''
   DATA nswidth              INIT 80
   DATA csaction             INIT ''
   DATA csicon               INIT ''
   DATA lsflat               INIT .F.
   DATA lsstat               INIT .F.
   DATA lsraised             INIT .F.
   DATA cstooltip            INIT ''
   DATA lskeyboard           INIT .F.
   DATA lsdate               INIT .F.
   DATA nsdatewidth          INIT 80
// DATA csdateaction         INIT ''
// DATA csdatetooltip        INIT ''
   DATA lstime               INIT .F.
   DATA nstimewidth          INIT 80
// DATA cstimeaction         INIT ''
// DATA cstimetooltip        INIT ''

   // variables de contadores de tipos de controles
   DATA ButtonCount           INIT  0
   DATA CheckBoxCount        INIT  0
   DATA ListBoxCount          INIT  0
   DATA ComboBoxCount       INIT  0
   DATA CheckButtonCount    INIT  0
   DATA GridCount           INIT  0
   DATA FrameCount      INIT  0
   DATA TabCount      INIT  0
   DATA ImageCount      INIT  0
   DATA AnimateCount   INIT  0
   DATA DatepickerCount   INIT  0
   DATA TextBoxCount   INIT  0
   DATA EditBoxCount   INIT  0
   DATA LabelCount      INIT  0
   DATA PlayerCount      INIT  0
   DATA ProgressBarCount   INIT  0
   DATA RadioGroupCount   INIT  0
   DATA SliderCount      INIT  0
   DATA SpinnerCount   INIT  0
   DATA Timercount          INIT  0
   DATA BrowseCount         INIT  0
   DATA Treecount           INIT  0
   DATA Ipaddresscount      INIT  0
   DATA Monthcalendarcount  INIT  0
   DATA Hyperlinkcount      INIT  0
   DATA Richeditboxcount    INIT  0

   METHOD vd( cItem1, myIde ) CONSTRUCTOR
   METHOD end() INLINE return
   METHOD verifybar()
   METHOD what(citem1)
   METHOD iniarray(nform,ncontrolwl,controlname,ctypectrl,noanade)
   METHOD AddControl()
   METHOD new()
   METHOD Newagain()
   METHOD Open(cItem1)
   METHOD fillcontrolaux()
   METHOD fillcontrol()
   METHOD Control_click(wpar)
   // METHOD leeprg()
   METHOD leatipo(cname)
   METHOD leadato(cName,cPropmet,cDefault)
   METHOD leadatostatus(cName,cPropmet,cDefault)
   METHOD leadatologic(cName,cPropmet,cDefault)
   METHOD learow(cName)
   METHOD learowf(cname)
   METHOD leacol(cName)
   METHOD leacolf(cname)
   METHOD clean(cfvalue)
   METHOD leadato_oop(cName,cPropmet,cDefault)
   METHOD save(Cas)
ENDCLASS

*------------------------------------------------------------------------------*
METHOD vd( cItem1, myIde ) CLASS TForm1
*------------------------------------------------------------------------------*
local nNumcont:=0
   Public swcursor := 0, myhandle := 0, cfbackcolor := ::cfbackcolor, swkm:=.F., swordenfd:=.F.

   nhandlep := 0

   DECLARE WINDOW form_main
   DECLARE WINDOW form_tree
   DECLARE WINDOW form_1
   DECLARE WINDOW cvccontrols
   DECLARE WINDOW waitmess
   DECLARE WINDOW lista

   SET INTERACTIVECLOSE OFF

   CursorWait()

   ::myIde                := myIde
   ::ButtonCount          := nNumcont
   ::CheckBoxCount        := nNumcont
   ::ListBoxCount         := nNumcont
   ::ComboBoxCount        := nNumcont
   ::CheckButtonCount     := nNumcont
   ::GridCount            := nNumcont
   ::FrameCount           := nNumcont
   ::TabCount             := nNumcont
   ::ImageCount           := nNumcont
   ::AnimateCount         := nNumcont
   ::DatepickerCount      := nNumcont
   ::TextBoxCount         := nNumcont
   ::EditBoxCount         := nNumcont
   ::LabelCount           := nNumcont
   ::PlayerCount          := nNumcont
   ::ProgressBarCount     := nNumcont
   ::RadioGroupCount      := nNumcont
   ::SliderCount          := nNumcont
   ::SpinnerCount         := nNumcont
   ::Timercount           := nNumcont
   ::BrowseCount          := nNumcont
   ::Treecount            := nNumcont
   ::Ipaddresscount       := nNumcont
   ::Monthcalendarcount   := nNUmcont
   ::Hyperlinkcount       := nNUmcont
   ::Richeditboxcount     := nNUmcont
   ::Aline                := {}
   ::cftitle              := ""
   ::cfname               := ""
   ::cficon               := ""
   ::lfmain               := .F.
   ::lfchild              := .F.
   ::lfmodal              := .F.
   ::lfhelpbutton         := .F.
   ::lffocused            := .F.
   ::lfbreak              := .F.
   ::lfsplitchild         := .F.
   ::lfgrippertext        := .F.
   ::lfnoshow             := .F.
   ::lftopmost            := .F.
   ::lfnominimize         := .F.
   ::lfnomaximize         := .F.
   ::lfnosize             := .F.
   ::lfnosysmenu          := .F.
   ::lfnocaption          := .F.
   ::lfnoautorelease      := .F.
   ::cfbackcolor          := ::myIde:cdbackcolor
   ::cffontname           := "MS Sans Serif"
   ::nffontsize           := 9
   ::nfvirtualw           := 0
   ::nfvirtualh           := 0
   ::cfontcolor           := ""
   ::cfcursor             := ""
   ::cbackcolor           := ::myIde:cdbackcolor
   ::cfnotifyicon         := ""
   ::cfnotifytooltip      := ""
   ::cfoninit             := ""
   ::cfonrelease          := ""
   ::cfonmouseclick       := ""
   ::cfonmousemove        := ""
   ::cfonmousedrag        := ""
   ::cfongottfocus        := ""
   ::cfonlostfocus        := ""
   ::cfonscrollup         := ""
   ::cfonscrolldown       := ""
   ::cfonscrollleft       := ""
   ::cfonscrollright      := ""
   ::cfonhscrollbox       := ""
   ::cfonvscrollbox       := ""
   ::cfonnotifyclick      := ""
   ::cfonsize             := ""
   ::cfonpaint            := ""
   ::cfoninteractiveclose :=  ""
   ::cscaption            := ''
   ::csfontname           := 'MS Sans Serif'
   ::nsfontsize           := 9
   ::cscolor              := ''
   ::nswidth              := 80
   ::csaction             := ''
   ::csicon               := ''
   ::lsflat               := .F.
   ::lsstat               := .F.
   ::lsraised             := .F.
   ::cstooltip            := ''
   ::lskeyboard           := .F.
   ::lsdate               := .F.
   ::nsdatewidth          := 80
   ::lstime               := .F.
   ::nstimewidth          := 80
   ::nffontsize           := 10

   form_main:Title := 'ooHG IDE Plus - Form designer'
   form_main:frame_1:Caption := "Form: " + cItem1
   ::myIde:Disable_Button()
   ::What( citem1 )
Return Self

*---------------------------------
METHOD verifybar() CLASS TForm1
*---------------------------------
if .not. myform:lsstat  &&&&  lstat
    cvccontrols.control_30.visible:=.T.
    myform:lsstat:=.T.

    DEFINE STATUSBAR of form_1
            if len(myform:cscaption)> 0
               STATUSITEM myform:cscaption
            else
               statusitem ""
            endif
            if myform:lskeyboard
               KEYBOARD
            endif
            if myform:lsdate
               DATE WIDTH 95
            endif
            if myform:lstime
               CLOCK WIDTH 85
            endif
   END STATUSBAR

else
    cvccontrols.control_30.visible:=.F.
    myform:lsstat:=.F.
    form_1.statusbar.release
endif
myform:lfsave:=.F.
return

*---------------------------------
METHOD what(citem1) CLASS TForm1
*---------------------------------
local npos,npos1,nd
myform:cForm:=citem1
npos:=rat(".",myform:cForm)
npos1:=rat("\",myform:cForm)
nd:=1
if npos1=0
   npos1:=1
   nd:=0
endif
myform:cFname:=substr(myform:cForm,npos1+nd,npos-npos1-nd)
myform:cFname:=lower(myform:cFname)
myform:lsstat:=.F.
cvccontrols.control_30.visible:=.F.
form_main:butt_status:value:=.F.
if file(cItem1)
   myform:open(cItem1)
else
   myform:new()
endif
cursorarrow()
return

*-----------------------------------------------------------------------------
METHOD iniarray(nform,ncontrolwl,controlname,ctypectrl,noanade) CLASS TForm1
*-----------------------------------------------------------------------------
 **** inicia array de controles para la forma actual
 with Object myform
 if noanade=NIL

     aadd(:acontrolw,controlname)
     aadd(:actrltype,ctypectrl)
     aadd(:aenabled,.T.)
     aadd(:avisible,.T.)
     aadd(:afontname,:cffontname)
     aadd(:afontsize,:nffontsize)
     aadd(:abold,.F.)
     aadd(:abackcolor,"{255,255,255}")
     aadd(:afontcolor,"{0,0,0}")
     aadd(:afontitalic,.F.)
     aadd(:afontunderline,.F.)
     aadd(:afontstrikeout,.F.)
     aadd(:atransparent,.F.)
     aadd(:acaption,"")
     aadd(:apicture,"")
     aadd(:avalue,"")
     aadd(:avaluen,0)
     aadd(:avaluel,.F.)
     aadd(:atooltip,"")
     aadd(:amaxlength,30)
     aadd(:awrap,.F.)
     aadd(:aincrement,0)
     aadd(:auppercase,.f.)
     aadd(:apassword,.f.)
     aadd(:anumeric,.f.)
     aadd(:ainputmasK,"")
     aadd(:auppercase,.f.)
     aadd(:alowercase,.f.)
     aadd(:aaction,"")
     aadd(:aopaque,.F.)
     aadd(:arange,"")
     aadd(:anotabstop,.F.)
     aadd(:asort,.F.)
     aadd(:afile,"")
     aadd(:ainvisible,.F.)
     aadd(:aautoplay,.F.)
     aadd(:acenter,.F.)
     aadd(:acenteralign,.F.)
     aadd(:atransparent,.F.)
     aadd(:ashownone,.F.)
     aadd(:aupdown,.F.)
     aadd(:areadonly,.F.)
     aadd(:avertical,.F.)
     aadd(:asmooth,.F.)
     aadd(:anoticks,.F.)
     aadd(:aboth,.F.)
     aadd(:atop,.F.)
     aadd(:aleft,.F.)
     aadd(:abreak,.F.)
     aadd(:aitems, "")
     aadd(:aitemsource,"")
     aadd(:avaluesource,"")
     aadd(:amultiselect,.F.)
     aadd(:ahelpid,0)
     aadd(:aspacing,0)
     aadd(:aheaders,"{'one','two'}")
     aadd(:awidths,'{60,60}')
     aadd(:aonheadclick,'')
     aadd(:anolines,.F.)
     aadd(:aimage,'')
     aadd(:astretch,.f.)
     aadd(:aworkarea,'ALIAS()')
     aadd(:afields,'')
     aadd(:afield,'')
     aadd(:avalid,'')
     aadd(:awhen,'')
     aadd(:avalidmess,'')
     aadd(:areadonlyb,'')
     aadd(:alock,.F.)
     aadd(:adelete,.F.)
     aadd(:ajustify,'')
     aadd(:adate,.F.)
     aadd(:aongotfocus,"")
     aadd(:aonchange,"")
     aadd(:aonlostfocus,"")
     aadd(:aonenter,"")
     aadd(:aondisplaychange,"")
     aadd(:aondblclick,"")
     aadd(:arightalign,.f.)
     aadd(:anotoday,.f.)
     aadd(:anotodaycircle,.f.)
     aadd(:aweeknumbers,.f.)
     aadd(:aaddress,"")
     aadd(:ahandcursor,.F.)
     aadd(:atabpage,{'',0})  //     aadd(:atabpage[1,1],'')  &&& nombre del TAB a que pertenece   :atabpage[1,2]:=0   &&& numero de la pagina
     aadd(:aname,controlname)
     aadd(:anumber,0)
     aadd(:aflat,.F.)
     aadd(:abuttons,.F.)
     aadd(:ahottrack,.F.)
     aadd(:adisplayedit,.F.)
     aadd(:Anodeimages,'')
     aadd(:Aitemimages,'' )
     aadd(:ANorootbutton,.F.)
     aadd(:AItemids,.F.)
     aadd(:Anovscroll,.F.)
     aadd(:Anohscroll,.F.)
     aadd(:Adynamicbackcolor,"")
     aadd(:Adynamicforecolor,"")
     aadd(:Acolumncontrols,"")
     aadd(:Aoneditcell,"")
     aadd(:Aonappend,"")
     aadd(:Ainplace,.T.)
     aadd(:Aedit,.F.)
     aadd(:Aappend,.F.)
     aadd(:Aclientedge,.F.)
     aadd(:afocusedpos,-2)  // pb

     aadd(:aspeed,1)

   else

     z:=ncontrolwl

     myadel("myform:acontrolw",z)
     myadel("myform:actrltype",z)
     myadel("myform:aenabled",z)
     myadel("myform:avisible",z)
     myadel("myform:afontname",z)
     myadel("myform:afontsize",z)
     myadel("myform:abold",z)
     myadel("myform:abackcolor",z)
     myadel("myform:afontcolor",z)
     myadel("myform:afontitalic",z)
     myadel("myform:afontunderline",z)
     myadel("myform:afontstrikeout",z)
     myadel("myform:atransparent",z)
     myadel("myform:acaption",z)
     myadel("myform:apicture",z)
     myadel("myform:avalue",z)
     myadel("myform:avaluen",z)
     myadel("myform:avaluel",z)
     myadel("myform:atooltip",z)
     myadel("myform:amaxlength",z)
     myadel("myform:awrap",z)
     myadel("myform:aincrement",z)
     myadel("myform:auppercase",z)
     myadel("myform:apassword",z)
     myadel("myform:anumeric",z)
     myadel("myform:ainputmasK",z)
     myadel("myform:auppercase",z)
     myadel("myform:alowercase",z)
     myadel("myform:aaction",z)
     myadel("myform:aopaque",z)
     myadel("myform:arange",z)
     myadel("myform:anotabstop",z)
     myadel("myform:asort",z)
     myadel("myform:afile",z)
     myadel("myform:ainvisible",z)
     myadel("myform:aautoplay",z)
     myadel("myform:acenter",z)
     myadel("myform:acenteralign",z)
     myadel("myform:atransparent",z)
     myadel("myform:ashownone",z)
     myadel("myform:aupdown",z)
     myadel("myform:areadonly",z)
     myadel("myform:avertical",z)
     myadel("myform:asmooth",z)
     myadel("myform:anoticks",z)
     myadel("myform:aboth",z)
     myadel("myform:atop",z)
     myadel("myform:aleft",z)
     myadel("myform:abreak",z)
     myadel("myform:aitems", z)
     myadel("myform:aitemsource",z)
     myadel("myform:avaluesource",z)
     myadel("myform:amultiselect",z)
     myadel("myform:ahelpid",z)
     myadel("myform:aspacing",z)
     myadel("myform:aheaders",z)
     myadel("myform:awidths",z)
     myadel("myform:aonheadclick",z)
     myadel("myform:anolines",z)
     myadel("myform:aimage",z)
     myadel("myform:astretch",z)
     myadel("myform:aworkarea",z)
     myadel("myform:afields",z)
     myadel("myform:afield",z)
     myadel("myform:avalid",z)
     myadel("myform:awhen",z)
     myadel("myform:avalidmess",z)
     myadel("myform:areadonlyb",z)
     myadel("myform:alock",z)
     myadel("myform:adelete",z)
     myadel("myform:ajustify",z)
     myadel("myform:adate",z)
     myadel("myform:aongotfocus",z)
     myadel("myform:aonchange",z)
     myadel("myform:aonlostfocus",z)
     myadel("myform:aonenter",z)
     myadel("myform:aondisplaychange",z)
     myadel("myform:aondblclick",z)
     myadel("myform:arightalign",z)
     myadel("myform:anotoday",z)
     myadel("myform:anotodaycircle",z)
     myadel("myform:aweeknumbers",z)
     myadel("myform:aaddress",z)
     myadel("myform:ahandcursor",z)
     myadel("myform:atabpage",z)
     myadel("myform:aname",z)
     myadel("myform:anumber",z)
     myadel("myform:aflat",z)
     myadel("myform:abuttons",z)
     myadel("myform:ahottrack",z)
     myadel("myform:adisplayedit",z)
     myadel("myform:Anodeimages",z)
     myadel("myform:Aitemimages",z )
     myadel("myform:ANorootbutton",z)
     myadel("myform:AItemids",z)
     myadel("myform:Anovscroll",z)
     myadel("myform:Anohscroll",z)
     myadel("myform:Adynamicbackcolor",z)
     myadel("myform:Adynamicforecolor",z)
     myadel("myform:Acolumncontrols",z)
     myadel("myform:Aoneditcell",z)
     myadel("myform:Aonappend",z)
     myadel("myform:Ainplace",z)
     myadel("myform:Aedit",z)
     myadel("myform:Aappend",z)
     myadel("myform:Aclientedge",z)
     myadel("myform:afocusedpos",z)  // pb

     myadel("myform:aspeed",z)
     :ncontrolw--
     if :ncontrolw=1
        myhandle:=0
        nhandlep:=0
     endif
  endif
  end
return
*----------------------------------
static function myadel(arreglo,z)
*----------------------------------
q:=z
adel(&arreglo,q)
asize(&arreglo,len(&arreglo)-1)
return nil

*---------------------
static function ms( myIde )
*---------------------
local i,ocontrol,jk,nl
jk:=myhandle
if swcursor=1
   if jk>0
      nl:=0
      for i:=1 to len(getformobject('Form_1'):acontrols)
          if lower(getformobject('Form_1'):acontrols[i]:name)= lower(myform:aname[jk])
             nl:=i
             exit
          endif
      next i
      if nl=0
         return nil
      endif
      ocontrol:=getformobject('Form_1'):acontrols[nl]
************************
   nRowAnterior := GetWindowRow( oControl:hWnd )
   ncolAnterior := GetWindowcol( oControl:hWnd )
   myinteractivemovehandle(ocontrol:hwnd)

   myform:lfsave:=.F.
   CHideControl (ocontrol:hwnd)
   nRowActual   := GetWindowRow( oControl:hWnd )
   ncolActual   := GetWindowcol( oControl:hWnd )
   oControl:Row := oControl:Row + ( nRowActual - nRowAnterior )
   oControl:col := oControl:col + ( ncolActual - ncolAnterior )

   if myIde:lsnap=1
      snap(ocontrol:name)
   endif
***********************
   myform:lfsave:=.F.

   CShowControl (ocontrol:hwnd)

   swcursor=0
   controlname:=lower(ocontrol:name)
   cvc:=ascan(myform:acontrolw,{  |c| lower( c ) == controlname } )
   if cvc>0
      if myform:atabpage[cvc,2] # NIL
         if myform:atabpage[cvc,2] >0
            cnombretab:=myform:atabpage[cvc,1]
            getcontrolobject(cnombretab,"form_1"):show()
         endif
      endif
      dibuja( ocontrol:name )
    endif
    endif
endif
if swcursor=2
   if jk>0
**********
         nl:=0
         for i:=1 to len(getformobject('Form_1'):acontrols)
             if lower(getformobject('Form_1'):acontrols[i]:name)== lower(myform:aname[jk])
                nl:=i
                exit
             endif
         next i
         if nl=0
            return nil
         endif
         ocontrol:=getformobject('Form_1'):acontrols[nl]
         cname:=lower(ocontrol:name)
         nheight:= ocontrol:height
         nwidth := ocontrol:width
*********
      interactivesizehandle(ocontrol:hwnd)
      CHideControl (ocontrol:hwnd)

      if (.not. siesdeste(nl,'RADIOGROUP') .and. .not. siesdeste(nl,'COMBO'))
         nheighta:= GetWindowHeight ( ocontrol:hwnd )
         nwidtha:= GetWindowwidth ( ocontrol:hwnd )
         ocontrol:Width := nwidtha
         ocontrol:Height := nheighta
      else
          nwidtha:= GetWindowwidth ( ocontrol:hwnd )
          ocontrol:Width := nwidtha    /// nuevo valor
          ocontrol:Height:= nheight    /// viejo valor
      endif
     myform:lfsave:=.F.
     CShowControl (ocontrol:hwnd)
     swcursor=0
     controlname:=lower(cname)
     cvc:=ascan( myform:acontrolw, { |c| lower( c ) == controlname } )
     if cvc>0
        if myform:atabpage[cvc,2] # NIL
           if myform:atabpage[cvc,2] >0
              cnombretab:=myform:atabpage[cvc,1]
              getcontrolobject(cnombretab,"form_1"):show()
           endif
        endif
        dibuja( ocontrol:name )
     endif
   endif
endif
return nil

*------------------------------------------------------------------------------*
METHOD AddControl() CLASS TForm1
*------------------------------------------------------------------------------*
local aName,x,i,swborrado
with Object myform
        swkm:=.F.
   Do Case
        Case :currentcontrol == 1
***************
             x:=chiffram()
             if x>0
                dibuja1(x)
                return
             endif
   Case :currentcontrol == 2
      :ButtonCount++
      ControlName := 'button_'+Alltrim(str(:ButtonCount))
                do while iscontroldefined(&Controlname,form_1)
              :ButtonCount++
                   ControlName := 'button_'+Alltrim(str(:Buttoncount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'BUTTON')
                :aaction[:ncontrolw]:="msginfo('Button pressed')"
      @ _oohg_mouserow,_oohg_mousecol BUTTON &ControlName OF Form_1  FONT 'MS Sans Serif' SIZE 10 ON GOTFOCUS dibuja(this:name) NOTABSTOP
                :abackcolor[:ncontrolw]:=cfbackcolor
      ProcessContainers( ControlName )
   Case :currentcontrol == 3
      :CheckBoxCount++
      ControlName := 'checkbox_'+Alltrim(str(:CheckBoxCount))
                do while iscontroldefined(&Controlname,form_1)
              :CheckBoxCount++
                   ControlName := 'checkbox_'+Alltrim(str(:CheckBoxCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol CHECKBOX &ControlName OF Form_1 CAPTION ControlName FONT 'San serif' SIZE 10 ;
                ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'CHECKBOX')
                :abackcolor[:ncontrolw]:=cfbackcolor
                if cfbackcolor#'NIL'
                   getcontrolobject(controlname,"form_1"):backcolor:= &cfbackcolor
                endif
      ProcessContainers( ControlName )
   Case :currentcontrol == 4
      :ListBoxCount++
      ControlName := 'list_'+Alltrim(str(:ListBoxcount))
                do while iscontroldefined(&Controlname,form_1)
             :ListBoxCount++
                   ControlName := 'list_'+Alltrim(str(:ListBoxCount))
                enddo
      aName := { ControlName }
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LISTBOX &ControlName OF Form_1 WIDTH 100 HEIGHT 100 ITEMS aName FONT 'MS Sans Serif' SIZE 10 ;
                ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'LIST')
      ProcessContainers( ControlName )
   Case :currentcontrol == 5
      :ComboBoxCount++
      ControlName := 'combo_'+Alltrim(str(:ComboBoxCount))
                do while iscontroldefined(&Controlname,form_1)
                    :ComboBoxCount++
                   ControlName := 'combo_'+Alltrim(str(:ComboboxCount))
                enddo
      aName := { ControlName,' ' }
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol COMBOBOX &ControlName OF Form_1 WIDTH 100 HEIGHT 100 ITEMS aName VALUE 1 FONT 'San serif' SIZE 10 ;
                ON GOTFOCUS dibuja(this:name) NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'COMBO')
      ProcessContainers( ControlName )
   Case :currentcontrol == 6
      :CheckButtonCount++

      ControlName := 'checkbtn_'+Alltrim(str(:CheckButtonCount))
                do while iscontroldefined(&Controlname,form_1)
         :CheckButtonCount++
                   ControlName := 'checkbtn_'+Alltrim(str(:CheckbuttonCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol CHECKBUTTON &ControlName OF Form_1 CAPTION ControlName FONT 'MS Sans Serif' SIZE 10 ;
                ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'CHECKBTN')
      ProcessContainers( ControlName )
   Case :currentcontrol == 7
      :GridCount++
      ControlName := 'grid_'+Alltrim(str(:GridCount))
                do while iscontroldefined(&Controlname,form_1)
            :GridCount++
                   ControlName := 'grid_'+Alltrim(str(:GridCount))
                enddo
      aName := { { ControlName ,''} }
                     :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'GRID')
      @ _oohg_mouserow,_oohg_mousecol GRID &ControlName OF Form_1 HEADERS {'',''} WIDTHS {60,60} ITEMS aName TOOLTIP 'To move/size click on header area' FONT 'MS Sans Serif' SIZE 10 ;
                ON GOTFOCUS dibuja(this:name)
      ProcessContainers( ControlName )
   Case :currentcontrol == 8
      :frameCount++
      ControlName := 'frame_'+Alltrim(str(:FrameCount))
                do while iscontroldefined(&Controlname,form_1)
         :frameCount++
                   ControlName := 'frame_'+Alltrim(str(:FrameCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'FRAME')
      @ _oohg_mouserow, _oohg_mousecol FRAME &ControlName OF Form_1 CAPTION ControlName WIDTH 140 HEIGHT 140  FONT 'MS Sans Serif' SIZE 10
                :abackcolor[:ncontrolw]:=cfbackcolor
                if cfbackcolor#'NIL'
                   getcontrolobject(controlname,"form_1"):backcolor:= &cfbackcolor
                endif
      ProcessContainers( ControlName )
   Case :currentcontrol == 9
      :TabCount++
      ControlName := 'tab_'+Alltrim(str(:TabCount))
                do while iscontroldefined(&Controlname,form_1)
                   :TabCount++
                   ControlName := 'tab_'+Alltrim(str(:TabCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'TAB')
      DEFINE TAB &ControlName OF Form_1 AT _oohg_mouserow,_oohg_mousecol WIDTH 300 HEIGHT 250 FONT 'MS Sans Serif' SIZE 10 TOOLTIP Controlname ON CHANGE dibuja(this:name)
         DEFINE PAGE 'Page 1' IMAGE ' '
         END PAGE
         DEFINE PAGE 'Page 2' IMAGE ' '
                        END PAGE
      END TAB
***               :atabpage[:ncontrolw,2]=NIL
                :acaption[:ncontrolw]="{'Page 1','Page 2'}"
                :aimage[:ncontrolw]="{' ',' '}"
                :swtab:=.T.
   Case :currentcontrol == 10
      :ImageCount++
      ControlName := 'image_'+Alltrim(str(:ImageCount))
                do while iscontroldefined(&Controlname,form_1)
         :ImageCount++
                   ControlName := 'image_'+Alltrim(str(:ImageCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'IMAGE')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 100 VALUE ControlName BORDER ACTION dibuja(this:name) FONT 'MS Sans Serif' SIZE 10

      ProcessContainers( ControlName )
   Case :currentcontrol == 11
      :AnimateCount++
      ControlName := 'animate_'+Alltrim(str(:AnimateCount))
                do while iscontroldefined(&Controlname,form_1)
                   :AnimateCount++
                   ControlName := 'animate_'+Alltrim(str(:AnimateCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'ANIMATE')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 50 VALUE ControlName BORDER ACTION dibuja(this:name) FONT 'MS Sans Serif' SIZE 10
      ProcessContainers( ControlName )
   Case :currentcontrol == 12
      :DatePickerCount++
      ControlName := 'datepicker_'+Alltrim(str(:DatePickerCount))
                do while iscontroldefined(&Controlname,form_1)
            :DatePickerCount++
                   ControlName := 'datepicker_'+Alltrim(str(:DatePickerCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'DATEPICKER')
      @ _oohg_mouserow,_oohg_mousecol DATEPICKER &ControlName OF Form_1 TOOLTIP ControlName FONT 'MS Sans Serif' SIZE 10 ;
                ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
      ProcessContainers( ControlName )
   Case :currentcontrol == 13
      :TextBoxCount++
      ControlName := 'text_'+Alltrim(str(:TextBoxCount))
                do while iscontroldefined(&Controlname,form_1)
              :TextBoxCount++
                   ControlName := 'text_'+Alltrim(str(:TextBoxcount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 24 BACKCOLOR WHITE CLIENTEDGE ACTION dibuja(this:name) FONT 'San serif' SIZE 10
                getcontrolobject(controlname,"form_1"):value:=controlname
                :iniarray(:nform,:ncontrolw,controlname,'TEXT')
      ProcessContainers( ControlName )
   Case :currentcontrol == 14
      :EditBoxCount++
      ControlName := 'edit_'+Alltrim(str(:EditBoxCount))
                do while iscontroldefined(&Controlname,form_1)
           :EditBoxCount++
                    ControlName := 'edit_'+Alltrim(str(:EditBoxcount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 120 VALUE ControlName BACKCOLOR WHITE CLIENTEDGE HSCROLL VSCROLL ACTION dibuja(this:name)
                getcontrolobject(controlname,"form_1"):fontname:='MS Sans Serif'
                getcontrolobject(controlname,"form_1"):fontsize:=10
                :iniarray(:nform,:ncontrolw,controlname,'EDIT')
      ProcessContainers( ControlName )
   Case :currentcontrol == 15
                :LabelCount++
      ControlName := 'label_'+Alltrim(str(:LabelCount))
                do while iscontroldefined(&Controlname,form_1)
                   :LabelCount++
                   ControlName := 'label_'+Alltrim(str(:LabelCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 VALUE ControlName  ACTION dibuja(this:name) FONT 'MS Sans Serif' SIZE 10
                getcontrolobject(controlname,"form_1"):value:= "Empty label"
                :iniarray(:nform,:ncontrolw,controlname,'LABEL')
                :abackcolor[:ncontrolw]:=cfbackcolor
                if cfbackcolor#'NIL'
                   getcontrolobject(controlname,"form_1"):backcolor:= &cfbackcolor
                endif
      ProcessContainers( ControlName )
   Case :currentcontrol == 16
      :PlayerCount++
      ControlName := 'player_'+Alltrim(str(:PlayerCount))
                do while iscontroldefined(&Controlname,form_1)
                    :PlayerCount++
                   ControlName := 'player_'+Alltrim(str(:PlayerCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 100 VALUE ControlName BORDER ACTION dibuja(this:name) FONT 'MS Sans Serif' SIZE 10
                :iniarray(:nform,:ncontrolw,controlname,'PLAYER')
      ProcessContainers( ControlName )
   Case :currentcontrol == 17
      :ProgressBarCount++
      ControlName := 'progressbar_'+Alltrim(str(:ProgressBarCount))
                do while iscontroldefined(&Controlname,form_1)
                  :ProgressBarCount++
                   ControlName := 'progressbar_'+Alltrim(str(:ProgressBarCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 26 VALUE Controlname BORDER ACTION dibuja(this:name)
                :iniarray(:nform,:ncontrolw,controlname,'PROGRESSBAR')
      ProcessContainers( ControlName )
   Case :currentcontrol == 18
      :RadioGroupCount++
      ControlName := 'radiogroup_'+Alltrim(str(:RadioGroupCount))
                do while iscontroldefined(&Controlname,form_1)
         :RadioGroupCount++
                   ControlName := 'radiogroup_'+Alltrim(str(:RadioGroupCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 25*2+8 VALUE ControlName BORDER ACTION dibuja(this:name) FONT 'MS Sans Serif' SIZE 10
                :iniarray(:nform,:ncontrolw,controlname,'RADIOGROUP')
                :abackcolor[:ncontrolw]:=cfbackcolor
                if cfbackcolor#'NIL'
                   getcontrolobject(controlname,"form_1"):backcolor:= &cfbackcolor
                endif
                :aitems[:ncontrolw]:="{'option 1','option 2'}"
                :aspacing[:ncontrolw]:=25
      ProcessContainers( ControlName )
   Case :currentcontrol == 19
      :SliderCount++
      ControlName := 'slider_'+Alltrim(str(:SliderCount))
                do while iscontroldefined(&Controlname,form_1)
         :SliderCount++
                   ControlName := 'slider_'+Alltrim(str(:SliderCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol SLIDER &ControlName OF Form_1 RANGE 1,10 VALUE 5 ON CHANGE dibuja(this:name) NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'SLIDER')
                :abackcolor[:ncontrolw]:=cfbackcolor
                if cfbackcolor#'NIL'
                   getcontrolobject(controlname,"form_1"):backcolor:= &cfbackcolor
                endif
      ProcessContainers( ControlName )
   Case :currentcontrol == 20
      :SpinnerCount++
      ControlName := 'spinner_'+Alltrim(str(:SpinnerCount))
                do while iscontroldefined(&Controlname,form_1)
         :SpinnerCount++
                   ControlName := 'spinner_'+Alltrim(str(:SpinnerCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 24 VALUE ControlName BACKCOLOR WHITE CLIENTEDGE VSCROLL ACTION dibuja(this:name)
                getcontrolobject(controlname,"form_1"):fontname:= 'MS Sans Serif'
                getcontrolobject(controlname,"form_1"):fontsize:= 10
                :iniarray(:nform,:ncontrolw,controlname,'SPINNER')
      ProcessContainers( ControlName )
   Case :currentcontrol == 21
      :CheckButtonCount++
      ControlName := 'piccheckbutt_'+Alltrim(str(:CheckButtonCount))
                do while iscontroldefined(&Controlname,form_1)
         :CheckButtonCount++
                   ControlName := 'piccheckbutt_'+Alltrim(str(:CheckButtonCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol CHECKBUTTON &ControlName OF Form_1 PICTURE 'A4' WIDTH 30 HEIGHT 30 VALUE .F. ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'PICCHECKBUTT')
      ProcessContainers( ControlName )
   Case :currentcontrol == 22
      :ButtonCount++
      ControlName := 'picbutt_'+Alltrim(str(:ButtonCount))
                do while iscontroldefined(&Controlname,form_1)
         :ButtonCount++
                   ControlName := 'picbutt_'+Alltrim(str(:ButtonCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'PICBUTT')
                :aaction[:ncontrolw]:="msginfo('Pic button pressed')"
      @ _oohg_mouserow,_oohg_mousecol BUTTON &ControlName OF Form_1 PICTURE 'A4' WIDTH 30 HEIGHT 30 ON GOTFOCUS dibuja(this:name) NOTABSTOP
      ProcessContainers( ControlName )
         Case :currentcontrol == 23
      :TimerCount++
      ControlName := 'timer_'+Alltrim(str(:timerCount))
                do while iscontroldefined(&Controlname,form_1)
         :timerCount++
                   ControlName := 'timer_'+Alltrim(str(:timerCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'TIMER')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 20 VALUE ControlName BORDER ACTION dibuja(this:name) FONT 'MS Sans Serif' SIZE 10
      ProcessContainers( ControlName )
   Case :currentcontrol == 24
      :BrowseCount++
         ControlName := 'browse_'+Alltrim(str(:browseCount))
                do while iscontroldefined(&Controlname,form_1)
            :browseCount++
                   ControlName := 'browse_'+Alltrim(str(:browseCount))
                enddo
      aName := { { ControlName ,''} }
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'BROWSE')
      @ _oohg_mouserow,_oohg_mousecol GRID &ControlName OF Form_1 HEADERS {'one','two'} WIDTHS {60,60} ITEMS aName TOOLTIP 'To move/size click on header area' FONT 'MS Sans Serif' SIZE 10 ON GOTFOCUS dibuja(this:name)
      ProcessContainers( ControlName )
   Case :currentcontrol == 25
      :TreeCount++
         ControlName := 'tree_'+Alltrim(str(:treecount))
                do while iscontroldefined(&Controlname,form_1)
            :treecount++
                   ControlName := 'tree_'+Alltrim(str(:treeCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'TREE')

                DEFINE TREE &ControlName OF Form_1 AT _oohg_mouserow,_oohg_mousecol  WIDTH 100 HEIGHT 100 VALUE 1 ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name)
                   NODE 'Tree'
              END NODE
                   NODE 'Nodes'
              END NODE
                END TREE

      ProcessContainers( ControlName )
   Case :currentcontrol == 26
      :IpaddressCount++
         ControlName := 'ipaddress_'+Alltrim(str(:ipaddressCount))
                do while iscontroldefined(&Controlname,form_1)
         :ipaddressCount++
                   ControlName := 'ipaddress_'+Alltrim(str(:ipaddressCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'IPADDRESS')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 VALUE '   .   .   .   ' BACKCOLOR WHITE CLIENTEDGE ACTION dibuja(this:name) FONT 'Courier new' SIZE 9
      ProcessContainers( ControlName )
        Case :currentcontrol == 27
      :MonthcalendarCount++
         ControlName := 'monthcal_'+Alltrim(str(:monthcalendarCount))
                do while iscontroldefined(&Controlname,form_1)
            :monthcalendarCount++
                   ControlName := 'monthcal_'+Alltrim(str(:monthcalendarCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'MONTHCALENDAR')
      @ _oohg_mouserow,_oohg_mousecol MONTHCALENDAR &ControlName OF Form_1  NOTABSTOP ON CHANGE dibuja(this:name)
      ProcessContainers( ControlName )
        Case :currentcontrol == 28
      :hyperlinkCount++
         ControlName := 'Hyperlink_'+Alltrim(str(:HyperlinkCount))
                Do while iscontroldefined(&Controlname,form_1)
         :hyperlinkCount++
                   ControlName := 'Hyperlink_'+Alltrim(str(:HyperlinkCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'HYPERLINK')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 VALUE Controlname ACTION dibuja(this:name) BORDER FONT 'MS Sans Serif' SIZE 9
      ProcessContainers( ControlName )
        case :currentcontrol ==29
           :richeditBoxCount++
      ControlName := 'richeditbox_'+Alltrim(str(:richeditboxCount))
                do while iscontroldefined(&Controlname,form_1)
              :richeditBoxCount++
                   ControlName := 'richeditbox_'+Alltrim(str(:richeditboxcount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 124 BACKCOLOR WHITE CLIENTEDGE ACTION dibuja(this:name) FONT 'MS Sans Serif' SIZE 10
                getcontrolobject(controlname,"form_1"):value:= controlname
                :iniarray(:nform,:ncontrolw,controlname,'RICHEDIT')
      ProcessContainers( ControlName )
   EndCase
           :control_click(1)
           :lFsave:=.F.

           mispuntos()
           muestrasino()
end
Return
*------------------------
function borracon( )    /////// para futuro uso
*------------------------
local i,cvalor,j
local owindow:=getformobject('Form_1')
local back:= owindow:backcolor
for i:= 2 to myform:ncontrolw
    cvalor:=lower(myform:acontrolw[i])
    j:=Ascan( getformobject('Form_1'):aControls, { |o| lower(o:Name) == cValor } )
    y:= owindow:acontrols[j]:row
    x:= owindow:acontrols[j]:col
    w:= owindow:acontrols[j]:width
    h:= owindow:acontrols[j]:height

    DRAW RECTANGLE IN WINDOW form_1 AT y - 10, x -10 ;
     TO y +h+6 , x +w +6  ;
     PENCOLOR back  FILLCOLOR back

     CShowControl (owindow:acontrols[j]:hwnd )
next i
return nil

*------------------------
function dibuja(xName)
*------------------------
local  cValor:= lower(xName)
dibuja1(Ascan( getformobject('Form_1'):aControls, { |o| lower(o:Name) == cValor } ) )
return nil

*--------------------
function dibuja1(h)
*--------------------
local l,ocontrol,owindow,nrow,ncol,nwidth,nheight,clabel,y,x,y1,x1
local z:=h

owindow:=getformobject('Form_1')
erase window form_1
mispuntos()                  //// dibuja puntos
ocontrol:= owindow:acontrols[z]
y :=  ocontrol:containerrow
x :=  ocontrol:containercol
y1:=  ocontrol:containerrow + ocontrol:height
x1:=  ocontrol:containercol + ocontrol:width

DRAW RECTANGLE IN WINDOW form_1 AT ocontrol:containerrow-10, ocontrol:containercol-10 ;
     TO ocontrol:containerrow, ocontrol:containercol ;
     PENCOLOR { 255 ,0 , 0 }  FILLCOLOR {255,0,0}

DRAW RECTANGLE IN WINDOW form_1 AT ocontrol:containerrow + ocontrol:height+1, ocontrol:containercol + ocontrol:width+1 ;
     TO ocontrol:containerrow + ocontrol:height+6, ocontrol:containercol + ocontrol:width+6 ;
     PENCOLOR { 255 ,0 , 0 }  FILLCOLOR {255,0,0}


DRAW LINE IN WINDOW form_1 AT y-1 ,x-1  ;
     TO  y-1  + ocontrol:height +1 ,x -1   PENCOLOR { 255 ,0 , 0 }    /// |

DRAW LINE IN WINDOW form_1 AT y-1,x-1 ;
     TO  y -1  , x-1 + ocontrol:width+1   PENCOLOR { 255 ,0 , 0 }    ///  -

DRAW LINE IN WINDOW form_1 AT y-1 + ocontrol:height+1 , x-1  ;      ////   -
     TO  y1,x1+1    PENCOLOR { 255 ,0 , 0 }

DRAW LINE IN WINDOW form_1 AT y-1 , x-1+ ocontrol:width+1 ;         ////   |
     TO  y1+1,x1   PENCOLOR { 255 ,0 , 0 }

l:=ascan( myform:acontrolw, { |c| lower( c ) == lower(ocontrol:name)  } )

if l>0
   form_main:frame_2:caption := "Control : "+  myform:aname[l]    /////+space(20)
   form_main:frame_2:refresh()

/////////// Mostrar cordenadas control actual
   nrow:=ocontrol:row
   ncol:=ocontrol:col
   nwidth:=ocontrol:width
   nheight:=ocontrol:height
   clabel:="r:"+alltrim(str(nrow,4))+" c:"+alltrim(str(ncol,4))+" w:"+alltrim(str(nwidth,4))+" h:"+alltrim(str(nheight,4))
   form_main:label_2:value :=clabel
//////////
   nhandlep:=z
else
   nhandlep:=0
   myhandle:=0
   form_main:label_2:value:= 'r:    c:    w:    h: '
endif
return nil

*------------------------------------------------------------------------------*
METHOD  Open(cItem1)  CLASS TForm1
*-----------------------------------------------------------------------------*
local i,nContlin,nPosilin,cForma
cForma:=memoread(cItem1)
nContlin:=mlcount(Cforma)

For i:=1 to nContlin
    aAdd(myform:aline,memoline(Cforma,800,i))
    if myform:aline[i]# NIL
       if at("DEFINE WINDOW",myform:aline[i])#0 .OR. ( at("@ ",myform:aline[i]) > 0 .AND. AT(",",myform:aline[i])>0  )
       ////////// .and. (.not. at("@E",myform:aline[i]) > 0  )
          myform:ncontrolw++
*** ojo aqui
         IF at("WINDOW",myform:aline[i]) > 0
            if at("WINDOW",myform:aline[i]) > 0
                nPoscor:=at("WINDOW",myform:aline[i])+7
            endif
         ELSE
            nPoscor1:=at(',',myform:aline[i]) +1
            For q:=nposcor1 to len(myform:aline[i])
                if asc(substr(myform:aline[i],q,1))>=65
                   nposcor2:=q
                   **** q:=len(myform:aline[i])
                   exit
                endif
            next q
            For q:=nposcor2 to len(myform:aline[i])
                if substr(myform:aline[i],q,1)=" "
                   nposcor:=q
                   exit
                endif
            next q

         ENDIF
        nLenlin:=len(trim(myform:aline[i]))
        cvcControl:=substr(rtrim(myform:aline[i]),nPoscor,nLenlin)
        cvccontrol:=strtran(cvccontrol,";","")
        cvccontrol:=strtran(cvccontrol,chr(10),"")
        cvccontrol:=strtran(cvccontrol,chr(13),"")
        cvccontrol:=strtran(cvccontrol," ","")

        myform:iniarray(myform:nform,myform:ncontrolw,cvccontrol,'')
        myform:aspeed[myform:ncontrolw]:=i
       ENDIF
    else
        exit
    endif
next i
For i:=1 to (myform:ncontrolw - 1)
    myform:anumber[i]:=myform:aspeed[i+1]-1
next i
myform:anumber[myform:ncontrolw]:=ncontlin
myform:newagain()
return nil


*------------------------------------------------------------------------------*
METHOD New() CLASS TForm1
*------------------------------------------------------------------------------*
whlp:='formedit'
   if .not. IsWindowDefined(Form_1)
           cfbackcolor:=myform:cfbackcolor

                   DEFINE WINDOW Form_1 obj Form_1 ;
         AT ::myIde:mainheight + 46 ,66 ;
         WIDTH 700 ;
         HEIGHT 410 ;
         TITLE 'Form' ICON 'VD' ;
         CHILD ;
         ON MOUSECLICK myform:AddControl() ;
                        ON MOUSEMOVE cordenada() ;
                        ON MOUSEDRAG ms( ::myIde ) ;
                        ON GOTFOCUS mispuntos() ;
                        ON PAINT {|| refrefo(), mispuntos() } ;
                        BACKCOLOR &cfbackcolor ;
                        FONT 'MS Sans Serif' SIZE 10   ;
                        NOMAXIMIZE NOMINIMIZE

         DEFINE CONTEXT MENU
                  ITEM 'Properties' ACTION Properties_Click( ::myIde )
                                ITEM 'Events    ' name events ACTION Events_click( ::myIde )
                                ITEM 'Interactive Font/Color' ACTION intfoco( 1, ::myIde )
                                ITEM 'Manual Move/Size'  ACTION manualmosi( 1, ::myIde )
            ITEM 'Interactive Move' ACTION MoveControl( ::myIde )
            ITEM 'Keyboard Move' ACTION kMove( ::myIde )
            ITEM 'Interactive Size' ACTION SizeControl()
                                SEPARATOR
                                ITEM 'Delete' ACTION DeleteControl()
         END MENU


                        ON KEY DELETE ACTION deletecontrol()
                        ON KEY F1 ACTION help_f1('FORMEDIT')
                        ON KEY ALT+D ACTION debug()

      END WINDOW

                DEFINE WINDOW lista obj lista ;
                AT 120 , 665 ;                                                 // MigSoft
                WIDTH 285 ;
                HEIGHT 450 + GetTitleHeight() + GetBorderheight() ;
                TITLE 'Control Inspector' ;
                ICON 'Edit' ;
                CHILD ;
                NOMAXIMIZE NOMINIMIZE ;
                NOSIZE ;
                backcolor ::myIde:asystemcolor


                @ 20,10 GRID listacon obj olistacon ;                          // MigSoft
                 WIDTH  260 ;
                 HEIGHT 400  ;
                 headers {'Name','row','col','width','height','int-name'}     ;
                 WIDTHS {80,40,40,45,50,0 } ;
                 FONT "Arial" ;
                 SIZE 10      ;
                 INPLACE EDIT ;
                 readonly {.t.,.f.,.f.,.f.,.f.,.t.}  ;
                 justify { ,1,1,1,1,  }  ;
                 ON GOTFOCUS muestrasino() ;
                 ON EDITCELL validapos(olistacon)

        ////            ON CHANGE procesacontrol() ;           ///cvc

                 olistacon:fullmove:=.T.


         DEFINE CONTEXT MENU
                  ITEM 'Properties' ACTION Properties_Click( ::myIde )
                                ITEM 'Events    ' name events ACTION Events_click( ::myIde )
                                ITEM 'Interactive Font/Color' ACTION intfoco( 1, ::myIde )
                                ITEM 'Manual Move/Size'  ACTION manualmosi( 1, ::myIde )
            ITEM 'Interactive Move' ACTION MoveControl( ::myIde )
            ITEM 'Keyboard Move' ACTION kMove( ::myIde )
            ITEM 'Interactive Size' ACTION SizeControl()
                                SEPARATOR
                                ITEM 'Delete' ACTION DeleteControl()
         END MENU

         @ 420,30 label lop value  "Right Click  -  click or enter to modify Cord" FONT "Calibri" SIZE 9 autosize
         @ 435,30 label lop1 value "More Options" FONT "Calibri" SIZE 9 autosize

           end window


          form_main:show()
          cvccontrols:show()


                ::myIde:form_activated:=.T.

////////// importante añadir el primer elemento
     myform:ncontrolw++
     myform:iniarray(myform:nform,myform:ncontrolw,"TEMPLATE",'FORM')
///     activate window form_1,lista
activate window lista nowait
activate window form_1

     EndIf
Return
*-----------------------------------
static function validapos(olistacon)
*-----------------------------------
wvalue:=this.cellrowindex
cname:=olistacon:cell(wvalue,6)
oname:=getcontrolobject(cname,"form_1")
nrow:=val(olistacon:cell(wvalue,2))
ncol:=val(olistacon:cell(wvalue,3))
nwidth:=val(olistacon:cell(wvalue,4))
nheight:=val(olistacon:cell(wvalue,5))
if this.cellcolindex=2
   oname:row:=nrow
endif
if this.cellcolindex=3
   oname:col:=ncol
endif
if this.cellcolindex=4
   oname:width:=nwidth
endif
if this.cellcolindex=5
   oname:height:=nheight
endif

procesacontrol()
dibuja(cname)           //////// cvc  2012/01/15
///muestrasino()
return nil

*-----------------------------------------------------------------------------
METHOD Newagain() CLASS TForm1
*------------------------------------------------------------------------------*
whlp:='formedit'
if  IsWindowDefined(Form_1)
    msginfo('only one Form can be edited at the same time','Information')
else
    myform:fillcontrolaux()
    cffontname:=myform:cffontname
    nffontsize:=myform:nffontsize
    cfbackcolor:=myform:cfbackcolor
    cursorwait()
    waitmess:hmi_label_101:value:='Loading Form....'
    waitmess:show()


    if myform:nfvirtualw <= nfwidth
      nvw := NIL
    else
      nvw:= NIL  /////  myform:nfvirtualw
    endif

    if myform:nfvirtualh <= nfheight
       nvh := NIL
    else
       nvh := NIL  ////  myform:nfvirtualh
    endif

    DEFINE WINDOW Form_1 obj Form_1 AT ::myIde:mainheight + 42 , 66 ;
         WIDTH nfwidth ;
         HEIGHT nfheight ;
                        VIRTUAL WIDTH  nvw  ;
                        VIRTUAL HEIGHT nvh  ;
         TITLE 'Title' ;
                        ICON 'VD' ;
         CHILD NOSHOW  ;
         ON MOUSECLICK myform:AddControl()  ;
                        ON MOUSEMOVE cordenada() ;
                        ON MOUSEDRAG ms( ::myIde ) ;
                        ON GOTFOCUS mispuntos() ;
                        ON PAINT {|| refrefo(),mispuntos() } ;
                        BACKCOLOR &cfbackcolor ;
                        FONT cffontname ;
                        SIZE nffontsize ;
                        NOMAXIMIZE NOMINIMIZE


         DEFINE CONTEXT MENU
                  ITEM 'Properties' ACTION Properties_Click( ::myIde )
                                ITEM 'Events    ' name events ACTION Events_click( ::myIde )
                                ITEM 'Interactive Font/Color' ACTION intfoco( 1, ::myIde )
                                ITEM 'Manual Move/Size'  ACTION manualmosi( 1, ::myIde )
            ITEM 'Interactive Move' ACTION MoveControl( ::myIde )
            ITEM 'Keyboard Move' ACTION kMove( ::myIde )
            ITEM 'Interactive Size' ACTION SizeControl()
                                SEPARATOR
                                ITEM 'Delete' ACTION DeleteControl()
         END MENU



                        ON KEY ALT+D ACTION debug()
                        ON KEY DELETE ACTION deletecontrol()
                        ON KEY F1 ACTION help_f1('FORMEDIT')

    END WINDOW

    DEFINE WINDOW lista obj lista ;
        AT 120 , 665 ;                                             // MigSoft
        WIDTH 285 ;
        HEIGHT 450 + GetTitleHeight() + GetBorderheight() ;
        TITLE 'Control Inspector' ;
        ICON 'Edit' ;
        CHILD ;
        NOMAXIMIZE NOMINIMIZE ;
        NOSIZE ;
        backcolor ::myIde:asystemcolor

                 @ 20,10 GRID listacon  obj olistacon ;            // MigSoft
                 WIDTH  260 ;
                 HEIGHT 400  ;
                 headers {'Name','row','col','width','height','int-name'}     ;
                 WIDTHS {80,40,40,45,50,0 } ;
                 FONT "Arial" ;
                 SIZE 10      ;
                 INPLACE EDIT ;
                 readonly {.t.,.f.,.f.,.f.,.f.,.t.}  ;
                 justify { ,1,1,1,1,  }  ;
                 ON GOTFOCUS muestrasino()  ;
                 ON EDITCELL validapos(olistacon)

                 olistacon:fullmove:=.T.

      DEFINE CONTEXT MENU
               ITEM 'Properties' ACTION Properties_Click( ::myIde )
                        ITEM 'Events    ' name events ACTION Events_click( ::myIde )
                        ITEM 'Interactive Font/Color' ACTION intfoco( 1, ::myIde )
                        ITEM 'Manual Move/Size'  ACTION manualmosi( 1, ::myIde )
                   ITEM 'Interactive Move' ACTION MoveControl( ::myIde )
                        ITEM 'Keyboard Move' ACTION kMove( ::myIde )
         ITEM 'Interactive Size' ACTION SizeControl()
                        SEPARATOR
                        ITEM 'Delete' ACTION DeleteControl()
                END MENU

         @ 420,30 label lop value "Right Click  -  click or enter to modify Cord" FONT "Calibri" SIZE 9 autosize
         @ 435,30 label lop1 value "More Options" FONT "Calibri" SIZE 9 autosize

    end window

    form_main:show()
    cvccontrols:show()

    ::myIde:form_activated:=.T.
    myform:fillcontrol()
    muestrasino()
*********************************

    tmytoolb:abrir()
    zap
    ctitulo:='Toolbar'
    archivo:=myform:cfname+'.tbr'
    if file(archivo)
       append from &archivo
    endif

    tbparsea( tmytoolb )
    use
******************************
    Activate window form_1,lista

EndIf
Return  nil


*------------------------------------
METHOD fillcontrolaux() CLASS TForm1
*------------------------------------
Public nfwidth,nfheight
myform:cffontname:=myform:clean(myform:leadato('WINDOW','FONT','MS Sans Serif'))
myform:nffontsize:=val(myform:leadato('WINDOW','SIZE','10'))
myform:cfbackcolor:=myform:leadato('WINDOW','BACKCOLOR',::myIde:cdbackcolor)
/////form_1:backcolor:=&(myform:cfbackcolor)

nfwidth:=val(myform:leadato('WINDOW','WIDTH','640'))
nfheight:=val(myform:leadato('WINDOW','HEIGHT','480'))
myform:nfvirtualw:=val(myform:leadato('WINDOW','VIRTUAL WIDTH','0'))
myform:nfvirtualh:=val(myform:leadato('WINDOW','VIRTUAL HEIGHT','0'))
return

*---------------------------------
METHOD fillcontrol() CLASS TForm1
*---------------------------------
local i,ctipo
with Object myform
:swtab:=.F.
for i:=1 to len(:aline)
  if at(upper('DEFINE STATUSBAR'),upper(:aline[i]))#0
     :lsstat:=.T.
     form_main:butt_status:value:=.T.
     cvccontrols.control_30.visible:=.T.

     :cscaption:=:clean(:leadato('DEFINE STATUSBAR','STATUSITEM',''))
     :nswidth:=val(:leadato('DEFINE STATUSBAR','WIDTH','0'))
     :csaction:=:leadato('DEFINE STATUSBAR','ACTION','')
     :csicon:=:leadato('DEFINE STATUSBAR','ICON','')
     :lsflat:=:leadatologic('DEFINE STATUSBAR','FLAT','F')
     :lsraised:=:leadatologic('DEFINE STATUSBAR','RAISED','F')

     :lsflat:=iif(:lsflat='T',.T.,.F.)

     :lsraised:=iif(:lsraised='T',.T.,.F.)

     :cstooltip:=:leadato('DEFINE STATUSBAR','TOOLTIP','')
     :lsdate:=:leadatologic('DEFINE STATUSBAR','DATE','F')
     :lstime:=:leadatologic('DEFINE STATUSBAR','CLOCK','F')
     :lskeyboard:=:leadatologic('DEFINE STATUSBAR','KEYBOARD','F')

     :lsdate:=iif(:lsdate='T',.T.,.F.)
     :lstime:=iif(:lstime='T',.T.,.F.)
     :lskeyboard:=iif(:lskeyboard='T',.T.,.F.)
     exit
***********i:=len(:aline)+1
  else
     :lsstat:=.F.
     form_main:butt_status:value:=.F.
     cvccontrols.control_30.visible:=.F.
  endif
next i

for i:=1 to :ncontrolw
   if i==1
     ctipo:='FORM'
   else
     ctipo:=:leatipo(:aControlw[i])
   endif
do case
case ctipo=='DEFINE'
   :actrltype[i]:='STATUSBAR'
case ctipo=='FORM'
   pforma( i )
case ctipo=='BUTTON'
   pbutton( i, ::myIde )
case ctipo=="CHECKBOX"
   pcheckbox( i, ::myIde )
case ctipo=="LISTBOX"
   plistbox( i, ::myIde )
case ctipo=='COMBOBOX'
   pcombobox( i, ::myIde )
case ctipo='CHECKBTN'
   pcheckbtn( i, ::myIde )
case ctipo=='PICCHECKBUTT'
     ppiccheckbutt( i, ::myIde )
case ctipo=="PICBUTT"
   ppicbutt( i, ::myIde )
case ctipo=="IMAGE"
   pimage( i, ::myIde )
case ctipo=="ANIMATEBOX"
   panimatebox( i, ::myIde )
case ctipo="DATEPICKER"
   pdatepicker( i, ::myIde )
case ctipo='GRID'
   pgrid( i, ::myIde )
case ctipo='BROWSE'
   pbrowse( i, ::myIde )
case ctipo=='FRAME'
   pframe( i, ::myIde )
case ctipo=="TEXTBOX"
   ptextbox( i, ::myIde )
case ctipo=="EDITBOX"
   peditbox( i, ::myIde )
case ctipo='RADIOGROUP'
   pradiogroup( i, ::myIde )
case ctipo="PROGRESSBAR"
   pprogressbar( i, ::myIde )
case ctipo='SLIDER'
   pslider( i, ::myIde )
case ctipo='SPINNER'
   pspinner( i, ::myIde )
case ctipo="PLAYER"
   pplayer( i, ::myIde )
case ctipo=='LABEL'
   plabel( i, ::myIde )
case ctipo="TIMER"
   ptimer( i, ::myIde )
case ctipo='IPADDRESS'
   pipaddress( i, ::myIde )
case ctipo='MONTHCALENDAR'
   pmonthcal( i, ::myIde )
case ctipo='HYPERLINK'
   phyplink( i, ::myIde )
case ctipo='TREE'
   ptree( i, ::myIde )
case ctipo='RICHEDITBOX'
   prichedit( i, ::myIde )
case ctipo='TAB'
   :swtab:=.T.
   ptab( i )
endcase
next i
close data
********************** toolbar
if file(:cfname+'.tbr')
   archivo:=:cfname+'.tbr'
   select 10
   use &archivo alias Dtoolbar
   nbuttons:=reccount()
   if  nbuttons>0
*****
   go 1
   Apar:={}
   wvar:=Dtoolbar->auxit
   nposi:=1
   nposf:=1
   if len(trim(wvar))=0
      wvar:='toolbar_1 ,   65 ,   65 ,  , .F. , .F. , .F. , .T. , Arial , 10 , .F. , .F. , .F. , .F. , 0 , 0 , 0'
   endif
   for i:=1 to len(wvar)
    if substr(wvar,i,1)=','
       nposf:=i
       aadd(Apar,ltrim(substr(wvar,nposi,nposf-nposi-1)))
       nposi:=nposf+1
    endif
   next i
   aadd(Apar,substr(wvar,nposi,6))
   nw:=val(apar[2])
   nh:=val(apar[3])

   tmytoolb:nwidth :=nw
   tmytoolb:nheight:=nh
   define toolbar hmitb of form_1  ;
   buttonsize nw, nh
   GO 1
   for i=1 to nbuttons

       wcaption:=ltrim(rtrim(dtoolbar->item))

       cname:="hmi_cvc_tb_button_"+alltrim(str(i,2) )
       button &cname  ;
       caption wcaption   ;
       action NIL
   skip
   next i
   END TOOLBAR
   USE
   endif
endif
define main menu of form_1
end menu
********************** carga menu
if file(:cfname+'.mnm')
   archivo:=:cfname+'.mnm'
   select 20
   use &archivo alias menues
   nbuttons:=reccount()
   swpop:=0
   if nbuttons>0
     go top
   DEFINE MAIN MENU of form_1
   do while .not. eof()
      if recn() < reccount()
         skip
         signiv:=level
         skip -1
      else
         signiv=0
      endif
      niv=level
      if ( signiv > level )
         if lower(trim(auxit))='separator'
            SEPARATOR
         else
            POPUP alltrim(auxit)
            swpop++
         endif
      else
         if lower(trim(auxit))='separator'
            SEPARATOR
         else
            ITEM  alltrim(auxit)  ACTION  NIL
            if trim(named)==''
            else
               if menues->checked='X'
                 /// cc:=:cfname+'.'+trim(named)+'.checked:=.T.'
                 /// output+= cc + CRLF
               endif
               if menues->enabled='X'
                  ///cc:=:cfname+'.'+trim(named)+'.enabled:=.F.'
                  ///output+= cc + CRLF
               endif
            endif
         endif
**********************************
         do while signiv<niv
            END POPUP
            swpop--
            niv--
         enddo
      endif
      skip
   enddo
   nnivaux:=niv-1
   do while swpop>0
      nnivaux--
      END POPUP
      swpop--
   enddo
   END MENU
   use
   endif
endif

*********************

waitmess:hide()
form_1:show()
if :lsstat

    DEFINE STATUSBAR of form_1
            if len(:cscaption)> 0
               STATUSITEM :cscaption
            else
               statusitem " "
            endif
            if :lskeyboard
               KEYBOARD
            endif
            if :lsdate
               DATE WIDTH 95
            endif
            if :lstime
               CLOCK WIDTH 85
            endif
   END STATUSBAR

endif
if :ncontrolw=1
   myhandle:=0
   nhandlep:=0
endif
form_main:show()
cvccontrols:show()
cursorarrow()
end
return nil

*---------------------------------------------------------
METHOD Control_Click(wpar) CLASS TForm1
*------------------------------------------------------------------------------*

if lsi
    for i:=1 to 29
        cccontrol:='Control_'+padl(ltrim(str(i,2)),2,'0')
        lsi:=.F.
        cvccontrols:&(cccontrol):value:=.F.
    next i
    myform:currentcontrol:=wpar
    cccontrol:='Control_'+padl(ltrim(str(wpar,2)),2,'0')
    lsi:=.F.
    cvccontrols:&(cccontrol):value:=.T.
else
   lsi:=.T.
endif

Return nil

*----------------------------------
METHOD leatipo(cname) CLASS TForm1
*----------------------------------
local q,r,s,nposcorq,nposa,cregresa,zl
cregresa:=''
***************
cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname)  } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))
**************
for q:=zi to zl
     s:=at(upper(cname)+' ',upper(myform:aline[q]))
     if s>0
        nposcorq:=s
        nPosa:=0
        for r:=1  to nposcorq
            if asc(substr(myform:aline[q],r,1))>=65
               cregresa:=alltrim(substr(myform:aline[q],r,nposcorq-r))
               exit
            endif
        next r
        exit
     endif
next q

if upper(cregresa)=='CHECKBUTTON'
   ctregresa:=myform:leadatologic(cname,'CAPTION','')
   if ctregresa='T'
      cregresa:='CHECKBTN'
   else
      cregresa:='PICCHECKBUTT'
   endif
endif
if upper(cregresa)=='BUTTON'
   ctregresa:=myform:leadatologic(cname,'CAPTION','')
   if ctregresa='T'
      cregresa:='BUTTON'
   else
      cregresa:='PICBUTT'
   endif
endif
return cregresa

*------------------------------------------------------
METHOD leadato(cName,cPropmet,cDefault) CLASS TForm1
*----------------------------------------------------
local i,sw,zi,cvc,zl,npos
sw:=0
cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname)  } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))

For i:=zi to zl

if at(upper(cname)+' ',upper(myform:aline[i]))#0 .and. sw=0  ///// ubica el control en la forma y a partir de ahi busca la propiedad
   sw:=1
else
   if sw==1
      if len(trim(myform:aline[i]))==0
         return cDefault
      endif
      npos:=at(upper(cPropmet)+' ',upper(myform:aline[i]) )

            if npos>0 .and. substr(myform:aline[i],npos-1,1)#"."
               cfvalue:=substr(myform:aline[i],npos+len(Cpropmet),500)
               cfvalue:=trim(cfvalue)
               cfvalue:=substr(cfvalue,1,len(cfvalue)-1)

               return alltrim(cfvalue)
            endif
   endif
endif
Next i
return cDefault
*--------------------------------------------------------
METHOD leadatostatus(cName,cPropmet,cDefault) CLASS TForm1
*---------------------------------------------------------
local i,sw,zi,cvc,zl
sw:=0
cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname)  } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))
For i:=zi to zl
if at(upper(cname)+' ',upper(myform:aline[i]))#0 .and. sw=0
   sw:=1
else
   if sw==1
      if len(trim(myform:aline[i]))==0
         return cDefault
      endif
      npos:=at(upper(cPropmet)+' ',upper(myform:aline[i]))

      if npos>0
         cfvalue:=substr(myform:aline[i],npos+len(Cpropmet),len(myform:aline[i]))
         cfvalue:=trim(cfvalue)
         cfvalue:=substr(cfvalue,1,len(cfvalue)-1)
         return alltrim(cfvalue)
      endif
   endif
endif
Next i
return cDefault

*----------------------------------------------------------
METHOD leadatologic(cName,cPropmet,cDefault) CLASS TForm1
*----------------------------------------------------------
local i,sw,zi,cvc,zl
sw:=0

cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname)  } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))
For i:=zi to zl
    if at(upper(cname)+' ',upper(myform:aline[i]))#0 .and. sw=0
       sw:=1
    else
       if sw==1

          if len(trim(myform:aline[i]))==0
             return cDefault
          endif
          if at(upper(cPropmet)+' ',upper(myform:aline[i]))>0
             return 'T'
          endif

       endif
    endif

Next i
return cDefault

*---------------------------------
METHOD learow(cName) CLASS TForm1
*---------------------------------
local i,npos,nrow,zi,zl
cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname)  } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))
For i:=zi to zl
    if at(upper(cname)+' ',upper(myform:aline[i]))#0
       npos:=at(",",myform:aline[i])
       nrow:=left(myform:aline[i],npos-1)
       nrow:=strtran(nrow,"@","")
       return nrow
    endif
Next i
return nrow

*------------------------------------
METHOD learowf(cname) CLASS TForm1
*-------------------------------------
local i,npos1,npos2,nrow,zi,zl
cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname)  } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))
For i:=zi to zl
    if at(upper('WINDOW')+' ',upper(myform:aline[i]))#0
       npos1:=at("AT",upper(myform:aline[i+1]))
       npos2:=at(",",myform:aline[i+1])
       nrow:=substr(myform:aline[i+1],npos1+3,len(myform:aline[i+1])-npos2)
       return nrow
    endif
Next i
return nrow

*-----------------------------------
METHOD leacol(cName) CLASS TForm1
*-----------------------------------
local i,npos,ncol,zi,zl
cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname) } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))
For i:=zi to zl
if at(upper(cname)+' ',upper(myform:aline[i]))#0
   npos:=at(",",myform:aline[i])
   ncol:=substr(myform:aline[i],npos+1,4)
   return ncol
endif
Next i
return ncol
*------------------------------------
METHOD leacolf(cname) CLASS TForm1
*------------------------------------
local i,npos,ncol,zi,zl
cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname)  } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))
For i:=zi to zl
if at(upper('WINDOW')+' ',upper(myform:aline[i]))#0
   npos:=at(",",myform:aline[i+1])
   ncol:=substr(myform:aline[i+1],npos+1,4)
   return ncol
endif
Next i
return ncol

*----------------------------------
METHOD clean(cfvalue) CLASS TForm1
*----------------------------------
cfvalue:=strtran(cfvalue,'"','')
cfvalue:=strtran(cfvalue,"'","")
return cfvalue

*---------------------------------------------------------
METHOD leadato_oop(cName,cPropmet,cDefault) CLASS TForm1
*---------------------------------------------------------
local i,mlyform,nposx,zi,zl,npos1,nd
nposx:=rat('.',myform:cform)
npos1:=rat('\',myform:cform)
nd:=1
if npos1=0
  npos1:=1
  nd:=0
endif
mlyform:=substr(myform:cform,npos1+nd,nposx-npos1-nd)
cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(cname)  } )
zi:=iif(cvc>0,myform:aspeed[cvc],1)
zl:=iif(cvc>0,myform:anumber[cvc],len(myform:aline))
For i:=zi to zl
if at(upper(mlyform)+'.'+upper(cname)+'.'+upper(cPropmet),upper(myform:aline[i]))>0
   npos=rat('=',myform:aline[i])+1
   return trim(substr(myform:aline[i],npos,len(myform:aline[i])))
endif
next i
return cdefault


*---------------------
function ntabpages(k)
*---------------------
local cname
if hb_isNumeric(k)
   cname:=myform:acontrolw[k]
endif
sw:=0
return nil

*----------------------
function mispuntos()
*----------------------
local hdc := HB_GetDC( Form_1:Hwnd )
local h := form_1:height
local w:=  form_1:width
local i,j

    FOR  i = 0 TO w STEP 10
        FOR j= 0 TO h STEP 10
            SetPixel(hDC, i,j,RGB(0,0,0))
        NEXT
    NEXT

HB_ReleaseDC( Form_1:Hwnd , hdc )


DRAW line IN WINDOW form_1 AT 480,1  TO 480,w  PENCOLOR { 255 ,0 , 0 }  penwidth 1  ///FILLCOLOR {255,0,0}
DRAW line IN WINDOW form_1 AT 600,1  TO 600,w   PENCOLOR { 255 ,0 , 0 }  penwidth 1  ///FILLCOLOR {255,0,0}
DRAW line IN WINDOW form_1 AT 1,640  TO h,640  PENCOLOR { 255 ,0 , 0 }  penwidth 1  /////FILLCOLOR {255,0,0}
DRAW line IN WINDOW form_1 AT 1,800  TO h,800   PENCOLOR { 255 ,0 , 0 }  penwidth 1  //// FILLCOLOR {255,0,0}
return nil

*------------------------
static function ptree( i, myIde )
*------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='TREE'
   myform:aname[i]:=cname

   ncol:=val(myform:leacol(cName))
   nrow:=val(myform:leadato(cname,'AT','100'))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',''))
   nfontsize:=val(myform:leadato(cname,'SIZE','10'))
   nwidth:=val(myform:leadato(cname,'WIDTH','120'))
   nheight:=val(myform:leadato(cname,'HEIGHT','24'))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))

   cnodeimages:=myform:leadato(cname,'NODEIMAGES',"")
   citemimages:=myform:leadato(cname,'ITEMIMAGES',"")
   lnorootbutton:=myform:leadatologic(cname,'NOROOTBUTTON',"F")
   litemids:=myform:leadatologic(cname,'ITEMIDS',"F")
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))

   conchange:=myform:leadato(cname,'ON CHANGE','')
   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   condblclick:=myform:leadato(cname,'ON DBLCLICK','')

   myform:anodeimages[i]:=cnodeimages
   myform:aitemimages[i]:=citemimages
   myform:anorootbutton[i]:=iif(lnorootbutton='T',.T.,.F.)
   myform:aitemids[i]:=iif(litemids='T',.T.,.F.)

   myform:ahelpid[i]:=nhelpid


   DEFINE TREE &cname of form_1 ;
   AT nrow , ncol ;
   WIDTH nwidth ;
   HEIGHT nheight    ;
   ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name)

   NODE 'Tree'
   END NODE
   NODE 'Nodes'
   END NODE

   END TREE

   oconrol:=getcontrolobject(cname,"form_1")

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
       form_1:&cname:fontname := cfontname
   else
       form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
      form_1:&cname:fontsize := nfontsize
   else
      form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))

   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor

   myform:atooltip[i]:=ctooltip
   form_1:&cname:tooltip:=ctooltip
   myform:aonchange[i]:=conchange
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aondblclick[i]:=condblclick

   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*-----------------------
static function ptab(i)
*-----------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='TAB'
   myform:aname[i]:=cname

   ncol:=val(myform:leacol(cName))
   nrow:=val(myform:leadato(cname,'AT','100'))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))  // MigSoft
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))      // MigSoft
   nwidth:=val(myform:leadato(cname,'WIDTH','120'))
   nheight:=val(myform:leadato(cname,'HEIGHT','24'))
   nvalue:=(myform:leadato(cname,'VALUE','0'))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   cimage:=myform:clean(myform:leadato(cname,'IMAGE',''))
   conchange:=myform:leadato(cname,'ON CHANGE','')
   lflat:=myform:leadatologic(cname,'FLAT',"F")
   lvertical:=myform:leadatologic(cname,'VERTICAL',"F")
   lbuttons:=myform:leadatologic(cname,'BUTTONS',"F")
   lhottrack:=myform:leadatologic(cname,'HOTTRACK',"F")

   DEFINE TAB &cname of form_1 ;
   AT nrow , ncol ;
   WIDTH nwidth ;
   HEIGHT nheight    ;
   TOOLTIP 'Properties and events right click on header area' ON CHANGE dibuja(this:name)

   END TAB

   if lflat='F'
      myform:aflat[i]:=.F.
   else
      myform:aflat[i]:=.T.
   endif
   if lvertical='F'
      myform:avertical[i]:=.F.
   else
      myform:avertical[i]:=.T.
   endif
   if lbuttons='F'
      myform:abuttons[i]:=.F.
   else
      myform:abuttons[i]:=.T.
   endif
   if lhottrack='F'
      myform:ahottrack[i]:=.F.
   else
      myform:ahottrack[i]:=.T.
   endif

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
      form_1:&cname:fontname := cfontname
   else
      form_1:&cname:fontname := myform:cffontname
   endif

   myform:afontsize[i]:=nfontsize
   if nfontsize>0
    form_1:&cname:fontsize := nfontsize
   else
     form_1:&cname:fontsize := myform:nffontsize
   endif

   myform:atooltip[i]:=ctooltip
   myform:aimage[i]:=cimage


   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   ocontrol:=getcontrolobject(cname,"form_1")

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)


   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)


  form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)


   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor


   myform:avalue[i]:=nValue
   myform:aonchange[i]:=conchange

   cuantospage(cname)

return
*-----------------------------
static function pipaddress( i, myIde )
*-----------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='IPADDRESS'
   myform:aname[i]:=myform:acontrolw[i]
   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   cfontname:=myform:clean(myform:leadato(cname,'FONT',''))
   nfontsize:=val(myform:leadato(cname,'SIZE','10'))
   nwidth:=val(myform:leadato(cname,'WIDTH','120'))
   nheight:=val(myform:leadato(cname,'HEIGHT','24'))
   cvalue:=myform:clean(myform:leadato(cname,'VALUE',''))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))

   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"F")

***   conenter:=myform:leadato(cname,'ON ENTER','')
   conchange:=myform:leadato(cname,'ON CHANGE','')
   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')

   @ nrow, ncol LABEL &Cname OF Form_1 VALUE '   .   .   .   ' BACKCOLOR WHITE CLIENTEDGE ACTION dibuja(this:name) FONT 'Courier new' SIZE 10

   myform:afontname[i]:=cfontname

   ocontrol:=getcontrolobject(cname,"form_1")

   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
      form_1:&cname:fontsize := nfontsize
   else
      form_1:&cname:fontsize := nffontsize
   endif

   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)


   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor

   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor


   myform:avalue[i]:=cValue
   myform:atooltip[i]:=ctooltip
   form_1:&cname:tooltip:=ctooltip
   myform:aonchange[i]:=conchange
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:ahelpid[i]:=nhelpid

   form_1:&cname:value := cvalue
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*--------------------------
static function ptimer( i, myIde )
*--------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='TIMER'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:leadato(cname,'ROW','0'))
   ncol:=val(myform:leadato(cname,'COL','0'))
   ninterval:=val(myform:leadato(cname,'INTERVAL','1000'))
   caction:=myform:leadato(cname,'ACTION','')
   @ nRow,nCol LABEL &CName OF Form_1 WIDTH 100 HEIGHT 20 VALUE CName BORDER ACTION dibuja(this:name)
   myform:avaluen[i]:=ninterval
   myform:aaction[i]:=caction
   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)

   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*-------------------------
static function pforma(i)
*-------------------------
   myform:actrltype[i]:='FORM'
   nfrow:=val(myform:learowf(myform:cfname))
   nfcol:=val(myform:leacolf(myform:cfname))
   ****
   myform:cftitle:=myform:clean(myform:leadato('DEFINE WINDOW','TITLE',''))
   nfwidth:=val(myform:leadato('DEFINE WINDOW','WIDTH','640'))
   nfheight:=val(myform:leadato('DEFINE WINDOW','HEIGHT','480'))+gettitleheight()

   myform:cfobj:=myform:leadato('DEFINE WINDOW','OBJ','')
   myform:cficon:=myform:clean(myform:leadato('WINDOW','ICON',''))

   myform:nfvirtualw:=val(myform:leadato('DEFINE WINDOW','VIRTUAL WIDTH','0'))
   myform:nfvirtualh:=val(myform:leadato('DEFINE WINDOW','VIRTUAL HEIGHT','0'))


   myform:lfmain:=myform:leadatologic('DEFINE WINDOW',"MAIN","")
   myform:lfchild:=myform:leadatologic('DEFINE WINDOW',"CHILD","")
   myform:lfmodal:=myform:leadatologic('DEFINE WINDOW',"MODAL","")
   myform:lfnoshow:=myform:leadatologic('DEFINE WINDOW',"NOSHOW","")
   myform:lftopmost:=myform:leadatologic('DEFINE WINDOW',"TOPMOST","")
   myform:lfnominimize:=myform:leadatologic('DEFINE WINDOW',"NOMINIMIZE","")
   myform:lfnomaximize:=myform:leadatologic('DEFINE WINDOW',"NOMAXIMIZE","")
   myform:lfnosize:=myform:leadatologic('DEFINE WINDOW',"NOSIZE","")
   myform:lfnosysmenu:=myform:leadatologic('DEFINE WINDOW',"NOSYSMENU","")
   myform:lfnocaption:=myform:leadatologic('DEFINE WINDOW',"NOCAPTION","")
   myform:lfnoautorelease:=myform:leadatologic('DEFINE WINDOW',"NOAUTORELEASE","")
   myform:lfhelpbutton:=myform:leadatologic('DEFINE WINDOW',"HELPBUTTON","")
   myform:lffocused:=myform:leadatologic('DEFINE WINDOW',"FOCUSED","")
   myform:lfbreak:=myform:leadatologic('DEFINE WINDOW',"BREAK","")
   myform:lfsplitchild:=myform:leadatologic('DEFINE WINDOW',"SPLITCHILD","")
   myform:lfgrippertext:=myform:leadatologic('DEFINE WINDOW',"GRIPPERTEXT","")

   myform:cfoninit:=myform:leadato('DEFINE WINDOW','ON INIT','')
   myform:cfonrelease:=myform:leadato('DEFINE WINDOW','ON RELEASE','')
   myform:cfoninteractiveclose:=myform:leadato('DEFINE WINDOW','ON INTERACTIVECLOSE','')
   myform:cfonmouseclick:=myform:leadato('DEFINE WINDOW','ON MOUSECLICK','')
   myform:cfonmousedrag:=myform:leadato('DEFINE WINDOW','ON MOUSEDRAG','')
   myform:cfonmousemove:=myform:leadato('DEFINE WINDOW','ON MOUSEMOVE','')
   myform:cfonsize:=myform:leadato('DEFINE WINDOW','ON SIZE','')
   myform:cfonpaint:=myform:leadato('DEFINE WINDOW','ON PAINT','')
   myform:cfbackcolor:=myform:leadato('DEFINE WINDOW','BACKCOLOR','NIL')
   myform:cfcursor:=myform:leadato('DEFINE WINDOW','CURSOR','')
*********ojo aqui
   myform:cffontname:=myform:clean(myform:leadato('DEFINE WINDOW','FONT','MS Sans Serif'))
   myform:nffontsize:=val(myform:leadato('DEFINE WINDOW','SIZE','10'))
   myform:cfnotifyicon:=myform:clean(myform:leadato('DEFINE WINDOW','NOTIFYICON',''))
   myform:cfnotifytooltip:=myform:clean(myform:leadato('DEFINE WINDOW','NOTIFYTOOLTIP',''))
   myform:cfonnotifyclick:=myform:leadato('DEFINE WINDOW','ON NOTIFYCLICK','')
   myform:cfongotfocus:=myform:leadato('DEFINE WINDOW','ON GOTFOCUS','')
   myform:cfonlostfocus:=myform:leadato('DEFINE WINDOW','ON LOSTFOCUS','')
   myform:cfonscrollup:=myform:leadato('DEFINE WINDOW','ON SCROLLUP','')
   myform:cfonscrolldown:=myform:leadato('DEFINE WINDOW','ON SCROLLDOWN','')
   myform:cfonscrollright:=myform:leadato('DEFINE WINDOW','ON SCROLLRIGHT','')
   myform:cfonscrollleft:=myform:leadato('DEFINE WINDOW','ON SCROLLLEFT','')
   myform:cfonhscrollbox:=myform:leadato('DEFINE WINDOW','ON HSCROLLBOX','')
   myform:cfonvscrollbox:=myform:leadato('DEFINE WINDOW','ON VSCROLLBOX','')

   myform:lfmain:=iif(myform:lfmain='T',.T.,.F.)
   myform:lfmodal:=iif(myform:lfmodal='T',.T.,.F.)


   form_1:row := nfrow
   form_1:col := nfcol
   form_1:width := nfwidth
   form_1:height := nfheight - GetTitleHeight()
   form_1:title := myform:cftitle

   myform:lfchild:=iif(myform:lfchild='T',.T.,.F.)
   myform:lfnoshow:=iif(myform:lfnoshow='T',.T.,.F.)
   myform:lftopmost:=iif(myform:lftopmost='T',.T.,.F.)
   myform:lfnominimize:=iif(myform:lfnominimize='T',.T.,.F.)
   myform:lfnomaximize:=iif(myform:lfnomaximize='T',.T.,.F.)
   myform:lfnosize:=iif(myform:lfnosize='T',.T.,.F.)
   myform:lfnosysmenu:=iif(myform:lfnosysmenu='T',.T.,.F.)
   myform:lfnocaption:=iif(myform:lfnocaption='T',.T.,.F.)
   myform:lfnoautorelease:=iif(myform:lfnoautorelease='T',.T.,.F.)
   myform:lfhelpbutton:=iif(myform:lfhelpbutton='T',.T.,.F.)
   myform:lffocused:=iif(myform:lffocused='T',.T.,.F.)
   myform:lfbreak:=iif(myform:lfbreak='T',.T.,.F.)
   myform:lfsplitchild:=iif(myform:lfsplitchild='T',.T.,.F.)
   myform:lfgrippertext:=iif(myform:lfgrippertext='T',.T.,.F.)

return
*---------------------------
static function plabel( i, myIde )
*---------------------------
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='LABEL'
   myform:aname[i]:=myform:acontrolw[i]
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))

***  lbold:=myform:leadatologic(cname,"BOLD","F")
**   cfontcolor:=myform:clean(myform:leadato(cname,'FONTCOLOR','{0,0,0}'))

   cbackcolor:=myform:clean(myform:leadato(cname,'BACKCOLOR','NIL'))

   ltrans:=myform:leadatologic(cname,"TRANSPARENT","")
   lrightalign:=myform:leadatologic(cname,"RIGHTALIGN","")
   lcenteralign:=myform:leadatologic(cname,"CENTERALIGN","")
   lautosize:=myform:leadatologic(cname,"AUTOSIZE","")
   lclientedge:=myform:leadatologic(cname,"CLIENTEDGE","")

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))


   nWidth:=val(myform:leadato(cname,'WIDTH','120'))

   nHeight:=val(myform:leadato(cname,'HEIGHT','24'))

   cvalue:=myform:clean(myform:leadato(cname,'VALUE',cname))
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   caction:=myform:leadato(cname,"ACTION","")
****** autoplay ---> autosize

   if lrightalign='T'
          @ nRow,nCol LABEL &cName OF Form_1 WIDTH nWidth HEIGHT nHeight VALUE cValue ACTION dibuja(this:name) RIGHTALIGN
   else
      if lcenteralign='T'
            @ nRow,nCol LABEL &cName OF Form_1 WIDTH nWidth HEIGHT nHeight VALUE cValue ACTION dibuja(this:name) CENTERALIGN
      else
            @ nRow,nCol LABEL &cName OF Form_1 WIDTH nWidth HEIGHT nHeight VALUE cValue  ACTION dibuja(this:name)
      endif
   endif

   if lautosize='T'
      myform:aautoplay[i]:=.T.
   else
      myform:aautoplay[i]:=.F.
   endif

   ocontrol:=getcontrolobject(cname,"form_1")

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif

   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
        ocontrol:fontsize:=nffontsize
   endif

   myform:atooltip[i]:=myform:clean(myform:leadato_oop(cname,'TOOLTIP',''))

   myform:atransparent[i]:=iif(ltrans='T',.T.,.F.)

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=cbackcolor

   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))


 ****  myform:afontcolor[i]:=cfontcolor
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor


  if len(cbackcolor)>0 .and. cbackcolor#'NIL'

     form_1:&cname:backcolor:=&cbackcolor
  else
     form_1:&cname:backcolor:= { -1,-1,-1 }
  endif

  myform:aaction[i]:=iif(len(caction)>0,caction,'')

  myform:avalue[i]:=cValue

  myform:arightalign[i]:=iif(lrightalign='T',.T.,.F.)

  myform:acenteralign[i]:=iif(lcenteralign='T',.T.,.F.)

  myform:ahelpid[i]:=nhelpid

  myform:aclientedge[i]:=iif(lclientedge='T',.T.,.F.)

  ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*--------------------------
static function pplayer( i, myIde )
*--------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='PLAYER'
   myform:aname[i]:=myform:acontrolw[i]
   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   nWidth:=val(myform:leadato(cname,'WIDTH','0'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))
   cplayfile:=myform:clean(myform:leadato(cname,'FILE',''))
   nHelpid:=val(myform:leadato(cname,'HELPID','0'))

   @ nRow,nCol LABEL &CName OF Form_1 WIDTH nwidth HEIGHT nheight VALUE CName BORDER ACTION dibuja(this:name)

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   myform:afile[i]:=cplayfile
   myform:ahelpid[i]:=nhelpid
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*----------------------------
static function pspinner( i, myIde )
*----------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='SPINNER'
   myform:aname[i]:=myform:acontrolw[i]
   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   nwidth:=val(myform:leadato(cname,'WIDTH','0'))
   nheight:=val(myform:leadato(cname,'HEIGHT','0'))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   crange:=myform:leadato(cname,'RANGE','1,10')
   nvalue:=val(myform:leadato(cname,'VALUE','0'))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   conchange:=myform:leadato(cname,'ON CHANGE','')
   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))

   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"F")
   lwrap:=myform:leadatologic(cname,'WRAP',"F")
   lreadonly:=myform:leadatologic(cname,'READONLY',"F")
   nincrement:=val(myform:leadato(cname,'INCREMENT','0'))

   @ nRow,nCol LABEL &CName OF Form_1 WIDTH nwidth HEIGHT nheight VALUE CName ACTION dibuja(this:name) BACKCOLOR WHITE CLIENTEDGE VSCROLL

   myform:afontname[i]:=cfontname

   if len(cfontname)>0
      form_1:&cname:fontname := cfontname
   else
      form_1:&cname:fontname := cffontname
   endif

   myform:afontsize[i]:=nfontsize
   if nfontsize>0
      form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   cbackcolor:= myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   if len(cbackcolor)>0
      form_1:&cname:backcolor:=&cbackcolor
   endif
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor

   myform:arange[i]:=crange
   myform:ahelpid[i]:=nhelpid
   myform:avaluen[i]:=nvalue
   myform:atooltip[i]:=ctooltip
   form_1:&cname:tooltip:=ctooltip
   myform:aonchange[i]:=conchange
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus

   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)

   myform:awrap[i]:=iif(lwrap='T',.T.,.F.)

   myform:areadonly[i]:=iif(lreadonly='T',.T.,.F.)

   myform:aincrement[i]:=nincrement
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*--------------------------
static function pslider( i, myIde )
*--------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='SLIDER'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nwidth:=val(myform:leadato(cname,'WIDTH','0'))
   nheight:=val(myform:leadato(cname,'HEIGHT','0'))
   crange:=myform:leadato(cname,'RANGE','1,10')
   nvalue:=val(myform:leadato(cname,'VALUE','0'))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   conchange:=myform:leadato(cname,'ON CHANGE','')
   lvertical:=myform:leadatologic(cname,'VERTICAL','F')
   lnoticks:=myform:leadatologic(cname,'NOTICKS','F')
   lboth:=myform:leadatologic(cname,'BOTH','F')
   ltop:=myform:leadatologic(cname,'NTOP','F')
   lleft:=myform:leadatologic(cname,'LEFT','F')
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))

   myform:atooltip[i]:=ctooltip

   if lvertical="T"
      @ nRow,nCol SLIDER &CName OF Form_1 RANGE 1,10 VALUE 5 WIDTH nwidth HEIGHT nheight ON CHANGE dibuja(this:name) NOTABSTOP VERTICAL
   else
      @ nRow,nCol SLIDER &CName OF Form_1 RANGE 1,10 VALUE 5 WIDTH nwidth HEIGHT nheight ON CHANGE dibuja(this:name) NOTABSTOP
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:tooltip:=ctooltip

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','NIL'))
   cbackcolor:=myform:abackcolor[i]
   if cbackcolor#'NIL'
      form_1:&cname:backcolor:=&cbackcolor
   endif

   myform:avertical[i]:=iif(lvertical='T',.T.,.F.)

   myform:anoticks[i]:=iif(lnoticks='T',.T.,.F.)

   myform:aboth[i]:=iif(lboth='T',.T.,.F.)
   myform:atop[i]:=iif(ltop='T',.T.,.F.)
   myform:aleft[i]:=iif(lleft='T',.T.,.F.)

   myform:arange[i]:=crange
   myform:ahelpid[i]:=nhelpid
   myform:avaluen[i]:=nvalue
   myform:aonchange[i]:=conchange
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*--------------------------------
static function pprogressbar( i, myIde )
*--------------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='PROGRESSBAR'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nwidth:=val(myform:leadato(cname,'WIDTH','120'))
   nheight:=val(myform:leadato(cname,'HEIGHT','24'))
   crange:=myform:leadato(cname,'RANGE','1,100')
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   lvertical:=myform:leadatologic(cname,'VERTICAL','F')
   lsmooth:=myform:leadatologic(cname,'SMOOTH','F')
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))

   myform:atooltip[i]:=ctooltip


   @ nrow,ncol LABEL &Cname OF Form_1 WIDTH nwidth HEIGHT nheight VALUE Cname BORDER ACTION dibuja(this:name)

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]

   form_1:&cname:fontcolor:=&cfontcolor

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor
    form_1:&cname:tooltip:=ctooltip
   myform:avertical[i]:=iif(lvertical='T',.T.,.F.)

   myform:asmooth[i]:=iif(lsmooth='T',.T.,.F.)

   myform:arange[i]:=crange
   myform:ahelpid[i]:=nhelpid
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*------------------------------
static function pradiogroup( i, myIde )
*------------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='RADIOGROUP'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nwidth:=val(myform:leadato(cname,'WIDTH','0'))
   nheight:=val(myform:leadato(cname,'HEIGHT','100'))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))

   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   citems:=myform:leadato(cname,'OPTIONS',"{'option 1','option 2'}")
   nvalue:=val(myform:leadato(cname,'VALUE','0'))
   nspacing:=val(myform:leadato(cname,'SPACING',"25"))
   ltrans:=myform:leadatologic(cname,'TRANSPARENT','')
   nhelpid:=val(myform:leadato(cname,'HELPID',"0"))
   nllaves1:=0
   nllaves2:=0
   for ki:=1 to len(citems)
       if substr(citems,ki,1)='{'
          nllaves1++
       else
          if substr(citems,ki,1)='}'
             nllaves2++
          endif
       endif

   next ki
   if (len(&citems)<2) .or. (nllaves1#1) .or. (nllaves2#1)
      citems:="{'option 1','option 2'}"
   endif
   litems:=len(&citems)
   cOnchange:=myform:leadato(cname,'ON CHANGE','')

   @ nRow,nCol LABEL &CName OF Form_1 WIDTH nwidth HEIGHT nspacing*litems+8 VALUE CName BORDER ACTION dibuja(this:name)

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif

   myform:atransparent[i]:=iif(ltrans='T',.T.,.F.)

   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','NIL'))
   cbackcolor:=myform:abackcolor[i]
   if cbackcolor#"NIL"
      form_1:&cname:backcolor:=&cbackcolor
   endif
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
   myform:atooltip[i]:=ctooltip
   myform:avaluen[i]:=nvalue
   myform:aitems[i]:=citems
   myform:aspacing[i]:=nspacing
   myform:ahelpid[i]:=nhelpid
   myform:aonchange[i]:=conchange
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*---------------------------
static function peditbox( i, myIde )
*---------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='EDIT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nwidth:=val(myform:leadato(cname,'WIDTH','0'))
   nheight:=val(myform:leadato(cname,'HEIGHT','0'))

   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))

   cvalue:=myform:clean(myform:leadato(cname,'VALUE',''))
   cfield:=myform:leadato(cname,'FIELD','')
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   nmaxlength:=val(myform:leadato(cname,'MAXLENGTH','500'))
   lreadonly:=myform:leadatologic(cname,"READONLY","F")
   lbreak:=myform:leadatologic(cname,"BREAK","F")
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   lnotabstop:=myform:leadatologic(cname,"NOTABSTOP","F")
   lnovscroll:=myform:leadatologic(cname,"NOVSCROLL","F")
   lnohscroll:=myform:leadatologic(cname,"NOHSCROLL","F")

   conchange:=myform:leadato(cname,'ON CHANGE','')
   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')

   @ nRow,nCol LABEL &CName OF Form_1 WIDTH nwidth HEIGHT nheight VALUE CName BACKCOLOR WHITE CLIENTEDGE HSCROLL VSCROLL ACTION dibuja(this:name)

   myform:areadonly[i]:=iif(lreadonly='T',.T.,.F.)
   myform:abreak[i]:=iif(lbreak='T',.T.,.F.)
   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)
   myform:anovscroll[i]:=iif(lnovscroll='T',.T.,.F.)
   myform:anohscroll[i]:=iif(lnohscroll='T',.T.,.F.)

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor

   myform:ahelpid[i]:=nhelpid
   myform:avalue[i]:=cValue
   myform:afield[i]:=cfield
   myform:atooltip[i]:=ctooltip
   form_1:&cname:tooltip:=ctooltip
   myform:amaxlength[i]:=nmaxlength
   myform:aonchange[i]:=conchange
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   form_1:&cname:value := cvalue
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*-----------------------------
static function prichedit( i, myIde )
*-----------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='RICHEDIT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nwidth:=val(myform:leadato(cname,'WIDTH','0'))
   nheight:=val(myform:leadato(cname,'HEIGHT','0'))

   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))

   cvalue:=myform:clean(myform:leadato(cname,'VALUE',''))
   cfield:=myform:leadato(cname,'FIELD','')
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   nmaxlength:=val(myform:leadato(cname,'MAXLENGTH','60'))
   lreadonly:=myform:leadatologic(cname,"READONLY","F")
   lbreak:=myform:leadatologic(cname,"BREAK","F")
   lnotabstop:=myform:leadatologic(cname,"NOTABSTOP","F")
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))

   conchange:=myform:leadato(cname,'ON CHANGE','')
   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')

   @ nRow,nCol LABEL &CName OF Form_1 WIDTH nwidth HEIGHT nheight VALUE CName BACKCOLOR WHITE CLIENTEDGE  ACTION dibuja(this:name)

   myform:areadonly[i]:=iif(lreadonly='T',.T.,.F.)
   myform:abreak[i]:=iif(lbreak='T',.T.,.F.)
   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor

   myform:ahelpid[i]:=nhelpid
   myform:avalue[i]:=cValue
   myform:afield[i]:=cfield
   myform:atooltip[i]:=ctooltip
    form_1:&cname:tooltip:=ctooltip
   myform:amaxlength[i]:=nmaxlength
   myform:aonchange[i]:=conchange
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   form_1:&cname:value := cvalue
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*--------------------------
static function pframe( i, myIde )
*--------------------------
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='FRAME'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   nWidth:=val(myform:leadato(cname,'WIDTH','0'))

   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))

   cCaption:=myform:clean(myform:leadato(cname,'CAPTION',cname))
   lopaque:=myform:leadatologic(cname,"OPAQUE","F")
   ltrans:=myform:leadatologic(cname,'TRANSPARENT',"")


   lopaque:=iif(upper(lopaque)='T',.T.,.F.)

   if lopaque
      @ nRow,nCol FRAME &cName OF Form_1 CAPTION cCaption WIDTH nWidth HEIGHT nHeight OPAQUE
   else
      @ nRow,nCol FRAME &cName OF Form_1 CAPTION cCaption WIDTH nWidth HEIGHT nHeight
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontname:=myform:afontname[i]:=myform:clean(myform:leadato_oop(cname,'FONTNAME',myform:cffontname))
   form_1:&cname:fontsize:=myform:afontsize[i]:=val(myform:clean(myform:leadato_oop(cname,'FONTSIZE',str(myform:nffontsize,3))))

   myform:atransparent[i]:=iif(ltrans='T',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','NIL'))
   cbackcolor:=myform:abackcolor[i]
   if cbackcolor#'NIL'
      form_1:&cname:backcolor:=&cbackcolor
   endif
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
   myform:aCaption[i]:=cCaption
   myform:aopaque[i]:=lopaque
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*--------------------------
static function pbrowse( i, myIde )
*-------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='BROWSE'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nWidth:=val(myform:leadato(cname,'WIDTH','0'))

   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))
   cheaders:=myform:leadato(cname,'HEADERS',"{'',''} ")
   cworkarea:=myform:leadato(cname,'WORKAREA',"ALIAS()")
   cwidths:=myform:leadato(cname,'WIDTHS',"{100,60}")
   cfields:=myform:leadato(cname,'FIELDS',"{ 'field1','field2'}")
   nvalue:=val(myform:leadato(cname,'VALUE',''))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   conchange:=myform:leadato(cname,'ON CHANGE','')
   coneditcell:=myform:leadato(cname,'ON EDITCELL','')
   conappend:=myform:leadato(cname,'ON APPEND','')
   condblclick:=myform:leadato(cname,'ON DBLCLICK','')
   conenter:=myform:leadato(cname,'ON ENTER','')

   ccolumncontrols:=myform:leadato(cname,"COLUMNCONTROLS","")
   cinputmask:=myform:leadato(cname,'INPUTMASK',"")

   conheadclick:=myform:leadato(cname,'ON HEADCLICK','')
   cvalid:=myform:leadato(cname,'VALID',"")
   cwhen:=myform:leadato(cname,'WHEN',"")
   cvalidmess:=myform:leadato(cname,'VALIDMESSAGES',"")
   cdynamicbackcolor:=myform:leadato(cname,"DYNAMICBACKCOLOR","")
   cdynamicforecolor:=myform:leadato(cname,"DYNAMICFORECOLOR","")
   creadonly:=myform:leadato(cname,'READONLY',"")
   llock:=myform:leadatologic(cname,'LOCK',"")
   ldelete:=myform:leadatologic(cname,'DELETE',"")
   ledit:=myform:leadatologic(cname,'EDIT',"")
   lappend:=myform:leadatologic(cname,'APPEND ;',"")
   lnolines:=myform:leadatologic(cname,'NOLINES',"")
   cjustify:=myform:leadato(cname,'JUSTIFY',"")
   cimage:=myform:leadato(cname,'IMAGE',"")
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   linplace:=myform:leadatologic(cname,'INPLACE',"")
   Name := { { Cname ,''} }


   lnolines:=iif(lnolines='T',.T.,.F.)
   llock:=iif(llock='T',.T.,.F.)
   ldelete:=iif(ldelete='T',.T.,.F.)
   linplace:=iif(linplace='T',.T.,.F.)
   ledit:=iif(ledit='T',.T.,.F.)
   lappend:=iif(lappend='T',.T.,.F.)

   @ nRow,nCol GRID &CName OF Form_1 WIDTH nwidth HEIGHT nheight  HEADERS {  cname,'' }  WIDTHS { 100,60 } ITEMS { { "" ,"" } }  TOOLTIP 'Properties and events right click on header area' ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name)

   myform:aheaders[i]:=cheaders
   myform:awidths[i]:=cwidths
   myform:afields[i]:=cfields
   myform:avaluen[i]:=nvalue
   myform:aworkarea[i]:=cworkarea

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor

   myform:atooltip[i]:=ctooltip
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange
   myform:aoneditcell[i]:=coneditcell
   myform:aonappend[i]:=conappend

   myform:aondblclick[i]:=condblclick
   myform:aonenter[i]:=conenter
   myform:aonheadclick[i]:=conheadclick
   myform:avalid[i]:=cvalid
   myform:awhen[i]:=cwhen

   myform:avalidmess[i]:=cvalidmess
   myform:adynamicbackcolor[i]:=cdynamicbackcolor
   myform:adynamicforecolor[i]:=cdynamicforecolor
   myform:areadonlyb[i]:=creadonly
   myform:alock[i]:=llock
   myform:adelete[i]:=ldelete
   myform:ainplace[i]:=linplace
   myform:aedit[i]:=ledit
   myform:aappend[i]:=lappend

   myform:anolines[i]:=lnolines
   myform:ajustify[i]:=cjustify
   myform:aimage[i]:=cimage
   myform:ahelpid[i]:=nhelpid
   myform:acolumncontrols[i]:=ccolumncontrols
   myform:ainputmask[i]:=cinputmask
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*-------------------------
static function pgrid( i, myIde )
*-------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='GRID'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nWidth:=val(myform:leadato(cname,'WIDTH','0'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))
   cheaders:=myform:leadato(cname,'HEADERS',"{'one','two'} ")
   cwidths:=myform:leadato(cname,'WIDTHS',"{80,60}")
   citems:=myform:leadato(cname,'ITEMS',"")
   cvalue:=myform:leadato(cname,'VALUE','')
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   cdynamicbackcolor:=myform:leadato(cname,"DYNAMICBACKCOLOR","")
   cdynamicforecolor:=myform:leadato(cname,"DYNAMICFORECOLOR","")
   ccolumncontrols:=myform:leadato(cname,"COLUMNCONTROLS","")
   creadonly:=myform:leadato(cname,'READONLY',"")
   cinputmask:=myform:leadato(cname,'INPUTMASK',"")

   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   conchange:=myform:leadato(cname,'ON CHANGE','')
   condblclick:=myform:leadato(cname,'ON DBLCLICK','')
   conheadclick:=myform:leadato(cname,'ON HEADCLICK','')
   coneditcell:=myform:leadato(cname,'ON EDITCELL','')
   lmultiselect:=myform:leadatologic(cname,'MULTISELECT',"")
   lnolines:=myform:leadatologic(cname,'NOLINES',"")
   linplace:=myform:leadatologic(cname,'INPLACE',"")
   cimage:=myform:leadato(cname,'IMAGE',"")
   cjustify:=myform:leadato(cname,'JUSTIFY',"")
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   lbreak:=myform:leadatologic(cname,'BREAK',"")
   ledit:=myform:leadatologic(cname,'EDIT',"")
   cvalid:=myform:leadato(cname,'VALID',"")
   cwhen:=myform:leadato(cname,'WHEN',"")
   cvalidmess:=myform:leadato(cname,'VALIDMESSAGES',"")

   lmultiselect:=iif(lmultiselect='T',.T.,.F.)

   lnolines:=iif(lnolines='T',.T.,.F.)
   linplace:=iif(linplace='T',.T.,.F.)
   ledit:=iif(ledit='T',.T.,.F.)
   lbreak:=iif(lbreak='T',.T.,.F.)

   @ nRow,nCol GRID &CName OF Form_1 WIDTH nwidth HEIGHT nheight  HEADERS {  cname,'' }  WIDTHS { 100,60 } ITEMS { { "" ,"" } }  TOOLTIP 'Properties and events right click on header area' ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name)

   myform:aheaders[i]:=cheaders
   myform:awidths[i]:=cwidths
   myform:aitems[i]:=citems
   myform:avalue[i]:=cvalue

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
   myform:atooltip[i]:=ctooltip
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange
   myform:aondblclick[i]:=condblclick
   myform:aonheadclick[i]:=conheadclick
   myform:aoneditcell[i]:=coneditcell
   myform:amultiselect[i]:=lmultiselect
   myform:anolines[i]:=lnolines
   myform:ainplace[i]:=linplace
    myform:aedit[i]:=ledit
   myform:ahelpid[i]:=nhelpid
   myform:abreak[i]:=lbreak
   myform:aimage[i]:=cimage
   myform:ajustify[i]:=cjustify
   myform:adynamicbackcolor[i]:=cdynamicbackcolor
   myform:adynamicforecolor[i]:=cdynamicforecolor
   myform:acolumncontrols[i]:=ccolumncontrols
   myform:avalid[i]:=cvalid
   myform:awhen[i]:=cwhen
   myform:areadonlyb[i]:=creadonly
   myform:avalidmess[i]:=cvalidmess
   myform:ainputmask[i]:=cinputmask

   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*-----------------------------
static function pdatepicker( i, myIde )
*-----------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='DATEPICKER'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   myform:aname[i]:=myform:acontrolw[i]

   nWidth:=val(myform:leadato(cname,'WIDTH','120'))
****   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))

   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   cfield:=myform:leadato(cname,'FIELD','')
   cvalue:=myform:leadato(cname,'VALUE','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   conchange:=myform:leadato(cname,'ON CHANGE','')
   conenter:=myform:leadato(cname,'ON ENTER','')

   lshownone:=myform:leadatologic(cname,'SHOWNONE',"")
   lupdown:=myform:leadatologic(cname,'UPDOWN',"")
   lrightalign:=myform:leadatologic(cname,'RIGHTALIGN',"")
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))


   @ nRow,nCol DATEPICKER &CName OF Form_1 WIDTH nwidth ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP

   myform:avalue[i]:=cvalue

   myform:ashownone[i]:=iif(lshownone='T',.T.,.F.)

   myform:aupdown[i]:=iif(lupdown='T',.T.,.F.)

   myform:arightalign[i]:=iif(lrightalign='T',.T.,.F.)

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
   myform:atooltip[i]:=ctooltip
   form_1:&cname:tooltip:=ctooltip
   myform:ahelpid[i]:=nhelpid
   myform:afield[i]:=cfield

   myform:aongotfocus[i]:=congotfocus
   myform:aonchange[i]:=conchange
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonenter[i]:=conenter

   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*-----------------------------
static function pmonthcal( i, myIde )
*-----------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='MONTHCALENDAR'
   myform:aname[i]:=cname


   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

////   nWidth:=val(myform:leadato(cname,'WIDTH','0'))  197
////  nHeight:=val(myform:leadato(cname,'HEIGHT','0')) 151
/// el alto y ancho deben ser constantes
   nwidth:=217
   nheight:=181
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))

****   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   cvalue:=myform:leadato(cname,'VALUE','')
**   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   conchange:=myform:leadato(cname,'ON CHANGE','')

   lnotoday:=myform:leadatologic(cname,'NOTODAY',"")
   lnotodaycircle:=myform:leadatologic(cname,'NOTODAYCIRCLE',"")
   lweeknumbers:=myform:leadatologic(cname,'WEEKNUMBERS',"")
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"")

   nhelpid:=val(myform:leadato(cname,'HELPID','0'))

   @ nrow,ncol MONTHCALENDAR &Cname OF Form_1  NOTABSTOP ON CHANGE dibuja(this:name)

   myform:avalue[i]:=cvalue

   myform:anotoday[i]:=iif(lnotoday='T',.T.,.F.)

   myform:anotodaycircle[i]:=iif(lnotodaycircle='T',.T.,.F.)

   myform:aweeknumbers[i]:=iif(lweeknumbers='T',.T.,.F.)

   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
   myform:atooltip[i]:=ctooltip
   form_1:&cname:tooltip:=ctooltip
   myform:ahelpid[i]:=nhelpid
   myform:aonchange[i]:=conchange
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*-----------------------------
static function phyplink( i, myIde )
*-----------------------------
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='HYPERLINK'
   myform:aname[i]:=myform:acontrolw[i]
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   caddress:=myform:clean(myform:leadato(cname,'ADDRESS','http://sistemascvc.tripod.com'))
   cvalue:=myform:clean(myform:leadato(cname,'VALUE','ooHG IDE+ Home'))
   nWidth:=val(myform:leadato(cname,'WIDTH','100'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','28'))
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   lhandcursor:=myform:leadatologic(cname,'HANDCURSOR',"")


@ nrow,ncol LABEL &cName OF Form_1 value cvalue BORDER ACTION dibuja(this:name) WIDTH nwidth HEIGHT nheight
   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)
   if lhandcursor=''
      myform:ahandcursor[i]:=.F.
   else
      myform:ahandcursor[i]:=.T.
   endif
   myform:aaddress[i]:=caddress

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)
   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','NIL'))
   cbackcolor:=myform:abackcolor[i]
   if cbackcolor#'NIL'
      form_1:&cname:backcolor:=&cbackcolor
   endif
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor

   myform:avalue[i]:=cvalue
   myform:atooltip[i]:=ctooltip
    form_1:&cname:tooltip:=ctooltip
   myform:ahelpid[i]:=nhelpid
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*------------------------------
static function panimatebox( i, myIde )
*------------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='ANIMATE'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   nWidth:=val(myform:leadato(cname,'WIDTH','0'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))

   cfile:=myform:clean(myform:leadato(cname,'FILE',""))
***
   lautoplay:=myform:leadatologic(cname,'AUTOPLAY',"")
   lcentrado:=myform:leadatologic(cname,'CENTER',"")

   ltrans:=myform:leadatologic(cname,'TRANSPARENT',"")
   nHelpid:=val(myform:leadato(cname,'HELPID','0'))


   @ nRow,nCol LABEL &CName OF Form_1 WIDTH nwidth HEIGHT nheight VALUE CName BORDER ACTION dibuja(this:name)

   myform:afile[i]:=cfile

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)
   myform:atooltip[i]:=myform:clean(myform:leadato_oop(cname,'TOOLTIP',''))
   form_1:&cname:tooltip:= myform:atooltip[i]
   myform:aautoplay[i]:=iif(lautoplay='T',.T.,.F.)
   myform:acenter[i]:=iif(lcentrado='T',.T.,.F.)
   myform:atransparent[i]:=iif(ltrans='T',.T.,.F.)

   myform:ahelpid[i]:=nhelpid
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*--------------------------
static function pimage( i, myIde )
*--------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='IMAGE'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   nWidth:=val(myform:leadato(cname,'WIDTH','100'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','100'))
   cAction:=myform:leadato(cname,'ACTION',"")

   nHelpid:=val(myform:leadato(cname,'HELPID','0'))
   lstretch:=myform:leadatologic(cname,'STRETCH',"F")
   cPicture:=myform:clean(myform:leadato(cname,'PICTURE','IMAGE.BMP'))

*      IF lstretch='T'
*         @ nrow,ncol IMAGE &cname OF Form_1 PICTURE cpicture WIDTH nWidth HEIGHT nheight STRETCH
*      else
*         @ nrow,ncol IMAGE &cname OF Form_1 PICTURE cpicture WIDTH nWidth HEIGHT nheight
*      endif

   @ nrow,ncol LABEL &Cname OF Form_1 WIDTH nwidth HEIGHT nheight VALUE CName BORDER ACTION dibuja(this:name) FONT 'MS Sans Serif' SIZE 10

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)


   myform:aPicture[i]:=cPicture
   myform:aaction[i]:=cAction

   myform:astretch[i]:=iif(lstretch='T',.T.,.F.)
   myform:ahelpid[i]:=nHelpid
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*----------------------------
static function ppicbutt( i, myIde )
*----------------------------
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='PICBUTT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   cPicture:=myform:clean(myform:leadato(cname,'PICTURE',''))
   cAction:=myform:leadato(cname,'ACTION',"msginfo('Button pressed')")
   nWidth:=val(myform:leadato(cname,'WIDTH','30'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','30'))
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"")
   lflat:=myform:leadatologic(cname,'FLAT',"")

   cOngotfocus:=myform:leadato(cname,'ON GOTFOCUS','')

   cOnlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   cauxfile:=cpicture+'.BMP'
   if file(cauxfile)
      @ nrow,ncol Button &cName OF Form_1 PICTURE cauxfile  WIDTH nwidth HEIGHT nheight ON GOTFOCUS dibuja(this:name) NOTABSTOP
    else
       @ nrow,ncol Button &cName OF Form_1 PICTURE 'A4'  WIDTH nwidth HEIGHT nheight ON GOTFOCUS dibuja(this:name) NOTABSTOP
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   myform:aPicture[i]:=cPicture
   myform:atooltip[i]:=ctooltip
    form_1:&cname:tooltip:=ctooltip
   myform:aaction[i]:=caction
   myform:ahelpid[i]:=nhelpid

   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)
   myform:aflat[i]:=iif(lflat='T',.T.,.F.)

   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus

   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*--------------------------------
static function ppiccheckbutt( i, myIde )
*--------------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='PICCHECKBUTT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nWidth:=val(myform:leadato(cname,'WIDTH','0'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))
   cpicture:=myform:clean(myform:leadato(cname,'PICTURE',''))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   lvalue:=myform:leadato(cname,'VALUE','')
   nhelpid:=val(myform:leadato(cname,'HELPID',"0"))
   cOnchange:=myform:leadato(cname,'ON CHANGE','')
   cOngotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   cOnlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"")

   lvaluel:=myform:leadato(cname,'VALUE',"")
   lvaluelaux:=iif(lvaluel='.T.',.T.,.F.)

   cauxfile:=cpicture+'.BMP'

   if file(cauxfile)
      @ nRow,nCol CHECKBUTTON &CName OF Form_1 PICTURE cauxfile WIDTH nwidth HEIGHT nheight ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
   else
      @ nRow,nCol CHECKBUTTON &CName OF Form_1 PICTURE 'A4' WIDTH nwidth HEIGHT nheight ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)
   myform:atooltip[i]:=ctooltip
    form_1:&cname:tooltip:=ctooltip

   form_1:&cname:value := myform:avaluel[i]
   myform:apicture[i]:=cpicture
   myform:avaluel[i]:=lvaluelaux
   myform:ahelpid[i]:=nhelpid
   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)

   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*---------------------------
static function pcheckbtn( i, myIde )
*---------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='CHECKBTN'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nWidth:=val(myform:leadato(cname,'WIDTH','30'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','30'))
   cCaption:=myform:clean(myform:leadato(cname,'CAPTION',cName))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   lvalue:=myform:leadato(cname,'VALUE','')
   nhelpid:=val(myform:leadato(cname,'HELPID',"0"))
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"")

   cOnchange:=myform:leadato(cname,'ON CHANGE','')
   cOngotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   cOnlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')

   lvaluel:=myform:leadato(cname,'VALUE',"")
   lvaluelaux:=iif(lvaluel='.T.',.T.,.F.)



   @ nRow,nCol CHECKBUTTON &CName OF Form_1 CAPTION Ccaption WIDTH nwidth HEIGHT nheight VALUE lvaluelaux ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','NIL'))
   cbackcolor:=myform:abackcolor[i]
   if cbackcolor#'NIL'
      form_1:&cname:backcolor:=&cbackcolor
   endif
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor

   myform:atooltip[i]:=ctooltip

    form_1:&cname:tooltip:=ctooltip
   myform:acaption[i]:=ccaption

   myform:avaluel[i]:=lvaluelaux

   myform:ahelpid[i]:=nhelpid

   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)

   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*------------------------------
static function pcombobox( i, myIde )
*------------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='COMBO'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nWidth:=val(myform:leadato(cname,'WIDTH','0'))
////   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))
   citems:=myform:leadato(cname,'ITEMS','')
   citemsource:=myform:leadato(cname,'ITEMSOURCE','')
   nvalue:=val(myform:leadato(cname,'VALUE','0'))
   cvaluesource:=myform:leadato(cname,'VALUESOURCE','')
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   nhelpid:=val(myform:leadato(cname,'HELPID',"0"))
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"")
   lsort:=myform:leadatologic(cname,'SORT',"")
   lbreak:=myform:leadatologic(cname,'BREAK',"")
   ldisplayedit:=myform:leadatologic(cname,'DISPLAYEDIT',"")

   cOnchange:=myform:leadato(cname,'ON CHANGE','')
   cOngotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   cOnlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   cOnenter:=myform:leadato(cname,'ON ENTER','')
   cOndisplaychange:=myform:leadato(cname,'ON DISPLAYCHANGE','')

  @ nRow,nCol COMBOBOX &CName OF Form_1 WIDTH nwidth ITEMS { cname,' ' } VALUE 1 ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP


   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor

  myform:atooltip[i]:=ctooltip
    form_1:&cname:tooltip:=ctooltip
  myform:aitems[i]:=citems
  myform:aitemsource[i]:=citemsource
  myform:avaluen[i]:=nvalue
  myform:avaluesource[i]:=cvaluesource
  myform:ahelpid[i]:=nhelpid

  myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)
  myform:asort[i]:=iif(lsort='T',.T.,.F.)
  myform:abreak[i]:=iif(lbreak='T',.T.,.F.)
  myform:adisplayedit[i]:=iif(ldisplayedit='T',.T.,.F.)
  myform:aongotfocus[i]:=congotfocus
  myform:aonlostfocus[i]:=conlostfocus
  myform:aonchange[i]:=conchange
  myform:aonenter[i]:=conenter
  myform:aondisplaychange[i]:=condisplaychange

  ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*----------------------------
static function plistbox( i, myIde )
*----------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='LIST'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   nWidth:=val(myform:leadato(cname,'WIDTH','0'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   citems:=myform:leadato(cname,'ITEMS','')

   nvalue:=val(myform:leadato(cname,'VALUE','0'))
   lmultiselect:=myform:leadatologic(cname,'MULTISELECT',"F")
   nhelpid:=val(myform:leadato(cname,'HELPID',"0"))
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"")
   lbreak:=myform:leadatologic(cname,'BREAK',"")
   lsort:=myform:leadatologic(cname,'SORT',"")

   cOnchange:=myform:leadato(cname,'ON CHANGE','')
   cOngotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   cOnlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   cOndblclick:=myform:leadato(cname,'ON DBLCLICK','')

 @ nRow,nCol LISTBOX &CName OF Form_1 WIDTH nwidth HEIGHT nheight ITEMS {cname} ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP

  myform:atooltip[i]:=ctooltip

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)


  form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
  form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
  form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
  form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)
   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
  myform:atooltip[i]:=ctooltip
    form_1:&cname:tooltip:=ctooltip
  myform:aitems[i]:=citems
  myform:avaluen[i]:=nvalue

  myform:amultiselect[i]:=iif(lmultiselect='T',.T.,.F.)

  myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)

  myform:asort[i]:=iif(lsort='T',.T.,.F.)

  myform:ahelpid[i]:=nhelpid

  myform:abreak[i]:=iif(lbreak='T',.T.,.F.)

  myform:aongotfocus[i]:=congotfocus
  myform:aonlostfocus[i]:=conlostfocus
  myform:aonchange[i]:=conchange
  myform:aondblclick[i]:=condblclick

  ProcessContainersfill( Cname,nrow,ncol, myIde )
return
*-----------------------------
static function pcheckbox( i, myIde )
*-----------------------------
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='CHECKBOX'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   cCaption:=myform:clean(myform:leadato(cname,'CAPTION',cName))
   nWidth:=val(myform:leadato(cname,'WIDTH','0'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','0'))
   cOnchange:=myform:leadato(cname,'ON CHANGE','')
   cfield:=myform:leadato(cname,'FIELD','')
   cOngotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   cOnlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   ltrans:=myform:leadatologic(cname,'TRANSPARENT',"")
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"")

   lvaluel:=myform:leadato(cname,'VALUE',"")
   lvaluelaux:=iif(lvaluel='.T.',.T.,.F.)

   @ nRow,nCol CHECKBOX &CName OF Form_1 CAPTION Ccaption WIDTH nwidth HEIGHT nheight VALUE lvaluelaux FONT cfontname SIZE nfontsize ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif


   myform:atransparent[i]:=iif(ltrans='T',.T.,.F.)

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)
   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','NIL'))
   cbackcolor:=myform:abackcolor[i]
   if cbackcolor#'NIL'
      form_1:&cname:backcolor:=&cbackcolor
   endif
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
   myform:atooltip[i]:=ctooltip
    form_1:&cname:tooltip:=ctooltip

   myform:acaption[i]:=ccaption
   myform:ahelpid[i]:=nhelpid
   myform:afield[i]:=cfield
   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)
   myform:avaluel[i]:=lvaluelaux


   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*---------------------------
static function pbutton( i, myIde )
*---------------------------

   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='BUTTON'
   myform:aname[i]:=myform:acontrolw[i]
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))

   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   cCaption:=myform:clean(myform:leadato(cname,'CAPTION',cName))
   cPicture:= myform:clean(myform:leadato(cname,'PICTURE',''))
   cAction:=myform:leadato(cname,'ACTION',"msginfo('Button pressed')")
   nWidth:=val(myform:leadato(cname,'WIDTH','100'))
   nHeight:=val(myform:leadato(cname,'HEIGHT','28'))
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"")
   lflat:=myform:leadatologic(cname,'FLAT',"")

   ltop:=myform:leadatologic(cname,'TOP',"")
   lbottom:=myform:leadatologic(cname,'BOTTOM',"")
   lleft:=myform:leadatologic(cname,'LEFT',"")
   lright:=myform:leadatologic(cname,'RIGHT',"")

   cOngotfocus:=myform:leadato(cname,'ON GOTFOCUS','')

   cOnlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')

@ nrow,ncol Button &cName OF Form_1 CAPTION cCaption  WIDTH nwidth HEIGHT nheight ON GOTFOCUS dibuja(this:name) NOTABSTOP

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)


   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','NIL'))

   cbackcolor:=myform:abackcolor[i]
   if cbackcolor#'NIL'
      form_1:&cname:backcolor:=&cbackcolor
   endif
   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor

   myform:aCaption[i]:=cCaption
   myform:aPicture[i]:=cPicture
   if ltop="T"
       myform:Ajustify[i]:="TOP"
   else
      if lbottom="T"
         myform:Ajustify[i]:="BOTTOM"
      else
         if lleft="T"
             myform:Ajustify[i]:="LEFT"
         else
             if lright="T"
                myform:Ajustify[i]:="RIGHT"
             endif
         endif
      endif
   endif


   myform:atooltip[i]:=ctooltip
    form_1:&cname:tooltip:=ctooltip
   myform:aaction[i]:=caction
   myform:ahelpid[i]:=nhelpid

   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)
   myform:aflat[i]:=iif(lflat='T',.T.,.F.)

   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*----------------------------
static function ptextbox( i, myIde )
*----------------------------
   cname:=myform:acontrolw[i]
   myform:actrltype[i]:='TEXT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:learow(cName))
   ncol:=val(myform:leacol(cname))
   cfontname:=myform:clean(myform:leadato(cname,'FONT',cffontname))
   nfontsize:=val(myform:leadato(cname,'SIZE',str(nffontsize)))
   nwidth:=val(myform:leadato(cname,'WIDTH','120'))
   nheight:=val(myform:leadato(cname,'HEIGHT','24'))
   cvalue:=myform:clean(myform:leadato(cname,'VALUE',''))
   cfield:=myform:leadato(cname,'FIELD','')
   ctooltip:=myform:clean(myform:leadato(cname,'TOOLTIP',''))
   nmaxlength:=val(myform:leadato(cname,'MAXLENGTH','30'))
   nhelpid:=val(myform:leadato(cname,'HELPID','0'))
   luppercase:=myform:leadatologic(cname,"UPPERCASE","F")
   llowercase:=myform:leadatologic(cname,"LOWERCASE","F")
   lpassword:=myform:leadatologic(cname,"PASSWORD","F")
   lnumeric:=myform:leadatologic(cname,"NUMERIC","F")
   lrightalign:=myform:leadatologic(cname,"RIGHTALIGN","F")
   lnotabstop:=myform:leadatologic(cname,'NOTABSTOP',"F")
   ldate:=myform:leadatologic(cname,'DATE',"F")
   cinputmask:=myform:clean(myform:leadato(cname,'INPUTMASK',""))
   if len(cinputmask)>0
      nmaxlength:=0
   endif
   cformat:=myform:clean(myform:leadato(cname,'FORMAT',""))
   conenter:=myform:leadato(cname,'ON ENTER','')
   conchange:=myform:leadato(cname,'ON CHANGE','')
   congotfocus:=myform:leadato(cname,'ON GOTFOCUS','')
   conlostfocus:=myform:leadato(cname,'ON LOSTFOCUS','')
   lreadonly:=myform:leadatologic(cname,'READONLY',"")
   nFocusedPos:= val(myform:leadato(cname,'FOCUSEDPOS','-2'))   // pb
   cvalid:= myform:leadato(cname,'VALID','')
   cwhen:=myform:leadato(cname,'WHEN','')


   if luppercase='T'
      luppercase=.T.
      cvalue:=upper(cvalue)
   else
      luppercase=.F.
   endif

   if llowercase='T'
      llowercase=.T.
      cvalue:=lower(cvalue)
   else
      llowercase=.F.
   endif

   lpassword:=iif(lpassword='T',.T.,.F.)

   lnumeric:=iif(lnumeric='T',.T.,.F.)

   lrightalign:=iif(lrightalign='T',.T.,.F.)

   @ nRow,nCol LABEL &cName OF Form_1 WIDTH nWidth HEIGHT nHeight VALUE "" ACTION dibuja(this:name) FONT cfontname SIZE nfontsize BACKCOLOR WHITE CLIENTEDGE

   myform:afontname[i]:=cfontname
   if len(cfontname)>0
        form_1:&cname:fontname := cfontname
   else
        form_1:&cname:fontname := cffontname
   endif
   myform:afontsize[i]:=nfontsize
   if nfontsize>0
        form_1:&cname:fontsize := nfontsize
   else
        form_1:&cname:fontsize := nffontsize
   endif

   myform:adate[i]:=iif(ldate='T',.T.,.F.)


   myform:anotabstop[i]:=iif(lnotabstop='T',.T.,.F.)

   myform:aenabled[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'ENABLED','.T.')))='.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'VISIBLE','.T.')))='.T.',.T.,.F.)

   form_1:&cname:fontitalic:=myform:afontitalic[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTITALIC','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontunderline:=myform:afontunderline[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTUNDERLINE','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTSTRIKEOUT','.F.')))='.T.',.T.,.F.)
   form_1:&cname:fontbold:=myform:abold[i]:=iif(upper(myform:clean(myform:leadato_oop(cname,'FONTBOLD','.F.')))='.T.',.T.,.F.)

   myform:abackcolor[i]:=myform:clean(myform:leadato_oop(cname,'BACKCOLOR','{255,255,255}'))
   cbackcolor:=myform:abackcolor[i]
   form_1:&cname:backcolor:=&cbackcolor

   myform:afontcolor[i]:=myform:clean(myform:leadato_oop(cname,'FONTCOLOR','{0,0,0}'))
   cfontcolor:=myform:afontcolor[i]
   form_1:&cname:fontcolor:=&cfontcolor
     myform:avalue[i]:=cValue
     myform:afield[i]:=cfield
     myform:atooltip[i]:=ctooltip
     form_1:&cname:tooltip:=ctooltip
     myform:amaxlength[i]:=nmaxlength
     myform:auppercase[i]:=luppercase
     myform:alowercase[i]:=llowercase
     myform:apassword[i]:=lpassword
     myform:anumeric[i]:=lnumeric
     myform:ainputmask[i]:=cinputmask
     myform:afields[i]:=cformat
     myform:arightalign[i]:=lrightalign
     myform:aonenter[i]:=conenter
     myform:aonchange[i]:=conchange
     myform:aongotfocus[i]:=congotfocus
     myform:aonlostfocus[i]:=conlostfocus
     myform:ahelpid[i]:=nhelpid

     myform:areadonly[i]:=iif(lreadonly='T',.T.,.F.)

     if myform:adate[i] .or. len(myform:ainputmask[i])>0
        myform:amaxlength[i]=0
     endif
     myform:afocusedpos[i]:=nFocusedPos   // pb
     myform:avalid[i]:=cvalid
     myform:awhen[i]:=cwhen

     ProcessContainersfill( Cname,nrow,ncol, myIde )
return

*------------------------------------------------------------------------------*
static function ProcessContainers( ControlName, myIde )
*------------------------------------------------------------------------------*
local i , ActivePage , z,k,k1 ,ocontrol,owindow,alsc
if .not. (myform:swtab)
   return nil
endif
        owindow:=getformobject('Form_1')
   For i := 1 To Len (owindow:acontrols)
            ocontrol:=owindow:acontrols[i]
      If ocontrol:type == 'TAB'
                        cname:=ocontrol:name
                        ndesrow:=ocontrol:row   &&& cordenada del tab para desplazamiento del mouse
                        ndescol:=ocontrol:col
         If ( _ooHG_mouserow > ocontrol:Row ) .And. (_ooHG_mouserow < ocontrol:Row + ocontrol:Height ) .And. ( _ooHG_mousecol > ocontrol:Col ) .And. ( _ooHG_mousecol < ocontrol:Col + ocontrol:Width )
            ActivePage := _GetValue ( ocontrol:Name , 'Form_1' )
            aAdd ( ocontrol:aPages[ActivePage] , GetControlobject ( ControlName , 'Form_1' ) )
                                form_1:&cname:AddControl(controlname, activepage,_ooHG_mouserow - ndesrow ,_ooHG_mousecol - ndescol )
                                alsc := myIde:asystemcoloraux
                                form_1:&controlname:backcolor:=alsc
                                cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(controlname) } )
                                if cvc>0
                                    myform:abackcolor[cvc]:="NIL"
                                    myform:atabpage[cvc,1]:= lower(ocontrol:Name)
                                    myform:atabpage[cvc,2]:= Activepage

                                endif
                         for k=2 to myform:ncontrolw
                               for k1=k+1 to myform:ncontrolw
                                  if myform:atabpage[k,1]#NIL .and. myform:atabpage[k1,1]#NIL
                                     if myform:atabpage[k,1]>myform:atabpage[k1,1]
                                        swapea(k,k1)
                                     endif
                                  endif
                               next k1
                           next k
                           for k=2 to myform:ncontrolw
                               for k1=k+1 to myform:ncontrolw
                                  if myform:atabpage[k,1]#NIL .and. myform:atabpage[k1,1]#NIL
                                     if myform:atabpage[k,1]=myform:atabpage[k1,1]
                                         if myform:atabpage[k,2]>myform:atabpage[k1,2]
                                            swapea(k,k1)
                                         endif
                                     endif
                                  endif
                               next k1
                           next k

                   CHideControl ( GetControlobject ( ControlName , 'Form_1' ):hwnd )
         CShowControl ( GetControlobject ( ControlName , 'Form_1' ):hwnd )
            EndIf

         Exit


      EndIf

   Next i

Return


*----------------------------------------------------
** llena los TABS, previo cargado de los controles en la forma
static function ProcessContainersfill( ControlName, row, col, myIde )
*------------------------------------------------------------------------------*
local i , pagecount , z,l,swpagename,pagename,swnoestab
if .not. myform:swtab
   return nil
endif
controlname:=lower(controlname)
z:=ascan( myform:acontrolw, { |c| lower( c ) == controlname  } )
if z=0
   return nil
endif
l:=myform:aspeed[z]
pagecount:=0
swpagename:=0
****  swanadepage:=0
**** por cada control busca hacia atras a que tab pertenece
swnoestab:=0
for i:=l to 1 step -1

    if at(upper('END TAB'),upper(myform:aline[i]))#0
       swnoestab:=1
       i:=1
       return nil
    else
       if at(upper('DEFINE PAGE '),upper(myform:aline[i]))#0
          if swpagename=0
             npos:=at(upper('DEFINE PAGE '),upper(myform:aline[i]))
             pagename:=alltrim(substr(myform:aline[i],npos+6,len(myform:aline[I])-1))
             pagename:=myform:clean(pagename)
             swpagename:=1
          endif
          pagecount++
       else
          if at(upper('DEFINE TAB '),upper(myform:aline[i]))#0
             npos:=at(upper('TAB '),upper(myform:aline[i]))
             tabname:=alltrim(substr(myform:aline[i],npos+4,len(myform:aline[I])))
             tabname:=lower(alltrim(substr(tabname,1,len(tabname)-1)))
             i:=0
          endif

       endif


    endif
next i
if pagecount>0 .and. swnoestab=0
   myform:atabpage[z,1]:= tabname
   myform:atabpage[z,2]:= pagecount
   form_1:&tabname:addcontrol(Controlname,pagecount,row,col)

   if myform:abackcolor[z]="NIL"
      alsc := myIde:asystemcoloraux
      form_1:&controlname:backcolor:=alsc
   endif
endif
return nil

*----------------------------
function cuantospage(tabname)
*----------------------------
local i,pagecount:=0,swb:=0,h
h:=ascan( myform:acontrolw, { |c| lower( c ) == lower(tabname)  } )
ccaptions:='{'
cimages:='{'
for i=1 to len(myform:aline)
    if at(upper(tabname),upper(myform:aline[i]))#0
       swb:=1
    endif
    if at(upper('DEFINE PAGE '),upper(myform:aline[i]))#0 .and. swb=1
       pagecount++
       npospage:=at('DEFINE PAGE ',upper(myform:aline[i]))
       cpagename:=alltrim(substr(myform:aline[i],npospage+11,len(myform:aline[i])))
       nrat:=rat(';',cpagename)
       cpagename:=alltrim(myform:clean(substr(cpagename,1,nrat-1)))

       nposimage:=at('IMAGE ',upper(myform:aline[i+1]))
       if nposimage>0
          cimage:=alltrim(substr(myform:aline[i+1],nposimage+6,len(myform:aline[i])))
          cimage:=myform:clean(substr(cimage,1,len(myform:aline[i+1])))
       else
          cimage:=''
       endif
       if pagecount>0
          form_1:&tabname:addpage(pagecount,cpagename,cimage)
       endif
       ccaptions=ccaptions+"'"+cpagename+"',"
       cimages=cimages+"'"+cimage+"',"
    endif
    if at(upper('END TAB'),upper(myform:aline[i]))#0 .and. swb=1
       swb:=0
    endif
next i
ccaptions:=substr(ccaptions,1,len(ccaptions)-1)+'}'
cimages:=substr(cimages,1,len(cimages)-1)+'}'
myform:acaption[h]:=ccaptions
myform:aimage[h]:=cimages
return nil


*-------------------------
function procesacontrol()
*-------------------------
local i,j,x,cname,owindow
j:=(lista:listacon:value)+1
cname:=myform:acontrolw[j]
owindow:=getformobject("form_1")
x:=0
for i:=1 to len(owindow:acontrols)
    if lower(cname)=lower(owindow:acontrols[i]:name)
       x=i
       if owindow:acontrols[i]:row # owindow:acontrols[i]:containerrow .or. owindow:acontrols[i]:col # owindow:acontrols[i]:containercol
          oGenerico:=owindow:acontrols[i]
          oPage:=oGenerico:Container
          npos:=oPage:position
          oTab:=oPage:Container
          oTab:value:=npos
       endif
       exit
    endif
next i
if x>0
   dibuja1(x)
endif
myform:lFsave:=.F.
RETURN NIL
*--------------------
function minim()
*--------------------
cvccontrols:minimize()
lista:minimize()
return nil

*----------------
function maxim()
*----------------
cvccontrols:restore()
lista:restore()
return nil

*---------------------
function muestrasino()
*---------------------
local i,ccontrol,oocontrol,nrow,ncol,nwidth,nheight,cname,j,nl
   lista.listacon.deleteallitems
   for i= 2 to len(myform:aname)
//// ojo aqui estaab desde 2
       if len(trim(myform:acontrolw[i]))>0
          ccontrol:=myform:acontrolw[i]
          cname:=myform:aname[i]
          nl:=0
          for j:=1 to len(getformobject('Form_1'):acontrols)
              if lower(getformobject('Form_1'):acontrols[j]:name)= lower(ccontrol)
                 nl:=j
                 exit
              endif
          next j
          if nl>0
              oocontrol:=getformobject('Form_1'):acontrols[nl]
              nrow:=oocontrol:row
              ncol:=oocontrol:col
              nwidth:=oocontrol:width
              nheight:=oocontrol:height
              olistacon:additem({cname,str(nrow,4),str(ncol,4),str(nwidth,4),str(nheight,4),ccontrol})
          endif
       endif
   next i
return nil

*---------------------
function cordenada()
*---------------------
local ocontrol
iRow := _ooHG_mouserow
iCol := _ooHG_mousecol
form_main:labelyx:value:=strzero(irow,4)+','+strzero(icol,4)
if .not. iswindowactive(form_1)
   return nil
endif
BorderWidth    := GetBorderWidth()
BorderHeight    := GetBorderHeight()
****swcursor:=0
****************************************

      iMin := 0

      w_OOHG_MouseRow = _OOHG_MouseRow  -  BorderHeight
      w_OOHG_MouseCol = _OOHG_MouseCol  - BorderWidth

      For i := 2 To Len (myform:aname)
                    wcnamet:=myform:aname[i]
             if valtype(wcnamet)='C' .and. wcnamet#'' ;
                .and. (.not. (myform:actrltype[i]$'STATUSBAR'))
                ocontrol:=getcontrolobject(wcnamet,'form_1')
                if ocontrol:hwnd>0
                if ocontrol:row=ocontrol:containerrow .and. ocontrol:col=ocontrol:containercol
                   if ( w_ooHG_mouserow >= ocontrol:Row -10 ) .And. ;
                      ( w_ooHG_mouserow <= ocontrol:Row   )  .And. ;
                      ( w_ooHG_mousecol >= ocontrol:Col -10 ) .And. ;
                      ( w_ooHG_mousecol <= ocontrol:Col ) .And. ;
                      ( .not. lower(ocontrol:name)$'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .and.  ;
                      (  .not. lower(ocontrol:type)$'hotkey' )
                      iMin := i
                   EndIf
                else
                   if ( w_ooHG_mouserow >= ocontrol:containerRow -10 ) .And. ;
                      ( w_ooHG_mouserow <= ocontrol:containerRow   )  .And. ;
                      ( w_ooHG_mousecol >= ocontrol:containerCol -10 ) .And. ;
                      ( w_ooHG_mousecol <= ocontrol:containerCol ) .And. ;
                      ( .not. lower(ocontrol:name)$'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .and.  ;
                      (  .not. lower(ocontrol:type)$'hotkey' )
                      iMin := i
                   EndIf
                endif
      endif
             endif
       Next i

****************

             if imin>0

                   CursorHand()

                swcursor:=1
                myhandle=imin
             else
                if swcursor#2
                   cursorarrow()
                   swcursor:=0
                endif
             endif


        Imin:=0
   For i := 2 To Len (myform:aname)
             wcnamet:=myform:aname[i]
             if valtype(wcnamet)='C' .and. wcnamet#'' .and. (.not. (myform:actrltype[i]$'STATUSBAR'))
                ocontrol:=getcontrolobject(wcnamet,'form_1')
             if ocontrol:hwnd>0
             if ocontrol:type='TOOLBAR'
             else
                if ocontrol:row=ocontrol:containerrow .and. ocontrol:col=ocontrol:containercol
                   if ( w_ooHG_mouserow >= ocontrol:Row  + ocontrol:height ) .And. ;
                      ( w_ooHG_mouserow <= ocontrol:Row + ocontrol:height+5 )  .And. ;
                      ( w_ooHG_mousecol >= ocontrol:Col  + ocontrol:width ) .And. ;
                      ( w_ooHG_mousecol <= ocontrol:Col + ocontrol:width+5 )  .and. ;
                      (.not. lower(ocontrol:name)$'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .and. ;
                      (  .not. lower(ocontrol:type)$'hotkey' ) .and. .not. sionomc(ocontrol:name)
                      iMin := i
                    EndIf
                else
                   if ( w_ooHG_mouserow >= ocontrol:containerRow  + ocontrol:height ) .And. ;
                      ( w_ooHG_mouserow <= ocontrol:containerRow + ocontrol:height+5 )  .And. ;
                      ( w_ooHG_mousecol >= ocontrol:containerCol  + ocontrol:width ) .And. ;
                      ( w_ooHG_mousecol <= ocontrol:containerCol + ocontrol:width+5 )  .and. ;
                      (.not. lower(ocontrol:name)$'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .and. ;
                      (  .not. lower(ocontrol:type)$'hotkey' ) .and. .not. sionomc(ocontrol:name)
                      iMin := i
                    EndIf
                endif
             endif
             endif
             endif
          Next i

             if imin>0
                CursorSizeNWSE()
                swcursor:=2
                myhandle=imin
             else
                if swcursor#1
                   cursorarrow()
                  swcursor:=0
                endif
             endif
return nil

*---------------------------------
static function sionomc(cname)
*---------------------------------
local i
for i:=2 to len(myform:acontrolw)
    if lower(myform:acontrolw[i])=lower(cname)
       if myform:actrltype[i]$'MONTHCALENDAR TIMER'
          return .T.
       endif
    endif
next i
return .F.


*------------------------
function HELP_F1(C_P, myIde )
*-------------------------
LOCAL WR,I, H, F
**PARAMETER C_P,L_N,I_V

WFHLP:=C_P+'.HLP'
do case
   case C_P='PROJECT'
WR:=""+CRLF
wr:=WR+"MANAGE PROJECTS"+CRLF+CRLF
wr:=WR+"CREATING PROJECTS"+CRLF
wr:=WR+"Select 'new projetc' from menu File, and you have a new project"+CRLF
wr:=WR+"with basic elements and a PRG main"+CRLF+CRLF


wr:=WR+"CHANGING PREFERENCES"+CRLF
wr:=WR+"Select 'preference' from menu File"+CRLF
wr:=WR+"Can change Date Format, Compile mode (Tradtional or BRmake)"+CRLF
wr:=WR+"Default Backcolor and linker options"+CRLF+CRLF

wr:=WR+"SAVING PROJECTS"+CRLF
wr:=WR+"Select 'Save projetc' from menu File"+CRLF+CRLF

wr:=WR+"ADDING ITEMS TO PROJECT TREE"+CRLF
wr:=WR+"Add forms,prg,ch,rpt,rc modules"+CRLF
wr:=WR+"Select the toolbar option ADD FORM or the dropdown menu option"+CRLF+CRLF

wr:=WR+"MODIFY ITEMS"+CRLF
wr:=WR+"Simply double click over item to modify"+CRLF+CRLF

wr:=WR+"REMOVE ITEMS."+CRLF
wr:=WR+"Select toolbar REMOVE ITEM button."+CRLF+CRLF

wr:=WR+"PRINT ITEMS."+CRLF
wr:=WR+"Select toolbar PRINT ITEM button."+CRLF+CRLF

wr:=WR+"BUILDING, RUNING AND DEBUGGIN."+CRLF
wr:=WR+"to only build select toolbar BUILD PROJECT button."+CRLF
wr:=WR+"to build and run  select toolbar BUILD/RUN button."+CRLF
wr:=WR+"to only run select toolbar RUN button."+CRLF
wr:=WR+"to debug select toolbar dropdown menu DEBUG option."+CRLF+CRLF

wr:=WR+"SEARCHING TEXT."+CRLF
wr:=WR+"to search text over all project select toolbar GLOBAL SEARCH TEXT button."+CRLF+CRLF

wr:=WR+"QUICK BROWSING."+CRLF
wr:=WR+"to quick browse only select toolbar QUICK BROWSET button."+CRLF+CRLF

wr:=WR+"DATA MANAGEMENT."+CRLF
wr:=WR+"to more advanced browse, edit, modify select toolbar DATA MANAGER button."+CRLF+CRLF

   case C_P='FORMEDIT'
WR:=""+CRLF
wr:=WR+"EDITING FORMS AND CONTROLS"+CRLF+CRLF
wr:=WR+"FORM OPTIONS"+CRLF+CRLF
wr:=WR+"Menu Builder."+CRLF
wr:=WR+"Select dropedownmenu in form toolbar Menus button the apropiate option"+CRLF
wr:=WR+"Can build MAIN, CONTEXT or NOTIFY menus."+CRLF+CRLF
wr:=WR+"Form Properties."+CRLF
wr:=WR+"Select toolbar Properties button."+CRLF+CRLF
wr:=WR+"Form Events."+CRLF
wr:=WR+"Select toolbar Events button."+CRLF+CRLF
wr:=WR+"Form Font/Color and backcolor"+CRLF
wr:=WR+"Select toolbar Font/Color button."+CRLF+CRLF
wr:=WR+"Control Order (tab order)."+CRLF
wr:=WR+"Select toolbar Order button and move controls Up/down."+CRLF+CRLF
wr:=WR+"Toolbar builder."+CRLF
wr:=WR+"Select toolbar 'Toolbar' button."+CRLF+CRLF
wr:=WR+"Statusbar Builder."+CRLF
wr:=WR+"In order to use statusbar must be ON."+CRLF+CRLF+CRLF

wr:=WR+"CONTROL OPTIONS."+CRLF+CRLF

wr:=WR+"Adding controls."+CRLF
wr:=WR+"Select control type on left toolbar with mouse, and click over design form."+CRLF+CRLF

wr:=WR+"Change control properties in 2 ways."+CRLF
wr:=WR+"1) Selecting control with mouse, and push the toolbar control  button Properties"+CRLF
wr:=WR+"2) Selecting control with mouse, and select properties on context menu"+CRLF+CRLF

wr:=WR+"Change control events in 2 ways."+CRLF
wr:=WR+"1) Selecting control with mouse, and push the toolbar control  button Events"+CRLF
wr:=WR+"2) Selecting control with mouse, and select Events on context menu"+CRLF+CRLF

wr:=WR+"Change Font/Color and Backcolor in 2 ways."+CRLF
wr:=WR+"1) Selecting control with mouse, and push the toolbar control button Font/Colors"+CRLF
wr:=WR+"2) Selecting control with mouse, and select Font/Color on context menu"+CRLF+CRLF

wr:=WR+"Move controls in 4 ways."+CRLF
wr:=WR+"1) Selecting control with mouse, and push the toolbar button Interactive move"+CRLF
wr:=WR+"2) Selecting control with mouse, and select Interactive move on context menu"+CRLF
wr:=WR+"3) Selecting control with mouse, and push the toolbar button Manual move/size"+CRLF
wr:=WR+"4) Drag upper left corner"+CRLF
wr:=WR+"When use 1,2 or 3 option can move control with mouse or keyboard"+CRLF+CRLF


wr:=WR+"Resize controls in 4 ways."+CRLF
wr:=WR+"1) Selecting control with mouse, and push the toolbar button Interactive size"+CRLF
wr:=WR+"2) Selecting control with mouse, and select Interactive size on context menu"+CRLF
wr:=WR+"3) Selecting control with mouse, and push the toolbar button Manual move/size"+CRLF
wr:=WR+"4) Drag lower right corner"+CRLF
wr:=WR+"When use 1,2 or 3 option can resize control with mouse or keyboard"+CRLF+CRLF

wr:=WR+"Delete controls in 3 ways."+CRLF
wr:=WR+"1) Selecting control with mouse, and push the toolbar button delete"+CRLF
wr:=WR+"2) Selecting control with mouse, and select delete on context menu"+CRLF
wr:=WR+"3) Selecting control with mouse, and press the delete key"+CRLF+CRLF
endcase

set interactiveclose on
DEFINE WINDOW FAYUDA  obj fayuda  ;
   AT 10,10 ;
   WIDTH 620 HEIGHT 460 ;
   TITLE 'Help' ;
   ICON 'Edit' ;
   modal on release closeoff() ;
   backcolor myIde:asystemcolor

   on key ESCAPE of fayuda ACTION { || fayuda:release() , closeoff()  }

   @ 0,0 EDITBOX EDIT_1 ;
   WIDTH 613 ;
   HEIGHT 435 ;
   VALUE WR ;
   READONLY ;
   FONT 'Times new Roman' ;
   SIZE 12

END WINDOW

CENTER WINDOW fayuda
ACTIVATE WINDOW fayuda
RETURN NIL

*---------------------------
static function closeoff()
SET INTERACTIVECLOSE OFF
return nil
*---------------------------


/////////// funciones para hacer debug....
Function DebugT
   Local i, l, oForm, aCont

   oForm := GetFormObject( "form_1" )
   l := Len( oForm:aControls )
   For i := 1 To l
      aCont := oForm:aControls[i]
      If aCont:Container:Name # NIL
         MsgInfo( aCont:Container:Name )
      EndIf
   Next i
Return Nil


procedure debugw
local i,cname,j,row,col,width,height,sw,fr
for i:= 1 to len(myform:aname)
  msgbox(myform:aname[i])
next i
return nil

procedure debug
local i,cs
cs:=''
cs:=cs+'# controles '+str(myform:ncontrolw-1,4)+ CRLF
for i:=1 to myform:ncontrolw
    if upper(myform:acontrolw[i])#'TEMPLATE' .AND. upper(myform:acontrolw[i])#'STATUSBAR' .AND. upper(myform:acontrolw[i])#'MAINMENU'   .AND. upper(myform:acontrolw[i])#'CONTEXTMENU' .AND. upper(myform:acontrolw[i])#'NOTIFYMENU'
       if myform:atabpage[i,1]#NIL .and. myform:atabpage[i,1]#''
          cs:=cs+myform:acontrolw[i]+' | ' + myform:actrltype[i] +' | '+str(myform:atabpage[i,2])+' | '+myform:atabpage[i,1] +CRLF
       else
             cs:=cs+myform:acontrolw[i]+' | ' + myform:actrltype[i] + ' |-> '+myform:acaption[i]+CRLF
       endif
    endif
next i
msginfo(cs)
return

*------------------------
function chidecontrol(x)
*------------------------
return hidewindow(x)

#include 'saveform.prg'

#pragma BEGINDUMP

#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"
/////#include "wingdi.h"

HB_FUNC ( HB_GETDC )
{
   hb_retnl( (ULONG) GetDC( (HWND) hb_parnl(1) ) ) ;
}

HB_FUNC ( HB_RELEASEDC )
{
   hb_retl( ReleaseDC( (HWND) hb_parnl(1), (HDC) hb_parnl(2) ) ) ;
}

HB_FUNC( SETPIXEL )
{

  hb_retnl( (ULONG) SetPixel( (HDC) hb_parnl( 1 ),
                              hb_parni( 2 )      ,
                              hb_parni( 3 )      ,
                              (COLORREF) hb_parnl( 4 )
                            ) ) ;
}

HB_FUNC ( INTERACTIVESIZEHANDLE )
{

        keybd_event(
                VK_DOWN,
                0,
                0,
                0
        );

        keybd_event(
                VK_RIGHT,
                0,
                0,
                0
        );

        SendMessage( (HWND) hb_parnl(1) , WM_SYSCOMMAND , SC_SIZE , 0 );

}

HB_FUNC ( INTERACTIVEMOVEHANDLE )
{

        keybd_event(
                VK_RIGHT,       // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function optio
                0               // additional data associated with keystro
        );
        keybd_event(
                VK_LEFT,        // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function optio
                0               // additional data associated with keystro
        );

        SendMessage( (HWND) hb_parnl(1) , WM_SYSCOMMAND , SC_MOVE ,10 );

}

#pragma ENDDUMP

