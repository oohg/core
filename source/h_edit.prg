/*
 * $Id: h_edit.prg,v 1.26 2017-08-25 19:42:18 fyurisich Exp $
 */
/*
 * ooHG source code:
 * EDIT WORKAREA command
 *
 * Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
 * https://sourceforge.net/projects/oohg/
 *
 * Portions of this project are based upon Harbour MiniGUI library.
 * Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
 *
 * Portions of this project are based upon Harbour GUI framework for Win32.
 * Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
 * Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *
 * Portions of this project are based upon Harbour Project.
 * Copyright 1999-2017, https://harbour.github.io/
 */
/*
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
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
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
 */


/*
 * - Descripción -
 * ===============
 *      EDIT WORKAREA, es un comando que permite realizar altas, bajas y modificaciones
 *      sobre una base de datos.
 *
 * - Sintáxis -
 * ============
 *      Todos los parámetros del comando EDIT WORKAREA son opcionales, con excepción del área de trabajo.
 *
 *      EDIT WORKAREA cArea      ;
 *       [ TITLE cTitulo ]       ;
 *       [ FIELDS aCampos ]      ;
 *       [ READONLY aEditables ] ;
 *       [ SAVE bGuardar ]       ;
 *       [ SEARCH bBuscar ]
 *
 *      Ver detalle de parámetros en función ABM().
 *
 *
 * - Historial -
 * =============
 *              Mar 03  - Definición de la función.
 *                      - Pruebas.
 *                      - Soporte para lenguaje en inglés.
 *                      - Corregido bug al borrar en bdds con CDX.
 *                      - Mejora del control de parámetros.
 *                      - Mejorada la función de soprte de busqueda.
 *                      - Soprte para multilenguaje.
 *              Abr 03  - Corregido bug en la función de busqueda (Nombre del botón).
 *                      - Añadido soporte para lenguaje Ruso (Grigory Filiatov).
 *                      - Añadido soporte para lenguaje Catalán.
 *                      - Añadido soporte para lenguaje Portugués (Clovis Nogueira Jr).
 *			- Añadido soporte para lenguaja Polaco 852 (Janusz Poura).
 *			- Añadido soporte para lenguaje Francés (C. Jouniauxdiv).
 *              May 03  - Añadido soporte para lenguaje Italiano (Lupano Piero).
 *                      - Añadido soporte para lenguaje Alemán (Janusz Poura).
 *
 */


#include "oohg.ch"
#include "winprint.ch"

// Modos.
#define ABM_MODO_VER            1
#define ABM_MODO_EDITAR         2

// Eventos de la ventana principal.
#define ABM_EVENTO_SALIR        1
#define ABM_EVENTO_NUEVO        2
#define ABM_EVENTO_EDITAR       3
#define ABM_EVENTO_BORRAR       4
#define ABM_EVENTO_BUSCAR       5
#define ABM_EVENTO_IR           6
#define ABM_EVENTO_LISTADO      7
#define ABM_EVENTO_PRIMERO      8
#define ABM_EVENTO_ANTERIOR     9
#define ABM_EVENTO_SIGUIENTE   10
#define ABM_EVENTO_ULTIMO      11
#define ABM_EVENTO_GUARDAR     12
#define ABM_EVENTO_CANCELAR    13

// Eventos de la ventana de definición de listados.
#define ABM_LISTADO_CERRAR      1
#define ABM_LISTADO_MAS         2
#define ABM_LISTADO_MENOS       3
#define ABM_LISTADO_IMPRIMIR    4


/*
 * ABM()
 *
 * Descipción:
 *      ABM es una función para la realización de altas, bajas y modificaciones
 *      sobre una base de datos dada (el nombre del area). Esta función esta basada
 *      en la libreria GUI para [x]Harbour/W32 de Roberto López, MiniGUI.
 *
 * Limitaciones:
 *      - El tamaño de la ventana de dialogo es de 640 x 480 pixels.
 *      - No puede manejar bases de datos de más de 16 campos.
 *      - El tamaño máximo de las etiquetas de los campos es de 70 pixels.
 *      - El tamaño máximo de los controles de edición es de 160 pixels.
 *      - Si no se especifica función de busqueda, esta se realiza por el
 *        indice activo (si existe) y solo en campos tipo carácter y fecha.
 *        El indice activo tiene que tener el mismo nombre que el campo por
 *        el que va indexada la base de datos.
 *      - Los campos Memo deben ir al final de la base de datos.
 *
 * Sintaxis:
 *      ABM( cArea, [cTitulo], [aCampos], [aEditables], [bGuardar], [bBuscar] )
 *              cArea      Cadena de texto con el nombre del area de la base de
 *                         datos a tratar.
 *              cTitulo    Cadena de texto con el nombre de la ventana, se le añade
 *                         "Listado de " como título de los listados. Por defecto se
 *                         toma el nombre del area de la base de datos.
 *              aCampos    Matriz de cadenas de texto con los nombres desciptivos
 *                         de los campos de la base de datos. Tiene que tener el mismo
 *                         numero de elementos que campos hay en la base de datos.
 *                         Por defecto se toman los nombres de los campos de la
 *                         estructura de la base de datos.
 *              aEditables Array de valores lógicos qie indican si un campo es editable.
 *                         Normalmente se utiliza cuando se usan campos calculados y se
 *                         pasa el bloque de código para el evento de guardar registro.
 *                         Tiene que tener el mismo numero de elementos que campos hay en
 *                         la estructura de la base de datos. Por defecto es una matriz
 *                         con todos los valores verdaderos (.t.).
 *              bGuardar   Bloque de codigo al que se le pasa uan matriz con los
 *                         valores a guardar/editar y una variable lógica que indica
 *                         si se esta editando (.t.) o añadiendo (.f.). El bloque de código
 *                         tendrá la siguiente forma {|p1, p2| MiFuncion( p1, p2 ) }, donde
 *                         p1 será un array con los valores para cada campo y p2 sera el
 *                         valor lógico que indica el estado. Por defecto se guarda usando
 *                         el código interno de la función. Tras la operación se realiza un
 *                         refresco del cuadro de dialogo. La función debe devolver un valor
 *                         .f. si no se quiere salir del modo de edición o cualquier otro
 *                         si se desea salir. Esto es util a la hora de comprobar los valores
 *                         a añadir a la base de datos.
 *              bBuscar    Bloque de código para la función de busqueda. Por defecto se usa
 *                         el código interno que solo permite la busqueda por el campo
 *                         indexado actual, y solo si es de tipo caracter o fecha.
 *
*/



// Declaración de variables globales.
static _cArea          := ""                            // Nombre del area.
static _aEstructura    := {}                            // Estructura de la bdd.
static _cTitulo        := ""                            // Titulo de la ventana.
static _aCampos        := {}                            // Nombre de los campos.
static _aEditables     := {}                            // Controles editables.
static _bGuardar       := {|| NIL }                     // Bloque para la accion guardar.
static _bBuscar        := {|| NIL }                     // Bloque para la acción buscar.
static _OOHG_aControles     := {}                            // Controles de edición.
static _aBotones       := {}                            // Controles BUTTON.
static _lEditar        := .t.                           // Modo.
static _aCamposListado := {}                            // Campos del listado.
static _aAnchoCampo    := {}                            // Ancho campos listado.
static _aNumeroCampo   := {}                            // Numero de campo del listado.



 /***************************************************************************************
 *     Función: ABM( cArea, [cTitulo], [aCampos], [aEditables], [bGuardar], [bBuscar] )
 *       Autor: Cristóbal Mollá.
 * Descripción: Crea un dialogo de altas, bajas y modificaciones a partir
 *              de la estructura del area de datos pasada.
 *  Parámetros: cArea        Cadena de texto con el nombre del area de la BDD.
 *              [cTitulo]    Cadena de texto con el título de la ventana.
 *              [aCampos]    Array con cadenas de texto para las etiquetas de los campos.
 *              [aEditables] Array de valores lógicos que indican si el campo es editable.
 *              [bGuardar]   Bloque de codigo para la acción de guardar registro.
 *              [bBuscar]    Bloque de código para la acción de buscar registro.
 *    Devuelve: NIL
 ****************************************************************************************/
function ABM( cArea, cTitulo, aCampos, aEditables, bGuardar, bBuscar )

// Declaración de variables locales.-------------------------------------------
local nArea             // := 0                         // Area anterior.
local nRegistro         // := 0                         // Numero de registro anterior.
// local cMensaje          := ""                        // Mensajes al usuario.
local nCampos              := 0                         // Numero de campos de la base.
local nItem             // := 1                         // Indice de iteración.
local nFila             // := 20                        // Fila de creación del control.
local nColumna          // := 20                        // Columna de creación de control.
local aEtiquetas        // := {}                        // Array con los controles LABEL.
local aBrwCampos        // := {}                        // Títulos de columna del BROWSE.
local aBrwAnchos        // := {}                        // Anchos de columna del BROWSE.
local nBrwAnchoCampo    // := 0                         // Ancho del campo para el browse.
local nBrwAnchoRegistro // := 0                         // Ancho del registro para el browse.
local cMascara             := ""                        // Mascara de datos para el TEXTBOX.
local nMascaraTotal     // := 0                         // Tamaño de la máscara de edición.
local nMascaraDecimales // := 0                         // Tamaño de los decimales.
Local _BackDeleted

// Inicializa el soporte multilenguaje.----------------------------------------
InitMessages()
IF EMPTY( DATE() )
   EMPTY( _OOHG_AllVars )
   EMPTY( HBPRN )
ENDIF

////////// Gusrdar estado actual de SET DELETED y activarlo
        _BackDeleted := set( _SET_DELETED )
        SET DELETED ON

// Control de parámetros.
// Area de la base de datos.---------------------------------------------------
if ( ! VALTYPE( cArea ) $"CM" ) .or. Empty( cArea )
        MsgOOHGError( _OOHG_Messages( 8, 1 ), "" )
else
        _cArea       := cArea
        _aEstructura := (_cArea)->( dbStruct() )
        nCampos      := Len( _aEstructura )
endif

// Numero de campos.-----------------------------------------------------------
if ( nCampos > 16 )
        MsgOOHGError( _OOHG_Messages( 8, 2 ), "" )
endif

// Titulo de la ventana.-------------------------------------------------------
if ( ! VALTYPE( cTitulo ) $ "CM" ) .or. Empty( cTitulo )
        _cTitulo := cArea
else
        _cTitulo := cTitulo
endif

// Nombre de los campos.-------------------------------------------------------
_aCampos := Array( nCampos )
if ( !HB_IsArray( aCampos ) ) .or. ( Len( aCampos ) != nCampos )
        _aCampos   := Array( nCampos )
        for nItem := 1 to nCampos
                _aCampos[nItem] := Lower( _aEstructura[nItem,1] )
        next
else
        for nItem := 1 to nCampos
                if ! (VALTYPE( aCampos[nItem] )  $ "CM" )
                        _aCampos[nItem] := Lower( _aEstructura[nItem,1] )
                else
                        _aCampos[nItem] := aCampos[nItem]
                endif
        next
endif

// Array de controles editables.-----------------------------------------------
_aEditables := Array( nCampos )
if ( !HB_IsArray( aEditables ) ) .or. ( Len( aEditables ) != nCampos )
        _aEditables := Array( nCampos )
        for nItem := 1 to nCampos
                _aEditables[nItem] := .t.
        next
else
        for nItem := 1 to nCampos
                if !HB_IsLogical( aEditables[nItem] )
                        _aEditables[nItem] := .t.
                else
                        _aEditables[nItem] := aEditables[nItem]
                endif
        next
endif

// Bloque de codigo de la acción guardar.--------------------------------------
if !HB_IsBlock( bGuardar )
        _bGuardar := NIL
else
        _bGuardar := bGuardar
endif

// Bloque de código de la acción buscar.---------------------------------------
if !HB_IsBlock( bBuscar )
        _bBuscar := NIL
else
        _bBuscar := bBuscar
endif

// Inicialización de variables.------------------------------------------------
aEtiquetas  := Array( nCampos, 3 )
aBrwCampos  := Array( nCampos )
aBrwAnchos  := Array( nCampos )
_OOHG_aControles := Array( nCampos, 3)

// Propiedades de las etiquetas.-----------------------------------------------
nFila    := 20
nColumna := 20
for nItem := 1 to nCampos
        aEtiquetas[nItem,1] := "lbl" + "Etiqueta" + AllTrim( Str( nItem ,4,0 ) )
        aEtiquetas[nItem,2] := nFila
        aEtiquetas[nItem,3] := nColumna
        nFila += 25
        if nFila >= 200
                nFila    := 20
                nColumna := 270
        endif
next

// Propiedades del browse.-----------------------------------------------------
for nItem := 1 to nCampos
        aBrwCampos[nItem] := cArea + "->" + _aEstructura[nItem,1]
        nBrwAnchoRegistro := _aEstructura[nItem,3] * 10
        nBrwAnchoCampo    := Len( _aCampos[nItem] ) * 10
        nBrwAnchoCampo    := iif( nBrwanchoCampo >= nBrwAnchoRegistro, nBrwanchoCampo, nBrwAnchoRegistro )
        aBrwAnchos[nItem] := nBrwAnchoCampo
next

// Propiedades de los controles de edición.------------------------------------
nFila    := 20
nColumna := 20
for nItem := 1 to nCampos
        do case
                case _aEstructura[nItem,2] == "C"        // Campo tipo caracter.
                        _OOHG_aControles[nItem,1] := "txt" + "Control" + AllTrim( Str( nItem ,4,0) )
                        _OOHG_aControles[nItem,2] := nFila
                        _OOHG_aControles[nItem,3] := nColumna + 80
                case _aEstructura[nItem,2] == "N"        // Campo tipo numerico.
                        _OOHG_aControles[nItem,1] := "txn" + "Control" + AllTrim( Str( nItem ,4,0) )
                        _OOHG_aControles[nItem,2] := nFila
                        _OOHG_aControles[nItem,3] := nColumna + 80
                case _aEstructura[nItem,2] == "D"        // Campo tipo fecha.
                        _OOHG_aControles[nItem,1] := "dat" + "Control" + AllTrim( Str( nItem ,4,0) )
                        _OOHG_aControles[nItem,2] := nFila
                        _OOHG_aControles[nItem,3] := nColumna + 80
                case _aEstructura[nItem,2] == "L"        // Campo tipo lógico.
                        _OOHG_aControles[nItem,1] := "chk" + "Control" + AllTrim( Str( nItem ,4,0) )
                        _OOHG_aControles[nItem,2] := nFila
                        _OOHG_aControles[nItem,3] := nColumna + 80
                case _aEstructura[nItem,2] == "M"        // Campo tipo memo.
                        _OOHG_aControles[nItem,1] := "edt" + "Control" + AllTrim( Str( nItem ,4,0) )
                        _OOHG_aControles[nItem,2] := nFila
                        _OOHG_aControles[nItem,3] := nColumna + 80
                        nFila += 25
        endcase
        nFila += 25
        if nFila >= 200
                nFila    := 20
                nColumna := 270
        endif
next

// Propiedades de los botones.-------------------------------------------------
_aBotones := { "btnCerrar", "btnNuevo", "btnEditar", ;
              "btnBorrar", "btnBuscar", "btnIr",;
              "btnListado","btnPrimero", "btnAnterior",;
              "btnSiguiente", "btnUltimo", "btnGuardar",;
              "btnCancelar" }

// Defincinión de la ventana de edición.---------------------------------------
define window wndABM ;
       at     0, 0 ;
       width  640 ;
       height 480 ;
       title  _cTitulo ;
       modal ;
       nosysmenu ;
       font "Serif" ;
       size 8 ;
       on init ABMRefresh( ABM_MODO_VER ) ;
       backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )
end window

// Defincición del frame.------------------------------------------------------
@  10,  10 frame frmFrame1 of wndABM width 510 height 290

// Defincición de las etiquetas.-----------------------------------------------
for nItem := 1 to nCampos

        @ aEtiquetas[nItem,2], aEtiquetas[nItem,3] label &( aEtiquetas[nItem,1] ) ;
                of     wndABM ;
                value  _aCampos[nItem] ;
                width  70 ;
                height 21 ;
                font   "ms sans serif" ;
                size   8
next

@ 310, 535 label  lblLabel1 ;
           of     wndABM ;
           value  _OOHG_Messages( 6, 1 ) ;
           width  85 ;
           height 20 ;
           font   "ms sans serif" ;
           size   8
@ 330, 535 label  lblRegistro ;
           of     wndABM ;
           value  "9999" ;
           width  85 ;
           height 20 ;
           font   "ms sans serif" ;
           size   8
@ 350, 535 label  lblLabel2 ;
           of     wndABM ;
           value  _OOHG_Messages( 6, 2 ) ;
           width  85 ;
           height 20 ;
           font   "ms sans serif" ;
           size   8
@ 370, 535 label  lblTotales ;
           of     wndABM ;
           value  "9999" ;
           width  85 ;
           height 20 ;
           font   "ms sans serif" ;
           size   8

// Defincición del browse.-----------------------------------------------------
@ 310, 10 browse brwBrowse ;
        of wndABM ;
        width    510 ;
        height   125 ;
        headers  _aCampos ;
        widths   aBrwAnchos ;
        workarea &_cArea ;
        fields   aBrwCampos ;
        value    (_cArea)->( RecNo() ) ;
        ON DBLCLICK ABMEventos( ABM_EVENTO_EDITAR ) ;        
        on change {|| (_cArea)->( dbGoTo( wndABM.brwBrowse.Value ) ), ABMRefresh( ABM_MODO_VER ) }

// Definición de los botones.--------------------------------------------------
@ 400, 535 button btnCerrar ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 1 ) ;
        action  ABMEventos( ABM_EVENTO_SALIR ) ;
        width   85 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8
@ 20, 535 button btnNuevo ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 2 ) ;
        action  ABMEventos( ABM_EVENTO_NUEVO ) ;
        width   85 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 65, 535 button btnEditar ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 3 ) ;
        action  ABMEventos( ABM_EVENTO_EDITAR ) ;
        width   85 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 110, 535 button btnBorrar ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 4 ) ;
        action  ABMEventos( ABM_EVENTO_BORRAR ) ;
        width   85 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 155, 535 button btnBuscar ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 5 ) ;
        action  ABMEventos( ABM_EVENTO_BUSCAR ) ;
        width   85 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 200, 535 button btnIr ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 6 ) ;
        action  ABMEventos( ABM_EVENTO_IR ) ;
        width   85 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 245, 535 button btnListado ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 7 ) ;
        action  ABMEventos( ABM_EVENTO_LISTADO ) ;
        width   85 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 260, 20 button btnPrimero ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 8 ) ;
        action  ABMEventos( ABM_EVENTO_PRIMERO ) ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 260, 100 button btnAnterior ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 9 ) ;
        action  ABMEventos( ABM_EVENTO_ANTERIOR ) ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 260, 180 button btnSiguiente ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 10 ) ;
        action  ABMEventos( ABM_EVENTO_SIGUIENTE ) ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 260, 260 button btnUltimo ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 11 ) ;
        action  ABMEventos( ABM_EVENTO_ULTIMO ) ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 260, 355 button btnGuardar ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 12 ) ;
        action  ABMEventos( ABM_EVENTO_GUARDAR ) ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8
@ 260, 435 button btnCancelar ;
        of      wndABM ;
        caption _OOHG_Messages( 7, 13 ) ;
        action  ABMEventos( ABM_EVENTO_CANCELAR ) ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8

// Defincición de los controles de edición.------------------------------------
for nItem := 1 to nCampos
        do case
                case _aEstructura[nItem,2] == "C"        // Campo tipo caracter.

                        @ _OOHG_aControles[nItem,2], _OOHG_aControles[nItem,3] textbox &( _OOHG_aControles[nItem,1] ) ;
                                of      wndABM ;
                                height  21 ;
                                value   "" ;
                                width   iif( (_aEstructura[nItem,3] * 10)>160, 160, _aEstructura[nItem,3] * 10 ) ;
                                font    "Arial" ;
                                size    9 ;
                                maxlength _aEstructura[nItem,3]

                case _aEstructura[nItem,2] == "N"        // Campo tipo numerico
                        if _aEstructura[nItem,4] == 0

                                @ _OOHG_aControles[nItem,2], _OOHG_aControles[nItem,3] textbox &( _OOHG_aControles[nItem,1] ) ;
                                        of      wndABM ;
                                        height  21 ;
                                        value   0 ;
                                        width   iif( (_aEstructura[nItem,3] * 10)>160, 160, _aEstructura[nItem,3] * 10 ) ;
                                        numeric ;
                                        maxlength _aEstructura[nItem,3] ;
                                        font "Arial" ;
                                        size 9
                        else
                                nMascaraTotal     := _aEstructura[nItem,3]
                                nMascaraDecimales := _aEstructura[nItem,4]
                                cMascara := Replicate( "9", nMascaraTotal - (nMascaraDecimales + 1) )
                                cMascara += "."
                                cMascara += Replicate( "9", nMascaraDecimales )

                                @ _OOHG_aControles[nItem,2], _OOHG_aControles[nItem,3] textbox &( _OOHG_aControles[nItem,1] ) ;
                                        of      wndABM ;
                                        height  21 ;
                                        value   0 ;
                                        width   iif( (_aEstructura[nItem,3] * 10)>160, 160, _aEstructura[nItem,3] * 10 ) ;
                                        numeric ;
                                        inputmask cMascara
                        endif
                case _aEstructura[nItem,2] == "D"        // Campo tipo fecha.

                        @ _OOHG_aControles[nItem,2], _OOHG_aControles[nItem,3] datepicker &( _OOHG_aControles[nItem,1] ) ;
                                of      wndABM ;
                                value   Date() ;
                                width   100 ;
                                font    "Arial" ;
                                size    9

                        wndABM.&( _OOHG_aControles[nItem,1] ).Height := 21


        case _aEstructura[nItem,2] == "L"        // Campo tipo logico.

                        @ _OOHG_aControles[nItem,2], _OOHG_aControles[nItem,3] checkbox &( _OOHG_aControles[nItem,1] ) ;
                                of      wndABM ;
                                caption "" ;
                                width   21 ;
                                height  21 ;
                                value   .t. ;
                                font    "Arial" ;
                                size    9
                case _aEstructura[nItem,2] == "M"        // Campo tipo memo.

                        @ _OOHG_aControles[nItem,2], _OOHG_aControles[nItem,3] editbox &( _OOHG_aControles[nItem,1] ) ;
                                of     wndABM ;
                                width  160 ;
                                height 47
        endcase
next

// Puntero de registros.------------------------------------------------------
nArea     := Select()
nRegistro := RecNo()
dbSelectArea( _cArea )
(_cArea)->( dbGoTop() )

// Activación de la ventana.---------------------------------------------------
center   window wndABM
activate window wndABM


////////// Restaurar SET DELETED a su valor inicial

        set( _SET_DELETED , _BackDeleted  )


// Salida.---------------------------------------------------------------------
(_cArea )->( dbGoTop() )
dbSelectArea( nArea )
dbGoTo( nRegistro )

return ( nil )



 /***************************************************************************************
 *     Función: ABMRefresh( [nEstado] )
 *       Autor: Cristóbal Mollá
 * Descripción: Refresca la ventana segun el estado pasado.
 *  Parámetros: nEstado    Valor numerico que indica el tipo de estado.
 *    Devuelve: NIL
 ***************************************************************************************/
static function ABMRefresh( nEstado )

// Declaración de variables locales.-------------------------------------------
local nItem    // := 1                                  // Indice de iteración.
// local cMensaje := ""                                 // Mensajes al usuario.

// Refresco del cuadro de dialogo.
do case
        // Modo de visualización.----------------------------------------------
        case nEstado == ABM_MODO_VER

                // Estado de los controles.
                // Botones Cerrar y Nuevo.
                for nItem := 1 to 2
                        wndABM.&( _aBotones[nItem] ).Enabled := .t.
                next

                // Botones Guardar y Cancelar.
                for nItem := ( Len( _aBotones ) - 1 ) to Len( _aBotones )
                        wndABM.&( _aBotones[nItem] ).Enabled := .f.
                next

                // Resto de botones.
                if (_cArea)->( RecCount() ) == 0
                        wndABM.brwBrowse.Enabled := .f.
                        for nItem := 3 to ( Len( _aBotones ) - 2 )
                                wndABM.&( _aBotones[nItem] ).Enabled := .f.
                        next
                else
                        wndABM.brwBrowse.Enabled := .t.
                        for nItem := 3 to ( Len( _aBotones ) - 2 )
                                wndABM.&( _aBotones[nItem] ).Enabled := .t.
                        next
                endif

                // Controles de edición.
                for nItem := 1 to Len( _OOHG_aControles )
                        wndABM.&( _OOHG_aControles[nItem,1] ).Enabled := .f.
                next

                // Contenido de los controles.
                // Controles de edición.
                for nItem := 1 to Len( _OOHG_aControles )
                        wndABM.&( _OOHG_aControles[nItem,1] ).Value := (_cArea)->( FieldGet( nItem ) )
                next

                // Numero de registro y total.
                wndABM.lblRegistro.Value := AllTrim( Str( (_cArea)->(RecNo()) ) )
                wndABM.lblTotales.Value  := AllTrim( Str( (_cArea)->(RecCount()) ) )

        // Modo de edición.----------------------------------------------------
        case nEstado == ABM_MODO_EDITAR

                // Estado de los controles.
                // Botones Guardar y Cancelar.
                for nItem := ( Len( _aBotones ) - 1 ) to Len( _aBotones )
                        wndABM.&( _aBotones[nItem] ).Enabled := .t.
                next

                // Resto de los botones.
                for nItem := 1 to ( Len( _aBotones ) - 2 )
                        wndABM.&( _aBotones[nItem] ).Enabled := .f.
                next
                wndABM.brwBrowse.Enabled := .f.

                // Contenido de los controles.
                // Controles de edición.
                for nItem := 1 to Len( _OOHG_aControles )
                        wndABM.&( _OOHG_aControles[nItem,1] ).Enabled := _aEditables[nItem]
                next

                // Numero de registro y total.
                wndABM.lblRegistro.Value := AllTrim( Str( (_cArea)->(RecNo()) ) )
                wndABM.lblTotales.Value  := AllTrim( Str( (_cArea)->(RecCount()) ) )

        // Control de error.---------------------------------------------------
        otherwise
                MsgOOHGError( _OOHG_Messages( 8, 3 ), "" )
end case

return ( nil )



 /***************************************************************************************
 *     Función: ABMEventos( nEvento )
 *       Autor: Cristóbal Mollá
 * Descripción: Gestiona los eventos que se producen en la ventana wndABM.
 *  Parámetros: nEvento    Valor numérico que indica el evento a ejecutar.
 *    Devuelve: NIL
 ****************************************************************************************/
static function ABMEventos( nEvento )

// Declaración de variables locales.-------------------------------------------
local nItem      // := 1                                // Indice de iteración.
// local cMensaje   := ""                               // Mensaje al usuario.
local aValores      := {}                               // Valores de los campos de edición.
local nRegistro  // := 0                                // Numero de registro.
local lGuardar   // := .t.                              // Salida del bloque _bGuardar.
local cModo      // := ""                               // Texto del modo.
local cRegistro  // := ""                               // Numero de registro.
Local wndABM        := GetFormObject( "wndABM" )

// Gestión de eventos.
do case
        // Pulsación del botón CERRAR.-----------------------------------------
        case nEvento == ABM_EVENTO_SALIR
                wndABM:Release()

        // Pulsación del botón NUEVO.------------------------------------------
        case nEvento == ABM_EVENTO_NUEVO
                _lEditar := .f.
                cModo := _OOHG_Messages( 6, 3 )
                wndABM:Title := wndABM:Title + cModo

                // Pasa a modo de edición.
                ABMRefresh( ABM_MODO_EDITAR )

                // Actualiza los valores de los controles de edición.
                for nItem := 1 to Len( _OOHG_aControles )
                        do case
                                case _aEstructura[nItem, 2] == "C"
                                        wndABM:Control( _OOHG_aControles[nItem,1] ):Value := ""
                                case _aEstructura[nItem, 2] == "N"
                                        wndABM:Control( _OOHG_aControles[nItem,1] ):Value := 0
                                case _aEstructura[nItem, 2] == "D"
                                        wndABM:Control( _OOHG_aControles[nItem,1] ):Value := Date()
                                case _aEstructura[nItem, 2] == "L"
                                        wndABM:Control( _OOHG_aControles[nItem,1] ):Value := .f.
                                case _aEstructura[nItem, 2] == "M"
                                        wndABM:Control( _OOHG_aControles[nItem,1] ):Value := ""
                        endcase
                next

                // Esteblece el foco en el primer control.
                wndABM:Control( _OOHG_aControles[1,1] ):SetFocus()

        // Pulsación del botón EDITAR.-----------------------------------------
        case nEvento == ABM_EVENTO_EDITAR
                _lEditar := .t.
                cModo := _OOHG_Messages( 6, 4 )
                wndABM:Title := wndABM:Title + cModo

                // Pasa a modo de edicion.
                ABMRefresh( ABM_MODO_EDITAR )

                // Actualiza los valores de los controles de edición.
                for nItem := 1 to Len( _OOHG_aControles )
                        wndABM:Control( _OOHG_aControles[nItem,1] ):Value := (_cArea)->( FieldGet(nItem) )
                next

                // Establece el foco en el primer coltrol.
                wndABM:Control( _OOHG_aControles[1,1] ):SetFocus()

        // Pulsación del botón BORRAR.-----------------------------------------
        case nEvento == ABM_EVENTO_BORRAR

                // Borra el registro si se acepta.
                if MsgOKCancel( _OOHG_Messages( 5, 1 ), "" )
	                if (_cArea)->( rlock() )
        	           (_cArea)->( dbDelete() )
                	   (_cArea)->( dbCommit() )
	                   (_cArea)->( dbunlock() )
        	           if .not. set( _SET_DELETED )
                	      set deleted on
	                   endif
        	           (_cArea)->( dbSkip() )
                	   if (_cArea)->( eof() )
	                      (_cArea)->( dbGoBottom() )
        	           endif
	                else
                      Msgstop( _OOHG_Messages( 11, 41 ), '' )
	                endif
                endif

                // Refresca.
                wndABM:brwBrowse:Refresh()
                wndABM:brwBrowse:Value := (_cArea)->( RecNo() )

        // Pulsación del botón BUSCAR.-----------------------------------------
        case nEvento == ABM_EVENTO_BUSCAR
                if !HB_IsBlock( _bBuscar )
                        if Empty( (_cArea)->( ordSetFocus() ) )
                                msgExclamation( _OOHG_Messages( 5, 2 ), "" )
                        else
                                ABMBuscar()
                        endif
                else
                        Eval( _bBuscar )
                        wndABM:brwBrowse:Value := (_cArea)->( RecNo() )
                endif

        // Pulsación del botón IR AL REGISTRO.---------------------------------
        case nEvento == ABM_EVENTO_IR
                cRegistro := InputBox( _OOHG_Messages( 6, 5 ), "" )
                if !Empty( cRegistro )
                        nRegistro := Val( cRegistro )
                        if ( nRegistro != 0 ) .and. ( nRegistro <= (_cArea)->( RecCount() ) )
                                (_cArea)->( dbGoTo( nRegistro ) )
                                wndABM:brwBrowse:Value := nRegistro
                        endif
                endif

        // Pulsación del botón LISTADO.----------------------------------------
        case nEvento == ABM_EVENTO_LISTADO
                ABMListado()

        // Pulsación del botón PRIMERO.----------------------------------------
        case nEvento == ABM_EVENTO_PRIMERO
                (_cArea)->( dbGoTop() )
                wndABM:brwBrowse:Value   := (_cArea)->( RecNo() )
                wndABM:lblRegistro:Value := AllTrim( Str( (_cArea)->(RecNo()) ) )
                wndABM:lblTotales:Value  := AllTrim( Str( (_cArea)->(RecCount()) ) )

        // Pulsación del botón ANTERIOR.---------------------------------------
        case nEvento == ABM_EVENTO_ANTERIOR
                (_cArea)->( dbSkip( -1 ) )
                wndABM:brwBrowse:Value   := (_cArea)->( RecNo() )
                wndABM:lblRegistro:Value := AllTrim( Str( (_cArea)->(RecNo()) ) )
                wndABM:lblTotales:Value  := AllTrim( Str( (_cArea)->(RecCount()) ) )

        // Pulsación del botón SIGUIENTE.--------------------------------------
        case nEvento == ABM_EVENTO_SIGUIENTE
                (_cArea)->( dbSkip( 1 ) )
                iif( (_cArea)->( EOF() ) , (_cArea)->( DbGoBottom() ), Nil )
                wndABM:brwBrowse:Value := (_cArea)->( RecNo() )
                wndABM:lblRegistro:Value := AllTrim( Str( (_cArea)->(RecNo()) ) )
                wndABM:lblTotales:Value  := AllTrim( Str( (_cArea)->(RecCount()) ) )

        // Pulsación del botón ULTIMO.-----------------------------------------
        case nEvento == ABM_EVENTO_ULTIMO
                (_cArea)->( dbGoBottom() )
                wndABM:brwBrowse:Value   := (_cArea)->( RecNo() )
                wndABM:lblRegistro:Value := AllTrim( Str( (_cArea)->(RecNo()) ) )
                wndABM:lblTotales:Value  := AllTrim( Str( (_cArea)->(RecCount()) ) )

        // Pulsación del botón GUARDAR.----------------------------------------
        case nEvento == ABM_EVENTO_GUARDAR
                if ( !HB_IsBlock( _bGuardar ) )

                        // Guarda el registro.
                        if .not. _lEditar
                                (_cArea)->( dbAppend() )
                        endif

			if (_cArea)->(rlock())

            for nItem := 1 to Len( _OOHG_aControles )
                                 (_cArea)->( FieldPut( nItem, wndABM:Control( _OOHG_aControles[nItem,1] ):Value ) )
				next

				(_cArea)->( dbCommit() )

				Unlock

				// Refresca el browse.

                           wndABM:brwBrowse:Value := (_cArea)->( RecNo() )
                           wndABM:brwBrowse:Refresh()
                         wndABM:Title := SubStr( wndABM:Title, 1, Len(wndABM:Title) - 12 )

			else

				MsgStop ('Record locked by another user')

			endif

                else

                        // Evalúa el bloque de código bGuardar.
                        for nItem := 1 to Len( _OOHG_aControles )
                                aAdd( aValores, wndABM:Control( _OOHG_aControles[nItem,1] ):Value )
                        next
                        lGuardar := Eval( _bGuardar, aValores, _lEditar )
                        lGuardar := iif( !HB_IsLogical( lGuardar ) , .t., lGuardar )
                        if lGuardar
                                (_cArea)->( dbCommit() )

                                // Refresca el browse.
                                wndABM:brwBrowse:Value := (_cArea)->( RecNo() )
                                wndABM:brwBrowse:Refresh()
                                wndABM:Title := SubStr( wndABM:Title, 1, Len(wndABM:Title) - 12 )
                        endif
                endif

        // Pulsación del botón CANCELAR.---------------------------------------
        case nEvento == ABM_EVENTO_CANCELAR

                // Pasa a modo de visualización.
                ABMRefresh( ABM_MODO_VER )
                wndABM:Title := SubStr( wndABM:Title, 1, Len(wndABM:Title) - 12 )

        // Control de error.---------------------------------------------------
        otherwise
                MsgOOHGError( _OOHG_Messages( 8, 4 ), "" )

endcase

return ( nil )


 /***************************************************************************************
 *     Función: ABMBuscar()
 *       Autor: Cristóbal Mollá
 * Descripción: Definición de la busqueda
 *  Parámetros: Ninguno
 *    Devuelve: NIL
 ***************************************************************************************/
static function ABMBuscar()

// Declaración de variables locales.-------------------------------------------
local nItem      // := 0                                // Indice de iteración.
local aCampo        := {}                               // Nombre de los campos.
local aTipoCampo    := {}                               // Matriz con los tipos de campo.
local cCampo     // := ""                               // Nombre del campo.
// local cMensaje   := ""                               // Mensaje al usuario.
local nTipoCampo // := 0                                // Indice el tipo de campo.
local cTipoCampo // := ""                               // Tipo de campo.
local cModo      // := ""                               // Texto del modo de busqueda.

// Obtiene el nombre y el tipo de campo.---------------------------------------
for nItem := 1 to Len( _aEstructura )
        aAdd( aCampo, _aEstructura[nItem,1] )
        aAdd( aTipoCampo, _aEstructura[nItem,2] )
next

// Evalua si el campo indexado existe y obtiene su tipo.-----------------------
cCampo := Upper( (_cArea)->( ordSetFocus() ) )
nTipoCampo := aScan( aCampo, cCampo )
if nTipoCampo == 0
        msgExclamation( _OOHG_Messages( 5, 3 ), "" )
        return ( nil )
endif
cTipoCampo := aTipoCampo[nTipoCampo]

// Comprueba si el tipo se puede buscar.---------------------------------------
if ( cTipoCampo == "N" ) .or. ( cTipoCampo == "L" ) .or. ( cTipoCampo == "M" )
        MsgExclamation( _OOHG_Messages( 5, 4 ), "" )
        return ( nil )
endif

// Define la ventana de busqueda.----------------------------------------------
define window wndABMBuscar ;
                at 0, 0 ;
                width  200 ;
                height 160 ;
                title _OOHG_Messages( 6, 6 ) ;
                modal ;
                nosysmenu ;
                font "Serif" ;
                size 8 ;
                backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )
end window

// Define los controles de la ventana de busqueda.-----------------------------
// Etiquetas
@ 20, 20 label lblEtiqueta1 ;
        of wndABMBuscar ;
        value "" ;
        width 160 ;
        height 21 ;
        font "ms sans serif" ;
        size 8

// Botones.
@ 80, 20 button btnGuardar ;
        of      wndABMBuscar ;
        caption "&" + _OOHG_Messages( 7, 5 ) ;
        action  {|| ABMBusqueda() } ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8
@ 80, 100 button btnCancelar ;
        of      wndABMBuscar ;
        caption "&" + _OOHG_Messages( 7, 13 ) ;
        action  {|| wndABMBuscar.Release } ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8

// Controles de edición.
do case
        case cTipoCampo == "C"
                cModo := _OOHG_Messages( 6, 7 )
                wndABMBuscar.lblEtiqueta1.Value := cModo
                @ 45, 20 textbox txtBuscar ;
                of wndABMBuscar ;
                height 21 ;
                value "" ;
                width 160 ;
                font "Arial" ;
                size 9 ;
                maxlength _aEstructura[nTipoCampo,3]
        case cTipoCampo == "D"
                cModo := _OOHG_Messages( 6, 8 )
                wndABMBuscar.lblEtiqueta1.Value := cModo
                @ 45, 20 datepicker txtBuscar ;
                        of  wndABMBuscar ;
                        value   Date() ;
                        width   100 ;
                        font    "Arial" ;
                        size    9
        endcase

// Activa la ventana.----------------------------------------------------------
center window   wndABMBuscar
activate window wndABMBuscar

return ( nil )



 /***************************************************************************************
 *     Función: ABMBusqueda()
 *       Autor: Cristóbal Mollá
 * Descripción: Realiza la busqueda en la base de datos
 *  Parámetros: Ninguno
 *    Devuelve: NIL
 ***************************************************************************************/
static function ABMBusqueda()

// Declaración de variables locales.-------------------------------------------
local nRegistro := (_cArea)->( RecNo() )                // Registro anterior.

// Busca el registro.----------------------------------------------------------
if (_cArea)->( dbSeek( wndABMBuscar.txtBuscar.Value ) )
        nRegistro := (_cArea)->( RecNo() )
else
        msgExclamation( _OOHG_Messages( 5, 5 ), "" )
        (_cArea)->(dbGoTo( nRegistro ) )
endif

// Cierra y actualiza.---------------------------------------------------------
wndABMBuscar.Release
wndABM.brwBrowse.Value := nRegistro

return ( nil )



 /***************************************************************************************
 *     Función: ABMListado()
 *       Autor: Cristóbal Mollá
 * Descripción: Definición del listado.
 *  Parámetros: Ninguno
 *    Devuelve: NIL
 ***************************************************************************************/
function ABMListado()

// Declaración de variables locales.-------------------------------------------
local nItem          // := 1                            // Indice de iteración.
local aCamposListado    := {}                           // Matriz con los campos del listado.
local aCamposTotales    := {}                           // Matriz con los campos totales.
local nPrimero       // := 0                            // Registro inicial.
local nUltimo        // := 0                            // Registro final.
local nRegistro         := (_cArea)->( RecNo() )        // Registro anterior.

// Inicialización de variables.------------------------------------------------
// Campos imprimibles.
for nItem := 1 to Len( _aEstructura )

        // Todos los campos son imprimibles menos los memo.
        if _aEstructura[nItem,2] != "M"
                aAdd( aCamposTotales, _aEstructura[nItem,1] )
        endif
next

// Rango de registros.
(_cArea)->( dbGoTop() )
nPrimero := (_cArea)->( RecNo() )
(_cArea)->( dbGoBottom() )
nUltimo  := (_cArea)->( RecNo() )
(_cArea)->( dbGoTo( nRegistro ) )


// Defincicón de la ventana del proceso.---------------------------------------
define window wndABMListado ;
        at 0, 0 ;
        width  420 ;
        height 295 ;
        title _OOHG_Messages( 6, 10 ) ;
        modal ;
        nosysmenu ;
        font "Serif" ;
        size 8 ;
        backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

end window

// Definición de los controles.------------------------------------------------
// Frame.
@ 10, 10 frame frmFrame1 of wndABMListado width 390 height 205

// Label.
@ 20, 20 label lblLabel1 ;
        of wndABMListado ;
        value _OOHG_Messages( 6, 11 ) ;
        width 140 ;
        height 21 ;
        font "ms sans serif" ;
        size 8
@ 20, 250 label lblLabel2 ;
        of     wndABMListado ;
        value  _OOHG_Messages( 6, 12 ) ;
        width  140 ;
        height 21 ;
        font   "ms sans serif" ;
        size   8
@ 160, 20 label lblLabel3 ;
        of wndABMListado ;
        value _OOHG_Messages( 6, 13 ) ;
        width 140 ;
        height 21 ;
        font "ms sans serif" ;
        size 8
@ 160, 250 label lblLabel4 ;
        of wndABMListado ;
        value _OOHG_Messages( 6, 14 ) ;
        width 140 ;
        height 21 ;
        font "ms sans serif" ;
        size 8

// ListBox.
@ 45, 20 listbox lbxListado ;
        of wndABMListado ;
        width 140 ;
        height 100 ;
        items aCamposListado ;
        value 1 ;
        font "Arial" ;
        size 9
@ 45, 250 listbox lbxCampos ;
        of wndABMListado ;
        width 140 ;
        height 100 ;
        items aCamposTotales ;
        value 1 ;
        font "Arial" ;
        size 9 ;
        sort

// Spinner.
@ 185, 20 spinner spnPrimero ;
        of wndABMListado ;
        range 1, (_cArea)->( RecCount() ) ;
        value nPrimero ;
        width 70 ;
        height 21 ;
        font "Arial" ;
        size 9
@ 185, 250 spinner spnUltimo ;
        of wndABMListado ;
        range 1, (_cArea)->( RecCount() ) ;
        value nUltimo ;
        width 70 ;
        height 21 ;
        font "Arial" ;
        size 9

// Botones.
@ 45, 170 button btnMas ;
        of      wndABMListado ;
        caption _OOHG_Messages( 7, 14 ) ;
        action  {|| ABMListadoEvento( ABM_LISTADO_MAS ) } ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8
@ 85, 170 button btnMenos ;
        of      wndABMListado ;
        caption _OOHG_Messages( 7, 15 ) ;
        action  {|| ABMListadoEvento( ABM_LISTADO_MENOS ) } ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8
@ 225, 240 button btnImprimir ;
        of      wndABMListado ;
        caption _OOHG_Messages( 7, 16 ) ;
        action  {|| ABMListadoEvento( ABM_LISTADO_IMPRIMIR ) } ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop
@ 225, 330 button btnCerrar ;
        of      wndABMListado ;
        caption _OOHG_Messages( 7, 17 ) ;
        action  {|| ABMListadoEvento( ABM_LISTADO_CERRAR ) } ;
        width   70 ;
        height  30 ;
        font    "ms sans serif" ;
        size    8 ;
        notabstop

// Activación de la ventana----------------------------------------------------
center   window wndABMListado
activate window wndABMListado

return ( nil )



 /***************************************************************************************
 *     Función: ABMListadoEvento( nEvento )
 *       Autor: Cristóbal Mollá
 * Descripción: Ejecuta los eventos de la ventana de definición del listado.
 *  Parámetros: nEvento    Valor numérico con el tipo de evento a ejecutar.
 *    Devuelve: NIL
 ***************************************************************************************/
function ABMListadoEvento( nEvento )

// Declaración de variables locales.-------------------------------------------
local cItem        // := ""                             // Nombre del item.
local nItem        // := 0                              // Numero del item.
local aCampo          := {}                             // Nombres de los campos.
local nIndice      // := 0                              // Numero del campo.
local nAnchoCampo  // := 0                              // Ancho del campo.
local nAnchoTitulo // := 0                              // Ancho del título.
local nTotal          := 0                              // Ancho total.
// local cMensaje     := ""                             // Mensaje al usuario.
local nPrimero        := wndABMListado.spnPrimero.Value // Registro inicial.
local nUltimo         := wndABMListado.spnUltimo.Value  // Registro final.

// Control de eventos.
do case
        // Cerrar el cuadro de dialogo de definición de listado.---------------
        case nEvento == ABM_LISTADO_CERRAR
                wndABMListado.Release

        // Añadir columna.-----------------------------------------------------
        case nEvento == ABM_LISTADO_MAS
                if .not. wndABMListado.lbxCampos.ItemCount == 0 .or. ;
                         wndABMListado.lbxCampos.Value == 0
                        nItem := wndABMListado.lbxCampos.Value
                        cItem := wndABMListado.lbxCampos.Item( nItem )
                        wndABMListado.lbxListado.addItem( cItem )
                        delete item nItem from lbxCampos of wndABMListado
                endif

        // Quitar columna.-----------------------------------------------------
        case nevento == ABM_LISTADO_MENOS
                if .not. wndABMListado.lbxListado.ItemCount == 0 .or. ;
                         wndABMListado.lbxListado.Value == 0
                        nItem := wndABMListado.lbxListado.Value
                        cItem := wndABMListado.lbxListado.Item( nItem )
                        wndABMListado.lbxCampos.addItem( cItem )
                        delete item nItem from lbxListado of wndABMListado
                endif

        // Imprimir listado.---------------------------------------------------
        case nevento == ABM_LISTADO_IMPRIMIR

                // Copia el contenido de los controles a las variables.
                _aCamposListado := {}
                for nItem := 1 to wndABMListado.lbxListado.ItemCount
                        aAdd( _aCamposListado, wndABMListado.lbxListado.Item( nItem ) )
                next

                // Establece el numero de orden del campo a listar.
                _aNumeroCampo := {}
                for nItem := 1 to Len( _aEstructura )
                        aAdd( aCampo, _aEstructura[nItem,1] )
                next
                for nItem := 1 to Len( _aCamposListado )
                        aAdd( _aNumeroCampo, aScan( aCampo, _aCamposListado[nItem] ) )
                next

                // Establece el ancho del campo a listar.
                _aAnchoCampo := {}
                for nItem := 1 to Len( _aCamposListado )
                        nIndice      := _aNumeroCampo[nItem]
                        nAnchoTitulo := Len( _aCampos[nIndice] )
                        nAnchoCampo  := _aEstructura[nIndice,3]
                        if _aEstructura[nIndice,2] == "D"
                                aAdd( _aAnchoCampo, iif( nAnchoTitulo > nAnchoCampo,;
                                                         nAnchoTitulo+4,;
                                                         nAnchoCampo+4 ) )
                        else
                                aAdd( _aAnchoCampo, iif( nAnchoTitulo > nAnchoCampo,;
                                                         nAnchoTitulo+2,;
                                                         nAnchoCampo+2 ) )
                        endif
                 next

                // Comprueba el tamaño del listado y lanza la impresión.
                for nItem := 1 to Len( _aAnchoCampo )
                        nTotal += _aAnchoCampo[nItem]
                next
                if nTotal > 164

                        // No cabe en la hoja.
                        MsgExclamation( _OOHG_Messages( 5, 6 ), "" )
                else
                        if nTotal > 109

                                // Cabe en una hoja horizontal.
                                ABMListadoImprimir( .t., nPrimero, nUltimo )
                        else

                                // Cabe en una hoja vertical.
                                ABMListadoImprimir( .f., nPrimero, nUltimo )
                        endif
                endif

        // Control de error.---------------------------------------------------
        otherwise
                MsgOOHGError( _OOHG_Messages( 8, 5 ), "" )
endcase

return ( nil )



 /***************************************************************************************
 *     Función: ABMListadoImprimir( lOrientacion, nPrimero, nUltimo )
 *       Autor: Cristóbal Mollá
 * Descripción: Lanza el listado definido a la impresora.
 *  Parámetros: lOrientacion    Lógico que indica si el listado es horizontal (.t.)
 *                              o vertical (.f.)
 *              nPrimero        Valor numerico con el primer registro a imprimir.
 *              nUltimo         Valor numérico con el último registro a imprimir.
 *    Devuelve: NIL
 ***************************************************************************************/
function ABMListadoImprimir( lOrientacion, nPrimero, nUltimo )

// Declaración de variables locales.-------------------------------------------
local nLineas      := 0                                 // Numero de linea.
local nPaginas  // := 0                                 // Numero de páginas.
local nFila        := 13                                // Numero de fila.
local nColumna     := 10                                // Numero de columna.
local nItem     // := 1                                 // Indice de iteracion.
local nIndice   // := 1                                 // Indice de campo.
local lCabecera // := .t.                               // ¿Imprimir cabecera?.
// local lPie      := .f.                               // ¿Imprimir pie?.
local nPagina      := 1                                 // Numero de pagina.
local lSalida   // := .t.                               // ¿Salir del listado?.
local nRegistro    := (_cArea)->( RecNo() )             // Registro anterior.
local cTexto    // := ""                                // Texto para lógicos.
local oprint

// Definición del rango del listado.-------------------------------------------
(_cArea)->( dbGoTo( nPrimero ) )
do while .not. ( (_cArea)->( RecNo() ) ) == nUltimo .or. ( (_cArea)->( Eof() ) )
        nLineas++
        (_cArea)->( dbSkip( 1 ) )
enddo
(_cArea)->( dbGoTo( nPrimero ) )

// Inicialización de la impresora.---------------------------------------------


oprint:=tprint()
oprint:init()   ////// printlibrary
oprint:selprinter(.T. , .T.  )  /// select,preview,landscape,papersize
if oprint:lprerror
   oprint:release()
   return nil
endif



// Control de errores.---------------------------------------------------------


// Definición de fuentes, rellenos y tipos de linea.---------------------------
// Fuentes.

// Inicio del listado.

oprint:begindoc()


lCabecera := .t.
lSalida   := .t.
do while lSalida

        // Cabecera.-----------------------------------------------------------
        if lCabecera
                oprint:beginpage()
oprint:printdata(5,1,_OOHG_Messages(6,15) + _cTitulo,"times new roman",14,.T.) ///
oprint:printline(6,1,6,140)
oprint:printdata(7,1,_OOHG_messages(6,16) ,"times new roman",10,.T.) ///
oprint:printdata(7,30,date(),"times new roman",10,.F.) ///
oprint:printdata(8,1, _OOHG_messages(6,17) ,"times new roman",10,.T.) ///
oprint:printdata(8,30, alltrim(str(nprimero)),"times new roman",10,.F.) ///
oprint:printdata(8,40,_OOHG_messages(6,18) ,"times new roman",10,.T.) ///
oprint:printdata(8,60, alltrim(str(nultimo)),"times new roman",10,.F.) ///
oprint:printdata(9,1,_OOHG_messages(6,19) ,"times new roman",10,.T.) ///
oprint:printdata(9,30, ordname(),"times new roman",10,.F.) ///
                nColumna := 1
                for nItem := 1 to Len( _aNumeroCampo )
                        nIndice := _aNumeroCampo[nItem]
                        oprint:printdata(11,ncolumna,UPPER(_acampos[nindice]),,9,.T.) ///
                        nColumna += _aAnchoCampo[nItem] +2
                next
                lCabecera := .f.
        endif

        // Registros.-----------------------------------------------------------
        nColumna := 1
        for nItem := 1 to Len( _aNumeroCampo )
                nIndice := _aNumeroCampo[nItem]
                do case
                case _aEstructura[nIndice,2] == "L"

                        cTexto := iif( (_cArea)->( FieldGet( nIndice ) ), _OOHG_Messages( 6, 20 ), _OOHG_Messages( 6, 21 ) )
                        oprint:printdata(nfila,ncolumna,ctexto, ,,)
                        nColumna += _aAnchoCampo[nItem] +2
                case _aEstructura[nIndice,2] == "N"
                        oprint:printdata(nfila,ncolumna, (_cArea)->( FieldGet( nIndice ) ), ,,)
                        nColumna += _aAnchoCampo[nItem] +2

                otherwise
                        oprint:printdata(nfila,ncolumna, (_cArea)->( FieldGet( nIndice ) ), ,,)
                        nColumna += _aAnchoCampo[nItem] +2
                endcase
        next
        nFila++

        (_cArea)->( dbSkip( 1 ) )

        // Pie.-----------------------------------------------------------------
        if lOrientacion
                // Horizontal
                if nFila > 43
                        nPaginas := Int( nLineas / 32 )
                        if .not. Mod( nLineas, 32 ) == 0
                                nPaginas++
                        endif


                        oprint:printline(45,10,45,140)
                        oprint:printdata(46,1,_OOHG_messages(6,22) + AllTrim( Str( nPagina ) )  ,"times new roman",10,.F.) ///
                        lCabecera := .t.
                        nPagina++
                        nFila := 13
                        oprint:endpage()
                endif
        else
                // Vertical
                if nFila > 53
                        nPaginas := Int( nLineas / 42 )
                        if .not. Mod( nLineas, 42 ) == 0
                                nPaginas++
                        endif

                        oprint:printline(55,1,55,140)


                        oprint:printdata(56,70,_OOHG_messages(6,22) + AllTrim( Str( nPagina ) )  ,"times new roman",10,.F.) ///
                        lCabecera := .t.
                        nPagina++
                        nFila := 13

                        oprint:endpage()
                endif
        endif
        Empty( nPaginas )

        // Comprobación del rango de registro.---------------------------------
        if ( (_cArea)->( RecNo() ) == nUltimo )
                nColumna := 1

                // Imprime el último registro.
                for nItem := 1 to Len( _aNumeroCampo )
                        nIndice := _aNumeroCampo[nItem]
                        do case
                        case _aEstructura[nIndice,2] == "L"
                                cTexto := iif( (_cArea)->( FieldGet( nIndice ) ), _OOHG_Messages( 6, 20 ), _OOHG_Messages( 6, 21 ) )
                                oprint:printdata(nfila,ncolumna, ctexto, ,,.F.)
                                nColumna += _aAnchoCampo[nItem]  +2
                        case _aEstructura[nIndice,2] == "N"
                                oprint:printdata(nfila,ncolumna, (_cArea)->( FieldGet( nIndice ) )    , ,,.F.)
                                nColumna += _aAnchoCampo[nItem] +2

                        otherwise
                                oprint:printdata(nfila,ncolumna, (_cArea)->( FieldGet( nIndice ) )    , ,,.F.)
                                nColumna += _aAnchoCampo[nItem] +2
                        endcase
                next
                lSalida := .f.
        endif
        if ( (_cArea)->( Eof() ) )
                lSalida := .f.
        endif
enddo

// Comprueba que se imprime el pie al finalizar.-------------------------------
if lOrientacion
        // Horizontal
        if nFila <= 43
                nPaginas := Int( nLineas / 32 )
                if .not. Mod( nLineas, 32 ) == 0
                        nPaginas++
                endif
                oprint:printline(45,1,45,140)
                oprint:printdata(46,70,_OOHG_messages(6,22) + AllTrim( Str( nPagina ) )   ,"times new roman" ,10,.F.)
        endif
else
        // Vertical
        if nFila <= 53
                nPaginas := Int( nLineas / 42 )
                if .not. Mod( nLineas, 42 ) == 0
                        nPaginas++
                endif
                oprint:printline(55,1,55,140)
                oprint:printdata(56,70,_OOHG_messages(6,22) + AllTrim( Str( nPagina ) )   ,"times new roman" ,10,.F.)
        endif
endif
Empty( nPaginas )
oprint:endpage()
oprint:enddoc()
oprint:release()
release oprint
// Restaura.-------------------------------------------------------------------
(_cArea)->( dbGoTo( nRegistro ) )

return ( nil )
