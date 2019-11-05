/*
 * $Id: h_dll.prg $
 */
/*
 * ooHG source code:
 * DLL access functions
 *
 * Copyright 2009-2019 Ciro Vargas C. <cvc@oohg.org> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Based upon:
 * Original source code of Vic McClung
 * Copyright 2005 <vicmcclung@vicmcclung.com>
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


EXTERN PtrStr

#pragma BEGINDUMP

#include "oohg.h"

#define MAX_PARAMS  9

static HINSTANCE HB_DllStore[ 256 ];
HINSTANCE HB_LoadDll( const CHAR * );
VOID      HB_UnloadDll( VOID );
typedef   INT ( CALLBACK * DYNACALL0 ) ( VOID );
typedef   INT ( CALLBACK * DYNACALL1 ) ( INT d1 );
typedef   INT ( CALLBACK * DYNACALL2 ) ( INT d1, INT d2 );
typedef   INT ( CALLBACK * DYNACALL3 ) ( INT d1, INT d2, INT d3 );
typedef   INT ( CALLBACK * DYNACALL4 ) ( INT d1, INT d2, INT d3, INT d4 );
typedef   INT ( CALLBACK * DYNACALL5 ) ( INT d1, INT d2, INT d3, INT d4, INT d5 );
typedef   INT ( CALLBACK * DYNACALL6 ) ( INT d1, INT d2, INT d3, INT d4, INT d5, INT d6 );
typedef   INT ( CALLBACK * DYNACALL7 ) ( INT d1, INT d2, INT d3, INT d4, INT d5, INT d6, INT d7 );
typedef   INT ( CALLBACK * DYNACALL8 ) ( INT d1, INT d2, INT d3, INT d4, INT d5, INT d6, INT d7, INT d8 );
typedef   INT ( CALLBACK * DYNACALL9 ) ( INT d1, INT d2, INT d3, INT d4, INT d5, INT d6, INT d7, INT d8, INT d9 );

HINSTANCE HB_LoadDll( const CHAR * DllName )
{
   static INT DllCnt = 0;
   static INT RegUnload = 0;
   HINSTANCE ret;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! RegUnload )
   {
      RegUnload = ! atexit( HB_UnloadDll );
      memset( HB_DllStore, 0 , sizeof( HB_DllStore ) );
   }
   DllCnt = ( DllCnt + 1 ) & 255;
   if( HB_DllStore[ DllCnt ] )
   {
      FreeLibrary( HB_DllStore[ DllCnt ] );
   }
   ret = HB_DllStore[ DllCnt ] = LoadLibrary( DllName );
   ReleaseMutex( _OOHG_GlobalMutex() );
   return ret;
}

HB_FUNC( UNLOADALLDLL )
{
   HB_UnloadDll();
}

void HB_UnloadDll( void )
{
   register INT i;
   for( i = 255; i >= 0; i-- )
   {
      if( HB_DllStore[ i ] )
      {
         FreeLibrary( HB_DllStore[ i ] );
      }
   }
}

HB_FUNC( CALLDLL32 )
{
   register INT i;
   HINSTANCE hInst;
   DYNACALL1 lpAddr;
   INT result = -2000;
   CHAR buff[ 256 ];
   const CHAR * FuncName = ( const CHAR * ) hb_parc( 1 );
   const CHAR * DllName = ( const CHAR * ) hb_parc( 2 );
   INT nArgs;
   INT dd[ MAX_PARAMS ];

   nArgs = hb_pcount();
   if( nArgs < 2 || nArgs > MAX_PARAMS + 2 )
   {
      hb_retnl( 0 );
      return;
   }
   nArgs -= 2;

   hInst = GetModuleHandle( DllName );
   if( hInst == NULL )
   {
      hInst = HB_LoadDll( DllName );
   }
   if( ! hInst )
   {
      hb_retnl( 0 );
      return;
   }
   lpAddr = ( DYNACALL1 ) GetProcAddress( hInst, FuncName );
   if( lpAddr == NULL )
   {
      sprintf( buff, "%s%s", FuncName, "A" );
      lpAddr = ( DYNACALL1 ) GetProcAddress( hInst, buff );
   }
   if( lpAddr == NULL )
   {
      sprintf( buff, "%s%s", "_", FuncName );
      lpAddr = ( DYNACALL1 ) GetProcAddress( hInst, buff );
   }
   if( lpAddr )
   {
      for( i = 0; i < nArgs; i++ )
      {
         if( HB_ISCHAR( i + 3 ) )
         {
            dd[ i ] = ( INT ) ( const char * ) hb_parc( i + 3 );
         }
         else if( ISPTR( i + 3 ) )
         {
            dd[ i ] = ( INT ) hb_parptr( i + 3 );
         }
         else
         {
            dd[ i ] = ( INT ) hb_parni( i + 3 );
         }
      }

      switch( nArgs )
      {
         case 0:
            result = ( INT )( ( DYNACALL0 ) ( FARPROC ) lpAddr )();
            break;

         case 1:
            result = ( INT )( ( DYNACALL1 ) ( FARPROC ) lpAddr )( dd[ 0 ] );
            break;

         case 2:
            result = ( INT )( ( DYNACALL2 ) ( FARPROC ) lpAddr )( dd[ 0 ], dd[ 1 ] );
            break;

         case 3:
            result = ( INT )( ( DYNACALL3 ) ( FARPROC ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ] );
            break;

         case 4:
            result = ( INT )( ( DYNACALL4 ) ( FARPROC ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ] );
            break;

         case 5:
            result = ( INT )( ( DYNACALL5 ) ( FARPROC ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ] );
            break;

         case 6:
            result = ( INT )( ( DYNACALL6 ) ( FARPROC ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ] );
            break;

         case 7:
            result = ( INT )( ( DYNACALL7 ) ( FARPROC ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ] );
            break;

         case 8:
            result = ( INT )( ( DYNACALL8 ) ( FARPROC ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ], dd[ 7 ] );
            break;

         default:
            result = ( INT )( ( DYNACALL9 ) ( FARPROC ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ], dd[ 7 ], dd[ 8 ] );
            break;

      }
   }

   hb_retnl( result );
}

HB_FUNC( STRPTR )
{
   const CHAR * cString = ( const CHAR * ) hb_parc( 1 );
   HB_RETNL( ( LONG_PTR ) cString );
}

HB_FUNC( PTRSTR )
{
   hb_retc( ( LPSTR ) HB_PARNL( 1 ) );
}

#pragma ENDDUMP
