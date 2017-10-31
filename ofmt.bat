@echo off

:MAIN

   rem *** Sets ***
   if .%HG_FMT%.==.. set HG_FMT=%~dp0fmt

   rem *** Check ***
   if not exist %HG_FMT%\ofmt.exe goto NOT_INSTALLED

   rem *** Execute ***
   start %HG_FMT%\ofmt.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:NOT_INSTALLED

   echo Missing %HG_FMT%\ofmt.exe
   echo.

:END
