/*
 * $Id: h_comm.prg,v 1.11 2017-10-01 15:52:26 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Communication functions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
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
 * Copyright 1999-2017, https://harbour.github.io/
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


#include "oohg.ch"
#include "common.ch"
#include "i_windefs.ch"

STATIC _OOHG_StationName := ""
STATIC _OOHG_SendDataCount := 0
STATIC _OOHG_CommPath := ""

Function GetData()

   Local PacketNames [ aDir ( _OOHG_CommPath + _OOHG_StationName + '.*'  ) ] , i , Rows , Cols , RetVal := Nil , bd , aItem , aTemp := {} , r , c
   Local DataValue, DataType, DataLenght, Packet

   aDir ( _OOHG_CommPath + _OOHG_StationName + '.*' , PacketNames )

   If Len ( PacketNames ) == 0
      Return Nil
   EndIf

   bd = Set (_SET_DATEFORMAT )

   SET DATE TO ANSI

   Packet := MemoRead ( _OOHG_CommPath + PacketNames [1] )

   Rows := Val ( SubStr ( Memoline ( Packet , , 1 ) , 11 , 99 ) )
   Cols := Val ( SubStr ( Memoline ( Packet , , 2 ) , 11 , 99 )   )

   Do Case

   // Single Data

   Case Rows == 0 .And. Cols == 0

      DataType := SubStr ( Memoline ( Packet ,  , 3 ) , 12 , 1 )
      DataLenght := Val ( SubStr ( Memoline ( Packet , , 3 ) , 14 , 99 ) )

      DataValue := Memoline ( Packet , 254 , 4 )

      Do Case
      Case DataType == 'C'
         RetVal := Left ( DataValue , DataLenght )
      Case DataType == 'N'
         RetVal := Val ( DataValue )
      Case DataType == 'D'
         RetVal := CTOD ( DataValue )
      Case DataType == 'L'
         RetVal := iif ( Alltrim(DataValue) == 'T' , .t. , .f. )
      Case DataType == 'T'
         RetVal := CTOT ( DataValue )
      End Case

      // One Dimension Array Data

   Case Rows != 0 .And. Cols == 0

            i := 3

            Do While i < MlCount ( Packet )

               DataType   := SubStr ( Memoline ( Packet , , i ) , 12 , 1 )
               DataLenght := Val ( SubStr ( Memoline ( Packet , , i ) , 14 , 99 ) )

               i++

               DataValue  := Memoline ( Packet , 254 , i )

               Do Case
                  Case DataType == 'C'
                     aItem := Left ( DataValue , DataLenght )
                  Case DataType == 'N'
                     aItem := Val ( DataValue )
                  Case DataType == 'D'
                     aItem := CTOD ( DataValue )
                  Case DataType == 'L'
                     aItem := iif ( Alltrim(DataValue) == 'T' , .t. , .f. )
                  Case DataType == 'T'
                     aItem := CTOT ( DataValue )
               End Case

               aAdd ( aTemp , aItem )

               i++

            EndDo

            RetVal := aTemp

         // Two Dimension Array Data

         Case Rows != 0 .And. Cols != 0

            i := 3

            aTemp := Array ( Rows , Cols )

            r := 1
                           c := 1

            Do While i < MlCount ( Packet )

               DataType   := SubStr ( Memoline ( Packet , , i ) , 12 , 1 )
               DataLenght := Val ( SubStr ( Memoline ( Packet , , i ) , 14 , 99 ) )

               i++

               DataValue  := Memoline ( Packet , 254 , i )

               Do Case
                  Case DataType == 'C'
                     aItem := Left ( DataValue , DataLenght )
                  Case DataType == 'N'
                     aItem := Val ( DataValue )
                  Case DataType == 'D'
                     aItem := CTOD ( DataValue )
                  Case DataType == 'L'
                     aItem := iif ( Alltrim(DataValue) == 'T' , .t. , .f. )
                  Case DataType == 'T'
                     aItem := CTOT ( DataValue )
               End Case

               aTemp [r] [c] := aItem

               c++
               if c > Cols
                  r++
                  c := 1
               EndIf

               i++

            EndDo

            RetVal := aTemp

      End Case

   Delete File ( _OOHG_CommPath + PacketNames [1] )

   Set (_SET_DATEFORMAT ,bd)

   Return ( RetVal )

Function SendData ( cDest , Data )

   Local cData, i, j
   LOCAL pData, cLen, cType, FileName, Rows, Cols

   _OOHG_SendDataCount++

   FileName := _OOHG_CommPath + cDest + '.' + _OOHG_StationName + '.' + Alltrim ( Str ( _OOHG_SendDataCount ) )

   If ValType ( Data ) == 'A'

      If ValType ( Data [1] ) != 'A'

         cData := '#DataRows=' +   Alltrim(Str(Len(Data)))   + chr(13) + chr(10)
         cData := cData + '#DataCols=0'   + chr(13) + chr(10)

         For i := 1 To Len ( Data )

            cType := ValType ( Data [i] )

            If cType == 'D'
               pData := alltrim(str(year(data[i]))) + '.' + alltrim(str(month(data[i]))) + '.' + alltrim(str(day(data[i])))
               cLen := Alltrim(Str(Len(pData)))
            ElseIf cType == 'L'
               If Data [i] == .t.
                  pData := 'T'
               Else
                  pData := 'F'
               EndIf
               cLen := Alltrim(Str(Len(pData)))
            ElseIf cType == 'N'
               pData := str ( Data [i] )
               cLen := Alltrim(Str(Len(pData)))
            ElseIf cType == 'C'
               pData := Data [i]
               cLen := Alltrim(Str(Len(pData)))
            Else
               MsgOOHGError('SendData: Type Not Suported. Program terminated.')
            EndIf

            cData := cData + '#DataBlock='   + cType   + ',' + cLen + chr(13) + chr(10)
            cData := cData + pData      + chr(13) + chr(10)

         Next i

         MemoWrit ( FileName , cData )

      Else

         Rows := Len ( Data )
         Cols := Len ( Data [1] )

         cData := '#DataRows=' +   Alltrim(Str(Rows))   + chr(13) + chr(10)
         cData := cData + '#DataCols=' +   Alltrim(Str(Cols)) + chr(13) + chr(10)

         For i := 1 To Rows

            For j := 1 To Cols

            cType := ValType ( Data [i] [j] )

            If cType == 'D'
               pData := alltrim(str(year(data[i][j]))) + '.' + alltrim(str(month(data[i][j]))) + '.' + alltrim(str(day(data[i][j])))
               cLen := Alltrim(Str(Len(pData)))
            ElseIf cType == 'L'
               If Data [i] [j] == .t.
                  pData := 'T'
               Else
                  pData := 'F'
               EndIf
               cLen := Alltrim(Str(Len(pData)))
            ElseIf cType == 'N'
               pData := str ( Data [i] [j] )
               cLen := Alltrim(Str(Len(pData)))
            ElseIf cType == 'C'
               pData := Data [i] [j]
               cLen := Alltrim(Str(Len(pData)))
            Else
               MsgOOHGError('SendData: Type Not Suported. Program terminated.')
            EndIf

            cData := cData + '#DataBlock='   + cType   + ',' + cLen+ chr(13) + chr(10)
            cData := cData + pData      + chr(13) + chr(10)

            Next j
         Next i

         MemoWrit ( FileName , cData )

      EndIf

   Else

      cType := ValType ( Data )

      If cType == 'D'
         pData := alltrim(str(year(data))) + '.' + alltrim(str(month(data))) + '.' + alltrim(str(day(data)))
         cLen := Alltrim(Str(Len(pData)))
      ElseIf cType == 'L'
         If Data == .t.
            pData := 'T'
         Else
            pData := 'F'
         EndIf
         cLen := Alltrim(Str(Len(pData)))
      ElseIf cType == 'N'
         pData := str ( Data )
         cLen := Alltrim(Str(Len(pData)))
      ElseIf cType == 'C'
         pData := Data
         cLen := Alltrim(Str(Len(pData)))
      Else
         MsgOOHGError( "SendData: Type Not Suported. Program terminated." )
      EndIf

      cData := '#DataRows=0'      + chr(13) + chr(10)
      cData := cData + '#DataCols=0'   + chr(13) + chr(10)

      cData := cData + '#DataBlock='   + cType + ',' + cLen+ chr(13) + chr(10)
      cData := cData + pData      + chr(13) + chr(10)

      MemoWrit ( FileName , cData )

   EndIf

   Return Nil

Function SetCommStationName( st )

   If ValType( st ) $ "CM" .AND. ! Empty( st )
      _OOHG_StationName   := st
      _OOHG_SendDataCount := 0
   EndIf

   Return _OOHG_StationName

Function SetCommPath( cph )

   If ValType( cph ) $ "CM"
      _OOHG_CommPath := cph
   EndIf

   Return _OOHG_CommPath
