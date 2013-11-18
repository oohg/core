/*
 * $Id: ExeCommon.prg,v 1.1 2013-11-18 20:40:24 migsoft Exp $
 */

#include "oohg.ch"
#include "mpm.ch"

Procedure StartBuild()

   DECLARE WINDOW main
   DECLARE WINDOW MigMess

   Out                   := ''
   main.RichEdit_1.Value := ''
   PRGFILES              := {}
   CFILES                := {}
   LIBFILES              := {}

   PROJECTFOLDER  := AllTrim(main.text_1.Value)
   EXEOUTPUTNAME  := AllTrim(main.text_2.Value)

   WLEVEL         := main.RadioGroup_1.Value
   WITHDEBUG      := main.RadioGroup_2.Value
   WITHGTMODE     := main.RadioGroup_3.Value
   INCREMENTAL    := main.RadioGroup_4.Value
   HBCHOICE       := main.RadioGroup_5.Value

   If     main.RadioGroup_6.Value = 1
          USERFLAGS      := AllTrim(main.text_24.Value)
          USERCFLAGS     := AllTrim(main.text_12.Value)
          USERLFLAGS     := AllTrim(main.text_13.Value)
   ElseIf main.RadioGroup_6.Value = 2
          USERFLAGS      := AllTrim(main.text_44.Value)
          USERCFLAGS     := AllTrim(main.text_32.Value)
          USERLFLAGS     := AllTrim(main.text_33.Value)
   ElseIf main.RadioGroup_6.Value = 3
          USERFLAGS      := AllTrim(main.text_54.Value)
          USERCFLAGS     := AllTrim(main.text_42.Value)
          USERLFLAGS     := AllTrim(main.text_43.Value)
   ElseIf main.RadioGroup_6.Value = 4
          USERFLAGS      := AllTrim(main.text_64.Value)
          USERCFLAGS     := AllTrim(main.text_52.Value)
          USERLFLAGS     := AllTrim(main.text_53.Value)
   Endif

   OBJFOLDER      := UPPER(AllTrim(main.Text_5.Value))
   LIBFOLDER      := UPPER(AllTrim(main.Text_6.Value))
   INCFOLDER      := UPPER(AllTrim(main.Text_7.Value))

Return

Procedure MsgBuild()

      DO EVENTS

      if Empty ( ProjectName )
         MsgStop('You must save project first')
         BREAK
      EndIf

      If Empty ( ProjectFolder ) .Or. Empty ( main.List_1.Item(1) )  .Or. Empty (CCOMPFOLDER) .Or. Empty (MiniGUIFolder) .Or. Empty (HarbourFolder)
         MsgStop ( 'One or more required fields is not complete','')
         BREAK
      EndIf

      SetCurrentFolder (PROJECTFOLDER)

      cOBJ_DIR := iif(empty(OBJFOLDER),'\'+MyOBJName(),'\'+GetName(OBJFOLDER))

      MakeInclude(MINIGUIFOLDER,Auto_GUI(MINIGUIFOLDER))

      If INCREMENTAL = 2
         BorraOBJ(PROJECTFOLDER,cOBJ_DIR)
      Endif

      If ( main.RadioGroup_7.Value == 1 ) // EXE
         If File( GetName(ExeName)+'.exe' )
            if MsgYesNo('File: '+ GetName(ExeName)+'.exe Already Exist, Rebuild?',"Rebuild Project") == .F.
               BREAK
            Else
               main.RichEdit_1.Value := ''
            Endif
         Endif
      Endif

      PonerEspera('Compiling...')

      For i := 1 To main.List_1.ItemCount
          DO EVENTS
          aadd ( PRGFILES , Alltrim(main.List_1.Item(i)) )
      Next i

      For i := 1 To main.List_1.ItemCount
          DO EVENTS
          aadd ( CFILES , Alltrim(main.List_1.Item(i)) )
      Next i

      For i := 1 To main.List_2.ItemCount
          DO EVENTS
          aadd ( LIBFILES , Alltrim(main.List_2.Item(i)) )
      Next i

      CreateFolder ( PROJECTFOLDER + cOBJ_DIR )

Return

Procedure EndBuild()

      main.Tab_1.value := 7

      If File(PROJECTFOLDER+'\'+GetName(ExeName)+'.exe') .and. TxtSearch('error') == .F.
         if MsgYesNo('Execute File: ['+ GetName(ExeName)+'.exe] ?',"Project Build") == .T.
            cursorwait2()
            If main.Check_1.value == .T.
               If MsgYesNo('Compress File: ['+ GetName(ExeName)+'.exe] ?',"Compress Exe with UPX") == .T.
                  PonerEspera('Compress...')
                  ComprimoExe(PROJECTFOLDER,GetName(ExeName))
                  QuitarEspera()
               Endif
            Endif
            EXECUTE FILE PROJECTFOLDER +'\'+GetName(ExeName)
            cursorarrow2()
         Else
            main.RichEdit_1.Value := 'File: [' + GetName(ExeName) + '.exe] is OK'
            main.Tab_1.value := 7
            main.RichEdit_1.Setfocus
         Endif
         DELETE FILE ( PROJECTFOLDER + '\_Temp.Log' )
      Else
         main.RichEdit_1.Setfocus
      Endif

Return


Function WathLibLink(MiniGuiFolder,HBCHOICE)
    Local Out := ""

         If HBCHOICE = 2               // xHarbour
            if File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'XLIB\oohg.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'XLIB\oohg.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'XLIB\hbprinter.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'XLIB\miniprint.LIB + >> b32.bc' + NewLi
            ElseIf File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'XLIB\minigui.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'XLIB\minigui.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + HARBOURFOLDER + If ( Right ( HARBOURFOLDER , 1 ) != '\' , '\' , '' )  + 'XLIB\hbprinter.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + HARBOURFOLDER + If ( Right ( HARBOURFOLDER , 1 ) != '\' , '\' , '' )  + 'XLIB\miniprint.LIB + >> b32.bc' + NewLi
            ElseIf File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\oohg.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\oohg.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\hbprinter.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\miniprint.LIB + >> b32.bc' + NewLi
            ElseIf File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\fivehx.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\fivehx.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\fivehc.LIB + >> b32.bc' + NewLi
            ElseIf File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\xhb\bcc\oohg.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\xhb\bcc\oohg.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\xhb\bcc\hbprinter.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\xhb\bcc\miniprint.LIB + >> b32.bc' + NewLi
            Endif
         Else
            if File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\oohg.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\oohg.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\hbprinter.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\miniprint.LIB + >> b32.bc' + NewLi
            ElseIf File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\bcc\oohg.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\bcc\oohg.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\bcc\hbprinter.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\bcc\miniprint.LIB + >> b32.bc' + NewLi
            ElseIf File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\hb\bcc\oohg.LIB')
                  Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\hb\bcc\oohg.LIB + >> b32.bc' + NewLi
                  Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\hb\bcc\hbprinter.LIB + >> b32.bc' + NewLi
                  Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\hb\bcc\miniprint.LIB + >> b32.bc' + NewLi
            ElseIf File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\fiveh.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\fiveh.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\fivehc.LIB + >> b32.bc' + NewLi
            ElseIf File(MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\minigui.LIB')
               Out := Out + '	echo ' + MINIGUIFOLDER + If ( Right ( MINIGUIFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\minigui.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + HARBOURFOLDER + If ( Right ( HARBOURFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\hbprinter.LIB + >> b32.bc' + NewLi
               Out := Out + '	echo ' + HARBOURFOLDER + If ( Right ( HARBOURFOLDER , 1 ) != '\' , '\' , '' )  + 'LIB\miniprint.LIB + >> b32.bc' + NewLi
            endif
         Endif

Return( Out )