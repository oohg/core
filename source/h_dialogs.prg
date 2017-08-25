/*
 * $Id: h_dialogs.prg,v 1.19 2017-08-25 19:42:18 fyurisich Exp $
 */
/*
 * ooHG source code:
 * Miscelaneous dialogs functions
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

*------------------------------------------------------------------------------*
Function GetColor( aInitColor )
*------------------------------------------------------------------------------*
Local aRetVal, nColor, nInitColor

   If HB_IsArray( aInitColor )
      nInitColor := RGB( aInitColor[ 1 ], aInitColor[ 2 ], aInitColor[ 3 ] )
   ElseIf HB_IsNumeric( aInitColor )
      nInitColor := aInitColor
   EndIf

   nColor := ChooseColor( Nil, nInitColor )

   If nColor == -1
      aRetVal := { Nil, Nil, Nil }
   Else
      aRetVal := { GetRed( nColor ), GetGreen( nColor ), GetBlue( nColor ) }
   EndIf

   HB_SYMBOL_UNUSED( _OOHG_AllVars )
Return aRetVal

*------------------------------------------------------------------------------*
Function GetFolder( cTitle, cInitPath )
*------------------------------------------------------------------------------*
Return C_Browseforfolder( Nil, cTitle, Nil, Nil, cInitPath )

*------------------------------------------------------------------------------*
Function BrowseForFolder( nFolder, nFlag, cTitle, cInitPath ) // Contributed By Ryszard Rylko
*------------------------------------------------------------------------------*
Return C_BrowseForFolder( Nil, cTitle, nFlag, nFolder, cInitPath )

*------------------------------------------------------------------------------*
Function GetFile( aFilter, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )
*------------------------------------------------------------------------------*
Local c := ''
Local cFiles
Local FilesList := {}
Local n

   If HB_IsArray( aFilter )
      aEval( aFilter, { |a| c += a[ 1 ] + Chr( 0 ) + a[ 2 ] + Chr( 0 ) } )
   EndIf

   If ! HB_IsLogical( multiselect )
      multiselect := .f.
   EndIf

   If ! multiselect
      Return C_GetFile( c, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )
   EndIf

   cFiles := C_GetFile( c, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )

   If Len( cFiles ) > 0
      If HB_IsArray( cFiles )
         For n := 1 To Len( cFiles )
            If At( "\\", cFiles[ n ] ) > 0
               cFiles[ n ] := StrTran( cFiles[ n ], "\\", "\" )
            EndIf
         Next
         FilesList := aClone( cFiles )
      Else
         aAdd( FilesList, cFiles )
      Endif
   Endif

Return FilesList

*------------------------------------------------------------------------------*
Function Putfile( aFilter, title, cIniFolder, nochangedir, cDefaultFileName, lForceExt )
*------------------------------------------------------------------------------*
Local c := ''

   If HB_IsArray( aFilter )
      aEval( aFilter, { |a| c += a[ 1 ] + Chr( 0 ) + a[ 2 ] + Chr( 0 ) } )
   EndIf

Return C_PutFile( c, title, cIniFolder, nochangedir, cDefaultFileName, lForceExt )

*------------------------------------------------------------------------------*
Function GetFont( cInitFontName, nInitFontSize, lBold, lItalic, anInitColor, lUnderLine, lStrikeOut, nCharset )
*------------------------------------------------------------------------------*
Local RetArray, Tmp, rgbcolor

   If ! HB_IsString ( cInitFontName )
      cInitFontName := ""
   EndIf

   If ! HB_Isnumeric ( nInitFontSize )
      nInitFontSize := 0
   EndIf

   If ! HB_IsLogical( lBold )
      lBold := .F.
   EndIf

   If ! HB_IsLogical ( lItalic )
      lItalic := .F.
   EndIf

   If ! HB_IsArray ( anInitColor )
      rgbcolor := 0
   Else
      rgbcolor := RGB( anInitColor[1], anInitColor[2], anInitColor[3] )
   EndIf

   If ! HB_IsLogical ( lUnderLine )
      lUnderLine := .F.
   EndIf

   If ! HB_IsLogical ( lStrikeOut )
      lStrikeOut := .F.
   EndIf

   If ! HB_IsNumeric ( nCharSet )
      nCharSet := 0
   EndIf

   RetArray := ChooseFont( cInitFontName, nInitFontSize, lBold, lItalic, rgbcolor, lUnderLine, lStrikeOut, nCharSet )

   If ! Empty( RetArray[ 1 ] )
      Tmp := RetArray[ 5 ]
      RetArray[ 5 ] := { GetRed( Tmp ), GetGreen( Tmp ), GetBlue( Tmp ) }
   Else
      RetArray[ 5 ] := { Nil, Nil, Nil }
   EndIf

Return RetArray
