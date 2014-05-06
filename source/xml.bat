@echo off
rem
rem $Id: xml.bat,v 1.4 2014-05-06 21:49:58 fyurisich Exp $
rem
cls

rem *** Set Paths ***
IF "%HG_BCC%"==""  SET HG_BCC=c:\borland\bcc55
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=C:\xhb_121

rem *** Set EnvVars ***
IF "%LIB_GUI%"=="" SET LIB_GUI=lib\xhb\bcc
IF "%LIB_HRB%"=="" SET LIB_HRB=lib
IF "%BIN_HRB%"=="" SET BIN_HRB=bin

rem IF "%LIB_HRB%"=="" SET LIB_HRB=lib\win\bcc
rem IF "%BIN_HRB%"=="" SET BIN_HRB=bin\win\bcc

IF NOT EXIST %hg_root%\%LIB_GUI%\oohg.lib MD %hg_root%\%LIB_GUI% >nul

IF EXIST %hg_root%\%LIB_GUI%\oohg.lib del %hg_root%\%LIB_GUI%\oohg.lib
IF EXIST %hg_root%\%LIB_GUI%\hbprinter.lib del %hg_root%\%LIB_GUI%\hbprinter.lib
IF EXIST %hg_root%\%LIB_GUI%\miniprint.lib del %hg_root%\%LIB_GUI%\miniprint.lib

call common_make "%hg_hrb%\%LIB_HRB%\tip.lib"
if errorlevel 1 goto EXIT1

IF EXIST resul.txt del resul.txt

SET OOHG_X_FLAGS=-c -O2 -tW -tWM -d -a8 -OS -5 -6 -I%hg_hrb%\include;%hg_bcc%\include;%hg_root%\include; -L%hg_hrb%\%LIB_HRB%;%hg_bcc%\lib; -D__XHARBOUR__

for %%a in (%HG_FILES1_PRG%) do if not errorlevel 1 %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES2_PRG%) do if not errorlevel 1 %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES_C%)    do if not errorlevel 1 %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
if errorlevel 1 goto EXIT2
if exist winprint.c  %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% winprint.c
if errorlevel 1 goto EXIT2
if exist miniprint.c %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% miniprint.c
if errorlevel 1 goto EXIT2

for %%a in ( %HG_FILES1_PRG% ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\oohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
for %%a in ( %HG_FILES2_PRG% ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\oohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
for %%a in ( %HG_FILES_C%    ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\oohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
if exist winprint.obj  %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\hbprinter +winprint.obj
if errorlevel 2 goto EXIT3
if exist miniprint.obj %hg_bcc%\bin\tlib %hg_root%\%LIB_GUI%\miniprint +miniprint.obj
if errorlevel 2 goto EXIT3

:EXIT3
IF EXIST %hg_root%\%LIB_GUI%\oohg.bak del %hg_root%\%LIB_GUI%\oohg.bak
IF EXIST %hg_root%\%LIB_GUI%\hbprinter.bak del %hg_root%\%LIB_GUI%\hbprinter.bak
IF EXIST %hg_root%\%LIB_GUI%\miniprint.bak del %hg_root%\%LIB_GUI%\miniprint.bak

:EXIT2
del *.obj

:EXIT1
del h_*.c
if exist winprint.c  del winprint.c
if exist miniprint.c del miniprint.c

SET OOHG_X_FLAGS=
SET HG_FILES1_PRG=
SET HG_FILES2_PRG=
SET HG_FILES_C=
