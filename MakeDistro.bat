@echo off
rem
rem $Id: MakeDistro.bat,v 1.1 2015-03-09 22:29:20 fyurisich Exp $
rem
cls

if /I "%1" == "HB30" goto CONTINUE
if /I "%1" == "HB32" goto CONTINUE
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

:CONTINUE
set BASE_DISTRO_DIR=C:\OOHG_DISTRO
if not exist %BASE_DISTRO_DIR%\nul goto CREATE
if /I "%2" == "/C" rd %BASE_DISTRO_DIR% /s /q
pause

:CREATE
md %BASE_DISTRO_DIR%
if not exist %BASE_DISTRO_DIR%\nul goto ERROR1

:FOLDERS
pushd %BASE_DISTRO_DIR%
md doc
if /I "%1" == "HB30" md harbour
if /I "%1" == "HB32" md hb32
md ide
md include
md lib
md manual
if /I "%1" == "HB30" md MinGW
md resources
md samples
md source

:FILES
echo Copy start.
:ROOT
xcopy c:\oohg\*.* /c /q /y /exclude:C:\OOHG\MakeExclude.txt
if /I NOT "%1" == "HB30" del compile32.bat
if /I NOT "%1" == "HB32" del compile.bat
:DOC
echo Copying DOC ...
cd doc
xcopy c:\oohg\doc\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
:HB30
if /I NOT "%1" == "HB30" goto :HB32
echo Copying HB30 ...
cd harbour
xcopy c:\oohg\harbour\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
:HB32
if /I NOT "%1" == "HB32" goto :IDE
echo Copying HB32 ...
cd hb32
xcopy c:\oohg\hb32\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
:IDE
echo Copying IDE ...
cd ide
xcopy c:\oohg\ide\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
:INCLUDE
echo Copying INCLUDE ...
cd include
xcopy c:\oohg\include\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
:LIB
echo Copying LIB ...
cd lib
xcopy c:\oohg\lib\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
echo Copying MANUAL ...
cd manual
xcopy c:\oohg\manual\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
if /I NOT "%1" == "HB30" goto :RESOURCES
echo Copying MINGW ...
cd MinGW
xcopy c:\oohg\MinGW\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
:RESOURCES
echo Copying RESOURCES ...
cd resources
xcopy c:\oohg\resources\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
echo Copying SAMPLES folder ...
cd samples
xcopy c:\oohg\samples\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
cd ..
echo Copying SOURCE folder ...
cd source
xcopy c:\oohg\source\*.* /s /e /c /q /y /exclude:C:\OOHG\MakeExclude.txt
popd
echo Copy end.

if /I "%1" == "HB30" goto LIBSHB30
if /I "%1" == "HB32" goto LIBSHB32
goto END

:LIBSHB30
set HG_ROOT=%BASE_DISTRO_DIR%
set HG_HRB=%BASE_DISTRO_DIR%\harbour
set HG_MINGW=%BASE_DISTRO_DIR%\mingw
set LIB_GUI=lib
set BIN_HRB=bin
pushd source
call BuildLib.bat f
goto END

:LIBSHB32
set HG_ROOT=%BASE_DISTRO_DIR%
set HG_HRB=%BASE_DISTRO_DIR%\hb32
set HG_MINGW=%BASE_DISTRO_DIR%\hb32\comp\mingw
set LIB_GUI=lib\hb\mingw
set BIN_HRB=bin\win\mingw
pushd source
call BuildLib.bat f
goto END

:END
set BASE_DISTRO_DIR=
