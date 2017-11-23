/*
TEST ONLY !!!!!!!!!!!!!!!
Testing over HMG3 + HMG EXTENDED + HWGUI + OOHG

2017.10.09.1215 - Do not insert blank line if line have continuation (;)
2017.11.23.0000 - Method inside CREATECLASS/CLASS
*/
#include "directry.ch"
#include "inkey.ch"
#include "hbclass.ch"

#define FMT_COMMENT_OPEN  "/" + "*"
#define FMT_COMMENT_CLOSE "*" + "/"
#define FMT_TO_UPPER      1
#define FMT_TO_LOWER      2
#define FMT_GO_AHEAD      3
#define FMT_GO_BACK       4
#define FMT_SELF_BACK     5
#define FMT_BLANK_LINE    6
#define FMT_DECLARE_VAR   7
#define FMT_AT_BEGIN      8

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
           Upper( RIght( oElement[ F_NAME ], 3 ) ) == ".CH" .OR. ;
           Upper( Right( oElement[ F_NAME ], 2 ) ) == ".H" .OR. ;
           Upper( Right( oElement[ F_NAME ], 4 ) ) == ".FMG" .OR. ;
           Upper( Right( oElement[ F_NAME ], 4 ) ) == ".BAT" .OR. ;
           Upper( Right( oElement[ F_NAME ], 2 ) ) == ".C" .OR. ;
           Upper( Right( oElement[ F_NAME ], 4 ) ) == ".CPP"
         FormatFile( cPath + oElement[ F_NAME ], @nContYes, @nContNo )
      ENDCASE
      nKey := iif( nKey == 27, nKey, Inkey() )
      IF nKey == K_ESC
         EXIT
      ENDIF
   NEXT

   RETURN NIL

STATIC FUNCTION FormatFile( cFile, nContYes, nContNo )

   LOCAL cTxtPrg, cTxtPrgAnt, acPrgLines, oElement
   LOCAL lPrg := .T.
   LOCAL oFormat := FormatClass():New()

   cTxtPrgAnt := MemoRead( cFile )
   IF "HB_INLINE" $ cTxtPrgAnt // fonte C embutido no PRG - não #pragma begin dump
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
         CASE IsBeginDump( oElement ) ; lPrg := .F.
         CASE ! lPrg
            IF IsEndDump( oElement )
               lPrg := .T.
            ENDIF
         OTHERWISE
            FormatIndent( @oElement, oFormat )
         ENDCASE
      NEXT
      FormatRest( @cTxtPrg, @acPrgLines )
   ELSE
      cTxtPrg := ""
      FOR EACH oElement IN acPrgLines
         cTxtPrg += Trim( oElement ) + hb_Eol()
      NEXT
   ENDIF
   // save if changed
   IF ! cTxtPrg == cTxtPrgAnt
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

   LOCAL cThisLineUpper

   LOCAL nIdent2 := 0

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
      oFormat:lContinue := Right( cThisLineUpper, 1 ) == ";"
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
      cLinePrg := Space( ( Max( oFormat:nIdent + nIdent2, 0 ) ) * 3 ) + AllTrim( cLinePrg )
   ENDIF
   IF oFormat:lComment
      RETURN NIL
   ENDIF
   DO CASE
   CASE ";" $ cThisLineUpper .AND. hb_LeftEq( cThisLineUpper, "IF " ) .AND. Right( cThisLineUpper, 5 ) == "ENDIF"
   CASE ";" $ cThisLineUpper .AND. hb_LeftEq( cThisLineUpper, "DO WHILE " ) .AND. Right( cThisLineUpper, 5 ) == "ENDDO"
   CASE ";" $ cThisLineUpper .AND. hb_LeftEq( cThisLineUpper, "WHILE " ) .AND. Right( cThisLineUpper, 5 ) == "ENDDO"
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

FUNCTION FormatRest( cTxtPrg, acPrgLines )

   LOCAL cThisLineUpper, nLine := 1, lPrg := .T.
   LOCAL oFormat := FormatClass():New()

   cTxtPrg  := ""
   DO WHILE nLine <= Len( acPrgLines )
      cThisLineUpper := Upper( AllTrim( acPrgLines[ nLine ] ) )
      DO CASE
      CASE IsEndDump( cThisLineUpper ) ;   lPrg := .T.
      CASE ! lPrg
      CASE IsBeginDump( cThisLineUpper ) ; lPrg := .T.
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
      CASE Left( acPrgLines[ nLine ], 1 ) != " " .AND. IsCmdType( FMT_BLANK_LINE, cThisLineUpper );  cTxtPrg += hb_Eol(); oFormat:lEmptyLine := .T.
      CASE Left( cThisLineUpper, 6 )  == "RETURN";       cTxtPrg += hb_Eol(); oFormat:lEmptyLine := .T.
      ENDCASE
      IF oFormat:lDeclareVar .AND. ;
         Right( cTxtPrg, 3 ) != ";" + hb_Eol() .AND. ;
         ! IsCmdType( FMT_DECLARE_VAR, cThisLineUpper )
         oFormat:lDeclareVar := .F.
         IF ! Empty( acPrgLines[ nLine ] ) .AND. ! oFormat:lEmptyLine .AND. ! ";" $ cThisLineUpper
            cTxtPrg += hb_Eol()
            oFormat:lEmptyLine := .T.
         ENDIF
      ENDIF
      cTxtPrg += acPrgLines[ nLine ] + hb_Eol()
      DO CASE
      CASE ! lPrg
      CASE oFormat:lComment
      CASE ";" $ cThisLineUpper
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
   IF IsCmdType( FMT_TO_UPPER, cLinePrg, @nPos )
      cLinePrg := Upper( FmtList( FMT_TO_UPPER )[ nPos ] ) + Substr( cLinePrg, Len( FmtList( FMT_TO_UPPER )[ nPos ] ) + 1 )
   ENDIF
   IF isCmdType( FMT_TO_LOWER, cLinePrg, @nPos )
      cLinePrg := Lower( FmtList( FMT_TO_LOWER )[ nPos ] ) + Substr( cLinePrg, Len( FmtList( FMT_TO_LOWER )[ nPos ] ) + 1 )
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

   DO CASE
   CASE nType == FMT_TO_UPPER

      aList := { ;
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
         "END BUTTON", ;
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
         "END INI", ;
         "END LABEL", ;
         "END PAGE", ;
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
         "ENDCASE", ;
         "ENDCLASS", ;
         "ENDDO", ;
         "ENDIF", ;
         "ENDSEQUENCE", ;
         "ENDSWITCH", ;
         "ENDTEXT", ;
         "ENDFOR", ;
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
         "METHOD", ;
         "NEXT", ;
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
         "RUN", ;
         "SAVE", ;
         "SEEK", ;
         "SELECT", ;
         "SET", ;
         "SET ALTERNATE ON", ;
         "SET ALTERNATE OFF", ;
         "SET ALTERNATE TO", ;
         "SET CENTURY ON", ;
         "SET CENTURY OFF", ;
         "SET CONFIRM ON", ;
         "SET CONFIRM OFF", ;
         "SET CONSOLE ON", ;
         "SET CONSOLE OFF", ;
         "SET DATE", ;
         "SET DATE ANSI", ;
         "SET DATE BRITISH", ;
         "SET DELETED", ;
         "SET DELETED ON", ;
         "SET DELETED OFF", ;
         "SET EPOCH TO", ;
         "SET MULTIPLE ON", ;
         "SET MULTIPLE OFF", ;
         "SET PRINTER OFF", ;
         "SET PRINTER ON", ;
         "SET PRINTER TO", ;
         "SET RELATION TO", ;
         "SET SECTION", ;
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

   CASE nType == FMT_TO_LOWER
      aList := { ;
         "#COMMAND", ;
         "#DEFINE", ;
         "#ELSE", ;
         "#ENDIF", ;
         "#IFDEF", ;
         "#IFNDEF", ;
         "#PRAGMA", ;
         "#INCLUDE", ;
         "#PRAGMA BEGINDUMP", ;
         "#PRAGMA ENDDUMP", ;
         "#TRANSLATE" }

   CASE nType == FMT_GO_AHEAD
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

   CASE nType == FMT_GO_BACK

      aList := { ;
         "END", ;
         "ENDCASE", ;
         "ENDCLASS", ;
         "ENDIF", ;
         "ENDDO", ;
         "ENDFOR", ;
         "ENDSWITCH", ;
         "NEXT" }

   CASE nType == FMT_SELF_BACK
      aList := { ;
         "CASE", ;
         "CATCH", ;
         "ELSE", ;
         "ELSEIF", ;
         "OTHER", ;
         "OTHERWISE", ;
         "RECOVER" }

   CASE nType == FMT_BLANK_LINE
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

   CASE nType == FMT_DECLARE_VAR
      aList := { ;
         "FIELD", ;
         "LOCAL", ;
         "MEMVAR", ;
         "PRIVATE", ;
         "PUBLIC" }

   CASE nType == FMT_AT_BEGIN

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
