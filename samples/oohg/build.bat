@echo off
rem
rem $Id: build.bat,v 1.1 2013-06-26 21:21:58 migsoft Exp $
rem

SET DISCO=%~d1
SET OOHGPATH=%~dp0

%DISCO%\oohg\buildapp.bat %*