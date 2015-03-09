/*
 * $Id: Readme.txt,v 1.3 2015-03-09 02:52:05 fyurisich Exp $
 */

(c)2011-2015 MigSoft Project Manager based upon
2003(c) MPM (MiniGUI Project Manager) by Roberto Lopez

MPM is a visual tool intented to speed up the application building process.
It uses MAKE tool bundled with C compiler.

This way, only modified files are recompiled speeding building process a lot.

Environment settings (C Folder, Harbour Folder, GUI Folder and Program Editor)
are stored in "MPM.INI" file, located at MPM folder.

This file is created the first time you run MPM and automatically updated.

The resource file ".RC" must have the same file name ".PRG" selected as the top.

The project file ".MPM" contains the file list ".PRG"
that are part of the application and settings of how to build.

If the files ".FMG" are in a different folder to the project,
indicate the path in the first tab "Include Search Path".

xBase compiler flags, c compiler and  linker,
takes its default value when you sets the textbox empty.

MPM autodetects the GUI according to the specified path and
linked only the libraries that exist in the specified directory

MPM used this tools for build ".exe"

MinGW  =>  mingw32-make.exe
Borland  => make.exe
MSVC => nmake.exe
Pelles => pomake.exe
