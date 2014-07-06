/*
 * $Id: saveform.prg,v 1.8 2014-07-06 19:37:51 fyurisich Exp $
 */

/////#include 'oohg.ch'

/*
   All keywords, properties and control names must be followed by a space.
*/

DECLARE WINDOW Form_1

*------------------------------------------------------------------------------*
METHOD Save( lSaveAs ) CLASS TFORM1
*------------------------------------------------------------------------------*
LOCAL i, h, BaseRow, BaseCol, TitleHeight, BorderWidth, BorderHeight, cName, nRow, nCol, nWidth, nHeight, Output, j, p, k, m, jn, npos, mlyform
LOCAL swpop, lDeleted, archivo, signiv, niv, nnivaux, nSpacing := 3

   IF ! IsWindowDefined( Form_1 )
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

//***************************  Header
   Output := '' + CRLF
   Output += '* ooHG IDE Plus form generated code' + CRLF
   Output += '* (c)2003-2014 Ciro Vargas Clemow <pcman2010@yahoo.com > ' + CRLF
   Output += CRLF

//***************************  Form start
   Output += 'DEFINE WINDOW TEMPLATE ;' + CRLF
   Output += Space( nSpacing ) + 'AT ' + LTrim( Str( BaseRow ) ) + ', ' + LTrim( Str( BaseCol ) ) + ' ;' + CRLF
   Output += IIF( ! Empty( myForm:cfobj ), Space( nSpacing ) + 'OBJ ' + AllTrim( myForm:cfobj ) + " ;" + CRLF, '')
   Output += Space( nSpacing ) + 'WIDTH ' + LTrim( Str( BaseWidth ) ) + ' ;' + CRLF
   Output += Space( nSpacing ) + 'HEIGHT ' + LTrim( Str( BaseHeight ) )
   IF myForm:nfvirtualw > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'VIRTUAL WIDTH ' + LTrim( Str( myForm:nfvirtualw ) )
   ENDIF
   IF myForm:nfvirtualh > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'VIRTUAL HEIGHT ' + LTrim( Str( myForm:nfvirtualh ) )
   ENDIF
   IF Len( myForm:cftitle ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'TITLE ' + "'" + AllTrim( myForm:cftitle ) + "'"
   ENDIF
   IF Len( myForm:cficon ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ICON ' + "'" + AllTrim( myForm:cficon ) + "'"
   ENDIF
   Output += IIF( myForm:lfmain, ' ;' + CRLF + Space( nSpacing ) + 'MAIN ', '' )
   Output += IIF( myForm:lfsplitchild, ' ;' + CRLF + Space( nSpacing ) + 'SPLITCHILD ', '' )
   Output += IIF( myForm:lfchild, ' ;' + CRLF + Space( nSpacing ) + 'CHILD ', '' )
   Output += IIF( myForm:lfmodal, ' ;' + CRLF + Space( nSpacing ) + 'MODAL ', '' )
   Output += IIF( myForm:lfnoshow, ' ;' + CRLF + Space( nSpacing ) + 'NOSHOW ', '' )
   Output += IIF( myForm:lftopmost, ' ;' + CRLF + Space( nSpacing ) + 'TOPMOST ', '' )
   Output += IIF( myForm:lfnoautorelease, ' ;' + CRLF + Space( nSpacing ) + 'NOAUTORELEASE ', '' )
   Output += IIF( myForm:lfnominimize, ' ;' + CRLF + Space( nSpacing ) + 'NOMINIMIZE ', '' )
   Output += IIF( myForm:lfnomaximize, ' ;' + CRLF + Space( nSpacing ) + 'NOMAXIMIZE ', '' )
   Output += IIF( myForm:lfnosize, ' ;' + CRLF + Space( nSpacing ) + 'NOSIZE ', '' )
   Output += IIF( myForm:lfnosysmenu, ' ;' + CRLF + Space( nSpacing ) + 'NOSYSMENU ', '' )
   Output += IIF( myForm:lfnocaption, ' ;' + CRLF + Space( nSpacing ) + 'NOCAPTION ', '' )
   IF Len( myForm:cfcursor ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'CURSOR ' + "'" + AllTrim( myForm:cfcursor ) + "'"
   ENDIF
   IF Len( myForm:cfoninit ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON INIT ' + AllTrim( myForm:cfoninit )
   ENDIF
   IF Len( myForm:cfonrelease ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RELEASE ' + AllTrim( myForm:cfonrelease )
   ENDIF
   IF Len( myForm:cfoninteractiveclose ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON INTERACTIVECLOSE ' + AllTrim( myForm:cfoninteractiveclose )
   ENDIF
   IF Len( myForm:cfonmouseclick ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSECLICK ' + AllTrim( myForm:cfonmouseclick )
   ENDIF
   IF Len( myForm:cfonmousedrag ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSEDRAG ' + AllTrim( myForm:cfonmousedrag )
   ENDIF
   IF Len( myForm:cfonmousemove ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSEMOVE ' + AllTrim( myForm:cfonmousemove )
   ENDIF
   IF Len( myForm:cfonsize ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SIZE ' + AllTrim( myForm:cfonsize )
   ENDIF
   IF Len( myForm:cfonpaint ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON PAINT ' + AllTrim( myForm:cfonpaint )
   ENDIF
   IF myForm:cfbackcolor # 'NIL' .AND. Len( myForm:cfbackcolor ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'BACKCOLOR ' + AllTrim( myForm:cfbackcolor )
   ENDIF
   IF Len( myForm:cffontname ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'FONT ' + "'" + AllTrim( myForm:cffontname ) + "'"
   ENDIF
   IF myForm:nffontsize > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'SIZE ' + LTrim( Str( myForm:nffontsize ) )
   ELSE
      Output += ' ;' + CRLF + Space( nSpacing ) + 'SIZE ' + LTrim( Str( 10 ) )
   ENDIF
   Output += IIF( myForm:lfgrippertext, ' ;' + CRLF + Space( nSpacing ) + 'GRIPPERTEXT ', '' )
   IF Len( myForm:cfnotifyicon ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'NOTIFYICON ' + "'" + AllTrim( myForm:cfnotifyicon ) + "'"
   ENDIF
   IF Len( myForm:cfnotifytooltip ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'NOTIFYTOOLTIP ' + "'" + AllTrim( myForm:cfnotifytooltip ) + "'"
   ENDIF
   IF Len( myForm:cfonnotifyclick ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON NOTIFYCLICK ' + AllTrim( myForm:cfonnotifyclick )
   ENDIF
   Output += IIF( myForm:lfbreak, ' ;' + CRLF + Space( nSpacing ) + 'BREAK ', '')
   Output += IIF( myForm:lffocused, ' ;' + CRLF + Space( nSpacing ) + ' FOCUSED ', '')
   IF Len( myForm:cfongotfocus ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON GOTFOCUS ' + AllTrim( myForm:cfongotfocus )
   ENDIF
   IF Len( myForm:cfonlostfocus ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON LOSTFOCUS ' + AllTrim( myForm:cfonlostfocus )
   ENDIF
   IF Len( myForm:cfonscrollup ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLUP ' + AllTrim( myForm:cfonscrollup )
   ENDIF
   IF Len( myForm:cfonscrolldown ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLDOWN ' + AllTrim( myForm:cfonscrolldown )
   ENDIF
   IF Len( myForm:cfonscrollright ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLRIGHT ' + AllTrim( myForm:cfonscrollright )
   ENDIF
   IF Len( myForm:cfonscrollleft ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLLEFT ' + AllTrim( myForm:cfonscrollleft )
   ENDIF
   IF Len( myForm:cfonhscrollbox ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON HSCROLLBOX ' + AllTrim( myForm:cfonhscrollbox )
   ENDIF
   IF Len( myForm:cfonvscrollbox ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON VSCROLLBOX ' + AllTrim( myForm:cfonvscrollbox )
   ENDIF
   Output += IIF( myForm:lfhelpbutton, ' ;' + CRLF + Space( nSpacing ) + 'HELPBUTTON ', '')
   IF Len( myForm:cfonmaximize ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MAXIMIZE ' + AllTrim( myForm:cfonmaximize )
   ENDIF
   IF Len( myForm:cfonminimize ) > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MINIMIZE ' + AllTrim( myForm:cfonminimize )
   ENDIF
   Output += CRLF + CRLF
/*
   TODO: Add this properties

   [ <modalsize: MODALSIZE> ] ;
   [ <mdi: MDI> ] ;
   [ <mdiclient: MDICLIENT> ] ;
   [ <mdichild: MDICHILD> ] ;
   [ <internal: INTERNAL> ] ;
   [ ON MOVE <MoveProcedure> ] ;
   [ ON RESTORE <RestoreProcedure> ] ;
   [ <rtl: RTL> ] ;
   [ <clientarea: CLIENTAREA> ] ;
   [ ON RCLICK <RClickProcedure> ] ;
   [ ON MCLICK <MClickProcedure> ] ;
   [ ON DBLCLICK <DblClickProcedure> ] ;
   [ ON RDBLCLICK <RDblClickProcedure> ] ;
   [ ON MDBLCLICK <MDblClickProcedure> ] ;
   [ MINWIDTH <minwidth> ] ;
   [ MAXWIDTH <maxwidth> ] ;
   [ MINHEIGHT <minheight> ] ;
   [ MAXHEIGHT <maxheight> ] ;
   [ BACKIMAGE <backimage> [ <stretch: STRETCH> ] ] ;
*/

//***************************  Statusbar
   wvalor := .F.
   IF myForm:lsstat
      wvalor := .T.
   ENDIF
   IF wvalor
      // Must end with a space
      Output += Space( nSpacing ) + 'DEFINE STATUSBAR '
      IF ! Empty( myForm:cscobj )
         Output += ';' + CRLF
         Output += Space( nSpacing * 2 ) + 'OBJ ' + AllTrim( myForm:cscobj )
      ENDIF
      Output += CRLF

      IF Len( myForm:cscaption ) > 0
         Output += Space( nSpacing * 2 ) + 'STATUSITEM ' + "'" + AllTrim( myForm:cscaption ) + "'"
      ELSE
         Output += Space( nSpacing * 2 ) + 'STATUSITEM ' + "'" + "'"
      ENDIF
      IF myForm:nswidth > 0
         Output += ' ;' + CRLF
         Output += Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( myForm:nswidth ) )
      ENDIF
      IF Len( myForm:csaction ) > 0
         Output += ' ;' + CRLF
         Output += Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( myForm:csaction )
      ENDIF
      IF Len( myForm:csicon ) > 0
         Output += ' ;' + CRLF
         Output += Space( nSpacing * 3 ) + 'ICON ' + "'" + AllTrim( myForm:csicon ) + "'"
      ENDIF
      IF myForm:lsflat
         Output += ' ;' + CRLF
         Output += Space( nSpacing * 3 ) + 'FLAT '
      ENDIF
      IF myForm:lsraised
         Output += ' ;' + CRLF
         Output += Space( nSpacing * 3 ) + 'RAISED '
      ENDIF
      IF Len( myForm:cstooltip ) > 0
         Output += ' ;' + CRLF
         Output += Space( nSpacing * 3 ) + 'TOOLTIP ' + "'" + AllTrim( myForm:cstooltip ) + "'"
      ENDIF
      Output += CRLF

      IF myForm:lskeyboard
         Output += Space( nSpacing * 2 ) + 'KEYBOARD ' + CRLF
      ENDIF

      IF myForm:lsdate
         Output += Space( nSpacing * 2 ) + 'DATE ;' + CRLF
         Output += Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( 80 ) ) + CRLF
      ENDIF
/*
      IF Len( csdateaction ) > 0
         Output += Space( nSpacing * 2 ) + 'ACTION ' + AllTrim( csdateaction ) + ' ;' + CRLF
      ENDIF
      IF Len( csdatetooltip ) > 0
         Output += Space( nSpacing * 2 ) + 'TOOLTIP ' + '"' + AllTrim( csdatetooltip ) + '" ;' + CRLF
      ENDIF
*/

      IF myForm:lstime
         Output += Space( nSpacing * 2 ) + 'CLOCK ;' + CRLF
         Output += Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( 80 ) ) + CRLF
      ENDIF
/*
      IF Len( cstimeaction ) > 0
         Output += Space( nSpacing * 2 ) + 'ACTION ' + AllTrim( cstimeaction ) + ' ;' + CRLF
      ENDIF
      IF Len( cstimetooltip ) > 0
         Output += Space( nSpacing * 2 ) + 'TOOLTIP ' + '"' + AllTrim( cstimetooltip ) + '" ;' + CRLF
      ENDIF
*/

      Output += Space( nSpacing ) + 'END STATUSBAR ' + CRLF
      Output += CRLF
   ENDIF
/*
   TODO: Add this properties

   [ FONT <fontname> ] ;
   [ SIZE <fontsize> ] ;
   [ <bold: BOLD> ] ;
   [ <top: TOP> ] ;
   [ <italic: ITALIC> ] ;
   [ <underline: UNDERLINE> ] ;
   [ <strikeout: STRIKEOUT> ] ;
   [ MESSAGE <msg> ] ;
   [ <noautoadjust: NOAUTOADJUST> ] ;
   [ WIDTH <nSize> ] ;
   [ ACTION <uAction> ] ;
   [ TOOLTIP <cToolTip> ] ;
   [ <align: LEFT, CENTER, RIGHT> ] ;

#xcommand STATUSITEM [ <cMsg> ] ;
      [ WIDTH <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ ICON <cBitmap> ] ;
      [ <styl:FLAT, RAISED> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ <align:LEFT, CENTER, RIGHT> ] ;

#xcommand DATE ;
      [ <w: WIDTH > <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ <styl:FLAT, RAISED> ] ;
      [ <align:LEFT, CENTER, RIGHT> ] ;

#xcommand CLOCK ;
      [ WIDTH <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ <ampm: AMPM> ] ;
      [ ICON <cBitmap> ] ;
      [ <styl:FLAT, RAISED> ] ;
      [ <align:LEFT, CENTER, RIGHT> ] ;

#xcommand KEYBOARD ;
      [ WIDTH <nSize> ] ;
      [ ACTION <uAction> ] ;
      [ TOOLTIP <cToolTip> ] ;
      [ ICON <cBitmap> ] ;
      [ <styl:FLAT, RAISED> ] ;
      [ <align:LEFT, CENTER, RIGHT> ] ;
*/

//***************************  Main menu
   CLOSE DATABASES
   lDeleted := SET( _SET_DELETED, .T. )

   IF File( myForm:cfname + '.mnm' )
      archivo := myForm:cfname + '.mnm'
      SELECT 10
      USE &archivo EXCLUSIVE ALIAS menues
      GO TOP
      IF ! Eof()
         Output += Space( nSpacing ) + 'DEFINE MAIN MENU ' + CRLF
         swpop := 0
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
               IF Lower( AllTrim( menues->auxit ) ) == 'separator'
                  Output += Space( nSpacing * ( menues->level + 2 ) ) + 'SEPARATOR ' + CRLF
               ELSE
                  Output += Space( nSpacing * ( menues->level + 2 ) ) + 'POPUP ' + "'" + AllTrim( menues->auxit ) + "'" + IIF( AllTrim( menues->named ) # '', " NAME " + "'" + AllTrim( menues->named ) + "'", '') + CRLF
                  IF menues->enabled == 'X'
// This is needed to read DISABLED clause         TODO: Add DISABLE clause to menus
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "// " + mlyform + '.' + AllTrim( menues->named ) + '.enabled := .F.' + CRLF
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'enabled', .F.)" + CRLF
                  ENDIF
                  swpop ++
               ENDIF
            ELSE
               IF Lower( AllTrim( menues->auxit ) ) == 'separator'
                  Output += Space( nSpacing * ( menues->level + 2 ) ) + 'SEPARATOR ' + CRLF
               ELSE
                  Output += Space( nSpacing * ( menues->level + 2 ) ) + 'ITEM ' + "'" + AllTrim( menues->auxit ) + "'" + ' ACTION ' + IIF( Len( AllTrim( menues->action ) ) # 0, AllTrim( menues->action ), "MsgBox( 'item' )") + ' '
                  IF AllTrim( menues->named ) == ''
                     Output += '' + IIF( AllTrim( menues->image ) # '', ' IMAGE ' + "'" + AllTrim( menues->image ) + "'", '') + ' ' + CRLF
                  ELSE
                     Output += "NAME " + "'" + AllTrim( menues->named ) + "'" + IIF( AllTrim( menues->image ) # '', " IMAGE " + "'" + AllTrim( menues->image ) + "'", '') + CRLF
                     IF menues->checked == 'X'
// This is needed to read CHECKED clause         TODO: Add CHECKED clause to menus
                        Output += Space( nSpacing * ( menues->level + 2 ) ) + "// " + mlyform + '.' + AllTrim( menues->named ) + '.checked := .F.' + CRLF
                        Output += Space( nSpacing * ( menues->level + 2 ) ) + "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'checked', .F.)" + CRLF
                     ENDIF
                     IF menues->enabled == 'X'
                        Output += Space( nSpacing * ( menues->level + 2 ) ) + "// " + mlyform + '.' + AllTrim( menues->named ) + '.enabled := .F.' + CRLF
                        Output += Space( nSpacing * ( menues->level + 2 ) ) + "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'enabled', .F.)" + CRLF
                     ENDIF
                  ENDIF
               ENDIF
               DO WHILE signiv < niv
                  Output += Space( nSpacing * ( niv + 1) ) + 'END POPUP ' + CRLF
                  swpop --
                  niv --
               ENDDO
            ENDIF
            SKIP
         ENDDO
         nnivaux := niv - 1
         DO WHILE swpop > 0
            nnivaux --
            Output += Space( nSpacing * ( nnivaux + 1 ) ) + 'END POPUP ' + CRLF
            swpop --
         ENDDO
         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      ENDIF
      CLOSE DATABASES
   ENDIF

//***************************  Context menu
   IF File( myForm:cfname + '.mnc' )
      archivo := myForm:cfname + '.mnc'
      SELECT 20
      USE &archivo EXCLUSIVE ALIAS menues
      GO TOP
      IF ! Eof()
         Output += Space( nSpacing ) + 'DEFINE CONTEXT MENU ' + CRLF
         DO WHILE ! Eof()
            IF Lower( AllTrim( menues->auxit ) ) == 'separator'
               Output += Space( nSpacing * ( menues->level + 2 ) ) + 'SEPARATOR ' + CRLF
            ELSE
               Output += Space( nSpacing * ( menues->level + 2 ) ) + 'ITEM ' + "'" + AllTrim( menues->auxit ) + "'" + ' ACTION ' + IIF( Len( AllTrim( menues->action ) ) # 0, AllTrim( menues->action ), "MsgBox( 'item' )")
               IF AllTrim( menues->named ) == ''
                  Output += IIF( Len( AllTrim( menues->image ) ) # 0, ' IMAGE ' + "'" + AllTrim( menues->image ) + "'", '') + CRLF
               ELSE
                  Output += " NAME " + "'" + AllTrim( menues->named ) + "'" + IIF( Len( AllTrim( menues->image ) ) # 0, " IMAGE " + "'" + AllTrim( menues->image ) + "'", '') + CRLF
                  IF menues->checked == 'X'
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "// " + mlyform + '.' + AllTrim( menues->named ) + '.checked := .F.' + CRLF
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'checked', .F.)" + CRLF
                  ENDIF
                  IF menues->enabled == 'X'
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "// " + mlyform + '.' + AllTrim( menues->named ) + '.enabled := .F.' + CRLF
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'enabled', .F.)" + CRLF
                  ENDIF
               ENDIF
            ENDIF
            SKIP
         ENDDO
         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      ENDIF
      CLOSE DATABASES
   ENDIF

//***************************  Notify menu
   IF File( myForm:cfname + '.mnn' )
      archivo := myForm:cfname + '.mnn'
      SELECT 30
      USE &archivo EXCLUSIVE ALIAS menues
      GO TOP
      IF ! Eof()
         Output += Space( nSpacing ) + 'DEFINE NOTIFY MENU ' + CRLF
         DO WHILE ! Eof()
            IF Lower( AllTrim( menues->auxit ) ) == 'separator'
                  Output += Space( nSpacing * ( menues->level + 2 ) ) + 'SEPARATOR ' + CRLF
            ELSE
               Output += Space( nSpacing * ( menues->level + 2 ) ) + 'ITEM ' + "'" + AllTrim( menues->auxit ) + "'" + ' ACTION ' + IIF( Len( AllTrim( menues->action ) ) # 0, AllTrim( menues->action ), "MsgBox( 'item' )")
               IF AllTrim( menues->named ) == ''
                  Output += IIF( Len( AllTrim( menues->image ) ) # 0, ' IMAGE ' + "'" + AllTrim( menues->image ) + "'", '') + CRLF
               ELSE
                  Output += " NAME " + "'" + AllTrim( menues->named ) + "'" + IIF( Len( AllTrim( menues->image ) ) # 0, " IMAGE " + "'" + AllTrim( menues->image ) + "'", '') + CRLF
                  IF menues->checked == 'X'
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "// " + mlyform + '.' + AllTrim( menues->named ) + '.checked := .F.' + CRLF
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'checked', .F.)" + CRLF
                  ENDIF
                  IF menues->enabled == 'X'
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "// " + mlyform + '.' + AllTrim( menues->named ) + '.enabled := .F.' + CRLF
                     Output += Space( nSpacing * ( menues->level + 2 ) ) + "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'enabled', .F.)" + CRLF
                  ENDIF
               ENDIF
            ENDIF
            SKIP
         ENDDO
         Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
      ENDIF
      CLOSE DATABASES
   ENDIF

//***************************  Toolbar
   IF File( myForm:cfname + '.tbr' )
      archivo := myForm:cfname + '.tbr'
      SELECT 40
      USE &archivo EXCLUSIVE ALIAS ddtoolbar
      GO TOP
      IF ! Eof()
         Output += Space( nSpacing ) + 'DEFINE TOOLBAR ' + AllTrim( tmytoolb:ctbname ) + ' ;' + CRLF
         Output += Space( nSpacing * 2 ) + 'BUTTONSIZE ' + LTrim( Str( tmytoolb:nwidth ) ) + ', ' + LTrim( Str( tmytoolb:nheight ) )
         Output += IIF( Len( tmytoolb:cfont ) > 0, ' ;' + CRLF + Space( nSpacing * 2 ) + 'FONT ' + "'" + AllTrim( tmytoolb:cfont ), '' )
         Output += IIF( tmytoolb:nsize > 0, ' ;' + CRLF + Space( nSpacing * 2 ) + 'SIZE ' + LTrim( Str( tmytoolb:nsize ) ), '' )
         Output += IIF( tmytoolb:lbold, ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOLD ', '' )
         Output += IIF( tmytoolb:litalic, ' ;' + CRLF + Space( nSpacing * 2 ) + 'ITALIC ', '' )
         Output += IIF( tmytoolb:lunderline, ' ;' + CRLF + Space( nSpacing * 2 ) + 'UNDERLINE ', '' )
         Output += IIF( tmytoolb:lstrikeout, ' ;' + CRLF + Space( nSpacing * 2 ) + 'STRIKEOUT ', '' )
         Output += IIF( Len( tmytoolb:ctooltip ) > 0, ' ;' + CRLF + Space( nSpacing * 2 ) + 'TOOLTIP ' + "'" + AllTrim( tmytoolb:ctooltip ) + "'", '' )
         Output += IIF( tmytoolb:lflat, ' ;' + CRLF + Space( nSpacing * 2 ) + 'FLAT ', '' )
         Output += IIF( tmytoolb:lbottom, ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOTTOM ', '' )
         Output += IIF( tmytoolb:lrighttext, ' ;' + CRLF + Space( nSpacing * 2 ) + 'RIGHTTEXT ', '' )
         Output += IIF( tmytoolb:lborder, ' ;' + CRLF + Space( nSpacing * 2 ) + 'BORDER ', '' )
         Output += CRLF + CRLF
         DO WHILE ! Eof()
            Output += Space( nSpacing ) + 'BUTTON ' + AllTrim( ddtoolbar->named )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'CAPTION ' + "'" + AllTrim( ddtoolbar->item ) + "'"
            IF Len( AllTrim( ddtoolbar->image ) ) > 0
              Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'PICTURE ' + "'" + AllTrim( ddtoolbar->image ) + "'"
            ENDIF
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'ACTION ' + AllTrim( ddtoolbar->ACTION )
            IF ddtoolbar->Separator='X'
               Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SEPARATOR '
            ENDIF
            IF ddtoolbar->AUTOSIZE='X'
               Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'AUTOSIZE '
            ENDIF
            IF ddtoolbar->check='X'
               Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'CHECK '
            ENDIF
            IF ddtoolbar->group='X'
               Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'GROUP '
            ENDIF
            IF FCount() > 9
               IF ddtoolbar->drop == 'X'
                  Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'DROPDOWN '
               ENDIF
               IF FCount() > 10
                  IF ! Empty( ddtoolbar->tooltip )
                     Output += ' ;' + CRLF + Space( nSpacing * 2 ) + "TOOLTIP '" + AllTrim( ddtoolbar->tooltip ) + "'"
                  ENDIF
               ENDIF
            ENDIF
            SKIP
            Output += CRLF + CRLF
/*
   TODO: Add this properties

   [ OBJ <obj> ] ;
   [ <wholedropdown: WHOLEDROPDOWN> ] ;
*/
         ENDDO
         Output += Space( nSpacing ) + 'END TOOLBAR ' + CRLF + CRLF
      ENDIF
/*
   TODO: Add this properties

   [ OBJ <obj> ] ;
   [ CAPTION <caption> ] ;
   [ ACTION <action> ] ;
   [ <vertical: VERTICAL> ] ;
   [ GRIPPERTEXT <caption> ] ;
   [ <break: BREAK> ] ;
   [ <rtl: RTL> ] ;
   [ <notabstop: NOTABSTOP> ] ;
*/

//***************************  Dropdown menu
      GO TOP
      DO WHILE ! Eof()
         cbutton := AllTrim( ddtoolbar->named )
         carchivo := myForm:cfname + '.' + cbutton + '.mnd'
         IF file( carchivo )
            SELECT 50
            USE &carchivo EXCLUSIVE ALIAS menues
            GO TOP
            IF ! Eof()
               Output += Space( nSpacing ) + 'DEFINE DROPDOWN MENU BUTTON ' + cbutton + CRLF + CRLF
               DO WHILE ! Eof()
                  IF Lower( AllTrim( menues->auxit ) ) == 'separator'
                     Output += Space( nSpacing * ( menues->level + 1 ) ) + 'SEPARATOR ' + CRLF
                  ELSE
                     Output += Space( nSpacing * ( menues->level + 1 ) ) + 'ITEM ' + "'" + AllTrim( menues->auxit ) + "'" + ' ACTION ' + IIF( Len( AllTrim( menues->action ) ) # 0, AllTrim( menues->action ), "MsgBox( 'item' )" )
                     IF AllTrim( menues->named ) == ''
                        Output += IIF( Len( AllTrim( menues->image ) ) # 0, ' IMAGE ' + "'" + AllTrim( menues->image ) + "'", '') + CRLF
                     ELSE
                        Output += "NAME " + AllTrim( menues->named ) + IIF( Len( AllTrim( menues->image ) ) # 0, ' IMAGE ' + "'" + AllTrim( menues->image ) + "'", '') + CRLF
                        IF menues->checked == 'X'
                           Output += Space( nSpacing * ( menues->level + 1 ) ) + "// " + mlyform + '.' + AllTrim(menues->named) + '.checked := .F.' + CRLF
                           Output += "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'checked', .F.)" + CRLF
                        ENDIF
                        IF menues->enabled == 'X'
                           Output += Space( nSpacing * ( menues->level + 1 ) ) + "// " + mlyform + '.' + AllTrim( menues->named ) + '.enabled := .F.' + CRLF
                           Output += Space( nSpacing * ( menues->level + 1 ) ) + "SetProperty('" + mlyform + "', " + "'" + AllTrim( menues->named ) + "', " + "'enabled', .F.)" + CRLF
                        ENDIF
                     ENDIF
                  ENDIF
                  SKIP
               ENDDO
               Output += CRLF
               Output += Space( nSpacing ) + 'END MENU ' + CRLF + CRLF
            ENDIF
         ENDIF
         SELECT 40
         SKIP
      ENDDO
      CLOSE DATABASES
   ENDIF

   SET( _SET_DELETED, lDeleted )

//***************************  Form controls
   j := 1
   DO WHILE j <= myForm:ncontrolw
      DO WHILE Upper( myForm:acontrolw[j] ) == 'TEMPLATE' .AND. ;
               Upper( myForm:acontrolw[j] ) == 'STATUSBAR' .AND. ;
               Upper( myForm:acontrolw[j] ) == 'MAINMENU' .AND. ;
               Upper( myForm:acontrolw[j] ) == 'CONTEXTMENU' .AND. ;
               Upper( myForm:acontrolw[j] ) == 'NOTIFYMENU' .AND. ;
               j < myForm:ncontrolw
         j ++
      ENDDO
      cName := myForm:acontrolw[j]
      nhandle := myaScan( cName )
      IF nhandle == 0
         j ++
         LOOP
      ENDIF
      owindow := getformobject( "Form_1" )
      nRow    := GetWindowRow( owindow:acontrols[nhandle]:hwnd ) - BaseRow - TitleHeight - BorderHeight
      nCol    := GetWindowCol( owindow:acontrols[nhandle]:hwnd ) - BaseCol - BorderWidth
      nWidth  := GetWindowWidth( owindow:acontrols[nhandle]:hwnd )
      nHeight := GetWindowHeight( owindow:acontrols[nhandle]:hwnd )

//***************************  Tab start
      IF myForm:actrltype[j] == 'TAB'
         // Do not delete next line, it's needed to load the fmg properly.
         Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TAB ' + AllTrim( myForm:aname[j] ) + ' ;' + CRLF
         Output += Space( nSpacing ) + 'DEFINE TAB ' + AllTrim( myForm:aname[j] ) + ' ;' + CRLF
         IF ! Empty( myForm:acobj[j] )
            Output += Space( nSpacing * 2) + 'OBJ ' + myForm:acobj[j] + ' ;' + CRLF
         ENDIF
         Output += Space( nSpacing * 2) + 'AT ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' ;' + CRLF
         Output += Space( nSpacing * 2) + 'WIDTH ' + LTrim( Str( nWidth ) ) + ' ;' + CRLF
         Output += Space( nSpacing * 2) + 'HEIGHT ' + LTrim( Str( nHeight ) )
         IF Len( myForm:avalue[j] ) > 0
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'VALUE ' + AllTrim( myForm:avalue[j] )
         ENDIF
         IF Len( myForm:afontname[j] ) > 0
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'FONT ' + "'" + myForm:afontname[j] + "'"
         ENDIF
         IF myForm:afontsize[j] > 0
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
         ENDIF
         IF Len( myForm:atooltip[j] ) > 0
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'TOOLTIP ' + "'" + myForm:atooltip[j] + "'"
         ENDIF
         IF myForm:abuttons[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'BUTTONS '
         ENDIF
         IF myForm:aflat[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'FLAT '
         ENDIF
         IF myForm:ahottrack[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'HOTTRACK '
         ENDIF
         IF myForm:avertical[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'VERTICAL '
         ENDIF
         IF Len( myForm:aonchange[j] ) > 0
            Output += ' ;' + CRLF + Space( nSpacing * 2) + 'ON CHANGE ' + myForm:aonchange[j]
         ENDIF
         Output += CRLF + CRLF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ <notabstop : NOTABSTOP> ] ;
   [ <rtl : RTL> ] ;
   [ <internals : INTERNALS> ] ;
   [ <invisible : INVISIBLE> ] ;
   [ <disabled : DISABLED> ] ;
   [ <multiline : MULTILINE> ] ;
*/
//***************************  Tab pages
         cacaptions := myForm:acaption[j]
         caimages := myForm:aimage[j]
         acaptions := &cacaptions
         aimage := &caimages
         currentpage := 1
         Output += Space( nSpacing * 2) + 'DEFINE PAGE ' + "'" + acaptions[currentpage] + "'" + ' ;' + CRLF
         Output += Space( nSpacing * 3) + 'IMAGE ' + "'" + AllTrim(aimage[currentpage]) + "'" + CRLF
         FOR k := 1 TO myForm:ncontrolw
            IF myForm:atabpage[k, 1] # NIL
               IF myForm:atabpage[k, 1] == myForm:acontrolw[j]
                  IF myForm:atabpage[k, 2] # currentpage
                     Output += Space( nSpacing * 2) + 'END PAGE ' + CRLF + CRLF
                     currentpage ++
                     Output += Space( nSpacing * 2) + 'DEFINE PAGE ' + "'" + acaptions[currentpage] + "'" + ' ;' + CRLF
                     Output += Space( nSpacing * 3) + 'IMAGE ' + "'" + AllTrim(aimage[currentpage]) + "'" + CRLF
                  ENDIF
/*
   TODO: Add this properties

   [ NAME <name> ]
   [ OBJ <obj> ]
*/
//***************************  Tab page controls
                  p := myaScan( myForm:acontrolw[k] )
                  IF p > 0
                     owindow := getformobject( "Form_1" )
                     nRow    := owindow:acontrols[p]:Row
                     nCol    := owindow:acontrols[p]:Col
                     nWidth  := owindow:acontrols[p]:Width
                     nHeight := owindow:acontrols[p]:Height
                     Output  := MakeControls( k, Output, nRow, nCol, nWidth, nHeight, mlyform, nSpacing, 3)
                  ENDIF
               ENDIF
            ENDIF
         NEXT k
//***************************  Tab end
         Output += Space( nSpacing * 2) + 'END PAGE ' + CRLF
         IF myForm:afontitalic[j]
            Output += Space( nSpacing * 2) + mlyform + '.' + cName + '.fontitalic := .T.' + CRLF
         ENDIF
         IF myForm:afontunderline[j]
            Output += Space( nSpacing * 2) + mlyform + '.' + cName + '.fontunderline := .T.' + CRLF
         ENDIF
         IF myForm:afontstrikeout[j]
            Output += Space( nSpacing * 2) + mlyform + '.' + cName + '.fontstrikeout := .T.' + CRLF
         ENDIF
         IF myForm:abold[j]
            Output += Space( nSpacing * 2) + mlyform + '.' + cName + '.fontbold := .T.' + CRLF
         ENDIF
         IF ! myForm:aenabled[j]
            Output += Space( nSpacing * 2) + mlyform + '.' + cName + '.enabled := .F.' + CRLF
         ENDIF
         IF ! myForm:avisible[j]
            Output += Space( nSpacing * 2) + mlyform + '.' + cName + '.visible := .F.' + CRLF
         ENDIF
         Output += Space( nSpacing ) + "END TAB " + CRLF + CRLF
      ELSE
//***************************  Other controls
         IF myForm:actrltype[j] # 'TAB' .AND. ( myForm:atabpage[j, 2] == NIL .OR. myForm:atabpage[j, 2] == 0 )
            Output := MakeControls( j, Output, nRow, nCol, nWidth, nHeight, mlyform, nSpacing, 1 )
         ENDIF
      ENDIF
      j ++
   ENDDO

//***************************  Form end
   Output += 'END WINDOW ' + CRLF + CRLF
   Output := StrTran( Output, "  ;", " ;" )

   CursorArrow()

//***************************  Save FMG
   IF lSaveAs == 1
      IF ! MemoWrit( PutFile( { {'Form files *.fmg', '*.fmg'} }, 'Save Form As', , .T. ), Output )
         MsgStop( 'Error writing FMG file.', 'OOHG IDE+' )
         RETURN NIL
      ENDIF
   ELSE
      IF ! MemoWrit( myForm:cForm, Output )
         MsgStop( 'Error writing ' + myForm:cForm + ".", 'OOHG IDE+' )
         RETURN NIL
      ENDIF
      myForm:lfSave := .T.
   ENDIF

//***************************  Rebuild form's menu
   IF File( myForm:cfname + '.mnm' )
      lDeleted := SET( _SET_DELETED, .T. )

      archivo := myForm:cfname + '.mnm'
      SELECT 20
      USE &archivo EXCLUSIVE ALIAS menues
      GO TOP
      IF ! Eof()
         swpop := 0
         DEFINE MAIN MENU OF Form_1
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
                  IF Lower( AllTrim( menues->auxit ) ) == 'separator'
                     SEPARATOR
                  ELSE
                     POPUP AllTrim( menues->auxit )
                     swpop ++
                  ENDIF
               ELSE
                  IF Lower( AllTrim( menues->auxit ) ) == 'separator'
                     SEPARATOR
                  ELSE
                     ITEM AllTrim( menues->auxit ) ACTION NIL
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
               nnivaux--
               END POPUP
               swpop --
            ENDDO
         END MENU
      ENDIF
      CLOSE DATABASES
      SET( _SET_DELETED, lDeleted )
   ENDIF
RETURN NIL

*------------------------------------------------------------------------------*
STATIC FUNCTION MakeControls( j, Output, nRow, nCol, nWidth, nHeight, mlyform, nSpacing, nLevel )
*------------------------------------------------------------------------------*
LOCAL cName, lBlankLine := .F.

/*
   TODO: Add ON GOTFOCUS and ON LOSTFOCUS to all controls
*/

   IF myForm:actrltype[j] == 'BUTTON'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BUTTON ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:acaption[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + "'" + AllTrim( myForm:acaption[j] ) + "'"
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + "'" + AllTrim( myForm:aname[j] ) + "'"
      ENDIF
      IF Len( myForm:aPicture[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + "'" + AllTrim( myForm:apicture[j] ) + "'"
      ENDIF
      IF Len( myForm:aaction[j] ) > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( myForm:aaction[j] )
      ELSE
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + "MsgInfo( 'Button Pressed' )"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:aflat[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FLAT '
      ENDIF
      IF Len( myForm:ajustify[j] ) > 0 .AND. Len( myForm:aPicture[j] ) > 0 .AND. Len( myForm:acaption[j] ) > 0
          // Must end with a space
          Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + Upper( AllTrim( myForm:ajustify[j] ) ) + " "
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:anotabstop[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:ahelpid[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ ON MOUSEMOVE <onmousemove> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <rtl: RTL> ] ;
   [ <noprefix: NOPREFIX> ] ;
   [ <disabled: DISABLED> ] ;
   [ BUFFER <buffer> ] ;
   [ HBITMAP <hbitmap> ] ;
   [ <notrans: NOLOADTRANSPARENT> ] ;
   [ <scale: FORCESCALE> ] ;
   [ <cancel: CANCEL> ] ;
   [ <alignment:LEFT,RIGHT,TOP,BOTTOM,CENTER> ] ;
   [ <multiline: MULTILINE> ] ;
   [ <themed : THEMED> ] ;
   [ IMAGEMARGIN <aImageMargin> ] ;
   [ <no3dcolors: NO3DCOLORS> ] ;
   [ <autofit: AUTOFIT, ADJUST> ] ;
   [ <lDIB: DIBSECTION> ] ;
   [ BACKCOLOR <backcolor> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'CHECKBOX'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBOX ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:acaption[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + "'" + AllTrim( myForm:acaption[j] ) + "'"
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + " '" + "'"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF myForm:avaluel[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF Len( myForm:afield[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( myForm:afield[j] )
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
       ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:atransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:ahelpid[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <autosize: AUTOSIZE > ] ;
   [ <disabled: DISABLED > ] ;
   [ <rtl: RTL> ] ;
   [ <threestate : THREESTATE> ] ;
   [ <leftalign: LEFTALIGN> ] ;
   [ <themed : THEMED> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'TREE'
      // Do not delete next line, it's needed to load the fmg properly.
      Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TREE ' + AllTrim( myForm:aname[j] ) + ' ;' + CRLF
      Output += Space( nSpacing * nLevel ) + 'DEFINE TREE ' + AllTrim( myForm:aname[j] )
      IF ! Empty( myForm:acobj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AT ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF myForm:afontcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + AllTrim( myForm:afontcolor[j] )
      ENDIF
      IF myForm:abold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF myForm:afontitalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF myForm:afontunderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF myForm:afontstrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF myForm:abackcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( myForm:abackcolor[j] )
      ENDIF
      IF ! myForm:avisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! myForm:aenabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF Len( myForm:aondblclick[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( myForm:aondblclick[j] )
      ENDIF
      IF Len( myForm:anodeimages[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NODEIMAGES ' + AllTrim( myForm:anodeimages[j] )
      ENDIF
      IF Len( myForm:aitemimages[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMIMAGES ' + AllTrim( myForm:aitemimages[j] )
      ENDIF
      IF myForm:anorootbutton[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOROOTBUTTON '
      ENDIF
      IF myForm:aitemids[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMIDS '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      Output += CRLF
      Output += Space( nSpacing * nLevel ) + "END TREE " + CRLF + CRLF
/*
   TODO: Add this properties

   FULLROWSELECT ;
   [ VALUE <value> ] ;
   [ <rtl: RTL> ]                  ;
   [ ON ENTER <enter> ]            ;
   [ <break: BREAK> ]              ;
   [ <notabstop: NOTABSTOP> ] ;
   [ SELCOLOR <selcolor> ] ;
   [ <selbold: SELBOLD> ] ;
   [ <checkboxes: CHECKBOXES> ] ;
   [ <editlabels: EDITLABELS> ] ;
   [ <noHScr: NOHSCROLL> ] ;
   [ <noScr: NOSCROLL> ] ;
   [ <hott: HOTTRACKING> ] ;
   [ <nobuts: NOBUTTONS> ] ;
   [ <drag: ENABLEDRAG> ] ;
   [ <drop: ENABLEDROP> ] ;
   [ TARGET <aTarget> ] ;
   [ <single: SINGLEEXPAND> ] ;
   [ <noborder: BORDERLESS> ] ;
   [ ON LABELEDIT <labeledit> ] ;
   [ VALID <valid> ] ;
   [ ON CHECKCHANGE <checkchange> ] ;
   [ INDENT <pixels> ] ;
   [ ON DROP <ondrop> ] ;
   [ <nolines: NOLINES> ] ;
*/
   ENDIF

   IF myForm:actrltype[j] == 'LIST'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' LISTBOX ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:aitems[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( myForm:aitems[j] )
      ENDIF
      IF myForm:avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) )
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF Len( myForm:aondblclick[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( myForm:aondblclick[j] )
      ENDIF
      IF myForm:amultiselect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTISELECT '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:abreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:asort[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SORT '
      ENDIF
/*
   TODO: Add this properties

   [ <bold: BOLD> ] ;
   [ <italic: ITALIC> ] ;
   [ <underline: UNDERLINE> ] ;
   [ <strikeout: STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <rtl: RTL> ] ;
   [ ON ENTER <enter> ]            ;
   [ <disabled: DISABLED> ]        ;
   [ IMAGE <aImage> [ <fit: FIT> ] ] ;
   [ TEXTHEIGHT <textheight> ] ;
   [ <novscroll: NOVSCROLL> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'COMBO'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' COMBOBOX ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:aitems[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( myForm:aitems[j] )
      ENDIF
      IF Len( myForm:aitemsource[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMSOURCE ' + AllTrim( myForm:aitemsource[j] )
      ENDIF
      IF myForm:avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) )
      ENDIF
      IF Len( myForm:avaluesource[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUESOURCE ' + AllTrim( myForm:avaluesource[j] )
      ENDIF
      IF myForm:adisplayedit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISPLAYEDIT '
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      // Do not include HEIGHT
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF Len( myForm:aonenter[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( myForm:aonenter[j] )
      ENDIF
      IF Len( myForm:aondisplaychange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DISPLAYCHANGE ' + myForm:aondisplaychange[j]
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:abreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF myForm:asort[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SORT '
      ENDIF
/*
   TODO: Add this properties

   [ ITEMIMAGENUMBER <itemimagenumber> ] ;
   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ <invisible : INVISIBLE> ] ;
   [ IMAGE <aImage> ] ;
   [ IMAGESOURCE <imagesource> ] ;
   [ <fit: FIT> ] ;
   [ <rtl: RTL> ] ;
   [ TEXTHEIGHT <textheight> ] ;
   [ <disabled : DISABLED> ] ;
   [ <firstitem : FIRSTITEM> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ LISTWIDTH <listwidth> ];
   [ ON LISTDISPLAY <onListDisplay> ] ;
   [ ON LISTCLOSE <onListClose> ] ;
   [ <delay: DELAYEDLOAD> ] ;
   [ <incremental: INCREMENTAL> ] ;
   [ <winsize: INTEGRALHEIGHT> ] ;
   [ <rfrsh: REFRESH, NOREFRESH> ] ;
   [ SOURCEORDER <sourceorder> ] ;
   [ ON REFRESH <refresh> ] ;
   [ SEARCHLAPSE <nLapse> ] ;
   [ GRIPPERTEXT <grippertext> ] ;
   [ <break: BREAK> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'CHECKBTN'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBUTTON ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:acaption[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + "'" + AllTrim( myForm:acaption[j] ) + "'"
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + "'" + AllTrim( myForm:aname[j] ) + "'"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF myForm:avaluel[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <rtl: RTL> ]                    ;
   [ <dummy3: PICTURE, ICON> <bitmap> ] ;
   [ BUFFER <buffer> ] ;
   [ HBITMAP <hbitmap> ] ;
   [ <notrans: NOLOADTRANSPARENT> ] ;
   [ <scale: FORCESCALE> ] ;
   [ FIELD <field> ] ;
   [ <no3dcolors: NO3DCOLORS> ] ;
   [ <autofit: AUTOFIT, ADJUST> ] ;
   [ <lDIB: DIBSECTION> ] ;
   [ BACKCOLOR <backcolor> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'GRID'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' GRID ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + AllTrim( myForm:aheaders[j] )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + AllTrim( myForm:awidths[j] )
      IF Len( myForm:aitems[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( myForm:aitems[j] )
      ENDIF
      IF Len( myForm:avalue[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( myForm:avalue[j] )
      ENDIF
      IF Len( myForm:adynamicbackcolor[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBACKCOLOR ' + AllTrim( myForm:adynamicbackcolor[j] )
      ENDIF
      IF Len( myForm:adynamicforecolor[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICFORECOLOR ' + AllTrim( myForm:adynamicforecolor[j] )
      ENDIF
      IF Len( myForm:acolumncontrols[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNCONTROLS ' + AllTrim( myForm:acolumncontrols[j] )
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF Len( myForm:aondblclick[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( myForm:aondblclick[j] )
      ENDIF
      IF Len( myForm:aonenter[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( myForm:aonenter[j] ) + ' ;' +CRLF
      ENDIF
      IF Len( myForm:aonheadclick[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADCLICK ' + AllTrim( myForm:aonheadclick[j] )
      ENDIF
      IF Len( myForm:aoneditcell[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON EDITCELL ' + AllTrim( myForm:aoneditcell[j] )
      ENDIF
      IF myForm:amultiselect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTISELECT '
      ENDIF
      IF myForm:anolines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF myForm:ainplace[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPLACE '
      ENDIF
      IF myForm:aedit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDIT '
      ENDIF
      IF Len( myForm:aimage[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( myForm:aimage[j] )
      ENDIF
      IF Len( myForm:ajustify[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( myForm:ajustify[j] )
      ENDIF
      IF Len( myForm:awhen[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( myForm:awhen[j] )
      ENDIF
      IF Len( myForm:avalid[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( myForm:avalid[j] )
      ENDIF
      IF Len( myForm:avalidmess[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALIDMESSAGES ' + AllTrim( myForm:avalidmess[j] )
      ENDIF
      IF Len( myForm:areadonlyb[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY ' + AllTrim( myForm:areadonlyb[j] )
      ENDIF
      IF Len( myForm:ainputmask[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( myForm:ainputmask[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:abreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ <dummy06: ONCLICK, ON CLICK> <click> ] ;
   [ <ownerdata: VIRTUAL> ] ;
   [ ITEMCOUNT <itemcount> ] ;
   [ <dummy08: ONQUERYDATA, ON QUERYDATA> <dispinfo> ] ;
   [ <rtl: RTL> ] ;
   [ <noshowheaders: NOHEADERS> ] ;
   [ <disabled: DISABLED> ] ;
   [ <notabstop: NOTABSTOP> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ HEADERIMAGES <aHeaderImages> ] ;
   [ IMAGESALIGN <aImgAlign> ] ;
   [ <fullmove: FULLMOVE> ] ;
   [ <bycell: NAVIGATEBYCELL> ] ;
   [ SELECTEDCOLORS <aSelectedColors> ] ;
   [ EDITKEYS <aEditKeys> ] ;
   [ <checkboxes: CHECKBOXES> ] ;
   [ <dummy12: ONCHECKCHANGE, ON CHECKCHANGE> <checkchange> ] ;
   [ <bffr: DOUBLEBUFFER, SINGLEBUFFER> ] ;
   [ <focus: NOFOCUSRECT, FOCUSRECT> ] ;
   [ <plm: PAINTLEFTMARGIN> ] ;
   [ <fixedcols: FIXEDCOLS> ] ;
   [ <dummy13: ONABORTEDIT, ON ABORTEDIT> <abortedit> ] ;
   [ <fixedwidths: FIXEDWIDTHS> ] ;
   [ BEFORECOLMOVE <bBefMov> ] ;
   [ AFTERCOLMOVE <bAftMov> ] ;
   [ BEFORECOLSIZE <bBefSiz> ] ;
   [ AFTERCOLSIZE <bAftSiz> ] ;
   [ BEFOREAUTOFIT <bBefAut> ] ;
   [ <excel: EDITLIKEEXCEL> ] ;
   [ <buts: USEBUTTONS> ] ;
   [ <delete: DELETE> ] ;
   [ DELETEWHEN <bWhenDel> ] ;
   [ DELETEMSG <DelMsg> ] ;
   [ <dummy14: ONDELETE, ON DELETE> <onDelete> ] ;
   [ <nodelmsg: NODELETEMSG> ] ;
   [ <append : APPEND> ] ;
   [ <dummy15: ONAPPEND, ON APPEND> <onappend> ] ;
   [ <nomodal : NOMODALEDIT> ] ;
   [ <edtctrls: FIXEDCONTROLS, DYNAMICCONTROLS> ] ;
   [ <dummy16: ONHEADRCLICK, ON HEADRCLICK> <bheadrclick> ] ;
   [ <noclick: NOCLICKONCHECKBOX> ] ;
   [ <norclick: NORCLICKONCHECKBOX> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'BROWSE'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BROWSE ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:aheaders[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + AllTrim( myForm:aheaders[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + "{'', ''}"
      ENDIF
      IF Len( myForm:awidths[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + AllTrim( myForm:awidths[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + "{90, 60}"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WORKAREA ' + AllTrim( myForm:aworkarea[j] )
      IF Len( myForm:afields[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + AllTrim( myForm:afields[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + "{'field1', 'field2'}"
      ENDIF
      IF myForm:avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) )
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:ainputmask[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( myForm:ainputmask[j] )
      ENDIF
      IF Len( myForm:adynamicbackcolor[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBACKCOLOR ' + AllTrim( myForm:adynamicbackcolor[j] )
      ENDIF
      IF Len( myForm:adynamicforecolor[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICFORECOLOR ' + AllTrim( myForm:adynamicforecolor[j] )
      ENDIF
      IF Len( myForm:acolumncontrols[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNCONTROLS ' + AllTrim( myForm:acolumncontrols[j] )
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF Len( myForm:aondblclick[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( myForm:aondblclick[j] )
      ENDIF
      IF Len( myForm:aonheadclick[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADCLICK ' + AllTrim( myForm:aonheadclick[j] )
      ENDIF
      IF Len( myForm:aoneditcell[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON EDITCELL ' + AllTrim( myForm:aoneditcell[j] )
      ENDIF
      IF Len( myForm:aonappend[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON APPEND ' + AllTrim( myForm:aonappend[j] )
      ENDIF
      IF Len( myForm:awhen[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( myForm:awhen[j] )
      ENDIF
      IF Len( myForm:avalid[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( myForm:avalid[j] )
      ENDIF
      IF Len( myForm:avalidmess[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALIDMESSAGES ' + AllTrim( myForm:avalidmess[j] )
      ENDIF
      IF Len( myForm:areadonlyb[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY ' + AllTrim( myForm:areadonlyb[j] )
      ENDIF
      IF myForm:alock[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LOCK '
      ENDIF
      IF myForm:adelete[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELETE '
      ENDIF
      IF myForm:ainplace[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPLACE '
      ENDIF
      IF myForm:aedit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDIT '
      ENDIF
      IF myForm:anolines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF Len( myForm:aimage[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( myForm:aimage[j] )
      ENDIF
      IF Len( myForm:ajustify[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( myForm:ajustify[j] )
      ENDIF
      IF Len( myForm:aonenter[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( myForm:aonenter[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:aappend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'APPEND '
      ENDIF
/*
   TODO: Add this properties

   [ <bold: BOLD> ] ;
   [ <italic: ITALIC> ] ;
   [ <underline: UNDERLINE> ] ;
   [ <strikeout: STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ <dummy06: ONCLICK, ON CLICK> <click> ] ;
   [ <novscroll: NOVSCROLL> ] ;
   [ <break: BREAK> ] ;
   [ <rtl: RTL> ] ;
   [ REPLACEFIELD <replacefields> ] ;
   [ SUBCLASS <subclass> ] ;
   [ <reccount: RECCOUNT> ] ;
   [ COLUMNINFO <columninfo> ] ;
   [ <noshowheaders: NOHEADERS> ] ;
   [ <disabled: DISABLED> ] ;
   [ <notabstop: NOTABSTOP> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <descending: DESCENDING> ] ;
   [ DELETEWHEN <bWhenDel> ] ;
   [ DELETEMSG <DelMsg> ] ;
   [ <dummy12: ONDELETE, ON DELETE> <onDelete> ] ;
   [ HEADERIMAGES <aHeaderImages> ] ;
   [ IMAGESALIGN <aImgAlign> ] ;
   [ <fullmove: FULLMOVE> ] ;
   [ SELECTEDCOLORS <aSelectedColors> ] ;
   [ EDITKEYS <aEditKeys> ] ;
   [ <forcerefresh: FORCEREFRESH> ] ;
   [ <norefresh: NOREFRESH> ] ;
   [ <bffr: DOUBLEBUFFER, SINGLEBUFFER> ] ;
   [ <focus: NOFOCUSRECT, FOCUSRECT> ] ;
   [ <plm: PAINTLEFTMARGIN> ] ;
   [ <sync: SYNCHRONIZED, UNSYNCHRONIZED> ] ;
   [ <fixedcols: FIXEDCOLS> ] ;
   [ <nodelmsg: NODELETEMSG> ] ;
   [ <updall: UPDATEALL> ] ;
   [ <dummy13: ONABORTEDIT, ON ABORTEDIT> <abortedit> ] ;
   [ <fixedwidths: FIXEDWIDTHS> ] ;
   [ <blocks: FIXEDBLOCKS, DYNAMICBLOCKS> ] ;
   [ BEFORECOLMOVE <bBefMov> ] ;
   [ AFTERCOLMOVE <bAftMov> ] ;
   [ BEFORECOLSIZE <bBefSiz> ] ;
   [ AFTERCOLSIZE <bAftSiz> ] ;
   [ BEFOREAUTOFIT <bBefAut> ] ;
   [ <excel: EDITLIKEEXCEL> ] ;
   [ <buts: USEBUTTONS> ] ;
   [ <upcol: UPDATECOLORS> ] ;
   [ <edtctrls: FIXEDCONTROLS, DYNAMICCONTROLS> ] ;
   [ <dummy14: ONHEADRCLICK, ON HEADRCLICK> <bheadrclick> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'IMAGE'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' IMAGE ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:aaction[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( myForm:aaction[j] )
      ENDIF
      IF Len( myForm:apicture[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE '" + AllTrim( myForm:apicture[j] ) + "'"
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE 'oohg.bmp'"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF myForm:astretch[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRETCH '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:aborder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF myForm:aclientedge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ! myForm:avisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! myForm:aenabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF myForm:atransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF myForm:abackcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( myForm:abackcolor[j] )
      ENDIF
/*
   TODO: Add this properties

   [ <rtl: RTL> ] ;
   [ <whitebackground: WHITEBACKGROUND> ] ;
   [ BUFFER <buffer> ] ;
   [ HBITMAP <hbitmap> ] ;
   [ <noresize: NORESIZE> ] ;
   [ <imagesize: IMAGESIZE> ] ;
   [ <notrans: NOLOADTRANSPARENT> ] ;
   [ <no3dcolors: NO3DCOLORS> ] ;
   [ <nodib: NODIBSECTION> ] ;
   [ EXCLUDEAREA <area> ] ;

*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'TIMER'
      // Do not delete next 3 lines, they are needed to load the control properly.
      Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TIMER ' + AllTrim( myForm:aname[j] ) + ' ;' + CRLF
      Output += Space( nSpacing ) + '*****' + Space( nSpacing ) + 'ROW ' + LTrim( Str( nRow ) ) + ' ;' + CRLF
      Output += Space( nSpacing ) + '*****' + Space( nSpacing ) + 'COL ' + LTrim( Str( nCol ) ) + CRLF
      Output += Space( nSpacing * ( nLevel + 1 ) ) + 'DEFINE TIMER ' + AllTrim( myForm:aname[j] )
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF myForm:avaluen[j] > 999
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INTERVAL ' + LTrim( Str( myForm:avaluen[j] ) )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INTERVAL ' + LTrim( Str( 1000 ) )
      ENDIF
      IF Len( myForm:aaction[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( myForm:aaction[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + '_dummy()'
      ENDIF
/*
   TODO: Add this properties

   [ <disabled: DISABLED> ] 

*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'ANIMATE'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' ANIMATEBOX ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:afile[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "FILE '" + AllTrim( myForm:afile[j] ) + "'"
      ENDIF
      IF myForm:aautoplay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOPLAY '
      ENDIF
      IF myForm:acenter[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CENTER '
      ENDIF
      IF myForm:atransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF ! myForm:avisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! myForm:aenabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
/*
   TODO: Add this properties

   [ <notabstop: NOTABSTOP> ] ;
   [ <rtl: RTL> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'DATEPICKER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' DATEPICKER ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:avalue[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( myForm:avalue[j] )
      ENDIF
      IF Len( myForm:afield[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( myForm:afield[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:ashownone[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWNONE '
      ENDIF
      IF myForm:aupdown[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDOWN '
      ENDIF
      IF myForm:arightalign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF Len( myForm:aonenter[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( myForm:aonenter[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
/*
   TODO: Add this properties

   [ HEIGHT <h> ] ;
   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <notabstop: NOTABSTOP> ] ;
   [ <disabled: DISABLED> ] ;
   [ <noborder: NOBORDER> ] ;
   [ <rtl: RTL> ] ;
   [ <dummy2: RANGE> <min>, <max> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'TEXT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TEXTBOX ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:afield[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( myForm:afield[j] )
      ENDIF
      cValue  := AllTrim( myForm:avalue[j] )
      IF cValue == NIL
         cvalue := ''
      ENDIF
      IF Len( cValue ) > 0
         IF myForm:anumeric[j]
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + cValue
         ELSE
            IF myForm:adate[j]
               Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + cValue
            ELSE
               Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + "'" + cValue + "'"
            ENDIF
         ENDIF
      ENDIF
      IF myForm:areadonly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      IF myForm:apassword[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PASSWORD '
      ENDIF
      IF Len( myForm:aFontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:anumeric[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NUMERIC '
         IF Len( myForm:ainputmask[j] ) > 0
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + "'" + myForm:ainputmask[j] + "'"
         ENDIF
      ELSE
         IF Len( myForm:ainputmask[j] ) > 0
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + "'" + myForm:ainputmask[j] + "'"
         ENDIF
      ENDIF
      IF Len( myForm:afields[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORMAT ' + "'" + myForm:afields[j] + "'"
      ENDIF
      IF myForm:adate[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DATE '
      ENDIF
      IF myForm:amaxlength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( myForm:amaxlength[j] ) )
      ENDIF
      IF myForm:auppercase[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPPERCASE '
      ENDIF
      IF myForm:aLowercase[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LOWERCASE '
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aonenter[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( myForm:aonenter[j] )
      ENDIF
      IF myForm:arightalign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:afocusedpos[j] <> -2            // default value, see DATA nOnFocusPos in h_textbox.prg
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSEDPOS ' + LTrim( Str( myForm:afocusedpos[j] ) )
      ENDIF
      IF Len( myForm:avalid[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( myForm:avalid[j] )
      ENDIF
      IF Len( myForm:awhen[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( myForm:awhen[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ ON TEXTFILLED <textfilled> ] ;
   [ <centeralign: CENTERALIGN> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <rtl: RTL> ] ;
   [ <autoskip: AUTOSKIP> ] ;
   [ <noborder: NOBORDER> ] ;
   [ <disabled: DISABLED> ] ;
   [ DEFAULTYEAR <year> ] ;
   [ ACTION <action> ] ;
   [ ACTION2 <action2> ] ;
   [ IMAGE <abitmap> ] ;
   [ BUTTONWIDTH <btnwidth> ] ;
   [ INSERTTYPE <nInsType> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'EDIT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' EDITBOX ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:afield[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( myForm:afield[j] )
      ENDIF
      IF Len( myForm:avalue[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + "'" + AllTrim( myForm:avalue[j] ) + "'"
      ENDIF
      IF myForm:areadonly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:amaxlength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( myForm:amaxlength[j] ) )
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:abreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF myForm:anohscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHSCROLL '
      ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <rtl: RTL> ] ;
   [ <noborder: NOBORDER> ] ;
   [ FOCUSEDPOS <focusedpos> ]     ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'RICHEDIT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' RICHEDITBOX ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:afield[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( myForm:afield[j] )
      ENDIF
      IF Len( myForm:avalue[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + "'" + AllTrim( myForm:avalue[j] ) + "'"
      ENDIF
      IF myForm:areadonly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:amaxlength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( myForm:amaxlength[j] ) )
      ENDIF
      IF myForm:abreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ ON SELCHANGE <selchange> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <rtl: RTL> ] ;
   [ <disabled: DISABLED> ] ;
   [ <nohidesel: NOHIDESEL> ] ;
   [ FOCUSEDPOS <focusedpos> ] ;
   [ <novscroll: NOVSCROLL> ] ;
   [ <nohscroll: NOHSCROLL> ] ;
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'IPADDRESS'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' IPADDRESS ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:avalue[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( myForm:avalue[j] )
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:anotabstop[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:afontcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + AllTrim( myForm:afontcolor[j] )
      ENDIF
      IF myForm:abold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF myForm:afontitalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF myForm:afontunderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF myForm:afontstrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF myForm:abackcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( myForm:abackcolor[j] )
      ENDIF
      IF ! myForm:avisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! myForm:aenabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
/*
   TODO: Add this properties

   [ <rtl: RTL> ]
*/
      Output += CRLF + CRLF
   ENDIF

   IF myForm:actrltype[j] == 'HYPERLINK'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' HYPERLINK ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:avalue[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + "'" + AllTrim( myForm:avalue[j] ) + "'"
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + "ooHG Home"
      ENDIF
      IF Len( myForm:aaddress[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ADDRESS ' + "'" + AllTrim( myForm:aaddress[j] ) + "'"
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ADDRESS ' + "'https://sourceforge.net/projects/oohg/'"
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:ahandcursor[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HANDCURSOR '
      ENDIF
      IF myForm:afontcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + AllTrim( myForm:afontcolor[j] )
      ENDIF
      IF myForm:abold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF myForm:afontitalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF myForm:afontunderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF myForm:afontstrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF myForm:abackcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( myForm:abackcolor[j] )
      ENDIF
      IF ! myForm:avisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! myForm:aenabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ <autosize : AUTOSIZE> ] ;
   [ <border: BORDER> ] ;
   [ <clientedge: CLIENTEDGE> ] ;
   [ <hscroll: HSCROLL> ] ;
   [ <vscroll: VSCROLL> ] ;
   [ <transparent: TRANSPARENT> ] ;
   [ <rtl: RTL> ]               ;
*/

   IF myForm:actrltype[j] == 'MONTHCALENDAR'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' MONTHCALENDAR ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:avalue[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( myForm:avalue[j] )
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF myForm:afontcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + AllTrim( myForm:afontcolor[j] )
      ENDIF
      IF myForm:abold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF myForm:afontitalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF myForm:afontunderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF myForm:afontstrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF myForm:abackcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( myForm:abackcolor[j] )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! myForm:avisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! myForm:aenabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF myForm:aNoToday[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTODAY '
      ENDIF
      IF myForm:aNoTodayCircle[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTODAYCIRCLE '
      ENDIF
      IF myForm:aWeekNumbers[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WEEKNUMBERS '
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ <rtl: RTL> ] ;
   [ TITLEFONTCOLOR <titlefontcolor> ] ;
   [ TITLEBACKCOLOR <titlebackcolor> ] ;
   [ TRAILINGFONTCOLOR <trailingfontcolor> ] ;
   [ BACKGROUNDCOLOR <backgroundcolor> ] ;
*/

   IF myForm:actrltype[j] == 'LABEL'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' LABEL ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF myForm:aautoplay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      ENDIF
      IF Len( myForm:aValue[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + "'" + AllTrim( myForm:avalue[j] ) + "'"
      ENDIF
      IF Len( myForm:aaction[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( myForm:aaction[j] )
      ENDIF
      IF Len( myForm:aFontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF myForm:afontcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + AllTrim( myForm:afontcolor[j] )
      ENDIF
      IF myForm:abold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF myForm:afontitalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF myForm:afontunderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF myForm:afontstrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF myForm:abackcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( myForm:abackcolor[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:atransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF myForm:acenteralign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CENTERALIGN '
      ENDIF
      IF myForm:arightalign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF myForm:aclientedge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF myForm:aborder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF ! myForm:avisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! myForm:aenabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF Len( myForm:ainputmask[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( myForm:ainputmask[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ <hscroll: HSCROLL> ] ;
   [ <vscroll: VSCROLL> ] ;
   [ <rtl: RTL> ] ;
   [ <nowordwrap: NOWORDWRAP> ] ;
   [ <noprefix: NOPREFIX> ] ;
*/

   IF myForm:actrltype[j] == 'PLAYER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' PLAYER ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "FILE '" + AllTrim( myForm:afile[j] ) + "'"
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ahelpid[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ <noautosizewindow: NOAUTOSIZEWINDOW> ] ;
   [ <noautosizemovie : NOAUTOSIZEMOVIE> ] ;
   [ <noerrordlg: NOERRORDLG> ] ;
   [ <nomenu: NOMENU> ] ;
   [ <noopen: NOOPEN> ] ;
   [ <noplaybar: NOPLAYBAR> ] ;
   [ <showall: SHOWALL> ] ;
   [ <showmode: SHOWMODE> ] ;
   [ <showname: SHOWNAME> ] ;
   [ <showposition: SHOWPOSITION> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <notabstop: NOTABSTOP> ] ;
   [ <disabled: DISABLED> ] ;
   [ <rtl: RTL> ] ;
*/

   IF myForm:actrltype[j] == 'PROGRESSBAR'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' PROGRESSBAR ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:arange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( myForm:arange[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:avertical[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VERTICAL '
      ENDIF
      IF myForm:asmooth[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SMOOTH '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ VALUE <v> ]         ;
   [ <invisible : INVISIBLE> ]   ;
   [ BACKCOLOR <backcolor> ]   ;
   [ FORECOLOR <barcolor> ]   ;
   [ <rtl: RTL> ]                  ;
   [ MARQUEE <nVelocity> ] ;
*/

   IF myForm:actrltype[j] == 'RADIOGROUP'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' RADIOGROUP ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:aitems[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "OPTIONS " + AllTrim( myForm:aitems[j] )
      ENDIF
      IF myForm:avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      IF myForm:aspacing[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "SPACING " + LTrim( Str( myForm:aspacing[j] ) )
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF myForm:atransparent[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ <invisible : INVISIBLE> ] ;
   [ <notabstop : NOTABSTOP> ] ;
   [ <autosize : AUTOSIZE> ] ;
   [ <horizontal: HORIZONTAL> ] ;
   [ <disabled : DISABLED> ] ;
   [ <rtl : RTL> ] ;
   [ HEIGHT <height> ] ;
   [ <themed : THEMED> ] ;
   [ BACKGROUND <bkgrnd> ] ;
*/

   IF myForm:actrltype[j] == 'SLIDER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' SLIDER ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:arange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( myForm:arange[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE 1, 100'
      ENDIF
      IF myForm:avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF myForm:avertical[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VERTICAL '
      ENDIF
      IF myForm:anoticks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTICKS '
      ENDIF
      IF myForm:aboth[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOTH '
      ENDIF
      IF myForm:atop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOP '
      ENDIF
      IF myForm:aleft[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LEFT '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ BACKCOLOR <backcolor> ] ;
   [ <invisible : INVISIBLE> ] ;
   [ <notabstop : NOTABSTOP> ] ;
   [ <rtl: RTL> ] ;
   [ <disabled: DISABLED> ] ;
*/

   IF myForm:actrltype[j] == 'SPINNER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' SPINNER ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:arange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( myForm:arange[j] )
      ENDIF
      IF myForm:avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( myForm:avaluen[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:awrap[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WRAP '
      ENDIF
      IF myForm:areadonly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF myForm:aincrement[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INCREMENT ' + LTrim( Str( myForm:aincrement[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ BACKCOLOR <backcolor> ] ;
   [ FONTCOLOR <fontcolor> ] ;
   [ <invisible : INVISIBLE> ] ;
   [ <rtl: RTL> ] ;
   [ <noborder: NOBORDER> ] ;
*/

   IF myForm:actrltype[j] == 'PICCHECKBUTT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBUTTON ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:apicture[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + "'" + AllTrim( myForm:apicture[j] ) + "'"
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + "'" + '' + "'"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF myForm:avaluel[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF Len( myForm:aonchange[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( myForm:aonchange[j] )
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ CAPTION <caption> ] ;
   [ FONT <f> ] ;
   [ SIZE <n> ] ;
   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <rtl: RTL> ]                    ;
   [ BUFFER <buffer> ] ;
   [ HBITMAP <hbitmap> ] ;
   [ <notrans: NOLOADTRANSPARENT> ] ;
   [ <scale: FORCESCALE> ] ;
   [ FIELD <field> ] ;
   [ <no3dcolors: NO3DCOLORS> ] ;
   [ <autofit: AUTOFIT, ADJUST> ] ;
   [ <lDIB: DIBSECTION> ] ;
*/

   IF myForm:actrltype[j] == 'PICBUTT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BUTTON ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      IF Len( myForm:apicture[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE " + "'" + AllTrim( myForm:apicture[j] ) + "'"
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE " + "'" + '' + "'"
      ENDIF
      IF Len( myForm:aaction[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( myForm:aaction[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + "MsgInfo( 'Button Pressed' )"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF Len( myForm:atooltip[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + "'" + AllTrim( myForm:atooltip[j] ) + "'"
      ENDIF
      IF myForm:aflat[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FLAT '
      ENDIF
      IF Len( myForm:aongotfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( myForm:aongotfocus[j] )
      ENDIF
      IF Len( myForm:aonlostfocus[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( myForm:aonlostfocus[j] )
      ENDIF
      IF myForm:anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF myForm:ahelpid[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( myForm:ahelpid[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ FONT <font> ] ;
   [ SIZE <size> ] ;
   [ <bold : BOLD> ] ;
   [ <italic : ITALIC> ] ;
   [ <underline : UNDERLINE> ] ;
   [ <strikeout : STRIKEOUT> ] ;
   [ ON MOUSEMOVE <onmousemove> ] ;
   [ <invisible: INVISIBLE> ] ;
   [ <rtl: RTL> ] ;
   [ <noprefix: NOPREFIX> ] ;
   [ <disabled: DISABLED> ] ;
   [ CAPTION <caption> ] ;
   [ BUFFER <buffer> ] ;
   [ HBITMAP <hbitmap> ] ;
   [ <notrans: NOLOADTRANSPARENT> ] ;
   [ <scale: FORCESCALE> ] ;
   [ <cancel: CANCEL> ] ;
   [ <alignment:LEFT,RIGHT,TOP,BOTTOM,CENTER> ] ;
   [ <multiline: MULTILINE> ] ;
   [ <themed : THEMED> ] ;
   [ IMAGEMARGIN <aImageMargin> ] ;
   [ <no3dcolors: NO3DCOLORS> ] ;
   [ <autofit: AUTOFIT, ADJUST> ] ;
   [ <lDIB: DIBSECTION> ] ;
*/

   IF myForm:actrltype[j] == 'FRAME'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' FRAME ' + AllTrim( myForm:aname[j] ) + ' '
      IF ! Empty( myForm:acobj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( myForm:acobj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "CAPTION '" + AllTrim( myForm:acaption[j] ) + "'"
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF myForm:aopaque[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OPAQUE '
      ENDIF
      IF myForm:atransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF Len( myForm:afontname[j] ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + "'" + AllTrim( myForm:afontname[j] ) + "'"
      ENDIF
      IF myForm:afontsize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( myForm:afontsize[j] ) )
      ENDIF
      IF myForm:afontcolor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + AllTrim( myForm:afontcolor[j] )
      ENDIF
      IF myForm:abold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF myForm:afontitalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF myForm:afontunderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF myForm:afontstrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ! myForm:aenabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! myForm:avisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      // Frame's backcolor defaults to Form's backcolor.   TODO: Check
      IF myForm:cfbackcolor # 'NIL' .AND. Len( myForm:cfbackcolor ) > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( myForm:cfbackcolor )
      ENDIF
      Output += CRLF + CRLF
   ENDIF
/*
   TODO: Add this properties

   [ <rtl: RTL> ] ;
*/

   // TODO: move up if control syntax supports the property
   IF myForm:aname[j] # NIL
      cName := myForm:aname[j]
   ENDIF
   IF Upper( myForm:actrltype[j] ) $ 'TEXT CHECKBOX BUTTON CHECKBTN COMBO DATEPICKER EDIT GRID LIST PLAYER PROGRESSBAR RADIOGROUP SLIDER SPINNER BROWSE TAB RICHEDIT TIMER PICBUTT PICCHECKBUTT' .AND. j > 1
      IF ! myForm:aenabled[j]
         Output += Space( nSpacing * ( nLevel + 1 ) ) + mlyform + '.' + cName + '.enabled := .F.' + CRLF
         lBlankLine := .T.
      ENDIF
   ENDIF
   IF Upper( myForm:actrltype[j] ) $ 'TEXT CHECKBOX BUTTON CHECKBTN COMBO DATEPICKER EDIT GRID LIST PLAYER PROGRESSBAR RADIOGROUP SLIDER SPINNER BROWSE TAB RICHEDIT PICBUTT PICCHECKBUTT' .AND. j > 1
      IF myForm:actrltype[j] # 'TIMER'
         IF ! myForm:avisible[j]
            Output += Space( nSpacing * ( nLevel + 1 ) ) + mlyform + '.' + cName + '.visible := .F.' + CRLF
            lBlankLine := .T.
         ENDIF
      ENDIF
   ENDIF
   IF  UPPER( myForm:actrltype[j] ) $ 'TEXT EDIT DATEPICKER BUTTON CHECKBOX LIST COMBO CHECKBTN GRID SPINNER BROWSE RADIOGROUP RICHEDIT' .AND. j > 1
      IF myForm:afontitalic[j]
         Output += Space( nSpacing * ( nLevel + 1 ) ) + mlyform + '.' + cName + '.fontitalic := .T.' + CRLF
         lBlankLine := .T.
      ENDIF
      IF myForm:afontunderline[j]
         Output += Space( nSpacing * ( nLevel + 1 ) ) + mlyform + '.' + cName + '.fontunderline := .T.' + CRLF
         lBlankLine := .T.
      ENDIF
      IF myForm:afontstrikeout[j]
         Output += Space( nSpacing * ( nLevel + 1 ) ) + mlyform + '.' + cName + '.fontstrikeout := .T.' + CRLF
         lBlankLine := .T.
      ENDIF
      IF myForm:abold[j]
         Output += Space( nSpacing * ( nLevel + 1 ) ) + mlyform + '.' + cName + '.fontbold := .T.' + CRLF
         lBlankLine := .T.
      ENDIF
   ENDIF
   IF UPPER( myForm:actrltype[j] ) $ 'TEXT EDIT CHECKBOX LIST COMBO GRID SPINNER BROWSE RADIOGROUP PROGRESSBAR RICHEDIT' .AND. j > 1
      IF myForm:afontcolor[j] # 'NIL'
         Output += Space( nSpacing * ( nLevel + 1 ) ) + mlyform + '.' + cName + '.fontcolor := ' + AllTrim( myForm:afontcolor[j] ) + CRLF
         lBlankLine := .T.
      ENDIF
   ENDIF
   IF UPPER(myForm:actrltype[j])$'SLIDER TEXT EDIT BUTTON CHECKBOX LIST COMBO CHECKBTN GRID SPINNER BROWSE RADIOGROUP PROGRESSBAR RICHEDIT' .AND. j > 1
      IF myForm:abackcolor[j] # 'NIL'
         Output += Space( nSpacing * ( nLevel + 1 ) ) + mlyform + '.' + cName + '.backcolor := ' + AllTrim( myForm:abackcolor[j] ) + CRLF
         lBlankLine := .T.
      ENDIF
   ENDIF
   IF lBlankLine
      Output += CRLF
   ENDIF
RETURN Output

*------------------------------------------------------------------------------*
STATIC FUNCTION myaScan( cName )
*------------------------------------------------------------------------------*
LOCAL ai, nHandle := 0, l

   l := Len( Form_1:aControls )
   FOR ai := 1 TO l
      IF Lower( Form_1:aControls[ai]:Name ) == Lower( cName )
         nHandle := ai
         EXIT
      ENDIF
   NEXT ai
RETURN nHandle

/*
   TODO: Add this controls

   ACTIVEX
   CHECKLIST
   TIMEPICKER
   HOTKEYBOX
   INTERNAL
   PICTURE
   PROGRESSMETER
   SCROLLBAR
   SPLITBOX
   TEXTARRAY
   XBROWSE
*/
