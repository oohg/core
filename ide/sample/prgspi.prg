/*
*         IDE: HMI+
*     Project: C:\ANALISIS\vd1\install\ciro.pmg
*        Item: prgspi.prg
* Description:
*      Author:
*        Date: 2003.07.01
*/

#include 'minigui.ch'

*-------------------------
Function prgspi()
*-------------------------
local i
declare window fp
for i:=1 to 65000 step 15
    fp.progressbar_101.value := i
next i
Return Nil
