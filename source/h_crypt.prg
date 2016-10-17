/*
 * $Id: h_crypt.prg,v 1.8 2016-10-17 01:55:34 fyurisich Exp $
 */
/*
 * ooHG source code:
 * XOR based crypto functions
 *
 * Based upon
 * Crypto Library for MiniGUI by
 * Grigory Filatov <gfilatov@inbox.ru>
 *
 * Copyright 2005-2016 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2016, http://www.harbour-project.org/
 */
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 */


#define MSGALERT( c ) MsgEXCLAMATION( c, "Attention" )
#define MSGSTOP( c ) MsgStop( c, "Stop!" )

FUNCTION _ENCRYPT( cStr, cPass )
LOCAL cXorStr := CHARXOR( cStr, "<ORIGINAL>" )
   IF ! EMPTY( cPass )
      cXorStr := CHARXOR( cXorStr, cPass )
   ENDIF
RETURN cXorStr

FUNCTION _DECRYPT(cStr, cPass)
RETURN CHARXOR( CHARXOR( cStr, cPass ), "<ORIGINAL>" )

FUNCTION FI_CODE(cInFile, cPass, cOutFile, lDelete)
LOCAL nHandle, cBuffer, cStr, nRead := 1
LOCAL nOutHandle

   IF EMPTY(cInFile) .OR. .NOT. FILE(cInFile)
      MSGSTOP("No such file")
      RETURN NIL
   ENDIF

   IF ALLTRIM(UPPER(cInFile)) == ALLTRIM(UPPER(cOutFile))
      MSGALERT("New and old filenames must not be the same")
      RETURN NIL
   ENDIF

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   IF lDelete == NIL
      lDelete := .F.
   ENDIF

   IF LEN(cPass) > 10
      cPass := SUBSTR(cPass, 1, 10)
   ELSE
      cPass := PADR(cPass, 10)
   ENDIF

   nHandle := FOPEN(cInFile, 2)

   IF FERROR() <> 0
      MSGSTOP("File I/O error, cannot proceed")
   ENDIF

   cBuffer := SPACE(30)
   FREAD(nHandle, @cBuffer, 30)

   IF cBuffer == "ENCRYPTED FILE (C) ODESSA 2002"
      MSGSTOP("File already encrypted")
      FCLOSE(nHandle)
      RETURN NIL
   ENDIF

   FSEEK(nHandle, 0)
   nOutHandle := FCREATE(cOutFile, 0)

   IF FERROR() <> 0
      MSGSTOP("File I/O error, cannot proceed")
      FCLOSE(nHandle)
      RETURN NIL
   ENDIF

   FWRITE(nOutHandle, "ENCRYPTED FILE (C) ODESSA 2002")
   cStr := _ENCRYPT(cPass)
   FWRITE(nOutHandle, cStr)
   cBuffer := SPACE(512)

   DO WHILE nRead <> 0
      nRead := FREAD(nHandle, @cBuffer, 512)
      IF nRead <> 512
         cBuffer := SUBSTR(cBuffer, 1, nRead)
      ENDIF
      cStr := _ENCRYPT(cBuffer, cPass)
      FWRITE(nOutHandle, cStr)
   ENDDO

   FCLOSE(nHandle)
   FCLOSE(nOutHandle)

   IF lDelete
      FERASE(cInFile)
   ENDIF

RETURN NIL

FUNCTION FI_DECODE(cInFile, cPass, cOutFile, lDelete)
LOCAL nHandle, cBuffer, cStr, nRead := 1
LOCAL nOutHandle

   IF EMPTY(cInFile) .OR. .NOT. FILE(cInFile)
      MSGSTOP("No such file")
      RETURN NIL
   ENDIF

   IF ALLTRIM(UPPER(cInFile)) == ALLTRIM(UPPER(cOutFile))
      MSGALERT("New and old filenames must not be the same")
      RETURN NIL
   ENDIF

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   IF lDelete == NIL
      lDelete := .F.
   ENDIF

   IF LEN(cPass) > 10
      cPass := SUBSTR(cPass, 1, 10)
   ELSE
      cPass := PADR(cPass, 10)
   ENDIF

   nHandle := FOPEN(cInFile, 2)

   IF FERROR() <> 0
      MSGSTOP("File I/O error, cannot proceed")
   ENDIF

   cBuffer := SPACE(30)
   FREAD(nHandle, @cBuffer, 30)

   IF cBuffer <> "ENCRYPTED FILE (C) ODESSA 2002"
      MSGSTOP("File is not encrypted")
      FCLOSE(nHandle)
      RETURN NIL
   ENDIF

   cBuffer := SPACE(10)
   FREAD(nHandle, @cBuffer, 10)

   IF cBuffer <> _ENCRYPT(cPass)
      MSGALERT("You have entered the wrong password")
      FCLOSE(nHandle)
      RETURN NIL
   ENDIF

   nOutHandle := FCREATE(cOutFile, 0)

   IF FERROR() <> 0
      MSGSTOP("File I/O error, cannot proceed")
      FCLOSE(nHandle)
      RETURN NIL
   ENDIF

   cBuffer := SPACE(512)

   DO WHILE nRead <> 0
      nRead := FREAD(nHandle, @cBuffer, 512)
      IF nRead <> 512
         cBuffer := SUBSTR(cBuffer, 1, nRead)
      ENDIF
      cStr := _DECRYPT(cBuffer, cPass)
      FWRITE(nOutHandle, cStr)
   ENDDO

   FCLOSE(nHandle)
   FCLOSE(nOutHandle)

   IF lDelete
      FERASE(cInFile)
   ENDIF

RETURN NIL

FUNCTION DB_ENCRYPT(cFile, cPass)
LOCAL nHandle, cBuffer := SPACE(4), cFlag := SPACE(3)

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   IF cFile == NIL
      cFile := "TEMP.DBF"
   ENDIF

   IF LEN(cPass) > 10
      cPass := SUBSTR(cPass, 1, 10)
   ELSE
      cPass := PADR(cPass, 10)
   ENDIF

   IF AT(".", cFileName(cFile)) = 0
      cFile := cFile + ".DBF"
   ENDIF

   IF FILE(cFile)
      nHandle := FOPEN(cFile, 2)

      IF FERROR() <> 0
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL
      ENDIF

      FSEEK(nHandle, 28)

      IF FERROR() <> 0
         MSGSTOP("File I/O error, cannot encrypt file")
         FCLOSE(nHandle)
         RETURN NIL
      ENDIF

      IF FREAD(nHandle, @cFlag, 3) <> 3
         MSGSTOP("File I/O error, cannot encrypt file")
         FCLOSE(nHandle)
         RETURN NIL
      ENDIF

      IF cFlag == "ENC"
         MSGSTOP("This database already encrypted!")
         FCLOSE(nHandle)
         RETURN NIL
      ENDIF

      FSEEK(nHandle, 8)

      IF FERROR() <> 0
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL
      ENDIF

      IF FREAD(nHandle, @cBuffer, 4) <> 4
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL
      ENDIF

      cBuffer := _ENCRYPT(cBuffer, cPass)
      FSEEK(nHandle, 8)

      IF FERROR() <> 0
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL
      ENDIF

      IF FWRITE(nHandle, cBuffer) <> 4
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL
      ENDIF

      FSEEK(nHandle, 12)

      IF FERROR() <> 0
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL
      ENDIF

      cBuffer := _ENCRYPT(cPass)

      IF FWRITE(nHandle, cBuffer) <> LEN(cPass)
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL
      ENDIF

      FSEEK(nHandle, 28)

      IF FWRITE(nHandle, "ENC") <> 3
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot encrypt file")
         RETURN NIL
      ENDIF

      FCLOSE(nHandle)

   ELSE
      MSGSTOP("No such file")
   ENDIF


RETURN NIL

FUNCTION DB_UNENCRYPT(cFile, cPass)
LOCAL nHandle, cBuffer := SPACE(4), cSavePass := SPACE(10), cFlag := SPACE(3)

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   IF cFile == NIL
      cFile := "TEMP.DBF"
   ENDIF

   IF LEN(cPass) > 10
      cPass := SUBSTR(cPass, 1, 10)
   ELSE
      cPass := PADR(cPass, 10)
   ENDIF

   IF AT(".", cFile) = 0
      cFile := cFile + ".DBF"
   ENDIF

   IF FILE(cFile)
      nHandle := FOPEN(cFile, 2)

      IF FERROR() <> 0
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL
      ENDIF

      FSEEK(nHandle, 28)

      IF FERROR() <> 0
         MSGSTOP("File I/O error, cannot unencrypt file")
         FCLOSE(nHandle)
         RETURN NIL
      ENDIF

      IF FREAD(nHandle, @cFlag, 3) <> 3
         MSGSTOP("File I/O error, cannot unencrypt file")
         FCLOSE(nHandle)
         RETURN NIL
      ENDIF

      IF cFlag <> "ENC"
         MSGSTOP("This database is not encrypted!")
         FCLOSE(nHandle)
         RETURN NIL
      ENDIF

      FSEEK(nHandle, 12)

      IF FERROR() <> 0
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL
      ENDIF

      cBuffer := _ENCRYPT(cPass)

      IF FREAD(nHandle, @cSavePass, 10) <> LEN(cPass)
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL
      ENDIF

      IF cBuffer <> cSavePass
         FCLOSE(nHandle)
         MSGALERT("You have entered the wrong password")
         RETURN NIL
      ENDIF

      cBuffer := SPACE(4)
      FSEEK(nHandle, 8)

      IF FERROR() <> 0
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL
      ENDIF

      IF FREAD(nHandle, @cBuffer, 4) <> 4
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL
      ENDIF

      cBuffer := _DECRYPT(cBuffer, cPass)
      FSEEK(nHandle, 8)

      IF FERROR() <> 0
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL
      ENDIF

      IF FWRITE(nHandle, cBuffer) <> 4
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL
      ENDIF

      FSEEK(nHandle, 12)

      IF FWRITE(nHandle, REPLICATE(CHR(0), 20)) <> 20
         FCLOSE(nHandle)
         MSGSTOP("File I/O error, cannot unencrypt file")
         RETURN NIL
      ENDIF

      FCLOSE(nHandle)

   ELSE
      MSGSTOP("No such file")
   ENDIF


RETURN NIL

Static Function cFileName( cMask )
Local cName := AllTrim( cMask )
Local n     := At( ".", cName )
Return AllTrim( If( n > 0, Left( cName, n - 1 ), cName ) )

FUNCTION DB_CODE(cData, cKey, aFields, cPass, cFor, cWhile)
local cTmpFile := "__temp__.dbf", nRecno := recno(), cVal, cBuf
Local aString[Len(aFields)] , nFields , cSeek , i , cAlias , cTmpAlias // RL

   cData:=If(cData=nil,Alias()+".DBF",cData)
   cData:=If(at(".",cData)=0,cData+".DBF",cData)
   cWhile:=If(cWhile=nil, ".t.",cWhile)
   cFor:=If(cFor=nil,".t.",cFor)
   cSeek:=cKey

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   Copy Stru to &(cTmpFile)
   cAlias:=Alias()
   nFields:=FCount()

   Use (cTmpFile) New Exclusive
   cTmpAlias:=Alias()

Select &cAlias
Do while .not. eof() .and. &(cWhile)
   If !&(cFor)                         && Select records that meet for condition
      Skip
      Loop
   Endif

   Select &cTmpAlias
   dbAppend()                          && Create record at target file

   For i=1 to nFields
       FieldPut(i, &cAlias->(FieldGet(i)))
   Next

   Select &cAlias
   afill(aString, '')

   cBuf:=&cSeek
   cVal:=cBuf
   Do while cBuf=cVal .and. !Eof()    && Evaluate records with same key
      If !&(cFor)                     && Evaluate For condition within
         Skip
         Loop
      Endif

      For i=1 to Len(aString)         && Crypt values
          aString[i]:=_ENCRYPT(FieldGet(FieldPos(aFields[i])), cPass)
      Next

      skip                            && Evaluate condition in next record
      cVal:=&cSeek
   Enddo

   Select &cTmpAlias
   For i=1 to Len(aString)            && Place Crypts in target file
       FieldPut(FieldPos(aFields[i]), aString[i])
   Next

   Select &cAlias
Enddo

Select &cTmpAlias
go top
Do while .not. eof()
      cVal:=&cSeek
      Select &cAlias
      seek cVal
	rlock()
      For i=1 to nFields
         FieldPut(i, &cTmpAlias->(FieldGet(i)))
      Next
	dbunlock()
      Select &cTmpAlias
      skip
Enddo
use                                   && Close target file
ferase(cTmpFile)
Select &cAlias                        && Select prior file
go nRecno

RETURN NIL

EXTERN CHARXOR

#pragma BEGINDUMP
#include "hbapi.h"
#include "hbapiitm.h"
#include <windows.h>

HB_FUNC( CHARXOR )
{
   char *cData, *cMask, *cRet, *cPos;
   ULONG ulData, ulMask, ulRemain, ulMaskPos;

   ulData = hb_parclen( 1 );
   ulMask = hb_parclen( 2 );
   cData = ( char * ) hb_parc( 1 );
   cMask = ( char * ) hb_parc( 2 );
   if( ulData == 0 || ulMask == 0 )
   {
      hb_retclen( cData, ulData );
   }
   else
   {
      cRet = (char *) hb_xgrab( ulData );

      cPos = cRet;
      ulRemain = ulData;
      ulMaskPos = 0;
      while( ulRemain )
      {
         *cPos++ = *cData++ ^ cMask[ ulMaskPos++ ];
         if( ulMaskPos == ulMask )
         {
            ulMaskPos = 0;
         }
         ulRemain--;
      }

      hb_retclen( cRet, ulData );
      hb_xfree( cRet );
   }
}
#pragma ENDDUMP
