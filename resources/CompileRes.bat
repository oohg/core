@echo off
rem
rem $Id: CompileRes.bat,v 1.3 2011-08-05 18:27:01 fyurisich Exp $
rem

Rem Set Paths 

IF "%HG_BCC%"==""  SET HG_BCC=c:\borland\bcc55
IF "%HG_ROOT%"=="" SET HG_ROOT=c:\oohg
IF "%HG_HRB%"==""  SET HG_HRB=c:\harbour

%HG_BCC%\bin\brc32 -r -fooohg.res oohg_bcc.rc
