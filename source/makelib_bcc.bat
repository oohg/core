@echo off
rem
rem $Id: makelib_bcc.bat,v 1.10 2008-01-14 02:12:54 guerra000 Exp $
rem
cls

Rem Set Paths

IF "%HG_BCC%"==""  SET HG_BCC=c:\borland\bcc55
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=c:\oohg\harbour

IF NOT EXIST %hg_root%\lib\oohg.lib MD %hg_root%\lib >nul

IF EXIST %hg_root%\lib\oohg.lib del %hg_root%\lib\oohg.lib
IF EXIST %hg_root%\lib\hbprinter.lib del %hg_root%\lib\hbprinter.lib
IF EXIST %hg_root%\lib\miniprint.lib del %hg_root%\lib\miniprint.lib

call common_make "%hg_hrb%\lib\tip.lib"
if errorlevel 1 goto EXIT1

SET OOHG_X_FLAGS=-c -O2 -tW -tWM -d -a8 -OS -5 -6 -I%hg_hrb%\include;%hg_bcc%\include;%hg_root%\include; -L%hg_hrb%\lib;%hg_bcc%\lib;

for %%a in (%HG_FILES_PRG% %HG_FILES_C%) do if not errorlevel 1 %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% %%a.c
if errorlevel 1 goto EXIT2
if exist winprint.c  %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% winprint.c
if errorlevel 1 goto EXIT2
if exist miniprint.c %hg_bcc%\bin\bcc32 %OOHG_X_FLAGS% miniprint.c
if errorlevel 1 goto EXIT2

%hg_bcc%\bin\tlib %hg_root%\lib\oohg +h_scrsaver.obj +h_edit.obj +h_edit_ex.obj +h_error.obj +h_ipaddress.obj +c_ipaddress.obj +h_monthcal.obj +c_monthcal.obj +h_help.obj +h_status.obj +h_tree.obj +h_toolbar.obj +h_init.obj +h_media.obj + c_media.obj  +c_resource.obj +h_cursor.obj +c_cursor.obj +h_ini.obj +h_report.obj +h_font.obj +c_font.obj +h_hyperlink.obj +c_scrsaver.obj +h_hotkey.obj +h_graph.obj +c_graph.obj +h_richeditbox.obj +h_browse.obj +h_scroll.obj +h_http.obj +h_zip.obj +h_progressmeter.obj +h_comm.obj +h_print.obj +h_splitbox.obj +h_scrollbutton.obj +h_xbrowse.obj +h_internal.obj +h_textarray.obj +h_hotkeybox.obj /P32
if errorlevel 2 goto EXIT3
%hg_bcc%\bin\tlib %hg_root%\lib\oohg +h_crypt.obj +h_winapimisc.obj +h_slider.obj +c_controlmisc.obj +c_datepicker.obj +c_dialogs.obj +c_grid.obj +c_windows.obj +c_image.obj +c_msgbox.obj +c_frame.obj +c_progressbar.obj +c_spinner.obj +c_textbox.obj +c_winapimisc +h_button.obj +h_checkbox.obj +h_combo.obj +h_controlmisc.obj +h_datepicker.obj +h_editbox.obj +h_dialogs.obj +h_grid.obj +h_windows.obj +h_image.obj +h_label.obj +h_listbox.obj +h_menu.obj +h_msgbox.obj +h_frame.obj +h_progressbar.obj +h_radio.obj +h_spinner.obj +h_tab.obj +h_textbox.obj +h_timer.obj +h_registry.obj +h_activex.obj +c_activex.obj +h_pdf.obj /P32
if errorlevel 2 goto EXIT3
if exist winprint.obj  %hg_bcc%\bin\tlib %hg_root%\lib\hbprinter +winprint.obj
if errorlevel 2 goto EXIT3
if exist miniprint.obj %hg_bcc%\bin\tlib %hg_root%\lib\miniprint +miniprint.obj
if errorlevel 2 goto EXIT3

:EXIT3
IF EXIST %hg_root%\lib\oohg.bak del %hg_root%\lib\oohg.bak
IF EXIST %hg_root%\lib\hbprinter.bak del %hg_root%\lib\hbprinter.bak
IF EXIST %hg_root%\lib\miniprint.bak del %hg_root%\lib\miniprint.bak

:EXIT2
del *.obj

:EXIT1
del h_*.c
if exist winprint.c  del winprint.c
if exist miniprint.c del miniprint.c

SET OOHG_X_FLAGS=
SET HG_FILES_PRG=
SET HG_FILES_C=
