/*
 * $Id: dbuvar.ch,v 1.3 2015-03-09 02:52:05 fyurisich Exp $
 */

#define PROGRAM        'DBF Viewer 2020 '
#define COPYRIGHT      ' (c)2009-2015 MigSoft  '
#define CRLF           HB_OsNewLine()
#define _DBUreddish    {255,200,200}
#define _DBUgreenish   {200,255,200}
#define _DBUblueish    {200,200,255}
#define _DBUyellowish  {255,255,200}
#define _DBUblack      {  0,  0,  0}

#ifndef __XHARBOUR__
   #xcommand TRY                => bError := errorBlock( {|oError| break( oError ) } ) ;;
                                   BEGIN SEQUENCE
   #xcommand CATCH [<!oError!>] => errorBlock( bError ) ;;
                                   RECOVER [USING <oError>] <-oError-> ;;
                                   errorBlock( bError )
#endif

memvar _DBUdbfopened, _DBUfname, _DBUindexed, _DBUfiltered, _DBUcondition, _DBUmaxrow, _DBUcontrolarr
memvar _DBUeditmode, _DBUindexfieldname, _DBUbuttonsdefined, _DBUscrwidth, _DBUscrheight, _DBUwindowwidth
memvar _DBUwindowheight,VERSION,ACLRMEN,AFTYPE,ACTRL,CCTRL,AJST,CCOMA,CCTRLBRW,oWndBase,ccampo,thisfld

memvar _DBUtotdeleted, _DBUlastpath, _DBUlastfname, _DBUcurrentprinter, _DBUpath, _DBUparentfname, cqfile
memvar _DBUchildfname, _DBUparentstructarr, _DBUchildstructarr, _DBUindexfields, _DBUindexfiles, _DBUactiveindex

memvar _DBUi,_DBUj,tab,tab2,tab3,xmlver,cvalue,nfield,cbuffer,cfile,nhandle,nfields,flddecs,fldsize,fldname,fldtype

memvar _DBUfieldname, _DBUforcondition, _DBUcondition1, _DBUvalue, _DBUinputwindowresult, _DBUinputwindowinitial
memvar _DBUfieldnames, _DBUfieldsarr, _DBUstructarr, _DBUdbffunctions, _DBUindexlist, _DBUcurrentitem, _DBUindexfile
memvar _DBUopenfilenames, _DBUsize, _DBUsize1, _DBUbuttonfirstrow, _DBUbuttonrow, _DBUbuttoncol, _DBUbuttoncount
memvar _DBUcurrec,META_START_TAG,COL_START_TAG,NAME_END_TAG,TYPE_START_TAG,WIDTH_START_TAG,DECS_END_TAG,nlong

memvar _DBUdbfsaved, _DBUtype1, _DBUcurline, _DBUpos, _DBUfname1,META_END_TAG,DATA_START_TAG,COL_END_TAG,NAME_START_TAG
memvar TYPE_END_TAG,WIDTH_END_TAG,DECS_START_TAG,ROW_START_TAG,ROW_END_TAG,DATA_END_TAG,OLD_PERCENT

memvar _DBUfieldnamesize, _DBUfieldsize, _DBUspecifysize, _DBUmaxcol, _DBUrow, _DBUcol, _DBUpages, _DBUhspace
memvar _DBUvspace, _DBUcontrolname, _DBUheader1, _DBUoriginalarr, _DBUmodarr, _DBUline, _DBUbackname, _DBUnewname

memvar _DBUmaxrow1, _DBUmaxcol1, _DBUfieldnamearr, _DBUfieldsizearr, _DBUlongest, _DBUavailableprinters, _DBUmaxportraitcol
memvar _DBUmaxlandscapecol, _DBUfontsizesstr, _DBUfieldfound, _DBUheadingarr, _DBUjustifyarr, _DBUlinesrefarr, _DBUselectedstructarr
memvar _DBUpageno, _DBUfirstrow, _DBUlastrow, _DBUcurrentrecordarr, _curDBUindexfile,lnew,nB,nRecCopy

Memvar ncol,nrow,nwidth,nheight,cbase,anomb,along,nAltoPantalla,nAnchoPantalla,ajust,aest,cfont,nsize
Memvar aname,calias,cfield,lfind,cfindstr,creplstr,ncurrec,ndirect,asearch,nreg1,nopt,actrol,nuevo,lmodyes
Memvar nalto,nalto1,n,nfil,alabel,adbstru,nlongtot,nlongdec,cinpmsk,nwidthf,busca,cnomb,nregbus,anewfile
Memvar afntclr,abackclr,areplace,ncolumns,nreplace,nsearch,lmatchwhole,lmatchcase,cdateformat,cbasefolder,ahdr
Memvar aheadicon,atypes,acabimg,atemp,nultimo,afont,afiles,ahdr1,asize,atot,cdbfile,lfirstfind,cfind,cpath
