@echo off
rem
rem $Id: compile_MINGW.BAT,v 1.16 2012-09-17 00:29:57 fyurisich Exp $
rem
cls

if exist %1.exe del %1.exe
if exist %1.exe GOTO ERREXIT

set TPATH=%PATH%
set PATH=c:\oohg\mingw\bin
set MINGW=c:\oohg\mingw
set HRB_DIR=c:\oohg\harbour
set ooHG_INSTALL=c:\oohg

echo #define oohgpath %oohg_INSTALL%\RESOURCES > _oohg_resconfig.h

if exist %1.rc copy /b %ooHG_INSTALL%\resources\ooHG.rc+%1.rc+%ooHG_INSTALL%\resources\filler _temp.rc > nul
if exist %1.rc windres -i _temp.rc -o _temp.o

set EXTRA=
if "%3"=="/p" set EXTRA=-p
if "%3"=="/P" set EXTRA=-p

if "%2"=="/d" goto DEBUG_COMP
if "%2"=="/D" goto DEBUG_COMP

if "%2"=="/c" goto CONSOLE_COMP
if "%2"=="/C" goto CONSOLE_COMP

if "%2"=="/p" set EXTRA=-p
if "%2"=="/P" set EXTRA=-p

goto STD_COMP

:CONSOLE_COMP

%HRB_DIR%\bin\harbour %1.prg -n %EXTRA% -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -mno-cygwin -Wall -c %1.c -o%1.o
  
if     exist %1.rc gcc -Wall -o%1.exe %1.o _temp.o                         -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group                 -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

goto END_COMPILE

:STD_COMP

%HRB_DIR%\bin\harbour %1.prg -n %EXTRA% -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -mno-cygwin -Wall -c %1.c -o%1.o

if     exist %1.rc gcc -Wall -o%1.exe %1.o _temp.o                         -mwindows -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -mwindows -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

goto END_COMPILE

:DEBUG_COMP

echo OPTIONS NORUNATSTARTUP > init.cld

%HRB_DIR%\bin\harbour %1.prg -n %EXTRA% -b -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
gcc -I. -I%HRB_DIR%\include -I%ooHG_INSTALL%\include -mno-cygwin -Wall -c %1.c -o%1.o

if     exist %1.rc gcc -Wall -o%1.exe %1.o _temp.o                         -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbdebug -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbmemio -lhbpp -lhbrtl -lhbziparc -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lxhb -lhbodbc -lrddsql -lsddodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -lhbtip -lhbpcre -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lws2_32 -Wl,--end-group

:END_COMPILE

del %1.c
del %1.o
if exist _temp.rc del _temp.rc
if exist _temp.o del _temp.o
if exist _oohg_resconfig.h del _oohg_resconfig.h
set PATH=%TPATH%

if exist %1.exe %1.exe

if exist init.cld del init.cld

goto ENDBATCH

:ERREXIT

echo COMPILE ERROR: IS %1.EXE RUNNING ?

:ENDBATCH
