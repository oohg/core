@echo off
rem
rem $Id: xml.bat,v 1.1 2013-06-27 00:00:38 fyurisich Exp $
rem
cls

Rem Set Paths

IF "%HG_BCC%"==""  SET HG_BCC=c:\borland\bcc55
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=C:\xharbour-1.2.1

IF NOT EXIST %hg_root%\lib\oohg.lib MD %hg_root%\lib >nul

IF EXIST %hg_root%\lib\xoohg.lib del %hg_root%\lib\xoohg.lib
IF EXIST %hg_root%\lib\xhbprinter.lib del %hg_root%\lib\xhbprinter.lib
IF EXIST %hg_root%\lib\xminiprint.lib del %hg_root%\lib\xminiprint.lib

call common_make "%hg_hrb%\lib\tip.lib"
if errorlevel 1 goto EXIT1

IF EXIST resul.txt del resul.txt

SET OOHG_X_FLAGS=-c -O2 -tW -tWM -d -a8 -OS -5 -6 -I%hg_hrb%\include;%hg_bcc%\include;%hg_root%\include; -L%hg_hrb%\lib;%hg_bcc%\lib;

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

for %%a in ( %HG_FILES1_PRG% ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\lib\xoohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
for %%a in ( %HG_FILES2_PRG% ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\lib\xoohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
for %%a in ( %HG_FILES_C%    ) do if not errorlevel 2 %hg_bcc%\bin\tlib %hg_root%\lib\xoohg +%%a.obj /P32
if errorlevel 2 goto EXIT3
if exist winprint.obj  %hg_bcc%\bin\tlib %hg_root%\lib\xhbprinter +winprint.obj
if errorlevel 2 goto EXIT3
if exist miniprint.obj %hg_bcc%\bin\tlib %hg_root%\lib\xminiprint +miniprint.obj
if errorlevel 2 goto EXIT3

:EXIT3
IF EXIST %hg_root%\lib\xoohg.bak del %hg_root%\lib\xoohg.bak
IF EXIST %hg_root%\lib\xhbprinter.bak del %hg_root%\lib\xhbprinter.bak
IF EXIST %hg_root%\lib\xminiprint.bak del %hg_root%\lib\xminiprint.bak

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
