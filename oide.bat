@echo off
rem
rem $Id: oide.bat $
rem

:OIDE

   if not .%HG_IDE%.==.. goto CHECK

   pushd "%~dp0"
   set HG_IDE=%CD%\ide
   popd

:CHECK

   if not exist "%HG_IDE%\oide.exe" goto NOT_INSTALLED

:EXECUTE

   start %HG_IDE%\oide.exe %*
   goto END

:NOT_INSTALLED

   echo File %HG_IDE%\oide.exe not found !!!
   echo.

:END
