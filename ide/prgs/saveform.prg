/*
 * $Id: saveform.prg,v 1.3 2014-06-19 18:53:30 fyurisich Exp $
 */

/////#include 'oohg.ch'

declare window form_1

*------------------------------------------------------------------------------*
METHOD save(Cas) CLASS tform1
*------------------------------------------------------------------------------*
local i , h , BaseRow , BaseCol , TitleHeight , BorderWidth , BorderHeight , Name , Row , Col , Width , height , Output , j , p , k,m,jn,npos,mlyform
local swpop:=0
	If .Not. IsWindowDefined(Form_1)
           Return
	EndIf
        define main menu of form_1
        end menu
        npos:=rat('.',myform:cform)
        
        mlyform:=substr(myform:cform,1,npos-1)
        nslash:=rat("\",mlyform)
        if nslash>0
           mlyform:=substr(mlyform,nslash+1)
        endif
        ////msgbox(mlyform)
        cursorwait()
        mlyform:=lower(mlyform)
	h := GetFormHandle (myform:designform)

	BaseRow 	:= GetWindowRow ( h )
	BaseCol 	:= GetWindowCol ( h )
	BaseWidth 	:= GetWindowWidth ( h )
	BaseHeight 	:= GetWindowHeight ( h )
	TitleHeight 	:= GetTitleHeight()
	BorderWidth 	:= GetBorderWidth()
	BorderHeight 	:= GetBorderHeight()
        Output := ''+CRLF
        OUTPUT += '* ooHG IDE Plus form generated code'+CRLF
        output += '* (c)2003-2014 Ciro Vargas Clemow <pcman2010@yahoo.com>'+CRLF
        Output += ''+CRLF
	Output += 'DEFINE WINDOW '+ ' TEMPLATE ; '+CRLF
        output += 'AT ' + Alltrim(Str(baserow)) + ',' + Alltrim(Str(baseCol)) + ' ;' +CRLF
        Output += iif(!empty(myform:cfobj),"OBJ "+myform:cfobj+" ;"+CRLF,"")
        output += ' WIDTH '+ Alltrim(Str(baseWidth))  + ' ;' +CRLF
        output += ' HEIGHT '+ Alltrim(Str(baseHeight))  + ' ; '+CRLF
        if myform:nfvirtualw>0
           output += 'VIRTUAL WIDTH '+ Alltrim(Str(myform:nfvirtualw))  + ' ;' +CRLF
        endif
        if myform:nfvirtualh>0
           output += 'VIRTUAL HEIGHT '+ Alltrim(Str(myform:nfvirtualh))  + ' ; '+CRLF
        endif
        output += ' TITLE '+ "'"+myform:cftitle+"'"+ ' ; '+CRLF
        output += ' ICON '+ "'"+myform:cficon+"'"+ ' ; '+CRLF
        output +=   iif(myform:lfmain,"MAIN ;"+CRLF,"")
        output +=   iif(myform:lfsplitchild,"SPLITCHILD  ;"+CRLF,"")
        output +=   iif(myform:lfchild,"CHILD ;"+CRLF,"")
        output +=   iif(myform:lfmodal,"MODAL ;"+CRLF,"")
        output +=   iif(myform:lfnoshow,"NOSHOW ;"+CRLF,"")
        output +=   iif(myform:lftopmost,"TOPMOST ;"+CRLF,"")
        output +=   iif(myform:lfnoautorelease,"NOAUTORELEASE ;"+CRLF,"")
        output +=   iif(myform:lfnominimize,"NOMINIMIZE ;"+CRLF,"")
        output +=   iif(myform:lfnomaximize,"NOMAXIMIZE ;"+CRLF,"")
        output +=   iif(myform:lfnosize,"NOSIZE ;"+CRLF,"")
        output +=   iif(myform:lfnosysmenu,"NOSYSMENU ;"+CRLF,"")
        output +=   iif(myform:lfnocaption,"NOCAPTION ;"+CRLF,"")

*****            output+=CRLF

        if len(myform:cfcursor)>0
            output +=   'CURSOR '+"'"+myform:cfcursor+"'"+  ' ;'+ CRLF
        endif

        if len(myform:cfoninit)>0
            output +=   'ON INIT '+myform:cfoninit +' ; '+CRLF
        endif
        if len(myform:cfonrelease)>0
            output +=   'ON RELEASE '+myform:cfonrelease +' ; '+CRLF
        endif
        if len(myform:cfoninteractiveclose)>0
            output +=   'ON INTERACTIVECLOSE '+myform:cfoninteractiveclose +' ; '+CRLF
        endif
        if len(myform:cfonmouseclick)>0
            output +=   'ON MOUSECLICK '+myform:cfonmouseclick +' ; '+CRLF
        endif
        if len(myform:cfonmousedrag)>0
            output +=   'ON MOUSEDRAG '+myform:cfonmousedrag +' ; '+CRLF
        endif
        if len(myform:cfonmousemove)>0
            output +=   'ON MOUSEMOVE '+myform:cfonmousemove +' ; '+CRLF
        endif
        if len(myform:cfonsize)>0
            output +=   'ON SIZE '+myform:cfonsize +' ; '+CRLF
        endif
        if len(myform:cfonpaint)>0
            output +=   'ON PAINT '+myform:cfonpaint +' ; '+CRLF
        endif

        if len(myform:cfbackcolor)>0 .and. myform:cfbackcolor#'NIL'
            output +=   'BACKCOLOR '+myform:cfbackcolor +' ; '+CRLF
        endif

        if len(myform:cffontname)>0
           Output += "FONT "+ "'"+myform:cffontname+"'"+  ' ;'+ CRLF
        endif

        if myform:nffontsize>0
           Output += 'SIZE '+ str(myform:nffontsize,2) + ' ;'+CRLF
        else
           Output += 'SIZE '+ str(10,2) + ' ;'+CRLF
        endif
        output +=  iif(myform:lfgrippertext,"GRIPPERTEXT ;"+CRLF,"")
        if len(myform:cfnotifyicon)>0
           Output += "NOTIFYICON "+ "'"+myform:cfnotifyicon+"'"+  ' ;'+ CRLF
        endif
        if len(myform:cfnotifytooltip)>0
           Output += "NOTIFYTOOLTIP "+ "'"+myform:cfnotifytooltip+"'"+  ' ;'+ CRLF
        endif
        if len(myform:cfonnotifyclick)>0
            output +=   'ON NOTIFYCLICK '+myform:cfonnotifyclick +' ; '+CRLF
        endif
        output +=  iif(myform:lfbreak,"BREAK ;"+CRLF,"")
        output +=  iif(myform:lffocused,"FOCUSED ;"+CRLF,"")
        if len(myform:cfongotfocus)>0
            output +=   'ON GOTFOCUS '+myform:cfongotfocus +' ; '+CRLF
        endif
        if len(myform:cfonlostfocus)>0
            output +=   'ON LOSTFOCUS '+myform:cfonlostfocus +' ; '+CRLF
        endif

        if len(myform:cfonscrollup)>0
            output +=   'ON SCROLLUP '+myform:cfonscrollup +' ; '+CRLF
        endif
        if len(myform:cfonscrolldown)>0
            output +=   'ON SCROLLDOWN '+myform:cfonscrolldown +' ; '+CRLF
        endif
        if len(myform:cfonscrollright)>0
            output +=   'ON SCROLLRIGHT '+myform:cfonscrollright +' ; '+CRLF
        endif
        if len(myform:cfonscrollleft)>0
            output +=   'ON SCROLLLEFT '+myform:cfonscrollleft +' ; '+CRLF
        endif
        if len(myform:cfonhscrollbox)>0
            output +=   'ON HSCROLLBOX '+myform:cfonhscrollbox +' ; '+CRLF
        endif
        if len(myform:cfonvscrollbox)>0
            output +=   'ON VSCROLLBOX '+myform:cfonvscrollbox +' ; '+CRLF
        endif
        output +=  iif(myform:lfhelpbutton,"HELPBUTTON ;"+CRLF,"")

        output += CRLF+CRLF

 *********** HASTA AQUI DEFINICION BASICA DE LA FORMA

        wvalor:=.F.
/////        FETCH CONTROL check    _stat OF form_main VALUE TO wvalor
        if myform:lsstat
           wvalor:=.T.
        endif
        if wvalor
           output +='DEFINE STATUSBAR '+CRLF
           if len(myform:cscaption)>0
              output +='STATUSITEM '+'"'+myform:cscaption+'" ; '+CRLF
           else
              output +="STATUSITEM ' ' "+" ; "+CRLF
           endif
           if myform:nswidth>0
              output +='WIDTH '+str(myform:nswidth,4)+ ' ; '+CRLF
           endif
           if len(myform:csaction)>0
              output +='ACTION '+myform:csaction+' ; '+CRLF
           endif
           if len(myform:csicon)>0
              output +='ICON '+'"'+myform:csicon+'" ; '+CRLF
           endif
           if myform:lsflat
              output +='FLAT '+' ; '+CRLF
           endif
           if myform:lsraised
              output +='RAISED '+' ; '+CRLF
           endif
           if len(myform:cstooltip)>0
               output +='TOOLTIP '+'"'+myform:cstooltip+'" ; '+CRLF
           endif
           output+= ' &&& comment'+CRLF
           if myform:lskeyboard
              output+= 'KEYBOARD'+'  '+CRLF
******              output+= 'WIDTH '+str(80,4)+' ; '+CRLF
           endif
           if myform:lsdate
              output+= 'DATE '+' ; '+CRLF
              output+= 'WIDTH '+str(80,4)+' ; '+CRLF
           endif

*           if len(csdateaction)>0
*              output+= 'ACTION '+csdateaction+' ; '+CRLF
*           endif
*           if len(csdatetooltip)>0
*              output+= 'TOOLTIP '+'"'+csdatetooltip+'" ; '+CRLF
*           endif
           output+= ' &&& comment '+CRLF
           if myform:lstime
              output+= 'CLOCK '+' ; '+CRLF
              output+= 'WIDTH '+str(80,4)+' ; '+CRLF
           endif

*           if len(cstimeaction)>0
*              output+= 'ACTION '+cstimeaction+' ; '+CRLF
*           endif
*           if len(cstimetooltip)>0
*              output+= 'TOOLTIP '+'"'+cstimetooltip+'" ; '+CRLF
*           endif
           output+= ' &&& comment '+CRLF
           output+='END STATUSBAR'+CRLF
           output+= CRLF

        endif

***************************  creacion de menus
        close data
        if file(myform:cfname+'.mnm')
           archivo:=myform:cfname+'.mnm'
           select 10
           use &archivo exclusive alias menues
           if reccount()>0
              pack
           endif
           if  reccount()>0
            output+=CRLF+'DEFINE MAIN MENU '+CRLF
                   **************
                   do while .not. eof()
                   if recn() < reccount()
                      skip
                      signiv:=level
                      skip -1
                   else
                      signiv=0
                   endif
                      niv=level
                       if signiv>level
                            if lower(trim(auxit))='separator'
                               output+=space(6*level)+'SEPARATOR'+ CRLF
                            else
                    /////           output+=space(6*level)+'POPUP '+"'"+trim(auxit) +"'"+ CRLF
                               output+=space(6*level)+'POPUP '+"'"+trim(auxit) +"'"+ iif(trim(named)#""," NAME "+"'"+alltrim(named)+"'","")  +" "+ CRLF
                                  if menues->enabled='X'
                                     cc:="//"+mlyform+'.'+trim(named)+'.enabled:=.F.'
                                     output+= cc + CRLF
                                     cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'enabled',.F.)"
   ////                                   CARGACOPIA", "TEXT_" + NUME, "VALUE", 0 )

                                     output+= cc + CRLF
                                  endif
                               swpop++
                            endif
                       else
                            if lower(trim(auxit))='separator'
                               output+=space(6*level)+'SEPARATOR'+ CRLF
                            else
                               output+=space(6*level)+'ITEM '+"'"+ trim(auxit) +"'"+ ' ACTION '+iif(len(trim(action))#0,trim(ACTION),"msgbox('item')")+ " "
                               if trim(named)==''
                                  output+=""+IIF(TRIM(menues->IMAGE)#""," IMAGE "+"'"+alltrim(menues->IMAGE)+"'","")+ " "+CRLF
                               else
                                  output+= "NAME "+"'"+alltrim(NAMED)+"'" + IIF(TRIM(menues->IMAGE)#""," IMAGE "+"'"+alltrim(menues->IMAGE)+"'","")+ " "+CRLF
                                  if menues->checked='X'
                                     cc:="//"+mlyform+'.'+trim(named)+'.checked:=.F.'
                                     output+= cc + CRLF
                                     cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'checked',.F.)"
                                     output+= cc + CRLF
                                  endif
                                  if menues->enabled='X'
                                     cc:="//"+mlyform+'.'+trim(named)+'.enabled:=.F.'
                                     output+= cc + CRLF
                                     cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'enabled',.F.)"
                                     output+= cc + CRLF
                                  endif
                               endif

                            endif
**********************************
                         do while signiv<niv
                              output+=space((niv-1)*6)+'END POPUP'+CRLF
                               swpop--
                               niv--
                         enddo
                       endif
                      skip
                   enddo
            nnivaux:=niv-1
            do while swpop>0
               nnivaux--
               output+=space((nnivaux)*6)+'END POPUP'+CRLF
               swpop--
            enddo

            output+=CRLF
            output+='END MENU'+CRLF+CRLF
******   fin de creacion de menu principal
            close data
            endif
        endif
        close data
        if file(myform:cfname+'.mnc')
           archivo:=myform:cfname+'.mnc'
           select 20
           use &archivo alias menues
           if  reccount()>0
               output+=CRLF+'DEFINE CONTEXT MENU '+CRLF
               **************
               do while .not. eof()
               if lower(trim(auxit))='separator'
                  output+=space(6*level)+'SEPARATOR'+ CRLF
               else
                  output+=space(6*level)+'ITEM '+"'"+ trim(auxit) +"'"+ ' ACTION '+iif(len(trim(action))#0,trim(ACTION),"msgbox('item')")+ " "
                  if trim(named)==''
                     output+="" +IIF(LEN(TRIM(menues->IMAGE))#0," IMAGE "+"'"+alltrim(menues->IMAGE)+"'","")+ " "+CRLF
                  else
                     output+= "NAME "+"'"+alltrim(NAMED)+"'"+IIF(LEN(TRIM(menues->IMAGE))#0," IMAGE "+"'"+alltrim(menues->IMAGE)+"'","")+ " "+CRLF
                     if menues->checked='X'
                        cc:="//"+mlyform+'.'+trim(named)+'.checked:=.F.'
                        output+= cc + CRLF
                        cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'checked',.F.)"


////                        cc:=mlyform+'.'+trim(named)+'.checked:=.T.'
                        output+= cc + CRLF
                     endif
                     if menues->enabled='X'

                        cc:="//"+mlyform+'.'+trim(named)+'.enabled:=.F.'
                        output+= cc + CRLF
                        cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'enabled',.F.)"

                        output+= cc + CRLF
                     endif
                  endif
               endif
               skip
               enddo
               output+=CRLF
               output+='END MENU'+CRLF+CRLF
               use
****    fin de menu contextual
           endif
        endif
        close data
        if file(myform:cfname+'.mnn')
           archivo:=myform:cfname+'.mnn'
           select 30
           use &archivo alias menues
           if  reccount()>0
               output+=CRLF+'DEFINE NOTIFY MENU '+CRLF
               **************
               do while .not. eof()
               if lower(trim(auxit))='separator'
                  output+=space(6*level)+'SEPARATOR'+ CRLF
               else
                  output+=space(6*level)+'ITEM '+"'"+ trim(auxit) +"'"+ ' ACTION '+iif(len(trim(action))#0,trim(ACTION),"msgbox('item')")+ " "
                  if trim(named)==''
                     output+="" + IIF(LEN(TRIM(menues->IMAGE))#0," IMAGE "+"'"+alltrim(menues->IMAGE)+"'","")+ " "+CRLF
                  else
                     output+= "NAME "+"'"+alltrim(NAMED)+"'" +IIF(LEN(TRIM(menues->IMAGE))#0," IMAGE "+"'"+alltrim(menues->IMAGE)+"'","")+ " "+CRLF
                     if menues->checked='X'
                        cc:="//"+mlyform+'.'+trim(named)+'.checked:=.F.'
                        output+= cc + CRLF
                        cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'checked',.F.)"

                        output+= cc + CRLF
                     endif
                     if menues->enabled='X'
                        cc:="//"+mlyform+'.'+trim(named)+'.enabled:=.F.'
                        output+= cc + CRLF
                        cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'enabled',.F.)"

                        output+= cc + CRLF
                     endif
                  endif
               endif
               skip
               enddo
               output+=CRLF
               output+='END MENU'+CRLF+CRLF
           use
******          fin de menu notify
           endif
        endif

        ***** end menus creation
        close data
        if file(myform:cfname+'.tbr')
           archivo:=myform:cfname+'.tbr'
           select 40
           use &archivo exclusive alias dDtoolbar
           pack
           if  reccount()>0
               output+=CRLF+'DEFINE TOOLBAR '+tmytoolb:ctbname+' ; '+CRLF
               output+='BUTTONSIZE '+str(tmytoolb:nwidth,4)+ ' , '+ str(tmytoolb:nheight,4) +'  ;  '+CRLF
               output+=iif(len(tmytoolb:cfont)>0,'FONT '+"'"+tmytoolb:cfont+"' ;"+CRLF,'')
               output+=iif(tmytoolb:nsize>0,'SIZE '+str(tmytoolb:nsize,4)+" ;"+CRLF,'')
               output+=iif(tmytoolb:lbold,'BOLD ;'+CRLF,'')
               output+=iif(tmytoolb:litalic,'ITALIC ;'+CRLF,'')
               output+=iif(tmytoolb:lunderline,'UNDERLINE ;'+CRLF,'')
               output+=iif(tmytoolb:lstrikeout,'STRIKEOUT ;'+CRLF,'')
               output+=iif(len(tmytoolb:ctooltip)>0,'TOOLTIP '+"'"+tmytoolb:ctooltip+"' ;"+CRLF,'')
               output+=iif(tmytoolb:lflat,'FLAT ;'+CRLF,'')
               output+=iif(tmytoolb:lbottom,'BOTTOM ;'+CRLF,'')
               output+=iif(tmytoolb:lrighttext,'RIGHTTEXT ;'+CRLF,'')
               output+=iif(tmytoolb:lborder,'BORDER ;'+CRLF,'')

               output+=CRLF+CRLF
               go top
               **************
               do while .not. eof()
                  output+='BUTTON '+trim(NAMED)+ ' ; '+CRLF
                  output+='CAPTION '+"'"+trim(ITEM)+"'"+ ' ; '+CRLF
                  if len(trim(DdTOOLBAR->IMAGE))>0
                    output+='PICTURE '+"'"+trim(DdTOOLBAR->IMAGE)+"'"+ ' ; '+CRLF
                  endif
                  output+='ACTION '+trim(DdTOOLBAR->ACTION)+ ' ; '+CRLF
                  if DdTOOLBAR->Separator='X'
                     output+='SEPARATOR  ; ' + CRLF
                  endif
                  if DdTOOLBAR->AUTOSIZE='X'
                     output+='AUTOSIZE  ; ' + CRLF
                  endif
                  if DdTOOLBAR->check='X'
                     output+='CHECK  ; ' + CRLF
                  endif
                  if DdTOOLBAR->group='X'
                     output+='GROUP  ; ' + CRLF
                  endif


                  if fcount()>9
                     if DdTOOLBAR->drop='X'
                        output+='DROPDOWN  ; ' + CRLF
                     endif
                     if fcount()>10
                        if .not. empty(DdTOOLBAR->tooltip )
                           output+="Tooltip  '"+rtrim(Ddtoolbar->tooltip)+"'"+ " ; " + CRLF
                        endif
                     endif
                  endif
                  **** VER GROUP Y SEPARATOR
                  skip
                  output+=CRLF+CRLF
               enddo
               output+=CRLF
               output+='END TOOLBAR'+CRLF+CRLF
           endif
        go top
        do while .not. eof()
           cbutton:=alltrim(ddtoolbar->named)
           carchivo:=myform:cfname+'.'+cbutton+'.mnd'
           if file(carchivo)
           select 50
           use &carchivo alias menues
           if  reccount()>0
               output+=CRLF+CRLF+'DEFINE DROPDOWN MENU BUTTON '+cbutton+CRLF
               **************
               do while .not. eof()
               if lower(trim(auxit))='separator'
                  output+=space(6*level)+'SEPARATOR'+ CRLF
               else
                  output+=space(6*level)+'ITEM '+"'"+ trim(auxit) +"'"+ ' ACTION '+iif(len(trim(action))#0,trim(ACTION),"msgbox('item')")+ " "
                  if trim(named)==''
                     output+="" + IIF(LEN(TRIM(menues->IMAGE))#0," IMAGE "+"'"+alltrim(menues->IMAGE)+"'","")+ " "+CRLF
                  else
                     output+= "NAME "+NAMED +IIF(LEN(TRIM(menues->IMAGE))#0," IMAGE "+"'"+alltrim(menues->IMAGE)+"'","")+ " "+CRLF

                     if menues->checked='X'
                        cc:="//"+mlyform+'.'+trim(named)+'.checked:=.F.'
                        output+= cc + CRLF
                        cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'checked',.F.)"

                        output+= cc + CRLF
                     endif
                     if menues->enabled='X'
                        cc:="//"+mlyform+'.'+trim(named)+'.enabled:=.F.'
                        output+= cc + CRLF
                        cc:="SetProperty('"+mlyform+"',"+"'"+trim(named)+"',"+"'enabled',.F.)"

                        output+= cc + CRLF
                     endif
                  endif
               endif
               skip
               enddo
               output+=CRLF
               output+='END MENU'+CRLF+CRLF
           endif
           endif
           select 40
           skip
        enddo
        endif
        ********** dropdown menu

        ***** end toolbar ****    fin de toolbar

        j:=1
        do while j <=  myform:ncontrolw
               do while upper(myform:acontrolw[j])='TEMPLATE' .AND. upper(myform:acontrolw[j])='STATUSBAR'  .AND. upper(myform:acontrolw[j])='MAINMENU' ;
                 .and. upper(myform:acontrolw[j])='CONTEXTMENU' .AND. upper(myform:acontrolw[j])='NOTIFYMENU' .and. j< myform:ncontrolw
                  j++
               enddo
            name:=myform:acontrolw[j]
            nhandle:=myascan(name)
*********
            if nhandle=0
               j++
               loop
            endif
            owindow:=getformobject("form_1")
            Row    := GetWindowRow ( owindow:acontrols[nhandle]:hwnd ) - BaseRow - TitleHeight - BorderHeight
	    Col    := GetWindowCol ( owindow:acontrols[nhandle]:hwnd ) - BaseCol - BorderWidth
	    Width  := GetWindowWidth ( owindow:acontrols[nhandle]:hwnd )
	    Height := GetWindowHeight ( owindow:acontrols[nhandle]:hwnd )


                        if myform:actrltype[j] == 'TAB'
                           Output += '*****@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' TAB '+ myform:aname[j] + '  '+CRLF
                           output+= 'DEFINE TAB '+myform:aname[j]+' ; '+CRLF
                           output+= 'AT '+ str(row,4) +' , '+ str(col,4)+'  ; '+CRLF
                           Output += 'WIDTH  '+ Alltrim(Str(Width))  + ' ;'+CRLF
                           output += 'HEIGHT '+ Alltrim(Str(Height)) + ' ;'+ CRLF
                           if len(myform:avalue[j])>0
                              Output += 'VALUE '+ myform:avalue[j]  + ' ;'+CRLF
                           endif
                           if len(myform:afontname[j])>0
                              Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                           endif
                           if myform:afontsize[j]>0
                              Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                           endif
                           if len(myform:atooltip[j])>0
                              Output += 'TOOLTIP '+"'"+ myform:atooltip[j]+"'" + ' ;'+ CRLF
                           endif
                           if myform:abuttons[j]
                              Output += 'BUTTONS '+'  ;'+ CRLF
                           endif
                           if myform:aflat[j]
                              Output += 'FLAT '+'  ;'+ CRLF
                           endif
                           if myform:ahottrack[j]
                              Output += 'HOTTRACK '+'  ;'+ CRLF
                           endif
                           if myform:avertical[j]
                              Output += 'VERTICAL '+'  ;'+ CRLF
                           endif
                           if len(myform:aonchange[j])>0
                              output += 'ON CHANGE '+ myform:aonchange[j]+ ' ;'+ CRLF
                           endif
                           output+= '  '+'  '+CRLF+CRLF
                            **************
****                           cuantos page hay ?
                           cacaptions:=myform:acaption[j]
                           caimages:=myform:aimage[j]
                           acaptions:=&cacaptions
                           aimage:=&caimages
                           currentpage:=1
                           output+= "DEFINE PAGE '"+acaptions[currentpage]+"'"+'  ;'+CRLF
                           output+= "IMAGE '"+ltrim(aimage[currentpage])+"'"+'  '+CRLF+CRLF
                           for k=1 to myform:ncontrolw
                               if myform:atabpage[k,1]#NIL
                                  if myform:atabpage[k,1]==myform:acontrolw[j]
                                     if myform:atabpage[k,2]#currentpage
                                         output+= 'END PAGE'+CRLF+CRLF
                                         currentpage++
                                        output+= "DEFINE PAGE '"+acaptions[currentpage]+"'"+'  ;'+CRLF
                                        output+= "IMAGE '"+ltrim(aimage[currentpage])+"'"+'  '+CRLF+CRLF
                                     endif

                                     p:=myascan(myform:acontrolw[k])
                                     if p>0
                                        owindow:=getformobject("form_1")
                                        Row     := owindow:acontrols[p]:row
                                        Col     := owindow:acontrols[p]:col
                                        Width   := owindow:acontrols[p]:width
                                        Height  := owindow:acontrols[p]:height
                                        output:=makecontrols(k,output,row,col,width,height,mlyform)
                                     endif
                                  endif
                               endif
                           next k

                           output+= 'END PAGE '+'  '+CRLF
                           if myform:afontitalic[j]
                               output+= mlyform+'.'+name+'.fontitalic:=.T.'+CRLF
                           endif
                           if myform:afontunderline[j]
                               output+= mlyform+'.'+name+'.fontunderline:=.T.'+CRLF
                           endif
                           if myform:afontstrikeout[j]
                               output+= mlyform+'.'+name+'.fontstrikeout:=.T.'+CRLF
                           endif
                           if myform:abold[j]
                               output+= mlyform+'.'+name+'.fontbold:=.T.'+CRLF
                           endif
                           if .not. myform:aenabled[j]
                              output += mlyform+'.'+name+'.enabled:=.F.'+CRLF
                           endif
                           if .not. myform:avisible[j]
                              output += mlyform+'.'+name+'.visible:=.F.'+CRLF
                           endif

                           output+="END TAB" +CRLF+CRLF
*************************************************
                           output+=CRLF
                        else
                           if myform:actrltype[j]#'TAB' .and. myform:atabpage[j,2]=0 .or. myform:atabpage[j,2]=NIL
                              output:=makecontrols(j,output,row,col,width,height,mlyform)
                           endif
                        endif
           j++
        enddo
output += 'END WINDOW '+CRLF+CRLF
cursorarrow()
****return
if cAs==1
   if .not. memoWrit ( PutFile ( { {'Form files *.fmg','*.fmg'} }  , 'Save Form As', ,.T. ) , Output )
      msgstop('Error writing Form','Information')
      return
   endif
else
   if .not. memowrit(myform:cForm,output)
      msgstop('Error writing '+myform:cForm,'Information')
      return
   endif
   myform:lfSave:=.T.
endif
close data
if file(myform:cfname+'.mnm')
   archivo:=myform:cfname+'.mnm'
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
      if signiv>level
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
                 /// cc:=myform:cfname+'.'+trim(named)+'.checked:=.T.'
                 /// output+= cc + CRLF
               endif
               if menues->enabled='X'
                  ///cc:=myform:cfname+'.'+trim(named)+'.enabled:=.F.'
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
Return
*-------------------------------------------------------------
function makecontrols(j,output,row,col,width,height,mlyform)
*-------------------------------------------------------------
                        if myform:actrltype[j]  == "BUTTON"
                                  Output += '@ '+ltrim(Str(Row)) +','+Alltrim(Str(Col))+' BUTTON '+myform:aname[j]+' ;'+CRLF
                                  if len(myform:acaption[j])>0
                                      Output += "CAPTION "+ "'"+myform:acaption[j] +"'"+ ' ; '+ CRLF
                                  else
                                      Output += "CAPTION "+"'"+myform:aname[j]+"'"+ " ; "+CRLF
                                  endif
                                   if len(myform:aPicture[j])>0
                                      Output += "PICTURE "+ "'"+myform:apicture[j] +"'"+ ' ; '+ CRLF
                                  endif
                                   if len(myform:aaction[j])>0
                                      Output += 'ACTION '+ myform:aaction[j] + ' ;'+ CRLF
                                   else
                                      Output += 'ACTION '+ 'MsgInfo("Button Pressed")'+' ;' + CRLF
                                   endif
                                   Output += 'WIDTH '+ Alltrim(Str(Width))+ ' ;'+CRLF
                                   Output += 'HEIGHT '+ Alltrim(Str(Height)) +' ; '+CRLF
                                  if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                  endif
                                  if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                  endif
                                  if len(myform:atooltip[j])>0
                                      Output += 'TOOLTIP '+"'"+ myform:atooltip[j]+"'" + ' ;'+ CRLF
                                  endif
                                  if myform:aflat[j]
                                      Output += 'FLAT '+ ' ;'+CRLF
                                   endif
                                   if len(myform:ajustify[j])>0 .and. len(myform:aPicture[j])>0 .and. len(myform:acaption[j])>0
                                        Output += myform:ajustify[j]+ ' ;'+CRLF
                                   endif
                                   if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                   endif
                                   if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                   endif
                                   if myform:anotabstop[j]
                                      Output += 'NOTABSTOP '+ ' ;'+CRLF
                                   endif
                                   if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                   endif

                                   Output += ' '+CRLF+CRLF
                        endif

			if myform:actrltype[j] == 'CHECKBOX'
                                Output += '@ '+ltrim(Str(Row)) +','+Alltrim(Str(Col))+' CHECKBOX '+myform:aname[j]+' ;'+CRLF

                                if len(myform:acaption[j])>0
   	 			   Output += 'CAPTION ' +"'"+myform:acaption[j]+"'" +' ;'+CRLF
                                else
   	 			   Output += 'CAPTION ' +" ' "+" ' " +' ;'+CRLF
                                endif
      				Output += 'WIDTH '+ Alltrim(Str(Width)) +' ;'+ CRLF
				Output += 'HEIGHT '+ Alltrim(Str(Height))+';'+CRLF
                                if myform:avaluel[j]
                                   Output += 'VALUE .T.' + ' ; '+CRLF
                                else
                                   Output += 'VALUE .F.' + ' ; '+CRLF
                                endif
                                if len(myform:afield[j])>0
                                   Output += 'FIELD '+myform:afield[j] + ' ; '+CRLF
                                endif

                                if len(myform:afontname[j])>0
                                   Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ; '+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                   Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ; '+CRLF
                                 endif
                                if len(myform:atooltip[j])>0
                                   Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif
                                if len(myform:aonchange[j])>0
                                   Output += 'ON CHANGE '+ myform:aonchange[j] + ' ; '+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                   Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ; '+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                   Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ; ' +CRLF
                                endif
                                if myform:atransparent[j]
                                   Output += 'TRANSPARENT '+ ' ; '+CRLF
                                endif
                                if myform:anotabstop[j]
                                   Output += 'NOTABSTOP '+ ' ; '+CRLF
                                endif

                                Output += ' '+CRLF+CRLF
				EndIf
			if myform:actrltype[j] == 'TREE'
                           Output += '*****@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' TREE '+ myform:aname[j] + '  '+CRLF
                           output+= 'DEFINE TREE '+myform:aname[j]+' ; '+CRLF
                           output+= 'AT '+ str(row,4) +' , '+ str(col,4)+'  ; '+CRLF 
                           Output += 'WIDTH  '+ Alltrim(Str(Width))  + ' ;'+CRLF
                           output += 'HEIGHT '+ Alltrim(Str(Height)) + ' ;'+ CRLF
                           if len(myform:afontname[j])>0
                               Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                           endif
                           if myform:afontsize[j]>0
                              Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                           endif
                           if len(myform:atooltip[j])>0
                               Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' '+ CRLF
                           endif
                           if len(myform:aonchange[j])>0
                              Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                           endif
                           if len(myform:aongotfocus[j])>0
                              Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                           endif
                           if len(myform:aonlostfocus[j])>0
                              Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                           endif
                           if len(myform:aondblclick[j])>0
                              Output += 'ON DBLCLICK '+ myform:aondblclick[j] + ' ;' +CRLF
                           endif
                           if len(myform:anodeimages[j])>0
                              Output += 'NODEIMAGES '+ myform:anodeimages[j] + ' ;' +CRLF
                           endif
                           if len(myform:aitemimages[j])>0
                              Output += 'ITEMIMAGES '+ myform:aitemimages[j] + ' ;' +CRLF
                           endif
                           if myform:anorootbutton[j]
                              Output += 'NOROOTBUTTON '+ ' ;' +CRLF
                           endif
                           if myform:aitemids[j]
                              Output += 'ITEMIDS '+  ' ;' +CRLF
                           endif
                           if myform:ahelpid[j]>0
                              Output += 'HELPID ' + str(myform:ahelpid[j],3) +  ' ;' +CRLF
                           endif

                           output+=CRLF
                           output+="END TREE" +CRLF+CRLF
                        endif

			if myform:actrltype[j] == 'LIST'
 				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' LISTBOX '+ myform:aname[j] + ' ; '+CRLF
                                Output += 'WIDTH  '+ Alltrim(Str(Width))  + ' ;'+CRLF
                                output += 'HEIGHT '+ Alltrim(Str(Height)) + ' ;'+ CRLF
                                if len(myform:aitems[j])>0
                                      Output += "ITEMS  "+ myform:aitems[j] + "  ;" +CRLF
                                endif

                                if myform:avaluen[j]>0
                                      Output += 'VALUE '+ str(myform:avaluen[j]) + ' ;' +CRLF
                                endif

                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                endif

                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif
                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif

                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif

                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if len(myform:aondblclick[j])>0
                                      Output += 'ON DBLCLICK '+ myform:aondblclick[j] + ' ;' +CRLF
                                endif

                                if myform:amultiselect[j]
                                      Output += 'MULTISELECT ' + ' ;' +CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID ' + str(myform:ahelpid[j],3) +  ' ;' +CRLF
                                endif
                                if myform:abreak[j]
                                      Output += 'BREAK ' + ' ;' +CRLF
                                endif
                                if myform:anotabstop[j]
                                   Output += 'NOTABSTOP '+ ' ;'+CRLF
                                endif
                                if myform:asort[j]
                                   Output += 'SORT '+ ' ;'+CRLF
                                endif

                                Output += ' '+CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'COMBO'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' COMBOBOX '+ myform:aname[j] + ' ; '+CRLF

                                if len(myform:aitems[j])>0
                                      Output += "ITEMS  "+ myform:aitems[j] + "  ;" +CRLF
                                endif
                                if len(myform:aitemsource[j])>0
                                      Output += "ITEMSOURCE "+ myform:aitemsource[j] + "  ;" +CRLF
                                endif
                                if myform:avaluen[j]>0
                                      Output += 'VALUE '+ str(myform:avaluen[j]) + ' ;' +CRLF
                                endif
                                if len(myform:avaluesource[j])>0
                                      Output += "VALUESOURCE "+ myform:avaluesource[j] + "  ;" +CRLF
                                endif
                                if myform:adisplayedit[j]
                                   Output += 'DISPLAYEDIT '+ ' ;'+CRLF
                                endif
                                Output += 'WIDTH  '+ Alltrim(Str(Width))  + ' ;'+CRLF
////                                output += 'HEIGHT '+ Alltrim(Str(Height)) + ' ;'+ CRLF
                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif

                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                endif

                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif

                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if len(myform:aonenter[j])>0
                                      Output += 'ON ENTER '+ myform:aonenter[j] + ' ;'+CRLF
                                endif
                                if len(myform:aondisplaychange[j])>0
                                      Output += 'ON DISPLAYCHANGE '+ myform:aondisplaychange[j] + ' ;'+CRLF
                                endif
                                if myform:anotabstop[j]
                                   Output += 'NOTABSTOP '+ ' ;'+CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                if myform:abreak[j]
                                   Output += 'BREAK '+ ' ;'+CRLF
                                endif
                                if myform:asort[j]
                                   Output += 'SORT '+ ' ;'+CRLF
                                endif

                                Output += CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'CHECKBTN'
                                Output += '@ '+ltrim(Str(Row)) +','+Alltrim(Str(Col))+' CHECKBUTTON '+myform:aname[j]+' ;'+CRLF
                                if len(myform:acaption[j])>0
   	 				Output += 'CAPTION ' +"'"+myform:acaption[j]+"'" +' ;'+CRLF
                                else
   	 				Output += 'CAPTION ' +"'"+myform:aname[j]+"'" +' ;'+CRLF
                                endif
      				Output += 'WIDTH '+ Alltrim(Str(Width)) +' ;'+ CRLF
				Output += 'HEIGHT '+ Alltrim(Str(Height))+';'+CRLF
                                if myform:avaluel[j]
                                   Output += 'VALUE .T.' + ' ; '+CRLF
                                else
                                   Output += 'VALUE .F.' + ' ; '+CRLF
                                endif

                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                 endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif
                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                if myform:anotabstop[j]
                                   Output += 'NOTABSTOP '+ ' ; '+CRLF
                                endif
                                Output += ' '+CRLF+CRLF

			EndIf
			if myform:actrltype[j] == 'GRID'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' GRID '+ myform:aname[j] + ' ;'+CRLF
                                OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ;'+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF

                                OUTPUT += 'HEADERS '+myform:aheaders[j] + ' ; '+CRLF
                                OUTPUT += 'WIDTHS  '+myform:awidths[j]  + ' ; '+CRLF
                                if len(myform:aitems[j])>0
                                   OUTPUT += 'ITEMS  '+myform:aitems[j]   + ' ; '+CRLF
                                endif
                                if len(myform:avalue[j])>0
                                    OUTPUT += ' VALUE  ' + myform:avalue[j]+' ; '+ CRLF
                                endif
                                if len(myform:adynamicbackcolor[j])>0
                                      Output += 'DYNAMICBACKCOLOR '+ myform:adynamicbackcolor[j] + ' ;' +CRLF
                                endif
                                if len(myform:adynamicforecolor[j])>0
                                      Output += 'DYNAMICFORECOLOR '+ myform:adynamicforecolor[j] + ' ;' +CRLF
                                endif
                                if len(myform:acolumncontrols[j])>0
                                      Output += 'COLUMNCONTROLS '+ myform:acolumncontrols[j] + ' ;' +CRLF
                                endif
                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                 endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif
                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if len(myform:aondblclick[j])>0
                                      Output += 'ON DBLCLICK '+ myform:aondblclick[j] + ' ;' +CRLF
                                endif
                                if len(myform:aonheadclick[j])>0
                                      Output += 'ON HEADCLICK '+ myform:aonheadclick[j] + ' ;' +CRLF
                                endif
                                if len(myform:aoneditcell[j])>0
                                      Output += 'ON EDITCELL '+ myform:aoneditcell[j] + ' ;' +CRLF
                                endif
                                if myform:amultiselect[j]
                                   Output += 'MULTISELECT' + ' ;' +CRLF
                                endif
                                if myform:anolines[j]
                                   Output += 'NOLINES' + ' ;' +CRLF
                                endif
                                if myform:ainplace[j]
                                   Output += 'INPLACE' + ' ;' +CRLF
                                endif
                                if myform:aedit[j]
                                   Output += 'EDIT' + ' ;' +CRLF
                                endif
                                if len(myform:aimage[j])>0
                                      Output += 'IMAGE '+ myform:aimage[j] + ' ;' +CRLF
                                endif
                                if len(myform:ajustify[j])>0
                                      Output += 'JUSTIFY '+ (myform:ajustify[j]) + ' ;' +CRLF
                                endif
                                if len(myform:awhen[j])>0
                                      Output += 'WHEN '+ myform:awhen[j] + ' ;' +CRLF
                                endif

                                if len(myform:avalid[j])>0
                                      Output += 'VALID '+ myform:avalid[j] + ' ;' +CRLF
                                endif
                                if len(myform:avalidmess[j])>0
                                      Output += 'VALIDMESSAGES '+ myform:avalidmess[j] + ' ;' +CRLF
                                endif
                                if len(myform:areadonlyb[j])>0
                                   Output += 'READONLY ' +myform:areadonlyb[j]+ ' ;' +CRLF                                  
                                endif
                                if len(myform:ainputmask[j])>0
                                      Output += "INPUTMASK "+ myform:ainputmask[j]+  ' ;'+ CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                if myform:abreak[j]
                                   Output += 'BREAK' + ' ;' +CRLF                                  
                                endif
                                  
                                Output += CRLF+CRLF
			EndIf
                        if myform:actrltype[j] == 'BROWSE'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' BROWSE '+ myform:aname[j] + ' ;'+CRLF
                                OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ;'+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                                if len(myform:aheaders[j])>0
                                   OUTPUT += 'HEADERS '+myform:aheaders[j] + ' ; '+CRLF
                                else
                                   OUTPUT += 'HEADERS '+"{'',''} "+' ; '+CRLF
                                endif
                                if len(myform:awidths[j])>0
                                   OUTPUT += 'WIDTHS  '+myform:awidths[j]  + ' ; '+CRLF
                                else
                                   output += 'WIDTHS '+"{90,60}"+' ; '+CRLF
                                endif
                                OUTPUT += 'WORKAREA '+myform:aworkarea[j]+' ; '+CRLF
                                if len(myform:afields[j])>0
                                   OUTPUT += 'FIELDS  '+myform:afields[j]   + ' ; '+CRLF
                                else
                                   OUTPUT += 'FIELDS  '+"{'field1','field2'}"  + ' ; '+CRLF
                                endif
                                if myform:avaluen[j]>0
                                    OUTPUT += 'VALUE  ' + str(myform:avaluen[j])+' ; '+ CRLF
                                endif
                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                 endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif
                                if len(myform:ainputmask[j])>0
                                      Output += "INPUTMASK "+ myform:ainputmask[j]+  ' ;'+ CRLF
                                endif
                                if len(myform:adynamicbackcolor[j])>0
                                      Output += 'DYNAMICBACKCOLOR '+ myform:adynamicbackcolor[j] + ' ;' +CRLF
                                endif
                                if len(myform:adynamicforecolor[j])>0
                                      Output += 'DYNAMICFORECOLOR '+ myform:adynamicforecolor[j] + ' ;' +CRLF
                                endif

                                if len(myform:acolumncontrols[j])>0
                                      Output += 'COLUMNCONTROLS '+ myform:acolumncontrols[j] + ' ;' +CRLF
                                endif

                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if len(myform:aondblclick[j])>0
                                     Output += 'ON DBLCLICK '+ myform:aondblclick[j] + ' ;' +CRLF
                                endif
                                if len(myform:aonheadclick[j])>0
                                      Output += 'ON HEADCLICK '+ myform:aonheadclick[j] + ' ;' +CRLF
                                endif

                                if len(myform:aoneditcell[j])>0
                                      Output += 'ON EDITCELL '+ myform:aoneditcell[j] + ' ;' +CRLF
                                endif
                                if len(myform:aonappend[j])>0
                                      Output += 'ON APPEND '+ myform:aonappend[j] + ' ;' +CRLF
                                endif
                                if len(myform:awhen[j])>0
                                      Output += 'WHEN '+ myform:awhen[j] + ' ;' +CRLF
                                endif

                                if len(myform:avalid[j])>0
                                      Output += 'VALID '+ myform:avalid[j] + ' ;' +CRLF
                                endif
                                if len(myform:avalidmess[j])>0
                                      Output += 'VALIDMESSAGES '+ myform:avalidmess[j] + ' ;' +CRLF
                                endif
                                if len(myform:areadonlyb[j])>0
                                   Output += 'READONLY ' +myform:areadonlyb[j]+ ' ;' +CRLF
                                endif
                                if myform:alock[j]
                                   Output += 'LOCK' + ' ;' +CRLF
                                endif
                                if myform:adelete[j]
                                   Output += 'DELETE' + ' ;' +CRLF
                                endif
                                  if myform:ainplace[j]
                                   Output += 'INPLACE' + ' ;' +CRLF
                                endif
                                  if myform:aedit[j]
                                   Output += 'EDIT' + ' ;' +CRLF
                                endif

                                if myform:anolines[j]
                                   Output += 'NOLINES' + ' ;' +CRLF
                                endif
                                if len(myform:aimage[j])>0
                                      Output += 'IMAGE '+ myform:aimage[j] + ' ;' +CRLF
                                endif
                                if len(myform:ajustify[j])>0
                                      Output += 'JUSTIFY '+ (myform:ajustify[j]) + ' ;' +CRLF
                                endif
                                if len(myform:aonenter[j])>0
                                     Output += 'ON ENTER '+ myform:aonenter[j] + ' ;' +CRLF
                                endif

                                 if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                if myform:aappend[j]
                                   Output += 'APPEND' + ' ;' +CRLF
                                endif

                                Output += CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'IMAGE'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' IMAGE '+ myform:aname[j] + ' ; '+CRLF
                                if len(myform:aaction[j])>0
                                    Output += 'ACTION '+ myform:aaction[j] + ' ;'+ CRLF
                                endif
                                if len(myform:apicture[j])>0
                                    Output += 'PICTURE '+ '"'+myform:apicture[j] + '" ;'+ CRLF
                                   else
                                    Output += 'PICTURE "demo.bmp"' +' ; '+ CRLF
                                endif
                                ****
                                OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ;'+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF

                                if myform:astretch[j]
                                   OUTPUT += 'STRETCH '+ ' ; '+CRLF
                                else
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif

                                OUTPUT += CRLF+CRLF

			EndIf
			if myform:actrltype[j] == 'TIMER'
                                Output += '*****@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' TIMER '+ myform:aname[j] + '  '+CRLF
				Output += 'DEFINE TIMER '+ myform:aname[j] + ' ; '+CRLF
                                if myform:avaluen[j]>999
                                    Output += 'INTERVAL '+ str(myform:avaluen[j],7) + ' ; '+  CRLF
                                   else
                                     Output += 'INTERVAL '+ str(1000,5) + ' ; '+  CRLF
                                endif
                                if len(myform:aaction[j])>0
                                    Output += 'ACTION '+ myform:aaction[j] + ' ;'+ CRLF
                                else
                                     Output += 'ACTION '+ ' _dummy() ' + ' ;'+ CRLF
                                endif
                                output +=  ' &&&& ROW ' + Alltrim(Str(Row)) + ' ; '+CRLF
                                output +=  ' &&&& COL ' + Alltrim(Str(Col)) + ' ; '+CRLF                            
                                OUTPUT += CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'ANIMATE'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' ANIMATEBOX '+ myform:aname[j]  + ' ; '+CRLF
                                OUTPUT += ' WIDTH '+ Alltrim(Str(Width))  +' ; '+CRLF
                                Output += ' HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF 
                                if len(myform:afile[j])>0
                                    Output += 'FILE '+ '"'+myform:afile[j] + '" ;'+ CRLF
                                endif
                                if myform:aautoplay[j]
                                      Output += 'AUTOPLAY ' + ' ;' +CRLF
                                endif
                                if myform:acenter[j]
                                      Output += 'CENTER ' + ' ;' +CRLF
                                endif
                                if myform:atransparent[j]
                                      Output += 'TRANSPARENT ' + ' ;' +CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                output += CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'DATEPICKER'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' DATEPICKER '+ myform:aname[j]  + ' ; '+CRLF
                                if len(myform:avalue[j])>0
                                    Output += "VALUE "+ myform:avalue[j] + "  ;"+ CRLF
                                endif
                                if len(myform:afield[j])>0
                                    Output += 'FIELD '+ myform:afield[j] + ' ;'+ CRLF
                                endif
                                OUTPUT += ' WIDTH '+ Alltrim(Str(Width))  +' ; '+CRLF
                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                 endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:ashownone[j]
                                      Output += 'SHOWNONE ' + ' ;' +CRLF
                                endif
                                if myform:aupdown[j]
                                      Output += 'UPDOWN ' + ' ;' +CRLF
                                endif

                                if myform:arightalign[j]
                                      Output += 'RIGHTALIGN ' + ' ;' +CRLF
                                endif
                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if len(myform:aonenter[j])>0
                                      Output += 'ON ENTER '+ myform:aonenter[j] + ' ;'+CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                OUTPUT += CRLF+CRLF

			EndIf
			if myform:actrltype[j] == 'TEXT'
                                cFontname  :=myform:afontname[j]
                                nFontsize  :=myform:afontsize[j]
                                ctooltip   :=myform:atooltip[j]
                                nmaxlength:= myform:amaxlength[j]
                                luppercase:=myform:auppercase[j]
                                llowercase:=myform:alowercase[j]
                                lrightalign:=myform:arightalign[j]
                                lpassword:=myform:apassword[j]
                                lnumeric:=myform:anumeric[j]
                                cinputmask:=myform:ainputmask[j]
                                cformat:=myform:afields[j]
                                conenter:=myform:aonenter[j]
                                conchange:=myform:aonchange[j]
                                congotfocus:=myform:aongotfocus[j]
                                conlostfocus:=myform:aonlostfocus[j]
                                nFocusedPos:=myform:afocusedpos[j] // pb
                                cvalid:=myform:avalid[j]
                                cwhen:=myform:awhen[j]

                                if len(myform:atooltip[j]) > 0
                                   ctooltip:= "TOOLTIP '"+myform:atooltip[j]+ "'"+ ' ; ' +CRLF
                                else
                                   ctooltip:=''
                                endif

                                if myform:adate[j]
                                   cdate:='DATE'+ ' ; '+CRLF
                                else
                                   cdate:=''
                                endif

                                if myform:amaxlength[j] > 0
                                   cmaxlength:= 'MAXLENGTH '+str(myform:amaxlength[j]) + ' ; '+CRLF
                                else
                                   cmaxlength:=''
                                endif

                                if myform:auppercase[j]
                                   cuppercase:= 'UPPERCASE ; '+CRLF
                                else
                                   cuppercase:=''
                                endif

                                if myform:alowercase[j]
                                   clowercase:= 'LOWERCASE ;'+CRLF
                                else
                                   clowercase:=''
                                endif

                                if myform:arightalign[j]
                                   crightalign:= 'RIGHTALIGN ; '+CRLF
                                else
                                   crightalign:=''
                                endif

                                cnumeric:=''
                                if myform:anumeric[j]
                                   cnumeric:= 'NUMERIC ; '+CRLF
                                   if len(myform:ainputmask[j])>0
                                      cnumeric = cnumeric + 'INPUTMASK '+"'"+myform:ainputmask[j] +"'"+' ;' +CRLF
                                   endif
                                else
                                   if len(myform:ainputmask[j])>0
                                      cnumeric = 'INPUTMASK '+"'"+myform:ainputmask[j] +"'"+' ;' +CRLF
                                   endif
                                endif

                                if len(myform:afields[j])>0
                                   cformat =  'FORMAT '+"'"+myform:afields[j] +"'"+' ;' +CRLF
                                else
                                   cformat = ""
                                endif

                                if myform:apassword[j]
                                   cpassword:= 'PASSWORD ; '+CRLF
                                else
                                   cpassword:=''
                                endif

                                // pb
                                // si tiene el valor -2 que es el valor x defecto, no es necesario agregar esta propiedad

                                cFocusedPos:= ''
                                if myform:afocusedpos[j] <> -2
                                   cFocusedPos:= 'FOCUSEDPOS '+str(myform:afocusedpos[j]) + ' ; '+CRLF
                                endif
                                if len(myform:avalid[j])>0
                                   cvalid:= 'VALID '+myform:avalid[j]+ ' ; '+CRLF
                                endif

                                if len(myform:awhen[j])>0
                                   cwhen:= 'WHEN '+myform:awhen[j]+ ' ; '+CRLF
                                endif

                                if len(myform:aongotfocus[j])>0
                                   congotfocus:= 'ON GOTFOCUS '+myform:aongotfocus[j]+ ' ; '+CRLF
                                else
                                   congotfocus:=''
                                endif
                                if len(myform:aonlostfocus[j])>0
                                   conlostfocus:= 'ON LOSTFOCUS '+myform:aonlostfocus[j]+ ' ; '+CRLF
                                else
                                   conlostfocus:=''
                                endif

                                if len(myform:aonchange[j])>0
                                   conchange:= 'ON CHANGE '+myform:aonchange[j]+ ' ; '+CRLF
                                else
                                   conchange:=''
                                endif

                                if len(myform:aonenter[j])>0
                                   conenter:= 'ON ENTER '+myform:aonenter[j]+' ; '+CRLF
                                else
                                   conenter:=''
                                endif
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' TEXTBOX '+ myform:aname[j] + ' ; '+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                                if len(myform:afield[j])>0
                                   Output+= 'FIELD '+myform:afield[j]+ ' ; '+CRLF
                                endif
                                cValue :=myform:avalue[j]
                                if cValue == NIL
                                   cvalue=""
                                endif
                                if len(cValue) > 0
                                   if myform:anumeric[j]
                                      Output += 'VALUE ' +cValue + ' ; ' +CRLF
                                   else
                                      if myform:adate[j]
                                         Output += 'VALUE ' +cValue + ' ; ' +CRLF
                                      else
                                         Output += 'VALUE ' +"'"+cValue +"'"+ ' ; ' +CRLF
                                      endif
                                   endif

                                endif
                                if myform:areadonly[j]
                                   Output+= 'READONLY '+ ' ; '+CRLF
                                endif
                                OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ; '+CRLF
                                OUTPUT +=  cpassword

                                if len(myform:aFontname[j]) > 0
                                   Output += 'Font '+ "'"+myform:aFontname[j]+"'" + ' ; '+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                   Output += 'size '+ str(myform:afontsize[j]) + ' ; '+CRLF
                                endif

                               OUTPUT +=  cTooltip
                                OUTPUT +=  cnumeric

                                OUTPUT +=  cformat

                                OUTPUT +=  cdate
                                OUTPUT +=  cMaxlength
                                OUTPUT += cUppercase

                                OUTPUT += congotfocus
                                OUTPUT += conlostfocus
                                OUTPUT += conchange
                                OUTPUT += conenter
                                OUTPUT += crightalign

                                if myform:anotabstop[j]
                                   output+= ' NOTABSTOP '+ ' ; '+CRLF
                                endif

                                output += cFocusedPos   // pb

                                output += cvalid
                                output += cwhen

                                OUTPUT += CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'EDIT'
       				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' EDITBOX '+ myform:aName[j]  + ' ; '+CRLF
                                OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ; '+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                                if len(myform:afield[j])>0
                                   output += 'FIELD '+myform:afield[j]+' ; '+CRLF
                                endif
                                if len(myform:avalue[j]) > 0
                                   Output += 'VALUE ' +"'"+myform:avalue[j] +"'"+ ' ; ' +CRLF
                                endif
                                if myform:areadonly[j]
                                   Output += 'READONLY '+' ; '+CRLF
                                endif

                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif

                                if myform:amaxlength[j] > 0
                                   Output += 'MAXLENGTH '+str(myform:amaxlength[j]) + ' ; '+CRLF
                                endif
                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                if myform:abreak[j]
                                   Output += 'BREAK '+' ; '+CRLF
                                endif
                                if myform:anotabstop[j]
                                   Output += 'NOTABSTOP '+' ; '+CRLF
                                endif
                                if myform:anovscroll[j]
                                   Output += 'NOVSCROLL '+' ; '+CRLF
                                endif
                                if myform:anohscroll[j]
                                   Output += 'NOHSCROLL '+' ; '+CRLF
                                endif

				Output += CRLF+CRLF
			EndIf
                        if myform:actrltype[j] == 'RICHEDIT'
      				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' RICHEDITBOX '+ myform:aName[j]  + ' ; '+CRLF
                                OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ; '+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                                if len(myform:afield[j])>0
                                   output += 'FIELD '+myform:afield[j]+' ; '+CRLF
                                endif
                                if len(myform:avalue[j]) > 0
                                   Output += 'VALUE ' +"'"+myform:avalue[j] +"'"+ ' ; ' +CRLF
                                endif
                                if myform:areadonly[j]
                                   Output += 'READONLY '+' ; '+CRLF
                                endif

                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif

                                if myform:amaxlength[j] > 0
                                   Output += 'MAXLENGTH '+str(myform:amaxlength[j]) + ' ; '+CRLF
                                endif
                                if myform:abreak[j]
                                   Output += 'BREAK '+' ; '+CRLF
                                endif
                                if myform:anotabstop[j]
                                   Output += 'NOTABSTOP '+' ; '+CRLF
                                endif

                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif

				Output += CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'IPADDRESS'

       				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' IPADDRESS '+ myform:aname[j]  + ' ; '+CRLF
                                OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ; '+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                                if len(myform:avalue[j]) > 0
****                                   strtran(myform:avalue[j],'.',',')
                                   Output += 'VALUE ' +myform:avalue[j] + ' ; ' +CRLF
                                endif
                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif

                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                if myform:anotabstop[j]
                                   Output += 'NOTABSTOP '+' ; '+CRLF
                                endif
				Output += CRLF+CRLF
			EndIf
                        if myform:actrltype[j] == 'HYPERLINK'
       				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' HYPERLINK '+ myform:aname[j]  + ' ; '+CRLF
                                OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ; '+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                                if len(myform:avalue[j]) > 0
                                   Output += 'VALUE ' +"'"+myform:avalue[j] + "'"+' ; ' +CRLF
                                else
                                   Output += 'VALUE ' +" 'ooHG IDE+ Home ' " + ' ; ' +CRLF
                                endif
                                if len(myform:aaddress[j]) > 0
                                   Output += 'ADDRESS ' +"'"+myform:aaddress[j] +"'"+ ' ; ' +CRLF
                                else
                                   Output += 'ADDRESS ' +"'http://sistemascvc.tripod.com'" + ' ; ' +CRLF
                                endif
                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif

                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                if myform:ahandcursor[j]
                                   Output += 'HANDCURSOR '+' ; '+CRLF
                                endif
				Output += CRLF+CRLF
			EndIf

                        if myform:actrltype[j] == 'MONTHCALENDAR'
       				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' MONTHCALENDAR '+ myform:aname[j]  + ' ; '+CRLF
                                if len(myform:avalue[j]) > 0
                                   Output += 'VALUE ' +myform:avalue[j] + ' ; ' +CRLF
                                endif
                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                endif
                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif

                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif

                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                endif
                                if myform:anotabstop[j]
                                   Output += 'NOTABSTOP '+' ; '+CRLF
                                endif
				Output += CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'LABEL'

  				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' LABEL '+ myform:aname[j]  + ' ; '+CRLF


                                if myform:aautoplay[j]
                                   Output += 'AUTOSIZE ;'+ CRLF
                                else
                                   OUTPUT += 'WIDTH '+Alltrim(Str(Width))+ ' ; '+CRLF
                                   OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                                ENDIF
                                if len(myform:aValue[j]) > 0
                                   Output += 'VALUE ' +"'"+myform:avalue[j]+"'"  + ' ; ' + CRLF
                                endif
                                if len(myform:aaction[j])>0
                                   Output += 'ACTION ' +myform:aaction[j]+ ' ; ' + CRLF
                                endif
                                if len(myform:aFontname[j]) > 0
                                   Output += 'FONT '+ "'"+myform:afontname[j]+"'" + ' ; '+CRLF
                                endif
                                if myform:afontsize[j]>0
                                   Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+ CRLF      // MigSoft
                                endif
                                if len(myform:abackcolor[j]) > 0 .and. myform:abackcolor[j]#'NIL'
                                   Output += 'BACKCOLOR '+ myform:abackcolor[j]+ ' ; '+CRLF
                                endif
                                *if len(afontcolor[j]) > 0
                                *   Output += 'FONTCOLOR '+ "'"+afontcolor[j]+"'" + ' ; '+CRLF
                                *endif
                                if myform:abold[j]
                                   Output += 'BOLD ;'+ CRLF
                                ENDIF
                                if myform:ahelpid[j]>0
                                  output += 'HELPID '+str(myform:ahelpid[j],3)+' ; '+CRLF
                                endif
                                if myform:atransparent[j]
                                   Output += 'TRANSPARENT '+ ' ;'+CRLF
                                endif
                                if myform:acenteralign[j]
                                   Output += 'CENTERALIGN '+ ' ;'+CRLF
                                endif
                                if myform:arightalign[j]
                                   Output += 'RIGHTALIGN '+ ' ;'+CRLF
                                endif
                                if myform:aclientedge[j]
                                   Output += 'CLIENTEDGE '+ ' ;'+CRLF
                                endif
                                Output  +=  CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'PLAYER'
				Output  +=  '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' PLAYER '+ myform:aname[j]  + ' ; '+CRLF
                                OUTPUT  +=  'WIDTH '+ Alltrim(Str(Width))+ ' ; '+CRLF
                                OUTPUT  +=  'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                                OUTPUT  +=  'FILE "'+myform:afile[j]+'"'+  ' ; '+CRLF
                                if myform:ahelpid[j]>0
                                  output += 'HELPID '+str(ahelpid[j],3)+' ; '+CRLF
                                endif
                                OUTPUT  +=  CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'PROGRESSBAR'
 				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' PROGRESSBAR '+ myform:aname[j]  + ' ; '+CRLF
                               if len(myform:arange[j])>0
                                  output += 'RANGE '+myform:arange[j]+' ; '+CRLF
                               endif

                               OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ; '+CRLF
                               OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                               if len(myform:atooltip[j])>0
                                  output += 'TOOLTIP '+"'"+myform:atooltip[j]+"'"+' ; '+CRLF
                               endif
                               if myform:avertical[j]
                                  output += 'VERTICAL '+' ; '+CRLF
                               endif
                               if myform:asmooth[j]
                                  output += 'SMOOTH '+' ; '+CRLF
                               endif
                               if myform:ahelpid[j]>0
                                  output += 'HELPID '+str(myform:ahelpid[j],3)+' ; '+CRLF
                               endif
                               OUTPUT += CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'RADIOGROUP'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' RADIOGROUP '+ myform:aname[j]  + ' ; '+CRLF
                                if len(myform:aitems[j])>0
                                      Output += "OPTIONS  "+ myform:aitems[j] + "  ;" +CRLF
                                endif

                                if myform:avaluen[j]>0
                                      Output += 'VALUE '+ str(myform:avaluen[j]) + ' ;' +CRLF
                                endif
                                Output += 'WIDTH  '+ Alltrim(Str(Width))  + ' ;'+CRLF
                                if myform:aspacing[j]>0
                                      Output += "SPACING "+ +str(myform:aspacing[j],3)+  ' ;'+ CRLF
                                endif
                                if len(myform:afontname[j])>0
                                      Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:afontsize[j]>0
                                      Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                                endif

                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif
                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if myform:atransparent[j]
                                   Output += 'TRANSPARENT '+ ' ;'+CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID ' + str(myform:ahelpid[j],3) +  ' ;' +CRLF
                                endif
                                Output  +=  CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'SLIDER'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' SLIDER '+ myform:aname[j] +' ; '+CRLF
                               if len(myform:arange[j])>0
                                  output += 'RANGE '+myform:arange[j]+' ; '+CRLF
                               else
                                  output += 'RANGE 1,100'+' ; '+CRLF
                               endif

                               if myform:avaluen[j]>0
                                  output += 'VALUE '+str(myform:avaluen[j],4)+' ; '+CRLF
                               endif

                               OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ; '+CRLF
                               OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                               if len(myform:atooltip[j])>0
                                  output += 'TOOLTIP '+"'"+myform:atooltip[j]+"'"+' ; '+CRLF
                               endif
                               if len(myform:aonchange[j])>0
                                  Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                               endif
                               if myform:avertical[j]
                                  output += ' VERTICAL '+' ; '+CRLF
                               endif
                              if myform:anoticks[j]
                                  output += 'NOTICKS '+' ; '+CRLF
                               endif
                              if myform:aboth[j]
                                  output += 'BOTH '+' ; '+CRLF
                               endif
                              if myform:atop[j]
                                  output += 'TOP '+' ; '+CRLF
                               endif

                              if myform:aleft[j]
                                  output += 'LEFT '+' ; '+CRLF
                              endif

                              if myform:ahelpid[j]>0
                                 output += 'HELPID '+str(myform:ahelpid[j],3)+' ; '+CRLF
                              endif
                              Output  +=  CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'SPINNER'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' SPINNER '+ myform:aname[j]  + ' ; '+CRLF
                               if len(myform:arange[j])>0
                                  output += 'RANGE '+myform:arange[j]+' ; '+CRLF
                               endif

                               if myform:avaluen[j]>0
                                  output += 'VALUE '+str(myform:avaluen[j],4)+' ; '+CRLF
                               endif

                               OUTPUT += 'WIDTH '+ Alltrim(Str(Width)) + ' ; '+CRLF
                               OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+CRLF
                               if len(myform:afontname[j])>0
                                     Output += "FONT "+ "'"+myform:afontname[j]+"'"+  ' ;'+ CRLF
                               endif
                               if myform:afontsize[j]>0
                                     Output += 'SIZE '+ str(myform:afontsize[j],2) + ' ;'+CRLF
                               endif
                               if len(myform:atooltip[j])>0
                                     Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                               endif
                               if len(myform:aonchange[j])>0
                                  Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                               endif
                               if len(myform:aongotfocus[j])>0
                                  Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                               endif
                               if len(myform:aonlostfocus[j])>0
                                  Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                               endif
                               if myform:ahelpid[j]>0
                                  output += 'HELPID '+str(myform:ahelpid[j],3)+' ; '+CRLF
                               endif
                               if myform:anotabstop[j]
                                  output += 'NOTABSTOP '+' ; '+CRLF
                               endif
                               if myform:awrap[j]
                                  output += 'WRAP '+' ; '+CRLF
                               endif
                               if myform:areadonly[j]
                                  output += 'READONLY '+' ; '+CRLF
                               endif
                               if myform:aincrement[j]>0
                                  output += 'INCREMENT '+str(myform:aincrement[j],6)+' ; '+CRLF
                               endif
                               Output  +=  CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'PICCHECKBUTT'
                               Output += '@ '+ltrim(Str(Row)) +','+Alltrim(Str(Col))+' CHECKBUTTON '+myform:aname[j]+' ;'+CRLF
                                if len(myform:apicture[j])>0
   	 				Output += 'PICTURE ' +"'"+myform:apicture[j]+"'" +' ;'+CRLF
                                else
   	 				Output += 'PICTURE ' +"'"+""+"'" +' ;'+CRLF
                                endif
      				Output += 'WIDTH '+ Alltrim(Str(Width)) +' ;'+ CRLF
				Output += 'HEIGHT '+ Alltrim(Str(Height))+';'+CRLF
                                if myform:avaluel[j]
                                   Output += 'VALUE .T.' + ' ; '+CRLF
                                else
                                   Output += 'VALUE .F.' + ' ; '+CRLF
                                endif

                                if len(myform:atooltip[j])>0
                                      Output += "TOOLTIP "+ "'"+myform:atooltip[j]+"'"+  ' ;'+ CRLF
                                endif
                                if myform:anotabstop[j]
                                   output += 'NOTABSTOP '+' ; '+CRLF
                                endif
                                if len(myform:aonchange[j])>0
                                      Output += 'ON CHANGE '+ myform:aonchange[j] + ' ;'+CRLF
                                endif
                                if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                endif
                                if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                endif
                                if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                 endif
                                Output  +=  +CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'PICBUTT'
   				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' BUTTON '+ myform:aname[j]  + ' ; '+ CRLF
                                  if len(myform:apicture[j])>0
                                      Output += "PICTURE "+ "'"+myform:apicture[j] +"'"+ ';'+ CRLF
                                  else
                                      Output += "PICTURE "+"'"+""+"'"+ " ; "+CRLF
                                  endif
                                  if len(myform:aaction[j])>0
                                     Output += 'ACTION '+ myform:aaction[j] + ' ;'+ CRLF
                                  else
                                     Output += 'ACTION '+ 'MsgInfo("Button Pressed")' + CRLF
                                  endif
                                  Output += 'WIDTH '+ Alltrim(Str(Width))+ ' ;'+CRLF
                                  Output += 'HEIGHT '+ Alltrim(Str(Height)) +' ; '+CRLF

                                  if len(myform:atooltip[j])>0
                                      Output += 'TOOLTIP '+"'"+ myform:atooltip[j]+"'" + ' ;'+ CRLF
                                  endif

                                  if myform:aflat[j]
                                      Output += 'FLAT '+ ' ;'+CRLF
                                   endif

                                   if len(myform:aongotfocus[j])>0
                                      Output += 'ON GOTFOCUS '+ myform:aongotfocus[j] + ' ;'+CRLF
                                   endif
                                   if len(myform:aonlostfocus[j])>0
                                      Output += 'ON LOSTFOCUS '+ myform:aonlostfocus[j] + ' ;' +CRLF
                                   endif
                                  if myform:anotabstop[j]
                                     Output += 'NOTABSTOP '+ ' ;'+CRLF
                                  endif
                                  if myform:ahelpid[j]>0
                                      Output += 'HELPID '+ str(myform:ahelpid[j],3) + ' ;'+CRLF
                                  endif
                                  Output  +=  +CRLF+CRLF
			EndIf
			if myform:actrltype[j] == 'FRAME'
				Output += '@ ' + Alltrim(Str(Row)) + ',' + Alltrim(Str(Col)) + ' FRAME '+ myform:aname[j]  +' ; '+CRLF
                                OUTPUT += 'CAPTION ' + '"' + myform:acaption[j] + '"' +' ; '+ CRLF
                                OUTPUT += 'WIDTH ' + Alltrim(Str(Width)) +' ; '+CRLF
                                OUTPUT += 'HEIGHT '+ Alltrim(Str(Height)) + ' ; '+ CRLF
                                if myform:aopaque[j]
                                  output += 'OPAQUE '+' ; '+CRLF
                                endif
                                if myform:atransparent[j]
                                   Output += 'TRANSPARENT '+ ' ;'+CRLF
                                endif
				Output += CRLF+CRLF
			EndIf
                        if myform:aname[j] # NIL
                           name:=myform:aname[j]
                        endif
                        if UPPER(myform:actrltype[j])$'MONTHCALENDAR HYPLINK IPADDRESS TEXT CHECKBOX BUTTON CHECKBTN COMBO DATEPICKER EDIT FRAME GRID IMAGE LABEL LIST PLAYER PROGRESSBAR RADIOGROUP SLIDER SPINNER ANIMATE BROWSE TAB RICHEDIT TIMER PICBUTT PICCHECKBUTT' .and. j>1
                           output+= CRLF
                           if .not. myform:aenabled[j]
                              output += mlyform+'.'+name+'.enabled:=.F.'+CRLF
                           endif
                           if myform:actrltype[j]#'TIMER'
                              if .not. myform:avisible[j]
                                 output += mlyform+'.'+name+'.visible:=.F.'+CRLF
                              endif
                           endif
                        endif
                        if UPPER(myform:actrltype[j])$'LABEL ANIMATE' .and. j>1
                           output+= CRLF
                           if len(myform:atooltip[j])>0
                              output += mlyform+'.'+name+'.tooltip:='+"'"+myform:atooltip[j]+"' " + CRLF
                           endif
                        endif
                       if  UPPER(myform:actrltype[j])$'MONTHCALENDAR HYPLINK TEXT LABEL FRAME EDIT DATEPICKER BUTTON CHECKBOX LIST COMBO CHECKBTN GRID SPINNER BROWSE RADIOGROUP RICHEDIT TREE' .and. j>1
                           if myform:afontitalic[j]
                               output+= mlyform+'.'+name+'.fontitalic:=.T.'+CRLF
                           endif
                           if myform:afontunderline[j]
                               output+= mlyform+'.'+name+'.fontunderline:=.T.'+CRLF
                           endif
                           if myform:afontstrikeout[j]
                               output+= mlyform+'.'+name+'.fontstrikeout:=.T.'+CRLF
                           endif
                           if myform:abold[j]
                               output+= mlyform+'.'+name+'.fontbold:=.T.'+CRLF
                           endif
                           endif
                           if UPPER(myform:actrltype[j])$'HYPLINK LABEL FRAME TEXT EDIT DATEPICKER BUTTON CHECKBOX LIST COMBO CHECKBTN GRID SPINNER BROWSE RADIOGROUP PROGRESSBAR RICHEDIT TREE' .and. j>1
                              if len(myform:afontcolor[j])>0
                                 output+= mlyform+'.'+name+'.fontcolor:='+trim(myform:afontcolor[j])+CRLF
                              endif
                           endif
                           if  UPPER(myform:actrltype[j])$'HYPLINK SLIDER FRAME TEXT EDIT DATEPICKER BUTTON CHECKBOX LIST COMBO CHECKBTN GRID SPINNER BROWSE RADIOGROUP PROGRESSBAR RICHEDIT' .and. j>1
                               if len(myform:abackcolor[j])>0 .and. myform:abackcolor[j]#'NIL'
                                  output+= mlyform+'.'+name+'.backcolor:='+trim(myform:abackcolor[j])+CRLF
                               endif
                           endif
                           if UPPER(myform:actrltype[j])$'FRAME' .and. j>1
                               if len(myform:afontname[j])>0
                                  output+= mlyform+'.'+name+'.fontname:='+"'"+trim(myform:afontname[j])+"'"+CRLF
                               endif
                               if myform:afontsize[j]>0
                                  output+= mlyform+'.'+name+'.fontsize:='+str(myform:afontsize[j],3)+CRLF
                               endif
                           endif
                           output+=CRLF
return output

*---------------------------
function myascan(name)
*---------------------------
local ai,nhandle:=0,l
   l:=  len(form_1:acontrols)
   for ai:=1 to l
    if lower(form_1:acontrols[ai]:name) == lower(name)
       nhandle:=ai
       exit
    endif
next ai
return nhandle

