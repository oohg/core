@echo off
rem
rem $Id: common_make.bat $
rem

:MAIN

   if "%1"         == "" goto INFO
   if "%HG_ROOT%"  == "" goto INFO
   if "%HG_HRB%"   == "" goto INFO
   if "%BIN_HRB%"  == "" goto INFO

   rem *** File list ***
   set HG_FILES1_PRG=h_error h_windows h_form h_ipaddress h_monthcal h_help h_status h_tree h_toolbar h_init h_media h_winapimisc h_slider h_button h_checkbox h_combo h_controlmisc h_datepicker h_editbox h_dialogs h_grid h_image h_label h_listbox h_menu h_msgbox h_frame h_progressbar h_radio h_spinner h_tab h_textbox h_application h_notify
   set HG_FILES2_PRG=h_graph h_richeditbox h_edit h_edit_ex h_scrsaver h_browse h_crypt h_zip h_comm h_print h_scroll h_splitbox h_progressmeter h_scrollbutton h_xbrowse h_internal h_textarray h_hotkeybox h_activex h_pdf h_hotkey h_hyperlink h_tooltip h_picture h_dll h_checklist h_timer h_cursor h_ini h_report h_registry h_anigif
   set HG_FILES_C=c_media c_controlmisc c_resource c_cursor c_font c_dialogs c_windows c_image c_msgbox c_winapimisc c_scrsaver c_graph c_activex c_gdiplus

   rem *** Check for Harbour/xHarbour ***
   if exist %1 goto XHARBOUR_COMPILE

:HARBOUR_COMPILE

   rem This define is needed to handle GTGUI in Harbour builds
   set HG_X_FLAGS=-i"%HG_HRB%\include;%HG_ROOT%\include" -n1 -w3 -gc0 -es2 -d_OOHG_CONSOLEMODE_ %2
   goto PRG_COMPILE

:XHARBOUR_COMPILE

   set HG_X_FLAGS=-i"%HG_HRB%\include;%HG_ROOT%\include" -n1 -w3 -gc0 -es2 %2
   goto PRG_COMPILE

:PRG_COMPILE

   echo Compiling prg files ...
   for %%a in ( %HG_FILES1_PRG% %HG_FILES2_PRG% ) do (
      %HG_HRB%\%BIN_HRB%\harbour %%a %HG_X_FLAGS% %~3
      if errorlevel 1 (
         set HG_ERRORAT=%%a
         goto ERROR ) )
   if not exist winprint.prg echo winprint.prg is missing !!!
   if not exist winprint.prg goto ERROR
   if exist winprint.prg  %HG_HRB%\%BIN_HRB%\harbour winprint  %HG_X_FLAGS% %~3
   if errorlevel 1 goto ERROR
   if not exist miniprint.prg echo miniprint.prg is missing !!!
   if not exist miniprint.prg goto ERROR
   if exist miniprint.prg %HG_HRB%\%BIN_HRB%\harbour miniprint %HG_X_FLAGS% %~3
   if errorlevel 1 goto ERROR
   if not exist bostaurus.prg echo bostaurus.prg is missing !!!
   if not exist bostaurus.prg goto ERROR
   if exist bostaurus.prg %HG_HRB%\%BIN_HRB%\harbour bostaurus %HG_X_FLAGS% %~3
   if errorlevel 1 goto ERROR
   goto END

:INFO

   echo This file must be called from MAKELIB.BAT !!!
   echo.
   goto END

:ERROR

   if not .%3.==.. echo Error compiling %HG_ERRORAT%.prg !!!
   if not .%3.==.. echo.
   set HG_ERRORAT=

:END
