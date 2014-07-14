/*
 * $Id: formedit.prg,v 1.17 2014-07-14 21:20:24 fyurisich Exp $
 */

/*
 * Copyright 2003-2014 Ciro Vargas Clemow <pcman2010@yahoo.com>
 * http://sistemasvc.tripod.com/
 */

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

#DEFINE CR CHR(13)
#DEFINE LF CHR(10)

*------------------------------------------------------------------------------*
CLASS TForm1
*------------------------------------------------------------------------------*
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

   /*
      Variables de propiedades y eventos.
      Cada vez que se agrega una propiedad o un evento nuevo a un control, se debe agregar una DATA aquí.
      Esa DATA debe inicializarse en el método IniArray.
   */
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
   DATA acobj                INIT {}  //gca                // TODO: cambiar a aObj
   DATA aBorder              INIT {}  //GCA
   DATA aOnEnter             INIT {}  //gca
   DATA aAction2             INIT {}

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
   DATA cFBackcolor          INIT "{212, 208, 200}"
   DATA cFCursor             INIT ""
   DATA cFFontName           INIT ''
   DATA nFFontSize           INIT 0
   DATA cFFontColor          INIT 'NIL'
   DATA nfvirtualw           INIT 0
   DATA nfvirtualh           INIT 0
   DATA cfontcolor           INIT ""
   DATA cbackcolor           INIT ""
   DATA cfnotifyicon         INIT ""
   DATA cfnotifytooltip      INIT ""
   DATA cfobj                INIT ""
   DATA cfonmaximize         INIT ""  //gca
   DATA cfonminimize         INIT ""  //gca

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
   DATA csfontname           INIT 'MS Sans Serif' // TODO: del ide
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
   DATA cscobj               INIT ''    //GCA

   // variables de contadores de tipos de controles
   DATA ButtonCount          INIT  0
   DATA CheckBoxCount        INIT  0
   DATA ListBoxCount         INIT  0
   DATA ComboBoxCount        INIT  0
   DATA CheckButtonCount     INIT  0
   DATA GridCount            INIT  0
   DATA FrameCount           INIT  0
   DATA TabCount             INIT  0
   DATA ImageCount           INIT  0
   DATA AnimateCount         INIT  0
   DATA DatepickerCount      INIT  0
   DATA TextBoxCount         INIT  0
   DATA EditBoxCount         INIT  0
   DATA LabelCount           INIT  0
   DATA PlayerCount          INIT  0
   DATA ProgressBarCount     INIT  0
   DATA RadioGroupCount      INIT  0
   DATA SliderCount          INIT  0
   DATA SpinnerCount         INIT  0
   DATA Timercount           INIT  0
   DATA BrowseCount          INIT  0
   DATA Treecount            INIT  0
   DATA Ipaddresscount       INIT  0
   DATA Monthcalendarcount   INIT  0
   DATA Hyperlinkcount       INIT  0
   DATA Richeditboxcount     INIT  0

   METHOD vd( cItem1, myIde ) CONSTRUCTOR
   METHOD VerifyBar()
   METHOD What( citem1 )
   METHOD IniArray( nForm, nControlwl, ControlName, cTypeCtrl, noanade )
   METHOD AddControl()
   METHOD New()
   METHOD NewAgain()
   METHOD Open( cItem1 )
   METHOD FillControl()
   METHOD Control_Click( wpar )
   METHOD LeaTipo( cName )
   METHOD LeaDato( cName, cPropmet, cDefault )
   METHOD LeaDatoStatus( cName, cPropmet, cDefault )
   METHOD LeaDatoLogic( cName, cPropmet, cDefault )
   METHOD LeaRow( cName )
   METHOD LeaRowF( cName )
   METHOD LeaCol( cName )
   METHOD LeaColF( cName )
   METHOD Clean( cFValue )
   METHOD LeaDato_Oop( cName, cPropmet, cDefault )
   METHOD Save( Cas )
ENDCLASS

*------------------------------------------------------------------------------*
METHOD VD( cItem1, myIde ) CLASS TForm1
*------------------------------------------------------------------------------*
local nNumcont:=0
   Public swcursor := 0, myhandle := 0, cFBackcolor := ::cFBackcolor, swkm:=.F., swordenfd:=.F.

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
   ::Monthcalendarcount   := nNumcont
   ::Hyperlinkcount       := nNumcont
   ::Richeditboxcount     := nNumcont
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
   ::cFBackcolor          := ::myIde:cdbackcolor
   ::cFFontName           := ::myIde:cFormDefFontName
   ::nFFontSize           := ::myIde:nFormDefFontSize
   ::cFFontColor          := ::myIde:cFormDefFontColor
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
   ::csfontname           := 'MS Sans Serif'          // todo: revisar
   ::nsfontsize           := 9
   ::cscolor              := ''
   ::cscobj               := ''
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
   ::cfonmaximize         := ""
   ::cfonminimize         := ""

   form_main:Title := 'ooHG IDE Plus - Form designer'
   form_main:frame_1:Caption := "Form: " + cItem1
   ::myIde:Disable_Button()
   ::What( cItem1 )
Return Self

*------------------------------------------------------------------------------*
METHOD VerifyBar() CLASS TForm1
*------------------------------------------------------------------------------*
   IF ! myform:lsstat
      cvccontrols.control_30.Visible := .T.
      myform:lsstat := .T.

      DEFINE STATUSBAR of form_1
         IF Len( myform:cscaption ) > 0
            STATUSITEM myform:cscaption
         ELSE
            STATUSITEM ""
         ENDIF
         IF myform:lskeyboard
            KEYBOARD
         ENDIF
         IF myform:lsdate
            DATE WIDTH 95
         ENDIF
         IF myform:lstime
            CLOCK WIDTH 85
         ENDIF
      END STATUSBAR
   ELSE
      cvccontrols.control_30.Visible := .F.
      myform:lsstat := .F.
      form_1.Statusbar.Release
   ENDIF
   myform:lfsave := .F.
RETURN NIL

*------------------------------------------------------------------------------*
METHOD What( cItem ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL nPos, cName

   ::cForm := cItem
   nPos := RAt( '\', cItem )
   cName := SubStr( cItem, nPos + 1 )
   nPos := RAt( ".", cName )
   IF nPos > 0
      cName := SubStr( cName, 1, nPos - 1 )
   ENDIF
   ::cFname := Lower( cName )

   ::lsStat := .F.
   cvcControls.control_30.Visible := .F.
   Form_Main:butt_status:Value := .F.
   IF File( cItem )
      ::Open( cItem )
   ELSE
      ::New()
   ENDIF
   CursorArrow()
RETURN

*------------------------------------------------------------------------------*
METHOD IniArray( nform, ncontrolwl, controlname, ctypectrl, noanade ) CLASS TForm1
*------------------------------------------------------------------------------*
   // inicia array de controles para la forma actual
   WITH OBJECT myform
      IF noanade == NIL
         aAdd( :acontrolw, controlname )
         aAdd( :actrltype, ctypectrl )
         aAdd( :aenabled, .T. )
         aAdd( :avisible, .T. )
         aAdd( :afontname, "" )
         aAdd( :afontsize, 0 )
         aAdd( :abold, .F. )
         aAdd( :abackcolor, "NIL" )
         aAdd( :afontcolor, "NIL" )
         aAdd( :afontitalic, .F. )
         aAdd( :afontunderline, .F. )
         aAdd( :afontstrikeout, .F. )
         aAdd( :atransparent, .T. )
         aAdd( :acaption, "" )
         aAdd( :apicture, "" )
         aAdd( :avalue, "" )
         aAdd( :avaluen, 0 )
         aAdd( :avaluel, .F. )
         aAdd( :atooltip, "" )
         aAdd( :amaxlength, 30 )
         aAdd( :awrap, .F. )
         aAdd( :aincrement, 0 )
         aAdd( :auppercase, .F. )
         aAdd( :apassword, .F. )
         aAdd( :anumeric, .F. )
         aAdd( :ainputmasK, "" )
         aAdd( :auppercase, .F. )
         aAdd( :alowercase, .F. )
         aAdd( :aaction, "" )
         aAdd( :aopaque, .F. )
         aAdd( :arange, "" )
         aAdd( :anotabstop, .F. )
         aAdd( :asort, .F. )
         aAdd( :afile, "" )
         aAdd( :ainvisible, .F. )
         aAdd( :aautoplay, .F. )
         aAdd( :acenter, .F. )
         aAdd( :acenteralign, .F. )
         aAdd( :atransparent, .F. )
         aAdd( :ashownone, .F. )
         aAdd( :aupdown, .F. )
         aAdd( :areadonly, .F. )
         aAdd( :avertical, .F. )
         aAdd( :asmooth, .F. )
         aAdd( :anoticks, .F. )
         aAdd( :aboth, .F. )
         aAdd( :atop, .F. )
         aAdd( :aleft, .F. )
         aAdd( :abreak, .F. )
         aAdd( :aitems,  "" )
         aAdd( :aitemsource, "" )
         aAdd( :avaluesource, "" )
         aAdd( :amultiselect, .F. )
         aAdd( :ahelpid, 0 )
         aAdd( :aspacing, 0 )
         aAdd( :aheaders, "{'one', 'two'}" )
         aAdd( :awidths, '{60, 60}' )
         aAdd( :aonheadclick, '' )
         aAdd( :anolines, .F. )
         aAdd( :aimage, '' )
         aAdd( :astretch, .F. )
         aAdd( :aworkarea, 'Alias()' )
         aAdd( :afields, '' )
         aAdd( :afield, '' )
         aAdd( :avalid, '' )
         aAdd( :awhen, '' )
         aAdd( :avalidmess, '' )
         aAdd( :areadonlyb, '' )
         aAdd( :alock, .F. )
         aAdd( :adelete, .F. )
         aAdd( :ajustify, '' )
         aAdd( :adate, .F. )
         aAdd( :aongotfocus, "" )
         aAdd( :aonchange, "" )
         aAdd( :aonlostfocus, "" )
         aAdd( :aonenter, "" )
         aAdd( :aondisplaychange, "" )
         aAdd( :aondblclick, "" )
         aAdd( :arightalign, .F. )
         aAdd( :anotoday, .F. )
         aAdd( :anotodaycircle, .F. )
         aAdd( :aweeknumbers, .F. )
         aAdd( :aaddress, "" )
         aAdd( :ahandcursor, .F. )
         aAdd( :atabpage, {'', 0} )    
         aAdd( :aname, controlname )
         aAdd( :anumber, 0 )
         aAdd( :aflat, .F. )
         aAdd( :abuttons, .F. )
         aAdd( :ahottrack, .F. )
         aAdd( :adisplayedit, .F. )
         aAdd( :Anodeimages, '' )
         aAdd( :Aitemimages, ''  )
         aAdd( :ANorootbutton, .F. )
         aAdd( :AItemids, .F. )
         aAdd( :Anovscroll, .F. )
         aAdd( :Anohscroll, .F. )
         aAdd( :Adynamicbackcolor, "" )
         aAdd( :Adynamicforecolor, "" )
         aAdd( :Acolumncontrols, "" )
         aAdd( :Aoneditcell, "" )
         aAdd( :Aonappend, "" )
         aAdd( :Ainplace, .T. )
         aAdd( :Aedit, .F. )
         aAdd( :Aappend, .F. )
         aAdd( :Aclientedge, .F. )
         aAdd( :afocusedpos, -2 )
         aAdd( :aspeed, 1 )
         aAdd( :acobj, '' )
         aAdd( :aborder, .F. )
         aAdd( :aonenter, '' )
         aAdd( ::aAction2, "" )
      ELSE
         z:=ncontrolwl
         myAdel( "myform:acontrolw", z )
         myAdel( "myform:actrltype", z )
         myAdel( "myform:aenabled", z )
         myAdel( "myform:avisible", z )
         myAdel( "myform:afontname", z )
         myAdel( "myform:afontsize", z )
         myAdel( "myform:abold", z )
         myAdel( "myform:abackcolor", z )
         myAdel( "myform:afontcolor", z )
         myAdel( "myform:afontitalic", z )
         myAdel( "myform:afontunderline", z )
         myAdel( "myform:afontstrikeout", z )
         myAdel( "myform:atransparent", z )
         myAdel( "myform:acaption", z )
         myAdel( "myform:apicture", z )
         myAdel( "myform:avalue", z )
         myAdel( "myform:avaluen", z )
         myAdel( "myform:avaluel", z )
         myAdel( "myform:atooltip", z )
         myAdel( "myform:amaxlength", z )
         myAdel( "myform:awrap", z )
         myAdel( "myform:aincrement", z )
         myAdel( "myform:auppercase", z )
         myAdel( "myform:apassword", z )
         myAdel( "myform:anumeric", z )
         myAdel( "myform:ainputmasK", z )
         myAdel( "myform:auppercase", z )
         myAdel( "myform:alowercase", z )
         myAdel( "myform:aaction", z )
         myAdel( "myform:aopaque", z )
         myAdel( "myform:arange", z )
         myAdel( "myform:anotabstop", z )
         myAdel( "myform:asort", z )
         myAdel( "myform:afile", z )
         myAdel( "myform:ainvisible", z )
         myAdel( "myform:aautoplay", z )
         myAdel( "myform:acenter", z )
         myAdel( "myform:acenteralign", z )
         myAdel( "myform:atransparent", z )
         myAdel( "myform:ashownone", z )
         myAdel( "myform:aupdown", z )
         myAdel( "myform:areadonly", z )
         myAdel( "myform:avertical", z )
         myAdel( "myform:asmooth", z )
         myAdel( "myform:anoticks", z )
         myAdel( "myform:aboth", z )
         myAdel( "myform:atop", z )
         myAdel( "myform:aleft", z )
         myAdel( "myform:abreak", z )
         myAdel( "myform:aitems",  z )
         myAdel( "myform:aitemsource", z )
         myAdel( "myform:avaluesource", z )
         myAdel( "myform:amultiselect", z )
         myAdel( "myform:ahelpid", z )
         myAdel( "myform:aspacing", z )
         myAdel( "myform:aheaders", z )
         myAdel( "myform:awidths", z )
         myAdel( "myform:aonheadclick", z )
         myAdel( "myform:anolines", z )
         myAdel( "myform:aimage", z )
         myAdel( "myform:astretch", z )
         myAdel( "myform:aworkarea", z )
         myAdel( "myform:afields", z )
         myAdel( "myform:afield", z )
         myAdel( "myform:avalid", z )
         myAdel( "myform:awhen", z )
         myAdel( "myform:avalidmess", z )
         myAdel( "myform:areadonlyb", z )
         myAdel( "myform:alock", z )
         myAdel( "myform:adelete", z )
         myAdel( "myform:ajustify", z )
         myAdel( "myform:adate", z )
         myAdel( "myform:aongotfocus", z )
         myAdel( "myform:aonchange", z )
         myAdel( "myform:aonlostfocus", z )
         myAdel( "myform:aonenter", z )
         myAdel( "myform:aondisplaychange", z )
         myAdel( "myform:aondblclick", z )
         myAdel( "myform:arightalign", z )
         myAdel( "myform:anotoday", z )
         myAdel( "myform:anotodaycircle", z )
         myAdel( "myform:aweeknumbers", z )
         myAdel( "myform:aaddress", z )
         myAdel( "myform:ahandcursor", z )
         myAdel( "myform:atabpage", z )
         myAdel( "myform:aname", z )
         myAdel( "myform:anumber", z )
         myAdel( "myform:aflat", z )
         myAdel( "myform:abuttons", z )
         myAdel( "myform:ahottrack", z )
         myAdel( "myform:adisplayedit", z )
         myAdel( "myform:Anodeimages", z )
         myAdel( "myform:Aitemimages", z  )
         myAdel( "myform:ANorootbutton", z )
         myAdel( "myform:AItemids", z )
         myAdel( "myform:Anovscroll", z )
         myAdel( "myform:Anohscroll", z )
         myAdel( "myform:Adynamicbackcolor", z )
         myAdel( "myform:Adynamicforecolor", z )
         myAdel( "myform:Acolumncontrols", z )
         myAdel( "myform:Aoneditcell", z )
         myAdel( "myform:Aonappend", z )
         myAdel( "myform:Ainplace", z )
         myAdel( "myform:Aedit", z )
         myAdel( "myform:Aappend", z )
         myAdel( "myform:Aclientedge", z )
         myAdel( "myform:afocusedpos", z )  // pb
         myAdel( "myform:aspeed", z )
         myAdel( "myform:acobj", z)         //gca
         myAdel( "myform:aonenter", z )     //gca
         myAdel( "myform:aborder", z )      // gca
         :ncontrolw --
         IF :ncontrolw == 1
            myhandle := 0
            nhandlep := 0
         ENDIF
      ENDIF
   END
RETURN

*------------------------------------------------------------------------------*
STATIC FUNCTION myadel(arreglo,z)
*------------------------------------------------------------------------------*
q:=z
adel(&arreglo,q)
asize(&arreglo,len(&arreglo)-1)
return nil

*------------------------------------------------------------------------------*
STATIC FUNCTION ms( myIde )
*------------------------------------------------------------------------------*
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
            GetControlObject( cnombretab,"form_1"):show()
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
              GetControlObject( cnombretab,"form_1"):show()
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
LOCAL aName, x, i, swBorrado

// TODO: los controles definidos acá deber ser iguales a los definidos en las function p(Control)
   WITH OBJECT myform
      swkm := .F.
      DO CASE
      CASE :CurrentControl == 1
         x := chiffram()
         IF x > 0
            Dibuja1( x )
            RETURN
         ENDIF
      CASE :CurrentControl == 2
         :ButtonCount ++
         ControlName := 'button_' + LTrim( Str( :ButtonCount ) )
         DO WHILE IsControlDefined( &Controlname, Form_1 )
            :ButtonCount ++
            ControlName := 'button_' + LTrim( Str( :Buttoncount ) )
         enddo
         :nControlW ++
         :IniArray( :nForm, :nControlW, ControlName, 'BUTTON' )
         :aaction[:ncontrolw] := "MsgInfo( 'Button pressed' )"
         @ _oohg_mouserow, _oohg_mousecol BUTTON &ControlName OF Form_1 ;
            CAPTION ControlName ;
            ON GOTFOCUS Dibuja( This:Name ) ;
            ACTION Dibuja( This:Name ) ;
            NOTABSTOP
         :abackcolor[:ncontrolw] := cFBackcolor
         ProcessContainers( ControlName, ::myIde )
      CASE :CurrentControl == 3
         :CheckBoxCount ++
         ControlName := 'checkbox_' + LTrim( Str( :CheckBoxCount ) )
         DO WHILE IsControlDefined( &Controlname, Form_1 )
            :CheckBoxCount ++
            ControlName := 'checkbox_' + LTrim( Str( :CheckBoxCount ) )
         enddo
         :nControlW ++
         :IniArray( :nForm, :nControlW, ControlName, 'CHECKBOX' )
         @ _oohg_mouserow,_oohg_mousecol CHECKBOX &ControlName OF Form_1 ;
            CAPTION ControlName ;
            ON GOTFOCUS Dibuja( This:Name ) ;
            ON CHANGE Dibuja( This:Name ) ;
            NOTABSTOP
         :abackcolor[:ncontrolw] := cFBackcolor
         IF cFBackcolor # 'NIL' .AND. Len( cFBackcolor ) > 0
            GetControlObject( ControlName, "Form_1" ):BackColor:= &cFBackcolor
         ENDIF
         ProcessContainers( ControlName, ::myIde )
   CASE :CurrentControl == 4
      :ListBoxCount ++
      ControlName := 'list_' + LTrim( Str( :ListBoxcount ) )
      DO WHILE IsControlDefined( &Controlname, Form_1 )
         :ListBoxCount ++
         ControlName := 'list_' + LTrim( Str( :ListBoxCount ) )
      ENDDO
      aName := { ControlName }
      :nControlW ++
      @ _oohg_mouserow, _oohg_mousecol LISTBOX &ControlName OF Form_1 ;
         WIDTH 100 ;
         HEIGHT 100 ;
         ITEMS aName ;
         ON GOTFOCUS Dibuja( This:Name ) ;
         ON CHANGE Dibuja( This:Name ) ;
         NOTABSTOP
      :IniArray( :nForm, :nControlW, ControlName, 'LIST')
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 5
      :ComboBoxCount++
      ControlName := 'combo_'+Alltrim(str(:ComboBoxCount))
                do while iscontroldefined(&Controlname,form_1)
                    :ComboBoxCount++
                   ControlName := 'combo_'+Alltrim(str(:ComboboxCount))
                enddo
      aName := { ControlName,' ' }
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol COMBOBOX &ControlName OF Form_1 ;
         WIDTH 100 ;
         HEIGHT 100 ;
         ITEMS aName ;
         VALUE 1 ;
         ON GOTFOCUS Dibuja( This:Name ) ;
         NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'COMBO')
      ProcessContainers( ControlName, ::myIde )
   CASE :CurrentControl == 6
      :CheckButtonCount ++
      ControlName := 'checkbtn_' + LTrim( Str( :CheckButtonCount ) )
      DO WHILE IsControlDefined( &Controlname, Form_1 )
         :CheckButtonCount ++
         ControlName := 'checkbtn_' + LTrim( Str( :CheckbuttonCount ) )
      ENDDO
      :nControlW ++
      @ _oohg_mouserow, _oohg_mousecol CHECKBUTTON &ControlName OF Form_1 ;
         CAPTION ControlName ;
         ON GOTFOCUS Dibuja( This:Name ) ;
         ON CHANGE Dibuja( This:Name) ;
         NOTABSTOP
      :IniArray( :nForm, :nControlW, ControlName, 'CHECKBTN' )
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 7
      :GridCount ++
      ControlName := 'grid_' + LTrim( Str( :GridCount ) )
      DO WHILE IsControlDefined( &Controlname, Form_1 )
         :GridCount ++
         ControlName := 'grid_' + LTrim( Str( :GridCount ) )
      ENDDO
      aName := { { ControlName, ''} }
      :nControlw ++
      @ _oohg_mouserow, _oohg_mousecol GRID &ControlName OF Form_1 ;
         HEADERS {'', ''} ;
         WIDTHS {60, 60} ;
         ITEMS aName ;
         TOOLTIP 'To move/size click on header area' ;
         ON GOTFOCUS Dibuja( This:Name )
      :IniArray( :nForm, :nControlW, ControlName, 'GRID' )
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 8
      :frameCount++
      ControlName := 'frame_'+Alltrim(str(:FrameCount))
                do while iscontroldefined(&Controlname,form_1)
         :frameCount++
                   ControlName := 'frame_'+Alltrim(str(:FrameCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'FRAME')
      @ _oohg_mouserow, _oohg_mousecol FRAME &ControlName OF Form_1 CAPTION ControlName WIDTH 140 HEIGHT 140
                :abackcolor[:ncontrolw]:=cFBackcolor
         IF cFBackcolor # 'NIL' .AND. Len( cFBackcolor ) > 0
                   GetControlObject( controlname,"form_1"):backcolor:= &cFBackcolor
                ENDIF
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 9
      :TabCount++
      ControlName := 'tab_'+Alltrim(str(:TabCount))
                do while iscontroldefined(&Controlname,form_1)
                   :TabCount++
                   ControlName := 'tab_'+Alltrim(str(:TabCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'TAB')
      DEFINE TAB &ControlName OF Form_1 AT _oohg_mouserow,_oohg_mousecol WIDTH 300 HEIGHT 250 TOOLTIP Controlname ON CHANGE dibuja(this:name)
         DEFINE PAGE 'Page 1' IMAGE ' '
         END PAGE
         DEFINE PAGE 'Page 2' IMAGE ' '
                        END PAGE
      END TAB
***               :atabpage[:ncontrolw,2]=NIL
                :acaption[:ncontrolw]="{'Page 1','Page 2'}"
                :aimage[:ncontrolw]="{' ',' '}"
                :swtab:=.T.
   Case :CurrentControl == 10
      :ImageCount++
      ControlName := 'image_'+Alltrim(str(:ImageCount))
                do while iscontroldefined(&Controlname,form_1)
         :ImageCount++
                   ControlName := 'image_'+Alltrim(str(:ImageCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'IMAGE')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 100 VALUE ControlName BORDER ACTION dibuja(this:name)

      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 11
      :AnimateCount++
      ControlName := 'animate_'+Alltrim(str(:AnimateCount))
                do while iscontroldefined(&Controlname,form_1)
                   :AnimateCount++
                   ControlName := 'animate_'+Alltrim(str(:AnimateCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'ANIMATE')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 50 VALUE ControlName BORDER ACTION dibuja(this:name)
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 12
      :DatePickerCount++
      ControlName := 'datepicker_'+Alltrim(str(:DatePickerCount))
                do while iscontroldefined(&Controlname,form_1)
            :DatePickerCount++
                   ControlName := 'datepicker_'+Alltrim(str(:DatePickerCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'DATEPICKER')
      @ _oohg_mouserow,_oohg_mousecol DATEPICKER &ControlName OF Form_1 TOOLTIP ControlName ;
                ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 13
      :TextBoxCount++
      ControlName := 'text_'+Alltrim(str(:TextBoxCount))
                do while iscontroldefined(&Controlname,form_1)
              :TextBoxCount++
                   ControlName := 'text_'+Alltrim(str(:TextBoxcount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 24 BACKCOLOR WHITE CLIENTEDGE ACTION dibuja(this:name)
                GetControlObject( controlname,"form_1"):value:=controlname
                :iniarray(:nform,:ncontrolw,controlname,'TEXT')
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 14
      :EditBoxCount++
      ControlName := 'edit_'+Alltrim(str(:EditBoxCount))
                do while iscontroldefined(&Controlname,form_1)
           :EditBoxCount++
                    ControlName := 'edit_'+Alltrim(str(:EditBoxcount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 120 VALUE ControlName BACKCOLOR WHITE CLIENTEDGE HSCROLL VSCROLL ACTION dibuja(this:name)
                :iniarray(:nform,:ncontrolw,controlname,'EDIT')
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 15
                :LabelCount++
      ControlName := 'label_'+Alltrim(str(:LabelCount))
                do while iscontroldefined(&Controlname,form_1)
                   :LabelCount++
                   ControlName := 'label_'+Alltrim(str(:LabelCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 VALUE ControlName  ACTION dibuja(this:name)
                GetControlObject( controlname,"form_1"):value:= "Empty label"
                :iniarray(:nform,:ncontrolw,controlname,'LABEL')
                :abackcolor[:ncontrolw]:=cFBackcolor
         IF cFBackcolor # 'NIL' .AND. Len( cFBackcolor ) > 0
            GetControlObject( ControlName, "Form_1" ):BackColor:= &cFBackcolor
         ENDIF
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 16
      :PlayerCount++
      ControlName := 'player_'+Alltrim(str(:PlayerCount))
                do while iscontroldefined(&Controlname,form_1)
                    :PlayerCount++
                   ControlName := 'player_'+Alltrim(str(:PlayerCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 100 VALUE ControlName BORDER ACTION dibuja(this:name) 
                :iniarray(:nform,:ncontrolw,controlname,'PLAYER')
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 17
      :ProgressBarCount++
      ControlName := 'progressbar_'+Alltrim(str(:ProgressBarCount))
                do while iscontroldefined(&Controlname,form_1)
                  :ProgressBarCount++
                   ControlName := 'progressbar_'+Alltrim(str(:ProgressBarCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 26 VALUE Controlname BORDER ACTION dibuja(this:name)
                :iniarray(:nform,:ncontrolw,controlname,'PROGRESSBAR')
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 18
      :RadioGroupCount++
      ControlName := 'radiogroup_'+Alltrim(str(:RadioGroupCount))
                do while iscontroldefined(&Controlname,form_1)
         :RadioGroupCount++
                   ControlName := 'radiogroup_'+Alltrim(str(:RadioGroupCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 25*2+8 VALUE ControlName BORDER ACTION dibuja(this:name) 
                :iniarray(:nform,:ncontrolw,controlname,'RADIOGROUP')
                :abackcolor[:ncontrolw]:=cFBackcolor
                IF cFBackcolor # 'NIL' .AND. Len( cFBackcolor ) > 0
                   GetControlObject( ControlName, "Form_1" ):BackColor:= &cFBackcolor
                ENDIF
                :aitems[:ncontrolw]:="{'option 1','option 2'}"
                :aspacing[:ncontrolw]:=25
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 19
      :SliderCount++
      ControlName := 'slider_'+Alltrim(str(:SliderCount))
                do while iscontroldefined(&Controlname,form_1)
         :SliderCount++
                   ControlName := 'slider_'+Alltrim(str(:SliderCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol SLIDER &ControlName OF Form_1 RANGE 1,10 VALUE 5 ON CHANGE dibuja(this:name) NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'SLIDER')
                :abackcolor[:ncontrolw]:=cFBackcolor
         IF cFBackcolor # 'NIL' .AND. Len( cFBackcolor ) > 0
            GetControlObject( ControlName, "Form_1" ):BackColor:= &cFBackcolor
         ENDIF
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 20
      :SpinnerCount++
      ControlName := 'spinner_'+Alltrim(str(:SpinnerCount))
                do while iscontroldefined(&Controlname,form_1)
         :SpinnerCount++
                   ControlName := 'spinner_'+Alltrim(str(:SpinnerCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 24 VALUE ControlName BACKCOLOR WHITE CLIENTEDGE VSCROLL ACTION dibuja(this:name)
                :iniarray(:nform,:ncontrolw,controlname,'SPINNER')
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 21
      :CheckButtonCount++
      ControlName := 'piccheckbutt_'+Alltrim(str(:CheckButtonCount))
                do while iscontroldefined(&Controlname,form_1)
         :CheckButtonCount++
                   ControlName := 'piccheckbutt_'+Alltrim(str(:CheckButtonCount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol CHECKBUTTON &ControlName OF Form_1 PICTURE 'A4' WIDTH 30 HEIGHT 30 VALUE .F. ON GOTFOCUS dibuja(this:name) ON CHANGE dibuja(this:name) NOTABSTOP
                :iniarray(:nform,:ncontrolw,controlname,'PICCHECKBUTT')
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 22
      :ButtonCount++
      ControlName := 'picbutt_'+Alltrim(str(:ButtonCount))
                do while iscontroldefined(&Controlname,form_1)
         :ButtonCount++
                   ControlName := 'picbutt_'+Alltrim(str(:ButtonCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'PICBUTT')
                :aaction[:ncontrolw]:="msginfo('Pic button pressed')"
      @ _oohg_mouserow,_oohg_mousecol BUTTON &ControlName OF Form_1 ;
         PICTURE 'A4' ;
         WIDTH 30 ;
         HEIGHT 30 ;
         ON GOTFOCUS Dibuja( This:Name ) ;
         ACTION Dibuja( This:Name ) ;
         NOTABSTOP
      ProcessContainers( ControlName, ::myIde )
         Case :CurrentControl == 23
      :TimerCount++
      ControlName := 'timer_'+Alltrim(str(:timerCount))
                do while iscontroldefined(&Controlname,form_1)
         :timerCount++
                   ControlName := 'timer_'+Alltrim(str(:timerCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'TIMER')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 100 HEIGHT 20 VALUE ControlName BORDER ACTION dibuja(this:name) 
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 24
      :BrowseCount++
         ControlName := 'browse_'+Alltrim(str(:browseCount))
                do while iscontroldefined(&Controlname,form_1)
            :browseCount++
                   ControlName := 'browse_'+Alltrim(str(:browseCount))
                enddo
      aName := { { ControlName ,''} }
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'BROWSE')
      @ _oohg_mouserow,_oohg_mousecol GRID &ControlName OF Form_1 HEADERS {'one','two'} WIDTHS {60,60} ITEMS aName TOOLTIP 'To move/size click on header area' ON GOTFOCUS dibuja(this:name)
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 25
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

      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 26
      :IpaddressCount ++
      ControlName := 'ipaddress_' + LTrim( Str( :ipaddressCount ) )
      DO WHILE IsControlDefined( &Controlname, Form_1 )
         :ipaddressCount ++
         ControlName := 'ipaddress_' + LTrim( Str( :ipaddressCount ) )
      ENDDO
      :nControlW ++
      :IniArray( :nform, :ncontrolw, ControlName, 'IPADDRESS' )
      @ _oohg_mouserow, _oohg_mousecol LABEL &ControlName OF Form_1 ;
         VALUE '   .   .   .   ' ;
         BACKCOLOR WHITE ;
         CLIENTEDGE ;
         ACTION Dibuja( This:Name )
      ProcessContainers( ControlName, ::myIde )
   Case :CurrentControl == 27
      :MonthcalendarCount++
         ControlName := 'monthcal_'+Alltrim(str(:monthcalendarCount))
                do while iscontroldefined(&Controlname,form_1)
            :monthcalendarCount++
                   ControlName := 'monthcal_'+Alltrim(str(:monthcalendarCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'MONTHCALENDAR')
      @ _oohg_mouserow,_oohg_mousecol MONTHCALENDAR &ControlName OF Form_1  NOTABSTOP ON CHANGE dibuja(this:name)
      ProcessContainers( ControlName, ::myIde )
        Case :CurrentControl == 28
      :hyperlinkCount++
         ControlName := 'Hyperlink_'+Alltrim(str(:HyperlinkCount))
                Do while iscontroldefined(&Controlname,form_1)
         :hyperlinkCount++
                   ControlName := 'Hyperlink_'+Alltrim(str(:HyperlinkCount))
                enddo
                :ncontrolw++
                :iniarray(:nform,:ncontrolw,controlname,'HYPERLINK')
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 VALUE Controlname ACTION dibuja(this:name) BORDER
      ProcessContainers( ControlName, ::myIde )
        case :CurrentControl ==29
           :richeditBoxCount++
      ControlName := 'richeditbox_'+Alltrim(str(:richeditboxCount))
                do while iscontroldefined(&Controlname,form_1)
              :richeditBoxCount++
                   ControlName := 'richeditbox_'+Alltrim(str(:richeditboxcount))
                enddo
                :ncontrolw++
      @ _oohg_mouserow,_oohg_mousecol LABEL &ControlName OF Form_1 WIDTH 120 HEIGHT 124 BACKCOLOR WHITE CLIENTEDGE ACTION dibuja(this:name)
                GetControlObject( controlname,"form_1"):value:= controlname
                :iniarray(:nform,:ncontrolw,controlname,'RICHEDIT')
      ProcessContainers( ControlName, ::myIde )
   EndCase
           :control_click(1)
           :lFsave:=.F.

           mispuntos()
           muestrasino()
end
Return

*------------------------------------------------------------------------------*
FUNCTION borracon()    /////// para futuro uso
*------------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
FUNCTION Dibuja( xName )
*------------------------------------------------------------------------------*
LOCAL cValor := Lower( xName )
   Dibuja1( aScan( GetFormObject( 'Form_1' ):aControls, { |o| Lower( o:Name ) == cValor } ) )
RETURN NIL

*------------------------------------------------------------------------------*
FUNCTION Dibuja1( h )
*------------------------------------------------------------------------------*
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
METHOD Open( cFMG )  CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, j, nContlin, cForma, nStart, nEnd

   cForma := MemoRead( cFMG )
   nContlin := MLCount( cForma )

   FOR i := 1 TO nContlin
      aAdd( myform:aline, ' ' + MemoLine( cForma, 800, i ) )
      IF myform:aline[i] # NIL
         IF At( "DEFINE WINDOW", myform:aline[i] ) # 0 .OR. ( At( "@ ", myform:aline[i] ) > 0 .AND. At( ",", myform:aline[i] ) > 0 )
            myform:ncontrolw ++
            IF At( "WINDOW", myform:aline[i] ) > 0
               // Form, after WINDOW should come TEMPLATE, but everything is accepted and ignored
               nStart := At( "WINDOW", myform:aline[i] ) + 7
               nEnd := Len( myform:aline[i] )
            ELSE
               // Control, skip nCol
               nStart := At( ',', myform:aline[i] ) + 1
               FOR j := nStart TO Len( myform:aline[i] )
                  // Stop at the first letter
                  IF Asc( SubStr( myform:aline[i], j, 1 ) ) >= 65
                     EXIT
                  ENDIF
               NEXT j
               // Skip control type
               nStart := j
               FOR j := nStart TO Len( myform:aline[i] )
                  // Stop at the first space
                  IF SubStr( myform:aline[i], j, 1) == " "
                     EXIT
                  ENDIF
               NEXT j
               nEnd := j
            ENDIF
            // Get name
            cvcControl := SubStr( myform:aline[i], nEnd + 1 )
            cvcControl := StrTran( cvcControl, ";", "" )
            cvcControl := StrTran( cvcControl, chr(10), "" )
            cvcControl := StrTran( cvcControl, chr(13), "" )
            cvcControl := StrTran( cvcControl, " ", "" )
            myform:IniArray( myform:nform, myform:ncontrolw, cvcControl, '' )
            myform:aspeed[myform:ncontrolw] := i
         ENDIF
      ELSE
         EXIT
      ENDIF
   NEXT i

   FOR i := 1 TO ( myform:ncontrolw - 1 )
       myform:anumber[i] := myform:aspeed[i+1] - 1
   NEXT i

   myform:anumber[myform:ncontrolw] := nContlin
   myform:NewAgain()
RETURN NIL

*------------------------------------------------------------------------------*
METHOD New() CLASS TForm1
*------------------------------------------------------------------------------*
   IF ! IsWindowDefined( Form_1 )
      cFBackcolor := myform:cFBackcolor

      DEFINE WINDOW Form_1 OBJ Form_1 ;
         AT ::myIde:mainheight + 46 ,66 ;
         WIDTH 700 ;
         HEIGHT 410 ;
         TITLE 'Form' ICON 'VD' ;
         CHILD ;
         ON MOUSECLICK myform:AddControl() ;
         ON DBLCLICK Properties_Click( ::myIde ) ;
         ON MOUSEMOVE cordenada() ;
         ON MOUSEDRAG ms( ::myIde ) ;
         ON GOTFOCUS mispuntos() ;
         ON PAINT {|| refrefo(), mispuntos() } ;
         BACKCOLOR &( myform:cFBackcolor ) ;
         FONT ::cFFontName ;
         SIZE ::nFFontSize ;
         FONTCOLOR &( ::cFFontColor ) ;
         NOMAXIMIZE NOMINIMIZE

         DEFINE CONTEXT MENU
            ITEM 'Properties' ACTION Properties_Click( ::myIde )
            ITEM 'Events    ' NAME events ACTION Events_click( ::myIde )
            ITEM 'Interactive Font/Color' ACTION intfoco( 1, ::myIde )
            ITEM 'Manual Move/Size' ACTION manualmosi( 1, ::myIde )
            ITEM 'Interactive Move' ACTION MoveControl( ::myIde )
            ITEM 'Keyboard Move' ACTION kMove( ::myIde )
            ITEM 'Interactive Size' ACTION SizeControl()
            SEPARATOR
            ITEM 'Delete' ACTION DeleteControl()
         END MENU

         ON KEY DELETE ACTION DeleteControl()
         ON KEY F1 ACTION Help_F1( 'FORMEDIT' )
         ON KEY ALT+D ACTION Debug()
      END WINDOW

      DEFINE WINDOW Lista OBJ Lista ;
         AT 120, 665 ;
         WIDTH 300 ;
         HEIGHT 450 ;
         CLIENTAREA ;
         TITLE 'Control Inspector' ;
         ICON 'Edit' ;
         CHILD ;
         NOMAXIMIZE NOMINIMIZE ;
         NOSIZE ;
         BACKCOLOR ::myIde:asystemcolor ;
         ON INIT oListaCon:Height := SetHeightForWholeRows( oListaCon, 18 )

         @ 20, 10 GRID ListaCon OBJ oListaCon ;
            WIDTH 280 ;
            HEIGHT 400  ;
            headers {'Name', 'Row', 'Col', 'Width', 'Height', 'int-name'} ;
            WIDTHS {80, 40, 40, 45, 50, 0 } ;
            FONT "Arial" ;
            SIZE 10 ;
            INPLACE EDIT ;
            READONLY {.T., .F., .F., .F., .F., .T.}  ;
            JUSTIFY {GRID_JTFY_LEFT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_LEFT}  ;
            FULLMOVE ;
            ON GOTFOCUS MuestraSiNo() ;
            ON EDITCELL ValidaPos( oListaCon )

// TODO: This context should open on the control clicked and not the control selected in the form
         DEFINE CONTEXT MENU CONTROL ListaCon OF Lista
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

         @ 420, 30 LABEL lop1 VALUE "Click or enter to modify position or dimension." FONT "Calibri" SIZE 9 AUTOSIZE
         @ 435, 30 LABEL lop2 VALUE "Use right click to display more options." FONT "Calibri" SIZE 9 AUTOSIZE
      END WINDOW

      form_main:Show()
      cvcControls:Show()

      ::myIde:form_activated := .T.

////////// importante añadir el primer elemento
      myform:nControlW ++
      myform:IniArray( myform:nForm, myform:nControlW, "TEMPLATE", 'FORM' )

      ACTIVATE WINDOW Lista NOWAIT
      ACTIVATE WINDOW Form_1
   ENDIF
RETURN

*------------------------------------------------------------------------------*
STATIC FUNCTION ValidaPos( oListaCon )
*------------------------------------------------------------------------------*
wvalue:=this.cellrowindex
cname:=olistacon:cell(wvalue,6)
oname:=GetControlObject( cname,"form_1")
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

*------------------------------------------------------------------------------*
METHOD NewAgain() CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL nFWidth, nFHeight

   IF IsWindowDefined( Form_1 )
      MsgStop( 'Can only edit one form at a time.', 'OOHG IDE+' )
   ELSE
      CursorWait()
      waitmess:hmi_label_101:Value := 'Loading Form....'
      waitmess:Show()

      // Do not force a font when form has none, use OOHG default
      ::cFFontName  := ::Clean( ::LeaDato( 'WINDOW', 'FONT', '' ) )
      ::nFFontSize  := Val( ::LeaDato( 'WINDOW', 'SIZE', '0' ) )
      ::cFBackcolor := ::LeaDato( 'WINDOW', 'BACKCOLOR', 'NIL' )
      nFWidth       := Val( ::LeaDato( 'WINDOW', 'WIDTH', '640' ) )
      nFHeight      := Val( ::LeaDato( 'WINDOW', 'HEIGHT', '480' ) )
      ::nfvirtualw  := Val( ::LeaDato( 'WINDOW', 'VIRTUAL WIDTH', '0' ) )
      ::nfvirtualh  := Val( ::LeaDato( 'WINDOW', 'VIRTUAL HEIGHT', '0' ) )

      DEFINE WINDOW Form_1 OBJ Form_1 ;
         AT ::myIde:mainheight + 42, 66 ;
         WIDTH nFWidth ;
         HEIGHT nFHeight ;
         TITLE 'Title' ;
         ICON 'VD' ;
         CHILD NOSHOW  ;
         ON MOUSECLICK ::AddControl()  ;
         ON DBLCLICK Properties_Click( ::myIde ) ;
         ON MOUSEMOVE Cordenada() ;
         ON MOUSEDRAG ms( ::myIde ) ;
         ON GOTFOCUS MisPuntos() ;
         ON PAINT {|| RefreFo(), MisPuntos() } ;
         BACKCOLOR &( ::cFBackcolor ) ;
         FONT ::cFFontName ;
         SIZE ::nFFontSize ;
         FONTCOLOR &( ::cFFontColor ) ;
         NOMAXIMIZE NOMINIMIZE

         DEFINE CONTEXT MENU
            ITEM 'Properties' ACTION Properties_Click( ::myIde )
            ITEM 'Events    ' NAME events ACTION Events_click( ::myIde )
            ITEM 'Interactive Font/Color' ACTION intfoco( 1, ::myIde )
            ITEM 'Manual Move/Size' ACTION manualmosi( 1, ::myIde )
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

      DEFINE WINDOW Lista OBJ Lista ;
         AT 120, 665 ;                                  
         WIDTH 300 ;
         HEIGHT 450 ;
         CLIENTAREA ;
         TITLE 'Control Inspector' ;
         ICON 'Edit' ;
         CHILD ;
         NOMAXIMIZE NOMINIMIZE ;
         NOSIZE ;
         BACKCOLOR ::myIde:asystemcolor ;
         ON INIT oListaCon:Height := SetHeightForWholeRows( oListaCon, 18 )

         @ 20, 10 GRID ListaCon OBJ oListaCon ;
            WIDTH 280 ;
            HEIGHT 400  ;
            headers {'Name', 'Row', 'Col', 'Width', 'Height', 'int-name'} ;
            WIDTHS {80, 40, 40, 45, 50, 0 } ;
            FONT "Arial" ;
            SIZE 10 ;
            INPLACE EDIT ;
            READONLY {.T., .F., .F., .F., .F., .T.}  ;
            JUSTIFY {GRID_JTFY_LEFT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_LEFT}  ;
            FULLMOVE ;
            ON GOTFOCUS MuestraSiNo() ;
            ON EDITCELL ValidaPos( oListaCon )

         DEFINE CONTEXT MENU CONTROL ListaCon OF Lista
            ITEM 'Properties' ACTION Properties_Click( ::myIde )
            ITEM 'Events    ' NAME events ACTION Events_click( ::myIde )
            ITEM 'Interactive Font/Color' ACTION IntFoco( 1, ::myIde )
            ITEM 'Manual Move/Size' ACTION ManualMosi( 1, ::myIde )
            ITEM 'Interactive Move' ACTION MoveControl( ::myIde )
            ITEM 'Keyboard Move' ACTION kMove( ::myIde )
            ITEM 'Interactive Size' ACTION SizeControl()
            SEPARATOR
            ITEM 'Delete' ACTION DeleteControl()
         END MENU

         @ 420, 30 LABEL lop1 VALUE "Click or enter to modify position or dimension." FONT "Calibri" SIZE 9 AUTOSIZE
         @ 435, 30 LABEL lop2 VALUE "Use right click to display more options." FONT "Calibri" SIZE 9 AUTOSIZE
      END WINDOW

      form_main:Show()
      cvcControls:Show()

      ::myIde:form_activated := .T.
      ::FillControl()
      MuestraSiNo()

      tMyToolb:Abrir()
      ZAP
      cTitulo := 'Toolbar'                   // TODO: remove ?
      IF File( ::cFName + '.tbr' )
         APPEND FROM ( ::cFName + '.tbr' )
      ENDIF

      tbParsea( tmytoolb )
      USE

      ACTIVATE WINDOW form_1, lista
   ENDIF
RETURN  NIL

*------------------------------------------------------------------------------*
METHOD FillControl() CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, cTipo

   WITH OBJECT myForm
      :swTab := .F.

********************** Load statusbar data
      FOR i := 1 TO Len( :aLine )
         IF At( Upper( 'DEFINE STATUSBAR' ), Upper( :aLine[i] ) ) # 0
            :lsstat := .T.
            form_main:butt_status:Value := .T.
            cvccontrols.control_30.Visible := .T.

            :csCaption  := :Clean( :LeaDato( 'DEFINE STATUSBAR', 'STATUSITEM', '' ) )
            :nsWidth    := Val( :LeaDato( 'DEFINE STATUSBAR', 'WIDTH', '0' ) )
            :csAction   := :LeaDato( 'DEFINE STATUSBAR', 'ACTION', '' )
            :csIcon     := :LeaDato( 'DEFINE STATUSBAR', 'ICON', '' )
            :lsFlat     := ( :LeaDatoLogic( 'DEFINE STATUSBAR', 'FLAT', 'F' ) == "T" )
            :lsRaised   := ( :LeaDatoLogic( 'DEFINE STATUSBAR', 'RAISED', 'F' ) == "T" )
            :csToolTip  := :LeaDato('DEFINE STATUSBAR','TOOLTIP', '' )
            :lsDate     := ( :LeaDatoLogic('DEFINE STATUSBAR','DATE', 'F' ) == "T" )
            :lsTime     := ( :LeaDatoLogic('DEFINE STATUSBAR','CLOCK', 'F' ) == "T" )
            :lsKeyboard := ( :LeaDatoLogic('DEFINE STATUSBAR','KEYBOARD', 'F' ) == "T" )
            :cscObj     := :LeaDato('DEFINE STATUSBAR','OBJ','')
            EXIT
         ELSE
            :lsstat := .F.

            form_main:butt_status:Value := .F.
            cvccontrols.control_30.Visible := .F.
         ENDIF
      NEXT i

********************** Controls
      FOR i := 1 TO :nControlW
         IF i == 1
           cTipo := 'FORM'
         ELSE
           cTipo := :LeaTipo( :aControlW[i] )
         ENDIF

/*
   Por cada nuevo control se debe agregar un CASE llamando a la función que carga las propiedades desde el form.
   Por cada nueva propiedad se debe agrebar una línea en la correspondiente p(función) para cargar su valor desde el form.
*/
         DO CASE
         CASE cTipo == 'DEFINE'
            :aCtrlType[i] := 'STATUSBAR'
         CASE cTipo == 'FORM'
            pForma( i )
         CASE cTipo == 'BUTTON'
            pButton( i, ::myIde )
         CASE cTipo == "CHECKBOX"
            pCheckBox( i, ::myIde )
         CASE cTipo == "LISTBOX"
            pListBox( i, ::myIde )
         CASE cTipo == 'COMBOBOX'
            pComboBox( i, ::myIde )
         CASE cTipo == 'CHECKBTN'
            pCheckBtn( i, ::myIde )
         CASE cTipo == 'PICCHECKBUTT'
              pPicCheckButt( i, ::myIde )
         CASE cTipo == "PICBUTT"
            pPicButt( i, ::myIde )
         CASE cTipo == "IMAGE"
            pImage( i, ::myIde )
         CASE cTipo == "ANIMATEBOX"
            pAnimateBox( i, ::myIde )
         CASE cTipo == "DATEPICKER"
            pDatePicker( i, ::myIde )
         CASE cTipo == 'GRID'
            pGrid( i, ::myIde )
         CASE cTipo == 'BROWSE'
            pBrowse( i, ::myIde )
         CASE cTipo == 'FRAME'
            pFrame( i, ::myIde )
         CASE cTipo == "TEXTBOX"
            pTextBox( i, ::myIde )
         CASE cTipo == "EDITBOX"
            pEditBox( i, ::myIde )
         CASE cTipo == 'RADIOGROUP'
            pRadioGroup( i, ::myIde )
         CASE cTipo == "PROGRESSBAR"
            pProgressBar( i, ::myIde )
         CASE cTipo == 'SLIDER'
            pSlider( i, ::myIde )
         CASE cTipo == 'SPINNER'
            pSpinner( i, ::myIde )
         CASE cTipo == "PLAYER"
            pPlayer( i, ::myIde )
         CASE cTipo == 'LABEL'
            pLabel( i, ::myIde )
         CASE cTipo == "TIMER"
            pTimer( i, ::myIde )
         CASE cTipo == 'IPADDRESS'
            pIPAddress( i, ::myIde )
         CASE cTipo == 'MONTHCALENDAR'
            pMonthCal( i, ::myIde )
         CASE cTipo == 'HYPERLINK'
            pHypLink( i, ::myIde )
         CASE cTipo == 'TREE'
            pTree( i, ::myIde )
         CASE cTipo == 'RICHEDITBOX'
            pRichedit( i, ::myIde )
         CASE cTipo == 'TAB'
            :swTab := .T.
            pTab( i )
         ENDCASE
      NEXT i

      CLOSE DATABASES
      lDeleted := SET( _SET_DELETED, .T. )

********************** Toolbar
      IF File( :cfname + '.tbr' )
         archivo := :cfname + '.tbr'
         SELECT 10
         USE &archivo EXCLUSIVE ALIAS dtoolbar
         GO TOP
         IF ! Eof()
            aPar  := {}
            wVar  := dtoolbar->auxit
            nPosi := 1
            nPosf := 1
            IF Len( AllTrim( wVar ) ) == 0
               wvar := 'toolbar_1, 65, 65, , .F., .F., .F., .T., Arial, 10, .F., .F., .F., .F., 0, 0, 0'
            ENDIF
            FOR i := 1 TO Len( wVar )
               IF SubStr( wvar, i, 1 ) == ','
                  nPosf := i
                  aAdd( Apar, AllTrim( SubStr( wvar, nPosi, nPosf - nPosi ) ) )
                  nPosi := nPosf + 1
               ENDIF
            NEXT i
            aAdd( aPar, Alltrim( SubStr( wVar, nPosi ) ) )

            nw := Val( aPar[2] )
            nh := Val( aPar[3] )
            tmytoolb:nwidth  := nw
            tmytoolb:nheight := nh

            DEFINE TOOLBAR hmitb OF form_1  ;
               BUTTONSIZE nw, nh

               i := 1
               GO TOP
               DO WHILE ! Eof()
                  wCaption := LTrim( RTrim( dtoolbar->item ) )
                  cName := "hmi_cvc_tb_button_" + AllTrim( Str( i, 2 ) )
                  BUTTON &cName ;
                     CAPTION wCaption ;
                     ACTION NIL

                  SKIP
                  i ++
               ENDDO
            END TOOLBAR
         ENDIF

         CLOSE DATABASES
      ENDIF

*********************** Menu
      DEFINE MAIN MENU OF Form_1
         IF File( :cfname + '.mnm' )
            archivo := :cfname + '.mnm'
            SELECT 20
            USE &archivo EXCLUSIVE ALIAS menues
            GO TOP
            swpop := 0
            IF ! Eof()
               DO WHILE ! Eof()
                  SKIP
                  IF Eof()
                     signiv := 0
                  ELSE
                     signiv := menues->level
                  ENDIF
                  SKIP -1

                  niv := menues->level
                  IF signiv > menues->level
                     IF Lower( RTrim( menues->auxit ) ) == 'separator'
                        SEPARATOR
                     ELSE
                        POPUP AllTrim( menues->auxit )
                        swpop ++
                     ENDIF
                  ELSE
                     IF Lower( RTrim( menues->auxit ) ) == 'separator'
                        SEPARATOR
                     ELSE
                        ITEM AllTrim( auxit ) ACTION NIL
                        IF ! RTrim( menues->named ) == ''
                           IF menues->checked == 'X'
                             /// cc:=:cfname+'.'+trim(named)+'.checked:=.T.'
                             /// output+= cc + CRLF
                           ENDIF
                           IF menues->enabled == 'X'
                              ///cc:=:cfname+'.'+trim(named)+'.enabled:=.F.'
                              ///output+= cc + CRLF
                           ENDIF
                        ENDIF
                     ENDIF

                     DO WHILE signiv < niv
                        END POPUP
                        swpop --
                        niv --
                     ENDDO
                  ENDIF

                  SKIP
               ENDDO

               nnivaux := niv - 1
               DO WHILE swpop > 0
                  nnivaux --
                  END POPUP
                  swpop --
               ENDDO
            ENDIF

            CLOSE DATABASES
         ENDIF
      END MENU

      SET( _SET_DELETED, lDeleted )

********************** Show statusbar
      waitmess:Hide()
      form_1:Show()
      IF :lsstat
         DEFINE STATUSBAR of form_1
            IF Len( :csCaption ) > 0
               STATUSITEM :cscaption
            ELSE
               STATUSITEM " "
            ENDIF
            IF :lsKeyboard
               KEYBOARD
            ENDIF
            IF :lsDate
               DATE WIDTH 95
            ENDIF
            IF :lsTime
               CLOCK WIDTH 85
            ENDIF
         END STATUSBAR
      ENDIF

      IF :nControlW == 1
         myHandle := 0
         nHandleP := 0
      ENDIF

      form_main:Show()
      cvccontrols:Show()
      CursorArrow()
   END WITH
RETURN NIL

*------------------------------------------------------------------------------*
METHOD Control_Click( wpar ) CLASS TForm1
*------------------------------------------------------------------------------*
   IF lsi
      FOR i := 1 TO 29
         cccontrol := 'Control_' + PadL( LTrim( Str( i, 2 ) ), 2, '0' )
         lsi := .F.
         cvccontrols:&(cccontrol):Value := .F.
      NEXT i
      myform:CurrentControl := wpar
      cccontrol := 'Control_' + PadL( LTrim( Str( wpar, 2 ) ), 2, '0' )
      lsi := .F.
      cvccontrols:&(cccontrol):Value := .T.
   ELSE
      lsi := .T.
   ENDIF
RETURN NIL

*------------------------------------------------------------------------------*
METHOD LeaTipo( cName ) CLASS TForm1
*------------------------------------------------------------------------------*
Local q, r, s, cRegresa := '', zi, zl, cvc

   cvc := aScan( myform:acontrolw, { |c| Lower( c ) == Lower( cName ) } )
   zi  := IIF( cvc > 0, myform:aspeed[cvc], 1)
   zl  := IIF( cvc > 0, myform:anumber[cvc], Len( myform:aline ) )

   FOR q := zi TO zl
      s := At( ' ' + Upper( cname ) + ' ', Upper( myform:aline[q] ) )
      If s > 0
         FOR r := 1 TO s
            IF Asc( SubStr( myform:aline[q], r, 1 ) ) >= 65
               cRegresa := AllTrim( SubStr( myform:aline[q], r, s - r ) )
               EXIT
            ENDIF
         NEXT r
         EXIT
      ENDIF
   NEXT q

   IF Upper( cRegresa ) == 'CHECKBUTTON'
      IF myform:LeaDatoLogic( cname, 'CAPTION', '' ) ==  'T'
         cRegresa := 'CHECKBTN'
      ELSE
         cRegresa := 'PICCHECKBUTT'
      ENDIF
   ENDIF
   IF Upper( cRegresa ) == 'BUTTON'
      IF myform:LeaDatoLogic( cname, 'CAPTION', '' ) == 'T'
         cRegresa := 'BUTTON'
      ELSE
         cRegresa := 'PICBUTT'
      ENDIF
   ENDIF
RETURN cRegresa

*------------------------------------------------------------------------------*
METHOD LeaDato( cName, cPropmet, cDefault ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, sw := 0, zi, cvc, zl, nPos, cFValue

   cvc := aScan( myform:acontrolw, { |c| Lower( c ) == Lower( cName ) } )
   zi  := IIF( cvc > 0, myform:aspeed[cvc], 1 )
   zl  := IIF( cvc > 0, myform:anumber[cvc], Len( myform:aline ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ' , Upper( myform:aline[i] ) ) # 0 .AND. sw == 0  ///// ubica el control en la forma y a partir de ahí busca la propiedad
         sw := 1
      ELSE
         IF sw == 1
            IF Len( RTrim( myform:aline[i] ) ) == 0
               RETURN cDefault
            ENDIF
            nPos := At( ' ' + Upper( cPropmet ) + ' ', Upper( myform:aline[i] ) )
            IF nPos > 0
               cFValue := SubStr( myform:aline[i], nPos + Len( cPropmet ) + 2 )
               cFValue := RTrim( cFValue)
               IF Right( cFValue, 1 ) == ";"
                  cFValue := SubStr( cFValue, 1, Len( cFValue ) - 1 )
               ENDIF
               cFValue := AllTrim( cFValue )
               IF Len( cFValue ) == 0
                  RETURN cDefault
               ELSE
                  RETURN cFValue
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

*------------------------------------------------------------------------------*
METHOD LeaDatoStatus( cName, cPropmet, cDefault ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, sw := 0, zi, cvc, zl, nPos, cFValue

   cvc := aScan( myform:acontrolw, { |c| Lower( c ) == Lower( cName ) } )
   zi  := IIF( cvc > 0, myform:aspeed[cvc], 1 )
   zl  := IIF( cvc > 0, myform:anumber[cvc], Len( myform:aline ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ' , Upper( myform:aline[i] ) ) # 0 .AND. sw == 0
         sw := 1
      ELSE
         IF sw == 1
            IF Len( RTrim( myform:aline[i] ) ) == 0
               RETURN cDefault
            ENDIF
            nPos := At( ' ' + Upper( cPropmet ) + ' ', Upper( myform:aline[i] ) )
            IF nPos > 0
               cFValue := SubStr( myform:aline[i], nPos + Len( cPropmet ) + 2 )
               cFValue := RTrim( cFValue)
               IF Right( cFValue, 1 ) == ";"
                  cFValue := SubStr( cFValue, 1, Len( cFValue ) - 1 )
               ENDIF
               cFValue := AllTrim( cFValue )
               IF Len( cFValue ) == 0
                  RETURN cDefault
               ELSE
                  RETURN cFValue
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

*------------------------------------------------------------------------------*
METHOD LeaDatoLogic( cName, cPropmet, cDefault ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, sw := 0, zi, cvc, zl

   cvc := aScan( myform:acontrolw, { |c| Lower( c ) == Lower( cName ) } )
   zi  := IIF( cvc > 0, myform:aspeed[cvc], 1 )
   zl  := IIF( cvc > 0, myform:anumber[cvc], Len( myform:aline ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ', Upper( myform:aline[i] ) ) # 0 .AND. sw == 0
         sw := 1
      ELSE
         IF sw == 1
            IF Len( RTrim( myform:aline[i] ) ) == 0
               RETURN cDefault
            ENDIF
            IF At( ' ' + Upper( cPropmet ) + ' ', Upper( myform:aline[i] ) ) > 0
               RETURN 'T'
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

*------------------------------------------------------------------------------*
METHOD LeaRow( cName ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, nPos, nRow := '0', zi, zl, cvc

   cvc := aScan( myform:acontrolw, { |c| Lower( c ) == Lower( cName ) } )
   zi := IIF( cvc > 0, myform:aspeed[cvc], 1 )
   zl := IIF( cvc > 0, myform:anumber[cvc], Len( myform:aline ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cname ) + ' ', Upper( myform:aline[i] ) ) # 0
         nPos := At( ",", myform:aline[i] )
         nRow := Left( myform:aline[i], nPos - 1 )
         nRow := StrTran( nRow, "@", "" )
         EXIT
      ENDIF
   NEXT i
RETURN nRow

*------------------------------------------------------------------------------*
METHOD LeaRowF( cName ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, nPos1, nPos2, nRow := '0', zi, zl, cvc

   cvc := aScan( myform:acontrolw, { |c| Lower( c ) == Lower( cName ) } )
   zi := IIF( cvc > 0, myform:aspeed[cvc], 1 )
   zl := IIF( cvc > 0, myform:anumber[cvc], Len( myform:aline ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( 'WINDOW' ) + ' ', Upper( myform:aline[i] ) ) # 0
         nPos1 := At( "AT", Upper(myform:aline[i + 1] ) )
         nPos2 := At( ",", myform:aline[i + 1])
         nRow := SubStr( myform:aline[i + 1], nPos1 + 3, Len( myform:aline[i + 1] ) - nPos2 )
         EXIT
      ENDIF
   NEXT i
RETURN nRow

*------------------------------------------------------------------------------*
METHOD LeaCol( cName ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, nPos, nCol := '0', zi, zl, cvc

   cvc := aScan( myform:acontrolw, { |c| Lower( c ) == Lower( cName ) } )
   zi := IIF( cvc > 0, myform:aspeed[cvc], 1 )
   zl := IIF( cvc > 0, myform:anumber[cvc], Len( myform:aline ) )
   For i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ', Upper( myform:aline[i] ) ) # 0
         nPos := At( ",", myform:aline[i] )
         nCol := SubStr( myform:aline[i], nPos + 1 )
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

*------------------------------------------------------------------------------*
METHOD LeaColF( cName ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, nPos, nCol := '0', zi, zl, cvc

   cvc := aScan( myform:acontrolw, { |c| Lower( c ) == Lower( cName ) } )
   zi := IIF( cvc > 0, myform:aspeed[cvc], 1 )
   zl := IIF( cvc > 0, myform:anumber[cvc], Len( myform:aline ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( 'WINDOW' ) + ' ', Upper( myform:aline[i] ) ) # 0
         nPos := At( ",", myform:aline[i + 1] )
         nCol := RTrim( SubStr( myform:aline[i + 1], nPos + 1 ) )
         IF Right( nCol, 1 ) == ";"
            nCol := SubStr( nCol, 1, Len( nCol ) - 1 )
         ENDIF
         EXIT
      ENDIF
   NEXT i
RETURN nCol

*------------------------------------------------------------------------------*
METHOD Clean( cData ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL cIni, cFin

   cIni := Left( cData, 1 )
   cFin := Right( cData, 1 )
   IF cIni == "'" .or. cIni == '"'
      IF cIni == cFin
         cData := SubStr( cData, 2, Len( cData ) - 2 )
      ENDIF
   ENDIF
RETURN cData

*------------------------------------------------------------------------------*
METHOD LeaDato_Oop( cName, cPropmet, cDefault ) CLASS TForm1
*------------------------------------------------------------------------------*
LOCAL i, zi, zl, cvc, nPos

   cvc := aScan( ::acontrolw, { |c| Lower( c ) == Lower( cName) } )
   zi := IIF( cvc > 0, ::aspeed[cvc], 1 )
   zl := IIF( cvc > 0, ::anumber[cvc], Len( ::aline ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( ::cFname ) + '.' + Upper( cName ) + '.' + Upper( cPropmet ), Upper( ::aline[i] ) ) > 0
         nPos := RAt( '=', ::aline[i] ) + 1
         IF nPos > 1
            RETURN RTrim( SubStr( ::aline[i], nPos ) )
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

/*
*------------------------------------------------------------------------------*
FUNCTION nTabPages( k )
*------------------------------------------------------------------------------*
local cname
if hb_isNumeric(k)
   cname:=myform:acontrolw[k]
endif
sw:=0
return nil
*/

*------------------------------------------------------------------------------*
FUNCTION MisPuntos()
*------------------------------------------------------------------------------*
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

RETURN NIL

// TODO: change all p(Control) functions to methods, change myform: by ::, and myIde by ::myIde
*------------------------------------------------------------------------------*
STATIC FUNCTION pTree( i, myIde )
*------------------------------------------------------------------------------*
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip, cOnChange, cOnGotFocus, cOnLostFocus, cOnDblClick, cNodeimages, cItemimages, lNoRootButton, lItemIds, nHelpId

   // Load properties
   cName         := myform:acontrolw[i]
   cObj          := myform:LeaDato( cName, 'OBJ', '' )
   nRow          := Val( myform:LeaDato( cName, 'AT', '100' ) )
   nCol          := Val( myform:LeaCol( cName ) )
   nWidth        := Val( myform:LeaDato( cName, 'WIDTH', '120' ) )              // use control's default value
   nHeight       := Val( myform:LeaDato( cName, 'HEIGHT', '120' ) )              // use control's default value
   cFontName     := myform:Clean( myform:LeaDato( cName, 'FONT', '' ) )
   nFontSize     := Val( myform:LeaDato( cName, 'SIZE', '0' ) )
   aFontColor    := myform:LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor    := myform:LeaDato_Oop( cName, 'FONTCOLOR', aFontColor )
   lBold         := ( myform:LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold         := ( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic       := ( myform:LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic       := ( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline    := ( myform:LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline    := ( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout    := ( myform:LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout    := ( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor    := myform:LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := myform:LeaDato_Oop( cName, 'BACKCOLOR', aBackColor )
   lVisible      := ( myform:LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( myform:LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( myform:LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip      := myform:Clean( myform:LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange     := myform:LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus   := myform:LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus  := myform:LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick   := myform:LeaDato( cName, 'ON DBLCLICK', '' )
   cNodeImages   := myform:LeaDato( cName, 'NODEIMAGES', '' )
   cItemImages   := myform:LeaDato( cName, 'ITEMIMAGES', '' )
   lNoRootButton := ( myform:LeaDatoLogic( cName, 'NOROOTBUTTON', "F" ) == "T" )
   lItemIds      := ( myform:LeaDatoLogic( cName, 'ITEMIDS', "F" ) == "T" )
   nHelpId       := Val( myform:LeaDato( cName, 'HELPID', '0' ) )

   // Show control
   DEFINE TREE &cName OF Form_1 ;
      AT nRow, nCol ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      NOTABSTOP ;
      ON GOTFOCUS Dibuja( this:name ) ;
      ON CHANGE Dibuja( this:name )

      NODE 'Tree'
      END NODE

      NODE 'Nodes'
      END NODE
   END TREE
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      Form_1:&cName:FontColor  := &aFontColor
   ENDIF
   Form_1:&cName:FontBold      := lBold
   Form_1:&cName:FontItalic    := lItalic
   Form_1:&cName:FontUnderline := lUnderline
   Form_1:&cName:FontStrikeout := lStrikeout
   IF aBackColor # 'NIL'
      Form_1:&cName:BackColor  := &aBackColor
   ENDIF
   Form_1:&cName:ToolTip       := cToolTip

   // Save properties
   myform:aCtrlType[i]      := 'TREE'
   myform:aName[i]          := cName
   myform:acObj[i]          := cObj
   myform:aFontName[i]      := cFontName
   myform:aFontSize[i]      := nFontSize
   myform:aFontColor[i]     := aFontColor
   myForm:aBold[i]          := lBold
   myForm:aFontItalic[i]    := lItalic
   myForm:aFontUnderline[i] := lUnderline
   myForm:aFontStrikeout[i] := lStrikeout
   myform:aBackColor[i]     := aBackColor
   myform:aVisible[i]       := lVisible
   myform:aEnabled[i]       := lEnabled
   myform:aToolTip[i]       := cToolTip
   myform:aOnChange[i]      := cOnChange
   myform:aOnGotFocus[i]    := cOnGotFocus
   myform:aOnLostFocus[i]   := cOnLostFocus
   myform:aOnDblClick[i]    := cOnDblClick
   myform:aNodeImages[i]    := cNodeImages
   myform:aItemImages[i]    := cItemImages
   myform:aNoRootButton[i]  := lNoRootButton
   myform:aItemIds[i]       := lItemIds
   myform:aHelpId[i]        := nHelpId

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pTab(i)
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='TAB'
   myform:aname[i]:=cName

   ncol:=val(myform:LeaCol( cName))
   nrow:=val(myform:LeaDato(cName,'AT','100'))
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   nwidth:=val(myform:LeaDato(cName,'WIDTH','0')) 
   nheight:=val(myform:LeaDato(cName,'HEIGHT','0')) 
   nvalue:=(myform:LeaDato(cName,'VALUE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   cimage:=myform:Clean( myform:LeaDato(cName,'IMAGE',''))
   conchange:=myform:LeaDato(cName,'ON CHANGE','')
   lflat:=myform:LeaDatoLogic(cName,'FLAT',"F")
   lvertical:=myform:LeaDatoLogic(cName,'VERTICAL',"F")
   lbuttons:=myform:LeaDatoLogic(cName,'BUTTONS',"F")
   lhottrack:=myform:LeaDatoLogic(cName,'HOTTRACK',"F")
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj

   DEFINE TAB &cName OF Form_1 ;
      AT nrow, ncol ;
      WIDTH nwidth ;
      HEIGHT nheight    ;
      TOOLTIP 'Properties and events right click on header area' ;
      ON CHANGE Dibuja( This:Name ) ;
      NOTABSTOP

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
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:atooltip[i]:=ctooltip
   myform:aimage[i]:=cimage


   myform:aenabled[i] := iif( upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i] := iif( upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   ocontrol:=GetControlObject( cName,"form_1")

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTITALIC','.F.')) == '.T.',.T.,.F.)


   form_1:&cName:fontunderline:=myform:afontunderline[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTUNDERLINE','.F.')) == '.T.',.T.,.F.)


  form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTSTRIKEOUT','.F.')) == '.T.',.T.,.F.)


   form_1:&cName:fontbold:=myform:abold[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTBOLD','.F.')) == '.T.',.T.,.F.)

   myform:afontcolor[i]:= myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF


   myform:avalue[i]:=nValue
   myform:aonchange[i]:=conchange

   CuantosPage( cName )

return

*------------------------------------------------------------------------------*
STATIC FUNCTION pIpAddress( i, myIde )
*------------------------------------------------------------------------------*
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cValue, cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip, cOnChange, cOngotfocus, cOnLostfocus, nHelpId, lNoTabStop

   // Load properties
   cName        := myform:acontrolw[i]
   cObj         := myform:LeaDato( cName, 'OBJ', '' )
   nRow         := Val( myform:LeaRow( cName ) )
   nCol         := Val( myform:LeaCol( cName ) )
   nWidth       := Val( myform:LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( myform:LeaDato( cName, 'HEIGHT', '24' ) )
   cValue       := myform:LeaDato( cName, 'VALUE', '' )
   cFontName    := myform:Clean( myform:LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( myform:LeaDato( cName, 'SIZE', '0' ) )
   aFontColor   := myform:LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := myform:LeaDato_Oop( cName, 'FONTCOLOR', aFontColor )
   lBold        := ( myform:LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( myform:LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( myform:LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( myform:LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := myform:LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := myform:LeaDato_Oop( cName, 'BACKCOLOR', aBackColor )
   lVisible     := ( myform:LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( myform:LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( myform:LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := myform:Clean( myform:LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange    := myform:LeaDato( cName, 'ON CHANGE', '' )
   cOnGotfocus  := myform:LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostfocus := myform:LeaDato( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( myform:LeaDato( cName, 'HELPID', '0' ) )
   lNoTabStop   := ( myform:LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )

   // Show control
   @ nRow, nCol LABEL &cName ;
      OF Form_1 ;
      VALUE IIF( Empty( cValue ), '   .   .   .   ', cValue ) ;
      BACKCOLOR WHITE ;
      CLIENTEDGE ;
      ACTION Dibuja( This:Name )
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      Form_1:&cName:FontColor  := &aFontColor
   ENDIF
   Form_1:&cName:FontBold      := lBold
   Form_1:&cName:FontItalic    := lItalic
   Form_1:&cName:FontUnderline := lUnderline
   Form_1:&cName:FontStrikeout := lStrikeout
   IF aBackColor # 'NIL'
      Form_1:&cName:BackColor  := &aBackColor
   ENDIF
   Form_1:&cName:ToolTip       := cToolTip

   // Save properties
   myform:aCtrlType[i]      := 'IPADDRESS'
   myform:aName[i]          := cName
   myform:acObj[i]          := cObj
   myform:aValue[i]         := cValue
   myform:aFontName[i]      := cFontName
   myform:aFontSize[i]      := nFontSize
   myform:aFontColor[i]     := aFontColor
   myForm:aBold[i]          := lBold
   myForm:aFontItalic[i]    := lItalic
   myForm:aFontUnderline[i] := lUnderline
   myForm:aFontStrikeout[i] := lStrikeout
   myform:aBackColor[i]     := aBackColor
   myform:aVisible[i]       := lVisible
   myform:aEnabled[i]       := lEnabled
   myform:aToolTip[i]       := cToolTip
   myform:aOnChange[i]      := cOnChange
   myform:aOnGotFocus[i]    := cOnGotFocus
   myform:aOnLostFocus[i]   := cOnLostFocus
   myform:aHelpId[i]        := nHelpId
   myform:aNoTabStop[i]     := lNoTabStop

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pTimer( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='TIMER'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaDato(cName,'ROW','0'))
   ncol:=val(myform:LeaDato(cName,'COL','0'))
   ninterval:=val(myform:LeaDato(cName,'INTERVAL','1000'))
   caction:=myform:LeaDato(cName,'ACTION','')
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj
   @ nRow,nCol LABEL &cName OF Form_1 WIDTH 100 HEIGHT 20 VALUE cName BORDER ACTION dibuja(this:name)
   myform:avaluen[i]:=ninterval
   myform:aaction[i]:=caction
   myform:aenabled[i]:=iif( upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T. ,.F. )

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pForma(i)
*------------------------------------------------------------------------------*
LOCAL nFWidth, nFHeight

   myform:actrltype[i]:='FORM'
   nfrow:=val(myform:learowf( myform:cfname ) )
   nfcol:=val(myform:leacolf( myform:cfname ) )
   myform:cftitle:=myform:Clean( myform:LeaDato('WINDOW','TITLE',''))
   nFWidth:=val(myform:LeaDato('WINDOW','WIDTH','640'))
   nFHeight:=val(myform:LeaDato('WINDOW','HEIGHT','480'))+gettitleheight()
   myform:cfobj:=myform:LeaDato('WINDOW','OBJ','')
   myform:cficon:=myform:Clean( myform:LeaDato('WINDOW','ICON',''))
   myform:nfvirtualw:=val(myform:LeaDato('WINDOW','VIRTUAL WIDTH','0'))
   myform:nfvirtualh:=val(myform:LeaDato('WINDOW','VIRTUAL HEIGHT','0'))
   myform:lfmain:=myform:LeaDatoLogic('WINDOW',"MAIN","")
   myform:lfchild:=myform:LeaDatoLogic('WINDOW',"CHILD","")
   myform:lfmodal:=myform:LeaDatoLogic('WINDOW',"MODAL","")
   myform:lfnoshow:=myform:LeaDatoLogic('WINDOW',"NOSHOW","")
   myform:lftopmost:=myform:LeaDatoLogic('WINDOW',"TOPMOST","")
   myform:lfnominimize:=myform:LeaDatoLogic('WINDOW',"NOMINIMIZE","")
   myform:lfnomaximize:=myform:LeaDatoLogic('WINDOW',"NOMAXIMIZE","")
   myform:lfnosize:=myform:LeaDatoLogic('WINDOW',"NOSIZE","")
   myform:lfnosysmenu:=myform:LeaDatoLogic('WINDOW',"NOSYSMENU","")
   myform:lfnocaption:=myform:LeaDatoLogic('WINDOW',"NOCAPTION","")
   myform:lfnoautorelease:=myform:LeaDatoLogic('WINDOW',"NOAUTORELEASE","")
   myform:lfhelpbutton:=myform:LeaDatoLogic('WINDOW',"HELPBUTTON","")
   myform:lffocused:=myform:LeaDatoLogic('WINDOW',"FOCUSED","")
   myform:lfbreak:=myform:LeaDatoLogic('WINDOW',"BREAK","")
   myform:lfsplitchild:=myform:LeaDatoLogic('WINDOW',"SPLITCHILD","")
   myform:lfgrippertext:=myform:LeaDatoLogic('WINDOW',"GRIPPERTEXT","")
   myform:cfoninit:=myform:LeaDato('WINDOW','ON INIT','')
   myform:cfonrelease:=myform:LeaDato('WINDOW','ON RELEASE','')
   myform:cfoninteractiveclose:=myform:LeaDato('WINDOW','ON INTERACTIVECLOSE','')
   myform:cfonmouseclick:=myform:LeaDato('WINDOW','ON MOUSECLICK','')
   myform:cfonmousedrag:=myform:LeaDato('WINDOW','ON MOUSEDRAG','')
   myform:cfonmousemove:=myform:LeaDato('WINDOW','ON MOUSEMOVE','')
   myform:cfonsize:=myform:LeaDato('WINDOW','ON SIZE','')
   myform:cfonpaint:=myform:LeaDato('WINDOW','ON PAINT','')
   myform:cFBackcolor:=myform:LeaDato('WINDOW', 'BACKCOLOR', 'NIL')
   myform:cfcursor:=myform:LeaDato('WINDOW','CURSOR','')
   // Do not force a font when form has none, use OOHG default
   myform:cFFontName  := myform:Clean( myform:LeaDato( 'WINDOW', 'FONT', '' ) )
   myform:nFFontSize  := Val( myform:LeaDato( 'WINDOW', 'SIZE', '0' ) )
   myform:cFFontColor := myform:LeaDato( 'WINDOW', 'FONTCOLOR', 'NIL' )
   myform:cFFontColor := myform:LeaDato_Oop( 'WINDOW', 'FONTCOLOR', myform:cFFontColor )
   myform:cfnotifyicon:=myform:Clean( myform:LeaDato('WINDOW','NOTIFYICON',''))
   myform:cfnotifytooltip:=myform:Clean( myform:LeaDato('WINDOW','NOTIFYTOOLTIP',''))
   myform:cfonnotifyclick:=myform:LeaDato('WINDOW','ON NOTIFYCLICK','')
   myform:cfongotfocus:=myform:LeaDato('WINDOW','ON GOTFOCUS','')
   myform:cfonlostfocus:=myform:LeaDato('WINDOW','ON LOSTFOCUS','')
   myform:cfonscrollup:=myform:LeaDato('WINDOW','ON SCROLLUP','')
   myform:cfonscrolldown:=myform:LeaDato('WINDOW','ON SCROLLDOWN','')
   myform:cfonscrollright:=myform:LeaDato('WINDOW','ON SCROLLRIGHT','')
   myform:cfonscrollleft:=myform:LeaDato('WINDOW','ON SCROLLLEFT','')
   myform:cfonhscrollbox:=myform:LeaDato('WINDOW','ON HSCROLLBOX','')
   myform:cfonvscrollbox:=myform:LeaDato('WINDOW','ON VSCROLLBOX','')
   myform:cfonmaximize:=myform:LeaDato('WINDOW','ON MAXIMIZE','')
   myform:cfonminimize:=myform:LeaDato('WINDOW','ON MINIMIZE','')
   myform:lfmain:=iif(myform:lfmain='T',.T.,.F.)
   myform:lfmodal:=iif(myform:lfmodal='T',.T.,.F.)
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

   Form_1:Row       := nFRow
   Form_1:Col       := nFCol
   Form_1:Width     := nFWidth
   Form_1:Height    := nFHeight - GetTitleHeight()
   Form_1:Title     := myForm:cFTitle
   Form_1:cFontName := IIF( Empty( myform:cFFontName ), _OOHG_DefaultFontName, myform:cFFontName )
   Form_1:nFontSize := IIF( myform:nFFontSize > 0, myform:nFFontSize, _OOHG_DefaultFontSize )
   Form_1:FontColor := &( myform:cFFontColor )
RETURN NIL

*------------------------------------------------------------------------------*
STATIC FUNCTION pLabel( i, myIde )
*------------------------------------------------------------------------------*
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cAction, cToolTip, lBorder, lClientEdge, lVisible, lEnabled, lTrans, nHelpId, aBackColor, cValue, cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout, lRightAlign, lCenterAlign, lAutoSize, cInputMask

   // Load properties
   cName        := myform:acontrolw[i]
   cObj         := myform:LeaDato( cName, 'OBJ', '' )
   nRow         := Val( myform:LeaRow( cName))
   nCol         := Val( myform:LeaCol( cName))
   nWidth       := Val( myform:LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( myform:LeaDato( cName, 'HEIGHT', '24' ) )
   cAction      := myform:LeaDato( cName, 'ACTION', "" )
   cToolTip     := myform:Clean( myform:LeaDato( cName, 'TOOLTIP', '' ) )
   cToolTip     := myform:Clean( myform:LeaDato_Oop( cName, 'TOOLTIP', cToolTip ) )
   lBorder      := ( myform:LeaDatoLogic( cName, "BORDER", "F" ) == "T" )
   lClientEdge  := ( myform:LeaDatoLogic( cName, "CLIENTEDGE", "F") == "T" )
   lVisible     := ( myform:LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper(  myform:LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( myform:LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper(  myform:LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lTrans       := ( myform:LeaDatoLogic( cName, "TRANSPARENT", "T" ) == "T" )
   nHelpId      := Val( myform:LeaDato( cName, 'HELPID', '0' ) )
   aBackColor   := myform:LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := myform:LeaDato_Oop( cName, 'BACKCOLOR', aBackColor )
   cValue       := myform:Clean( myform:LeaDato( cName, 'VALUE', '' ) )
   cFontName    := myform:Clean( myform:LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( myform:LeaDato( cName, 'SIZE', '0' ) )
   aFontColor   := myform:LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := myform:LeaDato_Oop( cName, 'FONTCOLOR', aFontColor )
   lBold        := ( myform:LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( myform:LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( myform:LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( myform:LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lRightAlign  := ( myform:LeaDatoLogic( cName, "RIGHTALIGN", "F" ) == "T" )
   lCenterAlign := ( myform:LeaDatoLogic( cName, "CENTERALIGN", "F" ) == "T" )
   lAutoSize    := ( myform:LeaDatoLogic( cName, "AUTOSIZE", "F" ) == "T" )
   cInputMask   := myform:LeaDato( cName, 'INPUTMASK', "" )

   // Show control
   IF lRightAlign
      @ nRow, nCol LABEL &cName OF Form_1 ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         VALUE cValue ;
         RIGHTALIGN ;
         ACTION Dibuja( This:Name )
   ELSE
      IF lCenterAlign
         @ nRow, nCol LABEL &cName OF Form_1 ;
            WIDTH nWidth ;
            HEIGHT nHeight ;
            VALUE cValue ;
            CENTERALIGN ;
            ACTION Dibuja( This:Name )
      ELSE
         @ nRow, nCol LABEL &cName OF Form_1 ;
            WIDTH nWidth ;
            HEIGHT nHeight ;
            VALUE cValue ;
            ACTION Dibuja( This:Name )
      ENDIF
   ENDIF
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      Form_1:&cName:FontColor  := &aFontColor
   ENDIF
   Form_1:&cName:FontBold      := lBold
   Form_1:&cName:FontItalic    := lItalic
   Form_1:&cName:FontUnderline := lUnderline
   Form_1:&cName:FontStrikeout := lStrikeout
   IF aBackColor # 'NIL'
      Form_1:&cName:BackColor  := &aBackColor
   ENDIF
   Form_1:&cName:ToolTip       := cToolTip

   // Save properties
   myform:actrltype[i]      := 'LABEL'
   myform:aname[i]          := cName
   myform:acobj[i]          := cObj
   myform:aAction[i]        := cAction
   myform:aToolTip[i]       := cToolTip
   myform:aBorder[i]        := lBorder
   myform:aClientEdge[i]    := lClientEdge
   myform:aVisible[i]       := lVisible
   myform:aEnabled[i]       := lEnabled
   myform:aTransparent[i]   := lTrans
   myform:aHelpid[i]        := nHelpid
   myform:aBackColor[i]     := aBackColor
   myform:aValue[i]         := cValue
   myform:aFontName[i]      := cFontName
   myform:aFontSize[i]      := nFontSize
   myform:aFontColor[i]     := aFontColor
   myForm:aBold[i]          := lBold
   myForm:aFontItalic[i]    := lItalic
   myForm:aFontUnderline[i] := lUnderline
   myForm:aFontStrikeout[i] := lStrikeout
   myform:aRightAlign[i]    := lRightAlign
   myform:aCenterAlign[i]   := lCenterAlign
   myform:aAutoplay[i]      := lAutoSize
   myform:aInputMask[i]     := cInputMask

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pPlayer( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='PLAYER'
   myform:aname[i]:=myform:acontrolw[i]
   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))

   nWidth:=val(myform:LeaDato(cName,'WIDTH','0'))
   nHeight:=val(myform:LeaDato(cName,'HEIGHT','0'))
   cplayfile:=myform:Clean( myform:LeaDato(cName,'FILE',''))
   nHelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj

   @ nRow, nCol LABEL &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE cName ;
      BORDER ;
      ACTION Dibuja( This:Name )

   myform:aenabled[i]:=iif(upper( myform:LeaDato_Oop( cName,'ENABLED','.T.')) == '.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper( myform:LeaDato_Oop( cName,'VISIBLE','.T.')) == '.T.',.T.,.F.)

   myform:afile[i]:=cplayfile
   myform:ahelpid[i]:=nhelpid

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pSpinner( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='SPINNER'
   myform:aname[i]:=myform:acontrolw[i]
   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   cobj:=myform:LeaDato(cName,'OBJ','')
   crange:=myform:LeaDato(cName,'RANGE','1,10')
   nvalue:=val(myform:LeaDato(cName,'VALUE','0'))
   nwidth:=val(myform:LeaDato(cName,'WIDTH','120'))
   nheight:=val(myform:LeaDato(cName,'HEIGHT','24'))
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   conchange:=myform:LeaDato(cName,'ON CHANGE','')
   congotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   conlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   lNoTabStop:=myform:LeaDatoLogic(cName,'NOTABSTOP',"F")
   lwrap:=myform:LeaDatoLogic(cName,'WRAP',"F")
   lreadonly:=myform:LeaDatoLogic(cName,'READONLY',"F")
   nincrement:=val(myform:LeaDato(cName,'INCREMENT','0'))

    myform:acobj[i]:=cobj

   @ nRow,nCol LABEL &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE cName ;
      ACTION Dibuja( This:Name ) ;
      BACKCOLOR WHITE ;
      CLIENTEDGE ;
      VSCROLL

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=iif(upper( myform:LeaDato_Oop( cName,'ENABLED','.T.')) == '.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper( myform:LeaDato_Oop( cName,'VISIBLE','.T.')) == '.T.',.T.,.F.)

   form_1:&cName:fontitalic    := myform:afontitalic[i]    := iif( upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F.)
   form_1:&cName:fontunderline := myform:afontunderline[i] := iif( upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F.)
   form_1:&cName:fontstrikeout := myform:afontstrikeout[i] := iif( upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F.)
   form_1:&cName:fontbold      := myform:abold[i]          := iif( upper( myform:LeaDato_Oop( cName, 'FONTBOLD', '.F.' ) ) == '.T.', .T., .F.)

   cbackcolor:= myform:abackcolor[i] := myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:= myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF

   myform:arange[i]:=crange
   myform:ahelpid[i]:=nhelpid
   myform:avaluen[i]:=nvalue
   myform:atooltip[i]:=ctooltip
   form_1:&cName:tooltip:=ctooltip
   myform:aonchange[i]:=conchange
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus

   myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)

   myform:awrap[i]:=iif(lwrap='T',.T.,.F.)

   myform:areadonly[i]:=iif(lreadonly='T',.T.,.F.)

   myform:aincrement[i]:=nincrement

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pSlider( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='SLIDER'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   cobj:=myform:LeaDato(cName,'OBJ','')
   crange:=myform:LeaDato(cName,'RANGE','1,10')
   nvalue:=val(myform:LeaDato(cName,'VALUE','0'))
   nwidth:=val(myform:LeaDato(cName,'WIDTH','0'))
   nheight:=val(myform:LeaDato(cName,'HEIGHT','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   conchange:=myform:LeaDato(cName,'ON CHANGE','')
   lvertical:=myform:LeaDatoLogic(cName,'VERTICAL','F')
   lnoticks:=myform:LeaDatoLogic(cName,'NOTICKS','F')
   lboth:=myform:LeaDatoLogic(cName,'BOTH','F')
   ltop:=myform:LeaDatoLogic(cName,'TOP','F')
   lleft:=myform:LeaDatoLogic(cName,'LEFT','F')
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))

    myform:acobj[i]:=cobj

   myform:atooltip[i]:=ctooltip

   if lvertical="T"
      @ nRow, nCol SLIDER &cName OF Form_1 ;
         RANGE 1, 10 ;
         VALUE 5 ;
         WIDTH nwidth ;
         HEIGHT nheight ;
         ON CHANGE Dibuja( This:Name ) ;
         NOTABSTOP ;
         VERTICAL
   else
      @ nRow, nCol SLIDER &cName OF Form_1 ;
         RANGE 1, 10 ;
         VALUE 5 ;
         WIDTH nwidth ;
         HEIGHT nheight ;
         ON CHANGE Dibuja( This:Name ) ;
         NOTABSTOP
   endif

   myform:aenabled[i]:=iif(upper( myform:LeaDato_Oop( cName,'ENABLED','.T.')) == '.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper( myform:LeaDato_Oop( cName,'VISIBLE','.T.')) == '.T.',.T.,.F.)

   form_1:&cName:tooltip:=ctooltip

   myform:abackcolor[i]:= myform:LeaDato_Oop( cName, 'BACKCOLOR','NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF

   myform:avertical[i]:=iif(lvertical='T',.T.,.F.)

   myform:anoticks[i]:=iif(lnoticks='T',.T.,.F.)

   myform:aboth[i]:=iif(lboth='T',.T.,.F.)
   myform:atop[i]:=iif(ltop='T',.T.,.F.)
   myform:aleft[i]:=iif(lleft='T',.T.,.F.)

   myform:arange[i]:=crange
   myform:ahelpid[i]:=nhelpid
   myform:avaluen[i]:=nvalue
   myform:aonchange[i]:=conchange

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pProgressbar( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='PROGRESSBAR'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))

   lVertical := ( myform:LeaDatoLogic( cName, 'VERTICAL', 'F' ) == "T" )
   IF lVertical
      nWidth  := Val( myform:LeaDato( cName, 'WIDTH', '25'))
      nHeight := Val( myform:LeaDato( cName, 'HEIGHT', '120'))
   ELSE
      nWidth  := Val( myform:LeaDato( cName, 'WIDTH', '120'))
      nHeight := Val( myform:LeaDato( cName, 'HEIGHT', '25'))
   ENDIF
   crange:=myform:LeaDato(cName,'RANGE','1,100')
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   lsmooth:=myform:LeaDatoLogic(cName,'SMOOTH','F')
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj

   myform:atooltip[i]:=ctooltip


   @ nrow,ncol LABEL &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE cName ;
      BORDER ;
      ACTION Dibuja( This:Name )

   myform:aenabled[i] := iif( upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i] := iif( upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   myform:afontcolor[i]:= myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF

   myform:abackcolor[i]:= myform:LeaDato_Oop( cName,'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
    form_1:&cName:tooltip:=ctooltip
   myform:aVertical[i] := lVertical

   myform:asmooth[i]:=iif(lsmooth='T',.T.,.F.)

   myform:arange[i]:=crange
   myform:ahelpid[i]:=nhelpid

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pRadiogroup( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='RADIOGROUP'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   cobj:=myform:LeaDato(cName,'OBJ','')
   citems:=myform:LeaDato(cName,'OPTIONS',"{'option 1','option 2'}")
   nvalue:=val(myform:LeaDato(cName,'VALUE','0'))
   nwidth:=val(myform:LeaDato(cName,'WIDTH','120'))
   nspacing:=val(myform:LeaDato(cName,'SPACING',"25"))
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   cOnchange:=myform:LeaDato(cName,'ON CHANGE','')
   ltrans:=myform:LeaDatoLogic(cName,'TRANSPARENT','')
   nhelpid:=val(myform:LeaDato(cName,'HELPID',"0"))
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
    myform:acobj[i]:=cobj

   @ nRow, nCol LABEL &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nspacing * litems + 8 ;
      VALUE cName ;
      BORDER ;
      ACTION Dibuja( This:Name )

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:atransparent[i]:=iif(ltrans='T',.T.,.F.)

   myform:aenabled[i]:=iif(upper( myform:LeaDato_Oop( cName,'ENABLED','.T.')) == '.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper( myform:LeaDato_Oop( cName,'VISIBLE','.T.')) == '.T.',.T.,.F.)

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTITALIC','.F.')) == '.T.',.T.,.F.)
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTUNDERLINE','.F.')) == '.T.',.T.,.F.)
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTSTRIKEOUT','.F.')) == '.T.',.T.,.F.)
   form_1:&cName:fontbold:=myform:abold[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTBOLD','.F.')) == '.T.',.T.,.F.)

   myform:abackcolor[i]:= myform:LeaDato_Oop( cName, 'BACKCOLOR','NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:= myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF
   myform:atooltip[i]:=ctooltip
   myform:avaluen[i]:=nvalue
   myform:aitems[i]:=citems
   myform:aspacing[i]:=nspacing
   myform:ahelpid[i]:=nhelpid
   myform:aonchange[i]:=conchange

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pEditbox( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='EDIT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   nwidth:=val(myform:LeaDato(cName,'WIDTH','120'))
   nheight:=val(myform:LeaDato(cName,'HEIGHT','240'))

   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))

   cvalue:=myform:Clean( myform:LeaDato(cName,'VALUE',''))
   cfield:=myform:LeaDato(cName,'FIELD','')
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   nmaxlength:=val(myform:LeaDato(cName,'MAXLENGTH','500'))
   lreadonly:=myform:LeaDatoLogic(cName,"READONLY","F")
   lbreak:=myform:LeaDatoLogic(cName,"BREAK","F")
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   lNoTabStop:=myform:LeaDatoLogic(cName,"NOTABSTOP","F")
   lnovscroll:=myform:LeaDatoLogic(cName,"NOVSCROLL","F")
   lnohscroll:=myform:LeaDatoLogic(cName,"NOHSCROLL","F")

   conchange:=myform:LeaDato(cName,'ON CHANGE','')
   congotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   conlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj

   @ nRow, nCol LABEL &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE cName ;
      BACKCOLOR WHITE ;
      CLIENTEDGE ;
      HSCROLL ;
      VSCROLL ;
      ACTION Dibuja( This:Name )

   myform:areadonly[i]:=iif(lreadonly='T',.T.,.F.)
   myform:abreak[i]:=iif(lbreak='T',.T.,.F.)
   myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)
   myform:anovscroll[i]:=iif(lnovscroll='T',.T.,.F.)
   myform:anohscroll[i]:=iif(lnohscroll='T',.T.,.F.)

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName,'ENABLED','.T.')) == '.T.',.T.,.F.)
   myform:avisible[i]:=iif(upper( myform:LeaDato_Oop( cName,'VISIBLE','.T.')) == '.T.',.T.,.F.)

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTITALIC','.F.')) == '.T.',.T.,.F.)
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTUNDERLINE','.F.')) == '.T.',.T.,.F.)
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTSTRIKEOUT','.F.')) == '.T.',.T.,.F.)
   form_1:&cName:fontbold:=myform:abold[i]:=iif(upper( myform:LeaDato_Oop( cName,'FONTBOLD','.F.')) == '.T.',.T.,.F.)

   myform:abackcolor[i]:= myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:= myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF

   myform:ahelpid[i]:=nhelpid
   myform:avalue[i]:=cValue
   myform:afield[i]:=cfield
   myform:atooltip[i]:=ctooltip
   form_1:&cName:tooltip:=ctooltip
   myform:amaxlength[i]:=nmaxlength
   myform:aonchange[i]:=conchange
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   form_1:&cName:value := cvalue

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pRichedit( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='RICHEDIT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   nwidth:=val(myform:LeaDato(cName,'WIDTH','120'))
   nheight:=val(myform:LeaDato(cName,'HEIGHT','240'))

   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))

   cvalue:=myform:Clean( myform:LeaDato(cName,'VALUE',''))
   cfield:=myform:LeaDato(cName,'FIELD','')
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   nmaxlength:=val(myform:LeaDato(cName,'MAXLENGTH','60'))
   lreadonly:=myform:LeaDatoLogic(cName,"READONLY","F")
   lbreak:=myform:LeaDatoLogic(cName,"BREAK","F")
   lNoTabStop:=myform:LeaDatoLogic(cName,"NOTABSTOP","F")
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))

   conchange:=myform:LeaDato(cName,'ON CHANGE','')
   congotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   conlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj

   @ nRow, nCol LABEL &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE cName ;
      BACKCOLOR WHITE ;
      CLIENTEDGE ;
      ACTION Dibuja( This:Name )

   myform:areadonly[i]:=iif(lreadonly='T',.T.,.F.)
   myform:abreak[i]:=iif(lbreak='T',.T.,.F.)
   myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )

   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF

   myform:ahelpid[i]:=nhelpid
   myform:avalue[i]:=cValue
   myform:afield[i]:=cfield
   myform:atooltip[i]:=ctooltip
    form_1:&cName:tooltip:=ctooltip
   myform:amaxlength[i]:=nmaxlength
   myform:aonchange[i]:=conchange
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   form_1:&cName:value := cvalue

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pFrame( i, myIde )
*------------------------------------------------------------------------------*

   // Load properties
   cName      := myform:acontrolw[i]
   cObj       := myform:LeaDato( cName, 'OBJ', '' )
   nRow       := Val( myform:LeaRow( cName))
   nCol       := Val( myform:LeaCol( cName))
   nWidth     := Val( myform:LeaDato( cName, 'WIDTH', '140' ) )
   nHeight    := Val( myform:LeaDato( cName, 'HEIGHT', '140' ) )
   cCaption   := myform:Clean( myform:LeaDato( cName, 'CAPTION', cName ) )
   lOpaque    := ( myform:LeaDatoLogic( cName, "OPAQUE", "F") == "T" )
   lTrans     := ( myform:LeaDatoLogic( cName, "TRANSPARENT", "F" ) == "T" )
   cFontName  := myform:Clean( myform:LeaDato( cName, 'FONT', '' ) )
   nFontSize  := Val( myform:LeaDato( cName, 'SIZE', '0' ) )
   aFontColor := myform:LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor := myform:LeaDato_Oop( cName, 'FONTCOLOR', aFontColor )
   lBold      := ( myform:LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold      := ( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic    := ( myform:LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic    := ( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline := ( myform:LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline := ( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout := ( myform:LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout := ( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor := myform:LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor := myform:LeaDato_Oop( cName, 'BACKCOLOR', aBackColor )
   lVisible   := ( myform:LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( myform:LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper( myform:LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )

   IF lOpaque
      @ nRow, nCol FRAME &cName OF Form_1 ;
         CAPTION cCaption ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         OPAQUE
   ELSE
      @ nRow, nCol FRAME &cName OF Form_1 ;
         CAPTION cCaption ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         TRANSPARENT
   ENDIF
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      Form_1:&cName:FontColor  := &aFontColor
   ENDIF
   Form_1:&cName:FontBold      := lBold
   Form_1:&cName:FontItalic    := lItalic
   Form_1:&cName:FontUnderline := lUnderline
   Form_1:&cName:FontStrikeout := lStrikeout
   IF aBackColor # 'NIL'
      Form_1:&cName:BackColor  := &aBackColor
   ENDIF

   myform:aCtrlType[i]      := 'FRAME'
   myform:aName[i]          := cName
   myform:acobj[i]          := cObj
   myform:aCaption[i]       := cCaption
   myform:aTransparent[i]   := lTrans
   myform:aOpaque[i]        := lOpaque
   myform:aFontName[i]      := cFontName
   myform:aFontSize[i]      := nFontSize
   myform:aFontColor[i]     := aFontColor
   myForm:aBold[i]          := lBold
   myForm:aFontItalic[i]    := lItalic
   myForm:aFontUnderline[i] := lUnderline
   myForm:aFontStrikeout[i] := lStrikeout
   myform:aBackColor[i]     := aBackColor
   myform:aVisible[i]       := lVisible
   myform:aEnabled[i]       := lEnabled

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pBrowse( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='BROWSE'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   nWidth:=val(myform:LeaDato(cName,'WIDTH','240'))

   nHeight:=val(myform:LeaDato(cName,'HEIGHT','120'))
   cheaders:=myform:LeaDato(cName,'HEADERS',"{'',''} ")
   cworkarea:=myform:LeaDato(cName,'WORKAREA',"ALIAS()")
   cwidths:=myform:LeaDato(cName,'WIDTHS',"{100,60}")
   cfields:=myform:LeaDato(cName,'FIELDS',"{ 'field1','field2'}")
   nvalue:=val(myform:LeaDato(cName,'VALUE',''))
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   congotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   conlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   conchange:=myform:LeaDato(cName,'ON CHANGE','')
   coneditcell:=myform:LeaDato(cName,'ON EDITCELL','')
   conappend:=myform:LeaDato(cName,'ON APPEND','')
   condblclick:=myform:LeaDato(cName,'ON DBLCLICK','')
   conenter:=myform:LeaDato(cName,'ON ENTER','')

   ccolumncontrols:=myform:LeaDato(cName,"COLUMNCONTROLS","")
   cinputmask:=myform:LeaDato(cName,'INPUTMASK',"")

   conheadclick:=myform:LeaDato(cName,'ON HEADCLICK','')
   cvalid:=myform:LeaDato(cName,'VALID',"")
   cwhen:=myform:LeaDato(cName,'WHEN',"")
   cvalidmess:=myform:LeaDato(cName,'VALIDMESSAGES',"")
   cdynamicbackcolor:=myform:LeaDato( cName, "DYNAMICBACKCOLOR", '' )
   cdynamicforecolor:=myform:LeaDato( cName, "DYNAMICFORECOLOR", '' )
   creadonly:=myform:LeaDato(cName,'READONLY',"")
   llock:=myform:LeaDatoLogic(cName,'LOCK',"")
   ldelete:=myform:LeaDatoLogic(cName,'DELETE',"")
   ledit:=myform:LeaDatoLogic(cName,'EDIT',"")
   lappend:=myform:LeaDatoLogic(cName,'APPEND',"")
   lnolines:=myform:LeaDatoLogic(cName,'NOLINES',"")
   cjustify:=myform:LeaDato(cName,'JUSTIFY',"")
   cimage:=myform:LeaDato(cName,'IMAGE',"")
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   linplace:=myform:LeaDatoLogic(cName,'INPLACE',"")
   Name := { { cName ,''} }


   lnolines:=iif(lnolines='T',.T.,.F.)
   llock:=iif(llock='T',.T.,.F.)
   ldelete:=iif(ldelete='T',.T.,.F.)
   linplace:=iif(linplace='T',.T.,.F.)
   ledit:=iif(ledit='T',.T.,.F.)
   lappend:=iif(lappend='T',.T.,.F.)
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj

   @ nRow,nCol GRID &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      HEADERS { cName, '' } ;
      WIDTHS { 100, 60 } ;
      ITEMS { { "", "" } } ;
      TOOLTIP 'Properties and events right click on header area' ;
      NOTABSTOP ;
      ON GOTFOCUS Dibuja( This:Name ) ;
      ON CHANGE Dibuja( This:Name )

   myform:aheaders[i]:=cheaders
   myform:awidths[i]:=cwidths
   myform:afields[i]:=cfields
   myform:avaluen[i]:=nvalue
   myform:aworkarea[i]:=cworkarea

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF
   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF

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

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pGrid( i, myIde )
*------------------------------------------------------------------------------*
  cName:=myform:acontrolw[i]
  myform:actrltype[i]:='GRID'
  myform:aname[i]:=myform:acontrolw[i]

  nrow:=val(myform:LeaRow( cName))
  ncol:=val(myform:LeaCol( cName))
  nWidth:=val(myform:LeaDato(cName,'WIDTH','240'))
  nHeight:=val(myform:LeaDato(cName,'HEIGHT','120'))
  cheaders:=myform:LeaDato(cName,'HEADERS',"{'one','two'} ")
  cwidths:=myform:LeaDato(cName,'WIDTHS',"{80,60}")
  citems:=myform:LeaDato(cName,'ITEMS',"")
  cvalue:=myform:LeaDato(cName,'VALUE','')
  cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
  nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
  ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
  cdynamicbackcolor:=myform:LeaDato( cName, "DYNAMICBACKCOLOR", '' )
  cdynamicforecolor:=myform:LeaDato( cName, "DYNAMICFORECOLOR", '' )
  ccolumncontrols:=myform:LeaDato(cName,"COLUMNCONTROLS","")
  creadonly:=myform:LeaDato(cName,'READONLY',"")
  cinputmask:=myform:LeaDato(cName,'INPUTMASK',"")

  congotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
  conlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
  conchange:=myform:LeaDato(cName,'ON CHANGE','')
  condblclick:=myform:LeaDato(cName,'ON DBLCLICK','')
  conenter:=myform:LeaDato(cName,'ON ENTER','')
  conheadclick:=myform:LeaDato(cName,'ON HEADCLICK','')
  coneditcell:=myform:LeaDato(cName,'ON EDITCELL','')
  lmultiselect:=myform:LeaDatoLogic(cName,'MULTISELECT',"")
  lnolines:=myform:LeaDatoLogic(cName,'NOLINES',"")
  linplace:=myform:LeaDatoLogic(cName,'INPLACE',"")
  cimage:=myform:LeaDato(cName,'IMAGE',"")
  cjustify:=myform:LeaDato(cName,'JUSTIFY',"")
  nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
  lbreak:=myform:LeaDatoLogic(cName,'BREAK',"")
  ledit:=myform:LeaDatoLogic(cName,'EDIT',"")
  cvalid:=myform:LeaDato(cName,'VALID',"")
  cwhen:=myform:LeaDato(cName,'WHEN',"")
  cvalidmess:=myform:LeaDato(cName,'VALIDMESSAGES',"")
  cobj:=myform:LeaDato(cName,'OBJ','')
   lmultiselect:=iif(lmultiselect='T',.T.,.F.)

   lnolines:=iif(lnolines='T',.T.,.F.)
   linplace:=iif(linplace='T',.T.,.F.)
   ledit:=iif(ledit='T',.T.,.F.)
   lbreak:=iif(lbreak='T',.T.,.F.)

   @ nRow, nCol GRID &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      HEADERS { cName, '' } ;
      WIDTHS { 100, 60 } ;
      ITEMS { { "", "" } } ;
      TOOLTIP 'Properties and events right click on header area' ;
      NOTABSTOP ;
      ON GOTFOCUS Dibuja( This:Name ) ;
      ON CHANGE Dibuja( This:Name )

   myform:aheaders[i]:=cheaders
   myform:awidths[i]:=cwidths
   myform:aitems[i]:=citems
   myform:avalue[i]:=cvalue

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )

   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF
   myform:atooltip[i]:=ctooltip
   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange
   myform:aondblclick[i]:=condblclick
   myform:aonenter[i]:=conenter
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
    myform:acobj[i]:=cobj

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pDatepicker( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='DATEPICKER'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   myform:aname[i]:=myform:acontrolw[i]

   nWidth:=val(myform:LeaDato(cName,'WIDTH','120'))
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))

   congotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   cfield:=myform:LeaDato(cName,'FIELD','')
   cvalue:=myform:LeaDato(cName,'VALUE','')
   conlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   conchange:=myform:LeaDato(cName,'ON CHANGE','')
   conenter:=myform:LeaDato(cName,'ON ENTER','')

   lshownone:=myform:LeaDatoLogic(cName,'SHOWNONE',"")
   lupdown:=myform:LeaDatoLogic(cName,'UPDOWN',"")
   lrightalign:=myform:LeaDatoLogic(cName,'RIGHTALIGN',"")
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj


   @ nRow, nCol DATEPICKER &cName OF Form_1 ;
      WIDTH nwidth ;
      ON GOTFOCUS dibuja(this:name) ;
      ON CHANGE dibuja(this:name) ;
      NOTABSTOP

   myform:avalue[i]:=cvalue

   myform:ashownone[i]:=iif(lshownone='T',.T.,.F.)

   myform:aupdown[i]:=iif(lupdown='T',.T.,.F.)

   myform:arightalign[i]:=iif(lrightalign='T',.T.,.F.)

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )

   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF
   myform:atooltip[i]:=ctooltip
   form_1:&cName:tooltip:=ctooltip
   myform:ahelpid[i]:=nhelpid
   myform:afield[i]:=cfield

   myform:aongotfocus[i]:=congotfocus
   myform:aonchange[i]:=conchange
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonenter[i]:=conenter

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pMonthcal( i, myIde )
*------------------------------------------------------------------------------*

   // Load properties
   cName          := myform:acontrolw[i]
   cObj           := myform:LeaDato( cName, 'OBJ', '' )
   nRow           := Val( myform:LeaRow( cName ) )
   nCol           := Val( myform:LeaCol( cName ) )
   cValue         :=  myform:LeaDato( cName, 'VALUE', '' )
   cFontName      := myform:Clean( myform:LeaDato( cName, 'FONT', '' ) )
   nFontSize      := Val( myform:LeaDato( cName, 'SIZE', '0' ) )
   aFontColor     := myform:LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := myform:LeaDato_Oop( cName, 'FONTCOLOR', aFontColor )
   lBold          := ( myform:LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( myform:LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( myform:LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( myform:LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor     := myform:LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := myform:LeaDato_Oop( cName, 'BACKCOLOR', aBackColor )
   lVisible       := ( myform:LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled       := ( myform:LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( myform:LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip       := myform:Clean( myform:LeaDato( cName, 'TOOLTIP', '' ) )
   nHelpID        := Val( myform:LeaDato( cName, 'HELPID', '0' ) )
   cOnChange      := myform:LeaDato( cName, 'ON CHANGE', '' )
   lNoToday       := ( myform:LeaDatoLogic( cName, 'NOTODAY', 'F' ) == 'T' )
   lNoTodayCircle := ( myform:LeaDatoLogic( cName, 'NOTODAYCIRCLE', 'F' ) == 'T' )
   lWeekNumbers   := ( myform:LeaDatoLogic( cName, 'WEEKNUMBERS', 'F' ) == 'T' )
   lNoTabStop     := ( myform:LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == 'T' )

   // Show control
   @ nRow, nCol MONTHCALENDAR &cName OF Form_1 ;
      VALUE cValue ;
      ON CHANGE Dibuja( This:Name )
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      Form_1:&cName:FontColor  := &aFontColor
   ENDIF
   Form_1:&cName:FontBold      := lBold
   Form_1:&cName:FontItalic    := lItalic
   Form_1:&cName:FontUnderline := lUnderline
   Form_1:&cName:FontStrikeout := lStrikeout
   IF aBackColor # 'NIL'
      Form_1:&cName:BackColor  := &aBackColor
   ENDIF
   Form_1:&cName:ToolTip       := cToolTip

   // Save properties
   myform:aCtrlType[i]      := 'MONTHCALENDAR'
   myform:aName[i]          := cName
   myform:acObj[i]          := cObj
   myform:aValue[i]         := cValue
   myform:aFontName[i]      := cFontName
   myform:aFontSize[i]      := nFontSize
   myform:aFontColor[i]     := aFontColor
   myForm:aBold[i]          := lBold
   myForm:aFontItalic[i]    := lItalic
   myForm:aFontUnderline[i] := lUnderline
   myForm:aFontStrikeout[i] := lStrikeout
   myform:aBackColor[i]     := aBackColor
   myform:aVisible[i]       := lVisible
   myform:aEnabled[i]       := lEnabled
   myform:aToolTip[i]       := cToolTip
   myform:aHelpId[i]        := nHelpId
   myform:aOnChange[i]      := cOnChange
   myform:aNoToday[i]       := lNoToday
   myform:aNoTodayCircle[i] := lNoTodayCircle
   myform:aWeekNumbers[i]   := lWeekNumbers
   myform:aNoTabStop[i]     := lNoTabStop

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pHyplink( i, myIde )
*------------------------------------------------------------------------------*
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cValue, cAddress, cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip, nHelpID, lHandCursor

   // Load properties
   cName        := myform:acontrolw[i]
   cObj         := myform:LeaDato( cName, 'OBJ', '' )
   nRow         := Val( myform:LeaRow( cName ) )
   nCol         := Val( myform:LeaCol( cName ) )
   nWidth       := Val( myform:LeaDato( cName, 'WIDTH', '100' ) )
   nHeight      := Val( myform:LeaDato( cName, 'HEIGHT', '24' ) )
   cValue       := myform:Clean( myform:LeaDato( cName, 'VALUE', 'ooHG Home' ) )
   cAddress     := myform:Clean( myform:LeaDato( cName, 'ADDRESS', 'https://sourceforge.net/projects/oohg/' ) )
   cFontName    := myform:Clean( myform:LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( myform:LeaDato( cName, 'SIZE', '0' ) )
   aFontColor   := myform:LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := myform:LeaDato_Oop( cName, 'FONTCOLOR', aFontColor )
   lBold        := ( myform:LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( myform:LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( myform:LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( myform:LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := myform:LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := myform:LeaDato_Oop( cName, 'BACKCOLOR', aBackColor )
   lVisible     := ( myform:LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( myform:LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( myform:LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := myform:Clean( myform:LeaDato( cName, 'TOOLTIP', '' ) )
   nHelpID      := Val( myform:LeaDato( cName, 'HELPID', '0' ) )
   lHandCursor  := ( myform:LeaDatoLogic( cName, 'HANDCURSOR', 'F' ) == 'T' )

   // Show control
   @ nRow, nCol LABEL &cName OF Form_1 ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      BORDER ;
      VALUE cValue ;
      ACTION Dibuja( This:Name )
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      Form_1:&cName:FontColor  := &aFontColor
   ENDIF
   Form_1:&cName:FontBold      := lBold
   Form_1:&cName:FontItalic    := lItalic
   Form_1:&cName:FontUnderline := lUnderline
   Form_1:&cName:FontStrikeout := lStrikeout
   IF aBackColor # 'NIL'
      Form_1:&cName:BackColor  := &aBackColor
   ENDIF
   Form_1:&cName:ToolTip       := cToolTip
   IF lHandCursor
      Form_1:&cName:Cursor     := IDC_HAND
   ENDIF

   // Save properties
   myform:aCtrlType[i]      := 'HYPERLINK'
   myform:aName[i]          := cName
   myform:acObj[i]          := cObj
   myform:aValue[i]         := cValue
   myform:aAddress[i]       := cAddress
   myform:aFontName[i]      := cFontName
   myform:aFontSize[i]      := nFontSize
   myform:aFontColor[i]     := aFontColor
   myForm:aBold[i]          := lBold
   myForm:aFontItalic[i]    := lItalic
   myForm:aFontUnderline[i] := lUnderline
   myForm:aFontStrikeout[i] := lStrikeout
   myform:aBackColor[i]     := aBackColor
   myform:aVisible[i]       := lVisible
   myform:aEnabled[i]       := lEnabled
   myform:aToolTip[i]       := cToolTip
   myform:aHelpId[i]        := nHelpId
   myform:aHandCursor[i]    := lHandCursor

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pAnimatebox( i, myIde )
*------------------------------------------------------------------------------*
LOCAL cName, cObj, nWidth, nHeight, cFile, lAutoplay, lCenter, lTrans, nHelpid, cToolTip, lVisible, lEnabled

   // Load properties
   cName     := myform:acontrolw[i]
   cObj      := myform:LeaDato( cName, 'OBJ', '' )
   nRow      := Val( myform:LeaRow( cName))
   nCol      := Val( myform:LeaCol( cName))
   nWidth    := Val( myform:LeaDato( cName, 'WIDTH', '0' ) )
   nHeight   := Val( myform:LeaDato( cName, 'HEIGHT', '0' ) )
   cFile     := myform:Clean( myform:LeaDato( cName, 'FILE', '' ) )
   lAutoplay := ( myform:LeaDatoLogic( cName, 'AUTOPLAY', '') == "T" )
   lCenter   := ( myform:LeaDatoLogic( cName, 'CENTER', '' ) == "T" )
   lTrans    := ( myform:LeaDatoLogic( cName, 'TRANSPARENT', '' ) == "T" )
   nHelpid   := Val(myform:LeaDato( cName, 'HELPID', '0' ) )
   cToolTip  := myform:Clean( myform:LeaDato( cName, 'TOOLTIP', '' ) )
   cToolTip  := myform:Clean( myform:LeaDato_Oop( cName, 'TOOLTIP', cToolTip ) )
   lVisible  := ( myform:LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible  := ( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled  := ( myform:LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled  := ( Upper( myform:LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )

   // Show control
   @ nRow, nCol LABEL &cName ;
      OF Form_1 ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      VALUE cName ;
      BORDER ;
      ACTION Dibuja( This:Name )
   Form_1:&cName:ToolTip := cToolTip

   // Save properties
   myform:actrltype[i]    := 'ANIMATE'
   myform:aname[i]        := cName
   myform:acobj[i]        := cObj
   myform:afile[i]        := cFile
   myform:aautoplay[i]    := lAutoplay
   myform:acenter[i]      := lCenter
   myform:atransparent[i] := lTrans
   myform:ahelpid[i]      := nHelpId
   myform:atooltip[i]     := cToolTip
   myform:avisible[i]     := lVisible
   myform:aenabled[i]     := lEnabled

   ProcessContainersFill( cName, nRow, nCol, myIde )
RETURN NIL

*------------------------------------------------------------------------------*
STATIC FUNCTION pImage( i, myIde )
*------------------------------------------------------------------------------*
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cAction, cPicture, lStretch, cToolTip, lBorder, lClientEdge, lVisible, lEnabled, lTrans, nHelpId, aBackColor

   // Load properties
   cName       := myform:acontrolw[i]
   cObj        := myform:LeaDato( cName, 'OBJ', '' )
   nRow        := Val( myform:LeaRow( cName))
   nCol        := Val( myform:LeaCol( cName))
   nWidth      := Val( myform:LeaDato( cName, 'WIDTH', '100' ) )
   nHeight     := Val( myform:LeaDato( cName, 'HEIGHT', '100' ) )
   cAction     := myform:LeaDato( cName, 'ACTION', "" )
   cPicture    := myform:Clean( myform:LeaDato(cName, 'PICTURE', 'IMAGE.BMP' ) )             // TODO: Revisar si es necesario el default
   lStretch    := ( myform:LeaDatoLogic( cName, 'STRETCH', "F") == "T" )
   cToolTip    := myform:Clean( myform:LeaDato( cName, 'TOOLTIP', '' ) )
   cToolTip    := myform:Clean( myform:LeaDato_Oop( cName, 'TOOLTIP', cToolTip ) )
   lBorder     := ( myform:LeaDatoLogic( cName, "BORDER", "F" ) == "T" )
   lClientEdge := ( myform:LeaDatoLogic( cName, "CLIENTEDGE", "F") == "T" )
   lVisible    := ( myform:LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible    := ( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled    := ( myform:LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled    := ( Upper( myform:LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lTrans      := ( myform:LeaDatoLogic( cName, "TRANSPARENT", "F" ) == "T" )
   nHelpId     := Val( myform:LeaDato( cName, 'HELPID', '0' ) )
   aBackColor  := myform:LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor  := myform:LeaDato_Oop( cName, 'BACKCOLOR', aBackColor )

   // Show control
   @ nRow, nCol LABEL &cName OF Form_1 ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      VALUE cName ;
      BORDER ;
      ACTION Dibuja( This:Name )
   Form_1:&cName:ToolTip := cToolTip
   IF aBackColor # 'NIL'
      Form_1:&cName:BackColor  := &aBackColor
   ENDIF

   // Save properties
   myform:actrltype[i]    := 'IMAGE'
   myform:aname[i]        := cName
   myform:acobj[i]        := cObj
   myform:aAction[i]      := cAction
   myform:aPicture[i]     := cPicture
   myform:aStretch[i]     := lStretch  
   myform:aToolTip[i]     := cToolTip
   myform:aBorder[i]      := lBorder
   myform:aClientEdge[i]  := lClientEdge
   myform:aVisible[i]     := lVisible
   myform:aEnabled[i]     := lEnabled
   myform:aTransparent[i] := lTrans
   myform:aHelpid[i]      := nHelpid
   myform:aBackColor[i]   := aBackColor

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pPicButt( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='PICBUTT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))

   cobj:=myform:LeaDato(cName,'OBJ','')
   cPicture:=myform:Clean( myform:LeaDato(cName,'PICTURE',''))
   cAction:=myform:LeaDato(cName,'ACTION',"msginfo('Button pressed')")
   nWidth:=val(myform:LeaDato(cName,'WIDTH','100'))
   nHeight:=val(myform:LeaDato(cName,'HEIGHT','28'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   lflat:=myform:LeaDatoLogic(cName,'FLAT',"")
   cOngotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   cOnlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   lNoTabStop:=myform:LeaDatoLogic(cName,'NOTABSTOP',"")
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))

   cauxfile:=cpicture+'.BMP'              // TODO: Check
    myform:acobj[i]:=cobj
   IF File(cauxfile)
      @ nRow, nCol BUTTON &cName OF Form_1 ;
         PICTURE cAuxFile ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         ON GOTFOCUS Dibuja( This:Name ) ;
         ACTION Dibuja( This:Name ) ;
         NOTABSTOP
   ELSE
      @ nRow, nCol BUTTON &cName OF Form_1 ;
         PICTURE 'A4' ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         ON GOTFOCUS Dibuja( This:Name ) ;
         ACTION Dibuja( This:Name ) ;
         NOTABSTOP
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   myform:aPicture[i]:=cPicture
   myform:atooltip[i]:=ctooltip
    form_1:&cName:tooltip:=ctooltip
   myform:aaction[i]:=caction
   myform:ahelpid[i]:=nhelpid

   myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)
   myform:aflat[i]:=iif(lflat='T',.T.,.F.)

   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pPicCheckButt( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='PICCHECKBUTT'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   cobj:=myform:LeaDato(cName,'OBJ','')
   cpicture:=myform:Clean( myform:LeaDato(cName,'PICTURE',''))
   nWidth:=val(myform:LeaDato(cName,'WIDTH','100'))
   nHeight:=val(myform:LeaDato(cName,'HEIGHT','28'))
   lValue := ( myform:LeaDatoLogic( cName, 'VALUE', 'F' ) == "T" )
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   lNoTabStop := ( myform:LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   cOnchange:=myform:LeaDato(cName,'ON CHANGE','')
   cOngotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   cOnlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   nhelpid:=val(myform:LeaDato(cName,'HELPID',"0"))

   cauxfile:=cpicture+'.BMP'            // TODO: Check

    myform:acobj[i]:=cobj

   if file(cauxfile)
      @ nRow, nCol CHECKBUTTON &cName OF Form_1 ;
         PICTURE cauxfile ;
         WIDTH nwidth ;
         HEIGHT nheight ;
         ON GOTFOCUS Dibuja( This:Name ) ;
         ON CHANGE Dibuja( This:Name ) ;
         NOTABSTOP
   else
      @ nRow, nCol CHECKBUTTON &cName OF Form_1 ;
         PICTURE 'A4' ;
         WIDTH nwidth ;
         HEIGHT nheight ;
         ON GOTFOCUS Dibuja( This:Name ) ;
         ON CHANGE Dibuja( This:Name ) ;
         NOTABSTOP
   endif

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )
   myform:atooltip[i]:=ctooltip
    form_1:&cName:tooltip:=ctooltip

   form_1:&cName:value := myform:avaluel[i]
   myform:apicture[i]:=cpicture
   myform:avaluel[i] := lValue
   myform:ahelpid[i]:=nhelpid
   myform:aNoTabStop[i]     := lNoTabStop

   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pCheckBtn( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='CHECKBTN'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   nWidth:=val(myform:LeaDato(cName,'WIDTH','100'))
   nHeight:=val(myform:LeaDato(cName,'HEIGHT','28'))
   cCaption:=myform:Clean( myform:LeaDato(cName,'CAPTION',cName))         // TODO: Revisar si es necesario el default
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   lvalue:=myform:LeaDato(cName,'VALUE','')
   nhelpid:=val(myform:LeaDato(cName,'HELPID',"0"))
   lNoTabStop:=myform:LeaDatoLogic(cName,'NOTABSTOP',"")

   cOnchange:=myform:LeaDato(cName,'ON CHANGE','')
   cOngotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   cOnlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')

   lvaluel:=myform:LeaDato(cName,'VALUE',"")
   lvaluelaux:=iif(lvaluel='.T.',.T.,.F.)
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj

   @ nRow, nCol CHECKBUTTON &cName OF Form_1 ;
      CAPTION Ccaption ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE lvaluelaux ;
      ON GOTFOCUS Dibuja( This:Name ) ;
      ON CHANGE Dibuja( This:Name ) ;
      NOTABSTOP

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )

   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL' )
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF

   myform:atooltip[i]:=ctooltip

    form_1:&cName:tooltip:=ctooltip
   myform:acaption[i]:=ccaption

   myform:avaluel[i]:=lvaluelaux

   myform:ahelpid[i]:=nhelpid

   myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)

   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pComboBox( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='COMBO'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   nWidth:=val(myform:LeaDato(cName,'WIDTH','120'))
   citems:=myform:LeaDato(cName,'ITEMS','')
   citemsource:=myform:LeaDato(cName,'ITEMSOURCE','')
   nvalue:=val(myform:LeaDato(cName,'VALUE','0'))
   cvaluesource:=myform:LeaDato(cName,'VALUESOURCE','')
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   nhelpid:=val(myform:LeaDato(cName,'HELPID',"0"))
   lNoTabStop:=myform:LeaDatoLogic(cName,'NOTABSTOP',"")
   lsort:=myform:LeaDatoLogic(cName,'SORT',"")
   lbreak:=myform:LeaDatoLogic(cName,'BREAK',"")
   ldisplayedit:=myform:LeaDatoLogic(cName,'DISPLAYEDIT',"")

   cOnchange:=myform:LeaDato(cName,'ON CHANGE','')
   cOngotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   cOnlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   cOnenter:=myform:LeaDato(cName,'ON ENTER','')
   cOndisplaychange:=myform:LeaDato(cName,'ON DISPLAYCHANGE','')
   cobj:=myform:LeaDato(cName,'OBJ','')
   myform:acobj[i]:=cobj

   @ nRow, nCol COMBOBOX &cName OF Form_1 ;
      WIDTH nwidth ;
      ITEMS { cName, ' ' } ;
      VALUE 1 ;
      ON GOTFOCUS Dibuja( This:Name ) ;
      ON CHANGE Dibuja( This:Name ) ;
      NOTABSTOP

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )

   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF

  myform:atooltip[i]:=ctooltip
    form_1:&cName:tooltip:=ctooltip
  myform:aitems[i]:=citems
  myform:aitemsource[i]:=citemsource
  myform:avaluen[i]:=nvalue
  myform:avaluesource[i]:=cvaluesource
  myform:ahelpid[i]:=nhelpid

  myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)
  myform:asort[i]:=iif(lsort='T',.T.,.F.)
  myform:abreak[i]:=iif(lbreak='T',.T.,.F.)
  myform:adisplayedit[i]:=iif(ldisplayedit='T',.T.,.F.)
  myform:aongotfocus[i]:=congotfocus
  myform:aonlostfocus[i]:=conlostfocus
  myform:aonchange[i]:=conchange
  myform:aonenter[i]:=conenter
  myform:aondisplaychange[i]:=condisplaychange

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pListBox( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='LIST'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   nWidth:=val(myform:LeaDato(cName,'WIDTH','120'))
   nHeight:=val(myform:LeaDato(cName,'HEIGHT','120'))
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   citems:=myform:LeaDato(cName,'ITEMS','')

   nvalue:=val(myform:LeaDato(cName,'VALUE','0'))
   lmultiselect:=myform:LeaDatoLogic(cName,'MULTISELECT',"F")
   nhelpid:=val(myform:LeaDato(cName,'HELPID',"0"))
   lNoTabStop:=myform:LeaDatoLogic(cName,'NOTABSTOP',"")
   lbreak:=myform:LeaDatoLogic(cName,'BREAK',"")
   lsort:=myform:LeaDatoLogic(cName,'SORT',"")

   cOnchange:=myform:LeaDato(cName,'ON CHANGE','')
   cOngotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   cOnlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   cOndblclick:=myform:LeaDato(cName,'ON DBLCLICK','')
   cobj:=myform:LeaDato(cName,'OBJ','')
   myform:acobj[i]:=cobj

   @ nRow, nCol LISTBOX &cName OF Form_1 ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      ITEMS {cName} ;
      ON GOTFOCUS Dibuja( This:Name ) ;
      ON CHANGE Dibuja( This:Name ) ;
      NOTABSTOP

   myform:atooltip[i]:=ctooltip

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )


  form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
  form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
  form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
  form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )
   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF
  myform:atooltip[i]:=ctooltip
    form_1:&cName:tooltip:=ctooltip
  myform:aitems[i]:=citems
  myform:avaluen[i]:=nvalue

  myform:amultiselect[i]:=iif(lmultiselect='T',.T.,.F.)

  myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)

  myform:asort[i]:=iif(lsort='T',.T.,.F.)

  myform:ahelpid[i]:=nhelpid

  myform:abreak[i]:=iif(lbreak='T',.T.,.F.)

  myform:aongotfocus[i]:=congotfocus
  myform:aonlostfocus[i]:=conlostfocus
  myform:aonchange[i]:=conchange
  myform:aondblclick[i]:=condblclick

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pCheckBox( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='CHECKBOX'
   myform:aname[i]:=myform:acontrolw[i]

   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   cCaption:=myform:Clean( myform:LeaDato(cName,'CAPTION',cName))        // TODO: Ver si es necesario el default
   nWidth:=val(myform:LeaDato(cName,'WIDTH','100'))
   nHeight:=val(myform:LeaDato(cName,'HEIGHT','28'))
   cOnchange:=myform:LeaDato(cName,'ON CHANGE','')
   cfield:=myform:LeaDato(cName,'FIELD','')
   cOngotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   cOnlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   ltrans:=myform:LeaDatoLogic(cName,'TRANSPARENT',"")
   lNoTabStop:=myform:LeaDatoLogic(cName,'NOTABSTOP',"")

   lvaluel:=myform:LeaDato(cName,'VALUE',"")
   lvaluelaux:=iif(lvaluel='.T.',.T.,.F.)
   cobj:=myform:LeaDato(cName,'OBJ','')
    myform:acobj[i]:=cobj

   @ nRow, nCol CHECKBOX &cName OF Form_1 ;
      CAPTION Ccaption ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE lvaluelaux ;
      ON GOTFOCUS Dibuja( This:Name ) ;
      ON CHANGE Dibuja( This:Name ) ;
      NOTABSTOP

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:atransparent[i]:=iif(ltrans='T',.T.,.F.)

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )
   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL' )
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF
   myform:atooltip[i]:=ctooltip
    form_1:&cName:tooltip:=ctooltip

   myform:acaption[i]:=ccaption
   myform:ahelpid[i]:=nhelpid
   myform:afield[i]:=cfield
   myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)
   myform:avaluel[i]:=lvaluelaux


   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
   myform:aonchange[i]:=conchange

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pButton( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='BUTTON'
   myform:aname[i]:=myform:acontrolw[i]
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))

   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   cCaption:=myform:Clean( myform:LeaDato(cName,'CAPTION',cName))        // TODO: Ver si es necesario el default
   cPicture:= myform:Clean( myform:LeaDato(cName,'PICTURE',''))
   cAction:=myform:LeaDato(cName,'ACTION',"msginfo('Button pressed')")
   nWidth:=val(myform:LeaDato(cName,'WIDTH','100'))
   nHeight:=val(myform:LeaDato(cName,'HEIGHT','28'))
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   lNoTabStop:=myform:LeaDatoLogic(cName,'NOTABSTOP',"")
   lflat:=myform:LeaDatoLogic(cName,'FLAT',"")

   ltop:=myform:LeaDatoLogic(cName,'TOP',"")
   lbottom:=myform:LeaDatoLogic(cName,'BOTTOM',"")
   lleft:=myform:LeaDatoLogic(cName,'LEFT',"")
   lright:=myform:LeaDatoLogic(cName,'RIGHT',"")

   cOngotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')

   cOnlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   cobj:=myform:LeaDato(cName,'OBJ','')

   @ nrow, ncol Button &cName OF Form_1 ;
      CAPTION cCaption ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      ON GOTFOCUS Dibuja( This:Name ) ;
      ACTION Dibuja( This:Name ) ;
      NOTABSTOP

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )


   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL' )

   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF
   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF

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
    form_1:&cName:tooltip:=ctooltip
   myform:aaction[i]:=caction
   myform:ahelpid[i]:=nhelpid

   myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)
   myform:aflat[i]:=iif(lflat='T',.T.,.F.)

   myform:aongotfocus[i]:=congotfocus
   myform:aonlostfocus[i]:=conlostfocus
    myform:acobj[i]:=cobj

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION pTextBox( i, myIde )
*------------------------------------------------------------------------------*
   cName:=myform:acontrolw[i]
   myform:actrltype[i]:='TEXT'
   myform:aname[i]:=myform:acontrolw[i]
   nrow:=val(myform:LeaRow( cName))
   ncol:=val(myform:LeaCol( cName))
   cfontname:=myform:Clean( myform:LeaDato(cName,'FONT',''))
   nfontsize:=val(myform:LeaDato(cName,'SIZE','0'))
   nwidth:=val(myform:LeaDato(cName,'WIDTH','120'))
   nheight:=val(myform:LeaDato(cName,'HEIGHT','24'))
   cvalue:=myform:Clean( myform:LeaDato(cName,'VALUE',''))
   cfield:=myform:LeaDato(cName,'FIELD','')
   ctooltip:=myform:Clean( myform:LeaDato(cName,'TOOLTIP',''))
   nmaxlength:=val(myform:LeaDato(cName,'MAXLENGTH','30'))
   nhelpid:=val(myform:LeaDato(cName,'HELPID','0'))
   luppercase:=myform:LeaDatoLogic(cName,"UPPERCASE","F")
   llowercase:=myform:LeaDatoLogic(cName,"LOWERCASE","F")
   lpassword:=myform:LeaDatoLogic(cName,"PASSWORD","F")
   lnumeric:=myform:LeaDatoLogic(cName,"NUMERIC","F")
   lrightalign:=myform:LeaDatoLogic(cName,"RIGHTALIGN","F")
   lNoTabStop:=myform:LeaDatoLogic(cName,'NOTABSTOP',"F")
   ldate:=myform:LeaDatoLogic(cName,'DATE',"F")
   cinputmask:=myform:Clean( myform:LeaDato(cName,'INPUTMASK',""))
   if len(cinputmask)>0
      nmaxlength:=0
   endif
   cformat:=myform:Clean( myform:LeaDato(cName,'FORMAT',""))
   conenter:=myform:LeaDato(cName,'ON ENTER','')
   conchange:=myform:LeaDato(cName,'ON CHANGE','')
   congotfocus:=myform:LeaDato(cName,'ON GOTFOCUS','')
   conlostfocus:=myform:LeaDato(cName,'ON LOSTFOCUS','')
   lreadonly:=myform:LeaDatoLogic(cName,'READONLY',"")
   nFocusedPos:= val(myform:LeaDato(cName,'FOCUSEDPOS','-2'))   // pb
   cvalid:= myform:LeaDato(cName,'VALID','')
   caction:= myform:LeaDato(cName,'ACTION','')
   caction2:= myform:LeaDato(cName,'ACTION2','')
   cimage:= myform:LeaDato(cName,'IMAGE','')
   cwhen:=myform:LeaDato(cName,'WHEN','')
   cobj:=myform:LeaDato(cName,'OBJ','')

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

   @ nRow, nCol LABEL &cName OF Form_1 ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      VALUE "" ;
      ACTION Dibuja( This:Name ) ;
      BACKCOLOR WHITE ;
      CLIENTEDGE

   myform:afontname[i]:=cfontname
   IF Len( cFontName ) > 0
      Form_1:&cName:FontName   := cFontName
   ENDIF
   myform:afontsize[i]:=nfontsize
   IF nFontSize > 0
      Form_1:&cName:FontSize   := nFontSize
   ENDIF

   myform:adate[i]:=iif(ldate='T',.T.,.F.)


   myform:anotabstop[i]:=iif(lNoTabStop='T',.T.,.F.)

   myform:aenabled[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'ENABLED', '.T.' ) ) == '.T.', .T., .F. )
   myform:avisible[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'VISIBLE', '.T.' ) ) == '.T.', .T., .F. )

   form_1:&cName:fontitalic:=myform:afontitalic[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTITALIC', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontunderline:=myform:afontunderline[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTUNDERLINE', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontstrikeout:=myform:afontstrikeout[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTSTRIKEOUT', '.F.' ) ) == '.T.', .T., .F. )
   form_1:&cName:fontbold:=myform:abold[i]:=IIF( Upper( myform:LeaDato_Oop( cName, 'FONTBOLD' , '.F.' ) ) == '.T.', .T., .F. )

   myform:abackcolor[i]:=myform:LeaDato_Oop( cName, 'BACKCOLOR', 'NIL')
   cbackcolor:=myform:abackcolor[i]
   IF cBackColor # 'NIL'
      Form_1:&cName:BackColor := &cBackColor
   ENDIF

   myform:afontcolor[i]:=myform:LeaDato_Oop( cName, 'FONTCOLOR', 'NIL')
   cfontcolor:=myform:afontcolor[i]
   IF cFontColor # 'NIL'
      Form_1:&cName:Fontcolor := &cFontColor
   ENDIF
     myform:avalue[i]:=cValue
     myform:afield[i]:=cfield
     myform:atooltip[i]:=ctooltip
     form_1:&cName:tooltip:=ctooltip
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
     myform:aaction[i]:=caction           // rhs
     myform:aaction2[i]:=caction2         // rhs
     myform:aimage[i]:=cimage             // rhs
     myform:avalid[i]:=cvalid
     myform:awhen[i]:=cwhen
       myform:acobj[i]:=cobj

   ProcessContainersFill( cName, nRow, nCol, myIde )
return

*------------------------------------------------------------------------------*
STATIC FUNCTION ProcessContainers( ControlName, myIde )
*------------------------------------------------------------------------------*
local i , ActivePage , z,k,k1 ,ocontrol,owindow,alsc
if .not. (myform:swtab)
   return nil
endif
        owindow:=getformobject('Form_1')
   For i := 1 To Len (owindow:acontrols)
            ocontrol:=owindow:acontrols[i]
      If ocontrol:type == 'TAB'
                        cName:=ocontrol:name
                        ndesrow:=ocontrol:row   &&& cordenada del tab para desplazamiento del mouse
                        ndescol:=ocontrol:col
         If ( _ooHG_mouserow > ocontrol:Row ) .And. (_ooHG_mouserow < ocontrol:Row + ocontrol:Height ) .And. ( _ooHG_mousecol > ocontrol:Col ) .And. ( _ooHG_mousecol < ocontrol:Col + ocontrol:Width )
            ActivePage := _GetValue ( ocontrol:Name , 'Form_1' )
            aAdd ( ocontrol:aPages[ActivePage] , GetControlobject ( ControlName , 'Form_1' ) )
                                form_1:&cName:AddControl(controlname, activepage,_ooHG_mouserow - ndesrow ,_ooHG_mousecol - ndescol )
                                alsc := myIde:asystemcoloraux
                                form_1:&controlname:backcolor:=alsc
                                cvc:=ascan( myform:acontrolw, { |c| lower( c ) == lower(controlname) } )
                                if cvc>0
                                    myform:abackcolor[cvc]:='NIL'
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

// llena los TABS, previo cargado de los controles en la forma
*------------------------------------------------------------------------------*
STATIC FUNCTION ProcessContainersFill( ControlName, row, col, myIde )
*------------------------------------------------------------------------------*
LOCAL i, pagecount, z, l, swpagename, pagename, swnoestab

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

   // por cada control busca hacia atras a que tab pertenece
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
               pagename := AllTrim( SubStr( myform:aline[i], npos + 6, Len( myform:aline[I] ) - 1 ) )
               pagename := myform:Clean( pagename)
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
      if myform:abackcolor[z] == 'NIL'
         alsc := myIde:asystemcoloraux
         Form_1:&ControlName:BackColor:=alsc
      endif
   endif
return nil

*------------------------------------------------------------------------------*
FUNCTION CuantosPage( tabname )
*------------------------------------------------------------------------------*
local i,pagecount:=0,swb:=0,h
h:=ascan( myform:acontrolw, { |c| lower( c ) == lower(tabname)  } )
ccaptions:='{'
cimages:='{'
for i=1 to len(myform:aline)
    IF At( ' ' + Upper( tabname ) + ' ', Upper( myform:aline[i] ) ) # 0
       swb:=1
    endif
    if at(upper('DEFINE PAGE '),upper(myform:aline[i]))#0 .and. swb=1
       pagecount++
       npospage:=at('DEFINE PAGE ',upper(myform:aline[i]))
       cpagename:=alltrim(substr(myform:aline[i],npospage+11,len(myform:aline[i])))
       nrat := RAt( ';', cpagename )
       cpagename := myform:Clean( AllTrim( SubStr( cPageName, 1, nrat - 1 ) ) )

       nposimage:=at('IMAGE ',upper(myform:aline[i+1]))
       if nposimage>0
          cimage:=alltrim(substr(myform:aline[i+1],nposimage+6,len(myform:aline[i])))
          cimage:=myform:Clean( AllTrim( SubStr( cimage, 1, Len( myform:aline[i + 1] ) ) ) )
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

*------------------------------------------------------------------------------*
FUNCTION ProcesaControl()
*------------------------------------------------------------------------------*
local i,j,x,cName,owindow
j:=(lista:listacon:value)+1
cName:=myform:acontrolw[j]
owindow:=getformobject("form_1")
x:=0
for i:=1 to len(owindow:acontrols)
    if lower(cName)=lower(owindow:acontrols[i]:name)
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

*------------------------------------------------------------------------------*
FUNCTION Minim()
*------------------------------------------------------------------------------*
   cvccontrols:Minimize()
   lista:Minimize()
RETURN NIL

*------------------------------------------------------------------------------*
FUNCTION Maxim()
*------------------------------------------------------------------------------*
   cvccontrols:Restore()
   lista:Restore()
RETURN NIL

*------------------------------------------------------------------------------*
FUNCTION MuestraSiNo()
*------------------------------------------------------------------------------*
local i,ccontrol,oocontrol,nrow,ncol,nwidth,nheight,cName,j,nl
   lista.listacon.deleteallitems
   for i= 2 to len(myform:aname)
//// ojo aqui estaab desde 2
       if len(trim(myform:acontrolw[i]))>0
          ccontrol:=myform:acontrolw[i]
          cName:=myform:aname[i]
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
              olistacon:additem({cName,str(nrow,4),str(ncol,4),str(nwidth,4),str(nheight,4),ccontrol})
          endif
       endif
   next i
return nil

*------------------------------------------------------------------------------*
FUNCTION Cordenada()
*------------------------------------------------------------------------------*
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
                    wcNamet:=myform:aname[i]
             if valtype(wcNamet)='C' .and. wcNamet#'' ;
                .and. (.not. (myform:actrltype[i]$'STATUSBAR'))
                ocontrol:=GetControlObject( wcNamet,'form_1')
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
             wcNamet:=myform:aname[i]
             if valtype(wcNamet)='C' .and. wcNamet#'' .and. (.not. (myform:actrltype[i]$'STATUSBAR'))
                ocontrol:=GetControlObject( wcNamet,'form_1')
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

*------------------------------------------------------------------------------*
STATIC FUNCTION SioNoMC(cName)
*------------------------------------------------------------------------------*
local i
for i:=2 to len(myform:acontrolw)
    if lower(myform:acontrolw[i])=lower(cName)
       if myform:actrltype[i]$'MONTHCALENDAR TIMER'
          return .T.
       endif
    endif
next i
return .F.


*------------------------------------------------------------------------------*
FUNCTION Help_F1( C_P, myIde )
*------------------------------------------------------------------------------*
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

SET INTERACTIVECLOSE ON
DEFINE WINDOW FAYUDA ;
   OBJ FAyuda  ;
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

*------------------------------------------------------------------------------*
STATIC FUNCTION CloseOff()
*------------------------------------------------------------------------------*
   SET INTERACTIVECLOSE OFF
RETURN NIL

/////////// funciones para hacer debug....
*------------------------------------------------------------------------------*
FUNCTION DebugT
*------------------------------------------------------------------------------*
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

*------------------------------------------------------------------------------*
FUNCTION DebugW
*------------------------------------------------------------------------------*
LOCAL i
   FOR i := 1 TO Len( myform:aname )
     MsgBox( myform:aname[i] )
   NEXT i
RETURN NIL

*------------------------------------------------------------------------------*
FUNCTION Debug
*------------------------------------------------------------------------------*
LOCAL i, cs := ''
   cs := cs + '# controles ' + Str( myform:ncontrolw - 1, 4 ) + CRLF
   FOR i := 1 TO myform:ncontrolw
       IF Upper( myform:acontrolw[i] ) # 'TEMPLATE' .AND. ;
          Upper( myform:acontrolw[i] ) # 'STATUSBAR' .AND. ;
          Upper( myform:acontrolw[i] ) # 'MAINMENU' .AND. ;
          Upper( myform:acontrolw[i] ) # 'CONTEXTMENU' .AND. ;
          Upper( myform:acontrolw[i] ) # 'NOTIFYMENU'
          IF myform:atabpage[i,1] # NIL .AND. myform:atabpage[i, 1] # ''
             cs := cs + myform:acontrolw[i] + ' | ' + myform:actrltype[i] + ' | ' + Str( myform:atabpage[i, 2] )+ ' | ' + myform:atabpage[i, 1] + CRLF
          ELSE
             cs := cs + myform:acontrolw[i] + ' | ' + myform:actrltype[i] + ' |-> ' + myform:acaption[i] + CRLF
          ENDIF
       ENDIF
   NEXT i
   MsgInfo( cs )
RETURN NIL

*------------------------------------------------------------------------------*
FUNCTION cHideControl( x )
*------------------------------------------------------------------------------*
RETURN HideWindow( x )

*------------------------------------------------------------------------------*
FUNCTION SetHeightForWholeRows( oGrid, NumberOfWholeRows )
*------------------------------------------------------------------------------*
   LOCAL NeededHeight

   NeededHeight := NumberOfWholeRows * oGrid:ItemHeight() + ;
                   oGrid:HeaderHeight + ;
                   IF( IsWindowStyle( oGrid:hWnd, WS_HSCROLL ), ;
                       GetHScrollBarHeight(), 0 ) + ;
                   IF( IsWindowExStyle( oGrid:hWnd, WS_EX_CLIENTEDGE ), ;
                       GetEdgeHeight() * 2, 0 )
RETURN NeededHeight

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
