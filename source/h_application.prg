/*
 * $Id: h_application.prg $
 */
/*
 * ooHG source code:
 * Application object
 *
 * Based upon
 * HMG Extended source code
 * Copyright 2009 by Grigory Filatov <gfilatov@inbox.ru>
 *
 * Copyright 2014-2018 Fernando Yurisich <fyurisich@oohg.org>
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


#include "oohg.ch"
#include "hbclass.ch"

#define HOTKEY_ID        1
#define HOTKEY_MOD       2
#define HOTKEY_KEY       3
#define HOTKEY_ACTION    4

#define FONT_ID          01
#define FONT_HANDLE      02
#define FONT_NAME        03
#define FONT_SIZE        04
#define FONT_BOLD        05
#define FONT_ITALIC      06
#define FONT_UNDERLINE   07
#define FONT_STRIKEOUT   08
#define FONT_ANGLE       09
#define FONT_CHARSET     10
#define FONT_WIDTH       11
#define FONT_ORIENTATION 12
#define FONT_ADVANCED    13

#define NDX_OOHG_ACTIVECONTROLINFO     01
#define NDX_OOHG_ADJUSTFONT            03
#define NDX_OOHG_ADJUSTWIDTH           04
#define NDX_OOHG_AUTOADJUST            05
#define NDX_OOHG_DEFAULTFONTCOLOR      06
#define NDX_OOHG_DEFAULTFONTNAME       07
#define NDX_OOHG_DEFAULTFONTSIZE       08
#define NDX_OOHG_DIALOGCANCELLED       09
#define NDX_OOHG_EXTENDEDNAVIGATION    10
#define NDX_OOHG_MAIN                  11
#define NDX_OOHG_SAMEENTERDBLCLICK     12
#define NDX_OOHG_TEMPWINDOWNAME        13
#define NDX_OOHG_THISCONTROL           14
#define NDX_OOHG_THISEVENTTYPE         15
#define NDX_OOHG_THISFORM              16
#define NDX_OOHG_THISITEMCELLCOL       17
#define NDX_OOHG_THISITEMCELLHEIGHT    18
#define NDX_OOHG_THISITEMCELLROW       19
#define NDX_OOHG_THISITEMCELLVALUE     20
#define NDX_OOHG_THISITEMCELLWIDTH     21
#define NDX_OOHG_THISITEMCOLINDEX      22
#define NDX_OOHG_THISITEMROWINDEX      23
#define NDX_OOHG_THISOBJECT            24
#define NDX_OOHG_THISQUERYCOLINDEX     25
#define NDX_OOHG_THISQUERYDATA         26
#define NDX_OOHG_THISQUERYROWINDEX     27
#define NDX_OOHG_THISTYPE              28
#define NDX_OOHG_MAIN_ICON             29
#define NDX_OOHG_MULTIPLEINSTANCES     30
#define NDX_OOHG_APP_CARGO             31
#define NDX_BROWSE_SYNCSTATUS          32
#define NDX_BROWSE_FIXEDBLOCKS         33
#define NDX_BROWSE_FIXEDCONTROLS       34
#define NDX_XBROWSE_FIXEDBLOCKS        35
#define NDX_XBROWSE_FIXEDCONTROLS      36
#define NDX_GRID_FIXEDCONTROLS         37
#define NDX_OOHG_ERRORLEVEL            38
#define NDX_OOHG_WINRELEASESAMEORDER   39
#define NDX_OOHG_INITTGRIDCONTROLDATAS 40
#define NDX_OOHG_COMBOREFRESH          41
#define NDX_OOHG_SAVEASDWORD           42
#define NDX_OOHG_ACTIVEINIFILE         43
#define NDX_OOHG_ACTIVEMESSAGEBAR      44
#define NDX_OOHG_BKEYDOWN              45
#define NDX_OOHG_HOTKEYS               46
#define NDX_OOHG_DEFAULTSTATUSBARMSG   47
#define NDX_OOHG_DEFAULTMENUPARAMS     48
#define NUMBER_OF_APP_WIDE_VARS        48

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TApplication

   CLASSVAR oAppObj               INIT NIL HIDDEN
   CLASSVAR hClsMtx               INIT NIL HIDDEN

   DATA aEventsStack              INIT {}  HIDDEN
   DATA aFonts                    INIT {}  READONLY
   DATA aFramesStack              INIT {}  HIDDEN
   DATA aMenusStack               INIT {}  HIDDEN
   DATA AppMutex                  INIT NIL HIDDEN
   DATA ArgC                      INIT NIL READONLY
   DATA Args                      INIT NIL READONLY
   DATA aVars                     INIT NIL HIDDEN
   DATA Drive                     INIT NIL READONLY
   DATA ExeName                   INIT NIL READONLY
   DATA FileName                  INIT NIL READONLY
   DATA Path                      INIT NIL READONLY

   METHOD Define                  CONSTRUCTOR

   METHOD ActiveFrameContainer
   METHOD ActiveFrameGet
   METHOD ActiveFramePop
   METHOD ActiveFramePush
   METHOD ActiveMenuGet
   METHOD ActiveMenuPop
   METHOD ActiveMenuPush
   METHOD BackColor               SETGET
   METHOD Col                     SETGET
   METHOD CreateGlobalMutex       HIDDEN
   METHOD Cursor                  SETGET
   METHOD DefineLogFont
   METHOD EventInfoClear
   METHOD EventInfoList
   METHOD EventInfoPop
   METHOD EventInfoPush
   METHOD GetLogFontHandle
   METHOD GetLogFontID
   METHOD GetLogFontParams
   METHOD GetLogFontParamsByRef
   METHOD Height                  SETGET
   METHOD HelpButton              SETGET
   METHOD HotKeySet
   METHOD HotKeysGet
   METHOD hWnd
   METHOD MultipleInstances       SETGET
   METHOD MainClientHeight        SETGET
   METHOD MainClientWidth         SETGET
   METHOD MainName
   METHOD MainObject
   METHOD MainStyle               SETGET
   METHOD MutexLock               INLINE hb_mutexLock( ::hClsMtx )
   METHOD MutexUnlock             INLINE hb_mutexUnlock( ::hClsMtx )
   METHOD Release
   METHOD ReleaseLogFont
   METHOD Row                     SETGET
   METHOD Title                   SETGET
   METHOD TopMost                 SETGET
   METHOD Value_Pos01             SETGET
   METHOD Value_Pos03             SETGET
   METHOD Value_Pos04             SETGET
   METHOD Value_Pos05             SETGET
   METHOD Value_Pos06             SETGET
   METHOD Value_Pos07             SETGET
   METHOD Value_Pos08             SETGET
   METHOD Value_Pos09             SETGET
   METHOD Value_Pos10             SETGET
   METHOD Value_Pos11             SETGET
   METHOD Value_Pos12             SETGET
   METHOD Value_Pos13             SETGET
   METHOD Value_Pos14             SETGET
   METHOD Value_Pos15             SETGET
   METHOD Value_Pos16             SETGET
   METHOD Value_Pos17             SETGET
   METHOD Value_Pos18             SETGET
   METHOD Value_Pos19             SETGET
   METHOD Value_Pos20             SETGET
   METHOD Value_Pos21             SETGET
   METHOD Value_Pos22             SETGET
   METHOD Value_Pos23             SETGET
   METHOD Value_Pos24             SETGET
   METHOD Value_Pos25             SETGET
   METHOD Value_Pos26             SETGET
   METHOD Value_Pos27             SETGET
   METHOD Value_Pos28             SETGET
   METHOD Value_Pos29             SETGET
   METHOD Value_Pos30             SETGET
   METHOD Value_Pos31             SETGET
   METHOD Value_Pos32             SETGET
   METHOD Value_Pos33             SETGET
   METHOD Value_Pos34             SETGET
   METHOD Value_Pos35             SETGET
   METHOD Value_Pos36             SETGET
   METHOD Value_Pos37             SETGET
   METHOD Value_Pos38             SETGET
   METHOD Value_Pos39             SETGET
   METHOD Value_Pos40             SETGET
   METHOD Value_Pos41             SETGET
   METHOD Value_Pos42             SETGET
   METHOD Value_Pos43             SETGET
   METHOD Value_Pos44             SETGET
   METHOD Value_Pos45             SETGET
   METHOD Value_Pos47             SETGET
   METHOD Value_Pos48             SETGET
   METHOD Width                   SETGET

   MESSAGE Cargo                  METHOD Value_Pos31
   MESSAGE ErrorLevel             METHOD Value_Pos38
   MESSAGE FormObject             METHOD MainObject
   MESSAGE Handle                 METHOD hWnd
   MESSAGE Icon                   METHOD Value_Pos29

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define() CLASS TApplication

   IF ::oAppObj == NIL
      IF ! ::CreateGlobalMutex()
         MsgOOHGError( "APPLICATION: Global mutex creation failed. Program terminated." )
      ENDIF

      ::aVars := Array( NUMBER_OF_APP_WIDE_VARS )

      ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ]     := {}
      ::aVars[ NDX_OOHG_ADJUSTFONT ]            := .T.
      ::aVars[ NDX_OOHG_ADJUSTWIDTH ]           := .T.
      ::aVars[ NDX_OOHG_AUTOADJUST ]            := .F.
      ::aVars[ NDX_OOHG_DEFAULTFONTCOLOR ]      := NIL
      ::aVars[ NDX_OOHG_DEFAULTFONTNAME ]       := 'Arial'
      ::aVars[ NDX_OOHG_DEFAULTFONTSIZE ]       := 9
      ::aVars[ NDX_OOHG_DIALOGCANCELLED ]       := .F.
      ::aVars[ NDX_OOHG_EXTENDEDNAVIGATION ]    := .F.
      ::aVars[ NDX_OOHG_MAIN ]                  := NIL
      ::aVars[ NDX_OOHG_SAMEENTERDBLCLICK ]     := .F.
      ::aVars[ NDX_OOHG_TEMPWINDOWNAME ]        := ""
      ::aVars[ NDX_OOHG_THISCONTROL ]           := NIL
      ::aVars[ NDX_OOHG_THISEVENTTYPE ]         := ''
      ::aVars[ NDX_OOHG_THISFORM ]              := NIL
      ::aVars[ NDX_OOHG_THISITEMCELLCOL ]       := 0
      ::aVars[ NDX_OOHG_THISITEMCELLHEIGHT ]    := 0
      ::aVars[ NDX_OOHG_THISITEMCELLROW ]       := 0
      ::aVars[ NDX_OOHG_THISITEMCELLVALUE ]     := NIL
      ::aVars[ NDX_OOHG_THISITEMCELLWIDTH ]     := 0
      ::aVars[ NDX_OOHG_THISITEMCOLINDEX ]      := 0
      ::aVars[ NDX_OOHG_THISITEMROWINDEX ]      := 0
      ::aVars[ NDX_OOHG_THISOBJECT ]            := ''
      ::aVars[ NDX_OOHG_THISQUERYCOLINDEX ]     := 0
      ::aVars[ NDX_OOHG_THISQUERYDATA ]         := ""
      ::aVars[ NDX_OOHG_THISQUERYROWINDEX ]     := 0
      ::aVars[ NDX_OOHG_THISTYPE ]              := ''
      ::aVars[ NDX_OOHG_MAIN_ICON ]             := NIL
      ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ]     := .T.
      ::aVars[ NDX_OOHG_APP_CARGO ]             := NIL
      ::aVars[ NDX_BROWSE_SYNCSTATUS ]          := .F.
      ::aVars[ NDX_BROWSE_FIXEDBLOCKS ]         := .T.
      ::aVars[ NDX_BROWSE_FIXEDCONTROLS ]       := .F.
      ::aVars[ NDX_XBROWSE_FIXEDBLOCKS ]        := .T.
      ::aVars[ NDX_XBROWSE_FIXEDCONTROLS ]      := .F.
      ::aVars[ NDX_GRID_FIXEDCONTROLS ]         := .F.
      ::aVars[ NDX_OOHG_ERRORLEVEL ]            := 0
      ::aVars[ NDX_OOHG_WINRELEASESAMEORDER ]   := .T.
      ::aVars[ NDX_OOHG_INITTGRIDCONTROLDATAS ] := NIL
      ::aVars[ NDX_OOHG_COMBOREFRESH ]          := .T.
      ::aVars[ NDX_OOHG_SAVEASDWORD ]           := .F.
      ::aVars[ NDX_OOHG_ACTIVEINIFILE ]         := ""
      ::aVars[ NDX_OOHG_BKEYDOWN ]              := NIL
      ::aVars[ NDX_OOHG_HOTKEYS ]               := {}
      ::aVars[ NDX_OOHG_DEFAULTSTATUSBARMSG ]   := NIL
      ::aVars[ NDX_OOHG_DEFAULTMENUPARAMS ]     := { RGB( 236, 233, 216 ), RGB( 236, 233, 216 ), RGB( 0, 0, 0 ),       RGB( 0, 0, 0 ), ;
                                                     RGB( 192, 192, 192 ), RGB( 255, 252, 248 ), RGB( 136, 133, 116 ), RGB( 0, 0, 0 ), ;
                                                     RGB( 0, 0, 0 ),       RGB( 192, 192, 192 ), RGB( 255, 255, 255 ), RGB( 255, 255, 255 ), ;
                                                     RGB( 182, 189, 210 ), RGB( 182, 189, 210 ), RGB( 255, 255, 255 ), RGB( 255, 255, 255 ), ;
                                                     RGB( 246, 245, 244 ), RGB( 207, 210, 200 ), RGB( 168, 169, 163 ), RGB( 255, 255, 255 ), ;
                                                     RGB( 10, 36, 106 ),   RGB( 10, 36, 106 ),   RGB( 10, 36, 106 ),   RGB( 10, 36, 106 ), ;
                                                     RGB( 0, 0, 0 ),       RGB( 216, 220, 224 ), RGB( 64, 116, 200 ),  RGB( 128, 128, 128 ), ;
                                                     MNUCUR_FULL, MNUSEP_DOUBLE, MNUSEP_LEFT, .T., .T. }
      ::aVars[ NDX_OOHG_ACTIVEMESSAGEBAR ]      := NIL

      ::ArgC     := hb_argc()
      ::Args     := GetCommandLineArgs()
      ::ExeName  := GetProgramFileName()
      ::Drive    := Left( ::ExeName, 1 )
      ::Path     := Left( ::ExeName, RAt( '\', ::ExeName ) - 1 )
      ::FileName := SubStr( ::ExeName, RAt( '\', ::ExeName ) + 1 )

      _GETDDLMESSAGE()

      ::hClsMtx := hb_mutexCreate()
      ::oAppObj := Self
   ENDIF

   RETURN ( ::oAppObj )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ActiveFrameContainer( hWnd ) CLASS TApplication

   LOCAL nThreadID, i, nPos := 0, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   nThreadID := GetThreadId()
   i := 1
   DO WHILE i <= Len( ::aFramesStack )
      IF ::aFramesStack[ i ][ 1 ] == nThreadID
         IF ::aFramesStack[ i ][ 2 ]:Parent:hWnd == hWnd
            nPos := i
         ENDIF
      ENDIF
      i ++
   ENDDO
   IF nPos > 0
      uRet := ::aFramesStack[ nPos ][ 2 ]
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ActiveFrameGet() CLASS TApplication

   LOCAL nThreadID, i, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   nThreadID := GetThreadId()
   i := Len( ::aFramesStack )
   DO WHILE i > 0
      IF ::aFramesStack[ i ][ 1 ] == nThreadID
         uRet := ::aFramesStack[ i ][ 2 ]
         EXIT
      ENDIF
      i --
   ENDDO
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ActiveFramePop() CLASS TApplication

   LOCAL nThreadID, i, nLen

   hb_mutexLock( ::hClsMtx )
   nThreadID := GetThreadId()
   i := nLen := Len( ::aFramesStack )
   DO WHILE i > 0
      IF ::aFramesStack[ i ][ 1 ] == nThreadID
         ADel( ::aFramesStack, i )
         ASize( ::aFramesStack, nLen - 1 )
         EXIT
      ENDIF
      i --
   ENDDO
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ActiveFramePush( oFrame ) CLASS TApplication

   hb_mutexLock( ::hClsMtx )
   AAdd( ::aFramesStack, { GetThreadId(), oFrame } )
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ActiveMenuGet() CLASS TApplication

   LOCAL nThreadID, i, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   nThreadID := GetThreadId()
   i := Len( ::aMenusStack )
   DO WHILE i > 0
      IF ::aMenusStack[ i ][ 1 ] == nThreadID
         uRet := ::aMenusStack[ i ][ 2 ]
         EXIT
      ENDIF
      i --
   ENDDO
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ActiveMenuPop() CLASS TApplication

   LOCAL nThreadID, i, nLen

   hb_mutexLock( ::hClsMtx )
   nThreadID := GetThreadId()
   i := nLen := Len( ::aMenusStack )
   DO WHILE i > 0
      IF ::aMenusStack[ i ][ 1 ] == nThreadID
         ADel( ::aMenusStack, i )
         ASize( ::aMenusStack, nLen - 1 )
         EXIT
      ENDIF
      i --
   ENDDO
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ActiveMenuPush( oMenu ) CLASS TApplication

   hb_mutexLock( ::hClsMtx )
   AAdd( ::aMenusStack, { GetThreadId(), oMenu } )
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD BackColor( uColor ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:BackColor( uColor )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:BackColor()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Col( nCol ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   If PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      If HB_ISOBJECT( oMain )
         uRet := oMain:Col( nCol )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      If HB_ISOBJECT( oMain )
         uRet := oMain:Col()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Cursor( uValue ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Cursor( uValue )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Cursor()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineLogFont( cFontID, lDefault, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, ;
                   nAngle, nCharset, nWidth, nOrientation, lAdvanced ) CLASS TApplication

   LOCAL i, aFontList, hFont := 0

   hb_mutexLock( ::hClsMtx )
   IF HB_ISSTRING( cFontID ) .AND. ! Empty( cFontID )
      IF ( i := AScan( ::aFonts, { |f| f[ FONT_ID ] == Upper( cFontID ) } ) ) > 0
         hFont := ::aFonts[ i, FONT_HANDLE ]
      ELSE
         ASSIGN cFontName    VALUE cFontName    TYPE "C" DEFAULT ::aVars[ NDX_OOHG_DEFAULTFONTNAME ]
         ASSIGN cFontName    VALUE cFontName    TYPE "C" DEFAULT ::aVars[ NDX_OOHG_DEFAULTFONTSIZE ]
         ASSIGN lDefault     VALUE lDefault     TYPE "L" DEFAULT .F.
         ASSIGN lBold        VALUE lBold        TYPE "L" DEFAULT .F.
         ASSIGN lItalic      VALUE lItalic      TYPE "L" DEFAULT .F.
         ASSIGN lUnderline   VALUE lUnderline   TYPE "L" DEFAULT .F.
         ASSIGN lStrikeout   VALUE lStrikeout   TYPE "L" DEFAULT .F.
         ASSIGN nAngle       VALUE nAngle       TYPE "N" DEFAULT 0
         ASSIGN nCharset     VALUE nCharset     TYPE "N" DEFAULT DEFAULT_CHARSET
         ASSIGN nWidth       VALUE nWidth       TYPE "N" DEFAULT 0
         ASSIGN nOrientation VALUE nOrientation TYPE "N" DEFAULT nAngle
         IF ! HB_ISLOGICAL( lAdvanced )
            lAdvanced := ( nAngle # nOrientation )
         ELSEIF ! lAdvanced
            nOrientation := nAngle
         ENDIF
         GetFontList( NIL, NIL, NIL, NIL, NIL, NIL, @aFontList )
         IF Empty( AScan( aFontList, { | cName | Upper( cName ) == Upper( cFontName ) } ) )
            cFontName := "Arial"
         ENDIF
         hFont := InitFont( cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced )
         IF lDefault
            _OOHG_DefaultFontName := ::aVars[ NDX_OOHG_DEFAULTFONTNAME ]
            _OOHG_DefaultFontSize := ::aVars[ NDX_OOHG_DEFAULTFONTSIZE ]
            AAdd( ::aFonts, NIL )
            AIns( ::aFonts, 1 )
            ::aFonts[ 1 ] := { Upper( cFontID ), hFont, cFontName, nFontSize, lBold, lItalic, lUnderline, ;
                               lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced }
         ELSE
            AAdd( ::aFonts, { Upper( cFontID ), hFont, cFontName, nFontSize, lBold, lItalic, lUnderline, ;
                               lStrikeout, nAngle, nCharset, nWidth, nOrientation, lAdvanced } )
         ENDIF
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( hFont )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EventInfoList() CLASS TApplication

   LOCAL aEvents, nLen

   hb_mutexLock( ::hClsMtx )
   IF Empty( ::aVars[ NDX_OOHG_THISOBJECT ] )
      aEvents := {}
   ELSE
      ::EventInfoPush()
      nLen := Len( ::aEventsStack )
      aEvents := Array( nLen )
      AEval( ::aEventsStack, ;
             { | a, i | aEvents[ nLen - i + 1 ] := a[ 1 ]:Name + iif( a[ 4 ] == NIL, "", "." + a[ 4 ]:Name ) + "." + a[ 2 ] }, 2 )
      ASize( aEvents, nLen - 1 )
      ::EventInfoPop()
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( aEvents )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EventInfoPop() CLASS TApplication

   LOCAL nThreadID, i, nLen

   hb_mutexLock( ::hClsMtx )
   nThreadID := GetThreadId()
   i := nLen := Len( ::aEventsStack )
   DO WHILE i > 0
      IF ::aEventsStack[ i ][ 01 ] == nThreadID
         ::aVars[ NDX_OOHG_THISCONTROL ]        := ::aEventsStack[ i ][ 02 ]
         ::aVars[ NDX_OOHG_THISEVENTTYPE ]      := ::aEventsStack[ i ][ 03 ]
         ::aVars[ NDX_OOHG_THISFORM ]           := ::aEventsStack[ i ][ 04 ]
         ::aVars[ NDX_OOHG_THISITEMCELLCOL ]    := ::aEventsStack[ i ][ 05 ]
         ::aVars[ NDX_OOHG_THISITEMCELLHEIGHT ] := ::aEventsStack[ i ][ 06 ]
         ::aVars[ NDX_OOHG_THISITEMCELLROW ]    := ::aEventsStack[ i ][ 07 ]
         ::aVars[ NDX_OOHG_THISITEMCELLVALUE ]  := ::aEventsStack[ i ][ 08 ]
         ::aVars[ NDX_OOHG_THISITEMCELLWIDTH ]  := ::aEventsStack[ i ][ 09 ]
         ::aVars[ NDX_OOHG_THISITEMCOLINDEX ]   := ::aEventsStack[ i ][ 10 ]
         ::aVars[ NDX_OOHG_THISITEMROWINDEX ]   := ::aEventsStack[ i ][ 11 ]
         ::aVars[ NDX_OOHG_THISOBJECT ]         := ::aEventsStack[ i ][ 12 ]
         ::aVars[ NDX_OOHG_THISTYPE ]           := ::aEventsStack[ i ][ 13 ]
         ADel( ::aEventsStack, i )
         ASize( ::aEventsStack, nLen - 1 )
         hb_mutexUnlock( ::hClsMtx )
         RETURN NIL
      ENDIF
      i --
   ENDDO
   ::aVars[ NDX_OOHG_THISCONTROL ]        := NIL
   ::aVars[ NDX_OOHG_THISEVENTTYPE ]      := ''
   ::aVars[ NDX_OOHG_THISFORM ]           := NIL
   ::aVars[ NDX_OOHG_THISITEMCELLCOL ]    := 0
   ::aVars[ NDX_OOHG_THISITEMCELLHEIGHT ] := 0
   ::aVars[ NDX_OOHG_THISITEMCELLROW ]    := 0
   ::aVars[ NDX_OOHG_THISITEMCELLVALUE ]  := NIL
   ::aVars[ NDX_OOHG_THISITEMCELLWIDTH ]  := 0
   ::aVars[ NDX_OOHG_THISITEMCOLINDEX ]   := 0
   ::aVars[ NDX_OOHG_THISITEMROWINDEX ]   := 0
   ::aVars[ NDX_OOHG_THISOBJECT ]         := NIL
   ::aVars[ NDX_OOHG_THISTYPE ]           := ''
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EventInfoClear( nThreadID ) CLASS TApplication

   LOCAL i

   hb_mutexLock( ::hClsMtx )
   ASSIGN nThreadID VALUE nThreadID TYPE "N" DEFAULT GetThreadId()
   i := Len( ::aEventsStack )
   DO WHILE i > 0
      IF ::aEventsStack[ i ][ 01 ] == nThreadID
         ADel( ::aEventsStack, i )
         ASize( ::aEventsStack, Len( ::aEventsStack ) - 1 )
      ENDIF
      i --
   ENDDO
   ::aVars[ NDX_OOHG_THISCONTROL ]        := NIL
   ::aVars[ NDX_OOHG_THISEVENTTYPE ]      := ''
   ::aVars[ NDX_OOHG_THISFORM ]           := NIL
   ::aVars[ NDX_OOHG_THISITEMCELLCOL ]    := 0
   ::aVars[ NDX_OOHG_THISITEMCELLHEIGHT ] := 0
   ::aVars[ NDX_OOHG_THISITEMCELLROW ]    := 0
   ::aVars[ NDX_OOHG_THISITEMCELLVALUE ]  := NIL
   ::aVars[ NDX_OOHG_THISITEMCELLWIDTH ]  := 0
   ::aVars[ NDX_OOHG_THISITEMCOLINDEX ]   := 0
   ::aVars[ NDX_OOHG_THISITEMROWINDEX ]   := 0
   ::aVars[ NDX_OOHG_THISOBJECT ]         := NIL
   ::aVars[ NDX_OOHG_THISTYPE ]           := ''
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD EventInfoPush() CLASS TApplication

   hb_mutexLock( ::hClsMtx )
   AAdd( ::aEventsStack, { GetThreadId(), ;
                           ::aVars[ NDX_OOHG_THISCONTROL ], ;
                           ::aVars[ NDX_OOHG_THISEVENTTYPE ], ;
                           ::aVars[ NDX_OOHG_THISFORM ], ;
                           ::aVars[ NDX_OOHG_THISITEMCELLCOL ], ;
                           ::aVars[ NDX_OOHG_THISITEMCELLHEIGHT ], ;
                           ::aVars[ NDX_OOHG_THISITEMCELLROW ], ;
                           ::aVars[ NDX_OOHG_THISITEMCELLVALUE ], ;
                           ::aVars[ NDX_OOHG_THISITEMCELLWIDTH ], ;
                           ::aVars[ NDX_OOHG_THISITEMCOLINDEX ], ;
                           ::aVars[ NDX_OOHG_THISITEMROWINDEX ], ;
                           ::aVars[ NDX_OOHG_THISOBJECT ], ;
                           ::aVars[ NDX_OOHG_THISTYPE ] } )
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetLogFontHandle( cFontID ) CLASS TApplication

   LOCAL i, hFont := 0

   hb_mutexLock( ::hClsMtx )
   IF HB_ISSTRING( cFontID ) .AND. ! Empty( cFontID )
      IF ( i := AScan( ::aFonts, { |f| f[ FONT_ID ] == Upper( cFontID ) } ) ) > 0
         hFont := ::aFonts[ i, FONT_HANDLE ]
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( hFont )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetLogFontID( hFont ) CLASS TApplication

   LOCAL i, nID

   hb_mutexLock( ::hClsMtx )
   IF ( i := AScan( ::aFonts, { |f| f[ FONT_HANDLE ] == hFont } ) ) > 0
      nID := ::aFonts[ i, FONT_ID ]
   ELSE
      nID := ""
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( nID )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetLogFontParams( hFont ) CLASS TApplication

   LOCAL i, aFontAttr

   hb_mutexLock( ::hClsMtx )
   IF ( i := AScan( ::aFonts, { |f| f[ FONT_HANDLE ] == hFont } ) ) > 0
      aFontAttr := { ::aFonts[ i, FONT_NAME ], ;
                     ::aFonts[ i, FONT_SIZE ], ;
                     ::aFonts[ i, FONT_BOLD ], ;
                     ::aFonts[ i, FONT_ITALIC ], ;
                     ::aFonts[ i, FONT_UNDERLINE ], ;
                     ::aFonts[ i, FONT_STRIKEOUT ], ;
                     ::aFonts[ i, FONT_ANGLE ], ;
                     ::aFonts[ i, FONT_CHARSET ], ;
                     ::aFonts[ i, FONT_WIDTH ], ;
                     ::aFonts[ i, FONT_ORIENTATION ], ;
                     ::aFonts[ i, FONT_ADVANCED ] }
   ELSE
      aFontAttr := { ::aVars[ NDX_OOHG_DEFAULTFONTNAME ], ::aVars[ NDX_OOHG_DEFAULTFONTSIZE ], .F., .F., .F., .F., 0, DEFAULT_CHARSET, 0, 0, .F. }
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( aFontAttr )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD GetLogFontParamsByRef( hFont, cFontName, nFontSize, lBold, lItalic, lUnderline, lStrikeout, ;
                              nAngle, nCharset, nWidth, nOrientation, lAdvanced ) CLASS TApplication

   LOCAL lFound, aFontAttr

   hb_mutexLock( ::hClsMtx )
   aFontAttr := ::GetLogFontParams( hFont )
   cFontName    := aFontAttr[ 01 ]
   nFontSize    := aFontAttr[ 02 ]
   lBold        := aFontAttr[ 03 ]
   lItalic      := aFontAttr[ 04 ]
   lUnderline   := aFontAttr[ 05 ]
   lStrikeout   := aFontAttr[ 06 ]
   nAngle       := aFontAttr[ 07 ]
   nCharset     := aFontAttr[ 08 ]
   nWidth       := aFontAttr[ 09 ]
   nOrientation := aFontAttr[ 10 ]
   lAdvanced    := aFontAttr[ 11 ]
   lFound := ( AScan( ::aFonts, { |f| f[ FONT_HANDLE ] == hFont } ) > 0 )
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( lFound )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Height( nHeight ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Height( nHeight )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Height()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD HelpButton( lShow ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:HelpButton( lShow )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:HelpButton()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD HotKeySet( nKey, nFlags, bAction ) CLASS TApplication

   LOCAL nPos, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   nPos := AScan( ::aVars[ NDX_OOHG_HOTKEYS ], { |a| a[ HOTKEY_KEY ] == nKey .AND. a[ HOTKEY_MOD ] == nFlags } )
   IF nPos > 0
      uRet := ::aVars[ NDX_OOHG_HOTKEYS ][ nPos ][ HOTKEY_ACTION ]
   ENDIF
   IF PCount() > 2
      IF HB_ISBLOCK( bAction )
         IF nPos > 0
            ::aVars[ NDX_OOHG_HOTKEYS ][ nPos ] := { 0, nFlags, nKey, bAction }
         ELSE
            AAdd( ::aVars[ NDX_OOHG_HOTKEYS ], { 0, nFlags, nKey, bAction } )
         ENDIF
      ELSE
         IF nPos > 0
            _OOHG_DeleteArrayItem( ::aVars[ NDX_OOHG_HOTKEYS ], nPos )
         ENDIF
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD HotKeysGet() CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   uRet := AClone( ::aVars[ NDX_OOHG_HOTKEYS ] )
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD hWnd CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   oMain := ::aVars[ NDX_OOHG_MAIN ]
   IF HB_ISOBJECT( oMain )
      uRet := oMain:hWnd
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MainClientHeight( nHeight ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:ClientHeight( nHeight )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:ClientHeight()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MainClientWidth( nHeight ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:ClientWidth( nHeight )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:ClientWidth()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MainName CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   oMain := ::aVars[ NDX_OOHG_MAIN ]
   IF HB_ISOBJECT( oMain )
      uRet := oMain:Name
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MainObject CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   uRet := ::aVars[ NDX_OOHG_MAIN ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MainStyle( nStyle ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Style( nStyle )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Style()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD MultipleInstances( lMultiple, lWarning ) CLASS TApplication

   LOCAL lBefore, lRet

   hb_mutexLock( ::hClsMtx )
   IF lMultiple == NIL
      lRet := ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ]
   ELSE
      lBefore := ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ]

      IF HB_ISLOGICAL( lMultiple )
         ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ] := lMultiple
      ELSEIF HB_ISNUMERIC( lMultiple )
         ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ] := ( lMultiple != 0 )
      ELSEIF ValType( lMultiple ) $ "CM"
         IF Upper( AllTrim( lMultiple ) ) == "ON"
            ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ] := .T.
         ELSEIF Upper( AllTrim( lMultiple ) ) == "OFF"
            ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ] := .F.
         ENDIF
      ENDIF

      lRet := ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ]
      IF lRet # lBefore
         IF lRet
            CloseHandle( ::AppMutex )
            ::AppMutex := NIL
         ELSE
            ::AppMutex := CreateMutex( , .T., StrTran( GetModuleFileName(), '\', '_' ) )
            IF Empty( ::AppMutex ) .OR. _OOHG_GetLastError() > 0
               IF HB_ISLOGICAL( lWarning ) .AND. lWarning
                  MsgStop( _OOHG_Messages( 1, 4 ) )
               ENDIF
               ExitProcess( 1 )
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( lRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TApplication

   LOCAL i

   hb_mutexLock( ::hClsMtx )
   FOR i := 1 TO Len( ::aFonts )
      DeleteObject( ::aFonts[ i ] )
   NEXT i
   ::aFonts := {}
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ReleaseLogFont( cFontID ) CLASS TApplication

   LOCAL i

   hb_mutexLock( ::hClsMtx )
   IF HB_ISSTRING( cFontID ) .AND. ! Empty( cFontID )
      IF ( i := AScan( ::aFonts, { |f| f[ FONT_ID ] == Upper( cFontID ) } ) ) > 0
         DeleteObject( ::aFonts[ i, FONT_HANDLE ] )
         ADel( ::aFonts[ i ] )
         ASize( ::aFonts, Len( ::aFonts ) - 1 )
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

RETURN ( NIL )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Row( nRow ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Row( nRow )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Row()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Title( cTitle ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Title( cTitle )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Title()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TopMost( lTopmost ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:TopMost( lTopmost )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:TopMost()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos01( uValue ) CLASS TApplication

   LOCAL uRet, nThreadID, i

   hb_mutexLock( ::hClsMtx )
   nThreadID := GetThreadId()
   IF PCount() > 0
      IF uValue == NIL
         IF ( i := AScan( ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ], { |a| a[ 1 ] == nThreadID } ) ) > 0
            ADel( ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ], i )
            ASize( ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ], Len( ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ] ) - 1 )
         ENDIF
         uRet := NIL
      ELSE
         IF ( i := AScan( ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ], { |a| a[ 1 ] == nThreadID } ) ) == 0
            AAdd( ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ], { nThreadID, NIL } )
            i := Len( ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ] )
         ENDIF
         ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ][ i ][ 2 ] := uValue
         uRet := ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ][ i ][ 2 ]
      ENDIF
   ELSE
      IF ( i := AScan( ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ], { |a| a[ 1 ] == nThreadID } ) ) == 0
         uRet := NIL
      ELSE
         uRet := ::aVars[ NDX_OOHG_ACTIVECONTROLINFO ][ i ][ 2 ]
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos03( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_ADJUSTFONT ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_ADJUSTFONT ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos04( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_ADJUSTWIDTH ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_ADJUSTWIDTH ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos05( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_AUTOADJUST ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_AUTOADJUST ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos06( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      ::aVars[ NDX_OOHG_DEFAULTFONTCOLOR ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_DEFAULTFONTCOLOR ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos07( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_DEFAULTFONTNAME ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_DEFAULTFONTNAME ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos08( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_DEFAULTFONTSIZE ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_DEFAULTFONTSIZE ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos09( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_DIALOGCANCELLED ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_DIALOGCANCELLED ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos10( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_EXTENDEDNAVIGATION ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_EXTENDEDNAVIGATION ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )


/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos11( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF HB_ISOBJECT( uValue )
      ::aVars[ NDX_OOHG_MAIN ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_MAIN ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos12( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_SAMEENTERDBLCLICK ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_SAMEENTERDBLCLICK ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos13( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_TEMPWINDOWNAME ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_TEMPWINDOWNAME ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos14( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      ::aVars[ NDX_OOHG_THISCONTROL ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISCONTROL ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos15( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISEVENTTYPE ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISEVENTTYPE ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos16( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      ::aVars[ NDX_OOHG_THISFORM ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISFORM ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos17( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISITEMCELLCOL ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISITEMCELLCOL ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos18( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISITEMCELLHEIGHT ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISITEMCELLHEIGHT ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos19( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISITEMCELLROW ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISITEMCELLROW ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos20( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      ::aVars[ NDX_OOHG_THISITEMCELLVALUE ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISITEMCELLVALUE ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos21( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISITEMCELLWIDTH ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISITEMCELLWIDTH ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos22( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISITEMCOLINDEX ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISITEMCOLINDEX ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos23( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISITEMROWINDEX ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISITEMROWINDEX ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos24( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISOBJECT ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISOBJECT ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos25( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISQUERYCOLINDEX ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISQUERYCOLINDEX ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos26( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISQUERYDATA ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISQUERYDATA ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos27( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISQUERYROWINDEX ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISQUERYROWINDEX ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos28( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_THISTYPE ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_THISTYPE ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos29( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      ::aVars[ NDX_OOHG_MAIN_ICON ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_MAIN_ICON ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos30( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::MultipleInstances( uValue, .F. )
   ENDIF
   uRet := ::aVars[ NDX_OOHG_MULTIPLEINSTANCES ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos31( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_APP_CARGO ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_APP_CARGO ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos32( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_BROWSE_SYNCSTATUS ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_BROWSE_SYNCSTATUS ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos33( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_BROWSE_FIXEDBLOCKS ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_BROWSE_FIXEDBLOCKS ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos34( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_BROWSE_FIXEDCONTROLS ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_BROWSE_FIXEDCONTROLS ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos35( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_XBROWSE_FIXEDBLOCKS ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_XBROWSE_FIXEDBLOCKS ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos36( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_XBROWSE_FIXEDCONTROLS ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_XBROWSE_FIXEDCONTROLS ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos37( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_GRID_FIXEDCONTROLS ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_GRID_FIXEDCONTROLS ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos38( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_ERRORLEVEL ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_ERRORLEVEL ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos39( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_WINRELEASESAMEORDER ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_WINRELEASESAMEORDER ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos40( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      ::aVars[ NDX_OOHG_INITTGRIDCONTROLDATAS ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_INITTGRIDCONTROLDATAS ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos41( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_COMBOREFRESH ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_COMBOREFRESH ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos42( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_SAVEASDWORD ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_SAVEASDWORD ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos43( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF uValue != NIL
      ::aVars[ NDX_OOHG_ACTIVEINIFILE ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_ACTIVEINIFILE ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos44( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      ::aVars[ NDX_OOHG_ACTIVEMESSAGEBAR ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_ACTIVEMESSAGEBAR ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos45( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   uRet := ::aVars[ NDX_OOHG_BKEYDOWN ]
   IF PCount() > 0
      ::aVars[ NDX_OOHG_BKEYDOWN ] := iif( HB_ISBLOCK( uValue ), uValue, NIL )
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos47( uValue ) CLASS TApplication

   LOCAL uRet

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      ::aVars[ NDX_OOHG_DEFAULTSTATUSBARMSG ] := uValue
   ENDIF
   uRet := ::aVars[ NDX_OOHG_DEFAULTSTATUSBARMSG ]
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value_Pos48( uValue ) CLASS TApplication

   LOCAL i, uRet

   hb_mutexLock( ::hClsMtx )
   IF HB_ISARRAY( uValue )
      IF Len( uValue ) < 28
         ASize( uValue, 28 )
      ENDIF
      FOR i := 1 TO 28
         IF uValue[ i ] == NIL
            uValue[ i ] := ::aVars[ NDX_OOHG_DEFAULTMENUPARAMS ][ i ]
         ENDIF
      NEXT i
      ::aVars[ NDX_OOHG_DEFAULTMENUPARAMS ] := AClone( uValue )
   ENDIF
   uRet := AClone( ::aVars[ NDX_OOHG_DEFAULTMENUPARAMS ] )
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Width( nWidth ) CLASS TApplication

   LOCAL oMain, uRet := NIL

   hb_mutexLock( ::hClsMtx )
   IF PCount() > 0
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Width( nWidth )
      ENDIF
   ELSE
      oMain := ::aVars[ NDX_OOHG_MAIN ]
      IF HB_ISOBJECT( oMain )
         uRet := oMain:Width()
      ENDIF
   ENDIF
   hb_mutexUnlock( ::hClsMtx )

   RETURN ( uRet )

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION GetCommandLineArgs

   LOCAL i, nCount, aArgs

   nCount := hb_argc()
   aArgs := {}
   FOR i := 1 TO nCount
      aAdd( aArgs, hb_argv( i ) )
   NEXT i

   RETURN ( aArgs )

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#ifndef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif
#if ( _WIN32_IE < 0x0500 )
   #undef _WIN32_IE
   #define _WIN32_IE 0x0500
#endif

#ifndef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif
#if ( _WIN32_WINNT < 0x0501 )
   #undef _WIN32_WINNT
   #define _WIN32_WINNT 0x0501
#endif

#include <windows.h>
#include <hbapi.h>

static HANDLE hGlobalMutex = NULL;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC_STATIC( TAPPLICATION_CREATEGLOBALMUTEX )
{
   if( ! hGlobalMutex )
   {
      hGlobalMutex = CreateMutex( NULL, FALSE, NULL );
   }
   hb_retl( hGlobalMutex != NULL );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HANDLE _OOHG_GlobalMutex( void )
{
   return hGlobalMutex;
}

#pragma ENDDUMP
