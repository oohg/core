@echo off
rem
rem $Id: MakeDistro.bat,v 1.7 2015-03-13 23:04:04 fyurisich Exp $
rem
cls

:PARAMS
setlocal enableextensions
if errorlevel 1 goto ERROR7
if /I "%1"=="HB30" goto CONTINUE
if /I "%1"=="HB32" goto CONTINUE
echo.
echo Usage: MakeDistro HarbourVersion [ /C ]
echo where HarbourVersion = HB30 or HB32
echo and /C switch requests the erase of the
echo destination folder before making the distro.
echo.
goto END

:ERROR1
echo.
echo Can't create folder %BASE_DISTRO_DIR%
echo.
goto END

:ERROR2
echo.
echo %HG_ROOT%\MakeExclude.txt is missing
echo.
goto END

:ERROR3
echo.
echo Can't create subfolder %BASE_DISTRO_SUBDIR%
echo.
goto END

:ERROR4
echo.
echo Can't delete folder %BASE_DISTRO_DIR%
echo.
goto END

:ERROR5
echo.
echo Can't find subfolder %BASE_DISTRO_SUBDIR%
echo.
goto END

:ERROR6
echo.
echo Folder %BASE_DISTRO_DIR% is not valid !!!
echo.
goto END

:ERROR7
echo.
echo Can't run because CMD extensions are not enabled !!!
echo.
goto END

:CONTINUE
rem Change this sets to use different sources for OOHG, Harbour and MinGW
if "%HG_ROOT%" == "" set HG_ROOT=C:\OOHG
if not exist %HG_ROOT%\MakeExclude.txt goto ERROR2
if /I "%1"=="HB30" set HG_HRB=C:\HB30
if /I "%1"=="HB30" set HG_MINGW=C:\HB30\COMP\MINGW
if /I "%1"=="HB32" set HG_HRB=C:\HB32
if /I "%1"=="HB32" set HG_MINGW=C:\HB32\COMP\MINGW

:DISTRO_FOLDER
if not "%BASE_DISTRO_DIR%"=="" goto PREPARE
if /I "%1"=="HB30" set BASE_DISTRO_DIR=C:\OOHG_HB30
if /I "%1"=="HB32" set BASE_DISTRO_DIR=C:\OOHG_HB32

:PREPARE
echo Preparing folder %BASE_DISTRO_DIR% ...
echo.

:CLEAN
if /I "%BASE_DISTRO_DIR%"=="C:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="D:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="E:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="F:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="G:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="H:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="I:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="J:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="K:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="L:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="M:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="N:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="O:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="P:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="Q:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="R:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="S:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="T:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="U:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="V:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="W:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="X:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="Y:" goto ERROR6
if /I "%BASE_DISTRO_DIR%"=="Z:" goto ERROR6
if not exist %BASE_DISTRO_DIR%\nul goto CREATE
if /I "%2"=="/C" del /f /s /q %BASE_DISTRO_DIR%\*.* >nul
if /I "%2"=="/C" attrib -s -h %BASE_DISTRO_DIR%\*.* /s /d
if /I "%2"=="/C" del /f /s /q %BASE_DISTRO_DIR%\*.* >nul
if /I "%2"=="/C" rd /s /q %BASE_DISTRO_DIR%
if /I "%2"=="/C" if exist %BASE_DISTRO_DIR%\nul goto ERROR4

:CREATE
if not exist %BASE_DISTRO_DIR%\nul md %BASE_DISTRO_DIR%
if not exist %BASE_DISTRO_DIR%\nul goto ERROR1

:FOLDERS
pushd %BASE_DISTRO_DIR%
set BASE_DISTRO_SUBDIR=doc
if not exist doc\nul md doc
if not exist doc\nul goto ERROR3
if /I "%1"=="HB30" set BASE_DISTRO_SUBDIR=hb30
if /I "%1"=="HB30" if not exist hb30\nul md hb30
if /I "%1"=="HB30" if not exist hb30\nul goto ERROR3
if /I "%1"=="HB32" set BASE_DISTRO_SUBDIR=hb32
if /I "%1"=="HB32" if not exist hb32\nul md hb32
if /I "%1"=="HB32" if not exist hb32\nul goto ERROR3
set BASE_DISTRO_SUBDIR=ide
if not exist ide\nul md ide
if not exist ide\nul goto ERROR3
set BASE_DISTRO_SUBDIR=include
if not exist include\nul md include
if not exist include\nul goto ERROR3
if /I "%1"=="HB30" set BASE_DISTRO_SUBDIR=lib
if /I "%1"=="HB32" set BASE_DISTRO_SUBDIR=lib\hb\mingw
if not exist %BASE_DISTRO_SUBDIR%\nul md %BASE_DISTRO_SUBDIR%
if not exist %BASE_DISTRO_SUBDIR%\nul goto ERROR3
set BASE_DISTRO_SUBDIR=manual
if not exist manual\nul md manual
if not exist manual\nul goto ERROR3
set BASE_DISTRO_SUBDIR=resources
if not exist resources\nul md resources
if not exist resources\nul goto ERROR3
set BASE_DISTRO_SUBDIR=samples
if not exist samples\nul md samples
if not exist samples\nul goto ERROR3
set BASE_DISTRO_SUBDIR=source
if not exist source\nul md source
if not exist source\nul goto ERROR3

:FILES
echo Copying files ...
echo.
:ROOT
echo %HG_ROOT% ...
xcopy %HG_ROOT%\*.* /r /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
echo +
if /I "%1"=="HB30" xcopy %HG_ROOT%\compile30.bat /r /y /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\compile32.bat /r /y /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\buildapp30.bat /r /y /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\buildapp32.bat /r /y /q
echo.
:DOC
echo DOC ...
set BASE_DISTRO_SUBDIR=doc
if not exist doc\nul goto ERROR5
cd doc
xcopy %HG_ROOT%\doc\*.* /r /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
echo.
:HB30
if /I not "%1"=="HB30" goto :HB32
echo HB30 ...
set BASE_DISTRO_SUBDIR=hb30
if not exist hb30\nul goto ERROR5
cd hb30
xcopy %HG_HRB%\*.* /r /s /e /c /q /y
cd ..
echo.
:HB32
if /I not "%1"=="HB32" goto :IDE
echo HB32 ...
set BASE_DISTRO_SUBDIR=hb32
if not exist hb32\nul goto ERROR5
cd hb32
xcopy %HG_HRB%\*.* /r /s /e /c /q /y
cd ..
echo.
:IDE
echo IDE ...
set BASE_DISTRO_SUBDIR=ide
if not exist ide\nul goto ERROR5
cd ide
xcopy %HG_ROOT%\ide\*.* /r /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
echo.
:INCLUDE
echo INCLUDE ...
set BASE_DISTRO_SUBDIR=include
if not exist include\nul goto ERROR5
cd include
xcopy %HG_ROOT%\include\*.* /r /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
echo.
:MANUAL
echo MANUAL ...
set BASE_DISTRO_SUBDIR=manual
if not exist manual\nul goto ERROR5
cd manual
xcopy %HG_ROOT%\manual\*.* /r /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
echo.
if /I not "%1"=="HB30" goto :RESOURCES
:RESOURCES
echo RESOURCES ...
set BASE_DISTRO_SUBDIR=resources
if not exist resources\nul goto ERROR5
cd resources
xcopy %HG_ROOT%\resources\*.* /r /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
echo.
:SAMPLES
echo SAMPLES folder ...
set BASE_DISTRO_SUBDIR=samples
if not exist samples\nul goto ERROR5
cd samples
xcopy %HG_ROOT%\samples\*.* /r /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
echo.
:SOURCE
echo SOURCE folder ...
set BASE_DISTRO_SUBDIR=source
if not exist source\nul goto ERROR5
cd source
xcopy %HG_ROOT%\source\*.* /r /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
echo +
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\build30.bat /r /y /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\build32.bat /r /y /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\makelib30.bat /r /y /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\makelib32.bat /r /y /q
cd ..
echo.

:BUILDLIBS
if /I "%1"=="HB30" goto LIBSHB30
if /I "%1"=="HB32" goto LIBSHB32
popd
goto END

:LIBSHB30
echo Building libs ...
echo.
cd source
set HG_ROOT=%BASE_DISTRO_DIR%
set HG_HRB=%BASE_DISTRO_DIR%\hb30
set HG_MINGW=%BASE_DISTRO_DIR%\hb30\comp\mingw
set LIB_GUI=lib
set BIN_HRB=bin
set TPATH=%PATH%
set PATH=%HG_MINGW%\bin;%HG_HRB%\%BIN_HRB%
hbmk2 oohg.hbp
hbmk2 miniprint.hbp
hbmk2 hbprinter.hbp
set PATH=%TPATH%
set TPATH=
attrib -s -h %BASE_DISTRO_DIR%\%LIB_GUI%\.hbmk /s /d
rd %BASE_DISTRO_DIR%\%LIB_GUI%\.hbmk /s /q
echo.
popd
goto END

:LIBSHB32
echo Building libs ...
echo.
cd source
set HG_ROOT=%BASE_DISTRO_DIR%
set HG_HRB=%BASE_DISTRO_DIR%\hb32
set HG_MINGW=%BASE_DISTRO_DIR%\hb32\comp\mingw
set LIB_GUI=lib\hb\mingw
set BIN_HRB=bin
set TPATH=%PATH%
set PATH=%HG_MINGW%\bin;%HG_HRB%\%BIN_HRB%
hbmk2 oohg.hbp
hbmk2 miniprint.hbp
hbmk2 hbprinter.hbp
set PATH=%TPATH%
set TPATH=
attrib -s -h %BASE_DISTRO_DIR%\%LIB_GUI%\.hbmk /s /d
rd %BASE_DISTRO_DIR%\%LIB_GUI%\.hbmk /s /q
echo.
popd
goto END

:END
echo End reached.
