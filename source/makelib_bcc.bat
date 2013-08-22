@echo off
rem
rem $Id: makelib_bcc.bat,v 1.17 2013-08-22 22:25:08 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
if "%HG_HRB%"==""  set HG_HRB=%HG_ROOT%\harbour
if "%HG_BCC%"==""  set HG_BCC=c:\borland\bcc55

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** Create Lib Folder ***
if not exist %HG_ROOT%\lib\oohg.lib md %HG_ROOT%\lib >nul

rem *** Delete Old Libraries ***
if exist %HG_ROOT%\%LIB_GUI%\oohg.lib      del %HG_ROOT%\%LIB_GUI%\oohg.lib
if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib del %HG_ROOT%\%LIB_GUI%\hbprinter.lib
if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib del %HG_ROOT%\%LIB_GUI%\miniprint.lib

rem *** Compile with Harbour ***
call common_make "%HG_HRB%\%LIB_HRB%\tip.lib"
if errorlevel 1 goto EXIT1

rem *** Compile with BCC ***
set OOHG_X_FLAGS=-c -O2 -tW -tWM -d -a8 -OS -5 -6 -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_HRB%\%LIB_HRB%;%HG_BCC%\lib;
for %%a in (%HG_FILES1_PRG%) do if not errorlevel 1 %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES2_PRG%) do if not errorlevel 1 %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES_C%)    do if not errorlevel 1 %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
if exist winprint.c  %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% winprint.c
if errorlevel 1 goto EXIT2
if exist miniprint.c %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% miniprint.c
if errorlevel 1 goto EXIT2

rem *** Build Libraries ***
for %%a in ( %HG_FILES1_PRG% ) do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
for %%a in ( %HG_FILES2_PRG% ) do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
for %%a in ( %HG_FILES_C%    ) do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
if exist winprint.obj  %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\hbprinter +winprint.obj
if errorlevel 2 goto EXIT3
if exist miniprint.obj %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\miniprint +miniprint.obj
if errorlevel 2 goto EXIT3


:EXIT3
rem *** Cleanup ***
IF EXIST %HG_ROOT%\%LIB_GUI%\oohg.bak      del %HG_ROOT%\%LIB_GUI%\oohg.bak
IF EXIST %HG_ROOT%\%LIB_GUI%\hbprinter.bak del %HG_ROOT%\%LIB_GUI%\hbprinter.bak
IF EXIST %HG_ROOT%\%LIB_GUI%\miniprint.bak del %HG_ROOT%\%LIB_GUI%\miniprint.bak


:EXIT2
rem *** Cleanup ***
del *.obj


:EXIT1
rem *** Cleanup ***
del h_*.c
if exist winprint.c  del winprint.c
if exist miniprint.c del miniprint.c
SET OOHG_X_FLAGS=
SET HG_FILES1_PRG=
SET HG_FILES2_PRG=
SET HG_FILES_C=


:EXIT
