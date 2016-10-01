#include 'oohg.ch'

*--------------------------
Function Main()
*-------------------------
    LOAD WINDOW fp
    center window fp
    activate window fp
Return nil

*-------------------------
Function rep()
*-------------------------
set language to english
wempresa:="hollywood"
USe test
DO REPORT FORM repdemo
close data
return

*-------------------------
function toolbar()
*-------------------------
/*
load window tbarsamp
center window tbarsamp
activate window tbarsamp
*/
return nil

*-------------------------
function abre()
*-------------------------
use test
return nil

*-------------------------
function cierra()
*-------------------------
close data
return nil

#include 'prgspi.prg'
#include 'p2.prg'
