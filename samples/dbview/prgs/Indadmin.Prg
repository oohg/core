/*
 * $Id: Indadmin.Prg,v 1.1 2013-11-19 19:15:41 migsoft Exp $
 */

/*
 *
 * MINIGUI - Harbour Win32 GUI library
 * Copyright 2002-2012 Roberto Lopez <harbourminigui@gmail.com>
 * http://harbourminigui.googlepages.com/
 *
 * Program to view DBF files using standard Browse control
 * Miguel Angel Juárez A. - 2009-2012 MigSoft <mig2soft/at/yahoo.com>
 *
 */

#include "oohg.ch"
#include "dbuvar.ch"
#include "hbcompat.ch"

*------------------------------------------------------------*
Procedure IndexManager()
*------------------------------------------------------------*
   If !Empty( Alias() )

DEFINE WINDOW IndAdmin AT 270 , 574 WIDTH 561 HEIGHT 370 TITLE PROGRAM+"- Index Manager" MODAL ICON "main1" ON INIT FillGrid() nosize nomaximize nominimize

     DEFINE SPLITBOX

     DEFINE TOOLBAR Toolbar_133   BUTTONSIZE 16,16 FONT "Arial" SIZE 9 FLAT
            BUTTON OpenIndex      TOOLTIP   "Open Index"   PICTURE "open1"    ACTION OpenIndex()
            BUTTON NewIndex       TOOLTIP   "New Index"    PICTURE "new1"     ACTION NewModifyIndex(0)
            BUTTON CloseIndex     TOOLTIP   "Close Index"  PICTURE "closeid1" ACTION CloseIndex()
            BUTTON Modifyindex    TOOLTIP   "Modify Index" PICTURE "modiind1" ACTION NewModifyIndex(1)
            BUTTON Reindex1       TOOLTIP   "Reindex"      PICTURE "reindex1" ACTION ReindexBag() SEPARATOR
            BUTTON AddTag         TOOLTIP   "Add Tag"      PICTURE "addtag1"  ACTION NewModifyIndex(1)
            BUTTON DropTag        TOOLTIP   "Drop Tag"     PICTURE "droptag1" ACTION DestroyTag()
     END TOOLBAR

     END SPLITBOX

     DEFINE GRID Grid_133
            ROW    50
            COL    20
            WIDTH  513
            HEIGHT 244
            ITEMS {}
            VALUE 1
            WIDTHS {90,90,150,90,88}
            HEADERS {'Index File','Index Tag','Expression','Sorting Order','Unique'}
            FONTNAME 'Arial'
            MULTISELECT .T.
            ondblclick Result()
     END GRID

     DEFINE BUTTON Button_133
            ROW    300
            COL    210
            WIDTH  100
            HEIGHT 28
            CAPTION "Native Order"
            FONTNAME 'Arial'
            TOOLTIP ''
            ACTION ( SeleNativeOrder(), IndAdmin.release )
     END BUTTON

     DEFINE BUTTON Button_233
            ROW    300
            COL    320
            WIDTH  100
            HEIGHT 28
            CAPTION "Set the Order"
            FONTNAME 'Arial'
            TOOLTIP ''
            ACTION ( IndSeleOrder(), IndAdmin.release )
     END BUTTON

     DEFINE BUTTON Button_333
            ROW    300
            COL    430
            WIDTH  100
            HEIGHT 28
            CAPTION "Close"
            FONTNAME 'Arial'
            TOOLTIP ''
            ACTION IndAdmin.release
     END BUTTON

END WINDOW

Center Window IndAdmin
Activate Window IndAdmin

   Endif
Return

*------------------------------------------------------------*
Procedure NewModifyIndex( nOpt )
*------------------------------------------------------------*
Local cFieldSel := ""

DEFINE WINDOW ModIndex AT 234 , 68 WIDTH 410 HEIGHT 280 TITLE "Create/modify index" MODAL ICON "main1" nosize nosysmenu nomaximize nominimize

     DEFINE FRAME Frame_133
            ROW    5
            COL    5
            WIDTH  393
            HEIGHT 203
            FONTNAME 'Arial'
            CAPTION "Index parameters"
            OPAQUE .T.
     END FRAME

     DEFINE LABEL Label_133
            ROW    40
            COL    10
            WIDTH  70
            HEIGHT 24
            VALUE "Index File :"
     END LABEL

     DEFINE LABEL Label_233
            ROW    70
            COL    10
            WIDTH  70
            HEIGHT 24
            VALUE "Index Tag :"
     END LABEL

     DEFINE LABEL Label_333
            ROW    100
            COL    10
            WIDTH  70
            HEIGHT 24
            VALUE "Expression :"
     END LABEL

     DEFINE TEXTBOX Text_IndBag
            ROW    40
            COL    80
            WIDTH  160
            HEIGHT 24
            FONTNAME 'Arial'
            VALUE  ( Alias() )->( OrdBagName() )+( Alias() )->( OrdBagExt() )
     END TEXTBOX

     DEFINE TEXTBOX Text_IndTag
            ROW    70
            COL    80
            WIDTH  160
            HEIGHT 22
            FONTNAME 'Arial'
            VALUE  ( Alias() )->( OrdName(1) )
     END TEXTBOX

     DEFINE TEXTBOX Text_IndKey
            ROW    100
            COL    80
            WIDTH  280
            HEIGHT 23
            FONTNAME 'Arial'
            VALUE  ( Alias() )->( OrdKey(1) )
     END TEXTBOX

     DEFINE BUTTON Button_134
            ROW    215
            COL    250
            WIDTH  70
            HEIGHT 25
            CAPTION "Save"
            FONTNAME 'Arial'
            ACTION IndexTag()
     END BUTTON

     DEFINE BUTTON Button_234
            ROW    215
            COL    325
            WIDTH  70
            HEIGHT 25
            CAPTION "Cancel"
            FONTNAME 'Arial'
            ACTION ModIndex.release
     END BUTTON

     DEFINE CHECKBOX Check_Uniq
            ROW    40
            COL    290
            WIDTH  100
            HEIGHT 28
            CAPTION "Unique"
            FONTNAME 'Arial'
            TOOLTIP ''
     END CHECKBOX

     DEFINE CHECKBOX Check_Desc
            ROW    70
            COL    290
            WIDTH  100
            HEIGHT 28
            CAPTION "Descending"
            FONTNAME 'Arial'
            TOOLTIP ''
     END CHECKBOX

     DEFINE BUTTON Button_IndKey
            ROW    100
            COL    360
            WIDTH  24
            HEIGHT 24
            CAPTION "..."
            FONTNAME 'Arial'
            TOOLTIP ''
            ACTION Expression()
     END BUTTON

END WINDOW

Center Window ModIndex

   If nOpt == 1
      aIndMan := Result()
      If Len( aIndMan ) > 0
         ModIndex.Text_IndBag.value    := aIndMan[1]
         ModIndex.Text_IndBag.readonly := .T.
         ModIndex.Text_IndTag.value    := aIndMan[2]
         ModIndex.Text_IndKey.value    := aIndMan[3]
         ModIndex.Check_Desc.value     := iif(aIndMan[4]="Descending",.T.,.F.)
         ModIndex.Check_Uniq.value     := iif(aIndMan[5]="True",.T.,.F.)
      Endif
   Endif

Activate Window ModIndex

Return

*------------------------------------------------------------*
Function Expression()
*------------------------------------------------------------*
   define window IndexExpress at 0,0 width 300 height 500 title "Select Field" modal nosize nosysmenu nomaximize nominimize
        define grid fields_133
            row 20
            col 12
            width 270
            height 380
            widths {265}
            headers {"Field Names"}
            ondblclick ( ModIndex.Text_IndKey.value := SeleField(), IndexExpress.release )
        end grid
        define button setindexbutton
           row 430
           col 85
           caption "Set the Field"
           action  ( ModIndex.Text_IndKey.value := SeleField(), IndexExpress.release )
        end button
        define button closeindexbutton
           row 430
           col 185
           caption "Close"
           action IndexExpress.release
        end button
   End window
   aEst  := DBstruct()
   For i := 1 to FCount()
       If !aEst[i,2] == "M"
          IndexExpress.fields_133.additem( {AllTrim( aEst[i,1] ) })
       Endif
   Next i

   IndexExpress.center
   IndexExpress.activate

Return(Nil)

*------------------------------------------------------------*
Function SeleField()
*------------------------------------------------------------*
   cField := IndexExpress.fields_133.item(IndexExpress.fields_133.value)

Return( cField[1] )


*------------------------------------------------------------*
Procedure SeleNativeOrder()
*------------------------------------------------------------*
   If !Empty( Alias() )
      ( Alias() )->(OrdSetFocus(0))
   Endif
   MuestraRec()
Return

*------------------------------------------------------------*
Procedure DestroyTag()
*------------------------------------------------------------*
   If !Empty( Alias() )
       aRow := IndAdmin.Grid_133.value
       If Len(aRow) > 0
          ( Alias() )->(OrdDestroy( aRow[1] ))
          IndAdmin.Grid_133.DeleteAllItems
       Endif
   Endif
   FillGrid()
Return

*------------------------------------------------------------*
Procedure IndSeleOrder()
*------------------------------------------------------------*
   If !Empty( Alias() )
       aRow := IndAdmin.Grid_133.value
      ( Alias() )->( OrdSetFocus( aRow[1] ) )
   Endif
   MuestraRec()
   Primero()
Return

*------------------------------------------------------------*
Procedure CloseIndex()
*------------------------------------------------------------*
   If !Empty( Alias() )
      ( Alias() )->( DbClearIndex() )
      IndAdmin.Grid_133.DeleteAllItems
   Endif
   MuestraRec()
Return

*------------------------------------------------------------*
Procedure IndexTag()
*------------------------------------------------------------*
   Index_Now( ModIndex.Text_IndBag.value, ModIndex.Text_IndKey.value, ModIndex.Text_IndTag.value, ModIndex.Check_Desc.value, ModIndex.Check_Uniq.value )
   ModIndex.release
   IndAdmin.Grid_133.DeleteAllItems
   FillGrid()
Return

*------------------------------------------------------------*
Procedure ReindexBag()
*------------------------------------------------------------*
   Local aTags   := {}
   Local nLineas := GetExistingControlObject( "Grid_133", "IndAdmin" ):ItemCount

   If !Empty( Alias() )
      If ( Alias() )->( OrdCount() ) > 0
         For j := 1 to nLineas
             Aadd( aTags, GetExistingControlObject( "Grid_133", "IndAdmin" ):Item(j) )
             ( Alias() )->( OrdDestroy( j ) )
         Next

         ( Alias() )->( DbClearIndex() )
         Ferase( aTags[1,1] )
         IndAdmin.Grid_133.DeleteAllItems

         If Len(aTags) > 0
            For n := 1 to nLineas
                lDesc := Iif(aTags[n,4]="Descending",.T.,.F.)
                lUniq := Iif(aTags[n,5]="True",.T.,.F.)
                Index_Now( aTags[n,1], aTags[n,3], aTags[n,2], lDesc, lUniq )
            Next
         Endif
       Endif
   Endif
   FillGrid()

Return

*------------------------------------------------------------*
Procedure Result()
*------------------------------------------------------------*
   local n_for, n_pos, x, a_result, aResult := {}
   local m_itemcount := GetExistingControlObject( "Grid_133", "IndAdmin" ):ColumnCount ()
   //{'Index File','Index Tag','Expression','Sorting Order','Unique'}

   If m_itemcount > 0
      a_result := IndAdmin.Grid_133.value
      If Len( a_result ) > 0
         aResult := {}
         For n_for = 1 to len( a_result )
             n_pos := a_result[ n_for ]
             For i := 1 to m_itemcount
                 Aadd( aResult, IndAdmin.Grid_133.cell( n_pos , i ) )
             Next
         Next
      Endif
   Endif

Return(aResult)

*------------------------------------------------------------*
Function OpenIndex()
*------------------------------------------------------------*
    Local aIndexBag := {}
    Local aOpenTag  := {}
    Local nOk       := 0

   If !Empty( Alias() )
      If ( Alias() )->( OrdCount() ) == 0
         aIndexFile := GetFile( {{"Index File (*.cdx)","*.cdx"}},"Choose Index File to Open",CurDir(),.t.,.t. )
         if Len( aIndexFile ) > 0
            For i := 1 to Len( aIndexFile )
                aIndexBag := aIndexFile[i]

                TRY
                   ( Alias() )->( OrdListAdd( (aIndexBag) ) )
                CATCH loError
                   MsgInfo("Invalid Index File!!!","Caution")
                   Return(Nil)
                END

                For j := 1 to ( Alias() )->( OrdCount() )
                    Aadd( aOpenTag, IndexKey(j) )
                Next j
            next i
         endif
      Endif
      FillGrid()
   Endif

   MuestraRec()

Return(Nil)

*------------------------------------------------------------*
Procedure FillGrid()
*------------------------------------------------------------*
   If !Empty( Alias() )
      If ( Alias() )->( OrdCount() ) > 0
         IndAdmin.Grid_133.DeleteAllItems
         For j := 1 to ( Alias() )->( OrdCount() )
             cOrden  := iif( ( Alias() )->(OrdDescend(j)) =.T.,"Descending","Ascending" )
             cUnique := iif( ( Alias() )->(OrdIsUnique(j))=.T.,"True"     ,"False"      )
             IndAdmin.Grid_133.AddItem ( {( Alias() )->( OrdBagName(j) )+( Alias() )->( OrdBagExt() ), ( Alias() )->( OrdName(j) ), ( Alias() )->(OrdKey(j)), cOrden, cUnique })
         Next j
         IndAdmin.Grid_133.value := {1}
      Endif
   Endif
Return

*------------------------------------------------------------*
FUNCTION Index_Now( cBag, cKey, cTag, lDesc, lUniq )
*------------------------------------------------------------*
    Local cBag2 := cBag

    DEFINE WINDOW Form_idx AT 274,282 WIDTH 298 HEIGHT 100 ;
        TITLE "Indexing in progress !!!" ICON "Tool" MODAL NOSIZE ;
        ON INIT Go_Index( cKey, cBag2, cTag, lDesc, lUniq ) ;
        FONT 'Arial' SIZE 09 nosysmenu nomaximize nominimize

        @  6,94 LABEL Label_001 VALUE "Completed " WIDTH 120 HEIGHT 18
        @ 26,19 PROGRESSBAR ProgressBar_1 RANGE 0,100 WIDTH 252 HEIGHT 18

        DEFINE STATUSBAR
           STATUSITEM PadC( cBag2, 80 )
        END STATUSBAR

    END WINDOW
    Form_idx.center
    Form_idx.ACTIVATE

RETURN NIL

*------------------------------------------------------------*
Function Go_Index( cKey, cBag, cTag, lDesc, lUniq )
*------------------------------------------------------------*

    If     lDesc=.T. .AND. lUniq=.F.
           INDEX ON &cKey TAG &cTag TO &cBag DESCENDING EVAL Go_Progress() EVERY LASTREC()/20
    ElseIf lDesc=.F. .AND. lUniq=.T.
           INDEX ON &cKey TAG &cTag TO &cBag UNIQUE EVAL Go_Progress() EVERY LASTREC()/20
    ElseIf lDesc=.T. .AND. lUniq=.T.
           INDEX ON &cKey TAG &cTag TO &cBag DESCENDING UNIQUE EVAL Go_Progress() EVERY LASTREC()/20
    Else
           INDEX ON &cKey TAG &cTag TO &cBag EVAL Go_Progress() EVERY LASTREC()/20
    Endif

    Form_idx.Release

Return(Nil)

*------------------------------------------------------------*
FUNCTION Go_Progress()
*------------------------------------------------------------*
    Local nComplete := INT((RecNo()/LastRec()) * 100)
    Local cComplete := Ltrim(Str(nComplete))

    Form_idx.Label_001.Value     := "Completed "+ cComplete + "%"
    Form_idx.ProgressBar_1.Value := nComplete

Return(.T.)
