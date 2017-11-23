/*
* $Id: h_edit_ex.prg $
*/
/*
* ooHG source code:
* EDIT EXTENDED command
* Copyright 2005-2017 Vicente Guerra <vicente@guerra.com.mx>
* https://oohg.github.io/
* Portions of this project are based upon Harbour MiniGUI library.
* Copyright 2002-2005 Roberto Lopez <roblez@ciudad.com.ar>
* Portions of this project are based upon Harbour GUI framework for Win32.
* Copyright 2001 Alexander S. Kresin <alex@belacy.belgorod.su>
* Copyright 2001 Antonio Linares <alinares@fivetech.com>
* Portions of this project are based upon Harbour Project.
* Copyright 1999-2017, https://harbour.github.io/
*/
/*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2, or (at your option)
* any later version.
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
* You should have received a copy of the GNU General Public License
* along with this software; see the file LICENSE.txt. If not, write to
* the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1335,USA (or download from http://www.gnu.org/licenses/).
* As a special exception, the ooHG Project gives permission for
* additional uses of the text contained in its release of ooHG.
* The exception is that, if you link the ooHG libraries with other
* files to produce an executable, this does not by itself cause the
* resulting executable to be covered by the GNU General Public License.
* Your use of that executable is in no way restricted on account of
* linking the ooHG library code into it.
* This exception does not however invalidate any other reasons why
* the executable file might be covered by the GNU General Public License.
* This exception applies only to the code released by the ooHG
* Project under the name ooHG. If you copy code from other
* ooHG Project or Free Software Foundation releases into a copy of
* ooHG, as the General Public License permits, the exception does
* not apply to the code that you add in this way. To avoid misleading
* anyone as to the status of such modified files, you must delete
* this exception notice from them.
* If you write modifications of your own for ooHG, it is your choice
* whether to permit this exception to apply to your modifications.
* If you do not wish that, delete this exception notice.
*/

/*
* - Descripción -
* ===============
*      EDIT EXTENDED, es un comando que permite realizar el mantenimiento de una bdd. En principio
*      está diseñado para administrar bases de datos que usen los divers DBFNTX y DBFCDX,
*      presentando otras bases de datos con diferentes drivers resultados inesperados.
* - Sintáxis -
* ============
*      Todos los parámetros del comando EDIT son opcionales.
*      EDIT EXTENDED                           ;
*       [ WORKAREA cWorkArea ]                 ;
*       [ TITLE cTitle ]                       ;
*       [ FIELDNAMES acFieldNames ]            ;
*       [ FIELDMESSAGES acFieldMessages ]      ;
*       [ FIELDENABLED alFieldEnabled ]        ;
*       [ TABLEVIEW alTableView ]              ;
*       [ OPTIONS aOptions ]                   ;
*       [ ON SAVE bSave ]                      ;
*       [ ON FIND bFind ]                      ;
*       [ ON PRINT bPrint ]
*      Si no se pasa ningún parámetro, el comando EDIT toma como bdd de trabajo la del
*      area de trabajo actual.
*      [cWorkArea]             Cadena de texto con el nombre del alias de la base de datos
*                              a editar. Por defecto el alias de la base de datos activa.
*      [cTitle]                Cadena de texto con el título de la ventana de visualización
*                              de registros. Por defecto se toma el alias de la base de datos
*                              activa.
*      [acFieldNames]          Matriz de cadenas de texto con el nombre descriptivo de los
*                              campos de la base de datos. Tiene que tener el mismo número
*                              de elementos que campos la bdd. Por defecto se toma el nombre
*                              de los campos de la estructura de la bdd.
*      [acFieldMessages]       Matriz de cadenas de texto con el texto que aparaecerá en la
*                              barra de estado cuando se este añadiento o editando un registro.
*                              Tiene que tener el mismo numero de elementos que campos la bdd.
*                              Por defecto se rellena con valores internos.
*      [alFieldEnabled]        Matriz de valores lógicos que indica si el campo referenciado
*                              por la matriz esta activo durante la edición de registro. Tiene
*                              que tener el mismo numero de elementos que campos la bdd. Por
*                              defecto toma todos los valores como verdaderos ( .t. ).
*      [aTableView]            Matriz de valores lógicos que indica si el campo referenciado
*                              por la matriz es visible en la tabla. Tiene que tener el mismo
*                              numero de elementos que campos la bdd. Por defecto toma todos
*                              los valores como verdaderos ( .t. ).
*      [aOptions]              Matriz de 2 niveles. el primero de tipo texto es la descripción
*                              de la opción. El segundo de tipo bloque de código es la opción
*                              a ejecutar cuando se selecciona. Si no se pasa esta variable,
*                              se desactiva la lista desplegable de opciones.
*      [bSave]                 Bloque de codigo con el formato {|aValores, lNuevo| Accion } que
*                              se ejecutará al pulsar la tecla de guardar registro. Se pasan
*                              las variables aValores con el contenido del registro a guardar y
*                              lNuevo que indica si se está añadiendo (.t.) o editando (.f.).
*                              Esta variable ha de devolver .t. para salir del modo de edición.
*                              Por defecto se graba con el código de la función.
*      [bFind]                 Bloque de codigo a ejecutar cuando se pulsa la tecla de busqueda.
*                              Por defecto se usa el código de la función.
*      [bPrint]                Bloque de código a ejecutar cuando se pulsa la tecla de listado.
*                              Por defecto se usa el codigo de la función.
*      Ver DEMO.PRG para ejemplo de llamada al comando.
* - Historial -
* =============
*      Mar 03  - Definición de la función.
*              - Pruebas.
*              - Soporte para lenguaje en inglés.
*              - Corregido bug al borrar en bdds con CDX.
*              - Mejora del control de parámetros.
*              - Mejorada la función de de busqueda.
*              - Soprte para multilenguaje.
*              - Versión 1.0 lista.
*      Abr 03  - Corregido bug en la función de busqueda (Nombre del botón).
*              - Añadido soporte para idioma Ruso (Grigory Filiatov).
*              - Añadido soporte para idioma Catalán (Por corregir).
*              - Añadido soporte para idioma Portugués (Clovis Nogueira Jr).
*              - Añadido soporte para idioma Polaco (Janusz Poura).
*              - Añadido soporte para idioma Francés (C. Jouniauxdiv).
*      May 03  - Añadido soporte para idioma Italiano (Lupano Piero).
*              - Añadido soporte para idioma Alemán (Janusz Poura).
*              - Cambio del formato de llamada al comando.
*              - La creación de ventanas se realiza en función del alto y ancho
*                de la pantalla.
*              - Se elimina la restricción de tamaño en los nombre de etiquetas.
*              - Se elimina la restricción de numero de campos del area de la bdd.
*              - Se elimina la restricción de que los campos tipo MEMO tienen que ir
*                al final de la base de datos.
*              - Se añade la opción de visualizar comentarios en la barra de estado.
*              - Se añade opción de control de visualización de campos en el browse.
*              - Se modifica el parámetro nombre del area de la bdd que pasa a ser
*                opcional.
*              - Se añade la opción de saltar al siguiente foco mediante la pulsación
*                de la tecla ENTER (Solo a controles tipo TEXTBOX).
*              - Se añade la opción de cambio del indice activo.
*              - Mejora de la rutina de busqueda.
*              - Mejora en la ventana de definición de listados.
*              - Pequeños cambios en el formato del listado.
*              - Actualización del soporte multilenguaje.
*      Jun 03  - Pruebas de la versión 1.5
*              - Se implementan las nuevas opciones de la librería de Ryszard Rylko
*              - Se implementa el filtrado de la base de datos.
*      Ago 03  - Se corrige bug en establecimiento de filtro.
*              - Actualizado soporte para italiano (Arcangelo Molinaro).
*              - Actualizado soporte multilenguage.
*              - Actualizado el soporte para filtrado.
*      Sep 03  - Idioma Vasco listo. Gracias a Gerardo Fernández.
*              - Idioma Italaino listo. Gracias a Arcangelo Molinaro.
*              - Idioma Francés listo. Gracias a Chris Jouniauxdiv.
*              - Idioma Polaco listo. Gracias a Jacek Kubica.
*      Oct 03  - Solucionado problema con las clausulas ON FIND y ON PRINT, ahora
*                ya tienen el efecto deseado. Gracias a Grigory Filiatov.
*              - Se cambia la referencia a _ExtendedNavigation por _OOHG_ExtendedNavigation
*                para adecuarse a la sintaxis de la construción 76.
*              - Idioma Alemán listo. Gracias a Andreas Wiltfang.
*      Nov 03  - Problema con dbs en set exclusive. Gracias a cas_minigui.
*              - Problema con tablas con pocos campos. Gracias a cas_minigui.
*              - Cambio en demo para ajustarse a nueva sintaxis RDD Harbour (DBFFPT).
*      Dic 03  - Ajuste de la longitud del control para fecha. Gracias a Laszlo Henning.
*      Ene 04  - Problema de bloqueo con SET DELETED ON. Gracias a Grigory Filiatov y Roberto L¢pez.
* - Limitaciones -
* ================
*      - No se pueden realizar busquedas por campos lógico o memo.
*      - No se pueden realizar busquedas en indices con claves compuestas, la busqueda
*        se realiza por el primer campo de la clave compuesta.
* - Por hacer -
* =============
*      - Implementar busqueda del siguiente registro.
*/

// Ficheros de definiciones.---------------------------------------------------
#include "oohg.ch"
#include "dbstruct.ch"
#define NO_HBPRN_DECLARATION
#include "winprint.ch"

// Estructura de la etiquetas.
#define ABM_LBL_LEN             5
#define ABM_LBL_NAME            1
#define ABM_LBL_ROW             2
#define ABM_LBL_COL             3
#define ABM_LBL_WIDTH           4
#define ABM_LBL_HEIGHT          5

// Estructura de los controles de edición.
#define ABM_CON_LEN             7
#define ABM_CON_NAME            1
#define ABM_CON_ROW             2
#define ABM_CON_COL             3
#define ABM_CON_WIDTH           4
#define ABM_CON_HEIGHT          5
#define ABM_CON_DES             6
#define ABM_CON_TYPE            7

// Tipos de controles de edición.
#define ABM_TEXTBOXC            1
#define ABM_TEXTBOXN            2
#define ABM_DATEPICKER          3
#define ABM_CHECKBOX            4
#define ABM_EDITBOX             5

// Estructura de las opciones de usuario.
#define ABM_OPC_TEXTO           1
#define ABM_OPC_BLOQUE          2

// Tipo de acción al definir las columnas del listado.
#define ABM_LIS_ADD             1
#define ABM_LIS_DEL             2

// Tipo de acción al definir los registros del listado.
#define ABM_LIS_SET1            1
#define ABM_LIS_SET2            2

// Declaración de variables globales.------------------------------------------
STATIC _cArea           AS Character            // Nombre del area de la bdd.
STATIC _aEstructura     AS Array                // Estructura de la bdd.
STATIC _aIndice         AS Array                // Nombre de los indices de la bdd.
STATIC _aIndiceCampo    AS Array                // Número del campo indice.
STATIC _nIndiceActivo   AS Array                // Indice activo.
STATIC _aNombreCampo    AS Array                // Nombre desciptivo de los campos de la bdd.
STATIC _aEditable       AS Array                // Indicador de si son editables.
STATIC _cTitulo         AS Character            // Título de la ventana.
STATIC _nAltoPantalla   AS Numeric              // Alto de la pantalla.
STATIC _nAnchoPantalla  AS Numeric              // Ancho de la pantalla.
STATIC _aEtiqueta       AS Array                // Datos de las etiquetas.
STATIC _aControl        AS Array                // Datos de los controles.
STATIC _aCampoTabla     AS Array                // Nombre de los campos para la tabla.
STATIC _aAnchoTabla     AS Array                // Anchos de los campos para la tabla.
STATIC _aCabeceraTabla  AS Array                // Texto de las columnas de la tabla.
STATIC _aAlineadoTabla  AS Array                // Alineación de las columnas de la tabla.
STATIC _aVisibleEnTabla AS Array                // Campos visibles en la tabla.
STATIC _nControlActivo  AS Numeric              // Control con foco.
STATIC _aOpciones       AS Array                // Opciones del usuario.
STATIC _bGuardar        AS Codeblock            // Acción para guardar registro.
STATIC _bBuscar         AS Codeblock            // Acción para buscar registro.
STATIC _bImprimir       AS Codeblock            // Acción para imprimir listado.
STATIC _lFiltro         AS Logical              // Indicativo de filtro activo.
STATIC _cFiltro         AS Character            // Condición de filtro.

/****************************************************************************************
*  Aplicación: Comando EDIT para MiniGUI
*       Autor: Cristóbal Mollá [cemese@terra.es]
*     Función: ABM()
* Descripción: Función inicial. Comprueba los parámetros pasados, crea la estructura
*              para las etiquetas y controles de edición y crea la ventana de visualización
*              de registro.
*  Parámetros: cArea           Nombre del area de la bdd. Por defecto se toma el area
*                              actual.
*              cTitulo         Título de la ventana de edición. Por defecto se toma el
*                              nombre de la base de datos actual.
*              aNombreCampo    Matriz de valores carácter con los nombres descriptivos de
*                              los campos de la bdd.
*              aAvisoCampo     Matriz con los textos que se presentarán en la barra de
*                              estado al editar o añadir un registro.
*              aEditable       Matriz de valóre lógicos que indica si el campo referenciado
*                              esta activo en la ventana de edición de registro.
*              aVisibleEnTabla Matriz de valores lógicos que indica la visibilidad de los
*                              campos del browse de la ventana de edición.
*              aOpciones       Matriz con los valores de las opciones de usuario.
*              bGuardar        Bloque de código para la acción de guardar registro.
*              bBuscar         Bloque de código para la acción de buscar registro.
*              bImprimir       Bloque de código para la acción imprimir.
*    Devuelve: NIL
****************************************************************************************/

FUNCTION ABM2( cArea, cTitulo, aNombreCampo, ;
      aAvisoCampo, aEditable, aVisibleEnTabla, ;
      aOpciones, bGuardar, bBuscar, ;
      bImprimir )

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL   i              as numeric       // Indice de iteración.
   LOCAL   k              as numeric       // Indice de iteración.
   LOCAL   nArea          as numeric       // Numero del area de la bdd.
   LOCAL   nRegistro      as numeric       // Número de regisrto de la bdd.
   LOCAL   lSalida        as logical       // Control de bucle.
   LOCAL   nVeces         as numeric       // Indice de iteración.
   LOCAL   cIndice        as character     // Nombre del indice.
   LOCAL   cIndiceActivo  as character     // Nombre del indice activo.
   LOCAL   cClave         as character     // Clave del indice.
   LOCAL   nInicio        as numeric       // Inicio de la cadena de busqueda.
   LOCAL   nAnchoCampo    as numeric       // Ancho del campo actual.
   LOCAL   nAnchoEtiqueta as numeric       // Ancho máximo de las etiquetas.
   LOCAL   nFila          as numeric       // Fila de creación del control de edición.
   LOCAL   nColumna       as numeric       // Columna de creación del control de edición.
   LOCAL   aTextoOp       as numeric       // Texto de las opciones de usuario.
   LOCAL   _BakExtendedNavigation          // Estado de SET NAVIAGTION.
   LOCAL _BackDeleted
   LOCAL cFiltroAnt     as character     // Condición del filtro anterior.

   ////////// Gusrdar estado actual de SET DELETED y activarlo
   _BackDeleted := set( _SET_DELETED )
   SET DELETED ON

   ////////// Desactivación de SET NAVIGATION.------------------------------------
   _BakExtendedNavigation := _OOHG_ExtendedNavigation
   _OOHG_ExtendedNavigation    := .F.

   ////////// Control de parámetros.----------------------------------------------
   // Area de la base de datos.
   IF ( ! ValType( cArea ) $ "CM" ) .or. Empty( cArea )
      _cArea := Alias()
      IF _cArea == ""
         msgExclamation( _OOHG_Messages( 11, 1 ), "EDIT EXTENDED" )

         RETURN NIL
      ENDIF
   ELSE
      _cArea := cArea
   ENDIF
   _aEstructura := (_cArea)->( dbStruct() )

   // Título de la ventana.
   IF ( cTitulo == NIL )
      _cTitulo := _cArea
   ELSE
      IF ( ! Valtype( cTitulo ) $ "CM" )
         _cTitulo := _cArea
      ELSE
         _cTitulo := cTitulo
      ENDIF
   ENDIF

   // Nombres de los campos.
   lSalida := .t.
   IF ( ValType( aNombreCampo ) != "A" )
      lSalida := .f.
   ELSE
      IF ( Len( aNombreCampo ) != Len( _aEstructura ) )
         lSalida := .f.
      ELSE
         FOR i := 1 to Len( aNombreCampo )
            IF ! ValType( aNombreCampo[i] ) $ "CM"
               lSalida := .f.
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF
   IF lSalida
      _aNombreCampo := aNombreCampo
   ELSE
      _aNombreCampo := {}
      FOR i := 1 to Len( _aEstructura )
         aAdd( _aNombreCampo, Upper( Left( _aEstructura[i,DBS_NAME], 1 ) ) + ;
            Lower( SubStr( _aEstructura[i,DBS_NAME], 2 ) ) )
      NEXT
   ENDIF

   // Texto de aviso en la barra de estado de la ventana de edición de registro.
   lSalida := .t.
   IF ( ValType( aAvisoCampo ) != "A" )
      lSalida := .f.
   ELSE
      IF ( Len( aAvisoCampo ) != Len( _aEstructura ) )
         lSalida := .f.
      ELSE
         FOR i := 1 to Len( aAvisoCampo )
            IF ! Valtype( aAvisoCampo[i] ) $ "CM"
               lSalida := .f.
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF
   IF !lSalida
      aAvisoCampo := {}
      FOR i := 1 to Len( _aEstructura )
         DO CASE
         CASE _aEstructura[i,DBS_TYPE] == "C"
            aAdd( aAvisoCampo, _OOHG_Messages( 11, 2 ) )
         CASE _aEstructura[i,DBS_TYPE] == "N"
            aAdd( aAvisoCampo, _OOHG_Messages( 11, 3 ) )
         CASE _aEstructura[i,DBS_TYPE] == "D"
            aAdd( aAvisoCampo, _OOHG_Messages( 11, 4 ) )
         CASE _aEstructura[i,DBS_TYPE] == "L"
            aAdd( aAvisoCampo, _OOHG_Messages( 11, 5 ) )
         CASE _aEstructura[i,DBS_TYPE] == "M"
            aAdd( aAvisoCampo, _OOHG_Messages( 11, 6 ) )
         OTHERWISE
            aAdd( aAvisoCampo, _OOHG_Messages( 11, 7 ) )
         ENDCASE
      NEXT
   ENDIF

   // Campos visibles en la tabla de la ventana de visualización de registros.
   lSalida := .t.
   IF ( Valtype( aVisibleEnTabla ) != "A" )
      lSalida := .f.
   ELSE
      IF Len( aVisibleEnTabla ) != Len( _aEstructura )
         lSalida := .f.
      ELSE
         FOR i := 1 to Len( aVisibleEnTabla )
            IF ValType( aVisibleEnTabla[i] ) != "L"
               lSalida := .f.
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF
   IF lSalida
      _aVisibleEnTabla := aVisibleEnTabla
   ELSE
      _aVisibleEnTabla := {}
      FOR i := 1 to Len( _aEstructura )
         aAdd( _aVisibleEnTabla, .t. )
      NEXT
   ENDIF

   // Estado de los campos en la ventana de edición de registro.
   lSalida := .t.
   IF ( ValType( aEditable ) != "A" )
      lSalida := .f.
   ELSE
      IF Len( aEditable ) != Len( _aEstructura )
         lSalida := .f.
      ELSE
         FOR i := 1 to Len( aEditable )
            IF ValType( aEditable[i] ) != "L"
               lSalida := .f.
               EXIT
            ENDIF
         NEXT
      ENDIF
   ENDIF
   IF lSalida
      _aEditable := aEditable
   ELSE
      _aEditable := {}
      FOR i := 1 to Len( _aEstructura )
         aAdd( _aEditable, .t.)
      NEXT
   ENDIF

   **** JK 104

   // Opciones del usuario.
   lSalida := .t.

   IF ValType( aOpciones ) != "A"
      lSalida := .f.
   ELSEIF len(aOpciones)<1
      lSalida := .f.
   ELSEIF Len( aOpciones[1] ) != 2
      lSalida := .f.
   ELSE
      FOR i := 1 to Len( aOpciones )
         IF ! ValType( aOpciones [i,ABM_OPC_TEXTO] ) $ "CM"
            lSalida := .f.
            EXIT
         ENDIF
         IF ValType( aOpciones [i,ABM_OPC_BLOQUE] ) != "B"
            lSalida := .f.
            EXIT
         ENDIF
      NEXT
   ENDIF

   **** END JK 104

   IF lSalida
      _aOpciones := aOpciones
   ELSE
      _aOpciones := {}
   ENDIF

   // Acción al guardar.
   IF ValType( bGuardar ) == "B"
      _bGuardar := bGuardar
   ELSE
      _bGuardar := NIL
   ENDIF

   // Acción al buscar.
   IF ValType( bBuscar ) == "B"
      _bBuscar := bBuscar
   ELSE
      _bBuscar := NIL
   ENDIF

   // Acción al buscar.
   IF ValType( bImprimir ) == "B"
      _bImprimir := bImprimir
   ELSE
      _bImprimir := NIL
   ENDIF

   ////////// Selección del area de la bdd.---------------------------------------
   nRegistro     := (_cArea)->( RecNo() )
   nArea         := Select()
   cIndiceActivo := (_cArea)->( ordSetFocus() )
   cFiltroAnt    := (_cArea)->( dbFilter() )
   dbSelectArea( _cArea )
   (_cArea)->( dbGoTop() )

   ////////// Inicialización de variables.----------------------------------------
   // Filtro.
   IF (_cArea)->( dbFilter() ) == ""
      _lFiltro := .f.
   ELSE
      _lFiltro := .t.
   ENDIF
   _cFiltro := (_cArea)->( dbFilter() )

   // Indices de la base de datos.
   lSalida       := .t.
   k             := 1
   _aIndice      := {}
   _aIndiceCampo := {}
   nVeces        := 1
   aAdd( _aIndice, _OOHG_Messages( 10, 1 ) )
   aAdd( _aIndiceCampo, 0 )
   DO WHILE lSalida
      IF ( (_cArea)->( ordName( k ) ) == "" )
         lSalida := .f.
      ELSE
         cIndice := (_cArea)->( ordName( k ) )
         aAdd( _aIndice, cIndice )
         cClave := Upper( (_cArea)->( ordKey( k ) ) )
         FOR i := 1 to Len( _aEstructura )
            IF nVeces <= 1
               nInicio := At( _aEstructura[i,DBS_NAME], cClave )
               IF nInicio != 0
                  aAdd( _aIndiceCampo, i )
                  nVeces++
               ENDIF
            ENDIF
         NEXT
      ENDIF
      k++
      nVeces := 1
   ENDDO

   // Numero de indice.
   IF ( (_cArea)->( ordSetFocus() ) == "" )
      _nIndiceActivo := 1
   ELSE
      _nIndiceActivo := aScan( _aIndice, (_cArea)->( ordSetFocus() ) )
   ENDIF

   // Tamaño de la pantalla.
   _nAltoPantalla  := getDesktopHeight()
   _nAnchoPantalla := getDesktopWidth()

   // Datos de las etiquetas y los controles de la ventana de edición.
   _aEtiqueta     := Array( Len( _aEstructura ), ABM_LBL_LEN )
   _aControl      := Array( Len( _aEstructura ), ABM_CON_LEN )
   nFila          := 10
   nColumna       := 10
   nAnchoEtiqueta := 0
   FOR i := 1 to Len( _aNombreCampo )
      nAnchoEtiqueta := iif( nAnchoEtiqueta > ( Len( _aNombreCampo[i] ) * 9 ),;
         nAnchoEtiqueta,;
         Len( _aNombreCampo[i] ) * 9 )
   NEXT
   FOR i := 1 to Len( _aEstructura )
      _aEtiqueta[i,ABM_LBL_NAME]   := "ABM2Etiqueta" + AllTrim( Str( i ,4,0) )
      _aEtiqueta[i,ABM_LBL_ROW]    := nFila
      _aEtiqueta[i,ABM_LBL_COL]    := nColumna
      _aEtiqueta[i,ABM_LBL_WIDTH]  := Len( _aNombreCampo[i] ) * 9
      _aEtiqueta[i,ABM_LBL_HEIGHT] := 25
      DO CASE
      CASE _aEstructura[i,DBS_TYPE] == "C"
         _aControl[i,ABM_CON_NAME]   := "ABM2Control" + AllTrim( Str( i ,4,0) )
         _aControl[i,ABM_CON_ROW]    := nFila
         _aControl[i,ABM_CON_COL]    := nColumna + nAnchoEtiqueta + 20
         _aControl[i,ABM_CON_WIDTH]  := iif( ( _aEstructura[i,DBS_LEN] * 10 ) < 50, 50, _aEstructura[i,DBS_LEN] * 10 )
         _aControl[i,ABM_CON_HEIGHT] := 25
         _aControl[i,ABM_CON_DES]    := aAvisoCampo[i]
         _aControl[i,ABM_CON_TYPE]   := ABM_TEXTBOXC
         nFila += 35
      CASE _aEstructura[i,DBS_TYPE] == "D"
         _aControl[i,ABM_CON_NAME]   := "ABM2Control" + AllTrim( Str( i ,4,0) )
         _aControl[i,ABM_CON_ROW]    := nFila
         _aControl[i,ABM_CON_COL]    := nColumna + nAnchoEtiqueta + 20
         _aControl[i,ABM_CON_WIDTH]  := _aEstructura[i,DBS_LEN] * 10
         _aControl[i,ABM_CON_HEIGHT] := 25
         _aControl[i,ABM_CON_DES]    := aAvisoCampo[i]
         _aControl[i,ABM_CON_TYPE]   := ABM_DATEPICKER
         nFila += 35
      CASE _aEstructura[i,DBS_TYPE] == "N"
         _aControl[i,ABM_CON_NAME]   := "ABM2Control" + AllTrim( Str( i ,4,0) )
         _aControl[i,ABM_CON_ROW]    := nFila
         _aControl[i,ABM_CON_COL]    := nColumna + nAnchoEtiqueta + 20
         _aControl[i,ABM_CON_WIDTH]  := iif( ( _aEstructura[i,DBS_LEN] * 10 ) < 50, 50, _aEstructura[i,DBS_LEN] * 10 )
         _aControl[i,ABM_CON_HEIGHT] := 25
         _aControl[i,ABM_CON_DES]    := aAvisoCampo[i]
         _aControl[i,ABM_CON_TYPE]   := ABM_TEXTBOXN
         nFila += 35
      CASE _aEstructura[i,DBS_TYPE] == "L"
         _aControl[i,ABM_CON_NAME]   := "ABM2Control" + AllTrim( Str( i ,4,0) )
         _aControl[i,ABM_CON_ROW]    := nFila
         _aControl[i,ABM_CON_COL]    := nColumna + nAnchoEtiqueta + 20
         _aControl[i,ABM_CON_WIDTH]  := 25
         _aControl[i,ABM_CON_HEIGHT] := 25
         _aControl[i,ABM_CON_DES]    := aAvisoCampo[i]
         _aControl[i,ABM_CON_TYPE]   := ABM_CHECKBOX
         nFila += 35
      CASE _aEstructura[i,DBS_TYPE] == "M"
         _aControl[i,ABM_CON_NAME]   := "ABM2Control" + AllTrim( Str( i ,4,0) )
         _aControl[i,ABM_CON_ROW]    := nFila
         _aControl[i,ABM_CON_COL]    := nColumna + nAnchoEtiqueta + 20
         _aControl[i,ABM_CON_WIDTH]  := 300
         _aControl[i,ABM_CON_HEIGHT] := 70
         _aControl[i,ABM_CON_DES]    := aAvisoCampo[i]
         _aControl[i,ABM_CON_TYPE]   := ABM_EDITBOX
         nFila += 80
      ENDCASE
   NEXT

   // Datos de la tabla de la ventana de visualización.
   _aCampoTabla    := {}
   _aAnchoTabla    := {}
   _aCabeceraTabla := {}
   _aAlineadoTabla := {}
   FOR i := 1 to Len( _aEstructura )
      IF _aVisibleEnTabla[i]
         aAdd( _aCampoTabla, _cArea + "->" + _aEstructura[i, DBS_NAME] )
         nAnchoCampo    := iif( ( _aEstructura[i,DBS_LEN] * 10 ) < 50,   ;
            50,                                    ;
            _aEstructura[i,DBS_LEN] * 10 )
         nAnchoEtiqueta := Len( _aNombreCampo[i] ) * 10
         aAdd( _aAnchoTabla, iif( nAnchoEtiqueta > nAnchoCampo,          ;
            nAnchoEtiqueta,                        ;
            nAnchoCampo ) )
         aAdd( _aCabeceraTabla, _aNombreCampo[i] )
         aAdd( _aAlineadoTabla, iif( _aEstructura[i,DBS_TYPE] == "N",     ;
            BROWSE_JTFY_RIGHT,                   ;
            BROWSE_JTFY_LEFT ) )
      ENDIF
   NEXT

   ////////// Definición de la ventana de visualización.--------------------------
   DEFINE WINDOW wndABM2Edit               ;
         at 60, 30                       ;
         width _nAnchoPantalla - 60      ;
         height _nAltoPantalla - 140     ;
         title _cTitulo                  ;
         modal                           ;
         nosize                          ;
         nosysmenu                       ;
         on init {|| ABM2Redibuja() }    ;
         on release {|| ABM2salir(nRegistro, cIndiceActivo, cFiltroAnt, nArea) }   ;
         font "ms sans serif" size 9     ;
         backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      // Define la barra de estado de la ventana de visualización.
      DEFINE STATUSBAR font "ms sans serif" size 9
         statusitem _OOHG_Messages( 10, 19 )                       // 1
         statusitem _OOHG_Messages( 10, 20 )     width 100 raised  // 2
         statusitem _OOHG_Messages( 10, 2 ) +': '     width 200 raised // 3
      END STATUSBAR

      // Define la barra de botones de la ventana de visualización.
      DEFINE TOOLBAR tbEdit buttonsize 90, 32 flat righttext border
         button tbbCerrar  caption _OOHG_Messages( 9, 1 ) ;
            picture "MINIGUI_EDIT_CLOSE"          ;
            action  wndABM2Edit.Release
         button tbbNuevo   caption _OOHG_Messages( 9, 2 ) ;
            picture "MINIGUI_EDIT_NEW"            ;
            action  {|| ABM2Editar( .t. ) }
         button tbbEditar  caption _OOHG_Messages( 9, 3 ) ;
            picture "MINIGUI_EDIT_EDIT"           ;
            action  {|| ABM2Editar( .f. ) }
         button tbbBorrar  caption _OOHG_Messages( 9, 4 ) ;
            picture "MINIGUI_EDIT_DELETE"         ;
            action  {|| ABM2Borrar() }
         button tbbBuscar  caption _OOHG_Messages( 9, 5 ) ;
            picture "MINIGUI_EDIT_FIND"           ;
            action  {|| ABM2Buscar() }
         button tbbListado caption _OOHG_Messages( 9, 6 ) ;
            picture "MINIGUI_EDIT_PRINT"          ;
            action  {|| ABM2Imprimir() }
      end toolbar

   END WINDOW

   ////////// Creación de los controles de la ventana de visualización.-----------
   @ 45, 10 frame frmEditOpciones          ;
      of wndABM2Edit                  ;
      caption ""                      ;
      width wndABM2Edit.Width - 25    ;
      height 65
   @ 112, 10 frame frmEditTabla            ;
      of wndABM2Edit                  ;
      caption ""                      ;
      width wndABM2Edit.Width - 25    ;
      height wndABM2Edit.Height - 165
   @ 60, 20 label lblIndice               ;
      of wndABM2Edit                  ;
      value _OOHG_Messages( 11, 26 )  ;
      width 150                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 75, 20 combobox cbIndices                     ;
      of wndABM2Edit                          ;
      items _aIndice                          ;
      value _nIndiceActivo                    ;
      width 150                               ;
      font "arial" size 9                     ;
      on change {|| ABM2CambiarOrden() }
   nColumna := wndABM2Edit.Width - 175
   aTextoOp := {}
   FOR i := 1 to Len( _aOpciones )
      aAdd( aTextoOp, _aOpciones[i,ABM_OPC_TEXTO] )
   NEXT
   @ 60, nColumna label lblOpciones        ;
      of wndABM2Edit                  ;
      value _OOHG_Messages( 10, 5 )   ;
      width 150                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 75, nColumna combobox cbOpciones              ;
      of wndABM2Edit                          ;
      items aTextoOp                          ;
      value 1                                 ;
      width 150                               ;
      font "arial" size 9                     ;
      on change {|| ABM2EjecutaOpcion() }
   @ 65, (wndABM2Edit.Width / 2)-110 button btnFiltro1     ;
      of wndABM2Edit                                  ;
      caption _OOHG_Messages( 9, 10 )                 ;
      action {|| ABM2ActivarFiltro() }                ;
      width 100                                       ;
      height 32                                       ;
      font "ms sans serif" size 9
   @ 65, (wndABM2Edit.Width / 2)+5 button btnFiltro2       ;
      of wndABM2Edit                                  ;
      caption _OOHG_Messages( 9, 11 )                 ;
      action {|| ABM2DesactivarFiltro() }             ;
      width 100                                       ;
      height 32                                       ;
      font "ms sans serif" size 9
   @ 132, 20 browse brwABM2Edit                                                    ;
      of wndABM2Edit                                                          ;
      width wndABM2Edit.Width - 45                                            ;
      height wndABM2Edit.Height - 195                                         ;
      headers _aCabeceraTabla                                                 ;
      widths _aAnchoTabla                                                     ;
      workarea &_cArea                                                        ;
      fields _aCampoTabla                                                     ;
      value ( _cArea)->( RecNo() )                                            ;
      font "arial" size 9                                                     ;
      on change {|| (_cArea)->( dbGoto( wndABM2Edit.brwABM2Edit.Value ) ),    ;
      ABM2Redibuja( .f. ) }                                     ;
      on dblclick ABM2Editar( .f. )                                           ;
      justify _aAlineadoTabla

   // Comprueba el estado de las opciones de usuario.
   IF Len( _aOpciones ) == 0
      wndABM2Edit.cbOpciones.Enabled := .f.
   ENDIF

   ////////// Activación de la ventana de visualización.--------------------------
   ACTIVATE WINDOW wndABM2Edit

   ////////// Restauración de SET NAVIGATION.-------------------------------------
   _OOHG_ExtendedNavigation := _BakExtendedNavigation

   ////////// Restaurar SET DELETED a su valor inicial

   set( _SET_DELETED , _BackDeleted  )

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2salir()
   * Descripción: Cierra la ventana de visualización de registros y sale.
   *  Parámetros: Ninguno.
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2salir( nRegistro, cIndiceActivo, cFiltroAnt, nArea )

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL bFiltroAnt as codeblock           // Bloque de código del filtro.

   ////////// Inicialización de variables.----------------------------------------
   bFiltroAnt := iif( Empty( cFiltroAnt ),;
      &("{||NIL}"),;
      &("{||" + cFiltroAnt + "}") )

   ////////// Restaura el area de la bdd inicial.---------------------------------
   (_cArea)->( dbGoTo( nRegistro ) )
   (_cArea)->( ordSetFocus( cIndiceActivo ) )
   (_cArea)->( dbSetFilter( bFiltroAnt, cFiltroAnt ) )
   dbSelectArea( nArea )

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2Redibuja()
   * Descripción: Actualización de la ventana de visualización de registros.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2Redibuja( lTabla )

   ////////// Control de parámetros.----------------------------------------------
   IF ValType( lTabla ) != "L"
      lTabla := .f.
   ENDIF

   ////////// Refresco de la barra de botones.------------------------------------
   IF (_cArea)->( RecCount() ) == 0
      wndABM2Edit.tbbEditar.Enabled  := .f.
      wndABM2Edit.tbbBorrar.Enabled  := .f.
      wndABM2Edit.tbbBuscar.Enabled  := .f.
      wndABM2Edit.tbbListado.Enabled := .f.
   ELSE
      wndABM2Edit.tbbEditar.Enabled  := .t.
      wndABM2Edit.tbbBorrar.Enabled  := .t.
      wndABM2Edit.tbbBuscar.Enabled  := .t.
      wndABM2Edit.tbbListado.Enabled := .t.
   ENDIF

   ////////// Refresco de la barra de estado.-------------------------------------
   wndABM2Edit.StatusBar.Item( 1 ) := _OOHG_Messages( 10, 19 ) + _cFiltro
   wndABM2Edit.StatusBar.Item( 2 ) := _OOHG_Messages( 10, 20 ) + iif( _lFiltro, _OOHG_Messages( 11, 29 ), _OOHG_Messages( 11, 30 ) )
   wndABM2Edit.StatusBar.Item( 3 ) := _OOHG_Messages( 10, 2 ) + ': '+                                  ;
      AllTrim( Str( (_cArea)->( RecNo() ) ) ) + "/" + ;
      AllTrim( Str( (_cArea)->( RecCount() ) ) )

   ////////// Refresca el browse si se indica.
   IF lTabla
      wndABM2Edit.brwABM2Edit.Value := (_cArea)->( RecNo() )
      wndABM2Edit.brwABM2Edit.Refresh
   ENDIF

   ////////// Coloca el foco en el browse.
   wndABM2Edit.brwABM2Edit.SetFocus

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2CambiarOrden()
   * Descripción: Cambia el orden activo.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2CambiarOrden()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL cIndice as character              // Nombre del indice.
   LOCAL nIndice as numeric                // Número del indice.

   ////////// Inicializa las variables.-------------------------------------------
   nIndice := wndABM2Edit.cbIndices.Value
   cIndice := wndABM2Edit.cbIndices.Item( nIndice )
   Empty( cIndice )

   ////////// Cambia el orden del area de trabajo.--------------------------------
   nIndice--
   (_cArea)->( ordSetFocus( nIndice ) )
   // (_cArea)->( dbGoTop() )
   nIndice++
   _nIndiceActivo := nIndice
   ABM2Redibuja( .t. )

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2EjecutaOpcion()
   * Descripción: Ejecuta las opciones del usuario.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2EjecutaOpcion()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL nItem    as numeric               // Numero del item seleccionado.
   LOCAL bBloque  as codebloc              // Bloque de codigo a ejecutar.

   ////////// Inicialización de variables.----------------------------------------
   nItem   := wndABM2Edit.cbOpciones.Value
   bBloque := _aOpciones[nItem,ABM_OPC_BLOQUE]

   ////////// Ejecuta la opción.--------------------------------------------------
   Eval( bBloque )

   ////////// Refresca el browse.
   ABM2Redibuja( .t. )

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2Editar( lNuevo )
   * Descripción: Creación de la ventana de edición de registro.
   *  Parámetros: lNuevo          Valor lógico que indica si se está añadiendo un registro
   *                              o editando el actual.
   *    Devuelve:
   ****************************************************************************************/

STATIC FUNCTION ABM2Editar( lNuevo )

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL i              as numeric         // Indice de iteración.
   LOCAL nAnchoEtiqueta as numeric         // Ancho máximo de las etiquetas.
   LOCAL nAltoControl   as numeric         // Alto total de los controles de edición.
   LOCAL nAncho         as numeric         // Ancho de la ventana de edición .
   LOCAL nAlto          as numeric         // Alto de la ventana de edición.
   LOCAL nAnchoTope     as numeric         // Ancho máximo de la ventana de edición.
   LOCAL nAltoTope      as numeric         // Alto máximo de la ventana de edición.
   LOCAL nAnchoSplit    as numeric         // Ancho de la ventana Split.
   LOCAL nAltoSplit     as numeric         // Alto de la ventana Split.
   LOCAL cTitulo        as character       // Título de la ventana.
   LOCAL cMascara       as array           // Máscara de edición de los controles numéricos.
   LOCAL NANCHOCONTROL

   wndabm2edit.tbbNuevo.enabled:=.F.
   wndabm2edit.tbbEditar.enabled:=.F.
   wndabm2edit.tbbBorrar.enabled:=.F.
   wndabm2edit.tbbBuscar.enabled:=.F.
   wndabm2edit.tbbListado.enabled:=.F.

   ////////// Control de parámetros.----------------------------------------------
   IF ( ValType( lNuevo ) != "L" )
      lNuevo := .t.
   ENDIF

   ////////// Incialización de variables.-----------------------------------------
   nAnchoEtiqueta := 0
   nAnchoControl  := 0
   nAltoControl   := 0
   FOR i := 1 to Len( _aEtiqueta )
      nAnchoEtiqueta := iif( nAnchoEtiqueta > _aEtiqueta[i,ABM_LBL_WIDTH],;
         nAnchoEtiqueta,;
         _aEtiqueta[i,ABM_LBL_WIDTH] )
      nAnchoControl  := iif( nAnchoControl > _aControl[i,ABM_CON_WIDTH],;
         nAnchoControl,;
         _aControl[i,ABM_CON_WIDTH] )
      nAltoControl   += _aControl[i,ABM_CON_HEIGHT] + 10
   NEXT
   nAltoSplit  := 10 + nAltoControl + 10 + 15
   nAnchoSplit := 10 + nAnchoEtiqueta + 10 + nAnchoControl + 10 + 15
   nAlto       := 15 + 65 + nAltoSplit + 15
   nAltoTope   := _nAltoPantalla - 130
   nAncho      := 15 + nAnchoSplit + 15
   nAncho      := iif( nAncho < 300, 300, nAncho )
   nAnchoTope  := _nAnchoPantalla - 60
   cTitulo     := iif( lNuevo, _OOHG_Messages( 10, 6 ), _OOHG_Messages( 10, 7 ) )

   ////////// Define la ventana de edición de registro.---------------------------
   DEFINE WINDOW wndABM2EditNuevo                                  ;
         at 70, 40                                               ;
         width iif( nAncho > nAnchoTope, nAnchoTope, nAncho )    ;
         height iif( nAlto > nAltoTope, nAltoTope, nAlto )       ;
         title cTitulo                                           ;
         modal                                                   ;
         nosize                                                  ;
         nosysmenu                                               ;
         font "ms sans serif" size 9                             ;
         backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      // Define la barra de estado de la ventana de edición de registro.
      DEFINE STATUSBAR font "ms sans serif" size 9
         statusitem ""
      END STATUSBAR

      DEFINE SPLITBOX

         // Define la barra de botones de la ventana de edición de registro.
         DEFINE TOOLBAR tbEditNuevo buttonsize 90, 32 flat righttext
            button tbbCancelar caption _OOHG_Messages( 9, 7 ) ;
               picture "MINIGUI_EDIT_CANCEL"        ;
               action  wndABM2EditNuevo.Release
            button tbbAceptar  caption _OOHG_Messages( 9, 8 ) ;
               picture "MINIGUI_EDIT_OK"            ;
               action  ABM2EditarGuardar( lNuevo )
            button tbbCopiar   caption _OOHG_Messages( 9, 9 ) ;
               picture "MINIGUI_EDIT_COPY"          ;
               action  ABM2EditarCopiar()
         end toolbar

         // Define la ventana donde van contenidos los controles de edición.
         DEFINE WINDOW wndABM2EditNuevoSplit             ;
               width iif( nAncho > nAnchoTope,         ;
               nAnchoTope - 10,             ;
               nAnchoSplit  - 1 )           ;
               height iif( nAlto > nAltoTope,          ;
               nAltoTope - 95,             ;
               nAltoSplit - 1 )            ;
               virtual width nAnchoSplit               ;
               virtual height nAltoSplit               ;
               splitchild                              ;
               nocaption                               ;
               font "ms sans serif" size 9             ;
               focused                                 ;
               backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

         END WINDOW
      END SPLITBOX
   END WINDOW

   ////////// Define las etiquetas de los controles.------------------------------
   FOR i := 1 to Len( _aEtiqueta )

      @ _aEtiqueta[i,ABM_LBL_ROW], _aEtiqueta[i,ABM_LBL_COL]  ;
         LABEL &( _aEtiqueta[i,ABM_LBL_NAME] )           ;
         of wndABM2EditNuevoSplit                        ;
         value _aNombreCampo[i]                          ;
         width _aEtiqueta[i,ABM_LBL_WIDTH]               ;
         height _aEtiqueta[i,ABM_LBL_HEIGHT]             ;
         font "ms sans serif" size 9
   NEXT

   ////////// Define los controles de edición.------------------------------------
   FOR i := 1 to Len( _aControl )
      DO CASE
      CASE _aControl[i,ABM_CON_TYPE] == ABM_TEXTBOXC

         @ _aControl[i,ABM_CON_ROW], _aControl[i,ABM_CON_COL]    ;
            textbox &( _aControl[i,ABM_CON_NAME] )          ;
            of wndABM2EditNuevoSplit                        ;
            value ""                                        ;
            height _aControl[i,ABM_CON_HEIGHT]              ;
            width _aControl[i,ABM_CON_WIDTH]                ;
            font "arial" size 9                             ;
            maxlength _aEstructura[i,DBS_LEN]               ;
            on gotfocus ABM2ConFoco()                       ;
            on lostfocus ABM2SinFoco()                      ;
            on enter ABM2AlEntrar( )
      CASE _aControl[i,ABM_CON_TYPE] == ABM_DATEPICKER
         @ _aControl[i,ABM_CON_ROW], _aControl[i,ABM_CON_COL]    ;
            datepicker &( _aControl[i,ABM_CON_NAME] )       ;
            of wndABM2EditNuevoSplit                        ;
            height _aControl[i,ABM_CON_HEIGHT]              ;
            width _aControl[i,ABM_CON_WIDTH] + 25           ;
            font "arial" size 9                             ;
            SHOWNONE                ;
            on gotfocus ABM2ConFoco()                       ;
            on lostfocus ABM2SinFoco()
      CASE _aControl[i,ABM_CON_TYPE] == ABM_TEXTBOXN
         IF ( _aEstructura[i,DBS_DEC] == 0 )
            @ _aControl[i,ABM_CON_ROW], _aControl[i,ABM_CON_COL]    ;
               textbox &( _aControl[i,ABM_CON_NAME] )          ;
               of wndABM2EditNuevoSplit                        ;
               value ""                                        ;
               height _aControl[i,ABM_CON_HEIGHT]              ;
               width _aControl[i,ABM_CON_WIDTH]                ;
               numeric                                         ;
               font "arial" size 9                             ;
               maxlength _aEstructura[i,DBS_LEN]               ;
               on gotfocus ABM2ConFoco( i )                    ;
               on lostfocus ABM2SinFoco( i )                   ;
               on enter ABM2AlEntrar()
         ELSE
            cMascara := Replicate( "9", _aEstructura[i,DBS_LEN] -   ;
               ( _aEstructura[i,DBS_DEC] + 1 ) )
            cMascara += "."
            cMascara += Replicate( "9", _aEstructura[i,DBS_DEC] )
            @ _aControl[i,ABM_CON_ROW], _aControl[i,ABM_CON_COL]    ;
               textbox &( _aControl[i,ABM_CON_NAME] )          ;
               of wndABM2EditNuevoSplit                        ;
               value ""                                        ;
               height _aControl[i,ABM_CON_HEIGHT]              ;
               width _aControl[i,ABM_CON_WIDTH]                ;
               numeric                                         ;
               inputmask cMascara                              ;
               on gotfocus ABM2ConFoco()                       ;
               on lostfocus ABM2SinFoco()                      ;
               on enter ABM2AlEntrar()
         ENDIF
      CASE _aControl[i,ABM_CON_TYPE] == ABM_CHECKBOX
         @ _aControl[i,ABM_CON_ROW], _aControl[i,ABM_CON_COL]    ;
            checkbox &( _aControl[i,ABM_CON_NAME] )         ;
            of wndABM2EditNuevoSplit                        ;
            caption ""                                      ;
            height _aControl[i,ABM_CON_HEIGHT]              ;
            width _aControl[i,ABM_CON_WIDTH]                ;
            value .f.                                       ;
            on gotfocus ABM2ConFoco()                       ;
            on lostfocus ABM2SinFoco()
      CASE _aControl[i,ABM_CON_TYPE] == ABM_EDITBOX
         @ _aControl[i,ABM_CON_ROW], _aControl[i,ABM_CON_COL]    ;
            editbox &( _aControl[i,ABM_CON_NAME] )          ;
            of wndABM2EditNuevoSplit                        ;
            width _aControl[i,ABM_CON_WIDTH]                ;
            height _aControl[i,ABM_CON_HEIGHT]              ;
            value ""                                        ;
            font "arial" size 9                             ;
            on gotfocus ABM2ConFoco()                       ;
            on lostfocus ABM2SinFoco()
      ENDCASE
   NEXT

   ////////// Actualiza los controles si se está editando.------------------------
   IF !lNuevo
      FOR i := 1 to Len( _aControl )
         wndABM2EditNuevoSplit.&( _aControl[i,ABM_CON_NAME] ).Value := ;
            (_cArea)->( FieldGet( i ) )
      NEXT
   ENDIF

   ////////// Establece el estado inicial de los controles.-----------------------
   FOR i := 1 to Len( _aControl )
      wndABM2EditNuevoSplit.&( _aControl[i,ABM_CON_NAME] ).Enabled := _aEditable[i]
   NEXT

   ////////// Establece el estado del botón de copia.-----------------------------
   IF !lNuevo
      wndABM2EditNuevo.tbbCopiar.Enabled := .f.
   ENDIF

   ////////// Activa la ventana de edición de registro.---------------------------
   ACTIVATE WINDOW wndABM2EditNuevo
   wndabm2edit.tbbNuevo.enabled:=.t.
   wndabm2edit.tbbEditar.enabled:=.t.
   wndabm2edit.tbbBorrar.enabled:=.t.
   wndabm2edit.tbbBuscar.enabled:=.t.
   wndabm2edit.tbbListado.enabled:=.t.

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2ConFoco()
   * Descripción: Actualiza las etiquetas de los controles y presenta los mensajes en la
   *              barra de estado de la ventana de edición de registro al obtener un
   *              control de edición el foco.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2ConFoco()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL i         as numeric              // Indice de iteración.
   LOCAL cControl  as character            // Nombre del control activo.
   LOCAL acControl as array                // Matriz con los nombre de los controles.

   ////////// Inicialización de variables.----------------------------------------
   cControl := This.Name
   acControl := {}
   FOR i := 1 to Len( _aControl )
      aAdd( acControl, _aControl[i,ABM_CON_NAME] )
   NEXT
   _nControlActivo := aScan( acControl, cControl )

   ////////// Pone la etiqueta en negrita.----------------------------------------
   IF _ncontrolactivo>0
      wndABM2EditNuevoSplit.&( _aEtiqueta[_nControlActivo,ABM_LBL_NAME] ).FontBold := .t.

      ////////// Presenta el mensaje en la barra de estado.--------------------------
      wndABM2EditNuevo.StatusBar.Item( 1 ) := _aControl[_nControlActivo,ABM_CON_DES]
   ENDIF

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2SinFoco()
   * Descripción: Restaura el estado de las etiquetas y de la barra de estado de la ventana
   *              de edición de registros al dejar un control de edición sin foco.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2SinFoco()

   ////////// Restaura el estado de la etiqueta.----------------------------------
   IF _ncontrolactivo>0
      wndABM2EditNuevoSplit.&( _aEtiqueta[_nControlActivo,ABM_LBL_NAME] ).FontBold := .f.
   ENDIF
   ////////// Restaura el texto de la barra de estado.----------------------------
   wndABM2EditNuevo.StatusBar.Item( 1 ) := ""

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2AlEntrar()
   * Descripción: Cambia al siguiente control de edición tipo TEXTBOX al pulsar la tecla
   *              ENTER.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2AlEntrar()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL lSalida   as logical              // * Tipo de salida.
   LOCAL nTipo     as numeric              // * Tipo del control.

   ////////// Inicializa las variables.-------------------------------------------
   lSalida  := .t.

   ////////// Restaura el estado de la etiqueta.----------------------------------
   IF _ncontrolactivo>0
      wndABM2EditNuevoSplit.&( _aEtiqueta[_nControlActivo,ABM_LBL_NAME] ).FontBold := .f.
   ENDIF
   ////////// Activa el siguiente control editable con evento ON ENTER.-----------
   DO WHILE lSalida
      _nControlActivo++
      IF _nControlActivo > Len( _aControl )
         _nControlActivo := 1
      ENDIF
      IF _ncontrolactivo>0
         nTipo := _aControl[_nControlActivo,ABM_CON_TYPE]
      ENDIF
      IF nTipo == ABM_TEXTBOXC .or. nTipo == ABM_TEXTBOXN
         IF _aEditable[_nControlActivo]
            lSalida := .f.
         ENDIF
      ENDIF
   ENDDO
   IF _ncontrolactivo>0
      wndABM2EditNuevoSplit.&( _aControl[_nControlActivo,ABM_CON_NAME] ).SetFocus
   ENDIF

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2EditarGuardar( lNuevo )
   * Descripción: Añade o guarda el registro en la bdd.
   *  Parámetros: lNuevo          Valor lógico que indica si se está añadiendo un registro
   *                              o editando el actual.
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2EditarGuardar( lNuevo )

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL i          as numeric             // * Indice de iteración.
   LOCAL xValor                            // * Valor a guardar.
   LOCAL lResultado as logical             // * Resultado del bloque del usuario.
   LOCAL aValores   as array               // * Valores del registro.

   ////////// Guarda el registro.-------------------------------------------------
   IF _bGuardar == NIL

      // No hay bloque de código del usuario.
      IF lNuevo
         (_cArea)->( dbAppend() )
      ENDIF

      IF (_cArea)->(rlock())

         FOR i := 1 to Len( _aEstructura )
            xValor := wndABM2EditNuevoSplit.&( _aControl[i,ABM_CON_NAME] ).Value
            (_cArea)->( FieldPut( i, xValor ) )
         NEXT

         UNLOCK

         // Refresca la ventana de visualización.
         wndABM2EditNuevo.Release
         ABM2Redibuja( .t. )

      ELSE
         Msgstop ('Record locked by another user')
      ENDIF
   ELSE

      // Hay bloque de código del usuario.
      aValores := {}
      FOR i := 1 to Len( _aControl )
         xValor := wndABM2EditNuevoSplit.&( _aControl[i,ABM_CON_NAME] ).Value
         aAdd( aValores, xValor )
      NEXT
      lResultado := Eval( _bGuardar, aValores, lNuevo )
      IF ValType( lResultado ) != "L"
         lResultado := .t.
      ENDIF

      // Refresca la ventana de visualización.
      IF lResultado
         wndABM2EditNuevo.Release
         ABM2Redibuja( .t. )
      ENDIF
   ENDIF

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2Seleccionar()
   * Descripción: Presenta una ventana para la selección de un registro.
   *  Parámetros: Ninguno
   *    Devuelve: [nReg]          Numero de registro seleccionado, o cero si no se ha
   *                              seleccionado ninguno.
   ****************************************************************************************/

STATIC FUNCTION ABM2Seleccionar()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL lSalida   as logical              // Control de bucle.
   LOCAL nReg      as numeric              // Valores del registro
   LOCAL nRegistro as numeric              // Número de registro.

   ////////// Inicialización de variables.----------------------------------------
   lSalida   := .f.
   nReg      := 0
   nRegistro := (_cArea)->( RecNo() )

   ////////// Se situa en el primer registro.-------------------------------------
   (_cArea)->( dbGoTop() )

   ////////// Creación de la ventana de selección de registro.--------------------
   DEFINE WINDOW wndSeleccionar            ;
         at 0, 0                         ;
         width 500                       ;
         height 300                      ;
         title _OOHG_Messages( 10, 8 )   ;
         modal                           ;
         nosize                          ;
         nosysmenu                       ;
         font "ms sans serif" size 9     ;
         backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      // Define la barra de botones de la ventana de selección.
      DEFINE TOOLBAR tbSeleccionar buttonsize 90, 32 flat righttext border
         button tbbCancelarSel caption _OOHG_Messages( 9, 7 ) ;
            picture "MINIGUI_EDIT_CANCEL"             ;
            action  {|| lSalida := .f.,               ;
            nReg    := 0,                 ;
            wndSeleccionar.Release }
         button tbbAceptarSel  caption _OOHG_Messages( 9, 8 ) ;
            picture "MINIGUI_EDIT_OK"                                         ;
            action  {|| lSalida := .t.,                                       ;
            nReg    := wndSeleccionar.brwSeleccionar.Value,       ;
            wndSeleccionar.Release }
      end toolbar

      // Define la barra de estado de la ventana de selección.
      DEFINE STATUSBAR font "ms sans serif" size 9
         statusitem _OOHG_Messages( 11, 7 )
      END STATUSBAR

      // Define la tabla de la ventana de selección.
      @ 55, 20 browse brwSeleccionar                                          ;
         width 460                                                       ;
         height 190                                                      ;
         headers _aCabeceraTabla                                         ;
         widths _aAnchoTabla                                             ;
         workarea &_cArea                                                ;
         fields _aCampoTabla                                             ;
         value (_cArea)->( RecNo() )                                     ;
         font "arial" size 9                                             ;
         on dblclick {|| lSalida := .t.,                                 ;
         nReg := wndSeleccionar.brwSeleccionar.Value,    ;
         wndSeleccionar.Release }                        ;
         justify _aAlineadoTabla

   END WINDOW

   ////////// Activa la ventana de selección de registro.-------------------------
   CENTER WINDOW wndSeleccionar
   ACTIVATE WINDOW wndSeleccionar

   ////////// Restuara el puntero de registro.------------------------------------
   (_cArea)->( dbGoTo( nRegistro ) )

   RETURN ( nReg )

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2EditarCopiar()
   * Descripción: Copia el registro seleccionado en los controles de edición del nuevo
   *              registro.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2EditarCopiar()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL i         as numeric              // Indice de iteración.
   LOCAL nRegistro as numeric              // Puntero de registro.
   LOCAL nReg      as numeric              // Numero de registro.

   ////////// Obtiene el registro a copiar.---------------------------------------
   nReg := ABM2Seleccionar()

   ////////// Actualiza los controles de edición.---------------------------------
   IF nReg != 0
      nRegistro := (_cArea)->( RecNo() )
      (_cArea)->( dbGoTo( nReg ) )
      FOR i := 1 to Len( _aControl )
         IF _aEditable[i]
            wndABM2EditNuevoSplit.&( _aControl[i,ABM_CON_NAME] ).Value := ;
               (_cArea)->( FieldGet( i ) )
         ENDIF
      NEXT
      (_cArea)->( dbGoTo( nRegistro ) )
   ENDIF

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2Borrar()
   * Descripción: Borra el registro activo.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

FUNCTION ABM2Borrar()

   ////////// Declaración de variables locales.-----------------------------------

   ////////// Borra el registro si se acepta.-------------------------------------

   IF MsgOKCancel( _OOHG_Messages( 11, 8 ), _OOHG_Messages( 10, 16 ) )
      IF (_cArea)->( rlock() )
         (_cArea)->( dbDelete() )
         (_cArea)->( dbCommit() )
         (_cArea)->( dbunlock() )
         IF .not. set( _SET_DELETED )
            SET DELETED ON
         ENDIF
         (_cArea)->( dbSkip() )
         IF (_cArea)->( eof() )
            (_cArea)->( dbGoBottom() )
         ENDIF
         ABM2Redibuja( .t. )
      ELSE
         Msgstop( _OOHG_Messages( 11, 41 ), _cTitulo )
         wndabm2edit.tbbNuevo.enabled:=.t.
         wndabm2edit.tbbEditar.enabled:=.t.
         wndabm2edit.tbbBorrar.enabled:=.t.
         wndabm2edit.tbbBuscar.enabled:=.t.
         wndabm2edit.tbbListado.enabled:=.t.
      ENDIF
   ENDIF

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2Buscar()
   * Descripción: Busca un registro por la clave del indice activo.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2Buscar()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL nControl   as numeric             // Numero del control.
   LOCAL lSalida    as logical             // Tipo de salida de la ventana.
   LOCAL xValor                            // Valor de busqueda.
   LOCAL cMascara   as character           // Mascara de edición del control.
   LOCAL lResultado as logical             // Resultado de la busqueda.
   LOCAL nRegistro  as numeric             // Numero de registro.

   wndabm2edit.tbbNuevo.enabled:=.F.
   wndabm2edit.tbbEditar.enabled:=.F.
   wndabm2edit.tbbBorrar.enabled:=.F.
   wndabm2edit.tbbBuscar.enabled:=.F.
   wndabm2edit.tbbListado.enabled:=.F.

   ////////// Inicialización de variables.----------------------------------------
   nControl := _aIndiceCampo[_nIndiceActivo]

   ////////// Comprueba si se ha pasado una acción del usuario.--------------------
   IF _bBuscar != NIL
      // msgInfo( "ON FIND" )
      Eval( _bBuscar )
      ABM2Redibuja( .t. )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   ////////// Comprueba si hay un indice activo.----------------------------------
   IF _nIndiceActivo == 1
      msgExclamation( _OOHG_Messages( 11, 9 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   ////////// Comprueba que el campo indice no es del tipo memo o logico.---------
   IF _aEstructura[nControl,DBS_TYPE] == "L" .or. _aEstructura[nControl,DBS_TYPE] == "M"
      msgExclamation( _OOHG_Messages( 11, 10 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   ////////// Crea la ventana de busqueda.----------------------------------------
   DEFINE WINDOW wndABMBuscar              ;
         at 0, 0                         ;
         width 500                       ;
         height 170                      ;
         title _OOHG_Messages( 10, 9 )   ;
         modal                           ;
         nosize                          ;
         nosysmenu                       ;
         font "ms sans serif" size 9     ;
         backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      // Define la barra de botones de la ventana de busqueda.
      DEFINE TOOLBAR tbBuscar buttonsize 90, 32 flat righttext border
         button tbbCancelarBus caption _OOHG_Messages( 9, 7 ) ;
            picture "MINIGUI_EDIT_CANCEL"                     ;
            action  {|| lSalida := .f.,                       ;
            xValor := wndABMBuscar.conBuscar.Value,  ;
            wndABMBuscar.Release }
         button tbbAceptarBus  caption _OOHG_Messages( 9, 8 ) ;
            picture "MINIGUI_EDIT_OK"                         ;
            action  {|| lSalida := .t.,                       ;
            xValor := wndABMBuscar.conBuscar.Value,  ;
            wndABMBuscar.Release }
      end toolbar

      // Define la barra de estado de la ventana de busqueda.
      DEFINE STATUSBAR font "ms sans serif" size 9
         statusitem ""
      END STATUSBAR
   END WINDOW

   ////////// Crea los controles de la ventana de busqueda.-----------------------
   // Frame.
   @ 45, 10 frame frmBuscar                        ;
      of wndABMBuscar                         ;
      caption ""                              ;
      width wndABMBuscar.Width - 25           ;
      height wndABMBuscar.Height - 100

   // Etiqueta.
   @ 60, 20 label lblBuscar                                ;
      of wndABMBuscar                                 ;
      value _aNombreCampo[nControl]                   ;
      width _aEtiqueta[nControl,ABM_LBL_WIDTH]        ;
      height _aEtiqueta[nControl,ABM_LBL_HEIGHT]      ;
      font "ms sans serif" size 9

   // Tipo de dato a buscar.
   DO CASE

      // Carácter.
   CASE _aControl[nControl,ABM_CON_TYPE] == ABM_TEXTBOXC
      @ 75, 20  textbox conBuscar                             ;
         of wndABMBuscar                                    ;
         value ""                                        ;
         height _aControl[nControl,ABM_CON_HEIGHT]       ;
         width _aControl[nControl,ABM_CON_WIDTH]         ;
         font "arial" size 9                             ;
         maxlength _aEstructura[nControl,DBS_LEN]

      // Fecha.
   CASE _aControl[nControl,ABM_CON_TYPE] == ABM_DATEPICKER
      @ 75, 20 datepicker conBuscar                           ;
         of wndABMBuscar                                    ;
         value Date()                                    ;
         height _aControl[nControl,ABM_CON_HEIGHT]       ;
         width _aControl[nControl,ABM_CON_WIDTH] + 25    ;
         font "arial" size 9

      // Numerico.
   CASE _aControl[nControl,ABM_CON_TYPE] == ABM_TEXTBOXN
      IF ( _aEstructura[nControl,DBS_DEC] == 0 )

         // Sin decimales.
         @ 75, 20 textbox conBuscar                              ;
            of wndABMBuscar                                    ;
            value ""                                        ;
            height _aControl[nControl,ABM_CON_HEIGHT]       ;
            width _aControl[nControl,ABM_CON_WIDTH]         ;
            numeric                                         ;
            font "arial" size 9                             ;
            maxlength _aEstructura[nControl,DBS_LEN]
      ELSE

         // Con decimales.
         cMascara := Replicate( "9", _aEstructura[nControl,DBS_LEN] - ;
            ( _aEstructura[nControl,DBS_DEC] + 1 ) )
         cMascara += "."
         cMascara += Replicate( "9", _aEstructura[nControl,DBS_DEC] )
         @ 75, 20 textbox conBuscar                              ;
            of wndABMBuscar                                    ;
            value ""                                        ;
            height _aControl[nControl,ABM_CON_HEIGHT]       ;
            width _aControl[nControl,ABM_CON_WIDTH]         ;
            numeric                                         ;
            inputmask cMascara
      ENDIF
   ENDCASE

   ////////// Actualiza la barra de estado.---------------------------------------
   wndABMBuscar.StatusBar.Item( 1 ) := _aControl[nControl,ABM_CON_DES]

   ////////// Comprueba el tamaño del control de edición del dato a buscar.-------
   IF wndABMBuscar.conBuscar.Width > wndABM2Edit.Width - 45
      wndABMBuscar.conBuscar.Width := wndABM2Edit.Width - 45
   ENDIF

   ////////// Activa la ventana de busqueda.--------------------------------------
   CENTER WINDOW wndABMBuscar
   ACTIVATE WINDOW wndABMBuscar

   ////////// Busca el registro.--------------------------------------------------
   IF lSalida
      nRegistro := (_cArea)->( RecNo() )
      lResultado := (_cArea)->( dbSeek( xValor ) )
      IF !lResultado
         msgExclamation( _OOHG_Messages( 11, 11 ), _cTitulo )
         (_cArea)->( dbGoTo( nRegistro ) )
      ELSE
         ABM2Redibuja( .t. )
      ENDIF
   ENDIF

   wndabm2edit.tbbNuevo.enabled:=.t.
   wndabm2edit.tbbEditar.enabled:=.t.
   wndabm2edit.tbbBorrar.enabled:=.t.
   wndabm2edit.tbbBuscar.enabled:=.t.
   wndabm2edit.tbbListado.enabled:=.t.

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2Filtro()
   * Descripción: Filtra la base de datos.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2ActivarFiltro()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL aCompara   as array               // Comparaciones.
   LOCAL aCampos    as array               // Nombre de los campos.

   wndabm2edit.tbbNuevo.enabled:=.F.
   wndabm2edit.tbbEditar.enabled:=.F.
   wndabm2edit.tbbBorrar.enabled:=.F.
   wndabm2edit.tbbBuscar.enabled:=.F.
   wndabm2edit.tbbListado.enabled:=.F.

   ////////// Comprueba que no hay ningun filtro activo.--------------------------
   IF _cFiltro != ""
      MsgInfo( _OOHG_Messages( 11, 34 ), '' )
   ENDIF

   ////////// Inicialización de variables.----------------------------------------
   aCampos    := _aNombreCampo
   aCompara   := { _OOHG_Messages( 10, 27 ),;
      _OOHG_Messages( 10, 28 ),;
      _OOHG_Messages( 10, 29 ),;
      _OOHG_Messages( 10, 30 ),;
      _OOHG_Messages( 10, 31 ),;
      _OOHG_Messages( 10, 32 ) }

   ////////// Crea la ventana de filtrado.----------------------------------------
   DEFINE WINDOW wndABM2Filtro                     ;
         at 0, 0                                 ;
         width 400                               ;
         height 325                              ;
         title _OOHG_Messages( 10, 21 )          ;
         modal                                   ;
         nosize                                  ;
         nosysmenu                               ;
         on init {|| ABM2ControlFiltro() }       ;
         font "ms sans serif" size 9             ;
         backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      // Define la barra de botones de la ventana de filtrado.
      DEFINE TOOLBAR tbBuscar buttonsize 90, 32 flat righttext border
         button tbbCancelarFil caption _OOHG_Messages( 9, 7 ) ;
            picture "MINIGUI_EDIT_CANCEL"     ;
            action  {|| wndABM2Filtro.Release,;
            ABM2Redibuja( .f. ) }
         button tbbAceptarFil  caption _OOHG_Messages( 9, 8 ) ;
            picture "MINIGUI_EDIT_OK"         ;
            action  {|| ABM2EstableceFiltro() }
      end toolbar

      // Define la barra de estado de la ventana de filtrado.
      DEFINE STATUSBAR font "ms sans serif" size 9
         statusitem ""
      END STATUSBAR
   END WINDOW

   ////////// Controles de la ventana de filtrado.
   // Frame.
   @ 45, 10 frame frmFiltro                        ;
      of wndABM2Filtro                        ;
      caption ""                              ;
      width wndABM2Filtro.Width - 25          ;
      height wndABM2Filtro.Height - 100
   @ 65, 20 label lblCampos                ;
      of wndABM2Filtro                ;
      value _OOHG_Messages( 10, 22 )  ;
      width 140                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 65, 220 label lblCompara              ;
      of wndABM2Filtro                ;
      value _OOHG_Messages( 10, 23 )  ;
      width 140                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 200, 20 label lblValor                ;
      of wndABM2Filtro                ;
      value _OOHG_Messages( 10, 24 )  ;
      width 140                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 85, 20 listbox lbxCampos                      ;
      of wndABM2Filtro                        ;
      width 140                               ;
      height 100                              ;
      items aCampos                           ;
      value 1                                 ;
      font "Arial" size 9                     ;
      on change {|| ABM2ControlFiltro() }     ;
      on gotfocus wndABM2Filtro.StatusBar.Item(1) := _OOHG_Messages( 10, 25 ) ;
      on lostfocus wndABM2Filtro.StatusBar.Item(1) := ""
   @ 85, 220 listbox lbxCompara                    ;
      of wndABM2Filtro                        ;
      width 140                               ;
      height 100                              ;
      items aCompara                          ;
      value 1                                 ;
      font "Arial" size 9                     ;
      on gotfocus wndABM2Filtro.StatusBar.Item(1) := _OOHG_Messages( 10, 26 ) ;
      on lostfocus wndABM2Filtro.StatusBar.Item(1) := ""
   @ 220, 20 textbox conValor              ;
      of wndABM2Filtro                ;
      value ""                        ;
      height 25                       ;
      width 160                       ;
      font "arial" size 9             ;
      maxlength 16

   ////////// Activa la ventana.
   CENTER WINDOW wndABM2Filtro
   ACTIVATE WINDOW wndABM2Filtro

   wndabm2edit.tbbNuevo.enabled:=.t.
   wndabm2edit.tbbEditar.enabled:=.t.
   wndabm2edit.tbbBorrar.enabled:=.t.
   wndabm2edit.tbbBuscar.enabled:=.t.
   wndabm2edit.tbbListado.enabled:=.t.

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2ControlFiltro()
   * Descripción: Comprueba que el filtro se puede aplicar.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2ControlFiltro()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL nControl as numeric
   LOCAL cMascara as character
   LOCAL cMensaje as character

   ////////// Inicializa las variables.
   nControl := wndABM2Filtro.lbxCampos.Value

   ///////// Comprueba que se puede crear el control.-----------------------------
   IF _aEstructura[nControl,DBS_TYPE] == "M"
      msgExclamation( _OOHG_Messages( 11, 35 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF
   IF nControl == 0
      msgExclamation( _OOHG_Messages( 11, 36 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   ///////// Crea el nuevo control.-----------------------------------------------
   wndABM2Filtro.conValor.Release
   cMensaje := _aControl[nControl,ABM_CON_DES]
   DO CASE

      // Carácter.
   CASE _aControl[nControl,ABM_CON_TYPE] == ABM_TEXTBOXC
      @ 226, 20  textbox conValor                                     ;
         of wndABM2Filtro                                        ;
         value ""                                                ;
         height _aControl[nControl,ABM_CON_HEIGHT]               ;
         width _aControl[nControl,ABM_CON_WIDTH]                 ;
         font "arial" size 9                                     ;
         maxlength _aEstructura[nControl,DBS_LEN]                ;
         on gotfocus wndABM2Filtro.StatusBar.Item( 1 ) :=        ;
         cMensaje                                    ;
         on lostfocus wndABM2Filtro.StatusBar.Item( 1 ) := ""

      // Fecha.
   CASE _aControl[nControl,ABM_CON_TYPE] == ABM_DATEPICKER
      @ 226, 20 datepicker conValor                                   ;
         of wndABM2Filtro                                        ;
         value Date()                                            ;
         height _aControl[nControl,ABM_CON_HEIGHT]               ;
         width _aControl[nControl,ABM_CON_WIDTH] + 25            ;
         font "arial" size 9                                     ;
         on gotfocus wndABM2Filtro.StatusBar.Item( 1 ) :=        ;
         cMensaje                                    ;
         on lostfocus wndABM2Filtro.StatusBar.Item( 1 ) := ""

      // Numerico.
   CASE _aControl[nControl,ABM_CON_TYPE] == ABM_TEXTBOXN
      IF ( _aEstructura[nControl,DBS_DEC] == 0 )

         // Sin decimales.
         @ 226, 20 textbox conValor                                      ;
            of wndABM2Filtro                                        ;
            value ""                                                ;
            height _aControl[nControl,ABM_CON_HEIGHT]               ;
            width _aControl[nControl,ABM_CON_WIDTH]                 ;
            numeric                                                 ;
            font "arial" size 9                                     ;
            maxlength _aEstructura[nControl,DBS_LEN]                ;
            on gotfocus wndABM2Filtro.StatusBar.Item( 1 ) :=        ;
            cMensaje                                    ;
            on lostfocus wndABM2Filtro.StatusBar.Item( 1 ) := ""

      ELSE

         // Con decimales.
         cMascara := Replicate( "9", _aEstructura[nControl,DBS_LEN] - ;
            ( _aEstructura[nControl,DBS_DEC] + 1 ) )
         cMascara += "."
         cMascara += Replicate( "9", _aEstructura[nControl,DBS_DEC] )
         @ 226, 20 textbox conValor                                      ;
            of wndABM2Filtro                                        ;
            value ""                                                ;
            height _aControl[nControl,ABM_CON_HEIGHT]               ;
            width _aControl[nControl,ABM_CON_WIDTH]                 ;
            numeric                                                 ;
            inputmask cMascara                                      ;
            on gotfocus wndABM2Filtro.StatusBar.Item( 1 ) :=        ;
            cMensaje                                    ;
            on lostfocus wndABM2Filtro.StatusBar.Item( 1 ) := ""
      ENDIF

      // Logico
   CASE _aControl[nControl,ABM_CON_TYPE] == ABM_CHECKBOX
      @ 226, 20 checkbox conValor                                     ;
         of wndABM2Filtro                                        ;
         caption ""                                              ;
         height _aControl[nControl,ABM_CON_HEIGHT]               ;
         width _aControl[nControl,ABM_CON_WIDTH]                 ;
         value .f.                                               ;
         on gotfocus wndABM2Filtro.StatusBar.Item( 1 ) :=        ;
         cMensaje                                    ;
         on lostfocus wndABM2Filtro.StatusBar.Item( 1 ) := ""

   ENDCASE

   ////////// Actualiza el valor de la etiqueta.----------------------------------
   wndABM2Filtro.lblValor.Value := _aNombreCampo[nControl]

   ////////// Actualiza la barra de estado.---------------------------------------
   //wndABM2Filtro.StatusBar.Item( 1 ) := _aControl[nControl,ABM_CON_DES]

   ////////// Comprueba el tamaño del control de edición del dato a buscar.-------
   IF wndABM2Filtro.conValor.Width > wndABM2Filtro.Width - 45
      wndABM2Filtro.conValor.Width := wndABM2Filtro.Width - 45
   ENDIF

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2EstableceFiltro()
   * Descripción: Establece el filtro seleccionado.
   *  Parámetros: Ninguno.
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2EstableceFiltro()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL aOperador  as array
   LOCAL nCampo     as numeric
   LOCAL nCompara   as numeric
   LOCAL cValor     as character

   ////////// Inicialización de variables.----------------------------------------
   nCompara  := wndABM2Filtro.lbxCompara.Value
   nCampo    := wndABM2Filtro.lbxCampos.Value
   cValor    := HB_ValToStr( wndABM2Filtro.conValor.Value )
   aOperador := { "=", "<>", ">", "<", ">=", "<=" }

   ////////// Comprueba que se puede filtrar.-------------------------------------
   IF nCompara == 0
      msgExclamation( _OOHG_Messages( 11, 37 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF
   IF nCampo == 0
      msgExclamation( _OOHG_Messages( 11, 36 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF
   IF cValor == ""
      msgExclamation( _OOHG_Messages( 11, 38 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF
   IF _aEstructura[nCampo,DBS_TYPE] == "M"
      msgExclamation( _OOHG_Messages( 11, 35 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   ////////// Establece el filtro.------------------------------------------------
   DO CASE
   CASE _aEstructura[nCampo,DBS_TYPE] == "C"
      _cFiltro := "Upper(" + _cArea + "->" + ;
         _aEstructura[nCampo,DBS_NAME] + ")"+ ;
         aOperador[nCompara]
      _cFiltro += "'" + Upper( AllTrim( cValor ) ) + "'"

   CASE _aEstructura[nCampo,DBS_TYPE] == "N"
      _cFiltro := _cArea + "->" + ;
         _aEstructura[nCampo,DBS_NAME] + ;
         aOperador[nCompara]
      _cFiltro += AllTrim( cValor )

   CASE _aEstructura[nCampo,DBS_TYPE] == "D"
      _cFiltro := _cArea + "->" + ;
         _aEstructura[nCampo,DBS_NAME] + ;
         aOperador[nCompara]
      _cFiltro += "CToD(" + "'" + cValor + "')"

   CASE _aEstructura[nCampo,DBS_TYPE] == "L"
      _cFiltro := _cArea + "->" + ;
         _aEstructura[nCampo,DBS_NAME] + ;
         aOperador[nCompara]
      _cFiltro += cValor
   ENDCASE
   (_cArea)->( dbSetFilter( {|| &_cFiltro}, _cFiltro ) )
   _lFiltro := .t.
   wndABM2Filtro.Release
   ABM2Redibuja( .t. )

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función:
   * Descripción:
   *  Parámetros:
   *    Devuelve:
   ****************************************************************************************/

STATIC FUNCTION ABM2DesactivarFiltro()

   ////////// Desactiva el filtro si procede.
   IF !_lFiltro
      msgExclamation( _OOHG_Messages( 11, 39 ), _cTitulo )
      ABM2Redibuja( .f. )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF
   IF msgYesNo( _OOHG_Messages( 11, 40 ), _cTitulo )
      (_cArea)->( dbSetFilter( {|| NIL }, "" ) )
      _lFiltro := .f.
      _cFiltro := ""
      ABM2Redibuja( .t. )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

   ENDIF

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2Imprimir()
   * Descripción: Presenta la ventana de recogida de datos para la definición del listado.
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2Imprimir()

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL aCampoBase    as array            // Campos de la bdd.
   LOCAL aCampoListado as array            // Campos del listado.
   LOCAL nRegistro     as numeric          // Numero de registro actual.
   LOCAL nCampo        as numeric          // Numero de campo.
   LOCAL cRegistro1    as character        // Valor del registro inicial.
   LOCAL cRegistro2    as character        // Valor del registro final.
   LOCAL aImpresoras   as array            // Impresoras disponibles.
   LOCAL NIMPLEN
   LOCAL hbprn

   wndabm2edit.tbbNuevo.enabled:=.F.
   wndabm2edit.tbbEditar.enabled:=.F.
   wndabm2edit.tbbBorrar.enabled:=.F.
   wndabm2edit.tbbBuscar.enabled:=.F.
   wndabm2edit.tbbListado.enabled:=.F.

   ////////// Comprueba si se ha pasado la clausula ON PRINT.---------------------
   IF _bImprimir != NIL
      // msgInfo( "ON PRINT" )
      Eval( _bImprimir )
      ABM2Redibuja( .T. )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   ////////// Obtiene las impresoras disponibles.---------------------------------
   aImpresoras := {}
   INIT PRINTSYS
   GET PRINTERS TO aImpresoras
   RELEASE PRINTSYS
   IF ValType( nImpLen ) != 'N'
      nImpLen := Len( aImpresoras )
   ENDIF
   aSize( aImpresoras, nImpLen )

   ////////// Comprueba que hay un indice activo.---------------------------------
   IF _nIndiceActivo == 1
      msgExclamation( _OOHG_Messages( 11, 9 ), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   ////////// Inicialización de variables.----------------------------------------
   aCampoListado := {}
   aCampoBase    := _aNombreCampo
   nRegistro     := (_cArea)->( RecNo() )

   // Registro inicial y final.
   nCampo := _aIndiceCampo[_nIndiceActivo]
   ( _cArea)->( dbGoTop() )
   cRegistro1 := HB_ValToStr( (_cArea)->( FieldGet( nCampo ) ) )
   ( _cArea)->( dbGoBottom() )
   cRegistro2 := HB_ValToStr( (_cArea)->( FieldGet( nCampo ) ) )
   (_cArea)->( dbGoTo( nRegistro ) )

   ////////// Definición de la ventana de formato de listado.---------------------
   DEFINE WINDOW wndABM2Listado            ;
         at 0, 0                         ;
         width 390                       ;
         height 365                      ;
         title _OOHG_Messages( 10, 10 )  ;
         icon "MINIGUI_EDIT_PRINT"       ;
         modal                           ;
         nosize                          ;
         nosysmenu                       ;
         font "ms sans serif" size 9     ;
         backcolor ( GetFormObjectByHandle( GetActiveWindow() ):BackColor )

      // Define la barra de botones de la ventana de formato de listado.
      DEFINE TOOLBAR tbListado buttonsize 90, 32 flat righttext border
         button tbbCancelarLis caption _OOHG_Messages( 9, 7 ) ;
            picture "MINIGUI_EDIT_CANCEL"             ;
            action  wndABM2Listado.Release
         button tbbAceptarLis  caption _OOHG_Messages( 9, 8 ) ;
            picture "MINIGUI_EDIT_OK"                 ;
            action  ABM2Listado( aImpresoras )

      end toolbar

      // Define la barra de estado de la ventana de formato de listado.
      DEFINE STATUSBAR font "ms sans serif" size 9
         statusitem ""
      END STATUSBAR
   END WINDOW

   ////////// Define los controles de edición de la ventana de formato de listado.-
   // Frame.
   @ 45, 10 frame frmListado                       ;
      of wndABM2Listado                       ;
      caption ""                              ;
      width wndABM2Listado.Width - 25         ;
      height wndABM2Listado.Height - 100

   // Label
   @ 65, 20 label lblCampoBase             ;
      of wndABM2Listado               ;
      value _OOHG_Messages( 10, 11 )  ;
      width 140                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 65, 220 label lblCampoListado         ;
      of wndABM2Listado               ;
      value _OOHG_Messages( 10, 12 )  ;
      width 140                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 200, 20 label lblImpresoras           ;
      of wndABM2Listado               ;
      value _OOHG_Messages( 10, 13 )  ;
      width 140                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 200, 170 label lblInicial             ;
      of wndABM2Listado               ;
      value _OOHG_Messages( 10, 14 )  ;
      width 160                       ;
      height 25                       ;
      font "ms sans serif" size 9
   @ 255, 170 label lblFinal               ;
      of wndABM2Listado               ;
      value _OOHG_Messages( 10, 15 )  ;
      width 160                       ;
      height 25                       ;
      font "ms sans serif" size 9

   // Listbox.
   @ 85, 20 listbox lbxCampoBase                                           ;
      of wndABM2Listado                                               ;
      width 140                                                       ;
      height 100                                                      ;
      items aCampoBase                                                ;
      value 1                                                         ;
      font "Arial" size 9                                             ;
      on gotfocus wndABM2Listado.StatusBar.Item( 1 ) := _OOHG_Messages( 11, 12 ) ;
      on lostfocus wndABM2Listado.StatusBar.Item( 1 ) := ""
   @ 85, 220 listbox lbxCampoListado                                       ;
      of wndABM2Listado                                               ;
      width 140                                                       ;
      height 100                                                      ;
      items aCampoListado                                             ;
      value 1                                                         ;
      font "Arial" size 9                                             ;
      on gotFocus wndABM2Listado.StatusBar.Item( 1 ) := _OOHG_Messages( 11, 13 ) ;
      on lostfocus wndABM2Listado.StatusBar.Item( 1 ) := ""

   // ComboBox.
   @ 220, 20 combobox cbxImpresoras                                        ;
      of wndABM2Listado                                               ;
      items aImpresoras                                               ;
      value 1                                                         ;
      width 140                                                       ;
      font "Arial" size 9                                             ;
      on gotfocus wndABM2Listado.StatusBar.Item( 1 ) := _OOHG_Messages( 11, 14 ) ;
      on lostfocus wndABM2Listado.StatusBar.Item( 1 ) := ""

   // PicButton.
   @ 90, 170 button btnMas                                                 ;
      of wndABM2Listado                                               ;
      picture "MINIGUI_EDIT_ADD"                                      ;
      action ABM2DefinirColumnas( ABM_LIS_ADD )                       ;
      width 40                                                        ;
      height 40                                                       ;
      on gotfocus wndABM2Listado.StatusBar.Item( 1 ) := _OOHG_Messages( 11, 15 ) ;
      on lostfocus wndABM2Listado.StatusBar.Item( 1 ) := ""
   @ 140, 170 button btnMenos                                              ;
      of wndABM2Listado                                               ;
      picture "MINIGUI_EDIT_DEL"                                      ;
      action ABM2DefinirColumnas( ABM_LIS_DEL )                       ;
      width 40                                                        ;
      height 40                                                       ;
      on gotfocus wndABM2Listado.StatusBar.Item( 1 ) := _OOHG_Messages( 11, 16 ) ;
      on lostfocus wndABM2Listado.StatusBar.Item( 1 ) := ""
   @ 220, 170 button btnSet1                                               ;
      of wndABM2Listado                                               ;
      picture "MINIGUI_EDIT_SET"                                      ;
      action ABM2DefinirRegistro( ABM_LIS_SET1 )                      ;
      width 25                                                        ;
      height 25                                                       ;
      on gotfocus wndABM2Listado.StatusBar.Item( 1 ) := _OOHG_Messages( 11, 17 ) ;
      on lostfocus wndABM2Listado.StatusBar.Item( 1 ) := ""
   @ 275, 170 button btnSet2                                               ;
      of wndABM2Listado                                               ;
      picture "MINIGUI_EDIT_SET"                                      ;
      action ABM2DefinirRegistro( ABM_LIS_SET2 )                      ;
      width 25                                                        ;
      height 25                                                       ;
      on gotfocus wndABM2Listado.StatusBar.Item( 1 ) := _OOHG_Messages( 11, 18 ) ;
      on lostfocus wndABM2Listado.StatusBar.Item( 1 ) := ""

   // CheckBox.
   @ 255, 20 checkbox chkVistas            ;
      of wndABM2Listado               ;
      caption _OOHG_Messages( 10, 18 ) ;
      width 140                       ;
      height 25                       ;
      value .t.                       ;
      font "ms sans serif" size 9
   @ 275, 20 checkbox chkPrevio            ;
      of wndABM2Listado               ;
      caption _OOHG_Messages( 10, 17 ) ;
      width 140                       ;
      height 25                       ;
      value .t.                       ;
      font "ms sans serif" size 9

   // Editbox.
   @ 220, 196 textbox txtRegistro1         ;
      of wndABM2Listado               ;
      value cRegistro1                ;
      height 25                       ;
      width 160                       ;
      font "arial" size 9             ;
      maxlength 16
   @ 275, 196 textbox txtRegistro2         ;
      of wndABM2Listado               ;
      value cRegistro2                ;
      height 25                       ;
      width 160                       ;
      font "arial" size 9             ;
      maxlength 16

   ////////// Estado de los controles.--------------------------------------------
   wndABM2Listado.txtRegistro1.Enabled := .f.
   wndABM2Listado.txtRegistro2.Enabled := .f.

   ////////// Comrprueba que la selección de registros es posible.----------------
   nCampo := _aIndiceCampo[_nIndiceActivo]
   IF _aEstructura[nCampo,DBS_TYPE] == "L" .or. _aEstructura[nCampo,DBS_TYPE] == "M"
      wndABM2Listado.btnSet1.Enabled := .f.
      wndABM2Listado.btnSet2.Enabled := .f.
   ENDIF

   ////////// Activación de la ventana de formato de listado.---------------------
   CENTER WINDOW wndABM2Listado
   ACTIVATE WINDOW wndABM2Listado

   ////////// Restaura.-----------------------------------------------------------
   (_cArea)->( dbGoTo( nRegistro ) )
   ABM2Redibuja( .f. )

   wndabm2edit.tbbNuevo.enabled:=.t.
   wndabm2edit.tbbEditar.enabled:=.t.
   wndabm2edit.tbbBorrar.enabled:=.t.
   wndabm2edit.tbbBuscar.enabled:=.t.
   wndabm2edit.tbbListado.enabled:=.t.

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2DefinirRegistro( nAccion )
   * Descripción:
   *  Parámetros:
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2DefinirRegistro( nAccion )

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL nRegistro as character            // * Puntero de registros.
   LOCAL nReg      as character            // * Registro seleccionado.
   LOCAL cValor    as character            // * Valor del registro seleccionado.
   LOCAL nCampo    as numeric              // * Numero del campo indice.

   ////////// Inicializa las variables.-------------------------------------------
   nRegistro := (_cArea)->( RecNo() )
   //        cValor    := ""

   ////////// Selecciona el registro.---------------------------------------------
   nReg := ABM2Seleccionar()
   IF nReg == 0
      (_cArea)->( dbGoTo( nRegistro ) )

      RETURN NIL
   ELSE
      (_cArea)->( dbGoTo( nReg ) )
      nCampo := _aIndiceCampo[_nIndiceActivo]
      cValor := HB_ValToStr( (_cArea)->( FieldGet( nCampo ) ) )
   ENDIF

   ////////// Actualiza según la acción.------------------------------------------
   DO CASE
   CASE nAccion == ABM_LIS_SET1
      wndABM2Listado.txtRegistro1.Value := cValor
   CASE nAccion == ABM_LIS_SET2
      wndABM2Listado.txtRegistro2.Value := cValor
   ENDCASE

   ////////// Restaura el registro.
   (_cArea)->( dbGoTo( nRegistro ) )

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2DefinirColumnas( nAccion )
   * Descripción: Controla el contenido de las listas al pulsar los botones de añadir y
   *              eliminar campos del listado.
   *  Parámetros: [nAccion]       Numerico. Indica el tipo de accion realizado.
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2DefinirColumnas( nAccion )

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL aCampoBase    as array            // * Campos de la bbd.
   LOCAL aCampoListado as array            // * Campos del listado.
   LOCAL i             as numeric          // * Indice de iteración.
   LOCAL nItem         as numeric          // * Numero del item seleccionado.
   LOCAL cvalor

   ////////// Inicialización de variables.----------------------------------------
   aCampoBase  := {}
   aCampoListado := {}
   FOR i := 1 to wndABM2Listado.lbxCampoBase.ItemCount
      aAdd( aCampoBase, wndABM2Listado.lbxCampoBase.Item( i ) )
   NEXT
   FOR i := 1 to wndABM2Listado.lbxCampoListado.ItemCount
      aAdd( aCampoListado, wndABM2Listado.lbxCampoListado.Item( i ) )
   NEXT

   ////////// Ejecuta según la acción.--------------------------------------------
   DO CASE
   CASE nAccion == ABM_LIS_ADD

      // Obtiene la columna a añadir.
      nItem := wndABM2Listado.lbxCampoBase.Value
      cValor := wndABM2Listado.lbxCampoBase.Item( nItem )

      // Actualiza los datos de los campos de la base.
      IF Len( aCampoBase ) == 0
         msgExclamation( _OOHG_Messages( 11, 23 ), _cTitulo )
         wndabm2edit.tbbNuevo.enabled:=.t.
         wndabm2edit.tbbEditar.enabled:=.t.
         wndabm2edit.tbbBorrar.enabled:=.t.
         wndabm2edit.tbbBuscar.enabled:=.t.
         wndabm2edit.tbbListado.enabled:=.t.

         RETURN NIL
      ELSE
         wndABM2Listado.lbxCampoBase.DeleteAllItems
         FOR i := 1 to Len( aCampoBase )
            IF i != nItem
               wndABM2Listado.lbxCampoBase.AddItem( aCampoBase[i] )
            ENDIF
         NEXT
         IF  nItem > 1
            nItem--
         ELSE
            nItem := 1
         ENDIF
         wndABM2Listado.lbxCampoBase.Value := nItem
      ENDIF

      // Actualiza los datos de los campos del listado.
      IF Empty( cValor )
         msgExclamation( _OOHG_Messages( 11, 23 ), _cTitulo )
         wndabm2edit.tbbNuevo.enabled:=.t.
         wndabm2edit.tbbEditar.enabled:=.t.
         wndabm2edit.tbbBorrar.enabled:=.t.
         wndabm2edit.tbbBuscar.enabled:=.t.
         wndabm2edit.tbbListado.enabled:=.t.

         RETURN NIL
      ELSE
         wndABM2Listado.lbxCampoListado.AddItem( cValor )
         wndABM2Listado.lbxCampoListado.Value := ;
            wndABM2Listado.lbxCampoListado.ItemCount
      ENDIF
   CASE nAccion == ABM_LIS_DEL

      // Obtiene la columna a quitar.
      nItem := wndABM2Listado.lbxCampoListado.Value
      cValor := wndABM2Listado.lbxCampoListado.Item( nItem )

      // Actualiza los datos de los campos del listado.
      IF Len( aCampoListado ) == 0
         msgExclamation( _OOHG_Messages( 11, 23 ), _cTitulo )
         wndabm2edit.tbbNuevo.enabled:=.t.
         wndabm2edit.tbbEditar.enabled:=.t.
         wndabm2edit.tbbBorrar.enabled:=.t.
         wndabm2edit.tbbBuscar.enabled:=.t.
         wndabm2edit.tbbListado.enabled:=.t.

         RETURN NIL
      ELSE
         wndABM2Listado.lbxCampoListado.DeleteAllItems
         FOR i := 1 to Len( aCampoListado )
            IF i != nItem
               wndABM2Listado.lbxCampoListado.AddItem( aCampoListado[i] )
            ENDIF
         NEXT
         IF nItem > 1
            nItem--
         ELSE
            nItem := 1
         ENDIF
         Empty( nItem )

         wndABM2Listado.lbxCampoListado.Value := ;
            wndABM2Listado.lbxCampoListado.ItemCount
      ENDIF

      // Actualiza los datos de los campos de la base.
      IF Empty( cValor )
         msgExclamation( _OOHG_Messages( 11, 23 ), _cTitulo )
         wndabm2edit.tbbNuevo.enabled:=.t.
         wndabm2edit.tbbEditar.enabled:=.t.
         wndabm2edit.tbbBorrar.enabled:=.t.
         wndabm2edit.tbbBuscar.enabled:=.t.
         wndabm2edit.tbbListado.enabled:=.t.

         RETURN NIL
      ELSE
         wndABM2Listado.lbxCampoBase.DeleteAllItems
         FOR i := 1 to Len( _aNombreCampo )
            IF aScan( aCampoBase, _aNombreCampo[i] ) != 0
               wndABM2Listado.lbxCampoBase.AddItem( _aNombreCampo[i] )
            ENDIF
            IF _aNombreCampo[i] == cValor
               wndABM2Listado.lbxCampoBase.AddItem( _aNombreCampo[i] )
            ENDIF
         NEXT
         wndABM2Listado.lbxCampoBase.Value := 1
      ENDIF
   ENDCASE

   RETURN NIL

   /****************************************************************************************
   *  Aplicación: Comando EDIT para MiniGUI
   *       Autor: Cristóbal Mollá [cemese@terra.es]
   *     Función: ABM2Listado()
   * Descripción: Imprime la selecciona realizada por ABM2Imprimir()
   *  Parámetros: Ninguno
   *    Devuelve: NIL
   ****************************************************************************************/

STATIC FUNCTION ABM2Listado( aImpresoras )

   ////////// Declaración de variables locales.-----------------------------------
   LOCAL i             as numeric          // * Indice de iteración.
   LOCAL cCampo        as character        // * Nombre del campo indice.
   LOCAL aCampo        as array            // * Nombres de los campos.
   LOCAL nCampo        as numeric          // * Numero del campo actual.
   LOCAL nPosicion     as numeric          // * Posición del campo.
   LOCAL aNumeroCampo  as array            // * Numeros de los campos.
   LOCAL aAncho        as array            // * Anchos de las columnas.
   LOCAL nAncho        as numeric          // * Ancho de las columna actual.
   LOCAL lPrevio       as logical          // * Previsualizar.
   LOCAL lVistas       as logical          // * Vistas en miniatura.
   LOCAL nImpresora    as numeric          // * Numero de la impresora.
   LOCAL cImpresora    as character        // * Nombre de la impresora.
   LOCAL lOrientacion  as logical          // * Orientación de la página.
   LOCAL lSalida       as logical          // * Control de bucle.
   LOCAL lCabecera     as logical          // * ¿Imprimir cabecera?.
   LOCAL nFila         as numeric          // * Numero de la fila.
   LOCAL nColumna      as numeric          // * Numero de la columna.
   LOCAL nPagina       as numeric          // * Numero de página.
   LOCAL nPaginas      as numeric          // * Páginas totales.
   LOCAL cPie          as character        // * Texto del pie de página.
   LOCAL nPrimero      as numeric          // * Numero del primer registro a imprimir.
   LOCAL nUltimo       as numeric          // * Numero del ultimo registro a imprimir.
   LOCAL nTotales      as numeric          // * Registros totales a imprimir.
   LOCAL nRegistro     as numeric          // * Numero del registro actual.
   LOCAL cRegistro1    as character        // * Valor del registro inicial.
   LOCAL cRegistro2    as character        // * Valor del registro final.
   LOCAL xRegistro1                        // * Valor de comparación.
   LOCAL xRegistro2                        // * Valor de comparación.
   LOCAL oprint

   ////////// Inicialización de variables.----------------------------------------
   // Previsualizar.
   lPrevio := wndABM2Listado.chkPrevio.Value
   Empty( lPrevio )
   lVistas := wndABM2Listado.chkVistas.Value
   Empty( lVistas )

   // Nombre de la impresora.
   nImpresora := wndABM2Listado.cbxImpresoras.Value
   IF nImpresora == 0
      msgExclamation( _oohg_messages(6,32), '' )
   ELSE
      cImpresora := aImpresoras[nImpresora]
      Empty( cImpresora )
   ENDIF

   // Nombre del campo.
   aCampo := {}
   FOR i := 1 to wndABM2Listado.lbxCampoListado.ItemCount
      cCampo := wndABM2Listado.lbxCampoListado.Item( i )
      aAdd( aCampo, cCampo )
   NEXT
   IF Len( aCampo ) == 0
      msgExclamation( _OOHG_messages(6,23), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   // Número del campo.
   aNumeroCampo := {}
   FOR i := 1 to Len( aCampo )
      nPosicion := aScan( _aNombreCampo, aCampo[i] )
      aAdd( aNumeroCampo, nPosicion )
   NEXT

   ////////// Obtiene el ancho de impresión.--------------------------------------
   aAncho := {}
   FOR i := 1 to Len( aNumeroCampo )
      nCampo := aNumeroCampo[i]
      DO CASE
      CASE _aEstructura[nCampo,DBS_TYPE] == "D"
         nAncho := 9
      CASE _aEstructura[nCampo,DBS_TYPE] == "M"
         nAncho := 20
      OTHERWISE
         nAncho := _aEstructura[nCampo,DBS_LEN]
      ENDCASE
      nAncho := iif( Len( _aNombreCampo[nCampo] ) > nAncho ,  ;
         Len( _aNombreCampo[nCampo] ),            ;
         nAncho )
      aAdd( aAncho, 1 + nAncho )
   NEXT

   ////////// Comprueba el ancho de impresión.------------------------------------
   nAncho := 0
   FOR i := 1 to Len( aAncho )
      nAncho += aAncho[i]
   NEXT
   IF nAncho > 164
      MsgExclamation( _OOHG_messages(6,24), _cTitulo )
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ELSE
      IF nAncho > 109                 // Horizontal.
         lOrientacion := .t.
      ELSE                            // Vertical.
         lOrientacion := .f.
      ENDIF
   ENDIF

   ////////// Valores de inicio y fin de listado.---------------------------------
   nRegistro  := (_cArea)->( RecNo() )
   cRegistro1 := wndABM2Listado.txtRegistro1.Value
   cRegistro2 := wndABM2Listado.txtRegistro2.Value
   DO CASE
   CASE _aEstructura[_aIndiceCampo[_nIndiceActivo],DBS_TYPE] == "C"
      xRegistro1 := cRegistro1
      xRegistro2 := cRegistro2
   CASE _aEstructura[_aIndiceCampo[_nIndiceActivo],DBS_TYPE] == "N"
      xRegistro1 := Val( cRegistro1 )
      xRegistro2 := Val( cRegistro2 )
   CASE _aEstructura[_aIndiceCampo[_nIndiceActivo],DBS_TYPE] == "D"
      xRegistro1 := CToD( cRegistro1 )
      xRegistro2 := CToD( cRegistro2 )
   CASE _aEstructura[_aIndiceCampo[_nIndiceActivo],DBS_TYPE] == "L"
      xRegistro1 := iif( cRegistro1 == ".t.", .t., .f. )
      xRegistro2 := iif( cRegistro2 == ".t.", .t., .f. )
   ENDCASE
   (_cArea)->( dbSeek( xRegistro2 ) )
   nUltimo := (_cArea)->( RecNo() )
   (_cArea)->( dbSeek( xRegistro1 ) )
   nPrimero := (_cArea)->( RecNo() )

   ////////// Obtiene el número de páginas.---------------------------------------
   nTotales := 0
   DO WHILE (_cArea)->( RecNo() ) != nUltimo .or. (_cArea)->( Eof() )
      nTotales++
      (_cArea)->( dbSkip( 1 ) )
   ENDDO
   IF lOrientacion
      IF Mod( nTotales, 33 ) == 0
         nPaginas := Int( nTotales / 33 )
      ELSE
         nPaginas := Int( nTotales / 33 ) + 1
      ENDIF
   ELSE
      IF Mod( nTotales, 42 ) == 0
         nPaginas := Int( nTotales / 42 )
      ELSE
         nPaginas := Int( nTotales / 42 ) + 1
      ENDIF
   ENDIF
   Empty( nPaginas )
   (_cArea)->( dbGoTo( nPrimero ) )

   ////////// Inicializa el listado.----------------------------------------------
   oprint:=tprint()
   oprint:init()
   oprint:selprinter(.T. , .T.  )  /// select,preview,landscape,papersize
   //oprint:selprinter(.T. , .F.  )  /// select,preview,landscape,papersize
   IF oprint:lprerror
      oprint:release()
      wndabm2edit.tbbNuevo.enabled:=.t.
      wndabm2edit.tbbEditar.enabled:=.t.
      wndabm2edit.tbbBorrar.enabled:=.t.
      wndabm2edit.tbbBuscar.enabled:=.t.
      wndabm2edit.tbbListado.enabled:=.t.

      RETURN NIL
   ENDIF

   // Inicio del listado.
   lCabecera := .t.
   lSalida   := .t.
   nFila     := 14
   nPagina   := 1
   oprint:begindoc()
   oprint:beginpage()
   DO WHILE lSalida

      // Cabecera el listado.
      IF lCabecera
         oprint:printdata(5,1,_ctitulo,"times new roman",12,.T.) ///
         oprint:printline(6,1,6,140)

         oprint:printdata(7,1,_oohg_messages(6,19),"times new roman" ,,.T.) ///
         oprint:printdata(7,31, (_cArea)->( ordName() )) ///

         oprint:printdata(8,1,_OOHG_messages(6,17),"times new roman",,.T.) ///
         oprint:printdata(8,31, CREGISTRO1) ///

         oprint:printdata(9,1,_OOHG_messages(6,18),"times new roman",,.T.) ///
         oprint:printdata(9,31, CREGISTRO2) ///
         ///oprint:printdata(10,1,_OOHG_messages(6,23),"times new roman",,.T.) ///
         ///oprint:printdata(10,31, _CFILTRO) ///

         nColumna := 1
         FOR i := 1 to Len( aCampo )
            ////oprint:printdata(12,ncolumna+ancho[i], CREGISTRO1) ///
            oprint:printdata(12,ncolumna, acampo[i], , ,.T.) ///
            nColumna += aAncho[i]
         NEXT
         lCabecera := .f.
      ENDIF

      // Registros.
      nColumna := 1
      FOR i := 1 to Len( aNumeroCampo )
         nCampo := aNumeroCampo[i]
         DO CASE
         CASE _aEstructura[nCampo,DBS_TYPE] == "N"
            oprint:printdata(nfila,ncolumna, (_cArea)->( FieldGet( aNumeroCampo[i] ) )   ) ///
         CASE _aEstructura[nCampo,DBS_TYPE] == "L"
            oprint:printdata(nfila,ncolumna+1, iif( (_cArea)->( FieldGet( aNumeroCampo[i] ) ), _OOHG_messages(6,29), _OOHG_messages(6,30) )   ) ///
         CASE _aEstructura[nCampo,DBS_TYPE] == "M"
            oprint:printdata(nfila,ncolumna, SubStr( (_cArea)->( FieldGet( aNumeroCampo[i] ) ), 1, 20 )  ) ///
         OTHERWISE
            oprint:printdata(nfila,ncolumna, (_cArea)->( FieldGet( aNumeroCampo[i] ) )   ) ///
         ENDCASE
         nColumna += aAncho[i]
      NEXT
      nFila++

      // Comprueba el final del registro.
      IF (_cArea)->( RecNo() ) == nUltimo
         lSalida := .f.
      ENDIF
      IF (_cArea)->( EOF())
         lSalida := .f.
      ENDIF
      (_cArea)->( dbSkip( 1 ) )

      // Pie.
      IF lOrientacion
         IF nFila > 44
            oprint:printline(46,1,46,140)
            cPie := HB_ValToStr( Date() ) + " " + Time()
            oprint:printdata(47,1,cpie)
            cPie := _OOHG_messages(6,22) + " " +          ;
               AllTrim( Str( nPagina) )
            oprint:printdata(47,70,cpie)
            nPagina++
            nFila := 14
            lCabecera := .t.
            oprint:endpage()
            oprint:beginpage()
         ENDIF
      ELSE
         IF nFila > 56
            oprint:printline(58,1,58,140)
            cPie := HB_ValToStr( Date() ) + " " + Time()
            ////                  @ 68, 10 say cPie font "a9n" to print
            oprint:printdata(59,1,cpie)
            cPie := _oohg_messages(6,22)+" " +                    ;
               AllTrim( Str( nPagina) )
            oprint:printdata(59,70,cpie)
            nFila := 14
            nPagina++
            lCabecera := .t.
            oprint:endpage()
            oprint:beginpage()
         ENDIF
      ENDIF
   ENDDO

   // Comprueba que se imprime el pie de la ultima hoja.----------
   IF lOrientacion
      oprint:printline(46,1,46,140)
      cPie := HB_ValToStr( Date() ) + " " + Time()
      oprint:printdata(47,1,cpie)
      cPie := _oohg_messages(6,22)+" " +                    ;
         AllTrim( Str( nPagina) )
      oprint:printdata(47,70,cpie)
   ELSE
      oprint:printline(58,1,58,140)
      cPie := HB_ValToStr( Date() ) + " " + Time()
      oprint:printdata(59,1,cpie)
      cPie := _OOHG_messages(6,22) + " " +                    ;
         AllTrim( Str( nPagina) )
      oprint:printdata(59,70,cpie)
   ENDIF

   oprint:endpage()
   oprint:enddoc()
   oprint:release()

   ////////// Cierra la ventana.--------------------------------------------------
   (_cArea)->( dbGoTo( nRegistro ) )
   wndABM2Listado.Release
   wndabm2edit.tbbNuevo.enabled:=.t.
   wndabm2edit.tbbEditar.enabled:=.t.
   wndabm2edit.tbbBorrar.enabled:=.t.
   wndabm2edit.tbbBuscar.enabled:=.t.
   wndabm2edit.tbbListado.enabled:=.t.

   RETURN NIL
