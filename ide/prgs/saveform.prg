/*
 * $Id: saveform.prg,v 1.4 2014-06-25 20:11:58 fyurisich Exp $
 */

/////#include 'oohg.ch'

DECLARE WINDOW Form_1

*------------------------------------------------------------------------------*
METHOD Save(Cas) CLASS TFORM1
*------------------------------------------------------------------------------*
LOCAL i, h, BaseRow, BaseCol, TitleHeight, BorderWidth, BorderHeight, Name, Row, Col, Width, height, Output, j, p, k, m, jn, npos, mlyform
LOCAL swpop := 0

   IF .Not. IsWindowDefined( Form_1 )
      RETURN
   ENDIF

   CursorWait()

   DEFINE MAIN MENU OF Form_1
   END MENU

   npos := Rat( '.', myForm:cForm )
   mlyform := SubStr( myForm:cForm, 1, npos - 1 )
   nslash := Rat( '\', mlyform )
   IF nslash > 0
     mlyform := SubStr( mlyform, nslash + 1 )
   ENDIF
   mlyform := Lower( mlyform )

   h := GetFormHandle( myForm:designform )
   BaseRow := GetWindowRow( h )
   BaseCol := GetWindowCol( h )
   BaseWidth := GetWindowWidth( h )
   BaseHeight := GetWindowHeight( h )
   TitleHeight := GetTitleHeight()
   BorderWidth := GetBorderWidth()
   BorderHeight := GetBorderHeight()

   Output := '' + CRLF
   Output += '* ooHG IDE Plus form generated code' + CRLF
   Output += '* (c)2003-2014 Ciro Vargas Clemow <pcman2010@yahoo.com > ' + CRLF
   Output += CRLF
   Output += 'DEFINE WINDOW TEMPLATE ;' + CRLF
   Output += '   AT ' + LTrim( Str( BaseRow ) ) + ', ' + LTrim( Str( BaseCol ) ) + ' ;' + CRLF
   Output += IIF( ! Empty( myForm:cfobj ), "   OBJ " + myForm:cfobj + " ;" + CRLF, "")
   Output += '   WIDTH ' + LTrim( Str( BaseWidth ) ) + ' ;' + CRLF
   Output += '   HEIGHT ' + LTrim(Str( BaseHeight ) )
   IF myForm:nfvirtualw > 0
      Output +=  ' ;' + CRLF + '   VIRTUAL WIDTH ' + LTrim(Str( myForm:nfvirtualw ) )
   ENDIF
   IF myForm:nfvirtualh > 0
      Output += ' ;' + CRLF + '  VIRTUAL HEIGHT ' + LTrim( Str( myForm:nfvirtualh ) )
   ENDIF
   IF Len( myForm:cftitle ) > 0
      Output += ' ;' + CRLF + '   TITLE ' + "'" + myForm:cftitle + "'"
   ENDIF
   IF Len( myForm:cficon ) > 0
      Output += ' ;' + CRLF + '   ICON ' + "'" + myForm:cficon + "'"
   ENDIF
   Output += IIF( myForm:lfmain, ' ;' + CRLF + "   MAIN", "" )
   Output += IIF( myForm:lfsplitchild, ' ;' + CRLF + "   SPLITCHILD", "" )
   Output += IIF( myForm:lfchild, ' ;' + CRLF + "   CHILD", "" )
   Output += IIF( myForm:lfmodal, ' ;' + CRLF + "   MODAL", "" )
   Output += IIF( myForm:lfnoshow, ' ;' + CRLF + "   NOSHOW", "" )
   Output += IIF( myForm:lftopmost, ' ;' + CRLF + "   TOPMOST", "" )
   Output += IIF( myForm:lfnoautorelease, ' ;' + CRLF + "   NOAUTORELEASE", "" )
   Output += IIF( myForm:lfnominimize, ' ;' + CRLF + "   NOMINIMIZE", "" )
   Output += IIF( myForm:lfnomaximize, ' ;' + CRLF + "   NOMAXIMIZE", "" )
   Output += IIF( myForm:lfnosize, ' ;' + CRLF + "   NOSIZE", "" )
   Output += IIF( myForm:lfnosysmenu, ' ;' + CRLF + "   NOSYSMENU", "" )
   Output += IIF( myForm:lfnocaption, ' ;' + CRLF + "   NOCAPTION", "" )
   IF Len( myForm:cfcursor ) > 0
      Output += ' ;' + CRLF + '   CURSOR ' + "'" + myForm:cfcursor + "'"
   ENDIF
   IF Len( myForm:cfoninit ) > 0
      Output += ' ;' + CRLF + '   ON INIT ' + myForm:cfoninit
   ENDIF
   IF Len( myForm:cfonrelease ) > 0
      Output += ' ;' + CRLF + '   ON RELEASE ' + myForm:cfonrelease
   ENDIF
   IF Len( myForm:cfoninteractiveclose ) > 0
      Output += ' ;' + CRLF + '   ON INTERACTIVECLOSE ' + myForm:cfoninteractiveclose
   ENDIF
   IF Len( myForm:cfonmouseclick ) > 0
      Output += ' ;' + CRLF + '   ON MOUSECLICK ' + myForm:cfonmouseclick
   ENDIF
   IF Len( myForm:cfonmousedrag ) > 0
      Output += ' ;' + CRLF + '   ON MOUSEDRAG ' + myForm:cfonmousedrag
   ENDIF
   IF Len( myForm:cfonmousemove ) > 0
      Output += ' ;' + CRLF + '   ON MOUSEMOVE ' + myForm:cfonmousemove
   ENDIF
   IF Len( myForm:cfonsize ) > 0
      Output += ' ;' + CRLF + '   ON SIZE ' + myForm:cfonsize
   ENDIF
   IF Len( myForm:cfonpaint ) > 0
      Output += ' ;' + CRLF + '   ON PAINT ' + myForm:cfonpaint
   ENDIF
   IF Len( myForm:cfbackcolor ) > 0 .AND. myForm:cfbackcolor # 'NIL'
      Output += ' ;' + CRLF + '   BACKCOLOR ' + myForm:cfbackcolor
   ENDIF
   IF Len( myForm:cffontname ) > 0
      Output += ' ;' + CRLF + "   FONT " + "'" + myForm:cffontname + "'"
   ENDIF
   IF myForm:nffontsize > 0
      Output += ' ;' + CRLF + '   SIZE ' + LTrim( Str( myForm:nffontsize ) )
   ELSE
      Output += ' ;' + CRLF + '   SIZE ' + LTrim( Str( 10 ) )
   ENDIF
      Output += IIF( myForm:lfgrippertext, "GRIPPERTEXT", "")
   IF Len( myForm:cfnotifyicon ) > 0
      Output += ' ;' + CRLF + "   NOTIFYICON " + "'" + myForm:cfnotifyicon + "'"
   ENDIF
   IF Len( myForm:cfnotifytooltip ) > 0
      Output += ' ;' + CRLF + "   NOTIFYTOOLTIP " + "'" + myForm:cfnotifytooltip + "'"
   ENDIF
   IF Len( myForm:cfonnotifyclick ) > 0
      Output += ' ;' + CRLF + '   ON NOTIFYCLICK ' + myForm:cfonnotifyclick
   ENDIF
   Output += IIF( myForm:lfbreak, ' ;' + CRLF + "   BREAK", "")
   Output += IIF( myForm:lffocused, ' ;' + CRLF + "   FOCUSED", "")
   IF Len( myForm:cfongotfocus ) > 0
      Output += ' ;' + CRLF + '   ON GOTFOCUS ' + myForm:cfongotfocus
   ENDIF
   IF Len( myForm:cfonlostfocus ) > 0
      Output += ' ;' + CRLF + '   ON LOSTFOCUS ' + myForm:cfonlostfocus
   ENDIF
   IF Len( myForm:cfonscrollup ) > 0
      Output += ' ;' + CRLF + '   ON SCROLLUP ' + myForm:cfonscrollup
   ENDIF
   IF Len( myForm:cfonscrolldown ) > 0
      Output += ' ;' + CRLF + '   ON SCROLLDOWN ' + myForm:cfonscrolldown
   ENDIF
   IF Len( myForm:cfonscrollright ) > 0
      Output += ' ;' + CRLF + '   ON SCROLLRIGHT ' + myForm:cfonscrollright
   ENDIF
   IF Len( myForm:cfonscrollleft ) > 0
      Output += ' ;' + CRLF + '   ON SCROLLLEFT ' + myForm:cfonscrollleft
   ENDIF
   IF Len( myForm:cfonhscrollbox ) > 0
      Output += ' ;' + CRLF + '   ON HSCROLLBOX ' + myForm:cfonhscrollbox
   ENDIF
   IF Len( myForm:cfonvscrollbox ) > 0
      Output += ' ;' + CRLF + '   ON VSCROLLBOX ' + myForm:cfonvscrollbox
   ENDIF
   Output += IIF( myForm:lfhelpbutton, ' ;' + CRLF + "HELPBUTTON", "")
   Output += CRLF + CRLF

// HASTA AQUI DEFINICION BASICA DE LA FORMA

   wvalor := .F.
   IF myForm:lsstat
      wvalor := .T.
   ENDIF
   IF wvalor
      Output += '   DEFINE STATUSBAR'
      IF ! Empty( myForm:cscobj )
         Output += ' ;' + CRLF
         Output += '      OBJ ' + myForm:cscobj
      ENDIF
      Output += CRLF

      IF Len( myForm:cscaption ) > 0
         Output += '      STATUSITEM ' + "'" + myForm:cscaption + "'"
      ELSE
         Output += "      STATUSITEM ''"
      ENDIF
      IF myForm:nswidth > 0
         Output += ' ;' + CRLF
         Output += '         WIDTH ' + LTrim( Str( myForm:nswidth ) )
      ENDIF
      IF Len( myForm:csaction ) > 0
         Output += ' ;' + CRLF
         Output += '         ACTION ' + myForm:csaction
      ENDIF
      IF Len( myForm:csicon ) > 0
         Output += ' ;' + CRLF
         Output += "         ICON '" + myForm:csicon + "'"
      ENDIF
      IF myForm:lsflat
         Output += ' ;' + CRLF
         Output += '         FLAT'
      ENDIF
      IF myForm:lsraised
         Output += ' ;' + CRLF
         Output += '         RAISED'
      ENDIF
      IF Len( myForm:cstooltip ) > 0
         Output += ' ;' + CRLF
         Output += "         TOOLTIP '" + myForm:cstooltip + "'"
      ENDIF
      Output += CRLF

      IF myForm:lskeyboard
         Output += '      KEYBOARD' + CRLF
      ENDIF

      IF myForm:lsdate
         Output += '      DATE ;' + CRLF
         Output += '         WIDTH ' + LTrim( Str( 80 ) ) + CRLF
      ENDIF
/*
      IF Len( csdateaction ) > 0
         Output += '      ACTION ' + csdateaction + ' ;' + CRLF
      ENDIF
      IF Len( csdatetooltip ) > 0
         Output += '      TOOLTIP ' + '"' + csdatetooltip + '" ;' + CRLF
      ENDIF
*/

      IF myForm:lstime
         Output += '      CLOCK ;' + CRLF
         Output += '         WIDTH ' + LTrim( Str( 80 ) ) + CRLF
      ENDIF
/*
      IF Len( cstimeaction ) > 0
         Output += '      ACTION ' + cstimeaction + ' ;' + CRLF
      ENDIF
      IF Len( cstimetooltip ) > 0
         Output += '      TOOLTIP ' + '"' + cstimetooltip + '" ;' + CRLF
      ENDIF
*/

      Output += '   END STATUSBAR' + CRLF
      Output += CRLF
   ENDIF

//***************************  Inicio de creación de menú principal
   CLOSE DATABASES

   IF File( myForm:cfname + '.mnm' )
      archivo := myForm:cfname + '.mnm'
      SELECT 10
      use &archivo exclusive alias menues
      pack
      IF reccount() > 0
         Output += '   DEFINE MAIN MENU' + CRLF
         do while .not. eof()
            IF recn() < reccount()
               skip
               signiv := level
               skip -1
            ELSE
               signiv := 0
            ENDIF
            niv := level
            IF signiv > level
               IF lower( trim( auxit ) ) = 'separator'
                  Output += space( 6 * level + 3 ) + 'SEPARATOR' + CRLF
               ELSE
                  Output +=space( 6 * level + 3 ) + 'POPUP ' + "'" + Trim( auxit ) + "'" + IIF( Trim( named ) # "", " NAME " + "'" + AllTrim( named ) + "'", "") + " " + CRLF
                  IF menues->enabled = 'X'
                     cc := "//" + mlyform + '.' + Trim( named ) + '.enabled := .F.'
                     Output += cc + CRLF
                     cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'enabled', .F.)"
                     Output += cc + CRLF
                  ENDIF
                  swpop ++
               ENDIF
            ELSE
               IF lower( trim( auxit ) ) = 'separator'
                  Output += space( 6 * level + 3 ) + 'SEPARATOR' + CRLF
               ELSE
                  Output += space( 6 * level + 3 ) + 'ITEM ' + "'" + trim(auxit) + "'" + ' ACTION ' + IIF( Len( Trim( action ) ) # 0, Trim( ACTION ), "MsgBox( 'item' )") + " "
                  IF Trim( named ) == ''
                     Output += "" + IIF( TRIM(menues->IMAGE) # "", " IMAGE " + "'" + AllTrim(menues->IMAGE) + "'", "") + " " + CRLF
                  ELSE
                     Output += "NAME " + "'" + AllTrim(NAMED) + "'" + IIF( TRIM(menues->IMAGE) # "", " IMAGE " + "'" + AllTrim(menues->IMAGE) + "'", "") + " " + CRLF
                     IF menues->checked = 'X'
                        cc := "//" + mlyform + '.' + trim(named) + '.checked := .F.'
                        Output += cc + CRLF
                        cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'checked', .F.)"
                        Output += cc + CRLF
                     ENDIF
                     IF menues->enabled = 'X'
                        cc := "//" + mlyform + '.' + trim(named) + '.enabled := .F.'
                        Output += cc + CRLF
                        cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'enabled', .F.)"
                        Output += cc + CRLF
                     ENDIF
                  ENDIF
               ENDIF
               do while signiv < niv
                  Output += space( ( niv - 1 ) * 6 + 3 ) + 'END POPUP' + CRLF
                  swpop --
                  niv --
               enddo
            ENDIF
            skip
         enddo
         nnivaux := niv - 1
         do while swpop > 0
            nnivaux --
            Output += space( nnivaux * 6 + 3 ) + 'END POPUP' + CRLF
            swpop--
         enddo
         Output += '   END MENU' + CRLF + CRLF
      ENDIF
      CLOSE DATABASES
   ENDIF
//***************************  Fin de creación de menú principal

        IF file(myForm:cfname + '.mnc')
           archivo := myForm:cfname + '.mnc'
           select 20
           use &archivo alias menues
           IF  reccount( ) > 0
               Output +=CRLF + 'DEFINE CONTEXT MENU ' + CRLF
               **************
               do while .not. eof()
               IF lower(trim(auxit))='separator'
                  Output +=space(6*level) + 'SEPARATOR' + CRLF
               ELSE
                  Output +=space(6*level) + 'ITEM ' + "'" + trim(auxit) + "'" + ' ACTION ' + IIF( Len( trim(action)) # 0, trim(ACTION), "msgbox('item')") + " "
                  IF trim(named)==''
                     Output +="" + IIF( Len( TRIM(menues->IMAGE)) # 0, " IMAGE " + "'" + AllTrim(menues->IMAGE) + "'", "") + " " + CRLF
                  ELSE
                     Output += "NAME " + "'" + AllTrim(NAMED) + "'" + IIF( Len( TRIM(menues->IMAGE)) # 0, " IMAGE " + "'" + AllTrim(menues->IMAGE) + "'", "") + " " + CRLF
                     IF menues->checked='X'
                        cc := "//" + mlyform + '.' + trim(named) + '.checked := .F.'
                        Output += cc + CRLF
                        cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'checked', .F.)"


////                        cc := mlyform + '.' + trim(named) + '.checked := .T.'
                        Output += cc + CRLF
                     ENDIF
                     IF menues->enabled='X'

                        cc := "//" + mlyform + '.' + trim(named) + '.enabled := .F.'
                        Output += cc + CRLF
                        cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'enabled', .F.)"

                        Output += cc + CRLF
                     ENDIF
                  ENDIF
               ENDIF
               skip
               enddo
               Output +=CRLF
               Output += '   END MENU' + CRLF + CRLF
               use
****    fin de menu contextual
           ENDIF
        ENDIF
        close data
        IF file(myForm:cfname + '.mnn')
           archivo := myForm:cfname + '.mnn'
           select 30
           use &archivo alias menues
           IF  reccount( ) > 0
               Output +=CRLF + 'DEFINE NOTIFY MENU ' + CRLF
               **************
               do while .not. eof()
               IF lower(trim(auxit))='separator'
                  Output +=space(6*level) + 'SEPARATOR' + CRLF
               ELSE
                  Output +=space(6*level) + 'ITEM ' + "'" + trim(auxit) + "'" + ' ACTION ' + IIF( Len( trim(action)) # 0, trim(ACTION), "msgbox('item')") + " "
                  IF trim(named)==''
                     Output +="" + IIF( Len( TRIM(menues->IMAGE)) # 0, " IMAGE " + "'" + AllTrim(menues->IMAGE) + "'", "") + " " + CRLF
                  ELSE
                     Output += "NAME " + "'" + AllTrim(NAMED) + "'" + IIF( Len( TRIM(menues->IMAGE)) # 0, " IMAGE " + "'" + AllTrim(menues->IMAGE) + "'", "") + " " + CRLF
                     IF menues->checked='X'
                        cc := "//" + mlyform + '.' + trim(named) + '.checked := .F.'
                        Output += cc + CRLF
                        cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'checked', .F.)"

                        Output += cc + CRLF
                     ENDIF
                     IF menues->enabled='X'
                        cc := "//" + mlyform + '.' + trim(named) + '.enabled := .F.'
                        Output += cc + CRLF
                        cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'enabled', .F.)"

                        Output += cc + CRLF
                     ENDIF
                  ENDIF
               ENDIF
               skip
               enddo
               Output +=CRLF
               Output += '   END MENU' + CRLF + CRLF
           use
******          fin de menu notify
           ENDIF
        ENDIF

        ***** end menus creation
        close data
        IF file(myForm:cfname + '.tbr')
           archivo := myForm:cfname + '.tbr'
           select 40
           use &archivo exclusive alias dDtoolbar
           pack
           IF  reccount( ) > 0
               Output +=CRLF + 'DEFINE TOOLBAR ' + tmytoolb:ctbname + ' ;' + CRLF
               Output += '   BUTTONSIZE ' + LTrim( Str( tmytoolb:nwidth ) ) + ', ' + LTrim( Str( tmytoolb:nheight ) ) + '  ;' + CRLF
               Output +=IIF( Len( tmytoolb:cfont ) > 0, 'FONT ' + "'" + tmytoolb:cfont + "' ;" + CRLF, '')
               Output +=IIF( tmytoolb:nsize > 0, 'SIZE ' + LTrim( Str( tmytoolb:nsize ) ) + " ;" + CRLF, '')
               Output +=IIF( tmytoolb:lbold, 'BOLD ;' + CRLF, '')
               Output +=IIF( tmytoolb:litalic, 'ITALIC ;' + CRLF, '')
               Output +=IIF( tmytoolb:lunderline, 'UNDERLINE ;' + CRLF, '')
               Output +=IIF( tmytoolb:lstrikeout, 'STRIKEOUT ;' + CRLF, '')
               Output +=IIF( Len( tmytoolb:ctooltip ) > 0, 'TOOLTIP ' + "'" + tmytoolb:ctooltip + "' ;" + CRLF, '')
               Output +=IIF( tmytoolb:lflat, 'FLAT ;' + CRLF, '')
               Output +=IIF( tmytoolb:lbottom, 'BOTTOM ;' + CRLF, '')
               Output +=IIF( tmytoolb:lrighttext, 'RIGHTTEXT ;' + CRLF, '')
               Output +=IIF( tmytoolb:lborder, 'BORDER ;' + CRLF, '')

               Output +=CRLF + CRLF
               go top
               **************
               do while .not. eof()
                  Output += '   BUTTON ' + trim(NAMED) + ' ;' + CRLF
                  Output += '   CAPTION ' + "'" + trim(ITEM) + "'" + ' ;' + CRLF
                  IF Len( trim(DdTOOLBAR->IMAGE) ) > 0
                    Output += '   PICTURE ' + "'" + trim(DdTOOLBAR->IMAGE) + "'" + ' ;' + CRLF
                  ENDIF
                  Output += '   ACTION ' + trim(DdTOOLBAR->ACTION) + ' ;' + CRLF
                  IF DdTOOLBAR->Separator='X'
                     Output += '   SEPARATOR  ;' + CRLF
                  ENDIF
                  IF DdTOOLBAR->AUTOSIZE='X'
                     Output += '   AUTOSIZE  ;' + CRLF
                  ENDIF
                  IF DdTOOLBAR->check='X'
                     Output += '   CHECK  ;' + CRLF
                  ENDIF
                  IF DdTOOLBAR->group='X'
                     Output += '   GROUP  ;' + CRLF
                  ENDIF


                  IF fcount( ) > 9
                     IF DdTOOLBAR->drop='X'
                        Output += '   DROPDOWN  ;' + CRLF
                     ENDIF
                     IF fcount( ) > 10
                        IF .not. Empty(DdTOOLBAR->tooltip )
                           Output +="Tooltip  '" + rtrim(Ddtoolbar->tooltip) + "'" + " ;" + CRLF
                        ENDIF
                     ENDIF
                  ENDIF
                  **** VER GROUP Y SEPARATOR
                  skip
                  Output +=CRLF + CRLF
               enddo
               Output +=CRLF
               Output += '   END TOOLBAR' + CRLF + CRLF
           ENDIF
        go top
        do while .not. eof()
           cbutton := AllTrim(ddtoolbar->named)
           carchivo := myForm:cfname + '.' + cbutton + '.mnd'
           IF file(carchivo)
           select 50
           use &carchivo alias menues
           IF  reccount( ) > 0
               Output +=CRLF + CRLF + 'DEFINE DROPDOWN MENU BUTTON ' + cbutton + CRLF
               **************
               do while .not. eof()
               IF lower(trim(auxit))='separator'
                  Output +=space(6*level) + 'SEPARATOR' + CRLF
               ELSE
                  Output +=space(6*level) + 'ITEM ' + "'" + trim(auxit) + "'" + ' ACTION ' + IIF( Len( trim(action)) # 0, trim(ACTION), "msgbox('item')") + " "
                  IF trim(named)==''
                     Output +="" + IIF( Len( TRIM(menues->IMAGE)) # 0, " IMAGE " + "'" + AllTrim(menues->IMAGE) + "'", "") + " " + CRLF
                  ELSE
                     Output += "NAME " + NAMED + IIF( Len( TRIM(menues->IMAGE)) # 0, " IMAGE " + "'" + AllTrim(menues->IMAGE) + "'", "") + " " + CRLF

                     IF menues->checked='X'
                        cc := "//" + mlyform + '.' + trim(named) + '.checked := .F.'
                        Output += cc + CRLF
                        cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'checked', .F.)"

                        Output += cc + CRLF
                     ENDIF
                     IF menues->enabled='X'
                        cc := "//" + mlyform + '.' + trim(named) + '.enabled := .F.'
                        Output += cc + CRLF
                        cc := "SetProperty('" + mlyform + "', " + "'" + trim(named) + "', " + "'enabled', .F.)"

                        Output += cc + CRLF
                     ENDIF
                  ENDIF
               ENDIF
               skip
               enddo
               Output +=CRLF
               Output += '   END MENU' + CRLF + CRLF
           ENDIF
           ENDIF
           select 40
           skip
        enddo
        ENDIF
        ********** dropdown menu

        ***** end toolbar ****    fin de toolbar

        j := 1
        do while j <=  myForm:ncontrolw
               do while upper(myForm:acontrolw[j])='TEMPLATE' .AND. upper(myForm:acontrolw[j])='STATUSBAR'  .AND. upper(myForm:acontrolw[j])='MAINMENU' ;
                 .AND. upper(myForm:acontrolw[j])='CONTEXTMENU' .AND. upper(myForm:acontrolw[j])='NOTIFYMENU' .AND. j< myForm:ncontrolw
                  j ++
               enddo
            name := myForm:acontrolw[j]
            nhandle := myascan(name)
*********
            IF nhandle=0
               j ++
               loop
            ENDIF
            owindow := getformobject("Form_1")
            Row    := GetWindowRow ( owindow:acontrols[nhandle]:hwnd ) - BaseRow - TitleHeight - BorderHeight
            Col    := GetWindowCol ( owindow:acontrols[nhandle]:hwnd ) - BaseCol - BorderWidth
            Width  := GetWindowWidth ( owindow:acontrols[nhandle]:hwnd )
            Height := GetWindowHeight ( owindow:acontrols[nhandle]:hwnd )

                        IF myForm:actrltype[j] == 'TAB'
                           Output += '*****@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' TAB ' + myForm:aname[j] + '  ' + CRLF
                           Output += 'DEFINE TAB ' + myForm:aname[j] + ' ;' + CRLF
                           IF ! Empty(myForm:acobj[j])
                              Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
                           ENDIF
                           Output += 'AT ' + Str( row, 4) + ', ' + Str( col, 4) + '  ;' + CRLF
                           Output += 'WIDTH  ' + LTrim(Str( Width)) + ' ;' + CRLF
                           Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
                           IF Len( myForm:avalue[j] ) > 0
                              Output += 'VALUE ' + myForm:avalue[j] + ' ;' + CRLF
                           ENDIF
                           IF Len( myForm:afontname[j] ) > 0
                              Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
                           ENDIF
                           IF myForm:afontsize[j] > 0
                              Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
                           ENDIF
                           IF Len( myForm:atooltip[j] ) > 0
                              Output += 'TOOLTIP ' + "'" + myForm:atooltip[j] + "'" + ' ;' + CRLF
                           ENDIF
                           IF myForm:abuttons[j]
                              Output += 'BUTTONS ' + '  ;' + CRLF
                           ENDIF
                           IF myForm:aflat[j]
                              Output += 'FLAT ' + '  ;' + CRLF
                           ENDIF
                           IF myForm:ahottrack[j]
                              Output += 'HOTTRACK ' + '  ;' + CRLF
                           ENDIF
                           IF myForm:avertical[j]
                              Output += 'VERTICAL ' + '  ;' + CRLF
                           ENDIF
                           IF Len( myForm:aonchange[j] ) > 0
                              Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
                           ENDIF
                           Output += '  ' + '  ' + CRLF + CRLF
                            **************
****                           cuantos page hay ?
                           cacaptions := myForm:acaption[j]
                           caimages := myForm:aimage[j]
                           acaptions := &cacaptions
                           aimage := &caimages
                           currentpage := 1
                           Output += "DEFINE PAGE '" + acaptions[currentpage] + "'" + '  ;' + CRLF
                           Output += "IMAGE '" + ltrim(aimage[currentpage]) + "'" + '  ' + CRLF + CRLF
                           for k=1 to myForm:ncontrolw
                               IF myForm:atabpage[k, 1] # NIL
                                  IF myForm:atabpage[k, 1]==myForm:acontrolw[j]
                                     IF myForm:atabpage[k, 2] # currentpage
                                         Output += 'END PAGE' + CRLF + CRLF
                                         currentpage ++
                                        Output += "DEFINE PAGE '" + acaptions[currentpage] + "'" + '  ;' + CRLF
                                        Output += "IMAGE '" + ltrim(aimage[currentpage]) + "'" + '  ' + CRLF + CRLF
                                     ENDIF

                                     p := myascan(myForm:acontrolw[k])
                                     IF p > 0
                                        owindow := getformobject("Form_1")
                                        Row     := owindow:acontrols[p]:row
                                        Col     := owindow:acontrols[p]:col
                                        Width   := owindow:acontrols[p]:width
                                        Height  := owindow:acontrols[p]:height
                                        Output := makecontrols(k, Output, row, col, width, height, mlyform)
                                     ENDIF
                                  ENDIF
                               ENDIF
                           next k

                           Output += 'END PAGE ' + '  ' + CRLF
                           IF myForm:afontitalic[j]
                               Output += mlyform + '.' + name + '.fontitalic := .T.' + CRLF
                           ENDIF
                           IF myForm:afontunderline[j]
                               Output += mlyform + '.' + name + '.fontunderline := .T.' + CRLF
                           ENDIF
                           IF myForm:afontstrikeout[j]
                               Output += mlyform + '.' + name + '.fontstrikeout := .T.' + CRLF
                           ENDIF
                           IF myForm:abold[j]
                               Output += mlyform + '.' + name + '.fontbold := .T.' + CRLF
                           ENDIF
                           IF .not. myForm:aenabled[j]
                              Output += mlyform + '.' + name + '.enabled := .F.' + CRLF
                           ENDIF
                           IF .not. myForm:avisible[j]
                              Output += mlyform + '.' + name + '.visible := .F.' + CRLF
                           ENDIF

                           Output +="END TAB" + CRLF + CRLF
*************************************************
                           Output +=CRLF
                        ELSE
                           IF myForm:actrltype[j] # 'TAB' .AND. myForm:atabpage[j, 2]=0 .OR. myForm:atabpage[j, 2]=NIL
                              Output := makecontrols(j, Output, row, col, width, height, mlyform)
                           ENDIF
                        ENDIF
           j ++
        enddo
Output += 'END WINDOW ' + CRLF + CRLF
cursorarrow()
****RETURN
IF cAs==1
   IF .not. memoWrit ( PutFile ( { {'Form files *.fmg', '*.fmg'} }, 'Save Form As', , .T. ), Output )
      msgstop('Error writing Form', 'Information')
      RETURN
   ENDIF
ELSE
   IF .not. memowrit(myForm:cForm, Output)
      msgstop('Error writing ' + myForm:cForm, 'Information')
      RETURN
   ENDIF
   myForm:lfSave := .T.
ENDIF
close data
IF file(myForm:cfname + '.mnm')
   archivo := myForm:cfname + '.mnm'
   select 20
   use &archivo alias menues
   nbuttons := reccount()
   swpop := 0
   IF nbuttons > 0
     go top
   DEFINE MAIN MENU of Form_1
   do while .not. eof()
      IF recn() < reccount()
         skip
         signiv := level
         skip -1
      ELSE
         signiv=0
      ENDIF
      niv=level
      IF signiv > level
         IF lower(trim(auxit))='separator'
            SEPARATOR
         ELSE
            POPUP AllTrim(auxit)
            swpop ++
         ENDIF
      ELSE
         IF lower(trim(auxit))='separator'
            SEPARATOR
         ELSE
            ITEM  AllTrim(auxit)  ACTION  NIL
            IF trim(named)==''
            ELSE
               IF menues->checked='X'
                 /// cc := myForm:cfname + '.' + trim(named) + '.checked := .T.'
                 /// Output += cc + CRLF
               ENDIF
               IF menues->enabled='X'
                  ///cc := myForm:cfname + '.' + trim(named) + '.enabled := .F.'
                  ///Output += cc + CRLF
               ENDIF
            ENDIF
         ENDIF
**********************************
         do while signiv<niv
            END POPUP
            swpop--
            niv--
         enddo
      ENDIF
      skip
   enddo
   nnivaux := niv-1
   do while swpop > 0
      nnivaux--
      END POPUP
      swpop--
   enddo
   END MENU
   use
   ENDIF
ENDIF
RETURN

*-------------------------------------------------------------
FUNCTION MakeControls( j, Output, row, col, width, height, mlyform )
*-------------------------------------------------------------

   IF myForm:actrltype[j]  == "BUTTON"
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' BUTTON ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:acaption[j] ) > 0
         Output += "CAPTION " + "'" + myForm:acaption[j] + "'" + ' ;' + CRLF
     ELSE
         Output += "CAPTION " + "'" + myForm:aname[j] + "'" + " ;" + CRLF
     ENDIF
      IF Len( myForm:aPicture[j] ) > 0
         Output += "PICTURE " + "'" + myForm:apicture[j] + "'" + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aaction[j] ) > 0
        Output += 'ACTION ' + myForm:aaction[j] + ' ;' + CRLF
     ELSE
        Output += 'ACTION ' + 'MsgInfo("Button Pressed")' + ' ;' + CRLF
     ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:afontname[j] ) > 0
         Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
         Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:atooltip[j] ) > 0
         Output += 'TOOLTIP ' + "'" + myForm:atooltip[j] + "'" + ' ;' + CRLF
     ENDIF
     IF myForm:aflat[j]
        Output += 'FLAT ' + ' ;' + CRLF
     ENDIF
     IF Len( myForm:ajustify[j] ) > 0 .AND. Len( myForm:aPicture[j] ) > 0 .AND. Len( myForm:acaption[j] ) > 0
          Output += myForm:ajustify[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
        Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
        Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
        Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF

     Output += ' ' + CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'CHECKBOX'
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' CHECKBOX ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF

     IF Len( myForm:acaption[j] ) > 0
         Output += 'CAPTION ' + "'" + myForm:acaption[j] + "'" + ' ;' + CRLF
     ELSE
         Output += 'CAPTION ' + " ' " + " ' " + ' ;' + CRLF
     ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
      Output += 'HEIGHT ' + LTrim(Str( Height)) + ';' + CRLF
     IF myForm:avaluel[j]
       Output += 'VALUE .T.' + ' ;' + CRLF
     ELSE
       Output += 'VALUE .F.' + ' ;' + CRLF
     ENDIF
     IF Len( myForm:afield[j] ) > 0
       Output += 'FIELD ' + myForm:afield[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:afontname[j] ) > 0
        Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
        Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
      ENDIF
     IF Len( myForm:atooltip[j] ) > 0
        Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
        Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
        Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
        Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF myForm:atransparent[j]
        Output += 'TRANSPARENT ' + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF

     Output += ' ' + CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'TREE'
     Output += '*****@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' TREE ' + myForm:aname[j] + '  ' + CRLF
     Output += 'DEFINE TREE ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'AT ' + LTrim( Str( row ) ) + ', ' + LTrim( Str( col ) ) + '  ;' + CRLF
     Output += 'WIDTH  ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:afontname[j] ) > 0
         Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
        Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:atooltip[j] ) > 0
         Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
        Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
        Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
        Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aondblclick[j] ) > 0
        Output += 'ON DBLCLICK ' + myForm:aondblclick[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:anodeimages[j] ) > 0
        Output += 'NODEIMAGES ' + myForm:anodeimages[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aitemimages[j] ) > 0
        Output += 'ITEMIMAGES ' + myForm:aitemimages[j] + ' ;' + CRLF
     ENDIF
     IF myForm:anorootbutton[j]
        Output += 'NOROOTBUTTON ' + ' ;' + CRLF
     ENDIF
     IF myForm:aitemids[j]
        Output += 'ITEMIDS ' +  ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
        Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF

     Output +=CRLF
     Output +="END TREE" + CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'LIST'
       Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' LISTBOX ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'WIDTH  ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:aitems[j] ) > 0
           Output += "ITEMS  " + myForm:aitems[j] + "  ;" + CRLF
     ENDIF

     IF myForm:avaluen[j] > 0
           Output += 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) ) + ' ;' + CRLF
     ENDIF

     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF

     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aondblclick[j] ) > 0
           Output += 'ON DBLCLICK ' + myForm:aondblclick[j] + ' ;' + CRLF
     ENDIF

     IF myForm:amultiselect[j]
           Output += 'MULTISELECT ' + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:abreak[j]
           Output += 'BREAK ' + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
     IF myForm:asort[j]
        Output += 'SORT ' + ' ;' + CRLF
     ENDIF

     Output += ' ' + CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'COMBO'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' COMBOBOX ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF

     IF Len( myForm:aitems[j] ) > 0
           Output += "ITEMS  " + myForm:aitems[j] + "  ;" + CRLF
     ENDIF
     IF Len( myForm:aitemsource[j] ) > 0
           Output += "ITEMSOURCE " + myForm:aitemsource[j] + "  ;" + CRLF
     ENDIF
     IF myForm:avaluen[j] > 0
           Output += 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:avaluesource[j] ) > 0
           Output += "VALUESOURCE " + myForm:avaluesource[j] + "  ;" + CRLF
     ENDIF
     IF myForm:adisplayedit[j]
        Output += 'DISPLAYEDIT ' + ' ;' + CRLF
     ENDIF
     Output += 'WIDTH  ' + LTrim(Str( Width)) + ' ;' + CRLF
   ////   Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:afontname[j] ) > 0
       Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF

     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF

     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF

     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonenter[j] ) > 0
           Output += 'ON ENTER ' + myForm:aonenter[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aondisplaychange[j] ) > 0
           Output += 'ON DISPLAYCHANGE ' + myForm:aondisplaychange[j] + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:abreak[j]
        Output += 'BREAK ' + ' ;' + CRLF
     ENDIF
     IF myForm:asort[j]
        Output += 'SORT ' + ' ;' + CRLF
     ENDIF

     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'CHECKBTN'
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' CHECKBUTTON ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:acaption[j] ) > 0
         Output += 'CAPTION ' + "'" + myForm:acaption[j] + "'" + ' ;' + CRLF
     ELSE
         Output += 'CAPTION ' + "'" + myForm:aname[j] + "'" + ' ;' + CRLF
     ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
      Output += 'HEIGHT ' + LTrim(Str( Height)) + ';' + CRLF
     IF myForm:avaluel[j]
        Output += 'VALUE .T.' + ' ;' + CRLF
     ELSE
        Output += 'VALUE .F.' + ' ;' + CRLF
     ENDIF

     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
      ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
     Output += ' ' + CRLF + CRLF

   ENDIF
   IF myForm:actrltype[j] == 'GRID'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' GRID ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF

     Output += 'HEADERS ' + myForm:aheaders[j] + ' ;' + CRLF
     Output += 'WIDTHS  ' + myForm:awidths[j] + ' ;' + CRLF
     IF Len( myForm:aitems[j] ) > 0
        Output += 'ITEMS  ' + myForm:aitems[j]  + ' ;' + CRLF
     ENDIF
     IF Len( myForm:avalue[j] ) > 0
         Output += ' VALUE  ' + myForm:avalue[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:adynamicbackcolor[j] ) > 0
           Output += 'DYNAMICBACKCOLOR ' + myForm:adynamicbackcolor[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:adynamicforecolor[j] ) > 0
           Output += 'DYNAMICFORECOLOR ' + myForm:adynamicforecolor[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:acolumncontrols[j] ) > 0
           Output += 'COLUMNCONTROLS ' + myForm:acolumncontrols[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
      ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aondblclick[j] ) > 0
           Output += 'ON DBLCLICK ' + myForm:aondblclick[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonheadclick[j] ) > 0
           Output += 'ON HEADCLICK ' + myForm:aonheadclick[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aoneditcell[j] ) > 0
           Output += 'ON EDITCELL ' + myForm:aoneditcell[j] + ' ;' + CRLF
     ENDIF
     IF myForm:amultiselect[j]
        Output += 'MULTISELECT' + ' ;' + CRLF
     ENDIF
     IF myForm:anolines[j]
        Output += 'NOLINES' + ' ;' + CRLF
     ENDIF
     IF myForm:ainplace[j]
        Output += 'INPLACE' + ' ;' + CRLF
     ENDIF
     IF myForm:aedit[j]
        Output += 'EDIT' + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aimage[j] ) > 0
           Output += 'IMAGE ' + myForm:aimage[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:ajustify[j] ) > 0
           Output += 'JUSTIFY ' + (myForm:ajustify[j]) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:awhen[j] ) > 0
           Output += 'WHEN ' + myForm:awhen[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:avalid[j] ) > 0
           Output += 'VALID ' + myForm:avalid[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:avalidmess[j] ) > 0
           Output += 'VALIDMESSAGES ' + myForm:avalidmess[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:areadonlyb[j] ) > 0
        Output += 'READONLY ' + myForm:areadonlyb[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:ainputmask[j] ) > 0
           Output += "INPUTMASK " + myForm:ainputmask[j] +  ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:abreak[j]
        Output += 'BREAK' + ' ;' + CRLF
     ENDIF

      Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'BROWSE'
               Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' BROWSE ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:aheaders[j] ) > 0
        Output += 'HEADERS ' + myForm:aheaders[j] + ' ;' + CRLF
     ELSE
        Output += 'HEADERS ' + "{'', ''} " + ' ;' + CRLF
     ENDIF
     IF Len( myForm:awidths[j] ) > 0
        Output += 'WIDTHS  ' + myForm:awidths[j] + ' ;' + CRLF
     ELSE
        Output += 'WIDTHS ' + "{90, 60}" + ' ;' + CRLF
     ENDIF
     Output += 'WORKAREA ' + myForm:aworkarea[j] + ' ;' + CRLF
     IF Len( myForm:afields[j] ) > 0
        Output += 'FIELDS  ' + myForm:afields[j]  + ' ;' + CRLF
     ELSE
        Output += 'FIELDS  ' + "{'field1', 'field2'}" + ' ;' + CRLF
     ENDIF
     IF myForm:avaluen[j] > 0
         Output += 'VALUE  ' + LTrim( Str( myForm:avaluen[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
      ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:ainputmask[j] ) > 0
           Output += "INPUTMASK " + myForm:ainputmask[j] +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:adynamicbackcolor[j] ) > 0
           Output += 'DYNAMICBACKCOLOR ' + myForm:adynamicbackcolor[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:adynamicforecolor[j] ) > 0
           Output += 'DYNAMICFORECOLOR ' + myForm:adynamicforecolor[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:acolumncontrols[j] ) > 0
           Output += 'COLUMNCONTROLS ' + myForm:acolumncontrols[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aondblclick[j] ) > 0
          Output += 'ON DBLCLICK ' + myForm:aondblclick[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonheadclick[j] ) > 0
           Output += 'ON HEADCLICK ' + myForm:aonheadclick[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:aoneditcell[j] ) > 0
           Output += 'ON EDITCELL ' + myForm:aoneditcell[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonappend[j] ) > 0
           Output += 'ON APPEND ' + myForm:aonappend[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:awhen[j] ) > 0
           Output += 'WHEN ' + myForm:awhen[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:avalid[j] ) > 0
           Output += 'VALID ' + myForm:avalid[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:avalidmess[j] ) > 0
           Output += 'VALIDMESSAGES ' + myForm:avalidmess[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:areadonlyb[j] ) > 0
        Output += 'READONLY ' + myForm:areadonlyb[j] + ' ;' + CRLF
     ENDIF
     IF myForm:alock[j]
        Output += 'LOCK' + ' ;' + CRLF
     ENDIF
     IF myForm:adelete[j]
        Output += 'DELETE' + ' ;' + CRLF
     ENDIF
       IF myForm:ainplace[j]
        Output += 'INPLACE' + ' ;' + CRLF
     ENDIF
       IF myForm:aedit[j]
        Output += 'EDIT' + ' ;' + CRLF
     ENDIF

     IF myForm:anolines[j]
        Output += 'NOLINES' + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aimage[j] ) > 0
           Output += 'IMAGE ' + myForm:aimage[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:ajustify[j] ) > 0
           Output += 'JUSTIFY ' + (myForm:ajustify[j]) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonenter[j] ) > 0
          Output += 'ON ENTER ' + myForm:aonenter[j] + ' ;' + CRLF
     ENDIF

      IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:aappend[j]
        Output += 'APPEND' + ' ;' + CRLF
     ENDIF

     Output += CRLF + CRLF
      ENDIF
   IF myForm:actrltype[j] == 'IMAGE'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' IMAGE ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:aaction[j] ) > 0
         Output += 'ACTION ' + myForm:aaction[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:apicture[j] ) > 0
         Output += 'PICTURE ' + '"' + myForm:apicture[j] + '" ;' + CRLF
        ELSE
         Output += 'PICTURE "demo.bmp"' + ' ;' + CRLF
     ENDIF
     ****
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF

     IF myForm:astretch[j]
        Output += 'STRETCH ' + ' ;' + CRLF
     ELSE
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF

     Output += CRLF + CRLF

   ENDIF
   IF myForm:actrltype[j] == 'TIMER'
     Output += '*****@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' TIMER ' + myForm:aname[j] + '  ' + CRLF
      Output += 'DEFINE TIMER ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF myForm:avaluen[j] > 999
         Output += 'INTERVAL ' + LTrim( Str( myForm:avaluen[j] ) ) + ' ;' +  CRLF
        ELSE
          Output += 'INTERVAL ' + LTrim( Str( 1000 ) ) + ' ;' +  CRLF
     ENDIF
     IF Len( myForm:aaction[j] ) > 0
         Output += 'ACTION ' + myForm:aaction[j] + ' ;' + CRLF
     ELSE
          Output += 'ACTION ' + ' _dummy() ' + ' ;' + CRLF
     ENDIF
     Output += ' &&&& ROW ' + LTrim( Str( Row ) ) + ' ;' + CRLF
     Output += ' &&&& COL ' + LTrim( Str( Col ) ) + ' ;' + CRLF
     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'ANIMATE'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' ANIMATEBOX ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += ' WIDTH ' + LTrim(Str( Width))  + ' ;' + CRLF
     Output += ' HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:afile[j] ) > 0
       Output += 'FILE ' + '"' + myForm:afile[j] + '" ;' + CRLF
     ENDIF
     IF myForm:aautoplay[j]
           Output += 'AUTOPLAY ' + ' ;' + CRLF
     ENDIF
     IF myForm:acenter[j]
           Output += 'CENTER ' + ' ;' + CRLF
     ENDIF
     IF myForm:atransparent[j]
           Output += 'TRANSPARENT ' + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'DATEPICKER'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' DATEPICKER ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:avalue[j] ) > 0
         Output += "VALUE " + myForm:avalue[j] + "  ;" + CRLF
     ENDIF
     IF Len( myForm:afield[j] ) > 0
         Output += 'FIELD ' + myForm:afield[j] + ' ;' + CRLF
     ENDIF
     Output += ' WIDTH ' + LTrim(Str( Width))  + ' ;' + CRLF
     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
      ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:ashownone[j]
           Output += 'SHOWNONE ' + ' ;' + CRLF
     ENDIF
     IF myForm:aupdown[j]
           Output += 'UPDOWN ' + ' ;' + CRLF
     ENDIF

     IF myForm:arightalign[j]
           Output += 'RIGHTALIGN ' + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonenter[j] ) > 0
           Output += 'ON ENTER ' + myForm:aonenter[j] + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += CRLF + CRLF

   ENDIF
   IF myForm:actrltype[j] == 'TEXT'
     cFontname   := myForm:afontname[j]
     nFontsize   := myForm:afontsize[j]
     ctooltip    := myForm:atooltip[j]
     nmaxlength :=  myForm:amaxlength[j]
     luppercase := myForm:auppercase[j]
     llowercase := myForm:alowercase[j]
     lrightalign := myForm:arightalign[j]
     lpassword := myForm:apassword[j]
     lnumeric := myForm:anumeric[j]
     cinputmask := myForm:ainputmask[j]
     cFormat := myForm:afields[j]
     conenter := myForm:aonenter[j]
     conchange := myForm:aonchange[j]
     congotfocus := myForm:aongotfocus[j]
     conlostfocus := myForm:aonlostfocus[j]
     nFocusedPos := myForm:afocusedpos[j] // pb
     cvalid := myForm:avalid[j]
     cwhen := myForm:awhen[j]

     IF Len( myForm:atooltip[j] ) > 0
        ctooltip :=  "TOOLTIP '" + myForm:atooltip[j] + "'" + ' ;' + CRLF
     ELSE
        ctooltip := ''
     ENDIF

     IF myForm:adate[j]
        cdate := 'DATE' + ' ;' + CRLF
     ELSE
        cdate := ''
     ENDIF

     IF myForm:amaxlength[j] > 0
        cmaxlength :=  'MAXLENGTH ' + LTrim( Str( myForm:amaxlength[j] ) ) + ' ;' + CRLF
     ELSE
        cmaxlength := ''
     ENDIF

     IF myForm:auppercase[j]
        cuppercase :=  'UPPERCASE ;' + CRLF
     ELSE
        cuppercase := ''
     ENDIF

     IF myForm:alowercase[j]
        clowercase :=  'LOWERCASE ;' + CRLF
     ELSE
        clowercase := ''
     ENDIF

     IF myForm:arightalign[j]
        crightalign :=  'RIGHTALIGN ;' + CRLF
     ELSE
        crightalign := ''
     ENDIF

     cnumeric := ''
     IF myForm:anumeric[j]
        cnumeric :=  'NUMERIC ;' + CRLF
        IF Len( myForm:ainputmask[j] ) > 0
           cnumeric = cnumeric + 'INPUTMASK ' + "'" + myForm:ainputmask[j] + "'" + ' ;' + CRLF
        ENDIF
     ELSE
        IF Len( myForm:ainputmask[j] ) > 0
           cnumeric = 'INPUTMASK ' + "'" + myForm:ainputmask[j] + "'" + ' ;' + CRLF
        ENDIF
     ENDIF

     IF Len( myForm:afields[j] ) > 0
        cFormat =  'FORMAT ' + "'" + myForm:afields[j] + "'" + ' ;' + CRLF
     ELSE
        cFormat = ""
     ENDIF

     IF myForm:apassword[j]
        cpassword :=  'PASSWORD ;' + CRLF
     ELSE
        cpassword := ''
     ENDIF

     // pb
     // si tiene el valor -2 que es el valor x defecto, no es necesario agregar esta propiedad

     cFocusedPos :=  ''
     IF myForm:afocusedpos[j] <> -2
        cFocusedPos :=  'FOCUSEDPOS ' + LTrim( Str( myForm:afocusedpos[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:avalid[j] ) > 0
        cvalid :=  'VALID ' + myForm:avalid[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:awhen[j] ) > 0
        cwhen :=  'WHEN ' + myForm:awhen[j] + ' ;' + CRLF
     ENDIF

     IF Len( myForm:aongotfocus[j] ) > 0
        congotfocus :=  'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ELSE
        congotfocus := ''
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
        conlostfocus :=  'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ELSE
        conlostfocus := ''
     ENDIF

     IF Len( myForm:aonchange[j] ) > 0
        conchange :=  'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ELSE
        conchange := ''
     ENDIF

     IF Len( myForm:aonenter[j] ) > 0
        conenter :=  'ON ENTER ' + myForm:aonenter[j] + ' ;' + CRLF
     ELSE
        conenter := ''
     ENDIF
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' TEXTBOX ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:afield[j] ) > 0
        Output += 'FIELD ' + myForm:afield[j] + ' ;' + CRLF
     ENDIF
     cValue  := myForm:avalue[j]
     IF cValue == NIL
        cvalue=""
     ENDIF
     IF Len( cValue ) > 0
        IF myForm:anumeric[j]
           Output += 'VALUE ' + cValue + ' ;' + CRLF
        ELSE
           IF myForm:adate[j]
              Output += 'VALUE ' + cValue + ' ;' + CRLF
           ELSE
              Output += 'VALUE ' + "'" + cValue + "'" + ' ;' + CRLF
           ENDIF
        ENDIF

     ENDIF
     IF myForm:areadonly[j]
        Output += 'READONLY ' + ' ;' + CRLF
     ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += cpassword

     IF Len( myForm:aFontname[j] ) > 0
        Output += 'Font ' + "'" + myForm:aFontname[j] + "'" + ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
        Output += 'size ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF

     Output += cTooltip
     Output += cnumeric

     Output += cFormat

     Output += cdate
     Output += cMaxlength
     Output += cUppercase

     Output += congotfocus
     Output += conlostfocus
     Output += conchange
     Output += conenter
     Output += crightalign

     IF myForm:anotabstop[j]
        Output += ' NOTABSTOP ' + ' ;' + CRLF
     ENDIF

     Output += cFocusedPos   // pb

     Output += cvalid
     Output += cwhen

     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'EDIT'
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' EDITBOX ' + myForm:aName[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:afield[j] ) > 0
        Output += 'FIELD ' + myForm:afield[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:avalue[j] ) > 0
        Output += 'VALUE ' + "'" + myForm:avalue[j] + "'" + ' ;' + CRLF
     ENDIF
     IF myForm:areadonly[j]
        Output += 'READONLY ' + ' ;' + CRLF
     ENDIF

     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF

     IF myForm:amaxlength[j] > 0
        Output += 'MAXLENGTH ' + LTrim( Str( myForm:amaxlength[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:abreak[j]
        Output += 'BREAK ' + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
     IF myForm:anovscroll[j]
        Output += 'NOVSCROLL ' + ' ;' + CRLF
     ENDIF
     IF myForm:anohscroll[j]
        Output += 'NOHSCROLL ' + ' ;' + CRLF
     ENDIF

      Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'RICHEDIT'
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' RICHEDITBOX ' + myForm:aName[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:afield[j] ) > 0
        Output += 'FIELD ' + myForm:afield[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:avalue[j] ) > 0
        Output += 'VALUE ' + "'" + myForm:avalue[j] + "'" + ' ;' + CRLF
     ENDIF
     IF myForm:areadonly[j]
        Output += 'READONLY ' + ' ;' + CRLF
     ENDIF

     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF

     IF myForm:amaxlength[j] > 0
        Output += 'MAXLENGTH ' + LTrim( Str( myForm:amaxlength[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:abreak[j]
        Output += 'BREAK ' + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF

     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF

      Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'IPADDRESS'

      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' IPADDRESS ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:avalue[j] ) > 0
        Output += 'VALUE ' + myForm:avalue[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF

     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
      Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'HYPERLINK'
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' HYPERLINK ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:avalue[j] ) > 0
        Output += 'VALUE ' + "'" + myForm:avalue[j] + "'" + ' ;' + CRLF
     ELSE
        Output += 'VALUE ' + " 'ooHG IDE + Home ' " + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aaddress[j] ) > 0
        Output += 'ADDRESS ' + "'" + myForm:aaddress[j] + "'" + ' ;' + CRLF
     ELSE
        Output += 'ADDRESS ' + "'http://sistemascvc.tripod.com'" + ' ;' + CRLF
     ENDIF
     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF

     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:ahandcursor[j]
        Output += 'HANDCURSOR ' + ' ;' + CRLF
     ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'MONTHCALENDAR'
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' MONTHCALENDAR ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:avalue[j] ) > 0
        Output += 'VALUE ' + myForm:avalue[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF

     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF

     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
      Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'LABEL'

      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' LABEL ' + myForm:aname[j] + ' ;' + CRLF
      IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
      IF myForm:aautoplay[j]
         Output += 'AUTOSIZE ;' + CRLF
      ELSE
         Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
         Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
      ENDIF
      IF Len( myForm:aValue[j] ) > 0
         Output += 'VALUE ' + "'" + myForm:avalue[j] + "'" + ' ;' + CRLF
      ENDIF
      IF Len( myForm:aaction[j] ) > 0
         Output += 'ACTION ' + myForm:aaction[j] + ' ;' + CRLF
      ENDIF
      IF Len( myForm:aFontname[j] ) > 0
         Output += 'FONT ' + "'" + myForm:afontname[j] + "'" + ' ;' + CRLF
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF      // MigSoft
      ENDIF
      IF Len( myForm:abackcolor[j] ) > 0 .AND. myForm:abackcolor[j] # 'NIL'
         Output += 'BACKCOLOR ' + myForm:abackcolor[j] + ' ;' + CRLF
      ENDIF
   /*
      IF Len( afontcolor[j] ) > 0
         Output += 'FONTCOLOR ' + "'" + afontcolor[j] + "'" + ' ;' + CRLF
      ENDIF
   */
      IF myForm:abold[j]
         Output += 'BOLD ;' + CRLF
      ENDIF
      IF myForm:ahelpid[j] > 0
        Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
      ENDIF
      IF myForm:atransparent[j]
         Output += 'TRANSPARENT ' + ' ;' + CRLF
      ENDIF
      IF myForm:acenteralign[j]
         Output += 'CENTERALIGN ' + ' ;' + CRLF
      ENDIF
      IF myForm:arightalign[j]
         Output += 'RIGHTALIGN ' + ' ;' + CRLF
      ENDIF
      IF myForm:aclientedge[j]
         Output += 'CLIENTEDGE ' + ' ;' + CRLF
      ENDIF
      Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'PLAYER'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' PLAYER ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     Output += 'FILE "' + myForm:afile[j] + '"' +  ' ;' + CRLF
     IF myForm:ahelpid[j] > 0
       Output += 'HELPID ' + LTrim( Str( ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'PROGRESSBAR'
       Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' PROGRESSBAR ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:arange[j] ) > 0
        Output += 'RANGE ' + myForm:arange[j] + ' ;' + CRLF
     ENDIF

     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:atooltip[j] ) > 0
        Output += 'TOOLTIP ' + "'" + myForm:atooltip[j] + "'" + ' ;' + CRLF
     ENDIF
     IF myForm:avertical[j]
        Output += 'VERTICAL ' + ' ;' + CRLF
     ENDIF
     IF myForm:asmooth[j]
        Output += 'SMOOTH ' + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
        Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'RADIOGROUP'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' RADIOGROUP ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:aitems[j] ) > 0
           Output += "OPTIONS  " + myForm:aitems[j] + "  ;" + CRLF
     ENDIF

     IF myForm:avaluen[j] > 0
           Output += 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += 'WIDTH  ' + LTrim(Str( Width)) + ' ;' + CRLF
     IF myForm:aspacing[j] > 0
           Output += "SPACING " + LTrim( Str( myForm:aspacing[j] ) ) +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF

     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF myForm:atransparent[j]
        Output += 'TRANSPARENT ' + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'SLIDER'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' SLIDER ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
      IF Len( myForm:arange[j] ) > 0
         Output += 'RANGE ' + myForm:arange[j] + ' ;' + CRLF
      ELSE
         Output += 'RANGE 1, 100' + ' ;' + CRLF
      ENDIF

      IF myForm:avaluen[j] > 0
         Output += 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) ) + ' ;' + CRLF
      ENDIF

      Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
      Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
      IF Len( myForm:atooltip[j] ) > 0
         Output += 'TOOLTIP ' + "'" + myForm:atooltip[j] + "'" + ' ;' + CRLF
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
      ENDIF
      IF myForm:avertical[j]
         Output += ' VERTICAL ' + ' ;' + CRLF
      ENDIF
     IF myForm:anoticks[j]
         Output += 'NOTICKS ' + ' ;' + CRLF
      ENDIF
     IF myForm:aboth[j]
         Output += 'BOTH ' + ' ;' + CRLF
      ENDIF
     IF myForm:atop[j]
         Output += 'TOP ' + ' ;' + CRLF
      ENDIF

     IF myForm:aleft[j]
         Output += 'LEFT ' + ' ;' + CRLF
     ENDIF

     IF myForm:ahelpid[j] > 0
        Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'SPINNER'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' SPINNER ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:arange[j] ) > 0
        Output += 'RANGE ' + myForm:arange[j] + ' ;' + CRLF
     ENDIF

     IF myForm:avaluen[j] > 0
        Output += 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) ) + ' ;' + CRLF
     ENDIF

     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF Len( myForm:afontname[j] ) > 0
           Output += "FONT " + "'" + myForm:afontname[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:afontsize[j] > 0
           Output += 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) ) + ' ;' + CRLF
     ENDIF
     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
        Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
        Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
        Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
        Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
     IF myForm:awrap[j]
        Output += 'WRAP ' + ' ;' + CRLF
     ENDIF
     IF myForm:areadonly[j]
        Output += 'READONLY ' + ' ;' + CRLF
     ENDIF
     IF myForm:aincrement[j] > 0
        Output += 'INCREMENT ' + LTrim( Str( myForm:aincrement[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'PICCHECKBUTT'
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' CHECKBUTTON ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:apicture[j] ) > 0
         Output += 'PICTURE ' + "'" + myForm:apicture[j] + "'" + ' ;' + CRLF
     ELSE
         Output += 'PICTURE ' + "'" + "" + "'" + ' ;' + CRLF
     ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
      Output += 'HEIGHT ' + LTrim(Str( Height)) + ';' + CRLF
     IF myForm:avaluel[j]
        Output += 'VALUE .T.' + ' ;' + CRLF
     ELSE
        Output += 'VALUE .F.' + ' ;' + CRLF
     ENDIF

     IF Len( myForm:atooltip[j] ) > 0
           Output += "TOOLTIP " + "'" + myForm:atooltip[j] + "'" +  ' ;' + CRLF
     ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonchange[j] ) > 0
           Output += 'ON CHANGE ' + myForm:aonchange[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aongotfocus[j] ) > 0
           Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
     ENDIF
     IF Len( myForm:aonlostfocus[j] ) > 0
           Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
           Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
      ENDIF
     Output += + CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'PICBUTT'
     Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' BUTTON ' + myForm:aname[j] + ' ;' + CRLF
     IF ! Empty(myForm:acobj[j])
         Output += 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
      ENDIF
     IF Len( myForm:apicture[j] ) > 0
         Output += "PICTURE " + "'" + myForm:apicture[j] + "'" + ';' + CRLF
     ELSE
         Output += "PICTURE " + "'" + "" + "'" + " ;" + CRLF
     ENDIF
     IF Len( myForm:aaction[j] ) > 0
        Output += 'ACTION ' + myForm:aaction[j] + ' ;' + CRLF
     ELSE
        Output += 'ACTION ' + 'MsgInfo("Button Pressed")' + CRLF
     ENDIF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF

     IF Len( myForm:atooltip[j] ) > 0
         Output += 'TOOLTIP ' + "'" + myForm:atooltip[j] + "'" + ' ;' + CRLF
     ENDIF

     IF myForm:aflat[j]
         Output += 'FLAT ' + ' ;' + CRLF
      ENDIF

      IF Len( myForm:aongotfocus[j] ) > 0
         Output += 'ON GOTFOCUS ' + myForm:aongotfocus[j] + ' ;' + CRLF
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += 'ON LOSTFOCUS ' + myForm:aonlostfocus[j] + ' ;' + CRLF
      ENDIF
     IF myForm:anotabstop[j]
        Output += 'NOTABSTOP ' + ' ;' + CRLF
     ENDIF
     IF myForm:ahelpid[j] > 0
         Output += 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) ) + ' ;' + CRLF
     ENDIF
     Output += CRLF + CRLF
   ENDIF
   IF myForm:actrltype[j] == 'FRAME'
      Output += '@ ' + LTrim( Str( Row ) ) + ', ' + LTrim( Str( Col ) ) + ' FRAME ' + myForm:aname[j]  + ' ;' + CRLF
     Output += 'CAPTION ' + '"' + myForm:acaption[j] + '"' + ' ;' + CRLF
     Output += 'WIDTH ' + LTrim(Str( Width)) + ' ;' + CRLF
     Output += 'HEIGHT ' + LTrim(Str( Height)) + ' ;' + CRLF
     IF myForm:aopaque[j]
       Output += 'OPAQUE ' + ' ;' + CRLF
     ENDIF
     IF myForm:atransparent[j]
        Output += 'TRANSPARENT ' + ' ;' + CRLF
     ENDIF
      Output += CRLF + CRLF
   ENDIF
   IF myForm:aname[j] # NIL
      name := myForm:aname[j]
   ENDIF
   IF UPPER(myForm:actrltype[j])$'MONTHCALENDAR HYPLINK IPADDRESS TEXT CHECKBOX BUTTON CHECKBTN COMBO DATEPICKER EDIT FRAME GRID IMAGE LABEL LIST PLAYER PROGRESSBAR RADIOGROUP SLIDER SPINNER ANIMATE BROWSE TAB RICHEDIT TIMER PICBUTT PICCHECKBUTT' .AND. j > 1
      Output += CRLF
     IF .not. myForm:aenabled[j]
        Output += mlyform + '.' + name + '.enabled := .F.' + CRLF
     ENDIF
     IF myForm:actrltype[j] # 'TIMER'
        IF .not. myForm:avisible[j]
           Output += mlyform + '.' + name + '.visible := .F.' + CRLF
        ENDIF
     ENDIF
   ENDIF
   IF UPPER(myForm:actrltype[j])$'LABEL ANIMATE' .AND. j > 1
      Output += CRLF
      IF Len( myForm:atooltip[j] ) > 0
         Output += mlyform + '.' + name + '.tooltip := ' + "'" + myForm:atooltip[j] + "' " + CRLF
      ENDIF
   ENDIF
   IF  UPPER(myForm:actrltype[j])$'MONTHCALENDAR HYPLINK TEXT LABEL FRAME EDIT DATEPICKER BUTTON CHECKBOX LIST COMBO CHECKBTN GRID SPINNER BROWSE RADIOGROUP RICHEDIT TREE' .AND. j > 1
     IF myForm:afontitalic[j]
         Output += mlyform + '.' + name + '.fontitalic := .T.' + CRLF
     ENDIF
     IF myForm:afontunderline[j]
         Output += mlyform + '.' + name + '.fontunderline := .T.' + CRLF
     ENDIF
     IF myForm:afontstrikeout[j]
         Output += mlyform + '.' + name + '.fontstrikeout := .T.' + CRLF
     ENDIF
     IF myForm:abold[j]
         Output += mlyform + '.' + name + '.fontbold := .T.' + CRLF
     ENDIF
   ENDIF
   IF UPPER(myForm:actrltype[j])$'HYPLINK LABEL FRAME TEXT EDIT DATEPICKER BUTTON CHECKBOX LIST COMBO CHECKBTN GRID SPINNER BROWSE RADIOGROUP PROGRESSBAR RICHEDIT TREE' .AND. j > 1
     IF Len( myForm:afontcolor[j] ) > 0
        Output += mlyform + '.' + name + '.fontcolor := ' + trim(myForm:afontcolor[j]) + CRLF
     ENDIF
   ENDIF
   IF UPPER(myForm:actrltype[j])$'HYPLINK SLIDER FRAME TEXT EDIT DATEPICKER BUTTON CHECKBOX LIST COMBO CHECKBTN GRID SPINNER BROWSE RADIOGROUP PROGRESSBAR RICHEDIT' .AND. j > 1
     IF Len( myForm:abackcolor[j] ) > 0 .AND. myForm:abackcolor[j] # 'NIL'
       Output += mlyform + '.' + name + '.backcolor := ' + trim(myForm:abackcolor[j]) + CRLF
     ENDIF
   ENDIF
   IF UPPER(myForm:actrltype[j])$'FRAME' .AND. j > 1
    IF Len( myForm:afontname[j] ) > 0
       Output += mlyform + '.' + name + '.fontname := ' + "'" + trim(myForm:afontname[j]) + "'" + CRLF
    ENDIF
    IF myForm:afontsize[j] > 0
       Output += mlyform + '.' + name + '.fontsize := ' + LTrim( Str( myForm:afontsize[j] ) ) + CRLF
    ENDIF
   ENDIF
   Output +=CRLF
RETURN Output

*---------------------------
FUNCTION myascan( cName )
*---------------------------
LOCAL ai, nhandle := 0, l

   l := Len( Form_1:acontrols )
   FOR ai := 1 TO l
      IF Lower( Form_1:acontrols[ai]:Name ) == Lower( cName )
         nhandle := ai
         EXIT
      ENDIF
   NEXT ai
RETURN nhandle
