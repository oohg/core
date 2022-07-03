/*
 * $Id: h_button.prg $
 */
/*
 * OOHG source code:
 * Button and CheckButton controls
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

/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TButton FROM TControl

   DATA aImageMargin              INIT { 6, 10, 6, 10 }    // top, left, bottom, right
   DATA aTextMargin               INIT { 0, 0, 0, 0 }      // top, left, bottom, right
   DATA AutoFit                   INIT .F.
   DATA cBuffer                   INIT ""
   DATA cPicture                  INIT ""
   DATA hImage                    INIT NIL
   DATA ImageBkClr                INIT -1
   DATA ImageSize                 INIT .F.
   DATA lFitImg                   INIT .F.
   DATA lFitTxt                   INIT .F.
   DATA lLibDraw                  INIT .F.
   DATA lNo3DColors               INIT .F.
   DATA lNoDestroy                INIT .F.
   DATA lNoDIBSection             INIT .T.
   DATA lNoFocusRect              INIT .F.
   DATA lNoHotLight               INIT .F.
   DATA lNoImgLst                 INIT .F.
   DATA lNoTransparent            INIT .F.
   DATA lNoPrintOver              INIT .F.
   DATA lSolid                    INIT .F.
   DATA nAlign                    INIT BUTTON_IMAGELIST_ALIGN_LEFT
   DATA nHeight                   INIT 28
   DATA nTextAlign                INIT BS_CENTER + BS_VCENTER
   DATA nWidth                    INIT 100
   DATA Stretch                   INIT .F.
   DATA Type                      INIT "BUTTON" READONLY

   METHOD Buffer                  SETGET
   METHOD Define
   METHOD DefineImage
   METHOD Events_Enter
   METHOD Events_Notify
   METHOD lFocusRect              BLOCK { | Self, lValue | iif( HB_ISLOGICAL( lValue ), ::lNoFocusRect := ! lValue, ! ::lNoFocusRect ) }
   METHOD HBitMap                 SETGET
   METHOD ImageList               BLOCK { || NIL }
   METHOD ImageMargin             SETGET
   METHOD Picture                 SETGET
   METHOD Release
   METHOD RePaint
   METHOD SetFocus
   METHOD SizePos
   METHOD TextMargin              SETGET
   METHOD Value                   SETGET

   ENDCLASS

/*
   Layout of button with text and image placed at LEFT:

     button width (W)
   +--------------------------------------------------------+  b
   |    top margin               |     top margin           |  u
   | l +-------------------+ r   |    +---------------+ r   |  t.
   | e | image             | i   |  l |   text        | i   |
   | f | area              | g   |  e |   area        | g   |  h
   | t |                   | h   |  f |               | h   |  e
   |   |                   | t   |  t |               | t   |  i
   |   +-------------------+     |    +---------------+     |  g
   |    bottom margin            |     bottom margin        |  h
   |                             |                          |  t
   | IMAGEMARGIN {it,il,ib,ir}   | TEXTMARGIN {tt,tl,tb,tr} |
   |                             |                          |  (H)
   +--------------------------------------------------------+

   Note that when themes are enabled the area for the content is reduced by a 3 pixel margin.
   Note that when themes are not enabled or the painting is done by the OS then IMAGEMARGIN is ignored.

Image painting, see functions SetImageXP and TButton_Notify_CustomDraw:

   The image is always loaded at its full size.
   The image is drawn centered at the image area.
   The image has precedence over the text thus, if there's no room left, the text is not shown.
   In such case, you can use NOPRINTOVER clause to display the text over the image.

   IMAGESIZE: Button's size is adjusted to the image's size plus theme's margins.
              STRETCH, AUTOFIT AND FITIMG are ignored.
              Alignment is set to BUTTON_IMAGELIST_ALIGN_CENTER.

   FITIMG:    Sets ::lFitImg to .T.

   STRETCH:   Proportionally scales the image to button's rect ( minus aImageMargin if ::lFitImg is .T.)
              Has precedence over AUTOFIT.
   AUTOFIT:   Scales the image to button's rect (minus aImageMargin if ::lFitImg is .T.). Proportion may be lost.
   NONE:      The image is painted without scaling.

Image transparency:

   ICO images:
      a. color depth 24 bpp + alpha channel, or
      b. for other color depths, the BLACK color will be transparent.

   BMP images:
      a. color depth not greater than 8 bpp, and
         the color of the top-left pixel will be transparent
         if this color it at index 0 in the image's palette.
      b. for 32 bpp images, the BLACK color will be transparent.
         the color of the top-left pixel will be transparent
         if this color it at index 0 in the image's palette.

   JPG/JPEG/GIF images:
      a. whatever transparency is defined.

Text painting, see function TButton_Notify_CustomDraw:

   The text is placed inside the text area according to TEXTALIGN clause, defaults to ( DT_CENTER + DT_VCENTER ).
   FITTXT: The text is clipped into the text area.
   The image has precedence over the text thus, if there's no room left, the text is not shown.
   In such case, you can use NOPRINTOVER clause to displayed the text over the image.
*/

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, cCaption, bAction, nWidth, nHeight, cFontName, ;
          nFontSize, cToolTip, bGotFocus, bLostFocus, lFlat, lNoTabStop, nHelpId, lInvisible, lBold, ;
          lItalic, lUnderline, lStrikeOut, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, cImage, ;
          lNoLoadTrans, lStretch, lCancel, uAlign, lMultiLine, lDrawBy, aImageMargin, bMouseMove, ;
          lNo3DColors, lAutoFit, lNoDIB, uBackColor, lNoHotLight, lSolid, uFontColor, aTextAlign, ;
          lNoPrintOver, aTextMargin, lFitTxt, lFitImg, lImgSize, lTransparent, lNoFocusRect, ;
          lNoImgLst, lNoDestroy, lHand, lDefault ) CLASS TButton

   LOCAL nControlHandle, nStyle, lBitMap, i, nAlign, oTab

   ASSIGN ::nCol           VALUE nCol         TYPE "N"
   ASSIGN ::nRow           VALUE nRow         TYPE "N"
   ASSIGN ::nWidth         VALUE nWidth       TYPE "N"
   ASSIGN ::nHeight        VALUE nHeight      TYPE "N"
   ASSIGN ::lNoTransparent VALUE lNoLoadTrans TYPE "L"
   ASSIGN ::Stretch        VALUE lStretch     TYPE "L"
   ASSIGN ::lCancel        VALUE lCancel      TYPE "L"
   ASSIGN ::lNo3DColors    VALUE lNo3DColors  TYPE "L"
   ASSIGN ::AutoFit        VALUE lAutoFit     TYPE "L"
   ASSIGN ::lNoDIBSection  VALUE lNoDIB       TYPE "L"
   ASSIGN ::lNoHotLight    VALUE lNoHotLight  TYPE "L"
   ASSIGN ::lSolid         VALUE lSolid       TYPE "L"
   ASSIGN ::lNoPrintOver   VALUE lNoPrintOver TYPE "L"
   ASSIGN ::lFitTxt        VALUE lFitTxt      TYPE "L"
   ASSIGN ::lFitImg        VALUE lFitImg      TYPE "L"
   ASSIGN ::ImageSize      VALUE lImgSize     TYPE "L"
   ASSIGN ::Transparent    VALUE lTransparent TYPE "L"
   ASSIGN ::lNoFocusRect   VALUE lNoFocusRect TYPE "L"
   ASSIGN ::lNoImgLst      VALUE lNoImgLst    TYPE "L"
   ASSIGN ::lNoDestroy     VALUE lNoDestroy   TYPE "L"

   IF HB_ISARRAY( aTextMargin )
      FOR i := 1 TO Min( 4, Len( aTextMargin ) )
         IF HB_ISNUMERIC( aTextMargin[ i ] )
            ::aTextMargin[ i ] := aTextMargin[ i ]
         ENDIF
      NEXT
   ELSEIF HB_ISNUMERIC( aTextMargin )
      ::aTextMargin := { aTextMargin, aTextMargin, aTextMargin, aTextMargin }
   ENDIF

   IF HB_ISLOGICAL( lDrawBy )
      ::lLibDraw := lDrawBy
   ELSEIF ::lNoFocusRect .OR. ::lNoHotLight .OR. ::lFitTxt .OR. ::lNoPrintOver
      ::lLibDraw := .T.
   ELSEIF uFontColor # NIL .OR. ::lSolid .OR. ValType( aTextMargin ) $ "AN"
      ::lLibDraw := .T.
   ELSE
      ::lLibDraw := _OOHG_UseLibraryDraw
   ENDIF

   lBitMap := ( ( ValType( cImage ) $ "CM" .AND. ! Empty( cImage ) ) .OR. ;
                ( ValType( cBuffer ) $ "CM" .AND. ! Empty( cBuffer ) ) .OR. ;
                ValidHandler( hBitmap ) ) .AND. ;
              ( ! ValType( cCaption ) $ "CM" .OR. Empty( cCaption ) ) .AND. ;
              ::lNoImgLst

   IF HB_ISARRAY( aTextAlign )
      ASize( aTextAlign, 2 )
   ELSEIF ValType( aTextAlign ) == "N"
      aTextAlign := { aTextAlign, NIL }
   ELSEIF ValType( aTextAlign ) $ "CM"
      aTextAlign := { Upper( aTextAlign ), NIL }
   ELSE
      aTextAlign := { NIL, NIL }
   ENDIF
   IF Empty( aTextAlign[ 1 ] )
      aTextAlign[ 1 ] := BS_CENTER
   ELSEIF ValType( aTextAlign[ 1 ] ) == "N"
      IF ! ( aTextAlign[ 1 ] == BS_LEFT .OR. aTextAlign[ 1 ] == BS_RIGHT .OR. aTextAlign[ 1 ] == BS_CENTER )
         aTextAlign[ 1 ] := BS_CENTER
      ENDIF
   ELSEIF ValType( aTextAlign[ 1 ] ) $ "CM"
      IF aTextAlign[ 1 ] == "LEFT"
         aTextAlign[ 1 ] := BS_LEFT
      ELSEIF aTextAlign[ 1 ] == "RIGHT"
         aTextAlign[ 1 ] := BS_RIGHT
      ELSE
         aTextAlign[ 1 ] := BS_CENTER
      ENDIF
   ELSE
      aTextAlign[ 1 ] := BS_CENTER
   ENDIF
   IF Empty( aTextAlign[ 2 ] )
      aTextAlign[ 2 ] := BS_VCENTER
   ELSEIF ValType( aTextAlign[ 2 ] ) == "N"
      IF ! ( aTextAlign[ 2 ] == BS_TOP .OR. aTextAlign[ 2 ] == BS_BOTTOM .OR. aTextAlign[ 2 ] == BS_VCENTER )
         aTextAlign[ 2 ] := BS_VCENTER
      ENDIF
   ELSEIF ValType( aTextAlign[ 2 ] ) $ "CM"
      IF aTextAlign[ 2 ] == "TOP"
         aTextAlign[ 2 ] := BS_TOP
      ELSEIF aTextAlign[ 2 ] == "BOTTOM"
         aTextAlign[ 2 ] := BS_BOTTOM
      ELSE
         aTextAlign[ 2 ] := BS_VCENTER
      ENDIF
   ELSE
      aTextAlign[ 2 ] := BS_VCENTER
   ENDIF
   ::nTextAlign := aTextAlign[ 1 ] + aTextAlign[ 2 ]

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, NIL, lRtl )

   nStyle := ::InitStyle( NIL, NIL, lInvisible, lNoTabStop, lDisabled ) + ;
                iif( HB_ISLOGICAL( lDefault ) .AND. lDefault .AND. ! _OOHG_ExtendedNavigation, BS_DEFPUSHBUTTON, BS_PUSHBUTTON ) + ;
                iif( ValType( lFlat ) == "L" .AND. lFlat, BS_FLAT, 0 ) + ;
                iif( ! lBitMap .AND. ! IsVistaOrLater() .AND. ValType( lNoPrefix ) == "L" .AND. lNoPrefix, SS_NOPREFIX, 0 ) + ;   // for buttons SS_NOPREFIX is the same as BS_BITMAP, this used to work on XP so I leave it here.
                iif( lBitMap, BS_BITMAP, 0 ) + ;
                iif( ValType( lMultiLine ) == "L" .AND. lMultiLine, BS_MULTILINE, 0 ) + ;
                ::nTextAlign

   nControlHandle := InitButton( ::ContainerhWnd, cCaption, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, nStyle )

   ::Register( nControlHandle, cControlName, nHelpId, NIL, cToolTip )

   IF _OOHG_LastFrameType() == "TABPAGE" .AND. ::IsVisualStyled
      oTab := _OOHG_ActiveFrame
      IF oTab:Parent:hWnd == ::Parent:hWnd
         ::TabHandle := ::Container:Container:hWnd
      ENDIF
   ENDIF

   /* Must come after setting ::TabHandle to avoid a premature call to ::Events_Color */
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeOut )

   ::Caption := cCaption

   IF ValType( uAlign ) $ "CM"
      uAlign := AllTrim( Upper( uAlign ) )
      DO CASE
      CASE "LEFT" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_LEFT
      CASE "RIGHT" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_RIGHT
      CASE "BOTTOM" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_BOTTOM
      CASE "TOP" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_TOP
      CASE "CENTER" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_CENTER
      ENDCASE
   ELSEIF ValType( uAlign ) == "N"
      DO CASE
      CASE BUTTON_IMAGELIST_ALIGN_LEFT == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_LEFT
      CASE BUTTON_IMAGELIST_ALIGN_RIGHT == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_RIGHT
      CASE BUTTON_IMAGELIST_ALIGN_BOTTOM == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_BOTTOM
      CASE BUTTON_IMAGELIST_ALIGN_CENTER == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_CENTER
      CASE BUTTON_IMAGELIST_ALIGN_TOP == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_TOP
      ENDCASE
   ENDIF
   IF ! HB_ISNUMERIC( nAlign )
      IF Empty( ::Caption ) .OR. ::ImageSize
         nAlign := BUTTON_IMAGELIST_ALIGN_CENTER
      ELSE
         nAlign := BUTTON_IMAGELIST_ALIGN_LEFT
      ENDIF
   ENDIF
   ::nAlign := nAlign

   IF ::ImageSize
      IF ::lLibDraw .AND. ::IsVisualStyled
         ::aImageMargin := ThemeMargins( ::hWnd )
      ELSE
         ::aImageMargin := { 0, 0, 0, 0 }
      ENDIF
   ELSEIF HB_ISARRAY( aImageMargin )
      FOR i := 1 TO Min( 4, Len( aImageMargin ) )
         IF HB_ISNUMERIC( aImageMargin[ i ] )
            ::aImageMargin[ i ] := aImageMargin[ i ]
         ENDIF
      NEXT
   ELSEIF HB_ISNUMERIC( aImageMargin )
      ::aImageMargin := { aImageMargin, aImageMargin, aImageMargin, aImageMargin }
   ELSEIF Empty( ::Caption )
      IF ::lLibDraw .AND. ::IsVisualStyled
         ::aImageMargin := ThemeMargins( ::hWnd )
      ELSE
         ::aImageMargin := { 0, 0, 0, 0 }
      ENDIF
   ENDIF

   ::Picture := cImage
   IF ! ValidHandler( ::hImage )
      ::Buffer := cBuffer
      IF ! ValidHandler( ::hImage )
         ::HBitMap := hBitMap
      ENDIF
   ENDIF

   IF HB_ISLOGICAL( lHand ) .AND. lHand
      ::Cursor := IDC_HAND
   ENDIF

   ASSIGN ::OnClick     VALUE bAction    TYPE "B"
   ASSIGN ::OnLostFocus VALUE bLostFocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE bGotFocus  TYPE "B"
   ASSIGN ::OnMouseMove VALUE bMouseMove TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineImage( cControlName, uParentForm, nCol, nRow, cCaption, bAction, nWidth, nHeight, cFontName, ;
          nFontSize, cToolTip, bGotFocus, bLostFocus, lFlat, lNoTabStop, nHelpId, lInvisible, lBold, ;
          lItalic, lUnderline, lStrikeOut, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, cImage, ;
          lNoLoadTrans, lStretch, lCancel, uAlign, lMultiLine, lDrawBy, aImageMargin, bMouseMove, ;
          lNo3DColors, lAutoFit, lNoDIB, uBackColor, lNoHotLight, lSolid, uFontColor, aTextAlign, ;
          lNoPrintOver, aTextMargin, lFitTxt, lFitImg, lImgSize, lTransparent, lNoFocusRect, lNoImgLst, ;
          lNoDestroy, lHand, lDefault ) CLASS TButton

   IF Empty( cBuffer )
      cBuffer := ""
   ENDIF

   RETURN ::Define( cControlName, uParentForm, nCol, nRow, cCaption, bAction, nWidth, nHeight, cFontName, ;
             nFontSize, cToolTip, bGotFocus, bLostFocus, lFlat, lNoTabStop, nHelpId, lInvisible, lBold, ;
             lItalic, lUnderline, lStrikeOut, lRtl, lNoPrefix, lDisabled, cBuffer, hBitMap, cImage, ;
             lNoLoadTrans, lStretch, lCancel, uAlign, lMultiLine, lDrawBy, aImageMargin, bMouseMove, ;
             lNo3DColors, lAutoFit, lNoDIB, uBackColor, lNoHotLight, lSolid, uFontColor, aTextAlign, ;
             lNoPrintOver, aTextMargin, lFitTxt, lFitImg, lImgSize, lTransparent, lNoFocusRect, lNoImgLst, ;
             lNoDestroy, lHand, lDefault )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFocus() CLASS TButton

   IF ! _OOHG_ExtendedNavigation
      SendMessage( ::hWnd, BM_SETSTYLE, BS_DEFPUSHBUTTON, 1 )
   ENDIF

   RETURN ::Super:SetFocus()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Picture( cPicture ) CLASS TButton

   LOCAL nAttrib, aPictSize, lReplace := .F., hNew

   IF ValType( cPicture ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := cPicture
      ::cBuffer := ""

      IF ::lNoDIBSection
         nAttrib := LR_DEFAULTCOLOR
         IF ! ::lNo3DColors .OR. ! ::lNoTransparent
            aPictSize := _OOHG_SizeOfBitmapFromFile( cPicture )      // {width, height, depth}
            IF aPictSize[ 3 ] <= 8
               IF ! ::lNo3DColors
                  nAttrib += LR_LOADMAP3DCOLORS
               ENDIF
               IF ! ::lNoTransparent
                  nAttrib += LR_LOADTRANSPARENT
               ENDIF
            ELSE
               lReplace := .T.
            ENDIF
         ENDIF
      ELSE
         nAttrib := LR_CREATEDIBSECTION
      ENDIF

      ::hImage := _OOHG_BitmapFromFile( Self, cPicture, nAttrib, .F., ::lNoTransparent )
      IF ValidHandler( ::hImage )
         IF lReplace
            IF ! ::IsVisualStyled .OR. Len( ::Caption ) > 0 .OR. ! ::lNoImgLst
               hNew := _OOHG_ReplaceColor( ::hImage, 0, 0, -1, -1 )
               DeleteObject( ::hImage )
               ::hImage := hNew
            ENDIF
         ENDIF
         IF ValidHandler( ::hImage )
            IF ::ImageSize
               ::nWidth  := _OOHG_BitmapWidth( ::hImage ) + ::aImageMargin[ 2 ] + ::aImageMargin[ 4 ]
               ::nHeight := _OOHG_BitmapHeight( ::hImage ) + ::aImageMargin[ 1 ] + ::aImageMargin[ 3 ]
            ENDIF
         ELSE
            ::hImage := NIL
         ENDIF
      ELSE
         ::hImage := NIL
      ENDIF
      ::RePaint( .T. )
   ENDIF

   RETURN ::cPicture

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD HBitMap( hBitmap ) CLASS TButton

   IF ValType( hBitmap ) $ "NP"
      DeleteObject( ::hImage )
      ::cPicture := ""
      ::cBuffer := ""

      IF ValidHandler( hBitmap )
         IF ::lNoDestroy
            ::hImage := _OOHG_CopyImage( hBitMap, IMAGE_BITMAP, 0, 0, LR_DEFAULTSIZE )
         ELSE
            ::hImage := hBitMap
         ENDIF
         IF ::ImageSize
            ::nWidth  := _OOHG_BitmapWidth( ::hImage ) + ::aImageMargin[ 2 ] + ::aImageMargin[ 4 ]
            ::nHeight := _OOHG_BitmapHeight( ::hImage ) + ::aImageMargin[ 1 ] + ::aImageMargin[ 3 ]
         ENDIF
      ELSE
         ::hImage := NIL
      ENDIF
      ::RePaint( .T. )
   ENDIF

   RETURN ::hImage

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Buffer( cBuffer ) CLASS TButton

   IF ValType( cBuffer ) $ "CM"
      DeleteObject( ::hImage )
      ::cPicture := ""
      ::cBuffer := cBuffer

      ::hImage := _OOHG_BitmapFromBuffer( Self, cBuffer, .F., ::lNoTransparent )
      IF ValidHandler( ::hImage )
         IF ::ImageSize
            ::nWidth  := _OOHG_BitmapWidth( ::hImage ) + ::aImageMargin[ 2 ] + ::aImageMargin[ 4 ]
            ::nHeight := _OOHG_BitmapHeight( ::hImage ) + ::aImageMargin[ 1 ] + ::aImageMargin[ 3 ]
         ENDIF
      ELSE
         ::hImage := NIL
      ENDIF
      ::RePaint( .T. )
   ENDIF

   RETURN ::cBuffer

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( uValue ) CLASS TButton

   RETURN ( ::Caption := uValue )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD RePaint( lChange ) CLASS TButton

   LOCAL hCurrentOne

   IF ValidHandler( ::AuxHandle )
      DeleteObject( ::AuxHandle )
   ENDIF
   ::AuxHandle := NIL

   IF ValidHandler( ::hImage )
      ::TControl():SizePos()
      IF ::IsVisualStyled .AND. ( Len( ::Caption ) > 0 .OR. ! ::lNoImgLst )
         IF HB_ISLOGICAL( lChange ) .AND. lChange
            SetImageXP( ::hWnd, ::hImage, ::nAlign, ::ImageBkClr, ::aImageMargin, ::Stretch, ::AutoFit, ::lFitImg, ::ImageSize )
         ENDIF
         ::ReDraw()
      ELSE
         /* if ::hImage contains pixels with nonzero alpha then this message will create and use a new bitmap */
         ::AuxHandle := _OOHG_SetBitmap( Self, ::hImage, BM_SETIMAGE, ::Stretch, ::AutoFit, ::lNoTransparent )
         /* to prevent the resource leak we must do this check */
         hCurrentOne := _OOHG_GetBitmap( Self, BM_GETIMAGE )
         IF ::AuxHandle # hCurrentOne
            IF ValidHandler( ::AuxHandle )
               DeleteObject( ::AuxHandle )
            ENDIF
            ::AuxHandle := hCurrentOne
         ENDIF
      ENDIF
   ELSE
      ClearImageXP( ::hWnd )
   ENDIF

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SizePos( nRow, nCol, nWidth, nHeight ) CLASS TButton

   LOCAL uRet

   uRet := ::Super:SizePos( nRow, nCol, nWidth, nHeight )
   ::RePaint( .F. )

   RETURN uRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Release() CLASS TButton

   DeleteObject( ::hImage )
   ClearImageXP( ::hWnd )

   RETURN ::Super:Release()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Enter( wParam ) CLASS TButton

   IF _OOHG_ExtendedNavigation
      RETURN ::Super:Events_Enter()
   ENDIF

   RETURN ::Super:Events_Command( wParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Notify( wParam, lParam ) CLASS TButton

   LOCAL nNotify := GetNotifyCode( lParam )

   IF nNotify == NM_CUSTOMDRAW
      IF ::lLibDraw .AND. ::IsVisualStyled
         RETURN TButton_Notify_CustomDraw( Self, lParam, ! ::lNoHotLight, ::lSolid, ::Caption, ::lNoPrintOver, ::lNoFocusRect, ;
                                           ::aTextMargin, ::lFitTxt, ( HB_ISOBJECT( ::TabHandle ) .AND. ! HB_ISOBJECT( ::oBkGrnd ) ) )
      ENDIF
   ENDIF

   RETURN ::Super:Events_Notify( wParam, lParam )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD ImageMargin( aMargins ) CLASS TButton

   LOCAL i

   IF HB_ISARRAY( aMargins )
      FOR i := 1 to Min( 4, Len( aMargins ) )
         IF HB_ISNUMERIC( aMargins[ i ] )
            ::aImageMargin[ i ] := aMargins[ i ]
         ENDIF
      NEXT
      ::RePaint( .T. )
   ELSEIF HB_ISNUMERIC( aMargins )
      ::aImageMargin := { aMargins, aMargins, aMargins, aMargins }
      ::RePaint( .T. )
   ENDIF

   RETURN ::aImageMargin

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD TextMargin( aMargins ) CLASS TButton

   LOCAL i

   IF HB_ISARRAY( aMargins )
      FOR i := 1 to Min( 4, Len( aMargins ) )
         IF HB_ISNUMERIC( aMargins[ i ] )
            ::aTextMargin[ i ] := aMargins[ i ]
         ENDIF
      NEXT
      ::RePaint( .T. )
   ELSEIF HB_ISNUMERIC( aMargins )
      ::aTextMargin := { aMargins, aMargins, aMargins, aMargins }
      ::RePaint( .T. )
   ENDIF

   RETURN ::aTextMargin

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"

#ifndef TMT_CONTENTMARGINS
   #define TMT_CONTENTMARGINS     0x0E12
#endif

#ifndef BCM_FIRST
   #define BCM_FIRST     0x1600
#endif

#ifndef BCM_SETIMAGELIST
   typedef struct {
       HIMAGELIST himl;
       RECT margin;
       UINT uAlign;
   } BUTTON_IMAGELIST, *PBUTTON_IMAGELIST;

   #define BCM_SETIMAGELIST     ( BCM_FIRST + 2 )
   #define BCM_GETIMAGELIST     ( BCM_FIRST + 3 )
#endif

enum {
   BP_PUSHBUTTON = 1,
   BP_RADIOBUTTON = 2,
   BP_CHECKBOX = 3,
   BP_GROUPBOX = 4,
   BP_USERBUTTON = 5
};

enum {
   PBS_NORMAL = 1,
   PBS_HOT = 2,
   PBS_PRESSED = 3,
   PBS_DISABLED = 4,
   PBS_DEFAULTED = 5
};

#define BUTTON_IMAGELIST_ALIGN_LEFT   0
#define BUTTON_IMAGELIST_ALIGN_RIGHT  1
#define BUTTON_IMAGELIST_ALIGN_TOP    2
#define BUTTON_IMAGELIST_ALIGN_BOTTOM 3
#define BUTTON_IMAGELIST_ALIGN_CENTER 4

HBITMAP _OOHG_CopyBitmap( HBITMAP, INT, INT, INT, INT );

/*--------------------------------------------------------------------------------------------------------------------------------*/
static WNDPROC _OOHG_TButton_lpfnOldWndProc( LONG_PTR lp )
{
   static LONG_PTR lpfnOldWndProc = 0;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );
   if( ! lpfnOldWndProc )
   {
      lpfnOldWndProc = lp;
   }
   ReleaseMutex( _OOHG_GlobalMutex() );

   return (WNDPROC) lpfnOldWndProc;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static LRESULT APIENTRY SubClassFunc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
   return _OOHG_WndProcCtrl( hWnd, msg, wParam, lParam, _OOHG_TButton_lpfnOldWndProc( 0 ) );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITBUTTON )          /* FUNCTION InitButton( hWnd, cCaption, hMenu, nCol, nRow, nWidth, nHeight, lRtl, nStyle, nStyleEx ) -> hWnd */
{
   HWND hbutton;
   int Style, StyleEx;

   Style = BS_NOTIFY | WS_CHILD | hb_parni( 9 );

   StyleEx = hb_parni( 10 ) | _OOHG_RTL_Status( hb_parl( 8 ) );

   hbutton = CreateWindowEx( StyleEx, "BUTTON", hb_parc( 2 ), Style,
                             hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ), hb_parni( 7 ),
                             HWNDparam( 1 ), HMENUparam( 3 ), GetModuleHandle( NULL ), NULL );

   _OOHG_TButton_lpfnOldWndProc( SetWindowLongPtr( hbutton, GWLP_WNDPROC, (LONG_PTR) SubClassFunc ) );

   HWNDret( hbutton );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( CLEARIMAGEXP )          /* FUNCTION ClearImageXP(HWND) -> NIL */
{
   HIMAGELIST himl;
   BUTTON_IMAGELIST bi ;
   HWND hWnd = HWNDparam( 1 );

   memset( &bi, 0, sizeof( bi ) );
   SendMessage( hWnd, BCM_GETIMAGELIST, 0, (LPARAM) &bi );
   himl = bi.himl;
   if( himl )
   {
      ImageList_Destroy( himl );

      memset( &bi, 0, sizeof( bi ) );
      bi.himl = ( HIMAGELIST ) ( -1 ) ;
      SendMessage( hWnd, BCM_SETIMAGELIST, 0, (LPARAM) &bi );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SETIMAGEXP )          /* FUNCTION SetImageXP( hWnd, hBitmap, nImageAlign, uBackcolor, { nTop, nLeft, nBottom, nRight }, lStretch, lAutoFit, lFitImg, lImageSize ) -> NIL */
{
   HIMAGELIST himl;
   BUTTON_IMAGELIST bi ;
   HBITMAP hBmp;
   HBITMAP hBmp2;
   BITMAP bm;
   COLORREF clrColor;
   HWND hWnd;
   int iLeft = 0, iRight = 0, iTop = 0, iBottom = 0;

   hWnd = HWNDparam( 1 );
   hBmp = (HBITMAP) HWNDparam( 2 );
   if( hBmp )
   {
      memset( &bi, 0, sizeof( bi ) );
      SendMessage( hWnd, BCM_GETIMAGELIST, 0, (LPARAM) &bi );
      himl = bi.himl;
      if( himl )
      {
         ImageList_Destroy( himl );

         memset( &bi, 0, sizeof( bi ) );
         bi.himl = ( HIMAGELIST ) ( -1 ) ;
         SendMessage( hWnd, BCM_SETIMAGELIST, 0, (LPARAM) &bi );
      }

      if( hb_parnl( 4 ) == -1 )
      {
         clrColor = GetSysColor( COLOR_BTNFACE );
      }
      else
      {
         clrColor = (COLORREF) hb_parnl( 4 );
      }
      memset( &bm, 0, sizeof( bm ) );
      GetObject( hBmp, sizeof( bm ), &bm );
      if( hb_parl( 9 ) )   /* IMAGESIZE */
      {
         hBmp2 = (HBITMAP) CopyImage( hBmp, IMAGE_BITMAP, 0, 0, 0 );
      }
      else
      {
         if( hb_parl( 8 ) )   /* FITIMG */
         {
            iTop    = HB_PARNI( 5, 1 );
            iLeft   = HB_PARNI( 5, 2 );
            iBottom = HB_PARNI( 5, 3 );
            iRight  = HB_PARNI( 5, 4 );
         }
         if( hb_parl( 6 ) )   /* STRETCH */
         {
            hBmp2 = _OOHG_ScaleImage( hWnd, hBmp, 0, 0, TRUE, hb_parnl( 4 ), FALSE, iLeft + iRight, iTop + iBottom );
         }
         else if( hb_parl( 7 ) )   /* AUTOFIT */
         {
            hBmp2 = _OOHG_ScaleImage( hWnd, hBmp, 0, 0, FALSE, hb_parnl( 4 ), FALSE, iLeft + iRight, iTop + iBottom );
         }
         else   /* just copy */
         {
            hBmp2 = (HBITMAP) _OOHG_CopyBitmap( hBmp, 0, 0, bm.bmWidth - iLeft - iRight, bm.bmHeight - iTop - iBottom );
         }
      }

      if( hBmp2 )
      {
         memset( &bm, 0, sizeof( bm ) );
         GetObject( hBmp2, sizeof( bm ), &bm );
         himl = ImageList_Create( bm.bmWidth, bm.bmHeight, ILC_COLOR32 | ILC_MASK, 2, 2 );
         ImageList_AddMasked( himl, hBmp2, clrColor );
         DeleteObject( hBmp2 );

         memset( &bi, 0, sizeof( bi ) );
         bi.himl = himl;
         bi.margin.top = HB_PARNI( 5, 1 );
         bi.margin.left = HB_PARNI( 5, 2 );
         bi.margin.bottom = HB_PARNI( 5, 3 );
         bi.margin.right = HB_PARNI( 5, 4 );
         bi.uAlign = (UINT) hb_parni( 3 );
         SendMessage( hWnd, BCM_SETIMAGELIST, 0, (LPARAM) &bi );
      }
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( THEMEMARGINS )
{
   HTHEME hTheme;
   MARGINS pMargins;
   int iLeft = 0, iRight = 0, iTop = 0, iBottom = 0;

   if( _UxTheme_Init() )
   {
      hTheme = ( HTHEME ) ProcOpenThemeData( HWNDparam( 1 ), L"BUTTON" );
      if( hTheme )
      {
         /* get max content margins, usually all are { 3, 3, 3, 3 } */

         memset( &pMargins, 0, sizeof( MARGINS ) );
         ProcGetThemeMargins( hTheme, NULL, BP_PUSHBUTTON, PBS_DEFAULTED, TMT_CONTENTMARGINS, NULL, &pMargins );
         iLeft = max( iLeft, pMargins.cxLeftWidth );
         iRight = max( iRight, pMargins.cxRightWidth );
         iTop = max( iTop, pMargins.cyTopHeight );
         iBottom = max( iBottom, pMargins.cyBottomHeight );

         memset( &pMargins, 0, sizeof( MARGINS ) );
         ProcGetThemeMargins( hTheme, NULL, BP_PUSHBUTTON, PBS_DISABLED, TMT_CONTENTMARGINS, NULL, &pMargins );
         iLeft = max( iLeft, pMargins.cxLeftWidth );
         iRight = max( iRight, pMargins.cxRightWidth );
         iTop = max( iTop, pMargins.cyTopHeight );
         iBottom = max( iBottom, pMargins.cyBottomHeight );

         memset( &pMargins, 0, sizeof( MARGINS ) );
         ProcGetThemeMargins( hTheme, NULL, BP_PUSHBUTTON, PBS_HOT, TMT_CONTENTMARGINS, NULL, &pMargins );
         iLeft = max( iLeft, pMargins.cxLeftWidth );
         iRight = max( iRight, pMargins.cxRightWidth );
         iTop = max( iTop, pMargins.cyTopHeight );
         iBottom = max( iBottom, pMargins.cyBottomHeight );

         memset( &pMargins, 0, sizeof( MARGINS ) );
         ProcGetThemeMargins( hTheme, NULL, BP_PUSHBUTTON, PBS_NORMAL, TMT_CONTENTMARGINS, NULL, &pMargins );
         iLeft = max( iLeft, pMargins.cxLeftWidth );
         iRight = max( iRight, pMargins.cxRightWidth );
         iTop = max( iTop, pMargins.cyTopHeight );
         iBottom = max( iBottom, pMargins.cyBottomHeight );

         memset( &pMargins, 0, sizeof( MARGINS ) );
         ProcGetThemeMargins( hTheme, NULL, BP_PUSHBUTTON, PBS_PRESSED, TMT_CONTENTMARGINS, NULL, &pMargins );
         iLeft = max( iLeft, pMargins.cxLeftWidth );
         iRight = max( iRight, pMargins.cxRightWidth );
         iTop = max( iTop, pMargins.cyTopHeight );
         iBottom = max( iBottom, pMargins.cyBottomHeight );
      }
   }

   hb_reta( 4 );
   HB_STORNI( iTop, -1, 1 );
   HB_STORNI( iLeft, -1, 2 );
   HB_STORNI( iBottom, -1, 3 );
   HB_STORNI( iRight, -1, 4 );
   return;
}

int TButton_Notify_CustomDraw( PHB_ITEM, LPARAM, BOOL, BOOL, LPCSTR, BOOL, BOOL, RECT *, BOOL, BOOL );

/*--------------------------------------------------------------------------------------------------------------------------------*/
int TButton_Notify_CustomDraw( PHB_ITEM pSelf, LPARAM lParam, BOOL bHotLight, BOOL bSolid, LPCSTR cCaption, BOOL bNoPrintOver, BOOL bNoFocusRect, RECT * margin, BOOL bFitTxt, BOOL bDrawBkGrnd )
{
   POCTRL oSelf = _OOHG_GetControlInfo( pSelf );
   LPNMCUSTOMDRAW pCustomDraw = (LPNMCUSTOMDRAW) lParam;
   HTHEME hTheme;
   int state_id, x = 0, y = 0, dx = 0, dy = 0, w, h, iHrzNeeded, iVrtNeeded;
   UINT nTextAlign = 0;
   LONG_PTR style;
   BOOL bShowText;
   BUTTON_IMAGELIST bi ;
   RECT content_rect, rect, aux_rect;
   long lBackColor;
   HBRUSH hBrush;

   if( pCustomDraw->dwDrawStage == CDDS_PREERASE )
   {
      return CDRF_NOTIFYPOSTERASE;
   }
   else if( pCustomDraw->dwDrawStage == CDDS_POSTERASE )
   {
      if( ! _UxTheme_Init() )
      {
         return CDRF_DODEFAULT;
      }

      hTheme = ( HTHEME ) ProcOpenThemeData( pCustomDraw->hdr.hwndFrom, L"BUTTON" );
      if( ! hTheme )
      {
         return CDRF_DODEFAULT;
      }

      /* determine control's state, note that the order of these tests is significant */
      style = GetWindowLongPtr( pCustomDraw->hdr.hwndFrom, GWL_STYLE );

      state_id = PBS_NORMAL;
      if( style & WS_DISABLED )
      {
         state_id = PBS_DISABLED;
      }
      else if( ( pCustomDraw->uItemState & CDIS_DISABLED ) == CDIS_DISABLED )
      {
         state_id = PBS_DISABLED;
      }
      else if( style & BS_PUSHLIKE )
      {
         if( SendMessage( pCustomDraw->hdr.hwndFrom, BM_GETCHECK , 0 , 0 ) == BST_CHECKED )
         {
            state_id = PBS_PRESSED;
         }
         else if( ( ( pCustomDraw->uItemState & CDIS_HOT ) == CDIS_HOT ) && bHotLight )
         {
            state_id = PBS_HOT;
         }
         else if( ( pCustomDraw->uItemState & CDIS_SELECTED ) == CDIS_SELECTED )
         {
            state_id = PBS_PRESSED;
         }
      }
      else if( ( ( pCustomDraw->uItemState & CDIS_HOT ) == CDIS_HOT ) && bHotLight )
      {
         state_id = PBS_HOT;
      }
      else if( ( style & BS_DEFPUSHBUTTON ) && ( ( pCustomDraw->uItemState & CDIS_FOCUS ) == CDIS_FOCUS ) )
      {
         state_id = PBS_DEFAULTED;
      }
      else if( ( pCustomDraw->uItemState & CDIS_SELECTED ) == CDIS_SELECTED )
      {
         state_id = PBS_PRESSED;
      }

      /* draw parent background */
      if( bDrawBkGrnd )
      {
         if( ProcIsThemeBackgroundPartiallyTransparent( hTheme, BP_PUSHBUTTON, state_id ) )
         {
            /* pCustomDraw->rc is the item´s client area */
            ProcDrawThemeParentBackground( pCustomDraw->hdr.hwndFrom, pCustomDraw->hdc, &pCustomDraw->rc );
         }
      }

      if( bSolid )
      {
         lBackColor = ( oSelf->lUseBackColor != -1 ) ? oSelf->lUseBackColor : oSelf->lBackColor;
         if( lBackColor != -1 )
         {
            hBrush = CreateSolidBrush( (COLORREF) lBackColor );
            FillRect( pCustomDraw->hdc, &pCustomDraw->rc, hBrush );
            DeleteObject( hBrush );
         }
      }
      else
      {
         /* draw themed button background appropriate to button state */
         ProcDrawThemeBackground( hTheme, pCustomDraw->hdc, BP_PUSHBUTTON, state_id, &pCustomDraw->rc, NULL );
      }

      /* get content rectangle (space inside button for image) */
      ProcGetThemeBackgroundContentRect( hTheme, pCustomDraw->hdc, BP_PUSHBUTTON, state_id, &pCustomDraw->rc, &content_rect );

      /* draw the image */
      memset( &bi, 0, sizeof( bi ) );
      SendMessage( pCustomDraw->hdr.hwndFrom, BCM_GETIMAGELIST, 0, (LPARAM) &bi );

      rect = pCustomDraw->rc;

      if( bi.himl )
      {
         ImageList_GetIconSize( bi.himl, &dx, &dy );

         /* calculate the position of the image so it is drawn on left, right or centered (the default) as dictated by the style settings */
         w = rect.right - rect.left - bi.margin.right - bi.margin.left;
         if( w > 0 )
         {
            if( dx > w )
            {
               dx = w;
            }
            if( bi.uAlign == BUTTON_IMAGELIST_ALIGN_LEFT )
            {
               x = rect.left + bi.margin.left;
               rect.left = x + dx + bi.margin.right;
            }
            else if( bi.uAlign == BUTTON_IMAGELIST_ALIGN_RIGHT )
            {
               x = rect.right - bi.margin.right - dx;
               rect.right = x - bi.margin.left;
            }
            else
            {
               x = rect.left + (int) ( ( rect.right - rect.left - bi.margin.left - dx - bi.margin.right ) / 2 ) + bi.margin.left;
            }
         }

         /* calculate the position of the image so it is drawn on top, bottom or vertically centered (the default) as dictated by the style settings */
         h = rect.bottom - rect.top - bi.margin.bottom - bi.margin.top;
         if( h > 0 )
         {
            if( dy > h )
            {
               dy = h;
            }
            if( bi.uAlign == BUTTON_IMAGELIST_ALIGN_TOP )
            {
               y = rect.top + bi.margin.top;
               rect.top = y + dy + bi.margin.bottom;
            }
            else if( bi.uAlign == BUTTON_IMAGELIST_ALIGN_BOTTOM )
            {
               y = rect.bottom - bi.margin.bottom - dy;
               rect.bottom = y - bi.margin.top;
            }
            else
            {
               y = rect.top + (int) ( ( rect.bottom - rect.top - bi.margin.top - dy - bi.margin.bottom ) / 2 ) + bi.margin.top;
            }
         }

         if( dx > 0 && dy > 0 )
         {
            ImageList_DrawEx( bi.himl, 0, pCustomDraw->hdc, x, y, dx, dy, CLR_DEFAULT, CLR_NONE, ILD_TRANSPARENT );
         }
      }

      /* draw the caption */
      if( strlen( cCaption ) > 0 )
      {
         if( rect.left >= rect.right || rect.top >= rect.bottom )
         {
            if( bNoPrintOver )
            {
               bShowText = FALSE;
            }
            else
            {
               rect = content_rect;
               bShowText = TRUE;
            }
         }
         else
         {
            bShowText = TRUE;
         }
         if( bShowText )
         {
            SetBkMode( pCustomDraw->hdc, TRANSPARENT );
            SetTextColor( pCustomDraw->hdc, ( oSelf->lFontColor == -1 ) ? GetSysColor( COLOR_BTNTEXT ) : (COLORREF) oSelf->lFontColor );

            rect.top    += margin->top;
            rect.left   += margin->left;
            rect.bottom -= margin->bottom;
            rect.right  -= margin->right;

            aux_rect = rect;

            /* the order of these tests is significant */
            if( style & BS_CENTER )
            {
               nTextAlign += DT_CENTER;
            }
            else if( style & BS_RIGHT )
            {
               nTextAlign += DT_RIGHT;
            }
            else
            {
               nTextAlign += DT_LEFT;
            }
            /* the order of these tests is significant */
            if( style & BS_VCENTER )
            {
               nTextAlign += DT_VCENTER;
            }
            else if( style & BS_BOTTOM )
            {
               nTextAlign += DT_BOTTOM;
            }
            else
            {
               nTextAlign += DT_TOP;
            }

            if( style & BS_MULTILINE )
            {
               if( bFitTxt )
               {
                  iVrtNeeded = DrawText( pCustomDraw->hdc, cCaption, -1, &aux_rect, DT_WORDBREAK | nTextAlign | DT_CALCRECT );
                  iHrzNeeded = aux_rect.right - aux_rect.left;
               }
               else
               {
                  iVrtNeeded = DrawText( pCustomDraw->hdc, cCaption, -1, &aux_rect, DT_NOCLIP | DT_WORDBREAK | nTextAlign | DT_CALCRECT );
                  iHrzNeeded = aux_rect.right - aux_rect.left;
               }
               if( ( nTextAlign & DT_VCENTER ) == DT_VCENTER )
               {
                  rect.top = rect.top + (int) ( ( rect.bottom - rect.top - iVrtNeeded ) / 2 );
                  rect.bottom = rect.top + iVrtNeeded;
               }
               else if( ( nTextAlign & DT_BOTTOM ) == DT_BOTTOM )
               {
                  rect.top = rect.bottom - iVrtNeeded;
               }
               else   /* DT_TOP */
               {
                  rect.bottom = rect.top + iVrtNeeded;
               }
               if( ( nTextAlign & DT_CENTER ) == DT_CENTER )
               {
                  rect.left = rect.left + (int) ( ( rect.right - rect.left - iHrzNeeded ) / 2 );
                  rect.right = rect.left + iHrzNeeded;
               }
               else if( ( nTextAlign & DT_RIGHT ) == DT_RIGHT )
               {
                  rect.left = rect.right - iHrzNeeded;
               }
               else   /* DT_LEFT */
               {
                  rect.right = rect.left + iHrzNeeded;
               }
               if( bFitTxt )
               {
                  DrawText( pCustomDraw->hdc, cCaption, -1, &rect, DT_WORDBREAK | nTextAlign );
               }
               else
               {
                  DrawText( pCustomDraw->hdc, cCaption, -1, &rect, DT_NOCLIP | DT_WORDBREAK | nTextAlign );
               }
            }
            else
            {
               if( bFitTxt )
               {
                  DrawText( pCustomDraw->hdc, cCaption, -1, &rect, DT_WORDBREAK | nTextAlign | DT_SINGLELINE );
               }
               else
               {
                  DrawText( pCustomDraw->hdc, cCaption, -1, &rect, DT_NOCLIP | DT_WORDBREAK | nTextAlign | DT_SINGLELINE );
               }
            }
         }
      }

      /* draw the focus rectangle if needed and required */
      if( ( pCustomDraw->uItemState & CDIS_FOCUS ) && ( ! bNoFocusRect ) )
      {
         DrawFocusRect( pCustomDraw->hdc, &content_rect );
      }

      /* cleanup */
      ProcCloseThemeData( hTheme );

      return CDRF_SKIPDEFAULT;
   }
   else
   {
      return CDRF_SKIPDEFAULT;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( TBUTTON_NOTIFY_CUSTOMDRAW )          /* FUNCTION TButton_Notify_CustomDraw( Self, lParam, lHotLight, lSolid, cCaption, lNoPrintOver, lNoFocusRect, aTextMargin, lFitTxt, bDrawBkGrnd ) -> nRetVal */
{
   PHB_ITEM pArrayRect = hb_param( 8, HB_IT_ARRAY );
   RECT rect;

   rect.top    = hb_arrayGetNL( pArrayRect, 1 );
   rect.left   = hb_arrayGetNL( pArrayRect, 2 );
   rect.bottom = hb_arrayGetNL( pArrayRect, 3 );
   rect.right  = hb_arrayGetNL( pArrayRect, 4 );

   hb_retni( TButton_Notify_CustomDraw( hb_param( 1, HB_IT_OBJECT ), LPARAMparam( 2 ), hb_parl( 3 ), hb_parl( 4 ),
                                        (LPCSTR) hb_parc( 5 ), hb_parl( 6 ), hb_parl( 7 ), &rect, hb_parl( 9 ), hb_parl( 10 ) ) );
}

#pragma ENDDUMP


/*--------------------------------------------------------------------------------------------------------------------------------*/
CLASS TButtonCheck FROM TButton

   DATA Type                      INIT "CHECKBUTTON" READONLY
   DATA nWidth                    INIT 100
   DATA nHeight                   INIT 28

   METHOD Define
   METHOD DefineImage
   METHOD Events_Command
   METHOD SetFocus
   METHOD Value                   SETGET

   ENDCLASS

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Define( cControlName, uParentForm, nCol, nRow, cCaption, uValue, cFontName, nFontSize, cToolTip, ;
          bChange, nWidth, nHeight, bLostFocus, bGotFocus, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, ;
          lUnderline, lStrikeOut, cField, lRtl, cImage, cBuffer, hBitMap, lNoLoadTrans, lStretch, lNo3DColors, ;
          lAutoFit, lNoDIB, uBackColor, lDisabled, lDrawBy, aImageMargin, bMouseMove, uAlign, lMultiLine, ;
          lFlat, lNoHotLight, lSolid, uFontColor, aTextAlign, lNoPrintOver, aTextMargin, lFitTxt, lFitImg, ;
          lImgSize, lTransparent, lNoFocusRect, lNoImgLst, lNoDestroy, lHand ) CLASS TButtonCheck

   LOCAL nControlHandle, nStyle, lBitMap, i, nAlign

   ASSIGN ::nCol           VALUE nCol         TYPE "N"
   ASSIGN ::nRow           VALUE nRow         TYPE "N"
   ASSIGN ::nWidth         VALUE nWidth       TYPE "N"
   ASSIGN ::nHeight        VALUE nHeight      TYPE "N"
   ASSIGN ::lNoTransparent VALUE lNoLoadTrans TYPE "L"
   ASSIGN ::Stretch        VALUE lStretch     TYPE "L"
   ASSIGN ::lNo3DColors    VALUE lNo3DColors  TYPE "L"
   ASSIGN ::AutoFit        VALUE lAutoFit     TYPE "L"
   ASSIGN ::lNoDIBSection  VALUE lNoDIB       TYPE "L"
   ASSIGN ::lNoHotLight    VALUE lNoHotLight  TYPE "L"
   ASSIGN ::lSolid         VALUE lSolid       TYPE "L"
   ASSIGN ::lNoPrintOver   VALUE lNoPrintOver TYPE "L"
   ASSIGN ::lFitTxt        VALUE lFitTxt      TYPE "L"
   ASSIGN ::lFitImg        VALUE lFitImg      TYPE "L"
   ASSIGN ::ImageSize      VALUE lImgSize     TYPE "L"
   ASSIGN ::Transparent    VALUE lTransparent TYPE "L"
   ASSIGN ::lNoFocusRect   VALUE lNoFocusRect TYPE "L"
   ASSIGN ::lNoImgLst      VALUE lNoImgLst    TYPE "L"
   ASSIGN ::lNoDestroy     VALUE lNoDestroy   TYPE "L"

   IF HB_ISARRAY( aTextMargin )
      FOR i := 1 TO Min( 4, Len( aTextMargin ) )
         IF HB_ISNUMERIC( aTextMargin[ i ] )
            ::aTextMargin[ i ] := aTextMargin[ i ]
         ENDIF
      NEXT
   ELSEIF HB_ISNUMERIC( aTextMargin )
      ::aTextMargin := { aTextMargin, aTextMargin, aTextMargin, aTextMargin }
   ENDIF

   IF HB_ISLOGICAL( lDrawBy )
      ::lLibDraw := lDrawBy
   ELSEIF ::lNoFocusRect .OR. ::lNoHotLight .OR. ::lFitTxt .OR. ::lNoPrintOver .OR. ::lSolid .OR. ValType( aTextMargin ) $ "AN"
      ::lLibDraw := .T.
   ELSE
      ::lLibDraw := _OOHG_UseLibraryDraw
   ENDIF

   lBitMap := ( ( ValType( cImage ) $ "CM" .AND. ! Empty( cImage ) ) .OR. ;
                ( ValType( cBuffer ) $ "CM" .AND. ! Empty( cBuffer ) ) .OR. ;
                ValidHandler( hBitmap ) ) .AND. ;
              ( ! ValType( cCaption ) $ "CM" .OR. Empty( cCaption ) ) .AND. ;
              ::lNoImgLst

   IF HB_ISARRAY( aTextAlign )
      ASize( aTextAlign, 2 )
   ELSEIF ValType( aTextAlign ) == "N"
      aTextAlign := { aTextAlign, NIL }
   ELSEIF ValType( aTextAlign ) $ "CM"
      aTextAlign := { Upper( aTextAlign ), NIL }
   ELSE
      aTextAlign := { NIL, NIL }
   ENDIF
   IF Empty( aTextAlign[ 1 ] )
      aTextAlign[ 1 ] := BS_CENTER
   ELSEIF ValType( aTextAlign[ 1 ] ) == "N"
      IF ! ( aTextAlign[ 1 ] == BS_LEFT .OR. aTextAlign[ 1 ] == BS_RIGHT .OR. aTextAlign[ 1 ] == BS_CENTER )
         aTextAlign[ 1 ] := BS_CENTER
      ENDIF
   ELSEIF ValType( aTextAlign[ 1 ] ) $ "CM"
      IF ! ( aTextAlign[ 1 ] == "LEFT" .OR. aTextAlign[ 1 ] == "RIGHT" .OR. aTextAlign[ 1 ] == "CENTER" )
         aTextAlign[ 1 ] := BS_CENTER
      ENDIF
   ELSE
      aTextAlign[ 1 ] := BS_CENTER
   ENDIF
   IF Empty( aTextAlign[ 2 ] )
      aTextAlign[ 2 ] := BS_VCENTER
   ELSEIF ValType( aTextAlign[ 2 ] ) == "N"
      IF ! ( aTextAlign[ 2 ] == BS_TOP .OR. aTextAlign[ 2 ] == BS_BOTTOM .OR. aTextAlign[ 2 ] == BS_VCENTER )
         aTextAlign[ 2 ] := BS_VCENTER
      ENDIF
   ELSEIF ValType( aTextAlign[ 2 ] ) $ "CM"
      IF ! ( aTextAlign[ 2 ] == "TOP" .OR. aTextAlign[ 2 ] == "BOTTOM" .OR. aTextAlign[ 2 ] == "VCENTER" )
         aTextAlign[ 2 ] := BS_VCENTER
      ENDIF
   ELSE
      aTextAlign[ 2 ] := BS_VCENTER
   ENDIF
   ::nTextAlign := aTextAlign[ 1 ] + aTextAlign[ 2 ]

   ::SetForm( cControlName, uParentForm, cFontName, nFontSize, uFontColor, uBackColor, NIL, lRtl )

   nStyle := ::InitStyle( NIL, NIL, lInvisible, lNoTabStop, lDisabled ) + ;
                BS_AUTOCHECKBOX + ;
                BS_PUSHLIKE + ;
                iif( ValType( lFlat ) == "L" .AND. lFlat, BS_FLAT, 0 ) + ;
                iif( lBitMap, BS_BITMAP, 0 ) + ;
                iif( ValType( lMultiLine ) == "L" .AND. lMultiLine, BS_MULTILINE, 0 ) + ;
                ::nTextAlign

   nControlHandle := InitButton( ::ContainerhWnd, cCaption, 0, ::ContainerCol, ::ContainerRow, ::Width, ::Height, ::lRtl, nStyle )

   ::Register( nControlHandle, cControlName, nHelpId, NIL, cToolTip )
   ::SetFont( NIL, NIL, lBold, lItalic, lUnderline, lStrikeOut )

   ::Caption := cCaption

   IF ValType( uAlign ) $ "CM"
      uAlign := AllTrim( Upper( uAlign ) )
      DO CASE
      CASE "LEFT" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_LEFT
      CASE "RIGHT" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_RIGHT
      CASE "BOTTOM" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_BOTTOM
      CASE "TOP" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_TOP
      CASE "CENTER" == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_CENTER
      ENDCASE
   ELSEIF ValType( uAlign ) == "N"
      DO CASE
      CASE BUTTON_IMAGELIST_ALIGN_LEFT == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_LEFT
      CASE BUTTON_IMAGELIST_ALIGN_RIGHT == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_RIGHT
      CASE BUTTON_IMAGELIST_ALIGN_BOTTOM == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_BOTTOM
      CASE BUTTON_IMAGELIST_ALIGN_CENTER == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_CENTER
      CASE BUTTON_IMAGELIST_ALIGN_TOP == uAlign
         nAlign := BUTTON_IMAGELIST_ALIGN_TOP
      ENDCASE
   ENDIF
   IF ! HB_ISNUMERIC( nAlign )
      IF Empty( ::Caption ) .OR. ::ImageSize
         nAlign := BUTTON_IMAGELIST_ALIGN_CENTER
      ELSE
         nAlign := BUTTON_IMAGELIST_ALIGN_LEFT
      ENDIF
   ENDIF
   ::nAlign := nAlign

   IF ::ImageSize
      ::aImageMargin := { 0, 0, 0, 0 }
   ELSEIF HB_ISARRAY( aImageMargin )
      FOR i := 1 TO Min( 4, Len( aImageMargin ) )
         IF HB_ISNUMERIC( aImageMargin[ i ] )
            ::aImageMargin[ i ] := aImageMargin[ i ]
         ENDIF
      NEXT
   ELSEIF HB_ISNUMERIC( aImageMargin )
      ::aImageMargin := { aImageMargin, aImageMargin, aImageMargin, aImageMargin }
   ELSEIF Empty( ::Caption )
      ::aImageMargin := { 0, 0, 0, 0 }
   ENDIF

   ::Picture := cImage
   IF ! ValidHandler( ::hImage )
      ::Buffer := cBuffer
      IF ! ValidHandler( ::hImage )
         ::HBitMap := hBitMap
      ENDIF
   ENDIF

   ::SetVarBlock( cField, uValue )

   IF HB_ISLOGICAL( lHand ) .AND. lHand
      ::Cursor := IDC_HAND
   ENDIF

   ASSIGN ::OnLostFocus VALUE bLostFocus TYPE "B"
   ASSIGN ::OnGotFocus  VALUE bGotFocus  TYPE "B"
   ASSIGN ::OnChange    VALUE bChange    TYPE "B"
   ASSIGN ::OnMouseMove VALUE bMouseMove TYPE "B"

   RETURN Self

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD DefineImage( cControlName, uParentForm, nCol, nRow, cCaption, uValue, cFontName, nFontSize, cToolTip, ;
          bChange, nWidth, nHeight, bLostFocus, bGotFocus, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, ;
          lUnderline, lStrikeOut, cField, lRtl, cImage, cBuffer, hBitMap, lNoLoadTrans, lStretch, lNo3DColors, ;
          lAutoFit, lNoDIB, uBackColor, lDisabled, lDrawBy, aImageMargin, bMouseMove, uAlign, lMultiLine, ;
          lFlat, lNoHotLight, lSolid, uFontColor, aTextAlign, lNoPrintOver, aTextMargin, lFitTxt, lFitImg, ;
          lImgSize, lTransparent, lNoFocusRect, lNoImgLst, lNoDestroy, lHand ) CLASS TButtonCheck

   IF Empty( cBuffer )    // TODO: ver si se puede eliminar
      cBuffer := ""
   ENDIF

   RETURN ::Define( cControlName, uParentForm, nCol, nRow, cCaption, uValue, cFontName, nFontSize, cToolTip, ;
             bChange, nWidth, nHeight, bLostFocus, bGotFocus, nHelpId, lInvisible, lNoTabStop, lBold, lItalic, ;
             lUnderline, lStrikeOut, cField, lRtl, cImage, cBuffer, hBitMap, lNoLoadTrans, lStretch, lNo3DColors, ;
             lAutoFit, lNoDIB, uBackColor, lDisabled, lDrawBy, aImageMargin, bMouseMove, uAlign, lMultiLine, ;
             lFlat, lNoHotLight, lSolid, uFontColor, aTextAlign, lNoPrintOver, aTextMargin, lFitTxt, lFitImg, ;
             lImgSize, lTransparent, lNoFocusRect, lNoImgLst, lNoDestroy, lHand )

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Value( lValue ) CLASS TButtonCheck

   IF ValType( lValue ) == "L"
      SendMessage( ::hWnd, BM_SETCHECK, iif( lValue, BST_CHECKED, BST_UNCHECKED ), 0 )
      ::DoChange()
   ELSE
      lValue := ( SendMessage( ::hWnd, BM_GETCHECK , 0 , 0 ) == BST_CHECKED )
   ENDIF

   RETURN lValue

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD SetFocus() CLASS TButtonCheck

   RETURN ::TControl():SetFocus()

/*--------------------------------------------------------------------------------------------------------------------------------*/
METHOD Events_Command( wParam ) CLASS TButtonCheck

   LOCAL Hi_wParam := HIWORD( wParam )

   IF Hi_wParam == BN_CLICKED
      ::DoChange()
   ENDIF

   RETURN ::Super:Events_Command( wParam )
