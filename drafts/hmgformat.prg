/*
MGFORMAT - Format source code (indent, line space, first words to upper)
Test over HMG3 + HMG EXTENDED + HWGUI + OOHG

2017.12.01 - Try to solve continuation with comments, anything like this: IF .T. ; ENDIF
*/

#include "directry.ch"
#include "inkey.ch"
#include "hbclass.ch"

#define FMT_COMMENT_OPEN  "/" + "*"
#define FMT_COMMENT_CLOSE "*" + "/"
#define FMT_TO_CASE       1
#define FMT_GO_AHEAD      2
#define FMT_GO_BACK       3
#define FMT_SELF_BACK     4
#define FMT_BLANK_LINE    5
#define FMT_DECLARE_VAR   6
#define FMT_AT_BEGIN      7

FUNCTION Main()

   LOCAL nKey := 0, nContYes := 0, nContNo := 0, cPath := ".\"

   SetMode( 40, 100 )
   CLS

   ? "Hit Alt-D to debug, ESC to quit, or any other key to continue"
   ? "Working on " + cPath
   IF Inkey(0)  != K_ESC
      FormatDir( cPath, @nKey, @nContYes, @nContNo )
   ENDIF

   RETURN NIL

STATIC FUNCTION FormatDir( cPath, nKey, nContYes, nContNo )

   LOCAL oFiles, oElement

   oFiles := Directory( cPath + "*.*", "D" )
   ASort( oFiles, , , { | a, b | a[ 1 ] < b[ 1 ] } )
   FOR EACH oElement IN oFiles
      DO CASE
      CASE "D" $ oElement[ F_ATTR ] .AND. oElement[ F_NAME ] == "."
      CASE "D" $ oElement[ F_ATTR ] .AND. oElement[ F_NAME ] == ".."
      CASE "D" $ oELement[ F_ATTR ]
         FormatDir( cPath + oElement[ F_NAME ] + "\", @nKey, @nContYes, @nContNo )
      CASE Upper( Right( oElement[ F_NAME ], 4 ) ) == ".PRG" .OR. ;
           Upper( Right( oElement[ F_NAME ], 4 ) ) == ".FMG" .OR. ;
           Upper( RIght( oElement[ F_NAME ], 3 ) ) == ".CH" .OR. ;
           Upper( Right( oElement[ F_NAME ], 2 ) ) == ".H" .OR. ;
           Upper( Right( oElement[ F_NAME ], 4 ) ) == ".BAT" .OR. ;
           Upper( Right( oElement[ F_NAME ], 2 ) ) == ".C" .OR. ;
           Upper( Right( oElement[ F_NAME ], 4 ) ) == ".CPP" .OR. ;
           Upper( Right( oElement[ F_NAME ], 4 ) ) == ".TXT"
         FormatFile( cPath + oElement[ F_NAME ], @nContYes, @nContNo )
      ENDCASE
      nKey := iif( nKey == 27, nKey, Inkey() )
      IF nKey == K_ESC
         EXIT
      ENDIF
   NEXT

   RETURN NIL

STATIC FUNCTION FormatFile( cFile, nContYes, nContNo )

   LOCAL cTxtPrg, cTxtPrgAnt, acPrgLines, oElement, lPrgSource := .T.
   LOCAL oFormat := FormatClass():New()

   cTxtPrgAnt := MemoRead( cFile )
   IF "HB_INLINE" $ cTxtPrgAnt // C source inside PRG source, but not #pragma begindump
      ? cFile
      ? Space(3) + " ignored because have HB_INLINE"
      RETURN NIL
   ENDIF
   cTxtPrg    := cTxtPrgAnt
   cTxtPrg    := StrTran( cTxtPrg, Chr(9), Space(3) )
   cTxtPrg    := StrTran( cTxtPrg, Chr(13) + Chr(10), Chr(10) )
   cTxtPrg    := StrTran( cTxtPrg, Chr(13), Chr(10) )
   cTxtPrg    := StrTran( cTxtPrg, Chr(10) + Chr(10) + Chr(10), Chr(10) + Chr(10) )
   acPrgLines := hb_RegExSplit( Chr(10), cTxtPrg )
   DO WHILE .T.
      IF Len( acPrgLines ) < 1 .OR. ! Empty( acPrgLines[ Len( acPrgLines ) ] )
         EXIT
      ENDIF
      aSize( acPrgLines, Len( acPrgLines ) - 1 )
   ENDDO

   IF Upper( Right( cFile, 4 ) ) == ".PRG" .OR. Upper( Right( cFile, 4 ) ) == ".FMG"
      FOR EACH oElement IN acPrgLines
         oElement := Trim( oElement )
         DO CASE
         CASE IsBeginDump( oElement ) ; lPrgSource := .F.
         CASE ! lPrgSource
            IF IsEndDump( oElement )
               lPrgSource := .T.
            ENDIF
         OTHERWISE
            FormatIndent( @oElement, oFormat )
         ENDCASE
      NEXT
      FormatEmptyLine( @cTxtPrg, @acPrgLines )
   ELSE
      cTxtPrg := ""
      FOR EACH oElement IN acPrgLines
         cTxtPrg += Trim( oElement ) + hb_Eol()
      NEXT
   ENDIF
   // save if changed
   IF ! cTxtPrg == cTxtPrgAnt
      MakeBackup( cFile )
      nContYes += 1
      ? nContYes, nContNo, "Formatted " + cFile
      fErase( cFile )
      hb_MemoWrit( Lower( cFile ), cTxtPrg )
      //wapi_ShellExecute( NIL, "open", cFile,, WIN_SW_SHOWNORMAL )
      //IF Mod( nContYes, 10 ) == 0
      //   ? "Hit any key"
      //   IF Inkey(0) == K_ESC
      //      QUIT
      //   ENDIF
      //ENDIF
   ELSE
      nContNo += 1
   ENDIF

   RETURN NIL

FUNCTION FormatIndent( cLinePrg, oFormat )

   LOCAL cThisLineUpper, nIdent2 := 0

   cThisLineUpper := AllTrim( Upper( cLinePrg ) )
   IF Left( cThisLineUpper, 2 ) == FMT_COMMENT_OPEN .AND. ! FMT_COMMENT_CLOSE $ cThisLineUpper
      oFormat:lComment := .T. // begin comment code
   ENDIF
   IF Left( cThisLineUpper, 2 ) == FMT_COMMENT_CLOSE
      oFormat:lComment := .F. // end comment code
   ENDIF
   IF Right( cThisLineUpper, 2 ) == FMT_COMMENT_CLOSE .AND. oFormat:lComment
      oFormat:lComment := .F.
   ENDIF
   // line continuation, make ident
   IF oFormat:lContinue .AND. ! oFormat:lComment
      nIdent2 += 1
   ENDIF
   // line continuation, without comment, will ident next
   IF ! ( Left( cThisLineUpper, 1 ) == "*" .OR. Left( cThisLineUpper, 2 ) == "//" .OR. oFormat:lComment )
      oFormat:lContinue := IsLineContinue( cThisLineUpper )
   ENDIF
   IF ! oFormat:lComment
      FormatCase( @cLinePrg )
      IF IsCmdType( FMT_SELF_BACK, cThisLineUpper ) .OR. IsCmdType( FMT_GO_BACK, cThisLineUpper )
         IF ! Left( cThisLineUpper, 6 ) == "METHOD" .OR. ! oFormat:lIsClass
            oFormat:nIdent -= 1
         ENDIF
      ENDIF
      IF IsCmdType( FMT_AT_BEGIN, cThisLineUpper )
         IF ! Left( cThisLineUpper, 6 ) == "METHOD" .OR. ! oFormat:lIsClass
            oFormat:nIdent := 0
            nIdent2        := 0
         ENDIF
      ENDIF
   ENDIF
   IF Empty( cLinePrg )
      cLinePrg := ""
   ELSE
      IF ! oFormat:lComment
         IF Left( AllTrim( cLinePrg ), 1 ) == "#" .AND. ! oFormat:lComment
            nIdent2 := -oFormat:nIdent // 0 col
         ELSEIF AScan( { "ENDCLASS", " END CLASS" },,, { | e | Upper( AllTrim( cLinePrg ) ) == e } ) != 0
            nIdent2 := 1 - oFormat:nIdent // 1 col
         ENDIF
      ENDIF
      cLinePrg := Space( ( Max( oFormat:nIdent + nIdent2, 0 ) ) * 3 ) + AllTrim( cLinePrg )
   ENDIF
   IF oFormat:lComment
      RETURN NIL
   ENDIF
   DO CASE
   CASE ";" $ cThisLineUpper .AND. hb_LeftEq( cThisLineUpper, "IF " ) .AND. "ENDIF" $ cThisLineUpper
   CASE ";" $ cThisLineUpper .AND. hb_LeftEq( cThisLineUpper, "DO WHILE " ) .AND. "ENDDO"$ cThisLineUpper
   CASE ";" $ cThisLineUpper .AND. hb_LeftEq( cThisLineUpper, "WHILE " ) .AND. "ENDDO" $ cThisLineUpper
   OTHERWISE
      IF IsCmdType( FMT_SELF_BACK, cThisLineUpper ) .OR. IsCmdType( FMT_GO_AHEAD, cThisLineUpper )
         IF ! Left( cThisLineUpper, 6 ) == "METHOD" .OR. ! oFormat:lIsClass
            oFormat:nIdent += 1
         ENDIF
      ENDIF
   ENDCASE
   IF Left( cThisLineUpper, 3 ) == "END" .AND. oFormat:lIsClass
      oFormat:lIsClass := .F.
   ELSEIF Left( cThisLineUpper, 5 ) == "CLASS" .OR. Left( cThisLineUpper, 12 ) == "CREATE CLASS"
      oFormat:lIsClass := .T.
   ENDIF
   // min column
   oFormat:nIdent := Max( oFormat:nIdent, 0 )

   RETURN NIL

FUNCTION FormatEmptyLine( cTxtPrg, acPrgLines )

   LOCAL cThisLineUpper, nLine := 1, lPrgSource := .T.
   LOCAL oFormat := FormatClass():New()

   cTxtPrg  := ""
   DO WHILE nLine <= Len( acPrgLines )
      cThisLineUpper := Upper( AllTrim( acPrgLines[ nLine ] ) )
      DO CASE
      CASE IsEndDump( cThisLineUpper ) ;   lPrgSource := .T.
      CASE ! lPrgSource
      CASE IsBeginDump( cThisLineUpper ) ; lPrgSource := .F.
      CASE oFormat:lComment .AND. IsEndComment( cThisLineUpper ); oFormat:lComment := .F.
      CASE oFormat:lComment
      CASE IsEmptyComment( cThisLineUpper )
         nLine += 1
         LOOP
      CASE IsBeginComment( cThisLineUpper ) ; oFormat:lComment := .T.
      CASE oFormat:lEmptyLine
         IF Empty( cThisLineUpper )
            nLine += 1
            LOOP
         ENDIF
      CASE Left( acPrgLines[ nLine ], 1 ) != " " .AND. IsCmdType( FMT_BLANK_LINE, cThisLineUpper ) ;  cTxtPrg += hb_Eol(); oFormat:lEmptyLine := .T.
      CASE Left( cThisLineUpper, 7 )  == "RETURN " .AND. At( "RETURN", acPrgLines[ nLine ] ) < 5   ;  cTxtPrg += hb_Eol(); oFormat:lEmptyLine := .T.
      CASE cThisLineUpper == "RETURN" .AND. At( "RETURN", acPrgLines[ nLine ] ) < 5   ;  cTxtPrg += hb_Eol(); oFormat:lEmptyLine := .T.
      ENDCASE
      IF oFormat:lDeclareVar .AND. ;
         Right( cTxtPrg, 3 ) != ";" + hb_Eol() .AND. ;
         ! IsCmdType( FMT_DECLARE_VAR, cThisLineUpper )
         oFormat:lDeclareVar := .F.
         IF ! Empty( acPrgLines[ nLine ] ) .AND. ! oFormat:lEmptyLine .AND. ! IsLineContinue( cThisLineUpper )
            cTxtPrg += hb_Eol()
            oFormat:lEmptyLine := .T.
         ENDIF
      ENDIF
      cTxtPrg += acPrgLines[ nLine ] + hb_Eol()
      DO CASE
      CASE ! lPrgSource
      CASE oFormat:lComment
      CASE IsLineContinue( cThisLineUpper )
      CASE Left( acPrgLines[ nLine ], 1 ) != " " .AND. IsCmdType( FMT_BLANK_LINE,  cThisLineUpper ); cTxtPrg += hb_Eol(); cThisLineUpper := ""
      CASE IsCmdType( FMT_DECLARE_VAR, cThisLineUpper ) ; oFormat:lDeclareVar := .T.
      ENDCASE
      oFormat:lEmptyLine := ( Empty( cThisLineUpper ) )
      nLine += 1
   ENDDO
   DO WHILE Replicate( hb_Eol(), 3 ) $ cTxtPrg
      cTxtPrg := StrTran( cTxtPrg, Replicate( hb_Eol(), 3 ), Replicate( hb_Eol(), 2 ) )
   ENDDO

   RETURN NIL

FUNCTION FormatCase( cLinePrg )

   LOCAL nPos

   cLinePrg := AllTrim( cLinePrg )
   IF IsCmdType( FMT_TO_CASE, cLinePrg, @nPos )
      cLinePrg := FmtList( FMT_TO_CASE )[ nPos ] + Substr( cLinePrg, Len( FmtList( FMT_TO_CASE )[ nPos ] ) + 1 )
   ENDIF

   RETURN NIL

CREATE CLASS FormatClass

   VAR nIdent      INIT 0
   VAR lFormat     INIT .T.
   VAR lContinue   INIT .F.
   VAR lComment    INIT .F.
   VAR lEmptyLine  INIT .F.
   VAR lDeclareVar INIT .F.
   VAR lIsClass    INIT .F.

   ENDCLASS

STATIC FUNCTION IsBeginDump( cText )

   RETURN Lower( Left( AllTrim( cText ), 17 ) ) == "#" + "pragma begindump"

STATIC FUNCTION IsEndDump( cText )

   RETURN Lower( Left( AllTrim( cText ), 15 ) ) == "#" + "pragma enddump"

STATIC FUNCTION IsLineContinue( cText )

   LOCAL nPos

   // May be IF .T.; ENDIF, or xxx ; // comment

   IF .NOT. ";" $ cText
      RETURN .F.
   ENDIF
   IF "//" $ cText
      cText := Trim( Substr( cText, 1, At( "//", cText ) - 1 ) )
   ENDIF
   IF Right( cText, 1 ) == ";"
      RETURN .T.
   ENDIF
   nPos  := hb_At( ";", cText )
   IF "/*" $ cText
      IF At( "/*", cText ) < nPos
         RETURN .F.
      ENDIF
      cText := Trim( Substr( cText, 1, At( "/*", cText ) - 1 ) )
   ENDIF
   IF nPos < Len( cText ) // tem algo além do ;, talvez IF x; ENDIF
      RETURN .F.
   ENDIF

   RETURN .T.

STATIC FUNCTION IsBeginComment( cText )

   RETURN Left( AllTrim( cText ), 2 ) == "*" + "/" .AND. ! "*" + "/" $ cText

STATIC FUNCTION IsEndComment( cText )

   RETURN Left( AllTrim( cText ), 2 ) == "*" + "/"

STATIC FUNCTION IsEmptyComment( cText )

   LOCAL oElement

   cText := AllTrim( cText )
   // caution with above line, to not consider */
   IF "*/" $ cText .OR. ! ( hb_LeftEq( cText, "*" ) .OR. hb_LeftEq( cText, "//" ) )
      RETURN .F.
   ENDIF
   FOR EACH oElement IN cText
      IF ! oElement $ "/-*~"
         RETURN .F.
      ENDIF
   NEXT

   RETURN .T.

FUNCTION IsCmdType( nType, cTxt, nPos )

   LOCAL oElement

   nPos := 0
   FOR EACH oElement IN FmtList( nType ) DESCEND
      IF Upper( cTxt ) == Upper( oElement ) .OR. hb_LeftEq( Upper( cTxt ) + " ", Upper( oELement ) + " " )
         nPos := oElement:__EnumIndex
         EXIT
      ENDIF
   NEXT
   //nPos := AScan( FmtList( nType ), { | e | Upper( cTxt ) == Upper( e ) .OR. hb_LeftEq( Upper( cTxt ), Upper( e ) + " " )  } )

   RETURN nPos != 0

STATIC FUNCTION FmtList( nType )

   LOCAL aList

   // only first world of line
   DO CASE
   CASE nType == FMT_TO_CASE // word(s) will be on this case, upper or lower

      aList := { ;
         "#command", ;
         "#define", ;
         "#else", ;
         "#endif", ;
         "#ifdef", ;
         "#ifndef", ;
         "#include", ;
         "#pragma", ;
         "#pragma begindump", ;
         "#pragma enddump", ;
         "#translate", ;
         "ACCEPT", ;
         "ACTIVATE WINDOW", ;
         "ANNOUNCE", ;
         "APPEND", ;
         "APPEND BLANK", ;
         "AVERAGE", ;
         "BEGIN", ;
         "BEGIN INI FILE", ;
         "CASE", ;
         "CATCH", ;
         "CENTER WINDOW", ;
         "CLASS", ;
         "CLASSVAR", ;
         "CLEAR", ;
         "CLOSE", ;
         "COMMIT", ;
         "CONTINUE", ;
         "COPY", ;
         "COUNT", ;
         "CREATE", ;
         "CREATE CLASS", ;
         "DATA", ;
         "DECLARE", ;
         "DEFAULT", ;
         "DEFINE ACTIVEX", ;
         "DEFINE BROWSE", ;
         "DEFINE BUTTON", ;
         "DEFINE BUTTONEX", ;
         "DEFINE CHECKBOX", ;
         "DEFINE CHECKLIST", ;
         "DEFINE COMBOBOX", ;
         "DEFINE COMBOSEARCH", ;
         "DEFINE COMBOSEARCHBOX", ;
         "DEFINE COMBOSEARCHGRID", ;
         "DEFINE CONTEXT", ;
         "DEFINE CONTROL CONTEXTMENU", ;
         "DEFINE DATEPICKER", ;
         "DEFINE EDITBOX", ;
         "DEFINE FRAME", ;
         "DEFINE GRID", ;
         "DEFINE IMAGE", ;
         "DEFINE INTERNAL", ;
         "DEFINE LABEL", ;
         "DEFINE LISTBOX", ;
         "DEFINE MAIN MENU", ;
         "DEFINE MENU", ;
         "DEFINE PAGE", ;
         "DEFINE POPUP", ;
         "DEFINE RADIOGROUP", ;
         "DEFINE SLIDER", ;
         "DEFINE SPINNER", ;
         "DEFINE SPLITBOX", ;
         "DEFINE STATUSBAR", ;
         "DEFINE TAB", ;
         "DEFINE TEXTBOX", ;
         "DEFINE TIMEPICKER", ;
         "DEFINE TREE", ;
         "DEFINE TOOLBAR", ;
         "DEFINE WINDOW", ;
         "DELETE", ;
         "DISPLAY", ;
         "DO CASE", ;
         "DO WHILE", ;
         "DRAW LINE", ;
         "DYNAMIC", ;
         "EJECT", ;
         "ELSE", ;
         "ELSEIF", ;
         "END", ;
         "END BUTTON", ;
         "END BUTTONEX", ;
         "END CLASS", ;
         "END CASE", ;
         "END CHECKBOX", ;
         "END COMBOBOX", ;
         "END COMBOSEARCH", ;
         "END COMBOSEARCHBOX", ;
         "END COMBOSEARCHGRID", ;
         "END FRAME", ;
         "END GRID", ;
         "END IF", ;
         "END IMAGE", ;
         "END INI", ;
         "END LABEL", ;
         "END MENU", ;
         "END PAGE", ;
         "END POPUP", ;
         "END PRINTDOC", ;
         "END PRINTPAGE", ;
         "END SEQUENCE", ;
         "END SPLITBOX", ;
         "END STATUSBAR", ;
         "END SWITCH", ;
         "END TAB", ;
         "END TEXTBOX", ;
         "END TIMEPICKER", ;
         "END WINDOW", ;
         "END WITH", ;
         "ENDCASE", ;
         "ENDCLASS", ;
         "ENDDO", ;
         "ENDFOR", ;
         "ENDIF", ;
         "ENDSEQUENCE", ;
         "ENDSWITCH", ;
         "ENDTEXT", ;
         "ENDWITH", ;
         "ERASE", ;
         "EXECUTE FILE", ;
         "EXIT", ;
         "EXTERNAL", ;
         "FOR", ;
         "FOR EACH", ;
         "FUNCTION", ;
         "IF", ;
         "GET", ;
         "GOTO", ;
         "GO TOP", ;
         "INDEX", ;
         "INDEX ON", ;
         "INIT", ;
         "INIT PROCEDURE", ;
         "INPUT", ;
         "JOIN", ;
         "KEYBOARD", ;
         "LABEL", ;
         "LIST", ;
         "LOAD WINDOW", ;
         "LOCAL", ;
         "LOCATE", ;
         "LOOP", ;
         "MEMVAR", ;
         "MENU", ;
         "MENUITEM", ;
         "METHOD", ;
         "NEXT", ;
         "ON KEY ESCAPE ACTION", ;
         "OTHER", ;
         "OTHERWISE", ;
         "PACK", ;
         "PARAMETERS", ;
         "POPUP", ;
         "PRINT", ;
         "PRIVATE", ;
         "PROCEDURE", ;
         "PUBLIC", ;
         "QUIT", ;
         "READ", ;
         "RECALL", ;
         "RECOVER", ;
         "REINDEX", ;
         "RELEASE", ;
         "RELEASE WINDOW", ;
         "RENAME", ;
         "REPLACE", ;
         "REQUEST", ;
         "RESTORE", ;
         "RETURN", ;
         "RETURN NIL", ;
         "RETURN SELF", ;
         "RUN", ;
         "SAVE", ;
         "SEEK", ;
         "SELECT", ;
         "SEPARATOR", ;
         "SET", ;
         "SET ALTERNATE ON", ;
         "SET ALTERNATE OFF", ;
         "SET ALTERNATE TO", ;
         "SET AUTOADJUST ON", ;
         "SET AUTOADJUST OFF", ;
         "SET BROWSESYNC ON", ;
         "SET BROWSESYNC OFF", ;
         "SET CENTURY ON", ;
         "SET CENTURY OFF", ;
         "SET CODEPAGE TO", ;
         "SET CONFIRM ON", ;
         "SET CONFIRM OFF", ;
         "SET CONSOLE ON", ;
         "SET CONSOLE OFF", ;
         "SET DEFAULT TO", ;
         "SET DATE", ;
         "SET DATE ANSI", ;
         "SET DATE BRITISH", ;
         "SET DELETED", ;
         "SET DELETED ON", ;
         "SET DELETED OFF", ;
         "SET EPOCH TO", ;
         "SET INTERACTIVE CLOSE ON", ;
         "SET INTERACTIVE CLOSE OFF", ;
         "SET LANGUAGE TO", ;
         "SET MULTIPLE ON", ;
         "SET MULTIPLE OFF", ;
         "SET NAVIGATION EXTENDED", ;
         "SET PATH TO", ;
         "SET PRINTER OFF", ;
         "SET PRINTER ON", ;
         "SET PRINTER TO", ;
         "SET RELATION TO", ;
         "SET SECTION", ;
         "SET TOOLTIPBALOON ON", ;
         "SET TOOLTIPBALOON OFF", ;
         "SKIP", ;
         "SORT", ;
         "START PRINTDOC", ;
         "START PRINTPAGE", ;
         "STATIC", ;
         "STATIC FUNCTION", ;
         "STATIC PROCEDURE", ;
         "STORE", ;
         "SUM", ;
         "SWITCH", ;
         "SWITCH CASE", ;
         "TEXT", ;
         "THEAD STATIC", ;
         "TOTAL", ;
         "UNLOCK", ;
         "UPDATE", ;
         "USE", ;
         "VAR", ;
         "WAIT", ;
         "WHILE", ;
         "WITH OBJECT", ;
         "ZAP" }

   CASE nType == FMT_GO_AHEAD // after this, lines will be indented ahead
      aList := { ;
         "BEGIN", ;
         "CLASS", ;
         "CREATE CLASS", ;
         "DEFINE ACTIVEX", ;
         "DEFINE BUTTON", ;
         "DEFINE BUTTONEX", ;
         "DEFINE BROWSE", ;
         "DEFINE CHECKBOX", ;
         "DEFINE CHECKBUTTON", ;
         "DEFINE CHECKLIST", ;
         "DEFINE COMBOBOX", ;
         "DEFINE COMBOSEARCHBOX", ;
         "DEFINE COMBOSEARCHGRID", ;
         "DEFINE CONTEXT", ;
         "DEFINE CONTROL CONTEXTMENU", ;
         "DEFINE DATEPICKER", ;
         "DEFINE DROPDOWN", ;
         "DEFINE EDITBOX", ;
         "DEFINE FRAME", ;
         "DEFINE GRID", ;
         "DEFINE HYPERLINK", ;
         "DEFINE IMAGE", ;
         "DEFINE INTERNAL", ;
         "DEFINE IPADDRESS", ;
         "DEFINE LABEL", ;
         "DEFINE LISTBOX", ;
         "DEFINE MAIN MENU", ;
         "DEFINE MAINMENU", ;
         "DEFINE MENU", ;
         "DEFINE NODE", ;
         "DEFINE NOTIFY MENU", ;
         "DEFINE PAGE", ;
         "DEFINE PLAYER", ;
         "DEFINE POPUP", ;
         "DEFINE PROGRESSBAR", ;
         "DEFINE RADIOGROUP", ;
         "DEFINE REPORT", ;
         "DEFINE RICHEDITBOX", ;
         "DEFINE SLIDER", ;
         "DEFINE SPINNER", ;
         "DEFINE SPLITBOX", ;
         "DEFINE STATUSBAR", ;
         "DEFINE TAB", ;
         "DEFINE TEXTBOX", ;
         "DEFINE TIMEPICKER", ;
         "DEFINE TOOLBAR", ;
         "DEFINE TREE", ;
         "DEFINE WINDOW", ;
         "DO CASE", ;
         "DO WHILE", ;
         "FOR", ;
         "FUNC", ;
         "FUNCTION", ;
         "IF", ;
         "INIT PROC", ;
         "INIT PROCEDURE", ;
         "METHOD", ;
         "NODE", ;
         "PAGE", ;
         "POPUP", ;
         "PROC", ;
         "PROCEDURE", ;
         "RECOVER", ;
         "START HPDFDOC", ;
         "START HPDFPAGE", ;
         "START PRINTDOC", ;
         "START PRINTPAGE", ;
         "STATIC FUNC", ;
         "STATIC FUNCTION", ;
         "STATIC PROC", ;
         "STATIC PROCEDURE", ;
         "SWITCH", ;
         "TRY", ;
         "WHILE", ;
         "WITH OBJECT" }

   CASE nType == FMT_GO_BACK // including this, lines will be indented back

      aList := { ;
         "END", ;
         "ENDCASE", ;
         ; // "ENDCLASS", ;
         "ENDIF", ;
         "ENDDO", ;
         "ENDFOR", ;
         "ENDSWITCH", ;
         "ENDWITH", ;
         "NEXT" }

   CASE nType == FMT_SELF_BACK // this line will be indented back
      aList := { ;
         "CASE", ;
         "CATCH", ;
         "ELSE", ;
         "ELSEIF", ;
         "OTHER", ;
         "OTHERWISE", ;
         "RECOVER" }

   CASE nType == FMT_BLANK_LINE // a blank line before this line
      aList := { ;
         "CLASS", ;
         "CREATE CLASS", ;
         "END CLASS", ;
         "ENDCLASS", ;
         "FUNCTION", ;
         "METHOD", ;
         "PROC", ;
         "PROCEDURE", ;
         "STATIC FUNC", ;
         "STATIC FUNCTION", ;
         "STATIC PROC", ;
         "STATIC PROCEDURE" }

   CASE nType == FMT_DECLARE_VAR // only to group declarations
      aList := { ;
         "FIELD", ;
         "LOCAL", ;
         "MEMVAR", ;
         "PRIVATE", ;
         "PUBLIC" }

   CASE nType == FMT_AT_BEGIN // this will be at ZERO Column

      aList := { ;
         "CREATE CLASS", ;
         "CLASS", ;
         "INIT PROCEDURE", ;
         "METHOD", ;
         "FUNCTION", ;
         "PROCEDURE", ;
         "STATIC FUNCTION", ;
         "STATIC PROCEDURE" }

   ENDCASE

   RETURN aList

FUNCTION MakeBackup( cFile )

   LOCAL cFileBak

   IF "." $ cFile
      cFileBak := Substr( cFile, 1, Rat( ".", cFile ) ) + "bak"
   ELSE
      cFileBak := cFile + ".bak"
   ENDIF
   hb_MemoWrit( cFileBak, MemoRead( cFile ) )

   RETURN NIL
