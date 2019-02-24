@echo off
rem
rem $Id: CompileRes.bat $
rem

:COMPILERES

   cls

   setlocal
   pushd "%~dp0"
   set HG_START_DP_COMPILERES_BAT=%CD%
   popd

   if exist "%HG_START_DP_COMPILERES_BAT%\CompileRes_bcc.bat" goto BCC
   if exist "%HG_START_DP_COMPILERES_BAT%\CompileRes_mingw.bat" goto MINGW

   echo File %HG_START_DP_COMPILERES_BAT%\CompileRes_bcc.bat not found !!!
   echo FIle %HG_START_DP_COMPILERES_BAT%\CompileRes_mingw.bat not found !!!
   echo.
   goto EXIT

:BCC

   call "%HG_START_DP_COMPILERES_BAT%\CompileRes_bcc.bat" /NOCLS
   if exist "%HG_START_DP_COMPILERES_BAT%\CompileRes_mingw.bat" goto MINGW
   goto EXIT

:MINGW

   if exist "%HG_START_DP_COMPILERES_BAT%\..\compile30.bat" call "%HG_START_DP_COMPILERES_BAT%\CompileRes_mingw.bat" /NOCLS HM30
   if exist "%HG_START_DP_COMPILERES_BAT%\..\compile32.bat" call "%HG_START_DP_COMPILERES_BAT%\CompileRes_mingw.bat" /NOCLS HM32
   if exist "%HG_START_DP_COMPILERES_BAT%\..\compile34.bat" call "%HG_START_DP_COMPILERES_BAT%\CompileRes_mingw.bat" /NOCLS HM34
   if exist "%HG_START_DP_COMPILERES_BAT%\..\compileXM.bat" call "%HG_START_DP_COMPILERES_BAT%\CompileRes_mingw.bat" /NOCLS XM

:EXIT

   set HG_START_DP_COMPILERES_BAT=
