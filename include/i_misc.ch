/*
 * $Id: i_misc.ch $
 */
/*
 * ooHG source code:
 * Miscelaneous definitions
 *
 * Copyright 2005-2021 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2021 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2021 Contributors, https://harbour.github.io/
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

#define CSIDL_DESKTOP                 0x0000        // <desktop>
#define CSIDL_INTERNET                0x0001        // Internet Explorer (icon on desktop)
#define CSIDL_PROGRAMS                0x0002        // Start Menu\Programs
#define CSIDL_CONTROLS                0x0003        // My Computer\Control Panel
#define CSIDL_PRINTERS                0x0004        // My Computer\Printers
#define CSIDL_PERSONAL                0x0005        // My Documents
#define CSIDL_FAVORITES               0x0006        // <user name>\Favorites
#define CSIDL_STARTUP                 0x0007        // Start Menu\Programs\Startup
#define CSIDL_RECENT                  0x0008        // <user name>\Recent
#define CSIDL_SENDTO                  0x0009        // <user name>\SendTo
#define CSIDL_BITBUCKET               0x000a        // <desktop>\Recycle Bin
#define CSIDL_STARTMENU               0x000b        // <user name>\Start Menu
#define CSIDL_DESKTOPDIRECTORY        0x0010        // <user name>\Desktop
#define CSIDL_DRIVES                  0x0011        // My Computer
#define CSIDL_NETWORK                 0x0012        // Network Neighborhood
#define CSIDL_NETHOOD                 0x0013        // <user name>\nethood
#define CSIDL_FONTS                   0x0014        // windows\fonts
#define CSIDL_TEMPLATES               0x0015
#define CSIDL_COMMON_STARTMENU        0x0016        // All Users\Start Menu
#define CSIDL_COMMON_PROGRAMS         0X0017        // All Users\Programs
#define CSIDL_COMMON_STARTUP          0x0018        // All Users\Startup
#define CSIDL_COMMON_DESKTOPDIRECTORY 0x0019        // All Users\Desktop
#define CSIDL_APPDATA                 0x001a        // <user name>\Application Data
#define CSIDL_PRINTHOOD               0x001b        // <user name>\PrintHood
#define CSIDL_LOCAL_APPDATA           0x001c        // <user name>\Local Settings\Applicaiton Data (non roaming)
#define CSIDL_ALTSTARTUP              0x001d        // non localized startup
#define CSIDL_COMMON_ALTSTARTUP       0x001e        // non localized common startup
#define CSIDL_COMMON_FAVORITES        0x001f
#define CSIDL_INTERNET_CACHE          0x0020
#define CSIDL_COOKIES                 0x0021
#define CSIDL_HISTORY                 0x0022
#define CSIDL_COMMON_APPDATA          0x0023        // All Users\Application Data
#define CSIDL_WINDOWS                 0x0024        // GetWindowsDirectory()
#define CSIDL_SYSTEM                  0x0025        // GetSystemDirectory()
#define CSIDL_PROGRAM_FILES           0x0026        // C:\Program Files
#define CSIDL_MYPICTURES              0x0027        // C:\Program Files\My Pictures
#define CSIDL_PROFILE                 0x0028        // USERPROFILE
#define CSIDL_SYSTEMX86               0x0029        // x86 system directory on RISC
#define CSIDL_PROGRAM_FILESX86        0x002a        // x86 C:\Program Files on RISC
#define CSIDL_PROGRAM_FILES_COMMON    0x002b        // C:\Program Files\Common
#define CSIDL_PROGRAM_FILES_COMMONX86 0x002c        // x86 Program Files\Common on RISC
#define CSIDL_COMMON_TEMPLATES        0x002d        // All Users\Templates
#define CSIDL_COMMON_DOCUMENTS        0x002e        // All Users\Documents
#define CSIDL_COMMON_ADMINTOOLS       0x002f        // All Users\Start Menu\Programs\Administrative Tools
#define CSIDL_ADMINTOOLS              0x0030        // <user name>\Start Menu\Programs\Administrative Tools
#define CSIDL_CONNECTIONS             0x0031        // Network and Dial-up Connections
#define CSIDL_FLAG_CREATE             0x8000        // combine with CSIDL_ value to force folder creation in SHGetFolderPath()
#define CSIDL_FLAG_DONT_VERIFY        0x4000        // combine with CSIDL_ value to return an unverified folder path
#define CSIDL_FLAG_MASK               0xFF00        // mask for all possible flag values

/*---------------------------------------------------------------------------
Add a console window
---------------------------------------------------------------------------*/

#xcommand SET MIXEDMODE => REQUEST HB_GT_WIN_DEFAULT
