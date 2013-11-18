/*
 * $Id: mpm.ch,v 1.1 2013-11-18 20:46:50 migsoft Exp $
 */

#define cAppName      '(c)2008-2012 MigSoft Project Manager'
#define cAddMail      ' - mig2soft@yahoo.com'
#define NewLi         Hb_OSNewLine()
#define cBackS        Hb_OsPathSeparator()

//#xtranslate Hb_CurDrive() => Curdrive()

#define MPM_OOHG      1
#define MPM_MINIGUI   2
#define MPM_HMG       3
#define MPM_FWH       4
#define MPM_MINGW     1
#define MPM_BORLAND   2
#define MPM_PELLES    3
#define MPM_HARBOUR   1
#define MPM_XHARBOUR  2
#define MPM_GTGUI     1
#define MPM_GTWIN     2
#define MPM_GTMIX     3
#define MPM_INCREM    1
#define MPM_REBUILD   2
#define MPM_NODEBUG   1
#define MPM_DEBUG     2
#define MPM_OUTEXE    1
#define MPM_OUTLIB    2

MemVar folder,sfile,i,out,cfile1,prgfiles,cfiles,libfiles,cfilea,clibsuser,chmglibs2,coohglibs1
MemVar cmingwlibs,harbourfolder,withgtmode,wathgui,afiles,cdos,cdos1,projectfolder,processing
MemVar cos,fmgfiles,withdebug,incremental,hbchoice,bccfolder,objfolder,libfolder,incfolder,miniguifolder
MemVar cbarra,makename,paramstring,n,exename,projectname,cexteditor,CGUIHBMINGW,cprojext,lresp,opmfolder
MemVar axhb,npostext,debugactive,cprojfolder,exeoutputname,includefolder,flagstoccomp,flagstolinker,outputfile
MemVar ccompiler,guichoice,mingw32folder,cguihbbcc,cguihbpelles,cguixhbmingw,ahb,axhba1,axhba,nwathgui
MemVar cobj_dir,cminiguifolder,cbccfolder,charbourfolder,nfile,clib_oohg,clib_hbprinter,ahba,chbmingwfolder
MemVar cmingwfolder,cpellfolder,cguixhbbcc,cguixhbpelles,cfile,cdebug,cfilerc,chmglibs1,cmgelibs1,cmgelibs2
MemVar chblibs1,cmg2libs2,doscomm1,ahba1,chbbccfolder,chbpellfolder,cxhbmingwfolder
MemVar cxhbbccfolder,cxhbpellfolder,userflags,clibfolder,cuserflags,clib_miniprint,hrb_lib_dir,clib_five
MemVar clib_five2
