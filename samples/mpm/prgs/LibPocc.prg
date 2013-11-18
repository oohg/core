/*
 * $Id: LibPocc.prg,v 1.1 2013-11-18 20:40:25 migsoft Exp $
 */

#include "oohg.ch"
#include "mpm.ch"

*---------------------------------------------------------------------*
Procedure BuildLib4( ProjectName )  // Library Pelles C
*---------------------------------------------------------------------*

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

    BEGIN SEQUENCE

        MsgBuild()

        cMiniGuiFolder := MINIGUIFOLDER
        cBccFolder     := BCCFOLDER
        cProjFolder    := PROJECTFOLDER
        cHarbourFolder := HARBOURFOLDER
        cLibFolder     := iif( empty(LIBFOLDER),'',LIBFOLDER )
        cUserFlags     := iif( empty(USERFLAGS),'',USERFLAGS )
   
        EXEOUTPUTNAME := iif( empty(EXEOUTPUTNAME), GetName( Left( PRGFILES [1] , Len(PRGFILES [1] ) - 4 ) ) + '.lib' , EXEOUTPUTNAME+ '.lib' )

        Out := Out + 'HARBOUR_EXE = '   + cHarbourFolder + '\BIN\HARBOUR.EXE'   + NewLi
        Out := Out + 'CC = '            + cBccFolder     + '\BIN\POCC.EXE'      + NewLi
        Out := Out + 'ILINK_EXE = '     + cBccFolder     + '\BIN\POLINK.EXE'    + NewLi
        Out := Out + 'TLIB = '          + cBccFolder     + '\BIN\POLIB.EXE'     + NewLi
        Out := Out + 'BRC_EXE = '       + cBccFolder     + '\BIN\PORC.EXE'      + NewLi
        Out := Out + 'APP_NAME = '      + EXEOUTPUTNAME                         + NewLi
        Out := Out + 'RC_FILE = '       + cMiniGuiFolder + '\RESOURCES\oohg.RC' + NewLi
        Out := Out + 'GUI_FOLDER = '    + cMiniGuiFolder                        + NewLi
        Out := Out + 'INCLUDE_DIR = '   + cHarbourFolder + '\INCLUDE /i' + cMiniGuiFolder + '\INCLUDE /i' + cProjFolder +'/i' + cbccFolder + '\INCLUDE /i' + cBccFolder + '\INCLUDE\WIN'+ NewLi
        Out := Out + 'CC_LIB_DIR = '    + cBccFolder     + '\LIB'               + NewLi
        Out := Out + 'INCLUDE_C_DIR = ' + cbccFolder     + '\INCLUDE /I' + cBccFolder + '\INCLUDE\WIN /I' + cHarbourFolder + '\INCLUDE /I' + cMiniGuiFolder + '\INCLUDE /I' + cProjFolder + NewLi
        Out := Out + 'USR_LIB_DIR = '   + cProjFolder                           + NewLi
        Out := Out + 'OBJ_DIR = '       + cProjFolder    + cOBJ_DIR  + NewLi
        Out := Out + 'C_DIR = '         + cProjFolder    + cOBJ_DIR  + NewLi
        Out := Out + 'USER_FLAGS = '    + cUserFlags     + NewLi

        Out := Out + 'HARBOUR_FLAGS = /n  /i$(INCLUDE_DIR) $(USER_FLAGS)' + NewLi
        Out := Out + 'COBJFLAGS =  /Ze /Zx /Go /Tx86-coff /D__WIN32__  /I$(INCLUDE_C_DIR)' + NewLi

        Out := Out + NewLi

        cFile1 := Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )

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

        If File(PROJECTFOLDER +'\'+cFile1+'.rc')
            Out += '	$(BRC_EXE) /Fo' + PROJECTFOLDER +'\'+cFile1+'.res ' + PROJECTFOLDER +'\'+cFile1+'.rc ' + NewLi
        Endif

        Out := Out + '	echo /out:$@ > p32.pc' + NewLi

        For i := 1 To Len( PRGFILES ) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                Out := Out + '	echo $(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 ))  + '.obj >> p32.pc' + NewLi
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                Out := Out + '	echo $(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 ))  + '.obj >> p32.pc' + NewLi
            Endif
        Next i

        Out := Out + '	-$(TLIB) @p32.pc' + NewLi

        For i := 1 To Len ( PrgFiles ) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                Out := Out + NewLi
                Out := Out + '$(C_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.c : ' + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 ) + '.Prg' + NewLi
                Out := Out + '	$(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + NewLi

                Out := Out + NewLi
                Out := Out + '$(OBJ_DIR)\'  + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.obj : $(C_DIR)\' +  GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.c'  + NewLi
                Out := Out + '	$(CC) $(COBJFLAGS) /Fo$@ $**' + NewLi
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                Out := Out + NewLi
                Out := Out + '$(C_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )) + '.c : ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 ) + '.c' + NewLi

                Out := Out + NewLi
                Out := Out + '$(OBJ_DIR)\'  + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )) + '.obj : ' + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 ) + '.c'  + NewLi
                Out := Out + '	$(CC) $(COBJFLAGS) /Fo$@ $**' + NewLi
            Endif
        Next i

        hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.Bc' , Out )

        MakeName := BCCFOLDER + If ( Right ( BCCFOLDER , 1 ) != '\' , '\' , '' ) + 'BIN\POMAKE.EXE'
        ParamString := '/F ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.Bc' + ' 1>_Temp.Log 2>&1'

        hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + ;
         '_Build.Bat' , '@ECHO OFF' + NewLi + MakeName + ' ' + ParamString + ;
         NewLi + 'Echo End > ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + ;
         'End.Txt' + NewLi )

        Procesando(1)
        Processing := .t.

        main.RichEdit_1.Value := ''

        CorreBuildBat()

    END SEQUENCE
      
    QuitarEspera()

    main.Tab_1.value := 7

    If File(EXEOUTPUTNAME)
        MsgInfo('Library File: '+ EXEOUTPUTNAME+' is OK',"Project Build")
    Endif

    Procesando(2)

Return
