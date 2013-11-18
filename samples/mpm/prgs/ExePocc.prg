/*
 * $Id: ExePocc.prg,v 1.1 2013-11-18 20:40:25 migsoft Exp $
 */

#include "oohg.ch"
#include "mpm.ch"

*-----------------------------------------------------
Procedure Build4(ProjectName) //(x)Harbour - Pelles C
*-----------------------------------------------------

   DECLARE WINDOW main
   DECLARE WINDOW MigMess

   StartBuild()

   BCCFOLDER      := AllTrim(main.Text_17.Value)
   CCOMPFOLDER    := BCCFOLDER

   If HBCHOICE = 1
      HARBOURFOLDER  := AllTrim(main.Text_9.Value)
      MINIGUIFOLDER  := AllTrim(main.Text_18.Value)
   Else
      HARBOURFOLDER  := AllTrim(main.Text_10.Value)
      MINIGUIFOLDER  := AllTrim(main.Text_22.Value)
   Endif

   WATHGUI        := Auto_GUI(MINIGUIFOLDER)

   ExeName := iif(empty(EXEOUTPUTNAME), Left ( Alltrim(main.List_1.Item(1)), Len(Alltrim(main.List_1.Item(1))) - 4 ) , EXEOUTPUTNAME )

   BEGIN SEQUENCE

      MsgBuild()

   cMiniGuiFolder := MINIGUIFOLDER
   cBccFolder     := BCCFOLDER
   cProjFolder    := PROJECTFOLDER
   cHarbourFolder := HARBOURFOLDER
   cLibFolder     := iif( empty(LIBFOLDER),'',LIBFOLDER )
   cUserFlags     := iif( empty(USERFLAGS),'',USERFLAGS )
   cIncFolder     := iif( empty(INCFOLDER),'',INCFOLDER+' /i' )

   Out := Out + 'HARBOUR_EXE = '   + cHarbourFolder + '\BIN\HARBOUR.EXE'   + NewLi
   Out := Out + 'CC = '            + cBccFolder     + '\BIN\POCC.EXE'      + NewLi
   Out := Out + 'ILINK_EXE = '     + cBccFolder     + '\BIN\POLINK.EXE'    + NewLi
   Out := Out + 'BRC_EXE = '       + cBccFolder     + '\BIN\PORC.EXE'      + NewLi
   Out := Out + 'APP_NAME = '      + iif(empty(EXEOUTPUTNAME), GetName(Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 ) + '.Exe') + NewLi, EXEOUTPUTNAME+ '.Exe' + NewLi )
   Out := Out + 'RC_FILE = '       + cMiniGuiFolder + '\RESOURCES\oohg.RC' + NewLi
   Out := Out + 'GUI_FOLDER = '    + cMiniGuiFolder                        + NewLi
   Out := Out + 'INCLUDE_DIR = '   + cHarbourFolder + '\INCLUDE /i' +cIncFolder+cMiniGuiFolder + '\INCLUDE /i' + cProjFolder +'/i' + cbccFolder + '\INCLUDE /i' + cBccFolder + '\INCLUDE\WIN'+ NewLi
   Out := Out + 'CC_LIB_DIR = '    + cBccFolder     + '\LIB'               + NewLi
   Out := Out + 'INCLUDE_C_DIR = ' + cbccFolder     + '\INCLUDE -I' + cBccFolder + '\INCLUDE\WIN -I' + cHarbourFolder + '\INCLUDE -I' + cMiniGuiFolder + '\INCLUDE -I' + cProjFolder + NewLi
   Out := Out + 'USR_LIB_DIR = '   + cProjFolder                           + NewLi
   Out := Out + 'OBJ_DIR = '       + cProjFolder    + cOBJ_DIR             + NewLi
   Out := Out + 'C_DIR = '         + cProjFolder    + cOBJ_DIR             + NewLi
   Out := Out + 'USER_FLAGS = '    + cUserFlags     + NewLi

    If file(cHarbourFolder + '\LIB\tip.lib')
       Out += 'HRB_LIB_DIR = ' + cHarbourFolder + '\LIB'  + NewLi
    ElseIf file(cHarbourFolder + '\LIB\hbwin.lib')
       Out += 'HRB_LIB_DIR = ' + cHarbourFolder + '\LIB'  + NewLi
    ElseIf file(cHarbourFolder + '\LIB\WIN\POCC\hbwin.lib')
       Out += 'HRB_LIB_DIR = ' + cHarbourFolder + '\LIB\WIN\POCC' + NewLi
    Endif


    IF WITHDEBUG = 2
       Out += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n /b '+RetHbLevel()+' $(USER_FLAGS)' + NewLi
    ELSE
       Out += 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n '+RetHbLevel()+' $(USER_FLAGS)' + NewLi
    ENDIF
    

    cFlags := iif(empty(USERCFLAGS),' /Ze /Zx /Go /Tx86-coff /D__WIN32__ ', USERCFLAGS)

    Out += 'COBJFLAGS = ' + cFlags + ' -I$(INCLUDE_C_DIR)' + NewLi

    Out += NewLi

   if ( main.List_1.ItemCount > 2 )
      cBarra := ' \'
   Else
      cBarra := ''
   Endif

   Out += '$(APP_NAME) : $(OBJ_DIR)\' + GetName(Left ( PRGFILES [1] , Len( PRGFILES [1] ) - 4 ))  + '.obj'+ cBarra + NewLi

   nTotFmgs := 0

   For i := 2 TO Len ( PrgFiles )
       DO EVENTS
       If upper(Right( PRGFILES [i] , 3 )) = 'FMG'
          nTotFmgs := nTotFmgs + 1
       Endif
   Next

   For i := 2 TO Len ( PrgFiles )
       DO EVENTS
       If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
          IF i == Len ( PrgFiles ) - nTotFmgs
             Out += '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len( PRGFILES [i] ) - 4 ))  + '.obj' + NewLi
          ELSE
             Out += '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len( PRGFILES [i] ) - 4 ))  + '.obj \' + NewLi
          ENDIF
        ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
          IF i == Len ( PrgFiles ) - nTotFmgs
             Out += '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len( PRGFILES [i] ) - 2 ))  + '.obj' + NewLi
          ELSE
             Out += '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len( PRGFILES [i] ) - 2 ))  + '.obj \' + NewLi
          ENDIF
        Endif
   Next i

    If Crea_temp_rc( GetName(Left ( PRGFILES [1] , Len( PRGFILES [1] ) - 4 )) )

       Out += '	$(BRC_EXE) /Fo' + MINIGUIFOLDER +'\resources\_temp.res ' + MINIGUIFOLDER +'\resources\_temp.rc ' + NewLi

    Endif

    FOR nFile := 1 To Len(PrgFiles) - nTotFmgs
        DO EVENTS
        Out += '	echo $(OBJ_DIR)\' + GetName(DelExt(PrgFiles[nFile])) +  '.obj >' + IF(nFile > 1, '>', '') +' b32.bc ' + NewLi
    NEXT i

    If File(cMiniGuiFolder+'\LIB\oohg.lib')
       cLib_ooHG      :='\LIB\oohg.lib'
       cLib_Hbprinter :='\LIB\hbprinter.lib'
       cLib_Miniprint :='\LIB\miniprint.lib'
    ElseIf File(cMiniGuiFolder+'\LIB\hb\pocc\oohg.lib') .AND. HBCHOICE = 1
       cLib_ooHG      :='\LIB\hb\pocc\oohg.lib'
       cLib_Hbprinter :='\LIB\hb\pocc\hbprinter.lib'
       cLib_Miniprint :='\LIB\hb\pocc\miniprint.lib'
    ElseIf File(cMiniGuiFolder+'\LIB\xhb\pocc\oohg.lib') .AND. HBCHOICE = 2
       cLib_ooHG      :='\LIB\xhb\pocc\oohg.lib'
       cLib_Hbprinter :='\LIB\xhb\pocc\hbprinter.lib'
       cLib_Miniprint :='\LIB\xhb\pocc\miniprint.lib'
    Else
       cLib_ooHG      :='\LIB\oohg.lib'
       cLib_Hbprinter :='\LIB\hbprinter.lib'
       cLib_Miniprint :='\LIB\miniprint.lib'
    Endif

    Out += '	echo /OUT:$(APP_NAME) >> b32.bc '+ NewLi
    Out += '	echo /FORCE:MULTIPLE >> b32.bc '+ NewLi
    Out += '	echo /LIBPATH:'+cBccFolder+'\LIB >> b32.bc '+ NewLi
    Out += '	echo /LIBPATH:'+cBccFolder+'\LIB\WIN >> b32.bc '+ NewLi
    Out += '	echo ' + cMiniGuiFolder  + cLib_ooHG + ' >> b32.bc ' + NewLi

    IF WITHGTMODE = 1
       Out += '	echo $(HRB_LIB_DIR)\gtgui.lib >> b32.bc' + NewLi
    ElseIf (WITHGTMODE = 2) .OR. (WITHDEBUG = 2)
       Out += '	echo $(HRB_LIB_DIR)\gtwin.lib >> b32.bc' + NewLi
    ElseIf WITHGTMODE = 3
       Out += '	echo $(HRB_LIB_DIR)\gtwin.lib >> b32.bc' + NewLi
       Out += '	echo $(HRB_LIB_DIR)\gtgui.lib >> b32.bc' + NewLi
    ENDIF

    Out += '	echo ' + cMiniGuiFolder  + cLib_Hbprinter + '  >> b32.bc' + NewLi
    Out += '	echo ' + cMiniGuiFolder  + cLib_Miniprint + ' >> b32.bc' + NewLi

    If HBCHOICE = 1
       Out += HbLibs(HARBOURFOLDER,1,3)
    Else
       Out += HbLibs(HARBOURFOLDER,2,3)
    Endif
    
      For i := 1 To Len ( LIBFILES )
          DO EVENTS
          Out += '	echo ' + Left ( LIBFILES [i] , Len(LIBFILES [i] ) - 4 ) + '.lib >> b32.bc' + NewLi
      Next i


    Out += '	echo crt.lib >> b32.bc' + NewLi
    Out += '	echo kernel32.lib >> b32.bc' + NewLi
    Out += '	echo winspool.lib >> b32.bc' + NewLi
    Out += '	echo user32.lib >> b32.bc' + NewLi
    Out += '	echo advapi32.lib >> b32.bc' + NewLi
    Out += '	echo ole32.lib >> b32.bc' + NewLi
    Out += '	echo uuid.lib >> b32.bc' + NewLi
    Out += '	echo oleaut32.lib >> b32.bc' + NewLi
    Out += '	echo mpr.lib >> b32.bc' + NewLi
    Out += '	echo comdlg32.lib >> b32.bc' + NewLi
    Out += '	echo comctl32.lib >> b32.bc' + NewLi
    Out += '	echo gdi32.lib >> b32.bc' + NewLi
    Out += '	echo olepro32.lib >> b32.bc' + NewLi
    Out += '	echo shell32.lib >> b32.bc' + NewLi
    Out += '	echo winmm.lib >> b32.bc' + NewLi
    Out += '	echo vfw32.lib >> b32.bc' + NewLi
    Out += '	echo wsock32.lib >> b32.bc' + NewLi
    Out += '	echo ' + cMiniGuiFolder +'\resources\_temp.res >> b32.bc' + NewLi

    IF     (WITHDEBUG  = 2)  .OR. (WITHGTMODE = 2) .OR. (WITHGTMODE = 3)
               Out += '	$(ILINK_EXE)  /SUBSYSTEM:CONSOLE  @b32.bc' + NewLi+ NewLi
    ElseIF (WITHGTMODE = 1)
               Out += '	$(ILINK_EXE)  /SUBSYSTEM:WINDOWS  @b32.bc' + NewLi+ NewLi
    Endif

    FOR nFile := 1 TO Len(PrgFiles) - nTotFmgs
        DO EVENTS
        If upper(Right( PRGFILES [nFile] , 3 )) = 'PRG'
           Out += NewLi
           Out += '$(C_DIR)\' + GetName(DelExt(PrgFiles[nFile])) + '.c : ' + PrgFiles[nFile] + NewLi
           Out += '	$(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + NewLi
           Out += NewLi
           Out += '$(OBJ_DIR)\' + GetName(DelExt(PrgFiles[nFile])) + '.obj : $(C_DIR)\' + GetName(DelExt(PrgFiles[nFile])) + '.c'  + NewLi
           Out += '	$(CC) $(COBJFLAGS) /Fo$@ $**' + NewLi
         ElseIf upper(Right( PRGFILES [nFile] , 1 )) = 'C'
           Out += NewLi
           Out += '$(C_DIR)\' + GetName(DelExt(PrgFiles[nFile])) + '.c : ' + PrgFiles[nFile] + NewLi

           Out += NewLi
           Out += '$(OBJ_DIR)\' + GetName(DelExt(PrgFiles[nFile])) + '.obj : ' + GetName(DelExt(PrgFiles[nFile])) + '.c'  + NewLi
           Out += '	$(CC) $(COBJFLAGS) /Fo$@ $**' + NewLi
         Endif
    NEXT i

    Hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.Bc' , Out )

    MakeName := BCCFOLDER + If ( Right ( BCCFOLDER , 1 ) != '\' , '\' , '' ) + 'BIN\POMAKE.EXE'
    ParamString := '/F ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.Bc' + ' 1>' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.Log 2>&1'

    Hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + '_Build.Bat' , '@ECHO OFF' + NewLi + MakeName + ' ' + ParamString + ;
                       NewLi + 'Echo End > ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + 'End.Txt' + NewLi )

      Procesando(1)
      Processing := .T.

      main.RichEdit_1.Value := ''
      
      CorreBuildBat()

      END SEQUENCE

      QuitarEspera()
      
      EndBuild()

      Procesando(2)

Return
