@echo off
rem
rem $Id: ofmt.bat $
rem

:MAIN

   rem *** Sets ***
   if .%HG_FMT%.==.. set HG_FMT=%~dp0fmt

   rem *** Check ***
   if not exist %HG_FMT%\ofmt.exe goto NOT_INSTALLED

   rem *** Execute ***
   start %HG_FMT%\ofmt.exe %*
   goto END

:NOT_INSTALLED

   echo Missing %HG_FMT%\ofmt.exe
   echo.

:END
