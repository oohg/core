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

#ifndef __OOHG__
#define ArrayRGB_TO_COLORREF(aRGB) RGB( aRGB[1], aRGB[2], aRGB[3] )
#endif

#define NO_HBPRN_DECLARATION
#include "winprint.ch"

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS HBPrinter

   DATA AfterPrint                INIT {|| NIL }
   DATA aHS                       INIT {}
   DATA aOpisy                    INIT {}
   DATA AtH                       INIT {}
   DATA aZoom                     INIT { 0, 0, 0, 0 }
   DATA BaseDoc                   INIT ""
   DATA BeforePrint               INIT {|| .T. }
   DATA BeforePrintCopy           INIT {|| .T. }
   DATA BinNames                  INIT {}
   DATA BkColor                   INIT 0xFFFFFF
   DATA BkMode                    INIT BKMODE_TRANSPARENT
   DATA Brushes                   INIT { {}, {} }
   DATA Cargo                     INIT { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
   DATA ClsPreview                INIT .T.
   DATA CurPage                   INIT 1 PROTECTED
   DATA DevCaps                   INIT { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 }
   DATA DocName                   INIT "HBPRINTER"
   DATA dx                        INIT 0
   DATA dy                        INIT 0
   DATA Error                     INIT 0 READONLY
   DATA Fonts                     INIT { {}, {}, 0, {} }
   DATA hData                     INIT 0
   DATA hDC                       INIT 0
   DATA hDCRef                    INIT 0 PROTECTED
   DATA IloscStron                INIT 0              // 'Ilosc Stron' means 'Number of Pages' in polish
   DATA ImageLists                INIT { {}, {} }
   DATA InMemory                  INIT .F.
   DATA lAbsoluteCoords           INIT .F.
   DATA lEscaped                  INIT .F.
   DATA lGlobalChanges            INIT .T.
   DATA lReportError              INIT .F.
   DATA MaxCol                    INIT 0
   DATA MaxRow                    INIT 0
   DATA MetaFiles                 INIT {} PROTECTED
   DATA nCopies                   INIT 1
   DATA nFromPage                 INIT 1
   DATA nGroup                    INIT -1
   DATA NoButtonOptions           INIT .F.
   DATA NoButtonSave              INIT .F.
   DATA NotifyOnSave              INIT .F.
   DATA nPages                    INIT {}
   DATA nToPage                   INIT 0
   DATA nWhatToPrint              INIT 0
   DATA oWinPagePreview           INIT NIL
   DATA oWinPreview               INIT NIL
   DATA oWinThumbs                INIT NIL
   DATA Page                      INIT 1
   DATA PaperNames                INIT {}
   DATA Pens                      INIT { {}, {} }
   DATA PolyFillMode              INIT POLYFILL_ALTERNATE
   DATA Ports                     INIT {}
   DATA PreviewMode               INIT .F.
   DATA PreviewRect               INIT { 0, 0, 0, 0 }
   DATA PreviewScale              INIT 1
   DATA PrinterDefault            INIT ""
   DATA PrinterName               INIT ""
   DATA Printers                  INIT {}
   DATA Printing                  INIT .F.
   DATA PrintingEMF               INIT .F. PROTECTED
   DATA PrintOpt                  INIT 1 PROTECTED
   DATA Regions                   INIT { {}, {} }
   DATA Scale                     INIT 1
   DATA TextColor                 INIT 0
   DATA Thumbnails                INIT .F.
   DATA TimeStamp                 INIT ""
   DATA Units                     INIT 0
   DATA Version                   INIT 2.45 READONLY
   DATA ViewportOrg               INIT { 0, 0 }

   METHOD New
   METHOD SelectPrinter
   METHOD SetDevMode
   METHOD SetUserMode
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
   METHOD SetCharset( charset ) INLINE RR_SetCharset( charset, ::hData, Self )
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
   METHOD BitMap
   METHOD Line
   METHOD LineTo
   METHOD End
   METHOD GetTextExtent
   METHOD GetTextExtent_MM
   METHOD ReportData
   METHOD InitMessages
   METHOD BasePageName            INLINE ::BaseDoc
   METHOD GetVersion              INLINE ::Version
#ifndef NO_GUI
   METHOD Preview
   METHOD PrevAdjust
   METHOD PrevClose
   METHOD PrevPrint
   METHOD PrevShow
   METHOD PrevThumb
   METHOD PrintOption
   METHOD SaveMetaFiles
   METHOD CleanOnPrevClose
#endif

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD New( cLang ) CLASS HBPrinter

   LOCAL aPrnPort

   ::hData := RR_CreateHBPrinterData()

   aPrnPort := RR_GetPrinters( ::hData )
   IF ! aPrnPort == ",,"
      aPrnPort := RR_Str2Arr( aPrnPort, ",," )
      AEval( aPrnPort, {| x, xi | aPrnPort[ xi ] := RR_Str2Arr( x, ',' ) } )
      AEval( aPrnPort, {| x | AAdd( ::Printers, x[ 1 ] ), AAdd( ::Ports, x[ 2 ] ) } )
      ::PrinterDefault := GetDefaultPrinter()
   ELSE
      ::Error := 1
   ENDIF
   ::TimeStamp := TToS( DateTime() )
   ::BaseDoc := RR_GetTempFolder() + ::TimeStamp + "_HBPrinter_preview_"
   ::InitMessages( cLang )

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelectPrinter( cPrinter, lPrev ) CLASS HBPrinter

   LOCAL txtp := "", txtb := "", t := { 0, 0, 1, 0 }

   IF cPrinter == NIL
      ::hDCRef := RR_GetDC( ::PrinterDefault, ::hData )
      ::hDC := ::hDCRef
      ::PrinterName := ::PrinterDefault
   ELSEIF Empty( cPrinter )
      ::hDCRef := RR_PrintDialog( t, ::hData )
      ::nFromPage := t[ 1 ]
      ::nToPage := t[ 2 ]
      ::nCopies := t[ 3 ]
      ::nWhatToPrint := t[ 4 ]
      ::hDC := ::hDCRef
      ::PrinterName := RR_PrinterName( ::hData )
   ELSE
      ::hDCRef := RR_GetDC( cPrinter, ::hData )
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
      ::Error := 1
      ::PrinterName := ""
   ELSE
      RR_DeviceCapabilities( @txtp, @txtb, ::hData )
      ::PaperNames := RR_Str2Arr( txtp, ",," )
      ::BinNames := RR_Str2Arr( txtb, ",," )
      AEval( ::BinNames, {| x, xi | ::BinNames[ xi ] := RR_Str2Arr( x, ',' ) } )
      AEval( ::PaperNames, {| x, xi | ::PaperNames[ xi ] := RR_Str2Arr( x, ',' ) } )
      AAdd( ::Fonts[ 1 ], RR_GetCurrentObject( 1, ::hData ) ) ; AAdd( ::Fonts[ 2 ], "*" ) ;       AAdd( ::Fonts[ 4 ], {} )
      AAdd( ::Fonts[ 1 ], RR_GetCurrentObject( 1, ::hData ) ) ; AAdd( ::Fonts[ 2 ], "DEFAULT" ) ; AAdd( ::Fonts[ 4 ], {} )
      AAdd( ::Brushes[ 1 ], RR_GetCurrentObject( 2, ::hData ) ) ; AAdd( ::Brushes[ 2 ], "*" )
      AAdd( ::Brushes[ 1 ], RR_GetCurrentObject( 2, ::hData ) ) ; AAdd( ::Brushes[ 2 ], "DEFAULT" )
      AAdd( ::Pens[ 1 ], RR_GetCurrentObject( 3, ::hData ) ) ; AAdd( ::Pens[ 2 ], "*" )
      AAdd( ::Pens[ 1 ], RR_GetCurrentObject( 3, ::hData ) ) ; AAdd( ::Pens[ 2 ], "DEFAULT" )
      AAdd( ::Regions[ 1 ], 0 ) ; AAdd( ::Regions[ 2 ], "*" )
      AAdd( ::Regions[ 1 ], 0 ) ; AAdd( ::Regions[ 2 ], "DEFAULT" )
      ::Fonts[ 3 ] := ::Fonts[ 1, 1 ]
      RR_GetDeviceCaps( ::DevCaps, ::Fonts[ 3 ], ::hData )
      ::SetUnits( ::Units )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetDevMode( what, newvalue ) CLASS HBPrinter

   LOCAL uRet

   STATIC aWhat := { DM_ORIENTATION, DM_PAPERSIZE, DM_SCALE, DM_COPIES, DM_DEFAULTSOURCE, DM_PRINTQUALITY, DM_COLOR, DM_DUPLEX, DM_COLLATE, DM_PAPERLENGTH, DM_PAPERWIDTH }

   uRet := RR_SetDevMode( what, newvalue, ::lGlobalChanges, ::hData )
   IF uRet == NIL
      IF ::lReportError
         MsgInfo( ::aOpisy[ 37 ] + ::aOpisy[ 38 + aScan( aWhat, uRet ) ], "" )
      ENDIF
   ELSE
      ::hDCRef := uRet
   ENDIF
   RR_GetDeviceCaps( ::DevCaps, ::Fonts[ 3 ], ::hData )
   ::SetUnits( ::Units )

   RETURN ( uRet # NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetUserMode( what, value, value2 ) CLASS HBPrinter

   ::hDCRef := RR_SetUserMode( what, value, value2, ::hData )
   RR_GetDeviceCaps( ::DevCaps, ::Fonts[ 3 ] )
   ::SetUnits( ::Units )

RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD StartDoc( cDocName ) CLASS HBPrinter

   ::Printing := .T.
   IF HB_ISCHAR( cDocName )
      ::DocName := cDocName
   ENDIF
   IF ! ::PreviewMode
      RR_StartDoc( ::DocName, ::hData )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPage( orient, size, fontname ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( fontname, "F" )

   IF size <> NIL
      ::SetDevMode( DM_PAPERSIZE, size )
   ENDIF
   IF orient <> NIL
      ::SetDevMode( DM_ORIENTATION, orient )
   ENDIF
   IF lhand <> 0
      ::Fonts[ 3 ] := lhand
   ENDIF
   RR_GetDeviceCaps( ::DevCaps, ::Fonts[ 3 ], ::hData )
   ::SetUnits( ::Units )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD StartPage() CLASS HBPrinter

   IF ::PreviewMode
      IF ::InMemory
         ::hDC := RR_CreatEMFile( ::hData )
      ELSE
         ::hDC := RR_CreateFile( ::BaseDoc + AllTrim( Str( ::CurPage ) ) + '.emf', ::hData )
         ::CurPage ++
      ENDIF
   ELSE
      RR_StartPage( ::hData )
   ENDIF
   IF ! ::PrintingEMF
      RR_SelectClipRgn( ::Regions[ 1, 1 ], ::hData )
      RR_SetViewportOrg( ::ViewportOrg, ::hData )
      RR_SetTextColor( ::TextColor, ::hData )
      RR_SetBkColor( ::BkColor, ::hData )
      RR_SetBkMode( ::BkMode, ::hData )
      RR_SelectBrush( ::Brushes[ 1, 1 ], ::hData )
      RR_SelectPen( ::Pens[ 1, 1 ], ::hData )
      RR_SelectFont( ::Fonts[ 1, 1 ], ::hData )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndPage() CLASS HBPrinter

   IF ::PreviewMode
      IF ::InMemory
         AAdd( ::MetaFiles, { RR_ClosEMFile( ::hData ), ::DevCaps[ 1 ], ::DevCaps[ 2 ], ::DevCaps[ 3 ], ::DevCaps[ 4 ], ::DevCaps[ 15 ], ::DevCaps[ 17 ] } )
      ELSE
         RR_CloseFile( ::hData )
         AAdd( ::MetaFiles, { ::BaseDoc + AllTrim( Str( ::CurPage - 1 ) ) + '.emf', ::DevCaps[ 1 ], ::DevCaps[ 2 ], ::DevCaps[ 3 ], ::DevCaps[ 4 ], ::DevCaps[ 15 ], ::DevCaps[ 17 ] } )
      END
   ELSE
      RR_EndPage( ::hData )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EndDoc( cParent, lWait, lSize ) CLASS HBPrinter

   IF ! HB_ISLOGICAL( lWait )
      lWait := ::PreviewMode
   ENDIF
   IF ! HB_ISLOGICAL( lSize )
      lSize := ! lWait
   ENDIF

#ifndef NO_GUI
   ::Preview( cParent, lWait, lSize )
#endif
   IF ! ::PreviewMode
      IF lWait
         MsgInfo( ::aOpisy[ 31 ], "" )
      ENDIF
      RR_EndDoc( ::hData )
   ENDIF
   ::Printing := .F.

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetTextColor( clr ) CLASS HBPrinter

   LOCAL lret := ::TextColor

   IF clr <> NIL
      IF HB_ISNUMERIC ( clr )
         ::TextColor := RR_SetTextColor( clr, ::hData )
      ELSEIF HB_ISARRAY ( clr )
         ::TextColor := RR_SetTextColor( RR_SetRGB( clr[ 1 ], clr[ 2 ], clr[ 3 ] ), ::hData )
      ENDIF
   ENDIF

   RETURN lret

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetPolyFillMode( style ) CLASS HBPrinter

   LOCAL lret := ::PolyFillMode

   ::PolyFillMode := RR_SetPolyFillMode( style, ::hData )

   RETURN lret

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetBkColor( clr ) CLASS HBPrinter

   LOCAL lret := ::BkColor

   IF HB_ISNUMERIC ( clr )
      ::BkColor := RR_SetBkColor( clr, ::hData )
   ELSEIF HB_ISARRAY ( clr )
      ::BkColor := RR_SetBkColor( RR_SetRGB( clr[ 1 ], clr[ 2 ], clr[ 3 ] ), ::hData )
   ENDIF

   RETURN lret

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetBkMode( nmode ) CLASS HBPrinter

   LOCAL lret := ::BkMode

   ::BkMode := nmode
   RR_SetBkMode( nmode, ::hData )

   RETURN lret

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineBrush( defname, lstyle, lcolor, lhatch ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "B" )

   IF lhand == 0
      IF HB_ISARRAY ( lcolor )
         lcolor := RR_SetRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] )
      ENDIF

   lstyle := if( lstyle == NIL, BS_NULL, lstyle )
      lcolor := if( lcolor == NIL, 0xFFFFFF, lcolor )
      lhatch := if( lhatch == NIL, HS_HORIZONTAL, lhatch )
      AAdd( ::Brushes[ 1 ], RR_CreateBrush( lstyle, lcolor, lhatch ) )
      AAdd( ::Brushes[ 2 ], Upper( AllTrim( defname ) ) )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelectBrush( defname ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "B" )

   IF lhand <> 0
      RR_SelectBrush( lhand, ::hData )
      ::Brushes[ 1, 1 ] := lhand
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ModifyBrush( defname, lstyle, lcolor, lhatch ) CLASS HBPrinter

   LOCAL lhand := 0, lpos

   IF defname == "*"
      lpos := AScan( ::Brushes[ 1 ], ::Brushes[ 1, 1 ], 2 )
      IF lpos > 1
         lhand := ::Brushes[ 1, lpos ]
      ENDIF
   ELSE
      lhand := ::GetObjByName( defname, "B" )
      lpos := ::GetObjByName( defname, "B", .T. )
   ENDIF
   IF lhand == 0 .OR. lpos == 0
      ::Error := 1
      RETURN NIL
   ENDIF
   lstyle := if( lstyle == NIL, -1, lstyle )

   IF HB_ISARRAY ( lcolor )
      lcolor := RR_SetRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] )
   ENDIF

   lcolor := if( lcolor == NIL, -1, lcolor )
   lhatch := if( lhatch == NIL, -1, lhatch )
   ::Brushes[ 1, lpos ] := RR_ModifyBrush( lhand, lstyle, lcolor, lhatch )
   IF lhand == ::Brushes[ 1, 1 ]
      ::SelectBrush( ::Brushes[ 2, lpos ] )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefinePen( defname, lstyle, lwidth, lcolor ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "P" )

   IF lhand == 0
      IF HB_ISARRAY ( lcolor )
         lcolor := RR_SetRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] )
      ENDIF
      lstyle := if( lstyle == NIL, PS_SOLID, lstyle )
      lcolor := if( lcolor == NIL, 0xFFFFFF, lcolor )
      lwidth := if( lwidth == NIL, 0, lwidth )
      AAdd( ::Pens[ 1 ], RR_CreatePen( lstyle, lwidth, lcolor ) )
      AAdd( ::Pens[ 2 ], Upper( AllTrim( defname ) ) )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ModifyPen( defname, lstyle, lwidth, lcolor ) CLASS HBPrinter

   LOCAL lhand := 0, lpos

   IF defname == "*"
      lpos := AScan( ::Pens[ 1 ], ::Pens[ 1, 1 ], 2 )
      IF lpos > 1
         lhand := ::Pens[ 1, lpos ]
      ENDIF
   ELSE
      lhand := ::GetObjByName( defname, "P" )
      lpos := ::GetObjByName( defname, "P", .T. )
   ENDIF
   IF lhand == 0 .OR. lpos <= 1
      ::Error := 1
      RETURN NIL
   ENDIF

   lstyle := if( lstyle == NIL, -1, lstyle )

   IF HB_ISARRAY ( lcolor )
      lcolor := RR_SetRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] )
   ENDIF

   lcolor := iif( lcolor == NIL, -1, lcolor )
   lwidth := iif( lwidth == NIL, -1, lwidth )
   ::Pens[ 1, lpos ] := RR_ModifyPen( lhand, lstyle, lwidth, lcolor )
   IF lhand == ::Pens[ 1, 1 ]
      ::SelectPen( ::Pens[ 2, lpos ] )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelectPen( defname ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "P" )

   IF lhand <> 0
      RR_SelectPen( lhand, ::hData )
      ::Pens[ 1, 1 ] := lhand
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineFont( defname, lfontname, lfontsize, lfontwidth, langle, lweight, litalic, lunderline, lstrikeout ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( lfontname, "F" )

   IF lhand == 0
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
      AAdd( ::Fonts[ 1 ], RR_CreateFont( lfontname, lfontsize, -lfontwidth, langle * 10, lweight, litalic, lunderline, lstrikeout, ::hData ) )
      AAdd( ::Fonts[ 2 ], Upper( AllTrim( defname ) ) )
      AAdd( ::Fonts[ 4 ], { lfontname, lfontsize, lfontwidth, langle, lweight, litalic, lunderline, lstrikeout } )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ModifyFont( defname, lfontname, lfontsize, lfontwidth, langle, lweight, lnweight, litalic, lnitalic, lunderline, lnunderline, lstrikeout, lnstrikeout ) CLASS HBPrinter

   LOCAL lhand := 0, lpos

   IF defname == "*"
      lpos := AScan( ::Fonts[ 1 ], ::Fonts[ 1, 1 ], 2 )
      IF lpos > 1
         lhand := ::Fonts[ 1, lpos ]
      ENDIF
   ELSE
      lhand := ::GetObjByName( defname, "F" )
      lpos := ::GetObjByName( defname, "F", .T. )
   ENDIF
   IF lhand == 0 .OR. lpos <= 1
      ::Error := 1
      RETURN NIL
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

   ::Fonts[ 1, lpos ] := RR_CreateFont( ::Fonts[ 4, lpos, 1 ], ::Fonts[ 4, lpos, 2 ], -::Fonts[ 4, lpos, 3 ], ::Fonts[ 4, lpos, 4 ] * 10, ::Fonts[ 4, lpos, 5 ], ::Fonts[ 4, lpos, 6 ], ::Fonts[ 4, lpos, 7 ], ::Fonts[ 4, lpos, 8 ], ::hData )

   IF lhand == ::Fonts[ 1, 1 ]
      ::SelectFont( ::Fonts[ 2, lpos ] )
   ENDIF
   RR_DeleteObjects( { 0, lhand } )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelectFont( defname ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "F" )

   IF lhand <> 0
      RR_SelectFont( lhand, ::hData )
      ::Fonts[ 1, 1 ] := lhand
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetUnits( newvalue, r, c, lAbsolute ) CLASS HBPrinter

   LOCAL oldvalue := ::Units

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
   ::Units := if( newvalue < 0 .OR. newvalue > 4, 0, newvalue )
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Convert( arr, lsize ) CLASS HBPrinter

   LOCAL aret := AClone( arr )

   DO CASE
   CASE ::Units == 0
      aret[ 1 ] := ( arr[ 1 ] ) * ::DevCaps[ 11 ]
      aret[ 2 ] := ( arr[ 2 ] ) * ::DevCaps[ 12 ]
   CASE ::Units == 3
   CASE ::Units == 4
      aret[ 1 ] := ( arr[ 1 ] ) * ::DevCaps[ 3 ] / ( ::MaxRow + 1 )
      aret[ 2 ] := ( arr[ 2 ] ) * ::DevCaps[ 4 ] / ( ::MaxCol + 1 )
   CASE ::Units == 1
      aret[ 1 ] := ( arr[ 1 ] ) * ::DevCaps[ 5 ] / 25.4 - if( ! ::lAbsoluteCoords .AND. lsize == NIL, ::DevCaps[ 9 ], 0 )
      aret[ 2 ] := ( arr[ 2 ] ) * ::DevCaps[ 6 ] / 25.4 - if( ! ::lAbsoluteCoords .AND. lsize == NIL, ::DevCaps[ 10 ], 0 )
   CASE ::Units == 2
      aret[ 1 ] := ( arr[ 1 ] ) * ::DevCaps[ 5 ] - if( ! ::lAbsoluteCoords .AND. lsize == NIL, ::DevCaps[ 9 ], 0 )
      aret[ 2 ] := ( arr[ 2 ] ) * ::DevCaps[ 6 ] - if( ! ::lAbsoluteCoords .AND. lsize == NIL, ::DevCaps[ 10 ], 0 )
   OTHERWISE
      aret[ 1 ] := ( arr[ 1 ] ) * ::DevCaps[ 11 ]
      aret[ 2 ] := ( arr[ 2 ] ) * ::DevCaps[ 12 ]
   ENDCASE

   RETURN aret

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DrawText( row, col, torow, tocol, txt, style, defname, lNoWordBreak ) CLASS HBPrinter

   LOCAL lhf := ::GetObjByName( defname, "F" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   RR_DrawText( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), txt, style, lhf, lNoWordBreak, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TextOut( row, col, txt, defname ) CLASS HBPrinter

   LOCAL lhf := ::GetObjByName( defname, "F" )

   RR_TextOut( txt, ::Convert( { row, col } ), lhf, RAt( " ", txt ), ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Say( row, col, txt, defname, lcolor, lalign ) CLASS HBPrinter

   LOCAL atxt := {}, i, lhf := ::GetObjByName( defname, "F" ), oldalign
   LOCAL apos

   DO CASE
   CASE HB_ISNUMERIC( txt ) ;  AAdd( atxt, Str( txt ) )
   CASE ValType( txt ) == "T" ;  AAdd( atxt, ttoc( txt ) )
   CASE HB_ISDATE( txt ) ;  AAdd( atxt, DToC( txt ) )
   CASE HB_ISLOGICAL( txt ) ;  AAdd( atxt, if( txt, ".T.", ".F." ) )
   CASE ValType( txt ) == "U" ;  AAdd( atxt, "NIL" )
   CASE ValType( txt ) $ "BO" ;  AAdd( atxt, "" )
   CASE HB_ISARRAY( txt ) ;  AEval( txt, {| x | AAdd( atxt, RR_SayConvert( x ) ) } )
   CASE ValType( txt ) $ "MC" ;  atxt := RR_Str2Arr( txt, CRLF )
   ENDCASE
   apos := ::Convert( { row, col } )
   IF lcolor <> NIL
      IF HB_ISNUMERIC ( lcolor )
         RR_SetTextColor( lcolor, ::hData )
      ELSEIF HB_ISARRAY ( lcolor )
         RR_SetTextColor( RR_SetRGB( lcolor[ 1 ], lcolor[ 2 ], lcolor[ 3 ] ), ::hData )
      ENDIF
   ENDIF
   IF lalign <> NIL
      oldalign := RR_GetTextAlign( ::hData )
      RR_SetTextAlign( lalign, ::hData )
   ENDIF
   FOR i := 1 TO Len( atxt )
      RR_TextOut( atxt[ i ], apos, lhf, RAt( " ", atxt[ i ] ), ::hData )
      apos[ 1 ] += ::DevCaps[ 11 ]
   NEXT
   IF lalign <> NIL
      RR_SetTextAlign( oldalign, ::hData )
   ENDIF

   IF lcolor <> NIL
      RR_SetTextColor( ::TextColor, ::hData )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineImageList( defname, cpicture, nicons ) CLASS HBPrinter

   LOCAL lhi := ::GetObjByName( defname, "I" ), w := 0, h := 0, hand

   IF lhi == 0
      hand := RR_CreateImageList( cpicture, nicons, @w, @h )
      IF hand <> 0 .AND. w > 0 .AND. h > 0
         AAdd( ::ImageLists[ 1 ], { hand, nicons, w, h } )
         AAdd( ::ImageLists[ 2 ], Upper( AllTrim( defname ) ) )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DrawImageList( defname, nicon, row, col, torow, tocol, lstyle, color ) CLASS HBPrinter

   LOCAL lhi := ::GetObjByName( defname, "I" )

   IF Empty( lhi )
      RETURN NIL
   ENDIF
   IF COLOR == NIL
      COLOR := -1
   ENDIF
   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_DrawImageList( lhi[ 1 ], nicon, ::Convert( { row, col } ), ::Convert( { torow - row, tocol - col } ), lhi[ 3 ], lhi[ 4 ], lstyle, COLOR, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Rectangle( row, col, torow, tocol, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" ), lhb := ::GetObjByName( defbrush, "B" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_Rectangle( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), lhp, lhb, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD FrameRect( row, col, torow, tocol, defbrush ) CLASS HBPrinter

   LOCAL lhb := ::GetObjByName( defbrush, "B" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_FrameRect( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), lhb, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RoundRect( row, col, torow, tocol, widthellipse, heightellipse, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" ), lhb := ::GetObjByName( defbrush, "B" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   IF widthellipse == NIL
      widthellipse := 0
   ENDIF
   IF heightellipse == NIL
      heightellipse := 0
   ENDIF
   ::Error := RR_RoundRect( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), ::Convert( { widthellipse, heightellipse } ), lhp, lhb, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD FillRect( row, col, torow, tocol, defbrush ) CLASS HBPrinter

   LOCAL lhb := ::GetObjByName( defbrush, "B" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_FillRect( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), lhb, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InvertRect( row, col, torow, tocol ) CLASS HBPrinter

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_InvertRect( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Ellipse( row, col, torow, tocol, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" ), lhb := ::GetObjByName( defbrush, "B" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_Ellipse( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), lhp, lhb, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Arc( row, col, torow, tocol, rowsarc, colsarc, rowearc, colearc, defpen ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_Arc( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), ::Convert( { rowsarc, colsarc } ), ::Convert( { rowearc, colearc } ), lhp, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ArcTo( row, col, torow, tocol, rowrad1, colrad1, rowrad2, colrad2, defpen ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_ArcTo( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), ::Convert( { rowrad1, colrad1 } ), ::Convert( { rowrad2, colrad2 } ), lhp, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Chord( row, col, torow, tocol, rowrad1, colrad1, rowrad2, colrad2, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" ), lhb := ::GetObjByName( defbrush, "B" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_Chord( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), ::Convert( { rowrad1, colrad1 } ), ::Convert( { rowrad2, colrad2 } ), lhp, lhb, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Pie( row, col, torow, tocol, rowrad1, colrad1, rowrad2, colrad2, defpen, defbrush ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" ), lhb := ::GetObjByName( defbrush, "B" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_Pie( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), ::Convert( { rowrad1, colrad1 } ), ::Convert( { rowrad2, colrad2 } ), lhp, lhb, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Polygon( apoints, defpen, defbrush, style ) CLASS HBPrinter

   LOCAL apx := {}, apy := {}, temp
   LOCAL lhp := ::GetObjByName( defpen, "P" ), lhb := ::GetObjByName( defbrush, "B" )

   AEval( apoints, {| x | temp := ::Convert( x ), AAdd( apx, temp[ 2 ] ), AAdd( apy, temp[ 1 ] ) } )
   ::Error := RR_Polygon( apx, apy, lhp, lhb, style, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PolyBezier( apoints, defpen ) CLASS HBPrinter

   LOCAL apx := {}, apy := {}, temp
   LOCAL lhp := ::GetObjByName( defpen, "P" )

   AEval( apoints, {| x | temp := ::Convert( x ), AAdd( apx, temp[ 2 ] ), AAdd( apy, temp[ 1 ] ) } )
   ::Error := RR_PolyBezier( apx, apy, lhp, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PolyBezierTo( apoints, defpen ) CLASS HBPrinter

   LOCAL apx := {}, apy := {}, temp
   LOCAL lhp := ::GetObjByName( defpen, "P" )

   AEval( apoints, {| x | temp := ::Convert( x ), AAdd( apx, temp[ 2 ] ), AAdd( apy, temp[ 1 ] ) } )

   ::Error := RR_PolyBezierTo( apx, apy, lhp, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Line( row, col, torow, tocol, defpen ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" )

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   ::Error := RR_Line( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), lhp, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LineTo( row, col, defpen ) CLASS HBPrinter

   LOCAL lhp := ::GetObjByName( defpen, "P" )

   ::Error := RR_LineTo( ::Convert( { row, col } ), lhp, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetTextExtent( ctext, apoint, deffont ) CLASS HBPrinter

   LOCAL lhf := ::GetObjByName( deffont, "F" )

   ::Error := RR_GetTextExtent( ctext, apoint, lhf, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetTextExtent_MM( ctext, apoint, deffont ) CLASS HBPrinter

   LOCAL lhf := ::GetObjByName( deffont, "F" )

   ::Error = RR_GetTextExtent( ctext, apoint, lhf, ::hData )
   apoint[ 1 ] := 25.4 * apoint[ 1 ] / ::DevCaps[ 5 ]
   apoint[ 2 ] := 25.4 * apoint[ 2 ] / ::DevCaps[ 6 ]

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineRectRgn( defname, row, col, torow, tocol ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "R" )

   IF lhand == 0
      IF torow == NIL
         torow := ::MaxRow
      ENDIF
      IF tocol == NIL
         tocol := ::MaxCol
      ENDIF
      AAdd( ::Regions[ 1 ], RR_CreateRgn( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), 1, NIL, ::hData ) )
      AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineEllipticRgn( defname, row, col, torow, tocol ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "R" )

   IF lhand == 0
      IF torow == NIL
         torow := ::MaxRow
      ENDIF
      IF tocol == NIL
         tocol := ::MaxCol
      ENDIF
      AAdd( ::Regions[ 1 ], RR_CreateRgn( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), 2, NIL, ::hData ) )
      AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineRoundRectRgn( defname, row, col, torow, tocol, widthellipse, heightellipse ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "R" )

   IF lhand == 0
      IF torow == NIL
         torow := ::MaxRow
      ENDIF
      IF tocol == NIL
         tocol := ::MaxCol
      ENDIF
      AAdd( ::Regions[ 1 ], RR_CreateRgn( ::Convert( { row, col } ), ::Convert( { torow, tocol } ), 3, ::Convert( { widthellipse, heightellipse } ), ::hData ) )
      AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefinePolygonRgn( defname, apoints, style ) CLASS HBPrinter

   LOCAL apx := {}, apy := {}, temp
   LOCAL lhand := ::GetObjByName( defname, "R" )

   IF lhand == 0
      AEval( apoints, {| x | temp := ::Convert( x ), AAdd( apx, temp[ 2 ] ), AAdd( apy, temp[ 1 ] ) } )
      AAdd( ::Regions[ 1 ], RR_CreatePolygonRgn( apx, apy, style ) )
      AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CombineRgn( defname, reg1, reg2, style ) CLASS HBPrinter

   LOCAL lr1 := ::GetObjByName( reg1, "R" ), lr2 := ::GetObjByName( reg2, "R" )
   LOCAL lhand := ::GetObjByName( defname, "R" )

   IF lhand == 0 .AND. lr1 # 0 .AND. lr2 # 0
      AAdd( ::Regions[ 1 ], RR_CombineRgn( lr1, lr2, style ) )
      AAdd( ::Regions[ 2 ], Upper( AllTrim( defname ) ) )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SelectClipRgn( defname ) CLASS HBPrinter

   LOCAL lhand := ::GetObjByName( defname, "R" )

   IF lhand <> 0
      RR_SelectClipRgn( lhand, ::hData )
      ::Regions[ 1, 1 ] := lhand
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DeleteClipRgn() CLASS HBPrinter

   ::Regions[ 1, 1 ] := 0
   RR_DeleteClipRgn( ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetViewPortOrg( row, col ) CLASS HBPrinter

   row := if( row <> NIL, row, 0 )
   col := if( col <> NIL, col, 0 )
   ::ViewportOrg := ::Convert( { row, col } )
   RR_SetViewportOrg( ::ViewportOrg, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetViewPortOrg() CLASS HBPrinter

   RR_GetViewportOrg( ::ViewportOrg, ::hData )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD End() CLASS HBPrinter

   LOCAL n

   IF ::PreviewMode
      IF ! ::InMemory
         FOR n := 1 TO Len( ::MetaFiles )
            FErase( ::BaseDoc + AllTrim( Str( n ) ) + '.emf' )
         NEXT
      ENDIF
      ::MetaFiles := {}
   ENDIF
   IF ::hDCRef # 0
      RR_ResetPrinter( ::hData )
      RR_DeleteDC( ::hDCRef, ::hData )
   ENDIF
   RR_DeleteObjects( ::Fonts[ 1 ] )
   RR_DeleteObjects( ::Brushes[ 1 ] )
   RR_DeleteObjects( ::Pens[ 1 ] )
   RR_DeleteObjects( ::Regions[ 1 ] )
   RR_DeleteImageLists( ::ImageLists[ 1 ] )
   RR_Finish( ::hData )
   ::hData := NIL
   IF HB_ISOBJECT( ::oWinPreview )
      ::PrevClose()
   ENDIF
   ::BeforePrint := NIL
   ::AfterPrint := NIL
   ::BeforePrintCopy := NIL

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DxColors( uPar ) CLASS HBPrinter

   LOCAL nColor := 0
   STATIC aColors := { ;
      { "aliceblue", 0xfffff8f0 }, ;
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
      { "yellowgreen", 0xff32cd9a } ;
      }

   IF ValType( uPar ) == "C"
      uPar := Lower( AllTrim( uPar ) )
      AEval( aColors, {| x | if( x[ 1 ] == uPar, nColor := x[ 2 ], '' ) } )
   ELSEIF HB_ISNUMERIC( uPar ) .AND. uPar > 0 .AND. uPar <= Len( aColors )
       nColor := aColors[ uPar, 2 ]
   ENDIF

   RETURN nColor

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetRGB( red, green, blue ) CLASS HBPrinter

   RETURN RR_SetRGB( red, green, blue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetTextCharExtra( col ) CLASS HBPrinter

   LOCAL p1 := ::Convert( { 0, 0 } ), p2 := ::Convert( { 0, col } )

   RETURN RR_SetTextCharExtra( p2[ 2 ] - p1[ 2 ], ::hData )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetTextCharExtra() CLASS HBPrinter

   RETURN RR_GetTextCharExtra( ::hData )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetTextJustification( col ) CLASS HBPrinter

   LOCAL p1 := ::Convert( { 0, 0 } ), p2 := ::Convert( { 0, col } )

   RETURN RR_SetTextJustification( p2[ 2 ] - p1[ 2 ], ::hData )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetTextJustification() CLASS HBPrinter

   RETURN RR_GetTextJustification( ::hData )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetTextAlign( style ) CLASS HBPrinter

   RETURN RR_SetTextAlign( style, ::hData )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetTextAlign() CLASS HBPrinter

   RETURN RR_GetTextAlign( ::hData )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Picture( row, col, torow, tocol, cpicture, extrow, extcol, lImageSize ) CLASS HBPrinter

   LOCAL lp1 := ::Convert( { row, col } ), lp2, lp3

   IF torow == NIL
      torow := ::MaxRow   // height
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol   // width
   ENDIF
   lp2 := ::Convert( { torow, tocol }, 1 )
   IF extrow == NIL
      extrow := 0   // height of the 'extension': to replicate the image
   ENDIF
   IF extcol == NIL
      extcol := 0   // width of the 'extension': to replicate the image
   ENDIF
   lp3 := ::Convert( { extrow, extcol } )

   RETURN RR_DrawPicture( cpicture, lp1, lp2, lp3, lImageSize, ::hData )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Bitmap( row, col, torow, tocol, hbitmap, extrow, extcol, lImageSize ) CLASS HBPrinter

   LOCAL lp1 := ::Convert( { row, col } ), lp2, lp3

   IF torow == NIL
      torow := ::MaxRow
   ENDIF
   IF tocol == NIL
      tocol := ::MaxCol
   ENDIF
   lp2 := ::Convert( { torow, tocol }, 1 )
   IF extrow == NIL
      extrow := 0
   ENDIF
   IF extcol == NIL
      extcol := 0
   ENDIF
   lp3 := ::Convert( { extrow, extcol } )

   RETURN RR_DrawBitmap( hbitmap, lp1, lp2, lp3, lImageSize, ::hData )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION RR_Str2File( ctxt, cfile )

   LOCAL hand, lrec

   hand := FCreate( cfile )
   IF hand < 0
      RETURN 0
   ENDIF
   lrec := FWrite( hand, ctxt )
   FClose( hand )

   RETURN lrec

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION RR_SayConvert( ltxt )

   DO CASE
   CASE ValType( ltxt ) $ "MC"
      RETURN ltxt
   CASE HB_ISNUMERIC( ltxt )
      RETURN Str( ltxt )
   CASE ValType( ltxt ) == "T"
      RETURN TToC( ltxt )
   CASE HB_ISDATE( ltxt )
      RETURN DToC( ltxt )
   CASE HB_ISLOGICAL( ltxt )
      RETURN iif( ltxt, ".T.", ".F." )
   ENDCASE

   RETURN ""

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION RR_Str2Arr( cList, cDelimiter )

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

   RETURN aList

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReportData( l_x1, l_x2, l_x3, l_x4, l_x5, l_x6 ) CLASS HBPrinter

   SET DEVICE TO PRINT
   SET PRINTER TO "hbprinter.rep" ADDITIVE
   SET PRINTER ON
   SET CONSOLE OFF
   ? '-----------------', Date(), Time()
   ?
   ?? iif( ValType( l_x1 ) <> "U", l_x1, "," )
   ?? iif( ValType( l_x2 ) <> "U", l_x2, "," )
   ?? iif( ValType( l_x3 ) <> "U", l_x3, "," )
   ?? iif( ValType( l_x4 ) <> "U", l_x4, "," )
   ?? iif( ValType( l_x5 ) <> "U", l_x5, "," )
   ?? iif( ValType( l_x6 ) <> "U", l_x6, "," )
   ? 'HDC            :', ::hDC
   ? 'HDCREF         :', ::hDCREF
   ? 'PRINTERNAME    :', ::PrinterName
   ? 'PRINTEDEFAULT  :', ::PrinterDefault
   ? 'VERT X HORZ SIZE         :', ::DevCaps[ 1 ], "x", ::DevCaps[ 2 ]
   ? 'VERT X HORZ RES          :', ::DevCaps[ 3 ], "x", ::DevCaps[ 4 ]
   ? 'VERT X HORZ LOGPIX       :', ::DevCaps[ 5 ], "x", ::DevCaps[ 6 ]
   ? 'VERT X HORZ PHYS. SIZE   :', ::DevCaps[ 7 ], "x", ::DevCaps[ 8 ]
   ? 'VERT X HORZ PHYS. OFFSET :', ::DevCaps[ 9 ], "x", ::DevCaps[ 10 ]
   ? 'VERT X HORZ FONT SIZE    :', ::DevCaps[ 11 ], "x", ::DevCaps[ 12 ]
   ? 'VERT X HORZ ROWS COLS    :', ::DevCaps[ 13 ], "x", ::DevCaps[ 14 ]
   ? 'ORIENTATION              :', ::DevCaps[ 15 ]
   ? 'PAPER SIZE               :', ::DevCaps[ 17 ]
   SET PRINTER OFF
   SET PRINTER TO
   SET CONSOLE ON
   SET DEVICE TO SCREEN

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD InitMessages( cLang ) CLASS HBPrinter

   LOCAL nAt, i, cData

#ifndef NO_GUI
   IF ! ValType( cLang ) $ "CM" .OR. Empty( cLang )
      cLang := _OOHG_GetLanguage()
   ENDIF
#endif
   IF ! ValType( cLang ) $ "CM" .OR. Empty( cLang )
      cLang := Set( _SET_LANGUAGE )
   ENDIF
   IF ( nAt := At( ".", cLang ) ) > 0
      cLang := Left( cLang, nAt - 1 )
   ENDIF
   cLang := Upper( AllTrim( cLang ) )

   DO CASE
   CASE cLang == "FR"                                 // French
      ::aOpisy := { "Prévisualisation", ;             // 01
         "&Abandonner", ;                             // 02
         "&Imprimer", ;                               // 03
         "&Enregistrer", ;                            // 04
         "&Premier", ;                                // 05
         "P&récédent", ;                              // 06
         "&Suivant", ;                                // 07
         "&Dernier", ;                                // 08
         "Zoom +", ;                                  // 09
         "Zoom -", ;                                  // 10
         "&Options", ;                                // 11
         "Aller à la page:", ;                        // 12
         "Aperçu de la page", ;                       // 13
         "Aperçu affichettes", ;                      // 14
         "Page", ;                                    // 15
         "Imprimer la page en cours", ;               // 16
         "Pages:", ;                                  // 17
         "Plus de zoom !", ;                          // 18
         "Options d'impression", ;                    // 19
         "Imprimer de", ;                             // 20
         "à", ;                                       // 21
         "Copies", ;                                  // 22
         "Classement", ;                              // 23
         "Tout dans l'intervalle", ;                  // 24
         "Impair seulement", ;                        // 25
         "Pair seulement", ;                          // 26
         "Tout mais impair d'abord", ;                // 27
         "Tout mais pair d'abord", ;                  // 28
         "Impression ....", ;                         // 29
         "Attente de changement de papier...", ;      // 30
         "Appuyez sur OK pour continuer.", ;          // 31
         "Terminé !", ;                               // 32
         "Enregistrer sous...", ;                     // 33
         "Enregistrer tout", ;                        // 34
         "Fichiers EMF", ;                            // 35
         "Tous les fichiers", ;                       // 36
         "Paramètre non supporté:", ;                 // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "DEWIN" .OR. ;
        cLang == "DE"                                 // German
      ::aOpisy := { "Vorschau", ;                     // 01
         "&Abbruch", ;                                // 02
         "&Drucken", ;                                // 03
         "&Speichern", ;                              // 04
         "&Erste", ;                                  // 05
         "&Vorige", ;                                 // 06
         "&Nächste", ;                                // 07
         "&Letzte", ;                                 // 08
         "Ver&größern", ;                             // 09
         "Ver&kleinern", ;                            // 10
         "&Optionen", ;                               // 11
         "Seite:", ;                                  // 12
         "Seitenvorschau", ;                          // 13
         "Überblick", ;                               // 14
         "Seite", ;                                   // 15
         "Aktuelle Seite drucken", ;                  // 16
         "Seiten:", ;                                 // 17
         "Maximum erreicht!", ;                       // 18
         "Druckeroptionen", ;                         // 19
         "Drucke von", ;                              // 20
         "bis", ;                                     // 21
         "Anzahl", ;                                  // 22
         "Bereich", ;                                 // 23
         "Alle Seiten", ;                             // 24
         "Ungerade Seiten", ;                         // 25
         "Gerade Seiten", ;                           // 26
         "Alles ungerade Seiten zuerst", ;            // 27
         "Alles gerade Seiten zuerst", ;              // 28
         "Druckt ....", ;                             // 29
         "Bitte Papier nachlegen...", ;               // 30
         "Drücken Sie OK, um fortzufahren.", ;        // 31
         "Getan!", ;                                  // 32
         "Speichern als...", ;                        // 33
         "Speichern alle", ;                          // 34
         "EMF files", ;                               // 35
         "Alle Dateien", ;                            // 36
         "Nicht unterstützte Einstellung:", ;         // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "IT"                                 // Italian
      ::aOpisy := { "Anteprima", ;                    // 01
         "&Cancella", ;                               // 02
         "S&tampa", ;                                 // 03
         "&Salva", ;                                  // 04
         "&Primo", ;                                  // 05
         "&Indietro", ;                               // 06
         "&Avanti", ;                                 // 07
         "&Ultimo", ;                                 // 08
         "Zoom In", ;                                 // 09
         "Zoom Out", ;                                // 10
         "&Opzioni", ;                                // 11
         "Pagina:", ;                                 // 12
         "Pagina anteprima ", ;                       // 13
         "Miniatura Anteprima", ;                     // 14
         "Pagina", ;                                  // 15
         "Stampa solo pagina attuale", ;              // 16
         "Pagine:", ;                                 // 17
         "Limite zoom !", ;                           // 18
         "Opzioni Stampa", ;                          // 19
         "Stampa da", ;                               // 20
         "a", ;                                       // 21
         "Copie", ;                                   // 22
         "Confronto", ;                               // 23
         "Tutte", ;                                   // 24
         "Solo dispari", ;                            // 25
         "Solo pari", ;                               // 26
         "Tutte iniziando dispari", ;                 // 27
         "Tutte iniziando pari", ;                    // 28
         "Stampa in corso ....", ;                    // 29
         "Attendere cambio carta...", ;               // 30
         "Premere OK per continuare.", ;              // 31
         "Fatto !", ;                                 // 32
         "Salva come...", ;                           // 33
         "Salva tutto", ;                             // 34
         "File EMF", ;                                // 35
         "Tutti i file", ;                            // 36
         "Impostazione non supportata:", ;            // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "PLWIN" .OR. ;
        cLang == "PL852" .OR. ;
        cLang == "PLISO" .OR. ;
        cLang == "PLMAZ"                              // Polish
      ::aOpisy := { "Podgl¹d", ;                      // 01
         "&Rezygnuj", ;                               // 02
         "&Drukuj", ;                                 // 03
         "Zapisz", ;                                  // 04
         "Pierwsza", ;                                // 05
         "Poprzednia", ;                              // 06
         "Nastêpna", ;                                // 07
         "Ostatnia", ;                                // 08
         "Powiêksz", ;                                // 09
         "Pomniejsz", ;                               // 10
         "Opc&je", ;                                  // 11
         "IdŸ do strony:", ;                          // 12
         "Podgl¹d strony", ;                          // 13
         "Podgl¹d miniaturek", ;                      // 14
         "Strona", ;                                  // 15
         "Drukuj aktualn¹ stronê", ;                  // 16
         "Stron:", ;                                  // 17
         "Nie mozna wiêcej !", ;                      // 18
         "Opcje drukowania", ;                        // 19
         "Drukuj od", ;                               // 20
         "do", ;                                      // 21
         "Kopii", ;                                   // 22
         "Zakres", ;                                  // 23
         "Wszystkie z zakresu", ;                     // 24
         "Tylko nieparzyste", ;                       // 25
         "Tylko parzyste", ;                          // 26
         "Najpierw nieparzyste", ;                    // 27
         "Najpierw parzyste", ;                       // 28
         "Drukowanie...", ;                           // 29
         "Czekam na zmiane papieru...", ;             // 30
         "Nacisnij OK, aby kontynuowac.", ;           // 31
         "Gotowy !", ;                                // 32
         "Zapisz jako...", ;                          // 33
         "Zapisz wszystko", ;                         // 34
         "Pliki EMF", ;                               // 35
         "Wszystkie pliki", ;                         // 36
         "Nieobslugiwane ustawienie:" }               // 37
   CASE cLang == "PT"                                 // Portuguese
      ::aOpisy := { "Inspeção Prévia", ;              // 01
         "&Cancelar", ;                               // 02
         "&Imprimir", ;                               // 03
         "&Salvar", ;                                 // 04
         "&Primera", ;                                // 05
         "&Anterior", ;                               // 06
         "Próximo", ;                                 // 07
         "&Último", ;                                 // 08
         "Zoom +", ;                                  // 09
         "Zoom -", ;                                  // 10
         "&Opções", ;                                 // 11
         "Pag.:", ;                                   // 12
         "Página ", ;                                 // 13
         "Miniaturas", ;                              // 14
         "Pag.", ;                                    // 15
         "Imprimir somente a pag. atual", ;           // 16
         "Páginas:", ;                                // 17
         "Zoom Máximo/Minimo", ;                      // 18
         "Opções de Impressão", ;                     // 19
         "Imprimir de", ;                             // 20
         "para", ;                                    // 21
         "Cópias", ;                                  // 22
         "Agrupamento", ;                             // 23
         "Tudo a partir desta", ;                     // 24
         "Só Ímpares", ;                              // 25
         "Só Pares", ;                                // 26
         "Todas as Ímpares Primeiro", ;               // 27
         "Todas Pares primero", ;                     // 28
         "Imprimindo ....", ;                         // 29
         "Esperando por papel...", ;                  // 30
         "Pressione OK para continuar.", ;            // 31
         "Feito!", ;                                  // 32
         "Salvar como...", ;                          // 33
         "Salvar tudo", ;                             // 34
         "Arquivos EMF", ;                            // 35
         "Todos os arquivos", ;                       // 36
         "Configuração não suportada:", ;             // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "RUKOI8" .OR. ;
        cLang == "RU866"  .OR. ;
        cLang == "RUWIN"                              // Russian
      ::aOpisy := { 'Ïðîñìîòð', ;                     // 01
         'Âûõîä', ;                                   // 02
         'Ïå÷àòü', ;                                  // 03
         'Ñîõðàíèòü', ;                               // 04
         'Íà÷àëî', ;                                  // 05
         'Íàçàä', ;                                   // 06
         'Âïåðåä', ;                                  // 07
         'Êîíåö', ;                                   // 08
         'Óâåëè÷èòü', ;                               // 09
         'Óìåíüøèòü', ;                               // 10
         'Îïöèè', ;                                   // 11
         'Ñòðàíèöà:', ;                               // 12
         'Ïðîñìîòð ñòðàíèöû ', ;                      // 13
         'Ìèíèàòþðû', ;                               // 14
         'Ñòðàíèöà', ;                                // 15
         'Ïå÷àòàòü òåêóùóþ', ;                        // 16
         'Ñòðàíèö:', ;                                // 17
         'Äîñòèãíóò ïðåäåë ìàñøòàáèðîâàíèÿ!', ;       // 18
         'Ïàðàìåòðû ïå÷àòè', ;                        // 19
         'Ñòðàíèöû ñ', ;                              // 20
         'ïî', ;                                      // 21
         'Êîïèé', ;                                   // 22
         'Íàïå÷àòàòü', ;                              // 23
         'Âñå ñòðàíèöû', ;                            // 24
         'Íå÷¸òíûå', ;                                // 25
         '×¸òíûå', ;                                  // 26
         'Âñå, íî âíà÷àëå íå÷¸òíûå', ;                // 27
         'Âñå, íî âíà÷àëå ÷¸òíûå', ;                  // 28
         'Ïå÷àòü ....', ;                             // 29
         'Âñòàâüòå áóìàãó...', ;                      // 30
         "Press OK to continue.", ;                   // 31
         "Done!", ;                                   // 32
         'Ñîõðàíèòü êàê...', ;                        // 33
         'Ñîõðàíèòü âñå', ;                           // 34
         'Ôàéëû EMF', ;                               // 35
         'Âñå ôàéëû', ;                               // 36
         "Unsupported setting:", ;                    // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "ES" .OR. ;
        cLang == "ESWIN"                              // Spanish
      ::aOpisy := { "Vista Previa", ;                 // 01
         "&Cerrar", ;                                 // 02
         "&Imprimir", ;                               // 03
         "&Guardar", ;                                // 04
         "&Primera", ;                                // 05
         "&Anterior", ;                               // 06
         "&Siguiente", ;                              // 07
         "&Última", ;                                 // 08
         "Zoom +", ;                                  // 09
         "Zoom -", ;                                  // 10
         "&Opciones", ;                               // 11
         "Ir a Página:", ;                            // 12
         "Página ", ;                                 // 13
         "Miniaturas", ;                              // 14
         "Página", ;                                  // 15
         "Imprimir página actual", ;                  // 16
         "Páginas:", ;                                // 17
         "Zoom Máximo/Mínimo", ;                      // 18
         "Opciones de Impresión", ;                   // 19
         "Imprimir de", ;                             // 20
         "a", ;                                       // 21
         "Copias", ;                                  // 22
         "Compaginación", ;                           // 23
         "Todo, secuencial", ;                        // 24
         "Solo páginas impares", ;                    // 25
         "Solo páginas pares", ;                      // 26
         "Todo, páginas impares primero", ;           // 27
         "Todo, páginas pares primero", ;             // 28
         "Imprimiendo...", ;                          // 29
         "Esperando cambio de papel...", ;            // 30
         "Haga clic en OK para continuar.", ;         // 31
         "¡Listo!", ;                                 // 32
         "Guardar co&mo...", ;                        // 33
         "Guardar &todo", ;                           // 34
         "Archivos EMF", ;                            // 35
         "Todos los archivos", ;                      // 36
         "Configuración no soportada:", ;             // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "UK" .OR. ;
        cLang == "UA"                                 // Ukranian
      ::aOpisy := { 'Ïåðåãëÿä', ;                     // 01
         'Âèõiä', ;                                   // 02
         'Äðóê', ;                                    // 03
         'Çáåðåãòè', ;                                // 04
         'Ïî÷àòîê', ;                                 // 05
         'Íàçàä', ;                                   // 06
         'Âïåðåä', ;                                  // 07
         'Êiíåöü', ;                                  // 08
         'Çáiëüøèòè', ;                               // 09
         'Çìåíøèòè', ;                                // 10
         'Îïöi¿', ;                                   // 11
         'Ñòîðiíêà:', ;                               // 12
         'Ïåðåãëÿä ñòîðiíêè ', ;                      // 13
         'Ìiíiàòþðè', ;                               // 14
         'Ñòîðiíêà', ;                                // 15
         'Äðóêóâàòè ïîòî÷íó', ;                       // 16
         'Ñòîðiíîê:', ;                               // 17
         'Äîñÿãíóòà ìåæà ìàñøòàáóâàííÿ!', ;           // 18
         'Ïàðàìåòðè äðóêó', ;                         // 19
         'Ñòîðiíêè ç', ;                              // 20
         'ïî', ;                                      // 21
         'Êîïié', ;                                   // 22
         'Íàäðóêóâàòè', ;                             // 23
         'Óñi ñòðiíêè', ;                             // 24
         'Íåïàðíi', ;                                 // 25
         'Ïàðíi', ;                                   // 26
         'Óñi, àëå ñïåðøó íåïàðíi', ;                 // 27
         'Óñi, àëå ñïåðøó ïàðíi', ;                   // 28
         'Äðóê ....', ;                               // 29
         'Çàìiíiòü ïàïið...', ;                       // 30
         "Press OK to continue.", ;                   // 31
         "Done!", ;                                   // 32
         'Çáåðåãòè ÿê...', ;                          // 33
         'Çáåðåãòè âñå', ;                            // 34
         'Ôàéëè EMF', ;                               // 35
         'Óñi ôàéëè', ;                               // 36
         "Unsupported setting:", ;                    // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "FI"                                 // Finnish
      ::aOpisy := { "Esikatsele", ;                   // 01
         "&Keskeytä", ;                               // 02
         "&Tulosta", ;                                // 03
         "T&allenna", ;                               // 04
         "&Ensimmäinen", ;                            // 05
         "E&dellinen", ;                              // 06
         "&Seuraava", ;                               // 07
         "&Viimeinen", ;                              // 08
         "Suurenna", ;                                // 09
         "Pienennä", ;                                // 10
         "&Optiot", ;                                 // 11
         "Mene sivulle:", ;                           // 12
         "Esikatsele sivu ", ;                        // 13
         "Esikatsele miniatyyrit", ;                  // 14
         "Sivu", ;                                    // 15
         "Tulosta tämä sivu", ;                       // 16
         "Sivuja:", ;                                 // 17
         "Ei voi suurentaa !", ;                      // 18
         "Tulostus optiot", ;                         // 19
         "Alkaen", ;                                  // 20
         "->", ;                                      // 21
         "Kopiot", ;                                  // 22
         "Tulostus alue", ;                           // 23
         "Kaikki alueelta", ;                         // 24
         "Vain parittomat", ;                         // 25
         "Vain parilleset", ;                         // 26
         "Kaikki paitsi ensim. pariton", ;            // 27
         "Kaikki paitsi ensim. parillinen", ;         // 28
         "Tulostan ....", ;                           // 29
         "Odotan paperin vaihtoa...", ;               // 30
         "Jatka painamalla OK.", ;                    // 31
         "Valmis!", ;                                 // 32
         "Tallenna nimellä...", ;                     // 33
         "Tallenna kaikki", ;                         // 34
         "EMF Tiedostot", ;                           // 35
         "Kaikki Tiedostot", ;                        // 36
         "Asetusta ei tueta:", ;                      // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "NL"                                 // Dutch
      ::aOpisy := { 'Afdrukvoorbeeld', ;              // 01
         'Annuleer', ;                                // 02
         'Print', ;                                   // 03
         'Opslaan', ;                                 // 04
         'Eerste', ;                                  // 05
         'Vorige', ;                                  // 06
         'Volgende', ;                                // 07
         'Laatste', ;                                 // 08
         'Inzoomen', ;                                // 09
         'Uitzoomen', ;                               // 10
         'Opties', ;                                  // 11
         'Ga naar pagina:', ;                         // 12
         'Pagina voorbeeld ', ;                       // 13
         'Thumbnails voorbeeld', ;                    // 14
         'Pagina', ;                                  // 15
         'Print alleen huidige pagina', ;             // 16
         "Pagina's:", ;                               // 17
         'Geen zoom meer !', ;                        // 18
         'Print opties', ;                            // 19
         'Print van', ;                               // 20
         'tot', ;                                     // 21
         'Exemplaren', ;                              // 22
         "Pagina's", ;                                // 23
         "Alle pagina's", ;                           // 24
         'Alleen oneven', ;                           // 25
         'Alleen even', ;                             // 26
         'Alles maar oneven eerst', ;                 // 27
         'Alles maar even eerst', ;                   // 28
         'Printen ....', ;                            // 29
         'Wacht op papier wissel...', ;               // 30
         "Druk op OK om door te gaan.", ;             // 31
         "Gedaan!", ;                                 // 32
         'Be&waar als...', ;                          // 33
         'Bewaar &Alles', ;                           // 34
         'EMF-bestanden', ;                           // 35
         'Alle bestanden', ;                          // 36
         "Niet-ondersteunde instelling:", ;           // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "CS"                                 // Czech
      ::aOpisy := { "Náhled", ;                       // 01
         "&Storno", ;                                 // 02
         "&Tisk", ;                                   // 03
         "&Uložit", ;                                 // 04
         "&První", ;                                  // 05
         "P&øedchozí", ;                              // 06
         "&Další", ;                                  // 07
         "P&oslední", ;                               // 08
         "Z&vìtšit", ;                                // 09
         "&Zmenšit", ;                                // 10
         "&Možnosti", ;                               // 11
         "Ukaž stranu:", ;                            // 12
         "Náhled strany ", ;                          // 13
         "Náhled více strán", ;                       // 14
         "Strana", ;                                  // 15
         "Tisk aktuální strany", ;                    // 16
         "Strán:", ;                                  // 17
         "Nemožno dále mìnit velikost!", ;            // 18
         "Možnosti tisku", ;                          // 19
         "Tisk od", ;                                 // 20
         "po", ;                                      // 21
         "Kópií", ;                                   // 22
         "Tisk stran", ;                              // 23
         "Všechny stran", ;                           // 24
         "Jenom liché", ;                             // 25
         "Jenom sudé", ;                              // 26
         "Všechny kromì první liché", ;               // 27
         "Všechny kromì první sudéj", ;               // 28
         "Tisknu ...", ;                              // 29
         "Èekám na papír ...", ;                      // 30
         "Pokracujte stisknutím tlacítka OK.", ;      // 31
         "Hotovo!", ;                                 // 32
         "Uložit &jako...", ;                         // 33
         "Uložit &všechno", ;                         // 34
         "EMF soubor", ;                              // 35
         "Všechny soubory", ;                         // 36
         "Nepodporované nastavení:", ;                // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "SK"                                 // Slovak
      ::aOpisy := { "Náh¾ad", ;                       // 01
         "&Storno", ;                                 // 02
         "&Tlaè", ;                                   // 03
         "Uložit", ;                                  // 04
         "&Prvá", ;                                   // 05
         "P&redcházajúca", ;                          // 06
         "&Ïalšia", ;                                 // 07
         "Po&sledná", ;                               // 08
         "Zoom +", ;                                  // 09
         "Zoom -", ;                                  // 10
         "&Možnosti", ;                               // 11
         "Ukáž stranu:", ;                            // 12
         "Náh¾ad strany ", ;                          // 13
         "Náh¾ad viacerých stránok", ;                // 14
         "Strana", ;                                  // 15
         "Tlaè aktuálnej strany", ;                   // 16
         "Strana:", ;                                 // 17
         "Už žiadne priblíženie", ;                   // 18
         "Možnosti tlaèe", ;                          // 19
         "Tlaè od", ;                                 // 20
         "po", ;                                      // 21
         "Kópií", ;                                   // 22
         "Tlaè strán", ;                              // 23
         "Všetky strany", ;                           // 24
         "Len nepárne", ;                             // 25
         "Len párne", ;                               // 26
         "Všetko, najskôr nepárne stránky", ;         // 27
         "Všetko, najskôr párne stránky", ;           // 28
         "Tlaèím ...", ;                              // 29
         "Èakám na papier ...", ;                     // 30
         "Pokracujte stlacením tlacidla OK. ", ;      // 31
         "Hotový!", ;                                 // 32
         "Uloži ako...", ;                            // 33
         "Uloži všetko", ;                            // 34
         "EMF súbor", ;                               // 35
         "Všetky súbory", ;                           // 36
         "Nepodporované nastavenie:", ;               // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "SLWIN" .OR. ;
        cLang == "SLISO" .OR. ;
        cLang == "SL852" .OR. ;
        cLang == "SL437"                              // Slovenian
      ::aOpisy := { 'Predgled', ;                     // 01
         'Prekini', ;                                 // 02
         'Natisni', ;                                 // 03
         'Shrani', ;                                  // 04
         'Prva', ;                                    // 05
         'Prejšnja', ;                                // 06
         'Naslednja', ;                               // 07
         'Zadnja', ;                                  // 08
         'Poveèaj', ;                                 // 09
         'Pomanjšaj', ;                               // 10
         'Možnosti', ;                                // 11
         'Skok na stran:', ;                          // 12
         'Predgled', ;                                // 13
         'Mini predgled', ;                           // 14
         'Stran', ;                                   // 15
         'Samo trenutna stran', ;                     // 16
         'Strani:', ;                                 // 17
         'Ni veè poveèave!', ;                        // 18
         'Možnosti tiskanja', ;                       // 19
         'Tiskaj od', ;                               // 20
         'do', ;                                      // 21
         'Kopij', ;                                   // 22
         'Tiskanje', ;                                // 23
         'Vse iz izbora', ;                           // 24
         'Samo neparne strani', ;                     // 25
         'Samo parne strani', ;                       // 26
         'Vse - neparne strani najprej', ;            // 27
         'Vse - parne strani najprej', ;              // 28
         'Tiskanje ....', ;                           // 29
         'Èakanje na zamenjavo papirja...', ;         // 30
         "Pritisnite OK za nadaljevanje.", ;          // 31
         "Koncano!", ;                                // 32
         'Shrani kot...', ;                           // 33
         'Shrani vse', ;                              // 34
         'EMF datoteke', ;                            // 35
         'Vse datoteke', ;                            // 36
         "Nepodprta nastavitev:", ;                   // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "HU"                                 // Hungarian
      ::aOpisy := { "Elõnézet", ;                     // 01
         "&Mégse", ;                                  // 02
         "Nyo&mtatás", ;                              // 03
         "&Mentés", ;                                 // 04
         "&Elsõ", ;                                   // 05
         "E&lõzõ", ;                                  // 06
         "&Következõ", ;                              // 07
         "&Utolsó", ;                                 // 08
         "&Nagyítás", ;                               // 09
         "K&icsinyítés", ;                            // 10
         "&Opciók", ;                                 // 11
         "Oldalt mutasd:", ;                          // 12
         "Oldal elõnézete ", ;                        // 13
         "Több oldal elõnézete", ;                    // 14
         "Oldal", ;                                   // 15
         "Aktuális oldal nyomtatása", ;               // 16
         "Oldal:", ;                                  // 17
         "A nagyság tovább nem változtatható!", ;     // 18
         "Nyomtatási lehetõségek", ;                  // 19
         "Nyomtatás ettõl", ;                         // 20
         "eddig", ;                                   // 21
         "Másolat", ;                                 // 22
         "Egyeztetés", ;                              // 23
         "Minden oldalt", ;                           // 24
         "Csak a páratlan", ;                         // 25
         "Csak a páros", ;                            // 26
         "Mindet kivéve az elsõ páratlant", ;         // 27
         "Mindet kivéve az elsõ párost", ;            // 28
         "Nyomtatom ...", ;                           // 29
         "Papírra várok ...", ;                       // 30
         "A folytatáshoz nyomja meg az OK gombot.", ; // 31  ;
         "Kész!", ;                                   // 32
         "Mentés másként ...", ;                      // 33
         "Mindet mentsd", ;                           // 34
         "EMF állomány", ;                            // 35
         "Minden állomány", ;                         // 36
         "Nem támogatott beállítás:", ;               // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "EL"                                 // Greek - Ellinika
      ::aOpisy := { 'ÐñïâïëÞ', ;                      // 01
         '&Áêõñï', ;                                  // 02
         '&Ôýðùóå', ;                                 // 03
         '&Óþóå', ;                                   // 04
         '&1ç', ;                                     // 05
         'Ð&ñïçã/íç', ;                               // 06
         '&Åðïìåíç', ;                                // 07
         '&Ôåëåõô/á', ;                               // 08
         'Zoom +', ;                                  // 09
         'Zoom -', ;                                  // 10
         '&Åðéëïãåò', ;                               // 11
         'Ðçãáéíå óåë:', ;                            // 12
         'Ðñïâïëç ', ;                                // 13
         'Ìéêñïãñáößåò', ;                            // 14
         'Óåë.', ;                                    // 15
         'Ôõðùóå ìïíï ôçí ðáñïõóá', ;                 // 16
         'Óåëéäåò:', ;                                // 17
         'Ï÷é Üëëï zoom !', ;                         // 18
         'ÅðéëïãÝò', ;                                // 19
         'Ôýðùóå áðü', ;                              // 20
         'Ýùò', ;                                     // 21
         'Áíôßãñáöá', ;                               // 22
         'Åýñïò åêôýðùóçò', ;                         // 23
         'Ïëåò áðï', ;                                // 24
         'Ìüíï ÌïíÝò ', ;                             // 25
         'Ìüíï ÆõãÝò', ;                              // 26
         'Ïëåò åêôïò áðï ôçí 1ç ìïíÞ', ;              // 27
         'Ïëåò åêôïò áðï ôçí 1ç æõãÞ', ;              // 28
         'Ôõðþíù ....', ;                             // 29
         'Áíáìïíç ãéá áëëáãç ÷áñôéïõ...', ;           // 30
         "Press OK to continue.", ;                   // 31
         "Done!", ;                                   // 32
         'ÁðïèÞêåõóç ùò..', ;                         // 33
         'ÁðïèÞêåõóç üëùí', ;                         // 34
         'Áñ÷åßá EMF', ;                              // 35
         '¼ëá ôá áñ÷åßá', ;                           // 36
         "Unsupported setting:", ;                    // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "BG"                                 // Bulgarian
      ::aOpisy := { 'Ïðåãëåä', ;                      // 01
         'Èçõîä', ;                                   // 02
         'Ïå÷àò', ;                                   // 03
         'Ñúõðàíè', ;                                 // 04
         'Íà÷àëî', ;                                  // 05
         'Íàçàä', ;                                   // 06
         'Íàïðåä', ;                                  // 07
         'Êðàé', ;                                    // 08
         'Óâåëè÷è', ;                                 // 09
         'Íàìàëè', ;                                  // 10
         'Îïöèè', ;                                   // 11
         'Ñòðàíèöà:', ;                               // 12
         'Ïðåãëåä íà ñòðàíèöàòà ', ;                  // 13
         'Ìèíèàòþðè', ;                               // 14
         'Ñòðàíèöà', ;                                // 15
         'Ïå÷àòàíå íà òåêóùà', ;                      // 16
         'Ñòðàíèöè:', ;                               // 17
         'Äîñòèãíàò e ïðåäåëà íà ìàùàáèðàíå!', ;      // 18
         'Ïàðàìåòðè çà ïå÷àò', ;                      // 19
         'Ñòðàíèöè îò', ;                             // 20
         'äî', ;                                      // 21
         'Êîïèÿ', ;                                   // 22
         'Íàïå÷àòàé', ;                               // 23
         'Âñè÷êè ñòðàíèöè', ;                         // 24
         'Íå÷åòíèòå', ;                               // 25
         '×åòíèòå', ;                                 // 26
         'Âñè÷êè, íî ïúðâî íå÷åòíèòå', ;              // 27
         'Âñè÷êè, íî ïúðâî ÷åòíèòå', ;                // 28
         'Ïå÷àò ....', ;                              // 29
         'Ïîñòàâåòå õàðòèÿ...', ;                     // 30
         "Press OK to continue.", ;                   // 31
         "Done!", ;                                   // 32
         'Ñúõðàíè êàòî...', ;                         // 33
         'Ñúõðàíè âñè÷êî', ;                          // 34
         'Ôàéëîâå EMF', ;                             // 35
         'Âñè÷êè ôàéëîâå', ;                          // 36
         "Unsupported setting:", ;                    // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "HR852"                              // Croatian
      ::aOpisy := { "Pregled", ;                      // 01
         "Otkazati", ;                                // 02
         "Ispis", ;                                   // 03
         "Uštedjeti", ;                               // 04
         "Prvo", ;                                    // 05
         "Prethodni", ;                               // 06
         "Sljedeci", ;                                // 07
         "Posljednji", ;                              // 08
         "Zumirati", ;                                // 09
         "Umanji", ;                                  // 10
         "Opcije", ;                                  // 11
         "Idi na stranicu:", ;                        // 12
         "Pregled stranice", ;                        // 13
         "Pregledavanje slicica", ;                   // 14
         "Stranica", ;                                // 15
         "Ispis samo trenutne stranice", ;            // 16
         "Stranice:", ;                               // 17
         "Nema više zumiranja!", ;                    // 18
         "Opcije ispisa", ;                           // 19
         "Ispis iz", ;                                // 20
         "->", ;                                      // 21
         "Kopije", ;                                  // 22
         "Raspon ispisa", ;                           // 23
         "Sve iz dometa", ;                           // 24
         "Samo neparno", ;                            // 25
         "Cak i samo", ;                              // 26
         "Sve osim neparno prvo", ;                   // 27
         "Sve, ali cak i prvo", ;                     // 28
         "Tisak ...", ;                               // 29
         "Ceka se promjena papira ...", ;             // 30
         "Pritisnite OK za nastavak.", ;              // 31
         "Gotovo!", ;                                 // 32
         "Spremi kao...", ;                           // 33
         "Spremi sve", ;                              // 34
         "EMF datoteke", ;                            // 35
         "Sve datoteke", ;                            // 36
         "Nepodržana postavka:", ;                    // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "EU"                                 // Basque
      ::aOpisy := { "Aurrebista", ;                   // 01
         "Utzi", ;                                    // 02
         "Inprimatu", ;                               // 03
         "Gorde", ;                                   // 04
         "Lehenik", ;                                 // 05
         "Aurrekoa", ;                                // 06
         "Hurrengoa", ;                               // 07
         "Azkena", ;                                  // 08
         "Zoom In", ;                                 // 09
         "Zoom handiagotu", ;                         // 10
         "Aukerak", ;                                 // 11
         "Joan Orrialdera:", ;                        // 12
         "Orriaren aurrebista", ;                     // 13
         "Miniatutako aurrebista", ;                  // 14
         "Orria", ;                                   // 15
         "Uneko orria inprimatu bakarrik", ;          // 16
         "Orrialdeak:", ;                             // 17
         "Ez gehiago zoom!", ;                        // 18
         "Inprimatzeko aukerak", ;                    // 19
         "Inprimatu", ;                               // 20
         "etik", ;                                    // 21
         "Kopiak", ;                                  // 22
         "Inprimatu barrutia", ;                      // 23
         "Guztiak barrutik", ;                        // 24
         "Bitxia bakarrik", ;                         // 25
         "Bakarrik", ;                                // 26
         "Lehenik eta bakoitiak", ;                   // 27
         "Guztiak, baina baita lehen ere", ;          // 28
         "Inprimaketa ...", ;                         // 29
         "Papera aldatzeko zain ...", ;               // 30
         "Sakatu OK jarraitzeko.", ;                  // 31
         "Egina!", ;                                  // 32
         "Gorde...", ;                                // 33
         "Gorde guztiak", ;                           // 34
         "EMF fitxategiak", ;                         // 35
         "Fitxategi guztiak", ;                       // 36
         "Ezarpenik gabeko ezarpena:", ;               // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   CASE cLang == "TR"                                 // Turkish
      ::aOpisy := { "Önizleme", ;                     // 01
         "Iptal", ;                                   // 02
         "Yazdir", ;                                  // 03
         "Kaydet", ;                                  // 04
         "Ilk", ;                                     // 05
         "Önceki", ;                                  // 06
         "Ileri", ;                                   // 07
         "Son", ;                                     // 08
         "Yakinlastir", ;                             // 09
         "Uzaklastir", ;                              // 10
         "Seçenekler", ;                              // 11
         "Sayfaya Git:", ;                            // 12
         "Sayfa önizlemesi", ;                        // 13
         "Küçük resimlerin önizlemesi", ;             // 14
         "Sayfa", ;                                   // 15
         "Yalnizca geçerli sayfayi yazdir", ;         // 16
         "Sayfalar:", ;                               // 17
         "Artik zoom yok!", ;                         // 18
         "Yazdirma seçenekleri", ;                    // 19
         "Yazdir", ;                                  // 20
         "kadar", ;                                   // 21
         "Kopya", ;                                   // 22
         "Karsilastirma", ;                           // 23
         "Tüm araliktan", ;                           // 24
         "Sadece Garip", ;                            // 25
         "Sadece", ;                                  // 26
         "Ilk önce garip olanlarin hepsi", ;          // 27
         "Ilk önce hepsi bile", ;                     // 28
         "Yazdiriliyor ...", ;                        // 29
         "Kagit degisimi bekleniyor ...", ;           // 30
         "Devam etmek için OK tusuna basin.", ;       // 31
         "Bitti!", ;                                  // 32
         "Farkli kaydet ...", ;                       // 33
         "Tümünü kaydet", ;                           // 34
         "EMF dosyalari", ;                           // 35
         "Tüm dosyalar", ;                            // 36
         "Desteklenmeyen ayar:", ;                    // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   OTHERWISE
      ::aOpisy := { "Preview", ;                      // 01
         "&Cancel", ;                                 // 02
         "&Print", ;                                  // 03
         "&Save", ;                                   // 04
         "&First", ;                                  // 05
         "P&revious", ;                               // 06
         "&Next", ;                                   // 07
         "&Last", ;                                   // 08
         "Zoom In", ;                                 // 09
         "Zoom Out", ;                                // 10
         "&Options", ;                                // 11
         "Go To Page:", ;                             // 12
         "Page preview ", ;                           // 13
         "Thumbnails preview", ;                      // 14
         "Page", ;                                    // 15
         "Print current page only", ;                 // 16
         "Pages:", ;                                  // 17
         "No more zoom!", ;                           // 18
         "Print options", ;                           // 19
         "Print from", ;                              // 20
         "to", ;                                      // 21
         "Copies", ;                                  // 22
         "Collation", ;                               // 23
         "Everything, sequential", ;                  // 24
         "Only odd pages", ;                          // 25
         "Only even pages", ;                         // 26
         "Everything, odd pages first", ;             // 27
         "Everything, even pages first", ;            // 28
         "Printing...", ;                             // 29
         "Waiting for paper change...", ;             // 30
         "Press OK to continue.", ;                   // 31
         "Done!", ;                                   // 32
         "Save as...", ;                              // 33
         "Save all", ;                                // 34
         "EMF files", ;                               // 35
         "All files", ;                               // 36
         "Unsupported setting:", ;                    // 37
         "UNKNOWN", ;                                 // 38
         "ORIENTATION", ;                             // 39
         "PAPERSIZE", ;                               // 40
         "SCALE", ;                                   // 41
         "COPIES", ;                                  // 42
         "DEFAULTSOURCE", ;                           // 43
         "PRINTQUALITY", ;                            // 44
         "COLOR", ;                                   // 45
         "DUPLEX", ;                                  // 46
         "COLLATE", ;                                 // 47
         "PAPERLENGTH", ;                             // 48
         "PAPERWIDTH" }                               // 49
   ENDCASE

   FOR i := 1 TO 36
      IF ! Empty( cData := LoadString( i ) )
         ::aOpisy[ i ] := cData
      ENDIF
   NEXT i

   RETURN NIL

#ifndef NO_GUI
/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SaveMetaFiles( number, filename ) CLASS HBPrinter

   LOCAL n

   IF ::PreviewMode
      IF ! HB_ISNUMERIC( number ) .OR. number < 1 .OR. number > Len( ::MetaFiles )
         number := NIL
      ENDIF
      IF Empty( filename )
         filename := ::DocName + "_page_"
      ENDIF

      IF ::InMemory
         IF number == NIL
            AEval( ::MetaFiles, {| x, xi | RR_Str2File( x[ 1 ], filename + AllTrim( Str( xi ) ) + ".emf" ) } )
         ELSE
            RR_Str2File( ::MetaFiles[ number, 1 ], filename + AllTrim( Str( number ) ) + ".emf" )
         ENDIF
      ELSE
         IF number <> NIL
            COPY FILE ( ::BaseDoc + AllTrim( Str( number ) ) + '.emf' ) TO ( filename + AllTrim( Str( number ) ) + ".emf" )
         ELSE
            FOR n := 1 TO Len( ::MetaFiles )
               COPY FILE ( ::BaseDoc + AllTrim( Str( n ) ) + '.emf' ) TO ( filename + AllTrim( Str( n ) ) + ".emf" )
            END
         ENDIF
      ENDIF

      IF ::NotifyOnSave
         MsgInfo( ::aOpisy[ 32 ], "" )
      ENDIF
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrevThumb( nclick ) CLASS HBPrinter

   LOCAL i, spage

   IF ::IloscStron == 1
      RETURN NIL
   ENDIF
   IF nclick <> NIL
      ::Page := ::nGroup * 15 + nclick
      ::PrevShow()
      ::oWinPreview:combo_1:value := ::Page
      RETURN NIL
   ENDIF
   IF Int( ( ::Page - 1 ) / 15 ) <> ::nGroup
      ::nGroup := Int( ( ::Page - 1 ) / 15 )
   ELSE
      RETURN NIL
   ENDIF
   spage := ::nGroup * 15

   FOR i := 1 TO 15
      IF i + spage > ::IloscStron
         HideWindow( ::AtH[ i, 5 ] )
      ELSE
         IF ::MetaFiles[ i + spage, 2 ] >= ::MetaFiles[ i + spage, 3 ]
            ::AtH[ i, 3 ] := ::dy - 5
            ::AtH[ i, 4 ] := ::dx * ::MetaFiles[ i + spage, 3 ] / ::MetaFiles[ i + spage, 2 ] - 5
         ELSE
            ::AtH[ i, 4 ] := ::dx - 5
            ::AtH[ i, 3 ] := ::dy * ::MetaFiles[ i + spage, 2 ] / ::MetaFiles[ i + spage, 3 ] - 5
         ENDIF
         IF ::InMemory
            RR_PlayThumb( ::AtH[ i ], ::MetaFiles[ i + spage ], AllTrim( Str( i + spage ) ), i, ::hData )
         ELSE
            RR_PlayFThumb( ::AtH[ i ], ::MetaFiles[ i + spage, 1 ], AllTrim( Str( i + spage ) ), i, ::hData )
         ENDIF
         CShowControl( ::AtH[ i, 5 ] )
      ENDIF
   NEXT

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrevShow() CLASS HBPrinter

   LOCAL spos, hImage

   IF ::Thumbnails
      ::PrevThumb()
   ENDIF

   spos := Array( 2 )

   IF Empty( ::aZoom[ 4 ] )
      spos[ 1 ] := 0
   ELSE
      spos[ 1 ] := GetScrollpos( ::aHS[ 5, 7 ], SB_HORZ ) / ::aZoom[ 4 ]
   ENDIF

   IF Empty( ::aZoom[ 3 ] )
      spos[ 2 ] := 0
   ELSE
      spos[ 2 ] := GetScrollpos( ::aHS[ 5, 7 ], SB_VERT ) / ::aZoom[ 3 ]
   ENDIF

   IF ::MetaFiles[ ::Page, 2 ] >= ::MetaFiles[ ::Page, 3 ]
      ::aZoom[ 3 ] := ( ::aHS[ 5, 3 ] ) * ::Scale - 60
      ::aZoom[ 4 ] := ( ::aHS[ 5, 3 ] * ::MetaFiles[ ::Page, 3 ] / ::MetaFiles[ ::Page, 2 ] ) * ::Scale - 60
   ELSE
      ::aZoom[ 3 ] := ( ::aHS[ 5, 4 ] * ::MetaFiles[ ::Page, 2 ] / ::MetaFiles[ ::Page, 3 ] ) * ::Scale - 60
      ::aZoom[ 4 ] := ( ::aHS[ 5, 4 ] ) * ::Scale - 60
   ENDIF
   ::oWinPreview:StatusBar:Item( 1, ::aOpisy[ 15 ] + " " + AllTrim( Str( ::Page ) ) )

   IF ::aZoom[ 3 ] < 30
      ::Scale := ::Scale * 1.25
      ::PrevShow()
      MsgStop( ::aOpisy[ 18 ], "" )
   ENDIF
   HideWindow( ::aHS[ 6, 7 ] )
   ::oWinPagePreview:i1:SizePos(,, ::aZoom[ 4 ], ::aZoom[ 3 ] )
   ::oWinPagePreview:VirtualHeight := ::aZoom[ 3 ] + 20
   ::oWinPagePreview:VirtualWidth := ::aZoom[ 4 ] + 20

   IF ::InMemory
      hImage := RR_PreviewPlay( ::aHS[ 6, 7 ], ::MetaFiles[ ::Page ], ::aZoom )
   ELSE
      hImage := RR_PreviewFPlay( ::aHS[ 6, 7 ], ::MetaFiles[ ::Page, 1 ], ::aZoom )
   ENDIF
   if ! ValidHandler( hImage )
      ::Scale := ::Scale / 1.25
      ::PrevShow()
      MsgStop( ::aOpisy[ 18 ], ::aOpisy[ 1 ] )
   ELSE
      ::oWinPagePreview:i1:hbitmap := hImage
   ENDIF
   RR_ScrollWindow( ::aHS[ 5, 7 ], -spos[ 1 ] * ::aZoom[ 4 ], -spos[ 2 ] * ::aZoom[ 3 ] )
   CShowControl( ::aHS[ 6, 7 ] )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrevPrint( n1 ) CLASS HBPrinter

   LOCAL i, ilkop, toprint := .T.

   IF ! Eval( ::BeforePrint )
      RETURN NIL
   ENDIF

   ::PreviewMode := .F.
   ::PrintingEMF := .T.
   RR_LaLaBye( 1, ::hData )
   IF n1 <> NIL
      ::StartDoc()
      ::SetPage( ::MetaFiles[ n1, 6 ], ::MetaFiles[ n1, 7 ] )
      ::StartPage()
      IF ::InMemory
         RR_PlayEnhMetaFile( ::MetaFiles[ n1 ], ::hDCRef )
      ELSE
         RR_PlayFEnhMetaFile( ::MetaFiles[ n1 ], ::hDCRef )
      END
      ::EndPage()
      ::EndDoc()
   ELSE
      FOR ilkop = 1 TO ::nCopies
         IF ! Eval( ::BeforePrintCopy, ilkop )
            RR_LaLaBye( 0, ::hData )
            ::PrintingEMF := .F.
            ::PreviewMode := .T.
            RETURN NIL
         ENDIF
         ::StartDoc()
         FOR i := Max( 1, ::nFromPage ) TO Min( ::IloscStron, ::nToPage )
            DO CASE
            CASE ::PrintOpt == 1 ; toprint := .T.
            CASE ::PrintOpt == 2 .OR. ::PrintOpt == 4 ; toprint := !( i % 2 == 0 )
            CASE ::PrintOpt == 3 .OR. ::PrintOpt == 5 ; toprint := ( i % 2 == 0 )
            ENDCASE
            IF toprint
               toprint := .F.
               ::SetPage( ::MetaFiles[ i, 6 ], ::MetaFiles[ i, 7 ] )
               ::StartPage()
               IF ::InMemory
                  RR_PlayEnhMetaFile( ::MetaFiles[ i ], ::hDCRef )
               ELSE
                  RR_PlayFEnhMetaFile( ::MetaFiles[ i ], ::hDCRef )
               END

               ::EndPage()
            ENDIF
         NEXT i
         ::EndDoc()

         IF ::PrintOpt == 4 .OR. ::PrintOpt == 5
            MsgBox( ::aOpisy[ 30 ], ::aOpisy[ 29 ] )
            ::StartDoc()
            FOR i := Max( 1, ::nFromPage ) TO Min( ::IloscStron, ::nToPage )
               DO CASE
               CASE ::PrintOpt == 4 ; toprint := ( i % 2 == 0 )
               CASE ::PrintOpt == 5 ; toprint := !( i % 2 == 0 )
               ENDCASE
               IF toprint
                  toprint := .F.
                  ::SetPage( ::MetaFiles[ i, 6 ], ::MetaFiles[ i, 7 ] )
                  ::StartPage()
                  IF ::InMemory
                     RR_PlayEnhMetaFile( ::MetaFiles[ i ], ::hDCRef )
                  ELSE
                     RR_PlayFEnhMetaFile( ::MetaFiles[ i ], ::hDCRef )
                  END
                  ::EndPage()
               ENDIF
            NEXT i
            ::EndDoc()
         ENDIF
      NEXT ilkop
   ENDIF
   RR_LaLaBye( 0, ::hData )
   ::PrintingEMF := .F.
   ::PreviewMode := .T.
   Eval( ::AfterPrint )

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Preview( cParent, lWait, lSize ) CLASS HBPrinter

   LOCAL i, pi, cName

   IF ! HB_ISLOGICAL( lWait )
      lWait := .T.
   ENDIF
   IF ! HB_ISLOGICAL( lSize )
      lSize := ! lWait
   ENDIF

   ::IloscStron := Len( ::MetaFiles )
   ::nGroup := -1
   ::Page := 1
   ::AtH := {}
   ::aHS := {}
   ::aZoom := { 0, 0, 0, 0 }
   ::Scale := ::PreviewScale
   ::nPages := {}

   IF ::nWhatToPrint < 2
      ::nToPage := ::IloscStron
   ELSE
      ::nToPage := Min( ::IloscStron, ::nToPage )
   ENDIF

   IF ! ::PreviewMode
      RETURN NIL
   ENDIF

   FOR pi := 1 TO ::IloscStron
      AAdd( ::nPages, PadL( pi, 4 ) )
   NEXT pi

   AAdd( ::aHS, { 0, 0, 0, 0, 0, 0, 0 } )
   IF ::PreviewRect[ 3 ] > 0 .AND. ::PreviewRect[ 4 ] > 0
      ::aHS[ 1, 1 ] := ::PreviewRect[ 1 ]
      ::aHS[ 1, 2 ] := ::PreviewRect[ 2 ]
      ::aHS[ 1, 3 ] := ::PreviewRect[ 3 ]
      ::aHS[ 1, 4 ] := ::PreviewRect[ 4 ]
      ::aHS[ 1, 5 ] := ::PreviewRect[ 3 ] - ::PreviewRect[ 1 ] + 1
      ::aHS[ 1, 6 ] := ::PreviewRect[ 4 ] - ::PreviewRect[ 2 ] + 1
   ELSE
      RR_GetDesktopArea( ::aHS[ 1 ] )
      ::aHS[ 1, 1 ] += 10
      ::aHS[ 1, 2 ] += 10
      ::aHS[ 1, 3 ] -= 10
      ::aHS[ 1, 4 ] -= 10
      ::aHS[ 1, 5 ] := ::aHS[ 1, 3 ] - ::aHS[ 1, 1 ] + 1
      ::aHS[ 1, 6 ] := ::aHS[ 1, 4 ] - ::aHS[ 1, 2 ] + 1
   ENDIF

   IF lSize
      IF lWait
         DEFINE WINDOW 0 OBJ ::oWinPreview ;
            AT ::aHS[ 1, 1 ], ::aHS[ 1, 1 ] ;
            WIDTH ::aHS[ 1, 6 ] ;
            HEIGHT ::aHS[ 1, 5 ] ;
            TITLE ::aOpisy[ 1 ] ;
            ICON 'ZZZ_PRINTICON' ;
            MODAL ;
            ON SIZE ::PrevAdjust()
      ELSE
         DEFINE WINDOW 0 OBJ ::oWinPreview ;
            PARENT ( cParent ) ;
            AT ::aHS[ 1, 1 ], ::aHS[ 1, 1 ] ;
            WIDTH ::aHS[ 1, 6 ] ;
            HEIGHT ::aHS[ 1, 5 ] ;
            TITLE ::aOpisy[ 1 ] ;
            ICON 'ZZZ_PRINTICON' ;
            ON SIZE ::PrevAdjust() ;
            ON RELEASE ::CleanOnPrevClose()
      ENDIF
   ELSE
      IF lWait
         DEFINE WINDOW 0 OBJ ::oWinPreview ;
            AT ::aHS[ 1, 1 ], ::aHS[ 1, 1 ] ;
            WIDTH ::aHS[ 1, 6 ] ;
            HEIGHT ::aHS[ 1, 5 ] ;
            TITLE ::aOpisy[ 1 ] ;
            ICON 'ZZZ_PRINTICON' ;
            MODAL ;
            NOSIZE
      ELSE
         DEFINE WINDOW 0 OBJ ::oWinPreview ;
            PARENT ( cParent ) ;
            AT ::aHS[ 1, 1 ], ::aHS[ 1, 1 ] ;
            WIDTH ::aHS[ 1, 6 ] ;
            HEIGHT ::aHS[ 1, 5 ] ;
            TITLE ::aOpisy[ 1 ] ;
            ICON 'ZZZ_PRINTICON' ;
            NOSIZE ;
            ON RELEASE ::CleanOnPrevClose()
      ENDIF
   ENDIF

/*
   DEFINE WINDOW 0 OBJ ::oWinPreview ;
*/
      ON KEY ESCAPE      OF ( ::oWinPreview ) ACTION ::PrevClose( .T. )
      ON KEY ADD         OF ( ::oWinPreview ) ACTION ( ::Scale *= 1.25, ::PrevShow() )
      ON KEY SUBTRACT    OF ( ::oWinPreview ) ACTION ( ::Scale /= 1.25, ::PrevShow() )
      ON KEY CONTROL + P OF ( ::oWinPreview ) ACTION ( ::PrevPrint(), iif( ::ClsPreview, ::PrevClose( .F. ), NIL ) )
      ON KEY PRIOR       OF ( ::oWinPreview ) ACTION ( ::Page := iif( ::Page == 1, 1, ::Page - 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
      ON KEY NEXT        OF ( ::oWinPreview ) ACTION ( ::Page := iif( ::Page == ::IloscStron, ::Page, ::Page + 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )

      DEFINE STATUSBAR
         STATUSITEM ::aOpisy[ 15 ] + " " + AllTrim( Str( ::Page ) ) WIDTH 100
         STATUSITEM ::aOpisy[ 16 ] WIDTH 200 ICON 'ZZZ_PRINTICON' ACTION ::PrevPrint( ::Page ) RAISED
         STATUSITEM ::aOpisy[ 17 ] + " " + AllTrim( Str( ::IloscStron ) ) WIDTH 100
      END STATUSBAR

      @ 15, ::aHS[ 1, 6 ] - 150 LABEL prl VALUE ::aOpisy[ 12 ] WIDTH 80 HEIGHT 18 SIZE 8 TRANSPARENT
      @ 13, ::aHS[ 1, 6 ] - 77 COMBOBOX combo_1 ITEMS ::nPages VALUE 1 WIDTH 58 SIZE 8 ;
         ON CHANGE {|| ::Page := ::oWinPreview:combo_1:value, ::PrevShow(), ::oWinPagePreview:setfocus() }

      DEFINE SPLITBOX
         DEFINE TOOLBAR TB1 BUTTONSIZE iif( hb_osisWin10(), 56, 50 ), 37 SIZE 8 FLAT BREAK
            BUTTON B1 CAPTION ::aOpisy[ 02 ] PICTURE 'hbprint_close' ACTION ::PrevClose( .T. )
            BUTTON B2 CAPTION ::aOpisy[ 03 ] PICTURE 'hbprint_print' ACTION ( ::PrevPrint(), iif( ::ClsPreview, ::PrevClose( .F. ), NIL ) )
            IF ! ::NoButtonSave
               BUTTON B3 CAPTION ::aOpisy[ 04 ] PICTURE 'hbprint_save' WHOLEDROPDOWN SEPARATOR
               DEFINE DROPDOWN MENU BUTTON B3
                  ITEM ::aOpisy[ 04 ] ACTION ::SaveMetaFiles( ::Page )
                  ITEM ::aOpisy[ 33 ] ACTION { |pi| pi := PutFile( { { ::aOpisy[ 35 ], '*.emf' }, { ::aOpisy[ 36 ], '*.*' } }, NIL, GetStartUpFolder(), .T., ::DocName ), iif( Empty( pi ), NIL, ::SaveMetaFiles( ::Page, pi ) ) }
                  ITEM ::aOpisy[ 34 ] ACTION ::SaveMetaFiles()
              END MENU
            ENDIF
            IF ::IloscStron > 1
               BUTTON B4 CAPTION ::aOpisy[ 05 ] PICTURE 'hbprint_top' ACTION {|| ::Page := 1, ::oWinPreview:combo_1:value := ::Page, ::PrevShow() }
               BUTTON B5 CAPTION ::aOpisy[ 06 ] PICTURE 'hbprint_back' ACTION {|| ::Page := iif( ::Page == 1, 1, ::Page - 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() }
               BUTTON B6 CAPTION ::aOpisy[ 07 ] PICTURE 'hbprint_next' ACTION {|| ::Page := iif( ::Page == ::IloscStron, ::Page, ::Page + 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() }
               BUTTON B7 CAPTION ::aOpisy[ 08 ] PICTURE 'hbprint_end' ACTION {|| ::Page := ::IloscStron, ::oWinPreview:combo_1:value := ::Page, ::PrevShow() } SEPARATOR
            ENDIF
            BUTTON B8 CAPTION ::aOpisy[ 09 ] PICTURE 'hbprint_zoomin' ACTION {|| ::Scale *= 1.25, ::PrevShow() }
            IF ! ::NoButtonOptions
               BUTTON B9 CAPTION ::aOpisy[ 10 ] PICTURE 'hbprint_zoomout' ACTION {|| ::Scale /= 1.25, ::PrevShow() } SEPARATOR
               BUTTON B10 CAPTION ::aOpisy[ 11 ] PICTURE 'hbprint_option' ACTION {|| ::PrintOption() }
            ELSE
               BUTTON B9 CAPTION ::aOpisy[ 10 ] PICTURE 'hbprint_zoomout' ACTION {|| ::Scale /= 1.25, ::PrevShow() }
            ENDIF
         END TOOLBAR

         AAdd( ::aHS, { 0, 0, 0, 0, 0, 0, ::oWinPreview:hWnd } )
         RR_GetClientRect( ::aHS[ 2 ] )
         AAdd( ::aHS, { 0, 0, 0, 0, 0, 0, ::oWinPreview:TB1:hWnd } )
         RR_GetClientRect( ::aHS[ 3 ] )
         AAdd( ::aHS, { 0, 0, 0, 0, 0, 0, ::oWinPreview:StatusBar:hWnd } )
         RR_GetClientRect( ::aHS[ 4 ] )

         DEFINE WINDOW 0 OBJ ::oWinPagePreview ;
            WIDTH ::aHS[ 2, 6 ] - 15 ;
            HEIGHT ::aHS[ 2, 5 ] - ::aHS[ 3, 5 ] - ::aHS[ 4, 5 ] - 10 ;
            VIRTUAL WIDTH ::aHS[ 2, 6 ] - 5 ;
            VIRTUAL HEIGHT ::aHS[ 2, 5 ] - ::aHS[ 3, 5 ] - ::aHS[ 4, 5 ] ;
            TITLE ::aOpisy[ 13 ] ;
            SPLITCHILD ;
            GRIPPERTEXT "P" ;
            NOSYSMENU ;
            NOCAPTION ;
            ON MOUSECLICK ::oWinPagePreview:setfocus()

            ::oWinPagePreview:VScrollbar:nLineSkip := 20
            ::oWinPagePreview:HScrollbar:nLineSkip := 20
            AAdd( ::aHS, { 0, 0, 0, 0, 0, 0, ::oWinPagePreview:hWnd } )
            RR_GetClientRect( ::aHS[ 5 ] )
            @ ::aHS[ 5, 2 ] + 10, ::aHS[ 5, 1 ] + 10 IMAGE i1 PICTURE "" WIDTH ::aHS[ 5, 6 ] - 10 HEIGHT ::aHS[ 5, 5 ] - 10
            AAdd( ::aHS, { 0, 0, 0, 0, 0, 0, ::oWinPagePreview:i1:hWnd } )
            RR_GetClientRect( ::aHS[ 6 ] )

            ON KEY ESCAPE      OF ( ::oWinPagePreview ) ACTION ::PrevClose( .T. )
            ON KEY ADD         OF ( ::oWinPagePreview ) ACTION ( ::Scale *= 1.25, ::PrevShow() )
            ON KEY SUBTRACT    OF ( ::oWinPagePreview ) ACTION ( ::Scale /= 1.25, ::PrevShow() )
            ON KEY CONTROL + P OF ( ::oWinPagePreview ) ACTION ( ::PrevPrint(), iif( ::ClsPreview, ::PrevClose( .F. ), NIL ) )
            IF ::IloscStron > 1
               ON KEY PRIOR    OF ( ::oWinPagePreview ) ACTION ( ::Page := iif( ::Page == 1, 1, ::Page - 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
               ON KEY NEXT     OF ( ::oWinPagePreview ) ACTION ( ::Page := iif( ::Page == ::IloscStron, ::Page, ::Page + 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
               ON KEY END      OF ( ::oWinPagePreview ) ACTION ( ::Page := ::IloscStron, ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
               ON KEY HOME     OF ( ::oWinPagePreview ) ACTION ( ::Page := 1, ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
               ON KEY LEFT     OF ( ::oWinPagePreview ) ACTION ( ::Page := iif( ::Page == 1, 1, ::Page - 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
               ON KEY UP       OF ( ::oWinPagePreview ) ACTION ( ::Page := iif( ::Page == 1, 1, ::Page - 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
               ON KEY RIGHT    OF ( ::oWinPagePreview ) ACTION ( ::Page := iif( ::Page == ::IloscStron, ::Page, ::Page + 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
               ON KEY DOWN     OF ( ::oWinPagePreview ) ACTION ( ::Page := iif( ::Page == ::IloscStron, ::Page, ::Page + 1 ), ::oWinPreview:combo_1:value := ::Page, ::PrevShow() )
            ENDIF
         END WINDOW

         IF ::Thumbnails .AND. ::IloscStron > 1
            DEFINE WINDOW 0 OBJ ::oWinThumbs ;
               WIDTH ::aHS[ 2, 6 ] - 15 ;
               HEIGHT ::aHS[ 2, 5 ] - ::aHS[ 3, 5 ] - ::aHS[ 4, 5 ] - 10 ;
               TITLE ::aOpisy[ 14 ] ;
               SPLITCHILD ;
               GRIPPERTEXT "T"

               AAdd( ::aHS, { 0, 0, 0, 0, 0, 0, ::oWinThumbs:hWnd } )
               RR_GetClientRect( ::aHS[ 7 ] )
               ::dx := ( ::aHS[ 5, 6 ] - 20 ) / 5 - 5
               ::dy := ::aHS[ 5, 5 ] / 3 - 5
               FOR i := 1 TO 15
                  AAdd( ::AtH, { 0, 0, 0, 0, 0 } )
                  IF ::MetaFiles[ 1, 2 ] >= ::MetaFiles[ 1, 3 ]
                     ::AtH[ i, 3 ] := ::dy - 5
                     ::AtH[ i, 4 ] := ::dx * ::MetaFiles[ 1, 3 ] / ::MetaFiles[ 1, 2 ] - 5
                  ELSE
                     ::AtH[ i, 4 ] := ::dx - 5
                     ::AtH[ i, 3 ] := ::dy * ::MetaFiles[ 1, 2 ] / ::MetaFiles[ 1, 3 ] - 5
                  ENDIF
                  ::AtH[ i, 1 ] := Int( ( i - 1 ) / 5 ) * ::dy + 5
                  ::AtH[ i, 2 ] := ( ( i - 1 ) % 5 ) * ::dx + 5
               NEXT
               @ ::AtH[ 1, 1 ], ::AtH[ 1, 2 ] IMAGE it1 PICTURE "" ACTION {|| ::PrevThumb( 1 ) } WIDTH ::AtH[ 1, 4 ] HEIGHT ::AtH[ 1, 3 ]
               @ ::AtH[ 2, 1 ], ::AtH[ 2, 2 ] IMAGE it2 PICTURE "" ACTION {|| ::PrevThumb( 2 ) } WIDTH ::AtH[ 2, 4 ] HEIGHT ::AtH[ 2, 3 ]
               @ ::AtH[ 3, 1 ], ::AtH[ 3, 2 ] IMAGE it3 PICTURE "" ACTION {|| ::PrevThumb( 3 ) } WIDTH ::AtH[ 3, 4 ] HEIGHT ::AtH[ 3, 3 ]
               @ ::AtH[ 4, 1 ], ::AtH[ 4, 2 ] IMAGE it4 PICTURE "" ACTION {|| ::PrevThumb( 4 ) } WIDTH ::AtH[ 4, 4 ] HEIGHT ::AtH[ 4, 3 ]
               @ ::AtH[ 5, 1 ], ::AtH[ 5, 2 ] IMAGE it5 PICTURE "" ACTION {|| ::PrevThumb( 5 ) } WIDTH ::AtH[ 5, 4 ] HEIGHT ::AtH[ 5, 3 ]
               @ ::AtH[ 6, 1 ], ::AtH[ 6, 2 ] IMAGE it6 PICTURE "" ACTION {|| ::PrevThumb( 6 ) } WIDTH ::AtH[ 6, 4 ] HEIGHT ::AtH[ 6, 3 ]
               @ ::AtH[ 7, 1 ], ::AtH[ 7, 2 ] IMAGE it7 PICTURE "" ACTION {|| ::PrevThumb( 7 ) } WIDTH ::AtH[ 7, 4 ] HEIGHT ::AtH[ 7, 3 ]
               @ ::AtH[ 8, 1 ], ::AtH[ 8, 2 ] IMAGE it8 PICTURE "" ACTION {|| ::PrevThumb( 8 ) } WIDTH ::AtH[ 8, 4 ] HEIGHT ::AtH[ 8, 3 ]
               @ ::AtH[ 9, 1 ], ::AtH[ 9, 2 ] IMAGE it9 PICTURE "" ACTION {|| ::PrevThumb( 9 ) } WIDTH ::AtH[ 9, 4 ] HEIGHT ::AtH[ 9, 3 ]
               @ ::AtH[ 10, 1 ], ::AtH[ 10, 2 ] IMAGE it10 PICTURE "" ACTION {|| ::PrevThumb( 10 ) } WIDTH ::AtH[ 10, 4 ] HEIGHT ::AtH[ 10, 3 ]
               @ ::AtH[ 11, 1 ], ::AtH[ 11, 2 ] IMAGE it11 PICTURE "" ACTION {|| ::PrevThumb( 11 ) } WIDTH ::AtH[ 11, 4 ] HEIGHT ::AtH[ 11, 3 ]
               @ ::AtH[ 12, 1 ], ::AtH[ 12, 2 ] IMAGE it12 PICTURE "" ACTION {|| ::PrevThumb( 12 ) } WIDTH ::AtH[ 12, 4 ] HEIGHT ::AtH[ 12, 3 ]
               @ ::AtH[ 13, 1 ], ::AtH[ 13, 2 ] IMAGE it13 PICTURE "" ACTION {|| ::PrevThumb( 13 ) } WIDTH ::AtH[ 13, 4 ] HEIGHT ::AtH[ 13, 3 ]
               @ ::AtH[ 14, 1 ], ::AtH[ 14, 2 ] IMAGE it14 PICTURE "" ACTION {|| ::PrevThumb( 14 ) } WIDTH ::AtH[ 14, 4 ] HEIGHT ::AtH[ 14, 3 ]
               @ ::AtH[ 15, 1 ], ::AtH[ 15, 2 ] IMAGE it15 PICTURE "" ACTION {|| ::PrevThumb( 15 ) } WIDTH ::AtH[ 15, 4 ] HEIGHT ::AtH[ 15, 3 ]

               cName := ::oWinThumbs:Name
               FOR i := 1 TO 15
                  ::AtH[ i, 5 ] := GetControlHandle( "it" + AllTrim( Str( i ) ), cName )
                  RR_PlayThumb( ::AtH[ i ], ::MetaFiles[ i ], AllTrim( Str( i ) ), i, ::hData )
                  IF i >= ::IloscStron
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrevAdjust() CLASS HBPrinter

   ::oWinPreview:prl:col := ::oWinPreview:width - 150
   ::oWinPreview:combo_1:col := ::oWinPreview:width - 77

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrevClose( lEsc ) CLASS HBPrinter

   ::lEscaped := lEsc
   ::oWinPreview:Release()

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD CleanOnPrevClose() CLASS HBPrinter

   ::oWinPagePreview:Release()
   IF ::IloscStron > 1 .AND. ::Thumbnails
      ::oWinThumbs:Release()
   ENDIF
   ::oWinPagePreview := NIL
   ::oWinThumbs := NIL
   ::oWinPreview := NIL

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD PrintOption() CLASS HBPrinter

   LOCAL nLen := Len( LTrim( Str( ::IloscStron ) ) ), oFrom, oTo, oCopies, oWinPrOpt

   DEFINE WINDOW 0 OBJ oWinPrOpt ;
      AT 270, 346 ;
      WIDTH 390 HEIGHT 150 ;
      CLIENTAREA ;
      TITLE ::aOpisy[ 19 ] ;
      ICON 'ZZZ_PRINTICON' ;
      MODAL ;
      NOSIZE

      @ 002, 005 FRAME PrOptFrame WIDTH 380 HEIGHT 133

      @ 020, 010 LABEL label_11 WIDTH 120 HEIGHT 21 VALUE ::aOpisy[ 20 ] BOLD VCENTERALIGN
      @ 020, 135 TEXTBOX textFrom OBJ oFrom WIDTH 33 HEIGHT 21 NUMERIC MAXLENGTH nLen RIGHTALIGN ;
         VALUE Max( ::nFromPage, 1 ) VALID oFrom:Value > 0 .AND. oFrom:Value <= oTo:Value
      @ 020, 173 LABEL label_12 WIDTH 40 HEIGHT 21 VALUE ::aOpisy[ 21 ] BOLD CENTERALIGN VCENTERALIGN
      @ 020, 218 TEXTBOX textTo OBJ oTo WIDTH 33 HEIGHT 21 NUMERIC MAXLENGTH nLen RIGHTALIGN ;
         VALUE ::nToPage VALID oTo:Value >= oFrom:Value .AND. oTo:Value <= ::nToPage

      @ 020, 260 LABEL label_18 WIDTH 80 HEIGHT 21 VALUE ::aOpisy[ 22 ] BOLD VCENTERALIGN
      @ 020, 350 TEXTBOX textCopies OBJ oCopies WIDTH 30 HEIGHT 21 NUMERIC MAXLENGTH 6 RIGHTALIGN ;
         VALUE ::nCopies VALID oCopies:Value > 0
      @ 060, 010 LABEL label_13 WIDTH 100 HEIGHT 21 VALUE ::aOpisy[ 23 ] BOLD VCENTERALIGN
      @ 060, 115 COMBOBOX prnCombo WIDTH 265 VALUE ::PrintOpt ITEMS { ::aOpisy[ 24 ], ::aOpisy[ 25 ], ::aOpisy[ 26 ], ::aOpisy[ 27 ], ::aOpisy[ 28 ] }

      @ 100, 160 BUTTON button_14 WIDTH 95 HEIGHT 24 CAPTION "&OK" ;
         ACTION {|| ::nFromPage := oWinPrOpt:textFrom:Value, ;
         ::nToPage := oWinPrOpt:textTo:Value, ;
         ::nCopies := Max( oWinPrOpt:textCopies:Value, 1 ), ;
         ::PrintOpt := oWinPrOpt:prnCombo:Value, ;
         oWinPrOpt:Release() }

      @ 100, 285 BUTTON button_15 CAPTION ::aOpisy[ 02 ] ;
         ACTION oWinPrOpt:Release() ;
         WIDTH 95 HEIGHT 24

      ON KEY ESCAPE ACTION oWinPrOpt:Release()
   END WINDOW

   oWinPrOpt:Activate( .F. )

   RETURN .T.
#endif /* NO_GUI */

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
      /* Note: pDevMode->dmDeviceName is limited to 32 characters.
       * if the printer name is greater than 32, like network printers,
       * the RR_GetDC() function return a null handle. So, I'm using
       * pDevNames instead of pDevMode.
       * strcpy( lpData->PrinterName, pDevMode->dmDeviceName );
       */
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
HB_FUNC( RR_SETUSERMODE )
{
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 4 );
   DWORD what = hb_parnl( 1 );

   if( what == ( lpData->pi2->pDevMode->dmFields & what ) )
   {
      lpData->pi2->pDevMode->dmFields      = lpData->pi2->pDevMode->dmFields | DM_PAPERSIZE | DM_PAPERWIDTH | DM_PAPERLENGTH;
      lpData->pi2->pDevMode->dmPaperSize   = DMPAPER_USER;
      lpData->pi2->pDevMode->dmPaperWidth  = ( SHORT ) hb_parnl( 2 );
      lpData->pi2->pDevMode->dmPaperLength = ( SHORT ) hb_parnl( 3 );
   }

   DocumentProperties( NULL, lpData->hPrinter, lpData->PrinterName, lpData->pi2->pDevMode, lpData->pi2->pDevMode, DM_IN_BUFFER | DM_OUT_BUFFER );
   SetPrinter( lpData->hPrinter, 2, ( LPBYTE ) lpData->pi2, 0 );
   ResetDC( lpData->hDCRef, lpData->pi2->pDevMode );
   HB_RETNL( ( LONG_PTR ) lpData->hDCRef);
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
      w = ( LONG ) sSize.cx; /* text width */
      h = ( LONG ) sSize.cy; /* text height */

      /* Center text vertically within rectangle */
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
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
HB_FUNC( RR_DRAWPICTURE )          /* RR_DrawPicture( cpicture, lp1, lp2, lp3, lImageSize, ::hData ) -> lSuccess */
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
   BOOL bRet = TRUE;

   if( ! hb_parclen( 1 ) )
   {
      hb_retl( FALSE );
      return;
   }
   ipic = ( IPicture * ) RR_LoadPicture( ( const CHAR * ) hb_parc( 1 ), &lwidth, &lheight );
   if( ! ipic )
   {
      ipic = ( IPicture * ) RR_LoadPictureFromResource( ( const CHAR * ) hb_parc( 1 ), &lwidth, &lheight );
   }
   if( ! ipic )
   {
      hb_retl( FALSE );
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
         if( ipic->lpVtbl->Render( ipic, lpData->hDC, x, y, dc, dr, 0, lheight, lwidth, -lheight, &lrect ) != S_OK )
         {
            bRet = FALSE;
         }
         y += dr;
      }
      y = r;
      x += dc;
   }
   ipic->lpVtbl->Release( ipic );
   SelectClipRgn( lpData->hDC, lpData->hrgn );
   DeleteObject( hrgn1 );
   hb_retl( bRet );
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
HB_FUNC( RR_GETDESKTOPAREA )
{
   RECT rect;

   SystemParametersInfo( SPI_GETWORKAREA, 1, &rect, 0 );

   HB_STORNI( rect.top, 1, 1 );
   HB_STORNI( rect.left, 1, 2 );
   HB_STORNI( rect.bottom, 1, 3 );
   HB_STORNI( rect.right, 1, 4 );
   HB_STORNI( rect.bottom - rect.top + 1, 1, 5 );
   HB_STORNI( rect.right - rect.left + 1, 1, 6 );
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_GETPIXELCOLOR )          /* FUNCTION _OOHG_GetPixelColor( hBitmap, row, col ) -> nColor */
{
   int x, y;
   HDC memDC;
   COLORREF color;
   HBITMAP hOld;
   HBITMAP hBmp = ( HBITMAP ) HWNDparam( 1 );

   if( hBmp )
   {
      x = hb_parni( 2 );
      y = hb_parni( 3 );
      memDC = CreateCompatibleDC( NULL );
      hOld = SelectObject( memDC, hBmp );
      color = GetPixel( memDC, x, y );
      SelectObject( memDC, hOld );
      DeleteDC( memDC );
   }
   else
   {
      color = -1;
   }
   hb_retnl( ( LONG ) color );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RR_DRAWBITMAP )          /* FUNCTION RR_DrawBitMap( hBitmap, lp1, lp2, lp3, lImageSize, hData ) -> lSuccess */
{
   HBITMAP hBitmap = ( HBITMAP ) HWNDparam( 1 );
   INT r = HB_PARNI( 2, 1 );
   INT c = HB_PARNI( 2, 2 );
   INT dr = HB_PARNI( 3, 1 );
   INT dc = HB_PARNI( 3, 2 );
   INT tor = HB_PARNI( 4, 1 );
   INT toc = HB_PARNI( 4, 2 );
   BOOL bImageSize = hb_parl( 5 );
   LPHBPRINTERDATA lpData = ( HBPRINTERDATA * ) HB_PARNL( 6 );
   INT x, y, xe, ye;
   LONG lwidth = 0;
   LONG lheight = 0;
   RECT lrect;
   HRGN hrgn1;
   POINT lpp;
   INT lw, lh;
   PICTDESC picd;
   IPicture * iPicture;
   IPicture ** iPictureRef = &iPicture;
   BOOL bRet = TRUE;

   if( ! hBitmap )
   {
      hb_retl( FALSE );
      return;
   }
   picd.cbSizeofstruct = sizeof( PICTDESC );
   picd.picType = PICTYPE_BITMAP;
   picd.bmp.hbitmap = hBitmap;
   if( OleCreatePictureIndirect( &picd, &IID_IPicture, FALSE, ( LPVOID * ) iPictureRef ) != S_OK )
   {
      hb_retl( FALSE );
      return;
   }
   iPicture->lpVtbl->get_Width( iPicture, &lwidth );
   iPicture->lpVtbl->get_Height( iPicture, &lheight );
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
         SetRect( &lrect, x, y, dc + x, dr + y );
         if( iPicture->lpVtbl->Render( iPicture, lpData->hDC, x, y, dc, dr, 0, lheight, lwidth, -lheight, &lrect ) != S_OK )
         {
            bRet = FALSE;
         }
         y += dr;
}
      y = r;
      x += dc;
   }

   iPicture->lpVtbl->Release( iPicture );
   SelectClipRgn( lpData->hDC, lpData->hrgn );
   DeleteObject( hrgn1 );
   hb_retl( bRet );
}

#pragma ENDDUMP
