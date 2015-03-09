/*
 * $Id: rtl.prg,v 1.2 2015-03-09 02:52:06 fyurisich Exp $
 */
/*
* ooHG Right-to-left demo
* (c) 2005-2015 Vic
*/

#include "oohg.ch"

Function Main()
Local oWnd

   SET GLOBALRTL ON

   DEFINE WINDOW Main OBJ oWnd ;
          AT 0,0 ;
          WIDTH 400 ;
          HEIGHT 300 ;
          TITLE 'Right-To-Left demo' ;
          MAIN ;
          VIRTUAL HEIGHT 400 ;
          RTL

      DEFINE MAIN MENU
         POPUP "One"
            ITEM "Checked"  CHECKED  ACTION MsgInfo( "Checked click!" )
            ITEM "Disabled" DISABLED ACTION MsgInfo( "Disabled click!" )
            SEPARATOR
            ITEM "Exit"              ACTION oWnd:Release()
         END POPUP
         POPUP "Two"
            POPUP "SubMenu 1" CHECKED
               POPUP "SubMenu 1.1"
                  POPUP "SubMenu 1.1.1"
                     ITEM "SubMenu 1.1.1 item" ACTION MsgInfo( "SubMenu 1.1.1 item click!" )
                  END POPUP
               END POPUP
            END POPUP
            POPUP "SubMenu 2" DISABLED
               ITEM "SubMenu 2 item" ACTION MsgInfo( "SubMenu 2 item click!" )
            END POPUP
            ITEM "Item 3" ACTION MsgInfo( "Item 3 click!" )
         END POPUP
         ITEM "Exit" ACTION oWnd:Release()
      END MENU

      @  10, 10 BUTTON Button1 CAPTION "Window RTL ON"   WIDTH 130 HEIGHT 25 ACTION ( oWnd:RTL := .T. )

      @  40, 10 BUTTON Button2 CAPTION "Window RTL OFF"  WIDTH 130 HEIGHT 25 ACTION ( oWnd:RTL := .F. )

      @  70, 10 BUTTON Button3 CAPTION "ListBox RTL ON"  WIDTH 130 HEIGHT 25 ACTION ( oWnd:ListBox:RTL := .T. )

      @ 100, 10 BUTTON Button4 CAPTION "ListBox RTL OFF" WIDTH 130 HEIGHT 25 ACTION ( oWnd:ListBox:RTL := .F. )

      @  10,160 LISTBOX ListBox ITEMS { "Listbox 1", "Listbox 2", "Listbox 3" } WIDTH 150 HEIGHT 100

      DEFINE STATUSBAR
         STATUSITEM "RTL statusbar's test!"
         CLOCK
      END STATUSBAR

   END WINDOW
   oWnd:Center()
   oWnd:Activate()

Return
