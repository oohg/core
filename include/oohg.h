/*
 * $Id: oohg.h,v 1.17 2006-01-17 03:04:47 guerra000 Exp $
 */
/*
 * ooHG source code:
 * C level definitions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
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
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
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
 *
 */

struct IMAGE_PARAMETER {
   char *cString;
   int iImage1, iImage2;
};

#define _OOHG_Struct_Size    ( sizeof( OCTRL ) + 100 )

typedef struct OOHG_Window {
   HWND       hWnd;
   HIMAGELIST ImageList;
   BYTE      *AuxBuffer;
   ULONG      AuxBufferLen;
   LONG       lFontColor, lBackColor;
   HBRUSH     BrushHandle;
   LONG       lFontColorSelected, lBackColorSelected;

//   int        iRow, iCol, iWidth, iHeight;
//   HB_ITEM    oParent;
//   HB_ITEM    oContainer;
//   BYTE       *cFontName;
//   int        iFontSize;
//   BOOL       bBold, bItalic, bUnderline, bStrikeout;
//   int        iRowMargin, iColMargin;
//   BOOL       bRtl;
//   HWND       hContextMenu;
//   BOOL       bEnabled;
/*
   DATA aControls      INIT {}
   DATA aControlsNames INIT {}
   DATA lInternal      INIT .T.
   DATA OnClick        INIT nil
   DATA OnGotFocus     INIT nil
   DATA OnLostFocus    INIT nil
   DATA OnMouseDrag    INIT nil
   DATA OnMouseMove    INIT nil
   DATA aKeys          INIT {}  // { Id, Mod, Key, Action }   Application-controlled hotkeys
   DATA aHotKeys       INIT {}  // { Id, Mod, Key, Action }   OperatingSystem-controlled hotkeys
   DATA DefBkColorEdit  INIT nil
*/
} OCTRL, *POCTRL;

extern void ImageFillParameter( struct IMAGE_PARAMETER *pResult, PHB_ITEM pString );
extern PHB_ITEM GetControlObjectByHandle( LONG hWnd );
extern PHB_ITEM GetControlObjectById( LONG lId, LONG hWnd );
extern void _OOHG_Send( PHB_ITEM pSelf, int iSymbol );
void _OOHG_DoEvent( PHB_ITEM pSelf, int iSymbol );
LRESULT APIENTRY _OOHG_WndProcCtrl( HWND hWnd, UINT uiMsg, WPARAM wParam, LPARAM lParam, WNDPROC lpfnOldWndProc );
extern int GetKeyFlagState( void );
POCTRL _OOHG_GetControlInfo( PHB_ITEM pSelf );
BOOL _OOHG_DetermineColor( PHB_ITEM pColor, LONG *lColor );

// Symbol tables
#define s_Events_Notify        0
#define s_GridForeColor        1
#define s_GridBackColor        2
#define s_FontColor            3
#define s_BackColor            4
#define s_Container            5
#define s_Parent               6
#define s_hCursor              7
#define s_Events               8
#define s_Events_Color         9
#define s_Name                 10
#define s_Type                 11
#define s_TControl             12
#define s_TLabel               13
#define s_TGrid                14
#define s_ContextMenu          15
#define s_RowMargin            16
#define s_ColMargin            17
#define s_hWnd                 18
#define s_TText                19
#define s_AdjustRightScroll    20
#define s_OnMouseMove          21
#define s_OnMouseDrag          22
#define s_DoEvent              23
#define s_LookForKey           24
#define s_aControlInfo         25
#define s__aControlInfo        26
#define s_Events_DrawItem      27
#define s__hWnd                28
#define s_Events_Command       29
#define s_OnChange             30
#define s_OnGotFocus           31
#define s_OnLostFocus          32
#define s_OnClick              33
#define s_Transparent          34
#define s_Events_MeasureItem   35
#define s_FontHandle           36
#define s_TWindow              37
#define s_WndProc              38
#define s_OverWndProc          39
#define s_LastSymbol           40