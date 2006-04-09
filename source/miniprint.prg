/*
 * $Id: miniprint.prg,v 1.14 2006-04-09 14:58:19 declan2005 Exp $
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-05 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

	"Harbour GUI framework for Win32"
 	Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
 	Copyright 2001 Antonio Linares <alinares@fivetech.com>
	www - http://www.harbour-project.org

	"Harbour Project"
	Copyright 1999-2003, http://www.harbour-project.org/

 Parts of this module are based upon:

	"HBPRINT"
	Copyright 2002 Richard Rylko <rrylko@poczta.onet.pl>
	http://rrylko.republika.pl

	"HBPRINTER"
	Copyright 2002 Richard Rylko <rrylko@poczta.onet.pl>
	http://rrylko.republika.pl

---------------------------------------------------------------------------*/

//////////////////////////////////////////////////////////////////////////////////
// HARBOUR LEVEL PRINT ROUTINES
///////////////////////////////////////////////////////////////////////////////

#include "oohg.ch"
#include "miniprint.ch"

#define WM_CLOSE	0x0010
#define SB_HORZ		0
#define SB_VERT		1

#define WM_VSCROLL	0x0115

DECLARE WINDOW _HMG_PRINTER_PPNAV

memvar _HMG_printer_timestamp
memvar _HMG_printer_hdc_bak
memvar _HMG_printer_pagecount
memvar _HMG_printer_copies
memvar _HMG_printer_collate
memvar _HMG_printer_hdc
memvar a
memvar _HMG_printer_BasePageName
memvar _HMG_printer_CurrentPageNumber
memvar _HMG_printer_SizeFactor
memvar _HMG_printer_Dx
memvar _HMG_printer_Dy
memvar _HMG_printer_Dz
memvar _HMG_printer_scrollstep
memvar _HMG_printer_zoomclick_xoffset
memvar _HMG_printer_thumbupdate
memvar _HMG_printer_thumbscroll
memvar _HMG_printer_PrevPageNumber
memvar _HMG_printer_usermessages
memvar _OOHG_printer_docname

*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_SHOWPREVIEW
*------------------------------------------------------------------------------*
Local ModalHandle := 0
Local Tmp
Local tWidth
Local tHeight
Local tFactor
Local tvHeight
Local icb := 0
Public _HMG_printer_BasePageName := GetTempFolder() + "\" + _HMG_printer_timestamp + "_HMG_print_preview_"
Public _HMG_printer_CurrentPageNumber := 1
Public _HMG_printer_SizeFactor
Public _HMG_printer_Dx := 0
Public _HMG_printer_Dy := 0
Public _HMG_printer_Dz := 0
Public _HMG_printer_scrollstep := 10
Public _HMG_printer_zoomclick_xoffset := 0
Public _HMG_printer_thumbupdate := .T.
Public _HMG_printer_thumbscroll
Public _HMG_printer_PrevPageNumber := 0
if type ( "_OOHG_printer_docname") # 'C'
   PUblic _OOHG_printer_docname:="OOHG printing"
endif


        if _HMG_printer_hdc_bak == 0
		Return
	EndIf

        if _IsWindowDefined ( "_HMG_PRINTER_SHOWPREVIEW" )
		Return
	endif

        icb := setinteractiveclose()

	set interactiveclose on

        _HMG_printer_SizeFactor := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) * 0.63

        define window _HMG_PRINTER_Wait at 0,0 width 310 height 85 title '' child noshow nocaption
		define label label_1
			row 30
			col 5
			width 300
			height 30
                        value _HMG_printer_usermessages [29]
			centeralign .t.
		end label
	end window

        _HMG_PRINTER_Wait.Center

        DEFINE WINDOW _HMG_PRINTER_SHOWPREVIEW ;
			AT 0,0 ;
			WIDTH GetDesktopWidth() - 103 ;
			HEIGHT GetDesktopHeight() - 103  ;
			VIRTUAL WIDTH ( GetDesktopWidth() - 103 ) * 2 ;
			VIRTUAL HEIGHT ( GetDesktopHeight() - 103 ) * 2 ;
                        TITLE _HMG_printer_usermessages [01] + ' [' + alltrim(str(_HMG_printer_CurrentPageNumber)) + '/'+alltrim(str(_HMG_printer_PageCount)) + ']';
			CHILD ;
			NOSIZE ;
			NOMINIMIZE ;
			NOMAXIMIZE ;
			NOSYSMENU ;
			CURSOR "HP_GLASS" ;
                        ON PAINT _HMG_PRINTER_PreviewRefresh() ;
			BACKCOLOR GRAY ;
                        ON MOUSECLICK   ( If ( _HMG_PRINTER_PPNAV.b5.value == .T. , _HMG_PRINTER_PPNAV.b5.value := .F. , _HMG_PRINTER_PPNAV.b5.value := .T. ) , _HMG_PRINTER_MouseZoom() ) ;
                        ON SCROLLUP     _HMG_PRINTER_ScrolluP() ;
                        ON SCROLLDOWN   _HMG_PRINTER_ScrollDown() ;
                        ON SCROLLLEFT   _HMG_PRINTER_ScrollLeft() ;
                        ON SCROLLRIGHT  _HMG_PRINTER_ScrollRight() ;
                        ON HSCROLLBOX   _HMG_PRINTER_hScrollBoxProcess() ;
                        ON VSCROLLBOX   _HMG_PRINTER_vScrollBoxProcess()

                        ON KEY HOME             ACTION ( _HMG_printer_CurrentPageNumber:=1 , _HMG_PRINTER_PreviewRefresh()  )
                        ON KEY PRIOR            ACTION ( _HMG_printer_CurrentPageNumber-- , _HMG_PRINTER_PreviewRefresh()  )
                        ON KEY NEXT             ACTION ( _HMG_printer_CurrentPageNumber++ , _HMG_PRINTER_PreviewRefresh()  )
                        ON KEY END              ACTION ( _HMG_printer_CurrentPageNumber:= _HMG_printer_PageCount, _HMG_PRINTER_PreviewRefresh() )
                        ON KEY CONTROL+P        ACTION _HMG_PRINTER_PrintPages()
                        ON KEY CONTROL+G        ACTION _HMG_PRINTER_GO_TO_PAGE()
                        ON KEY ESCAPE           ACTION _HMG_PRINTER_PreviewClose()
                        ON KEY MULTIPLY         ACTION ( If ( _HMG_PRINTER_PPNAV.b5.value == .T. , _HMG_PRINTER_PPNAV.b5.value := .F. , _HMG_PRINTER_PPNAV.b5.value := .T. ) , _HMG_PRINTER_Zoom() )
                        ON KEY CONTROL+C        ACTION _HMG_PRINTER_PreviewClose()
                        ON KEY ALT+F4           ACTION _HMG_PRINTER_PreviewClose()
                        ON KEY CONTROL+S        ACTION _HMG_printer_savepages()
                        ON KEY CONTROL+T        ACTION _HMG_printer_ThumbnailToggle()

	END WINDOW

        Define Window _HMG_PRINTER_PRINTPAGES           ;
		At 0,0					;
		Width 420				;
		Height 168 + GetTitleHeight()		;
                Title _HMG_printer_usermessages [9]     ;
		CHILD NOSHOW 				;
		NOSIZE NOSYSMENU

                ON KEY ESCAPE   ACTION ( HideWindow ( GetFormHandle ( "_HMG_PRINTER_PRINTPAGES" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) ) , _HMG_PRINTER_SHOWPREVIEW.setfocus )
                ON KEY RETURN   ACTION _HMG_PRINTER_PrintPagesDo()

		Define Frame Frame_1
			Row 5
			Col 10
			Width 275
			Height 147
			FontName 'Arial'
			FontSize 9
                        Caption _HMG_printer_usermessages [15]
		End Frame

		Define RadioGroup Radio_1
			Row 25
			Col 20
			FontName 'Arial'
			FontSize 9
			Value 1
                        Options { _HMG_printer_usermessages [16] , _HMG_printer_usermessages [17] }
                        OnChange if ( This.value == 1 , ( _HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .F. , _HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .F. , _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F. , _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F. , _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F.  , _HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .F. ) , ( _HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .T.  , _HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .T. , _HMG_PRINTER_PRINTPAGES.Spinner_1.SetFocus ) )
		End RadioGroup

		Define Label Label_1
			Row 84
			Col 55
			Width 50
			Height 25
			FontName 'Arial'
			FontSize 9
                        Value _HMG_printer_usermessages [18] + ':'
		End Label

		Define Spinner Spinner_1
			Row 81
			Col 110
			Width 50
			FontName 'Arial'
			FontSize 9
			Value 1
			RangeMin 1
                        RangeMax _HMG_printer_PageCount
		End Spinner

		Define Label Label_2
			Row 84
			Col 165
			Width 35
			Height 25
			FontName 'Arial'
			FontSize 9
                        Value _HMG_printer_usermessages [19] + ':'
		End Label

		Define Spinner Spinner_2
			Row 81
			Col 205
			Width 50
			FontName 'Arial'
			FontSize 9
                        Value _HMG_printer_PageCount
			RangeMin 1
                        RangeMax _HMG_printer_PageCount
		End Spinner

		Define Label Label_4
			Row 115
			Col 55
			Width 50
			Height 25
			FontName 'Arial'
			FontSize 9
                        Value _HMG_printer_usermessages [09] + ':'
		End Label

		Define ComboBox Combo_1
			Row 113
			Col 110
			Width 145
			FontName 'Arial'
			FontSize 9
			Value 1
                        Items {_HMG_printer_usermessages [21] , _HMG_printer_usermessages [22] , _HMG_printer_usermessages [23] }
		End ComboBox

		Define Button Ok
			Row 10
			Col 300
			Width 105
			Height 25
			FontName 'Arial'
			FontSize 9
                        Caption _HMG_printer_usermessages [11]
                        Action _HMG_PRINTER_PrintPagesDo()
		End Button

		Define Button Cancel
			Row 40
			Col 300
			Width 105
			Height 25
			FontName 'Arial'
			FontSize 9
                        Caption _HMG_printer_usermessages [12]
                        Action ( EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) ) , HideWindow ( GetFormHandle ( "_HMG_PRINTER_PRINTPAGES" ) ) , _HMG_PRINTER_SHOWPREVIEW.setfocus )
		End Button

		Define Label Label_3
			Row 103
			Col 300
			Width 45
			Height 25
			FontName 'Arial'
			FontSize 9
                        Value _HMG_printer_usermessages [20] + ':'
		End Label

		Define Spinner Spinner_3
			Row 100
			Col 355
			Width 50
			FontName 'Arial'
			FontSize 9
                        Value _HMG_printer_copies
			RangeMin 1
			RangeMax 999
                        OnChange ( if ( _IsControlDefined ("CheckBox_1","_HMG_PRINTER_PRINTPAGES") , If ( This.Value > 1 , SetProperty( '_HMG_PRINTER_PRINTPAGES' , 'CheckBox_1','Enabled',.T.) , SetProperty( '_HMG_PRINTER_PRINTPAGES','CheckBox_1','Enabled', .F. ) ) , Nil ) )
		End Spinner

		Define CheckBox CheckBox_1
			Row 132
                        Col 300
			Width 110
			FontName 'Arial'
			FontSize 9
                        Value if ( _HMG_printer_collate == 1 , .T. , .F. )
                        Caption _HMG_printer_usermessages [14]
		End CheckBox

	End Window

        Center Window _HMG_PRINTER_PRINTPAGES

        Define Window _HMG_PRINTER_GO_TO_PAGE           ;
		At 0,0					;
		Width 195				;
		Height 90 + GetTitleHeight()		;
                Title _HMG_printer_usermessages [07]    ;
		CHILD NOSHOW				;
		NOSIZE NOSYSMENU

                ON KEY ESCAPE   ACTION ( HideWindow( GetFormHandle ( "_HMG_PRINTER_GO_TO_PAGE" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )  , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) ) , _HMG_PRINTER_SHOWPREVIEW.setfocus  )
                ON KEY RETURN   ACTION ( _HMG_printer_CurrentPageNumber := _HMG_PRINTER_GO_TO_PAGE.Spinner_1.Value , HideWindow( GetFormHandle ( "_HMG_PRINTER_GO_TO_PAGE" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )  , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) ) , _HMG_PRINTER_SHOWPREVIEW.setfocus  )

		Define Label Label_1
			Row 13
			Col 10
			Width 94
			Height 25
			FontName 'Arial'
			FontSize 9
                        Value _HMG_printer_usermessages [10] + ':'
		End Label

		Define Spinner Spinner_1
			Row 10
			Col 105
			Width 75
			FontName 'Arial'
			FontSize 9
                        Value _HMG_printer_CurrentPageNumber
			RangeMin 1
                        RangeMax _HMG_printer_PageCount
		End Spinner

		Define Button Ok
			Row 48
			Col 10
			Width 80
			Height 25
			FontName 'Arial'
			FontSize 9
                        Caption _HMG_printer_usermessages [11]
                        Action ( _HMG_printer_CurrentPageNumber := _HMG_PRINTER_GO_TO_PAGE.Spinner_1.Value , HideWindow( GetFormHandle ( "_HMG_PRINTER_GO_TO_PAGE" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) ) , _HMG_PRINTER_SHOWPREVIEW.setfocus  )
		End Button

		Define Button Cancel
			Row 48
			Col 100
			Width 80
			Height 25
			FontName 'Arial'
			FontSize 9
                        Caption _HMG_printer_usermessages [12]
                        Action ( HideWindow( GetFormHandle ( "_HMG_PRINTER_GO_TO_PAGE" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )  , EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) ) , EnableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) ) , _HMG_PRINTER_SHOWPREVIEW.setfocus  )
		End Button

	End Window

        Center Window _HMG_PRINTER_GO_TO_PAGE

        if _HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) > _HMG_PRINTER_GETPAGEWIDTH(_HMG_printer_hdc_bak)
		tFactor := 0.44
	else
		tFactor := 0.26
	endif

        tWidth  :=_HMG_PRINTER_GETPAGEWIDTH(_HMG_printer_hdc_bak) * tFactor
        tHeight :=_HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) * tFactor

	tHeight := Int (tHeight)

        tvHeight := ( _HMG_printer_PageCount * (tHeight + 10) ) + GetHScrollbarHeight() + GetTitleHeight() + ( GetBorderHeight() * 2 ) + 7

	if tvHeight <= GetDesktopHeight() - 103
                _HMG_printer_thumbscroll := .f.
		tvHeight := GetDesktopHeight() - 102
	else
                _HMG_printer_thumbscroll := .t.
	EndIf

        DEFINE WINDOW _HMG_PRINTER_SHOWTHUMBNAILS ;
		AT 0,5 ;
		WIDTH 130 ;
		HEIGHT GetDesktopHeight() - 103  ;
		VIRTUAL WIDTH 131 ;
		VIRTUAL HEIGHT tvHeight ;
                TITLE _HMG_printer_usermessages [28] ;
		CHILD ;
		NOSIZE ;
		NOMINIMIZE ;
		NOMAXIMIZE ;
		NOSYSMENU ;
		NOSHOW ;
		BACKCOLOR GRAY

                ON KEY HOME             ACTION ( _HMG_printer_CurrentPageNumber:=1 , _HMG_PRINTER_PreviewRefresh()  )
                ON KEY PRIOR            ACTION ( _HMG_printer_CurrentPageNumber-- , _HMG_PRINTER_PreviewRefresh()  )
                ON KEY NEXT             ACTION ( _HMG_printer_CurrentPageNumber++ , _HMG_PRINTER_PreviewRefresh()  )
                ON KEY END              ACTION ( _HMG_printer_CurrentPageNumber:= _HMG_printer_PageCount, _HMG_PRINTER_PreviewRefresh() )
                ON KEY CONTROL+P        ACTION _HMG_PRINTER_PrintPages()
                ON KEY CONTROL+G        ACTION _HMG_PRINTER_GO_TO_PAGE()
                ON KEY ESCAPE           ACTION _HMG_PRINTER_PreviewClose()
                ON KEY MULTIPLY         ACTION ( If ( _HMG_PRINTER_PPNAV.b5.value == .T. , _HMG_PRINTER_PPNAV.b5.value := .F. , _HMG_PRINTER_PPNAV.b5.value := .T. ) , _HMG_PRINTER_Zoom() )
                ON KEY CONTROL+C        ACTION _HMG_PRINTER_PreviewClose()
                ON KEY ALT+F4           ACTION _HMG_PRINTER_PreviewClose()
                ON KEY CONTROL+S        ACTION _HMG_printer_savepages()
                ON KEY CONTROL+T        ACTION _HMG_printer_ThumbnailToggle()

	END WINDOW

        if _HMG_printer_thumbscroll == .f.
                _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('_HMG_PRINTER_SHOWTHUMBNAILS'))
	endif

        DEFINE WINDOW _HMG_PRINTER_PPNAV ;
			AT 1, GetDesktopWidth() - 320 ;
			WIDTH 312 + GetBorderWidth() ;
			HEIGHT 35 + GetTitleHeight() + GetBorderHeight() ;
                        TITLE _HMG_printer_usermessages [02] ;
			CHILD  ;
			NOMAXIMIZE ;
			NOMINIMIZE ;
			NOSIZE ;
			NOSYSMENU

			DEFINE BUTTON b1
				ROW 2
				COL 2
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_TOP"
                                TOOLTIP _HMG_printer_usermessages [03]
                                ACTION ( _HMG_printer_CurrentPageNumber:=1 , _HMG_PRINTER_PreviewRefresh()  )
			END BUTTON

			DEFINE BUTTON b2
				ROW 2
				COL 32
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_BACK"
                                TOOLTIP _HMG_printer_usermessages [04]
                                ACTION ( _HMG_printer_CurrentPageNumber-- , _HMG_PRINTER_PreviewRefresh()  )
			END BUTTON

			DEFINE BUTTON b3
				ROW 2
				COL 62
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_NEXT"
                                TOOLTIP _HMG_printer_usermessages [05]
                                ACTION ( _HMG_printer_CurrentPageNumber++ , _HMG_PRINTER_PreviewRefresh()  )
			END BUTTON

			DEFINE BUTTON b4
				ROW 2
				COL 92
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_END"
                                TOOLTIP _HMG_printer_usermessages [06]
                                ACTION ( _HMG_printer_CurrentPageNumber:= _HMG_printer_PageCount, _HMG_PRINTER_PreviewRefresh()  )
			END BUTTON

			DEFINE CHECKBUTTON thumbswitch
				ROW 2
				COL 126
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_THUMBNAIL"
                                TOOLTIP _HMG_printer_usermessages [28] + ' [Ctrl+T]'
                                OnChange _HMG_PRINTER_ProcessTHUMBNAILS()
			END CHECKBUTTON

			DEFINE BUTTON GoToPage
				ROW 2
				COL 156
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_GOPAGE"
                                TOOLTIP _HMG_printer_usermessages [07] + ' [Ctrl+G]'
                                ACTION _HMG_PRINTER_GO_TO_PAGE()
			END BUTTON

			DEFINE CHECKBUTTON b5
				ROW 2
				COL 186
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_ZOOM"
                                TOOLTIP _HMG_printer_usermessages [08] + ' [*]'
                                ON CHANGE _HMG_PRINTER_Zoom()
			END CHECKBUTTON

			DEFINE BUTTON b12
				ROW 2
				COL 216
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_PRINT"
                                TOOLTIP _HMG_printer_usermessages [09] + ' [Ctrl+P]'
                                ACTION _HMG_PRINTER_PrintPages()
			END BUTTON

			DEFINE BUTTON b7
				ROW 2
				COL 246
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_SAVE"
                                TOOLTIP _HMG_printer_usermessages [27] + ' [Ctrl+S]'
                                ACTION _HMG_printer_savepages()
			END BUTTON

			DEFINE BUTTON b6
				ROW 2
				COL 280
				WIDTH 30
				HEIGHT 30
				PICTURE "HP_CLOSE"
                                TOOLTIP _HMG_printer_usermessages [26] + ' [Ctrl+C]'
                                ACTION _HMG_PRINTER_PreviewClose()
			END BUTTON

                        ON KEY HOME             ACTION ( _HMG_printer_CurrentPageNumber:=1 , _HMG_PRINTER_PreviewRefresh()  )
                        ON KEY PRIOR            ACTION ( _HMG_printer_CurrentPageNumber-- , _HMG_PRINTER_PreviewRefresh()  )
                        ON KEY NEXT             ACTION ( _HMG_printer_CurrentPageNumber++ , _HMG_PRINTER_PreviewRefresh()  )
                        ON KEY END              ACTION ( _HMG_printer_CurrentPageNumber:= _HMG_printer_PageCount, _HMG_PRINTER_PreviewRefresh()  )
                        ON KEY CONTROL+P        ACTION _HMG_PRINTER_Printpages()
                        ON KEY CONTROL+G        ACTION _HMG_PRINTER_GO_TO_PAGE()
                        ON KEY ESCAPE           ACTION _HMG_PRINTER_PreviewClose()
                        ON KEY MULTIPLY         ACTION ( If ( _HMG_PRINTER_PPNAV.b5.value == .T. , _HMG_PRINTER_PPNAV.b5.value := .F. , _HMG_PRINTER_PPNAV.b5.value := .T. ) , _HMG_PRINTER_Zoom() )
                        ON KEY CONTROL+C        ACTION _HMG_PRINTER_PreviewClose()
                        ON KEY ALT+F4           ACTION _HMG_PRINTER_PreviewClose()
                        ON KEY CONTROL+S        ACTION _HMG_printer_savepages()
                        ON KEY CONTROL+T        ACTION _HMG_printer_ThumbnailToggle()

	END WINDOW

        SetScrollRange ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 0 , 100 , 1 )
        SetScrollRange ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 0 , 100 , 1 )

        SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 50 , 1 )
        SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 50 , 1 )

        _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'))

        _HMG_PRINTER_PREVIEW_DISABLEHSCROLLBAR (GetFormHandle('_HMG_PRINTER_SHOWTHUMBNAILS'))

        CENTER WINDOW _HMG_PRINTER_SHOWPREVIEW

        Tmp := _HMG_PRINTER_SHOWPREVIEW.ROW

	Tmp := Tmp + GetTitleHeight() - 10

        _HMG_PRINTER_SHOWPREVIEW.ROW := Tmp

        _HMG_PRINTER_SHOWTHUMBNAILS.ROW := Tmp

        ACTIVATE WINDOW _HMG_PRINTER_PRINTPAGES , _HMG_PRINTER_GO_TO_PAGE , _HMG_PRINTER_SHOWTHUMBNAILS , _HMG_PRINTER_SHOWPREVIEW , _HMG_PRINTER_Wait , _HMG_PRINTER_PPNAV

        _HMG_printer_hdc := _HMG_printer_hdc_bak

      //  If ModalHandle != 0
       //
      //          For i := 1 To Len ( _HMG_aFormHandles )
      //                  If _HMG_aFormDeleted [i] == .F.
      ///                          If _HMG_aFormType [i] != 'X'
     //                                   If _HMG_aFormHandles [i] != ModalHandle
     //                                           DisableWindow (_HMG_aFormHandles [i] )
     //                                   EndIf
     //                           EndIf
     //                   EndIf
     //           Next i

     //           EnableWIndow ( ModalHandle )
     //           SetFocus ( ModalHandle )
     //   Endif

        setinteractiveclose(icb)

Return
*---a---------------------------------------------------------------------------*
Procedure CreateThumbNails
*------------------------------------------------------------------------------*
Local tFactor
Local tWidth
Local tHeight
Local ttHandle
Local i
Local cMacroTemp
Local cAction

        If _IsControlDefined ( 'Image1' , '_HMG_PRINTER_SHOWTHUMBNAILS' )
		Return
	EndIf

        ShowWindow ( GetFormHandle ( "_HMG_PRINTER_Wait" ) )

        if _HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) > _HMG_PRINTER_GETPAGEWIDTH(_HMG_printer_hdc_bak)
		tFactor := 0.44
	else
		tFactor := 0.26
	endif

        tWidth  :=_HMG_PRINTER_GETPAGEWIDTH(_HMG_printer_hdc_bak) * tFactor
        tHeight :=_HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) * tFactor

	tHeight := Int (tHeight)

        ttHandle := GetFormToolTipHandle ('_HMG_PRINTER_SHOWTHUMBNAILS')

        For i := 1 To _HMG_printer_PageCount

		cMacroTemp := 'Image' + alltrim(str(i))

                cAction := "( _HMG_printer_CurrentPageNumber:="+ alltrim(str(i)) +", _HMG_PRINTER_THUMBUPDATE := .F. , _HMG_PRINTER_PreviewRefresh() , _HMG_PRINTER_THUMBUPDATE := .T. )"

                   TImage():Define( cMacroTemp, '_HMG_PRINTER_SHOWTHUMBNAILS', 10, ;
                    ( i * (tHeight + 10) ) - tHeight, ;
                    _HMG_printer_BasePageName + strzero(i,4) + ".emf",;
                    tWidth, tHeight, { || &cAction }, Nil, ;
                   .F., .F., .T., .F. )

                SetToolTip ( GetControlHandle ( cMacroTemp ,'_HMG_PRINTER_SHOWTHUMBNAILS'), _HMG_printer_usermessages [01] + ' ' + AllTrim(Str(i)) + ' [Click]' , ttHandle )

	Next i

        HideWindow ( GetFormHandle ( "_HMG_PRINTER_Wait" ) )

Return
*------------------------------------------------------------------------------*
Function _HMG_printer_ThumbnailToggle()
*------------------------------------------------------------------------------*

        if _HMG_PRINTER_PPNAV.thumbswitch.Value == .t.

                _HMG_PRINTER_PPNAV.thumbswitch.Value := .f.

	Else

                _HMG_PRINTER_PPNAV.thumbswitch.Value := .t.

	EndIf

        _HMG_PRINTER_ProcessTHUMBNAILS()

Return .F.
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_ProcessTHUMBNAILS()
*------------------------------------------------------------------------------*

        If _HMG_PRINTER_PPNAV.thumbswitch.Value == .T.

		CreateThumbNails()

                _HMG_printer_zoomclick_xoffset := 90

                _HMG_printer_SizeFactor := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) * 0.58

                _HMG_PRINTER_SHOWPREVIEW.Width := GetDesktopWidth() - 148

                _HMG_PRINTER_SHOWPREVIEW.Col := 138

                ShowWindow ( GetFormHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )

	else

                _HMG_printer_zoomclick_xoffset := 0

                _HMG_printer_SizeFactor := GetDesktopHeight() / _HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) * 0.63

                _HMG_PRINTER_SHOWPREVIEW.Width := GetDesktopWidth() - 103
                _HMG_PRINTER_SHOWPREVIEW.Col := 51

                HideWindow ( GetFormHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )

                _HMG_PRINTER_PPNAV.SetFocus

	EndIf

Return
*------------------------------------------------------------------------------*
Procedure _HMG_printer_savepages
*------------------------------------------------------------------------------*
Local c , i , f , t , d , x

	x := GetFolder()

	if empty(x)
		return
	endif

	If right(x,1) != '\'
		x := x + '\'
	endif

	t := GetTempFolder()

        c := adir ( t + "\" + _HMG_printer_timestamp  + "_HMG_print_preview_*.Emf")

	declare a[c]

        adir ( t + "\" + _HMG_printer_timestamp  + "_HMG_print_preview_*.Emf" , a )

	For i := 1 To c
		f := t + "\" + a [i]
		d := x + 'Harbour_MiniPrint_' + StrZero ( i , 4 ) + '.Emf'
		COPY FILE (F) TO (D)
	Next i

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_GO_TO_PAGE
*------------------------------------------------------------------------------*

        DIsableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) )

        DIsableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )

        DIsableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )

        ShowWindow ( GetFormHandle ( "_HMG_PRINTER_GO_TO_PAGE" ) )

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_hScrollBoxProcess()
*------------------------------------------------------------------------------*
Local Sp

        Sp := GetScrollPos (  GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ )

        _HMG_printer_Dx := - ( Sp - 50 ) * 10

        _HMG_PRINTER_PreviewRefresh()

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_vScrollBoxProcess()
*------------------------------------------------------------------------------*
Local Sp

        Sp := GetScrollPos (  GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT )

        _HMG_printer_Dy := - ( Sp - 50 ) * 10

        _HMG_PRINTER_PreviewRefresh()

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_PreviewClose()
*------------------------------------------------------------------------------*

        _HMG_PRINTER_CleanPreview()



        

 
        _HMG_PRINTER_PPNAV.Release
        _HMG_PRINTER_WAIT.Release
        _HMG_PRINTER_SHOWPREVIEW.Release
        if iswindowdefined("_HMG_PRINTER_SHOWTHUMBNAILS")
          _HMG_PRINTER_SHOWTHUMBNAILS.Release
        endif
        if iswindowdefined("_HMG_PRINTER_GO_TO_PAGE")
           _HMG_PRINTER_GO_TO_PAGE.Release
        endif
        if iswindowdefined("_HMG_PRINTER_PRINTPAGES")
           _HMG_PRINTER_PRINTPAGES.Release
        endif

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_CleanPreview
*------------------------------------------------------------------------------*

        AEval( Directory( GetTempFolder() + "\" + _HMG_printer_timestamp + "_HMG_print_preview_*.Emf" ), ;
		{ |file| Ferase( GetTempFolder() + "\" + file[1] ) } )

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_PreviewRefresh
*------------------------------------------------------------------------------*
Local hwnd
Local nRow
Local nScrollMax

        if ! __MVEXIST ( '_HMG_printer_CurrentPageNumber' )
                __MVPUBLIC( '_HMG_printer_CurrentPageNumber' )
                __MVPUT( '_HMG_printer_CurrentPageNumber' , 1 )
	endif


        If _IsControlDefined ( 'Image' + AllTrim(Str(_HMG_printer_CurrentPageNumber)) , '_HMG_PRINTER_SHOWTHUMBNAILS' ) .and. _HMG_PRINTER_THUMBUPDATE == .T. .and. _HMG_printer_thumbscroll == .T.

                if _HMG_printer_PrevPageNumber != _HMG_printer_CurrentPageNumber
                        _HMG_printer_PrevPageNumber := _HMG_printer_CurrentPageNumber


                hwnd := GetFormHandle('_HMG_PRINTER_SHOWTHUMBNAILS')
                nRow := GetProperty ( '_HMG_PRINTER_SHOWTHUMBNAILS' , 'Image' + AllTrim(Str(_HMG_printer_CurrentPageNumber)) , 'Row' )
		nScrollMax := GetScrollRangeMax ( hwnd , SB_VERT )

                if _HMG_printer_PageCount == _HMG_printer_CurrentPageNumber

			if GetScrollPos(hwnd,SB_VERT) != nScrollMax
                                _HMG_PRINTER_SETVSCROLLVALUE ( hwnd , nScrollMax )
			EndIf

                ElseIf _HMG_printer_CurrentPageNumber == 1

			if GetScrollPos(hwnd,SB_VERT) != 0
                                _HMG_PRINTER_SETVSCROLLVALUE ( hwnd , 0 )
			EndIf

		Else

			if ( nRow - 9 ) < nScrollMax
                                _HMG_PRINTER_SETVSCROLLVALUE ( hwnd , nRow - 9 )
			Else
				if GetScrollPos(hwnd,SB_VERT) != nScrollMax
                                        _HMG_PRINTER_SETVSCROLLVALUE ( hwnd , nScrollMax )
				EndIf
			EndIf

		EndIf

		EndIf

	EndIf

        if _HMG_printer_CurrentPageNumber < 1
                _HMG_printer_CurrentPageNumber := 1
		PlayBeep()
		Return
	EndIf

        if _HMG_printer_CurrentPageNumber > _HMG_printer_PageCount
                _HMG_printer_CurrentPageNumber := _HMG_printer_PageCount
		PlayBeep()
		Return
	EndIf

        _HMG_PRINTER_SHOWPAGE ( _HMG_printer_BasePageName + strzero(_HMG_printer_CurrentPageNumber,4) + ".emf" , GetFormhandle ('_HMG_PRINTER_SHOWPREVIEW') , _HMG_printer_hdc_bak , _HMG_printer_SizeFactor * 10000 , _HMG_printer_Dz , _HMG_printer_Dx , _HMG_printer_Dy )

        _HMG_PRINTER_SHOWPREVIEW.TITLE := _HMG_printer_usermessages [01] + ' [' + alltrim(str(_HMG_printer_CurrentPageNumber)) + '/'+alltrim(str(_HMG_printer_PageCount)) + ']'

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_PrintPages
*------------------------------------------------------------------------------*
Local aProp := {}

        DIsableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) )
        DIsableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
        DIsableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )

        _HMG_PRINTER_PRINTPAGES.Radio_1.Value := 1

        _HMG_PRINTER_PRINTPAGES.Label_1.Enabled := .F.
        _HMG_PRINTER_PRINTPAGES.Label_2.Enabled := .F.
        _HMG_PRINTER_PRINTPAGES.Label_4.Enabled := .F.
        _HMG_PRINTER_PRINTPAGES.Spinner_1.Enabled := .F.
        _HMG_PRINTER_PRINTPAGES.Spinner_2.Enabled := .F.
        _HMG_PRINTER_PRINTPAGES.Combo_1.Enabled := .F.
        _HMG_PRINTER_PRINTPAGES.CheckBox_1.Enabled := .F.

        if      _HMG_printer_copies > 1 ;
		.or. ;
                _HMG_printer_collate == 1

                _HMG_PRINTER_PRINTPAGES.Spinner_3.Enabled := .F.

	endif

        ShowWindow ( GetFormHandle ( "_HMG_PRINTER_PRINTPAGES" ) )

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_PrintPagesDo
*------------------------------------------------------------------------------*
Local i
Local PageFrom
Local PageTo
Local p
Local OddOnly := .F.
Local EvenOnly := .F.

        If _HMG_PRINTER_PrintPages.Radio_1.Value == 1

		PageFrom := 1
                PageTo   := _HMG_printer_PageCount

        ElseIf _HMG_PRINTER_PrintPages.Radio_1.Value == 2

                PageFrom := _HMG_PRINTER_PrintPages.Spinner_1.Value
                PageTo   := _HMG_PRINTER_PrintPages.Spinner_2.Value

                If _HMG_PRINTER_PrintPages.Combo_1.Value == 2
			OddOnly := .T.
                ElseIf _HMG_PRINTER_PrintPages.Combo_1.Value == 3
			EvenOnly := .T.
		EndIf

	EndIf

        _HMG_PRINTER_StartDoc ( _HMG_printer_hdc_bak, _oohg_printer_docname )

        If      _HMG_printer_copies > 1 ;
		.or. ;
                _HMG_printer_collate == 1

		For i := PageFrom To PageTo

			If OddOnly == .T.
				If i / 2 != int (i / 2)
                                        _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
				EndIf
			ElseIf EvenOnly == .T.
				If i / 2 == int (i / 2)
                                        _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
				EndIf
			Else
                                _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
			EndIf

		Next i

	Else

                If _HMG_PRINTER_PrintPages.Spinner_3.Value == 1 // Copies

			For i := PageFrom To PageTo

				If OddOnly == .T.
					If i / 2 != int (i / 2)
                                                _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
					EndIf
				ElseIf EvenOnly == .T.
					If i / 2 == int (i / 2)
                                                _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
					EndIf
				Else
                                        _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
				EndIf

			Next i

		Else

                        If _HMG_PRINTER_PrintPages.CheckBox_1.Value == .F.

                                For p := 1 To _HMG_PRINTER_PrintPages.Spinner_3.Value
					For i := PageFrom To PageTo

						If OddOnly == .T.
							If i / 2 != int (i / 2)
                                                                _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
							EndIf
						ElseIf EvenOnly == .T.
							If i / 2 == int (i / 2)
                                                                _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
							EndIf
						Else
                                                        _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
						EndIf

					Next i

				Next p

			Else

				For i := PageFrom To PageTo

                                        For p := 1 To _HMG_PRINTER_PrintPages.Spinner_3.Value

						If OddOnly == .T.
							If i / 2 != int (i / 2)
                                                                _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
							EndIf
						ElseIf EvenOnly == .T.
							If i / 2 == int (i / 2)
                                                                _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
							EndIf
						Else
                                                        _HMG_PRINTER_PRINTPAGE ( _HMG_printer_hdc_bak , _HMG_printer_BasePageName + strzero(i,4) + ".emf" )
						EndIf

					Next p

				Next i

			EndIf

		EndIf

	EndIf

        _HMG_PRINTER_ENDDOC ( _HMG_printer_hdc_bak )

        EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWPREVIEW" ) )
        EnableWindow ( GetformHandle ( "_HMG_PRINTER_SHOWTHUMBNAILS" ) )
        EnableWindow ( GetformHandle ( "_HMG_PRINTER_PPNAV" ) )

        HideWindow ( GetFormHandle ( "_HMG_PRINTER_PRINTPAGES" ) )

        _HMG_PRINTER_SHOWPREVIEW.setfocus

Return

*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_MouseZoom
*------------------------------------------------------------------------------*
Local Width := GetDesktopWidth()
Local Height := GetDesktopHeight()
Local Q := 0
Local DeltaHeight := 35 + GetTitleHeight() + GetBorderHeight() + 10

        If _HMG_printer_Dz == 1000

                _HMG_printer_Dz := 0
                _HMG_printer_Dx := 0
                _HMG_printer_Dy := 0

                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 50 , 1 )
                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 50 , 1 )

                _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'))

	Else

		* Calculate Quadrant

                if      _oohg_mouseCol <= ( Width / 2 ) - _HMG_printer_zoomclick_xoffset ;
			.And. ;
                        _oohg_MouseRow <= ( Height / 2 ) - DeltaHeight

			Q := 1

                Elseif  _oohg_mouseCol > ( Width / 2 ) - _HMG_printer_zoomclick_xoffset ;
			.And. ;
                        _oohg_MouseRow <= ( Height / 2 ) - DeltaHeight

			Q := 2

                Elseif  _oohg_mousecol <= ( Width / 2 ) - _HMG_printer_zoomclick_xoffset ;
			.And. ;
                        _oohg_MouseRow > ( Height / 2 ) - DeltaHeight

			Q := 3

                Elseif  _oohg_mouseCol > ( Width / 2 ) - _HMG_printer_zoomclick_xoffset ;
			.And. ;
                        _oohg_MouseRow > ( Height / 2 ) - DeltaHeight

			Q := 4

		EndIf

                if      _HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) ;
			> ;
                        _HMG_PRINTER_GETPAGEWIDTH(_HMG_printer_hdc_bak)

			* Portrait

			If Q == 1
                                _HMG_printer_Dz := 1000
                                _HMG_printer_Dx := 100
                                _HMG_printer_Dy := 400
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 10 , 1 )
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 40 , 1 )
			ElseIf Q == 2
                                _HMG_printer_Dz := 1000
                                _HMG_printer_Dx := -100
                                _HMG_printer_Dy := 400
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 10 , 1 )
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 60 , 1 )
			ElseIf Q == 3
                                _HMG_printer_Dz := 1000
                                _HMG_printer_Dx := 100
                                _HMG_printer_Dy := -400
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 90 , 1 )
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 40 , 1 )
			ElseIf Q == 4
                                _HMG_printer_Dz := 1000
                                _HMG_printer_Dx := -100
                                _HMG_printer_Dy := -400
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 90 , 1 )
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 60 , 1 )
			EndIf

		Else

			* Landscape

			If Q == 1
                                _HMG_printer_Dz := 1000
                                _HMG_printer_Dx := 500
                                _HMG_printer_Dy := 300
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 20 , 1 )
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 1 , 1 )
			ElseIf Q == 2
                                _HMG_printer_Dz := 1000
                                _HMG_printer_Dx := -500
                                _HMG_printer_Dy := 300
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 20 , 1 )
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 99 , 1 )
			ElseIf Q == 3
                                _HMG_printer_Dz := 1000
                                _HMG_printer_Dx := 500
                                _HMG_printer_Dy := -300
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 80 , 1 )
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 1 , 1 )
			ElseIf Q == 4
                                _HMG_printer_Dz := 1000
                                _HMG_printer_Dx := -500
                                _HMG_printer_Dy := -300
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 80 , 1 )
                                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 99 , 1 )
			EndIf

		EndIf

                _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS (GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'))

	EndIf

        _HMG_PRINTER_PreviewRefresh()

Return

*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_Zoom
*------------------------------------------------------------------------------*

        If _HMG_printer_Dz == 1000

                _HMG_printer_Dz := 0
                _HMG_printer_Dx := 0
                _HMG_printer_Dy := 0

                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 50 , 1 )
                SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 50 , 1 )

                _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS (GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'))

	Else

                if      _HMG_PRINTER_GETPAGEHEIGHT(_HMG_printer_hdc_bak) ;
			> ;
                        _HMG_PRINTER_GETPAGEWIDTH(_HMG_printer_hdc_bak)

                        _HMG_printer_Dz := 1000
                        _HMG_printer_Dx := 100
                        _HMG_printer_Dy := 400
                        SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 10 , 1 )
                        SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 40 , 1 )

		Else

                        _HMG_printer_Dz := 1000
                        _HMG_printer_Dx := 500
                        _HMG_printer_Dy := 300
                        SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_VERT , 20 , 1 )
                        SetScrollPos ( GetFormHandle('_HMG_PRINTER_SHOWPREVIEW') , SB_HORZ , 1 , 1 )

		EndIf

                _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS (GetFormHandle('_HMG_PRINTER_SHOWPREVIEW'))

	EndIf

        _HMG_PRINTER_PreviewRefresh()

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_ScrollLeft
*------------------------------------------------------------------------------*
        _HMG_printer_Dx := _HMG_printer_Dx + _HMG_printer_scrollstep
        if _HMG_printer_Dx >= 500
                _HMG_printer_Dx := 500
		PlayBeep()
	EndIf
        _HMG_PRINTER_PreviewRefresh()
Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_ScrollRight
*------------------------------------------------------------------------------*
        _HMG_printer_Dx := _HMG_printer_Dx - _HMG_printer_scrollstep
        if _HMG_printer_Dx <= -500
                _HMG_printer_Dx := -500
		PlayBeep()
	EndIf
        _HMG_PRINTER_PreviewRefresh()
Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_ScrollUp
*------------------------------------------------------------------------------*
        _HMG_printer_Dy := _HMG_printer_Dy + _HMG_printer_scrollstep
        if _HMG_printer_Dy >= 500
                _HMG_printer_Dy := 500
		PlayBeep()
	EndIf
        _HMG_PRINTER_PreviewRefresh()
Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_ScrollDown
*------------------------------------------------------------------------------*
        _HMG_printer_Dy := _HMG_printer_Dy - _HMG_printer_scrollstep
        if _HMG_printer_Dy <= -500
                _HMG_printer_Dy := -500
		PlayBeep()
	EndIf

        _HMG_PRINTER_PreviewRefresh()
Return
*------------------------------------------------------------------------------*
Function GetPrinter()
*------------------------------------------------------------------------------*
        Local RetVal := '',I,nvalue:=0
        Local Printers := asort(aPrinters())
        Local cdefault:= getdefaultprinter()
        for i:=1 to len(printers)
            if printers[i]==cdefault
               nvalue:=i
               exit
            endif
        next i

        

        _HMG_printer_InitUserMessages()

        DEFINE WINDOW _HMG_PRINTER_GETPRINTER   ;
		AT 0,0			; 
		WIDTH 345		;
		HEIGHT GetTitleHeight() + 100 ;
                TITLE _HMG_printer_usermessages [13] ;
		MODAL			;
		NOSIZE

                @ 15,10 COMBOBOX Combo_1 ITEMS Printers VALUE nvalue WIDTH 320

                @ 53,65  BUTTON Ok CAPTION _HMG_printer_usermessages [11] ACTION ( RetVal := Printers [ GetProperty ( '_HMG_PRINTER_GETPRINTER','Combo_1','Value') ] , DoMethod('_HMG_PRINTER_GETPRINTER','Release' ) )
                @ 53,175 BUTTON Cancel CAPTION _HMG_printer_usermessages [12] ACTION ( RetVal := '' ,DoMethod('_HMG_PRINTER_GETPRINTER','Release' ) )

	END WINDOW

        CENTER WINDOW _HMG_PRINTER_GETPRINTER
        _HMG_printer_getprinter.ok.setfocus()

        ACTIVATE WINDOW _HMG_PRINTER_GETPRINTER

Return (RetVal)

*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_H_PRINT ( nHdc , nRow , nCol , cFontName , nFontSize , nColor1 , nColor2 , nColor3 , cText , lbold , litalic , lunderline , lstrikeout , lcolor , lfont , lsize )
*------------------------------------------------------------------------------*

	if ValType (cText) == "N"
		cText := AllTrim(Str(cText))
	Elseif ValType (cText) == "D"
		cText := dtoc (cText)
	Elseif ValType (cText) == "L"
                cText := if ( cText == .T. , _HMG_printer_usermessages [24] , _HMG_printer_usermessages [25] )
	Elseif ValType (cText) == "A"
		Return
	Elseif ValType (cText) == "B"
		Return
	Elseif ValType (cText) == "O"
		Return
	Elseif ValType (cText) == "U"
		Return
	EndIf

	nRow := Int ( nRow * 10000 / 254 )
	nCol := Int ( nCol * 10000 / 254 )

        _HMG_PRINTER_C_PRINT ( nHdc , nRow , nCol , cFontName , nFontSize , nColor1 , nColor2 , nColor3 , cText , lbold , litalic , lunderline , lstrikeout , lcolor , lfont , lsize )

Return

*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_H_MULTILINE_PRINT ( nHdc , nRow , nCol , nToRow , nToCol , cFontName , nFontSize , nColor1 , nColor2 , nColor3 , cText , lbold , litalic , lunderline , lstrikeout , lcolor , lfont , lsize )
*------------------------------------------------------------------------------*

	if ValType (cText) == "N"
		cText := AllTrim(Str(cText))
	Elseif ValType (cText) == "D"
		cText := dtoc (cText)
	Elseif ValType (cText) == "L"
                cText := if ( cText == .T. , _HMG_printer_usermessages [24] , _HMG_printer_usermessages [25] )
	Elseif ValType (cText) == "A"
		Return
	Elseif ValType (cText) == "B"
		Return
	Elseif ValType (cText) == "O"
		Return
	Elseif ValType (cText) == "U"
		Return
	EndIf

	nRow := Int ( nRow * 10000 / 254 )
	nCol := Int ( nCol * 10000 / 254 )
	nToRow := Int ( nToRow * 10000 / 254 )
	nToCol := Int ( nToCol * 10000 / 254 )

        _HMG_PRINTER_C_MULTILINE_PRINT ( nHdc , nRow , nCol , cFontName , nFontSize , nColor1 , nColor2 , nColor3 , cText , lbold , litalic , lunderline , lstrikeout , lcolor , lfont , lsize , nToRow , nToCol )

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_H_IMAGE ( nHdc , cImage , nRow , nCol , nHeight , nWidth , lStretch )
*------------------------------------------------------------------------------*

	nRow	:= Int ( nRow * 10000 / 254 )
	nCol	:= Int ( nCol * 10000 / 254 )
	nWidth	:= Int ( nWidth * 10000 / 254 )
	nHeight	:= Int ( nHeight * 10000 / 254 )

        _HMG_PRINTER_C_IMAGE ( nHdc , cImage , nRow , nCol , nHeight , nWidth , lStretch )

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_H_LINE ( nHdc , nRow , nCol , nToRow , nToCol , nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor )
*------------------------------------------------------------------------------*

	nRow	:= Int ( nRow * 10000 / 254 )
	nCol	:= Int ( nCol * 10000 / 254 )
	nToRow	:= Int ( nToRow * 10000 / 254 )
	nToCol	:= Int ( nToCol * 10000 / 254 )

	If ValType ( nWidth ) != 'U'
		nWidth	:= Int ( nWidth * 10000 / 254 )
	EndIf

        _HMG_PRINTER_C_LINE ( nHdc , nRow , nCol , nToRow , nToCol , nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor )

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_H_RECTANGLE ( nHdc , nRow , nCol , nToRow , nToCol ,nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor )
*------------------------------------------------------------------------------*

	nRow	:= Int ( nRow * 10000 / 254 )
	nCol	:= Int ( nCol * 10000 / 254 )
	nToRow	:= Int ( nToRow * 10000 / 254 )
	nToCol	:= Int ( nToCol * 10000 / 254 )

	If ValType ( nWidth ) != 'U'
		nWidth	:= Int ( nWidth * 10000 / 254 )
	EndIf

        _HMG_PRINTER_C_RECTANGLE ( nHdc , nRow , nCol , nToRow , nToCol , nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor )

Return
*------------------------------------------------------------------------------*
Procedure _HMG_PRINTER_H_ROUNDRECTANGLE ( nHdc , nRow , nCol , nToRow , nToCol ,nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor )
*------------------------------------------------------------------------------*

	nRow	:= Int ( nRow * 10000 / 254 )
	nCol	:= Int ( nCol * 10000 / 254 )
	nToRow	:= Int ( nToRow * 10000 / 254 )
	nToCol	:= Int ( nToCol * 10000 / 254 )

	If ValType ( nWidth ) != 'U'
		nWidth	:= Int ( nWidth * 10000 / 254 )
	EndIf

        _HMG_PRINTER_C_ROUNDRECTANGLE ( nHdc , nRow , nCol , nToRow , nToCol , nWidth , nColor1 , nColor2 , nColor3 , lwidth , lcolor )

Return
*------------------------------------------------------------------------------*
Procedure _HMG_printer_InitUserMessages
*------------------------------------------------------------------------------*
Local	cLang	:= ""   
Public  _HMG_printer_usermessages [29]

	cLang := Set ( _SET_LANGUAGE )

	// LANGUAGES NOT SUPPORTED BY hb_langSelect() FUNCTION.	

///         SET LANGUAGE TO FINNISH
//          SET LANGUAGE TO DUTCH


//        IF _HMG_LANG_ID == 'FI'         // FINNISH
//                cLang := 'FI'    
//        ELSEIF _HMG_LANG_ID == 'NL'     // DUTCH
//                cLang := 'NL'    
///        ENDIF

	do case

	/////////////////////////////////////////////////////////////
	// CROATIAN
	////////////////////////////////////////////////////////////
        case cLang == "HR852" // Croatian

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'

        case cLang == "EU"        // Basque.
	/////////////////////////////////////////////////////////////
	// BASQUE
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'

        case cLang == "EN"        // English
	/////////////////////////////////////////////////////////////
	// ENGLISH
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'

        case cLang == "FR"        // French
	/////////////////////////////////////////////////////////////
	// FRENCH
	////////////////////////////////////////////////////////////
	                                          
                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := "Prévision D'Impression"
                _HMG_printer_usermessages [03] := 'Première Page [HOME]'
                _HMG_printer_usermessages [04] := 'Page Précédente [PGUP]'
                _HMG_printer_usermessages [05] := 'Prochaine Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Dernière Page [END]'
                _HMG_printer_usermessages [07] := 'Allez Paginer'
                _HMG_printer_usermessages [08] := 'Bourdonnement'
                _HMG_printer_usermessages [09] := 'Copie'
                _HMG_printer_usermessages [10] := 'Page'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Annulation'
                _HMG_printer_usermessages [13] := "Choisissez L'Imprimeur"
                _HMG_printer_usermessages [14] := "Assemblez"
                _HMG_printer_usermessages [15] := "Chaîne D'Impression"
                _HMG_printer_usermessages [16] := 'Tous'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'De'
                _HMG_printer_usermessages [19] := 'À'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'Toute la Gamme'
                _HMG_printer_usermessages [22] := 'Pages Impaires'
                _HMG_printer_usermessages [23] := 'Pages Même'
                _HMG_printer_usermessages [24] := 'Oui'
                _HMG_printer_usermessages [25] := 'Non'
                _HMG_printer_usermessages [26] := 'Fermer'
                _HMG_printer_usermessages [27] := 'Sauver'
                _HMG_printer_usermessages [28] := 'affichettes'
                _HMG_printer_usermessages [29] := 'Produisant De affichettes...  Svp Attente...'

        case cLang == "DEWIN" .OR. cLang == "DE"       // German
	/////////////////////////////////////////////////////////////
	// GERMAN
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Seite'
                _HMG_printer_usermessages [02] := 'DruckcVorbetrachtung'
                _HMG_printer_usermessages [03] := 'Erste Seite [HOME]'
                _HMG_printer_usermessages [04] := 'Vorige Seite [PGUP]'
                _HMG_printer_usermessages [05] := 'Folgende Seite [PGDN]'
                _HMG_printer_usermessages [06] := 'Letzte Seite [END]'
                _HMG_printer_usermessages [07] := 'Gehen Sie Zu paginieren'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Druck'
                _HMG_printer_usermessages [10] := 'Seitenzahl'
                _HMG_printer_usermessages [11] := 'O.K.'
                _HMG_printer_usermessages [12] := 'Löschen'
                _HMG_printer_usermessages [13] := 'Wählen Sie Drucker Vor'
                _HMG_printer_usermessages [14] := 'Sortieren'
                _HMG_printer_usermessages [15] := 'DruckcStrecke'
                _HMG_printer_usermessages [16] := 'Alle'
                _HMG_printer_usermessages [17] := 'Seiten'
                _HMG_printer_usermessages [18] := 'Von'
                _HMG_printer_usermessages [19] := 'Zu'
                _HMG_printer_usermessages [20] := 'Kopien'
                _HMG_printer_usermessages [21] := 'Alle Strecke'
                _HMG_printer_usermessages [22] := 'Nur Ungerade Seiten'
                _HMG_printer_usermessages [23] := 'Nur Gleichmäßige Seiten'
                _HMG_printer_usermessages [24] := 'Ja'
                _HMG_printer_usermessages [25] := 'Nein'
                _HMG_printer_usermessages [26] := 'Fenster'
                _HMG_printer_usermessages [27] := 'Speichern'
                _HMG_printer_usermessages [28] := 'Überblick'
                _HMG_printer_usermessages [29] := 'Überblick Erzeugen...  Bitte Wartezeit...'

	case cLang == "IT"        // Italian
	/////////////////////////////////////////////////////////////
	// ITALIAN
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Pagina'
                _HMG_printer_usermessages [02] := 'Anteprima di stampa'
                _HMG_printer_usermessages [03] := 'Prima Pagina [HOME]'
                _HMG_printer_usermessages [04] := 'Pagina Precedente [PGUP]'
                _HMG_printer_usermessages [05] := 'Pagina Seguente [PGDN]'
                _HMG_printer_usermessages [06] := 'Ultima Pagina [END]'
                _HMG_printer_usermessages [07] := 'Vai Alla Pagina'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Stampa'
                _HMG_printer_usermessages [10] := 'Pagina'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Annulla'
                _HMG_printer_usermessages [13] := 'Selezioni Lo Stampatore'
                _HMG_printer_usermessages [14] := 'Fascicoli'
                _HMG_printer_usermessages [15] := 'Intervallo di stampa'
                _HMG_printer_usermessages [16] := 'Tutti'
                _HMG_printer_usermessages [17] := 'Pagine'
                _HMG_printer_usermessages [18] := 'Da'
                _HMG_printer_usermessages [19] := 'A'
                _HMG_printer_usermessages [20] := 'Copie'
                _HMG_printer_usermessages [21] := 'Tutte le pagine'
                _HMG_printer_usermessages [22] := 'Le Pagine Pari'
                _HMG_printer_usermessages [23] := 'Le Pagine Dispari'
                _HMG_printer_usermessages [24] := 'Si'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Chiudi'
                _HMG_printer_usermessages [27] := 'Salva'
                _HMG_printer_usermessages [28] := 'Miniatura'
                _HMG_printer_usermessages [29] := 'Generando Miniatura...  Prego Attesa...'

        case cLang == "PLWIN"  .OR. cLang == "PL852"  .OR. cLang == "PLISO"  .OR. cLang == ""  .OR. cLang == "PLMAZ"   // Polish 
	/////////////////////////////////////////////////////////////
	// POLISH
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'

        case cLang == "PT"        // Portuguese
	/////////////////////////////////////////////////////////////
	// PORTUGUESE
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Página'
                _HMG_printer_usermessages [02] := 'Inspecção prévia De Cópia'
                _HMG_printer_usermessages [03] := 'Primeira Página [HOME]'
                _HMG_printer_usermessages [04] := 'Página Precedente [PGUP]'
                _HMG_printer_usermessages [05] := 'Página Seguinte [PGDN]'
                _HMG_printer_usermessages [06] := 'Última Página [END]'
                _HMG_printer_usermessages [07] := 'Vá Paginar'
                _HMG_printer_usermessages [08] := 'amplie'
                _HMG_printer_usermessages [09] := 'Cópia'
                _HMG_printer_usermessages [10] := 'Página'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancelar'
                _HMG_printer_usermessages [13] := 'Selecione A Impressora'
                _HMG_printer_usermessages [14] := 'Ordene Cópias'
                _HMG_printer_usermessages [15] := 'Escala De Cópia'
                _HMG_printer_usermessages [16] := 'Tudo'
                _HMG_printer_usermessages [17] := 'Páginas'
                _HMG_printer_usermessages [18] := 'De'
                _HMG_printer_usermessages [19] := 'A'
                _HMG_printer_usermessages [20] := 'Cópias'
                _HMG_printer_usermessages [21] := 'Toda a Escala'
                _HMG_printer_usermessages [22] := 'Páginas Impares Somente'
                _HMG_printer_usermessages [23] := 'Páginas Uniformes Somente'
                _HMG_printer_usermessages [24] := 'Sim'
                _HMG_printer_usermessages [25] := 'Não'
                _HMG_printer_usermessages [26] := 'Fechar'
                _HMG_printer_usermessages [27] := 'Salvar'
                _HMG_printer_usermessages [28] := 'Miniaturas'
                _HMG_printer_usermessages [29] := 'Gerando Miniaturas...  Por favor Espera...'

        case cLang == "RUWIN"  .OR. cLang == "RU866" .OR. cLang == "RUKOI8" // Russian 
	/////////////////////////////////////////////////////////////
	// RUSSIAN
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'

        case cLang == "ES"  .OR. cLang == "ESWIN"       // Spanish
	/////////////////////////////////////////////////////////////
	// SPANISH
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Página'
                _HMG_printer_usermessages [02] := 'Vista Previa'
                _HMG_printer_usermessages [03] := 'Inicio [INICIO]'
                _HMG_printer_usermessages [04] := 'Anterior [REPAG]'
                _HMG_printer_usermessages [05] := 'Siguiente [AVPAG]'
                _HMG_printer_usermessages [06] := 'Fin [FIN]'
                _HMG_printer_usermessages [07] := 'Ir a'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Imprimir'
                _HMG_printer_usermessages [10] := 'Página Nro.'
                _HMG_printer_usermessages [11] := 'Aceptar'
                _HMG_printer_usermessages [12] := 'Cancelar'
                _HMG_printer_usermessages [13] := 'Seleccionar Impresora'
                _HMG_printer_usermessages [14] := 'Ordenar Copias'
                _HMG_printer_usermessages [15] := 'Rango de Impresión'
                _HMG_printer_usermessages [16] := 'Todo'
                _HMG_printer_usermessages [17] := 'Páginas'
                _HMG_printer_usermessages [18] := 'Desde'
                _HMG_printer_usermessages [19] := 'Hasta'
                _HMG_printer_usermessages [20] := 'Copias'
                _HMG_printer_usermessages [21] := 'Todo El Rango'
                _HMG_printer_usermessages [22] := 'Solo Páginas Impares'
                _HMG_printer_usermessages [23] := 'Solo Páginas Pares'
                _HMG_printer_usermessages [24] := 'Si'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Cerrar'
                _HMG_printer_usermessages [27] := 'Guardar'
                _HMG_printer_usermessages [28] := 'Miniaturas'
                _HMG_printer_usermessages [29] := 'Generando Miniaturas... Espere Por Favor...'

        case cLang == "FI"        // Finnish
	///////////////////////////////////////////////////////////////////////
	// FINNISH
	///////////////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'
	
        case cLang == "NL"        // Dutch
	/////////////////////////////////////////////////////////////
	// DUTCH
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'

        case cLang == "SLWIN" .OR. cLang == "SLISO" .OR. cLang == "SL852" .OR. cLang == "" .OR. cLang == "SL437" // Slovenian
  	/////////////////////////////////////////////////////////////
	// SLOVENIAN
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'

	OtherWise
	/////////////////////////////////////////////////////////////
	// DEFAULT ENGLISH
	////////////////////////////////////////////////////////////

                _HMG_printer_usermessages [01] := 'Page'
                _HMG_printer_usermessages [02] := 'Print Preview'
                _HMG_printer_usermessages [03] := 'First Page [HOME]'
                _HMG_printer_usermessages [04] := 'Previous Page [PGUP]'
                _HMG_printer_usermessages [05] := 'Next Page [PGDN]'
                _HMG_printer_usermessages [06] := 'Last Page [END]'
                _HMG_printer_usermessages [07] := 'Go To Page'
                _HMG_printer_usermessages [08] := 'Zoom'
                _HMG_printer_usermessages [09] := 'Print'
                _HMG_printer_usermessages [10] := 'Page Number'
                _HMG_printer_usermessages [11] := 'Ok'
                _HMG_printer_usermessages [12] := 'Cancel'
                _HMG_printer_usermessages [13] := 'Select Printer'
                _HMG_printer_usermessages [14] := 'Collate Copies'
                _HMG_printer_usermessages [15] := 'Print Range'
                _HMG_printer_usermessages [16] := 'All'
                _HMG_printer_usermessages [17] := 'Pages'
                _HMG_printer_usermessages [18] := 'From'
                _HMG_printer_usermessages [19] := 'To'
                _HMG_printer_usermessages [20] := 'Copies'
                _HMG_printer_usermessages [21] := 'All Range'
                _HMG_printer_usermessages [22] := 'Odd Pages Only'
                _HMG_printer_usermessages [23] := 'Even Pages Only'
                _HMG_printer_usermessages [24] := 'Yes'
                _HMG_printer_usermessages [25] := 'No'
                _HMG_printer_usermessages [26] := 'Close'
                _HMG_printer_usermessages [27] := 'Save'
                _HMG_printer_usermessages [28] := 'Thumbnails'
                _HMG_printer_usermessages [29] := 'Generating Thumbnails... Please Wait...'

	endcase

Return

*------------------------------------------------------------------------------*
FUNCTION GETPRINTABLEAREAWIDTH()
*------------------------------------------------------------------------------*

        IF ! __MVEXIST ( '_HMG_printer_hdc' )
		RETURN 0
	ENDIF

RETURN _HMG_PRINTER_GETPRINTERWIDTH ( _HMG_printer_hdc )

*------------------------------------------------------------------------------*
FUNCTION GETPRINTABLEAREAHEIGHT()
*------------------------------------------------------------------------------*

        IF ! __MVEXIST ( '_HMG_printer_hdc' )
		RETURN 0
	ENDIF

RETURN _HMG_PRINTER_GETPRINTERHEIGHT ( _HMG_printer_hdc )

*------------------------------------------------------------------------------*
FUNCTION GETPRINTABLEAREAHORIZONTALOFFSET()
*------------------------------------------------------------------------------*

        IF ! __MVEXIST ( '_HMG_printer_hdc' )
		RETURN 0
	ENDIF

RETURN ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETX ( _HMG_printer_hdc ) / _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSX ( _HMG_printer_hdc ) * 25.4 )

*------------------------------------------------------------------------------*
FUNCTION GETPRINTABLEAREAVERTICALOFFSET()
*------------------------------------------------------------------------------*

        IF ! __MVEXIST ( '_HMG_printer_hdc' )
		RETURN 0
	ENDIF

RETURN ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETY ( _HMG_printer_hdc ) / _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSY ( _HMG_printer_hdc ) * 25.4 )

*------------------------------------------------------------------------------*
FUNCTION textALIGN(nAlign)
*------------------------------------------------------------------------------*
CVCSETTEXTALIGN( _HMG_printer_hdc,nAlign )
RETURN NIL


#pragma BEGINDUMP


///////////////////////////////////////////////////////////////////////////////
// LOW LEVEL C PRINT ROUTINES
///////////////////////////////////////////////////////////////////////////////

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

HB_FUNC ( CVCSETTEXTALIGN )
{
  hb_retni(SetTextAlign( (HDC) hb_parnl (1) ,  hb_parni(2)));
}

HB_FUNC ( _HMG_PRINTER_ABORTDOC )
{
	HDC hdcPrint = (HDC) hb_parnl(1) ;
	AbortDoc(hdcPrint);
}

HB_FUNC ( _HMG_PRINTER_STARTDOC )
{

	DOCINFO docInfo;

	HDC hdcPrint = (HDC) hb_parnl(1) ;

  	if ( hdcPrint != 0 )
	{

		ZeroMemory(&docInfo, sizeof(docInfo));
		docInfo.cbSize = sizeof(docInfo);
                docInfo.lpszDocName =  hb_parc(2);

		StartDoc(hdcPrint, &docInfo);

	}
}

HB_FUNC ( _HMG_PRINTER_STARTPAGE )
{

	HDC hdcPrint = (HDC) hb_parnl(1) ;

	if ( hdcPrint != 0 )
	{
		StartPage(hdcPrint);
	}

}

HB_FUNC ( _HMG_PRINTER_C_PRINT )
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

        HGDIOBJ hgdiobj ;

	char FontName [32] ;
	int FontSize ;

	DWORD fdwItalic ;
	DWORD fdwUnderline ;
	DWORD fdwStrikeOut ;

	int fnWeight ;
	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	HFONT hfont ;

	HDC hdcPrint = (HDC) hb_parnl(1) ;

	int FontHeight ;

	if ( hdcPrint != 0 )
	{

		// Bold

		if ( hb_parl(10) )
		{
			fnWeight = FW_BOLD ;
		}
		else
		{
			fnWeight = FW_NORMAL ;
		}

		// Italic

		if ( hb_parl(11) )
		{
			fdwItalic = TRUE ;
		}
		else
		{
			fdwItalic = FALSE ;
		}

		// UnderLine

		if ( hb_parl(12) )
		{
			fdwUnderline = TRUE ;
		}
		else
		{
			fdwUnderline = FALSE ;
		}

		// StrikeOut

		if ( hb_parl(13) )
		{
			fdwStrikeOut = TRUE ;
		}
		else
		{
			fdwStrikeOut = FALSE ;
		}

		// Color

		if ( hb_parl(14) )
		{
			r = hb_parni(6) ;
			g = hb_parni(7) ;
			b = hb_parni(8) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		// Fontname

		if ( hb_parl(15) )
		{
			strcpy ( FontName , hb_parc(4) ) ;
		}
		else
		{
			strcpy( FontName , "Arial" ) ;
		}

		// FontSize

		if ( hb_parl(16) )
		{
			FontSize = hb_parni(5) ;
		}
		else
		{
			FontSize = 10 ;
		}

		FontHeight = -MulDiv ( FontSize , GetDeviceCaps ( hdcPrint , LOGPIXELSY ) , 72 ) ;

		hfont = CreateFont 
			( 
			FontHeight, 
			0, 
			0, 
			0, 
			fnWeight , 
			fdwItalic , 
			fdwUnderline , 
			fdwStrikeOut , 
			DEFAULT_CHARSET, 
			OUT_TT_PRECIS, 
			CLIP_DEFAULT_PRECIS, 
			DEFAULT_QUALITY, 
			FF_DONTCARE, 
			FontName 
			);

		hgdiobj = SelectObject ( hdcPrint , hfont ) ;

		SetTextColor( hdcPrint , RGB ( r , g , b ) ) ;
		SetBkMode( hdcPrint , TRANSPARENT );
 
		TextOut( hdcPrint , 
			( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,
			hb_parc(9),
			strlen(hb_parc(9)) ) ; 

                SelectObject ( hdcPrint , hgdiobj ) ;

		DeleteObject ( hfont ) ;

	}

}

HB_FUNC ( _HMG_PRINTER_C_MULTILINE_PRINT )
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

        HGDIOBJ hgdiobj ;

	char FontName [32] ;
	int FontSize ;

	DWORD fdwItalic ;
	DWORD fdwUnderline ;
	DWORD fdwStrikeOut ;

	RECT rect ;

	int fnWeight ;
	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;
	int toy = hb_parni(17) ;
	int tox = hb_parni(18) ;

	HFONT hfont ;

	HDC hdcPrint = (HDC) hb_parnl(1) ;

	int FontHeight ;

	if ( hdcPrint != 0 )
	{

		// Bold

		if ( hb_parl(10) )
		{
			fnWeight = FW_BOLD ;
		}
		else
		{
			fnWeight = FW_NORMAL ;
		}

		// Italic 

		if ( hb_parl(11) )
		{
			fdwItalic = TRUE ;
		}
		else
		{
			fdwItalic = FALSE ;
		}

		// UnderLine

		if ( hb_parl(12) )
		{
			fdwUnderline = TRUE ;
		}
		else
		{
			fdwUnderline = FALSE ;
		}

		// StrikeOut

		if ( hb_parl(13) )
		{
			fdwStrikeOut = TRUE ;
		}
		else
		{
			fdwStrikeOut = FALSE ;
		}

		// Color

		if ( hb_parl(14) )
		{
			r = hb_parni(6) ;
			g = hb_parni(7) ;
			b = hb_parni(8) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		// Fontname

		if ( hb_parl(15) )
		{
			strcpy ( FontName , hb_parc(4) ) ;
		}
		else
		{
			strcpy( FontName , "Arial" ) ;
		}

		// FontSize

		if ( hb_parl(16) )
		{
			FontSize = hb_parni(5) ;
		}
		else
		{
			FontSize = 10 ;
		}

		FontHeight = -MulDiv ( FontSize , GetDeviceCaps ( hdcPrint , LOGPIXELSY ) , 72 ) ;

		hfont = CreateFont 
			( 
			FontHeight, 
			0, 
			0, 
			0, 
			fnWeight , 
			fdwItalic , 
			fdwUnderline , 
			fdwStrikeOut , 
			DEFAULT_CHARSET, 
			OUT_TT_PRECIS, 
			CLIP_DEFAULT_PRECIS, 
			DEFAULT_QUALITY, 
			FF_DONTCARE, 
			FontName 
			);

		hgdiobj = SelectObject ( hdcPrint , hfont ) ;

		SetTextColor( hdcPrint , RGB ( r , g , b ) ) ;
		SetBkMode( hdcPrint , TRANSPARENT );

		rect.left	= ( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ;
		rect.top	= ( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY )  ;
		rect.right	= ( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ;
		rect.bottom	= ( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ;
 
		DrawText ( hdcPrint , 
			hb_parc(9),
			strlen(hb_parc(9)), 
			&rect ,
			DT_NOPREFIX | DT_MODIFYSTRING | DT_WORDBREAK | DT_END_ELLIPSIS 
			) ; 

                SelectObject ( hdcPrint , hgdiobj ) ;
                
		DeleteObject ( hfont ) ;

	}

}

HB_FUNC ( _HMG_PRINTER_ENDPAGE )
{
	HDC hdcPrint = (HDC) hb_parnl(1) ;

	if ( hdcPrint != 0 )
	{
		EndPage(hdcPrint);
	}

}

HB_FUNC ( _HMG_PRINTER_ENDDOC )
{
	HDC hdcPrint = (HDC) hb_parnl(1) ;

	if ( hdcPrint != 0 )	
	{
		EndDoc(hdcPrint);
	}

}

HB_FUNC ( _HMG_PRINTER_DELETEDC )
{
	HDC hdcPrint = (HDC) hb_parnl(1) ;

	DeleteDC(hdcPrint);

}

HB_FUNC ( _HMG_PRINTER_PRINTDIALOG )
{

	PRINTDLG pd ;

	LPDEVMODE   pDevMode;

	pd.lStructSize = sizeof(PRINTDLG); 
	pd.hDevMode = (HANDLE) NULL; 
	pd.hDevNames = (HANDLE) NULL; 
	pd.Flags = PD_RETURNDC | PD_PRINTSETUP ; 
	pd.hwndOwner = NULL ; 
	pd.hDC = (HDC) NULL; 
	pd.nFromPage = 1; 
	pd.nToPage = 1; 
	pd.nMinPage = 0; 
	pd.nMaxPage = 0; 
	pd.nCopies = 1; 
	pd.hInstance = (HANDLE) NULL; 
	pd.lCustData = 0L; 
	pd.lpfnPrintHook = (LPPRINTHOOKPROC) NULL; 
	pd.lpfnSetupHook = (LPSETUPHOOKPROC) NULL; 
	pd.lpPrintTemplateName = (LPSTR) NULL; 
	pd.lpSetupTemplateName = (LPSTR)  NULL; 
	pd.hPrintTemplate = (HANDLE) NULL; 
	pd.hSetupTemplate = (HANDLE) NULL; 
 
	if ( PrintDlg(&pd) ) 
	{
		pDevMode = (LPDEVMODE) GlobalLock(pd.hDevMode);

		hb_reta( 4 );
		hb_stornl	( (LONG) pd.hDC		, -1, 1 ); 
		hb_storc	( pDevMode->dmDeviceName, -1, 2 ); 
		hb_storni	( pDevMode->dmCopies	, -1, 3 ); 
		hb_storni	( pDevMode->dmCollate	, -1, 4 ); 

		GlobalUnlock(pd.hDevMode);
	}
	else
	{
		hb_reta( 4 );
		hb_stornl	( 0	, -1, 1 ); 
		hb_storc	( ""	, -1, 2 ); 
		hb_storni	( 0	, -1, 3 );
		hb_storni	( 0	, -1, 4 );
	}

}

HB_FUNC (APRINTERS)   //Pier Release
{
      OSVERSIONINFO osVer;
      DWORD level;
      DWORD flags;
      DWORD dwSize = 0;
      DWORD dwPrinters = 0;
      DWORD i;
      LPBYTE pBuffer;
      LPBYTE cBuffer ;
      PRINTER_INFO_4* pInfo_4;
      PRINTER_INFO_5* pInfo_5;
      osVer.dwOSVersionInfoSize = sizeof( osVer );
      if( GetVersionEx( &osVer ) )
      {
         switch( osVer.dwPlatformId )
         {
            case VER_PLATFORM_WIN32_NT:
               flags = PRINTER_ENUM_CONNECTIONS|PRINTER_ENUM_LOCAL;
               level = 4;
            break;

            default:
               flags = PRINTER_ENUM_LOCAL;
               level = 5;
            break;
         }
         EnumPrinters(flags, NULL, level, NULL, 0, &dwSize, &dwPrinters);
         pBuffer = GlobalAlloc(GPTR, dwSize);
         if (pBuffer == NULL)
         {
            hb_reta(0);
			GlobalFree(pBuffer);
            return;
         }
         EnumPrinters(flags, NULL, level, pBuffer, dwSize, &dwSize, &dwPrinters);
         if (dwPrinters == 0)
         {
            hb_reta(0);
			GlobalFree(pBuffer);
            return;
         }
         switch( osVer.dwPlatformId )
         {
            case VER_PLATFORM_WIN32_NT:
               pInfo_4 = (PRINTER_INFO_4*)pBuffer;
               hb_reta( dwPrinters );
               for ( i = 0; i < dwPrinters; i++, pInfo_4++)
               {
                  cBuffer = GlobalAlloc(GPTR, 256);
                  strcat(cBuffer,pInfo_4->pPrinterName);
                  hb_storc( cBuffer , -1 , i+1 );
                  GlobalFree(cBuffer);
               }

               GlobalFree(pBuffer);
            break;
            default:
               pInfo_5 = (PRINTER_INFO_5*)pBuffer;
               hb_reta( dwPrinters );
               for ( i = 0; i < dwPrinters; i++, pInfo_5++)
               {
                  cBuffer = GlobalAlloc(GPTR, 256);
                  strcat(cBuffer,pInfo_5->pPrinterName);
                  hb_storc( cBuffer , -1 , i+1 );
                  GlobalFree(cBuffer);
               }
               GlobalFree(pBuffer);
            break;
         }
      }
      else
      {
         GlobalFree(cBuffer);
         GlobalFree(pBuffer);
         hb_reta(0);
      }
   }


HB_FUNC ( _HMG_PRINTER_C_RECTANGLE )
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

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;

	HDC hdcPrint = (HDC) hb_parnl(1) ;
	HGDIOBJ hgdiobj;
	HPEN hpen;

	if ( hdcPrint != 0 )
	{

		// Width

		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1 * 10000 / 254 ;
		}

		// Color

		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		hpen = CreatePen( (int) PS_SOLID, ( width * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r , g , b ) );

		hgdiobj = SelectObject( (HDC) hdcPrint , hpen );

		Rectangle( (HDC) hdcPrint ,
			( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,	 
			( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) 
			);

		SelectObject( (HDC) hdcPrint , (HGDIOBJ) hgdiobj );

		DeleteObject( hpen );

	}

}

HB_FUNC ( _HMG_PRINTER_C_ROUNDRECTANGLE )
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

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;

	int w , h , p ;

	HDC hdcPrint = (HDC) hb_parnl(1) ;
	HGDIOBJ hgdiobj;
	HPEN hpen;

	if ( hdcPrint != 0 )
	{

		// Width

		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1 * 10000 / 254 ;
		}

		// Color

		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		hpen = CreatePen( (int) PS_SOLID, ( width * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r , g , b ) );

		hgdiobj = SelectObject( (HDC) hdcPrint , hpen );

		w = ( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - ( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) ;
		h = ( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - ( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) ;
		p = ( w + h ) / 2 ;
		p = p / 10 ;

		RoundRect( (HDC) hdcPrint , 
			( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,	 
			( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) , 
			p ,
			p 
			) ;

		SelectObject( (HDC) hdcPrint , (HGDIOBJ) hgdiobj );

		DeleteObject( hpen );

	}

}

HB_FUNC ( _HMG_PRINTER_C_LINE )
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

	int r ;
	int g ;
	int b ;

	int x = hb_parni(3) ;
	int y = hb_parni(2) ;

	int tox = hb_parni(5) ;
	int toy = hb_parni(4) ;

	int width ;

	HDC hdcPrint = (HDC) hb_parnl(1) ;
	HGDIOBJ hgdiobj;
	HPEN hpen;

	if ( hdcPrint != 0 )
	{

		// Width

		if ( hb_parl(10) )
		{
			width = hb_parni(6) ;
		}
		else
		{
			width = 1 * 10000 / 254 ;
		}

		// Color

		if ( hb_parl(11) )
		{
			r = hb_parni(7) ;
			g = hb_parni(8) ;
			b = hb_parni(9) ;
		}
		else
		{
			r = 0 ;
			g = 0 ;
			b = 0 ;
		}

		hpen = CreatePen( (int) PS_SOLID, ( width * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ), (COLORREF) RGB( r , g , b ) );

		hgdiobj = SelectObject( (HDC) hdcPrint , hpen );

		MoveToEx( (HDC) hdcPrint , 
			( x * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( y * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ,	 
			NULL
			);

		LineTo ( (HDC) hdcPrint , 
			( tox * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ,
			( toy * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) 
			);

		SelectObject( (HDC) hdcPrint , (HGDIOBJ) hgdiobj );

		DeleteObject( hpen );

	}

}

HB_FUNC ( _HMG_PRINTER_SETPRINTERPROPERTIES )
{
	HANDLE hPrinter = NULL;
	DWORD dwNeeded = 0;
	PRINTER_INFO_2 *pi2 ;
	DEVMODE *pDevMode = NULL;
	BOOL bFlag;
	LONG lFlag;

	HDC hdcPrint ;
	
	int fields = 0 ;

	bFlag = OpenPrinter( hb_parc(1) , &hPrinter, NULL);

	if (!bFlag || (hPrinter == NULL))
	{
		MessageBox(0, "Printer Configuration Failed! (001)", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_stornl	( 0 	, -1, 1 ); 
		hb_storc	( ""	, -1, 2 ); 
		hb_storni	( 0	, -1, 3 ); 
		hb_storni	( 0	, -1, 4 ); 

		return;
	}

	SetLastError(0);

	bFlag = GetPrinter(hPrinter, 2, 0, 0, &dwNeeded);

	if ((!bFlag) && (GetLastError() != ERROR_INSUFFICIENT_BUFFER) || (dwNeeded == 0))
	{
		ClosePrinter(hPrinter);
		MessageBox(0, "Printer Configuration Failed! (002)", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_stornl	( 0 	, -1, 1 ); 
		hb_storc	( ""	, -1, 2 ); 
		hb_storni	( 0	, -1, 3 ); 
		hb_storni	( 0	, -1, 4 ); 

		return;
	}

	pi2 = (PRINTER_INFO_2 *)GlobalAlloc(GPTR, dwNeeded);

	if (pi2 == NULL)
	{
		ClosePrinter(hPrinter);
		MessageBox(0, "Printer Configuration Failed! (003)", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_stornl	( 0 	, -1, 1 ); 
		hb_storc	( ""	, -1, 2 ); 
		hb_storni	( 0	, -1, 3 ); 
		hb_storni	( 0	, -1, 4 ); 

		return;
	}

	bFlag = GetPrinter(hPrinter, 2, (LPBYTE)pi2, dwNeeded, &dwNeeded);

	if (!bFlag)
	{
		GlobalFree(pi2);
		ClosePrinter(hPrinter);
		MessageBox(0, "Printer Configuration Failed! (004)", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_stornl	( 0 	, -1, 1 ); 
		hb_storc	( ""	, -1, 2 ); 
		hb_storni	( 0	, -1, 3 ); 
		hb_storni	( 0	, -1, 4 ); 

		return;
	}

	if (pi2->pDevMode == NULL)
	{
		dwNeeded = DocumentProperties(NULL, hPrinter, hb_parc(1), NULL, NULL, 0);
		if (dwNeeded <= 0)
		{
			GlobalFree(pi2);
			ClosePrinter(hPrinter);
			MessageBox(0, "Printer Configuration Failed! (005)", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pDevMode = (DEVMODE *)GlobalAlloc(GPTR, dwNeeded);
		if (pDevMode == NULL)
		{
			GlobalFree(pi2);
			ClosePrinter(hPrinter);
			MessageBox(0, "Printer Configuration Failed! (006)", "Error! (006)",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		lFlag = DocumentProperties(NULL, hPrinter, hb_parc(1), pDevMode, NULL,DM_OUT_BUFFER);
		if (lFlag != IDOK || pDevMode == NULL)
		{
			GlobalFree(pDevMode);
			GlobalFree(pi2);
			ClosePrinter(hPrinter);
			MessageBox(0, "Printer Configuration Failed! (007)", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode = pDevMode;
	}

	///////////////////////////////////////////////////////////////////////
	// Specify Fields
	//////////////////////////////////////////////////////////////////////
	// Orientation
	if ( hb_parni(2) != -999 )
	{
		fields = fields | DM_ORIENTATION ;
	}

	// PaperSize
	if ( hb_parni(3) != -999 )
	{
		fields = fields | DM_PAPERSIZE ;
	}

	// PaperLenght
	if ( hb_parni(4) != -999 )
	{
		fields = fields | DM_PAPERLENGTH ;
	}

	// PaperWidth
	if ( hb_parni(5) != -999 )
	{
		fields = fields | DM_PAPERWIDTH	 ;
	}

	// Copies
	if ( hb_parni(6) != -999 )
	{
		fields = fields | DM_COPIES ;
	}

	// Default Source
	if ( hb_parni(7) != -999 )
	{
		fields = fields | DM_DEFAULTSOURCE ;
	}

	// Print Quality
	if ( hb_parni(8) != -999 )
	{
		fields = fields | DM_PRINTQUALITY ;
	}

	// Print Color
	if ( hb_parni(9) != -999 )
	{
		fields = fields | DM_COLOR ;
	}

	// Print Duplex Mode
	if ( hb_parni(10) != -999 )
	{
		fields = fields | DM_DUPLEX ;
	}

	// Print Collate
	if ( hb_parni(11) != -999 )
	{
		fields = fields | DM_COLLATE ;
	}

	pi2->pDevMode->dmFields = fields ;

	///////////////////////////////////////////////////////////////////////
	// Load Fields
	//////////////////////////////////////////////////////////////////////
	// Orientation
	if ( hb_parni(2) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_ORIENTATION))
		{
			MessageBox(0, "Printer Configuration Failed: ORIENTATION Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmOrientation = (short) hb_parni(2);
	}

	// PaperSize
	if ( hb_parni(3) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_PAPERSIZE ))
		{
			MessageBox(0, "Printer Configuration Failed: PAPERSIZE Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmPaperSize = (short) hb_parni(3);
	}

	// PaperLenght
	if ( hb_parni(4) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_PAPERLENGTH ))
		{
			MessageBox(0, "Printer Configuration Failed: PAPERLENGTH Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmPaperLength = (short) hb_parni(4) * 10 ;
	}

	// PaperWidth
	if ( hb_parni(5) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_PAPERWIDTH))
		{
			MessageBox(0, "Printer Configuration Failed: PAPERWIDTH Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmPaperWidth = (short) hb_parni(5) * 10 ;
	}

	// Copies
	if ( hb_parni(6) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_COPIES ))
		{
			MessageBox(0, "Printer Configuration Failed: COPIES Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmCopies = (short) hb_parni(6);
	}

	// Default Source
	if ( hb_parni(7) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_DEFAULTSOURCE ))
		{
			MessageBox(0, "Printer Configuration Failed: DEFAULTSOURCE Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmDefaultSource = (short) hb_parni(7);
	}

	// Print Quality
	if ( hb_parni(8) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_PRINTQUALITY ))
		{
			MessageBox(0, "Printer Configuration Failed: QUALITY Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmPrintQuality = (short) hb_parni(8);
	}

	// Print Color
	if ( hb_parni(9) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_COLOR ))
		{
			MessageBox(0, "Printer Configuration Failed: COLOR Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmColor = (short) hb_parni(9);
	}

	// Print Duplex
	if ( hb_parni(10) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_DUPLEX ))
		{
			MessageBox(0, "Printer Configuration Failed: DUPLEX Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmDuplex = (short) hb_parni(10);
	}

	// Print Collate
	if ( hb_parni(11) != -999 )
	{
		if (!(pi2->pDevMode->dmFields & DM_COLLATE ))
		{
			MessageBox(0, "Printer Configuration Failed: COLLATE Property Not Supported By Selected Printer", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

			hb_reta( 4 );
			hb_stornl	( 0 	, -1, 1 ); 
			hb_storc	( ""	, -1, 2 ); 
			hb_storni	( 0	, -1, 3 ); 
			hb_storni	( 0	, -1, 4 ); 

			return;
		}

		pi2->pDevMode->dmCollate = (short) hb_parni(11);
	}

	//////////////////////////////////////////////////////////////////////

	pi2->pSecurityDescriptor = NULL;

	lFlag = DocumentProperties(NULL, hPrinter, hb_parc(1), pi2->pDevMode, pi2->pDevMode,DM_IN_BUFFER | DM_OUT_BUFFER);

	if (lFlag != IDOK)
	{
		GlobalFree(pi2);
		ClosePrinter(hPrinter);
		if (pDevMode)
		{
			GlobalFree(pDevMode);
		}
		MessageBox(0, "Printer Configuration Failed! (008)", "Error!",MB_ICONEXCLAMATION | MB_OK | MB_SYSTEMMODAL);

		hb_reta( 4 );
		hb_stornl	( 0 	, -1, 1 ); 
		hb_storc	( ""	, -1, 2 ); 
		hb_storni	( 0	, -1, 3 ); 
		hb_storni	( 0	, -1, 4 ); 

		return;
	}

	hdcPrint = CreateDC(NULL, TEXT( hb_parc(1) ), NULL, pi2->pDevMode);

	if ( hdcPrint != NULL )
	{
		hb_reta( 4 );
		hb_stornl	( (LONG) hdcPrint		, -1, 1 ); 
		hb_storc	( hb_parc(1)			, -1, 2 ); 
		hb_storni	( (INT) pi2->pDevMode->dmCopies	, -1, 3 ); 
		hb_storni	( (INT) pi2->pDevMode->dmCollate	, -1, 4 ); 
	}
	else
	{
		hb_reta( 4 );
		hb_stornl	( 0 	, -1, 1 ); 
		hb_storc	( ""	, -1, 2 ); 
		hb_storni	( 0	, -1, 3 ); 
		hb_storni	( 0	, -1, 4 ); 
	}

	if (pi2)
	{
		GlobalFree(pi2);
	}

	if (hPrinter)
	{
		ClosePrinter(hPrinter);
	}

	if (pDevMode)
	{
		GlobalFree(pDevMode);
	}

}


HB_FUNC (GETDEFAULTPRINTER)
{
        
	OSVERSIONINFO osvi;
	LPPRINTER_INFO_5 PrinterInfo;
	DWORD Needed , Returned ;
	DWORD BufferSize = 254;

	char DefaultPrinter [254] ;
	char Buffer [254] ;

	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);

	GetVersionEx(&osvi);

	if (osvi.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS)
	{

		EnumPrinters(PRINTER_ENUM_DEFAULT,NULL,5,NULL,0,&Needed,&Returned);
		PrinterInfo = (LPPRINTER_INFO_5) LocalAlloc(LPTR,Needed);
		EnumPrinters(PRINTER_ENUM_DEFAULT,NULL,5,(LPBYTE) PrinterInfo,Needed,&Needed,&Returned);
		strcpy(DefaultPrinter,PrinterInfo->pPrinterName);
		LocalFree(PrinterInfo);

	}
	else if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
	{

		GetProfileString("windows","device","",DefaultPrinter,BufferSize);
		strtok(DefaultPrinter, ",");

	}

	hb_retc(DefaultPrinter);

}

HB_FUNC ( _HMG_PRINTER_STARTPAGE_PREVIEW )
{

	HDC tmpDC ;
	RECT emfrect ;

	SetRect(&emfrect,0,0,GetDeviceCaps( (HDC) hb_parnl(1) , HORZSIZE)*100 , GetDeviceCaps( (HDC) hb_parnl(1) , VERTSIZE)*100 ) ;

	tmpDC = CreateEnhMetaFile ( (HDC) hb_parnl(1) , hb_parc(2) , &emfrect , "" ) ; 

	hb_retnl ( (LONG) tmpDC ) ; 

}

HB_FUNC ( _HMG_PRINTER_ENDPAGE_PREVIEW )
{
	DeleteEnhMetaFile(CloseEnhMetaFile( (HDC) hb_parnl (1) ) );
}

HB_FUNC ( _HMG_PRINTER_SHOWPAGE )
{

	HENHMETAFILE hemf ;
	HWND hWnd = (HWND) hb_parnl(2) ;
	HDC hDC ;
	RECT rct ;
	RECT aux ;
	int zw ;
	int zh ;
	int ClientWidth ;
	int ClientHeight ;
	int xOffset ;
	int yOffset ;

	hemf = GetEnhMetaFile( hb_parc(1) ) ; 

	hDC = GetDC(hWnd); 

	GetClientRect(hWnd,&rct);

	ClientWidth = rct.right - rct.left ;
	ClientHeight = rct.bottom - rct.left ;

	zw = hb_parni(5) * GetDeviceCaps( (HDC) hb_parnl(3) , HORZSIZE) / 750 ;
	zh = hb_parni(5) * GetDeviceCaps( (HDC) hb_parnl(3) , VERTSIZE) / 750 ;

	xOffset = ( ClientWidth - ( GetDeviceCaps( (HDC) hb_parnl(3) , HORZSIZE)  * hb_parni(4) / 10000 ) ) / 2 ;
	yOffset = ( ClientHeight - ( GetDeviceCaps( (HDC) hb_parnl(3) , VERTSIZE)  * hb_parni(4) / 10000 ) ) / 2 ;	

	SetRect(&rct,
	xOffset + hb_parni(6) - zw ,
	yOffset + hb_parni(7) - zh ,
	xOffset + ( GetDeviceCaps( (HDC) hb_parnl(3) , HORZSIZE) * hb_parni(4) / 10000 ) + hb_parni(6) + zw , 
	yOffset + ( GetDeviceCaps( (HDC) hb_parnl(3) , VERTSIZE) * hb_parni(4) / 10000 ) + hb_parni(7) + zh  
	) ;

	FillRect( (HDC) hDC , &rct , (HBRUSH) ( RGB(255,255,255) ) ) ;

	PlayEnhMetaFile(hDC, hemf, &rct); 

	// Remove prints outside printable area

	// Right
	aux.top = 0 ;
	aux.left = rct.right ;	
	aux.right =  ClientWidth ;
	aux.bottom = ClientHeight ;
	FillRect( (HDC) hDC , &aux , (HBRUSH) GetStockObject(GRAY_BRUSH	) ) ;

	// Bottom
	aux.top = rct.bottom ;
	aux.left = 0 ;	
	aux.right =  ClientWidth ;
	aux.bottom = ClientHeight ;
	FillRect( (HDC) hDC , &aux , (HBRUSH) GetStockObject(GRAY_BRUSH	) ) ;

	// Top
	aux.top = 0 ;
	aux.left = 0 ;	
	aux.right =  ClientWidth ;
	aux.bottom = yOffset + hb_parni(7) - zh ;
	FillRect( (HDC) hDC , &aux , (HBRUSH) GetStockObject(GRAY_BRUSH	) ) ;

	// Left
	aux.top = 0 ;
	aux.left = 0 ;	
	aux.right = xOffset + hb_parni(6) - zw ;
	aux.bottom = ClientHeight ;
	FillRect( (HDC) hDC , &aux , (HBRUSH) GetStockObject(GRAY_BRUSH	) ) ;

	//
 
	DeleteEnhMetaFile(hemf); 

	ReleaseDC(hWnd, hDC); 

} 

HB_FUNC ( _HMG_PRINTER_GETPAGEWIDTH )
{
	hb_retni ( GetDeviceCaps( (HDC) hb_parnl(1) , HORZSIZE ) ) ;
} 

HB_FUNC ( _HMG_PRINTER_GETPAGEHEIGHT )
{
	hb_retni ( GetDeviceCaps( (HDC) hb_parnl(1) , VERTSIZE ) ) ;
} 

HB_FUNC ( _HMG_PRINTER_PRINTPAGE )
{
	
	HENHMETAFILE hemf ;

	RECT rect ;

	hemf = GetEnhMetaFile( hb_parc(2) ) ; 

	SetRect(&rect,0,0,GetDeviceCaps((HDC) hb_parnl(1), HORZRES),GetDeviceCaps((HDC) hb_parnl(1), VERTRES));

	StartPage((HDC) hb_parnl(1));

	PlayEnhMetaFile((HDC) hb_parnl(1) , (HENHMETAFILE) hemf , &rect ) ;

	EndPage((HDC) hb_parnl(1));

	DeleteEnhMetaFile(hemf); 

}


HB_FUNC ( _HMG_PRINTER_PREVIEW_ENABLESCROLLBARS )
{
	EnableScrollBar( (HWND) hb_parnl(1) , SB_BOTH , ESB_ENABLE_BOTH	 ) ;
}

HB_FUNC ( _HMG_PRINTER_PREVIEW_DISABLESCROLLBARS )
{
	EnableScrollBar( (HWND) hb_parnl(1) , SB_BOTH , ESB_DISABLE_BOTH ) ;
}

HB_FUNC ( _HMG_PRINTER_PREVIEW_DISABLEHSCROLLBAR )
{
	EnableScrollBar( (HWND) hb_parnl(1) , SB_HORZ , ESB_DISABLE_BOTH ) ;
}

HB_FUNC ( _HMG_PRINTER_SETVSCROLLVALUE )
{

	SendMessage ( (HWND) hb_parnl(1) , WM_VSCROLL , MAKEWPARAM (SB_THUMBPOSITION , hb_parni(2) ) , 0 ) ;

}

HB_FUNC ( _HMG_PRINTER_GETPRINTERWIDTH )
{
	HDC hdc = (HDC) hb_parnl(1) ;
	hb_retnl ( GetDeviceCaps ( hdc , HORZSIZE ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTERHEIGHT )
{
	HDC hdc = (HDC) hb_parnl(1) ;
	hb_retnl ( GetDeviceCaps ( hdc , VERTSIZE ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETX )
{
	HDC hdc = (HDC) hb_parni(1) ;
	hb_retnl ( GetDeviceCaps ( hdc , PHYSICALOFFSETX ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSX )
{
	HDC hdc = (HDC) hb_parni(1) ;
	hb_retnl ( GetDeviceCaps ( hdc , LOGPIXELSX ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTABLEAREAPHYSICALOFFSETY )
{
	HDC hdc = (HDC) hb_parni(1) ;
	hb_retnl ( GetDeviceCaps ( hdc , PHYSICALOFFSETY ) ) ;
}

HB_FUNC ( _HMG_PRINTER_GETPRINTABLEAREALOGPIXELSY )
{
	HDC hdc = (HDC) hb_parni(1) ;
	hb_retnl ( GetDeviceCaps ( hdc , LOGPIXELSY ) ) ;
}

HB_FUNC ( _HMG_PRINTER_C_IMAGE )
{

	// 1: hDC
	// 2: Image File
	// 3: Row
	// 4: Col
	// 5: Height
	// 6: Width
	// 7: Stretch

	HRGN hrgn ;

	HDC hdcPrint = (HDC) hb_parnl(1) ;
	IStream *iStream ;
	IPicture *iPicture ;
	HGLOBAL hGlobal ;
	HANDLE hFile ;
	DWORD nFileSize ;
	DWORD nReadByte ;
	long lWidth ;
	long lHeight ;
	POINT lpp ;
	HRSRC hSource ;
	HGLOBAL hGlobalres ;
	LPVOID lpVoid ;
	int nSize ;
	HINSTANCE hinstance = GetModuleHandle ( NULL ) ;
	HBITMAP hbmp ;
	PICTDESC picd;

	int r = hb_parni(3) ; 
	int c = hb_parni(4) ; 
	int odr = hb_parni(5) ; // Height
	int odc = hb_parni(6) ; // Width
	int dr ;
	int dc ;

	if ( hdcPrint != 0 )
	{

		c = ( c * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETX ) ;
		r = ( r * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) - GetDeviceCaps ( hdcPrint , PHYSICALOFFSETY ) ;
		dc = ( odc * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 ) ; 
		dr = ( odr * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 ) ; 

		hFile = CreateFile(hb_parc(2), GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

		if (hFile == INVALID_HANDLE_VALUE)
		{

			hbmp = LoadImage(GetModuleHandle(NULL),hb_parc(2),IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION);
			if (hbmp!=NULL)
			{
				picd.cbSizeofstruct=sizeof(PICTDESC);
				picd.picType=PICTYPE_BITMAP;
				picd.bmp.hbitmap=hbmp;
				OleCreatePictureIndirect(&picd,&IID_IPicture,TRUE,(LPVOID *)&iPicture);
			}
			else
			{
				hSource = FindResource(hinstance,hb_parc(2),"GIF");
				if ( hSource == 0 )
				{
					hSource = FindResource( hinstance , hb_parc(2) , "JPG" ) ;
				}
				if ( hSource == 0 ) 
				{
					return ;
				}
        
				hGlobalres = LoadResource(hinstance, hSource);

				if ( hGlobalres == 0 ) 
				{
					return ;
				}

				lpVoid = LockResource ( hGlobalres ) ;

				if ( lpVoid == 0 ) 
				{
					return ;
				}

				nSize = SizeofResource ( hinstance , hSource ) ;

				hGlobal = GlobalAlloc ( GPTR, nSize ) ;

				if ( hGlobal == 0 ) 
				{
					return ;
				}

				memcpy ( hGlobal , lpVoid , nSize ) ;

				FreeResource ( hGlobalres ) ;

				CreateStreamOnHGlobal ( hGlobal , TRUE, &iStream ) ;

				if ( iStream == 0 )
				{
					GlobalFree ( hGlobal ) ;
					return ;
				}

				OleLoadPicture ( iStream , nSize , TRUE , &IID_IPicture , (LPVOID *)&iPicture ) ;

				iStream->lpVtbl->Release(iStream);

			}
		}
		else
		{
			nFileSize = GetFileSize ( hFile , NULL ) ;
			hGlobal = GlobalAlloc ( GPTR , nFileSize ) ;
			ReadFile ( hFile , hGlobal , nFileSize , &nReadByte, NULL ) ;
			CloseHandle ( hFile ) ;
			CreateStreamOnHGlobal ( hGlobal , TRUE , &iStream ) ;
			OleLoadPicture ( iStream , nFileSize , TRUE , &IID_IPicture , (LPVOID*)&iPicture ) ;

			if ( iPicture == 0 )
			{
				return;
			}
		}

		iPicture->lpVtbl->get_Width(iPicture,&lWidth);
		iPicture->lpVtbl->get_Height(iPicture,&lHeight);

		if ( ! hb_parl(7) ) // Scale
		{

			if ( odr * lHeight / lWidth <= odr )
			{
				dr = odc * GetDeviceCaps ( hdcPrint , LOGPIXELSY ) / 1000 * lHeight / lWidth ;
			}
			else
			{
				dc = odr * GetDeviceCaps ( hdcPrint , LOGPIXELSX ) / 1000 * lWidth / lHeight ;
			}

		}

		GetViewportOrgEx ( hdcPrint , &lpp ) ;

		hrgn = CreateRectRgn(	c + lpp.x , 
					r + lpp.y ,
					c + dc + lpp.x - 1 , 
					r + dr + lpp.y - 1 
					) ;

		SelectClipRgn( hdcPrint , hrgn ) ;

		iPicture->lpVtbl->Render( 	iPicture , 
						hdcPrint , 
						c , 
						r , 
						dc , 
						dr , 
						0 , 
						lHeight , 
						lWidth , 
						-lHeight , 
						NULL ) ;

		SelectClipRgn(hdcPrint,NULL);

		iPicture->lpVtbl->Release(iPicture);

		GlobalFree(hGlobal);

	}
}

#pragma ENDDUMP

