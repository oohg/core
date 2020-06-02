/*
 * $Id: h_dll.prg $
 */
/*
 * ooHG source code:
 * DLL access functions
 *
 * Copyright 2009-2020 Ciro Vargas C. <cvc@oohg.org> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Based upon:
 * Original source code of Vic McClung
 * Copyright 2005 <vicmcclung@vicmcclung.com>
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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


#pragma BEGINDUMP

#include "oohg.h"

#define MAX_PARAMS 9

typedef LONG_PTR ( CALLBACK * DYNACALL0 ) ( void );
typedef LONG_PTR ( CALLBACK * DYNACALL1 ) ( LONG_PTR d1 );
typedef LONG_PTR ( CALLBACK * DYNACALL2 ) ( LONG_PTR d1, LONG_PTR d2 );
typedef LONG_PTR ( CALLBACK * DYNACALL3 ) ( LONG_PTR d1, LONG_PTR d2, LONG_PTR d3 );
typedef LONG_PTR ( CALLBACK * DYNACALL4 ) ( LONG_PTR d1, LONG_PTR d2, LONG_PTR d3, LONG_PTR d4 );
typedef LONG_PTR ( CALLBACK * DYNACALL5 ) ( LONG_PTR d1, LONG_PTR d2, LONG_PTR d3, LONG_PTR d4, LONG_PTR d5 );
typedef LONG_PTR ( CALLBACK * DYNACALL6 ) ( LONG_PTR d1, LONG_PTR d2, LONG_PTR d3, LONG_PTR d4, LONG_PTR d5, LONG_PTR d6 );
typedef LONG_PTR ( CALLBACK * DYNACALL7 ) ( LONG_PTR d1, LONG_PTR d2, LONG_PTR d3, LONG_PTR d4, LONG_PTR d5, LONG_PTR d6, LONG_PTR d7 );
typedef LONG_PTR ( CALLBACK * DYNACALL8 ) ( LONG_PTR d1, LONG_PTR d2, LONG_PTR d3, LONG_PTR d4, LONG_PTR d5, LONG_PTR d6, LONG_PTR d7, LONG_PTR d8 );
typedef LONG_PTR ( CALLBACK * DYNACALL9 ) ( LONG_PTR d1, LONG_PTR d2, LONG_PTR d3, LONG_PTR d4, LONG_PTR d5, LONG_PTR d6, LONG_PTR d7, LONG_PTR d8, LONG_PTR d9 );

static HINSTANCE _OOHG_DllStore[ 256 ];

void _OOHG_UnloadDll( void )
{
   register int i;

   for( i = 255; i >= 0; i-- )
   {
      if( _OOHG_DllStore[ i ] )
      {
         FreeLibrary( _OOHG_DllStore[ i ] );
      }
   }
}

HINSTANCE _OOHG_LoadDLL( const char *DllName )
{
   static int DllCnt = 0;
   static int RegUnload = 0;
   HINSTANCE ret;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! RegUnload )
   {
      RegUnload = ! atexit( _OOHG_UnloadDll );
      memset( _OOHG_DllStore, 0 , sizeof( _OOHG_DllStore ) );
   }
   DllCnt = ( DllCnt + 1 ) & 255;
   if( _OOHG_DllStore[ DllCnt ] )
   {
      FreeLibrary( _OOHG_DllStore[ DllCnt ] );
   }
   ret = _OOHG_DllStore[ DllCnt ] = LoadLibrary( DllName );
   ReleaseMutex( _OOHG_GlobalMutex() );
   return ret;
}

HB_FUNC( UNLOADALLDLL )
{
   _OOHG_UnloadDll();
}

HB_FUNC( OOHG_CALLDLL32 )
{
   register int i;
   HINSTANCE hInst;
   DYNACALL1 lpAddr;
   LONG_PTR result = -2000;
   char buff[ 256 ];
   const char *FuncName = hb_parc( 1 );
   const char *DllName = hb_parc( 2 );
   int nArgs;
   LONG_PTR dd[ MAX_PARAMS ];
   void *p;

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
      hInst = _OOHG_LoadDLL( DllName );
   }
   if( ! hInst )
   {
      hb_retnl( 0 );
      return;
   }
   lpAddr = (DYNACALL1) GetProcAddress( hInst, FuncName );
   if( lpAddr == NULL )
   {
      sprintf( buff, "%s%s", FuncName, "A" );
      lpAddr = (DYNACALL1) GetProcAddress( hInst, buff );
   }
   if( lpAddr == NULL )
   {
      sprintf( buff, "%s%s", "_", FuncName );
      lpAddr = (DYNACALL1) GetProcAddress( hInst, buff );
   }
   if( lpAddr )
   {
      for( i = 0; i < nArgs; i++ )
      {
         if( HB_ISCHAR( i + 3 ) )
         {
            dd[ i ] = (LONG_PTR) HB_UNCONST( hb_parc( i + 3 ) );
         }
         else if( ISPTR( i + 3 ) )
         {
            p = hb_parptr( i + 3 );
            dd[ i ] = (LONG_PTR) p;
         }
         else
         {
            dd[ i ] = LONG_PTRparam( i + 3 );
         }
      }

      switch( nArgs )
      {
         case 0:
            result = (LONG_PTR) ( (DYNACALL0) (FARPROC) lpAddr )();
            break;

         case 1:
            result = (LONG_PTR) ( (DYNACALL1) (FARPROC) lpAddr )( dd[ 0 ] );
            break;

         case 2:
            result = (LONG_PTR) ( (DYNACALL2) (FARPROC) lpAddr )( dd[ 0 ], dd[ 1 ] );
            break;

         case 3:
            result = (LONG_PTR) ( (DYNACALL3) (FARPROC) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ] );
            break;

         case 4:
            result = (LONG_PTR) ( (DYNACALL4) (FARPROC) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ] );
            break;

         case 5:
            result = (LONG_PTR) ( (DYNACALL5) (FARPROC) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ] );
            break;

         case 6:
            result = (LONG_PTR) ( (DYNACALL6) (FARPROC) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ] );
            break;

         case 7:
            result = (LONG_PTR) ( (DYNACALL7) (FARPROC) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ] );
            break;

         case 8:
            result = (LONG_PTR) ( (DYNACALL8) (FARPROC) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ], dd[ 7 ] );
            break;

         default:
            result = (LONG_PTR) ( (DYNACALL9) (FARPROC) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ], dd[ 7 ], dd[ 8 ] );
            break;

      }
   }

   HB_RETNL( result );
}

HB_FUNC( STRPTR )
{
   HANDLEret( hb_parc( 1 ) );
}

HB_FUNC( PTRSTR )
{
   hb_retc( HANDLEparam( 1 ) );
}

#pragma ENDDUMP
