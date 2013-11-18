/*
 * $Id: MpmCommon.prg,v 1.1 2013-11-18 20:40:25 migsoft Exp $
 */

#include "oohg.ch"

   DECLARE WINDOW main


Function VerifyTop( cFile )
    Local aDirectry := {}
    Local aPickList := {}
    Local lVer := .F.

    aDirectry := Directory( "*.rc" )

    If Len( aDirectry ) > 0
       For x := 1 to Len( aDirectry )
           aadd( aPickList, aDirectry[ x, 1 ] )
       Next

       ASort( aPickList )

       cFileName := trim( aPickList[ 1 ] )

       If File( cFileName )
          If Upper( DelExt(GetName(cFile))+".rc" ) = Upper( cFileName )
             lVer := .T.
          Endif
       Endif
    Else
       lVer := .T.
    Endif

Return( lVer)

Function IsEqualPath(cPath)
    Local lEqu := .F.
    If AT( Upper(main.Text_1.value), Upper( AllTrim( cPath ) ) )  <> 0
       lEqu := .T.
    Endif
Return( lEqu )

Function FilPathInList( cExt )
    Local aDirectry := {}
    Local aPickList := {}
    Local aFiles    := {}
    Local aFmgFiles := {}
    Local cFmg      := ""

    If main.List_1.ItemCount > 0

       For i := 1 To main.List_1.ItemCount
          DO EVENTS
          Aadd ( aFiles , Alltrim(main.List_1.Item(i)) )
       Next i

       For i := 1 To Len ( aFiles )
          DO EVENTS
          If upper(Right( aFiles [i] , 3 )) = Upper( cExt )
             cFmg := aFiles [i]
          Endif
       Next i

    Endif

    If Len( cFmg ) > 0
       cFmg := SubStr(GetPath(cFmg),1,( Len(GetPath(cFmg))-Len(GetName(cFmg)) -1 ))
    Endif

Return( cFmg )

Function FilPath( cFile )
    Local cFmg := "", cPath:= ''

    If Len( cFile ) > 0
       cPath := SubStr(GetPath(cFile),1,( Len(GetPath(cFile))-Len(GetName(cFile)) -1 ))
    Endif

Return( cPath )

*---------------------------------------------------------------------*
FUNCTION AddSlash(cInFolder)
*---------------------------------------------------------------------*
  LOCAL cOutFolder := ALLTRIM(cInFolder)

  IF !EMPTY(cOutFolder) .AND. RIGHT(cOutfolder, 1) != '\'
     cOutFolder += '\'
  ENDIF

RETURN( cOutFolder )
*---------------------------------------------------------------------*
FUNCTION DelSlash(cInFolder)
*---------------------------------------------------------------------*
  LOCAL cOutFolder := ALLTRIM(cInFolder)

  IF !EMPTY(cOutFolder) .AND. RIGHT(cOutfolder, 1) == '\'
     cOutFolder := LEFT(cOutFolder, LEN(cOutFolder) - 1)
  ENDIF

RETURN( cOutFolder )
*---------------------------------------------------------------------*
FUNCTION AddQuote(cInPath)
*---------------------------------------------------------------------*
  LOCAL cOutPath := ALLTRIM(cInPath)
  LOCAL cQuote   := '"'
  LOCAL cSpace   := SPACE(1)

  IF cSpace $ cOutPath .AND. ;
    !(LEFT(cOutPath, 1) == cQuote) .AND. !(RIGHT(cOutPath, 1) == cQuote)
    cOutPath := cQuote + cOutPath + cQuote
  ENDIF
RETURN( cOutPath )
*---------------------------------------------------------------------*
FUNCTION GetPath(cFileName)
*---------------------------------------------------------------------*
  LOCAL cTrim  := ALLTRIM(cFileName)
  LOCAL nColon := AT(':', cTrim)
  LOCAL cDrive
  LOCAL cPath

  IF EMPTY(nColon)
    cDrive := Upper(DISKNAME())
    IF LEFT(cTrim, 1) == '\'
      cPath := cDrive + ':' + cTrim
    ELSE
      cPath := cDrive + ':\' + CURDIR(cDrive) + '\' + cTrim
    ENDIF
  ELSE
    IF SUBSTR(cTrim, nColon + 1, 1) == '\'
      cPath := cTrim
    ELSE
      cDrive := LEFT(cTrim, nColon - 1)
      cPath  := cDrive + ':\' + CURDIR(cDrive) + '\' + ;
        SUBSTR(cTrim, nColon + 1)
    ENDIF
  ENDIF
RETURN( cPath )
*---------------------------------------------------------------------*
FUNCTION GetSub(cFileName, lGetDefault)
*---------------------------------------------------------------------*
  LOCAL cTrim  := ;
    IF(EMPTY(lGetDefault), ALLTRIM(cFileName), GetPath(cFileName))
  LOCAL nSlash := MAX(RAT('\', cTrim), AT(':', cTrim))
  LOCAL cSub   := LEFT(cTrim, nSlash - 1)

RETURN cSub
*---------------------------------------------------------------------*
FUNCTION GetName(cFileName)
*---------------------------------------------------------------------*
  LOCAL cTrim  := ALLTRIM(cFileName)
  LOCAL nSlash := MAX(RAT('\', cTrim), AT(':', cTrim))
  LOCAL cName  := IF(EMPTY(nSlash), cTrim, SUBSTR(cTrim, nSlash + 1))
RETURN( cName )
*---------------------------------------------------------------------*
FUNCTION GetExt(cFileName)
*---------------------------------------------------------------------*
  LOCAL cTrim  := ALLTRIM(cFileName)
  LOCAL nDot   := RAT('.', cTrim)
  LOCAL nSlash := MAX(RAT('\', cTrim), AT(':', cTrim))
  LOCAL cExt   := IF(nDot <= nSlash .OR. nDot == nSlash + 1, ;
    '', SUBSTR(cTrim, nDot))
RETURN( cExt )
*---------------------------------------------------------------------*
FUNCTION DelExt(cFileName)
*---------------------------------------------------------------------*
  LOCAL cTrim  := ALLTRIM(cFileName)
  LOCAL nDot   := RAT('.', cTrim)
  LOCAL nSlash := MAX(RAT('\', cTrim), AT(':', cTrim))
  LOCAL cBase  := IF(nDot <= nSlash .OR. nDot == nSlash + 1, ;
                  cTrim, LEFT(cTrim, nDot - 1))
RETURN( cBase )
*---------------------------------------------------------------------*
Function cFilePath( cPathMask )
*---------------------------------------------------------------------*
   local n := RAt( "\", cPathMask ), cDisk

Return If( n > 0, Upper( Left( cPathMask, n ) ),;
       ( cDisk := cFileDisc( cPathMask ) ) + If( ! Empty( cDisk ), "\", "" ) )
*---------------------------------------------------------------------*
Function cFileDisc( cPathMask )
*---------------------------------------------------------------------*
Return If( At( ":", cPathMask ) == 2, Upper( Left( cPathMask, 2 ) ), "" )

*---------------------------------------------------------------------*
FUNCTION DateTime(dDate, cTime)
*---------------------------------------------------------------------*
  LOCAL nDateTime := (dDate - CTOD('')) + SECS(cTime)/86400
RETURN nDateTime
*---------------------------------------------------------------------*
Procedure BorraOBJ(cPROJFOLDER1,cOBJFOLDER1)
*---------------------------------------------------------------------*
   If hb_DirExists ( cPROJFOLDER1 + cOBJFOLDER1 )
      ZapDirectory ( cPROJFOLDER1 + '\' + MyOBJName() + Chr(0) )
   Endif
Return

Function DispMem()

    Save to MigMem All
    ReadMem("MigMem.mem")
    cArquivo := "MigMemory.txt"
    Editor   := "Notepad"

    EXECUTE FILE Editor PARAMETERS cArquivo

Return Nil

Procedure READMEM( cFileName )
    local x
    local aMemVars  := {}
    local nLine     := 0

    SET PRINTER TO MigMemory.txt
    SET DEVICE TO PRINTER

    @  1, 1 say PADC( "Display Memory", 79 )

    Do while .T.

       aMemVars := GETVARFROM( cFileName )

       @  3,  5 say "Name"
       @  3, 18 say "Type"
       @  3, 23 say "Value"
       @  3, 60 say "File: MigMemory.txt"

       nLine := 4

       For x := 1 to len( aMemVars )
           ++ nLine
           @ nLine,  5 say aMemVars[ x, 1 ]
           @ nLine, 18 say aMemVars[ x, 2 ]
           @ nLine, 23 say aMemVars[ x, 3 ]
       Next

       Exit

   Enddo

   SET PRINTER TO
   SET DEVICE TO SCREEN

Return


Function GETVARFROM( cMemFile )

local xVarValue    := NIL
local nHandle
local nFilePoint
local cMemBuff
local cVarName
local cID
local nSize
local nLen
local cBuffer
local cData
local nHi
local nLo
local lFlag
local nB1
local nB2
local nB3
local nB4
local nTotal
local nOutput
local nValue
local aMemVar
local aMemVarArray := {}

if valtype( cMemFile ) = "C" .and. file( cMemFile )

   nHandle    := fopen( cMemFile )
   nFilePoint := fseek( nHandle, 0, 2 )
   fseek( nHandle, 0 )

   if nFilePoint > 1

      xVarValue := ""

      do while fseek( nHandle, 0, 1 ) + 1 < nFilePoint .and. !FEOF( nHandle )

         cMemBuff := space( 18 )
         fread( nHandle, @cMemBuff, 18 )
         cVarName := left( cMemBuff, at( chr( 0 ), cMemBuff ) - 1 )
         cID      := substr( cMemBuff, 12, 1 )
         nSize    := bin2w( right( cMemBuff, 2 ) )
         nLen     := if( cID $ "ÃÌ", 14 + nSize, 22 )
         cBuffer  := space( nLen )
         fread( nHandle, @cBuffer, nLen )
         cData := substr( cBuffer, 15 )

         if cID == chr( 195 )            // character

            aMemVar   := { cVarName, "C", cData }
            xVarValue := cData

         elseif cID == chr( 204 )        // logic

            aMemVar   := { cVarName, "L", asc( cData ) == 1 }
            xVarValue := asc( cData ) == 1

         elseif cID == chr( 206 )        // Numeric

            cBuffer   := substr( cBuffer, 15 )
            nHi       := MODULUS( asc( substr( cBuffer, 8, 1 ) ), 128 ) * 16
            nLo       := int( asc( substr( cBuffer, 7, 1 ) ) / 16 )
            nValue    := nHi + nLo - 1023
            lFlag     := int( asc( substr( cBuffer, 8, 1 ) ) / 16 ) >= 8
            nB1       := MODULUS( asc( substr( cBuffer, 7, 1 ) ), 16 ) / 16
            nB2       := bin2w( substr( cBuffer, 5, 2 ) ) / ( 65536 * 16 )
            nB3       := bin2w( substr( cBuffer, 3, 2 ) ) / ( 65536 * 65536 * 16 )
            nB4       := bin2w( substr( cBuffer, 1, 2 ) ) / ( 65536 * 65536 * 65536 * 16 )
            nTotal    := nB1 + nB2 + nB3 + nB4
            nOutput   := if( lFlag, - ( 1 + nTotal ) * 2 ^ nValue, ( 1 + nTotal ) * 2 ^ nValue )
            xVarValue := val( transform( nOutput, "@B" ) )

            aMemVar := { cVarName, "N", xVarValue }

         elseif cID == chr( 196 )        // Date

            cBuffer   := substr( cBuffer, 15 )
            nHi       := MODULUS( asc( substr( cBuffer, 8, 1 ) ), 128 ) * 16
            nLo       := int( asc( substr( cBuffer, 7, 1 ) ) / 16 )
            nValue    := nHi + nLo - 1023
            lFlag     := int( asc( substr( cBuffer, 8, 1 ) ) / 16 ) >= 8
            nB1       := MODULUS( asc( substr( cBuffer, 7, 1 ) ), 16 ) / 16
            nB2       := bin2w( substr( cBuffer, 5, 2 ) ) / ( 65536 * 16 )
            nB3       := bin2w( substr( cBuffer, 3, 2 ) ) / ( 65536 * 65536 * 16 )
            nB4       := bin2w( substr( cBuffer, 1, 2 ) ) / ( 65536 * 65536 * 65536 * 16 )
            nTotal    := nB1 + nB2 + nB3 + nB4
            nOutput   := if( lFlag, - ( 1 + nTotal ) * 2 ^ nValue, ( 1 + nTotal ) * 2 ^ nValue )
            xVarValue := dtoc( ctod( "01/01/0100" ) + nOutput - 1757585 )

            aMemVar := { cVarName, "D", xVarValue }

         endif

         aadd( aMemVarArray, aMemVar )

      enddo

   endif

   fclose( nHandle )

endif

return aMemVarArray


Function FEOF( nHandle )

local nCurrPos
local nFileSize

nCurrPos  := fseek( nHandle, 0, 1 )
nFileSize := fseek( nHandle, 0, 2 )
fseek( nHandle, nCurrPos, 0 )

return nFileSize < nCurrPos


Function MODULUS( nParm1, nParm2 )

local x
local nRetVal := 0

if valtype( nParm1 ) = "N" .and. valtype( nParm2 ) = "N"
   if nParm2 = 0
      nRetVal := nParm1
   else
      x       := nParm1 % nParm2
      nRetVal := if( x * nParm2 < 0, x + nParm2, x )
   endif
endif

return nRetVal

#pragma BEGINDUMP

#define _WIN32_IE 0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT 0x0400

#define WS_EX_LAYERED 0x80000
#define LWA_ALPHA 0x02

#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"
#include "commctrl.h"

HB_FUNC ( ZAPDIRECTORY )
{
	SHFILEOPSTRUCT sh;

	sh.hwnd   = GetActiveWindow();
	sh.wFunc  = FO_DELETE;
	sh.pFrom  = hb_parc(1);
	sh.pTo    = NULL;
	sh.fFlags = FOF_NOCONFIRMATION | FOF_SILENT;
	sh.hNameMappings = 0;
	sh.lpszProgressTitle = NULL;

	SHFileOperation (&sh);
}

HB_FUNC( CURSORARROW2 )
{
   hb_retnl( (LONG) SetCursor(LoadCursor(NULL, IDC_ARROW)) );
}

HB_FUNC( CURSORWAIT2 )
{
   hb_retnl( (LONG) SetCursor(LoadCursor(NULL, IDC_WAIT)) );
}

HB_FUNC( GETEXEFILENAME )
{
   unsigned char  pBuf[250];

   GetModuleFileName( GetModuleHandle(NULL), (LPTSTR) pBuf, 249 );

   hb_retc( ( char * ) pBuf );
}

HB_FUNC( SETTRANSPARENT )
{

	typedef BOOL (__stdcall *PFN_SETLAYEREDWINDOWATTRIBUTES) (HWND, COLORREF, BYTE, DWORD);

	PFN_SETLAYEREDWINDOWATTRIBUTES pfnSetLayeredWindowAttributes = NULL;

	HINSTANCE hLib = LoadLibrary("user32.dll");

	if (hLib != NULL)
	{
		pfnSetLayeredWindowAttributes = (PFN_SETLAYEREDWINDOWATTRIBUTES) GetProcAddress(hLib, "SetLayeredWindowAttributes");
	}

	if (pfnSetLayeredWindowAttributes)
	{
		SetWindowLong((HWND) hb_parnl (1), GWL_EXSTYLE, GetWindowLong((HWND) hb_parnl (1), GWL_EXSTYLE) | WS_EX_LAYERED);
		pfnSetLayeredWindowAttributes((HWND) hb_parnl (1), 0, hb_parni (2), LWA_ALPHA);
	}

	if (!hLib)
	{
		FreeLibrary(hLib);
	}

}

#pragma ENDDUMP
