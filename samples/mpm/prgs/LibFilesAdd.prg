/*
 * $Id: LibFilesAdd.prg,v 1.1 2013-11-18 20:40:25 migsoft Exp $
 */

#include "oohg.ch"
*---------------------------------------------------------------------*
Procedure AddLibfiles
*---------------------------------------------------------------------*
   Local Files , x , i , Exists

   DECLARE WINDOW main
   DECLARE WINDOW MigMess

   Files :=  GetLibFiles( )
   For x := 1 To Len ( Files )
       DO EVENTS
       Exists := .F.
       For i := 1 To main.List_2.ItemCount
           DO EVENTS
           If Upper(alltrim(Files [x])) == Upper(alltrim(main.List_2.Item(i)))
              Exists := .T.
              Exit
           EndIf
       Next i
       If .Not. Exists
          main.List_2.AddItem ( Files [x] )
       EndIf
   Next x

Return
*---------------------------------------------------------------------*
Function GetLibFiles()
*---------------------------------------------------------------------*
   Local RetVal := {} , LibFolder

   If Empty ( main.text_1.Value )
      MsgStop('You must select project base folder first','')
      Return ( {} )
   EndIf

   cDirOld := GetCurrentFolder() // NIL
   cDirNew := GetFolder("Folder:",cDirOld)

   IF !Empty(cDirNew)
     cDirOld  :=cDirNew

   If (main.RadioGroup_6.value = 1)
     aFiles :=DIRECTORY(cDirNew + "\" +"*.a")
     AEVAL(aFiles,{|x,y| aFiles[y] :=cDirNew + "\" + x[1]})
   else
     aFiles :=DIRECTORY(cDirNew + "\" +"*.Lib")
     AEVAL(aFiles,{|x,y| aFiles[y] :=cDirNew + "\" + x[1]})
   Endif
   
     If Len(aFiles)>0

        aFiles :=ASORT(aFiles,{|x,y| UPPER(x) < UPPER(y)})

   DEFINE WINDOW GetLibFiles AT 0,0 WIDTH 533 HEIGHT 384 TITLE 'Select LIB Files' ;
      ICON "ampm" MODAL NOMINIMIZE NOMAXIMIZE NOSIZE BACKCOLOR {255,255,255}

         DEFINE FRAME Frame_21
            ROW    0
            COL    10
            WIDTH  508
            HEIGHT 344
            OPAQUE .T.
         END FRAME

         DEFINE LISTBOX List_Lib
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
            CAPTION  'All'
            ONCLICK  ( RetVal := GetLibFilesOk( aFiles , GetLibFiles.List_Lib.Value ) , GetLibFiles.Release )
         END BUTTON

         DEFINE BUTTON OK
            ROW 310
            COL 310
            WIDTH  100
            HEIGHT 28
            CAPTION  'Ok'
            ONCLICK  ( RetVal := GetLibFilesOk( aFiles , GetLibFiles.List_Lib.Value ) , GetLibFiles.Release )
         END BUTTON

         DEFINE BUTTON CANCEL
            ROW    310
            COL    410
            WIDTH  100
            HEIGHT 28
            CAPTION "Cancel"
            ONCLICK  ( RetVal := {} , GetLibFiles.Release )
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

   CENTER WINDOW GetLibFiles
   GetLibFiles.Ok.Setfocus
   ACTIVATE WINDOW GetLibFiles

     Else
         MsgInfo("(*.Lib or *.a ) Files not found","Libraries files")
         RetVal := {}
     Endif

   Endif

Return ( RetVal )
*---------------------------------------------------------------------*
Function GetLibFilesOk( aFiles , aSelected )
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

Return( aNew )
*---------------------------------------------------------------------*
Procedure RemoveLibFile()
*---------------------------------------------------------------------*
   Local a_Mig := main.List_2.value
   If !Empty(a_Mig)
      If MsgYesNo('Remove File(s) ' + UPPER( main.List_2.Item( main.List_2.Value ) ) + ' From Project ?','Confirm')
         While Len(a_Mig) > 0
            main.List_2.DeleteItem( a_Mig[ 1 ] )
            a_Mig := main.List_2.value
         Enddo
      EndIf
      if main.list_2.ItemCount > 0
         main.List_2.value := {1}
      endif
   Endif
Return
