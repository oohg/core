/*
 * $Id: dbquery1.prg,v 1.1 2013-11-19 19:15:41 migsoft Exp $
 */

/*
 *
 * MINIGUI - Harbour Win32 GUI library
 * Copyright 2002-2012 Roberto Lopez <harbourminigui@gmail.com>
 * http://harbourminigui.googlepages.com/
 *
 * Program to view DBF files using standard Browse control
 * Miguel Angel Juárez A. - 2009-2012 MigSoft <mig2soft/at/yahoo.com>
 * Includes the code of Grigory Filatov <gfilatov@freemail.ru>
 * and Rathinagiri <srathinagiri@gmail.com>
 *
 */

#include "oohg.ch"
#include "dbuvar.ch"

#define COMPILE(cExpr)    &("{||" + cExpr + "}")
#define MsgInfo( c ) MsgInfo( c, "DBView", , .f. )

#define Q_FILE  1   // For the aQuery_ array
#define Q_DESC  2
#define Q_EXPR  3

DECLARE WINDOW Form_Query

Function AddText(cExpr, aUndo_, cText)

  cExpr += cText
  aadd(aUndo_, cText)
  Form_Query.Edit_1.Value := cExpr
  DO EVENTS

Return(NIL)


Function GetType(cField, aFlds_, cChar)
  local cType, n

  n := len(aFlds_)

  if cField == aFlds_[n]    // Deleted() == Logical
    cType := "L"
  else
    n := ascan(aFlds_, cField)
    cType := valtype((cAlias)->( fieldget(n) ))
    if cType == "M"
      cType := "C"
    elseif cType == "C"
      cChar := padr(cChar, len((cAlias)->( fieldget(n) )))
    endif
  endif

Return(cType)


Function CheckComp(cType, cComp)
  local lOk := .T.
  local cTemp := left(cComp, 2)

  do case
    case cType $ "ND"
      if cTemp $ "$ ()"
        lOk := .F.
      endif
    case cType == "L"
      if cTemp <> "==" .and. cTemp <> "<>" .and. cTemp <> '""'
        lOk := .F.
      endif
    otherwise     // All are Ok for character variables
      lOk := .T.
  endcase

  if !lOk
    MsgInfo("Invalid comparison for selected data type.")
  endif

Return(lOk)


Function AddExpr(cExpr, aUndo_, cField, cComp, uVal)
  local cVT, cTemp
  local xFieldVal := (cAlias)->( fieldget(fieldpos(cField)) )

  cVT := alltrim(left(cComp, 2))
  if cVT == '()'
    cTemp := '"' + rtrim(uVal) + '" $ ' + cField
  elseif cVT == '""'
    cTemp := "empty(" + cField + ")"
  else
    cTemp := cField + ' ' + cVT + ' '
    cVT := valtype(uVal)
    do case
      case cVT == 'C'
        cTemp += '"' + padr(uVal, len(xFieldVal)) + '"'
      case cVT == 'N'
        cTemp += ltrim(str(uVal))
      case cVT == 'D'
        cTemp += 'ctod("' + dtoc(uVal) + '")'
      case cVT == "L"
        cTemp += iif(uVal, '.T.', '.F.')
    endcase
  endif

  cTemp += " "

  AddText(@cExpr, aUndo_, cTemp)

Return(NIL)


Function Undo(cExpr, aUndo_)
  local l := len(aUndo_)
  local x, cTemp := cExpr

  if (x := rat(aUndo_[l], cTemp)) > 0
    cExpr := InsDel(cTemp, x, len(aUndo_[l]), "")
    Form_Query.Edit_1.Value := cExpr
    DO EVENTS
  endif

  asize(aUndo_, l - 1)

Return(NIL)


Function RunQuery(cExpr)
  local nCurRec := (cAlias)->( recno() )
  local bOldErr := ErrorBlock({|e| QueryError(e) })
  local lOk := .T.
  local nCount := 0

  begin sequence
    (cAlias)->( DbSetFilter(COMPILE(cExpr), cExpr) )
  recover
    (cAlias)->( DbClearFilter() )
    lOk := .F.
  end sequence
  errorblock(bOldErr)

  if !lOk
    (cAlias)->( DbGoTo(nCurRec) )
    Return(lOk)
  endif

  (cAlias)->( DbGoTop() )
  do while !(cAlias)->( EoF() )
    nCount++
    (cAlias)->( DbSkip() )
    if !(cAlias)->( EoF() )
      exit
    endif
  enddo
  DO EVENTS

  if Empty(nCount)
    lOk := .F.
    MsgInfo( 'There are no such records!' )
    (cAlias)->( DbClearFilter() )
    (cAlias)->( DbGoTo(nCurRec) )
  else
    (cAlias)->( DbGoTop() )
  endif

Return(lOk)


Function SaveQuery(cExpr, aQuery_,cBase)
  local cDesc := ""
  local cQFile
  local lAppend := .T., x
  local aMask := { { "DataBase Queries (*.dbq)", "*.dbq" }, ;
                 { "All Files        (*.*)", "*.*"} }

  if !empty(aQuery_[Q_DESC])
     cDesc := alltrim(aQuery_[Q_DESC])
  endif

  cDesc := InputBox( 'Enter a brief description of this query'+":" , 'Query Description' , cDesc )
  if len(cDesc) == 0  // Rather than empty() because they may hit 'Ok' on
    Return(NIL)       // just spaces and that is acceptable.
  endif

  cpath  := _DBULastPath
  cQFile := PutFile( aMask, 'Save Query', cPath, .t. )

  If !Empty( cQFile )

  cQFile := cPath + "\" + cFileNoExt( cQFile ) + ".dbq"
  if !file(cQFile)
     Cr_QFile(cQFile)
  endif

  aQuery_[Q_FILE] := padr(cDBFile, 12)
  aQuery_[Q_DESC] := padr(cDesc, 80)
  aQuery_[Q_EXPR] := cExpr

  IF OpenDataBaseFile( cQFile, "QFile", .T., .F., RddSetDefault() )

    if QFile->( NotDBQ( cQFile ) )
      QFile->( DBCloseArea() )
      Return(NIL)
    endif

    QFile->( DBGoTop() )
    do while !QFile->( eof() )
      if QFile->FILENAME == aQuery_[Q_FILE]
        if QFile->DESC == aQuery_[Q_DESC]
		  x := MsgYesNo( 'A query with the same description was found for this database' + "." + CRLF + ;
                         'Do you wish to overwrite the existing query or append a new one?', 'Duplicate Query', , .f. )

          if x == 6
            lAppend := .F.
          elseif x == 2
            QFile->( DBCloseArea() )
            Return(NIL)
          endif
          exit
        endif
      endif
      QFile->( DBSkip() )
    enddo

    if lAppend
      QFile->( DBAppend() )
    endif

    QFile->FILENAME := aQuery_[Q_FILE]
    QFile->DESC     := aQuery_[Q_DESC]
    QFile->EXPR     := aQuery_[Q_EXPR]

    QFile->( DBCloseArea() )

    Sele &cBase

    MsgInfo('Query Saved')

  ENDIF

  Endif

Return(NIL)


Function LoadQuery(cExpr, aQuery_,cBase)
  //local cQFile := ""
  local lLoaded := .F., lCancel := .F.
  local aMask := { { "DataBase Queries (*.dbq)", "*.dbq" }, ;
                 { "All Files        (*.*)", "*.*"} }

  cpath := _DBULastPath
  cQFile := GetFile(aMask, 'Select a Query to Load', cPath, .f., .t.)

  if empty(cQFile)
    Return(lLoaded)
  endif

  IF OpenDataBaseFile( cQFile, "QFile", .T., .F., RddSetDefault() )

    if QFile->( NotDBQ( cQFile ) )
      QFile->( DBCloseArea() )
      Return(lLoaded)
    elseif QFile->( eof() )
      MsgInfo(cQFile + " " + 'does not contain any queries' + "!")
    else
	DEFINE WINDOW Form_Load ;
		AT 0, 0 WIDTH 484 HEIGHT 214 ;
		TITLE "Load Query" + cQFile ;
		ICON 'MAIN1' ;
		MODAL ;
		FONT "MS Sans Serif" ;
		SIZE 8

		DEFINE BROWSE Browse_1
			ROW 10
			COL 10
			WIDTH  Form_Load.Width  - 28   //GetProperty( 'Form_Load', 'Width' ) - 28
			HEIGHT Form_Load.Height - 78   //GetProperty( 'Form_Load', 'Height' ) - 78
			HEADERS { "X", 'Database', 'Description', 'Query Expression' }
			WIDTHS { 16, 86, 174, if(QFile->( Lastrec() ) > 8, 160, 176) }
			FIELDS { 'iif(QFile->( deleted() ), " X", "  ")', ;
                                  'QFile->FILENAME', ;
                                  'QFile->DESC', ;
                                  'QFile->EXPR' }
			WORKAREA QFile
			VALUE QFile->( Recno() )
			VSCROLLBAR QFile->( Lastrec() ) > 8
			READONLYFIELDS { .t., .t., .t., .t. }
			ONDBLCLICK Form_Load.Button_1.OnClick()
	        END BROWSE


		DEFINE BUTTON Button_1
	        ROW    GetProperty( 'Form_Load', 'Height' ) - 58
       	        COL    186
	        WIDTH  80
       	        HEIGHT 24
	        CAPTION "&Load"
       	        ACTION iif(LoadIt(aQuery_), Form_Load.Release, )
	        TABSTOP .T.
       	        VISIBLE .T.
		END BUTTON

		DEFINE BUTTON Button_2
	        ROW    GetProperty( 'Form_Load', 'Height' ) - 58
	        COL    286
       	        WIDTH  80
	        HEIGHT 24
       	        CAPTION "&Close"
	        ACTION (lCancel := .T., Form_Load.Release )
       	        TABSTOP .T.
	        VISIBLE .T.
		END BUTTON

		DEFINE BUTTON Button_3
	        ROW    GetProperty( 'Form_Load', 'Height' ) - 58
	        COL    386
       	        WIDTH  80
	        HEIGHT 24
       	        CAPTION '&Delete'
	        ACTION iif(QFile->( DelRec() ), ( Form_Load.Browse_1.Refresh, Form_Load.Browse_1.Setfocus ), )
       	        TABSTOP .T.
	        VISIBLE .T.
		END BUTTON

		ON KEY ESCAPE ACTION Form_Load.Button_2.OnClick

	END WINDOW

	CENTER WINDOW Form_Load

	ACTIVATE WINDOW Form_Load

      if !lCancel
        cExpr := aQuery_[Q_EXPR]
        Form_Query.Edit_1.Value := cExpr
        lLoaded := .T.
      endif

    endif

    QFile->( __DBPack() )
    QFile->( DBCloseArea() )

    sele &cBase

  ENDIF

Return(lLoaded)


Function NotDBQ( cQFile )
  local lNot := .F.

  if fieldpos("FILENAME") == 0 .or. ;
     fieldpos("DESC") == 0 .or. ;
     fieldpos("EXPR") == 0
    lNot := .T.
    MsgInfo(cQFile + " " + "is not a DataBase query file" + ".")
  endif

Return(lNot)


Function LoadIt(aQuery_)
  local lLoaded := .F.

  if QFile->FILENAME <> padr(cDBFile, 12)
    if MsgYesNo("The query's filename does not match that of the currently loaded file" + "." + CRLF + ;
		'Load it anyway?', 'Different Filename')
      lLoaded := .T.
    endif
  else
    lLoaded := .T.
  endif

  if lLoaded
    aQuery_[Q_FILE] := alltrim(QFile->FILENAME)
    aQuery_[Q_DESC] := alltrim(QFile->DESC)
    aQuery_[Q_EXPR] := alltrim(QFile->EXPR) + " "
  endif

Return(lLoaded)


Function DelRec()
  local lDel := .F.
  local cMsg, cTitle

  if deleted()
    cMsg := 'Are you sure you wish to recall this record?'
    cTitle := 'Recall'
  else
    cMsg := 'Are you sure you wish to delete this record?'
    cTitle := 'Delete'
  endif

  if MsgYesNo(cMsg, cTitle)
    if deleted()
      DBRecall()
    else
      DBDelete()
    endif
    lDel := .T.
  endif

Return(lDel)


Function QueryError(e)
  local cMsg := 'Syntax error in Query expression!'

  if valtype(e:description) == "C"
    cMsg := e:description
    cMsg += if(!empty(e:filename), ": " + e:filename, ;
            if(!empty(e:operation), ": " + e:operation, "" ))
  endif

  MsgInfo(cMsg)

Return break(e)

Procedure Cr_QFile(cQFile)
  local aArray_ := { { "FILENAME", "C",  12, 0 }, ;
			{ "DESC", "C",  80, 0 }, ;
			{ "EXPR", "C", 255, 0 } }

  DBCreate(cQFile, aArray_)

Return

Function InsDel(cOrig, nStart, nDelete, cInsert)
  local cLeft := left(cOrig, nStart - 1)
  local cRight := substr(cOrig, nStart + nDelete)

Return(cLeft + cInsert + cRight)

*--------------------------------------------------------*
FUNCTION OpenDataBaseFile( cDataBaseFileName, cAlias, lExclusive, lReadOnly, cDriverName, lNew )
*--------------------------------------------------------*
   Local _bLastHandler := ErrorBlock( {|o| Break(o)} ), _lGood := .T. /*, oError*/

   If PCount() < 6 .or. ValType(lNew) <> "L"
	lNew := .T.
   EndIf

   BEGIN SEQUENCE

	dbUseArea( lNew, cDriverName, cDataBaseFileName, cAlias, !lExclusive, lReadOnly )

   RECOVER //USING oError

	_lGood := .F.
	MsgInfo( "Unable to open file:" + CRLF + cDataBaseFileName )

   END

   ErrorBlock( _bLastHandler )

Return( _lGood )

