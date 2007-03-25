@echo off
rem
rem $Id: common_make.bat,v 1.3 2007-03-25 22:41:42 guerra000 Exp $
rem

if "%1"=="" goto INFO

rem /// File list

SET HG_FILES_PRG=h_browse h_scrsaver h_error h_ipaddress h_monthcal h_help h_crypt h_status h_tree h_toolbar h_init h_media h_winapimisc h_slider h_button h_checkbox h_combo h_controlmisc h_datepicker h_editbox h_dialogs h_grid h_windows h_image h_label h_listbox h_menu h_msgbox h_frame h_progressbar h_radio h_spinner h_tab h_textbox h_timer h_cursor h_ini h_report h_registry h_font h_hyperlink h_hotkey h_graph h_richeditbox h_edit h_edit_ex h_zip
SET HG_FILES_PRG=%HG_FILES_PRG% h_http h_comm h_print h_scroll h_splitbox h_progressmeter h_scrollbutton h_xbrowse h_internal h_textarray h_hotkeybox h_activex
SET HG_FILES_C=c_ipaddress c_monthcal c_help c_crypt c_tree c_toolbar c_media c_combo c_controlmisc c_datepicker c_resource c_cursor c_ini c_font c_dialogs c_grid c_windows c_image c_listbox c_msgbox c_frame c_progressbar c_spinner c_textbox c_timer c_winapimisc c_scrsaver c_graph

rem /// Checks Harbour/xHarbour

if exist %1 goto XHARBOUR_COMPILE

:HARBOUR_COMPILE
SET OOHG_X_FLAGS=-i"%hg_hrb%\include;%hg_root%\include" -n1 -w  -gc0 -es2
GOTO PRG_COMPILE

:XHARBOUR_COMPILE
SET OOHG_X_FLAGS=-i"%hg_hrb%\include;%hg_root%\include" -n1 -w2 -gc0 -es2
GOTO PRG_COMPILE

rem /// Compile PRG source files

:PRG_COMPILE
%hg_hrb%\bin\harbour %HG_FILES_PRG% %OOHG_X_FLAGS%
if errorlevel 1 goto EXIT
if exist winprint.prg  %hg_hrb%\bin\harbour winprint  %OOHG_X_FLAGS%
if errorlevel 1 goto EXIT
if exist miniprint.prg %hg_hrb%\bin\harbour miniprint %OOHG_X_FLAGS%
if errorlevel 1 goto EXIT

goto EXIT

:INFO
echo ooHG - Library compilation.
echo .
echo This file must be called from MAKELIB.BAT
echo .

:EXIT
