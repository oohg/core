@echo off
rem
rem $Id: ofmt.bat $
rem

:OFMT

   if not "%HG_FMT%" == "" goto CHECK

   pushd "%~dp0"
   set HG_FMT=%CD%\fmt
   popd

:CHECK

   if not exist "%HG_FMT%\ofmt.exe" goto NOT_INSTALLED

:EXECUTE

   start "%HG_FMT%\ofmt.exe" %*
   goto END

:NOT_INSTALLED

   echo File %HG_FMT%\ofmt.exe not found !!!
   echo.

:END
