/*
 * $Id: h_ini.prg $
 */
/*
 * OOHG source code:
 * INI files functions
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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


#include "common.ch"
#include "fileio.ch"
#include "oohg.ch"
#include "i_init.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION BeginIni( name, cIniFile )

   LOCAL hFile

   HB_SYMBOL_UNUSED( name )

   IF AT( "\", cIniFile ) == 0
      cIniFile := ".\" + cIniFile
   ENDIF

   IF ! File( cIniFile )
      hFile := FCreate( cIniFile )
   ELSE
      hFile := FOpen( cIniFile, FO_READ + FO_SHARED )
   ENDIF

   IF FError() != 0
      MsgStop( _OOHG_Messages( MT_MISCELL, 21 ) + DQM( cIniFile ) + ". [" + LTrim( Str( FError() ) ) + "]", _OOHG_Messages( MT_MISCELL, 9 ) )
      RETURN ""
   ELSE
      _OOHG_ActiveIniFile := cIniFile
   ENDIF

   FClose( hFile )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetBeginComment

   LOCAL aLines, nLen, i, lTest := .T., cComment := ""

   IF ! Empty( _OOHG_ActiveIniFile )
      aLines := hb_ATokens( StrTran( MemoRead( _OOHG_ActiveIniFile ), CRLF, Chr( 10 ) ), Chr( 10 ) )
      nLen := Len( aLines )
      IF nLen > 0
         FOR i := 1 TO nLen
            aLines[ i ] := AllTrim( aLines[ i ] )
            IF lTest
               IF Left( aLines[ i ], 1 ) $ "#;"
                  cComment := aLines[ i ]
                  lTest := .F.
               ELSEIF ! Empty( aLines[i] )
                  lTest := .F.
               ENDIF
            ENDIF
         NEXT i
      ENDIF
   ENDIF

   RETURN cComment

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetEndComment

   LOCAL aLines, nLen, i, lTest := .T., cComment := ""

   IF ! Empty( _OOHG_ActiveIniFile )
      aLines := hb_ATokens( StrTran( MemoRead( _OOHG_ActiveIniFile ), CRLF, Chr( 10 ) ), Chr( 10 ) )
      nLen := Len( aLines )
      IF nLen > 0
         FOR i := nLen TO 1 STEP -1
            aLines[ i ] := AllTrim( aLines[ i ] )
            IF lTest
               IF Left( aLines[ i ], 1 ) $ "#;"
                  cComment := aLines[ i ]
                  lTest := .F.
               ELSEIF ! Empty( aLines[i] )
                  lTest := .F.
               ENDIF
            ENDIF
         NEXT i
      ENDIF
   ENDIF

   RETURN cComment

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION SetBeginComment( cComment )

   LOCAL aLines, nLen, i, lTest := .T., cMemo := ""

   ASSIGN cComment VALUE cComment TYPE "CM" DEFAULT ""

   IF ! Empty( _OOHG_ActiveIniFile )
      aLines := hb_ATokens( StrTran( MemoRead( _OOHG_ActiveIniFile ), CRLF, Chr( 10 ) ), Chr( 10 ) )
      nLen := Len( aLines )
      IF nLen > 0 .AND. Len( ATail( aLines ) ) == 0
         ASize( aLines, nLen - 1 )
         nLen--
      ENDIF
      IF nLen > 0
         FOR i := 1 TO nLen
            aLines[ i ] := AllTrim( aLines[ i ] )
            IF lTest
               IF Left( aLines[ i ], 1 ) $ "#;"
                  IF Empty( cComment )
                     aLines[ i ] := ""
                  ELSE
                     IF ! Left( cComment := AllTrim( cComment ), 1 ) $ "#;"
                        cComment := "#" + cComment
                     ENDIF
                     aLines[ i ] := cComment + CRLF
                  ENDIF
                  lTest := .F.
               ELSEIF Empty( aLines[ i ] )
                  aLines[ i ] += CRLF
               ELSEIF Empty( cComment )
                  aLines[ i ] += CRLF
                  lTest := .F.
               ELSE
                  AAdd( aLines, NIL )
                  nLen++
                  AIns( aLines, i )
                  IF ! Left( cComment := AllTrim( cComment ), 1 ) $ "#;"
                     cComment := "#" + cComment
                  ENDIF
                  aLines[ i ] := cComment + CRLF
                  lTest := .F.
               ENDIF
            ELSE
               aLines[ i ] += CRLF
            ENDIF
            cMemo := cMemo + aLines[ i ]
         NEXT i
         hb_MemoWrit( _OOHG_ActiveIniFile, cMemo )
      ENDIF
   ENDIF

   RETURN cComment

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION SetEndComment( cComment )

   LOCAL aLines, nLen, i, lTest := .T., cMemo := ""

   ASSIGN cComment VALUE cComment TYPE "CM" DEFAULT ""
   cComment := AllTrim( cComment )

   IF ! Empty( _OOHG_ActiveIniFile )
      aLines := hb_ATokens( StrTran( MemoRead( _OOHG_ActiveIniFile ), CRLF, Chr( 10 ) ), Chr( 10 ) )
      nLen := Len( aLines )
      IF nLen > 0 .AND. Len( ATail( aLines ) ) == 0
         ASize( aLines, nLen - 1 )
         nLen--
      ENDIF
      IF nLen > 0
         FOR i := nLen TO 1 STEP -1
            aLines[ i ] := AllTrim( aLines[ i ] )
            IF lTest
               IF Empty( aLines[i] )
                  // Remove empty trailing lines
               ELSEIF Left( aLines[ i ], 1 ) $ "#;"
                  IF Empty( cComment )
                     // Remove previous comment
                  ELSE
                     // Replace previous comment
                     IF ! Left( cComment, 1 ) $ "#;"
                        cComment := "#" + cComment
                     ENDIF
                     cMemo := cComment + CRLF
                  ENDIF
                  lTest := .F.
               ELSEIF Empty( cComment )
                  // Do not add comment
                  lTest := .F.
               ELSE
                  // Add comment as the last line
                  IF ! Left( cComment, 1 ) $ "#;"
                     cComment := "#" + cComment
                  ENDIF
                  cMemo := CRLF + cComment + CRLF
                  // Add line
                  cMemo := aLines[ i ] + CRLF + cMemo
                  lTest := .F.
               ENDIF
            ELSE
               // Add line
               cMemo := aLines[ i ] + CRLF + cMemo
            ENDIF
         NEXT i
         IF Left( cMemo, Len( CRLF ) ) == CRLF
            cMemo := SubStr( cMemo, Len( CRLF ) + 1 )
         ENDIF
         hb_MemoWrit( _OOHG_ActiveIniFile, cMemo )
      ENDIF
   ENDIF

   RETURN cComment

// Code GetIni and SetIni based on source by Grigory Filatov

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _GetIni( cSection, cEntry, uDefault, uVar )

   LOCAL cFile, cVar := ''

   IF ! Empty( _OOHG_ActiveIniFile )
      IF ValType( uDefault ) == 'U'
         uDefault := cVar
      ENDIF
      cFile := _OOHG_ActiveIniFile
      cVar := GetPrivateProfileString( cSection, cEntry, xChar( uDefault ), cFile )
   ELSE
      IF uDefault != NIL
         cVar := xChar( uDefault )
      ENDIF
   ENDIF
   uVar := xValue( cVar, ValType( uVar ) )

   RETURN uVar

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _SetIni( cSection, cEntry, cValue )

   LOCAL ret := .F., cFile

   IF ! Empty( _OOHG_ActiveIniFile )
      cFile := _OOHG_ActiveIniFile
      ret := WritePrivateProfileString( cSection, cEntry, xChar( cValue ), cFile )
   ENDIF

   RETURN ret

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _DelIniEntry( cSection, cEntry )

   LOCAL ret := .F., cFile

   IF ! Empty( _OOHG_ActiveIniFile )
      cFile := _OOHG_ActiveIniFile
      ret := DelIniEntry( cSection, cEntry, cFile )
   ENDIF

   RETURN ret

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _DelIniSection( cSection )

   LOCAL ret := .F., cFile

   IF ! Empty( _OOHG_ActiveIniFile )
      cFile := _OOHG_ActiveIniFile
      ret := DelIniSection( cSection, cFile )
   ENDIF

   RETURN ret

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _EndIni()

   _OOHG_ActiveIniFile := ''

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION xChar( xValue )

   LOCAL cType := ValType( xValue )
   LOCAL cValue := "", nDecimals := Set( _SET_DECIMALS )

   DO CASE
   CASE cType $  "CM";  cValue := xValue
   CASE cType == "N" ;  cValue := LTrim( Str( xValue, 20, nDecimals ) )
   CASE cType == "D" ;  cValue := DToS( xValue )
   CASE cType == "L" ;  cValue := IIf( xValue, "T", "F" )
   CASE cType == "T" ;  cValue := TToS( xValue )
   CASE cType == "A" ;  cValue := AToC( xValue )
   CASE cType $  "UE";  cValue := "NIL"
   CASE cType == "B" ;  cValue := "{|| ... }"
   CASE cType == "O" ;  cValue := "{" + xValue:className + "}"
   ENDCASE

   RETURN cValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION xValue( cValue, cType )

   LOCAL xValue

   DO CASE
   CASE cType $  "CM";  xValue := cValue
   CASE cType == "D" ;  xValue := SToD( cValue )
   CASE cType == "N" ;  xValue := Val( cValue )
   CASE cType == "L" ;  xValue := ( cValue == 'T' )
   CASE cType == "T" ;  xValue := SToT( cValue )
   CASE cType == "A" ;  xValue := CToA( cValue )
   OTHERWISE         ;  xValue := NIL                     // nil, block, object
   ENDCASE

   RETURN xValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION AToC( aArray )

   LOCAL i, nLen := Len( aArray )
   LOCAL cType, cElement, cArray := ""

   FOR i := 1 TO nLen
      cElement := xChar( aArray[ i ] )
      IF ( cType := ValType( aArray[ i ] ) ) == "A"
         cArray += cElement
      ELSE
         cArray += Left( cType, 1) + Str( Len( cElement ),4 ) + cElement
      ENDIF
   ENDFOR

   RETURN "A" + str( Len( cArray ),4 ) + cArray

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION CToA( cArray )

   LOCAL cType, nLen, aArray := {}

   cArray := SubStr( cArray, 6 )    // strip off array and length
   WHILE Len( cArray ) > 0
      nLen := Val( SubStr( cArray, 2, 4 ) )
      IF ( cType := Left( cArray, 1 ) ) == "A"
         AAdd( aArray, CToA( SubStr( cArray, 1, nLen + 5 ) ) )
      ELSE
         AAdd( aArray, xValue( SubStr( cArray, 6, nLen ), cType ) )
      ENDIF
      cArray := SubStr( cArray, 6 + nLen )
   END

   RETURN aArray


/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"
#include "hbapiitm.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETPRIVATEPROFILESTRING )
{
   TCHAR bBuffer[ 1024 ];
   DWORD dwLen ;
   const char * lpSection = hb_parc( 1 );
   const char * lpEntry = HB_ISCHAR(2) ? hb_parc( 2 ) : NULL ;
   const char * lpDefault = hb_parc( 3 );
   const char * lpFileName = hb_parc( 4 );

   memset( &bBuffer, 0, sizeof( bBuffer ) );

   dwLen = GetPrivateProfileString( lpSection , lpEntry ,lpDefault , bBuffer, sizeof( bBuffer ) , lpFileName);
   if( dwLen )
      hb_retclen( (char *) bBuffer, dwLen );
   else
      hb_retc( lpDefault );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( WRITEPRIVATEPROFILESTRING )
{
   const char * lpSection = hb_parc( 1 );
   const char * lpEntry = HB_ISCHAR( 2 ) ? hb_parc( 2 ) : NULL ;
   const char * lpData = HB_ISCHAR( 3 ) ? hb_parc( 3 ) : NULL ;
   const char * lpFileName= hb_parc( 4 );

   if( WritePrivateProfileString( lpSection , lpEntry , lpData , lpFileName ) )
      hb_retl( TRUE ) ;
   else
      hb_retl(FALSE);
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( DELINIENTRY )
{
   hb_retl( WritePrivateProfileString( hb_parc( 1 ),         /* Section */
                                       hb_parc( 2 ),         /* Entry */
                                       NULL,                 /* String */
                                       hb_parc( 3 ) ) );     /* INI File */
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( DELINISECTION )
{
   hb_retl( WritePrivateProfileString( hb_parc( 1 ),       /* Section */
                                       NULL,               /* Entry */
                                       "",                 /* String */
                                       hb_parc( 2 ) ) );   /* INI File */
}

#pragma ENDDUMP

