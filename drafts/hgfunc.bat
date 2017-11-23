@echo off
rem   HGFUNC
rem   (Test only, not in use)
rem
rem   example: call :HGFUNC TEST
rem
rem   Variables:
rem
rem   HG_ROOT       - root path OOHG
rem   HG_ROOT_HB    - root path Harbour/XHarbour
rem   HG_ROOT_C     - root path C compiler
rem   HG_COMP_HB    - HB30, HB32, XB
rem   HG_COMP_C     - bcc, mingw, msvc, pocc
rem   HG_PRG_FLAGS  - additional PRG Flags
rem   HG_PRG_FLAGSL - Flag to log -q0 1^>error.lst 2^>^&1
rem   HG_C_FLAGS    - additional C Flags
rem   HG_C_FLAGSL   - Flag to log 1^>error.lst 2^>^&1
rem   HG_PRG_LIST   - list of PRG files WITHOUT extension
rem   HG_C_LIST     - list of C files WITHOUT extension
rem

:MAIN

   if /i "%1"=="TEST" goto :TEST_ALL
   if /i "%1"=="COMPILER" if /i "%2"=="RESET" goto :SET_COMP_RESET
   if /i "%1"=="COMPILER" if /i "%2"=="HB30"  goto :SET_COMP_HB30
   if /i "%1"=="COMPILER" if /i "%2"=="HB32"  goto :SET_COMP_HB32
   if /i "%1"=="COMPILER" if /i "%2"=="XB"    goto :SET_COMP_XB
   if /i "%1"=="COMPILE"     goto :BUILD_PREPARE
   if /i "%1"=="COMPILE_PRG" goto :COMPILE_ALL_PRG
   if /i "%1"=="COMPILE_C"   goto :COMPILE_ALL_C
   goto :END

:TEST_ALL

   call :MAIN COMPILER RESET
   set HG_COMP_C=bcc
   call :TEST_EACH
   pause
   call :MAIN COMPILER RESET
   set HG_COMP_C=pocc
   call :TEST_EACH
   pause
   call :MAIN COMPILER RESET
   set HG_COMP_C=msvc
   call :TEST_EACH
   pause
   call :MAIN COMPILER RESET
   set HG_COMP_C=mingw
   call :TEST_EACH
   pause
   goto :END

:TEST_EACH

   rem ---------- call :MAIN COMPILER RESET
   call :MAIN COMPILER HB30
   cd source
   call :MAIN COMPILE ^
      h_activex h_anigif h_application h_browse h_button ^
         c_windows
   rem ----------      h_checkbox h_checklist h_combo h_comm h_controlmisc h_crypt h_cursor ^
   rem ----------      h_datepicker h_dialogs h_dll h_edit h_editbox h_edit_ex h_error ^
   rem ----------      h_font h_form h_frame h_graph h_grid h_help h_hotkey h_hotkeybox ^
   rem ----------      h_hyperlink h_image h_ini h_init h_internal h_ipaddress h_label ^
   rem ----------      h_listbox h_media h_menu h_monthcal h_msgbox h_notify h_pdf ^
   rem ----------      h_picture h_print h_progressbar h_progressmeter h_radio h_registry ^
   rem ----------      h_report h_richeditbox h_scroll h_scrollbutton h_scrsaver h_slider ^
   rem ----------      h_spinner h_splitbox h_status h_tab h_textarray h_textbox h_timer ^
   rem ----------      h_toolbar h_tooltip h_tree h_winapimisc h_windows h_xbrowse h_zip ^
   rem ----------      c_activex c_controlmisc c_cursor c_dialogs c_font c_gdiplus c_graph ^
   rem ----------      c_image c_media c_msgbox c_progressbar c_resource c_scrsaver c_winapimisc ^

   cd ..
   goto :END

:SET_COMP_RESET

   set HG_ROOT=c:\oohg
   set HG_COMP_HB=
   set HG_COMP_C=
   set HG_ROOT_HB=
   set HG_ROOT_C=
   call :SET_PROJECT_RESET
   goto :END

:SET_PROJECT_RESET

   set HG_C_FLAGS=
   set HG_C_FLAGSL=
   set HG_PRG_FLAGS=
   set HG_PRG_FLAGSL=
   set HG_PRG_LIST=
   set HG_C_LIST=
   goto :END

:SET_COMP_HB30

   if "%HG_ROOT%"==""    set HG_ROOT=c:\oohg
   if "%HG_COMP_HB%"=="" set HG_COMP_HB=HB30
   rem ---------- if "%HG_COMP_C%"==""  set HG_COMP_C=mingw
   if "%HG_ROOT_HB%"=="" set HG_ROOT_HB=c:\oohg\hb30
   if "%HG_ROOT_C%"==""  set HG_ROOT_C=c:\oohg\hb30\comp\mingw
   goto :END

:SET_COMP_HB32

   if "%HG_ROOT%"==""    set HG_ROOT=c:\oohg
   if "%HG_COMP_HB%"=="" set HG_COMP_HB=HB32
   rem ---------- if "%HG_COMP_C%"==""  set HG_COMP_C=mingw
   if "%HG_ROOT_HB%"=="" set HG_ROOT_HB=c:\oohg\hb32
   if "%HG_ROOT_C%"==""  set HG_ROOT_C=c:\oohg\hb32\comp\mingw
   goto :END

:SET_COMP_XB

   if "%HG_ROOT%"==""    set HG_ROOT=c:\oohg
   if "%HG_COMP_HB%"=="" set HG_COMP_HB=XB
   rem ---------- if "%HG_COMP_C%"==""  set HG_COMP_C=bcc
   if "%HG_ROOT_HB%"==""  set HG_ROOT_HB=c:\oohg\xhbcc
   if "%HG_ROOT_C%"==""   set HG_ROOT_C=c:\Borland\BCC55
   goto :END

:BUILD_PREPARE

   shift
   if "%1"=="" goto :BUILD_PROJECT
   if exist %1.prg set HG_PRG_LIST=%HG_PRG_LIST% %1
   if exist %1.c   set HG_C_LIST=%HG_C_LIST% %1
   if exist %1.rc  set HG_RC_LIST=%HG_RC_LIST% %1
   goto :BUILD_PREPARE

:BUILD_PROJECT

   call :COMPILE_ALL_PRG
   call :COMPILE_ALL_C
   call :LINK
   set HG_PRG_LIST=
   set HG_C_LIST=
   goto :END

:COMPILE_ALL_PRG

   if not "%HG_PRG_LIST%"=="" for %%a in ( %HG_PRG_LIST% ) do call :COMPILE_PRG %%a
   goto :END

:COMPILE_PRG

   if not errorlevel 1 echo %HG_ROOT_HB%\bin\harbour %1.prg -n1 %HG_PRG_FLAGS% -i%HG_ROOT_HB%\include;%HG_ROOT%\include;. %HG_PRG_FLAGSL%
   echo.
   call :COMPILE_C %1
   goto :END

:COMPILE_ALL_C

   if not "%HG_C_LIST%"=="" for %%a in ( %HG_C_LIST% ) do call :COMPILE_C %%a
   goto :END

:COMPILE_C

   if /I "%HG_COMP_C%"=="BCC"   goto :COMPILE_BCC
   if /I "%HG_COMP_C%"=="MINGW" goto :COMPILE_MINGW
   if /I "%HG_COMP_C%"=="MSVC"  goto :COMPILE_MSVC
   if /I "%HG_COMP_C%"=="POCC"  goto :COMPILE_POCC
   goto :END

:COMPILE_BCC

   echo %HG_ROOT_C%\bin\bcc32 -c -O2 -tW -M -w -I%HG_ROOT_HB%\include;%HG_ROOT_C%\include;%HG_ROOT%\include; -L%HG_ROOTC%\lib; -D__XHARBOUR__ %1.c %HG_C_FLAGSL%
   echo.
   goto :END

:COMPILE_MINGW

   echo %HG_ROOT_C%\bin\gcc -W -Wall -O3 -c -I%HG_ROOT_HB%\include -I%HG_ROOT_C%\include -I%HG_ROOT%\include -L%HG_ROOT_HB%\%LIB_HRB% -L%HG_ROOT_C%\lib %1.c %HG_C_FLAGSL%
   echo.

   goto :END

:COMPILE_MSVC

   echo %HG_ROOT_C%\bin\cl /O2 /c /TP /I%HG_ROOT_HB%\include /I%HG_ROOT_C%\include /I%HG_ROOT%\include /I. /D__WIN32__ %1.c %HG_C_FLAGSL%
   echo.
   goto :END

:COMPILE_POCC

   echo %HG_ROOT_C%\bin\pocc /Ze /Zx /Go /Tx86-coff /I%HG_ROOT_C%\include /I%HG_ROOT_C%\include\Win /I%HG_ROOT_HB%\include /I%HB_ROOT%\include /D__WIN32__ %1.c %HG_C_FLAGSL%
   echo.

   goto :END

:LINK

   set HG_OBJ_LIST=
   set HG_LIB_LIST=
   call :ADD_OBJ c0w32
   if not "%HG_PRG_LIST%"=="" for %%a in ( %HG_PRG_LIST% ) do call :ADD_OBJ %%a
   call :ADD_LIB rtl
   call :ADD_LIB vm
   if not "%HB_USE_GT%"=="" call :ADD_LIB %HB_USE_GT%
   for %%a in ( lang codepage macro rdd dbfntx dbfcdx dbffpt common debug pp ct ) do call :ADD_LIB %%a
   for %%a in ( hbrtl hbvm hblang hbcpage hbmacro hbrdd rddntx rddcdx rddftp ) do call :ADD_LIB %%a
   for %%a in ( hbcommon hbdebg hbpp hbct hbwin xhb ) do call :ADD_LIB %%a
   for %%a in ( hbdbfdbt hbsix tip hsx pcrepos ) do call :ADD_LIB %%a
   for %%a in ( libmisc hboleaut dll ) do call :ADD_LIB %%a

   for %%a in ( hbodbc odbc32 zlib1 ziparchive ) do call :ADD_LIB %%a
   for %%a in ( rddads ace32 ) do call :ADD_LIB %%a
   for %%a in ( mysql libmysql ) do call :ADD_LIB %%a

   call :ADD_LIB cw32
   call :ADD_LIB msimg32
   call :ADD_LIB import32

   if /I "%HG_COMP_C%"=="BCC"   goto :LINK_BCC
   if /I "%HG_COMP_C%"=="MINGW" goto :LINK_MINGW
   if /I "%HG_COMP_C%"=="MSVC"  goto :LINK_MSVC
   if /I "%HG_COMP_C%"=="POCC"  goto :LINK_POCC
   goto :END

:ADD_OBJ

   if "%HG_COMP%" == "bcc"   set HG_OBJ_LIST=%HG_OBJ_LIST% %1.obj
   if "%HG_COMP%" == "pocc"  set HG_OBJ_LIST=%HG_OBJ_LIST% %1.obj
   if "%HG_COMP%" == "msvc"  set HG_OBJ_LIST=%HG_OBJ_LIST% %1.obj
   if "%HG_COMP%" == "mingw" set HG_OBJ_LIST=%HG_OBJ_LIST% %1.o
   goto :END

:ADD_LIB

   if "%HG_COMP%" == "bcc"   set HG_LIB_LIST=%HG_OBJ_LIST% %1.lib
   if "%HG_COMP%" == "pocc"  set HG_LIB_LIST=%HG_OBJ_LIST% %1.lib
   if "%HG_COMP%" == "msvc"  set HG_LIB_LIST=%HG_OBJ_LIST% %1.lib
   if "%HG_COMP%" == "mingw" set HG_LIB_LIST=%HG_OBJ_LIST% %1.a
   goto :END

:LINK_BCC

   echo BCC LINK
   if exist link.lnk del link.lnk
   for %%a in ( %HG_OBJ_LIST% ) do echo %%a + >> link.lnk
   for %%a in ( %HG_LIB_LIST% ) do echo %%a + >> link.lnk
   echo ,, + >> link.lnk

   if not "%HG_RC_LIST%"=="" echo %HG_RC_LIST%.res + >> link.lnk
   if exist %HG_ROOT%\resources\oohg.res echo %HG_ROOT%\resources\oohg.res + >> link.lnk
   echo LINK.LNK
   type link.lnk
   echo %HG_ROOT_C%\bin\ilink32 -Gn -Tpe -aa -L%HG_ROOT_C%\lib;%HG_ROOT_C%\lib\psdk; @link.lnk %HG_C_FLAGSL%
   del link.lnk

   goto :END

:LINK_MINGW

   echo MINGW LINK
   if exist link.lnk del link.lnk
   for %%a in ( %HG_OBJ_LIST% ) do echo %%a >> link.lnk
   echo -L. >> link.lnk
   echo -L%HG_ROOT%\lib >> link.lnk
   echo -L%HG_ROOT_HB%\lib >> link.lnk
   echo -L%HG_ROOT_C%\lib >> link.lnk
   for %%a in ( %HG_LIB_LIST% ) do echo -l%%a >> link.lnk
   echo %HG_ROOT_C%\bn\gcc -Wall -otest.exe @link.lnk ,--ed-group
   goto :END

:LINK_MSVC

   echo MSVC LINK
   if exist link.lnk del link.lnk
   echo /OUT:test.exe >> link.lnk
   echo /FORCE:MULTIPLE >> link.lnk
   echo /INCLUDE:__matherr >> link.lnk
   for %%a in ( %HG_OBJ_LIST% ) do echo %%a >> link.lnk
   echo link.lnk
   type link.lnk
   echo %HG_ROOT_C%link /SUBSYSTEM:WINDOWS @link.lnk
   del link.lnk
   goto :END

:LINK_POCC

   echo POCC LINK
   if exist link.lnk del link.lnk
   echo /OUT:test.exe >> link.lnk
   echo /FORCE_MULTIPLE >> link.lnk
   echo /LIBPATH:%HG_ROOT%\lib >> link.lnk
   echo /LIBPATH:%HG_ROOT_HB%\lib >> link.lnk
   echo /LIBPATH:%HG_ROOT_C%\lib >> link.lnk
   echo /LIBPATH:%HG_ROOT_C%\lib\win >> link.lnk
   for %%a in ( %HG_OBJ_LIST% ) do echo %%a >> link.lnk
   echo link.lnk
   type link.lnk
   echo %HG_ROOT_C%\polink /SUBSYSTEM:CONSOLE @link.lnk
   del link.lnk
   goto :END

:END
