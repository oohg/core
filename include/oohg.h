/*
 * $Id: oohg.h $
 */
/*
 * ooHG source code:
 * C level definitions
 *
 * Copyright 2005-2020 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2020 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2020 Contributors, https://harbour.github.io/
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


/*--------------------------------------------------------------------------------------------------------------------------------*/
#include "oohgversion.h"

#ifndef WINVER
   #define WINVER 0x0501   // Win XP
#endif
#if ( WINVER < 0x0501 )
   #undef WINVER
   #define WINVER 0x0501
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT WINVER
#endif
#if ( _WIN32_WINNT < WINVER )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT WINVER
#endif

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0600   // Internet Explorer 6.0 (Win XP)
#endif
#if ( _WIN32_IE < 0x0600 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0600
#endif

#include <windows.h>
#include <commctrl.h>
#include "hbapi.h"

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* Use this macros instead of Harbour/xHarbour specific functions */

#ifdef _WIN64
   /* For 64 bits WIN */

      #define HB_ARRAYGETNL( n, x )      hb_arrayGetNLL( n, x )
      #define HB_ARRAYSETNL( n, x, y )   hb_arraySetNLL( n, x, y )
      #define HB_RETNL( n )              hb_retnll( n )
      #define HB_STORNL( n, x )          hb_stornll( n, x )
      #define HB_PARPTR( n )             hb_parptr( n )
      #define HB_STORPTR( n, x )         hb_storptr( n, x )

   #ifdef __XHARBOUR__
      /* For XHARBOUR and 64 bits WIN */

      #define HB_PARC( n, x )            hb_parc( n, x )
      #define HB_PARCLEN( n, x )         hb_parclen( n, x )
      #define HB_PARND( n, x )           hb_parnd( n, x )
      #define HB_PARNI( n, x )           hb_parni( n, x )
      #define HB_PARNL( n )              hb_parnll( n )
      #define HB_PARNL2( n, x )          hb_parnll( n, x )
      #define HB_PARNL3( n, x, y )       hb_parnll( n, x, y )
      #define HB_PARPTR2( n, x )         hb_parptr( n, x )
      #define HB_PARPTR3( n, x, y )      hb_parptr( n, x, y )
      #define HB_PARVNL( n, x )          hb_parnll( n, x )
      #define HB_STORC( n, x, y )        hb_storc( n, x, y )
      #define HB_STORDL( n, x, y )       hb_stordl( n, x, y )
      #define HB_STORL( n, x, y )        hb_storl( n, x, y )
      #define HB_STORND( n, x, y )       hb_stornd( n, x, y )
      #define HB_STORNI( n, x, y )       hb_storni( n, x, y )
      #define HB_STORNL3( n, x, y )      hb_stornll( n, x, y )
      #define HB_STORPTR3( n, x, y )     hb_storptr( n, x, y )
      #define HB_STORVNL( n, x, y )      hb_stornll( n, x, y )
      #define HB_STORVNLL( n, x, y )     hb_stornll( n, x, y )

   #else /*  __XHARBOUR__ */
      /* For HARBOUR and 64 bits WIN */

      #define HB_PARC( n, x )            hb_parvc( n, x )
      #define HB_PARCLEN( n, x )         hb_parvclen( n, x )
      #define HB_PARND( n, x )           hb_parvnd( n, x )
      #define HB_PARNI( n, x )           hb_parvni( n, x )
      #define HB_PARNL( n )              hb_parvnll( n )
      #define HB_PARNL2( n, x )          hb_parvnll( n, x )
      #define HB_PARNL3( n, x, y )       hb_parvnll( n, x, y )
      #define HB_PARPTR2( n, x )         hb_parvptr( n, x )
      #define HB_PARPTR3( n, x, y )      hb_parvptr( n, x, y )
      #define HB_PARVNL( n, x )          hb_parvnll( n, x )
      #define HB_STORC( n, x, y )        hb_storvc( n, x, y )
      #define HB_STORDL( n, x, y )       hb_storvdl( n, x, y )
      #define HB_STORL( n, x, y )        hb_storvl( n, x, y )
      #define HB_STORND( n, x, y )       hb_storvnd( n, x, y )
      #define HB_STORNI( n, x, y )       hb_storvni( n, x, y )
      #define HB_STORNL3( n, x, y )      hb_storvnll( n, x, y )
      #define HB_STORPTR3( n, x, y )     hb_storvptr( n, x, y )
      #define HB_STORVNL( n, x, y )      hb_storvnll( n, x, y )
      #define HB_STORVNLL( n, x, y )     hb_storvnll( n, x, y )

   #endif /*  __XHARBOUR__ */

#else /*  _WIN64 */
   /* For 32 bits WIN */

      #define HB_ARRAYGETNL( n, x )      hb_arrayGetNL( n, x )
      #define HB_ARRAYSETNL( n, x, y )   hb_arraySetNL( n, x, y )
      #define HB_RETNL( n )              hb_retnl( n )
      #define HB_STORNL( n, x )          hb_stornl( n, x )
      #define HB_PARPTR( n )             hb_parptr( n )
      #define HB_STORPTR( n, x )         hb_storptr( n, x )

   #ifdef __XHARBOUR__
      /* For XHARBOUR and 32 bits WIN */

      #define HB_PARC( n, x )            hb_parc( n, x )
      #define HB_PARCLEN( n, x )         hb_parclen( n, x )
      #define HB_PARND( n, x )           hb_parnd( n, x )
      #define HB_PARNI( n, x )           hb_parni( n, x )
      #define HB_PARNL( n )              hb_parnl( n )
      #define HB_PARNL2( n, x )          hb_parnl( n, x )
      #define HB_PARNL3( n, x, y )       hb_parnl( n, x, y )
      #define HB_PARPTR2( n, x )         hb_parptr( n, x )
      #define HB_PARPTR3( n, x, y )      hb_parvptr( n, x, y )
      #define HB_PARVNL( n, x )          hb_parnl( n, x )
      #define HB_STORC( n, x, y )        hb_storc( n, x, y )
      #define HB_STORDL( n, x, y )       hb_stordl( n, x, y )
      #define HB_STORL( n, x, y )        hb_storl( n, x, y )
      #define HB_STORND( n, x, y )       hb_stornd( n, x, y )
      #define HB_STORNI( n, x, y )       hb_storni( n, x, y )
      #define HB_STORNL3( n, x, y )      hb_stornl( n, x, y )
      #define HB_STORPTR3( n, x, y )     hb_storptr( n, x, y )
      #define HB_STORVNL( n, x, y )      hb_stornl( n, x, y )
      #define HB_STORVNLL( n, x, y )     hb_stornll( n, x, y )

   #else /* __XHARBOUR__ */
      /* For HARBOUR and 32 bits WIN */

      #define HB_PARC( n, x )            hb_parvc( n, x )
      #define HB_PARCLEN( n, x )         hb_parvclen( n, x )
      #define HB_PARND( n, x )           hb_parvnd( n, x )
      #define HB_PARNI( n, x )           hb_parvni( n, x )
      #define HB_PARNL( n )              hb_parvnl( n )
      #define HB_PARNL2( n, x )          hb_parvnl( n, x )
      #define HB_PARNL3( n, x, y )       hb_parvnl( n, x, y )
      #define HB_PARPTR2( n, x )         hb_parvptr( n, x )
      #define HB_PARPTR3( n, x, y )      hb_parvptr( n, x, y )
      #define HB_PARVNL( n, x )          hb_parvnl( n, x )
      #define HB_STORC( n, x, y )        hb_storvc( n, x, y )
      #define HB_STORDL( n, x, y )       hb_storvdl( n, x, y )
      #define HB_STORL( n, x, y )        hb_storvl( n, x, y )
      #define HB_STORND( n, x, y )       hb_storvnd( n, x, y )
      #define HB_STORNI( n, x, y )       hb_storvni( n, x, y )
      #define HB_STORNL3( n, x, y )      hb_storvnl( n, x, y )
      #define HB_STORPTR3( n, x, y )     hb_storvptr( n, x, y )
      #define HB_STORVNL( n, x, y )      hb_storvnl( n, x, y )
      #define HB_STORVNLL( n, x, y )     hb_storvnll( n, x, y )

   #endif /*  __XHARBOUR__ */

#endif /* _WIN64 */

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* Handle related macros */

#ifdef OOHG_HWND_POINTER
   /* Use pointers for handles */

      #define HANDLEparam( n )            ( (HANDLE) HB_PARPTR( n ) )
      #define HBITMAPparam( n )           ( (HBITMAP) HB_PARPTR( n ) )
      #define HBRUSHparam( n )            ( (HBRUSH) HB_PARPTR( n ) )
      #define HCURSORparam( n )           ( (HCURSOR) HB_PARPTR( n ) )
      #define HDCparam( n )               ( (HDC) HB_PARPTR( n ) )
      #define HEMFparam( n )              ( (HENHMETAFILE) HB_PARPTR( n ) )
      #define HFONTparam( n )             ( (HFONT) HB_PARPTR( n ) )
      #define HGDIOBJparam( n )           ( (HGDIOBJ) HB_PARPTR( n ) )
      #define HGLOBALparam( n )           ( (HGLOBAL) HB_PARPTR( n ) )
      #define HICparam( n )               ( (HIC) HB_PARPTR( n ) )
      #define HICONparam( n )             ( (HICON) HB_PARPTR( n ) )
      #define HIMAGELISTparam( n )        ( (HIMAGELIST) HB_PARPTR( n ) )
      #define HINSTANCEparam( n )         ( (HINSTANCE) HB_PARPTR( n ) )
      #define HKEYparam( n )              ( (HKEY) HB_PARPTR( n ) )
      #define HMENUparam( n )             ( (HMENU) HB_PARPTR( n ) )
      #define HMODULEparam( n )           ( (HMODULE) HB_PARPTR( n ) )
      #define HPALETTEparam( n )          ( (HPALETTE) HB_PARPTR( n ) )
      #define HPENparam( n )              ( (HPEN) HB_PARPTR( n ) )
      #define HRGNparam( n )              ( (HRGN) HB_PARPTR( n ) )
      #define HRSRCparam( n )             ( (HRSRC) HB_PARPTR( n ) )
      #define HWNDparam( n )              ( (HWND) HB_PARPTR( n ) )

      #define DEVICEINTERFASEparam( n )   ( (device_interface *) HB_PARPTR( n ) )
      #define DRAWITEMSTRUCTparam( n )    ( (LPDRAWITEMSTRUCT) HB_PARPTR( n ) )
      #define HBPRINTERDATAparam( n )     ( (LPHBPRINTERDATA) HB_PARPTR( n ) )
      #define HELPINFOparam( n )          ( (LPHELPINFO) HB_PARPTR( n ) )
      #define HSINKparam( n )             ( (MyRealIEventHandler *) HB_PARPTR( n ) )
      #define LV_KEYDOWNparam( n )        ( (LV_KEYDOWN *) HB_PARPTR( n ) )
      #define MEASUREITEMSTRUCTparam( n ) ( (LPMEASUREITEMSTRUCT) HB_PARPTR( n ) )
      #define MSGBOXCALLBACKparam( n )    ( (MSGBOXCALLBACK) HB_PARPTR( n ) )
      #define MSGFILTERparam( n )         ( (MSGFILTER FAR *) HB_PARPTR( n ) )
      #define MYITEMparam( n )            ( (MYITEM *) HB_PARPTR( n ) )
      #define NMCUSTOMDRAWparam( n )      ( (LPNMCUSTOMDRAW) HB_PARPTR( n ) )
      #define NMDAYSTATEparam( n )        ( (NMDAYSTATE *) HB_PARPTR( n ) )
      #define NMHDRparam( n )             ( (LPNMHDR) HB_PARPTR( n ) )
      #define NMHEADERparam( n )          ( (LPNMHEADER) HB_PARPTR( n ) )
      #define NMITEMACTIVATEparam( n )    ( (LPNMITEMACTIVATE) HB_PARPTR( n ) )
      #define NMLISTVIEWparam( n )        ( (LPNMLISTVIEW) HB_PARPTR( n ) )
      #define NMLVDISPINFOparam( n )      ( (NMLVDISPINFO *) HB_PARPTR( 1 ) )
      #define NMLVSCROLLparam( n )        ( (LPNMLVSCROLL) HB_PARPTR( n ) )
      #define NMMOUSEparam( n )           ( (LPNMMOUSE) HB_PARPTR( n ) )
      #define NMTBGETINFOTIPparam( n )    ( (LPNMTBGETINFOTIP) HB_PARPTR( n ) )
      #define NMTOOLBARparam( n )         ( (LPNMTOOLBAR) HB_PARPTR( n ) )
      #define NMTTDISPINFOparam( n )      ( (NMTTDISPINFO *) HB_PARPTR( n ) )
      #define NMVIEWCHANGEparam( n )      ( (NMVIEWCHANGE *)  HB_PARPTR( n ) )
      #define TOOLTIPTEXTparam( n )       ( (LPTOOLTIPTEXT) HB_PARPTR( n ) )

      #define HWNDparam2( n, x )          ( (HWND) HB_PARPTR2( n, x ) )
      #define HBITMAPparam2( n, x )       ( (HBITMAP) HB_PARPTR2( n, x ) )
      #define HDCparam2( n, x )           ( (HDC) HB_PARPTR2( n, x ) )
      #define HGDIOBJparam2( n, x )       ( (HGDIOBJ) HB_PARPTR2( n, x ) )

      #define HIMAGELISTparam3( n, x, y ) ( (HIMAGELIST) HB_PARPTR3( n, x, y ) )

      #define LONG_PTRparam( n )          ( (LONG_PTR) HB_PARNL( n ) )
      #define LPARAMparam( n )            ( (LPARAM) HB_PARNL( n ) )
      #define LPRECTparam( n )            ( (LPRECT) HB_PARNL( n ) )
      #define REGSAMparam( n )            ( (REGSAM) HB_PARNL( n ) )
      #define ULONG_PTRparam( n )         ( (ULONG_PTR) HB_PARNL( n ) )
      #define WPARAMparam( n )            ( (WPARAM) HB_PARNL( n ) )

      #define HANDLEpush( n )             ( hb_vmPushPointer( n ) )
      #define HWNDpush( n )               HANDLEpush( n )

      #define HANDLEret( n )              ( hb_retptr( n ) )
      #define HBITMAPret( n )             HANDLEret( n )
      #define HBRUSHret( n )              HANDLEret( n )
      #define HCURSORret( n )             HANDLEret( n )
      #define HDCret( n )                 HANDLEret( n )
      #define HEMFret( n )                HANDLEret( n )
      #define HFONTret( n )               HANDLEret( n )
      #define HGDIOBJret( n )             HANDLEret( n )
      #define HGLOBALret( n )             HANDLEret( n )
      #define HICret( n )                 HANDLEret( n )
      #define HICONret( n )               HANDLEret( n )
      #define HIMAGELISTret( n )          HANDLEret( n )
      #define HINSTANCEret( n )           HANDLEret( n )
      #define HKEYret( n )                HANDLEret( n )
      #define HMENUret( n )               HANDLEret( n )
      #define HMODULEret( n )             HANDLEret( n )
      #define HPENret( n )                HANDLEret( n )
      #define HRGNret( n )                HANDLEret( n )
      #define HRSRCret( n )               HANDLEret( n )
      #define HWNDret( n )                HANDLEret( n )

      #define LRESULTret( n )             ( HB_RETNL( (LONG_PTR) n ) )

      #define HANDLEstor( n, x )          ( HB_STORPTR( n, x ) )
      #define HBITMAPstor( n, x )         HANDLEstor( n, x )
      #define HBRUSHstor( n, x )          HANDLEstor( n, x )
      #define HCURSORstor( n, x )         HANDLEstor( n, x )
      #define HDCstor( n, x )             HANDLEstor( n, x )
      #define HEMFstor( n, x )            HANDLEstor( n, x )
      #define HFONTstor( n, x )           HANDLEstor( n, x )
      #define HGDIOBJstor( n, x )         HANDLEstor( n, x )
      #define HGLOBALstor( n, x )         HANDLEstor( n, x )
      #define HICstor( n, x )             HANDLEstor( n, x )
      #define HICONstor( n, x )           HANDLEstor( n, x )
      #define HIMAGELISTstor( n, x )      HANDLEstor( n, x )
      #define HINSTANCEstor( n, x )       HANDLEstor( n, x )
      #define HKEYstor( n, x )            HANDLEstor( n, x )
      #define HMENUstor( n, x )           HANDLEstor( n, x )
      #define HMODULEstor( n, x )         HANDLEstor( n, x )
      #define HPENstor( n, x )            HANDLEstor( n, x )
      #define HRGNstor( n, x )            HANDLEstor( n, x )
      #define HRSRCstor( n, x )           HANDLEstor( n, x )
      #define HWNDstor( n, x )            HANDLEstor( n, x )

      #define HANDLEstor3( n, x, y )      ( HB_STORPTR3( n, x, y ) )
      #define HBITMAPstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HBRUSHstor3( n, x, y )      HANDLEstor3( n, x, y )
      #define HCURSORstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HDCstor3( n, x, y )         HANDLEstor3( n, x, y )
      #define HEMFstor3( n, x, y )        HANDLEstor3( n, x, y )
      #define HFONTstor3( n, x, y )       HANDLEstor3( n, x, y )
      #define HGDIOBJstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HGLOBALstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HICstor3( n, x, y )         HANDLEstor3( n, x, y )
      #define HICONstor3( n, x, y )       HANDLEstor3( n, x, y )
      #define HIMAGELISTstor3( n, x, y )  HANDLEstor3( n, x, y )
      #define HINSTANCEstor3( n, x, y )   HANDLEstor3( n, x, y )
      #define HKEYstor3( n, x, y )        HANDLEstor3( n, x, y )
      #define HMENUstor3( n, x, y )       HANDLEstor3( n, x, y )
      #define HMODULEstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HPENstor3( n, x, y )        HANDLEstor3( n, x, y )
      #define HRGNstor3( n, x, y )        HANDLEstor3( n, x, y )
      #define HRSRCstor3( n, x, y )       HANDLEstor3( n, x, y )
      #define HWNDstor3( n, x, y )        HANDLEstor3( n, x, y )

#else /* OOHG_HWND_POINTER */
   /* Use numbers for handles */

      #define HANDLEparam( n )            ( (HANDLE) HB_PARNL( n ) )
      #define HBITMAPparam( n )           ( (HBITMAP) HB_PARNL( n ) )
      #define HBRUSHparam( n )            ( (HBRUSH) HB_PARNL( n ) )
      #define HCURSORparam( n )           ( (HCURSOR) HB_PARNL( n ) )
      #define HDCparam( n )               ( (HDC) HB_PARNL( n ) )
      #define HEMFparam( n )              ( (HENHMETAFILE) HB_PARNL( n ) )
      #define HFONTparam( n )             ( (HFONT) HB_PARNL( n ) )
      #define HGDIOBJparam( n )           ( (HGDIOBJ) HB_PARNL( n ) )
      #define HGLOBALparam( n )           ( (HGLOBAL) HB_PARNL( n ) )
      #define HICparam( n )               ( (HIC) HB_PARNL( n ) )
      #define HICONparam( n )             ( (HICON) HB_PARNL( n ) )
      #define HIMAGELISTparam( n )        ( (HIMAGELIST) HB_PARNL( n ) )
      #define HINSTANCEparam( n )         ( (HINSTANCE) HB_PARNL( n ) )
      #define HKEYparam( n )              ( (HKEY) HB_PARNL( n ) )
      #define HMENUparam( n )             ( (HMENU) HB_PARNL( n ) )
      #define HMODULEparam( n )           ( (HMODULE) HB_PARNL( n ) )
      #define HPALETTEparam( n )          ( (HPALETTE) HB_PARNL( n ) )
      #define HPENparam( n )              ( (HPEN) HB_PARNL( n ) )
      #define HRGNparam( n )              ( (HRGN) HB_PARNL( n ) )
      #define HRSRCparam( n )             ( (HRSRC) HB_PARNL( n ) )
      #define HWNDparam( n )              ( (HWND) HB_PARNL( n ) )

      #define DEVICEINTERFASEparam( n )   ( (device_interface *) HB_PARNL( n ) )
      #define DRAWITEMSTRUCTparam( n )    ( (LPDRAWITEMSTRUCT) (LPARAM) HB_PARNL( n ) )
      #define HBPRINTERDATAparam( n )     ( (LPHBPRINTERDATA) HB_PARNL( n ) )
      #define HELPINFOparam( n )          ( (LPHELPINFO) HB_PARNL( n ) )
      #define HSINKparam( n )             ( (MyRealIEventHandler *) HB_PARNL( n ) )
      #define LV_KEYDOWNparam( n )        ( (LV_KEYDOWN *) (LPARAM) HB_PARNL( n ) )
      #define MEASUREITEMSTRUCTparam( n ) ( (LPMEASUREITEMSTRUCT) (LPARAM) HB_PARNL( n ) )
      #define MSGBOXCALLBACKparam( n )    ( (MSGBOXCALLBACK) HB_PARNL( n ) )
      #define MSGFILTERparam( n )         ( (MSGFILTER FAR *) HB_PARNL( n ) )
      #define MYITEMparam( n )            ( (MYITEM *) HB_PARNL( n ) )
      #define NMCUSTOMDRAWparam( n )      ( (LPNMCUSTOMDRAW) HB_PARNL( n ) )
      #define NMDAYSTATEparam( n )        ( (NMDAYSTATE *) HB_PARNL( n ) )
      #define NMHDRparam( n )             ( (LPNMHDR) HB_PARNL( n ) )
      #define NMHEADERparam( n )          ( (LPNMHEADER) HB_PARNL( n ) )
      #define NMITEMACTIVATEparam( n )    ( (LPNMITEMACTIVATE) HB_PARNL( n ) )
      #define NMLISTVIEWparam( n )        ( (LPNMLISTVIEW) HB_PARNL( n ) )
      #define NMLVDISPINFOparam( n )      ( (NMLVDISPINFO *) HB_PARNL( 1 ) )
      #define NMLVSCROLLparam( n )        ( (LPNMLVSCROLL) HB_PARNL( n ) )
      #define NMMOUSEparam( n )           ( (LPNMMOUSE) HB_PARNL( n ) )
      #define NMTBGETINFOTIPparam( n )    ( (LPNMTBGETINFOTIP) HB_PARNL( n ) )
      #define NMTOOLBARparam( n )         ( (LPNMTOOLBAR) HB_PARNL( n ) )
      #define NMTTDISPINFOparam( n )      ( (NMTTDISPINFO *) HB_PARNL( n ) )
      #define NMVIEWCHANGEparam( n )      ( (NMVIEWCHANGE *)  HB_PARNL( n ) )
      #define TOOLTIPTEXTparam( n )       ( (LPTOOLTIPTEXT) HB_PARNL( n ) )

      #define HWNDparam2( n, x )          ( (HWND) HB_PARNL2( n, x ) )
      #define HBITMAPparam2( n, x )       ( (HBITMAP) HB_PARNL2( n, x ) )
      #define HDCparam2( n, x )           ( (HDC) HB_PARNL2( n, x ) )
      #define HGDIOBJparam2( n, x )       ( (HGDIOBJ) HB_PARNL2( n, x ) )

      #define HIMAGELISTparam3( n, x, y ) ( (HIMAGELIST) HB_PARNL3( n, x, y ) )

      #define HANDLEpush( n )             ( hb_vmPushNumInt( (LONG_PTR) n ) )
      #define HWNDpush( n )               HANDLEpush( n )

      #define LONG_PTRparam( n )          ( (LONG_PTR) HB_PARNL( n ) )
      #define LPARAMparam( n )            ( (LPARAM) HB_PARNL( n ) )
      #define LPRECTparam( n )            ( (LPRECT) HB_PARNL( n ) )
      #define REGSAMparam( n )            ( (REGSAM) HB_PARNL( n ) )
      #define ULONG_PTRparam( n )         ( (ULONG_PTR) HB_PARNL( n ) )
      #define WPARAMparam( n )            ( (WPARAM) HB_PARNL( n ) )

      #define HANDLEret( n )              ( HB_RETNL( (LONG_PTR) n ) )
      #define HBITMAPret( n )             HANDLEret( n )
      #define HBRUSHret( n )              HANDLEret( n )
      #define HCURSORret( n )             HANDLEret( n )
      #define HDCret( n )                 HANDLEret( n )
      #define HEMFret( n )                HANDLEret( n )
      #define HFONTret( n )               HANDLEret( n )
      #define HGDIOBJret( n )             HANDLEret( n )
      #define HGLOBALret( n )             HANDLEret( n )
      #define HICret( n )                 HANDLEret( n )
      #define HICONret( n )               HANDLEret( n )
      #define HIMAGELISTret( n )          HANDLEret( n )
      #define HINSTANCEret( n )           HANDLEret( n )
      #define HKEYret( n )                HANDLEret( n )
      #define HMENUret( n )               HANDLEret( n )
      #define HMODULEret( n )             HANDLEret( n )
      #define HPENret( n )                HANDLEret( n )
      #define HRGNret( n )                HANDLEret( n )
      #define HRSRCret( n )               HANDLEret( n )
      #define HWNDret( n )                HANDLEret( n )

      #define LRESULTret( n )             ( HB_RETNL( (LONG_PTR) n ) )

      #define HANDLEstor( n, x )          ( HB_STORNL( (LONG_PTR) n, x ) )
      #define HBITMAPstor( n, x )         HANDLEstor( n, x )
      #define HBRUSHstor( n, x )          HANDLEstor( n, x )
      #define HCURSORstor( n, x )         HANDLEstor( n, x )
      #define HDCstor( n, x )             HANDLEstor( n, x )
      #define HEMFstor( n, x )            HANDLEstor( n, x )
      #define HFONTstor( n, x )           HANDLEstor( n, x )
      #define HGDIOBJstor( n, x )         HANDLEstor( n, x )
      #define HGLOBALstor( n, x )         HANDLEstor( n, x )
      #define HICstor( n, x )             HANDLEstor( n, x )
      #define HICONstor( n, x )           HANDLEstor( n, x )
      #define HIMAGELISTstor( n, x )      HANDLEstor( n, x )
      #define HINSTANCEstor( n, x )       HANDLEstor( n, x )
      #define HKEYstor( n, x )            HANDLEstor( n, x )
      #define HMENUstor( n, x )           HANDLEstor( n, x )
      #define HMODULEstor( n, x )         HANDLEstor( n, x )
      #define HPENstor( n, x )            HANDLEstor( n, x )
      #define HRGNstor( n, x )            HANDLEstor( n, x )
      #define HRSRCstor( n, x )           HANDLEstor( n, x )
      #define HWNDstor( n, x )            HANDLEstor( n, x )

      #define HANDLEstor3( n, x, y )      ( HB_STORNL3( (LONG_PTR) n, x, y ) )
      #define HBITMAPstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HBRUSHstor3( n, x, y )      HANDLEstor3( n, x, y )
      #define HCURSORstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HDCstor3( n, x, y )         HANDLEstor3( n, x, y )
      #define HEMFstor3( n, x, y )        HANDLEstor3( n, x, y )
      #define HFONTstor3( n, x, y )       HANDLEstor3( n, x, y )
      #define HGDIOBJstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HGLOBALstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HICstor3( n, x, y )         HANDLEstor3( n, x, y )
      #define HICONstor3( n, x, y )       HANDLEstor3( n, x, y )
      #define HIMAGELISTstor3( n, x, y )  HANDLEstor3( n, x, y )
      #define HINSTANCEstor3( n, x, y )   HANDLEstor3( n, x, y )
      #define HKEYstor3( n, x, y )        HANDLEstor3( n, x, y )
      #define HMENUstor3( n, x, y )       HANDLEstor3( n, x, y )
      #define HMODULEstor3( n, x, y )     HANDLEstor3( n, x, y )
      #define HPENstor3( n, x, y )        HANDLEstor3( n, x, y )
      #define HRGNstor3( n, x, y )        HANDLEstor3( n, x, y )
      #define HRSRCstor3( n, x, y )       HANDLEstor3( n, x, y )
      #define HWNDstor3( n, x, y )        HANDLEstor3( n, x, y )

#endif /* OOHG_HWND_POINTER */

#define ValidHandler( hWnd )  ( ( hWnd ) != 0 && (HWND) ( hWnd ) != (HWND) ( ~0 ) )

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* Auxiliary structure used for setting image related parameters, see function ImageFillParameter */

struct IMAGE_PARAMETER
{
   char *cString;
   int  iImage1, iImage2;
};

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* Structure used for handling OWNERDRAW menus */

typedef struct _MYITEM
{
   LONG id;
} MYITEM, *LPMYITEM;

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* Auxiliary structure used for handling some TWindow's datas at C level */

typedef struct OOHG_Window
{
   HWND       hWnd;
   HIMAGELIST ImageList;
   BYTE       *AuxBuffer;
   ULONG      AuxBufferLen;
   LONG       lFontColor;
   LONG       lBackColor;
   HBRUSH     BrushHandle;
   LONG       lFontColorSelected;
   LONG       lBackColorSelected;
   LONG       lAux[ 10 ];
   HFONT      hFontHandle;
   LONG       lOldBackColor;
   LONG       lUseBackColor;
   HICON      IconHandle;
   HBRUSH     OriginalBrush;
} OCTRL, *POCTRL;

/* TODO: Check is the + 100 is necessary */
#define _OOHG_Struct_Size  ( sizeof( OCTRL ) + 100 )

/*--------------------------------------------------------------------------------------------------------------------------------*/
/*
This files are not present in BCC 551
#include <uxtheme.h>
#include <tmschema.h>
*/

typedef HANDLE HTHEME;

typedef enum THEMESIZE {
   TS_MIN,
   TS_TRUE,
   TS_DRAW
} THEMESIZE;

#ifndef __MSABI_LONG
#  ifndef __LP64__
#    define __MSABI_LONG( x )  ( x ## l )
#  else
#    define __MSABI_LONG( x )  ( x )
#  endif
#endif

#define DTT_TEXTCOLOR     ( __MSABI_LONG( 1U ) << 0 )
#define DTT_BORDERCOLOR   ( __MSABI_LONG( 1U ) << 1 )
#define DTT_SHADOWCOLOR   ( __MSABI_LONG( 1U ) << 2 )
#define DTT_SHADOWTYPE    ( __MSABI_LONG( 1U ) << 3 )
#define DTT_SHADOWOFFSET  ( __MSABI_LONG( 1U ) << 4 )
#define DTT_BORDERSIZE    ( __MSABI_LONG( 1U ) << 5 )
#define DTT_FONTPROP      ( __MSABI_LONG( 1U ) << 6 )
#define DTT_COLORPROP     ( __MSABI_LONG( 1U ) << 7 )
#define DTT_STATEID       ( __MSABI_LONG( 1U ) << 8 )
#define DTT_CALCRECT      ( __MSABI_LONG( 1U ) << 9 )
#define DTT_APPLYOVERLAY  ( __MSABI_LONG( 1U ) << 10 )
#define DTT_GLOWSIZE      ( __MSABI_LONG( 1U ) << 11 )
#define DTT_CALLBACK      ( __MSABI_LONG( 1U ) << 12 )
#define DTT_COMPOSITED    ( __MSABI_LONG( 1U ) << 13 )
#define DTT_VALIDBITS     ( DTT_TEXTCOLOR | DTT_BORDERCOLOR | DTT_SHADOWCOLOR | DTT_SHADOWTYPE | DTT_SHADOWOFFSET | DTT_BORDERSIZE | \
                            DTT_FONTPROP | DTT_COLORPROP | DTT_STATEID | DTT_CALCRECT | DTT_APPLYOVERLAY | DTT_GLOWSIZE | DTT_COMPOSITED )

typedef int ( WINAPI *DTT_CALLBACK_PROC ) ( HDC hdc, LPWSTR pszText, int cchText, LPRECT prc, UINT dwFlags, LPARAM lParam );

typedef BOOL WINBOOL;

typedef struct _MARGINS {
   int cxLeftWidth;
   int cxRightWidth;
   int cyTopHeight;
   int cyBottomHeight;
} MARGINS, *PMARGINS;

typedef struct _DTTOPTS {
   DWORD dwSize;
   DWORD dwFlags;
   COLORREF crText;
   COLORREF crBorder;
   COLORREF crShadow;
   int iTextShadowType;
   POINT ptShadowOffset;
   int iBorderSize;
   int iFontPropId;
   int iColorPropId;
   int iStateId;
   WINBOOL fApplyOverlay;
   int iGlowSize;
   DTT_CALLBACK_PROC pfnDrawTextCallback;
   LPARAM lParam;
} DTTOPTS, *PDTTOPTS;

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* Prototypes for C functions used in more than one module */

LPWSTR           AnsiToWide( const char * );
PHB_ITEM         GetControlObjectByHandle( HWND, BOOL );
PHB_ITEM         GetControlObjectById( LONG, HWND );
PHB_ITEM         GetFormObjectByHandle( HWND, BOOL );
int              GetKeyFlagState( void );
void             getwinver( OSVERSIONINFO * );
void             ImageFillParameter( struct IMAGE_PARAMETER * , PHB_ITEM );
BOOL             InitDeinitGdiPlus( BOOL );
HFONT            PrepareFont( const char *, int, int, int, int, int, int, int, int, int, int );
HRESULT          ProcCloseThemeData( HTHEME );
HRESULT          ProcDrawThemeBackground( HTHEME, HDC, int, int, LPCRECT, LPCRECT );
HRESULT          ProcDrawThemeParentBackground( HWND, HDC, LPCRECT );
HRESULT          ProcDrawThemeText( HTHEME, HDC, int, int, LPCWSTR, int, DWORD, DWORD, LPCRECT );
HRESULT          ProcDrawThemeTextEx( HTHEME, HDC, int, int, LPCWSTR, int, DWORD, LPRECT, const DTTOPTS * );
HRESULT          ProcGetThemeBackgroundContentRect( HTHEME, HDC, int, int, LPCRECT, LPRECT );
HRESULT          ProcGetThemeMargins( HTHEME, HDC, int, int, int, LPCRECT, MARGINS * );
HRESULT          ProcGetThemePartSize( HTHEME, HDC, int, int, LPCRECT, THEMESIZE, SIZE * );
BOOL             ProcIsThemeActive( void );
BOOL             ProcIsThemeBackgroundPartiallyTransparent( HTHEME, int, int );
HTHEME           ProcOpenThemeData( HWND, LPCWSTR );
HRESULT          ProcSetWindowTheme( HWND, LPCWSTR, LPCWSTR );
BOOL             SaveHBitmapToFile( HBITMAP, const TCHAR *, UINT, UINT, TCHAR *, ULONG, ULONG );
void             _oohg_calldump( char *, char * );
BOOL             _OOHG_ChangeWindowMessageFilter( UINT, DWORD );
BOOL             _OOHG_DetermineColor( PHB_ITEM, LONG * );
BOOL             _OOHG_DetermineColorReturn( PHB_ITEM, LONG *, BOOL );
BOOL             _OOHG_UseGDIP( void );
DWORD            _OOHG_RTL_Status( BOOL );
HANDLE           _OOHG_GDIPLoadPicture( HGLOBAL, HWND, LONG, LONG, LONG, BOOL );
HANDLE           _OOHG_GlobalMutex( void );
HBITMAP          _OOHG_ScaleImage( HWND, HBITMAP, LONG, LONG, BOOL, LONG, BOOL, int, int );
HB_PTRUINT       _OOHG_GetProcAddress( HMODULE, LPCSTR );
HMODULE          _UxTheme_Init( void );
LRESULT APIENTRY _OOHG_WndProcCtrl( HWND, UINT, WPARAM, LPARAM, WNDPROC );
PHB_ITEM         _OOHG_GetExistingObject( HWND, BOOL, BOOL );
POCTRL           _OOHG_GetControlInfo( PHB_ITEM );
void             _Ax_DeInit( void );
void             _ComCtl32_DeInit( void );
void             _DWMAPI_DeInit( void );
void             _OOHG_DoEvent( PHB_ITEM, int, const char *, PHB_ITEM );
void             _OOHG_DoEventMouseCoords( PHB_ITEM, int, const char *, LPARAM );
void             _OOHG_Send( PHB_ITEM, int );
int              _OOHG_SearchControlHandleInArray( HWND );
int              _OOHG_SearchFormHandleInArray( HWND );
void             _ProcessLib_DeInit( void );
void             _RichEdit_DeInit( void );
void             _ShlWAPI_DeInit( void );
void             _User32_DeInit( void );
void             _UxTheme_DeInit( void );

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* Table of symbols used at C level to access some datas and methods of different classes */

#define s_Events_Notify         0
#define s_GridForeColor         1
#define s_GridBackColor         2
#define s_FontColor             3
#define s_BackColor             4
#define s_Container             5
#define s_Parent                6
#define s_hCursor               7
#define s_Events                8
#define s_Events_Color          9
#define s_Name                  10
#define s_Type                  11
#define s_TControl              12
#define s_TLabel                13
#define s_TGrid                 14
#define s_ContextMenu           15
#define s_RowMargin             16
#define s_ColMargin             17
#define s_hWnd                  18
#define s_TText                 19
#define s_AdjustRightScroll     20
#define s_OnMouseMove           21
#define s_OnMouseDrag           22
#define s_DoEvent               23
#define s_LookForKey            24
#define s_aControlInfo          25
#define s__aControlInfo         26
#define s_Events_DrawItem       27
#define s__hWnd                 28
#define s_Events_Command        29
#define s_OnChange              30
#define s_OnGotFocus            31
#define s_OnLostFocus           32
#define s_OnClick               33
#define s_Transparent           34
#define s_Events_MeasureItem    35
#define s_FontHandle            36
#define s_TWindow               37
#define s_WndProc               38
#define s_OverWndProc           39
#define s_hWndClient            40
#define s_Refresh               41
#define s_AuxHandle             42
#define s_ContainerCol          43
#define s_ContainerRow          44
#define s_lRtl                  45
#define s_Width                 46
#define s_Height                47
#define s_VScroll               48
#define s_ScrollButton          49
#define s_Visible               50
#define s_Events_HScroll        51
#define s_Events_VScroll        52
#define s_nTextHeight           53
#define s_Events_Enter          54
#define s_Id                    55
#define s_NestedClick           56
#define s__NestedClick          57
#define s_TInternal             58
#define s__ContextMenu          59
#define s_Release               60
#define s_Activate              61
#define s_oOle                  62
#define s_RangeHeight           63
#define s_OnRClick              64
#define s_OnMClick              65
#define s_OnDblClick            66
#define s_OnRDblClick           67
#define s_OnMDblClick           68
#define s_OnDropFiles           69
#define s_lAdjustImages         70
#define s_aSelColor             71
#define s_TabHandle             72
#define s_ItemEnabled           73
#define s_HandleToItem          74
#define s_GridSelectedColors    75
#define s_TEdit                 76
#define s_oBkGrnd               77
#define s_aExcludeArea          78
#define s_CompareItems          79
#define s_Events_Drag           80
#define s_Events_MenuHilited    81
#define s_Events_InitMenuPopUp  82
#define s_oMenu                 83
#define s_Events_TimeOut        84
#define s_RangeWidth            85
#define s_LastSymbol            86

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* Substitute some macros under xHarbour */

#ifdef __XHARBOUR__
   #ifndef HB_ISDATE
      #define HB_ISDATE( n )   ISDATE( n )
   #endif
   #ifndef HB_ISCHAR
      #define HB_ISCHAR( n )   ISCHAR( n )
   #endif
   #ifndef HB_ISNUM
      #define HB_ISNUM( n )    ISNUM( n )
   #endif
   #ifndef HB_ISNIL
      #define HB_ISNIL( n )    ISNIL( n )
   #endif
   #ifndef HB_ISARRAY
      #define HB_ISARRAY( n )  ISARRAY( n )
   #endif
   #ifndef HB_ISLOG
      #define HB_ISLOG( n )    ISLOG( n )
   #endif
   #ifndef HB_ISBLOCK
      #define HB_ISBLOCK( n )  ISBLOCK( n )
   #endif
#endif

/*--------------------------------------------------------------------------------------------------------------------------------*/
/*  Support for older C Compilers */

#if defined( _MSC_VER ) || defined( __MINGW32__ )
   /* For newer versions of MS and MINGW compilers */

   #define _OOHG_ITOA   _itoa
   #define _OOHG_ULTOA  _ultoa
   #define _OOHG_LTOA   _ltoa

#else /* _MSC_VER */
   /* For BORLAND and older versions of MINGW compilers */

   #define _OOHG_ITOA   itoa
   #define _OOHG_ULTOA  ultoa
   #define _OOHG_LTOA   ltoa

#endif /* _MSC_VER */

#ifdef MAKEWORD
   #undef MAKEWORD
#endif
#define MAKEWORD( a, b )  ( (WORD) ( ( (BYTE) ( ( (DWORD_PTR) ( a ) ) & 0xff ) ) | ( ( (WORD) ( (BYTE) ( ( (DWORD_PTR) ( b ) ) & 0xff ) ) ) << 8 ) ) )

#ifdef MAKELONG
   #undef MAKELONG
#endif
#define MAKELONG( a, b )  ( (LONG) ( ( (WORD) ( ( (DWORD_PTR) ( a ) ) & 0xffff ) ) | ( ( ( DWORD ) ( (WORD) ( ( (DWORD_PTR) ( b ) ) & 0xffff ) ) ) << 16 ) ) )

/*--------------------------------------------------------------------------------------------------------------------------------*/
/*  Menu related constants */

#ifdef _INCLUDE_OOHG_MENU_CONSTANTS_
   #include "menu.h"
#endif

/*--------------------------------------------------------------------------------------------------------------------------------*/
/*  For Harbour 3.0 */
#ifndef __XHARBOUR__
#if ( __HARBOUR__ - 0 < 0x030200 ) 
   #define HB_UNCONST( p ) ( (void *) (HB_PTRUINT) (const void *) ( p ) )
#endif
#endif
