/*
 * $Id: treeofclasses.prg,v 1.1 2011-10-23 05:25:42 fyurisich Exp $
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
      ON INIT {|| MainFormResize( oMainForm ), Populate( oMainForm ) }

      DEFINE TREE Classes ;
         AT 20,20 ;
         WIDTH 600 ;
         HEIGHT 400 ;
         ITEMIDS

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
   LOCAL nClassId, nParentId, aClasses, aOrphans

   oFile := TFileRead():New( "CLASSES.TXT" )

   oFile:Open()

   IF oFile:Error()
      MSGSTOP( oFile:ErrorMsg( "FileRead: " ) )
      oMainForm:Release()
   ELSE
      aClasses := {}
      aOrphans := {}

      DO WHILE oFile:MoreToRead()
         cLine := oFile:ReadLine()
         
         /*
          * Just process the lines with the the following structures:
          *    CLASS <ClassName>
          *    CLASS <ClassName> FROM <ParentClassName>
          */

         IF UPPER( LEFT( cLine, 6 ) ) == "CLASS "
            cRest := SUBSTR( cLine, 7 )

            i := AT( " ", cRest )
            IF i > 0
              cClassName := LEFT( cRest, i - 1 )
              cRest := SUBSTR( cRest, i + 1 )
            ELSE
               cClassName := cRest
               cRest := ""
            ENDIF

            i := ASCAN( aClasses, cClassName )
            IF i > 0
               MSGSTOP( "Class " + cClassName + " already defined." )
               oMainForm:Release()
               RETURN Nil
            ENDIF

            IF UPPER( LEFT( cRest, 5 ) ) == "FROM "
               cParentClass := RTRIM( SUBSTR( cRest, 6 ) )

               nParentId := ASCAN( aClasses, cParentClass )
               IF nParentId > 0
                  AADD( aClasses, cClassName )
                  nClassId := LEN( aClasses )

                  oMainForm:Classes:AddItem( cClassName, nParentId, nClassId )
               ELSE
                  /*
                   * When class parent isn't defined yet
                   * add class to the orphaned list
                   */
                  AADD( aOrphans, { cClassName, cParentClass } )
               ENDIF
            ELSE
               AADD( aClasses, cClassName )
               nClassId := LEN( aClasses )

               oMainForm:Classes:AddItem( cClassName, nil, nClassId )
            ENDIF
         ENDIF
      ENDDO
      
      oFile:Close()
      
      /*
       * Add orphaned classes
       */
      DO WHILE LEN( aOrphans ) > 0
         i := 1
         
         DO WHILE i <= LEN( aOrphans )
            j := ASCAN( aClasses, aOrphans[i][1] )

            IF j > 0
               MSGSTOP( "Class " + aOrphans[i][1] + " already defined." )
               oMainForm:Release()
               RETURN Nil
            ENDIF

            nParentId := ASCAN( aClasses, aOrphans[i][2] )

            IF nParentId > 0
               AADD( aClasses, aOrphans[i][1] )
               nClassId := LEN( aClasses )

               oMainForm:Classes:AddItem( aOrphans[i][1], nParentId, nClassId )

               ADEL( aOrphans, i )
               ASIZE( aOrphans, LEN( aOrphans ) - 1 )
               
               EXIT
            ELSE
               i ++
            ENDIF
         ENDDO
      ENDDO

      IF LEN( aClasses ) == 0
         MSGSTOP( "CLASSES.TXT does not contains classes' data." )
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
