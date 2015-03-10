/*
 * $Id: treeofclasses.prg,v 1.3 2015-03-10 23:58:19 fyurisich Exp $
 */
/*
 * Reads classes.txt and shows the tree of classes in a a Tree control
 */

#include "oohg.ch"

FUNCTION Main()

   SET EXACT ON

   DEFINE WINDOW MainForm ;
      OBJ oMainForm ;
      AT 0,0 ;
      WIDTH 648 ;
      HEIGHT 188 ;
      TITLE "Tree of ooHG's Classes" ;
      MAIN ;
      ON SIZE MainFormResize( oMainForm ) ;
      ON INIT {|| MainFormResize( oMainForm ), ;
                  Populate( oMainForm ), ;
                  oMainForm:lbl_wait:Visible := .F. , ;
                  oMainForm:Classes:Visible := .T. }

      @ 80, 10 LABEL lbl_wait ;
         VALUE "Working, please wait ..." ;
         CENTER ;
         BOLD ;
         SIZE 18 ;
         TRANSPARENT ;
         HEIGHT 40 ;
         WIDTH oMainForm:ClientWidth - 20

      DEFINE TREE Classes ;
         AT 20,20 ;
         WIDTH 600 ;
         HEIGHT 400 ;
         ITEMIDS ;
         INVISIBLE ;
         FONT "Courier New"

      END TREE

      ON KEY ESCAPE ACTION oMainForm:Release()

   END WINDOW

   oMainForm:Center()
   oMainForm:activate()

RETURN Nil

/*
 * Size and place controls whenever the form's size is changed
 */
FUNCTION MainFormResize( oMainForm )

   LOCAL TitleHeight  := GetTitleheight()
   LOCAL BorderHeight := GetBorderheight()
   LOCAL ScreenDPI    := GetScreenDPI()

   WITH OBJECT oMainForm
      IF :WIDTH < INT(388 * ScreenDPI / 96)
        :WIDTH := INT(388 * ScreenDPI / 96)
      ENDIF

      IF :HEIGHT < INT(388 * ScreenDPI / 96)
         :HEIGHT := INT(388 * ScreenDPI / 96)
      ENDIF

      :Classes:WIDTH  := :WIDTH - ( BorderHeight * 2 ) - INT(40 * ScreenDPI / 96)
      :Classes:HEIGHT := :HEIGHT - TitleHeight - ( BorderHeight * 2 ) - INT(40 * ScreenDPI / 96)
   END WITH

RETURN Nil

/*
 * Populate tree with classes' information from docs/classes.txt file
 */
FUNCTION Populate( oMainForm )

   LOCAL oFile, cLine, cRest, i, j, cClassName, cParentClass
   LOCAL nClassId, nParentId, aTreeItems, aOrphans, nPos
   local cDataName, cMethodName, lNew, cOthers, aItems

   oFile := TFileRead():New( "CLASSES.TXT" )

   oFile:Open()

   IF oFile:Error()
      MSGSTOP( oFile:ErrorMsg( "FileRead: " ), "Tree of ooHG's Classes, msg #1" )
      oMainForm:Release()
   ELSE
      aTreeItems := {}          // Names of the items added to the tree control. Array index is the item's Id.
      aOrphans   := {}          // Items with parent not yet added to the tree control.
      nClassId   := 0           // Id of the last class added to the tree control (0 means orphaned class or no class).
      cClassName := ""          // Name of the last class added to tree control ("" means no class).
      cOthers    := ""          // For cases when the FROM clause contains more than one class.

      DO WHILE oFile:MoreToRead()
         cLine := ALLTRIM( oFile:ReadLine() )
         
         /*
          * Just process the lines with the the following structures:
          *    CLASS <ClassName>
          *    CLASS <ClassName> FROM <ParentClassName>
          *    DATA <DataName> [ <Additional information> ]
          *    METHOD <MethodName> [ <Additional information> ]
          *    ENDCLASS
          */

         IF UPPER( LEFT( cLine, 6 ) ) == "CLASS "
            cRest := LTRIM( SUBSTR( cLine, 7 ) )

            i := AT( " ", cRest )
            IF i > 0
              cClassName := LEFT( cRest, i - 1 )
              cRest      := SUBSTR( cRest, i + 1 )
            ELSE
               cClassName := cRest
               cRest      := ""
            ENDIF

            IF ASCAN( aTreeItems, cClassName ) > 0
               MSGSTOP( "CLASS " + cClassName + " already defined.", "Tree of ooHG's Classes, msg #2" )
               oMainForm:Release()
               RETURN Nil
            ENDIF

            IF UPPER( LEFT( cRest, 5 ) ) == "FROM "
               cParentClass := LTRIM( SUBSTR( cRest, 6 ) )

               IF RIGHT( cParentClass, 7 ) == " STATIC"
                  cParentClass := LEFT( cParentClass, LEN( cParentClass ) - 7 )
               ENDIF

               nPos := AT( ",", cParentClass )
               IF nPos > 0
                  /*
                   * Class has more than one parent
                   */
                  cOthers := ALLTRIM( SUBSTR( cParentClass, nPos + 1 ) )
                  aItems  := {}

                  cParentClass := ALLTRIM( LEFT( cParentClass, nPos - 1) )
               ENDIF

               nParentId := ASCAN( aTreeItems, cParentClass )
               IF nParentId > 0
                  AADD( aTreeItems, cClassName )
                  nClassId := LEN( aTreeItems )

                  oMainForm:Classes:AddItem( cClassName, nParentId, nClassId )
               ELSE
                  /*
                   * When class parent isn't defined yet
                   * add class to the orphaned list.
                   * This list contains class' name, class' parent,
                   * an array of class' datas and methods and a flag
                   * indicating if cClassName must be unique.
                   */
                  AADD( aOrphans, { cClassName, cParentClass, {}, Empty( cOthers ) } )
                  nClassId := 0
               ENDIF
            ELSE
               AADD( aTreeItems, cClassName )
               nClassId := LEN( aTreeItems )

               oMainForm:Classes:AddItem( cClassName, nil, nClassId )
            ENDIF
         ELSEIF UPPER( LEFT( cLine, 5 ) ) == "DATA " .OR. ;
                UPPER( LEFT( cLine, 7 ) ) == "METHOD " .OR. ;
                UPPER( LEFT( cLine, 8 ) ) == "MESSAGE " .OR. ;
                UPPER( LEFT( cLine, 9 ) ) == "DELEGATE " .OR. ;
                ( UPPER( LEFT( cLine, 6 ) ) == "ERROR " .AND. UPPER( LEFT( LTRIM( SUBSTR( cLine, 7 ) ), 8 ) ) == "HANDLER " )
            IF EMPTY( cClassName )
               MSGSTOP( "Found " + HB_OSNewLine() + cLine + HB_OSNewLine() + "without associated class.", "Tree of ooHG's Classes, msg #3" )
               oMainForm:Release()
               RETURN Nil
            ELSE
               IF ASCAN( aTreeItems, cClassName + cLine ) > 0
                  MSGSTOP( cLine + HB_OSNewLine() + " already defined in CLASS " + HB_OSNewLine() + cClassName + ".", "Tree of ooHG's Classes, msg #4" )
                  oMainForm:Release()
                  RETURN Nil
               ENDIF

               IF nClassId > 0
                  AADD( aTreeItems, cClassName + cLine )

                  oMainForm:Classes:AddItem( cLine, nClassId, LEN( aTreeItems ) )
               ELSE
                  AADD( aOrphans[LEN(aOrphans)][3], cLine )
               ENDIF

               IF ! EMPTY( cOthers )
                  AADD( aItems, cLine )
               ENDIF
            ENDIF
         ELSEIF UPPER( LEFT( cLine, 8 ) ) == "ENDCLASS"
            DO WHILE ! Empty( cOthers )
               nPos := AT( ",", cOthers )
               IF nPos > 0
                  cParentClass := ALLTRIM( LEFT( cOthers, nPos - 1 ) )
                  cOthers      := ALLTRIM( SUBSTR( cOthers, nPos + 1 ) )
               ELSE
                  cParentClass := cOthers
                  cOthers    := ""
               ENDIF

               nParentId := ASCAN( aTreeItems, cParentClass )
               IF nParentId > 0
                  AADD( aTreeItems, cClassName )
                  nClassId := LEN( aTreeItems )

                  oMainForm:Classes:AddItem( cClassName, nParentId, nClassId )
               ELSE
                  /*
                   * When class parent isn't defined yet
                   * add class to the orphaned list.
                   * This list contains class' name, class' parent,
                   * an array of class' datas and methods and a flag
                   * indicating if cClassName must be unique.
                   */
                  AADD( aOrphans, { cClassName, cParentClass, {}, .F. } )
                  nClassId := 0
               ENDIF

               FOR i := 1 TO LEN( aItems )
                  IF nClassId > 0
                     AADD( aTreeItems, cClassName + aItems[ i ] )

                     oMainForm:Classes:AddItem( aItems[ i ], nClassId, LEN( aTreeItems ) )
                  ELSE
                     AADD( aOrphans[LEN(aOrphans)][3], aItems[ i ] )
                  ENDIF
               NEXT i
            ENDDO

            cClassName := ""
            nClassId   := 0
            aItems     := {}
         ENDIF
      ENDDO
      
      oFile:Close()
      
      /*
       * Add orphaned classes
       */
      DO WHILE LEN( aOrphans ) > 0
         i := 1
         lNew := .F.

         DO WHILE i <= LEN( aOrphans )
            IF aOrphans[i][4] .AND. ASCAN( aTreeItems, aOrphans[i][1] ) > 0
               MSGSTOP( "CLASS " + aOrphans[i][1] + " already defined.", "Tree of ooHG's Classes, msg #5" )
               oMainForm:Release()
               RETURN Nil
            ENDIF

            /*
             * Check if parent is in the tree control
             */
            nParentId := ASCAN( aTreeItems, aOrphans[i][2] )
            IF nParentId > 0
               /*
                * If it is, add class to tree
                */
               AADD( aTreeItems, aOrphans[i][1] )
               nClassId := LEN( aTreeItems )

               oMainForm:Classes:AddItem( aOrphans[i][1], nParentId, nClassId )
               
               /*
                * Add datas and methods
                */
               FOR j := 1 to LEN( aOrphans[i][3] )
                  IF aOrphans[i][4] .AND. ASCAN( aTreeItems, aOrphans[i][1] + aOrphans[i][3][j] ) > 0
                     MSGSTOP( aOrphans[i][3][j] + HB_OSNewLine() + " already defined in CLASS " + HB_OSNewLine() + aOrphans[i][1] + ".", "Tree of ooHG's Classes, msg #6" )
                     oMainForm:Release()
                     RETURN Nil
                  ENDIF

                  AADD( aTreeItems, aOrphans[i][1] + aOrphans[i][3][j] )

                  oMainForm:Classes:AddItem( aOrphans[i][3][j], nClassId, LEN( aTreeItems ) )
               NEXT

               lNew := .T.
               
               /*
                * Delete orphan
                */
               ADEL( aOrphans, i )
               ASIZE( aOrphans, LEN( aOrphans ) - 1 )
               
               /*
                * Restart from the first item in aOrphans
                */
               EXIT
            ELSE
               /*
                * If it's not, process next item in aOrphans
                */
               i ++
            ENDIF
         ENDDO
         
         IF ! lNew
            MSGSTOP( "CLASS " + aOrphans[1][2] + " not defined.", "Tree of ooHG's Classes, msg #7" )
            oMainForm:Release()
            RETURN Nil
         ENDIF
      ENDDO

      IF LEN( aTreeItems ) == 0
         MSGSTOP( "CLASSES.TXT does not contains classes' data.", "Tree of ooHG's Classes, msg #8" )
         oMainForm:Release()
      ENDIF
   ENDIF

RETURN Nil

/*
 * C functions
 */
#pragma BEGINDUMP

#include <windows.h>
#include <hbapi.h>

/*
 * Get screen's number of dots per inch
 */
HB_FUNC( GETSCREENDPI )
{
   HDC hDC;
   int iDPI;

   memset ( &iDPI, 0, sizeof ( iDPI ) );
   memset ( &hDC, 0, sizeof ( hDC ) );

   hDC = GetDC( HWND_DESKTOP );

   iDPI = GetDeviceCaps( hDC, LOGPIXELSX );

   ReleaseDC( HWND_DESKTOP, hDC );

   hb_retni( iDPI );
}

#pragma ENDDUMP

/*
 * EOF
 */
