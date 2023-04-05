/*
 * $Id: h_media.prg $
 */
/*
 * OOHG source code:
 * Multimedia Player and AnimateBox controls
 *
 * Copyright 2005-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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
#include "hbclass.ch"
#include "i_windefs.ch"
#include "i_init.ch"

CLASS TPlayer FROM TControl

   DATA Type      INIT "PLAYER" READONLY

   METHOD Define
   METHOD Release

   METHOD Play()             BLOCK { |Self| mcifunc( ::hWnd,  1 ) }
   METHOD Stop()             BLOCK { |Self| mcifunc( ::hWnd,  2 ) }
   METHOD Pause()            BLOCK { |Self| mcifunc( ::hWnd,  3 ) }
   METHOD Close()            BLOCK { |Self| mcifunc( ::hWnd,  4 ) }
   METHOD Eject()            BLOCK { |Self| mcifunc( ::hWnd,  6 ) }
   METHOD PositionEnd()      BLOCK { |Self| mcifunc( ::hWnd,  7 ) }
   METHOD PositionHome()     BLOCK { |Self| mcifunc( ::hWnd,  8 ) }
   METHOD Open(File)         BLOCK { |Self,File| mcifunc( ::hWnd,  9, File ) }
   METHOD OpenDialog()       BLOCK { |Self| mcifunc( ::hWnd, 10 ) }
   METHOD PlayReverse()      BLOCK { |Self| mcifunc( ::hWnd, 11 ) }
   METHOD Resume()           BLOCK { |Self| mcifunc( ::hWnd, 12 ) }
   METHOD Repeat(Status)     BLOCK { |Self,Status| mcifunc( ::hWnd, 13, Status ) }
   METHOD RepeatOn()         BLOCK { |Self| mcifunc( ::hWnd, 13, .t. ) }
   METHOD RepeatOff()        BLOCK { |Self| mcifunc( ::hWnd, 13, .f. ) }
   METHOD Speed(Speed)       BLOCK { |Self,Speed| mcifunc( ::hWnd, 14, Speed ) }
   METHOD Zoom(Zoom)         BLOCK { |Self,Zoom| mcifunc( ::hWnd, 16, Zoom ) }
   METHOD Length()           BLOCK { |Self| mcifunc( ::hWnd, 17 ) }
   METHOD Volume             SETGET
   METHOD Position           SETGET

   ENDCLASS

METHOD Define( ControlName, ParentForm, file, col, row, w, h, noasw, noasm, ;
               noed, nom, noo, nop, sha, shm, shn, shp, HelpId, Invisible, ;
               NoTabStop, lDisabled, lRtl ) CLASS TPlayer

   Local hh, nStyle

   ASSIGN ::nCol    VALUE col TYPE "N"
   ASSIGN ::nRow    VALUE row TYPE "N"
   ASSIGN ::nWidth  VALUE w   TYPE "N"
   ASSIGN ::nHeight VALUE h   TYPE "N"

   ::SetForm( ControlName, ParentForm,,,,,, lRtl )

   IF HB_IsLogical( sha ) .AND. sha
      shm := shn := shp := .T.
   ENDIF

   nStyle := ::InitStyle( ,, Invisible, NoTabStop, lDisabled ) + ;
             WS_CHILD + WS_BORDER + ;
             IF( HB_IsLogical( noasw ) .AND. noasw, MCIWNDF_NOAUTOSIZEWINDOW,  0 ) + ;
             IF( HB_IsLogical( noasm ) .AND. noasm, MCIWNDF_NOAUTOSIZEMOVIE,  0 ) + ;
             IF( HB_IsLogical( noed )  .AND. noed, MCIWNDF_NOERRORDLG,  0 ) + ;
             IF( HB_IsLogical( nom ) .AND. nom, MCIWNDF_NOMENU,  0 ) + ;
             IF( HB_IsLogical( noo ) .AND. noo, MCIWNDF_NOOPEN,  0 ) + ;
             IF( HB_IsLogical( nop ) .AND. nop, MCIWNDF_NOPLAYBAR,  0 ) + ;
             IF( HB_IsLogical( shm ) .AND. shm, MCIWNDF_SHOWMODE,  0 ) + ;
             IF( HB_IsLogical( shn ) .AND. shn, MCIWNDF_SHOWNAME,  0 ) + ;
             IF( HB_IsLogical( shp ) .AND. shp, MCIWNDF_SHOWPOS,  0 )

   hh := InitPlayer ( ::ContainerhWnd, file, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle )
   IF ! ValidHandler( hh )
      MsgExclamation( _OOHG_Messages( MT_MISCELL, 29 ), _OOHG_Messages( MT_MISCELL, 9 ) )
   ENDIF

   ::Register( hh, ControlName, HelpId )

   Return Self

METHOD Release() CLASS TPlayer

   mcifunc( ::hWnd, 5 )

   RETURN ::Super:Release()

METHOD Volume( nVolume ) CLASS TPlayer

   IF HB_IsNumeric( nVolume )
      mcifunc( ::hWnd, 15, nVolume )
   ENDIF

   Return mcifunc( ::hWnd, 19 )

METHOD Position( nPosition ) CLASS TPlayer

   IF HB_IsNumeric( nPosition )
      mcifunc( ::hWnd, 20, nPosition )
   ENDIF

   Return mcifunc( ::hWnd, 18 )

FUNCTION PlayWave( wave, r, s, ns, l, nd )

   IF PCount() == 1
      r := .F.
      s := .F.
      ns := .F.
      l := .F.
      nd := .F.
   ENDIF

   C_PlayWave( wave, r, s, ns, l, nd )

   RETURN NIL

FUNCTION PlayWaveFromResource( wave )

   C_PlayWave( wave, .T., .F., .F., .F., .F. )

   RETURN NIL


CLASS TAnimateBox FROM TControl

   DATA Type      INIT "ANIMATEBOX" READONLY

   METHOD Define

   METHOD Release            BLOCK { |Self| destroyanimate( ::hWnd ) , ::Super:Release() }
   METHOD Open(File)         BLOCK { |Self,File| openanimate( ::hWnd, File ) }
   METHOD Play               BLOCK { |Self| PlayAnimate( ::hWnd ) }
   METHOD Stop               BLOCK { |Self| stopanimate( ::hWnd ) }
   METHOD Close              BLOCK { |Self| closeanimate( ::hWnd ) }
   METHOD Seek(Frame)        BLOCK { |Self,Frame| seekanimate( ::hWnd, Frame ) }

   ENDCLASS

METHOD Define( ControlName, ParentForm, nCol, nRow, nWidth, nHeight, lAutoplay, ;
               lCenter, lTransparent, cFile, nHelpId, lInvisible, lNoTabStop, ;
               lDisabled, lRtl, cToolTip ) CLASS TAnimateBox

   Local hh, nStyle

   ASSIGN ::nCol    VALUE nCol    TYPE "N"
   ASSIGN ::nRow    VALUE nRow    TYPE "N"
   ASSIGN ::nWidth  VALUE nWidth  TYPE "N"
   ASSIGN ::nHeight VALUE nHeight TYPE "N"

   ::SetForm( ControlName, ParentForm, , , , , , lRtl )

   nStyle := ::InitStyle( , , lInvisible, lNoTabStop, lDisabled ) + ;
             WS_CHILD + WS_BORDER + ;
             If( HB_IsLogical( lAutoplay ) .AND. lAutoplay, ACS_AUTOPLAY, 0 ) + ;
             If( HB_IsLogical( lCenter ) .AND. lCenter, ACS_CENTER, 0 ) + ;
             If( HB_IsLogical( lTransparent ) .AND. lTransparent, ACS_TRANSPARENT, 0 )

   hh := InitAnimate( ::ContainerhWnd, ::ContainerCol, ::ContainerRow, ::Width, ::Height, nStyle )
   IF ! ValidHandler( hh )
      MsgExclamation( _OOHG_Messages( MT_MISCELL, 30 ), _OOHG_Messages( MT_MISCELL, 9 ) )
   ENDIF

   ::Register( hh, ControlName, nHelpId, , cToolTip )

   If ValType( cFile ) <> 'U'
      ::Open( cFile )
   EndIf

   Return Self


EXTERN MCIFUNC

#pragma BEGINDUMP

#include "oohg.h"
#include <vfw.h>

/* This fixes a warning over dwICValue */
HB_FUNC( ICGETDEFAULTQUALITY )
{
   HB_RETNL( ICGetDefaultQuality( HICparam( 1 ) ) );
}

HB_FUNC( ICGETDEFAULTKEYFRAMERATE )
{
   hb_retnl( ICGetDefaultKeyFrameRate( HICparam( 1 ) ) );
}

HB_FUNC( INITANIMATE )
{
   HWND hWnd = Animate_Create( HWNDparam( 1 ), NULL, hb_parni( 6 ), GetModuleHandle( NULL ) );

   if( hWnd )
   {
      MoveWindow( hWnd, hb_parnl( 2 ), hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ), TRUE );
   }

   HWNDret( hWnd );
}

HB_FUNC( OPENANIMATE )
{
   Animate_Open( HWNDparam( 1 ), (LPTSTR) HB_UNCONST( hb_parc( 2 ) ) );
}

HB_FUNC( PLAYANIMATE )
{
   Animate_Play( HWNDparam( 1 ), 0, -1, 1 );
}

HB_FUNC( SEEKANIMATE )
{
   Animate_Seek( HWNDparam( 1 ), hb_parni(2));
}

HB_FUNC( STOPANIMATE )
{
   Animate_Stop( HWNDparam( 1 ) );
}

HB_FUNC( CLOSEANIMATE )
{
   Animate_Close( HWNDparam( 1 ) );
}

HB_FUNC( DESTROYANIMATE )
{
   DestroyWindow( HWNDparam( 1 ) );
}

HB_FUNC( INITPLAYER )
{
   HWND hWnd = MCIWndCreate( HWNDparam( 1 ), NULL, hb_parni( 7 ), hb_parc( 2 ) );

   if( hWnd )
   {
      MoveWindow( hWnd, hb_parnl( 3 ), hb_parnl( 4 ), hb_parnl( 5 ), hb_parnl( 6 ), TRUE );
   }

   HWNDret( hWnd );
}

HB_FUNC( MCIFUNC )
{
   HWND mcihand = HWNDparam( 1 );
   int  func = hb_parni( 2 );

   switch( func )
   {
      case  1: HB_RETNL( MCIWndPlay( mcihand ) ); break;
      case  2: HB_RETNL( MCIWndStop( mcihand ) ); break;
      case  3: HB_RETNL( MCIWndPause( mcihand ) ); break;
      case  4: HB_RETNL( MCIWndClose( mcihand ) ); break;
      case  5:           MCIWndDestroy( mcihand ); HB_RETNL( 0 ); break;
      case  6: HB_RETNL( MCIWndEject( mcihand ) ); break;
      case  7: HB_RETNL( MCIWndEnd( mcihand ) ); break;
      case  8: HB_RETNL( MCIWndHome( mcihand ) ); break;
      case  9: HB_RETNL( MCIWndOpen( mcihand, (LPTSTR) HB_UNCONST( hb_parc( 3 ) ), 0 ) ); break;
      case 10: HB_RETNL( MCIWndOpenDialog( mcihand ) ); break;
      case 11: HB_RETNL( MCIWndPlayReverse( mcihand ) ); break;
      case 12: HB_RETNL( MCIWndResume( mcihand ) ); break;
      case 13:           MCIWndSetRepeat( mcihand, hb_parl( 3 ) ); HB_RETNL( 0 ); break;
      case 14: HB_RETNL( MCIWndSetSpeed( mcihand, hb_parni( 3 ) ) ); break;
      case 15: HB_RETNL( MCIWndSetVolume( mcihand, hb_parni( 3 ) ) ); break;
      case 16:           MCIWndSetZoom( mcihand, hb_parni( 3 ) ); HB_RETNL( 0 ); break;
      case 17: HB_RETNL( MCIWndGetLength( mcihand ) ); break;
      case 18: HB_RETNL( MCIWndGetPosition( mcihand ) ); break;
      case 19: HB_RETNL( MCIWndGetVolume( mcihand ) ); break;
      case 20: HB_RETNL( MCIWndSeek( mcihand, hb_parni( 3 ) ) ); HB_RETNL( 0 ); break;
      default: HB_RETNL( 0 );
   }
}

#pragma ENDDUMP
