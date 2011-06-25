/*
 * $Id: winprint.prg,v 1.37 2011-06-25 01:27:08 declan2005 Exp $
 */
// -----------------------------------------------------------------------------
// HBPRINTER - Harbour Win32 Printing library source code
//
// Copyright 2002 Richard Rylko <rrylko@poczta.onet.pl>
// http://rrylko.republika.pl
// -----------------------------------------------------------------------------

// 4.12.2004 Fixed network printer bug. Patch borrowed from
// Eduardo Fernandes <modalsist@yahoo.com.br> MiniGuiOOP Print.prg
// by Mitja Podgornik <yamamoto@rocketmail.com>

#include "HBClass.ch"
#include "minigui.ch"
#include "winprint.ch"


/* Background Modes */

#define TRANSPARENT         1
#define OPAQUE              2
#define BKMODE_LAST         2

CLASS HBPrinter

   DATA    hDC INIT 0
   DATA    hDCRef INIT 0
   DATA    PrinterName INIT ""

   DATA    nFromPage INIT 1
   DATA    nToPage   INIT 0
   DATA    CurPage   INIT 1
   DATA    nCopies   INIT 1
   DATA    nWhatToPrint INIT 0
   DATA    PrintOpt  INIT 1

   DATA    PrinterDefault INIT ""
   DATA    Error INIT 0
   DATA    PaperNames INIT {}
   DATA    BINNAMES INIT {}
   DATA    DOCNAME INIT "HBPRINTER"
   DATA    TextColor INIT 0
   DATA    BkColor INIT 0xFFFFFF
   DATA    BkMode INIT 1         &&TRANSPARENT
   DATA    PolyFillMode INIT 1
   DATA    Cargo INIT {0,0,0,0,0,0,0,0,0,0}
   DATA    FONTS INIT {{},{},0,{}}
   DATA    BRUSHES INIT {{},{}}
   DATA    PENS INIT {{},{}}
   DATA    REGIONS INIT {{},{}}
   DATA    IMAGELISTS INIT {{},{}}
   DATA    UNITS INIT 0
   DATA    DEVCAPS INIT {0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0}
   DATA    MAXROW INIT 0
   DATA    MAXCOL INIT 0
   DATA    METAFILES INIT {}
   DATA    PREVIEWMODE INIT .F.
   DATA    THUMBNAILS INIT .F.
   DATA    VIEWPORTORG INIT {0,0}
   DATA    PREVIEWRECT INIT {0,0,0,0}
   DATA    PRINTINGEMF INIT .F.
   DATA    PRINTING INIT .F.
   DATA    PREVIEWSCALE INIT 1
   DATA    Printers INIT {}
   DATA    Ports INIT {}
   DATA    iloscstron INIT 0
   DATA    ngroup INIT -1
   DATA    page INIT 1
   DATA    ath INIT {}
   DATA    dx INIT 0
   DATA    dy INIT 0
   DATA    ahs INIT {}
   DATA    azoom INIT {0,0,0,0}
   DATA    scale INIT 1
   DATA    npages INIT {}
   DATA    aopisy INIT {}
   DATA    oHBPreview1 INIT nil
   DATA    NoButtonSave INIT .F.
   DATA    NoButtonOptions INIT .F.   
   DATA    BeforePrint INIT {|| .T.}
   DATA    AfterPrint INIT {|| NIL}
   DATA    BeforePrintCopy  INIT {|| .T.}
   DATA    InMemory INIT .F.
   DATA    TimeStamp INIT ''
   DATA    BaseDoc INIT ""

   METHOD New()
   METHOD SelectPrinter( cPrinter ,lPrev)
   METHOD SetDevMode(what,newvalue)
   METHOD Startdoc(ldocname)
   METHOD SetPage(orient,size,fontname)
   METHOD Startpage()
   METHOD Endpage()
   METHOD Enddoc()
   METHOD SetTextColor(clr)
   METHOD GetTextColor()     INLINE ::TextColor
   METHOD SetBkColor(clr)
   METHOD GetBkColor()       INLINE ::BkColor
   METHOD SetBkMode(nmode)
   METHOD GetBkMode()        INLINE ::BkMode
   METHOD DefineImageList(defname,cpicture,nicons)
   METHOD DrawImageList(defname,nicon,row,col,torow,tocol,lstyle,color)
   METHOD DefineBrush(defname,lstyle,lcolor,lhatch)
   METHOD ModifyBrush(defname,lstyle,lcolor,lhatch)
   METHOD SelectBrush(defname)
   METHOD DefinePen(defname,lstyle,lwidth,lcolor)
   METHOD ModifyPen(defname,lstyle,lwidth,lcolor)
   METHOD SelectPen(defname)
   METHOD DefineFont(defname,lfontname,lfontsize,lfontwidth,langle,lweight,litalic,lunderline,lstrikeout)
   METHOD ModifyFont(defname,lfontname,lfontsize,lfontwidth,langle,lweight,lnweight,litalic,lnitalic,lunderline,lnunderline,lstrikeout,lnstrikeout)
   METHOD SelectFont(defname)
   METHOD GetObjByName(defname,what,retpos)
   METHOD DrawText(row,col,torow,tocol,txt,style,defname)
   METHOD TextOut(row,col,txt,defname)
   METHOD Say(row,col,txt,defname,lcolor,lalign)
   METHOD SetCharset(charset) INLINE rr_setcharset(charset,,SELF) // Dummy SELF
   METHOD Rectangle(row,col,torow,tocol,defpen,defbrush)
   METHOD RoundRect(row,col,torow,tocol,widthellipse,heightellipse,defpen,defbrush)
   METHOD FillRect(row,col,torow,tocol,defbrush)
   METHOD FrameRect(row,col,torow,tocol,defbrush)
   METHOD InvertRect(row,col,torow,tocol)
   METHOD Ellipse(row,col,torow,tocol,defpen,defbrush)
   METHOD Arc(row,col,torow,tocol,rowsarc,colsarc,rowearc,colearc,defpen)
   METHOD ArcTo(row,col,torow,tocol,rowrad1,colrad1,rowrad2,colrad2,defpen)
   METHOD Chord(row,col,torow,tocol,rowrad1,colrad1,rowrad2,colrad2,defpen,defbrush)
   METHOD Pie(row,col,torow,tocol,rowrad1,colrad1,rowrad2,colrad2,defpen,defbrush)
   METHOD Polygon(apoints,defpen,defbrush,style)
   METHOD PolyBezier(apoints,defpen)
   METHOD PolyBezierTo(apoints,defpen)
   METHOD SetUnits(newvalue,r,c)
   METHOD Convert(arr,lsize)
   METHOD DefineRectRgn(defname,row,col,torow,tocol)
   METHOD DefinePolygonRgn(defname,apoints,style)
   METHOD DefineEllipticRgn(defname,row,col,torow,tocol)
   METHOD DefineRoundRectRgn(defname,row,col,torow,tocol,widthellipse,heightellipse)
   METHOD CombineRgn(defname,reg1,reg2,style)
   METHOD SelectClipRgn(defname)
   METHOD DeleteClipRgn()
   METHOD SetPolyFillMode(style)
   METHOD GetPolyFillMode()   INLINE ::PolyFillMode
   METHOD SetViewPortOrg(row,col)
   METHOD GetViewPortOrg()
   METHOD DxColors(par)
   METHOD SetRGB(red,green,blue)
   METHOD SetTextCharExtra(col)
   METHOD GetTextCharExtra()
   METHOD SetTextJustification(col)
   METHOD GetTextJustification()
   METHOD SetTextAlign(style)
   METHOD GetTextAlign()
   METHOD Picture(row,col,torow,tocol,cpicture,extrow,extcol)
   METHOD Line(row,col,torow,tocol,defpen)
   METHOD LineTo(row,col,defpen)
   METHOD SaveMetaFiles(nr)
   METHOD GetTextExtent(ctext,apoint,deffont)
   METHOD End()
   METHOD ReportData(l_x1,l_x2,l_x3,l_x4,l_x5,l_x6)
   METHOD Preview(x,y,width,height)
   METHOD PrevPrint()
   METHOD PrevShow()
   METHOD PrevThumb()
// new method
   METHOD PrintOption()

   IF TIME() == "Z"
      EMPTY( _OOHG_AllVars )
      EMPTY( HBPRN )
   ENDIF
ENDCLASS



METHOD New() CLASS HBPrinter
local aprnport
   aprnport:=rr_getprinters()
   IF aprnport<>",,"
      aprnport:=str2arr(aprnport,",,")
      aeval(aprnport,{|x,xi| aprnport[xi]:=str2arr(x,',')})
      aeval(aprnport,{|x| aadd(::Printers,x[1]),  aadd(::ports,x[2]) })
      ::PrinterDefault:=RR_GETDEFAULTPRINTER()
   ELSE
      ::error:=1
   ENDIF
   ::TimeStamp := strzero( Seconds() * 100 , 8 )
   ::BaseDoc := GetTempFolder() + "\" + ::TimeStamp + "_HMG_print_preview_"
return self

METHOD SelectPrinter( cPrinter ,lPrev) CLASS HBPrinter
local txtp:="",txtb:="",t:={0,0,1,.t.}
   IF cPrinter == Nil
      ::hDCRef := rr_getdc(::PrinterDefault)
      ::hDC:=::hDCRef
      ::PrinterName:=::PrinterDefault
   ELSEIF Empty( cPrinter )
      ::hDCRef := rr_printdialog(t)
      ::nfrompage:=t[1]
      ::ntopage:=t[2]
      ::ncopies:=t[3]
      ::nwhattoprint:=t[4]
      ::hDC:=::hDCRef
      ::PrinterName := rr_PrinterName()
   ELSE
      ::hDCRef := rr_getdc(cPrinter)
      ::hDC:=::hDCRef
      ::PrinterName:=cPrinter

   ENDIF
   IF HB_IsLogical(lPrev)
     if lprev
      ::PreviewMode:=.t.
     endif
   ENDIF
   IF ::hDC==0
      ::error:=1
      ::PrinterName:=""
   ELSE
      rr_devicecapabilities(@txtp,@txtb)
      ::PaperNames:=str2arr(txtp,",,")
      ::BinNames:=str2arr(txtb,",,")
      aeval(::BinNames,{|x,xi| ::BinNames[xi]:=str2arr(x,',')})
      aeval(::PaperNames,{|x,xi| ::PaperNames[xi]:=str2arr(x,',')})
      aadd(::Fonts[1],rr_getcurrentobject(1)) ; aadd(::Fonts[2],"*") ; aadd(::Fonts[4],{})
      aadd(::Fonts[1],rr_getcurrentobject(1)) ; aadd(::Fonts[2],"DEFAULT") ; aadd(::Fonts[4],{})
      aadd(::Brushes[1],rr_getcurrentobject(2)) ; aadd(::Brushes[2],"*")
      aadd(::Brushes[1],rr_getcurrentobject(2)) ; aadd(::Brushes[2],"DEFAULT")
      aadd(::Pens[1],rr_getcurrentobject(3)) ; aadd(::Pens[2],"*")
      aadd(::Pens[1],rr_getcurrentobject(3)) ; aadd(::Pens[2],"DEFAULT")
      aadd(::Regions[1],0) ; aadd(::Regions[2],"*")
      aadd(::Regions[1],0) ; aadd(::Regions[2],"DEFAULT")
      ::Fonts[3]:=::Fonts[1,1]
      rr_getdevicecaps(::DEVCAPS,::Fonts[3])
      ::setunits(::units)
   ENDIF
Return Nil


METHOD SetDevMode(what,newvalue) CLASS HBPrinter
  ::hDCRef:=rr_setdevmode(what,newvalue)
  rr_getdevicecaps(::DEVCAPS,::Fonts[3])
  ::setunits(::units)
Return Self

METHOD StartDoc(ldocname) CLASS HBPrinter
  ::Printing:=.t.
  if ldocname<>NIL
     ::DOCNAME:=ldocname
  endif
  if !::PreviewMode
      rr_startdoc(::DOCNAME)
  endif
return self

METHOD SetPage(orient,size,fontname) CLASS HBPrinter
local lhand:=::getobjbyname(fontname,"F")
  if size<>NIL
     ::SetDevMode(DM_PAPERSIZE,size)
  endif
  if orient<>NIL
     ::SetDevMode(DM_ORIENTATION,orient)
  endif
  if lhand<>0
     ::Fonts[3]:=lhand
  endif
  rr_getdevicecaps(::DEVCAPS,::Fonts[3])
  ::setunits(::units)
return Self


METHOD Startpage() CLASS HBPrinter
  if ::PreviewMode
	if ::InMemory
		::hDC:=rr_createmfile()
	else
		::hDC:=rr_createfile( ::BaseDoc + alltrim(strzero(::CurPage,4))+'.emf')
		::CurPage := ::CurPage + 1
	end
  else
    rr_Startpage()
  endif
  if !::Printingemf
    rr_selectcliprgn(::Regions[1,1])
    rr_setviewportorg(::ViewPortOrg)
    rr_settextcolor(::textcolor)
    rr_setbkcolor(::bkcolor)
    rr_setbkmode(::bkmode)
    rr_selectbrush(::Brushes[1,1])
    rr_selectpen(::Pens[1,1])
    rr_selectfont(::Fonts[1,1])
  endif
return self

METHOD Endpage() CLASS HBPrinter
  if ::PreviewMode
	if ::InMemory
		aadd(::MetaFiles,{rr_closemfile(),::DEVCAPS[1],::DEVCAPS[2],::DEVCAPS[3],::DEVCAPS[4],::DEVCAPS[15],::DEVCAPS[17]})
	else
		rr_closefile()
		aadd(::MetaFiles,{::BaseDoc + strzero(::CurPage-1,4)+'.emf',::DEVCAPS[1],::DEVCAPS[2],::DEVCAPS[3],::DEVCAPS[4],::DEVCAPS[15],::DEVCAPS[17]})
	end
  else
     rr_endpage()
  endif
return self

METHOD SaveMetaFiles(number) CLASS HBPrinter
Local n,l
default number to NIL
 if ::PreviewMode
	if ::InMemory
        	if number==NIL
		   aeval(::METAFILES,{|x,xi| str2file(x[1],"page"+alltrim(str(xi))+".emf") })
		else
		   str2file(::METAFILES[number,1],"page"+alltrim(str(number))+".emf")
		endif
	else
		if number<>NIL
		   COPY FILE (::BaseDoc + alltrim(strzero(number,4))+'.emf') to ("page"+alltrim(strzero(number,4))+".emf")
		else
                         l:=::curpage-1
			for n := 1 to l
				COPY FILE (::BaseDoc + alltrim(strzero(n,4))+'.emf') to ("page"+alltrim(strzero(n,4))+".emf")
			end
		endif
	endif
 endif
return self

***********************************
METHOD EndDoc() CLASS HBPrinter
***********************************

 if ::PreviewMode
    ::preview()
 else
   rr_enddoc()
 endif
 ::Printing:=.f.
return self

******************************************
METHOD SetTextColor(clr) CLASS HBPrinter
******************************************
local lret:=::Textcolor
  if clr<>NIL

        // BEGIN RL 2003-08-03

        IF HB_IsNumeric (clr)
            ::TextColor:=rr_settextcolor(clr)
        ELSEIF HB_IsArray (clr)
            ::TextColor:=rr_settextcolor( RR_SETRGB ( clr [1] , clr [2] , clr [3] ) )
        ENDIF

        // END RL

  endif
return lret

METHOD SetPolyFillMode(style) CLASS HBPrinter
local lret:=::PolyFillMode
  ::PolyFillMode:=rr_setpolyfillmode(style)
return lret

METHOD SetBkColor(clr) CLASS HBPrinter
local lret:=::BkColor

        // BEGIN RL 2003-08-03

        IF HB_IsNumeric (clr)
          ::BkColor:=rr_setbkcolor(clr)
        ELSEIF HB_IsArray (clr)
          ::BkColor:=rr_setbkcolor( RR_SETRGB ( clr [1] , clr [2] , clr [3] ) )
        ENDIF

        // END RL

return lret

METHOD SetBkMode(nmode) CLASS HBPrinter
local lret:=::Bkmode
  ::BkMode:=nmode
  rr_setbkmode(nmode)
return lret

METHOD DefineBrush(defname,lstyle,lcolor,lhatch) CLASS HBPrinter
local lhand:=::getobjbyname(defname,"B")
 if lhand<>0
    return self
 endif

        // BEGIN RL 2003-08-03

        IF HB_IsArray (lcolor)
            lcolor := RR_SETRGB ( lcolor [1] , lcolor [2] , lcolor [3] )
        ENDIF

        // END RL

 lstyle:=if(lstyle==NIL,BS_NULL,lstyle)
 lcolor:=if(lcolor==NIL,0xFFFFFF,lcolor)
 lhatch:=if(lhatch==NIL,HS_HORIZONTAL,lhatch)
 aadd(::Brushes[1],rr_createbrush(lstyle,lcolor,lhatch))
 aadd(::Brushes[2],upper(alltrim(defname)))
return self

METHOD SelectBrush(defname) CLASS HBPrinter
local lhand:=::getobjbyname(defname,"B")
  if lhand<>0
        rr_selectbrush(lhand)
        ::Brushes[1,1]:=lhand
  endif
return self

METHOD ModifyBrush(defname,lstyle,lcolor,lhatch) CLASS HBPrinter
local lhand:=0,lpos:=0
 if defname=="*"
    lpos:=ascan(::Brushes[1],::Brushes[1,1],2)
    if lpos>1
       lhand:=::Brushes[1,lpos]
    endif
 else
    lhand:=::getobjbyname(defname,"B")
    lpos:=::getobjbyname(defname,"B",.t.)
 endif
 if lhand==0 .or. lpos==0
    ::error:=1
    return self
 endif
 lstyle:=if(lstyle==NIL,-1,lstyle)

        // BEGIN RL 2003-08-03

        IF HB_IsArray (lcolor)
            lcolor := RR_SETRGB ( lcolor [1] , lcolor [2] , lcolor [3] )
        ENDIF

        // END RL

 lcolor:=if(lcolor==NIL,-1,lcolor)
 lhatch:=if(lhatch==NIL,-1,lhatch)
 ::Brushes[1,lpos]:=rr_modifybrush(lhand,lstyle,lcolor,lhatch)
 if lhand==::Brushes[1,1]
    ::selectbrush(::Brushes[2,lpos])
 endif
return self

***************************************************************
METHOD DefinePen(defname,lstyle,lwidth,lcolor) CLASS HBPrinter
***************************************************************
local lhand:=::getobjbyname(defname,"P")
 if lhand<>0
    return self
 endif

        // BEGIN RL 2003-08-03

        IF HB_IsArray (lcolor)
            lcolor := RR_SETRGB ( lcolor [1] , lcolor [2] , lcolor [3] )
        ENDIF

        // END RL

 lstyle:=if(lstyle==NIL,PS_SOLID,lstyle)
 lcolor:=if(lcolor==NIL,0xFFFFFF,lcolor)
 lwidth:=if(lwidth==NIL,0,lwidth)
 aadd(::Pens[1],rr_createpen(lstyle,lwidth,lcolor))
 aadd(::Pens[2],upper(alltrim(defname)))
return self

***************************************************************
METHOD ModifyPen(defname,lstyle,lwidth,lcolor) CLASS HBPrinter
***************************************************************
local lhand:=0,lpos:=0
 if defname=="*"
    lpos:=ascan(::Pens[1],::Pens[1,1],2)
    if lpos>1
       lhand:=::Pens[1,lpos]
    endif
 else
    lhand:=::getobjbyname(defname,"P")
    lpos:=::getobjbyname(defname,"P",.t.)
 endif
 if lhand==0 .or. lpos<=1
    ::error:=1
    return self
 endif

 lstyle:=if(lstyle==NIL,-1,lstyle)

        // BEGIN RL 2003-08-03

        IF HB_IsArray (lcolor)
            lcolor := RR_SETRGB ( lcolor [1] , lcolor [2] , lcolor [3] )
        ENDIF

        // END RL

 lcolor:=if(lcolor==NIL,-1,lcolor)
 lwidth:=if(lwidth==NIL,-1,lwidth)
 ::Pens[1,lpos]:=rr_modifypen(lhand,lstyle,lwidth,lcolor)
 if lhand==::Pens[1,1]
    ::selectpen(::Pens[2,lpos])
 endif
return self

*********************************************
METHOD SelectPen(defname) CLASS HBPrinter
*********************************************
local lhand:=::getobjbyname(defname,"P")
  if lhand<>0
        rr_selectpen(lhand)
        ::Pens[1,1]:=lhand
  endif
return self

*********************************************************
METHOD DefineFont(defname,lfontname,lfontsize,lfontwidth,langle,lweight,litalic,lunderline,lstrikeout) CLASS HBPrinter
*********************************************************
local lhand:=::getobjbyname(lfontname,"F")
 if lhand<>0
    return self
 endif
 lfontname:=if(lfontname==NIL,"",upper(alltrim(lfontname)))
 if lfontsize==NIL
    lfontsize:=-1
 endif

 if lfontwidth==NIL
      lfontwidth:=0
 endif
 if langle==NIL
    langle:=-1
 endif
 lweight:=if(empty(lweight),0,1)
 litalic:=if(empty(litalic),0,1)
 lunderline:=if(empty(lunderline),0,1)
 lstrikeout:=if(empty(lstrikeout),0,1)
 aadd(::Fonts[1],rr_createfont(lfontname,lfontsize,-lfontwidth,langle*10,lweight,litalic,lunderline,lstrikeout))
 aadd(::Fonts[2],upper(alltrim(defname)))
 aadd(::Fonts[4],{lfontname,lfontsize,lfontwidth,langle,lweight,litalic,lunderline,lstrikeout})
return self

*********************************************************
METHOD ModifyFont(defname,lfontname,lfontsize,lfontwidth,langle,lweight,lnweight,litalic,lnitalic,lunderline,lnunderline,lstrikeout,lnstrikeout) CLASS HBPrinter
*********************************************************
local lhand:=0,lpos:=0
 if defname=="*"
    lpos:=ascan(::Fonts[1],::Fonts[1,1],2)
    if lpos>1
       lhand:=::Fonts[1,lpos]
    endif
 else
    lhand:=::getobjbyname(defname,"F")
    lpos:=::getobjbyname(defname,"F",.t.)
 endif
 if lhand==0 .or. lpos<=1
    ::error:=1
    return self
 endif

 if lfontname<>NIL
   ::Fonts[4,lpos,1]:=upper(alltrim(lfontname))
 endif

 if lfontsize<>NIL
    ::Fonts[4,lpos,2]:=lfontsize
 endif
 if lfontwidth<>NIL
   ::Fonts[4,lpos,3]:=lfontwidth
   endif
if langle<>NIL
    ::Fonts[4,lpos,4]:=langle
endif
 if lweight
   ::Fonts[4,lpos,5]:=1
 endif
 if lnweight
    ::Fonts[4,lpos,5]:=0
 endif
 if litalic
    ::Fonts[4,lpos,6]:=1
 endif
 if lnitalic
    ::Fonts[4,lpos,6]:=0
 endif
 if lunderline
   ::Fonts[4,lpos,7]:=1
 endif
 if lnunderline
   ::Fonts[4,lpos,7]:=0
 endif
 if lstrikeout
    ::Fonts[4,lpos,8]:=1
 endif
 if lnstrikeout
   ::Fonts[4,lpos,8]:=0
 endif


 ::Fonts[1,lpos]:=rr_createfont(::Fonts[4,lpos,1],::Fonts[4,lpos,2],-::Fonts[4,lpos,3],::Fonts[4,lpos,4]*10,::Fonts[4,lpos,5],::Fonts[4,lpos,6],::Fonts[4,lpos,7],::Fonts[4,lpos,8])

 if lhand==::Fonts[1,1]
    ::selectfont(::Fonts[2,lpos])
 endif
 rr_deleteobjects({0,lhand})
return self


METHOD SelectFont(defname) CLASS HBPrinter
local lhand:=::getobjbyname(defname,"F")
  if lhand<>0
        rr_selectfont(lhand)
        ::Fonts[1,1]:=lhand
  endif
return self

METHOD SetUnits(newvalue,r,c) CLASS HBPrinter
local oldvalue:=::UNITS
   newvalue:=if(HB_IsNumeric(newvalue),newvalue,0)
   ::UNITS:=if(newvalue<0 .or. newvalue>4,0,newvalue)
   do case
      case ::Units==0
           ::MaxRow:=::DevCaps[13]-1
           ::MaxCol:=::DevCaps[14]-1
      case ::Units==1
           ::MaxRow:=::DevCaps[1]-1
           ::MaxCol:=::DevCaps[2]-1
      case ::Units==2
           ::MaxRow:=(::DevCaps[1]/25.4)-1
           ::MaxCol:=(::DevCaps[2]/25.4)-1
      case ::Units==3
           ::MaxRow:=::DevCaps[3]
           ::MaxCol:=::DevCaps[4]
      case ::Units==4
           if HB_IsNumeric(r)
              ::MaxRow:=r-1
           endif
           if HB_IsNumeric(c)
              ::MaxCol:=c-1
           endif
   endcase
return oldvalue

METHOD Convert(arr,lsize) CLASS HBPrinter
local aret:=aclone(arr)
do case
   case ::UNITS==0
        aret[1]:=(arr[1])*::DEVCAPS[11]
        aret[2]:=(arr[2])*::DEVCAPS[12]
   case ::UNITS==3
   case ::UNITS==4
        aret[1]:=(arr[1])*::DEVCAPS[3]/(::maxrow+1)
        aret[2]:=(arr[2])*::DEVCAPS[4]/(::maxcol+1)
   case ::UNITS==1
        aret[1]:=(arr[1])*::DEVCAPS[5]/25.4-if(lsize==NIL,::DEVCAPS[9 ],0)
        aret[2]:=(arr[2])*::DEVCAPS[6]/25.4-if(lsize==NIL,::DEVCAPS[10],0)
   case ::UNITS==2
        aret[1]:=(arr[1])*::DEVCAPS[5]-if(lsize==NIL,::DEVCAPS[9 ],0)
        aret[2]:=(arr[2])*::DEVCAPS[6]-if(lsize==NIL,::DEVCAPS[10],0)
   otherwise
        aret[1]:=(arr[1])*::DEVCAPS[11]
        aret[2]:=(arr[2])*::DEVCAPS[12]
endcase
return aret

METHOD DrawText(row,col,torow,tocol,txt,style,defname) CLASS HBPrinter
local lhf:=::getobjbyname(defname,"F")
     if torow==NIL
        torow:=::maxrow
      endif
     if tocol==NIL
        tocol:=::maxcol
     endif
     rr_drawtext(::Convert({row,col}),::Convert({torow,tocol}),txt,style,lhf)
return self

METHOD TEXTOUT(row,col,txt,defname) CLASS HBPrinter
local lhf:=::getobjbyname(defname,"F")
  rr_textout(txt,::Convert({row,col}),lhf,rat(" ",txt))
return self

METHOD Say(row,col,txt,defname,lcolor,lalign)    CLASS HBPrinter
local atxt:={},i,lhf:=::getobjbyname(defname,"F"),font:=0,oldalign
local apos
  do case
     case HB_IsNumeric(txt)    ;  aadd(atxt,str(txt))
     case HB_IsDate(txt)    ;  aadd(atxt,dtoc(txt))
     case HB_IsLogical(txt)    ;  aadd(atxt,if(txt,".T.",".F."))
     case valtype(txt)=="U"    ;  aadd(atxt,"NIL")
     case valtype(txt)$"BO"    ;  aadd(atxt,"")
     case HB_IsArray(txt)    ;  aeval(txt,{|x| aadd(atxt,sayconvert(x)) })
     case valtype(txt)$"MC"    ;  atxt:=str2arr(txt,hb_osnewline())
  endcase
  apos:=::convert({row,col})
  if lcolor<>NIL

        // BEGIN RL 2003-08-03

        IF HB_IsNumeric (lcolor)
            rr_settextcolor(lcolor)
        ELSEIF HB_IsArray (lcolor)
            rr_settextcolor( RR_SETRGB ( lcolor [1] , lcolor [2] , lcolor [3] ) )
        ENDIF

        // END RL

  endif
  if lalign<>NIL
     oldalign:=rr_gettextalign()
     rr_settextalign(lalign)
  endif
  for i:=1 to len(atxt)
     rr_textout(atxt[i],apos,lhf,rat(" ",atxt[i]))
     apos[1]+=::DEVCAPS[11]
  next
  if lalign<>NIL
     rr_settextalign(oldalign)
  endif

  if lcolor<>NIL
     rr_settextcolor(::textcolor)
  endif

return self

METHOD DefineImageList(defname,cpicture,nicons) CLASS HBPrinter
local lhi:=::getobjbyname(defname,"I"),w:=0,h:=0,hand
 if lhi<>0
    return self
 endif
 hand:=rr_createimagelist(cpicture,nicons,@w,@h)
 if hand<>0 .and. w>0 .and. h>0
   aadd(::imagelists[1],{hand,nicons,w,h})
   aadd(::imagelists[2],upper(alltrim(defname)))
 endif
return self

METHOD DRAWIMAGELIST(defname,nicon,row,col,torow,tocol,lstyle,color) CLASS HBPrinter
local lhi:=::getobjbyname(defname,"I")
   if empty(lhi)
      return self
   endif
   if color==NIL
     color:=-1
   endif
   if torow==NIL
      torow:=::maxrow
   endif
   if tocol==NIL
    tocol:=::maxcol
   endif
   ::error:=rr_drawimagelist(lhi[1],nicon,::convert({row,col}),::convert({torow-row,tocol-col}),lhi[3],lhi[4],lstyle,color)
return self



METHOD Rectangle(row,col,torow,tocol,defpen,defbrush) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P"),lhb:=::getobjbyname(defbrush,"B")
   if torow==NIL
      torow:=::maxrow
   endif
   if tocol==NIL
      tocol:=::maxcol
   endif
   ::error=rr_rectangle(::convert({row,col}),::convert({torow,tocol}),lhp,lhb)
return self

METHOD FrameRect(row,col,torow,tocol,defbrush) CLASS HBPrinter
local lhb:=::getobjbyname(defbrush,"B")
   if torow==NIL
      torow:=::maxrow
   endif
   if tocol==NIL
     tocol:=::maxcol
   endif
   ::error=rr_framerect(::convert({row,col}),::convert({torow,tocol}),lhb)
return self

METHOD RoundRect(row,col,torow,tocol,widthellipse,heightellipse,defpen,defbrush) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P"),lhb:=::getobjbyname(defbrush,"B")
   if torow==NIL
     torow := ::maxrow
   endif
   if tocol==NIL
      tocol := ::maxcol
   endif
   if widthellipse == NIL
     widthellipse := 0
   endif
   if heightellipse == NIL
     heightellipse := 0
   endif
   ::error=rr_roundrect(::convert({row,col}),::convert({torow,tocol}),::convert({widthellipse,heightellipse}),lhp,lhb)
return self

METHOD FillRect(row,col,torow,tocol,defbrush) CLASS HBPrinter
local lhb:=::getobjbyname(defbrush,"B")
   if torow==NIL
      torow:=::maxrow
    endif
   if tocol==NIL
      tocol:=::maxcol
   endif
   ::error=rr_fillrect(::convert({row,col}),::convert({torow,tocol}),lhb)
return self

METHOD InvertRect(row,col,torow,tocol) CLASS HBPrinter
   if torow==NIL
     torow:=::maxrow
   endif
   if tocol==NIL
      tocol:=::maxcol
   endif
   ::error=rr_invertrect(::convert({row,col}),::convert({torow,tocol}))
return self

METHOD Ellipse(row,col,torow,tocol,defpen,defbrush) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P"),lhb:=::getobjbyname(defbrush,"B")
   if torow==NIL
     torow:=::maxrow
   endif
   if tocol==NIL
     tocol:=::maxcol
   endif
   ::error=rr_ellipse(::convert({row,col}),::convert({torow,tocol}),lhp,lhb)
return self

METHOD Arc(row,col,torow,tocol,rowsarc,colsarc,rowearc,colearc,defpen) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P")
   if torow==NIL
      torow:=::maxrow
   endif
   if tocol==NIL
     tocol:=::maxcol
   endif
   ::error=rr_arc(::convert({row,col}),::convert({torow,tocol}),::convert({rowsarc,colsarc}),::convert({rowearc,colearc}),lhp)
return self

METHOD ArcTo(row,col,torow,tocol,rowrad1,colrad1,rowrad2,colrad2,defpen) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P")
   if torow==NIL
      torow:=::maxrow
   endif
   if tocol==NIL
      tocol:=::maxcol
   endif
   ::error=rr_arcto(::convert({row,col}),::convert({torow,tocol}),::convert({rowrad1,colrad1}),::convert({rowrad2,colrad2}),lhp)
return self


METHOD Chord(row,col,torow,tocol,rowrad1,colrad1,rowrad2,colrad2,defpen,defbrush) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P"),lhb:=::getobjbyname(defbrush,"B")
   if torow==NIL
      torow:=::maxrow
   endif
   if tocol==NIL
      tocol:=::maxcol
   endif
   ::error=rr_chord(::convert({row,col}),::convert({torow,tocol}),::convert({rowrad1,colrad1}),::convert({rowrad2,colrad2}),lhp,lhb)
return self

METHOD Pie(row,col,torow,tocol,rowrad1,colrad1,rowrad2,colrad2,defpen,defbrush) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P"),lhb:=::getobjbyname(defbrush,"B")
   if torow==NIL
      torow:=::maxrow
   endif
   if tocol==NIL
      tocol:=::maxcol
   endif
   ::error=rr_pie(::convert({row,col}),::convert({torow,tocol}),::convert({rowrad1,colrad1}),::convert({rowrad2,colrad2}),lhp,lhb)
return self

METHOD Polygon(apoints,defpen,defbrush,style) CLASS HBPrinter
local apx:={},apy:={},temp
local lhp:=::getobjbyname(defpen,"P"),lhb:=::getobjbyname(defbrush,"B")
 aeval(apoints,{|x| temp:=::convert(x),aadd(apx,temp[2]), aadd(apy,temp[1])})
 ::error:=rr_polygon(apx,apy,lhp,lhb,style)
return self

METHOD PolyBezier(apoints,defpen) CLASS HBPrinter
local apx:={},apy:={},temp
local lhp:=::getobjbyname(defpen,"P")
 aeval(apoints,{|x| temp:=::convert(x),aadd(apx,temp[2]), aadd(apy,temp[1])})
 ::error:=rr_polybezier(apx,apy,lhp)
return self

METHOD PolyBezierTo(apoints,defpen) CLASS HBPrinter
local apx:={},apy:={},temp
local lhp:=::getobjbyname(defpen,"P")
 aeval(apoints,{|x| temp:=::convert(x),aadd(apx,temp[2]), aadd(apy,temp[1])})
 ::error:=rr_polybezierto(apx,apy,lhp)
return self


METHOD Line(row,col,torow,tocol,defpen) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P")
   if torow==NIL
      torow:=::maxrow
   endif
   if tocol==NIL
      tocol:=::maxcol
   endif
   ::error=rr_line(::convert({row,col}),::convert({torow,tocol}),lhp)
return self

METHOD LineTo(row,col,defpen) CLASS HBPrinter
local lhp:=::getobjbyname(defpen,"P")
   ::error=rr_lineto(::convert({row,col}),lhp)
return self

METHOD GetTextExtent(ctext,apoint,deffont) CLASS HBPrinter
local lhf:=::getobjbyname(deffont,"F")
   ::error=rr_gettextextent(ctext,apoint,lhf)
return self


METHOD GetObjByName(defname,what,retpos) CLASS HBPrinter
local lfound:=0,lret:=0,aref,ahref
 if valtype(defname)=="C"
    do case
       case what=="F" ; aref:=::Fonts[2]      ; ahref:=::Fonts[1]
       case what=="B" ; aref:=::Brushes[2]    ; ahref:=::Brushes[1]
       case what=="P" ; aref:=::Pens[2]       ; ahref:=::Pens[1]
       case what=="R" ; aref:=::Regions[2]    ; ahref:=::Regions[1]
       case what=="I" ; aref:=::ImageLists[2] ; ahref:=::ImageLists[1]
    endcase
    lfound:=ascan(aref,upper(alltrim(defname)))
    if lfound>0
       if aref[lfound]==upper(alltrim(defname))
          if retpos<>NIL
            lret:=lfound
          else
            lret:=ahref[lfound]
          endif
       endif
    endif
 endif
return lret

METHOD DefineRectRgn(defname,row,col,torow,tocol) CLASS HBPrinter
local lhand:=::getobjbyname(defname,"R")
 if lhand<>0
    return self
 endif
 if torow==NIL
    torow:=::maxrow
 endif
 if tocol==NIL
    tocol:=::maxcol
 endif
 aadd(::Regions[1],rr_creatergn(::convert({row,col}),::convert({torow,tocol}),1))
 aadd(::Regions[2],upper(alltrim(defname)))
return self

METHOD DefineEllipticRgn(defname,row,col,torow,tocol) CLASS HBPrinter
local lhand:=::getobjbyname(defname,"R")
 if lhand<>0
    return self
 endif
 if torow==NIL
    torow:=::maxrow
 endif
 if tocol==NIL
    tocol:=::maxcol
 endif
 aadd(::Regions[1],rr_creatergn(::convert({row,col}),::convert({torow,tocol}),2))
 aadd(::Regions[2],upper(alltrim(defname)))
return self

METHOD DefineRoundRectRgn(defname,row,col,torow,tocol,widthellipse,heightellipse) CLASS HBPrinter
local lhand:=::getobjbyname(defname,"R")
 if lhand<>0
    return self
 endif
 if torow==NIL
   torow:=::maxrow
 endif
 if tocol==NIL
    tocol:=::maxcol
 endif
 aadd(::Regions[1],rr_creatergn(::convert({row,col}),::convert({torow,tocol}),3,::convert({widthellipse,heightellipse})))
 aadd(::Regions[2],upper(alltrim(defname)))
return self

METHOD DefinePolygonRgn(defname,apoints,style) CLASS HBPrinter
local apx:={},apy:={},temp
local lhand:=::getobjbyname(defname,"R")
 if lhand<>0
    return self
 endif
 aeval(apoints,{|x| temp:=::convert(x),aadd(apx,temp[2]), aadd(apy,temp[1])})
 aadd(::Regions[1],rr_createPolygonrgn(apx,apy,style))
 aadd(::Regions[2],upper(alltrim(defname)))
return self


METHOD CombineRgn(defname,reg1,reg2,style) CLASS HBPrinter
local lr1:=::getobjbyname(reg1,"R"),lr2:=::getobjbyname(reg2,"R")
local lhand:=::getobjbyname(defname,"R")
 if lhand<>0 .or. lr1==0 .or. lr2==0
    return self
 endif
 aadd(::Regions[1],rr_combinergn(lr1,lr2,style))
 aadd(::Regions[2],upper(alltrim(defname)))
return self

METHOD SelectClipRgn(defname) CLASS HBPrinter
local lhand:=::getobjbyname(defname,"R")
  if lhand<>0
        rr_selectcliprgn(lhand)
        ::Regions[1,1]:=lhand
  endif
return self

METHOD DeleteClipRgn() CLASS HBPrinter
  ::Regions[1,1]:=0
  rr_deletecliprgn()
return self

METHOD SetViewPortOrg(row,col) CLASS HBPrinter
  row:=if(row<>NIL,row,0)
  col:=if(col<>NIL,col,0)
       ::VIEWPORTORG:=::convert({row,col})
       rr_setviewportorg(::ViewportOrg)
return self

METHOD GetViewPortOrg() CLASS HBPrinter
       rr_getviewportorg(::VIEWPORTORG)
return self

METHOD End() CLASS HBPrinter
local n
  if ::PreviewMode
    ::Metafiles:={}
	if !::InMemory
		for n := 1 to ::CurPage
			ferase(::BaseDoc + alltrim(strzero(n,4))+'.emf')
	   next
	end
  endif
  if ::HDCRef!=0
      ef_resetprinter()
      rr_deletedc(::HDCRef)
  endif
  rr_deleteobjects(::Fonts[1])
  rr_deleteobjects(::Brushes[1])
  rr_deleteobjects(::Pens[1])
  rr_deleteobjects(::Regions[1])
  rr_deleteimagelists(::ImageLists[1])
  rr_finish()
return NIL

METHOD DXCOLORS(par) CLASS HBPrinter
static rgbColorNames:=;
   {{ "aliceblue",             0xfffff8f0 },;
    { "antiquewhite",          0xffd7ebfa },;
    { "aqua",                  0xffffff00 },;
    { "aquamarine",            0xffd4ff7f },;
    { "azure",                 0xfffffff0 },;
    { "beige",                 0xffdcf5f5 },;
    { "bisque",                0xffc4e4ff },;
    { "black",                 0xff000000 },;
    { "blanchedalmond",        0xffcdebff },;
    { "blue",                  0xffff0000 },;
    { "blueviolet",            0xffe22b8a },;
    { "brown",                 0xff2a2aa5 },;
    { "burlywood",             0xff87b8de },;
    { "cadetblue",             0xffa09e5f },;
    { "chartreuse",            0xff00ff7f },;
    { "chocolate",             0xff1e69d2 },;
    { "coral",                 0xff507fff },;
    { "cornflowerblue",        0xffed9564 },;
    { "cornsilk",              0xffdcf8ff },;
    { "crimson",               0xff3c14dc },;
    { "cyan",                  0xffffff00 },;
    { "darkblue",              0xff8b0000 },;
    { "darkcyan",              0xff8b8b00 },;
    { "darkgoldenrod",         0xff0b86b8 },;
    { "darkgray",              0xffa9a9a9 },;
    { "darkgreen",             0xff006400 },;
    { "darkkhaki",             0xff6bb7bd },;
    { "darkmagenta",           0xff8b008b },;
    { "darkolivegreen",        0xff2f6b55 },;
    { "darkorange",            0xff008cff },;
    { "darkorchid",            0xffcc3299 },;
    { "darkred",               0xff00008b },;
    { "darksalmon",            0xff7a96e9 },;
    { "darkseagreen",          0xff8fbc8f },;
    { "darkslateblue",         0xff8b3d48 },;
    { "darkslategray",         0xff4f4f2f },;
    { "darkturquoise",         0xffd1ce00 },;
    { "darkviolet",            0xffd30094 },;
    { "deeppink",              0xff9314ff },;
    { "deepskyblue",           0xffffbf00 },;
    { "dimgray",               0xff696969 },;
    { "dodgerblue",            0xffff901e },;
    { "firebrick",             0xff2222b2 },;
    { "floralwhite",           0xfff0faff },;
    { "forestgreen",           0xff228b22 },;
    { "fuchsia",               0xffff00ff },;
    { "gainsboro",             0xffdcdcdc },;
    { "ghostwhite",            0xfffff8f8 },;
    { "gold",                  0xff00d7ff },;
    { "goldenrod",             0xff20a5da },;
    { "gray",                  0xff808080 },;
    { "green",                 0xff008000 },;
    { "greenyellow",           0xff2fffad },;
    { "honeydew",              0xfff0fff0 },;
    { "hotpink",               0xffb469ff },;
    { "indianred",             0xff5c5ccd },;
    { "indigo",                0xff82004b },;
    { "ivory",                 0xfff0ffff },;
    { "khaki",                 0xff8ce6f0 },;
    { "lavender",              0xfffae6e6 },;
    { "lavenderblush",         0xfff5f0ff },;
    { "lawngreen",             0xff00fc7c },;
    { "lemonchiffon",          0xffcdfaff },;
    { "lightblue",             0xffe6d8ad },;
    { "lightcoral",            0xff8080f0 },;
    { "lightcyan",             0xffffffe0 },;
    { "lightgoldenrodyellow",  0xffd2fafa },;
    { "lightgreen",            0xff90ee90 },;
    { "lightgrey",             0xffd3d3d3 },;
    { "lightpink",             0xffc1b6ff },;
    { "lightsalmon",           0xff7aa0ff },;
    { "lightseagreen",         0xffaab220 },;
    { "lightskyblue",          0xffface87 },;
    { "lightslategray",        0xff998877 },;
    { "lightsteelblue",        0xffdec4b0 },;
    { "lightyellow",           0xffe0ffff },;
    { "lime",                  0xff00ff00 },;
    { "limegreen",             0xff32cd32 },;
    { "linen",                 0xffe6f0fa },;
    { "magenta",               0xffff00ff },;
    { "maroon",                0xff000080 },;
    { "mediumaquamarine",      0xffaacd66 },;
    { "mediumblue",            0xffcd0000 },;
    { "mediumorchid",          0xffd355ba },;
    { "mediumpurple",          0xffdb7093 },;
    { "mediumseagreen",        0xff71b33c },;
    { "mediumslateblue",       0xffee687b },;
    { "mediumspringgreen",     0xff9afa00 },;
    { "mediumturquoise",       0xffccd148 },;
    { "mediumvioletred",       0xff8515c7 },;
    { "midnightblue",          0xff701919 },;
    { "mintcream",             0xfffafff5 },;
    { "mistyrose",             0xffe1e4ff },;
    { "moccasin",              0xffb5e4ff },;
    { "navajowhite",           0xffaddeff },;
    { "navy",                  0xff800000 },;
    { "oldlace",               0xffe6f5fd },;
    { "olive",                 0xff008080 },;
    { "olivedrab",             0xff238e6b },;
    { "orange",                0xff00a5ff },;
    { "orangered",             0xff0045ff },;
    { "orchid",                0xffd670da },;
    { "palegoldenrod",         0xffaae8ee },;
    { "palegreen",             0xff98fb98 },;
    { "paleturquoise",         0xffeeeeaf },;
    { "palevioletred",         0xff9370db },;
    { "papayawhip",            0xffd5efff },;
    { "peachpuff",             0xffb9daff },;
    { "peru",                  0xff3f85cd },;
    { "pink",                  0xffcbc0ff },;
    { "plum",                  0xffdda0dd },;
    { "powderblue",            0xffe6e0b0 },;
    { "purple",                0xff800080 },;
    { "red",                   0xff0000ff },;
    { "rosybrown",             0xff8f8fbc },;
    { "royalblue",             0xffe16941 },;
    { "saddlebrown",           0xff13458b },;
    { "salmon",                0xff7280fa },;
    { "sandybrown",            0xff60a4f4 },;
    { "seagreen",              0xff578b2e },;
    { "seashell",              0xffeef5ff },;
    { "sienna",                0xff2d52a0 },;
    { "silver",                0xffc0c0c0 },;
    { "skyblue",               0xffebce87 },;
    { "slateblue",             0xffcd5a6a },;
    { "slategray",             0xff908070 },;
    { "snow",                  0xfffafaff },;
    { "springgreen",           0xff7fff00 },;
    { "steelblue",             0xffb48246 },;
    { "tan",                   0xff8cb4d2 },;
    { "teal",                  0xff808000 },;
    { "thistle",               0xffd8bfd8 },;
    { "tomato",                0xff4763ff },;
    { "turquoise",             0xffd0e040 },;
    { "violet",                0xffee82ee },;
    { "wheat",                 0xffb3def5 },;
    { "white",                 0xffffffff },;
    { "whitesmoke",            0xfff5f5f5 },;
    { "yellow",                0xff00ffff },;
    { "yellowgreen",           0xff32cd9a }}
local ltemp:=0
//rgbcolornames:=asort(rgbcolornames,,,{|x,y| x[2]<y[2]})
if valtype(par)=="C"
   par:=lower(alltrim(par))
   aeval(rgbcolornames,{|x| if(x[1]==par,ltemp:=x[2],'')})
   return ltemp
elseif HB_IsNumeric(par)
   return if(par<=len(rgbcolornames),rgbcolornames[par,2],0)
endif
return 0

METHOD SetRGB(red,green,blue) CLASS HBPrinter
return rr_setrgb(red,green,blue)

METHOD SetTextCharExtra(col) CLASS HBPrinter
local p1:=::convert({0,0}),p2:=::convert({0,col})
return rr_SetTextCharExtra(p2[2]-p1[2])

METHOD GetTextCharExtra() CLASS HBPrinter
return rr_GetTextCharExtra()

METHOD SetTextJustification(col) CLASS HBPrinter
local p1:=::convert({0,0}),p2:=::convert({0,col})
return rr_SetTextJustification(p2[2]-p1[2])

METHOD GetTextJustification() CLASS HBPrinter
return rr_GetTextJustification()

METHOD SetTextAlign(style) CLASS HBPrinter
return rr_settextalign(style)

METHOD GetTextAlign() CLASS HBPrinter
return rr_gettextalign()

METHOD Picture(row,col,torow,tocol,cpicture,extrow,extcol,lImageSize) CLASS HBPrinter
local lp1:=::convert({row,col}),lp2,lp3
 if torow==NIL
    torow:=::maxrow
 endif
 if tocol==NIL
    tocol:=::maxcol
 endif
 lp2:=::convert({torow,tocol},1)
 if extrow==NIL
   extrow:=0
 endif
 if extcol==NIL
    extcol:=0
 endif
 lp3:=::convert({extrow,extcol})
 rr_drawpicture(cpicture,lp1,lp2,lp3,lImageSize)
return self

static function str2file(ctxt,cfile)
local hand,lrec
 hand:=fcreate(cfile)
 if hand<0
    return 0
 endif
 lrec:=fwrite(hand,ctxt)
 fclose(hand)
return lrec

static Function sayconvert(ltxt)
  do case
     case valtype(ltxt)$"MC"    ;  return ltxt
     case HB_IsNumeric(ltxt)    ;  return str(ltxt)
     case HB_IsDate(ltxt)    ;  return dtoc(ltxt)
     case HB_IsLogical(ltxt)    ;  return if(ltxt,".T.",".F.")
  endcase
return ""



static FUNCTION str2arr( cList, cDelimiter )
LOCAL nPos
LOCAL aList := {}
local nlencd:=0
LOCAL Asub
DO CASE
 CASE VALTYPE(CDELIMITER)=='C'
   cDelimiter:=if(cDelimiter==NIL,",",cDelimiter)
   nlencd:=len(cdelimiter)
   DO WHILE ( nPos := AT( cDelimiter, cList )) != 0
      AADD( aList, SUBSTR( cList, 1, nPos - 1 ))
      cList := SUBSTR( cList, nPos + nlencd )
   ENDDO
   AADD( aList, cList )
 CASE HB_IsNumeric(CDELIMITER)
   DO WHILE len((nPos:=left(clist,cdelimiter)))==cdelimiter
      aadd(alist,npos)
      clist:=substr(clist,cdelimiter+1)
   ENDDO
 CASE HB_IsArray(CDELIMITER)
   AEVAL(CDELIMITER,{|X| NLENCD+=X})
   DO WHILE len((nPos:=left(clist,NLENCD)))==NLENCD
      asub:={}
      aeval(cdelimiter,{|x| aadd(asub,left(npos,x)),npos:=substr(npos,x+1)})
      aadd(alist,asub)
      clist:=substr(clist,nlencd+1)
   ENDDO
 ENDCASE
RETURN ( aList )



**********************************************
METHOD PrevThumb(nclick) CLASS HBPrinter
**********************************************
local i,spage
 if ::iloscstron==1
    return self
 endif
 if nclick<>NIL
    ::page:=::ngroup*15+nclick
    ::prevshow()
     SetProperty ( 'hbpreview' , 'combo_1' , 'value' , ::Page )
    return self
 endif
 if int((::page-1)/15)<>::ngroup
       ::ngroup:=int((::page-1)/15)
 else
       return self
 endif
 spage:=::ngroup*15

 for i:=1 to 15
  if i+spage>::iloscstron
      HideWindow(::ath[i,5])
  else
     if ::Metafiles[i+spage,2]>=::Metafiles[i+spage,3]
       ::ath[i,3]:=::dy-5
       ::ath[i,4]:=::dx*::Metafiles[i+spage,3]/::Metafiles[i+spage,2]-5
     else
       ::ath[i,4]:=::dx-5
       ::ath[i,3]:=::dy*::Metafiles[i+spage,2]/::Metafiles[i+spage,3]-5
     endif
	 if ::InMemory
		rr_playthumb(::ath[i],::Metafiles[i+spage],alltrim(str(i+spage)),i)
	 else
		rr_playfthumb(::ath[i],::Metafiles[i+spage,1],alltrim(str(i+spage)),i)
	 endif
     CShowControl(::ath[i,5])
  endif
 next

return self

**************************************
METHOD PrevShow() CLASS HBPrinter
**************************************
local spos, hImage

 IF ::Thumbnails
    ::Prevthumb()
 ENDIF

 spos:={GetScrollpos(::ahs[5,7],SB_HORZ)/::azoom[4],GetScrollpos(::ahs[5,7],SB_VERT)/(::azoom[3])}

 if ::MetaFiles[::page,2]>=::MetaFiles[::page,3]
         ::azoom[3]:=(::ahs[5,3])*::scale-60
         ::azoom[4]:=(::ahs[5,3]*::MetaFiles[::page,3]/::MetaFiles[::page,2])*::scale-60
 else
         ::azoom[3]:=(::ahs[5,4]*::MetaFiles[::page,2]/::MetaFiles[::page,3])*::scale-60
         ::azoom[4]:=(::ahs[5,4])*::scale-60
 endif
 GetControlObject( "StatusBar", "hbpreview" ):Item( 1, ::aopisy[ 15 ] + " " + alltrim( str( ::page ) ) )

 if ::azoom[3]<30
    ::scale:=::scale*1.25
    ::prevshow()
    msgstop(::aopisy[18],"")
 endif
 HideWindow(::ahs[6,7])
   ::oHBPreview1:i1:SizePos( ,, ::azoom[4], ::azoom[3] )
   ::oHBPreview1:VirtualHeight := ::azoom[3]+20
   ::oHBPreview1:VirtualWidth := ::azoom[4]+20

 if ::InMemory
	hImage := rr_previewplay(::ahs[6,7],::METAFILES[::page],::azoom)
 else
	hImage := rr_previewfplay(::ahs[6,7],::METAFILES[::page,1],::azoom)
 endif
 if ! ValidHandler( hImage )
      ::scale:=::scale/1.25
      ::PrevShow()
      msgstop(::aopisy[18],::aopisy[1])
 else
      ::oHBPreview1:i1:hbitmap := hImage
 endif
 rr_scrollwindow(::ahs[5,7],-spos[1]*::azoom[4],-spos[2]*::azoom[3])
 CShowControl(::ahs[6,7])
return self

**************************************
METHOD PrevPrint(n1) CLASS HBPrinter
**************************************
local i,ilkop,_stronki:="",toprint:=.t.

IF .NOT. Eval(::BeforePrint)
  RETURN self
ENDIF

::Previewmode:=.f.
::Printingemf:=.t.
rr_lalabye(1)
if n1<>NIL
       ::startdoc()
       ::setpage(::MetaFiles[n1,6],::MetaFiles[n1,7])
       ::startpage()
	   if ::InMemory
           rr_PlayEnhMetaFile(::MetaFiles[n1],::hDCRef)
	   else
		   rr_PlayFEnhMetaFile(::MetaFiles[n1],::hDCRef)
		end
       ::endpage()
       ::enddoc()
else
       for ilkop = 1 to ::nCopies
        if .NOT. Eval(::BeforePrintCopy, ilkop)
          rr_lalabye(0)
          ::printingemf:=.f.
          ::Previewmode:=.t.
          return self
        endif
        ::startdoc()
          for i:=max(1,::nFromPage) to min(::iloscstron,::nToPage)
           do case
             case ::PrintOpt==1                    ; toprint:=.t.
             case ::PrintOpt==2 .or. ::PrintOpt==4 ; toprint:=!(i%2==0)
             case ::PrintOpt==3 .or. ::PrintOpt==5 ; toprint:=(i%2==0)
           endcase
           if toprint
              toprint:=.f.
              ::setpage(::MetaFiles[i,6],::MetaFiles[i,7])
              ::startpage()
              //rr_PlayEnhMetaFile(::MetaFiles[i],::hDCRef)
			  if ::InMemory
                 rr_PlayEnhMetaFile(::MetaFiles[i],::hDCRef)
	          else
		         rr_PlayFEnhMetaFile(::MetaFiles[i],::hDCRef)
	          end

              ::endpage()
           endif
          next i
          ::enddoc()

          if ::PrintOpt==4 .or. ::PrintOpt==5
             MsgBox(::aopisy[30],::aopisy[29])
             ::startdoc()
             for i:=max(1,::nFromPage) to min(::iloscstron,::nToPage)
               do case
                  case ::PrintOpt==4 ; toprint:=(i%2==0)
                  case ::PrintOpt==5 ; toprint:=!(i%2==0)
               endcase
               if toprint
                  toprint:=.f.
                  ::setpage(::MetaFiles[i,6],::MetaFiles[i,7])
                  ::startpage()
                  //rr_PlayEnhMetaFile(::MetaFiles[i],::hDCRef)
				  if ::InMemory
					rr_PlayEnhMetaFile(::MetaFiles[i],::hDCRef)
				  else
					rr_PlayFEnhMetaFile(::MetaFiles[i],::hDCRef)
				  end

                  ::endpage()
               endif
            next i
            ::enddoc()
          endif
       next ilkop
endif
rr_lalabye(0)
::printingemf:=.f.
::Previewmode:=.t.
Eval(::AfterPrint)
return self

**********************************
METHOD Preview() CLASS HBPrinter
**********************************
local i:=1,pi:=1,wl, oHBPreview

 ::aopisy:=;
{"Preview",;
"&Cancel",;
"&Print",;
"&Save",;
"&First",;
"P&revious",;
"&Next",;
"&Last",;
"Zoom In",;
"Zoom Out",;
"&Options",;
"Go To Page:",;
"Page preview ",;
"Thumbnails preview",;
"Page",;
"Print only current page",;
"Pages:",;
"No more zoom !",;
"Print options",;
"Print from",;
"to",;
"Copies",;
"Print Range",;
"All from range",;
"Odd only",;
"Even only",;
"All but odd first",;
"All but even first",;
"Printing ....",;
"Waiting for paper change..."}

  ::iloscstron:=len(::metafiles)
  ::ngroup:=-1
  ::page:=1
  ::ath:={}
  ::ahs:={}
  ::azoom:={0,0,0,0}
  ::scale:=::PREVIEWSCALE
  ::npages:={}

#ifdef __XHARBOUR__
  wl:=set(100)
#else
  wl:=hb_langselect()
#endif
  do case
  case wl="EN"
::aopisy:={"Preview";
,"&Cancel";
,"&Print";
,"&Save";
,"&First";
,"P&revious";
,"&Next";
,"&Last";
,"Zoom In";
,"Zoom Out";
,"&Options";
,"Go To Page:";
,"Page preview ";
,"Thumbnails preview";
,"Page";
,"Print only actual page";
,"Pages:";
,"No more zoom !";
,"Print options";
,"Print from";
,"to";
,"Copies";
,"Print Range";
,"All from range";
,"Odd only";
,"Even only";
,"All but odd first";
,"All but even first";
,"Printing ....";
,"Waiting for paper change..."}
  case wl="ES"
::aopisy:={"Vista Previa";
,"&Salir";
,"&Imprimir";
,"&Guardar";
,"&Primera";
,"&Anterior";
,"&Siguiente";
,"&Ultima";
,"Zoom +";
,"Zoom -";
,"&Opciones";
,"Pag.:";
,"Pagina ";
,"Miniaturas";
,"Pag.";
,"Imprimir solo pag. actual";
,"Paginas:";
,"Zoom Maximo/Minimo";
,"Opciones de Impresion";
,"Imprimir De";
,"a";
,"Copias";
,"Imprimir rango";
,"Todo a partir de desde";
,"Solo impares";
,"Solo pares";
,"Todo (impares primero)";
,"Todo (pares primero)";
,"Imprimiendo ....";
,"Esperando cambio de papel..."}
  case wl="IT"
::aopisy:={"Anteprima";
,"&Cancella";
,"S&tampa";
,"&Salva";
,"&Primo";
,"&Indietro";
,"&Avanti";
,"&Ultimo";
,"Zoom In";
,"Zoom Out";
,"&Opzioni";
,"Pagina:";
,"Pagina anteprima ";
,"Miniatura Anteprima";
,"Pagina";
,"Stampa solo pagina attuale";
,"Pagine:";
,"Limite zoom !";
,"Opzioni Stampa";
,"Stampa da";
,"a";
,"Copie";
,"Range Stampa";
,"Tutte";
,"Solo dispari";
,"Solo pari";
,"Tutte iniziando dispari";
,"Tutte iniziando pari";
,"Stampa in corso ....";
,"Attendere cambio carta..."}
case wl="PLWIN"
::aopisy:={"Podgl¹d";
,"&Rezygnuj";
,"&Drukuj";
,"Zapisz";
,"Pierwsza";
,"Poprzednia";
,"Nastêpna";
,"Ostatnia";
,"Powiêksz";
,"Pomniejsz";
,"Opc&je";
,"IdŸ do strony:";
,"Podgl¹d strony";
,"Podgl¹d miniaturek";
,"Strona";
,"Drukuj aktualn¹ stronê";
,"Stron:";
,"Nie mozna wiêcej !";
,"Opcje drukowania";
,"Drukuj od";
,"do";
,"Kopii";
,"Zakres";
,"Wszystkie z zakresu";
,"Tylko nieparzyste";
,"Tylko parzyste";
,"Najpierw nieparzyste";
,"Najpierw parzyste";
,"Drukowanie ....";
,"Czekam na zmiane papieru..."}
case wl="PT"
::aopisy:={"Inspeção Prévia";
,"&Cancelar";
,"&Imprimir";
,"&Salvar";
,"&Primera";
,"&Anterior";
,"Próximo";
,"&Último";
,"Zoom +";
,"Zoom -";
,"&Opções";
,"Pag.:";
,"Página ";
,"Miniaturas";
,"Pag.";
,"Imprimir somente a pag. atual";
,"Páginas:";
,"Zoom Máximo/Minimo";
,"Opções de Impressão";
,"Imprimir de";
,"Esta";
,"Cópias";
,"Imprimir rango";
,"Tudo a partir desta";
,"Só Ímpares";
,"Só Pares";
,"Todas as Ímpares Primeiro";
,"Todas Pares primero";
,"Imprimindo ....";
,"Esperando por papel..."}
case wl="DEWIN"
::aopisy:={"Vorschau";
,"&Abbruch";
,"&Drucken";
,"&Speichern";
,"&Erste";
,"&Vorige";
,"&Nächste";
,"&Letzte";
,"Ver&größern";
,"Ver&kleinern";
,"&Optionen";
,"Seite:";
,"Seitenvorschau";
,"Überblick";
,"Seite";
,"Aktuelle Seite drucken";
,"Seiten:";
,"Maximum erreicht!";
,"Druckeroptionen";
,"Drucke von";
,"bis";
,"Anzahl";
,"Bereich";
,"Alle Seiten";
,"Ungerade Seiten";
,"Gerade Seiten";
,"Alles, ungerade Seiten zuerst";
,"Alles, gerade Seiten zuerst";
,"Druckt ....";
,"Bitte Papier nachlegen..."}
case wl='FR'
::aopisy:={"Prévisualisation";
,"&Abandonner";
,"&Imprimer";
,"&Sauver";
,"&Premier";
,"P&récédent";
,"&Suivant";
,"&Dernier";
,"Zoom +";
,"Zoom -";
,"&Options";
,"Aller à la page:";
,"Aperçu de la page";
,"Aperçu affichettes";
,"Page";
,"Imprimer la page en cours";
,"Pages:";
,"Plus de zoom !";
,"Options d'impression";
,"Imprimer de";
,"à";
,"Copies";
,"Intervalle d'impression";
,"Tout dans l'intervalle";
,"Impair seulement";
,"Pair seulement";
,"Tout mais impair d'abord";
,"Tout mais pair d'abord";
,"Impression ....";
,"Attente de changement de papier..."}
  endcase

  if ::nwhattoprint<2
   ::ntopage:=::iloscstron
  endif
//  for i:=1 to len(::aopisy)
//    ctxt:=rr_loadstring(60000+i)
//    if !empty(ctxt)
//      ::aopisy[i]:=ctxt
//    endif
//  next

  if !::PreviewMode // .or. empty(::metafiles)
    return self
  endif
  aadd(::ahs,{0,0,0,0,0,0,0})
  rr_getwindowrect(::ahs[1])

for pi=1 to ::iloscstron
AADD(::npages,padl(pi,4))
next pi

  if ::PreviewRect[3]>0 .and. ::PreviewRect[4]>0
    ::ahs[1,1]:=::Previewrect[1]
    ::ahs[1,2]:=::Previewrect[2]
    ::ahs[1,3]:=::Previewrect[3]
    ::ahs[1,4]:=::Previewrect[4]
    ::ahs[1,5]:=::Previewrect[3]-::Previewrect[1]+1
    ::ahs[1,6]:=::Previewrect[4]-::Previewrect[2]+1
  else
    ::ahs[1,1]+=10
    ::ahs[1,2]+=10
    ::ahs[1,3]-=10
    ::ahs[1,4]-=10
    ::ahs[1,5]:=::ahs[1,3]-::ahs[1,1]+1
    ::ahs[1,6]:=::ahs[1,4]-::ahs[1,2]+1
  endif

  DEFINE WINDOW HBPREVIEW OBJ oHBPreview AT  ::ahs[1,1] , ::ahs[1,1] ;
         WIDTH ::ahs[1,6] HEIGHT ::ahs[1,5]-45 ;
          TITLE ::aopisy[1] ICON 'zzz_Printicon' ;
          MODAL NOSIZE ;
          FONT 'Arial' SIZE 9

         oHBPreview:HotKey(  27, 0, {|| oHBPreview:Release() } )
         oHBPreview:HotKey( 107, 0, {|| ::scale:=::scale*1.25,:: PrevShow () } )
         oHBPreview:HotKey( 109, 0, {|| ::scale:=::scale/1.25,:: PrevShow () } )

         DEFINE STATUSBAR

                        STATUSITEM ::aopisy[15]+" "+alltrim(str(::page)) WIDTH 100
                        STATUSITEM ::aopisy[16] WIDTH 200 ICON 'zzz_Printicon'  ACTION ::PREVPRINT(::PAGE) RAISED
                        STATUSITEM ::aopisy[17]+" "+alltrim(str(::iloscstron)) WIDTH 100

         END STATUSBAR

               @ 15 ,::ahs[1,6]-150 LABEL prl VALUE ::aopisy[12] WIDTH  80 HEIGHT 18 FONT 'Arial' SIZE 08
               @ 13 ,::ahs[1,6]-77  COMBOBOX combo_1  ITEMS ::npages VALUE 1 WIDTH 58 FONT 'Arial' SIZE  8 ON CHANGE {|| ::page := ::CurPage:=HBPREVIEW.combo_1.value,::PrevShow(),::oHBPreview1:setfocus() }

         DEFINE SPLITBOX
               DEFINE TOOLBAR TB1 BUTTONSIZE 50,37 FONT 'Arial Narrow' SIZE 8 FLAT BREAK // RIGHTTEXT
////                        BUTTON B1 CAPTION  ::aopisy[2]     PICTURE 'hbprint_close'   ACTION {||  ::oHBPreview1:Release(),if(::iloscstron>1 .and. ::thumbnails,_ReleaseWindow ("HBPREVIEW2" ),""), oHBPreview:Release()}
                        BUTTON B1 CAPTION  ::aopisy[2]     PICTURE 'hbprint_close'   ACTION MYCLOSEP(::iloscstron,::thumbnails ,oHBPreview,::oHBPreview1)
                        BUTTON B2 CAPTION  ::aopisy[3]    PICTURE 'hbprint_print'   ACTION {|| ::prevprint() }
                        if .NOT. ::NoButtonSave
                          BUTTON B3 CAPTION  ::aopisy[4]     PICTURE 'hbprint_save'    ACTION {|| ::savemetafiles()}
                        endif
                        if ::iloscstron>1
                           BUTTON B4 CAPTION  ::aopisy[5]    PICTURE 'hbprint_top'     ACTION {|| ::page := ::CurPage:=1,HBPREVIEW.combo_1.value:=::page, ::PrevShow() }
                           BUTTON B5 CAPTION  ::aopisy[6] PICTURE 'hbprint_back'    ACTION {|| ::page :=::CurPage:=if(::page==1,1,::page-1),HBPREVIEW.combo_1.value:=::page, ::PrevShow() }
                           BUTTON B6 CAPTION  ::aopisy[7]     PICTURE 'hbprint_next'    ACTION {|| ::page := ::CurPage:=if(::page==::iloscstron,::page,::page+1) , HBPREVIEW.combo_1.value:=::page,::PrevShow() }
                           BUTTON B7 CAPTION  ::aopisy[8]     PICTURE 'hbprint_end'     ACTION {|| ::page := ::CurPage:=::iloscstron,HBPREVIEW.combo_1.value:=::page,::PrevShow() }
                        endif
                        BUTTON B8 CAPTION  ::aopisy[9]  PICTURE 'hbprint_zoomin'  ACTION {|| ::scale:=::scale*1.25,::PrevShow() }
                        BUTTON B9 CAPTION  ::aopisy[10] PICTURE 'hbprint_zoomout' ACTION {|| ::scale:=::scale/1.25,::PrevShow() }
                        if .NOT. ::NoButtonOptions
                          BUTTON B10 CAPTION ::aopisy[11] PICTURE 'hbprint_option' ACTION {|| ::PrintOption() }
                        endif
               END TOOLBAR

               aadd(::ahs,{0,0,0,0,0,0,oHBPreview:hWnd})
               rr_getclientrect(::ahs[2])

               aadd(::ahs,{0,0,0,0,0,0,oHBPreview:Tb1:hWnd})
               rr_getclientrect(::ahs[3])
               aadd(::ahs,{0,0,0,0,0,0,oHBPreview:StatusBar:hWnd})
               rr_getclientrect(::ahs[4])

               DEFINE WINDOW 0 OBJ ::oHBPreview1 ;
                      WIDTH ::ahs[2,6]-15  HEIGHT ::ahs[2,5]-::ahs[3,5]-::ahs[4,5]-10 ;
                      VIRTUAL WIDTH ::ahs[2,6] -5;
                      VIRTUAL HEIGHT ::ahs[2,5]-::ahs[3,5]-::ahs[4,5] ;
                      TITLE ::aopisy[13]   SPLITCHILD  GRIPPERTEXT "P" ;
                      NOSYSMENU NOCAPTION ;
                      ON MOUSECLICK  ( ::oHBPreview1:setfocus() )

                      ::oHBPreview1:VScrollbar:nLineSkip := 20
                      ::oHBPreview1:HScrollbar:nLineSkip := 20

                      aadd(::ahs,{0,0,0,0,0,0, ::oHBPreview1:hWnd})
                      rr_getclientrect(::ahs[5])
                      @ ::ahs[5,2]+10,::ahs[5,1]+10 IMAGE I1  PICTURE "" WIDTH ::ahs[5,6]-10 HEIGHT ::ahs[5,5]-10
                      aadd(::ahs,{0,0,0,0,0,0,::oHBPreview1:i1:hWnd})
                      rr_getclientrect(::ahs[6])

               END WINDOW

               IF ::THUMBNAILS .and. ::iloscstron>1
                  DEFINE WINDOW HBPREVIEW2  ;
                      WIDTH ::ahs[2,6]-15  HEIGHT ::ahs[2,5]-::ahs[3,5]-::ahs[4,5]-10 ;
                      TITLE ::aopisy[14]   SPLITCHILD      GRIPPERTEXT "T"
                      aadd(::ahs,{0,0,0,0,0,0,GetFormHandle("hbpreview2")})
                      rr_getClientRect(::ahs[7])
                      ::dx:=(::ahs[5,6]-20)/5-5
                      ::dy:=::ahs[5,5]/3-5
                      for i:=1 to 15
                         aadd(::ath,{0,0,0,0,0})
                         if ::Metafiles[1,2]>=::Metafiles[1,3]
                             ::ath[i,3]:=::dy-5
                             ::ath[i,4]:=::dx*::Metafiles[1,3]/::Metafiles[1,2]-5
                         else
                             ::ath[i,4]:=::dx-5
                             ::ath[i,3]:=::dy*::Metafiles[1,2]/::Metafiles[1,3]-5
                         endif
                         ::ath[i,1]:=int((i-1)/5)*::dy+5
                         ::ath[i,2]:=((i-1)%5)*::dx+5
                       next
                       @::ath[1 ,1],::ath[1 ,2]  image it1  of hbpreview2 picture "" action {|| ::Prevthumb(1 ) } width ::ath[1 ,4] height ::ath[1 ,3]
                       @::ath[2 ,1],::ath[2 ,2]  image it2  of hbpreview2 picture "" action {|| ::Prevthumb(2 ) } width ::ath[2 ,4] height ::ath[2 ,3]
                       @::ath[3 ,1],::ath[3 ,2]  image it3  of hbpreview2 picture "" action {|| ::Prevthumb(3 ) } width ::ath[3 ,4] height ::ath[3 ,3]
                       @::ath[4 ,1],::ath[4 ,2]  image it4  of hbpreview2 picture "" action {|| ::Prevthumb(4 ) } width ::ath[4 ,4] height ::ath[4 ,3]
                       @::ath[5 ,1],::ath[5 ,2]  image it5  of hbpreview2 picture "" action {|| ::Prevthumb(5 ) } width ::ath[5 ,4] height ::ath[5 ,3]
                       @::ath[6 ,1],::ath[6 ,2]  image it6  of hbpreview2 picture "" action {|| ::Prevthumb(6 ) } width ::ath[6 ,4] height ::ath[6 ,3]
                       @::ath[7 ,1],::ath[7 ,2]  image it7  of hbpreview2 picture "" action {|| ::Prevthumb(7 ) } width ::ath[7 ,4] height ::ath[7 ,3]
                       @::ath[8 ,1],::ath[8 ,2]  image it8  of hbpreview2 picture "" action {|| ::Prevthumb(8 ) } width ::ath[8 ,4] height ::ath[8 ,3]
                       @::ath[9 ,1],::ath[9 ,2]  image it9  of hbpreview2 picture "" action {|| ::Prevthumb(9 ) } width ::ath[9 ,4] height ::ath[9 ,3]
                       @::ath[10,1],::ath[10,2]  image it10 of hbpreview2 picture "" action {|| ::Prevthumb(10) } width ::ath[10,4] height ::ath[10,3]
                       @::ath[11,1],::ath[11,2]  image it11 of hbpreview2 picture "" action {|| ::Prevthumb(11) } width ::ath[11,4] height ::ath[11,3]
                       @::ath[12,1],::ath[12,2]  image it12 of hbpreview2 picture "" action {|| ::Prevthumb(12) } width ::ath[12,4] height ::ath[12,3]
                       @::ath[13,1],::ath[13,2]  image it13 of hbpreview2 picture "" action {|| ::Prevthumb(13) } width ::ath[13,4] height ::ath[13,3]
                       @::ath[14,1],::ath[14,2]  image it14 of hbpreview2 picture "" action {|| ::Prevthumb(14) } width ::ath[14,4] height ::ath[14,3]
                       @::ath[15,1],::ath[15,2]  image it15 of hbpreview2 picture "" action {|| ::Prevthumb(15) } width ::ath[15,4] height ::ath[15,3]

                       for i:=1 to 15
                          ::ath[i,5]:=GetControlHandle("it"+alltrim(str(i)),"hbpreview2")
                          rr_playthumb(::ath[i],::Metafiles[i],alltrim(str(i)),i)
                          if i>=::iloscstron
                            exit
                          endif
                       next
                  END WINDOW
               ENDIF
         END SPLITBOX
  END WINDOW
  ::PrevShow()
  ::oHBPreview1:setfocus()
  ACTIVATE WINDOW HBPREVIEW
return nil

FUNCTION MYCLOSEP(T1,T2,OT3,oHBPreview1)
oHBPreview1:Release()
IF T1>1 .and. T2
  _ReleaseWindow ("HBPREVIEW2" )
ENDIF
oT3:Release()
return nil
*******************************************
METHOD PrintOption() CLASS HBPrinter
*******************************************
Local OKprint:=.f.,aro:={::aopisy[24],::aopisy[25],::aopisy[26],::aopisy[27],::aopisy[28]}

If IsWIndowDefined(PrOpt)==.f.

  DEFINE WINDOW PrOpt AT 270,346 WIDTH 298 HEIGHT 134 TITLE ::aopisy[19] ICON 'zzz_Printicon' ;
         MODAL NOSIZE FONT 'Arial' SIZE  9

@ 2,1    FRAME   PrOptFrame  WIDTH 291 HEIGHT 105
@ 19,9   LABEL   label_11  VALUE ::aopisy[20] WIDTH 87 HEIGHT 16 FONT 'Arial' SIZE 9 BOLD
@ 18,90  TEXTBOX textFrom  HEIGHT 21 WIDTH 33 NUMERIC Font 'Arial' size 09 MAXLENGTH 4 RIGHTALIGN
@ 19,134 LABEL   label_12  VALUE ::aopisy[21] WIDTH 14 HEIGHT 19 FONT 'Arial' SIZE 09 BOLD
@ 18,156 TEXTBOX textTo HEIGHT 21 WIDTH 33 NUMERIC Font 'Arial' size 09 MAXLENGTH 4 RIGHTALIGN
@ 19,200 LABEL   label_18  VALUE ::aopisy[22]  WIDTH 40 HEIGHT 19 FONT 'Arial' SIZE 09 BOLD
@ 18,252 TEXTBOX textCopies HEIGHT 21 WIDTH 30 NUMERIC Font 'Arial' size 09 MAXLENGTH 4   RIGHTALIGN
@ 55,9   LABEL label_13 VALUE ::aopisy[23]  WIDTH 71 HEIGHT 17 FONT 'Arial' SIZE 9 BOLD
@ 50,90  COMBOBOX prnCombo VALUE ::PRINTOPT ITEMS {::aopisy[24],::aopisy[25],::aopisy[26],::aopisy[27],::aopisy[28]}  WIDTH 195 FONT 'Arial' SIZE 9


@ 82,90 BUTTON button_14 CAPTION "OK";
  ACTION {|| ::nFromPage:=PrOpt.textFrom.Value,::nToPage:=PrOpt.textTo.Value,::nCopies:=max(PrOpt.textCopies.Value,1),::PrintOpt:=PrOpt.prnCombo.Value , PrOpt.Release} ;
  WIDTH 110 HEIGHT 19 ;
  FONT 'Arial' SIZE 9

END WINDOW
endif
PrOpt.Title := ::aopisy[19]
PrOpt.textCopies.Value := ::nCopies
PrOpt.textFrom.Value := max(::nfrompage,1)
PrOpt.textTo.Value := if(::nwhattoprint<2,::iloscstron,::ntopage)
PrOpt.Activate

Return OKPrint


METHOD ReportData(l_x1,l_x2,l_x3,l_x4,l_x5,l_x6) CLASS HBPrinter
set device to print
set printer to "hbprinter.rep" ADDITIVE
set printer on
set console off
 ? '-----------------',date(),time()
 ?
 ?? if(valtype(l_x1)<>"U",l_x1,",")
 ?? if(valtype(l_x2)<>"U",l_x2,",")
 ?? if(valtype(l_x3)<>"U",l_x3,",")
 ?? if(valtype(l_x4)<>"U",l_x4,",")
 ?? if(valtype(l_x5)<>"U",l_x5,",")
 ?? if(valtype(l_x6)<>"U",l_x6,",")
 ? 'HDC            :',::HDC
 ? 'HDCREF         :',::HDCREF
 ? 'PRINTERNAME    :',::PRINTERNAME
 ? 'PRINTEDEFAULT  :',::PRINTERDEFAULT
 ? 'VERT X HORZ SIZE         :',::DEVCAPS[1],"x",::DEVCAPS[2]
 ? 'VERT X HORZ RES          :',::DEVCAPS[3],"x",::DEVCAPS[4]
 ? 'VERT X HORZ LOGPIX       :',::DEVCAPS[5],"x",::DEVCAPS[6]
 ? 'VERT X HORZ PHYS. SIZE   :',::DEVCAPS[7],"x",::DEVCAPS[8]
 ? 'VERT X HORZ PHYS. OFFSET :',::DEVCAPS[9],"x",::DEVCAPS[10]
 ? 'VERT X HORZ FONT SIZE    :',::DEVCAPS[11],"x",::DEVCAPS[12]
 ? 'VERT X HORZ ROWS COLS    :',::DEVCAPS[13],"x",::DEVCAPS[14]
 ? 'ORIENTATION              :',::DEVCAPS[15]
 ? 'PAPER SIZE               :',::DEVCAPS[17]
set printer off
set printer to
set console on
set device to screen
return self



#pragma BEGINDUMP

#define _WIN32_IE      0x0500
#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#define WINVER   0x0400

#include <windows.h>
#include <winuser.h>
#include <wingdi.h>
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include <olectl.h>
#include <ocidl.h>
#include <commctrl.h>
#include "oohg.h"

static HDC hDC=NULL;
static HDC hDCRef=NULL;
static HDC hDCtemp;
static DEVMODE *pDevMode = NULL;
static DEVMODE *pDevMode2 = NULL;
static DEVNAMES *pDevNames = NULL;
static HANDLE hPrinter = NULL;
static PRINTER_INFO_2 *pi2 = NULL;
static PRINTER_INFO_2 *pi22 = NULL;  // to restore printer dev mode after print.static PRINTER_INFO_2 *pi22 = NULL;  // to restore printer dev mode after print.
static PRINTER_DEFAULTS pd;
static PRINTDLG pdlg;
static DOCINFO di;
static int nFromPage=0 ;
static int nToPage=0  ;
static char PrinterName[128] ;
static char PrinterDefault[128] ;
static DWORD charset=DEFAULT_CHARSET;
static HFONT hfont ;
static HPEN hpen ;
static HBRUSH hbrush ;
static int textjust=0;
static int devcaps[] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0};
static int preview=0;
static int polyfillmode=1;
static HRGN hrgn = NULL;
static HBITMAP hbmp[]= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
static OSVERSIONINFO osvi;

void rr_getdevmode(void);
//void rr_showerror(void);

HB_FUNC (RR_FINISH)
{
 pDevMode = NULL;
 pDevMode2 = NULL;
 pDevNames = NULL;
 ClosePrinter(hPrinter);
 hPrinter = NULL;
 pi2 = NULL;
 memset(&pd,0,sizeof(pd));
 memset(&pdlg,0,sizeof(pdlg));
 memset(&di,0,sizeof(di));
 nFromPage=0 ;
 nToPage=0  ;
 hfont = NULL;
 hpen = NULL ;
 hbrush = NULL;
 textjust=0;
 memset(&devcaps,0,sizeof(devcaps));
 devcaps[15]=1;
 preview=0;
 polyfillmode=1;
 hrgn = NULL;
 memset(&hbmp,0,sizeof(hbmp));

}
HB_FUNC (JK_ODD)
{
  hb_retl(hb_parni(1) % 2);
}

HB_FUNC (RR_PRINTERNAME)
{
  hb_retc(PrinterName);
}

HB_FUNC (RR_PRINTDIALOG)
{
  HWND hwnd ;

  LPCTSTR pDevice;
  memset( &pdlg,0, sizeof( pdlg ) );
  pdlg.lStructSize = sizeof( pdlg );
  pdlg.Flags = PD_RETURNDC|PD_ALLPAGES;
  pdlg.nFromPage=1;
  pdlg.nToPage=1;
//  pdlg.nMinPage=1;
//  pdlg.nMaxPage=999999;
  hwnd = GetActiveWindow() ;
  pdlg.hwndOwner  = hwnd ;


  if ( PrintDlg( &pdlg ) )
    {
      hDC = pdlg.hDC;
      pDevMode = (LPDEVMODE) GlobalLock(pdlg.hDevMode);
      pDevNames = (LPDEVNAMES) GlobalLock(pdlg.hDevNames);
      // Note: pDevMode->dmDeviceName is limited to 32 characters.
      // if the printer name is greater than 32, like network printers,
      // the rr_getdc() function return a null handle. So, I'm using
      // pDevNames instead pDevMode. (E.F.)
      //strcpy(PrinterName,pDevMode->dmDeviceName);
      pDevice = (LPCTSTR) pDevNames + pDevNames->wDeviceOffset;
      strcpy(PrinterName, (char *) pDevice);

      if (hDC==NULL)
         {
           strcpy(PrinterName,"");
           GlobalUnlock(pdlg.hDevMode);
           GlobalUnlock(pdlg.hDevNames);
         }
      else
         {
           HB_STORNL((LONG) pdlg.nFromPage,1,1);
           HB_STORNL((LONG) pdlg.nToPage  ,1,2);
           HB_STORNL((LONG) pdlg.nCopies  ,1,3);
           if ((pdlg.Flags & PD_PAGENUMS)==PD_PAGENUMS)
              HB_STORNL(2,1,4);
           else if ((pdlg.Flags & PD_SELECTION)==PD_SELECTION)
                     HB_STORNL(1,1,4);
                else
                     HB_STORNL(0,1,4);

           rr_getdevmode();
         }
     }
  else
     hDC=0;
  hDCRef=hDC;

  hb_retnl((LONG) hDC);
}



HB_FUNC (RR_GETDC)
{
  if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
//   {
//    if (osvi.dwMajorVersion < 5)
        hDC=CreateDC("WINSPOOL",hb_parc(1),NULL,NULL);
//   }
  else
        hDC=CreateDC(NULL,hb_parc(1),NULL,NULL);

  if (hDC)
     {
       strcpy(PrinterName,hb_parc(1));
       rr_getdevmode();
     }
  hDCRef=hDC;
  hb_retnl((LONG) hDC);
}


void rr_getdevmode()
{
    DWORD dwNeeded = 0;
    memset(&pd,0, sizeof(pd));
    pd.DesiredAccess = PRINTER_ALL_ACCESS;
    OpenPrinter(PrinterName, &hPrinter, NULL);
    GetPrinter(hPrinter, 2, 0, 0, &dwNeeded);
    pi2 = (PRINTER_INFO_2 *)GlobalAlloc(GPTR, dwNeeded);
    GetPrinter(hPrinter, 2, (LPBYTE)pi2, dwNeeded, &dwNeeded);
    pi22 = (PRINTER_INFO_2 *)GlobalAlloc(GPTR, dwNeeded);
    GetPrinter(hPrinter, 2, (LPBYTE)pi22, dwNeeded, &dwNeeded);

    if (pDevMode)
       {
          pi2->pDevMode = pDevMode;
       }
    else
    {
      if (pi2->pDevMode == NULL)
      {
        dwNeeded = DocumentProperties(NULL, hPrinter,PrinterName,NULL, NULL, 0);
        pDevMode2 = (DEVMODE *)GlobalAlloc(GPTR, dwNeeded);
        DocumentProperties(NULL, hPrinter,PrinterName,pDevMode2, NULL,DM_OUT_BUFFER);
        pi2->pDevMode=pDevMode2 ;
      }
    }
    hfont  = (HFONT) GetCurrentObject(hDC,OBJ_FONT);
    hbrush = (HBRUSH) GetCurrentObject(hDC,OBJ_BRUSH);
    hpen   = (HPEN) GetCurrentObject(hDC,OBJ_PEN);
}


HB_FUNC (EF_RESETPRINTER)
{
 if ( pi22 )
    SetPrinter(hPrinter, 2, (LPBYTE)pi22,0);

 GlobalFree(pi22);
 pi22=NULL;
}



HB_FUNC (RR_DELETEDC)
{
  if (pdlg.hDevMode)
     GlobalUnlock(pdlg.hDevMode);
  if (pDevMode)
       GlobalFree(pDevMode);
  if (pDevMode2)
       GlobalFree(pDevMode2);
  if (pDevNames)
       GlobalFree(pDevNames);
  if (pi2)
       GlobalFree(pi2);
  DeleteDC((HDC) hb_parnl(1));
}


HB_FUNC (RR_GETDEVICECAPS)
{
 TEXTMETRIC tm;
 UINT i;
 HFONT xfont=(HFONT) hb_parnl(2);
 if (xfont!=0)
    SelectObject(hDCRef,xfont);
 GetTextMetrics(hDCRef,&tm);
 devcaps[1 ]=GetDeviceCaps(hDCRef,VERTSIZE);
 devcaps[2 ]=GetDeviceCaps(hDCRef,HORZSIZE);
 devcaps[3 ]=GetDeviceCaps(hDCRef,VERTRES);
 devcaps[4 ]=GetDeviceCaps(hDCRef,HORZRES);
 devcaps[5 ]=GetDeviceCaps(hDCRef,LOGPIXELSY);
 devcaps[6 ]=GetDeviceCaps(hDCRef,LOGPIXELSX);
 devcaps[7 ]=GetDeviceCaps(hDCRef,PHYSICALHEIGHT);
 devcaps[8 ]=GetDeviceCaps(hDCRef,PHYSICALWIDTH);
 devcaps[9 ]=GetDeviceCaps(hDCRef,PHYSICALOFFSETY);
 devcaps[10]=GetDeviceCaps(hDCRef,PHYSICALOFFSETX);

 devcaps[11]=tm.tmHeight;
 devcaps[12]=tm.tmAveCharWidth;
 devcaps[13]=(int) ((devcaps[3]-tm.tmAscent)/tm.tmHeight);
 devcaps[14]=(int) (devcaps[4]/tm.tmAveCharWidth);
 devcaps[15]=pi2->pDevMode->dmOrientation;
 devcaps[16]=(int) tm.tmAscent;
 devcaps[17]=(int) pi2->pDevMode->dmPaperSize;
 for(i = 1; i <= hb_parinfa(1,0); i++)
     HB_STORNI(devcaps[i],1,i);
 if (xfont!=0)
    SelectObject(hDCRef,hfont);
}

HB_FUNC (RR_SETDEVMODE)
{
 DWORD what= hb_parnl(1);
 if (what == (pi2->pDevMode->dmFields & what))
  {
     if (what==DM_ORIENTATION)    pi2->pDevMode->dmOrientation = (short) hb_parni(2);
     if (what==DM_PAPERSIZE)      pi2->pDevMode->dmPaperSize = (short)hb_parni(2);
     if (what==DM_SCALE)          pi2->pDevMode->dmScale = (short)hb_parni(2);
     if (what==DM_COPIES)         pi2->pDevMode->dmCopies = (short)hb_parni(2);
     if (what==DM_DEFAULTSOURCE)  pi2->pDevMode->dmDefaultSource = (short)hb_parni(2);
     if (what==DM_PRINTQUALITY)   pi2->pDevMode->dmPrintQuality = (short)hb_parni(2);
     if (what==DM_COLOR)          pi2->pDevMode->dmColor = (short)hb_parni(2);
     if (what==DM_DUPLEX)         pi2->pDevMode->dmDuplex = (short)hb_parni(2);
     if (what==DM_COLLATE)        pi2->pDevMode->dmCollate = (short)hb_parni(2);

     DocumentProperties(NULL, hPrinter,PrinterName,pi2->pDevMode,pi2->pDevMode,DM_IN_BUFFER | DM_OUT_BUFFER);
     SetPrinter(hPrinter, 2, (LPBYTE)pi2,0);
     ResetDC(hDCRef,pi2->pDevMode);
     hb_retnl((LONG) hDCRef);
  }
}

HB_FUNC (RR_GETDEFAULTPRINTER)
{

  DWORD Needed, Returned;
  DWORD BuffSize = 256;
  LPPRINTER_INFO_5 PrinterInfo;

  if (osvi.dwPlatformId == VER_PLATFORM_WIN32_WINDOWS)
  {
    EnumPrinters(PRINTER_ENUM_DEFAULT,NULL,5,NULL,0,&Needed,&Returned);
    PrinterInfo = (LPPRINTER_INFO_5) LocalAlloc(LPTR,Needed);
    EnumPrinters(PRINTER_ENUM_DEFAULT,NULL,5,(LPBYTE) PrinterInfo,Needed,&Needed,&Returned);
    strcpy(PrinterDefault,PrinterInfo->pPrinterName);
    LocalFree(PrinterInfo);
  }
  else if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
  {
    if (osvi.dwMajorVersion >= 5) /* Windows 2000 or later */
    {
//      GetDefaultPrinter(PrinterDefault,&BuffSize);
      GetProfileString("windows","device","",PrinterDefault,BuffSize);
      strtok(PrinterDefault, ",");
    }
    else /* Windows NT 4.0 or earlier */
    {
      GetProfileString("windows","device","",PrinterDefault,BuffSize);
      strtok(PrinterDefault, ",");
    }
  }
  hb_retc(PrinterDefault);
  return ;
}


HB_FUNC (RR_GETPRINTERS)
{
  DWORD dwSize = 0;
  DWORD dwPrinters = 0;
  DWORD i;
  char * pBuffer ;
  char * cBuffer ;
  PRINTER_INFO_4* pInfo4;
  PRINTER_INFO_5* pInfo5;
  DWORD level;
  DWORD flags;

  osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
  GetVersionEx(&osvi);
  if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
    {
     level = 4;
     flags = PRINTER_ENUM_CONNECTIONS|PRINTER_ENUM_LOCAL;
    }
  else
    {
     level = 5;
     flags = PRINTER_ENUM_LOCAL;
    }

  EnumPrinters(flags, NULL,level, NULL, 0, &dwSize, &dwPrinters);

  pBuffer = (char *) GlobalAlloc(GPTR, dwSize);
  if (pBuffer == NULL)
     {
            hb_retc(",,");
            return;
     }
  EnumPrinters(flags, NULL,level, ( BYTE * ) pBuffer, dwSize, &dwSize, &dwPrinters);

  if (dwPrinters == 0)
     {
             hb_retc(",,");
             return;
     }
  cBuffer = (char *) GlobalAlloc(GPTR, dwPrinters*256);

  if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
     pInfo4 = (PRINTER_INFO_4*)pBuffer;
  else
     pInfo5 = (PRINTER_INFO_5*)pBuffer;

  for ( i = 0; i < dwPrinters; i++)
      {
       if (osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
          {
           strcat(cBuffer,pInfo4->pPrinterName);
           strcat(cBuffer,",");
           if (pInfo4->Attributes==PRINTER_ATTRIBUTE_LOCAL)
               strcat(cBuffer,"local printer");
           else
               strcat(cBuffer,"network printer");
           pInfo4++;
          }
       else
          {
           strcat(cBuffer,pInfo5->pPrinterName);
           strcat(cBuffer,",");
           strcat(cBuffer,pInfo5->pPortName);
           pInfo5++;
          }
       if (i < dwPrinters-1)
           strcat(cBuffer,",,");

      }
  hb_retc(cBuffer);
  GlobalFree(pBuffer);
  GlobalFree(cBuffer);
  return;
}

HB_FUNC (RR_STARTDOC)
{
  memset( &di, 0, sizeof( di ) );
  di.cbSize = sizeof( di );
  di.lpszDocName=hb_parc(1);
  StartDoc( hDC, &di );
}
HB_FUNC (RR_STARTPAGE)
{
  StartPage( hDC );
  SetTextAlign(hDC,TA_BASELINE);
}
HB_FUNC (RR_ENDPAGE)
{
  EndPage( hDC );
}
HB_FUNC (RR_ENDDOC)
{
        EndDoc( hDC );
}

HB_FUNC (RR_ABORTDOC)
{
  AbortDoc(hDC);
  DeleteDC(hDC);
}

HB_FUNC( RR_DEVICECAPABILITIES )
{
   char *cBuffer, *pBuffer, *nBuffer, *sBuffer, *bnBuffer, *bwBuffer, *bcBuffer;
   DWORD  numpapers,numbins,i;
   LPPOINT lp;
   char buffer [sizeof(long)*8+1] ;
   numbins=DeviceCapabilities(pi2->pPrinterName,pi2->pPortName,DC_BINNAMES,NULL,NULL);
   numpapers=DeviceCapabilities(pi2->pPrinterName,pi2->pPortName,DC_PAPERNAMES,NULL,NULL);
   if( numpapers != ( DWORD ) 0 && numpapers != ( DWORD ) ( ~0 ) )
   {
      pBuffer = (char *) GlobalAlloc( GPTR, numpapers * 64 );
      nBuffer = (char *) GlobalAlloc( GPTR, numpapers * sizeof( WORD ) );
      sBuffer = (char *) GlobalAlloc( GPTR, numpapers * sizeof( POINT ) );
      cBuffer = (char *) GlobalAlloc( GPTR, numpapers * 128 );
      DeviceCapabilities( pi2->pPrinterName, pi2->pPortName, DC_PAPERNAMES, pBuffer, pi2->pDevMode );
      DeviceCapabilities( pi2->pPrinterName, pi2->pPortName, DC_PAPERS, nBuffer, pi2->pDevMode );
      DeviceCapabilities( pi2->pPrinterName, pi2->pPortName, DC_PAPERSIZE, sBuffer, pi2->pDevMode );
      cBuffer[ 0 ] = 0;
      for( i = 0; i < numpapers; i++ )
      {
         strcat( cBuffer, pBuffer );
         strcat( cBuffer, "," );
         strcat( cBuffer, itoa( *nBuffer, buffer, 10 ) );
         strcat( cBuffer, "," );

         lp = ( LPPOINT ) sBuffer;
         strcat( cBuffer, ltoa( lp->x, buffer, 10 ) );
         strcat( cBuffer, "," );
         strcat( cBuffer, ltoa( lp->y, buffer, 10 ) );
         if( i < numpapers - 1 )
         {
            strcat(cBuffer,",,");
         }
         pBuffer += 64;
         nBuffer += sizeof( WORD );
         sBuffer += sizeof( POINT );
      }

      hb_storc( cBuffer, 1 );

      GlobalFree( cBuffer );
      GlobalFree( pBuffer );
      GlobalFree( nBuffer );
      GlobalFree( sBuffer );
   }
   else
   {
      hb_storc( "", 1 );
   }

   if( numbins != ( DWORD ) 0 && numbins != ( DWORD ) ( ~0 ) )
   {
      bnBuffer = (char *) GlobalAlloc(GPTR,numbins*24);
      bwBuffer = (char *) GlobalAlloc(GPTR,numbins*sizeof(WORD));
      bcBuffer = (char *) GlobalAlloc(GPTR,numbins*64);
      DeviceCapabilities( pi2->pPrinterName, pi2->pPortName, DC_BINNAMES, bnBuffer, pi2->pDevMode );
      DeviceCapabilities( pi2->pPrinterName, pi2->pPortName, DC_BINS, bwBuffer, pi2->pDevMode );
      bcBuffer[ 0 ] = 0;
      for( i = 0; i < numbins; i++ )
      {
         strcat( bcBuffer, bnBuffer );
         strcat( bcBuffer, "," );
         strcat( bcBuffer, itoa( *bwBuffer, buffer, 10 ) );

         if( i < numbins - 1 )
         {
            strcat( bcBuffer, ",," );
         }
         bnBuffer += 24;
         bwBuffer += sizeof( WORD );
      }

      hb_storc( bcBuffer, 2 );

      GlobalFree( bnBuffer );
      GlobalFree( bwBuffer );
      GlobalFree( bcBuffer );
   }
   else
   {
      hb_storc( "", 2 );
   }
}

HB_FUNC (RR_SETPOLYFILLMODE)
{
   if (SetPolyFillMode( hDC ,(COLORREF) hb_parnl(1)) != 0)
      hb_retnl(hb_parnl(1));
   else
      hb_retnl((LONG)GetPolyFillMode(hDC));
}

HB_FUNC (RR_SETTEXTCOLOR)
{
   if (SetTextColor( hDC ,(COLORREF) hb_parnl(1)) != CLR_INVALID)
      hb_retnl(hb_parnl(1));
   else
      hb_retnl((LONG)GetTextColor(hDC));
}

HB_FUNC (RR_SETBKCOLOR)
{
   if (SetBkColor( hDC ,(COLORREF) hb_parnl(1)) != CLR_INVALID)
      hb_retnl(hb_parnl(1));
   else
      hb_retnl((LONG)GetBkColor(hDC));
}
HB_FUNC (RR_SETBKMODE)
{
   if (hb_parni(1) == 1)
       SetBkMode( hDC, TRANSPARENT);
   else
       SetBkMode( hDC, OPAQUE);
}

HB_FUNC (RR_DELETEOBJECTS)
{
 UINT i;
 for(i = 2; i <= hb_parinfa(1,0); i++)
    DeleteObject((HGDIOBJ) HB_PARNL( 1, i ));
}
HB_FUNC (RR_DELETEIMAGELISTS)
{
 UINT i;
 for(i = 1; i <= hb_parinfa(1,0); i++)
    ImageList_Destroy((HIMAGELIST) HB_PARNL3( 1, i, 1));
}

/*
HB_FUNC (RR_DELETEMFILES)
{
 UINT i;
 for(i = 1; i <= hb_parinfa(1,0); i++)
    DeleteEnhMetaFile((HENHMETAFILE) HB_PARNL3( 1, i, 1 ));
 for(i = 1; i <= 15 ; i++)
   if (hbmp[i]!=NULL)
      DeleteObject(hbmp[i]);
}
*/

HB_FUNC (RR_SAVEMETAFILE)
{
   CopyEnhMetaFile((HENHMETAFILE) hb_parnl(1),hb_parc(2));
}

HB_FUNC (RR_GETCURRENTOBJECT)
{
 int what = hb_parni(1);
 HGDIOBJ hand;
 if (what==1)
      hand=GetCurrentObject(hDC,OBJ_FONT);
  else if (what==2)
      hand=GetCurrentObject(hDC,OBJ_BRUSH);
  else
      hand=GetCurrentObject(hDC,OBJ_PEN);
  hb_retnl((LONG) hand);
}

HB_FUNC (RR_GETSTOCKOBJECT)
{
  hb_retnl((LONG) GetStockObject(hb_parni(1)));
}

HB_FUNC (RR_CREATEPEN)
{
  hb_retnl((LONG) CreatePen(hb_parni(1),hb_parni(2),(COLORREF) hb_parnl(3)));
}

HB_FUNC (RR_MODIFYPEN)
{
  LOGPEN ppn;
  int i;
  HPEN hp;
  memset(&ppn,0,sizeof(LOGPEN));
  i=GetObject((HPEN) hb_parnl(1),sizeof(LOGPEN),&ppn);
  if (i>0)
    {
     if (hb_parni(2)>=0) ppn.lopnStyle =(UINT) hb_parni(2);
     if (hb_parnl(3)>=0) ppn.lopnWidth.x = hb_parnl(3);
     if (hb_parnl(4)>=0) ppn.lopnColor=(COLORREF) hb_parnl(4);
     hp = CreatePenIndirect(&ppn);
     if (hp != NULL)
        {
         DeleteObject((HPEN) hb_parnl(1));
         hb_retnl((LONG) hp);
        }
     else
        hb_retnl((LONG) hb_parnl(1));
    }
  else
     hb_retnl((LONG) hb_parnl(1));
}

HB_FUNC (RR_SELECTPEN)
{
   SelectObject(hDC,(HPEN) hb_parnl(1));
   hpen=(HPEN) hb_parnl(1);
}
HB_FUNC (RR_CREATEBRUSH)
{
  LOGBRUSH pbr;
  pbr.lbStyle=hb_parni(1);
  pbr.lbColor=(COLORREF) hb_parnl(2);
  pbr.lbHatch=(LONG) hb_parnl(3);
  hb_retnl((LONG)CreateBrushIndirect(&pbr));
}
HB_FUNC (RR_MODIFYBRUSH)
{
  LOGBRUSH ppn;
  int i;
  HBRUSH hb;
  memset(&ppn,0,sizeof(LOGBRUSH));
  i=GetObject((HBRUSH) hb_parnl(1),sizeof(LOGBRUSH),&ppn);
  if (i>0)
    {
     if (hb_parni(2)>=0) ppn.lbStyle =(UINT) hb_parni(2);
     if (hb_parnl(3)>=0) ppn.lbColor=(COLORREF) hb_parnl(3);
     if (hb_parnl(4)>=0) ppn.lbHatch = hb_parnl(4);
     hb = CreateBrushIndirect(&ppn);
     if (hb!=NULL)
        {
          DeleteObject((HBRUSH) hb_parnl(1));
          hb_retnl((LONG) hb);
        }
     else
          hb_retnl((LONG) hb_parnl(1));
    }
  else
     hb_retnl((LONG) hb_parnl(1));
}

HB_FUNC (RR_SELECTBRUSH)
{
   SelectObject(hDC,(HBRUSH) hb_parnl(1));
   hbrush=(HBRUSH) hb_parnl(1);
}

HB_FUNC (RR_CREATEFONT)
{
     char *FontName= ( char * ) hb_parc(1);
     int FontSize=hb_parni(2);
     LONG FontWidth=hb_parnl(3);
     LONG Orient=hb_parnl(4);
     LONG Weight=hb_parnl(5);
     int Italic= hb_parni(6);
     int Underline= hb_parni(7);
     int Strikeout= hb_parni(8);
     HFONT oldfont , hxfont ;
     LONG newWidth , FontHeight ;
     TEXTMETRIC tm ;
     BYTE bItalic,bUnderline,bStrikeOut;

     newWidth=(LONG) FontWidth ;
        if (FontSize <= 0) { FontSize = 10 ;}
        if (FontWidth<0)   { newWidth = 0;}
        if (Orient<=0)      { Orient = 0;}
        if (Weight<=0)      Weight=FW_NORMAL;
        else                Weight=FW_BOLD;
        if (Italic<=0)       bItalic=0;
        else                 bItalic=1;
        if (Underline<=0)    bUnderline=0;
        else                 bUnderline=1;
        if (Strikeout<=0)    bStrikeOut=0;
        else                 bStrikeOut=1;

        FontHeight = -MulDiv(FontSize , GetDeviceCaps (hDCRef, LOGPIXELSY ),72) ;
        hxfont = CreateFont (FontHeight, newWidth,Orient,Orient,Weight,bItalic,
                             bUnderline,bStrikeOut,charset,
                                OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS,
                                DEFAULT_QUALITY, FF_DONTCARE, FontName) ;
        if (FontWidth<0)
                {
                 oldfont = (HFONT) SelectObject(hDC,hxfont);
                 GetTextMetrics(hDC,&tm);
                 SelectObject(hDC,oldfont);
                 DeleteObject(hxfont);
                 newWidth=(int) ((float) -(tm.tmAveCharWidth+tm.tmOverhang)*FontWidth/100);
                 hxfont = CreateFont (FontHeight, newWidth,Orient,Orient,Weight,
                                     bItalic,bUnderline,bStrikeOut,charset,
                                     OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS,
                                     DEFAULT_QUALITY, FF_DONTCARE, FontName) ;
               }
        hb_retnl((LONG) hxfont);
}

HB_FUNC (RR_MODIFYFONT)
{
  LOGFONT ppn;
  int i;
  HFONT hf;
  LONG nHeight ;
  memset(&ppn,0,sizeof(LOGFONT));
  i=GetObject((HFONT) hb_parnl(1),sizeof(LOGFONT),&ppn);
  if (i>0)
    {
//     if (hb_parc(2)!="")
//       ppn.lfFaceName = hb_parc(2);
     if (hb_parni(3)>0)
         {
           nHeight = -MulDiv(hb_parni(3), GetDeviceCaps(hDC, LOGPIXELSY), 72);
           ppn.lfHeight =nHeight;
         }
     if (hb_parnl(4)>=0) ppn.lfWidth = (LONG) hb_parnl(4)*ppn.lfWidth/100;
     if (hb_parnl(5)>=0)
        {
          ppn.lfOrientation = hb_parnl(5);
          ppn.lfEscapement  = hb_parnl(5);
        }
     if (hb_parnl(6)>=0)
         if (hb_parnl(6)==0) ppn.lfWeight = FW_NORMAL;
         if (hb_parnl(6)>0) ppn.lfWeight =  FW_BOLD;
     if (hb_parni(7)>=0) ppn.lfItalic = (BYTE) hb_parni(7);
     if (hb_parni(8)>=0) ppn.lfUnderline = (BYTE) hb_parni(8);
     if (hb_parni(9)>=0) ppn.lfStrikeOut = (BYTE) hb_parni(9);

     hf = CreateFontIndirect(&ppn);
     if (hf!=NULL)
        {
          DeleteObject((HFONT) hb_parnl(1));
          hb_retnl((LONG) hf);
        }
     else
          hb_retnl((LONG) hb_parnl(1));
    }
  else
     hb_retnl((LONG) hb_parnl(1));
}


HB_FUNC (RR_SELECTFONT)
{
   SelectObject(hDC,(HFONT) hb_parnl(1));
   hfont=(HFONT) hb_parnl(1);
}

HB_FUNC (RR_SETCHARSET)
{
   charset = (DWORD) hb_parnl(1);
}

HB_FUNC (RR_TEXTOUT)
{
   LONG xfont=hb_parnl(3);
   HFONT prevfont;
   SIZE szMetric;
   int lspace = hb_parni(4);

   if (xfont!=0)  prevfont = (HFONT) SelectObject(hDC ,(HFONT) xfont);
   if (textjust>0)
       {
         GetTextExtentPoint32(hDC, hb_parc(1), hb_parclen(1), &szMetric);
         if (szMetric.cx<textjust)   // or can be for better look (szMetric.cx>(int) textjust*2/3)
               if (lspace>0)
                 {
                  SetTextJustification(hDC,(int) textjust-szMetric.cx,lspace);
                 }
       }
   hb_retl(TextOut( hDC , HB_PARNI( 2, 2 ), HB_PARNI( 2, 1 ) + devcaps[16], hb_parc(1),hb_parclen(1)));
   if (xfont!=0)     SelectObject(hDC,prevfont);
   if (textjust>0)  SetTextJustification (hDC, 0, 0) ;
}

HB_FUNC( RR_DRAWTEXT )
{
   LONG  xfont = hb_parnl( 5 );
   HFONT prevfont;
   RECT  rect;
   UINT  uFormat;

   SIZE  sSize;
   const char  *pszData = hb_parc(3);
   int   iLen = strlen(pszData);
   int   iStyle = hb_parni(4);
   LONG  w, h;

   SetRect( &rect, HB_PARNL(1, 2), HB_PARNL(1, 1), HB_PARNL(2, 2), HB_PARNL(2, 1) );

   if( xfont != 0 )
   {
      prevfont = ( HFONT ) SelectObject( hDC, (HFONT) xfont );
   }

   GetTextExtentPoint32( hDC, pszData, iLen , &sSize );
   w = (LONG) sSize.cx; // text width
   h = (LONG) sSize.cy; // text height

   // Center text vertically within rectangle
   if( w < rect.right - rect.left )
   {
      rect.top = rect.top + ( rect.bottom - rect.top + h / 2 ) / 2 ;
   }
   else
   {
      rect.top = rect.top + ( rect.bottom - rect.top - h / 2 ) / 2 ;
   }

   uFormat = DT_NOCLIP | DT_NOPREFIX | DT_WORDBREAK | DT_END_ELLIPSIS ;

   if( iStyle == 0 )
   {
      uFormat = uFormat | DT_LEFT ;
   }
   else if ( iStyle == 2 )
   {
      uFormat = uFormat | DT_RIGHT ;
   }
   else if ( iStyle == 1 )
   {
      uFormat = uFormat | DT_CENTER ;
   }

   hb_retni( DrawText( hDC, pszData, -1, &rect, uFormat ) );
   if( xfont != 0 )
   {
      SelectObject( hDC, prevfont );
   }
}


HB_FUNC (RR_RECTANGLE)
{
 LONG xpen  = hb_parnl(3);
 LONG xbrush= hb_parnl(4);
   if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);
   if (xbrush!=0) SelectObject(hDC ,(HBRUSH) xbrush);
   hb_retni(Rectangle(hDC,HB_PARNL(1,2),HB_PARNL(1,1),HB_PARNL(2,2),HB_PARNL(2,1)));
   if (xpen!=0) SelectObject(hDC ,hpen);
   if (xbrush!=0) SelectObject(hDC ,hbrush);
}

HB_FUNC (RR_CLOSEMFILE)
{
 UINT size;
 HENHMETAFILE hh;
 char *eBuffer;
 LPENHMETAHEADER eHeader;
 hh=CloseEnhMetaFile(hDC);
 size=GetEnhMetaFileBits(hh,0,NULL);
 eBuffer = (char *) GlobalAlloc(GPTR, (DWORD) size);
 GetEnhMetaFileBits(hh,size, ( BYTE * ) eBuffer);
 eHeader=(LPENHMETAHEADER) eBuffer;
      eHeader->szlDevice.cx=devcaps[4];
      eHeader->szlDevice.cy=devcaps[3];
      eHeader->szlMillimeters.cx=devcaps[2];
      eHeader->szlMillimeters.cy=devcaps[1];

 hb_retclen(eBuffer,(ULONG) size);
 DeleteEnhMetaFile(hh);
 GlobalFree(eBuffer);
}

HB_FUNC (RR_CLOSEFILE)
{
 	DeleteEnhMetaFile(CloseEnhMetaFile( hDC ));
}


HB_FUNC (RR_CREATEMFILE)
{
  RECT emfrect;
    SetRect(&emfrect,0,0,GetDeviceCaps(hDCRef, HORZSIZE)*100,GetDeviceCaps(hDCRef, VERTSIZE)*100);
    hDC=CreateEnhMetaFile(hDCRef,NULL,&emfrect,"hbprinter\0emf file\0\0");
    SetTextAlign(hDC,TA_BASELINE);
    preview=1;
    hb_retnl((LONG) hDC);
}

HB_FUNC (RR_CREATEFILE)
{
  RECT emfrect;
    SetRect(&emfrect,0,0,GetDeviceCaps(hDCRef, HORZSIZE)*100,GetDeviceCaps(hDCRef, VERTSIZE)*100);
    hDC=CreateEnhMetaFile(hDCRef,hb_parc(1),&emfrect,"hbprinter\0emf file\0\0");
    SetTextAlign(hDC,TA_BASELINE);
    preview=1;
    hb_retnl((LONG) hDC);
}

HB_FUNC (RR_DELETECLIPRGN)
{
  SelectClipRgn(hDC,NULL);
}

HB_FUNC (RR_CREATERGN)
{
  POINT lpp;
  GetViewportOrgEx(hDC,&lpp);
  if (hb_parni(3)==2)
     hb_retnl((LONG) CreateEllipticRgn(HB_PARNI(1,2)+lpp.x, HB_PARNI(1,1)+lpp.y,HB_PARNI(2,2)+lpp.x, HB_PARNI(2,1)+lpp.y));
  else if (hb_parni(3)==3)
     hb_retnl((LONG) CreateRoundRectRgn(HB_PARNI(1,2)+lpp.x, HB_PARNI(1,1)+lpp.y,HB_PARNI(2,2)+lpp.x, HB_PARNI(2,1)+lpp.y,HB_PARNI(4,2)+lpp.x, HB_PARNI(4,1)+lpp.y));
  else
     hb_retnl((LONG) CreateRectRgn(HB_PARNI(1,2)+lpp.x, HB_PARNI(1,1)+lpp.y,HB_PARNI(2,2)+lpp.x, HB_PARNI(2,1)+lpp.y));
}

HB_FUNC (RR_CREATEPOLYGONRGN)
{
 int number=hb_parinfa(1,0);
 int i;
 POINT apoints[1024];
 for(i = 0; i <= number-1; i++)
  {
   apoints[i].x=HB_PARNI(1,i+1);
   apoints[i].y=HB_PARNI(2,i+1);
  }
  hb_retnl((LONG) CreatePolygonRgn(apoints,number,hb_parni(3)));
}



HB_FUNC (RR_COMBINERGN)
{
  HRGN rgnnew=CreateRectRgn(0,0,1,1);
  CombineRgn(rgnnew,(HRGN) hb_parnl(1),(HRGN) hb_parnl(2),hb_parni(3));
  hb_retnl((LONG) rgnnew);
}

HB_FUNC (RR_SELECTCLIPRGN)
{
  SelectClipRgn(hDC,(HRGN) hb_parnl(1));
  hrgn=(HRGN) hb_parnl(1);
}
HB_FUNC (RR_SETVIEWPORTORG)
{
   hb_retl(SetViewportOrgEx(hDC,HB_PARNI(1,2), HB_PARNI(1,1),NULL));
}

HB_FUNC (RR_GETVIEWPORTORG)
{
   POINT lpp;
   hb_retl(GetViewportOrgEx(hDC,&lpp));
   HB_STORNL(lpp.x,1,2);
   HB_STORNL(lpp.y,1,1);
}
HB_FUNC (RR_SETRGB)
{
   hb_retnl(RGB(hb_parni(1),hb_parni(2),hb_parni(3)));
}

HB_FUNC (RR_SETTEXTCHAREXTRA)
{
   hb_retni(SetTextCharacterExtra(hDC,hb_parni(1)));
}

HB_FUNC (RR_GETTEXTCHAREXTRA)
{
   hb_retni(GetTextCharacterExtra(hDC));
}

HB_FUNC (RR_SETTEXTJUSTIFICATION)
{
   textjust=hb_parni(1);
}
HB_FUNC (RR_GETTEXTJUSTIFICATION)
{
   hb_retni(textjust);
}

HB_FUNC (RR_GETTEXTALIGN)
{
  hb_retni(GetTextAlign(hDC));
}

HB_FUNC (RR_SETTEXTALIGN)
{
  hb_retni(SetTextAlign(hDC,TA_BASELINE|hb_parni(1)));
}

HB_FUNC (RR_PICTURE)
{
    IStream *iStream;
    IPicture *iPicture;
    HGLOBAL hGlobal;
    void *pGlobal;
    HANDLE hFile;
    DWORD nFileSize;
    DWORD nReadByte;
    long lWidth,lHeight;
    int x,y,xe,ye;
    int r = HB_PARNI(2,1);
    int c = HB_PARNI(2,2);
    int dr = HB_PARNI(3,1);
    int dc = HB_PARNI(3,2);
    int tor = HB_PARNI(4,1);
    int toc = HB_PARNI(4,2);
    HRGN hrgn1;
    POINT lpp;


    hFile = CreateFile(hb_parc(1), GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
        return;
    nFileSize = GetFileSize(hFile, NULL);
    hGlobal = GlobalAlloc(GMEM_MOVEABLE, nFileSize);
    pGlobal = GlobalLock(hGlobal);
    ReadFile(hFile, pGlobal, nFileSize, &nReadByte, NULL);
    CloseHandle(hFile);
    GlobalUnlock(hGlobal);
    CreateStreamOnHGlobal(hGlobal, TRUE, &iStream);
    OleLoadPicture(iStream, nFileSize, TRUE, &IID_IPicture, (LPVOID*)&iPicture);
    GlobalFree(hGlobal);
    iStream->lpVtbl->Release(iStream);
    if (iPicture==NULL)
         {
           return;
         }
    iPicture->lpVtbl->get_Width(iPicture,&lWidth);
    iPicture->lpVtbl->get_Height(iPicture,&lHeight);
  if (dc==0)  { dc=(int) ((float) dr*lWidth/lHeight); }
  if (dr==0)  { dr=(int) ((float) dc*lHeight/lWidth); }
  if (tor<=0) { tor=dr;}
  if (toc<=0) { toc=dc;}
  x=c;
  y=r;
  xe=c+toc-1;
  ye=r+tor-1;
  GetViewportOrgEx(hDC,&lpp);
  hrgn1 = CreateRectRgn(c+lpp.x,r+lpp.y,xe+lpp.x,ye+lpp.y);
  if (hrgn==NULL) SelectClipRgn(hDC,hrgn1);
  else ExtSelectClipRgn(hDC,hrgn1,RGN_AND);
  while (x<xe)
   {  while (y<ye)
      {
        iPicture->lpVtbl->  Render(iPicture,hDC,x,y,dc,dr, 0, lHeight, lWidth, -lHeight, NULL);
        y+=dr;
      }
     y=r;
     x+=dc;
   }
  iPicture->lpVtbl->Release(iPicture);
  SelectClipRgn(hDC,hrgn);
  DeleteObject(hrgn1);
  hb_retni(0);

}

void rr_showerror(char * abc)
{
   LPVOID lpMsgBuf;
   DWORD dwError  = GetLastError();
   FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
      NULL,dwError,MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),(LPTSTR) &lpMsgBuf,
      0,NULL);
   MessageBox(NULL, (LPCSTR)lpMsgBuf, abc, MB_OK | MB_ICONEXCLAMATION);
   LocalFree( lpMsgBuf );
}

LPVOID rr_loadpicturefromresource(char * resname,LONG *lwidth,LONG *lheight)
{
   HBITMAP hbmpx;
   IPicture *iPicture = NULL ;
   IStream *iStream = NULL;
   PICTDESC picd;
   HGLOBAL hGlobalres ;
   HGLOBAL hGlobal;
   HRSRC hSource ;
   LPVOID lpVoid ;
   HINSTANCE hinstance=GetModuleHandle(NULL);
   int nSize ;

   hbmpx = (HBITMAP) LoadImage(GetModuleHandle(NULL),resname,IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION);
   if( hbmpx != NULL )
   {
      picd.cbSizeofstruct=sizeof(PICTDESC);
      picd.picType=PICTYPE_BITMAP;
      picd.bmp.hbitmap=hbmpx;
      OleCreatePictureIndirect(&picd,&IID_IPicture,TRUE,(LPVOID *)&iPicture);
   }
   else
   {
      hSource = FindResource( hinstance, resname, "HMGPICTURE" );
      if( ! hSource )
      {
         hSource = FindResource( hinstance, resname, "JPG" );
         if( ! hSource )
         {
            hSource = FindResource( hinstance, resname, "JPEG" );
            if( ! hSource )
            {
               hSource = FindResource( hinstance, resname, "GIF" );
               if( ! hSource )
               {
                  hSource = FindResource( hinstance, resname, "BMP" );
                  if( ! hSource )
                  {
                     hSource = FindResource( hinstance, resname, "BITMAP" );
                     if( ! hSource )
                     {
                        return NULL;
                     }
                  }
               }
            }
         }
      }
      hGlobalres = LoadResource( hinstance, hSource );
      if( hGlobalres == NULL )
      {
         return NULL;
      }
      lpVoid = LockResource( hGlobalres );
      if( lpVoid == NULL )
      {
         return NULL;
      }
      nSize = SizeofResource(hinstance, hSource);
      hGlobal=GlobalAlloc(GPTR, nSize);
      if( hGlobal == NULL )
      {
         return NULL;
      }
      memcpy(hGlobal,lpVoid, nSize);
      FreeResource(hGlobalres);
      CreateStreamOnHGlobal(hGlobal, TRUE, &iStream);
      if( iStream == NULL )
      {
         GlobalFree( hGlobal );
         return NULL;
      }
      OleLoadPicture(iStream, nSize, TRUE, &IID_IPicture, (LPVOID *)&iPicture);
      iStream->lpVtbl->Release( iStream );
      GlobalFree(hGlobal);
   }
   if( iPicture != NULL )
   {
      iPicture->lpVtbl->get_Width( iPicture,  lwidth );
      iPicture->lpVtbl->get_Height( iPicture, lheight );
   }
   return iPicture;
}

LPVOID rr_loadpicture( char * filename, LONG * lwidth, LONG * lheight )
{
    IStream *iStream=NULL ;
    IPicture *iPicture=NULL;
    HGLOBAL hGlobal;
    void *pGlobal;
    HANDLE hFile;
    DWORD nFileSize,nReadByte;
//    int lw,lh;
    hFile = CreateFile(filename, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
        return NULL;
    nFileSize = GetFileSize(hFile, NULL);
    hGlobal = GlobalAlloc(GMEM_MOVEABLE, nFileSize+4096);
    pGlobal = GlobalLock(hGlobal);
    ReadFile(hFile, pGlobal, nFileSize, &nReadByte, NULL);
    CloseHandle(hFile);
    CreateStreamOnHGlobal(hGlobal, TRUE, &iStream);
    if (iStream==NULL)
       {
          GlobalUnlock(hGlobal);
          GlobalFree(hGlobal);
          return NULL;
       }
    OleLoadPicture(iStream, nFileSize, TRUE, &IID_IPicture, (LPVOID*)&iPicture);
    GlobalUnlock(hGlobal);
    GlobalFree(hGlobal);
    iStream->lpVtbl->Release(iStream);
    iStream=NULL;
    if (iPicture!=NULL)
       {
          iPicture->lpVtbl->get_Width(iPicture ,lwidth);
          iPicture->lpVtbl->get_Height(iPicture,lheight);
       }
    return iPicture;
}

HB_FUNC( RR_DRAWPICTURE )
{
    IPicture *ipic;
    int x,y,xe,ye;
    int r = HB_PARNI(2,1);
    int c = HB_PARNI(2,2);
    int dr = HB_PARNI(3,1);
    int dc = HB_PARNI(3,2);
    int tor = HB_PARNI(4,1);
    int toc = HB_PARNI(4,2);
    long lwidth=0;
    long lheight=0;
    RECT lrect;
    HRGN hrgn1;
    POINT lpp;
    int lw,lh;
    BOOL bImageSize = hb_parl( 5 );

   if( hb_parclen( 1 ) )
   {
      ipic = (IPicture *) rr_loadpicture( ( char * ) hb_parc( 1 ), &lwidth, &lheight );
      if( ! ipic )
      {
         ipic = (IPicture *) rr_loadpicturefromresource( ( char * ) hb_parc( 1 ), &lwidth, &lheight );
      }
      if( ! ipic )
      {
         return ;
      }
   }
  lw=MulDiv(lwidth,devcaps[6],2540);
  lh=MulDiv(lheight,devcaps[5],2540);
  if (dc==0)  { dc=(int) ((float) dr*lw/lh); }
  if (dr==0)  { dr=(int) ((float) dc*lh/lw); }
  if( bImageSize )
  {
     dr = lh;
     dc = lw;
  }
  if (tor<=0) { tor=dr;}
  if (toc<=0) { toc=dc;}
  if( bImageSize )
  {
     tor = lh;
     toc = lw;
  }
  x=c;
  y=r;
  xe=c+toc-1;
  ye=r+tor-1;
  GetViewportOrgEx(hDC,&lpp);
  hrgn1 = CreateRectRgn(c+lpp.x,r+lpp.y,xe+lpp.x,ye+lpp.y);
  if (hrgn==NULL) SelectClipRgn(hDC,hrgn1);
  else ExtSelectClipRgn(hDC,hrgn1,RGN_AND);
  while (x<xe)
   {  while (y<ye)
      {
        SetRect(&lrect,x,y,dc+x,dr+y);
        ipic->lpVtbl->Render(ipic,hDC,x,y,dc,dr, 0, lheight, lwidth, -lheight, &lrect);
        y+=dr;
      }
     y=r;
     x+=dc;
   }
  ipic->lpVtbl->Release(ipic);
  SelectClipRgn(hDC,hrgn);
  DeleteObject(hrgn1);
  hb_retni(0);
}



HB_FUNC (RR_CREATEIMAGELIST)
{
 HBITMAP hbmpx ;
 BITMAP  bm;
 HIMAGELIST himl;
 int dx,number;

 hbmpx = (HBITMAP)LoadImage(0,hb_parc(1),IMAGE_BITMAP,0,0,LR_LOADFROMFILE|LR_CREATEDIBSECTION);
 if (hbmpx==NULL)
       hbmpx = (HBITMAP)LoadImage(GetModuleHandle(NULL),hb_parc(1),IMAGE_BITMAP,0,0,LR_CREATEDIBSECTION);
 if (hbmpx==NULL)
     return ;
 GetObject(hbmpx,sizeof(BITMAP),&bm);
 number=hb_parni(2);
 if (number==0)
    {
      number = (int) bm.bmWidth/bm.bmHeight;
      dx = bm.bmHeight;
    }
 else
      dx = (int) bm.bmWidth/number;
 himl = ImageList_Create(dx,bm.bmHeight,ILC_COLOR24|ILC_MASK,number,0);
 ImageList_AddMasked(himl,hbmpx,CLR_DEFAULT);
 HB_STORNI2(dx,3);
 HB_STORNI2(bm.bmHeight,4);
 DeleteObject(hbmpx);
 hb_retnl((LONG) himl);
}


HB_FUNC (RR_DRAWIMAGELIST)
{
 HIMAGELIST himl=(HIMAGELIST)hb_parnl(1);
 HDC tempdc,temp2dc;
 HBITMAP hbmpx;
 RECT rect;
 HWND hwnd=GetActiveWindow();
 rect.left=HB_PARNI(3,2);
 rect.top=HB_PARNI(3,1);
 rect.right=HB_PARNI(4,2);
 rect.bottom=HB_PARNI(4,1);
 temp2dc=GetWindowDC(hwnd);
 tempdc=CreateCompatibleDC(temp2dc);
 hbmpx=CreateCompatibleBitmap(temp2dc,hb_parni(5),hb_parni(6));
 ReleaseDC(hwnd,temp2dc);
 SelectObject(tempdc,hbmpx);
 BitBlt(tempdc,0,0,hb_parni(5),hb_parni(6),tempdc,0,0,WHITENESS);
 if (hb_parnl(8)>=0)
    ImageList_SetBkColor(himl, (COLORREF) hb_parnl(8));
 ImageList_Draw(himl,hb_parni(2)-1,tempdc,0,0,hb_parni(7));
 if (hb_parnl(8)>=0)
    ImageList_SetBkColor(himl, CLR_NONE);
 hb_retl(StretchBlt(hDC,rect.left,rect.top,rect.right,rect.bottom,tempdc,0,0,hb_parni(5),hb_parni(6),SRCCOPY));
 DeleteDC(tempdc);
 DeleteObject(hbmpx);
}



HB_FUNC (RR_POLYGON)
{
 int number=hb_parinfa(1,0);
 int i;
 int styl=GetPolyFillMode(hDC);
 POINT apoints[1024];
 LONG xpen  =hb_parnl(3);
 LONG xbrush=hb_parnl(4);

 for(i = 0; i <= number-1; i++)
  {
   apoints[i].x=HB_PARNI(1,i+1);
   apoints[i].y=HB_PARNI(2,i+1);
  }
  if (xpen!=0)   SelectObject(hDC ,(HPEN) xpen);
  if (xbrush!=0) SelectObject(hDC ,(HBRUSH) xbrush);
  SetPolyFillMode(hDC,hb_parni(5));

  hb_retnl((LONG) Polygon(hDC,apoints,number));

  if (xpen!=0) SelectObject(hDC , hpen);
  if (xbrush!=0) SelectObject(hDC , hbrush);
  SetPolyFillMode(hDC,styl);
}

HB_FUNC (RR_POLYBEZIER)
{
 DWORD number=(DWORD) hb_parinfa(1,0);
 DWORD i;
 POINT apoints[1024];
 LONG xpen  =hb_parnl(3);

 for(i = 0; i <= number-1; i++)
  {
   apoints[i].x=HB_PARNI(1,i+1);
   apoints[i].y=HB_PARNI(2,i+1);
  }
  if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);

  hb_retnl((LONG) PolyBezier(hDC,apoints,number));

  if (xpen!=0) SelectObject(hDC , hpen);
}

HB_FUNC (RR_POLYBEZIERTO)
{
 DWORD number=(DWORD) hb_parinfa(1,0);
 DWORD i;
 POINT apoints[1024];
 LONG xpen  =hb_parnl(3);

 for(i = 0; i <= number-1; i++)
  {
   apoints[i].x=HB_PARNI(1,i+1);
   apoints[i].y=HB_PARNI(2,i+1);
  }
  if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);

  hb_retnl((LONG) PolyBezierTo(hDC,apoints,number));

  if (xpen!=0) SelectObject(hDC , hpen);
}


HB_FUNC (RR_GETTEXTEXTENT)
{
  LONG xfont =hb_parnl(3);
  SIZE szMetric;

  if (xfont!=0) SelectObject(hDC ,(HPEN) xfont);
  hb_retni(GetTextExtentPoint32(hDC, hb_parc(1), hb_parclen(1), &szMetric));
  HB_STORNI(szMetric.cy,2,1);
  HB_STORNI(szMetric.cx,2,2);
  if (xfont!=0) SelectObject(hDC , hfont);

}

HB_FUNC (RR_ROUNDRECT)
{
 LONG xpen  =hb_parnl(3);
 LONG xbrush=hb_parnl(4);
 if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);
 if (xbrush!=0) SelectObject(hDC ,(HBRUSH) xbrush);

 hb_retni(RoundRect(hDC,HB_PARNI(1,2),HB_PARNI(1,1),HB_PARNI(2,2),HB_PARNI(2,1),HB_PARNI(3,2),HB_PARNI(3,1)));

 if (xbrush!=0) SelectObject(hDC ,(HBRUSH) hbrush);
 if (xpen!=0) SelectObject(hDC ,(HPEN) hpen);


}

HB_FUNC (RR_ELLIPSE)
{
 LONG xpen  =hb_parnl(3);
 LONG xbrush=hb_parnl(4);
 if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);
 if (xbrush!=0) SelectObject(hDC ,(HBRUSH) xbrush);

 hb_retni(Ellipse(hDC,HB_PARNI(1,2),HB_PARNI(1,1),HB_PARNI(2,2),HB_PARNI(2,1)));

 if (xpen!=0) SelectObject(hDC , hpen);
 if (xbrush!=0) SelectObject(hDC , hbrush);
}

HB_FUNC (RR_CHORD)
{
 LONG xpen  =hb_parnl(5);
 LONG xbrush=hb_parnl(6);
 if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);
 if (xbrush!=0) SelectObject(hDC ,(HBRUSH) xbrush);

 hb_retni(Chord(hDC,HB_PARNI(1,2),HB_PARNI(1,1),HB_PARNI(2,2),HB_PARNI(2,1),HB_PARNI(3,2),HB_PARNI(3,1),HB_PARNI(4,2),HB_PARNI(4,1)));

 if (xpen!=0) SelectObject(hDC , hpen);
 if (xbrush!=0) SelectObject(hDC , hbrush);
}
HB_FUNC (RR_ARCTO)
{
 LONG xpen  =hb_parnl(5);
 if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);

 hb_retni(ArcTo(hDC,HB_PARNI(1,2),HB_PARNI(1,1),HB_PARNI(2,2),HB_PARNI(2,1),HB_PARNI(3,2),HB_PARNI(3,1),HB_PARNI(4,2),HB_PARNI(4,1)));

 if (xpen!=0) SelectObject(hDC , hpen);
}

HB_FUNC (RR_ARC)
{
 LONG xpen  =hb_parnl(5);
 if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);

 hb_retni(Arc(hDC,HB_PARNI(1,2),HB_PARNI(1,1),HB_PARNI(2,2),HB_PARNI(2,1),HB_PARNI(3,2),HB_PARNI(3,1),HB_PARNI(4,2),HB_PARNI(4,1)));

 if (xpen!=0) SelectObject(hDC , hpen);
}

HB_FUNC (RR_PIE)
{
 LONG xpen  =hb_parnl(5);
 LONG xbrush=hb_parnl(6);
 if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);
 if (xbrush!=0) SelectObject(hDC ,(HBRUSH) xbrush);

 hb_retni(Pie(hDC,HB_PARNI(1,2),HB_PARNI(1,1),HB_PARNI(2,2),HB_PARNI(2,1),HB_PARNI(3,2),HB_PARNI(3,1),HB_PARNI(4,2),HB_PARNI(4,1)));

 if (xpen!=0) SelectObject(hDC , hpen);
 if (xbrush!=0) SelectObject(hDC , hbrush);
}

HB_FUNC (RR_FILLRECT)
{
 RECT rect;
 rect.left=HB_PARNI(1,2);
 rect.top=HB_PARNI(1,1);
 rect.right=HB_PARNI(2,2);
 rect.bottom=HB_PARNI(2,1);
 hb_retni(FillRect(hDC, &rect, (HBRUSH) hb_parnl(3)));
}

HB_FUNC (RR_FRAMERECT)
{
 RECT rect;
 rect.left=HB_PARNI(1,2);
 rect.top=HB_PARNI(1,1);
 rect.right=HB_PARNI(2,2);
 rect.bottom=HB_PARNI(2,1);
 hb_retni(FrameRect(hDC , &rect,(HBRUSH) hb_parnl(3)));
}

HB_FUNC (RR_LINE)
{
 LONG xpen  =hb_parnl(3);
 if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);
 MoveToEx(hDC,HB_PARNI(1,2),HB_PARNI(1,1),NULL);
    hb_retni(LineTo(hDC,HB_PARNI(2,2),HB_PARNI(2,1)));
 if (xpen!=0) SelectObject(hDC ,hpen);
}

HB_FUNC (RR_LINETO)
{
 LONG xpen  =hb_parnl(2);
 if (xpen!=0) SelectObject(hDC ,(HPEN) xpen);
    hb_retni(LineTo(hDC,HB_PARNI(1,2),HB_PARNI(1,1)));
 if (xpen!=0) SelectObject(hDC ,hpen);
}

HB_FUNC (RR_INVERTRECT)
{
 RECT rect;
 rect.left=HB_PARNI(1,2);
 rect.top=HB_PARNI(1,1);
 rect.right=HB_PARNI(2,2);
 rect.bottom=HB_PARNI(2,1);
 hb_retni(InvertRect(hDC, &rect));
}

HB_FUNC (RR_GETWINDOWRECT)
{
  RECT rect;
  HWND hwnd=(HWND) HB_PARNL(1,7);
  if (hwnd==0)
      hwnd= GetDesktopWindow();
  GetWindowRect(hwnd,&rect);
  HB_STORNI(rect.top,1,1);
  HB_STORNI(rect.left,1,2);
  HB_STORNI(rect.bottom,1,3);
  HB_STORNI(rect.right,1,4);
  HB_STORNI(rect.bottom-rect.top+1,1,5);
  HB_STORNI(rect.right-rect.left+1,1,6);
}

HB_FUNC (RR_GETCLIENTRECT)
{
  RECT rect;
  GetClientRect((HWND) HB_PARNL(1,7),&rect);
  HB_STORNI(rect.top,1,1);
  HB_STORNI(rect.left,1,2);
  HB_STORNI(rect.bottom,1,3);
  HB_STORNI(rect.right,1,4);
  HB_STORNI(rect.bottom-rect.top+1,1,5);
  HB_STORNI(rect.right-rect.left+1,1,6);
}

HB_FUNC (RR_SCROLLWINDOW)
{
 ScrollWindow((HWND) hb_parnl(1), hb_parni(2),hb_parni(3),NULL,NULL);
}

HB_FUNC (RR_PREVIEWPLAY)
{
        RECT rect;
        HDC imgDC = GetWindowDC((HWND) hb_parnl(1));
        HDC tmpDC = CreateCompatibleDC(imgDC);
        HENHMETAFILE hh=SetEnhMetaFileBits((UINT) HB_PARCLEN(2,1), ( BYTE * ) HB_PARC(2,1));
        HBITMAP himgbmp;
        if (tmpDC==NULL)
           {
              ReleaseDC((HWND) hb_parnl(1),imgDC);
              hb_retnl( 0 );
           }
        SetRect(&rect ,0,0,HB_PARNL(3,4),HB_PARNL(3,3));
        himgbmp=CreateCompatibleBitmap(imgDC,rect.right,rect.bottom);
        SelectObject(tmpDC,(HBITMAP) himgbmp);
        FillRect(tmpDC,&rect,(HBRUSH) GetStockObject(WHITE_BRUSH));
        PlayEnhMetaFile(tmpDC,hh,&rect);
        DeleteEnhMetaFile(hh);
        ReleaseDC((HWND) hb_parnl(1),imgDC);
        DeleteDC(tmpDC);
        hb_retnl( ( long ) himgbmp );
}

HB_FUNC (RR_PREVIEWFPLAY)
{
        RECT rect;
        HDC imgDC = GetWindowDC((HWND) hb_parnl(1));
        HDC tmpDC = CreateCompatibleDC(imgDC);
        HENHMETAFILE hh= GetEnhMetaFile( hb_parc(2) ) ;
		//SetEnhMetaFileBits((UINT) HB_PARCLEN(2,1), ( BYTE * ) HB_PARC(2,1));
        HBITMAP himgbmp;
        if (tmpDC==NULL)
           {
              ReleaseDC((HWND) hb_parnl(1),imgDC);
              hb_retnl( 0 );
           }
        SetRect(&rect ,0,0,HB_PARNL(3,4),HB_PARNL(3,3));
        himgbmp=CreateCompatibleBitmap(imgDC,rect.right,rect.bottom);
        SelectObject(tmpDC,(HBITMAP) himgbmp);
        FillRect(tmpDC,&rect,(HBRUSH) GetStockObject(WHITE_BRUSH));
        PlayEnhMetaFile(tmpDC,hh,&rect);
        DeleteEnhMetaFile(hh);
        ReleaseDC((HWND) hb_parnl(1),imgDC);
        DeleteDC(tmpDC);
        hb_retnl( ( long ) himgbmp );
}


HB_FUNC (RR_PLAYTHUMB)
{
   RECT rect;
   HDC tmpDC;
   HDC imgDC=GetWindowDC((HWND) HB_PARNL(1,5));
   HENHMETAFILE hh=SetEnhMetaFileBits((UINT) HB_PARCLEN(2,1), ( BYTE * ) HB_PARC(2,1));
   int i;
   i= hb_parni(4)-1;
   tmpDC=CreateCompatibleDC(imgDC);
   SetRect(&rect,0,0,HB_PARNI(1,4),HB_PARNI(1,3));
   hbmp[i]=CreateCompatibleBitmap(imgDC,rect.right,rect.bottom);
   DeleteObject(SelectObject(tmpDC,hbmp[i]));
   FillRect(tmpDC,&rect,(HBRUSH) GetStockObject(WHITE_BRUSH));
   PlayEnhMetaFile(tmpDC ,hh,&rect);
   DeleteEnhMetaFile(hh);
   TextOut(tmpDC,(int)rect.right/2-5,(int)rect.bottom/2-5,hb_parc(3),hb_parclen(3));
   SendMessage((HWND) HB_PARNL (1,5),(UINT)STM_SETIMAGE,(WPARAM)IMAGE_BITMAP,(LPARAM) hbmp[i]);
   ReleaseDC((HWND) HB_PARNL(1,5),imgDC);
   DeleteDC(tmpDC);
}

HB_FUNC (RR_PLAYFTHUMB)
{
   RECT rect;
   HDC tmpDC;
   HDC imgDC=GetWindowDC((HWND) HB_PARNL(1,5));
   HENHMETAFILE hh= GetEnhMetaFile( HB_PARC(2,1) ) ;
   //SetEnhMetaFileBits((UINT) HB_PARCLEN(2,1), ( BYTE * ) HB_PARC(2,1));
   int i;
   i= hb_parni(4)-1;
   tmpDC=CreateCompatibleDC(imgDC);
   SetRect(&rect,0,0,HB_PARNI(1,4),HB_PARNI(1,3));
   hbmp[i]=CreateCompatibleBitmap(imgDC,rect.right,rect.bottom);
   DeleteObject(SelectObject(tmpDC,hbmp[i]));
   FillRect(tmpDC,&rect,(HBRUSH) GetStockObject(WHITE_BRUSH));
   PlayEnhMetaFile(tmpDC ,hh,&rect);
   DeleteEnhMetaFile(hh);
   TextOut(tmpDC,(int)rect.right/2-5,(int)rect.bottom/2-5,hb_parc(3),hb_parclen(3));
   SendMessage((HWND) HB_PARNL (1,5),(UINT)STM_SETIMAGE,(WPARAM)IMAGE_BITMAP,(LPARAM) hbmp[i]);
   ReleaseDC((HWND) HB_PARNL(1,5),imgDC);
   DeleteDC(tmpDC);
}


HB_FUNC (RR_PLAYENHMETAFILE)
{
   RECT rect;
   HENHMETAFILE hh=SetEnhMetaFileBits((UINT) HB_PARCLEN(1,1), ( BYTE * ) HB_PARC(1,1));
   SetRect(&rect,0,0,HB_PARNL(1,5),HB_PARNL(1,4));
   PlayEnhMetaFile((HDC) hb_parnl(2),hh,&rect);
   DeleteEnhMetaFile(hh);
}

HB_FUNC (RR_PLAYFENHMETAFILE)
{
   RECT rect;
   HENHMETAFILE hh = GetEnhMetaFile( HB_PARC(1,1) ) ;
   // hh=SetEnhMetaFileBits((UINT) HB_PARCLEN(1,1), ( BYTE * ) HB_PARC(1,1));
   SetRect(&rect,0,0,HB_PARNL(1,5),HB_PARNL(1,4));
   PlayEnhMetaFile((HDC) hb_parnl(2),hh,&rect);
   DeleteEnhMetaFile(hh);
}



HB_FUNC (RR_LALABYE)
{
   if (hb_parni(1)==1)
     {
       hDCtemp=hDC;
       hDC=hDCRef;
     }
   else
       hDC=hDCtemp;
}



HB_FUNC( RR_LOADSTRING )
{
  char *cBuffer;
  cBuffer = (char *) GlobalAlloc(GPTR,255);
  LoadString(GetModuleHandle(NULL),hb_parni(1),(LPSTR) cBuffer,254);
  hb_retc(cBuffer);
  GlobalFree(cBuffer);
}

#pragma ENDDUMP
