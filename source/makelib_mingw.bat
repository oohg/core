@echo off
rem
rem $Id: makelib_mingw.bat,v 1.42 2016-10-25 21:38:01 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%HG_ROOT%"==""  set HG_ROOT=c:\oohg
if "%HG_HRB%"==""   set HG_HRB=c:\oohg\hb32
if "%HG_MINGW%"=="" set HG_MINGW=c:\oohg\hb32\comp\mingw

rem *** To Build with Nightly Harbour ***
rem set HG_HRB=c:\hb32
rem *** For 32 bits MinGW ***
rem set HG_MINGW=c:\hb32\comp\mingw
rem *** For 64 bits MinGW ***
rem set HG_MINGW=c:\hb32\comp\mingw64

rem *** Set EnvVars ***
if "%LIB_GUI%"==""  set LIB_GUI=lib\hb\mingw
if "%LIB_HRB%"=="" set LIB_HRB=lib\win\mingw
if "%BIN_HRB%"=="" set BIN_HRB=bin

rem *** To Build with Nightly Harbour ***
rem *** For 32 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw
rem set LIB_HRB=lib\win\mingw
rem set BIN_HRB=bin or bin\win\mingw
rem *** For 64 bits MinGW ***
rem set LIB_GUI=lib\hb\mingw64
rem set LIB_HRB=lib\win\mingw64
rem set BIN_HRB=bin or bin\win\mingw64

rem *** Create Lib Folder ***
if not exist %HG_ROOT%\%LIB_GUI%\nul md %HG_ROOT%\%LIB_GUI% >nul

rem *** Delete Old Libraries ***
if exist %HG_ROOT%\%LIB_GUI%\liboohg.a      del %HG_ROOT%\%LIB_GUI%\liboohg.a
if exist %HG_ROOT%\%LIB_GUI%\libhbprinter.a del %HG_ROOT%\%LIB_GUI%\libhbprinter.a
if exist %HG_ROOT%\%LIB_GUI%\libminiprint.a del %HG_ROOT%\%LIB_GUI%\libminiprint.a
if exist %HG_ROOT%\%LIB_GUI%\libbostaurus.a del %HG_ROOT%\%LIB_GUI%\libbostaurus.a

rem *** Compile with Harbour ***
call common_make "%HG_HRB%\%LIB_HRB%\libtip.a"
if errorlevel 1 goto EXIT1

rem *** Set PATH ***
rem *** If PATH is empty "SET TPATH=%PATH%" sets ERRORLEVEL TO 1 ***
set TPATH=%PATH%
set PATH=%HG_MINGW%\bin

rem *** Compile with GCC ***
echo Compiling C sources ...
set OOHG_X_FLAGS=-W -Wall -O3 -c -I%HG_HRB%\include -I%HG_MINGW%\include -I%HG_ROOT%\include -L%HG_HRB%\%LIB_HRB% -L%HG_MINGW%\lib
for %%a in (%HG_FILES1_PRG%) do if not errorlevel 1 gcc %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES2_PRG%) do if not errorlevel 1 gcc %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
for %%a in (%HG_FILES_C%)    do if not errorlevel 1 gcc %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
if exist winprint.c  gcc %OOHG_X_FLAGS% winprint.c
if errorlevel 1 goto EXIT2
if exist miniprint.c gcc %OOHG_X_FLAGS% miniprint.c
if errorlevel 1 goto EXIT2
if exist bostaurus.c gcc %OOHG_X_FLAGS% bostaurus.c
if errorlevel 1 goto EXIT2

rem *** Build Libraries ***
echo Building libraries ...
%HG_MINGW%\bin\ar rc %HG_ROOT%\%LIB_GUI%\liboohg.a h_scrsaver.o h_edit.o h_edit_ex.o h_error.o h_ipaddress.o h_monthcal.o h_help.o h_status.o h_tree.o h_toolbar.o h_init.o h_media.o c_media.o c_resource.o h_cursor.o c_cursor.o h_ini.o h_report.o h_font.o c_font.o h_hyperlink.o c_scrsaver.o h_hotkey.o h_graph.o c_graph.o h_richeditbox.o h_browse.o h_scroll.o h_zip.o h_progressmeter.o h_comm.o h_print.o h_splitbox.o h_scrollbutton.o h_pdf.o h_tooltip.o h_application.o
if errorlevel 2 goto EXIT3
%HG_MINGW%\bin\ar rc %HG_ROOT%\%LIB_GUI%\liboohg.a h_windows.o h_form.o c_windows.o h_crypt.o h_winapimisc.o h_slider.o c_controlmisc.o c_dialogs.o c_image.o c_msgbox.o c_progressbar.o c_winapimisc.o h_button.o h_checkbox.o h_combo.o h_controlmisc.o h_datepicker.o h_editbox.o h_dialogs.o h_grid.o h_image.o h_label.o h_listbox.o h_menu.o h_msgbox.o h_frame.o h_progressbar.o h_radio.o h_spinner.o h_tab.o h_textbox.o h_timer.o h_registry.o h_internal.o h_dll.o h_checklist.o
if errorlevel 2 goto EXIT3
%HG_MINGW%\bin\ar rc %HG_ROOT%\%LIB_GUI%\liboohg.a h_xbrowse.o h_activex.o c_activex.o h_textarray.o h_picture.o h_hotkeybox.o c_gdiplus.o h_anigif.o
if errorlevel 2 goto EXIT3
if exist winprint.o  %HG_MINGW%\bin\ar rc %HG_ROOT%\%LIB_GUI%\libhbprinter.a winprint.o
if errorlevel 2 goto EXIT3
if exist miniprint.o %HG_MINGW%\bin\ar rc %HG_ROOT%\%LIB_GUI%\libminiprint.a miniprint.o
if errorlevel 2 goto EXIT3
if exist bostaurus.o %HG_MINGW%\bin\ar rc %HG_ROOT%\%LIB_GUI%\libbostaurus.a bostaurus.o
if errorlevel 2 goto EXIT3

:SUCCESS
echo BUILD FINISHED !!!
echo Look for new libs at %HG_ROOT%\%LIB_GUI%

rem *** This are compatibility commands for current CVS version ***
if /I .%LIB_GUI%.==.LIB. goto EXIT2
if exist %HG_ROOT%\%LIB_GUI%\liboohg.a      copy %HG_ROOT%\%LIB_GUI%\liboohg.a      %HG_ROOT%\lib\liboohg.a
if exist %HG_ROOT%\%LIB_GUI%\libhbprinter.a copy %HG_ROOT%\%LIB_GUI%\libhbprinter.a %HG_ROOT%\lib\libhbprinter.a
if exist %HG_ROOT%\%LIB_GUI%\libminiprint.a copy %HG_ROOT%\%LIB_GUI%\libminiprint.a %HG_ROOT%\lib\libminiprint.a
if exist %HG_ROOT%\%LIB_GUI%\libbostaurus.a copy %HG_ROOT%\%LIB_GUI%\libbostaurus.a %HG_ROOT%\lib\libbostaurus.a

:EXIT2
set PATH=%TPATH%
set TPATH=
for %%a in (*.o) do del %%a

:EXIT1
for %%a in (h_*.c) do del %%a
if exist winprint.c  del winprint.c
if exist miniprint.c del miniprint.c
if exist bostaurus.c del bostaurus.c

set OOHG_X_FLAGS=
set HG_FILES1_PRG=
set HG_FILES2_PRG=
set HG_FILES_C=
