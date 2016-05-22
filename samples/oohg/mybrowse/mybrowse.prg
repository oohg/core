/*
 * $Id: mybrowse.prg,v 1.3 2016-05-22 23:53:21 fyurisich Exp $
 */
/*
 * This demo shows how to use BROWSE.
 * Copyright (c)2007-2016 MigSoft <migsoft/at/oohg.org>
 *
 */

#include "oohg.ch"

Function Main()

   Local cBaseFolder, aTypes, aNewFiles
   Local nCamp, aEst, aNomb, aJust, aLong, i

   HB_LANGSELECT( "EN" )
   SET CENTURY ON
   SET EPOCH TO YEAR(DATE())-20
   SET DATE TO BRITISH
   
   cBaseFolder := GetStartupFolder()

   aTypes      := { {'Database files (*.dbf)', '*.dbf'} }
   aNewFiles   := GetFile( aTypes, 'Select database files', cBaseFolder, TRUE )

   IF !Empty(aNewFiles)

      Use (aNewFiles[1]) Shared New

      nCamp := Fcount()
      aEst  := DBstruct()

      aNomb := {'iif(deleted(),0,1)'} ; aJust := {0} ; aLong := {0}

      For i := 1 to nCamp
          aadd(aNomb,aEst[i,1])
          aadd(aJust,LtoN(aEst[i,2]=='N'))
          aadd(aLong,Max(100,Min(160,aEst[i,3]*14)))
      Next

      CreaBrowse( Alias(), aNomb, aLong, aJust )

   Endif

Return Nil

Function CreaBrowse( cBase, aNomb, aLong, aJust )

    Local nAltoPantalla  := GetDesktopHeight() + GetTitleHeight() + GetBorderHeight()
    Local nAnchoPantalla := GetDesktopWidth()
    Local nRow           := nAltoPantalla  * 0.10
    Local nCol           := nAnchoPantalla * 0.10
    Local nWidth         := nAnchoPantalla * 0.95
    Local nHeight        := nAltoPantalla  * 0.85
    Local aHdr           := aClone(aNomb)
    Local aCabImg        := aClone(VerHeadIcon())

    aHdr[1] := Nil

    DEFINE WINDOW oWndBase AT nRow , nCol OBJ oWndBase;
      WIDTH nWidth HEIGHT nHeight ;
      TITLE "(c)2009-2016 MigSoft - MyBrowse" ;
      ICON "main" ;
      MAIN ;
      ON SIZE Adjust() ON MAXIMIZE Adjust()

      DEFINE TOOLBAR ToolBar_1 BUTTONSIZE 90,32 FONT "Arial" SIZE 9 FLAT RIGHTTEXT
        BUTTON Cerrar    CAPTION "Cerrar"    PICTURE "MINIGUI_EDIT_CLOSE"  ACTION oWndBase.Release                    AUTOSIZE
        BUTTON Nuevo     CAPTION "Nuevo"     PICTURE "MINIGUI_EDIT_NEW"    ACTION Append()                            AUTOSIZE
        BUTTON Modificar CAPTION "Modificar" PICTURE "MINIGUI_EDIT_EDIT"   ACTION Edit()                              AUTOSIZE
        BUTTON Eliminar  CAPTION "Eliminar"  PICTURE "MINIGUI_EDIT_DELETE" ACTION DeleteRecall()                      AUTOSIZE
        BUTTON Buscar    CAPTION "Buscar"    PICTURE "MINIGUI_EDIT_FIND"   ACTION MsgInfo( "My Find routine", cBase ) AUTOSIZE
        BUTTON Imprimir  CAPTION "Imprimir"  PICTURE "MINIGUI_EDIT_PRINT"  ACTION printlist(cBase, aNomb, aLong)      AUTOSIZE
      END TOOLBAR
      
      IF !IsControlDefined(Browse_1,oWndBase)

                  @ 45,20 BROWSE Browse_1               ;
                     OF oWndBase                        ;
                     WIDTH  oWndBase:Clientwidth  - 40  ;
                     HEIGHT oWndBase:Clientheight - 95  ;
                     HEADERS aHdr                       ;
                     WIDTHS aLong                       ;
                     WORKAREA &( Alias() )              ;
                     FIELDS aNomb                       ;
                     VALUE 0                            ;
                     FONT "MS Sans Serif" SIZE 8        ;
                     TOOLTIP ""                         ;
                     IMAGE { "br_no", "br_ok" }         ;
                     JUSTIFY aJust                      ;
                     LOCK                               ;
                     EDIT                               ;
                     INPLACE                            ;
                     DELETE                             ;
                     ON HEADCLICK Nil                   ;
                     HEADERIMAGES aCabImg               ;
                     FULLMOVE                           ;
                     DOUBLEBUFFER
      ENDIF

    END WINDOW

    oWndBase.Center
    oWndBase.Activate

Return Nil

Function VerHeadIcon()

   Local aName     := {}, cType, n
   Local aHeadIcon := {"hdel"}

   For n := 1 to FCount()
       aadd( aName, Fieldname(n) )
       cType := ValType( &(aName[n]) )
       Switch cType
          Case 'L'
               aadd(aHeadIcon,"hlogic")
               exit
          Case 'D'
               aadd(aHeadIcon,"hfech")
               exit
          Case 'N'
               aadd(aHeadIcon,"hnum")
               exit
          Case 'C'
               aadd(aHeadIcon,"hchar")
               exit
          Case 'M'
               aadd(aHeadIcon,"hmemo")
       End
   Next

Return(aHeadIcon)

Procedure Adjust()
   oWndBase.Browse_1.Width  := oWndBase.width  - 40
   oWndBase.Browse_1.Height := oWndBase.height - 95
Return

Procedure Append()

Return

Procedure Edit()

Return

Procedure DeleteRecall()

   ( Alias() )->( DbGoto(oWndBase.Browse_1.Value) )

   if ( Alias() )->( Rlock() )
      iif( ( Alias() )->( Deleted() ), ( Alias() )->( DbRecall() ), ( Alias() )->( DbDelete() ) )
   endif
   ( Alias() )->( dbUnlock() )

   oWndBase.Browse_1.Refresh
   oWndBase.Browse_1.SetFocus

Return

Procedure printlist()

    Local aHdr1, aTot, aFmt, i

    _OOHG_PRINTLIBRARY="MINIPRINT"

    cBase := Alias()
    aEst  := DBstruct()

    aHdr  := {}
    aLen  := {}

    For i := 1 to ( Alias() )->(FCount())
        Aadd(aHdr,aEst[i,1])
        Aadd(aLen,Max(100,Min(160,aEst[i,3]*14)))
    Next

	
	aeval(aLen, {|e,i| aLen[i] := e/9})

	aHdr1 := array(len(aHdr))
	aTot  := array(len(aHdr))
	aFmt  := array(len(aHdr))
	afill(aHdr1, '')
	afill(aTot, .f.)
	afill(aFmt, '')

	set deleted on

	( Alias() )->( dbgotop() )

	DO REPORT ;
		TITLE    cBase                    ;
		HEADERS  aHdr1, aHdr              ;
		FIELDS   aHdr                     ;
		WIDTHS   aLen                     ;
		TOTALS   aTot                     ;
		NFORMATS aFmt                     ;
		WORKAREA &cBase                   ;
                LPP 60                            ;
                CPL 120                           ;
                LMARGIN  5                        ;
		PAPERSIZE DMPAPER_LETTER          ;
		PREVIEW

	Set Deleted off

Return
