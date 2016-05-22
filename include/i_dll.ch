/*
 * $Id: i_dll.ch,v 1.5 2016-05-22 23:52:23 fyurisich Exp $
 */
/*
 * ooHG source code:
 * DLL definitions
 *
 * Copyright 2007-2016 Vicente Guerra <vicente@guerra.com.mx>
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2016, http://www.harbour-project.org/
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
 * along with this software; see the file COPYING.TXT.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301,USA (or download from http://www.gnu.org/licenses/).
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

/*---------------------------------------------------------------------------
FLAGS
---------------------------------------------------------------------------*/

#define  DC_MICROSOFT            0x0000
#define  DC_BORLAND              0x0001
#define  DC_CALL_CDECL           0x0010
#define  DC_CALL_STD             0x0020

/*---------------------------------------------------------------------------
TYPES
---------------------------------------------------------------------------*/

#define DLL_TYPE_VOID             0
#define DLL_TYPE_UINT            -3
#define DLL_TYPE_INT              3
#define DLL_TYPE_HANDLE          -4
#define DLL_TYPE_HICON           -4
#define DLL_TYPE_HBITMAP         -4
#define DLL_TYPE_HCURSOR         -4
#define DLL_TYPE_HBRUSH          -4
#define DLL_TYPE_LPCSTR          10
#define DLL_TYPE_WNDPROC         -4
#define DLL_TYPE_BOOL             4
#define DLL_TYPE_LPVOID           7
#define DLL_TYPE_DWORD           -4
#define DLL_TYPE_WORD            -2
#define DLL_TYPE_LPCTSTR         10
#define DLL_TYPE_COLORREF        -4
#define DLL_TYPE_BYTE             1
#define DLL_TYPE_TCHAR           -1
#define DLL_TYPE_HINSTANCE       -4
#define DLL_TYPE_HWND            -4
#define DLL_TYPE_LPARAM           4
#define DLL_TYPE_HGLOBAL         -4
#define DLL_TYPE_WPARAM           3
#define DLL_TYPE_HKEY            -4
#define DLL_TYPE_CHAR            -1
#define DLL_TYPE_LONG             4
#define DLL_TYPE_BCHAR           -1
#define DLL_TYPE_WCHAR           -2
#define DLL_TYPE_DOUBLE           6
#define DLL_TYPE_LPTSTR          10
#define DLL_TYPE_LPSTR           10
#define DLL_TYPE_ULONG           -4
#define DLL_TYPE_UCHAR           -1
#define DLL_TYPE_SHORT            2
#define DLL_TYPE_USHORT          -2
#define DLL_TYPE_LPOFNHOOKPROC   -4 
#define DLL_TYPE_LPCFHOOKPROC    -4
#define DLL_TYPE_LPFRHOOKPROC    -4
#define DLL_TYPE_LPPAGESETUPHOOK -4
#define DLL_TYPE_LPPAGEPAINTHOOK -4
#define DLL_TYPE_LPPRINTHOOKPROC -4  
#define DLL_TYPE_LPSETUPHOOKPROC -4  
#define DLL_TYPE_BFFCALLBACK     -4 
#define DLL_TYPE_HDC             -4
#define DLL_TYPE_HIMAGELIST      -4

#xcommand DECLARE <return> [<static: STATIC>] <FuncName>( ;
      [ <type1> <uParam1> ] ;
      [, <typeN> <uParamN> ] ) ;
      IN <*DllName*> [ FLAGS <flags> ] ;
   => ;
      [<static>] FUNCTION <FuncName>( [<uParam1>] [,<uParamN>] ) ;;
      LOCAL uResult ;;
         uResult := CallDLL32( <(FuncName)>, <(DllName)> [, <uParam1> ] [, <uParamN> ] ) ;;
      RETURN uResult

#xcommand DECLARE <return> [<static: STATIC>] <FuncName>( ;
      [ <type1> <uParam1> ] ;
      [, <typeN> <uParamN> ] ) ;
      IN <DllName> ALIAS <alias> [ FLAGS <flags> ] ;
   => ;
      [<static>] FUNCTION <alias>( [<uParam1>] [,<uParamN>] ) ;;
      LOCAL uResult ;;
         uResult := CallDLL32( <(FuncName)>, <(DllName)> [, <uParam1> ] [, <uParamN> ] ) ;;
      RETURN uResult
