/*
 * $Id: i_misc.ch,v 1.7 2017-08-25 19:26:28 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Miscelaneous definitions
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
BROWSEINFO FLAGS FOR BrowseForFolder() (contributed by Richard Rylco)
http://msdn.microsoft.com/en-us/library/windows/desktop/bb773205(v=vs.85).aspx
---------------------------------------------------------------------------*/

#define BIF_RETURNONLYFSDIRS          0x0001
#define BIF_DONTGOBELOWDOMAIN         0x0002
#define BIF_STATUSTEXT                0x0004
#define BIF_RETURNFSANCESTORS         0x0008
#define BIF_EDITBOX                   0x0010
#define BIF_VALIDATE                  0x0020
#define BIF_NEWDIALOGSTYLE            0x0040
#define BIF_USENEWUI                  ( BIF_NEWDIALOGSTYLE + BIF_EDITBOX )
#define BIF_BROWSEINCLUDEURLS         0x0080
#define BIF_BROWSEFORCOMPUTER         0x1000
#define BIF_BROWSEFORPRINTER          0x2000
#define BIF_BROWSEINCLUDEFILES        0x4000
#define BIF_SHAREABLE                 0x8000

/*---------------------------------------------------------------------------
SPECIAL FOLDERS (contributed by Richard Rylco)
http://msdn.microsoft.com/en-us/library/windows/desktop/bb762494(v=vs.85).aspx
---------------------------------------------------------------------------*/

#define CSIDL_DESKTOP                 0x0000
#define CSIDL_INTERNET                0x0001
#define CSIDL_PROGRAMS                0x0002
#define CSIDL_CONTROLS                0x0003
#define CSIDL_PRINTERS                0x0004
#define CSIDL_PERSONAL                0x0005
#define CSIDL_FAVORITES               0x0006
#define CSIDL_STARTUP                 0x0007
#define CSIDL_RECENT                  0x0008
#define CSIDL_SENDTO                  0x0009
#define CSIDL_BITBUCKET               0x000a
#define CSIDL_STARTMENU               0x000b
#define CSIDL_DESKTOPDIRECTORY        0x0010
#define CSIDL_DRIVES                  0x0011
#define CSIDL_NETWORK                 0x0012
#define CSIDL_NETHOOD                 0x0013
#define CSIDL_FONTS                   0x0014
#define CSIDL_TEMPLATES               0x0015
#define CSIDL_COMMON_STARTMENU        0x0016
#define CSIDL_COMMON_PROGRAMS         0X0017
#define CSIDL_COMMON_STARTUP          0x0018
#define CSIDL_COMMON_DESKTOPDIRECTORY 0x0019
#define CSIDL_APPDATA                 0x001a
#define CSIDL_PRINTHOOD               0x001b
#define CSIDL_LOCAL_APPDATA           0x001c
#define CSIDL_ALTSTARTUP              0x001d
#define CSIDL_COMMON_ALTSTARTUP       0x001e
#define CSIDL_COMMON_FAVORITES        0x001f
#define CSIDL_INTERNET_CACHE          0x0020
#define CSIDL_COOKIES                 0x0021
#define CSIDL_HISTORY                 0x0022
#define CSIDL_COMMON_APPDATA          0x0023
#define CSIDL_WINDOWS                 0x0024
#define CSIDL_SYSTEM                  0x0025
#define CSIDL_PROGRAM_FILES           0x0026
#define CSIDL_MYPICTURES              0x0027
#define CSIDL_PROFILE                 0x0028
#define CSIDL_SYSTEMX86               0x0029
#define CSIDL_PROGRAM_FILESX86        0x002a
#define CSIDL_PROGRAM_FILES_COMMON    0x002b
#define CSIDL_PROGRAM_FILES_COMMONX86 0x002c
#define CSIDL_COMMON_TEMPLATES        0x002d
#define CSIDL_COMMON_DOCUMENTS        0x002e
#define CSIDL_COMMON_ADMINTOOLS       0x002f
#define CSIDL_ADMINTOOLS              0x0030
#define CSIDL_CONNECTIONS             0x0031
#define CSIDL_FLAG_CREATE             0x8000
#define CSIDL_FLAG_DONT_VERIFY        0x4000
#define CSIDL_FLAG_MASK               0xFF00
