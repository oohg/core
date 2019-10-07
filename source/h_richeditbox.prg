/*
 * $Id: h_richeditbox.prg $
 */
/*
 * ooHG source code:
 * RichEdit control
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TEditRich FROM TEdit

   DATA lDefault                  INIT .T.
   DATA lSelChanging              INIT .F.
   DATA nHeight                   INIT 240
   DATA nWidth                    INIT 120
   DATA OnSelChange               INIT NIL
   DATA Version                   INIT 41
   DATA Type                      INIT "RICHEDIT" READONLY

   METHOD AutoURLDetect
   METHOD BackColor               SETGET
   METHOD CanPaste                BLOCK { |Self| SendMessage( ::hWnd, EM_CANPASTE, 0, 0 ) # 0 }
   METHOD CanReDo                 BLOCK { |Self| SendMessage( ::hWnd, EM_CANREDO, 0, 0 ) # 0 }
   METHOD Define
   METHOD Events
   METHOD Events_Notify
   METHOD FontColor               SETGET
   METHOD GetCharFromPos
   METHOD GetLastVisibleLine
   METHOD GetSelFont
   METHOD GetSelText
   METHOD GetSelType              BLOCK { |Self| TEditRich_SelectionType( ::hWnd ) }
   METHOD HideSelection
   METHOD LoadFile
   METHOD MaxLength               SETGET
   METHOD ReDo                    BLOCK { |Self| SendMessage( ::hWnd, EM_REDO, 0, 0 ) }
   METHOD Release
   METHOD RichValue               SETGET
   METHOD SaveFile
   METHOD SetOptions              BLOCK { |Self, nOptions| TEditRich_SetOptions( ::hWnd, nOptions ) }
   METHOD SetSelectionBackColor
   METHOD SetSelectionTextColor
   METHOD SetSelEx                BLOCK { |Self, nStart, nEnd| TEditRich_SetSelEx( ::hWnd, nStart, nEnd ) }
   METHOD SetSelFont
   METHOD Value                   SETGET

   MESSAGE GetSelectionFont       METHOD GetSelFont
   MESSAGE SetSelBackColor        METHOD SetSelectionBackColor
   MESSAGE SetSelectionFont       METHOD SetSelFont
   MESSAGE SetSelTextColor        METHOD SetSelectionTextColor

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, nWidth, nHeight, uValue, cFontName, ;
               nFontSize, cToolTip, nMaxLength, bGotFocus, bChange, bLostFocus, ;
               lReadonly, lBreak, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, ;
               lUnderline, lStrikeout, cField, uBackColor, lRtl, lDisabled, ;
               bSelChange, uFontColor, lNoHideSel, nOnFocusPos, lNoVScroll, ;
               lNoHScroll, cFile, nType, bOnHScroll, bOnVScroll, nInsType, nVersion ) CLASS TEditRich

   LOCAL nControlHandle, nStyle

   ASSIGN ::nWidth  VALUE nWidth   TYPE "N"
   ASSIGN ::nHeight VALUE nHeight  TYPE "N"
   ASSIGN ::nRow    VALUE nRow     TYPE "N"
   ASSIGN ::nCol    VALUE nCol     TYPE "N"

   IF HB_ISNUMERIC( nVersion ) .AND. ( nVersion == 41 .OR. nVersion == 30 )
      ::Version := nVersion
   ENDIF

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, .T., lRtl )

   nStyle := ::InitStyle( NIL, NIL, lInvisible, lNoTabStop, lDisabled ) + ;
             iif( HB_ISLOGICAL( lReadonly ) .AND. lReadonly, ES_READONLY, 0 ) + ;
             iif( HB_ISLOGICAL( lNoHideSel ) .AND. lNoHideSel, ES_NOHIDESEL, 0 ) + ;
             iif( HB_ISLOGICAL( lNoVScroll ) .AND. lNoVScroll, ES_AUTOVSCROLL, WS_VSCROLL ) + ;
             iif( HB_ISLOGICAL( lNoHScroll ) .AND. lNoHScroll, 0, WS_HSCROLL )
/*
ES_AUTOHSCROLL
Automatically scrolls text to the right by 10 characters when the user types a character at the end of the line. When the user presses the ENTER key, the control scrolls all text back to position zero.
ES_CENTER
Centers text in a single-line or multiline edit control.
ES_LEFT
Left aligns text.
ES_NUMBER
Allows only digits to be entered into the edit control.
ES_PASSWORD
Displays an asterisk (*) for each character typed into the edit control. This style is valid only for single-line edit controls.
ES_RIGHT
Right aligns text in a single-line or multiline edit control.
ES_DISABLENOSCROLL
Disables scroll bars instead of hiding them when they are not needed.
ES_NOOLEDRAGDROP
Disables support for drag-drop of OLE objects.
ES_SAVESEL
Preserves the selection when the control loses the focus. By default, the entire contents of the control are selected when it regains the focus.
ES_SELECTIONBAR
Adds space to the left margin where the cursor changes to a right-up arrow, allowing the user to select full lines of text.
ES_SUNKEN
Displays the control with a sunken border style so that the rich edit control appears recessed into its parent window.
*/

   ::SetSplitBoxInfo( lBreak )
   nControlHandle := InitRichEditBox( ::ContainerhWnd, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle, nMaxLength, ::lRtl, ::Version )

   ::Register( nControlHandle, cControlName, nHelpId, NIL, cToolTip )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeout )

   ::BackColor := ::BackColor
   ::FontColor := ::FontColor

   IF Empty( cFile )
      ::SetVarBlock( cField, uValue )
   ELSE
      ::LoadFile( cFile, nType )
   ENDIF

   ASSIGN ::OnHScroll   VALUE bOnHScroll  TYPE "B"
   ASSIGN ::OnVScroll   VALUE bOnVScroll  TYPE "B"
   ASSIGN ::OnLostFocus VALUE bLostFocus  TYPE "B"
   ASSIGN ::OnGotFocus  VALUE bGotFocus   TYPE "B"
   ASSIGN ::OnChange    VALUE bChange     TYPE "B"
   ASSIGN ::OnSelChange VALUE bSelChange  TYPE "B"
   ASSIGN ::nOnFocusPos VALUE nOnFocusPos TYPE "N"
   ASSIGN ::nInsertType VALUE nInsType    TYPE "N"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release CLASS TEditRich

   ::OnSelChange := NIL

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD LoadFile( cFile, nType ) CLASS TEditRich

   LOCAL lRet := .F.

   ASSIGN cFile VALUE cFile TYPE "C" DEFAULT ""
   ASSIGN nType VALUE nType TYPE "N" DEFAULT 2
   IF ! Empty( cFile ) .AND. File( cFile )
      lRet := FileStreamIn( ::hWnd, cFile, nType )
   ENDIF

   RETURN lRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SaveFile( cFile, nType ) CLASS TEditRich

   LOCAL lRet := .F.

   ASSIGN cFile VALUE cFile TYPE "C" DEFAULT ""
   ASSIGN nType VALUE nType TYPE "N" DEFAULT 2
   IF ! Empty( cFile )
      lRet := FileStreamOut( ::hWnd, cFile, nType )
   ENDIF

   RETURN lRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RichValue( cValue ) CLASS TEditRich

   IF ValType( cValue ) $ "CM"
      RichStreamIn( ::hWnd, cValue )
   ENDIF

   RETURN RichStreamOut( ::hWnd )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetSelFont( lSelection ) CLASS TEditRich

   LOCAL aRet, nTextColor

   ASSIGN lSelection VALUE lSelection TYPE "L" DEFAULT .T.               // .F. means control's default font

   aRet := GetFontRTF( ::hWnd, iif( lSelection, 1, 0 ) )                 // { cFontName, nFontSize, lBold, lItalic, nTextColor, lUnderline, lStrikeout, nCharset }

   IF ! Empty( aRet[ 1 ] )
      nTextColor := aRet[ 5 ]
      aRet[ 5 ] := { GetRed( nTextColor ), GetGreen( nTextColor ), GetBlue( nTextColor ) }
   ELSE
      aRet[ 5 ] := { NIL, NIL, NIL }
   ENDIF

   RETURN aRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetSelFont( lSelection, cFontName, nFontSize, lBold, lItalic, aTextColor, lUnderline, lStrikeout, nMask ) CLASS TEditRich

   ASSIGN lSelection VALUE lSelection TYPE "L" DEFAULT .T.               // .F. means control's default font

   RETURN SetFontRTF( ::hWnd, iif( lSelection, 1, 0 ), cFontName, nFontSize, lBold, lItalic, RGB( aTextColor[1], aTextColor[2], aTextColor[3] ), lUnderline, lStrikeout, nMask )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION TEditRich_Events2( hWnd, nMsg, wParam, lParam )

   LOCAL Self := QSelf()
   LOCAL cText, lRet

   IF nMsg == WM_KEYDOWN .AND. wParam == VK_Z .AND. ( GetKeyFlagState() == MOD_CONTROL .OR. GetKeyFlagState() == MOD_CONTROL + MOD_SHIFT )

      cText := ::Value
      ::Value := ::xUndo
      ::xUndo := cText
      RETURN 1

   ELSEIF nMsg == WM_LBUTTONDBLCLK
      lRet := ::DoEventMouseCoords( ::OnDblClick, "DBLCLICK" )
      IF HB_ISLOGICAL( lRet ) .AND. lRet
         IF ::lDefault
            // Do default action: select word
            RETURN NIL
         ELSE
            // Prevent default action
            RETURN 1
         ENDIF
      ENDIF

   ENDIF

   RETURN ::Super:Events( hWnd, nMsg, wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Notify( wParam, lParam ) CLASS TEditRich

   LOCAL nNotify := GetNotifyCode( lParam )

   IF nNotify == EN_SELCHANGE
      IF ! ::lSelChanging
         ::lSelChanging := .T.
         ::DoEvent( ::OnSelChange, "SELCHANGE" )
         ::lSelChanging := .F.
      ENDIF
   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetSelText( lTranslate ) CLASS TEditRich

   LOCAL cSelText := RichEdit_GetSelText( ::hWnd )

   IF HB_ISLOGICAL( lTranslate ) .AND. lTranslate
     cSelText := StrTran( cSelText, Chr( 13 ), Chr( 13 ) + Chr( 10 ) )
   ENDIF

   RETURN cSelText

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MaxLength( nLen ) CLASS TEditRich

   IF HB_ISNUMERIC( nLen )
      SendMessage( ::hWnd, EM_EXLIMITTEXT, 0, nLen )
   ENDIF

   RETURN SendMessage( ::hWnd, EM_GETLIMITTEXT, 0, 0 )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetLastVisibleLine CLASS TEditRich

   LOCAL aRect, nChar

   aRect := ::GetRect()            // top, left, bottom, right
   nChar := ::GetCharFromPos( aRect[3] - 2, aRect[2] + 1 )

   RETURN ::GetLineFromChar( nChar )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD AutoURLDetect( lOnOff ) CLASS TEditRich

   IF HB_ISLOGICAL( lOnOff )
      SendMessage( ::hWnd, EM_AUTOURLDETECT, iif( lOnOff, 1, 0 ), 0 )
   ENDIF

   RETURN NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( cValue ) CLASS TEditRich

   IF ValType( cValue ) $ "CM"
      TEditRich_SetText( ::hWnd, .F., cValue )
   ENDIF

   RETURN ::Caption

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include <windows.h>
#include <commctrl.h>
#include <richedit.h>
#include "oohg.h"

#ifndef CFM_BACKCOLOR
   #define CFM_BACKCOLOR 0x04000000
#endif

#ifdef MSFTEDIT_CLASS
   #undef MSFTEDIT_CLASS
#endif
#define MSFTEDIT_CLASS "RICHEDIT50W"

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TEditRich_lpfnOldWndProc( WNDPROC lp )
{
   static WNDPROC lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TEditRich_lpfnOldWndProc( 0 ) );
}

static HMODULE hDllRichEdit30 = NULL;
static HMODULE hDllRichEdit41 = NULL;

/*--------------------------------------------------------------------------------------------------------------------------------*/
VOID _RichEdit_DeInit( VOID )
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( hDllRichEdit41 )
   {
      FreeLibrary( hDllRichEdit41 );
      hDllRichEdit41 = NULL;
   }
   if( hDllRichEdit30 )
   {
      FreeLibrary( hDllRichEdit30 );
      hDllRichEdit30 = NULL;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITRICHEDITBOX )          /* FUNCTION InitMonthCal( hWnd, hMenu, nCol, nRow, nWidth, nHeight, nStyle, nMaxLength, lRtl, nVersion ) -> hWnd */
{
   HWND hCtrl;
   INT Style, StyleEx, Mask;
   char * classname = NULL;
   BOOL bIs41;

   Style = ES_MULTILINE | ES_WANTRETURN | WS_CHILD | hb_parni( 7 );
   StyleEx = WS_EX_CLIENTEDGE | _OOHG_RTL_Status( hb_parl( 9 ) );
   Mask = ENM_CHANGE | ENM_SELCHANGE | ENM_SCROLL | ENM_DRAGDROPDONE;
/*
ENM_DROPFILES
ENM_KEYEVENTS
ENM_LINK
ENM_MOUSEEVENTS
*/
   InitCommonControls();

   if( hb_parni( 10 ) == 30 )
   {
      if( hDllRichEdit30 != NULL )
      {
         classname = RICHEDIT_CLASS;
         bIs41 = FALSE;
      }
      else
      {
         WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
         hDllRichEdit30 = LoadLibrary( "RICHED20.DLL" );
         if( hDllRichEdit30 != NULL )
         {
            classname = RICHEDIT_CLASS;
            bIs41 = FALSE;
         }
         ReleaseMutex( _OOHG_GlobalMutex() );
      }
   }
   else
   {
      if( hDllRichEdit41 != NULL )
      {
         classname = MSFTEDIT_CLASS;
         bIs41 = TRUE;
      }
      else
      {
         WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
         hDllRichEdit41 = LoadLibrary( "MSFTEDIT.DLL" );
         if( hDllRichEdit41 != NULL )
         {
            classname = MSFTEDIT_CLASS;
            bIs41 = TRUE;
         }
         else
         {
            if( hDllRichEdit30 != NULL )
            {
               classname = RICHEDIT_CLASS;
               bIs41 = FALSE;
            }
            else
            {
               hDllRichEdit30 = LoadLibrary( "RICHED20.DLL" );
               if( hDllRichEdit30 != NULL )
               {
                  classname = RICHEDIT_CLASS;
                  bIs41 = FALSE;
               }
            }
         }
         ReleaseMutex( _OOHG_GlobalMutex() );
      }
   }

   if ( classname != NULL )
   {
      hCtrl = CreateWindowEx( StyleEx, classname, ( LPSTR ) NULL, Style,
                              hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                              HWNDparam( 1 ), HMENUparam( 2 ), GetModuleHandle( NULL ), NULL );

      _OOHG_TEditRich_lpfnOldWndProc( ( WNDPROC ) SetWindowLongPtr( hCtrl, GWL_WNDPROC, ( LONG_PTR ) SubClassFunc ) );

      if( hb_parni( 8 ) != 0 )
      {
         SendMessage( hCtrl, EM_EXLIMITTEXT, ( WPARAM) 0, ( LPARAM ) hb_parni( 8 ) );
      }

      SendMessage( hCtrl, EM_SETEVENTMASK, 0, ( LPARAM ) Mask );

      if( bIs41 )
      {
         HB_STORNI( 41, 1, 10 );
      }
      else
      {
         HB_STORNI( 30, 1, 10 );
      }

      HWNDret( hCtrl );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TEDITRICH_BACKCOLOR )          /* METHOD BackColor( uColor ) CLASS TEditRich -> aColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lBackColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         if( oSelf->lBackColor != -1 )
         {
            SendMessage( oSelf->hWnd, EM_SETBKGNDCOLOR, 0, oSelf->lBackColor );
         }
         else
         {
            SendMessage( oSelf->hWnd, EM_SETBKGNDCOLOR, 0, GetSysColor( COLOR_WINDOW ) );
         }
         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TEDITRICH_FONTCOLOR )          /* METHOD FontColor( uColor ) CLASS TEditRich -> aColor */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   CHARFORMAT2 Format;

   if( _OOHG_DetermineColorReturn( hb_param( 1, HB_IT_ANY ), &oSelf->lFontColor, ( hb_pcount() >= 1 ) ) )
   {
      if( ValidHandler( oSelf->hWnd ) )
      {
         memset( &Format, 0, sizeof( Format ) );
         Format.cbSize = sizeof( Format );
         Format.dwMask = CFM_COLOR;
         Format.crTextColor = ( ( oSelf->lFontColor != -1 ) ? ( COLORREF ) oSelf->lFontColor : GetSysColor( COLOR_WINDOWTEXT ) );

         SendMessage( oSelf->hWnd, EM_SETCHARFORMAT, ( WPARAM ) SCF_ALL, ( LPARAM ) &Format );

         RedrawWindow( oSelf->hWnd, NULL, NULL, RDW_ERASE | RDW_INVALIDATE | RDW_ALLCHILDREN | RDW_ERASENOW | RDW_UPDATENOW );
      }
   }

   // Return value was set in _OOHG_DetermineColorReturn()
}

struct StreamInfo {
   LONG lSize;
   LONG lRead;
   char *cBuffer;
   struct StreamInfo *pNext;
};

/*--------------------------------------------------------------------------------------------------------------------------------*/
DWORD CALLBACK EditStreamCallbackIn( DWORD_PTR dwCookie, LPBYTE pbBuff, LONG cb, LONG FAR *pcb )
{
   struct StreamInfo *si;
   LONG lMax;

   si = ( struct StreamInfo * ) dwCookie;

   if( si->lSize == si->lRead )
   {
      *pcb = 0;
   }
   else
   {
      lMax = si->lSize - si->lRead;
      if( cb < lMax )
      {
         lMax = cb;
      }
      memcpy( pbBuff, si->cBuffer + si->lRead, lMax );
      si->lRead += lMax;
      *pcb = lMax;
   }
   return 0;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RICHSTREAMIN )          /* FUNCTION RichStreamIn( hWnd, cValue ) -> NIL */
{
   int iType = SF_RTF;
   EDITSTREAM es;
   struct StreamInfo si;

   si.lSize = hb_parclen( 2 );
   si.lRead = 0;
   si.cBuffer = ( char * ) HB_UNCONST( hb_parc( 2 ) );

   es.dwCookie = ( DWORD_PTR ) &si;
   es.dwError = 0;
   es.pfnCallback = ( EDITSTREAMCALLBACK ) EditStreamCallbackIn;

   SendMessage( HWNDparam( 1 ), EM_STREAMIN, ( WPARAM ) iType, ( LPARAM ) &es );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
DWORD CALLBACK EditStreamCallbackOut( DWORD_PTR dwCookie, LPBYTE pbBuff, LONG cb, LONG FAR *pcb )
{
   struct StreamInfo *si;

   si = ( struct StreamInfo * ) dwCookie;

   if( cb == 0 )
   {
      *pcb = 0;
   }
   else
   {
      // Locates next available block
      while( si->lSize != 0 )
      {
         if( si->pNext )
         {
            si = si->pNext;
         }
         else
         {
            si->pNext = (struct StreamInfo *) hb_xgrab( sizeof( struct StreamInfo ) );
            si = si->pNext;
            si->lSize = 0;
            si->pNext = NULL;
         }
      }

      si->cBuffer = (char *) hb_xgrab( cb );
      memcpy( si->cBuffer, pbBuff, cb );
      si->lSize = cb;
      *pcb = cb;
   }
   return 0;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RICHSTREAMOUT )          /* FUNCTION RichStreamOut( hWnd ) -> NIL */
{
   int iType = SF_RTF;
   EDITSTREAM es;
   struct StreamInfo *si, *si2;
   LONG lSize, lRead;
   char *cBuffer;

   si = (struct StreamInfo *) hb_xgrab( sizeof( struct StreamInfo ) );
   si->lSize = 0;
   si->pNext = NULL;

   es.dwCookie = ( DWORD_PTR ) si;
   es.dwError = 0;
   es.pfnCallback = ( EDITSTREAMCALLBACK ) EditStreamCallbackOut;

   SendMessage( HWNDparam( 1 ), EM_STREAMOUT, ( WPARAM ) iType, ( LPARAM ) &es );

   lSize = si->lSize;
   si2 = si->pNext;
   while( si2 )
   {
      lSize += si2->lSize;
      si2 = si2->pNext;
   }

   if( lSize == 0 )
   {
      hb_retc( "" );
      hb_xfree( si );
   }
   else
   {
      cBuffer = (char *) hb_xgrab( lSize );
      lRead = 0;
      while( si )
      {
         memcpy( cBuffer + lRead, si->cBuffer, si->lSize );
         hb_xfree( si->cBuffer );
         lRead += si->lSize;
         si2 = si;
         si = si->pNext;
         hb_xfree( si2 );
      }
      hb_retclen( cBuffer, lSize );
      hb_xfree( cBuffer );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
DWORD CALLBACK EditStreamCallbackFileIn( DWORD_PTR dwCookie, LPBYTE pbBuff, LONG cb, LONG FAR *pcb )
{
   HANDLE hFile = (HANDLE) dwCookie;

   if( ReadFile( hFile, (LPVOID) pbBuff, cb, (LPDWORD) pcb, NULL ) )
   {
      return 0;
   }
   else
   {
      return -1;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
DWORD CALLBACK EditStreamCallbackFileOut( DWORD_PTR dwCookie, LPBYTE pbBuff, LONG cb, LONG FAR *pcb )
{
   HANDLE hFile = (HANDLE) dwCookie;

   if( WriteFile( hFile, (LPVOID) pbBuff, cb, (LPDWORD) pcb, NULL ) )
   {
      return 0;
   }
   else
   {
      return -1;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( FILESTREAMIN )          /* FUNCTION FileStreamIn( hWnd, cFile, nType ) -> lSuccess */
{
   HWND hwnd = HWNDparam( 1 );
   HANDLE hFile;
   EDITSTREAM es;
   LONG lFlag, lMode;

   switch( hb_parni( 3 ) )
   {
      case 1:
      {
         lFlag = SF_TEXT;
         lMode = TM_PLAINTEXT;
         break;
      }
      case 2:
      {
         lFlag = SF_RTF;
         lMode = TM_RICHTEXT;
         break;
      }
      case 3:
      {
         lFlag = SF_TEXT | SF_UNICODE;
         lMode = TM_PLAINTEXT;
         break;
      }
      case 4:
      {
         lFlag = ( ( ULONG ) CP_UTF8 << 16 ) | SF_USECODEPAGE | SF_TEXT;
         lMode = TM_PLAINTEXT;
         break;
      }
      case 5:
      {
         lFlag = ( ( ULONG ) CP_UTF8 << 16 ) | SF_USECODEPAGE | SF_RTF; ;
         lMode = TM_RICHTEXT;
         break;
      }
      case 6:
      {
         lFlag = ( ( ULONG ) CP_UTF7 << 16 ) | SF_USECODEPAGE | SF_TEXT; ;
         lMode = TM_PLAINTEXT;
         break;
      }
      default:
      {
         lFlag = SF_TEXT;
         lMode = TM_PLAINTEXT;
      }
   }

   if( ( hFile = CreateFile( hb_parc( 2 ), GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL ) ) == INVALID_HANDLE_VALUE )
   {
      hb_retl( FALSE );
   }

   es.dwCookie = (DWORD) hFile;
   es.dwError = 0;
   es.pfnCallback = (EDITSTREAMCALLBACK) EditStreamCallbackFileIn;

   SendMessage( hwnd, (UINT) EM_STREAMIN, (WPARAM) lFlag, (LPARAM) &es );
   SendMessage( hwnd, (UINT) EM_SETTEXTMODE, (WPARAM) lMode, 0 );

   CloseHandle( hFile );

   if( es.dwError )
   {
      hb_retl( FALSE );
   }
   else
   {
      hb_retl( TRUE );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( FILESTREAMOUT )          /* FUNCTION FileStreamOut( hWnd, cFile, nType ) -> lSuccess */
{
   HWND hwnd = HWNDparam( 1 );
   HANDLE hFile;
   EDITSTREAM es;
   LONG lFlag;

   switch( hb_parni( 3 ) )
   {
      case 1:
      {
         lFlag = SF_TEXT;
         break;
      }
      case 2:
      {
         lFlag = SF_RTF;
         break;
      }
      case 3:
      {
         lFlag = SF_TEXT | SF_UNICODE;
         break;
      }
      case 4:
      {
         lFlag = ( ( ULONG ) CP_UTF8 << 16 ) | SF_USECODEPAGE | SF_TEXT;
         break;
      }
      case 5:
      {
         lFlag = ( ( ULONG ) CP_UTF8 << 16 ) | SF_USECODEPAGE | SF_RTF;
         break;
      }
      case 6:
      {
         lFlag = ( ( ULONG ) CP_UTF7 << 16 ) | SF_USECODEPAGE | SF_TEXT;
         break;
      }
      default:
      {
         lFlag = SF_TEXT;
      }
   }

   if( ( hFile = CreateFile( hb_parc( 2 ), GENERIC_WRITE, FILE_SHARE_WRITE, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL ) ) == INVALID_HANDLE_VALUE )
   {
      hb_retl( FALSE );
   }

   es.dwCookie = (DWORD) hFile;
   es.dwError = 0;
   es.pfnCallback = (EDITSTREAMCALLBACK) EditStreamCallbackFileOut;

   SendMessage( hwnd, EM_STREAMOUT, (WPARAM) lFlag, (LPARAM) &es );

   CloseHandle( hFile );

   if( es.dwError )
   {
      hb_retl( FALSE );
   }
   else
   {
      hb_retl( TRUE );
   }
}

#define s_Super s_TEdit

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TEDITRICH_EVENTS )          /* METHOD Events( hWnd, nMsg, wParam, lParam ) CLASS TEditRich -> uRet */
{
   HWND hWnd      = HWNDparam( 1 );
   UINT message   = ( UINT )   hb_parni( 2 );
   WPARAM wParam  = ( WPARAM ) HB_PARNL( 3 );
   LPARAM lParam  = ( LPARAM ) HB_PARNL( 4 );
   PHB_ITEM pSelf = hb_stackSelfItem();

   switch( message )
   {
      case WM_LBUTTONDBLCLK:
          HB_FUNCNAME( TEDITRICH_EVENTS2 )();
          break;

      case WM_KEYDOWN:
         if( ( GetWindowLongPtr( hWnd, GWL_STYLE ) & ES_READONLY ) == 0 )
         {
            HB_FUNCNAME( TEDITRICH_EVENTS2 )();
            break;
         }
         /* FALLTHRU */

      default:
         _OOHG_Send( pSelf, s_Super );
         hb_vmSend( 0 );
         _OOHG_Send( hb_param( -1, HB_IT_OBJECT ), s_Events );
         HWNDpush( hWnd );
         hb_vmPushLong( message );
         hb_vmPushNumInt( wParam );
         hb_vmPushNumInt( lParam );
         hb_vmSend( 4 );
         break;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TEDITRICH_SETSELECTIONTEXTCOLOR )          /* METHOD SetSelectionTextColor( lColor ) CLASS TEditRich -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   CHARFORMAT2 Format;
   COLORREF clrColor;

   if( HB_ISNIL( 1 ) )
   {
      clrColor = ( ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_WINDOWTEXT ) : (COLORREF) oSelf->lFontColor );
   }
   else
   {
      clrColor = (COLORREF) hb_parnl( 1 );
   }

   memset( &Format, 0, sizeof( Format ) );
   Format.cbSize = sizeof( Format );
   Format.dwMask = CFM_COLOR;
   Format.crTextColor = clrColor;

   SendMessage( oSelf->hWnd, EM_SETCHARFORMAT, (WPARAM) SCF_SELECTION, (LPARAM) &Format );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TEDITRICH_SETSELECTIONBACKCOLOR )          /* METHOD SetSelectionBackColor( lColor ) CLASS TEditRich -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   CHARFORMAT2 Format;
   COLORREF clrColor;

   if( HB_ISNIL( 1 ) )
   {
      clrColor = ( ( oSelf->lBackColor == -1 ) ? GetSysColor( COLOR_WINDOW ) : (COLORREF) oSelf->lBackColor );
   }
   else
   {
      clrColor = (COLORREF) hb_parnl( 1 );
   }

   memset( &Format, 0, sizeof( Format ) );
   Format.cbSize = sizeof( Format );
   Format.dwMask = CFM_BACKCOLOR;
   Format.crBackColor = clrColor;

   SendMessage( oSelf->hWnd, EM_SETCHARFORMAT, ( WPARAM ) SCF_SELECTION, ( LPARAM ) &Format );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TEDITRICH_HIDESELECTION )          /* METHOD HideSelection( lHide ) CLASS TEditRich -> NIL */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );

   SendMessage( oSelf->hWnd, EM_HIDESELECTION, ( WPARAM ) ( hb_parl( 1 ) ? 1 : 0 ), 0 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RICHEDIT_GETSELTEXT )          /* FUNCTION RichEdit_GetSelText( hWnd ) -> cText */
{
   GETTEXTLENGTHEX gtl;
   GETTEXTEX gte;
   char *cBuffer;

   gtl.flags = GTL_USECRLF | GTL_PRECISE | GTL_NUMCHARS;
   gtl.codepage = CP_ACP;

   gte.cb = SendMessage( HWNDparam( 1 ), EM_GETTEXTLENGTHEX, ( WPARAM ) &gtl, 0 ) + 1;
   gte.flags = GT_SELECTION | GT_USECRLF;
   gte.codepage = CP_ACP;
   gte.lpDefaultChar = NULL;
   gte.lpUsedDefChar = NULL;

   cBuffer = ( char * ) hb_xgrab( gte.cb );

   SendMessage( HWNDparam( 1 ), EM_GETSELTEXT, 0, ( LPARAM ) cBuffer );

   hb_retc( cBuffer );
   hb_xfree( cBuffer );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TEDITRICH_GETCHARFROMPOS )          /* METHOD GetCharFromPos( nRow, nCol ) CLASS TEditRich -> nIndex */
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   POINTL pnt;

   pnt.x = hb_parni( 2 );
   pnt.y = hb_parni( 1 );

   hb_retni( SendMessage( oSelf->hWnd, EM_CHARFROMPOS, 0, ( LPARAM ) &pnt ) );        // zero-based index
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( GETFONTRTF )          /* FUNCTION GetFontRTF( hWnd, nSel ) -> { cFontName, nFontSize, lBold, lItalic, nTextColor, lUnderline, lStrikeout, nCharset } */
{
   CHARFORMAT  cF;
   LONG        PointSize;
   INT         bold;
   INT         Italic;
   INT         Underline;
   INT         StrikeOut;
   INT         SelText;
   HWND        hWnd = HWNDparam( 1 );

   cF.cbSize = sizeof( CHARFORMAT );
   cF.dwMask = CFM_BOLD | CFM_ITALIC | CFM_UNDERLINE | CFM_SIZE;
   if( hb_parni( 2 ) > 0 )
   {
      SelText = SCF_SELECTION;
   }
   else
   {
      SelText = SCF_DEFAULT;
   }

   SendMessage( hWnd, EM_GETCHARFORMAT, ( WPARAM ) SelText, ( LPARAM ) &cF );

   PointSize = cF.yHeight / 20;

   bold = ( cF.dwEffects & CFE_BOLD ) ? 1 : 0;
   Italic = ( cF.dwEffects & CFE_ITALIC ) ? 1 : 0;
   Underline = ( cF.dwEffects & CFE_UNDERLINE ) ? 1 : 0;
   StrikeOut = ( cF.dwEffects & CFE_STRIKEOUT ) ? 1 : 0;

   hb_reta( 8 );
   HB_STORC( cF.szFaceName, -1, 1 );
   HB_STORNL3( ( LONG ) PointSize, -1, 2 );
   HB_STORL( bold, -1, 3 );
   HB_STORL( Italic, -1, 4 );
   HB_STORNL3( ( LONG ) cF.crTextColor, -1, 5 );
   HB_STORL( Underline, -1, 6 );
   HB_STORL( StrikeOut, -1, 7 );
   HB_STORNI( cF.bCharSet, -1, 8 );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETFONTRTF )          /* SetFontRTF( hWnd, nSel, cFontName, nFontSize, lBold, lItalic, nTextColor, lUnderline, lStrikeout, nMask ) -> lSuccess */
/*
 * See https://msdn.microsoft.com/en-us/library/windows/desktop/bb788026(v=vs.85).aspx
 * See https://msdn.microsoft.com/en-us/library/windows/desktop/bb774230(v=vs.85).aspx
 * See https://msdn.microsoft.com/en-us/library/windows/desktop/bb787881(v=vs.85).aspx
 */
{
   LRESULT     lResult;
   CHARFORMAT  cF;
   DWORD       Mask;
   DWORD       Effects = 0;
   int         SelText = SCF_SELECTION;
   HWND        hWnd = HWNDparam( 1 );

   cF.cbSize = sizeof( CHARFORMAT );
   Mask = SendMessage( hWnd, EM_GETCHARFORMAT, ( WPARAM ) SelText, ( LPARAM ) &cF );

   if( hb_parni( 10 ) > 0 )
   {
      Mask = hb_parni( 10 );
   }

   if( hb_parni( 2 ) > 0 )
   {
      SelText = SCF_SELECTION | SCF_WORD;
   }

   if( hb_parni( 2 ) < 0 )
   {
      SelText = SCF_ALL;
   }

   if( hb_parl( 5 ) )
   {
      Effects = Effects | CFE_BOLD;
   }

   if( hb_parl( 6 ) )
   {
      Effects = Effects | CFE_ITALIC;
   }

   if( hb_parl( 8 ) )
   {
      Effects = Effects | CFE_UNDERLINE;
   }

   if( hb_parl( 9 ) )
   {
      Effects = Effects | CFE_STRIKEOUT;
   }

   cF.dwMask = Mask;
   cF.dwEffects = Effects;
   if( hb_parnl( 4 ) )
   {
      cF.yHeight = hb_parnl( 4 ) * 20;
   }

   cF.crTextColor = hb_parnl( 7 );

   if( hb_parclen( 3 ) > 0 )
   {
      lstrcpy( cF.szFaceName, hb_parc( 3 ) );
   }

   lResult = SendMessage( hWnd, EM_SETCHARFORMAT, ( WPARAM ) SelText, ( LPARAM ) &cF );

   if( lResult )
   {
      hb_retl( TRUE );
   }
   else
   {
      hb_retl( FALSE );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC ( TEDITRICH_SETTEXT )         /* FUNCTION TEditRich_SetText( hWnd, lReplace, cText ) -> NIL */
{
   SETTEXTEX ST;

   ST.flags = ( hb_parl( 2 ) ? ST_SELECTION : ST_DEFAULT );
   ST.codepage = CP_ACP;
   SendMessage ( HWNDparam( 1 ), EM_SETTEXTEX, ( WPARAM ) &ST, ( LPARAM ) hb_parc( 3 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TEDITRICH_SETOPTIONS )         /* FUNCTION TEditRich_SetOptions( hWnd, nNew ) ->  nOld */
{
   hb_retnl( SendMessage( HWNDparam( 1 ), EM_SETOPTIONS, ( WPARAM ) ECOOP_SET, ( LPARAM ) hb_parnl( 2 ) ) );   // See ECO_* defines
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TEDITRICH_SETSELEX )         /* FUNCTION TEditRich_SetSelEx( hWnd, nStart, nEnd ) -> NIL */
{
   CHARRANGE cRange;
   cRange.cpMin = 0;
   cRange.cpMax = 0;

   if( hb_parnl( 2 ) )
   {
      cRange.cpMin = hb_parnl( 2 );
   }

   if( hb_parnl( 3 ) )
   {
      cRange.cpMax = hb_parnl( 3 );
   }

   SendMessage( HWNDparam( 1 ), EM_EXSETSEL, 0, ( LPARAM ) &cRange );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TEDITRICH_SELECTIONTYPE )          /* FUNCTION TEditRich_SelectionType( hWnd ) -> nType */
{
   LRESULT lResult;
   int nMode = 0;

   lResult = SendMessage( HWNDparam( 1 ), EM_SELECTIONTYPE, 0, 0 );

   switch( lResult )
   {
      case SEL_EMPTY:       nMode = 1; break;
      case SEL_TEXT:        nMode = 2; break;
      case SEL_OBJECT:      nMode = 3; break;
      case SEL_MULTICHAR:   nMode = 4; break;
      case SEL_MULTIOBJECT: nMode = 5; break;
      default:
      {
         nMode = 0;
         if( lResult & SEL_TEXT )
         {
            nMode = nMode + 10;
         }
         if( lResult & SEL_OBJECT )
         {
            nMode = nMode + 100;
         }
         if( lResult & SEL_MULTICHAR )
         {
            nMode = nMode + 1000;
         }
         if( lResult & SEL_MULTIOBJECT )
         {
            nMode = nMode + 10000;
         }
      }
   }

   hb_retni( nMode );
}

#pragma ENDDUMP
