@Echo Off

Rem Set Paths 

IF "%MG_BCC%"=="" SET MG_BCC=c:\borland\bcc55
IF "%MG_ROOT%"=="" SET MG_ROOT=c:\minigui
IF "%MG_HRB%"=="" SET MG_HRB=c:\minigui\harbour

%MG_BCC%\bin\brc32 -r minigui.rc