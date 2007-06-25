/*
 * $Id: i_media.ch,v 1.3 2007-06-25 04:35:57 guerra000 Exp $
 */
/*
 * ooHG source code:
 * Multimedia definitions
 *
 * Copyright 2005 Vicente Guerra <vicente@guerra.com.mx>
 * www - http://www.guerra.com.mx
 *
 * Portions of this code are copyrighted by the Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the ooHG Project gives permission for
 * additional uses of the text contained in its release of ooHG.
 *
 * The exception is that, if you link the ooHG libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the ooHG library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the ooHG
 * Project under the name ooHG. If you copy code from other
 * ooHG Project or Free Software Foundation releases into a copy of
 * ooHG, as the General Public License permits, the exception does
 * not apply to the code that you add in this way. To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for ooHG, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------------
 MINIGUI - Harbour Win32 GUI library source code

 Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 http://www.geocities.com/harbour_minigui/

 This program is free software; you can redistribute it and/or modify it under
 the terms of the GNU General Public License as published by the Free Software
 Foundation; either version 2 of the License, or (at your option) any later
 version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License along with
 this software; see the file COPYING. If not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
 visit the web site http://www.gnu.org/).

 As a special exception, you have permission for additional uses of the text
 contained in this release of Harbour Minigui.

 The exception is that, if you link the Harbour Minigui library with other
 files to produce an executable, this does not by itself cause the resulting
 executable to be covered by the GNU General Public License.
 Your use of that executable is in no way restricted on account of linking the
 Harbour-Minigui library code into it.

 Parts of this project are based upon:

        "Harbour GUI framework for Win32"
        Copyright 2001 Alexander S.Kresin <alex@belacy.belgorod.su>
        Copyright 2001 Antonio Linares <alinares@fivetech.com>
        www - http://www.harbour-project.org

        "Harbour Project"
        Copyright 1999-2003, http://www.harbour-project.org/
---------------------------------------------------------------------------*/

///////////////////////////////////////////////////////////////////////////////
// ANIMATEBOX COMMANDS
///////////////////////////////////////////////////////////////////////////////
#command @ <row>,<col>  ANIMATEBOX <name> ;
                        [ OBJ <obj> ]                   ;
			[ <dummy1: OF, PARENT> <parent> ] ;
			WIDTH <w> ;
			HEIGHT <h> ;
			[ FILE <file> ] ;
			[ <autoplay: AUTOPLAY> ] ;
			[ <center : CENTER> ] ;
			[ <transparent: TRANSPARENT> ] ;
			[ HELPID <helpid> ] 		;
                        [ SUBCLASS <subclass> ]         ;
			[ <invisible: INVISIBLE> ]	;
			[ <notabstop: NOTABSTOP> ]	;
                        [ <disabled: DISABLED> ]        ;
                        [ <rtl: RTL> ]                  ;
	=>;
        [ <obj> := ] _OOHG_SelectSubClass( TAnimateBox(), [ <subclass>() ] ): ;
        Define( <(name)>, <(parent)>, <col>, <row>, <w>, <h>, <.autoplay.>, <.center.>, <.transparent.>, <file>, <helpid>, ;
                <.invisible.>, <.notabstop.>, <.disabled.>, <.rtl.> )

#command OPEN ANIMATEBOX <ControlName> OF <ParentForm> FILE <FileName> ;
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Open( <FileName> )

#command PLAY ANIMATEBOX <ControlName> OF <ParentForm> ;
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Play()

#command SEEK ANIMATEBOX <ControlName> OF <ParentForm> POSITION <frame> ;
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Seek( <frame> )

#command STOP ANIMATEBOX <ControlName> OF <ParentForm> ;
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Stop()

#command CLOSE ANIMATEBOX <ControlName> OF <ParentForm> ;
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Close()

#command DESTROY ANIMATEBOX <ControlName> OF <ParentForm> ;
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Release()

#translate  OpenAnimateBox ( <ControlName> , <ParentForm> , <FileName> );
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Open( <FileName> )

#translate  PlayAnimateBox ( <ControlName> , <ParentForm> );
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Play()

#translate  SeekAnimateBox ( <ControlName> , <ParentForm> , <frame> );
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Seek( <frame> )

#translate StopAnimateBox ( <ControlName> , <ParentForm> );
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Stop()

#translate CloseAnimateBox ( <ControlName> , <ParentForm> ) ;
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Close()

#translate DestroyAnimateBox ( <ControlName> , <ParentForm> );
=> ;
GetControlObject( <(ControlName)> , <(ParentForm)> ):Release()

//////////////////////////////////////////////////////////////////////////////
// PLAYER COMMANDS
/////////////////////////////////////////////////////////////////////////////
#command @ <row>,<col>  PLAYER <name> ;
                        [ OBJ <obj> ]                   ;
			[ <dummy1: OF, PARENT> <parent> ] ;
                        [ WIDTH <w> ] ;
                        [ HEIGHT <h> ] ;
                        [ FILE <file> ] ;
			[ <noautosizewindow: NOAUTOSIZEWINDOW> ] ;
			[ <noautosizemovie : NOAUTOSIZEMOVIE> ] ;
			[ <noerrordlg: NOERRORDLG> ] ;
			[ <nomenu: NOMENU> ] ;
			[ <noopen: NOOPEN> ] ;
			[ <noplaybar: NOPLAYBAR> ] ;
			[ <showall: SHOWALL> ] ;
			[ <showmode: SHOWMODE> ] ;
			[ <showname: SHOWNAME> ] ;
			[ <showposition: SHOWPOSITION> ] ;
			[ HELPID <helpid> ] 		;
                        [ SUBCLASS <subclass> ]         ;
			[ <invisible: INVISIBLE> ]	;
			[ <notabstop: NOTABSTOP> ]	;
                        [ <disabled: DISABLED> ]        ;
                        [ <rtl: RTL> ]                  ;
	=>;
        [ <obj> := ] _OOHG_SelectSubClass( TPlayer(), [ <subclass>() ] ): ;
        Define( <(name)>, <(parent)>, <file>, <col>, <row>, <w>, <h>, <.noautosizewindow.>, <.noautosizemovie.>, ;
                <.noerrordlg.>, <.nomenu.>, <.noopen.>, <.noplaybar.>, <.showall.>, <.showmode.>, <.showname.>, ;
                <.showposition.>, <helpid>, <.invisible.>, <.notabstop.>, <.disabled.>, <.rtl.> )

#command PLAY PLAYER <name> OF <parent> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Play()

#xcommand PLAY PLAYER <name> OF <parent> REVERSE ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):PlayReverse()

#command STOP PLAYER <name> OF <parent> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Stop()

#command PAUSE PLAYER <name> OF <parent> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Pause()

#command CLOSE PLAYER <name> OF <parent> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Close()

#command DESTROY PLAYER <name> OF <parent> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Release()

#command EJECT PLAYER <name> OF <parent> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Eject()

#command OPEN PLAYER <name> OF <parent> FILE <file> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Open( <file> )

#command OPEN PLAYER <name> OF <parent> DIALOG ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):OpenDialog()

#command RESUME PLAYER <name> OF <parent> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Resume()

#command SET PLAYER <name> OF <parent> POSITION HOME ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):PositionHome()

#command SET PLAYER <name> OF <parent> POSITION END ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):PositionEnd()

#command SET PLAYER <name> OF <parent> REPEAT ON ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):RepeatOn()

#command SET PLAYER <name> OF <parent> REPEAT OFF ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):RepeatOff()

#command SET PLAYER <name> OF <parent> SPEED <speed> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Speed( <speed> )

#command SET PLAYER <name> OF <parent> VOLUME <volume> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Volume( <volume> )

#command SET PLAYER <name> OF <parent> ZOOM <zoom> ;
	=> ;
        GetControlObject( <(name)> , <(parent)> ):Zoom( <zoom> )

///////////////////////////////////////////////////////////////////////////////
// WAVE COMMANDS
//////////////////////////////////////////////////////////////////////////////
#command PLAY WAVE  <wave>  [<r:  FROM RESOURCE>] ;
                            [<s:  SYNC>];
                            [<ns: NOSTOP>] ;
                            [<l:  LOOP>] ;
                            [<nd: NODEFAULT>] ;
	=> playwave(<wave>,<.r.>,<.s.>,<.ns.>,<.l.>,<.nd.>)

#command STOP WAVE  => stopwave()
#command STOP WAVE NODEFAULT => stopwave()
