/*
 * $Id: h_monthcal.prg,v 1.24 2017-10-01 15:52:26 fyurisich Exp $
 */
/*
 * ooHG source code:
 * MonthCal and MonthCalMulti controls
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
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
 * along with this software; see the file COPYING.  If not, write to
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


#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TMonthCal FROM TControl
   DATA Type                      INIT "MONTHCAL" READONLY
   DATA OnViewChange              INIT Nil
   DATA aBoldDays                 INIT {}

   METHOD Define
   METHOD Value                   SETGET
   METHOD SetFont
   METHOD Events_Notify
   METHOD FontColor               SETGET
   METHOD BackColor               SETGET
   METHOD TitleFontColor          SETGET
   METHOD TitleBackColor          SETGET
   METHOD TrailingFontColor       SETGET
   METHOD BackgroundColor         SETGET
   METHOD SetRange
   METHOD Define2
   METHOD CurrentView             SETGET
   METHOD Events
   METHOD Width                   SETGET
   METHOD Height                  SETGET
   METHOD AddBoldDay
   METHOD DelBoldDay
   METHOD IsBoldDay               BLOCK { |Self, dDay| aScan( ::aBoldDays, dDay ) > 0 }

   /* HB_SYMBOL_UNUSED( _OOHG_AllVars ) */
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, notoday, notodaycircle, weeknumbers, ;
               change, HelpId, invisible, notabstop, bold, italic, ;
               underline, strikeout, lRtl, lDisabled, fontcolor, backcolor, ;
               titlefontcolor, titlebackcolor, trailingfontcolor, ;
               backgroundcolor, viewchg, gotfocus, lostfocus ) CLASS TMonthCal
*------------------------------------------------------------------------------*

   ::Define2( ControlName, ParentForm, x, y, w, h, value, fontname, ;
              fontsize, tooltip, notoday, notodaycircle, weeknumbers, ;
              change, HelpId, invisible, notabstop, bold, italic, ;
              underline, strikeout, lRtl, lDisabled, fontcolor, backcolor, ;
              titlefontcolor, titlebackcolor, trailingfontcolor, ;
              backgroundcolor, viewchg, 0, gotfocus, lostfocus )

Return Self

*------------------------------------------------------------------------------*
METHOD Define2( ControlName, ParentForm, x, y, w, h, value, fontname, ;
                fontsize, tooltip, notoday, notodaycircle, weeknumbers, ;
                change, HelpId, invisible, notabstop, bold, italic, ;
                underline, strikeout, lRtl, lDisabled, fontcolor, backcolor, ;
                titlefontcolor, titlebackcolor, trailingfontcolor, ;
                backgroundcolor, viewchg, nStyle, gotfocus, lostfocus ) CLASS TMonthCal
*------------------------------------------------------------------------------*
Local ControlHandle

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   If ! HB_IsDate( value )
      value := DATE()
   EndIf

   ::SetForm( ControlName, ParentForm, FontName, FontSize,,,, lRtl )

   nStyle += ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + MCS_DAYSTATE + ;
             IF( HB_IsLogical( notoday )       .AND. notoday,       MCS_NOTODAY,       0 ) + ;
             IF( HB_IsLogical( notodaycircle ) .AND. notodaycircle, MCS_NOTODAYCIRCLE, 0 ) + ;
             IF( HB_IsLogical( weeknumbers )   .AND. weeknumbers,   MCS_WEEKNUMBERS,   0 )

   ControlHandle := InitMonthCal( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::nWidth, ::nHeight, nStyle, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId,, ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )
   ::FontColor         := fontcolor
   ::BackColor         := backcolor
   ::TitleFontColor    := titlefontcolor
   ::TitleBackColor    := titlebackcolor
   ::TrailingFontColor := trailingfontcolor
   ::BackgroundColor   := backgroundcolor

   ::Value             := value
   SetDayState( Self )

   ASSIGN ::OnChange     VALUE change    TYPE "B"
   ASSIGN ::OnViewChange VALUE viewchg   TYPE "B"
   ASSIGN ::OnGotFocus   VALUE gotfocus  TYPE "B"
   ASSIGN ::OnLostFocus  VALUE lostfocus TYPE "B"

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TMonthCal
*------------------------------------------------------------------------------*

   IF ValType( uValue ) == "D"
      SetMonthCal( ::hWnd, uValue )
   ENDIF

Return GetMonthCalDate( ::hWnd )

*------------------------------------------------------------------------------*
METHOD SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout ) CLASS TMonthCal
*------------------------------------------------------------------------------*
Local uRet

   uRet := ::Super:SetFont( FontName, FontSize, Bold, Italic, Underline, Strikeout )
   AdjustMonthCalSize( ::hWnd, ::ContainerCol, ::ContainerRow )
   ::SizePos( , , GetWindowWidth( ::hWnd ), GetWindowHeight( ::hWnd ) )

Return uRet

*------------------------------------------------------------------------------*
METHOD Events_Notify( wParam, lParam ) CLASS TMonthCal
*------------------------------------------------------------------------------*
Local nNotify := GetNotifyCode( lParam )

   If nNotify == MCN_SELECT
      ::DoChange()
      Return Nil

   ElseIf nNotify == MCN_SELCHANGE
      ::DoChange()
      Return Nil

   ElseIf nNotify == MCN_VIEWCHANGE
      ::DoEvent( ::OnViewChange, "VIEWCHANGE", GetViewChangeData( lParam ) )
      Return Nil

   ElseIF nNotify == MCN_GETDAYSTATE
      RetDayState( Self, lParam )

   EndIf

Return ::Super:Events_Notify( wParam, lParam )

*------------------------------------------------------------------------------*
METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TMonthCal
*------------------------------------------------------------------------------*

   If nMsg == WM_MOUSEACTIVATE
      ::SetFocus()
      Return 1

   ElseIf nMsg == WM_SETFOCUS
      GetFormObjectByHandle( ::ContainerhWnd ):LastFocusedControl := ::hWnd
      ::FocusEffect()
      ::DoEvent( ::OnGotFocus, "GOTFOCUS" )

   ElseIf nMsg == WM_KILLFOCUS
      Return ::DoLostFocus()

   EndIf

Return ::Super:Events( hWnd, nMsg, wParam, lParam )

*------------------------------------------------------------------------------*
METHOD CurrentView( nView ) CLASS TMonthCal
*------------------------------------------------------------------------------*

   /*
   nView valid values are:
   #define   MCMV_MONTH     0   // days in a month
   #define   MCMV_YEAR      1   // month in a year
   #define   MCMV_DECADE    2   // years in a decade
   #define   MCMV_CENTURY   3   // decades in a century

   Note that changing the current view in a MULTISELECT control,
   from MCMV_MONTH to another view, generates a change in the
   control's value. The previous value is lost and a new range
   is set: for MCMV_YEAR the last days of the month are set,
   for MCMV_DECADE the last days of the year are set and for
   MCMV_CENTURY the last days of the decade are set.
   */
   IF HB_IsNumeric( nView )
      SendMessage( ::hWnd, MCM_SETCURRENTVIEW, 0, nView )
   ENDIF

Return SendMessage( ::hWnd, MCM_GETCURRENTVIEW, 0, 0 )

*------------------------------------------------------------------------------*
METHOD Width( nWidth ) CLASS TMonthCal
*------------------------------------------------------------------------------*

   IF HB_IsNumeric( nWidth )
      AdjustMonthCalSize( ::hWnd, ::ContainerCol, ::ContainerRow )
      ::SizePos( , , GetWindowWidth( ::hWnd ), GetWindowHeight( ::hWnd ) )
   EndIf

Return ::nWidth

*------------------------------------------------------------------------------*
METHOD Height( nHeight ) CLASS TMonthCal
*------------------------------------------------------------------------------*

   IF HB_IsNumeric( nHeight )
      AdjustMonthCalSize( ::hWnd, ::ContainerCol, ::ContainerRow )
      ::SizePos( , , GetWindowWidth( ::hWnd ), GetWindowHeight( ::hWnd ) )
   EndIf

Return ::nHeight

*------------------------------------------------------------------------------*
METHOD AddBoldDay( dDay ) CLASS TMonthCal
*------------------------------------------------------------------------------*
Local i

   i := aScan( ::aBoldDays, { |d| d >= dDay } )
   IF i == 0
      aAdd( ::aBoldDays, dDay )
      SetDayState( Self )
   ELSEIF ::aBoldDays[ i ] > dDay
      aSize( ::aBoldDays, Len( ::aBoldDays ) + 1 )
      aIns( ::aBoldDays, i )
      ::aBoldDays[ i ] := dDay
      SetDayState( Self )
   ENDIF

Return Nil

*------------------------------------------------------------------------------*
METHOD DelBoldDay( dDay ) CLASS TMonthCal
*------------------------------------------------------------------------------*
Local i

   i := aScan( ::aBoldDays, dDay )
   IF i > 0
      aDel( ::aBoldDays, i )
      aSize( ::aBoldDays, Len( ::aBoldDays ) - 1 )
      SetDayState( Self )
   ENDIF

Return Nil





CLASS TMonthCalMulti FROM TMonthCal
   DATA Type                      INIT "MONTHCALMULTI" READONLY

   METHOD Define
   METHOD DoChange
   METHOD MaxSelCount             SETGET
   METHOD Value                   SETGET
ENDCLASS

*------------------------------------------------------------------------------*
METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, notoday, notodaycircle, weeknumbers, ;
               change, HelpId, invisible, notabstop, bold, italic, ;
               underline, strikeout, lRtl, lDisabled, fontcolor, backcolor, ;
               titlefontcolor, titlebackcolor, trailingfontcolor, ;
               backgroundcolor, viewchg, gotfocus, lostfocus ) CLASS TMonthCalMulti
*------------------------------------------------------------------------------*

   ::Define2( ControlName, ParentForm, x, y, w, h, value, fontname, ;
              fontsize, tooltip, notoday, notodaycircle, weeknumbers, ;
              change, HelpId, invisible, notabstop, bold, italic, ;
              underline, strikeout, lRtl, lDisabled, fontcolor, backcolor, ;
              titlefontcolor, titlebackcolor, trailingfontcolor, ;
              backgroundcolor, viewchg, MCS_MULTISELECT, gotfocus, lostfocus )

Return Self

*------------------------------------------------------------------------------*
METHOD MaxSelCount( nMax ) CLASS TMonthCalMulti
*------------------------------------------------------------------------------*

   IF HB_IsNumeric( nMax )
      SendMessage( ::hWnd, MCM_SETMAXSELCOUNT, nMax, 0 )
   ENDIF

Return SendMessage( ::hWnd, MCM_GETMAXSELCOUNT, 0, 0 )

*------------------------------------------------------------------------------*
METHOD DoChange() CLASS TMonthCalMulti
*------------------------------------------------------------------------------*
Local xValue, cType, cOldType

   xValue   := ::Value
   cType    := ValType( xValue )
   cOldType := ValType( ::xOldValue )
   cType    := If( cType == "M", "C", cType )
   cOldType := If( cOldType == "M", "C", cOldType )
   If ( cOldType == "U" .OR. ! cType == cOldType .OR. ;
        ( HB_IsArray( xValue ) .AND. ! HB_IsArray( ::xOldValue ) ) .OR. ;
        ( ! HB_IsArray( xValue ) .AND. HB_IsArray( ::xOldValue ) ) .OR. ;
        ! aEqual( xValue, ::xOldValue ) )
      ::xOldValue := xValue
      ::DoEvent( ::OnChange, "CHANGE" )
   EndIf

Return Self

*------------------------------------------------------------------------------*
METHOD Value( uValue ) CLASS TMonthCalMulti
*------------------------------------------------------------------------------*

   IF HB_IsArray( uValue ) .AND. Len( uValue ) > 1 .AND. HB_IsDate( uValue[ 1 ] ) .AND. HB_IsDate( uValue[ 2 ] )
      SetMonthCalRange( ::hWnd, uValue[ 1 ], uValue[ 2 ] )
   ENDIF

Return GetMonthCalRange( ::hWnd )





*------------------------------------------------------------------------------*
FUNCTION SetDayState( Self )
*------------------------------------------------------------------------------*
Local aData, nCount, aDays, dStart, iNextD, dEnd, dEoM, nMonth, dDay, nLen

   aData  := GetMonthRange( ::hWnd )
   nCount := aData[ 1 ]
   IF nCount < 1
      Return Nil
   ENDIF

   aDays := Array( nCount * 32 )
   aFill( aDays, 0 )

   dStart := aData[ 2 ]
   iNextD := aScan( ::aBoldDays, { |d| d >= dStart } )

   IF iNextD > 0
      dEnd   := aData[ 3 ]
      dEoM   := EoM( dStart )
      nMonth := 0
      dDay   := ::aBoldDays[ iNextD ]
      nLen   := Len( ::aBoldDays )

      DO WHILE dDay <= dEnd
         IF dDay <= dEoM
            aDays[ nMonth * 32 + Day( dDay ) ] := 1
            iNextD ++
            IF iNextD > nLen
               EXIT
            ENDIF
            dDay := ::aBoldDays[ iNextD ]
         ELSE
            nMonth ++
            dEoM := EoM( dEoM + 1 )
         ENDIF
      ENDDO
   ENDIF

   C_SETDAYSTATE( ::hWnd, nCount, aDays )

Return Nil

*------------------------------------------------------------------------------*
FUNCTION RetDayState( Self, lParam )
*------------------------------------------------------------------------------*
Local aData, nCount, aDays, dStart, iNextD, dEoM, nMonth, dDay, nLen

   aData  := GetDayStateData( lParam )
   nCount := aData[ 1 ]
   IF nCount < 1
      Return Nil
   ENDIF

   aDays := Array( nCount * 32 )
   aFill( aDays, 0 )

   dStart := aData[ 2 ]
   iNextD := aScan( ::aBoldDays, { |d| d >= dStart } )

   IF iNextD > 0
      dEoM   := EoM( dStart )
      nMonth := 0
      dDay   := ::aBoldDays[ iNextD ]
      nLen   := Len( ::aBoldDays )

      DO WHILE nMonth < nCount
         IF dDay <= dEoM
            aDays[ nMonth * 32 + Day( dDay ) ] := 1
            iNextD ++
            IF iNextD > nLen
               EXIT
            ENDIF
            dDay := ::aBoldDays[ iNextD ]
         ELSE
            nMonth ++
            dEoM := EoM( dEoM + 1 )
         ENDIF
      ENDDO
   ENDIF

   C_RETDAYSTATE( lParam, nCount, aDays )

Return Nil





#pragma BEGINDUMP

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
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

#include <shlobj.h>

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "hbdate.h"
#include "winreg.h"
#include "tchar.h"
#include "oohg.h"

static WNDPROC lpfnOldWndProc = 0;

static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, lpfnOldWndProc );
}

HB_FUNC( INITMONTHCAL )
{
   HWND hwnd;
   HWND hmonthcal;
   INITCOMMONCONTROLSEX icex;
   int Style, StyleEx;

   icex.dwSize = sizeof( icex );
   icex.dwICC  = ICC_DATE_CLASSES;
   InitCommonControlsEx( &icex );

   hwnd = HWNDparam( 1 );

   StyleEx = _OOHG_RTL_Status( hb_parl( 8 ) );

   Style = hb_parni( 7 ) | WS_BORDER | WS_CHILD;

   hmonthcal = CreateWindowEx( StyleEx, MONTHCAL_CLASS, "", Style,
                               hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                               hwnd, HMENUparam( 2 ), GetModuleHandle( NULL ), NULL ) ;

   lpfnOldWndProc = (WNDPROC) SetWindowLong( (HWND) hmonthcal, GWL_WNDPROC, (LONG) SubClassFunc );

   HWNDret( hmonthcal );
}

HB_FUNC( ADJUSTMONTHCALSIZE )
{
   HWND hWnd = HWNDparam( 1 );
   RECT rMin;
   int iToday;

   if( ( GetWindowLong( hWnd, GWL_STYLE ) & MCS_NOTODAY ) == MCS_NOTODAY )
   {
      iToday = 0;
   }
   else
   {
      iToday = SendMessage( hWnd, MCM_GETMAXTODAYWIDTH, 0, 0 );
   }

   MonthCal_GetMinReqRect( hWnd, &rMin );

   if( rMin.right < iToday )
   {
      rMin.right = iToday;
   }

   SetWindowPos( hWnd, NULL, hb_parni( 2 ), hb_parni( 3 ), rMin.right, rMin.bottom, SWP_NOZORDER );
}

HB_FUNC( SETMONTHCAL )
{
   SYSTEMTIME sysTime;
   char *cDate;

   if( HB_ISDATE( 2 ) )
   {
      cDate = (char *) hb_pards( 2 );
      if( ! ( cDate[ 0 ] == ' ' ) )
      {
         memset( &sysTime, 0, sizeof( sysTime ) );
         sysTime.wYear  = (WORD) ( ( ( (int) cDate[ 0 ] - '0' ) * 1000 ) +
                                   ( ( (int) cDate[ 1 ] - '0' ) * 100 )  +
                                   ( ( (int) cDate[ 2 ] - '0' ) * 10 ) + ( (int) cDate[ 3 ] - '0' ) );
         sysTime.wMonth = (WORD) ( ( ( (int) cDate[ 4 ] - '0' ) * 10 ) + ( (int) cDate[ 5 ] - '0' ) );
         sysTime.wDay   = (WORD) ( ( ( (int) cDate[ 6 ] - '0' ) * 10 ) + ( (int) cDate[ 7 ] - '0' ) );

         MonthCal_SetCurSel( HWNDparam( 1 ), &sysTime );
      }
   }
}

HB_FUNC( GETMONTHCALDATE )
{
   SYSTEMTIME st;

   SendMessage( HWNDparam( 1 ), MCM_GETCURSEL, 0, (LPARAM) &st );

   hb_retd( st.wYear, st.wMonth, st.wDay );
}

HB_FUNC( GETMONTHCALFIRSTDAYOFWEEK )
{
   hb_retni( LOWORD( SendMessage( HWNDparam( 1 ), MCM_GETFIRSTDAYOFWEEK, 0, 0 ) ) );
}

HB_FUNC( SETMONTHCALFIRSTDAYOFWEEK )
{
   SendMessage( HWNDparam( 1 ), MCM_SETFIRSTDAYOFWEEK, 0, hb_parni( 2 ) );
}

HB_FUNC_STATIC( TMONTHCAL_FONTCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lColor;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( oSelf->lFontColor != -1 )
         {
            MonthCal_SetColor( oSelf->hWnd, MCSC_TEXT, (COLORREF) oSelf->lFontColor );
         }
         // else
         // {
         //    ListView_SetTextColor( oSelf->hWnd, GetSysColor( COLOR_WINDOWTEXT ) );
         // }
         // RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   lColor = (LONG) MonthCal_GetColor( oSelf->hWnd, MCSC_TEXT );
   hb_reta( 3 );
   HB_STORNL( GetRValue( lColor ), -1, 1 );
   HB_STORNL( GetGValue( lColor ), -1, 2 );
   HB_STORNL( GetBValue( lColor ), -1, 3 );
}

HB_FUNC_STATIC( TMONTHCAL_BACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lColor;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( oSelf->lBackColor != -1 )
         {
            MonthCal_SetColor( oSelf->hWnd, MCSC_MONTHBK, (COLORREF) oSelf->lBackColor );
         }
         // else
         // {
         //    ListView_SetTextColor( oSelf->hWnd, GetSysColor( COLOR_WINDOWTEXT ) );
         // }
         // RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   lColor = (LONG) MonthCal_GetColor( oSelf->hWnd, MCSC_MONTHBK );
   hb_reta( 3 );
   HB_STORNL( GetRValue( lColor ), -1, 1 );
   HB_STORNL( GetGValue( lColor ), -1, 2 );
   HB_STORNL( GetBValue( lColor ), -1, 3 );
}

HB_FUNC_STATIC( TMONTHCAL_TITLEFONTCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lColor;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &lColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( lColor != -1 )
         {
            MonthCal_SetColor( oSelf->hWnd, MCSC_TITLETEXT, (COLORREF) lColor );
         }
         // else
         // {
         //    ListView_SetTextColor( oSelf->hWnd, GetSysColor( COLOR_WINDOWTEXT ) );
         // }
         // RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   lColor = (LONG) MonthCal_GetColor( oSelf->hWnd, MCSC_TITLETEXT );
   hb_reta( 3 );
   HB_STORNL( GetRValue( lColor ), -1, 1 );
   HB_STORNL( GetGValue( lColor ), -1, 2 );
   HB_STORNL( GetBValue( lColor ), -1, 3 );
}

HB_FUNC_STATIC( TMONTHCAL_TITLEBACKCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lColor;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &lColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( lColor != -1 )
         {
            MonthCal_SetColor( oSelf->hWnd, MCSC_TITLEBK, (COLORREF) lColor );
         }
         // else
         // {
         //    ListView_SetTextColor( oSelf->hWnd, GetSysColor( COLOR_WINDOWTEXT ) );
         // }
         // RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   lColor = (LONG) MonthCal_GetColor( oSelf->hWnd, MCSC_TITLEBK );
   hb_reta( 3 );
   HB_STORNL( GetRValue( lColor ), -1, 1 );
   HB_STORNL( GetGValue( lColor ), -1, 2 );
   HB_STORNL( GetBValue( lColor ), -1, 3 );
}

HB_FUNC_STATIC( TMONTHCAL_TRAILINGFONTCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lColor;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &lColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( lColor != -1 )
         {
            MonthCal_SetColor( oSelf->hWnd, MCSC_TRAILINGTEXT, (COLORREF) lColor );
         }
         // else
         // {
         //    ListView_SetTextColor( oSelf->hWnd, GetSysColor( COLOR_WINDOWTEXT ) );
         // }
         // RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   lColor = (LONG) MonthCal_GetColor( oSelf->hWnd, MCSC_TRAILINGTEXT );
   hb_reta( 3 );
   HB_STORNL( GetRValue( lColor ), -1, 1 );
   HB_STORNL( GetGValue( lColor ), -1, 2 );
   HB_STORNL( GetBValue( lColor ), -1, 3 );
}

HB_FUNC_STATIC( TMONTHCAL_BACKGROUNDCOLOR )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LONG lColor;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &lColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( lColor != -1 )
         {
            MonthCal_SetColor( oSelf->hWnd, MCSC_BACKGROUND, (COLORREF) lColor );
         }
         // else
         // {
         //    ListView_SetTextColor( oSelf->hWnd, GetSysColor( COLOR_WINDOWTEXT ) );
         // }
         // RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   lColor = (LONG) MonthCal_GetColor( oSelf->hWnd, MCSC_BACKGROUND );
   hb_reta( 3 );
   HB_STORNL( GetRValue( lColor ), -1, 1 );
   HB_STORNL( GetGValue( lColor ), -1, 2 );
   HB_STORNL( GetBValue( lColor ), -1, 3 );
}

HB_FUNC_STATIC( TMONTHCAL_SETRANGE )
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   SYSTEMTIME sysTime[ 2 ];
   char *cDate;
   WPARAM wLimit = 0;

   if( HB_ISDATE( 1 ) && HB_ISDATE( 2 ) )
   {
      memset( &sysTime, 0, sizeof( sysTime ) );

      cDate = (char *) hb_pards( 1 );
      if( ! ( cDate[ 0 ] == ' ' ) )
      {
         sysTime[ 0 ].wYear  = (WORD) ( ( ( (int) cDate[ 0 ] - '0' ) * 1000 ) +
                                        ( ( (int) cDate[ 1 ] - '0' ) * 100 )  +
                                        ( ( (int) cDate[ 2 ] - '0' ) * 10 ) + ( (int) cDate[ 3 ] - '0' ) );
         sysTime[ 0 ].wMonth = (WORD) ( ( ( (int) cDate[ 4 ] - '0' ) * 10 ) + ( (int) cDate[ 5 ] - '0' ) );
         sysTime[ 0 ].wDay   = (WORD) ( ( ( (int) cDate[ 6 ] - '0' ) * 10 ) + ( (int) cDate[ 7 ] - '0' ) );
         wLimit |= GDTR_MIN;
      }

      cDate = ( char * ) hb_pards( 2 );
      if( ! ( cDate[ 0 ] == ' ' ) )
      {
         sysTime[ 1 ].wYear  = (WORD) ( ( ( (int) cDate[ 0 ] - '0' ) * 1000 ) +
                                        ( ( (int) cDate[ 1 ] - '0' ) * 100 )  +
                                        ( ( (int) cDate[ 2 ] - '0' ) * 10 ) + ( (int) cDate[ 3 ] - '0' ) );
         sysTime[ 1 ].wMonth = (WORD) ( ( ( (int) cDate[ 4 ] - '0' ) * 10 ) + ( (int) cDate[ 5 ] - '0' ) );
         sysTime[ 1 ].wDay   = (WORD) ( ( ( (int) cDate[ 6 ] - '0' ) * 10 ) + ( (int) cDate[ 7 ] - '0' ) );
         wLimit |= GDTR_MAX;
      }

      SendMessage( oSelf->hWnd, MCM_SETRANGE, wLimit, (LPARAM) &sysTime );
   }
}

HB_FUNC( SETMONTHCALRANGE )
{
   SYSTEMTIME sysTime[ 2 ];
   char *cDate;

   if( HB_ISDATE( 2 ) && HB_ISDATE( 3 ) )
   {
      memset( &sysTime, 0, sizeof( sysTime ) );

      cDate = (char *) hb_pards( 2 );
      if( ! ( cDate[ 0 ] == ' ' ) )
      {
         sysTime[ 0 ].wYear  = (WORD) ( ( ( (int) cDate[ 0 ] - '0' ) * 1000 ) +
                                        ( ( (int) cDate[ 1 ] - '0' ) * 100 )  +
                                        ( ( (int) cDate[ 2 ] - '0' ) * 10 ) + ( (int) cDate[ 3 ] - '0' ) );
         sysTime[ 0 ].wMonth = (WORD) ( ( ( (int) cDate[ 4 ] - '0' ) * 10 ) + ( (int) cDate[ 5 ] - '0' ) );
         sysTime[ 0 ].wDay   = (WORD) ( ( ( (int) cDate[ 6 ] - '0' ) * 10 ) + ( (int) cDate[ 7 ] - '0' ) );
      }

      cDate = (char *) hb_pards( 3 );
      if( ! ( cDate[ 0 ] == ' ' ) )
      {
         sysTime[ 1 ].wYear  = (WORD) ( ( ( (int) cDate[ 0 ] - '0' ) * 1000 ) +
                                        ( ( (int) cDate[ 1 ] - '0' ) * 100 )  +
                                        ( ( (int) cDate[ 2 ] - '0' ) * 10 ) + ( (int) cDate[ 3 ] - '0' ) );
         sysTime[ 1 ].wMonth = (WORD) ( ( ( (int) cDate[ 4 ] - '0' ) * 10 ) + ( (int) cDate[ 5 ] - '0' ) );
         sysTime[ 1 ].wDay   = (WORD) ( ( ( (int) cDate[ 6 ] - '0' ) * 10 ) + ( (int) cDate[ 7 ] - '0' ) );
      }

      SendMessage( HWNDparam( 1 ), MCM_SETSELRANGE, 0, (LPARAM) &sysTime );
   }
}

HB_FUNC( GETMONTHCALRANGE )
{
   SYSTEMTIME sysTime[ 2 ];

   memset( &sysTime, 0, sizeof( sysTime ) );
   SendMessage( HWNDparam( 1 ), MCM_GETSELRANGE, 0, (LPARAM) &sysTime );

   hb_reta( 2 );
   HB_STORDL( hb_dateEncode( sysTime[ 0 ].wYear, sysTime[ 0 ].wMonth, sysTime[ 0 ].wDay ), -1, 1 );
   HB_STORDL( hb_dateEncode( sysTime[ 1 ].wYear, sysTime[ 1 ].wMonth, sysTime[ 1 ].wDay ), -1, 2 );
}

enum MonthCalendarView {
   MCMV_MONTH = 0,
   MCMV_YEAR = 1,
   MCMV_DECADE = 2,
   MCMV_CENTURY = 3,
   MCMV_MAX = MCMV_CENTURY
};

#ifndef MCN_VIEWCHANGE
   #define MCN_VIEWCHANGE (MCN_FIRST-4)

   typedef struct tagNMVIEWCHANGE {
     NMHDR nmhdr;
     DWORD dwOldView;
     DWORD dwNewView;
   } NMVIEWCHANGE, *LPNMVIEWCHANGE;
#endif

HB_FUNC( GETVIEWCHANGEDATA )
{
   LPNMVIEWCHANGE pData = (NMVIEWCHANGE *) hb_parnl( 1 );

   hb_reta( 2 );
   HB_STORNI( (int) pData->dwOldView, -1, 1 );
   HB_STORNI( (int) pData->dwNewView, -1, 2 );
}

HB_FUNC( GETMONTHRANGE )
{
   SYSTEMTIME sysTime[ 2 ];
   int iCount;

   memset( &sysTime, 0, sizeof( sysTime ) );
   iCount = SendMessage( HWNDparam( 1 ), MCM_GETMONTHRANGE, (WPARAM) GMR_DAYSTATE, (LPARAM) &sysTime );

   hb_reta( 3 );
   HB_STORNI( iCount, -1, 1 );
   HB_STORDL( hb_dateEncode( sysTime[ 0 ].wYear, sysTime[ 0 ].wMonth, sysTime[ 0 ].wDay ), -1, 2 );
   HB_STORDL( hb_dateEncode( sysTime[ 1 ].wYear, sysTime[ 1 ].wMonth, sysTime[ 1 ].wDay ), -1, 3 );
}

#ifndef BOLDDAY
   #define BOLDDAY( ds, iDay ) if( iDay > 0 && iDay < 32 )( ds ) |= ( 0x00000001 << ( iDay - 1 ) )
#endif

HB_FUNC( C_SETDAYSTATE )
{
   int i, j, iSize;
   LPMONTHDAYSTATE rgMonths;
   HWND hwnd = HWNDparam( 1 );
   int iCount = hb_parni( 2 );
   PHB_ITEM hArray = hb_param( 3, HB_IT_ARRAY );

   iSize = sizeof( MONTHDAYSTATE ) * iCount;
   rgMonths = (LPMONTHDAYSTATE) hb_xgrab( iSize );
   memset( rgMonths, 0, iSize );

   for( i = 0; i < iCount; i ++ )
   {
      for( j = 1; j <= 32; j ++ )
      {
         if( hb_arrayGetNI( hArray, i * 32 + j ) == 1 )
         {
            BOLDDAY( rgMonths[ i ], j );
         }
      }
   }

   SendMessage( hwnd, MCM_SETDAYSTATE, (WPARAM) iCount, (LPARAM) rgMonths );
   hb_xfree( rgMonths );
}

HB_FUNC( C_RETDAYSTATE )
{
   int i, j, iSize;
   LPMONTHDAYSTATE rgMonths;
   LPNMDAYSTATE pData = (NMDAYSTATE *) hb_parnl( 1 );
   int iCount = hb_parni( 2 );
   PHB_ITEM hArray = hb_param( 3, HB_IT_ARRAY );

   iSize = sizeof( MONTHDAYSTATE ) * iCount;
   rgMonths = (LPMONTHDAYSTATE) hb_xgrab( iSize );
   memset( rgMonths, 0, iSize );

   for( i = 0; i < iCount; i ++ )
   {
      for( j = 1; j <= 32; j ++ )
      {
         if( hb_arrayGetNI( hArray, i * 32 + j ) == 1 )
         {
            BOLDDAY( rgMonths[ i ], j );
         }
      }
   }

   pData->prgDayState = rgMonths;
   hb_xfree( rgMonths );
}

HB_FUNC( GETDAYSTATEDATA )
{
   LPNMDAYSTATE pData = (NMDAYSTATE *) hb_parnl( 1 );

   hb_reta( 2 );
   HB_STORNI( (int) pData->cDayState, -1, 1 );
   HB_STORDL( hb_dateEncode( pData->stStart.wYear, pData->stStart.wMonth, pData->stStart.wDay ), -1, 2 );
}

#pragma ENDDUMP
