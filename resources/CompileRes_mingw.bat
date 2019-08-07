@echo off
rem
rem $Id: CompileRes_mingw.bat $
rem

:COMPILERES_MINGW

   echo Compiling oohg.rc ...

   setlocal
   pushd "%~dp0"
   set HG_START_DP_COMPILERES_MINGW_BAT=%CD%
   popd

   if /I not "%1"=="/NOCLS" cls
   if /I "%1"=="/NOCLS" shift

   if /I "%1"=="HM30" goto CONTINUE
   if /I "%1"=="HM32" goto CONTINUE
   if /I "%1"=="HM34" goto CONTINUE
   if /I "%1"=="XM"   goto CONTINUE

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       CompileRes_mingw [/NOCLS] HM30
   echo   To build with Harbour 3.2 and MinGW
   echo       CompileRes_mingw [/NOCLS] HM32
   echo   To build with Harbour 3.4 and MinGW
   echo       CompileRes_mingw [/NOCLS] HM34
   echo   To build with xHarbour and MinGW
   echo       CompileRes_mingw [/NOCLS] XM
   echo.
   goto EXIT


:CONTINUE

   if not "%HG_MINGW%"=="" goto CHECK

   if not "%HG_ROOT%"=="" goto SETFROMROOT

   pushd "%HG_START_DP_COMPILERES_MINGW_BAT%\.."
   set HG_ROOT=%CD%
   popd

:SETFROMROOT

   set HG_MINGW=%HG_ROOT%

   if /I "%1"=="HM30" set HG_MINGW=%HG_MINGW%\hb30\comp\mingw
   if /I "%1"=="HM32" set HG_MINGW=%HG_MINGW%\hb32\comp\mingw
   if /I "%1"=="HM34" set HG_MINGW=%HG_MINGW%\hb34\comp\mingw
   if /I "%1"=="XM"   set HG_MINGW=%HG_MINGW%\xhmingw\comp\mingw

:CHECK

   if not exist "%HG_MINGW%\bin\windres.exe" goto NO_MINGW

:COMPILE

   if /I "%1"=="HM30" ( if exist oohg_hb30.o del oohg_hb30.o )
   if /I "%1"=="HM30" ( if exist oohg_hb30.o goto ERROR4 )

   if /I "%1"=="HM32" ( if exist oohg_hb32.o del oohg_hb32.o )
   if /I "%1"=="HM32" ( if exist oohg_hb32.o goto ERROR5 )

   if /I "%1"=="HM34" ( if exist oohg_hb34.o del oohg_hb34.o )
   if /I "%1"=="HM34" ( if exist oohg_hb34.o goto ERROR6 )

   if /I "%1"=="XM"   ( if exist oohg_xm.o   del oohg_xm.o )
   if /I "%1"=="XM"   ( if exist oohg_xm.o   goto ERROR7 )

   if exist _oohg_resconfig.h del _oohg_resconfig.h
   if exist _oohg_resconfig.h goto ERROR2

   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
   if not exist _oohg_resconfig.h goto ERROR3

   set "HG_PATH=%PATH%"
   set "PATH=%HG_MINGW%\bin"

   if /I "%1"=="HM30" ( windres -i oohg.rc -o oohg_hb30.o )
   if /I "%1"=="HM32" ( windres -i oohg.rc -o oohg_hb32.o )
   if /I "%1"=="HM34" ( windres -i oohg.rc -o oohg_hb34.o )
   if /I "%1"=="XM"   ( windres -i oohg.rc -o oohg_xm.o )

   set "PATH=%HG_PATH%"
   set HG_PATH=

   rem Do not delete _oohg_resconfig.h, QAC/QPM needs it
   if /I "%1"=="HM30" ( if exist oohg_hb30.o echo oohg_hb30.o builded ok. )
   if /I "%1"=="HM30" ( if not exist oohg_hb30.o echo Error building oohg_hb30.o. )

   if /I "%1"=="HM32" ( if exist oohg_hb32.o echo oohg_hb32.o builded ok. )
   if /I "%1"=="HM32" ( if not exist oohg_hb32.o echo Error building oohg_hb32.o. )

   if /I "%1"=="HM34" ( if exist oohg_hb34.o echo oohg_hb34.o builded ok. )
   if /I "%1"=="HM34" ( if not exist oohg_hb34.o echo Error building oohg_hb34.o. )

   if /I "%1"=="XM"   ( if exist oohg_xm.o echo oohg_xm.o builded ok. )
   if /I "%1"=="XM"   ( if not exist oohg_xm.o echo Error building oohg_xm.o. )

   echo.
   goto EXIT

:NO_MINGW

   echo MINGW for %1 not found !!!
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

:ERROR6

   echo Can not delete old oohg_hb34.o !!!
   goto EXIT

:ERROR7

   echo Can not delete old oohg_xm.o !!!
   goto EXIT

:EXIT

   set HG_START_DP_COMPILERES_MINGW_BAT=
