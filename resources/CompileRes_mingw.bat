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

   if /I "%1"=="HM30"   goto CONTINUE
   if /I "%1"=="HM32"   goto CONTINUE
   if /I "%1"=="HM3264" goto CONTINUE
   if /I "%1"=="HM34"   goto CONTINUE
   if /I "%1"=="HM3464" goto CONTINUE
   if /I "%1"=="XM"     goto CONTINUE

:SYNTAX

   echo Syntax:
   echo    To build with Harbour 3.0 and MinGW
   echo       CompileRes_mingw [/NOCLS] HM30
   echo   To build with Harbour 3.2 and MinGW
   echo       CompileRes_mingw [/NOCLS] HM32
   echo   To build with Harbour 3.2 and MinGW, 64 bits
   echo       CompileRes_mingw [/NOCLS] HM3264
   echo   To build with Harbour 3.4 and MinGW
   echo       CompileRes_mingw [/NOCLS] HM34
   echo   To build with Harbour 3.4 and MinGW, 64 bits
   echo       CompileRes_mingw [/NOCLS] HM3464
   echo   To build with xHarbour and MinGW
   echo       CompileRes_mingw [/NOCLS] XM
   echo.
   goto EXIT


:CONTINUE

   if not "%HG_MINGW%"=="" goto CHECK
   if not "%HG_CCOMP%"=="" set HG_MINGW=%HG_CCOMP%
   if not "%HG_CCOMP%"=="" goto CHECK

   if not "%HG_ROOT%"=="" goto SETFROMROOT

   pushd "%HG_START_DP_COMPILERES_MINGW_BAT%\.."
   set HG_ROOT=%CD%
   popd

:SETFROMROOT

   set HG_MINGW=%HG_ROOT%

   if /I "%1"=="HM30"   set HG_MINGW=%HG_MINGW%\hb30\comp\mingw
   if /I "%1"=="HM32"   set HG_MINGW=%HG_MINGW%\hb32\comp\mingw
   if /I "%1"=="HM3264" set HG_MINGW=%HG_MINGW%\hb3264\comp\mingw
   if /I "%1"=="HM34"   set HG_MINGW=%HG_MINGW%\hb34\comp\mingw
   if /I "%1"=="HM3464" set HG_MINGW=%HG_MINGW%\hb3464\comp\mingw
   if /I "%1"=="XM"     set HG_MINGW=%HG_MINGW%\xhmingw\comp\mingw

:CHECK

   if not exist "%HG_MINGW%\bin\windres.exe" goto NO_MINGW

:COMPILE

   if /I "%1"=="HM30"   ( if exist ooHG_HM30.o   del ooHG_HM30.o )
   if /I "%1"=="HM30"   ( if exist ooHG_HM30.o   goto ERROR4 )

   if /I "%1"=="HM32"   ( if exist ooHG_HM32.o   del ooHG_HM32.o )
   if /I "%1"=="HM32"   ( if exist ooHG_HM32.o   goto ERROR5 )

   if /I "%1"=="HM3264" ( if exist ooHG_HM3264.o del ooHG_HM3264.o )
   if /I "%1"=="HM3264" ( if exist ooHG_HM3264.o goto ERROR6 )

   if /I "%1"=="HM34"   ( if exist ooHG_HM34.o   del ooHG_HM34.o )
   if /I "%1"=="HM34"   ( if exist ooHG_HM34.o   goto ERROR7 )

   if /I "%1"=="HM3464" ( if exist ooHG_HM3464.o del ooHG_HM3464.o )
   if /I "%1"=="HM3464" ( if exist ooHG_HM3464.o goto ERROR8 )

   if /I "%1"=="XM"     ( if exist oohg_xm.o     del oohg_xm.o )
   if /I "%1"=="XM"     ( if exist oohg_xm.o     goto ERROR9 )

   if exist _oohg_resconfig.h del _oohg_resconfig.h
   if exist _oohg_resconfig.h goto ERROR2

   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
   echo #include "%HG_ROOT%\INCLUDE\oohgversion.h" >> _oohg_resconfig.h
   if not exist _oohg_resconfig.h goto ERROR3

   set "HG_PATH=%PATH%"
   set "PATH=%HG_MINGW%\bin"

   if /I "%1"=="HM30"   ( windres -i oohg.rc -o ooHG_HM30.o )
   if /I "%1"=="HM32"   ( windres -i oohg.rc -o ooHG_HM32.o )
   if /I "%1"=="HM3264" ( windres -i oohg.rc -o ooHG_HM3264.o )
   if /I "%1"=="HM34"   ( windres -i oohg.rc -o ooHG_HM34.o )
   if /I "%1"=="HM3464" ( windres -i oohg.rc -o ooHG_HM3464.o )
   if /I "%1"=="XM"     ( windres -i oohg.rc -o oohg_xm.o )

   set "PATH=%HG_PATH%"
   set HG_PATH=

   rem Do not delete _oohg_resconfig.h, QAC/QPM needs it
   if /I "%1"=="HM30"   ( if exist ooHG_HM30.o       echo ooHG_HM30.o builded ok. )
   if /I "%1"=="HM30"   ( if not exist ooHG_HM30.o   echo Error building ooHG_HM30.o. )

   if /I "%1"=="HM32"   ( if exist ooHG_HM32.o       echo ooHG_HM32.o builded ok. )
   if /I "%1"=="HM32"   ( if not exist ooHG_HM32.o   echo Error building ooHG_HM32.o. )

   if /I "%1"=="HM3264" ( if exist ooHG_HM3264.o     echo ooHG_HM3264.o builded ok. )
   if /I "%1"=="HM3264" ( if not exist ooHG_HM3264.o echo Error building ooHG_HM3264.o. )

   if /I "%1"=="HM34"   ( if exist ooHG_HM34.o       echo ooHG_HM34.o builded ok. )
   if /I "%1"=="HM34"   ( if not exist ooHG_HM34.o   echo Error building ooHG_HM34.o. )

   if /I "%1"=="HM3464" ( if exist ooHG_HM3464.o     echo ooHG_HM3464.o builded ok. )
   if /I "%1"=="HM3464" ( if not exist ooHG_HM3464.o echo Error building ooHG_HM3464.o. )

   if /I "%1"=="XM"     ( if exist oohg_xm.o         echo oohg_xm.o builded ok. )
   if /I "%1"=="XM"     ( if not exist oohg_xm.o     echo Error building oohg_xm.o. )

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

   echo Can not delete old ooHG_HM30.o !!!
   goto EXIT

:ERROR5

   echo Can not delete old ooHG_HM32.o !!!
   goto EXIT

:ERROR6

   echo Can not delete old ooHG_HM3264.o !!!
   goto EXIT

:ERROR7

   echo Can not delete old ooHG_HM34.o !!!
   goto EXIT

:ERROR8

   echo Can not delete old ooHG_HM3464.o !!!
   goto EXIT

:ERROR9

   echo Can not delete old oohg_xm.o !!!
   goto EXIT

:EXIT

   set HG_START_DP_COMPILERES_MINGW_BAT=
