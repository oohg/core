@echo off
rem
rem $Id: CompileRes.bat $
rem

:COMPILERES

   cls
   if exist "%~dp0.\CompileRes_bcc.bat" goto BCC
   if exist "%~dp0.\CompileRes_mingw.bat" goto MINGW

   echo File %~dp0CompileRes_bcc.bat not found !!!
   echo FIle %~dp0CompileRes_mingw.bat not found !!!
   echo.
   goto EXIT

:BCC

   call "%~dp0.\CompileRes_bcc.bat" /NOCLS
   if exist "%~dp0.\CompileRes_mingw.bat" goto MINGW
   goto EXIT

:MINGW

   if exist "%~dp0..\compile30.bat" call "%~dp0.\CompileRes_mingw.bat" /NOCLS HB30
   if exist "%~dp0..\compile32.bat" call "%~dp0.\CompileRes_mingw.bat" /NOCLS HB32

:EXIT
