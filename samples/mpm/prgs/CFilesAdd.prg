/*
 * $Id: CFilesAdd.prg,v 1.1 2013-11-18 20:40:24 migsoft Exp $
 */

#include "oohg.ch"
*---------------------------------------------------------------------*
Procedure AddCfiles
*---------------------------------------------------------------------*
   Local Files , x , i , Exists
   
   DECLARE WINDOW main
   DECLARE WINDOW MigMess

   Files :=  GetCFiles( )
   For x := 1 To Len ( Files )
       DO EVENTS
       Exists := .F.
       For i := 1 To main.List_1.ItemCount
           DO EVENTS
           If Upper(alltrim(Files [x])) == Upper(alltrim(main.List_1.Item(i)))
              Exists := .T.
              Exit
           EndIf
       Next i
       If .Not. Exists
          main.List_1.AddItem ( Files [x] )
       EndIf
   Next x

Return
*---------------------------------------------------------------------*
Function GetCFiles()
*---------------------------------------------------------------------*
   Local RetVal := {} , BaseFolder

   If Empty ( main.text_1.Value )
      MsgStop('You must select project base folder first','')
      Return ( {} )
   EndIf

   cDirOld := GetCurrentFolder()
   cDirNew := GetFolder("Folder:",cDirOld)

   IF !Empty(cDirNew)

     cDirOld :=cDirNew
     aFiles  :=Directory( cDirNew + "\" +"*.C" )
     Aeval( aFiles,{|x,y| aFiles[y] :=cDirNew + "\" + x[1]} )

     If Len(aFiles)>0
     
        aFiles :=ASORT(aFiles,{|x,y| UPPER(x) < UPPER(y)})

        DEFINE WINDOW GetCFiles AT 0,0 WIDTH 533 HEIGHT 384 TITLE 'Select C Files' ;
           ICON "ampm" MODAL NOMINIMIZE NOMAXIMIZE NOSIZE BACKCOLOR {255,255,255}

         DEFINE FRAME Frame_21
            ROW    0
            COL    10
            WIDTH  508
            HEIGHT 344
            OPAQUE .T.
         END FRAME

         DEFINE LISTBOX List_C
            ITEMS aFiles
            ROW	20
            COL	20
            WIDTH 490
            HEIGHT 284
            FONTNAME "Segoe UI"
            ONGOTFOCUS This.BackColor := {211,237,250}
            ONLOSTFOCUS This.BackColor := {255,255,225}
            BACKCOLOR {255,255,225}
            MULTISELECT	.T.
         END LISTBOX

         DEFINE BUTTON ALL
            ROW 310
            COL 210
            WIDTH  100
            HEIGHT 28
            CAPTION  'ALL'
            ONCLICK  ( RetVal := GetCFilesOk( aFiles , GetCFiles.List_C.Value ) , GetCFiles.Release )
         END BUTTON

         DEFINE BUTTON OK
            ROW 310
            COL 310
            WIDTH  100
            HEIGHT 28
            CAPTION  'Ok'
            ONCLICK  ( RetVal := GetCFilesOk( aFiles , GetCFiles.List_C.Value ) , GetCFiles.Release )
         END BUTTON

         DEFINE BUTTON CANCEL
            ROW    310
            COL    410
            WIDTH  100
            HEIGHT 28
            CAPTION "Cancel"
            ONCLICK  ( RetVal := {} , GetCFiles.Release )
         END BUTTON

         DEFINE LABEL Label_1
            ROW    315
            COL    40
            WIDTH  120
            HEIGHT 24
            VALUE "Select ( Ctrl + Click )"
            TRANSPARENT .T.
         END LABEL


        END WINDOW

        CENTER WINDOW GetCFiles
        GetCFiles.Ok.Setfocus
        ACTIVATE WINDOW GetCFiles
     Else
         MsgInfo("C Files not found","C Files")
         RetVal := {}
     Endif

   Endif

Return ( RetVal )
*---------------------------------------------------------------------*
Function GetCFilesOk( aFiles , aSelected )
*---------------------------------------------------------------------*
   Local aNew := {} , i

   If Empty( aSelected )
      aNew := aFiles
   Else
      For i := 1 To Len ( aSelected )
          DO EVENTS      
          aadd ( aNew , aFiles [ aSelected [i] ] )
      Next i
   Endif

Return aNew

