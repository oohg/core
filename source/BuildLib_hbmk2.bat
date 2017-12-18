@echo off
rem
rem $Id: BuildLib_hbmk2.bat $
rem

:BUILDLIB_HBMK2

   if "%HG_ROOT%"  == "" goto INFO
   if "%HG_HRB%"   == "" goto INFO
   if "%HG_CCOMP%" == "" goto INFO
   if "%LIB_GUI%"  == "" goto INFO
   if "%LIB_HRB%"  == "" goto INFO
   if "%BIN_HRB%"  == "" goto INFO

:PREPARE

   rem *** Set PATH ***
   set TPATH=%PATH%
   set PATH=%HG_CCOMP%\bin;%HG_HRB%\%BIN_HRB%

   rem *** Delete Old Log ***
   if exist error.log del error.log

   rem *** Check for Log Messages Switch ***
   if .%1.==.f. goto FILE
   if .%1.==.F. goto FILE

:SCREEN

   rem *** Build Libraries ***
   hbmk2 oohg.hbp      %1 %2 %3 %4 %5 %6 %7 %8 %9
   hbmk2 miniprint.hbp %1 %2 %3 %4 %5 %6 %7 %8 %9
   hbmk2 hbprinter.hbp %1 %2 %3 %4 %5 %6 %7 %8 %9
   hbmk2 bostaurus.hbp %1 %2 %3 %4 %5 %6 %7 %8 %9
   goto RESTORE_PATH

:FILE

   rem *** Build Libraries ***
   hbmk2 oohg.hbp      %2 %3 %4 %5 %6 %7 %8 %9 >> error.log 2>&1
   hbmk2 miniprint.hbp %2 %3 %4 %5 %6 %7 %8 %9 >> error.log 2>&1
   hbmk2 hbprinter.hbp %2 %3 %4 %5 %6 %7 %8 %9 >> error.log 2>&1
   hbmk2 bostaurus.hbp %2 %3 %4 %5 %6 %7 %8 %9 >> error.log 2>&1
   goto RESTORE_PATH

:INFO

   echo This file must be called from BUILDLIB.BAT !!!
   echo .
   goto END

:RESTORE_PATH

   rem *** Restore PATH ***
   set PATH=%TPATH%
   set TPATH=

:END
