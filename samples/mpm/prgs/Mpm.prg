/*
 * $Id: Mpm.prg,v 1.3 2017-07-21 00:35:20 fyurisich Exp $
 */

/*
 * HARBOUR MINIGUI PROJECT MANAGER - Harbour MiniGUI library Demo
 *
 * Copyright 2002-2012 Roberto Lopez <harbourminigui@gmail.com>
 * http://harbourminigui.googlepages.com
 */

/*
 * ooHG - Object Oriented Harbour GUI library
 * http://www.oohg.org - http://sourceforge.net/projects/oohg - http://mig2soft.com
 * "mpm.prg" MigSoft Project Manager
 * Copyright 2008-2012 MigSoft <fugaz_cl/at/yahoo.es> <mig2soft/at/yahoo.com>
 */

/* Optimizations */

#pragma -km+
#pragma -ko+

#include "oohg.ch"
#include "common.ch"
#include "mpm.ch"

*---------------------------------------------------------------------*
Function Main( cMpm )
*---------------------------------------------------------------------*

   DECLARE WINDOW MigMess

   Publicar()

   Mpm_DiskPaths(opmfolder+"\mpm.ini") // Asigno disco actual

   Load window Main
        LoadEnvironment()
        If Pcount() > 0
           IF ! Empty( cMpm )
              ProjectFile := cMpm
              OpenMPM ( ProjectFile )
           Endif
        EndIf
        DefineWindowHotKeys()
   Center window Main
   Activate window Main

Return Nil

*---------------------------------------------------------------------*
PROCEDURE Mpm_DiskPaths( cFileCfg )
*---------------------------------------------------------------------*
   LOCAL aDiskOld := {}
   LOCAL cDiskNew := Upper( DiskName() ) + ":\"
   LOCAL cTexto   := MemoRead( cFileCfg )

   For i := 1 To MLCount ( cTexto )
       cLine := AllTrim ( MemoLine( cTexto , , i ) )
       If "PRGEDITOR" $ cLine .OR. "FCOMPRESS" $ cLine .OR. "FMGEDITOR" $ cLine .OR. "VISUALFOLDER" $ cLine ;
          .OR. "MINGWFOLDER" $ cLine .OR. "BCCFOLDER" $ cLine .OR. "PELLESFOLDER" $ cLine .OR. "EXTERNAL" $ cLine ;
          .OR. "HBMINGW" $ cLine .OR. "HBBCC" $ cLine .OR. "HBPELLES" $ cLine .OR. "HBVISUAL" $ cLine ;
          .OR. "XHBMINGW" $ cLine .OR. "XHBBCC" $ cLine .OR. "XHBPELLES" $ cLine .OR. "XHBVISUAL" $ cLine
       Else
          cDisk := SubStr( cLine, AtNum( ":\", cLine )-1, 3 )
          If (cDisk <> cDiskNew) .and. SubStr( cDisk, 2, 2 )==":\"
             Aadd( aDiskOld, cDisk )
          Endif
       Endif
   Next

   For n := 1 to Len(aDiskOld)
       cTexto := StrTran( cTexto, (aDiskOld[n]), cDiskNew )
   Next

   Hb_MemoWrit( cFileCfg, cTexto )

RETURN

*---------------------------------------------------------------------*
Procedure Publicar
*---------------------------------------------------------------------*
   Local  cDiskNew       := Upper(DiskName()) + ":\"
//   Local  cDiskNew       := Upper( hb_CurDrive () ) + ":\"
//   Local  cPath          := hb_CurDrive () + hb_osDriveSeparator () + hb_ps () + CurDir ()
   Public cAppVer        := "v."+substr(__DATE__,3,2)+"."+right(__DATE__,4)
   Public ProjectName    := ''
   Public DebugActive    := .F.
   Public Processing     := .F.
   Public MakeName, ParamString, Split1
   Public i, cDados, x1, cLib
   Public CPROJFOLDER    := ''
   Public Folder, WATHGUI, cOldPath
   Public cStartTime, cOBJ_Dir
   Public Exename        := ''
   Public HARBOURFOLDER  := ''
   Public MINIGUIFOLDER  := cDiskNew+'oohg'
   Public PROJECTFOLDER  := ''
   Public EXEOUTPUTNAME  := ''
   Public CCFOLDER       := ''
   Public BCCFOLDER      := ''
   Public OBJFOLDER      := ''
   Public LIBFOLDER      := ''
   Public INCFOLDER      := ''
   Public FMGFOLDER      := ''
   Public INCLUDEFOLDER  := ''
   Public USERFLAGS      := ''
   Public USERCFLAGS     := ''
   Public USERLFLAGS     := ''
   Public INCREMENTAL    := 1
   Public WITHGTMODE     := 1
   Public WITHDEBUG      := 1
   Public OUTPUTFILE     := 1
   Public CCOMPILER      := 1
   Public HBCHOICE       := 1
   Public GUICHOICE      := 1
   Public WLEVEL         := 1
   Public INCREMENTAL    := 1
   Public PRGFILES       := {}
   Public FMGFILES       := {}
   Public LIBFILES       := {}
   Public CFILES         := {}
   Public MINGW32FOLDER  := ''
   Public CCOMPFOLDER    := ''
   Public Out            := ''
   Public OpmFolder      := GetStartupFolder()

   public cPrgEditor     := 'notepad.exe'
   public cFCompress     := 'upx.exe'
   public cFmgEditor     := 'oide.exe'

   public cGuiHbMinGW    := cDiskNew+'oohg'
   public cGuiHbBCC      := cDiskNew+'oohg'
   public cGuiHbPelles   := cDiskNew+'oohg'
   public cGuiHbVisual   := cDiskNew+'oohg'

   public cGuixHbMinGW   := cDiskNew+'oohg'
   public cGuixHbBCC     := cDiskNew+'oohg'
   public cGuixHbPelles  := cDiskNew+'oohg'
   public cGuixHbVisual  := cDiskNew+'oohg'

   public cHbMinGWFolder := cDiskNew+'harbourm'
   public cHbBCCFolder   := cDiskNew+'harbourb'
   public cHbPellFolder  := cDiskNew+'harbourp'
   public cHbVisuaFolder := cDiskNew+'harbourv'

   public cxHbMinGWFolder:= cDiskNew+'xharbourm'
   public cxHbBCCFolder  := cDiskNew+'xharbourb'
   public cxHbPellFolder := cDiskNew+'xharbourp'
   public cxHbVisuaFolder:= cDiskNew+'xharbourv'

   public cMinGWFolder   := cDiskNew+'MinGW'
   public cBCCFolder     := cDiskNew+'Borland\BCC55'
   public cPellFolder    := cDiskNew+'PellesC'
   public cVisualFolder  := cDiskNew+'Archivos de programa\Microsoft Visual Studio 10.0\VC'

   SET TOOLTIPSTYLE BALLOON
   SET TOOLTIPBACKCOLOR  {255,0,0 }
   SET TOOLTIPFORECOLOR  YELLOW

Return

*---------------------------------------------------------------------*
Procedure AddListFile(nExt)
*---------------------------------------------------------------------*
    If nExt     == 1
       main.tab_2.value := 1
       AddPrgFiles()
    ElseIf nExt == 2
       main.tab_2.value := 1
       AddCFiles()
    ElseIf nExt == 3
       main.tab_2.value := 2
       AddFmgFiles()
    ElseIf nExt == 4
       main.tab_2.value := 3
       AddRcFiles()
    Endif
Return

*---------------------------------------------------------------------*
Procedure RemoveFile()
*---------------------------------------------------------------------*
    If main.tab_2.value == 1
       main.tab_2.value := 1
       RemoveFilePrg()
    ElseIf main.tab_2.value == 1
       main.tab_2.value := 1
       RemoveFilePrg()
    ElseIf main.tab_2.value == 2
       main.tab_2.value := 2
       RemoveFileFmg()
    ElseIf main.tab_2.value == 3
       main.tab_2.value := 3
       RemoveFileRc()
    Endif
Return

*---------------------------------------------------------------------*
Procedure EditProgram
*---------------------------------------------------------------------*
   Local Editor, EdiFmg

   If main.tab_2.value == 1
      If main.list_1.ItemCount > 0
         if Empty(main.List_1.Value)
            main.List_1.Value := {1,1}
            main.List_1.SetFocus
         Endif
         x1 := main.list_1.value[ 1 ]
         x3 := main.list_1.Item( x1 )
         If !Empty( x1 )
            If Empty ( main.Text_15.Value ) .OR. Empty ( main.Text_31.Value )
               MsgStop ('Program Editor Not Defined','Operation Aborted')
            Else
               If Upper(Right(x3,3))='FMG'
                  EdiFmg := AllTrim( main.Text_31.Value )
                  EXECUTE FILE EdiFmg PARAMETERS DelExt( x3 )
               Else
                  Editor := AllTrim( main.Text_15.Value )
                  EXECUTE FILE Editor PARAMETERS x3
               Endif
            EndIf
         EndIf
      Endif
   ElseIf main.tab_2.value == 2
      If main.list_3.ItemCount > 0
         if Empty(main.List_3.Value)
            main.List_3.Value := {1,1}
            main.List_3.SetFocus
         Endif
         x1 := main.list_3.value[ 1 ]
         x3 := main.list_3.Item( x1 )
         If !Empty( x1 )
            If Empty ( main.Text_15.Value ) .OR. Empty ( main.Text_31.Value )
               MsgStop ('Program Editor Not Defined','Operation Aborted')
            Else
               If Upper(Right(x3,3))='FMG'
                  EdiFmg := AllTrim( main.Text_31.Value )
                  EXECUTE FILE EdiFmg PARAMETERS DelExt( x3 )
               Else
                  Editor := AllTrim( main.Text_15.Value )
                  EXECUTE FILE Editor PARAMETERS x3
               Endif
            EndIf
         EndIf
      Endif
   ElseIf main.tab_2.value == 3
      If main.list_4.ItemCount > 0
         if Empty(main.List_4.Value)
            main.List_4.Value := {1,1}
            main.List_4.SetFocus
         Endif
         x1 := main.list_4.value[ 1 ]
         x3 := main.list_4.Item( x1 )
         If !Empty( x1 )
            If Empty ( main.Text_15.Value ) .OR. Empty ( main.Text_31.Value )
               MsgStop ('Program Editor Not Defined','Operation Aborted')
            Else
               If Upper(Right(x3,3))='FMG'
                  EdiFmg := AllTrim( main.Text_31.Value )
                  EXECUTE FILE EdiFmg PARAMETERS DelExt( x3 )
               Else
                  Editor := AllTrim( main.Text_15.Value )
                  EXECUTE FILE Editor PARAMETERS x3
               Endif
            EndIf
         EndIf
      Endif
   Endif
Return

*---------------------------------------------------------------------*
Procedure SetTop
*---------------------------------------------------------------------*
   Local i , i1 , is

   If main.tab_2.value == 1
      If main.list_1.ItemCount > 0
         if !Empty(main.List_1.Value)
            i := main.List_1.Value[ 1 ]
            If i <> 1 .or. i <> 0
               i1 := main.List_1.Item( 1 )
               is := main.List_1.Item( main.List_1.Value[ 1 ] )
               main.List_1.Item( main.List_1.Value[ 1 ] ) := i1
               main.List_1.Item( 1 ) := is
               main.List_1.Value := {1,1}
               main.List_1.SetFocus
               MsgInfo ( is + ' Is The New Project Top File','Top File' )
            Endif
         Endif
      Endif
   Endif

Return

*---------------------------------------------------------------------*
Procedure OpenMPM2( ProjectFile ) // Versión antigüa de .mpm
*---------------------------------------------------------------------*

   Local ConfigFile , ConfigFileName , i , Line

   ConfigFileName := ProjectFile
   cProjExt       := UPPER(GetExt(ConfigFileName))

   If !Empty (ConfigFilename)
      DO CASE
      CASE cProjExt == '.MPM'
         ProjectName := ConfigFileName
         Main.Title := ' [ ' + AllTrim ( ProjectName ) + ' ]'
         StartCtrls()
         ConfigFile := MemoRead	( ConfigFileName )
         For i := 1 To MLCount ( ConfigFile )
          Line := AllTrim ( MEMOLINE( ConfigFile , , i ) )
          If Upper (Line) = 'PROJECTFOLDER'
             main.text_1.Value := SubStr ( Line , 15 , 255 )
             If !main.text_1.Value = CurrentFolderUpperDrv()
                cOldPath := main.text_1.Value
                main.text_1.Value := CurrentFolderUpperDrv()
             Else
                cOldPath := main.text_1.Value
             Endif
          ElseIf Upper (Line) = 'EXEOUTPUTNAME'
             main.text_2.Value := SubStr ( Line , 15 , 255 )
          ElseIf Upper (Line) = 'OBJFOLDER'
            main.text_5.Value := SubStr ( Line , 11 , 255 )
          ElseIf Upper (Line) = 'LIBFOLDER'
             If !Empty(SubStr(Upper(Line),11,3))
                Line := ChangeDrvMpm('LIBFOLDER',Line)
             Endif
             main.text_6.Value := SubStr ( Line , 11 , 255 )
          ElseIf Upper (Line) = 'INCLUDEFOLDER'
             If !Empty(SubStr(Upper(Line),15,3))
                Line := ChangeDrvMpm('INCLUDEFOLDER',Line)
             Endif
             main.text_7.Value := SubStr ( Line , 15 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOCCOMP1'
            main.text_12.Value := SubStr ( Line , 15 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOCCOMP2'
            main.text_32.Value := SubStr ( Line , 15 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOCCOMP3'
            main.text_42.Value := SubStr ( Line , 15 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOCCOMP4'
            main.text_52.Value := SubStr ( Line , 15 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOLINKER1'
            main.text_13.Value := SubStr ( Line , 16 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOLINKER2'
            main.text_33.Value := SubStr ( Line , 16 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOLINKER3'
            main.text_43.Value := SubStr ( Line , 16 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOLINKER4'
            main.text_53.Value := SubStr ( Line , 16 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOHARBOUR1'
            main.text_24.Value := SubStr ( Line , 17 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOHARBOUR2'
            main.text_44.Value := SubStr ( Line , 17 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOHARBOUR3'
            main.text_54.Value := SubStr ( Line , 17 , 255 )
          ElseIf Upper (Line) = 'FLAGSTOHARBOUR4'
            main.text_64.Value := SubStr ( Line , 17 , 255 )
          ElseIf	Upper (Line) = 'HBWARNINGLEVEL1'
            main.RadioGroup_1.Value := val(SubStr ( Line , 17 , 1 ))
          ElseIf	Upper (Line) = 'HBWARNINGLEVEL2'
            main.RadioGroup_21.Value := val(SubStr ( Line , 17 , 1 ))
          ElseIf	Upper (Line) = 'HBWARNINGLEVEL3'
            main.RadioGroup_31.Value := val(SubStr ( Line , 17 , 1 ))
          ElseIf	Upper (Line) = 'HBWARNINGLEVEL4'
            main.RadioGroup_41.Value := val(SubStr ( Line , 17 , 1 ))
          ElseIf	Upper (Line) = 'INCREMENTAL'
            main.RadioGroup_4.Value := val(SubStr ( Line , 13 , 1 ))
          ElseIf	Upper (Line) = 'WITHGTMODE'
            main.RadioGroup_3.Value := val(SubStr ( Line , 12 , 1 ))
          ElseIf	Upper (Line) = 'WITHDEBUG'
            main.RadioGroup_2.Value := val(SubStr ( Line , 11 , 1 ))
          ElseIf	Upper (Line) = 'OUTPUTFILE'
            main.RadioGroup_7.Value := val(SubStr ( Line , 12 , 1 ))
          ElseIf Upper (Line) = 'CCOMPILER'
            main.RadioGroup_6.Value := val(SubStr ( Line , 11 , 1 ))
          ElseIf Upper (Line) = 'HBCHOICE'
            main.RadioGroup_5.Value := val(SubStr ( Line , 10 , 1 ))
          ElseIf	Right ( Upper ( Line) , 4 ) == '.PRG'
             If SubStr(Line,2,2) == ':\'
                Line := ChangeDrvSource(Line)
                Line := PathChange(Line,2)
             ElseIF SubStr(Line,1,11) == "PathProject"
                Line := PathChange(Line,0)
             ElseIf Empty( cOldPath )
                Line := PathChange(Line,2)
             Endif
             main.List_1.AddItem( { AllTrim(Line) } )
          ElseIf	Right ( Upper ( Line) , 2 ) == '.C'
             If SubStr(Line,2,2) == ':\'
                Line := ChangeDrvSource(Line)
                Line := PathChange(Line,2)
             ElseIf SubStr(Line,1,11) == "PathProject"
                Line := PathChange(Line,0)
             Else
                cOldPath := ""
                Line := PathChange(Line,2)
             Endif
             main.List_1.AddItem( { AllTrim(Line) } )
          ElseIf	Right ( Upper ( Line) , 4 ) == '.FMG'
             If SubStr(Line,2,2) == ':\'
                Line := PathChange(Line,2)
             ElseIf SubStr(Line,1,11) == "PathProject"
                Line := PathChange(Line,0)
             Else
                cOldPath := ""
                Line := PathChange(Line,2)
             Endif
             main.List_1.AddItem( { AllTrim(Line) } )
          ElseIf	Right ( Upper ( Line) , 4 ) == '.LIB'
             If SubStr(Line,2,2) == ':\'
                Line := ChangeDrvSource(Line)
             Else
                MsgInfo("The path of the Library is needed, please re-enter file")
             Endif
             main.List_2.AddItem( AllTrim(Line) )
          ElseIf	Right ( Upper ( Line) , 2 ) == '.A'
             If SubStr(Line,2,2) == ':\'
                Line := ChangeDrvSource(Line)
             Endif
             main.List_2.AddItem( AllTrim(Line) )
          EndIf
         Next i

         If !File( main.List_1.Item(1) )
            MsgInfo("Please add the source files again","File not found !!!")
         Endif

         If empty(main.text_1.Value)
             main.text_1.Value := CurrentFolderUpperDrv()
         Endif
      CASE cProjExt == '.PRG'
           StartCtrls()
           ProjectName := DelExt(ConfigFileName)
           SaveAs()
           main.List_1.DeleteAllItems
           main.List_1.AddItem( ConfigFileName )
           main.text_1.Value := CurrentFolderUpperDrv()
      ENDCASE
   EndIf

   main.Tab_1.Value := 1

Return
*---------------------------------------------------------------------*
Procedure ChangeDrvMpm(cLabel,cLine)
*---------------------------------------------------------------------*
   If !SubStr (  Upper(cLine) , Len(cLabel)+2, 3 ) == Upper(hb_CurDrive())+':\'
      cLine := SubStr(cLine,1,Len(cLabel)-1)+Upper(hb_CurDrive())+':\'+SubStr(cLine,Len(cLabel)+5,255)
   Endif
Return(cLine)
*---------------------------------------------------------------------*
Procedure ChangeDrvSource(cLine)
*---------------------------------------------------------------------*
   If !Left ( Upper ( cLine) , 3 ) == Upper(hb_CurDrive())+':\'
       cLine := Upper(hb_CurDrive())+':\'+SubStr(cLine,4,255)
   Endif
Return(cLine)
*---------------------------------------------------------------------*
Procedure OpenMPM( ProjectFile ) // Versión nueva de .mpm
*---------------------------------------------------------------------*

   Local cDiskNew := Upper(Hb_CurDrive()) + ":\", c := ''
   Local nTotSou  := 0 , nTotLib := 0, cFile := '',i,i2,i3,i4
   Local nTotFmg  := 0 , nTotRc  := 0

   main.List_1.DeleteAllItems
   main.List_2.DeleteAllItems
   main.List_3.DeleteAllItems
   main.List_4.DeleteAllItems

   IF EMPTY(ProjectFile) .OR. ValType ( ProjectFile ) == 'U'
      ConfigFileName := GetFile( { {'MPM Project Files','*.mpm'},{'PRG Source Files', '*.prg'} } , 'Open Project' )
   Else
      ConfigFileName := ProjectFile
   ENDIF

   If !Empty (ConfigFilename) .and. UPPER(GetExt(ConfigFileName)) = '.MPM'
       ProjectName := ConfigFileName
       
       Main.Title := ' [ ' + AllTrim ( ProjectName ) + ' ]'

       Mpm_DiskPaths(ProjectName)

       BEGIN INI FILE ConfigFileName

         GET main.text_1.value       SECTION 'PROJECT'    ENTRY "PROJECTFOLDER"
             If !main.text_1.Value = CurrentFolderUpperDrv()
                cOldPath := main.text_1.Value
                main.text_1.Value := CurrentFolderUpperDrv()
             Else
                cOldPath := main.text_1.Value
             Endif

         GET main.text_2.value       SECTION 'PROJECT'    ENTRY "EXEOUTPUTNAME"
         GET main.text_5.value       SECTION 'PROJECT'    ENTRY "OBJFOLDER"
             main.text_5.value := ChgPathToReal( main.text_5.value )
         GET main.text_6.value       SECTION 'PROJECT'    ENTRY "LIBFOLDER"
             main.text_6.value := ChgPathToReal( main.text_6.value )
         GET main.text_7.value       SECTION 'PROJECT'    ENTRY "INCLUDEFOLDER"
             main.text_7.value := ChgPathToReal( main.text_7.value )

         GET main.text_24.value      SECTION 'FLAGSHB'    ENTRY "FLAGSTOHARBOUR1" DEFAULT ''
         GET main.text_44.value      SECTION 'FLAGSHB'    ENTRY "FLAGSTOHARBOUR2" DEFAULT ''
         GET main.text_54.value      SECTION 'FLAGSHB'    ENTRY "FLAGSTOHARBOUR3" DEFAULT ''
         GET main.text_64.value      SECTION 'FLAGSHB'    ENTRY "FLAGSTOHARBOUR4" DEFAULT ''

         GET main.text_12.value      SECTION 'FLAGSCCMP'  ENTRY "FLAGSTOCCOMP1"   DEFAULT ''
         GET main.text_32.value      SECTION 'FLAGSCCMP'  ENTRY "FLAGSTOCCOMP2"   DEFAULT ''
         GET main.text_42.value      SECTION 'FLAGSCCMP'  ENTRY "FLAGSTOCCOMP3"   DEFAULT ''
         GET main.text_52.value      SECTION 'FLAGSCCMP'  ENTRY "FLAGSTOCCOMP4"   DEFAULT ''

         GET main.text_13.value      SECTION 'FLAGSCLNK'  ENTRY "FLAGSTOLINKER1"  DEFAULT ''
         GET main.text_33.value      SECTION 'FLAGSCLNK'  ENTRY "FLAGSTOLINKER2"  DEFAULT ''
         GET main.text_43.value      SECTION 'FLAGSCLNK'  ENTRY "FLAGSTOLINKER3"  DEFAULT ''
         GET main.text_53.value      SECTION 'FLAGSCLNK'  ENTRY "FLAGSTOLINKER4"  DEFAULT ''

         GET main.RadioGroup_5.value SECTION 'COMPILER'   ENTRY "HBCHOICE"        DEFAULT 1
         GET main.RadioGroup_6.value SECTION 'COMPILER'   ENTRY "CCOMPILER"       DEFAULT 1
         GET main.RadioGroup_7.value SECTION 'FILETYPE'   ENTRY "OUTPUTFILE"      DEFAULT 1

         GET main.RadioGroup_3.value SECTION 'INTERFASE'  ENTRY "WITHGTMODE"      DEFAULT 1
         GET main.RadioGroup_2.value SECTION 'ENABDEBUG'  ENTRY "WITHDEBUG"       DEFAULT 1
         GET main.RadioGroup_4.value SECTION 'COMPTYPE'   ENTRY "INCREMENTAL"     DEFAULT 1

         GET nTotSou                 SECTION 'NFILES'     ENTRY "TOTSOUFILES"     DEFAULT 0
         GET nTotLib                 SECTION 'NFILES'     ENTRY "TOTLIBFILES"     DEFAULT 0
         GET nTotFmg                 SECTION 'NFILES'     ENTRY "TOTFMGFILES"     DEFAULT 0
         GET nTotRc                  SECTION 'NFILES'     ENTRY "TOTRCFILES"      DEFAULT 0


         If nTotSou > 0
            For i := 1 To nTotSou
                DO EVENTS
                GET  cFile   SECTION 'SOURCE'  ENTRY "SCRFILE"+AllTrim(Str(i))
                cFile := ChgPathToReal( cFile )
                If !Empty(cFile)
                   main.List_1.AddItem( AllTrim(cFile) )
                Endif
            Next i
            If !File( main.List_1.Item(1) )
                MsgInfo("Please add the source files again","File not found !!!")
            Endif
         Endif
         if nTotLib > 0
            For i2 := 1 To nTotLib
                DO EVENTS
                GET cFile   SECTION 'LIBRARY'  ENTRY "LIBFILE"+AllTrim(Str(i2))
                cFile := ChgPathToReal( cFile )
                If !Empty(cFile)
                   main.List_2.AddItem( AllTrim( cFile ) )
                Endif
            Next i2
         Endif
         if nTotFmg > 0
            For i3 := 1 To nTotFmg
                DO EVENTS
                GET cFile   SECTION 'INCLUDE'  ENTRY "FMGFILE"+AllTrim(Str(i3))
                cFile := ChgPathToReal( cFile )
                If !Empty(cFile)
                   main.List_3.AddItem( AllTrim( cFile ) )
                Endif
            Next i3
         Endif
         if nTotRc > 0
            For i4 := 1 To nTotRc
                DO EVENTS
                GET cFile   SECTION 'RESOURCE'  ENTRY "RCFILE"+AllTrim(Str(i4))
                cFile := ChgPathToReal( cFile )
                If !Empty(cFile)
                   main.List_4.AddItem( AllTrim( cFile ) )
                Endif
            Next i4
         Endif

       END INI

   Endif

   main.Tab_1.Value := 1

   If Empty(main.text_1.value) .OR. main.List_1.ItemCount == 0
      OpenMPM2( ConfigFileName )
   Endif

Return
*---------------------------------------------------------------------*
Function CurrentFolderUpperDrv()
*---------------------------------------------------------------------*
   Local cDrv := GetCurrentFolder()
   Local cUnd, cRes, cDrvDir := ""
   If SubStr(cDrv,2,2) == ':\'
      cUnd    := Upper(Left(cDrv,3))
      cRes    := SubStr(cDrv,4,Len(cDrv))
      cDrvDir := cUnd + cRes
   Else
      cDrvDir := cDrv
   Endif
Return(cDrvDir)

*---------------------------------------------------------------------*
Procedure PathChange( cFile, nPath )
*---------------------------------------------------------------------*

    cPath := FilPath( cFile )

    If IsEqualPath( cPath ) .OR. Left(AllTrim(cFile),11) = "PathProject"
       DO CASE
          CASE nPath = 0                      // To Real
               cPath := Stuff( cFile, 1, Len("PathProject"), AllTrim(main.text_1.value) )
          CASE nPath = 1                      // To Relative
               If SubStr(cFile,2,2) == ':\'
                  cPath := Stuff( cFile, 1, Len(AllTrim(main.text_1.value)), "PathProject")
               Else
                  cPath := "PathProject\"+cFile
               Endif
          CASE nPath = 2                      // Interchange
               If Empty( cOldPath )
                  cPath := iif(empty(AllTrim(main.text_1.value)),cFile,AllTrim(main.text_1.value)+"\"+cfile )
               Else
                  cPath := Stuff( cFile, 1, Len(cOldPath) , AllTrim(main.text_1.value) )
               Endif
       ENDCASE
   Else
       // cPath := cFile
       If AT(Upper(cFile),Upper(CurrentFolderUpperDrv())) <> 0 .OR. Left(AllTrim(cFile),10) = "ThisFolder"

       //If SubStr( AllTrim( cFile ),1,Len( CurrentFolderUpperDrv() ) )  == CurrentFolderUpperDrv() .OR. Left(AllTrim(cFile),10) = "ThisFolder"
           If nPath = 0
              cPath := Stuff( cFile, 1, Len( "ThisFolder" ), CurrentFolderUpperDrv() )
              //MsgInfo(cPath, "Thisfolder 0")
           Endif
           If nPath = 1
              cPath := Stuff( cFile, 1, Len(CurrentFolderUpperDrv()), "ThisFolder" )
              //MsgInfo(cPath, "Thisfolder 1")
           Endif
           If nPath = 2
              cPath := cFile
              //MsgInfo(cPath, "Thisfolder 2")
           Endif
       Else
           cPath := cFile
           //MsgInfo(cPath, "Thisfolder Else")
       Endif

   Endif

   //MsgInfo(cPath, cOldPath+"cOldPath Fuera")

Return( cPath )

Function ChgPathToReal( cPath )
   cPath := StrTran( cPath , "PathProject" , AllTrim(main.text_1.value) )
   cPath := StrTran( cPath , "ThisFolder" ,  AllTrim(main.text_1.value) )
Return( cPath )

Function ChgPathToRelative( cPath )
   cPath := StrTran( cPath, AllTrim(main.text_1.value), "PathProject" )
   cPath := StrTran( cPath, AllTrim(main.text_1.value), "ThisFolder" )
Return( cPath )

*---------------------------------------------------------------------*
Procedure New()
*---------------------------------------------------------------------*
   Local r

   r := MsgYesNo ('Do you want to save current project')

   If r == .T.
      If Empty(ProjectName)
         SaveAs()
      Else
         Save()
      EndIf
   EndIf
   BorraTemporales()
   ProjectName := ''
   Main.Title  := ' [ New Project ]'

   StartCtrls()
   OpenMPM()

Return
*---------------------------------------------------------------------*
Procedure CorreBuildBat()
*---------------------------------------------------------------------*
   Local cOs := UPPER(GETE('os'))

   if len(cos)== 0
      cOs := GETE('os_type')
   endif

   If cos == 'WINDOWS_NT'
      WaitRun( "_Build.Bat",0 )
   Else
      EXECUTE FILE PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + '_Build.Bat' WAIT
   Endif

Return
*---------------------------------------------------------------------*
Procedure StatusRefresh()
*---------------------------------------------------------------------*
   If Processing
      main.Tab_1.Value := 7
      If File ( PROJECTFOLDER + '\End.Txt' )
         main.RichEdit_1.Value := TranslateLog ( MemoRead ( PROJECTFOLDER + '\_Temp.Log' ) )
         Processing := .F.
         Procesando(2)
         CursorArrow2()
         BorraTemporales()
      Endif
   Endif
   DO EVENTS
Return
*---------------------------------------------------------------------*
Procedure BorraTemporales()
*---------------------------------------------------------------------*

      Local x3 := "", x1 := ""

      If main.list_1.ItemCount > 0
         if Empty(main.List_1.Value)
            main.List_1.Value := {1,1}
         Endif
         x1 := main.list_1.value[ 1 ]
         x3 := DelExt(GetName(main.list_1.Item( x1 )))
      Endif

      oPath := AllTrim(main.Text_1.value)
      oFile := AllTrim(main.Text_2.value)

      Ferase(oPath +'\'+'_Build.log')
      Ferase(oPath +'\'+'_Build.bat')
      Ferase(oPath +'\'+'b32.bc')
      Ferase(oPath +'\'+'p32.bc')
      Ferase(oPath +'\'+'p32.pc')
      Ferase(oPath +'\'+'End.txt')
      Ferase(oPath +'\'+'Makefile.Gcc')
      Ferase(oPath +'\'+'error.lst')
      Ferase(oPath +'\'+x3+'.res')
      Ferase(oPath +'\'+x3+'.map')
      Ferase(oPath +'\'+x3+'.tds')
      Ferase(oPath +'\'+'_Temp.bc')
      Ferase(oPath +'\'+'_Temp.rc')
      Ferase(oPath +'\'+'_Temp.res')
      Ferase(oPath +'\'+'_Temp.o')
      Ferase(oPath +'\'+oFile+'.map')
      Ferase(oPath +'\'+oFile+'.tds')
      Ferase(oPath +'\'+'MigMem.mem')
      Ferase(MINIGUIFOLDER+"\resources\_temp.rc" )
      Ferase(MINIGUIFOLDER+"\resources\_temp.res" )
      Ferase(MINIGUIFOLDER+"\resources\_temp.o" )
      Ferase(Exename+'\'+'.res')
      Ferase(Exename+'\'+'.map')
      Ferase(Exename+'\'+'.tds')

Return
*---------------------------------------------------------------------*
Procedure Procesando( nOpt )
*---------------------------------------------------------------------*
   Do Case
      Case nOpt == 1
           Main.StatusBar.Item(2) := 'Status: Building...'
           Main.StatusBar.Icon(2) := 'Process'
      Case nOpt == 2
           Main.StatusBar.Item(2) := 'Status: Idle...'
           Main.StatusBar.Icon(2) := 'Build'
   Endcase
Return
*---------------------------------------------------------------------*
FUNCTION PonerEspera( cMensaje)
*---------------------------------------------------------------------*

   cStartTime := Time()
   DEFINE WINDOW MigMess AT 323,389 WIDTH 277 HEIGHT 80 TITLE cAppName ;
      MODAL NOMINIMIZE NOMAXIMIZE NOSIZE NOSYSMENU NOCAPTION BACKCOLOR {255,0,0}

       @ 20,0 LABEL lblMensajes VALUE AllTrim(cMensaje) WIDTH 267 SIZE 16 ;
         FONTCOLOR YELLOW CENTERALIGN BOLD TRANSPARENT

   END WINDOW

   CENTER WINDOW MigMess
   ACTIVATE WINDOW MigMess NOWAIT

   CURSORWAIT2()
RETURN(NIL)

*---------------------------------------------------------------------*
FUNCTION QuitarEspera( )
*---------------------------------------------------------------------*

   if iswindowdefined("MigMess")
      CURSORARROW2( )
      RELEASE WINDOW MigMess
      DO EVENTS
   Endif

RETURN(NIL)
*---------------------------------------------------------------------*
Procedure StartCtrls()
*---------------------------------------------------------------------*

   main.text_1.Value          := ''         //Project source path
   main.text_2.Value          := ''         //Output file name
   main.text_5.Value          := ''         //Obj path
   main.text_6.Value          := ''         //Lib path
   main.text_7.Value          := ''         //Include path
   main.text_12.Value         := ''         //Flags - Compiler
   main.text_32.Value         := ''         //Flags - Compiler
   main.text_42.Value         := ''         //Flags - Compiler
   main.text_52.Value         := ''         //Flags - Compiler
   main.text_13.Value         := ''         //Flags - Linker
   main.text_33.Value         := ''         //Flags - Linker
   main.text_43.Value         := ''         //Flags - Linker
   main.text_53.Value         := ''         //Flags - Linker
   main.text_24.Value         := ''         //Flags - (x)Harbour
   main.text_44.Value         := ''         //Flags - (x)Harbour
   main.text_54.Value         := ''         //Flags - (x)Harbour
   main.text_64.Value         := ''         //Flags - (x)Harbour
   main.RadioGroup_1.Value    :=  1         //Level - Warning Harbour
   main.RadioGroup_21.Value   :=  1         //Level - Warning Harbour
   main.RadioGroup_31.Value   :=  1         //Level - Warning Harbour
   main.RadioGroup_41.Value   :=  1         //Level - Warning Harbour
   main.RadioGroup_4.Value    :=  1         //Incremental - Rebuild
   main.RadioGroup_3.Value    :=  1         //GUI - Console - Mixed
   main.RadioGroup_2.Value    :=  1         //Normal-Debug
   main.RadioGroup_7.Value    :=  1         //Exe - Lib
   main.RadioGroup_6.Value    :=  1         //MinGW - BCC - Pelles C - Visual C
   main.RadioGroup_5.Value    :=  1         //Harbour - xHarbour
   main.RichEdit_1.Value      := ''
   main.List_1.DeleteAllItems
   main.List_2.DeleteAllItems

Return
*---------------------------------------------------------------------*
Procedure Save
*---------------------------------------------------------------------*

   SaveProject()
   SaveEnvironment()

Return

*---------------------------------------------------------------------*
Procedure SaveProject()  // Guarda variables en carpeta de mpm
*---------------------------------------------------------------------*
   Local c:= '', i, ii
   If Empty ( ProjectName )
      SaveAs()
      Return
   Else
      Ferase(ProjectName)
   EndIf

   BEGIN INI FILE ProjectName

         SET SECTION 'PROJECT'    ENTRY "PROJECTFOLDER"   TO main.text_1.value
         SET SECTION 'PROJECT'    ENTRY "EXEOUTPUTNAME"   TO main.text_2.value
         SET SECTION 'PROJECT'    ENTRY "OBJFOLDER"       TO ChgPathToRelative(main.text_5.value)
         SET SECTION 'PROJECT'    ENTRY "LIBFOLDER"       TO ChgPathToRelative(main.text_6.value)
         SET SECTION 'PROJECT'    ENTRY "INCLUDEFOLDER"   TO ChgPathToRelative(main.text_7.value)

         SET SECTION 'FLAGSHB'    ENTRY "FLAGSTOHARBOUR1" TO main.text_24.value
         SET SECTION 'FLAGSHB'    ENTRY "FLAGSTOHARBOUR2" TO main.text_44.value
         SET SECTION 'FLAGSHB'    ENTRY "FLAGSTOHARBOUR3" TO main.text_54.value
         SET SECTION 'FLAGSHB'    ENTRY "FLAGSTOHARBOUR4" TO main.text_64.value

         SET SECTION 'FLAGSCCMP'  ENTRY "FLAGSTOCCOMP1"   TO main.text_12.value
         SET SECTION 'FLAGSCCMP'  ENTRY "FLAGSTOCCOMP2"   TO main.text_32.value
         SET SECTION 'FLAGSCCMP'  ENTRY "FLAGSTOCCOMP3"   TO main.text_42.value
         SET SECTION 'FLAGSCCMP'  ENTRY "FLAGSTOCCOMP4"   TO main.text_52.value

         SET SECTION 'FLAGSCLNK'  ENTRY "FLAGSTOLINKER1"  TO main.text_13.value
         SET SECTION 'FLAGSCLNK'  ENTRY "FLAGSTOLINKER2"  TO main.text_33.value
         SET SECTION 'FLAGSCLNK'  ENTRY "FLAGSTOLINKER3"  TO main.text_43.value
         SET SECTION 'FLAGSCLNK'  ENTRY "FLAGSTOLINKER4"  TO main.text_53.value

         SET SECTION 'COMPILER'   ENTRY "HBCHOICE"        TO main.RadioGroup_5.value
         SET SECTION 'COMPILER'   ENTRY "CCOMPILER"       TO main.RadioGroup_6.value

         SET SECTION 'FILETYPE'   ENTRY "OUTPUTFILE"      TO main.RadioGroup_7.value
         SET SECTION 'INTERFASE'  ENTRY "WITHGTMODE"      TO main.RadioGroup_3.value
         SET SECTION 'ENABDEBUG'  ENTRY "WITHDEBUG"       TO main.RadioGroup_2.value
         SET SECTION 'COMPTYPE'   ENTRY "INCREMENTAL"     TO main.RadioGroup_4.value

         SET SECTION 'NFILES'     ENTRY "TOTSOUFILES"     TO main.List_1.ItemCount
         SET SECTION 'NFILES'     ENTRY "TOTLIBFILES"     TO main.List_2.ItemCount
         SET SECTION 'NFILES'     ENTRY "TOTFMGFILES"     TO main.List_3.ItemCount
         SET SECTION 'NFILES'     ENTRY "TOTRCFILES"      TO main.List_4.ItemCount

         If main.List_1.ItemCount > 0
            For i := 1 To main.List_1.ItemCount
                c := ChgPathToRelative( AllTrim(main.List_1.Item(i) ) )
                SET SECTION 'SOURCE'  ENTRY "SCRFILE"+AllTrim(Str(i))  TO c
                c := ''
            Next i
         Endif
         If main.List_2.ItemCount > 0
            For i2 := 1 To main.List_2.ItemCount
                c := c +  AllTrim(main.List_2.Item(i2))
                c := ChgPathToRelative( AllTrim(main.List_2.Item(i2) ) )
                SET SECTION 'LIBRARY'  ENTRY "LIBFILE"+AllTrim(Str(i2))  TO c
                c := ''
            Next i2
         Endif
         If main.List_3.ItemCount > 0
            For i3 := 1 To main.List_3.ItemCount
                c := c +  AllTrim(main.List_3.Item(i3))
                c := ChgPathToRelative( AllTrim(main.List_3.Item(i3) ) )
                SET SECTION 'INCLUDE'  ENTRY "FMGFILE"+AllTrim(Str(i3))  TO c
                c := ''
            Next i3
         Endif
         If main.List_4.ItemCount > 0
            For i4 := 1 To main.List_4.ItemCount
                c := c +  AllTrim(main.List_4.Item(i4))
                c := ChgPathToRelative( AllTrim(main.List_4.Item(i4) ) )
                SET SECTION 'RESOURCE'  ENTRY "RCFILE"+AllTrim(Str(i4))  TO c
                c := ''
            Next i4
         Endif

   END INI

Return
*---------------------------------------------------------------------*
Procedure SaveAs()
*---------------------------------------------------------------------*
   Local TmpName

   TmpName := AllTrim ( PutFile( { {'MPM Project Files','*.mpm'} } , 'Save Project' ) )

   If ! Empty (TmpName)
      If Upper ( Right (Tmpname , 4 ) ) != '.MPM'
         TmpName := TmpName + '.mpm'
      EndIf
      ProjectName := TmpName
      Main.Title := ' [ ' + AllTrim ( ProjectName ) + ' ]'
      Save()
   EndIf

Return
*---------------------------------------------------------------------*
Function ExitProg()
*---------------------------------------------------------------------*
   lResp := MsgYesNo ('Are you sure ?','Exit '+cAppName )
   If ( lResp == .T. )
      BorraTemporales()
      SaveEnvironment()
      ThisWindow.Release
   EndIf
Return(lResp)
*---------------------------------------------------------------------*
Procedure Run
*---------------------------------------------------------------------*
   Local PROJECTFOLDER	:= AllTrim(main.text_1.Value)
   Local NAMEEXE := AllTrim(main.text_2.Value)
   Local TopPrg	:= Alltrim(main.List_1.Item(1))
   Local App := iif(empty(NAMEEXE) , PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + Left ( TopPrg , Len(TopPrg) - 4 ) + '.Exe',NAMEEXE+'.Exe' )

   if Empty ( ProjectName )
      MsgStop('You must save project first')
   EndIf

   If Empty ( ProjectFolder ) .Or. Empty ( TopPrg )
      Return
   EndIf

   If .Not. File( PROJECTFOLDER+'\'+GetName(App ) )
      MsgStop ('You Must (Re)Build Project Prior To Run It' )
   Else
      SetCurrentFolder (PROJECTFOLDER)
      EXECUTE FILE GetName(App)
   EndIf

Return
*---------------------------------------------------------------------*
Procedure DefineWindowHotKeys()
*---------------------------------------------------------------------*
   ON KEY F1  OF Main  ACTION About()
   ON KEY F2  OF Main  ACTION Save()
   ON KEY F3  OF Main  ACTION OpenMPM()
   ON KEY F4  OF Main  ACTION BuildMode(main.radiogroup_7.value,main.radiogroup_6.value,main.radiogroup_5.value)
   ON KEY F5  OF Main  ACTION Run()
   ON KEY F6  OF Main  ACTION DispMem()
   ON KEY F7  OF Main  ACTION _OOHG_CallDump()
   ON KEY F8  OF Main  ACTION DateMod()
   ON KEY F9  OF Main  ACTION MsgInfo( iif( IsOS64(),"x64","x32" ), "OS Architecture"  )
   ON KEY F10 OF Main  ACTION ExitProg()
Return
*---------------------------------------------------------------------*
Procedure BuildMode(nModo,nCChoice,nHChoice)
*---------------------------------------------------------------------*
    Local x1 :="" , x3 := "" , cPrgFile :={}

    CursorWait2()

    // nHChoice = RadioGroup_5 - Harbour - xharbour
    // nCChoice = RadioGroup_6 - MingW - BCC - Pelles - Visual
    // nModo    = RadioGroup_7 - Exe - Librería

    Aadd( cPrgFile , Alltrim(main.List_1.Item(1)) )


    //If !VerifyTop( cPrgFile[1] )
    //   MsgInfo("Select Main Source File")
    //   Main.Tab_1.value := 2
    //   Return
    //Endif

    DateMod()

    FMGFOLDER := FilPathInList("FMG")

    If !Empty( FMGFOLDER )

        If Empty( main.Text_7.Value )
           main.Text_7.Value := FMGFOLDER
        ElseIf ! AllTrim(main.Text_7.Value)==AllTrim(FMGFOLDER)
           main.Text_7.Value := main.Text_7.Value+" i/"+FMGFOLDER
        Endif

    Endif

    Do Case
       Case nModo == 1  // Exe
            Do Case
               Case nCChoice == 1 .and. nHChoice = 1 //Harbour - MinGW
                    Build2( ProjectName )
               Case nCChoice == 2 .and. nHChoice = 1 //Harbour - BCC
                    Build( ProjectName )
               Case nCChoice == 3 .and. nHChoice = 1 //Harbour - Pelles C
                    Build4( ProjectName )
               Case nCChoice == 4 .and. nHChoice = 1 //Harbour - Visual C
                    Build5( ProjectName )

               Case nCChoice == 1 .and. nHChoice = 2 //xHarbour - MinGW
                    Build2( ProjectName )
               Case nCChoice == 2 .and. nHChoice = 2 //xHarbour - BCC
                    Build( ProjectName )
               Case nCChoice == 3 .and. nHChoice = 2 //xHarbour - Pelles C
                    Build4( ProjectName )
               Case nCChoice == 4 .and. nHChoice = 2 //xHarbour - Visual C
                    Build5( ProjectName )
            Endcase
       Case nModo == 2  // Librería
            Do Case
               Case nCChoice == 1  //MinGW
                    //BuildAny( ProjectName )
                    Build2Lib( ProjectName )
               Case nCChoice == 2  //BCC
                    //BuildAny( ProjectName )
                    BuildLib( ProjectName )
               Case nCChoice == 3  //Pelles C
                    //BuildAny( ProjectName )
                    BuildLib4( ProjectName )
               Case nCChoice == 4  //Visual C
                    //BuildAny( ProjectName )
                    BuildLib5( ProjectName )
            Endcase
    Endcase

Return

*---------------------------------------------------------------------*
Function TranslateLog( Log )
*---------------------------------------------------------------------*
   Local NewLog := '' , i, c

   For i := 1 To Len(Log) - 1
       c := SubStr ( Log , i , 2 )
       If Left ( c , 1 ) == Chr (13) .And. Right ( c , 1 ) != Chr ( 10 )
          NewLog := NewLog + NewLi
       Else
          NewLog := NewLog + Left ( c , 1 )
       EndIf
   Next i

Return NewLog
*---------------------------------------------------------------------*
Procedure AsignCtrl(nOpt)
*---------------------------------------------------------------------*
   If nOpt == 1
      cPrgEditor     := main.text_15.Value
      cFCompress     := main.text_28.Value
      cFmgEditor     := main.text_31.Value

      cGuiHbMinGW    := main.text_14.Value
      cGuiHbBCC      := main.text_23.Value
      cGuiHbPelles   := main.text_18.Value
      cGuiHbVisual   := main.text_29.Value

      cGuixHbMinGW   := main.text_19.Value
      cGuixHbBCC     := main.text_21.Value
      cGuixHbPelles  := main.text_22.Value
      cGuixHbVisual  := main.text_30.Value

      cHbMinGWFolder := main.text_8.Value
      cHbBCCFolder   := main.text_20.Value
      cHbPellFolder  := main.text_9.Value
      cHbVisuaFolder := main.text_25.Value

      cxHbMinGWFolder:= main.text_3.Value
      cxHbBCCFolder  := main.text_4.Value
      cxHbPellFolder := main.text_10.Value
      cxHbVisuaFolder:= main.text_26.Value

      cMinGWFolder   := main.text_11.Value
      cBCCFolder     := main.text_16.Value
      cPellFolder    := main.text_17.Value
      cVisualFolder  := main.text_27.Value
   Else
      main.text_15.Value := cPrgEditor
      main.text_28.Value := cFCompress
      main.text_31.Value := cFmgEditor

      main.text_14.Value := cGuiHbMinGW
      main.text_23.Value := cGuiHbBCC
      main.text_18.Value := cGuiHbPelles
      main.text_29.Value := cGuiHbVisual

      main.text_19.Value := cGuixHbMinGW
      main.text_21.Value := cGuixHbBCC
      main.text_22.Value := cGuixHbPelles
      main.text_30.Value := cGuixHbVisual

      main.text_8.Value  := cHbMinGWFolder
      main.text_20.Value := cHbBCCFolder
      main.text_9.Value  := cHbPellFolder
      main.text_25.Value := cHbVisuaFolder

      main.text_3.Value  := cxHbMinGWFolder
      main.text_4.Value  := cxHbBCCFolder
      main.text_10.Value := cxHbPellFolder
      main.text_26.Value := cxHbVisuaFolder

      main.text_11.Value := cMinGWFolder
      main.text_16.Value := cBCCFolder
      main.text_17.Value := cPellFolder
      main.text_27.Value := cVisualFolder

   Endif

Return
*---------------------------------------------------------------------*
Procedure LoadEnvironment()
*---------------------------------------------------------------------*
   Local  cDiskNew        := Upper(Hb_CurDrive()) + ":\"

   Main.title             := cAppName+" "+cAppVer
   Main.statusbar.item(1) := cAppName+" "+cAddMail

   BEGIN INI FILE OpmFolder+'\mpm.ini'

   //****************** TOOLS
   GET cPrgEditor       SECTION 'TOOLS'    ENTRY "PRGEDITOR"     default 'notepad.exe'
   GET cFcompress       SECTION 'TOOLS'    ENTRY "FCOMPRESS"     default 'upx.exe'
   GET cFmgEditor       SECTION 'TOOLS'    ENTRY "FMGEDITOR"     default 'oide.exe'

   //****************** OOHG
   GET cGuiHbMinGW      SECTION 'GUILIB'   ENTRY "GUIHBMINGW"    default cDiskNew+'oohg'
   GET cGuiHbBCC        SECTION 'GUILIB'   ENTRY "GUIHBBCC"      default cDiskNew+'oohg'
   GET cGuiHbPelles     SECTION 'GUILIB'   ENTRY "GUIHBPELL"     default cDiskNew+'oohg'
   GET cGuiHbVisual     SECTION 'GUILIB'   ENTRY "GUIHBVISUA"    default cDiskNew+'oohg'
   GET cGuixHbMinGW     SECTION 'GUILIB'   ENTRY "GUIXHBMINGW"   default cDiskNew+'oohg'
   GET cGuixHbBCC       SECTION 'GUILIB'   ENTRY "GUIXHBBCC"     default cDiskNew+'oohg'
   GET cGuixHbPelles    SECTION 'GUILIB'   ENTRY "GUIXHBPELL"    default cDiskNew+'oohg'
   GET cGuixHbVisual    SECTION 'GUILIB'   ENTRY "GUIXHBVISUA"   default cDiskNew+'oohg'

   //****************** HARBOUR
   GET cHbMinGWFolder   SECTION 'HARBOUR'  ENTRY "HBMINGW"       default cDiskNew+'harbourm'
   GET cHbBCCFolder     SECTION 'HARBOUR'  ENTRY "HBBCC"         default cDiskNew+'harbourb'
   GET cHbPellFolder    SECTION 'HARBOUR'  ENTRY "HBPELLES"      default cDiskNew+'harbourp'
   GET cHbVisuaFolder   SECTION 'HARBOUR'  ENTRY "HBVISUAL"      default cDiskNew+'harbourv'
   //****************** XHARBOUR
   GET cxHbMinGWFolder  SECTION 'HARBOUR'  ENTRY "XHBMINGW"      default cDiskNew+'xharbourm'
   GET cxHbBCCFolder    SECTION 'HARBOUR'  ENTRY "XHBBCC"        default cDiskNew+'xharbourb'
   GET cxHbPellFolder   SECTION 'HARBOUR'  ENTRY "XHBPELLES"     default cDiskNew+'xharbourp'
   GET cxHbVisuaFolder  SECTION 'HARBOUR'  ENTRY "XHBVISUAL"     default cDiskNew+'xharbourv'
   //****************** C COMPILER
   GET cMinGWFolder     SECTION 'COMPILER' ENTRY "MINGWFOLDER"   default cDiskNew+'MinGW'
   GET cBCCFolder       SECTION 'COMPILER' ENTRY "BCCFOLDER"     default cDiskNew+'Borland\BCC55'
   GET cPellFolder      SECTION 'COMPILER' ENTRY "PELLESFOLDER"  default cDiskNew+'PellesC'
   GET cVisualFolder    SECTION 'COMPILER' ENTRY "VISUALFOLDER"  default cDiskNew+'Archivos de programa\Microsoft Visual Studio 10.0\VC'

   END INI

   AsignCtrl(0)

Return
*---------------------------------------------------------------------*
Procedure SaveEnvironment()  // Guardaba variables en carpeta de mpm
*---------------------------------------------------------------------*

   BEGIN INI FILE OpmFolder+'\mpm.ini'

         SET SECTION 'TOOLS'    ENTRY "PRGEDITOR"    TO main.text_15.value
         SET SECTION 'TOOLS'    ENTRY "FCOMPRESS"    TO main.text_28.value
         SET SECTION 'TOOLS'    ENTRY "FMGEDITOR"    TO main.text_31.value

         SET SECTION 'GUILIB'   ENTRY "GUIHBMINGW"   TO main.text_14.value
         SET SECTION 'GUILIB'   ENTRY "GUIHBBCC"     TO main.text_23.value
         SET SECTION 'GUILIB'   ENTRY "GUIHBPELL"    TO main.text_18.value
         SET SECTION 'GUILIB'   ENTRY "GUIHBVISUA"   TO main.text_29.value

         SET SECTION 'GUILIB'   ENTRY "GUIXHBMINGW"  TO main.text_19.value
         SET SECTION 'GUILIB'   ENTRY "GUIXHBBCC"    TO main.text_21.value
         SET SECTION 'GUILIB'   ENTRY "GUIXHBPELL"   TO main.text_22.value
         SET SECTION 'GUILIB'   ENTRY "GUIXHBVISUA"  TO main.text_30.value

         SET SECTION 'HARBOUR'  ENTRY "HBMINGW"      TO main.text_8.value
         SET SECTION 'HARBOUR'  ENTRY "HBBCC"        TO main.text_20.value
         SET SECTION 'HARBOUR'  ENTRY "HBPELLES"     TO main.text_9.value
         SET SECTION 'HARBOUR'  ENTRY "HBVISUAL"     TO main.text_25.value

         SET SECTION 'HARBOUR'  ENTRY "XHBMINGW"     TO main.text_3.value
         SET SECTION 'HARBOUR'  ENTRY "XHBBCC"       TO main.text_4.value
         SET SECTION 'HARBOUR'  ENTRY "XHBPELLES"    TO main.text_10.value
         SET SECTION 'HARBOUR'  ENTRY "XHBVISUAL"    TO main.text_26.value

         SET SECTION 'COMPILER' ENTRY "MINGWFOLDER"  TO main.text_11.value
         SET SECTION 'COMPILER' ENTRY "BCCFOLDER"    TO main.text_16.value
         SET SECTION 'COMPILER' ENTRY "PELLESFOLDER" TO main.text_17.value
         SET SECTION 'COMPILER' ENTRY "VISUALFOLDER" TO main.text_27.value

   END INI

Return

*---------------------------------------------------------------*
Function Hblibs( cRuta,cHb,cCclr )
*---------------------------------------------------------------*
   Local n,nGUI :=0,cHbLibs := ''

   If File(cRuta+'\lib\vm.lib') .and. cCclr <> 1
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\hbvm.lib') .and. cCclr <> 1
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\win\bcc\hbvm.lib') .and. cCclr <> 1
      cRuta := cRuta + '\lib\win\bcc'
   ElseIf File(cRuta+'\lib\win\pocc\hbvm.lib') .and. cCclr <> 1
      cRuta := cRuta + '\lib\win\pocc'
   ElseIf File(cRuta+'\lib\win\msvc\hbvm.lib') .and. cCclr == 4
      cRuta := cRuta + '\lib\win\msvc'
   ElseIf File(cRuta+'\lib\libvm.a') .and. cCclr == 1
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\libhbvm.a') .and. cCclr == 1 .and. (main.check_64.value == .F.)
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\win\mingw\libhbvm.a') .and. cCclr == 1 .and. (main.check_64.value == .F.)
      cRuta := cRuta + '\lib\win\mingw'
   ElseIf File(cRuta+'\lib\win\mingw64\libhbvm.a') .and. cCclr == 1 .and. (main.check_64.value == .T.)
      cRuta := cRuta + '\lib\win\mingw64'
   Else
      cRuta := cRuta + '\lib'
   Endif

   If File(cRuta+'\vm.lib')
      aHb  := {'hbsix.lib', 'vm.lib'  , 'rdd.lib'  , 'macro.lib'  , 'pp.lib'  , 'rtl.lib'  , 'lang.lib'  , 'common.lib'  , 'nulsys.lib', 'dbfntx.lib', 'dbfcdx.lib', 'dbffpt.lib', 'ct.lib', 'libmisc.lib', 'hbodbc.lib', 'odbc32.lib', 'use_dll.lib', 'pcrepos.lib', 'codepage.lib', 'zlib.lib', 'tip.lib', 'rdds.lib' , 'rddads.lib', 'ace32.lib','debug.lib'}
   Else
      aHb  := {'hbsix.lib', 'hbvm.lib', 'hbrdd.lib', 'hbmacro.lib', 'hbpp.lib', 'hbrtl.lib', 'hblang.lib', 'hbcommon.lib', 'rddntx.lib', 'rddcdx.lib', 'rddfpt.lib', 'hbct.lib', 'socket.lib', 'mysqldll.lib', 'dll.lib', 'hbcpage.lib', 'hbdebug.lib', 'hbhsx.lib', 'hbpcre.lib', 'hbmzip.lib', 'hbzlib.lib', 'hbwin.lib', 'xhb.lib', 'odbc32.lib', 'hbmisc.lib', 'hbnf.lib', 'hbmemio.lib','hbcplr.lib','hbziparc.lib','hbtip.lib' }
   Endif

   aHba := {'libhbsix.a', 'libhbvm.a', 'libhbrdd.a', 'libhbmacro.a', 'libhbpp.a', 'libhbrtl.a', 'libhblang.a', 'libhbcommon.a', 'librddntx.a', 'librddcdx.a', 'librddfpt.a', 'libhbct.a', 'libsocket.a', 'libmysqldll.a', 'libdll.a', 'libhbcpage.a', 'libhbdebug.a', 'libhbhsx.a', 'libhbpcre.a', 'libhbmzip.a', 'libhbzlib.a', 'libhbwin.a', 'libxhb.a','libodbc32.a', 'libhbmisc.a', 'libhbnf.a', 'libhbmemio.a','libhbcplr.a','libhbziparc.a','libminizip.a','libhbtip.a' }
   aHba1:= {'lhbsix', 'lhbvm', 'lhbrdd', 'lhbmacro', 'lhbpp', 'lhbrtl', 'lhblang', 'lhbcommon', 'lrddntx', 'lrddcdx', 'lrddfpt', 'lhbct', 'lsocket', 'lmysqldll', 'ldll', 'lhbcpage', 'lhbdebug', 'lhbhsx', 'lhbpcre', 'lhbmzip', 'lhbzlib', 'lhbwin', 'lxhb', 'lodbc32', 'lhbmisc', 'lhbnf', 'lhbmemio','lhbcplr','lhbzebra','lhbziparc','lminizip','lhbtip' }

   axHb := {'hbsix.lib', 'vm.lib'  , 'rdd.lib'  , 'macro.lib'  , 'pp.lib'  , 'rtl.lib'  , 'lang.lib'  , 'common.lib'  , 'nulsys.lib', 'dbfntx.lib', 'dbfcdx.lib', 'dbffpt.lib', 'ct.lib', 'libmisc.lib', 'hbodbc.lib', 'odbc32.lib', 'use_dll.lib', 'pcrepos.lib', 'codepage.lib', 'zlib.lib', 'tip.lib', 'rdds.lib' ,'dll.lib','socket.lib', 'rddads.lib', 'ace32.lib','debug.lib'}
   axHba:= {'libgtwin.a','libhbsix.a', 'libvm.a', 'librdd.a', 'libmacro.a', 'libpp.a', 'librtl.a', 'liblang.a', 'libcommon.a', 'libnulsys.a', 'libdbfntx.a', 'libdbfcdx.a', 'libdbffpt.a', 'libct.a', 'liblibmisc.a', 'libhbodbc.a', 'libodbc32.a', 'libuse_dll.a', 'libpcrepos.a', 'libcodepage.a', 'libzlib.a', 'libtip.a', 'librdds.a','libdll.a','libsocket.a' }
   axHba1:= {'lgtwin','lhbsix', 'lvm', 'lrdd', 'lmacro', 'lpp', 'lrtl', 'llang', 'lcommon', 'lnulsys', 'ldbfntx', 'ldbfcdx', 'ldbffpt', 'lct', 'llibmisc', 'lhbodbc', 'lodbc32', 'luse_dll', 'lpcrepos', 'lcodepage', 'lzlib', 'ltip', 'lrdds', 'ldll', 'lsocket' }

   Do case
      case cHb == 1 .and. cCclr == 1  // Harbour - MinGW
           For n = 1 to Len(aHba)
               DO EVENTS
               If File(cRuta+'\'+aHba[n])
                  cHbLibs := cHbLibs + '-' + aHba1[n] + ' '
               Endif
           Next
      case cHb == 1 .and. cCclr == 2 // Harbour - Borland
           For n = 1 to Len(aHb)
               DO EVENTS
               If File(cRuta+'\'+aHb[n])
                  cHbLibs := cHbLibs + '	echo $(HRB_LIB_DIR)\' + aHb[n] + ' + >> b32.bc' + NewLi
               Endif
           Next
      case cHb == 1 .and. cCclr == 3 // Harbour - Pelles
           For n = 1 to Len(aHb)
               DO EVENTS
               If File(cRuta+'\'+aHb[n])
                  cHbLibs = cHbLibs + '	echo $(HRB_LIB_DIR)\' + aHb[n] + ' >> b32.bc' + NewLi
               Endif
           Next
      case cHb == 1 .and. cCclr == 4 // Harbour - MS Visual
           For n = 1 to Len(aHb)
               DO EVENTS
               If File(cRuta+'\'+aHb[n])
                  cHbLibs = cHbLibs + '	echo $(HRB_LIB_DIR)\' + aHb[n] + ' >> b32.bc' + NewLi
               Endif
           Next

      case cHb == 2 .and. cCclr == 1 // xHarbour - MinGW
           For n = 1 to Len(axHba)
               DO EVENTS
               If File(cRuta+'\'+axHba[n])
                  cHbLibs = cHbLibs + '-' + axHba1[n] + ' '
               Endif
           Next
      case cHb == 2 .and. cCclr == 2 // xHarbour - Borland
           For n = 1 to Len(axHb)
               DO EVENTS
               If File(cRuta+'\'+axHb[n])
                  cHbLibs := cHbLibs + '	echo $(HRB_LIB_DIR)\' + axHb[n] + ' + >> b32.bc' + NewLi
               Endif
           Next

      case cHb == 2 .and. cCclr == 3 // xHarbour - Pelles
           For n = 1 to Len(axHb)
               DO EVENTS
               If File(cRuta+'\'+axHb[n])
                  cHbLibs = cHbLibs + '	echo $(HRB_LIB_DIR)\' + axHb[n] + ' >> b32.bc' + NewLi
               Endif
           Next
      case cHb == 2 .and. cCclr == 4 // xHarbour - MS Visual
           For n = 1 to Len(axHb)
               DO EVENTS
               If File(cRuta+'\'+axHb[n])
                  cHbLibs = cHbLibs + '	echo $(HRB_LIB_DIR)\' + axHb[n] + ' >> b32.bc' + NewLi
               Endif
           Next

   End case

Return(cHblibs)
*---------------------------------------------------------------------*
Function Auto_GUI(cRuta)
*---------------------------------------------------------------------*
   If File(cRuta+'\lib\oohg.lib') .and. (main.check_64.value == .F.)
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\minigui.lib')
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\fivehc.lib')
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\libminigui.a')
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\libhmg.a')
      cRuta := cRuta + '\lib'
   ElseIf File(cRuta+'\lib\hb\bcc\oohg.lib')
      cRuta := cRuta + '\lib\hb\bcc'
   ElseIf File(cRuta+'\lib\hb\pocc\oohg.lib') .and. (main.check_64.value == .F.)
      cRuta := cRuta + '\lib\hb\pocc'
   ElseIf File(cRuta+'\lib\hb\pocc64\oohg.lib') .and. (main.check_64.value == .T.)
      cRuta := cRuta + '\lib\hb\pocc64'
   ElseIf File(cRuta+'\lib\hb\mingw\liboohg.a') .and. (main.check_64.value == .F.)
      cRuta := cRuta + '\lib\hb\mingw'
   ElseIf File(cRuta+'\lib\hb\mingw64\liboohg.a') .and. (main.check_64.value == .T.)
      cRuta := cRuta + '\lib\hb\mingw64'
   ElseIf File(cRuta+'\lib\hb\msvc\oohg.lib') .and. (main.check_64.value == .F.)
      cRuta := cRuta + '\lib\hb\msvc'
   ElseIf File(cRuta+'\lib\hb\msvc64\oohg.lib') .and. (main.check_64.value == .T.)
      cRuta := cRuta + '\lib\hb\msvc64'
   ElseIf File(cRuta+'\lib\xhb\bcc\oohg.lib')
      cRuta := cRuta + '\lib\xhb\bcc'
   ElseIf File(cRuta+'\lib\xhb\pocc\oohg.lib')
      cRuta := cRuta + '\lib\xhb\pocc'
   ElseIf File(cRuta+'\lib\xhb\mingw\liboohg.a')
      cRuta := cRuta + '\lib\xhb\mingw'
   ElseIf File(cRuta+'\lib\xhb\msvc\oohg.lib')
      cRuta := cRuta + '\lib\xhb\msvc'
   Else
      cRuta := cRuta + '\lib'
   Endif

   If File(cRuta+'\libhmg.a')
      nWathGui := 3                        // HMG
   ElseIf File(cRuta+'\minigui.lib')
      nWathGui := 2                        // MiniGUI
   ElseIf File(cRuta+'\libminigui.a')
      nWathGui := 2                        // MiniGUI
   ElseIf File(cRuta+'\oohg.lib')
      nWathGui := 1                        // ooHG
   ElseIf File(cRuta+'\liboohg.a')
      nWathGui := 1                        // ooHG
   ElseIf File(cRuta+'\fivehc.lib')
      nWathGui := 4                        // Fivewin
   Else
      nWathGui := 1                        // ooHG
   Endif

Return(nWathGui)
*---------------------------------------------------------------------*
Function TxtSearch(cText)
*---------------------------------------------------------------------*
    npostext := 0
    cText := Rtrim(cText)
    if len(cText) > 0
       lEnc := NextSearch(cText)
    endif
return( lEnc )

#DEFINE CR chr(13)
*---------------------------------------------------------------------*
Function NextSearch(cText)
*---------------------------------------------------------------------*
   local todo,lBus
   todo := strtran( main.RichEdit_1.value,CR,"" )
   nPostext := MyAt( upper(ctext), upper(todo), nPostext + len(ctext))
   if nPostext > 0
      main.RichEdit_1.setfocus()
      main.RichEdit_1.caretpos := nPostext - 1
      lBus := .T.
   else
      main.RichEdit_1.setfocus()
      lBus := .F.
   endif
return lBus
*---------------------------------------------------------------------*
Function MyAt(cBusca,cTodo,nInicio)
*---------------------------------------------------------------------*
   local i,nposluna
   nPosluna := 0
   for i := nInicio to len(cTodo)
       DO EVENTS              
       if UPPER(SUBSTR(cTodo,i,len(cBusca))) = UPPER(cBusca)
          nPosluna := i
          exit
       endif
   next i
Return(nPosluna)
*---------------------------------------------------------------------*
Procedure MakeInclude(cPathGUI,nGUI)
*---------------------------------------------------------------------*
   DO CASE
      CASE nGUI == 1
           cDos  := "/c echo #define oohgpath "+cPathGUI+"\resources > "+cPathGUI+"\include\_oohg_resconfig.h"
           cDos1 := "/c echo #define oohgpath "+cPathGUI+"\resources > "+cPathGUI+"\resources\_oohg_resconfig.h"
      CASE nGUI == 2
           cDos  := "/c echo #define HMGRPATH "+cPathGUI+"\resources > "+cPathGUI+"\include\_hmg_resconfig.h"
           cDos1 := "/c echo #define HMGRPATH "+cPathGUI+"\resources > "+cPathGUI+"\resources\_hmg_resconfig.h"
      CASE nGUI == 3
           cDos  := "/c echo #define HMGRPATH "+cPathGUI+"\resources > "+cPathGUI+"\include\_hmg_resconfig.h"
           cDos1 := "/c echo #define HMGRPATH "+cPathGUI+"\resources > "+cPathGUI+"\resources\_hmg_resconfig.h"
      OTHERWISE
           cDos  := "/c echo #define oohgpath "+cPathGUI+"\resources > "+cPathGUI+"\include\_oohg_resconfig.h"
           cDos1 := "/c echo #define oohgpath "+cPathGUI+"\resources > "+cPathGUI+"\resources\_oohg_resconfig.h"
   ENDCASE
   EXECUTE FILE "CMD.EXE" PARAMETERS cDos HIDE
   EXECUTE FILE "CMD.EXE" PARAMETERS cDos1 HIDE
Return

*---------------------------------------------------------------------*
Procedure Crea_temp_rc( cFilerc )  // File _temp.rc
*---------------------------------------------------------------------*
      Local lRet

      If File ( PROJECTFOLDER + '\' + cFilerc + '.rc' )  // Existe .RC
         cFilerc2 := AllTrim( PROJECTFOLDER + '\' + cFilerc )
         DO CASE
            CASE WATHGUI == 1 // ooHG
                 If ( main.RadioGroup_6.value = 2 .OR. main.RadioGroup_6.value = 3 .OR. main.RadioGroup_6.value = 4)
                    DosComm1 := '/c copy /b "'+MINIGUIFOLDER+'\resources\oohg_bcc.rc'+'"+"'+cFilerc2+'.rc'+'"+"'+MINIGUIFOLDER+'\resources\filler"'+' "'+MINIGUIFOLDER+'\resources\_temp.rc"'+' >NUL'
                 Else
                    DosComm1 := '/c copy /b "'+MINIGUIFOLDER+'\resources\oohg.rc'+'"+"'+cFilerc2+'.rc'+'"+"'+MINIGUIFOLDER+'\resources\filler"'+' "'+MINIGUIFOLDER+'\resources\_temp.rc"'+' >NUL'
                 Endif
            CASE WATHGUI == 2  // MiniGUI
                 If main.RadioGroup_6.value = 1
                    DosComm1 := '/c copy /b "'+MINIGUIFOLDER+'\resources\hmg.rc'+'"+"'+cFilerc2+'.rc'+'"+"'+MINIGUIFOLDER+'\resources\filler"'+' "'+MINIGUIFOLDER+'\resources\_temp.rc"'+' >NUL'
                 Else
                    cRcs := MINIGUIFOLDER+'\resources\minigui.rc'+'"+"'+MINIGUIFOLDER+'\resources\miniprint.rc'+'"+"'+MINIGUIFOLDER+'\resources\hbprinter.rc'+'"+"'+cFilerc2+'.rc'+'"+"'+MINIGUIFOLDER+'\resources\filler"'
                    DosComm1 := '/c copy /b "'+cRcs+' "'+MINIGUIFOLDER+'\resources\_temp.rc"'+' >NUL'
                 Endif
            CASE WATHGUI == 3  // HMG
                 DosComm1 := '/c copy /b "'+MINIGUIFOLDER+'\resources\hmg.rc'+'"+"'+cFilerc2+'.rc'+'"+"'+MINIGUIFOLDER+'\resources\filler"'+' "'+MINIGUIFOLDER+'\resources\_temp.rc"'+' >NUL'
            CASE WATHGUI == 4  // FWH
                 DosComm1 := '/c copy /b ' + cFilerc2 + '.rc  _temp.rc >NUL'
            OTHERWISE
                 DosComm1 := '/c Echo // > '+PROJECTFOLDER+'\_temp.rc'
         ENDCASE
      Endif

      If !File ( PROJECTFOLDER + '\' + cFilerc + '.rc' )  // No existe .RC
         DO CASE
            CASE WATHGUI == 1
                 If ( main.RadioGroup_6.value = 2 .OR. main.RadioGroup_6.value = 3 .OR. main.RadioGroup_6.value = 4)
                    DosComm1 := "/c copy /b "+MINIGUIFOLDER+"\resources\oohg_bcc.rc "+MINIGUIFOLDER+"\resources\_temp.rc >NUL"
                 Else
                    DosComm1 := "/c copy /b "+MINIGUIFOLDER+"\resources\oohg.rc "+MINIGUIFOLDER+"\resources\_temp.rc >NUL"
                 Endif
            CASE WATHGUI == 2
                 If main.RadioGroup_6.value = 1
                    DosComm1 := "/c copy /b "+MINIGUIFOLDER+"\resources\hmg.rc "+MINIGUIFOLDER+"\resources\_temp.rc >NUL"
                 Else
                    cRcs := MINIGUIFOLDER+"\resources\minigui.rc+"+MINIGUIFOLDER+"\resources\miniprint.rc+"+MINIGUIFOLDER+"\resources\hbprinter.rc"
                    DosComm1 := "/c copy /b "+cRcs+" "+MINIGUIFOLDER+"\resources\_temp.rc >NUL"
                 Endif
            CASE WATHGUI == 3
                 DosComm1 := "/c copy /b "+MINIGUIFOLDER+"\resources\hmg.rc "+MINIGUIFOLDER+"\resources\_temp.rc >NUL"
            CASE WATHGUI == 4
                 DosComm1 := '/c Echo // > '+PROJECTFOLDER+'\_temp.rc'
            OTHERWISE
                 DosComm1 := '/c Echo // > '+PROJECTFOLDER+'\_temp.rc'
         ENDCASE
      Endif

      EXECUTE FILE "CMD.EXE" PARAMETERS DosComm1 HIDE

      If File ( MINIGUIFOLDER + '\resources\_temp.rc' )  // .RC Creado
         lRet := .T.
      Else
         lRet := .T.
      Endif

Return( lRet )

*---------------------------------------------------------------------*
Procedure AsociarMpm()
*---------------------------------------------------------------------*

   ChangeAssociation(".mpm",.T.)

Return

*---------------------------------------------------------------------*
Procedure FocoEnText()
*---------------------------------------------------------------------*
   DisableText()

   Do Case
      Case main.RadioGroup_6.Value = 1 .AND. main.RadioGroup_5.Value = 1 .AND. main.Tab_1.Value = 3 // MinGW - Harbour
           main.Frame_2.Show
           // main.Frame_37.Show
           main.Label_9.Show
           main.Button_12.Show
           main.Label_25.Show
           main.Label_29.Show
           main.text_24.Show
           main.RadioGroup_1.Show
           main.text_8.Show      // cHbMinGWFolder
           main.text_8.Setfocus  // cHbMinGWFolder

      Case main.RadioGroup_6.Value = 1 .AND. main.RadioGroup_5.Value = 2 .AND. main.Tab_1.Value = 3 // MinGW - xHarbour
           main.Frame_3.Show
           // main.Frame_37.Show
           main.Label_8.Show
           main.Button_25.Show
           main.Label_25.Show
           main.Label_29.Show
           main.text_24.Show
           main.RadioGroup_1.Show
           main.text_3.Show      // cxHbMinGWFolder
           main.text_3.Setfocus  // cxHbMinGWFolder

      Case main.RadioGroup_6.Value = 2 .AND. main.RadioGroup_5.Value = 1 .AND. main.Tab_1.Value = 3 // Borland - Harbour
           main.Frame_2.Show
           // main.Frame_37.Show
           main.Label_10.Show
           main.Button_13.Show
           main.Label_25.Show
           main.Label_29.Show
           main.text_44.Show
           main.RadioGroup_21.Show
           main.text_20.Show     // cHbBCCFolder
           main.text_20.Setfocus // cHbBCCFolder

      Case main.RadioGroup_6.Value = 2 .AND. main.RadioGroup_5.Value = 2 .AND. main.Tab_1.Value = 3 // Borland - xHarbour
           main.Frame_3.Show
           // main.Frame_37.Show
           main.Label_16.Show
           main.Button_26.Show
           main.Label_25.Show
           main.Label_29.Show
           main.text_44.Show
           main.RadioGroup_21.Show
           main.text_4.Show     // cxHbBCCFolder
           main.text_4.Setfocus // cxHbBCCFolder

      Case main.RadioGroup_6.Value = 3 .AND. main.RadioGroup_5.Value = 1 .AND. main.Tab_1.Value = 3  // Pelles - Harbour
           main.Frame_2.Show
           // main.Frame_37.Show
           main.Label_12.Show
           main.Button_24.Show
           main.Label_25.Show
           main.Label_29.Show
           main.text_54.Show
           main.RadioGroup_31.Show
           main.text_9.Show     // cHbPellFolder
           main.text_9.Setfocus // cHbPellFolder

      Case main.RadioGroup_6.Value = 3 .AND. main.RadioGroup_5.Value = 2 .AND. main.Tab_1.Value = 3 // Pelles - xHarbour
           main.Frame_3.Show
           // main.Frame_37.Show
           main.Label_17.Show
           main.Button_27.Show
           main.Label_25.Show
           main.Label_29.Show
           main.text_54.Show
           main.RadioGroup_31.Show
           main.text_10.Show      // cxHbPellFolder
           main.text_10.Setfocus  // cxHbPellFolder

      Case main.RadioGroup_6.Value = 4 .AND. main.RadioGroup_5.Value = 1 .AND. main.Tab_1.Value = 3 // Visual - Harbour
           main.Frame_2.Show
           // main.Frame_37.Show
           main.Label_26.Show
           main.Button_2.Show
           main.Label_25.Show
           main.Label_29.Show
           main.text_64.Show
           main.RadioGroup_41.Show
           main.text_25.Show      // cHbVisuaFolder
           main.text_25.Setfocus  // cHbVisuaFolder

      Case main.RadioGroup_6.Value = 4 .AND. main.RadioGroup_5.Value = 2 .AND. main.Tab_1.Value = 3 // Visual - xHarbour
           main.Frame_3.Show
           // main.Frame_37.Show
           main.Label_27.Show
           main.Button_40.Show
           main.Label_25.Show
           main.Label_29.Show
           main.text_64.Show
           main.RadioGroup_41.Show
           main.text_26.Show      // cxHbVisuaFolder
           main.text_26.Setfocus  // cxHbVisuaFolder

      Case main.RadioGroup_6.Value = 1 .AND. main.Tab_1.Value = 4 // MinGW
           // main.Frame_6.Show
           // main.Frame_7.Show

           main.Label_11.Show
           main.Button_14.Show

           main.Label_13.Show
           main.text_12.Show
           main.Label_14.Show
           main.text_13.Show

           main.text_11.Setfocus // cMinGWFolder
           main.text_11.Show     // cMinGWFolder

      Case main.RadioGroup_6.Value = 2 .AND. main.Tab_1.Value = 4 // Borland
           // main.Frame_6.Show
           // main.Frame_7.Show

           main.Label_3.Show
           main.Button_16.Show

           main.Label_13.Show
           main.text_32.Show
           main.Label_14.Show
           main.text_33.Show

           main.text_16.Show     // cBCCFolder
           main.text_16.Setfocus // cBCCFolder

      Case main.RadioGroup_6.Value = 3 .AND. main.Tab_1.Value = 4 // Pelles
           // main.Frame_6.Show
           // main.Frame_7.Show

           main.Label_7.Show
           main.Button_17.Show

           main.Label_13.Show
           main.text_42.Show
           main.Label_14.Show
           main.text_43.Show

           main.text_17.Show     // cPellFolder
           main.text_17.Setfocus // cPellFolder

      Case main.RadioGroup_6.Value = 4 .AND. main.Tab_1.Value = 4 // Visual
           // main.Frame_6.Show
           // main.Frame_7.Show

           main.Label_28.Show
           main.Button_41.Show

           main.Label_13.Show
           main.text_52.Show
           main.Label_14.Show
           main.text_53.Show

           main.text_27.Show     // cVisualFolder
           main.text_27.Setfocus // cVisualFolder

      Case main.RadioGroup_6.Value = 1 .AND. main.RadioGroup_5.Value = 1 .AND. main.Tab_1.Value = 5 // MinGW - Harbour
           main.Frame_9.Show
           main.Label_15.Show
           main.Button_15.Show
           main.text_14.Show     // cGuiHbMinGW
           main.text_14.Setfocus // cGuiHbMinGW

      Case main.RadioGroup_6.Value = 1 .AND. main.RadioGroup_5.Value = 2 .AND. main.Tab_1.Value = 5 // MinGW - xHarbour
           main.Frame_10.Show
           main.Label_21.Show
           main.Button_29.Show
           main.text_19.Show     // cGuixHbMinGW
           main.text_19.Setfocus // cGuixHbMinGW

      Case main.RadioGroup_6.Value = 2 .AND. main.RadioGroup_5.Value = 1 .AND. main.Tab_1.Value = 5 // Borland - Harbour
           main.Frame_9.Show
           main.Label_18.Show
           main.Button_18.Show
           main.text_23.Show     // cGuiHbBCC
           main.text_23.Setfocus // cGuiHbBCC

      Case main.RadioGroup_6.Value = 2 .AND. main.RadioGroup_5.Value = 2 .AND. main.Tab_1.Value = 5 // Borland - xHarbour
           main.Frame_10.Show
           main.Label_22.Show
           main.Button_30.Show
           main.text_21.Show     // cGuixHbBCC
           main.text_21.Setfocus // cGuixHbBCC

      Case main.RadioGroup_6.Value = 3 .AND. main.RadioGroup_5.Value = 1 .AND. main.Tab_1.Value = 5  // Pelles - Harbour
           main.Frame_9.Show
           main.Label_20.Show
           main.Button_28.Show
           main.text_18.Show     // cGuiHbPelles
           main.text_18.Setfocus // cGuiHbPelles

      Case main.RadioGroup_6.Value = 3 .AND. main.RadioGroup_5.Value = 2 .AND. main.Tab_1.Value = 5 // Pelles - xHarbour
           main.Frame_10.Show
           main.Label_23.Show
           main.Button_31.Show
           main.text_22.Show     // cGuixHbPelles
           main.text_22.Setfocus // cGuixHbPelles

      Case main.RadioGroup_6.Value = 4 .AND. main.RadioGroup_5.Value = 1 .AND. main.Tab_1.Value = 5 // Visual - Harbour
           main.Frame_9.Show
           main.Label_30.Show
           main.Button_42.Show
           main.text_29.Show     // cGuiHbVisual
           main.text_29.Setfocus // cGuiHbVisual

      Case main.RadioGroup_6.Value = 4 .AND. main.RadioGroup_5.Value = 2 .AND. main.Tab_1.Value = 5 // Visual - xHarbour
           main.Frame_10.Show
           main.Label_31.Show
           main.Button_43.Show
           main.text_30.Show     // cGuixHbVisual
           main.text_30.Setfocus // cGuixHbVisual
   Endcase


Return
*---------------------------------------------------------------------*
Procedure DisableText()
*---------------------------------------------------------------------*
         // Tab (x)Harbour

         main.text_8.Hide  // cHbMinGWFolder
         main.text_20.Hide // cHbBCCFolder
         main.text_9.Hide  // cHbPellFolder
         main.text_25.Hide // cHbVisuaFolder

         main.Label_9.Hide
         main.Label_10.Hide
         main.Label_12.Hide
         main.Label_26.Hide
         main.Button_12.Hide
         main.Button_13.Hide
         main.Button_24.Hide
         main.Button_2.Hide

         main.text_3.Hide  // cxHbMinGWFolder
         main.text_4.Hide  // cxHbBCCFolder
         main.text_10.Hide // cxHbPellFolder
         main.text_26.Hide // cxHbVisuaFolder

         main.Label_8.Hide
         main.Label_16.Hide
         main.Label_17.Hide
         main.Label_27.Hide
         main.Button_25.Hide
         main.Button_26.Hide
         main.Button_27.Hide
         main.Button_40.Hide

         main.Frame_2.Hide
         main.Frame_3.Hide
         // main.Frame_37.Hide


         // Tab C Compiler

         main.text_11.Hide // cMinGWFolder
         main.text_16.Hide // cBCCFolder
         main.text_17.Hide // cPellFolder
         main.text_27.Hide // cVisualFolder

         main.Label_11.Hide
         main.Label_3.Hide
         main.Label_7.Hide
         main.Label_28.Hide
         main.Button_14.Hide
         main.Button_16.Hide
         main.Button_17.Hide
         main.Button_41.Hide

         main.text_12.Hide
         main.text_13.Hide
         main.text_24.Hide
         main.RadioGroup_1.Hide

         main.text_32.Hide
         main.text_33.Hide
         main.text_44.Hide
         main.RadioGroup_21.Hide

         main.text_42.Hide
         main.text_43.Hide
         main.text_54.Hide
         main.RadioGroup_31.Hide

         main.text_52.Hide
         main.text_53.Hide
         main.text_64.Hide
         main.RadioGroup_41.Hide

         main.Label_13.Hide
         main.Label_14.Hide
         main.Label_25.Hide
         main.Label_29.Hide

         // main.Frame_6.Hide
         // main.Frame_7.Hide

         // Tab GUI

         main.text_14.Hide // cGuiHbMinGW
         main.text_23.Hide // cGuiHbBCC
         main.text_18.Hide // cGuiHbPelles
         main.text_29.Hide // cGuiHbVisual

         main.Label_15.Hide
         main.Label_18.Hide
         main.Label_20.Hide
         main.Label_30.Hide
         main.Button_15.Hide
         main.Button_18.Hide
         main.Button_28.Hide
         main.Button_42.Hide

         main.text_19.Hide // cGuixHbMinGW
         main.text_21.Hide // cGuixHbBCC
         main.text_22.Hide // cGuixHbPelles
         main.text_30.Hide // cGuixHbVisual

         main.Label_21.Hide
         main.Label_22.Hide
         main.Label_23.Hide
         main.Label_31.Hide
         main.Button_29.Hide
         main.Button_30.Hide
         main.Button_31.Hide
         main.Button_43.Hide

         main.Frame_9.Hide
         main.Frame_10.Hide

Return
*---------------------------------------------------------------------*
Function RetHbLevel()
*---------------------------------------------------------------------*
      If     main.RadioGroup_1.Value = 1
             cLevel := ""
      ElseIf main.RadioGroup_1.Value = 2
             cLevel := "-w0"
      ElseIf main.RadioGroup_1.Value = 3
             cLevel := "-w1"
      ElseIf main.RadioGroup_1.Value = 4
             cLevel := "-w2"
      ElseIf main.RadioGroup_1.Value = 5
             cLevel := "-w3"
      Endif
Return(cLevel)
*---------------------------------------------------------------------*
Function MyOBJName()
*---------------------------------------------------------------------*
      If     main.RadioGroup_6.Value = 1 .and. main.RadioGroup_5.Value = 1
             cOBJName := "mOBJh"
      ElseIf main.RadioGroup_6.Value = 2 .and. main.RadioGroup_5.Value = 1
             cOBJName := "bOBJh"
      ElseIf main.RadioGroup_6.Value = 3 .and. main.RadioGroup_5.Value = 1
             cOBJName := "pOBJh"
      ElseIf main.RadioGroup_6.Value = 4 .and. main.RadioGroup_5.Value = 1
             cOBJName := "vOBJh"
      ElseIf main.RadioGroup_6.Value = 1 .and. main.RadioGroup_5.Value = 2
             cOBJName := "mOBJx"
      ElseIf main.RadioGroup_6.Value = 2 .and. main.RadioGroup_5.Value = 2
             cOBJName := "bOBJx"
      ElseIf main.RadioGroup_6.Value = 3 .and. main.RadioGroup_5.Value = 2
             cOBJName := "pOBJx"
      ElseIf main.RadioGroup_6.Value = 4 .and. main.RadioGroup_5.Value = 2
             cOBJName := "vOBJx"
      Endif
Return( cOBJName )
*---------------------------------------------------------------------*
Procedure ComprimoExe(ProjectFolder,ProjectFile)
*---------------------------------------------------------------------*
   If !Empty(main.Text_28.value)
      WAITRUN( AllTrim(main.Text_28.value)+" --best --lzma " + ProjectFolder + '\' + DelExt( ProjectFile ) + '.exe' )
      DO EVENTS
   Endif
Return

*---------------------------------------------------------------------*
FUNCTION DateMod()
*---------------------------------------------------------------------*
  LOCAL aDir1   := DIRECTORY( main.text_7.value + '\*.*' )
  LOCAL aDir2   := DIRECTORY( main.List_1.Item(1) )
  LOCAL nFiles  := LEN( aDir1 )
  LOCAL lMod    := .N.
  LOCAL nFile
  LOCAL nTargDate
  LOCAL cMfile   := GetName( Left( main.List_1.Item(1), Len( main.List_1.Item(1) ) - 4 ) )

  LOCAL cOBJFldr := iif( Empty(main.text_5.value), MyOBJName(), AllTrim(main.text_5.value) )
  LOCAL cProjFldr:= iif( Empty(main.text_1.value), CurDir(), AllTrim(main.text_1.value) )

  IF !EMPTY( aDir1 )
    nTargDate := FDateTime(aDir2[1][3], aDir2[1][4])
    FOR nFile := 1 TO nFiles
        IF FDateTime( aDir1[nFile][3], aDir1[nFile][4] ) > nTargDate
           lMod := .T.
        ENDIF
    NEXT
    If lMod == .T.
       main.RadioGroup_4.value := 2
    Endif
  ENDIF

RETURN( Nil )
/*
*---------------------------------------------------------------------*
FUNCTION DateTime(dDate, cTime)
*---------------------------------------------------------------------*
  LOCAL nDateTime := (dDate - CTOD('')) + SECS(cTime)/86400

RETURN( nDateTime )
*/
