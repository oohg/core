@echo off
rem
rem $Id: MakeDistro.bat,v 1.8 2016-10-25 21:37:45 fyurisich Exp $
rem
cls

:PARAMS
if /I "%1"=="HB30" goto CONTINUE
if /I "%1"=="HB32" goto CONTINUE
if /I "%1"=="XB"   goto CONTINUE
echo.
echo Usage: MakeDistro HarbourVersion [ /C ]
echo where /C switch requests the erase of the
echo destination folder before making the distro
echo and HarbourVersion is one of the following
echo   HB30 - Harbour 3.0 and MinGW
echo   HB32 - Harbour 3.2 and MinGW
echo   XB   - xHarbour and BCC
echo.
goto END

:ERROR1
echo.
echo Can't create folder %BASE_DISTRO_DIR%
echo.
goto END

:ERROR2
echo.
echo %HG_ROOT%\distros\MakeExclude.txt is missing
echo.
goto END

:ERROR3
echo.
echo Can't create subfolder %BASE_DISTRO_SUBDIR%
echo.
popd
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
popd
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
rem Change these sets to use different sources for OOHG, Harbour and MinGW
if "%HG_ROOT%" == "" set HG_ROOT=C:\OOHG

if not exist %HG_ROOT%\distros\MakeExclude.txt goto ERROR2
if /I "%1"=="HB30" if "%HG_HRB%" == ""   set HG_HRB=C:\HB30
if /I "%1"=="HB30" if "%HG_MINGW%" == "" set HG_MINGW=C:\HB30\COMP\MINGW
if /I "%1"=="HB32" if "%HG_HRB%" == ""   set HG_HRB=C:\HB32
if /I "%1"=="HB32" if "%HG_MINGW%" == "" set HG_MINGW=C:\HB32\COMP\MINGW
if /I "%1"=="XB"   if "%HG_HRB%" == ""   set HG_HRB=C:\XHBCC
if /I "%1"=="XB"   if "%HG_BCC%" == ""   set HG_BCC=C:\BORLAND\BCC55

:DISTRO_FOLDER
if not "%BASE_DISTRO_DIR%"=="" goto PREPARE
if /I "%1"=="HB30" set BASE_DISTRO_DIR=C:\OOHG_HB30
if /I "%1"=="HB32" set BASE_DISTRO_DIR=C:\OOHG_HB32
if /I "%1"=="XB"   set BASE_DISTRO_DIR=C:\OOHG_XB

:PREPARE
echo Preparing folder %BASE_DISTRO_DIR%...
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
if /I "%2"=="/C" del /f /s /q %BASE_DISTRO_DIR%\*.* > nul
if /I "%2"=="/C" attrib -s -h %BASE_DISTRO_DIR%\*.* /s /d > nul
if /I "%2"=="/C" del /f /s /q %BASE_DISTRO_DIR%\*.* > nul
if /I "%2"=="/C" rd /s /q %BASE_DISTRO_DIR% > nul
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
if /I "%1"=="XB"   set BASE_DISTRO_SUBDIR=xhbcc
if /I "%1"=="XB"   if not exist xhbcc\nul md xhbcc
if /I "%1"=="XB"   if not exist xhbcc\nul goto ERROR3
set BASE_DISTRO_SUBDIR=ide
if not exist ide\nul md ide
if not exist ide\nul goto ERROR3
set BASE_DISTRO_SUBDIR=include
if not exist include\nul md include
if not exist include\nul goto ERROR3
if /I "%1"=="HB30" set BASE_DISTRO_SUBDIR=lib
if /I "%1"=="HB32" set BASE_DISTRO_SUBDIR=lib\hb\mingw
if /I "%1"=="XB"   set BASE_DISTRO_SUBDIR=lib\xhb\bcc
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
echo Copying %HG_ROOT%...
xcopy %HG_ROOT%\*.* /r /c /q /y /d /exclude:%HG_ROOT%\distros\MakeExclude.txt
xcopy %HG_ROOT%\compile.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\compile30.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\compile32.bat /r /y /d /q
if /I "%1"=="XB"   xcopy %HG_ROOT%\compileXB.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\compile_mingw.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\compile_mingw.bat /r /y /d /q
if /I "%1"=="XB"   xcopy %HG_ROOT%\compile_bcc.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\buildapp30.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\buildapp32.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\buildapp.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\buildapp.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\buildapp_hbmk2.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\buildapp_hbmk2.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\oohg.hbc /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\oohg.hbc /r /y /d /q
echo.
:DOC
echo Copying DOC...
set BASE_DISTRO_SUBDIR=doc
if not exist doc\nul goto ERROR5
cd doc
xcopy %HG_ROOT%\doc\*.* /r /s /e /c /q /y /d /exclude:%HG_ROOT%\distros\MakeExclude.txt
cd ..
echo.
:HB30
if /I not "%1"=="HB30" goto :HB32
echo Copying HB30...
set BASE_DISTRO_SUBDIR=hb30
if not exist hb30\nul goto ERROR5
cd hb30
xcopy %HG_HRB%\*.* /r /s /e /c /q /y /d
cd ..
echo.
:HB32
if /I not "%1"=="HB32" goto :XB
echo Copying HB32...
set BASE_DISTRO_SUBDIR=hb32
if not exist hb32\nul goto ERROR5
cd hb32
xcopy %HG_HRB%\*.* /r /s /e /c /q /y /d
cd ..
echo.
:XB
if /I not "%1"=="XB" goto :IDE
echo Copying xHarbour...
set BASE_DISTRO_SUBDIR=xhbcc
if not exist xhbcc\nul goto ERROR5
cd xhbcc
xcopy %HG_HRB%\*.* /r /s /e /c /q /y /d
cd ..
echo.
:IDE
echo Copying IDE...
set BASE_DISTRO_SUBDIR=ide
if not exist ide\nul goto ERROR5
cd ide
xcopy %HG_ROOT%\ide\*.* /r /s /e /c /q /y /d /exclude:%HG_ROOT%\distros\MakeExclude.txt
if /I "%1"=="HB30" xcopy %HG_ROOT%\ide\build.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\ide\mgide.hbp /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\ide\build.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\ide\mgide.hbp /r /y /d /q
if /I "%1"=="XB"   xcopy %HG_ROOT%\ide\compile.bat /r /y /d /q
cd ..
echo.
:INCLUDE
echo Copying INCLUDE...
set BASE_DISTRO_SUBDIR=include
if not exist include\nul goto ERROR5
cd include
xcopy %HG_ROOT%\include\*.* /r /s /e /c /q /y /d /exclude:%HG_ROOT%\distros\MakeExclude.txt
cd ..
echo.
:MANUAL
echo Copying MANUAL...
set BASE_DISTRO_SUBDIR=manual
if not exist manual\nul goto ERROR5
cd manual
xcopy %HG_ROOT%\manual\*.* /r /s /e /c /q /y /d /exclude:%HG_ROOT%\distros\MakeExclude.txt
cd ..
echo.
if /I not "%1"=="HB30" goto :RESOURCES
:RESOURCES
echo Copying RESOURCES...
set BASE_DISTRO_SUBDIR=resources
if not exist resources\nul goto ERROR5
cd resources
xcopy %HG_ROOT%\resources\*.* /r /s /e /c /q /y /d /exclude:%HG_ROOT%\distros\MakeExclude.txt
if /I "%1"=="HB30" xcopy %HG_ROOT%\resources\compileres_mingw.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\resources\compileres_mingw.bat /r /y /d /q
if /I "%1"=="XB"   xcopy %HG_ROOT%\resources\compileres_bcc.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\resources\oohg.rc /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\resources\oohg.rc /r /y /d /q
if /I "%1"=="XB"   xcopy %HG_ROOT%\resources\oohg_bcc.rc /r /y /d /q
cd ..
echo.
:SAMPLES
echo Copying SAMPLES...
set BASE_DISTRO_SUBDIR=samples
if not exist samples\nul goto ERROR5
cd samples
xcopy %HG_ROOT%\samples\*.* /r /s /e /c /q /y /d /exclude:%HG_ROOT%\distros\MakeExclude.txt
cd ..
echo.
:SOURCE
echo Copying SOURCE...
set BASE_DISTRO_SUBDIR=source
if not exist source\nul goto ERROR5
cd source
xcopy %HG_ROOT%\source\*.* /r /s /e /c /q /y /d /exclude:%HG_ROOT%\distros\MakeExclude.txt
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\buildlib30.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\buildlib32.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\buildlib.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\buildlib.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\buildlib_hbmk2.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\buildlib_hbmk2.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\oohg.hbp /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\oohg.hbp /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\bostaurus.hbp /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\bostaurus.hbp /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\miniprint.hbp /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\miniprint.hbp /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\hbprinter.hbp /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\hbprinter.hbp /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\makelib30.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\makelib32.bat /r /y /d /q
if /I "%1"=="HB30" xcopy %HG_ROOT%\source\makelib_mingw.bat /r /y /d /q
if /I "%1"=="HB32" xcopy %HG_ROOT%\source\makelib_mingw.bat /r /y /d /q
if /I "%1"=="XB"   xcopy %HG_ROOT%\source\makelibXB.bat /r /y /d /q
if /I "%1"=="XB"   xcopy %HG_ROOT%\source\makelib_bcc.bat /r /y /d /q
cd ..
echo.

:RES_FILE
echo Compiling resource file...
cd resources
if /I "%1"=="HB30" call compileres_mingw.bat /NOCLS
if /I "%1"=="HB32" call compileres_mingw.bat /NOCLS
if /I "%1"=="XB"   call compileres_bcc.bat /NOCLS
cd ..

:BUILDLIBS
if /I "%1"=="HB30" goto LIBSHB30
if /I "%1"=="HB32" goto LIBSHB32
if /I "%1"=="XB"   goto LIBSXB
popd
goto END

:LIBSHB30
echo Building libs...
cd source
set HG_ROOT=%BASE_DISTRO_DIR%
set HG_HRB=%BASE_DISTRO_DIR%\hb30
set HG_MINGW=%BASE_DISTRO_DIR%\hb30\comp\mingw
set LIB_GUI=lib
set BIN_HRB=bin
set TPATH=%PATH%
set PATH=%HG_MINGW%\bin;%HG_HRB%\%BIN_HRB%
hbmk2 oohg.hbp
hbmk2 bostaurus.hbp
hbmk2 miniprint.hbp
hbmk2 hbprinter.hbp
set PATH=%TPATH%
set TPATH=
attrib -s -h %BASE_DISTRO_DIR%\%LIB_GUI%\.hbmk /s /d
rd %BASE_DISTRO_DIR%\%LIB_GUI%\.hbmk /s /q
echo.
cd ..
goto OIDE_HBMK2

:LIBSHB32
echo Building libs...
cd source
set HG_ROOT=%BASE_DISTRO_DIR%
set HG_HRB=%BASE_DISTRO_DIR%\hb32
set HG_MINGW=%BASE_DISTRO_DIR%\hb32\comp\mingw
set LIB_GUI=lib\hb\mingw
set BIN_HRB=bin
set TPATH=%PATH%
set PATH=%HG_MINGW%\bin;%HG_HRB%\%BIN_HRB%
hbmk2 oohg.hbp
hbmk2 bostaurus.hbp
hbmk2 miniprint.hbp
hbmk2 hbprinter.hbp
set PATH=%TPATH%
set TPATH=
attrib -s -h %BASE_DISTRO_DIR%\%LIB_GUI%\.hbmk /s /d
rd %BASE_DISTRO_DIR%\%LIB_GUI%\.hbmk /s /q
echo.
cd ..
goto OIDE_HBMK2

:LIBSXB
echo Building libs...
cd source
set HG_ROOT=%BASE_DISTRO_DIR%
set HG_HRB=%BASE_DISTRO_DIR%\xhbcc
set LIB_GUI=lib\xhb\bcc
set LIB_HRB=lib
set BIN_HRB=bin
echo Harbour: Compiling sources...
set HG_FILES1_PRG=h_error h_windows h_form h_ipaddress h_monthcal h_help h_status h_tree h_toolbar h_init h_media h_winapimisc h_slider h_button h_checkbox h_combo h_controlmisc h_datepicker h_editbox h_dialogs h_grid h_image h_label h_listbox h_menu h_msgbox h_frame h_progressbar h_radio h_spinner h_tab h_textbox h_application
set HG_FILES2_PRG=h_graph h_richeditbox h_edit h_edit_ex h_scrsaver h_browse h_crypt h_zip h_comm h_print h_scroll h_splitbox h_progressmeter h_scrollbutton h_xbrowse h_internal h_textarray h_hotkeybox h_activex h_pdf h_hotkey h_hyperlink h_tooltip h_picture h_dll h_checklist h_timer h_cursor h_ini h_report h_registry h_font h_anigif
set OOHG_X_FLAGS=-i"%HG_HRB%\include;%HG_ROOT%\include" -n1 -gc0 -q0
%HG_HRB%\%BIN_HRB%\harbour %HG_FILES1_PRG% %HG_FILES2_PRG% miniprint winprint bostaurus %OOHG_X_FLAGS%
echo BCC32: Compiling...
set OOHG_X_FLAGS=-c -O2 -tW -tWM -d -a8 -OS -5 -6 -w -I%HG_HRB%\include;%HG_BCC%\include;%HG_ROOT%\include; -L%HG_HRB%\%LIB_HRB%;%HG_BCC%\lib; -D__XHARBOUR__
set HG_FILES_C=c_media c_controlmisc c_resource c_cursor c_font c_dialogs c_windows c_image c_msgbox c_progressbar c_winapimisc c_scrsaver c_graph c_activex c_gdiplus
for %%a in ( %HG_FILES1_PRG% %HG_FILES2_PRG% %HG_FILES_C% miniprint winprint bostaurus ) do %HG_BCC%\bin\bcc32 %OOHG_X_FLAGS% %%a.c > nul
echo TLIB: Building library %HG_ROOT%\%LIB_GUI%\oohg.lib...
for %%a in ( %HG_FILES1_PRG% %HG_FILES2_PRG% %HG_FILES_C% ) do %HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\oohg +%%a.obj /P32 > nul
echo TLIB: Building library %HG_ROOT%\%LIB_GUI%\hbprinter.lib...
%HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\hbprinter +winprint.obj > nul
echo TLIB: Building library %HG_ROOT%\%LIB_GUI%\miniprint.lib...
%HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\miniprint +miniprint.obj > nul
echo TLIB: Building library %HG_ROOT%\%LIB_GUI%\bostaurus.lib...
%HG_BCC%\bin\tlib %HG_ROOT%\%LIB_GUI%\bostaurus +bostaurus.obj > nul
del %HG_ROOT%\%LIB_GUI%\oohg.bak /q > nul
del *.obj /q
del h_*.c /q
del winprint.c /q
del miniprint.c /q
del bostaurus.c /q
set OOHG_X_FLAGS=
set HG_FILES_C=
set HG_FILES2_PRG=
set HG_FILES1_PRG=
echo.
cd ..
goto OIDE_XBCC

:OIDE_HBMK2
echo Building oIDE...
cd ide
set TPATH=%PATH%
set PATH=%HG_MINGW%\bin;%HG_HRB%\%BIN_HRB%
echo #define oohgpath %HG_ROOT%\RESOURCES > _oohg_resconfig.h
copy /b mgide.rc + %HG_ROOT%\resources\oohg.rc _temp.rc > nul
windres -i _temp.rc -o _temp.o
hbmk2 mgide.hbp %HG_ROOT%\oohg.hbc
del _oohg_resconfig.h /q
del _temp.* /q
set PATH=%TPATH%
set TPATH=
attrib -s -h .hbmk /s /d
rd .hbmk /s /q
echo.
cd ..
goto END

:OIDE_XBCC
echo Building oIDE...
cd ide
call compile.bat /nocls
echo.
cd ..
goto END

:END
echo End reached.
