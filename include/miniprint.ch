/*
 * $Id: miniprint.ch,v 1.1 2005-08-06 23:53:55 guerra000 Exp $
 */

/*----------------------------------------------------------------------------
 MINIPRINT - HARBOUR MINIGUI PRINT LIBRARY

 Copyright 2004-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/
---------------------------------------------------------------------------*/
MEMVAR _HMG_PRINTER_HDC
MEMVAR _HMG_PRINTER_PREVIEW
MEMVAR _HMG_PRINTER_HTML_OUT
MEMVAR _HMG_PRINTER_HTNL_OUT
MEMVAR _HMG_PRINTER_NAME
MEMVAR _HMG_PRINTER_TIMESTAMP
MEMVAR _HMG_PRINTER_PAGECOUNT
MEMVAR _HMG_PRINTER_HDC_BAK
MEMVAR _HMG_PRINTER_COPIES
MEMVAR _HMG_PRINTER_COLLATE
MEMVAR _HMG_PRINTER_APRINTERPROPERTIES

* Select Html Printer

#xcommand SELECT PRINTER HTML <cBaseName> ;
=> ;
_hmg_printer_select_html_printer ( <cBaseName> ) ;;
_hmg_printer_preview := .f.

* Select Printer <cPrinter> [ TO <lSelect> ]

#xcommand SELECT PRINTER <cPrinter> ;
	[ <lOrientation 	: ORIENTATION>		<nOrientation> ] ;
	[ <lPaperSize		: PAPERSIZE>		<nPaperSize> ] ;
	[ <lPaperLength 	: PAPERLENGTH>		<nPaperLength> ] ;
	[ <lPaperWidth		: PAPERWIDTH>		<nPaperWidth> ] ;
	[ <lCopies		: COPIES>		<nCopies> ] ;
	[ <lDefaultSource	: DEFAULTSOURCE>	<nDefaultSource> ] ;
	[ <lQuality		: QUALITY>		<nQuality> ] ;
	[ <lColor		: COLOR>		<nColor> ] ;
	[ <lDuplex		: DUPLEX>		<nDuplex> ] ;
	[ <lCollate		: COLLATE>		<nCollate> ] ;
	[ <Preview 		: PREVIEW> ] ;
=> ;
	_hmg_printer_aPrinterProperties := _HMG_PRINTER_SetPrinterProperties ( ;
		<cPrinter> , ;
		if ( <.lOrientation.>	, <nOrientation>	, -999 ) , ;
		if ( <.lPaperSize.>	, <nPaperSize>		, -999 ) , ;
		if ( <.lPaperLength.>	, <nPaperLength>	, -999 ) , ;
		if ( <.lPaperWidth.>	, <nPaperWidth>		, -999 ) , ;
		if ( <.lCopies.>	, <nCopies>		, -999 ) , ;
		if ( <.lDefaultSource.>	, <nDefaultSource>	, -999 ) , ;
		if ( <.lQuality.>	, <nQuality>		, -999 ) , ;
		if ( <.lColor.>		, <nColor>		, -999 ) , ;
		if ( <.lDuplex.>	, <nDuplex>		, -999 ) , ;
		if ( <.lCollate.>	, <nCollate>		, -999 ) ;
	) ;;
	_hmg_printer_hdc := _hmg_printer_aPrinterProperties \[1\] ;;
	_hmg_printer_copies := _hmg_printer_aPrinterProperties \[3\] ;;
	_hmg_printer_collate := _hmg_printer_aPrinterProperties \[4\] ;;
	_hmg_printer_preview := <.Preview.> ;;
	_hmg_printer_InitUserMessages() ;;
	_hmg_printer_timestamp := strzero( Seconds() * 100 , 8 ) ;;
	_hmg_printer_name := <cPrinter>	;;
	__mvpublic ( '_hmg_printer_htnl_out' ) ;;
	_hmg_printer_htnl_out := .f.

#xcommand SELECT PRINTER <cPrinter> TO <lSuccess> ;
	[ <lOrientation 	: ORIENTATION>		<nOrientation> ] ;
	[ <lPaperSize		: PAPERSIZE>		<nPaperSize> ] ;
	[ <lPaperLength 	: PAPERLENGTH>		<nPaperLength> ] ;
	[ <lPaperWidth		: PAPERWIDTH>		<nPaperWidth> ] ;
	[ <lCopies		: COPIES>		<nCopies> ] ;
	[ <lDefaultSource	: DEFAULTSOURCE>	<nDefaultSource> ] ;
	[ <lQuality		: QUALITY>		<nQuality> ] ;
	[ <lColor		: COLOR>		<nColor> ] ;
	[ <lDuplex		: DUPLEX>		<nDuplex> ] ;
	[ <lCollate		: COLLATE>		<nCollate> ] ;
	[ <Preview 		: PREVIEW> ] ;
=> ;
	_hmg_printer_aPrinterProperties := _HMG_PRINTER_SetPrinterProperties ( ;
		<cPrinter> , ;
		if ( <.lOrientation.>	, <nOrientation>	, -999 ) , ;
		if ( <.lPaperSize.>	, <nPaperSize>		, -999 ) , ;
		if ( <.lPaperLength.>	, <nPaperLength>	, -999 ) , ;
		if ( <.lPaperWidth.>	, <nPaperWidth>		, -999 ) , ;
		if ( <.lCopies.>	, <nCopies>		, -999 ) , ;
		if ( <.lDefaultSource.>	, <nDefaultSource>	, -999 ) , ;
		if ( <.lQuality.>	, <nQuality>		, -999 ) , ;
		if ( <.lColor.>		, <nColor>		, -999 ) , ;
		if ( <.lDuplex.>	, <nDuplex>		, -999 ) , ;
		if ( <.lCollate.>	, <nCollate>		, -999 ) ;
	) ;;
	_hmg_printer_hdc := _hmg_printer_aPrinterProperties \[1\] ;;
	_hmg_printer_copies := _hmg_printer_aPrinterProperties \[3\] ;;
	_hmg_printer_collate := _hmg_printer_aPrinterProperties \[4\] ;;
	<lSuccess> := if ( _hmg_printer_hdc <> 0 , .T. , .F. ) ;;
	_hmg_printer_preview := <.Preview.> ;;
	_hmg_printer_InitUserMessages() ;;
	_hmg_printer_timestamp := strzero( Seconds() * 100 , 8 ) ;;
	_hmg_printer_name := <cPrinter>	;;
	__mvpublic ( '_hmg_printer_htnl_out' ) ;;
	_hmg_printer_htnl_out := .f.

#xcommand SELECT PRINTER DEFAULT ;
	[ <lOrientation 	: ORIENTATION>		<nOrientation> ] ;
	[ <lPaperSize		: PAPERSIZE>		<nPaperSize> ] ;
	[ <lPaperLength 	: PAPERLENGTH>		<nPaperLength> ] ;
	[ <lPaperWidth		: PAPERWIDTH>		<nPaperWidth> ] ;
	[ <lCopies		: COPIES>		<nCopies> ] ;
	[ <lDefaultSource	: DEFAULTSOURCE>	<nDefaultSource> ] ;
	[ <lQuality		: QUALITY>		<nQuality> ] ;
	[ <lColor		: COLOR>		<nColor> ] ;
	[ <lDuplex		: DUPLEX>		<nDuplex> ] ;
	[ <lCollate		: COLLATE>		<nCollate> ] ;
	[ <Preview 		: PREVIEW> ] ;
=> ;
	_hmg_printer_name := GetDefaultPrinter() ;;
	_hmg_printer_aPrinterProperties := _HMG_PRINTER_SetPrinterProperties ( ;
		_hmg_printer_name , ;
		if ( <.lOrientation.>	, <nOrientation>	, -999 ) , ;
		if ( <.lPaperSize.>	, <nPaperSize>		, -999 ) , ;
		if ( <.lPaperLength.>	, <nPaperLength>	, -999 ) , ;
		if ( <.lPaperWidth.>	, <nPaperWidth>		, -999 ) , ;
		if ( <.lCopies.>	, <nCopies>		, -999 ) , ;
		if ( <.lDefaultSource.>	, <nDefaultSource>	, -999 ) , ;
		if ( <.lQuality.>	, <nQuality>		, -999 ) , ;
		if ( <.lColor.>		, <nColor>		, -999 ) , ;
		if ( <.lDuplex.>	, <nDuplex>		, -999 ) , ;
		if ( <.lCollate.>	, <nCollate>		, -999 ) ;
	) ;;
	_hmg_printer_hdc := _hmg_printer_aPrinterProperties \[1\] ;;
	_hmg_printer_copies := _hmg_printer_aPrinterProperties \[3\] ;;
	_hmg_printer_collate := _hmg_printer_aPrinterProperties \[4\] ;;
	_hmg_printer_preview := <.Preview.> ;;
	_hmg_printer_InitUserMessages() ;;
	_hmg_printer_timestamp := strzero( Seconds() * 100 , 8 ) ;;
	__mvpublic ( '_hmg_printer_htnl_out' ) ;;
	_hmg_printer_htnl_out := .f. 

#xcommand SELECT PRINTER DEFAULT TO <lSuccess> ;
	[ <lOrientation 	: ORIENTATION>		<nOrientation> ] ;
	[ <lPaperSize		: PAPERSIZE>		<nPaperSize> ] ;
	[ <lPaperLength 	: PAPERLENGTH>		<nPaperLength> ] ;
	[ <lPaperWidth		: PAPERWIDTH>		<nPaperWidth> ] ;
	[ <lCopies		: COPIES>		<nCopies> ] ;
	[ <lDefaultSource	: DEFAULTSOURCE>	<nDefaultSource> ] ;
	[ <lQuality		: QUALITY>		<nQuality> ] ;
	[ <lColor		: COLOR>		<nColor> ] ;
	[ <lDuplex		: DUPLEX>		<nDuplex> ] ;
	[ <lCollate		: COLLATE>		<nCollate> ] ;
	[ <Preview 		: PREVIEW> ] ;
=> ;
	_hmg_printer_name := GetDefaultPrinter() ;;
	_hmg_printer_aPrinterProperties := _HMG_PRINTER_SetPrinterProperties ( ;
		_hmg_printer_name , ;
		if ( <.lOrientation.>	, <nOrientation>	, -999 ) , ;
		if ( <.lPaperSize.>	, <nPaperSize>		, -999 ) , ;
		if ( <.lPaperLength.>	, <nPaperLength>	, -999 ) , ;
		if ( <.lPaperWidth.>	, <nPaperWidth>		, -999 ) , ;
		if ( <.lCopies.>	, <nCopies>		, -999 ) , ;
		if ( <.lDefaultSource.>	, <nDefaultSource>	, -999 ) , ;
		if ( <.lQuality.>	, <nQuality>		, -999 ) , ;
		if ( <.lColor.>		, <nColor>		, -999 ) , ;
		if ( <.lDuplex.>	, <nDuplex>		, -999 ) , ;
		if ( <.lCollate.>	, <nCollate>		, -999 ) ;
	) ;;
	_hmg_printer_hdc := _hmg_printer_aPrinterProperties \[1\] ;;
	_hmg_printer_copies := _hmg_printer_aPrinterProperties \[3\] ;;
	_hmg_printer_collate := _hmg_printer_aPrinterProperties \[4\] ;;
	<lSuccess> := if ( _hmg_printer_hdc <> 0 , .T. , .F. ) ;;
	_hmg_printer_preview := <.Preview.> ;;
	_hmg_printer_InitUserMessages() ;;
	_hmg_printer_timestamp := strzero( Seconds() * 100 , 8 ) ;;
	__mvpublic ( '_hmg_printer_htnl_out' ) ;;
	_hmg_printer_htnl_out := .f. 

#xcommand SELECT PRINTER DIALOG ;
	[ <Preview : PREVIEW> ] ;
=> ;
_hmg_printer_aPrinterProperties	= _HMG_PRINTER_PrintDialog()	;;
_hmg_printer_hdc := _hmg_printer_aPrinterProperties \[1\]		;;
_hmg_printer_name := _hmg_printer_aPrinterProperties \[2\]	;;
_hmg_printer_copies := _hmg_printer_aPrinterProperties \[3\] ;;
_hmg_printer_collate := _hmg_printer_aPrinterProperties \[4\] ;;
_hmg_printer_preview := <.Preview.>				;;
_hmg_printer_InitUserMessages()					;;
_hmg_printer_timestamp := strzero( Seconds() * 100 , 8 ) ;;
__mvpublic ( '_hmg_printer_htnl_out' ) ;;
_hmg_printer_htnl_out := .f. 

#xcommand SELECT PRINTER DIALOG TO <lSuccess> ;
	[ <Preview : PREVIEW> ] ;
=> ;
_hmg_printer_aPrinterProperties	= _HMG_PRINTER_PrintDialog()	;;
_hmg_printer_hdc := _hmg_printer_aPrinterProperties \[1\]		;;
_hmg_printer_name := _hmg_printer_aPrinterProperties \[2\]	;;
_hmg_printer_copies := _hmg_printer_aPrinterProperties \[3\] ;;
_hmg_printer_collate := _hmg_printer_aPrinterProperties \[4\] ;;
<lSuccess> := if ( _hmg_printer_hdc <> 0 , .T. , .F. ) ;;
_hmg_printer_preview := <.Preview.> ;;
_hmg_printer_InitUserMessages() ;;
_hmg_printer_timestamp := strzero( Seconds() * 100 , 8 ) ;;
__mvpublic ( '_hmg_printer_htnl_out' ) ;;
_hmg_printer_htnl_out := .f. 

#xcommand START PRINTDOC ;
=> ;
if ( _hmg_printer_htnl_out == .f. , if ( _hmg_printer_preview , ( _hmg_printer_PageCount := 0 , _hmg_printer_hdc_bak := _hmg_printer_hdc ) ,  _HMG_PRINTER_StartDoc ( _hmg_printer_hdc ) ) , Nil )

#xcommand START PRINTPAGE ;
=> ;
if ( _hmg_printer_htnl_out == .f. , if ( _hmg_printer_preview , ( _hmg_printer_hdc := _HMG_PRINTER_STARTPAGE_PREVIEW ( _hmg_printer_hdc_bak , GetTempFolder() + _hmg_printer_timestamp + "_hmg_print_preview_" +  alltrim(strzero(++_hmg_printer_PageCount,4)) + ".Emf" ) ) , _HMG_PRINTER_StartPage ( _hmg_printer_hdc ) ) , _hmg_printer_html_start_printpage() )

#xcommand END PRINTPAGE ;
=> ;
if ( _hmg_printer_htnl_out == .f. , if ( _hmg_printer_preview , _HMG_PRINTER_ENDPAGE_PREVIEW (_hmg_printer_hdc) , _HMG_PRINTER_EndPage ( _hmg_printer_hdc ) ) , _hmg_printer_html_end_printpage() )

#xcommand END PRINTDOC ;
=> ;
if ( _hmg_printer_htnl_out == .f. , if ( _hmg_printer_preview , _HMG_PRINTER_SHOWPREVIEW() , _HMG_PRINTER_EndDoc ( _hmg_printer_hdc ) ) , Nil )

#xcommand ABORT PRINTDOC ;
=> ;
_HMG_PRINTER_ABORTDOC ( _hmg_printer_hdc )

#xcommand @ <Row> , <Col> PRINT [ DATA ] <cText> ;
	[ <lfont : FONT> <cFontName> ] ;
	[ <lsize : SIZE> <nFontSize> ] ;
	[ <bold : BOLD> ] ;
	[ <italic : ITALIC> ] ;
	[ <underline : UNDERLINE> ] ;
	[ <strikeout : STRIKEOUT> ] ;
	[ <lcolor : COLOR> <aColor> ] ;
	=> ;
	if ( _hmg_printer_htnl_out == .f. , _HMG_PRINTER_H_PRINT ( _hmg_printer_hdc , <Row> , <Col> , <cFontName> , <nFontSize> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] , <cText> , <.bold.> , <.italic.> , <.underline.> , <.strikeout.> , <.lcolor.> , <.lfont.> , <.lsize.> ) , _hmg_printer_html_printdata ( <cText> , <Row> , <Col> , <cFontName> , <nFontSize> , <.bold.> , <.italic.> , <.underline.> , <.strikeout.> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] ) )

#xcommand @ <Row> , <Col> PRINT [ DATA ] <cText> ;
	TO <ToRow> , <ToCol> ;
	[ <lfont : FONT> <cFontName> ] ;
	[ <lsize : SIZE> <nFontSize> ] ;
	[ <bold : BOLD> ] ;
	[ <italic : ITALIC> ] ;
	[ <underline : UNDERLINE> ] ;
	[ <strikeout : STRIKEOUT> ] ;
	[ <lcolor : COLOR> <aColor> ] ;
	=> ;
	if ( _hmg_printer_htnl_out == .f. , _HMG_PRINTER_H_MULTILINE_PRINT ( _hmg_printer_hdc , <Row> , <Col> , <ToRow> , <ToCol> , <cFontName> , <nFontSize> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] , <cText> , <.bold.> , <.italic.> , <.underline.> , <.strikeout.> , <.lcolor.> , <.lfont.> , <.lsize.> ) , _hmg_printer_html_printdata ( <cText> , <Row> , <Col> , <cFontName> , <nFontSize> , <.bold.> , <.italic.> , <.underline.> , <.strikeout.> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] ) )

#xcommand @ <nRow> , <nCol> PRINT IMAGE <cImage> ;
	WIDTH <nWidth> ;
	HEIGHT <nheight> ;
	[ <stretch : STRETCH> ] ;
	=> ;
	if ( _hmg_printer_htnl_out == .f. , _HMG_PRINTER_H_IMAGE ( _hmg_printer_hdc , <cImage> , <nRow> , <nCol> , <nheight> , <nWidth> , <.stretch.> ) , _hmg_printer_html_printimage ( <nRow> , <nCol> , <nWidth> , <nheight> , <cImage> , <.stretch.> ) )

#xcommand @ <Row> , <Col> PRINT LINE TO <ToRow> , <ToCol> ;
	[ <lwidth : PENWIDTH> <Width> ] ;
	[ <lcolor : COLOR> <aColor> ] ;
	=> ;
	if ( _hmg_printer_htnl_out == .f. , _HMG_PRINTER_H_LINE ( _hmg_printer_hdc , <Row> , <Col> , <ToRow> , <ToCol> , <Width> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\]  , <.lwidth.> , <.lcolor.> ) , _hmg_printer_html_printline ( <Row> , <Col> , <ToCol> - <Col> , <Width> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] ) )

#xcommand @ <Row> , <Col> PRINT RECTANGLE TO <ToRow> , <ToCol> ;
	[ <lwidth : PENWIDTH> <Width> ] ;
	[ <lcolor : COLOR> <aColor> ] ;
	=> ;
	if ( _hmg_printer_htnl_out == .f. , _HMG_PRINTER_H_RECTANGLE ( _hmg_printer_hdc , <Row> , <Col> , <ToRow> , <ToCol> , <Width> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] , <.lwidth.> , <.lcolor.> ) , _hmg_printer_html_printrectangle ( <Row> , <Col> , <ToCol> - <Col>, <ToRow> - <Row> , <Width> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] ) )

#xcommand @ <Row> , <Col> PRINT RECTANGLE TO <ToRow> , <ToCol> ;
	[ <lwidth : PENWIDTH> <Width> ] ;
	[ <lcolor : COLOR> <aColor> ] ;
	ROUNDED ;
	=> ;
	if ( _hmg_printer_htnl_out == .f. , _HMG_PRINTER_H_ROUNDRECTANGLE ( _hmg_printer_hdc , <Row> , <Col> , <ToRow> , <ToCol> , <Width> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] , <.lwidth.> , <.lcolor.> ) , _hmg_printer_html_printrectangle ( <Row> , <Col> , <ToCol> - <Col>, <ToRow> - <Row> , <Width> , <aColor>\[1\] , <aColor>\[2\] , <aColor>\[3\] ) )

///////////////////////////////////////////////////////////////////////////////
// PRINTER CONFIGURATION CONSTANTS
///////////////////////////////////////////////////////////////////////////////

* Collate

#define PRINTER_COLLATE_TRUE	1
#define PRINTER_COLLATE_FALSE	0

* Source

#define PRINTER_BIN_FIRST         DMBIN_UPPER
#define PRINTER_BIN_UPPER         1
#define PRINTER_BIN_ONLYONE       1
#define PRINTER_BIN_LOWER         2
#define PRINTER_BIN_MIDDLE        3
#define PRINTER_BIN_MANUAL        4
#define PRINTER_BIN_ENVELOPE      5
#define PRINTER_BIN_ENVMANUAL     6
#define PRINTER_BIN_AUTO          7
#define PRINTER_BIN_TRACTOR       8
#define PRINTER_BIN_SMALLFMT      9
#define PRINTER_BIN_LARGEFMT      10
#define PRINTER_BIN_LARGECAPACITY 11
#define PRINTER_BIN_CASSETTE      14
#define PRINTER_BIN_FORMSOURCE    15
#define PRINTER_BIN_LAST          DMBIN_FORMSOURCE
#define PRINTER_BIN_USER          256    

* Orientation

#define PRINTER_ORIENT_PORTRAIT   1
#define PRINTER_ORIENT_LANDSCAPE  2

* Color 

#define PRINTER_COLOR_MONOCHROME  1
#define PRINTER_COLOR_COLOR       2

* Quality

#define PRINTER_RES_DRAFT         (-1)
#define PRINTER_RES_LOW           (-2)
#define PRINTER_RES_MEDIUM        (-3)
#define PRINTER_RES_HIGH          (-4)

* Duplex

#define PRINTER_DUP_SIMPLEX    1
#define PRINTER_DUP_VERTICAL   2
#define PRINTER_DUP_HORIZONTAL 3

* Paper Size

#define PRINTER_PAPER_FIRST                DMPAPER_LETTER
#define PRINTER_PAPER_LETTER               1  /* Letter 8 1/2 x 11 in               */
#define PRINTER_PAPER_LETTERSMALL          2  /* Letter Small 8 1/2 x 11 in         */
#define PRINTER_PAPER_TABLOID              3  /* Tabloid 11 x 17 in                 */
#define PRINTER_PAPER_LEDGER               4  /* Ledger 17 x 11 in                  */
#define PRINTER_PAPER_LEGAL                5  /* Legal 8 1/2 x 14 in                */
#define PRINTER_PAPER_STATEMENT            6  /* Statement 5 1/2 x 8 1/2 in         */
#define PRINTER_PAPER_EXECUTIVE            7  /* Executive 7 1/4 x 10 1/2 in        */
#define PRINTER_PAPER_A3                   8  /* A3 297 x 420 mm                    */
#define PRINTER_PAPER_A4                   9  /* A4 210 x 297 mm                    */
#define PRINTER_PAPER_A4SMALL             10  /* A4 Small 210 x 297 mm              */
#define PRINTER_PAPER_A5                  11  /* A5 148 x 210 mm                    */
#define PRINTER_PAPER_B4                  12  /* B4 (JIS) 250 x 354                 */
#define PRINTER_PAPER_B5                  13  /* B5 (JIS) 182 x 257 mm              */
#define PRINTER_PAPER_FOLIO               14  /* Folio 8 1/2 x 13 in                */
#define PRINTER_PAPER_QUARTO              15  /* Quarto 215 x 275 mm                */
#define PRINTER_PAPER_10X14               16  /* 10x14 in                           */
#define PRINTER_PAPER_11X17               17  /* 11x17 in                           */
#define PRINTER_PAPER_NOTE                18  /* Note 8 1/2 x 11 in                 */
#define PRINTER_PAPER_ENV_9               19  /* Envelope #9 3 7/8 x 8 7/8          */
#define PRINTER_PAPER_ENV_10              20  /* Envelope #10 4 1/8 x 9 1/2         */
#define PRINTER_PAPER_ENV_11              21  /* Envelope #11 4 1/2 x 10 3/8        */
#define PRINTER_PAPER_ENV_12              22  /* Envelope #12 4 \276 x 11           */
#define PRINTER_PAPER_ENV_14              23  /* Envelope #14 5 x 11 1/2            */
#define PRINTER_PAPER_CSHEET              24  /* C size sheet                       */
#define PRINTER_PAPER_DSHEET              25  /* D size sheet                       */
#define PRINTER_PAPER_ESHEET              26  /* E size sheet                       */
#define PRINTER_PAPER_ENV_DL              27  /* Envelope DL 110 x 220mm            */
#define PRINTER_PAPER_ENV_C5              28  /* Envelope C5 162 x 229 mm           */
#define PRINTER_PAPER_ENV_C3              29  /* Envelope C3  324 x 458 mm          */
#define PRINTER_PAPER_ENV_C4              30  /* Envelope C4  229 x 324 mm          */
#define PRINTER_PAPER_ENV_C6              31  /* Envelope C6  114 x 162 mm          */
#define PRINTER_PAPER_ENV_C65             32  /* Envelope C65 114 x 229 mm          */
#define PRINTER_PAPER_ENV_B4              33  /* Envelope B4  250 x 353 mm          */
#define PRINTER_PAPER_ENV_B5              34  /* Envelope B5  176 x 250 mm          */
#define PRINTER_PAPER_ENV_B6              35  /* Envelope B6  176 x 125 mm          */
#define PRINTER_PAPER_ENV_ITALY           36  /* Envelope 110 x 230 mm              */
#define PRINTER_PAPER_ENV_MONARCH         37  /* Envelope Monarch 3.875 x 7.5 in    */
#define PRINTER_PAPER_ENV_PERSONAL        38  /* 6 3/4 Envelope 3 5/8 x 6 1/2 in    */
#define PRINTER_PAPER_FANFOLD_US          39  /* US Std Fanfold 14 7/8 x 11 in      */
#define PRINTER_PAPER_FANFOLD_STD_GERMAN  40  /* German Std Fanfold 8 1/2 x 12 in   */
#define PRINTER_PAPER_FANFOLD_LGL_GERMAN  41  /* German Legal Fanfold 8 1/2 x 13 in */
#define PRINTER_PAPER_ISO_B4              42  /* B4 (ISO) 250 x 353 mm              */
#define PRINTER_PAPER_JAPANESE_POSTCARD   43  /* Japanese Postcard 100 x 148 mm     */
#define PRINTER_PAPER_9X11                44  /* 9 x 11 in                          */
#define PRINTER_PAPER_10X11               45  /* 10 x 11 in                         */
#define PRINTER_PAPER_15X11               46  /* 15 x 11 in                         */
#define PRINTER_PAPER_ENV_INVITE          47  /* Envelope Invite 220 x 220 mm       */
#define PRINTER_PAPER_RESERVED_48         48  /* RESERVED--DO NOT USE               */
#define PRINTER_PAPER_RESERVED_49         49  /* RESERVED--DO NOT USE               */
#define PRINTER_PAPER_LETTER_EXTRA        50  /* Letter Extra 9 \275 x 12 in        */
#define PRINTER_PAPER_LEGAL_EXTRA         51  /* Legal Extra 9 \275 x 15 in         */
#define PRINTER_PAPER_TABLOID_EXTRA       52  /* Tabloid Extra 11.69 x 18 in        */
#define PRINTER_PAPER_A4_EXTRA            53  /* A4 Extra 9.27 x 12.69 in           */
#define PRINTER_PAPER_LETTER_TRANSVERSE   54  /* Letter Transverse 8 \275 x 11 in   */
#define PRINTER_PAPER_A4_TRANSVERSE       55  /* A4 Transverse 210 x 297 mm         */
#define PRINTER_PAPER_LETTER_EXTRA_TRANSVERSE 56 /* Letter Extra Transverse 9\275 x 12 in */
#define PRINTER_PAPER_A_PLUS              57  /* SuperA/SuperA/A4 227 x 356 mm      */
#define PRINTER_PAPER_B_PLUS              58  /* SuperB/SuperB/A3 305 x 487 mm      */
#define PRINTER_PAPER_LETTER_PLUS         59  /* Letter Plus 8.5 x 12.69 in         */
#define PRINTER_PAPER_A4_PLUS             60  /* A4 Plus 210 x 330 mm               */
#define PRINTER_PAPER_A5_TRANSVERSE       61  /* A5 Transverse 148 x 210 mm         */
#define PRINTER_PAPER_B5_TRANSVERSE       62  /* B5 (JIS) Transverse 182 x 257 mm   */
#define PRINTER_PAPER_A3_EXTRA            63  /* A3 Extra 322 x 445 mm              */
#define PRINTER_PAPER_A5_EXTRA            64  /* A5 Extra 174 x 235 mm              */
#define PRINTER_PAPER_B5_EXTRA            65  /* B5 (ISO) Extra 201 x 276 mm        */
#define PRINTER_PAPER_A2                  66  /* A2 420 x 594 mm                    */
#define PRINTER_PAPER_A3_TRANSVERSE       67  /* A3 Transverse 297 x 420 mm         */
#define PRINTER_PAPER_A3_EXTRA_TRANSVERSE 68  /* A3 Extra Transverse 322 x 445 mm   */
#define PRINTER_PAPER_DBL_JAPANESE_POSTCARD 69 /* Japanese Double Postcard 200 x 148 mm */
#define PRINTER_PAPER_A6                  70  /* A6 105 x 148 mm                 */
#define PRINTER_PAPER_JENV_KAKU2          71  /* Japanese Envelope Kaku #2       */
#define PRINTER_PAPER_JENV_KAKU3          72  /* Japanese Envelope Kaku #3       */
#define PRINTER_PAPER_JENV_CHOU3          73  /* Japanese Envelope Chou #3       */
#define PRINTER_PAPER_JENV_CHOU4          74  /* Japanese Envelope Chou #4       */
#define PRINTER_PAPER_LETTER_ROTATED      75  /* Letter Rotated 11 x 8 1/2 11 in */
#define PRINTER_PAPER_A3_ROTATED          76  /* A3 Rotated 420 x 297 mm         */
#define PRINTER_PAPER_A4_ROTATED          77  /* A4 Rotated 297 x 210 mm         */
#define PRINTER_PAPER_A5_ROTATED          78  /* A5 Rotated 210 x 148 mm         */
#define PRINTER_PAPER_B4_JIS_ROTATED      79  /* B4 (JIS) Rotated 364 x 257 mm   */
#define PRINTER_PAPER_B5_JIS_ROTATED      80  /* B5 (JIS) Rotated 257 x 182 mm   */
#define PRINTER_PAPER_JAPANESE_POSTCARD_ROTATED 81 /* Japanese Postcard Rotated 148 x 100 mm */
#define PRINTER_PAPER_DBL_JAPANESE_POSTCARD_ROTATED 82 /* Double Japanese Postcard Rotated 148 x 200 mm */
#define PRINTER_PAPER_A6_ROTATED          83  /* A6 Rotated 148 x 105 mm         */
#define PRINTER_PAPER_JENV_KAKU2_ROTATED  84  /* Japanese Envelope Kaku #2 Rotated */
#define PRINTER_PAPER_JENV_KAKU3_ROTATED  85  /* Japanese Envelope Kaku #3 Rotated */
#define PRINTER_PAPER_JENV_CHOU3_ROTATED  86  /* Japanese Envelope Chou #3 Rotated */
#define PRINTER_PAPER_JENV_CHOU4_ROTATED  87  /* Japanese Envelope Chou #4 Rotated */
#define PRINTER_PAPER_B6_JIS              88  /* B6 (JIS) 128 x 182 mm           */
#define PRINTER_PAPER_B6_JIS_ROTATED      89  /* B6 (JIS) Rotated 182 x 128 mm   */
#define PRINTER_PAPER_12X11               90  /* 12 x 11 in                      */
#define PRINTER_PAPER_JENV_YOU4           91  /* Japanese Envelope You #4        */
#define PRINTER_PAPER_JENV_YOU4_ROTATED   92  /* Japanese Envelope You #4 Rotated*/
#define PRINTER_PAPER_P16K                93  /* PRC 16K 146 x 215 mm            */
#define PRINTER_PAPER_P32K                94  /* PRC 32K 97 x 151 mm             */
#define PRINTER_PAPER_P32KBIG             95  /* PRC 32K(Big) 97 x 151 mm        */
#define PRINTER_PAPER_PENV_1              96  /* PRC Envelope #1 102 x 165 mm    */
#define PRINTER_PAPER_PENV_2              97  /* PRC Envelope #2 102 x 176 mm    */
#define PRINTER_PAPER_PENV_3              98  /* PRC Envelope #3 125 x 176 mm    */
#define PRINTER_PAPER_PENV_4              99  /* PRC Envelope #4 110 x 208 mm    */
#define PRINTER_PAPER_PENV_5              100 /* PRC Envelope #5 110 x 220 mm    */
#define PRINTER_PAPER_PENV_6              101 /* PRC Envelope #6 120 x 230 mm    */
#define PRINTER_PAPER_PENV_7              102 /* PRC Envelope #7 160 x 230 mm    */
#define PRINTER_PAPER_PENV_8              103 /* PRC Envelope #8 120 x 309 mm    */
#define PRINTER_PAPER_PENV_9              104 /* PRC Envelope #9 229 x 324 mm    */
#define PRINTER_PAPER_PENV_10             105 /* PRC Envelope #10 324 x 458 mm   */
#define PRINTER_PAPER_P16K_ROTATED        106 /* PRC 16K Rotated                 */
#define PRINTER_PAPER_P32K_ROTATED        107 /* PRC 32K Rotated                 */
#define PRINTER_PAPER_P32KBIG_ROTATED     108 /* PRC 32K(Big) Rotated            */
#define PRINTER_PAPER_PENV_1_ROTATED      109 /* PRC Envelope #1 Rotated 165 x 102 mm */
#define PRINTER_PAPER_PENV_2_ROTATED      110 /* PRC Envelope #2 Rotated 176 x 102 mm */
#define PRINTER_PAPER_PENV_3_ROTATED      111 /* PRC Envelope #3 Rotated 176 x 125 mm */
#define PRINTER_PAPER_PENV_4_ROTATED      112 /* PRC Envelope #4 Rotated 208 x 110 mm */
#define PRINTER_PAPER_PENV_5_ROTATED      113 /* PRC Envelope #5 Rotated 220 x 110 mm */
#define PRINTER_PAPER_PENV_6_ROTATED      114 /* PRC Envelope #6 Rotated 230 x 120 mm */
#define PRINTER_PAPER_PENV_7_ROTATED      115 /* PRC Envelope #7 Rotated 230 x 160 mm */
#define PRINTER_PAPER_PENV_8_ROTATED      116 /* PRC Envelope #8 Rotated 309 x 120 mm */
#define PRINTER_PAPER_PENV_9_ROTATED      117 /* PRC Envelope #9 Rotated 324 x 229 mm */
#define PRINTER_PAPER_PENV_10_ROTATED     118 /* PRC Envelope #10 Rotated 458 x 324 mm */

#define PRINTER_PAPER_USER                256







