@echo off
rem
rem $Id: compile_bcc.bat $
rem

:COMPILE_BCC

   if "%HG_ROOT%" == "" goto ERROR1
   if "%HG_HRB%"  == "" goto ERROR1
   if "%HG_BCC%"  == "" goto ERROR1
   if "%LIB_GUI%" == "" goto ERROR1
   if "%LIB_HRB%" == "" goto ERROR1
   if "%BIN_HRB%" == "" goto ERROR1

:CHECK

   if "%1" == "" goto ERROR2
   if not exist %1.prg goto ERROR3

:CLEAN_EXE

   if exist %1.exe del %1.exe
   if exist %1.exe goto ERROR4
   if exist _temp.rc del _temp.rc
   if exist _temp.rc goto ERROR5
   if exist oohglog.txt del oohglog.txt

:PARSE_SWITCHES

   set HG_C_FLAGS=
   set HG_C_LIBS=
   set HG_C_LOG=1^>nul
   set HG_COMP_TYPE=STD
   set HG_DEFINES=
   set HG_EXTRA=
   set HG_FILE=%1
   set HG_NO_RUN=FALSE
   set HG_PRG_LOG=
   set HG_SEARCH=
   set HG_USE_RC=TRUE
   set HG_W_LIBS=

:LOOP_START

   if    "%2" == ""       goto LOOP_END
   if /I "%2" == "/C"     goto SW_CONSOLE
   if /I "%2" == "/D"     goto SW_DEBUG
   if /I "%2" == "/GTWIN" goto SW_CONSOLE
   if /I "%2" == "/L"     goto SW_USELOG
   if /I "%2" == "/LOG"   goto SW_USELOG
   if /I "%2" == "/NORC"  goto SW_NORC
   if /I "%2" == "/NR"    goto SW_NORUN
   if /I "%2" == "/P"     goto SW_PPO
   if /I "%2" == "/S"     goto SW_SILENT
   if /I "%2" == "/SL"    goto SW_SILENT
   if /I "%2" == "/V"     goto SW_VERBOSE
   if /I "%2" == "/W3"    goto SW_W3
   if /I "%2" == "-C"     goto SW_CONSOLE
   if /I "%2" == "-D"     goto SW_DEBUG
   if /I "%2" == "-GTWIN" goto SW_CONSOLE
   if /I "%2" == "-L"     goto SW_USELOG
   if /I "%2" == "-LOG"   goto SW_USELOG
   if /I "%2" == "-NORC"  goto SW_NORC
   if /I "%2" == "-NR"    goto SW_NORUN
   if /I "%2" == "-P"     goto SW_PPO
   if /I "%2" == "-S"     goto SW_SILENT
   if /I "%2" == "-SL"    goto SW_SILENT
   if /I "%2" == "-V"     goto SW_VERBOSE
   if /I "%2" == "-W3"    goto SW_W3
   set HG_EXTRA=%HG_EXTRA% %2
   shift
   goto LOOP_START

:SW_DEBUG

   set HG_COMP_TYPE=DEBUG
   set HG_DEFINES=-D_OOHG_CONSOLEMODE_
   shift
   goto LOOP_START

:SW_CONSOLE

   set HG_COMP_TYPE=CONSOLE
   set HG_DEFINES=-D_OOHG_CONSOLEMODE_
   shift
   goto LOOP_START

:SW_NORC

   set HG_USE_RC=FALSE
   shift
   goto LOOP_START

:SW_PPO

   set HG_EXTRA=%HG_EXTRA% -p
   shift
   goto LOOP_START

:SW_W3

   set HG_EXTRA=%HG_EXTRA% -w3
   shift
   goto LOOP_START

:SW_NORUN

   set HG_NO_RUN=TRUE
   shift
   goto LOOP_START

:SW_USELOG

   set HG_PRG_LOG=-q 1^>^>oohglog.txt 2^>^>^&1
   set HG_C_LOG=1^>^>oohglog.txt 2^>^>^&1
   shift
   goto LOOP_START

:SW_SILENT

   set HG_PRG_LOG=1^>nul 2^>^&1
   set HG_C_LOG=1^>nul 2^>^&1
   set HG_C_FLAGS=-q
   shift
   goto LOOP_START

:SW_VERBOSE

   set HG_PRG_LOG=
   set HG_C_LOG=
   shift
   goto LOOP_START

:LOOP_END

   set HG_SEARCH=-i%HG_ROOT%\resources;%HG_ROOT%\include;%HG_BCC%\include;
   if not "%HG_INC_RC%" == "" set HG_SEARCH=%HG_SEARCH%;%HG_INC_RC%

   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h

   if "%HG_USE_RC%" == "FALSE" goto WITHOUT_HG_RC

   echo. > %HG_ROOT%\resources\filler
   if     exist %HG_FILE%.rc copy /b %HG_FILE%.rc + %HG_ROOT%\resources\filler + %HG_ROOT%\resources\oohg_bcc.rc _temp.rc %HG_C_LOG%
   if not exist %HG_FILE%.rc copy /b %HG_ROOT%\resources\oohg_bcc.rc _temp.rc %HG_C_LOG%
   if not exist _temp.rc echo COMPILE ERROR: Error creating file _temp.rc !!!
   if not exist _temp.rc goto CLEANUP
   "%HG_BCC%\bin\brc32.exe" -r %HG_SEARCH% _temp.rc %HG_C_LOG%
   if errorlevel 1 goto CLEANUP
   goto COMPILE_PRG

:WITHOUT_HG_RC

   if not exist %HG_FILE%.rc goto COMPILE_PRG

   copy /b %HG_FILE%.rc _temp.rc %HG_C_LOG%
   if not exist _temp.rc echo COMPILE ERROR: Error creating file _temp.rc !!!
   if not exist _temp.rc goto CLEANUP
   %HG_BCC%\bin\brc32.exe -r %HG_SEARCH% _temp.rc %HG_C_LOG%
   if errorlevel 1 goto CLEANUP

:COMPILE_PRG

   if "%HG_COMP_TYPE%" == "DEBUG" echo OPTIONS NORUNATSTARTUP > init.cld
   if "%HG_COMP_TYPE%" == "DEBUG" set %HG_EXTRA%=-b %HG_EXTRA%
   set HG_SEARCH=-i%HG_HRB%\include;%HG_ROOT%\include;.
   if not "%HG_INC_HRB%" == "" set HG_SEARCH=%HG_SEARCH%;%HG_INC_HRB%
   %HG_HRB%\%BIN_HRB%\harbour %HG_FILE%.prg -n %HG_EXTRA% %HG_SEARCH% %HG_DEFINES% %HG_PRG_LOG%
   if errorlevel 1 set HG_NO_RUN=TRUE
   if errorlevel 1 goto CLEANUP

:COMPILE_C

   set HG_SEARCH=-I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include;%HG_INC_CCOMP%
   %HG_BCC%\bin\bcc32 -c -O2 -tW -tWM -M -w %HG_SEARCH% -L%HG_BCC%\lib; %HG_FILE%.c %HG_C_LOG%
   if errorlevel 1 set HG_NO_RUN=TRUE
   if errorlevel 1 echo Error compiling %HG_FILE%.c! %HG_PRG_LOG%
   if errorlevel 1 goto CLEANUP
   if "%HG_FLAVOR%" == "HARBOUR" goto LIBS_HARBOUR

:LIBS_XHARBOUR

   set HG_C_LIBS=gtgui gtwin
   if "%HG_COMP_TYPE%" == "DEBUG" set HG_C_LIBS=gtwin gtgui debug
   if "%HG_COMP_TYPE%" == "CONSOLE" set HG_C_LIBS=gtwin gtgui
   set HG_C_LIBS=%HG_C_LIBS% rtl vmmt rdd codepage common ct dbfcdx dbffpt
   set HG_C_LIBS=%HG_C_LIBS% dbfntx hbsix hsx lang macro pp %HG_ADDLIBS%
   set HG_C_LIBS=%HG_C_LIBS% filemem libmisc hbmzip tip hbzebra
   set HG_C_LIBS=%HG_C_LIBS% hbzip rddsql sevenzip
   set HG_C_LIBS=%HG_C_LIBS% hbhpdf libharu png
   goto LIBS_WINDOWS

:LIBS_HARBOUR

   set HG_C_LIBS=gtgui gtwin
   if "%HG_COMP_TYPE%" == "DEBUG" set HG_C_LIBS=gtwin gtgui hbdebug
   if "%HG_COMP_TYPE%" == "CONSOLE" set HG_C_LIBS=gtwin gtgui
   set HG_C_LIBS=%HG_C_LIBS% hbrtl hbvmmt hbrdd hbcpage hbcommon hbct rddcdx rddfpt
   set HG_C_LIBS=%HG_C_LIBS% rddntx hbsix hbhsx hblang hbmacro hbpp
   set HG_C_LIBS=%HG_C_LIBS% hbmemio hbmisc hbmzip hbtip hbzebra
   set HG_C_LIBS=%HG_C_LIBS% rddsql hbziparc minizip
   rem hbhpdf must precede hbwin, png and xhb
   rem %HG_ADDLIBS% must be at the end in case the user adds xhb
   rem xhb must always the last lib
   set HG_C_LIBS=%HG_C_LIBS% hbhpdf hpdf hbwin png %HG_ADDLIBS%

:LIBS_WINDOWS

   set HG_W_LIBS=cw32mt import32 user32 winspool gdi32 comctl32 comdlg32 shell32 ole32 oleaut32 uuid mpr wsock32 ws2_32 mapi32 winmm vfw32 msimg32 iphlpapi

:BUILD_RESPONSE_FILE:

   echo c0w32.obj + > b32.bc
   echo %HG_FILE%.obj, + >> b32.bc
   echo %HG_FILE%.exe, + >> b32.bc
   echo %HG_FILE%.map, + >> b32.bc
   echo %HG_ROOT%\%LIB_GUI%\oohg.lib + >> b32.bc
   echo %HG_ROOT%\%LIB_GUI%\bostaurus.lib + >> b32.bc
   echo %HG_ROOT%\%LIB_GUI%\hbprinter.lib + >> b32.bc
   echo %HG_ROOT%\%LIB_GUI%\miniprint.lib + >> b32.bc
   for %%a in ( %HG_C_LIBS% ) do if exist %HG_HRB%\%LIB_HRB%\%%a.lib echo %HG_HRB%\%LIB_HRB%\%%a.lib + >> b32.bc
   for %%a in ( %HG_W_LIBS% ) do echo %%a.lib + >> b32.bc
   echo , , + >> b32.bc
   if exist _temp.res echo _temp.res >> b32.bc

:LINK

   set HG_SEARCH=-L%HG_BCC%\lib;%HG_BCC%\lib\psdk;
   if not "%HG_COMP_TYPE%" == "DEBUG" set HG_C_FLAGS=-Gn -Tpe -aa %HG_C_FLAGS%
   if     "%HG_COMP_TYPE%" == "DEBUG" set HG_C_FLAGS=-Gn -Tpe -ap %HG_C_FLAGS%
   %HG_BCC%\bin\ilink32.exe %HG_C_FLAGS% %HG_SEARCH% @b32.bc %HG_C_LOG%

:CLEANUP

   if exist b32.bc        del b32.bc
   if exist %HG_FILE%.map del %HG_FILE%.map
   if exist %HG_FILE%.obj del %HG_FILE%.obj
   if exist %HG_FILE%.tds del %HG_FILE%.tds
   if exist %HG_FILE%.c   del %HG_FILE%.c
   for %%a in ( _temp.* ) do del %%a
   set HG_C_FLAGS=
   set HG_C_LIBS=
   set HG_C_LOG=
   set HG_DEFINES=
   set HG_EXTRA=
   set HG_PRG_LOG=
   set HG_SEARCH=
   set HG_USE_RC=
   set HG_W_LIBS=

   rem *** Run ***
   if errorlevel 1 set HG_NO_RUN=TRUE
   if "%HG_NO_RUN%" == "FALSE" if     "%HG_COMP_TYPE%" == "CONSOLE" %HG_FILE%
   if "%HG_NO_RUN%" == "FALSE" if not "%HG_COMP_TYPE%" == "CONSOLE" start %HG_FILE%

   set HG_COMP_TYPE=
   set HG_FILE=
   set HG_NO_RUN=
   if exist init.cld del init.cld
   goto END

:ERROR1

   echo This file must be called from COMPILE.BAT !!!
   goto END

:ERROR2

   echo COMPILE ERROR: No file specified !!!
   goto END

:ERROR3

   echo File %1.prg not found !!!
   goto END

:ERROR4

   echo COMPILE ERROR: Is %1.exe running ?
   goto END

:ERROR5

   echo Cant't delete _temp.rc file !!!
   goto END

:END
