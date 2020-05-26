/*
 * $Id: miniprint.prg $
 */
/*
 * ooHG source code:
 * MINIPRINT printing library
 *
 * Copyright 2006-2019 Ciro Vargas C. <cvc@oohg.org> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Based upon:
 * HBPRINT and HBPRINTER libraries
 * Copyright 2002 Richard Rylko <rrylko@poczta.onet.pl>
 * http://rrylko.republika.pl
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
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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


#include "oohg.ch"
#include "miniprint.ch"

#define WM_CLOSE     0x0010
#define SB_HORZ      0
#define SB_VERT      1
#define WM_VSCROLL   0x0115

DECLARE WINDOW _HMG_PRINTER_PPNAV
DECLARE WINDOW _HMG_PRINTER_SHOWPREVIEW

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_ShowPreview( cParent, lWait, lSize )

   LOCAL tHeight, tFactor, tvHeight, icb, oSep

   IF _HMG_PRINTER_hdcPrint == 0
      RETURN
   ENDIF

   _HMG_PRINTER_BasePageName := GetTempFolder() + "\" + _HMG_PRINTER_TimeStamp + "_HMG_print_preview_"
   _HMG_PRINTER_CurrentPageNumber := 1
   _HMG_PRINTER_Dx := 0
   _HMG_PRINTER_Dy := 0
   _HMG_PRINTER_Dz := 0
   _HMG_PRINTER_ScrollStep := 10
   _HMG_PRINTER_ZoomClick_xOffset := 0
   _HMG_PRINTER_ThumbUpdate := .T.
   _HMG_PRINTER_PrevPageNumber := 0

   IF _IsWindowDefined( "_HMG_PRINTER_SHOWPREVIEW" )
      RETURN
   ENDIF

   icb := SetInteractiveClose()

   SET INTERACTIVECLOSE ON

   _HMG_PRINTER_SizeFactor := GetDesktopRealHeight() / _HMG_PRINTER_GetPageHeight( _HMG_PRINTER_hdcPrint ) * 0.63

   ASSIGN lWait VALUE lWait TYPE "L" DEFAULT .T.
   ASSIGN lSize VALUE lSize TYPE "L" DEFAULT .T.

   IF lSize
      IF lWait
         DEFINE WINDOW _HMG_PRINTER_AUXIL ;
            TITLE _HMG_PRINTER_UserMessages[ 02 ] + '. ' + _HMG_PRINTER_UserMessages[ 01 ] + ' [' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ) + '/'+ AllTrim( Str(_HMG_PRINTER_PageCount ) ) + ']' ;
            CHILD ;
            AT 0, 0 ;
            WIDTH GetDesktopRealWidth() - 123 ;
            HEIGHT GetDesktopRealHeight() - 123 ;
            ON MOUSECLICK ( iif( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ) ) ;
            ON RELEASE _HMG_PRINTER_PreviewClose() ;
            ON PAINT _HMG_PRINTER_SHOWPREVIEW.SetFocus()
      ELSE
         DEFINE WINDOW _HMG_PRINTER_AUXIL ;
            TITLE _HMG_PRINTER_UserMessages[ 02 ] + '. ' + _HMG_PRINTER_UserMessages[ 01 ] + ' [' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ) + '/'+ AllTrim( Str(_HMG_PRINTER_PageCount ) ) + ']' ;
            PARENT ( cParent ) ;
            AT 0, 0 ;
            WIDTH GetDesktopRealWidth() - 123 ;
            HEIGHT GetDesktopRealHeight() - 123 ;
            ON MOUSECLICK ( iif( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ) ) ;
            ON RELEASE _HMG_PRINTER_PreviewClose() ;
            ON PAINT _HMG_PRINTER_SHOWPREVIEW.SetFocus()
      ENDIF
   ELSE
      IF lWait
         DEFINE WINDOW _HMG_PRINTER_AUXIL ;
            TITLE _HMG_PRINTER_UserMessages[ 02 ] + '. ' + _HMG_PRINTER_UserMessages[ 01 ] + ' [' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ) + '/'+ AllTrim( Str(_HMG_PRINTER_PageCount ) ) + ']' ;
            CHILD ;
            AT 0, 0 ;
            WIDTH GetDesktopRealWidth() - 123 ;
            HEIGHT GetDesktopRealHeight() - 123 ;
            ON MOUSECLICK ( iif( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ) ) ;
            ON RELEASE _HMG_PRINTER_PreviewClose() ;
            ON PAINT _HMG_PRINTER_SHOWPREVIEW.SetFocus() ;
            NOSIZE
      ELSE
         DEFINE WINDOW _HMG_PRINTER_AUXIL ;
            TITLE _HMG_PRINTER_UserMessages[ 02 ] + '. ' + _HMG_PRINTER_UserMessages[ 01 ] + ' [' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ) + '/'+ AllTrim( Str(_HMG_PRINTER_PageCount ) ) + ']' ;
            PARENT ( cParent ) ;
            AT 0, 0 ;
            WIDTH GetDesktopRealWidth() - 123 ;
            HEIGHT GetDesktopRealHeight() - 123 ;
            ON MOUSECLICK ( iif( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ) ) ;
            ON RELEASE _HMG_PRINTER_PreviewClose() ;
            ON PAINT _HMG_PRINTER_SHOWPREVIEW.SetFocus() ;
            NOSIZE
      ENDIF
   ENDIF

      DEFINE WINDOW _HMG_PRINTER_PPNAV HEIGHT 35 WIDTH 100 INTERNAL

         @ 2, 2 BUTTON b1 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_TOP" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 03 ] ;
            ACTION( _HMG_PRINTER_CurrentPageNumber := 1, _HMG_PRINTER_PreviewRefresh() )

         @ 2, 32 BUTTON b2 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_BACK" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 04 ] ;
            ACTION( _HMG_PRINTER_CurrentPageNumber--, _HMG_PRINTER_PreviewRefresh() )

         @ 2, 62 BUTTON b3 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_NEXT" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 05 ] ;
            ACTION( _HMG_PRINTER_CurrentPageNumber++, _HMG_PRINTER_PreviewRefresh() )

         @ 2, 92 BUTTON b4 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_END" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 06 ] ;
            ACTION( _HMG_PRINTER_CurrentPageNumber := _HMG_PRINTER_PageCount, _HMG_PRINTER_PreviewRefresh() )

         @ 2, 126 CHECKBUTTON thumbswitch ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_THUMBNAIL" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 28 ] + ' [Ctrl+T]' ;
            ON CHANGE _HMG_PRINTER_ProcessThumbnails()

         @ 2, 156 CHECKBUTTON b5 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_ZOOM" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 08 ] + ' [*]' ;
            ON CHANGE _HMG_PRINTER_MouseZoom()

         @ 2, 186 BUTTON b12 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_PRINT" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 09 ] + ' [Ctrl+P]' ;
            ACTION _HMG_PRINTER_PrintPages()

      IF ! _HMG_PRINTER_NoSaveButton
         @ 2, 216 BUTTON b7 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_SAVE" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 27 ] + ' [Ctrl+S]' ;
            ACTION _HMG_PRINTER_SavePages()
      ENDIF

         @ 2, 246 BUTTON b6 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_CLOSE" ;
            TOOLTIP _HMG_PRINTER_UserMessages[ 26 ] + ' [Ctrl+C]' ;
            ACTION _HMG_PRINTER_PreviewClose()

         @ 15, 291 LABEL lbl_1 VALUE _HMG_PRINTER_UserMessages[ 07 ] AUTOSIZE

         @ 8, 400 TEXTBOX page PICTURE '999999' NUMERIC WIDTH 75 VALUE _HMG_PRINTER_CurrentPageNumber IMAGE "HP_GOPAGE" ;
            ACTION ( _HMG_PRINTER_PPNAV.page.Value := iif( _HMG_PRINTER_PPNAV.page.Value < 1, 1, _HMG_PRINTER_PPNAV.page.Value ), ;
                     _HMG_PRINTER_PPNAV.page.Value := iif( _HMG_PRINTER_PPNAV.page.Value > _HMG_PRINTER_PageCount, _HMG_PRINTER_PageCount, _HMG_PRINTER_PPNAV.page.Value ), ;
                     _HMG_PRINTER_CurrentPageNumber := _HMG_PRINTER_PPNAV.page.Value, _HMG_PRINTER_SHOWPREVIEW.Show() )

         @ 15, 500 LABEL lbl_2 VALUE 'Zoom' AUTOSIZE

         @ 8, 550 TEXTBOX zoom PICTURE '99.99' NUMERIC WIDTH 75 VALUE _HMG_PRINTER_Dz / 200 IMAGE "HP_ZOOM" ;
            ACTION ( _HMG_PRINTER_Dz := _HMG_PRINTER_PPNAV.zoom.Value * 200, ;
                     _HMG_PRINTER_SHOWPREVIEW.Show() )
      END WINDOW

      _HMG_PRINTER_PPNAV.ClientAdjust := 1

      DEFINE WINDOW _HMG_PRINTER_SHOWPREVIEW ;
         AT 0, 0 ;
         WIDTH GetDesktopRealWidth() - 123 ;
         HEIGHT GetDesktopRealHeight() - 123 ;
         VIRTUAL WIDTH GetDesktopRealWidth() - 55 ;
         VIRTUAL HEIGHT GetDesktopRealHeight() - 112 ;
         INTERNAL ;
         CURSOR "HP_GLASS" ;
         ON PAINT _HMG_PRINTER_PreviewRefresh() ;
         BACKCOLOR GRAY ;
         ON MOUSECLICK iif( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ) ;
         ON SCROLLUP    _HMG_PRINTER_ScrolluP() ;
         ON SCROLLDOWN  _HMG_PRINTER_ScrollDown() ;
         ON SCROLLLEFT  _HMG_PRINTER_ScrollLeft() ;
         ON SCROLLRIGHT _HMG_PRINTER_ScrollRight() ;
         ON HSCROLLBOX  _HMG_PRINTER_HScrollBoxProcess() ;
         ON VSCROLLBOX  _HMG_PRINTER_VScrollBoxProcess()

         ON KEY HOME         ACTION ( _HMG_PRINTER_CurrentPageNumber := 1, _HMG_PRINTER_PreviewRefresh() )
         ON KEY PRIOR        ACTION ( _HMG_PRINTER_CurrentPageNumber--, _HMG_PRINTER_PreviewRefresh() )
         ON KEY NEXT         ACTION ( _HMG_PRINTER_CurrentPageNumber++, _HMG_PRINTER_PreviewRefresh() )
         ON KEY END          ACTION ( _HMG_PRINTER_CurrentPageNumber := _HMG_PRINTER_PageCount, _HMG_PRINTER_PreviewRefresh() )
         ON KEY CONTROL+P    ACTION _HMG_PRINTER_PrintPages()
         ON KEY ESCAPE       ACTION _HMG_PRINTER_PreviewClose()
         ON KEY MULTIPLY     ACTION ( iif( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ), _HMG_PRINTER_Zoom() )
         ON KEY CONTROL+C    ACTION _HMG_PRINTER_PreviewClose()
         ON KEY ALT + F4     ACTION _HMG_PRINTER_PreviewClose()
      IF ! _HMG_PRINTER_NoSaveButton
         ON KEY CONTROL+S    ACTION _HMG_PRINTER_SavePages()
      ENDIF
         ON KEY CONTROL+T    ACTION _HMG_PRINTER_ThumbnailToggle()

         _HMG_PRINTER_SHOWPREVIEW.ClientAdjust := 5
      END WINDOW

      IF _HMG_PRINTER_GetPageHeight( _HMG_PRINTER_hdcPrint ) > _HMG_PRINTER_GetPageWidth( _HMG_PRINTER_hdcPrint )
         tFactor := 0.44
      ELSE
         tFactor := 0.26
      ENDIF

      tHeight := _HMG_PRINTER_GetPageHeight( _HMG_PRINTER_hdcPrint ) * tFactor

      tHeight := Int( tHeight )

      tvHeight := ( _HMG_PRINTER_PageCount * ( tHeight + 10 ) ) + GetHScrollBarHeight() + GetTitleHeight() + ( GetBorderHeight() * 2 ) + 7

      IF tvHeight <= GetDesktopRealHeight() - 103
         _HMG_PRINTER_ThumbScroll := .F.
         tvHeight := GetDesktopRealHeight() - 102
      ELSE
         _HMG_PRINTER_ThumbScroll := .T.
      ENDIF

      DEFINE WINDOW _HMG_PRINTER_SHOWTHUMBNAILS INTERNAL ;
         WIDTH 130 ;
         VIRTUAL WIDTH 130 ;
         VIRTUAL HEIGHT tvHeight ;
         TITLE _HMG_PRINTER_UserMessages[ 28 ] ;
         BACKCOLOR { 100, 100, 100 }
      END WINDOW

      _HMG_PRINTER_SHOWTHUMBNAILS.ClientAdjust := 3
      _HMG_PRINTER_SHOWTHUMBNAILS.Hide()

      @ 0, 0 LABEL _lsep OBJ oSep WIDTH 4 VALUE '' BORDER

      oSep:ClientAdjust := 3
    END WINDOW

    DEFINE WINDOW _HMG_PRINTER_WAIT AT 0, 0 WIDTH 310 HEIGHT 85 TITLE ' ' CHILD NOSHOW NOCAPTION

      DEFINE LABEL label_1
         ROW 30
         COL 5
         WIDTH 300
         HEIGHT 30
         VALUE _HMG_PRINTER_UserMessages[ 29 ]
         CENTERALIGN .T.
      END LABEL
   END WINDOW

   _HMG_PRINTER_WAIT.Center

   DEFINE WINDOW _HMG_PRINTER_PRINTPAGES ;
      AT 0, 0 ;
      WIDTH 420 ;
      HEIGHT 168 + GetTitleHeight() ;
      TITLE _HMG_PRINTER_UserMessages[ 9 ] ;
      CHILD NOSHOW ;
      NOSIZE NOSYSMENU

      ON KEY ESCAPE ACTION( HideWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) ), EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), EnableWindow( GetFormHandle( "_HMG_PRINTER_PPNAV" ) ), _HMG_PRINTER_SHOWPREVIEW.SetFocus )
      ON KEY RETURN ACTION _HMG_PRINTER_PrintPagesDo()

      DEFINE FRAME Frame_1
         ROW 5
         COL 10
         WIDTH 275
         HEIGHT 147
         FONTNAME 'Arial'
         FONTSIZE 9
         CAPTION _HMG_PRINTER_UserMessages[ 15 ]
      END FRAME

      DEFINE RADIOGROUP Radio_1
         ROW 25
         COL 20
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE 1
         OPTIONS { _HMG_PRINTER_UserMessages[ 16 ], _HMG_PRINTER_UserMessages[ 17 ] }
         ONCHANGE iif( This.Value == 1, ( _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F. ), ( _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Spinner_1.SetFocus ) )
      END RADIOGROUP

      DEFINE LABEL Label_1
         ROW 84
         COL 55
         WIDTH 50
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE _HMG_PRINTER_UserMessages[ 18 ] + ':'
      END LABEL

      DEFINE SPINNER Spinner_1
         ROW 81
         COL 110
         WIDTH 50
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE 1
         RANGEMIN 1
         RANGEMAX _HMG_PRINTER_PageCount
         DISABLED .T.
      END SPINNER

      DEFINE LABEL Label_2
         ROW 84
         COL 165
         WIDTH 35
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE _HMG_PRINTER_UserMessages[ 19 ] + ':'
      END LABEL

      DEFINE SPINNER Spinner_2
         ROW 81
         COL 205
         WIDTH 50
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE _HMG_PRINTER_PageCount
         RANGEMIN 1
         RANGEMAX _HMG_PRINTER_PageCount
         DISABLED .T.
      END SPINNER

      DEFINE LABEL Label_4
         ROW 115
         COL 55
         WIDTH 50
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE _HMG_PRINTER_UserMessages[ 09 ] + ':'
      END LABEL

      DEFINE COMBOBOX Combo_1
         ROW 113
         COL 110
         WIDTH 145
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE 1
         ITEMS { _HMG_PRINTER_UserMessages[ 21 ], _HMG_PRINTER_UserMessages[ 22 ], _HMG_PRINTER_UserMessages[ 23 ] }
         DISABLED .T.
      END COMBOBOX

      DEFINE BUTTON Ok
         ROW 10
         COL 300
         WIDTH 105
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         CAPTION _HMG_PRINTER_UserMessages[ 11 ]
         ACTION _HMG_PRINTER_PrintPagesDo()
      END BUTTON

      DEFINE BUTTON Cancel
         ROW 40
         COL 300
         WIDTH 105
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         CAPTION _HMG_PRINTER_UserMessages[ 12 ]
         ACTION( EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), EnableWindow( GetFormHandle( "_HMG_PRINTER_PPNAV" ) ), HideWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) ), _HMG_PRINTER_SHOWPREVIEW.SetFocus )
      END BUTTON

      DEFINE LABEL LABEL_3
         ROW 103
         COL 300
         WIDTH 45
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE _HMG_PRINTER_UserMessages[ 20 ] + ':'
      END LABEL

// See comment in function _HMG_PRINTER_PrintPages()
      DEFINE SPINNER SPINNER_3
         ROW 100
         COL 355
         WIDTH 50
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE _HMG_PRINTER_Copies
         RANGEMIN 1
         RANGEMAX 999
         DISABLED ( _HMG_PRINTER_Copies > 1 )
      END SPINNER

      DEFINE CHECKBOX CHECKBOX_1
         ROW 132
         COL 300
         WIDTH 110
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE ( _HMG_PRINTER_Collate == 1 )
         CAPTION _HMG_PRINTER_UserMessages[ 14 ]
         DISABLED ( _HMG_PRINTER_Copies > 1 )
      END CHECKBOX
   END WINDOW

   CENTER WINDOW _HMG_PRINTER_PRINTPAGES

   IF _HMG_PRINTER_ThumbScroll == .F.
      _HMG_PRINTER_Preview_DisableScrollBars( GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' ) )
   ENDIF

   SetScrollRange( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 0, 100, .T. )
   SetScrollRange( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 0, 100, .T. )

   SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 50, .T. )
   SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 50, .T. )

   _HMG_PRINTER_Preview_DisableHScrollBar( GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' ) )

   CENTER WINDOW _HMG_PRINTER_SHOWPREVIEW

   CENTER WINDOW _HMG_PRINTER_AUXIL

   IF lWait
      ACTIVATE WINDOW _HMG_PRINTER_AUXIL, _HMG_PRINTER_PRINTPAGES, _HMG_PRINTER_WAIT
   ELSE
      ACTIVATE WINDOW _HMG_PRINTER_AUXIL, _HMG_PRINTER_PRINTPAGES, _HMG_PRINTER_WAIT NOWAIT
   ENDIF

   SetInteractiveClose( icb )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_CreateThumbNails()

   LOCAL tFactor, tWidth, tHeight, ttHandle, i, cMacroTemp

   IF _HMG_PRINTER_hdcPrint == 0
      RETURN
   ENDIF

   IF _IsControlDefined( 'Image1', '_HMG_PRINTER_SHOWTHUMBNAILS' )
      RETURN
   ENDIF

   ShowWindow( GetFormHandle( "_HMG_PRINTER_WAIT" ) )

   IF _HMG_PRINTER_GetPageHeight( _HMG_PRINTER_hdcPrint ) > _HMG_PRINTER_GetPageWidth( _HMG_PRINTER_hdcPrint )
      tFactor := 0.44
   ELSE
      tFactor := 0.26
   ENDIF

   tWidth  := _HMG_PRINTER_GetPageWidth( _HMG_PRINTER_hdcPrint ) * tFactor
   tHeight := _HMG_PRINTER_GetPageHeight( _HMG_PRINTER_hdcPrint ) * tFactor

   tHeight := Int( tHeight )

   ttHandle := GetFormToolTipHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' )

   FOR i := 1 TO _HMG_PRINTER_PageCount
      cMacroTemp := 'Image' + AllTrim( Str( i ) )

      TImage():Define( cMacroTemp, ;
                       '_HMG_PRINTER_SHOWTHUMBNAILS', ;
                       10, ;
                       ( i * ( tHeight + 10 ) ) - tHeight, ;
                       _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf", ;
                       tWidth, ;
                       tHeight, ;
                       { || ( _HMG_PRINTER_CurrentPageNumber := i, _HMG_PRINTER_ThumbUpdate := .F., _HMG_PRINTER_PreviewRefresh(), _HMG_PRINTER_ThumbUpdate := .T. ) }, ;
                       NIL, .F., .F., .T., .F. )

      SetToolTip( GetControlHandle( cMacroTemp, '_HMG_PRINTER_SHOWTHUMBNAILS' ), _HMG_PRINTER_UserMessages[ 01 ] + ' ' + AllTrim( Str( i ) ) + ' [Click]', ttHandle )
   NEXT i

   HideWindow( GetFormHandle( "_HMG_PRINTER_WAIT" ) )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_ThumbnailToggle()

   _HMG_PRINTER_PPNAV.thumbswitch.Value := ! _HMG_PRINTER_PPNAV.thumbswitch.Value
   _HMG_PRINTER_ProcessThumbnails()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_ProcessThumbnails()

   IF _HMG_PRINTER_PPNAV.thumbswitch.Value == .T.
      _HMG_PRINTER_CreateThumbNails()
      _HMG_PRINTER_SHOWTHUMBNAILS.Show()
   ELSE
      _HMG_PRINTER_SHOWTHUMBNAILS.Hide()
   ENDIF

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_SavePages()

   LOCAL c, i, f, t, d, x, a

   IF _HMG_PRINTER_NoSaveButton
      RETURN
   ENDIF

   x := GetFolder( _HMG_PRINTER_UserMessages[ 31 ] )

   IF Empty( x )
      RETURN
   ENDIF

   IF Right( x, 1 ) != '\'
      x := x + '\'
   ENDIF

   t := GetTempFolder()

   c := ADir( t + [\] + _HMG_PRINTER_TimeStamp  + "_HMG_print_preview_*.Emf" )

   a := Array( c )

   ADir( t + [\] + _HMG_PRINTER_TimeStamp  + "_HMG_print_preview_*.Emf", a )

   FOR i := 1 TO c
      f := t + [\] + a[ i ]
      d := x + 'Harbour_MiniPrint_' + StrZero( i, 6 ) + '.Emf'
      COPY FILE ( f ) TO ( d )
   NEXT i

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_HScrollBoxProcess()

   LOCAL Sp

   Sp := GetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ )

   _HMG_PRINTER_Dx := ( 50 - Sp ) * 10

   _HMG_PRINTER_PreviewRefresh()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_VScrollBoxProcess()

   LOCAL Sp

   Sp := GetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT )

   _HMG_PRINTER_Dy := ( 50 - Sp ) * 10

   _HMG_PRINTER_PreviewRefresh()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_PreviewClose()

   IF IsWindowDefined( "_HMG_PRINTER_WAIT" )
      _HMG_PRINTER_WAIT.label_1.Value := _HMG_PRINTER_UserMessages[ 33 ]
      ShowWindow( GetFormHandle( "_HMG_PRINTER_WAIT" ) )
   ENDIF

   _HMG_PRINTER_CleanPreview()

   IF IsWindowDefined( "_HMG_PRINTER_AUXIL" )
     _HMG_PRINTER_AUXIL.Release
   ENDIF

   IF IsWindowDefined( "_HMG_PRINTER_PRINTPAGES" )
     _HMG_PRINTER_PRINTPAGES.Release
   ENDIF

   IF IsWindowDefined( "_HMG_PRINTER_WAIT" )
     _HMG_PRINTER_WAIT.Release
   ENDIF

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_CleanPreview()

   AEval( Directory( GetTempFolder() + [\] + _HMG_PRINTER_TimeStamp + "_HMG_print_preview_*.Emf" ), ;
                     { |aFile| FErase( GetTempFolder() + [\] + aFile[ 1 ] ) } )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_PreviewRefresh()

   LOCAL hwnd
   LOCAL nRow
   LOCAL nScrollMax

   IF _HMG_PRINTER_hdcPrint == 0
      RETURN
   ENDIF

   IF _IsControlDefined( 'Image' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ), '_HMG_PRINTER_SHOWTHUMBNAILS' ) .AND. _HMG_PRINTER_ThumbUpdate == .T. .AND. _HMG_PRINTER_ThumbScroll == .T.
      IF _HMG_PRINTER_PrevPageNumber != _HMG_PRINTER_CurrentPageNumber
         _HMG_PRINTER_PrevPageNumber := _HMG_PRINTER_CurrentPageNumber

         hwnd := GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' )
         nRow := GetProperty( '_HMG_PRINTER_SHOWTHUMBNAILS', 'Image' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ), 'Row' )
         nScrollMax := GetScrollRangeMax( hwnd, SB_VERT )

         IF _HMG_PRINTER_PageCount == _HMG_PRINTER_CurrentPageNumber
            IF GetScrollPos( hwnd, SB_VERT ) != nScrollMax
               _HMG_PRINTER_SetVScrollValue( hwnd, nScrollMax )
            ENDIF
         ELSEIF _HMG_PRINTER_CurrentPageNumber == 1
            IF GetScrollPos( hwnd, SB_VERT ) != 0
               _HMG_PRINTER_SetVScrollValue( hwnd, 0 )
            ENDIF
         ELSE
            IF ( nRow - 9 ) < nScrollMax
               _HMG_PRINTER_SetVScrollValue( hwnd, nRow - 9 )
            ELSE
               IF GetScrollPos( hwnd, SB_VERT ) != nScrollMax
                  _HMG_PRINTER_SetVScrollValue( hwnd, nScrollMax )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   IF _HMG_PRINTER_CurrentPageNumber < 1
      _HMG_PRINTER_PPNAV.page.Value := _HMG_PRINTER_CurrentPageNumber := 1
      PlayBeep()
      RETURN
   ENDIF

   IF _HMG_PRINTER_CurrentPageNumber > _HMG_PRINTER_PageCount
      _HMG_PRINTER_PPNAV.page.Value := _HMG_PRINTER_CurrentPageNumber := _HMG_PRINTER_PageCount
      PlayBeep()
      RETURN
   ENDIF

   _HMG_PRINTER_ShowPage( _HMG_PRINTER_BasePageName + StrZero( _HMG_PRINTER_CurrentPageNumber, 6 ) + ".emf", GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), _HMG_PRINTER_hdcPrint, _HMG_PRINTER_SizeFactor * 10000, _HMG_PRINTER_Dz, _HMG_PRINTER_Dx, _HMG_PRINTER_Dy )

   _HMG_PRINTER_AUXIL.Title := _HMG_PRINTER_UserMessages[ 02 ] + '. ' + _HMG_PRINTER_UserMessages[ 01 ] + ' [' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ) + '/' + AllTrim( Str( _HMG_PRINTER_PageCount ) ) + ']'

   _HMG_PRINTER_PPNAV.page.Value := _HMG_PRINTER_CurrentPageNumber

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_PrintPages()

   DisableWindow( GetFormHandle( "_HMG_PRINTER_PPNAV" ) )
   DisableWindow( GetFormHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
   DisableWindow( GetFormHandle( "_HMG_PRINTER_SHOWPREVIEW" ) )
   /*
   _HMG_PRINTER_Copies > 1
   The printer will print a predefined number of copies using collation if
   _HMG_PRINTER_Collate == 1.
   Only one copy must be sent to the printer.
   Spinner_3 must show the value of _HMG_PRINTER_Copies.
   CheckBox_1 must be checked only if the value of _HMG_PRINTER_Collate is 1.
   Both controls must be DISABLED.

   _HMG_PRINTER_Copies <= 1
   The printer will print only one copy even if it supports multicopy.
   The number of copies indicated by Spinner_3 must be sent to the printer in
   the order defined by CheckBox_1.
   Spinner_3 initial value must be 1.
   CheckBox_1 initial state must be checked only if the value of
   _HMG_PRINTER_Collate is 1.
   Both controls must be ENABLED.

   _HMG_PRINTER_Collate == 1
   Indicates that the printer will collate documents when printing multiples
   copies ( _HMG_PRINTER_Copies > 1 ).

   _HMG_PRINTER_Collate # 1
   Indicates that the printer will not collate documents (even if it supports
   collation) when printing multiples copies ( _HMG_PRINTER_Copies > 1 ).
   */
   _HMG_PRINTER_PRINTPAGES.Radio_1.Value := 1
   _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F.
   _HMG_PRINTER_PRINTPAGES.Spinner_3.Value := _HMG_PRINTER_Copies
   _HMG_PRINTER_PRINTPAGES.Spinner_3.Enabled := ( _HMG_PRINTER_Copies <= 1 )
   _HMG_PRINTER_PRINTPAGES.CheckBox_1.Value := ( _HMG_PRINTER_Collate == 1 )
   _HMG_PRINTER_PRINTPAGES.CheckBox_1.Enabled := ( _HMG_PRINTER_Copies <= 1 )

   ShowWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_PrintPagesDo( cLang )

   LOCAL i
   LOCAL PageFrom
   LOCAL PageTo
   LOCAL p
   LOCAL OddOnly := .F.
   LOCAL EvenOnly := .F.
   LOCAL nCopies

   IF _HMG_PRINTER_hdcPrint == 0
      RETURN
   ENDIF

   IF _HMG_PRINTER_PrintPages.Radio_1.Value == 1
      PageFrom := 1
      PageTo   := _HMG_PRINTER_PageCount
   ELSEIF _HMG_PRINTER_PrintPages.Radio_1.Value == 2
      PageFrom := _HMG_PRINTER_PrintPages.Spinner_1.Value
      PageTo   := _HMG_PRINTER_PrintPages.Spinner_2.Value
      IF _HMG_PRINTER_PrintPages.Combo_1.Value == 2
         OddOnly := .T.
      ELSEIF _HMG_PRINTER_PrintPages.Combo_1.Value == 3
         EvenOnly := .T.
      ENDIF
   ENDIF

   // See comment in function _HMG_PRINTER_PrintPages()
   nCopies := iif( _HMG_PRINTER_Copies > 1, 1, _HMG_PRINTER_PrintPages.Spinner_3.Value )

   _HMG_PRINTER_InitUserMessages( cLang )
   _HMG_PRINTER_JobId := _HMG_PRINTER_StartDoc( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_GetJobName() )

   IF _HMG_PRINTER_PrintPages.CheckBox_1.Value  // Collate
      FOR p := 1 TO nCopies
         FOR i := PageFrom TO PageTo
            IF OddOnly == .T.
               IF i / 2 != Int( i / 2 )
                  _HMG_PRINTER_PrintPage( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
               ENDIF
            ELSEIF EvenOnly == .T.
               IF i / 2 == Int( i / 2 )
                  _HMG_PRINTER_PrintPage( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
               ENDIF
            ELSE
               _HMG_PRINTER_PrintPage( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
            ENDIF
         NEXT i
      NEXT p
   ELSE
      FOR i := PageFrom TO PageTo
         FOR p := 1 TO nCopies
            IF OddOnly == .T.
               IF i / 2 != Int( i / 2 )
                  _HMG_PRINTER_PrintPage( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
               ENDIF
            ELSEIF EvenOnly == .T.
               IF i / 2 == Int( i / 2 )
                  _HMG_PRINTER_PrintPage( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
               ENDIF
            ELSE
               _HMG_PRINTER_PrintPage( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
            ENDIF
         NEXT p
      NEXT i
   ENDIF

   _HMG_PRINTER_EndDoc( _HMG_PRINTER_hdcPrint )

   EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWPREVIEW" ) )
   EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
   EnableWindow( GetFormHandle( "_HMG_PRINTER_PPNAV" ) )

   HideWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) )

   _HMG_PRINTER_SHOWPREVIEW.SetFocus

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_MouseZoom()

   LOCAL Width := GetDesktopRealWidth()
   LOCAL Height := GetDesktopRealHeight()
   LOCAL Q := 0
   LOCAL DeltaHeight := 35 + GetTitleHeight() + GetBorderHeight() + 10

   IF _HMG_PRINTER_hdcPrint == 0
      RETURN
   ENDIF

   IF _HMG_PRINTER_Dz # 0
      _HMG_PRINTER_Dz := 0
      _HMG_PRINTER_Dx := 0
      _HMG_PRINTER_Dy := 0

      SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 50, .T. )
      SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 50, .T. )
   ELSE
      // Calculate Quadrant
      IF _OOHG_MouseCol <= ( Width / 2 ) - _HMG_PRINTER_ZoomClick_xOffset .AND. ;
         _OOHG_MouseRow <= ( Height / 2 ) - DeltaHeight
         Q := 1
      ELSEIF _OOHG_MouseCol > ( Width / 2 ) - _HMG_PRINTER_ZoomClick_xOffset .AND. ;
             _OOHG_MouseRow <= ( Height / 2 ) - DeltaHeight
         Q := 2
      ELSEIF _OOHG_MouseCol <= ( Width / 2 ) - _HMG_PRINTER_ZoomClick_xOffset .AND. ;
             _OOHG_MouseRow > ( Height / 2 ) - DeltaHeight
         Q := 3
      ELSEIF _OOHG_MouseCol > ( Width / 2 ) - _HMG_PRINTER_ZoomClick_xOffset .AND. ;
             _OOHG_MouseRow > ( Height / 2 ) - DeltaHeight
         Q := 4
      ENDIF

      IF _HMG_PRINTER_GetPageHeight( _HMG_PRINTER_hdcPrint ) > _HMG_PRINTER_GetPageWidth( _HMG_PRINTER_hdcPrint )
         // Portrait
         IF Q == 1
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := 100
            _HMG_PRINTER_Dy := 400
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 10, .T. )
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 40, .T. )
         ELSEIF Q == 2
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := -100
            _HMG_PRINTER_Dy := 400
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 10, .T. )
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 60, .T. )
         ELSEIF Q == 3
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := 100
            _HMG_PRINTER_Dy := -400
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 90, .T. )
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 40, .T. )
         ELSEIF Q == 4
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := -100
            _HMG_PRINTER_Dy := -400
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 90, .T. )
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 60, .T. )
         ENDIF
      ELSE
         // Landscape
         IF Q == 1
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := 500
            _HMG_PRINTER_Dy := 300
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 20, .T. )
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 1, .T. )
         ELSEIF Q == 2
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := -500
            _HMG_PRINTER_Dy := 300
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 20, .T. )
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 99, .T. )
         ELSEIF Q == 3
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := 500
            _HMG_PRINTER_Dy := -300
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 80, .T. )
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 1, .T. )
         ELSEIF Q == 4
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := -500
            _HMG_PRINTER_Dy := -300
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 80, .T. )
            SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 99, .T. )
         ENDIF
      ENDIF
   ENDIF

   _HMG_PRINTER_PPNAV.zoom.Value := _HMG_PRINTER_Dz / 200

   _HMG_PRINTER_PreviewRefresh()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_Zoom()

   IF _HMG_PRINTER_hdcPrint == 0
      RETURN
   ENDIF

   IF _HMG_PRINTER_Dz # 0
      _HMG_PRINTER_Dz := 0
      _HMG_PRINTER_Dx := 0
      _HMG_PRINTER_Dy := 0
      SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 50, .T. )
      SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 50, .T. )
   ELSE
      IF _HMG_PRINTER_GetPageHeight( _HMG_PRINTER_hdcPrint ) > _HMG_PRINTER_GetPageWidth( _HMG_PRINTER_hdcPrint )
         _HMG_PRINTER_Dz := 1000
         _HMG_PRINTER_Dx := 100
         _HMG_PRINTER_Dy := 400
         SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 10, .T. )
         SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 40, .T. )
      ELSE
         _HMG_PRINTER_Dz := 1000
         _HMG_PRINTER_Dx := 500
         _HMG_PRINTER_Dy := 300
         SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 20, .T. )
         SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 1, .T. )
      ENDIF
   ENDIF

   _HMG_PRINTER_PPNAV.zoom.Value := _HMG_PRINTER_Dz / 200

   _HMG_PRINTER_PreviewRefresh()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_ScrollLeft()

   _HMG_PRINTER_Dx := _HMG_PRINTER_Dx + _HMG_PRINTER_ScrollStep
   IF _HMG_PRINTER_Dx >= 500
      _HMG_PRINTER_Dx := 500
      PlayBeep()
   ENDIF
   _HMG_PRINTER_PreviewRefresh()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_ScrollRight()

   _HMG_PRINTER_Dx := _HMG_PRINTER_Dx - _HMG_PRINTER_ScrollStep
   IF _HMG_PRINTER_Dx <= -500
      _HMG_PRINTER_Dx := -500
      PlayBeep()
   ENDIF
   _HMG_PRINTER_PreviewRefresh()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_ScrollUp()

   _HMG_PRINTER_Dy := _HMG_PRINTER_Dy + _HMG_PRINTER_ScrollStep
   IF _HMG_PRINTER_Dy >= 500
      _HMG_PRINTER_Dy := 500
      PlayBeep()
   ENDIF
   _HMG_PRINTER_PreviewRefresh()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_ScrollDown()

   _HMG_PRINTER_Dy := _HMG_PRINTER_Dy - _HMG_PRINTER_ScrollStep
   IF _HMG_PRINTER_Dy <= -500
      _HMG_PRINTER_Dy := -500
      PlayBeep()
   ENDIF
   _HMG_PRINTER_PreviewRefresh()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_GetPrinter( cLang )

   LOCAL RetVal := '', nValue
   LOCAL aPrinters := ASort( _HMG_PRINTER_aPrinters() )
   LOCAL cDefault := GetDefaultPrinter()

   _HMG_PRINTER_InitUserMessages( cLang )

   IF Len( aPrinters ) == 0
      MsgExclamation( _HMG_PRINTER_UserMessages[ 32 ], _HMG_PRINTER_UserMessages[ 30 ] )
      RETURN cDefault
   ENDIF

   nValue := Max( AScan( aPrinters, cDefault ), 1 )

   DEFINE WINDOW _HMG_PRINTER_GETPRINTER ;
      AT 0, 0 ;
      WIDTH 345 ;
      HEIGHT GetTitleHeight() + 100 ;
      TITLE _HMG_PRINTER_UserMessages[ 13 ] ;
      MODAL ;
      NOSIZE

      @ 15, 10 COMBOBOX Combo_1 ITEMS aPrinters VALUE nvalue WIDTH 320

      @ 53, 65  BUTTON Ok CAPTION _HMG_PRINTER_UserMessages[ 11 ] ACTION( RetVal := aPrinters[ GetProperty( '_HMG_PRINTER_GETPRINTER', 'Combo_1', 'Value') ], DoMethod( '_HMG_PRINTER_GETPRINTER', 'Release' ) )
      @ 53, 175 BUTTON Cancel CAPTION _HMG_PRINTER_UserMessages[ 12 ] ACTION( RetVal := '', DoMethod( '_HMG_PRINTER_GETPRINTER', 'Release' ) )
   END WINDOW

   CENTER WINDOW _HMG_PRINTER_GETPRINTER
   _HMG_PRINTER_getprinter.Ok.SetFocus()

   ACTIVATE WINDOW _HMG_PRINTER_GETPRINTER

   RETURN RetVal

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Print( nHdc, nRow, nCol, cFontName, nFontSize, nRed, nGreen, nBlue, cText, lBold, lItalic, lUnderline, lStrikeOut, lColor, lFontName, lFontSize, lAngle, nAngle, lWidth, nWidth, cAlign )

   LOCAL cOld, lRestore := .F.

   DEFAULT lAngle TO .F.
   DEFAULT nAngle TO 0

   IF ValType( cText ) == "N"
      cText := AllTrim( Str( cText ) )
   ELSEIF ValType( cText ) == "D"
      cText := DToC( cText )
   ELSEIF ValType( cText ) == "L"
      cText := iif( cText == .T., _HMG_PRINTER_UserMessages[ 24 ], _HMG_PRINTER_UserMessages[ 25 ] )
   ELSEIF ValType( cText ) == "T"
      cText := TToC( cText )
   ELSEIF ValType( cText ) == "A"
      RETURN
   ELSEIF ValType( cText ) == "B"
      RETURN
   ELSEIF ValType( cText ) == "O"
      RETURN
   ELSEIF ValType( cText ) == "U"
      RETURN
   ENDIF

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )

   IF lAngle
      nAngle := nAngle * 10
   ENDIF

   IF ValType( cAlign ) $ "CM"
      IF Upper( cAlign ) == "CENTER"
         cOld := _HMG_PRINTER_SetTextAlign( nHdc, TA_CENTER )
         lRestore := .T.
      ELSEIF Upper( cAlign )== "RIGHT"
         cOld := _HMG_PRINTER_SetTextAlign( nHdc, TA_RIGHT )
         lRestore := .T.
      ELSEIF Upper( cAlign )== "LEFT"
         cOld := _HMG_PRINTER_SetTextAlign( nHdc, TA_LEFT )
         lRestore := .T.
      ENDIF
   ENDIF

   _HMG_PRINTER_C_Print( nHdc, nRow, nCol, cFontName, nFontSize, nRed, nGreen, nBlue, cText, lBold, lItalic, lUnderline, lStrikeOut, lColor, lFontName, lFontSize, lAngle, nAngle, lWidth, nWidth )

   IF lRestore
      _HMG_PRINTER_SetTextAlign( nHdc, cOld )
   ENDIF

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_MultiLine_Print( nHdc, nRow, nCol, nToRow, nToCol, cFontName, nFontSize, nRed, nGreen, nBlue, cText, lBold, lItalic, lUnderline, lStrikeOut, lColor, lFontName, lFontSize, lAngle, nAngle, lWidth, nWidth, cAlign )

   LOCAL nAlign

   DEFAULT lAngle TO .F.
   DEFAULT nAngle TO 0

   IF ValType( cText ) == "N"
      cText := AllTrim( Str( cText ) )
   ELSEIF ValType( cText ) == "D"
      cText := DToC( cText )
   ELSEIF ValType( cText ) == "L"
      cText := iif( cText == .T., _HMG_PRINTER_UserMessages[ 24 ], _HMG_PRINTER_UserMessages[ 25 ] )
   ELSEIF ValType( cText ) == "T"
      cText := TToC( cText )
   ELSEIF ValType( cText ) == "A"
      RETURN
   ELSEIF ValType( cText ) == "B"
      RETURN
   ELSEIF ValType( cText ) == "O"
      RETURN
   ELSEIF ValType( cText ) == "U"
      RETURN
   ENDIF

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   IF lAngle
      nAngle := nAngle * 10
   ENDIF

   IF ValType( cAlign ) $ "CM"
      IF Upper( cAlign ) == "CENTER"
         nAlign := TA_CENTER
      ELSEIF Upper( cAlign )== "RIGHT"
         nAlign := TA_RIGHT
      ELSEIF Upper( cAlign )== "LEFT"
         nAlign := TA_LEFT
      ENDIF
   ENDIF

   _HMG_PRINTER_C_MultiLine_Print( nHdc, nRow, nCol, cFontName, nFontSize, nRed, nGreen, nBlue, cText, lBold, lItalic, lUnderline, lStrikeOut, lColor, lFontName, lFontSize, nToRow, nToCol, lAngle, nAngle, lWidth, nWidth, nAlign )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Image( nHdc, cFile, nRow, nCol, nHeight, nWidth, lStretch )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )

   ASSIGN nWidth VALUE nWidth TYPE "N" DEFAULT 0
   nWidth := Int( nWidth * 10000 / 254 )

   ASSIGN nHeight VALUE nHeight TYPE "N" DEFAULT 0
   nHeight := Int( nHeight * 10000 / 254 )

   _HMG_PRINTER_C_Image( nHdc, cFile, nRow, nCol, nHeight, nWidth, lStretch )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Line( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   ASSIGN lStyle VALUE lStyle TYPE "L" DEFAULT .F.

   IF lStyle .AND. nStyle == PEN_DASH
      IF ! HB_ISNUMERIC( nWidth ) .OR. nWidth < 1
         nWidth := 3
      ENDIF
      lwidth := .T.
   ELSEIF HB_ISNUMERIC( nWidth ) .AND. nWidth > 0
      nWidth := Int( nWidth * 10000 / 254 )
   ENDIF

   _HMG_PRINTER_C_Line( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Rectangle( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, aBrushColor, lNoPen, lNoBrush )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   IF Empty( aBrushColor )
      aBrushColor := { 0, 0, 0 }
   ENDIF

   IF ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   ENDIF

   _HMG_PRINTER_C_Rectangle( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, ;
      lBrushStyle, nBrushStyle, lBrushColor, aBrushColor[ 1 ], aBrushColor[ 2 ], aBrushColor[ 3 ], lNoPen, lNoBrush )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_RoundRectangle( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, aBrushColor, lNoPen, lNoBrush )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   IF Empty( aBrushColor )
      aBrushColor := { 0, 0, 0 }
   ENDIF

   IF ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   ENDIF

   _HMG_PRINTER_C_RoundRectangle( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, ;
      lBrushStyle, nBrushStyle, lBrushColor, aBrushColor[ 1 ], aBrushColor[ 2 ], aBrushColor[ 3 ], lNoPen, lNoBrush )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Fill( nHdc, nRow, nCol, nToRow, nToCol, nRed, nGreen, nBlue, lColor )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   _HMG_PRINTER_C_Fill( nHdc, nRow, nCol, nToRow, nToCol, nRed, nGreen, nBlue, lColor )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Ellipse( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, aBrushColor, lNoPen, lNoBrush )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   IF Empty( aBrushColor )
      aBrushColor := { 0, 0, 0 }
   ENDIF

   IF ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   ENDIF

   _HMG_PRINTER_C_Ellipse( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, ;
      lBrushStyle, nBrushStyle, lBrushColor, aBrushColor[ 1 ], aBrushColor[ 2 ], aBrushColor[ 3 ], lNoPen, lNoBrush )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Arc( nHdc, nRow, nCol, nToRow, nToCol, nRow1, nCol1, nRow2, nCol2, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )
   nRow1 := Int( nRow1 * 10000 / 254 )
   nCol1 := Int( nCol1 * 10000 / 254 )
   nRow2 := Int( nRow2 * 10000 / 254 )
   nCol2 := Int( nCol2 * 10000 / 254 )

   IF ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   ENDIF

   _HMG_PRINTER_C_Arc( nHdc, nRow, nCol, nToRow, nToCol, nRow1, nCol1, nRow2, nCol2, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Pie( nHdc, nRow, nCol, nToRow, nToCol, nRow1, nCol1, nRow2, nCol2, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, aBrushColor, lNoPen, lNoBrush )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )
   nRow1 := Int( nRow1 * 10000 / 254 )
   nCol1 := Int( nCol1 * 10000 / 254 )
   nRow2 := Int( nRow2 * 10000 / 254 )
   nCol2 := Int( nCol2 * 10000 / 254 )

   IF Empty( aBrushColor )
      aBrushColor := { 0, 0, 0 }
   ENDIF

   IF ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   ENDIF

   _HMG_PRINTER_C_Pie( nHdc, nRow, nCol, nToRow, nToCol, nRow1, nCol1, nRow2, nCol2, nWidth, nRed, nGreen, nBlue, lWidth, lColor, ;
      lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, aBrushColor[ 1 ], aBrushColor[ 2 ], aBrushColor[ 3 ], lNoPen, lNoBrush )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_H_Bitmap( nHdc, hBitmap, nRow, nCol, nHeight, nWidth, lStretch )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )

   ASSIGN nWidth VALUE nWidth TYPE "N" DEFAULT 0
   nWidth := Int( nWidth * 10000 / 254 )

   ASSIGN nHeight VALUE nHeight TYPE "N" DEFAULT 0
   nHeight := Int( nHeight * 10000 / 254 )

   _HMG_PRINTER_C_Bitmap( nHdc, hBitmap, nRow, nCol, nHeight, nWidth, lStretch )

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE _HMG_PRINTER_InitUserMessages( cLang )

   LOCAL nAt, i, cData

   IF ! __mvExist( '_HMG_MiniPrint' )
      __mvPublic( '_HMG_MiniPrint' )
      _HMG_MiniPrint := Array( _HMG_PRINTER_LastVar )

      _HMG_PRINTER_Name               := ""
      _HMG_PRINTER_aPrinterProperties := NIL
      _HMG_PRINTER_BasePageName       := ""
      _HMG_PRINTER_CurrentPageNumber  := 0
      _HMG_PRINTER_SizeFactor         := ""
      _HMG_PRINTER_Dx                 := 0
      _HMG_PRINTER_Dy                 := 0
      _HMG_PRINTER_Dz                 := 0
      _HMG_PRINTER_ScrollStep         := 0
      _HMG_PRINTER_ZoomClick_xOffset  := 0
      _HMG_PRINTER_ThumbUpdate        := .F.
      _HMG_PRINTER_ThumbScroll        := .F.
      _HMG_PRINTER_PrevPageNumber     := 0
      _HMG_PRINTER_Copies             := 0
      _HMG_PRINTER_Collate            := 1
      _HMG_PRINTER_Delta_Zoom         := 0
      _HMG_PRINTER_TimeStamp          := ""
      _HMG_PRINTER_PageCount          := 0
      _HMG_PRINTER_hdcPrint           := 0
      _HMG_PRINTER_hdcEMF             := 0
      _HMG_PRINTER_JobName            := "OOHG printing system"
      _HMG_PRINTER_Preview            := .F.
      _HMG_PRINTER_UserCopies         := .F.
      _HMG_PRINTER_UserCollate        := .F.
      _HMG_PRINTER_JobId              := 0
      _HMG_PRINTER_JobData            := ""
      _HMG_PRINTER_Error              := .T.
      _HMG_PRINTER_NoSaveButton       := .F.
   ENDIF

   IF ! ValType( cLang ) $ "CM" .OR. Empty( cLang )
      IF _HMG_PRINTER_Language == NIL
         cLang := Set( _SET_LANGUAGE )
      ELSE
         cLang := _HMG_PRINTER_Language
      ENDIF
   ENDIF
   IF ( nAt := At( ".", cLang ) ) > 0
      cLang := Left( cLang, nAt - 1 )
   ENDIF
   cLang := Upper( AllTrim( cLang ) )

   _HMG_PRINTER_UserMessages := Array( 35 )

   DO CASE
   // CZECH
   CASE cLang == "CS" .OR. cLang == "CSWIN"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Strana'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Náhled'
      _HMG_PRINTER_UserMessages[ 03 ] := 'První strana[ HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Pøedchozí strana[ PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Další strana[ PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Poslední strana[ END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Jdi na stranu'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Lupa'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Tisk'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Èíslo strany'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Ok'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Storno'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Vyber tiskárnu'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Tøídìní'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Rozsah tisku'
      _HMG_PRINTER_UserMessages[ 16 ] := 'vše'
      _HMG_PRINTER_UserMessages[ 17 ] := 'strany'
      _HMG_PRINTER_UserMessages[ 18 ] := 'od'
      _HMG_PRINTER_UserMessages[ 19 ] := 'do'
      _HMG_PRINTER_UserMessages[ 20 ] := 'kopií'
      _HMG_PRINTER_UserMessages[ 21 ] := 'všechny strany'
      _HMG_PRINTER_UserMessages[ 22 ] := 'liché strany'
      _HMG_PRINTER_UserMessages[ 23 ] := 'sudé strany'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Ano'
      _HMG_PRINTER_UserMessages[ 25 ] := 'No'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Zavøi'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Ulož'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Miniatury'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Generuji miniatury... Èekejte, prosím...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Warning'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Select a Folder'
      _HMG_PRINTER_UserMessages[ 32 ] := 'No printer is installed in this system.'
      _HMG_PRINTER_UserMessages[ 33 ] := 'Closing preview... Please Wait...'
      _HMG_PRINTER_UserMessages[ 34 ] := 'Chyba'
      _HMG_PRINTER_UserMessages[ 35 ] := 'Konfigurace tiskárny s kódem selhala: '
   // FRENCH
   CASE cLang == "FR"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Page'
      _HMG_PRINTER_UserMessages[ 02 ] := "Aperçu avant impression"
      _HMG_PRINTER_UserMessages[ 03 ] := 'Première page [HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Page précédente [PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Page suivante [PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Dernière Page [END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Allez page'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Zoom'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Imprimer'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Page'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Ok'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Annulation'
      _HMG_PRINTER_UserMessages[ 13 ] := "Sélection de l'imprimante"
      _HMG_PRINTER_UserMessages[ 14 ] := "Assemblez"
      _HMG_PRINTER_UserMessages[ 15 ] := "Intervalle d'impression"
      _HMG_PRINTER_UserMessages[ 16 ] := 'Tous'
      _HMG_PRINTER_UserMessages[ 17 ] := 'Pages'
      _HMG_PRINTER_UserMessages[ 18 ] := 'De'
      _HMG_PRINTER_UserMessages[ 19 ] := 'À'
      _HMG_PRINTER_UserMessages[ 20 ] := 'Copies'
      _HMG_PRINTER_UserMessages[ 21 ] := 'Toutes les pages'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Pages Impaires'
      _HMG_PRINTER_UserMessages[ 23 ] := 'Pages paires'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Oui'
      _HMG_PRINTER_UserMessages[ 25 ] := 'Non'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Fermer'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Sauver'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Affichettes'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Veuillez patienter pendant que les vignettes sont générées ...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Attention'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Sélectionner un dossier'
      _HMG_PRINTER_UserMessages[ 32 ] := "Aucune imprimeur n'est installé dans ce système."
      _HMG_PRINTER_UserMessages[ 33 ] := "Svp attente, l'aperçu se ferme..."
      _HMG_PRINTER_UserMessages[ 34 ] := 'Erreur'
      _HMG_PRINTER_UserMessages[ 35 ] := "La configuration de l'imprimante a échoué avec le code: "
   // GERMAN
   CASE cLang == "DEWIN" .OR. cLang == "DE"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Seite'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Druckvorschau'
      _HMG_PRINTER_UserMessages[ 03 ] := 'Erste Seite [HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Vorherige Seite [PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Nächste Seite [PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Letzte Seite [END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Gehe zur Seite'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Zoom'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Druck'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Seitenzahl'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Okay'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Löschen'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Drucker wählen'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Sortieren'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Wählen Sie Druckbereich'
      _HMG_PRINTER_UserMessages[ 16 ] := 'Alle'
      _HMG_PRINTER_UserMessages[ 17 ] := 'Seiten'
      _HMG_PRINTER_UserMessages[ 18 ] := 'Von'
      _HMG_PRINTER_UserMessages[ 19 ] := 'Bis'
      _HMG_PRINTER_UserMessages[ 20 ] := 'Kopien'
      _HMG_PRINTER_UserMessages[ 21 ] := 'Alle Seiten'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Nur ungerade Seiten'
      _HMG_PRINTER_UserMessages[ 23 ] := 'Nur gerade Seiten'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Ja'
      _HMG_PRINTER_UserMessages[ 25 ] := 'Nein'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Beenden'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Speichern'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Seitenminiaturen'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Bitte warten, während die Seitenminiaturen erstellt werden...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Warnung'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Wählen Sie einen Ordner'
      _HMG_PRINTER_UserMessages[ 32 ] := 'Es sind keine Drucker im System installiert.'
      _HMG_PRINTER_UserMessages[ 33 ] := 'Bitte warten, während die Druckvorschau Schließens...'
      _HMG_PRINTER_UserMessages[ 34 ] := 'Fehler'
      _HMG_PRINTER_UserMessages[ 35 ] := 'Druckerkonfiguration mit Code fehlgeschlagen: '
   // ITALIAN
   CASE cLang == "IT"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Pagina'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Anteprima di stampa'
      _HMG_PRINTER_UserMessages[ 03 ] := 'Prima Pagina [HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Pagina Precedente [PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Pagina Seguente [PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Ultima Pagina [END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Vai Alla Pagina'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Zoom'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Stampa'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Pagina'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Ok'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Annulla'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Selezioni Lo Stampatore'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Fascicoli'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Intervallo di stampa'
      _HMG_PRINTER_UserMessages[ 16 ] := 'Tutti'
      _HMG_PRINTER_UserMessages[ 17 ] := 'Pagine'
      _HMG_PRINTER_UserMessages[ 18 ] := 'Da'
      _HMG_PRINTER_UserMessages[ 19 ] := 'A'
      _HMG_PRINTER_UserMessages[ 20 ] := 'Copie'
      _HMG_PRINTER_UserMessages[ 21 ] := 'Tutte le pagine'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Le Pagine Pari'
      _HMG_PRINTER_UserMessages[ 23 ] := 'Le Pagine Dispari'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Si'
      _HMG_PRINTER_UserMessages[ 25 ] := 'No'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Chiudi'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Salva'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Miniatura'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Generando Miniatura...  Prego Attesa...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Avvertimento'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Selezionare una cartella'
      _HMG_PRINTER_UserMessages[ 32 ] := 'Nessuna stampatore è installata in questo sistema.'
      _HMG_PRINTER_UserMessages[ 33 ] := "Chiudendo l'anteprima... Prego Attesa..."
      _HMG_PRINTER_UserMessages[ 34 ] := 'Errore'
      _HMG_PRINTER_UserMessages[ 35 ] := 'Configurazione della stampante non riuscita con codice: '
   // POLISH
   CASE cLang == "PL" .OR. cLang == "PLWIN" .OR. cLang == "PL852" .OR. cLang == "PLISO" .OR. cLang == "PLMAZ"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Strona'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Podgl¹d wydruku'
      _HMG_PRINTER_UserMessages[ 03 ] := 'Pierwsza strona [HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Poprzednia strona [PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Nastêpna strona [PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Ostatnia strona [END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Skocz do strony'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Powiêksz'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Drukuj'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Numer strony'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Tak'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Przerwij'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Wybierz drukarkê'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Sortuj kopie'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Zakres wydruku'
      _HMG_PRINTER_UserMessages[ 16 ] := 'Wszystkie'
      _HMG_PRINTER_UserMessages[ 17 ] := 'Strony'
      _HMG_PRINTER_UserMessages[ 18 ] := 'Od'
      _HMG_PRINTER_UserMessages[ 19 ] := 'Do'
      _HMG_PRINTER_UserMessages[ 20 ] := 'Kopie'
      _HMG_PRINTER_UserMessages[ 21 ] := 'Wszystkie'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Nieparzyste'
      _HMG_PRINTER_UserMessages[ 23 ] := 'Parzyste'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Tak'
      _HMG_PRINTER_UserMessages[ 25 ] := 'Nie'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Zamknij'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Zapisz'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Thumbnails'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Generujê Thumbnails... Proszê czekaæ...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Ostrzezenie'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Wybierz folder'
      _HMG_PRINTER_UserMessages[ 32 ] := 'Zadna drukarka nie jest zainstalowana w tym systemie.'
      _HMG_PRINTER_UserMessages[ 33 ] := 'Zamykanie podgladu... Prosze czekac...'
      _HMG_PRINTER_UserMessages[ 34 ] := 'Blad'
      _HMG_PRINTER_UserMessages[ 35 ] := 'Konfiguracja drukarki nie powiodla sie z kodem: '
   // PORTUGUESE
   CASE cLang == "PT"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Página'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Inspecção prévia De Cópia'
      _HMG_PRINTER_UserMessages[ 03 ] := 'Primeira Página [HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Página Precedente [PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Página Seguinte [PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Última Página [END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Vá Paginar'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Amplie'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Cópia'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Página'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Ok'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Cancelar'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Selecione A Impressora'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Ordene Cópias'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Escala De Cópia'
      _HMG_PRINTER_UserMessages[ 16 ] := 'Tudo'
      _HMG_PRINTER_UserMessages[ 17 ] := 'Páginas'
      _HMG_PRINTER_UserMessages[ 18 ] := 'De'
      _HMG_PRINTER_UserMessages[ 19 ] := 'A'
      _HMG_PRINTER_UserMessages[ 20 ] := 'Cópias'
      _HMG_PRINTER_UserMessages[ 21 ] := 'Toda a Escala'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Páginas Impares Somente'
      _HMG_PRINTER_UserMessages[ 23 ] := 'Páginas Uniformes Somente'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Sim'
      _HMG_PRINTER_UserMessages[ 25 ] := 'Não'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Fechar'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Salvar'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Miniaturas'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Gerando Miniaturas...  Por favor Espera...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Aviso'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Selecione uma pasta'
      _HMG_PRINTER_UserMessages[ 32 ] := 'Nenhuma impressora está instalado neste sistema.'
      _HMG_PRINTER_UserMessages[ 33 ] := 'Encerrando a visualização... Aguarde...'
      _HMG_PRINTER_UserMessages[ 34 ] := 'Erro'
      _HMG_PRINTER_UserMessages[ 35 ] := 'A configuração da impressora falhou com o código: '
   // RUSSIAN
   CASE cLang == "RU" .OR. cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Ñòðàíèöà'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Ïðåäâàðèòåëüíûé ïðîñìîòð'
      _HMG_PRINTER_UserMessages[ 03 ] := 'Ïåðâàÿ [HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Ïðåäûäóùàÿ [PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Ñëåäóþùàÿ [PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Ïîñëåäíÿÿ [END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Ïåðåéòè ê'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Ìàñøòàá'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Ïå÷àòü'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Ñòðàíèöà ¹'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Ok'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Îòìåíà'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Âûáîð ïðèíòåðà'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Ñîðòèðîâêà êîïèé'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Èíòåðâàë ïå÷àòè'
      _HMG_PRINTER_UserMessages[ 16 ] := 'Âñå'
      _HMG_PRINTER_UserMessages[ 17 ] := 'Ñòðàíèöû'
      _HMG_PRINTER_UserMessages[ 18 ] := 'Îò'
      _HMG_PRINTER_UserMessages[ 19 ] := 'Äî'
      _HMG_PRINTER_UserMessages[ 20 ] := 'Êîïèé'
      _HMG_PRINTER_UserMessages[ 21 ] := 'Âåñü èíòåðâàë'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Íå÷åòíûå òîëüêî'
      _HMG_PRINTER_UserMessages[ 23 ] := '×åòíûå òîëüêî'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Äà'
      _HMG_PRINTER_UserMessages[ 25 ] := 'Íåò'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Çàêðûòü'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Ñîõðàíèòü'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Ìèíèàòþðû'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Æäèòå, ãåíåðèðóþ ìèíèàòþðû...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Ïðåäóïðåæäåíèå'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Select a Folder'
      _HMG_PRINTER_UserMessages[ 32 ] := 'No printer is installed in this system.'
      _HMG_PRINTER_UserMessages[ 33 ] := 'Closing preview... Please Wait...'
      _HMG_PRINTER_UserMessages[ 34 ] := 'Îøèáêà'
      _HMG_PRINTER_UserMessages[ 35 ] := 'Printer configuration failed with code: '
   // SPANISH
   CASE cLang == "ES"  .OR. cLang == "ESWIN"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Página'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Vista Previa'
      _HMG_PRINTER_UserMessages[ 03 ] := 'Inicio [INICIO]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Anterior [REPAG]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Siguiente [AVPAG]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Fin [FIN]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Ir a'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Zoom'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Imprimir'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Página Nro.'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Aceptar'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Cancelar'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Seleccionar Impresora'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Ordenar Copias'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Rango de Impresión'
      _HMG_PRINTER_UserMessages[ 16 ] := 'Todo'
      _HMG_PRINTER_UserMessages[ 17 ] := 'Páginas'
      _HMG_PRINTER_UserMessages[ 18 ] := 'Desde'
      _HMG_PRINTER_UserMessages[ 19 ] := 'Hasta'
      _HMG_PRINTER_UserMessages[ 20 ] := 'Copias'
      _HMG_PRINTER_UserMessages[ 21 ] := 'Todo El Rango'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Solo Páginas Impares'
      _HMG_PRINTER_UserMessages[ 23 ] := 'Solo Páginas Pares'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Si'
      _HMG_PRINTER_UserMessages[ 25 ] := 'No'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Cerrar'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Guardar'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Miniaturas'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Generando Miniaturas... Espere Por Favor...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Advertencia'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Seleccione Una Carpeta'
      _HMG_PRINTER_UserMessages[ 32 ] := 'No hay impresora instalada en este sistema.'
      _HMG_PRINTER_UserMessages[ 33 ] := 'Cerrando vista previa... Espere Por Favor...'
      _HMG_PRINTER_UserMessages[ 34 ] := 'Error'
      _HMG_PRINTER_UserMessages[ 35 ] := 'La configuración de la impresora falló con el código: '
   // FINNISH
   CASE cLang == "FI"
      _HMG_PRINTER_UserMessages[ 01 ] := 'Sivu'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Tulostuksen esikatselu'
      _HMG_PRINTER_UserMessages[ 03 ] := 'Ensimmäinen sivu [HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Edellinen sivu [PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Seuraava sivu [PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Viimeinen sivu [END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Mene sivulle'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Zoomaus'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Tulosta'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Sivunumero'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Ok'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Peruuttaa'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Valitse tulostin'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Lajittele kopiot'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Tulostusalue'
      _HMG_PRINTER_UserMessages[ 16 ] := 'Kaikki'
      _HMG_PRINTER_UserMessages[ 17 ] := 'sivut'
      _HMG_PRINTER_UserMessages[ 18 ] := 'osoitteesta'
      _HMG_PRINTER_UserMessages[ 19 ] := 'To'
      _HMG_PRINTER_UserMessages[ 20 ] := 'kopiot'
      _HMG_PRINTER_UserMessages[ 21 ] := 'All Range'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Vain parittomat sivut'
      _HMG_PRINTER_UserMessages[ 23 ] := 'Vain parilliset sivut'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Joo'
      _HMG_PRINTER_UserMessages[ 25 ] := 'Ei'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Kiinni'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Tallentaa'
      _HMG_PRINTER_UserMessages[ 28 ] := 'esikatselukuvat'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Luodaan pikkukuvia ... Odota ...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Varoitus'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Valitse kansio'
      _HMG_PRINTER_UserMessages[ 32 ] := 'Tähän järjestelmään ei ole asennettu tulostinta.'
      _HMG_PRINTER_UserMessages[ 33 ] := 'Sulje esikatselu ... odota ...'
      _HMG_PRINTER_UserMessages[ 34 ] := 'Virhe'
      _HMG_PRINTER_UserMessages[ 35 ] := 'Tulostimen määritykset epäonnistuivat koodilla:'
/* TODO:
   // DUTCH
   CASE cLang == "NL"
   // SLOVENIAN
   CASE cLang == "SL" .OR. CASE cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "SL646" .OR. cLang == "SL437"
   // BULGARIAN
   CASE cLang == "BG" .OR. cLang == "BGWIN"
   // GREEK
   CASE cLang == "EL" .OR. cLang == "ELWIN"
   // BASQUE
   CASE cLang == "EU"
   // CROATIAN
   CASE cLang == "HR" .OR. cLang == "HR852"
   // HUNGARIAN
   CASE cLang == "HU" .OR. cLang == "HUWIN"
   // SLOVAK
   CASE cLang == "SK" .OR. cLang == "SKWIN"
   // TURKISH
   CASE cLang == "TR" .OR. cLang == "TRWIN"
   // UKRANIAN
   CASE cLang == "UK" .OR. cLang == "UAWIN"
*/
   // DEFAULT TO ENGLISH
   OTHERWISE
      _HMG_PRINTER_UserMessages[ 01 ] := 'Page'
      _HMG_PRINTER_UserMessages[ 02 ] := 'Print Preview'
      _HMG_PRINTER_UserMessages[ 03 ] := 'First Page [HOME]'
      _HMG_PRINTER_UserMessages[ 04 ] := 'Previous Page [PGUP]'
      _HMG_PRINTER_UserMessages[ 05 ] := 'Next Page [PGDN]'
      _HMG_PRINTER_UserMessages[ 06 ] := 'Last Page [END]'
      _HMG_PRINTER_UserMessages[ 07 ] := 'Go To Page'
      _HMG_PRINTER_UserMessages[ 08 ] := 'Zoom'
      _HMG_PRINTER_UserMessages[ 09 ] := 'Print'
      _HMG_PRINTER_UserMessages[ 10 ] := 'Page Number'
      _HMG_PRINTER_UserMessages[ 11 ] := 'Ok'
      _HMG_PRINTER_UserMessages[ 12 ] := 'Cancel'
      _HMG_PRINTER_UserMessages[ 13 ] := 'Select Printer'
      _HMG_PRINTER_UserMessages[ 14 ] := 'Collate Copies'
      _HMG_PRINTER_UserMessages[ 15 ] := 'Print Range'
      _HMG_PRINTER_UserMessages[ 16 ] := 'All'
      _HMG_PRINTER_UserMessages[ 17 ] := 'Pages'
      _HMG_PRINTER_UserMessages[ 18 ] := 'From'
      _HMG_PRINTER_UserMessages[ 19 ] := 'To'
      _HMG_PRINTER_UserMessages[ 20 ] := 'Copies'
      _HMG_PRINTER_UserMessages[ 21 ] := 'All Range'
      _HMG_PRINTER_UserMessages[ 22 ] := 'Odd Pages Only'
      _HMG_PRINTER_UserMessages[ 23 ] := 'Even Pages Only'
      _HMG_PRINTER_UserMessages[ 24 ] := 'Yes'
      _HMG_PRINTER_UserMessages[ 25 ] := 'No'
      _HMG_PRINTER_UserMessages[ 26 ] := 'Close'
      _HMG_PRINTER_UserMessages[ 27 ] := 'Save'
      _HMG_PRINTER_UserMessages[ 28 ] := 'Thumbnails'
      _HMG_PRINTER_UserMessages[ 29 ] := 'Generating Thumbnails... Please Wait...'
      _HMG_PRINTER_UserMessages[ 30 ] := 'Warning'
      _HMG_PRINTER_UserMessages[ 31 ] := 'Select a Folder'
      _HMG_PRINTER_UserMessages[ 32 ] := 'No printer is installed in this system.'
      _HMG_PRINTER_UserMessages[ 33 ] := 'Closing preview... Please Wait...'
      _HMG_PRINTER_UserMessages[ 34 ] := 'Error'
      _HMG_PRINTER_UserMessages[ 35 ] := 'Printer configuration failed with code: '
   ENDCASE

   FOR i := 1 TO 35
      IF ! Empty( cData := LoadString( 100 + i ) )
         _HMG_PRINTER_UserMessages[ i ] := cData
      ENDIF
   NEXT i

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_GetPrintableAreaWidth()

   RETURN _HMG_PRINTER_GetPrinterWidth( OpenPrinterGetPageDC() )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_GetPrintableAreaHeight()

   RETURN _HMG_PRINTER_GetPrinterHeight( OpenPrinterGetPageDC() )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_GetPrintableAreaHorizontalOffset()

   LOCAL nPhOfX, nLgPxX

   nPhOfX := _HMG_PRINTER_GetPrintableAreaPhysicalOffsetX( OpenPrinterGetPageDC() )
   nLgPxX := _HMG_PRINTER_GetPrintableAreaLogPixelsX( OpenPrinterGetPageDC() )

   IF nLgPxX == 0
      RETURN 0
   ENDIF

   RETURN( nPhOfX / nLgPxX * 25.4 )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_GetPrintableAreaVerticalOffset()

   LOCAL nPhOfY, nLgPxY

   nPhOfY := _HMG_PRINTER_GetPrintableAreaPhysicalOffsetY( OpenPrinterGetPageDC() )
   nLgPxY := _HMG_PRINTER_GetPrintableAreaLogPixelsY( OpenPrinterGetPageDC() )

   IF nLgPxY == 0
      RETURN 0
   ENDIF

   RETURN( nPhOfY / nLgPxY * 25.4 )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_GetJobName()

   IF ! ValType( _HMG_PRINTER_JobName ) $ "CM" .OR. Empty( _HMG_PRINTER_JobName )
      _HMG_PRINTER_JobName := "OOHG printing system"
   ENDIF

   RETURN _HMG_PRINTER_JobName

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_SetJobName( cName )

   _HMG_PRINTER_GetJobName()

   IF ValType( cName ) $ 'CM'
      _HMG_PRINTER_JobName := cName
   ENDIF

   RETURN _HMG_PRINTER_JobName

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_TextAlign( nAlign )

   RETURN _HMG_PRINTER_SetTextAlign( OpenPrinterGetPageDC(), nAlign )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_PreviewZoom( nSize )

   IF PCount() > 1
      _HMG_PRINTER_Dz := nSize * 200
      IF IsControlDefined( zoom, _HMG_PRINTER_PPNAV )
         _HMG_PRINTER_PPNAV.zoom.Value := _HMG_PRINTER_Dz / 200
      ENDIF
   ENDIF

   RETURN ( _HMG_PRINTER_Dz / 200 )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_GetJobInfo( aJobData )

   IF ValType( aJobData ) == "U"
      aJobData := OpenPrinterGetJobData()   // { _hmg_printer_JobId, _hmg_printer_name }
   ENDIF

RETURN _HMG_PRINTER_C_GetJobInfo( aJobData[ 2 ], aJobData[ 1 ] )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_GetStatus( cPrinter )

   IF ! ValType( cPrinter ) $ "CM" .OR. Empty( cPrinter )
      cPrinter := _HMG_PRINTER_Name
   ENDIF

   RETURN _HMG_PRINTER_C_GetStatus( cPrinter )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_SetPrinterProperties( cPrinter, nOrientation, nPaperSize, nPaperLength, nPaperWidth, nCopies, nDefaultSource, nQuality, nColor, nDuplex, nCollate, nScale, lSilent, lIgnore, lGlobal )

   LOCAL aResult

   aResult := _HMG_PRINTER_C_SetPrinterProperties( cPrinter, nOrientation, nPaperSize, nPaperLength, nPaperWidth, nCopies, nDefaultSource, nQuality, nColor, nDuplex, nCollate, nScale, .F., lIgnore, lGlobal )
   ASize( aResult, 14 )
/*
 * { hdcPrint, cPrinter, nCopies, nCollate, nError, nOrientation, nPaperSize, nPaperLength, nPaperWidth, nDefaultSource, nQuality, nColor, nDuplex, nScale }
 */
   IF aResult[ 5 ] # 0 .AND. ! lSilent
      MsgExclamation( _HMG_PRINTER_ErrMsg( aResult[ 5 ] ), _HMG_PRINTER_UserMessages[ 34 ] )
   ENDIF

   RETURN aResult

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION _HMG_PRINTER_ErrMsg( nMsg )

   LOCAL cMsg := _HMG_PRINTER_UserMessages[ 35 ]

   DO CASE
   CASE NumAnd( nMsg, ERR_OPEN_PRINTER ) == ERR_OPEN_PRINTER
      cMsg += 'ERR_OPEN_PRINTER'
   CASE NumAnd( nMsg, ERR_GET_PRINTER_BUFFER_SIZE ) == ERR_GET_PRINTER_BUFFER_SIZE
      cMsg += 'ERR_GET_PRINTER_BUFFER_SIZE'
   CASE NumAnd( nMsg, ERR_ALLOCATE_PRINTER_BUFFER ) == ERR_ALLOCATE_PRINTER_BUFFER
      cMsg += 'ERR_ALLOCATE_PRINTER_BUFFER'
   CASE NumAnd( nMsg, ERR_GET_PRINTER_SETTINGS ) == ERR_GET_PRINTER_SETTINGS
      cMsg += 'ERR_GET_PRINTER_SETTINGS'
   CASE NumAnd( nMsg, ERR_GET_DOCUMENT_BUFFER_SIZE ) == ERR_GET_DOCUMENT_BUFFER_SIZE
      cMsg += 'ERR_GET_DOCUMENT_BUFFER_SIZE'
   CASE NumAnd( nMsg, ERR_ALLOCATE_DOCUMENT_BUFFER ) == ERR_ALLOCATE_DOCUMENT_BUFFER
      cMsg += 'ERR_ALLOCATE_DOCUMENT_BUFFER'
   CASE NumAnd( nMsg, ERR_GET_DOCUMENT_SETTINGS ) == ERR_GET_DOCUMENT_SETTINGS
      cMsg += 'ERR_GET_DOCUMENT_SETTINGS'
   CASE NumAnd( nMsg, ERR_ORIENTATION_NOT_SUPPORTED ) == ERR_ORIENTATION_NOT_SUPPORTED
      cMsg += 'ERR_ORIENTATION_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_PAPERSIZE_NOT_SUPPORTED ) == ERR_PAPERSIZE_NOT_SUPPORTED
      cMsg += 'ERR_PAPERSIZE_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_PAPERLENGTH_NOT_SUPPORTED ) == ERR_PAPERLENGTH_NOT_SUPPORTED
      cMsg += 'ERR_PAPERLENGTH_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_PAPERWIDTH_NOT_SUPPORTED ) == ERR_PAPERWIDTH_NOT_SUPPORTED
      cMsg += 'ERR_PAPERWIDTH_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_COPIES_NOT_SUPPORTED ) == ERR_COPIES_NOT_SUPPORTED
      cMsg += 'ERR_COPIES_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_DEFAULTSOURCE_NOT_SUPPORTED ) == ERR_DEFAULTSOURCE_NOT_SUPPORTED
      cMsg += 'ERR_DEFAULTSOURCE_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_QUALITY_NOT_SUPPORTED ) == ERR_QUALITY_NOT_SUPPORTED
      cMsg += 'ERR_QUALITY_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_COLOR_NOT_SUPPORTED ) == ERR_COLOR_NOT_SUPPORTED
      cMsg += 'ERR_COLOR_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_DUPLEX_NOT_SUPPORTED ) == ERR_DUPLEX_NOT_SUPPORTED
      cMsg += 'ERR_DUPLEX_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_COLLATE_NOT_SUPPORTED ) == ERR_COLLATE_NOT_SUPPORTED
      cMsg += 'ERR_COLLATE_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_SCALE_NOT_SUPPORTED ) == ERR_SCALE_NOT_SUPPORTED
      cMsg += 'ERR_SCALE_NOT_SUPPORTED'
   CASE NumAnd( nMsg, ERR_SET_DOCUMENT_SETTINGS ) == ERR_SET_DOCUMENT_SETTINGS
      cMsg += 'ERR_SET_DOCUMENT_SETTINGS'
   CASE NumAnd( nMsg, ERR_CREATING_DC ) == ERR_CREATING_DC
      cMsg += 'ERR_CREATING_DC'
   OTHERWISE
      cMsg += 'ERR_UNKNOWN'
   ENDCASE

   RETURN cMsg

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _HMG_PRINTER_aPrinters()

   RETURN _HMG_PRINTER_C_aPrinters()

/*
 * The next 6 functions are deprecated and will be removed in a future release.
 * Use _HMG_PRINTER_funcname() instead or add
 * #xtranslate _HMG_PRINTER_funcname() => funcname()
 * to your sources.
 */

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetPrintableAreaWidth()

   RETURN _HMG_PRINTER_GetPrintableAreaWidth()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetPrintableAreaHeight()

   RETURN _HMG_PRINTER_GetPrintableAreaHeight()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetPrintableAreaHorizontalOffset()

   RETURN _HMG_PRINTER_GetPrintableAreaHorizontalOffset()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetPrintableAreaVerticalOffset()

   RETURN _HMG_PRINTER_GetPrintableAreaVerticalOffset()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetPrinter()

   RETURN _HMG_PRINTER_GetPrinter()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION aPrinters()

   RETURN _HMG_PRINTER_aPrinters()

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"
#include <stdio.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include <winuser.h>
#include <wingdi.h>
#include <olectl.h>

// error codes returned by _HMG_PRINTER_SETPRINTERPROPERTIES
#define ERR_OPEN_PRINTER                            0x00000001
#define ERR_GET_PRINTER_BUFFER_SIZE                 0x00000002
#define ERR_ALLOCATE_PRINTER_BUFFER                 0x00000004
#define ERR_GET_PRINTER_SETTINGS                    0x00000008
#define ERR_GET_DOCUMENT_BUFFER_SIZE                0x00000010
#define ERR_ALLOCATE_DOCUMENT_BUFFER                0x00000020
#define ERR_GET_DOCUMENT_SETTINGS                   0x00000040
#define ERR_ORIENTATION_NOT_SUPPORTED               0x00000080
#define ERR_PAPERSIZE_NOT_SUPPORTED                 0x00000100
#define ERR_PAPERLENGTH_NOT_SUPPORTED               0x00000200
#define ERR_PAPERWIDTH_NOT_SUPPORTED                0x00000400
#define ERR_COPIES_NOT_SUPPORTED                    0x00000800
#define ERR_DEFAULTSOURCE_NOT_SUPPORTED             0x00001000
#define ERR_QUALITY_NOT_SUPPORTED                   0x00002000
#define ERR_COLOR_NOT_SUPPORTED                     0x00004000
#define ERR_DUPLEX_NOT_SUPPORTED                    0x00008000
#define ERR_COLLATE_NOT_SUPPORTED                   0x00010000
#define ERR_SCALE_NOT_SUPPORTED                     0x00020000
#define ERR_SET_DOCUMENT_SETTINGS                   0x00040000
#define ERR_CREATING_DC                             0x00080000
// error code returned by _HMG_PRINTER_PRINTDIALOG
#define ERR_PRINTDLG                                0x00100000
// error code returned by _HMG_PRINTER_C_GETSTATUS
#define ERR_PRINTER_STATUS_NOT_AVAILABLE            0x00001000

static DWORD s_charset = DEFAULT_CHARSET;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_SETCHARSET )          /* _HMG_PRINTER_SetCharset( nCharSet ) -> nAlign */
{
   s_charset = ( DWORD ) hb_parnl( 1 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETTEXTALIGN )          /* _HMG_PRINTER_GetTextAlign( hdcPrint ) -> nAlign */
{
   hb_retni( GetTextAlign( (HDC) HB_PARNL( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_SETTEXTALIGN )          /* _HMG_PRINTER_SetTextAlign( hdcPrint, nAlign ) -> nOldAlign */
{
   hb_retni( SetTextAlign( (HDC) HB_PARNL( 1 ), hb_parni( 2 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_ABORTDOC )          /* _HMG_PRINTER_AbortDoc( hdcPrint ) -> NIL */
{
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   AbortDoc( hdcPrint );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_STARTDOC )          /* _HMG_PRINTER_StartDoc( hdcPrint ) -> NIL */
{
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   DOCINFO docInfo;
   int iRet = 0;

   if( hdcPrint != 0 )
   {
      ZeroMemory( &docInfo, sizeof( docInfo ) );
      docInfo.cbSize = sizeof( docInfo );
      docInfo.lpszDocName = hb_parc( 2 );

      iRet = StartDoc( hdcPrint, &docInfo );
      if ( iRet < 0 )
      {
         iRet = 0;
      }
   }

   hb_retni( iRet );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_STARTPAGE )          /* _HMG_PRINTER_StartPage( hdcPrint ) -> NIL */
{
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   int iRet = 0;

   if( hdcPrint != 0 )
   {
      iRet = StartPage( hdcPrint );
   }

   hb_retl( iRet > 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_PRINT )          /* _HMG_PRINTER_C_Print( hdcPrint, nRow, nCol, cFontName, nFontSize, nRed, nGreen, nBlue, cText, lBold, lItalic, lUnderline, lStrikeOut, lColor, lFontName, lFontSize, lAngle, nAngle, lWidth, nWidth ) -> NIL */
{
   HGDIOBJ hgdiobj;
   char FontName[ 32 ];
   int FontSize;
   DWORD fdwItalic;
   DWORD fdwUnderline;
   DWORD fdwStrikeOut;
   int fnWeight;
   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   long nAngle;
   long nWidth ;
   HFONT hfont;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   int FontHeight;

   if( hdcPrint != 0 )
   {
      // lBold
      if( hb_parl( 10 ) )
      {
         fnWeight = FW_BOLD;
      }
      else
      {
         fnWeight = FW_NORMAL;
      }

      // lItalic
      if( hb_parl( 11 ) )
      {
         fdwItalic = TRUE;
      }
      else
      {
         fdwItalic = FALSE;
      }

      // lUnderLine
      if( hb_parl( 12 ) )
      {
         fdwUnderline = TRUE;
      }
      else
      {
         fdwUnderline = FALSE;
      }

      // lStrikeOut
      if( hb_parl( 13 ) )
      {
         fdwStrikeOut = TRUE;
      }
      else
      {
         fdwStrikeOut = FALSE;
      }

      // lColor
      if( hb_parl( 14 ) )
      {
         r = hb_parni( 6 );
         g = hb_parni( 7 );
         b = hb_parni( 8 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      // lAngle
      if( hb_parl( 17 ) )
      {
         nAngle = hb_parnl( 18 );
      }
      else
      {
         nAngle = 0;
      }

      // lWidth
      if( hb_parl( 19 ) )
      {
         nWidth = hb_parnl( 20 );
      }
      else
      {
         nWidth = 0;
      }

      // lFontname
      if( hb_parl( 15 ) )
      {
         strcpy( FontName, hb_parc( 4 ) );
      }
      else
      {
         strcpy( FontName, "Arial" );
      }

      // lFontSize
      if( hb_parl( 16 ) )
      {
         FontSize = hb_parni( 5 );
      }
      else
      {
         FontSize = 10;
      }

      FontHeight = -MulDiv( FontSize, GetDeviceCaps( hdcPrint, LOGPIXELSY ), 72 );

      hfont = CreateFont( FontHeight,
                          nWidth,
                          nAngle,
                          nAngle,
                          fnWeight,
                          fdwItalic,
                          fdwUnderline,
                          fdwStrikeOut,
                          s_charset,
                          OUT_TT_PRECIS,
                          CLIP_DEFAULT_PRECIS,
                          DEFAULT_QUALITY,
                          FF_DONTCARE,
                          FontName );

      hgdiobj = SelectObject( hdcPrint, hfont );

      SetTextColor( hdcPrint, RGB( r, g, b ) );
      SetBkMode( hdcPrint, TRANSPARENT );

      TextOut( hdcPrint,
               ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
               ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
               hb_parc( 9 ),
               hb_parclen( 9 ) );

      SelectObject( hdcPrint, hgdiobj );
      DeleteObject( hfont );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_MULTILINE_PRINT )          /* _HMG_PRINTER_C_MultiLine_Print( hdcPrint, nRow, nCol, cFontName, nFontSize, nRed, nGreen, nBlue, cText, lBold, lItalic, lUnderline, lStrikeOut, lColor, lFontName, lFontSize, nToRow, nToCol, lAngle, nAngle, lWidth, nWidth, nAlign ) -> NIL */
{
   HGDIOBJ hgdiobj;
   char FontName[ 32 ];
   int FontSize;
   DWORD fdwItalic;
   DWORD fdwUnderline;
   DWORD fdwStrikeOut;
   RECT rect;
   int fnWeight;
   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   long nAngle;
   long nWidth ;
   int toy = hb_parni( 17 );
   int tox = hb_parni( 18 );
   HFONT hfont;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   int FontHeight;
   UINT uFormat = 0;

   if( hdcPrint != 0 )
   {
      // lBold
      if( hb_parl( 10 ) )
      {
         fnWeight = FW_BOLD;
      }
      else
      {
         fnWeight = FW_NORMAL;
      }

      // lItalic
      if( hb_parl( 11 ) )
      {
         fdwItalic = TRUE;
      }
      else
      {
         fdwItalic = FALSE;
      }

      // lUnderLine
      if( hb_parl( 12 ) )
      {
         fdwUnderline = TRUE;
      }
      else
      {
         fdwUnderline = FALSE;
      }

      // lStrikeOut
      if( hb_parl( 13 ) )
      {
         fdwStrikeOut = TRUE;
      }
      else
      {
         fdwStrikeOut = FALSE;
      }

      // lColor
      if( hb_parl( 14 ) )
      {
         r = hb_parni( 6 );
         g = hb_parni( 7 );
         b = hb_parni( 8 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      // lAngle
      if( hb_parl( 19 ) )
      {
         nAngle = hb_parnl( 20 );
      }
      else
      {
         nAngle = 0;
      }

      // lWidth
      if( hb_parl( 21 ) )
      {
         nWidth = hb_parnl( 22 );
      }
      else
      {
         nWidth = 0;
      }

      // lFontname
      if( hb_parl( 15 ) )
      {
         strcpy( FontName, hb_parc( 4 ) );
      }
      else
      {
         strcpy( FontName, "Arial" );
      }

      // lFontSize
      if( hb_parl( 16 ) )
      {
         FontSize = hb_parni( 5 );
      }
      else
      {
         FontSize = 10;
      }

      FontHeight = -MulDiv( FontSize, GetDeviceCaps( hdcPrint, LOGPIXELSY ), 72 );

      hfont = CreateFont( FontHeight,
                          nWidth,
                          nAngle,
                          nAngle,
                          fnWeight,
                          fdwItalic,
                          fdwUnderline,
                          fdwStrikeOut,
                          s_charset,
                          OUT_TT_PRECIS,
                          CLIP_DEFAULT_PRECIS,
                          DEFAULT_QUALITY,
                          FF_DONTCARE,
                          FontName );

      if( hb_parni( 23 ) == 0 )
         uFormat = DT_END_ELLIPSIS | DT_NOPREFIX | DT_WORDBREAK | DT_LEFT;
      else if( hb_parni( 23 ) == 2 )
         uFormat = DT_END_ELLIPSIS | DT_NOPREFIX | DT_WORDBREAK | DT_RIGHT;
      else if( hb_parni( 23 ) == 6 )
         uFormat = DT_END_ELLIPSIS | DT_NOPREFIX | DT_WORDBREAK | DT_CENTER;

      hgdiobj = SelectObject( hdcPrint, hfont );

      SetTextColor( hdcPrint, RGB( r, g, b ) );
      SetBkMode( hdcPrint, TRANSPARENT );

      rect.left   = (long) ( ( x   * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ) );
      rect.top    = (long) ( ( y   * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );
      rect.right  = (long) ( ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ) );
      rect.bottom = (long) ( ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      DrawText( hdcPrint,
                hb_parc( 9 ),
                hb_parclen( 9 ),
                &rect,
                uFormat );

      SelectObject( hdcPrint, hgdiobj );
      DeleteObject( hfont );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_ENDPAGE )          /* _HMG_PRINTER_EndPage( hdcPrint ) -> NIL */
{
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   int iRet = 0;

   if( hdcPrint != 0 )
   {
      iRet = EndPage( hdcPrint );
   }

   hb_retl( iRet > 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_ENDDOC )          /* _HMG_PRINTER_EndDoc( hdcPrint ) -> NIL */
{
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   int iRet = 0;

   if( hdcPrint != 0 )
   {
      iRet = EndDoc( hdcPrint );
   }

   hb_retl( iRet > 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_DELETEDC )          /* _HMG_PRINTER_DeleteDC( hdcPrint ) -> NIL */
{
   HDC hdcPrint = (HDC) HB_PARNL( 1 );

   DeleteDC( hdcPrint );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_PRINTDIALOG )          /* _HMG_PRINTER_PrintDialog() -> { hdcPrint, cName, nCopies, nCollate, nError } */
{
   PRINTDLG pd;
   LPDEVMODE pDevMode;
   pd.lStructSize = sizeof( PRINTDLG );
   pd.hDevMode = ( HANDLE ) NULL;
   pd.hDevNames = ( HANDLE ) NULL;
   pd.Flags = PD_RETURNDC | PD_PRINTSETUP;
   pd.hwndOwner = GetActiveWindow();
   pd.hDC = (HDC) NULL;
   pd.nFromPage = 1;
   pd.nToPage = 1;
   pd.nMinPage = 0;
   pd.nMaxPage = 0;
   pd.nCopies = 1;
   pd.hInstance = (HINSTANCE) NULL;
   pd.lCustData = 0L;
   pd.lpfnPrintHook = ( LPPRINTHOOKPROC ) NULL;
   pd.lpfnSetupHook = ( LPSETUPHOOKPROC ) NULL;
   pd.lpPrintTemplateName = (LPSTR) NULL;
   pd.lpSetupTemplateName = (LPSTR) NULL;
   pd.hPrintTemplate = ( HANDLE ) NULL;
   pd.hSetupTemplate = ( HANDLE ) NULL;

   if( PrintDlg( &pd ) )
   {
      pDevMode = ( LPDEVMODE ) GlobalLock( pd.hDevMode );

      hb_reta( 5 );
      HB_STORNL3( (LONG_PTR) pd.hDC, -1, 1 );
      HB_STORC( (char *) pDevMode->dmDeviceName, -1, 2 );
      HB_STORNI( pDevMode->dmCopies, -1, 3 );
      HB_STORNI( pDevMode->dmCollate, -1, 4 );
      HB_STORNI( 0, -1, 5 );
      HB_STORNI( pDevMode->dmOrientation, -1, 6 );
      HB_STORNI( pDevMode->dmPaperSize, -1, 7 );
      HB_STORNI( pDevMode->dmPaperLength, -1, 8 );
      HB_STORNI( pDevMode->dmPaperWidth, -1, 9 );
      HB_STORNI( pDevMode->dmDefaultSource, -1, 10 );
      HB_STORNI( pDevMode->dmPrintQuality, -1, 11 );
      HB_STORNI( pDevMode->dmColor, -1, 12 );
      HB_STORNI( pDevMode->dmDuplex, -1, 13 );
      HB_STORNI( pDevMode->dmScale, -1, 14 );

      GlobalUnlock( pd.hDevMode );
   }
   else
   {
      hb_reta( 5 );
      HB_STORNL3( 0, -1, 1 );
      HB_STORC( "", -1, 2 );
      HB_STORNI( 0, -1, 3 );
      HB_STORNI( 0, -1, 4 );
      HB_STORNI( ERR_PRINTDLG, -1, 5 );
      HB_STORNI( 0, -1, 6 );
      HB_STORNI( 0, -1, 7 );
      HB_STORNI( 0, -1, 8 );
      HB_STORNI( 0, -1, 9 );
      HB_STORNI( 0, -1, 10 );
      HB_STORNI( 0, -1, 11 );
      HB_STORNI( 0, -1, 12 );
      HB_STORNI( 0, -1, 13 );
      HB_STORNI( 0, -1, 14 );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_APRINTERS )          /* _HMG_PRINTER_C_aPrinters() -> { cPrinterNames } or {} */
{
   OSVERSIONINFO osVer;
   DWORD level;
   DWORD flags;
   DWORD dwSize = 0;
   DWORD dwPrinters = 0;
   DWORD i;
   char * pBuffer;
   char * cBuffer;
   PRINTER_INFO_4 * pInfo_4;
   PRINTER_INFO_5 * pInfo_5;

   osVer.dwOSVersionInfoSize = sizeof( osVer );
   if( GetVersionEx( &osVer ) )
   {
      switch( osVer.dwPlatformId )
      {
         case VER_PLATFORM_WIN32_NT:
            flags = PRINTER_ENUM_CONNECTIONS | PRINTER_ENUM_LOCAL;
            level = 4;
            break;

         default:
            flags = PRINTER_ENUM_LOCAL;
            level = 5;
            break;
      }
      EnumPrinters( flags, NULL, level, NULL, 0, &dwSize, &dwPrinters );
      pBuffer = (char *) GlobalAlloc( GPTR, dwSize );
      if( pBuffer == NULL )
      {
         hb_reta( 0 );
         GlobalFree( pBuffer );
         return;
      }
      EnumPrinters( flags, NULL, level, (BYTE *) pBuffer, dwSize, &dwSize, &dwPrinters );
      if( dwPrinters == 0 )
      {
         hb_reta( 0 );
         GlobalFree( pBuffer );
         return;
      }
      switch( osVer.dwPlatformId )
      {
         case VER_PLATFORM_WIN32_NT:
            pInfo_4 = ( PRINTER_INFO_4 * ) pBuffer;
            hb_reta( dwPrinters );
            for( i = 0; i < dwPrinters; i++, pInfo_4++)
            {
               cBuffer = (char *) GlobalAlloc( GPTR, 256 );
               strcat( cBuffer, pInfo_4->pPrinterName );
               HB_STORC( cBuffer, -1, i + 1 );
               GlobalFree( cBuffer );
            }
            GlobalFree( pBuffer );
            break;
         default:
            pInfo_5 = ( PRINTER_INFO_5 * ) pBuffer;
            hb_reta( dwPrinters );
            for( i = 0; i < dwPrinters; i++, pInfo_5++)
            {
               cBuffer = (char *) GlobalAlloc( GPTR, 256 );
               strcat( cBuffer, pInfo_5->pPrinterName );
               HB_STORC( cBuffer, -1, i + 1 );
               GlobalFree( cBuffer );
            }
            GlobalFree( pBuffer );
            break;
      }
   }
   else
   {
      hb_reta( 0 );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_RECTANGLE )          /* _HMG_PRINTER_C_Rectangle( hdcPrint, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, nRedB, nGreenB, nBlueB, lNoPen, lNoBrush ) -> NIL */
{
   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   int tox = hb_parni( 5 );
   int toy = hb_parni( 4 );
   int width;
   int nStyle;
   int br;
   int bg;
   int bb;
   int nBstyle;
   long nBhatch;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HGDIOBJ hgdiobj1 = NULL;
   HGDIOBJ hgdiobj2 = NULL;
   HPEN hpen = NULL;
   LOGBRUSH pbr;
   HBRUSH hbr = NULL;
   RECT rect;
   BOOL bNoPen = hb_parl( 20 );
   BOOL bNoBrush = hb_parl( 21 );

   if( hdcPrint != 0 )
   {
      // lWidth
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // lColor
      if( hb_parl( 11 ) )
      {
         r = hb_parni( 7 );
         g = hb_parni( 8 );
         b = hb_parni( 9 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      // lStyle
      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      // lBrushStyle
      if( hb_parl( 14 ) )
      {
         nBstyle = BS_HATCHED;
         nBhatch = hb_parni( 15 );   // nBrushStyle
      }
      else
      {
         // lBrushColor
         if( hb_parl( 16 ) )   
         {
            nBstyle = BS_SOLID;
         }
         else
         {
            nBstyle = BS_NULL;
         }
         nBhatch = 0 ;
      }

      // lBrushColor
      if( hb_parl( 16 ) )
      {
         br = hb_parni( 17 );
         bg = hb_parni( 18 );
         bb = hb_parni( 19 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBstyle;
      pbr.lbColor = (COLORREF) RGB( br, bg, bb );
      pbr.lbHatch = nBhatch;

      if( ! bNoBrush )
      {
         hbr = CreateBrushIndirect( &pbr );
         hgdiobj1 = SelectObject( hdcPrint, hbr );
      }

      if( ! bNoPen )
      {
         hpen = CreatePen( nStyle, ( width * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r, g, b ) );
         hgdiobj2 = SelectObject( hdcPrint, hpen );
      }

      rect.left   = ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX );
      rect.top    = ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY );
      rect.right  = ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX );
      rect.bottom = ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY );

      Rectangle( hdcPrint, rect.left, rect.top, rect.right, rect.bottom );

      if( ! bNoBrush )
      {
         SelectObject( hdcPrint, hgdiobj1 );
         DeleteObject( hbr );
      }

      if( ! bNoPen )
      {
         SelectObject( hdcPrint, hgdiobj2 );
         DeleteObject( hpen );
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_ROUNDRECTANGLE )          /* _HMG_PRINTER_C_RoundRectangle( hdcPrint, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, nRedB, nGreenB, nBlueB, lNoPen, lNoBrush ) -> NIL */
{
   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   int tox = hb_parni( 5 );
   int toy = hb_parni( 4 );
   int width;
   int w, h, p;
   int nStyle;
   int br;
   int bg;
   int bb;
   int nBstyle;
   long nBhatch;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HGDIOBJ hgdiobj1 = NULL;
   HGDIOBJ hgdiobj2 = NULL;
   HPEN hpen = NULL;
   LOGBRUSH pbr;
   HBRUSH hbr = NULL;
   BOOL bNoPen = hb_parl( 20 );
   BOOL bNoBrush = hb_parl( 21 );

   if( hdcPrint != 0 )
   {
      // lWidth
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // lColor
      if( hb_parl( 11 ) )
      {
         r = hb_parni( 7 );
         g = hb_parni( 8 );
         b = hb_parni( 9 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      // lStyle
      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      // lBrushStyle
      if( hb_parl( 14 ) )
      {
         nBstyle = BS_HATCHED;
         nBhatch = hb_parni( 15 );   // nBrushStyle
      }
      else
      {
         // lBrushColor
         if( hb_parl( 16 ) )
         {
            nBstyle = BS_SOLID;
         }
         else
         {
            nBstyle = BS_NULL;
         }
         nBhatch = 0 ;
      }

      // lBrushColor
      if( hb_parl( 16 ) )
      {
         br = hb_parni( 17 );
         bg = hb_parni( 18 );
         bb = hb_parni( 19 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBstyle;
      pbr.lbColor = (COLORREF) RGB( br, bg, bb );
      pbr.lbHatch = nBhatch;

      if( ! bNoBrush )
      {
         hbr = CreateBrushIndirect( &pbr );
         hgdiobj1 = SelectObject( hdcPrint, hbr );
      }

      if( ! bNoPen )
      {
         hpen = CreatePen( nStyle, ( width * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r, g, b ) );
         hgdiobj2 = SelectObject( hdcPrint, hpen );
      }

      w = ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 );
      h = ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 );
      p = ( w + h ) / 2;
      p = p / 10;

      RoundRect( hdcPrint,
                 ( x   * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
                 ( y   * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
                 ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
                 ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
                 p,
                 p );

      if( ! bNoBrush )
      {
         SelectObject( hdcPrint, hgdiobj1 );
         DeleteObject( hbr );
      }

      if( ! bNoPen )
      {
         SelectObject( hdcPrint, hgdiobj2 );
         DeleteObject( hpen );
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_FILL )          /* _HMG_PRINTER_C_Fill( hdcPrint, nRow, nCol, nToRow, nToCol, nRed, nGreen, nBlue, lColor ) -> NIL */
{
   int r;
   int g;
   int b;
   int x = hb_parnl( 3 );
   int y = hb_parnl( 2 );
   int tox = hb_parnl( 5 );
   int toy = hb_parnl( 4 );
   RECT rect;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HBRUSH hBrush;

   if( hdcPrint != 0 )
   {
      // lColor
      if( hb_parl( 9 ) )
      {
         r = hb_parni( 6 );
         g = hb_parni( 7 );
         b = hb_parni( 8 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      rect.left   = (long) ( ( x   * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ) );
      rect.top    = (long) ( ( y   * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );
      rect.right  = (long) ( ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ) );
      rect.bottom = (long) ( ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      hBrush = CreateSolidBrush( RGB( r, g, b ) );
      hgdiobj = SelectObject( hdcPrint, hBrush );

      FillRect( hdcPrint, &rect, hBrush );

      SelectObject( hdcPrint, hgdiobj );
      DeleteObject( hBrush );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_LINE)          /* _HMG_PRINTER_C_Line( hdcPrint, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle ) -> NIL */
{
   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   int tox = hb_parni( 5 );
   int toy = hb_parni( 4 );
   int width;
   int nStyle;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;

   if( hdcPrint != 0 )
   {
      // lWidth
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // lColor
      if( hb_parl( 11 ) )
      {
         r = hb_parni( 7 );
         g = hb_parni( 8 );
         b = hb_parni( 9 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      // lStyle
      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      hpen = CreatePen( nStyle, ( width * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r, g, b ) );

      hgdiobj = SelectObject( hdcPrint, hpen );

      MoveToEx( hdcPrint,
                ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
                ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
                NULL );

      LineTo( hdcPrint,
              ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
              ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      SelectObject( hdcPrint, hgdiobj );
      DeleteObject( hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_SETPRINTERPROPERTIES )          /* _HMG_PRINTER_C_SetPrinterProperties( cPrinter, nOrientation, nPaperSize, nPaperLength, nPaperWidth, nCopies, nDefaultSource, nQuality, nColor, nDuplex, nCollate, nScale, lSilent, lIgnore, lGlobal ) -> { hdcPrint, cPrinter, nCopies, nCollate, nError, nOrientation, nPaperSize, nPaperLength, nPaperWidth, nDefaultSource, nQuality, nColor, nDuplex, nScale } */
{
   HANDLE hPrinter = NULL;
   DWORD dwNeeded = 0;
   PRINTER_INFO_2 * pi2;
   DEVMODE *pDevMode = NULL;
   BOOL bFlag;
   BOOL bVerbose = ! hb_parl( 13 );
   BOOL bAbort = ! hb_parl( 14 );
   BOOL bGlobal = hb_parl( 15 );
   long lFlag;
   HDC hdcPrint;
   int error = 0;

   // Get the current settings of the printer's driver

   bFlag = OpenPrinter( (LPTSTR) HB_UNCONST( hb_parc( 1 ) ), &hPrinter, NULL );

   if( ! bFlag || ( hPrinter == NULL ) )
   {
      if( bVerbose )
      {
         MessageBox( 0, "Printer Configuration Failed! (ERR_OPEN_PRINTER)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      }
      hb_reta( 5 );
      HB_STORNL3( 0, -1, 1 );
      HB_STORC( "", -1, 2 );
      HB_STORNI( 0, -1, 3 );
      HB_STORNI( 0, -1, 4 );
      HB_STORNI( ERR_OPEN_PRINTER, -1, 5 );
      return;
   }

   SetLastError( 0 );

   bFlag = GetPrinter( hPrinter, 2, 0, 0, &dwNeeded );

   if( ( ( ! bFlag ) && ( GetLastError() != ERROR_INSUFFICIENT_BUFFER ) ) || ( dwNeeded == 0 ) )
   {
      ClosePrinter( hPrinter );
      if( bVerbose )
      {
         MessageBox( 0, "Printer Configuration Failed! (ERR_GET_PRINTER_BUFFER_SIZE)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      }
      hb_reta( 5 );
      HB_STORNL3( 0, -1, 1 );
      HB_STORC( "", -1, 2 );
      HB_STORNI( 0, -1, 3 );
      HB_STORNI( 0, -1, 4 );
      HB_STORNI( ERR_GET_PRINTER_BUFFER_SIZE, -1, 5 );
      return;
   }

   pi2 = ( PRINTER_INFO_2 * ) GlobalAlloc( GPTR, dwNeeded );

   if( pi2 == NULL )
   {
      ClosePrinter( hPrinter );
      if( bVerbose )
      {
         MessageBox( 0, "Printer Configuration Failed! (ERR_ALLOCATE_PRINTER_BUFFER)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      }
      hb_reta( 5 );
      HB_STORNL3( 0, -1, 1 );
      HB_STORC( "", -1, 2 );
      HB_STORNI( 0, -1, 3 );
      HB_STORNI( 0, -1, 4 );
      HB_STORNI( ERR_ALLOCATE_PRINTER_BUFFER, -1, 5 );
      return;
   }

   bFlag = GetPrinter( hPrinter, 2, ( LPBYTE ) pi2, dwNeeded, &dwNeeded );

   if( ! bFlag )
   {
      GlobalFree( pi2 );
      ClosePrinter( hPrinter );
      if( bVerbose )
      {
         MessageBox( 0, "Printer Configuration Failed! (ERR_GET_PRINTER_SETTINGS)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      }
      hb_reta( 5 );
      HB_STORNL3( 0, -1, 1 );
      HB_STORC( "", -1, 2 );
      HB_STORNI( 0, -1, 3 );
      HB_STORNI( 0, -1, 4 );
      HB_STORNI( ERR_GET_PRINTER_SETTINGS, -1, 5 );
      return;
   }

   // If this condition is true the printer is unusable until the driver is reinstalled successfully

   if( pi2->pDevMode == NULL)
   {
      dwNeeded = DocumentProperties( NULL, hPrinter, (LPTSTR) HB_UNCONST( hb_parc( 1 ) ), NULL, NULL, 0 );

      if( dwNeeded <= 0 )
      {
         GlobalFree( pi2 );
         ClosePrinter( hPrinter );
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed! (ERR_GET_DOCUMENT_BUFFER_SIZE)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         hb_reta( 5 );
         HB_STORNL3( 0, -1, 1 );
         HB_STORC( "", -1, 2 );
         HB_STORNI( 0, -1, 3 );
         HB_STORNI( 0, -1, 4 );
         HB_STORNI( ERR_GET_DOCUMENT_BUFFER_SIZE, -1, 5 );
         return;
      }

      pDevMode = ( DEVMODE * ) GlobalAlloc( GPTR, dwNeeded );

      if( pDevMode == NULL )
      {
         GlobalFree( pi2 );
         ClosePrinter( hPrinter );
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed! (ERR_ALLOCATE_DOCUMENT_BUFFER)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         hb_reta( 5 );
         HB_STORNL3( 0, -1, 1 );
         HB_STORC( "", -1, 2 );
         HB_STORNI( 0, -1, 3 );
         HB_STORNI( 0, -1, 4 );
         HB_STORNI( ERR_ALLOCATE_DOCUMENT_BUFFER, -1, 5 );
         return;
      }

      lFlag = DocumentProperties( NULL, hPrinter, (LPTSTR) HB_UNCONST( hb_parc( 1 ) ), pDevMode, NULL, DM_OUT_BUFFER );

      if( lFlag != IDOK || pDevMode == NULL )
      {
         GlobalFree( pDevMode );
         GlobalFree( pi2 );
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed! (ERR_GET_DOCUMENT_SETTINGS)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         hb_reta( 5 );
         HB_STORNL3( 0, -1, 1 );
         HB_STORC( "", -1, 2 );
         HB_STORNI( 0, -1, 3 );
         HB_STORNI( 0, -1, 4 );
         HB_STORNI( ERR_GET_DOCUMENT_SETTINGS, -1, 5 );
         return;
      }

      pi2->pDevMode = pDevMode;
   }

   // Set new values if the driver supports changing the properties

   if( hb_parni( 2 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_ORIENTATION )
      {
         pi2->pDevMode->dmOrientation = ( short ) hb_parni( 2 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: ORIENTATION Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_ORIENTATION_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_ORIENTATION_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 3 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_PAPERSIZE )
      {
         pi2->pDevMode->dmPaperSize = ( short ) hb_parni( 3 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: PAPERSIZE Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_PAPERSIZE_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_PAPERSIZE_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 4 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_PAPERLENGTH )
      {
         pi2->pDevMode->dmPaperLength = ( short ) ( hb_parni( 4 ) * 10 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: PAPERLENGTH Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_PAPERLENGTH_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_PAPERLENGTH_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 5 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_PAPERWIDTH )
      {
         pi2->pDevMode->dmPaperWidth = ( short ) ( hb_parni( 5 ) * 10 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: PAPERWIDTH Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_PAPERWIDTH_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_PAPERWIDTH_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 6 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_COPIES )
      {
         pi2->pDevMode->dmCopies = ( short ) hb_parni( 6 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: COPIES Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_COPIES_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_COPIES_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 7 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_DEFAULTSOURCE )
      {
         pi2->pDevMode->dmDefaultSource = ( short ) hb_parni( 7 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: DEFAULTSOURCE Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_DEFAULTSOURCE_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_DEFAULTSOURCE_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 8 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_PRINTQUALITY )
      {
         pi2->pDevMode->dmPrintQuality = ( short ) hb_parni( 8 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: QUALITY Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_QUALITY_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_QUALITY_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 9 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_COLOR )
      {
         pi2->pDevMode->dmColor = ( short ) hb_parni( 9 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: COLOR Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_COLOR_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_COLOR_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 10 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_DUPLEX )
      {
         pi2->pDevMode->dmDuplex = ( short ) hb_parni( 10 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: DUPLEX Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_DUPLEX_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_DUPLEX_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 11 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_COLLATE )
      {
         pi2->pDevMode->dmCollate = ( short ) hb_parni( 11 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: COLLATE Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_COLLATE_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_COLLATE_NOT_SUPPORTED;
         }
      }
   }

   if( hb_parni( 12 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_SCALE )
      {
         pi2->pDevMode->dmScale = ( short ) hb_parni( 12 );
      }
      else
      {
         if( bVerbose )
         {
            MessageBox( 0, "Printer Configuration Failed: SCALE Property Not Supported By Selected Printer", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
         }
         if( bAbort )
         {
            GlobalFree( pDevMode );
            GlobalFree( pi2 );
            ClosePrinter( hPrinter );
            hb_reta( 5 );
            HB_STORNL3( 0, -1, 1 );
            HB_STORC( "", -1, 2 );
            HB_STORNI( 0, -1, 3 );
            HB_STORNI( 0, -1, 4 );
            HB_STORNI( ERR_SCALE_NOT_SUPPORTED, -1, 5 );
            return;
         }
         else
         {
            error = error | ERR_SCALE_NOT_SUPPORTED;
         }
      }
   }

   // Change the driver's configuration

   lFlag = DocumentProperties( NULL, hPrinter, (LPTSTR) HB_UNCONST( hb_parc( 1 ) ), pi2->pDevMode, pi2->pDevMode, DM_IN_BUFFER | DM_OUT_BUFFER );

   if( lFlag != IDOK )
   {
      GlobalFree( pDevMode );
      GlobalFree( pi2 );
      ClosePrinter( hPrinter );
      if( bVerbose )
      {
         MessageBox( 0, "Printer Configuration Failed! (ERR_SET_DOCUMENT_SETTINGS)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      }
      hb_reta( 5 );
      HB_STORNL3( 0, -1, 1 );
      HB_STORC( "", -1, 2 );
      HB_STORNI( 0, -1, 3 );
      HB_STORNI( 0, -1, 4 );
      HB_STORNI( ERR_SET_DOCUMENT_SETTINGS, -1, 5 );
      return;
   }

   // Make changes global

   if( bGlobal )
   {
      SetPrinter( hPrinter, 2, ( LPBYTE ) pi2, 0 );
   }

   // Create a DC to handle the print job

   hdcPrint = CreateDC( NULL, hb_parc( 1 ), NULL, pi2->pDevMode );

   if( hdcPrint == NULL )
   {
      GlobalFree( pDevMode );
      GlobalFree( pi2 );
      ClosePrinter( hPrinter );
      if( bVerbose )
      {
         MessageBox( 0, "Printer Configuration Failed! (ERR_CREATING_DC)", "Error!", MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL );
      }
      hb_reta( 5 );
      HB_STORNL3( 0, -1, 1 );
      HB_STORC( "", -1, 2 );
      HB_STORNI( 0, -1, 3 );
      HB_STORNI( 0, -1, 4 );
      HB_STORNI( ERR_CREATING_DC, -1, 5 );
      return;
   }

   hb_reta( 14 );
   HB_STORNL3( (LONG_PTR) hdcPrint, -1, 1 );
   HB_STORC( hb_parc( 1 ), -1, 2 );
   HB_STORNI( (int) pi2->pDevMode->dmCopies, -1, 3 );
   HB_STORNI( (int) pi2->pDevMode->dmCollate, -1, 4 );
   HB_STORNI( error, -1, 5 );
   HB_STORNI( (int) pi2->pDevMode->dmOrientation, -1, 6 );
   HB_STORNI( (int) pi2->pDevMode->dmPaperSize, -1, 7 );
   HB_STORNI( (int) pi2->pDevMode->dmPaperLength, -1, 8 );
   HB_STORNI( (int) pi2->pDevMode->dmPaperWidth, -1, 9 );
   HB_STORNI( (int) pi2->pDevMode->dmDefaultSource, -1, 10 );
   HB_STORNI( (int) pi2->pDevMode->dmPrintQuality, -1, 11 );
   HB_STORNI( (int) pi2->pDevMode->dmColor, -1, 12 );
   HB_STORNI( (int) pi2->pDevMode->dmDuplex, -1, 13 );
   HB_STORNI( (int) pi2->pDevMode->dmScale, -1, 14 );

   GlobalFree( pDevMode );
   GlobalFree( pi2 );
   ClosePrinter( hPrinter );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_GETJOBINFO )          /* FUNCTION _HMG_PRINTER_C_GetJobInfo( cPrinterName, nJobID ) -> { nJobID, cPrinterName, cMachineName, cUserName, cDocument, cDataType, cStatus, nStatus, nPriorityLevel, nPositionPrintQueue, nTotalPages, nPagesPrinted, cLocalDate, cLocalTime } */
{
   HANDLE hPrinter = NULL;
   DWORD dwNeeded = 0;
   BOOL bFlag;
   JOB_INFO_1 * pj1;
   DWORD nJobID = ( DWORD ) hb_parni( 2 );
   char cDateTime[ 256 ];
   SYSTEMTIME LocalSystemTime;

   bFlag = OpenPrinter( (LPTSTR) HB_UNCONST( hb_parc( 1 ) ), &hPrinter, NULL );

   if( bFlag || hPrinter != NULL )
   {
      SetLastError( 0 );

      bFlag = GetJob( hPrinter, nJobID, 1, NULL, 0, &dwNeeded );

      if( ( bFlag || ( GetLastError() == ERROR_INSUFFICIENT_BUFFER ) ) && ( dwNeeded != 0 ) )
      {
         pj1 = ( JOB_INFO_1 * ) GlobalAlloc( GPTR, dwNeeded );

         if( GetJob( hPrinter, nJobID, 1, ( LPBYTE ) pj1, dwNeeded, &dwNeeded ) )
         {
            hb_reta( 14 );
            HB_STORNI( pj1->JobId, -1, 1 );
            HB_STORC( pj1->pPrinterName, -1, 2 );
            HB_STORC( pj1->pMachineName, -1, 3 );
            HB_STORC( pj1->pUserName, -1, 4 );
            HB_STORC( pj1->pDocument, -1, 5 );
            HB_STORC( pj1->pDatatype, -1, 6 );
            HB_STORC( pj1->pStatus, -1, 7 );
            HB_STORNI( pj1->Status, -1, 8 );
            HB_STORNI( pj1->Priority, -1, 9 );
            HB_STORNI( pj1->Position, -1, 10 );
            HB_STORNI( pj1->TotalPages, -1, 11 );
            HB_STORNI( pj1->PagesPrinted, -1, 12 );

            SystemTimeToTzSpecificLocalTime( NULL, &pj1->Submitted, &LocalSystemTime );

            wsprintf( cDateTime, "%02d/%02d/%02d", LocalSystemTime.wYear, LocalSystemTime.wMonth, LocalSystemTime.wDay );
            HB_STORC( cDateTime, -1, 13 );

            wsprintf( cDateTime, "%02d:%02d:%02d", LocalSystemTime.wHour, LocalSystemTime.wMinute, LocalSystemTime.wSecond );
            HB_STORC( cDateTime, -1, 14 );
         }
         else
         {
            hb_reta( 0 );
         }

         GlobalFree( pj1 );
      }
      else
      {
         hb_reta( 0 );
      }

      ClosePrinter( hPrinter );
   }
   else
   {
      hb_reta( 0 );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_GETSTATUS )          /* _HMG_PRINTER_C_GetStatus( cPrinter ) -> nStatus */
{
   HANDLE hPrinter = NULL;
   DWORD dwNeeded = 0;
   BOOL bFlag;
   PRINTER_INFO_6 * pi6;

   bFlag = OpenPrinter( (LPTSTR) HB_UNCONST( hb_parc( 1 ) ), &hPrinter, NULL );

   if( bFlag || hPrinter != NULL )
   {
      SetLastError( 0 );

      bFlag = GetPrinter( hPrinter, 2, 0, 0, &dwNeeded );

      if( ( bFlag || ( GetLastError() == ERROR_INSUFFICIENT_BUFFER ) ) && ( dwNeeded != 0 ) )
      {
         pi6 = ( PRINTER_INFO_6 * ) GlobalAlloc( GPTR, dwNeeded );

         if( pi6 != NULL )
         {
            bFlag = GetPrinter( hPrinter, 6, ( LPBYTE ) pi6, dwNeeded, &dwNeeded );

            if( bFlag )
            {
               hb_retnl( pi6->dwStatus );
               return;
            }

            GlobalFree( pi6 );
         }
      }

      ClosePrinter( hPrinter );
   }

   hb_retnl( ERR_PRINTER_STATUS_NOT_AVAILABLE );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_STARTPAGE_PREVIEW )          /* _HMG_PRINTER_StartPage_Preview( hdcPrint, cName ) -> hdcEmf */
{
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HDC hdcEmf;
   RECT emfrect;

   SetRect( &emfrect, 0, 0, GetDeviceCaps( hdcPrint, HORZSIZE ) * 100, GetDeviceCaps( hdcPrint, VERTSIZE) * 100 );

   hdcEmf = CreateEnhMetaFile( hdcPrint, hb_parc( 2 ), &emfrect, "" );

   HB_RETNL( (LONG_PTR) hdcEmf );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_ENDPAGE_PREVIEW )          /* _HMG_PRINTER_EndPage_Preview( hdcEmf ) -> NIL */
{
   DeleteEnhMetaFile( CloseEnhMetaFile( (HDC) HB_PARNL ( 1 ) ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_SHOWPAGE )          /* _HMG_PRINTER_ShowPage( cEmf, hWnd, hdcPrint, nFactor, nDz, nDx, nDy ) -> NIL */
{
   HENHMETAFILE hemf;
   HWND hWnd = HWNDparam( 2 );
   HDC hdcPrint = (HDC) HB_PARNL( 3 );
   HDC hDC;
   RECT rct;
   RECT aux;
   int zw;
   int zh;
   int ClientWidth;
   int ClientHeight;
   int xOffset;
   int yOffset;

   hemf = GetEnhMetaFile( hb_parc( 1 ) );

   hDC = GetDC( hWnd );

   GetClientRect( hWnd, &rct );

   ClientWidth = rct.right - rct.left;
   ClientHeight = rct.bottom - rct.top;

   zw = hb_parni( 5 ) * GetDeviceCaps( hdcPrint, HORZSIZE ) / 1000;
   zh = hb_parni( 5 ) * GetDeviceCaps( hdcPrint, VERTSIZE ) / 1000;

   xOffset = ( ClientWidth - ( GetDeviceCaps( hdcPrint, HORZSIZE ) * hb_parni( 4 ) / 10000 ) ) / 2;
   yOffset = ( ClientHeight - ( GetDeviceCaps( hdcPrint, VERTSIZE ) * hb_parni( 4 ) / 10000 ) ) / 2;

   SetRect( &rct,
            xOffset + hb_parni( 6 ) - zw,
            yOffset + hb_parni( 7 ) - zh,
            xOffset + ( GetDeviceCaps( hdcPrint, HORZSIZE ) * hb_parni( 4 ) / 10000 ) + hb_parni( 6 ) + zw,
            yOffset + ( GetDeviceCaps( hdcPrint, VERTSIZE ) * hb_parni( 4 ) / 10000 ) + hb_parni( 7 ) + zh );

   FillRect( hDC, &rct, ( HBRUSH ) RGB( 255, 255, 255 ) );

   PlayEnhMetaFile( hDC, hemf, &rct );

   // Remove prints outside printable area

   // Right
   aux.top = 0;
   aux.left = rct.right;
   aux.right = ClientWidth;
   aux.bottom = ClientHeight;
   FillRect( hDC, &aux, ( HBRUSH ) GetStockObject( GRAY_BRUSH ) );

   // Bottom
   aux.top = rct.bottom;
   aux.left = 0;
   aux.right = ClientWidth;
   aux.bottom = ClientHeight;
   FillRect( hDC, &aux, ( HBRUSH ) GetStockObject( GRAY_BRUSH ) );

   // Top
   aux.top = 0;
   aux.left = 0;
   aux.right = ClientWidth;
   aux.bottom = yOffset + hb_parni( 7 ) - zh;
   FillRect( hDC, &aux, ( HBRUSH ) GetStockObject( GRAY_BRUSH ) );

   // Left
   aux.top = 0;
   aux.left = 0;
   aux.right = xOffset + hb_parni( 6 ) - zw;
   aux.bottom = ClientHeight;
   FillRect( hDC, &aux, ( HBRUSH ) GetStockObject( GRAY_BRUSH ) );

   // Clean up
   DeleteEnhMetaFile( hemf );

   ReleaseDC( hWnd, hDC );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETPAGEWIDTH )          /* _HMG_PRINTER_GetPageWidth( hdcPrint ) -> nRet */
{
   hb_retni( GetDeviceCaps( (HDC) HB_PARNL( 1 ), HORZSIZE ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETPAGEHEIGHT )          /* _HMG_PRINTER_GetPageHeight( hdcPrint ) -> nRet */
{
   hb_retni( GetDeviceCaps( (HDC) HB_PARNL( 1 ), VERTSIZE ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_PRINTPAGE )          /* _HMG_PRINTER_PrintPage( hdcPrint, cFile ) -> NIL */
{
   RECT rect;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HENHMETAFILE hemf = GetEnhMetaFile( hb_parc( 2 ) );

   if( hemf != NULL )
   {
      SetRect( &rect, 0, 0, GetDeviceCaps( hdcPrint, HORZRES ), GetDeviceCaps( hdcPrint, VERTRES ) );

      if( StartPage( hdcPrint ) > 0 )
      {
         PlayEnhMetaFile( hdcPrint, hemf, &rect );

         EndPage( hdcPrint );
      }

      DeleteEnhMetaFile( hemf );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS )          /* _HMG_PRINTER_Preview_EnableScrollBars( hWnd ) -> NIL */
{
   EnableScrollBar( HWNDparam( 1 ), SB_BOTH, ESB_ENABLE_BOTH );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS )          /* _HMG_PRINTER_Preview_DisableScrollBars( hWnd ) -> NIL */
{
   EnableScrollBar( HWNDparam( 1 ), SB_BOTH, ESB_DISABLE_BOTH );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_PREVIEW_DISABLEHSCROLLBAR )          /* _HMG_PRINTER_Preview_DisableHScrollBar( hWnd ) -> NIL */
{
   EnableScrollBar( HWNDparam( 1 ), SB_HORZ, ESB_DISABLE_BOTH );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_SETVSCROLLVALUE )          /* _HMG_PRINTER_SetVScrollValue( hWnd ) -> NIL */
{
   SendMessage( HWNDparam( 1 ), WM_VSCROLL, MAKEWPARAM( SB_THUMBPOSITION, hb_parni( 2 ) ), 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETPRINTERWIDTH )          /* _HMG_PRINTER_GetPrinterWidth( hdcPrint ) -> nRet */
{
   hb_retnl( GetDeviceCaps( (HDC) HB_PARNL( 1 ), HORZSIZE ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETPRINTERHEIGHT )          /* _HMG_PRINTER_GetPrinterHeight( hdcPrint ) -> nRet */
{
   hb_retnl( GetDeviceCaps( (HDC) HB_PARNL( 1 ), VERTSIZE ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETX )          /* _HMG_PRINTER_GetPrintableAreaPhysicalOffsetX( hdcPrint ) -> nRet */
{
   hb_retnl( GetDeviceCaps( (HDC) HB_PARNL( 1 ), PHYSICALOFFSETX ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSX )          /* _HMG_PRINTER_GetPrintableAreaLogPixelsX( hdcPrint ) -> nRet */
{
   hb_retnl( GetDeviceCaps( (HDC) HB_PARNL( 1 ), LOGPIXELSX ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETY )          /* _HMG_PRINTER_GetPrintableAreaPhysicalOffsetY( hdcPrint ) -> nRet */
{
   hb_retnl( GetDeviceCaps( (HDC) HB_PARNL( 1 ), PHYSICALOFFSETY ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSY )          /* _HMG_PRINTER_GetPrintableAreaLogPixelsY( hdcPrint ) -> nRet */
{
   hb_retnl( GetDeviceCaps( (HDC) HB_PARNL( 1 ), LOGPIXELSY ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_IMAGE )          /* _HMG_PRINTER_C_Image( hdcPrint, cFile, nRow, nCol, nHeight, nWidth, lStretch ) -> lSuccess */
{
   HRGN hrgn;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   IStream * iStream;
   IPicture * iPicture;
   IPicture ** iPictureRef = &iPicture;
   HGLOBAL hGlobalStream;
   HANDLE hFile;
   DWORD nFileSize;
   DWORD nReadByte;
   long lWidth;
   long lHeight;
   POINT lpp;
   HRSRC hSource;
   HGLOBAL hGlobalRes;
   LPVOID lpVoid;
   int nSize;
   HINSTANCE hinstance = GetModuleHandle( NULL );
   HBITMAP hbmp;
   PICTDESC picd;
   int r;
   int c;
   int odr;
   int odc;
   int dr;
   int dc;

   if( hdcPrint != 0 )
   {
      hFile = CreateFile( hb_parc( 2 ), GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );

      if( hFile == INVALID_HANDLE_VALUE )
      {
         hbmp = (HBITMAP) LoadImage( hinstance, hb_parc( 2 ), IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION );

         if( hbmp != NULL )
         {
            picd.cbSizeofstruct = sizeof( PICTDESC );
            picd.picType = PICTYPE_BITMAP;
            picd.bmp.hbitmap = hbmp;
            OleCreatePictureIndirect( &picd, &IID_IPicture, TRUE, ( LPVOID * )  iPictureRef );
         }
         else
         {
            hSource = FindResource( hinstance, hb_parc( 2 ), "BMP" );
            if( hSource == NULL )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "BITMAP" );
            }
            if( hSource == NULL )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "GIF" );
            }
            if( hSource == NULL )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "JPG" );
            }
            if( hSource == NULL )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "JPEG" );
            }
            if( hSource == NULL )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "ICO" );
            }
            if( hSource == NULL )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "ICON" );
            }
            if( hSource == NULL )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "PNG" );
            }
            if( hSource == NULL )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "TIFF" );
            }
            if( hSource == NULL )
            {
               hb_retl( FALSE );
               return;
            }

            hGlobalRes = LoadResource( hinstance, hSource );
            if( hGlobalRes == NULL )
            {
               hb_retl( FALSE );
               return;
            }

            lpVoid = LockResource( hGlobalRes );
            if( lpVoid == NULL )
            {
               FreeResource( hGlobalRes );
               hb_retl( FALSE );
               return;
            }

            nSize = SizeofResource( hinstance, hSource );
            hGlobalStream = GlobalAlloc( GPTR, nSize );
            if( hGlobalStream == NULL )
            {
               FreeResource( hGlobalRes );
               hb_retl( FALSE );
               return;
            }

            memcpy( hGlobalStream, lpVoid, nSize );
            FreeResource( hGlobalRes );

            CreateStreamOnHGlobal( hGlobalStream, FALSE, &iStream );
            OleLoadPicture( iStream, nSize, TRUE, &IID_IPicture, ( LPVOID * ) iPictureRef );
            iStream->lpVtbl->Release( iStream );
            GlobalFree( hGlobalStream );
         }
      }
      else
      {
         nFileSize = GetFileSize( hFile, NULL );
         hGlobalStream = GlobalAlloc( GPTR, nFileSize );
         if( hGlobalStream )
         {
            ReadFile( hFile, hGlobalStream, nFileSize, &nReadByte, NULL );

            CreateStreamOnHGlobal( hGlobalStream, FALSE, &iStream );
            OleLoadPicture( iStream, nFileSize, TRUE, &IID_IPicture, ( LPVOID * ) iPictureRef );
            iStream->lpVtbl->Release( iStream );
            GlobalFree( hGlobalStream );
         }
         CloseHandle( hFile );
      }

      if( ! iPicture )
      {
         hb_retl( FALSE );
         return;
      }

      iPicture->lpVtbl->get_Width( iPicture, ( OLE_XSIZE_HIMETRIC * ) &lWidth );     // PIXELS_X = lWidth *  GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 2540
      iPicture->lpVtbl->get_Height( iPicture, ( OLE_YSIZE_HIMETRIC * ) &lHeight );   // PIXELS_Y = lHeight * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 2540

      odr = hb_parni( 5 );
      if( odr == 0 )
      {
         odr = lHeight;
      }
      odc = hb_parni( 6 );

      if( odc == 0 )
      {
         odc = lWidth;
      }

      dc = ( odc * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 );
      dr = ( odr * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 );

      if( ! hb_parl( 7 ) )             // Scale
      {
         if( odr * lHeight / lWidth <= odr )
         {
            dr = odc * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 * lHeight / lWidth;
         }
         else
         {
            dc = odr * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 * lWidth / lHeight;
         }
      }

      GetViewportOrgEx( hdcPrint, &lpp );

      c = ( hb_parni( 4 ) * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX );
      r = ( hb_parni( 3 ) * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY );

      hrgn = CreateRectRgn( c + lpp.x, r + lpp.y, c + dc + lpp.x - 1, r + dr + lpp.y - 1 );

      SelectClipRgn( hdcPrint, hrgn );

      hb_retl( iPicture->lpVtbl->Render( iPicture, hdcPrint, c, r, dc, dr, 0, lHeight, lWidth, -lHeight, NULL ) == S_OK );

      SelectClipRgn( hdcPrint, NULL );

      iPicture->lpVtbl->Release( iPicture );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_BITMAP )          /* _HMG_PRINTER_C_Bitmap( hdcPrint, hBitmap, nRow, nCol, nHeight, nWidth, lStretch ) -> lSuccess */
{
   HRGN hrgn;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   IPicture * iPicture;
   IPicture ** iPictureRef = &iPicture;
   long lWidth;
   long lHeight;
   POINT lpp;
   HBITMAP hbmp = (HBITMAP) HB_PARNL( 2 );
   PICTDESC picd;
   int r;
   int c;
   int odr;
   int odc;
   int dr;
   int dc;

   if( hdcPrint == NULL ||  hbmp == NULL )
   {
      hb_retl( FALSE );
      return;
   }

   picd.cbSizeofstruct = sizeof( PICTDESC );
   picd.picType = PICTYPE_BITMAP;
   picd.bmp.hbitmap = hbmp;
   OleCreatePictureIndirect( &picd, &IID_IPicture, FALSE, ( LPVOID * )  iPictureRef );

   if( iPicture == NULL )
   {
      hb_retl( FALSE );
      return;
   }

   iPicture->lpVtbl->get_Width( iPicture, ( OLE_XSIZE_HIMETRIC * ) &lWidth );     // PIXELS_X = lWidth *  GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 2540
   iPicture->lpVtbl->get_Height( iPicture, ( OLE_YSIZE_HIMETRIC * ) &lHeight );   // PIXELS_Y = lHeight * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 2540

   odr = hb_parni( 5 );
   if( odr == 0 )
   {
      odr = lHeight;
   }
   odc = hb_parni( 6 );  
   if( odc == 0 )
   {
      odc = lWidth;
   }

   dc = ( odc * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 );
   dr = ( odr * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 );

   if( ! hb_parl( 7 ) )             // Scale
   {
      if( odr * lHeight / lWidth <= odr )
      {
         dr = odc * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 * lHeight / lWidth;
      }
      else
      {
         dc = odr * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 * lWidth / lHeight;
      }
   }

   GetViewportOrgEx( hdcPrint, &lpp );

   c = ( hb_parni( 4 ) * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX );
   r = ( hb_parni( 3 ) * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY );

   hrgn = CreateRectRgn( c + lpp.x, r + lpp.y, c + dc + lpp.x - 1, r + dr + lpp.y - 1 );

   SelectClipRgn( hdcPrint, hrgn );

   hb_retl( iPicture->lpVtbl->Render( iPicture, hdcPrint, c, r, dc, dr, 0, lHeight, lWidth, -lHeight, NULL ) == S_OK );

   SelectClipRgn( hdcPrint, NULL );

   DeleteObject( hrgn );

   iPicture->lpVtbl->Release( iPicture );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_ELLIPSE )          /* _HMG_PRINTER_C_Ellipse( hdcPrint, nRow, nCol, nToRow, nToCol, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, nRedB, nGreenB, nBlueB, lNoPen, lNoBrush ) -> NIL */
{
   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   int tox = hb_parni( 5 );
   int toy = hb_parni( 4 );
   int width;
   int nStyle;
   int br;
   int bg;
   int bb;
   int nBstyle;
   long nBhatch;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HGDIOBJ hgdiobj1 = NULL;
   HGDIOBJ hgdiobj2 = NULL;
   HPEN hpen = NULL;
   LOGBRUSH pbr;
   HBRUSH hbr = NULL;
   BOOL bNoPen = hb_parl( 20 );
   BOOL bNoBrush = hb_parl( 21 );

   if( hdcPrint != 0 )
   {
      // lWidth
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // lColor
      if( hb_parl( 11 ) )
      {
         r = hb_parni( 7 );
         g = hb_parni( 8 );
         b = hb_parni( 9 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      // lStyle
      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      // lBrushStyle
      if( hb_parl( 14 ) )
      {
         nBstyle = BS_HATCHED;
         nBhatch = hb_parni( 15 );   // nBrushStyle
      }
      else
      {
         // lBrushColor
         if( hb_parl( 16 ) )
         {
            nBstyle = BS_SOLID;
         }
         else
         {
            nBstyle = BS_NULL;
         }
         nBhatch = 0 ;
      }

      // lBrushColor
      if( hb_parl( 16 ) )
      {
         br = hb_parni( 17 );
         bg = hb_parni( 18 );
         bb = hb_parni( 19 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBstyle;
      pbr.lbColor = (COLORREF) RGB( br, bg, bb );
      pbr.lbHatch = nBhatch;

      if( ! bNoBrush )
      {
         hbr = CreateBrushIndirect( &pbr );
         hgdiobj1 = SelectObject( hdcPrint, hbr );
      }

      if( ! bNoPen )
      {
         hpen = CreatePen( nStyle, width, (COLORREF) RGB( r, g, b ) );
         hgdiobj2 = SelectObject( hdcPrint, hpen );
      }

      Ellipse( hdcPrint,
               ( x   * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
               ( y   * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
               ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
               ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      if( ! bNoBrush )
      {
         SelectObject( hdcPrint, hgdiobj1 );
         DeleteObject( hbr );
      }

      if( ! bNoPen )
      {
         SelectObject( hdcPrint, hgdiobj2 );
         DeleteObject( hpen );
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_ARC )          /* _HMG_PRINTER_C_Arc( hdcPrint, nRow, nCol, nToRow, nToCol, nRow1, nCol1, nRow2, nCol2, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle ) -> NIL */
{
   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   int tox = hb_parni( 5 );
   int toy = hb_parni( 4 );
   int x1 = hb_parni( 7 );
   int y1 = hb_parni( 6 );
   int x2 = hb_parni( 9 );
   int y2 = hb_parni( 8 );
   int width = 0;
   int nStyle;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;

   if( hdcPrint != 0 )
   {
      // lWidth
      if( hb_parl( 14 ) )
      {
         width = hb_parni( 10 );
      }

      // lColor
      if( hb_parl( 15 ) )
      {
         r = hb_parni( 11 );
         g = hb_parni( 12 );
         b = hb_parni( 13 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      // lStyle
      if( hb_parl( 16 ) )
      {
         nStyle = hb_parni( 17 );   // nStyle
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      hpen = CreatePen( nStyle, width, (COLORREF) RGB( r, g, b ) );
      hgdiobj = SelectObject( hdcPrint, hpen );

      Arc( hdcPrint,
           ( x   * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
           ( y   * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
           ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
           ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
           ( x1  * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
           ( y1  * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
           ( x2  * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
           ( y2  * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      SelectObject( hdcPrint, hgdiobj );

      DeleteObject( hpen );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_C_PIE )          /* _HMG_PRINTER_C_Pie( hdcPrint, nRow, nCol, nToRow, nToCol, nRow1, nCol1, nRow2, nCol2, nWidth, nRed, nGreen, nBlue, lWidth, lColor, lStyle, nStyle, lBrushStyle, nBrushStyle, lBrushColor, nRedB, nGreenB, nBlueB, lNoPen, lNoBrush ) -> NIL */
{
   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   int tox = hb_parni( 5 );
   int toy = hb_parni( 4 );
   int x1 = hb_parni( 7 );
   int y1 = hb_parni( 6 );
   int x2 = hb_parni( 9 );
   int y2 = hb_parni( 8 );
   int width = 0;
   int nStyle;
   int br;
   int bg;
   int bb;
   int nBstyle;
   long nBhatch;
   HDC hdcPrint = (HDC) HB_PARNL( 1 );
   HGDIOBJ hgdiobj1 = NULL;
   HGDIOBJ hgdiobj2 = NULL;
   HPEN hpen = NULL;
   LOGBRUSH pbr;
   HBRUSH hbr = NULL;
   BOOL bNoPen = hb_parl( 24 );
   BOOL bNoBrush = hb_parl( 25 );

   if( hdcPrint != 0 )
   {
      // lWidth
      if( hb_parl( 14 ) )
      {
         width = hb_parni( 10 );
      }

      // lColor
      if( hb_parl( 15 ) )
      {
         r = hb_parni( 11 );
         g = hb_parni( 12 );
         b = hb_parni( 13 );
      }
      else
      {
         r = 0;
         g = 0;
         b = 0;
      }

      // lStyle
      if( hb_parl( 16 ) )
      {
         nStyle = hb_parni( 17 );   // nStyle
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      // lBrushStyle
      if( hb_parl( 18 ) )
      {
         nBstyle = BS_HATCHED;
         nBhatch = hb_parni( 19 );   // nBrushStyle
      }
      else
      {
         // lBrushColor
         if( hb_parl( 20 ) )
         {
            nBstyle = BS_SOLID;
         }
         else
         {
            nBstyle = BS_NULL;
         }
         nBhatch = 0 ;
      }

      // lBrushColor
      if( hb_parl( 20 ) )
      {
         br = hb_parni( 21 );
         bg = hb_parni( 22 );
         bb = hb_parni( 23 );
      }
      else
      {
         br = 0;
         bg = 0;
         bb = 0;
      }

      pbr.lbStyle = nBstyle;
      pbr.lbColor = (COLORREF) RGB( br, bg, bb );
      pbr.lbHatch = nBhatch;

      if( ! bNoBrush )
      {
         hbr = CreateBrushIndirect( &pbr );
         hgdiobj1 = SelectObject( hdcPrint, hbr );
      }

      if( ! bNoPen )
      {
         hpen = CreatePen( nStyle, width, (COLORREF) RGB( r, g, b ) );
         hgdiobj2 = SelectObject( hdcPrint, hpen );
      }

      Pie( hdcPrint,
           ( x   * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
           ( y   * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
           ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
           ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
           ( x1  * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
           ( y1  * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
           ( x2  * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
           ( y2  * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      if( ! bNoBrush )
      {
         SelectObject( hdcPrint, hgdiobj1 );
         DeleteObject( hbr );
      }

      if( ! bNoPen )
      {
         SelectObject( hdcPrint, hgdiobj2 );
         DeleteObject( hpen );
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETMAXCOL )          /* _HMG_PRINTER_GetMaxCol( hdcPrint, cFontName, nFontSize, nWidth, nAngle, lBold, lItalic, lUnderLine, lStrikeOut ) -> nRet */
{
   HDC hdcPrint;
   char FontName[ 32 ];
   int FontSize;
   int nWidth;
   int nAngle;
   int fnWeight;
   DWORD fdwItalic;
   DWORD fdwUnderline;
   DWORD fdwStrikeOut;
   int FontHeight;
   HFONT hfont;
   HGDIOBJ hgdiobj;
   TEXTMETRIC tm;

   hdcPrint = (HDC) HB_PARNL( 1 );

   // FontName
   if( hb_parclen( 2 ) )
   {
      strcpy( FontName, hb_parc( 2 ) );
   }
   else
   {
      strcpy( FontName, "Arial" );
   }

   // FontSize
   if( hb_parni( 3 ) > 0 )
   {
      FontSize = hb_parni( 3 );
   }
   else
   {
      FontSize = 10;
   }

   // Width
   nWidth = hb_parni( 4 );

   // Angle
   nAngle = hb_parni( 5 );

   // Bold
   if( hb_parl( 6 ) )
   {
      fnWeight = FW_BOLD;
   }
   else
   {
      fnWeight = FW_NORMAL;
   }

   // Italic
   if( hb_parl( 7 ) )
   {
      fdwItalic = TRUE;
   }
   else
   {
      fdwItalic = FALSE;
   }

   // UnderLine
   if( hb_parl( 8 ) )
   {
      fdwUnderline = TRUE;
   }
   else
   {
      fdwUnderline = FALSE;
   }

   // StrikeOut
   if( hb_parl( 9 ) )
   {
      fdwStrikeOut = TRUE;
   }
   else
   {
      fdwStrikeOut = FALSE;
   }

   FontHeight = -MulDiv( FontSize, GetDeviceCaps( hdcPrint, LOGPIXELSY ), 72 );

   hfont = CreateFont( FontHeight,
                       nWidth,
                       nAngle,
                       nAngle,
                       fnWeight,
                       fdwItalic,
                       fdwUnderline,
                       fdwStrikeOut,
                       s_charset,
                       OUT_TT_PRECIS,
                       CLIP_DEFAULT_PRECIS,
                       DEFAULT_QUALITY,
                       FF_DONTCARE,
                       FontName );

   hgdiobj = SelectObject( hdcPrint, hfont );

   GetTextMetrics( hdcPrint, &tm );

   hb_retni( (int) ( GetDeviceCaps( hdcPrint, HORZRES ) / tm.tmAveCharWidth - 1 ) );

   SelectObject( hdcPrint, hgdiobj );

   DeleteObject( hfont );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( _HMG_PRINTER_GETMAXROW )          /* _HMG_PRINTER_GetMaxRow( hdcPrint, cFontName, nFontSize, nWidth, nAngle, lBold, lItalic, lUnderLine, lStrikeOut ) -> nRet */
{
   HDC hdcPrint;
   char FontName[ 32 ];
   int FontSize;
   int nWidth;
   int nAngle;
   int fnWeight;
   DWORD fdwItalic;
   DWORD fdwUnderline;
   DWORD fdwStrikeOut;
   int FontHeight;
   HFONT hfont;
   HGDIOBJ hgdiobj;
   TEXTMETRIC tm;

   hdcPrint = (HDC) HB_PARNL( 1 );

   // FontName
   if( hb_parclen( 2 ) )
   {
      strcpy( FontName, hb_parc( 2 ) );
   }
   else
   {
      strcpy( FontName, "Arial" );
   }

   // FontSize
   if( hb_parni( 3 ) > 0 )
   {
      FontSize = hb_parni( 3 );
   }
   else
   {
      FontSize = 10;
   }

   // Width
   nWidth = hb_parni( 4 );

   // Angle
   nAngle = hb_parni( 5 );

   // Bold
   if( hb_parl( 6 ) )
   {
      fnWeight = FW_BOLD;
   }
   else
   {
      fnWeight = FW_NORMAL;
   }

   // Italic
   if( hb_parl( 7 ) )
   {
      fdwItalic = TRUE;
   }
   else
   {
      fdwItalic = FALSE;
   }

   // UnderLine
   if( hb_parl( 8 ) )
   {
      fdwUnderline = TRUE;
   }
   else
   {
      fdwUnderline = FALSE;
   }

   // StrikeOut
   if( hb_parl( 9 ) )
   {
      fdwStrikeOut = TRUE;
   }
   else
   {
      fdwStrikeOut = FALSE;
   }

   FontHeight = -MulDiv( FontSize, GetDeviceCaps( hdcPrint, LOGPIXELSY ), 72 );

   hfont = CreateFont( FontHeight,
                       nWidth,
                       nAngle,
                       nAngle,
                       fnWeight,
                       fdwItalic,
                       fdwUnderline,
                       fdwStrikeOut,
                       s_charset,
                       OUT_TT_PRECIS,
                       CLIP_DEFAULT_PRECIS,
                       DEFAULT_QUALITY,
                       FF_DONTCARE,
                       FontName );

   hgdiobj = SelectObject( hdcPrint, hfont );

   GetTextMetrics( hdcPrint, &tm );

   hb_retni( (int) ( ( GetDeviceCaps( (HDC) HB_PARNL( 1 ), VERTRES ) - tm.tmAscent ) / tm.tmHeight - 1 ) );

   SelectObject( hdcPrint, hgdiobj );

   DeleteObject( hfont );
}

#pragma ENDDUMP
