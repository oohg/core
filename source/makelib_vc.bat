@echo off
rem
rem $Id: makelib_vc.bat,v 1.6 2015-11-07 22:39:57 fyurisich Exp $
rem

:MAKELIB_VC

   cls
   rem *** Set Paths ***
   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""  set HG_HRB=c:\oohg\harbour
   if "%HG_VC%"==""   set HG_VC=%PROGRAMFILES%\Microsoft Visual Studio 9.0\vc

   rem *** Set EnvVars ***
   if "%LIB_GUI%"=="" set LIB_GUI=lib
   if "%LIB_HRB%"=="" set LIB_HRB=lib
   if "%BIN_HRB%"=="" set BIN_HRB=bin

   rem *** Change Path ***
   set _PATH=%PATH%
   set PATH="%HG_VC%\bin";%PATH%
   if exist "%HG_VC%"\vcvarsall.bat call "%HG_VC%"\vcvarsall.bat

   rem *** Create Lib Folder ***
   if not exist %HG_ROOT%\%LIB_GUI%\oohg.lib md %HG_ROOT%\%LIB_GUI% >nul

   rem *** Delete Old Libraries ***
   if exist %HG_ROOT%\%LIB_GUI%\oohg.lib      del %HG_ROOT%\%LIB_GUI%\oohg.lib
   if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib del %HG_ROOT%\%LIB_GUI%\hbprinter.lib
   if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib del %HG_ROOT%\%LIB_GUI%\miniprint.lib
   if exist %HG_ROOT%\%LIB_GUI%\bostaurus.lib del %HG_ROOT%\%LIB_GUI%\bostaurus.lib

   rem *** Compile with Harbour ***
   call common_make "%HG_HRB%\%LIB_HRB%\tip.lib"
   if errorlevel 1 goto :EXIT1_VC

   rem *** Compile with MSVC ***
   set OOHG_X_FLAGS= /O2 /c /W3 /nologo /I"%HG_VC%\include" /I"%HG_VC%\include\Win" /I%HG_HRB%\include /I%HG_ROOT%\include /D__WIN32__ /D_CRT_SECURE_NO_WARNINGS
   for %%a in (%HG_FILES1_PRG%) do if not errorlevel 1 cl %OOHG_X_FLAGS% %%a.c
   if errorlevel 1 goto :EXIT2_VC
   for %%a in (%HG_FILES2_PRG%) do if not errorlevel 1 cl %OOHG_X_FLAGS% %%a.c
   if errorlevel 1 goto :EXIT2_VC
   for %%a in (%HG_FILES_C%)    do if not errorlevel 1 cl %OOHG_X_FLAGS% %%a.c
   if errorlevel 1 goto :EXIT2_VC
   if exist winprint.c  cl %OOHG_X_FLAGS% winprint.c
   if errorlevel 1 goto :EXIT2_VC
   if exist miniprint.c cl %OOHG_X_FLAGS% miniprint.c
   if errorlevel 1 goto :EXIT2_VC
   if exist bostaurus.c cl %OOHG_X_FLAGS% bostaurus.c
   if errorlevel 1 goto :EXIT2_VC

   rem *** Build Libraries ***
   echo /out:%HG_ROOT%\%LIB_GUI%\oohg.lib >%HG_ROOT%\%LIB_GUI%\oohg.def
   for %%a in (%HG_FILES1_PRG%) do echo %%a.obj >>%HG_ROOT%\%LIB_GUI%\oohg.def
   for %%a in (%HG_FILES2_PRG%) do echo %%a.obj >>%HG_ROOT%\%LIB_GUI%\oohg.def
   for %%a in (%HG_FILES_C%)    do echo %%a.obj >>%HG_ROOT%\%LIB_GUI%\oohg.def
   lib @%HG_ROOT%\lib\oohg.def
   if errorlevel 2 goto :EXIT3_VC
   if exist winprint.obj  lib /out:%HG_ROOT%\%LIB_GUI%\hbprinter.lib winprint.obj
   if errorlevel 2 goto :EXIT3_VC
   if exist miniprint.obj lib /out:%HG_ROOT%\%LIB_GUI%\miniprint.lib miniprint.obj
   if errorlevel 2 goto :EXIT3_VC
   if exist bostaurus.obj lib /out:%HG_ROOT%\%LIB_GUI%\bostaurus.lib bostaurus.obj
   if errorlevel 2 goto :EXIT3_VC

:EXIT3_VC

   rem *** Delete Unwanted Files ***
   if exist %HG_ROOT%\%LIB_GUI%\oohg.def      del %HG_ROOT%\%LIB_GUI%\oohg.def
   if exist %HG_ROOT%\%LIB_GUI%\oohg.bak      del %HG_ROOT%\%LIB_GUI%\oohg.bak
   if exist %HG_ROOT%\%LIB_GUI%\hbprinter.bak del %HG_ROOT%\%LIB_GUI%\hbprinter.bak
   if exist %HG_ROOT%\%LIB_GUI%\miniprint.bak del %HG_ROOT%\%LIB_GUI%\miniprint.bak
   if exist %HG_ROOT%\%LIB_GUI%\bostaurus.bak del %HG_ROOT%\%LIB_GUI%\bostaurus.bak

:EXIT2_VC

   rem *** Delete Unwanted Files ***
   del *.obj

:EXIT1_VC

   rem *** Delete Unwanted Files ***
   del h_*.c
   if exist winprint.c  del winprint.c
   if exist miniprint.c del miniprint.c
   if exist bostaurus.c del bostaurus.c

   rem *** Clear Temporary EnvVars ***
   set OOHG_X_FLAGS=
   set HG_FILES1_PRG=
   set HG_FILES2_PRG=
   set HG_FILES_C=
   set PATH=%_PATH%
   set _PATH=
