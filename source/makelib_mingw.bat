@echo off
rem
rem $Id: makelib_mingw.bat $
rem

:MAKELIB_MINGW

   if "%HG_ROOT%"  == "" goto INFO
   if "%HG_HRB%"   == "" goto INFO
   if "%HG_MINGW%" == "" goto INFO
   if "%LIB_GUI%"  == "" goto INFO
   if "%LIB_HRB%"  == "" goto INFO
   if "%BIN_HRB%"  == "" goto INFO

:CLEAN_LIBS

   if not exist %HG_ROOT%\%LIB_GUI%\nul md %HG_ROOT%\%LIB_GUI% >nul

   if exist %HG_ROOT%\%LIB_GUI%\liboohg.a      del %HG_ROOT%\%LIB_GUI%\liboohg.a
   if exist %HG_ROOT%\%LIB_GUI%\libhbprinter.a del %HG_ROOT%\%LIB_GUI%\libhbprinter.a
   if exist %HG_ROOT%\%LIB_GUI%\libminiprint.a del %HG_ROOT%\%LIB_GUI%\libminiprint.a
   if exist %HG_ROOT%\%LIB_GUI%\libbostaurus.a del %HG_ROOT%\%LIB_GUI%\libbostaurus.a

:COMPILE_PRGS

   call common_make "%HG_HRB%\%LIB_HRB%\libtip.a"
   if errorlevel 1 goto EXIT1

:MORE_SETS

   set TPATH=%PATH%
   set PATH=%HG_MINGW%\bin

:COMPILE_C

   echo Compiling C files ...
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

:BUILD_LIBS

   echo Building libraries ...
   %HG_MINGW%\bin\ar rc %HG_ROOT%\%LIB_GUI%\liboohg.a h_scrsaver.o h_edit.o h_edit_ex.o h_error.o h_ipaddress.o h_monthcal.o h_help.o h_status.o h_tree.o h_toolbar.o h_init.o h_media.o c_media.o c_resource.o h_cursor.o c_cursor.o h_ini.o h_report.o c_font.o h_hyperlink.o c_scrsaver.o h_hotkey.o h_graph.o c_graph.o h_richeditbox.o h_browse.o h_scroll.o h_zip.o h_progressmeter.o h_comm.o h_print.o h_splitbox.o h_scrollbutton.o h_pdf.o h_tooltip.o h_application.o h_notify.o
   if errorlevel 2 goto EXIT3
   %HG_MINGW%\bin\ar rc %HG_ROOT%\%LIB_GUI%\liboohg.a h_windows.o h_form.o c_windows.o h_crypt.o h_winapimisc.o h_slider.o c_controlmisc.o c_dialogs.o c_image.o c_msgbox.o c_winapimisc.o h_button.o h_checkbox.o h_combo.o h_controlmisc.o h_datepicker.o h_editbox.o h_dialogs.o h_grid.o h_image.o h_label.o h_listbox.o h_menu.o h_msgbox.o h_frame.o h_progressbar.o h_radio.o h_spinner.o h_tab.o h_textbox.o h_timer.o h_registry.o h_internal.o h_dll.o h_checklist.o
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

   echo Build finished !!!
   echo Look for new libs at %HG_ROOT%\%LIB_GUI%

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
   goto END

:INFO

:END

   echo.
