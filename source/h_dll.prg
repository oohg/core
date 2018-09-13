/*
 * $Id: h_dll.prg $
 */
/*
 * ooHG source code:
 * DLL access functions
 *
 * Based upon
 * Original source code of Vic McClung
 * Copyright 2005 <vicmcclung@vicmcclung.com>
 *
 * Copyright 2009-2018 Ciro Vargas Clemow <cvc@oohg.org>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
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

#include "windows.h"
#include "hbapi.h"
#include <commctrl.h>
#include "oohg.h"

#define MAX_PARAMS   9

HINSTANCE HB_DllStore[ 256 ];

HINSTANCE HB_LoadDll(char *);
void      HB_UnloadDll(void);
typedef   int (CALLBACK *DYNACALL0)(void);
typedef   int (CALLBACK *DYNACALL1)(int d1);
typedef   int (CALLBACK *DYNACALL2)(int d1,int d2);
typedef   int (CALLBACK *DYNACALL3)(int d1,int d2,int d3);
typedef   int (CALLBACK *DYNACALL4)(int d1,int d2,int d3,int d4);
typedef   int (CALLBACK *DYNACALL5)(int d1,int d2,int d3,int d4,int d5);
typedef   int (CALLBACK *DYNACALL6)(int d1,int d2,int d3,int d4,int d5,int d6);
typedef   int (CALLBACK *DYNACALL7)(int d1,int d2,int d3,int d4,int d5,int d6,int d7);
typedef   int (CALLBACK *DYNACALL8)(int d1,int d2,int d3,int d4,int d5,int d6,int d7,int d8);
typedef   int (CALLBACK *DYNACALL9)(int d1,int d2,int d3,int d4,int d5,int d6,int d7,int d8,int d9);

HINSTANCE HB_LoadDll( char *DllName )
{
   // Thread safe.
   static int DllCnt = 0;
   static int RegUnload = 0;
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
   return HB_DllStore[ DllCnt ] = LoadLibrary( DllName );
}

HB_FUNC( UNLOADALLDLL )
{
   HB_UnloadDll();
}

void HB_UnloadDll( void )
{
   register int i;
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
   register int i;
   HINSTANCE  hInst;
   DYNACALL1 lpAddr;
   int result = -2000;
   char buff[ 256 ];
   char *FuncName = ( char * ) hb_parc( 1 );
   char *DllName = ( char * ) hb_parc( 2 );
   int nArgs;
   int dd[ MAX_PARAMS ];

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
      sprintf(buff,"%s%s","_",FuncName);
      lpAddr=(DYNACALL1)GetProcAddress(hInst,buff);
   }
   if( lpAddr )
   {
      for( i = 0; i < nArgs; i++ )
      {
         if( HB_ISCHAR( i + 3 ) )
         {
            dd[ i ] = ( int ) ( char * ) hb_parc( i + 3 );
         }
         else if( ISPTR( i + 3 ) )
         {
            dd[ i ] = ( int ) hb_parptr( i + 3 );
         }
         else
         {
            dd[ i ] = ( int ) hb_parni( i + 3 );
         }
      }

      switch( nArgs )
      {
         case 0:
            result = ( int )( ( DYNACALL0 ) lpAddr )();
            break;

         case 1:
            result = ( int )( ( DYNACALL1 ) lpAddr )( dd[ 0 ] );
            break;

         case 2:
            result = ( int )( ( DYNACALL2 ) lpAddr )( dd[ 0 ], dd[ 1 ] );
            break;

         case 3:
            result = ( int )( ( DYNACALL3 ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ] );
            break;

         case 4:
            result = ( int )( ( DYNACALL4 ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ] );
            break;

         case 5:
            result = ( int )( ( DYNACALL5 ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ] );
            break;

         case 6:
            result = ( int )( ( DYNACALL6 ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ] );
            break;

         case 7:
            result = ( int )( ( DYNACALL7 ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ] );
            break;

         case 8:
            result = ( int )( ( DYNACALL8 ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ], dd[ 7 ] );
            break;

         default:
            result = ( int )( ( DYNACALL9 ) lpAddr )( dd[ 0 ], dd[ 1 ], dd[ 2 ], dd[ 3 ], dd[ 4 ], dd[ 5 ], dd[ 6 ], dd[ 7 ], dd[ 8 ] );
            break;

      }
   }

   hb_retnl( result );
}

HB_FUNC( STRPTR )
{
   char *cString = ( char * ) hb_parc( 1 );
   HB_RETNL( ( LONG_PTR ) cString );
}

HB_FUNC( PTRSTR )
{
   hb_retc( ( LPSTR ) HB_PARNL( 1 ) );
}

#pragma ENDDUMP
