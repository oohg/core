/*
 * $Id: miniprint.prg $
 */
/*
 * ooHG source code:
 * MINIPRINT printing library
 *
 * Based upon
 * HBPRINT and HBPRINTER libraries
 * Copyright 2002 Richard Rylko <rrylko@poczta.onet.pl>
 * http://rrylko.republika.pl
 *
 * Copyright 2006-2018 Vicente Guerra <vicente@guerra.com.mx>
 * https://oohg.github.io/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
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


   ///////////////////////////////////////////////////////////////////
   // HARBOUR LEVEL PRINT ROUTINES
   ///////////////////////////////////////////////////////////////////

#include "oohg.ch"
#include "miniprint.ch"

#define WM_CLOSE     0x0010
#define SB_HORZ      0
#define SB_VERT      1
#define WM_VSCROLL   0x0115

DECLARE WINDOW _HMG_PRINTER_PPNAV

MEMVAR _HMG_PRINTER_TimeStamp
MEMVAR _HMG_PRINTER_hDC_Bak
MEMVAR _HMG_PRINTER_PageCount
MEMVAR _HMG_PRINTER_Copies
MEMVAR _HMG_PRINTER_Collate
MEMVAR _HMG_PRINTER_hDC
MEMVAR _HMG_PRINTER_BasePageName
MEMVAR _HMG_PRINTER_CurrentPageNumber
MEMVAR _HMG_PRINTER_SizeFactor
MEMVAR _HMG_PRINTER_Dx
MEMVAR _HMG_PRINTER_Dy
MEMVAR _HMG_PRINTER_Dz
MEMVAR _HMG_PRINTER_ScrollStep
MEMVAR _HMG_PRINTER_ZoomClick_xOffset
MEMVAR _HMG_PRINTER_ThumbUpdate
MEMVAR _HMG_PRINTER_ThumbScroll
MEMVAR _HMG_PRINTER_PrevPageNumber
MEMVAR _HMG_PRINTER_UserMessages
MEMVAR _OOHG_PRINTER_DocName
MEMVAR _OOHG_Auxil_Page
MEMVAR _OOHG_Auxil_Zoom

PROCEDURE _HMG_PRINTER_ShowPreview()

   LOCAL tHeight
   LOCAL tFactor
   LOCAL tvHeight
   LOCAL icb
   LOCAL _HMG_PRINTER_SHOWPREVIEW, _HMG_PRINTER_PPNAV, _HMG_PRINTER_SHOWTHUMBNAILS, oSep

   PUBLIC _HMG_PRINTER_BasePageName := GetTempFolder() + "\" + _HMG_PRINTER_TimeStamp + "_HMG_print_preview_"
   PUBLIC _HMG_PRINTER_CurrentPageNumber := 1
   PUBLIC _HMG_PRINTER_SizeFactor
   PUBLIC _HMG_PRINTER_Dx := 0
   PUBLIC _HMG_PRINTER_Dy := 0
   _HMG_PRINTER_PreviewZoom()                          // PUBLIC _HMG_PRINTER_Dz := 0
   PUBLIC _HMG_PRINTER_ScrollStep := 10
   PUBLIC _HMG_PRINTER_ZoomClick_xOffset := 0
   PUBLIC _HMG_PRINTER_ThumbUpdate := .T.
   PUBLIC _HMG_PRINTER_ThumbScroll
   PUBLIC _HMG_PRINTER_PrevPageNumber := 0
   PUBLIC _OOHG_Auxil_Page
   PUBLIC _OOHG_Auxil_Zoom

   If _HMG_PRINTER_hDC_Bak == 0
      RETURN
   EndIf

   If _IsWindowDefined( "_HMG_PRINTER_SHOWPREVIEW" )
      RETURN
   EndIf

   icb := SetInteractiveClose()

   set interactiveclose on

   _HMG_PRINTER_SizeFactor := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT( _HMG_PRINTER_hDC_Bak ) * 0.63

    DEFINE WINDOW _OOHG_AUXIL TITLE _HMG_PRINTER_UserMessages [02] + '. ' + _HMG_PRINTER_UserMessages [01] + ' [' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber)) + '/'+ AllTrim( Str(_HMG_PRINTER_PageCount ) ) + ']';
      CHILD ;
      AT 0, 0 ;
      WIDTH GetDesktopWidth() - 123 ;
      HEIGHT GetDesktopHeight() - 123 ;
      ON MOUSECLICK ( If( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ) ) ;
      ON RELEASE _HMG_PRINTER_PreviewClose() ;
      ON PAINT _HMG_PRINTER_SHOWPREVIEW:SetFocus()
      /*
      ON SCROLLUP    _HMG_PRINTER_ScrolluP() ;
      ON SCROLLDOWN  _HMG_PRINTER_ScrollDown() ;
      ON SCROLLLEFT  _HMG_PRINTER_ScrollLeft() ;
      ON SCROLLRIGHT _HMG_PRINTER_ScrollRight() ;
      ON HSCROLLBOX  _HMG_PRINTER_hScrollBoxProcess() ;
      ON VSCROLLBOX  _HMG_PRINTER_vScrollBoxProcess() ;
      */

      DEFINE WINDOW _HMG_PRINTER_PPNAV OBJ _HMG_PRINTER_PPNAV HEIGHT 35 WIDTH 100 INTERNAL

         @ 2, 2 BUTTON b1 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_TOP" ;
            TOOLTIP _HMG_PRINTER_UserMessages[03] ;
            ACTION( _HMG_PRINTER_CurrentPageNumber := 1, _HMG_PRINTER_PreviewRefresh() )


         @ 2, 32 BUTTON b2 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_BACK" ;
            TOOLTIP _HMG_PRINTER_UserMessages[04] ;
            ACTION( _HMG_PRINTER_CurrentPageNumber--, _HMG_PRINTER_PreviewRefresh() )


         @ 2, 62 BUTTON b3 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_NEXT" ;
            TOOLTIP _HMG_PRINTER_UserMessages[05] ;
            ACTION( _HMG_PRINTER_CurrentPageNumber++, _HMG_PRINTER_PreviewRefresh() )


         @ 2, 92 BUTTON b4 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_END" ;
            TOOLTIP _HMG_PRINTER_UserMessages[06] ;
            ACTION( _HMG_PRINTER_CurrentPageNumber := _HMG_PRINTER_PageCount, _HMG_PRINTER_PreviewRefresh() )


         @ 2, 126 CHECKBUTTON thumbswitch ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_THUMBNAIL" ;
            TOOLTIP _HMG_PRINTER_UserMessages[28] + ' [Ctrl+T]' ;
            ON CHANGE _HMG_PRINTER_ProcessThumbnails()

/*
         @ 2, 156 BUTTON GoToPage ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_GOPAGE" ;
            TOOLTIP _HMG_PRINTER_UserMessages[07] + ' [Ctrl+G]' ;
            ACTION _HMG_PRINTER_Go_To_Page()
*/

         @ 2, 156 CHECKBUTTON b5 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_ZOOM" ;
            TOOLTIP _HMG_PRINTER_UserMessages[08] + ' [*]' ;
            ON CHANGE _HMG_PRINTER_MouseZoom()     ///// _HMG_PRINTER_zoom()


         @ 2, 186 BUTTON b12 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_PRINT" ;
            TOOLTIP _HMG_PRINTER_UserMessages[09] + ' [Ctrl+P]' ;
            ACTION _HMG_PRINTER_PrintPages()



         @ 2, 216 BUTTON b7 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_SAVE" ;
            TOOLTIP _HMG_PRINTER_UserMessages[27] + ' [Ctrl+S]' ;
            ACTION _HMG_PRINTER_SavePages()


         @ 2, 246 BUTTON b6 ;
            WIDTH 30 ;
            HEIGHT 30 ;
            PICTURE "HP_CLOSE" ;
            TOOLTIP _HMG_PRINTER_UserMessages[26] + ' [Ctrl+C]' ;
            ACTION _HMG_PRINTER_PreviewClose()

         @ 15, 291 LABEL lbl_1 VALUE _HMG_PRINTER_UserMessages [07] AUTOSIZE

         @ 8, 400 TEXTBOX pagina OBJ _OOHG_Auxil_Page PICTURE '999999' NUMERIC WIDTH 75 VALUE _HMG_PRINTER_CurrentPageNumber IMAGE "HP_GOPAGE" ;
         ACTION ( _OOHG_Auxil_Page:Value := If( _OOHG_Auxil_Page:Value < 1, 1, _OOHG_Auxil_Page:Value ), ;
                  _OOHG_Auxil_Page:Value := If( _OOHG_Auxil_Page:Value > _HMG_PRINTER_PageCount, _HMG_PRINTER_PageCount, _OOHG_Auxil_Page:Value ), ;
                  _HMG_PRINTER_CurrentPageNumber := _OOHG_Auxil_Page:Value, _HMG_PRINTER_SHOWPREVIEW:Show() )

         @ 15, 500 LABEL lbl_2 VALUE 'Zoom' AUTOSIZE

         @ 8, 550 TEXTBOX zoom OBJ _OOHG_Auxil_Zoom PICTURE '99.99' NUMERIC WIDTH 75 VALUE _HMG_PRINTER_Dz/200 IMAGE "HP_ZOOM" ;
         ACTION ( _HMG_PRINTER_Dz := _OOHG_Auxil_Zoom:Value*200, ;
                  _HMG_PRINTER_SHOWPREVIEW:Show() )
      END WINDOW

      _HMG_PRINTER_PPNAV:ClientAdjust := 1

      DEFINE WINDOW _HMG_PRINTER_SHOWPREVIEW OBJ _HMG_PRINTER_SHOWPREVIEW;
         AT 0, 0 ;
         WIDTH GetDesktopWidth() - 123 ;
         HEIGHT GetDesktopHeight() - 123 ;
         VIRTUAL WIDTH GetDesktopWidth() - 55 ;
         VIRTUAL HEIGHT GetDesktopHeight() - 112 ;
         INTERNAL ;
         CURSOR "HP_GLASS" ;
         ON PAINT _HMG_PRINTER_PreviewRefresh() ;
         BACKCOLOR GRAY ;
         ON MOUSECLICK If( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ) ;
         ON SCROLLUP    _HMG_PRINTER_ScrolluP() ;
         ON SCROLLDOWN  _HMG_PRINTER_ScrollDown() ;
         ON SCROLLLEFT  _HMG_PRINTER_ScrollLeft() ;
         ON SCROLLRIGHT _HMG_PRINTER_ScrollRight() ;
         ON HSCROLLBOX  _HMG_PRINTER_hScrollBoxProcess() ;
         ON VSCROLLBOX  _HMG_PRINTER_vScrollBoxProcess()

         ON KEY HOME         ACTION ( _HMG_PRINTER_CurrentPageNumber := 1, _HMG_PRINTER_PreviewRefresh() )
         ON KEY PRIOR        ACTION ( _HMG_PRINTER_CurrentPageNumber--, _HMG_PRINTER_PreviewRefresh() )
         ON KEY NEXT         ACTION ( _HMG_PRINTER_CurrentPageNumber++, _HMG_PRINTER_PreviewRefresh() )
         ON KEY END          ACTION ( _HMG_PRINTER_CurrentPageNumber := _HMG_PRINTER_PageCount, _HMG_PRINTER_PreviewRefresh() )
         ON KEY CONTROL+P    ACTION _HMG_PRINTER_PrintPages()
         //ON KEY CONTROL+G    ACTION _HMG_PRINTER_Go_To_Page()
         ON KEY ESCAPE       ACTION _HMG_PRINTER_PreviewClose()
         ON KEY MULTIPLY     ACTION ( If( _HMG_PRINTER_PPNAV.b5.Value == .T., _HMG_PRINTER_PPNAV.b5.Value := .F., _HMG_PRINTER_PPNAV.b5.Value := .T. ), _HMG_PRINTER_Zoom() )
         ON KEY CONTROL+C    ACTION _HMG_PRINTER_PreviewClose()
         ON KEY ALT+F4       ACTION _HMG_PRINTER_PreviewClose()
         ON KEY CONTROL+S    ACTION _HMG_PRINTER_SavePages()
         ON KEY CONTROL+T    ACTION _HMG_PRINTER_ThumbnailToggle()

         _HMG_PRINTER_SHOWPREVIEW:ClientAdjust := 5
      END WINDOW

      If _HMG_PRINTER_GETPAGEHEIGHT( _HMG_PRINTER_hDC_Bak ) > _HMG_PRINTER_GETPAGEWIDTH( _HMG_PRINTER_hDC_Bak )
         tFactor := 0.44
      Else
         tFactor := 0.26
      EndIf

      tHeight :=_HMG_PRINTER_GETPAGEHEIGHT( _HMG_PRINTER_hDC_Bak ) * tFactor

      tHeight := Int( tHeight )

      tvHeight := ( _HMG_PRINTER_PageCount * ( tHeight + 10 ) ) + GetHScrollbarHeight() + GetTitleHeight() + ( GetBorderHeight() * 2 ) + 7

      If tvHeight <= GetDesktopHeight() - 103
         _HMG_PRINTER_ThumbScroll := .F.
         tvHeight := GetDesktopHeight() - 102
      Else
         _HMG_PRINTER_ThumbScroll := .T.
      EndIf

      DEFINE WINDOW _HMG_PRINTER_SHOWTHUMBNAILS OBJ _HMG_PRINTER_SHOWTHUMBNAILS INTERNAL ;
         WIDTH 130 ;
         VIRTUAL WIDTH 130 ;
         VIRTUAL HEIGHT tvHeight ;
         TITLE _HMG_PRINTER_UserMessages [28] ;
         BACKCOLOR {100, 100, 100}
      END WINDOW

      _HMG_PRINTER_SHOWTHUMBNAILS:ClientAdjust := 3
      _HMG_PRINTER_SHOWTHUMBNAILS:Hide()

      @ 0, 0 LABEL _lsep OBJ oSep WIDTH 4 VALUE '' BORDER

      oSep:ClientAdjust := 3
    END WINDOW

    DEFINE WINDOW _HMG_PRINTER_WAIT AT 0, 0 WIDTH 310 HEIGHT 85 TITLE ' ' CHILD NOSHOW NOCAPTION

      DEFINE LABEL label_1
         ROW 30
         COL 5
         WIDTH 300
         HEIGHT 30
         VALUE _HMG_PRINTER_UserMessages [29]
         CENTERALIGN .T.
      END LABEL
   END WINDOW

   _HMG_PRINTER_WAIT.Center

   DEFINE WINDOW _HMG_PRINTER_PRINTPAGES ;
      AT 0, 0 ;
      WIDTH 420 ;
      HEIGHT 168 + GetTitleHeight() ;
      TITLE _HMG_PRINTER_UserMessages [9] ;
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
         CAPTION _HMG_PRINTER_UserMessages [15]
      END FRAME

      DEFINE RADIOGROUP Radio_1
         ROW 25
         COL 20
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE 1
         OPTIONS { _HMG_PRINTER_UserMessages [16], _HMG_PRINTER_UserMessages [17] }
         ONCHANGE If( This.Value == 1, ( _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F., _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F. ), ( _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .T., _HMG_PRINTER_PRINTPAGES.Spinner_1.SetFocus ) )
      END RADIOGROUP

      DEFINE LABEL Label_1
         ROW 84
         COL 55
         WIDTH 50
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE _HMG_PRINTER_UserMessages [18] + ':'
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
         VALUE _HMG_PRINTER_UserMessages [19] + ':'
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
         VALUE _HMG_PRINTER_UserMessages [09] + ':'
      END LABEL

      DEFINE COMBOBOX Combo_1
         ROW 113
         COL 110
         WIDTH 145
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE 1
         ITEMS {_HMG_PRINTER_UserMessages [21], _HMG_PRINTER_UserMessages [22], _HMG_PRINTER_UserMessages [23] }
         DISABLED .T.
      END COMBOBOX

      DEFINE BUTTON Ok
         ROW 10
         COL 300
         WIDTH 105
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         CAPTION _HMG_PRINTER_UserMessages [11]
         ACTION _HMG_PRINTER_PrintPagesDo()
      END BUTTON

      DEFINE BUTTON Cancel
         ROW 40
         COL 300
         WIDTH 105
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         CAPTION _HMG_PRINTER_UserMessages [12]
         ACTION( EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWPREVIEW" ) ), EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ), EnableWindow( GetFormHandle( "_HMG_PRINTER_PPNAV" ) ), HideWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) ), _HMG_PRINTER_SHOWPREVIEW.SetFocus )
      END BUTTON

      DEFINE LABEL LABEL_3
         ROW 103
         COL 300
         WIDTH 45
         HEIGHT 25
         FONTNAME 'Arial'
         FONTSIZE 9
         VALUE _HMG_PRINTER_UserMessages [20] + ':'
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
         CAPTION _HMG_PRINTER_UserMessages [14]
         DISABLED ( _HMG_PRINTER_Copies > 1 )
      END CHECKBOX
   END WINDOW

   CENTER WINDOW _HMG_PRINTER_PRINTPAGES

   If _HMG_PRINTER_ThumbScroll == .F.
      _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS( GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' ) )
   EndIf

   SetScrollRange( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 0, 100, .T. )
   SetScrollRange( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 0, 100, .T. )

   SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 50, .T. )
   SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 50, .T. )

   _HMG_PRINTER_PREVIEW_DISABLEHSCROLLBAR( GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' ) )

   CENTER WINDOW _HMG_PRINTER_SHOWPREVIEW

   CENTER WINDOW _OOHG_AUXIL

   ACTIVATE WINDOW _OOHG_AUXIL, _HMG_PRINTER_PRINTPAGES, _HMG_PRINTER_WAIT

   _HMG_PRINTER_hDC := _HMG_PRINTER_hDC_Bak

   SetInteractiveClose( icb )

   RETURN

PROCEDURE _HMG_PRINTER_CreateThumbNails()

   LOCAL tFactor
   LOCAL tWidth
   LOCAL tHeight
   LOCAL ttHandle
   LOCAL i
   LOCAL cMacroTemp
   LOCAL cAction

   If _IsControlDefined( 'Image1', '_HMG_PRINTER_SHOWTHUMBNAILS' )
      RETURN
   EndIf

   ShowWindow( GetFormHandle( "_HMG_PRINTER_WAIT" ) )

   If _HMG_PRINTER_GETPAGEHEIGHT( _HMG_PRINTER_hDC_Bak ) > _HMG_PRINTER_GETPAGEWIDTH( _HMG_PRINTER_hDC_Bak )
      tFactor := 0.44
   Else
      tFactor := 0.26
   EndIf

   tWidth  :=_HMG_PRINTER_GETPAGEWIDTH( _HMG_PRINTER_hDC_Bak ) * tFactor
   tHeight :=_HMG_PRINTER_GETPAGEHEIGHT( _HMG_PRINTER_hDC_Bak ) * tFactor

   tHeight := Int( tHeight )

   ttHandle := GetFormToolTipHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' )

   For i := 1 To _HMG_PRINTER_PageCount
      cMacroTemp := 'Image' + AllTrim( Str( i ) )

      cAction := "( _HMG_PRINTER_CurrentPageNumber := " + AllTrim( Str( i ) ) + ", _HMG_PRINTER_ThumbUpdate := .F., _HMG_PRINTER_PreviewRefresh(), _HMG_PRINTER_ThumbUpdate := .T. )"

      TImage():Define( cMacroTemp, '_HMG_PRINTER_SHOWTHUMBNAILS', 10, ;
                       ( i * (tHeight + 10) ) - tHeight, ;
                       _HMG_PRINTER_BasePageName + strzero(i, 6) + ".emf", ;
                       tWidth, tHeight, { || &cAction }, NIL, ;
                       .F., .F., .T., .F. )

      SetToolTip( GetControlHandle( cMacroTemp, '_HMG_PRINTER_SHOWTHUMBNAILS' ), _HMG_PRINTER_UserMessages [01] + ' ' + AllTrim(Str(i)) + ' [Click]', ttHandle )

   Next i

   HideWindow( GetFormHandle( "_HMG_PRINTER_WAIT" ) )

   RETURN

PROCEDURE _HMG_PRINTER_ThumbnailToggle()

   _HMG_PRINTER_PPNAV.thumbswitch.Value := ! _HMG_PRINTER_PPNAV.thumbswitch.Value
   _HMG_PRINTER_ProcessThumbnails()

   RETURN

PROCEDURE _HMG_PRINTER_ProcessThumbnails()

   If _HMG_PRINTER_PPNAV.thumbswitch.Value == .T.
      _HMG_PRINTER_CreateThumbNails()
      _HMG_PRINTER_SHOWTHUMBNAILS.Show()
   Else
      _HMG_PRINTER_SHOWTHUMBNAILS.Hide()
   EndIf

   RETURN

PROCEDURE _HMG_PRINTER_SavePages()

   LOCAL c, i, f, t, d, x, a

   x := GetFolder( _HMG_PRINTER_UserMessages [101] )

   If Empty( x )
      RETURN
   EndIf

   If right(x, 1) != '\'
      x := x + '\'
   EndIf

   t := GetTempFolder()

   c := aDir( t + "\" + _HMG_PRINTER_TimeStamp  + "_HMG_print_preview_*.Emf")

   a := Array( c )

   aDir( t + "\" + _HMG_PRINTER_TimeStamp  + "_HMG_print_preview_*.Emf", a )

   For i := 1 To c
      f := t + "\" + a [i]
      d := x + 'Harbour_MiniPrint_' + StrZero( i, 6 ) + '.Emf'
      COPY FILE (f) TO (d)
   Next i

   RETURN

PROCEDURE _HMG_PRINTER_hScrollBoxProcess()

   LOCAL Sp

   Sp := GetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ )

   _HMG_PRINTER_Dx := -( Sp - 50 ) * 10

   _HMG_PRINTER_PreviewRefresh()

   RETURN

PROCEDURE _HMG_PRINTER_vScrollBoxProcess()

   LOCAL Sp

   Sp := GetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT )

   _HMG_PRINTER_Dy := -( Sp - 50 ) * 10

   _HMG_PRINTER_PreviewRefresh()

   RETURN

PROCEDURE _HMG_PRINTER_PreviewClose()

   If IsWindowDefined( "_HMG_PRINTER_WAIT" )
      _HMG_PRINTER_WAIT.label_1.Value := _HMG_PRINTER_UserMessages [103]
      ShowWindow( GetFormHandle( "_HMG_PRINTER_WAIT" ) )
   EndIf

   _HMG_PRINTER_CleanPreview()

   If IsWindowDefined( "_OOHG_AUXIL" )
     _OOHG_AUXIL.Release
   EndIf

   If IsWindowDefined( "_HMG_PRINTER_PRINTPAGES" )
     _HMG_PRINTER_PRINTPAGES.Release
   EndIf

   If IsWindowDefined( "_HMG_PRINTER_WAIT" )
     _HMG_PRINTER_WAIT.Release
   EndIf

   RETURN

PROCEDURE _HMG_PRINTER_CleanPreview()

   AEval( Directory( GetTempFolder() + "\" + _HMG_PRINTER_TimeStamp + "_HMG_print_preview_*.Emf" ), ;
                     { |file| Ferase( GetTempFolder() + '\' + file[1] ) } )

   RETURN

PROCEDURE _HMG_PRINTER_PreviewRefresh()

   LOCAL hwnd
   LOCAL nRow
   LOCAL nScrollMax

   If ! __MVEXIST( '_HMG_PRINTER_CurrentPageNumber' )
      __MVPUBLIC( '_HMG_PRINTER_CurrentPageNumber' )
      __MVPUT( '_HMG_PRINTER_CurrentPageNumber', 1 )
   EndIf

   If _IsControlDefined( 'Image' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ), '_HMG_PRINTER_SHOWTHUMBNAILS' ) .AND. _HMG_PRINTER_ThumbUpdate == .T. .AND. _HMG_PRINTER_ThumbScroll == .T.

      If _HMG_PRINTER_PrevPageNumber != _HMG_PRINTER_CurrentPageNumber
         _HMG_PRINTER_PrevPageNumber := _HMG_PRINTER_CurrentPageNumber

         hwnd := GetFormHandle( '_HMG_PRINTER_SHOWTHUMBNAILS' )
         nRow := GetProperty( '_HMG_PRINTER_SHOWTHUMBNAILS', 'Image' + AllTrim( Str( _HMG_PRINTER_CurrentPageNumber ) ), 'Row' )
         nScrollMax := GetScrollRangeMax( hwnd, SB_VERT )

         If _HMG_PRINTER_PageCount == _HMG_PRINTER_CurrentPageNumber

            If GetScrollPos( hwnd, SB_VERT ) != nScrollMax
               _HMG_PRINTER_SETVSCROLLVALUE( hwnd, nScrollMax )
            EndIf

         ElseIf _HMG_PRINTER_CurrentPageNumber == 1

            If GetScrollPos(hwnd, SB_VERT) != 0
               _HMG_PRINTER_SETVSCROLLVALUE( hwnd, 0 )
            EndIf

         Else

            If( nRow - 9 ) < nScrollMax
               _HMG_PRINTER_SETVSCROLLVALUE( hwnd, nRow - 9 )
            Else
               If GetScrollPos( hwnd, SB_VERT ) != nScrollMax
                  _HMG_PRINTER_SETVSCROLLVALUE( hwnd, nScrollMax )
               EndIf
            EndIf

         EndIf

      EndIf

   EndIf

   If _HMG_PRINTER_CurrentPageNumber < 1
      _HMG_PRINTER_CurrentPageNumber := 1
      PlayBeep()
      RETURN
   EndIf

   If _HMG_PRINTER_CurrentPageNumber > _HMG_PRINTER_PageCount
      _HMG_PRINTER_CurrentPageNumber := _HMG_PRINTER_PageCount
      PlayBeep()
      RETURN
   EndIf

   _HMG_PRINTER_SHOWPAGE( _HMG_PRINTER_BasePageName + StrZero( _HMG_PRINTER_CurrentPageNumber, 6 ) + ".emf", GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), _HMG_PRINTER_hDC_Bak, _HMG_PRINTER_SizeFactor * 10000, _HMG_PRINTER_Dz, _HMG_PRINTER_Dx, _HMG_PRINTER_Dy )

   _OOHG_AUXIL.Title := _HMG_PRINTER_UserMessages [02]+'. '+_HMG_PRINTER_UserMessages [01] + ' [' + alltrim(str(_HMG_PRINTER_CurrentPageNumber)) + '/' + AllTrim( Str( _HMG_PRINTER_PageCount ) ) + ']'

   _OOHG_Auxil_Page:Value:=_HMG_PRINTER_CurrentPageNumber

   RETURN

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

PROCEDURE _HMG_PRINTER_PrintPagesDo()

   LOCAL i
   LOCAL PageFrom
   LOCAL PageTo
   LOCAL p
   LOCAL OddOnly := .F.
   LOCAL EvenOnly := .F.
   LOCAL nCopies

   If _HMG_PRINTER_PrintPages.Radio_1.Value == 1

      PageFrom := 1
      PageTo   := _HMG_PRINTER_PageCount

   ElseIf _HMG_PRINTER_PrintPages.Radio_1.Value == 2

      PageFrom := _HMG_PRINTER_PrintPages.Spinner_1.Value
      PageTo   := _HMG_PRINTER_PrintPages.Spinner_2.Value

      If _HMG_PRINTER_PrintPages.Combo_1.Value == 2
         OddOnly := .T.
      ElseIf _HMG_PRINTER_PrintPages.Combo_1.Value == 3
         EvenOnly := .T.
      EndIf

   EndIf

   // See comment in function _HMG_PRINTER_PrintPages()
   nCopies := If( _HMG_PRINTER_Copies > 1, 1, _HMG_PRINTER_PrintPages.Spinner_3.Value )

   _HMG_PRINTER_StartDoc( _HMG_PRINTER_hDC_Bak, _OOHG_PRINTER_DocName )

   If _HMG_PRINTER_PrintPages.CheckBox_1.Value  // Collate

      For p := 1 To nCopies
         For i := PageFrom To PageTo
            If OddOnly == .T.
               If i / 2 != Int( i / 2 )
                  _HMG_PRINTER_PRINTPAGE( _HMG_PRINTER_hDC_Bak, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
               EndIf
            ElseIf EvenOnly == .T.
               If i / 2 == Int( i / 2 )
                  _HMG_PRINTER_PRINTPAGE( _HMG_PRINTER_hDC_Bak, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
               EndIf
            Else
               _HMG_PRINTER_PRINTPAGE( _HMG_PRINTER_hDC_Bak, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
            EndIf
         Next i
      Next p

   Else

      For i := PageFrom To PageTo
         For p := 1 To nCopies
            If OddOnly == .T.
               If i / 2 != Int( i / 2 )
                  _HMG_PRINTER_PRINTPAGE( _HMG_PRINTER_hDC_Bak, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
               EndIf
            ElseIf EvenOnly == .T.
               If i / 2 == Int( i / 2 )
                  _HMG_PRINTER_PRINTPAGE( _HMG_PRINTER_hDC_Bak, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
               EndIf
            Else
               _HMG_PRINTER_PRINTPAGE( _HMG_PRINTER_hDC_Bak, _HMG_PRINTER_BasePageName + StrZero( i, 6 ) + ".emf" )
            EndIf
         Next p
      Next i

   EndIf

   _HMG_PRINTER_ENDDOC( _HMG_PRINTER_hDC_Bak )

   EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWPREVIEW" ) )
   EnableWindow( GetFormHandle( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
   EnableWindow( GetFormHandle( "_HMG_PRINTER_PPNAV" ) )

   HideWindow( GetFormHandle( "_HMG_PRINTER_PRINTPAGES" ) )

   _HMG_PRINTER_SHOWPREVIEW.SetFocus

   RETURN

PROCEDURE _HMG_PRINTER_MouseZoom()

   LOCAL Width := GetDesktopWidth()
   LOCAL Height := GetDesktopHeight()
   LOCAL Q := 0
   LOCAL DeltaHeight := 35 + GetTitleHeight() + GetBorderHeight() + 10

   If _HMG_PRINTER_Dz # 0

      _HMG_PRINTER_Dz := 0
      _HMG_PRINTER_Dx := 0
      _HMG_PRINTER_Dy := 0

      SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 50, .T. )
      SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 50, .T. )

      //      _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'))

   Else

      // Calculate Quadrant

      If _OOHG_mouseCol <= ( Width / 2 ) - _HMG_PRINTER_ZoomClick_xOffset .AND. ;
         _OOHG_MouseRow <= ( Height / 2 ) - DeltaHeight
         Q := 1
      Elseif _OOHG_mouseCol > ( Width / 2 ) - _HMG_PRINTER_ZoomClick_xOffset .AND. ;
             _OOHG_MouseRow <= ( Height / 2 ) - DeltaHeight
         Q := 2
      Elseif _OOHG_mousecol <= ( Width / 2 ) - _HMG_PRINTER_ZoomClick_xOffset .AND. ;
             _OOHG_MouseRow > ( Height / 2 ) - DeltaHeight
         Q := 3
      Elseif _OOHG_mouseCol > ( Width / 2 ) - _HMG_PRINTER_ZoomClick_xOffset .AND. ;
             _OOHG_MouseRow > ( Height / 2 ) - DeltaHeight
         Q := 4
      EndIf

      If _HMG_PRINTER_GETPAGEHEIGHT( _HMG_PRINTER_hDC_Bak ) > _HMG_PRINTER_GETPAGEWIDTH( _HMG_PRINTER_hDC_Bak )
         // Portrait

         If Q == 1
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := 100
            _HMG_PRINTER_Dy := 400
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 10, .T. )
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 40, .T. )
         ElseIf Q == 2
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := -100
            _HMG_PRINTER_Dy := 400
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 10, .T. )
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 60, .T. )
         ElseIf Q == 3
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := 100
            _HMG_PRINTER_Dy := -400
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 90, .T. )
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 40, .T. )
         ElseIf Q == 4
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := -100
            _HMG_PRINTER_Dy := -400
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 90, .T. )
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 60, .T. )
         EndIf
      Else
         // Landscape

         If Q == 1
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := 500
            _HMG_PRINTER_Dy := 300
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 20, .T. )
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 1, .T. )
         ElseIf Q == 2
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := -500
            _HMG_PRINTER_Dy := 300
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 20, .T. )
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 99, .T. )
         ElseIf Q == 3
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := 500
            _HMG_PRINTER_Dy := -300
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 80, .T. )
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 1, .T. )
         ElseIf Q == 4
            _HMG_PRINTER_Dz := 1000
            _HMG_PRINTER_Dx := -500
            _HMG_PRINTER_Dy := -300
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 80, .T. )
            SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 99, .T. )
         EndIf

      EndIf

      //      _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ) )
   EndIf

   _OOHG_Auxil_Zoom:Value := _HMG_PRINTER_Dz/200

   _HMG_PRINTER_PreviewRefresh()

   RETURN

PROCEDURE _HMG_PRINTER_Zoom()

   If _HMG_PRINTER_Dz # 0

      _HMG_PRINTER_Dz := 0
      _HMG_PRINTER_Dx := 0
      _HMG_PRINTER_Dy := 0
      SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_VERT, 50, .T. )
      SetScrollPos( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ), SB_HORZ, 50, .T. )
      //      _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ) )

   Else

      If _HMG_PRINTER_GETPAGEHEIGHT( _HMG_PRINTER_hDC_Bak ) > _HMG_PRINTER_GETPAGEWIDTH( _HMG_PRINTER_hDC_Bak )

         _HMG_PRINTER_Dz := 1000
         _HMG_PRINTER_Dx := 100
         _HMG_PRINTER_Dy := 400
         SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 10, .T. )
         SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 40, .T. )

      Else

         _HMG_PRINTER_Dz := 1000
         _HMG_PRINTER_Dx := 500
         _HMG_PRINTER_Dy := 300
         SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_VERT, 20, .T. )
         SetScrollPos( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'), SB_HORZ, 1, .T. )

      EndIf

      //      _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS( GetFormHandle( '_HMG_PRINTER_SHOWPREVIEW' ) )
   EndIf

   _OOHG_Auxil_Zoom:Value := _HMG_PRINTER_Dz/200

   _HMG_PRINTER_PreviewRefresh()

   RETURN

PROCEDURE _HMG_PRINTER_ScrollLeft()

   _HMG_PRINTER_Dx := _HMG_PRINTER_Dx + _HMG_PRINTER_ScrollStep
   If _HMG_PRINTER_Dx >= 500
      _HMG_PRINTER_Dx := 500
      PlayBeep()
   EndIf
   _HMG_PRINTER_PreviewRefresh()

   RETURN

PROCEDURE _HMG_PRINTER_ScrollRight()

   _HMG_PRINTER_Dx := _HMG_PRINTER_Dx - _HMG_PRINTER_ScrollStep
   If _HMG_PRINTER_Dx <= -500
      _HMG_PRINTER_Dx := -500
      PlayBeep()
   EndIf
   _HMG_PRINTER_PreviewRefresh()

   RETURN

PROCEDURE _HMG_PRINTER_ScrollUp()

   _HMG_PRINTER_Dy := _HMG_PRINTER_Dy + _HMG_PRINTER_ScrollStep
   If _HMG_PRINTER_Dy >= 500
      _HMG_PRINTER_Dy := 500
      PlayBeep()
   EndIf
   _HMG_PRINTER_PreviewRefresh()

   RETURN

PROCEDURE _HMG_PRINTER_ScrollDown()

   _HMG_PRINTER_Dy := _HMG_PRINTER_Dy - _HMG_PRINTER_ScrollStep
   If _HMG_PRINTER_Dy <= -500
      _HMG_PRINTER_Dy := -500
      PlayBeep()
   EndIf
   _HMG_PRINTER_PreviewRefresh()

   RETURN

FUNCTION GetPrinter()

   LOCAL RetVal := '', nValue
   LOCAL Printers := asort( aPrinters() )
   LOCAL cDefault := getdefaultprinter()

   _HMG_PRINTER_InitUserMessages()

   If Len( Printers ) == 0
      MsgExclamation( _HMG_PRINTER_UserMessages [102] )
      RETURN cDefault
   EndIf

   nValue := Max( aScan( Printers, cDefault ), 1 )

   DEFINE WINDOW _HMG_PRINTER_GETPRINTER ;
      AT 0, 0 ;
      WIDTH 345 ;
      HEIGHT GetTitleHeight() + 100 ;
      TITLE _HMG_PRINTER_UserMessages [13] ;
      MODAL ;
      NOSIZE

      @ 15, 10 COMBOBOX Combo_1 ITEMS Printers VALUE nvalue WIDTH 320

      @ 53, 65  BUTTON Ok CAPTION _HMG_PRINTER_UserMessages [11] ACTION( RetVal := Printers [ GetProperty( '_HMG_PRINTER_GETPRINTER', 'Combo_1', 'Value') ], DoMethod('_HMG_PRINTER_GETPRINTER', 'Release' ) )
      @ 53, 175 BUTTON Cancel CAPTION _HMG_PRINTER_UserMessages [12] ACTION( RetVal := '', DoMethod( '_HMG_PRINTER_GETPRINTER', 'Release' ) )
   END WINDOW

   CENTER WINDOW _HMG_PRINTER_GETPRINTER
   _HMG_PRINTER_getprinter.Ok.SetFocus()

   ACTIVATE WINDOW _HMG_PRINTER_GETPRINTER

   RETURN RetVal

PROCEDURE _HMG_PRINTER_H_Print( nHdc, nRow, nCol, cFontName, nFontSize, nColor1, nColor2, nColor3, cText, lbold, litalic, lunderline, lstrikeout, lcolor, lfont, lsize, lAngle, nAngle, lWidth, nWidth )

   DEFAULT lAngle TO .F.
   DEFAULT nAngle TO 0

   If ValType(cText) == "N"
      cText := AllTrim( Str( cText ) )
   Elseif ValType( cText ) == "D"
      cText := DtoC( cText )
   Elseif ValType( cText ) == "L"
      cText := If( cText == .T., _HMG_PRINTER_UserMessages [24], _HMG_PRINTER_UserMessages [25] )
   Elseif ValType( cText ) == "T"
      cText := TtoC( cText )
   Elseif ValType( cText ) == "A"
      RETURN
   Elseif ValType( cText ) == "B"
      RETURN
   Elseif ValType( cText ) == "O"
      RETURN
   Elseif ValType( cText ) == "U"
      RETURN
   EndIf

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )

   If lAngle
      nAngle := nAngle * 10
   EndIf

   _HMG_PRINTER_C_PRINT( nHdc, nRow, nCol, cFontName, nFontSize, nColor1, nColor2, nColor3, cText, lbold, litalic, lunderline, lstrikeout, lcolor, lfont, lsize, lAngle, nAngle, lWidth, nWidth )

   RETURN

PROCEDURE _HMG_PRINTER_H_MultiLine_Print( nHdc, nRow, nCol, nToRow, nToCol, cFontName, nFontSize, nColor1, nColor2, nColor3, cText, lbold, litalic, lunderline, lstrikeout, lcolor, lfont, lsize, lAngle, nAngle, lWidth, nWidth )

   DEFAULT lAngle TO .F.
   DEFAULT nAngle TO 0

   If ValType( cText ) == "N"
      cText := AllTrim( Str( cText ) )
   Elseif ValType( cText ) == "D"
      cText := DtoC( cText )
   Elseif ValType( cText ) == "L"
      cText := If( cText == .T., _HMG_PRINTER_UserMessages [24], _HMG_PRINTER_UserMessages [25] )
   Elseif ValType( cText ) == "T"
      cText := TtoC( cText )
   Elseif ValType( cText ) == "A"
      RETURN
   Elseif ValType( cText ) == "B"
      RETURN
   Elseif ValType( cText ) == "O"
      RETURN
   Elseif ValType( cText ) == "U"
      RETURN
   EndIf

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   If lAngle
      nAngle := nAngle * 10
   EndIf

   _HMG_PRINTER_C_MULTILINE_PRINT( nHdc, nRow, nCol, cFontName, nFontSize, nColor1, nColor2, nColor3, cText, lbold, litalic, lunderline, lstrikeout, lcolor, lfont, lsize, nToRow, nToCol, lAngle, nAngle, lWidth, nWidth )

   RETURN

PROCEDURE _HMG_PRINTER_H_Image( nHdc, cImage, nRow, nCol, nHeight, nWidth, lStretch )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nWidth := Int( nWidth * 10000 / 254 )
   nHeight := Int( nHeight * 10000 / 254 )

   _HMG_PRINTER_C_IMAGE( nHdc, cImage, nRow, nCol, nHeight, nWidth, lStretch )

   RETURN

PROCEDURE _HMG_PRINTER_H_Line( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lStyle, nStyle )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   If ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   EndIf

   _HMG_PRINTER_C_LINE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lStyle, nStyle )

   RETURN

PROCEDURE _HMG_PRINTER_H_Rectangle( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lStyle, nStyle, lBrushStyle, nBrStyle, lBrushColor, aBrColor)

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   If Empty( aBrColor )
      aBrColor := {0, 0, 0}
   EndIf

   If ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   EndIf

   _HMG_PRINTER_C_RECTANGLE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, ;
                             lcolor, lStyle, nStyle, lBrushStyle, nBrStyle, lBrushColor, aBrColor[1], aBrColor[2], aBrColor[3] )

   RETURN

PROCEDURE _HMG_PRINTER_H_RoundRectangle( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lStyle, nStyle, lBrushStyle, nBrStyle, lBrushColor, aBrColor )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   If Empty( aBrColor )
      aBrColor := {0, 0, 0}
   EndIf

   If ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   EndIf

   _HMG_PRINTER_C_ROUNDRECTANGLE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, ;
                                  lcolor, lStyle, nStyle, lBrushStyle, nBrStyle, lBrushColor, aBrColor[1], aBrColor[2], aBrColor[3] )

   RETURN

PROCEDURE _HMG_PRINTER_H_Fill( nHdc, nRow, nCol, nToRow, nToCol, nColor1, nColor2, nColor3, lcolor )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   // (LONG)((GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ));

   _HMG_PRINTER_C_FILL( nHdc, nRow, nCol, nToRow, nToCol, nColor1, nColor2, nColor3, lcolor )

   RETURN

PROCEDURE _HMG_PRINTER_H_Ellipse( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lStyle, nStyle, lBrushStyle, nBrStyle, lBrushColor, aBrColor)

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )

   If Empty( aBrColor )
      aBrColor := {0, 0, 0}
   EndIf

   If ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   EndIf

   _HMG_PRINTER_C_RECTANGLE( nHdc, nRow, nCol, nToRow, nToCol, nWidth, nColor1, nColor2, nColor3, lwidth, ;
                             lcolor, lStyle, nStyle, lBrushStyle, nBrStyle, lBrushColor, aBrColor[1], aBrColor[2], aBrColor[3] )

   RETURN

PROCEDURE _HMG_PRINTER_H_Arc( nHdc, nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lStyle, nStyle )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )
   x1 := Int( x1 * 10000 / 254 )
   y1 := Int( y1 * 10000 / 254 )
   x2 := Int( x2 * 10000 / 254 )
   y2 := Int( y2 * 10000 / 254 )

   If ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   EndIf

   _HMG_PRINTER_C_ARC( nHdc, nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lStyle, nStyle )

   RETURN

PROCEDURE _HMG_PRINTER_H_Pie( nHdc, nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, nColor1, nColor2, nColor3, lwidth, lcolor, lStyle, nStyle, lBrushStyle, nBrStyle, lBrushColor, aBrColor )

   nRow := Int( nRow * 10000 / 254 )
   nCol := Int( nCol * 10000 / 254 )
   nToRow := Int( nToRow * 10000 / 254 )
   nToCol := Int( nToCol * 10000 / 254 )
   x1 := Int( x1 * 10000 / 254 )
   y1 := Int( y1 * 10000 / 254 )
   x2 := Int( x2 * 10000 / 254 )
   y2 := Int( y2 * 10000 / 254 )

   If Empty(aBrColor)
      aBrColor := {0, 0, 0}
   EndIf

   If ValType( nWidth ) != 'U'
      nWidth := Int( nWidth * 10000 / 254 )
   EndIf

   _HMG_PRINTER_C_PIE( nHdc, nRow, nCol, nToRow, nToCol, x1, y1, x2, y2, nWidth, nColor1, nColor2, nColor3, lwidth, ;
                       lcolor, lStyle, nStyle, lBrushStyle, nBrStyle, lBrushColor, aBrColor[1], aBrColor[2], aBrColor[3] )

   RETURN

PROCEDURE _HMG_PRINTER_InitUserMessages()

   LOCAL   cLang, nAt
   PUBLIC  _HMG_PRINTER_UserMessages [103]
   PUBLIC _OOHG_PRINTER_DocName := "OOHG printing system"

   IF ! VALTYPE( cLang ) $ "CM" .OR. EMPTY( cLang )
      // [x]Harbour's default language
      cLang := Set( _SET_LANGUAGE )
   ENDIF
   IF ( nAt := At( ".", cLang ) ) > 0
      cLang := LEFT( cLang, nAt - 1 )
   ENDIF
   cLang := UPPER( ALLTRIM( cLang ) )

   // LANGUAGES NOT SUPPORTED BY hb_langSelect() FUNCTION.
   //        SET LANGUAGE TO FINNISH
   //        SET LANGUAGE TO DUTCH
   //        IF _HMG_LANG_ID == 'FI'         // FINNISH
   //           cLang := 'FI'
   //        ELSEIF _HMG_LANG_ID == 'NL'     // DUTCH
   //          cLang := 'NL'
   //        ENDIF

   Do Case

      Case cLang == "HR852"
   ///////////////////////////////////////////////////////////////////
   // CROATIAN
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Page'
         _HMG_PRINTER_UserMessages [02] := 'Print Preview'
         _HMG_PRINTER_UserMessages [03] := 'First Page [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Previous Page [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Next Page [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Last Page [END]'
         _HMG_PRINTER_UserMessages [07] := 'Go To Page'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Print'
         _HMG_PRINTER_UserMessages [10] := 'Page Number'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancel'
         _HMG_PRINTER_UserMessages [13] := 'Select Printer'
         _HMG_PRINTER_UserMessages [14] := 'Collate Copies'
         _HMG_PRINTER_UserMessages [15] := 'Print Range'
         _HMG_PRINTER_UserMessages [16] := 'All'
         _HMG_PRINTER_UserMessages [17] := 'Pages'
         _HMG_PRINTER_UserMessages [18] := 'From'
         _HMG_PRINTER_UserMessages [19] := 'To'
         _HMG_PRINTER_UserMessages [20] := 'Copies'
         _HMG_PRINTER_UserMessages [21] := 'All Range'
         _HMG_PRINTER_UserMessages [22] := 'Odd Pages Only'
         _HMG_PRINTER_UserMessages [23] := 'Even Pages Only'
         _HMG_PRINTER_UserMessages [24] := 'Yes'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Close'
         _HMG_PRINTER_UserMessages [27] := 'Save'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generating Thumbnails... Please Wait...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "EU"
   ///////////////////////////////////////////////////////////////////
   // BASQUE
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Page'
         _HMG_PRINTER_UserMessages [02] := 'Print Preview'
         _HMG_PRINTER_UserMessages [03] := 'First Page [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Previous Page [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Next Page [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Last Page [END]'
         _HMG_PRINTER_UserMessages [07] := 'Go To Page'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Print'
         _HMG_PRINTER_UserMessages [10] := 'Page Number'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancel'
         _HMG_PRINTER_UserMessages [13] := 'Select Printer'
         _HMG_PRINTER_UserMessages [14] := 'Collate Copies'
         _HMG_PRINTER_UserMessages [15] := 'Print Range'
         _HMG_PRINTER_UserMessages [16] := 'All'
         _HMG_PRINTER_UserMessages [17] := 'Pages'
         _HMG_PRINTER_UserMessages [18] := 'From'
         _HMG_PRINTER_UserMessages [19] := 'To'
         _HMG_PRINTER_UserMessages [20] := 'Copies'
         _HMG_PRINTER_UserMessages [21] := 'All Range'
         _HMG_PRINTER_UserMessages [22] := 'Odd Pages Only'
         _HMG_PRINTER_UserMessages [23] := 'Even Pages Only'
         _HMG_PRINTER_UserMessages [24] := 'Yes'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Close'
         _HMG_PRINTER_UserMessages [27] := 'Save'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generating Thumbnails... Please Wait...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "EN"
   ///////////////////////////////////////////////////////////////////
   // ENGLISH
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Page'
         _HMG_PRINTER_UserMessages [02] := 'Print Preview'
         _HMG_PRINTER_UserMessages [03] := 'First Page [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Previous Page [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Next Page [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Last Page [END]'
         _HMG_PRINTER_UserMessages [07] := 'Go To Page'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Print'
         _HMG_PRINTER_UserMessages [10] := 'Page Number'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancel'
         _HMG_PRINTER_UserMessages [13] := 'Select Printer'
         _HMG_PRINTER_UserMessages [14] := 'Collate Copies'
         _HMG_PRINTER_UserMessages [15] := 'Print Range'
         _HMG_PRINTER_UserMessages [16] := 'All'
         _HMG_PRINTER_UserMessages [17] := 'Pages'
         _HMG_PRINTER_UserMessages [18] := 'From'
         _HMG_PRINTER_UserMessages [19] := 'To'
         _HMG_PRINTER_UserMessages [20] := 'Copies'
         _HMG_PRINTER_UserMessages [21] := 'All Range'
         _HMG_PRINTER_UserMessages [22] := 'Odd Pages Only'
         _HMG_PRINTER_UserMessages [23] := 'Even Pages Only'
         _HMG_PRINTER_UserMessages [24] := 'Yes'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Close'
         _HMG_PRINTER_UserMessages [27] := 'Save'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generating Thumbnails... Please Wait...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "FR"
   ///////////////////////////////////////////////////////////////////
   // FRENCH
   ///////////////////////////////////////////////////////////////////

            _HMG_PRINTER_UserMessages [01] := 'Page'
            _HMG_PRINTER_UserMessages [02] := "Aperçu avant impression"
            _HMG_PRINTER_UserMessages [03] := 'Première page [HOME]'
            _HMG_PRINTER_UserMessages [04] := 'Page précédente [PGUP]'
            _HMG_PRINTER_UserMessages [05] := 'Page suivante [PGDN]'
            _HMG_PRINTER_UserMessages [06] := 'Dernière Page [END]'
            _HMG_PRINTER_UserMessages [07] := 'Allez page'
            _HMG_PRINTER_UserMessages [08] := 'Zoom'
            _HMG_PRINTER_UserMessages [09] := 'Imprimer'
            _HMG_PRINTER_UserMessages [10] := 'Page'
            _HMG_PRINTER_UserMessages [11] := 'Ok'
            _HMG_PRINTER_UserMessages [12] := 'Annulation'
            _HMG_PRINTER_UserMessages [13] := "Sélection de l'imprimante"
            _HMG_PRINTER_UserMessages [14] := "Assemblez"
            _HMG_PRINTER_UserMessages [15] := "Intervalle d'impression"
            _HMG_PRINTER_UserMessages [16] := 'Tous'
            _HMG_PRINTER_UserMessages [17] := 'Pages'
            _HMG_PRINTER_UserMessages [18] := 'De'
            _HMG_PRINTER_UserMessages [19] := 'À'
            _HMG_PRINTER_UserMessages [20] := 'Copies'
            _HMG_PRINTER_UserMessages [21] := 'Toutes les pages'
            _HMG_PRINTER_UserMessages [22] := 'Pages Impaires'
            _HMG_PRINTER_UserMessages [23] := 'Pages paires'
            _HMG_PRINTER_UserMessages [24] := 'Oui'
            _HMG_PRINTER_UserMessages [25] := 'Non'
            _HMG_PRINTER_UserMessages [26] := 'Fermer'
            _HMG_PRINTER_UserMessages [27] := 'Sauver'
            _HMG_PRINTER_UserMessages [28] := 'affichettes'
            _HMG_PRINTER_UserMessages [29] := 'Svp attente, étant les miniatures sont générées...'
            _HMG_PRINTER_UserMessages [101] := 'Sélectionner un dossier'
            _HMG_PRINTER_UserMessages [102] := "Aucune imprimeur n'est installé dans ce système."
            _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "DEWIN" .OR. cLang == "DE"
   ///////////////////////////////////////////////////////////////////
   // GERMAN
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Seite'
         _HMG_PRINTER_UserMessages [02] := 'Druckvorschau'
         _HMG_PRINTER_UserMessages [03] := 'Erste Seite [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Vorherige Seite [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Nächste Seite [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Letzte Seite [END]'
         _HMG_PRINTER_UserMessages [07] := 'Gehe zur Seite'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Druck'
         _HMG_PRINTER_UserMessages [10] := 'Seitenzahl'
         _HMG_PRINTER_UserMessages [11] := 'Okay'
         _HMG_PRINTER_UserMessages [12] := 'Löschen'
         _HMG_PRINTER_UserMessages [13] := 'Drucker wählen'
         _HMG_PRINTER_UserMessages [14] := 'Sortieren'
         _HMG_PRINTER_UserMessages [15] := 'Wählen Sie Druckbereich'
         _HMG_PRINTER_UserMessages [16] := 'Alle'
         _HMG_PRINTER_UserMessages [17] := 'Seiten'
         _HMG_PRINTER_UserMessages [18] := 'Von'
         _HMG_PRINTER_UserMessages [19] := 'Bis'
         _HMG_PRINTER_UserMessages [20] := 'Kopien'
         _HMG_PRINTER_UserMessages [21] := 'Alle Seiten'
         _HMG_PRINTER_UserMessages [22] := 'Nur ungerade Seiten'
         _HMG_PRINTER_UserMessages [23] := 'Nur gerade Seiten'
         _HMG_PRINTER_UserMessages [24] := 'Ja'
         _HMG_PRINTER_UserMessages [25] := 'Nein'
         _HMG_PRINTER_UserMessages [26] := 'Beenden'
         _HMG_PRINTER_UserMessages [27] := 'Speichern'
         _HMG_PRINTER_UserMessages [28] := 'Seitenminiaturen'
         _HMG_PRINTER_UserMessages [29] := 'Bitte warten, während die Seitenminiaturen erstellt werden...'
         _HMG_PRINTER_UserMessages [101] := 'Wählen Sie einen Ordner'
         _HMG_PRINTER_UserMessages [102] := 'Es sind keine Drucker im System installiert.'
         _HMG_PRINTER_UserMessages [103] := 'Bitte warten, während die Druckvorschau Schließens...'

      Case cLang == "IT"
   ///////////////////////////////////////////////////////////////////
   // ITALIAN
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Pagina'
         _HMG_PRINTER_UserMessages [02] := 'Anteprima di stampa'
         _HMG_PRINTER_UserMessages [03] := 'Prima Pagina [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Pagina Precedente [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Pagina Seguente [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Ultima Pagina [END]'
         _HMG_PRINTER_UserMessages [07] := 'Vai Alla Pagina'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Stampa'
         _HMG_PRINTER_UserMessages [10] := 'Pagina'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Annulla'
         _HMG_PRINTER_UserMessages [13] := 'Selezioni Lo Stampatore'
         _HMG_PRINTER_UserMessages [14] := 'Fascicoli'
         _HMG_PRINTER_UserMessages [15] := 'Intervallo di stampa'
         _HMG_PRINTER_UserMessages [16] := 'Tutti'
         _HMG_PRINTER_UserMessages [17] := 'Pagine'
         _HMG_PRINTER_UserMessages [18] := 'Da'
         _HMG_PRINTER_UserMessages [19] := 'A'
         _HMG_PRINTER_UserMessages [20] := 'Copie'
         _HMG_PRINTER_UserMessages [21] := 'Tutte le pagine'
         _HMG_PRINTER_UserMessages [22] := 'Le Pagine Pari'
         _HMG_PRINTER_UserMessages [23] := 'Le Pagine Dispari'
         _HMG_PRINTER_UserMessages [24] := 'Si'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Chiudi'
         _HMG_PRINTER_UserMessages [27] := 'Salva'
         _HMG_PRINTER_UserMessages [28] := 'Miniatura'
         _HMG_PRINTER_UserMessages [29] := 'Generando Miniatura...  Prego Attesa...'
         _HMG_PRINTER_UserMessages [101] := 'Selezionare una cartella'
         _HMG_PRINTER_UserMessages [102] := 'Nessuna stampatore è installata in questo sistema.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "PLWIN" .OR. cLang == "PL852" .OR. cLang == "PLISO" .OR. cLang == "PLMAZ"
   ///////////////////////////////////////////////////////////////////
   // POLISH
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Strona'
         _HMG_PRINTER_UserMessages [02] := 'Podgl¹d wydruku'
         _HMG_PRINTER_UserMessages [03] := 'Pierwsza strona [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Poprzednia strona [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Nastêpna strona [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Ostatnia strona [END]'
         _HMG_PRINTER_UserMessages [07] := 'Skocz do strony'
         _HMG_PRINTER_UserMessages [08] := 'Powiêksz'
         _HMG_PRINTER_UserMessages [09] := 'Drukuj'
         _HMG_PRINTER_UserMessages [10] := 'Numer strony'
         _HMG_PRINTER_UserMessages [11] := 'Tak'
         _HMG_PRINTER_UserMessages [12] := 'Przerwij'
         _HMG_PRINTER_UserMessages [13] := 'Wybierz drukarkê'
         _HMG_PRINTER_UserMessages [14] := 'Sortuj kopie'
         _HMG_PRINTER_UserMessages [15] := 'Zakres wydruku'
         _HMG_PRINTER_UserMessages [16] := 'Wszystkie'
         _HMG_PRINTER_UserMessages [17] := 'Strony'
         _HMG_PRINTER_UserMessages [18] := 'Od'
         _HMG_PRINTER_UserMessages [19] := 'Do'
         _HMG_PRINTER_UserMessages [20] := 'Kopie'
         _HMG_PRINTER_UserMessages [21] := 'Wszystkie'
         _HMG_PRINTER_UserMessages [22] := 'Nieparzyste'
         _HMG_PRINTER_UserMessages [23] := 'Parzyste'
         _HMG_PRINTER_UserMessages [24] := 'Tak'
         _HMG_PRINTER_UserMessages [25] := 'Nie'
         _HMG_PRINTER_UserMessages [26] := 'Zamknij'
         _HMG_PRINTER_UserMessages [27] := 'Zapisz'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generujê Thumbnails... Proszê czekaæ...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "PT"
   ///////////////////////////////////////////////////////////////////
   // PORTUGUESE
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Página'
         _HMG_PRINTER_UserMessages [02] := 'Inspecção prévia De Cópia'
         _HMG_PRINTER_UserMessages [03] := 'Primeira Página [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Página Precedente [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Página Seguinte [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Última Página [END]'
         _HMG_PRINTER_UserMessages [07] := 'Vá Paginar'
         _HMG_PRINTER_UserMessages [08] := 'amplie'
         _HMG_PRINTER_UserMessages [09] := 'Cópia'
         _HMG_PRINTER_UserMessages [10] := 'Página'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancelar'
         _HMG_PRINTER_UserMessages [13] := 'Selecione A Impressora'
         _HMG_PRINTER_UserMessages [14] := 'Ordene Cópias'
         _HMG_PRINTER_UserMessages [15] := 'Escala De Cópia'
         _HMG_PRINTER_UserMessages [16] := 'Tudo'
         _HMG_PRINTER_UserMessages [17] := 'Páginas'
         _HMG_PRINTER_UserMessages [18] := 'De'
         _HMG_PRINTER_UserMessages [19] := 'A'
         _HMG_PRINTER_UserMessages [20] := 'Cópias'
         _HMG_PRINTER_UserMessages [21] := 'Toda a Escala'
         _HMG_PRINTER_UserMessages [22] := 'Páginas Impares Somente'
         _HMG_PRINTER_UserMessages [23] := 'Páginas Uniformes Somente'
         _HMG_PRINTER_UserMessages [24] := 'Sim'
         _HMG_PRINTER_UserMessages [25] := 'Não'
         _HMG_PRINTER_UserMessages [26] := 'Fechar'
         _HMG_PRINTER_UserMessages [27] := 'Salvar'
         _HMG_PRINTER_UserMessages [28] := 'Miniaturas'
         _HMG_PRINTER_UserMessages [29] := 'Gerando Miniaturas...  Por favor Espera...'
         _HMG_PRINTER_UserMessages [101] := 'Selecione uma pasta'
         _HMG_PRINTER_UserMessages [102] := 'Nenhuma impressora está instalado neste sistema.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8"
   ///////////////////////////////////////////////////////////////////
   // RUSSIAN
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Page'
         _HMG_PRINTER_UserMessages [02] := 'Print Preview'
         _HMG_PRINTER_UserMessages [03] := 'First Page [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Previous Page [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Next Page [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Last Page [END]'
         _HMG_PRINTER_UserMessages [07] := 'Go To Page'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Print'
         _HMG_PRINTER_UserMessages [10] := 'Page Number'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancel'
         _HMG_PRINTER_UserMessages [13] := 'Select Printer'
         _HMG_PRINTER_UserMessages [14] := 'Collate Copies'
         _HMG_PRINTER_UserMessages [15] := 'Print Range'
         _HMG_PRINTER_UserMessages [16] := 'All'
         _HMG_PRINTER_UserMessages [17] := 'Pages'
         _HMG_PRINTER_UserMessages [18] := 'From'
         _HMG_PRINTER_UserMessages [19] := 'To'
         _HMG_PRINTER_UserMessages [20] := 'Copies'
         _HMG_PRINTER_UserMessages [21] := 'All Range'
         _HMG_PRINTER_UserMessages [22] := 'Odd Pages Only'
         _HMG_PRINTER_UserMessages [23] := 'Even Pages Only'
         _HMG_PRINTER_UserMessages [24] := 'Yes'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Close'
         _HMG_PRINTER_UserMessages [27] := 'Save'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generating Thumbnails... Please Wait...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "ES"  .OR. cLang == "ESWIN"
   ///////////////////////////////////////////////////////////////////
   // SPANISH
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Página'
         _HMG_PRINTER_UserMessages [02] := 'Vista Previa'
         _HMG_PRINTER_UserMessages [03] := 'Inicio [INICIO]'
         _HMG_PRINTER_UserMessages [04] := 'Anterior [REPAG]'
         _HMG_PRINTER_UserMessages [05] := 'Siguiente [AVPAG]'
         _HMG_PRINTER_UserMessages [06] := 'Fin [FIN]'
         _HMG_PRINTER_UserMessages [07] := 'Ir a'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Imprimir'
         _HMG_PRINTER_UserMessages [10] := 'Página Nro.'
         _HMG_PRINTER_UserMessages [11] := 'Aceptar'
         _HMG_PRINTER_UserMessages [12] := 'Cancelar'
         _HMG_PRINTER_UserMessages [13] := 'Seleccionar Impresora'
         _HMG_PRINTER_UserMessages [14] := 'Ordenar Copias'
         _HMG_PRINTER_UserMessages [15] := 'Rango de Impresión'
         _HMG_PRINTER_UserMessages [16] := 'Todo'
         _HMG_PRINTER_UserMessages [17] := 'Páginas'
         _HMG_PRINTER_UserMessages [18] := 'Desde'
         _HMG_PRINTER_UserMessages [19] := 'Hasta'
         _HMG_PRINTER_UserMessages [20] := 'Copias'
         _HMG_PRINTER_UserMessages [21] := 'Todo El Rango'
         _HMG_PRINTER_UserMessages [22] := 'Solo Páginas Impares'
         _HMG_PRINTER_UserMessages [23] := 'Solo Páginas Pares'
         _HMG_PRINTER_UserMessages [24] := 'Si'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Cerrar'
         _HMG_PRINTER_UserMessages [27] := 'Guardar'
         _HMG_PRINTER_UserMessages [28] := 'Miniaturas'
         _HMG_PRINTER_UserMessages [29] := 'Generando Miniaturas... Espere Por Favor...'
         _HMG_PRINTER_UserMessages [101] := 'Seleccione Una Carpeta'
         _HMG_PRINTER_UserMessages [102] := 'No hay impresora instalada en este sistema.'
         _HMG_PRINTER_UserMessages [103] := 'Cerrando vista previa... Espere Por Favor...'

      Case cLang == "FI"
   ///////////////////////////////////////////////////////////////////
   // FINNISH
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Page'
         _HMG_PRINTER_UserMessages [02] := 'Print Preview'
         _HMG_PRINTER_UserMessages [03] := 'First Page [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Previous Page [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Next Page [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Last Page [END]'
         _HMG_PRINTER_UserMessages [07] := 'Go To Page'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Print'
         _HMG_PRINTER_UserMessages [10] := 'Page Number'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancel'
         _HMG_PRINTER_UserMessages [13] := 'Select Printer'
         _HMG_PRINTER_UserMessages [14] := 'Collate Copies'
         _HMG_PRINTER_UserMessages [15] := 'Print Range'
         _HMG_PRINTER_UserMessages [16] := 'All'
         _HMG_PRINTER_UserMessages [17] := 'Pages'
         _HMG_PRINTER_UserMessages [18] := 'From'
         _HMG_PRINTER_UserMessages [19] := 'To'
         _HMG_PRINTER_UserMessages [20] := 'Copies'
         _HMG_PRINTER_UserMessages [21] := 'All Range'
         _HMG_PRINTER_UserMessages [22] := 'Odd Pages Only'
         _HMG_PRINTER_UserMessages [23] := 'Even Pages Only'
         _HMG_PRINTER_UserMessages [24] := 'Yes'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Close'
         _HMG_PRINTER_UserMessages [27] := 'Save'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generating Thumbnails... Please Wait...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "NL"
   ///////////////////////////////////////////////////////////////////
   // DUTCH
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Page'
         _HMG_PRINTER_UserMessages [02] := 'Print Preview'
         _HMG_PRINTER_UserMessages [03] := 'First Page [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Previous Page [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Next Page [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Last Page [END]'
         _HMG_PRINTER_UserMessages [07] := 'Go To Page'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Print'
         _HMG_PRINTER_UserMessages [10] := 'Page Number'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancel'
         _HMG_PRINTER_UserMessages [13] := 'Select Printer'
         _HMG_PRINTER_UserMessages [14] := 'Collate Copies'
         _HMG_PRINTER_UserMessages [15] := 'Print Range'
         _HMG_PRINTER_UserMessages [16] := 'All'
         _HMG_PRINTER_UserMessages [17] := 'Pages'
         _HMG_PRINTER_UserMessages [18] := 'From'
         _HMG_PRINTER_UserMessages [19] := 'To'
         _HMG_PRINTER_UserMessages [20] := 'Copies'
         _HMG_PRINTER_UserMessages [21] := 'All Range'
         _HMG_PRINTER_UserMessages [22] := 'Odd Pages Only'
         _HMG_PRINTER_UserMessages [23] := 'Even Pages Only'
         _HMG_PRINTER_UserMessages [24] := 'Yes'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Close'
         _HMG_PRINTER_UserMessages [27] := 'Save'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generating Thumbnails... Please Wait...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437"
   ///////////////////////////////////////////////////////////////////
   // SLOVENIAN
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Page'
         _HMG_PRINTER_UserMessages [02] := 'Print Preview'
         _HMG_PRINTER_UserMessages [03] := 'First Page [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Previous Page [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Next Page [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Last Page [END]'
         _HMG_PRINTER_UserMessages [07] := 'Go To Page'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Print'
         _HMG_PRINTER_UserMessages [10] := 'Page Number'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancel'
         _HMG_PRINTER_UserMessages [13] := 'Select Printer'
         _HMG_PRINTER_UserMessages [14] := 'Collate Copies'
         _HMG_PRINTER_UserMessages [15] := 'Print Range'
         _HMG_PRINTER_UserMessages [16] := 'All'
         _HMG_PRINTER_UserMessages [17] := 'Pages'
         _HMG_PRINTER_UserMessages [18] := 'From'
         _HMG_PRINTER_UserMessages [19] := 'To'
         _HMG_PRINTER_UserMessages [20] := 'Copies'
         _HMG_PRINTER_UserMessages [21] := 'All Range'
         _HMG_PRINTER_UserMessages [22] := 'Odd Pages Only'
         _HMG_PRINTER_UserMessages [23] := 'Even Pages Only'
         _HMG_PRINTER_UserMessages [24] := 'Yes'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Close'
         _HMG_PRINTER_UserMessages [27] := 'Save'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generating Thumbnails... Please Wait...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

      Otherwise
   ///////////////////////////////////////////////////////////////////
   // DEFAULT TO ENGLISH
   ///////////////////////////////////////////////////////////////////

         _HMG_PRINTER_UserMessages [01] := 'Page'
         _HMG_PRINTER_UserMessages [02] := 'Print Preview'
         _HMG_PRINTER_UserMessages [03] := 'First Page [HOME]'
         _HMG_PRINTER_UserMessages [04] := 'Previous Page [PGUP]'
         _HMG_PRINTER_UserMessages [05] := 'Next Page [PGDN]'
         _HMG_PRINTER_UserMessages [06] := 'Last Page [END]'
         _HMG_PRINTER_UserMessages [07] := 'Go To Page'
         _HMG_PRINTER_UserMessages [08] := 'Zoom'
         _HMG_PRINTER_UserMessages [09] := 'Print'
         _HMG_PRINTER_UserMessages [10] := 'Page Number'
         _HMG_PRINTER_UserMessages [11] := 'Ok'
         _HMG_PRINTER_UserMessages [12] := 'Cancel'
         _HMG_PRINTER_UserMessages [13] := 'Select Printer'
         _HMG_PRINTER_UserMessages [14] := 'Collate Copies'
         _HMG_PRINTER_UserMessages [15] := 'Print Range'
         _HMG_PRINTER_UserMessages [16] := 'All'
         _HMG_PRINTER_UserMessages [17] := 'Pages'
         _HMG_PRINTER_UserMessages [18] := 'From'
         _HMG_PRINTER_UserMessages [19] := 'To'
         _HMG_PRINTER_UserMessages [20] := 'Copies'
         _HMG_PRINTER_UserMessages [21] := 'All Range'
         _HMG_PRINTER_UserMessages [22] := 'Odd Pages Only'
         _HMG_PRINTER_UserMessages [23] := 'Even Pages Only'
         _HMG_PRINTER_UserMessages [24] := 'Yes'
         _HMG_PRINTER_UserMessages [25] := 'No'
         _HMG_PRINTER_UserMessages [26] := 'Close'
         _HMG_PRINTER_UserMessages [27] := 'Save'
         _HMG_PRINTER_UserMessages [28] := 'Thumbnails'
         _HMG_PRINTER_UserMessages [29] := 'Generating Thumbnails... Please Wait...'
         _HMG_PRINTER_UserMessages [101] := 'Select a Folder'
         _HMG_PRINTER_UserMessages [102] := 'No printer is installed in this system.'
         _HMG_PRINTER_UserMessages [103] := 'Closing preview... Please Wait...'

   EndCase

   RETURN

FUNCTION GetPrintableAreaWidth()

   If ! __MVEXIST( '_HMG_PRINTER_hDC' )
      RETURN 0
   EndIf

   RETURN _HMG_PRINTER_GETPRINTERWIDTH( _HMG_PRINTER_hDC )

FUNCTION GetPrintableAreaHeight()

   If ! __MVEXIST( '_HMG_PRINTER_hDC' )
      RETURN 0
   EndIf

   RETURN _HMG_PRINTER_GETPRINTERHEIGHT( _HMG_PRINTER_hDC )

FUNCTION GetPrintableAreaHorizontalOffset()

   If ! __MVEXIST( '_HMG_PRINTER_hDC' )
      RETURN 0
   EndIf

   RETURN( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETX( _HMG_PRINTER_hDC ) / _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSX( _HMG_PRINTER_hDC ) * 25.4 )

FUNCTION GetPrintableAreaVerticalOffset()

   If ! __MVEXIST( '_HMG_PRINTER_hDC' )
      RETURN 0
   EndIf

   RETURN( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETY( _HMG_PRINTER_hDC ) / _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSY( _HMG_PRINTER_hDC ) * 25.4 )

FUNCTION _HMG_PRINTER_SetJobName( cName )

   If ValType( cName ) = 'U'
      _OOHG_PRINTER_DocName := 'OOHG Printing System'
   Else
      _OOHG_PRINTER_DocName := cName
   EndIf

   RETURN NIL

FUNCTION _HMG_PRINTER_TextAlign( nAlign )

   _HMG_PRINTER_SetTextAlign( _HMG_PRINTER_hDC, nAlign )

   RETURN NIL

FUNCTION _HMG_PRINTER_PreviewZoom( nSize )

   If PCount() > 1
      If ! __MVEXIST( '_HMG_PRINTER_Dz' )
         __MVPUBLIC( '_HMG_PRINTER_Dz' )
      EndIf
      _HMG_PRINTER_Dz := nSize * 200
      If HB_IsObject( _OOHG_Auxil_Zoom )
         _OOHG_Auxil_Zoom:Value := _HMG_PRINTER_Dz / 200
      EndIf
   Else
      If ! __MVEXIST( '_HMG_PRINTER_Dz' )
         __MVPUBLIC( '_HMG_PRINTER_Dz' )
         _HMG_PRINTER_Dz := 0
      EndIf
   EndIf

   RETURN ( _HMG_PRINTER_Dz / 200 )


#pragma BEGINDUMP

   ///////////////////////////////////////////////////////////////////
   // LOW LEVEL C PRINT ROUTINES
   ///////////////////////////////////////////////////////////////////

#include <windows.h>
#include <stdio.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include <winuser.h>
#include <wingdi.h>
#include "commctrl.h"
#include "olectl.h"
#include "oohg.h"

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
// error codes returned by _HMG_PRINTER_PRINTDIALOG
#define ERR_PRINTDLG                                0x00100000


HB_FUNC( _HMG_PRINTER_SETTEXTALIGN )
{
   hb_retni( SetTextAlign( (HDC) hb_parnl( 1 ), hb_parni( 2 ) ) );
}

HB_FUNC( _HMG_PRINTER_ABORTDOC )
{
   HDC hdcPrint = (HDC) hb_parnl( 1 );
   AbortDoc( hdcPrint );
}

HB_FUNC( _HMG_PRINTER_STARTDOC )
{
   DOCINFO docInfo;

   HDC hdcPrint = (HDC) hb_parnl( 1 );

   if( hdcPrint != 0 )
   {
      ZeroMemory( &docInfo, sizeof( docInfo ) );
      docInfo.cbSize = sizeof( docInfo );
      docInfo.lpszDocName = hb_parc( 2 );

      StartDoc( hdcPrint, &docInfo );
   }
}

HB_FUNC( _HMG_PRINTER_STARTPAGE )
{
   HDC hdcPrint = (HDC) hb_parnl( 1 );

   if( hdcPrint != 0 )
   {
      StartPage( hdcPrint );
   }
}

HB_FUNC( _HMG_PRINTER_C_PRINT )
{
   // 1:  Hdc
   // 2:  y
   // 3:  x
   // 4:  FontName
   // 5:  FontSize
   // 6:  R Color
   // 7:  G Color
   // 8:  B Color
   // 9:  Text
   // 10: Bold
   // 11: Italic
   // 12: Underline
   // 13: StrikeOut
   // 14: Color Flag
   // 15: FontName Flag
   // 16: FontSize Flag
   // 17: lAngle
   // 18: nAngle
   // 19: lWidth
   // 20: Width

   HGDIOBJ hgdiobj;
   char FontName [32];
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
   HDC hdcPrint = (HDC) hb_parnl( 1 );
   int FontHeight;

   if( hdcPrint != 0 )
   {
      // Bold
      if( hb_parl( 10 ) )
      {
         fnWeight = FW_BOLD;
      }
      else
      {
         fnWeight = FW_NORMAL;
      }

      // Italic
      if( hb_parl( 11 ) )
      {
         fdwItalic = TRUE;
      }
      else
      {
         fdwItalic = FALSE;
      }

      // UnderLine
      if( hb_parl( 12 ) )
      {
         fdwUnderline = TRUE;
      }
      else
      {
         fdwUnderline = FALSE;
      }

      // StrikeOut
      if( hb_parl( 13 ) )
      {
         fdwStrikeOut = TRUE;
      }
      else
      {
         fdwStrikeOut = FALSE;
      }

      // Color
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

      // Angle
      if( hb_parl( 17 ) )
      {
         nAngle = hb_parnl( 18 );
      }
      else
      {
         nAngle = 0;
      }

      // Width
      if( hb_parl( 19 ) )
      {
         nWidth = hb_parnl( 20 );
      }
      else
      {
         nWidth = 0;
      }

      // Fontname
      if( hb_parl( 15 ) )
      {
         strcpy( FontName, hb_parc( 4 ) );
      }
      else
      {
         strcpy( FontName, "Arial" );
      }

      // FontSize
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
                          DEFAULT_CHARSET,
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
               strlen( hb_parc( 9 ) ) );

      SelectObject( hdcPrint, hgdiobj );

      DeleteObject( hfont );
   }
}

HB_FUNC( _HMG_PRINTER_C_MULTILINE_PRINT )
{
   // 1:  Hdc
   // 2:  y
   // 3:  x
   // 4:  FontName
   // 5:  FontSize
   // 6:  R Color
   // 7:  G Color
   // 8:  B Color
   // 9:  Text
   // 10: Bold
   // 11: Italic
   // 12: Underline
   // 13: StrikeOut
   // 14: Color Flag
   // 15: FontName Flag
   // 16: FontSize Flag
   // 17: ToRow
   // 18: ToCol

   HGDIOBJ hgdiobj;
   char FontName [32];
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
   int toy = hb_parni( 17 );
   int tox = hb_parni( 18 );
   HFONT hfont;
   HDC hdcPrint = (HDC) hb_parnl( 1 );
   int FontHeight;

   if( hdcPrint != 0 )
   {
      // Bold
      if( hb_parl( 10 ) )
      {
         fnWeight = FW_BOLD;
      }
      else
      {
         fnWeight = FW_NORMAL;
      }

      // Italic
      if( hb_parl( 11 ) )
      {
         fdwItalic = TRUE;
      }
      else
      {
         fdwItalic = FALSE;
      }

      // UnderLine
      if( hb_parl( 12 ) )
      {
         fdwUnderline = TRUE;
      }
      else
      {
         fdwUnderline = FALSE;
      }

      // StrikeOut
      if( hb_parl( 13 ) )
      {
         fdwStrikeOut = TRUE;
      }
      else
      {
         fdwStrikeOut = FALSE;
      }

      // Color
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

      // Fontname
      if( hb_parl( 15 ) )
      {
         strcpy( FontName, hb_parc( 4 ) );
      }
      else
      {
         strcpy( FontName, "Arial" );
      }

      // FontSize
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
                          0,
                          0,
                          0,
                          fnWeight,
                          fdwItalic,
                          fdwUnderline,
                          fdwStrikeOut,
                          DEFAULT_CHARSET,
                          OUT_TT_PRECIS,
                          CLIP_DEFAULT_PRECIS,
                          DEFAULT_QUALITY,
                          FF_DONTCARE,
                          FontName );

      hgdiobj = SelectObject( hdcPrint, hfont );

      SetTextColor( hdcPrint, RGB( r, g, b ) );
      SetBkMode( hdcPrint, TRANSPARENT );

      rect.left = ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX );
      rect.top = ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) ;
      rect.right = ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX );
      rect.bottom = ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY );

      DrawText( hdcPrint,
                hb_parc( 9 ),
                strlen( hb_parc( 9 ) ),
                &rect,
                DT_NOPREFIX | DT_MODIFYSTRING | DT_WORDBREAK | DT_END_ELLIPSIS );

      SelectObject( hdcPrint, hgdiobj );

      DeleteObject( hfont );
   }
}

HB_FUNC( _HMG_PRINTER_ENDPAGE )
{
   HDC hdcPrint = (HDC) hb_parnl( 1 );

   if( hdcPrint != 0 )
   {
      EndPage( hdcPrint );
   }
}

HB_FUNC( _HMG_PRINTER_ENDDOC )
{
   HDC hdcPrint = (HDC) hb_parnl( 1 );

   if( hdcPrint != 0 )
   {
      EndDoc( hdcPrint );
   }
}

HB_FUNC( _HMG_PRINTER_DELETEDC )
{
   HDC hdcPrint = (HDC) hb_parnl( 1 );

   DeleteDC( hdcPrint );
}

HB_FUNC( _HMG_PRINTER_PRINTDIALOG )
{
   PRINTDLG pd;
   LPDEVMODE pDevMode;
   pd.lStructSize = sizeof(PRINTDLG);
   pd.hDevMode = (HANDLE) NULL;
   pd.hDevNames = (HANDLE) NULL;
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
   pd.lpfnPrintHook = (LPPRINTHOOKPROC) NULL;
   pd.lpfnSetupHook = (LPSETUPHOOKPROC) NULL;
   pd.lpPrintTemplateName = (LPSTR) NULL;
   pd.lpSetupTemplateName = (LPSTR)  NULL;
   pd.hPrintTemplate = (HANDLE) NULL;
   pd.hSetupTemplate = (HANDLE) NULL;

   if( PrintDlg( &pd ) )
   {
      pDevMode = (LPDEVMODE) GlobalLock( pd.hDevMode );

      hb_reta( 5 );
      HB_STORNL3( (LONG_PTR) pd.hDC, -1, 1 );
      HB_STORC( ( char * ) pDevMode->dmDeviceName, -1, 2 );
      HB_STORNI( pDevMode->dmCopies, -1, 3 );
      HB_STORNI( pDevMode->dmCollate, -1, 4 );
      HB_STORNI( 0, -1, 5 );

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
   }
}

HB_FUNC( APRINTERS )   //Pier Release
{
   OSVERSIONINFO osVer;
   DWORD level;
   DWORD flags;
   DWORD dwSize = 0;
   DWORD dwPrinters = 0;
   DWORD i;
   char *pBuffer;
   char *cBuffer;
   PRINTER_INFO_4* pInfo_4;
   PRINTER_INFO_5* pInfo_5;
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
            pInfo_4 = (PRINTER_INFO_4*) pBuffer;
            hb_reta( dwPrinters );
            for( i = 0; i < dwPrinters; i++, pInfo_4++)
            {
               cBuffer = (char *) GlobalAlloc( GPTR, 256 );
               strcat( cBuffer, pInfo_4->pPrinterName );
               HB_STORC( cBuffer, -1, i+1 );
               GlobalFree( cBuffer );
            }
            GlobalFree( pBuffer );
            break;
         default:
            pInfo_5 = (PRINTER_INFO_5*) pBuffer;
            hb_reta( dwPrinters );
            for( i = 0; i < dwPrinters; i++, pInfo_5++)
            {
               cBuffer = (char *) GlobalAlloc( GPTR, 256 );
               strcat( cBuffer, pInfo_5->pPrinterName );
               HB_STORC( cBuffer, -1, i+1 );
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

HB_FUNC( _HMG_PRINTER_C_RECTANGLE )
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: width
   // 7: R Color
   // 8: G Color
   // 9: B Color
   // 10: lWindth
   // 11: lColor
   // 12: lStyle
   // 13: nStyle
   // 14: lBrusStyle
   // 15: nBrushStyle
   // 16: lBrushColor
   // 17: nColorR
   // 18: nColorG
   // 19: nColorB

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
   int nBr;
   long nBh;
   HDC hdcPrint = (HDC) hb_parnl( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdcPrint != 0 )
   {
      // Width
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // Color
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

      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      if( hb_parl( 14 ) )
      {
         nBh = hb_parni( 15 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 16 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

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

      pbr.lbStyle = nBr;
      pbr.lbColor = (COLORREF) RGB( br, bg, bb );
      pbr.lbHatch = (LONG) nBh;

      hpen = CreatePen( nStyle, ( width * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( (HDC) hdcPrint, hpen );
      hgdiobj2 = SelectObject( (HDC) hdcPrint, hbr );
      Rectangle( (HDC) hdcPrint,
                 ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
                 ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
                 ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
                 ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      SelectObject( (HDC) hdcPrint, (HGDIOBJ) hgdiobj );
      SelectObject( (HDC) hdcPrint, (HGDIOBJ) hgdiobj2 );

      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

HB_FUNC( _HMG_PRINTER_C_ROUNDRECTANGLE )
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: width
   // 7: R Color
   // 8: G Color
   // 9: B Color
   // 10: lWindth
   // 11: lColor
   // 12: lStyle
   // 13: nStyle
   // 14: lBrusStyle
   // 15: nBrushStyle
   // 16: lBrushColor
   // 17: nColorR
   // 18: nColorG
   // 19: nColorB

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
   int nBr;
   long nBh;
   HDC hdcPrint = (HDC) hb_parnl( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdcPrint != 0 )
   {
      // Width
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // Color
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

      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      if( hb_parl( 14 ) )
      {
         nBh = hb_parni( 15 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 16 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

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

      pbr.lbStyle = nBr;
      pbr.lbColor = (COLORREF) RGB( br, bg, bb );
      pbr.lbHatch = (LONG) nBh;

      hpen = CreatePen( nStyle, ( width * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( (HDC) hdcPrint, hpen );
      hgdiobj2 = SelectObject( (HDC) hdcPrint, hbr );

      w = ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 );
      h = ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 );
      p = ( w + h ) / 2;
      p = p / 10;

      RoundRect( (HDC) hdcPrint,
                 ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
                 ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
                 ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
                 ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
                 p,
                 p );

      SelectObject( (HDC) hdcPrint, (HGDIOBJ) hgdiobj );
      SelectObject( (HDC) hdcPrint, (HGDIOBJ) hgdiobj2 );

      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

HB_FUNC( _HMG_PRINTER_C_FILL )
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: R Color
   // 7: G Color
   // 8: B Color
   // 9: lColor

   int r;
   int g;
   int b;
   int x = hb_parnl( 3 );
   int y = hb_parnl( 2 );
   int tox = hb_parnl( 5 );
   int toy = hb_parnl( 4 );
   RECT rect;
   HDC hdcPrint = (HDC) hb_parnl( 1 );
   HGDIOBJ hgdiobj;
   HBRUSH hBrush;

   if( hdcPrint != 0 )
   {
      // Color
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

      rect.left = (LONG) ( ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ) );
      rect.top = (LONG) ( ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );
      rect.right = (LONG) ( ( tox *GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ) );
      rect.bottom = (LONG) ( ( toy *GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      hBrush = CreateSolidBrush( RGB(r, g, b) );
      hgdiobj = SelectObject( (HDC) hdcPrint, hBrush );
      FillRect( (HDC) hdcPrint, &rect, (HBRUSH) hBrush );
      SelectObject( (HDC) hdcPrint, (HGDIOBJ) hgdiobj );
      DeleteObject( hBrush );
   }
}

HB_FUNC( _HMG_PRINTER_C_LINE )
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: width
   // 7: R Color
   // 8: G Color
   // 9: B Color
   // 10: lWindth
   // 11: lColor
   // 12: lStyle
   // 13: nStyle

   int r;
   int g;
   int b;
   int x = hb_parni( 3 );
   int y = hb_parni( 2 );
   int tox = hb_parni( 5 );
   int toy = hb_parni( 4 );
   int width;
   int nStyle;
   HDC hdcPrint = (HDC) hb_parnl( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;

   if( hdcPrint != 0 )
   {
      // Width
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // Color
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

      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      hpen = CreatePen( nStyle, ( width * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r, g, b ) );

      hgdiobj = SelectObject( (HDC) hdcPrint, hpen );

      MoveToEx( (HDC) hdcPrint,
                ( x * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
                ( y * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ),
                NULL );

      LineTo( (HDC) hdcPrint,
              ( tox * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX ),
              ( toy * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY ) );

      SelectObject( (HDC) hdcPrint, (HGDIOBJ) hgdiobj );

      DeleteObject( hpen );
   }
}

/*
http://support.microsoft.com/kb/246772/EN-US
http://support.microsoft.com/default.aspx?scid=kb;EN-US;Q167345
http://support.microsoft.com/kb/140285/EN-US
*/
HB_FUNC( _HMG_PRINTER_SETPRINTERPROPERTIES )
{
   HANDLE hPrinter = NULL;
   DWORD dwNeeded = 0;
   PRINTER_INFO_2 *pi2;
   DEVMODE *pDevMode = NULL;
   BOOL bFlag;
   BOOL bVerbose = ! hb_parl( 13 );
   BOOL bAbort = ! hb_parl( 14 );
   BOOL bGlobal = hb_parl( 15 );
   LONG lFlag;
   HDC hdcPrint;
   int fields = 0;
   int error = 0;

   ///////////////////////////////////////////////////////////////////
   // Get the current settings from the printer's driver
   ///////////////////////////////////////////////////////////////////

   bFlag = OpenPrinter( (char *) hb_parc( 1 ), &hPrinter, NULL );

   if( !bFlag || ( hPrinter == NULL ) )
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

   pi2 = (PRINTER_INFO_2 *) GlobalAlloc( GPTR, dwNeeded );

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

   bFlag = GetPrinter( hPrinter, 2, (LPBYTE) pi2, dwNeeded, &dwNeeded );

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

   if(pi2->pDevMode == NULL)
   {
      dwNeeded = DocumentProperties( NULL, hPrinter, (char *) hb_parc( 1 ), NULL, NULL, 0 );
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

      pDevMode = (DEVMODE *) GlobalAlloc( GPTR, dwNeeded );
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

      lFlag = DocumentProperties( NULL, hPrinter, ( char * ) hb_parc( 1 ), pDevMode, NULL, DM_OUT_BUFFER );
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

   ///////////////////////////////////////////////////////////////////
   // Set new values if the driver supports changing the properties
   ///////////////////////////////////////////////////////////////////

   // Orientation
   if( hb_parni( 2 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_ORIENTATION )
      {
         fields = fields | DM_ORIENTATION;
         pi2->pDevMode->dmOrientation = (short) hb_parni( 2 );
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

   // PaperSize
   if( hb_parni( 3 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_PAPERSIZE )
      {
         fields = fields | DM_PAPERSIZE;
         pi2->pDevMode->dmPaperSize = (short) hb_parni( 3 );
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

   // PaperLenght
   if( hb_parni( 4 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_PAPERLENGTH )
      {
         fields = fields | DM_PAPERLENGTH;
         pi2->pDevMode->dmPaperLength = (short) ( hb_parni( 4 ) * 10 );
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

   // PaperWidth
   if( hb_parni( 5 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_PAPERWIDTH )
      {
         fields = fields | DM_PAPERWIDTH ;
         pi2->pDevMode->dmPaperWidth = (short) ( hb_parni( 5 ) * 10 );
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

   // Copies
   if( hb_parni( 6 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_COPIES )
      {
         fields = fields | DM_COPIES;
         pi2->pDevMode->dmCopies = (short) hb_parni( 6 );
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

   // Default Source
   if( hb_parni( 7 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_DEFAULTSOURCE )
      {
         fields = fields | DM_DEFAULTSOURCE;
         pi2->pDevMode->dmDefaultSource = (short) hb_parni( 7 );
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

   // Print Quality
   if( hb_parni( 8 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_PRINTQUALITY )
      {
         fields = fields | DM_PRINTQUALITY;
         pi2->pDevMode->dmPrintQuality = (short) hb_parni( 8 );
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

   // Print Color
   if( hb_parni( 9 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_COLOR )
      {
         fields = fields | DM_COLOR;
         pi2->pDevMode->dmColor = (short) hb_parni( 9 );
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

   // Print Duplex
   if( hb_parni( 10 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_DUPLEX )
      {
         fields = fields | DM_DUPLEX;
         pi2->pDevMode->dmDuplex = (short) hb_parni( 10 );
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

   // Print Collate
   if( hb_parni( 11 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_COLLATE )
      {
         fields = fields | DM_COLLATE;
         pi2->pDevMode->dmCollate = (short) hb_parni( 11 );
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

   // Scale
   if( hb_parni( 12 ) != -999 )
   {
      if( pi2->pDevMode->dmFields & DM_SCALE )
      {
         fields = fields | DM_SCALE;
         pi2->pDevMode->dmCollate = (short) hb_parni( 12 );
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

   ///////////////////////////////////////////////////////////////////
   // Update driver
   ///////////////////////////////////////////////////////////////////

   // Specify exactly what we are attempting to change
   pi2->pDevMode->dmFields = fields;

   // Do not attempt to set security descriptor
   pi2->pSecurityDescriptor = NULL;

   lFlag = DocumentProperties( NULL, hPrinter, (char *) hb_parc( 1 ), pi2->pDevMode, pi2->pDevMode, DM_IN_BUFFER | DM_OUT_BUFFER );

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
      SetPrinter( hPrinter, 2, (LPBYTE) pi2, 0 );
   }

   ///////////////////////////////////////////////////////////////////
   // Create a DC to handle the print job
   ///////////////////////////////////////////////////////////////////

   hdcPrint = CreateDC( NULL, TEXT( hb_parc( 1 ) ), NULL, pi2->pDevMode );

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

   hb_reta( 5 );
   HB_STORNL3( (LONG_PTR) hdcPrint, -1, 1 );
   HB_STORC( hb_parc( 1 ), -1, 2 );
   HB_STORNI( (INT) pi2->pDevMode->dmCopies, -1, 3 );
   HB_STORNI( (INT) pi2->pDevMode->dmCollate, -1, 4 );
   HB_STORNI( error, -1, 5 );

   GlobalFree( pDevMode );
   GlobalFree( pi2 );
   ClosePrinter( hPrinter );
}

HB_FUNC( _HMG_PRINTER_STARTPAGE_PREVIEW )
{
   HDC tmpDC;
   RECT emfrect;

   SetRect( &emfrect, 0, 0, GetDeviceCaps( (HDC) hb_parnl( 1 ), HORZSIZE ) * 100, GetDeviceCaps( (HDC) hb_parnl( 1 ), VERTSIZE) * 100 );

   tmpDC = CreateEnhMetaFile( (HDC) hb_parnl( 1 ), hb_parc( 2 ), &emfrect, "" );

   hb_retnl( (LONG) tmpDC );
}

HB_FUNC( _HMG_PRINTER_ENDPAGE_PREVIEW )
{
   DeleteEnhMetaFile( CloseEnhMetaFile( (HDC) hb_parnl ( 1 ) ) );
}

// _HMG_PRINTER_SHOWPAGE( cEmf, hwnd, hDC, _HMG_PRINTER_SizeFactor * 10000, Dz, Dx, Dy )
HB_FUNC( _HMG_PRINTER_SHOWPAGE )
{
   HENHMETAFILE hemf;
   HWND hWnd = HWNDparam( 2 );
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

   zw = hb_parni( 5 ) * GetDeviceCaps( (HDC) hb_parnl( 3 ), HORZSIZE ) / 1000;
   zh = hb_parni( 5 ) * GetDeviceCaps( (HDC) hb_parnl( 3 ), VERTSIZE ) / 1000;

   xOffset =( ClientWidth - ( GetDeviceCaps( (HDC) hb_parnl( 3 ), HORZSIZE )  * hb_parni( 4 ) / 10000 ) ) / 2;
   yOffset =( ClientHeight - ( GetDeviceCaps( (HDC) hb_parnl( 3 ), VERTSIZE )  * hb_parni( 4 ) / 10000 ) ) / 2;

   SetRect( &rct,
      xOffset + hb_parni( 6 ) - zw,
      yOffset + hb_parni( 7 ) - zh,
      xOffset +( GetDeviceCaps( (HDC) hb_parnl( 3 ), HORZSIZE) * hb_parni( 4 ) / 10000 ) + hb_parni( 6 ) + zw,
      yOffset +( GetDeviceCaps( (HDC) hb_parnl( 3 ), VERTSIZE) * hb_parni( 4 ) / 10000 ) + hb_parni( 7 ) + zh
      );

   FillRect( (HDC) hDC, &rct, (HBRUSH) RGB(255, 255, 255) );

   PlayEnhMetaFile( hDC, hemf, &rct );

   // Remove prints outside printable area

   // Right
   aux.top = 0;
   aux.left = rct.right;
   aux.right =  ClientWidth;
   aux.bottom = ClientHeight;
   FillRect( (HDC) hDC, &aux, (HBRUSH) GetStockObject( GRAY_BRUSH ) );

   // Bottom
   aux.top = rct.bottom;
   aux.left = 0;
   aux.right =  ClientWidth;
   aux.bottom = ClientHeight;
   FillRect( (HDC) hDC, &aux, (HBRUSH) GetStockObject( GRAY_BRUSH ) );

   // Top
   aux.top = 0;
   aux.left = 0;
   aux.right =  ClientWidth;
   aux.bottom = yOffset + hb_parni( 7 ) - zh;
   FillRect( (HDC) hDC, &aux, (HBRUSH) GetStockObject( GRAY_BRUSH ) );

   // Left
   aux.top = 0;
   aux.left = 0;
   aux.right = xOffset + hb_parni( 6 ) - zw;
   aux.bottom = ClientHeight;
   FillRect( (HDC) hDC, &aux, (HBRUSH) GetStockObject(GRAY_BRUSH ) );

   // Clean up
   DeleteEnhMetaFile( hemf );

   ReleaseDC( hWnd, hDC );
}

HB_FUNC( _HMG_PRINTER_GETPAGEWIDTH )
{
   hb_retni( GetDeviceCaps( (HDC) hb_parnl( 1 ), HORZSIZE ) );
}

HB_FUNC( _HMG_PRINTER_GETPAGEHEIGHT )
{
   hb_retni( GetDeviceCaps( (HDC) hb_parnl( 1 ), VERTSIZE ) );
}

HB_FUNC( _HMG_PRINTER_PRINTPAGE )
{
   HENHMETAFILE hemf;

   RECT rect;

   hemf = GetEnhMetaFile( hb_parc( 2 ) );

   if( hemf != NULL )
   {
      SetRect( &rect, 0, 0, GetDeviceCaps( (HDC) hb_parnl( 1 ), HORZRES ), GetDeviceCaps( (HDC) hb_parnl( 1 ), VERTRES ) );

      if( StartPage( (HDC) hb_parnl( 1 ) ) > 0 )
      {
         PlayEnhMetaFile( (HDC) hb_parnl( 1 ), hemf, &rect );

         EndPage( (HDC) hb_parnl( 1 ) );
      }

      DeleteEnhMetaFile( hemf );
   }
}

HB_FUNC( _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS )
{
   EnableScrollBar( HWNDparam( 1 ), SB_BOTH, ESB_ENABLE_BOTH );
}

HB_FUNC( _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS )
{
   EnableScrollBar( HWNDparam( 1 ), SB_BOTH, ESB_DISABLE_BOTH );
}

HB_FUNC( _HMG_PRINTER_PREVIEW_DISABLEHSCROLLBAR )
{
   EnableScrollBar( HWNDparam( 1 ), SB_HORZ, ESB_DISABLE_BOTH );
}

HB_FUNC( _HMG_PRINTER_SETVSCROLLVALUE )
{
   SendMessage( HWNDparam( 1 ), WM_VSCROLL, MAKEWPARAM( SB_THUMBPOSITION, hb_parni( 2 ) ), 0 );
}

HB_FUNC( _HMG_PRINTER_GETPRINTERWIDTH )
{
   HDC hdc = (HDC) HB_PARNL( 1 );
   hb_retnl( GetDeviceCaps( hdc, HORZSIZE ) );
}

HB_FUNC( _HMG_PRINTER_GETPRINTERHEIGHT )
{
   HDC hdc = (HDC) hb_parnl( 1 );
   hb_retnl( GetDeviceCaps( hdc, VERTSIZE ) );
}

HB_FUNC( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETX )
{
   HDC hdc = (HDC) hb_parni( 1 );
   hb_retnl( GetDeviceCaps( hdc, PHYSICALOFFSETX ) );
}

HB_FUNC( _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSX )
{
   HDC hdc = (HDC) hb_parni( 1 );
   hb_retnl( GetDeviceCaps( hdc, LOGPIXELSX ) );
}

HB_FUNC( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETY )
{
   HDC hdc = (HDC) hb_parni( 1 );
   hb_retnl( GetDeviceCaps( hdc, PHYSICALOFFSETY ) );
}

HB_FUNC( _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSY )
{
   HDC hdc = (HDC) hb_parni( 1 );
   hb_retnl( GetDeviceCaps( hdc, LOGPIXELSY ) );
}

HB_FUNC( _HMG_PRINTER_C_IMAGE )
{
   // 1: hDC
   // 2: Image File
   // 3: Row
   // 4: Col
   // 5: Height
   // 6: Width
   // 7: Stretch

   HRGN hrgn;
   HDC hdcPrint = (HDC) hb_parnl( 1 );
   IStream *iStream;
   IPicture *iPicture;
   IPicture ** iPictureRef = &iPicture;
   HGLOBAL hGlobal;
   HANDLE hFile;
   DWORD nFileSize;
   DWORD nReadByte;
   long lWidth;
   long lHeight;
   POINT lpp;
   HRSRC hSource;
   HGLOBAL hGlobalres;
   LPVOID lpVoid;
   int nSize;
   HINSTANCE hinstance = GetModuleHandle( NULL );
   HBITMAP hbmp;
   PICTDESC picd;
   int r = hb_parni( 3 );
   int c = hb_parni( 4 );
   int odr = hb_parni( 5 ); // Height
   int odc = hb_parni( 6 ); // Width
   int dr;
   int dc;

   if( hdcPrint != 0 )
   {
      c = ( c * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETX );
      r = ( r * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdcPrint, PHYSICALOFFSETY );
      dc =( odc * GetDeviceCaps( hdcPrint, LOGPIXELSX ) / 1000 );
      dr =( odr * GetDeviceCaps( hdcPrint, LOGPIXELSY ) / 1000 );

      hFile = CreateFile( hb_parc( 2 ), GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );

      if( hFile == INVALID_HANDLE_VALUE )
      {
         hbmp = (HBITMAP) LoadImage( GetModuleHandle(NULL), hb_parc( 2 ), IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION );
         // TODO: Use _OOHG_LoadImage
         if( hbmp!=NULL )
         {
            picd.cbSizeofstruct = sizeof( PICTDESC );
            picd.picType = PICTYPE_BITMAP;
            picd.bmp.hbitmap = hbmp;
            OleCreatePictureIndirect( &picd, &IID_IPicture, TRUE, (LPVOID *) iPictureRef );
         }
         else
         {
            hSource = FindResource( hinstance, hb_parc( 2 ), "GIF" );
            if( hSource == 0 )
            {
               hSource = FindResource( hinstance, hb_parc( 2 ), "JPG" );
            }
            if( hSource == 0 )
            {
               return;
            }

            hGlobalres = LoadResource( hinstance, hSource );

            if( hGlobalres == 0 )
            {
               return;
            }

            lpVoid = LockResource( hGlobalres );

            if( lpVoid == 0 )
            {
               return;
            }

            nSize = SizeofResource( hinstance, hSource );

            hGlobal = GlobalAlloc( GPTR, nSize );

            if( hGlobal == 0 )
            {
               return;
            }

            memcpy( hGlobal, lpVoid, nSize );

            FreeResource( hGlobalres );

            CreateStreamOnHGlobal( hGlobal, TRUE, &iStream );

            if( iStream == 0 )
            {
               GlobalFree( hGlobal );
               return;
            }

            OleLoadPicture( iStream, nSize, TRUE, &IID_IPicture, (LPVOID *) iPictureRef );

            iStream->lpVtbl->Release( iStream );

         }
      }
      else
      {
         nFileSize = GetFileSize( hFile, NULL );
         hGlobal = GlobalAlloc( GPTR, nFileSize );
         if( hGlobal )
         {
            ReadFile( hFile, hGlobal, nFileSize, &nReadByte, NULL );
            CreateStreamOnHGlobal( hGlobal, FALSE, &iStream );
            OleLoadPicture( iStream, nFileSize, TRUE, &IID_IPicture, (LPVOID*) iPictureRef );
            iStream->lpVtbl->Release( iStream );
            GlobalFree( hGlobal );
         }
         CloseHandle( hFile );

         if( iPicture == 0 )
         {
            return;
         }
      }

      iPicture->lpVtbl->get_Width( iPicture, &lWidth );
      iPicture->lpVtbl->get_Height( iPicture, &lHeight );

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

      hrgn = CreateRectRgn( c + lpp.x,
                            r + lpp.y,
                            c + dc + lpp.x - 1,
                            r + dr + lpp.y - 1 );

      SelectClipRgn( hdcPrint, hrgn );

      iPicture->lpVtbl->Render( iPicture,
                                hdcPrint,
                                c,
                                r,
                                dc,
                                dr,
                                0,
                                lHeight,
                                lWidth,
                                -lHeight,
                                NULL );

      SelectClipRgn( hdcPrint, NULL );

      iPicture->lpVtbl->Release( iPicture );
   }
}

HB_FUNC( _HMG_PRINTER_C_ELLIPSE )
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6: width
   // 7: R Color
   // 8: G Color
   // 9: B Color
   // 10: lWindth
   // 11: lColor
   // 12: lStyle
   // 13: nStyle
   // 14: lBrusStyle
   // 15: nBrushStyle
   // 16: lBrushColor
   // 17: nColorR
   // 18: nColorG
   // 19: nColorB

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
   int nBr;
   long nBh;
   HDC hdc = (HDC) hb_parnl( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 10 ) )
      {
         width = hb_parni( 6 );
      }
      else
      {
         width = 1 * 10000 / 254;
      }

      // Color
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

      if( hb_parl( 12 ) )
      {
         nStyle = hb_parni( 13 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      if( hb_parl( 14 ) )
      {
         nBh = hb_parni( 15 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 16 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

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

      pbr.lbStyle = nBr;
      pbr.lbColor = (COLORREF) RGB( br, bg, bb );
      pbr.lbHatch = (LONG) nBh;

      hpen = CreatePen( nStyle, width, (COLORREF) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( (HDC) hdc, hpen );
      hgdiobj2 = SelectObject( (HDC) hdc, hbr );

      Ellipse( (HDC) hdc,
               ( x * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
               ( y * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ),
               ( tox * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
               ( toy * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ) );

      SelectObject( (HDC) hdc, (HGDIOBJ) hgdiobj );
      SelectObject( (HDC) hdc, (HGDIOBJ) hgdiobj2 );

      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

HB_FUNC( _HMG_PRINTER_C_ARC )
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6-9, x1, y1, x2, y2
   // 10: width
   // 11: R Color
   // 12: G Color
   // 13: B Color
   // 14: lWindth
   // 15: lColor
   // 16: lStyle
   // 17: nStyle

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
   HDC hdc = (HDC) hb_parnl( 1 );
   HGDIOBJ hgdiobj;
   HPEN hpen;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 14 ) )
      {
         width = hb_parni( 10 );
      }

      // Color
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

      if( hb_parl( 16 ) )
      {
         nStyle = hb_parni( 17 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      hpen = CreatePen( nStyle, width, (COLORREF) RGB( r, g, b ) );
      hgdiobj = SelectObject( (HDC) hdc, hpen );

      Arc( (HDC) hdc,
           ( x * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
           ( y * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ),
           ( tox * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
           ( toy * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ),
           ( x1 * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
           ( y1 * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ),
           ( x2 * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
           ( y2 * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ) );

      SelectObject( (HDC) hdc, (HGDIOBJ) hgdiobj );
      DeleteObject( hpen );
   }
}

HB_FUNC( _HMG_PRINTER_C_PIE )
{
   // 1: hDC
   // 2: y
   // 3: x
   // 4: toy
   // 5: tox
   // 6-9, x1, y1, x2, y2
   // 10: width
   // 11: R Color
   // 12: G Color
   // 13: B Color
   // 14: lWindth
   // 15: lColor
   // 16: lStyle
   // 17: nStyle
   // 18: lBrusStyle
   // 19: nBrushStyle
   // 20: lBrushColor
   // 21: nColorR
   // 22: nColorG
   // 23: nColorB

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
   int nBr;
   long nBh;
   HDC hdc = (HDC) hb_parnl( 1 );
   HGDIOBJ hgdiobj, hgdiobj2;
   HPEN hpen;
   LOGBRUSH pbr;
   HBRUSH hbr;

   if( hdc != 0 )
   {
      // Width
      if( hb_parl( 14 ) )
      {
         width = hb_parni( 10 );
      }

      // Color
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

      if( hb_parl( 16 ) )
      {
         nStyle = hb_parni( 17 );
      }
      else
      {
         nStyle = (int) PS_SOLID;
      }

      if( hb_parl( 18 ) )
      {
         nBh = hb_parni( 19 );
         nBr = 2;
      }
      else
      {
         if( hb_parl( 20 ) )
         {
            nBr = 0;
         }
         else
         {
            nBr = 1;
         }
         nBh = 0 ;
      }

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

      pbr.lbStyle = nBr;
      pbr.lbColor = (COLORREF) RGB( br, bg, bb );
      pbr.lbHatch = (LONG) nBh;

      hpen = CreatePen( nStyle, width, (COLORREF) RGB( r, g, b ) );
      hbr = CreateBrushIndirect( &pbr );
      hgdiobj = SelectObject( (HDC) hdc, hpen );
      hgdiobj2 = SelectObject( (HDC) hdc, hbr );

      Pie( (HDC) hdc,
           ( x * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
           ( y * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ),
           ( tox * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
           ( toy * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ),
           ( x1 * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
           ( y1 * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ),
           ( x2 * GetDeviceCaps( hdc, LOGPIXELSX ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETX ),
           ( y2 * GetDeviceCaps( hdc, LOGPIXELSY ) / 1000 ) - GetDeviceCaps( hdc, PHYSICALOFFSETY ) );

      SelectObject( (HDC) hdc, (HGDIOBJ) hgdiobj );
      SelectObject( (HDC) hdc, (HGDIOBJ) hgdiobj2 );

      DeleteObject( hpen );
      DeleteObject( hbr );
   }
}

//----------------------------------------------------------------------------//
HB_FUNC( _HMG_PRINTER_GETMAXCOL )       // hdcPrint, FontName, FontSize, nWidth, nAngle, lBold, lItalic, lUnderLine, lStrikeOut
{
   HDC hdcPrint;
   char FontName [32];
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

   hdcPrint = (HDC) hb_parnl( 1 );

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
                       DEFAULT_CHARSET,
                       OUT_TT_PRECIS,
                       CLIP_DEFAULT_PRECIS,
                       DEFAULT_QUALITY,
                       FF_DONTCARE,
                       (LPCTSTR) FontName );

   hgdiobj = SelectObject( hdcPrint, hfont );

   GetTextMetrics( hdcPrint, &tm );

   hb_retni( (int) ( GetDeviceCaps( hdcPrint, HORZRES ) / tm.tmAveCharWidth - 1 ) );

   SelectObject( hdcPrint, hgdiobj );

   DeleteObject( hfont );
}

//----------------------------------------------------------------------------//
HB_FUNC( _HMG_PRINTER_GETMAXROW )       // hdcPrint, FontName, FontSize, nWidth, nAngle, lBold, lItalic, lUnderLine, lStrikeOut
{
   HDC hdcPrint;
   char FontName [32];
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

   hdcPrint = (HDC) hb_parnl( 1 );

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
                       DEFAULT_CHARSET,
                       OUT_TT_PRECIS,
                       CLIP_DEFAULT_PRECIS,
                       DEFAULT_QUALITY,
                       FF_DONTCARE,
                       (LPCTSTR) FontName );

   hgdiobj = SelectObject( hdcPrint, hfont );

   GetTextMetrics( hdcPrint, &tm );

   hb_retni( (int) ( ( GetDeviceCaps( (HDC) hb_parnl( 1 ), VERTRES ) - tm.tmAscent ) / tm.tmHeight - 1 ) );

   SelectObject( hdcPrint, hgdiobj );

   DeleteObject( hfont );
}

#pragma ENDDUMP
