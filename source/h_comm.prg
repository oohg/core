/*
 * $Id: h_comm.prg $
 */
/*
 * ooHG source code:
 * Communications related functions
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
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


#include "oohg.ch"
#include "common.ch"
#include "i_windefs.ch"

STATIC _OOHG_StationName   := ""
STATIC _OOHG_SendDataCount := 0
STATIC _OOHG_CommPath      := ""

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetData()

   LOCAL PacketNames, i, Rows, Cols, RetVal := NIL, bd, aItem, aTemp := {}, r, c
   LOCAL DataValue, DataType, DataLenght, Packet, cph, stn

   App.MutexLock
   cph := _OOHG_CommPath
   stn := _OOHG_StationName
   App.MutexUnLock

   PacketNames := Array( ADir( cph + stn + '.*' ) )

   ADir( cph + stn + '.*', PacketNames )

   IF Len ( PacketNames ) == 0
      RETURN NIL
   ENDIF

   bd = Set( _SET_DATEFORMAT )

   SET DATE TO ANSI

   Packet := MemoRead( cph + PacketNames[ 1 ] )

   Rows := Val( SubStr( MemoLine( Packet, NIL, 1 ), 11, 99 ) )
   Cols := Val( SubStr( MemoLine( Packet, NIL, 2 ), 11, 99 ) )

   DO CASE
   CASE Rows == 0 .AND. Cols == 0
      // Single Data

      DataType   := SubStr( MemoLine( Packet, NIL, 3 ), 12, 1 )
      DataLenght := Val( SubStr( MemoLine( Packet, NIL, 3 ), 14, 99 ) )
      DataValue  := MemoLine( Packet, 254, 4 )

      DO CASE
      CASE DataType == 'C'
         RetVal := Left( DataValue, DataLenght )
      CASE DataType == 'N'
         RetVal := Val( DataValue )
      CASE DataType == 'D'
         RetVal := CToD( DataValue )
      CASE DataType == 'L'
         RetVal := iif( AllTrim( DataValue ) == 'T', .T., .F. )
      CASE DataType == 'T'
         RetVal := CToT( DataValue )
      END CASE

   CASE Rows != 0 .AND. Cols == 0
      // One Dimension Array Data

      i := 3
      DO WHILE i < MLCount( Packet )
         DataType   := SubStr( MemoLine( Packet, NIL, i ), 12, 1 )
         DataLenght := Val( SubStr( MemoLine( Packet, NIL, i ), 14, 99 ) )
         i++

         DataValue := MemoLine( Packet, 254, i )

         DO CASE
         CASE DataType == 'C'
            aItem := Left( DataValue, DataLenght )
         CASE DataType == 'N'
            aItem := Val( DataValue )
         CASE DataType == 'D'
            aItem := CToD( DataValue )
         CASE DataType == 'L'
            aItem := iif( AllTrim( DataValue ) == 'T', .T., .F. )
         CASE DataType == 'T'
            aItem := CToT( DataValue )
         END CASE

         AAdd( aTemp, aItem )
         i++
      ENDDO

      RetVal := aTemp

   CASE Rows != 0 .AND. Cols != 0
      // Two Dimension Array Data

      i := 3
      aTemp := Array( Rows, Cols )
      r := 1
      c := 1

      DO WHILE i < MLCount( Packet )
         DataType   := SubStr( MemoLine( Packet, NIL, i ), 12, 1 )
         DataLenght := Val( SubStr( MemoLine( Packet, NIL, i ), 14, 99 ) )
         i++

         DataValue  := MemoLine( Packet, 254, i )

         DO CASE
         CASE DataType == 'C'
            aItem := Left( DataValue, DataLenght )
         CASE DataType == 'N'
            aItem := Val( DataValue )
         CASE DataType == 'D'
            aItem := CToD( DataValue )
         CASE DataType == 'L'
            aItem := iif( AllTrim( DataValue ) == 'T', .T., .F. )
         CASE DataType == 'T'
            aItem := CToT( DataValue )
         END CASE

         aTemp[ r, c ] := aItem
         c++
         IF c > Cols
            r++
            c := 1
         ENDIF
         i++
      ENDDO

      RetVal := aTemp

   END CASE

   DELETE FILE ( cph + PacketNames[ 1 ] )

   Set( _SET_DATEFORMAT, bd )

   RETURN ( RetVal )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION SendData( cDest, Data )

   LOCAL cData, i, j, cph, stn, sdc
   LOCAL pData, cLen, cType, FileName, Rows, Cols

   App.MutexLock
   cph := _OOHG_CommPath
   stn := _OOHG_StationName
   _OOHG_SendDataCount++
   sdc := _OOHG_SendDataCount
   App.MutexUnLock

   FileName := cph + cDest + '.' + stn + '.' + AllTrim( Str( sdc ) )

   IF ValType( Data ) == 'A'
      IF ValType( Data[ 1 ] ) != 'A'
         cData := '#DataRows=' +  AllTrim( Str( Len( Data ) ) ) + CRLF
         cData := cData + '#DataCols=0' + CRLF

         FOR i := 1 TO Len( Data )
            cType := ValType( Data[ i ] )

            IF cType == 'D'
               pData := AllTrim( Str( Year( Data[ i ] ) ) ) + '.' + AllTrim( Str( Month( Data[ i ] ) ) ) + '.' + AllTrim( Str( Day( Data[ i ] ) ) )
               cLen := AllTrim( Str( Len( pData ) ) )
            ELSEIF cType == 'L'
               IF Data[ i ] == .T.
                  pData := 'T'
               ELSE
                  pData := 'F'
               ENDIF
               cLen := AllTrim( Str( Len( pData ) ) )
            ELSEIF cType == 'N'
               pData := Str( Data[ i ] )
               cLen := AllTrim( Str( Len( pData ) ) )
            ELSEIF cType == 'C'
               pData := Data[ i ]
               cLen := AllTrim( Str( Len( pData ) ) )
            ELSE
               MsgOOHGError( 'SendData: Type Not Suported. Program terminated.' )
            ENDIF

            cData := cData + '#DataBlock=' + cType + ',' + cLen + CRLF
            cData := cData + pData + CRLF
         NEXT i

         MemoWrit( FileName, cData )
      ELSE
         Rows := Len( Data )
         Cols := Len( Data[ 1 ] )

         cData := '#DataRows=' + AllTrim( Str( Rows ) ) + CRLF
         cData := cData + '#DataCols=' + AllTrim( Str( Cols ) ) + CRLF

         FOR i := 1 TO Rows
            FOR j := 1 TO Cols
               cType := ValType( Data[ i, j ] )

               IF cType == 'D'
                  pData := AllTrim( Str( Year( Data[ i, j ] ) ) ) + '.' + AllTrim( Str( Month( Data[ i, j ] ) ) ) + '.' + AllTrim( Str( Day( Data[ i, j ] ) ) )
                  cLen := AllTrim( Str( Len( pData ) ) )
               ELSEIF cType == 'L'
                  IF Data[ i, j ] == .T.
                     pData := 'T'
                  ELSE
                     pData := 'F'
                  ENDIF
                  cLen := AllTrim( Str( Len( pData ) ) )
               ELSEIF cType == 'N'
                  pData := Str( Data[ i, j ] )
                  cLen := AllTrim( Str( Len(pData ) ) )
               ELSEIF cType == 'C'
                  pData := Data[ i, j ]
                  cLen := AllTrim( Str( Len( pData ) ) )
               ELSE
                  MsgOOHGError( 'SendData: Type Not Suported. Program terminated.' )
               ENDIF

               cData := cData + '#DataBlock=' + cType + ',' + cLen + CRLF
               cData := cData + pData + CRLF
            NEXT j
         NEXT i

         MemoWrit ( FileName, cData )
      ENDIF
   ELSE
      cType := ValType ( Data )

      IF cType == 'D'
         pData := AllTrim( Str( Year( Data ) ) ) + '.' + AllTrim( Str( Month( data ) ) ) + '.' + AllTrim( Str( Day( Data ) ) )
         cLen := AllTrim( Str( Len( pData ) ) )
      ELSEIF cType == 'L'
         IF Data == .T.
            pData := 'T'
         ELSE
            pData := 'F'
         ENDIF
         cLen := AllTrim( Str( Len( pData ) ) )
      ELSEIF cType == 'N'
         pData := Str( Data )
         cLen := AllTrim( Str( Len( pData ) ) )
      ELSEIF cType == 'C'
         pData := Data
         cLen := AllTrim( Str( Len( pData ) ) )
      ELSE
         MsgOOHGError( "SendData: Type Not Suported. Program terminated." )
      ENDIF

      cData := '#DataRows=0'+ CRLF
      cData := cData + '#DataCols=0' + CRLF
      cData := cData + '#DataBlock=' + cType + ',' + cLen + CRLF
      cData := cData + pData + CRLF

      MemoWrit( FileName, cData )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION SetCommStationName( stn )

   App.MutexLock
   IF ValType( stn ) $ "CM" .AND. ! Empty( stn )
      _OOHG_StationName   := stn
      _OOHG_SendDataCount := 0
   ELSE
      stn := _OOHG_StationName
   ENDIF
   App.MutexUnlock

   RETURN stn

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION SetCommPath( cph )

   App.MutexLock
   IF ValType( cph ) $ "CM"
      _OOHG_CommPath := cph
   ELSE
      cph := _OOHG_CommPath
   ENDIF
   App.MutexUnlock

   RETURN cph
