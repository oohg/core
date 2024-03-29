/*
 * $Id: c_activex.c $
 */
/*
 * OOHG source code:
 * ActiveX control
 *
 * Copyright 2007-2022 Vicente Guerra <vicente@guerra.com.mx> and contributors of
 * the Object Oriented (x)Harbour GUI (aka OOHG) Project, https://oohg.github.io/
 *
 * Portions of this project are based upon:
 *    "TActiveX for [x]Harbour Minigui" by Marcelo Torres and Fernando Santolin
 *       Copyright 2006 <lichitorres@yahoo.com.ar> and <CarozoDeQuilmes@gmail.com>
 *    "TActiveX_FreeWin class for Fivewin" by Oscar Joel Lira Lira Oscar
 *       Copyright 2006-2007 [oSkAr] <oscarlira78@hotmail.com>
 *    "Harbour MiniGUI Extended Edition Library"
 *       Copyright 2005-2022 MiniGUI Team, http://hmgextended.com
 *    "Harbour GUI framework for Win32"
 *       Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
 *       Copyright 2001 Antonio Linares <alinares@fivetech.com>
 *    "Harbour MiniGUI"
 *       Copyright 2002-2016 Roberto Lopez <mail.box.hmg@gmail.com>
 *    "Harbour Project"
 *       Copyright 1999-2022 Contributors, https://harbour.github.io/
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
 * along with this software; see the file LICENSE.txt. If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1335, USA (or download from http://www.gnu.org/licenses/).
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


/*
 * This source must not be included in any .PRG file because it won't compile.
 */

#ifndef CINTERFACE
   #define CINTERFACE 1
#endif

#ifndef NONAMELESSUNION
   #define NONAMELESSUNION
#endif

/* this must come before any #include */
#ifndef _HB_API_INTERNAL_
   #define _HB_API_INTERNAL_
#endif

/* do not change the order */
#include <windows.h>
#include <commctrl.h>
#include <ocidl.h>
#include <hbvm.h>
#include <hbstack.h>
#include <hbapiitm.h>
#include <hbvmopt.h>
#include "oohg.h"

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

#ifdef UNICODE
   LPWSTR AnsiToWide( LPCSTR );
#endif

typedef HRESULT ( WINAPI *LPAtlAxWinInit )       ( void );
typedef HRESULT ( WINAPI *LPAtlAxGetControl )    ( HWND, IUnknown** );

static HMODULE hAtl = NULL;                 /* Thread safe, see _Ax_Init() and _Ax_DeInit() */
static LPAtlAxGetControl AtlAxGetControl;   /* Thread safe, see _Ax_Init() and _Ax_DeInit() */
static HRESULT res = 0xFFFFFFFF;

/*--------------------------------------------------------------------------------------------------------------------------------*/
static BOOL _Ax_Init( void )
{
   LPAtlAxWinInit AtlAxWinInit;
   BOOL bSuccess;

   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   if( ! hAtl )
   {
      hAtl = LoadLibrary( TEXT( "ATL.DLL" ) );
      AtlAxWinInit       = (LPAtlAxWinInit) _OOHG_GetProcAddress( hAtl, "AtlAxWinInit" );
      AtlAxGetControl    = (LPAtlAxGetControl) _OOHG_GetProcAddress( hAtl, "AtlAxGetControl" );
      bSuccess = ( AtlAxWinInit )();
      if( bSuccess )
      {
         res = S_OK;
      }
      else
      {
         res = E_FAIL;
      }
   }

   ReleaseMutex( _OOHG_GlobalMutex() );

   return ( hAtl != NULL );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
void _Ax_DeInit( void )
{
   WaitForSingleObject( _OOHG_GlobalMutex(), INFINITE );

   if( hAtl )
   {
      FreeLibrary( hAtl );
      hAtl = NULL;
   }

   ReleaseMutex( _OOHG_GlobalMutex() );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( INITACTIVEX )          /* FUNCTION InitActivex( hWnd, cProgId, nCol, nRow, nWidth, nHeight, nStyle, nStyleEx -> hActiveXhWnd */
{
   HWND hControl = NULL;
   int iStyle, iStyleEx;
#ifndef UNICODE
   char * cProgId = HB_UNCONST( hb_parc( 2 ) );
#else
   LPWSTR cProgId = AnsiToWide( (char *) hb_parc( 2 ) );
#endif

   iStyle = WS_CHILD | WS_CLIPCHILDREN | hb_parni( 7 );
   iStyleEx = hb_parni( 8 );

   if( _Ax_Init() )
   {
      hControl = CreateWindowEx( iStyleEx, TEXT( "AtlAxWin" ), cProgId, iStyle,
                                 hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ),
                                 HWNDparam( 1 ), NULL, GetModuleHandle( NULL ), NULL );
   }

   HWNDret( hControl );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ATLAXHRESULT )          /* FUNCTION AtlAxHResult() -> res */
{
   hb_retnl( res );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( ATLAXGETDISP )          /* FUNCTION AtlAxGetDisp( hWnd ) -> pDisp */
{
   IUnknown *pUnk;
   IDispatch *pDisp = NULL;

   if( _Ax_Init() )
   {
      res = AtlAxGetControl( HWNDparam( 1 ), &pUnk );
#if defined( __cplusplus )
      pUnk->QueryInterface( IID_IDispatch, (void **) &pDisp );
#else
      pUnk->lpVtbl->QueryInterface( pUnk, &IID_IDispatch, (void **) (void *) &pDisp );
#endif
      pUnk->lpVtbl->Release( pUnk );
   }

   HWNDret( pDisp );
}

#ifdef __USEHASHEVENTS
   #include <hashapi.h>
#endif

HRESULT hb_oleVariantToItem( PHB_ITEM pItem, VARIANT *pVariant );

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* self is a macro which defines our IEventHandler struct as:
 * typedef struct {
 *    IEventHandlerVtbl *lpVtbl;
 * } IEventHandler;
 */
#undef  INTERFACE
#define INTERFACE IEventHandler

DECLARE_INTERFACE_( INTERFACE, IDispatch )
{
   /* IUnknown functions */
   STDMETHOD( QueryInterface           ) ( THIS_ REFIID, void **                                                          ) PURE;
   STDMETHOD_( ULONG, AddRef           ) ( THIS                                                                           ) PURE;
   STDMETHOD_( ULONG, Release          ) ( THIS                                                                           ) PURE;
   /* IDispatch functions */
   STDMETHOD_( ULONG, GetTypeInfoCount ) ( THIS_ UINT *                                                                   ) PURE;
   STDMETHOD_( ULONG, GetTypeInfo      ) ( THIS_ UINT, LCID, ITypeInfo **                                                 ) PURE;
   STDMETHOD_( ULONG, GetIDsOfNames    ) ( THIS_ REFIID, LPOLESTR *, UINT, LCID, DISPID *                                 ) PURE;
   STDMETHOD_( ULONG, Invoke           ) ( THIS_ DISPID, REFIID, LCID, WORD, DISPPARAMS *, VARIANT *, EXCEPINFO *, UINT * ) PURE;
};

/* In other words, it defines our IEventHandler to have nothing
 * but a pointer to its VTable. And of course, every COM object must
 * start with a pointer to its VTable.
 *
 * But we actually want to add some more members to our IEventHandler.
 * We just don't want any app to be able to know about, and directly
 * access, those members. So here we'll define a MyRealIEventHandler that
 * contains those extra members. The app doesn't know that we're
 * really allocating and giving it a MyRealIEventHAndler object. We'll
 * lie and tell it we're giving a plain old IEventHandler. That's ok
 * because a MyRealIEventHandler starts with the same VTable pointer.
 *
 * We add a DWORD reference count so that self IEventHandler
 * can be allocated (which we do in our IClassFactory object's
 * CreateInstance()) and later freed. And, we have an extra
 * BSTR (pointer) string, which is used by some of the functions we'll
 * add to IEventHandler
 */

typedef struct {

   IEventHandler    *lpVtbl;
   DWORD            count;
   IConnectionPoint *pIConnectionPoint;  /* Ref counted of course. */
   DWORD            dwEventCookie;
   IID              device_event_interface_iid;
   PHB_ITEM         pEvents;

#ifndef __USEHASHEVENTS
   PHB_ITEM         pEventsExec;
#endif

} MyRealIEventHandler;

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* IEventHandler's functions.
 * Every COM object's interface must have the 3 functions QueryInterface(), AddRef() and Release().
 */

/*--------------------------------------------------------------------------------------------------------------------------------*/
static HRESULT STDMETHODCALLTYPE QueryInterface( IEventHandler *self, REFIID vTableGuid, void **ppv )
{
   /* Check if the GUID matches IEvenetHandler VTable's GUID. We gave the C variable name
    * IID_IEventHandler to our VTable GUID. We can use an OLE function called
    * IsEqualIID to do the comparison for us. Also, if the caller passed a
    * IUnknown GUID, then we'll likewise return the IEventHandler, since it can
    * masquerade as an IUnknown object too. Finally, if the called passed a
    * IDispatch GUID, then we'll return the IExample3, since it can masquerade
    * as an IDispatch too
    */

   if( IsEqualIID( vTableGuid, &IID_IUnknown ) )
   {
      *ppv = (IUnknown *) self;
      /* Increment the count of callers who have an outstanding pointer to self object */
      self->lpVtbl->AddRef( self );
      return S_OK;
   }

   if( IsEqualIID( vTableGuid, &IID_IDispatch ) )
   {
      *ppv = (IDispatch *) self;
      self->lpVtbl->AddRef( self );
      return S_OK;
   }

   if( IsEqualIID( vTableGuid, &( ((MyRealIEventHandler *) self)->device_event_interface_iid ) ) )
   {
      *ppv = (IDispatch *) self;
      self->lpVtbl->AddRef( self );
      return S_OK;
   }

   /* We don't recognize the GUID passed to us. Let the caller know self,
    * by clearing his handle, and returning E_NOINTERFACE.
    */
   *ppv = 0;
   return E_NOINTERFACE;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static ULONG STDMETHODCALLTYPE AddRef( IEventHandler *self )
{
   /* Increment IEventHandler's reference count, and return the updated value.
    * NOTE: We have to typecast to gain access to any data members. These
    * members are not defined  (so that an app can't directly access them).
    * Rather they are defined only above in our MyRealIEventHandler
    * struct. So typecast to that in order to access those data members
    */
   return ( ++( (MyRealIEventHandler *) self )->count );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static ULONG STDMETHODCALLTYPE Release( IEventHandler *self )
{
   if( --( (MyRealIEventHandler *) self )->count == 0 )
   {
      GlobalFree( self );
      return ( 0 );
   }
   return( ( (MyRealIEventHandler *) self )->count );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static ULONG STDMETHODCALLTYPE GetTypeInfoCount( IEventHandler *self, UINT *pCount )
{
   HB_SYMBOL_UNUSED( self );
   HB_SYMBOL_UNUSED( pCount );
   return E_NOTIMPL;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static ULONG STDMETHODCALLTYPE GetTypeInfo( IEventHandler *self, UINT itinfo, LCID lcid, ITypeInfo **pTypeInfo )
{
   HB_SYMBOL_UNUSED( self );
   HB_SYMBOL_UNUSED( itinfo );
   HB_SYMBOL_UNUSED( lcid );
   HB_SYMBOL_UNUSED( pTypeInfo );
   return E_NOTIMPL;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
static ULONG STDMETHODCALLTYPE GetIDsOfNames( IEventHandler *self, REFIID riid, LPOLESTR *rgszNames, UINT cNames, LCID lcid, DISPID *rgdispid )
{
   HB_SYMBOL_UNUSED( self );
   HB_SYMBOL_UNUSED( riid );
   HB_SYMBOL_UNUSED( rgszNames );
   HB_SYMBOL_UNUSED( cNames );
   HB_SYMBOL_UNUSED( lcid );
   HB_SYMBOL_UNUSED( rgdispid );
   return E_NOTIMPL;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* self is where the action happens
 * self function receives events (by their ID number) and distributes the processing or ignores them
 */
static ULONG STDMETHODCALLTYPE Invoke( IEventHandler *self, DISPID dispid, REFIID riid,
   LCID lcid, WORD wFlags, DISPPARAMS *params, VARIANT *result, EXCEPINFO *pexcepinfo,
   UINT *puArgErr )
{
   PHB_ITEM pItem;
   int iArg, i;
   PHB_ITEM pItemArray[32]; /* max 32 parameters? */
   PHB_ITEM *pItems;
   HB_SIZE ulPos;
   PHB_ITEM Key;

   Key = hb_itemNew( NULL );

   /* We implement only a "default" interface */
   if( ! IsEqualIID( riid, &IID_NULL ) )
      return( (ULONG) DISP_E_UNKNOWNINTERFACE );

   HB_SYMBOL_UNUSED( lcid );
   HB_SYMBOL_UNUSED( wFlags );
   HB_SYMBOL_UNUSED( result );
   HB_SYMBOL_UNUSED( pexcepinfo );
   HB_SYMBOL_UNUSED( puArgErr );

   /* delegate work to somewhere else in PRG */

#ifdef __USEHASHEVENTS

   if( hb_hashScan( ( (MyRealIEventHandler *) self )->pEvents, hb_itemPutNL( Key, dispid ), &ulPos ) )
   {
      PHB_ITEM pArray = hb_hashGetValueAt( ( (MyRealIEventHandler *) self )->pEvents, ulPos );

#else

   #ifdef __XHARBOUR__
      ulPos = hb_arrayScan( ( (MyRealIEventHandler *) self )->pEvents, hb_itemPutNL( Key, dispid ), NULL, NULL, 0, 0 );
   #else
      ulPos = hb_arrayScan( ( (MyRealIEventHandler *) self )->pEvents, hb_itemPutNL( Key, dispid ), NULL, NULL, 0 );
   #endif

   if( ulPos )
   {
      PHB_ITEM pArray = hb_arrayGetItemPtr( ( (MyRealIEventHandler *) self )->pEventsExec, ulPos );

#endif

      PHB_ITEM pExec  = hb_arrayGetItemPtr( pArray, 1 );

      if( pExec )
      {
         if( hb_vmRequestReenter() )
         {
            switch ( hb_itemType( pExec ) )
            {
               case HB_IT_BLOCK:
               {
#ifdef __XHARBOUR__
                  hb_vmPushSymbol( &hb_symEval );
#else
                  hb_vmPushEvalSym();
#endif
                  hb_vmPush( pExec );
                  break;
               }
               case HB_IT_STRING:
               {
                  PHB_ITEM pObject = hb_arrayGetItemPtr( pArray, 2 );
                  hb_vmPushSymbol( hb_dynsymSymbol( hb_dynsymFindName( hb_itemGetCPtr( pExec ) ) ) );

                  if( HB_IS_OBJECT( pObject ) )
                     hb_vmPush( pObject );
                  else
                     hb_vmPushNil();
                  break;
               }
               case HB_IT_POINTER:
               {
                  hb_vmPushSymbol( hb_dynsymSymbol( ( (PHB_SYMB) pExec )->pDynSym ) );
                  hb_vmPushNil();
                  break;
               }
               default:
                  break;
            }

            iArg = params->cArgs;
            for( i = 1; i <= iArg; i++ )
            {
               pItem = hb_itemNew( NULL );
               hb_oleVariantToItem( pItem, &( params->rgvarg[ iArg - i ] ) );
               pItemArray[ i - 1 ] = pItem;
               /* set bit i */
               //ulRefMask |= ( 1L << ( i - 1 ) );
            }

            if( iArg )
            {
               pItems = pItemArray;
               if( iArg )
               {
                  for( i = 0; i < iArg; i++ )
                  {
                     hb_vmPush( ( pItems )[ i ] );
                  }
               }
            }

            /* execute */
            hb_vmDo( (USHORT) iArg );

            // En caso de que los parametros sean pasados por referencia
            for( i = iArg; i > 0; i-- )
            {
               if( ( ( &( params->rgvarg[ iArg - i ] ) )->n1.n2.vt & VT_BYREF ) == VT_BYREF )
               {

                  switch( ( &( params->rgvarg[ iArg - i ] ) )->n1.n2.vt )
                  {

                     //case VT_UI1|VT_BYREF:
                     //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pbVal) = va_arg(argList,unsigned char*);  //pItemArray[i-1]
                     //   break;
                     case VT_I2 | VT_BYREF:
                        *( ( &( params->rgvarg[ iArg - i ] ) )->n1.n2.n3.piVal ) = ( short ) hb_itemGetNI( pItemArray[ i - 1 ] );
                        break;
                     case VT_I4 | VT_BYREF:
                        *( ( &( params->rgvarg[ iArg - i ] ) )->n1.n2.n3.plVal ) = ( long ) hb_itemGetNL( pItemArray[ i - 1 ] );
                        break;
                     case VT_R4 | VT_BYREF:
                        *( ( &( params->rgvarg[ iArg - i ] ) )->n1.n2.n3.pfltVal ) = ( float ) hb_itemGetND( pItemArray[ i - 1 ] );
                        break;
                     case VT_R8 | VT_BYREF:
                        *( ( &( params->rgvarg[ iArg - i ] ) )->n1.n2.n3.pdblVal ) = ( double ) hb_itemGetND( pItemArray[ i - 1 ] );
                        break;
                     case VT_BOOL | VT_BYREF:
                        *( ( &( params->rgvarg[ iArg - i ] ) )->n1.n2.n3.pboolVal ) = ( VARIANT_BOOL ) ( hb_itemGetL( pItemArray[ i - 1 ] ) ? 0xFFFF : 0 );
                        break;
                     //case VT_ERROR|VT_BYREF:
                     //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pscode) = va_arg(argList, SCODE*);
                     //   break;
                     case VT_DATE | VT_BYREF:
                        *( ( &( params->rgvarg[ iArg - i ] ) )->n1.n2.n3.pdate ) = ( DATE ) ( double ) ( hb_itemGetDL( pItemArray[ i - 1 ] ) - 2415019 );
                        break;
                     //case VT_CY|VT_BYREF:
                     //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pcyVal) = va_arg(argList, CY*);
                     //   break;
                     //case VT_BSTR|VT_BYREF:
                     //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pbstrVal = va_arg(argList, BSTR*);
                     //   break;
                     //case VT_UNKNOWN|VT_BYREF:
                     //   pArg->ppunkVal = va_arg(argList, LPUNKNOWN*);
                     //   break;
                     //case VT_DISPATCH|VT_BYREF:
                     //   pArg->ppdispVal = va_arg(argList, LPDISPATCH*);
                     //   break;
                  }
               }
            }

            hb_vmRequestRestore();
         }
      }
   }

   hb_itemRelease( Key );

   return S_OK;
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* IEventHandler's VTable. It never changes so we can declare it static */
static const IEventHandlerVtbl IEventHandler_Vtbl = {
   QueryInterface,
   AddRef,
   Release,
   GetTypeInfoCount,
   GetTypeInfo,
   GetIDsOfNames,
   Invoke
};

/*--------------------------------------------------------------------------------------------------------------------------------*/
/* constructor
 * params:
 * device_interface        - refers to the interface type of the COM object (whose event we are trying to receive).
 * device_event_interface  - indicates the interface type of the outgoing interface supported by the COM object.
 *                           This will be the interface that must be implemented by the Sink object.
 *                           is essentially derived from IDispatch, our Sink object (self IEventHandler)
 *                           is also derived from IDispatch.
 */
typedef IEventHandler device_interface;

/* Hash:  SetupConnectionPoint( oOle:hObj, @hSink, hEvents )             -> nError
 * Array: SetupConnectionPoint( oOle:hObj, @hSink, aEvents, aExecEvent ) -> nError
 */
HB_FUNC( SETUPCONNECTIONPOINT )
{
   IConnectionPointContainer *pIConnectionPointContainerTemp = NULL;
   IUnknown                  *pIUnknown = NULL;
   IConnectionPoint          *m_pIConnectionPoint = NULL;
   IEnumConnectionPoints     *m_pIEnumConnectionPoints;
   HRESULT                   hr;
   IID                       rriid = IID_NULL;
   register IEventHandler    *selfobj;
   DWORD                     dwCookie = 0;
   device_interface          *pdevice_interface = DEVICEINTERFACEparam( 1 );
   MyRealIEventHandler       *pThis;

   /* Allocate our IEventHandler object (actually a MyRealIEventHandler)
    * intentional misrepresentation of size
    */
   selfobj = (IEventHandler *) GlobalAlloc( GMEM_FIXED, sizeof( MyRealIEventHandler ) );

   if( ! selfobj )
   {
      hr = E_OUTOFMEMORY;
   }
   else
   {
      /* Store IEventHandler's VTable in the object */
      selfobj->lpVtbl = (IEventHandlerVtbl *) HB_UNCONST( &IEventHandler_Vtbl );

      /* Increment the reference count so we can call Release() below and
       * it will deallocate only if there is an error with QueryInterface() */
      ( (MyRealIEventHandler *) selfobj )->count = 0;

      /* ((MyRealIEventHandler *) selfobj)->device_event_interface_iid = &riid; */
      ( (MyRealIEventHandler *) selfobj )->device_event_interface_iid = IID_IDispatch;

      /* Query self object itself for its IUnknown pointer which will be used
       * later to connect to the Connection Point of the device_interface object.
       */
      hr = selfobj->lpVtbl->QueryInterface( selfobj, &IID_IUnknown, (void **) (void *) &pIUnknown );
      if( hr == S_OK && pIUnknown )
      {
         /* Query the pdevice_interface for its connection point. */
         hr = pdevice_interface->lpVtbl->QueryInterface( pdevice_interface,
            &IID_IConnectionPointContainer, (void **) (void *) &pIConnectionPointContainerTemp );

         if( hr == S_OK && pIConnectionPointContainerTemp )
         {
            hr = pIConnectionPointContainerTemp->lpVtbl->EnumConnectionPoints( pIConnectionPointContainerTemp, &m_pIEnumConnectionPoints );

            if( hr == S_OK && m_pIEnumConnectionPoints )
            {
               do
               {
                  hr = m_pIEnumConnectionPoints->lpVtbl->Next( m_pIEnumConnectionPoints, 1, &m_pIConnectionPoint , NULL);
                  if( hr == S_OK )
                  {
                     if( m_pIConnectionPoint->lpVtbl->GetConnectionInterface( m_pIConnectionPoint, &rriid ) == S_OK )
                     {
                        break;
                     }
                  }
               }
               while( hr == S_OK );
               m_pIEnumConnectionPoints->lpVtbl->Release( m_pIEnumConnectionPoints );
            }

            /* hr = pIConnectionPointContainerTemp ->lpVtbl->FindConnectionPoint(pIConnectionPointContainerTemp ,  &IID_IDispatch, &m_pIConnectionPoint); */
            pIConnectionPointContainerTemp->lpVtbl->Release( pIConnectionPointContainerTemp );
            pIConnectionPointContainerTemp = NULL;
         }

         if( hr == S_OK && m_pIConnectionPoint )
         {
            /* OutputDebugString("getting iid");
             * Returns the IID of the outgoing interface managed by self connection point.
             * hr = m_pIConnectionPoint->lpVtbl->GetConnectionInterface(m_pIConnectionPoint, &rriid );
             * OutputDebugString("called");
             */

            if( hr == S_OK )
            {
               ( (MyRealIEventHandler *) selfobj )->device_event_interface_iid = rriid;
            }
            else
               OutputDebugString( "error getting iid" );

            /* OutputDebugString("calling advise"); */
            hr = m_pIConnectionPoint->lpVtbl->Advise( m_pIConnectionPoint, pIUnknown, &dwCookie );
            ( (MyRealIEventHandler *) selfobj )->pIConnectionPoint = m_pIConnectionPoint;
            ( (MyRealIEventHandler *) selfobj )->dwEventCookie = dwCookie;
         }

         pIUnknown->lpVtbl->Release( pIUnknown );
         pIUnknown = NULL;
      }
   }

   if( selfobj )
   {
      pThis = (MyRealIEventHandler *) selfobj;

#ifndef __USEHASHEVENTS
      pThis->pEventsExec = hb_itemNew( hb_param( 4, HB_IT_ANY ) );
#endif

      pThis->pEvents = hb_itemNew( hb_param( 3, HB_IT_ANY ) );
      HANDLEstor( pThis, 2 );
   }

   hb_retnl( hr );
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( SHUTDOWNCONNECTIONPOINT )
{
   MyRealIEventHandler *self = HSINKparam( 1 );

   if( self->pIConnectionPoint )
   {
      self->pIConnectionPoint->lpVtbl->Unadvise( self->pIConnectionPoint, self->dwEventCookie );
      self->dwEventCookie = 0;
      self->pIConnectionPoint->lpVtbl->Release( self->pIConnectionPoint );
      self->pIConnectionPoint = NULL;
   }
}

/*--------------------------------------------------------------------------------------------------------------------------------*/
HB_FUNC( RELEASEDISPATCH )
{
   IDispatch *pObj;

   pObj = (IDispatch *) HWNDparam( 1 );
   pObj->lpVtbl->Release( pObj );
}
