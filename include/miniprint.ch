/*
 * $Id: miniprint.ch $
 */
/*
 * OOHG source code:
 * Miniprint library definitions
 *
 * Copyright 2006-2022 Ciro Vargas C. <cvc@oohg.org> and contributors of
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


#ifndef __MINIPRINT__
#define __MINIPRINT__

MEMVAR _HMG_MiniPrint

#define _HMG_PRINTER_LastVar 30

#xtranslate _HMG_PRINTER_Name               => _HMG_MiniPrint\[01\]
#xtranslate _HMG_PRINTER_aPrinterProperties => _HMG_MiniPrint\[02\]
#xtranslate _HMG_PRINTER_BasePageName       => _HMG_MiniPrint\[03\]
#xtranslate _HMG_PRINTER_CurrentPageNumber  => _HMG_MiniPrint\[04\]
#xtranslate _HMG_PRINTER_SizeFactor         => _HMG_MiniPrint\[05\]
#xtranslate _HMG_PRINTER_Dx                 => _HMG_MiniPrint\[06\]
#xtranslate _HMG_PRINTER_Dy                 => _HMG_MiniPrint\[07\]
#xtranslate _HMG_PRINTER_Dz                 => _HMG_MiniPrint\[08\]
#xtranslate _HMG_PRINTER_ScrollStep         => _HMG_MiniPrint\[09\]
#xtranslate _HMG_PRINTER_ZoomClick_xOffset  => _HMG_MiniPrint\[10\]
#xtranslate _HMG_PRINTER_ThumbUpdate        => _HMG_MiniPrint\[11\]
#xtranslate _HMG_PRINTER_ThumbScroll        => _HMG_MiniPrint\[12\]
#xtranslate _HMG_PRINTER_PrevPageNumber     => _HMG_MiniPrint\[13\]
#xtranslate _HMG_PRINTER_Copies             => _HMG_MiniPrint\[14\]
#xtranslate _HMG_PRINTER_Collate            => _HMG_MiniPrint\[15\]
#xtranslate _HMG_PRINTER_Delta_Zoom         => _HMG_MiniPrint\[16\]   // Unused
#xtranslate _HMG_PRINTER_TimeStamp          => _HMG_MiniPrint\[17\]
#xtranslate _HMG_PRINTER_PageCount          => _HMG_MiniPrint\[18\]
#xtranslate _HMG_PRINTER_hdcPrint           => _HMG_MiniPrint\[19\]
#xtranslate _HMG_PRINTER_hdcEMF             => _HMG_MiniPrint\[20\]
#xtranslate _HMG_PRINTER_JobName            => _HMG_MiniPrint\[21\]
#xtranslate _HMG_PRINTER_UserMessages       => _HMG_MiniPrint\[22\]
#xtranslate _HMG_PRINTER_Preview            => _HMG_MiniPrint\[23\]
#xtranslate _HMG_PRINTER_UserCopies         => _HMG_MiniPrint\[24\]
#xtranslate _HMG_PRINTER_UserCollate        => _HMG_MiniPrint\[25\]
#xtranslate _HMG_PRINTER_JobId              => _HMG_MiniPrint\[26\]
#xtranslate _HMG_PRINTER_JobData            => _HMG_MiniPrint\[27\]
#xtranslate _HMG_PRINTER_Language           => _HMG_MiniPrint\[28\]
#xtranslate _HMG_PRINTER_Error              => _HMG_MiniPrint\[29\]
#xtranslate _HMG_PRINTER_NoSaveButton       => _HMG_MiniPrint\[30\]

#xtranslate OpenPrinterGetJobData()         => { _HMG_PRINTER_JobId, _HMG_PRINTER_Name }
#xtranslate OpenPrinterGetDC()              => _HMG_PRINTER_aPrinterProperties\[1\]
#xtranslate OpenPrinterGetPageDC()          => iif( _HMG_PRINTER_Preview, _HMG_PRINTER_hdcEMF, _HMG_PRINTER_hdcPrint )
#xtranslate OpenPrinterGetPageWidth()       => _HMG_PRINTER_GETPAGEWIDTH( OpenPrinterGetDC() )
#xtranslate OpenPrinterGetPageHeight()      => _HMG_PRINTER_GETPAGEHEIGHT( OpenPrinterGetDC() )

// Pseudofunctions
#xtranslate GetPrintableAreaWidth()            => _HMG_PRINTER_GetPrintableAreaWidth()
#xtranslate GetPrintableAreaHeight()           => _HMG_PRINTER_GetPrintableAreaHeight()
#xtranslate GetPrintableAreaHorizontalOffset() => _HMG_PRINTER_GetPrintableAreaHorizontalOffset()
#xtranslate GetPrintableAreaVerticalOffset()   => _HMG_PRINTER_GetPrintableAreaVerticalOffset()
#xtranslate GetPrinter()                       => _HMG_PRINTER_GetPrinter()
#xtranslate aPrinters()                        => _HMG_PRINTER_aPrinters()

#xcommand SELECT PRINTER <cPrinter> ;
      [ <lOrientation: ORIENTATION> <nOrientation> ] ;
      [ <lPaperSize: PAPERSIZE> <nPaperSize> ] ;
      [ <lPaperLength: PAPERLENGTH> <nPaperLength> ] ;
      [ <lPaperWidth: PAPERWIDTH> <nPaperWidth> ] ;
      [ <lCopies: COPIES> <nCopies> ] ;
      [ <lDefaultSource: DEFAULTSOURCE> <nDefaultSource> ] ;
      [ <lQuality: QUALITY> <nQuality> ] ;
      [ <lColor: COLOR> <nColor> ] ;
      [ <lDuplex: DUPLEX> <nDuplex> ] ;
      [ <lCollate: COLLATE> <nCollate> ] ;
      [ <lScale: SCALE> <nScale> ] ;
      [ <lPreview: PREVIEW> ] ;
      [ <lSilent: NOERRORMSGS> ] ;
      [ <lIgnore: IGNOREERRORS> ] ;
      [ <lGlobal: GLOBAL> ] ;
      [ LANGUAGE <cLang> ] ;
   => ;
      _HMG_PRINTER_InitUserMessages( <cLang> ) ;;
      _HMG_PRINTER_aPrinterProperties := _HMG_PRINTER_SetPrinterProperties( ;
            <cPrinter>, ;
            iif( <.lOrientation.>, <nOrientation>, -999 ), ;
            iif( <.lPaperSize.>, <nPaperSize>, -999 ), ;
            iif( <.lPaperLength.>, <nPaperLength>, -999 ), ;
            iif( <.lPaperWidth.>, <nPaperWidth>, -999 ), ;
            iif( <.lCopies.>, <nCopies>, -999 ), ;
            iif( <.lDefaultSource.>, <nDefaultSource>, -999 ), ;
            iif( <.lQuality.>, <nQuality>, -999 ), ;
            iif( <.lColor.>, <nColor>, -999 ), ;
            iif( <.lDuplex.>, <nDuplex>, -999 ), ;
            iif( <.lCollate.>, <nCollate>, -999 ), ;
            iif( <.lScale.>, <nScale>, -999 ), ;
            <.lSilent.>, ;
            <.lIgnore.>, ;
            <.lGlobal.> ) ;;
      _HMG_PRINTER_hdcPrint := _HMG_PRINTER_aPrinterProperties\[1\] ;;
      _HMG_PRINTER_Copies := _HMG_PRINTER_aPrinterProperties\[3\] ;;
      _HMG_PRINTER_Collate := _HMG_PRINTER_aPrinterProperties\[4\] ;;
      _HMG_PRINTER_Error := _HMG_PRINTER_aPrinterProperties\[5\] ;;
      _HMG_PRINTER_Preview := <.lPreview.> ;;
      _HMG_PRINTER_UserCopies := <.lCopies.> ;;
      _HMG_PRINTER_UserCollate := <.lCollate.> ;;
      _HMG_PRINTER_TimeStamp := StrZero( Seconds() * 100, 8 ) ;;
      _HMG_PRINTER_Name := <cPrinter> 

#xcommand SELECT PRINTER <cPrinter> TO <lSuccess> ;
      [ <lOrientation: ORIENTATION> <nOrientation> ] ;
      [ <lPaperSize: PAPERSIZE> <nPaperSize> ] ;
      [ <lPaperLength: PAPERLENGTH> <nPaperLength> ] ;
      [ <lPaperWidth: PAPERWIDTH> <nPaperWidth> ] ;
      [ <lCopies: COPIES> <nCopies> ] ;
      [ <lDefaultSource: DEFAULTSOURCE> <nDefaultSource> ] ;
      [ <lQuality: QUALITY> <nQuality> ] ;
      [ <lColor: COLOR> <nColor> ] ;
      [ <lDuplex: DUPLEX> <nDuplex> ] ;
      [ <lCollate: COLLATE> <nCollate> ] ;
      [ <lScale: SCALE> <nScale> ] ;
      [ <lPreview: PREVIEW> ] ;
      [ <lSilent: NOERRORMSGS> ] ;
      [ <lIgnore: IGNOREERRORS> ] ;
      [ <lGlobal: GLOBAL> ] ;
      [ LANGUAGE <cLang> ] ;
   => ;
      _HMG_PRINTER_InitUserMessages( <cLang> ) ;;
      _HMG_PRINTER_aPrinterProperties := _HMG_PRINTER_SetPrinterProperties( ;
            <cPrinter>, ;
            iif( <.lOrientation.>, <nOrientation>, -999 ), ;
            iif( <.lPaperSize.>, <nPaperSize>, -999 ), ;
            iif( <.lPaperLength.>, <nPaperLength>, -999 ), ;
            iif( <.lPaperWidth.>, <nPaperWidth>, -999 ), ;
            iif( <.lCopies.>, <nCopies>, -999 ), ;
            iif( <.lDefaultSource.>, <nDefaultSource>, -999 ), ;
            iif( <.lQuality.>, <nQuality>, -999 ), ;
            iif( <.lColor.>, <nColor>, -999 ), ;
            iif( <.lDuplex.>, <nDuplex>, -999 ), ;
            iif( <.lCollate.>, <nCollate>, -999 ), ;
            iif( <.lScale.>, <nScale>, -999 ), ;
            <.lSilent.>, ;
            <.lIgnore.>, ;
            <.lGlobal.> ) ;;
      _HMG_PRINTER_hdcPrint := _HMG_PRINTER_aPrinterProperties\[1\] ;;
      _HMG_PRINTER_Copies := _HMG_PRINTER_aPrinterProperties\[3\] ;;
      _HMG_PRINTER_Collate := _HMG_PRINTER_aPrinterProperties\[4\] ;;
      _HMG_PRINTER_Error := _HMG_PRINTER_aPrinterProperties\[5\] ;;
      <lSuccess> := iif( _HMG_PRINTER_hdcPrint <> 0, .T., .F. ) ;;
      _HMG_PRINTER_Preview := <.lPreview.> ;;
      _HMG_PRINTER_UserCopies := <.lCopies.> ;;
      _HMG_PRINTER_UserCollate := <.lCollate.> ;;
      _HMG_PRINTER_TimeStamp := StrZero( Seconds() * 100, 8 ) ;;
      _HMG_PRINTER_Name := <cPrinter>

#xcommand SELECT PRINTER DEFAULT ;
      [ <lOrientation: ORIENTATION> <nOrientation> ] ;
      [ <lPaperSize: PAPERSIZE> <nPaperSize> ] ;
      [ <lPaperLength: PAPERLENGTH> <nPaperLength> ] ;
      [ <lPaperWidth: PAPERWIDTH> <nPaperWidth> ] ;
      [ <lCopies: COPIES> <nCopies> ] ;
      [ <lDefaultSource: DEFAULTSOURCE> <nDefaultSource> ] ;
      [ <lQuality: QUALITY> <nQuality> ] ;
      [ <lColor: COLOR> <nColor> ] ;
      [ <lDuplex: DUPLEX> <nDuplex> ] ;
      [ <lCollate: COLLATE> <nCollate> ] ;
      [ <lScale: SCALE> <nScale> ] ;
      [ <lPreview: PREVIEW> ] ;
      [ <lSilent: NOERRORMSGS> ] ;
      [ <lIgnore: IGNOREERRORS> ] ;
      [ <lGlobal: GLOBAL> ] ;
      [ LANGUAGE <cLang> ] ;
   => ;
      _HMG_PRINTER_InitUserMessages( <cLang> ) ;;
      _HMG_PRINTER_Name := GetDefaultPrinter() ;;
      _HMG_PRINTER_aPrinterProperties := _HMG_PRINTER_SetPrinterProperties( ;
            _HMG_PRINTER_Name, ;
            iif( <.lOrientation.>, <nOrientation>, -999 ), ;
            iif( <.lPaperSize.>, <nPaperSize>, -999 ), ;
            iif( <.lPaperLength.>, <nPaperLength>, -999 ), ;
            iif( <.lPaperWidth.>, <nPaperWidth>, -999 ), ;
            iif( <.lCopies.>, <nCopies>, -999 ), ;
            iif( <.lDefaultSource.>, <nDefaultSource>, -999 ), ;
            iif( <.lQuality.>, <nQuality>, -999 ), ;
            iif( <.lColor.>, <nColor>, -999 ), ;
            iif( <.lDuplex.>, <nDuplex>, -999 ), ;
            iif( <.lCollate.>, <nCollate>, -999 ), ;
            iif( <.lScale.>, <nScale>, -999 ), ;
            <.lSilent.>, ;
            <.lIgnore.>, ;
            <.lGlobal.> ) ;;
      _HMG_PRINTER_hdcPrint := _HMG_PRINTER_aPrinterProperties\[1\] ;;
      _HMG_PRINTER_Copies := _HMG_PRINTER_aPrinterProperties\[3\] ;;
      _HMG_PRINTER_Collate := _HMG_PRINTER_aPrinterProperties\[4\] ;;
      _HMG_PRINTER_Error := _HMG_PRINTER_aPrinterProperties\[5\] ;;
      _HMG_PRINTER_Preview := <.lPreview.> ;;
      _HMG_PRINTER_UserCopies := <.lCopies.> ;;
      _HMG_PRINTER_UserCollate := <.lCollate.> ;;
      _HMG_PRINTER_TimeStamp := StrZero( Seconds() * 100, 8 )

#xcommand SELECT PRINTER DEFAULT TO <lSuccess> ;
      [ <lOrientation: ORIENTATION> <nOrientation> ] ;
      [ <lPaperSize: PAPERSIZE> <nPaperSize> ] ;
      [ <lPaperLength: PAPERLENGTH> <nPaperLength> ] ;
      [ <lPaperWidth: PAPERWIDTH> <nPaperWidth> ] ;
      [ <lCopies: COPIES> <nCopies> ] ;
      [ <lDefaultSource: DEFAULTSOURCE> <nDefaultSource> ] ;
      [ <lQuality: QUALITY> <nQuality> ] ;
      [ <lColor: COLOR> <nColor> ] ;
      [ <lDuplex: DUPLEX> <nDuplex> ] ;
      [ <lCollate: COLLATE> <nCollate> ] ;
      [ <lScale: SCALE> <nScale> ] ;
      [ <lPreview: PREVIEW> ] ;
      [ <lSilent: NOERRORMSGS> ] ;
      [ <lIgnore: IGNOREERRORS> ] ;
      [ <lGlobal: GLOBAL> ] ;
      [ LANGUAGE <cLang> ] ;
   => ;
      _HMG_PRINTER_InitUserMessages( <cLang> ) ;;
      _HMG_PRINTER_Name := GetDefaultPrinter() ;;
      _HMG_PRINTER_aPrinterProperties := _HMG_PRINTER_SetPrinterProperties( ;
            _HMG_PRINTER_Name, ;
            iif( <.lOrientation.>, <nOrientation>, -999 ), ;
            iif( <.lPaperSize.>, <nPaperSize>, -999 ), ;
            iif( <.lPaperLength.>, <nPaperLength>, -999 ), ;
            iif( <.lPaperWidth.>, <nPaperWidth>, -999 ), ;
            iif( <.lCopies.>, <nCopies>, -999 ), ;
            iif( <.lDefaultSource.>, <nDefaultSource>, -999 ), ;
            iif( <.lQuality.>, <nQuality>, -999 ), ;
            iif( <.lColor.>, <nColor>, -999 ), ;
            iif( <.lDuplex.>, <nDuplex>, -999 ), ;
            iif( <.lCollate.>, <nCollate>, -999 ), ;
            iif( <.lScale.>, <nScale>, -999 ), ;
            <.lSilent.>, ;
            <.lIgnore.>, ;
            <.lGlobal.> ) ;;
      _HMG_PRINTER_hdcPrint := _HMG_PRINTER_aPrinterProperties\[1\] ;;
      _HMG_PRINTER_Copies := _HMG_PRINTER_aPrinterProperties\[3\] ;;
      _HMG_PRINTER_Collate := _HMG_PRINTER_aPrinterProperties\[4\] ;;
      _HMG_PRINTER_Error := _HMG_PRINTER_aPrinterProperties\[5\] ;;
      <lSuccess> := iif( _HMG_PRINTER_hdcPrint <> 0, .T., .F. ) ;;
      _HMG_PRINTER_Preview := <.lPreview.> ;;
      _HMG_PRINTER_UserCopies := <.lCopies.> ;;
      _HMG_PRINTER_UserCollate := <.lCollate.> ;;
      _HMG_PRINTER_TimeStamp := StrZero( Seconds() * 100, 8 )

#xcommand SELECT PRINTER DIALOG [ <lPreview: PREVIEW> ] [ LANGUAGE <cLang> ] ;
   => ;
      _HMG_PRINTER_InitUserMessages( <cLang> ) ;;
      _HMG_PRINTER_aPrinterProperties = _HMG_PRINTER_PrintDialog() ;;
      _HMG_PRINTER_hdcPrint := _HMG_PRINTER_aPrinterProperties\[1\] ;;
      _HMG_PRINTER_Name := _HMG_PRINTER_aPrinterProperties\[2\] ;;
      _HMG_PRINTER_Copies := _HMG_PRINTER_aPrinterProperties\[3\] ;;
      _HMG_PRINTER_Collate := _HMG_PRINTER_aPrinterProperties\[4\] ;;
      _HMG_PRINTER_Error := _HMG_PRINTER_aPrinterProperties\[5\] ;;
      _HMG_PRINTER_Preview := <.lPreview.> ;;
      _HMG_PRINTER_TimeStamp := StrZero( Seconds() * 100, 8 )

#xcommand SELECT PRINTER DIALOG TO <lSuccess> [ <lPreview: PREVIEW> ] [ LANGUAGE <cLang> ] ;
   => ;
      _HMG_PRINTER_InitUserMessages( <cLang> ) ;;
      _HMG_PRINTER_aPrinterProperties = _HMG_PRINTER_PrintDialog() ;;
      _HMG_PRINTER_hdcPrint := _HMG_PRINTER_aPrinterProperties\[1\] ;;
      _HMG_PRINTER_Name := _HMG_PRINTER_aPrinterProperties\[2\] ;;
      _HMG_PRINTER_Copies := _HMG_PRINTER_aPrinterProperties\[3\] ;;
      _HMG_PRINTER_Collate := _HMG_PRINTER_aPrinterProperties\[4\] ;;
      _HMG_PRINTER_Error := _HMG_PRINTER_aPrinterProperties\[5\] ;;
      <lSuccess> := iif( _HMG_PRINTER_hdcPrint <> 0, .T., .F. ) ;;
      _HMG_PRINTER_Preview := <.lPreview.> ;;
      _HMG_PRINTER_TimeStamp := StrZero( Seconds() * 100, 8 )

#xcommand START PRINTDOC [ NAME <cname> ] [ LANGUAGE <cLang> ] ;
   => ;
      _HMG_PRINTER_SetJobName( <cname> ) ;;
      iif( _HMG_PRINTER_Preview, ;
           _HMG_PRINTER_PageCount := 0, ;
           _HMG_PRINTER_JobId := _HMG_PRINTER_StartDoc( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_GetJobName() ) ) ;;
      _HMG_PRINTER_Jobdata := ""

#xcommand START PRINTDOC [ NAME <cname> ] STOREJOBDATA <aJobData> [ LANGUAGE <cLang> ] ;
   => ;
      _HMG_PRINTER_SetJobName( <cname> ) ;;
      iif( _HMG_PRINTER_Preview, ;
           _HMG_PRINTER_PageCount := 0, ;
           _HMG_PRINTER_JobId := _HMG_PRINTER_StartDoc( _HMG_PRINTER_hdcPrint, _HMG_PRINTER_GetJobName() ) ) ;;
      _HMG_PRINTER_Jobdata := <"aJobData"> ;;
      <aJobData> := OpenPrinterGetJobData()

#xcommand START PRINTPAGE ;
   => ;
      iif( _HMG_PRINTER_Preview, ;
           ( _HMG_PRINTER_hdcEMF := _HMG_PRINTER_StartPage_Preview( ;
                _HMG_PRINTER_hdcPrint, ;
                ( GetTempFolder() + ;
                  '\' + ;
                  _HMG_PRINTER_TimeStamp + ;
                  "_hmg_print_preview_" + ;
                  StrZero( ++ _HMG_PRINTER_PageCount, 6, 0 ) + ;
                  ".emf" ) ) ), ;
           _HMG_PRINTER_StartPage( _HMG_PRINTER_hdcPrint ) )

#xcommand END PRINTPAGE ;
   => ;
      iif( _HMG_PRINTER_Preview, ;
           _HMG_PRINTER_EndPage_Preview( _HMG_PRINTER_hdcEMF ), ;
           _HMG_PRINTER_EndPage( _HMG_PRINTER_hdcPrint ) )

#xcommand END PRINTDOC [ <nowait: NOWAIT> ] [ <nosize: NOSIZE> ] [ <dummy: OF, PARENT> <parent> ] ;
   => ;
      iif( _HMG_PRINTER_Preview, ;
           _HMG_PRINTER_ShowPreview( <(parent)>, ! <.nowait.>, ! <.nosize.> ), ;
           _HMG_PRINTER_EndDoc( _HMG_PRINTER_hdcPrint ) )

#xcommand ABORT PRINTDOC ;
   => ;
      iif( _HMG_PRINTER_Preview, ;
           _HMG_PRINTER_EndPage_Preview( _HMG_PRINTER_hdcEMF ), ;
           _HMG_PRINTER_AbortDoc( _HMG_PRINTER_hdcPrint ) )

#xcommand SET PRINT CHARSET <charset> ;
   => ;
      _HMG_PRINTER_SetCharset( <charset> )

#xcommand @ <nRow>, <nCol> PRINT [ DATA ] <cText> ;
      [ <lFont: FONT> <cFontName> ] ;
      [ <lSize: SIZE> <nFontSize> ] ;
      [ <lBold: BOLD> ] ;
      [ <lItalic: ITALIC> ] ;
      [ <lUnderline: UNDERLINE> ] ;
      [ <lStrikeout: STRIKEOUT> ] ;
      [ <lColor: COLOR> <aColor> ] ;
      [ <lAngle: ANGLE> <nAngle> ] ;
      [ <lWidth: WIDTH> <nWidth> ] ;
      [ <cAlign: CENTER, LEFT, RIGHT> ] ;
   => ;
      _HMG_PRINTER_H_Print( OpenPrinterGetPageDC(), <nRow>, <nCol>, <cFontName>, <nFontSize>, <aColor>\[1\], ;
         <aColor>\[2\], <aColor>\[3\], <cText>, <.lBold.>, <.lItalic.>, <.lUnderline.>, <.lStrikeout.>, ;
         <.lColor.>, <.lFont.>, <.lSize.>, <.lAngle.>, <nAngle>, <.lWidth.>, <nWidth>, <"cAlign"> )

#xcommand @ <nRow>, <nCol> PRINT [ DATA ] <cText> TO <nToRow>, <nToCol> ;
      [ <lFont: FONT> <cFontName> ] ;
      [ <lSize: SIZE> <nFontSize> ] ;
      [ <lBold: BOLD> ] ;
      [ <lItalic: ITALIC> ] ;
      [ <lUnderline: UNDERLINE> ] ;
      [ <lStrikeout: STRIKEOUT> ] ;
      [ <lColor: COLOR> <aColor> ] ;
      [ <lAngle: ANGLE> <nAngle> ] ;
      [ <lWidth: WIDTH> <nWidth> ] ;
      [ <cAlign: CENTER, LEFT, RIGHT> ] ;
   => ;
      _HMG_PRINTER_H_MultiLine_Print( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, <cFontName>, <nFontSize>, ;
         <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <cText>, <.lBold.>, <.lItalic.>, <.lUnderline.>, ;
         <.lStrikeout.>, <.lColor.>, <.lFont.>, <.lSize.>, <.lAngle.>, <nAngle>, <.lWidth.>, <nWidth>, <"cAlign"> )

#xcommand @ <nRow>, <nCol> PRINT IMAGE <cFile> ;
      WIDTH <nWidth> ;
      HEIGHT <nHeight> ;
      [ <lStretch: STRETCH> ] ;
      [ TRANSPARENT ] ;
   => ;
      _HMG_PRINTER_H_Image( OpenPrinterGetPageDC(), <cFile>, <nRow>, <nCol>, <nHeight>, <nWidth>, <.lStretch.> )

#xcommand @ <nRow>, <nCol> PRINT IMAGE <cFile> ;
      IMAGESIZE ;
      [ <lStretch: STRETCH> ] ;
      [ TRANSPARENT ] ;
   => ;
      _HMG_PRINTER_H_Image( OpenPrinterGetPageDC(), <cFile>, <nRow>, <nCol>, 0, 0, <.lStretch.> )

#xcommand @ <nRow>, <nCol> PRINT LINE TO <nToRow>, <nToCol> ;
      [ <lWidth: PENWIDTH> <nWidth> ] ;
      [ <lColor: COLOR> <aColor> ] ;
      [ <lStyle: STYLE> <nStyle> ] ;
   => ;
      _HMG_PRINTER_H_Line( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, <nWidth>, ;
         <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <.lWidth.>, <.lColor.>, <.lStyle.>, <nStyle> )

#xcommand @ <nRow>, <nCol> PRINT LINE TO <nToRow>, <nToCol> DOTTED ;
      [ <lWidth: PENWIDTH> <nWidth> ] ;
      [ <lColor: COLOR> <aColor> ] ;
   => ;
      _HMG_PRINTER_H_Line( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, <nWidth>, ;
         <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <.lWidth.>, <.lColor.>, .T., PS_DASH )

// for compatibility with Extended
#xcommand @ <nRow>, <nCol> PRINT RECTANGLE TO <nToRow>, <nToCol> FILLED NOBORDER ;
      [ PENWIDTH <nWidth> ] ;
      [ COLOR <aColor> ] ;
   => ;
      @ <nRow>, <nCol> PRINT FILL TO <nToRow>, <nToCol> ;
         [ PENWIDTH <nWidth> ] ;
         [ COLOR <aColor> ]

// for compatibility with Extended
#xcommand @ <nRow>, <nCol> PRINT RECTANGLE TO <nToRow>, <nToCol> FILLED ;
      [ PENWIDTH <nWidth> ] ;
      [ COLOR <aColor> ] ;
   => ;
      @ <nRow>, <nCol> PRINT RECTANGLE TO <nToRow>, <nToCol> ;
         [ PENWIDTH <nWidth> ] ;
         [ BRUSHCOLOR <aColor> ] ;
         NOPEN

#xcommand @ <nRow>, <nCol> PRINT RECTANGLE TO <nToRow>, <nToCol> ;
      [ <lWidth: PENWIDTH> <nWidth> ] ;
      [ <lColor: COLOR> <aColor> ] ;
      [ <lStyle: STYLE> <nStyle> ] ;
      [ <lBrushStyle: BRUSHSTYLE> <nBrushStyle> ] ;
      [ <lBrushColor: BRUSHCOLOR> <aBrushColor> ] ;
      [ <lNoPen: NOPEN> ] ;
      [ <lNoBrush: NOBRUSH> ] ;
   => ;
      _HMG_PRINTER_H_Rectangle( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, <nWidth>, ;
         <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <.lWidth.>, <.lColor.>, <.lStyle.>, <nStyle>, ;
         <.lBrushStyle.>, <nBrushStyle>, <.lBrushColor.>, <aBrushColor>, <.lNoPen.>, <.lNoBrush.> )

// for compatibility with Extended
#xcommand @ <nRow>, <nCol> PRINT RECTANGLE TO <nToRow>, <nToCol> ;
      [ PENWIDTH <nWidth> ] ;
      [ COLOR <aColor> ] ;
      FILLED ;
      ROUNDED ;
   => ;
      @ <nRow>, <nCol> PRINT RECTANGLE TO <nToRow>, <nToCol> ;
         BRUSHCOLOR <aColor> NOPEN ROUNDED

#xcommand @ <nRow>, <nCol> PRINT RECTANGLE TO <nToRow>, <nToCol> ;
      [ <lWidth: PENWIDTH> <nWidth> ] ;
      [ <lColor: COLOR> <aColor> ] ;
      [ <lStyle: STYLE> <nStyle> ] ;
      [ <lBrushStyle: BRUSHSTYLE> <nBrushStyle> ] ;
      [ <lBrushColor: BRUSHCOLOR> <aBrushColor> ] ;
      [ <lNoPen: NOPEN> ] ;
      [ <lNoBrush: NOBRUSH> ] ;
      ROUNDED ;
   => ;
      _HMG_PRINTER_H_RoundRectangle( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, <nWidth>, ;
         <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <.lWidth.>, <.lColor.>, <.lStyle.>, <nStyle>, ;
         <.lBrushStyle.>, <nBrushStyle>, <.lBrushColor.>, <aBrushColor>, <.lNoPen.>, <.lNoBrush.> )

#xcommand @ <nRow>, <nCol> PRINT FILL TO <nToRow>, <nToCol> ;
      [ <lColor: COLOR> <aColor> ] ;
   => ;
      _HMG_PRINTER_H_Fill( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, ;
         <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <.lColor.> )

#xcommand @ <nRow>, <nCol> PRINT ELLIPSE TO <nToRow>, <nToCol> ;
      [ <lWidth: PENWIDTH> <nWidth> ] ;
      [ <lColor: COLOR> <aColor> ] ;
      [ <lStyle: STYLE> <nStyle> ] ;
      [ <lBrushStyle: BRUSHSTYLE> <nBrushStyle> ] ;
      [ <lBrushColor: BRUSHCOLOR> <aBrushColor> ] ;
      [ <lNoPen: NOPEN> ] ;
      [ <lNoBrush: NOBRUSH> ] ;
   => ;
      _HMG_PRINTER_H_Ellipse( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, <nWidth>, ;
         <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <.lColor.>, <.lStyle.>, <nStyle>, ;
         <.lBrushStyle.>, <nBrushStyle>, <.lBrushColor.>, <aBrushColor>, <.lNoPen.>, <.lNoBrush.> )

#xcommand @ <nRow>, <nCol> PRINT ARC TO <nToRow>, <nToCol> ;
      LIMITS <nRow1>, <nCol1>, <nRow2>, <nCol2> ;
      [ <lWidth: PENWIDTH> <nWidth> ] ;
      [ <lColor: COLOR> <aColor> ] ;
      [ <lStyle: STYLE> <nStyle> ] ;
   => ;
      _HMG_PRINTER_H_Arc( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, <nRow1>, <nCol1>, <nRow2>, <nCol2>, ;
         <nWidth>, <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <.lWidth.>, <.lColor.>, <.lStyle.>, <nStyle> )

#xcommand @ <nRow>, <nCol> PRINT PIE TO <nToRow>, <nToCol> ;
      LIMITS <nRow1>, <nCol1>, <nRow2>, <nCol2> ;
      [ <lWidth: PENWIDTH> <nWidth> ] ;
      [ <lColor: COLOR> <aColor> ] ;
      [ <lStyle: STYLE> <nStyle> ] ;
      [ <lBrushStyle: BRUSHSTYLE> <nBrushStyle> ] ;
      [ <lBrushColor: BRUSHCOLOR> <aBrushColor> ] ;
      [ <lNoPen: NOPEN> ] ;
      [ <lNoBrush: NOBRUSH> ] ;
   => ;
      _HMG_PRINTER_H_Pie( OpenPrinterGetPageDC(), <nRow>, <nCol>, <nToRow>, <nToCol>, <nRow1>, <nCol1>, <nRow2>, <nCol2>, ;
         <nWidth>, <aColor>\[1\], <aColor>\[2\], <aColor>\[3\], <.lWidth.>, <.lColor.>, <lStyle>, <nStyle>, ;
         <.lBrushStyle.>, <nBrushStyle>, <.lBrushColor.>, <aBrushColor>, <.lNoPen.>, <.lNoBrush.> )

#xcommand @ <nRow>, <nCol> PRINT BITMAP <hBitmap> ;
      WIDTH <nWidth> ;
      HEIGHT <nHeight> ;
      [ <lStretch: STRETCH> ] ;
   => ;
      _HMG_PRINTER_H_Bitmap( OpenPrinterGetPageDC(), <hBitmap>, <nRow>, <nCol>, <nHeight>, <nWidth>, <.lStretch.> )

#xcommand @ <nRow>, <nCol> PRINT BITMAP <hBitmap> ;
      IMAGESIZE ;
      [ <lStretch: STRETCH> ] ;
   => ;
      _HMG_PRINTER_H_Bitmap( OpenPrinterGetPageDC(), <hBitmap>, <nRow>, <nCol>, 0, 0, <.lStretch.> )

#xcommand SET PREVIEW ZOOM <nZoom> ;
   => ;
      _HMG_PRINTER_PreviewZoom( <nZoom> )

/*---------------------------------------------------------------------------
PRINTER CONFIGURATION CONSTANTS
---------------------------------------------------------------------------*/

/* collate */
#define PRINTER_COLLATE_TRUE  1
#define PRINTER_COLLATE_FALSE 0

/* source */
#define PRINTER_BIN_FIRST                           DMBIN_UPPER
#define PRINTER_BIN_UPPER                           1
#define PRINTER_BIN_ONLYONE                         1
#define PRINTER_BIN_LOWER                           2
#define PRINTER_BIN_MIDDLE                          3
#define PRINTER_BIN_MANUAL                          4
#define PRINTER_BIN_ENVELOPE                        5
#define PRINTER_BIN_ENVMANUAL                       6
#define PRINTER_BIN_AUTO                            7
#define PRINTER_BIN_TRACTOR                         8
#define PRINTER_BIN_SMALLFMT                        9
#define PRINTER_BIN_LARGEFMT                        10
#define PRINTER_BIN_LARGECAPACITY                   11
#define PRINTER_BIN_CASSETTE                        14
#define PRINTER_BIN_FORMSOURCE                      15
#define PRINTER_BIN_LAST                            DMBIN_FORMSOURCE
#define PRINTER_BIN_USER                            256

/* orientation */
#define PRINTER_ORIENT_PORTRAIT                     1
#define PRINTER_ORIENT_LANDSCAPE                    2

/* color */
#define PRINTER_COLOR_MONOCHROME                    1
#define PRINTER_COLOR_COLOR                         2

/* quality */
#define PRINTER_RES_DRAFT                           (-1)
#define PRINTER_RES_LOW                             (-2)
#define PRINTER_RES_MEDIUM                          (-3)
#define PRINTER_RES_HIGH                            (-4)

/* duplex */
#define PRINTER_DUP_SIMPLEX                         1
#define PRINTER_DUP_VERTICAL                        2
#define PRINTER_DUP_HORIZONTAL                      3

/* paper size */
#define PRINTER_PAPER_FIRST                         PRINTER_PAPER_LETTER
#define PRINTER_PAPER_LETTER                        1   /* US Letter 8 1/2 x 11 in */
#define PRINTER_PAPER_LETTERSMALL                   2   /* US Letter Small 8 1/2 x 11 in */
#define PRINTER_PAPER_TABLOID                       3   /* US Tabloid 11 x 17 in */
#define PRINTER_PAPER_LEDGER                        4   /* US Ledger 17 x 11 in */
#define PRINTER_PAPER_LEGAL                         5   /* US Legal 8 1/2 x 14 in */
#define PRINTER_PAPER_STATEMENT                     6   /* US Statement 5 1/2 x 8 1/2 in */
#define PRINTER_PAPER_EXECUTIVE                     7   /* US Executive 7 1/4 x 10 1/2 in */
#define PRINTER_PAPER_A3                            8   /* A3 297 x 420 mm */
#define PRINTER_PAPER_A4                            9   /* A4 210 x 297 mm */
#define PRINTER_PAPER_A4SMALL                       10  /* A4 Small 210 x 297 mm */
#define PRINTER_PAPER_A5                            11  /* A5 148 x 210 mm */
#define PRINTER_PAPER_B4                            12  /* B4 (JIS) 257 x 364 mm */
#define PRINTER_PAPER_B5                            13  /* B5 (JIS) 182 x 257 mm */
#define PRINTER_PAPER_FOLIO                         14  /* Folio 8 1/2 x 13 in */
#define PRINTER_PAPER_QUARTO                        15  /* Quarto 215 x 275 mm */
#define PRINTER_PAPER_10X14                         16  /* 10x14 in */
#define PRINTER_PAPER_11X17                         17  /* 11x17 in */
#define PRINTER_PAPER_NOTE                          18  /* US Note 8 1/2 x 11 in */
#define PRINTER_PAPER_ENV_9                         19  /* US Envelope #9 3 7/8 x 8 7/8 in */
#define PRINTER_PAPER_ENV_10                        20  /* US Envelope #10 4 1/8 x 9 1/2 in */
#define PRINTER_PAPER_ENV_11                        21  /* US Envelope #11 4 1/2 x 10 3/8 in */
#define PRINTER_PAPER_ENV_12                        22  /* US Envelope #12 4 3/4 x 11 in */
#define PRINTER_PAPER_ENV_14                        23  /* US Envelope #14 5 x 11 1/2 in */
#define PRINTER_PAPER_CSHEET                        24  /* C size sheet 17 X 22 in */
#define PRINTER_PAPER_DSHEET                        25  /* D size sheet 22 X 34 in */
#define PRINTER_PAPER_ESHEET                        26  /* E size sheet 34 x 44 in */
#define PRINTER_PAPER_ENV_DL                        27  /* Envelope DL 110 x 220 mm */
#define PRINTER_PAPER_ENV_C5                        28  /* Envelope C5 162 x 229 mm */
#define PRINTER_PAPER_ENV_C3                        29  /* Envelope C3 324 x 458 mm */
#define PRINTER_PAPER_ENV_C4                        30  /* Envelope C4 229 x 324 mm */
#define PRINTER_PAPER_ENV_C6                        31  /* Envelope C6 114 x 162 mm */
#define PRINTER_PAPER_ENV_C65                       32  /* Envelope C65 114 x 229 mm */
#define PRINTER_PAPER_ENV_B4                        33  /* Envelope B4 250 x 353 mm */
#define PRINTER_PAPER_ENV_B5                        34  /* Envelope B5 176 x 250 mm */
#define PRINTER_PAPER_ENV_B6                        35  /* Envelope B6 176 x 125 mm */
#define PRINTER_PAPER_ENV_ITALY                     36  /* Envelope 110 x 230 mm */
#define PRINTER_PAPER_ENV_MONARCH                   37  /* US Envelope Monarch 3 7/8 x 7 1/2 in */
#define PRINTER_PAPER_ENV_PERSONAL                  38  /* 6 3/4 US Envelope 3 5/8 x 6 1/2 in */
#define PRINTER_PAPER_FANFOLD_US                    39  /* US Std Fanfold 14 7/8 x 11 in */
#define PRINTER_PAPER_FANFOLD_STD_GERMAN            40  /* German Std Fanfold 8 1/2 x 12 in */
#define PRINTER_PAPER_FANFOLD_LGL_GERMAN            41  /* German Legal Fanfold 8 1/2 x 13 in */
#define PRINTER_PAPER_ISO_B4                        42  /* B4 (ISO) 250 x 353 mm */
#define PRINTER_PAPER_JAPANESE_POSTCARD             43  /* Japanese Postcard 100 x 148 mm */
#define PRINTER_PAPER_9X11                          44  /* 9 x 11 in */
#define PRINTER_PAPER_10X11                         45  /* 10 x 11 in */
#define PRINTER_PAPER_15X11                         46  /* 15 x 11 in */
#define PRINTER_PAPER_ENV_INVITE                    47  /* Envelope Invite 220 x 220 mm */
#define PRINTER_PAPER_RESERVED_48                   48  /* RESERVED--DO NOT USE */
#define PRINTER_PAPER_RESERVED_49                   49  /* RESERVED--DO NOT USE */
#define PRINTER_PAPER_LETTER_EXTRA                  50  /* US Letter Extra 9 1/2 x 12 in */
#define PRINTER_PAPER_LEGAL_EXTRA                   51  /* US Legal Extra 9 1/2 x 15 in */
#define PRINTER_PAPER_TABLOID_EXTRA                 52  /* US Tabloid Extra 11.69 x 18 in */
#define PRINTER_PAPER_A4_EXTRA                      53  /* A4 Extra 9.27 x 12.69 in */
#define PRINTER_PAPER_LETTER_TRANSVERSE             54  /* Letter Transverse 8 1/2 x 11 in */
#define PRINTER_PAPER_A4_TRANSVERSE                 55  /* A4 Transverse 210 x 297 mm */
#define PRINTER_PAPER_LETTER_EXTRA_TRANSVERSE       56  /* Letter Extra Transverse 9 1/2 x 12 in */
#define PRINTER_PAPER_A_PLUS                        57  /* SuperA/SuperA/A4 227 x 356 mm */
#define PRINTER_PAPER_B_PLUS                        58  /* SuperB/SuperB/A3 305 x 487 mm */
#define PRINTER_PAPER_LETTER_PLUS                   59  /* US Letter Plus 8.5 x 12.69 in */
#define PRINTER_PAPER_A4_PLUS                       60  /* A4 Plus 210 x 330 mm */
#define PRINTER_PAPER_A5_TRANSVERSE                 61  /* A5 Transverse 148 x 210 mm */
#define PRINTER_PAPER_B5_TRANSVERSE                 62  /* B5 (JIS) Transverse 182 x 257 mm */
#define PRINTER_PAPER_A3_EXTRA                      63  /* A3 Extra 322 x 445 mm */
#define PRINTER_PAPER_A5_EXTRA                      64  /* A5 Extra 174 x 235 mm */
#define PRINTER_PAPER_B5_EXTRA                      65  /* B5 (ISO) Extra 201 x 276 mm */
#define PRINTER_PAPER_A2                            66  /* A2 420 x 594 mm */
#define PRINTER_PAPER_A3_TRANSVERSE                 67  /* A3 Transverse 297 x 420 mm */
#define PRINTER_PAPER_A3_EXTRA_TRANSVERSE           68  /* A3 Extra Transverse 322 x 445 mm */
#define PRINTER_PAPER_DBL_JAPANESE_POSTCARD         69  /* Japanese Double Postcard 200 x 148 mm */
#define PRINTER_PAPER_A6                            70  /* A6 105 x 148 mm */
#define PRINTER_PAPER_JENV_KAKU2                    71  /* Japanese Envelope Kaku #2 */
#define PRINTER_PAPER_JENV_KAKU3                    72  /* Japanese Envelope Kaku #3 */
#define PRINTER_PAPER_JENV_CHOU3                    73  /* Japanese Envelope Chou #3 */
#define PRINTER_PAPER_JENV_CHOU4                    74  /* Japanese Envelope Chou #4 */
#define PRINTER_PAPER_LETTER_ROTATED                75  /* Letter Rotated 11 x 8 1/2 in */
#define PRINTER_PAPER_A3_ROTATED                    76  /* A3 Rotated 420 x 297 mm */
#define PRINTER_PAPER_A4_ROTATED                    77  /* A4 Rotated 297 x 210 mm */
#define PRINTER_PAPER_A5_ROTATED                    78  /* A5 Rotated 210 x 148 mm */
#define PRINTER_PAPER_B4_JIS_ROTATED                79  /* B4 (JIS) Rotated 364 x 257 mm */
#define PRINTER_PAPER_B5_JIS_ROTATED                80  /* B5 (JIS) Rotated 257 x 182 mm */
#define PRINTER_PAPER_JAPANESE_POSTCARD_ROTATED     81  /* Japanese Postcard Rotated 148 x 100 mm */
#define PRINTER_PAPER_DBL_JAPANESE_POSTCARD_ROTATED 82  /* Double Japanese Postcard Rotated 148 x 200 mm */
#define PRINTER_PAPER_A6_ROTATED                    83  /* A6 Rotated 148 x 105 mm */
#define PRINTER_PAPER_JENV_KAKU2_ROTATED            84  /* Japanese Envelope Kaku #2 Rotated */
#define PRINTER_PAPER_JENV_KAKU3_ROTATED            85  /* Japanese Envelope Kaku #3 Rotated */
#define PRINTER_PAPER_JENV_CHOU3_ROTATED            86  /* Japanese Envelope Chou #3 Rotated */
#define PRINTER_PAPER_JENV_CHOU4_ROTATED            87  /* Japanese Envelope Chou #4 Rotated */
#define PRINTER_PAPER_B6_JIS                        88  /* B6 (JIS) 128 x 182 mm */
#define PRINTER_PAPER_B6_JIS_ROTATED                89  /* B6 (JIS) Rotated 182 x 128 mm */
#define PRINTER_PAPER_12X11                         90  /* 12 x 11 in */
#define PRINTER_PAPER_JENV_YOU4                     91  /* Japanese Envelope You #4 */
#define PRINTER_PAPER_JENV_YOU4_ROTATED             92  /* Japanese Envelope You #4 Rotated*/
#define PRINTER_PAPER_P16K                          93  /* PRC 16K 146 x 215 mm */
#define PRINTER_PAPER_P32K                          94  /* PRC 32K 97 x 151 mm */
#define PRINTER_PAPER_P32KBIG                       95  /* PRC 32K(Big) 97 x 151 mm */
#define PRINTER_PAPER_PENV_1                        96  /* PRC Envelope #1 102 x 165 mm */
#define PRINTER_PAPER_PENV_2                        97  /* PRC Envelope #2 102 x 176 mm */
#define PRINTER_PAPER_PENV_3                        98  /* PRC Envelope #3 125 x 176 mm */
#define PRINTER_PAPER_PENV_4                        99  /* PRC Envelope #4 110 x 208 mm */
#define PRINTER_PAPER_PENV_5                        100 /* PRC Envelope #5 110 x 220 mm */
#define PRINTER_PAPER_PENV_6                        101 /* PRC Envelope #6 120 x 230 mm */
#define PRINTER_PAPER_PENV_7                        102 /* PRC Envelope #7 160 x 230 mm */
#define PRINTER_PAPER_PENV_8                        103 /* PRC Envelope #8 120 x 309 mm */
#define PRINTER_PAPER_PENV_9                        104 /* PRC Envelope #9 229 x 324 mm */
#define PRINTER_PAPER_PENV_10                       105 /* PRC Envelope #10 324 x 458 mm */
#define PRINTER_PAPER_P16K_ROTATED                  106 /* PRC 16K Rotated 215 x 146mm */
#define PRINTER_PAPER_P32K_ROTATED                  107 /* PRC 32K Rotated 151 x 97mm */
#define PRINTER_PAPER_P32KBIG_ROTATED               108 /* PRC 32K(Big) Rotated 151 x 97mm */
#define PRINTER_PAPER_PENV_1_ROTATED                109 /* PRC Envelope #1 Rotated 165 x 102 mm */
#define PRINTER_PAPER_PENV_2_ROTATED                110 /* PRC Envelope #2 Rotated 176 x 102 mm */
#define PRINTER_PAPER_PENV_3_ROTATED                111 /* PRC Envelope #3 Rotated 176 x 125 mm */
#define PRINTER_PAPER_PENV_4_ROTATED                112 /* PRC Envelope #4 Rotated 208 x 110 mm */
#define PRINTER_PAPER_PENV_5_ROTATED                113 /* PRC Envelope #5 Rotated 220 x 110 mm */
#define PRINTER_PAPER_PENV_6_ROTATED                114 /* PRC Envelope #6 Rotated 230 x 120 mm */
#define PRINTER_PAPER_PENV_7_ROTATED                115 /* PRC Envelope #7 Rotated 230 x 160 mm */
#define PRINTER_PAPER_PENV_8_ROTATED                116 /* PRC Envelope #8 Rotated 309 x 120 mm */
#define PRINTER_PAPER_PENV_9_ROTATED                117 /* PRC Envelope #9 Rotated 324 x 229 mm */
#define PRINTER_PAPER_PENV_10_ROTATED               118 /* PRC Envelope #10 Rotated 458 x 324 mm */
#define PRINTER_PAPER_LAST                          PRINTER_PAPER_PENV_10_ROTATED
#define PRINTER_PAPER_USER                          256

/* pen styles */
#define PEN_SOLID                                   0
#define PEN_DASH                                    1       /* ------- */
#define PEN_DOT                                     2       /* ....... */
#define PEN_DASHDOT                                 3       /* _._._._ */
#define PEN_DASHDOTDOT                              4       /* _.._.._ */
#define PEN_NULL                                    5
#define PEN_INSIDEFRAME                             6
#define PEN_USERSTYLE                               7
#define PEN_ALTERNATE                               8
#define PEN_STYLE_MASK                              0x0000000F

/* brush styles */
#define BR_SOLID                                    0
#define BR_NULL                                     1
#define BR_HOLLOW                                   BR_NULL
#define BR_HATCHED                                  2
#define BR_PATTERN                                  3
#define BR_INDEXED                                  4
#define BR_DIBPATTERN                               5
#define BR_DIBPATTERNPT                             6
#define BR_PATTERN8X8                               7
#define BR_DIBPATTERN8X8                            8
#define BR_MONOPATTERN                              9

/* hatch styles for brush */
#define BR_HORIZONTAL                               0       /* ----- */
#define BR_VERTICAL                                 1       /* ||||| */
#define BR_FDIAGONAL                                2       /* \\\\\ */
#define BR_BDIAGONAL                                3       /* ///// */
#define BR_CROSS                                    4       /* +++++ */
#define BR_DIAGCROSS                                5       /* xxxxx */

/* error codes for SELECT PRINTER command */
#define ERR_OPEN_PRINTER                            0x00000001
#define ERR_GET_PRINTER_BUFFER_SIZE                 0x00000002
#define ERR_ALLOCATE_PRINTER_BUFFER                 0x00000004
#define ERR_GET_PRINTER_SETTINGS                    0x00000008
#define ERR_GET_DOCUMENT_BUFFER_SIZE                0x00000010
#define ERR_ALLOCATE_DOCUMENT_BUFFER                0x00000020
#define ERR_GET_DOCUMENT_SETTINGS                   0x00000040
#define ERR_ORIENTATION_NOT_SUPPORTED               0x00000080
#define ERR_PAPERSIZE_NOT_SUPPORTED                 0x00000100
#define ERR_PAPERLENGTH_NOT_SUPPORTED               0x00000200
#define ERR_PAPERWIDTH_NOT_SUPPORTED                0x00000400
#define ERR_COPIES_NOT_SUPPORTED                    0x00000800
#define ERR_DEFAULTSOURCE_NOT_SUPPORTED             0x00001000
#define ERR_QUALITY_NOT_SUPPORTED                   0x00002000
#define ERR_COLOR_NOT_SUPPORTED                     0x00004000
#define ERR_DUPLEX_NOT_SUPPORTED                    0x00008000
#define ERR_COLLATE_NOT_SUPPORTED                   0x00010000
#define ERR_SCALE_NOT_SUPPORTED                     0x00020000
#define ERR_SET_DOCUMENT_SETTINGS                   0x00040000
#define ERR_CREATING_DC                             0x00080000
#define ERR_PRINTDLG                                0x00100000

/* printer status codes for _HMG_PRINTER_C_GETSTATUS */
#define WIN_PRINTER_STATUS_PAUSED                   0x00000001
#define WIN_PRINTER_STATUS_ERROR                    0x00000002
#define WIN_PRINTER_STATUS_PENDING_DELETION         0x00000004
#define WIN_PRINTER_STATUS_PAPER_JAM                0x00000008
#define WIN_PRINTER_STATUS_PAPER_OUT                0x00000010
#define WIN_PRINTER_STATUS_MANUAL_FEED              0x00000020
#define WIN_PRINTER_STATUS_PAPER_PROBLEM            0x00000040
#define WIN_PRINTER_STATUS_OFFLINE                  0x00000080
#define WIN_PRINTER_STATUS_IO_ACTIVE                0x00000100
#define WIN_PRINTER_STATUS_BUSY                     0x00000200
#define WIN_PRINTER_STATUS_PRINTING                 0x00000400
#define WIN_PRINTER_STATUS_OUTPUT_BIN_FULL          0x00000800
#define WIN_PRINTER_STATUS_NOT_AVAILABLE            0x00001000
#define WIN_PRINTER_STATUS_WAITING                  0x00002000
#define WIN_PRINTER_STATUS_PROCESSING               0x00004000
#define WIN_PRINTER_STATUS_INITIALIZING             0x00008000
#define WIN_PRINTER_STATUS_WARMING_UP               0x00010000
#define WIN_PRINTER_STATUS_TONER_LOW                0x00020000
#define WIN_PRINTER_STATUS_NO_TONER                 0x00040000
#define WIN_PRINTER_STATUS_PAGE_PUNT                0x00080000
#define WIN_PRINTER_STATUS_USER_INTERVENTION        0x00100000
#define WIN_PRINTER_STATUS_OUT_OF_MEMORY            0x00200000
#define WIN_PRINTER_STATUS_DOOR_OPEN                0x00400000
#define WIN_PRINTER_STATUS_SERVER_UNKNOWN           0x00800000
#define WIN_PRINTER_STATUS_POWER_SAVE               0x01000000

/* text alignment */
#ifndef __HBPRN__
#define TA_NOUPDATECP                               0
#define TA_UPDATECP                                 1
#define TA_LEFT                                     0
#define TA_RIGHT                                    2
#define TA_CENTER                                   6
#define TA_TOP                                      0
#define TA_BOTTOM                                   8
#define TA_BASELINE                                 24
#define TA_RTLREADING                               256
#define TA_MASK                                     ( TA_BASELINE + TA_CENTER + TA_UPDATECP + TA_RTLREADING )
#endif

#endif

