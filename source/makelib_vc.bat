@echo off
rem
rem $Id: makelib_vc.bat,v 1.3 2010-08-12 23:07:55 guerra000 Exp $
rem
cls

Rem Set Paths

IF "%HG_VC%"==""   SET HG_VC=%Program Files%\Microsoft Visual Studio 9.0\vc
IF "%HG_ROOT%"=="" SET HG_ROOT=C:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=C:\oohg\harbour

SET _PATH=%PATH%
SET PATH="%HG_VC%\bin";%PATH%
IF EXIST "%HG_VC%"\vcvarsall.bat CALL "%HG_VC%"\vcvarsall.bat

IF NOT EXIST %hg_root%\lib\oohg.lib MD %hg_root%\lib >nul

IF EXIST %hg_root%\lib\oohg.lib del %hg_root%\lib\oohg.lib
IF EXIST %hg_root%\lib\hbprinter.lib del %hg_root%\lib\hbprinter.lib
IF EXIST %hg_root%\lib\miniprint.lib del %hg_root%\lib\miniprint.lib

call common_make "%hg_hrb%\lib\tip.lib"
if errorlevel 1 goto EXIT1

SET OOHG_X_FLAGS= /O2 /c /W3 /nologo /I"%hg_vc%\include" /I"%hg_vc%\include\Win" /I%hg_hrb%\include /I%hg_root%\include /D__WIN32__ /D_CRT_SECURE_NO_WARNINGS

for %%a in (%HG_FILES1_PRG%) do if not errorlevel 1 cl %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES2_PRG%) do if not errorlevel 1 cl %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES_C%)    do if not errorlevel 1 cl %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
if exist winprint.c  cl %OOHG_X_FLAGS% winprint.c
if errorlevel 1 goto EXIT2
if exist miniprint.c cl %OOHG_X_FLAGS% miniprint.c
if errorlevel 1 goto EXIT2

ECHO /out:%hg_root%\lib\oohg.lib >%hg_root%\lib\oohg.def
for %%a in (%HG_FILES1_PRG%) do ECHO %%a.obj >>%hg_root%\lib\oohg.def
for %%a in (%HG_FILES2_PRG%) do ECHO %%a.obj >>%hg_root%\lib\oohg.def
for %%a in (%HG_FILES_C%)    do ECHO %%a.obj >>%hg_root%\lib\oohg.def
lib @%hg_root%\lib\oohg.def
if errorlevel 2 goto EXIT3
if exist winprint.obj  lib /out:%hg_root%\lib\hbprinter.lib winprint.obj
if errorlevel 2 goto EXIT3
if exist miniprint.obj lib /out:%hg_root%\lib\miniprint.lib miniprint.obj
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
SET HG_FILES1_PRG=
SET HG_FILES2_PRG=
SET HG_FILES_C=
SET PATH=%_PATH%
SET _PATH=
