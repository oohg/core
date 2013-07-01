@echo off
rem
rem $Id: build.bat,v 1.2 2013-07-01 19:34:25 migsoft Exp $
rem

SET DISCO=%~d1
SET OOHGPATH=%DISCO%\oohg

%OOHGPATH%\buildapp.bat %*