@echo off
rem
rem $Id: makelib_mingw.bat,v 1.2 2007-01-01 22:30:14 guerra000 Exp $
rem
cls

Rem Set Paths 

IF "%HG_MGW%"==""  SET HG_MGW=c:\mingw
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=c:\harbour

IF NOT EXIST %hg_root%\lib\liboohg.a MD %hg_root%\lib >nul

IF EXIST %hg_root%\lib\liboohg.a      del %hg_root%\lib\liboohg.a
IF EXIST %hg_root%\lib\libhbprinter.a del %hg_root%\lib\libhbprinter.a
IF EXIST %hg_root%\lib\libminiprint.a del %hg_root%\lib\libminiprint.a

call common_make "%hg_hrb%\lib\libtip.a"
if errorlevel 1 goto EXIT1

SET OOHG_X_FLAGS=-Wall -mno-cygwin -O3 -c -I%hg_hrb%\include -I%hg_mgw%\include -L%hg_hrb%\lib -L%hg_mgw%\lib

SET _PATH2=%PATH%
SET PATH=%PATH%;%hg_mgw%\bin

%hg_mgw%\bin\gcc %OOHG_X_FLAGS% h_scrsaver.c h_edit.c h_edit_ex.c h_error.c h_ipaddress.c c_ipaddress.c h_monthcal.c c_monthcal.c h_help.c c_help.c h_crypt.c c_crypt.c h_status.c h_tree.c c_tree.c c_toolbar.c h_toolbar.c h_init.c h_media.c c_media.c h_winapimisc.c h_slider.c c_combo.c c_controlmisc.c c_datepicker.c c_resource.c h_cursor.c c_cursor.c c_ini.c h_ini.c h_report.c h_registry.c h_font.c c_font.c h_hyperlink.c h_richeditbox.c h_scroll.c h_http.c h_zip.c h_progressmeter.c h_comm.c h_print.c
if errorlevel 1 goto EXIT2
%hg_mgw%\bin\gcc %OOHG_X_FLAGS% c_dialogs.c c_grid.c c_windows.c c_image.c c_listbox.c c_msgbox.c c_frame.c c_progressbar.c c_spinner.c c_textbox.c c_timer.c c_winapimisc.c h_button.c h_checkbox.c h_combo.c h_controlmisc.c h_datepicker.c h_editbox.c h_dialogs.c h_grid.c h_windows.c h_image.c h_label.c h_listbox.c h_menu.c h_msgbox.c h_frame.c h_progressbar.c h_radio.c h_spinner.c h_tab.c h_textbox.c h_timer.c c_scrsaver.c h_hotkey.c h_graph.c c_graph.c h_browse.c h_splitbox.c h_scrollbutton.c h_xbrowse.c h_internal.c h_textarray.c h_hotkeybox.c
if errorlevel 1 goto EXIT2
if exist winprint.c  %OOHG_X_FLAGS% winprint.c
if errorlevel 1 goto EXIT2
if exist miniprint.c %OOHG_X_FLAGS% miniprint.c
if errorlevel 1 goto EXIT2

%hg_mgw%\bin\ar rc %hg_root%\lib\liboohg.a h_scrsaver.o h_edit.o h_edit_ex.o h_error.o h_ipaddress.o c_ipaddress.o h_monthcal.o c_monthcal.o h_help.o c_help.o h_status.o h_tree.o c_tree.o h_toolbar.o c_toolbar.o h_init.o h_media.o c_media.o c_resource.o h_cursor.o c_cursor.o h_ini.o c_ini.o h_report.o h_font.o c_font.o h_hyperlink.o c_scrsaver.o h_hotkey.o h_graph.o c_graph.o h_richeditbox.o h_browse.o h_scroll.o h_http.o h_zip.o h_progressmeter.o h_comm.o h_print.o h_splitbox.o h_scrollbutton.o h_xbrowse.o
if errorlevel 2 goto EXIT2
%hg_mgw%\bin\ar rc %hg_root%\lib\liboohg.a c_crypt.o h_crypt.o h_winapimisc.o h_slider.o c_combo.o c_controlmisc.o c_datepicker.o c_dialogs.o c_grid.o c_windows.o c_image.o c_listbox.o c_msgbox.o c_frame.o c_progressbar.o c_spinner.o c_textbox.o c_timer.o c_winapimisc.o h_button.o h_checkbox.o h_combo.o h_controlmisc.o h_datepicker.o h_editbox.o h_dialogs.o h_grid.o h_windows.o h_image.o h_label.o h_listbox.o h_menu.o h_msgbox.o h_frame.o h_progressbar.o h_radio.o h_spinner.o h_tab.o h_textbox.o h_timer.o h_registry.o h_internal.o h_textarray.o h_hotkeybox.o
if errorlevel 2 goto EXIT2
if exist winprint.o  %hg_mgw%\bin\ar rc %hg_root%\lib\libhbprinter.a winprint.o
if errorlevel 2 goto EXIT2
if exist miniprint.o %hg_mgw%\bin\ar rc %hg_root%\lib\libminiprint.a miniprint.o
if errorlevel 2 goto EXIT2

:EXIT2
SET PATH=%_PATH2%
SET _PATH2=
del *.o

:EXIT1
del h_*.c
if exist winprint.c  del winprint.c
if exist miniprint.c del miniprint.c

SET OOHG_X_FLAGS=
SET HG_FILES_PRG=
SET HG_FILES_C=
