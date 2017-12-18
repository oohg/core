@echo off
rem
rem $Id: CompileRes_bcc.bat $
rem

:COMPILERES_BCC

   echo Compiling oohg.res ...

   if /I not "%1%"=="/NOCLS" cls
   if /I "%1%"=="/NOCLS" shift

   if "%HG_BCC%"=="" set HG_BCC=c:\borland\bcc55

:CHECK

   if not exist "%HG_BCC%\bin\brc32.exe" goto NO_BCC

:COMPILE

   if exist oohg.res del oohg.res
   if exist oohg.res goto ERROR1

   "%HG_BCC%\bin\brc32.exe" -r -fooohg.res oohg_bcc.rc > nul

   if exist oohg.res echo Done.
   if not exist oohg.res echo Not done.
   echo.
   goto EXIT

:NO_BCC

   echo BCC not found !!!
   echo.
   goto EXIT

:ERROR1

   echo Can not delete old oohg.res !!!
   goto EXIT

:EXIT
