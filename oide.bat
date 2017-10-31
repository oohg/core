@echo off

:MAIN

   rem *** Sets ***
   if .%HG_IDE%.==.. set HG_IDE=%~dp0ide

   rem *** Check ***
   if not exist %HG_IDE%\oide.exe goto NOT_INSTALLED

   rem *** Execute ***
   start %HG_IDE%\oide.exe %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto END

:NOT_INSTALLED

   echo Missing %HG_IDE%\oide.exe
   echo.

:END
