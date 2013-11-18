/*
 * $Id: LibGcc.prg,v 1.1 2013-11-18 20:40:25 migsoft Exp $
 */

#include "oohg.ch"
#include "mpm.ch"

*---------------------------------------------------------------------*
Procedure Build2Lib( ProjectName )  // Library MinGW
*---------------------------------------------------------------------*

    DECLARE WINDOW main
    DECLARE WINDOW MigMess

    StartBuild()

    MINGW32FOLDER  := AllTrim(main.Text_11.Value)
    CCOMPFOLDER    := MINGW32FOLDER

    If HBCHOICE = 1
      HARBOURFOLDER  := AllTrim(main.Text_8.Value)
      MINIGUIFOLDER  := AllTrim(main.Text_14.Value)
    Else
      HARBOURFOLDER  := AllTrim(main.Text_3.Value)
      MINIGUIFOLDER  := AllTrim(main.Text_19.Value)
    Endif

    BEGIN SEQUENCE

        MsgBuild()

        If WITHDEBUG = 2
            cDEBUG = ' -b'
        Else
            cDEBUG = ''
        Endif

        EXEOUTPUTNAME := iif( empty(EXEOUTPUTNAME), 'lib'+GetName( Left( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )+'.a' ) , 'lib'+EXEOUTPUTNAME+'.a' )

        // cCUserFlags := iif( empty(AllTrim(main.Text_12.Value)),'-Wall -mno-cygwin -O3',AllTrim(main.Text_12.Value) )
        cCUserFlags := iif( empty(AllTrim(main.Text_12.Value)),'-Wall -O3',AllTrim(main.Text_12.Value) )
        cUserFlags  := iif( empty(USERFLAGS),'',' '+USERFLAGS )
        cIncFolder  := MINIGUIFOLDER + '\INCLUDE' + ' -I'+HARBOURFOLDER + '\INCLUDE' + IIF( Empty( INCFOLDER ),"",' -I'+ INCFOLDER )
        cLibFolder  := IIF( Empty( LIBFOLDER ),"",' -L'+ LIBFOLDER )

        Out := Out + 'PATH = '+MINGW32FOLDER+'\BIN;'+MINGW32FOLDER+'\LIBEXEC\GCC\MINGW32\3.4.5'+';'+PROJECTFOLDER +NewLi
        Out := Out + 'APP_NAME = ' + EXEOUTPUTNAME +NewLi
        Out := Out + 'MINGW = '+MINGW32FOLDER +NewLi
        Out := Out + 'HRB_DIR = '+HARBOURFOLDER  +NewLi
        Out := Out + 'MINIGUI_INSTALL = '+MINIGUIFOLDER  +NewLi
        Out := Out + 'INC_DIR = '+ cIncFolder + NewLi
        Out := Out + 'OBJ_DIR = ' + PROJECTFOLDER + cOBJ_DIR  + NewLi
        Out := Out + 'PROJECTFOLDER = '+PROJECTFOLDER +NewLi
        Out := Out + 'TLIB = '+MINGW32FOLDER+'\BIN\AR.EXE'+NewLi
        Out := Out + 'CFLAGS = '+ cCUserFlags +NewLi

        Out := Out + NewLi

        If upper(Right( PRGFILES [1] , 3 )) = 'PRG'
            cFile1 := Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )
        ElseIF upper(Right( PRGFILES [1] , 1 )) = 'C'
            cFile1 := Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 2 )
        Endif

        Out := Out + '$(APP_NAME):'
        
        nTotFmgs := 0

        For i := 2 TO Len ( PrgFiles )
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'FMG'
                nTotFmgs := nTotFmgs + 1
            Endif
        Next              

        For n := 1 TO Len(PrgFiles)
            DO EVENTS
            If upper(Right( PRGFILES [n] , 3 )) = 'PRG'
                If n == Len(PrgFiles) - nTotFmgs
                    Out := Out + '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [n] , Len( PRGFILES [n] ) - 4 )  + '.o') + NewLi
                Else
                    Out := Out + '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [n] , Len( PRGFILES [n] ) - 4 )  + '.o')+' \' + NewLi
                Endif
            ElseIf upper(Right( PRGFILES [n] , 1 )) = 'C'
                If n == Len(PrgFiles) - nTotFmgs
                    Out := Out + '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [n] , Len( PRGFILES [n] ) - 2 )  + '.o') + NewLi
                Else
                    Out := Out + '	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [n] , Len( PRGFILES [n] ) - 2 )  + '.o')+' \' + NewLi
                Endif
            Endif
        Next

        For i := 1 To Len ( PrgFiles) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )
            Else
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )
            Endif
*            Out := Out + '	$(TLIB) rc '+cFile1+'.a $(OBJ_DIR)\'+GetName(cfile+'.o')+NewLi
            Out := Out + '	$(TLIB) rc '+EXEOUTPUTNAME+' $(OBJ_DIR)\'+GetName(cfile+'.o')+NewLi
        Next i

        Out := Out + NewLi

        For i := 1 To Len ( PrgFiles) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )
                Out := Out +'$(OBJ_DIR)\'+GetName(cfile)+'.o    : $(OBJ_DIR)\'+GetName(cfile)+'.c'+NewLi
                Out := Out +'	gcc $(CFLAGS) -c -I$(INC_DIR) -I$(HRB_DIR)\include -I$(MINGW)\include -I$(MINGW)/LIB/GCC/MINGW32/3.4.5/include -o$@ $^'+NewLi
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )
                Out := Out +'$(OBJ_DIR)\'+GetName(cfile)+'.o    : '+cfile+'.c'+NewLi
                Out := Out +'	gcc $(CFLAGS) -c -I$(INC_DIR) -I$(HRB_DIR)\include -I$(MINGW)\include -I$(MINGW)/LIB/GCC/MINGW32/3.4.5/include -o$@ $^'+NewLi
            Endif
        next i

        Out := Out + NewLi

        For i := 1 To Len ( PrgFiles) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )
                Out := Out +'$(OBJ_DIR)\'+GetName(cfile)+'.c   : '+cfile+'.prg'+NewLi
                Out := Out +'	$(HRB_DIR)\bin\harbour.exe $^ -n '+RetHbLevel()+cUserFlags+cDEBUG+'-I$(HRB_DIR)\include -I$(MINIGUI_INSTALL)/include -i$(INC_DIR) -I$(PROJECTFOLDER) -d__WINDOWS__ -o$@ $^'+NewLi
            Endif
        next i

        Out := Out + NewLi
        Out := Out + '.prg.c:'+NewLi
        Out := Out + '	$(HRB_DIR)\bin\harbour.exe $^ -n -I$(HRB_DIR)\include -i$(INC_DIR) -d__WINDOWS__ -o$@ $^'+NewLi
        Out := Out + NewLi
        Out := Out + '.c.o:'+NewLi
        Out := Out + '	$(HRB_DIR)\bin\gcc $(CFLAGS) -c -I$(INC_DIR) -I$(HRB_DIR)\include -o $@ $^'+NewLi
        Out := Out + NewLi

        hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  'Makefile.Gcc' , Out )

        MakeName    := mingw32folder+'\BIN\mingw32-make.exe'
        ParamString := '-f  makefile.gcc 1>_Temp.log 2>&1'

        hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + '_Build.Bat' , 'REM @echo off' + NewLi +"REM SET PATH=;"+NewLi+ MakeName + ' ' + ParamString +NewLi + 'Echo End > ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + 'End.Txt' + NewLi )

        Procesando(1)

        Processing := .T.

        main.RichEdit_1.Value := ''

        CorreBuildBat()
   
    END SEQUENCE

    QuitarEspera()

    main.Tab_1.value := 7

    If File(EXEOUTPUTNAME)
        MsgInfo('Library File: '+ EXEOUTPUTNAME+' is OK',"Project Build")
        Ferase('_Temp.log')
    Endif

    Procesando(2)

Return
