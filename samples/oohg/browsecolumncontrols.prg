/*
 * $Id: browsecolumncontrols.prg,v 1.1 2005-10-22 06:05:45 guerra000 Exp $
 */
/*
 * ooHG Browse COLUMNCONTROLS demo. (c) 2005 Vic
 * This demo shows how to create custom COLUMNCONTROLS objects,
 * and how to implement REPLACEFIELD clause on browse.
 */

#include "oohg.ch"
#include "hbclass.ch"

PROCEDURE MAIN
Local oMain
Local aControls, aItems, aGroups, aReplaceField

   aGroups := { "Computing", "Accounting", "Sales" }

   aControls := { , ; // TGridControlTextBox():New(), ;
                  MyFullName():New(), ;
                  MyIpAddress():New(), ;
                  TGridControlLComboBox():New( "Yes", "No" ), ;
                  MyRadioGroup():New( aGroups ) }

   USE browsecolumncontrols

   aReplaceField := { , ; // FieldBlock( "COMPUTER" )
                      { |a| SaveFullName( a ) }, ;
                      { |a| SaveIPAddress( a ) }, ;
                      , ; // FieldBlock( "INETACCESS" )
                        } // FieldBlock( "GROUP" )

   DEFINE WINDOW Main OBJ oMain AT 0,0 WIDTH 500 HEIGHT 250 ;
          TITLE "Browse COLUMNCONTROLS demo." MAIN

      @  10, 10 BROWSE Browse WIDTH 475 HEIGHT 150 EDIT INPLACE NOVSCROLL ;
                HEADERS { "Computer", "User", "IP Address", "INET Access", "Group" } ;
                WIDTHS { 90, 110, 100, 80, 85 } ;
                FIELDS { "COMPUTER", "{FIRST,LAST}", "{IP1,IP2,IP3,IP4}", "INETACCESS", "GROUP" } ;
                FONT "MS Sans Serif" SIZE 9 ;
                COLUMNCONTROLS aControls ;
                REPLACEFIELD aReplaceField

      @ 180, 10 LABEL Label VALUE "Edition type:" AUTOSIZE

      @ 180,100 RADIOGROUP Radio OPTIONS { "InPlace", "Full Row" } AUTOSIZE VALUE 1 ;
                ON CHANGE ( oMain:Browse:InPlace := ( oMain:Radio:Value == 1 ) )

      oMain:Radio:aItems[ 2 ]:Row := 180
      oMain:Radio:aItems[ 2 ]:Col := 180

   END WINDOW
   CENTER WINDOW Main
   ACTIVATE WINDOW Main

RETURN

FUNCTION SaveFullName( aName )
   If ValType( aName ) == "A"
      REPLACE First WITH aName[ 1 ]
      REPLACE Last  WITH aName[ 2 ]
   EndIf
RETURN { FIRST, LAST }

FUNCTION SaveIPAddress( aIPAddress )
   If ValType( aIPAddress ) == "A"
      REPLACE IP1 WITH aIPAddress[ 1 ]
      REPLACE IP2 WITH aIPAddress[ 2 ]
      REPLACE IP3 WITH aIPAddress[ 3 ]
      REPLACE IP4 WITH aIPAddress[ 4 ]
   EndIf
RETURN { IP1, IP2, IP3, IP4 }





*-----------------------------------------------------------------------------*
CLASS MyIpAddress FROM TGridControl // CLASS TGridControlIpAddress
*-----------------------------------------------------------------------------*
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue(uValue) BLOCK { |Self,uValue| Empty( Self ), LTrim(Str(uValue[1]))+"."+LTrim(Str(uValue[2]))+"."+LTrim(Str(uValue[3]))+"."+LTrim(Str(uValue[4])) }
ENDCLASS

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS MyIpAddress
   If Valtype( uValue ) == "C"
      uValue := ::Str2Val( uValue )
   EndIf
   @ nRow,nCol IPADDRESS 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth HEIGHT nHeight VALUE uValue
Return ::oControl

METHOD Str2Val( uValue ) CLASS MyIpAddress
Local aValue, nPos, nCount
   aValue := { 0, 0, 0, 0 }
   nCount := 1
   Do While nCount <= 4 .AND. ! Empty( uValue )
      nPos := At( ".", uValue )
      If nPos == 0
         aValue[ nCount ] := Val( AllTrim( uValue ) )
         uValue := ""
      Else
         aValue[ nCount ] := Val( AllTrim( Left( uValue, nPos - 1 ) ) )
         uValue := SubStr( uValue, nPos + 1 )
      EndIf
      nCount++
   EndDo
Return aValue





*-----------------------------------------------------------------------------*
CLASS MyRadioGroup FROM TGridControl // CLASS TGridControlRadioGroup
*-----------------------------------------------------------------------------*
   DATA aItems INIT {}

   METHOD nDefHeight         BLOCK { |Self| ( Len( ::aItems ) * 20 ) }

   METHOD New
   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue(uValue) BLOCK { |Self,uValue| if( ( uValue >= 1 .AND. uValue <= Len( ::aItems ) ), ::aItems[ uValue ], "" ) }
ENDCLASS

METHOD New( aItems ) CLASS MyRadioGroup
   If ValType( aItems ) == "A"
      ::aItems := aItems
   EndIf
Return Self

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS MyRadioGroup
Return ::Super:CreateWindow( uValue, nRow, nCol, nWidth, ::nDefHeight, cFontName, nFontSize )

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS MyRadioGroup
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := aScan( ::aItems, { |c| c == uValue } )
   EndIf
   @ nRow,nCol RADIOGROUP 0 OBJ ::oControl PARENT &cWindow OPTIONS ::aItems WIDTH nWidth VALUE uValue SPACING 20
Return ::oControl

METHOD Str2Val( uValue ) CLASS MyRadioGroup
Return ASCAN( ::aItems, { |c| c == uValue } )





*-----------------------------------------------------------------------------*
CLASS MyFullName FROM TGridControl
*-----------------------------------------------------------------------------*
   DATA oControl2     INIT nil
   DATA nDefHeight    INIT 54

   METHOD CreateWindow
   METHOD CreateControl
   METHOD Str2Val
   METHOD GridValue(uValue) BLOCK { |Self,uValue| Empty( Self ), AllTrim( uValue[ 2 ] ) + ", " + AllTrim( uValue[ 1 ] ) }
   METHOD ControlValue      BLOCK { |Self| { ::oControl:Value, ::oControl2:Value } }
   METHOD Enabled           SETGET
   METHOD OnLostFocus       SETGET
ENDCLASS

METHOD CreateWindow( uValue, nRow, nCol, nWidth, nHeight, cFontName, nFontSize ) CLASS MyFullName
Local lRet := .F.
   Empty( nWidth )
   Empty( nHeight )
   Empty( cFontName )
   Empty( nFontSize )
   DEFINE WINDOW 0 OBJ ::oWindow ;
          AT nRow, nCol WIDTH 260 HEIGHT GetTitleHeight() + 120 TITLE "Edit Full Name" ;
          MODAL NOSIZE

          ON KEY ESCAPE OF &( ::oWindow:Name ) ACTION ( ::oWindow:Release() )

          @ 13, 10 LABEL 0 PARENT &( ::oWindow:Name ) VALUE "First Name:" AUTOSIZE
          @ 43, 10 LABEL 0 PARENT &( ::oWindow:Name ) VALUE "Last Name:"  AUTOSIZE
          ::CreateControl( uValue, ::oWindow:Name, 10, 100, ::nDefWidth, ::nDefHeight )
          ::Value := ::ControlValue
          @  77, 20 BUTTON 0 PARENT &( ::oWindow:Name ) CAPTION _OOHG_MESSAGE[ 6 ] ACTION ( lRet := ::Valid() )
          @  77,130 BUTTON 0 PARENT &( ::oWindow:Name ) CAPTION _OOHG_MESSAGE[ 7 ] ACTION ( ::oWindow:Release() )
   END WINDOW
   ::oWindow:Center()
   ::oControl:SetFocus()
   ::oWindow:Activate()
Return lRet

METHOD CreateControl( uValue, cWindow, nRow, nCol, nWidth, nHeight ) CLASS MyFullName
   Empty( nHeight )
   If ValType( uValue ) == "C"
      uValue := ::Str2Val( uValue )
   EndIf
   @ nRow,nCol TEXTBOX 0 OBJ ::oControl PARENT &cWindow WIDTH nWidth HEIGHT 24 VALUE uValue[ 1 ]
   @ nRow + 30,nCol TEXTBOX 0 OBJ ::oControl2 PARENT &cWindow WIDTH nWidth HEIGHT 24 VALUE uValue[ 2 ]
Return ::oControl

METHOD Str2Val( uValue ) CLASS MyFullName
Local aValue, nPos
   nPos := At( ",", uValue )
   If nPos != 0
      aValue := { AllTrim( SubStr( uValue, nPos + 1 ) ), AllTrim( Left( uValue, nPos - 1 ) ) }
   Else
      aValue := { "", AllTrim( Left( uValue, nPos - 1 ) ) }
   EndIf
Return aValue

METHOD Enabled( uValue ) CLASS MyFullName
   ::oControl2:Enabled := uValue
Return ( ::oControl:Enabled := uValue )

METHOD OnLostFocus( uValue ) CLASS MyFullName
   If PCOUNT() >= 1
      ::oControl:OnLostFocus  := uValue
      ::oControl2:OnLostFocus := uValue
   EndIf
Return ::oControl:OnLostFocus