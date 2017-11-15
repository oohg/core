@echo off
rem
rem $Id: CompileRes.bat $
rem

:MAIN

   cls
   if exist CompileRes_bcc.bat goto BCC
   if exist CompileRes_mingw.bat goto MINGW

   echo File CompileRes_bcc.bat not found !!!
   echo FIle CompileRes_mingw.bat not found !!!
   echo.
   goto EXIT

:BCC

   call CompileRes_bcc.bat /NOCLS
   if exist CompileRes_mingw.bat goto MINGW
   goto EXIT

:MINGW

   if exist ..\compile30.bat call CompileRes_mingw.bat /NOCLS HB30
   if exist ..\compile32.bat call CompileRes_mingw.bat /NOCLS HB32

:EXIT
