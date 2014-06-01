/*
 * $Id: winprint.ch,v 1.10 2014-06-01 15:08:41 fyurisich Exp $
 */
// ---------------------------------------------------------------------------
// HBPRINTER - Harbour Win32 Printing library source code
//
// Copyright 2002 Richard Rylko <rrylko@poczta.onet.pl>
// http://rrylko.republika.pl
// ---------------------------------------------------------------------------

MEMVAR HBPRN

#xcommand SET CHANGES GLOBAL => hbprn:lGlobalChanges := .T.
#xcommand SET CHANGES LOCAL => hbprn:lGlobalChanges := .F.

#xcommand SET DUPLEX VERTICAL => hbprn:setdevmode(DM_DUPLEX,DMDUP_VERTICAL)
#xcommand SET DUPLEX HORIZONTAL => hbprn:setdevmode(DM_DUPLEX,DMDUP_HORIZONTAL)
#xcommand SET DUPLEX OFF => hbprn:setdevmode(DM_DUPLEX,DMDUP_SIMPLEX)

#xcommand SET COLLATE ON => hbprn:setdevmode(DM_COLLATE,DMCOLLATE_TRUE)
#xcommand SET COLLATE OFF => hbprn:setdevmode(DM_COLLATE,DMCOLLATE_FALSE)

#xcommand SET QUALITY <q> => hbprn:setdevmode(DM_PRINTQUALITY,<q>)
#xcommand SET COLORMODE <c> => hbprn:setdevmode(DM_COLOR,<c>)

#xcommand INIT PRINTSYS => hbprn:=hbprinter():new()
#xcommand START DOC [NAME <docname>] => hbprn:startdoc(<docname>)
#xcommand START PAGE => hbprn:startpage()
#xcommand END PAGE => IIF ( TYPE( "_OOHG_AllVars" ) == "A" .AND. ! EMPTY( _OOHG_ActiveFrame ) , DO( "_EndTabPage" ) , hbprn:endpage() )
#xcommand END DOC => hbprn:enddoc()
#xcommand RELEASE PRINTSYS => hbprn:end()

#xcommand GET DEFAULT PRINTER TO <cprinter> => <cprinter>:=hbprn:printerdefault
#xcommand GET SELECTED PRINTER TO <cprinter> => <cprinter>:=hbprn:printername
#xcommand GET PAPERS TO <a_names_numbers> => <a_names_numbers>:=aclone(hbprn:papernames)
#xcommand GET BINS TO <a_names_numbers> => <a_names_numbers>:=aclone(hbprn:binnames)
#xcommand GET PRINTERS TO <aprinters> => <aprinters>:=aclone(hbprn:printers)
#xcommand GET PORTS TO <aports> => <aports>:=aclone(hbprn:ports)

#xtranslate HBPRNMAXROW => hbprn:maxrow
#xtranslate HBPRNMAXCOL => hbprn:maxcol
#xtranslate HBPRNERROR => hbprn:error
#xtranslate HBPRNCOLOR(<clr>) => hbprn:dxcolors(<clr>)

#xcommand SELECT BY DIALOG [<p: PREVIEW>]=> hbprn:selectprinter("",<.p.>)
#xcommand SELECT DEFAULT [<p: PREVIEW>]=> hbprn:selectprinter(NIL,<.p.>)
#xcommand SELECT PRINTER <cprinter> [<p: PREVIEW>]=> hbprn:selectprinter(<cprinter>,<.p.>)

#xcommand ENABLE THUMBNAILS => hbprn:thumbnails := .T.
#xcommand DISABLE THUMBNAILS => hbprn:thumbnails := .F.
#xcommand SET PREVIEW RECT <row>,<col>,<row2>,<col2> => hbprn:previewrect:={<row>,<col>,<row2>,<col2>}
#xcommand SET PREVIEW SCALE <scale> => hbprn:previewscale:=<scale>

#xcommand SET PAGE [ORIENTATION <orient>] [PAPERSIZE <psize>] [FONT <cfont>] ;
               => hbprn:setpage(<orient>,<psize>,<cfont>)

#xcommand SET ORIENTATION PORTRAIT => hbprn:setdevmode(DM_ORIENTATION,DMORIENT_PORTRAIT)
#xcommand SET ORIENTATION LANDSCAPE => hbprn:setdevmode(DM_ORIENTATION,DMORIENT_LANDSCAPE)
#xcommand SET PAPERSIZE <psize> => hbprn:setdevmode(DM_PAPERSIZE,<psize>)
#xcommand SET BIN [TO] <prnbin> => hbprn:setdevmode(DM_DEFAULTSOURCE,<prnbin>)

#xcommand SET TEXTCOLOR <clr> => hbprn:settextcolor(<clr>)
#xcommand GET TEXTCOLOR [TO] <clr> => <clr>:=hbprn:gettexcolor()
#xcommand SET BACKCOLOR <clr> => hbprn:setbkcolor(<clr>)
#xcommand GET BACKCOLOR [TO] <clr> => <clr>:=hbprn:getbkcolor()
#xcommand SET BKMODE <mode> => hbprn:setbkmode(<mode>)
#xcommand SET BKMODE TRANSPARENT => hbprn:setbkmode(1)
#xcommand SET BKMODE OPAQUE => hbprn:setbkmode(2)
#xcommand GET BKMODE [TO] <mode> => <mode>:=hbprn:getbkmode()
#xcommand SET PRINT MARGINS [TOP <lm>] [LEFT <rm>] =>hbprn:setviewportorg(<lm>,<rm>)

#xcommand SET THUMBNAILS ON => hbprn:Thumbnails := .T.
#xcommand SET THUMBNAILS OFF => hbprn:Thumbnails := .F.
#xcommand SET PREVIEW ON => hbprn:PreviewMode := .T.
#xcommand SET PREVIEW OFF => hbprn:PreviewMode := .F.

#xcommand DEFINE IMAGELIST <cimglist> PICTURE <cpicture> [ICONCOUNT <nicons>] ;
                            => hbprn:defineimagelist(<cimglist>,<cpicture>,<nicons>)

#xcommand @ <row>,<col>,<row2>,<col2> DRAW IMAGELIST <cimglist> ICON <nicon> [NORMAL] [BACKGROUND <color>];
          => hbprn:drawimagelist(<cimglist>,<nicon>,<row>,<col>,<row2>,<col2>,ILD_NORMAL,<color>)
#xcommand @ <row>,<col>,<row2>,<col2> DRAW IMAGELIST <cimglist> ICON <nicon> BLEND25 [BACKGROUND <color>];
          => hbprn:drawimagelist(<cimglist>,<nicon>,<row>,<col>,<row2>,<col2>,ILD_BLEND25,<color>)
#xcommand @ <row>,<col>,<row2>,<col2> DRAW IMAGELIST <cimglist> ICON <nicon> BLEND50 [BACKGROUND <color>];
          => hbprn:drawimagelist(<cimglist>,<nicon>,<row>,<col>,<row2>,<col2>,ILD_BLEND50,<color>)
#xcommand @ <row>,<col>,<row2>,<col2> DRAW IMAGELIST <cimglist> ICON <nicon> MASK [BACKGROUND <color>];
          => hbprn:drawimagelist(<cimglist>,<nicon>,<row>,<col>,<row2>,<col2>,ILD_MASK,<color>)



#xcommand DEFINE BRUSH <cbrush> [STYLE <style>] [COLOR <clr>] [HATCH <hatch>] ;
                            => hbprn:definebrush(<cbrush>,<style>,<clr>,<hatch>)
#xcommand CHANGE BRUSH <cbrush> [STYLE <style>] [COLOR <clr>] [HATCH <hatch>] ;
                            => hbprn:modifybrush(<cbrush>,<style>,<clr>,<hatch>)
#xcommand SELECT BRUSH <cbrush>;
                            => hbprn:selectbrush(<cbrush>)

#xcommand DEFINE PEN <cpen> [STYLE <style>] [WIDTH <width>] [COLOR <clr>] ;
                            => hbprn:definepen(<cpen>,<style>,<width>,<clr>)
#xcommand CHANGE PEN <cpen> [STYLE <style>] [WIDTH <width>] [COLOR <clr>] ;
                            => hbprn:modifypen(<cpen>,<style>,<width>,<clr>)

#xcommand SELECT PEN <cpen> ;
                            => hbprn:selectpen(<cpen>)

#xcommand DEFINE FONT <cfont> [NAME <cface>] [SIZE <size>] [WIDTH <width>] [ANGLE <angle>] ;
                           [<bold:BOLD>] [<italic:ITALIC>] ;
                           [<underline:UNDERLINE>] [<strikeout:STRIKEOUT>];
                            => hbprn:definefont(<cfont>,<cface>,<size>,<width>,<angle>,<.bold.>,<.italic.>,<.underline.>,<.strikeout.>)


#xcommand CHANGE FONT <cfont> [NAME <cface>] [SIZE <size>] [WIDTH <width>] [ANGLE <angle>] ;
                    [<bold:BOLD>] [<nbold:NOBOLD>] ;
                    [<italic:ITALIC>] [<nitalic:NOITALIC>] ;
                    [<underline:UNDERLINE>] [<nunderline:NOUNDERLINE>] ;
                    [<strikeout:STRIKEOUT>] [<nstrikeout:NOSTRIKEOUT>] ;
                   => hbprn:modifyfont(<cfont>,<cface>,<size>,<width>,<angle>,;
                      <.bold.>,<.nbold.>,<.italic.>,<.nitalic.>,;
                      <.underline.>,<.nunderline.>,<.strikeout.>,<.nstrikeout.>)


#xcommand SELECT FONT <cfont> => hbprn:selectfont(<cfont>)
#xcommand SET CHARSET <charset> => hbprn:setcharset(<charset>)

#xcommand @ <row>,<col>,<row2>,<col2> DRAW TEXT <txt> [STYLE <style>] [FONT <cfont>] [<lNoWordBreak: NOWORDBREAK>];
          => hbprn:drawtext(<row>,<col>,<row2>,<col2>,<txt>,<style>,<cfont>,<.lNoWordBreak.>)
#xcommand @ <row>,<col> TEXTOUT <txt> [FONT <cfont>];
          => hbprn:textout(<row>,<col>,<txt>,<cfont>)

#xcommand @ <row>,<col> SAY <txt> [FONT <cfont>] [COLOR <color>] [ALIGN <align>]  TO PRINT;
            => hbprn:say(<row>,<col>,<txt>,<cfont>,<color>,<align>)

#xcommand @ <row>,<col>,<row2>,<col2> RECTANGLE [PEN <cpen>] [BRUSH <cbrush>];
          => hbprn:rectangle(<row>,<col>,<row2>,<col2>,<cpen>,<cbrush>)

#xcommand @ <row>,<col>,<row2>,<col2> FILLRECT [BRUSH <cbrush>];
          => hbprn:fillrect(<row>,<col>,<row2>,<col2>,<cbrush>)

#xcommand @ <row>,<col>,<row2>,<col2> ROUNDRECT  [ROUNDR <tor>] [ROUNDC <toc>] [PEN <cpen>] [BRUSH <cbrush>];
          => hbprn:roundrect(<row>,<col>,<row2>,<col2>,<tor>,<toc>,<cpen>,<cbrush>)

#xcommand @ <row>,<col>,<row2>,<col2> FRAMERECT [BRUSH <cbrush>];
          => hbprn:framerect(<row>,<col>,<row2>,<col2>,<cbrush>)

#xcommand @ <row>,<col>,<row2>,<col2> INVERTRECT ;
          => hbprn:invertrect(<row>,<col>,<row2>,<col2>)

#xcommand @ <row>,<col>,<row2>,<col2> ELLIPSE [PEN <cpen>] [BRUSH <cbrush>];
          => hbprn:ellipse(<row>,<col>,<row2>,<col2>,<cpen>,<cbrush>)

#xcommand @ <row>,<col>,<row2>,<col2> ARC RADIAL1 <row3>,<col3> RADIAL2 <row4>,<col4> [PEN <cpen>] ;
          => hbprn:arc(<row>,<col>,<row2>,<col2>,<row3>,<col3>,<row4>,<col4>,<cpen>)

#xcommand @ <row>,<col> ARCTO RADIAL1 <row3>,<col3> RADIAL2 <row4>,<col4> [PEN <cpen>] ;
          => hbprn:arcto(<row>,<col>,<row3>,<col3>,<row4>,<col4>,<cpen>)

#xcommand @ <row>,<col>,<row2>,<col2> CHORD RADIAL1 <row3>,<col3> RADIAL2 <row4>,<col4> [PEN <cpen>] [BRUSH <cbrush>];
          => hbprn:chord(<row>,<col>,<row2>,<col2>,<row3>,<col3>,<row4>,<col4>,<cpen>,<cbrush>)

#xcommand @ <row>,<col>,<row2>,<col2> PIE RADIAL1 <row3>,<col3> RADIAL2 <row4>,<col4> [PEN <cpen>] [BRUSH <cbrush>];
          => hbprn:pie(<row>,<col>,<row2>,<col2>,<row3>,<col3>,<row4>,<col4>,<cpen>,<cbrush>)

#xcommand POLYGON <apoints> [PEN <cpen>] [BRUSH <cbrush>] [STYLE <style>];
          => hbprn:polygon(<apoints>,<cpen>,<cbrush>,<style>)

#xcommand POLYBEZIER <apoints> [PEN <cpen>] ;
          => hbprn:polybezier(<apoints>,<cpen>)

#xcommand POLYBEZIERTO <apoints> [PEN <cpen>] ;
          => hbprn:polybezierto(<apoints>,<cpen>)

#xcommand SET UNITS => hbprn:setunits(0)
#xcommand SET UNITS <units: ROWCOL, MM, INCHES, PIXELS> [ <absolute: ABSOLUTE> ] =>  hbprn:setunits(<"units">,,,<.absolute.>)
#xcommand SET UNITS ROWS <r> COLS <c> [ <absolute: ABSOLUTE> ] =>  hbprn:setunits(4,<r>,<c>,<.absolute.>)

#xcommand DEFINE RECT REGION <creg> AT <row>,<col>,<row2>,<col2> ;
           => hbprn:definerectrgn(<creg>,<row>,<col>,<row2>,<col2>)

#xcommand DEFINE POLYGON REGION <creg> VERTEX <apoints> [STYLE <style>] ;
           => hbprn:definepolygonrgn(<creg>,<apoints>,<style>)

#xcommand DEFINE ELLIPTIC REGION <creg> AT <row>,<col>,<row2>,<col2> ;
           => hbprn:defineEllipticrgn(<creg>,<row>,<col>,<row2>,<col2>)

#xcommand DEFINE ROUNDRECT REGION <creg> AT <row>,<col>,<row2>,<col2> ELLIPSE <ewidth>,<eheight>;
           => hbprn:defineroundrectrgn(<creg>,<row>,<col>,<row2>,<col2>,<ewidth>,<eheight>)

#xcommand COMBINE REGIONS <creg1>,<creg2> TO <creg> [STYLE <style>] ;
           => hbprn:combinergn(<creg>,<creg1>,<creg2>,<style>)

#xcommand SELECT CLIP REGION <creg> ;
           => hbprn:selectcliprgn(<creg>)

#xcommand DELETE CLIP REGION ;
           => hbprn:deletecliprgn()

#xcommand SET POLYFILL MODE <mode>;
           => hbprn:setpolyfillmode(<mode>)

#xcommand SET POLYFILL ALTERNATE;
           => hbprn:setpolyfillmode(ALTERNATE)

#xcommand SET POLYFILL WINDING;
           => hbprn:setpolyfillmode(WINDING)

#xcommand GET POLYFILL MODE TO <mode>;
           => <mode>:=hbprn:getpolyfillmode()

#xcommand SET VIEWPORTORG <row>,<col>;
           => hbprn:setviewportorg(<row>,<col>)

#xcommand GET VIEWPORTORG TO <aviewport>;
           => hbprn:getviewportorg(); <aviewport>:=aclone(hbprn:viewportorg)

#xcommand SET RGB <red>,<green>,<blue> TO <nrgb>;
           => <nrgb>:=hbprn:setrgb(<red>,<green>,<blue>)

#xcommand SET TEXTCHAR EXTRA <col> ;
           => hbprn:settextcharextra(<col>)

#xcommand GET TEXTCHAR EXTRA TO <col> ;
           => <col>:=hbprn:gettextcharextra()

#xcommand SET TEXT JUSTIFICATION <col> ;
           => hbprn:settextjustification(<col>)

#xcommand GET TEXT JUSTIFICATION TO <col> ;
           => <col>:=hbprn:gettextjustification()

#xcommand SET TEXT ALIGN <style> ;
           => hbprn:settextalign(<style>)
#xcommand SET TEXT ALIGN LEFT ;
           => hbprn:settextalign(TA_LEFT)
#xcommand SET TEXT ALIGN RIGHT ;
           => hbprn:settextalign(TA_RIGHT)
#xcommand SET TEXT ALIGN CENTER ;
           => hbprn:settextalign(TA_CENTER)

#xcommand GET TEXT ALIGN TO <style> ;
           => <style>:=hbprn:gettextalign()

#xcommand @<row>,<col> PICTURE <cpic> SIZE <row2>,<col2> [EXTEND <row3>,<col3>] ;
           => hbprn:picture(<row>,<col>,<row2>,<col2>,<cpic>,<row3>,<col3>)

#xcommand @<row>,<col> PICTURE <cpic> IMAGESIZE ;
           => hbprn:picture(<row>,<col>,,,<cpic>,,,.T.)

#xcommand @<row>,<col>,<row2>,<col2> LINE  [PEN <cpen>] ;
           => hbprn:line(<row>,<col>,<row2>,<col2>,<cpen>)

#xcommand @<row>,<col> LINETO  [PEN <cpen>] ;
           => hbprn:lineto(<row>,<col>,<cpen>)

#xcommand GET TEXT EXTENT <txt> [FONT <cfont>] TO <asize> ;
           => hbprn:gettextextent(<txt>,<asize>,<cfont>)





/* field selection bits for setdevmode "what"*/
#define DM_ORIENTATION      0x00000001
#define DM_PAPERSIZE        0x00000002
#define DM_PAPERLENGTH      0x00000004
#define DM_PAPERWIDTH       0x00000008
#define DM_SCALE            0x00000010
#define DM_POSITION         0x00000020
#define DM_NUP              0x00000040
#define DM_COPIES           0x00000100
#define DM_DEFAULTSOURCE    0x00000200
#define DM_PRINTQUALITY     0x00000400
#define DM_COLOR            0x00000800
#define DM_DUPLEX           0x00001000
#define DM_YRESOLUTION      0x00002000
#define DM_TTOPTION         0x00004000
#define DM_COLLATE          0x00008000
#define DM_FORMNAME         0x00010000
#define DM_LOGPIXELS        0x00020000
#define DM_BITSPERPEL       0x00040000
#define DM_PELSWIDTH        0x00080000
#define DM_PELSHEIGHT       0x00100000
#define DM_DISPLAYFLAGS     0x00200000
#define DM_DISPLAYFREQUENCY 0x00400000
#define DM_ICMMETHOD        0x00800000
#define DM_ICMINTENT        0x01000000
#define DM_MEDIATYPE        0x02000000
#define DM_DITHERTYPE       0x04000000
#define DM_PANNINGWIDTH     0x08000000
#define DM_PANNINGHEIGHT    0x10000000

/* bin selections */
#define DMBIN_FIRST         DMBIN_UPPER
#define DMBIN_UPPER         1
#define DMBIN_ONLYONE       1
#define DMBIN_LOWER         2
#define DMBIN_MIDDLE        3
#define DMBIN_MANUAL        4
#define DMBIN_ENVELOPE      5
#define DMBIN_ENVMANUAL     6
#define DMBIN_AUTO          7
#define DMBIN_TRACTOR       8
#define DMBIN_SMALLFMT      9
#define DMBIN_LARGEFMT      10
#define DMBIN_LARGECAPACITY 11
#define DMBIN_CASSETTE      14
#define DMBIN_FORMSOURCE    15
#define DMBIN_LAST          DMBIN_FORMSOURCE
#define DMBIN_USER          256     /* device specific bins start here */

/* collate */
#define DMCOLLATE_TRUE      1
#define DMCOLLATE_FALSE     0

/* orientation */
#define DMORIENT_PORTRAIT   1
#define DMORIENT_LANDSCAPE  2

/* color enable/disable for color printers */
#define DMCOLOR_MONOCHROME  1
#define DMCOLOR_COLOR       2

/* print qualities */
#define DMRES_DRAFT         (-1)
#define DMRES_LOW           (-2)
#define DMRES_MEDIUM        (-3)
#define DMRES_HIGH          (-4)


/* IMAGELIST DRAWING STYLES */
#define ILD_NORMAL              0x0000
#define ILD_MASK                0x0010
#define ILD_BLEND25             0x0002
#define ILD_BLEND50             0x0004



/* Brush Styles */
#define BS_SOLID            0
#define BS_NULL             1
#define BS_HOLLOW           BS_NULL
#define BS_HATCHED          2
#define BS_PATTERN          3
#define BS_INDEXED          4
#define BS_DIBPATTERN       5
#define BS_DIBPATTERNPT     6
#define BS_PATTERN8X8       7
#define BS_DIBPATTERN8X8    8
#define BS_MONOPATTERN      9

/* Hatch Styles */
#define HS_HORIZONTAL       0       /* ----- */
#define HS_VERTICAL         1       /* ||||| */
#define HS_FDIAGONAL        2       /* \\\\\ */
#define HS_BDIAGONAL        3       /* ///// */
#define HS_CROSS            4       /* +++++ */
#define HS_DIAGCROSS        5       /* xxxxx */

/* Pen Styles */
#define PS_SOLID            0
#define PS_DASH             1       /* -------  */
#define PS_DOT              2       /* .......  */
#define PS_DASHDOT          3       /* _._._._  */
#define PS_DASHDOTDOT       4       /* _.._.._  */
#define PS_NULL             5
#define PS_INSIDEFRAME      6
#define PS_USERSTYLE        7
#define PS_ALTERNATE        8
#define PS_STYLE_MASK       0x0000000F

/* CombineRgn() Styles */
#define RGN_AND             1
#define RGN_OR              2
#define RGN_XOR             3
#define RGN_DIFF            4
#define RGN_COPY            5
#define RGN_MIN             RGN_AND
#define RGN_MAX             RGN_COPY

/* PolyFill() Modes */
#define ALTERNATE                    1
#define WINDING                      2
#define POLYFILL_LAST                2

/* Text Alignment Options */
#define TA_NOUPDATECP                0
#define TA_UPDATECP                  1

#define TA_LEFT                      0
#define TA_RIGHT                     2
#define TA_CENTER                    6

#define TA_TOP                       0
#define TA_BOTTOM                    8
#define TA_BASELINE                  24
#define TA_RTLREADING                256
#define TA_MASK       (TA_BASELINE+TA_CENTER+TA_UPDATECP+TA_RTLREADING)

/*
 * Scroll Bar Constants
 */

#define SB_HORZ             0
#define SB_VERT             1
#define SB_CTL              2
#define SB_BOTH             3

/*
 * DrawText() Format Flags
 */
#define DT_TOP                      0x00000000
#define DT_LEFT                     0x00000000
#define DT_CENTER                   0x00000001
#define DT_RIGHT                    0x00000002
#define DT_VCENTER                  0x00000004
#define DT_BOTTOM                   0x00000008
#define DT_WORDBREAK                0x00000010
#define DT_SINGLELINE               0x00000020
#define DT_EXPANDTABS               0x00000040
#define DT_TABSTOP                  0x00000080
#define DT_NOCLIP                   0x00000100
#define DT_EXTERNALLEADING          0x00000200
#define DT_CALCRECT                 0x00000400
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000

#define DT_EDITCONTROL              0x00002000
#define DT_PATH_ELLIPSIS            0x00004000
#define DT_END_ELLIPSIS             0x00008000
#define DT_MODIFYSTRING             0x00010000
#define DT_RTLREADING               0x00020000
#define DT_WORD_ELLIPSIS            0x00040000
#define DT_NOFULLWIDTHCHARBREAK     0x00080000
#define DT_HIDEPREFIX               0x00100000
#define DT_PREFIXONLY               0x00200000

#define ANSI_CHARSET            0
#define DEFAULT_CHARSET         1
#define SYMBOL_CHARSET          2
#define SHIFTJIS_CHARSET        128
#define HANGEUL_CHARSET         129
#define HANGUL_CHARSET          129
#define GB2312_CHARSET          134
#define CHINESEBIG5_CHARSET     136
#define OEM_CHARSET             255
#define JOHAB_CHARSET           130
#define HEBREW_CHARSET          177
#define ARABIC_CHARSET          178
#define GREEK_CHARSET           161
#define TURKISH_CHARSET         162
#define VIETNAMESE_CHARSET      163
#define THAI_CHARSET            222
#define EASTEUROPE_CHARSET      238
#define RUSSIAN_CHARSET         204
#define MAC_CHARSET             77
#define BALTIC_CHARSET          186


/* Stock Logical Objects */
#define WHITE_BRUSH         0
#define LTGRAY_BRUSH        1
#define GRAY_BRUSH          2
#define DKGRAY_BRUSH        3
#define BLACK_BRUSH         4
#define NULL_BRUSH          5
#define HOLLOW_BRUSH        NULL_BRUSH
#define WHITE_PEN           6
#define BLACK_PEN           7
#define NULL_PEN            8
#define OEM_FIXED_FONT      10
#define ANSI_FIXED_FONT     11
#define ANSI_VAR_FONT       12
#define SYSTEM_FONT         13
#define DEVICE_DEFAULT_FONT 14
#define DEFAULT_PALETTE     15
#define SYSTEM_FIXED_FONT   16

/* duplex */
#define DMDUP_SIMPLEX    1
#define DMDUP_VERTICAL   2
#define DMDUP_HORIZONTAL 3

#ifndef DMPAPER_FIRST

/*values for setmode papersize predefined!!! */

#define DMPAPER_FIRST                DMPAPER_LETTER
#define DMPAPER_LETTER               1  /* Letter 8 1/2 x 11 in               */
#define DMPAPER_LETTERSMALL          2  /* Letter Small 8 1/2 x 11 in         */
#define DMPAPER_TABLOID              3  /* Tabloid 11 x 17 in                 */
#define DMPAPER_LEDGER               4  /* Ledger 17 x 11 in                  */
#define DMPAPER_LEGAL                5  /* Legal 8 1/2 x 14 in                */
#define DMPAPER_STATEMENT            6  /* Statement 5 1/2 x 8 1/2 in         */
#define DMPAPER_EXECUTIVE            7  /* Executive 7 1/4 x 10 1/2 in        */
#define DMPAPER_A3                   8  /* A3 297 x 420 mm                    */
#define DMPAPER_A4                   9  /* A4 210 x 297 mm                    */
#define DMPAPER_A4SMALL             10  /* A4 Small 210 x 297 mm              */
#define DMPAPER_A5                  11  /* A5 148 x 210 mm                    */
#define DMPAPER_B4                  12  /* B4 (JIS) 250 x 354                 */
#define DMPAPER_B5                  13  /* B5 (JIS) 182 x 257 mm              */
#define DMPAPER_FOLIO               14  /* Folio 8 1/2 x 13 in                */
#define DMPAPER_QUARTO              15  /* Quarto 215 x 275 mm                */
#define DMPAPER_10X14               16  /* 10x14 in                           */
#define DMPAPER_11X17               17  /* 11x17 in                           */
#define DMPAPER_NOTE                18  /* Note 8 1/2 x 11 in                 */
#define DMPAPER_ENV_9               19  /* Envelope #9 3 7/8 x 8 7/8          */
#define DMPAPER_ENV_10              20  /* Envelope #10 4 1/8 x 9 1/2         */
#define DMPAPER_ENV_11              21  /* Envelope #11 4 1/2 x 10 3/8        */
#define DMPAPER_ENV_12              22  /* Envelope #12 4 \276 x 11           */
#define DMPAPER_ENV_14              23  /* Envelope #14 5 x 11 1/2            */
#define DMPAPER_CSHEET              24  /* C size sheet                       */
#define DMPAPER_DSHEET              25  /* D size sheet                       */
#define DMPAPER_ESHEET              26  /* E size sheet                       */
#define DMPAPER_ENV_DL              27  /* Envelope DL 110 x 220mm            */
#define DMPAPER_ENV_C5              28  /* Envelope C5 162 x 229 mm           */
#define DMPAPER_ENV_C3              29  /* Envelope C3  324 x 458 mm          */
#define DMPAPER_ENV_C4              30  /* Envelope C4  229 x 324 mm          */
#define DMPAPER_ENV_C6              31  /* Envelope C6  114 x 162 mm          */
#define DMPAPER_ENV_C65             32  /* Envelope C65 114 x 229 mm          */
#define DMPAPER_ENV_B4              33  /* Envelope B4  250 x 353 mm          */
#define DMPAPER_ENV_B5              34  /* Envelope B5  176 x 250 mm          */
#define DMPAPER_ENV_B6              35  /* Envelope B6  176 x 125 mm          */
#define DMPAPER_ENV_ITALY           36  /* Envelope 110 x 230 mm              */
#define DMPAPER_ENV_MONARCH         37  /* Envelope Monarch 3.875 x 7.5 in    */
#define DMPAPER_ENV_PERSONAL        38  /* 6 3/4 Envelope 3 5/8 x 6 1/2 in    */
#define DMPAPER_FANFOLD_US          39  /* US Std Fanfold 14 7/8 x 11 in      */
#define DMPAPER_FANFOLD_STD_GERMAN  40  /* German Std Fanfold 8 1/2 x 12 in   */
#define DMPAPER_FANFOLD_LGL_GERMAN  41  /* German Legal Fanfold 8 1/2 x 13 in */
#define DMPAPER_ISO_B4              42  /* B4 (ISO) 250 x 353 mm              */
#define DMPAPER_JAPANESE_POSTCARD   43  /* Japanese Postcard 100 x 148 mm     */
#define DMPAPER_9X11                44  /* 9 x 11 in                          */
#define DMPAPER_10X11               45  /* 10 x 11 in                         */
#define DMPAPER_15X11               46  /* 15 x 11 in                         */
#define DMPAPER_ENV_INVITE          47  /* Envelope Invite 220 x 220 mm       */
#define DMPAPER_RESERVED_48         48  /* RESERVED--DO NOT USE               */
#define DMPAPER_RESERVED_49         49  /* RESERVED--DO NOT USE               */
#define DMPAPER_LETTER_EXTRA        50  /* Letter Extra 9 \275 x 12 in        */
#define DMPAPER_LEGAL_EXTRA         51  /* Legal Extra 9 \275 x 15 in         */
#define DMPAPER_TABLOID_EXTRA       52  /* Tabloid Extra 11.69 x 18 in        */
#define DMPAPER_A4_EXTRA            53  /* A4 Extra 9.27 x 12.69 in           */
#define DMPAPER_LETTER_TRANSVERSE   54  /* Letter Transverse 8 \275 x 11 in   */
#define DMPAPER_A4_TRANSVERSE       55  /* A4 Transverse 210 x 297 mm         */
#define DMPAPER_LETTER_EXTRA_TRANSVERSE 56 /* Letter Extra Transverse 9\275 x 12 in */
#define DMPAPER_A_PLUS              57  /* SuperA/SuperA/A4 227 x 356 mm      */
#define DMPAPER_B_PLUS              58  /* SuperB/SuperB/A3 305 x 487 mm      */
#define DMPAPER_LETTER_PLUS         59  /* Letter Plus 8.5 x 12.69 in         */
#define DMPAPER_A4_PLUS             60  /* A4 Plus 210 x 330 mm               */
#define DMPAPER_A5_TRANSVERSE       61  /* A5 Transverse 148 x 210 mm         */
#define DMPAPER_B5_TRANSVERSE       62  /* B5 (JIS) Transverse 182 x 257 mm   */
#define DMPAPER_A3_EXTRA            63  /* A3 Extra 322 x 445 mm              */
#define DMPAPER_A5_EXTRA            64  /* A5 Extra 174 x 235 mm              */
#define DMPAPER_B5_EXTRA            65  /* B5 (ISO) Extra 201 x 276 mm        */
#define DMPAPER_A2                  66  /* A2 420 x 594 mm                    */
#define DMPAPER_A3_TRANSVERSE       67  /* A3 Transverse 297 x 420 mm         */
#define DMPAPER_A3_EXTRA_TRANSVERSE 68  /* A3 Extra Transverse 322 x 445 mm   */
#define DMPAPER_DBL_JAPANESE_POSTCARD 69 /* Japanese Double Postcard 200 x 148 mm */
#define DMPAPER_A6                  70  /* A6 105 x 148 mm                 */
#define DMPAPER_JENV_KAKU2          71  /* Japanese Envelope Kaku #2       */
#define DMPAPER_JENV_KAKU3          72  /* Japanese Envelope Kaku #3       */
#define DMPAPER_JENV_CHOU3          73  /* Japanese Envelope Chou #3       */
#define DMPAPER_JENV_CHOU4          74  /* Japanese Envelope Chou #4       */
#define DMPAPER_LETTER_ROTATED      75  /* Letter Rotated 11 x 8 1/2 11 in */
#define DMPAPER_A3_ROTATED          76  /* A3 Rotated 420 x 297 mm         */
#define DMPAPER_A4_ROTATED          77  /* A4 Rotated 297 x 210 mm         */
#define DMPAPER_A5_ROTATED          78  /* A5 Rotated 210 x 148 mm         */
#define DMPAPER_B4_JIS_ROTATED      79  /* B4 (JIS) Rotated 364 x 257 mm   */
#define DMPAPER_B5_JIS_ROTATED      80  /* B5 (JIS) Rotated 257 x 182 mm   */
#define DMPAPER_JAPANESE_POSTCARD_ROTATED 81 /* Japanese Postcard Rotated 148 x 100 mm */
#define DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED 82 /* Double Japanese Postcard Rotated 148 x 200 mm */
#define DMPAPER_A6_ROTATED          83  /* A6 Rotated 148 x 105 mm         */
#define DMPAPER_JENV_KAKU2_ROTATED  84  /* Japanese Envelope Kaku #2 Rotated */
#define DMPAPER_JENV_KAKU3_ROTATED  85  /* Japanese Envelope Kaku #3 Rotated */
#define DMPAPER_JENV_CHOU3_ROTATED  86  /* Japanese Envelope Chou #3 Rotated */
#define DMPAPER_JENV_CHOU4_ROTATED  87  /* Japanese Envelope Chou #4 Rotated */
#define DMPAPER_B6_JIS              88  /* B6 (JIS) 128 x 182 mm           */
#define DMPAPER_B6_JIS_ROTATED      89  /* B6 (JIS) Rotated 182 x 128 mm   */
#define DMPAPER_12X11               90  /* 12 x 11 in                      */
#define DMPAPER_JENV_YOU4           91  /* Japanese Envelope You #4        */
#define DMPAPER_JENV_YOU4_ROTATED   92  /* Japanese Envelope You #4 Rotated*/
#define DMPAPER_P16K                93  /* PRC 16K 146 x 215 mm            */
#define DMPAPER_P32K                94  /* PRC 32K 97 x 151 mm             */
#define DMPAPER_P32KBIG             95  /* PRC 32K(Big) 97 x 151 mm        */
#define DMPAPER_PENV_1              96  /* PRC Envelope #1 102 x 165 mm    */
#define DMPAPER_PENV_2              97  /* PRC Envelope #2 102 x 176 mm    */
#define DMPAPER_PENV_3              98  /* PRC Envelope #3 125 x 176 mm    */
#define DMPAPER_PENV_4              99  /* PRC Envelope #4 110 x 208 mm    */
#define DMPAPER_PENV_5              100 /* PRC Envelope #5 110 x 220 mm    */
#define DMPAPER_PENV_6              101 /* PRC Envelope #6 120 x 230 mm    */
#define DMPAPER_PENV_7              102 /* PRC Envelope #7 160 x 230 mm    */
#define DMPAPER_PENV_8              103 /* PRC Envelope #8 120 x 309 mm    */
#define DMPAPER_PENV_9              104 /* PRC Envelope #9 229 x 324 mm    */
#define DMPAPER_PENV_10             105 /* PRC Envelope #10 324 x 458 mm   */
#define DMPAPER_P16K_ROTATED        106 /* PRC 16K Rotated                 */
#define DMPAPER_P32K_ROTATED        107 /* PRC 32K Rotated                 */
#define DMPAPER_P32KBIG_ROTATED     108 /* PRC 32K(Big) Rotated            */
#define DMPAPER_PENV_1_ROTATED      109 /* PRC Envelope #1 Rotated 165 x 102 mm */
#define DMPAPER_PENV_2_ROTATED      110 /* PRC Envelope #2 Rotated 176 x 102 mm */
#define DMPAPER_PENV_3_ROTATED      111 /* PRC Envelope #3 Rotated 176 x 125 mm */
#define DMPAPER_PENV_4_ROTATED      112 /* PRC Envelope #4 Rotated 208 x 110 mm */
#define DMPAPER_PENV_5_ROTATED      113 /* PRC Envelope #5 Rotated 220 x 110 mm */
#define DMPAPER_PENV_6_ROTATED      114 /* PRC Envelope #6 Rotated 230 x 120 mm */
#define DMPAPER_PENV_7_ROTATED      115 /* PRC Envelope #7 Rotated 230 x 160 mm */
#define DMPAPER_PENV_8_ROTATED      116 /* PRC Envelope #8 Rotated 309 x 120 mm */
#define DMPAPER_PENV_9_ROTATED      117 /* PRC Envelope #9 Rotated 324 x 229 mm */
#define DMPAPER_PENV_10_ROTATED     118 /* PRC Envelope #10 Rotated 458 x 324 mm */
#define DMPAPER_USER                256

#endif
