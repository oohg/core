/*
 * $Id: c_winapimisc.c $
 */
/*
 * OOHG source code:
 * Windows API related functions
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


#include "oohg.h"
#include <shlobj.h>
#include <lmcons.h>
#include <psapi.h>
#include <ctype.h>
#include <time.h>
#include <tchar.h>
#include <shlwapi.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "hbapifs.h"

#ifndef IShellFolder2_Release
   #define IShellFolder2_Release(T) (T)->lpVtbl->Release(T)
#endif
#ifndef IShellFolder2_ParseDisplayName
   #define IShellFolder2_ParseDisplayName(T,a,b,c,d,e,f) (T)->lpVtbl->ParseDisplayName(T,a,b,c,d,e,f)
#endif
#ifndef IShellFolder2_EnumObjects
   #define IShellFolder2_EnumObjects(T,a,b,c) (T)->lpVtbl->EnumObjects(T,a,b,c)
#endif
#ifndef IShellFolder2_BindToObject
   #define IShellFolder2_BindToObject(T,a,b,c,d) (T)->lpVtbl->BindToObject(T,a,b,c,d)
#endif
#ifndef IShellFolder2_GetAttributesOf
   #define IShellFolder2_GetAttributesOf(T,a,b,c) (T)->lpVtbl->GetAttributesOf(T,a,b,c)
#endif
#ifndef IShellFolder2_GetDisplayNameOf
   #define IShellFolder2_GetDisplayNameOf(T,a,b,c) (T)->lpVtbl->GetDisplayNameOf(T,a,b,c)
#endif
#ifndef IShellFolder2_GetDetailsOf
   #define IShellFolder2_GetDetailsOf(T,a,b,c) (T)->lpVtbl->GetDetailsOf(T,a,b,c)
#endif
#ifndef IEnumIDList_Next
   #define IEnumIDList_Next(T,a,b,c) (T)->lpVtbl->Next(T,a,b,c)
#endif
#ifndef IEnumIDList_Release
   #define IEnumIDList_Release(T) (T)->lpVtbl->AddRef(T)
#endif

#ifdef __XHARBOUR__
   #define HB_FHANDLE FHANDLE
#endif

/*
 * WaitRun function for MiniGUI with pipe redirection
 * Author Luiz Rafael Culik Guimaraes: culikr@uol.com.br
 * Parameters WaitRunPipe(cCommand,nShowWindow,cFile)
 */

HB_FUNC( WAITRUNPIPE )
{
   STARTUPINFO StartupInfo;
   PROCESS_INFORMATION ProcessInfo;
   HANDLE ReadPipeHandle;
   HANDLE WritePipeHandle;     
   char Data[1024];
   const char * szFile = hb_parc( 3 );
   HB_FHANDLE nHandle;
   SECURITY_ATTRIBUTES sa;

   ZeroMemory( &sa, sizeof( SECURITY_ATTRIBUTES ) );
   sa.nLength = sizeof( SECURITY_ATTRIBUTES );
   sa.bInheritHandle = 1;
   sa.lpSecurityDescriptor = NULL;

   if( ! hb_fsFile( szFile ) )
   {
      nHandle = hb_fsCreate( szFile, 0 );
   }
   else
   {
      nHandle = hb_fsOpen( szFile, 2 );
      hb_fsSeek( nHandle, 0, 2 );
   }

   if( ! CreatePipe( &ReadPipeHandle, &WritePipeHandle, &sa, 0 ) )
   {
      hb_retnl( -1 );
   }

   memset( &ProcessInfo, 0, sizeof( ProcessInfo ) );
   ProcessInfo.hProcess = INVALID_HANDLE_VALUE;
   ProcessInfo.hThread = INVALID_HANDLE_VALUE;

   memset( &StartupInfo, 0, sizeof( StartupInfo ) );
   StartupInfo.dwFlags = STARTF_USESHOWWINDOW | STARTF_USESTDHANDLES;
   StartupInfo.wShowWindow = (WORD) hb_parni( 2 );
   StartupInfo.hStdOutput = WritePipeHandle;
   StartupInfo.hStdError = WritePipeHandle;

   if( ! CreateProcess( 0, (LPSTR) HB_UNCONST( hb_parc( 1 ) ), 0, 0, FALSE,
                        CREATE_NEW_CONSOLE | NORMAL_PRIORITY_CLASS,
                        0, 0, &StartupInfo, &ProcessInfo ) )
   {
      hb_retnl( -1 );
   }

   for( ; ; )
   {
      DWORD BytesRead;
      DWORD TotalBytes;
      DWORD BytesLeft;

      /* Check for the presence of data in the pipe */
      if( ! PeekNamedPipe( ReadPipeHandle, Data, sizeof( Data ), &BytesRead, &TotalBytes, &BytesLeft ) )
      {
         hb_retnl( -1 );
      }

      /* If there is bytes, read them */
      if( BytesRead )
      {
         if( ! ReadFile( ReadPipeHandle, Data, sizeof( Data ) - 1, &BytesRead, NULL ) )
         {
            hb_retnl( -1 );
         }
         Data[ BytesRead ] = '\0';
         hb_fsWriteLarge( nHandle, (BYTE *) Data, BytesRead );
      }
      else
      {
         /* Is the console app terminated? */
         if( WaitForSingleObject( ProcessInfo.hProcess, 0 ) == WAIT_OBJECT_0 )
         {
            break;
         }
      }
   }

   CloseHandle( ProcessInfo.hThread );
   CloseHandle( ProcessInfo.hProcess );
   CloseHandle( ReadPipeHandle );
   CloseHandle( WritePipeHandle );
   hb_fsClose( nHandle );
}

HB_FUNC( GETBLUE )
{
   hb_retnl( GetBValue( hb_parnl( 1 ) ) );
}

HB_FUNC( GETRED )
{
   hb_retnl( GetRValue( hb_parnl( 1 ) ) );
}

HB_FUNC( GETGREEN )
{
   hb_retnl( GetGValue( hb_parnl( 1 ) ) );
}

HB_FUNC( GETKEYSTATE )
{
   hb_retni( GetKeyState( hb_parni( 1 ) ) );
}

HB_FUNC( HIWORD )
{
   hb_retnl( HIWORD( hb_parnl( 1 ) ) );
}

HB_FUNC( LOWORD )
{
   hb_retnl( LOWORD( hb_parnl( 1 ) ) );
}

HB_FUNC( MAKELPARAM )
{
   hb_retnl( MAKELPARAM( hb_parni( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( MAKEWPARAM )
{
   hb_retnl( MAKEWPARAM( hb_parni( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( GET_WHEEL_DELTA_WPARAM )
{
   hb_retnl( GET_WHEEL_DELTA_WPARAM( hb_parnl( 1 ) ) );
}

HB_FUNC( C_GETFOLDER )
/* Based Upon Code Contributed By Ryszard Ryüko */
{
   HWND hWnd = GetActiveWindow();
   BROWSEINFO bi;
   char * lpBuffer = (char *) hb_xgrab( MAX_PATH + 1 );
   LPITEMIDLIST pidlBrowse;    /* PIDL selected by user */

   bi.hwndOwner = hWnd;
   bi.pidlRoot = NULL;
   bi.pszDisplayName = lpBuffer;
   bi.lpszTitle = (LPCSTR) hb_parc( 1 );
   bi.ulFlags = 0;
   bi.lpfn = NULL;
   bi.lParam = 0;

   /* Browse for a folder and return its PIDL. */
   pidlBrowse = SHBrowseForFolder( &bi );
   SHGetPathFromIDList( pidlBrowse, lpBuffer );
   hb_retc( lpBuffer );
   hb_xfree( lpBuffer );
}

HB_FUNC( C_GETSPECIALFOLDER )
/* Contributed By Ryszard Ryüko */
{
   char * lpBuffer = (char *) hb_xgrab( MAX_PATH + 1 );
   LPITEMIDLIST pidlBrowse;    /* PIDL selected by user */
   SHGetSpecialFolderLocation( GetActiveWindow(), hb_parni( 1 ), &pidlBrowse );
   SHGetPathFromIDList( pidlBrowse, lpBuffer );
   hb_retc( lpBuffer );
   hb_xfree( lpBuffer );
}

typedef BOOL ( WINAPI * CALL_GLOBALMEMORYSTATUSEX )( MEMORYSTATUSEX * );

HB_FUNC( MEMORYSTATUS )          /* FUNCTION MemoryStatus() -> nValue | aValue */
{
   CALL_GLOBALMEMORYSTATUSEX fGlobalMemoryStatusEx;

   fGlobalMemoryStatusEx = (CALL_GLOBALMEMORYSTATUSEX) _OOHG_GetProcAddress( GetModuleHandle( "KERNEL32.DLL" ), "GlobalMemoryStatusEx" );
   if( fGlobalMemoryStatusEx )
   {
      MEMORYSTATUSEX mstex;

      mstex.dwLength = sizeof( mstex );

      if( fGlobalMemoryStatusEx( &mstex ) )
      {
         if( HB_ISNUM( 1 ) && hb_parni( 1 ) >= 0 && hb_parni( 1 ) <= 6 )
         {
            switch( hb_parni( 1 ) )
            {
               case 0:  HB_RETNL( mstex.dwMemoryLoad     / ( 1024 * 1024 ) ); break;
               case 1:  hb_retnll( mstex.ullTotalPhys     / ( 1024 * 1024 ) ); break;
               case 2:  hb_retnll( mstex.ullAvailPhys     / ( 1024 * 1024 ) ); break;
               case 3:  hb_retnll( mstex.ullTotalPageFile / ( 1024 * 1024 ) ); break;
               case 4:  hb_retnll( mstex.ullAvailPageFile / ( 1024 * 1024 ) ); break;
               case 5:  hb_retnll( mstex.ullTotalVirtual  / ( 1024 * 1024 ) ); break;
               case 6:  hb_retnll( mstex.ullAvailVirtual  / ( 1024 * 1024 ) ); break;
               default: HB_RETNL( 0 );
            }
         }
         else
         {
            hb_reta( 7 );
            HB_STORNL3( mstex.dwMemoryLoad     / ( 1024 * 1024 ), -1, 1 );
            HB_STORVNLL( mstex.ullTotalPhys     / ( 1024 * 1024 ), -1, 2 );
            HB_STORVNLL( mstex.ullAvailPhys     / ( 1024 * 1024 ), -1, 3 );
            HB_STORVNLL( mstex.ullTotalPageFile / ( 1024 * 1024 ), -1, 4 );
            HB_STORVNLL( mstex.ullAvailPageFile / ( 1024 * 1024 ), -1, 5 );
            HB_STORVNLL( mstex.ullTotalVirtual  / ( 1024 * 1024 ), -1, 6 );
            HB_STORVNLL( mstex.ullAvailVirtual  / ( 1024 * 1024 ), -1, 7 );
         }
      }
      else
      {
         HB_RETNL( 0 );
      }
   }
   else
   {
      MEMORYSTATUS mst;

      mst.dwLength = sizeof( MEMORYSTATUS );

      GlobalMemoryStatus( &mst );

      if( HB_ISNUM( 1 ) && hb_parni( 1 ) >= 0 && hb_parni( 1 ) <= 6 )
      {
         switch( hb_parni( 1 ) )
         {
            case 0:  HB_RETNL( mst.dwMemoryLoad    / ( 1024 * 1024 ) ); break;
            case 1:  HB_RETNL( mst.dwTotalPhys     / ( 1024 * 1024 ) ); break;
            case 2:  HB_RETNL( mst.dwAvailPhys     / ( 1024 * 1024 ) ); break;
            case 3:  HB_RETNL( mst.dwTotalPageFile / ( 1024 * 1024 ) ); break;
            case 4:  HB_RETNL( mst.dwAvailPageFile / ( 1024 * 1024 ) ); break;
            case 5:  HB_RETNL( mst.dwTotalVirtual  / ( 1024 * 1024 ) ); break;
            case 6:  HB_RETNL( mst.dwAvailVirtual  / ( 1024 * 1024 ) ); break;
            default: HB_RETNL( 0 );
         }
      }
      else
      {
         hb_reta( 7 );
         HB_STORNL3( mst.dwMemoryLoad    / ( 1024 * 1024 ), -1, 1 );
         HB_STORNL3( mst.dwTotalPhys     / ( 1024 * 1024 ), -1, 2 );
         HB_STORNL3( mst.dwAvailPhys     / ( 1024 * 1024 ), -1, 3 );
         HB_STORNL3( mst.dwTotalPageFile / ( 1024 * 1024 ), -1, 4 );
         HB_STORNL3( mst.dwAvailPageFile / ( 1024 * 1024 ), -1, 5 );
         HB_STORNL3( mst.dwTotalVirtual  / ( 1024 * 1024 ), -1, 6 );
         HB_STORNL3( mst.dwAvailVirtual  / ( 1024 * 1024 ), -1, 7 );
      }
   }
}

HB_FUNC( SHELLABOUT )
{
   ShellAbout( 0, hb_parc( 1 ), hb_parc( 2 ), HICONparam(3) );
}

HB_FUNC( PAINTBKGND )
{
   HWND hWnd;
   HBRUSH brush;
   RECT recClie;
   HDC hdc;

   hWnd = HWNDparam( 1 );
   hdc  = GetDC( hWnd );

   GetClientRect( hWnd, &recClie );

   if( ( hb_pcount() > 1 ) && ( ! HB_ISNIL( 2 ) ) )
   {
      brush = CreateSolidBrush( RGB( HB_PARNI( 2, 1 ), HB_PARNI( 2, 2 ), HB_PARNI( 2, 3 ) ) );
      FillRect( hdc, &recClie, brush );
      DeleteObject( brush );
   }
   else
   {
      brush = ( HBRUSH ) ( COLOR_BTNFACE + 1 );
      FillRect( hdc, &recClie, brush );
   }

   ReleaseDC( hWnd, hdc );
   hb_ret();
}

/* Functions Contributed By Luiz Rafael Culik Guimaraes( culikr@uol.com.br) */

HB_FUNC( GETWINDOWSDIR )
{
   char szBuffer[ MAX_PATH + 1 ] = { 0 };
   GetWindowsDirectory( szBuffer, MAX_PATH );
   hb_retc( szBuffer );
}

HB_FUNC( GETSYSTEMDIR )
{
   char szBuffer[ MAX_PATH + 1 ] = { 0 };
   GetSystemDirectory( szBuffer, MAX_PATH );
   hb_retc( szBuffer );
}

HB_FUNC( GETTEMPDIR )
{
   char szBuffer[ MAX_PATH + 1 ] = { 0 };
   GetTempPath( MAX_PATH, szBuffer );
   hb_retc( szBuffer );
}

HB_FUNC( POSTMESSAGE )
{
   hb_retl( (BOOL) PostMessage( HWNDparam( 1 ), (UINT) hb_parni( 2 ), WPARAMparam( 3 ), LPARAMparam( 4 ) ) );
}

HB_FUNC( DEFWINDOWPROC )
{
   LRESULTret( DefWindowProc( HWNDparam( 1 ), (UINT) hb_parni( 2 ), WPARAMparam( 3 ), LPARAMparam( 4 ) ) );
}

HB_FUNC( DEFFRAMEPROC )
{
   LRESULTret( DefFrameProc( HWNDparam( 1 ), HWNDparam( 2 ), (UINT) hb_parni( 3 ), WPARAMparam( 4 ), LPARAMparam( 5 ) ) );
}

HB_FUNC( DEFMDICHILDPROC )
{
   LRESULTret( DefMDIChildProc( HWNDparam( 1 ), (UINT) hb_parni( 2 ), WPARAMparam( 3 ), LPARAMparam( 4 ) ) );
}

HB_FUNC( GETSTOCKOBJECT )
{
   HGDIOBJret( GetStockObject( hb_parni( 1 ) ) );
}

HB_FUNC( SETBKMODE )
{
   hb_retni( SetBkMode( HDCparam( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( GETNEXTDLGTABITEM )
{
   HWNDret( GetNextDlgTabItem( HWNDparam( 1 ), HWNDparam( 2 ), hb_parl( 3 ) ) );
}

typedef BOOL ( WINAPI *LPFN_ISWOW64PROCESS ) ( HANDLE, PBOOL );
typedef BOOL ( WINAPI *LPFN_WOW64DISABLEWOW64FSREDIRECTION ) ( PVOID * );
typedef BOOL ( WINAPI *LPFN_WOW64REVERTWOW64FSREDIRECTION ) ( PVOID );

HB_FUNC( ISWOW64 )
{
   BOOL bIsWow64 = FALSE;
   LPFN_ISWOW64PROCESS fnIsWow64Process;

   fnIsWow64Process = ( LPFN_ISWOW64PROCESS ) _OOHG_GetProcAddress( GetModuleHandle( "kernel32" ), "IsWow64Process" );
   if( NULL != fnIsWow64Process )
   {
      fnIsWow64Process( GetCurrentProcess(), &bIsWow64 );
   }

   hb_retl( bIsWow64 );
}


HB_FUNC( SHELLEXECUTE )          /* FUNCTION ShellExecute( hwnd, cOperation, cFile, cParameters, cFolder, iShowComd ) -> nRet */
{
   LPFN_ISWOW64PROCESS fnIsWow64Process;
   BOOL bIsWow64 = FALSE;
   LPFN_WOW64DISABLEWOW64FSREDIRECTION fnDisable;
   PVOID OldValue = NULL;
   BOOL bRestore = FALSE;
   LPFN_WOW64REVERTWOW64FSREDIRECTION fnRevert;

   fnIsWow64Process = ( LPFN_ISWOW64PROCESS ) _OOHG_GetProcAddress( GetModuleHandle( "kernel32" ), "IsWow64Process" );
   if( NULL != fnIsWow64Process )
   {
      fnIsWow64Process( GetCurrentProcess(), &bIsWow64 );
   }

   if( bIsWow64 )
   {
      fnDisable = ( LPFN_WOW64DISABLEWOW64FSREDIRECTION ) _OOHG_GetProcAddress( GetModuleHandle( "kernel32" ), "Wow64DisableWow64FsRedirection" );
      if( NULL != fnDisable )
      {
         if( fnDisable( &OldValue ) )
         {
            bRestore = TRUE;
         }
      }
   }

   CoInitialize( NULL );

   HINSTANCEret( ShellExecute( HWNDparam( 1 ),
                 HB_ISNIL( 2 ) ? NULL : (LPCSTR) hb_parc( 2 ),
                 (LPCSTR) hb_parc( 3 ),
                 HB_ISNIL( 4 ) ? NULL : (LPCSTR) hb_parc( 4 ),
                 HB_ISNIL( 5 ) ? NULL : (LPCSTR) hb_parc( 5 ),
                 hb_parni( 6 ) ) );

   hb_idleSleep( 1 );

   if( bRestore )
   {
      fnRevert = ( LPFN_WOW64REVERTWOW64FSREDIRECTION ) _OOHG_GetProcAddress( GetModuleHandle( "kernel32" ), "Wow64RevertWow64FsRedirection" );
      if( NULL != fnRevert )
      {
         fnRevert( OldValue );
      }
   }
}

HB_FUNC( WAITRUN )
{

   DWORD dwExitCode;
   STARTUPINFO stInfo;
   PROCESS_INFORMATION prInfo;
   BOOL bResult;

   ZeroMemory( &stInfo, sizeof( stInfo ) );
   stInfo.cb = sizeof( stInfo );
   stInfo.dwFlags = STARTF_USESHOWWINDOW;
   stInfo.wShowWindow = (WORD) hb_parni( 2 );

   bResult = CreateProcess( NULL,
                            (LPSTR) HB_UNCONST( hb_parc( 1 ) ),
                            NULL,
                            NULL,
                            TRUE,
                            CREATE_NEW_CONSOLE | NORMAL_PRIORITY_CLASS,
                            NULL,
                            NULL,
                            &stInfo,
                            &prInfo );
   if( ! bResult )
   {
      hb_retnl( -1 );
      return ;
   }

   WaitForSingleObject( prInfo.hProcess, INFINITE );
   GetExitCodeProcess( prInfo.hProcess, &dwExitCode );

   CloseHandle( prInfo.hThread );
   CloseHandle( prInfo.hProcess );

   hb_retnl( dwExitCode );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( WAITRUNTERM )
{
   PHB_ITEM    pWaitProc  = hb_param( 4, HB_IT_BLOCK );
   ULONG       ulWaitMsec = ( HB_ISNIL( 5 ) ? 2000 : hb_parnl( 5 ) );
   BOOL        bTerm      = FALSE;
   BOOL        bWait;
   ULONG       ulNoSignal;
   DWORD       dwExitCode;
   STARTUPINFO stInfo;
   PROCESS_INFORMATION prInfo;
   BOOL bResult;

   ZeroMemory( &stInfo, sizeof( stInfo ) );
   stInfo.cb          = sizeof( stInfo );
   stInfo.dwFlags     = STARTF_USESHOWWINDOW;
   stInfo.wShowWindow = (WORD) ( HB_ISNIL( 3 ) ? 5 : hb_parni( 3 ) );

   bResult = CreateProcess( NULL,
                            (LPSTR) HB_UNCONST( hb_parc( 1 ) ),
                            NULL,
                            NULL,
                            TRUE,
                            CREATE_NEW_CONSOLE | NORMAL_PRIORITY_CLASS,
                            NULL,
                            HB_ISNIL( 2 ) ? NULL : hb_parc( 2 ),
                            &stInfo,
                            &prInfo );
   if( ! bResult )
   {
      hb_retnl( -2 );
      return;
   }

   if( pWaitProc )
   {
      do
      {
         ulNoSignal = WaitForSingleObject( prInfo.hProcess, ulWaitMsec );
         if( ulNoSignal )
         {
            hb_evalBlock0( pWaitProc );
            bWait = hb_parl( -1 );
            if( ! bWait )
            {
               if( TerminateProcess( prInfo.hProcess, 0 ) != 0 )
                  bTerm = TRUE;
               else
                  bWait = TRUE;
            }
         }
         else
            bWait = FALSE;
      }
      while( bWait );
   }
   else
      WaitForSingleObject( prInfo.hProcess, INFINITE );

   if( bTerm )
      dwExitCode = ( DWORD ) -1;
   else
      GetExitCodeProcess( prInfo.hProcess, &dwExitCode );

   CloseHandle( prInfo.hThread );
   CloseHandle( prInfo.hProcess );
   hb_retnl( dwExitCode );
}

/*
NULL means the app doesn't care if more than one instance is running
*/
static HANDLE hMutex = NULL;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ISEXERUNNING )          /* FUNCTION IsExeRunnnig( cExeNameCaseSensitive ) -> lResult */
{
   hMutex = CreateMutex( NULL, FALSE, (LPCSTR) hb_parc( 1 ) );

   hb_retl( GetLastError() == ERROR_ALREADY_EXISTS );

   if( hMutex )
   {
      ReleaseMutex( hMutex );
      hMutex = NULL;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETEXEMUTEX )          /* FUNCTION GetExeMutex() -> handle */
{
   if( hMutex )
      HANDLEret( hMutex );
   else
      hb_ret();
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CLOSEEXEMUTEX )          /* FUNCTION CloseExeMutex() -> lResult */
{
   BOOL bResult = CloseHandle( hMutex );
   hMutex = NULL;
   hb_retl( bResult );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CREATEMUTEX )          /* FUNCTION CreateMutex( cAttributes, lOwner, cName ) -> handle */
{
   SECURITY_ATTRIBUTES *sa = NULL;

   if( HB_ISCHAR( 1 ) )
   {
      sa = (SECURITY_ATTRIBUTES *) HB_UNCONST( hb_parc( 1 ) );
   }

   HANDLEret( CreateMutex( sa, hb_parl( 2 ), (LPCSTR) hb_parc( 3 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _OOHG_GETLASTERROR )
{
   hb_retnl( (long) GetLastError() );
}

HB_FUNC( CREATEFOLDER )
{
   hb_retl( CreateDirectory( (LPCTSTR) hb_parc( 1 ), NULL ) );
}

HB_FUNC( SETCURRENTFOLDER )
{
   hb_retl( SetCurrentDirectory( (LPCTSTR) hb_parc( 1 ) ) );
}

HB_FUNC( REMOVEFOLDER )
{
   hb_retl( RemoveDirectory( (LPCSTR) hb_parc( 1 ) ) );
}

HB_FUNC( GETCURRENTFOLDER )
{
   char Path[ MAX_PATH + 1 ] = { 0 };
   GetCurrentDirectory( MAX_PATH, (LPSTR) Path );
   hb_retc( Path );
}

HB_FUNC( CREATESOLIDBRUSH )
{
   HBRUSHret( CreateSolidBrush( (COLORREF) RGB( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) ) );
}

HB_FUNC( SETTEXTCOLOR )
{
   hb_retnl( (long) SetTextColor( HDCparam( 1 ), (COLORREF) RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) ) );
}

HB_FUNC( SETBKCOLOR )
{
   hb_retnl( (long) SetBkColor( HDCparam( 1 ), (COLORREF) RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) ) );
}

HB_FUNC( GETSYSCOLOR )
{
   hb_retnl( GetSysColor( hb_parni( 1 ) ) );
}

HB_FUNC( GETWINDOWLONG )
{
   HB_RETNL( GetWindowLongPtr( HWNDparam( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( GETWINDOWLONGPTR )
{
   HB_RETNL( GetWindowLongPtr( HWNDparam( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( SETWINDOWLONG )
{
   HB_RETNL( SetWindowLongPtr( HWNDparam( 1 ), hb_parni( 2 ), LONG_PTRparam( 3 ) ) );
}

HB_FUNC( SETWINDOWLONGPTR )
{
   HB_RETNL( SetWindowLongPtr( HWNDparam( 1 ), hb_parni( 2 ), LONG_PTRparam( 3 ) ) );
}

/**************************************************************************************/
/*                                                                                    */
/*  This function returns the Windows Version on which the app calling the function   */
/*  is running.                                                                       */
/*                                                                                    */
/*  The return value is an array with 4 items (strings), containing the OS in the     */
/*  first, the servicepack or the system release number in the second, the build      */
/*  number in the third and extended OS information in the fourth array element.      */
/*                                                                                    */
/**************************************************************************************/

HB_FUNC( WINVERSION )
{
   #ifndef VER_SUITE_PERSONAL
      #define VER_SUITE_PERSONAL  0x00000200
   #endif
   #ifndef VER_SUITE_BLADE
      #define VER_SUITE_BLADE     0x00000400
   #endif
   #ifndef VER_SUITE_WH_SERVER
      #define VER_SUITE_WH_SERVER 0x00008000
   #endif

   OSVERSIONINFOEX osvi;
   BOOL bOsVersionInfoEx;
   TCHAR * szVersion = NULL;
   TCHAR * szServicePack = NULL;
   TCHAR * szBuild = NULL;
   TCHAR buffer[5];
   TCHAR * szVersionEx = NULL;
#ifdef UNICODE
   LPSTR pStr;
#endif

   ZeroMemory( &osvi, sizeof( OSVERSIONINFOEX ) );
   osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFOEX );

   bOsVersionInfoEx = GetVersionEx( ( OSVERSIONINFO * ) &osvi );
   if( ! bOsVersionInfoEx )
   {
      osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
      if( ! GetVersionEx( (OSVERSIONINFO *) &osvi ) )
         szVersion = TEXT( "Unknown Operating System" );
   }

   if( szVersion == NULL )
   {
      switch( osvi.dwPlatformId )
      {
         case VER_PLATFORM_WIN32_NT:
            if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2 )
               szVersion = TEXT( "Windows Server 2003 family " );

            if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1 )
               szVersion = TEXT( "Windows XP " );

            if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0 )
               szVersion = TEXT( "Windows 2000 " );

            if( osvi.dwMajorVersion <= 4 )
               szVersion = TEXT( "Windows NT " );

            if( bOsVersionInfoEx )
            {
               if( osvi.wProductType == VER_NT_WORKSTATION )
               {
                  if( osvi.dwMajorVersion == 10 && osvi.dwBuildNumber >= 22000 )
                     szVersion = TEXT( "Windows 11 " );
                  if( osvi.dwMajorVersion == 10 && osvi.dwMinorVersion == 0 )
                     szVersion = TEXT( "Windows 10 " );
                  else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 3 )
                     szVersion = TEXT( "Windows 8.1 " );
                  else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 2 )
                     szVersion = TEXT( "Windows 8 " );
                  else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 1 )
                     szVersion = TEXT( "Windows 7 " );
                  else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0 )
                     szVersion = TEXT( "Windows Vista " );

                  if( osvi.dwMajorVersion == 4 )
                     szVersionEx = TEXT( "Workstation 4.0 " );
                  else if( osvi.wSuiteMask & VER_SUITE_PERSONAL )
                     szVersionEx = TEXT( "Home Edition " );
                  else
                     szVersionEx = TEXT( "Professional " );
               }
               else if( osvi.wProductType == VER_NT_SERVER )
               {
                  if( osvi.dwMajorVersion == 10 && osvi.dwMinorVersion == 0 )
                     szVersion = TEXT( "Windows Server 2016 " );
                  else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 3 )
                     szVersion = TEXT( "Windows Server 2012 R2 " );
                  else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 2 )
                     szVersion = TEXT( "Windows Server 2012 " );
                  else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 1 )
                     szVersion = TEXT( "Windows Server 2008 R2 " );
                  else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0 )
                     szVersion = TEXT( "Windows Server 2008 " );
                  else if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2 )
                  {
                     if( osvi.wSuiteMask & VER_SUITE_DATACENTER )
                        szVersionEx = TEXT( "Datacenter Edition " );
                     else if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                        szVersionEx = TEXT( "Enterprise Edition " );
                     else if( osvi.wSuiteMask & VER_SUITE_BLADE )
                        szVersionEx = TEXT( "Web Edition " );
                     else
                        szVersionEx = TEXT( "Standard Edition " );
                  }
                  else if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0 )
                  {
                     if( osvi.wSuiteMask & VER_SUITE_DATACENTER )
                        szVersionEx = TEXT( "Datacenter Server " );
                     else if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                        szVersionEx = TEXT( "Advanced Server " );
                     else
                        szVersionEx = TEXT( "Server " );
                  }
                  else
                  {
                     if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                        szVersionEx = TEXT( "Server 4.0, Enterprise Edition " );
                     else
                        szVersionEx = TEXT( "Server 4.0 " );
                  }
               }
            }
            else
            {
               HKEY hKey;
               TCHAR szProductType[80];
               DWORD dwBufLen = 80;
               LONG lRetVal;

               lRetVal = RegOpenKeyEx( HKEY_LOCAL_MACHINE, 
                                       TEXT( "SYSTEM\\CurrentControlSet\\Control\\ProductOptions" ), 
                                       0, 
                                       KEY_QUERY_VALUE, 
                                       &hKey );

               if( lRetVal != ERROR_SUCCESS )
                  szVersion = TEXT( "Unknown Operating System" );
               else
               {
                  lRetVal = RegQueryValueEx( hKey, 
                                             TEXT( "ProductType" ), 
                                             NULL, 
                                             NULL, 
                                             (LPBYTE) szProductType, 
                                             &dwBufLen );
                  if( ( lRetVal != ERROR_SUCCESS ) || ( dwBufLen > 80 ) )
                     szVersion = TEXT( "Unknown Operating System" );
               }

               RegCloseKey( hKey );

               if( lstrcmpi( TEXT( "Unknown Operating System" ), szVersion ) != 0 )
               {
                  if( lstrcmpi( TEXT( "WINNT" ), szProductType ) == 0 )
                     szVersionEx = TEXT( "Workstation " );

                  if( lstrcmpi( TEXT( "LANMANNT" ), szProductType ) == 0 )
                     szVersionEx = TEXT( "Server " );

                  if( lstrcmpi( TEXT( "SERVERNT" ), szProductType ) == 0 )
                     szVersionEx = TEXT( "Advanced Server " );

                  szVersion = lstrcat( szVersion, _OOHG_ULTOA( osvi.dwMajorVersion, buffer, 10 ) );
                  szVersion = lstrcat( szVersion, TEXT( "." ) );
                  szVersion = lstrcat( szVersion, _OOHG_ULTOA( osvi.dwMinorVersion, buffer, 10 ) );
               }
            }

            if( osvi.dwMajorVersion == 4 && lstrcmpi( osvi.szCSDVersion, TEXT( "Service Pack 6" ) ) == 0 )
            {
               HKEY hKey;
               LONG lRetVal;

               lRetVal = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
                                       TEXT( "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Hotfix\\Q246009" ),
                                       0,
                                       KEY_QUERY_VALUE,
                                       &hKey );

               if( lRetVal == ERROR_SUCCESS )
               {
                  szServicePack = TEXT( "Service Pack 6a" );
                  szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0xFFFF, buffer, 10 );
               }
               else
               {
                  szServicePack = osvi.szCSDVersion;
                  szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0xFFFF, buffer, 10 );
               }

               RegCloseKey( hKey );
            }
            else
            {
               szServicePack = osvi.szCSDVersion;
               szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0xFFFF, buffer, 10 );
            }

            break;

         case VER_PLATFORM_WIN32_WINDOWS:
            if( ( osvi.dwMajorVersion == 4 ) && ( osvi.dwMinorVersion == 0 ) )
            {
               if( osvi.szCSDVersion[1] == TEXT( 'B' ) )
               {
                  szVersion = TEXT( "Windows 95 B" );
                  szServicePack = TEXT( "OSR2" );
               }
               else
               {
                  if( osvi.szCSDVersion[1] == TEXT( 'C' ) )
                  {
                     szVersion = TEXT( "Windows 95 C" );
                     szServicePack = TEXT( "OSR2" );
                  }
                  else
                  {
                     szVersion = TEXT( "Windows 95" );
                     szServicePack = TEXT( "OSR1" );
                  }
               }

               szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }

            if( ( osvi.dwMajorVersion == 4 ) && ( osvi.dwMinorVersion == 10 ) )
            {
               if( osvi.szCSDVersion[1] == 'A' )
               {
                  szVersion = TEXT( "Windows 98 A" );
                  szServicePack = TEXT( "Second Edition" );
               }
               else
               {
                  szVersion = TEXT( "Windows 98" );
                  szServicePack = TEXT( "First Edition" );
               }

               szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }

            if( ( osvi.dwMajorVersion == 4 ) && ( osvi.dwMinorVersion == 90 ) )
            {
               szVersion = TEXT( "Windows ME" );
               szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }

            break;
      }
   }

   hb_reta( 4 );
#ifndef UNICODE
   HB_STORC( szVersion, -1, 1 );
   HB_STORC( szServicePack, -1, 2 );
   HB_STORC( szBuild, -1, 3 );
   HB_STORC( szVersionEx, -1, 4 );
#else
   pStr = WideToAnsi( szVersion );
   HB_STORC( pStr, -1, 1 );
   hb_xfree( pStr );
   pStr = WideToAnsi( szServicePack );
   HB_STORC( pStr, -1, 2 );
   hb_xfree( pStr );
   pStr = WideToAnsi( szBuild );
   HB_STORC( pStr, -1, 3 );
   hb_xfree( pStr );
   pStr = WideToAnsi( szVersionEx );
   HB_STORC( pStr, -1, 4 );
   hb_xfree( pStr );
#endif
}

#if defined( __XHARBOUR__ )

HB_FUNC( ISEXE64 )
{
   hb_retl( ( sizeof( void * ) == 8 ) );
}

#endif

HB_FUNC( SETWINDOWPOS )
{
   hb_retl( SetWindowPos( HWNDparam( 1 ), HWNDparam( 2 ), hb_parni( 4 ), hb_parni( 3 ), hb_parni( 5 ), hb_parni( 6 ), (UINT) hb_parni( 7 ) ) );
}

HB_FUNC( GETCOMPUTERNAME )
{
   TCHAR lpBuffer[ 129 ];
   DWORD nSize = 128;
   GetComputerName( lpBuffer, &nSize );
   hb_retc( lpBuffer );
}

HB_FUNC( GETUSERNAME )
{
   TCHAR lpBuffer[ UNLEN + 1 ];
   DWORD nSize = UNLEN;
   GetUserName( lpBuffer, &nSize );
   hb_retc( lpBuffer );
}

static HMODULE hDllShlWAPI = NULL;

void _ShlWAPI_DeInit( void )
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllShlWAPI )
   {
      FreeLibrary( hDllShlWAPI );
      hDllShlWAPI = NULL;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );
}

typedef BOOL ( WINAPI * CALL_PATHCOMPACTPATHEXA )( LPTSTR pszOut, LPTSTR pszSrc, int cchMax, DWORD dwFlags );

static CALL_PATHCOMPACTPATHEXA fPathCompactPathExA = NULL;

HB_FUNC( GETCOMPACTPATH )
{
   BOOL bRet = FALSE;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllShlWAPI == NULL )
   {
      hDllShlWAPI = LoadLibrary( "SHLWAPI.DLL" );
   }
   if( hDllShlWAPI != NULL )
   {
      if( fPathCompactPathExA == NULL )
      {
         fPathCompactPathExA = (CALL_PATHCOMPACTPATHEXA) _OOHG_GetProcAddress( hDllShlWAPI, "PathCompactPathExA" );
      }
      if( fPathCompactPathExA != NULL )
      {
         bRet = fPathCompactPathExA( (LPTSTR) HB_UNCONST( hb_parc( 1 ) ), (LPTSTR) HB_UNCONST( hb_parc( 2 ) ), (int) hb_parni( 3 ), ( DWORD ) hb_parnl( 4 ) );
      }
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   hb_retl( bRet ) ;
}

HB_FUNC( GETSHORTPATHNAME )
/* Jacek Kubica <kubica@wssk.wroc.pl> HMG 1.1 Experimental Build 11a */
{
   char buffer[ MAX_PATH + 1 ] = { 0 };
   DWORD iRet;

   iRet = GetShortPathName( hb_parc( 1 ), buffer, MAX_PATH );
   if( iRet < MAX_PATH )
   {
      hb_storclen( buffer, iRet, 2);
   }
   else
   {
      hb_storc( "", 2 );
   }
   hb_retni( (int) iRet );
}

/* szWide must be freed by the caller */
LPWSTR AnsiToWide( const char * szString )
{
   int iLen;
   LPWSTR szWide;

   iLen = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, szString, -1, NULL, 0 );
   szWide = (LPWSTR) hb_xgrab( ( (UINT) iLen ) * sizeof( WCHAR ) );
   MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, szString, -1, szWide, iLen );
   return szWide;
}

HB_FUNC( CLOSEHANDLE )
{
   CloseHandle( HANDLEparam( 1 ) );
}

typedef HRESULT ( WINAPI * CALL_STRRETTOBUFA )( STRRET *, LPCITEMIDLIST, LPTSTR, UINT );

static CALL_STRRETTOBUFA fStrRetToBufA = NULL;

HRESULT WINAPI win_StrRetToBuf( STRRET *pstr, LPCITEMIDLIST pidl, LPTSTR pszBuf, UINT cchBuf )
{
   HRESULT hRet = ( HRESULT ) -1;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllShlWAPI == NULL )
   {
   hDllShlWAPI = LoadLibrary( "SHLWAPI.DLL" );
   }
   if( hDllShlWAPI != NULL )
   {
      if( fStrRetToBufA == NULL )
      {
         fStrRetToBufA = (CALL_STRRETTOBUFA) _OOHG_GetProcAddress( hDllShlWAPI, "StrRetToBufA" );
      }
      if( fStrRetToBufA != NULL )
      {
         hRet = ( fStrRetToBufA ) ( pstr, pidl, pszBuf, cchBuf );
      }
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return hRet;
}

TCHAR * _LocalDateTimeToDateTimeANSI( TCHAR *cLocalDateTime )
{
   int           i;
   TCHAR         cDateFormat[ 80 ];
   TCHAR         Year[ 12 ], Month[ 12 ], Day[ 12 ], Time[ 24 ];
   TCHAR         *p2 = cLocalDateTime;
   TCHAR         *p;

   GetLocaleInfo( LOCALE_USER_DEFAULT, LOCALE_SSHORTDATE, cDateFormat, sizeof( cDateFormat ) / sizeof( TCHAR ) );
   p = (TCHAR*) &cDateFormat;

   ZeroMemory( Year,  sizeof( Year ) );
   ZeroMemory( Month, sizeof( Month ) );
   ZeroMemory( Day,   sizeof( Day ) );

   while( *p != 0 )
   {
      if( ( *p == _TEXT( 'y' ) || *p == _TEXT( 'Y' ) ) && ( Year[ 0 ] == 0 ) )
      {
         i = 0;
         while( _istdigit( *p2 ) )
            Year[ i ++ ] = *p2 ++;
         while( ! _istdigit( *p2 ) )
            p2 ++;
      }
      if( ( *p == _TEXT( 'm' ) || *p == _TEXT( 'M' ) ) && ( Month[ 0 ] == 0 ) )
      {
         i = 0;
         while( _istdigit( *p2 ) )
            Month[ i ++ ] = *p2 ++;
         while( ! _istdigit( *p2 ) )
            p2 ++;
      }
      if( ( *p == _TEXT( 'd' ) || *p == _TEXT( 'D' ) ) && ( Day[ 0 ] == 0 ) )
      {
         i = 0;
         while( _istdigit( *p2 ) )
            Day[ i ++ ] = *p2 ++;
         while( ! _istdigit( *p2 ) )
            p2 ++;
      }
      p ++;
   }
   if( lstrlen( Month ) == 1 )
   {
      Month[ 1 ] = Month[ 0 ];
      Month[ 0 ] = _TEXT( '0' );
   }
   if( lstrlen( Day ) == 1 )
   {
      Day[ 1 ] = Day[ 0 ];
      Day[ 0 ] = _TEXT( '0' );
   }
   lstrcpy( Time, p2 );
   wsprintf( cLocalDateTime, _TEXT( "%s/%s/%s  %s" ), Year, Month, Day, Time );
   return cLocalDateTime;
}

TCHAR * _SpaceToBlank( TCHAR *cStr )
{
   TCHAR *p = cStr;

   while( *p != 0 )
   {
      if( _istspace( *p ) )   /* space character (0x09, 0x0D or 0x20) */
         *p = _TEXT( ' ' );
      p ++;
   }

   return cStr;
}

#define DIRECTORYINFO_NAME                      1
#define DIRECTORYINFO_DATE                      2
#define DIRECTORYINFO_TYPE                      3
#define DIRECTORYINFO_SIZE                      4
#define DIRECTORYINFO_FULLNAME                  5
#define DIRECTORYINFO_INTERNALDATA_TYPE         6
#define DIRECTORYINFO_INTERNALDATA_DATE         7
#define DIRECTORYINFO_INTERNALDATA_IMAGEINDEX   8
#define DIRECTORYINFO_INTERNALDATA_FOLDER       "D-"
#define DIRECTORYINFO_INTERNALDATA_HASSUBFOLDER "D+"
#define DIRECTORYINFO_INTERNALDATA_NOFOLDER     "F"
#define DIRECTORYINFO_INFOROOT                  -1
#define DIRECTORYINFO_LISTALL                   0
#define DIRECTORYINFO_LISTFOLDER                1
#define DIRECTORYINFO_LISTNONFOLDER             2

#ifndef SFGAO_STREAM
   #define SFGAO_STREAM 0x00400000
#endif
#ifndef SFGAO_ISSLOW
   #define SFGAO_ISSLOW 0x00004000
#endif

HB_FUNC( DIRECTORYINFO )          /* FUNCTION DirectoryInfo( [ nCSIDL | cPath], [nTypeList], @nIndexRoot, @CSIDL_Name ) --> { { Data1, ... }, ... } */
{
   LPITEMIDLIST  pidlFolders = NULL;
   LPITEMIDLIST  pidlItems = NULL;
   IShellFolder2 *psfFolders = NULL;
   IShellFolder  *psfDeskTop = NULL;
   LPENUMIDLIST  ppenum = NULL;
   ULONG         celtFetched, chEaten, uAttr;
   STRRET        strDispName;
   DWORD         nFlags;
   BOOL          Found_Ok;
   TCHAR         cDisplayData[ MAX_PATH ];
   TCHAR         cFullPath[ MAX_PATH ];
   TCHAR         cDateTime[ 80 ];
   TCHAR         cInternalType[ 33 ];
   SHELLDETAILS  psd;
   SHFILEINFO    psfi;
   int           nCSIDL;
   PHB_ITEM      pArray, pSubarray;
   LPCITEMIDLIST *apidl;

   CoInitialize( NULL );

   if( SHGetDesktopFolder( &psfDeskTop ) != S_OK )
      return;

   if( HB_ISCHAR( 1 ) )
   {
      const TCHAR *cPath = hb_parc( 1 );
      if( IShellFolder2_ParseDisplayName( psfDeskTop, NULL, NULL, hb_mbtowc( cPath ), &chEaten, &pidlFolders, NULL ) != S_OK )
         return;
   }
   else
   {
      nCSIDL = HB_ISNUM( 1 ) ? hb_parni( 1 ) : CSIDL_DRIVES;
      if( SHGetFolderLocation( NULL, nCSIDL, NULL, 0, &pidlFolders ) != S_OK )
         return;

      if( HB_ISBYREF( 4 ) )
      {
         TCHAR cParsingName[ MAX_PATH ] = { 0 };
         IShellFolder2_GetDisplayNameOf( psfDeskTop, pidlFolders, SHGDN_INFOLDER, &strDispName );
         win_StrRetToBuf( &strDispName, pidlItems, cParsingName, MAX_PATH );
         hb_storc( cParsingName, 4 );
      }
   }

   if( HB_ISBYREF( 3 ) )
   {
      SHGetFileInfo( (LPCTSTR) pidlFolders, 0, &psfi, sizeof( SHFILEINFO ), SHGFI_PIDL | SHGFI_SYSICONINDEX );
      hb_storni( psfi.iIcon, 3 );
   }

   switch( hb_parni( 2 ) )
   {
      case DIRECTORYINFO_LISTFOLDER:
         nFlags = SHCONTF_FOLDERS;
         break;

      case DIRECTORYINFO_LISTNONFOLDER:
         nFlags = SHCONTF_NONFOLDERS;
         break;

      default:
         nFlags = SHCONTF_FOLDERS | SHCONTF_NONFOLDERS;
   }

   if( IShellFolder2_BindToObject( psfDeskTop, pidlFolders, NULL, &IID_IShellFolder2, (LPVOID *) &psfFolders ) != S_OK || hb_parni( 2 ) == DIRECTORYINFO_INFOROOT )
   {
      if( pidlFolders )
         CoTaskMemFree( pidlFolders );
      IShellFolder2_Release( psfDeskTop );
      return;
   }

   IShellFolder2_Release( psfDeskTop );

   if( IShellFolder2_EnumObjects( psfFolders, NULL, nFlags, &ppenum ) != S_OK)
      return;

   pArray = hb_itemArrayNew( 0 );
   pSubarray = hb_itemNew( NULL );

   while( ( IEnumIDList_Next( ppenum, 1, &pidlItems, &celtFetched ) == S_OK ) && ( celtFetched == 1 ) )
   {
      Found_Ok = FALSE;

      uAttr = SFGAO_FOLDER | SFGAO_STREAM | SFGAO_ISSLOW;
      apidl = ( LPCITEMIDLIST * ) ( const LPITEMIDLIST ) &pidlItems;
      if( IShellFolder2_GetAttributesOf( psfFolders, 1, apidl, &uAttr ) != S_OK )
         break;

      if( ( nFlags & SHCONTF_FOLDERS ) && ( uAttr & SFGAO_FOLDER ) && ! ( uAttr & SFGAO_STREAM ) && ! ( uAttr & SFGAO_ISSLOW ) )
      {
         uAttr = SFGAO_HASSUBFOLDER;
         IShellFolder2_GetAttributesOf( psfFolders, 1, apidl, &uAttr );
         if( uAttr & SFGAO_HASSUBFOLDER )
            lstrcpy( cInternalType, _TEXT( DIRECTORYINFO_INTERNALDATA_HASSUBFOLDER ) );    /* Folder with Sub-Folder */
         else
            lstrcpy( cInternalType, _TEXT( DIRECTORYINFO_INTERNALDATA_FOLDER ) );    /* Folder without Sub-Folder */
         Found_Ok = TRUE;
      }
      else if( nFlags & SHCONTF_NONFOLDERS )
      {
         lstrcpy( cInternalType, _TEXT( DIRECTORYINFO_INTERNALDATA_NOFOLDER ) );    /* File */
         Found_Ok = TRUE;
      }

      if( Found_Ok )
      {
         hb_arrayNew( pSubarray, 8 );

         IShellFolder2_GetDetailsOf( psfFolders, pidlItems, 0, &psd );    /* Name */
         win_StrRetToBuf( &psd.str, pidlItems, cDisplayData, MAX_PATH );
         hb_arraySetC( pSubarray, DIRECTORYINFO_NAME, cDisplayData );

         IShellFolder2_GetDetailsOf( psfFolders, pidlItems, 3, &psd );    /* Date */
         win_StrRetToBuf( &psd.str, pidlItems, cDisplayData, MAX_PATH );
         hb_arraySetC( pSubarray, DIRECTORYINFO_DATE, _SpaceToBlank( cDisplayData ) );
         lstrcpy( cDateTime, cDisplayData );

         IShellFolder2_GetDetailsOf( psfFolders, pidlItems, 2, &psd );    /* Type */
         win_StrRetToBuf( &psd.str, pidlItems, cDisplayData, MAX_PATH );
         hb_arraySetC( pSubarray, DIRECTORYINFO_TYPE, _SpaceToBlank( cDisplayData ) );

         IShellFolder2_GetDetailsOf( psfFolders, pidlItems, 1, &psd );    /* Size */
         win_StrRetToBuf( &psd.str, pidlItems, cDisplayData, MAX_PATH );
         hb_arraySetC( pSubarray, DIRECTORYINFO_SIZE, _SpaceToBlank( cDisplayData ) );

         IShellFolder2_GetDisplayNameOf( psfFolders, pidlItems, SHGDN_FORPARSING, &strDispName );    /* FullName */
         win_StrRetToBuf( &strDispName, pidlItems, cFullPath, MAX_PATH );
         hb_arraySetC( pSubarray, DIRECTORYINFO_FULLNAME, cFullPath );

         hb_arraySetC( pSubarray, DIRECTORYINFO_INTERNALDATA_TYPE, cInternalType );    /* D+ | D- | F */

         _LocalDateTimeToDateTimeANSI( cDateTime );
         hb_arraySetC( pSubarray, DIRECTORYINFO_INTERNALDATA_DATE, cDateTime );    /* YYYY:MM:DD  HH:MM:SS */

         SHGetFileInfo( (LPCTSTR) cFullPath, 0, &psfi, sizeof( SHFILEINFO ), SHGFI_SYSICONINDEX );
         hb_arraySetNI( pSubarray, DIRECTORYINFO_INTERNALDATA_IMAGEINDEX, (int) psfi.iIcon );    /* nImageIndex */

         hb_arrayAddForward( pArray, pSubarray );
      }
      CoTaskMemFree( pidlItems );
   }
   IEnumIDList_Release( ppenum );

   CoTaskMemFree( pidlFolders );
   IShellFolder2_Release( psfFolders );

   hb_itemReturnRelease( pArray );
   hb_itemRelease( pSubarray );
}

int GetGDIObjects( DWORD nProcessId )
{
   HANDLE hProcess;
   DWORD gdi = 0;

   nProcessId = nProcessId ? nProcessId : GetCurrentProcessId();
   hProcess = OpenProcess( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, nProcessId );

   if( hProcess )
   {
      gdi = GetGuiResources( hProcess, GR_GDIOBJECTS );
      CloseHandle( hProcess );
   }
   return gdi;
}

int GetUserObjects( DWORD nProcessId )
{
   HANDLE hProcess;
   DWORD user = 0;

   nProcessId = nProcessId ? nProcessId : GetCurrentProcessId();
   hProcess = OpenProcess( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, nProcessId );

   if( hProcess )
   {
      user = GetGuiResources( hProcess, GR_USEROBJECTS );
      CloseHandle( hProcess );
   }
   return user;
}

#if ( ( ! defined(__BORLANDC__) ) || (__TURBOC__ > 0x0551) )

int GetKernelObjects( DWORD nProcessId )
{
   HANDLE hProcess;
   DWORD kernel = 0;

   nProcessId = nProcessId ? nProcessId : GetCurrentProcessId();
   hProcess = OpenProcess( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, nProcessId );

   if( hProcess )
   {
      GetProcessHandleCount( hProcess, &kernel );
      CloseHandle( hProcess );
   }
   return kernel;
}

HB_FUNC( GETOBJECTCOUNT )          /* GetObjectCount( [ nProcessId ] ) -> { nGDIObjects, nUserObjects, nKernelObjects } */
/*
 * GDI Objects: https://docs.microsoft.com/es-es/windows/win32/sysinfo/gdi-objects
 * User Objects: https://docs.microsoft.com/es-es/windows/win32/sysinfo/user-objects
 * Kernel Objects: https://docs.microsoft.com/es-es/windows/win32/sysinfo/kernel-objects
 */
{
   DWORD nProcessId;
   HANDLE hProcess;
   DWORD gdi, user, kernel;

   nProcessId = HB_ISNUM( 1 ) ? ( DWORD ) hb_parnl( 1 ) : GetCurrentProcessId();
   hProcess = OpenProcess( PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, nProcessId );

   if( hProcess )
   {
      gdi = GetGuiResources( hProcess, GR_GDIOBJECTS );
      user = GetGuiResources( hProcess, GR_USEROBJECTS );
      GetProcessHandleCount( hProcess, &kernel );

      CloseHandle( hProcess );

      hb_reta(3);
      HB_STORNI( (int) gdi, -1, 1 );
      HB_STORNI( (int) user, -1, 2 );
      HB_STORNI( (int) kernel, -1, 3 );
   }
}

#endif

static HMODULE hDllProcess = NULL;

void _ProcessLib_DeInit( void )
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllProcess )
   {
      FreeLibrary( hDllProcess );
      hDllProcess = NULL;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );
}

#ifndef PROCESS_QUERY_LIMITED_INFORMATION
   #define PROCESS_QUERY_LIMITED_INFORMATION 0x1000
#endif

typedef BOOL ( WINAPI * CALL_EMPTYWORKINGSET )( HANDLE );

static CALL_EMPTYWORKINGSET fEmptyWorkingSet = NULL;

HB_FUNC( EMPTYWORKINGSET )          /* FUNCTION EmptyWorkingSet( [ ProcessID ] ) -> lSuccess */
{
   /*
    * It removes as many pages as possible from the process working set (clean the working set memory).
    * This operation is useful primarily for testing and tuning.
    */
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( fEmptyWorkingSet == NULL )
   {
      if( hDllProcess == NULL )
      {
         hDllProcess = LoadLibrary( "KERNEL32.DLL" );
         if( hDllProcess == NULL )
         {
            hDllProcess = LoadLibrary( "PSAPI.DLL" );
         }
      }
      if( hDllProcess != NULL )
      {
         fEmptyWorkingSet = (CALL_EMPTYWORKINGSET) _OOHG_GetProcAddress( hDllProcess, "K32EmptyWorkingSet" );
      }
   }
   if( ( hDllProcess != NULL ) && ( fEmptyWorkingSet == NULL ) )
   {
      fEmptyWorkingSet = (CALL_EMPTYWORKINGSET) _OOHG_GetProcAddress( hDllProcess, "EmptyWorkingSet" );
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   if( fEmptyWorkingSet == NULL )
   {
      hb_retl( FALSE );
   }
   else
   {
      DWORD ProcessID = HB_ISNUM( 1 ) ? ( DWORD ) hb_parnl( 1 ) : GetCurrentProcessId();
      HANDLE hProcess = OpenProcess( PROCESS_QUERY_LIMITED_INFORMATION | PROCESS_SET_QUOTA, FALSE, ProcessID );

      if( hProcess == NULL )
      {
         hb_ret();
      }
      else
      {
         hb_retl( fEmptyWorkingSet( hProcess ) );
         CloseHandle( hProcess );
      }
   }
}

static HMODULE hDllUser32 = NULL;

void _User32_DeInit( void )
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllUser32 )
   {
      FreeLibrary( hDllUser32 );
      hDllUser32 = NULL;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );
}

typedef BOOL ( WINAPI * CALL_CHANGEWINDOWMESSAGEFILTER )( UINT message, DWORD dwFlag );
static CALL_CHANGEWINDOWMESSAGEFILTER fChangeWindowMessageFilter = NULL;

BOOL _OOHG_ChangeWindowMessageFilter( UINT message, DWORD dwFlag )
{
   BOOL bRet = FALSE;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllUser32 == NULL )
   {
      hDllUser32 = LoadLibrary( "USER32.DLL" );
      if( hDllUser32 != NULL )
      {
         fChangeWindowMessageFilter = (CALL_CHANGEWINDOWMESSAGEFILTER) _OOHG_GetProcAddress( hDllUser32, "ChangeWindowMessageFilter" );
      }
   }
   if( fChangeWindowMessageFilter != NULL )
   {
      bRet = fChangeWindowMessageFilter( message, dwFlag );
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return bRet;
}

typedef int ( WINAPI * CALL_MESSAGEBOXTIMEOUT )( HWND, LPCSTR, LPCSTR, UINT, WORD, DWORD );
static CALL_MESSAGEBOXTIMEOUT fMessageBoxTimeout = NULL;

int WINAPI MessageBoxTimeout( HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType, WORD wLanguageId, DWORD dwMilliseconds )
{
   int iRet;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllUser32 == NULL )
   {
      hDllUser32 = LoadLibrary( "USER32.DLL" );
      if( hDllUser32 != NULL )
      {
         fMessageBoxTimeout = (CALL_MESSAGEBOXTIMEOUT) _OOHG_GetProcAddress( hDllUser32, "MessageBoxTimeoutA" );
      }
   }
   if( fMessageBoxTimeout == NULL )
   {
      iRet = 0;
   }
   else
   {
      iRet = fMessageBoxTimeout( hWnd, lpText, lpCaption, uType, wLanguageId, dwMilliseconds );
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return iRet;
}

/*
 * The SetLayeredWindowAttributes function sets the opacity and transparency
 * color key of a layered window.
 * Parameters:
 * - hWnd   Handle to the layered window.
 * - crKey   Pointer to a COLORREF value that specifies the transparency color
 *   key to be used.
 *    (When making a certain color transparent...).
 * - bAlpha   Alpha value used to describe the opacity of the layered window.
 *    0 = Invisible, 255 = Fully visible
 * - dwFlags   Specifies an action to take. This parameter can be LWA_COLORKEY
 *    (When making a certain color transparent...) or LWA_ALPHA.
 */

#if ! ( defined ( __MINGW32__ ) && ! defined ( __MINGW32_VERSION ) )
   typedef BOOL ( WINAPI * CALL_SETLAYEREDWINDOWATTRIBUTES )( HWND, COLORREF, BYTE, DWORD );
   static CALL_SETLAYEREDWINDOWATTRIBUTES fSetLayeredWindowAttributes = NULL;
#endif

HB_FUNC( SETLAYEREDWINDOWATTRIBUTES )          /* FUNCTION SetLayeredWindowAttributes( hWnd, color, opacity, [ LWA_COLORKEY | LWA_ALPHA ] ) -> lSuccess */
{
   HWND hWnd = HWNDparam( 1 );
   COLORREF crKey = (COLORREF) hb_parnl( 2 );
   BYTE bAlpha = (BYTE) hb_parni( 3 );
   DWORD dwFlags = ( DWORD ) hb_parnl( 4 );

#if defined ( __MINGW32__ ) && ! defined ( __MINGW32_VERSION )
   if( ! ( GetWindowLongPtr( hWnd, GWL_EXSTYLE ) & WS_EX_LAYERED ) )
   {
      SetWindowLongPtr( hWnd, GWL_EXSTYLE, ( GetWindowLongPtr( hWnd, GWL_EXSTYLE ) | WS_EX_LAYERED ) );
   }

   hb_retl( SetLayeredWindowAttributes( hWnd, crKey, bAlpha, dwFlags ) );
#else
   BOOL bRet;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllUser32 == NULL )
   {
      hDllUser32 = LoadLibrary( "USER32.DLL" );
   }
   if( hDllUser32 == NULL )
   {
      bRet = FALSE;
   }
   else
   {
      if( fSetLayeredWindowAttributes == NULL )
      {
         fSetLayeredWindowAttributes = (CALL_SETLAYEREDWINDOWATTRIBUTES) GetProcAddress( hDllUser32, "SetLayeredWindowAttributes" );
      }
      if( fSetLayeredWindowAttributes == NULL )
      {
         bRet = FALSE;
      }
      else
      {
         SetWindowLongPtr( hWnd, GWL_EXSTYLE, GetWindowLongPtr( hWnd, GWL_EXSTYLE ) | WS_EX_LAYERED );
         bRet = ( fSetLayeredWindowAttributes )( hWnd, crKey, bAlpha, dwFlags );
      }
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   hb_retl( bRet );
#endif
}

static HMODULE hDllComctl32 = NULL;

/*--------------------------------------------------------------------------------------------------------------------------------*/
void _ComCtl32_DeInit( void )
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllComctl32 )
   {
      FreeLibrary( hDllComctl32 );
      hDllComctl32 = NULL;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );
}

typedef HRESULT ( WINAPI * CALL_DLLGETVERSION )( DLLVERSIONINFO * );

static CALL_DLLGETVERSION fDllGetVersion = NULL;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETCOMCTL32VERSION )          /* FUNCTION GetComCtl32Version() -> nVersion */
{
   int iResult = 0;
   DLLVERSIONINFO dll;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllComctl32 == NULL )
   {
      hDllComctl32 = LoadLibrary( "COMCTL32.DLL" );
   }
   if( hDllComctl32 != NULL )
   {
      if( fDllGetVersion == NULL )
      {
         fDllGetVersion = (CALL_DLLGETVERSION) _OOHG_GetProcAddress( hDllComctl32, "DllGetVersion" );
      }
      if( fDllGetVersion != NULL )
      {
         memset( &dll, 0, sizeof( dll ) );
         dll.cbSize = sizeof( dll );
         if( ( fDllGetVersion )( &dll ) == S_OK )
         {
            iResult = dll.dwMajorVersion;
         }
      }
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   hb_retni( iResult );
}

typedef HRESULT ( WINAPI * CALL_CLOSETHEMEDATA ) ( HTHEME );
typedef HRESULT ( WINAPI * CALL_DRAWTHEMEBACKGROUND ) ( HTHEME, HDC, int, int, LPCRECT, LPCRECT );
typedef HRESULT ( WINAPI * CALL_DRAWTHEMEPARENTBACKGROUND ) ( HWND, HDC, LPCRECT );
typedef HRESULT ( WINAPI * CALL_DRAWTHEMETEXTEX ) ( HTHEME, HDC, int, int, LPCWSTR, int, DWORD, LPCRECT, const DTTOPTS * );
typedef HRESULT ( WINAPI * CALL_DRAWTHEMETEXT ) ( HTHEME, HDC, int, int, LPCWSTR, int, DWORD, DWORD, LPCRECT );
typedef HRESULT ( WINAPI * CALL_GETTHEMEBACKGROUNDCONTENTRECT ) ( HTHEME, HDC, int, int, LPCRECT, LPRECT );
typedef HRESULT ( WINAPI * CALL_GETTHEMEMARGINS ) ( HTHEME, HDC, int, int, int, LPCRECT, MARGINS * );
typedef HRESULT ( WINAPI * CALL_GETTHEMEPARTSIZE ) ( HTHEME, HDC, int, int, LPCRECT, THEMESIZE, SIZE * );
typedef HRESULT ( WINAPI * CALL_GETTHEMETEXTEXTENT ) ( HTHEME, HDC, int, int, LPCWSTR, int, DWORD, LPCRECT, LPRECT );
typedef HRESULT ( WINAPI * CALL_GETTHEMETEXTMETRICS ) ( HTHEME, HDC, int, int, TEXTMETRICW * );
typedef BOOL    ( WINAPI * CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT ) ( HTHEME, int, int );
typedef HTHEME  ( WINAPI * CALL_OPENTHEMEDATA ) ( HWND, LPCWSTR );
typedef HRESULT ( WINAPI * CALL_SETWINDOWTHEME ) ( HWND, LPCWSTR, LPCWSTR );
typedef BOOL    ( WINAPI * CALL_ISTHEMEACTIVE ) ( VOID );
typedef BOOL    ( WINAPI * CALL_ISAPPTHEMED ) ( VOID );

static HMODULE hDllUxTheme = NULL;
static CALL_CLOSETHEMEDATA pProcCloseThemeData = NULL;
static CALL_DRAWTHEMEBACKGROUND pProcDrawThemeBackground = NULL;
static CALL_DRAWTHEMEPARENTBACKGROUND pProcDrawThemeParentBackground = NULL;
static CALL_DRAWTHEMETEXT pProcDrawThemeText = NULL;
static CALL_DRAWTHEMETEXTEX pProcDrawThemeTextEx = NULL;
static CALL_GETTHEMEBACKGROUNDCONTENTRECT pProcGetThemeBackgroundContentRect = NULL;
static CALL_GETTHEMEMARGINS pProcGetThemeMargins = NULL;
static CALL_GETTHEMEPARTSIZE pProcGetThemePartSize = NULL;
static CALL_GETTHEMETEXTEXTENT pProcGetThemeTextExtent = NULL;
static CALL_GETTHEMETEXTMETRICS pProcGetThemeTextMetrics = NULL;
static CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT pProcIsThemeBackgroundPartiallyTransparent = NULL;
static CALL_OPENTHEMEDATA pProcOpenThemeData = NULL;
static CALL_SETWINDOWTHEME pProcSetWindowTheme = NULL;
static CALL_ISTHEMEACTIVE pProcIsThemeActive = NULL;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HMODULE _UxTheme_Init( void )
{
   HMODULE hUxTheme;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! hDllUxTheme )
   {
      hDllUxTheme = LoadLibrary( "UXTHEME.DLL" );

      if( hDllUxTheme )
      {
         pProcCloseThemeData = ( CALL_CLOSETHEMEDATA ) _OOHG_GetProcAddress( hDllUxTheme, "CloseThemeData" );
         pProcDrawThemeBackground = ( CALL_DRAWTHEMEBACKGROUND ) _OOHG_GetProcAddress( hDllUxTheme, "DrawThemeBackground" );
         pProcDrawThemeParentBackground = ( CALL_DRAWTHEMEPARENTBACKGROUND ) _OOHG_GetProcAddress( hDllUxTheme, "DrawThemeParentBackground" );
         pProcDrawThemeText = ( CALL_DRAWTHEMETEXT ) _OOHG_GetProcAddress( hDllUxTheme, "DrawThemeText" );
         pProcDrawThemeTextEx = ( CALL_DRAWTHEMETEXTEX ) _OOHG_GetProcAddress( hDllUxTheme, "DrawThemeTextEx" );
         pProcGetThemeBackgroundContentRect = ( CALL_GETTHEMEBACKGROUNDCONTENTRECT ) _OOHG_GetProcAddress( hDllUxTheme, "GetThemeBackgroundContentRect" );
         pProcGetThemeMargins = ( CALL_GETTHEMEMARGINS ) _OOHG_GetProcAddress( hDllUxTheme, "GetThemeMargins" );
         pProcGetThemePartSize = ( CALL_GETTHEMEPARTSIZE ) _OOHG_GetProcAddress( hDllUxTheme, "GetThemePartSize" );
         pProcGetThemeTextExtent = ( CALL_GETTHEMETEXTEXTENT ) _OOHG_GetProcAddress( hDllUxTheme, "GetThemeTextExtent" );
         pProcGetThemeTextMetrics = ( CALL_GETTHEMETEXTMETRICS ) _OOHG_GetProcAddress( hDllUxTheme, "GetThemeTextMetrics" );
         pProcIsThemeBackgroundPartiallyTransparent = ( CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT ) _OOHG_GetProcAddress( hDllUxTheme, "IsThemeBackgroundPartiallyTransparent" );
         pProcOpenThemeData = ( CALL_OPENTHEMEDATA ) _OOHG_GetProcAddress( hDllUxTheme, "OpenThemeData" );
         pProcSetWindowTheme = ( CALL_SETWINDOWTHEME ) _OOHG_GetProcAddress( hDllUxTheme, "SetWindowTheme" );
         pProcIsThemeActive = ( CALL_ISTHEMEACTIVE ) _OOHG_GetProcAddress( hDllUxTheme, "IsThemeActive" );

         if( ! ( pProcCloseThemeData &&
                 pProcDrawThemeBackground &&
                 pProcDrawThemeParentBackground &&
                 pProcGetThemeBackgroundContentRect &&
                 pProcGetThemeMargins &&
                 pProcGetThemePartSize &&
                 pProcGetThemeTextExtent &&
                 pProcGetThemeTextMetrics &&
                 pProcIsThemeBackgroundPartiallyTransparent &&
                 pProcOpenThemeData &&
                 pProcSetWindowTheme &&
                 pProcIsThemeActive &&
                 ( pProcDrawThemeText || pProcDrawThemeTextEx ) ) )
         {
            FreeLibrary( hDllUxTheme );

            hDllUxTheme = NULL;
            pProcCloseThemeData = NULL;
            pProcDrawThemeBackground = NULL;
            pProcDrawThemeParentBackground = NULL;
            pProcDrawThemeText = NULL;
            pProcDrawThemeTextEx = NULL;
            pProcGetThemeBackgroundContentRect = NULL;
            pProcGetThemeMargins = NULL;
            pProcGetThemePartSize = NULL;
            pProcGetThemeTextExtent = NULL;
            pProcGetThemeTextMetrics = NULL;
            pProcIsThemeBackgroundPartiallyTransparent = NULL;
            pProcOpenThemeData = NULL;
            pProcSetWindowTheme = NULL;
            pProcIsThemeActive = NULL;
         }
      }
   }
   hUxTheme = hDllUxTheme;
   ReleaseMutex( _OOHG_GlobalMutex() );

  return hUxTheme;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcCloseThemeData( HTHEME hTheme )
{
   return ( pProcCloseThemeData )( hTheme );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcDrawThemeBackground( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, LPCRECT pRect, LPCRECT pClipRect )
{
   return ( pProcDrawThemeBackground )( hTheme, hdc, iPartId, iStateId, pRect, pClipRect );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcDrawThemeParentBackground( HWND hWnd, HDC hdc, LPCRECT prc )
{
   return ( pProcDrawThemeParentBackground )( hWnd, hdc, prc );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcDrawThemeText( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, LPCWSTR pszText, int cchText, DWORD dwTextFlags, DWORD dwTextFlags2, LPCRECT pRect )
{
   return ( pProcDrawThemeText )( hTheme, hdc, iPartId, iStateId, pszText, cchText, dwTextFlags, dwTextFlags2, pRect );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcDrawThemeTextEx( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, LPCWSTR pszText, int cchText, DWORD dwTextFlags, LPRECT pRect, const DTTOPTS * pOptions )
{
   return ( pProcDrawThemeTextEx )( hTheme, hdc, iPartId, iStateId, pszText, cchText, dwTextFlags, pRect, pOptions );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcGetThemeBackgroundContentRect( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, LPCRECT pBoundingRect, LPRECT pContentRect )
{
   return ( pProcGetThemeBackgroundContentRect )( hTheme, hdc, iPartId, iStateId, pBoundingRect, pContentRect );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcGetThemeMargins( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, int iPropId, LPCRECT prc, MARGINS * pMargins )
{
   return ( pProcGetThemeMargins )( hTheme, hdc, iPartId, iStateId, iPropId, prc, pMargins );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcGetThemePartSize( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, LPCRECT prc, THEMESIZE eSize, SIZE * psz )
{
   return ( pProcGetThemePartSize )( hTheme, hdc, iPartId, iStateId, prc, eSize, psz );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcGetThemeTextExtent( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, LPCWSTR pszText, int cchCharCount, DWORD dwTextFlags, LPCRECT pBoundingRect, LPRECT pExtentRect )
{
   return ( pProcGetThemeTextExtent )( hTheme, hdc, iPartId, iStateId, pszText, cchCharCount, dwTextFlags, pBoundingRect, pExtentRect );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcGetThemeTextMetrics( HTHEME hTheme, HDC hdc, int iPartId, int iStateId, TEXTMETRICW * ptm )
{
   return ( pProcGetThemeTextMetrics )( hTheme, hdc, iPartId, iStateId, ptm );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL ProcIsThemeBackgroundPartiallyTransparent( HTHEME hTheme, int iPartId, int iStateId )
{
   return ( pProcIsThemeBackgroundPartiallyTransparent )( hTheme, iPartId, iStateId );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HTHEME ProcOpenThemeData( HWND hWnd, LPCWSTR pszClassList )
{
   return ( pProcOpenThemeData )( hWnd, pszClassList );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HRESULT ProcSetWindowTheme( HWND hWnd, LPCWSTR pszSubAppName, LPCWSTR pszSubIdList )
{
   return ( pProcSetWindowTheme )( hWnd, pszSubAppName, pszSubIdList );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
BOOL ProcIsThemeActive( void )
{
   return ( pProcIsThemeActive )();
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void _UxTheme_DeInit( void )
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllUxTheme )
   {
      FreeLibrary( hDllUxTheme );

      hDllUxTheme = NULL;
      pProcCloseThemeData = NULL;
      pProcDrawThemeBackground = NULL;
      pProcDrawThemeParentBackground = NULL;
      pProcDrawThemeText = NULL;
      pProcDrawThemeTextEx = NULL;
      pProcGetThemeBackgroundContentRect = NULL;
      pProcGetThemeMargins = NULL;
      pProcGetThemePartSize = NULL;
      pProcGetThemeTextExtent = NULL;
      pProcGetThemeTextMetrics = NULL;
      pProcIsThemeBackgroundPartiallyTransparent = NULL;
      pProcOpenThemeData = NULL;
      pProcSetWindowTheme = NULL;
      pProcIsThemeActive = NULL;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ISXPTHEMEACTIVE )          /* FUNCTION IsXPThemeActive() -> lRet */
{
   BOOL bResult = FALSE;
   OSVERSIONINFO os;

   os.dwOSVersionInfoSize = sizeof( os );

   if( GetVersionEx( &os ) && os.dwPlatformId == VER_PLATFORM_WIN32_NT && os.dwMajorVersion == 5 && os.dwMinorVersion == 1 )
   {
      if( _UxTheme_Init() )
      {
         bResult = (BOOL) ProcIsThemeActive();
      }
   }

   hb_retl( bResult );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ISAPPTHEMED )          /* FUNCTION IsAppThemed() -> lRet */
{
   BOOL bResult = FALSE;
   HMODULE hInstDLL;
   CALL_ISAPPTHEMED pIsAppThemed;
   long lResult;
   OSVERSIONINFO os;

   os.dwOSVersionInfoSize = sizeof( os );

   if( GetVersionEx( &os ) && ( os.dwMajorVersion > 5 || ( os.dwMajorVersion == 5 && os.dwMinorVersion >= 1 ) ) )
   {
      hInstDLL = _UxTheme_Init();
      if( hInstDLL )
      {
         pIsAppThemed = ( CALL_ISAPPTHEMED ) _OOHG_GetProcAddress( hInstDLL, "IsAppThemed" );
         if( pIsAppThemed )
         {
            lResult = ( pIsAppThemed )();
            if( lResult )
            {
               bResult = TRUE;
            }
         }
      }
   }

   hb_retl( bResult );
}

HB_FUNC( FREELIBRARIES )
{
   _Ax_DeInit();
   _ComCtl32_DeInit();
   _DWMAPI_DeInit();
   _ProcessLib_DeInit();
   _RichEdit_DeInit();
   _ShlWAPI_DeInit();
   _User32_DeInit();
   _UxTheme_DeInit();
   InitDeinitGdiPlus( FALSE );
}

HB_FUNC( GETTASKBARHEIGHT )
{
   RECT rect;

   GetWindowRect( FindWindow( "Shell_TrayWnd", NULL ), &rect );
   hb_retni( (int) rect.bottom - rect.top );
}

HB_FUNC( LOADSTRING )
{
   LPBYTE cBuffer;

   cBuffer = (LPBYTE) GlobalAlloc( GPTR, 255 );
   LoadString( GetModuleHandle( NULL ), hb_parni( 1 ), (LPSTR) cBuffer, 254 );

   hb_retc( (char *) cBuffer );
   GlobalFree( cBuffer );
}

HB_PTRUINT _OOHG_GetProcAddress( HMODULE hmodule, LPCSTR lpProcName )
{
   FARPROC p = GetProcAddress( hmodule, lpProcName );

   return (HB_PTRUINT) p;
}

// For Harbour 3.0 with GCC 4.5.2
// Note that each DEFINE_KNOWN_FOLDER generates the warning: initialized and declared 'extern'
#ifndef REFKNOWNFOLDERID
   typedef GUID KNOWNFOLDERID;
   #define REFKNOWNFOLDERID KNOWNFOLDERID * /*__MIDL_CONST*/
   #ifdef DEFINE_KNOWN_FOLDER
      #undef DEFINE_KNOWN_FOLDER
   #endif
   #define DEFINE_KNOWN_FOLDER(name, l, w1, w2, b1, b2, b3, b4, b5, b6, b7, b8) \
              EXTERN_C const GUID DECLSPEC_SELECTANY name \
              = { l, w1, w2, { b1, b2,  b3,  b4,  b5,  b6,  b7,  b8 } }
   // legacy CSIDL value: CSIDL_NETWORK
   // display name: "Network"
   // legacy display name: "My Network Places"
   // default path:
   // {D20BEEC4-5CA8-4905-AE3B-BF251EA09B53}
   DEFINE_KNOWN_FOLDER(FOLDERID_NetworkFolder,          0xD20BEEC4, 0x5CA8, 0x4905, 0xAE, 0x3B, 0xBF, 0x25, 0x1E, 0xA0, 0x9B, 0x53);
   // {0AC0837C-BBF8-452A-850D-79D08E667CA7}
   DEFINE_KNOWN_FOLDER(FOLDERID_ComputerFolder,         0x0AC0837C, 0xBBF8, 0x452A, 0x85, 0x0D, 0x79, 0xD0, 0x8E, 0x66, 0x7C, 0xA7);
   // {4D9F7874-4E0C-4904-967B-40B0D20C3E4B}
   DEFINE_KNOWN_FOLDER(FOLDERID_InternetFolder,         0x4D9F7874, 0x4E0C, 0x4904, 0x96, 0x7B, 0x40, 0xB0, 0xD2, 0x0C, 0x3E, 0x4B);
   // {82A74AEB-AEB4-465C-A014-D097EE346D63}
   DEFINE_KNOWN_FOLDER(FOLDERID_ControlPanelFolder,     0x82A74AEB, 0xAEB4, 0x465C, 0xA0, 0x14, 0xD0, 0x97, 0xEE, 0x34, 0x6D, 0x63);
   // {76FC4E2D-D6AD-4519-A663-37BD56068185}
   DEFINE_KNOWN_FOLDER(FOLDERID_PrintersFolder,         0x76FC4E2D, 0xD6AD, 0x4519, 0xA6, 0x63, 0x37, 0xBD, 0x56, 0x06, 0x81, 0x85);
   // {43668BF8-C14E-49B2-97C9-747784D784B7}
   DEFINE_KNOWN_FOLDER(FOLDERID_SyncManagerFolder,      0x43668BF8, 0xC14E, 0x49B2, 0x97, 0xC9, 0x74, 0x77, 0x84, 0xD7, 0x84, 0xB7);
   // {0F214138-B1D3-4a90-BBA9-27CBC0C5389A}
   DEFINE_KNOWN_FOLDER(FOLDERID_SyncSetupFolder,        0xf214138, 0xb1d3, 0x4a90, 0xbb, 0xa9, 0x27, 0xcb, 0xc0, 0xc5, 0x38, 0x9a);
   // {4bfefb45-347d-4006-a5be-ac0cb0567192}
   DEFINE_KNOWN_FOLDER(FOLDERID_ConflictFolder,         0x4bfefb45, 0x347d, 0x4006, 0xa5, 0xbe, 0xac, 0x0c, 0xb0, 0x56, 0x71, 0x92);
   // {289a9a43-be44-4057-a41b-587a76d7e7f9}
   DEFINE_KNOWN_FOLDER(FOLDERID_SyncResultsFolder,      0x289a9a43, 0xbe44, 0x4057, 0xa4, 0x1b, 0x58, 0x7a, 0x76, 0xd7, 0xe7, 0xf9);
   // {B7534046-3ECB-4C18-BE4E-64CD4CB7D6AC}
   DEFINE_KNOWN_FOLDER(FOLDERID_RecycleBinFolder,       0xB7534046, 0x3ECB, 0x4C18, 0xBE, 0x4E, 0x64, 0xCD, 0x4C, 0xB7, 0xD6, 0xAC);
   // {6F0CD92B-2E97-45D1-88FF-B0D186B8DEDD}
   DEFINE_KNOWN_FOLDER(FOLDERID_ConnectionsFolder,      0x6F0CD92B, 0x2E97, 0x45D1, 0x88, 0xFF, 0xB0, 0xD1, 0x86, 0xB8, 0xDE, 0xDD);
   // {FD228CB7-AE11-4AE3-864C-16F3910AB8FE}
   DEFINE_KNOWN_FOLDER(FOLDERID_Fonts,                  0xFD228CB7, 0xAE11, 0x4AE3, 0x86, 0x4C, 0x16, 0xF3, 0x91, 0x0A, 0xB8, 0xFE);
   // display name:        "Desktop"
   // default path:        "C:\Users\<UserName>\Desktop"
   // legacy default path: "C:\Documents and Settings\<userName>\Desktop"
   // legacy CSIDL value:  CSIDL_DESKTOP
   // {B4BFCC3A-DB2C-424C-B029-7FE99A87C641}
   DEFINE_KNOWN_FOLDER(FOLDERID_Desktop,                0xB4BFCC3A, 0xDB2C, 0x424C, 0xB0, 0x29, 0x7F, 0xE9, 0x9A, 0x87, 0xC6, 0x41);
   // {B97D20BB-F46A-4C97-BA10-5E3608430854}
   DEFINE_KNOWN_FOLDER(FOLDERID_Startup,                0xB97D20BB, 0xF46A, 0x4C97, 0xBA, 0x10, 0x5E, 0x36, 0x08, 0x43, 0x08, 0x54);
   // {A77F5D77-2E2B-44C3-A6A2-ABA601054A51}
   DEFINE_KNOWN_FOLDER(FOLDERID_Programs,               0xA77F5D77, 0x2E2B, 0x44C3, 0xA6, 0xA2, 0xAB, 0xA6, 0x01, 0x05, 0x4A, 0x51);
   // {625B53C3-AB48-4EC1-BA1F-A1EF4146FC19}
   DEFINE_KNOWN_FOLDER(FOLDERID_StartMenu,              0x625B53C3, 0xAB48, 0x4EC1, 0xBA, 0x1F, 0xA1, 0xEF, 0x41, 0x46, 0xFC, 0x19);
   // {AE50C081-EBD2-438A-8655-8A092E34987A}
   DEFINE_KNOWN_FOLDER(FOLDERID_Recent,                 0xAE50C081, 0xEBD2, 0x438A, 0x86, 0x55, 0x8A, 0x09, 0x2E, 0x34, 0x98, 0x7A);
   // {8983036C-27C0-404B-8F08-102D10DCFD74}
   DEFINE_KNOWN_FOLDER(FOLDERID_SendTo,                 0x8983036C, 0x27C0, 0x404B, 0x8F, 0x08, 0x10, 0x2D, 0x10, 0xDC, 0xFD, 0x74);
   // {FDD39AD0-238F-46AF-ADB4-6C85480369C7}
   DEFINE_KNOWN_FOLDER(FOLDERID_Documents,              0xFDD39AD0, 0x238F, 0x46AF, 0xAD, 0xB4, 0x6C, 0x85, 0x48, 0x03, 0x69, 0xC7);
   // {1777F761-68AD-4D8A-87BD-30B759FA33DD}
   DEFINE_KNOWN_FOLDER(FOLDERID_Favorites,              0x1777F761, 0x68AD, 0x4D8A, 0x87, 0xBD, 0x30, 0xB7, 0x59, 0xFA, 0x33, 0xDD);
   // {C5ABBF53-E17F-4121-8900-86626FC2C973}
   DEFINE_KNOWN_FOLDER(FOLDERID_NetHood,                0xC5ABBF53, 0xE17F, 0x4121, 0x89, 0x00, 0x86, 0x62, 0x6F, 0xC2, 0xC9, 0x73);
   // {9274BD8D-CFD1-41C3-B35E-B13F55A758F4}
   DEFINE_KNOWN_FOLDER(FOLDERID_PrintHood,              0x9274BD8D, 0xCFD1, 0x41C3, 0xB3, 0x5E, 0xB1, 0x3F, 0x55, 0xA7, 0x58, 0xF4);
   // {A63293E8-664E-48DB-A079-DF759E0509F7}
   DEFINE_KNOWN_FOLDER(FOLDERID_Templates,              0xA63293E8, 0x664E, 0x48DB, 0xA0, 0x79, 0xDF, 0x75, 0x9E, 0x05, 0x09, 0xF7);
   // {82A5EA35-D9CD-47C5-9629-E15D2F714E6E}
   DEFINE_KNOWN_FOLDER(FOLDERID_CommonStartup,          0x82A5EA35, 0xD9CD, 0x47C5, 0x96, 0x29, 0xE1, 0x5D, 0x2F, 0x71, 0x4E, 0x6E);
   // {0139D44E-6AFE-49F2-8690-3DAFCAE6FFB8}
   DEFINE_KNOWN_FOLDER(FOLDERID_CommonPrograms,         0x0139D44E, 0x6AFE, 0x49F2, 0x86, 0x90, 0x3D, 0xAF, 0xCA, 0xE6, 0xFF, 0xB8);
   // {A4115719-D62E-491D-AA7C-E74B8BE3B067}
   DEFINE_KNOWN_FOLDER(FOLDERID_CommonStartMenu,        0xA4115719, 0xD62E, 0x491D, 0xAA, 0x7C, 0xE7, 0x4B, 0x8B, 0xE3, 0xB0, 0x67);
   // {C4AA340D-F20F-4863-AFEF-F87EF2E6BA25}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicDesktop,          0xC4AA340D, 0xF20F, 0x4863, 0xAF, 0xEF, 0xF8, 0x7E, 0xF2, 0xE6, 0xBA, 0x25);
   // {62AB5D82-FDC1-4DC3-A9DD-070D1D495D97}
   DEFINE_KNOWN_FOLDER(FOLDERID_ProgramData,            0x62AB5D82, 0xFDC1, 0x4DC3, 0xA9, 0xDD, 0x07, 0x0D, 0x1D, 0x49, 0x5D, 0x97);
   // {B94237E7-57AC-4347-9151-B08C6C32D1F7}
   DEFINE_KNOWN_FOLDER(FOLDERID_CommonTemplates,        0xB94237E7, 0x57AC, 0x4347, 0x91, 0x51, 0xB0, 0x8C, 0x6C, 0x32, 0xD1, 0xF7);
   // {ED4824AF-DCE4-45A8-81E2-FC7965083634}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicDocuments,        0xED4824AF, 0xDCE4, 0x45A8, 0x81, 0xE2, 0xFC, 0x79, 0x65, 0x08, 0x36, 0x34);
   // {3EB685DB-65F9-4CF6-A03A-E3EF65729F3D}
   DEFINE_KNOWN_FOLDER(FOLDERID_RoamingAppData,         0x3EB685DB, 0x65F9, 0x4CF6, 0xA0, 0x3A, 0xE3, 0xEF, 0x65, 0x72, 0x9F, 0x3D);
   // {F1B32785-6FBA-4FCF-9D55-7B8E7F157091}
   DEFINE_KNOWN_FOLDER(FOLDERID_LocalAppData,           0xF1B32785, 0x6FBA, 0x4FCF, 0x9D, 0x55, 0x7B, 0x8E, 0x7F, 0x15, 0x70, 0x91);
   // {A520A1A4-1780-4FF6-BD18-167343C5AF16}
   DEFINE_KNOWN_FOLDER(FOLDERID_LocalAppDataLow,        0xA520A1A4, 0x1780, 0x4FF6, 0xBD, 0x18, 0x16, 0x73, 0x43, 0xC5, 0xAF, 0x16);
   // {352481E8-33BE-4251-BA85-6007CAEDCF9D}
   DEFINE_KNOWN_FOLDER(FOLDERID_InternetCache,          0x352481E8, 0x33BE, 0x4251, 0xBA, 0x85, 0x60, 0x07, 0xCA, 0xED, 0xCF, 0x9D);
   // {2B0F765D-C0E9-4171-908E-08A611B84FF6}
   DEFINE_KNOWN_FOLDER(FOLDERID_Cookies,                0x2B0F765D, 0xC0E9, 0x4171, 0x90, 0x8E, 0x08, 0xA6, 0x11, 0xB8, 0x4F, 0xF6);
   // {D9DC8A3B-B784-432E-A781-5A1130A75963}
   DEFINE_KNOWN_FOLDER(FOLDERID_History,                0xD9DC8A3B, 0xB784, 0x432E, 0xA7, 0x81, 0x5A, 0x11, 0x30, 0xA7, 0x59, 0x63);
   // {1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}
   DEFINE_KNOWN_FOLDER(FOLDERID_System,                 0x1AC14E77, 0x02E7, 0x4E5D, 0xB7, 0x44, 0x2E, 0xB1, 0xAE, 0x51, 0x98, 0xB7);
   // {D65231B0-B2F1-4857-A4CE-A8E7C6EA7D27}
   DEFINE_KNOWN_FOLDER(FOLDERID_SystemX86,              0xD65231B0, 0xB2F1, 0x4857, 0xA4, 0xCE, 0xA8, 0xE7, 0xC6, 0xEA, 0x7D, 0x27);
   // {F38BF404-1D43-42F2-9305-67DE0B28FC23}
   DEFINE_KNOWN_FOLDER(FOLDERID_Windows,                0xF38BF404, 0x1D43, 0x42F2, 0x93, 0x05, 0x67, 0xDE, 0x0B, 0x28, 0xFC, 0x23);
   // {5E6C858F-0E22-4760-9AFE-EA3317B67173}
   DEFINE_KNOWN_FOLDER(FOLDERID_Profile,                0x5E6C858F, 0x0E22, 0x4760, 0x9A, 0xFE, 0xEA, 0x33, 0x17, 0xB6, 0x71, 0x73);
   // {33E28130-4E1E-4676-835A-98395C3BC3BB}
   DEFINE_KNOWN_FOLDER(FOLDERID_Pictures,               0x33E28130, 0x4E1E, 0x4676, 0x83, 0x5A, 0x98, 0x39, 0x5C, 0x3B, 0xC3, 0xBB);
   // {7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}
   DEFINE_KNOWN_FOLDER(FOLDERID_ProgramFilesX86,        0x7C5A40EF, 0xA0FB, 0x4BFC, 0x87, 0x4A, 0xC0, 0xF2, 0xE0, 0xB9, 0xFA, 0x8E);
   // {DE974D24-D9C6-4D3E-BF91-F4455120B917}
   DEFINE_KNOWN_FOLDER(FOLDERID_ProgramFilesCommonX86,  0xDE974D24, 0xD9C6, 0x4D3E, 0xBF, 0x91, 0xF4, 0x45, 0x51, 0x20, 0xB9, 0x17);
   // {6D809377-6AF0-444b-8957-A3773F02200E}
   DEFINE_KNOWN_FOLDER(FOLDERID_ProgramFilesX64,        0x6d809377, 0x6af0, 0x444b, 0x89, 0x57, 0xa3, 0x77, 0x3f, 0x02, 0x20, 0x0e );
   // {6365D5A7-0F0D-45e5-87F6-0DA56B6A4F7D}
   DEFINE_KNOWN_FOLDER(FOLDERID_ProgramFilesCommonX64,  0x6365d5a7, 0xf0d, 0x45e5, 0x87, 0xf6, 0xd, 0xa5, 0x6b, 0x6a, 0x4f, 0x7d );
   // {905e63b6-c1bf-494e-b29c-65b732d3d21a}
   DEFINE_KNOWN_FOLDER(FOLDERID_ProgramFiles,           0x905e63b6, 0xc1bf, 0x494e, 0xb2, 0x9c, 0x65, 0xb7, 0x32, 0xd3, 0xd2, 0x1a);
   // {F7F1ED05-9F6D-47A2-AAAE-29D317C6F066}
   DEFINE_KNOWN_FOLDER(FOLDERID_ProgramFilesCommon,     0xF7F1ED05, 0x9F6D, 0x47A2, 0xAA, 0xAE, 0x29, 0xD3, 0x17, 0xC6, 0xF0, 0x66);
   // {5cd7aee2-2219-4a67-b85d-6c9ce15660cb}
   DEFINE_KNOWN_FOLDER(FOLDERID_UserProgramFiles,       0x5cd7aee2, 0x2219, 0x4a67, 0xb8, 0x5d, 0x6c, 0x9c, 0xe1, 0x56, 0x60, 0xcb);
   // {bcbd3057-ca5c-4622-b42d-bc56db0ae516}
   DEFINE_KNOWN_FOLDER(FOLDERID_UserProgramFilesCommon, 0xbcbd3057, 0xca5c, 0x4622, 0xb4, 0x2d, 0xbc, 0x56, 0xdb, 0x0a, 0xe5, 0x16);
   // {724EF170-A42D-4FEF-9F26-B60E846FBA4F}
   DEFINE_KNOWN_FOLDER(FOLDERID_AdminTools,             0x724EF170, 0xA42D, 0x4FEF, 0x9F, 0x26, 0xB6, 0x0E, 0x84, 0x6F, 0xBA, 0x4F);
   // {D0384E7D-BAC3-4797-8F14-CBA229B392B5}
   DEFINE_KNOWN_FOLDER(FOLDERID_CommonAdminTools,       0xD0384E7D, 0xBAC3, 0x4797, 0x8F, 0x14, 0xCB, 0xA2, 0x29, 0xB3, 0x92, 0xB5);
   // {4BD8D571-6D19-48D3-BE97-422220080E43}
   DEFINE_KNOWN_FOLDER(FOLDERID_Music,                  0x4BD8D571, 0x6D19, 0x48D3, 0xBE, 0x97, 0x42, 0x22, 0x20, 0x08, 0x0E, 0x43);
   // {18989B1D-99B5-455B-841C-AB7C74E4DDFC}
   DEFINE_KNOWN_FOLDER(FOLDERID_Videos,                 0x18989B1D, 0x99B5, 0x455B, 0x84, 0x1C, 0xAB, 0x7C, 0x74, 0xE4, 0xDD, 0xFC);
   // {C870044B-F49E-4126-A9C3-B52A1FF411E8}
   DEFINE_KNOWN_FOLDER(FOLDERID_Ringtones,              0xC870044B, 0xF49E, 0x4126, 0xA9, 0xC3, 0xB5, 0x2A, 0x1F, 0xF4, 0x11, 0xE8);
   // {B6EBFB86-6907-413C-9AF7-4FC2ABF07CC5}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicPictures,         0xB6EBFB86, 0x6907, 0x413C, 0x9A, 0xF7, 0x4F, 0xC2, 0xAB, 0xF0, 0x7C, 0xC5);
   // {3214FAB5-9757-4298-BB61-92A9DEAA44FF}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicMusic,            0x3214FAB5, 0x9757, 0x4298, 0xBB, 0x61, 0x92, 0xA9, 0xDE, 0xAA, 0x44, 0xFF);
   // {2400183A-6185-49FB-A2D8-4A392A602BA3}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicVideos,           0x2400183A, 0x6185, 0x49FB, 0xA2, 0xD8, 0x4A, 0x39, 0x2A, 0x60, 0x2B, 0xA3);
   // {E555AB60-153B-4D17-9F04-A5FE99FC15EC}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicRingtones,        0xE555AB60, 0x153B, 0x4D17, 0x9F, 0x04, 0xA5, 0xFE, 0x99, 0xFC, 0x15, 0xEC);
   // {8AD10C31-2ADB-4296-A8F7-E4701232C972}
   DEFINE_KNOWN_FOLDER(FOLDERID_ResourceDir,            0x8AD10C31, 0x2ADB, 0x4296, 0xA8, 0xF7, 0xE4, 0x70, 0x12, 0x32, 0xC9, 0x72);
   // {2A00375E-224C-49DE-B8D1-440DF7EF3DDC}
   DEFINE_KNOWN_FOLDER(FOLDERID_LocalizedResourcesDir,  0x2A00375E, 0x224C, 0x49DE, 0xB8, 0xD1, 0x44, 0x0D, 0xF7, 0xEF, 0x3D, 0xDC);
   // {C1BAE2D0-10DF-4334-BEDD-7AA20B227A9D}
   DEFINE_KNOWN_FOLDER(FOLDERID_CommonOEMLinks,         0xC1BAE2D0, 0x10DF, 0x4334, 0xBE, 0xDD, 0x7A, 0xA2, 0x0B, 0x22, 0x7A, 0x9D);
   // {9E52AB10-F80D-49DF-ACB8-4330F5687855}
   DEFINE_KNOWN_FOLDER(FOLDERID_CDBurning,              0x9E52AB10, 0xF80D, 0x49DF, 0xAC, 0xB8, 0x43, 0x30, 0xF5, 0x68, 0x78, 0x55);
   // {0762D272-C50A-4BB0-A382-697DCD729B80}
   DEFINE_KNOWN_FOLDER(FOLDERID_UserProfiles,           0x0762D272, 0xC50A, 0x4BB0, 0xA3, 0x82, 0x69, 0x7D, 0xCD, 0x72, 0x9B, 0x80);
   // {DE92C1C7-837F-4F69-A3BB-86E631204A23}
   DEFINE_KNOWN_FOLDER(FOLDERID_Playlists,              0xDE92C1C7, 0x837F, 0x4F69, 0xA3, 0xBB, 0x86, 0xE6, 0x31, 0x20, 0x4A, 0x23);
   // {15CA69B3-30EE-49C1-ACE1-6B5EC372AFB5}
   DEFINE_KNOWN_FOLDER(FOLDERID_SamplePlaylists,        0x15CA69B3, 0x30EE, 0x49C1, 0xAC, 0xE1, 0x6B, 0x5E, 0xC3, 0x72, 0xAF, 0xB5);
   // {B250C668-F57D-4EE1-A63C-290EE7D1AA1F}
   DEFINE_KNOWN_FOLDER(FOLDERID_SampleMusic,            0xB250C668, 0xF57D, 0x4EE1, 0xA6, 0x3C, 0x29, 0x0E, 0xE7, 0xD1, 0xAA, 0x1F);
   // {C4900540-2379-4C75-844B-64E6FAF8716B}
   DEFINE_KNOWN_FOLDER(FOLDERID_SamplePictures,         0xC4900540, 0x2379, 0x4C75, 0x84, 0x4B, 0x64, 0xE6, 0xFA, 0xF8, 0x71, 0x6B);
   // {859EAD94-2E85-48AD-A71A-0969CB56A6CD}
   DEFINE_KNOWN_FOLDER(FOLDERID_SampleVideos,           0x859EAD94, 0x2E85, 0x48AD, 0xA7, 0x1A, 0x09, 0x69, 0xCB, 0x56, 0xA6, 0xCD);
   // {69D2CF90-FC33-4FB7-9A0C-EBB0F0FCB43C}
   DEFINE_KNOWN_FOLDER(FOLDERID_PhotoAlbums,            0x69D2CF90, 0xFC33, 0x4FB7, 0x9A, 0x0C, 0xEB, 0xB0, 0xF0, 0xFC, 0xB4, 0x3C);
   // {DFDF76A2-C82A-4D63-906A-5644AC457385}
   DEFINE_KNOWN_FOLDER(FOLDERID_Public,                 0xDFDF76A2, 0xC82A, 0x4D63, 0x90, 0x6A, 0x56, 0x44, 0xAC, 0x45, 0x73, 0x85);
   // {df7266ac-9274-4867-8d55-3bd661de872d}
   DEFINE_KNOWN_FOLDER(FOLDERID_ChangeRemovePrograms,   0xdf7266ac, 0x9274, 0x4867, 0x8d, 0x55, 0x3b, 0xd6, 0x61, 0xde, 0x87, 0x2d);
   // {a305ce99-f527-492b-8b1a-7e76fa98d6e4}
   DEFINE_KNOWN_FOLDER(FOLDERID_AppUpdates,             0xa305ce99, 0xf527, 0x492b, 0x8b, 0x1a, 0x7e, 0x76, 0xfa, 0x98, 0xd6, 0xe4);
   // {de61d971-5ebc-4f02-a3a9-6c82895e5c04}
   DEFINE_KNOWN_FOLDER(FOLDERID_AddNewPrograms,         0xde61d971, 0x5ebc, 0x4f02, 0xa3, 0xa9, 0x6c, 0x82, 0x89, 0x5e, 0x5c, 0x04);
   // {374DE290-123F-4565-9164-39C4925E467B}
   DEFINE_KNOWN_FOLDER(FOLDERID_Downloads,              0x374de290, 0x123f, 0x4565, 0x91, 0x64, 0x39, 0xc4, 0x92, 0x5e, 0x46, 0x7b);
   // {3D644C9B-1FB8-4f30-9B45-F670235F79C0}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicDownloads,        0x3d644c9b, 0x1fb8, 0x4f30, 0x9b, 0x45, 0xf6, 0x70, 0x23, 0x5f, 0x79, 0xc0);
   // {7d1d3a04-debb-4115-95cf-2f29da2920da}
   DEFINE_KNOWN_FOLDER(FOLDERID_SavedSearches,          0x7d1d3a04, 0xdebb, 0x4115, 0x95, 0xcf, 0x2f, 0x29, 0xda, 0x29, 0x20, 0xda);
   // {52a4f021-7b75-48a9-9f6b-4b87a210bc8f}
   DEFINE_KNOWN_FOLDER(FOLDERID_QuickLaunch,            0x52a4f021, 0x7b75, 0x48a9, 0x9f, 0x6b, 0x4b, 0x87, 0xa2, 0x10, 0xbc, 0x8f);
   // {56784854-C6CB-462b-8169-88E350ACB882}
   DEFINE_KNOWN_FOLDER(FOLDERID_Contacts,               0x56784854, 0xc6cb, 0x462b, 0x81, 0x69, 0x88, 0xe3, 0x50, 0xac, 0xb8, 0x82);
   // {A75D362E-50FC-4fb7-AC2C-A8BEAA314493}
   DEFINE_KNOWN_FOLDER(FOLDERID_SidebarParts,           0xa75d362e, 0x50fc, 0x4fb7, 0xac, 0x2c, 0xa8, 0xbe, 0xaa, 0x31, 0x44, 0x93);
   // {7B396E54-9EC5-4300-BE0A-2482EBAE1A26}
   DEFINE_KNOWN_FOLDER(FOLDERID_SidebarDefaultParts,    0x7b396e54, 0x9ec5, 0x4300, 0xbe, 0xa, 0x24, 0x82, 0xeb, 0xae, 0x1a, 0x26);
   // {DEBF2536-E1A8-4c59-B6A2-414586476AEA}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicGameTasks,        0xdebf2536, 0xe1a8, 0x4c59, 0xb6, 0xa2, 0x41, 0x45, 0x86, 0x47, 0x6a, 0xea);
   // {054FAE61-4DD8-4787-80B6-090220C4B700}
   DEFINE_KNOWN_FOLDER(FOLDERID_GameTasks,              0x54fae61, 0x4dd8, 0x4787, 0x80, 0xb6, 0x9, 0x2, 0x20, 0xc4, 0xb7, 0x0);
   // {4C5C32FF-BB9D-43b0-B5B4-2D72E54EAAA4}
   DEFINE_KNOWN_FOLDER(FOLDERID_SavedGames,             0x4c5c32ff, 0xbb9d, 0x43b0, 0xb5, 0xb4, 0x2d, 0x72, 0xe5, 0x4e, 0xaa, 0xa4);
   // {CAC52C1A-B53D-4edc-92D7-6B2E8AC19434}
   DEFINE_KNOWN_FOLDER(FOLDERID_Games,                  0xcac52c1a, 0xb53d, 0x4edc, 0x92, 0xd7, 0x6b, 0x2e, 0x8a, 0xc1, 0x94, 0x34);
   // {98ec0e18-2098-4d44-8644-66979315a281}
   DEFINE_KNOWN_FOLDER(FOLDERID_SEARCH_MAPI,            0x98ec0e18, 0x2098, 0x4d44, 0x86, 0x44, 0x66, 0x97, 0x93, 0x15, 0xa2, 0x81);
   // {ee32e446-31ca-4aba-814f-a5ebd2fd6d5e}
   DEFINE_KNOWN_FOLDER(FOLDERID_SEARCH_CSC,             0xee32e446, 0x31ca, 0x4aba, 0x81, 0x4f, 0xa5, 0xeb, 0xd2, 0xfd, 0x6d, 0x5e);
   // {bfb9d5e0-c6a9-404c-b2b2-ae6db6af4968}
   DEFINE_KNOWN_FOLDER(FOLDERID_Links,                  0xbfb9d5e0, 0xc6a9, 0x404c, 0xb2, 0xb2, 0xae, 0x6d, 0xb6, 0xaf, 0x49, 0x68);
   // {f3ce0f7c-4901-4acc-8648-d5d44b04ef8f}
   DEFINE_KNOWN_FOLDER(FOLDERID_UsersFiles,             0xf3ce0f7c, 0x4901, 0x4acc, 0x86, 0x48, 0xd5, 0xd4, 0x4b, 0x04, 0xef, 0x8f);
   // {A302545D-DEFF-464b-ABE8-61C8648D939B}
   DEFINE_KNOWN_FOLDER(FOLDERID_UsersLibraries,         0xa302545d, 0xdeff, 0x464b, 0xab, 0xe8, 0x61, 0xc8, 0x64, 0x8d, 0x93, 0x9b);
   // {190337d1-b8ca-4121-a639-6d472d16972a}
   DEFINE_KNOWN_FOLDER(FOLDERID_SearchHome,             0x190337d1, 0xb8ca, 0x4121, 0xa6, 0x39, 0x6d, 0x47, 0x2d, 0x16, 0x97, 0x2a);
   // {2C36C0AA-5812-4b87-BFD0-4CD0DFB19B39}
   DEFINE_KNOWN_FOLDER(FOLDERID_OriginalImages,         0x2C36C0AA, 0x5812, 0x4b87, 0xbf, 0xd0, 0x4c, 0xd0, 0xdf, 0xb1, 0x9b, 0x39);
   // {7b0db17d-9cd2-4a93-9733-46cc89022e7c}
   DEFINE_KNOWN_FOLDER(FOLDERID_DocumentsLibrary,       0x7b0db17d, 0x9cd2, 0x4a93, 0x97, 0x33, 0x46, 0xcc, 0x89, 0x02, 0x2e, 0x7c);
   // {2112AB0A-C86A-4ffe-A368-0DE96E47012E}
   DEFINE_KNOWN_FOLDER(FOLDERID_MusicLibrary,           0x2112ab0a, 0xc86a, 0x4ffe, 0xa3, 0x68, 0xd, 0xe9, 0x6e, 0x47, 0x1, 0x2e);
   // {A990AE9F-A03B-4e80-94BC-9912D7504104}
   DEFINE_KNOWN_FOLDER(FOLDERID_PicturesLibrary,        0xa990ae9f, 0xa03b, 0x4e80, 0x94, 0xbc, 0x99, 0x12, 0xd7, 0x50, 0x41, 0x4);
   // {491E922F-5643-4af4-A7EB-4E7A138D8174}
   DEFINE_KNOWN_FOLDER(FOLDERID_VideosLibrary,          0x491e922f, 0x5643, 0x4af4, 0xa7, 0xeb, 0x4e, 0x7a, 0x13, 0x8d, 0x81, 0x74);
   // {1A6FDBA2-F42D-4358-A798-B74D745926C5}
   DEFINE_KNOWN_FOLDER(FOLDERID_RecordedTVLibrary,      0x1a6fdba2, 0xf42d, 0x4358, 0xa7, 0x98, 0xb7, 0x4d, 0x74, 0x59, 0x26, 0xc5);
   // {52528A6B-B9E3-4add-B60D-588C2DBA842D}
   DEFINE_KNOWN_FOLDER(FOLDERID_HomeGroup,              0x52528a6b, 0xb9e3, 0x4add, 0xb6, 0xd, 0x58, 0x8c, 0x2d, 0xba, 0x84, 0x2d);
   // {9B74B6A3-0DFD-4f11-9E78-5F7800F2E772}
   DEFINE_KNOWN_FOLDER(FOLDERID_HomeGroupCurrentUser,   0x9b74b6a3, 0xdfd, 0x4f11, 0x9e, 0x78, 0x5f, 0x78, 0x0, 0xf2, 0xe7, 0x72);
   // {5CE4A5E9-E4EB-479D-B89F-130C02886155}
   DEFINE_KNOWN_FOLDER(FOLDERID_DeviceMetadataStore,    0x5ce4a5e9, 0xe4eb, 0x479d, 0xb8, 0x9f, 0x13, 0x0c, 0x02, 0x88, 0x61, 0x55);
   // {1B3EA5DC-B587-4786-B4EF-BD1DC332AEAE}
   DEFINE_KNOWN_FOLDER(FOLDERID_Libraries,              0x1b3ea5dc, 0xb587, 0x4786, 0xb4, 0xef, 0xbd, 0x1d, 0xc3, 0x32, 0xae, 0xae);
   // {48daf80b-e6cf-4f4e-b800-0e69d84ee384}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicLibraries,        0x48daf80b, 0xe6cf, 0x4f4e, 0xb8, 0x00, 0x0e, 0x69, 0xd8, 0x4e, 0xe3, 0x84);
   // {9e3995ab-1f9c-4f13-b827-48b24b6c7174}
   DEFINE_KNOWN_FOLDER(FOLDERID_UserPinned,             0x9e3995ab, 0x1f9c, 0x4f13, 0xb8, 0x27, 0x48, 0xb2, 0x4b, 0x6c, 0x71, 0x74);
   // {bcb5256f-79f6-4cee-b725-dc34e402fd46}
   DEFINE_KNOWN_FOLDER(FOLDERID_ImplicitAppShortcuts,   0xbcb5256f, 0x79f6, 0x4cee, 0xb7, 0x25, 0xdc, 0x34, 0xe4, 0x2, 0xfd, 0x46);
   // {008ca0b1-55b4-4c56-b8a8-4de4b299d3be}
   DEFINE_KNOWN_FOLDER(FOLDERID_AccountPictures,        0x008ca0b1, 0x55b4, 0x4c56, 0xb8, 0xa8, 0x4d, 0xe4, 0xb2, 0x99, 0xd3, 0xbe);
   // {0482af6c-08f1-4c34-8c90-e17ec98b1e17}
   DEFINE_KNOWN_FOLDER(FOLDERID_PublicUserTiles,        0x0482af6c, 0x08f1, 0x4c34, 0x8c, 0x90, 0xe1, 0x7e, 0xc9, 0x8b, 0x1e, 0x17);
   // {1e87508d-89c2-42f0-8a7e-645a0f50ca58}
   DEFINE_KNOWN_FOLDER(FOLDERID_AppsFolder,             0x1e87508d, 0x89c2, 0x42f0, 0x8a, 0x7e, 0x64, 0x5a, 0x0f, 0x50, 0xca, 0x58);
   // {F26305EF-6948-40B9-B255-81453D09C785}
   DEFINE_KNOWN_FOLDER(FOLDERID_StartMenuAllPrograms,   0xf26305ef, 0x6948, 0x40b9, 0xb2, 0x55, 0x81, 0x45, 0x3d, 0x9, 0xc7, 0x85);
   // {A3918781-E5F2-4890-B3D9-A7E54332328C}
   DEFINE_KNOWN_FOLDER(FOLDERID_ApplicationShortcuts,   0xa3918781, 0xe5f2, 0x4890, 0xb3, 0xd9, 0xa7, 0xe5, 0x43, 0x32, 0x32, 0x8c);
   // {00BCFC5A-ED94-4e48-96A1-3F6217F21990}
   DEFINE_KNOWN_FOLDER(FOLDERID_RoamingTiles,           0xbcfc5a, 0xed94, 0x4e48, 0x96, 0xa1, 0x3f, 0x62, 0x17, 0xf2, 0x19, 0x90);
   // {AAA8D5A5-F1D6-4259-BAA8-78E7EF60835E}
   DEFINE_KNOWN_FOLDER(FOLDERID_RoamedTileImages,       0xaaa8d5a5, 0xf1d6, 0x4259, 0xba, 0xa8, 0x78, 0xe7, 0xef, 0x60, 0x83, 0x5e);
   // {b7bede81-df94-4682-a7d8-57a52620b86f}
   DEFINE_KNOWN_FOLDER(FOLDERID_Screenshots,            0xb7bede81, 0xdf94, 0x4682, 0xa7, 0xd8, 0x57, 0xa5, 0x26, 0x20, 0xb8, 0x6f);
   // {AB5FB87B-7CE2-4F83-915D-550846C9537B}
   DEFINE_KNOWN_FOLDER(FOLDERID_CameraRoll,             0xab5fb87b, 0x7ce2, 0x4f83, 0x91, 0x5d, 0x55, 0x8, 0x46, 0xc9, 0x53, 0x7b);
   // {A52BBA46-E9E1-435f-B3D9-28DAA648C0F6}
   DEFINE_KNOWN_FOLDER(FOLDERID_SkyDrive,               0xa52bba46, 0xe9e1, 0x435f, 0xb3, 0xd9, 0x28, 0xda, 0xa6, 0x48, 0xc0, 0xf6);
   // {A52BBA46-E9E1-435f-B3D9-28DAA648C0F6}
   // Same as FOLDERID_SkyDrive and later we'll remove FOLDERID_SkyDrive
   DEFINE_KNOWN_FOLDER(FOLDERID_OneDrive,               0xa52bba46, 0xe9e1, 0x435f, 0xb3, 0xd9, 0x28, 0xda, 0xa6, 0x48, 0xc0, 0xf6);
   // {24D89E24-2F19-4534-9DDE-6A6671FBB8FE}
   DEFINE_KNOWN_FOLDER(FOLDERID_SkyDriveDocuments,      0x24d89e24, 0x2f19, 0x4534, 0x9d, 0xde, 0x6a, 0x66, 0x71, 0xfb, 0xb8, 0xfe);
   // {339719B5-8C47-4894-94C2-D8F77ADD44A6}
   DEFINE_KNOWN_FOLDER(FOLDERID_SkyDrivePictures,       0x339719b5, 0x8c47, 0x4894, 0x94, 0xc2, 0xd8, 0xf7, 0x7a, 0xdd, 0x44, 0xa6);
   // {C3F2459E-80D6-45DC-BFEF-1F769F2BE730}
   DEFINE_KNOWN_FOLDER(FOLDERID_SkyDriveMusic,          0xc3f2459e, 0x80d6, 0x45dc, 0xbf, 0xef, 0x1f, 0x76, 0x9f, 0x2b, 0xe7, 0x30);
   // {767E6811-49CB-4273-87C2-20F355E1085B}
   DEFINE_KNOWN_FOLDER(FOLDERID_SkyDriveCameraRoll,     0x767e6811, 0x49cb, 0x4273, 0x87, 0xc2, 0x20, 0xf3, 0x55, 0xe1, 0x08, 0x5b);
   // {0D4C3DB6-03A3-462F-A0E6-08924C41B5D4}
   DEFINE_KNOWN_FOLDER(FOLDERID_SearchHistory,          0x0d4c3db6, 0x03a3, 0x462f, 0xa0, 0xe6, 0x08, 0x92, 0x4c, 0x41, 0xb5, 0xd4);
   // {7E636BFE-DFA9-4D5E-B456-D7B39851D8A9}
   DEFINE_KNOWN_FOLDER(FOLDERID_SearchTemplates,        0x7e636bfe, 0xdfa9, 0x4d5e, 0xb4, 0x56, 0xd7, 0xb3, 0x98, 0x51, 0xd8, 0xa9);
   // {2B20DF75-1EDA-4039-8097-38798227D5B7}
   DEFINE_KNOWN_FOLDER(FOLDERID_CameraRollLibrary,      0x2b20df75, 0x1eda, 0x4039, 0x80, 0x97, 0x38, 0x79, 0x82, 0x27, 0xd5, 0xb7);
   // {3B193882-D3AD-4eab-965A-69829D1FB59F}
   DEFINE_KNOWN_FOLDER(FOLDERID_SavedPictures,          0x3b193882, 0xd3ad, 0x4eab, 0x96, 0x5a, 0x69, 0x82, 0x9d, 0x1f, 0xb5, 0x9f);
   // {E25B5812-BE88-4bd9-94B0-29233477B6C3}
   DEFINE_KNOWN_FOLDER(FOLDERID_SavedPicturesLibrary,   0xe25b5812, 0xbe88, 0x4bd9, 0x94, 0xb0, 0x29, 0x23, 0x34, 0x77, 0xb6, 0xc3);
   // {12D4C69E-24AD-4923-BE19-31321C43A767}
   DEFINE_KNOWN_FOLDER(FOLDERID_RetailDemo,             0x12d4c69e, 0x24ad, 0x4923, 0xbe, 0x19, 0x31, 0x32, 0x1c, 0x43, 0xa7, 0x67);
   // The file system directory that contains development files that have been copied to this device by a development tool. A
   // typical path is C:\Users\username\AppData\Local\DevelopmentFiles. This directory is used by development tools that need
   // to copy files to a device. This may include copying application binaries for temporary registration and execution in order
   // to allow a developer to test their application without having to go through the full app packaging process. It could also
   // include development time only components such as a remote debugger. Recommended practice is to create sub-directories rather
   // than copying files to the DevelopmentFiles directory. Development tools should be careful to use a naming convention that
   // avoids conflicts. For example application binaries should be copied to a directory with a unique name such as the app package
   // full name. This information is per user and will not roam.
   // {DBE8E08E-3053-4BBC-B183-2A7B2B191E59}
   DEFINE_KNOWN_FOLDER(FOLDERID_DevelopmentFiles,       0xdbe8e08e, 0x3053, 0x4bbc, 0xb1, 0x83, 0x2a, 0x7b, 0x2b, 0x19, 0x1e, 0x59);
   // {31C0DD25-9439-4F12-BF41-7FF4EDA38722}
   DEFINE_KNOWN_FOLDER(FOLDERID_Objects3D,              0x31c0dd25,  0x9439, 0x4f12, 0xbf, 0x41, 0x7f, 0xf4, 0xed, 0xa3, 0x87, 0x22);
   // {EDC0FE71-98D8-4F4A-B920-C8DC133CB165}
   DEFINE_KNOWN_FOLDER(FOLDERID_AppCaptures,            0xedc0fe71, 0x98d8, 0x4f4a, 0xb9, 0x20, 0xc8, 0xdc, 0x13, 0x3c, 0xb1, 0x65);
   // {f42ee2d3-909f-4907-8871-4c22fc0bf756}
   DEFINE_KNOWN_FOLDER(FOLDERID_LocalDocuments,         0xf42ee2d3, 0x909f, 0x4907, 0x88, 0x71, 0x4c, 0x22, 0xfc, 0x0b, 0xf7, 0x56);
   // {0ddd015d-b06c-45d5-8c4c-f59713854639 }
   DEFINE_KNOWN_FOLDER(FOLDERID_LocalPictures,          0x0ddd015d, 0xb06c, 0x45d5, 0x8c, 0x4c, 0xf5, 0x97, 0x13, 0x85, 0x46, 0x39);
   // {35286a68-3c57-41a1-bbb1-0eae73d76c95}
   DEFINE_KNOWN_FOLDER(FOLDERID_LocalVideos,            0x35286a68, 0x3c57, 0x41a1, 0xbb, 0xb1, 0x0e, 0xae, 0x73, 0xd7, 0x6c, 0x95);
   // {a0c69a99-21c8-4671-8703-7934162fcf1d}
   DEFINE_KNOWN_FOLDER(FOLDERID_LocalMusic,             0xa0c69a99,  0x21c8, 0x4671, 0x87, 0x03, 0x79, 0x34, 0x16, 0x2f, 0xcf, 0x1d);
   // {7d83ee9b-2244-4e70-b1f5-5393042af1e4}
   DEFINE_KNOWN_FOLDER(FOLDERID_LocalDownloads,         0x7d83ee9b,  0x2244, 0x4e70, 0xb1, 0xf5, 0x53, 0x93, 0x04, 0x2a, 0xf1, 0xe4);

HRESULT WINAPI win_SHGetKnownFolderPath( REFKNOWNFOLDERID rfid, DWORD dwFlags, HANDLE hToken, PWSTR *ppath )
{
   typedef HRESULT ( WINAPI *SHGETKNOWNFOLDERPATH ) ( REFKNOWNFOLDERID, DWORD, HANDLE, PWSTR* );
   static SHGETKNOWNFOLDERPATH SHGetKnownFolderPath = NULL;
   HMODULE hLib;
   HRESULT res;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( SHGetKnownFolderPath == NULL )
   {
      hLib = LoadLibrary( "Shell32.dll" );
      SHGetKnownFolderPath = (SHGETKNOWNFOLDERPATH) _OOHG_GetProcAddress( hLib, "SHGetKnownFolderPath" );
   }
   if( SHGetKnownFolderPath == NULL )
   {
      res = FALSE;
   }
   else
   {
      res = SHGetKnownFolderPath( rfid, dwFlags, hToken, ppath );
   }
   ReleaseMutex( _OOHG_GlobalMutex() );
   return( res );
}

#define _SHGetKnownFolderPath win_SHGetKnownFolderPath
#else
#define _SHGetKnownFolderPath SHGetKnownFolderPath
#endif

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETKNOWNFOLDER )          /* FUNCTION GETKNOWNFOLDER( nFOLDERID ) -> cPath */
{
   PWSTR path;
   char *cBuffer;
   int size;
   static const REFKNOWNFOLDERID id[ 110 ] =
   { &FOLDERID_AccountPictures,        &FOLDERID_AddNewPrograms,        &FOLDERID_AdminTools,            &FOLDERID_AppsFolder,
     &FOLDERID_ApplicationShortcuts,   &FOLDERID_AppUpdates,            &FOLDERID_CDBurning,             &FOLDERID_ChangeRemovePrograms,
     &FOLDERID_CommonAdminTools,       &FOLDERID_CommonOEMLinks,        &FOLDERID_CommonPrograms,        &FOLDERID_CommonStartMenu,
     &FOLDERID_CommonStartup,          &FOLDERID_CommonTemplates,       &FOLDERID_ComputerFolder,        &FOLDERID_ConflictFolder,
     &FOLDERID_ConnectionsFolder,      &FOLDERID_Contacts,              &FOLDERID_ControlPanelFolder,    &FOLDERID_Cookies,
     &FOLDERID_Desktop,                &FOLDERID_DeviceMetadataStore,   &FOLDERID_Documents,             &FOLDERID_DocumentsLibrary,
     &FOLDERID_Downloads,              &FOLDERID_Favorites,             &FOLDERID_Fonts,                 &FOLDERID_Games,
     &FOLDERID_GameTasks,              &FOLDERID_History,               &FOLDERID_HomeGroup,             &FOLDERID_HomeGroupCurrentUser,
     &FOLDERID_ImplicitAppShortcuts,   &FOLDERID_InternetCache,         &FOLDERID_InternetFolder,        &FOLDERID_Libraries,
     &FOLDERID_Links,                  &FOLDERID_LocalAppData,          &FOLDERID_LocalAppDataLow,       &FOLDERID_LocalizedResourcesDir,
     &FOLDERID_Music,                  &FOLDERID_MusicLibrary,          &FOLDERID_NetHood,               &FOLDERID_NetworkFolder,
     &FOLDERID_OriginalImages,         &FOLDERID_PhotoAlbums,           &FOLDERID_Pictures,              &FOLDERID_PicturesLibrary,
     &FOLDERID_Playlists,              &FOLDERID_PrintHood,             &FOLDERID_PrintersFolder,        &FOLDERID_Profile,
     &FOLDERID_ProgramData,            &FOLDERID_ProgramFiles,          &FOLDERID_ProgramFilesX64,       &FOLDERID_ProgramFilesX86,
     &FOLDERID_ProgramFilesCommon,     &FOLDERID_ProgramFilesCommonX64, &FOLDERID_ProgramFilesCommonX86, &FOLDERID_Programs,
     &FOLDERID_Public,                 &FOLDERID_PublicDesktop,         &FOLDERID_PublicDocuments,       &FOLDERID_PublicDownloads,
     &FOLDERID_PublicGameTasks,        &FOLDERID_PublicLibraries,       &FOLDERID_PublicMusic,           &FOLDERID_PublicPictures,
     &FOLDERID_PublicRingtones,        &FOLDERID_PublicUserTiles,       &FOLDERID_PublicVideos,          &FOLDERID_QuickLaunch,
     &FOLDERID_Recent,                 &FOLDERID_RecordedTVLibrary,     &FOLDERID_RecycleBinFolder,      &FOLDERID_ResourceDir,
     &FOLDERID_Ringtones,              &FOLDERID_RoamingAppData,        &FOLDERID_RoamingTiles,          &FOLDERID_RoamedTileImages,
     &FOLDERID_SampleMusic,            &FOLDERID_SamplePictures,        &FOLDERID_SamplePlaylists,       &FOLDERID_SampleVideos,
     &FOLDERID_SavedGames,             &FOLDERID_SavedSearches,         &FOLDERID_Screenshots,           &FOLDERID_SEARCH_MAPI,
     &FOLDERID_SEARCH_CSC,             &FOLDERID_SearchHome,            &FOLDERID_SendTo,                &FOLDERID_SidebarDefaultParts,
     &FOLDERID_SidebarParts,           &FOLDERID_StartMenu,             &FOLDERID_Startup,               &FOLDERID_SyncManagerFolder,
     &FOLDERID_SyncResultsFolder,      &FOLDERID_SyncSetupFolder,       &FOLDERID_System,                &FOLDERID_SystemX86,
     &FOLDERID_Templates,              &FOLDERID_UserPinned,            &FOLDERID_UserProfiles,          &FOLDERID_UserProgramFiles,
     &FOLDERID_UserProgramFilesCommon, &FOLDERID_UsersFiles,            &FOLDERID_UsersLibraries,        &FOLDERID_Videos,
     &FOLDERID_VideosLibrary,          &FOLDERID_Windows };

   if( SUCCEEDED( _SHGetKnownFolderPath( (REFKNOWNFOLDERID) id[ hb_parni( 1 ) - 1 ], 0, NULL, &path ) ) )
   {
      size = WideCharToMultiByte( CP_ACP, 0, path, -1, NULL, 0, NULL, NULL );
      if( size > 0 )
      {
         cBuffer = (char *) hb_xgrab( size );
         if( WideCharToMultiByte( CP_ACP, 0, path, -1, cBuffer, size, NULL, NULL ) > 0 )
         {
            hb_retc( cBuffer );
         }
         else
         {
            hb_retc( "" );
         }
         hb_xfree( cBuffer );
      }
      else
      {
         hb_retc( "" );
      }
   }
   else
   {
      hb_retc( "" );
   }

   CoTaskMemFree( path );
}

