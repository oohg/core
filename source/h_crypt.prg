/*
 * $Id: h_crypt.prg $
 */
/*
 * ooHG source code:
 * XOR based crypto functions
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Based upon:
 * Crypto Library for MiniGUI by
 * Grigory Filatov <gfilatov@inbox.ru>
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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


#include "fileio.ch"
#include "oohg.ch"
#include "i_init.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _ENCRYPT( cStr, cPass )

   LOCAL cXorStr := CHARXOR( cStr, "<ORIGINAL>" )

   IF ! Empty( cPass )
      cXorStr := CHARXOR( cXorStr, cPass )
   ENDIF

   RETURN cXorStr

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _DECRYPT( cStr, cPass )

   RETURN CHARXOR( CHARXOR( cStr, cPass ), "<ORIGINAL>" )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION FI_CODE( cInFile, cPass, cOutFile, lDelete )

   LOCAL nHandle, cBuffer, cStr, nRead := 1, nOutHandle

   IF Empty( cInFile ) .OR. ! File( cInFile )
      MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cInFile ) + ".", _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF AllTrim( Upper( cInFile ) ) == AllTrim( Upper( cOutFile ) )
      MsgStop( _OOHG_Messages( MT_MISCELL, 28 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   IF lDelete == NIL
      lDelete := .F.
   ENDIF

   IF Len( cPass ) > 10
      cPass := SubStr( cPass, 1, 10 )
   ELSE
      cPass := PadR( cPass, 10 )
   ENDIF

   nHandle := FOpen( cInFile, FO_READWRITE )

   IF FError() <> 0
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   cBuffer := Space( 30 )
   FRead( nHandle, @cBuffer, 30 )

   IF cBuffer == "ENCRYPTED FILE (C) ODESSA 2002"
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF

   FSeek( nHandle, 0 )
   nOutHandle := FCreate( cOutFile, FC_NORMAL )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   FWrite( nOutHandle, "ENCRYPTED FILE (C) ODESSA 2002" )
   cStr := _ENCRYPT( cPass )
   FWrite( nOutHandle, cStr )
   cBuffer := Space( 512 )

   DO WHILE nRead <> 0
      nRead := FRead( nHandle, @cBuffer, 512 )
      IF nRead <> 512
         cBuffer := SubStr( cBuffer, 1, nRead )
      ENDIF
      cStr := _ENCRYPT(cBuffer, cPass )
      FWrite( nOutHandle, cStr )
   ENDDO

   FClose( nHandle )
   FClose( nOutHandle )

   IF lDelete
      FErase( cInFile )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION FI_DECODE( cInFile, cPass, cOutFile, lDelete )

   LOCAL nHandle, cBuffer, cStr, nRead := 1, nOutHandle

   IF Empty( cInFile ) .OR. ! File( cInFile )
      MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cInFile ) + ".", _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF AllTrim( Upper( cInFile ) ) == AllTrim( Upper( cOutFile ) )
      MsgStop( _OOHG_Messages( MT_MISCELL, 28 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   IF lDelete == NIL
      lDelete := .F.
   ENDIF

   IF Len( cPass ) > 10
      cPass := SubStr( cPass, 1, 10 )
   ELSE
      cPass := PadR( cPass, 10 )
   ENDIF

   nHandle := FOpen( cInFile, FO_READWRITE )

   IF FError() <> 0
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   cBuffer := Space( 30 )
   FRead( nHandle, @cBuffer, 30 )

   IF cBuffer <> "ENCRYPTED FILE (C) ODESSA 2002"
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 26 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF

   cBuffer := Space( 10 )
   FRead( nHandle, @cBuffer, 10 )

   IF cBuffer <> _ENCRYPT( cPass )
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 27 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   nOutHandle := FCreate( cOutFile, FC_NORMAL )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   cBuffer := Space( 512 )

   DO WHILE nRead <> 0
      nRead := FRead( nHandle, @cBuffer, 512 )
      IF nRead <> 512
         cBuffer := SubStr( cBuffer, 1, nRead )
      ENDIF
      cStr := _DECRYPT( cBuffer, cPass )
      FWrite( nOutHandle, cStr )
   ENDDO

   FClose( nHandle )
   FClose( nOutHandle )

   IF lDelete
      FErase( cInFile )
   ENDIF

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION DB_ENCRYPT( cFile, cPass )

   LOCAL nHandle, cBuffer := Space( 4 ), cFlag := Space( 3 )

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   IF cFile == NIL
      cFile := "TEMP.DBF"
   ENDIF

   IF Len( cPass ) > 10
      cPass := SubStr( cPass, 1, 10 )
   ELSE
      cPass := PadR( cPass, 10 )
   ENDIF

   IF At( ".", cFile ) == 0
      cFile := cFile + ".DBF"
   ENDIF

   IF ! FILE( cFile )
      MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cFile ) + ".", _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   nHandle := FOpen( cFile, FO_READWRITE )

   IF FError() <> 0
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   FSeek( nHandle, 28 )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF FRead( nHandle, @cFlag, 3 ) <> 3
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF cFlag == "ENC"
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 25 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF

   FSeek( nHandle, 8 )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF FRead( nHandle, @cBuffer, 4) <> 4
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   cBuffer := _ENCRYPT( cBuffer, cPass )
   FSeek( nHandle, 8 )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF FWrite( nHandle, cBuffer ) <> 4
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   FSeek( nHandle, 12 )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   cBuffer := _ENCRYPT( cPass )

   IF FWrite( nHandle, cBuffer ) <> Len( cPass )
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   FSeek( nHandle, 28 )

   IF FWrite( nHandle, "ENC" ) <> 3
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   FClose( nHandle )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION DB_UNENCRYPT( cFile, cPass )

   LOCAL nHandle, cBuffer := Space( 4 ), cSavePass := Space( 10 ), cFlag := Space( 3 )

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   IF cFile == NIL
      cFile := "TEMP.DBF"
   ENDIF

   IF Len( cPass ) > 10
      cPass := SubStr( cPass, 1, 10 )
   ELSE
      cPass := PadR( cPass, 10 )
   ENDIF

   IF At( ".", cFile ) == 0
      cFile := cFile + ".DBF"
   ENDIF

   IF ! FILE( cFile )
      MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cFile ) + ".", _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   nHandle := FOpen( cFile, FO_READWRITE )

   IF FError() <> 0
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   FSeek( nHandle, 28 )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF FRead( nHandle, @cFlag, 3 ) <> 3
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF cFlag <> "ENC"
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 26 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN NIL
   ENDIF

   FSeek( nHandle, 12 )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   cBuffer := _ENCRYPT( cPass )

   IF FRead( nHandle, @cSavePass, 10 ) <> Len( cPass )
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF cBuffer <> cSavePass
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 27 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   cBuffer := Space( 4 )
   FSeek( nHandle, 8 )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF FRead( nHandle, @cBuffer, 4 ) <> 4
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   cBuffer := _DECRYPT( cBuffer, cPass )
   FSeek( nHandle, 8 )

   IF FError() <> 0
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   IF FWrite( nHandle, cBuffer ) <> 4
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   FSeek( nHandle, 12 )

   IF FWrite( nHandle, Replicate( Chr( 0 ), 20 ) ) <> 20
      FClose( nHandle )
      MsgStop( _OOHG_Messages( MT_MISCELL, 24 ), _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN .F.
   ENDIF

   FClose( nHandle )

   RETURN .T.

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION DB_CODE( cData, cKey, aFields, cPass, cFor, cWhile )

   LOCAL cTmpFile, nRecno, cVal, cBuf, cAlias, cTmpAlias
   LOCAL aString[ Len( aFields ) ], nFields, cSeek, i

   cAlias  := Alias()
   nFields := FCount()
   nRecno  := RecNo()

   cData  := iif( cData == NIL, cAlias + ".DBF", cData )
   cData  := iif( At( ".", cData ) == 0, cData + ".DBF", cData )
   cWhile := iif( cWhile == NIL, ".T.", cWhile )
   cFor   := iif( cFor == NIL, ".T.", cFor )
   cSeek  := cKey

   IF cPass == NIL
      cPass := "<PRIMARY>"
   ENDIF

   App.MutexLock

   cTmpFile := "__temp__" + TToS( DateTime() ) + ".dbf"
   COPY STRUCTURE TO &(cTmpFile)

   USE ( cTmpFile ) NEW EXCLUSIVE
   cTmpAlias := Alias()

   App.MutexUnlock

   SELECT &cAlias
   DO WHILE ! Eof() .AND. &( cWhile )
      IF ! &( cFor )                         // Select records that meet for condition
         SKIP
         LOOP
      ENDIF

      SELECT &cTmpAlias
      dbAppend()                             // Create record at target file

      FOR i := 1 TO nFields
         FieldPut( i, &cAlias->( FieldGet( i ) ) )
      NEXT

      SELECT &cAlias
      AFill( aString, '' )

      cBuf := &cSeek
      cVal := cBuf
      DO WHILE cBuf == cVal .AND. ! Eof()    // Evaluate records with same key
         IF ! &( cFor )                      // Evaluate For condition within
            SKIP
            LOOP
         ENDIF

         FOR i := 1 TO Len( aString )        // Crypt values
            aString[ i ] := _ENCRYPT( FieldGet( FieldPos( aFields[ i ] ) ), cPass )
         NEXT

         SKIP                                // Evaluate condition in next record
         cVal := &cSeek
      ENDDO

      SELECT &cTmpAlias
      FOR i := 1 TO Len( aString )           // Place Crypts in target file
         FieldPut( FieldPos( aFields[ i ] ), aString[ i ] )
      NEXT

      SELECT &cAlias
   ENDDO

   SELECT &cTmpAlias
   GO TOP
   DO WHILE ! Eof()
      cVal := &cSeek
      SELECT &cAlias
      SEEK cVal
      RLock()
      FOR i := 1 TO nFields
         FieldPut( i, &cTmpAlias->( FieldGet( i ) ) )
      NEXT
      dbUnlock()
      SELECT &cTmpAlias
      SKIP
   ENDDO
   USE                                       // Close target file
   FErase( cTmpFile )

   Select &cAlias                            // Select prior file
   GO nRecno

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CHARXOR )
{
   const char *cData, *cMask;
   char *cRet, *cPos;
   ULONG ulData, ulMask, ulRemain, ulMaskPos;

   ulData = hb_parclen( 1 );
   ulMask = hb_parclen( 2 );
   cData = ( const char * ) hb_parc( 1 );
   cMask = ( const char * ) hb_parc( 2 );
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
         *cPos ++ = *cData ++ ^ cMask[ ulMaskPos ++ ];
         if( ulMaskPos == ulMask )
         {
            ulMaskPos = 0;
         }
         ulRemain --;
      }

      hb_retclen( cRet, ulData );
      hb_xfree( cRet );
   }
}

#pragma ENDDUMP
