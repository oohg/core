/*
 * $Id: c_winapimisc.c $
 */
/*
 * ooHG source code:
 * Windows API related functions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
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
   char szBuffer[ MAX_PATH + 1 ] = {0};
   GetWindowsDirectory( szBuffer, MAX_PATH );
   hb_retc( szBuffer );
}

HB_FUNC( GETSYSTEMDIR )
{
   char szBuffer[ MAX_PATH + 1 ] = {0};
   GetSystemDirectory( szBuffer, MAX_PATH );
   hb_retc( szBuffer );
}

HB_FUNC( GETTEMPDIR )
{
   char szBuffer[ MAX_PATH + 1 ] = {0};
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

HB_FUNC( SHELLEXECUTE )
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

   HINSTANCEret( ShellExecute( HWNDparam( 1 ),
                 HB_ISNIL( 2 ) ? NULL : (LPCSTR) hb_parc( 2 ),
                 (LPCSTR) hb_parc( 3 ),
                 HB_ISNIL( 4 ) ? NULL : (LPCSTR) hb_parc( 4 ),
                 HB_ISNIL( 5 ) ? NULL : (LPCSTR) hb_parc( 5 ),
                 hb_parni( 6 ) ) );

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

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ISEXERUNNING )          /* FUNCTION IsExeRunnnig( cExeNameCaseSensitive ) -> lResult */
{
   HANDLE hMutex = CreateMutex( NULL, FALSE, (LPTSTR) HB_UNCONST( hb_parc( 1 ) ) );

   hb_retl( GetLastError() == ERROR_ALREADY_EXISTS );

   if( hMutex )
   {
      ReleaseMutex( hMutex );
   }
}

HB_FUNC( CREATEMUTEX )
{
   SECURITY_ATTRIBUTES *sa = NULL;

   if( HB_ISCHAR( 2 ) && ! HB_ISNIL( 1 ) )
   {
      sa = ( SECURITY_ATTRIBUTES * ) HB_UNCONST( hb_itemGetCPtr( hb_param( 1, HB_IT_STRING ) ) );
   }

   HANDLEret( CreateMutex( sa, hb_parnl( 2 ), hb_parc( 3 ) ) );
}

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
   char Path[ MAX_PATH + 1 ] = {0};
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
   HKEY hKey;
   long lRetVal;
   DWORD dwBufLen;
   BYTE * lpData = NULL;
   DWORD dwUBR;

   ZeroMemory( &osvi, sizeof( OSVERSIONINFOEX ) );
   osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFOEX );

   bOsVersionInfoEx = GetVersionEx( ( OSVERSIONINFO * ) &osvi );
   if( ! bOsVersionInfoEx )
   {
      osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
      if( ! GetVersionEx( ( OSVERSIONINFO * ) &osvi ) )
      {
         lstrcat( szVersion, _TEXT( "Unknown Operating System" ) );
      }
   }

   if( szVersion == NULL )
   {
      switch( osvi.dwPlatformId )
      {
         case VER_PLATFORM_WIN32_NT:

            if( osvi.dwMajorVersion == 10 && osvi.dwMinorVersion == 0 )
               if( bOsVersionInfoEx && osvi.wProductType != VER_NT_WORKSTATION )
                  lstrcat( szVersion, _TEXT( "Windows Server 2016 " ) );
               else
                  lstrcat( szVersion, _TEXT( "Windows 10 " ) );
            else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 3 )
               if( bOsVersionInfoEx && osvi.wProductType != VER_NT_WORKSTATION )
                  lstrcat( szVersion, _TEXT( "Windows Server 2012 R2 " ) );
               else
                  lstrcat( szVersion, _TEXT( "Windows 8.1 " ) );
            else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 2 )
               if( bOsVersionInfoEx && osvi.wProductType != VER_NT_WORKSTATION )
                  lstrcat( szVersion, _TEXT( "Windows Server 2012 " ) );
               else
                  lstrcat( szVersion, _TEXT( "Windows 8 " ) );
            else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 1 )
               if( bOsVersionInfoEx && osvi.wProductType != VER_NT_WORKSTATION )
                  lstrcat( szVersion, _TEXT( "Windows Server 2008 R2 " ) );
               else
                  lstrcat( szVersion, _TEXT( "Windows 7 " ) );
            else if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0 )
               if( bOsVersionInfoEx && osvi.wProductType != VER_NT_WORKSTATION )
                  lstrcat( szVersion, _TEXT( "Windows Server 2008 " ) );
               else
                  lstrcat( szVersion, _TEXT( "Windows Vista " ) );
            else if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2 )
               lstrcat( szVersion, _TEXT( "Windows Server 2003 " ) );
            else if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1 )
               lstrcat( szVersion, _TEXT( "Windows XP " ) );
            else if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0 )
               lstrcat( szVersion, _TEXT( "Windows 2000 " ) );
            else if( osvi.dwMajorVersion <= 4 )
               lstrcat( szVersion, _TEXT( "Windows NT " ) );

            if( bOsVersionInfoEx )
            {
               if( osvi.wProductType == VER_NT_WORKSTATION )
               {
                  if( osvi.dwMajorVersion == 10 )
                  {
                     lRetVal = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
                                             _TEXT( "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion" ),
                                             0,
                                             KEY_QUERY_VALUE,
                                             &hKey);
                     if( lRetVal == ERROR_SUCCESS )
                     {
                        dwBufLen = 0;
                        lRetVal = RegQueryValueEx( hKey,
                                                   _TEXT( "ProductName" ),
                                                   NULL,
                                                   NULL,
                                                   NULL,
                                                   &dwBufLen );
                        if( lRetVal == ERROR_SUCCESS )
                        {
                           lpData = (BYTE *) hb_xgrab( (UINT) ( (int) dwBufLen + 1 ) );
                           lRetVal = RegQueryValueEx( hKey,
                                                      _TEXT( "ProductName" ),
                                                      NULL,
                                                      NULL,
                                                      lpData,
                                                      &dwBufLen );
                           if( lRetVal == ERROR_SUCCESS )
                              szVersion = (char *) lpData;
                           else
                              hb_xfree( lpData );
                        }
                     }
                     RegCloseKey( hKey );
                  }
                  else if( osvi.dwMajorVersion == 4 )
                     lstrcat( szVersionEx, _TEXT( "Workstation 4.0 " ) );
                  else if( osvi.wSuiteMask & VER_SUITE_PERSONAL )
                     lstrcat( szVersionEx, _TEXT( "Home Edition " ) );
                  else
                     lstrcat( szVersionEx, _TEXT( "Professional " ) );
               }
               else if( osvi.wProductType == VER_NT_SERVER || osvi.wProductType == VER_NT_DOMAIN_CONTROLLER )
               {
                  if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2 )
                  {
                     if( osvi.wSuiteMask & VER_SUITE_DATACENTER )
                        lstrcat( szVersionEx, _TEXT( "Datacenter Edition " ) );
                     else if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                        lstrcat( szVersionEx, _TEXT( "Enterprise Edition " ) );
                     else if( osvi.wSuiteMask & VER_SUITE_BLADE )
                        lstrcat( szVersionEx, _TEXT( "Web Edition " ) );
                     else if( osvi.wSuiteMask & VER_SUITE_WH_SERVER )
                        lstrcat( szVersionEx, _TEXT( "Home Edition " ) );
                     else
                        lstrcat( szVersionEx, _TEXT( "Standard Edition " ) );
                  }
                  else if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0 )
                  {
                     if( osvi.wSuiteMask & VER_SUITE_DATACENTER )
                        lstrcat( szVersionEx, _TEXT( "Datacenter Server " ) );
                     else if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                        lstrcat( szVersionEx, _TEXT( "Advanced Server " ) );
                     else
                        lstrcat( szVersionEx, _TEXT( "Server " ) );
                  }
                  else
                  {
                     if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                        lstrcat( szVersionEx, _TEXT( "Server 4.0, Enterprise Edition " ) );
                     else
                        lstrcat( szVersionEx, _TEXT( "Server 4.0 " ) );
                  }
               }
            }
            else
            {
               lRetVal = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
                                       _TEXT( "SYSTEM\\CurrentControlSet\\Control\\ProductOptions" ),
                                       0,
                                       KEY_QUERY_VALUE,
                                       &hKey);
               if( lRetVal == ERROR_SUCCESS )
               {
                  dwBufLen = 0;
                  lRetVal = RegQueryValueEx( hKey,
                                             _TEXT( "ProductType" ),
                                             NULL,
                                             NULL,
                                             NULL,
                                             &dwBufLen );
                  if( lRetVal == ERROR_SUCCESS )
                  {
                     lpData = (BYTE *) hb_xgrab( (UINT) ( (int) dwBufLen + 1 ) );
                     lRetVal = RegQueryValueEx( hKey,
                                                _TEXT( "ProductType" ),
                                                NULL,
                                                NULL,
                                                lpData,
                                                &dwBufLen );
                     if( lRetVal != ERROR_SUCCESS )
                     {
                        hb_xfree( lpData );
                        lstrcat( szVersion, _TEXT( "Unknown Operating System" ) );
                     }
                  }
                  else
                     lstrcat( szVersion, _TEXT( "Unknown Operating System" ) );
               }
               RegCloseKey( hKey );

               if( lstrcmp( szVersion, _TEXT( "Unknown Operating System" ) ) != 0 )
               {
                  if( lstrcmpi( _TEXT( "WINNT" ), (char *) lpData ) == 0 )
                     lstrcat( szVersionEx, _TEXT( "Workstation " ) );
                  if( lstrcmpi( _TEXT( "LANMANNT" ), (char *) lpData  ) == 0 )
                     lstrcat( szVersionEx, _TEXT( "Server " ) );
                  if( lstrcmpi( _TEXT( "SERVERNT" ), (char *) lpData  ) == 0 )
                     lstrcat( szVersionEx, _TEXT( "Advanced Server " ) );

                  szVersion = lstrcat( szVersion, _OOHG_ULTOA( osvi.dwMajorVersion, buffer, 10 ) );
                  szVersion = lstrcat( szVersion, _TEXT( "." ) );
                  szVersion = lstrcat( szVersion, _OOHG_ULTOA( osvi.dwMinorVersion, buffer, 10 ) );
               }
            }

            if( osvi.dwMajorVersion == 10 )
            {
               lRetVal = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
                                       _TEXT( "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion" ),
                                       0,
                                       KEY_QUERY_VALUE,
                                       &hKey);
               if( lRetVal == ERROR_SUCCESS )
               {
                  dwBufLen = 0;
                  lRetVal = RegQueryValueEx( hKey,
                                             _TEXT( "ReleaseId" ),
                                             NULL,
                                             NULL,
                                             NULL,
                                             &dwBufLen );
                  if( lRetVal == ERROR_SUCCESS )
                  {
                     lpData = (BYTE *) hb_xgrab( (UINT) ( (int) dwBufLen + 1 ) );
                     lRetVal = RegQueryValueEx( hKey,
                                                _TEXT( "ReleaseId" ),
                                                NULL,
                                                NULL,
                                                (BYTE *) lpData,
                                                &dwBufLen );
                     if( lRetVal == ERROR_SUCCESS )
                     {
                        szServicePack = (char *) lpData;
                        /* Add UBR */
                        dwBufLen = sizeof( dwUBR );
                        lRetVal = RegQueryValueEx( hKey,
                                                   _TEXT( "UBR" ),
                                                   NULL,
                                                   NULL,
                                                   (BYTE *) &dwUBR,
                                                   &dwBufLen );
                        if( lRetVal == ERROR_SUCCESS )
                        {
                           szServicePack = lstrcat( szServicePack, _TEXT( "." ) );
                           szServicePack = lstrcat( szServicePack, _OOHG_ULTOA( dwUBR, buffer, 10 ) );
                        }
                     }
                     else
                        hb_xfree( (BYTE *) lpData );
                  }
               }
               RegCloseKey( hKey );
               szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0xFFFF, buffer, 10 );
            }
            else if( osvi.dwMajorVersion == 4 && lstrcmpi( osvi.szCSDVersion, _TEXT( "Service Pack 6" ) ) == 0 )
            {
               lRetVal = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
                                       _TEXT( "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Hotfix\\Q246009" ),
                                       0,
                                       KEY_QUERY_VALUE,
                                       &hKey );
               if( lRetVal == ERROR_SUCCESS )
               {
                  lstrcat( szServicePack, _TEXT( "Service Pack 6a" ) );
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
               if( osvi.szCSDVersion[1] == 'B' )
               {
                  lstrcat( szVersion, _TEXT( "Windows 95 B" ) );
                  lstrcat( szServicePack, _TEXT( "OSR2" ) );
               }
               else
               {
                  if( osvi.szCSDVersion[1] == _TEXT( 'C' ) )
                  {
                     lstrcat( szVersion, _TEXT( "Windows 95 C" ) );
                     lstrcat( szServicePack, _TEXT( "OSR2" ) );
                  }
                  else
                  {
                     lstrcat( szVersion, _TEXT( "Windows 95" ) );
                     lstrcat( szServicePack, _TEXT( "OSR1" ) );
                  }
               }
               szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }
            if( ( osvi.dwMajorVersion == 4 ) && ( osvi.dwMinorVersion == 10 ) )
            {
               if( osvi.szCSDVersion[1] == 'A' )
               {
                  lstrcat( szVersion, _TEXT( "Windows 98 A" ) );
                  lstrcat( szServicePack, _TEXT( "Second Edition" ) );
               }
               else
               {
                  lstrcat( szVersion, _TEXT( "Windows 98" ) );
                  lstrcat( szServicePack, _TEXT( "First Edition" ) );
               }
               szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }
            if( ( osvi.dwMajorVersion == 4 ) && ( osvi.dwMinorVersion == 90 ) )
            {
               lstrcat( szVersion, _TEXT( "Windows ME" ) );
               szBuild = _OOHG_ULTOA( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }
            break;
      }
   }

   hb_reta( 4 );
   HB_STORC( szVersion, -1, 1 );
   HB_STORC( szServicePack, -1, 2 );
   HB_STORC( szBuild, -1, 3 );
   HB_STORC( szVersionEx, -1, 4 );
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
   char buffer[ MAX_PATH + 1 ] = {0};
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

LPWSTR AnsiToWide( const char * szString )
{
   int iLen;
   LPWSTR szWide;

   iLen = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, szString, -1, NULL, 0 );
   szWide = ( LPWSTR ) hb_xgrab( (UINT) ( iLen ) * sizeof( WCHAR ) );
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
typedef HRESULT ( WINAPI * CALL_DRAWTHEMEBACKGROUND ) ( HTHEME, HDC, INT, INT, const RECT *, const RECT * );
typedef HRESULT ( WINAPI * CALL_DRAWTHEMEPARENTBACKGROUND ) ( HWND, HDC, const RECT * );
typedef HRESULT ( WINAPI * CALL_DRAWTHEMETEXTEX ) ( HTHEME, HDC, INT, INT, LPCWSTR, INT, DWORD, const RECT *, const DTTOPTS * pOptions );
typedef HRESULT ( WINAPI * CALL_DRAWTHEMETEXT ) ( HTHEME, HDC, INT, INT, LPCWSTR, INT, DWORD, DWORD, const RECT * );
typedef HRESULT ( WINAPI * CALL_GETTHEMEBACKGROUNDCONTENTRECT ) ( HTHEME, HDC, INT, INT, const RECT *, RECT * );
typedef HRESULT ( WINAPI * CALL_GETTHEMEMARGINS ) ( HTHEME, HDC, INT, INT, INT, LPCRECT, MARGINS * );
typedef HRESULT ( WINAPI * CALL_GETTHEMEPARTSIZE ) ( HTHEME, HDC, INT, INT, const RECT *, THEMESIZE, SIZE * );
typedef BOOL    ( WINAPI * CALL_ISTHEMEBACKGROUNDPARTIALLYTRANSPARENT ) ( HTHEME, INT, INT );
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETKNOWNFOLDER )          /* FUNCTION GETKNOWNFOLDER( nFOLDERID ) -> cPath */
{
   PWSTR path = NULL;
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

   if( SUCCEEDED( SHGetKnownFolderPath( id[ hb_parni( 1 ) - 1 ], 0, NULL, &path ) ) )
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
