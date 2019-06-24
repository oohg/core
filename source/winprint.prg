/*
 * $Id: winprint.prg $
 */
/*
 * ooHG source code:
 * HBPRINTER printing library
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Based upon:
 * HBPRINT and HBPRINTER libraries
 * Copyright 2002 Richard Rylko <rrylko@poczta.onet.pl>
 * http://rrylko.republika.pl
 * Original contributions made by
 * Eduardo Fernandes <modalsist@yahoo.com.br> and
 * Mitja Podgornik <yamamoto@rocketmail.com>
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2019 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2019 Contributors, https://harbour.github.io/
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


#include "hbclass.ch"

/*
 * Define NO_GUI macro for non-ooHG compilation.
 * It allows to compile HBPRINTER library for console mode.
 * Fully functional but no preview.
 */

#ifndef NO_GUI
   #include "oohg.ch"
#endif

#define NO_HBPRN_DECLARATION
#include "winprint.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS HBPrinter

   DATA hDC                     INIT 0
   DATA hDCRef                  INIT 0
   DATA PrinterName             INIT ""
   DATA nFromPage               INIT 1
   DATA nToPage                 INIT 0
   DATA CurPage                 INIT 1
   DATA nCopies                 INIT 1
   DATA nWhatToPrint            INIT 0
   DATA PrintOpt                INIT 1
   DATA PrinterDefault          INIT ""
   DATA Error                   INIT 0
   DATA PaperNames              INIT {}
   DATA BinNames                INIT {}
   DATA DocName                 INIT "HBPRINTER"
   DATA TextColor               INIT 0
   DATA BkColor                 INIT 0xFFFFFF
   DATA BkMode                  INIT BKMODE_TRANSPARENT
   DATA PolyFillMode            INIT 1
   DATA Cargo                   INIT { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
   DATA Fonts                   INIT { {}, {}, 0, {} }
   DATA Brushes                 INIT { {}, {} }
   DATA Pens                    INIT { {}, {} }
   DATA Regions                 INIT { {}, {} }
   DATA Imagelists              INIT { {}, {} }
   DATA Units                   INIT 0
   DATA DevCaps                 INIT { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 }
   DATA MAxRow                  INIT 0
   DATA MaxCol                  INIT 0
   DATA MetaFiles               INIT {}
   DATA PreviewMode             INIT .F.
   DATA Thumbnails              INIT .F.
   DATA Viewportorg             INIT { 0, 0 }
   DATA PreviewRect             INIT { 0, 0, 0, 0 }
   DATA PrintingEMF             INIT .F.
   DATA Printing                INIT .F.
   DATA PreviewScale            INIT 1
   DATA Printers                INIT {}
   DATA Ports                   INIT {}
   DATA iLoscstron              INIT 0
   DATA nGroup                  INIT -1
   DATA Page                    INIT 1
   DATA AtH                     INIT {}
   DATA dx                      INIT 0
   DATA dy                      INIT 0
   DATA AHs                     INIT {}
   DATA aZoom                   INIT { 0, 0, 0, 0 }
   DATA Scale                   INIT 1
   DATA npages                  INIT {}
   DATA aOpisy                  INIT {}
   DATA oWinPreview             INIT NIL
   DATA oWinPrOpt               INIT NIL
   DATA oWinPagePreview         INIT NIL
   DATA oWinThumbs              INIT NIL
   DATA NoButtonSave            INIT .F.
   DATA NoButtonOptions         INIT .F.
   DATA BeforePrint             INIT {|| .T. }
   DATA AfterPrint              INIT {|| NIL }
   DATA BeforePrintCopy         INIT {|| .T. }
   DATA InMemory                INIT .F.
   DATA TimeStamp               INIT ""
   DATA BaseDoc                 INIT ""
   DATA lGlobalChanges          INIT .T.
   DATA lAbsoluteCoords         INIT .F.
   DATA hData                   INIT 0

   METHOD New
   METHOD SelectPrinter
   METHOD SetDevMode
   METHOD StartDoc
   METHOD SetPage
   METHOD StartPage
   METHOD EndPage
   METHOD EndDoc
   METHOD SetTextColor
   METHOD GetTextColor          INLINE ::TextColor
   METHOD SetBkColor
   METHOD GetBkColor            INLINE ::BkColor
   METHOD SetBkMode
   METHOD GetBkMode             INLINE ::BkMode
   METHOD DefineImageList
   METHOD DrawImageList
   METHOD DefineBrush
   METHOD ModifyBrush
   METHOD SelectBrush
   METHOD DefinePen
   METHOD ModifyPen
   METHOD SelectPen
   METHOD DefineFont
   METHOD ModifyFont
   METHOD SelectFont
   METHOD GetObjByName
   METHOD DrawText
   METHOD TextOut
   METHOD Say
   METHOD SetCharset( charset ) INLINE RR_SETCHARSET( charset, ::hData, Self )
   METHOD Rectangle
   METHOD RoundRect
   METHOD FillRect
   METHOD FrameRect
   METHOD InvertRect
   METHOD Ellipse
   METHOD Arc
   METHOD ArcTo
   METHOD Chord
   METHOD Pie
   METHOD Polygon
   METHOD PolyBezier
   METHOD PolyBezierTo
   METHOD SetUnits
   METHOD Convert
   METHOD DefineRectRgn
   METHOD DefinePolygonRgn
   METHOD DefineEllipticRgn
   METHOD DefineRoundRectRgn
   METHOD CombineRgn
   METHOD SelectClipRgn
   METHOD DeleteClipRgn
   METHOD SetPolyFillMode
   METHOD GetPolyFillMode       INLINE ::PolyFillMode
   METHOD SetViewPortOrg
   METHOD GetViewPortOrg
   METHOD DxColors
   METHOD SetRGB
   METHOD SetTextCharExtra
   METHOD GetTextCharExtra
   METHOD SetTextJustification
   METHOD GetTextJustification
   METHOD SetTextAlign
   METHOD GetTextAlign
   METHOD Picture
   METHOD Line
   METHOD LineTo
   METHOD End
   METHOD SaveMetaFiles
   METHOD GetTextExtent
   METHOD ReportData
#ifndef NO_GUI
   METHOD Preview
   METHOD PrevAdjust
   METHOD PrevClose
   METHOD PrevPrint
   METHOD PrevShow
   METHOD PrevThumb
   METHOD PrintOption
#endif

   ENDCLASS

METHOD New() CLASS HBPrinter

   LOCAL aPrnPort

   ::hData := RR_CREATEHBPRINTERDATA()

   aPrnPort := RR_GETPRINTERS( ::hData )
   IF ! aPrnPort == ",,"
      aPrnPort := RR_STR2ARR( aPrnPort, ",," )
      AEval( aPrnPort, {| x, xi | aPrnPort[ xi ] := RR_STR2ARR( x, ',' ) } )
      AEval( aPrnPort, {| x | AAdd( ::Printers, x[ 1 ] ), AAdd( ::Ports, x[ 2 ] ) } )
      ::PrinterDefault := GetDefaultPrinter()
   ELSE
      ::Error := 1
   ENDIF
   ::TimeStamp := TToS( DateTime() )
   ::BaseDoc := RR_GETTEMPFOLDER() + '\' + ::TimeStamp + "_HBPrinter_preview_"

   RETURN Self

METHOD SelectPrinter( cPrinter, lPrev ) CLASS HBPrinter

   LOCAL txtp := "", txtb := "", t := { 0, 0, 1, .T. }

   IF cPrinter == NIL
      ::hDCRef := RR_GETDC( ::PrinterDefault, ::hData )
      ::hDC := ::hDCRef
      ::PrinterName := ::PrinterDefault
   ELSEIF Empty( cPrinter )
      ::hDCRef := RR_PRINTDIALOG( t, ::hData )
      ::nfrompage := t[ 1 ]
      ::ntopage := t[ 2 ]
      ::ncopies := t[ 3 ]
      ::nwhattoprint := t[ 4 ]
      ::hDC := ::hDCRef
      ::PrinterName := RR_PRINTERNAME( ::hData )
   ELSE
      ::hDCRef := RR_GETDC( cPrinter, ::hData )
      ::hDC := ::hDCRef
      ::PrinterName := cPrinter
   ENDIF
   IF HB_ISLOGICAL( lPrev )
      #ifndef NO_GUI
         IF lprev
            ::PreviewMode := .T.
         ENDIF
      #else
         ::PreviewMode := .F.
      #endif
   ENDIF
   IF ::hDC == 0
      ::error := 1
      ::PrinterName := ""
   ELSE
      RR_DEVICECAPABILITIES( @txtp, @txtb, ::hData )
      ::PaperNames := RR_STR2ARR( txtp, ",," )
      ::BinNames := RR_STR2ARR( txtb, ",," )
      AEval( ::BinNames, {| x, xi | ::BinNames[ xi ] := RR_STR2ARR( x, ',' ) } )
      AEval( ::PaperNames, {| x, xi | ::PaperNames[ xi ] := RR_STR2ARR( x, ',' ) } )
      AAdd( ::Fonts[ 1 ], RR_GETCURRENTOBJECT( 1, ::hData ) ) ; AAdd( ::Fonts[ 2 ], "*" ) ;       AAdd( ::Fonts[ 4 ], {} )
      AAdd( ::Fonts[ 1 ], RR_GETCURRENTOBJECT( 1, ::hData ) ) ; AAdd( ::Fonts[ 2 ], "DEFAULT" ) ; AAdd( ::Fonts[ 4 ], {} )
      AAdd( ::Brushes[ 1 ], RR_GETCURRENTOBJECT( 2, ::hData ) ) ; AAdd( ::Brushes[ 2 ], "*" )
      AAdd( ::Brushes[ 1 ], RR_GETCURRENTOBJECT( 2, ::hData ) ) ; AAdd( ::Brushes[ 2 ], "DEFAULT" )
      AAdd( ::Pens[ 1 ], RR_GETCURRENTOBJECT( 3, ::hData ) ) ; AAdd( ::Pens[ 2 ], "*" )
      AAdd( ::Pens[ 1 ], RR_GETCURRENTOBJECT( 3, ::hData ) ) ; AAdd( ::Pens[ 2 ], "DEFAULT" )
      AAdd( ::Regions[ 1 ], 0 ) ; AAdd( ::Regions[ 2 ], "*" )
      AAdd( ::Regions[ 1 ], 0 ) ; AAdd( ::Regions[ 2 ], "DEFAULT" )
      ::Fonts[ 3 ] := ::Fonts[ 1, 1 ]
      RR_GETDEVICECAPS( ::DEVCAPS, ::Fonts[ 3 ], ::hData )
      ::setunits( ::units )
   ENDIF

   RETURN NIL

METHOD SetDevMode( what, newvalue ) CLASS HBPrinter

   ::hDCRef := RR_SETDEVMODE( what, newvalue, ::lGlobalChanges, ::hData )
   RR_GETDEVICECAPS( ::DEVCAPS, ::Fonts[ 3 ], ::hData )
   ::setunits( ::units )

   RETURN Self

METHOD StartDoc( lDocName ) CLASS HBPrinter

   ::Printing := .T.
   ASSIGN ::DocName VALUE lDocName TYPE "C" DEFAULT "HBPRINTER"
   IF ! ::PreviewMode
      RR_STARTDOC( ::DocName, ::hData )
   ENDIF

   RETURN Self

METHOD SetPage( orient, size, fontname ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( fontname, "F" )

   IF size <> NIL
      ::SetDevMode( DM_PAPERSIZE, size )
   ENDIF
   IF orient <> NIL
      ::SetDevMode( DM_ORIENTATION, orient )
   ENDIF
   IF lhand <> 0
      ::Fonts[ 3 ] := lhand
   ENDIF
   RR_GETDEVICECAPS( ::DEVCAPS, ::Fonts[ 3 ], ::hData )
   ::setunits( ::units )

   RETURN Self

METHOD StartPage() CLASS HBPrinter

   IF ::PreviewMode
      IF ::InMemory
         ::hDC := RR_CREATEMFILE( ::hData )
      ELSE
         ::hDC := RR_CREATEFILE( ::BaseDoc + AllTrim( StrZero( ::CurPage, 4 ) ) + '.emf', ::hData )
         ::CurPage := ::CurPage + 1
      ENDIF
   ELSE
      RR_STARTPAGE( ::hData )
   ENDIF
   IF ! ::PrintingEMF
      RR_SELECTCLIPRGN( ::Regions[ 1, 1 ], ::hData )
      RR_SETVIEWPORTORG( ::ViewPortOrg, ::hData )
      RR_SETTEXTCOLOR( ::textcolor, ::hData )
      RR_SETBKCOLOR( ::bkcolor, ::hData )
      RR_SETBKMODE( ::bkmode, ::hData )
      RR_SELECTBRUSH( ::Brushes[ 1, 1 ], ::hData )
      RR_SELECTPEN( ::Pens[ 1, 1 ], ::hData )
      RR_SELECTFONT( ::Fonts[ 1, 1 ], ::hData )
   ENDIF

   RETURN Self

METHOD Endpage() CLASS HBPrinter

   IF ::PreviewMode
      IF ::InMemory
         AAdd( ::MetaFiles, { RR_CLOSEMFILE( ::hData ), ::DEVCAPS[ 1 ], ::DEVCAPS[ 2 ], ::DEVCAPS[ 3 ], ::DEVCAPS[ 4 ], ::DEVCAPS[ 15 ], ::DEVCAPS[ 17 ] } )
      ELSE
         RR_CLOSEFILE( ::hData )
         AAdd( ::MetaFiles, { ::BaseDoc + StrZero( ::CurPage - 1, 4 ) + '.emf', ::DEVCAPS[ 1 ], ::DEVCAPS[ 2 ], ::DEVCAPS[ 3 ], ::DEVCAPS[ 4 ], ::DEVCAPS[ 15 ], ::DEVCAPS[ 17 ] } )
      END
   ELSE
      RR_ENDPAGE( ::hData )
   ENDIF

   RETURN Self

METHOD SaveMetaFiles( number ) CLASS HBPrinter

   LOCAL n, l

   IF Empty( number )
      number := NIL
   ENDIF
   IF ::PreviewMode
      IF ::InMemory
         IF number == NIL
            AEval( ::METAFILES, {| x, xi | RR_STR2FILE( x[ 1 ], "page" + AllTrim( Str(xi ) ) + ".emf" ) } )
         ELSE
            RR_STR2FILE( ::METAFILES[ number, 1 ], "page" + AllTrim( Str( number ) ) + ".emf" )
         ENDIF
      ELSE
         IF number <> NIL
            COPY File ( ::BaseDoc + AllTrim( StrZero( number, 4 ) ) + '.emf' ) to ( "page" + AllTrim( StrZero( number, 4 ) ) + ".emf" )
         ELSE
            l := ::curpage - 1
            FOR n := 1 TO l
               COPY File ( ::BaseDoc + AllTrim( StrZero( n, 4 ) ) + '.emf' ) to ( "page" + AllTrim( StrZero( n, 4 ) ) + ".emf" )
            END
         ENDIF
      ENDIF
   ENDIF

   RETURN Self

METHOD EndDoc( cParent, lWait, lSize ) CLASS HBPrinter

   ASSIGN lWait VALUE lWait TYPE "L" DEFAULT ::PreviewMode
   ASSIGN lSize VALUE lSize TYPE "L" DEFAULT ! lWait

   ::Preview( cParent, lWait, lSize )
   IF ! ::PreviewMode
      IF lWait
         MsgInfo( ::aopisy[ 31 ], "" )
      ENDIF
      RR_ENDDOC( ::hData )
   ENDIF
   ::Printing := .F.

   RETURN Self

METHOD SetTextColor( clr ) CLASS HBPrinter

   LOCAL lret := ::Textcolor

   IF clr <> NIL

      // BEGIN RL 2003-08-03

      IF HB_ISNUMERIC ( clr )
         ::TextColor := RR_SETTEXTCOLOR( clr, ::hData )
      ELSEIF HB_ISARRAY ( clr )
         ::TextColor := RR_SETTEXTCOLOR( RR_SETRGB( clr[ 1 ], clr[ 2 ], clr[ 3 ] ), ::hData )
      ENDIF

      // END RL

   ENDIF

   RETURN lret

METHOD SetPolyFillMode( style ) CLASS HBPrinter

   LOCAL lret := ::PolyFillMode

   ::PolyFillMode := RR_SETPOLYFILLMODE( style, ::hData )

   RETURN lret

METHOD SetBkColor( clr ) CLASS HBPrinter

   LOCAL lret := ::BkColor

   IF HB_ISNUMERIC ( clr )
      ::BkColor := RR_SETBKCOLOR( clr, ::hData )
   ELSEIF HB_ISARRAY ( clr )
      ::BkColor := RR_SETBKCOLOR( RR_SETRGB( clr[ 1 ], clr[ 2 ], clr[ 3 ] ), ::hData )
   ENDIF

   RETURN lret

METHOD SetBkMode( nmode ) CLASS HBPrinter

   LOCAL lret := ::Bkmode

   ::BkMode := nmode
   RR_SETBKMODE( nmode, ::hData )

   RETURN lret

METHOD DefineBrush( defname, lstyle, lcolor, lhatch ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "B" )

   IF lhand <> 0
      RETURN Self
   ENDIF

   // BEGIN RL 2003-08-03

   IF HB_ISARRAY ( lcolor )
      lcolor := RR_SETRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] )
   ENDIF

   // END RL

   lstyle := if( lstyle == NIL, BS_NULL, lstyle )
   lcolor := if( lcolor == NIL, 0xFFFFFF, lcolor )
   lhatch := if( lhatch == NIL, HS_HORIZONTAL, lhatch )
   AAdd( ::Brushes[ 1 ], RR_CREATEBRUSH( lstyle, lcolor, lhatch ) )
   AAdd( ::Brushes[ 2 ], Upper( AllTrim( defname ) ) )

   RETURN Self

METHOD SelectBrush( defname ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "B" )

   IF lhand <> 0
      RR_SELECTBRUSH( lhand, ::hData )
      ::Brushes[ 1, 1 ] := lhand
   ENDIF

   RETURN Self

METHOD ModifyBrush( defname, lstyle, lcolor, lhatch ) CLASS HBPrinter

   LOCAL lhand := 0, lpos

   IF defname == "*"
      lpos := AScan( ::Brushes[ 1 ], ::Brushes[ 1, 1 ], 2 )
      IF lpos > 1
         lhand := ::Brushes[ 1, lpos ]
      ENDIF
   ELSE
      lhand := ::getobjbyname( defname, "B" )
      lpos := ::getobjbyname( defname, "B", .T. )
   ENDIF
   IF lhand == 0 .OR. lpos == 0
      ::error := 1
      RETURN Self
   ENDIF
   lstyle := if( lstyle == NIL, -1, lstyle )

   // BEGIN RL 2003-08-03

   IF HB_ISARRAY ( lcolor )
      lcolor := RR_SETRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] )
   ENDIF

   // END RL

   lcolor := if( lcolor == NIL, -1, lcolor )
   lhatch := if( lhatch == NIL, -1, lhatch )
   ::Brushes[ 1, lpos ] := RR_MODIFYBRUSH( lhand, lstyle, lcolor, lhatch )
   IF lhand == ::Brushes[ 1, 1 ]
      ::selectbrush( ::Brushes[ 2, lpos ] )
   ENDIF

   RETURN Self

METHOD DefinePen( defname, lstyle, lwidth, lcolor ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "P" )

   IF lhand <> 0
      RETURN Self
   ENDIF

   // BEGIN RL 2003-08-03

   IF HB_ISARRAY ( lcolor )
      lcolor := RR_SETRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] )
   ENDIF

   // END RL

   lstyle := if( lstyle == NIL, PS_SOLID, lstyle )
   lcolor := if( lcolor == NIL, 0xFFFFFF, lcolor )
   lwidth := if( lwidth == NIL, 0, lwidth )
   AAdd( ::Pens[ 1 ], RR_CREATEPEN( lstyle, lwidth, lcolor ) )
   AAdd( ::Pens[ 2 ], Upper( AllTrim( defname ) ) )

   RETURN Self

METHOD ModifyPen( defname, lstyle, lwidth, lcolor ) CLASS HBPrinter

   LOCAL lhand := 0, lpos

   IF defname == "*"
      lpos := AScan( ::Pens[ 1 ], ::Pens[ 1, 1 ], 2 )
      IF lpos > 1
         lhand := ::Pens[ 1, lpos ]
      ENDIF
   ELSE
      lhand := ::getobjbyname( defname, "P" )
      lpos := ::getobjbyname( defname, "P", .T. )
   ENDIF
   IF lhand == 0 .OR. lpos <= 1
      ::error := 1
      RETURN Self
   ENDIF

   lstyle := if( lstyle == NIL, -1, lstyle )

   // BEGIN RL 2003-08-03

   IF HB_ISARRAY ( lcolor )
      lcolor := RR_SETRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] )
   ENDIF

   // END RL

   lcolor := if( lcolor == NIL, -1, lcolor )
   lwidth := if( lwidth == NIL, -1, lwidth )
   ::Pens[ 1, lpos ] := RR_MODIFYPEN( lhand, lstyle, lwidth, lcolor )
   IF lhand == ::Pens[ 1, 1 ]
      ::selectpen( ::Pens[ 2, lpos ] )
   ENDIF

   RETURN Self

METHOD SelectPen( defname ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "P" )

   IF lhand <> 0
      RR_SELECTPEN( lhand, ::hData )
      ::Pens[ 1, 1 ] := lhand
   ENDIF

   RETURN Self

METHOD DefineFont( defname, lfontname, lfontsize, lfontwidth, langle, lweight, litalic, lunderline, lstrikeout ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( lfontname, "F" )

   IF lhand <> 0
      RETURN Self
   ENDIF
   lfontname := if( lfontname == NIL, "", Upper( AllTrim( lfontname ) ) )
   IF lfontsize == NIL
      lfontsize := -1
   ENDIF

   IF lfontwidth == NIL
      lfontwidth := 0
   ENDIF
   IF langle == NIL
      langle := -1
   ENDIF
   lweight := if( Empty( lweight ), 0, 1 )
   litalic := if( Empty( litalic ), 0, 1 )
   lunderline := if( Empty( lunderline ), 0, 1 )
   lstrikeout := if( Empty( lstrikeout ), 0, 1 )
   AAdd( ::Fonts[ 1 ], RR_CREATEFONT( lfontname, lfontsize, -lfontwidth, langle * 10, lweight, litalic, lunderline, lstrikeout, ::hData ) )
   AAdd( ::Fonts[ 2 ], Upper( AllTrim( defname ) ) )
   AAdd( ::Fonts[ 4 ], { lfontname, lfontsize, lfontwidth, langle, lweight, litalic, lunderline, lstrikeout } )

   RETURN Self

METHOD ModifyFont( defname, lfontname, lfontsize, lfontwidth, langle, lweight, lnweight, litalic, lnitalic, lunderline, lnunderline, lstrikeout, lnstrikeout ) CLASS HBPrinter

   LOCAL lhand := 0, lpos

   IF defname == "*"
      lpos := AScan( ::Fonts[ 1 ], ::Fonts[ 1, 1 ], 2 )
      IF lpos > 1
         lhand := ::Fonts[ 1, lpos ]
      ENDIF
   ELSE
      lhand := ::getobjbyname( defname, "F" )
      lpos := ::getobjbyname( defname, "F", .T. )
   ENDIF
   IF lhand == 0 .OR. lpos <= 1
      ::error := 1
      RETURN Self
   ENDIF

   IF lfontname <> NIL
      ::Fonts[ 4, lpos, 1 ] := Upper( AllTrim( lfontname ) )
   ENDIF

   IF lfontsize <> NIL
      ::Fonts[ 4, lpos, 2 ] := lfontsize
   ENDIF
   IF lfontwidth <> NIL
      ::Fonts[ 4, lpos, 3 ] := lfontwidth
   ENDIF
   IF langle <> NIL
      ::Fonts[ 4, lpos, 4 ] := langle
   ENDIF
   IF lweight
      ::Fonts[ 4, lpos, 5 ] := 1
   ENDIF
   IF lnweight
      ::Fonts[ 4, lpos, 5 ] := 0
   ENDIF
   IF litalic
      ::Fonts[ 4, lpos, 6 ] := 1
   ENDIF
   IF lnitalic
      ::Fonts[ 4, lpos, 6 ] := 0
   ENDIF
   IF lunderline
      ::Fonts[ 4, lpos, 7 ] := 1
   ENDIF
   IF lnunderline
      ::Fonts[ 4, lpos, 7 ] := 0
   ENDIF
   IF lstrikeout
      ::Fonts[ 4, lpos, 8 ] := 1
   ENDIF
   IF lnstrikeout
      ::Fonts[ 4, lpos, 8 ] := 0
   ENDIF

   ::Fonts[ 1, lpos ] := RR_CREATEFONT( ::Fonts[ 4, lpos, 1 ], ::Fonts[ 4, lpos, 2 ], -::Fonts[ 4, lpos, 3 ], ::Fonts[ 4, lpos, 4 ] * 10, ::Fonts[ 4, lpos, 5 ], ::Fonts[ 4, lpos, 6 ], ::Fonts[ 4, lpos, 7 ], ::Fonts[ 4, lpos, 8 ], ::hData )

   IF lhand == ::Fonts[ 1, 1 ]
      ::selectfont( ::Fonts[ 2, lpos ] )
   ENDIF
   RR_DELETEOBJECTS( { 0, lhand } )

   RETURN Self

METHOD SelectFont( defname ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "F" )

   IF lhand <> 0
      RR_SELECTFONT( lhand, ::hData )
      ::Fonts[ 1, 1 ] := lhand
   ENDIF

   RETURN Self

METHOD SetUnits( newvalue, r, c, lAbsolute ) CLASS HBPrinter

   LOCAL oldvalue := ::UNITS

   IF HB_ISSTRING( newvalue )
      newvalue := Upper( AllTrim( newvalue ) )
      IF newvalue == "ROWCOL"
         newvalue := 0
      ELSEIF newvalue == "MM"
         newvalue := 1
      ELSEIF newvalue == "INCHES"
         newvalue := 2
      ELSEIF newvalue == "PIXELS"
         newvalue := 3
      ENDIF
   ENDIF
   newvalue := if( HB_ISNUMERIC( newvalue ), newvalue, 0 )
   ::UNITS := if( newvalue < 0 .OR. newvalue > 4, 0, newvalue )
   DO CASE
   CASE ::Units == 0
      ::MaxRow := ::DevCaps[ 13 ] - 1
      ::MaxCol := ::DevCaps[ 14 ] - 1
   CASE ::Units == 1
      ::MaxRow := ::DevCaps[ 1 ] - 1
      ::MaxCol := ::DevCaps[ 2 ] - 1
   CASE ::Units == 2
      ::MaxRow := ( ::DevCaps[ 1 ] / 25.4 ) - 1
      ::MaxCol := ( ::DevCaps[ 2 ] / 25.4 ) - 1
   CASE ::Units == 3
      ::MaxRow := ::DevCaps[ 3 ]
      ::MaxCol := ::DevCaps[ 4 ]
   CASE ::Units == 4
      IF HB_ISNUMERIC( r )
         ::MaxRow := r - 1
      ENDIF
      IF HB_ISNUMERIC( c )
         ::MaxCol := c - 1
      ENDIF
   ENDCASE
   IF HB_ISLOGICAL( lAbsolute )
      ::lAbsoluteCoords := lAbsolute
   ENDIF

   RETURN oldvalue

METHOD Convert( arr, lsize ) CLASS HBPrinter

   LOCAL aret := AClone( arr )

   DO CASE
   CASE ::UNITS == 0
      aret[ 1 ] := ( arr[ 1 ] ) * ::DEVCAPS[ 11 ]
      aret[ 2 ] := ( arr[ 2 ] ) * ::DEVCAPS[ 12 ]
   CASE ::UNITS == 3
   CASE ::UNITS == 4
      aret[ 1 ] := ( arr[ 1 ] ) * ::DEVCAPS[ 3 ] / ( ::maxrow + 1 )
      aret[ 2 ] := ( arr[ 2 ] ) * ::DEVCAPS[ 4 ] / ( ::maxcol + 1 )
   CASE ::UNITS == 1
      aret[ 1 ] := ( arr[ 1 ] ) * ::DEVCAPS[ 5 ] / 25.4 - if( ! ::lAbsoluteCoords .AND. lsize == NIL, ::DEVCAPS[ 9 ], 0 )
      aret[ 2 ] := ( arr[ 2 ] ) * ::DEVCAPS[ 6 ] / 25.4 - if( ! ::lAbsoluteCoords .AND. lsize == NIL, ::DEVCAPS[ 10 ], 0 )
   CASE ::UNITS == 2
      aret[ 1 ] := ( arr[ 1 ] ) * ::DEVCAPS[ 5 ] - if( ! ::lAbsoluteCoords .AND. lsize == NIL, ::DEVCAPS[ 9 ], 0 )
      aret[ 2 ] := ( arr[ 2 ] ) * ::DEVCAPS[ 6 ] - if( ! ::lAbsoluteCoords .AND. lsize == NIL, ::DEVCAPS[ 10 ], 0 )
   OTHERWISE
      aret[ 1 ] := ( arr[ 1 ] ) * ::DEVCAPS[ 11 ]
      aret[ 2 ] := ( arr[ 2 ] ) * ::DEVCAPS[ 12 ]
   ENDCASE

   RETURN aret

METHOD DrawText( row, col, torow, tocol, txt, style, defname, lNoWordBreak ) CLASS HBPrinter

   LOCAL lhf := ::getobjbyname( defname, "F" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   RR_DRAWTEXT( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), txt, style, lhf, lNoWordBreak, ::hData )

   RETURN Self

METHOD TEXTOUT( row, col, txt, defname ) CLASS HBPrinter

   LOCAL lhf := ::getobjbyname( defname, "F" )

   RR_TEXTOUT( txt, ::Convert( { row, col } ), lhf, RAt( " ", txt ), ::hData )

   RETURN Self

METHOD Say( row, col, txt, defname, lcolor, lalign ) CLASS HBPrinter

   LOCAL atxt := {}, i, lhf := ::getobjbyname( defname, "F" ), oldalign
   LOCAL apos

   DO CASE
   CASE HB_ISNUMERIC( txt ) ;  AAdd( atxt, Str( txt ) )
   CASE ValType( txt ) == "T" ;  AAdd( atxt, ttoc( txt ) )
   CASE HB_ISDATE( txt ) ;  AAdd( atxt, DToC( txt ) )
   CASE HB_ISLOGICAL( txt ) ;  AAdd( atxt, if( txt, ".T.", ".F." ) )
   CASE ValType( txt ) == "U" ;  AAdd( atxt, "NIL" )
   CASE ValType( txt ) $ "BO" ;  AAdd( atxt, "" )
   CASE HB_ISARRAY( txt ) ;  AEval( txt, {| x | AAdd( atxt, RR_SAYCONVERT( x ) ) } )
   CASE ValType( txt ) $ "MC" ;  atxt := RR_STR2ARR( txt, CRLF )
   ENDCASE
   apos := ::convert( { row, col } )
   IF lcolor <> NIL
      IF HB_ISNUMERIC ( lcolor )
         RR_SETTEXTCOLOR( lcolor, ::hData )
      ELSEIF HB_ISARRAY ( lcolor )
         RR_SETTEXTCOLOR( RR_SETRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] ), ::hData )
      ENDIF
   ENDIF
   IF lalign <> NIL
      oldalign := RR_GETTEXTALIGN( ::hData )
      RR_SETTEXTALIGN( lalign, ::hData )
   ENDIF
   FOR i := 1 TO Len( atxt )
      RR_TEXTOUT( atxt[ i ], apos, lhf, RAt( " ", atxt[ i ] ), ::hData )
      apos[ 1 ] += ::DEVCAPS[ 11 ]
   NEXT
   IF lalign <> NIL
      RR_SETTEXTALIGN( oldalign, ::hData )
   ENDIF

   IF lcolor <> NIL
      RR_SETTEXTCOLOR( ::textcolor, ::hData )
   ENDIF

   RETURN Self

METHOD DefineImageList( defname, cpicture, nicons ) CLASS HBPrinter

   LOCAL lhi := ::getobjbyname( defname, "I" ), w := 0, h := 0, hand

   IF lhi <> 0
      RETURN Self
   ENDIF
   hand := RR_CREATEIMAGELIST( cpicture, nicons, @w, @h )
   IF hand <> 0 .AND. w > 0 .AND. h > 0
      AAdd( ::imagelists[ 1 ], { hand, nicons, w, h } )
      AAdd( ::imagelists[ 2 ], Upper( AllTrim( defname ) ) )
   ENDIF

   RETURN Self

METHOD DRAWIMAGELIST( defname, nicon, row, col, torow, tocol, lstyle, color ) CLASS HBPrinter

   LOCAL lhi := ::getobjbyname( defname, "I" )

   IF Empty( lhi )
      RETURN Self
   ENDIF
   IF COLOR == NIL
      COLOR := -1
   ENDIF
   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_DRAWIMAGELIST( lhi[ 1 ], nicon, ::convert( { row, col } ), ::convert( { torow - row, tocol - col } ), lhi[ 3 ], lhi[ 4 ], lstyle, COLOR, ::hData )

   RETURN Self

METHOD Rectangle( row, col, torow, tocol, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" ), lhb := ::getobjbyname( defbrush, "B" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_RECTANGLE( ::convert( { row, col } ), ::convert( { torow, tocol } ), lhp, lhb, ::hData )

   RETURN Self

METHOD FrameRect( row, col, torow, tocol, defbrush ) CLASS HBPrinter

   LOCAL lhb := ::getobjbyname( defbrush, "B" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_FRAMERECT( ::convert( { row, col } ), ::convert( { torow, tocol } ), lhb, ::hData )

   RETURN Self

METHOD RoundRect( row, col, torow, tocol, widthellipse, heightellipse, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" ), lhb := ::getobjbyname( defbrush, "B" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   IF widthellipse == NIL
      widthellipse := 0
   ENDIF
   IF heightellipse == NIL
      heightellipse := 0
   ENDIF
   ::error := RR_ROUNDRECT( ::convert( { row, col } ), ::convert( { torow, tocol } ), ::convert( { widthellipse, heightellipse } ), lhp, lhb, ::hData )

   RETURN Self

METHOD FillRect( row, col, torow, tocol, defbrush ) CLASS HBPrinter

   LOCAL lhb := ::getobjbyname( defbrush, "B" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_FILLRECT( ::convert( { row, col } ), ::convert( { torow, tocol } ), lhb, ::hData )

   RETURN Self

METHOD InvertRect( row, col, torow, tocol ) CLASS HBPrinter

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_INVERTRECT( ::convert( { row, col } ), ::convert( { torow, tocol }, ::hData ) )

   RETURN Self

METHOD Ellipse( row, col, torow, tocol, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" ), lhb := ::getobjbyname( defbrush, "B" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_ELLIPSE( ::convert( { row, col } ), ::convert( { torow, tocol } ), lhp, lhb, ::hData )

   RETURN Self

METHOD Arc( row, col, torow, tocol, rowsarc, colsarc, rowearc, colearc, defpen ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_ARC( ::convert( { row, col } ), ::convert( { torow, tocol } ), ::convert( { rowsarc, colsarc } ), ::convert( { rowearc, colearc } ), lhp, ::hData )

   RETURN Self

METHOD ArcTo( row, col, torow, tocol, rowrad1, colrad1, rowrad2, colrad2, defpen ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_ARCTO( ::convert( { row, col } ), ::convert( { torow, tocol } ), ::convert( { rowrad1, colrad1 } ), ::convert( { rowrad2, colrad2 } ), lhp, ::hData )

   RETURN Self

METHOD Chord( row, col, torow, tocol, rowrad1, colrad1, rowrad2, colrad2, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" ), lhb := ::getobjbyname( defbrush, "B" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_CHORD( ::convert( { row, col } ), ::convert( { torow, tocol } ), ::convert( { rowrad1, colrad1 } ), ::convert( { rowrad2, colrad2 } ), lhp, lhb, ::hData )

   RETURN Self

METHOD Pie( row, col, torow, tocol, rowrad1, colrad1, rowrad2, colrad2, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" ), lhb := ::getobjbyname( defbrush, "B" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_PIE( ::convert( { row, col } ), ::convert( { torow, tocol } ), ::convert( { rowrad1, colrad1 } ), ::convert( { rowrad2, colrad2 } ), lhp, lhb, ::hData )

   RETURN Self

METHOD Polygon( apoints, defpen, defbrush, style ) CLASS HBPrinter

   LOCAL apx := {}, apy := {}, temp
   LOCAL lhp := ::getobjbyname( defpen, "P" ), lhb := ::getobjbyname( defbrush, "B" )

   AEval( apoints, {| x | temp := ::convert( x ), AAdd( apx, temp[ 2 ] ), AAdd( apy, temp[ 1 ] ) } )
   ::error := RR_POLYGON( apx, apy, lhp, lhb, style, ::hData )

   RETURN Self

METHOD PolyBezier( apoints, defpen ) CLASS HBPrinter

   LOCAL apx := {}, apy := {}, temp
   LOCAL lhp := ::getobjbyname( defpen, "P" )

   AEval( apoints, {| x | temp := ::convert( x ), AAdd( apx, temp[ 2 ] ), AAdd( apy, temp[ 1 ] ) } )
   ::error := RR_POLYBEZIER( apx, apy, lhp, ::hData )

   RETURN Self

METHOD PolyBezierTo( apoints, defpen ) CLASS HBPrinter

   LOCAL apx := {}, apy := {}, temp
   LOCAL lhp := ::getobjbyname( defpen, "P" )

   AEval( apoints, {| x | temp := ::convert( x ), AAdd( apx, temp[ 2 ] ), AAdd( apy, temp[ 1 ] ) } )

   ::error := RR_POLYBEZIERTO( apx, apy, lhp, ::hData )

   RETURN Self

METHOD Line( row, col, torow, tocol, defpen ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" )

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   ::error := RR_LINE( ::convert( { row, col } ), ::convert( { torow, tocol } ), lhp, ::hData )

   RETURN Self

METHOD LineTo( row, col, defpen ) CLASS HBPrinter

   LOCAL lhp := ::getobjbyname( defpen, "P" )

   ::error := RR_LINETO( ::convert( { row, col } ), lhp, ::hData )

   RETURN Self

METHOD GetTextExtent( ctext, apoint, deffont ) CLASS HBPrinter

   LOCAL lhf := ::getobjbyname( deffont, "F" )

   ::error := RR_GETTEXTEXTENT( ctext, apoint, lhf, ::hData )

   RETURN Self

METHOD GetObjByName( defname, what, retpos ) CLASS HBPrinter

   LOCAL lfound, lret := 0, aref, ahref

   IF ValType( defname ) == "C"
      DO CASE
      CASE what == "F" ; aref := ::Fonts[ 2 ] ; ahref := ::Fonts[ 1 ]
      CASE what == "B" ; aref := ::Brushes[ 2 ] ; ahref := ::Brushes[ 1 ]
      CASE what == "P" ; aref := ::Pens[ 2 ] ; ahref := ::Pens[ 1 ]
      CASE what == "R" ; aref := ::Regions[ 2 ] ; ahref := ::Regions[ 1 ]
      CASE what == "I" ; aref := ::ImageLists[ 2 ] ; ahref := ::ImageLists[ 1 ]
      ENDCASE
      lfound := AScan( aref, Upper( AllTrim( defname ) ) )
      IF lfound > 0
         IF aref[ lfound ] == Upper( AllTrim( defname ) )
            IF retpos <> NIL
               lret := lfound
            ELSE
               lret := ahref[ lfound ]
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   RETURN lret

METHOD DefineRectRgn( defname, row, col, torow, tocol ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "R" )

   IF lhand <> 0
      RETURN Self
   ENDIF
   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   AAdd( ::Regions[ 1 ], RR_CREATERGN( ::convert( { row, col } ), ::convert( { torow, tocol } ), 1, NIL, ::hData ) )
   AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )

   RETURN Self

METHOD DefineEllipticRgn( defname, row, col, torow, tocol ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "R" )

   IF lhand <> 0
      RETURN Self
   ENDIF
   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   AAdd( ::Regions[ 1 ], RR_CREATERGN( ::convert( { row, col } ), ::convert( { torow, tocol } ), 2, NIL, ::hData ) )
   AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )

   RETURN Self

METHOD DefineRoundRectRgn( defname, row, col, torow, tocol, widthellipse, heightellipse ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "R" )

   IF lhand <> 0
      RETURN Self
   ENDIF
   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   AAdd( ::Regions[ 1 ], RR_CREATERGN( ::convert( { row, col } ), ::convert( { torow, tocol } ), 3, ::convert( { widthellipse, heightellipse } ), ::hData ) )
   AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )

   RETURN Self

METHOD DefinePolygonRgn( defname, apoints, style ) CLASS HBPrinter

   LOCAL apx := {}, apy := {}, temp
   LOCAL lhand := ::getobjbyname( defname, "R" )

   IF lhand <> 0
      RETURN Self
   ENDIF
   AEval( apoints, {| x | temp := ::convert( x ), AAdd( apx, temp[ 2 ] ), AAdd( apy, temp[ 1 ] ) } )
   AAdd( ::Regions[ 1 ], RR_CREATEPOLYGONRGN( apx, apy, style ) )
   AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )

   RETURN Self

METHOD CombineRgn( defname, reg1, reg2, style ) CLASS HBPrinter

   LOCAL lr1 := ::getobjbyname( reg1, "R" ), lr2 := ::getobjbyname( reg2, "R" )
   LOCAL lhand := ::getobjbyname( defname, "R" )

   IF lhand <> 0 .OR. lr1 == 0 .OR. lr2 == 0
      RETURN Self
   ENDIF
   AAdd( ::Regions[ 1 ], RR_COMBINERGN( lr1, lr2, style ) )
   AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )

   RETURN Self

METHOD SelectClipRgn( defname ) CLASS HBPrinter

   LOCAL lhand := ::getobjbyname( defname, "R" )

   IF lhand <> 0
      RR_SELECTCLIPRGN( lhand, ::hData )
      ::Regions[ 1, 1 ] := lhand
   ENDIF

   RETURN Self

METHOD DeleteClipRgn() CLASS HBPrinter

   ::Regions[ 1, 1 ] := 0
   RR_DELETECLIPRGN( ::hData )

   RETURN Self

METHOD SetViewPortOrg( row, col ) CLASS HBPrinter

   row := if( row <> NIL, row, 0 )
   col := if( col <> NIL, col, 0 )
   ::VIEWPORTORG := ::convert( { row, col } )
   RR_SETVIEWPORTORG( ::ViewportOrg, ::hData )

   RETURN Self

METHOD GetViewPortOrg() CLASS HBPrinter

   RR_GETVIEWPORTORG( ::VIEWPORTORG, ::hData )

   RETURN Self

METHOD End() CLASS HBPrinter

   LOCAL n, l

   IF ::PreviewMode
      ::Metafiles := {}
      IF ! ::InMemory
         l := ::curpage - 1
         FOR n := 1 TO l
            FErase( ::BaseDoc + AllTrim( StrZero( n, 4 ) ) + '.emf' )
         NEXT
      ENDIF
   ENDIF
   IF ::HDCRef # 0
      RR_RESETPRINTER( ::hData )
      RR_DELETEDC( ::HDCRef, ::hData )
   ENDIF
   RR_DELETEOBJECTS( ::Fonts[ 1 ] )
   RR_DELETEOBJECTS( ::Brushes[ 1 ] )
   RR_DELETEOBJECTS( ::Pens[ 1 ] )
   RR_DELETEOBJECTS( ::Regions[ 1 ] )
   RR_DELETEIMAGELISTS( ::ImageLists[ 1 ] )
   RR_FINISH( ::hData )
   ::hData := NIL
   IF HB_ISOBJECT( ::oWinPreview )
      ::PrevClose()
   ENDIF
   IF HB_ISOBJECT( ::oWinPrOpt )
      ::oWinPrOpt:Release()
   ENDIF

   RETURN NIL

METHOD DXCOLORS( par ) CLASS HBPrinter

   STATIC rgbColorNames := ;
      { { "aliceblue", 0xfffff8f0 }, ;
      { "antiquewhite", 0xffd7ebfa }, ;
      { "aqua", 0xffffff00 }, ;
      { "aquamarine", 0xffd4ff7f }, ;
      { "azure", 0xfffffff0 }, ;
      { "beige", 0xffdcf5f5 }, ;
      { "bisque", 0xffc4e4ff }, ;
      { "black", 0xff000000 }, ;
      { "blanchedalmond", 0xffcdebff }, ;
      { "blue", 0xffff0000 }, ;
      { "blueviolet", 0xffe22b8a }, ;
      { "brown", 0xff2a2aa5 }, ;
      { "burlywood", 0xff87b8de }, ;
      { "cadetblue", 0xffa09e5f }, ;
      { "chartreuse", 0xff00ff7f }, ;
      { "chocolate", 0xff1e69d2 }, ;
      { "coral", 0xff507fff }, ;
      { "cornflowerblue", 0xffed9564 }, ;
      { "cornsilk", 0xffdcf8ff }, ;
      { "crimson", 0xff3c14dc }, ;
      { "cyan", 0xffffff00 }, ;
      { "darkblue", 0xff8b0000 }, ;
      { "darkcyan", 0xff8b8b00 }, ;
      { "darkgoldenrod", 0xff0b86b8 }, ;
      { "darkgray", 0xffa9a9a9 }, ;
      { "darkgreen", 0xff006400 }, ;
      { "darkkhaki", 0xff6bb7bd }, ;
      { "darkmagenta", 0xff8b008b }, ;
      { "darkolivegreen", 0xff2f6b55 }, ;
      { "darkorange", 0xff008cff }, ;
      { "darkorchid", 0xffcc3299 }, ;
      { "darkred", 0xff00008b }, ;
      { "darksalmon", 0xff7a96e9 }, ;
      { "darkseagreen", 0xff8fbc8f }, ;
      { "darkslateblue", 0xff8b3d48 }, ;
      { "darkslategray", 0xff4f4f2f }, ;
      { "darkturquoise", 0xffd1ce00 }, ;
      { "darkviolet", 0xffd30094 }, ;
      { "deeppink", 0xff9314ff }, ;
      { "deepskyblue", 0xffffbf00 }, ;
      { "dimgray", 0xff696969 }, ;
      { "dodgerblue", 0xffff901e }, ;
      { "firebrick", 0xff2222b2 }, ;
      { "floralwhite", 0xfff0faff }, ;
      { "forestgreen", 0xff228b22 }, ;
      { "fuchsia", 0xffff00ff }, ;
      { "gainsboro", 0xffdcdcdc }, ;
      { "ghostwhite", 0xfffff8f8 }, ;
      { "gold", 0xff00d7ff }, ;
      { "goldenrod", 0xff20a5da }, ;
      { "gray", 0xff808080 }, ;
      { "green", 0xff008000 }, ;
      { "greenyellow", 0xff2fffad }, ;
      { "honeydew", 0xfff0fff0 }, ;
      { "hotpink", 0xffb469ff }, ;
      { "indianred", 0xff5c5ccd }, ;
      { "indigo", 0xff82004b }, ;
      { "ivory", 0xfff0ffff }, ;
      { "khaki", 0xff8ce6f0 }, ;
      { "lavender", 0xfffae6e6 }, ;
      { "lavenderblush", 0xfff5f0ff }, ;
      { "lawngreen", 0xff00fc7c }, ;
      { "lemonchiffon", 0xffcdfaff }, ;
      { "lightblue", 0xffe6d8ad }, ;
      { "lightcoral", 0xff8080f0 }, ;
      { "lightcyan", 0xffffffe0 }, ;
      { "lightgoldenrodyellow", 0xffd2fafa }, ;
      { "lightgreen", 0xff90ee90 }, ;
      { "lightgrey", 0xffd3d3d3 }, ;
      { "lightpink", 0xffc1b6ff }, ;
      { "lightsalmon", 0xff7aa0ff }, ;
      { "lightseagreen", 0xffaab220 }, ;
      { "lightskyblue", 0xffface87 }, ;
      { "lightslategray", 0xff998877 }, ;
      { "lightsteelblue", 0xffdec4b0 }, ;
      { "lightyellow", 0xffe0ffff }, ;
      { "lime", 0xff00ff00 }, ;
      { "limegreen", 0xff32cd32 }, ;
      { "linen", 0xffe6f0fa }, ;
      { "magenta", 0xffff00ff }, ;
      { "maroon", 0xff000080 }, ;
      { "mediumaquamarine", 0xffaacd66 }, ;
      { "mediumblue", 0xffcd0000 }, ;
      { "mediumorchid", 0xffd355ba }, ;
      { "mediumpurple", 0xffdb7093 }, ;
      { "mediumseagreen", 0xff71b33c }, ;
      { "mediumslateblue", 0xffee687b }, ;
      { "mediumspringgreen", 0xff9afa00 }, ;
      { "mediumturquoise", 0xffccd148 }, ;
      { "mediumvioletred", 0xff8515c7 }, ;
      { "midnightblue", 0xff701919 }, ;
      { "mintcream", 0xfffafff5 }, ;
      { "mistyrose", 0xffe1e4ff }, ;
      { "moccasin", 0xffb5e4ff }, ;
      { "navajowhite", 0xffaddeff }, ;
      { "navy", 0xff800000 }, ;
      { "oldlace", 0xffe6f5fd }, ;
      { "olive", 0xff008080 }, ;
      { "olivedrab", 0xff238e6b }, ;
      { "orange", 0xff00a5ff }, ;
      { "orangered", 0xff0045ff }, ;
      { "orchid", 0xffd670da }, ;
      { "palegoldenrod", 0xffaae8ee }, ;
      { "palegreen", 0xff98fb98 }, ;
      { "paleturquoise", 0xffeeeeaf }, ;
      { "palevioletred", 0xff9370db }, ;
      { "papayawhip", 0xffd5efff }, ;
      { "peachpuff", 0xffb9daff }, ;
      { "peru", 0xff3f85cd }, ;
      { "pink", 0xffcbc0ff }, ;
      { "plum", 0xffdda0dd }, ;
      { "powderblue", 0xffe6e0b0 }, ;
      { "purple", 0xff800080 }, ;
      { "red", 0xff0000ff }, ;
      { "rosybrown", 0xff8f8fbc }, ;
      { "royalblue", 0xffe16941 }, ;
      { "saddlebrown", 0xff13458b }, ;
      { "salmon", 0xff7280fa }, ;
      { "sandybrown", 0xff60a4f4 }, ;
      { "seagreen", 0xff578b2e }, ;
      { "seashell", 0xffeef5ff }, ;
      { "sienna", 0xff2d52a0 }, ;
      { "silver", 0xffc0c0c0 }, ;
      { "skyblue", 0xffebce87 }, ;
      { "slateblue", 0xffcd5a6a }, ;
      { "slategray", 0xff908070 }, ;
      { "snow", 0xfffafaff }, ;
      { "springgreen", 0xff7fff00 }, ;
      { "steelblue", 0xffb48246 }, ;
      { "tan", 0xff8cb4d2 }, ;
      { "teal", 0xff808000 }, ;
      { "thistle", 0xffd8bfd8 }, ;
      { "tomato", 0xff4763ff }, ;
      { "turquoise", 0xffd0e040 }, ;
      { "violet", 0xffee82ee }, ;
      { "wheat", 0xffb3def5 }, ;
      { "white", 0xffffffff }, ;
      { "whitesmoke", 0xfff5f5f5 }, ;
      { "yellow", 0xff00ffff }, ;
      { "yellowgreen", 0xff32cd9a } }
   LOCAL ltemp := 0

   // rgbcolornames:=asort(rgbcolornames,,,{|x,y| x[2]<y[2]})
   IF ValType( par ) == "C"
      par := Lower( AllTrim( par ) )
      AEval( rgbcolornames, {| x | if( x[ 1 ] == par, ltemp := x[ 2 ], '' ) } )
      RETURN ltemp
   ELSEIF HB_ISNUMERIC( par )
      RETURN if( par <= Len( rgbcolornames ), rgbcolornames[ par, 2 ], 0 )
   ENDIF

   RETURN 0

METHOD SetRGB( red, green, blue ) CLASS HBPrinter

   RETURN RR_SETRGB( red, green, blue )

METHOD SetTextCharExtra( col ) CLASS HBPrinter

   LOCAL p1 := ::convert( { 0, 0 } ), p2 := ::convert( { 0, col } )

   RETURN RR_SETTEXTCHAREXTRA( p2[ 2 ] - p1[ 2 ], ::hData )

METHOD GetTextCharExtra() CLASS HBPrinter

   RETURN RR_GETTEXTCHAREXTRA( ::hData )

METHOD SetTextJustification( col ) CLASS HBPrinter

   LOCAL p1 := ::convert( { 0, 0 } ), p2 := ::convert( { 0, col } )

   RETURN RR_SETTEXTJUSTIFICATION( p2[ 2 ] - p1[ 2 ], ::hData )

METHOD GetTextJustification() CLASS HBPrinter

   RETURN RR_GETTEXTJUSTIFICATION( ::hData )

METHOD SetTextAlign( style ) CLASS HBPrinter

   RETURN RR_SETTEXTALIGN( style, ::hData )

METHOD GetTextAlign() CLASS HBPrinter

   RETURN RR_GETTEXTALIGN( ::hData )

METHOD Picture( row, col, torow, tocol, cpicture, extrow, extcol, lImageSize ) CLASS HBPrinter

   LOCAL lp1 := ::convert( { row, col } ), lp2, lp3

   IF torow == NIL
      torow := ::maxrow
   ENDIF
   IF tocol == NIL
      tocol := ::maxcol
   ENDIF
   lp2 := ::convert( { torow, tocol }, 1 )
   IF extrow == NIL
      extrow := 0
   ENDIF
   IF extcol == NIL
      extcol := 0
   ENDIF
   lp3 := ::convert( { extrow, extcol } )
   RR_DRAWPICTURE( cpicture, lp1, lp2, lp3, lImageSize, ::hData )

   RETURN Self

FUNCTION RR_STR2FILE( ctxt, cfile )

   LOCAL hand, lrec

   hand := FCreate( cfile )
   IF hand < 0
      RETURN 0
   ENDIF
   lrec := FWrite( hand, ctxt )
   FClose( hand )

   RETURN lrec

FUNCTION RR_SAYCONVERT( ltxt )

   DO CASE
   CASE ValType( ltxt ) $ "MC" ;  RETURN ltxt
   CASE HB_ISNUMERIC( ltxt ) ;  RETURN Str( ltxt )
   CASE ValType( ltxt ) == "T" ;  RETURN TToC( ltxt )
   CASE HB_ISDATE( ltxt ) ;  RETURN DToC( ltxt )
   CASE HB_ISLOGICAL( ltxt ) ;  RETURN iif( ltxt, ".T.", ".F." )
   ENDCASE

   RETURN ""

FUNCTION RR_STR2ARR( cList, cDelimiter )

   LOCAL nPos
   LOCAL aList := {}
   LOCAL nLen := 0
   LOCAL aSub

   DO CASE
   CASE ValType( cDelimiter ) == 'C'
      cDelimiter := iif( cDelimiter == NIL, ',', cDelimiter )
      nLen := Len( cDelimiter )
      DO WHILE ( nPos := At( cDelimiter, cList ) ) # 0
         AAdd( aList, SubStr( cList, 1, nPos - 1 ) )
         cList := SubStr( cList, nPos + nLen )
      ENDDO
      AAdd( aList, cList )
   CASE HB_ISNUMERIC( cDelimiter )
      DO WHILE Len( ( nPos := Left( cList, cDelimiter ) ) ) == cDelimiter
         AAdd( aList, nPos )
         cList := SubStr( cList, cDelimiter + 1 )
      ENDDO
   CASE HB_ISARRAY( cDelimiter )
      AEval( cDelimiter, {| X | nLen += X } )
      DO WHILE Len( ( nPos := Left( cList, nLen ) ) ) == nLen
         aSub := {}
         AEval( cDelimiter, {| x | AAdd( aSub, Left( nPos, x ) ), nPos := SubStr( nPos, x + 1 ) } )
         AAdd( aList, aSub )
         cList := SubStr( cList, nLen + 1 )
      ENDDO
   ENDCASE

   RETURN ( aList )

METHOD ReportData( l_x1, l_x2, l_x3, l_x4, l_x5, l_x6 ) CLASS HBPrinter

   SET DEVICE TO PRINT
   SET PRINTER TO "hbprinter.rep" ADDITIVE
   SET PRINTER ON
   SET CONSOLE OFF
   ? '-----------------', Date(), Time()
   ?
   ?? if( ValType( l_x1 ) <> "U", l_x1, "," )
   ?? if( ValType( l_x2 ) <> "U", l_x2, "," )
   ?? if( ValType( l_x3 ) <> "U", l_x3, "," )
   ?? if( ValType( l_x4 ) <> "U", l_x4, "," )
   ?? if( ValType( l_x5 ) <> "U", l_x5, "," )
   ?? if( ValType( l_x6 ) <> "U", l_x6, "," )
   ? 'HDC            :', ::HDC
   ? 'HDCREF         :', ::HDCREF
   ? 'PRINTERNAME    :', ::PRINTERNAME
   ? 'PRINTEDEFAULT  :', ::PRINTERDEFAULT
   ? 'VERT X HORZ SIZE         :', ::DEVCAPS[ 1 ], "x", ::DEVCAPS[ 2 ]
   ? 'VERT X HORZ RES          :', ::DEVCAPS[ 3 ], "x", ::DEVCAPS[ 4 ]
   ? 'VERT X HORZ LOGPIX       :', ::DEVCAPS[ 5 ], "x", ::DEVCAPS[ 6 ]
   ? 'VERT X HORZ PHYS. SIZE   :', ::DEVCAPS[ 7 ], "x", ::DEVCAPS[ 8 ]
   ? 'VERT X HORZ PHYS. OFFSET :', ::DEVCAPS[ 9 ], "x", ::DEVCAPS[ 10 ]
   ? 'VERT X HORZ FONT SIZE    :', ::DEVCAPS[ 11 ], "x", ::DEVCAPS[ 12 ]
   ? 'VERT X HORZ ROWS COLS    :', ::DEVCAPS[ 13 ], "x", ::DEVCAPS[ 14 ]
   ? 'ORIENTATION              :', ::DEVCAPS[ 15 ]
   ? 'PAPER SIZE               :', ::DEVCAPS[ 17 ]
   SET PRINTER OFF
   SET PRINTER TO
   SET CONSOLE ON
   SET DEVICE TO SCREEN

   RETURN Self

#ifndef NO_GUI

METHOD PrevThumb( nclick ) CLASS HBPrinter

   LOCAL i, spage

   IF ::iloscstron == 1
      RETURN Self
   ENDIF
   IF nclick <> NIL
      ::page := ::ngroup * 15 + nclick
      ::prevshow()
      ::oWinPreview:combo_1:value := ::Page
      RETURN Self
   ENDIF
   IF Int( ( ::page - 1 ) / 15 ) <> ::ngroup
      ::ngroup := Int( ( ::page - 1 ) / 15 )
   ELSE
      RETURN Self
   ENDIF
   spage := ::ngroup * 15

   FOR i := 1 TO 15
      IF i + spage > ::iloscstron
         HideWindow( ::ath[ i, 5 ] )
      ELSE
         IF ::Metafiles[ i + spage, 2 ] >= ::Metafiles[ i + spage, 3 ]
            ::ath[ i, 3 ] := ::dy - 5
            ::ath[ i, 4 ] := ::dx * ::Metafiles[ i + spage, 3 ] / ::Metafiles[ i + spage, 2 ] - 5
         ELSE
            ::ath[ i, 4 ] := ::dx - 5
            ::ath[ i, 3 ] := ::dy * ::Metafiles[ i + spage, 2 ] / ::Metafiles[ i + spage, 3 ] - 5
         ENDIF
         IF ::InMemory
            RR_PLAYTHUMB( ::ath[ i ], ::Metafiles[ i + spage ], AllTrim( Str( i + spage ) ), i, ::hData )
         ELSE
            RR_PLAYFTHUMB( ::ath[ i ], ::Metafiles[ i + spage, 1 ], AllTrim( Str( i + spage ) ), i, ::hData )
         ENDIF
         CShowControl( ::ath[ i, 5 ] )
      ENDIF
   NEXT

   RETURN Self

METHOD PrevShow() CLASS HBPrinter

   LOCAL spos, hImage

   IF ::Thumbnails
      ::Prevthumb()
   ENDIF

   spos := { GetScrollpos( ::ahs[ 5, 7 ], SB_HORZ ) / ::azoom[ 4 ], GetScrollpos( ::ahs[ 5, 7 ], SB_VERT ) / ( ::azoom[ 3 ] ) }

   IF ::MetaFiles[ ::page, 2 ] >= ::MetaFiles[ ::page, 3 ]
      ::azoom[ 3 ] := ( ::ahs[ 5, 3 ] ) * ::scale - 60
      ::azoom[ 4 ] := ( ::ahs[ 5, 3 ] * ::MetaFiles[ ::page, 3 ] / ::MetaFiles[ ::page, 2 ] ) * ::scale - 60
   ELSE
      ::azoom[ 3 ] := ( ::ahs[ 5, 4 ] * ::MetaFiles[ ::page, 2 ] / ::MetaFiles[ ::page, 3 ] ) * ::scale - 60
      ::azoom[ 4 ] := ( ::ahs[ 5, 4 ] ) * ::scale - 60
   ENDIF
   ::oWinPreview:StatusBar:Item( 1, ::aopisy[ 15 ] + " " + AllTrim( Str( ::page ) ) )

   IF ::azoom[ 3 ] < 30
      ::scale := ::scale * 1.25
      ::prevshow()
      MsgStop( ::aopisy[ 18 ], "" )
   ENDIF
   HideWindow( ::ahs[ 6, 7 ] )
   ::oWinPagePreview:i1:SizePos(,, ::azoom[ 4 ], ::azoom[ 3 ] )
   ::oWinPagePreview:VirtualHeight := ::azoom[ 3 ] + 20
   ::oWinPagePreview:VirtualWidth := ::azoom[ 4 ] + 20

   IF ::InMemory
      hImage := RR_PREVIEWPLAY( ::ahs[ 6, 7 ], ::METAFILES[ ::page ], ::azoom )
   ELSE
      hImage := RR_PREVIEWFPLAY( ::ahs[ 6, 7 ], ::METAFILES[ ::page, 1 ], ::azoom )
   ENDIF
   if ! ValidHandler( hImage )
      ::scale := ::scale / 1.25
      ::PrevShow()
      MsgStop( ::aopisy[ 18 ], ::aopisy[ 1 ] )
   ELSE
      ::oWinPagePreview:i1:hbitmap := hImage
   ENDIF
   RR_SCROLLWINDOW( ::ahs[ 5, 7 ], -spos[ 1 ] * ::azoom[ 4 ], -spos[ 2 ] * ::azoom[ 3 ] )
   CShowControl( ::ahs[ 6, 7 ] )

   RETURN Self

METHOD PrevPrint( n1 ) CLASS HBPrinter

   LOCAL i, ilkop, toprint := .T.

   IF ! Eval( ::BeforePrint )
      RETURN Self
   ENDIF

   ::PreviewMode := .F.
   ::PrintingEMF := .T.
   RR_LALABYE( 1, ::hData )
   IF n1 <> NIL
      ::StartDoc()
      ::SetPage( ::MetaFiles[ n1, 6 ], ::MetaFiles[ n1, 7 ] )
      ::StartPage()
      IF ::InMemory
         RR_PLAYENHMETAFILE( ::MetaFiles[ n1 ], ::hDCRef )
      ELSE
         RR_PLAYFENHMETAFILE( ::MetaFiles[ n1 ], ::hDCRef )
      END
      ::endpage()
      ::enddoc()
   ELSE
      FOR ilkop = 1 TO ::nCopies
         IF ! Eval( ::BeforePrintCopy, ilkop )
            RR_LALABYE( 0, ::hData )
            ::PrintingEMF := .F.
            ::PreviewMode := .T.
            RETURN Self
         ENDIF
         ::StartDoc()
         FOR i := Max( 1, ::nFromPage ) TO Min( ::iloscstron, ::nToPage )
            DO CASE
            CASE ::PrintOpt == 1 ; toprint := .T.
            CASE ::PrintOpt == 2 .OR. ::PrintOpt == 4 ; toprint := !( i % 2 == 0 )
            CASE ::PrintOpt == 3 .OR. ::PrintOpt == 5 ; toprint := ( i % 2 == 0 )
            ENDCASE
            IF toprint
               toprint := .F.
               ::setpage( ::MetaFiles[ i, 6 ], ::MetaFiles[ i, 7 ] )
               ::startpage()
               IF ::InMemory
                  RR_PLAYENHMETAFILE( ::MetaFiles[ i ], ::hDCRef )
               ELSE
                  RR_PLAYFENHMETAFILE( ::MetaFiles[ i ], ::hDCRef )
               END

               ::endpage()
            ENDIF
         NEXT i
         ::enddoc()

         IF ::PrintOpt == 4 .OR. ::PrintOpt == 5
            MsgBox( ::aopisy[ 30 ], ::aopisy[ 29 ] )
            ::StartDoc()
            FOR i := Max( 1, ::nFromPage ) TO Min( ::iloscstron, ::nToPage )
               DO CASE
               CASE ::PrintOpt == 4 ; toprint := ( i % 2 == 0 )
               CASE ::PrintOpt == 5 ; toprint := !( i % 2 == 0 )
               ENDCASE
               IF toprint
                  toprint := .F.
                  ::setpage( ::MetaFiles[ i, 6 ], ::MetaFiles[ i, 7 ] )
                  ::startpage()
                  IF ::InMemory
                     RR_PLAYENHMETAFILE( ::MetaFiles[ i ], ::hDCRef )
                  ELSE
                     RR_PLAYFENHMETAFILE( ::MetaFiles[ i ], ::hDCRef )
                  END

                  ::endpage()
               ENDIF
            NEXT i
            ::enddoc()
         ENDIF
      NEXT ilkop
   ENDIF
   RR_LALABYE( 0, ::hData )
   ::PrintingEMF := .F.
   ::PreviewMode := .T.
   Eval( ::AfterPrint )

   RETURN Self

METHOD Preview( cParent, lWait, lSize ) CLASS HBPrinter

   LOCAL i, pi, cLang, cName

   ASSIGN lWait VALUE lWait TYPE "L" DEFAULT .T.
   ASSIGN lSize VALUE lSize TYPE "L" DEFAULT ! lWait

   ::aopisy := { "Preview", ;
      "&Cancel", ;
      "&Print", ;
      "&Save", ;
      "&First", ;
      "P&revious", ;
      "&Next", ;
      "&Last", ;
      "Zoom In", ;
      "Zoom Out", ;
      "&Options", ;
      "Go To Page:", ;
      "Page preview ", ;
      "Thumbnails preview", ;
      "Page", ;
      "Print only current page", ;
      "Pages:", ;
      "No more zoom !", ;
      "Print options", ;
      "Print from", ;
      "to", ;
      "Copies", ;
      "Print Range", ;
      "All from range", ;
      "Odd only", ;
      "Even only", ;
      "All but odd first", ;
      "All but even first", ;
      "Printing ....", ;
      "Waiting for paper change...", ;
      "Press OK to continue!" }

   ::iloscstron := Len( ::metafiles )
   ::ngroup := -1
   ::page := 1
   ::ath := {}
   ::ahs := {}
   ::azoom := { 0, 0, 0, 0 }
   ::scale := ::PreviewScale
   ::npages := {}

   // [x]Harbour's default language
   cLang := Set( _SET_LANGUAGE )
   IF ( i := At( ".", cLang ) ) > 0
      cLang := Left( cLang, i - 1 )
   ENDIF
   cLang := Upper( AllTrim( cLang ) )

   DO CASE
   CASE cLang == "EN"
      ::aopisy := { "Preview", ;
         "&Cancel", ;
         "&Print", ;
         "&Save", ;
         "&First", ;
         "P&revious", ;
         "&Next", ;
         "&Last", ;
         "Zoom In", ;
         "Zoom Out", ;
         "&Options", ;
         "Go to Page:", ;
         "Page preview ", ;
         "Thumbnails preview", ;
         "Page", ;
         "Print only actual page", ;
         "Pages:", ;
         "No more zoom !", ;
         "Print options", ;
         "Print from", ;
         "to", ;
         "Copies", ;
         "Print Range", ;
         "All from range", ;
         "Odd only", ;
         "Even only", ;
         "All but odd first", ;
         "All but even first", ;
         "Printing ....", ;
         "Waiting for paper change...", ;
         "Press OK to continue." }
   CASE cLang == "ES"
      ::aopisy := { "Vista Previa", ;
         "&Salir", ;
         "&Imprimir", ;
         "&Guardar", ;
         "&Primera", ;
         "&Anterior", ;
         "&Siguiente", ;
         "&Última", ;
         "Zoom +", ;
         "Zoom -", ;
         "&Opciones", ;
         "Ir a Página:", ;
         "Página ", ;
         "Miniaturas", ;
         "Página", ;
         "Imprimir página actual", ;
         "Páginas:", ;
         "Zoom Máximo/Mínimo", ;
         "Opciones de Impresión", ;
         "Imprimir de", ;
         "a", ;
         "Copias", ;
         "Imprimir rango", ;
         "Todo a partir de", ;
         "Solo impares", ;
         "Solo pares", ;
         "Todo (impares primero)", ;
         "Todo (pares primero)", ;
         "Imprimiendo ....", ;
         "Esperando cambio de papel...", ;
         "Haga clic en OK para continuar." }
   CASE cLang == "IT"
      ::aopisy := { "Anteprima", ;
         "&Cancella", ;
         "S&tampa", ;
         "&Salva", ;
         "&Primo", ;
         "&Indietro", ;
         "&Avanti", ;
         "&Ultimo", ;
         "Zoom In", ;
         "Zoom Out", ;
         "&Opzioni", ;
         "Pagina:", ;
         "Pagina anteprima ", ;
         "Miniatura Anteprima", ;
         "Pagina", ;
         "Stampa solo pagina attuale", ;
         "Pagine:", ;
         "Limite zoom !", ;
         "Opzioni Stampa", ;
         "Stampa da", ;
         "a", ;
         "Copie", ;
         "Range Stampa", ;
         "Tutte", ;
         "Solo dispari", ;
         "Solo pari", ;
         "Tutte iniziando dispari", ;
         "Tutte iniziando pari", ;
         "Stampa in corso ....", ;
         "Attendere cambio carta...", ;
         "Premere OK per continuare." }
   CASE cLang == "PLWIN"
      ::aopisy := { "Podgl¹d", ;
         "&Rezygnuj", ;
         "&Drukuj", ;
         "Zapisz", ;
         "Pierwsza", ;
         "Poprzednia", ;
         "Nastêpna", ;
         "Ostatnia", ;
         "Powiêksz", ;
         "Pomniejsz", ;
         "Opc&je", ;
         "IdŸ do strony:", ;
         "Podgl¹d strony", ;
         "Podgl¹d miniaturek", ;
         "Strona", ;
         "Drukuj aktualn¹ stronê", ;
         "Stron:", ;
         "Nie mozna wiêcej !", ;
         "Opcje drukowania", ;
         "Drukuj od", ;
         "do", ;
         "Kopii", ;
         "Zakres", ;
         "Wszystkie z zakresu", ;
         "Tylko nieparzyste", ;
         "Tylko parzyste", ;
         "Najpierw nieparzyste", ;
         "Najpierw parzyste", ;
         "Drukowanie ....", ;
         "Czekam na zmiane papieru...", ;
         "Nacisnij OK, aby kontynuowac." }
   CASE cLang == "PT"
      ::aopisy := { "Inspeção Prévia", ;
         "&Cancelar", ;
         "&Imprimir", ;
         "&Salvar", ;
         "&Primera", ;
         "&Anterior", ;
         "Próximo", ;
         "&Último", ;
         "Zoom +", ;
         "Zoom -", ;
         "&Opções", ;
         "Pag.:", ;
         "Página ", ;
         "Miniaturas", ;
         "Pag.", ;
         "Imprimir somente a pag. atual", ;
         "Páginas:", ;
         "Zoom Máximo/Minimo", ;
         "Opções de Impressão", ;
         "Imprimir de", ;
         "Esta", ;
         "Cópias", ;
         "Imprimir rango", ;
         "Tudo a partir desta", ;
         "Só Ímpares", ;
         "Só Pares", ;
         "Todas as Ímpares Primeiro", ;
         "Todas Pares primero", ;
         "Imprimindo ....", ;
         "Esperando por papel...", ;
         "Pressione OK para continuar." }
   CASE cLang == "DEWIN"
      ::aopisy := { "Vorschau", ;
         "&Abbruch", ;
         "&Drucken", ;
         "&Speichern", ;
         "&Erste", ;
         "&Vorige", ;
         "&Nächste", ;
         "&Letzte", ;
         "Ver&größern", ;
         "Ver&kleinern", ;
         "&Optionen", ;
         "Seite:", ;
         "Seitenvorschau", ;
         "Überblick", ;
         "Seite", ;
         "Aktuelle Seite drucken", ;
         "Seiten:", ;
         "Maximum erreicht!", ;
         "Druckeroptionen", ;
         "Drucke von", ;
         "bis", ;
         "Anzahl", ;
         "Bereich", ;
         "Alle Seiten", ;
         "Ungerade Seiten", ;
         "Gerade Seiten", ;
         "Alles ungerade Seiten zuerst", ;
         "Alles gerade Seiten zuerst", ;
         "Druckt ....", ;
         "Bitte Papier nachlegen...", ;
         "Drücken Sie OK, um fortzufahren." }
   CASE cLang == 'FR'
      ::aopisy := { "Prévisualisation", ;
         "&Abandonner", ;
         "&Imprimer", ;
         "&Sauver", ;
         "&Premier", ;
         "P&récédent", ;
         "&Suivant", ;
         "&Dernier", ;
         "Zoom +", ;
         "Zoom -", ;
         "&Options", ;
         "Aller à la page:", ;
         "Aperçu de la page", ;
         "Aperçu affichettes", ;
         "Page", ;
         "Imprimer la page en cours", ;
         "Pages:", ;
         "Plus de zoom !", ;
         "Options d'impression", ;
         "Imprimer de", ;
         "à", ;
         "Copies", ;
         "Intervalle d'impression", ;
         "Tout dans l'intervalle", ;
         "Impair seulement", ;
         "Pair seulement", ;
         "Tout mais impair d'abord", ;
         "Tout mais pair d'abord", ;
         "Impression ....", ;
         "Attente de changement de papier...", ;
         "Appuyez sur OK pour continuer." }
   ENDCASE

   IF ::nwhattoprint < 2
      ::ntopage := ::iloscstron
   ENDIF

   IF ! ::PreviewMode
      RETURN Self
   ENDIF
   AAdd( ::ahs, { 0, 0, 0, 0, 0, 0, 0 } )
   RR_GETWINDOWRECT( ::ahs[ 1 ] )

   FOR pi := 1 TO ::iloscstron
      AAdd( ::npages, PadL( pi, 4 ) )
   NEXT pi

   IF ::PreviewRect[ 3 ] > 0 .AND. ::PreviewRect[ 4 ] > 0
      ::ahs[ 1, 1 ] := ::Previewrect[ 1 ]
      ::ahs[ 1, 2 ] := ::Previewrect[ 2 ]
      ::ahs[ 1, 3 ] := ::Previewrect[ 3 ]
      ::ahs[ 1, 4 ] := ::Previewrect[ 4 ]
      ::ahs[ 1, 5 ] := ::Previewrect[ 3 ] - ::Previewrect[ 1 ] + 1
      ::ahs[ 1, 6 ] := ::Previewrect[ 4 ] - ::Previewrect[ 2 ] + 1
   ELSE
      ::ahs[ 1, 1 ] += 10
      ::ahs[ 1, 2 ] += 10
      ::ahs[ 1, 3 ] -= 10
      ::ahs[ 1, 4 ] -= 10
      ::ahs[ 1, 5 ] := ::ahs[ 1, 3 ] - ::ahs[ 1, 1 ] + 1
      ::ahs[ 1, 6 ] := ::ahs[ 1, 4 ] - ::ahs[ 1, 2 ] + 1
   ENDIF

   IF lSize
      IF lWait
         DEFINE WINDOW 0 OBJ ::oWinPreview ;
            AT ::ahs[ 1, 1 ], ::ahs[ 1, 1 ] ;
            WIDTH ::ahs[ 1, 6 ] ;
            HEIGHT ::ahs[ 1, 5 ] - 45 ;
            TITLE ::aopisy[ 1 ] ;
            ICON 'ZZZ_PRINTICON' ;
            MODAL ;
            ON SIZE ::PrevAdjust()
      ELSE
         DEFINE WINDOW 0 OBJ ::oWinPreview ;
            PARENT ( cParent ) ;
            AT ::ahs[ 1, 1 ], ::ahs[ 1, 1 ] ;
            WIDTH ::ahs[ 1, 6 ] ;
            HEIGHT ::ahs[ 1, 5 ] - 45 ;
            TITLE ::aopisy[ 1 ] ;
            ICON 'ZZZ_PRINTICON' ;
            CHILD ;
            ON SIZE ::PrevAdjust()
      ENDIF
   ELSE
      IF lWait
         DEFINE WINDOW 0 OBJ ::oWinPreview ;
            AT ::ahs[ 1, 1 ], ::ahs[ 1, 1 ] ;
            WIDTH ::ahs[ 1, 6 ] ;
            HEIGHT ::ahs[ 1, 5 ] - 45 ;
            TITLE ::aopisy[ 1 ] ;
            ICON 'ZZZ_PRINTICON' ;
            MODAL ;
            NOSIZE
      ELSE
         DEFINE WINDOW 0 OBJ ::oWinPreview ;
            PARENT ( cParent ) ;
            AT ::ahs[ 1, 1 ], ::ahs[ 1, 1 ] ;
            WIDTH ::ahs[ 1, 6 ] ;
            HEIGHT ::ahs[ 1, 5 ] - 45 ;
            TITLE ::aopisy[ 1 ] ;
            ICON 'ZZZ_PRINTICON' ;
            CHILD ;
            NOSIZE
      ENDIF
   ENDIF

/*
   DEFINE WINDOW 0 OBJ ::oWinPreview ;
*/
      ::oWinPreview:HotKey( 27, 0, {|| ::oWinPreview:Release() } )
      ::oWinPreview:HotKey( 107, 0, {|| ::scale := ::scale * 1.25, ::PrevShow() } )
      ::oWinPreview:HotKey( 109, 0, {|| ::scale := ::scale / 1.25, ::PrevShow() } )

      DEFINE STATUSBAR
         STATUSITEM ::aopisy[ 15 ] + " " + AllTrim( Str( ::Page ) ) WIDTH 100
         STATUSITEM ::aopisy[ 16 ] WIDTH 200 ICON 'ZZZ_PRINTICON' ACTION ::PrevPrint( ::Page ) RAISED
         STATUSITEM ::aopisy[ 17 ] + " " + AllTrim( Str( ::iloscstron ) ) WIDTH 100
      END STATUSBAR

      @ 15, ::ahs[ 1, 6 ] - 150 LABEL prl VALUE ::aopisy[ 12 ] WIDTH 80 HEIGHT 18 SIZE 8 TRANSPARENT
      @ 13, ::ahs[ 1, 6 ] - 77 COMBOBOX combo_1 ITEMS ::npages VALUE 1 WIDTH 58 SIZE 8 ;
         ON CHANGE {|| ::Page := ::CurPage := ::oWinPreview:combo_1:value, ::PrevShow(), ::oWinPagePreview:setfocus() }

      DEFINE SPLITBOX
         DEFINE TOOLBAR TB1 BUTTONSIZE 50, 37 SIZE 8 FLAT BREAK
            BUTTON B1 CAPTION ::aopisy[ 2 ] PICTURE 'hbprint_close' ACTION ::PrevClose()
            BUTTON B2 CAPTION ::aopisy[ 3 ] PICTURE 'hbprint_print' ACTION {|| ::prevprint() }
            IF ! ::NoButtonSave
               BUTTON B3 CAPTION ::aopisy[ 4 ] PICTURE 'hbprint_save' ACTION {|| ::savemetafiles() }
            ENDIF
            IF ::iloscstron > 1
               BUTTON B4 CAPTION ::aopisy[ 5 ] PICTURE 'hbprint_top' ACTION {|| ::Page := ::CurPage := 1, ::oWinPreview:combo_1:value := ::Page, ::PrevShow() }
               BUTTON B5 CAPTION ::aopisy[ 6 ] PICTURE 'hbprint_back' ACTION {|| ::Page := ::CurPage := iif( ::Page == 1, 1, ::Page - 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() }
               BUTTON B6 CAPTION ::aopisy[ 7 ] PICTURE 'hbprint_next' ACTION {|| ::Page := ::CurPage := iif( ::Page == ::iloscstron, ::Page, ::Page + 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() }
               BUTTON B7 CAPTION ::aopisy[ 8 ] PICTURE 'hbprint_end' ACTION {|| ::Page := ::CurPage := ::iloscstron, ::oWinPreview:combo_1:value := ::Page, ::PrevShow() }
            ENDIF
            BUTTON B8 CAPTION ::aopisy[ 9 ] PICTURE 'hbprint_zoomin' ACTION {|| ::scale := ::scale * 1.25, ::PrevShow() }
            BUTTON B9 CAPTION ::aopisy[ 10 ] PICTURE 'hbprint_zoomout' ACTION {|| ::scale := ::scale / 1.25, ::PrevShow() }
            IF ! ::NoButtonOptions
               BUTTON B10 CAPTION ::aopisy[ 11 ] PICTURE 'hbprint_option' ACTION {|| ::PrintOption() }
            ENDIF
         END TOOLBAR

         AAdd( ::ahs, { 0, 0, 0, 0, 0, 0, ::oWinPreview:hWnd } )
         RR_GETCLIENTRECT( ::ahs[ 2 ] )
         AAdd( ::ahs, { 0, 0, 0, 0, 0, 0, ::oWinPreview:Tb1:hWnd } )
         RR_GETCLIENTRECT( ::ahs[ 3 ] )
         AAdd( ::ahs, { 0, 0, 0, 0, 0, 0, ::oWinPreview:StatusBar:hWnd } )
         RR_GETCLIENTRECT( ::ahs[ 4 ] )

         DEFINE WINDOW 0 OBJ ::oWinPagePreview ;
            WIDTH ::ahs[ 2, 6 ] - 15 ;
            HEIGHT ::ahs[ 2, 5 ] - ::ahs[ 3, 5 ] - ::ahs[ 4, 5 ] - 10 ;
            VIRTUAL WIDTH ::ahs[ 2, 6 ] - 5 ;
            VIRTUAL HEIGHT ::ahs[ 2, 5 ] - ::ahs[ 3, 5 ] - ::ahs[ 4, 5 ] ;
            TITLE ::aopisy[ 13 ] ;
            SPLITCHILD ;
            GRIPPERTEXT "P" ;
            NOSYSMENU ;
            NOCAPTION ;
            ON MOUSECLICK ::oWinPagePreview:setfocus()

            ::oWinPagePreview:VScrollbar:nLineSkip := 20
            ::oWinPagePreview:HScrollbar:nLineSkip := 20
            AAdd( ::ahs, { 0, 0, 0, 0, 0, 0, ::oWinPagePreview:hWnd } )
            RR_GETCLIENTRECT( ::ahs[ 5 ] )
            @ ::ahs[ 5, 2 ] + 10, ::ahs[ 5, 1 ] + 10 IMAGE I1 PICTURE "" WIDTH ::ahs[ 5, 6 ] - 10 HEIGHT ::ahs[ 5, 5 ] - 10
            AAdd( ::ahs, { 0, 0, 0, 0, 0, 0, ::oWinPagePreview:i1:hWnd } )
            RR_GETCLIENTRECT( ::ahs[ 6 ] )
         END WINDOW

         IF ::Thumbnails .AND. ::iloscstron > 1
            DEFINE WINDOW 0 OBJ ::oWinThumbs ;
               WIDTH ::ahs[ 2, 6 ] - 15 ;
               HEIGHT ::ahs[ 2, 5 ] - ::ahs[ 3, 5 ] - ::ahs[ 4, 5 ] - 10 ;
               TITLE ::aopisy[ 14 ] ;
               SPLITCHILD ;
               GRIPPERTEXT "T"

               AAdd( ::ahs, { 0, 0, 0, 0, 0, 0, ::oWinThumbs:hWnd } )
               RR_GETCLIENTRECT( ::ahs[ 7 ] )
               ::dx := ( ::ahs[ 5, 6 ] - 20 ) / 5 - 5
               ::dy := ::ahs[ 5, 5 ] / 3 - 5
               FOR i := 1 TO 15
                  AAdd( ::ath, { 0, 0, 0, 0, 0 } )
                  IF ::Metafiles[ 1, 2 ] >= ::Metafiles[ 1, 3 ]
                     ::ath[ i, 3 ] := ::dy - 5
                     ::ath[ i, 4 ] := ::dx * ::Metafiles[ 1, 3 ] / ::Metafiles[ 1, 2 ] - 5
                  ELSE
                     ::ath[ i, 4 ] := ::dx - 5
                     ::ath[ i, 3 ] := ::dy * ::Metafiles[ 1, 2 ] / ::Metafiles[ 1, 3 ] - 5
                  ENDIF
                  ::ath[ i, 1 ] := Int( ( i - 1 ) / 5 ) * ::dy + 5
                  ::ath[ i, 2 ] := ( ( i - 1 ) % 5 ) * ::dx + 5
               NEXT
               @ ::ath[ 1, 1 ], ::ath[ 1, 2 ] IMAGE it1 PICTURE "" ACTION {|| ::Prevthumb( 1 ) } WIDTH ::ath[ 1, 4 ] HEIGHT ::ath[ 1, 3 ]
               @ ::ath[ 2, 1 ], ::ath[ 2, 2 ] IMAGE it2 PICTURE "" ACTION {|| ::Prevthumb( 2 ) } WIDTH ::ath[ 2, 4 ] HEIGHT ::ath[ 2, 3 ]
               @ ::ath[ 3, 1 ], ::ath[ 3, 2 ] IMAGE it3 PICTURE "" ACTION {|| ::Prevthumb( 3 ) } WIDTH ::ath[ 3, 4 ] HEIGHT ::ath[ 3, 3 ]
               @ ::ath[ 4, 1 ], ::ath[ 4, 2 ] IMAGE it4 PICTURE "" ACTION {|| ::Prevthumb( 4 ) } WIDTH ::ath[ 4, 4 ] HEIGHT ::ath[ 4, 3 ]
               @ ::ath[ 5, 1 ], ::ath[ 5, 2 ] IMAGE it5 PICTURE "" ACTION {|| ::Prevthumb( 5 ) } WIDTH ::ath[ 5, 4 ] HEIGHT ::ath[ 5, 3 ]
               @ ::ath[ 6, 1 ], ::ath[ 6, 2 ] IMAGE it6 PICTURE "" ACTION {|| ::Prevthumb( 6 ) } WIDTH ::ath[ 6, 4 ] HEIGHT ::ath[ 6, 3 ]
               @ ::ath[ 7, 1 ], ::ath[ 7, 2 ] IMAGE it7 PICTURE "" ACTION {|| ::Prevthumb( 7 ) } WIDTH ::ath[ 7, 4 ] HEIGHT ::ath[ 7, 3 ]
               @ ::ath[ 8, 1 ], ::ath[ 8, 2 ] IMAGE it8 PICTURE "" ACTION {|| ::Prevthumb( 8 ) } WIDTH ::ath[ 8, 4 ] HEIGHT ::ath[ 8, 3 ]
               @ ::ath[ 9, 1 ], ::ath[ 9, 2 ] IMAGE it9 PICTURE "" ACTION {|| ::Prevthumb( 9 ) } WIDTH ::ath[ 9, 4 ] HEIGHT ::ath[ 9, 3 ]
               @ ::ath[ 10, 1 ], ::ath[ 10, 2 ] IMAGE it10 PICTURE "" ACTION {|| ::Prevthumb( 10 ) } WIDTH ::ath[ 10, 4 ] HEIGHT ::ath[ 10, 3 ]
               @ ::ath[ 11, 1 ], ::ath[ 11, 2 ] IMAGE it11 PICTURE "" ACTION {|| ::Prevthumb( 11 ) } WIDTH ::ath[ 11, 4 ] HEIGHT ::ath[ 11, 3 ]
               @ ::ath[ 12, 1 ], ::ath[ 12, 2 ] IMAGE it12 PICTURE "" ACTION {|| ::Prevthumb( 12 ) } WIDTH ::ath[ 12, 4 ] HEIGHT ::ath[ 12, 3 ]
               @ ::ath[ 13, 1 ], ::ath[ 13, 2 ] IMAGE it13 PICTURE "" ACTION {|| ::Prevthumb( 13 ) } WIDTH ::ath[ 13, 4 ] HEIGHT ::ath[ 13, 3 ]
               @ ::ath[ 14, 1 ], ::ath[ 14, 2 ] IMAGE it14 PICTURE "" ACTION {|| ::Prevthumb( 14 ) } WIDTH ::ath[ 14, 4 ] HEIGHT ::ath[ 14, 3 ]
               @ ::ath[ 15, 1 ], ::ath[ 15, 2 ] IMAGE it15 PICTURE "" ACTION {|| ::Prevthumb( 15 ) } WIDTH ::ath[ 15, 4 ] HEIGHT ::ath[ 15, 3 ]

               cName := ::oWinThumbs:Name
               FOR i := 1 TO 15
                  ::ath[ i, 5 ] := GetControlHandle( "it" + AllTrim( Str( i ) ), cName )
                  RR_PLAYTHUMB( ::ath[ i ], ::Metafiles[ i ], AllTrim( Str( i ) ), i, ::hData )
                  IF i >= ::iloscstron
                     EXIT
                  ENDIF
               NEXT
            END WINDOW
         ENDIF
      END SPLITBOX
   END WINDOW

   ::PrevShow()
   ::oWinPagePreview:i1:SetFocus()
   ::oWinPreview:Activate( ! lWait )

   RETURN NIL

METHOD PrevAdjust() CLASS HBPrinter

   ::oWinPreview:prl:col := ::oWinPreview:width - 150
   ::oWinPreview:combo_1:col := ::oWinPreview:width - 77

   RETURN NIL

METHOD PrevClose() CLASS HBPrinter

   ::oWinPagePreview:Release()
   IF ::iloscstron > 1 .AND. ::Thumbnails
      ::oWinThumbs:Release()
   ENDIF
   ::oWinPreview:Release()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintOption() CLASS HBPrinter

   LOCAL OKprint := .F.

   IF ! HB_ISOBJECT( ::oWinPrOpt )
      DEFINE WINDOW 0 OBJ ::oWinPrOpt ;
            AT 270, 346 ;
            WIDTH 298 HEIGHT 134 ;
            TITLE ::aopisy[ 19 ] ;
            ICON 'ZZZ_PRINTICON' ;
            MODAL ;
            NOSIZE

         @ 02, 001 FRAME PrOptFrame WIDTH 291 HEIGHT 105
         @ 19, 009 LABEL label_11 WIDTH 087 HEIGHT 016 VALUE ::aopisy[ 20 ] BOLD
         @ 18, 090 TEXTBOX textFrom WIDTH 033 HEIGHT 021 NUMERIC MAXLENGTH 4 RIGHTALIGN
         @ 19, 134 LABEL label_12 WIDTH 014 HEIGHT 019 VALUE ::aopisy[ 21 ] BOLD
         @ 18, 156 TEXTBOX textTo WIDTH 033 HEIGHT 021 NUMERIC MAXLENGTH 4 RIGHTALIGN
         @ 19, 200 LABEL label_18 WIDTH 040 HEIGHT 019 VALUE ::aopisy[ 22 ] BOLD
         @ 18, 252 TEXTBOX textCopies WIDTH 030 HEIGHT 021 NUMERIC MAXLENGTH 4 RIGHTALIGN
         @ 55, 009 LABEL label_13 WIDTH 071 HEIGHT 017 VALUE ::aopisy[ 23 ] BOLD
         @ 50, 090 COMBOBOX prnCombo WIDTH 195 VALUE ::PrintOpt ITEMS { ::aopisy[ 24 ], ::aopisy[ 25 ], ::aopisy[ 26 ], ::aopisy[ 27 ], ::aopisy[ 28 ] }

         @ 82, 090 BUTTON button_14 WIDTH 110 HEIGHT 019 CAPTION "OK" ;
            ACTION {|| ::nFromPage := ::oWinPrOpt:textFrom:Value, ;
            ::nToPage := ::oWinPrOpt:textTo:Value, ;
            ::nCopies := Max( ::oWinPrOpt:textCopies:Value, 1 ), ;
            ::PrintOpt := ::oWinPrOpt:prnCombo:Value, ;
            ::oWinPrOpt:Release() }
      END WINDOW
   ENDIF
   ::oWinPrOpt:Title := ::aopisy[ 19 ]
   ::oWinPrOpt:textCopies:Value := ::nCopies
   ::oWinPrOpt:textFrom:Value := Max( ::nfrompage, 1 )
   ::oWinPrOpt:textTo:Value := iif( ::nwhattoprint < 2, ::iloscstron, ::ntopage )
   ::oWinPrOpt:Activate( .F. )

   RETURN OKPrint

#endif // NO_GUI


/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#ifndef WINVER
   #define WINVER 0x0400
#endif
#if ( WINVER < 0x0400 )
   #undef WINVER
   #define WINVER 0x0400
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif
#if ( _WIN32_WINNT < 0x0400 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0400
#endif

#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include <olectl.h>
#include <ocidl.h>
#include <commctrl.h>
#include "oohg.h"

typedef struct _HBPRINTERDATA
{
   HDC              hDC;
   HDC              hDCRef;
   HDC              hDCtemp;
   HANDLE           hPrinter;
   PRINTER_DEFAULTS pd;
   PRINTDLG         pdlg;
   DOCINFO          di;
   INT              nFromPage;
   INT              nToPage;
   DWORD            charset;
   HFONT            hfont;
   HPEN             hpen;
   HBRUSH           hbrush;
   INT              textjust;
   INT              preview;
   INT              polyfillmode;
   HRGN             hrgn;
   DEVMODE *        pDevMode;
   DEVMODE *        pDevMode2;
   DEVNAMES *       pDevNames;
   PRINTER_INFO_2 * pi2;
   PRINTER_INFO_2 * pi22;
   CHAR             PrinterName[ 128 ];
   CHAR             PrinterDefault[ 128 ];
   INT              devcaps[ 17 ];
   HBITMAP          hbmp[ 15 ];
   OSVERSIONINFO    osvi;
} HBPRINTERDATA, * LPHBPRINTERDATA;

/*--------------------------------------------------------------------------------------------------------------------------------*/
static VOID RR_GetDevmode( HBPRINTERDATA * lpData )
{
   DWORD dwNeeded = 0;

   memset( &lpData->pd, 0, sizeof( lpData->pd ) );
   lpData->pd.DesiredAccess = PRINTER_ALL_ACCESS;
   OpenPrinter( lpData->PrinterName, &lpData->hPrinter, NULL );
   GetPrinter( lpData->hPrinter, 2, 0, 0, &dwNeeded );
   lpData->pi2 = ( PRINTER_INFO_2 * ) GlobalAlloc( GPTR, dwNeeded );
   GetPrinter( lpData->hPrinter, 2, ( LPBYTE ) lpData->pi2, dwNeeded, &dwNeeded );
   lpData->pi22 = ( PRINTER_INFO_2 * ) GlobalAlloc( GPTR, dwNeeded );
   GetPrinter( lpData->hPrinter, 2, ( LPBYTE ) lpData->pi22, dwNeeded, &dwNeeded );

   if( lpData->pDevMode )
   {
      lpData->pi2->pDevMode = lpData->pDevMode;
   }
   else
   {
      if( lpData->pi2->pDevMode == NULL )
      {
         dwNeeded = DocumentProperties( NULL, lpData->hPrinter, lpData->PrinterName, NULL, NULL, 0 );
         lpData->pDevMode2 = ( DEVMODE * ) GlobalAlloc( GPTR, dwNeeded );
         DocumentProperties( NULL, lpData->hPrinter, lpData->PrinterName, lpData->pDevMode2, NULL, DM_OUT_BUFFER );
         lpData->pi2->pDevMode = lpData->pDevMode2;
      }
   }
   lpData->hfont = ( HFONT ) GetCurrentObject( lpData->hDC, OBJ_FONT );
   lpData->hbrush = ( HBRUSH ) GetCurrentObject( lpData->hDC, OBJ_BRUSH );
   lpData->hpen = ( HPEN ) GetCurrentObject( lpData->hDC, OBJ_PEN );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATEHBPRINTERDATA )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) hb_xgrab( ( sizeof( HBPRINTERDATA ) ) );

   memset( lpData, 0, sizeof( HBPRINTERDATA ) );

   lpData->charset = DEFAULT_CHARSET;
   lpData->devcaps[ 15 ] = 1;
   lpData->polyfillmode = 1;
   lpData->osvi.dwOSVersionInfoSize = sizeof( OSVERSIONINFO );
   GetVersionEx( &lpData->osvi );

   HB_RETNL( ( LONG_PTR ) lpData );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_FINISH )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   ClosePrinter( lpData->hPrinter );
   hb_xfree( lpData );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PRINTERNAME )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   hb_retc( lpData->PrinterName );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PRINTDIALOG )
{
   HWND hwnd;
   LPCTSTR pDevice;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   memset( &lpData->pdlg, 0, sizeof( lpData->pdlg ) );
   lpData->pdlg.lStructSize = sizeof( lpData->pdlg );
   lpData->pdlg.Flags = PD_RETURNDC | PD_ALLPAGES;
   lpData->pdlg.nFromPage = 1;
   lpData->pdlg.nToPage = 1;
   hwnd = GetActiveWindow();
   lpData->pdlg.hwndOwner = hwnd;

   if( PrintDlg( &lpData->pdlg ) )
   {
      lpData->hDC = lpData->pdlg.hDC;
      lpData->pDevMode = ( LPDEVMODE ) GlobalLock( lpData->pdlg.hDevMode );
      lpData->pDevNames = ( LPDEVNAMES ) GlobalLock( lpData->pdlg.hDevNames );
      // Note: pDevMode->dmDeviceName is limited to 32 characters.
      // if the printer name is greater than 32, like network printers,
      // the RR_GETDC() function return a null handle. So, I'm using
      // pDevNames instead pDevMode.
      // strcpy( lpData->PrinterName, pDevMode->dmDeviceName );
      pDevice = ( LPCTSTR ) lpData->pDevNames + lpData->pDevNames->wDeviceOffset;
      strcpy( lpData->PrinterName, pDevice );

      if( lpData->hDC == NULL )
      {
         strcpy( lpData->PrinterName, "" );
         GlobalUnlock( lpData->pdlg.hDevMode );
         GlobalUnlock( lpData->pdlg.hDevNames );
      }
      else
      {
         HB_STORNL3( ( LONG ) lpData->pdlg.nFromPage, 1, 1 );
         HB_STORNL3( ( LONG ) lpData->pdlg.nToPage, 1, 2 );
         HB_STORNL3( ( LONG ) lpData->pdlg.nCopies, 1, 3 );
         if( ( lpData->pdlg.Flags & PD_PAGENUMS ) == PD_PAGENUMS )
         {
            HB_STORNL3( 2, 1, 4 );
         }
         else
         {
            if( ( lpData->pdlg.Flags & PD_SELECTION ) == PD_SELECTION )
            {
               HB_STORNL3( 1, 1, 4 );
            }
            else
            {
               HB_STORNL3( 0, 1, 4 );
            }
         }
         RR_GetDevmode( lpData );
      }
   }
   else
   {
      lpData->hDC = 0;
   }

   lpData->hDCRef = lpData->hDC;

   HB_RETNL( ( LONG_PTR ) lpData->hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETDC )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   if( lpData->osvi.dwPlatformId == VER_PLATFORM_WIN32_NT )
   {
      lpData->hDC = CreateDC( "WINSPOOL", hb_parc( 1 ), NULL, NULL );
   }
   else
   {
      lpData->hDC = CreateDC( NULL, hb_parc( 1 ), NULL, NULL );
   }

   if( lpData->hDC )
   {
      strcpy( lpData->PrinterName, hb_parc( 1 ) );
      RR_GetDevmode( lpData );
   }
   lpData->hDCRef = lpData->hDC;
   HB_RETNL( ( LONG_PTR ) lpData->hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_RESETPRINTER )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   if( lpData->pi22 )
   {
      SetPrinter( lpData->hPrinter, 2, ( LPBYTE ) lpData->pi22, 0 );
   }
   GlobalFree( lpData->pi22 );
   lpData->pi22 = NULL;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DELETEDC )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   if( lpData->pdlg.hDevMode )
      GlobalUnlock( lpData->pdlg.hDevMode );
   if( lpData->pDevMode )
      GlobalFree( lpData->pDevMode );
   if( lpData->pDevMode2 )
      GlobalFree( lpData->pDevMode2 );
   if( lpData->pDevNames )
      GlobalFree( lpData->pDevNames );
   if( lpData->pi2 )
      GlobalFree( lpData->pi2 );

   DeleteDC( ( HDC ) HB_PARNL( 1 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETDEVICECAPS )
{
   TEXTMETRIC tm;
   UINT i;
   HFONT xfont = ( HFONT ) HB_PARNL( 2 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 3 );

   if( xfont )
   {
      SelectObject( lpData->hDCRef, xfont );
   }

   GetTextMetrics( lpData->hDCRef, &tm );

   lpData->devcaps[  0 ] = GetDeviceCaps( lpData->hDCRef, VERTSIZE );
   lpData->devcaps[  1 ] = GetDeviceCaps( lpData->hDCRef, HORZSIZE );
   lpData->devcaps[  2 ] = GetDeviceCaps( lpData->hDCRef, VERTRES );
   lpData->devcaps[  3 ] = GetDeviceCaps( lpData->hDCRef, HORZRES );
   lpData->devcaps[  4 ] = GetDeviceCaps( lpData->hDCRef, LOGPIXELSY );
   lpData->devcaps[  5 ] = GetDeviceCaps( lpData->hDCRef, LOGPIXELSX );
   lpData->devcaps[  6 ] = GetDeviceCaps( lpData->hDCRef, PHYSICALHEIGHT );
   lpData->devcaps[  7 ] = GetDeviceCaps( lpData->hDCRef, PHYSICALWIDTH );
   lpData->devcaps[  8 ] = GetDeviceCaps( lpData->hDCRef, PHYSICALOFFSETY );
   lpData->devcaps[  9 ] = GetDeviceCaps( lpData->hDCRef, PHYSICALOFFSETX );
   lpData->devcaps[ 10 ] = tm.tmHeight;
   lpData->devcaps[ 11 ] = tm.tmAveCharWidth;
   lpData->devcaps[ 12 ] = ( INT ) ( ( lpData->devcaps[2] - tm.tmAscent ) / tm.tmHeight );
   lpData->devcaps[ 13 ] = ( INT ) ( lpData->devcaps[3] / tm.tmAveCharWidth );
   lpData->devcaps[ 14 ] = lpData->pi2->pDevMode->dmOrientation;
   lpData->devcaps[ 15 ] = ( INT ) tm.tmAscent;
   lpData->devcaps[ 16 ] = ( INT ) lpData->pi2->pDevMode->dmPaperSize;

   for( i = 1; i <= hb_parinfa( 1, 0 ); i ++ )
   {
      HB_STORNI( lpData->devcaps[ i - 1 ], 1, i );
   }

   if( xfont )
   {
      SelectObject( lpData->hDCRef, lpData->hfont );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETDEVMODE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 4 );
   DWORD what = hb_parnl( 1 );

   if( what == ( lpData->pi2->pDevMode->dmFields & what ) )
   {
      if( what == DM_ORIENTATION )
         lpData->pi2->pDevMode->dmOrientation = ( SHORT ) hb_parni( 2 );
      if( what == DM_PAPERSIZE )
         lpData->pi2->pDevMode->dmPaperSize = ( SHORT) hb_parni( 2 );
      if( what == DM_SCALE )
         lpData->pi2->pDevMode->dmScale = ( SHORT ) hb_parni( 2 );
      if( what == DM_COPIES )
         lpData->pi2->pDevMode->dmCopies = ( SHORT ) hb_parni( 2 );
      if( what == DM_DEFAULTSOURCE )
         lpData->pi2->pDevMode->dmDefaultSource = ( SHORT ) hb_parni( 2 );
      if( what == DM_PRINTQUALITY )
         lpData->pi2->pDevMode->dmPrintQuality = ( SHORT ) hb_parni( 2 );
      if( what == DM_COLOR )
         lpData->pi2->pDevMode->dmColor = ( SHORT ) hb_parni( 2 );
      if( what == DM_DUPLEX )
         lpData->pi2->pDevMode->dmDuplex = ( SHORT ) hb_parni( 2 );
      if( what == DM_COLLATE )
         lpData->pi2->pDevMode->dmCollate = ( SHORT ) hb_parni( 2 );
      if( what == DM_PAPERLENGTH )
         lpData->pi2->pDevMode->dmPaperLength = ( SHORT ) hb_parni( 2 );
      if( what == DM_PAPERWIDTH )
         lpData->pi2->pDevMode->dmPaperWidth = ( SHORT ) hb_parni( 2 );

      DocumentProperties( NULL, lpData->hPrinter, lpData->PrinterName, lpData->pi2->pDevMode, lpData->pi2->pDevMode, DM_IN_BUFFER | DM_OUT_BUFFER );
      if( hb_parl( 3 ) )
      {
         SetPrinter( lpData->hPrinter, 2, ( LPBYTE ) lpData->pi2, 0 );
      }
      ResetDC( lpData->hDCRef, lpData->pi2->pDevMode );
      HB_RETNL( ( LONG_PTR ) lpData->hDCRef);
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETDEFAULTPRINTER )
{
   DWORD Needed, Returned;
   DWORD BuffSize = 256;
   LPPRINTER_INFO_5 PrinterInfo;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   if( lpData->osvi.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS )
   {
      EnumPrinters( PRINTER_ENUM_DEFAULT, NULL, 5, NULL, 0, &Needed, &Returned );
      PrinterInfo = ( LPPRINTER_INFO_5 ) LocalAlloc( LPTR, Needed );
      EnumPrinters( PRINTER_ENUM_DEFAULT, NULL, 5, ( LPBYTE ) PrinterInfo, Needed, &Needed, &Returned );
      strcpy( lpData->PrinterDefault, PrinterInfo->pPrinterName );
      LocalFree( PrinterInfo );
   }
   else if( lpData->osvi.dwPlatformId == VER_PLATFORM_WIN32_NT )
   {
      if( lpData->osvi.dwMajorVersion >= 5 ) /* Windows 2000 or later */
      {
         GetProfileString( "windows", "device", "", lpData->PrinterDefault, BuffSize );
         strtok( lpData->PrinterDefault, "," );
      }
      else /* Windows NT 4.0 or earlier */
      {
         GetProfileString( "windows", "device", "", lpData->PrinterDefault, BuffSize);
         strtok( lpData->PrinterDefault, "," );
      }
   }
   hb_retc( lpData->PrinterDefault );
   return;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETPRINTERS )
{
   DWORD dwSize = 0;
   DWORD dwPrinters = 0;
   DWORD i;
   CHAR * pBuffer;
   CHAR * cBuffer;
   PRINTER_INFO_4 * pInfo4;
   PRINTER_INFO_5 * pInfo5;
   DWORD level;
   DWORD flags;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   if( lpData->osvi.dwPlatformId == VER_PLATFORM_WIN32_NT )
   {
      level = 4;
      flags = PRINTER_ENUM_CONNECTIONS | PRINTER_ENUM_LOCAL;
   }
   else
   {
      level = 5;
      flags = PRINTER_ENUM_LOCAL;
   }

   EnumPrinters( flags, NULL, level, NULL, 0, &dwSize, &dwPrinters );

   pBuffer = ( CHAR * ) GlobalAlloc( GPTR, dwSize );
   if( pBuffer == NULL )
   {
      hb_retc( ",," );
      return;
   }
   EnumPrinters( flags, NULL, level, ( BYTE * ) pBuffer, dwSize, &dwSize, &dwPrinters );

   if( dwPrinters == 0 )
   {
      hb_retc( ",," );
      return;
   }
   cBuffer = ( CHAR * ) GlobalAlloc( GPTR, dwPrinters * 256 );

   if( lpData->osvi.dwPlatformId == VER_PLATFORM_WIN32_NT )
   {
      pInfo4 = ( PRINTER_INFO_4 * ) pBuffer;

      for( i = 0; i < dwPrinters; i++ )
      {
         strcat( cBuffer, pInfo4->pPrinterName );
         strcat( cBuffer, "," );
         if( pInfo4->Attributes == PRINTER_ATTRIBUTE_LOCAL )
         {
            strcat( cBuffer, "local printer" );
         }
         else
         {
            strcat( cBuffer, "network printer" );
         }

         pInfo4++;

         if( i < dwPrinters - 1 )
         {
            strcat( cBuffer, ",," );
         }
      }
   }
   else
   {
      pInfo5 = ( PRINTER_INFO_5 * ) pBuffer;

      for( i = 0; i < dwPrinters; i++ )
      {
         strcat( cBuffer, pInfo5->pPrinterName );
         strcat( cBuffer, "," );
         strcat( cBuffer, pInfo5->pPortName );

         pInfo5++;

         if( i < dwPrinters - 1 )
         {
            strcat( cBuffer, ",," );
         }
      }
   }

   hb_retc( cBuffer );
   GlobalFree( pBuffer );
   GlobalFree( cBuffer );
   return;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_STARTDOC )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   memset( &lpData->di, 0, sizeof( lpData->di ) );
   lpData->di.cbSize = sizeof( lpData->di );
   lpData->di.lpszDocName = hb_parc( 1 );
   StartDoc( lpData->hDC, &lpData->di );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_STARTPAGE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   StartPage( lpData->hDC );
   SetTextAlign( lpData->hDC, TA_BASELINE );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_ENDPAGE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   EndPage( lpData->hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_ENDDOC )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   EndDoc( lpData->hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_ABORTDOC )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   AbortDoc( lpData->hDC );
   DeleteDC( lpData->hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DEVICECAPABILITIES )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 3 );
   HGLOBAL cBuf, pBuf, nBuf, sBuf, bnBuf, bwBuf, bcBuf;
   CHAR * cBuffer, * pBuffer, * nBuffer, * sBuffer, * bnBuffer, * bwBuffer, * bcBuffer;
   DWORD numpapers, numbins, i;
   LPPOINT lp;
   CHAR buffer[ sizeof( LONG ) * 8 + 1 ];

   numbins = DeviceCapabilities( lpData->pi2->pPrinterName, lpData->pi2->pPortName, DC_BINNAMES, NULL, NULL );
   numpapers = DeviceCapabilities( lpData->pi2->pPrinterName, lpData->pi2->pPortName, DC_PAPERNAMES, NULL, NULL );
   if( numpapers != ( DWORD ) 0 && numpapers != ( DWORD ) ( ~ 0 ) )
   {
      pBuf = GlobalAlloc( GPTR, numpapers * 64 );
      nBuf = GlobalAlloc( GPTR, numpapers * sizeof( WORD ) );
      sBuf = GlobalAlloc( GPTR, numpapers * sizeof( POINT ) );
      cBuf = GlobalAlloc( GPTR, numpapers * 128 );
      pBuffer = ( CHAR * ) pBuf;
      nBuffer = ( CHAR * ) nBuf;
      sBuffer = ( CHAR * ) sBuf;
      cBuffer = ( CHAR * ) cBuf;
      DeviceCapabilities( lpData->pi2->pPrinterName, lpData->pi2->pPortName, DC_PAPERNAMES, pBuffer, lpData->pi2->pDevMode );
      DeviceCapabilities( lpData->pi2->pPrinterName, lpData->pi2->pPortName, DC_PAPERS, nBuffer, lpData->pi2->pDevMode );
      DeviceCapabilities( lpData->pi2->pPrinterName, lpData->pi2->pPortName, DC_PAPERSIZE, sBuffer, lpData->pi2->pDevMode );
      cBuffer[ 0 ] = 0;
      for( i = 0; i < numpapers; i++ )
      {
         strcat( cBuffer, pBuffer );
         strcat( cBuffer, "," );
         strcat( cBuffer, _OOHG_ITOA( * nBuffer, buffer, 10 ) );
         strcat( cBuffer, "," );

         lp = ( LPPOINT ) sBuffer;
         strcat( cBuffer, _OOHG_LTOA( lp->x, buffer, 10 ) );
         strcat( cBuffer, "," );
         strcat( cBuffer, _OOHG_LTOA( lp->y, buffer, 10 ) );
         if( i < numpapers - 1 )
         {
            strcat( cBuffer, ",," );
         }
         pBuffer += 64;
         nBuffer += sizeof( WORD );
         sBuffer += sizeof( POINT );
      }

      hb_storc( cBuffer, 1 );

      GlobalFree( cBuf );
      GlobalFree( pBuf );
      GlobalFree( nBuf );
      GlobalFree( sBuf );
   }
   else
   {
      hb_storc( "", 1 );
   }

   if( numbins != ( DWORD ) 0 && numbins != ( DWORD ) ( ~ 0 ) )
   {
      bnBuf = GlobalAlloc( GPTR, numbins * 24 );
      bwBuf = GlobalAlloc( GPTR, numbins * sizeof( WORD ) );
      bcBuf = GlobalAlloc( GPTR, numbins * 64 );
      bnBuffer = ( CHAR * ) bnBuf;
      bwBuffer = ( CHAR * ) bwBuf;
      bcBuffer = ( CHAR * ) bcBuf;
      DeviceCapabilities( lpData->pi2->pPrinterName, lpData->pi2->pPortName, DC_BINNAMES, bnBuffer, lpData->pi2->pDevMode );
      DeviceCapabilities( lpData->pi2->pPrinterName, lpData->pi2->pPortName, DC_BINS, bwBuffer, lpData->pi2->pDevMode );
      bcBuffer[ 0 ] = 0;
      for( i = 0; i < numbins; i++ )
      {
         strcat( bcBuffer, bnBuffer );
         strcat( bcBuffer, "," );
         strcat( bcBuffer, _OOHG_ITOA( * bwBuffer, buffer, 10 ) );

         if( i < numbins - 1 )
         {
            strcat( bcBuffer, ",," );
         }
         bnBuffer += 24;
         bwBuffer += sizeof( WORD );
      }

      hb_storc( bcBuffer, 2 );

      GlobalFree( bnBuf );
      GlobalFree( bwBuf );
      GlobalFree( bcBuf );
   }
   else
   {
      hb_storc( "", 2 );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETPOLYFILLMODE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   if( SetPolyFillMode( lpData->hDC, ( COLORREF ) hb_parnl( 1 ) ) )
   {
      hb_retnl( hb_parnl( 1 ) );
   }
   else
   {
      hb_retnl( ( LONG ) GetPolyFillMode( lpData->hDC ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETTEXTCOLOR )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   if( SetTextColor( lpData->hDC, ( COLORREF ) hb_parnl( 1 ) ) != CLR_INVALID )
   {
      hb_retnl( hb_parnl( 1 ) );
   }
   else
   {
      hb_retnl( ( LONG ) GetTextColor( lpData->hDC ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETBKCOLOR )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   if( SetBkColor( lpData->hDC, ( COLORREF ) hb_parnl( 1 ) ) != CLR_INVALID )
   {
      hb_retnl( hb_parnl( 1) );
   }
   else
   {
      hb_retnl( ( LONG ) GetBkColor( lpData->hDC ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETBKMODE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   if( hb_parni( 1 ) == 1 )
   {
      SetBkMode( lpData->hDC, TRANSPARENT );
   }
   else
   {
      SetBkMode( lpData->hDC, OPAQUE );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DELETEOBJECTS )
{
   UINT i;

   for( i = 2; i <= hb_parinfa( 1, 0 ); i++ )
      DeleteObject( ( HGDIOBJ ) HB_PARNL2( 1, i ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DELETEIMAGELISTS )
{
   UINT i;

   for( i = 1; i <= hb_parinfa( 1, 0 ); i++ )
      ImageList_Destroy( ( HIMAGELIST ) HB_PARNL3( 1, i, 1) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SAVEMETAFILE )
{
   CopyEnhMetaFile( ( HENHMETAFILE ) HB_PARNL( 1 ), hb_parc( 2 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETCURRENTOBJECT )
{
   INT what = hb_parni( 1 );
   HGDIOBJ hand;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   if( what == 1 )
   {
      hand = GetCurrentObject( lpData->hDC, OBJ_FONT );
   }
   else
   {
      if( what == 2 )
      {
         hand = GetCurrentObject( lpData->hDC, OBJ_BRUSH );
      }
      else
      {
         hand = GetCurrentObject( lpData->hDC, OBJ_PEN );
      }
   }
   HB_RETNL( ( LONG_PTR ) hand );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETSTOCKOBJECT )
{
   HB_RETNL( ( LONG_PTR ) GetStockObject( hb_parni( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATEPEN )
{
   HB_RETNL( ( LONG_PTR ) CreatePen( hb_parni( 1 ), hb_parni( 2 ), ( COLORREF ) hb_parnl( 3 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_MODIFYPEN )
{
   LOGPEN ppn;
   INT i;
   HPEN hp;

   memset( &ppn, 0, sizeof( LOGPEN ) );
   i = GetObject( ( HPEN ) HB_PARNL( 1 ), sizeof( LOGPEN ), &ppn );
   if ( i > 0 )
   {
      if( hb_parni( 2 ) >= 0 )
      {
         ppn.lopnStyle = ( UINT ) hb_parni( 2 );
      }
      if( hb_parnl( 3 ) >= 0 )
      {
         ppn.lopnWidth.x = hb_parnl( 3 );
      }
      if( hb_parnl( 4 ) >= 0 )
      {
         ppn.lopnColor = ( COLORREF ) hb_parnl( 4 );
      }

      hp = CreatePenIndirect( &ppn );
      if( hp != NULL )
      {
         DeleteObject( ( HPEN ) HB_PARNL( 1 ) );
         HB_RETNL( ( LONG_PTR ) hp );
      }
      else
      {
         HB_RETNL( ( LONG_PTR ) HB_PARNL( 1 ) );
      }
   }
   else
   {
      HB_RETNL( ( LONG_PTR ) HB_PARNL( 1 ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SELECTPEN )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   SelectObject( lpData->hDC, ( HPEN ) HB_PARNL( 1 ) );
   lpData->hpen = ( HPEN ) HB_PARNL(1);
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATEBRUSH )
{
  LOGBRUSH pbr;

  pbr.lbStyle = hb_parni( 1 );
  pbr.lbColor = ( COLORREF ) hb_parnl( 2 );
  pbr.lbHatch = ( ULONG_PTR ) HB_PARNL( 3 );
  HB_RETNL( ( LONG_PTR ) CreateBrushIndirect( &pbr ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_MODIFYBRUSH )
{
   LOGBRUSH ppn;
   INT i;
   HBRUSH hb;

   memset( &ppn, 0, sizeof( LOGBRUSH ) );
   i = GetObject( ( HBRUSH ) HB_PARNL( 1 ), sizeof( LOGBRUSH ), &ppn );
   if( i > 0 )
   {
      if( hb_parni( 2 ) >= 0 )
      {
         ppn.lbStyle = ( UINT ) hb_parni( 2 );
      }
      if( hb_parnl( 3 ) >= 0 )
      {
         ppn.lbColor = ( COLORREF ) hb_parnl( 3 );
      }
      if( hb_parnl( 4 ) >= 0 )
      {
         ppn.lbHatch = ( ULONG_PTR ) HB_PARNL( 4 );
      }

      hb = CreateBrushIndirect( &ppn );
      if( hb != NULL )
      {
         DeleteObject( ( HBRUSH ) HB_PARNL( 1 ) );
         HB_RETNL( ( LONG_PTR ) hb );
      }
      else
      {
         HB_RETNL( ( LONG_PTR ) HB_PARNL( 1 ) );
      }
   }
   else
   {
      HB_RETNL( ( LONG_PTR ) HB_PARNL( 1 ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SELECTBRUSH )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   SelectObject( lpData->hDC, ( HBRUSH ) HB_PARNL( 1 ) );
   lpData->hbrush = ( HBRUSH ) HB_PARNL( 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATEFONT )
{
   const CHAR * FontName = ( const CHAR * ) hb_parc( 1 );
   INT FontSize = hb_parni( 2 );
   LONG FontWidth = hb_parnl( 3 );
   LONG Orient = hb_parnl( 4 );
   LONG Weight = hb_parnl( 5 );
   INT Italic = hb_parni( 6 );
   INT Underline = hb_parni( 7 );
   INT Strikeout = hb_parni( 8 );
   HFONT oldfont, hxfont;
   LONG newWidth, FontHeight;
   TEXTMETRIC tm;
   BYTE bItalic, bUnderline, bStrikeOut;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 9 );

   newWidth = FontWidth;
   if( FontSize <= 0 )
   {
      FontSize = 10;
   }
   if( FontWidth < 0 )
   {
      newWidth = 0;
   }
   if( Orient <= 0 )
   {
      Orient = 0;
   }
   if( Weight <= 0 )
   {
      Weight = FW_NORMAL;
   }
   else
   {
      Weight = FW_BOLD;
   }
   if( Italic <= 0 )
   {
      bItalic = 0;
   }
   else
   {
      bItalic = 1;
   }
   if( Underline <= 0 )
   {
      bUnderline = 0;
   }
   else
   {
      bUnderline = 1;
   }
   if( Strikeout <= 0 )
   {
      bStrikeOut = 0;
   }
   else
   {
      bStrikeOut = 1;
   }

   FontHeight = - MulDiv( FontSize, GetDeviceCaps( lpData->hDCRef, LOGPIXELSY ), 72 );
   hxfont = CreateFont( FontHeight, newWidth, Orient, Orient, Weight, bItalic, bUnderline, bStrikeOut, lpData->charset,
                        OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FF_DONTCARE, FontName );
   if( FontWidth < 0 )
   {
      oldfont = ( HFONT ) SelectObject( lpData->hDC, hxfont );
      GetTextMetrics( lpData->hDC, &tm );
      SelectObject( lpData->hDC, oldfont );
      DeleteObject( hxfont );
      newWidth = ( INT ) ( ( FLOAT ) - ( tm.tmAveCharWidth + tm.tmOverhang ) * FontWidth / 100 );
      hxfont = CreateFont( FontHeight, newWidth, Orient, Orient, Weight, bItalic, bUnderline, bStrikeOut, lpData->charset,
                           OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FF_DONTCARE, FontName );
   }

   HB_RETNL( ( LONG_PTR ) hxfont );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_MODIFYFONT )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 10 );
   LOGFONT ppn;
   INT i;
   HFONT hf;
   LONG nHeight;

   memset( &ppn, 0, sizeof( LOGFONT ) );
   i = GetObject( ( HFONT ) HB_PARNL( 1 ), sizeof( LOGFONT ), &ppn );
   if( i > 0 )
   {
      if( hb_parni( 3 ) > 0 )
      {
         nHeight = - MulDiv( hb_parni( 3 ), GetDeviceCaps( lpData->hDC, LOGPIXELSY ), 72 );
         ppn.lfHeight = nHeight;
      }
      if( hb_parnl( 4 ) >= 0 )
      {
         ppn.lfWidth = ( LONG ) hb_parnl( 4 ) * ppn.lfWidth / 100;
      }
      if( hb_parnl( 5 ) >= 0 )
      {
         ppn.lfOrientation = hb_parnl( 5 );
         ppn.lfEscapement = hb_parnl( 5 );
      }
      if( hb_parnl( 6 ) == 0 )
      {
         ppn.lfWeight = FW_NORMAL;
      }
      if( hb_parnl( 6 ) > 0 )
      {
         ppn.lfWeight = FW_BOLD;
      }
      if( hb_parni( 7 ) >= 0 )
      {
         ppn.lfItalic = ( BYTE ) hb_parni( 7 );
      }
      if( hb_parni( 8 ) >= 0 )
      {
         ppn.lfUnderline = ( BYTE ) hb_parni( 8 );
      }
      if( hb_parni( 9 ) >= 0 )
      {
         ppn.lfStrikeOut = ( BYTE ) hb_parni( 9 );
      }

      hf = CreateFontIndirect( &ppn );
      if ( hf != NULL )
      {
         DeleteObject( ( HFONT ) HB_PARNL( 1 ) );
         HB_RETNL( ( LONG_PTR ) hf );
      }
      else
      {
         HB_RETNL( ( LONG_PTR ) HB_PARNL( 1 ) );
      }
   }
   else
   {
      HB_RETNL( ( LONG_PTR ) HB_PARNL( 1 ) );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SELECTFONT )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   SelectObject( lpData->hDC, ( HFONT ) HB_PARNL( 1 ) );
   lpData->hfont = ( HFONT ) HB_PARNL( 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETCHARSET )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   lpData->charset = ( DWORD ) hb_parnl( 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_TEXTOUT )
{
   HFONT xfont = ( HFONT ) HB_PARNL( 3 );
   HFONT prevfont = NULL;
   SIZE szMetric;
   INT lspace = hb_parni( 4 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 5 );

   if( xfont )
   {
      prevfont = ( HFONT ) SelectObject( lpData->hDC, xfont);
   }
   if( lpData->textjust > 0 )
   {
      GetTextExtentPoint32( lpData->hDC, hb_parc( 1 ), hb_parclen( 1 ), &szMetric );
      if( szMetric.cx < lpData->textjust )
      {
         if( lspace > 0 )
         {
            SetTextJustification( lpData->hDC, ( INT ) ( lpData->textjust - szMetric.cx ), lspace );
         }
      }
   }

   hb_retl( TextOut( lpData->hDC, HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ) + lpData->devcaps[ 15 ], hb_parc( 1 ), hb_parclen( 1 ) ) );

   if( xfont )
   {
      SelectObject( lpData->hDC, prevfont );
   }
   if( lpData->textjust > 0)
   {
      SetTextJustification( lpData->hDC, 0, 0 );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DRAWTEXT )
{
   HFONT xfont = ( HFONT ) HB_PARNL( 5 );
   HFONT prevfont = NULL;
   RECT rect;
   UINT uFormat;
   SIZE  sSize;
   const CHAR * pszData = hb_parc( 3 );
   INT iLen = strlen( pszData );
   INT iStyle = hb_parni( 4 );
   INT iAlign = 0, iNoWordBreak;
   LONG w, h;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 7 );

   SetRect( &rect, HB_PARNL2( 1, 2 ), HB_PARNL2( 1, 1 ), HB_PARNL2( 2, 2 ), HB_PARNL2( 2, 1 ) );
   iNoWordBreak = hb_parl( 6 );

   if( xfont )
   {
      prevfont = ( HFONT ) SelectObject( lpData->hDC, xfont );
   }

   uFormat = DT_NOPREFIX;

   if( iNoWordBreak )
   {
      iAlign = GetTextAlign( lpData->hDC );
      SetTextAlign( lpData->hDC, TA_TOP );
   }
   else
   {
      uFormat |= DT_NOCLIP | DT_WORDBREAK | DT_END_ELLIPSIS;

      GetTextExtentPoint32( lpData->hDC, pszData, iLen, &sSize );
      w = ( LONG ) sSize.cx; // text width
      h = ( LONG ) sSize.cy; // text height

      // Center text vertically within rectangle
      if( w < rect.right - rect.left )
      {
         rect.top = rect.top + ( rect.bottom - rect.top + h / 2 ) / 2;
      }
      else
      {
         rect.top = rect.top + ( rect.bottom - rect.top - h / 2 ) / 2;
      }
   }

   if( iStyle == 0 )
   {
      uFormat = uFormat | DT_LEFT;
   }
   else if( iStyle == 2 )
   {
      uFormat = uFormat | DT_RIGHT;
   }
   else if( iStyle == 1 )
   {
      uFormat = uFormat | DT_CENTER;
   }

   hb_retni( DrawText( lpData->hDC, pszData, -1, &rect, uFormat ) );

   if( xfont )
   {
      SelectObject( lpData->hDC, prevfont );
   }

   if( iNoWordBreak )
   {
      SetTextAlign( lpData->hDC, iAlign );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_RECTANGLE )
{
   HPEN xpen = ( HPEN ) HB_PARNL( 3 );
   HBRUSH xbrush = ( HBRUSH ) HB_PARNL( 4 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 5 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, xbrush );
   }

   hb_retni( Rectangle( lpData->hDC, HB_PARNL2( 1, 2 ), HB_PARNL2( 1, 1 ), HB_PARNL2( 2, 2 ), HB_PARNL2( 2, 1 ) ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, lpData->hbrush );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CLOSEMFILE )
{
   UINT size;
   HENHMETAFILE hh;
   CHAR * eBuffer;
   LPENHMETAHEADER eHeader;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   hh = CloseEnhMetaFile( lpData->hDC );
   size = GetEnhMetaFileBits( hh, 0, NULL );
   eBuffer = ( CHAR * ) GlobalAlloc( GPTR, ( DWORD ) size );
   GetEnhMetaFileBits( hh, size, ( BYTE * ) eBuffer);
   eHeader = ( LPENHMETAHEADER ) eBuffer;
   eHeader->szlDevice.cx = lpData->devcaps[ 3 ];
   eHeader->szlDevice.cy = lpData->devcaps[ 2 ];
   eHeader->szlMillimeters.cx = lpData->devcaps[ 1 ];
   eHeader->szlMillimeters.cy = lpData->devcaps[ 0 ];
   hb_retclen( eBuffer, ( ULONG ) size );
   DeleteEnhMetaFile( hh );
   GlobalFree( eBuffer );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CLOSEFILE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   DeleteEnhMetaFile( CloseEnhMetaFile( lpData->hDC ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATEMFILE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );
   RECT emfrect;

   SetRect( &emfrect, 0, 0, GetDeviceCaps( lpData->hDCRef, HORZSIZE ) * 100, GetDeviceCaps( lpData->hDCRef, VERTSIZE ) * 100 );
   lpData->hDC = CreateEnhMetaFile( lpData->hDCRef, NULL, &emfrect, "hbprinter\0emf file\0\0" );
   SetTextAlign( lpData->hDC, TA_BASELINE );
   lpData->preview = 1;
   HB_RETNL( ( LONG_PTR ) lpData->hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATEFILE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );
   RECT emfrect;

   SetRect( &emfrect, 0, 0, GetDeviceCaps( lpData->hDCRef, HORZSIZE ) * 100, GetDeviceCaps( lpData->hDCRef, VERTSIZE ) * 100 );
   lpData->hDC = CreateEnhMetaFile( lpData->hDCRef, hb_parc( 1 ), &emfrect, "hbprinter\0emf file\0\0" );
   SetTextAlign( lpData->hDC, TA_BASELINE );
   lpData->preview = 1;
   HB_RETNL( ( LONG_PTR ) lpData->hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DELETECLIPRGN )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   SelectClipRgn( lpData->hDC, NULL );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATERGN )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 5 );
   POINT lpp;
   GetViewportOrgEx( lpData->hDC, &lpp );

   if( hb_parni( 3 ) == 2 )
   {
      HB_RETNL( ( LONG_PTR ) CreateEllipticRgn( HB_PARNI( 1, 2 ) + lpp.x, HB_PARNI( 1, 1 ) + lpp.y,
                                                HB_PARNI( 2, 2 ) + lpp.x, HB_PARNI( 2, 1 ) + lpp.y ) );
   }
   else
   {
      if( hb_parni( 3 ) == 3 )
      {
         HB_RETNL( ( LONG_PTR ) CreateRoundRectRgn( HB_PARNI( 1, 2 ) + lpp.x, HB_PARNI( 1, 1 ) + lpp.y,
                                                    HB_PARNI( 2, 2 ) + lpp.x, HB_PARNI( 2, 1 ) + lpp.y,
                                                    HB_PARNI( 4, 2 ) + lpp.x, HB_PARNI( 4, 1 ) + lpp.y ) );
      }
      else
      {
         HB_RETNL( ( LONG_PTR ) CreateRectRgn( HB_PARNI( 1, 2 ) + lpp.x, HB_PARNI( 1, 1 ) + lpp.y,
                                               HB_PARNI( 2, 2 ) + lpp.x, HB_PARNI( 2, 1 ) + lpp.y ) );
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATEPOLYGONRGN )
{
   INT number = hb_parinfa( 1, 0 );
   INT i;
   POINT apoints[ 1024 ];

   for( i = 0; i <= number - 1; i++ )
   {
      apoints[ i ].x = HB_PARNI( 1, i + 1 );
      apoints[ i ].y = HB_PARNI( 2, i + 1 );
   }
   HB_RETNL( ( LONG_PTR ) CreatePolygonRgn( apoints, number, hb_parni( 3 ) ) );
}


/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_COMBINERGN )
{
   HRGN rgnnew = CreateRectRgn( 0, 0, 1, 1 );

   CombineRgn( rgnnew, ( HRGN ) HB_PARNL( 1 ), ( HRGN ) HB_PARNL( 2 ), hb_parni( 3 ) );
   HB_RETNL( ( LONG_PTR ) rgnnew );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SELECTCLIPRGN )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   SelectClipRgn( lpData->hDC, ( HRGN ) HB_PARNL( 1 ) );
   lpData->hrgn = ( HRGN ) HB_PARNL( 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETVIEWPORTORG )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   hb_retl( SetViewportOrgEx( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ), NULL ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETVIEWPORTORG )
{
   POINT lpp;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   hb_retl( GetViewportOrgEx( lpData->hDC, &lpp ) );
   HB_STORNL3( lpp.x, 1, 2 );
   HB_STORNL3( lpp.y, 1, 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETRGB )
{
   hb_retnl( RGB( hb_parni( 1 ), hb_parni( 2 ), hb_parni( 3 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETTEXTCHAREXTRA )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   hb_retni( SetTextCharacterExtra( lpData->hDC, hb_parni( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETTEXTCHAREXTRA )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   hb_retni( GetTextCharacterExtra( lpData->hDC ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETTEXTJUSTIFICATION )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   lpData->textjust = hb_parni( 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETTEXTJUSTIFICATION )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   hb_retni( lpData->textjust );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETTEXTALIGN )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 1 );

   hb_retni( GetTextAlign( lpData->hDC ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SETTEXTALIGN )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   hb_retni( SetTextAlign( lpData->hDC, TA_BASELINE | hb_parni( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PICTURE )
{
   IStream * iStream;
   IPicture * iPicture;
   IPicture ** iPictureRef = &iPicture;
   HGLOBAL hGlobal;
   VOID * pGlobal;
   HANDLE hFile;
   DWORD nFileSize;
   DWORD nReadByte;
   LONG lWidth, lHeight;
   INT x, y, xe, ye;
   INT r = HB_PARNI( 2, 1 );
   INT c = HB_PARNI( 2, 2 );
   INT dr = HB_PARNI( 3, 1 );
   INT dc = HB_PARNI( 3, 2 );
   INT tor = HB_PARNI( 4, 1 );
   INT toc = HB_PARNI( 4, 2 );
   HRGN hrgn1;
   POINT lpp;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 5 );

   hFile = CreateFile( hb_parc( 1 ), GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );
   if( hFile == INVALID_HANDLE_VALUE )
   {
      return;
   }
   nFileSize = GetFileSize( hFile, NULL );
   hGlobal = GlobalAlloc( GMEM_MOVEABLE, nFileSize );
   pGlobal = GlobalLock( hGlobal );
   ReadFile( hFile, pGlobal, nFileSize, &nReadByte, NULL );
   CloseHandle( hFile );
   GlobalUnlock( hGlobal );
   CreateStreamOnHGlobal( hGlobal, TRUE, &iStream );
   OleLoadPicture( iStream, nFileSize, TRUE, &IID_IPicture, ( LPVOID * ) iPictureRef );
   GlobalFree( hGlobal );
   iStream->lpVtbl->Release( iStream );
   if( iPicture == NULL )
   {
      return;
   }
   iPicture->lpVtbl->get_Width( iPicture, &lWidth );
   iPicture->lpVtbl->get_Height( iPicture, &lHeight );
   if( dc == 0 )
   {
      dc = ( INT ) ( ( FLOAT ) dr * lWidth / lHeight );
   }
   if( dr == 0 )
   {
      dr = ( INT ) ( ( FLOAT ) dc * lHeight / lWidth );
   }
   if( tor <= 0 )
   {
      tor = dr;
   }
   if( toc <= 0 )
   {
      toc = dc;
   }
   x = c;
   y = r;
   xe = c + toc - 1;
   ye = r + tor - 1;
   GetViewportOrgEx( lpData->hDC, &lpp );
   hrgn1 = CreateRectRgn( c + lpp.x, r + lpp.y, xe + lpp.x, ye + lpp.y );
   if( lpData->hrgn == NULL )
   {
      SelectClipRgn( lpData->hDC, hrgn1 );
   }
   else
   {
      ExtSelectClipRgn( lpData->hDC, hrgn1, RGN_AND );
   }
   while( x < xe )
   {
      while( y < ye )
      {
         iPicture->lpVtbl->Render( iPicture, lpData->hDC, x, y, dc, dr, 0, lHeight, lWidth, - lHeight, NULL );
         y += dr;
      }
      y = r;
      x += dc;
   }
   iPicture->lpVtbl->Release( iPicture );
   SelectClipRgn( lpData->hDC, lpData->hrgn );
   DeleteObject( hrgn1 );
   hb_retni( 0 );
}

static LPVOID RR_LoadPictureFromResource( const CHAR * resname, LONG * lwidth, LONG * lheight )
{
   HBITMAP hbmpx;
   IPicture * iPicture = NULL;
   IPicture ** iPictureRef = &iPicture;
   IStream * iStream = NULL;
   PICTDESC picd;
   HGLOBAL hGlobalres;
   HGLOBAL hGlobal;
   HRSRC hSource;
   LPVOID lpVoid;
   HINSTANCE hinstance = GetModuleHandle( NULL );
   INT nSize;

   hbmpx = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), resname, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION );
   // TODO: Use _OOHG_LoadImage
   if( hbmpx != NULL )
   {
      picd.cbSizeofstruct = sizeof( PICTDESC );
      picd.picType = PICTYPE_BITMAP;
      picd.bmp.hbitmap = hbmpx;
      OleCreatePictureIndirect( &picd, &IID_IPicture, TRUE, ( LPVOID * ) iPictureRef );
   }
   else
   {
      hSource = FindResource( hinstance, resname, "HMGPICTURE" );
      if( ! hSource )
      {
         hSource = FindResource( hinstance, resname, "JPG" );
         if( ! hSource )
         {
            hSource = FindResource( hinstance, resname, "JPEG" );
            if( ! hSource )
            {
               hSource = FindResource( hinstance, resname, "GIF" );
               if( ! hSource )
               {
                  hSource = FindResource( hinstance, resname, "BMP" );
                  if( ! hSource )
                  {
                     hSource = FindResource( hinstance, resname, "BITMAP" );
                     if( ! hSource )
                     {
                        hSource = FindResource( hinstance, resname, "PNG" );
                        if( ! hSource )
                        {
                           hSource = FindResource( hinstance, resname, "TIFF" );
                           if( ! hSource )
                           {
                              return NULL;
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      hGlobalres = LoadResource( hinstance, hSource );
      if( hGlobalres == NULL )
      {
         return NULL;
      }
      lpVoid = LockResource( hGlobalres );
      if( lpVoid == NULL )
      {
         return NULL;
      }
      nSize = SizeofResource( hinstance, hSource );
      hGlobal = GlobalAlloc( GPTR, nSize );
      if( hGlobal == NULL )
      {
         return NULL;
      }
      memcpy( hGlobal, lpVoid, nSize );
      FreeResource( hGlobalres );
      CreateStreamOnHGlobal( hGlobal, TRUE, &iStream );
      if( iStream == NULL )
      {
         GlobalFree( hGlobal );
         return NULL;
      }
      OleLoadPicture( iStream, nSize, TRUE, &IID_IPicture, ( LPVOID * ) iPictureRef );
      iStream->lpVtbl->Release( iStream );
      GlobalFree( hGlobal );
   }
   if( iPicture != NULL )
   {
      iPicture->lpVtbl->get_Width( iPicture, lwidth );
      iPicture->lpVtbl->get_Height( iPicture, lheight );
   }
   return iPicture;
}

static LPVOID RR_LoadPicture( const CHAR * filename, LONG * lwidth, LONG * lheight )
{
   IStream * iStream = NULL;
   IPicture * iPicture = NULL;
   IPicture ** iPictureRef = &iPicture;
   HGLOBAL hGlobal;
   VOID * pGlobal;
   HANDLE hFile;
   DWORD nFileSize, nReadByte;

   hFile = CreateFile( filename, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );
   if( hFile == INVALID_HANDLE_VALUE )
   {
      return NULL;
   }
   nFileSize = GetFileSize( hFile, NULL );
   hGlobal = GlobalAlloc( GMEM_MOVEABLE, nFileSize + 4096 );
   pGlobal = GlobalLock( hGlobal );
   ReadFile( hFile, pGlobal, nFileSize, &nReadByte, NULL );
   CloseHandle( hFile );
   CreateStreamOnHGlobal( hGlobal, TRUE, &iStream );
   if( iStream == NULL )
   {
      GlobalUnlock( hGlobal );
      GlobalFree( hGlobal );
      return NULL;
   }
   OleLoadPicture( iStream, nFileSize, TRUE, &IID_IPicture, ( LPVOID * ) iPictureRef );
   GlobalUnlock( hGlobal );
   GlobalFree( hGlobal );
   iStream->lpVtbl->Release( iStream );
   iStream = NULL;
   if( iPicture != NULL )
   {
      iPicture->lpVtbl->get_Width( iPicture, lwidth );
      iPicture->lpVtbl->get_Height( iPicture, lheight );
   }
   return iPicture;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DRAWPICTURE )
{
   IPicture * ipic;
   INT x, y, xe, ye;
   INT r = HB_PARNI( 2, 1 );
   INT c = HB_PARNI( 2, 2 );
   INT dr = HB_PARNI( 3, 1 );
   INT dc = HB_PARNI( 3, 2 );
   INT tor = HB_PARNI( 4, 1 );
   INT toc = HB_PARNI( 4, 2 );
   LONG lwidth = 0;
   LONG lheight = 0;
   RECT lrect;
   HRGN hrgn1;
   POINT lpp;
   INT lw, lh;
   BOOL bImageSize = hb_parl( 5 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 6 );

   if( ! hb_parclen( 1 ) )
   {
      return;
   }
   ipic = ( IPicture * ) RR_LoadPicture( ( const CHAR * ) hb_parc( 1 ), &lwidth, &lheight );
   if( ! ipic )
   {
      ipic = ( IPicture * ) RR_LoadPictureFromResource( ( const CHAR * ) hb_parc( 1 ), &lwidth, &lheight );
   }
   if( ! ipic )
   {
      return;
   }
   lw = MulDiv( lwidth, lpData->devcaps[ 5 ], 2540 );
   lh = MulDiv( lheight, lpData->devcaps[ 4 ], 2540 );
   if( dc == 0 )
   {
      dc = ( INT ) ( ( FLOAT ) dr * lw / lh );
   }
   if( dr == 0 )
   {
      dr = ( INT ) ( ( FLOAT ) dc * lh / lw );
   }
   if( bImageSize )
   {
      dr = lh;
      dc = lw;
   }
   if( tor <= 0 )
   {
      tor = dr;
   }
   if( toc <= 0 )
   {
      toc = dc;
   }
   if( bImageSize )
   {
      tor = lh;
      toc = lw;
   }
   x = c;
   y = r;
   xe = c + toc - 1;
   ye = r + tor - 1;
   GetViewportOrgEx( lpData->hDC, &lpp );
   hrgn1 = CreateRectRgn( c + lpp.x, r + lpp.y, xe + lpp.x, ye + lpp.y );
   if( lpData->hrgn == NULL )
   {
      SelectClipRgn( lpData->hDC, hrgn1 );
   }
   else
   {
      ExtSelectClipRgn( lpData->hDC, hrgn1, RGN_AND );
   }
   while( x < xe )
   {
      while( y < ye )
      {
         SetRect( &lrect, x, y, dc + x, dr +y );
         ipic->lpVtbl->Render( ipic, lpData->hDC, x, y, dc, dr, 0, lheight, lwidth, - lheight, &lrect );
         y += dr;
      }
      y = r;
      x += dc;
   }
   ipic->lpVtbl->Release( ipic );
   SelectClipRgn( lpData->hDC, lpData->hrgn );
   DeleteObject( hrgn1 );
   hb_retni( 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CREATEIMAGELIST )
{
   HBITMAP hbmpx;
   BITMAP bm;
   HIMAGELIST himl;
   INT dx, number;

   hbmpx = ( HBITMAP ) LoadImage( 0, hb_parc( 1 ), IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE | LR_CREATEDIBSECTION );
   if( hbmpx == NULL )
   {
      hbmpx = ( HBITMAP ) LoadImage( GetModuleHandle( NULL ), hb_parc( 1 ), IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION );
   }
   if( hbmpx == NULL )
   {
      return;
   }
   GetObject( hbmpx, sizeof( BITMAP ), &bm );
   number = hb_parni( 2 );
   if( number == 0 )
   {
      number = ( INT ) bm.bmWidth / bm.bmHeight;
      dx = bm.bmHeight;
   }
   else
   {
      dx = ( INT ) bm.bmWidth / number;
   }
   himl = ImageList_Create( dx, bm.bmHeight, ILC_COLOR24 | ILC_MASK, number, 0 );
   ImageList_AddMasked( himl, hbmpx, CLR_DEFAULT );
   hb_storni( dx, 3 );
   hb_storni( bm.bmHeight, 4 );
   DeleteObject( hbmpx );
   HB_RETNL( ( LONG_PTR ) himl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DRAWIMAGELIST )
{
   HIMAGELIST himl = ( HIMAGELIST ) HB_PARNL( 1 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 8 );
   HDC tempdc, temp2dc;
   HBITMAP hbmpx;
   RECT rect;
   HWND hwnd = GetActiveWindow();

   rect.left = HB_PARNI( 3, 2 );
   rect.top = HB_PARNI( 3, 1 );
   rect.right = HB_PARNI( 4, 2 );
   rect.bottom = HB_PARNI( 4, 1 );
   temp2dc = GetWindowDC( hwnd );
   tempdc = CreateCompatibleDC( temp2dc );
   hbmpx = CreateCompatibleBitmap( temp2dc, hb_parni( 5 ), hb_parni( 6 ) );
   ReleaseDC( hwnd, temp2dc );
   SelectObject( tempdc, hbmpx );
   BitBlt( tempdc, 0, 0, hb_parni( 5 ), hb_parni( 6 ), tempdc, 0, 0, WHITENESS );
   if( hb_parnl( 8 ) >= 0 )
   {
      ImageList_SetBkColor( himl, ( COLORREF ) hb_parnl( 8 ) );
   }
   ImageList_Draw( himl, hb_parni( 2 ) - 1, tempdc, 0, 0, ( UINT ) hb_parni( 7 ) );
   if( hb_parnl( 8 ) >= 0 )
   {
      ImageList_SetBkColor( himl, CLR_NONE );
   }
   hb_retl( StretchBlt( lpData->hDC, rect.left, rect.top, rect.right, rect.bottom, tempdc, 0, 0, hb_parni( 5 ), hb_parni( 6 ), SRCCOPY ) );
   DeleteDC( tempdc );
   DeleteObject( hbmpx );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_POLYGON )
{
   INT number = ( INT ) hb_parinfa( 1, 0 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 6 );
   INT i;
   INT styl = GetPolyFillMode( lpData->hDC );
   POINT apoints[ 1024 ];
   HPEN xpen = ( HPEN ) HB_PARNL( 3 );
   HBRUSH xbrush = ( HBRUSH ) HB_PARNL( 4 );

   for( i = 0; i <= number-1; i++ )
   {
      apoints[ i ].x = HB_PARNI( 1, i + 1 );
      apoints[ i ].y = HB_PARNI( 2, i + 1 );
   }

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, xbrush );
   }
   SetPolyFillMode( lpData->hDC, hb_parni( 5 ) );

   hb_retnl( ( LONG ) Polygon( lpData->hDC, apoints, number ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, lpData->hbrush );
   }
   SetPolyFillMode( lpData->hDC, styl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_POLYBEZIER )
{
   DWORD number = ( DWORD ) hb_parinfa( 1, 0 );
   DWORD i;
   POINT apoints[ 1024 ];
   HPEN xpen = ( HPEN )HB_PARNL( 3 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 4 );

   for( i = 0; i <= number - 1; i++ )
   {
      apoints[ i ].x = HB_PARNI( 1, i + 1 );
      apoints[ i ].y = HB_PARNI( 2, i + 1 );
   }

   if( xpen )
   {
     SelectObject( lpData->hDC, xpen );
   }

   hb_retnl( ( LONG ) PolyBezier( lpData->hDC, apoints, number ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_POLYBEZIERTO )
{
   DWORD number = ( DWORD ) hb_parinfa( 1, 0 );
   DWORD i;
   POINT apoints[ 1024 ];
   HPEN xpen = ( HPEN ) HB_PARNL( 3 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 4 );

   for( i = 0; i <= number-1; i++ )
   {
      apoints[ i ].x = HB_PARNI( 1, i + 1 );
      apoints[ i ].y = HB_PARNI( 2, i + 1 );
   }

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }

   hb_retnl( ( LONG ) PolyBezierTo( lpData->hDC, apoints, number ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETTEXTEXTENT )
{
   HFONT xfont = ( HFONT ) HB_PARNL( 3 );
   SIZE szMetric;
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 4 );

   if( xfont )
   {
      SelectObject( lpData->hDC, xfont );
   }
   hb_retni( GetTextExtentPoint32( lpData->hDC, hb_parc( 1 ), ( INT ) hb_parclen( 1 ), &szMetric ) );
   HB_STORNI( szMetric.cy, 2, 1 );
   HB_STORNI( szMetric.cx, 2, 2 );
   if( xfont )
   {
      SelectObject( lpData->hDC, lpData->hfont );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_ROUNDRECT )
{
   HPEN xpen = ( HPEN ) HB_PARNL( 4 );
   HBRUSH xbrush = ( HBRUSH ) HB_PARNL( 5 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 6 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, xbrush );
   }

   hb_retni( RoundRect( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ), HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ), HB_PARNI( 3, 2 ), HB_PARNI( 3, 1 ) ) );

   if( xbrush )
   {
      SelectObject( lpData->hDC, lpData->hbrush );
   }
   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_ELLIPSE )
{
   HPEN xpen = ( HPEN ) HB_PARNL( 3 );
   HBRUSH xbrush = ( HBRUSH ) HB_PARNL( 4 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 5 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, xbrush );
   }

   hb_retni( Ellipse( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ), HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ) ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, lpData->hbrush );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_CHORD )
{
   HPEN xpen = ( HPEN ) HB_PARNL( 5 );
   HBRUSH xbrush = ( HBRUSH ) HB_PARNL( 6 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 7 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, xbrush );
   }

   hb_retni( Chord( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ), HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ),
                    HB_PARNI( 3, 2 ), HB_PARNI( 3, 1 ), HB_PARNI( 4, 2 ), HB_PARNI( 4, 1 ) ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, lpData->hbrush );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_ARCTO )
{
   HPEN xpen = ( HPEN ) HB_PARNL( 5 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 6 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }

    hb_retni( ArcTo( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ), HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ),
                     HB_PARNI( 3, 2 ), HB_PARNI( 3, 1 ), HB_PARNI( 4, 2 ), HB_PARNI( 4, 1 ) ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_ARC )
{
   HPEN xpen = ( HPEN ) HB_PARNL( 5 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 6 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }

   hb_retni( Arc( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ), HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ),
                  HB_PARNI( 3, 2 ), HB_PARNI( 3, 1 ), HB_PARNI( 4, 2 ), HB_PARNI( 4, 1 ) ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PIE )
{
   HPEN xpen = ( HPEN ) HB_PARNL( 5 );
   HBRUSH xbrush = ( HBRUSH ) HB_PARNL( 6 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 7 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, xbrush );
   }

   hb_retni( Pie( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ), HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ),
                  HB_PARNI( 3, 2 ), HB_PARNI( 3, 1 ), HB_PARNI( 4, 2 ), HB_PARNI( 4, 1 ) ) );

   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
   if( xbrush )
   {
      SelectObject( lpData->hDC, lpData->hbrush );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_FILLRECT )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 4 );
   RECT rect;

   rect.left = HB_PARNI( 1, 2 );
   rect.top = HB_PARNI( 1, 1 );
   rect.right = HB_PARNI( 2, 2 );
   rect.bottom = HB_PARNI( 2, 1 );
   hb_retni( FillRect( lpData->hDC, &rect, ( HBRUSH ) HB_PARNL( 3 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_FRAMERECT )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 4 );
   RECT rect;

   rect.left = HB_PARNI( 1, 2 );
   rect.top = HB_PARNI( 1, 1 );
   rect.right = HB_PARNI( 2, 2 );
   rect.bottom = HB_PARNI( 2, 1 );
   hb_retni( FrameRect( lpData->hDC, &rect, ( HBRUSH ) HB_PARNL( 3 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_LINE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 4 );
   HPEN xpen = ( HPEN ) HB_PARNL( 3 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }
   MoveToEx( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ), NULL );
   hb_retni( LineTo( lpData->hDC, HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ) ) );
   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_LINETO )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 3 );
   HPEN xpen = ( HPEN ) HB_PARNL( 2 );

   if( xpen )
   {
      SelectObject( lpData->hDC, xpen );
   }
   hb_retni( LineTo( lpData->hDC, HB_PARNI( 1, 2 ), HB_PARNI( 1, 1 ) ) );
   if( xpen )
   {
      SelectObject( lpData->hDC, lpData->hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_INVERTRECT )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 3 );
   RECT rect;

   rect.left = HB_PARNI( 1, 2 );
   rect.top = HB_PARNI( 1, 1 );
   rect.right = HB_PARNI( 2, 2 );
   rect.bottom = HB_PARNI( 2, 1 );
   hb_retni( InvertRect( lpData->hDC, &rect ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETWINDOWRECT )
{
   RECT rect;
   HWND hwnd = HWNDparam2( 1, 7 );

   if( hwnd == 0 )
   {
      hwnd = GetDesktopWindow();
   }
   GetWindowRect( hwnd, &rect );
   HB_STORNI( rect.top, 1, 1 );
   HB_STORNI( rect.left, 1, 2 );
   HB_STORNI( rect.bottom, 1, 3 );
   HB_STORNI( rect.right, 1, 4 );
   HB_STORNI( rect.bottom - rect.top + 1, 1, 5 );
   HB_STORNI( rect.right - rect.left + 1, 1, 6 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETCLIENTRECT )
{
   RECT rect;

   GetClientRect( HWNDparam2( 1, 7 ), &rect );
   HB_STORNI( rect.top, 1, 1 );
   HB_STORNI( rect.left, 1, 2 );
   HB_STORNI( rect.bottom, 1, 3 );
   HB_STORNI( rect.right, 1, 4 );
   HB_STORNI( rect.bottom - rect.top + 1, 1, 5 );
   HB_STORNI( rect.right - rect.left + 1, 1, 6 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_SCROLLWINDOW )
{
   ScrollWindow( HWNDparam( 1 ), hb_parni( 2 ), hb_parni( 3 ), NULL, NULL );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PREVIEWPLAY )
{
   RECT rect;
   HBITMAP himgbmp = 0;
   HDC imgDC = GetWindowDC( HWNDparam( 1 ) );
   HENHMETAFILE hh = SetEnhMetaFileBits( ( UINT ) HB_PARCLEN( 2, 1 ), ( const BYTE * ) HB_PARC( 2, 1 ) );
   HDC tmpDC = CreateCompatibleDC( imgDC );

   if( tmpDC == NULL )
   {
      ReleaseDC( HWNDparam( 1 ), imgDC );
   }
   else
   {
      SetRect( &rect, 0, 0, HB_PARNL2( 3, 4 ), HB_PARNL2( 3, 3 ) );
      himgbmp = CreateCompatibleBitmap( imgDC, rect.right, rect.bottom );
      SelectObject( tmpDC, ( HBITMAP ) himgbmp );
      FillRect( tmpDC, &rect, ( HBRUSH ) GetStockObject( WHITE_BRUSH ) );
      PlayEnhMetaFile( tmpDC, hh, &rect );
      DeleteEnhMetaFile( hh );
      ReleaseDC( HWNDparam( 1 ), imgDC );
      DeleteDC( tmpDC );
   }
   HB_RETNL( ( LONG_PTR ) himgbmp );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PREVIEWFPLAY )
{
   RECT rect;
   HBITMAP himgbmp = 0;
   HDC imgDC = GetWindowDC( HWNDparam( 1 ) );
   HENHMETAFILE hh = GetEnhMetaFile( hb_parc( 2 ) );
   HDC tmpDC = CreateCompatibleDC( imgDC );

   if( tmpDC == NULL )
   {
      ReleaseDC( HWNDparam( 1 ), imgDC );
   }
   else
   {
      SetRect( &rect, 0, 0, HB_PARNL2( 3, 4 ), HB_PARNL2( 3, 3 ) );
      himgbmp = CreateCompatibleBitmap( imgDC, rect.right, rect.bottom );
      SelectObject( tmpDC, ( HBITMAP ) himgbmp );
      FillRect( tmpDC, &rect, ( HBRUSH ) GetStockObject( WHITE_BRUSH ) );
      PlayEnhMetaFile( tmpDC, hh, &rect );
      DeleteEnhMetaFile( hh );
      ReleaseDC( HWNDparam( 1 ), imgDC );
      DeleteDC( tmpDC );
   }
   HB_RETNL( ( LONG_PTR ) himgbmp );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PLAYTHUMB )
{
   RECT rect;
   INT i = hb_parni( 4 ) - 1;
   HWND hwnd = HWNDparam2( 1, 5 );
   HDC imgDC = GetWindowDC( hwnd );
   HDC tmpDC = CreateCompatibleDC( imgDC );
   HENHMETAFILE hh = SetEnhMetaFileBits( ( UINT ) HB_PARCLEN( 2, 1 ), ( const BYTE * ) HB_PARC( 2, 1 ) );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 5 );

   SetRect( &rect, 0, 0, HB_PARNI( 1, 4 ), HB_PARNI( 1, 3 ) );
   lpData->hbmp[ i ] = CreateCompatibleBitmap( imgDC, rect.right, rect.bottom );
   DeleteObject( SelectObject( tmpDC, lpData->hbmp[ i ] ) );
   FillRect( tmpDC, &rect, ( HBRUSH ) GetStockObject( WHITE_BRUSH ) );
   PlayEnhMetaFile( tmpDC, hh, &rect );
   DeleteEnhMetaFile( hh );
   TextOut( tmpDC, ( INT )( rect.right / 2 - 5 ), ( INT )( rect.bottom / 2 - 5 ), hb_parc( 3 ), ( INT ) hb_parclen( 3 ) );
   SendMessage( hwnd, ( UINT ) STM_SETIMAGE, ( WPARAM ) IMAGE_BITMAP, ( LPARAM ) lpData->hbmp[ i ] );
   ReleaseDC( hwnd, imgDC );
   DeleteDC( tmpDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PLAYFTHUMB )
{
   RECT rect;
   INT i = hb_parni( 4 ) - 1;
   HWND hwnd = HWNDparam2( 1, 5 );
   HDC imgDC = GetWindowDC( hwnd );
   HDC tmpDC = CreateCompatibleDC( imgDC );
   HENHMETAFILE hh = GetEnhMetaFile( HB_PARC( 2, 1 ) );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 5 );

   SetRect( &rect, 0, 0, HB_PARNI( 1, 4 ), HB_PARNI( 1, 3 ) );
   lpData->hbmp[ i ] = CreateCompatibleBitmap( imgDC, rect.right, rect.bottom );
   DeleteObject( SelectObject( tmpDC, lpData->hbmp[ i ] ) );
   FillRect( tmpDC, &rect, ( HBRUSH ) GetStockObject( WHITE_BRUSH ) );
   PlayEnhMetaFile( tmpDC, hh, &rect );
   DeleteEnhMetaFile( hh );
   TextOut( tmpDC, ( INT )( rect.right / 2 - 5 ), ( INT )( rect.bottom / 2 - 5 ), hb_parc( 3 ), ( INT ) hb_parclen( 3 ) );
   SendMessage( hwnd, ( UINT ) STM_SETIMAGE, ( WPARAM ) IMAGE_BITMAP, ( LPARAM ) lpData->hbmp[ i ] );
   ReleaseDC( hwnd, imgDC );
   DeleteDC( tmpDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PLAYENHMETAFILE )
{
   RECT rect;
   HENHMETAFILE hh = SetEnhMetaFileBits( ( UINT ) HB_PARCLEN( 1, 1 ), ( const BYTE * ) HB_PARC( 1, 1 ) );

   SetRect( &rect, 0, 0, HB_PARNL2( 1, 5 ), HB_PARNL2( 1, 4 ) );
   PlayEnhMetaFile( ( HDC ) HB_PARNL( 2 ), hh, &rect );
   DeleteEnhMetaFile( hh );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_PLAYFENHMETAFILE )
{
   RECT rect;
   HENHMETAFILE hh = GetEnhMetaFile( HB_PARC( 1, 1 ) );

   SetRect( &rect, 0, 0, HB_PARNL2( 1, 5 ), HB_PARNL2( 1, 4 ) );
   PlayEnhMetaFile( ( HDC ) HB_PARNL( 2 ), hh, &rect );
   DeleteEnhMetaFile( hh );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_LALABYE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 2 );

   if( hb_parni( 1 ) == 1 )
   {
      lpData->hDCtemp = lpData->hDC;
      lpData->hDC = lpData->hDCRef;
   }
   else
   {
      lpData->hDC = lpData->hDCtemp;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_LOADSTRING )
{
   CHAR * cBuffer;

   cBuffer = ( CHAR * ) GlobalAlloc( GPTR, 255 );
   LoadString( GetModuleHandle( NULL ), ( UINT ) hb_parni( 1 ), ( LPSTR ) cBuffer, 254 );
   hb_retc( cBuffer );
   GlobalFree( cBuffer );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETTEMPFOLDER )
{
   CHAR szBuffer[ MAX_PATH + 1 ] = { 0 };

   GetTempPath( MAX_PATH, szBuffer );
   hb_retc( szBuffer );
}

#pragma ENDDUMP
