/*
 * $Id: propeven.prg,v 1.10 2014-07-17 02:59:37 fyurisich Exp $
 */

#include 'oohg.ch'

#define SS_LEFT             0
#define SS_CENTER           1
#define SS_RIGHT            2

DECLARE WINDOW Form_1

*----------------------------
FUNCTION Properties_Click( myIde )
*----------------------------
LOCAL i, cname, j, Title, aLabels, aInitValues, aFormats, aResults, ctipo, jh, nn, temp

   WITH OBJECT myForm

      h := GetFormHandle ( :designform )
      BaseRow    := GetWindowRow ( h ) + GetBorderHeight()
      BaseCol    := GetWindowCol ( h ) + GetBorderWidth()
      BaseWidth    := GetWindowWidth ( h )
      BaseHeight    := GetWindowHeight ( h )
      TitleHeight    := GetTitleHeight()
      BorderWidth    := GetBorderWidth()
      BorderHeight    := GetBorderHeight()

      i := nhandlep
      IF i > 0
         ocontrol:=getformobject('Form_1'):acontrols[i]
         IF ocontrol:type == 'FRAME'
            cName:=lower(ocontrol:name)
            J:=ascan( :acontrolw, { |c| lower( c ) == cname  } )
            cname:=:acontrolw[j]
            cnamew:=:aname[j]
            Title:=cnamew+" properties"
            aLabels     := { 'Caption',    'Opaque',    'Transparent',    'Name',    'Enabled',    'Visible',    'Obj' }
            aInitValues := { :acaption[j], :aopaque[j], :atransparent[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j] }
            aFormats    := { 30,           .F.,         .F.,              30,        .F.,          .F.,          31 }
            aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
            IF aresults[1] == NIL
               RETURN NIL
            ENDIF
            IF Len(aresults[1] )>0
               ocontrol:caption:= aresults[1]
            ENDIF
            :acaption[j]:=aresults[1]
            :aopaque[j]:=aresults[2]
            :atransparent[j]:=aresults[3]
            IF .not. empty(aresults[4] )
               :aname[j]:=aresults[4]
            ENDIF
            :aenabled[j]:=aresults[5]
            :avisible[j]:=aresults[6]
            :acobj[j] := aresults[7]
            RETURN NIL
         ELSE
            IF ocontrol:type == 'TAB'
               cname:=lower(ocontrol:name)
               sa:=ascan( :acontrolw, { |c| lower( c ) == cname  } )
               TabProp( i, myIDe )   // propiedades de TAB personalizadas
               cacaptions:=:acaption[sa]
               carreglo:= &cacaptions
               cnametab:=:acontrolw[sa]
               FOR kp:=1 TO len(carreglo)
                  ocontrolaux:=getcontrolobject(cnametab, "Form_1")
                  ocontrol:value:=kp
                  ocontrol:caption:=carreglo[kp]
               NEXT kp
               ocontrol:visible:=.F.
               ocontrol:visible:=.T.
            ELSE
               cName:=lower(ocontrol:name )
               FOR j:=1 TO :ncontrolw
                  IF lower(:acontrolw[j]) == cname
                     cNameW := :aName[j]

                     IF :aCtrlType[j] == "TEXT"
                        Title:=cnamew+" properties"
                        // rhs - se agregan metodos "action" y "action2" y propiedad "image"
                        aLabels     := { 'ToolTip',    'MaxLength',    'UpperCase',    'RightAlign',    'Value',    'Password',    'Lowercase',    'Numeric',    'Inputmask',    'HelpId',    'Field',    'ReadOnly',    'Enabled',    'Visible',    'NoTabStop',    'Date',    'Name',    'Format',    'FocusedPos',    'Valid',    'When',    'Obj',       'Action',    'Action2',    'Image'    }
                        aInitValues := { :atooltip[j], :amaxlength[j], :auppercase[j], :arightalign[j], :avalue[j], :apassword[j], :alowercase[j], :anumeric[j], :ainputmask[j], :ahelpid[j], :afield[j], :areadonly[j], :aenabled[j], :avisible[j], :anotabstop[j], :adate[j], :aname[j], :afields[j], :afocusedpos[j], :avalid[j], :awhen[j], :acobj[j],   :aaction[j], :aaction2[j], :aimage[j] }
                        aFormats    := { 120,          '999',          NIL,            NIL,             40,         .F.,           .F.,            .F.,          30,             '999',       250,        .F.,           .F.,          .F.,          .F.,            .F.,       30,        30,          '99',            250,        250,       31,          250,         250,          250        }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        IF aresults[7] .and. aresults[3]
                           msginfo("Uppercase and Lowercase at the same time It's not logic", "Information")
                           aresults[7]:=.F.
                           aresults[3]:=.F.
                        ENDIF
                        :atooltip[j]:=aresults[1]
                        ocontrol:tooltip:=aresults[1]
                        IF aresults[2] >0
                           :amaxlength[j]:=aresults[2]
                        ELSE
                           :amaxlength[j]:=0
                        ENDIF
                        :auppercase[j]:=aresults[3]
                        :arightalign[j]:= aresults[4]
                        :avalue[j]:=aresults[5]
                        :apassword[j]:= aresults[6]
                        :alowercase[j]:=aresults[7]
                        :anumeric[j]:=aresults[8]
                        :ainputmask[j]:=aresults[9]
                        IF len(aresults[9])>0 .or. aresults[16]
                           :amaxlength[j]:=0
                        ENDIF
                        :ahelpid[j]:=aresults[10]
                        :afield[j]:=aresults[11]
                        :areadonly[j]:=aresults[12]
                        :aenabled[j]:=aresults[13]
                        :avisible[j]:=aresults[14]
                        :anotabstop[j]:=aresults[15]
                        :adate[j]:=aresults[16]
                        IF .not. empty(aresults[17] )
                           :aname[j]:=aresults[17]
                        ENDIF
                        :afields[j]:=aresults[18]
                        :afocusedpos[j]:=aresults[19]  // pb
                        :avalid[j]:=aresults[20]
                        :awhen[j]:=aresults[21]
                        :acobj[j]:=aresults[22]     //gca
                        :aaction[j]:=aresults[23]   //rhs
                        :aaction2[j]:=aresults[24]  //rhs
                        :aimage[j]:=aresults[25]    //rhs
                     ENDIF

                     IF :aCtrlType[j] == "IPADDRESS"
                        Title:=cnamew+" properties"
                        aLabels     := { 'ToolTip',    'Value',    'HelpId',    'Enabled',    'Visible',    'NoTabStop',    'Name',    'Obj' }
                        aInitValues := { :atooltip[j], :avalue[j], :ahelpid[j], :aenabled[j], :avisible[j], :anotabstop[j], :aname[j], :acobj[j] }
                        aFormats    := { 120,          30,         '999',       .T.,          .T.,          .F.,            30,        31   }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :atooltip[j]:=aresults[1]
                        ocontrol:tooltip:=aresults[1]
                        IF len(aresults[2])>0
                           ocontrol:value:= aresults[2]
                           :avalue[j]:=aresults[2]
                        ELSE
                           :avalue[j]:=aresults[2]
                           ocontrol:value:="   .   .   .   "
                        ENDIF
                        :ahelpid[j]:=aresults[3]
                        :aenabled[j]:=aresults[4]
                        :avisible[j]:=aresults[5]
                        :anotabstop[j]:=aresults[6]
                        IF .not. empty(aresults[7] )
                           :aname[j]:=aresults[7]
                        ENDIF
                        :acobj[j]:=aresults[8]
                     ENDIF

                     IF :aCtrlType[j] == "HYPERLINK"
                        Title:=cnamew+" properties"
                        aLabels     := { 'ToolTip',    'Value',    'HelpId',    'Enabled',    'Visible',    'Address',    'HandCursor',    'Name',    'Obj' }
                        aInitValues := { :atooltip[j], :avalue[j], :ahelpid[j], :aenabled[j], :avisible[j], :aaddress[j], :ahandcursor[j], :aname[j], :acobj[j] }
                        aFormats    := { 120,          30,         '999',       .T.,          .T.,          60,           .F.,             30,        31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :atooltip[j]:=aresults[1]
                        ocontrol:tooltip:=aresults[1]
                        IF len(aresults[2])>0
                           ocontrol:value:= aresults[2]
                           :avalue[j]:=aresults[2]
                        ENDIF
                        :ahelpid[j]:=aresults[3]
                        :aenabled[j]:=aresults[4]
                        :avisible[j]:=aresults[5]
                        :aaddress[j]:=aresults[6]
                        :ahandcursor[j]:=aresults[7]
                        IF .not. empty(aresults[8] )
                           :aname[j]:=aresults[8]
                        ENDIF
                        :acobj[j]:=aresults[9]
                     ENDIF

                     IF :aCtrlType[j] == "TREE"
                        Title:=cnamew+" properties"
                        aLabels     := { 'ToolTip',    'Enabled',    'Visible',    'Name',    'NodeImages',    'ItemImages',    'NoRootButton',    'ItemIds',    'HelpId',    'Obj' }
                        aInitValues := { :atooltip[j], :aenabled[j], :avisible[j], :aname[j], :Anodeimages[j], :aitemimages[j], :anorootbutton[j], :aitemids[j], :ahelpid[j], :acobj[j] }
                        aFormats    := { 120,          .T.,          .T.,          60,        60,              60,              .F.,               .F.,          '999',       31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :atooltip[j]:=aresults[1]
                        ocontrol:tooltip:=aresults[1]
                        :aenabled[j]:=aresults[2]
                        :avisible[j]:=aresults[3]
                        IF .not. empty(aresults[4] )
                           :aname[j]:=aresults[4]
                        ENDIF
                        :anodeimages[j]:=aresults[5]
                        :aitemimages[j]:=aresults[6]
                        :anorootbutton[j]:=aresults[7]
                        :aitemids[j]:=aresults[8]
                        :ahelpid[j]:=aresults[9]
                        :acobj[j]:=aresults[10]
                     ENDIF

                     IF :aCtrlType[j] == "EDIT"
                        Title:=cnamew+" properties"
                        aLabels     := { 'ToolTip',    'MaxLength',    'ReadOnly',    'Value',    'HelpId',    'Break',    'Field',    'Name',    'Enabled',    'Visible',   'NoTabStop',    'NoVScroll',    'NoHScroll',    'Obj' }
                        aInitValues := { :atooltip[j], :amaxlength[j], :areadonly[j], :avalue[j], :ahelpid[j], :abreak[j], :afield[j], :aname[j], :aenabled[j], :avisible[j], :anotabstop[j], :anovscroll[j], :anohscroll[j], :acobj[j] }
                        aFormats    := { 120,          '999999',       .F.,           800,        '999',       .F.,        250,        30,        .F.,          .F.,         .F.,            .F.,            .F.,            31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :atooltip[j]:=aresults[1]
                        ocontrol:tooltip:=aresults[1]
                        IF aresults[2] >0
                           :amaxlength[j]:=aresults[2]
                        ELSE
                           :amaxlength[j]:=0
                        ENDIF
                        :areadonly[j]:=aresults[3]
                        ocontrol:value:= aresults[4]
                        :avalue[j]:=aresults[4]
                        :ahelpid[j]:=aresults[5]
                        :abreak[j]:=aresults[6]
                        :afield[j]:=aresults[7]
                        IF .not. empty(aresults[8] )
                           :aname[j]:=aresults[8]
                        ENDIF
                        :aenabled[j]:=aresults[9]
                        :avisible[j]:=aresults[10]
                        :anotabstop[j]:=aresults[11]
                        :anovscroll[j]:=aresults[12]
                        :anohscroll[j]:=aresults[13]
                        :acobj[j]:=aresults[14]
                     ENDIF

                     IF :aCtrlType[j] == "RICHEDIT"
                        Title:=cnamew+" properties"
                        aLabels     := { 'ToolTip',    'MaxLength',    'ReadOnly',    'Value',    'HelpId',    'Break',    'Field',    'Name',    'Enabled',    'Visible',    'NoTabStop',    'Obj' }
                        aInitValues := { :atooltip[j], :amaxlength[j], :areadonly[j], :avalue[j], :ahelpid[j], :abreak[j], :afield[j], :aname[j], :aenabled[j], :avisible[j], :anotabstop[j], :acobj[j] }
                        aFormats    := { 120,          '999999',       .F.,           800,        '999',       .F.,        250,        30,        .F.,          .F.,          .F.,            31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :atooltip[j]:=aresults[1]
                        ocontrol:tooltip:=aresults[1]
                        IF aresults[2] >0
                           :amaxlength[j]:=aresults[2]
                        ELSE
                           :amaxlength[j]:=0
                        ENDIF
                        :areadonly[j]:=aresults[3]
                        IF len(aresults[4])>0
                           ocontrol:value:= aresults[4]
                           :avalue[j]:=aresults[4]
                        ELSE
                           :avalue[j]:=aresults[4]
                           ocontrol:value:= ""
                        ENDIF
                        :ahelpid[j]:=aresults[5]
                        :abreak[j]:=aresults[6]
                        :afield[j]:=aresults[7]
                        IF .not. empty(aresults[8] )
                           :aname[j]:=aresults[8]
                        ENDIF
                        :aenabled[j]:=aresults[9]
                        :avisible[j]:=aresults[10]
                        :anotabstop[j]:=aresults[11]
                        :acobj[j]:=aresults[12]
                     ENDIF

                     IF :aCtrlType[j] == "GRID"
                        Title:=cnamew+" properties"
                        myide:lvirtual:=.T.
                        aLabels     := { 'Headers',    'Widths',    'Items',    'Value',    'ToolTip',    'MultiSelect',    'NoLines',    'Image',    'HelpId',    'Break',    'Justify',    'Name',    'Enabled',    'Visible',    "DynamicBackColor",    "DynamicForeColor",    "ColumnControls",    "Valid",    "ValidMessages", "When",    "ReadOnly",     "InPlace",    "InputMask",    "Edit",    'Obj' }
                        aInitValues := { :aheaders[j], :awidths[j], :aitems[j], :avalue[j], :atooltip[j], :amultiselect[j], :anolines[j], :aimage[j], :ahelpid[j], :abreak[j], :ajustify[j], :aname[j], :aenabled[j], :avisible[j], :adynamicbackcolor[j], :adynamicforecolor[j], :acolumncontrols[j], :avalid[j], :avalidmess[j],   :awhen[j], :areadonlyb[j], :ainplace[j], :ainputmask[j], :aedit[j], :acobj[j] }
                        aFormats    := { 800,          800,         800,        60,         250,          .F.,              .F.,          60,         '999',       .F.,        350,          30,        .F.,          .F.,          350,                   350,                   800,                 800,        800,              800,       800,            .T.,          800,            .T.,       31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :aheaders[j]:=aresults[1]
                        :awidths[j]:=aresults[2]
                        :aitems[j]:=aresults[3]
                        :avalue[j]:=aresults[4]
                        :atooltip[j]:=aresults[5]
                        :amultiselect[j]:=aresults[6]
                        :anolines[j]:=aresults[7]
                        :aimage[j]:=aresults[8]
                        :ahelpid[j]:=aresults[9]
                        :abreak[j]:=aresults[10]
                        IF len(aresults[11])>0
                            :ajustify[j]:=aresults[11]
                        ENDIF
                        IF .not. empty(aresults[12] )
                           :aname[j]:=aresults[12]
                        ENDIF
                        :aenabled[j]:=aresults[13]
                        :avisible[j]:=aresults[14]
                        :adynamicbackcolor[j]:=aresults[15]
                        :adynamicforecolor[j]:=aresults[16]
                        :acolumncontrols[j]:=aresults[17]
                        :avalid[j]:=aresults[18]
                        :avalidmess[j]:=aresults[19]
                        :awhen[j]:=aresults[20]
                        :areadonlyb[j]:=aresults[21]
                        :ainplace[j]:=aresults[22]
                        :ainputmask[j]:=aresults[23]
                        :aedit[j]:=aresults[24]
                        :acobj[j]:=aresults[25]
                     ENDIF

                     IF :aCtrlType[j] == "LABEL"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Value',    'HelpId',    'Transparent',    'CenterAlign',    'RightAlign',    'ToolTip',    'Name',    'AutoSize',    "Enabled",    "Visible",    "ClientEdge",    "Border",   'Obj',     "InputMask" }
                        aInitValues := { :avalue[j], :ahelpid[j], :atransparent[j], :acenteralign[j], :arightalign[j], :atooltip[j], :aname[j], :aautoplay[j], :aenabled[j], :avisible[j], :aclientedge[j], :aborder[j], :acobj[j], :ainputmask[j] }
                        aFormats    := { 300,        '999',       .F.,              .F.,              .F.,             120,          30,        .F.,           .F.,          .F.,          .F.,             .F.,         31,        800 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        IF len(aresults[1])>0
                           :avalue[j]:=aresults[1]
                             ocontrol:value:=aresults[1]
                        ELSE
                           :avalue[j]:=aresults[1]
                             ocontrol:value:="Empty label"
                        ENDIF
                        :ahelpid[j]:=aresults[2]
                        :atransparent[j]:=aresults[3]
                        :acenteralign[j]:=aresults[4]
                        IF aresults[4]
                           ocontrol:align := SS_CENTER
                        ENDIF
                        :arightalign[j]:=aresults[5]
                        IF aresults[5]
                           ocontrol:align := SS_RIGHT
                        ENDIF
                        IF .not. aresults[4] .and. .not. aresults[5]
                           ocontrol:align := SS_LEFT
                        ENDIF
                        :atooltip[j]:=ltrim(aresults[6])
                        IF len(aresults[7])>0
                           :aname[j]:=strtran(aresults[7], " ", "")
                        ENDIF
                        :aautoplay[j]:=aresults[8]
                        :aenabled[j]:=aresults[9]
                        :avisible[j]:=aresults[10]
                        :aclientedge[j]:=aresults[11]
                        :aborder[j]:=aresults[12]
                        :acobj[j]:=aresults[13]
                        :ainputmask[j] := aresults[14]
                     ENDIF

                     IF :aCtrlType[j] == "PROGRESSBAR"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Range',    'ToolTip',    'Vertical',    'Smooth',    'HelpId',    'Name',    'Enabled',    'Visible',    'Obj' }
                        aInitValues := { :arange[j], :atooltip[j], :avertical[j], :asmooth[j], :ahelpid[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j] }
                        aFormats    := { 20,         120,          .F.,           .F.,         '999',       30,        .F.,          .F.,          31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :arange[j]:=aresults[1]
                        :atooltip[j]:=aresults[2]
                        ocontrol:tooltip:=aresults[2]
                        :avertical[j]:=aresults[3]
                        :asmooth[j]:=aresults[4]
                        :ahelpid[j]:=aresults[5]
                        IF .not. empty(aresults[6] )
                           :aname[j]:=aresults[6]
                        ENDIF
                        ocontrol:value:=:aname[j]
                        :aenabled[j]:=aresults[7]
                        :avisible[j]:=aresults[8]
                        :acobj[j]:=aresults[9]
                     ENDIF

                     IF :aCtrlType[j] == "SLIDER"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Range',    'Value ',    'ToolTip',    'Vertical',    'Both',    'Top',    'Left',    'HelpId',    'Name',    'Enabled',    'Visible',    'Obj',    'NoTicks' }
                        aInitValues := { :arange[j], :avaluen[j], :atooltip[j], :avertical[j], :aboth[j], :atop[j], :aleft[j], :ahelpid[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j], :anoticks[j] }
                        aFormats    := { 20,         '999',       120,          .F.,           .F.,       .F.,      .F.,       '999',       30,        .F.,          .F.,          31,        .F.  }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :arange[j]:=aresults[1]
                        :avaluen[j]:=aresults[2]
                        :atooltip[j]:=aresults[3]
                        ocontrol:tooltip:=aresults[3]
                        :avertical[j]:=aresults[4]
                        nn := WindowStyleFlag( ocontrol:hWnd, 2 )
                        IF (nn=0 .and. aresults[4]) .or. (nn=2 .and. !aresults[4])
                            WindowStyleFlag( ocontrol:hWnd, 2, 2 - nn )
                            temp:=ocontrol:width
                            ocontrol:width:=ocontrol:height
                            ocontrol:height:=temp
                        ENDIF
                        :aboth[j]:=aresults[5]
                        :atop[j]:=aresults[6]
                        :aleft[j]:=aresults[7]
                        :ahelpid[j]:=aresults[8]
                        IF .not. empty(aresults[9] )
                           :aname[j]:=aresults[9]
                        ENDIF
                        :aenabled[j]:=aresults[10]
                        :avisible[j]:=aresults[11]
                        :acobj[j]:=aresults[12]
                        dibuja(cnamew)
                     ENDIF

                     IF :aCtrlType[j] == "SPINNER"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Range',    'Value ',    'ToolTip',    'HelpId',    'NoTabStop',    'Wrap',    'ReadOnly',    'Increment',    'Name',    'Enabled',    'Visible',    'Obj' }
                        aInitValues := { :arange[j], :avaluen[j], :atooltip[j], :ahelpid[j], :anotabstop[j], :awrap[j], :areadonly[j], :aincrement[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j] }
                        aFormats    := { 30,         '99999',     120,          '999',       .F.,            .F.,       .F.,           '999999',       30,        .F.,          .F.,          31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :arange[j]:=aresults[1]
                        :avaluen[j]:=aresults[2]
                        :atooltip[j]:=aresults[3]
                        ocontrol:tooltip:=aresults[3]
                        :ahelpid[j]:=aresults[4]
                        :anotabstop[j]:=aresults[5]
                        :awrap[j]:=aresults[6]
                        :areadonly[j]:=aresults[7]
                        :aincrement[j]:=aresults[8]
                        IF .not. empty(aresults[9] )
                           :aname[j]:=aresults[9]
                        ENDIF
                        :aenabled[j]:=aresults[10]
                        :avisible[j]:=aresults[11]
                        :acobj[j]:=aresults[12]
                     ENDIF

                     IF :aCtrlType[j] == "BUTTON"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Caption',    'ToolTip',    'HelpId',    'NoTabStop',    'Enabled',    'Visible',    'Name',    'Flat',    'Picture',    "Alignment",  'Obj' }
                        aInitValues := { :acaption[j], :atooltip[j], :ahelpid[j], :anotabstop[j], :aenabled[j], :avisible[j], :aname[j], :aflat[j], :aPicture[j], :Ajustify[j], :acobj[j] }
                        aFormats    := { 300,          120,          '999',       .F.,            .T.,          .T.,          30,        .T.,       40,           20,           31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        IF len(aresults[1])>0
                           :acaption[j]:=aresults[1]
                           ocontrol:caption:=aresults[1]
                        ELSE
                           :acaption[j]:=aresults[1]
                           ocontrol:caption:=cname
                        ENDIF
                        :atooltip[j]:=aresults[2]
                        ocontrol:tooltip:=aresults[2]
                        :ahelpid[j]:=aresults[3]
                        :anotabstop[j]:=aresults[4]
                        :aenabled[j]:=aresults[5]
                        :avisible[j]:=aresults[6]
                        IF .not. empty(aresults[7] )
                           :aname[j]:=aresults[7]
                        ENDIF
                        :aflat[j]:=aresults[8]
                        :apicture[j]:=aresults[9]
                        :ajustify[j]:=aresults[10]
                        :acobj[j]:=aresults[11]
                     ENDIF

                     IF :aCtrlType[j] == "CHECKBOX"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Value',     'Caption',    'ToolTip',    'HelpId',    'Field',    'Transparent',    'Enabled',    'Visible',    'Name',    "NoTabStop",    'Obj' }
                        aInitValues := { :avaluel[j], :acaption[j], :atooltip[j], :ahelpid[j], :afield[j], :atransparent[j], :aenabled[j], :avisible[j], :aname[j], :anotabstop[j], :acobj[j] }
                        aFormats    := { .F.,         31,           120,          '999',       250,        .F.,              .F.,          .F.,          30,        .F.,            31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :avaluel[j]:=aresults[1]
                        ocontrol:value:= aresults[1]
                        :acaption[j]:=aresults[2]
                        ocontrol:caption:= aresults[2]
                        :atooltip[j]:=aresults[3]
                        ocontrol:tooltip:=aresults[3]
                        :ahelpid[j]:=aresults[4]
                        :afield[j]:=aresults[5]
                        :atransparent[j]:=aresults[6]
                        :aenabled[j]:=aresults[7]
                        :avisible[j]:=aresults[8]
                        IF .not. empty(aresults[9] )
                           :aname[j]:=aresults[9]
                        ENDIF
                        :anotabstop[j]:=aresults[10]
                        :acobj[j]:=aresults[11]
                     ENDIF

                     IF :aCtrlType[j] == "LIST"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Value',     'Items',    'ToolTip',    'MultiSelect',    'HelpId',    'Break',    'NoTabStop',    'Sort',    'Name',    'Enabled',    'Visible',    'Obj' }
                        aInitValues := { :avaluen[j], :aitems[j], :atooltip[j], :amultiselect[j], :ahelpid[j], :abreak[j], :anotabstop[j], :asort[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j] }
                        aFormats    := { '999',       800,        120,          .F.,              '999',       .F.,        .F.,            .F.,       30,        .F.,          .F.,          31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :avaluen[j]:=aresults[1]
                        ocontrol:value:=aresults[1]
                        IF len(aresults[2])>0
                           :aitems[j]:=aresults[2]
                        ELSE
                           :aitems[j]:=""
                        ENDIF
                        IF len(aresults[3])>0
                           :atooltip[j]:=aresults[3]
                        ELSE
                           :atooltip[j]:=""
                        ENDIF
                        ocontrol:tooltip:=aresults[3]
                        :amultiselect[j]:=aresults[4]
                        :ahelpid[j]:=aresults[5]
                        :abreak[j]:=aresults[6]
                        :anotabstop[j]:=aresults[7]
                        :asort[j]:=aresults[8]
                        IF .not. empty(aresults[9] )
                           :aname[j]:=aresults[9]
                        ENDIF
                        :aenabled[j]:=aresults[10]
                        :avisible[j]:=aresults[11]
                        :acobj[j]:=aresults[12]
                     ENDIF

                     IF :aCtrlType[j] == "BROWSE"
                        myide:lvirtual:=.T.
                        Title:=cnamew+" properties"
                        aLabels     := { 'Headers',    'Widths',    'WorkArea',    'Fields',    'Value ',    'ToolTip',    'Valid',    'ValidMessages', 'ReadOnly',     'Lock',    'Delete',    'NoLines',    'Image',    'Justify',    'HelpId',    'Name',    'Enabled',    'Visible',    "When",   "DynamicBackColor",      "DynamicForeColor",    "ColumnControls",    "InputMask",    "InPlace",    "Edit",    "Append",    'Obj' }
                        aInitValues := { :aheaders[j], :awidths[j], :aworkarea[j], :afields[j], :avaluen[j], :atooltip[j], :avalid[j], :avalidmess[j],  :areadonlyb[j], :alock[j], :adelete[j], :anolines[j], :aimage[j], :ajustify[j], :ahelpid[j], :aname[j], :aenabled[j], :avisible[j], :awhen[j] , :adynamicbackcolor[j], :adynamicforecolor[j], :acolumncontrols[j], :ainputmask[j], :ainplace[j], :aedit[j], :aappend[j], :acobj[j] }
                        aFormats    := { 800,          800,         80,            800,         '999999',    250,          800,        800,             800,            .T.,       .F.,         .F.,          800,        800,          '99999',     30,        .F.,          .F.,          800,      800,                     800,                   800,                 800,            .F.,          .F.,       .F.,          31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :aheaders[j]:=aresults[1]
                        :awidths[j]:=aresults[2]
                        :aworkarea[j]:=aresults[3]
                        :afields[j]:=aresults[4]
                        :avaluen[j]:=aresults[5]
                        :atooltip[j]:=aresults[6]
                        :avalid[j]:=aresults[7]
                        :avalidmess[j]:=aresults[8]
                        :areadonlyb[j]:=aresults[9]
                        :alock[j]:=aresults[10]
                        :adelete[j]:=aresults[11]
                        :anolines[j]:=aresults[12]
                        :aimage[j]:=aresults[13]
                        :ajustify[j]:=aresults[14]
                        :ahelpid[j]:=aresults[15]
                        IF .not. empty(aresults[16] )
                          :aname[j]:=aresults[16]
                        ENDIF
                        :aenabled[j]:=aresults[17]
                        :avisible[j]:=aresults[18]
                        :awhen[j]:=aresults[19]
                        :adynamicbackcolor[j]:=aresults[20]
                        :adynamicforecolor[j]:=aresults[21]
                        :acolumncontrols[j]:=aresults[22]
                        :ainputmask[j]:=aresults[23]
                        :ainplace[j]:=aresults[24]
                        :aedit[j]:=aresults[25]
                        :aappend[j]:=aresults[26]
                        :acobj[j]:=aresults[27]
                     ENDIF

                     IF :aCtrlType[j] == "RADIOGROUP"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Value',     'Options',  'ToolTip',    'Spacing',    'HelpId',    'Transparent',    'Name',    'Enabled',    'Visible',    'Obj'  }
                        aInitValues := { :avaluen[j], :aitems[j], :atooltip[j], :aspacing[j], :ahelpid[j], :atransparent[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j] }
                        aFormats    := { '999',       250,        120,          '999',        '999',       .F.,              30,        .F.,          .F.,          31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        nllaves1:=0
                        nllaves2:=0
                        citems:=ltrim(rtrim(aresults[2]))
                        FOR ki:=1 TO len(citems)
                           IF substr(citems, ki, 1)='{'
                              nllaves1++
                           ELSE
                              IF substr(citems, ki, 1)='}'
                                 nllaves2++
                              ENDIF
                           ENDIF
                        NEXT ki
                        IF (len(&citems)<2) .or. (nllaves1#1) .or. (nllaves2#1)
                           citems:="{'option 1', 'option 2'}"
                           msginfo('minimun 2 options', 'Information')
                           RETURN NIL
                        ENDIF
                        :avaluen[j]:=aresults[1]
                        :aitems[j]:=aresults[2]
                        IF len(aresults[3])>0
                           :atooltip[j]:=aresults[3]
                        ENDIF
                        :aspacing[j]:=aresults[4]
                        :ahelpid[j]:=aresults[5]
                        :atransparent[j]:=aresults[6]
                        IF .not. empty(aresults[7] )
                           :aname[j]:=aresults[7]
                        ENDIF
                        :aenabled[j]:=aresults[8]
                        :avisible[j]:=aresults[9]
                        :acobj[j]:=aresults[10]
                        ocontrol:height:= aresults[4]*len(&citems)+8
                     ENDIF

                     IF :aCtrlType[j] == "COMBO"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Value',     'Items',    'ToolTip',    'HelpId',    'NoTabStop',    'Sort',    'ItemSource',    'Enabled',    'Visible',    'Valuesource',    'Name',    'Break',    "DisplayEdit",    'Obj' }
                        aInitValues := { :avaluen[j], :aitems[j], :atooltip[j], :ahelpid[j], :anotabstop[j], :asort[j], :aitemsource[j], :aenabled[j], :avisible[j], :avaluesource[j], :aname[j], :abreak[j], :adisplayedit[j], :acobj[j] }
                        aFormats    := { '999',       250,        120,          '999',       .F.,            .F.,       100,             .T.,          .T.,          100,              30,        .F.,        .F.,              31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :avaluen[j]:=aresults[1]
                        IF len(aresults[2])>0
                           :aitems[j]:=aresults[2]
                        ELSE
                           :aitems[j]:=""
                        ENDIF
                        :atooltip[j]:=aresults[3]
                        ocontrol:tooltip:=aresults[3]
                        :ahelpid[j]:=aresults[4]
                        :anotabstop[j]:=aresults[5]
                        :asort[j]:=  aresults[6]
                        :aitemsource[j]:=aresults[7]
                        IF len(aresults[7])>0
                           :aitems[j]:=''
                        ENDIF
                        :aenabled[j]:=aresults[8]
                        :avisible[j]:=aresults[9]
                        :avaluesource[j]:=aresults[10]
                        IF .not. empty(aresults[11] )
                           :aname[j]:=aresults[11]
                        ENDIF
                        :abreak[j]:=aresults[12]
                        :adisplayedit[j]:=aresults[13]
                        :acobj[j]:=aresults[14]
                     ENDIF

                     IF :aCtrlType[j] == "CHECKBTN"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Value',     'Caption',    'ToolTip',    'HelpId',    'Name',    'Enabled',    'Visible',    "NoTabStop",    'Obj' }
                        aInitValues := { :avaluel[j], :acaption[j], :atooltip[j], :ahelpid[j], :aname[j], :aenabled[j], :avisible[j], :anotabstop[j], :acobj[j] }
                        aFormats    := { .F.,         31,           120,          '999',       30,        .F.,          .F.,          .F.,            31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :avaluel[j]:=aresults[1]
                        ocontrol:value:=aresults[1]
                        IF len(aresults[2])>0
                           :acaption[j]:=aresults[2]
                           ocontrol:caption:=aresults[2]
                        ELSE
                           :acaption[j]:=""
                           ocontrol:caption:=cname
                        ENDIF
                        :atooltip[j]:=aresults[3]
                        ocontrol:tooltip:=aresults[3]
                        :ahelpid[j]:=aresults[4]
                        IF .not. empty(aresults[5] )
                           :aname[j]:=aresults[5]
                        ENDIF
                        :aenabled[j]:=aresults[6]
                        :avisible[j]:=aresults[7]
                        :anotabstop[j]:=aresults[8]
                        :acobj[j]:=aresults[9]
                     ENDIF

                     IF :aCtrlType[j] == "PICCHECKBUTT"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Value',     'Picture',    'ToolTip',    'HelpId',    'Name',    'Enabled',    'Visible',    "NoTabStop",    'Obj' }
                        aInitValues := { :avaluel[j], :apicture[j], :atooltip[j], :ahelpid[j], :aname[j], :aenabled[j], :avisible[j], :anotabstop[j], :acobj[j] }
                        aFormats    := { .F.,         31,           120,          '999',       30,        .F.,          .F.,          .F.,            31 }
                         aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :avaluel[j]:=aresults[1]
                        ocontrol:value:=:avaluel[j]
                        IF len(aresults[2])>0
                           :apicture[j]:=aresults[2]
                        ELSE
                           :apicture[j]:=""
                        ENDIF
                        :atooltip[j]:=aresults[3]
                        ocontrol:tooltip:=aresults[3]
                        :ahelpid[j]:=aresults[4]
                        IF .not. empty(aresults[5] )
                           :aname[j]:=aresults[5]
                        ENDIF
                        :aenabled[j]:=aresults[6]
                        :avisible[j]:=aresults[7]
                        :anotabstop[j]:=aresults[8]
                        :acobj[j]:=aresults[9]
                     ENDIF

                     IF :aCtrlType[j] == "PICBUTT"
                        Title       := cNameW + " properties"
                        aLabels     := { 'Picture',    'ToolTip',    'HelpId',    'NoTabStop',    'Name',    'Enabled',    'Visible',    'Flat',    'Obj' }
                        aInitValues := { :apicture[j], :atooltip[j], :ahelpid[j], :anotabstop[j], :aname[j], :aenabled[j], :avisible[j], :aflat[j], :acobj[j] }
                        aFormats    := { 30,           120,          '999',       .F.,            30,        .T.,          .T.,          .F.,       31  }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        IF Len( aresults[1] ) > 0
                          :apicture[j]  := aresults[1]
                        ELSE
                           :apicture[j]  := aresults[1]
                        ENDIF
                        :atooltip[j]     := aresults[2]
                        ocontrol:tooltip := aresults[2]
                        :ahelpid[j]      := aresults[3]
                        :anotabstop[j]   := aresults[4]
                        IF ! Empty( aresults[5] )
                           :aname[j]     := aresults[5]
                        ENDIF
                        :aenabled[j]     := aresults[6]
                        :avisible[j]     := aresults[7]
                        :aflat[j]        := aresults[8]
                        :acobj[j]        := aresults[9]
                     ENDIF

                     IF :aCtrlType[j] == "IMAGE"
                        Title       := cNameW + " properties"
                        aLabels     := { 'Picture',    'ToolTip',    'HelpId',    'Stretch',    'Name',    'Enabled',    'Visible',    'Obj',     "ClientEdge",    "Border",    'Transparent' }
                        aInitValues := { :apicture[j], :atooltip[j], :ahelpid[j], :astretch[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j], :aclientedge[j], :aborder[j], :atransparent[j] }
                        aFormats    := { 30,           120,          '999',       .F.,          30,        .F.,          .F.,          31,        .F.,             .F.,         .F. }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        IF Len( aresults[1] ) > 0
                           :apicture[j]   := aresults[1]
                        ENDIF
                        :atooltip[j]      := aresults[2]
                        :ahelpid[j]       := aresults[3]
                        :astretch[j]      := aresults[4]
                        IF ! Empty(aresults[5])
                           ocontrol:value := ;
                           :aname[j]      := aresults[5]
                        ENDIF
                        :aenabled[j]      := aresults[6]
                        :avisible[j]      := aresults[7]
                        :acobj[j]         := aresults[8]
                        :aclientedge[j]   := aresults[9]
                        :aborder[j]       := aresults[10]
                        :atransparent[j]  := aresults[11]
                     ENDIF

                     IF :aCtrlType[j] == "TIMER"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Interval',  'Name',    'Enabled',    'Obj' }
                        aInitValues := { :avaluen[j], :aname[j], :aenabled[j], :acobj[j]    }
                        aFormats    := { '9999999', 30, .F., 31}
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                          RETURN NIL
                        ENDIF
                        IF aresults[1]>0
                           :avaluen[j]:=aresults[1]
                        ENDIF
                        IF .not. empty(aresults[2])
                           :aname[j]:=aresults[2]
                        ENDIF
                        ocontrol:value:=:aname[j]
                        :aenabled[j]:=aresults[3]
                        :acobj[j]:=aresults[4]
                     ENDIF

                     IF :aCtrlType[j] == "ANIMATE"
                        Title:=cnamew+" properties"
                        aLabels     := { 'File',    'Autoplay',    'Center ',   'Transparent',    'HelpId',    'ToolTip',    'Name',    'Enabled',    'Visible',    'Obj' }
                        aInitValues := { :afile[j], :aautoplay[j], :acenter[j], :atransparent[j], :ahelpid[j], :atooltip[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j] }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                          RETURN NIL
                        ENDIF
                        :afile[j]:=aresults[1]
                        :aautoplay[j]:=aresults[2]
                        :acenter[j]:=aresults[3]
                        :atransparent[j]:=aresults[4]
                        :ahelpid[j]:=aresults[5]
                        :atooltip[j]:=aresults[6]
                        ocontrol:tooltip:=aresults[6]
                        IF .not. empty(aresults[7])
                           :aname[j]:=aresults[7]
                        ENDIF
                        :aenabled[j]:=aresults[8]
                        :avisible[j]:=aresults[9]
                        :acobj[j]:=aresults[10]
                     ENDIF

                     IF :aCtrlType[j] == "PLAYER"
                        Title:=cnamew+" properties"
                        aLabels     := { 'File',    'HelpId',    'Name',    'Enabled',    'Visible',    'Obj' }
                        aInitValues := { :afile[j], :ahelpid[j], :aname[j], :aenabled[j], :avisible[j], :acobj[j] }
                        aFormats    := { 30,        '999',       30,        .F.,          .F.,          31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :afile[j]:=aresults[1]
                        :ahelpid[j]:=aresults[2]
                        IF .not. empty(aresults[3] )
                           :aname[j]:=aresults[3]
                        ENDIF
                        :aenabled[j]:=aresults[4]
                        :avisible[j]:=aresults[5]
                        :acobj[j]:=aresults[6]
                     ENDIF

                     IF :aCtrlType[j] == "DATEPICKER"
                        Title:=cnamew+" properties"
                        aLabels     := { 'Value',    'ToolTip',    'ShowNone',    'UpDown',    'RightAlign',    'HelpId',    'Field',    'Visible',    'Enabled',    'Name',    'Obj' }
                        aInitValues := { :avalue[j], :atooltip[j], :ashownone[j], :aupdown[j], :arightalign[j], :ahelpid[j], :afield[j], :avisible[j], :aenabled[j], :aname[j], :acobj[j] }
                        aFormats    := { 20,         120,          .F.,           .F.,         .F.,             '999',       250,        .T.,          .T.,          30,        31 }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :avalue[j]:=aresults[1]
                        :atooltip[j]:=aresults[2]
                        ocontrol:tooltip:=aresults[2]
                        :ashownone[j]:=aresults[3]
                        :aupdown[j]:=aresults[4]
                        :arightalign[j]:=aresults[5]
                        :ahelpid[j]:=aresults[6]
                        :afield[j]:=aresults[7]
                        :avisible[j]:=aresults[08]
                        :aenabled[j]:=aresults[09]
                        IF .not. empty(aresults[10] )
                           :aname[j]:=aresults[10]
                        ENDIF
                        :acobj[j]:=aresults[11]
                     ENDIF

                     IF :aCtrlType[j] == "MONTHCALENDAR"
                        Title       := cNameW + " properties"
                        aLabels     := { 'Value',    'ToolTip',    'NoToday',    'NoTodayCircle',    'WeekNumbers',    'HelpId',    'Visible',    'Enabled',    'Name',    'Obj',     'NoTabStop' }
                        aInitValues := { :avalue[j], :atooltip[j], :anotoday[j], :anotodaycircle[j], :aweeknumbers[j], :ahelpid[j], :avisible[j], :aenabled[j], :aname[j], :acobj[j], :anotabstop[j] }
                        aFormats    := { 30,         120,          .F.,          .F.,                .F.,              '999',       .T.,          .T.,          30,        31,        .F. }
                        aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                        IF aresults[1] == NIL
                           RETURN NIL
                        ENDIF
                        :afontname[j]:=aresults[1]
                        IF len(aresults[1])>0
                           :avalue[j]:=aresults[1]
                        ELSE
                           :avalue[j]:=aresults[1]
                        ENDIF
                        :atooltip[j]:=aresults[2]
                        ocontrol:tooltip:=aresults[2]
                        :anotoday[j]:=aresults[3]
                        :anotodaycircle[j]:=aresults[4]
                        :aweeknumbers[j]:=aresults[5]
                        :ahelpid[j]:=aresults[6]
                        :avisible[j]:=aresults[7]
                        :aenabled[j]:=aresults[8]
                        IF .not. empty(aresults[9]  )
                           :aname[j]:=aresults[9]
                        ENDIF
                        :acobj[j]:=aresults[10]
                        :anotabstop[j] := aresults[11]
                     ENDIF

                  ENDIF
               NEXT j
            ENDIF
         ENDIF
      ENDIF

      :lFsave:=.F.
      RefreshControlInspector()
   END
RETURN NIL

*-------------------------
FUNCTION Events_Click( myIDe )
*-------------------------
LOCAL i, cname, j, Title, aLabels, aInitValues, aFormats, aResults

   WITH OBJECT myForm
      i = nhandlep
      IF i > 0
         ocontrol:=getformobject('Form_1'):acontrols[i]
         cname:=lower(ocontrol:name)
         x:=ascan(:acontrolw, { |c| lower( c ) ==  cname  } )
         IF ocontrol:type  == 'TAB'
            Tabevent( i )
            :lFsave:=.F.
            RETURN NIL
         ELSE
            cName:=lower(ocontrol:name)
            nform:=1
            FOR j:=1 TO :ncontrolw
               IF lower(:acontrolw[j]) == cname
                  cnamew:=:aname[j]

                  IF :aCtrlType[j] == "TEXT"
                     Title:=cnamew+" events"
                     aLabels     := { 'On Enter',   'On Change',   'On GotFocus',   'On LostFocus' }
                     aInitValues := { :aonenter[j], :aonchange[j], :aongotfocus[j], :aonlostfocus[j] }
                     aFormats    := { 250,          250,           250,             250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonenter[j]:=aresults[1]
                     :aonchange[j]:=aresults[2]
                     :aongotfocus[j]:=aresults[3]
                     :aonlostfocus[j]:=aresults[4]
                  ENDIF

                  IF :aCtrlType[j] == "BUTTON"
                     Title:=cnamew+" events"
                     aLabels     := { 'On GotFocus',   'On LostFocus',   'Action' }
                     aInitValues := { :aongotfocus[j], :aonlostfocus[j], :aaction[j] }
                     aFormats    := { 250,             250,              250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aongotfocus[j]:=aresults[1]
                     :aonlostfocus[j]:=aresults[2]
                     :aaction[j]:=aresults[3]
                  ENDIF

                  IF :aCtrlType[j] == 'CHECKBOX'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j] }
                     aFormats    := { 250,          250,             250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                  ENDIF

                  IF :aCtrlType[j] == 'IPADDRESS'
                     Title:=cnamew+" events"
                     aLabels     := { 'On change', 'On GotFocus', 'On LostFocus' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j]}
                     aFormats    := { 250,          250,             250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                  ENDIF

                  IF :aCtrlType[j] == 'GRID'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus',   'On DblClick',   'On Enter',   'On Headclcik',   "On EditCell" }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j], :aondblclick[j], :aOnEnter[j], :aonheadclick[j], :aoneditcell[j] }
                     aFormats    := { 250,           250,             250,              250,             250,          250,              800 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                     :aondblclick[j]:=aresults[4]
                     :aonenter[j]:=aresults[5]
                     :aonheadclick[j]:=aresults[6]
                     :aoneditcell[j]:=aresults[7]
                  ENDIF

                  IF :aCtrlType[j] == 'TREE'
                     myide:lvirtual:=.T.
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus',   'On DblClick' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j], :aondblclick[j] }
                     aFormats    := { 250,           250,             250,              250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                     :aondblclick[j]:=aresults[4]
                  ENDIF

                  IF :aCtrlType[j] == 'BROWSE'
                     myide:lvirtual:=.T.
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus',   'On DblClick',   'On HeadClick',   'On EditCell',   'On Append',   'On Enter' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j], :aondblclick[j], :aonheadclick[j], :aoneditcell[j], :aonappend[j], :aonenter[j] }
                     aFormats    := { 250,           250,             250,              250,             250,              250,             250,           250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                     :aondblclick[j]:=aresults[4]
                     :aonheadclick[j]:=aresults[5]
                     :aoneditcell[j]:=aresults[6]
                     :aonappend[j]:=aresults[7]
                     :aonenter[j]:=aresults[8]
                  ENDIF

                  IF :aCtrlType[j] == 'SPINNER'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j] }
                     aFormats    := { 250,           250,             250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                  ENDIF

                  IF :aCtrlType[j] == 'LIST'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus',   'On DblClick' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j], :aOndblclick[j] }
                     aFormats    := { 250,           250,             250,              250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                     :aondblclick[j]:=aresults[4]
                  ENDIF

                  IF :aCtrlType[j] == 'COMBO'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus',   'On Enter',   'On DisplayChange' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j], :aonenter[j], :aondisplaychange[j] }
                     aFormats    := { 250,           250,             250,              250,          250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                     :aonenter[j]:=aresults[4]
                     :aondisplaychange[j]:=aresults[5]
                  ENDIF

                  IF :aCtrlType[j] == 'CHECKBTN'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j] }
                     aFormats    := { 250,           250,             250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                  ENDIF

                  IF :aCtrlType[j] == 'PICCHECKBUTT'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j] }
                     aFormats    := { 250,           250,             250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                  ENDIF

                  IF :aCtrlType[j] == "PICBUTT"
                     Title:=cnamew+" events"
                     aLabels     := { 'On GotFocus',   'On LostFocus',   'Action'}
                     aInitValues := { :aongotfocus[j], :aonlostfocus[j], :aaction[j] }
                     aFormats    := { 250,             250,              250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aongotfocus[j]:=aresults[1]
                     :aonlostfocus[j]:=aresults[2]
                     :aaction[j]:=aresults[3]
                  ENDIF

                  IF :aCtrlType[j] == "IMAGE"
                     Title:=cnamew+" events"
                     aLabels     := { 'Action' }
                     aInitValues := { :aaction[j] }
                     aFormats    := { 250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aaction[j]:=aresults[1]
                  ENDIF

                  IF :aCtrlType[j] == "MONTHCALENDAR"
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change' }
                     aInitValues := { :aonchange[j] }
                     aFormats    := { 250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                  ENDIF

                  IF :aCtrlType[j] == "TIMER"
                     Title:=cnamew+" events"
                     aLabels     := { 'Action' }
                     aInitValues := { :aaction[j] }
                     aFormats    := { 250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aaction[j]:=aresults[1]
                  ENDIF

                  IF :aCtrlType[j] == "LABEL"
                     Title:=cnamew+" events"
                     aLabels     := { 'Action' }
                     aInitValues := { :aaction[j] }
                     aFormats    := { 250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aaction[j]:=aresults[1]
                  ENDIF

                  IF :aCtrlType[j] == "RADIOGROUP"
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change' }
                     aInitValues := { :aonchange[j] }
                     aFormats    := { 250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                  ENDIF

                  IF :aCtrlType[j] == "SLIDER"
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change' }
                     aInitValues := { :aonchange[j] }
                     aFormats    := { 250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                  ENDIF

                  IF :aCtrlType[j] == 'DATEPICKER'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus',   'On Enter'  }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j], :aonenter[j] }
                     aFormats    := { 250,           250,             250,              250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                     :aonenter[j]:=aresults[4]
                  ENDIF

                  IF :aCtrlType[j] == 'EDIT'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j] }
                     aFormats    := { 250,           250,             250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                  ENDIF

                  IF :aCtrlType[j] == 'RICHEDIT'
                     Title:=cnamew+" events"
                     aLabels     := { 'On Change',   'On GotFocus',   'On LostFocus' }
                     aInitValues := { :aonchange[j], :aongotfocus[j], :aonlostfocus[j]}
                     aFormats    := { 250,           250,             250 }
                     aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
                     IF aresults[1] == NIL
                        RETURN NIL
                     ENDIF
                     :aonchange[j]:=aresults[1]
                     :aongotfocus[j]:=aresults[2]
                     :aonlostfocus[j]:=aresults[3]
                  ENDIF

               ENDIF
            NEXT j
         ENDIF
      ENDIF
      :lFsave:=.F.
   END
RETURN NIL


*-------------------------
FUNCTION FrmProperties( myIde )
*-------------------------

   WITH OBJECT myForm
      Title:='Form '+:cfname+" properties"
      aLabels     := { 'Title', 'icon', 'main', 'child', 'noshow', 'topmost', 'nominimize', 'nomaximize', 'nosize', 'nosysmenu', 'nocaption', 'modal', 'Notify icon', 'Notify tooltip', 'Noautorelease', 'Helpbutton', 'Focused', 'Break', 'Splitchild', 'Grippertext', 'Cursor', 'Virtual Height', 'Virtual Width', 'Obj' }
      aInitValues := { :cftitle, :cficon, :lfmain, :lfchild, :lfnoshow, :lftopmost, :lfnominimize, :lfnomaximize, :lfnosize, :lfnosysmenu, :lfnocaption, :lfmodal, :cfnotifyicon, :cfnotifytooltip, :lfnoautorelease, :lfhelpbutton, :lffocused, :lfbreak, :lfsplitchild, :lfgrippertext, :cfcursor, :nfvirtualh, :nfvirtualw, :cfobj }
      aFormats    := { 200, 31, .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., 120, 120, .F., .F., .F., .F., .F., .F., 31, '9999', '9999', 120  }
      aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
      IF aresults[1] == NIL
         RETURN NIL
      ENDIF
      myide:lvirtual:=.T.
      :cftitle:=aresults[1]
      Form_1.title := :cftitle
      :cficon:=aresults[2]
      IF aresults[3]
         :lfmain:=aresults[3]
      ELSE
         :lfmain:=.f.
      ENDIF
      IF aresults[4]
         :lfchild:=aresults[4]
      ELSE
         :lfchild:=.F.
      ENDIF
      IF aresults[5]
         :lfnoshow:=aresults[5]
      ELSE
         :lfnoshow:=.f.
      ENDIF
      IF aresults[6]
         :lftopmost:=aresults[6]
      ELSE
         :lftopmost:=.f.
      ENDIF
      IF aresults[7]
         :lfnominimize:=aresults[7]
      ELSE
         :lfnominimize:=.f.
      ENDIF
      IF aresults[8]
         :lfnomaximize:=aresults[8]
      ELSE
         :lfnomaximize:=.f.
      ENDIF
      IF aresults[9]
         :lfnosize:=aresults[9]
      ELSE
         :lfnosize:=.f.
      ENDIF
      IF aresults[10]
         :lfnosysmenu:=aresults[10]
      ELSE
         :lfnosysmenu:=.f.
      ENDIF
      IF aresults[11]
         :lfnocaption:=aresults[11]
      ELSE
         :lfnocaption:=.F.
      ENDIF
      IF aresults[12]
         :lfmodal:=aresults[12]
      ELSE
         :lfmodal:=.F.
      ENDIF
      :cfnotifyicon:=aresults[13]
      :cfnotifytooltip:=aresults[14]
      IF aresults[16]
         :lfnoautorelease:=aresults[15]
      ELSE
         :lfnoautorelease:=.F.
      ENDIF
      :lfhelpbutton:=aresults[16]
      :lffocused:=aresults[17]
      :lfbreak:=aresults[18]
      :lfsplitchild:=aresults[19]
      :lfgrippertext:=aresults[20]
      :cfcursor:=aresults[21]
      :nfvirtualh:=aresults[22]
      :nfvirtualw:=aresults[23]
      :cfobj:=aresults[24]
      :lFsave:=.F.
   END
RETURN NIL


*----------------------
FUNCTION FrmEvents( myIde )
*----------------------
LOCAL i, cname, j, Title, aLabels, aInitValues, aFormats, aResults

   WITH OBJECT myForm
      Title:='Form '+:cfname+" events"
      myide:lvirtual:=.T.
      aLabels     := { 'On Init', 'On Release', 'On MouseClick', 'On MouseMove', 'On MouseDrag', 'On GotFocus', 'On LostFocus', 'On ScrollUp', 'On ScrollDown', 'On ScrollLeft', 'On ScrollRight', 'On HScrollBox', 'On VScrollBox', 'On Size', 'On Paint', 'On NotifyClick', "On InteractiveClose", "On Maximize", "On Minimize" }
      aInitValues := { :cfoninit, :cfonrelease, :cfonmouseclick, :cfonmousemove, :cfonmousedrag, :cfongotfocus, :cfonlostfocus, :cfonscrollup, :cfonscrolldown, :cfonscrollleft, :cfonscrollright, :cfonhscrollbox, :cfonvscrollbox, :cfonsize, :cfonpaint, :cfonnotifyclick, :cfoninteractiveclose, :cfonmaximize, :cfonminimize }
      aFormats    := { 250,       250,          250,             250,            250,            250,           250,            250,           250,             250,             250,              250,             250,             250,       250,        250,              250,                   250,           250 }
      aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
      IF aresults[1] == NIL
         RETURN NIL
      ENDIF
      :cfoninit:=aresults[1]
      :cfonrelease:=aresults[2]
      :cfonmouseclick:=aresults[3]
      :cfonmousemove:=aresults[4]
      :cfonmousedrag:=aresults[5]
      :cfongotfocus:=aresults[6]
      :cfonlostfocus:=aresults[7]
      :cfonscrollup:=aresults[8]
      :cfonscrolldown:=aresults[9]
      :cfonscrollleft:=aresults[10]
      :cfonscrollright:=aresults[11]
      :cfonhscrollbox:=aresults[12]
      :cfonvscrollbox:=aresults[13]
      :cfonsize:=aresults[14]
      :cfonpaint:=aresults[15]
      :cfonnotifyclick:=aresults[16]
      :cfoninteractiveclose:=aresults[17]
      :cfonmaximize:=aresults[18]
      :cfonminimize:=aresults[19]
      :lFsave:=.F.
   END
RETURN NIL

*-------------------------
FUNCTION StatPropEvents( myIde )
*-------------------------
   WITH OBJECT myForm
      myIde:lvirtual:=.T.
      cname:='Statusbar'
      Title:=cname+" properties"
      aLabels     := { 'Caption',  'Width',  'Action',  'Icon',  'Flat',  'Raised',  'ToolTip',  'Date',  'Time',  'Keyboard',  'Obj' }
      aInitValues := { :cscaption, :nswidth, :csaction, :csicon, :lsflat, :lsraised, :cstooltip, :lsdate, :lstime, :lskeyboard, :cscobj }
      aFormats    := { 480,        '9999',   250,       30,      .F.,     .F.,       120,        .F.,     .F.,     .T.,         31 }
      aResults    := myInputWindow( Title, aLabels, aInitValues, aFormats )
      IF aresults[1] == NIL
         :control_click(1)
         RETURN NIL
      ENDIF
      Form_1.Statusbar.Release
      DEFINE STATUSBAR of Form_1
         IF Len( aresults[1] ) > 0
            STATUSITEM aresults[1]
         ENDIF
         IF aresults[10]
            KEYBOARD
         ENDIF
         IF aresults[8]
            DATE WIDTH 95
         ENDIF
         IF aresults[9]
            CLOCK WIDTH 85
         ENDIF
      END STATUSBAR
      :cscaption:=aresults[1]
      :nswidth:=aresults[2]
      :csaction:=aresults[3]
      :csicon:=aresults[4]
      :lsflat:=aresults[5]
      :lsraised:=aresults[6]
      :cstooltip:=aresults[7]
      :lsdate:=aresults[8]
      :lstime:=aresults[9]
      :lskeyboard:=aresults[10]
      :cscobj:=aresults[11]
      :lFsave:=.F.
      :Control_Click( 1 )
   END
RETURN NIL


*-----------------------
FUNCTION TabProp( i, myIde )
*-----------------------
LOCAL ki

   WITH OBJECT myForm
      ocontrol:=getformobject("Form_1"):acontrols[i]
      cname:=lower(ocontrol:name)
      ki:= ascan( :acontrolw, { |c| lower( c ) ==  cname  } )
      LOAD WINDOW tabprop
      tabprop.title:='Tab properties '+:aname[ki]
      tabprop.text_101.value:=:acaption[ki]
      tabprop.text_1.value:=:avalue[ki]
      tabprop.text_2.value:=:aname[ki]
      tabprop.edit_2.value:=:aimage[ki]
      tabprop.edit_3.value:=:atooltip[ki]
      tabprop.check_2.value:=:abuttons[ki]
      tabprop.check_1.value:=:aflat[ki]
      tabprop.check_3.value:=:ahottrack[ki]
      tabprop.check_4.value:=:avertical[ki]
      tabprop.check_5.value:=:aenabled[ki]
      tabprop.check_6.value:=:avisible[ki]
      tabprop.text_3.value:=:acobj[ki]
      CENTER WINDOW tabProp
      ACTIVATE WINDOW TabProp
   END
RETURN NIL


*--------------------
FUNCTION Tabevent( i )
*--------------------
LOCAL ki

   WITH OBJECT myForm
      ocontrol:=getformobject("Form_1"):acontrols[i]
      cname:=ocontrol:name
      ki := ascan( :acontrolw, { |c| lower( c ) ==  cname  } )
      LOAD WINDOW tabeven AS Tabprop
      tabprop.text_101.value:=:aonchange[ki]
      tabprop.title:="Tab events "+:aname[ki]
      CENTER WINDOW tabProp
      ACTIVATE WINDOW TabProp
   END
RETURN NIL


*-------------------------
FUNCTION CambiaCap( cName )
*-------------------------
LOCAL i
   cacaptions:=  tabprop.text_101.value
   acaptions := &cacaptions
   IF HB_IsArray(acaptions)
      otab:=getcontrolobject(cname, "Form_1")
      FOR i:= 1 TO len(acaptions)
          otab:caption(i, acaptions[i])
      NEXT i
   ENDIF
RETURN NIL


*-----------------------------
FUNCTION AddTabPageAux( i )
*-----------------------------
LOCAL j, cname

   WITH OBJECT myForm
      ocontrol:=getformobject("Form_1"):acontrols[i]
      cname:=lower(ocontrol:name)
      j:= ascan( :acontrolw, { |c| lower( c ) ==  cname  } )
      caux:=:acaption[j]
      caux1:=&caux
      auxpages:=len(caux1)
      :acaption[j]:=substr(:acaption[j], 1, len(:acaption[j])-1)+", 'Page "+alltrim(str(auxpages+1))+"'}"
      :aimage[j]:=substr(:aimage[j], 1, len(:aimage[j])-1)+", ' '  }"
      tabprop.text_101.value:=:acaption[j]
      tabprop.Edit_2.value:=:aimage[j]
      cname:=:acontrolw[j]
      ocontrol:addpage(auxpages+1, 'Page '+alltrim(str(auxpages+1)), '')
   END
RETURN NIL


*------------------------------
FUNCTION DeleteTabPageAux( i )
*------------------------------
LOCAL p, j, cname, p1, k

   WITH OBJECT myForm
      ocontrol:=getformobject("Form_1"):acontrols[i]
      cname:=lower(ocontrol:name)
      j:= ascan( :acontrolw, { |c| lower( c ) ==  cname  } )
      caux:=:acaption[j]
      caux1:=&(caux)
      auxpages:=len(caux1)
      IF auxpages<=1
         RETURN NIL
      ENDIF
      p:=rat(", ", :acaption[j])
      p1:=rat(", ", :aimage[j])
      cname:=:acontrolw[j]
      :acaption[j]:=substr(:acaption[j], 1, p-1)+"}"
      :aimage[j]  :=substr(:aimage[j], 1, p1-1)+"}"
      tabprop.text_101.value:=:acaption[j]
      tabprop.Edit_2.value:=:aimage[j]
      ocontrol:deletepage(auxpages)
      FOR ia:=1 TO :ncontrolw
         IF :atabpage[ia, 1]=cname .and. :atabpage[ia, 2]=auxpages
            :atabpage[ia, 1]:=''
            :atabpage[ia, 2]:=0
            :IniArray( :nform, ia, '', '' )
          ENDIF
      NEXT ia
      ocontrol:visible:=.F.
      ocontrol:visible:=.T.
   END
RETURN NIL
*------------------------------------------------------------------------------*
