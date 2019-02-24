@echo off
rem
rem $Id: makelib_bcc.bat $
rem

:MAKELIB_BCC

   if "%HG_ROOT%" == "" goto INFO
   if "%HG_HRB%"  == "" goto INFO
   if "%HG_BCC%"  == "" goto INFO
   if "%LIB_GUI%" == "" goto INFO
   if "%LIB_HRB%" == "" goto INFO
   if "%BIN_HRB%" == "" goto INFO

:CLEAN_LIBS

   if not exist %HG_ROOT%\%LIB_GUI%\nul md %HG_ROOT%\%LIB_GUI% > nul

   if exist %HG_ROOT%\%LIB_GUI%\oohg.lib      del %HG_ROOT%\%LIB_GUI%\oohg.lib      > nul
   if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib del %HG_ROOT%\%LIB_GUI%\hbprinter.lib > nul
   if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib del %HG_ROOT%\%LIB_GUI%\miniprint.lib > nul
   if exist %HG_ROOT%\%LIB_GUI%\bostaurus.lib del %HG_ROOT%\%LIB_GUI%\bostaurus.lib > nul

:COMPILE_PRGS

   if exist resul.txt del resul.txt
   call common_make "%HG_HRB%\%LIB_HRB%\tip.lib" -q0 ">> resul.txt 2>&1"
   if errorlevel 1 goto EXIT1
   echo. >> resul.txt

:COMPILE_C

   echo Compiling C files ...
   set HG_X_FLAGS=-c -O2 -tW -tWM -d -a8 -OS -5 -6 -w -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_HRB%\%LIB_HRB%;%HG_BCC%\lib;
   for %%a in ( %HG_FILES1_PRG% ) do if not errorlevel 1 %HG_BCC%\bin\bcc32 %HG_X_FLAGS% %%a.c >> resul.txt
   if errorlevel 1 goto EXIT2
   for %%a in ( %HG_FILES2_PRG% ) do if not errorlevel 1 %HG_BCC%\bin\bcc32 %HG_X_FLAGS% %%a.c >> resul.txt
   if errorlevel 1 goto EXIT2
   for %%a in ( %HG_FILES_C% )    do if not errorlevel 1 %HG_BCC%\bin\bcc32 %HG_X_FLAGS% %%a.c >> resul.txt
   if errorlevel 1 goto EXIT2
   if not exist winprint.c echo winprint.c is missing! >> resul.txt
   if exist winprint.c  %HG_BCC%\bin\bcc32 %HG_X_FLAGS% winprint.c >> resul.txt
   if errorlevel 1 goto EXIT2
   if not exist miniprint.c echo miniprint.c is missing! >> resul.txt
   if exist miniprint.c %HG_BCC%\bin\bcc32 %HG_X_FLAGS% miniprint.c >> resul.txt
   if errorlevel 1 goto EXIT2
   if not exist bostaurus.c echo bostaurus.c is missing! >> resul.txt
   if exist bostaurus.c %HG_BCC%\bin\bcc32 %HG_X_FLAGS% bostaurus.c >> resul.txt
   if errorlevel 1 goto EXIT2
   echo. >> resul.txt

:BUILD_LIBS

   echo Building libraries ...
   for %%a in ( %HG_FILES1_PRG% ) do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
   if errorlevel 2 goto EXIT2
   for %%a in ( %HG_FILES2_PRG% ) do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
   if errorlevel 2 goto EXIT2
   for %%a in ( %HG_FILES_C% )    do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
   if errorlevel 2 goto EXIT2
   if not exist winprint.obj echo winprint.obj is missing! >> resul.txt
   if not exist winprint.obj goto EXIT2
   if exist winprint.obj  %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\hbprinter +winprint.obj >> resul.txt
   if errorlevel 2 goto EXIT2
   if not exist miniprint.obj echo miniprint.obj is missing! >> resul.txt
   if not exist miniprint.obj goto EXIT2
   if exist miniprint.obj %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\miniprint +miniprint.obj >> resul.txt
   if errorlevel 2 goto EXIT2
   if not exist bostaurus.obj echo bostaurus.obj is missing! >> resul.txt
   if not exist bostaurus.obj goto EXIT2
   if exist bostaurus.obj %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\bostaurus +bostaurus.obj >> resul.txt
   if errorlevel 2 goto EXIT2
   if exist %HG_ROOT%\%LIB_GUI%\oohg.bak      del %HG_ROOT%\%LIB_GUI%\oohg.bak      > nul
   if exist %HG_ROOT%\%LIB_GUI%\hbprinter.bak del %HG_ROOT%\%LIB_GUI%\hbprinter.bak > nul
   if exist %HG_ROOT%\%LIB_GUI%\miniprint.bak del %HG_ROOT%\%LIB_GUI%\miniprint.bak > nul
   if exist %HG_ROOT%\%LIB_GUI%\bostaurus.bak del %HG_ROOT%\%LIB_GUI%\bostaurus.bak > nul

:SUCCESS

   echo Build finished !!!
   echo Look for new libs at %HG_ROOT%\%LIB_GUI%

:EXIT2

   rem *** Cleanup ***
   del /q *.obj > nul

:EXIT1

   rem *** Cleanup ***
   del /q h_*.c > nul
   if exist winprint.c  del winprint.c  > nul
   if exist miniprint.c del miniprint.c > nul
   if exist bostaurus.c del bostaurus.c > nul
   SET HG_X_FLAGS=
   SET HG_FILES1_PRG=
   SET HG_FILES2_PRG=
   SET HG_FILES_C=

:SHOW_RESULT

   if not exist resul.txt goto END
   type resul.txt | more

:END
