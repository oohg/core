/*
 * $Id: h_media.prg,v 1.2 2005-08-26 06:04:16 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG multimedia functions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
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
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
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
---------------------------------------------------------------------------*/

#include "oohg.ch"
#include "hbclass.ch"

CLASS TPlayer FROM TControl
   DATA Type      INIT "PLAYER" READONLY

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

*-----------------------------------------------------------------------------*
Function _DefinePlayer(ControlName,ParentForm,file,col,row,w,h,noasw,noasm,noed,nom,noo,nop,sha,shm,shn,shp , HelpId )
*-----------------------------------------------------------------------------*
Local hh
Local Self

   Self := TPlayer():SetForm( ControlName, ParentForm )

   Hh :=InitPlayer ( ::Parent:hWnd  , ;
				file 				, ;
				col 				, ;
				row				, ;
				w				, ;
				h				, ;
				noasw				, ;
				noasm				, ;
				noed				, ;
				nom				, ;
				noo				, ;
				nop				, ;
				sha				, ;
				shm				, ;
				shn				, ;
				shp )

   ::New( hh, ControlName, HelpId )
   ::SizePos( row, col, w, h )

Return Nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TPlayer
*-----------------------------------------------------------------------------*
   mcifunc( ::hWnd, 5 )
RETURN ::Super:Release()

*-----------------------------------------------------------------------------*
METHOD Volume( nVolume ) CLASS TPlayer
*-----------------------------------------------------------------------------*
   IF VALTYPE( nVolume ) == "N"
      mcifunc( ::hWnd, 15, nVolume )
   ENDIF
Return mcifunc( ::hWnd, 19 )

*-----------------------------------------------------------------------------*
METHOD Position( nPosition ) CLASS TPlayer
*-----------------------------------------------------------------------------*
   IF VALTYPE( nPosition ) == "N"
      mcifunc( ::hWnd, 20, nPosition )
   ENDIF
Return mcifunc( ::hWnd, 18 )

*-----------------------------------------------------------------------------*
Function PlayWave(wave,r,s,ns,l,nd)
*-----------------------------------------------------------------------------*
	if PCount() == 1
		r := .F.
		s := .F.
		ns := .F.
		l := .F.
		nd := .F.
	endif

	c_PlayWave(wave,r,s,ns,l,nd)
Return Nil

*-----------------------------------------------------------------------------*
Function PlayWaveFromResource(wave)
*-----------------------------------------------------------------------------*
	c_PlayWave(wave,.t.,.f.,.f.,.f.,.f.)
Return Nil





CLASS TAnimateBox FROM TControl
   DATA Type      INIT "ANIMATEBOX" READONLY

   METHOD Release

   METHOD Open(File)         BLOCK { |Self,File| openanimate( ::hWnd, File ) }
   METHOD Play               BLOCK { |Self| playanimate( ::hWnd ) }
   METHOD Stop               BLOCK { |Self| stopanimate( ::hWnd ) }
   METHOD Close              BLOCK { |Self| closeanimate( ::hWnd ) }
   METHOD Seek(Frame)        BLOCK { |Self,Frame| seekanimate( ::hWnd, Frame ) }
ENDCLASS

*-----------------------------------------------------------------------------*
Function _DefineAnimateBox(ControlName,ParentForm,col,row,w,h,autoplay,center,transparent,file , HelpId )
*-----------------------------------------------------------------------------*
Local hh
Local Self

   Self := TAnimateBox():SetForm( ControlName, ParentForm )

   hh:=InitAnimate(::Parent:hWnd,col,row,w,h,autoplay,center,transparent)

   ::New( hh, ControlName, HelpId )
   ::SizePos( row, col, w, h )

	if valtype(file) <> 'U'
      ::Open( File )
	EndIf

Return Nil

*-----------------------------------------------------------------------------*
METHOD Release() CLASS TAnimateBox
*-----------------------------------------------------------------------------*
   destroyanimate( ::hWnd )
RETURN ::Super:Release()