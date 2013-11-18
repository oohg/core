/*
 * $Id: LibBcc.prg,v 1.1 2013-11-18 20:40:25 migsoft Exp $
 */

#include "oohg.ch"
#include "mpm.ch"

*---------------------------------------------------------------------*
Procedure BuildLib( ProjectName )  // Borland C
*---------------------------------------------------------------------*

    DECLARE WINDOW main
    DECLARE WINDOW MigMess

    StartBuild()

    BCCFOLDER      := AllTrim(main.text_16.Value)
    CCOMPFOLDER    := BCCFOLDER

    If HBCHOICE = 1
        HARBOURFOLDER  := AllTrim(main.text_20.Value)
        MINIGUIFOLDER  := AllTrim(main.text_23.Value)
    Else
        HARBOURFOLDER  := AllTrim(main.text_4 .Value)
        MINIGUIFOLDER  := AllTrim(main.text_21.Value)
    Endif

    BEGIN SEQUENCE

        MsgBuild()

        EXEOUTPUTNAME := iif( empty(EXEOUTPUTNAME), GetName( Left( PRGFILES [1] , Len(PRGFILES [1] ) - 4 ) ) + '.lib' , EXEOUTPUTNAME+ '.lib' )

        Out := Out + 'HARBOUR_EXE = ' + HARBOURFOLDER + If ( Right ( HARBOURFOLDER , 1 ) != '\' , '\' , '' ) + 'BIN\HARBOUR.EXE'  + NewLi
        Out := Out + 'CC = ' + BCCFOLDER + If ( Right ( BCCFOLDER , 1 ) != '\' , '\' , '' ) + 'BIN\BCC32.EXE'  + NewLi
        Out := Out + 'ILINK_EXE = ' + BCCFOLDER + If ( Right ( BCCFOLDER , 1 ) != '\' , '\' , '' ) + 'BIN\ILINK32.EXE'  + NewLi
        Out := Out + 'BRC_EXE = ' + BCCFOLDER + If ( Right ( BCCFOLDER , 1 ) != '\' , '\' , '' ) + 'BIN\BRC32.EXE'  + NewLi
        Out := Out + 'APP_NAME = ' + EXEOUTPUTNAME                         + NewLi
        Out := Out + 'RC_FILE = ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' ) + 'RESOURCES\oohg.RC'  + NewLi
        Out := Out + 'INCLUDE_DIR = ' + HARBOURFOLDER+'\INCLUDE -I'+MINIGUIFOLDER+'\INCLUDE -I'+BCCFOLDER+'\INCLUDE -I'+PROJECTFOLDER + NewLi
        Out := Out + 'CC_LIB_DIR = ' + BCCFOLDER+'\LIB -L'+HARBOURFOLDER+'\LIB -L'+HARBOURFOLDER+'\LIB\WIN\BCC -L'+MINIGUIFOLDER+'\LIB -L'+PROJECTFOLDER + NewLi
        Out := Out + 'HRB_LIB_DIR = ' + HARBOURFOLDER + If ( Right ( HARBOURFOLDER , 1 ) != '\' , '\' , '' ) + 'LIB'  + NewLi
        Out := Out + 'USR_LIB_DIR = ' + LIBFOLDER + NewLi
        Out := Out + 'OBJ_DIR = ' + PROJECTFOLDER + cOBJ_DIR  + NewLi
        Out := Out + 'C_DIR = ' + PROJECTFOLDER + cOBJ_DIR  + NewLi
        Out := Out + 'TLIB = '+BCCFOLDER+'\BIN\TLIB.EXE'+crlf
        Out := Out + 'USER_FLAGS = ' + NewLi

        HRB_LIB_DIR := HARBOURFOLDER + If ( Right ( HARBOURFOLDER , 1 ) != '\' , '\' , '' ) + 'LIB'  + NewLi

*        Out := Out + 'HARBOUR_FLAGS = /i$(INCLUDE_DIR) /n /w /es2 /gc0 $(USER_FLAGS)' + NewLi
        Out := Out + 'HARBOUR_FLAGS =   /i$(INCLUDE_DIR) /n /b $(USER_FLAGS)' + NewLi

        Out := Out + 'COBJFLAGS =  -c -O2 -tWM -d -6 -OS -I' + BCCFOLDER + If ( Right ( BCCFOLDER , 1 ) != '\' , '\' , '' ) + 'INCLUDE -I$(INCLUDE_DIR) -L' + BCCFOLDER + If ( Right ( BCCFOLDER , 1 ) != '\' , '\' , '' ) + 'LIB' + NewLi

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

        Out := Out + '$(APP_NAME) :	$(OBJ_DIR)\' + GetName(Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )) + '.obj'+ cBarra + NewLi
        
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

        If File(Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )+'.Rc')
            Out := Out + ' $(BRC_EXE) -d__BORLANDC__ -r -fo'+ Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )+'.Res '+ Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )+'.Rc' + NewLi
        Endif

        Out := Out + '	echo '

        For i := 1 To Len( PRGFILES ) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                Out := Out + '+$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.obj'
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                Out := Out + '+$(OBJ_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )) + '.obj'
            Endif
        Next i

        Out := Out + ' > b32.bc' + NewLi

        Out := Out + '	$(TLIB) $@ /P32 @b32.bc ' + NewLi

        For i := 1 To Len ( PrgFiles ) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                Out := Out + NewLi
                Out := Out + '$(C_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.c : ' + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 ) + '.Prg' + NewLi
                Out := Out + '	$(HARBOUR_EXE) $(HARBOUR_FLAGS) $** -o$@'  + NewLi

                Out := Out + NewLi
                Out := Out + '$(OBJ_DIR)\'  + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )) + '.obj : $(C_DIR)\' +  GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4))  + '.c'  + NewLi
                Out := Out + '	$(CC) $(COBJFLAGS) -o$@ $**' + NewLi
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                Out := Out + NewLi
                Out := Out + '$(C_DIR)\' + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )) + '.c : ' + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 ) + '.c' + NewLi

                Out := Out + NewLi
                Out := Out + '$(OBJ_DIR)\'  + GetName(Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )) + '.obj : ' + Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 ) + '.c'  + NewLi
                Out := Out + '	$(CC) $(COBJFLAGS) -o$@ $**' + NewLi
            Endif
        Next i

        Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.bc' , Out )

        MakeName := BCCFOLDER + If ( Right ( BCCFOLDER , 1 ) != '\' , '\' , '' ) + 'BIN\MAKE.EXE'
        ParamString := '-f ' + PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  '_Temp.bc 1>_Temp.log 2>&1'

        Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + ;
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
