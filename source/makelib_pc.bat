@echo off
rem
rem $Id: makelib_pc.bat,v 1.2 2007-11-05 04:36:06 guerra000 Exp $
rem
cls

Rem Set Paths

IF "%HG_PC%"==""   SET HG_PC=c:\pellesc
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=c:\oohg\harbour

IF NOT EXIST %hg_root%\lib\oohg.lib MD %hg_root%\lib >nul

IF EXIST %hg_root%\lib\oohg.lib del %hg_root%\lib\oohg.lib
IF EXIST %hg_root%\lib\hbprinter.lib del %hg_root%\lib\hbprinter.lib
IF EXIST %hg_root%\lib\miniprint.lib del %hg_root%\lib\miniprint.lib

call common_make "%hg_hrb%\lib\tip.lib"
if errorlevel 1 goto EXIT1

SET OOHG_X_FLAGS= /Ze /Zx /Go /Tx86-coff /I%hg_pc%\include /I%hg_pc%\include\Win /I%hg_hrb%\include /I%hg_root%\include /D__WIN32__

for %%a in (%HG_FILES_PRG% %HG_FILES_C%) do if not errorlevel 1 %hg_pc%\bin\pocc %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
if exist winprint.c  %hg_pc%\bin\pocc %OOHG_X_FLAGS% winprint.c
if errorlevel 1 goto EXIT2
if exist miniprint.c %hg_pc%\bin\pocc %OOHG_X_FLAGS% miniprint.c
if errorlevel 1 goto EXIT2

ECHO /out:%hg_root%\lib\oohg.lib >%hg_root%\lib\oohg.def
for %%a in (%HG_FILES_PRG% %HG_FILES_C%) do ECHO %%a.obj >>%hg_root%\lib\oohg.def
%hg_pc%\bin\polib @%hg_root%\lib\oohg.def
if errorlevel 2 goto EXIT3
if exist winprint.obj  %hg_pc%\bin\polib /out:%hg_root%\lib\hbprinter winprint.obj
if errorlevel 2 goto EXIT3
if exist miniprint.obj %hg_pc%\bin\polib /out:%hg_root%\lib\miniprint miniprint.obj
if errorlevel 2 goto EXIT3

:EXIT3
IF EXIST %hg_root%\lib\oohg.def del %hg_root%\lib\oohg.def
IF EXIST %hg_root%\lib\oohg.bak del %hg_root%\lib\oohg.bak
IF EXIST %hg_root%\lib\hbprinter.bak del %hg_root%\lib\hbprinter.bak
IF EXIST %hg_root%\lib\miniprint.bak del %hg_root%\lib\miniprint.bak

:EXIT2
del *.obj

:EXIT1
del h_*.c
if exist winprint.c  del winprint.c
if exist miniprint.c del miniprint.c

SET OOHG_X_FLAGS=
SET HG_FILES_PRG=
SET HG_FILES_C=
