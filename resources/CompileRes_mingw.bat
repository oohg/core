@echo off
rem
rem $Id: CompileRes_mingw.bat $
rem

:COMPILERES_MINGW

   echo Compiling oohg.rc ...

   if /I not "%1"=="/NOCLS" cls
   if /I "%1"=="/NOCLS" shift

   if /I "%1"=="HB30" goto CONTINUE
   if /I "%1"=="HB32" goto CONTINUE

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       CompileRes_mingw [/NOCLS] HB30
   echo   To build with Harbour 3.2 and MinGW
   echo       CompileRes_mingw [/NOCLS] HB32
   echo.
   goto EXIT


:CONTINUE

   if not "%HG_MINGW%"=="" goto CHECK

   if not "%HG_ROOT%"=="" set HG_MINGW=%HG_ROOT%
   if "%HG_ROOT%"=="" set HG_MINGW=%~dp0..

   if /I "%1"=="HB30" set HG_MINGW=%HG_MINGW%\hb30\comp\mingw
   if /I "%1"=="HB32" set HG_MINGW=%HG_MINGW%\hb32\comp\mingw

:CHECK

   if not exist "%HG_MINGW%\bin\windres.exe" goto NO_MINGW

:COMPILE

   if /I "%1"=="HB30" ( if exist oohg_hb30.o del oohg_hb30.o )
   if /I "%1"=="HB30" ( if exist oohg_hb30.o goto ERROR4 )

   if /I "%1"=="HB32" ( if exist oohg_hb32.o del oohg_hb32.o )
   if /I "%1"=="HB32" ( if exist oohg_hb32.o goto ERROR5 )

   if exist _oohg_resconfig.h del _oohg_resconfig.h
   if exist _oohg_resconfig.h goto ERROR2

   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
   if not exist _oohg_resconfig.h goto ERROR3

   set TPATH=%PATH%
   set PATH=%HG_MINGW%\bin

   if /I "%1"=="HB30" ( windres -i oohg.rc -o oohg_hb30.o )
   if /I "%1"=="HB32" ( windres -i oohg.rc -o oohg_hb32.o )

   set PATH=%TPATH%
   set TPATH=

   rem Do not delete _oohg_resconfig.h, QAC/QPM needs it
   if /I "%1"=="HB30" ( if exist oohg_hb30.o echo oohg_hb30.o builded ok. )
   if /I "%1"=="HB30" ( if not exist oohg_hb30.o echo Error building oohg_hb30.o. )

   if /I "%1"=="HB32" ( if exist oohg_hb32.o echo oohg_hb32.o builded ok. )
   if /I "%1"=="HB32" ( if not exist oohg_hb32.o echo Error building oohg_hb32.o. )

   echo.
   goto EXIT

:NO_MINGW

   echo MINGW not found !!!
   echo.
   goto EXIT

:ERROR2

   echo Can not delete old _oohg_resconfig.h !!!
   goto EXIT

:ERROR3

   echo Can not create new _oohg_resconfig.h !!!
   goto EXIT

:ERROR4

   echo Can not delete old oohg_hb30.o !!!
   goto EXIT

:ERROR5

   echo Can not delete old oohg_hb32.o !!!
   goto EXIT

:EXIT
