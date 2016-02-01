/*
 * $Id: h_dialogs.prg,v 1.15 2016-02-01 00:03:38 fyurisich Exp $
 */
/*
 * ooHG source code:
 * PRG dialogs functions
 *
 * Copyright 2005-2015 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.oohg.org
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

*-----------------------------------------------------------------------------*
Function GetColor( aInitColor )
*-----------------------------------------------------------------------------*
Local aRetVal, nColor, nInitColor

   If HB_IsArray( aInitColor )
      nInitColor := RGB( aInitColor[ 1 ], aInitColor[ 2 ], aInitColor[ 3 ] )
   ElseIf HB_IsNumeric( aInitColor )
      nInitColor := aInitColor
   EndIf

   nColor := ChooseColor( NIL, nInitColor )

   If nColor == -1
      aRetVal := { Nil, Nil, Nil }
   Else
      aRetVal := { GetRed( nColor ), GetGreen( nColor ), GetBlue( nColor ) }
   EndIf

   EMPTY( _OOHG_AllVars )
Return aRetVal

*-----------------------------------------------------------------------------*
Function GetFolder( cTitle, cInitPath )
*-----------------------------------------------------------------------------*
Return C_Browseforfolder( NIL, cTitle, NIL, NIL, cInitPath )

*-----------------------------------------------------------------------------*
Function browseforfolder(nFolder, nFlag, cTitle, cInitPath) // Contributed By Ryszard Rylko
*-----------------------------------------------------------------------------*
Return C_BrowseForFolder( NIL, cTitle, nFlag, nFolder, cInitPath )

*-----------------------------------------------------------------------------*
Function GetFile( aFilter, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )
*-----------------------------------------------------------------------------*
local c := ''
local cfiles
local fileslist := {}
local n

   If HB_IsArray( aFilter )
      AEVAL( aFilter, { |a| c += a[ 1 ] + CHR( 0 ) + a[ 2 ] + CHR( 0 ) } )
   EndIf

   If ! HB_IsLogical( multiselect )
      multiselect := .f.
   EndIf

   If ! multiselect
      Return C_GetFile( c, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )
   Else
      cfiles := C_GetFile( c, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )

      If len( cfiles ) > 0
         If HB_IsArray( cfiles )
            FOR n := 1 TO LEN( cfiles )
               If At( "\\", cfiles[n] ) > 0
                  cfiles[ n ] := strtran( cfiles[ n ] , "\\", "\" )
               EndIf
            NEXT
            fileslist := aclone( cfiles )
         Else
            aadd( fileslist, cfiles )
         Endif
      Endif

      Return ( fileslist )
   Endif

Return Nil

*-----------------------------------------------------------------------------*
Function Putfile( aFilter, title, cIniFolder, nochangedir, cDefaultFileName, lForceExt )
*-----------------------------------------------------------------------------*
local c := ''

   If HB_IsArray( aFilter )
      AEVAL( aFilter, { |a| c += a[ 1 ] + CHR( 0 ) + a[ 2 ] + CHR( 0 ) } )
   EndIf

Return C_PutFile( c, title, cIniFolder, nochangedir, cDefaultFileName, lForceExt )

*------------------------------------------------------------------------------*
Function GetFont( cInitFontName , nInitFontSize , lBold , lItalic , anInitColor , lUnderLine , lStrikeOut , nCharset )
*------------------------------------------------------------------------------*
Local RetArray, Tmp, rgbcolor

   If !HB_IsString ( cInitFontName )
      cInitFontName := ""
   EndIf

   If !HB_Isnumeric ( nInitFontSize )
      nInitFontSize := 0
   EndIf

   If !HB_IsLogical( lBold )
      lBold := .F.
   EndIf

   If !HB_IsLogical ( lItalic )
      lItalic := .F.
   EndIf

   If !HB_Isarray ( anInitColor )
      rgbcolor := 0
   Else
      rgbcolor := RGB( anInitColor[1] , anInitColor[2] , anInitColor[3] )
   EndIf

   If !HB_IsLogical ( lUnderLine )
      lUnderLine := .F.
   EndIf

   If !HB_IsLogical ( lStrikeOut )
      lStrikeOut := .F.
   EndIf

   If !HB_IsNumeric ( nCharSet )
      nCharSet := 0
   EndIf

   RetArray := ChooseFont( cInitFontName , nInitFontSize , lBold , lItalic , rgbcolor , lUnderLine , lStrikeOut , nCharSet )

   If ! Empty( RetArray[ 1 ] )
      Tmp := RetArray[ 5 ]
      RetArray[ 5 ] := { GetRed( Tmp ), GetGreen( Tmp ), GetBlue( Tmp ) }
   Else
      RetArray[ 5 ] := { Nil , Nil , Nil }
   EndIf

Return RetArray
