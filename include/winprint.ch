/*
 * $Id: winprint.ch $
 */
/*
 * ooHG source code:
 * HBPRINTER printing library definitions
 *
 * Copyright 2005-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2018, https://harbour.github.io/
 */
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 */


#ifndef NO_HBPRN_DECLARATION
MEMVAR HBPRN
#endif

#xcommand SET CHANGES GLOBAL ;
   => ;
      hbprn:lGlobalChanges := .T.

#xcommand SET CHANGES LOCAL ;
   => ;
      hbprn:lGlobalChanges := .F.

#xcommand SET DUPLEX VERTICAL ;
   => ;
      hbprn:SetDevMode( DM_DUPLEX, DMDUP_VERTICAL )

#xcommand SET DUPLEX HORIZONTAL ;
   => ;
      hbprn:SetDevMode( DM_DUPLEX, DMDUP_HORIZONTAL )

#xcommand SET DUPLEX OFF ;
   => ;
      hbprn:SetDevMode( DM_DUPLEX, DMDUP_SIMPLEX )

#xcommand SET COLLATE ON ;
   => ;
      hbprn:SetDevMode( DM_COLLATE, DMCOLLATE_TRUE )

#xcommand SET COLLATE OFF ;
   => ;
      hbprn:SetDevMode( DM_COLLATE, DMCOLLATE_FALSE )

#xcommand SET COPIES TO <nCopies> ;
   => ;
      hbprn:SetDevMode( DM_COPIES, <nCopies> )

#xcommand SET SCALE TO <nScale> ;
   => ;
      hbprn:SetDevMode( DM_SCALE, <nScale> )

#xcommand SET PAPERLENGTH TO <nPaperLength> ;
   => ;
      hbprn:SetDevMode( DM_PAPERLENGTH, <nPaperLength> )

#xcommand SET PAPERWIDTH TO <nPaperWidth> ;
   => ;
      hbprn:SetDevMode( DM_PAPERWIDTH, <nPaperWidth> )

#xcommand SET QUALITY <q> ;
   => ;
      hbprn:SetDevMode( DM_PRINTQUALITY, <q> )

#xcommand SET COLORMODE <c> ;
   => ;
      hbprn:SetDevMode( DM_COLOR, <c> )

#xcommand INIT PRINTSYS ;
   => ;
      hbprn := HBPrinter():New()

#xcommand START DOC [ NAME <docname> ] ;
   => ;
      hbprn:StartDoc( <docname> )

#xcommand START PAGE ;
   => ;
      hbprn:StartPage()

#xcommand END PAGE ;
   => ;
      iif( __DYNSISFUN( "TAPPLICATION" ) .AND. _OOHG_ActiveFrame # NIL, Do( "_EndTabPage" ), hbprn:EndPage() )

#xcommand END DOC ;
   => ;
      hbprn:EndDoc()

#xcommand RELEASE PRINTSYS ;
   => ;
      hbprn:End()

#xcommand GET DEFAULT PRINTER TO <cprinter> ;
   => ;
      <cprinter> := hbprn:PrinterDefault

#xcommand GET SELECTED PRINTER TO <cprinter> ;
   => ;
      <cprinter> := hbprn:PrinterName

#xcommand GET PAPERS TO <a_names_numbers> ;
   => ;
      <a_names_numbers> := aClone( hbprn:PaperNames )

#xcommand GET BINS TO <a_names_numbers> ;
   => ;
      <a_names_numbers> := aClone( hbprn:BinNames )

#xcommand GET PRINTERS TO <aprinters> ;
   => ;
      <aprinters> := aClone( hbprn:Printers )

#xcommand GET PORTS TO <aports> ;
   => ;
      <aports> := aClone( hbprn:Ports )

#xtranslate HBPRNMAXROW ;
   => ;
      hbprn:MaxRow

#xtranslate HBPRNMAXCOL ;
   => ;
      hbprn:MaxCol

#xtranslate HBPRNERROR ;
   => ;
      hbprn:Error

#xtranslate HBPRNCOLOR( <clr> ) ;
   => ;
      hbprn:DxColors( <clr> )

#xcommand SELECT BY DIALOG [ <p: PREVIEW> ] ;
   => ;
      hbprn:SelectPrinter( "", <.p.> )

#xcommand SELECT DEFAULT [ <p: PREVIEW> ] ;
   => ;
      hbprn:SelectPrinter( NIL, <.p.> )

#xcommand SELECT PRINTER <cprinter> [ <p: PREVIEW> ] ;
   => ;
      hbprn:SelectPrinter( <cprinter>, <.p.> )

#xcommand ENABLE THUMBNAILS ;
   => ;
      hbprn:Thumbnails := .T.

#xcommand DISABLE THUMBNAILS ;
   => ;
      hbprn:Thumbnails := .F.

#xcommand SET PREVIEW RECT <row>, <col>, <row2>, <col2> ;
   => ;
      hbprn:PreviewRect := { <row>, <col>, <row2>, <col2> }

#xcommand SET PREVIEW SCALE <scale> ;
   => ;
      hbprn:PreviewScale := <scale>

#xcommand SET PAGE ;
      [ ORIENTATION <orient> ] ;
      [ PAPERSIZE <psize> ] ;
      [ FONT <cfont> ] ;
   => ;
      hbprn:SetPage( <orient>, <psize>, <cfont> )

#xcommand SET ORIENTATION PORTRAIT ;
   => ;
      hbprn:SetDevMode( DM_ORIENTATION, DMORIENT_PORTRAIT )

#xcommand SET ORIENTATION LANDSCAPE ;
   => ;
      hbprn:SetDevMode( DM_ORIENTATION, DMORIENT_LANDSCAPE )

#xcommand SET PAPERSIZE <psize> ;
   => ;
      hbprn:SetDevMode( DM_PAPERSIZE, <psize> )

#xcommand SET BIN [ TO ] <prnbin> ;
   => ;
      hbprn:SetDevMode( DM_DEFAULTSOURCE, <prnbin> )

#xcommand SET TEXTCOLOR <clr> ;
   => ;
      hbprn:SetTextColor( <clr> )

#xcommand GET TEXTCOLOR [ TO ] <clr> ;
   => ;
      <clr> := hbprn:GetTexColor()

#xcommand SET BACKCOLOR <clr> ;
   => ;
      hbprn:SetBkColor( <clr> )

#xcommand GET BACKCOLOR [ TO ] <clr> ;
   => ;
      <clr> := hbprn:GetBkColor()

/* Background Modes */
#define BKMODE_TRANSPARENT  1
#define BKMODE_OPAQUE       2
#define BKMODE_LAST         2

#xcommand SET BKMODE <mode> ;
   => ;
      hbprn:SetBkMode( <mode> )

#xcommand SET BKMODE TRANSPARENT ;
   => ;
      hbprn:SetBkMode( BKMODE_TRANSPARENT )

#xcommand SET BKMODE OPAQUE ;
   => ;
      hbprn:SetBkMode( BKMODE_OPAQUE )

#xcommand GET BKMODE [ TO ] <mode> ;
   => ;
      <mode> := hbprn:GetBkMode()

#xcommand SET PRINT MARGINS [ TOP <lm> ] [ LEFT <rm> ] ;
   => ;
      hbprn:SetViewPortOrg( <lm>, <rm> )

#xcommand SET THUMBNAILS ON ;
   => ;
      hbprn:Thumbnails := .T.

#xcommand SET THUMBNAILS OFF ;
   => ;
      hbprn:Thumbnails := .F.

#xcommand SET PREVIEW ON ;
   => ;
      hbprn:PreviewMode := .T.

#xcommand SET PREVIEW OFF ;
   => ;
      hbprn:PreviewMode := .F.

#xcommand DEFINE IMAGELIST <cimglist> ;
      PICTURE <cpicture> ;
      [ ICONCOUNT <nicons> ] ;
   => ;
      hbprn:DefineImagelist( <cimglist>, <cpicture>, <nicons> )

#xcommand @ <row>, <col>, <row2>, <col2> DRAW IMAGELIST <cimglist> ;
      ICON <nicon> ;
      [ NORMAL ] ;
      [ BACKGROUND <color> ] ;
   => ;
      hbprn:DrawImagelist( <cimglist>, <nicon>, <row>, <col>, <row2>, <col2>, ;
            ILD_NORMAL, <color> )

#xcommand @ <row>, <col>, <row2>, <col2> DRAW IMAGELIST <cimglist> ;
      ICON <nicon> ;
      BLEND25 ;
      [ BACKGROUND <color> ] ;
   => ;
      hbprn:DrawImagelist( <cimglist>, <nicon>, <row>, <col>, <row2>, <col2>, ;
            ILD_BLEND25, <color> )

#xcommand @ <row>, <col>, <row2>, <col2> DRAW IMAGELIST <cimglist> ;
      ICON <nicon> ;
      BLEND50 ;
      [ BACKGROUND <color> ] ;
   => ;
      hbprn:DrawImagelist( <cimglist>, <nicon>, <row>, <col>, <row2>, <col2>, ;
            ILD_BLEND50, <color> )

#xcommand @ <row>, <col>, <row2>, <col2> DRAW IMAGELIST <cimglist> ;
      ICON <nicon> ;
      MASK ;
      [ BACKGROUND <color> ] ;
   => ;
      hbprn:DrawImagelist( <cimglist>, <nicon>, <row>, <col>, <row2>, <col2>, ;
            _ILD_MASK, <color> )

#xcommand DEFINE BRUSH <cbrush> ;
      [ STYLE <style> ] ;
      [ COLOR <clr> ] ;
      [ HATCH <hatch> ] ;
   => ;
      hbprn:DefineBrush( <cbrush>, <style>, <clr>, <hatch> )

#xcommand CHANGE BRUSH <cbrush> ;
      [ STYLE <style> ] ;
      [ COLOR <clr> ] ;
      [ HATCH <hatch> ] ;
   => ;
      hbprn:ModifyBrush( <cbrush>, <style>, <clr>, <hatch> )

#xcommand SELECT BRUSH <cbrush> ;
   => ;
      hbprn:SelectBrush( <cbrush> )

#xcommand DEFINE PEN <cpen> ;
      [ STYLE <style> ] ;
      [ WIDTH <width> ] ;
      [ COLOR <clr> ] ;
   => ;
      hbprn:DefinePen( <cpen>, <style>, <width>, <clr> )

#xcommand CHANGE PEN <cpen> ;
      [ STYLE <style> ] ;
      [ WIDTH <width> ] ;
      [ COLOR <clr> ] ;
   => ;
      hbprn:ModifyPen( <cpen>, <style>, <width>, <clr> )

#xcommand SELECT PEN <cpen> ;
   => ;
      hbprn:SelectPen( <cpen> )

#xcommand DEFINE FONT <cfont> ;
      [ NAME <cface> ] ;
      [ SIZE <size> ] ;
      [ WIDTH <width> ] ;
      [ ANGLE <angle> ] ;
      [ <bold: BOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
   => ;
      hbprn:DefineFont( <cfont>, <cface>, <size>, <width>, <angle>, <.bold.>, ;
            <.italic.>, <.underline.>, <.strikeout.>)

#xcommand CHANGE FONT <cfont> ;
      [ NAME <cface> ] ;
      [ SIZE <size> ] ;
      [ WIDTH <width> ] ;
      [ ANGLE <angle> ] ;
      [ <bold: BOLD> ] ;
      [ <nbold: NOBOLD> ] ;
      [ <italic: ITALIC> ] ;
      [ <nitalic: NOITALIC> ] ;
      [ <underline: UNDERLINE> ] ;
      [ <nunderline: NOUNDERLINE> ] ;
      [ <strikeout: STRIKEOUT> ] ;
      [ <nstrikeout: NOSTRIKEOUT> ] ;
   => ;
      hbprn:ModifyFont( <cfont>, <cface>, <size>, <width>, <angle>, <.bold.>, ;
            <.nbold.>, <.italic.>, <.nitalic.>, <.underline.>, <.nunderline.>, <.strikeout.>, <.nstrikeout.> )

#xcommand SELECT FONT <cfont> ;
   => ;
      hbprn:SelectFont( <cfont> )

#xcommand SET CHARSET <charset> ;
   => ;
      hbprn:SetCharSet( <charset> )

#xcommand @ <row>, <col>, <row2>, <col2> DRAW TEXT <txt> ;
      [ STYLE <style> ] ;
      [ FONT <cfont> ] ;
      [ <lNoWordBreak: NOWORDBREAK> ] ;
   => ;
      hbprn:DrawText( <row>, <col>, <row2>, <col2>, <txt>, <style>, <cfont>, ;
            <.lNoWordBreak.>)

#xcommand @ <row>, <col> TEXTOUT <txt> [ FONT <cfont> ] ;
   => ;
      hbprn:TextOut( <row>, <col>, <txt>, <cfont> )

#xcommand @ <row>, <col> SAY <txt> ;
      [ FONT <cfont> ] ;
      [ COLOR <color> ] ;
      [ ALIGN <align> ] ;
      TO PRINT ;
   => ;
      hbprn:Say( <row>, <col>, <txt>, <cfont>, <color>, <align> )

#xcommand @ <row>, <col>, <row2>, <col2> RECTANGLE ;
      [ PEN <cpen> ] ;
      [ BRUSH <cbrush> ] ;
   => ;
      hbprn:Rectangle( <row>, <col>, <row2>, <col2>, <cpen>, <cbrush> )

#xcommand @ <row>, <col>, <row2>, <col2> FILLRECT [ BRUSH <cbrush> ] ;
   => ;
      hbprn:FillRect( <row>, <col>, <row2>, <col2>, <cbrush> )

#xcommand @ <row>, <col>, <row2>, <col2> ROUNDRECT ;
      [ ROUNDR <tor> ] ;
      [ ROUNDC <toc> ] ;
      [ PEN <cpen> ] ;
      [ BRUSH <cbrush> ] ;
   => ;
      hbprn:RoundRect( <row>, <col>, <row2>, <col2>, <tor>, <toc>, <cpen>, ;
            <cbrush> )

#xcommand @ <row>, <col>, <row2>, <col2> FRAMERECT [ BRUSH <cbrush> ] ;
   => ;
      hbprn:FrameRect( <row>, <col>, <row2>, <col2>, <cbrush> )

#xcommand @ <row>, <col>, <row2>, <col2> INVERTRECT ;
   => ;
      hbprn:InvertRect( <row>, <col>, <row2>, <col2> )

#xcommand @ <row>, <col>, <row2>, <col2> ELLIPSE ;
      [ PEN <cpen> ] ;
      [ BRUSH <cbrush> ] ;
   => ;
      hbprn:Ellipse( <row>, <col>, <row2>, <col2>, <cpen>, <cbrush> )

#xcommand @ <row>, <col>, <row2>, <col2> ARC ;
      RADIAL1 <row3>, <col3> ;
      RADIAL2 <row4>, <col4> ;
      [ PEN <cpen> ] ;
   => ;
      hbprn:Arc( <row>, <col>, <row2>, <col2>, <row3>, <col3>, <row4>, <col4>, ;
            <cpen> )

#xcommand @ <row>, <col> ARCTO ;
      RADIAL1 <row3>, <col3> ;
      RADIAL2 <row4>, <col4> ;
      [ PEN <cpen> ] ;
   => ;
      hbprn:ArcTo( <row>, <col>, <row3>, <col3>, <row4>, <col4>, <cpen> )

#xcommand @ <row>, <col>, <row2>, <col2> CHORD ;
      RADIAL1 <row3>, <col3> ;
      RADIAL2 <row4>, <col4> ;
      [ PEN <cpen> ] ;
      [ BRUSH <cbrush> ] ;
   => ;
      hbprn:Chord( <row>, <col>, <row2>, <col2>, <row3>, <col3>, <row4>, ;
            <col4>, <cpen>, <cbrush> )

#xcommand @ <row>, <col>, <row2>, <col2> PIE ;
      RADIAL1 <row3>, <col3> ;
      RADIAL2 <row4>, <col4> ;
      [ PEN <cpen> ] ;
      [ BRUSH <cbrush> ] ;
   => ;
      hbprn:Pie( <row>, <col>, <row2>, <col2>, <row3>, <col3>, <row4>, <col4>, ;
            <cpen>, <cbrush> )

#xcommand POLYGON <apoints> ;
      [ PEN <cpen> ] ;
      [ BRUSH <cbrush> ] ;
      [ STYLE <style> ] ;
   => ;
      hbprn:Polygon( <apoints>, <cpen>, <cbrush>, <style> )

#xcommand POLYBEZIER <apoints> [ PEN <cpen> ] ;
   => ;
      hbprn:Polybezier( <apoints>, <cpen> )

#xcommand POLYBEZIERTO <apoints> [ PEN <cpen> ] ;
   => ;
       hbprn:PolybezierTo( <apoints>, <cpen> )

#xcommand SET UNITS ;
   => ;
      hbprn:SetUnits( 0 )

#xcommand SET UNITS <units: ROWCOL, MM, INCHES, PIXELS> ;
      [ <absolute: ABSOLUTE> ] ;
   => ;
      hbprn:SetUnits( <"units">,,, <.absolute.> )

#xcommand SET UNITS ROWS <r> COLS <c> [ <absolute: ABSOLUTE> ] ;
   => ;
      hbprn:SetUnits( 4, <r>, <c>, <.absolute.> )

#xcommand DEFINE RECT REGION <creg> AT <row>, <col>, <row2>, <col2> ;
   => ;
      hbprn:DefineRectRgn( <creg>, <row>, <col>, <row2>, <col2> )

#xcommand DEFINE POLYGON REGION <creg> VERTEX <apoints> [ STYLE <style> ] ;
   => ;
      hbprn:DefinePolygonRgn( <creg>, <apoints>, <style> )

#xcommand DEFINE ELLIPTIC REGION <creg> AT <row>, <col>, <row2>, <col2> ;
   => ;
      hbprn:DefineEllipticRgn( <creg>, <row>, <col>, <row2>, <col2> )

#xcommand DEFINE ROUNDRECT REGION <creg> ;
      AT <row>, <col>, <row2>, <col2> ;
      ELLIPSE <ewidth>, <eheight> ;
   => ;
      hbprn:DefineRoundrectRgn( <creg>, <row>, <col>, <row2>, <col2>, ;
            <ewidth>, <eheight> )

#xcommand COMBINE REGIONS <creg1>, <creg2> TO <creg> [ STYLE <style> ] ;
   => ;
      hbprn:CombineRgn( <creg>, <creg1>, <creg2>, <style> )

#xcommand SELECT CLIP REGION <creg> ;
   => ;
      hbprn:SelectClipRgn( <creg> )

#xcommand DELETE CLIP REGION ;
   => ;
      hbprn:DeleteClipRgn()

#xcommand SET POLYFILL MODE <mode> ;
   => ;
      hbprn:SetPolyFillMode( <mode> )

#xcommand SET POLYFILL MODE ALTERNATE ;
   => ;
      hbprn:SetPolyFillMode( POLYFILL_ALTERNATE )

#xcommand SET POLYFILL MODE WINDING ;
   => ;
      hbprn:SetPolyFillMode( POLYFILL_WINDING )

#xcommand SET POLYFILL ALTERNATE ;
   => ;
      hbprn:SetPolyFillMode( POLYFILL_ALTERNATE )

#xcommand SET POLYFILL WINDING ;
   => ;
      hbprn:SetPolyFillMode( POLYFILL_WINDING )

#xcommand GET POLYFILL MODE TO <mode> ;
   => ;
      <mode> := hbprn:GetPolyFillMode()

#xcommand SET VIEWPORTORG <row>, <col> ;
   => ;
      hbprn:SetViewPortOrg( <row>, <col> )

#xcommand GET VIEWPORTORG TO <aviewport> ;
   => ;
      hbprn:GetViewPortOrg() ; <aviewport> := aClone( hbprn:ViewPortOrg )

#xcommand SET RGB <red>, <green>, <blue> TO <nrgb> ;
   => ;
      <nrgb> := hbprn:SetRGB( <red>, <green>, <blue> )

#xcommand SET TEXTCHAR EXTRA <col> ;
   => ;
      hbprn:SetTextCharExtra( <col> )

#xcommand GET TEXTCHAR EXTRA TO <col> ;
   => ;
      <col> := hbprn:GetTextCharExtra()

#xcommand SET TEXT JUSTIFICATION <col> ;
   => ;
      hbprn:SetTextJustification( <col> )

#xcommand GET TEXT JUSTIFICATION TO <col> ;
   => ;
      <col> := hbprn:GetTextJustification()

#xcommand SET TEXT ALIGN <style> ;
   => ;
      hbprn:SetTextAlign( <style> )

#xcommand SET TEXT ALIGN LEFT ;
   => ;
      hbprn:SetTextAlign( TA_LEFT )

#xcommand SET TEXT ALIGN RIGHT ;
   => ;
      hbprn:SetTextAlign( TA_RIGHT )

#xcommand SET TEXT ALIGN CENTER ;
   => ;
      hbprn:SetTextAlign( TA_CENTER )

#xcommand GET TEXT ALIGN TO <style> ;
   => ;
      <style> := hbprn:GetTextAlign()

#xcommand @ <row>, <col> PICTURE <cpic> SIZE <row2>, <col2> ;
      [ EXTEND <row3>, <col3> ] ;
   => ;
      hbprn:Picture( <row>, <col>, <row2>, <col2>, <cpic>, <row3>, <col3> )

#xcommand @ <row>, <col> PICTURE <cpic> IMAGESIZE ;
   => ;
      hbprn:Picture( <row>, <col>,,, <cpic>,,, .T. )

#xcommand @ <row>, <col>, <row2>, <col2> LINE [ PEN <cpen> ] ;
   => ;
      hbprn:Line( <row>, <col>, <row2>, <col2>, <cpen> )

#xcommand @ <row>, <col> LINETO [ PEN <cpen> ] ;
   => ;
      hbprn:LineTo( <row>, <col>, <cpen> )

#xcommand GET TEXT EXTENT <txt> [ FONT <cfont> ] TO <asize> ;
   => ;
      hbprn:GetTextExtent( <txt>, <asize>, <cfont> )

/*---------------------------------------------------------------------------
FIELD SELECTION BITS FOR SETDEVMODE "WHAT" PARAMETER
---------------------------------------------------------------------------*/

#define DM_ORIENTATION                        0x00000001
#define DM_PAPERSIZE                          0x00000002
#define DM_PAPERLENGTH                        0x00000004
#define DM_PAPERWIDTH                         0x00000008
#define DM_SCALE                              0x00000010
#define DM_POSITION                           0x00000020
#define DM_NUP                                0x00000040
#define DM_COPIES                             0x00000100
#define DM_DEFAULTSOURCE                      0x00000200
#define DM_PRINTQUALITY                       0x00000400
#define DM_COLOR                              0x00000800
#define DM_DUPLEX                             0x00001000
#define DM_YRESOLUTION                        0x00002000
#define DM_TTOPTION                           0x00004000
#define DM_COLLATE                            0x00008000
#define DM_FORMNAME                           0x00010000
#define DM_LOGPIXELS                          0x00020000
#define DM_BITSPERPEL                         0x00040000
#define DM_PELSWIDTH                          0x00080000
#define DM_PELSHEIGHT                         0x00100000
#define DM_DISPLAYFLAGS                       0x00200000
#define DM_DISPLAYFREQUENCY                   0x00400000
#define DM_ICMMETHOD                          0x00800000
#define DM_ICMINTENT                          0x01000000
#define DM_MEDIATYPE                          0x02000000
#define DM_DITHERTYPE                         0x04000000
#define DM_PANNINGWIDTH                       0x08000000
#define DM_PANNINGHEIGHT                      0x10000000

/*---------------------------------------------------------------------------
BIN SELECTIONS
---------------------------------------------------------------------------*/

#define DMBIN_FIRST                           DMBIN_UPPER
#define DMBIN_UPPER                           1
#define DMBIN_ONLYONE                         1
#define DMBIN_LOWER                           2
#define DMBIN_MIDDLE                          3
#define DMBIN_MANUAL                          4
#define DMBIN_ENVELOPE                        5
#define DMBIN_ENVMANUAL                       6
#define DMBIN_AUTO                            7
#define DMBIN_TRACTOR                         8
#define DMBIN_SMALLFMT                        9
#define DMBIN_LARGEFMT                        10
#define DMBIN_LARGECAPACITY                   11
#define DMBIN_CASSETTE                        14
#define DMBIN_FORMSOURCE                      15
#define DMBIN_LAST                            DMBIN_FORMSOURCE
#define DMBIN_USER                            256 // device specific bins start here

/*---------------------------------------------------------------------------
COLLATE
---------------------------------------------------------------------------*/

#define DMCOLLATE_TRUE                        1
#define DMCOLLATE_FALSE                       0

/*---------------------------------------------------------------------------
ORIENTATION
---------------------------------------------------------------------------*/

#define DMORIENT_PORTRAIT                     1
#define DMORIENT_LANDSCAPE                    2

/*---------------------------------------------------------------------------
COLOR ENABLE/DISABLE FOR COLOR PRINTERS
---------------------------------------------------------------------------*/

#define DMCOLOR_MONOCHROME                    1
#define DMCOLOR_COLOR                         2

/*---------------------------------------------------------------------------
PRINT QUALITY
---------------------------------------------------------------------------*/

#define DMRES_DRAFT                           (-1)
#define DMRES_LOW                             (-2)
#define DMRES_MEDIUM                          (-3)
#define DMRES_HIGH                            (-4)

/*---------------------------------------------------------------------------
IMAGELIST DRAWING STYLES
---------------------------------------------------------------------------*/

#define ILD_NORMAL                            0x0000
#define ILD_MASK                              0x0010
#define ILD_BLEND25                           0x0002
#define ILD_BLEND50                           0x0004

/*---------------------------------------------------------------------------
BRUSH STYLES
---------------------------------------------------------------------------*/

#define BS_SOLID                              0
#define BS_NULL                               1
#define BS_HOLLOW                             BS_NULL
#define BS_HATCHED                            2
#define BS_PATTERN                            3
#define BS_INDEXED                            4
#define BS_DIBPATTERN                         5
#define BS_DIBPATTERNPT                       6
#define BS_PATTERN8X8                         7
#define BS_DIBPATTERN8X8                      8
#define BS_MONOPATTERN                        9

/*---------------------------------------------------------------------------
HATCH STYLES
---------------------------------------------------------------------------*/

#define HS_HORIZONTAL                         0       /* ----- */
#define HS_VERTICAL                           1       /* ||||| */
#define HS_FDIAGONAL                          2       /* \\\\\ */
#define HS_BDIAGONAL                          3       /* ///// */
#define HS_CROSS                              4       /* +++++ */
#define HS_DIAGCROSS                          5       /* xxxxx */

/*---------------------------------------------------------------------------
PEN STYLES
---------------------------------------------------------------------------*/

#define PS_SOLID                              0
#define PS_DASH                               1       /* -------  */
#define PS_DOT                                2       /* .......  */
#define PS_DASHDOT                            3       /* _._._._  */
#define PS_DASHDOTDOT                         4       /* _.._.._  */
#define PS_NULL                               5
#define PS_INSIDEFRAME                        6
#define PS_USERSTYLE                          7
#define PS_ALTERNATE                          8
#define PS_STYLE_MASK                         0x0000000F

/*---------------------------------------------------------------------------
COMBINERGN() STYLES
---------------------------------------------------------------------------*/

#define RGN_AND                               1
#define RGN_OR                                2
#define RGN_XOR                               3
#define RGN_DIFF                              4
#define RGN_COPY                              5
#define RGN_MIN                               RGN_AND
#define RGN_MAX                               RGN_COPY

/*---------------------------------------------------------------------------
POLYFILL() MODES
---------------------------------------------------------------------------*/

#define POLYFILL_ALTERNATE                    1
#define POLYFILL_WINDING                      2
#define POLYFILL_LAST                         2

/*---------------------------------------------------------------------------
TEXT ALIGNMENT OPTIONS
---------------------------------------------------------------------------*/

#define TA_NOUPDATECP                         0
#define TA_UPDATECP                           1
#define TA_LEFT                               0
#define TA_RIGHT                              2
#define TA_CENTER                             6
#define TA_TOP                                0
#define TA_BOTTOM                             8
#define TA_BASELINE                           24
#define TA_RTLREADING                         256
#define TA_MASK                               ( TA_BASELINE + TA_CENTER + TA_UPDATECP + TA_RTLREADING )

/*---------------------------------------------------------------------------
SCROLL BAR CONSTANTS
---------------------------------------------------------------------------*/

#define SB_HORZ                               0
#define SB_VERT                               1
#define SB_CTL                                2
#define SB_BOTH                               3

/*---------------------------------------------------------------------------
DRAWTEXT() FORMAT FLAGS
---------------------------------------------------------------------------*/

#define DT_TOP                                0x00000000
#define DT_LEFT                               0x00000000
#define DT_CENTER                             0x00000001
#define DT_RIGHT                              0x00000002
#define DT_VCENTER                            0x00000004
#define DT_BOTTOM                             0x00000008
#define DT_WORDBREAK                          0x00000010
#define DT_SINGLELINE                         0x00000020
#define DT_EXPANDTABS                         0x00000040
#define DT_TABSTOP                            0x00000080
#define DT_NOCLIP                             0x00000100
#define DT_EXTERNALLEADING                    0x00000200
#define DT_CALCRECT                           0x00000400
#define DT_NOPREFIX                           0x00000800
#define DT_INTERNAL                           0x00001000
#define DT_EDITCONTROL                        0x00002000
#define DT_PATH_ELLIPSIS                      0x00004000
#define DT_END_ELLIPSIS                       0x00008000
#define DT_MODIFYSTRING                       0x00010000
#define DT_RTLREADING                         0x00020000
#define DT_WORD_ELLIPSIS                      0x00040000
#define DT_NOFULLWIDTHCHARBREAK               0x00080000
#define DT_HIDEPREFIX                         0x00100000
#define DT_PREFIXONLY                         0x00200000

/*---------------------------------------------------------------------------
CHARSET CONSTANTS
---------------------------------------------------------------------------*/

#ifndef __OOHG_I_FONT__

#define ANSI_CHARSET                          0
#define DEFAULT_CHARSET                       1
#define SYMBOL_CHARSET                        2
#define SHIFTJIS_CHARSET                      128
#define HANGEUL_CHARSET                       129
#define HANGUL_CHARSET                        129
#define GB2312_CHARSET                        134
#define CHINESEBIG5_CHARSET                   136
#define OEM_CHARSET                           255
#define JOHAB_CHARSET                         130
#define HEBREW_CHARSET                        177
#define ARABIC_CHARSET                        178
#define GREEK_CHARSET                         161
#define TURKISH_CHARSET                       162
#define VIETNAMESE_CHARSET                    163
#define THAI_CHARSET                          222
#define EASTEUROPE_CHARSET                    238
#define RUSSIAN_CHARSET                       204
#define MAC_CHARSET                           77
#define BALTIC_CHARSET                        186

#endif

/*---------------------------------------------------------------------------
STOCK LOGICAL OBJECTS
---------------------------------------------------------------------------*/

#define WHITE_BRUSH                           0
#define LTGRAY_BRUSH                          1
#define GRAY_BRUSH                            2
#define DKGRAY_BRUSH                          3
#define BLACK_BRUSH                           4
#define NULL_BRUSH                            5
#define HOLLOW_BRUSH                          NULL_BRUSH
#define WHITE_PEN                             6
#define BLACK_PEN                             7
#define NULL_PEN                              8
#define OEM_FIXED_FONT                        10
#define ANSI_FIXED_FONT                       11
#define ANSI_VAR_FONT                         12
#define SYSTEM_FONT                           13
#define DEVICE_DEFAULT_FONT                   14
#define DEFAULT_PALETTE                       15
#define SYSTEM_FIXED_FONT                     16

/*---------------------------------------------------------------------------
DUPLEX
---------------------------------------------------------------------------*/

#define DMDUP_SIMPLEX                         1
#define DMDUP_VERTICAL                        2
#define DMDUP_HORIZONTAL                      3

/*---------------------------------------------------------------------------
PREDEFINED VALUES FOR SETDEVMODE() PAPERSIZE
---------------------------------------------------------------------------*/

#ifndef DMPAPER_FIRST

#define DMPAPER_FIRST                         DMPAPER_LETTER
#define DMPAPER_LETTER                        1   // US Letter 8 1/2 x 11 in
#define DMPAPER_LETTERSMALL                   2   // US Letter Small 8 1/2 x 11 in
#define DMPAPER_TABLOID                       3   // US Tabloid 11 x 17 in
#define DMPAPER_LEDGER                        4   // US Ledger 17 x 11 in
#define DMPAPER_LEGAL                         5   // US Legal 8 1/2 x 14 in
#define DMPAPER_STATEMENT                     6   // US Statement 5 1/2 x 8 1/2 in
#define DMPAPER_EXECUTIVE                     7   // US Executive 7 1/4 x 10 1/2 in
#define DMPAPER_A3                            8   // A3 297 x 420 mm
#define DMPAPER_A4                            9   // A4 210 x 297 mm
#define DMPAPER_A4SMALL                       10  // A4 Small 210 x 297 mm
#define DMPAPER_A5                            11  // A5 148 x 210 mm
#define DMPAPER_B4                            12  // B4 (JIS) 257 x 364 mm
#define DMPAPER_B5                            13  // B5 (JIS) 182 x 257 mm
#define DMPAPER_FOLIO                         14  // Folio 8 1/2 x 13 in
#define DMPAPER_QUARTO                        15  // Quarto 215 x 275 mm
#define DMPAPER_10X14                         16  // 10x14 in
#define DMPAPER_11X17                         17  // 11x17 in
#define DMPAPER_NOTE                          18  // US Note 8 1/2 x 11 in
#define DMPAPER_ENV_9                         19  // US Envelope #9 3 7/8 x 8 7/8 in
#define DMPAPER_ENV_10                        20  // US Envelope #10 4 1/8 x 9 1/2 in
#define DMPAPER_ENV_11                        21  // US Envelope #11 4 1/2 x 10 3/8 in
#define DMPAPER_ENV_12                        22  // US Envelope #12 4 3/4 x 11 in
#define DMPAPER_ENV_14                        23  // US Envelope #14 5 x 11 1/2 in
#define DMPAPER_CSHEET                        24  // C size sheet 17 X 22 in
#define DMPAPER_DSHEET                        25  // D size sheet 22 X 34 in
#define DMPAPER_ESHEET                        26  // E size sheet 34 x 44 in
#define DMPAPER_ENV_DL                        27  // Envelope DL 110 x 220 mm
#define DMPAPER_ENV_C5                        28  // Envelope C5 162 x 229 mm
#define DMPAPER_ENV_C3                        29  // Envelope C3 324 x 458 mm
#define DMPAPER_ENV_C4                        30  // Envelope C4 229 x 324 mm
#define DMPAPER_ENV_C6                        31  // Envelope C6 114 x 162 mm
#define DMPAPER_ENV_C65                       32  // Envelope C65 114 x 229 mm
#define DMPAPER_ENV_B4                        33  // Envelope B4 250 x 353 mm
#define DMPAPER_ENV_B5                        34  // Envelope B5 176 x 250 mm
#define DMPAPER_ENV_B6                        35  // Envelope B6 176 x 125 mm
#define DMPAPER_ENV_ITALY                     36  // Envelope 110 x 230 mm
#define DMPAPER_ENV_MONARCH                   37  // US Envelope Monarch 3 7/8 x 7 1/2 in
#define DMPAPER_ENV_PERSONAL                  38  // 6 3/4 US Envelope 3 5/8 x 6 1/2 in
#define DMPAPER_FANFOLD_US                    39  // US Std Fanfold 14 7/8 x 11 in
#define DMPAPER_FANFOLD_STD_GERMAN            40  // German Std Fanfold 8 1/2 x 12 in
#define DMPAPER_FANFOLD_LGL_GERMAN            41  // German Legal Fanfold 8 1/2 x 13 in
#define DMPAPER_ISO_B4                        42  // B4 (ISO) 250 x 353 mm
#define DMPAPER_JAPANESE_POSTCARD             43  // Japanese Postcard 100 x 148 mm
#define DMPAPER_9X11                          44  // 9 x 11 in
#define DMPAPER_10X11                         45  // 10 x 11 in
#define DMPAPER_15X11                         46  // 15 x 11 in
#define DMPAPER_ENV_INVITE                    47  // Envelope Invite 220 x 220 mm
#define DMPAPER_RESERVED_48                   48  // RESERVED--DO NOT USE
#define DMPAPER_RESERVED_49                   49  // RESERVED--DO NOT USE
#define DMPAPER_LETTER_EXTRA                  50  // US Letter Extra 9 1/2 x 12 in
#define DMPAPER_LEGAL_EXTRA                   51  // US Legal Extra 9 1/2 x 15 in
#define DMPAPER_TABLOID_EXTRA                 52  // US Tabloid Extra 11.69 x 18 in
#define DMPAPER_A4_EXTRA                      53  // A4 Extra 9.27 x 12.69 in
#define DMPAPER_LETTER_TRANSVERSE             54  // Letter Transverse 8 1/2 x 11 in
#define DMPAPER_A4_TRANSVERSE                 55  // A4 Transverse 210 x 297 mm
#define DMPAPER_LETTER_EXTRA_TRANSVERSE       56  // Letter Extra Transverse 9 1/2 x 12 in
#define DMPAPER_A_PLUS                        57  // SuperA/SuperA/A4 227 x 356 mm
#define DMPAPER_B_PLUS                        58  // SuperB/SuperB/A3 305 x 487 mm
#define DMPAPER_LETTER_PLUS                   59  // US Letter Plus 8.5 x 12.69 in
#define DMPAPER_A4_PLUS                       60  // A4 Plus 210 x 330 mm
#define DMPAPER_A5_TRANSVERSE                 61  // A5 Transverse 148 x 210 mm
#define DMPAPER_B5_TRANSVERSE                 62  // B5 (JIS) Transverse 182 x 257 mm
#define DMPAPER_A3_EXTRA                      63  // A3 Extra 322 x 445 mm
#define DMPAPER_A5_EXTRA                      64  // A5 Extra 174 x 235 mm
#define DMPAPER_B5_EXTRA                      65  // B5 (ISO) Extra 201 x 276 mm
#define DMPAPER_A2                            66  // A2 420 x 594 mm
#define DMPAPER_A3_TRANSVERSE                 67  // A3 Transverse 297 x 420 mm
#define DMPAPER_A3_EXTRA_TRANSVERSE           68  // A3 Extra Transverse 322 x 445 mm
#define DMPAPER_DBL_JAPANESE_POSTCARD         69  // Japanese Double Postcard 200 x 148 mm
#define DMPAPER_A6                            70  // A6 105 x 148 mm
#define DMPAPER_JENV_KAKU2                    71  // Japanese Envelope Kaku #2
#define DMPAPER_JENV_KAKU3                    72  // Japanese Envelope Kaku #3
#define DMPAPER_JENV_CHOU3                    73  // Japanese Envelope Chou #3
#define DMPAPER_JENV_CHOU4                    74  // Japanese Envelope Chou #4
#define DMPAPER_LETTER_ROTATED                75  // Letter Rotated 11 x 8 1/2 in
#define DMPAPER_A3_ROTATED                    76  // A3 Rotated 420 x 297 mm
#define DMPAPER_A4_ROTATED                    77  // A4 Rotated 297 x 210 mm
#define DMPAPER_A5_ROTATED                    78  // A5 Rotated 210 x 148 mm
#define DMPAPER_B4_JIS_ROTATED                79  // B4 (JIS) Rotated 364 x 257 mm
#define DMPAPER_B5_JIS_ROTATED                80  // B5 (JIS) Rotated 257 x 182 mm
#define DMPAPER_JAPANESE_POSTCARD_ROTATED     81  // Japanese Postcard Rotated 148 x 100 mm
#define DMPAPER_DBL_JAPANESE_POSTCARD_ROTATED 82  // Double Japanese Postcard Rotated 148 x 200 mm
#define DMPAPER_A6_ROTATED                    83  // A6 Rotated 148 x 105 mm
#define DMPAPER_JENV_KAKU2_ROTATED            84  // Japanese Envelope Kaku #2 Rotated
#define DMPAPER_JENV_KAKU3_ROTATED            85  // Japanese Envelope Kaku #3 Rotated
#define DMPAPER_JENV_CHOU3_ROTATED            86  // Japanese Envelope Chou #3 Rotated
#define DMPAPER_JENV_CHOU4_ROTATED            87  // Japanese Envelope Chou #4 Rotated
#define DMPAPER_B6_JIS                        88  // B6 (JIS) 128 x 182 mm
#define DMPAPER_B6_JIS_ROTATED                89  // B6 (JIS) Rotated 182 x 128 mm
#define DMPAPER_12X11                         90  // 12 x 11 in
#define DMPAPER_JENV_YOU4                     91  // Japanese Envelope You #4
#define DMPAPER_JENV_YOU4_ROTATED             92  // Japanese Envelope You #4 Rotated
#define DMPAPER_P16K                          93  // PRC 16K 146 x 215 mm
#define DMPAPER_P32K                          94  // PRC 32K 97 x 151 mm
#define DMPAPER_P32KBIG                       95  // PRC 32K(Big) 97 x 151 mm
#define DMPAPER_PENV_1                        96  // PRC Envelope #1 102 x 165 mm
#define DMPAPER_PENV_2                        97  // PRC Envelope #2 102 x 176 mm
#define DMPAPER_PENV_3                        98  // PRC Envelope #3 125 x 176 mm
#define DMPAPER_PENV_4                        99  // PRC Envelope #4 110 x 208 mm
#define DMPAPER_PENV_5                        100 // PRC Envelope #5 110 x 220 mm
#define DMPAPER_PENV_6                        101 // PRC Envelope #6 120 x 230 mm
#define DMPAPER_PENV_7                        102 // PRC Envelope #7 160 x 230 mm
#define DMPAPER_PENV_8                        103 // PRC Envelope #8 120 x 309 mm
#define DMPAPER_PENV_9                        104 // PRC Envelope #9 229 x 324 mm
#define DMPAPER_PENV_10                       105 // PRC Envelope #10 324 x 458 mm
#define DMPAPER_P16K_ROTATED                  106 // PRC 16K Rotated 215 x 146 mm
#define DMPAPER_P32K_ROTATED                  107 // PRC 32K Rotated 151 x 97 mm
#define DMPAPER_P32KBIG_ROTATED               108 // PRC 32K(Big) Rotated 151 x 97 mm
#define DMPAPER_PENV_1_ROTATED                109 // PRC Envelope #1 Rotated 165 x 102 mm
#define DMPAPER_PENV_2_ROTATED                110 // PRC Envelope #2 Rotated 176 x 102 mm
#define DMPAPER_PENV_3_ROTATED                111 // PRC Envelope #3 Rotated 176 x 125 mm
#define DMPAPER_PENV_4_ROTATED                112 // PRC Envelope #4 Rotated 208 x 110 mm
#define DMPAPER_PENV_5_ROTATED                113 // PRC Envelope #5 Rotated 220 x 110 mm
#define DMPAPER_PENV_6_ROTATED                114 // PRC Envelope #6 Rotated 230 x 120 mm
#define DMPAPER_PENV_7_ROTATED                115 // PRC Envelope #7 Rotated 230 x 160 mm
#define DMPAPER_PENV_8_ROTATED                116 // PRC Envelope #8 Rotated 309 x 120 mm
#define DMPAPER_PENV_9_ROTATED                117 // PRC Envelope #9 Rotated 324 x 229 mm
#define DMPAPER_PENV_10_ROTATED               118 // PRC Envelope #10 Rotated 458 x 324 mm
#define DMPAPER_LAST                          DMPAPER_PENV_10_ROTATED
#define DMPAPER_USER                          256

#endif
