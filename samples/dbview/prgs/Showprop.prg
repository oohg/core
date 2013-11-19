/*
 * $Id: Showprop.prg,v 1.1 2013-11-19 19:15:41 migsoft Exp $
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
#include "hbcompat.ch"

*--------------------------------------------------------*
Procedure ShowProperties()
*--------------------------------------------------------*
   Local aNames := {}, cFilename, data_type := { "Character", "Numeric", "Date", "Logical", "Memo" , "General","Integer","TimeStamp","Time","Image","Binary","Money","Double" }
   DECLARE WINDOW oWndBase

   If !Empty( Alias() )
   declare window form_prop
   Aeval( (Alias())->( DBstruct() ), ;
        {|e,i| aadd(aNames, { Str(i, 4), e[1], data_type[ AT(e[2], "CNDLMGI@TPWYB") ], Ltrim(Str(e[3])), Ltrim(Str(e[4])) })} )

	DEFINE WINDOW Form_Prop ;
		AT 0, 0 WIDTH 490 HEIGHT 530  ;
		TITLE PROGRAM+VERSION+"- DBF Properties" ;
		ICON 'MAIN1' ;
		MODAL ;
		ON INIT Form_Prop.Grid_1.Setfocus ;
		NOMAXIMIZE;
		NOSIZE;
		FONT "MS Sans Serif" ;
		SIZE 8

    DEFINE FRAME Frame_1
        ROW    10
        COL    10
        WIDTH  460
        HEIGHT 100
        OPAQUE .T.
    END FRAME

    DEFINE LABEL Label_1
        ROW    25
        COL    20
        WIDTH  120
        HEIGHT 21
        VALUE "File:"
        VISIBLE .T.
        AUTOSIZE .F.
    END LABEL

    nPos := ( Alias() )->( Select( oWndBase.Tab_1.caption( oWndBase.Tab_1.value ) ) )

    TRY
        cFileName := iif(Empty(aFiles[nPos]),"",aFiles[nPos])
    CATCH loError
        cFileName := ""
    END

    DEFINE TEXTBOX Label_11
        ROW    25
        COL    80
        WIDTH  380
        HEIGHT 21
        TABSTOP .F.
        READONLY .T.
        VALUE  cFileName
        VISIBLE .T.
        AUTOSIZE .F.
    END TEXTBOX

    DEFINE LABEL Label_2
        ROW    45
        COL    20
        WIDTH  120
        HEIGHT 21
        VALUE "Size:"
        VISIBLE .T.
        AUTOSIZE .F.
    END LABEL

    DEFINE TEXTBOX Label_22
        ROW    45
        COL    80
        WIDTH  380
        HEIGHT 21
        TABSTOP .F.
        READONLY .T.
        VALUE ALLTRIM(Ltrim(Str(FileSize(aFiles[nPos])))) + " " + "Byte(s)"
        VISIBLE .T.
        AUTOSIZE .F.
    END TEXTBOX

    DEFINE LABEL Label_3
        ROW    65
        COL    20
        WIDTH  120
        HEIGHT 21
        VALUE "Created:"
        VISIBLE .T.
        AUTOSIZE .F.
    END LABEL

    DEFINE TEXTBOX Label_33
        ROW    65
        COL    80
        WIDTH  380
        HEIGHT 21
        TABSTOP .F.
        READONLY .T.
        VALUE DtoC( (Alias())->( LupDate() ) )
        VISIBLE .T.
        AUTOSIZE .F.
    END TEXTBOX

    DEFINE LABEL Label_4
        ROW    85
        COL    20
        WIDTH  120
        HEIGHT 21
        VALUE "Modified:"
        VISIBLE .T.
        AUTOSIZE .F.
    END LABEL

    DEFINE TEXTBOX Label_44
        ROW    85
        COL    80
        WIDTH  380
        HEIGHT 21
        TABSTOP .F.
        READONLY .T.
        VALUE DtoC(FileDate(aFiles[nPos])) + "  " + FileTime(aFiles[nPos])
        VISIBLE .T.
        AUTOSIZE .F.
    END TEXTBOX

    DEFINE FRAME Frame_2
        ROW    110
        COL    10
        WIDTH  460
        HEIGHT 100
        OPAQUE .T.
    END FRAME

    DEFINE LABEL Label_5
        ROW    125
        COL    20
        WIDTH  120
        HEIGHT 21
        VALUE "Number of Records:"
        VISIBLE .T.
        AUTOSIZE .F.
    END LABEL

    DEFINE TEXTBOX Label_55
        ROW    125
        COL    160
        WIDTH  300
        HEIGHT 21
        TABSTOP .F.
        READONLY .T.
        VALUE Ltrim(Str((Alias())->( LastRec() )))
        VISIBLE .T.
        AUTOSIZE .F.
        NUMERIC  .T.
        RIGHTALIGN .T.        
    END TEXTBOX

    DEFINE LABEL Label_6
        ROW    145
        COL    20
        WIDTH  120
        HEIGHT 21
        VALUE "Header Size:"
        VISIBLE .T.
        AUTOSIZE .F.
    END LABEL

    DEFINE TEXTBOX Label_66
        ROW    145
        COL    160
        WIDTH  300
        HEIGHT 21
        TABSTOP .F.
        READONLY .T.
        VALUE Ltrim(Str((Alias())->( Header() )))
        VISIBLE .T.
        AUTOSIZE .F.
        NUMERIC  .T.
        RIGHTALIGN .T.
    END TEXTBOX

    DEFINE LABEL Label_7
        ROW    165
        COL    20
        WIDTH  120
        HEIGHT 21
        VALUE "Record Size:"
        VISIBLE .T.
        AUTOSIZE .F.
    END LABEL

    DEFINE TEXTBOX Label_77
        ROW    165
        COL    160
        WIDTH  300
        HEIGHT 21
        TABSTOP .F.
        READONLY .T.
        VALUE Ltrim(Str((Alias())->( RecSize() )))
        VISIBLE .T.
        AUTOSIZE .F.
        NUMERIC  .T.
        RIGHTALIGN .T.
    END TEXTBOX

    DEFINE LABEL Label_8
        ROW    185
        COL    20
        WIDTH  120
        HEIGHT 21
        VALUE "Number of Fields:"
        VISIBLE .T.
        AUTOSIZE .F.
    END LABEL

    DEFINE TEXTBOX Label_88
        ROW    185
        COL    160
        WIDTH  300
        HEIGHT 21
        TABSTOP .F.
        READONLY .T.
        VALUE Ltrim(Str((Alias())->( Fcount() )))
        VISIBLE .T.
        AUTOSIZE .F.
        NUMERIC  .T.
        RIGHTALIGN .T.
    END TEXTBOX

    DEFINE GRID Grid_1
        ROW    220
        COL    10
        WIDTH  460
        HEIGHT 240
        ITEMS aNames
        VALUE 0
        WIDTHS { 30, 220, 80, 50, 50 }
        HEADERS {' #', ' Name', 'Type', ' Len', ' Dec'}
        NOLINES .T.
        JUSTIFY { BROWSE_JTFY_LEFT, BROWSE_JTFY_LEFT, BROWSE_JTFY_LEFT, BROWSE_JTFY_RIGHT, BROWSE_JTFY_RIGHT }
    END GRID

    DEFINE BUTTON Button_1
        ROW    470
        COL    390
        WIDTH  80
        HEIGHT 24
        CAPTION "Close"
        ACTION ( ThisWindow.Release )
        TABSTOP .T.
        VISIBLE .T.
        PICTURE "down1"
    END BUTTON

        ON KEY ESCAPE ACTION Form_Prop.Button_1.OnClick

	END WINDOW

	CENTER WINDOW Form_Prop
	ACTIVATE WINDOW Form_Prop

   Endif
Return
