/*
Only a draft to compile using EXE and not a BAT
Better to use HBMK2, but seems XHarbour do not want it
*/

#include "directry.ch"
#define CMD_PARAM    1
#define SRC_PRG_LIST 2
#define SRC_C_LIST   3
#define SRC_RC_LIST  4
#define LIB_LIST     5
#define PRG_PARAM    6
#define C_PARAM      7
#define ROOT_HB      8
#define ROOT_C       9
#define ROOT_HMG     10
#define C_EXE        11

PROCEDURE Main

   LOCAL aParam := Array(11), oElement, aFiles, aItem
   LOCAL cTxt   := "MINIHBMK %*" + hb_Eol() + "HERE ENTER THE OUTPUT OF EXE" + hb_Eol()

   Afill( aParam, {} )
   aParam[ C_EXE ]    := "bcc32.exe"
   aParam[ ROOT_HB ]  := "d:\harbour\"
   aParam[ ROOT_C ]   := "d:\harbour\comp\bcc\"
   aParam[ ROOT_HMG ] := "d:\oohg\"

   aParam[ CMD_PARAM ] := hb_AParams()

   FOR EACH oElement IN aParam[ CMD_PARAM ]
      DO CASE
      CASE oElement == "-auto"
         aFiles := Directory( "*.prg" )
         FOR EACH aItem IN aFiles
            AAdd( aParam[ SRC_PRG_LIST ], FilePrefix( aItem[ F_NAME ] ) )
         NEXT
         aFiles := Directory( "*.c" )
         FOR EACH aItem IN aFiles
            AAdd( aParam[ SRC_C_LIST ], FilePrefix( aItem[ F_NAME ] ) )
         NEXT
      CASE Upper( Right( oElement, 4 ) ) == ".HBP" ; HBPToParam( oElement, @aParam )
      CASE Upper( Right( oElement, 4 ) ) == ".PRG" ; AAdd( aParam[ SRC_PRG_LIST ], FilePrefix( oElement ) )
      CASE Upper( Right( oElement, 2 ) ) == ".C"   ; AAdd( aParam[ SRC_C_LIST ],   FilePrefix( oElement ) )
      CASE Upper( Right( oElement, 3 ) ) == ".RC"  ; AAdd( aParam[ SRC_RC_LIST ],  FilePrefix( oElement ) )
      CASE oElement == "-m"                        ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == "-n"                        ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == "-w0"                       ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == "-w1"                       ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == "-w2"                       ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == "-w3"                       ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == "-es0"                      ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == "-es1"                      ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == "-es2"                      ; AAdd( aParam[ PRG_PARAM ], oElement )
      CASE oElement == Left( oElement, 2 ) == "-l" ; AAdd( aParam[ LIB_LIST ],  Substr( oElement, 3 ) )
      ENDCASE
   NEXT
   AAdd( aParam[ PRG_PARAM ], "-n1" )
   AAdd( aParam[ PRG_PARAM ], "-i" + aParam[ ROOT_HB ]  + "\include;" )
   AAdd( aParam[ PRG_PARAM ], "-i" + aParam[ ROOT_HMG ] + "\include;" )
   IF .T.
      aParam[ C_EXE ] := "bcc32.exe"
      AAdd( aParam[ C_PARAM ], "-c" )
      AAdd( aParam[ C_PARAM ], "-O2" )
      AAdd( aParam[ C_PARAM ], "-tW" )
      AAdd( aParam[ C_PARAM ], "-M" )
      AAdd( aParam[ C_PARAM ], "-w" )
      AAdd( aParam[ C_PARAM ], "-I" + aParam[ ROOT_HB ]  + "\include;" )
      AAdd( aParam[ C_PARAM ], "-I" + aParam[ ROOT_C ]   + "\include;" )
      AAdd( aParam[ C_PARAM ], "-I" + aParam[ ROOT_C ]   + "\lib\include;" )
      AAdd( aParam[ C_PARAM ], "-I" + aParam[ ROOT_HMG ] + "\include;" )
   ENDIF

   FOR EACH oElement IN aParam[ SRC_PRG_LIST ]
      cTxt += "if not errorlevel 1 harbour " + oElement + ".prg " + ToParam( aParam[ PRG_PARAM ] ) + hb_Eol()
      cTxt += "if not errorlevel 1 " + aParam[ C_EXE ] + " " + ToParam( aParam[ C_PARAM ] ) + " " + oElement + ".c" + hb_Eol()
   NEXT
   FOR EACH oElement IN aParam[ SRC_C_LIST ]
      cTxt += "if not errorlevel 1 " + aParam[ C_EXE ] + " " + ToParam( aParam[ C_PARAM ] ) + " " + oElement + ".c" + hb_Eol()
   NEXT
   cTxt += "ilink32 link.lnk"  + hb_Eol()
   cTxt += "del link.lnk"  + hb_Eol()

   // LinkAll( aParam )

   hb_MemoWrit( "c.bat", cTxt )

   RETURN

FUNCTION FilePrefix( cValue)

   IF "." $ cValue
      cValue := Substr( cValue, 1, Rat( ".", cValue ) - 1 )
   ENDIF

   RETURN cValue

FUNCTION ToParam( aList )

   LOCAL cTxt := "", oElement

   FOR EACH oELement IN aList
      cTxt += " " + oElement
   NEXT

   RETURN cTxt

FUNCTION HBPToParam( cFile, aParam )

   LOCAL cTxt

   cTxt := AllTrim( StrTran( MemoRead( cFile ), hb_Eol(), " " ) )
   DO WHILE " " $ cTxt
      AAdd( aParam, Substr( cTxt, 1, At( " ", cTxt ) - 1 ) )
      cTxt := AllTrim( Substr( cTxt, At( " ", cTxt + "  " ) ) )
   ENDDO
   IF ! Empty( cTxt )
      AAdd( aParam, cTxt )
   ENDIF

   RETURN NIL
