/*
*         IDE: HMI+
*     Project: C:\ANALISIS\vd1\install\ciro.pmg
*        Item: Main.prg
* Description:
*      Author:
*        Date: 2004.12.01
*/

#include 'oohg.ch'
*--------------------------
Function Main()
*-------------------------
set century on
set date ansi
msginfo("Welcome ooHG users.","The ooHG IDE+ world")
p1()
LOAD WINDOW fp
center window fp
activate window fp
Return nil


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
Function rep()
*-------------------------
local wempresa
set language to english
wempresa:="hollywood"
USe test
DO REPORT FORM repdemo
close data
return Nil


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
