@echo off
rem
rem $Id: makelib.bat,v 1.7 2005-10-09 21:30:09 guerra000 Exp $
rem
cls

IF "%hg_bcc%"=="" SET HG_BCC=c:\borland\bcc55
IF "%hg_root%"==""  SET HG_ROOT=c:\oohg
IF "%hg_hrb%"=="" SET HG_HRB=c:\harbour

IF EXIST %hg_root%\lib\oohg.lib del %hg_root%\lib\oohg.lib
IF EXIST %hg_root%\lib\hbprinter.lib del %hg_root%\lib\hbprinter.lib

if exist %hg_hrb%\lib\tip.lib goto XHARBOUR_COMPILE

:HARBOUR_COMPILE
%hg_hrb%\bin\harbour h_browse h_scrsaver h_error h_ipaddress h_monthcal h_help h_crypt h_status h_tree h_toolbar errorsys h_init h_media h_winapimisc h_slider h_button h_checkbox h_combo h_controlmisc h_datepicker h_editbox h_dialogs h_grid h_windows h_image h_label h_listbox h_menu h_msgbox h_frame h_progressbar h_radio h_spinner h_tab h_textbox h_timer h_cursor h_ini h_report h_registry h_font h_hyperlink h_hotkey h_graph h_richeditbox h_edit h_edit_ex h_scroll h_http h_zip h_progressmeter -i%hg_hrb%\include;%hg_root%\include; -n1     -gc0 -es2
if exist winprint.prg %hg_hrb%\bin\harbour winprint -i%hg_hrb%\include;%hg_root%\include; -n1     -gc0 -es2
GOTO C_COMPILE

:XHARBOUR_COMPILE
%hg_hrb%\bin\harbour h_browse h_scrsaver h_error h_ipaddress h_monthcal h_help h_crypt h_status h_tree h_toolbar errorsys h_init h_media h_winapimisc h_slider h_button h_checkbox h_combo h_controlmisc h_datepicker h_editbox h_dialogs h_grid h_windows h_image h_label h_listbox h_menu h_msgbox h_frame h_progressbar h_radio h_spinner h_tab h_textbox h_timer h_cursor h_ini h_report h_registry h_font h_hyperlink h_hotkey h_graph h_richeditbox h_edit h_edit_ex h_scroll h_http h_zip h_progressmeter -i%hg_hrb%\include;%hg_root%\include; -n1 -w2 -gc0 -es2
if exist winprint.prg %hg_hrb%\bin\harbour winprint -i%hg_hrb%\include;%hg_root%\include; -n1 -w2 -gc0 -es2

:C_COMPILE
%hg_bcc%\bin\bcc32 -c -O2 -tW -tWM -d -a8 -OS -5 -6 -I%hg_hrb%\include;%hg_bcc%\include;  -L%hg_hrb%\lib;%hg_bcc%\lib; h_scrsaver.c h_edit.c h_edit_ex.c h_error.c h_ipaddress.c c_ipaddress.c h_monthcal.c c_monthcal.c h_help.c c_help.c h_crypt.c c_crypt.c h_status.c c_status.c h_tree.c c_tree.c c_toolbar.c h_toolbar.c errorsys.c h_init.c h_media.c c_media.c h_winapimisc.c h_slider.c c_button.c c_checkbox.c c_combo.c c_controlmisc.c c_datepicker.c c_resource.c h_cursor.c c_cursor.c c_ini.c h_ini.c h_report.c h_registry.c h_font.c c_font.c h_hyperlink.c h_richeditbox.c c_richeditbox.c h_scroll.c h_http.c h_zip.c h_progressmeter.c
%hg_bcc%\bin\bcc32 -c -O2 -tW -tWM -d -a8 -OS -5 -6 -I%hg_hrb%\include;%hg_bcc%\include;  -L%hg_hrb%\lib;%hg_bcc%\lib; c_dialogs.c c_grid.c c_windows.c c_image.c c_label.c c_listbox.c c_menu.c c_msgbox.c c_frame.c c_progressbar.c c_radio.c c_registry.c c_slider.c c_spinner.c c_tab.c c_textbox.c c_timer.c c_winapimisc.c h_button.c h_checkbox.c h_combo.c h_controlmisc.c h_datepicker.c h_editbox.c h_dialogs.c h_grid.c h_windows.c h_image.c h_label.c h_listbox.c h_menu.c h_msgbox.c h_frame.c h_progressbar.c h_radio.c h_spinner.c h_tab.c h_textbox.c h_timer.c c_scrsaver.c h_hotkey.c c_hotkey.c h_graph.c c_graph.c h_browse.c c_browse.c
if exist winprint.c %hg_bcc%\bin\bcc32 -c -O2 -tW -tWM -d -a8 -OS -5 -6 -I%hg_hrb%\include;%hg_bcc%\include;  -L%hg_hrb%\lib;%hg_bcc%\lib; winprint.c

%hg_bcc%\bin\tlib %hg_root%\lib\oohg +h_scrsaver.obj +h_edit.obj +h_edit_ex.obj +h_error.obj +h_ipaddress.obj +c_ipaddress.obj +h_monthcal.obj +c_monthcal.obj +h_help.obj +c_help.obj +h_status.obj +c_status.obj +h_tree.obj +c_tree.obj +h_toolbar.obj +c_toolbar.obj +errorsys.obj +h_init.obj +h_media.obj + c_media.obj  +c_resource.obj +h_cursor.obj +c_cursor.obj +h_ini.obj +c_ini.obj +h_report.obj +h_font.obj +c_font.obj +h_hyperlink.obj +c_scrsaver.obj +h_hotkey.obj +c_hotkey.obj +h_graph.obj +c_graph.obj +h_richeditbox.obj +c_richeditbox.obj +h_browse.obj +c_browse.obj +h_scroll.obj +h_http.obj +h_zip.obj +h_progressmeter.obj
%hg_bcc%\bin\tlib %hg_root%\lib\oohg +c_crypt.obj +h_crypt.obj +h_winapimisc.obj +h_slider.obj +c_button.obj +c_checkbox.obj +c_combo.obj +c_controlmisc.obj +c_datepicker.obj +c_dialogs.obj +c_grid.obj +c_windows.obj +c_image.obj +c_label.obj +c_listbox.obj +c_menu.obj +c_msgbox.obj +c_frame.obj +c_progressbar.obj +c_radio.obj +c_registry.obj +c_slider.obj +c_spinner.obj +c_tab.obj +c_textbox.obj +c_timer.obj +c_winapimisc +h_button.obj +h_checkbox.obj +h_combo.obj +h_controlmisc.obj +h_datepicker.obj +h_editbox.obj +h_dialogs.obj +h_grid.obj +h_windows.obj +h_image.obj +h_label.obj +h_listbox.obj +h_menu.obj +h_msgbox.obj +h_frame.obj +h_progressbar.obj +h_radio.obj +h_spinner.obj +h_tab.obj +h_textbox.obj +h_timer.obj +h_registry.obj
if exist winprint.obj %hg_bcc%\bin\tlib %hg_root%\lib\hbprinter +winprint.obj

IF EXIST %hg_root%\lib\oohg.bak del %hg_root%\lib\oohg.bak
IF EXIST %hg_root%\lib\hbprinter.bak del %hg_root%\lib\hbprinter.bak

del *.obj
del h_*.c
del errorsys.c
if exist winprint.c del winprint.c
