/*
 * $Id: i_registry.ch $
 */
/*
 * ooHG source code:
 * Registry definitions
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
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


/*---------------------------------------------------------------------------
THIS DEFINES ARE PART OF THE "REGISTRY FUNCTIONS FOR HARBOUR"
Contributed by Luiz Rafael Culik <culik@sl.conex.net>)
---------------------------------------------------------------------------*/

#ifndef _REGISTRY_CH
#define _REGISTRY_CH

/*---------------------------------------------------------------------------
REGISTRY KEYS
---------------------------------------------------------------------------*/

#define HKEY_CLASSES_ROOT        2147483648 // 0x80000000
#define HKEY_CURRENT_USER        2147483649 // 0x80000001
#define HKEY_LOCAL_MACHINE       2147483650 // 0x80000002
#define HKEY_USERS               2147483651 // 0x80000003
#define HKEY_PERFORMANCE_DATA    2147483652 // 0x80000004
#define HKEY_CURRENT_CONFIG      2147483653 // 0x80000005
#define HKEY_DYN_DATA            2147483654 // 0x80000006

/*---------------------------------------------------------------------------
MASKS FOR STANDARD ACCESS TYPES
---------------------------------------------------------------------------*/

#define SYNCHRONIZE              1048576    // 0x00100000L
#define STANDARD_RIGHTS_READ     131072     // 0x00020000L
#define STANDARD_RIGHTS_WRITE    131072     // 0x00020000L
#define STANDARD_RIGHTS_ALL      2031616    // 0x001F0000L

/*---------------------------------------------------------------------------
REGISTRY SPECIFIC ACCESS RIGHTS
http://msdn.microsoft.com/en-us/library/windows/desktop/ms724878(v=vs.85).aspx
http://msdn.microsoft.com/en-us/library/windows/desktop/aa379607(v=vs.85).aspx
TODO: Check KEY_READ, KEY_EXECUTE and KEY_ALL_ACCESS defines.
      Their values do not correspond with the ones in the article.
---------------------------------------------------------------------------*/

#define KEY_QUERY_VALUE          1          // Query the values of a key.
#define KEY_SET_VALUE            2          // Create, delete, or set a value.
#define KEY_CREATE_SUB_KEY       4          // Create a subkey of a key.
#define KEY_ENUMERATE_SUB_KEYS   8          // Enumerate the subkeys of a key.
#define KEY_NOTIFY               16         // Request change notifications.
#define KEY_CREATE_LINK          32         // Reserved for system use.
#define KEY_READ                 25         // Read, query, enumerate and notify.
#define KEY_WRITE                6          // Create, set and write.
#define KEY_EXECUTE              25         // Read, query, enumerate and notify.
#define KEY_ALL_ACCESS           63         // All actions.

/*---------------------------------------------------------------------------
VALUE TYPES
http://msdn.microsoft.com/en-us/library/windows/desktop/ms724884(v=vs.85).aspx
---------------------------------------------------------------------------*/

#define REG_NONE                 0          // No value type.
#define REG_SZ                   1          // String.
#define REG_EXPAND_SZ            2          // String with envvar.
#define REG_BINARY               3          // Binary.
#define REG_DWORD                4          // A 32-bit number
#define REG_DWORD_BIG_ENDIAN     5          // A 32-bit number
#define REG_LINK                 6          // Symbolic link.
#define REG_MULTI_SZ             7          // Array of strings.
#define REG_RESOURCE_LIST        8          // Resource list.

#endif

/*---------------------------------------------------------------------------
END OF DEFINES FROM THE "REGISTRY FUNCTIONS FOR HARBOUR"
---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
ERROR CODES
---------------------------------------------------------------------------*/

#define ERROR_SUCCESS            0
#define ERROR_FILE_NOT_FOUND     2
#define ERROR_ACCESS_DENIED      5
#define ERROR_OUTOFMEMORY        14
#define ERROR_NOT_SUPPORTED      50
#define ERROR_INVALID_PARAMETER  87
#define ERROR_LOCK_FAILED        167
#define ERROR_MORE_DATA          234
#define ERROR_NO_MORE_ITEMS      259
#define ERROR_BADDB              1009
#define ERROR_BADKEY             1010
#define ERROR_CANTOPEN           1011
#define ERROR_CANTREAD           1012
#define ERROR_CANTWRITE          1013
#define ERROR_REGISTRY_CORRUPT   1015
#define ERROR_REGISTRY_IO_FAILED 1016
#define ERROR_KEY_DELETED        1018

/*---------------------------------------------------------------------------
DISPOSITION VALUES
---------------------------------------------------------------------------*/

#define REG_CREATED_NEW_KEY      1          // Key did not exist and was created.
#define REG_OPENED_EXISTING_KEY  2          // Key existed and was opened.

/*---------------------------------------------------------------------------
WRAPPER COMMANDS FOR TREG32 CLASS
---------------------------------------------------------------------------*/

#xcommand OPEN REGISTRY <oReg> KEY <hKey> SECTION <cKey> ;
   => ;
      <oReg> := TReg32():Create( <hKey>, <cKey> )

#xcommand OPEN REGISTRY <oReg> KEY <hKey> SECTION <cKey> OLD ;
   => ;
      <oReg> := TReg32():New( <hKey>, <cKey> )

#xcommand CREATE REGISTRY <oReg> KEY <hKey> SECTION <cKey> ;
   => ;
      <oReg> := TReg32():Create( <hKey>, <cKey> )

#xcommand GET VALUE <uVar> [NAME <cKey> ] <of: OF, REGISTRY> <oReg> ;
   => ;
      <uVar> := <oReg>:Get( <cKey>, <uVar> )

#xcommand SET VALUE <cKey> <of: OF, REGISTRY> <oReg>] [ TO <uVal> ] ;
   => ;
      <oReg>:Set( <cKey>, <uVal> )

#xcommand DELETE VALUE <cKey> <of: OF, REGISTRY> <oReg> ;
   => ;
      <oReg>:Delete( <cKey> )

#xcommand DELETE KEY <cKey> <of: OF, REGISTRY> <oReg> ;
   => ;
      <oReg>:KeyDelete( <cKey> )

#xcommand CLOSE REGISTRY <oReg> ;
   => ;
      <oReg>:Close()
