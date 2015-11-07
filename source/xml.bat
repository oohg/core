@echo off
rem
rem $Id: xml.bat,v 1.9 2015-11-07 22:39:57 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%HG_BCC%"==""  set HG_BCC=c:\borland\bcc55
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
if "%HG_HRB%"==""  set HG_HRB=C:\xhbcc

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib\xhb\bcc
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem if "%LIB_HRB%"=="" set LIB_HRB=lib\win\bcc
rem if "%BIN_HRB%"=="" set BIN_HRB=bin\win\bcc

if not exist %hg_root%\%LIB_GUI%\nul md %hg_root%\%LIB_GUI% >nul

if exist %hg_root%\%LIB_GUI%\oohg.lib del %hg_root%\%LIB_GUI%\oohg.lib > nul
if exist %hg_root%\%LIB_GUI%\hbprinter.lib del %hg_root%\%LIB_GUI%\hbprinter.lib > nul
if exist %hg_root%\%LIB_GUI%\miniprint.lib del %hg_root%\%LIB_GUI%\miniprint.lib > nul
if exist %hg_root%\%LIB_GUI%\bostaurus.lib del %hg_root%\%LIB_GUI%\bostaurus.lib > nul

if exist resul.txt del resul.txt

echo Compiling prg files ...
call common_make "%hg_hrb%\%LIB_HRB%\tip.lib" -q >> resul.txt
if errorlevel 1 goto EXIT1
echo. >> resul.txt

echo Compiling c files ...
set OOHG_X_FLAGS=-c -O2 -tW -tWM -d -a8 -OS -5 -6 -w -I%hg_hrb%\include;%hg_bcc%\include;%hg_root%\include; -L%hg_hrb%\%LIB_HRB%;%hg_bcc%\lib; -D__XHARBOUR__
for %%a in (%HG_FILES1_PRG%) do if not errorlevel 1 %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES2_PRG%) do if not errorlevel 1 %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES_C%)    do if not errorlevel 1 %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
if errorlevel 1 goto EXIT2
if exist winprint.c  %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% winprint.c >> resul.txt
if errorlevel 1 goto EXIT2
if exist miniprint.c %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% miniprint.c >> resul.txt
if errorlevel 1 goto EXIT2
if exist bostaurus.c %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% bostaurus.c >> resul.txt
if errorlevel 1 goto EXIT2
echo. >> resul.txt

echo Building libraries ...
for %%a in ( %HG_FILES1_PRG% ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
if errorlevel 2 goto EXIT3
for %%a in ( %HG_FILES2_PRG% ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
if errorlevel 2 goto EXIT3
for %%a in ( %HG_FILES_C%    ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
if errorlevel 2 goto EXIT3
if exist winprint.obj  %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\hbprinter +winprint.obj >> resul.txt
if errorlevel 2 goto EXIT3
if exist miniprint.obj %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\miniprint +miniprint.obj >> resul.txt
if errorlevel 2 goto EXIT3
if exist bostaurus.obj %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\bostaurus +bostaurus.obj >> resul.txt
if errorlevel 2 goto EXIT3

:EXIT3
if exist %hg_root%\%LIB_GUI%\oohg.bak del %hg_root%\%LIB_GUI%\oohg.bak > nul
if exist %hg_root%\%LIB_GUI%\hbprinter.bak del %hg_root%\%LIB_GUI%\hbprinter.bak > nul
if exist %hg_root%\%LIB_GUI%\miniprint.bak del %hg_root%\%LIB_GUI%\miniprint.bak > nul
if exist %hg_root%\%LIB_GUI%\bostaurus.bak del %hg_root%\%LIB_GUI%\bostaurus.bak > nul

:EXIT2
del /q *.obj > nul

:EXIT1
del /q h_*.c > nul
if exist winprint.c  del winprint.c > nul
if exist miniprint.c del miniprint.c > nul
if exist bostaurus.c del bostaurus.c > nul

set OOHG_X_FLAGS=
set HG_FILES1_PRG=
set HG_FILES2_PRG=
set HG_FILES_C=

echo See resul.txt
echo.
