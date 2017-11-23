/*
* $Id: h_dialogs.prg $
*/
/*
* ooHG source code:
* Miscelaneous dialogs functions
* Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
* https://oohg.github.io/
* Portions of this project are based upon Harbour MiniGUI library.
* Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
* Portions of this project are based upon Harbour GUI framework for Win32.
* Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
* Copyright 2001 Antonio Linares <alinares@fivetech.com>
* Portions of this project are based upon Harbour Project.
* Copyright 1999-2017, https://harbour.github.io/
*/
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this software; see the file LICENSE.txt. If not, write to
* the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
* As a special exception, the ooHG Project gives permission for
* additional uses of the text contained in its release of ooHG.
* The exception is that, if you link the ooHG libraries with other
* files to produce an executable, this does not by itself cause the
* resulting executable to be covered by the GNU General Public License.
* Your use of that executable is in no way restricted on account of
* linking the ooHG library code into it.
* This exception does not however invalidate any other reasons why
* the executable file might be covered by the GNU General Public License.
* This exception applies only to the code released by the ooHG
* Project under the name ooHG. If you copy code from other
* ooHG Project or Free Software Foundation releases into a copy of
* ooHG, as the General Public License permits, the exception does
* not apply to the code that you add in this way. To avoid misleading
* anyone as to the status of such modified files, you must delete
* this exception notice from them.
* If you write modifications of your own for ooHG, it is your choice
* whether to permit this exception to apply to your modifications.
* If you do not wish that, delete this exception notice.
*/

#include "oohg.ch"

FUNCTION GetColor( aInitColor )

   LOCAL aRetVal, nColor, nInitColor

   IF HB_IsArray( aInitColor )
      nInitColor := RGB( aInitColor[ 1 ], aInitColor[ 2 ], aInitColor[ 3 ] )
   ELSEIF HB_IsNumeric( aInitColor )
      nInitColor := aInitColor
   ENDIF

   nColor := ChooseColor( Nil, nInitColor )

   IF nColor == -1
      aRetVal := { Nil, Nil, Nil }
   ELSE
      aRetVal := { GetRed( nColor ), GetGreen( nColor ), GetBlue( nColor ) }
   ENDIF

   RETURN aRetVal

FUNCTION GetFolder( cTitle, cInitPath )

   RETURN C_Browseforfolder( Nil, cTitle, Nil, Nil, cInitPath )

FUNCTION BrowseForFolder( nFolder, nFlag, cTitle, cInitPath ) // Contributed By Ryszard Rylko

   RETURN C_BrowseForFolder( Nil, cTitle, nFlag, nFolder, cInitPath )

FUNCTION GetFile( aFilter, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )

   LOCAL c := ''
   LOCAL cFiles
   LOCAL FilesList := {}
   LOCAL n

   IF HB_IsArray( aFilter )
      aEval( aFilter, { |a| c += a[ 1 ] + Chr( 0 ) + a[ 2 ] + Chr( 0 ) } )
   ENDIF

   IF ! HB_IsLogical( multiselect )
      multiselect := .f.
   ENDIF

   IF ! multiselect

      RETURN C_GetFile( c, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )
   ENDIF

   cFiles := C_GetFile( c, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )

   IF Len( cFiles ) > 0
      IF HB_IsArray( cFiles )
         FOR n := 1 To Len( cFiles )
            IF At( "\\", cFiles[ n ] ) > 0
               cFiles[ n ] := StrTran( cFiles[ n ], "\\", "\" )
            ENDIF
         NEXT
         FilesList := aClone( cFiles )
      ELSE
         aAdd( FilesList, cFiles )
      ENDIF
   ENDIF

   RETURN FilesList

FUNCTION Putfile( aFilter, title, cIniFolder, nochangedir, cDefaultFileName, lForceExt )

   LOCAL c := ''

   IF HB_IsArray( aFilter )
      aEval( aFilter, { |a| c += a[ 1 ] + Chr( 0 ) + a[ 2 ] + Chr( 0 ) } )
   ENDIF

   RETURN C_PutFile( c, title, cIniFolder, nochangedir, cDefaultFileName, lForceExt )

FUNCTION GetFont( cInitFontName, nInitFontSize, lBold, lItalic, anInitColor, lUnderLine, lStrikeOut, nCharset )

   LOCAL RetArray, Tmp, rgbcolor

   IF ! HB_IsString ( cInitFontName )
      cInitFontName := ""
   ENDIF

   IF ! HB_Isnumeric ( nInitFontSize )
      nInitFontSize := 0
   ENDIF

   IF ! HB_IsLogical( lBold )
      lBold := .F.
   ENDIF

   IF ! HB_IsLogical ( lItalic )
      lItalic := .F.
   ENDIF

   IF ! HB_IsArray ( anInitColor )
      rgbcolor := 0
   ELSE
      rgbcolor := RGB( anInitColor[1], anInitColor[2], anInitColor[3] )
   ENDIF

   IF ! HB_IsLogical ( lUnderLine )
      lUnderLine := .F.
   ENDIF

   IF ! HB_IsLogical ( lStrikeOut )
      lStrikeOut := .F.
   ENDIF

   IF ! HB_IsNumeric ( nCharSet )
      nCharSet := 0
   ENDIF

   RetArray := ChooseFont( cInitFontName, nInitFontSize, lBold, lItalic, rgbcolor, lUnderLine, lStrikeOut, nCharSet )

   IF ! Empty( RetArray[ 1 ] )
      Tmp := RetArray[ 5 ]
      RetArray[ 5 ] := { GetRed( Tmp ), GetGreen( Tmp ), GetBlue( Tmp ) }
   ELSE
      RetArray[ 5 ] := { Nil, Nil, Nil }
   ENDIF

   RETURN RetArray
