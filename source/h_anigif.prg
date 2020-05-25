/*
 * $Id: h_anigif.prg $
 */
/*
 * ooHG source code:
 * Animate GIF control
 *
 * Copyright 2016-2019 Fernando Yurisich <fyurisich@oohg.org> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Based upon:
 * An HMG Extended sample by
 * P.Chornyj <myorg63@mail.ru>
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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
#include "hbclass.ch"
#include "i_windefs.ch"
#include "fileio.ch"

#define FRAME_END Chr( 0 ) + Chr( 33 ) + Chr( 249 )

#ifndef __XHARBOUR__
   #xtranslate At(<a>,<b>,[<x,...>]) => hb_At(<a>,<b>,<x>)
#endif


CLASS TAniGIF FROM TImage

   DATA aDelays                   INIT {}
   DATA aInfo                     INIT { "", 0, 0 }
   DATA aPictures                 INIT {}
   DATA CurrentFrame              INIT 0
   DATA FileName                  INIT ""
   DATA oTimer                    INIT Nil
   DATA Type                      INIT "ANIGIF" READONLY

   METHOD Define
   METHOD FrameCount              BLOCK { |Self| Len( ::aPictures ) }
   METHOD FrameDelay
   METHOD FrameHeight             BLOCK { |Self| ::aInfo[ 3 ] }
   METHOD FrameWidth              BLOCK { |Self| ::aInfo[ 2 ] }
   METHOD IsPlaying               BLOCK { |Self| ::oTimer:Enabled }
   METHOD Load
   METHOD Play                    BLOCK { |Self| ::oTimer:Enabled := ( ::FrameCount > 1 ) }
   METHOD Release
   METHOD ShowNextFrame
   METHOD Stop                    BLOCK { |Self| ::oTimer:Enabled := .F. }
   METHOD Version                 BLOCK { |Self| ::aInfo[ 1 ] }

   ENDCLASS

METHOD Define( ControlName, ParentForm, nCol, nRow, cFile, nWidth, nHeight, ;
               ProcedureName, nHelpId, lInvisible, lWhiteBack, lRtl, uBkClr, ;
               cTooltip, lBorder, lClientedge, lDisabled ) CLASS TAniGIF

   ::Load( cFile )

   ASSIGN nWidth     VALUE nWidth     TYPE "N"  DEFAULT ::FrameWidth
   ASSIGN nHeight    VALUE nHeight    TYPE "N"  DEFAULT ::FrameHeight

   ::Super:Define( ControlName, ParentForm, nCol, nRow, Nil, nWidth, nHeight, ProcedureName, ;
                   nHelpId, lInvisible, .F., lWhiteBack, lRtl, uBkClr, ;
                   Nil, Nil, .F., .F., cTooltip, lBorder, lClientedge, ;
                   .F., .F., .F., .F., Nil, lDisabled )

   ::oTimer := TTimer():Define( 0, Self, Nil, { || ::ShowNextFrame() }, .T. )

   ::ShowNextFrame()

   IF ! HB_IsLogical( lDisabled ) .OR. ! lDisabled
      ::Play()
   ENDIF

   RETURN SELF

METHOD FrameDelay( nFrame, nDelay )  CLASS TAniGIF

   LOCAL nMilliSeconds := 0

   IF HB_IsNumeric( nFrame ) .AND. nFrame > 0 .AND. nFrame <= ::FrameCount
      IF HB_IsNumeric( nDelay ) .AND. nDelay >= 0
         ::aDelays[ nFrame ] := nDelay
      ENDIF
      nMilliSeconds := ::aDelays[ nFrame ]
   ENDIF

   RETURN nMilliSeconds

METHOD Load( cGIF ) CLASS TAniGIF

   LOCAL aInfo, aPictures, aDelays, nHandle, nSize, cStream, i, j, cHeader, cFile, lClean

   // any attempt to load a file resets the control
   ::aInfo     := { "", 0, 0 }
   ::aPictures := {}
   ::aDelays   := {}

   ASSIGN cGIF VALUE cGIF TYPE "CM" DEFAULT ""
   ::FileName := cGIF

   IF Empty( cGIF )
      Return .F.
   ELSEIF File( cGIF )
      cFile := cGIF
      lClean := .F.
   ELSE
      // try to load from resource
      cFile := GetTempFolder() + '\' + cGIF + '_' + StrZero( Seconds() * 100 , 8 )
      IF ! SaveResourceToFile( cGIF, cFile, "GIF" )
         RETURN .F.
      ENDIF
      lClean := .T.
   ENDIF

   nHandle := FOpen( cFile )
   IF FError() <> 0
      IF lClean
         FErase( cFile )
      ENDIF
      RETURN .F.
   ENDIF

   nSize   := FSeek( nHandle, 0, FS_END )
   cStream := Space( nSize )
   FSeek( nHandle, 0, FS_SET )
   FRead( nHandle, @cStream, nSize )
   FClose( nHandle )

   IF FError() # 0 .OR. Empty( cStream )
      IF lClean
         FErase( cFile )
      ENDIF
      RETURN .F.
   ENDIF

   // header, version and frame size
   j := At( FRAME_END, cStream, 1 ) + 1
   cHeader := Left( cStream, j )
   IF Left( cHeader, 3 ) <> "GIF"
      IF lClean
         FErase( cFile )
      ENDIF
      RETURN .F.
   ENDIF
   aInfo := { SubStr( cHeader, 4, 3 ), ;           // Gif version
              Bin2W( SubStr( cHeader, 7, 2 ) ), ;  // Logical screen width
              Bin2W( SubStr( cHeader, 9, 2 ) ) }   // Logical screen height

   // frames
   aPictures := {}
   aDelays := {}

   i := j + 2
   DO WHILE .T.
      j := At( FRAME_END, cStream, i ) + 3
      IF j > Len( FRAME_END )
         aAdd( aPictures, cHeader + SubStr( cStream, i - 1, j - i ) )
         aAdd( aDelays, Bin2W( SubStr( Left( SubStr( cStream, i - 1, j - i ), 16 ), 4, 2 ) ) * 10 )
      ENDIF

      IF j == 3
         EXIT
      ELSE
         i := j
      ENDIF
   ENDDO

   IF i < Len( cStream )
      aAdd( aPictures, cHeader + SubStr( cStream, i - 1, Len( cStream ) - i ) )
      aAdd( aDelays, Bin2W( SubStr( Left( SubStr( cStream, i - 1, Len( cStream ) - i ), 16 ), 4, 2 ) ) * 10 )
   ENDIF

   ::aInfo  := aInfo
   ::aPictures  := aPictures
   ::aDelays := aDelays

   IF lClean
      FErase( cFile )
   ENDIF

   RETURN ::FrameCount # 0

METHOD Release() CLASS TAniGIF

   ::oTimer:Release()

   RETURN ::Super:Release()

METHOD ShowNextFrame() CLASS TAniGIF

   LOCAL nFrameCount := ::FrameCount

   IF nFrameCount == 0
      ::CurrentFrame := 0
   ELSE
      IF ::CurrentFrame < nFrameCount
         ::CurrentFrame ++
      ELSE
         ::CurrentFrame := 1
      ENDIF

      ::Buffer := ::aPictures[ ::CurrentFrame ]
      ::oTimer:Value := ::FrameDelay( ::CurrentFrame )

      DO EVENTS
   ENDIF

   RETURN NIL


#pragma BEGINDUMP

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif

#include <hbapi.h>
#include <windows.h>

BOOL SaveResourceToFile( const char *, const char *, const char * );

BOOL SaveResourceToFile( const char * res, const char * filename, const char * type )
{
   HRSRC     hrsrc;
   HINSTANCE hInst;
   DWORD     size, writ;
   HGLOBAL   hglob;
   LPVOID    rdata;
   HANDLE    hFile;

   hInst = GetModuleHandle( NULL );
   hrsrc = FindResource( hInst, res, type );
   if ( hrsrc == NULL )
      return FALSE;

  size = SizeofResource( hInst, hrsrc );
  hglob = LoadResource( hInst, hrsrc );
  rdata = LockResource( hglob );

  hFile = CreateFile( filename, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL );
  WriteFile( hFile, rdata, size, &writ, NULL );
  CloseHandle( hFile );

  return TRUE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SAVERESOURCETOFILE )
{
   hb_retl( SaveResourceToFile( hb_parc( 1 ), hb_parc( 2 ), hb_parc( 3 ) ) );
}

#pragma ENDDUMP
