@echo off
rem
rem $Id: CompileRes.bat,v 1.2 2006-01-23 00:44:01 guerra000 Exp $
rem

Rem Set Paths 

IF "%HG_BCC%"==""  SET HG_BCC=c:\borland\bcc55
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=c:\harbour

%HG_BCC%\bin\brc32 -r oohg.rc
