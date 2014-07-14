/*
 * $Id: intfocop.prg,v 1.7 2014-07-14 21:20:24 fyurisich Exp $
 */

#include 'oohg.ch'

//------------------------------------------------------------------------------
FUNCTION IntFoco( qw, myIde )
//------------------------------------------------------------------------------
LOCAL i, iRow, iCol, iWidth, iHeight, h, j, k, l, z, eRow, eCol, dRow, dCol
LOCAL BaseRow, BaseCol, BaseWidth, BaseHeight, TitleHeight, BorderWidth
LOCAL BorderHeight, CurrentPage, IsInTab, SupMin, iMin, cName, jk, jl

   IF qw == 0
      IntFoco1( 0, myIDe )
      RETURN NIL
   ENDIF

   h := GetFormHandle( myForm:DesignForm )
   BaseRow := GetWindowRow( h ) + GetBorderHeight()
   BaseCol := GetWindowCol( h ) + GetBorderWidth()
   BaseWidth := GetWindowWidth( h )
   BaseHeight := GetWindowHeight( h )
   TitleHeight := GetTitleHeight()
   BorderWidth := GetBorderWidth()
   BorderHeight := GetBorderHeight()

   i := nHandleP
   jk := i

   IF jk > 0
      IF SiEsDEste( jk, 'IMAGE' ) .OR. SiEsDEste( jk, 'TIMER' ) .OR. ;
         SiEsDEste( jk, 'PLAYER' ) .OR. SiEsDEste( jk, 'ANIMATE') .OR. ;
         SiEsDEste( jk, 'PICCHECKBUTT' ) .OR. SiEsDEste( jk, 'PICBUTT' )
         RETURN NIL
      ENDIF

      oWindow := GetFormObject( "Form_1" )
      si := aScan( myForm:aControlW, { |c| Lower( c ) == Lower( oWindow:aControls[jk]:Name ) } )
      IF si > 0
         IntFoco1( si, myIde )
         CHideControl( oWindow:aControls[jk] )
         CShowControl( oWindow:aControls[jk] )
         RETURN NIL
      ENDIF
   ELSE
      RETURN NIL
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION IntFoco1( si, myIde )
//------------------------------------------------------------------------------
   LOAD WINDOW intfonco
   IF si == 0
      intfonco.label_1.Value := '  Form : ' + myForm:cFName
   ELSE
      intfonco.label_1.Value := 'Control: ' + myForm:aName[si]
   ENDIF
   ACTIVATE WINDOW intfonco
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION SDefCol( si, myide )
//------------------------------------------------------------------------------
LOCAL cCode, cBackColor, aColor, cName, oWindow
   cCode := myide:aSystemColorAux
   IF si == 0
      myForm:cFBackColor := 'NIL'
      myForm:lFSave := .F.
      oWindow := GetFormObject( "Form_1" )
      oWindow:BackColor := cCode
      oWindow:Hide()
      oWindow:Show()
      intfonco.button_103.SetFocus
   ELSE
      myForm:aBackColor[si] := 'NIL'
      myForm:lFSave := .F.
      cName := myForm:aControlW[si]
      GetControlObject( cName, "Form_1" ):BackColor := cCode
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION GFontT( si )
//------------------------------------------------------------------------------
LOCAL cName, aFont, nRed, nGreen, nBlue

   IF si == 0
      aFont := GetFont( myForm:cFFontName, myForm:nFFontSize, .F. , .F. , {0, 0, 0} , .F., .F., 0 )
      IF aFont[1] == "" .AND. aFont[2] == 0 .AND. ( ! aFont[3] ) .AND.  ( ! aFont[4] ) .AND. ;
         aFont[5, 1] == NIL .AND. aFont[5,2] == NIL .AND.  aFont[5, 3] == NIL .AND. ;
         ( ! aFont[6] ) .AND. ( ! aFont[7]) .AND. aFont[8] == 0
         RETURN NIL
      ENDIF

      IF Len( aFont[1] ) > 0
         myForm:cFFontName := aFont[1]
         GetFormObject( "Form_1" ):cFontName := aFont[1]
      ENDIF
      IF aFont[2] > 0
         myForm:nFFontSize := aFont[2]
         GetFormObject( "Form_1" ):nFontSize := aFont[2]
      ENDIF
      nRed := aFont[5,1]
      nGreen := aFont[5,2]
      nBlue := aFont[5,3]
      IF nRed <> NIL .AND. nGreen <> NIL .AND. nBlue <> NIL
         cColor := '{ ' + LTrim( Str( nRed ) ) + ', ' + ;
                          LTrim( Str( nGreen ) ) + ', ' + ;
                          LTrim( Str( nBlue ) ) + ' }'
         myForm:cFFontColor := cColor
         GetFormObject( "Form_1" ):FontColor := &cColor
      ENDIF
   ELSE
      cName := myForm:aControlW[si]
      nFontColor := myForm:aFontColor[si]
      aFont := GetFont( myForm:aFontName[si], myForm:aFontSize[si], myForm:aBold[si], myForm:aFontItalic[si], &nFontColor, myForm:aFontUnderline[si], myForm:aFontStrikeout[si], 0 )
      IF aFont[1] == "" .AND. aFont[2] == 0 .AND. ( ! aFont[3] ) .AND.  ( ! aFont[4] ) .AND. ;
         aFont[5, 1] == NIL .AND. aFont[5,2] == NIL .AND.  aFont[5, 3] == NIL .AND. ;
         ( ! aFont[6] ) .AND. ( ! aFont[7]) .AND. aFont[8] == 0
         RETURN NIL
      ENDIF

      IF Len( aFont[1] ) > 0
         myForm:aFontName[si] := aFont[1]
         GetControlObject( cName, "Form_1" ):FontName := aFont[1]
      ENDIF
      IF aFont[2] > 0
         myForm:aFontSize[si] := aFont[2]
         GetControlObject( cName, "Form_1" ):FontSize := aFont[2]
      ENDIF

      IF myForm:aBold[si] <> aFont[3]
         myForm:aBold[si] := aFont[3]
         GetControlObject( cName, "Form_1" ):FontBold := aFont[3]
      ENDIF
      IF myForm:aFontItalic[si] <> aFont[4]
         myForm:aFontItalic[si] := aFont[4]
         GetControlObject( cName, "Form_1" ):FontItalic := aFont[4]
      ENDIF
      nRed := aFont[5,1]
      nGreen := aFont[5,2]
      nBlue := aFont[5,3]
      IF nRed <> NIL .AND. nGreen <> NIL .AND. nBlue <> NIL
         cColor := '{ ' + LTrim( Str( nRed ) ) + ', ' + ;
                          LTrim( Str( nGreen ) ) + ', ' + ;
                          LTrim( Str( nBlue ) ) + ' }'
         myForm:aFontColor[si] := cColor
         GetControlObject( cName, "Form_1" ):FontColor := &cColor
      ENDIF
      IF myForm:aFontUnderline[si] <> aFont[6]
         myForm:aFontUnderline[si] := aFont[6]
         GetControlObject( cName, "Form_1" ):FontUnderline := aFont[6]
      ENDIF
      IF myForm:aFontStrikeout[si] <> aFont[7]
         myForm:aFontStrikeout[si] := aFont[7]
         GetControlObject( cName, "Form_1" ):FontStrikeout := aFont[7]
      ENDIF
   ENDIF
   myForm:lFSave := .F.
RETURN NIL

/*
   TODO: Add a function to reset font attributes to defaults.
         Add buttons to reset Name, Size and Color individually.
*/

//------------------------------------------------------------------------------
FUNCTION GBackC( si )
//------------------------------------------------------------------------------
LOCAL cCode, cBackColor, aColor, oWindow, cName

   IF si == 0
     cBackColor := myForm:cfBackColor
   ELSE
     cName := myForm:aControlW[si]
     cBackColor := myForm:aBackColor[si]
   ENDIF
   IF Len( cBackColor ) > 0
      aColor := GetColor( &cBackColor )
   ELSE
      aColor := GetColor()
   ENDIF
   IF aColor[1] == NIL .AND. aColor[2] == NIL .AND. aColor[3] == NIL
      RETURN NIL
   ENDIF
   cCode := '{ ' + LTrim( Str( aColor[1] ) ) + ", " + ;
                   LTrim( Str( aColor[2] ) ) + ", " + ;
                   LTrim( Str( aColor[3] ) ) + " }"
   IF si == 0
      myForm:cFBackColor := cCode
      myForm:lFSave := .F.
      oWindow := GetFormObject( "Form_1" )
      oWindow:BackColor := &cCode
      oWindow:Hide()
      oWindow:Show()
      intfonco.button_103.SetFocus
   ELSE
      myForm:aBackColor[si] := cCode
      GetControlObject( cName, "Form_1" ):BackColor := &cCode
      myForm:lFSave := .F.
   ENDIF
RETURN NIL
