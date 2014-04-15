@echo off
rem
rem $Id: build.bat,v 1.2 2014-04-15 00:46:19 fyurisich Exp $
rem
cls

rem *** Set Paths ***
if "%HG_ROOT%"=="" set HG_ROOT=c:\oohg

rem *** Call Compiler Specific Batch File ***
call %HG_ROOT%\buildapp.bat mgide %1 %2
