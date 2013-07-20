@echo off
rem
rem $Id: makelib_mingw.bat,v 1.31 2013-07-20 01:32:51 fyurisich Exp $
rem
cls

Rem Set Paths

IF "%HG_MGW%"==""  SET HG_MGW=c:\oohg\mingw
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=c:\oohg\harbour

IF "%LIB_GUI%"=="" SET LIB_GUI=lib\hb\mingw
IF "%LIB_HRB%"=="" SET LIB_HRB=lib
rem IF "%LIB_HRB%"=="" SET LIB_HRB=lib\win\mingw
IF "%BIN_HRB%"=="" SET BIN_HRB=bin
rem IF "%BIN_HRB%"=="" SET BIN_HRB=bin\win\mingw

rem IF "%LIB_GUI%"=="" SET LIB_GUI=lib\hb\mingw64
rem IF "%LIB_HRB%"=="" SET LIB_HRB=lib\win\mingw64
rem IF "%BIN_HRB%"=="" SET BIN_HRB=bin\win\mingw64

IF NOT EXIST %hg_root%\%LIB_GUI%\liboohg.a MD %hg_root%\%LIB_GUI% >nul

IF EXIST %hg_root%\%LIB_GUI%\liboohg.a      del %hg_root%\%LIB_GUI%\liboohg.a
IF EXIST %hg_root%\%LIB_GUI%\libhbprinter.a del %hg_root%\%LIB_GUI%\libhbprinter.a
IF EXIST %hg_root%\%LIB_GUI%\libminiprint.a del %hg_root%\%LIB_GUI%\libminiprint.a

call common_make "%hg_hrb%\%LIB_HRB%\libtip.a"
if errorlevel 1 goto EXIT1

SET OOHG_X_FLAGS=-W -Wall -mno-cygwin -O3 -c -I%hg_hrb%\include -I%hg_mgw%\include -I%hg_root%\include -L%hg_hrb%\%LIB_HRB% -L%hg_mgw%\lib

SET _PATH2=%PATH%
SET PATH=%hg_mgw%\bin;%PATH%

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

%hg_mgw%\bin\ar rc %hg_root%\%LIB_GUI%\liboohg.a h_scrsaver.o h_edit.o h_edit_ex.o h_error.o h_ipaddress.o h_monthcal.o h_help.o h_status.o h_tree.o h_toolbar.o h_init.o h_media.o c_media.o c_resource.o h_cursor.o c_cursor.o h_ini.o h_report.o h_font.o c_font.o h_hyperlink.o c_scrsaver.o h_hotkey.o h_graph.o c_graph.o h_richeditbox.o h_browse.o h_scroll.o h_zip.o h_progressmeter.o h_comm.o h_print.o h_splitbox.o h_scrollbutton.o h_pdf.o h_tooltip.o
if errorlevel 2 goto EXIT2
%hg_mgw%\bin\ar rc %hg_root%\%LIB_GUI%\liboohg.a h_windows.o h_form.o c_windows.o h_crypt.o h_winapimisc.o h_slider.o c_controlmisc.o c_dialogs.o c_image.o c_msgbox.o c_progressbar.o c_winapimisc.o h_button.o h_checkbox.o h_combo.o h_controlmisc.o h_datepicker.o h_editbox.o h_dialogs.o h_grid.o h_image.o h_label.o h_listbox.o h_menu.o h_msgbox.o h_frame.o h_progressbar.o h_radio.o h_spinner.o h_tab.o h_textbox.o h_timer.o h_registry.o h_internal.o h_dll.o h_checklist.o
if errorlevel 2 goto EXIT2
%hg_mgw%\bin\ar rc %hg_root%\%LIB_GUI%\liboohg.a h_xbrowse.o h_activex.o c_activex.o h_textarray.o h_picture.o  h_hotkeybox.o
if errorlevel 2 goto EXIT2
if exist winprint.o  %hg_mgw%\bin\ar rc %hg_root%\%LIB_GUI%\libhbprinter.a winprint.o
if errorlevel 2 goto EXIT2
if exist miniprint.o %hg_mgw%\bin\ar rc %hg_root%\%LIB_GUI%\libminiprint.a miniprint.o
if errorlevel 2 goto EXIT2

IF EXIST %hg_root%\%LIB_GUI%\liboohg.a      copy %hg_root%\%LIB_GUI%\liboohg.a      %hg_root%\lib\liboohg.a
IF EXIST %hg_root%\%LIB_GUI%\libhbprinter.a copy %hg_root%\%LIB_GUI%\libhbprinter.a %hg_root%\lib\libhbprinter.a
IF EXIST %hg_root%\%LIB_GUI%\libminiprint.a copy %hg_root%\%LIB_GUI%\libminiprint.a %hg_root%\lib\libminiprint.a

:EXIT2
SET PATH=%_PATH2%
SET _PATH2=
del *.o

:EXIT1
del h_*.c
if exist winprint.c  del winprint.c
if exist miniprint.c del miniprint.c

SET OOHG_X_FLAGS=
SET HG_FILES1_PRG=
SET HG_FILES2_PRG=
SET HG_FILES_C=
