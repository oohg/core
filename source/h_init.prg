/*
* $Id: h_init.prg $
*/
/*
* ooHG source code:
* Initialization procedure
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

#ifndef __XHARBOUR__
REQUEST DBFNTX, DBFDBT
ANNOUNCE hb_GTSYS
#endif

STATIC _OOHG_Messages := { {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }          // TODO: Thread safe ?   Move to TApplication ?

INIT PROCEDURE _OOHG_INIT()

   // Init mutexes
   TApplication():Define()

   // TODO: Move to TApplication ?
   _GETDDLMESSAGE()

   // TODO: Move to TApplication or make thread safe ?
   InitMessages()

   RETURN

PROCEDURE InitMessages( cLang )

   LOCAL aLang, aLangDefault, nAt

   IF ! ValType( cLang ) $ "CM" .OR. Empty( cLang )
      // [x]Harbour's default language
      cLang := Set( _SET_LANGUAGE )
   ENDIF
   IF ( nAt := At( ".", cLang ) ) > 0
      cLang := Left( cLang, nAt - 1 )
   ENDIF
   cLang := Upper( AllTrim( cLang ) )

   aLang := _OOHG_MacroCall( "ooHG_Messages_" + cLang + "()" )
   aLangDefault := ooHG_Messages_EN()

   IF ValType( aLang ) != "A"
      aLang := {}
   ENDIF

   _OOHG_Messages[  1 ] := InitMessagesMerge( aLang, aLangDefault,  1 )
   _OOHG_Messages[  2 ] := InitMessagesMerge( aLang, aLangDefault,  2 )
   _OOHG_Messages[  3 ] := InitMessagesMerge( aLang, aLangDefault,  3 )
   _OOHG_Messages[  4 ] := InitMessagesMerge( aLang, aLangDefault,  4 )
   _OOHG_Messages[  5 ] := InitMessagesMerge( aLang, aLangDefault,  5 )
   _OOHG_Messages[  6 ] := InitMessagesMerge( aLang, aLangDefault,  6 )
   _OOHG_Messages[  7 ] := InitMessagesMerge( aLang, aLangDefault,  7 )
   _OOHG_Messages[  8 ] := InitMessagesMerge( aLang, aLangDefault,  8 )
   _OOHG_Messages[  9 ] := InitMessagesMerge( aLang, aLangDefault,  9 )
   _OOHG_Messages[ 10 ] := InitMessagesMerge( aLang, aLangDefault, 10 )
   _OOHG_Messages[ 11 ] := InitMessagesMerge( aLang, aLangDefault, 11 )
   _OOHG_Messages[ 12 ] := InitMessagesMerge( aLang, aLangDefault, 12 )

   RETURN

FUNCTION _OOHG_Messages( nTable, nItem )

   RETURN iif( ( ValType( nTable ) == "N" .AND. nTable >= 1 .AND. nTable <= Len( _OOHG_Messages ) .AND. ;
      ValType( nItem ) == "N" .AND. nItem >= 1 .AND. nItem <= Len( _OOHG_Messages[ nTable] ) ), ;
      _OOHG_Messages[ nTable ][ nItem ], "" )

STATIC FUNCTION InitMessagesMerge( aLang, aLangDefault, nTable )

   LOCAL aReturn

   aReturn := AClone( aLangDefault[ nTable ] )
   IF Len( aLang ) >= nTable .AND. ValType( aLang[ nTable ] ) == "A"
      AEval( aReturn, { |c,i| iif( Len( aLang[ nTable ] ) >= i .AND. ValType( aLang[ nTable ][ i ] ) $ "CM", aReturn[ i ] := aLang[ nTable ][ i ], c ) } )
   ENDIF

   RETURN aReturn

FUNCTION ooHG_Messages_EN // English (default)

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Are you sure ?', ;
      'Close Window', ;
      'Close not allowed', ;
      'Program is already running', ;
      'Edit', ;
      'Ok', ;
      'Cancel', ;
      'Pag.', ;
      'Error', ;
      'Warning', ;
      'Edit Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Append", ;
      "Edit", ;
      "&Cancel", ;
      "&OK" }
   acBrowseError    := { "Window: ", ;
      " is not defined. Program terminated.", ;
      "OOHG Error", ;
      "Control: ", ;
      " Of ", ;
      " Already defined. Program terminated.", ;
      "Browse: Type Not Allowed. Program terminated.", ;
      "Browse: Append Clause Can't Be Used With Fields Not Belonging To Browse WorkArea. Program terminated.", ;
      "Record Is Being Edited By Another User", ;
      "Warning", ;
      "Invalid Entry" }
   acBrowseMessages := { 'Are you sure ?', ;
      'Delete Record', ;
      'Delete Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Delete record" + CRLF + "Are you sure ?" + CRLF, ;
      CRLF + "Index file missing" + CRLF + "Can't do search" + CRLF, ;
      CRLF + "Can't find index field" + CRLF + "Can't do search" + CRLF, ;
      CRLF + "Can't do search by" + CRLF + "fields memo or logic" + CRLF, ;
      CRLF + "Record not found" + CRLF, ;
      CRLF + "Too many cols" + CRLF + "The report don't fit in the sheet" + CRLF }
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
   acABMError       := { "EDIT, workarea name is missing", ;
      "EDIT, this workarea has more than 16 fields", ;
      "EDIT, refresh mode out of range (please report bug)", ;
      "EDIT, main event number out of range (please report bug)", ;
      "EDIT, list event number out of range (please report bug)" }

   // EDIT EXTENDED MESSAGES
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
   acUser           := { CRLF + "Can't find an active area.   " + CRLF + "Please select any area before call EDIT   " + CRLF, ;      // 1
   "Type the field value (any text)", ;                                                                        // 2
   "Type the field value (any number)", ;                                                                      // 3
   "Select the date", ;                                                                                        // 4
   "Check for true value", ;                                                                                   // 5
   "Enter the field value", ;                                                                                  // 6
   "Select any record and press OK", ;                                                                         // 7
   CRLF + "You are going to delete the active record   " + CRLF + "Are you sure?    " + CRLF, ;                // 8
   CRLF + "There isn't any active order   " + CRLF + "Please select one   " + CRLF, ;                          // 9
   CRLF + "Can't do searches by fields memo or logic   " + CRLF, ;                                             // 10
   CRLF + "Record not found   " + CRLF, ;                                                                      // 11
   "Select the field to include to list", ;                                                                    // 12
   "Select the field to exclude from list", ;                                                                  // 13
   "Select the printer", ;                                                                                     // 14
   "Push button to include field", ;                                                                           // 15
   "Push button to exclude field", ;                                                                           // 16
   "Push button to select the first record to print", ;                                                        // 17
   "Push button to select the last record to print", ;                                                         // 18
   CRLF + "No more fields to include   " + CRLF, ;                                                             // 19
   CRLF + "First select the field to include   " + CRLF, ;                                                     // 20
   CRLF + "No more fields to exlude   " + CRLF, ;                                                              // 21
   CRLF + "First select th field to exclude   " + CRLF, ;                                                      // 22
   CRLF + "You don't select any field   " + CRLF + "Please select the fields to include on print   " + CRLF, ; // 23
   CRLF + "Too many fields   " + CRLF + "Reduce number of fields   " + CRLF, ;                                 // 24
   CRLF + "Printer not ready   " + CRLF, ;                                                                     // 25
   "Ordered by", ;                                                                                             // 26
   "From record", ;                                                                                            // 27
   "To record", ;                                                                                              // 28
   "Yes", ;                                                                                                    // 29
   "No", ;                                                                                                     // 30
   "Page:", ;                                                                                                  // 31
   CRLF + "Please select a printer   " + CRLF, ;                                                               // 32
   "Filtered by", ;                                                                                            // 33
   CRLF + "There is an active filter    " + CRLF, ;                                                            // 34
   CRLF + "Can't filter by memo fields    " + CRLF, ;                                                          // 35
   CRLF + "Select the field to filter    " + CRLF, ;                                                           // 36
   CRLF + "Select any operator to filter    " + CRLF, ;                                                        // 37
   CRLF + "Type any value to filter    " + CRLF, ;                                                             // 38
   CRLF + "There isn't any active filter    " + CRLF, ;                                                        // 39
   CRLF + "Deactivate filter?   " + CRLF, ;                                                                    // 40
   CRLF + "Record locked by another user    " + CRLF }                                                         // 41

   // PRINT MESSAGES
   acPrint          := { "Print preview pending, close first", ;
      "ooHG printing", ;
      "Auxiliar printing command", ;
      " PRINTED OK !!!", ;
      "Invalid parameters passed to function !!!", ;
      "WinAPI OpenPrinter() call failed !!!", ;
      "WinAPI StartDocPrinter() call failed !!!", ;
      "WinAPI StartPagePrinter() call failed !!!", ;
      "WinAPI malloc() call failed !!!", ;
      " NOT FOUND !!!", ;
      "No printer found !!!", ;
      "Error", ;
      "Port is not valid !!!", ;
      "Select printer", ;
      "OK", ;
      "Cancel", ;
      'Preview -----> ', ;
      "Close", ;
      "Close", ;
      "Zoom + ", ;
      "Zoom + ", ;
      "Zoom -", ;
      "Zoom -", ;
      "Print", ;
      "Print mode: ", ;
      "Search", ;
      "Search", ;
      "Next search", ;
      "Next search", ;
      'Text: ', ;
      'Search string', ;
      "Search ended.", ;
      "Information", ;
      'Excel not found !!!', ;
      "XLS extension not asociated !!!", ;
      "File saved in: ", ;
      "HTML extension not asociated !!!", ;
      "RTF extension not asociated !!!", ;
      "CSV extension not asociated !!!", ;
      "PDF extension not asociated !!!", ;
      "ODT extension not asociated !!!", ;
      'Barcodes require a character value !!!', ;
      'Code 128 modes are A, B or C (character values) !!!', ;
      "Calc not found !!!", ;
      "Error saving file: " }

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

FUNCTION ooHG_Messages_HR852 // Croatian

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Are you sure ?', ;
      'Zatvori prozor', ;
      'Zatvaranje nije dozvoljeno', ;
      'Program je ve� pokrenut', ;
      'Uredi', ;
      'U redu', ;
      'Prekid', ;
      'Pag.', ;
      'Pogre�ka', ;
      'Upozorenje', ;
      'Uredi Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

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

FUNCTION ooHG_Messages_FR // French

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Etes-vous s�re ?', ;
      'Fermer la fen�tre', ;
      'Fermeture interdite', ;
      'Programme d�j� activ�', ;
      'Editer', ;
      'Ok', ;
      'Abandonner', ;
      'Pag.', ;
      'Erreur', ;
      'Alerte', ;
      'Editer Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Ajout", ;
      "Modification", ;
      "Annuler", ;
      "OK" }
   acBrowseError    := { "Fen�tre: ", ;
      " n'est pas d�finie. Programme Termin�.", ;
      "Erreur OOHG", ;
      "Contr�le: ", ;
      " De ", ;
      " D�j� d�fini. Programme Termin�.", ;
      "Modification: Type non autoris�. Programme Termin�.", ;
      "Modification: La clause Ajout ne peut �tre utilis�e avec des champs n'appartenant pas � la zone de travail de Modification. Programme Termin�", ;
      "L'enregistrement est utilis� par un autre utilisateur", ;
      "Erreur", ;
      "Entr�e invalide" }
   acBrowseMessages := { 'Etes-vous s�re ?', ;
      'Suprimer Enregistrement', ;
      'Supprimer �l�ment' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Suppression d'enregistrement" + CRLF + "Etes-vous s�re ?" + CRLF, ;
      CRLF + "Index manquant" + CRLF + "Recherche impossible" + CRLF, ;
      CRLF + "Champ Index introuvable" + CRLF + "Recherche impossible" + CRLF, ;
      CRLF + "Recherche impossible" + CRLF + "sur champs memo ou logique" + CRLF, ;
      CRLF + "Enregistrement non trouv�" + CRLF, ;
      CRLF + "Trop de colonnes" + CRLF + "L'�tat ne peut �tre imprim�" + CRLF }
   acABMLabel       := { "Enregistrement", ;
      "Nb. total enr.", ;
      "   (Ajouter)", ;
      "  (Modifier)", ;
      "Entrez le num�ro de l'enregistrement", ;
      "Trouver", ;
      "Chercher texte", ;
      "Chercher date", ;
      "Chercher num�ro", ;
      "D�finition de l'�tat", ;
      "Colonnes de l'�tat", ;
      "Colonnes disponibles", ;
      "Enregistrement de d�but", ;
      "Enregistrement de fin", ;
      "Etat de ", ;
      "Date:", ;
      "Enregistrement de d�but:", ;
      "Enregistrement de fin:", ;
      "Tri� par:", ;
      "Oui", ;
      "Non", ;
      " Page", ;
      " de " }
   acABMButton      := { "Fermer", ;
      "Nouveau", ;
      "Modifier", ;
      "Supprimer", ;
      "Trouver", ;
      "Aller �", ;
      "Etat", ;
      "Premier", ;
      "Pr�c�dent", ;
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
      "EDIT, �v�nement principal nombre hors limite (Rapport d'erreur merci)", ;
      "EDIT, liste d'�v�nements nombre hors limite (Rapport d'erreur merci)" }

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
   "&D�activer Filtre" }                                  // 11
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
   "Champs � imprimer", ;                                 // 12
   "Imprimantes connect�es", ;                            // 13
   "Premier enregistrement � imprimer", ;                 // 14
   "Dernier enregistrement � imprimer", ;                 // 15
   "Enregistrement supprim�", ;                           // 16
   "Pr�visualisation", ;                                  // 17
   "Aper�u pages", ;                                      // 18
   "Condition filtre : ", ;                               // 19
   "Filtr� : ", ;                                         // 20
   "Options de filtrage", ;                               // 21
   "Champs de la Bdd", ;                                  // 22
   "Op�rateurs de comparaison", ;                         // 23
   "Valeur du filtre", ;                                  // 24
   "Selectionner le champ � filtrer", ;                   // 25
   "Selectionner l'op�rateur de comparaison", ;           // 26
   "Egal", ;                                              // 27
   "Diff�rent", ;                                         // 28
   "Plus grand", ;                                        // 29
   "Plus petit", ;                                        // 30
   "Plus grand ou �gal", ;                                // 31
   "Plus petit ou �gal" }                                 // 32
   acUser           := { CRLF + "Ne peut trouver une base active.   " + CRLF + "S�lectionner une base avant la fonction EDIT  " + CRLF, ;            // 1
   "Entrer la valeur du champ (du texte)", ;                                                                                   // 2
   "Entrer la valeur du champ (un nombre)", ;                                                                                  // 3
   "S�lectionner la date", ;                                                                                                   // 4
   "V�rifier la valeur logique", ;                                                                                             // 5
   "Entrer la valeur du champ", ;                                                                                              // 6
   "S�lectionner un enregistrement et appuyer sur OK", ;                                                                       // 7
   CRLF + "Vous voulez d�truire l'enregistrement actif  " + CRLF + "Etes-vous s�re?   " + CRLF, ;                              // 8
   CRLF + "Il n'y a pas d'ordre actif   " + CRLF + "S�lectionner en un   " + CRLF, ;                                           // 9
   CRLF + "Ne peut faire de recherche sur champ memo ou logique   " + CRLF, ;                                                  // 10
   CRLF + "Enregistrement non trouv�  " + CRLF, ;                                                                              // 11
   "S�lectionner le champ � inclure � la liste", ;                                                                             // 12
   "S�lectionner le champ � exclure de la liste", ;                                                                            // 13
   "S�lectionner l'imprimante", ;                                                                                              // 14
   "Appuyer sur le bouton pour inclure un champ", ;                                                                            // 15
   "Appuyer sur le bouton pour exclure un champ", ;                                                                            // 16
   "Appuyer sur le bouton pour s�lectionner le premier enregistrement � imprimer", ;                                           // 17
   "Appuyer sur le bouton pour s�lectionner le dernier champ � imprimer", ;                                                    // 18
   CRLF + "Plus de champs � inclure   " + CRLF, ;                                                                              // 19
   CRLF + "S�lectionner d'abord les champs � inclure   " + CRLF, ;                                                             // 20
   CRLF + "Plus de champs � exclure   " + CRLF, ;                                                                              // 21
   CRLF + "S�lectionner d'abord les champs � exclure   " + CRLF, ;                                                             // 22
   CRLF + "Vous n'avez s�lectionn� aucun champ   " + CRLF + "S�lectionner les champs � inclure dans l'impression   " + CRLF, ; // 23
   CRLF + "Trop de champs   " + CRLF + "R�duiser le nombre de champs   " + CRLF, ;                                             // 24
   CRLF + "Imprimante pas pr�te   " + CRLF, ;                                                                                  // 25
   "Tri� par", ;                                                                                                               // 26
   "De l'enregistrement", ;                                                                                                    // 27
   "A l'enregistrement", ;                                                                                                     // 28
   "Oui", ;                                                                                                                    // 29
   "Non", ;                                                                                                                    // 30
   "Page:", ;                                                                                                                  // 31
   CRLF + "S�lectionner une imprimante   " + CRLF, ;                                                                           // 32
   "Filtr� par", ;                                                                                                             // 33
   CRLF + "Il y a un filtre actif    " + CRLF, ;                                                                               // 34
   CRLF + "Filtre impossible sur champ memo    " + CRLF, ;                                                                     // 35
   CRLF + "S�lectionner un champ de filtre    " + CRLF, ;                                                                      // 36
   CRLF + "S�lectionner un op�rateur de filtre   " + CRLF, ;                                                                   // 37
   CRLF + "Entrer une valeur au filtre    " + CRLF, ;                                                                          // 38
   CRLF + "Il n'y a aucun filtre actif    " + CRLF, ;                                                                          // 39
   CRLF + "D�sactiver le filtre?   " + CRLF, ;                                                                                 // 40
   CRLF + "Record locked by another user" + CRLF }                                                                             // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

FUNCTION ooHG_Messages_DE // German

   RETURN ooHG_Messages_DEWIN()

FUNCTION ooHG_Messages_DEWIN // German

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Sind Sie sicher ?', ;
      'Fenster schlie�en', ;
      'Schlie�en nicht erlaubt', ;
      'Programm l�uft bereits', ;
      'Bearbeiten', ;
      'OK', ;
      'Abbrechen', ;
      'Seite', ;
      'Fehler', ;
      'Warnung', ;
      'Bearbeiten Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := {}
   acBrowseError    := {}
   acBrowseMessages := { 'Sind Sie sicher ?', ;
      'Datensatz L�schen', ;
      'Element L�schen' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Datensatz loeschen" + CRLF + "Sind Sie sicher ?" + CRLF, ;
      CRLF + " Falscher Indexdatensatz" + CRLF + "Suche unmoeglich" + CRLF, ;
      CRLF + "Man kann nicht Indexdatenfeld finden" + CRLF + "Suche unmoeglich" + CRLF, ;
      CRLF + "Suche unmoeglich nach" + CRLF + "Feld memo oder logisch" + CRLF, ;
      CRLF + "Datensatz nicht gefunden" + CRLF, ;
      CRLF + " zu viele Spalten" + CRLF + "Zu wenig Platz  fuer die Meldung auf dem Blatt" + CRLF }
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
   acButton         := { "S&chlie�en", ;                                        // 1
   "&Neu", ;                                              // 2
   "&Bearbeiten", ;                                       // 3
   "&L�schen", ;                                          // 4
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
   "Datensatz ausw�hlen", ;                               // 8
   "Datensatz finden", ;                                  // 9
   "Druckeinstellungen", ;                                // 10
   "Verf�gbare Felder", ;                                 // 11
   "Zu druckende Felder", ;                               // 12
   "Verf�gbare Drucker", ;                                // 13
   "Erster zu druckender Datensatz", ;                    // 14
   "Letzter zu druckender Datensatz", ;                   // 15
   "Datensatz l�schen", ;                                 // 16
   "Vorschau", ;                                          // 17
   "�bersicht", ;                                         // 18
   "Filterbedingung: ", ;                                 // 19
   "Gefiltert: ", ;                                       // 20
   "Filter-Einstellungen", ;                              // 21
   "Datenbank-Felder", ;                                  // 22
   "Vergleichs-Operator", ;                               // 23
   "Filterwert", ;                                        // 24
   "Zu filterndes Feld ausw�hlen", ;                      // 25
   "Vergleichs-Operator ausw�hlen", ;                     // 26
   "Gleich", ;                                            // 27
   "Ungleich", ;                                          // 28
   "Gr��er als", ;                                        // 29
   "Kleiner als", ;                                       // 30
   "Gr��er oder gleich als", ;                            // 31
   "Kleiner oder gleich als" }                            // 32
   acUser           := { CRLF + "Kein aktiver Arbeitsbereich gefunden.   " + CRLF + "Bitte einen Arbeitsbereich ausw�hlen vor dem Aufruf von EDIT   " + CRLF, ;  // 1
   "Einen Text eingeben (alphanumerisch)", ;                                                                                               // 2
   "Eine Zahl eingeben", ;                                                                                                                 // 3
   "Datum ausw�hlen", ;                                                                                                                    // 4
   "F�r positive Auswahl einen Haken setzen", ;                                                                                            // 5
   "Einen Text eingeben (alphanumerisch)", ;                                                                                               // 6
   "Einen Datensatz w�hlen und mit OK best�tigen", ;                                                                                       // 7
   CRLF + "Sie sind im Begriff, den aktiven Datensatz zu l�schen.   " + CRLF + "Sind Sie sicher?    " + CRLF, ;                            // 8
   CRLF + "Es ist keine Sortierung aktiv.   " + CRLF + "Bitte w�hlen Sie eine Sortierung   " + CRLF, ;                                     // 9
   CRLF + "Suche nach den Feldern memo oder logisch nicht m�glich.   " + CRLF, ;                                                           // 10
   CRLF + "Datensatz nicht gefunden   " + CRLF, ;                                                                                          // 11
   "Bitte ein Feld zum Hinzuf�gen zur Liste w�hlen", ;                                                                                     // 12
   "Bitte ein Feld zum Entfernen aus der Liste w�hlen ", ;                                                                                 // 13
   "Drucker ausw�hlen", ;                                                                                                                  // 14
   "Schaltfl�che  Feld hinzuf�gen", ;                                                                                                      // 15
   "Schaltfl�che  Feld Entfernen", ;                                                                                                       // 16
   "Schaltfl�che  Auswahl erster zu druckender Datensatz", ;                                                                               // 17
   "Schaltfl�che  Auswahl letzte zu druckender Datensatz", ;                                                                               // 18
   CRLF + "Keine Felder zum Hinzuf�gen mehr vorhanden   " + CRLF, ;                                                                        // 19
   CRLF + "Bitte erst ein Feld zum Hinzuf�gen w�hlen   " + CRLF, ;                                                                         // 20
   CRLF + "Keine Felder zum Entfernen vorhanden   " + CRLF, ;                                                                              // 21
   CRLF + "Bitte ein Feld zum Entfernen w�hlen   " + CRLF, ;                                                                               // 22
   CRLF + "Kein Feld ausgew�hlt   " + CRLF + "Bitte die Felder f�r den Ausdruck ausw�hlen   " + CRLF, ;                                    // 23
   CRLF + "Zu viele Felder   " + CRLF + "Bitte Anzahl der Felder reduzieren   " + CRLF, ;                                                  // 24
   CRLF + "Drucker nicht bereit   " + CRLF, ;                                                                                              // 25
   "Sortiert nach", ;                                                                                                                      // 26
   "Von Datensatz", ;                                                                                                                      // 27
   "Bis Datensatz", ;                                                                                                                      // 28
   "Ja", ;                                                                                                                                 // 29
   "Nein", ;                                                                                                                               // 30
   "Seite:", ;                                                                                                                             // 31
   CRLF + "Bitte einen Drucker w�hlen   " + CRLF, ;                                                                                        // 32
   "Filtered by", ;                                                                                                                        // 33
   CRLF + "Es ist kein aktiver Filter vorhanden    " + CRLF, ;                                                                             // 34
   CRLF + "Kann nicht nach Memo-Feldern filtern    " + CRLF, ;                                                                             // 35
   CRLF + "Feld zum Filtern ausw�hlen    " + CRLF, ;                                                                                       // 36
   CRLF + "Einen Operator zum Filtern ausw�hlen    " + CRLF, ;                                                                             // 37
   CRLF + "Bitte einen Wert f�r den Filter angeben    " + CRLF, ;                                                                          // 38
   CRLF + "Es ist kein aktiver Filter vorhanden    " + CRLF, ;                                                                             // 39
   CRLF + "Filter deaktivieren?   " + CRLF, ;                                                                                              // 40
   CRLF + "Record locked by another user" + CRLF }                                                                                         // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

FUNCTION ooHG_Messages_IT // Italian

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Sei sicuro ?', ;
      'Chiudi la finestra', ;
      'Chiusura non consentita', ;
      'Il programma � gi� in esecuzione', ;
      'Edita', ;
      'Conferma', ;
      'Annulla', ;
      'Pag.', ;
      'Errore', ;
      'Avvertimento', ;
      'Edita Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Aggiungere", ;
      "Modificare", ;
      "Cancellare", ;
      "OK" }
   acBrowseError    := { "Window: ", ;
      " non � definita. Programma Terminato.", ;
      "Errore OOHG", ;
      "Controllo: ", ;
      " Di ", ;
      " Gi� definito. Programma Terminato.", ;
      "Browse: Tipo non valido. Programma Terminato.", ;
      "Browse: Modifica non possibile: il campo non � pertinente l'area di lavoro.Programma Terminato.", ;
      "Record gi� utilizzato da altro utente", ;
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
      CRLF + "Troppe colonne" + CRLF + "Il report non pu� essere stampato" + CRLF }
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
      "S�", ;
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
   acABMError       := { "EDIT, il nome dell'area � mancante", ;
      "EDIT, quest'area contiene pi� di 16 campi", ;
      "EDIT, modalit� aggiornamento fuori dal limite (segnalare l'errore)", ;
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

FUNCTION ooHG_Messages_PL852 // Polish

   RETURN ooHG_Messages_PLWIN()

FUNCTION ooHG_Messages_PLISO // Polish

   RETURN ooHG_Messages_PLWIN()

FUNCTION ooHG_Messages_PLMAZ // Polish

   RETURN ooHG_Messages_PLWIN()

FUNCTION ooHG_Messages_PLWIN // Polish

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Czy jeste� pewny ?', ;
      'Zamknij okno', ;
      'Zamkni�cie niedozwolone', ;
      'Program ju� uruchomiony', ;
      'Edycja', ;
      'Ok', ;
      'Porzu�', ;
      'Pag.', ;
      'B��d', ;
      'Ostrze�enie', ;
      'Edycja Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Dodaj", ;
      "Edycja", ;
      "Porzu�", ;
      "OK" }
   acBrowseError    := { "Okno: ", ;
      " nie zdefiniowane.Program zako�czony", ;
      "B��d OOHG", ;
      "Kontrolka: ", ;
      " z ", ;
      " ju� zdefiniowana. Program zako�czony", ;
      "Browse: Niedozwolony typ danych. Program zako�czony", ;
      "Browse: Klauzula Append nie mo�e by� stosowana do p�l nie nale��cych do aktualnego obszaru roboczego. Program zako�czony", ;
      "Rekord edytowany przez innego u�ytkownika", ;
      "Ostrze�enie", ;
      "Nieprawid�owy wpis" }
   acBrowseMessages := { 'Czy jesteo pewny ?', ;
      'Skasuj Rekord', ;
      'Skasuj Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Usuni�cie rekordu" + CRLF + "Jeste� pewny ?" + CRLF, ;
      CRLF + "B��dny zbi�r Indeksowy" + CRLF + "Nie mo�na szuka�" + CRLF, ;
      CRLF + "Nie mo�na znale�� pola indeksu" + CRLF + "Nie mo�na szuka�" + CRLF, ;
      CRLF + "Nie mo�na szuka� wg" + CRLF + "pola memo lub logicznego" + CRLF, ;
      CRLF + "Rekordu nie znaleziono" + CRLF, ;
      CRLF + "Zbyt wiele kolumn" + CRLF + "Raport nie mo�e zmie�ci� si� na arkuszu" + CRLF }
   acABMLabel       := { "Rekord", ;
      "Liczba rekord�w", ;
      "      (Nowy)", ;
      "    (Edycja)", ;
      "Wprowad� numer rekordu", ;
      "Szukaj", ;
      "Szukaj tekstu", ;
      "Szukaj daty", ;
      "Szukaj liczby", ;
      "Definicja Raportu", ;
      "Kolumny Raportu", ;
      "Dost�pne kolumny", ;
      "Pocz�tkowy rekord", ;
      "Ko�cowy rekord", ;
      "Raport z ", ;
      "Data:", ;
      "Pocz�tkowy rekord:", ;
      "Ko�cowy rekord:", ;
      "Sortowanie wg:", ;
      "Tak", ;
      "Nie", ;
      "Strona ", ;
      " z " }
   acABMButton      := { "Zamknij", ;
      "Nowy", ;
      "Edytuj", ;
      "Usu�", ;
      "Znajd�", ;
      "Id� do", ;
      "Raport", ;
      "Pierwszy", ;
      "Poprzedni", ;
      "Nast�pny", ;
      "Ostatni", ;
      "Zapisz", ;
      "Rezygnuj", ;
      "Dodaj", ;
      "Usu�", ;
      "Drukuj", ;
      "Zamknij" }
   acABMError       := { "EDIT, b��dna nazwa bazy", ;
      "EDIT, baza ma wi�cej ni� 16 p�l", ;
      "EDIT, tryb od�wierzania poza zakresem (zobacz raport b��d�w)", ;
      "EDIT, liczba zdarz� podstawowych poza zakresem (zobacz raport b��d�w)", ;
      "EDIT, lista zdarze� poza zakresem (zobacz raport b��d�w)" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Zamknij", ;                                          // 1
   "&Nowy", ;                                             // 2
   "&Modyfikuj", ;                                        // 3
   "&Kasuj", ;                                            // 4
   "&Znajd�", ;                                           // 5
   "&Drukuj", ;                                           // 6
   "&Porzu�", ;                                           // 7
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
   "Znajd� rekord", ;                                     // 9
   "Opcje druku", ;                                       // 10
   "Dost�pne pola", ;                                     // 11
   "Pola do druku", ;                                     // 12
   "Dost�pne drukarki", ;                                 // 13
   "Pierwszy rekord do druku", ;                          // 14
   "Ostatni rekord do druku", ;                           // 15
   "Skasuj rekord", ;                                     // 16
   "Podgl�d", ;                                           // 17
   "Poka� miniatury", ;                                   // 18
   "Stan filtru: ", ;                                     // 19
   "Filtrowane: ", ;                                      // 20
   "Opcje filtrowania", ;                                 // 21
   "Pola bazy danych", ;                                  // 22
   "Operator por�wnania", ;                               // 23
   "Warto�� filtru", ;                                    // 24
   "Wybierz pola do filtru", ;                            // 25
   "Wybierz operator por�wnania", ;                       // 26
   "R�wna si�", ;                                         // 27
   "Nie r�wna si�", ;                                     // 28
   "Wi�kszy ", ;                                          // 29
   "Mniejszy ", ;                                         // 30
   "Wi�kszy lub r�wny ", ;                                // 31
   "Mniejszy lub r�wny" }                                 // 32
   acUser           := { CRLF + "Aktywny obszar nie odnaleziony   " + CRLF + "Wybierz obszar przed wywo�aniem EDIT   " + CRLF, ;    // 1
   "Poszukiwany ci�g znak�w (dowolny tekst)", ;                                                               // 2
   "Poszukiwana warto�� (dowolna liczba)", ;                                                                  // 3
   "Wybierz dat�", ;                                                                                          // 4
   "Check for true value", ;                                                                                  // 5
   "Wprowa� warto��", ;                                                                                       // 6
   "Wybierz dowolny rekord i naci�cij OK", ;                                                                  // 7
   CRLF + "Wybra�e� opcj� kasowania rekordu   " + CRLF + "Czy jeste� pewien?    " + CRLF, ;                   // 8
   CRLF + "Brak aktywnych indeks�w   " + CRLF + "Wybierz    " + CRLF, ;                                       // 9
   CRLF + "Nie mo�na szuka� w polach typu MEMO lub LOGIC   " + CRLF, ;                                        // 10
   CRLF + "Rekord nie znaleziony   " + CRLF, ;                                                                // 11
   "Wybierz rekord kt�ry nale�y doda� do listy", ;                                                            // 12
   "Wybierz rekord kt�ry nale�y wy��czy� z listy", ;                                                          // 13
   "Wybierz drukark�", ;                                                                                      // 14
   "Kliknij na przycisk by doda� pole", ;                                                                     // 15
   "Kliknij na przycisk by odj�� pole", ;                                                                     // 16
   "Kliknij, aby wybra� pierwszy rekord do druku", ;                                                          // 17
   "Kliknij, aby wybra� ostatni rekord do druku", ;                                                           // 18
   CRLF + "Brak p�l do w��czenia   " + CRLF, ;                                                                // 19
   CRLF + "Najpierw wybierz pola do w��czenia   " + CRLF, ;                                                   // 20
   CRLF + "Brak p�l do wy��czenia   " + CRLF, ;                                                               // 21
   CRLF + "Najpierw wybierz pola do wy��czenia   " + CRLF, ;                                                  // 22
   CRLF + "Nie wybra�e� �adnych p�l   " + CRLF + "Najpierw wybierz pola do w��czenia do wydruku   " + CRLF, ; // 23
   CRLF + "Za wiele p�l   " + CRLF + "Zredukuj liczb� p�l   " + CRLF, ;                                       // 24
   CRLF + "Drukarka nie gotowa   " + CRLF, ;                                                                  // 25
   "Porz�dek wg", ;                                                                                           // 26
   "Od rekordu", ;                                                                                            // 27
   "Do rekordu", ;                                                                                            // 28
   "Tak", ;                                                                                                   // 29
   "Nie", ;                                                                                                   // 30
   "Strona:", ;                                                                                               // 31
   CRLF + "Wybierz drukark�   " + CRLF, ;                                                                     // 32
   "Filtrowanie wg", ;                                                                                        // 33
   CRLF + "Brak aktywnego filtru    " + CRLF, ;                                                               // 34
   CRLF + "Nie mo�na filtrowa� wg. p�l typu MEMO    " + CRLF, ;                                               // 35
   CRLF + "Wybierz pola dla filtru    " + CRLF, ;                                                             // 36
   CRLF + "Wybierz operator por�wnania dla filtru    " + CRLF, ;                                              // 37
   CRLF + "Wpisz dowoln� warto�� dla filtru    " + CRLF, ;                                                    // 38
   CRLF + "Brak aktywnego filtru    " + CRLF, ;                                                               // 39
   CRLF + "Deaktywowa� filtr?   " + CRLF, ;                                                                   // 40
   CRLF + "Record locked by another user" + CRLF }                                                            // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

FUNCTION ooHG_Messages_PT // Portuguese

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Voc� tem Certeza ?', ;
      'Fechar Janela', ;
      'Fechamento n�o permitido', ;
      'Programa j� est� em execu��o', ;
      'Edita', ;
      'Ok', ;
      'Cancela', ;
      'Pag.', ;
      'Erro', ;
      'Advert�ncia', ;
      'Edita Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Incluir", ;
      "Alterar", ;
      "Cancelar", ;
      "OK" }
   acBrowseError    := { "Window: ", ;
      " Erro n�o definido. Programa ser� fechado", ;
      "Erro na OOHG", ;
      "Control: ", ;
      " Of ", ;
      " N�o pronto. Programa ser� fechado", ;
      "Browse: Tipo Invalido !!!. Programa ser� fechado", ;
      "Browse: Edi��o n�o pode ser efetivada,campo n�o pertence a essa �rea. Programa ser� fechado", ;
      "Arquivo em uso n�o pode ser editado !!!", ;
      "Aguarde...", ;
      "Dado Invalido" }
   acBrowseMessages := { 'Voc� tem Certeza ?', ;
      'Apaga Registro', ;
      'Apaga Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Ser� apagado o registro atual" + CRLF + "Tem certeza?" + CRLF, ;
      CRLF + "N�o existe um �ndice ativo" + CRLF + "N�o � poss�vel realizar a busca" + CRLF, ;
      CRLF + "N�o encontrado o campo �ndice" + CRLF + "N�o � poss�vel realizar a busca" + CRLF, ;
      CRLF + "N�o � poss�vel realizar busca" + CRLF + "por campos memo ou l�gicos" + CRLF, ;
      CRLF + "Registro n�o encontrado" + CRLF, ;
      CRLF + "Inclu�das colunas em excesso" + CRLF + "A listagem completa n�o caber� na tela" + CRLF }
   acABMLabel       := { "Registro Atual", ;
      "Total Registros", ;
      "      (Novo)", ;
      "    (Editar)", ;
      "Introduza o n�mero do registro", ;
      "Buscar", ;
      "Texto a buscar", ;
      "Data a buscar", ;
      "N�mero a buscar", ;
      "Definic�o da lista", ;
      "Colunas da lista", ;
      "Colunas dispon�veis", ;
      "Registro inicial", ;
      "Registro final", ;
      "Lista de ", ;
      "Data:", ;
      "Primeiro registro:", ;
      "�ltimo registro:", ;
      "Ordenado por:", ;
      "Sim", ;
      "N�o", ;
      "P�gina ", ;
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
      "�ltimo", ;
      "Guardar", ;
      "Cancelar", ;
      "Juntar", ;
      "Sair", ;
      "Imprimir", ;
      "Fechar" }
   acABMError       := { "EDIT, N�o foi especificada a �rea", ;
      "EDIT, A �rea contem mais de 16 campos", ;
      "EDIT, Atualiza��o fora do limite (por favor comunique o erro)", ;
      "EDIT, Evento principal fora do limite (por favor comunique o erro)", ;
      "EDIT, Evento mostrado est�fora do limite (por favor comunique o erro)" }

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
   "Op��o", ;                                             // 5
   "Novo registro", ;                                     // 6
   "Modificar registro", ;                                // 7
   "Selecionar registro", ;                               // 8
   "Localizar registro", ;                                // 9
   "Op��o de impress�o", ;                                // 10
   "Campos dispon�veis", ;                                // 11
   "Campos selecionados", ;                               // 12
   "Impressoras dispon�veis", ;                           // 13
   "Primeiro registro a imprimir", ;                      // 14
   "�ltimo registro a imprimir", ;                        // 15
   "Apagar registro", ;                                   // 16
   "Visualizar impress�o", ;                              // 17
   "P�ginas em miniatura", ;                              // 18
   "Condi��o do filtro: ", ;                              // 19
   "Filtrado: ", ;                                        // 20
   "Op��es do filtro", ;                                  // 21
   "Campos de la bdd", ;                                  // 22
   "Operador de compara��o", ;                            // 23
   "Valor de compara��o", ;                               // 24
   "Selecione o campo a filtrar", ;                       // 25
   "Selecione o operador de compara��o", ;                // 26
   "Igual", ;                                             // 27
   "Diferente", ;                                         // 28
   "Maior que", ;                                         // 29
   "Menor que", ;                                         // 30
   "Maior ou igual que", ;                                // 31
   "Menor ou igual que" }                                 // 32
   acUser           := { CRLF + "N�o ha uma area ativa   " + CRLF + "Por favor selecione uma area antes de chamar a EDIT EXTENDED   " + CRLF, ;  // 1
   "Introduza o valor do campo (texto)", ;                                                                                 // 2
   "Introduza o valor do campo (num�rico)", ;                                                                              // 3
   "Selecione a data", ;                                                                                                   // 4
   "Ative o indicar para valor verdadero", ;                                                                               // 5
   "Introduza o valor do campo", ;                                                                                         // 6
   "Selecione um registro e tecle Ok", ;                                                                                   // 7
   CRLF + "Confirma apagar o registro ativo   " + CRLF + "Tem certeza?    " + CRLF, ;                                      // 8
   CRLF + "N�o ha um �ndice seleccionado    " + CRLF + "Por favor selecione un   " + CRLF, ;                               // 9
   CRLF + "N�o se pode realizar busca por campos tipo memo ou l�gico   " + CRLF, ;                                         // 10
   CRLF + "Registro n�o encontrado   " + CRLF, ;                                                                           // 11
   "Selecione o campo a incluir na lista", ;                                                                               // 12
   "Selecione o campo a excluir da lista", ;                                                                               // 13
   "Selecione a impressora", ;                                                                                             // 14
   "Precione o bot�o para incluir o campo", ;                                                                              // 15
   "Precione o bot�o para excluir o campo", ;                                                                              // 16
   "Precione o bot�o para selecionar o primeiro registro a imprimir", ;                                                    // 17
   "Precione o bot�o para selecionar o �ltimo registro a imprimir", ;                                                      // 18
   CRLF + "Foram incluidos todos os campos   " + CRLF, ;                                                                   // 19
   CRLF + "Primeiro seleccione o campo a incluir   " + CRLF, ;                                                             // 20
   CRLF + "N�o ha campos para excluir   " + CRLF, ;                                                                        // 21
   CRLF + "Primeiro selecione o campo a excluir   " + CRLF, ;                                                              // 22
   CRLF + "N�o ha selecionado nenhum campo   " + CRLF, ;                                                                   // 23
   CRLF + "A lista n�o cabe na p�gina   " + CRLF + "Reduza o n�mero de campos   " + CRLF, ;                                // 24
   CRLF + "A impressora n�o est� dispon�vel   " + CRLF, ;                                                                  // 25
   "Ordenado por", ;                                                                                                       // 26
   "Do registro", ;                                                                                                        // 27
   "At� registro", ;                                                                                                       // 28
   "Sim", ;                                                                                                                // 29
   "N�o", ;                                                                                                                // 30
   "P�gina:", ;                                                                                                            // 31
   CRLF + "Por favor selecione uma impressora   " + CRLF, ;                                                                // 32
   "Filtrado por", ;                                                                                                       // 33
   CRLF + "N�o ha um filtro ativo    " + CRLF, ;                                                                           // 34
   CRLF + "N�o se pode filtrar por campos memo    " + CRLF, ;                                                              // 35
   CRLF + "Selecione o campo a filtrar    " + CRLF, ;                                                                      // 36
   CRLF + "Selecione o operador de compara��o    " + CRLF, ;                                                               // 37
   CRLF + "Introduza o valor do filtro    " + CRLF, ;                                                                      // 38
   CRLF + "N�o ha nenhum filtro ativo    " + CRLF, ;                                                                       // 39
   CRLF + "Eliminar o filtro ativo?   " + CRLF, ;                                                                          // 40
   CRLF + "Registro bloqueado por outro usu�rio" + CRLF }                                                                  // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

FUNCTION ooHG_Messages_RU866 // Russian

   RETURN ooHG_Messages_RUWIN()

FUNCTION ooHG_Messages_RUKOI8 // Russian

   RETURN ooHG_Messages_RUWIN()

FUNCTION ooHG_Messages_RUWIN // Russian

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { '�� ������� ?', ;
      '������� ����', ;
      '�������� �� ��������', ;
      '��������� ��� ��������', ;
      '��������', ;
      '��', ;
      '������', ;
      'Pag.', ;
      '������', ;
      '��������������', ;
      '�������� Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "��������", ;
      "��������", ;
      "������", ;
      "OK" }
   acBrowseError    := { "����: ", ;
      " �� ����������. ��������� ��������", ;
      "OOHG ������", ;
      "������� ���������: ", ;
      " �� ", ;
      " ��� ���������. ��������� ��������", ;
      "Browse: ����� ��� �� �������������. ��������� ��������", ;
      "Browse: Append ����� �� ����� ���� ����������� � ����� �� ������ ������� �������. ��������� ��������", ;
      "������ ������ ������������ ������ �������������", ;
      "��������������", ;
      "������� ������������ ������" }
   acBrowseMessages := { '�� ������� ?', ;
      '������� ������', ;
      'Delete Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "�������� ������." + CRLF + "�� ������� ?" + CRLF, ;
      CRLF + "����������� ��������� ����" + CRLF + "����� ����������" + CRLF, ;
      CRLF + "����������� ��������� ����" + CRLF + "����� ����������" + CRLF, ;
      CRLF + "����� ���������� ��" + CRLF + "���� ��� ���������� �����" + CRLF, ;
      CRLF + "������ �� �������" + CRLF, ;
      CRLF + "������� ����� �������" + CRLF + "����� �� ���������� �� �����" + CRLF }
   acABMLabel       := { "������", ;
      "����� �������", ;
      "     (�����)", ;
      "  (��������)", ;
      "������� ����� ������", ;
      "�����", ;
      "����� �����", ;
      "����� ����", ;
      "����� �����", ;
      "��������� ������", ;
      "������� ������", ;
      "��������� �������", ;
      "��������� ������", ;
      "�������� ������", ;
      "����� ��� ", ;
      "����:", ;
      "������ ������:", ;
      "�������� ������:", ;
      "����������� ��:", ;
      "��", ;
      "���", ;
      "�������� ", ;
      " �� " }
   acABMButton      := { "�������", ;
      "�����", ;
      "��������", ;
      "�������", ;
      "�����", ;
      "�������", ;
      "�����", ;
      "������", ;
      "�����", ;
      "������", ;
      "���������", ;
      "���������", ;
      "������", ;
      "��������", ;
      "�������", ;
      "������", ;
      "�������" }
   acABMError       := { "EDIT, �� ������� ��� ������� �������", ;
      "EDIT, ����������� ������ �� 16 �����", ;
      "EDIT, ����� ���������� ��� ��������� (�������� �� ������)", ;
      "EDIT, ����� ������� ��� ��������� (�������� �� ������)", ;
      "EDIT, ����� ������� �������� ��� ��������� (�������� �� ������)" }

   // EDIT EXTENDED MESSAGES
   acButton         := {}
   acLabel          := {}
   acUser           := {}

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

FUNCTION ooHG_Messages_ES // Spanish

   RETURN ooHG_Messages_ESWIN()

FUNCTION ooHG_Messages_ESWIN // Spanish

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { '� Est� seguro ?', ;
      'Cerrar Ventana', ;
      'Operaci�n no permitida', ;
      'El programa ya est� ejecut�ndose', ;
      'Editar', ;
      'Aceptar', ;
      'Cancelar', ;
      'Pag.', ;
      'Error', ;
      'Peligro', ;
      'Editar Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Agregar", ;
      "Editar", ;
      "Cancelar", ;
      "Aceptar" }
   acBrowseError    := { "Window: ", ;
      " no est� definida. Programa Terminado.", ;
      "OOHG Error", ;
      "Control: ", ;
      " De ", ;
      " ya definido. Programa Terminado.", ;
      "Browse: Tipo no permitido. Programa Terminado.", ;
      "Browse: La cl�usula APPEND no puede ser usada con campos no pertenecientes al area del BROWSE. Programa Terminado.", ;
      "El registro est� siendo editado por otro usuario", ;
      "Peligro", ;
      "Entrada no v�lida" }
   acBrowseMessages := { '� Est� Seguro ?', ;
      'Eliminar Registro', ;
      'Eliminar Item' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Va a eliminar el registro actual" + CRLF + "� Est� seguro ?" + CRLF, ;
      CRLF + "No hay un �ndice activo" + CRLF + "No se puede realizar la b�squeda" + CRLF, ;
      CRLF + "No se encuentra el campo �ndice" + CRLF + "No se puede realizar la b�squeda" + CRLF, ;
      CRLF + "No se pueden realizar b�squedas" + CRLF + "por campos memo o l�gico" + CRLF, ;
      CRLF + "Registro no encontrado" + CRLF, ;
      CRLF + "Ha incl�do demasiadas columnas" + CRLF + "El listado no cabe en la hoja" + CRLF }
   acABMLabel       := { "Registro Actual", ;
      "Registros Totales", ;
      "     (Nuevo)", ;
      "    (Editar)", ;
      "Introduzca el n�mero de registro", ;
      "Buscar", ;
      "Texto a buscar", ;
      "Fecha a buscar", ;
      "N�mero a buscar", ;
      "Definici�n del listado", ;
      "Columnas del listado", ;
      "Columnas disponibles", ;
      "Registro inicial", ;
      "Registro final", ;
      "Listado de ", ;
      "Fecha:", ;
      "Primer registro:", ;
      "Ultimo registro:", ;
      "Ordenado por:", ;
      "Si", ;
      "No", ;
      "P�gina ", ;
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
      "�ltimo", ;
      "Guardar", ;
      "Cancelar", ;
      "A�adir", ;
      "Quitar", ;
      "Imprimir", ;
      "Cerrar" }
   acABMError       := { "EDIT, No se ha especificado el area", ;
      "EDIT, El area contiene m�s de 16 campos", ;
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
   "Opciones de impresi�n", ;                             // 10
   "Campos disponibles", ;                                // 11
   "Campos del listado", ;                                // 12
   "Impresoras disponibles", ;                            // 13
   "Primer registro a imprimir", ;                        // 14
   "Ultimo registro a imprimir", ;                        // 15
   "Borrar registro", ;                                   // 16
   "Vista previa", ;                                      // 17
   "P�ginas en miniatura", ;                              // 18
   "Condici�n del filtro: ", ;                            // 19
   "Filtrado: ", ;                                        // 20
   "Opciones de filtrado", ;                              // 21
   "Campos de la bdd", ;                                  // 22
   "Operador de comparaci�n", ;                           // 23
   "Valor de comparaci�n", ;                              // 24
   "Seleccione el campo a filtrar", ;                     // 25
   "Seleccione el operador de comparaci�n", ;             // 26
   "Igual", ;                                             // 27
   "Distinto", ;                                          // 28
   "Mayor que", ;                                         // 29
   "Menor que", ;                                         // 30
   "Mayor o igual que", ;                                 // 31
   "Menor o igual que" }                                  // 32
   acUser           := { CRLF + "No hay un area activa   " + CRLF + "Por favor seleccione un area antes de llamar a EDIT EXTENDED   " + CRLF, ;  // 1
   "Introduzca el valor del campo (texto)", ;                                                                              // 2
   "Introduzca el valor del campo (num�rico)", ;                                                                           // 3
   "Seleccione la fecha", ;                                                                                                // 4
   "Active la casilla para indicar un valor verdadero", ;                                                                  // 5
   "Introduzca el valor del campo", ;                                                                                      // 6
   "Seleccione un registro y pulse aceptar", ;                                                                             // 7
   CRLF + "Se dispone a borrar el registro activo   " + CRLF + "�Est� seguro?    " + CRLF, ;                               // 8
   CRLF + "No se ha seleccionado un indice   " + CRLF + "Por favor seleccione uno   " + CRLF, ;                            // 9
   CRLF + "No se pueden realizar b�squedas por campos tipo memo o l�gico   " + CRLF, ;                                     // 10
   CRLF + "Registro no encontrado   " + CRLF, ;                                                                            // 11
   "Seleccione el campo a incluir en el listado", ;                                                                        // 12
   "Seleccione el campo a excluir del listado", ;                                                                          // 13
   "Seleccione la impresora", ;                                                                                            // 14
   "Pulse el bot�n para incluir el campo", ;                                                                               // 15
   "Pulse el bot�n para excluir el campo", ;                                                                               // 16
   "Pulse el bot�n para seleccionar el primer registro a imprimir", ;                                                      // 17
   "Pulse el bot�n para seleccionar el �ltimo registro a imprimir", ;                                                      // 18
   CRLF + "Ha incluido todos los campos   " + CRLF, ;                                                                      // 19
   CRLF + "Primero seleccione el campo a incluir   " + CRLF, ;                                                             // 20
   CRLF + "No hay campos para excluir   " + CRLF, ;                                                                        // 21
   CRLF + "Primero seleccione el campo a excluir   " + CRLF, ;                                                             // 22
   CRLF + "No ha seleccionado ning�n campo   " + CRLF, ;                                                                   // 23
   CRLF + "El listado no cabe en la p�gina   " + CRLF + "Reduzca el numero de campos   " + CRLF, ;                         // 24
   CRLF + "La impresora no est� disponible   " + CRLF, ;                                                                   // 25
   "Ordenado por", ;                                                                                                       // 26
   "Del registro", ;                                                                                                       // 27
   "Al registro", ;                                                                                                        // 28
   "S�", ;                                                                                                                 // 29
   "No", ;                                                                                                                 // 30
   "P�gina:", ;                                                                                                            // 31
   CRLF + "Por favor seleccione una impresora   " + CRLF, ;                                                                // 32
   "Filtrado por", ;                                                                                                       // 33
   CRLF + "No hay un filtro activo    " + CRLF, ;                                                                          // 34
   CRLF + "No se puede filtrar por campos memo    " + CRLF, ;                                                              // 35
   CRLF + "Seleccione el campo a filtrar    " + CRLF, ;                                                                    // 36
   CRLF + "Seleccione el operador de comparaci�n    " + CRLF, ;                                                            // 37
   CRLF + "Introduzca el valor del filtro    " + CRLF, ;                                                                   // 38
   CRLF + "No hay ning�n filtro activo    " + CRLF, ;                                                                      // 39
   CRLF + "�Eliminar el filtro activo?   " + CRLF, ;                                                                       // 40
   CRLF + "Registro bloqueado por otro usuario    " + CRLF }                                                               // 41

   // PRINT MESSAGES
   acPrint          := { "Vista previa de impresi�n pendiente, ci�rrela primero", ;
      "Impresi�n ooHG", ;
      "Comando auxiliar de impresi�n", ;
      " IMPRESO OK !!!", ;
      "Los par�metros pasados a la funci�n no son v�lidos !!!", ;
      "Fracas� la llamada a WinAPI OpenPrinter() !!!", ;
      "Fracas� la llamada a WinAPI StartDocPrinter() !!!", ;
      "Fracas� la llamada a WinAPI StartPagePrinter() !!!", ;
      "Fracas� la llamada a WinAPI malloc() !!!", ;
      " NO ENCONTRADO !!!", ;
      "No se detect� impresora !!!", ;
      "Error", ;
      "El puerto no es v�lido !!!", ;
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
      "Modo de impresi�n: ", ;
      "Buscar", ;
      "Buscar", ;
      "Sig. b�squeda", ;
      "Sig. b�squeda", ;
      'Texto: ', ;
      'Cadena a buscar', ;
      "B�squeda finalizada.", ;
      "Informaci�n", ;
      'No se detect� Excel !!!', ;
      "La extensi�n XLS no est� asociada !!!", ;
      "Archivo guardado en: ", ;
      "La extensi�n HTML no est� asociada !!!", ;
      "La extensi�n RTF no est� asociada !!!", ;
      "La extensi�n CSV no est� asociada !!!", ;
      "La extensi�n PDF no est� asociada !!!", ;
      "La extensi�n ODT no est� asociada !!!", ;
      'Los c�digos de barra requieren una cadena !!!', ;
      'Los modos v�lidos de c�digos de barra c128 son A, B or C !!!', ;
      "No se detect� OpenCalc !!!", ;
      "No se pudo guardar el archivo: " }

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

FUNCTION ooHG_Messages_FI // Finnish

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Oletko varma ?', ;
      'Sulje ikkuna', ;
      'Sulkeminen ei sallittu', ;
      'Ohjelma on jo k�ynniss�', ;
      'Korjaa', ;
      'Ok', ;
      'Keskeyt�', ;
      'Sivu.', ;
      'Virhe', ;
      'Varoitus', ;
      'Korjaa Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Lis��", ;
      "Korjaa", ;
      " Keskeyt�", ;
      " OK" }
   acBrowseError    := { "Ikkuna: ", ;
      " m��rittelem�t�n. Ohjelma lopetettu", ;
      "OOHG Virhe", ;
      "Kontrolli: ", ;
      " / ", ;
      " On jo m��ritelty. Ohjelma lopetettu", ;
      "Browse: Virheellinen tyyppi. Ohjelma lopetettu", ;
      "Browse: Et voi lis�t� kentti� jotka eiv�t ole BROWSEN m��rityksess�. Ohjelma lopetettu", ;
      "Toinen k�ytt�j� korjaa juuri tietuetta", ;
      "Varoitus", ;
      "Virheellinen arvo" }
   acBrowseMessages := { 'Oletko varma ?', ;
      'Poista Tietue', ;
      'Poista Rivi' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Poista tietue" + CRLF + "Oletko varma?" + CRLF, ;
      CRLF + "Indeksi tiedosto puuttuu" + CRLF + "En voihakea" + CRLF, ;
      CRLF + "Indeksikentt� ei l�ydy" + CRLF + "En voihakea" + CRLF, ;
      CRLF + "En voi hakea memo" + CRLF + "tai loogisen kent�n mukaan" + CRLF, ;
      CRLF + "Tietue ei l�ydy" + CRLF, ;
      CRLF + "Liian monta saraketta" + CRLF + "raportti ei mahdu sivulle" + CRLF }
   acABMLabel       := { "Tietue", ;
      "Tietue lukum��r�", ;
      "       (Uusi)", ;
      "      (Korjaa)", ;
      "Anna tietue numero", ;
      "Hae", ;
      "Hae teksti", ;
      "Hae p�iv�ys", ;
      "Hae numero", ;
      "Raportti m��ritys", ;
      "Raportti sarake", ;
      "Sallitut sarakkeet", ;
      "Alku tietue", ;
      "Loppu tietue", ;
      "Raportti ", ;
      "Pvm:", ;
      "Alku tietue:", ;
      "Loppu tietue:", ;
      "Lajittelu:", ;
      "Kyll�", ;
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
      "Ensimm�inen", ;
      "Edellinen", ;
      "Seuraava", ;
      "Viimeinen", ;
      "Tallenna", ;
      "Keskeyt�", ;
      "Lis��", ;
      "Poista", ;
      "Tulosta", ;
      "Sulje" }
   acABMError       := { "EDIT, ty�alue puuttuu", ;
      "EDIT, ty�alueella yli 16 kentt��", ;
      "EDIT, p�ivitysalue ylitys (raportoi virhe)", ;
      "EDIT, tapahtuma numero ylitys (raportoi virhe)", ;
      "EDIT, lista tapahtuma numero ylitys (raportoi virhe)"}

   // EDIT EXTENDED MESSAGES
   acButton         := { " Sulje", ;                                            // 1
   " Uusi", ;                                             // 2
   " Muuta", ;                                            // 3
   " Poista", ;                                           // 4
   " Hae", ;                                              // 5
   " Tulosta", ;                                          // 6
   " Keskeyt�", ;                                         // 7
   " Ok", ;                                               // 8
   " Kopioi", ;                                           // 9
   " Aktivoi Filtteri", ;                                 // 10
   " Deaktivoi Filtteri" }                                // 11
   acLabel          := { "Ei mit��n", ;                                         // 1
   "Tietue", ;                                            // 2
   "Yhteens�", ;                                          // 3
   "Aktiivinen lajittelu", ;                              // 4
   "Optiot", ;                                            // 5
   "Uusi tietue", ;                                       // 6
   "Muuta tietue", ;                                      // 7
   "Valitse tietue", ;                                    // 8
   "Hae tietue", ;                                        // 9
   "Tulostus optiot", ;                                   // 10
   "Valittavat kent�t", ;                                 // 11
   "Tulostettavat kent�t", ;                              // 12
   "Valittavat tulostimet", ;                             // 13
   "Ensim. tulostuttava tietue", ;                        // 14
   "Viim. tulostettava tietue", ;                         // 15
   "Poista tietue", ;                                     // 16
   "Esikatselu", ;                                        // 17
   "N�yt� sivujen miniatyyrit", ;                         // 18
   "Suodin ehto: ", ;                                     // 19
   "Suodatettu: ", ;                                      // 20
   "Suodatus Optiot", ;                                   // 21
   "Tietokanta kent�t", ;                                 // 22
   "Vertailu operaattori", ;                              // 23
   "Suodatus arvo", ;                                     // 24
   "Valitse suodatus kentt�", ;                           // 25
   "Valitse vertailu operaattori", ;                      // 26
   "Yht� kuin", ;                                         // 27
   "Erisuuri kuin", ;                                     // 28
   "Isompi kuin", ;                                       // 29
   "Pienempi kuin", ;                                     // 30
   "Isompi tai sama kuin", ;                              // 31
   "Pienempi tai sama kuin" }                             // 32
   acUser           := { CRLF + "Ty�alue ei l�ydy.   " + CRLF + "Valitse ty�aluetta ennenkun kutsut Edit  " + CRLF, ;  // 1
   "Anna kentt� arvo (teksti�)", ;                                                               // 2
   "Anna kentt� arvo (numeerinen)", ;                                                            // 3
   "Valitse p�iv�ys", ;                                                                          // 4
   "Tarkista tosi arvo", ;                                                                       // 5
   "Anna kentt� arvo", ;                                                                         // 6
   "Valitse joku tietue ja paina OK", ;                                                          // 7
   CRLF + "Olet poistamassa aktiivinen tietue   " + CRLF + "Oletko varma?    " + CRLF, ;         // 8
   CRLF + "Ei aktiivista lajittelua   " + CRLF + "Valitse lajittelu   " + CRLF, ;                // 9
   CRLF + "En voi hakea memo tai loogiseten kenttien perusteella  " + CRLF, ;                    // 10
   CRLF + "Tietue ei l�ydy   " + CRLF, ;                                                         // 11
   "Valitse listaan lis�tt�v�t kent�t", ;                                                        // 12
   "Valitse EI lis�tt�v�t kent�t", ;                                                             // 13
   "Valitse tulostin", ;                                                                         // 14
   "Paina n�pp�in lis��t�ksesi kentt�", ;                                                        // 15
   "Paina n�pp�in poistaaksesi kentt�", ;                                                        // 16
   "Paina n�pp�in valittaaksesi ensimm�inen tulostettava tietue", ;                              // 17
   "Paina n�pp�in valittaaksesi viimeinen tulostettava tietue", ;                                // 18
   CRLF + "Ei lis�� kentti�   " + CRLF, ;                                                        // 19
   CRLF + "Valitse ensin lis�tt�v� kentt�   " + CRLF, ;                                          // 20
   CRLF + "EI Lis�� ohitettavia kentti�   " + CRLF, ;                                            // 21
   CRLF + "Valitse ensin ohitettava kentt�   " + CRLF, ;                                         // 22
   CRLF + "Et valinnut kentti�   " + CRLF + "Valitse tulosteen kent�t   " + CRLF, ;              // 23
   CRLF + "Liikaa kentti�   " + CRLF + "V�henn� kentt� lukum��r�   " + CRLF, ;                   // 24
   CRLF + "Tulostin ei valmiina   " + CRLF, ;                                                    // 25
   "Lajittelu", ;                                                                                // 26
   "Tietueesta", ;                                                                               // 27
   "Tietueeseen", ;                                                                              // 28
   "Kyll�", ;                                                                                    // 29
   "EI", ;                                                                                       // 30
   "Sivu:", ;                                                                                    // 31
   CRLF + "Valitse tulostin   " + CRLF, ;                                                        // 32
   "Lajittelu", ;                                                                                // 33
   CRLF + "Aktiivinen suodin olemassa    " + CRLF, ;                                             // 34
   CRLF + "En voi suodattaa memo kentti�    " + CRLF, ;                                          // 35
   CRLF + "Valitse suodattava kentt�    " + CRLF, ;                                              // 36
   CRLF + "Valitse suodattava operaattori    " + CRLF, ;                                         // 37
   CRLF + "Anna suodatusarvo    " + CRLF, ;                                                      // 38
   CRLF + "Ei aktiivisia suotimia    " + CRLF, ;                                                 // 39
   CRLF + "Poista suodin?   " + CRLF, ;                                                          // 40
   CRLF + "Tietue lukittu    " + CRLF }                                                          // 41

   // PRINT MESSAGES
   acPrint          := {}

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }

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
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Toevoegen", ;
      "Bewerken", ;
      "&Annuleer", ;
      "&OK" }
   acBrowseError    := { "Scherm: ", ;
      " is niet gedefinieerd. Programma be�indigd", ;
      "OOHG fout", ;
      "Control: ", ;
      " Van ", ;
      " Is al gedefinieerd. Programma be�indigd", ;
      "Browse: Type niet toegestaan. Programma be�indigd", ;
      "Browse: Toevoegen-methode kan niet worden gebruikt voor velden die niet bij het Browse werkgebied behoren. Programma be�indigd", ;
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
      CRLF + "Te veel rijen" + CRLF + "Het rapport past niet op het papier" + CRLF }
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

FUNCTION ooHG_Messages_SLISO // Slovenian

   RETURN ooHG_Messages_SLWIN()

FUNCTION ooHG_Messages_SL852 // Slovenian

   RETURN ooHG_Messages_SLWIN()

FUNCTION ooHG_Messages_SL437 // Slovenian

   RETURN ooHG_Messages_SLWIN()

FUNCTION ooHG_Messages_SLWIN // Slovenian

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Ste prepri�ani ?', ;
      'Zapri okno', ;
      'Zapiranje ni dovoljeno', ;
      'Program je �e zagnan', ;
      'Popravi', ;
      'V redu', ;
      'Prekini', ;
      'Pag.', ;
      'Napaka', ;
      'Opozorilo', ;
      'Popravi Memo', ;
      "ooHG can't determine cell type for INPLACE edit." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Dodaj", ;
      "Popravi", ;
      "Prekini", ;
      "V redu" }
   acBrowseError    := { "Window: ", ;
      " not defined. Program terminated.", ;
      "OOHG Error", ;
      "Control: ", ;
      " Of ", ;
      " Already defined. Program terminated.", ;
      "Type Not Allowed. Program terminated.", ;
      "False WorkArea. Program terminated.", ;
      "Zapis ureja drug uporabnik", ;
      "Opozorilo", ;
      "Narobe vnos" }
   acBrowseMessages := { 'Ste prepri�ani ?', ;
      'Bri�i zapis', ;
      'Bri�i Vrstico' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Bri�i vrstico" + CRLF + "Ste prepri�ani ?" + CRLF, ;
      CRLF + "Manjka indeksna datoteka" + CRLF + "Ne morem iskati" + CRLF, ;
      CRLF + "Ne najdem indeksnega polja" + CRLF + "Ne morem iskati" + CRLF, ;
      CRLF + "Ne morem iskati po" + CRLF + "memo ali logi�nih poljih" + CRLF, ;
      CRLF + "Ne najdem vrstice" + CRLF, ;
      CRLF + "Preve� kolon" + CRLF + "Poro�ilo ne gre na list" + CRLF }
   acABMLabel       := { "Vrstica", ;
      "�tevilo vrstic", ;
      "       (Nova)", ;
      "      (Popravi)", ;
      "Vnesi �tevilko vrstice", ;
      "Poi��i", ;
      "Besedilo za iskanje", ;
      "Datum za iskanje", ;
      "�tevilka za iskanje", ;
      "Parametri poro�ila", ;
      "Kolon v poro�ilu", ;
      "Kolon na razpolago", ;
      "Za�etna vrstica", ;
      "Kon�na vrstica", ;
      "Pporo�ilo za ", ;
      "Datum:", ;
      "Za�etna vrstica:", ;
      "Kon�na vrstica:", ;
      "Urejeno po:", ;
      "Ja", ;
      "Ne", ;
      "Stran ", ;
      " od " }
   acABMButton      := { "Zapri", ;
      "Nova", ;
      "Uredi", ;
      "Bri�i", ;
      "Poi��i", ;
      "Pojdi na", ;
      "Poro�ilo", ;
      "Prva", ;
      "Prej�nja", ;
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
   "&Bri�i", ;                                            // 4
   "&Poi��i", ;                                           // 5
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
   "Mo�nosti", ;                                          // 5
   "Nova vrstica", ;                                      // 6
   "Spreminjaj vrstico", ;                                // 7
   "Ozna�i vrstico", ;                                    // 8
   "Najdi vrstico", ;                                     // 9
   "Mo�nosti tiskanja", ;                                 // 10
   "Polja na razpolago", ;                                // 11
   "Polja za tiskanje", ;                                 // 12
   "Tiskalniki na razpolago", ;                           // 13
   "Prva vrstica za tiskanje", ;                          // 14
   "Zadnja vrstica za tiskanje", ;                        // 15
   "Bri�i vrstico", ;                                     // 16
   "Pregled", ;                                           // 17
   "Mini pregled strani", ;                               // 18
   "Pogoj za filter: ", ;                                 // 19
   "Filtrirano: ", ;                                      // 20
   "Mo�nosti filtra", ;                                   // 21
   "Polja v datoteki", ;                                  // 22
   "Operator za primerjavo", ;                            // 23
   "Vrednost filtra", ;                                   // 24
   "Izberi polje za filter", ;                            // 25
   "Izberi operator za primerjavo", ;                     // 26
   "Enako", ;                                             // 27
   "Neenako", ;                                           // 28
   "Ve�je od", ;                                          // 29
   "Manj�e od", ;                                         // 30
   "Ve�je ali enako od", ;                                // 31
   "Manj�e ali enako od" }                                // 32
   acUser           := { CRLF + "Can't find an active area.   " + CRLF + "Please select any area before call EDIT   " + CRLF, ;  // 1
   "Vnesi vrednost (tekst)", ;                                                                             // 2
   "Vnesi vrednost (�tevilka)", ;                                                                          // 3
   "Izberi datum", ;                                                                                       // 4
   "Ozna�i za logi�ni DA", ;                                                                               // 5
   "Vnesi vrednost", ;                                                                                     // 6
   "Izberi vrstico in pritisni <V redu>", ;                                                                // 7
   CRLF + "Pobrisali boste trenutno vrstico   " + CRLF + "Ste prepri�ani?    " + CRLF, ;                   // 8
   CRLF + "Ni aktivnega indeksa   " + CRLF + "Prosimo, izberite ga   " + CRLF, ;                           // 9
   CRLF + "Ne morem iskati po logi�nih oz. memo poljih   " + CRLF, ;                                       // 10
   CRLF + "Ne najdem vrstice   " + CRLF, ;                                                                 // 11
   "Izberite polje, ki bo vklju�eno na listo", ;                                                           // 12
   "Izberite polje, ki NI vklju�eno na listo", ;                                                           // 13
   "Izberite tisklanik", ;                                                                                 // 14
   "Pritisnite gumb za vklju�itev polja", ;                                                                // 15
   "Pritisnite gumb za izklju�itev polja", ;                                                               // 16
   "Pritisnite gumb za izbor prve vrstice za tiskanje", ;                                                  // 17
   "Pritisnite gumb za izbor zadnje vrstice za tiskanje", ;                                                // 18
   CRLF + "Ni ve� polj za dodajanje   " + CRLF, ;                                                          // 19
   CRLF + "Najprej izberite ppolje za vklju�itev   " + CRLF, ;                                             // 20
   CRLF + "Ni ve� polj za izklju�itev   " + CRLF, ;                                                        // 21
   CRLF + "Najprej izberite polje za izklju�itev   " + CRLF, ;                                             // 22
   CRLF + "Niste izbrali nobenega polja   " + CRLF + "Prosom, izberite polje za tiskalnje   " + CRLF, ;    // 23
   CRLF + "Preve� polj   " + CRLF + "Zmanj�ajte �tevilo polj   " + CRLF, ;                                 // 24
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

FUNCTION ooHG_Messages_TR

   LOCAL acMisc
   LOCAL acBrowseButton, acBrowseError, acBrowseMessages
   LOCAL acABMUser, acABMLabel, acABMButton, acABMError
   LOCAL acButton, acLabel, acUser, acPrint

   // MISC MESSAGES
   acMisc           := { 'Eminmisiniz ?', ;
      'Pencereyi kapat', ;
      'Kapatma izni yok', ;
      'Program halen �al���yor', ;
      'D�zelt', ;
      'Tamam', ;
      '�ptal', ;
      'Sayf.', ;
      'Hata', ;
      'Dikkat', ;
      'Not d�zelt', ;
      "H�cre tipi d�zenlemek i�in uygun de�il." }

   // BROWSE MESSAGES
   acBrowseButton   := { "Yeni Giri�", ;
      "D�zelt", ;
      "&�ptal", ;
      "&Tamam" }
   acBrowseError    := { "Pencere: ", ;
      " Tan�mlanmam��. Program sonland�.", ;
      "Hata ", ;
      "Control: ", ;
      "   ", ;
      " �nceden tan�ml�. Program sonland�.", ;
      "Browse: Tip tan�ml� de�il. Program sonland�.", ;
      "Browse: Giri� modunda g�zatma i�lemi uygun de�il. Program sonland�.", ;
      "Kayd� di�er kullan�c� d�zenliyor", ;
      "Dikkat", ;
      "Giri� tan�mlanmam��" }
   acBrowseMessages := { 'Eminmisiniz ?', ;
      'Kay�t Sil', ;
      '��eyi Sil' }

   // EDIT MESSAGES
   acABMUser        := { CRLF + "Kay�t sil" + CRLF + "Eminmisiniz ?" + CRLF, ;
      CRLF + "Index dosyas� kay�p" + CRLF + "Arama i�lemi yap�lam�yor" + CRLF, ;
      CRLF + "Index dosyas� bulunamad�" + CRLF + "Arama i�lemi yap�lam�yor" + CRLF, ;
      CRLF + "Arama yap�lamaz" + CRLF + "Not ve mant�ksal alanlarda" + CRLF, ;
      CRLF + "Kay�t bulunamad�" + CRLF, ;
      CRLF + "kolon say�s� fazla" + CRLF + " Rapor sayfas�na s��m�yor" + CRLF }
   acABMLabel       := { "Kay�t", ;
      "Kay�t say�s�", ;
      "       Yeni", ;
      "      D�zelt", ;
      "Kay�t numaras� gir", ;
      "Bul", ;
      "Text ara", ;
      "Tarih ara", ;
      "Say� ara", ;
      "Rapor tan�mlar�", ;
      "Rapor kolonlar�", ;
      "Kullan�labilir kolonlar", ;
      "Tan�ml� kay�t", ;
      "Son kay�t", ;
      "Rapor ", ;
      "Tarih.", ;
      "Tan�ml� kay�t", ;
      "Son kay�t", ;
      "S�ralama:", ;
      "Evet", ;
      "Hay�r", ;
      "Sayfa ", ;
      "  " }
   acABMButton      := { "Kapat", ;
      "Yeni", ;
      "D�zelt", ;
      "Sil", ;
      "Bul", ;
      "Git", ;
      "Rapor", ;
      "�lk", ;
      "�nceki", ;
      "Sonraki", ;
      "Son", ;
      "Kaydet", ;
      "�ptal", ;
      "Ekle", ;
      "Sil", ;
      "Yazd�r", ;
      "Kapat" }
   acABMError       := { "D�zelt, Dosya ad� tan�mlanmam�� veya kay�p", ;
      "D�zelt, Bu dosyan�n alan say�s� 16 dan fazla ", ;
      "D�zelt, Aral��� a�m�� durumdas�n�z", ;
      "D�zelt, Numara aral��� a�m��", ;
      "D�zelt, Listelemede numara a��lm��" }

   // EDIT EXTENDED MESSAGES
   acButton         := { "&Kapat", ;                                                                                                         // 1
   "&Yeni", ;                                                                                                          // 2
   "&D�zelt", ;                                                                                                        // 3
   "&Sil", ;                                                                                                           // 4
   "&Bul", ;                                                                                                           // 5
   "&Yazd�r", ;                                                                                                        // 6
   "&�ptal", ;                                                                                                         // 7
   "&Tamam", ;                                                                                                         // 8
   "&Kopya", ;                                                                                                         // 9
   "&Filtre Aktif", ;                                                                                                  // 10
   "&Filtre Pasif" }                                                                                                   // 11
   acLabel          := { "Bo�", ;                                                                                                            // 1
   "Kay�t", ;                                                                                                          // 2
   "Toplam", ;                                                                                                         // 3
   "Aktif s�ralama", ;                                                                                                 // 4
   "i�lemler", ;                                                                                                       // 5
   "Yeni Kay�t", ;                                                                                                     // 6
   "Kay�t d�zelt", ;                                                                                                   // 7
   "Kay�t se�", ;                                                                                                      // 8
   "Kay�t bul", ;                                                                                                      // 9
   "Yaz�c� i�lemleri", ;                                                                                               // 10
   "Kullan�lbilir alanlar", ;                                                                                          // 11
   "Yaz�c�da alanlar�", ;                                                                                              // 12
   "Kullan�labilir Yaz�c�lar", ;                                                                                       // 13
   "Yaz�lacak ilk kay�t", ;                                                                                            // 14
   "Yaz�lacak son kay�t", ;                                                                                            // 15
   "Kay�t sil", ;                                                                                                      // 16
   "�n izleme", ;                                                                                                      // 17
   "Sayfa g�r�nt�c�k", ;                                                                                               // 18
   "Filtre ifadesi: ", ;                                                                                               // 19
   "Filtrelendi: ", ;                                                                                                  // 20
   "Filtre ��lemleri", ;                                                                                               // 21
   "Database alanlar�", ;                                                                                              // 22
   "Kar��la�t�rma i�areleri", ;                                                                                        // 23
   "Filtre de�i�keni", ;                                                                                               // 24
   "Filtre alan se�imi", ;                                                                                             // 25
   "Kar��la�t�rma ��lem se�imi", ;                                                                                     // 26
   "E�it", ;                                                                                                           // 27
   "E�it de�il", ;                                                                                                     // 28
   "den B�y�k", ;                                                                                                      // 29
   "den K���k", ;                                                                                                      // 30
   "B�y�k veya e�it", ;                                                                                                // 31
   "K���k veya e�it" }                                                                                                 // 32
   acUser           := { CRLF + "Aktif database bulunamad�.   " + CRLF + "L�tfen se�iminizi d�zeltin   " + CRLF, ;               // 1
   "alan text tan�ml�", ;                                                                                  // 2
   "alan say�sal tan�ml�", ;                                                                               // 3
   "Tarih se�", ;                                                                                          // 4
   "Do�ru de�i�keni i�aretleyin", ;                                                                        // 5
   "Alan de�i�keni girin", ;                                                                               // 6
   "Kay�t se�imi yaparak onaylay�n", ;                                                                     // 7
   CRLF + "Aktif kayd� siliyorsunuz.  " + CRLF + "Eminmisiniz ?    " + CRLF, ;                             // 8
   CRLF + "Aktif s�ralama yok   " + CRLF + "L�tfen se�im yap�n " + CRLF, ;                                 // 9
   CRLF + "Not alanlar� ve mant�ksal alanlarda arama yap�lamaz " + CRLF, ;                                 // 10
   CRLF + "Kay�t yok  " + CRLF, ;                                                                          // 11
   "Tan�ml� alan listesi Se�imi", ;                                                                        // 12
   "Listeden alanlar� se�iniz", ;                                                                          // 13
   "Yaz�c� Se�imi", ;                                                                                      // 14
   "Tan�ml� alanlar� se�", ;                                                                               // 15
   "Se�ilmi� alanlar", ;                                                                                   // 16
   "Yazd�r�lacak ilk kay�t se�imi", ;                                                                      // 17
   "Yazd�r�lacak son kay�t se�imi", ;                                                                      // 18
   CRLF + "Se�ilmi� alan �ok fazla  " + CRLF, ;                                                            // 19
   CRLF + "�lk alanlar� tan�mlay�n  " + CRLF, ;                                                            // 20
   CRLF + "Alanlar tan�mlanmam��   " + CRLF, ;                                                             // 21
   CRLF + "�nce alan tan�mlanmal� " + CRLF, ;                                                              // 22
   CRLF + "Hi� alan se�mediniz  " + CRLF + "Yazd�rmadan �nce alanlar tan�mlanm�� olmal� " + CRLF, ;        // 23
   CRLF + "�ok fazla alan var " + CRLF + "Alan say�s�n� uygun hale getirin " + CRLF, ;                     // 24
   CRLF + "Yaz�c� haz�r de�il " + CRLF, ;                                                                  // 25
   "S�ralama ", ;                                                                                          // 26
   "ilk kay�t ", ;                                                                                         // 27
   "son kay�t", ;                                                                                          // 28
   "Evet", ;                                                                                               // 29
   "Hay�r", ;                                                                                              // 30
   "Sayfa:", ;                                                                                             // 31
   CRLF + "L�tfen yaz�c� se�in  " + CRLF, ;                                                                // 32
   "Filtreleme ", ;                                                                                        // 33
   CRLF + "Aktif filtre " + CRLF, ;                                                                        // 34
   CRLF + "Not alanlar�nda filtreleme yap�lamaz " + CRLF, ;                                                // 35
   CRLF + "Filtre i�in alan se� " + CRLF, ;                                                                // 36
   CRLF + "Filtre i�in ��lem se�  " + CRLF, ;                                                              // 37
   CRLF + "Alan tipi filtrelemeye uymuyor " + CRLF, ;                                                      // 38
   CRLF + "Aktif hi� filtre yok  " + CRLF, ;                                                               // 39
   CRLF + "Filtre �ptali ?   " + CRLF, ;                                                                   // 40
   CRLF + "Di�er kullan�c�lar kayd� kullan�yor " + CRLF }                                                  // 41

   // PRINT MESSAGES
   acPrint          := { "Yaz�c� �nizlemesi olu�turuluyor , bekleyin", ;
      "Yazd�r�l�yor ", ;
      "Yaz�c�ya aktar�l�yor", ;
      " Yazd�r�ld� !!!", ;
      "Tan�ms�z parametre veya i�lem var !!!", ;
      "Yaz�c� �a�r�lamad� !!!", ;
      "Yazd�rmaya ba�lanamad� !!!", ;
      "Sayfalar yazd�r�lam�yor !!!", ;
      "��leminiz ger�ekle�tirilemiyor !!!", ;
      " BULUNAMADI !!!", ;
      "Yaz�c� bulunm�yor !!!", ;
      "HATA", ;
      "Yaz�c� ba�lant�s� kullan�lam�yor !!!", ;
      "Yaz�c� Se� ", ;
      "Tamam", ;
      "�ptal", ;
      '�nizleme --> ', ;
      "Kapat", ;
      "Kapat", ;
      "B�y�lt", ;
      "K���lt", ;
      "K���lt", ;
      "K���lt", ;
      "Yazd�r", ;
      "Yazd�rma Modu ", ;
      "Ara ", ;
      "Ara ", ;
      "Sonraki arama ", ;
      "Sonraki arama ", ;
      'S�zc�k: ', ;
      'Aranacak c�mle ', ;
      "Arama sonland�.", ;
      "Bilgilendirme ", ;
      'Excel bulunamad� !!!', ;
      "XLS uzant�s� de�il !!!", ;
      "Kaydedilecek dosya : ", ;
      "HTML uzant�l� de�il !!!", ;
      "RTF uzant�l� de�il !!!", ;
      "CSV uzant�l� de�il !!!", ;
      "PDF uzant�l� de�il !!!", ;
      "ODT uzant�l� de�il !!!", ;
      'Barcode gerekli bir karakter de�i�keni !!!', ;
      'Code 128 modunda A, B veya C karakter de�i�keni !!!', ;
      "Hesap bulunamad� !!!", ;
      "Dosya kayd�nda hata: " }

   RETURN { acMisc, acBrowseButton, acBrowseError, acBrowseMessages, acABMUser, acABMLabel, acABMButton, acABMError, acButton, acLabel, acUser, acPrint }
