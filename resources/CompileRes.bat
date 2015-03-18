@echo off
rem
rem $Id: CompileRes.bat,v 1.8 2015-03-18 01:22:30 fyurisich Exp $
rem
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
call CompileRes_mingw.bat /NOCLS

:EXIT
