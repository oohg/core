@echo off
rem
rem $Id: makelib_pc.bat,v 1.4 2013-08-22 22:29:32 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
if "%HG_HRB%"==""  set HG_HRB=%HG_ROOT%\harbour
IF "%HG_PC%"==""   set HG_PC=c:\pellesc

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** Create Lib Folder ***
if not exist %HG_ROOT%\%LIB_GUI%\oohg.lib md %HG_ROOT%\%LIB_GUI% >nul

rem *** Delete Old Libraries ***
if exist %HG_ROOT%\%LIB_GUI%\oohg.lib      del %HG_ROOT%\%LIB_GUI%\oohg.lib
if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib del %HG_ROOT%\%LIB_GUI%\hbprinter.lib
if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib del %HG_ROOT%\%LIB_GUI%\miniprint.lib

rem *** Compile with Harbour ***
call common_make "%HG_HRB%\%LIB_HRB%\tip.lib"
if errorlevel 1 goto EXIT1

rem *** Compile with Pelles C ***
set OOHG_X_FLAGS= /Ze /Zx /Go /Tx86-coff /I%HG_PC%\include /I%HG_PC%\include\Win /I%HG_HRB%\include /I%HG_ROOT%\include /D__WIN32__
for %%a in (%HG_FILES1_PRG%) do if not errorlevel 1 %HG_PC%\bin\pocc %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES2_PRG%) do if not errorlevel 1 %HG_PC%\bin\pocc %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES_C%)    do if not errorlevel 1 %HG_PC%\bin\pocc %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
if exist winprint.c  %HG_PC%\bin\pocc %OOHG_X_FLAGS% winprint.c
if errorlevel 1 goto EXIT2
if exist miniprint.c %HG_PC%\bin\pocc %OOHG_X_FLAGS% miniprint.c
if errorlevel 1 goto EXIT2

rem *** Build Libraries ***
echo /out:%HG_ROOT%\%LIB_GUI%\oohg.lib >%HG_ROOT%\%LIB_GUI%\oohg.def
for %%a in (%HG_FILES1_PRG%) do echo %%a.obj >>%HG_ROOT%\%LIB_GUI%\oohg.def
for %%a in (%HG_FILES2_PRG%) do echo %%a.obj >>%HG_ROOT%\%LIB_GUI%\oohg.def
for %%a in (%HG_FILES_C%)    do echo %%a.obj >>%HG_ROOT%\%LIB_GUI%\oohg.def
%HG_PC%\bin\polib @%HG_ROOT%\lib\oohg.def
if errorlevel 2 goto EXIT3
if exist winprint.obj  %HG_PC%\bin\polib /out:%HG_ROOT%\%LIB_GUI%\hbprinter winprint.obj
if errorlevel 2 goto EXIT3
if exist miniprint.obj %HG_PC%\bin\polib /out:%HG_ROOT%\%LIB_GUI%\miniprint miniprint.obj
if errorlevel 2 goto EXIT3


:EXIT3
rem *** Delete Unwanted Files ***
if exist %HG_ROOT%\%LIB_GUI%\oohg.def      del %HG_ROOT%\%LIB_GUI%\oohg.def
if exist %HG_ROOT%\%LIB_GUI%\oohg.bak      del %HG_ROOT%\%LIB_GUI%\oohg.bak
if exist %HG_ROOT%\%LIB_GUI%\hbprinter.bak del %HG_ROOT%\%LIB_GUI%\hbprinter.bak
if exist %HG_ROOT%\%LIB_GUI%\miniprint.bak del %HG_ROOT%\%LIB_GUI%\miniprint.bak


:EXIT2
rem *** Delete Unwanted Files ***
del *.obj


:EXIT1
rem *** Delete Unwanted Files ***
del h_*.c
if exist winprint.c  del winprint.c
if exist miniprint.c del miniprint.c


rem *** Clear Temporary EnvVars ***
set OOHG_X_FLAGS=
set HG_FILES1_PRG=
set HG_FILES2_PRG=
set HG_FILES_C=
