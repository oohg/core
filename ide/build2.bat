

@echo off
SET ooHG_INSTALL=c:\oohg
SET HB_ARCHITECTURE=win
SET HB_COMPILER=mingw
set PATH=%ooHG_INSTALL%\Harbour\bin;%ooHG_INSTALL%\Mingw\bin;%ooHG_INSTALL%\MinGW\libexec\gcc\mingw32\3.4.5\;e:\bison\bin;%PATH%
SET INCLUDE=%ooHG_INSTALL%\include;%ooHG_INSTALL%\Mingw\include;%ooHG_INSTALL%\Harbour\include;.;%INCLUDE%
SET LIB=%ooHG_INSTALL%\Harbour\lib;%ooHG_INSTALL%\Mingw\lib;%ooHG_INSTALL%\lib

echo #define oohgpath %oohg_INSTALL%\resources > _oohg_resconfig.h


copy /b %ooHG_INSTALL%\resources\ooHG.rc _temp.rc >NUL
if exist _temp.rc windres -i _temp.rc -o _temp.o

if exist %1.rc copy /b %ooHG_INSTALL%\resources\ooHG.rc+%1.rc+%ooHG_INSTALL%\resources\filler _temp.rc >NUL
if exist %1.rc windres -i _temp.rc -o _temp.o

if exist %1.hbp hbmk2 %1.hbp %2 %3 %4 %ooHG_INSTALL%\oohg.hbc

if exist %1.prg hbmk2 %1 %2 %3 %4 %ooHG_INSTALL%\oohg.hbc

%ooHG_INSTALL%\harbour\bin\hbmk2 %1 %2 %3 %4 %5 %6

if exist _temp.rc del _temp.rc
if exist _temp.o del _temp.o



