@echo off
rem
rem $Id: common_make.bat,v 1.31 2017-07-09 20:08:03 guerra000 Exp $
rem

:MAIN

   if "%1"=="" goto INFO
   rem /// File list
   SET HG_FILES1_PRG=h_error h_windows h_form h_ipaddress h_monthcal h_help h_status h_tree h_toolbar h_init h_media h_winapimisc h_slider h_button h_checkbox h_combo h_controlmisc h_datepicker h_editbox h_dialogs h_grid h_image h_label h_listbox h_menu h_msgbox h_frame h_progressbar h_radio h_spinner h_tab h_textbox h_application h_notify
   SET HG_FILES2_PRG=h_graph h_richeditbox h_edit h_edit_ex h_scrsaver h_browse h_crypt h_zip h_comm h_print h_scroll h_splitbox h_progressmeter h_scrollbutton h_xbrowse h_internal h_textarray h_hotkeybox h_activex h_pdf h_hotkey h_hyperlink h_tooltip h_picture h_dll h_checklist h_timer h_cursor h_ini h_report h_registry h_font h_anigif
   SET HG_FILES_C=c_media c_controlmisc c_resource c_cursor c_font c_dialogs c_windows c_image c_msgbox c_progressbar c_winapimisc c_scrsaver c_graph c_activex c_gdiplus
   rem /// Checks Harbour/xHarbour
   if exist %1 goto XHARBOUR_COMPILE

:HARBOUR_COMPILE

   SET OOHG_X_FLAGS=-i"%hg_hrb%\include;%hg_root%\include" -n1 -w3 -gc0 -es2 %2
   GOTO PRG_COMPILE

:XHARBOUR_COMPILE

   SET OOHG_X_FLAGS=-i"%hg_hrb%\include;%hg_root%\include" -n1 -w2 -gc0 -es2 %2
   GOTO PRG_COMPILE

   rem /// Compile PRG source files

:PRG_COMPILE

   %hg_hrb%\%BIN_HRB%\harbour %HG_FILES1_PRG% %OOHG_X_FLAGS%
   if errorlevel 1 goto EXIT
   %hg_hrb%\%BIN_HRB%\harbour %HG_FILES2_PRG% %OOHG_X_FLAGS%
   if errorlevel 1 goto EXIT
   if exist winprint.prg  %hg_hrb%\%BIN_HRB%\harbour winprint  %OOHG_X_FLAGS%
   if errorlevel 1 goto EXIT
   if exist miniprint.prg %hg_hrb%\%BIN_HRB%\harbour miniprint %OOHG_X_FLAGS%
   if errorlevel 1 goto EXIT
   if exist bostaurus.prg %hg_hrb%\%BIN_HRB%\harbour bostaurus %OOHG_X_FLAGS%
   if errorlevel 1 goto EXIT
   GOTO EXIT

:INFO

   echo ooHG - Library compilation.
   echo .
   echo This file must be called from MAKELIB.BAT
   echo .

:EXIT
