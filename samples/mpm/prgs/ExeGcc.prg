/*
 * $Id: ExeGcc.prg,v 1.1 2013-11-18 20:40:24 migsoft Exp $
 */

#include "oohg.ch"
#include "mpm.ch"

#ifndef __HARBOUR__
   #xtranslate hb_MemoWrit(<a>,<b>) => Memowrit(<a>,<b>,.N.)
#else
   #xtranslate MemoWrit(<a>,<b>,<c>) => hb_MemoWrit(<a>,<b>)
#endif


*---------------------------------------------------------------------*
Procedure Build2( ProjectName )  // Executable MinGW
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

    WATHGUI        := Auto_GUI(MINIGUIFOLDER)
    cLibsUser      := ''

    ExeName := iif(empty(EXEOUTPUTNAME), Left ( Alltrim(main.List_1.Item(1)), Len(Alltrim(main.List_1.Item(1))) - 4 ) , EXEOUTPUTNAME )

    BEGIN SEQUENCE

        MsgBuild()

        If WITHDEBUG = 2
            cDEBUG = ' -b'
        Else
            cDEBUG = ''
        Endif

        cUserFlags := iif( empty(USERFLAGS),'',' '+USERFLAGS )
        cIncFolder := MINIGUIFOLDER + '\INCLUDE' + ' -I'+HARBOURFOLDER + '\INCLUDE' + IIF( Empty( INCFOLDER ),"",' -I'+ INCFOLDER )
        cLibFolder := IIF( Empty( LIBFOLDER ),"",' -L'+ LIBFOLDER )

        Out := Out + 'PATH = '+MINGW32FOLDER+'\BIN;'+MINGW32FOLDER+'\LIBEXEC\GCC\MINGW32\3.4.5'+';'+PROJECTFOLDER +NewLi
        Out := Out + 'MINGW = '+MINGW32FOLDER +NewLi
        Out := Out + 'HRB_DIR = '+HARBOURFOLDER  +NewLi
        Out := Out + 'MINIGUI_INSTALL = '+MINIGUIFOLDER  +NewLi
        Out := Out + 'INC_DIR = '+ cIncFolder + NewLi
        Out := Out + 'OBJ_DIR = '+PROJECTFOLDER + cOBJ_DIR + NewLi
        Out := Out + 'PROJECTFOLDER = '+PROJECTFOLDER +NewLi
        Out := Out + 'USER_FLAGS = '+USERFLAGS +NewLi

        If WITHGTMODE = 2
           // Out := Out + 'CFLAGS = -Wall -mno-cygwin -O3' +NewLi
            Out := Out + 'CFLAGS = -Wall -O3' +NewLi
            
        Else
           // Out := Out + 'CFLAGS = -Wall -mwindows -mno-cygwin -O3 -Wl,--allow-multiple-definition '+USERCFLAGS+NewLi
            Out := Out + 'CFLAGS = -Wall -mwindows -O3 -Wl,--allow-multiple-definition '+USERCFLAGS+NewLi
         // Out := Out + 'CFLAGS = -Wall -mwindows -mno-cygwin -O3 ' +NewLi
        Endif

        Out := Out + NewLi

        // Resources make File .o
        cFilerc := Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )

        Crea_temp_rc( GetName(cFilerc) )    // Make File "_temp.rc"

        Out := Out +'SOURCE='+GetName(ExeName)+NewLi
        Out := Out + NewLi

        cFile1 := Left ( PRGFILES [1] , Len(PRGFILES [1] ) - 4 )
        Out := Out + 'all: '+GetName(cfile1)+'.exe $(OBJ_DIR)/'+GetName(cFile1)+'.o $(OBJ_DIR)/'+GetName(cfile1)+'.c'

        nTotFmgs := 0

        For i := 2 TO Len ( PrgFiles )
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'FMG'
                nTotFmgs := nTotFmgs + 1
            Endif
        Next

        For i := 2 To Len ( PrgFiles) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )
                Out := Out + ' $(OBJ_DIR)/'+GetName(cfile)+'.o $(OBJ_DIR)/'+GetName(cfile)+'.c'
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )
                Out := Out + ' $(OBJ_DIR)/'+GetName(cfile)+'.o '+cfile+'.c'
            Endif
        Next i

        Out := Out +' $(MINIGUI_INSTALL)/resources/_temp.o $(MINIGUI_INSTALL)/resources/_temp.rc '

        Out := Out + NewLi
        Out := Out + NewLi

        Out := Out + GetName(cFile1)+'.exe  :'

        For i := 1 To Len ( PrgFiles) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )
            Endif
            Out := Out +' $(OBJ_DIR)/'+GetName(cfile)+'.o '
        Next

        Out := Out +' $(MINIGUI_INSTALL)/resources/_temp.o '

        Out := Out + NewLi
        Out := Out + '	gcc $(CFLAGS) -o$(SOURCE).exe '

        For i := 1 To Len ( PrgFiles) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )
            ElseIf upper(Right( PRGFILES [i] , 1 )) = 'C'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )
            Endif
            Out := Out +'$(OBJ_DIR)/'+GetName(cfile)+'.o '
        NEXT I

        For i := 1 To Len ( LIBFILES)
            DO EVENTS
            If UPPER(Right(LIBFILES [i],1))='A'
                cFilea    := Left ( LIBFILES [i] , Len(LIBFILES [i] ) - 2 )
                cLibsUser := cLibsUser + ' -l'+SubStr( GetName(cFilea),4,(Len(GetName(cFilea))-2) )
            Endif
        NEXT I

        Out := Out +' $(MINIGUI_INSTALL)/resources/_temp.o '

        If HBCHOICE == 1
            cRutaLibs :=' -L$(MINIGUI_INSTALL)/lib -L$(MINIGUI_INSTALL)/lib/hb/mingw '
        Else
            cRutaLibs :=' -L$(MINIGUI_INSTALL)/lib -L$(MINIGUI_INSTALL)/lib/xhb/mingw '
        Endif

        Out := Out +'-L$(MINGW)/lib -L$(HRB_DIR)/lib -L$(HRB_DIR)/lib/win/mingw'+cLibFolder+cRutaLibs+' -L. -Wl,--start-group '

        cHMGLibs1  :=' -lhmg '+cLibsUser
        cHMGLibs2  :=' -lgraph -ledit -lreport -lini -leditex -lcrypt '

        cMGELibs1  :=' -lminigui -lhbprinter -lminiprint '+cLibsUser
        cMGELibs2  :=' -ltsbrowse -lcalldll -ladordd -lmsvfw32'

        cOohgLibs1 :=' -looHG -lhbprinter -lminiprint '+cLibsUser

        cMinGWLibs :=' -luser32 -lwinspool -lcomctl32 -lcomdlg32 -lgdi32 -lole32 -loleaut32 -luuid -lwinmm -lvfw32 -lwsock32 -lmsimg32 -lws2_32 '

        If HBCHOICE = 1
            cHbLibs1   := HbLibs(HARBOURFOLDER,1,1)
        Else
            cHbLibs1   := HbLibs(HARBOURFOLDER,2,1)
        Endif

        // Include rest of libs here

        If WITHGTMODE = 1                     // GUI
            Out := Out + ' -lgtgui '
            If WATHGUI = 3                     // HMG
                Out := Out + ' -lgtwin '
            Endif
        Endif
        If WITHGTMODE = 2
            Out := Out + ' -lgtwin '           // Console
        Endif
        If WITHGTMODE = 3                     // Mixed
            Out := Out + ' -lgtgui '
            Out := Out + ' -lgtwin '
        Endif

        If WATHGUI = 1                        // ooHG
            Out := Out + cOohgLibs1 + cMinGWLibs + cHbLibs1
        Endif
        If WATHGUI = 2                         // MiniGUI
            Out := Out + cMGELibs1 + cMGELibs2 + cMinGWLibs + cHbLibs1
        Endif
        If WATHGUI = 3                         // HMG
            CreaGT(WITHGTMODE)
            Out := Out + cHMGLibs1 + cHMGLibs2 + cMinGWLibs + cHbLibs1
        Endif

        Out := Out + ' -Wl,--end-group '
        Out := Out + NewLi

        For i := 1 To Len ( PrgFiles)  - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )
                Out := Out +'$(OBJ_DIR)/'+GetName(cfile)+'.o    : $(OBJ_DIR)/'+GetName(cfile)+'.c'+NewLi
                Out := Out +'	gcc $(CFLAGS)  -I$(INC_DIR) -I$(HRB_DIR)/include -I$(MINGW)/include -I$(MINGW)/LIB/GCC/MINGW32/3.4.5/include -I. -c $(OBJ_DIR)/'+GetName(cfile)+'.c -o $(OBJ_DIR)/'+GetName(cfile)+'.o'+NewLi
            ElseIF upper(Right( PRGFILES [i] , 1 )) = 'C'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 2 )
                Out := Out +'$(OBJ_DIR)/'+GetName(cfile)+'.o    : '+cfile+'.c'+NewLi
                Out := Out +'	gcc $(CFLAGS)  -I$(INC_DIR) -I$(HRB_DIR)/include -I$(MINGW)/include -I$(MINGW)/LIB/GCC/MINGW32/3.4.5/include -I. -c '+cfile+'.c -o $(OBJ_DIR)/'+GetName(cfile)+'.o'+NewLi
            Endif
        next i

        Out := Out + NewLi

        Out := Out +'$(MINIGUI_INSTALL)/resources/_temp.o    : $(MINIGUI_INSTALL)/resources/'+'_temp.rc'+NewLi
        Out := Out +'	$(MINGW)/bin/windres.exe -i $^ -o$@' +NewLi

        Out := Out + NewLi

        For i := 1 To Len ( PrgFiles) - nTotFmgs
            DO EVENTS
            If upper(Right( PRGFILES [i] , 3 )) = 'PRG'
                cfile := Left ( PRGFILES [i] , Len(PRGFILES [i] ) - 4 )
                Out := Out +'$(OBJ_DIR)/'+GetName(cfile)+'.c   : '+cfile+'.prg'+NewLi
                Out := Out +'	$(HRB_DIR)/bin/harbour.exe $^ -n '+RetHbLevel()+cUserFlags+cDEBUG+' -I$(HRB_DIR)/include -I$(MINIGUI_INSTALL)/include -i$(INC_DIR) -I$(PROJECTFOLDER) -I. -d__WINDOWS__ -o$@ $^'+NewLi
            Endif
        next i

        hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  'Makefile.Gcc' , Out )

        If File(PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) +  'Makefile.Gcc')
            MakeName    := mingw32folder+'\BIN\mingw32-make.exe'
            ParamString := '-f  makefile.gcc 1>_Temp.log 2>&1'
        Endif

        hb_Memowrit ( PROJECTFOLDER + If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + '_Build.Bat' , 'REM @echo off' + NewLi ;
                    +"REM SET PATH=;"+NewLi+ MakeName + ' ' + ParamString +NewLi + 'Echo End > ' + PROJECTFOLDER + ;
                    If ( Right ( PROJECTFOLDER , 1 ) != '\' , '\' , '' ) + 'End.Txt' + NewLi )

        Procesando(1)

        Processing := .T.

        main.RichEdit_1.Value := ''

        CorreBuildBat()

    END SEQUENCE

    QuitarEspera()

    EndBuild()

    Procesando(2)

Return

Procedure CreaGT(nOpt)
    Local cDos,cDos2,cDos3

    If !File(MINIGUIFOLDER+"\include\respa.ch")
      cDos3 := "/c copy /b "+MINIGUIFOLDER+"\include\minigui.ch "+MINIGUIFOLDER+"\include\respa.ch >NUL"
      EXECUTE FILE "CMD.EXE" PARAMETERS cDos3 HIDE
    Endif

    If nOpt = 2
       cDos := "/c echo REQUEST HB_GT_WIN_DEFAULT > "+MINIGUIFOLDER+"\include\mpm_gt.ch"
    Else
       cDos := "/c echo REQUEST HB_GT_GUI_DEFAULT > "+MINIGUIFOLDER+"\include\mpm_gt.ch"
    Endif

    EXECUTE FILE "CMD.EXE" PARAMETERS cDos HIDE

    hb_Memowrit ( MINIGUIFOLDER+"\include\i_temp.ch" , "#include "+'"mpm_gt.ch"'+ NewLi )

    cDos2 := "/c copy /b "+MINIGUIFOLDER+"\include\respa.ch+"+MINIGUIFOLDER+"\include\i_temp.ch "+MINIGUIFOLDER+"\include\minigui.ch >NUL"

    EXECUTE FILE "CMD.EXE" PARAMETERS cDos2 HIDE

Return
