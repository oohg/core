@echo off
rem
rem $Id: compile_MINGW.BAT,v 1.27 2013-10-12 00:00:58 fyurisich Exp $
rem
cls

REM *** Check for .prg ***
if "%1"=="" goto EXIT
if not exist %1.prg goto ERREXIT1

rem *** Delete Old Executable ***
if exist %1.exe del %1.exe
if exist %1.exe goto ERREXIT2

rem *** Set Paths ***
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=%HG_ROOT%\harbour
if "%HG_MINGW%"=="" set HG_MINGW=%HG_ROOT%\mingw

rem *** To Build with Nightly Harbour ***
rem set HG_HRB=c:\hb32
rem *** For 32 bits MinGW ***
rem set HG_MINGW=%HG_HRB%\comp\mingw
rem *** For 64 bits MinGW ***
rem set HG_MINGW=%HG_HRB%\comp\mingw64

rem *** Set EnvVars ***
if "%LIB_GUI%"=="" set LIB_GUI=lib
if "%LIB_HRB%"=="" set LIB_HRB=lib
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** To Build with Nightly Harbour ***
rem *** For 32 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw
rem set LIB_HRB=lib\win\mingw
rem set BIN_HRB=bin\win\mingw
rem *** For 64 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw64
rem set LIB_HRB=lib\win\mingw64
rem set BIN_HRB=bin\win\mingw64

rem *** Third Party Libraries ***
set THR_LIB=
rem THR_LIB=-lsocket -lmysqldll -ldll

rem *** Set PATH ***
set TPATH=%PATH%
set PATH=%HG_MINGW%\bin;%HG_HRB%\%BIN_HRB%

rem *** Parse Switches ***
set TFILE=%1
set COMP_TYPE=STD
set EXTRA=
set RC_FILE=TRUE
:LOOP_START
if "%2"==""    goto LOOP_END
if "%2"=="/d"  goto COMP_DEBUG
if "%2"=="/D"  goto COMP_DEBUG
if "%2"=="/c"  goto COMP_CONSOLE
if "%2"=="/C"  goto COMP_CONSOLE
if "%2"=="/i"  goto NORC
if "%2"=="/I"  goto NORC
if "%2"=="-p"  goto PPO
if "%2"=="-P"  goto PPO
if "%2"=="-w3" goto W3
if "%2"=="-W3" goto W3
set EXTRA=%EXTRA% %2
shift
goto LOOP_START
:COMP_DEBUG
set COMP_TYPE=DEBUG
shift
goto LOOP_START
:COMP_CONSOLE
set COMP_TYPE=CONSOLE
shift
goto LOOP_START
:NORC
set RC_FILE=FALSE
shift
goto LOOP_START
:PPO
set EXTRA=%EXTRA% -p
shift
goto LOOP_START
:W3
set EXTRA=%EXTRA% -w3
shift
goto LOOP_START
:LOOP_END

rem *** Check for Console Switch ***
if "%COMP_TYPE%"=="CONSOLE" goto CONSOLE_COMP

rem *** Check for Debug Switch ***
if "%COMP_TYPE%"=="DEBUG" goto DEBUG_COMP

goto STD_COMP


:CONSOLE_COMP
rem *** Compile with Harbour and Check for Errors ***
%HG_HRB%\%BIN_HRB%\harbour %TFILE%.prg -n %EXTRA% -i%HG_HRB%\include;%HG_ROOT%\include;.
if errorlevel 1 goto EXIT1

rem *** Compile .c Files and Check for Errors ***
gcc -I. -I%HG_HRB%\include -I%HG_ROOT%\include -Wall -c %TFILE%.c -o%TFILE%.o
rem *** To Use -mno-cygwin Switch ***
rem gcc -I. -I%HG_HRB%\include -I%HG_ROOT%\include -mno-cygwin -Wall -c %TFILE%.c -o%TFILE%.o
if errorlevel 1 goto EXIT2

rem *** Check for Exclude OOHG Resource Switch ***
if not "%RC_FILE%"=="TRUE" GOTO CONSOLE_COMP_WITHOUT_RC

rem *** Process Resource File and OOHG Resource File ***
echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
if exist %TFILE%.rc copy /b %HG_ROOT%\resources\ooHG.rc+%TFILE%.rc+%HG_ROOT%\resources\filler _temp.rc > nul
if exist %TFILE%.rc windres -i _temp.rc -o _temp.o
if errorlevel 1 goto EXIT3

rem *** Link ***
if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o %HG_ROOT%\resources\ooHG.o -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem *** To Use -mno-cygwin Switch ***
rem if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group                 -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o %HG_ROOT%\resources\ooHG.o -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

goto CLEANUP


:CONSOLE_COMP_WITHOUT_RC
rem *** Process Resource File Without OOHG Resource ***
if exist %TFILE%.rc copy /b %TFILE%.rc _temp.rc > nul
if exist %TFILE%.rc windres -i _temp.rc -o _temp.o
if errorlevel 1 goto EXIT3

rem *** Link ***
if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o                            -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem *** To Use -mno-cygwin Switch ***
rem if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group                 -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o                            -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

goto CLEANUP


:DEBUG_COMP
rem *** Compile with Harbour and Check for Errors ***
echo OPTIONS NORUNATSTARTUP > init.cld
%HG_HRB%\%BIN_HRB%\harbour %TFILE%.prg -n %EXTRA% -b -i%HG_HRB%\include;%HG_ROOT%\include;.
if errorlevel 1 goto EXIT1

rem *** Compile .c Files and Check for Errors ***
gcc -I. -I%HG_HRB%\include -I%HG_ROOT%\include -Wall -c %TFILE%.c -o%TFILE%.o
rem *** To Use -mno-cygwin Switch ***
rem gcc -I. -I%HG_HRB%\include -I%HG_ROOT%\include -mno-cygwin -Wall -c %TFILE%.c -o%TFILE%.o
if errorlevel 1 goto EXIT2

rem *** Check for Exclude OOHG Resource Switch ***
if not "%RC_FILE%"=="TRUE" GOTO DEBUG_COMP_WITHOUT_RC

rem *** Process Resource File and OOHG Resource File ***
echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
if exist %TFILE%.rc copy /b %HG_ROOT%\resources\ooHG.rc+%TFILE%.rc+%HG_ROOT%\resources\filler _temp.rc > nul
if exist %TFILE%.rc windres -i _temp.rc -o _temp.o
if errorlevel 1 goto EXIT3

rem *** Link ***
if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_DIR% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o %HG_ROOT%\resources\ooHG.o -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_DIR% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem *** To Use -mno-cygwin Switch ***
rem if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_DIR% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o %HG_ROOT%\resources\ooHG.o -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_DIR% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

goto CLEANUP


:DEBUG_COMP_WITHOUT_RC
rem *** Process Resource File Without OOHG Resource ***
if exist %TFILE%.rc copy /b %TFILE%.rc _temp.rc > nul
if exist %TFILE%.rc windres -i _temp.rc -o _temp.o
if errorlevel 1 goto EXIT3

rem *** Link ***
if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_DIR% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o                            -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_DIR% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem *** To Use -mno-cygwin Switch ***
rem if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_DIR% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o %                          -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_DIR% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

goto CLEANUP


:STD_COMP
rem *** Compile with Harbour and Check for Errors ***
%HG_HRB%\%BIN_HRB%\harbour %TFILE%.prg -n %EXTRA% -i%HG_HRB%\include;%HG_ROOT%\include;.
if errorlevel 1 goto EXIT1

rem *** Compile .c Files and Check for Errors ***
gcc -I. -I%HG_HRB%\include -I%HG_ROOT%\include -Wall -c %TFILE%.c -o%TFILE%.o
rem *** Use -mno-cygwin Switch ***
rem gcc -I. -I%HG_HRB%\include -I%HG_ROOT%\include -mno-cygwin -Wall -c %TFILE%.c -o%TFILE%.o

rem *** Check for Exclude OOHG Resource Switch ***
if not "%RC_FILE%"=="TRUE" GOTO STD_COMP_WITHOUT_RC

rem *** Process Resource File ***
echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
if exist %TFILE%.rc copy /b %HG_ROOT%\resources\ooHG.rc+%TFILE%.rc+%HG_ROOT%\resources\filler _temp.rc > nul
if exist %TFILE%.rc windres -i _temp.rc -o _temp.o
if errorlevel 1 goto EXIT3

rem *** Link ***
if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -mwindows -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o %HG_ROOT%\resources\ooHG.o -mwindows -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem *** Use -mno-cygwin Switch ***
rem if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -mwindows -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o %HG_ROOT%\resources\ooHG.o -mwindows -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

goto CLEANUP


:STD_COMP_WITHOUT_RC
rem *** Process Resource File Without OOHG Resource ***
if exist %TFILE%.rc copy /b %TFILE%.rc _temp.rc > nul
if exist %TFILE%.rc windres -i _temp.rc -o _temp.o
if errorlevel 1 goto EXIT3

rem *** Link ***
if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -mwindows -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o                            -mwindows -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem *** Use -mno-cygwin Switch ***
rem if     exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o _temp.o                    -mwindows -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
rem if not exist %TFILE%.rc gcc -Wall -o%TFILE%.exe %TFILE%.o                            -mwindows -L%HG_MINGW%\lib -L%HG_HRB%\%LIB_HRB% -L%HG_ROOT%\%LIB_GUI% -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lhbmysql %THR_LIB% -lhbwin -lhbcpage -lhbmzip -lminizip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

goto CLEANUP


:ERREXIT1
echo FILE %1.PRG NOT FOUND !!!

goto EXIT


:ERREXIT2
echo COMPILE ERROR: IS %1.EXE RUNNING ?

goto EXIT


:CLEANUP
rem *** Check for Errors in Linking ***
if errorlevel 1 goto EXIT4

rem *** Cleanup ***
if exist _temp.o del _temp.o
if exist _temp.rc del _temp.rc
del _oohg_resconfig.h
del %TFILE%.o
del %TFILE%.c
set THR_LIB=
set COMP_TYPE=
set EXTRA=
set PATH=%TPATH%
set TPATH=

rem *** Execute ***
%TFILE%
set TFILE=
goto EXIT


:EXIT4
rem *** Cleanup ***
if exist _temp.o del _temp.o


:EXIT3
rem *** Cleanup ***
if exist _temp.rc del _temp.rc
del _oohg_resconfig.h
del %TFILE%.o


:EXIT2
rem *** Cleanup ***
del %TFILE%.c


:EXIT1
rem *** Cleanup ***
set THR_LIB=
set COMP_TYPE=
set EXTRA=
set PATH=%TPATH%
set TPATH=


:EXIT
rem *** Cleanup ***
if exist init.cld del init.cld
