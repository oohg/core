@echo off
rem
rem $Id: compile_mingw.bat $
rem

:COMPILE_MINGW

   if "%HG_ROOT%"  == "" goto ERROR1
   if "%HG_HRB%"   == "" goto ERROR1
   if "%HG_MINGW%" == "" goto ERROR1
   if "%LIB_GUI%"  == "" goto ERROR1
   if "%LIB_HRB%"  == "" goto ERROR1
   if "%BIN_HRB%"  == "" goto ERROR1

:CHECK

   if "%1" == "" goto ERROR2
   if not exist %1.prg goto ERROR3

:CLEAN_EXE

   if exist %1.exe del %1.exe
   if exist %1.exe goto ERROR4
   if exist _temp.rc del _temp.rc
   if exist _temp.rc goto ERROR5
   if exist oohglog.txt del oohglog.txt

:MORE_SETS

   rem *** Version dependent libraries ***
   rem This var must be set by compile.bat
   rem For Harbour 3.0 and 3.2
   rem set HG_ADDLIBS=-lhbpcre -lhbhpdf -llibhpdf -lhbuddall -lrddads
   rem For Harbour 3.4
   rem set HG_ADDLIBS=-lhbpcre2 -lhpdf -lhbhpdf
   rem For xHarbour
   rem set HG_ADDLIBS=-lpcrepos -lhbhpdf -llibharu

   rem *** Third party libraries ***
   rem set HG_ADDLIBS=%HG_ADDLIBS% -lsocket -lmysqldll -ldll -lhbmysql -lrddleto -lrddado -lhbusrrdd

   rem *** Force static linking of this libs ***
   set HG_STATIC_LIBS=-static -static-libgcc

   rem *** Set PATH ***
   set "HG_PATH=%PATH%"
   set "PATH=%HG_MINGW%\bin;%HG_HRB%\%BIN_HRB%"

:PARSE_SWITCHES

   set HG_FILE=%1
   set HG_COMP_TYPE=STD
   set HG_DEFINES=
   set HG_EXTRA=
   set HG_USE_RC=TRUE
   set HG_NO_RUN=FALSE
   set HG_PRG_LOG=
   set HG_C_LOG=1^>nul

:LOOP_START

   if "%2" == ""    goto LOOP_END
   if /I "%2" == "/D"  goto SW_DEBUG
   if /I "%2" == "-D"  goto SW_DEBUG
   if /I "%2" == "/C"  goto SW_CONSOLE
   if /I "%2" == "-C"  goto SW_CONSOLE
   if /I "%2" == "/I"  goto SW_NORC
   if /I "%2" == "-I"  goto SW_NORC
   if /I "%2" == "-P"  goto SW_PPO
   if /I "%2" == "/P"  goto SW_PPO
   if /I "%2" == "-W3" goto SW_W3
   if /I "%2" == "/W3" goto SW_W3
   if /I "%2" == "-NR" goto SW_NORUN
   if /I "%2" == "/NR" goto SW_NORUN
   if /I "%2" == "/L"  goto SW_USELOG
   if /I "%2" == "-L"  goto SW_USELOG
   if /I "%2" == "/S"  goto SW_SILENT
   if /I "%2" == "-S"  goto SW_SILENT
   if /I "%2" == "/V"  goto SW_VERBOSE
   if /I "%2" == "-V"  goto SW_VERBOSE
   set HG_EXTRA=%HG_EXTRA% %2
   shift
   goto LOOP_START

:SW_DEBUG

   set HG_COMP_TYPE=DEBUG
   shift
   goto LOOP_START

:SW_CONSOLE

   set HG_COMP_TYPE=CONSOLE
   set HG_DEFINES=-d_OOHG_CONSOLEMODE_
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
   shift
   goto LOOP_START

:SW_VERBOSE

   set HG_PRG_LOG=
   set HG_C_LOG=
   shift
   goto LOOP_START

:LOOP_END

   set HG_OBJS=%HG_FILE%.o
   if "%HG_USE_RC%" == "FALSE" GOTO WITHOUT_HG_RC

   echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
   if     exist %HG_FILE%.rc copy /b %HG_ROOT%\resources\oohg.rc + %HG_FILE%.rc _temp.rc %HG_C_LOG%
   if not exist %HG_FILE%.rc copy /b %HG_ROOT%\resources\oohg.rc                _temp.rc %HG_C_LOG%
   windres.exe -i _temp.rc -o _temp.o %HG_DEFINES% %HG_C_LOG%
   if errorlevel 1 set HG_NO_RUN=TRUE
   if errorlevel 1 echo Error compiling resources! %HG_PRG_LOG%
   if errorlevel 1 goto CLEANUP
   set HG_OBJS=%HG_OBJS% _temp.o
   goto COMPILE_PRG

:WITHOUT_HG_RC

   if not exist %HG_FILE%.rc goto COMPILE_PRG

   copy /b %HG_FILE%.rc _temp.rc %HG_C_LOG%
   windres -i _temp.rc -o _temp.o %HG_DEFINES% %HG_C_LOG%
   if errorlevel 1 set HG_NO_RUN=TRUE
   if errorlevel 1 echo Error compiling resources! %HG_PRG_LOG%
   if errorlevel 1 goto CLEANUP
   set HG_OBJS=%HG_OBJS% _temp.o

:COMPILE_PRG

   if "%HG_COMP_TYPE%" == "DEBUG" echo OPTIONS NORUNATSTARTUP > init.cld
   if "%HG_COMP_TYPE%" == "DEBUG" set %HG_EXTRA%=-b %HG_EXTRA%
   %HG_HRB%\%BIN_HRB%\harbour %HG_FILE%.prg -n %HG_EXTRA% -i%HG_HRB%\include;%HG_ROOT%\include;. %HG_DEFINES% %HG_PRG_LOG%
   if errorlevel 1 set HG_NO_RUN=TRUE
   if errorlevel 1 goto CLEANUP

:COMPILE_C

   gcc -I. -I%HG_HRB%\include -I%HG_ROOT%\include -Wall -c %HG_FILE%.c -o %HG_FILE%.o %HG_DEFINES% %HG_C_LOG%
   if errorlevel 1 set HG_NO_RUN=TRUE
   if errorlevel 1 echo Error compiling %HG_FILE%.c! %HG_PRG_LOG%
   if errorlevel 1 goto CLEANUP

:CHECK_COMP_TYPE

   if "%HG_COMP_TYPE%" == "CONSOLE" goto CONSOLE_COMP
   if "%HG_COMP_TYPE%" == "DEBUG" goto CONSOLE_COMP

:STD_COMP

   set HG_C_FLAGS=-Wall -mwindows
   if not exist %HG_HRB%\%LIB_HRB%\mainwin.o goto LIBS_HARBOUR
   set HG_OBJS=%HG_HRB%\%LIB_HRB%\mainwin.o %HG_OBJS%
   goto LIBS_XHARBOUR

:CONSOLE_COMP

   set HG_C_FLAGS=-Wall -mconsole
   if not exist %HG_HRB%\%LIB_HRB%\mainstd.o goto LIBS_HARBOUR
   set HG_OBJS=%HG_HRB%\%LIB_HRB%\mainstd.o %HG_OBJS%

:LIBS_XHARBOUR

   set HG_C_LIBS=-lgtgui -lgtwin
   if "%HG_COMP_TYPE%" == "DEBUG" set HG_C_LIBS=-lgtwin -lgtgui -ldebug
   if "%HG_COMP_TYPE%" == "CONSOLE" set HG_C_LIBS=-lgtwin -lgtgui
   set HG_C_LIBS=%HG_C_LIBS% -lcodepage -lcommon -lct -ldbfcdx -ldbffpt -ldbfntx -lhbsix -lhsx
   set HG_C_LIBS=%HG_C_LIBS% -llang -lmacro -lpp -lrdd -lrtl -lvmmt %HG_ADDLIBS%
   set HG_C_LIBS=%HG_C_LIBS% -lfilemem -llibmisc -lhbmzip -lhbodbc -ltip -lhbzebra
   set HG_C_LIBS=%HG_C_LIBS% -lhbzip -lzlib -lodbc32 -lpng -lrddsql -lsddodbc -lsevenzip
   goto OTHER_LIBS

:LIBS_HARBOUR

   set HG_C_LIBS=-lgtgui -lgtwin
   if "%HG_COMP_TYPE%" == "DEBUG" set HG_C_LIBS=-lgtwin -lgtgui -lhbdebug
   if "%HG_COMP_TYPE%" == "CONSOLE" set HG_C_LIBS=-lgtwin -lgtgui
   set HG_C_LIBS=%HG_C_LIBS% -lhbcpage -lhbcommon -lhbct -lrddcdx -lrddfpt -lrddntx -lhbsix -lhbhsx
   set HG_C_LIBS=%HG_C_LIBS% -lhblang -lhbmacro -lhbpp -lhbrdd -lhbrtl -lhbvmmt %HG_ADDLIBS%
   set HG_C_LIBS=%HG_C_LIBS% -lhbmemio -lhbmisc -lhbmzip -lhbodbc -lhbtip -lhbzebra
   set HG_C_LIBS=%HG_C_LIBS% -lhbziparc -lhbzlib -lminizip -lodbc32 -lrddsql -lsddodbc
   rem hbhpdf must precede hbwin, png and xhb
   set HG_C_LIBS=%HG_C_LIBS% -lhbcplr -lhbextern -lhbusrrdd -lrddnsx -lhbwin -lpng -lxhb

:OTHER_LIBS

   rem oohg.lib must be linked first to avoid "multiple definition of hb_gtsys" error
   set HG_C_LIBS=-looHG %HG_C_LIBS% -lbostaurus -lhbprinter -lminiprint
   set HG_C_LIBS=%HG_C_LIBS% -luser32 -lwinspool -lgdi32 -lcomctl32 -lcomdlg32 -lole32 -loleaut32 -luuid
   set HG_C_LIBS=%HG_C_LIBS% -lmpr -lwsock32 -lws2_32 -lmapi32 -lwinmm -lvfw32 -lmsimg32 -liphlpapi

:LINK

   set HG_SEARCH=-L. -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI%
   set HG_C_LIBS=-Wl,--start-group %HG_C_LIBS% -Wl,--end-group
   gcc -o %HG_FILE%.exe %HG_OBJS% %HG_C_FLAGS% %HG_SEARCH% %HG_C_LIBS% %HG_STATIC_LIBS% %HG_DEFINES% %HG_C_LOG%
   if errorlevel 1 set HG_NO_RUN=TRUE
   if errorlevel 1 echo Error linking %HG_FILE%.exe! %HG_PRG_LOG%

:CLEANUP

   set HG_C_FLAGS=
   set HG_C_LIBS=
   set HG_SEARCH=
   if exist %HG_FILE%.o del %HG_FILE%.o
   if exist %HG_FILE%.c del %HG_FILE%.c
   for %%a in ( _temp.* ) do del %%a
   if exist _oohg_resconfig.h del _oohg_resconfig.h
   set HG_OBJS=
   set HG_C_LOG=
   set HG_PRG_LOG=
   set HG_USE_RC=
   set HG_EXTRA=
   set HG_COMP_TYPE=
   set HG_DEFINES=
   set "PATH=%HG_PATH%"
   set HG_PATH=
   set HG_STATIC_LIBS=

   rem *** Run ***
   if "%HG_NO_RUN%" == "FALSE" %HG_FILE%

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
