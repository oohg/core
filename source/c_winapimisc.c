/*
 * $Id: c_winapimisc.c,v 1.20 2013-07-25 21:01:39 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Windows API calls
 *
 * Copyright 2005-2010 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
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
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

 "Harbour GUI framework for Win32"
 Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 Copyright 2001 Antonio Linares <alinares@fivetech.com>
 www - http://www.harbour-project.org

 "Harbour Project"
 Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <shlobj.h>
// #include <stdlib.h>
#ifdef __MINGW32__
   #define ultoa    _ultoa
#endif

#include <windows.h>
#include <lmcons.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"
#include "hbapifs.h"
#include "oohg.h"

#ifdef __XHARBOUR__
   #define HB_FHANDLE FHANDLE
#endif

BOOL SysRefresh( void );

/*WaitRun function For minigui With Pipe redirection
Author Luiz Rafael Culik Guimaraes: culikr@uol.com.br
Parameters WaitRunPipe(cCommand,nShowWindow,cFile)
*/

HB_FUNC( WAITRUNPIPE )
{
   STARTUPINFO StartupInfo;
   PROCESS_INFORMATION ProcessInfo;
   HANDLE ReadPipeHandle;
   HANDLE WritePipeHandle;       // not used here
   char Data[1024];
   char *szFile = (char *) hb_parc( 3 );
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
   StartupInfo.dwFlags = STARTF_USESHOWWINDOW |STARTF_USESTDHANDLES;
   StartupInfo.wShowWindow = (SHORT) hb_parni( 2 );
   StartupInfo.hStdOutput = WritePipeHandle;
   StartupInfo.hStdError = WritePipeHandle;

   if( ! CreateProcess( 0, (char *) hb_parc( 1 ), 0, 0, FALSE,
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

      //Check for the presence of data in the pipe
      if( ! PeekNamedPipe( ReadPipeHandle, Data, sizeof( Data ), &BytesRead, &TotalBytes, &BytesLeft ) )
      {
         hb_retnl( -1 );
      }

      //If there is bytes, read them
      if( BytesRead )
      {
         if( ! ReadFile( ReadPipeHandle, Data, sizeof( Data ) - 1, &BytesRead, NULL ) )
         {
            hb_retnl(-1);
         }
         Data[ BytesRead ] = '\0';
         hb_fsWriteLarge( nHandle, (BYTE *) Data, BytesRead );
      }
      else
      {
         //Is the console app terminated?
         if( WaitForSingleObject( ProcessInfo.hProcess, 0) == WAIT_OBJECT_0 )
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

HB_FUNC( GET_WHEEL_DELTA_WPARAM )
{
   hb_retnl( GET_WHEEL_DELTA_WPARAM( hb_parnl( 1 ) ) );
}

HB_FUNC( C_GETFOLDER ) // Based Upon Code Contributed By Ryszard Ryüko
{
   HWND hwnd = GetActiveWindow();
   BROWSEINFO bi;
   char *lpBuffer = (char*) hb_xgrab( MAX_PATH + 1 );
   LPITEMIDLIST pidlBrowse;    // PIDL selected by user

   bi.hwndOwner = hwnd;
   bi.pidlRoot = NULL;
   bi.pszDisplayName = lpBuffer;
   bi.lpszTitle = (char *) hb_parc( 1 );
   bi.ulFlags = 0;
   bi.lpfn = NULL;
   bi.lParam = 0;

   // Browse for a folder and return its PIDL.
   pidlBrowse = SHBrowseForFolder( &bi );
   SHGetPathFromIDList( pidlBrowse, lpBuffer );
   hb_retc( lpBuffer );
   hb_xfree( lpBuffer );
}

HB_FUNC( C_GETSPECIALFOLDER ) // Contributed By Ryszard Ryüko
{
   char *lpBuffer = (char*) hb_xgrab( MAX_PATH + 1 );
   LPITEMIDLIST pidlBrowse;    // PIDL selected by user
   SHGetSpecialFolderLocation( GetActiveWindow(), hb_parni( 1 ) , &pidlBrowse );
   SHGetPathFromIDList( pidlBrowse, lpBuffer );
   hb_retc( lpBuffer );
   hb_xfree( lpBuffer );
}

HB_FUNC( MEMORYSTATUS )
{
   MEMORYSTATUS mst;
   long n = hb_parnl( 1 );

   mst.dwLength = sizeof( MEMORYSTATUS );
   GlobalMemoryStatus( &mst );

   switch( n )
   {
      case 1:  hb_retnl( mst.dwTotalPhys     / ( 1024*1024 ) ); break;
      case 2:  hb_retnl( mst.dwAvailPhys     / ( 1024*1024 ) ); break;
      case 3:  hb_retnl( mst.dwTotalPageFile / ( 1024*1024 ) ); break;
      case 4:  hb_retnl( mst.dwAvailPageFile / ( 1024*1024 ) ); break;
      case 5:  hb_retnl( mst.dwTotalVirtual  / ( 1024*1024 ) ); break;
      case 6:  hb_retnl( mst.dwAvailVirtual  / ( 1024*1024 ) ); break;
      default: hb_retnl( 0 );
   }
}

HB_FUNC( SHELLABOUT )
{
   ShellAbout( 0, hb_parc( 1 ), hb_parc( 2 ), (HICON) hb_parnl(3) );
}

HB_FUNC( PAINTBKGND )
{
   HWND hwnd;
   HBRUSH brush;
   RECT recClie;
   HDC hdc;

   hwnd = HWNDparam( 1 );
   hdc  = GetDC( hwnd );

   GetClientRect( hwnd, &recClie );

   if( ( hb_pcount() > 1 ) && ( ! HB_ISNIL( 2 ) ) )
   {
      brush = CreateSolidBrush( RGB( HB_PARNI( 2, 1 ),
                                     HB_PARNI( 2, 2 ),
                                     HB_PARNI( 2, 3 ) ) );
      FillRect( hdc, &recClie, brush );
      DeleteObject( brush );
   }
   else
   {
      brush = (HBRUSH) (COLOR_BTNFACE + 1);
      FillRect( hdc, &recClie, brush );
   }

   ReleaseDC( hwnd, hdc );
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
   hb_retc(szBuffer);
}

HB_FUNC( GETTEMPDIR )
{
   char szBuffer[ MAX_PATH + 1 ] = {0};
   GetTempPath( MAX_PATH, szBuffer );
   hb_retc( szBuffer );
}

HB_FUNC ( POSTMESSAGE )
{
   hb_retnl( (LONG) PostMessage( HWNDparam( 1 ),
                                 (UINT) hb_parni( 2 ),
                                 (WPARAM) hb_parnl( 3 ),
                                 (LPARAM) hb_parnl( 4 ) ) );
}

HB_FUNC ( DEFWINDOWPROC )
{
   hb_retnl( (LONG) DefWindowProc( HWNDparam( 1 ),
                                   (UINT) hb_parni( 2 ),
                                   (WPARAM) hb_parnl( 3 ),
                                   (LPARAM) hb_parnl( 4 ) ) );
}

HB_FUNC ( DEFFRAMEPROC )
{
   hb_retnl( (LONG) DefFrameProc( HWNDparam( 1 ),
                                  HWNDparam( 2 ),
                                  (UINT) hb_parni( 3 ),
                                  (WPARAM) hb_parnl( 4 ),
                                  (LPARAM) hb_parnl( 5 ) ) );
}

HB_FUNC ( DEFMDICHILDPROC )
{
   hb_retnl( (LONG) DefMDIChildProc( HWNDparam( 1 ),
                                     (UINT) hb_parni( 2 ),
                                     (WPARAM) hb_parnl( 3 ),
                                     (LPARAM) hb_parnl( 4 ) ) );
}

HB_FUNC( GETSTOCKOBJECT )
{
   hb_retnl( (LONG) GetStockObject( hb_parni( 1 ) ) );
}

HB_FUNC( SETBKMODE )
{
   hb_retni( SetBkMode( (HDC) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( GETNEXTDLGTABITEM )
{
   HWNDret( GetNextDlgTabItem( HWNDparam( 1 ), HWNDparam( 2 ), hb_parl( 3 ) ) );
}

HB_FUNC( SHELLEXECUTE )
{
   hb_retnl( (LONG) ShellExecute( HWNDparam( 1 ), HB_ISNIL( 2 ) ? NULL : (LPCSTR) hb_parc( 2 ),(LPCSTR) hb_parc( 3 ), HB_ISNIL( 4 ) ? NULL : (LPCSTR) hb_parc( 4 ), HB_ISNIL( 5 ) ? NULL : (LPCSTR) hb_parc( 5 ), hb_parni( 6 ) ) );
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
   stInfo.wShowWindow = (SHORT) hb_parni( 2 );

   bResult = CreateProcess( NULL,
                            (char *) hb_parc( 1 ),
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
      hb_retl( -1 );
   }

   WaitForSingleObject( prInfo.hProcess, INFINITE );

   GetExitCodeProcess( prInfo.hProcess, &dwExitCode );

   hb_retnl( dwExitCode );
}

HB_FUNC( CREATEMUTEX )
{
   SECURITY_ATTRIBUTES *sa = NULL;

   if( HB_ISCHAR( 2 ) && ! HB_ISNIL( 1 ) )
   {
      sa = (SECURITY_ATTRIBUTES *) hb_itemGetCPtr( hb_param( 1, HB_IT_STRING ) );
   }

   hb_retnl( (ULONG) CreateMutex( sa, hb_parnl( 2 ), hb_parc( 3 ) ) );
}

#ifndef __XHARBOUR__

HB_FUNC( GETLASTERROR )
{
   hb_retnl( (LONG) GetLastError() );
}

#endif

HB_FUNC ( CREATEFOLDER )
{
   CreateDirectory( (LPCTSTR) hb_parc( 1 ) , NULL );
}

HB_FUNC ( SETCURRENTFOLDER )
{
   SetCurrentDirectory( (LPCTSTR) hb_parc( 1 ) );
}

HB_FUNC( REMOVEFOLDER )
{
   hb_retl( RemoveDirectory( (LPCSTR) hb_parc( 1 ) ) );
}

HB_FUNC( GETCURRENTFOLDER )
{
   char Path[ MAX_PATH + 1 ] = {0};
   GetCurrentDirectory( MAX_PATH , (LPSTR) Path );
   hb_retc( Path );
}

HB_FUNC( CREATESOLIDBRUSH )
{
   hb_retnl( (LONG) CreateSolidBrush( (COLORREF) RGB( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) ) );
}

HB_FUNC( SETTEXTCOLOR )
{
   hb_retnl( (ULONG) SetTextColor( (HDC) hb_parnl( 1 ), (COLORREF) RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) ) );
}

HB_FUNC( SETBKCOLOR )
{
   hb_retnl( (ULONG) SetBkColor( (HDC) hb_parnl( 1 ), (COLORREF) RGB( hb_parni( 2 ), hb_parni( 3 ), hb_parni( 4 ) ) ) );
}

HB_FUNC ( GETSYSCOLOR )
{
   hb_retnl( GetSysColor( hb_parni( 1 ) ) );
}

HB_FUNC ( SETWINDOWLONG )
{
   hb_retnl( SetWindowLong( HWNDparam( 1 ), hb_parni( 2 ), hb_parnl( 3 ) ) );
}

/**************************************************************************************/
/*                                                                                    */
/*  This function returns the Windows Version on which the app calling the function   */
/*  is running.                                                                       */
/*                                                                                    */
/*  The return value is an three dimensi0nal array containing the OS in the first,    */
/*  the servicepack or the system release number in the second and the build number   */
/*  in the third array element.                                                       */
/*                                                                                    */
/**************************************************************************************/

HB_FUNC( WINVERSION )
{
   #ifndef VER_SUITE_PERSONAL
      #define VER_SUITE_PERSONAL 0x00000200
   #endif
   #ifndef VER_SUITE_BLADE
      #define VER_SUITE_BLADE    0x00000400
   #endif

   OSVERSIONINFOEX osvi;
   BOOL bOsVersionInfoEx;
   CHAR *szVersion = NULL;
   CHAR *szServicePack = NULL;
   CHAR *szBuild = NULL;
   CHAR buffer[5];
   CHAR *szVersionEx = NULL;

   ZeroMemory( &osvi, sizeof( OSVERSIONINFOEX ) );
   osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFOEX );

   bOsVersionInfoEx = GetVersionEx( (OSVERSIONINFO *) &osvi );
   if( ! bOsVersionInfoEx )
   {
      osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
      if( ! GetVersionEx( (OSVERSIONINFO *) &osvi ) )
      {
         szVersion = "Unknown Operating System";
      }
   }

   if( szVersion == NULL )
   {
      switch( osvi.dwPlatformId )
      {
         case VER_PLATFORM_WIN32_NT:
            if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 2 && osvi.wProductType != VER_NT_WORKSTATION )
            {
               szVersion = "Windows Server 2012 ";
            }
            if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 2 && osvi.wProductType == VER_NT_WORKSTATION )
            {
               szVersion = "Windows 8 ";
            }
            if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 1 && osvi.wProductType != VER_NT_WORKSTATION )
            {
               szVersion = "Windows Server 2008 R2 ";
            }
            if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 1 && osvi.wProductType == VER_NT_WORKSTATION )
            {
               szVersion = "Windows 7 ";
            }
            if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0 && osvi.wProductType != VER_NT_WORKSTATION )
            {
               szVersion = "Windows Server 2008 ";
            }
            if( osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 0 && osvi.wProductType == VER_NT_WORKSTATION )
            {
               szVersion = "Windows Vista ";
            }
            if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2 )
            {
               szVersion = "Windows Server 2003 family ";
            }
            if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1 )
            {
               szVersion = "Windows XP ";
            }
            if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0 )
            {
               szVersion = "Windows 2000 ";
            }
            if( osvi.dwMajorVersion <= 4 )
            {
               szVersion = "Windows NT ";
            }

            if( bOsVersionInfoEx )
            {
               if( osvi.wProductType == VER_NT_WORKSTATION )
               {
                  if( osvi.dwMajorVersion == 4 )
                  {
                     szVersionEx = "Workstation 4.0 ";
                  }
                  else if( osvi.wSuiteMask & VER_SUITE_PERSONAL )
                  {
                     szVersionEx = "Home Edition ";
                  }
                  else
                  {
                     szVersionEx = "Professional ";
                  }
               }
               else if( osvi.wProductType == VER_NT_SERVER )
               {
                  if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2 )
                  {
                     if( osvi.wSuiteMask & VER_SUITE_DATACENTER )
                     {
                        szVersionEx = "Datacenter Edition ";
                     }
                     else if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                     {
                        szVersionEx = "Enterprise Edition ";
                     }
                     else if( osvi.wSuiteMask & VER_SUITE_BLADE )
                     {
                        szVersionEx = "Web Edition ";
                     }
                     else
                     {
                        szVersionEx = "Standard Edition ";
                     }
                  }
                  else if( osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0 )
                  {
                     if( osvi.wSuiteMask & VER_SUITE_DATACENTER )
                     {
                        szVersionEx = "Datacenter Server ";
                     }
                     else if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                     {
                        szVersionEx = "Advanced Server ";
                     }
                     else
                     {
                        szVersionEx = "Server ";
                     }
                  }
                  else
                  {
                     if( osvi.wSuiteMask & VER_SUITE_ENTERPRISE )
                     {
                        szVersionEx = "Server 4.0, Enterprise Edition ";
                     }
                     else
                     {
                        szVersionEx = "Server 4.0 ";
                     }
                  }
               }
            }
            else
            {
               HKEY hKey;
               char szProductType[ 80 ];
               DWORD dwBufLen = 80;
               LONG lRetVal;

               lRetVal = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
                                       "SYSTEM\\CurrentControlSet\\Control\\ProductOptions",
                                       0,
                                       KEY_QUERY_VALUE,
                                       &hKey );

               if( lRetVal != ERROR_SUCCESS )
               {
                  szVersion = "Unknown Operating System";
               }
               else
               {
                  lRetVal = RegQueryValueEx( hKey,
                                             "ProductType",
                                             NULL,
                                             NULL,
                                             (LPBYTE) szProductType,
                                             &dwBufLen );

                  if( ( lRetVal != ERROR_SUCCESS ) || ( dwBufLen > 80 ) )
                  {
                     szVersion = "Unknown Operating System";
                  }
               }
               RegCloseKey( hKey );

               if( szVersion != (CHAR *) "Unknown Operating System" )
               {
                  if( lstrcmpi( "WINNT", szProductType ) == 0 )
                  {
                     szVersionEx = "Workstation ";
                  }
                  if( lstrcmpi( "LANMANNT", szProductType ) == 0 )
                  {
                     szVersionEx = "Server ";
                  }
                  if( lstrcmpi( "SERVERNT", szProductType) == 0 )
                  {
                     szVersionEx = "Advanced Server ";
                  }

                  szVersion = strcat( szVersion, ultoa( osvi.dwMajorVersion, buffer, 10 ) );
                  szVersion = strcat( szVersion, "." );
                  szVersion = strcat( szVersion, ultoa( osvi.dwMinorVersion, buffer, 10 ) );
               }
            }

            if( osvi.dwMajorVersion == 4 && lstrcmpi( osvi.szCSDVersion, "Service Pack 6" ) == 0 )
            {
               HKEY hKey;
               LONG lRetVal;

               lRetVal = RegOpenKeyEx( HKEY_LOCAL_MACHINE,
                                       "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Hotfix\\Q246009",
                                       0,
                                       KEY_QUERY_VALUE,
                                       &hKey );
               if( lRetVal == ERROR_SUCCESS )
               {
                  szServicePack = "Service Pack 6a";
                  szBuild = ultoa( osvi.dwBuildNumber & 0xFFFF, buffer, 10 );
               }
               else
               {
                  szServicePack = osvi.szCSDVersion;
                  szBuild = ultoa( osvi.dwBuildNumber & 0xFFFF, buffer, 10 );
               }
               RegCloseKey( hKey );
            }
            else
            {
               szServicePack = osvi.szCSDVersion;
               szBuild = ultoa( osvi.dwBuildNumber & 0xFFFF, buffer, 10 );
            }
            break;

         case VER_PLATFORM_WIN32_WINDOWS:
            if( ( osvi.dwMajorVersion == 4 ) && ( osvi.dwMinorVersion == 0 ) )
            {
               if( osvi.szCSDVersion[ 1 ] == 'B' )
               {
                  szVersion = "Windows 95 B";
                  szServicePack = "OSR2";
               }
               else
               {
                  if( osvi.szCSDVersion[ 1 ] == 'C' )
                  {
                     szVersion = "Windows 95 C";
                     szServicePack = "OSR2";
                  }
                  else
                  {
                     szVersion = "Windows 95";
                     szServicePack = "OSR1";
                  }
               }
               szBuild = ultoa( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }
            if( ( osvi.dwMajorVersion == 4 ) && ( osvi.dwMinorVersion == 10 ) )
            {
               if( osvi.szCSDVersion[ 1 ] == 'A' )
               {
                  szVersion = "Windows 98 A";
                  szServicePack = "Second Edition";
               }
               else
               {
                  szVersion = "Windows 98";
                  szServicePack = "First Edition";
               }

               szBuild = ultoa( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }
            if( ( osvi.dwMajorVersion == 4 ) && ( osvi.dwMinorVersion == 90 ) )
            {
               szVersion = "Windows ME";
               szBuild = ultoa( osvi.dwBuildNumber & 0x0000FFFF, buffer, 10 );
            }
            break;
      }
   }

   hb_reta( 4 );
   HB_STORC( szVersion , -1, 1 );
   HB_STORC( szServicePack, -1, 2 );
   HB_STORC( szBuild, -1, 3 );
   HB_STORC( szVersionEx, -1, 4 );
}

HB_FUNC( SETWINDOWPOS )
{
   hb_retl( SetWindowPos( HWNDparam( 1 ), HWNDparam( 2 ), hb_parni( 4 ), hb_parni( 3 ), hb_parni( 5 ), hb_parni( 6 ), hb_parni( 7 ) ) );
}


HB_FUNC ( GETCOMPUTERNAME )
{
   TCHAR lpBuffer[129];
   DWORD nSize = 128;
   GetComputerName( lpBuffer, &nSize );
   hb_retc( lpBuffer );
}

HB_FUNC ( GETUSERNAME )
{
   TCHAR lpBuffer[ UNLEN + 1 ];
   DWORD nSize = UNLEN;
   GetUserName( lpBuffer, &nSize );
   hb_retc( lpBuffer );
}

// Jacek Kubica <kubica@wssk.wroc.pl> HMG 1.1 Experimental Build 11a

HB_FUNC ( GETSHORTPATHNAME )
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
   hb_retnl( iRet );
}

