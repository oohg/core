/*
 * $Id: h_datepicker.prg $
 */
/*
 * ooHG source code:
 * DatePicker and TimePicker controls
 *
 * Copyright 2005-2019 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
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


#include "oohg.ch"
#include "common.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

CLASS TDatePick FROM TControl

   DATA Type                      INIT "DATEPICK" READONLY
   DATA nWidth                    INIT 120
   DATA nHeight                   INIT 24
   DATA cDateFormat               INIT ""

   METHOD Define
   METHOD Value                   SETGET
   METHOD Events_Notify
   METHOD SetRange
   METHOD DateFormat              SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, change, lostfocus, gotfocus, shownone, ;
               updown, rightalign, HelpId, invisible, notabstop, bold, ;
               italic, underline, strikeout, Field, Enter, lRtl, lDisabled, ;
               lNoBorder, DateFrom, DateTo, cDateFormat, bValid ) CLASS TDatePick

   Local ControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t., lRtl )

   nStyle := ::InitStyle( , , Invisible, NoTabStop, lDisabled ) + ;
             IF( HB_IsLogical( shownone   ) .AND. shownone,    DTS_SHOWNONE,   0 ) + ;
             IF( HB_IsLogical( updown     ) .AND. updown,      DTS_UPDOWN,     0 ) + ;
             IF( HB_IsLogical( rightalign ) .AND. rightalign,  DTS_RIGHTALIGN, 0 )

   nStyleEx := IF( ! HB_IsLogical( lNoBorder ) .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

   ControlHandle := InitDatePick( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::SetRange( DateFrom, DateTo )

   ::SetVarBlock( Field, Value )

   IF HB_IsString( cDateFormat )
      ::DateFormat := cDateFormat
   ENDIF

   ASSIGN ::OnLostFocus VALUE lostfocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus  TYPE "B"
   ASSIGN ::OnChange    VALUE Change    TYPE "B"
   ASSIGN ::OnEnter     VALUE Enter     TYPE "B"
   ASSIGN ::postBlock   VALUE bValid    TYPE "B"

   Return Self

METHOD DateFormat( cDateFormat ) CLASS TDatePick

   Local lRes

   IF VALTYPE( cDateFormat ) == "C"
      // cDateFormat == "" means reset to default
      lRes := SetDatePickerDateFormat( ::hWnd, cDateFormat )
      IF lRes
         ::cDateFormat := cDateFormat
      ENDIF
   ENDIF

   Return ::cDateFormat

METHOD Value( uValue ) CLASS TDatePick

   IF HB_IsDate( uValue )
      IF EMPTY( uValue )
         SetDatePickNull( ::hWnd )
      ELSE
         SetDatePick( ::hWnd, uValue )
      ENDIF
      ::DoChange()
   ELSEIF PCOUNT() > 0
      SetDatePickNull( ::hWnd )
      ::DoChange()
   ENDIF

   Return GetDatePick( ::hWnd )

METHOD Events_Notify( wParam, lParam ) CLASS TDatePick

   Local nNotify := GetNotifyCode( lParam )

   IF nNotify == DTN_DATETIMECHANGE
      ::DoChange()
      Return nil

   ENDIF

   Return ::Super:Events_Notify( wParam, lParam )


CLASS TTimePick FROM TControl

   DATA Type                      INIT "TIMEPICK" READONLY
   DATA nWidth                    INIT 120
   DATA nHeight                   INIT 24
   DATA cTimeFormat               INIT ""

   METHOD Define
   METHOD Value                   SETGET
   METHOD Events_Notify
   METHOD TimeFormat              SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, x, y, w, h, value, fontname, ;
               fontsize, tooltip, change, lostfocus, gotfocus, shownone, ;
               updown, rightalign, HelpId, invisible, notabstop, bold, ;
               italic, underline, strikeout, Field, Enter, lRtl, lDisabled, ;
               lNoBorder, cTimeFormat, bValid ) CLASS TTimePick

   Local ControlHandle, nStyle, nStyleEx

   ASSIGN ::nCol    VALUE x TYPE "N"
   ASSIGN ::nRow    VALUE y TYPE "N"
   ASSIGN ::nWidth  VALUE w TYPE "N"
   ASSIGN ::nHeight VALUE h TYPE "N"

   ::SetForm( ControlName, ParentForm, FontName, FontSize, , , .t., lRtl )

   nStyle := ::InitStyle( , , Invisible, NoTabStop, lDisabled ) + ;
             IF( HB_IsLogical( shownone ) .AND. shownone, DTS_SHOWNONE, 0 )

   // Control always has DTS_UPDOWN style.
   // Control ignores DTS_RIGHTALIGN style.
   HB_SYMBOL_UNUSED( updown )
   HB_SYMBOL_UNUSED( rightalign )

   nStyleEx := IF( ! HB_IsLogical( lNoBorder ) .OR. ! lNoBorder, WS_EX_CLIENTEDGE, 0 )

   ControlHandle := InitTimePick( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, nStyleEx, ::lRtl )

   ::Register( ControlHandle, ControlName, HelpId, , ToolTip )
   ::SetFont( , , bold, italic, underline, strikeout )

   ::SetVarBlock( Field, Value )

   IF HB_IsString( cTimeFormat )
      ::TimeFormat := cTimeFormat
   ENDIF

   ASSIGN ::OnLostFocus VALUE lostfocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE gotfocus  TYPE "B"
   ASSIGN ::OnChange    VALUE Change    TYPE "B"
   ASSIGN ::OnEnter     VALUE Enter     TYPE "B"
   ASSIGN ::postBlock   VALUE bValid    TYPE "B"

   Return Self

METHOD TimeFormat( cTimeFormat ) CLASS TTimePick

   Local lRes

   IF VALTYPE( cTimeFormat ) == "C"
      // cTimeFormat == "" means reset to default
      lRes := SetDatePickerDateFormat( ::hWnd, cTimeFormat )
      IF lRes
         ::cTimeFormat := cTimeFormat
      ENDIF
   ENDIF

   Return ::cTimeFormat

METHOD Value( uValue ) CLASS TTimePick

   IF VALTYPE( uValue ) == "C"
      IF EMPTY( uValue ) .AND. IsWindowStyle( ::hWnd, DTS_SHOWNONE )
         SetDatePickNull( ::hWnd )
      ELSE
         SetTimePick( ::hWnd, VAL( LEFT( uValue, 2 ) ), VAL( SUBSTR( uValue, 4, 2 ) ), VAL( SUBSTR( uValue, 7, 2 ) ) )
      ENDIF
       ::DoChange()
   ELSEIF PCOUNT() > 0
      IF uValue == NIL .AND. IsWindowStyle( ::hWnd, DTS_SHOWNONE )
         SetDatePickNull( ::hWnd )
      ELSE
         SetTimePick( ::hWnd, VAL( LEFT( TIME(), 2 ) ), VAL( SUBSTR( TIME(), 4, 2 ) ), VAL( SUBSTR( TIME(), 7, 2) ) )
      ENDIF
       ::DoChange()
   ENDIF

   Return STRZERO( GetDatePickHour( ::hWnd ), 2 ) + ":" + STRZERO( GetDatePickMinute( ::hWnd ), 2 ) + ":" + STRZERO( GetDatePickSecond( ::hWnd ), 2 )

METHOD Events_Notify( wParam, lParam ) CLASS TTimePick

   Local nNotify := GetNotifyCode( lParam )

   IF nNotify == DTN_DATETIMECHANGE
      ::DoChange()
      Return Nil

   ENDIF

   Return ::Super:Events_Notify( wParam, lParam )


#pragma BEGINDUMP

#include "oohg.h"
#include <shlobj.h>
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "winreg.h"
#include "tchar.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TDatePick_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProcA = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProcA )
   {
      lpfnOldWndProcA = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProcA;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFuncA( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TDatePick_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITDATEPICK )          /* FUNCTION InitDatePick( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, nStyleEx, lRtl ) -> hWnd */
{
   HWND hCtrl;
   int Style, StyleEx;
   INITCOMMONCONTROLSEX i;

   Style   = hb_parni( 7 ) | WS_CHILD;
   StyleEx = hb_parni( 8 ) | _OOHG_RTL_Status( hb_parl( 9 ) );

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC = ICC_DATE_CLASSES;
   InitCommonControlsEx( &i );

   hCtrl = CreateWindowEx( StyleEx, "SysDateTimePick32", NULL, Style,
                           hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                           HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   _OOHG_TDatePick_lpfnOldWndProc( SetWindowLongPtr( hCtrl, GWLP_WNDPROC, (LONG_PTR) SubClassFuncA ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETDATEPICK )
{
   SYSTEMTIME sysTime;
   const char *cDate;

   memset( &sysTime, 0, sizeof( sysTime ) );

   cDate = hb_pards( 2 );
   if( ! ( cDate[ 0 ] == ' ' ) )
   {
      sysTime.wYear  = (WORD) ( ( ( cDate[ 0 ] - '0' ) * 1000 ) +
                                ( ( cDate[ 1 ] - '0' ) * 100 )  +
                                ( ( cDate[ 2 ] - '0' ) * 10 ) + ( cDate[ 3 ] - '0' ) );
      sysTime.wMonth = (WORD) ( ( ( cDate[ 4 ] - '0' ) * 10 ) + ( cDate[ 5 ] - '0' ) );
      sysTime.wDay   = (WORD) ( ( ( cDate[ 6 ] - '0' ) * 10 ) + ( cDate[ 7 ] - '0' ) );

      SendMessage( HWNDparam( 1 ), DTM_SETSYSTEMTIME, GDT_VALID, (LPARAM) &sysTime );
   }
}

HB_FUNC( GETDATEPICK )
{
   SYSTEMTIME st;

   SendMessage( HWNDparam( 1 ), DTM_GETSYSTEMTIME, 0, (LPARAM) &st );
   hb_retd( st.wYear, st.wMonth, st.wDay );
}

HB_FUNC( SETDATEPICKNULL )
{
   SendMessage( HWNDparam( 1 ), DTM_SETSYSTEMTIME, GDT_NONE, (LPARAM) 0 );
}

HB_FUNC_STATIC( TDATEPICK_SETRANGE )          /* METHOD SetRange( DateFrom, DateTo ) CLASS TDatePick */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   SYSTEMTIME sysTime[ 2 ];
   const char *cDate;
   WPARAM wLimit = 0;

   if( HB_ISDATE( 1 ) && HB_ISDATE( 2 ) )
   {
      memset( &sysTime, 0, sizeof( sysTime ) );

      cDate = hb_pards( 1 );
      if( ! ( cDate[ 0 ] == ' ' ) )
      {
         sysTime[ 0 ].wYear  = (WORD) ( ( ( cDate[ 0 ] - '0' ) * 1000 ) +
                                        ( ( cDate[ 1 ] - '0' ) * 100 )  +
                                        ( ( cDate[ 2 ] - '0' ) * 10 ) + ( cDate[ 3 ] - '0' ) );
         sysTime[ 0 ].wMonth = (WORD) ( ( ( cDate[ 4 ] - '0' ) * 10 ) + ( cDate[ 5 ] - '0' ) );
         sysTime[ 0 ].wDay   = (WORD) ( ( ( cDate[ 6 ] - '0' ) * 10 ) + ( cDate[ 7 ] - '0' ) );
         wLimit |= GDTR_MIN;
      }

      cDate = hb_pards( 2 );
      if( ! ( cDate[ 0 ] == ' ' ) )
      {
         sysTime[ 1 ].wYear  = (WORD) ( ( ( cDate[ 0 ] - '0' ) * 1000 ) +
                                        ( ( cDate[ 1 ] - '0' ) * 100 )  +
                                        ( ( cDate[ 2 ] - '0' ) * 10 ) + ( cDate[ 3 ] - '0' ) );
         sysTime[ 1 ].wMonth = (WORD) ( ( ( cDate[ 4 ] - '0' ) * 10 ) + ( cDate[ 5 ] - '0' ) );
         sysTime[ 1 ].wDay   = (WORD) ( ( ( cDate[ 6 ] - '0' ) * 10 ) + ( cDate[ 7 ] - '0' ) );
         wLimit |= GDTR_MAX;
      }

      SendMessage( oSelf->hWnd, DTM_SETRANGE, wLimit, (LPARAM) &sysTime );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TTimePick_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProcB = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProcB )
   {
      lpfnOldWndProcB = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProcB;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFuncB( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TTimePick_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITTIMEPICK )          /* FUNCTION InitTimePick( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, nStyleEx, lRtl ) -> hWnd */
{
   HWND hCtrl;
   int Style, StyleEx;
   INITCOMMONCONTROLSEX i;

   Style   = hb_parni( 7 ) | WS_CHILD | DTS_TIMEFORMAT | DTS_UPDOWN;
   StyleEx = hb_parni( 8 ) | _OOHG_RTL_Status( hb_parl( 9 ) );

   i.dwSize = sizeof( INITCOMMONCONTROLSEX );
   i.dwICC = ICC_DATE_CLASSES;
   InitCommonControlsEx( &i );

   hCtrl = CreateWindowEx( StyleEx, DATETIMEPICK_CLASS, NULL, Style,
                           hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                           HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

   _OOHG_TTimePick_lpfnOldWndProc( SetWindowLongPtr( hCtrl, GWLP_WNDPROC, (LONG_PTR) SubClassFuncB ) );

   HWNDret( hCtrl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETTIMEPICK )
{
   SYSTEMTIME sysTime;

   sysTime.wYear = 2005;
   sysTime.wMonth = 1;
   sysTime.wDay = 1;
   sysTime.wDayOfWeek = 0;

   sysTime.wHour   = (WORD) hb_parni( 2 );
   sysTime.wMinute = (WORD) hb_parni( 3 );
   sysTime.wSecond = (WORD) hb_parni( 4 );
   sysTime.wMilliseconds = 0;

   SendMessage( HWNDparam( 1 ), DTM_SETSYSTEMTIME, GDT_VALID, (LPARAM) &sysTime );
}

HB_FUNC( GETDATEPICKHOUR )
{
   SYSTEMTIME st;

   if( SendMessage( HWNDparam( 1 ), DTM_GETSYSTEMTIME, 0, (LPARAM) &st ) == GDT_VALID )
   {
      hb_retni( st.wHour );
   }
   else
   {
     hb_retni( -1 );
   }
}

HB_FUNC( GETDATEPICKMINUTE )
{
   SYSTEMTIME st;

   if( SendMessage( HWNDparam( 1 ), DTM_GETSYSTEMTIME, 0, (LPARAM) &st ) == GDT_VALID )
   {
      hb_retni( st.wMinute );
   }
   else
   {
     hb_retni( -1 );
   }
}

HB_FUNC( GETDATEPICKSECOND )
{
   SYSTEMTIME st;

   if( SendMessage( HWNDparam( 1 ), DTM_GETSYSTEMTIME, 0, (LPARAM) &st ) == GDT_VALID )
   {
      hb_retni( st.wSecond );
   }
   else
   {
      hb_retni( -1 );
   }
}

HB_FUNC( SETDATEPICKERDATEFORMAT )          /* FUNCTION SetDatePickerDateFormat( hWnd, cFormat ) -> lSuccess */
{
   if( HB_ISCHAR( 2 ) && hb_parclen( 2 ) > 0 )
   {
      hb_retl( SendMessage( HWNDparam( 1 ), DTM_SETFORMAT, 0, (LPARAM) (LPCTSTR) hb_parc( 2 ) ) );
   }
   else
   {
      /* reset to default */
      hb_retl( SendMessage( HWNDparam( 1 ), DTM_SETFORMAT, 0, (LPARAM) NULL ) );
   }
}

#pragma ENDDUMP
