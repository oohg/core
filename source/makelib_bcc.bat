@echo off
rem
rem $Id: makelib_bcc.bat,v 1.23 2015-12-09 19:49:32 guerra000 Exp $
rem

:MAKELIB_BCC

   cls
   rem *** Set Paths ***
   if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg
   if "%HG_HRB%"==""  set HG_HRB=c:\oohg\harbour
   if "%HG_BCC%"==""  set HG_BCC=c:\borland\bcc55

   rem *** Set EnvVars ***
   if "%LIB_GUI%"=="" set LIB_GUI=lib
   if "%LIB_HRB%"=="" set LIB_HRB=lib
   if "%BIN_HRB%"=="" set BIN_HRB=bin

   rem *** Create Lib Folder ***
   if not exist %HG_ROOT%\%LIB_GUI%\nul md %HG_ROOT%\%LIB_GUI%

   rem *** Delete Old Libraries ***
   if exist %HG_ROOT%\%LIB_GUI%\oohg.lib      del %HG_ROOT%\%LIB_GUI%\oohg.lib
   if exist %HG_ROOT%\%LIB_GUI%\hbprinter.lib del %HG_ROOT%\%LIB_GUI%\hbprinter.lib
   if exist %HG_ROOT%\%LIB_GUI%\miniprint.lib del %HG_ROOT%\%LIB_GUI%\miniprint.lib
   if exist %HG_ROOT%\%LIB_GUI%\bostaurus.lib del %HG_ROOT%\%LIB_GUI%\bostaurus.lib

   rem *** Compile with Harbour ***
   echo Compiling prg files ...
   if exist resul.txt del resul.txt
   call common_make "%HG_HRB%\%LIB_HRB%\tip.lib" -q0 ">> resul.txt 2>&1"
   if errorlevel 1 goto :EXIT1_BCC
   echo. >> resul.txt

   rem *** Compile with BCC ***
   echo Compiling c files ...
   set OOHG_X_FLAGS=-c -O2 -tW -tWM -d -a8 -OS -5 -6 -w -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_HRB%\%LIB_HRB%;%HG_BCC%\lib; -D__XHARBOUR__
   for %%a in ( %HG_FILES1_PRG% ) do if not errorlevel 1 %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
   if errorlevel 1 goto :EXIT2_BCC
   for %%a in ( %HG_FILES2_PRG% ) do if not errorlevel 1 %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
   if errorlevel 1 goto :EXIT2_BCC
   for %%a in ( %HG_FILES_C% )    do if not errorlevel 1 %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% %%a.c >> resul.txt
   if errorlevel 1 goto :EXIT2_BCC
   if exist winprint.c  %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% winprint.c >> resul.txt
   if errorlevel 1 goto :EXIT2_BCC
   if exist miniprint.c %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% miniprint.c >> resul.txt
   if errorlevel 1 goto :EXIT2_BCC
   if exist bostaurus.c %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% bostaurus.c >> resul.txt
   if errorlevel 1 goto :EXIT2_BCC
   echo. >> resul.txt

   rem *** Build Libraries ***
   echo Building libraries ...
   for %%a in ( %HG_FILES1_PRG% ) do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
   if errorlevel 2 goto :EXIT3_BCC
   for %%a in ( %HG_FILES2_PRG% ) do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
   if errorlevel 2 goto :EXIT3_BCC
   for %%a in ( %HG_FILES_C% )    do if not errorlevel 2 %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32 >> resul.txt
   if errorlevel 2 goto :EXIT3_BCC
   if exist winprint.obj  %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\hbprinter +winprint.obj >> resul.txt
   if errorlevel 2 goto :EXIT3_BCC
   if exist miniprint.obj %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\miniprint +miniprint.obj >> resul.txt
   if errorlevel 2 goto :EXIT3_BCC
   if exist bostaurus.obj %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\bostaurus +bostaurus.obj >> resul.txt
   if errorlevel 2 goto :EXIT3_BCC

:EXIT3_BCC

   rem *** Cleanup ***
   IF EXIST %HG_ROOT%\%LIB_GUI%\oohg.bak      del %HG_ROOT%\%LIB_GUI%\oohg.bak
   IF EXIST %HG_ROOT%\%LIB_GUI%\hbprinter.bak del %HG_ROOT%\%LIB_GUI%\hbprinter.bak
   IF EXIST %HG_ROOT%\%LIB_GUI%\miniprint.bak del %HG_ROOT%\%LIB_GUI%\miniprint.bak
   IF EXIST %HG_ROOT%\%LIB_GUI%\bostaurus.bak del %HG_ROOT%\%LIB_GUI%\bostaurus.bak

:EXIT2_BCC

   rem *** Cleanup ***
   del *.obj

:EXIT1_BCC

   rem *** Cleanup ***
   del h_*.c
   if exist winprint.c  del winprint.c
   if exist miniprint.c del miniprint.c
   if exist bostaurus.c del bostaurus.c
   SET OOHG_X_FLAGS=
   SET HG_FILES1_PRG=
   SET HG_FILES2_PRG=
   SET HG_FILES_C=

:SHOW_RESULT_BCC

   if not exist resul.txt goto :END
   type resul.txt | more

:END
