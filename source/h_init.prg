/*
 * $Id: h_init.prg $
 */
/*
 * ooHG source code:
 * Initialization procedure
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
#include "i_init.ch"

#define DOUBLE_QUOTATION_MARK '"'
#define DQM( x )              ( DOUBLE_QUOTATION_MARK + x + DOUBLE_QUOTATION_MARK )

STATIC _OOHG_Messages := { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }
STATIC _OOHG_Language := NIL

/*--------------------------------------------------------------------------------------------------------------------------------*/
INIT PROCEDURE _OOHG_Init()

   TApplication():New()
   InitMessages_C_Side( _OOHG_Messages )
   InitMessages()

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
EXIT PROCEDURE _OOHG_Exit()

   IF HB_ISOBJECT( _OOHG_AppObject() )
      _OOHG_AppObject():Release()
   ENDIF

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
PROCEDURE InitMessages( cLang )

   LOCAL aLang, aLangDefault, nAt

   App.MutexLock

   IF ! ValType( cLang ) $ "CM" .OR. Empty( cLang )
      cLang := Set( _SET_LANGUAGE )
   ENDIF
   IF ( nAt := At( ".", cLang ) ) > 0
      cLang := Left( cLang, nAt - 1 )
   ENDIF
   cLang := Upper( AllTrim( cLang ) )
   _OOHG_Language := cLang

   aLang := _OOHG_MacroCall( "ooHG_Messages_" + cLang + "()" )
   IF ValType( aLang ) != "A"
      aLang := {}
   ENDIF

   aLangDefault := ooHG_Messages_EN()

   _OOHG_Messages[ MT_MISCELL ] := InitMessagesMerge( aLang, aLangDefault, MT_MISCELL )
   _OOHG_Messages[ MT_BRW_BTN ] := InitMessagesMerge( aLang, aLangDefault, MT_BRW_BTN )
   _OOHG_Messages[ MT_BRW_ERR ] := InitMessagesMerge( aLang, aLangDefault, MT_BRW_ERR )
   _OOHG_Messages[ MT_BRW_MSG ] := InitMessagesMerge( aLang, aLangDefault, MT_BRW_MSG )
   _OOHG_Messages[ MT_ABM_USR ] := InitMessagesMerge( aLang, aLangDefault, MT_ABM_USR )
   _OOHG_Messages[ MT_ABM_LBL ] := InitMessagesMerge( aLang, aLangDefault, MT_ABM_LBL )
   _OOHG_Messages[ MT_ABM_BTN ] := InitMessagesMerge( aLang, aLangDefault, MT_ABM_BTN )
   _OOHG_Messages[ MT_ABM_ERR ] := InitMessagesMerge( aLang, aLangDefault, MT_ABM_ERR )
   _OOHG_Messages[ MT_EXT_BTN ] := InitMessagesMerge( aLang, aLangDefault, MT_EXT_BTN )
   _OOHG_Messages[ MT_EXT_LBL ] := InitMessagesMerge( aLang, aLangDefault, MT_EXT_LBL )
   _OOHG_Messages[ MT_EXT_USR ] := InitMessagesMerge( aLang, aLangDefault, MT_EXT_USR )
   _OOHG_Messages[ MT_PRINTER ] := InitMessagesMerge( aLang, aLangDefault, MT_PRINTER )

   _OOHG_SetErrorMsgs( _OOHG_Messages( MT_MISCELL, 9 ), _OOHG_Messages( MT_MISCELL, 10 ) )

   App.MutexUnlock

   RETURN

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_GetLanguage()

   RETURN _OOHG_Language

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION _OOHG_Messages( nTable, nItem, nSubItem )

   LOCAL uData, cRet

   App.MutexLock

   IF ValType( nTable ) == "N" .AND. nTable >= 1 .AND. nTable <= Len( _OOHG_Messages )
      IF ValType( nItem ) == "N" .AND. nItem >= 1 .AND. nItem <= Len( _OOHG_Messages[ nTable] )
         uData := _OOHG_Messages[ nTable ][ nItem ]
         IF ValType( nSubItem ) == "N" .AND. HB_ISARRAY( uData ) .AND. nSubItem >= 1 .AND. nSubItem <= Len( uData )
            cRet := uData[ nSubItem ]
         ELSE
            cRet := uData
         ENDIF
      ELSE
         cRet := ""
      ENDIF
   ELSE
      cRet := ""
   ENDIF

   App.MutexUnlock

   RETURN cRet

/*--------------------------------------------------------------------------------------------------------------------------------*/
STATIC FUNCTION InitMessagesMerge( aLang, aLangDefault, nTable )

   LOCAL aReturn

   aReturn := AClone( aLangDefault[ nTable ] )
   IF Len( aLang ) >= nTable .AND. ValType( aLang[ nTable ] ) == "A"
      AEval( aReturn, { |c,i| iif( Len( aLang[ nTable ] ) >= i .AND. ValType( aLang[ nTable ][ i ] ) $ "CM", aReturn[ i ] := aLang[ nTable ][ i ], c ) } )
   ENDIF

   RETURN aReturn

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_EN // English (default)

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISCELLANEOUS MESSAGES
   // MT_MISCELL
   acMisc           := { 'Are you sure?', ;                                                                                         // 1
                         'The window is about to close...', ;                                                                       // 2
                         'Close is not allowed!', ;                                                                                 // 3
                         'Program is already running!', ;                                                                           // 4
                         'Edit', ;                                                                                                  // 5
                         'Ok', ;                                                                                                    // 6
                         'Cancel', ;                                                                                                // 7
                         'Page', ;                                                                                                  // 8
                         'Error', ;                                                                                                 // 9
                         'Warning', ;                                                                                               // 10
                         'Edit Memo', ;                                                                                             // 11
                         "Can't determine cell type for INPLACE edit.", ;                                                           // 12
                         "Excel is not available!", ;                                                                               // 13
                         "OpenOffice is not available!", ;                                                                          // 14
                         "OpenOffice Desktop is not available!", ;                                                                  // 15
                         "OpenOffice Calc is not available!", ;                                                                     // 16
                         " successfully installed.", ;                                                                              // 17
                         " not installed.", ;                                                                                       // 18
                         "Error creating TReg32 object ", ;                                                                         // 19
                         "This screen saver has no configurable options.", ;                                                        // 20
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends!", ;                                                                         // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed!", ;                                                                      // 24
                         "File is already encrypted!", ;                                                                            // 25
                         "File is not encrypted!", ;                                                                                // 26
                         "Password is not valid!", ;                                                                                // 27
                         "The names of the new file and the old file must be different!", ;                                         // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   //MT_BRW_BTN
   acBrowseButton   := { "Append", ;
                         "Edit", ;
                         "&Cancel", ;
                         "&OK" }
   //MT_BRW_ERR
   acBrowseError    := { "Window: ", ;
                         " is not defined. Program terminated.", ;
                         "Error", ;
                         "Control: ", ;
                         " Of ", ;
                         " Already defined. Program terminated.", ;
                         "Browse: Type Not Allowed. Program terminated.", ;
                         "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program terminated.", ;
                         "Record Is Being Edited By Another User", ;
                         "Warning", ;
                         "Invalid Entry" }
   //MT_BRW_MSG
   acBrowseMessages := { 'Are you sure?', ;
                         'Delete Record', ;
                         'Delete Item' }

   // EDIT MESSAGES
   // MT_ABM_USR
   acABMUser        := { CRLF + "Delete record" + CRLF + "Are you sure?" + CRLF, ;
                         CRLF + "Index file missing" + CRLF + "Can't do search" + CRLF, ;
                         CRLF + "Can't find index field" + CRLF + "Can't do search" + CRLF, ;
                         CRLF + "Can't do search by" + CRLF + "fields memo or logic" + CRLF, ;
                         CRLF + "Record not found" + CRLF, ;
                         CRLF + "Too many cols" + CRLF + "The report don't fit in the sheet" + CRLF, ;
                         CRLF + "Record is locked by another user" + CRLF + "Retry later" + CRLF }
   // MT_ABM_LBL
   acABMLabel       := { "Record", ;
                         "Record count", ;
                         "       (New)", ;
                         "      (Edit)", ;
                         "Enter record number", ;
                         "Find", ;
                         "Search text", ;
                         "Search date", ;
                         "Search number", ;
                         "Report definition", ;
                         "Report columns", ;
                         "Available columns", ;
                         "Initial record", ;
                         "Final record", ;
                         "Report of ", ;
                         "Date:", ;
                         "Initial record:", ;
                         "Final record:", ;
                         "Ordered by:", ;
                         "Yes", ;
                         "No", ;
                         "Page ", ;
                         " of " }
   // MT_ABM_BTN
   acABMButton      := { "Close", ;
                         "New", ;
                         "Edit", ;
                         "Delete", ;
                         "Find", ;
                         "Goto", ;
                         "Report", ;
                         "First", ;
                         "Previous", ;
                         "Next", ;
                         "Last", ;
                         "Save", ;
                         "Cancel", ;
                         "Add", ;
                         "Remove", ;
                         "Print", ;
                         "Close" }
   // MT_ABM_ERR
   acABMError       := { "EDIT, workarea name is missing", ;
                         "EDIT, this workarea has more than 16 fields", ;
                         "EDIT, refresh mode out of range (please report bug)", ;
                         "EDIT, main event number out of range (please report bug)", ;
                         "EDIT, list event number out of range (please report bug)" }

   // EDIT EXTENDED MESSAGES
   // MT_EXT_BTN
   acButton         := { "&Close", ;                                            // 1
                         "&New", ;                                              // 2
                         "&Modify", ;                                           // 3
                         "&Delete", ;                                           // 4
                         "&Find", ;                                             // 5
                         "&Print", ;                                            // 6
                         "&Cancel", ;                                           // 7
                         "&Ok", ;                                               // 8
                         "&Copy", ;                                             // 9
                         "&Activate Filter", ;                                  // 10
                         "&Deactivate Filter" }                                 // 11
   // MT_EXT_LBL
   acLabel          := { "None", ;                                              // 1
                         "Record", ;                                            // 2
                         "Total", ;                                             // 3
                         "Active order", ;                                      // 4
                         "Options", ;                                           // 5
                         "New record", ;                                        // 6
                         "Modify record", ;                                     // 7
                         "Select record", ;                                     // 8
                         "Find record", ;                                       // 9
                         "Print options", ;                                     // 10
                         "Available fields", ;                                  // 11
                         "Fields to print", ;                                   // 12
                         "Available printers", ;                                // 13
                         "First record to print", ;                             // 14
                         "Last record to print", ;                              // 15
                         "Delete record", ;                                     // 16
                         "Preview", ;                                           // 17
                         "View page thumbnails", ;                              // 18
                         "Filter Condition: ", ;                                // 19
                         "Filtered: ", ;                                        // 20
                         "Filtering Options", ;                                 // 21
                         "Database Fields", ;                                   // 22
                         "Comparission Operator", ;                             // 23
                         "Filter Value", ;                                      // 24
                         "Select Field To Filter", ;                            // 25
                         "Select Comparission Operator", ;                      // 26
                         "Equal", ;                                             // 27
                         "Not Equal", ;                                         // 28
                         "Greater Than", ;                                      // 29
                         "Lower Than", ;                                        // 30
                         "Greater or Equal Than", ;                             // 31
                         "Lower or Equal Than" }                                // 32
   // MT_EXT_USR
   acUser           := { CRLF + "Can't find an active area" + CRLF + "Please select any area before calling EDIT" + CRLF, ;          // 1
                         "Type the field value (any text)", ;                                                                        // 2
                         "Type the field value (any number)", ;                                                                      // 3
                         "Select the date", ;                                                                                        // 4
                         "Check for true value", ;                                                                                   // 5
                         "Enter the field value", ;                                                                                  // 6
                         "Select any record and press OK", ;                                                                         // 7
                         CRLF + "You are going to delete the active record" + CRLF + "Are you sure?" + CRLF, ;                       // 8
                         CRLF + "There isn't any active order" + CRLF + "Please select one" + CRLF, ;                                // 9
                         CRLF + "Can't do searches by fields memo or logic" + CRLF, ;                                                // 10
                         CRLF + "Record not found" + CRLF, ;                                                                         // 11
                         "Select the field to include to list", ;                                                                    // 12
                         "Select the field to exclude from list", ;                                                                  // 13
                         "Select the printer", ;                                                                                     // 14
                         "Push button to include field", ;                                                                           // 15
                         "Push button to exclude field", ;                                                                           // 16
                         "Push button to select the first record to print", ;                                                        // 17
                         "Push button to select the last record to print", ;                                                         // 18
                         CRLF + "No more fields to include" + CRLF, ;                                                                // 19
                         CRLF + "First select the field to include" + CRLF, ;                                                        // 20
                         CRLF + "No more fields to exlude" + CRLF, ;                                                                 // 21
                         CRLF + "First select th field to exclude" + CRLF, ;                                                         // 22
                         CRLF + "You don't select any field" + CRLF + "Please select the fields to include on print" + CRLF, ;       // 23
                         CRLF + "Too many fields" + CRLF + "Reduce number of fields" + CRLF, ;                                       // 24
                         CRLF + "Printer not ready" + CRLF, ;                                                                        // 25
                         "Ordered by", ;                                                                                             // 26
                         "From record", ;                                                                                            // 27
                         "To record", ;                                                                                              // 28
                         "Yes", ;                                                                                                    // 29
                         "No", ;                                                                                                     // 30
                         "Page:", ;                                                                                                  // 31
                         CRLF + "Please select a printer" + CRLF, ;                                                                  // 32
                         "Filtered by", ;                                                                                            // 33
                         CRLF + "There is an active filter" + CRLF, ;                                                                // 34
                         CRLF + "Can't filter by memo fields" + CRLF, ;                                                              // 35
                         CRLF + "Select the field to filter" + CRLF, ;                                                               // 36
                         CRLF + "Select any operator to filter" + CRLF, ;                                                            // 37
                         CRLF + "Type any value to filter" + CRLF, ;                                                                 // 38
                         CRLF + "There isn't any active filter" + CRLF, ;                                                            // 39
                         CRLF + "Deactivate filter?" + CRLF, ;                                                                       // 40
                         CRLF + "Record locked by another user" + CRLF }                                                             // 41

   // PRINT MESSAGES
   // MT_PRINTER
   acPrint          := { "TPrint object already initialized!", ;                                                                     // 1
                         "Printing ......", ;                                                                                        // 2
                         "Auxiliar printing command", ;                                                                              // 3
                         " PRINTED OK !!!", ;                                                                                        // 4
                         "Invalid parameters passed to function !!!", ;                                                              // 5
                         "WinAPI OpenPrinter() call failed !!!", ;                                                                   // 6
                         "WinAPI StartDocPrinter() call failed !!!", ;                                                               // 7
                         "WinAPI StartPagePrinter() call failed !!!", ;                                                              // 8
                         "WinAPI malloc() call failed !!!", ;                                                                        // 9
                         " NOT FOUND !!!", ;                                                                                         // 10
                         "No printer found !!!", ;                                                                                   // 11
                         "Error", ;                                                                                                  // 12
                         "Port is not valid !!!", ;                                                                                  // 13
                         "Select printer", ;                                                                                         // 14
                         "OK", ;                                                                                                     // 15
                         "Cancel", ;                                                                                                 // 16
                         'Preview -----> ', ;                                                                                        // 17
                         "Close", ;                                                                                                  // 18
                         "Close", ;                                                                                                  // 19
                         "Zoom + ", ;                                                                                                // 20
                         "Zoom + ", ;                                                                                                // 21
                         "Zoom -", ;                                                                                                 // 22
                         "Zoom -", ;                                                                                                 // 23
                         { "Print", "Save" }, ;                                                                                      // 24
                         { "Print mode: ", "Save mode: " }, ;                                                                        // 25
                         "Search", ;                                                                                                 // 26
                         "Search", ;                                                                                                 // 27
                         "Next search", ;                                                                                            // 28
                         "Next search", ;                                                                                            // 29
                         'Text: ', ;                                                                                                 // 30
                         'Search string', ;                                                                                          // 31
                         "Search ended.", ;                                                                                          // 32
                         "Information", ;                                                                                            // 33
                         'Excel not found !!!', ;                                                                                    // 34
                         "XLS extension not asociated !!!", ;                                                                        // 35
                         "File saved in: ", ;                                                                                        // 36
                         "HTML extension not asociated !!!", ;                                                                       // 37
                         "RTF extension not asociated !!!", ;                                                                        // 38
                         "CSV extension not asociated !!!", ;                                                                        // 39
                         "PDF extension not asociated !!!", ;                                                                        // 40
                         "ODT extension not asociated !!!", ;                                                                        // 41
                         'Barcodes require a character value !!!', ;                                                                 // 42
                         'Code 128 modes are A, B or C (character values) !!!', ;                                                    // 43
                         "Calc not found !!!", ;                                                                                     // 44
                         "Error saving file: ", ;                                                                                    // 45
                         "TPrint preview is already active!", ;                                                                      // 46
                         "TPrint document is already open!", ;                                                                       // 47
                         "TPrint object is not initialized!", ;                                                                      // 48
                         "TPrint object is in error state!", ;                                                                       // 49
                         "TPrint document is not open!" }                                                                            // 50

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_HR852 // Croatian

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Are you sure?', ;
                         'Zatvori prozor', ;
                         'Zatvaranje nije dozvoljeno', ;
                         'Program je veæ pokrenut', ;
                         'Uredi', ;
                         'U redu', ;
                         'Prekid', ;
                         'Pag.', ;
                         'Pogreška', ;
                         'Upozorenje', ;
                         'Uredi Memo', ;
                         "Can't determine cell type for INPLACE edit.", ;
                         "Excel is not available!", ;
                         "OpenOffice is not available!", ;
                         "OpenOffice Desktop is not available!", ;
                         "OpenOffice Calc is not available!", ;
                         " successfully installed.", ;
                         " not installed.", ;
                         "Error creating TReg32 object ", ;
                         "This screen saver has no configurable options.", ;
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends!", ;                                                                        // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed !!!", ;                                                                   // 24
                         "File is already encrypted !!!", ;                                                                         // 25
                         "File is not encrypted !!!", ;                                                                             // 26
                         "Password is invalid !!!", ;                                                                               // 27
                         "The names of the new file and the old file must be different !!!", ;                                      // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := {}
   acBrowseError    := {}
   acBrowseMessages := {}

   // EDIT MESSAGES
   acABMUser        := {}
   acABMLabel       := {}
   acABMButton      := {}
   acABMError       := {}

   // EDIT EXTENDED MESSAGES
   acButton         := {}
   acLabel          := {}
   acUser           := {}

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_EU // Basque

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := {}

   // BROWSE MESSAGES
   acBrowseButton   := {}
   acBrowseError    := {}
   acBrowseMessages := {}

   // EDIT MESSAGES
   acABMUser        := {}
   acABMLabel       := {}
   acABMButton      := {}
   acABMError       := {}

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Itxi", ;                                             // 1
                         "&Berria", ;                                           // 2
                         "&Aldatu", ;                                           // 3
                         "&Ezabatu", ;                                          // 4
                         "Bi&latu", ;                                           // 5
                         "In&primatu", ;                                        // 6
                         "&Utzi", ;                                             // 7
                         "&Ok", ;                                               // 8
                         "&Kopiatu", ;                                          // 9
                         "I&ragazkia Ezarri", ;                                 // 10
                         "Ira&gazkia Kendu" }                                   // 11
   acLabel          := { "Bat ere ez", ;                                        // 1
                         "Erregistroa", ;                                       // 2
                         "Guztira", ;                                           // 3
                         "Orden Aktiboa", ;                                     // 4
                         "Aukerak", ;                                           // 5
                         "Erregistro Berria", ;                                 // 6
                         "Erregistroa Aldatu", ;                                // 7
                         "Erregistroa Aukeratu", ;                              // 8
                         "Erregistroa Bilatu", ;                                // 9
                         "Inprimatze-aukerak", ;                                // 10
                         "Eremu Libreak", ;                                     // 11
                         "Inprimatzeko Eremuak", ;                              // 12
                         "Inprimagailu Libreak", ;                              // 13
                         "Inprimatzeko Lehenengo Erregistroa", ;                // 14
                         "Inprimatzeko Azken Erregistroa", ;                    // 15
                         "Erregistroa Ezabatu", ;                               // 16
                         "Aurreikusi", ;                                        // 17
                         "Orrien Irudi Txikiak Ikusi", ;                        // 18
                         "Iragazkiaren Baldintza: ", ;                          // 19
                         "Iragazita: ", ;                                       // 20
                         "Iragazte-aukerak", ;                                  // 21
                         "Datubasearen Eremuak", ;                              // 22
                         "Konparaketa Eragilea", ;                              // 23
                         "Iragazkiaren Balioa", ;                               // 24
                         "Iragazteko Eremua Aukeratu", ;                        // 25
                         "Konparaketa Eragilea Aukeratu", ;                     // 26
                         "Berdin", ;                                            // 27
                         "Ezberdin", ;                                          // 28
                         "Handiago", ;                                          // 29
                         "Txikiago", ;                                          // 30
                         "Handiago edo Berdin", ;                               // 31
                         "Txikiago edo Berdin" }                                // 32
   acUser           := { CRLF + "Ezin da area aktiborik aurkitu.   " + CRLF + "Mesedez aukeratu area EDIT deitu baino lehen   " + CRLF, ;  // 1
                         "Eremuaren balioa idatzi (edozein testu)", ;                                                                      // 2
                         "Eremuaren balioa idatzi (edozein zenbaki)", ;                                                                    // 3
                         "Data aukeratu", ;                                                                                                // 4
                         "Markatu egiazko baliorako", ;                                                                                    // 5
                         "Eremuaren balioa sartu", ;                                                                                       // 6
                         "Edozein erregistro aukeratu eta OK sakatu", ;                                                                    // 7
                         CRLF + "Erregistro aktiboa ezabatuko duzu   " + CRLF + "Ziur zaude?    " + CRLF, ;                                // 8
                         CRLF + "Ez dago orden aktiborik   " + CRLF + "Mesedez aukeratu bat   " + CRLF, ;                                  // 9
                         CRLF + "Memo edo eremu logikoen arabera ezin bilaketarik egin   " + CRLF, ;                                       // 10
                         CRLF + "Erregistroa ez da aurkitu   " + CRLF, ;                                                                   // 11
                         "Zerrendan sartzeko eremua aukeratu", ;                                                                           // 12
                         "Zerrendatik kentzeko eremua aukeratu", ;                                                                         // 13
                         "Inprimagailua aukeratu", ;                                                                                       // 14
                         "Sakatu botoia eremua sartzeko", ;                                                                                // 15
                         "Sakatu botoia eremua kentzeko", ;                                                                                // 16
                         "Sakatu botoia inprimatzeko lehenengo erregistroa aukeratzeko", ;                                                 // 17
                         "Sakatu botoia inprimatzeko azken erregistroa aukeratzeko", ;                                                     // 18
                         CRLF + "Sartzeko eremu gehiagorik ez   " + CRLF, ;                                                                // 19
                         CRLF + "Lehenago aukeratu sartzeko eremua   " + CRLF, ;                                                           // 20
                         CRLF + "Kentzeko eremu gehiagorik ez   " + CRLF, ;                                                                // 21
                         CRLF + "Lehenago aukeratu kentzeko eremua   " + CRLF, ;                                                           // 22
                         CRLF + "Ez duzu eremurik aukeratu  " + CRLF + "Mesedez aukeratu inprimaketan sartzeko eremuak   " + CRLF, ;       // 23
                         CRLF + "Eremu gehiegi   " + CRLF + "Murriztu eremu kopurua   " + CRLF, ;                                          // 24
                         CRLF + "Inprimagailua ez dago prest   " + CRLF, ;                                                                 // 25
                         "Ordenatuta honen arabera:", ;                                                                                    // 26
                         "Erregistro honetatik:", ;                                                                                        // 27
                         "Erregistro honetara:", ;                                                                                         // 28
                         "Bai", ;                                                                                                          // 29
                         "Ez", ;                                                                                                           // 30
                         "Orrialdea:", ;                                                                                                   // 31
                         CRLF + "Mesedez aukeratu inprimagailua   " + CRLF, ;                                                              // 32
                         "Iragazita honen arabera:", ;                                                                                     // 33
                         CRLF + "Iragazki aktiboa dago    " + CRLF, ;                                                                      // 34
                         CRLF + "Ezin iragazi Memo eremuen arabera    " + CRLF, ;                                                          // 35
                         CRLF + "Iragazteko eremua aukeratu    " + CRLF, ;                                                                 // 36
                         CRLF + "Iragazteko edozein eragile aukeratu    " + CRLF, ;                                                        // 37
                         CRLF + "Idatzi edozein balio iragazteko    " + CRLF, ;                                                            // 38
                         CRLF + "Ez dago iragazki aktiborik    " + CRLF, ;                                                                 // 39
                         CRLF + "Iragazkia kendu?   " + CRLF, ;                                                                            // 40
                         CRLF + "Record locked by another user" + CRLF }                                                                   // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_FR // French

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Etes-vous sûre ?', ;
                         'Fermer la fenêtre', ;
                         'Fermeture interdite', ;
                         'Programme déjà activé', ;
                         'Editer', ;
                         'Ok', ;
                         'Abandonner', ;
                         'Pag.', ;
                         'Erreur', ;
                         'Alerte', ;
                         'Editer Memo', ;
                         "Can't determine cell type for INPLACE edit.", ;
                         "Excel n'est pas disponible.", ;
                         "OpenOffice n'est pas disponible.", ;
                         "OpenOffice Desktop n'est pas disponible.", ;
                         "OpenOffice Calc n'est pas disponible.", ;
                         " installé avec succès.", ;
                         " pas installé.", ;
                         "Erreur lors de la création de l'objet TReg32 ", ;
                         "Cet économiseur d'écran n'a pas d'options configurables.", ;
                         "Impossible d'ouvrir le fichier ", ;                                                                       // 21
                         "Pas assez d'espace pour les légendes !!!", ;                                                              // 22
                         "Le format du rapport n'est pas valide ", ;                                                                // 23
                         { "Le format du rapport n'est pas valide: aucun " + DQM( "DO REPORT" ) + ' ni ' + DQM( "DEFINE REPORT" ) + ' trouvé!', ;
                           "Le format du rapport n'est pas valide: aucun " + DQM( "FIELDS" ) + " trouvé!", ;
                           "Le format du rapport n'est pas valide: aucun " + DQM( "FIELDS" ) + " trouvé!", ;
                           "Le format du rapport n'est pas valide: aucun " + DQM( "WIDTHS" ) + " trouvé!", ;
                           "Le format du rapport n'est pas valide: aucun " + DQM( "WIDTHS" ) + " trouvé!" }, ;                      // 23
                         "Erreur d' E/S de fichier, impossible de continuer !!!", ;                                                 // 24
                         "Le fichier est déjà crypté !!!", ;                                                                        // 25
                         "Le fichier n'est pas crypté !!!", ;                                                                       // 26
                         "Le mot de passe est invalide !!!", ;                                                                      // 27
                         "Les noms du nouveau fichier et de l'ancien fichier doivent être différents !!!", ;                        // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Ajout", ;
                         "Modification", ;
                         "Annuler", ;
                         "OK" }
   acBrowseError    := { "Fenêtre: ", ;
                         " n'est pas définie. Programme Terminé.", ;
                         "Erreur", ;
                         "Contrôle: ", ;
                         " De ", ;
                         " Déjà défini. Programme Terminé.", ;
                         "Modification: Type non autorisé. Programme Terminé.", ;
                         "Modification: La clause Ajout ne peut être utilisée avec des champs n'appartenant pas à la zone de travail de Modification. Programme Terminé", ;
                         "L'enregistrement est utilisé par un autre utilisateur", ;
                         "Erreur", ;
                         "Entrée invalide" }
   acBrowseMessages := { 'Etes-vous sûre ?', ;
                         'Suprimer Enregistrement', ;
                         'Supprimer Élément' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Suppression d'enregistrement" + CRLF + "Etes-vous sûre ?" + CRLF, ;
                         CRLF + "Index manquant" + CRLF + "Recherche impossible" + CRLF, ;
                         CRLF + "Champ Index introuvable" + CRLF + "Recherche impossible" + CRLF, ;
                         CRLF + "Recherche impossible" + CRLF + "sur champs memo ou logique" + CRLF, ;
                         CRLF + "Enregistrement non trouvé" + CRLF, ;
                         CRLF + "Trop de colonnes" + CRLF + "L'état ne peut être imprimé" + CRLF, ;
                         CRLF + "L'enregistrement est verrouillé par un autre utilisateur" + CRLF + "Réessayer plus tard" + CRLF }
   acABMLabel       := { "Enregistrement", ;
                         "Nb. total enr.", ;
                         "   (Ajouter)", ;
                         "  (Modifier)", ;
                         "Entrez le numéro de l'enregistrement", ;
                         "Trouver", ;
                         "Chercher texte", ;
                         "Chercher date", ;
                         "Chercher numéro", ;
                         "Définition de l'état", ;
                         "Colonnes de l'état", ;
                         "Colonnes disponibles", ;
                         "Enregistrement de début", ;
                         "Enregistrement de fin", ;
                         "Etat de ", ;
                         "Date:", ;
                         "Enregistrement de début:", ;
                         "Enregistrement de fin:", ;
                         "Trié par:", ;
                         "Oui", ;
                         "Non", ;
                         " Page", ;
                         " de " }
   acABMButton      := { "Fermer", ;
                         "Nouveau", ;
                         "Modifier", ;
                         "Supprimer", ;
                         "Trouver", ;
                         "Aller à", ;
                         "Etat", ;
                         "Premier", ;
                         "Précédent", ;
                         "Suivant", ;
                         "Dernier", ;
                         "Enregistrer", ;
                         "Annuler", ;
                         "Ajouter", ;
                         "Retirer", ;
                         "Imprimer", ;
                         "Fermer" }
   acABMError       := { "EDIT, nom de la table manquant", ;
                         "EDIT, la table a plus de 16 champs", ;
                         "EDIT, mode rafraichissement hors limite (Rapport d'erreur merci)", ;
                         "EDIT, événement principal nombre hors limite (Rapport d'erreur merci)", ;
                         "EDIT, liste d'événements nombre hors limite (Rapport d'erreur merci)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Fermer", ;                                           // 1
                         "&Nouveau", ;                                          // 2
                         "&Modifier", ;                                         // 3
                         "&Supprimer", ;                                        // 4
                         "&Trouver", ;                                          // 5
                         "&Imprimer", ;                                         // 6
                         "&Abandon", ;                                          // 7
                         "&Ok", ;                                               // 8
                         "&Copier", ;                                           // 9
                         "&Activer Filtre", ;                                   // 10
                         "&Déactiver Filtre" }                                  // 11
   acLabel          := { "Aucun", ;                                             // 1
                         "Enregistrement", ;                                    // 2
                         "Total", ;                                             // 3
                         "Ordre actif", ;                                       // 4
                         "Options", ;                                           // 5
                         "Nouvel enregistrement", ;                             // 6
                         "Modifier enregistrement", ;                           // 7
                         "Selectionner enregistrement", ;                       // 8
                         "Trouver enregistrement", ;                            // 9
                         "Imprimer options", ;                                  // 10
                         "Champs disponibles", ;                                // 11
                         "Champs à imprimer", ;                                 // 12
                         "Imprimantes connectées", ;                            // 13
                         "Premier enregistrement à imprimer", ;                 // 14
                         "Dernier enregistrement à imprimer", ;                 // 15
                         "Enregistrement supprimé", ;                           // 16
                         "Prévisualisation", ;                                  // 17
                         "Aperçu pages", ;                                      // 18
                         "Condition filtre : ", ;                               // 19
                         "Filtré : ", ;                                         // 20
                         "Options de filtrage", ;                               // 21
                         "Champs de la Bdd", ;                                  // 22
                         "Opérateurs de comparaison", ;                         // 23
                         "Valeur du filtre", ;                                  // 24
                         "Selectionner le champ à filtrer", ;                   // 25
                         "Selectionner l'opérateur de comparaison", ;           // 26
                         "Egal", ;                                              // 27
                         "Différent", ;                                         // 28
                         "Plus grand", ;                                        // 29
                         "Plus petit", ;                                        // 30
                         "Plus grand ou égal", ;                                // 31
                         "Plus petit ou égal" }                                 // 32
   acUser           := { CRLF + "Ne peut trouver une base active.   " + CRLF + "Sélectionner une base avant la fonction EDIT  " + CRLF, ;            // 1
                         "Entrer la valeur du champ (du texte)", ;                                                                                   // 2
                         "Entrer la valeur du champ (un nombre)", ;                                                                                  // 3
                         "Sélectionner la date", ;                                                                                                   // 4
                         "Vérifier la valeur logique", ;                                                                                             // 5
                         "Entrer la valeur du champ", ;                                                                                              // 6
                         "Sélectionner un enregistrement et appuyer sur OK", ;                                                                       // 7
                         CRLF + "Vous voulez détruire l'enregistrement actif  " + CRLF + "Etes-vous sûre?   " + CRLF, ;                              // 8
                         CRLF + "Il n'y a pas d'ordre actif   " + CRLF + "Sélectionner en un   " + CRLF, ;                                           // 9
                         CRLF + "Ne peut faire de recherche sur champ memo ou logique   " + CRLF, ;                                                  // 10
                         CRLF + "Enregistrement non trouvé  " + CRLF, ;                                                                              // 11
                         "Sélectionner le champ à inclure à la liste", ;                                                                             // 12
                         "Sélectionner le champ à exclure de la liste", ;                                                                            // 13
                         "Sélectionner l'imprimante", ;                                                                                              // 14
                         "Appuyer sur le bouton pour inclure un champ", ;                                                                            // 15
                         "Appuyer sur le bouton pour exclure un champ", ;                                                                            // 16
                         "Appuyer sur le bouton pour sélectionner le premier enregistrement à imprimer", ;                                           // 17
                         "Appuyer sur le bouton pour sélectionner le dernier champ à imprimer", ;                                                    // 18
                         CRLF + "Plus de champs à inclure   " + CRLF, ;                                                                              // 19
                         CRLF + "Sélectionner d'abord les champs à inclure   " + CRLF, ;                                                             // 20
                         CRLF + "Plus de champs à exclure   " + CRLF, ;                                                                              // 21
                         CRLF + "Sélectionner d'abord les champs à exclure   " + CRLF, ;                                                             // 22
                         CRLF + "Vous n'avez sélectionné aucun champ   " + CRLF + "Sélectionner les champs à inclure dans l'impression   " + CRLF, ; // 23
                         CRLF + "Trop de champs   " + CRLF + "Réduiser le nombre de champs   " + CRLF, ;                                             // 24
                         CRLF + "Imprimante pas prête   " + CRLF, ;                                                                                  // 25
                         "Trié par", ;                                                                                                               // 26
                         "De l'enregistrement", ;                                                                                                    // 27
                         "A l'enregistrement", ;                                                                                                     // 28
                         "Oui", ;                                                                                                                    // 29
                         "Non", ;                                                                                                                    // 30
                         "Page:", ;                                                                                                                  // 31
                         CRLF + "Sélectionner une imprimante   " + CRLF, ;                                                                           // 32
                         "Filtré par", ;                                                                                                             // 33
                         CRLF + "Il y a un filtre actif    " + CRLF, ;                                                                               // 34
                         CRLF + "Filtre impossible sur champ memo    " + CRLF, ;                                                                     // 35
                         CRLF + "Sélectionner un champ de filtre    " + CRLF, ;                                                                      // 36
                         CRLF + "Sélectionner un opérateur de filtre   " + CRLF, ;                                                                   // 37
                         CRLF + "Entrer une valeur au filtre    " + CRLF, ;                                                                          // 38
                         CRLF + "Il n'y a aucun filtre actif    " + CRLF, ;                                                                          // 39
                         CRLF + "Désactiver le filtre?   " + CRLF, ;                                                                                 // 40
                         CRLF + "Enregistrement verrouillé par un autre utilisateur" + CRLF }                                                        // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_DE // German

   RETURN ooHG_Messages_DEWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_DEWIN // German

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Sind Sie sicher ?', ;
                         'Fenster schließen', ;
                         'Schließen nicht erlaubt', ;
                         'Programm läuft bereits', ;
                         'Bearbeiten', ;
                         'OK', ;
                         'Abbrechen', ;
                         'Seite', ;
                         'Fehler', ;
                         'Warnung', ;
                         'Bearbeiten Memo', ;
                         "Can't determine cell type for INPLACE edit.", ;
                         "Excel is not available.", ;
                         "OpenOffice is not available.", ;
                         "OpenOffice Desktop is not available.", ;
                         "OpenOffice Calc is not available.", ;
                         " successfully installed.", ;
                         " not installed.", ;
                         "Error creating TReg32 object ", ;
                         "This screen saver has no configurable options.", ;
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends !!!", ;                                                                      // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed !!!", ;                                                                   // 24
                         "File is already encrypted !!!", ;                                                                         // 25
                         "File is not encrypted !!!", ;                                                                             // 26
                         "Password is invalid !!!", ;                                                                               // 27
                         "The names of the new file and the old file must be different !!!", ;                                      // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := {}
   acBrowseError    := {}
   acBrowseMessages := { 'Sind Sie sicher ?', ;
                         'Datensatz Löschen', ;
                         'Element Löschen' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Datensatz loeschen" + CRLF + "Sind Sie sicher ?" + CRLF, ;
                         CRLF + " Falscher Indexdatensatz" + CRLF + "Suche unmoeglich" + CRLF, ;
                         CRLF + "Man kann nicht Indexdatenfeld finden" + CRLF + "Suche unmoeglich" + CRLF, ;
                         CRLF + "Suche unmoeglich nach" + CRLF + "Feld memo oder logisch" + CRLF, ;
                         CRLF + "Datensatz nicht gefunden" + CRLF, ;
                         CRLF + " zu viele Spalten" + CRLF + "Zu wenig Platz  fuer die Meldung auf dem Blatt" + CRLF, ;
                         CRLF + "Record is locked by another user" + CRLF + "Retry later" + CRLF }
   acABMLabel       := { "Datensatz", ;
                         "Menge der Dat.", ;
                         "       (Neu)", ;
                         " (Editieren)", ;
                         "Datensatznummer eintragen", ;
                         "Suche", ;
                         "Suche Text", ;
                         "Suche Datum", ;
                         "Suche Zahl", ;
                         "Definition der Meldung", ;
                         "Spalten der Meldung", ;
                         "Zugaengliche Spalten", ;
                         "Anfangsdatensatz", ;
                         "Endedatensatz", ;
                         "Datensatz vom ", ;
                         "Datum:", ;
                         "Anfangsdatensatz:", ;
                         "Endedatensatz:", ;
                         "Sortieren nach:", ;
                         "Ja", ;
                         "Nein", ;
                         "Seite ", ;
                         " von " }
   acABMButton      := { "Schliesse", ;
                         "Neu", ;
                         "Editiere", ;
                         "Loesche", ;
                         "Finde", ;
                         "Gehe zu", ;
                         "Meldung", ;
                         "Erster", ;
                         "Zurueck", ;
                         "Naechst", ;
                         "Letzter", ;
                         "Speichern", ;
                         "Aufheben", ;
                         "Hinzufuegen", ;
                         "Loeschen", ;
                         "Drucken", ;
                         "Schliessen" }
   acABMError       := { "EDIT, falscher Name von Datenbank", ;
                         "EDIT, Datenbank hat mehr als 16 Felder", ;
                         "EDIT, Auffrische-Modus ausser dem Bereich (siehe Fehlermeldungen)", ;
                         "EDIT, Menge der Basisereignisse ausser dem Bereich (siehe Fehlermeldungen)", ;
                         "EDIT, Liste der Ereignisse ausser dem Bereich (siehe Fehlermeldungen)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "S&chließen", ;                                        // 1
                         "&Neu", ;                                              // 2
                         "&Bearbeiten", ;                                       // 3
                         "&Löschen", ;                                          // 4
                         "&Suchen", ;                                           // 5
                         "&Drucken", ;                                          // 6
                         "&Abbruch", ;                                          // 7
                         "&Ok", ;                                               // 8
                         "&Kopieren", ;                                         // 9
                         "&Filter aktivieren", ;                                // 10
                         "&Filter deaktivieren" }                               // 11
   acLabel          := { "Keine", ;                                             // 1
                         "Datensatz", ;                                         // 2
                         "Gesamt", ;                                            // 3
                         "Aktive Sortierung", ;                                 // 4
                         "Einstellungen", ;                                     // 5
                         "Neuer Datensatz", ;                                   // 6
                         "Datensatz bearbeiten", ;                              // 7
                         "Datensatz auswählen", ;                               // 8
                         "Datensatz finden", ;                                  // 9
                         "Druckeinstellungen", ;                                // 10
                         "Verfügbare Felder", ;                                 // 11
                         "Zu druckende Felder", ;                               // 12
                         "Verfügbare Drucker", ;                                // 13
                         "Erster zu druckender Datensatz", ;                    // 14
                         "Letzter zu druckender Datensatz", ;                   // 15
                         "Datensatz löschen", ;                                 // 16
                         "Vorschau", ;                                          // 17
                         "Übersicht", ;                                         // 18
                         "Filterbedingung: ", ;                                 // 19
                         "Gefiltert: ", ;                                       // 20
                         "Filter-Einstellungen", ;                              // 21
                         "Datenbank-Felder", ;                                  // 22
                         "Vergleichs-Operator", ;                               // 23
                         "Filterwert", ;                                        // 24
                         "Zu filterndes Feld auswählen", ;                      // 25
                         "Vergleichs-Operator auswählen", ;                     // 26
                         "Gleich", ;                                            // 27
                         "Ungleich", ;                                          // 28
                         "Größer als", ;                                        // 29
                         "Kleiner als", ;                                       // 30
                         "Größer oder gleich als", ;                            // 31
                         "Kleiner oder gleich als" }                            // 32
   acUser           := { CRLF + "Kein aktiver Arbeitsbereich gefunden.   " + CRLF + "Bitte einen Arbeitsbereich auswählen vor dem Aufruf von EDIT   " + CRLF, ;  // 1
                         "Einen Text eingeben (alphanumerisch)", ;                                                                                               // 2
                         "Eine Zahl eingeben", ;                                                                                                                 // 3
                         "Datum auswählen", ;                                                                                                                    // 4
                         "Für positive Auswahl einen Haken setzen", ;                                                                                            // 5
                         "Einen Text eingeben (alphanumerisch)", ;                                                                                               // 6
                         "Einen Datensatz wählen und mit OK bestätigen", ;                                                                                       // 7
                         CRLF + "Sie sind im Begriff, den aktiven Datensatz zu löschen.   " + CRLF + "Sind Sie sicher?    " + CRLF, ;                            // 8
                         CRLF + "Es ist keine Sortierung aktiv.   " + CRLF + "Bitte wählen Sie eine Sortierung   " + CRLF, ;                                     // 9
                         CRLF + "Suche nach den Feldern memo oder logisch nicht möglich.   " + CRLF, ;                                                           // 10
                         CRLF + "Datensatz nicht gefunden   " + CRLF, ;                                                                                          // 11
                         "Bitte ein Feld zum Hinzufügen zur Liste wählen", ;                                                                                     // 12
                         "Bitte ein Feld zum Entfernen aus der Liste wählen ", ;                                                                                 // 13
                         "Drucker auswählen", ;                                                                                                                  // 14
                         "Schaltfläche  Feld hinzufügen", ;                                                                                                      // 15
                         "Schaltfläche  Feld Entfernen", ;                                                                                                       // 16
                         "Schaltfläche  Auswahl erster zu druckender Datensatz", ;                                                                               // 17
                         "Schaltfläche  Auswahl letzte zu druckender Datensatz", ;                                                                               // 18
                         CRLF + "Keine Felder zum Hinzufügen mehr vorhanden   " + CRLF, ;                                                                        // 19
                         CRLF + "Bitte erst ein Feld zum Hinzufügen wählen   " + CRLF, ;                                                                         // 20
                         CRLF + "Keine Felder zum Entfernen vorhanden   " + CRLF, ;                                                                              // 21
                         CRLF + "Bitte ein Feld zum Entfernen wählen   " + CRLF, ;                                                                               // 22
                         CRLF + "Kein Feld ausgewählt   " + CRLF + "Bitte die Felder für den Ausdruck auswählen   " + CRLF, ;                                    // 23
                         CRLF + "Zu viele Felder   " + CRLF + "Bitte Anzahl der Felder reduzieren   " + CRLF, ;                                                  // 24
                         CRLF + "Drucker nicht bereit   " + CRLF, ;                                                                                              // 25
                         "Sortiert nach", ;                                                                                                                      // 26
                         "Von Datensatz", ;                                                                                                                      // 27
                         "Bis Datensatz", ;                                                                                                                      // 28
                         "Ja", ;                                                                                                                                 // 29
                         "Nein", ;                                                                                                                               // 30
                         "Seite:", ;                                                                                                                             // 31
                         CRLF + "Bitte einen Drucker wählen   " + CRLF, ;                                                                                        // 32
                         "Filtered by", ;                                                                                                                        // 33
                         CRLF + "Es ist kein aktiver Filter vorhanden    " + CRLF, ;                                                                             // 34
                         CRLF + "Kann nicht nach Memo-Feldern filtern    " + CRLF, ;                                                                             // 35
                         CRLF + "Feld zum Filtern auswählen    " + CRLF, ;                                                                                       // 36
                         CRLF + "Einen Operator zum Filtern auswählen    " + CRLF, ;                                                                             // 37
                         CRLF + "Bitte einen Wert für den Filter angeben    " + CRLF, ;                                                                          // 38
                         CRLF + "Es ist kein aktiver Filter vorhanden    " + CRLF, ;                                                                             // 39
                         CRLF + "Filter deaktivieren?   " + CRLF, ;                                                                                              // 40
                         CRLF + "Record locked by another user" + CRLF }                                                                                         // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_IT // Italian

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Sei sicuro ?', ;
                         'Chiudi la finestra', ;
                         'Chiusura non consentita', ;
                         'Il programma è già in esecuzione', ;
                         'Edita', ;
                         'Conferma', ;
                         'Annulla', ;
                         'Pag.', ;
                         'Errore', ;
                         'Avvertimento', ;
                         'Edita Memo', ;
                         "Impossibile determinare il tipo di cella per la modifica INPLACE.", ;
                         "Excel non è disponibile.", ;
                         "OpenOffice non è disponibile.", ;
                         "OpenOffice Desktop non è disponibile.", ;
                         "OpenOffice Calc non è disponibile.", ;
                         " installato con successo.", ;
                         " non installato.", ;
                         "Errore durante la creazione dell'oggetto TReg32 ", ;
                         "Questo screen saver non ha opzioni configurabili.", ;
                         "Impossibile aprire il file INI.", ;
                         "Non c'è abbastanza spazio per le leggende !!!", ;                                                         // 22
                         { 'Il formato del rapporto non è valido: nessuna ' + DQM( "DO REPORT" ) + ' né ' + DQM( "DEFINE REPORT" ) + ' trovata.!', ;
                           'Il formato del rapporto non è valido: nessuna ' + DQM( "FIELDS" ) + ' trovata.!', ;
                           'Il formato del rapporto non è valido: nessuna ' + DQM( "FIELDS" ) + ' trovata.!', ;
                           'Il formato del rapporto non è valido: nessuna ' + DQM( "WIDTHS" ) + ' trovata.!', ;
                           'Il formato del rapporto non è valido: nessuna ' + DQM( "WIDTHS" ) + ' trovata.!' }, ;                   // 23
                         "Errore I / O file, impossibile procedere !!!", ;                                                          // 24
                         "Il file è già crittografato !!!", ;                                                                       // 25
                         "Il file non è crittografato !!!", ;                                                                       // 26
                         "La password non è valida !!!", ;                                                                          // 27
                         "I nomi del nuovo file e del vecchio file devono essere diversi !!!", ;                                    // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Aggiungere", ;
                         "Modificare", ;
                         "Cancellare", ;
                         "OK" }
   acBrowseError    := { "Window: ", ;
                         " non Š definita. Programma Terminato.", ;
                         "Errore", ;
                         "Controllo: ", ;
                         " Di ", ;
                         " Gi… definito. Programma Terminato.", ;
                         "Browse: Tipo non valido. Programma Terminato.", ;
                         "Browse: Modifica non possibile: il campo non Š pertinente l'area di lavoro.Programma Terminato.", ;
                         "Record gi… utilizzato da altro utente", ;
                         "Attenzione!", ;
                         "Dato non valido" }
   acBrowseMessages := { 'Sei sicuro ?', ;
                         'Cancella Record', ;
                         'Cancella Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Cancellare il record" + CRLF + "Sei sicuro ?" + CRLF, ;
                         CRLF + "File indice mancante" + CRLF + "Ricerca impossibile" + CRLF, ;
                         CRLF + "Campo indice mancante" + CRLF + "Ricerca impossibile" + CRLF, ;
                         CRLF + "Ricerca impossibile per" + CRLF + "campi memo o logici" + CRLF, ;
                         CRLF + "Record non trovato" + CRLF, ;
                         CRLF + "Troppe colonne" + CRLF + "Il report non può essere stampato" + CRLF, ;
                         CRLF + "Il record è bloccato da un altro utente" + CRLF + "Riprova più tardi" + CRLF }
   acABMLabel       := { "Record", ;
                         "Record totali", ;
                         "  (Aggiungi)", ;
                         "     (Nuovo)", ;
                         "Inserire il numero del record", ;
                         "Ricerca", ;
                         "Testo da cercare", ;
                         "Data da cercare", ;
                         "Numero da cercare", ;
                         "Definizione del report", ;
                         "Colonne del report", ;
                         "Colonne totali", ;
                         "Record Iniziale", ;
                         "Record Finale", ;
                         "Report di ", ;
                         "Data:", ;
                         "Primo Record:", ;
                         "Ultimo Record:", ;
                         "Ordinare per:", ;
                         "Sì", ;
                         "No", ;
                         "Pagina ", ;
                         " di " }
   acABMButton      := { "Chiudi", ;
                         "Nuovo", ;
                         "Modifica", ;
                         "Cancella", ;
                         "Ricerca", ;
                         "Vai a", ;
                         "Report", ;
                         "Primo", ;
                         "Precedente", ;
                         "Successivo", ;
                         "Ultimo", ;
                         "Salva", ;
                         "Annulla", ;
                         "Aggiungi", ;
                         "Rimuovi", ;
                         "Stampa", ;
                         "Chiudi" }
   acABMError       := { "EDIT, il nome dell'area è mancante", ;
                         "EDIT, quest'area contiene più di 16 campi", ;
                         "EDIT, modalità aggiornamento fuori dal limite (segnalare l'errore)", ;
                         "EDIT, evento pricipale fuori dal limite (segnalare l'errore)", ;
                         "EDIT, lista eventi fuori dal limite (segnalare l'errore)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Chiudi", ;                                           // 1
                         "&Nuovo", ;                                            // 2
                         "&Modifica", ;                                         // 3
                         "&Cancella", ;                                         // 4
                         "&Trova", ;                                            // 5
                         "&Stampa", ;                                           // 6
                         "&Annulla", ;                                          // 7
                         "&Ok", ;                                               // 8
                         "C&opia", ;                                            // 9
                         "A&ttiva Filtro", ;                                    // 10
                         "&Disattiva Filtro" }                                  // 11
   acLabel          := { "Nessuno", ;                                           // 1
                         "Record", ;                                            // 2
                         "Totale", ;                                            // 3
                         "Ordinamento attivo", ;                                // 4
                         "Opzioni", ;                                           // 5
                         "Nuovo record", ;                                      // 6
                         "Modifica record", ;                                   // 7
                         "Seleziona record", ;                                  // 8
                         "Trova record", ;                                      // 9
                         "Stampa opzioni", ;                                    // 10
                         "Campi disponibili", ;                                 // 11
                         "Campi da stampare", ;                                 // 12
                         "Stampanti disponibili", ;                             // 13
                         "Primo  record da stampare", ;                         // 14
                         "Ultimo record da stampare", ;                         // 15
                         "Cancella record", ;                                   // 16
                         "Anteprima", ;                                         // 17
                         "Visualizza pagina miniature", ;                       // 18
                         "Condizioni Filtro: ", ;                               // 19
                         "Filtrato: ", ;                                        // 20
                         "Opzioni Filtro", ;                                    // 21
                         "Campi del Database", ;                                // 22
                         "Operatori di comparazione", ;                         // 23
                         "Valore Filtro", ;                                     // 24
                         "Seleziona campo da filtrare", ;                       // 25
                         "Seleziona operatore comparazione", ;                  // 26
                         "Uguale", ;                                            // 27
                         "Non Uguale", ;                                        // 28
                         "Maggiore di", ;                                       // 29
                         "Minore di", ;                                         // 30
                         "Maggiore o uguale a", ;                               // 31
                         "Minore o uguale a" }                                  // 32
   acUser           := { CRLF + "Nessuna area attiva.   " + CRLF + "Selezionare un'area prima della chiamata a EDIT   " + CRLF, ;  // 1
                         "Digitare valore campo (testo)", ;                                                                        // 2
                         "Digitare valore campo (numerico)", ;                                                                     // 3
                         "Selezionare data", ;                                                                                     // 4
                         "Attivare per valore TRUE", ;                                                                             // 5
                         "Inserire valore campo", ;                                                                                // 6
                         "Seleziona un record and premi OK", ;                                                                     // 7
                         CRLF + "Cancellazione record attivo   " + CRLF + "Sei sicuro?      " + CRLF, ;                            // 8
                         CRLF + "Nessun ordinamento attivo     " + CRLF + "Selezionarne uno " + CRLF, ;                            // 9
                         CRLF + "Ricerca non possibile su campi MEMO o LOGICI   " + CRLF, ;                                        // 10
                         CRLF + "Record non trovato   " + CRLF, ;                                                                  // 11
                         "Seleziona campo da includere nel listato", ;                                                             // 12
                         "Seleziona campo da escludere dal listato", ;                                                             // 13
                         "Selezionare la stampante", ;                                                                             // 14
                         "Premi per includere il campo", ;                                                                         // 15
                         "Premi per escludere il campo", ;                                                                         // 16
                         "Premi per selezionare il primo record da stampare", ;                                                    // 17
                         "Premi per selezionare l'ultimo record da stampare", ;                                                    // 18
                         CRLF + "Nessun altro campo da inserire   " + CRLF, ;                                                      // 19
                         CRLF + "Prima seleziona il campo da includere " + CRLF, ;                                                 // 20
                         CRLF + "Nessun altro campo da escludere       " + CRLF, ;                                                 // 21
                         CRLF + "Prima seleziona il campo da escludere " + CRLF, ;                                                 // 22
                         CRLF + "Nessun campo selezionato     " + CRLF + "Selezionare campi da includere nel listato   " + CRLF, ; // 23
                         CRLF + "Troppi campi !   " + CRLF + "Redurre il numero di campi   " + CRLF, ;                             // 24
                         CRLF + "Stampante non pronta..!   " + CRLF, ;                                                             // 25
                         "Ordinato per", ;                                                                                         // 26
                         "Dal record", ;                                                                                           // 27
                         "Al  record", ;                                                                                           // 28
                         "Si", ;                                                                                                   // 29
                         "No", ;                                                                                                   // 30
                         "Pagina:", ;                                                                                              // 31
                         CRLF + "Selezionare una stampante   " + CRLF, ;                                                           // 32
                         "Filtrato per ", ;                                                                                        // 33
                         CRLF + "Esiste un filtro attivo     " + CRLF, ;                                                           // 34
                         CRLF + "Filtro non previsto per campi MEMO   " + CRLF, ;                                                  // 35
                         CRLF + "Selezionare campo da filtrare        " + CRLF, ;                                                  // 36
                         CRLF + "Selezionare un OPERATORE per filtro  " + CRLF, ;                                                  // 37
                         CRLF + "Digitare un valore per filtro        " + CRLF, ;                                                  // 38
                         CRLF + "Nessun filtro attivo    " + CRLF, ;                                                               // 39
                         CRLF + "Disattivare filtro ?   " + CRLF, ;                                                                // 40
                         CRLF + "Record bloccato da altro utente" + CRLF }                                                         // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_PL852 // Polish

   RETURN ooHG_Messages_PLWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_PLISO // Polish

   RETURN ooHG_Messages_PLWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_PLMAZ // Polish

   RETURN ooHG_Messages_PLWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_PLWIN // Polish

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Czy jesteœ pewny ?', ;
                         'Zamknij okno', ;
                         'Zamkniêcie niedozwolone', ;
                         'Program ju¿ uruchomiony', ;
                         'Edycja', ;
                         'Ok', ;
                         'Porzuæ', ;
                         'Pag.', ;
                         'B³¹d', ;
                         'Ostrze¿enie', ;
                         'Edycja Memo', ;
                         "Can't determine cell type for INPLACE edit.", ;
                         "Excel is not available.", ;
                         "OpenOffice is not available.", ;
                         "OpenOffice Desktop is not available.", ;
                         "OpenOffice Calc is not available.", ;
                         " successfully installed.", ;
                         " not installed.", ;
                         "Error creating TReg32 object ", ;
                         "This screen saver has no configurable options.", ;
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends !!!", ;                                                                      // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed !!!", ;                                                                   // 24
                         "File is already encrypted !!!", ;                                                                         // 25
                         "File is not encrypted !!!", ;                                                                             // 26
                         "Password is invalid !!!", ;                                                                               // 27
                         "The names of the new file and the old file must be different !!!", ;                                      // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Dodaj", ;
                         "Edycja", ;
                         "Porzuæ", ;
                         "OK" }
   acBrowseError    := { "Okno: ", ;
                         " nie zdefiniowane.Program zakoñczony", ;
                         "B³¹d", ;
                         "Kontrolka: ", ;
                         " z ", ;
                         " ju¿ zdefiniowana. Program zakoñczony", ;
                         "Browse: Niedozwolony typ danych. Program zakoñczony", ;
                         "Browse: Klauzula Append nie mo¿e byæ stosowana do pól nie nale¿¹cych do aktualnego obszaru roboczego. Program zakoñczony", ;
                         "Rekord edytowany przez innego u¿ytkownika", ;
                         "Ostrze¿enie", ;
                         "Nieprawid³owy wpis" }
   acBrowseMessages := { 'Czy jesteo pewny ?', ;
                         'Skasuj Rekord', ;
                         'Skasuj Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Usuni©cie rekordu" + CRLF + "Jeste˜ pewny ?" + CRLF, ;
                         CRLF + "Bˆ©dny zbi¢r Indeksowy" + CRLF + "Nie mo¾na szuka†" + CRLF, ;
                         CRLF + "Nie mo¾na znale˜† pola indeksu" + CRLF + "Nie mo¾na szuka†" + CRLF, ;
                         CRLF + "Nie mo¾na szukaæ wg" + CRLF + "pola memo lub logicznego" + CRLF, ;
                         CRLF + "Rekordu nie znaleziono" + CRLF, ;
                         CRLF + "Zbyt wiele kolumn" + CRLF + "Raport nie mo¾e zmie˜ci† si© na arkuszu" + CRLF, ;
                         CRLF + "Record is locked by another user" + CRLF + "Retry later" + CRLF }
   acABMLabel       := { "Rekord", ;
                         "Liczba rekord¢w", ;
                         "      (Nowy)", ;
                         "    (Edycja)", ;
                         "Wprowad« numer rekordu", ;
                         "Szukaj", ;
                         "Szukaj tekstu", ;
                         "Szukaj daty", ;
                         "Szukaj liczby", ;
                         "Definicja Raportu", ;
                         "Kolumny Raportu", ;
                         "Dost©pne kolumny", ;
                         "Pocz¥tkowy rekord", ;
                         "Koäcowy rekord", ;
                         "Raport z ", ;
                         "Data:", ;
                         "Pocz¥tkowy rekord:", ;
                         "Koäcowy rekord:", ;
                         "Sortowanie wg:", ;
                         "Tak", ;
                         "Nie", ;
                         "Strona ", ;
                         " z " }
   acABMButton      := { "Zamknij", ;
                         "Nowy", ;
                         "Edytuj", ;
                         "Usuä", ;
                         "Znajd«", ;
                         "IdŸ do", ;
                         "Raport", ;
                         "Pierwszy", ;
                         "Poprzedni", ;
                         "Nast©pny", ;
                         "Ostatni", ;
                         "Zapisz", ;
                         "Rezygnuj", ;
                         "Dodaj", ;
                         "Usuä", ;
                         "Drukuj", ;
                         "Zamknij" }
   acABMError       := { "EDIT, bˆ©dna nazwa bazy", ;
                         "EDIT, baza ma wi©cej ni¾ 16 p¢l", ;
                         "EDIT, tryb od˜wierzania poza zakresem (zobacz raport bˆ©d¢w)", ;
                         "EDIT, liczba zdarzä podstawowych poza zakresem (zobacz raport bˆ©d¢w)", ;
                         "EDIT, lista zdarzeä poza zakresem (zobacz raport bˆ©d¢w)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Zamknij", ;                                          // 1
                         "&Nowy", ;                                             // 2
                         "&Modyfikuj", ;                                        // 3
                         "&Kasuj", ;                                            // 4
                         "&ZnajdŸ", ;                                           // 5
                         "&Drukuj", ;                                           // 6
                         "&Porzuæ", ;                                           // 7
                         "&Ok", ;                                               // 8
                         "&Kopiuj", ;                                           // 9
                         "&Aktywuj Filtr", ;                                    // 10
                         "&Deaktywuj Filtr" }                                   // 11
   acLabel          := { "Brak", ;                                              // 1
                         "Rekord", ;                                            // 2
                         "Suma", ;                                              // 3
                         "Aktywny indeks", ;                                    // 4
                         "Opcje", ;                                             // 5
                         "Nowy rekord", ;                                       // 6
                         "Modyfikuj rekord", ;                                  // 7
                         "Wybierz rekord", ;                                    // 8
                         "ZnajdŸ rekord", ;                                     // 9
                         "Opcje druku", ;                                       // 10
                         "Dostêpne pola", ;                                     // 11
                         "Pola do druku", ;                                     // 12
                         "Dostêpne drukarki", ;                                 // 13
                         "Pierwszy rekord do druku", ;                          // 14
                         "Ostatni rekord do druku", ;                           // 15
                         "Skasuj rekord", ;                                     // 16
                         "Podgl¹d", ;                                           // 17
                         "Poka¿ miniatury", ;                                   // 18
                         "Stan filtru: ", ;                                     // 19
                         "Filtrowane: ", ;                                      // 20
                         "Opcje filtrowania", ;                                 // 21
                         "Pola bazy danych", ;                                  // 22
                         "Operator porównania", ;                               // 23
                         "Wartoœæ filtru", ;                                    // 24
                         "Wybierz pola do filtru", ;                            // 25
                         "Wybierz operator porównania", ;                       // 26
                         "Równa siê", ;                                         // 27
                         "Nie równa siê", ;                                     // 28
                         "Wiêkszy ", ;                                          // 29
                         "Mniejszy ", ;                                         // 30
                         "Wiêkszy lub równy ", ;                                // 31
                         "Mniejszy lub równy" }                                 // 32
   acUser           := { CRLF + "Aktywny obszar nie odnaleziony   " + CRLF + "Wybierz obszar przed wywo³aniem EDIT   " + CRLF, ;    // 1
                         "Poszukiwany ci¹g znaków (dowolny tekst)", ;                                                               // 2
                         "Poszukiwana wartoœæ (dowolna liczba)", ;                                                                  // 3
                         "Wybierz datê", ;                                                                                          // 4
                         "Check for true value", ;                                                                                  // 5
                         "Wprowaæ wartoœæ", ;                                                                                       // 6
                         "Wybierz dowolny rekord i naciœcij OK", ;                                                                  // 7
                         CRLF + "Wybra³eœ opcjê kasowania rekordu   " + CRLF + "Czy jesteœ pewien?    " + CRLF, ;                   // 8
                         CRLF + "Brak aktywnych indeksów   " + CRLF + "Wybierz    " + CRLF, ;                                       // 9
                         CRLF + "Nie mo¿na szukaæ w polach typu MEMO lub LOGIC   " + CRLF, ;                                        // 10
                         CRLF + "Rekord nie znaleziony   " + CRLF, ;                                                                // 11
                         "Wybierz rekord który nale¿y dodaæ do listy", ;                                                            // 12
                         "Wybierz rekord który nale¿y wy³¹czyæ z listy", ;                                                          // 13
                         "Wybierz drukarkê", ;                                                                                      // 14
                         "Kliknij na przycisk by dodaæ pole", ;                                                                     // 15
                         "Kliknij na przycisk by odj¹æ pole", ;                                                                     // 16
                         "Kliknij, aby wybraæ pierwszy rekord do druku", ;                                                          // 17
                         "Kliknij, aby wybraæ ostatni rekord do druku", ;                                                           // 18
                         CRLF + "Brak pól do w³¹czenia   " + CRLF, ;                                                                // 19
                         CRLF + "Najpierw wybierz pola do w³¹czenia   " + CRLF, ;                                                   // 20
                         CRLF + "Brak pól do wy³¹czenia   " + CRLF, ;                                                               // 21
                         CRLF + "Najpierw wybierz pola do wy³¹czenia   " + CRLF, ;                                                  // 22
                         CRLF + "Nie wybra³eœ ¿adnych pól   " + CRLF + "Najpierw wybierz pola do w³¹czenia do wydruku   " + CRLF, ; // 23
                         CRLF + "Za wiele pól   " + CRLF + "Zredukuj liczbê pól   " + CRLF, ;                                       // 24
                         CRLF + "Drukarka nie gotowa   " + CRLF, ;                                                                  // 25
                         "Porz¹dek wg", ;                                                                                           // 26
                         "Od rekordu", ;                                                                                            // 27
                         "Do rekordu", ;                                                                                            // 28
                         "Tak", ;                                                                                                   // 29
                         "Nie", ;                                                                                                   // 30
                         "Strona:", ;                                                                                               // 31
                         CRLF + "Wybierz drukarkê   " + CRLF, ;                                                                     // 32
                         "Filtrowanie wg", ;                                                                                        // 33
                         CRLF + "Brak aktywnego filtru    " + CRLF, ;                                                               // 34
                         CRLF + "Nie mo¿na filtrowaæ wg. pól typu MEMO    " + CRLF, ;                                               // 35
                         CRLF + "Wybierz pola dla filtru    " + CRLF, ;                                                             // 36
                         CRLF + "Wybierz operator porównania dla filtru    " + CRLF, ;                                              // 37
                         CRLF + "Wpisz dowoln¹ wartoœæ dla filtru    " + CRLF, ;                                                    // 38
                         CRLF + "Brak aktywnego filtru    " + CRLF, ;                                                               // 39
                         CRLF + "Deaktywowaæ filtr?   " + CRLF, ;                                                                   // 40
                         CRLF + "Record locked by another user" + CRLF }                                                            // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_PT // Portuguese

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Você tem Certeza ?', ;
                         'Fechar Janela', ;
                         'Fechamento não permitido', ;
                         'Programa já está em execução', ;
                         'Edita', ;
                         'Ok', ;
                         'Cancela', ;
                         'Pag.', ;
                         'Erro', ;
                         'Advertência', ;
                         'Edita Memo', ;
                         "Não é possível determinar o tipo de célula para a edição INPLACE.", ;
                         "Excel não está disponível.", ;
                         "OpenOffice não está disponível.", ;
                         "OpenOffice Desktop não está disponível.", ;
                         "OpenOffice Calc não está disponível.", ;
                         " instalado com sucesso.", ;
                         " não instalado.", ;
                         "Erro ao criar o objeto TReg32 ", ;
                         "Esta proteção de tela não possui opções configuráveis.", ;
                         "Não é possível abrir o arquivo ", ;
                         "Não há espaço suficiente para lendas !!!", ;                                                              // 22
                         { 'O formato do relatório não é válido: nenhum ' + DQM( "DO REPORT" ) + ' nem ' + DQM( "DEFINE REPORT" ) + ' encontrado.!', ;
                           'O formato do relatório não é válido: nenhum ' + DQM( "FIELDS" ) + ' encontrado.!', ;
                           'O formato do relatório não é válido: nenhum ' + DQM( "FIELDS" ) + ' encontrado.!', ;
                           'O formato do relatório não é válido: nenhum ' + DQM( "WIDTHS" ) + ' encontrado.!', ;
                           'O formato do relatório não é válido: nenhum ' + DQM( "WIDTHS" ) + ' encontrado.!' }, ;                  // 23
                         "Erro de E / S de arquivo, não pode continuar !!!", ;                                                      // 24
                         "O arquivo já está criptografado !!!", ;                                                                   // 25
                         "O arquivo não está criptografado !!!", ;                                                                  // 26
                         "Senha é inválida !!!", ;                                                                                  // 27
                         "Os nomes do novo arquivo e do arquivo antigo devem ser diferentes !!!", ;                                 // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Incluir", ;
                         "Alterar", ;
                         "Cancelar", ;
                         "OK" }
   acBrowseError    := { "Window: ", ;
                         " Erro não definido. Programa será fechado", ;
                         "Erro", ;
                         "Control: ", ;
                         " Of ", ;
                         " Não pronto. Programa será fechado", ;
                         "Browse: Tipo Invalido !!!. Programa será fechado", ;
                         "Browse: Edição não pode ser efetivada,campo não pertence a essa área. Programa será fechado", ;
                         "Arquivo em uso não pode ser editado !!!", ;
                         "Aguarde...", ;
                         "Dado Invalido" }
   acBrowseMessages := { 'Você tem Certeza ?', ;
                         'Apaga Registro', ;
                         'Apaga Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Ser  apagado o registro atual" + CRLF + "Tem certeza?" + CRLF, ;
                         CRLF + "NÆo existe um ¡ndice ativo" + CRLF + "NÆo ‚ poss¡vel realizar a busca" + CRLF, ;
                         CRLF + "NÆo encontrado o campo ¡ndice" + CRLF + "NÆo ‚ poss¡vel realizar a busca" + CRLF, ;
                         CRLF + "NÆo ‚ poss¡vel realizar busca" + CRLF + "por campos memo ou l¢gicos" + CRLF, ;
                         CRLF + "Registro nÆo encontrado" + CRLF, ;
                         CRLF + "Inclu¡das colunas em excesso" + CRLF + "A listagem completa nÆo caber  na tela" + CRLF, ;
                         CRLF + "Registro está bloqueado por outro usuário " + CRLF + "Tente novamente mais tarde" + CRLF }
   acABMLabel       := { "Registro Atual", ;
                         "Total Registros", ;
                         "      (Novo)", ;
                         "    (Editar)", ;
                         "Introduza o n£mero do registro", ;
                         "Buscar", ;
                         "Texto a buscar", ;
                         "Data a buscar", ;
                         "N£mero a buscar", ;
                         "DefinicÆo da lista", ;
                         "Colunas da lista", ;
                         "Colunas dispon¡veis", ;
                         "Registro inicial", ;
                         "Registro final", ;
                         "Lista de ", ;
                         "Data:", ;
                         "Primeiro registro:", ;
                         "éltimo registro:", ;
                         "Ordenado por:", ;
                         "Sim", ;
                         "NÆo", ;
                         "P gina ", ;
                         " de " }
   acABMButton      := { "Fechar", ;
                         "Novo", ;
                         "Modificar", ;
                         "Eliminar", ;
                         "Buscar", ;
                         "Ir ao registro", ;
                         "Listar", ;
                         "Primeiro", ;
                         "Anterior", ;
                         "Seguinte", ;
                         "éltimo", ;
                         "Guardar", ;
                         "Cancelar", ;
                         "Juntar", ;
                         "Sair", ;
                         "Imprimir", ;
                         "Fechar" }
   acABMError       := { "EDIT, NÆo foi especificada a  rea", ;
                         "EDIT, A  rea contem mais de 16 campos", ;
                         "EDIT, Atualiza‡Æo fora do limite (por favor comunique o erro)", ;
                         "EDIT, Evento principal fora do limite (por favor comunique o erro)", ;
                         "EDIT, Evento mostrado est fora do limite (por favor comunique o erro)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Sair", ;                                             // 1
                         "&Novo", ;                                             // 2
                         "&Alterar", ;                                          // 3
                         "&Eliminar", ;                                         // 4
                         "&Localizar", ;                                        // 5
                         "&Imprimir", ;                                         // 6
                         "&Cancelar", ;                                         // 7
                         "&Aceitar", ;                                          // 8
                         "&Copiar", ;                                           // 9
                         "&Ativar Filtro", ;                                    // 10
                         "&Desativar Filtro" }                                  // 11
   acLabel          := { "Nenhum", ;                                            // 1
                         "Registro", ;                                          // 2
                         "Total", ;                                             // 3
                         "Indice ativo", ;                                      // 4
                         "Opção", ;                                             // 5
                         "Novo registro", ;                                     // 6
                         "Modificar registro", ;                                // 7
                         "Selecionar registro", ;                               // 8
                         "Localizar registro", ;                                // 9
                         "Opção de impressão", ;                                // 10
                         "Campos disponíveis", ;                                // 11
                         "Campos selecionados", ;                               // 12
                         "Impressoras disponíveis", ;                           // 13
                         "Primeiro registro a imprimir", ;                      // 14
                         "Último registro a imprimir", ;                        // 15
                         "Apagar registro", ;                                   // 16
                         "Visualizar impressão", ;                              // 17
                         "Páginas em miniatura", ;                              // 18
                         "Condição do filtro: ", ;                              // 19
                         "Filtrado: ", ;                                        // 20
                         "Opções do filtro", ;                                  // 21
                         "Campos de la bdd", ;                                  // 22
                         "Operador de comparação", ;                            // 23
                         "Valor de comparação", ;                               // 24
                         "Selecione o campo a filtrar", ;                       // 25
                         "Selecione o operador de comparação", ;                // 26
                         "Igual", ;                                             // 27
                         "Diferente", ;                                         // 28
                         "Maior que", ;                                         // 29
                         "Menor que", ;                                         // 30
                         "Maior ou igual que", ;                                // 31
                         "Menor ou igual que" }                                 // 32
   acUser           := { CRLF + "Não ha uma area ativa   " + CRLF + "Por favor selecione uma area antes de chamar a EDIT EXTENDED   " + CRLF, ;  // 1
                         "Introduza o valor do campo (texto)", ;                                                                                 // 2
                         "Introduza o valor do campo (numérico)", ;                                                                              // 3
                         "Selecione a data", ;                                                                                                   // 4
                         "Ative o indicar para valor verdadero", ;                                                                               // 5
                         "Introduza o valor do campo", ;                                                                                         // 6
                         "Selecione um registro e tecle Ok", ;                                                                                   // 7
                         CRLF + "Confirma apagar o registro ativo   " + CRLF + "Tem certeza?    " + CRLF, ;                                      // 8
                         CRLF + "Não ha um índice seleccionado    " + CRLF + "Por favor selecione un   " + CRLF, ;                               // 9
                         CRLF + "Não se pode realizar busca por campos tipo memo ou lógico   " + CRLF, ;                                         // 10
                         CRLF + "Registro não encontrado   " + CRLF, ;                                                                           // 11
                         "Selecione o campo a incluir na lista", ;                                                                               // 12
                         "Selecione o campo a excluir da lista", ;                                                                               // 13
                         "Selecione a impressora", ;                                                                                             // 14
                         "Precione o botão para incluir o campo", ;                                                                              // 15
                         "Precione o botão para excluir o campo", ;                                                                              // 16
                         "Precione o botão para selecionar o primeiro registro a imprimir", ;                                                    // 17
                         "Precione o botão para selecionar o último registro a imprimir", ;                                                      // 18
                         CRLF + "Foram incluidos todos os campos   " + CRLF, ;                                                                   // 19
                         CRLF + "Primeiro seleccione o campo a incluir   " + CRLF, ;                                                             // 20
                         CRLF + "Não ha campos para excluir   " + CRLF, ;                                                                        // 21
                         CRLF + "Primeiro selecione o campo a excluir   " + CRLF, ;                                                              // 22
                         CRLF + "Não ha selecionado nenhum campo   " + CRLF, ;                                                                   // 23
                         CRLF + "A lista não cabe na página   " + CRLF + "Reduza o número de campos   " + CRLF, ;                                // 24
                         CRLF + "A impressora não está disponível   " + CRLF, ;                                                                  // 25
                         "Ordenado por", ;                                                                                                       // 26
                         "Do registro", ;                                                                                                        // 27
                         "Até registro", ;                                                                                                       // 28
                         "Sim", ;                                                                                                                // 29
                         "Não", ;                                                                                                                // 30
                         "Página:", ;                                                                                                            // 31
                         CRLF + "Por favor selecione uma impressora   " + CRLF, ;                                                                // 32
                         "Filtrado por", ;                                                                                                       // 33
                         CRLF + "Não ha um filtro ativo    " + CRLF, ;                                                                           // 34
                         CRLF + "Não se pode filtrar por campos memo    " + CRLF, ;                                                              // 35
                         CRLF + "Selecione o campo a filtrar    " + CRLF, ;                                                                      // 36
                         CRLF + "Selecione o operador de comparação    " + CRLF, ;                                                               // 37
                         CRLF + "Introduza o valor do filtro    " + CRLF, ;                                                                      // 38
                         CRLF + "Não ha nenhum filtro ativo    " + CRLF, ;                                                                       // 39
                         CRLF + "Eliminar o filtro ativo?   " + CRLF, ;                                                                          // 40
                         CRLF + "Registro bloqueado por outro usuário" + CRLF }                                                                  // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_RU866 // Russian

   RETURN ooHG_Messages_RUWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_RUKOI8 // Russian

   RETURN ooHG_Messages_RUWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_RUWIN // Russian

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Âû óâåðåíû ?', ;
                         'Çàêðûòü îêíî', ;
                         'Çàêðûòèå íå äîñòóïíî', ;
                         'Ïðîãðàììà óæå çàïóùåíà', ;
                         'Èçìåíèòü', ;
                         'Äà', ;
                         'Îòìåíà', ;
                         'Pag.', ;
                         'Îøèáêà', ;
                         'Ïðåäóïðåæäåíèå', ;
                         'Èçìåíèòü Memo', ;
                         "Can't determine cell type for INPLACE edit.", ;
                         "Excel is not available.", ;
                         "OpenOffice is not available.", ;
                         "OpenOffice Desktop is not available.", ;
                         "OpenOffice Calc is not available.", ;
                         " successfully installed.", ;
                         " not installed.", ;
                         "Error creating TReg32 object ", ;
                         "This screen saver has no configurable options.", ;
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends !!!", ;                                                                      // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed !!!", ;                                                                   // 24
                         "File is already encrypted !!!", ;                                                                         // 25
                         "File is not encrypted !!!", ;                                                                             // 26
                         "Password is invalid !!!", ;                                                                               // 27
                         "The names of the new file and the old file must be different !!!", ;                                      // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Äîáàâèòü", ;
                         "Èçìåíèòü", ;
                         "Îòìåíà", ;
                         "OK" }
   acBrowseError    := { "Îêíî: ", ;
                         " íå îïðåäåëåíî. Ïðîãðàììà ïðåðâàíà", ;
                         "Îøèáêà", ;
                         "Ýëåìåíò óïðàâëåíè: ", ;
                         " èç ", ;
                         " Óæå îïðåäåëåí. Ïðîãðàììà ïðåðâàíà", ;
                         "Browse: Òàêîé òèï íå ïîääåðæèâàåòñ. Ïðîãðàììà ïðåðâàíà", ;
                         "Browse: Append êëàññ íå ìîæåò áûòü èñïîëüçîâàí ñ ïîëìè èç äðóãîé ðàáî÷åé îáëàñòè. Ïðîãðàììà ïðåðâàíà", ;
                         "Çàïèñü ñåé÷àñ ðåäàêòèðóåòñ äðóãèì ïîëüçîâàòåëåì", ;
                         "Ïðåäóïðåæäåíèå", ;
                         "Ââåäåíû íåïðàâèëüíûå äàííûå" }
   acBrowseMessages := { 'Âû óâåðåíû ?', ;
                         'Óäàëèòü Çàïèñü', ;
                         'Delete Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Óäàëåíèå çàïèñè." + CRLF + "Âû óâåðåíû ?" + CRLF, ;
                         CRLF + "Îòñóòñòâóåò èíäåêñíûé ôàéë" + CRLF + "Ïîèñê íåâîçìîæåí" + CRLF, ;
                         CRLF + "Îòñóòñòâóåò èíäåêñíîå ïîëå" + CRLF + "Ïîèñê íåâîçìîæåí" + CRLF, ;
                         CRLF + "Ïîèñê íåâîçìîæåí ïî" + CRLF + "ìåìî èëè ëîãè÷åñêèì ïîëÿì" + CRLF, ;
                         CRLF + "Çàïèñü íå íàéäåíà" + CRLF, ;
                         CRLF + "Ñëèøêîì ìíîãî êîëîíîê" + CRLF + "Îò÷åò íå ïîìåñòèòñÿ íà ëèñòå" + CRLF, ;
                         CRLF + "Record is locked by another user" + CRLF + "Retry later" + CRLF }
   acABMLabel       := { "Çàïèñü", ;
                         "Âñåãî çàïèñåé", ;
                         "     (Íîâàÿ)", ;
                         "  (Èçìåíèòü)", ;
                         "Ââåäèòå íîìåð çàïèñè", ;
                         "Ïîèñê", ;
                         "Íàéòè òåêñò", ;
                         "Íàéòè äàòó", ;
                         "Íàéòè ÷èñëî", ;
                         "Íàñòðîéêà îò÷åòà", ;
                         "Êîëîíêè îò÷åòà", ;
                         "Äîñòóïíûå êîëîíêè", ;
                         "Íà÷àëüíàÿ çàïèñü", ;
                         "Êîíå÷íàÿ çàïèñü", ;
                         "Îò÷åò äëÿ ", ;
                         "Äàòà:", ;
                         "Ïåðâàÿ çàïèñü:", ;
                         "Êîíå÷íàÿ çàïèñü:", ;
                         "Ãðóïïèðîâêà ïî:", ;
                         "Äà", ;
                         "Íåò", ;
                         "Ñòðàíèöà ", ;
                         " èç " }
   acABMButton      := { "Çàêðûòü", ;
                         "Íîâàÿ", ;
                         "Èçìåíèòü", ;
                         "Óäàëèòü", ;
                         "Ïîèñê", ;
                         "Ïåðåéòè", ;
                         "Îò÷åò", ;
                         "Ïåðâàÿ", ;
                         "Íàçàä", ;
                         "Âïåðåä", ;
                         "Ïîñëåäíÿÿ", ;
                         "Ñîõðàíèòü", ;
                         "Îòìåíà", ;
                         "Äîáàâèòü", ;
                         "Óäàëèòü", ;
                         "Ïå÷àòü", ;
                         "Çàêðûòü" }
   acABMError       := { "EDIT, íå óêàçàíî èìÿ ðàáî÷åé îáëàñòè", ;
                         "EDIT, äîïóñêàåòñÿ òîëüêî äî 16 ïîëåé", ;
                         "EDIT, ðåæèì îáíîâëåíèÿ âíå äèàïàçîíà (ñîîáùèòå îá îøèáêå)", ;
                         "EDIT, íîìåð ñîáûòèÿ âíå äèàïàçîíà (ñîîáùèòå îá îøèáêå)", ;
                         "EDIT, íîìåð ñîáûòèÿ ëèñòèíãà âíå äèàïàçîíà (ñîîáùèòå îá îøèáêå)" }

   // EDIT EXTENDED MESSAGES
   acButton         := {}
   acLabel          := {}
   acUser           := {}

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_ES // Spanish

   RETURN ooHG_Messages_ESWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_ESWIN // Spanish

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { '¿Está seguro?', ;                                                                                         // 1
                         'La ventana está a punto de cerrarse...', ;                                                                // 2
                         '¡Operación no permitida!', ;                                                                              // 3
                         '¡El programa ya está ejecutándose!', ;                                                                    // 4
                         'Editar', ;                                                                                                // 5
                         'Aceptar', ;                                                                                               // 6
                         'Cancelar', ;                                                                                              // 7
                         'Pág.', ;                                                                                                  // 8
                         'Error', ;                                                                                                 // 9
                         'Advertencia', ;                                                                                           // 10
                         'Editar Memo', ;                                                                                           // 11
                         "No se pudo determinar el tipo de celda para la edición INPLACE.", ;                                       // 12
                         "¡Excel no está disponible!", ;                                                                            // 13
                         "¡OpenOffice no está disponible!", ;                                                                       // 14
                         "¡OpenOffice Desktop no está disponible!", ;                                                               // 15
                         "¡OpenOffice Calc no está disponible!", ;                                                                  // 16
                         " instalado exitosamente.", ;                                                                              // 17
                         " no instalado.", ;                                                                                        // 18
                         "Error creando el objecto TReg32 ", ;                                                                      // 19
                         "Este protector de pantalla no tiene opciones configurables.", ;                                           // 20
                         "No se pudo abrir el archivo ", ;                                                                          // 21
                         "¡Insuficiente espacio para las leyendas!", ;                                                              // 22
                         { 'El formato del reporte no es válido: falta ' + DQM( "DO REPORT" ) + ' o ' + DQM( "DEFINE REPORT" ) + ".", ;
                           'El formato del reporte no es válido: falta ' + DQM( "FIELDS" ) + ".", ;
                           'El formato del reporte no es válido: falta ' + DQM( "FIELDS" ) + ".", ;
                           'El formato del reporte no es válido: falta ' + DQM( "WIDTHS" ) + ".", ;
                           'El formato del reporte no es válido: falta ' + DQM( "WIDTHS" ) + "." }, ;                               // 23
                         "¡Error de E/S en el archivo, no se puede continuar!", ;                                                   // 24
                         "¡El archivo ya está encriptado!", ;                                                                       // 25
                         "¡El archivo no está encriptado!", ;                                                                       // 26
                         "¡La contraseña es inválida!", ;                                                                           // 27
                         "¡Los nombres del nuevo archivo y el antiguo deben ser diferentes!", ;                                     // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Agregar", ;
                         "Cancelar", ;
                         "Aceptar" }
   acBrowseError    := { "Window: ", ;
                         " no está definida. Programa Terminado.", ;
                         "Error", ;
                         "Control: ", ;
                         " De ", ;
                         " ya definido. Programa Terminado.", ;
                         "Browse: Tipo no permitido. Programa Terminado.", ;
                         "Browse: La cláusula APPEND no puede ser usada con campos no pertenecientes al area del BROWSE. Programa Terminado.", ;
                         "El registro está siendo editado por otro usuario.", ;
                         "Peligro", ;
                         "Entrada no válida." }
   acBrowseMessages := { '¿Está seguro?', ;
                         'Eliminar Registro', ;
                         'Eliminar Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Va a eliminar el registro actual." + CRLF + "¿Está seguro?" + CRLF, ;
                         CRLF + "No hay un índice activo." + CRLF + "No se puede realizar la búsqueda." + CRLF, ;
                         CRLF + "No se encuentra el campo índice." + CRLF + "No se puede realizar la búsqueda." + CRLF, ;
                         CRLF + "No se pueden realizar búsquedas." + CRLF + "por campos memo o lógico." + CRLF, ;
                         CRLF + "Registro no encontrado." + CRLF, ;
                         CRLF + "Ha incluido demasiadas columnas." + CRLF + "El listado no cabe en la hoja." + CRLF, ;
                         CRLF + "El registro está bloqueado por otro usuario." + CRLF + "Reintente más tarde." + CRLF }
   acABMLabel       := { "Registro Actual", ;
                         "Registros Totales", ;
                         "     (Nuevo)", ;
                         "    (Editar)", ;
                         "Introduzca el número de registro", ;
                         "Buscar", ;
                         "Texto a buscar", ;
                         "Fecha a buscar", ;
                         "Número a buscar", ;
                         "Definición del listado", ;
                         "Columnas del listado", ;
                         "Columnas disponibles", ;
                         "Registro inicial", ;
                         "Registro final", ;
                         "Listado de ", ;
                         "Fecha:", ;
                         "Primer registro:", ;
                         "Último registro:", ;
                         "Ordenado por:", ;
                         "Si", ;
                         "No", ;
                         "Página ", ;
                         " de " }
   acABMButton      := { "Cerrar", ;
                         "Nuevo", ;
                         "Modificar", ;
                         "Eliminar", ;
                         "Buscar", ;
                         "Ir al registro", ;
                         "Listado", ;
                         "Primero", ;
                         "Anterior", ;
                         "Siguiente", ;
                         "Último", ;
                         "Guardar", ;
                         "Cancelar", ;
                         "Añadir", ;
                         "Quitar", ;
                         "Imprimir", ;
                         "Cerrar" }
   acABMError       := { "EDIT, No se ha especificado el area", ;
                         "EDIT, El area contiene más de 16 campos", ;
                         "EDIT, Refesco fuera de rango (por favor comunique el error)", ;
                         "EDIT, Evento principal fuera de rango (por favor comunique el error)", ;
                         "EDIT, Evento listado fuera de rango (por favor comunique el error)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Cerrar", ;                                           // 1
                         "&Nuevo", ;                                            // 2
                         "&Modificar", ;                                        // 3
                         "&Eliminar", ;                                         // 4
                         "&Buscar", ;                                           // 5
                         "&Imprimir", ;                                         // 6
                         "&Cancelar", ;                                         // 7
                         "&Aceptar", ;                                          // 8
                         "&Copiar", ;                                           // 9
                         "&Activar Filtro", ;                                   // 10
                         "&Desactivar Filtro" }                                 // 11
   acLabel          := { "Ninguno", ;                                           // 1
                         "Registro", ;                                          // 2
                         "Total", ;                                             // 3
                         "Indice activo", ;                                     // 4
                         "Opciones", ;                                          // 5
                         "Nuevo registro", ;                                    // 6
                         "Modificar registro", ;                                // 7
                         "Seleccionar registro", ;                              // 8
                         "Buscar registro", ;                                   // 9
                         "Opciones de impresión", ;                             // 10
                         "Campos disponibles", ;                                // 11
                         "Campos del listado", ;                                // 12
                         "Impresoras disponibles", ;                            // 13
                         "Primer registro a imprimir", ;                        // 14
                         "Último registro a imprimir", ;                        // 15
                         "Borrar registro", ;                                   // 16
                         "Vista previa", ;                                      // 17
                         "Páginas en miniatura", ;                              // 18
                         "Condición del filtro: ", ;                            // 19
                         "Filtrado: ", ;                                        // 20
                         "Opciones de filtrado", ;                              // 21
                         "Campos de la bdd", ;                                  // 22
                         "Operador de comparación", ;                           // 23
                         "Valor de comparación", ;                              // 24
                         "Seleccione el campo a filtrar", ;                     // 25
                         "Seleccione el operador de comparación", ;             // 26
                         "Igual", ;                                             // 27
                         "Distinto", ;                                          // 28
                         "Mayor que", ;                                         // 29
                         "Menor que", ;                                         // 30
                         "Mayor o igual que", ;                                 // 31
                         "Menor o igual que" }                                  // 32
   acUser           := { CRLF + "No hay un área activa   " + CRLF + "Por favor seleccione un área antes de llamar a EDIT EXTENDED   " + CRLF, ;  // 1
                         "Introduzca el valor del campo (texto)", ;                                                                              // 2
                         "Introduzca el valor del campo (numérico)", ;                                                                           // 3
                         "Seleccione la fecha", ;                                                                                                // 4
                         "Active la casilla para indicar un valor verdadero", ;                                                                  // 5
                         "Introduzca el valor del campo", ;                                                                                      // 6
                         "Seleccione un registro y pulse aceptar", ;                                                                             // 7
                         CRLF + "Se dispone a borrar el registro activo   " + CRLF + "¿Está seguro?    " + CRLF, ;                               // 8
                         CRLF + "No se ha seleccionado un indice   " + CRLF + "Por favor seleccione uno   " + CRLF, ;                            // 9
                         CRLF + "No se pueden realizar búsquedas por campos tipo memo o lógico   " + CRLF, ;                                     // 10
                         CRLF + "Registro no encontrado   " + CRLF, ;                                                                            // 11
                         "Seleccione el campo a incluir en el listado", ;                                                                        // 12
                         "Seleccione el campo a excluir del listado", ;                                                                          // 13
                         "Seleccione la impresora", ;                                                                                            // 14
                         "Pulse el botón para incluir el campo", ;                                                                               // 15
                         "Pulse el botón para excluir el campo", ;                                                                               // 16
                         "Pulse el botón para seleccionar el primer registro a imprimir", ;                                                      // 17
                         "Pulse el botón para seleccionar el último registro a imprimir", ;                                                      // 18
                         CRLF + "Ha incluido todos los campos   " + CRLF, ;                                                                      // 19
                         CRLF + "Primero seleccione el campo a incluir   " + CRLF, ;                                                             // 20
                         CRLF + "No hay campos para excluir   " + CRLF, ;                                                                        // 21
                         CRLF + "Primero seleccione el campo a excluir   " + CRLF, ;                                                             // 22
                         CRLF + "No ha seleccionado campo alguno   " + CRLF, ;                                                                   // 23
                         CRLF + "El listado no cabe en la página   " + CRLF + "Reduzca el número de campos   " + CRLF, ;                         // 24
                         CRLF + "La impresora no está disponible   " + CRLF, ;                                                                   // 25
                         "Ordenado por", ;                                                                                                       // 26
                         "Del registro", ;                                                                                                       // 27
                         "Al registro", ;                                                                                                        // 28
                         "Sí", ;                                                                                                                 // 29
                         "No", ;                                                                                                                 // 30
                         "Página:", ;                                                                                                            // 31
                         CRLF + "Por favor seleccione una impresora   " + CRLF, ;                                                                // 32
                         "Filtrado por", ;                                                                                                       // 33
                         CRLF + "No hay un filtro activo    " + CRLF, ;                                                                          // 34
                         CRLF + "No se puede filtrar por campos memo    " + CRLF, ;                                                              // 35
                         CRLF + "Seleccione el campo a filtrar    " + CRLF, ;                                                                    // 36
                         CRLF + "Seleccione el operador de comparación    " + CRLF, ;                                                            // 37
                         CRLF + "Introduzca el valor del filtro    " + CRLF, ;                                                                   // 38
                         CRLF + "No hay ningún filtro activo    " + CRLF, ;                                                                      // 39
                         CRLF + "¿Eliminar el filtro activo?   " + CRLF, ;                                                                       // 40
                         CRLF + "Registro bloqueado por otro usuario    " + CRLF }                                                               // 41

   // PRINT MESSAGES
   acPrint          := { "¡El objecto TPrint ya está inicializado!", ;
                         "Imprimiendo...", ;
                         "Comando auxiliar de impresión", ;
                         " IMPRESO OK !!!", ;
                         "Los parámetros pasados a la función no son válidos!", ;
                         "¡Fracasó la llamada a WinAPI OpenPrinter!", ;
                         "¡Fracasó la llamada a WinAPI StartDocPrinter!", ;
                         "¡Fracasó la llamada a WinAPI StartPagePrinter!", ;
                         "¡Fracasó la llamada a WinAPI malloc!", ;
                         " NO ENCONTRADO !!!", ;
                         "¡No se detectó impresora!", ;
                         "Error", ;
                         "¡El puerto no es válido!", ;
                         "Seleccione la impresora", ;
                         "OK", ;
                         "Cancelar", ;
                         'Vista previa -----> ', ;
                         "Cerrar", ;
                         "Cerrar", ;
                         "Zoom + ", ;
                         "Zoom + ", ;
                         "Zoom -", ;
                         "Zoom -", ;
                         "Imprimir", ;
                         "Modo de impresión: ", ;
                         "Buscar", ;
                         "Buscar", ;
                         "Sig. búsqueda", ;
                         "Sig. búsqueda", ;
                         'Texto: ', ;
                         'Cadena a buscar', ;
                         "Búsqueda finalizada.", ;
                         "Información", ;
                         '¡No se detectó Excel!', ;
                         "¡La extensión XLS no está asociada!", ;
                         "Archivo guardado en: ", ;
                         "¡La extensión HTML no está asociada!", ;
                         "¡La extensión RTF no está asociada!", ;
                         "¡La extensión CSV no está asociada!", ;
                         "¡La extensión PDF no está asociada!", ;
                         "¡La extensión ODT no está asociada!", ;
                         '¡Los códigos de barra requieren una cadena!', ;
                         '¡Los modos válidos de códigos de barra c128 son A, B or C!', ;
                         "¡No se detectó OpenCalc!", ;
                         "No se pudo guardar el archivo: ", ;
                         "¡La vista previa TPrint está activa!", ;
                         "¡El documento TPrint está abierto!", ;
                         "¡El objeto TPrint no está inicializado!", ;
                         "¡El objeto TPrint está en estado de error!", ;
                         "¡El documento TPrint no está abierto!" }

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_FI // Finnish

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Oletko varma ?', ;
                         'Sulje ikkuna', ;
                         'Sulkeminen ei sallittu', ;
                         'Ohjelma on jo käynnissä', ;
                         'Korjaa', ;
                         'Ok', ;
                         'Keskeytä', ;
                         'Sivu.', ;
                         'Virhe', ;
                         'Varoitus', ;
                         'Korjaa Memo', ;
                         "Can't determine cell type for INPLACE edit.", ;
                         "Excel is not available.", ;
                         "OpenOffice is not available.", ;
                         "OpenOffice Desktop is not available.", ;
                         "OpenOffice Calc is not available.", ;
                         " successfully installed.", ;
                         " not installed.", ;
                         "Error creating TReg32 object ", ;
                         "This screen saver has no configurable options.", ;
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends !!!", ;                                                                      // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed !!!", ;                                                                   // 24
                         "File is already encrypted !!!", ;                                                                         // 25
                         "File is not encrypted !!!", ;                                                                             // 26
                         "Password is invalid !!!", ;                                                                               // 27
                         "The names of the new file and the old file must be different !!!", ;                                      // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Lisää", ;
                         "Korjaa", ;
                         " Keskeytä", ;
                         " OK" }
   acBrowseError    := { "Ikkuna: ", ;
                         " määrittelemätön. Ohjelma lopetettu", ;
                         "Virhe", ;
                         "Kontrolli: ", ;
                         " / ", ;
                         " On jo määritelty. Ohjelma lopetettu", ;
                         "Browse: Virheellinen tyyppi. Ohjelma lopetettu", ;
                         "Browse: Et voi lisätä kenttiä jotka eivät ole BROWSEN määrityksessä. Ohjelma lopetettu", ;
                         "Toinen käyttäjä korjaa juuri tietuetta", ;
                         "Varoitus", ;
                         "Virheellinen arvo" }
   acBrowseMessages := { 'Oletko varma ?', ;
                         'Poista Tietue', ;
                         'Poista Rivi' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Poista tietue" + CRLF + "Oletko varma?" + CRLF, ;
                         CRLF + "Indeksi tiedosto puuttuu" + CRLF + "En voihakea" + CRLF, ;
                         CRLF + "Indeksikenttä ei löydy" + CRLF + "En voihakea" + CRLF, ;
                         CRLF + "En voi hakea memo" + CRLF + "tai loogisen kentän mukaan" + CRLF, ;
                         CRLF + "Tietue ei löydy" + CRLF, ;
                         CRLF + "Liian monta saraketta" + CRLF + "raportti ei mahdu sivulle" + CRLF, ;
                         CRLF + "Record is locked by another user" + CRLF + "Retry later" + CRLF }
   acABMLabel       := { "Tietue", ;
                         "Tietue lukumäärä", ;
                         "       (Uusi)", ;
                         "      (Korjaa)", ;
                         "Anna tietue numero", ;
                         "Hae", ;
                         "Hae teksti", ;
                         "Hae päiväys", ;
                         "Hae numero", ;
                         "Raportti määritys", ;
                         "Raportti sarake", ;
                         "Sallitut sarakkeet", ;
                         "Alku tietue", ;
                         "Loppu tietue", ;
                         "Raportti ", ;
                         "Pvm:", ;
                         "Alku tietue:", ;
                         "Loppu tietue:", ;
                         "Lajittelu:", ;
                         "Kyllä", ;
                         "Ei", ;
                         "Sivu ", ;
                         " / " }
   acABMButton      := { "Sulje", ;
                         "Uusi", ;
                         "Korjaa", ;
                         "Poista", ;
                         "Hae", ;
                         "Mene", ;
                         "Raportti", ;
                         "Ensimmäinen", ;
                         "Edellinen", ;
                         "Seuraava", ;
                         "Viimeinen", ;
                         "Tallenna", ;
                         "Keskeytä", ;
                         "Lisää", ;
                         "Poista", ;
                         "Tulosta", ;
                         "Sulje" }
   acABMError       := { "EDIT, työalue puuttuu", ;
                         "EDIT, työalueella yli 16 kenttää", ;
                         "EDIT, päivitysalue ylitys (raportoi virhe)", ;
                         "EDIT, tapahtuma numero ylitys (raportoi virhe)", ;
                         "EDIT, lista tapahtuma numero ylitys (raportoi virhe)"}

   // EDIT EXTENDED MESSAGES
   acButton         := { " Sulje", ;                                            // 1
                         " Uusi", ;                                             // 2
                         " Muuta", ;                                            // 3
                         " Poista", ;                                           // 4
                         " Hae", ;                                              // 5
                         " Tulosta", ;                                          // 6
                         " Keskeytä", ;                                         // 7
                         " Ok", ;                                               // 8
                         " Kopioi", ;                                           // 9
                         " Aktivoi Filtteri", ;                                 // 10
                         " Deaktivoi Filtteri" }                                // 11
   acLabel          := { "Ei mitään", ;                                         // 1
                         "Tietue", ;                                            // 2
                         "Yhteensä", ;                                          // 3
                         "Aktiivinen lajittelu", ;                              // 4
                         "Optiot", ;                                            // 5
                         "Uusi tietue", ;                                       // 6
                         "Muuta tietue", ;                                      // 7
                         "Valitse tietue", ;                                    // 8
                         "Hae tietue", ;                                        // 9
                         "Tulostus optiot", ;                                   // 10
                         "Valittavat kentät", ;                                 // 11
                         "Tulostettavat kentät", ;                              // 12
                         "Valittavat tulostimet", ;                             // 13
                         "Ensim. tulostuttava tietue", ;                        // 14
                         "Viim. tulostettava tietue", ;                         // 15
                         "Poista tietue", ;                                     // 16
                         "Esikatselu", ;                                        // 17
                         "Näytä sivujen miniatyyrit", ;                         // 18
                         "Suodin ehto: ", ;                                     // 19
                         "Suodatettu: ", ;                                      // 20
                         "Suodatus Optiot", ;                                   // 21
                         "Tietokanta kentät", ;                                 // 22
                         "Vertailu operaattori", ;                              // 23
                         "Suodatus arvo", ;                                     // 24
                         "Valitse suodatus kenttä", ;                           // 25
                         "Valitse vertailu operaattori", ;                      // 26
                         "Yhtä kuin", ;                                         // 27
                         "Erisuuri kuin", ;                                     // 28
                         "Isompi kuin", ;                                       // 29
                         "Pienempi kuin", ;                                     // 30
                         "Isompi tai sama kuin", ;                              // 31
                         "Pienempi tai sama kuin" }                             // 32
   acUser           := { CRLF + "Työalue ei löydy.   " + CRLF + "Valitse työaluetta ennenkun kutsut Edit  " + CRLF, ;  // 1
                         "Anna kenttä arvo (tekstiä)", ;                                                               // 2
                         "Anna kenttä arvo (numeerinen)", ;                                                            // 3
                         "Valitse päiväys", ;                                                                          // 4
                         "Tarkista tosi arvo", ;                                                                       // 5
                         "Anna kenttä arvo", ;                                                                         // 6
                         "Valitse joku tietue ja paina OK", ;                                                          // 7
                         CRLF + "Olet poistamassa aktiivinen tietue   " + CRLF + "Oletko varma?    " + CRLF, ;         // 8
                         CRLF + "Ei aktiivista lajittelua   " + CRLF + "Valitse lajittelu   " + CRLF, ;                // 9
                         CRLF + "En voi hakea memo tai loogiseten kenttien perusteella  " + CRLF, ;                    // 10
                         CRLF + "Tietue ei löydy   " + CRLF, ;                                                         // 11
                         "Valitse listaan lisättävät kentät", ;                                                        // 12
                         "Valitse EI lisättävät kentät", ;                                                             // 13
                         "Valitse tulostin", ;                                                                         // 14
                         "Paina näppäin lisäätäksesi kenttä", ;                                                        // 15
                         "Paina näppäin poistaaksesi kenttä", ;                                                        // 16
                         "Paina näppäin valittaaksesi ensimmäinen tulostettava tietue", ;                              // 17
                         "Paina näppäin valittaaksesi viimeinen tulostettava tietue", ;                                // 18
                         CRLF + "Ei lisää kenttiä   " + CRLF, ;                                                        // 19
                         CRLF + "Valitse ensin lisättävä kenttä   " + CRLF, ;                                          // 20
                         CRLF + "EI Lisää ohitettavia kenttiä   " + CRLF, ;                                            // 21
                         CRLF + "Valitse ensin ohitettava kenttä   " + CRLF, ;                                         // 22
                         CRLF + "Et valinnut kenttiä   " + CRLF + "Valitse tulosteen kentät   " + CRLF, ;              // 23
                         CRLF + "Liikaa kenttiä   " + CRLF + "Vähennä kenttä lukumäärä   " + CRLF, ;                   // 24
                         CRLF + "Tulostin ei valmiina   " + CRLF, ;                                                    // 25
                         "Lajittelu", ;                                                                                // 26
                         "Tietueesta", ;                                                                               // 27
                         "Tietueeseen", ;                                                                              // 28
                         "Kyllä", ;                                                                                    // 29
                         "EI", ;                                                                                       // 30
                         "Sivu:", ;                                                                                    // 31
                         CRLF + "Valitse tulostin   " + CRLF, ;                                                        // 32
                         "Lajittelu", ;                                                                                // 33
                         CRLF + "Aktiivinen suodin olemassa    " + CRLF, ;                                             // 34
                         CRLF + "En voi suodattaa memo kenttiä    " + CRLF, ;                                          // 35
                         CRLF + "Valitse suodattava kenttä    " + CRLF, ;                                              // 36
                         CRLF + "Valitse suodattava operaattori    " + CRLF, ;                                         // 37
                         CRLF + "Anna suodatusarvo    " + CRLF, ;                                                      // 38
                         CRLF + "Ei aktiivisia suotimia    " + CRLF, ;                                                 // 39
                         CRLF + "Poista suodin?   " + CRLF, ;                                                          // 40
                         CRLF + "Tietue lukittu    " + CRLF }                                                          // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_NL // Dutch

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Weet u het zeker?', ;
                         'Sluit venster', ;
                         'Sluiten niet toegestaan', ;
                         'Programma is al actief', ;
                         'Bewerken', ;
                         'Ok', ;
                         'Annuleren', ;
                         'Pag.', ;
                         'Fout', ;
                         'Waarschuwing', ;
                         'Bewerken Memo', ;
                         "Can't determine cell type for INPLACE edit.", ;
                         "Excel is not available.", ;
                         "OpenOffice is not available.", ;
                         "OpenOffice Desktop is not available.", ;
                         "OpenOffice Calc is not available.", ;
                         " successfully installed.", ;
                         " not installed.", ;
                         "Error creating TReg32 object ", ;
                         "This screen saver has no configurable options.", ;
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends !!!", ;                                                                      // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed !!!", ;                                                                   // 24
                         "File is already encrypted !!!", ;                                                                         // 25
                         "File is not encrypted !!!", ;                                                                             // 26
                         "Password is invalid !!!", ;                                                                               // 27
                         "The names of the new file and the old file must be different !!!", ;                                      // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Toevoegen", ;
                         "Bewerken", ;
                         "&Annuleer", ;
                         "&OK" }
   acBrowseError    := { "Scherm: ", ;
                         " is niet gedefinieerd. Programma beëindigd", ;
                         "Fout", ;
                         "Control: ", ;
                         " Van ", ;
                         " Is al gedefinieerd. Programma beëindigd", ;
                         "Browse: Type niet toegestaan. Programma beëindigd", ;
                         "Browse: Toevoegen-methode kan niet worden gebruikt voor velden die niet bij het Browse werkgebied behoren. Programma beëindigd", ;
                         "Regel word al veranderd door een andere gebruiker", ;
                         "Waarschuwing", ;
                         "Onjuiste invoer" }
   acBrowseMessages := { 'Weet u het zeker?', ;
                         'Verwijder Record', ;
                         'Verwijder Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Verwijder regel" + CRLF + "Weet u het zeker ?" + CRLF, ;
                         CRLF + "Index bestand is er niet" + CRLF + "Kan niet zoeken" + CRLF, ;
                         CRLF + "Kan index veld niet vinden" + CRLF + "Kan niet zoeken" + CRLF, ;
                         CRLF + "Kan niet zoeken op" + CRLF + "Memo of logische velden" + CRLF, ;
                         CRLF + "Regel niet gevonden" + CRLF, ;
                         CRLF + "Te veel rijen" + CRLF + "Het rapport past niet op het papier" + CRLF, ;
                         CRLF + "Record is locked by another user" + CRLF + "Retry later" + CRLF }
   acABMLabel       := { "Regel", ;
                         "Regel aantal", ;
                         "       (Nieuw)", ;
                         "      (Bewerken)", ;
                         "Geef regel nummer", ;
                         "Vind", ;
                         "Zoek tekst", ;
                         "Zoek datum", ;
                         "Zoek nummer", ;
                         "Rapport definitie", ;
                         "Rapport rijen", ;
                         "Beschikbare rijen", ;
                         "Eerste regel", ;
                         "Laatste regel", ;
                         "Rapport van ", ;
                         "Datum:", ;
                         "Eerste regel:", ;
                         "Laatste tegel:", ;
                         "Gesorteerd op:", ;
                         "Ja", ;
                         "Nee", ;
                         "Pagina ", ;
                         " van " }
   acABMButton      := { "Sluiten", ;
                         "Nieuw", ;
                         "Bewerken", ;
                         "Verwijderen", ;
                         "Vind", ;
                         "Ga naar", ;
                         "Rapport", ;
                         "Eerste", ;
                         "Vorige", ;
                         "Volgende", ;
                         "Laatste", ;
                         "Bewaar", ;
                         "Annuleren", ;
                         "Voeg toe", ;
                         "Verwijder", ;
                         "Print", ;
                         "Sluiten" }
   acABMError       := { "BEWERKEN, werkgebied naam bestaat niet", ;
                         "BEWERKEN, dit werkgebied heeft meer dan 16 velden", ;
                         "BEWERKEN, ververs manier buiten bereik (a.u.b. fout melden)", ;
                         "BEWERKEN, hoofd gebeurtenis nummer buiten bereik (a.u.b. fout melden)", ;
                         "BEWERKEN, list gebeurtenis nummer buiten bereik (a.u.b. fout melden)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Sluiten", ;                                          // 1
                         "&Nieuw", ;                                            // 2
                         "&Aanpassen", ;                                        // 3
                         "&Verwijderen", ;                                      // 4
                         "&Vind", ;                                             // 5
                         "&Print", ;                                            // 6
                         "&Annuleren", ;                                        // 7
                         "&Ok", ;                                               // 8
                         "&Kopieer", ;                                          // 9
                         "&Activeer filter", ;                                  // 10
                         "&Deactiveer filter" }                                 // 11
   acLabel          := { "Geen", ;                                              // 1
                         "Regel", ;                                             // 2
                         "Totaal", ;                                            // 3
                         "Actieve volgorde", ;                                  // 4
                         "Opties", ;                                            // 5
                         "Nieuw regel", ;                                       // 6
                         "Aanpassen regel", ;                                   // 7
                         "Selecteer regel", ;                                   // 8
                         "Vind regel", ;                                        // 9
                         "Print opties", ;                                      // 10
                         "Beschikbare velden", ;                                // 11
                         "Velden te printen", ;                                 // 12
                         "Beschikbare printers", ;                              // 13
                         "Eerste regel te printen", ;                           // 14
                         "Laatste regel te printen", ;                          // 15
                         "Verwijder regel", ;                                   // 16
                         "Voorbeeld", ;                                         // 17
                         "Laat pagina klein zien", ;                            // 18
                         "Filter condities: ", ;                                // 19
                         "Gefilterd: ", ;                                       // 20
                         "Filter opties", ;                                     // 21
                         "Database velden", ;                                   // 22
                         "Vergelijkings operator", ;                            // 23
                         "Filter waarde", ;                                     // 24
                         "Selecteer velden om te filteren", ;                   // 25
                         "Selecteer vergelijkings operator", ;                  // 26
                         "Gelijk", ;                                            // 27
                         "Niet gelijk", ;                                       // 28
                         "Groter dan", ;                                        // 29
                         "Kleiner dan", ;                                       // 30
                         "Groter dan of gelijk aan", ;                          // 31
                         "Kleiner dan of gelijk aan" }                          // 32
   acUser           := { CRLF + "Kan geen actief werkgebied vinden   " + CRLF + "Selecteer A.U.B. een actief werkgebied voor BEWERKEN aan te roepen   " + CRLF, ;  // 1
                         "Geef de veld waarde (een tekst)", ;                                                                                                      // 2
                         "Geef de veld waarde (een nummer)", ;                                                                                                     // 3
                         "Selecteer de datum", ;                                                                                                                   // 4
                         "Controleer voor geldige waarde", ;                                                                                                       // 5
                         "Geef de veld waarde", ;                                                                                                                  // 6
                         "Selecteer een regel en druk op OK", ;                                                                                                    // 7
                         CRLF + "Je gaat het actieve regel verwijderen  " + CRLF + "Zeker weten?    " + CRLF, ;                                                    // 8
                         CRLF + "Er is geen actieve volgorde " + CRLF + "Selecteer er A.U.B. een   " + CRLF, ;                                                     // 9
                         CRLF + "Kan niet zoeken in memo of logische velden   " + CRLF, ;                                                                          // 10
                         CRLF + "Regel niet gevonden   " + CRLF, ;                                                                                                 // 11
                         "Selecteer het veld om in de lijst in te sluiten", ;                                                                                      // 12
                         "Selecteer het veld om uit de lijst te halen", ;                                                                                          // 13
                         "Selecteer de printer", ;                                                                                                                 // 14
                         "Druk op de knop om het veld in te sluiten", ;                                                                                            // 15
                         "Druk op de knop om het veld uit te sluiten", ;                                                                                           // 16
                         "Druk op de knop om het eerste veld te selecteren om te printen", ;                                                                       // 17
                         "Druk op de knop om het laatste veld te selecteren om te printen", ;                                                                      // 18
                         CRLF + "Geen velden meer om in te sluiten   " + CRLF, ;                                                                                   // 19
                         CRLF + "Selecteer eerst het veld om in te sluiten   " + CRLF, ;                                                                           // 20
                         CRLF + "Geen velden meer om uit te sluiten   " + CRLF, ;                                                                                  // 21
                         CRLF + "Selecteer eerst het veld om uit te sluiten   " + CRLF, ;                                                                          // 22
                         CRLF + "Je hebt geen velden geselecteerd   " + CRLF + "Selecteer A.U.B. de velden om in te sluiten om te printen   " + CRLF, ;            // 23
                         CRLF + "Teveel velden   " + CRLF + "Selecteer minder velden   " + CRLF, ;                                                                 // 24
                         CRLF + "Printer niet klaar   " + CRLF, ;                                                                                                  // 25
                         "Volgorde op", ;                                                                                                                          // 26
                         "Van regel", ;                                                                                                                            // 27
                         "Tot regel", ;                                                                                                                            // 28
                         "Ja", ;                                                                                                                                   // 29
                         "Nee", ;                                                                                                                                  // 30
                         "Pagina:", ;                                                                                                                              // 31
                         CRLF + "Selecteer A.U.B. een printer " + CRLF, ;                                                                                          // 32
                         "Gefilterd op", ;                                                                                                                         // 33
                         CRLF + "Er is een actief filter    " + CRLF, ;                                                                                            // 34
                         CRLF + "Kan niet filteren op memo velden    " + CRLF, ;                                                                                   // 35
                         CRLF + "Selecteer het veld om op te filteren    " + CRLF, ;                                                                               // 36
                         CRLF + "Selecteer een operator om te filteren    " + CRLF, ;                                                                              // 37
                         CRLF + "Type een waarde om te filteren " + CRLF, ;                                                                                        // 38
                         CRLF + "Er is geen actief filter    " + CRLF, ;                                                                                           // 39
                         CRLF + "Deactiveer filter?   " + CRLF, ;                                                                                                  // 40
                         CRLF + "Regel geblokkeerd door een andere gebuiker" + CRLF }                                                                              // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_SLISO // Slovenian

   RETURN ooHG_Messages_SLWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_SL852 // Slovenian

   RETURN ooHG_Messages_SLWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_SL437 // Slovenian

   RETURN ooHG_Messages_SLWIN()

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_SLWIN // Slovenian

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Ste preprièani ?', ;
                         'Zapri okno', ;
                         'Zapiranje ni dovoljeno', ;
                         'Program je že zagnan', ;
                         'Popravi', ;
                         'V redu', ;
                         'Prekini', ;
                         'Pag.', ;
                         'Napaka', ;
                         'Opozorilo', ;
                         'Popravi Memo', ;
                         "Can't determine cell type for INPLACE edit.", ;
                         "Excel is not available.", ;
                         "OpenOffice is not available.", ;
                         "OpenOffice Desktop is not available.", ;
                         "OpenOffice Calc is not available.", ;
                         " successfully installed.", ;
                         " not installed.", ;
                         "Error creating TReg32 object ", ;
                         "This screen saver has no configurable options.", ;
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends !!!", ;                                                                      // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed !!!", ;                                                                   // 24
                         "File is already encrypted !!!", ;                                                                         // 25
                         "File is not encrypted !!!", ;                                                                             // 26
                         "Password is invalid !!!", ;                                                                               // 27
                         "The names of the new file and the old file must be different !!!", ;                                      // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Dodaj", ;
                         "Popravi", ;
                         "Prekini", ;
                         "V redu" }
   acBrowseError    := { "Window: ", ;
                         " not defined. Program terminated.", ;
                         "Error", ;
                         "Control: ", ;
                         " Of ", ;
                         " Already defined. Program terminated.", ;
                         "Type Not Allowed. Program terminated.", ;
                         "False WorkArea. Program terminated.", ;
                         "Zapis ureja drug uporabnik", ;
                         "Opozorilo", ;
                         "Narobe vnos" }
   acBrowseMessages := { 'Ste preprièani ?', ;
                         'Briši zapis', ;
                         'Briši Vrstico' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Briši vrstico" + CRLF + "Ste preprièani ?" + CRLF, ;
                         CRLF + "Manjka indeksna datoteka" + CRLF + "Ne morem iskati" + CRLF, ;
                         CRLF + "Ne najdem indeksnega polja" + CRLF + "Ne morem iskati" + CRLF, ;
                         CRLF + "Ne morem iskati po" + CRLF + "memo ali logiènih poljih" + CRLF, ;
                         CRLF + "Ne najdem vrstice" + CRLF, ;
                         CRLF + "Preveè kolon" + CRLF + "Poroèilo ne gre na list" + CRLF, ;
                         CRLF + "Record is locked by another user" + CRLF + "Retry later" + CRLF }
   acABMLabel       := { "Vrstica", ;
                         "Število vrstic", ;
                         "       (Nova)", ;
                         "      (Popravi)", ;
                         "Vnesi številko vrstice", ;
                         "Poišèi", ;
                         "Besedilo za iskanje", ;
                         "Datum za iskanje", ;
                         "Številka za iskanje", ;
                         "Parametri poroèila", ;
                         "Kolon v poroèilu", ;
                         "Kolon na razpolago", ;
                         "Zaèetna vrstica", ;
                         "Konèna vrstica", ;
                         "Pporoèilo za ", ;
                         "Datum:", ;
                         "Zaèetna vrstica:", ;
                         "Konèna vrstica:", ;
                         "Urejeno po:", ;
                         "Ja", ;
                         "Ne", ;
                         "Stran ", ;
                         " od " }
   acABMButton      := { "Zapri", ;
                         "Nova", ;
                         "Uredi", ;
                         "Briši", ;
                         "Poišèi", ;
                         "Pojdi na", ;
                         "Poroèilo", ;
                         "Prva", ;
                         "Prejšnja", ;
                         "Naslednja", ;
                         "Zadnja", ;
                         "Shrani", ;
                         "Prekini", ;
                         "Dodaj", ;
                         "Odstrani", ;
                         "Natisni", ;
                         "Zapri" }
   acABMError       := { "EDIT, workarea name missing", ;
                         "EDIT, this workarea has more than 16 fields", ;
                         "EDIT, refresh mode out of range (please report bug)", ;
                         "EDIT, main event number out of range (please report bug)", ;
                         "EDIT, list event number out of range (please report bug)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Zapri", ;                                            // 1
                         "&Nova", ;                                             // 2
                         "&Spremeni", ;                                         // 3
                         "&Briši", ;                                            // 4
                         "&Poišèi", ;                                           // 5
                         "&Natisni", ;                                          // 6
                         "&Prekini", ;                                          // 7
                         "&V redu", ;                                           // 8
                         "&Kopiraj", ;                                          // 9
                         "&Aktiviraj Filter", ;                                 // 10
                         "&Deaktiviraj Filter" }                                // 11
   acLabel          := { "Prazno", ;                                            // 1
                         "Vrstica", ;                                           // 2
                         "Skupaj", ;                                            // 3
                         "Activni indeks", ;                                    // 4
                         "Možnosti", ;                                          // 5
                         "Nova vrstica", ;                                      // 6
                         "Spreminjaj vrstico", ;                                // 7
                         "Oznaèi vrstico", ;                                    // 8
                         "Najdi vrstico", ;                                     // 9
                         "Možnosti tiskanja", ;                                 // 10
                         "Polja na razpolago", ;                                // 11
                         "Polja za tiskanje", ;                                 // 12
                         "Tiskalniki na razpolago", ;                           // 13
                         "Prva vrstica za tiskanje", ;                          // 14
                         "Zadnja vrstica za tiskanje", ;                        // 15
                         "Briši vrstico", ;                                     // 16
                         "Pregled", ;                                           // 17
                         "Mini pregled strani", ;                               // 18
                         "Pogoj za filter: ", ;                                 // 19
                         "Filtrirano: ", ;                                      // 20
                         "Možnosti filtra", ;                                   // 21
                         "Polja v datoteki", ;                                  // 22
                         "Operator za primerjavo", ;                            // 23
                         "Vrednost filtra", ;                                   // 24
                         "Izberi polje za filter", ;                            // 25
                         "Izberi operator za primerjavo", ;                     // 26
                         "Enako", ;                                             // 27
                         "Neenako", ;                                           // 28
                         "Veèje od", ;                                          // 29
                         "Manjše od", ;                                         // 30
                         "Veèje ali enako od", ;                                // 31
                         "Manjše ali enako od" }                                // 32
   acUser           := { CRLF + "Can't find an active area.   " + CRLF + "Please select any area before call EDIT   " + CRLF, ;  // 1
                         "Vnesi vrednost (tekst)", ;                                                                             // 2
                         "Vnesi vrednost (številka)", ;                                                                          // 3
                         "Izberi datum", ;                                                                                       // 4
                         "Oznaèi za logièni DA", ;                                                                               // 5
                         "Vnesi vrednost", ;                                                                                     // 6
                         "Izberi vrstico in pritisni <V redu>", ;                                                                // 7
                         CRLF + "Pobrisali boste trenutno vrstico   " + CRLF + "Ste preprièani?    " + CRLF, ;                   // 8
                         CRLF + "Ni aktivnega indeksa   " + CRLF + "Prosimo, izberite ga   " + CRLF, ;                           // 9
                         CRLF + "Ne morem iskati po logiènih oz. memo poljih   " + CRLF, ;                                       // 10
                         CRLF + "Ne najdem vrstice   " + CRLF, ;                                                                 // 11
                         "Izberite polje, ki bo vkljuèeno na listo", ;                                                           // 12
                         "Izberite polje, ki NI vkljuèeno na listo", ;                                                           // 13
                         "Izberite tisklanik", ;                                                                                 // 14
                         "Pritisnite gumb za vkljuèitev polja", ;                                                                // 15
                         "Pritisnite gumb za izkljuèitev polja", ;                                                               // 16
                         "Pritisnite gumb za izbor prve vrstice za tiskanje", ;                                                  // 17
                         "Pritisnite gumb za izbor zadnje vrstice za tiskanje", ;                                                // 18
                         CRLF + "Ni veè polj za dodajanje   " + CRLF, ;                                                          // 19
                         CRLF + "Najprej izberite ppolje za vkljuèitev   " + CRLF, ;                                             // 20
                         CRLF + "Ni veè polj za izkljuèitev   " + CRLF, ;                                                        // 21
                         CRLF + "Najprej izberite polje za izkljuèitev   " + CRLF, ;                                             // 22
                         CRLF + "Niste izbrali nobenega polja   " + CRLF + "Prosom, izberite polje za tiskalnje   " + CRLF, ;    // 23
                         CRLF + "Preveè polj   " + CRLF + "Zmanjšajte število polj   " + CRLF, ;                                 // 24
                         CRLF + "Tiskalnik ni pripravljen   " + CRLF, ;                                                          // 25
                         "Urejeno po", ;                                                                                         // 26
                         "Od vrstice", ;                                                                                         // 27
                         "do vrstice", ;                                                                                         // 28
                         "Ja", ;                                                                                                 // 29
                         "Ne", ;                                                                                                 // 30
                         "Stran:", ;                                                                                             // 31
                         CRLF + "Izberite tiskalnik   " + CRLF, ;                                                                // 32
                         "Filtrirano z", ;                                                                                       // 33
                         CRLF + "Aktiven filter v uporabi    " + CRLF, ;                                                         // 34
                         CRLF + "Ne morem filtrirati z memo polji    " + CRLF, ;                                                 // 35
                         CRLF + "Izberi polje za filtriranje    " + CRLF, ;                                                      // 36
                         CRLF + "Izberi operator za filtriranje    " + CRLF, ;                                                   // 37
                         CRLF + "Vnesi vrednost za filtriranje    " + CRLF, ;                                                    // 38
                         CRLF + "Ni aktivnega filtra    " + CRLF, ;                                                              // 39
                         CRLF + "Deaktiviram filter?   " + CRLF, ;                                                               // 40
                         CRLF + "Vrstica zaklenjena - uporablja jo drug uporabnik    " + CRLF }                                  // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
FUNCTION ooHG_Messages_TR

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Eminmisiniz ?', ;
                         'Pencereyi kapat', ;
                         'Kapatma izni yok', ;
                         'Program halen çalýþýyor', ;
                         'Düzelt', ;
                         'Tamam', ;
                         'Ýptal', ;
                         'Sayf.', ;
                         'Hata', ;
                         'Dikkat', ;
                         'Not düzelt', ;
                         "Hücre tipi düzenlemek için uygun deðil.", ;
                         "Excel is not available.", ;
                         "OpenOffice is not available.", ;
                         "OpenOffice Desktop is not available.", ;
                         "OpenOffice Calc is not available.", ;
                         " successfully installed.", ;
                         " not installed.", ;
                         "Error creating TReg32 object ", ;
                         "This screen saver has no configurable options.", ;
                         "Can't open file ", ;                                                                                      // 21
                         "Not enough space for legends !!!", ;                                                                      // 22
                         { 'Report format is not valid: no ' + DQM( "DO REPORT" ) + ' nor ' + DQM( "DEFINE REPORT" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "FIELDS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.', ;
                           'Report format is not valid: no ' + DQM( "WIDTHS" ) + ' found.' }, ;                                     // 23
                         "File I/O error, can not proceed !!!", ;                                                                   // 24
                         "File is already encrypted !!!", ;                                                                         // 25
                         "File is not encrypted !!!", ;                                                                             // 26
                         "Password is invalid !!!", ;                                                                               // 27
                         "The names of the new file and the old file must be different !!!", ;                                      // 28
                         "Player creation failed!", ;                                                                               // 29
                         "AnimateBox creation failed!" }                                                                            // 30

   // BROWSE MESSAGES
   acBrowseButton   := { "Yeni Giriþ", ;
                         "Düzelt", ;
                         "&Ýptal", ;
                         "&Tamam" }
   acBrowseError    := { "Pencere: ", ;
                         " Tanýmlanmamýþ. Program sonlandý.", ;
                         "Hata ", ;
                         "Control: ", ;
                         "   ", ;
                         " Önceden tanýmlý. Program sonlandý.", ;
                         "Browse: Tip tanýmlý deðil. Program sonlandý.", ;
                         "Browse: Giriþ modunda gözatma iþlemi uygun deðil. Program sonlandý.", ;
                         "Kaydý diðer kullanýcý düzenliyor", ;
                         "Dikkat", ;
                         "Giriþ tanýmlanmamýþ" }
   acBrowseMessages := { 'Eminmisiniz ?', ;
                         'Kayýt Sil', ;
                         'Öðeyi Sil' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Kayýt sil" + CRLF + "Eminmisiniz ?" + CRLF, ;
                         CRLF + "Index dosyasý kayýp" + CRLF + "Arama iþlemi yapýlamýyor" + CRLF, ;
                         CRLF + "Index dosyasý bulunamadý" + CRLF + "Arama iþlemi yapýlamýyor" + CRLF, ;
                         CRLF + "Arama yapýlamaz" + CRLF + "Not ve mantýksal alanlarda" + CRLF, ;
                         CRLF + "Kayýt bulunamadý" + CRLF, ;
                         CRLF + "kolon sayýsý fazla" + CRLF + " Rapor sayfasýna sýðmýyor" + CRLF, ;
                         CRLF + "Record is locked by another user" + CRLF + "Retry later" + CRLF }
   acABMLabel       := { "Kayýt", ;
                         "Kayýt sayýsý", ;
                         "       Yeni", ;
                         "      Düzelt", ;
                         "Kayýt numarasý gir", ;
                         "Bul", ;
                         "Text ara", ;
                         "Tarih ara", ;
                         "Sayý ara", ;
                         "Rapor tanýmlarý", ;
                         "Rapor kolonlarý", ;
                         "Kullanýlabilir kolonlar", ;
                         "Tanýmlý kayýt", ;
                         "Son kayýt", ;
                         "Rapor ", ;
                         "Tarih.", ;
                         "Tanýmlý kayýt", ;
                         "Son kayýt", ;
                         "Sýralama:", ;
                         "Evet", ;
                         "Hayýr", ;
                         "Sayfa ", ;
                         "  " }
   acABMButton      := { "Kapat", ;
                         "Yeni", ;
                         "Düzelt", ;
                         "Sil", ;
                         "Bul", ;
                         "Git", ;
                         "Rapor", ;
                         "Ýlk", ;
                         "Önceki", ;
                         "Sonraki", ;
                         "Son", ;
                         "Kaydet", ;
                         "Ýptal", ;
                         "Ekle", ;
                         "Sil", ;
                         "Yazdýr", ;
                         "Kapat" }
   acABMError       := { "Düzelt, Dosya adý tanýmlanmamýþ veya kayýp", ;
                         "Düzelt, Bu dosyanýn alan sayýsý 16 dan fazla ", ;
                         "Düzelt, Aralýðý aþmýþ durumdasýnýz", ;
                         "Düzelt, Numara aralýðý aþmýþ", ;
                         "Düzelt, Listelemede numara aþýlmýþ" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Kapat", ;                                                                                                         // 1
                         "&Yeni", ;                                                                                                          // 2
                         "&Düzelt", ;                                                                                                        // 3
                         "&Sil", ;                                                                                                           // 4
                         "&Bul", ;                                                                                                           // 5
                         "&Yazdýr", ;                                                                                                        // 6
                         "&Ýptal", ;                                                                                                         // 7
                         "&Tamam", ;                                                                                                         // 8
                         "&Kopya", ;                                                                                                         // 9
                         "&Filtre Aktif", ;                                                                                                  // 10
                         "&Filtre Pasif" }                                                                                                   // 11
   acLabel          := { "Boþ", ;                                                                                                            // 1
                         "Kayýt", ;                                                                                                          // 2
                         "Toplam", ;                                                                                                         // 3
                         "Aktif sýralama", ;                                                                                                 // 4
                         "iþlemler", ;                                                                                                       // 5
                         "Yeni Kayýt", ;                                                                                                     // 6
                         "Kayýt düzelt", ;                                                                                                   // 7
                         "Kayýt seç", ;                                                                                                      // 8
                         "Kayýt bul", ;                                                                                                      // 9
                         "Yazýcý iþlemleri", ;                                                                                               // 10
                         "Kullanýlbilir alanlar", ;                                                                                          // 11
                         "Yazýcýda alanlarý", ;                                                                                              // 12
                         "Kullanýlabilir Yazýcýlar", ;                                                                                       // 13
                         "Yazýlacak ilk kayýt", ;                                                                                            // 14
                         "Yazýlacak son kayýt", ;                                                                                            // 15
                         "Kayýt sil", ;                                                                                                      // 16
                         "Ön izleme", ;                                                                                                      // 17
                         "Sayfa görüntücük", ;                                                                                               // 18
                         "Filtre ifadesi: ", ;                                                                                               // 19
                         "Filtrelendi: ", ;                                                                                                  // 20
                         "Filtre Ýþlemleri", ;                                                                                               // 21
                         "Database alanlarý", ;                                                                                              // 22
                         "Karþýlaþtýrma iþareleri", ;                                                                                        // 23
                         "Filtre deðiþkeni", ;                                                                                               // 24
                         "Filtre alan seçimi", ;                                                                                             // 25
                         "Karþýlaþtýrma Ýþlem seçimi", ;                                                                                     // 26
                         "Eþit", ;                                                                                                           // 27
                         "Eþit deðil", ;                                                                                                     // 28
                         "den Büyük", ;                                                                                                      // 29
                         "den Küçük", ;                                                                                                      // 30
                         "Büyük veya eþit", ;                                                                                                // 31
                         "Küçük veya eþit" }                                                                                                 // 32
   acUser           := { CRLF + "Aktif database bulunamadý.   " + CRLF + "Lütfen seçiminizi düzeltin   " + CRLF, ;               // 1
                         "alan text tanýmlý", ;                                                                                  // 2
                         "alan sayýsal tanýmlý", ;                                                                               // 3
                         "Tarih seç", ;                                                                                          // 4
                         "Doðru deðiþkeni iþaretleyin", ;                                                                        // 5
                         "Alan deðiþkeni girin", ;                                                                               // 6
                         "Kayýt seçimi yaparak onaylayýn", ;                                                                     // 7
                         CRLF + "Aktif kaydý siliyorsunuz.  " + CRLF + "Eminmisiniz ?    " + CRLF, ;                             // 8
                         CRLF + "Aktif sýralama yok   " + CRLF + "Lütfen seçim yapýn " + CRLF, ;                                 // 9
                         CRLF + "Not alanlarý ve mantýksal alanlarda arama yapýlamaz " + CRLF, ;                                 // 10
                         CRLF + "Kayýt yok  " + CRLF, ;                                                                          // 11
                         "Tanýmlý alan listesi Seçimi", ;                                                                        // 12
                         "Listeden alanlarý seçiniz", ;                                                                          // 13
                         "Yazýcý Seçimi", ;                                                                                      // 14
                         "Tanýmlý alanlarý seç", ;                                                                               // 15
                         "Seçilmiþ alanlar", ;                                                                                   // 16
                         "Yazdýrýlacak ilk kayýt seçimi", ;                                                                      // 17
                         "Yazdýrýlacak son kayýt seçimi", ;                                                                      // 18
                         CRLF + "Seçilmiþ alan çok fazla  " + CRLF, ;                                                            // 19
                         CRLF + "Ýlk alanlarý tanýmlayýn  " + CRLF, ;                                                            // 20
                         CRLF + "Alanlar tanýmlanmamýþ   " + CRLF, ;                                                             // 21
                         CRLF + "Önce alan tanýmlanmalý " + CRLF, ;                                                              // 22
                         CRLF + "Hiç alan seçmediniz  " + CRLF + "Yazdýrmadan önce alanlar tanýmlanmýþ olmalý " + CRLF, ;        // 23
                         CRLF + "Çok fazla alan var " + CRLF + "Alan sayýsýný uygun hale getirin " + CRLF, ;                     // 24
                         CRLF + "Yazýcý hazýr deðil " + CRLF, ;                                                                  // 25
                         "Sýralama ", ;                                                                                          // 26
                         "ilk kayýt ", ;                                                                                         // 27
                         "son kayýt", ;                                                                                          // 28
                         "Evet", ;                                                                                               // 29
                         "Hayýr", ;                                                                                              // 30
                         "Sayfa:", ;                                                                                             // 31
                         CRLF + "Lütfen yazýcý seçin  " + CRLF, ;                                                                // 32
                         "Filtreleme ", ;                                                                                        // 33
                         CRLF + "Aktif filtre " + CRLF, ;                                                                        // 34
                         CRLF + "Not alanlarýnda filtreleme yapýlamaz " + CRLF, ;                                                // 35
                         CRLF + "Filtre için alan seç " + CRLF, ;                                                                // 36
                         CRLF + "Filtre için Ýþlem seç  " + CRLF, ;                                                              // 37
                         CRLF + "Alan tipi filtrelemeye uymuyor " + CRLF, ;                                                      // 38
                         CRLF + "Aktif hiç filtre yok  " + CRLF, ;                                                               // 39
                         CRLF + "Filtre Ýptali ?   " + CRLF, ;                                                                   // 40
                         CRLF + "Diðer kullanýcýlar kaydý kullanýyor " + CRLF }                                                  // 41

   // PRINT MESSAGES
   acPrint          := { "TPrint nesnesi zaten baslatildi!", ;
                         "Yazdýrýlýyor ......", ;
                         "Yazýcýya aktarýlýyor", ;
                         " Yazdýrýldý !!!", ;
                         "Tanýmsýz parametre veya iþlem var !!!", ;
                         "Yazýcý çaðrýlamadý !!!", ;
                         "Yazdýrmaya baþlanamadý !!!", ;
                         "Sayfalar yazdýrýlamýyor !!!", ;
                         "Ýþleminiz gerçekleþtirilemiyor !!!", ;
                         " BULUNAMADI !!!", ;
                         "Yazýcý bulunmýyor !!!", ;
                         "HATA", ;
                         "Yazýcý baðlantýsý kullanýlamýyor !!!", ;
                         "Yazýcý Seç ", ;
                         "Tamam", ;
                         "Ýptal", ;
                         'Önizleme --> ', ;
                         "Kapat", ;
                         "Kapat", ;
                         "Büyült", ;
                         "Küçült", ;
                         "Küçült", ;
                         "Küçült", ;
                         "Yazdýr", ;
                         "Yazdýrma Modu ", ;
                         "Ara ", ;
                         "Ara ", ;
                         "Sonraki arama ", ;
                         "Sonraki arama ", ;
                         'Sözcük: ', ;
                         'Aranacak cümle ', ;
                         "Arama sonlandý.", ;
                         "Bilgilendirme ", ;
                         'Excel bulunamadý !!!', ;
                         "XLS uzantýsý deðil !!!", ;
                         "Kaydedilecek dosya : ", ;
                         "HTML uzantýlý deðil !!!", ;
                         "RTF uzantýlý deðil !!!", ;
                         "CSV uzantýlý deðil !!!", ;
                         "PDF uzantýlý deðil !!!", ;
                         "ODT uzantýlý deðil !!!", ;
                         'Barcode gerekli bir karakter deðiþkeni !!!', ;
                         'Code 128 modunda A, B veya C karakter deðiþkeni !!!', ;
                         "Hesap bulunamadý !!!", ;
                         "Dosya kaydýnda hata: ", ;
                         "Baska bir belgenin önizlemesi etkin!" , ;
                         "Baska bir belge açik!" , ;
                         "TPrint nesnesi baslatilmadi!", ;
                         "TPrint nesnesi hata durumunda!", ;
                         "TPrint belgesi açik degil!!" }

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

/*--------------------------------------------------------------------------------------------------------------------------------*/
#pragma BEGINDUMP

#include "oohg.h"
#include "hbapiitm.h"
#include <windowsx.h>

static PHB_ITEM _OOHG_Messages;

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITMESSAGES_C_SIDE )          /* FUNCTION InitMessages_C_Side() -> NIL */
{
   static BOOL init = FALSE;

   if( ! init )
   {
      WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

      _OOHG_Messages = hb_itemNew( NULL );
      hb_itemCopy( _OOHG_Messages, hb_param( 1, HB_IT_ARRAY ) );

      ReleaseMutex( _OOHG_GlobalMutex() );
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
char * _OOHG_Msg( UINT iTable, UINT iItem, UINT iSubItem )
{
   char * pMsg = NULL;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   if( iTable >= 1 &&
       iTable <= hb_arrayLen( _OOHG_Messages ) )
   {
      if( iItem >= 1 &&
          iItem <= hb_arrayLen( hb_arrayGetItemPtr( _OOHG_Messages, iTable ) ) )
      {
         if( HB_IS_ARRAY( hb_arrayGetItemPtr( hb_arrayGetItemPtr( _OOHG_Messages, iTable ), iItem ) ) )
         {
            if( iSubItem >= 1 && 
                iSubItem <= hb_arrayLen( hb_arrayGetItemPtr( hb_arrayGetItemPtr( _OOHG_Messages, iTable ), iItem ) ) )
            {
               pMsg = ( char * ) HB_UNCONST( hb_arrayGetCPtr( hb_arrayGetItemPtr( hb_arrayGetItemPtr( _OOHG_Messages, iTable ), iItem ), iSubItem ) );
            }
         }
         else
         {
            pMsg = ( char * ) HB_UNCONST( hb_arrayGetCPtr( hb_arrayGetItemPtr( _OOHG_Messages, iTable ), iItem ) );
         }
      }
   }

   ReleaseMutex( _OOHG_GlobalMutex() );

   return pMsg;
}

#pragma ENDDUMP
