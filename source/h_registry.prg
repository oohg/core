/*
 * $Id: h_registry.prg,v 1.1 2005-08-07 00:12:51 guerra000 Exp $
 */
/*
 * ooHG source code:
 * PRG registry functions
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
/*
	Class TReg32 for (x)Harbour
*/

#include "hbclass.ch"

CLASS TReg32

   DATA cRegKey, nKey, nHandle, nError, lError

   METHOD New( nKey, cRegKey, lShowError )

   METHOD Create( nKey, cRegKey, lShowError )

   METHOD Get( cSubKey, uVar )

   METHOD Set( cSubKey, uVar )

   METHOD Delete( cSubKey )

   METHOD KeyDelete( cSubKey )

   METHOD Close()    BLOCK {| Self | If( ::lError, , RegCloseKey( ::nHandle ) ) }

ENDCLASS


METHOD New( nKey, cRegKey, lShowError ) CLASS TReg32

   local nReturn,nHandle := 0

   cRegKey := If(cRegKey == nil,"",cRegKey ) ;

   nReturn := RegOpenKeyExA(nKey,cRegKey,,63,@nHandle )

   ::cRegKey = cRegKey
   ::nHandle = nHandle

   if nReturn != 0
      ::lError := .t.
      IF lShowError=NIL .OR. lShowError
         MsgStop("Error creating TReg32 object ("+LTrim(Str(nReturn))+")" )
      ENDIF
   else
      ::lError := .f.
   endif

return Self


METHOD Create( nKey, cRegKey, lShowError ) CLASS TReg32

   local nReturn,nHandle := 0

   cRegKey := If(cRegKey == nil,"",cRegKey ) ;

   nReturn := RegCreateKey(nKey,cRegKey,@nHandle )

   if nReturn != 0
      ::lError := .t.
      IF lShowError=NIL .OR. lShowError
         MsgStop("Error creating TReg32 object ("+LTrim(Str(nReturn))+")" )
      ENDIF
   else
      ::lError := .f.
   endif

   ::nError := RegOpenKeyExA(nKey,cRegKey,,63,@nHandle )

   ::cRegKey = cRegKey
   ::nHandle = nHandle

return Self


METHOD Get( cSubkey, uVar ) CLASS TReg32

   local cValue := ""
   local nType := 0
   local nLen := 0
   local cType

   if !::lError

      cType := ValType(uVar )

      ::nError = RegQueryValueExA(::nHandle,cSubkey,0,@nType,@cValue,@nLen )
      uVar = cValue

      do case
         case cType == "D"
              uVar = CToD(uVar )

         case cType == "L"
              uVar = (Upper(uVar ) == ".T." )

         case cType == "N"
              uVar = Val(uVar )
      endcase

   endif

return uVar


METHOD Set( cSubKey, uVar ) CLASS TReg32

   local nType,nLen,cType

   if !::lError

      cType := ValType(uVar )

      nType = 1
      do case
         case cType == "D"
              uVar = DToC(uVar )

         case cType == "L"
              uVar := If(uVar,".T.",".F." )
      endcase
      nLen = Len(uVar )
      ::nError = RegSetValueExA(::nHandle,cSubkey,0,nType,@uVar,nLen )

   endif

return nil


METHOD Delete( cSubKey ) CLASS TReg32

   if !::lError

      ::nError = RegDeleteValueA(::nHandle,cSubkey )

   endif

return nil


METHOD KeyDelete( cSubKey ) CLASS TReg32

   if !::lError

      ::nError = RegDeleteKey(::nHandle,cSubkey )

   endif

return nil