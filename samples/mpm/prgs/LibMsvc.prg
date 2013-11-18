/*
 * $Id: LibMsvc.prg,v 1.1 2013-11-18 20:40:25 migsoft Exp $
 */

#include "oohg.ch"
#include "mpm.ch"

*---------------------------------------------------------------------*
Procedure BuildLib5( ProjectName )  // Library Visual C
*---------------------------------------------------------------------*
    DECLARE WINDOW main
    DECLARE WINDOW MigMess

    StartBuild()

    BCCFOLDER      := AllTrim(main.Text_27.Value)
    CCOMPFOLDER    := BCCFOLDER

    If HBCHOICE = 1
      HARBOURFOLDER  := AllTrim(main.Text_25.Value)
      MINIGUIFOLDER  := AllTrim(main.Text_29.Value)
    Else
      HARBOURFOLDER  := AllTrim(main.Text_26.Value)
      MINIGUIFOLDER  := AllTrim(main.Text_30.Value)
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
        Out := Out + 'CC = '            + 'CL.EXE'       + NewLi
        Out := Out + 'ILINK_EXE = '     + 'LINK.EXE'     + NewLi
        Out := Out + 'TLIB = '          + 'LIB.EXE'      + NewLi
        Out := Out + 'BRC_EXE = '       + 'RC.EXE'       + NewLi
        Out := Out + 'APP_NAME = '      + EXEOUTPUTNAME                         + NewLi
        Out := Out + 'RC_FILE = '       + cMiniGuiFolder + '\RESOURCES\oohg.RC' + NewLi
        Out := Out + 'GUI_FOLDER = '    + cMiniGuiFolder                        + NewLi
        Out := Out + 'INCLUDE_DIR = '   + cHarbourFolder + '\INCLUDE /i' + cMiniGuiFolder + '\INCLUDE /i' + AddQuote( cProjFolder +'\INCLUDE' ) + NewLi
        Out := Out + 'CC_LIB_DIR = '    + AddQuote( cBccFolder + '\LIB' ) + NewLi
        Out := Out + 'INCLUDE_C_DIR = ' + AddQuote( cbccFolder + '\INCLUDE' ) + ' /I'+cHarbourFolder + '\INCLUDE /I' + cMiniGuiFolder + '\INCLUDE /I' + cProjFolder + NewLi
        Out := Out + 'USR_LIB_DIR = '   + cProjFolder                           + NewLi
        Out := Out + 'OBJ_DIR = '       + cProjFolder    + cOBJ_DIR  + NewLi
        Out := Out + 'C_DIR = '         + cProjFolder    + cOBJ_DIR  + NewLi
        Out := Out + 'USER_FLAGS = '    + cUserFlags     + NewLi

        Out := Out + 'HARBOUR_FLAGS = /n  /i$(INCLUDE_DIR) $(USER_FLAGS)' + NewLi

        Out := Out + 'COBJFLAGS =  /O2 /c /W3 /nologo /D__WIN32__ /D_CRT_SECURE_NO_WARNINGS' + '/I$(INCLUDE_C_DIR)' + NewLi

        Out := Out + NewLi

        If upper(Right( PRGFILES [1] , 3 )) = 'PRG'
            cFile1 := Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )
        Else
            cFile1 := Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 2 )
        Endif

        if ( main.List_1.ItemCount > 2 )
            cBarra := ' \'
        Else
            cBarra := ''
        Endif

        Out += '$(APP_NAME) : $(OBJ_DIR)\' + GetName(Left ( PRGFILES [1] , Len( PRGFILES [1] ) - 4 ))  + '.obj'+ cBarra + NewLi

        For i := 2 TO Len ( PrgFiles )
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                IF i == Len ( PrgFiles )
                    Out += '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len( PRGFILES [i] ) - 4 ))  + '.obj' + NewLi
                ELSE
                    Out += '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len( PRGFILES [i] ) - 4 ))  + '.obj \' + NewLi
                ENDIF
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                IF i == Len ( PrgFiles )
                    Out += '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len( PRGFILES [i] ) - 2 ))  + '.obj' + NewLi
                ELSE
                    Out += '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len( PRGFILES [i] ) - 2 ))  + '.obj \' + NewLi
                ENDIF
            Endif
        Next i

        If File(PROJECTFOLDER +'\'+GetName(Left ( PRGFILES [1] , Len( PRGFILES [1] ) - 4 ))+'.rc')
            Out += '	$(BRC_EXE) /Fo ' + PROJECTFOLDER +'\'+GetName(Left ( PRGFILES [1] , Len( PRGFILES [1] ) - 4 ))+'.res ' + PROJECTFOLDER +'\'+GetName(Left ( PRGFILES [1] , Len( PRGFILES [1] ) - 4 ))+'.rc ' + NewLi
        Endif

        Out := Out + '	echo /out:$@ > p32.pc' + NewLi

        For i := 1 To Len( PRGFILES )
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                Out := Out + '	echo $(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 ))  + '.obj >> p32.pc' + NewLi
            ElseIf upper(Right( PRGFILES [i] , 3 )) = 'C'
                Out := Out + '	echo $(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 ))  + '.obj >> p32.pc' + NewLi
            Endif
        Next i

        Out := Out + '	$(TLIB) @p32.pc' + NewLi

        For i := 1 To Len ( PrgFiles )
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                Out := Out + NewLi
                Out := Out + '$(C_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.c : ' + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 ) + '.Prg' + NewLi
                Out := Out + '	$(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + NewLi

                Out := Out + NewLi
                Out := Out + '$(OBJ_DIR)\'  + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.obj : $(C_DIR)\' +  GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.c'  + NewLi
                Out := Out + '	$(CC) $(COBJFLAGS) /Fo$@ $**' + NewLi
            ElseIF upper(Right( PRGFILES [i] , 1 )) = 'C'
                Out := Out + NewLi
                Out := Out + '$(C_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )) + '.c : ' + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 ) + '.c' + NewLi

                Out := Out + NewLi
                Out := Out + '$(OBJ_DIR)\'  + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )) + '.obj : ' + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 ) + '.c'  + NewLi
                Out := Out + '	$(CC) $(COBJFLAGS) /Fo$@ $**' + NewLi
            Endif
        Next i

        hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.Bc' , Out )

        MakeName := 'nmake.exe'
        ParamString := '/F ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.Bc' + ' 1>_Temp.Log 2>&1'

        Hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + '_Build.Bat' , ;
                  '@ECHO OFF' + NewLi + 'call '+AddQuote( BCCFOLDER ) +'\vcvarsall.bat x86' + NewLi + ;
                   MakeName + ' ' + ParamString + NewLi + 'Echo End > ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + 'End.Txt' + NewLi )

//                  '@ECHO OFF' + NewLi + 'call "%ProgramFiles%\Microsoft Visual Studio 10.0\VC\vcvarsall.bat" x86' + NewLi + ;
                   
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


