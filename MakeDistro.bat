@echo off
rem
rem $Id: MakeDistro.bat,v 1.3 2015-03-12 00:58:16 fyurisich Exp $
rem
cls

:PARAMS
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

:CONTINUE
rem Change this sets to use different sources for OOHG, Harbour and MinGW
set HG_ROOT=C:\OOHG
if not exist %HG_ROOT%\MakeExclude.txt goto ERROR2
if /I "%1"=="HB30" set HG_HRB=C:\HB30
if /I "%1"=="HB30" set HG_MINGW=C:\HB30\COMP\MINGW
if /I "%1"=="HB32" set HG_HRB=C:\HB32
if /I "%1"=="HB32" set HG_MINGW=C:\HB32\COMP\MINGW
set BASE_DISTRO_DIR=C:\OOHG_DISTRO
echo Preparing folder %BASE_DISTRO_DIR% ...
if not exist %BASE_DISTRO_DIR%\nul goto CREATE
if /I "%2"=="/C" attrib -s -h %BASE_DISTRO_DIR% /s /d
if /I "%2"=="/C" del %BASE_DISTRO_DIR%\*.* /s /f /q >nul
if /I "%2"=="/C" rd %BASE_DISTRO_DIR% /s /q
if /I "%2"=="/C" if exist %BASE_DISTRO_DIR%\nul goto ERROR4

:CREATE
md %BASE_DISTRO_DIR%
if not exist %BASE_DISTRO_DIR%\nul goto ERROR1

:FOLDERS
pushd %BASE_DISTRO_DIR%
set BASE_DISTRO_SUBDIR=doc
md doc
if not exist doc\nul goto ERROR3
if /I "%1"=="HB30" set BASE_DISTRO_SUBDIR=harbour
if /I "%1"=="HB30" md harbour
if /I "%1"=="HB30" if not exist harbour\nul goto ERROR3
if /I "%1"=="HB32" set BASE_DISTRO_SUBDIR=hb32
if /I "%1"=="HB32" md hb32
if /I "%1"=="HB32" if not exist hb32\nul goto ERROR3
set BASE_DISTRO_SUBDIR=ide
md ide
if not exist ide\nul goto ERROR3
set BASE_DISTRO_SUBDIR=include
md include
if not exist include\nul goto ERROR3
set BASE_DISTRO_SUBDIR=lib
md lib
if not exist lib\nul goto ERROR3
set BASE_DISTRO_SUBDIR=manual
md manual
if not exist manual\nul goto ERROR3
set BASE_DISTRO_SUBDIR=resources
md resources
if not exist resources\nul goto ERROR3
set BASE_DISTRO_SUBDIR=samples
md samples
if not exist samples\nul goto ERROR3
set BASE_DISTRO_SUBDIR=source
md source
if not exist source\nul goto ERROR3
echo.

:FILES
echo Copying files ...
:ROOT
echo Copying %HG_ROOT% ...
xcopy %HG_ROOT%\*.* /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
if /I not "%1"=="HB30" del compile.bat
if /I not "%1"=="HB32" del compile32.bat
:DOC
echo Copying DOC ...
set BASE_DISTRO_SUBDIR=doc
if not exist doc\nul goto ERROR5
cd doc
xcopy %HG_ROOT%\doc\*.* /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
:HB30
if /I not "%1"=="HB30" goto :HB32
echo Copying HB30 ...
set BASE_DISTRO_SUBDIR=harbour
if not exist harbour\nul goto ERROR5
cd harbour
xcopy %HG_HRB%\*.* /s /e /c /q /y
cd ..
:HB32
if /I not "%1"=="HB32" goto :IDE
echo Copying HB32 ...
set BASE_DISTRO_SUBDIR=hb32
if not exist hb32\nul goto ERROR5
cd hb32
xcopy %HG_HRB%\*.* /s /e /c /q /y
cd ..
:IDE
echo Copying IDE ...
set BASE_DISTRO_SUBDIR=ide
if not exist ide\nul goto ERROR5
cd ide
xcopy %HG_ROOT%\ide\*.* /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
:INCLUDE
echo Copying INCLUDE ...
set BASE_DISTRO_SUBDIR=include
if not exist include\nul goto ERROR5
cd include
xcopy %HG_ROOT%\include\*.* /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
:LIB
echo Copying LIB ...
set BASE_DISTRO_SUBDIR=lib
if not exist lib\nul goto ERROR5
cd lib
if /I "%1"=="HB32" md hb
if /I "%1"=="HB32" md hb\mingw
cd ..
:MANUAL
echo Copying MANUAL ...
set BASE_DISTRO_SUBDIR=manual
if not exist manual\nul goto ERROR5
cd manual
xcopy %HG_ROOT%\manual\*.* /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
if /I not "%1"=="HB30" goto :RESOURCES
:RESOURCES
echo Copying RESOURCES ...
set BASE_DISTRO_SUBDIR=resources
if not exist resources\nul goto ERROR5
cd resources
xcopy %HG_ROOT%\resources\*.* /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
:SAMPLES
echo Copying SAMPLES folder ...
set BASE_DISTRO_SUBDIR=samples
if not exist samples\nul goto ERROR5
cd samples
xcopy %HG_ROOT%\samples\*.* /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
cd ..
:SOURCE
echo Copying SOURCE folder ...
set BASE_DISTRO_SUBDIR=source
if not exist source\nul goto ERROR5
cd source
xcopy %HG_ROOT%\source\*.* /s /e /c /q /y /exclude:%HG_ROOT%\MakeExclude.txt
if /I not "%1"=="HB30" del build30.bat
if /I not "%1"=="HB32" del build32.bat
cd ..
echo.

:BUILDLIBS
if /I "%1"=="HB30" goto LIBSHB30
if /I "%1"=="HB32" goto LIBSHB32
popd
goto END

:LIBSHB30
echo Building libs ...
cd source
set HG_ROOT=%BASE_DISTRO_DIR%
set HG_HRB=%BASE_DISTRO_DIR%\harbour
set HG_MINGW=%BASE_DISTRO_DIR%\harbour\comp\mingw
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
set BASE_DISTRO_SUBDIR=
set BASE_DISTRO_DIR=
set HG_ROOT=
set HG_HRB=
set HG_MINGW=
set LIB_GUI=
set BIN_HRB=
echo End reached.
