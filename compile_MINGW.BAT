@ECHO OFF

CLS

if exist %1.exe del %1.exe

if exist %1.exe GOTO ERREXIT

set tpath=%path%
set PATH=c:\oohg\mingw\bin
set MINGW=c:\oohg\mingw
set HRB_DIR=c:\oohg\harbour
set ooHG_INSTALL=c:\oohg

echo #define oohgpath %oohg_INSTALL%\RESOURCES > _oohg_resconfig.h

if exist %1.rc copy /b %ooHG_INSTALL%\resources\ooHG.rc+%1.rc+%ooHG_INSTALL%\resources\filler _temp.rc >NUL
if exist %1.rc windres -i _temp.rc -o _temp.o

if "%2"=="/d" GOTO DEBUG_COMP
if "%2"=="/D" GOTO DEBUG_COMP

if "%2"=="/c" GOTO CONSOLE_COMP
if "%2"=="/C" GOTO CONSOLE_COMP

GOTO STD_COMP

:CONSOLE_COMP

%HRB_DIR%\bin\harbour %1.prg -n -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
gcc -I. -I%HRB_DIR%\include -mno-cygwin -Wall -c %1.c -o%1.o
  
if exist %1.rc gcc -Wall -o%1.exe %1.o _temp.o -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbpp -lhbrtl -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lhbodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -lgtgui -lgtwin -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbpp -lhbrtl -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lhbodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32  -Wl,--end-group
                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
GOTO END_COMPILE

:STD_COMP

%HRB_DIR%\bin\harbour %1.prg -n -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
gcc -I. -I%HRB_DIR%\include -mno-cygwin -Wall -c %1.c -o%1.o

if exist %1.rc gcc -Wall -o%1.exe %1.o _temp.o -mwindows -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbpp -lhbrtl -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lhbodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -mwindows -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lgtgui -lhbsix -lhbvm -lhbrdd -lhbmacro -lhbpp -lhbrtl -lhblang -lhbcommon -lhbnulrdd -lrddntx -lrddcdx -lrddfpt -lhbct -lhbmisc -lhbodbc -lodbc32 -lsocket -lhbmysql -lmysqldll -ldll -lhbwin -lhbcpage -lhbmzip -lhbzlib -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -Wl,--end-group

GOTO END_COMPILE

:DEBUG_COMP

ECHO OPTIONS NORUNATSTARTUP > INIT.CLD

%HRB_DIR%\bin\harbour %1.prg -n -b -i%HRB_DIR%\include;%ooHG_INSTALL%\include;.
gcc -I. -I%HRB_DIR%\include -mno-cygwin -Wall -c %1.c -o%1.o

if exist %1.rc gcc -Wall -o%1.exe %1.o _temp.o -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbsix -lvm -lrdd -lmacro -lpp -lrtl -lpp -llang -lcommon -lnulsys -ldbfntx -ldbfcdx -ldbffpt -lgtwin -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lct -lmisc -lhbodbc -lodbc32 -lsocket -lmysql -lmysqldll -ldebug -ldll -lhbole -lcodepage -Wl,--end-group
if not exist %1.rc gcc -Wall -o%1.exe %1.o %ooHG_INSTALL%\resources\ooHG.o -L%MINGW%\lib -L%HRB_DIR%\lib -L%ooHG_INSTALL%\lib -mno-cygwin -Wl,--start-group -looHG -lhbprinter -lminiprint -lhbsix -lvm -lrdd -lmacro -lpp -lrtl -lpp -llang -lcommon -lnulsys -ldbfntx -ldbfcdx -ldbffpt -lgtwin -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lct -lmisc -lhbodbc -lodbc32 -lsocket -lmysql -lmysqldll -ldebug -ldll -lhbole -lcodepage -Wl,--end-group

:END_COMPILE

del %1.c
del %1.o
if exist _temp.rc del _temp.rc
if exist _temp.o del _temp.o
set path=%tpath%

if exist %1.exe %1.exe

if exist INIT.CLD del INIT.CLD

GOTO ENDBATCH

:ERREXIT

ECHO COMPILE ERROR: IS %1.EXE RUNNING ?

:ENDBATCH

rem ----------------------------------------------------------

set path=%tpath%

