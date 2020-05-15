/*
 * $Id: h_dialogs.prg $
 */
/*
 * ooHG source code:
 * Miscelaneous dialogs functions
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetColor( uInitColor, uCustomColors )

   LOCAL aRetVal, nColor, nInitColor, v

   IF HB_ISARRAY( uInitColor )
      nInitColor := RGB( uInitColor[ 1 ], uInitColor[ 2 ], uInitColor[ 3 ] )
   ELSEIF HB_ISNUMERIC( uInitColor )
      nInitColor := uInitColor
   ENDIF
   IF HB_ISNUMERIC( uCustomColors )
      nColor := uCustomColors
      uCustomColors := Array( 16 )
      AFill( uCustomColors, nColor )
   ELSEIF HB_ISARRAY( uCustomColors )
      ASize( uCustomColors, 16 )
      FOR EACH v IN uCustomColors
         IF HB_ISNUMERIC( v )
            // OK
         ELSEIF HB_ISARRAY( v )
            v := RGB( v[ 1 ], v[ 2 ], v[ 3 ] )
         ELSE
            v := -1   // Defaults to COLOR_BTNFACE
         ENDIF
      NEXT
   ELSE
      uCustomColors := Array( 16 )
      AFill( uCustomColors, -1 )
   ENDIF

   nColor := ChooseColor( NIL, nInitColor, uCustomColors )

   IF nColor == -1
      aRetVal := { NIL, NIL, NIL }
   ELSE
      aRetVal := { GetRed( nColor ), GetGreen( nColor ), GetBlue( nColor ) }
   ENDIF

   RETURN aRetVal

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetFolder( cTitle, cInitPath )

   RETURN C_Browseforfolder( NIL, cTitle, NIL, NIL, cInitPath )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION BrowseForFolder( nFolder, nFlag, cTitle, cInitPath ) // Contributed By Ryszard Rylko

   RETURN C_BrowseForFolder( NIL, cTitle, nFlag, nFolder, cInitPath )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetFile( aFilter, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )

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
      RETURN C_GetFile( c, title, cIniFolder, multiselect, nochangedir, cDefaultFileName, hidereadonly )
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

   RETURN FilesList

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION Putfile( aFilter, title, cIniFolder, nochangedir, cDefaultFileName, lForceExt )

   Local c := ''

   If HB_IsArray( aFilter )
      aEval( aFilter, { |a| c += a[ 1 ] + Chr( 0 ) + a[ 2 ] + Chr( 0 ) } )
   EndIf

   RETURN C_PutFile( c, title, cIniFolder, nochangedir, cDefaultFileName, lForceExt )

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION GetFont( cInitFontName, nInitFontSize, lBold, lItalic, anInitColor, lUnderLine, lStrikeOut, nCharset )

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
      RetArray[ 5 ] := { NIL, NIL, NIL }
   EndIf

   RETURN RetArray
