/*
 * $Id: propeven.prg,v 1.2 2014-04-15 00:46:19 fyurisich Exp $
 */

#include 'oohg.ch'
#define SS_LEFT             0
#define SS_CENTER           1
#define SS_RIGHT            2

*----------------------------
Procedure Properties_Click
*----------------------------
local i,cname,j, Title , aLabels , aInitValues , aFormats , aResults,ctipo,jh,nn,temp
declare window form_1

with object myform

	h := GetFormHandle ( :designform )
	BaseRow 	:= GetWindowRow ( h ) + GetBorderHeight()
	BaseCol 	:= GetWindowCol ( h ) + GetBorderWidth()
	BaseWidth 	:= GetWindowWidth ( h )
	BaseHeight 	:= GetWindowHeight ( h )
	TitleHeight 	:= GetTitleHeight()
	BorderWidth 	:= GetBorderWidth()
	BorderHeight 	:= GetBorderHeight()

                i:=nhandlep
                if i>0
                   ocontrol:=getformobject('form_1'):acontrols[i]
                   if ocontrol:type == 'FRAME'
                      cName:=lower(ocontrol:name)
                      J:=ascan( :acontrolw, { |c| lower( c ) == cname  } )
                      cname:=:acontrolw[j]
                      cnamew:=:aname[j]
                      Title:=cnamew+" properties"
                      aLabels         := { 'Caption'        ,'Opaque', 'Transparent','Name','Enabled','Visible' }
                      aInitValues     := { :acaption[j],    :aopaque[j], :atransparent[j],:aname[j],:aenabled[j],:avisible[j]  }
                      aFormats        := { 30       ,.F., .F. ,30,.F. , .F. }
                      aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                      if aresults[1] == Nil
                         **   msginfo('Properties abandoned','Information')
                         return
                      endif
                      if len(aresults[1] )>0
                         ocontrol:caption:= aresults[1]
                      endif
                      :acaption[j]:=aresults[1]
                      :aopaque[j]:=aresults[2]
                      :atransparent[j]:=aresults[3]
                      if .not. empty(aresults[4] )
                          :aname[j]:=aresults[4]
                       endif
                      :aenabled[j]:=aresults[5]
                      :avisible[j]:=aresults[6]
                      return
                   else
                      if ocontrol:type == 'TAB'
                         cname:=lower(ocontrol:name)
                         sa:=ascan( :acontrolw, { |c| lower( c ) == cname  } )
	                 TabProp(i)   &&&& propiedades de TAB personalizadas
                         cacaptions:=:acaption[sa]
                         carreglo:= &cacaptions
                         cnametab:=:acontrolw[sa]
                         for kp:=1 to len(carreglo)
                             ocontrolaux:=getcontrolobject(cnametab,"form_1")
                             ocontrol:value:=kp
                             ocontrol:caption:=carreglo[kp]
                         next kp
                         ocontrol:visible:=.F.
                         ocontrol:visible:=.T.
                      else
                         cName:=lower(ocontrol:name )
                         For j:=1 to :ncontrolw
                   if lower(:acontrolw[j]) == cname
                      cnamew:=:aname[j]
                      if :actrltype[j]=="TEXT"
                         Title:=cnamew+" properties"
                         // pb - se agrega propiedad focusedpos
                         aLabels         := { 'Tooltip'        ,'Maxlength'        , 'Uppercase'            , 'Rightalign'         ,'Value'         ,'Password'         ,'Lowercase'         ,'Numeric'         , 'Inputmask'         ,'Helpid'         ,'Field'         ,'Readonly'          , 'Enabled'         ,'Visible'          ,'Notabstop'         ,'Date'         ,'Name'         ,'Format', 'FocusedPos','Valid','When'}
                         aInitValues     := { :atooltip[j],:amaxlength[j] , :auppercase[j], :arightalign[j],:avalue[j],:apassword[j],:alowercase[j],:anumeric[j], :ainputmask[j],:ahelpid[j],:afield[j], :areadonly[j], :aenabled[j], :avisible[j],:anotabstop[j],:adate[j],:aname[j],:afields[j], :afocusedpos[j],:avalid[j], :awhen[j] }
                         aFormats        := { 120               , '999'               , NIL                 , nil                  ,40              ,.F.                ,.F.                 ,.F.               ,30                   ,'999'            ,            250  , .F.                , .F.               ,.F.                ,.F.                 ,   .F.         ,30             ,30, '99',250,250 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
                      **      msginfo('Properties abandoned','Information')
                            return
                         endif
                         if aresults[7] .and. aresults[3]
                            msginfo("Uppercase and Lowercase at the same time It's not logic","Information")
                            aresults[7]:=.F.
                            aresults[3]:=.F.
                         endif

                         :atooltip[j]:=aresults[1]

                         ocontrol:tooltip:=aresults[1]

                         if aresults[2] >0
                            :amaxlength[j]:=aresults[2]
                         else
                            :amaxlength[j]:=0
                         endif

                        :auppercase[j]:=aresults[3]


                        :arightalign[j]:= aresults[4]
                        :avalue[j]:=aresults[5]


                        :apassword[j]:= aresults[6]


                        :alowercase[j]:=aresults[7]

                         :anumeric[j]:=aresults[8]
                         :ainputmask[j]:=aresults[9]
                         if len(aresults[9])>0 .or. aresults[16]
                            :amaxlength[j]:=0
                         endif
                         :ahelpid[j]:=aresults[10]
                         :afield[j]:=aresults[11]

                         :areadonly[j]:=aresults[12]

                         :aenabled[j]:=aresults[13]
                         :avisible[j]:=aresults[14]
                         :anotabstop[j]:=aresults[15]
                         :adate[j]:=aresults[16]
                         if .not. empty(aresults[17] )
                            :aname[j]:=aresults[17]
                         endif
                         :afields[j]:=aresults[18]
                         :afocusedpos[j]:=aresults[19]  // pb
                         :avalid[j]:=aresults[20]
                         :awhen[j]:=aresults[21]


                      endif
                      
                      if :actrltype[j]=="IPADDRESS"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Tooltip'        ,'Value'        ,'Helpid'        , 'Enabled','Visible','Notabstop','Name'}
                         aInitValues     := { :atooltip[j]      ,:avalue[j]      ,:ahelpid[j]      , :aenabled[j], :avisible[j],:anotabstop[j],:aname[j]    }
                         aFormats        := { 120               , 30             ,'999'          , .T.        ,  .T.       ,.F.     , 30 ,.F.,.F.   }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
                      **      msginfo('Properties abandoned','Information')
                            return
                         endif


                         :atooltip[j]:=aresults[1]

                         ocontrol:tooltip:=aresults[1]

                         if len(aresults[2])>0
                            ocontrol:value:= aresults[2]
                            :avalue[j]:=aresults[2]
                         else
                            :avalue[j]:=aresults[2]
                            ocontrol:value:="   .   .   .   "
                         endif
                         :ahelpid[j]:=aresults[3]
                         :aenabled[j]:=aresults[4]
                         :avisible[j]:=aresults[5]
                         :anotabstop[j]:=aresults[6]
                         if .not. empty(aresults[7] )
                            :aname[j]:=aresults[7]
                         endif
                      endif
                      if :actrltype[j]=="HYPERLINK"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Tooltip'        ,'Value'        ,'Helpid'        , 'Enabled','Visible','Address','Handcursor','Name'}
                         aInitValues     := { :atooltip[j]      ,:avalue[j]      ,:ahelpid[j]      , :aenabled[j], :avisible[j], :aaddress[j], :ahandcursor[j],:aname[j] }
                         aFormats        := { 120               , 30             ,'999'          , .T.        ,  .T.       , 60, .F. ,30,.F.,.F.       }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
                      **      msginfo('Properties abandoned','Information')
                            return
                         endif


                         :atooltip[j]:=aresults[1]

                            ocontrol:tooltip:=aresults[1]

                         if len(aresults[2])>0
                            ocontrol:value:= aresults[2]
                            :avalue[j]:=aresults[2]
                         endif
                         :ahelpid[j]:=aresults[3]
                         :aenabled[j]:=aresults[4]
                         :avisible[j]:=aresults[5]
                         :aaddress[j]:=aresults[6]
                         :ahandcursor[j]:=aresults[7]
                         if .not. empty(aresults[8] )
                            :aname[j]:=aresults[8]
                         endif
                      endif
                      if :actrltype[j]=="TREE"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Tooltip'   , 'Enabled','Visible','Name','Nodeimages','Itemimages','Norootbutton','Itemids','Helpid' }
                         aInitValues     := { :atooltip[j] , :aenabled[j], :avisible[j], :aname[j], :Anodeimages[j], :aitemimages[j], :anorootbutton[j], :aitemids[j],:ahelpid[j] }
                         aFormats        := { 120                 , .T.        ,  .T.   ,60 , 60,60,.F.,.F. ,'999'  }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
                      **      msginfo('Properties abandoned','Information')
                            return
                         endif


                         :atooltip[j]:=aresults[1]

                            ocontrol:tooltip:=aresults[1]

                         :aenabled[j]:=aresults[2]
                         :avisible[j]:=aresults[3]
                         if .not. empty(aresults[4] )
                            :aname[j]:=aresults[4]
                         endif
                         :anodeimages[j]:=aresults[5]
                         :aitemimages[j]:=aresults[6]
                         :anorootbutton[j]:=aresults[7]
                         :aitemids[j]:=aresults[8]
                         :ahelpid[j]:=aresults[9]
                      endif
                      if :actrltype[j]=="EDIT"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Tooltip'        ,'Maxlength'        , 'Readonly'        , 'Value'        , 'Helpid'  , 'Break','Field','Name','Enabled','Visible','Notabstop','Novscroll','Nohscroll'  }
                         aInitValues     := { :atooltip[j]      ,:amaxlength[j]      , :areadonly[j]      , :avalue[j]      ,:ahelpid[j] ,:abreak[j],:afield[j],:aname[j],:aenabled[j], ;
                                          :avisible[j], :anotabstop[j],:anovscroll[j],:anohscroll[j]  }
                         aFormats        := { 120               , '999999'             , .F.                ,  800           ,'999'      ,  .F., 250, 30, .F. , .F. ,.F.,.F.,.F. }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
                        ***    msginfo('Properties abandoned','Information')
                            return
                         endif

                         :atooltip[j]:=aresults[1]

                         ocontrol:tooltip:=aresults[1]
                    
                         if aresults[2] >0
                            :amaxlength[j]:=aresults[2]
                         else
                            :amaxlength[j]:=0
                         endif
                         :areadonly[j]:=aresults[3]

                        
                            ocontrol:value:= aresults[4]
                            :avalue[j]:=aresults[4]

                         :ahelpid[j]:=aresults[5]
                         :abreak[j]:=aresults[6]
                         :afield[j]:=aresults[7]
                         if .not. empty(aresults[8] )
                            :aname[j]:=aresults[8]
                         endif
                         :aenabled[j]:=aresults[9]
                         :avisible[j]:=aresults[10]
                         :anotabstop[j]:=aresults[11]
                         :anovscroll[j]:=aresults[12]
                         :anohscroll[j]:=aresults[13]
                      endif
                      if :actrltype[j]=="RICHEDIT"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Tooltip'        ,'Maxlength'        , 'Readonly'        , 'Value'        , 'Helpid'  , 'Break','Field','Name','Enabled','Visible','Notabstop' }
                         aInitValues     := { :atooltip[j]      ,:amaxlength[j]      , :areadonly[j]      , :avalue[j]   ;
                                         ,:ahelpid[j],:abreak[j],:afield[j],:aname[j],:aenabled[j],:avisible[j], :anotabstop[j] }
                         aFormats        := { 120               , '999999'             , .F.                ,  800           ,'999'      ,  .F., 250 ,30, .F., .F. ,.F. }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
                        ***    msginfo('Properties abandoned','Information')
                            return
                         endif

                         :atooltip[j]:=aresults[1]

                               ocontrol:tooltip:=aresults[1]
                     
                         if aresults[2] >0
                            :amaxlength[j]:=aresults[2]
                         else
                            :amaxlength[j]:=0
                         endif
                         :areadonly[j]:=aresults[3]

                         if len(aresults[4])>0
                            ocontrol:value:= aresults[4]
                            :avalue[j]:=aresults[4]
                         else
                            :avalue[j]:=aresults[4]
                            ocontrol:value:= ""
                         endif
                         :ahelpid[j]:=aresults[5]
                         :abreak[j]:=aresults[6]
                         :afield[j]:=aresults[7]
                         if .not. empty(aresults[8] )
                            :aname[j]:=aresults[8]
                         endif
                         :aenabled[j]:=aresults[9]
                         :avisible[j]:=aresults[10]
                         :anotabstop[j]:=aresults[11]
                      endif
                      if :actrltype[j]=="GRID"
                         Title:=cnamew+" properties"
                         myide:lvirtual:=.T.
                         aLabels         := { 'Headers'   ,'Widths'   ,'Items'     ,'Value'    ,'Tooltip'        ,'Multiselect'        , 'Nolines'        , 'Image'        , 'Helpid'  , 'Break', 'Justify','Name','Enabled','Visible',"Dynamicbackcolor","Dynamicforecolor","Columncontrols" ;
                            , "Valid","Valid Messages","When","Readonly","Inplace","Inputmask","Edit" }

                         aInitValues     := { :aheaders[j] ,:awidths[j],:aitems[j]   ,:avalue[j]  ,:atooltip[j]      ,:amultiselect[j]      , :anolines[j]      , :aimage[j]      ,:ahelpid[j] ,:abreak[j],:ajustify[j],:aname[j],:aenabled[j],:avisible[j],:adynamicbackcolor[j],:adynamicforecolor[j],:acolumncontrols[j];
                                           , :avalid[j],:avalidmess[j],:awhen[j],:areadonlyb[j],:ainplace[j],:ainputmask[j],:aedit[j] }
                         aFormats        := { 800          ,800         ,800          ,60         ,250               , .F.                 , .F.              ,  60            ,'999'      ,  .F.,   350,   30,      .F. ,      .F. ,    350,    350 ,    800 ;
                                             , 800,800,800, 800, .T.,800, .T. }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
                           *** msginfo('Properties abandoned','Information')
                            return
                         endif

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
                         if len(aresults[11])>0
                             :ajustify[j]:=aresults[11]
                         endif
                         if .not. empty(aresults[12] )
                            :aname[j]:=aresults[12]
                         endif
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
                      endif                  
                      if :actrltype[j]=="LABEL"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Value'         ,  'Bold'       ,'Helpid'         , 'Transparent','centeralign','rightalign', 'Tooltip','Name','Autosize',"Enabled","Visible","Clientedge" }
                         aInitValues     := { :avalue[j],:abold[j],:ahelpid[j], :atransparent[j],:acenteralign[j],:arightalign[j],:atooltip[j],:aname[j],:aautoplay[j],:aenabled[j],:avisible[j], :aclientedge[j] }
                         aFormats        := { 300             ,.F.            ,'999'            ,   .F.           , .F.           ,.F. , 120 ,30, .F., .F.,.F., .F. }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
****                            msginfo('Properties abandoned','Information')
                            return
                         endif

                         if len(aresults[1])>0
                            :avalue[j]:=aresults[1]
                              ocontrol:value:=aresults[1]
                         else
                            :avalue[j]:=aresults[1]
                              ocontrol:value:="Empty label"
                         endif
                         :abold[j]:=aresults[2]
                         ocontrol:fontbold:=aresults[2]

                         :ahelpid[j]:=aresults[3]

                          :atransparent[j]:=aresults[4]
                          :acenteralign[j]:=aresults[5]
                          if aresults[5]
                             ocontrol:align:=SS_CENTER
                          endif
                          :arightalign[j]:=aresults[6]
                          if aresults[6]
                             ocontrol:align:=SS_RIGHT
                          endif
                          if .not. aresults[5] .and. .not. aresults[6]
                              ocontrol:align:=SS_LEFT
                          endif
                                
                          :atooltip[j]:=ltrim(aresults[7])
                          if len(aresults[8])>0
                               :aname[j]:=strtran(aresults[8]," ","")
                          endif
                          :aautoplay[j]:=aresults[09]
                          :aenabled[j]:=aresults[10]
                          :avisible[j]:=aresults[11]
                          :aclientedge[j]:=aresults[12]
                      endif

                      if :actrltype[j]=="PROGRESSBAR"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Range'        ,'Tooltip'        ,'Vertical'        ,'Smooth'  , 'Helpid','Name','Enabled','Visible'   }
                         aInitValues     := { :arange[j]      ,:atooltip[j]      ,:avertical[j]      ,:asmooth[j],:ahelpid[j],:aname[j],:aenabled[j],:avisible[j] }
                         aFormats        := { 20                , 120           ,.F.               , .F.      ,'999' ,30 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
    ****                        msginfo('Properties abandoned','Information')
                            return
                         endif

                         :arange[j]:=aresults[1]
                         :atooltip[j]:=aresults[2]

                            ocontrol:tooltip:=aresults[2]

                         :avertical[j]:=aresults[3]
                         :asmooth[j]:=aresults[4]
                         :ahelpid[j]:=aresults[5]
                         if .not. empty(aresults[6] )
                            :aname[j]:=aresults[6]
                         endif
                         ocontrol:value:=:aname[j]
                         :aenabled[j]:=aresults[7]
                         :avisible[j]:=aresults[8]
                      endif
                      if :actrltype[j]=="SLIDER"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Range'        ,   'Value ', 'Tooltip'        ,'Vertical'        ,'Both'  ,  'Top'  , 'Left',    'Helpid','Name','Enabled','Visible'  }
                         aInitValues     := { :arange[j]      ,  :avaluen[j],  :atooltip[j]      ,:avertical[j]      ,:aboth[j],  :atop[j], :aleft[j],  :ahelpid[j],:aname[j],:aenabled[j],:avisible[j] }
                         aFormats        := { 20             ,   '999'   ,    120           ,.F.               , .F.  ,    .F.     , .F.,    '999' , 30, .F.,.F.  }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
        ****                    msginfo('Properties abandoned','Information')
                            return
                         endif
                         :arange[j]:=aresults[1]
                         :avaluen[j]:=aresults[2]
                         :atooltip[j]:=aresults[3]

                         ocontrol:tooltip:=aresults[3]

                         :avertical[j]:=aresults[4]

                         nn := WindowStyleFlag( ocontrol:hWnd, 2 )

                         if (nn=0 .and. aresults[4]) .or. (nn=2 .and. !aresults[4])
                             WindowStyleFlag( ocontrol:hWnd, 2, 2 - nn )
                             temp:=ocontrol:width
                             ocontrol:width:=ocontrol:height
                             ocontrol:height:=temp
                         endif


                         :aboth[j]:=aresults[5]
                         :atop[j]:=aresults[6]
                         :aleft[j]:=aresults[7]
                         :ahelpid[j]:=aresults[8]
                         if .not. empty(aresults[9] )
                            :aname[j]:=aresults[9]
                         endif
                         :aenabled[j]:=aresults[10]
                         :avisible[j]:=aresults[11]
                         dibuja(cnamew)
                      endif
                      if :actrltype[j]=="SPINNER"
                         Title:=cnamew+" properties"
                         aLabels         := { 'Range'        ,   'Value '  , 'Tooltip'         ,    'Helpid', 'Notabstop'   ,'Wrap'  ,'Readonly'  ,'Increment','Name','Enabled','Visible' }
                         aInitValues     := { :arange[j]      ,  :avaluen[j] ,  :atooltip[j]      ,  :ahelpid[j],  :anotabstop[j],:awrap[j],:areadonly[j],:aincrement[j],:aname[j],:aenabled[j],:avisible[j] }
                         aFormats        := {    30          ,   '99999'   ,    120             ,  '999'     , .F.           ,.F.     ,.F.         , '999999',30, .F. , .F.  }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
            ****                msginfo('Properties abandoned','Information')
                            return
                         endif

                         :arange[j]:=aresults[1]
                         :avaluen[j]:=aresults[2]
                         :atooltip[j]:=aresults[3]

                         ocontrol:tooltip:=aresults[3]

                         :ahelpid[j]:=aresults[4]
                         :anotabstop[j]:=aresults[5]
                         :awrap[j]:=aresults[6]
                         :areadonly[j]:=aresults[7]
                         :aincrement[j]:=aresults[8]
                         if .not. empty(aresults[9] )
                            :aname[j]:=aresults[9]
                         endif
                         :aenabled[j]:=aresults[10]
                         :avisible[j]:=aresults[11]
                      endif
                      if :actrltype[j]=="BUTTON"
                            Title:=cnamew+" properties"
                            aLabels         := { 'Caption'        ,'Tooltip','Helpid','Notabstop'  ,'Enabled'  ,'Visible','Name','Flat','Picture',"Alignment" }
                            aInitValues     := { :acaption[j],:atooltip[j]      ,:ahelpid[j]        ,:anotabstop[j], :aenabled[j], :avisible[j],:aname[j], :aflat[j],:aPicture[j],:Ajustify[j] }
                            aFormats        := { 300               ,120       ,'999'  , .F.         , .T.       , .T.     ,30, .T.,40,20}
                            aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                            if aresults[1] == Nil
                ***               msginfo('Properties abandoned','Information')
                              return
                            endif

                            if len(aresults[1])>0
                               :acaption[j]:=aresults[1]
                               ocontrol:caption:=aresults[1]
                            else
                               :acaption[j]:=aresults[1]
                               ocontrol:caption:=cname
                            endif
                             :atooltip[j]:=aresults[2]

                               ocontrol:tooltip:=aresults[2]
                        
                            :ahelpid[j]:=aresults[3]
                            :anotabstop[j]:=aresults[4]
                            :aenabled[j]:=aresults[5]
                            :avisible[j]:=aresults[6]
                            if .not. empty(aresults[7] )
                               :aname[j]:=aresults[7]
                            endif
                            :aflat[j]:=aresults[8]
                            :apicture[j]:=aresults[9]
                            :ajustify[j]:=aresults[10]
                      endif
                      if :actrltype[j]=="CHECKBOX"
                              Title:=cnamew+" properties"
                              aLabels         := { 'Value'        ,  'Caption'   ,'tooltip','Helpid','Field','Transparent'          ,'Enabled','Visible','Name',"notabstop" }
                              aInitValues     := { :avaluel[j]      ,:acaption[j]   ,:atooltip[j],:ahelpid[j],:afield[j], :atransparent[j],:aenabled[j],:avisible[j],:aname[j] , :anotabstop[j] }
                              aFormats        := { .F.            ,31            ,120  ,  '999',250 , .F.  , .F. , .F., 30,.F. ,.F., .F. }
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )

                              if aresults[1] == Nil
                   ****              msginfo('Properties abandoned','Information')
                                return
                              endif


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
                              if .not. empty(aresults[9] )
                                 :aname[j]:=aresults[9]
                              endif
                              :anotabstop[j]:=aresults[10]
                      endif
                      if :actrltype[j]=="LIST"
                              Title:=cnamew+" properties"
                              aLabels         := { 'Value'        ,  'Items'   ,'tooltip'   ,'Multiselect'  ,'Help id' ,'Break'  ,'Notabstop'   , 'Sort','Name','Enabled','Visible' }
                              aInitValues     := { :avaluen[j]     ,:aitems[j]   ,:atooltip[j] ,:amultiselect[j],:ahelpid[j],:abreak[j],:anotabstop[j],:asort[j],:aname[j],:aenabled[j],:avisible[j] }
                              aFormats        := { '999'             ,800          ,120         ,.F.            ,'999'     ,   .F.        ,.F.          ,.F.  , 30,.F.,.F. }
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                              if aresults[1] == Nil
                       ****          msginfo('Properties abandoned','Information')
                                return
                              endif

                              :avaluen[j]:=aresults[1]
                              ocontrol:value:=aresults[1]
                              if len(aresults[2])>0
                                 :aitems[j]:=aresults[2]
                              else
                                 :aitems[j]:=""
                              endif
                              if len(aresults[3])>0
                                 :atooltip[j]:=aresults[3]
                              else
                                 :atooltip[j]:=""
                              endif
                              ocontrol:tooltip:=aresults[3]
                              :amultiselect[j]:=aresults[4]
                              :ahelpid[j]:=aresults[5]
                              :abreak[j]:=aresults[6]
                              :anotabstop[j]:=aresults[7]
                              :asort[j]:=aresults[8]
                              if .not. empty(aresults[9] )
                                 :aname[j]:=aresults[9]
                              endif
                              :aenabled[j]:=aresults[10]
                              :avisible[j]:=aresults[11]
                      endif
                      if :actrltype[j]=="BROWSE"
                              myide:lvirtual:=.T.
                              Title:=cnamew+" properties"
                              aLabels         := { 'Headers'        ,  'Widths'   ,'Workarea'   ,'Fields' , 'value ' , 'Tooltip' ,'Valid'  ,'Validmesages','Readonly'  ,'Lock'   ,'Delete'   ,'Nolines'  ,'Image'  ,'Justify'  ,'Help id','Name','Enabled','Visible',"When","Dynamicbackcolor","dynamicforecolor","columncontrols","inputmask","Inplace","Edit","Append"}
                              aInitValues     := { :aheaders[j]      ,:awidths[j]    ,:aworkarea[j] ;
,:afields[j],:avaluen[j],:atooltip[j],:avalid[j],:avalidmess[j],:areadonlyb[j],:alock[j],:adelete[j]  ,:anolines[j],:aimage[j],:ajustify[j],:ahelpid[j] ,:aname[j],:aenabled[j],:avisible[j],:awhen[j] ;
,:adynamicbackcolor[j],:adynamicforecolor[j], :acolumncontrols[j], :ainputmask[j], :ainplace[j],:aedit[j],:aappend[j] }
                              aFormats        := { 800              ,800          ,80         ,800         ,'999999' ,   250     , 800    ,800          , 800        ,  .T.    ,  .F.      , .F.       , 800    , 800      ,  '99999' ,30, .F. , .F. , 800,800,800,800,800,.F.,.F.,.F. }
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                              if aresults[1] == Nil
                       ****          msginfo('Properties abandoned','Information')
                                return
                              endif

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
                              if .not. empty(aresults[16] )
                                :aname[j]:=aresults[16]
                              endif
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
                      endif
                      if :actrltype[j]=="RADIOGROUP"
                              Title:=cnamew+" properties"
                              aLabels         := { 'Value'        ,  'Options'   ,'Tooltip'   ,'Spacing'  ,'Help id','Transparent','Name','Enabled','Visible'  }
                              aInitValues     := { :avaluen[j]     ,:aitems[j]   ,:atooltip[j] ,:aspacing[j],:ahelpid[j],:atransparent[j],:aname[j],:aenabled[j],:avisible[j] }
                              aFormats        := { '999'             ,250          ,120         ,'999'            ,'999', .F.,30,.F.,.F.  }
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                              if aresults[1] == Nil
                           ***      msginfo('Properties abandoned','Information')
                                return
                              endif
                              ***********
                              nllaves1:=0
                              nllaves2:=0
                              citems:=ltrim(rtrim(aresults[2]))
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
                                 msginfo('minimun 2 options','Information')
                                 return
                              endif
                              **********
                              :avaluen[j]:=aresults[1]
                              :aitems[j]:=aresults[2]
                              if len(aresults[3])>0
                                 :atooltip[j]:=aresults[3]
                              endif
                              :aspacing[j]:=aresults[4]
                              :ahelpid[j]:=aresults[5]
                              :atransparent[j]:=aresults[6]
                              if .not. empty(aresults[7] )
                                 :aname[j]:=aresults[7]
                              endif
                              :aenabled[j]:=aresults[8]
                              :avisible[j]:=aresults[9]
                              ******

                              ocontrol:height:= aresults[4]*len(&citems)+8
                              ******
                      endif
                      if :actrltype[j]=="COMBO"
                              Title:=cnamew+" properties"
                              aLabels         := { 'Value'        ,  'Items'   ,'tooltip'   ,'Help id', 'Notabstop'  ,'Sort'  ,'Itemsource','Enabled'    ,'Visible','Valuesource','Name','Break',"Displayedit" }
                              aInitValues     := { :avaluen[j]     ,:aitems[j]   ,:atooltip[j] ,:ahelpid[j],:anotabstop[j],:asort[j],:aitemsource[j],:aenabled[j],:avisible[j], ;
:avaluesource[j],:aname[j],:abreak[j],:adisplayedit[j] }
                              aFormats        := { '999'             ,250       ,120         ,'999'     ,.F.          ,.F.     ,  100          ,.T.  ,.T.           ,100,30,.F. , .F. }
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                              if aresults[1] == Nil
                ***                 msginfo('Properties abandoned','Information')
                                return
                              endif

                              :avaluen[j]:=aresults[1]
                              if len(aresults[2])>0
                                 :aitems[j]:=aresults[2]
                              else
                                 :aitems[j]:=""
                              endif

                              :atooltip[j]:=aresults[3]

                                 ocontrol:tooltip:=aresults[3]
                          
                              :ahelpid[j]:=aresults[4]
                              :anotabstop[j]:=aresults[5]
                              :asort[j]:=  aresults[6]
                              :aitemsource[j]:=aresults[7]
                              if len(aresults[7])>0
                                 :aitems[j]:=''
                              endif
                              :aenabled[j]:=aresults[8]
                              :avisible[j]:=aresults[9]
                              :avaluesource[j]:=aresults[10]
                              if .not. empty(aresults[11] )
                              :aname[j]:=aresults[11]
                              endif
                              :abreak[j]:=aresults[12]
                              :adisplayedit[j]:=aresults[13]
                      endif
                      if :actrltype[j]=="CHECKBTN"
                              Title:=cnamew+" properties"
                              aLabels         := { 'Value'        ,  'Caption'   ,'tooltip'  ,'Help id','Name','Enabled','Visible',"notabstop" }
                              aInitValues     := { :avaluel[j]      ,:acaption[j]   ,:atooltip[j],:ahelpid[j],:aname[j],:aenabled[j],:avisible[j],:anotabstop[j]  }
                              aFormats        := { .F.            ,31            ,120  , '999', 30, .F. , .F. ,.F.}
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )

                              if aresults[1] == Nil
                   ***              msginfo('Properties abandoned','Information')
                                return
                              endif
                              :avaluel[j]:=aresults[1]
                              ocontrol:value:=aresults[1]

                              if len(aresults[2])>0
                                 :acaption[j]:=aresults[2]
                                  ocontrol:caption:=aresults[2]
                              else
                                 :acaption[j]:=""
                                ocontrol:caption:=cname
                              endif
                              :atooltip[j]:=aresults[3]

                                 ocontrol:tooltip:=aresults[3]
                           
                              :ahelpid[j]:=aresults[4]
                              if .not. empty(aresults[5] )
                                :aname[j]:=aresults[5]
                              endif
                              :aenabled[j]:=aresults[6]
                              :avisible[j]:=aresults[7]
                              :anotabstop[j]:=aresults[8]
                      endif
                      if :actrltype[j]=="PICCHECKBUTT"
                              Title:=cnamew+" properties"
                              aLabels         := { 'Value'        ,  'Picture'   ,'tooltip' ,'Help id','Name','Enabled','Visible',"notabstop" }
                              aInitValues     := { :avaluel[j]      ,:apicture[j]   ,:atooltip[j],  :ahelpid[j],:aname[j],:aenabled[j], :avisible[j],:anotabstop[j] }
                              aFormats        := { .F.            ,31            ,120    ,'999', 30, .F. , .F., .F.  }
                              aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )

                              if aresults[1] == Nil
            *****                     msginfo('Properties abandoned','Information')
                                return
                              endif
                              :avaluel[j]:=aresults[1]

                              ocontrol:value:=:avaluel[j]

                              if len(aresults[2])>0
                                 :apicture[j]:=aresults[2]
                              else
                                 :apicture[j]:=""
                              endif
                              :atooltip[j]:=aresults[3]

                                  ocontrol:tooltip:=aresults[3]
                          

                              :ahelpid[j]:=aresults[4]
                              if .not. empty(aresults[5] )
                                :aname[j]:=aresults[5]
                              endif
                              :aenabled[j]:=aresults[6]
                              :avisible[j]:=aresults[7]
                              :anotabstop[j]:=aresults[8]
                      endif
                      if :actrltype[j]=="PICBUTT"
                            Title:=cnamew+" properties"
                            aLabels         := { 'Picture'        ,'Tooltip','Helpid'    ,'Notabstop','Name','Enabled','Visible','Flat'}
                            aInitValues     := { :apicture[j],:atooltip[j]      ,:ahelpid[j],:anotabstop[j],:aname[j],:aenabled[j],:avisible[j],:aflat[j] }
                            aFormats        := { 30               ,120       ,'999',         .F.   ,30, .T. , .T.,.F.  }
                            aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                            if aresults[1] == Nil
         ****                      msginfo('Properties abandoned','Information')
                              return
                            endif


                            if len(aresults[1])>0
                               :apicture[j]:=aresults[1]
                            else
                               :apicture[j]:=aresults[1]
                            endif
                             :atooltip[j]:=aresults[2]

                                ocontrol:tooltip:=aresults[2]

                               :ahelpid[j]:=aresults[3]
                               :anotabstop[j]:=aresults[4]
                               if .not. empty(aresults[5] )
                                 :aname[j]:=aresults[5]
                               endif
                               :aenabled[j]:=aresults[6]
                               :avisible[j]:=aresults[7]
                               :aflat[j]:=aresults[8]
                      endif
                      if :actrltype[j]=="IMAGE"
                            Title:=cnamew+" properties"
                            aLabels         := { 'Picture'        ,'Helpid','Stretch','Name','Enabled','Visible' }
                            aInitValues     := { :apicture[j],    :ahelpid[j],:astretch[j],:aname[j], :aenabled[j] ,:avisible[j]  }
                            aFormats        := { 30       ,'999',.F. ,30 , .F. ,.F.}
                            aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                            if aresults[1] == Nil
           ****                    msginfo('Properties abandoned','Information')
                              return
                            endif
                            if len(aresults[1] )>0
                               :apicture[j]:=aresults[1]
                            endif

                            :ahelpid[j]:=aresults[2]
                            :astretch[j]:=aresults[3]
                            if .not. empty(aresults[4])
                               :aname[j]:=aresults[4]
                               ocontrol:value:=:aname[j]
                            endif
                            :aenabled[j]:=aresults[5]
                            :avisible[j]:=aresults[6]
                      endif
                      if :actrltype[j]=="TIMER"
                            Title:=cnamew+" properties"
                            aLabels         := { 'Interval' ,'Name','Enabled' }
                            aInitValues     := { :avaluen[j],:aname[j],:aenabled[j]    }
                            aFormats        := { '9999999',30,.F.}
                            aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                            if aresults[1] == Nil
             ***                  msginfo('Properties abandoned','Information')
                              return
                            endif
                            if aresults[1]>0
                               :avaluen[j]:=aresults[1]
                            endif
                            if .not. empty(aresults[2])
                               :aname[j]:=aresults[2]
                            endif
                            ocontrol:value:=:aname[j]
                            :aenabled[j]:=aresults[3]
                      endif
                      if :actrltype[j]=="ANIMATE"
                            Title:=cnamew+" properties"

                            aLabels         := { 'File'        ,'Autoplay'        ,'Center '        ,'Transparent',  'Helpid'   ,'Tooltip','Name','Enabled','Visible'     }
                            aInitValues     := { :afile[j]      ,:aautoplay[j]      , :acenter[j]      ,:atransparent[j] ,:ahelpid[j], :atooltip[j],:aname[j],:aenabled[j],:avisible[j] }
                            aFormats        := { 30            , .F.            ,.F.              ,.F.             ,'999'       , 120 ,30, .F. , .F. }
                            aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )

                            if aresults[1] == Nil
              ***                 msginfo('Properties abandoned','Information')
                              return
                            endif
                            :afile[j]:=aresults[1]
                            :aautoplay[j]:=aresults[2]
                            :acenter[j]:=aresults[3]
                            :atransparent[j]:=aresults[4]
                            :ahelpid[j]:=aresults[5]
                            :atooltip[j]:=aresults[6]

                                ocontrol:tooltip:=aresults[6]
                         
                            if .not. empty(aresults[7])
                               :aname[j]:=aresults[7]
                            endif
                            :aenabled[j]:=aresults[8]
                            :avisible[j]:=aresults[9]
                      endif
                      if :actrltype[j]=="PLAYER"
                            Title:=cnamew+" properties"

                            aLabels         := { 'File'        ,  'Helpid' ,'Name','Enabled','Visible'     }
                            aInitValues     := { :afile[j]      ,:ahelpid[j] ,:aname[j],:aenabled[j],:avisible[j] }
                            aFormats        := { 30            ,'999'  ,30 ,.F. , .F.  }
                            aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )

                            if aresults[1] == Nil
              ***                 msginfo('Properties abandoned','Information')
                              return
                            endif
                            :afile[j]:=aresults[1]
                            :ahelpid[j]:=aresults[2]
                            if .not. empty(aresults[3] )
                               :aname[j]:=aresults[3]
                            endif
                            :aenabled[j]:=aresults[4]
                            :avisible[j]:=aresults[5]
                      endif
                      if :actrltype[j]=="DATEPICKER"
                         Title:=cnamew+" properties"

                         aLabels         := { 'Date Value'  , 'Tooltip'  ,  'Shownone'  ,'updown'  , 'rightalign'  ,'Helpid','Field','Visible','Enabled','Name' }
                         aInitValues     := { :avalue[j]     , :atooltip[j],  :ashownone[j], :aupdown[j], :arightalign[j],:ahelpid[j],:afield[j],:avisible[j],:aenabled[j], :aname[j] }
                         aFormats        := { 20            ,   120      ,  .F.         ,     .F.   , .F.           ,'999', 250 , .T. , .T. ,30,.F.,.F. }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )

                         if aresults[1] == Nil
              ***              msginfo('Properties abandoned','Information')
                            return
                         endif


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
                         if .not. empty(aresults[10] )
                            :aname[j]:=aresults[10]
                         endif
                      endif
                      if :actrltype[j]=="MONTHCALENDAR"
                         Title:=cnamew+" properties"

                         aLabels         := { 'Date Value'  , 'Tooltip'  ,  'Notoday'  ,'Notodaycircle'  , 'Weeknumbers'  ,'Helpid','Visible','Enabled','Name' }
                         aInitValues     := { :avalue[j]     , :atooltip[j],  :anotoday[j], :anotodaycircle[j], :aweeknumbers[j],:ahelpid[j],:avisible[j],:aenabled[j],:aname[j] }
                         aFormats        := { 30            ,   120      ,  .F.         ,     .F.   , .F.           ,'999', .T. , .T. ,30,.F.,.F. }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )

                         if aresults[1] == Nil
              ***              msginfo('Properties abandoned','Information')
                            return
                         endif
                            :afontname[j]:=aresults[1]

                         if len(aresults[1])>0
                            :avalue[j]:=aresults[1]
                         else
                            :avalue[j]:=aresults[1]
                         endif


                         :atooltip[j]:=aresults[2]

                            ocontrol:tooltip:=aresults[2]
                        
                         :anotoday[j]:=aresults[3]
                         :anotodaycircle[j]:=aresults[4]
                         :aweeknumbers[j]:=aresults[5]
                         :ahelpid[j]:=aresults[6]
                         :avisible[j]:=aresults[7]
                         :aenabled[j]:=aresults[8]
                         if .not. empty(aresults[9]  )
                            :aname[j]:=aresults[9]
                         endif
                      endif

                   endif
		next j
                     endif
                   endif
                endif
**********************

:lFsave:=.F.
End
Return

*-------------------------
Procedure events_click()
*-------------------------
local i,cname,j, Title , aLabels , aInitValues , aFormats , aResults
WITH OBJECT myform
        i = nhandlep
	if i > 0
           ocontrol:=getformobject('form_1'):acontrols[i]
           cname:=lower(ocontrol:name)
           x:=ascan(:acontrolw, { |c| lower( c ) ==  cname  } )
		if ocontrol:type  == 'TAB'
                   Tabevent(i)
                   :lFsave:=.F.
                   return nil            &&&& lo meti yo
		Else
                cName:=lower(ocontrol:name)
                nform:=1
                For j:=1 to :ncontrolw
                   if lower(:acontrolw[j]) == cname
                     cnamew:=:aname[j]
                     if :actrltype[j]=="TEXT"
                         Title:=cnamew+" events"
                         aLabels         := { 'On enter'        ,'On change'        ,'On gotfocus'        ,'On lostfocus'       }
                         aInitValues     := { :aonenter[j] ,:aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]}
                         aFormats        := { 250               , 250                ,250                   ,250                   }
                        aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
               ***             msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonenter[j]:=aresults[1]
                         :aonchange[j]:=aresults[2]
                         :aongotfocus[j]:=aresults[3]
                         :aonlostfocus[j]:=aresults[4]

                      endif
                      if :actrltype[j]=="BUTTON"
                         Title:=cnamew+" events"
                         aLabels         := { 'On gotfocus'        ,'On lostfocus'       ,'Action'  }
                         aInitValues     := { :aongotfocus[j] ,:aonlostfocus[j],:aaction[j] }
                         aFormats        := { 250                , 250                     ,250 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
              ***              msginfo('Events abandoned','Information')
                            return
                         endif
                         :aongotfocus[j]:=aresults[1]
                         :aonlostfocus[j]:=aresults[2]
                         :aaction[j]:=aresults[3]
                      endif
                      if :actrltype[j]=='CHECKBOX'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus'       }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]}
                         aFormats        := {  250                ,250                   ,250                   }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
             ***               msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]

                      endif
                      if :actrltype[j]=='IPADDRESS'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus'       }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]}
                         aFormats        := {  250                ,250                   ,250                   }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
             ***               msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                      endif
                      if :actrltype[j]=='GRID'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus' ,'On Dblclick', 'On Headclcik',"On Editcell"  }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]            , :aondblclick[j], :aonheadclick[j] ,:aoneditcell[j] }
                         aFormats        := {  250                ,250                   ,250             ,250 ,250 ,800    }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
            ****                msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                         :aondblclick[j]:=aresults[4]
                         :aonheadclick[j]:=aresults[5]
                         :aoneditcell[j]:=aresults[6]
                      endif
                      if :actrltype[j]=='TREE'
                         myide:lvirtual:=.T.
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus' ,'On Dblclick'}
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]            , :aondblclick[j]  }
                         aFormats        := {  250                ,250                   ,250             ,250             }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
            ****                msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                         :aondblclick[j]:=aresults[4]
                      endif

                      if :actrltype[j]=='BROWSE'
                         myide:lvirtual:=.T.
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus' ,'On Dblclick', 'On Headclick','On Editcell','On Append','On enter'}
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]            , :aondblclick[j], :aonheadclick[j],:aoneditcell[j],:aonappend[j],:aonenter[j] }
                         aFormats        := {  250                ,250                   ,250             ,250         ,250 ,250,250,250    }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
            ****                msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                         :aondblclick[j]:=aresults[4]
                         :aonheadclick[j]:=aresults[5]
                         :aoneditcell[j]:=aresults[6]
                         :aonappend[j]:=aresults[7]
                         :aonenter[j]:=aresults[8]

                      endif

                      if :actrltype[j]=='SPINNER'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus'       }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]}
                         aFormats        := {  250                ,250                   ,250                   }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
             ****               msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]

                      endif
                      if :actrltype[j]=='LIST'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus','On dblclick' }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j], :aOndblclick[j]}
                         aFormats        := {  250                ,250                   ,250 ,250           }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
              ****              msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                         :aondblclick[j]:=aresults[4]
                      endif
                      if :actrltype[j]=='COMBO'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus', 'On Enter','On displaychange' }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j], :aonenter[j],:aondisplaychange[j] }
                         aFormats        := {  250                ,250                   ,250 ,   250  ,250                  }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
              ****              msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                         :aonenter[j]:=aresults[4]
                         :aondisplaychange[j]:=aresults[5]
                      endif
                      if :actrltype[j]=='CHECKBTN'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus'       }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]}
                         aFormats        := {  250                ,250                   ,250                   }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
          *****                  msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                      endif
                      if :actrltype[j]=='PICCHECKBUTT'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus'       }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]}
                         aFormats        := {  250                ,250                   ,250                   }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
          ***                  msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                      endif
                      if :actrltype[j]=="PICBUTT"
                         Title:=cnamew+" events"
                         aLabels         := { 'On gotfocus'        ,'On lostfocus'       ,'Action'  }
                         aInitValues     := { :aongotfocus[j] ,:aonlostfocus[j],:aaction[j] }
                         aFormats        := { 250                , 250                     ,250 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
          ***                  msginfo('Events abandoned','Information')
                            return
                         endif
                         :aongotfocus[j]:=aresults[1]
                         :aonlostfocus[j]:=aresults[2]
                         :aaction[j]:=aresults[3]
                      endif
                      if :actrltype[j]=="IMAGE"
                         Title:=cnamew+" events"
                         aLabels         := { 'Action'  }
                         aInitValues     := { :aaction[j] }
                         aFormats        := { 250 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
           ****                 msginfo('Events abandoned','Information')
                            return
                         endif
                         :aaction[j]:=aresults[1]
                      endif
                      if :actrltype[j]=="MONTHCALENDAR"
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'  }
                         aInitValues     := { :aonchange[j] }
                         aFormats        := { 250 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
           ****                 msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                      endif
                     if :actrltype[j]=="TIMER"
                         Title:=cnamew+" events"
                         aLabels         := { 'Action'  }
                         aInitValues     := { :aaction[j] }
                         aFormats        := { 250 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
           ****                 msginfo('Events abandoned','Information')
                            return
                         endif
                         :aaction[j]:=aresults[1]
                      endif
                     if :actrltype[j]=="LABEL"
                         Title:=cnamew+" events"
                         aLabels         := { 'Action'  }
                         aInitValues     := { :aaction[j] }
                         aFormats        := { 250 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
           ****                 msginfo('Events abandoned','Information')
                            return
                         endif
                         :aaction[j]:=aresults[1]
                      endif
                      if :actrltype[j]=="RADIOGROUP"
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'  }
                         aInitValues     := { :aonchange[j] }
                         aFormats        := { 250 }
	                 aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
          ****                  msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                      endif
                      if :actrltype[j]=="SLIDER"
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'  }
                         aInitValues     := { :aonchange[j] }
                         aFormats        := { 250 }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
         ****                   msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                      endif
                      if :actrltype[j]=='DATEPICKER'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus','On enter'  }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j] ,:aonenter[j] }
                         aFormats        := {  250                ,250                   ,250   ,   250        }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
         ****                   msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                         :aonenter[j]:=aresults[4]
                      endif
                      if :actrltype[j]=='EDIT'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus'       }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]}
                         aFormats        := {  250                ,250                   ,250                   }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
        ****                    msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                      endif
                      if :actrltype[j]=='RICHEDIT'
                         Title:=cnamew+" events"
                         aLabels         := { 'On change'        ,'On gotfocus'        ,'On lostfocus'       }
                         aInitValues     := { :aonchange[j] ,:aongotfocus[j] ,:aonlostfocus[j]}
                         aFormats        := {  250                ,250                   ,250                   }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
        ****                    msginfo('Events abandoned','Information')
                            return
                         endif
                         :aonchange[j]:=aresults[1]
                         :aongotfocus[j]:=aresults[2]
                         :aonlostfocus[j]:=aresults[3]
                      endif
                   endif
                next j

		EndIf


	EndIf
:lFsave:=.F.
END
return

*-------------------------
function frmproperties()
*-------------------------
with object myform
 Title:='Form '+:cfname+" properties"
                aLabels         := { 'Title'      ,'icon'  ,'main','child' ,'noshow','topmost','nominimize','nomaximize','nosize','nosysmenu','nocaption','modal','Notify icon','Notify tooltip','Noautorelease','Helpbutton','Focused','Break','Splitchild','Grippertext','Cursor','Virtual Height','Virtual Width','Object' }
                aInitValues     := { :cftitle, :cficon ;
,:lfmain,:lfchild,:lfnoshow,:lftopmost,:lfnominimize,:lfnomaximize,:lfnosize,:lfnosysmenu,:lfnocaption,:lfmodal,:cfnotifyicon ,:cfnotifytooltip,:lfnoautorelease,:lfhelpbutton, ;
:lffocused, :lfbreak, :lfsplitchild, :lfgrippertext, :cfcursor, :nfvirtualh,:nfvirtualw, :cfobj }
                aFormats        := { 200           , 31     ,.F.   ,.F.     ,.F.     ,.F.      ,.F.         ,.F.         ,.F.     , .F.       , .F.       ,.F.    , 120          ,120 , .F., .F., .F., .F.,.F., .F., 31,'9999','9999', 120  }
                myide:lvirtual:=.T.
                aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )


                  if aresults[1] == Nil
            ***         msginfo('Form Properties abandoned','Information')
                            return
                  endif

                         :cftitle:=aresults[1]
                         form_1.title := :cftitle

                         :cficon:=aresults[2]


                         if aresults[3]
                            :lfmain:=aresults[3]
                         else
                            :lfmain:=.f.
                         endif
                         if aresults[4]
                            :lfchild:=aresults[4]
                         else
                            :lfchild:=.F.
                         endif
                         if aresults[5]
                            :lfnoshow:=aresults[5]
                          else
                            :lfnoshow:=.f.
                         endif
                         if aresults[6]
                            :lftopmost:=aresults[6]
                         else
                            :lftopmost:=.f.
                         endif
                         if aresults[7]
                            :lfnominimize:=aresults[7]
                         else
                            :lfnominimize:=.f.
                         endif
                         if aresults[8]
                            :lfnomaximize:=aresults[8]
                         else
                            :lfnomaximize:=.f.
                         endif
                         if aresults[9]
                            :lfnosize:=aresults[9]
                         else
                            :lfnosize:=.f.
                         endif
                         if aresults[10]
                            :lfnosysmenu:=aresults[10]
                         else
                            :lfnosysmenu:=.f.
                         endif
                         if aresults[11]
                            :lfnocaption:=aresults[11]
                         else
                            :lfnocaption:=.F.
                         endif
                         if aresults[12]
                            :lfmodal:=aresults[12]
                         else
                            :lfmodal:=.F.
                         endif
                         :cfnotifyicon:=aresults[13]
                         :cfnotifytooltip:=aresults[14]
                         if aresults[16]
                            :lfnoautorelease:=aresults[15]
                         else
                            :lfnoautorelease:=.F.
                         endif
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
end
return

*----------------------
function frmevents()
*----------------------
local i,cname,j, Title , aLabels , aInitValues , aFormats , aResults

with object myform
                         Title:='Form '+:cfname+" events"
                         myide:lvirtual:=.T.
                         aLabels         := { 'On init','On release','On mouseclick','On mousemove','On mousedrag','On gotfocus','On lostfocus','On scrollup','On scrolldown','On scrollleft','On scrollright','On hscrollbox','On vscrollbox','On size','On paint','On notifyclick',"On interactiveclose" }
                         aInitValues     := { :cfoninit ,:cfonrelease ,:cfonmouseclick ,:cfonmousemove ,:cfonmousedrag ,:cfongotfocus ,:cfonlostfocus ,:cfonscrollup , :cfonscrolldown,:cfonscrollleft ,:cfonscrollright ,:cfonhscrollbox ,:cfonvscrollbox ,:cfonsize , :cfonpaint,:cfonnotifyclick,:cfoninteractiveclose }
                         aFormats        := { 250       , 250         ,250             ,250            ,250            ,250           ,250            ,250           ,250             ,250             ,250              ,250              ,250              ,250       ,250        ,250, 250      }
                         aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
                         if aresults[1] == Nil
               ****             msginfo('Events abandoned','Information')
                            return
                         endif
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
:lFsave:=.F.
end
return

*-------------------------
function statpropevents()
*-------------------------
with object myform
     myide:lvirtual:=.T.
     cname:='Statusbar'
     Title:=cname+" properties"
     aLabels         := { 'Caption'        ,'Width' ,'Action','icon','flat','raised','tooltip','date','time','Keyboard' }
     aInitValues     := { :cscaption        , :nswidth,:csaction,:csicon,:lsflat,:lsraised,:cstooltip,:lsdate,:lstime,:lskeyboard }
     aFormats        := {         480       , '9999' ,  250   ,  30  , .F.  ,.F.     ,120       ,.F.   ,.F., .T. }
     aResults        := myinputwindow ( Title , aLabels , aInitValues , aFormats )
     if aresults[1] == Nil
        **   msginfo('Properties abandoned','Information')
       :control_click(1)
       return
     endif

  form_1.statusbar.release

   DEFINE STATUSBAR of form_1
            if len(aresults[1])> 0
               STATUSITEM aresults[1]
            endif
            if aresults[10]
               KEYBOARD
            endif
            if aresults[8]
               DATE WIDTH 95
            endif
            if aresults[9]
               CLOCK WIDTH 85
            endif
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
    :lFsave:=.F.
    :control_click(1)
 end
return
*-----------------------
function TabProp(i)
*-----------------------
local ki
with object myform
        ocontrol:=getformobject("form_1"):acontrols[i]
        cname:=lower(ocontrol:name)
        ki:= ascan( :acontrolw, { |c| lower( c ) ==  cname  } )
        load window tabprop
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

	CENTER WINDOW tabProp

	ACTIVATE WINDOW TabProp
	end
Return nil

*--------------------
function Tabevent(i)
*--------------------
local ki
with object myform
        ocontrol:=getformobject("form_1"):acontrols[i]
        cname:=ocontrol:name
        ki := ascan( :acontrolw, { |c| lower( c ) ==  cname  } )
        load window tabeven AS Tabprop
        tabprop.text_101.value:=:aonchange[ki]
        tabprop.title:="Tab events "+:aname[ki]

	CENTER WINDOW tabProp

	ACTIVATE WINDOW TabProp
end
Return nil

*-------------------------
function cambiacap(cname)
*-------------------------
local i
cacaptions:=  tabprop.text_101.value
acaptions := &cacaptions
if HB_Isarray(acaptions)
   otab:=getcontrolobject(cname,"Form_1")
   for i:= 1 to len(acaptions)
       otab:caption(i,acaptions[i])
   next i
endif
return nil
*-----------------------------
function addtabpageaux(i)
*-----------------------------
local j,cname
with object myform
ocontrol:=getformobject("form_1"):acontrols[i]
cname:=lower(ocontrol:name)
j:= ascan( :acontrolw, { |c| lower( c ) ==  cname  } )

caux:=:acaption[j]
caux1:=&caux
auxpages:=len(caux1)
:acaption[j]:=substr(:acaption[j],1,len(:acaption[j])-1)+",'Page "+alltrim(str(auxpages+1))+"'}"
:aimage[j]:=substr(:aimage[j],1,len(:aimage[j])-1)+",' '  }"

tabprop.text_101.value:=:acaption[j]
tabprop.Edit_2.value:=:aimage[j]
cname:=:acontrolw[j]
ocontrol:addpage(auxpages+1,'Page '+alltrim(str(auxpages+1)),'')
end
return

*------------------------------
function deletetabpageaux(i)
*------------------------------
local p,j,cname,p1,k
with object myform
ocontrol:=getformobject("form_1"):acontrols[i]
cname:=lower(ocontrol:name)
j:= ascan( :acontrolw, { |c| lower( c ) ==  cname  } )

caux:=:acaption[j]
caux1:=&(caux)
auxpages:=len(caux1)
if auxpages<=1
   return nil
endif
p=rat(",",:acaption[j])
p1=rat(",",:aimage[j])
cname:=:acontrolw[j]
:acaption[j]:=substr(:acaption[j],1,p-1)+"}"
:aimage[j]  :=substr(:aimage[j],1,p1-1)+"}"
tabprop.text_101.value:=:acaption[j]
tabprop.Edit_2.value:=:aimage[j]
ocontrol:deletepage(auxpages)
for ia:=1 to :ncontrolw
    if :atabpage[ia,1]=cname .and. :atabpage[ia,2]=auxpages
       :atabpage[ia,1]:=''
       :atabpage[ia,2]:=0
       *** borra control  quitado por que ahora apenas se borra la pagina se borran los controles contenidos
         ///  aborrar:=:aname[ia]
          /// automsgbox(aborrar)
        ///   oaborrar:=getcontrolobject(aborrar,"form_1")
       ///    if hb_isobject()
       ///       oaborrar:release()
      ///     else
      ///     ////   automsgbox("no es objeto")
      ///     endif
           :iniarray(:nform,ia,'','')
       ***
    endif
next ia
ocontrol:visible:=.F.
ocontrol:visible:=.T.

end
return
*------------------------------------------------------------------------------*

