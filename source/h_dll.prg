/*
 * $Id: h_dll.prg,v 1.2 2009-12-14 03:25:13 guerra000 Exp $
 */
/*
 * Harbour Project source code:
 * DLL access functions
 *
 * Copyright 2005 Vic McClung
 *
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
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

 // adapted to ooHG  by Ciro Vargas Clemow

#define MAX_PARAMS   8

function CALLDLL32( /* p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 */ )
local aPass := array( 11 )
local aParms := HB_aParams()
local nParmCnt := LEN( aParms )
local i

   IF nParmCnt > MAX_PARAMS + 2
      return 0
   ENDIF

   aPass[ 1 ] := aParms[ 1 ]
   aPass[ 2 ] := aParms[ 2 ]
   aPass[ 3 ] := nParmCnt - 2
   FOR i := 3 TO nParmCnt
      aPass[i+1] := IIF(valtype(aParms[i]) == "C", STRPTR(aParms[i]), aParms[i])
   NEXT

return HB_DynaCall1( aPass[1],aPass[2],aPass[3],aPass[4],aPass[5],aPass[6],aPass[7],aPass[8],aPass[9],aPass[10],aPass[11])

EXTERN PtrStr

#PRAGMA BEGINDUMP

#include "windows.h"
#include "hbapi.h"

#define MAX_PARAMS   8

HINSTANCE HB_DllStore[ 256 ];

HINSTANCE HB_LoadDll(char *);
void      HB_UnloadDll(void);
typedef   int (CALLBACK *DYNACALL1)(void);
int       HB_DynaCall(char *, char *, int, ...);

HINSTANCE HB_LoadDll( char *DllName )
{
  static int DllCnt;
  static int RegUnload = 0;
  if ( ! RegUnload )
  {
     RegUnload = ! atexit( HB_UnloadDll );
  }
  DllCnt = ( DllCnt + 1 ) & 255;
  FreeLibrary( HB_DllStore[ DllCnt ] );
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
      FreeLibrary( HB_DllStore[ i ] );
   }
}

HB_FUNC( HB_DYNACALL1 )
{
   hb_retnl(
           HB_DynaCall(
             hb_parc(1),
             hb_parc(2),
             hb_parnl(3),
             hb_parnl(4),
             hb_parnl(5),
             hb_parnl(6),
             hb_parnl(7),
             hb_parnl(8),
             hb_parnl(9),
             hb_parnl(10),
             hb_parnl(11)
             )
             );
}

int HB_DynaCall( char *FuncName, char *DllName, int nArgs, ... )
{
   register int i;
   HINSTANCE  hInst;
   DYNACALL1 lpAddr;
   int arg;
   int result = -2000;
   //int *argtable = ( int * ) malloc( nArgs * sizeof *argtable );
   int argtable[ MAX_PARAMS ];
   char buff[ 256 ];
   va_list ap;

   hInst = GetModuleHandle( DllName );
   if( hInst == NULL )
   {
      hInst = HB_LoadDll( DllName );
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
      va_start( ap, nArgs );
      for ( i = 0; i < nArgs; i++ )
      {
          arg = va_arg( ap, int );
          argtable[ i ] = arg;
      }
      for( i = nArgs - 1; i >= 0; i-- )
      {
         arg = argtable[i];
         #if defined( __LCC__ )
         _asm("pushl %arg")
         #elif defined( __MINGW32__ )
         __asm__("pushl %0" : : "r" (arg));
         #elif defined( __BCPLUSPLUS__ )
           asm push arg
         #else
         __asm{push arg}
         #endif
      }
      result = ( int )( lpAddr )();
      va_end( ap );
   }
   return result;
}

HB_FUNC( STRPTR )
{
   char *cString = hb_parc( 1 );
   hb_retnl( ( LONG_PTR ) cString );
}

HB_FUNC( PTRSTR )
{
   hb_retc( ( LPSTR ) hb_parnl( 1 ) );
}

#PRAGMA ENDDUMP
