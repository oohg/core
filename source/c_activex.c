/*
 * $Id: c_activex.c,v 1.5 2007-11-11 17:42:05 guerra000 Exp $
 */
/*
 * ooHG source code:
 * ActiveX control
 *
 *  Marcelo Torres, Noviembre de 2006.
 *  TActiveX para [x]Harbour Minigui.
 *  Adaptacion del trabajo de:
 *  ---------------------------------------------
 *  Lira Lira Oscar Joel [oSkAr]
 *  Clase TActiveX_FreeWin para Fivewin
 *  Noviembre 8 del 2006
 *  email: oscarlira78@hotmail.com
 *  http://freewin.sytes.net
 *  @CopyRight 2006 Todos los Derechos Reservados
 *  ---------------------------------------------
 *  Implemented by ooHG team.
 *
 * + Soporte de Eventos para los controles activeX [oSkAr] 20070829
 *
 *
 */

#ifndef NONAMELESSUNION
   #define NONAMELESSUNION
#endif

#ifndef _HB_API_INTERNAL_
   #define _HB_API_INTERNAL_
#endif

#include <hbvmopt.h>
#include <windows.h>
#include <commctrl.h>
#include <hbapi.h>
#include <hbvm.h>
#include <hbstack.h>
#include "oohg.h"
#include <ocidl.h>
#include <hbapiitm.h>

#ifdef HB_ITEM_NIL
   #define hb_dynsymSymbol( pDynSym )        ( ( pDynSym )->pSymbol )
#endif

PHB_SYMB s___GetMessage = NULL;

// -----------------------------------------------------------------------------
HB_FUNC( TACTIVEX___ERROR )
// -----------------------------------------------------------------------------
{
   PHB_ITEM pSelf = hb_stackSelfItem();
   PHB_SYMB sMessage;
   int iPCount;

   if( ! s___GetMessage )
   {
      s___GetMessage = hb_dynsymSymbol( hb_dynsymFind( "__GETMESSAGE" ) );
   }

   hb_vmPushSymbol( s___GetMessage );
   hb_vmPushNil();
   hb_vmDo( 0 );
   sMessage = hb_dynsymSymbol( hb_dynsymFind( hb_parc( -1 ) ) );

   _OOHG_Send( pSelf, s_oOle );
   hb_vmSend( 0 );

   hb_vmPushSymbol( sMessage );
   hb_vmPush( hb_param( -1, HB_IT_ANY ) );
   for( iPCount = 1; iPCount <= hb_pcount() ; iPCount++ )
   {
      hb_vmPush( hb_param( iPCount, HB_IT_ANY ) );
   }
   hb_vmSend( hb_pcount() );
}

typedef HRESULT ( WINAPI *LPAtlAxWinInit )       ( void );
typedef HRESULT ( WINAPI *LPAtlAxGetControl )    ( HWND, IUnknown** );
typedef HRESULT ( WINAPI *LPAtlAxCreateControl ) ( LPCOLESTR, HWND, IStream*, IUnknown** );

HMODULE hAtl = NULL;
LPAtlAxWinInit       AtlAxWinInit;
LPAtlAxGetControl    AtlAxGetControl;
LPAtlAxCreateControl AtlAxCreateControl;

static void _Ax_Init( void )
{
   if( ! hAtl )
   {
      hAtl = LoadLibrary( "Atl.Dll" );
      AtlAxWinInit       = ( LPAtlAxWinInit )       GetProcAddress( hAtl, "AtlAxWinInit" );
      AtlAxGetControl    = ( LPAtlAxGetControl )    GetProcAddress( hAtl, "AtlAxGetControl" );
      AtlAxCreateControl = ( LPAtlAxCreateControl ) GetProcAddress( hAtl, "AtlAxCreateControl" );
      ( AtlAxWinInit )();
   }
}

HB_FUNC( INITACTIVEX ) // hWnd, cProgId -> hActiveXWnd
{
   HWND hControl;
   int iStyle, iStyleEx;

   iStyle = WS_CHILD | WS_CLIPCHILDREN | WS_CLIPSIBLINGS | hb_parni( 7 );
   iStyleEx = 0; // | WS_EX_CLIENTEDGE

   _Ax_Init();
   hControl = CreateWindowEx( iStyleEx, "AtlAxWin", hb_parc( 2 ), iStyle,
              hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ), HWNDparam( 1 ), 0, 0, NULL );

   HWNDret( hControl );
}
/*
      IUnknown*  pUnk;
      BSTR wString;
      UINT uLen;
      HWND hContainer = HWNDparam( 1 );
      char *Caption   = hb_parc( 2 );

      uLen = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, Caption, strlen(Caption)+1, NULL, 0 );
      wString = (BSTR) hb_xgrab( ( uLen * sizeof(WCHAR) ) + 1 );
      MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, Caption, strlen(Caption)+1, wString, uLen );

      AtlAxCreateControl( wString, hContainer, NULL, &pUnk );

      hb_xfree( wString );
*/

HB_FUNC( ATLAXGETDISP ) // hWnd -> pDisp
{
   IUnknown *pUnk;
   IDispatch *pDisp;
   _Ax_Init();
   AtlAxGetControl( HWNDparam( 1 ), &pUnk );
   pUnk->lpVtbl->QueryInterface( pUnk, &IID_IDispatch, ( void ** ) &pDisp );
   pUnk->lpVtbl->Release( pUnk );
   HWNDret( pDisp );
}

/*
 *   oskar 20070829
 *   Soporte de Eventos :)
 */
/*-----------------------------------------------------------------------------------------------*/

//   #define __USEHASHEVENTS

#ifdef __USEHASHEVENTS
   #include <hashapi.h>
#endif

   //------------------------------------------------------------------------------
   HRESULT hb_oleVariantToItem( PHB_ITEM pItem, VARIANT *pVariant );

   //------------------------------------------------------------------------------
   static void HB_EXPORT hb_itemPushList( ULONG ulRefMask, ULONG ulPCount, PHB_ITEM** pItems )
   {
      PHB_ITEM itmRef;
      ULONG ulParam;

      if( ulPCount )
      {
         itmRef = hb_itemNew( NULL );

         // initialize the reference item
         itmRef->type = HB_IT_BYREF;
         itmRef->item.asRefer.offset = -1;
         itmRef->item.asRefer.BasePtr.itemsbasePtr = pItems;
         for( ulParam = 0; ulParam < ulPCount; ulParam++ )
         {
            if( ulRefMask & ( 1L << ulParam ) )
            {
               // when item is passed by reference then we have to put
               // the reference on the stack instead of the item itself
               itmRef->item.asRefer.value = ulParam+1;
               hb_vmPush( itmRef );
            }
            else
            {
               hb_vmPush( (*pItems)[ulParam] );
            }
         }

         hb_itemRelease( itmRef );
      }
   }

   //------------------------------------------------------------------------------
   //this is a macro which defines our IEventHandler struct as so:
   //
   // typedef struct {
   //    IEventHandlerVtbl  *lpVtbl;
   // } IEventHandler;

   #undef  INTERFACE
   #define INTERFACE IEventHandler

   DECLARE_INTERFACE_ ( INTERFACE, IDispatch )
   {
      // IUnknown functions
      STDMETHOD  ( QueryInterface          ) ( THIS_ REFIID, void **                                                          ) PURE;
      STDMETHOD_ ( ULONG, AddRef           ) ( THIS                                                                           ) PURE;
      STDMETHOD_ ( ULONG, Release          ) ( THIS                                                                           ) PURE;
      // IDispatch functions
      STDMETHOD_ ( ULONG, GetTypeInfoCount ) ( THIS_ UINT *                                                                   ) PURE;
      STDMETHOD_ ( ULONG, GetTypeInfo      ) ( THIS_ UINT, LCID, ITypeInfo **                                                 ) PURE;
      STDMETHOD_ ( ULONG, GetIDsOfNames    ) ( THIS_ REFIID, LPOLESTR *, UINT, LCID, DISPID *                                 ) PURE;
      STDMETHOD_ ( ULONG, Invoke           ) ( THIS_ DISPID, REFIID, LCID, WORD, DISPPARAMS *, VARIANT *, EXCEPINFO *, UINT * ) PURE;
   };

   // In other words, it defines our IEventHandler to have nothing
   // but a pointer to its VTable. And of course, every COM object must
   // start with a pointer to its VTable.
   //
   // But we actually want to add some more members to our IEventHandler.
   // We just don't want any app to be able to know about, and directly
   // access, those members. So here we'll define a MyRealIEventHandler that
   // contains those extra members. The app doesn't know that we're
   // really allocating and giving it a MyRealIEventHAndler object. We'll
   // lie and tell it we're giving a plain old IEventHandler. That's ok
   // because a MyRealIEventHandler starts with the same VTable pointer.
   //
   // We add a DWORD reference count so that this IEventHandler
   // can be allocated (which we do in our IClassFactory object's
   // CreateInstance()) and later freed. And, we have an extra
   // BSTR (pointer) string, which is used by some of the functions we'll
   // add to IEventHandler

   typedef struct {

      IEventHandler*          lpVtbl;
      DWORD                   count;
      IConnectionPoint*       pIConnectionPoint;  // Ref counted of course.
      DWORD                   dwEventCookie;
      IID                     device_event_interface_iid;
      PHB_ITEM                pEvents;

#ifndef __USEHASHEVENTS
      PHB_ITEM                pEventsExec;
#endif

   } MyRealIEventHandler;

   //------------------------------------------------------------------------------
   // Here are IEventHandler's functions.
   //------------------------------------------------------------------------------
   // Every COM object's interface must have the 3 functions QueryInterface(),
   // AddRef(), and Release().

   // IEventHandler's QueryInterface()
   static HRESULT STDMETHODCALLTYPE QueryInterface( IEventHandler *this, REFIID vTableGuid, void **ppv )
   {
      // Check if the GUID matches IEvenetHandler VTable's GUID. We gave the C variable name
      // IID_IEventHandler to our VTable GUID. We can use an OLE function called
      // IsEqualIID to do the comparison for us. Also, if the caller passed a
      // IUnknown GUID, then we'll likewise return the IEventHandler, since it can
      // masquerade as an IUnknown object too. Finally, if the called passed a
      // IDispatch GUID, then we'll return the IExample3, since it can masquerade
      // as an IDispatch too

      if ( IsEqualIID( vTableGuid, &IID_IUnknown ) )
      {
         *ppv = (IUnknown*) this;
         // Increment the count of callers who have an outstanding pointer to this object
         this->lpVtbl->AddRef( this );
         return S_OK;
      }

      if ( IsEqualIID( vTableGuid, &IID_IDispatch ) )
      {
         *ppv = (IDispatch*) this;
         this->lpVtbl->AddRef( this );
         return S_OK;
      }

      if ( IsEqualIID( vTableGuid, &(((MyRealIEventHandler*) this)->device_event_interface_iid ) ) )
      {
         *ppv = (IDispatch*) this;
         this->lpVtbl->AddRef( this );
         return S_OK;
      }

      // We don't recognize the GUID passed to us. Let the caller know this,
      // by clearing his handle, and returning E_NOINTERFACE.
      *ppv = 0;
      return(E_NOINTERFACE);
   }

   //------------------------------------------------------------------------------
   // IEventHandler's AddRef()
   static ULONG STDMETHODCALLTYPE AddRef(IEventHandler *this)
   {
      // Increment IEventHandler's reference count, and return the updated value.
      // NOTE: We have to typecast to gain access to any data members. These
      // members are not defined  (so that an app can't directly access them).
      // Rather they are defined only above in our MyRealIEventHandler
      // struct. So typecast to that in order to access those data members
      return(++((MyRealIEventHandler *) this)->count);
   }

   //------------------------------------------------------------------------------
   // IEventHandler's Release()
   static ULONG STDMETHODCALLTYPE Release(IEventHandler *this)
   {
      if (--((MyRealIEventHandler *) this)->count == 0)
      {
         GlobalFree(this);
         return(0);
      }
      return(((MyRealIEventHandler *) this)->count);
   }

   //------------------------------------------------------------------------------
   // IEventHandler's GetTypeInfoCount()
   static ULONG STDMETHODCALLTYPE GetTypeInfoCount(IEventHandler *this, UINT *pCount)
   {
      HB_SYMBOL_UNUSED(this);
      HB_SYMBOL_UNUSED(pCount);
      return E_NOTIMPL;
   }

   //------------------------------------------------------------------------------
   // IEventHandler's GetTypeInfo()
   static ULONG STDMETHODCALLTYPE GetTypeInfo(IEventHandler *this, UINT itinfo, LCID lcid, ITypeInfo **pTypeInfo)
   {
      HB_SYMBOL_UNUSED(this);
      HB_SYMBOL_UNUSED(itinfo);
      HB_SYMBOL_UNUSED(lcid);
      HB_SYMBOL_UNUSED(pTypeInfo);
      return E_NOTIMPL;
   }

   //------------------------------------------------------------------------------
   // IEventHandler's GetIDsOfNames()
   static ULONG STDMETHODCALLTYPE GetIDsOfNames(IEventHandler *this, REFIID riid, LPOLESTR *rgszNames, UINT cNames, LCID lcid, DISPID *rgdispid)
   {
      HB_SYMBOL_UNUSED(this);
      HB_SYMBOL_UNUSED(riid);
      HB_SYMBOL_UNUSED(rgszNames);
      HB_SYMBOL_UNUSED(cNames);
      HB_SYMBOL_UNUSED(lcid);
      HB_SYMBOL_UNUSED(rgdispid);
      return E_NOTIMPL;
   }

   //------------------------------------------------------------------------------
   // IEventHandler's Invoke()
   // this is where the action happens
   // this function receives events (by their ID number) and distributes the processing
   // or them or ignores them
   static ULONG STDMETHODCALLTYPE Invoke( IEventHandler *this, DISPID dispid, REFIID riid,
      LCID lcid, WORD wFlags, DISPPARAMS *params, VARIANT *result, EXCEPINFO *pexcepinfo,
      UINT *puArgErr )
   {
      PHB_ITEM pItem;
      int iArg, i;
      PHB_ITEM pItemArray[32]; // max 32 parameters?
      PHB_ITEM *pItems;
      ULONG ulRefMask = 0;
      ULONG ulPos;
      PHB_ITEM Key;

      Key = hb_itemNew( NULL );

      // We implement only a "default" interface
      if ( !IsEqualIID( riid, &IID_NULL ) )
         return( DISP_E_UNKNOWNINTERFACE );

      HB_SYMBOL_UNUSED(lcid);
      HB_SYMBOL_UNUSED(wFlags);
      HB_SYMBOL_UNUSED(result);
      HB_SYMBOL_UNUSED(pexcepinfo);
      HB_SYMBOL_UNUSED(puArgErr);

      // delegate work to somewhere else in PRG
      //***************************************

#ifdef __USEHASHEVENTS

      if ( hb_hashScan( ((MyRealIEventHandler* ) this)->pEvents, hb_itemPutNL( Key, dispid ),
         &ulPos ) )
      {
         PHB_ITEM pArray = hb_hashGetValueAt( ((MyRealIEventHandler* ) this)->pEvents, ulPos );

#else

      ulPos = hb_arrayScan( ((MyRealIEventHandler* ) this)->pEvents, hb_itemPutNL( Key, dispid ),
         NULL, NULL, 0
            #ifdef __XHARBOUR__
               , 0
            #endif
         );

      if ( ulPos )
      {
         PHB_ITEM pArray = hb_arrayGetItemPtr( ((MyRealIEventHandler* ) this)->pEventsExec, ulPos );

#endif

         PHB_ITEM pExec  = hb_arrayGetItemPtr( pArray, 01 );

         if ( pExec )
         {

            hb_vmPushState();

            switch ( hb_itemType( pExec ) )
            {

               case HB_IT_BLOCK:
               {
                  hb_vmPushSymbol( &hb_symEval );
                  hb_vmPush( pExec );
                  break;
               }

               case HB_IT_STRING:
               {
                  PHB_ITEM pObject = hb_arrayGetItemPtr( pArray, 2 );
                  hb_vmPushSymbol( hb_dynsymSymbol( hb_dynsymFindName( hb_itemGetCPtr( pExec ) ) ) );

                  if ( HB_IS_OBJECT( pObject ) )
                     hb_vmPush( pObject );
                  else
                     hb_vmPushNil();
                  break;

               }

               case HB_IT_POINTER:
               {
                  hb_vmPushSymbol( hb_dynsymSymbol( ( (PHB_SYMB) pExec ) -> pDynSym ) );
                  hb_vmPushNil();
                  break;
               }

            }

            iArg = params->cArgs;
            for( i = 1; i<= iArg; i++ )
            {
               pItem = hb_itemNew(NULL);
               hb_oleVariantToItem( pItem, &(params->rgvarg[iArg-i]) );
               pItemArray[i-1] = pItem;
               // set bit i
               ulRefMask |= ( 1L << (i-1) );
            }

            if( iArg )
            {
               pItems = pItemArray;
               hb_itemPushList( ulRefMask, iArg, &pItems );
            }

            // execute
            hb_vmDo( iArg );

            // En caso de que los parametros sean pasados por referencia
            for( i=iArg; i > 0; i-- )
            {
               if( (&(params->rgvarg[iArg-i]))->n1.n2.vt & VT_BYREF == VT_BYREF )
               {

                  switch( (&(params->rgvarg[iArg-i]))->n1.n2.vt )
                  {

                     //case VT_UI1|VT_BYREF:
                     //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pbVal) = va_arg(argList,unsigned char*);  //pItemArray[i-1]
                     //   break;
                     case VT_I2|VT_BYREF:
                        *((&(params->rgvarg[iArg-i]))->n1.n2.n3.piVal)    = (short)          hb_itemGetNI(pItemArray[i-1]);
                        break;
                     case VT_I4|VT_BYREF:
                        *((&(params->rgvarg[iArg-i]))->n1.n2.n3.plVal)    = (long)           hb_itemGetNL(pItemArray[i-1]);
                        break;
                     case VT_R4|VT_BYREF:
                        *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pfltVal)  = (float)          hb_itemGetND(pItemArray[i-1]);
                        break;
                     case VT_R8|VT_BYREF:
                        *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pdblVal)  = (double)         hb_itemGetND(pItemArray[i-1]);
                        break;
                     case VT_BOOL|VT_BYREF:
                        *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pboolVal) =                  hb_itemGetL( pItemArray[i-1] ) ? 0xFFFF : 0;
                        break;
                     //case VT_ERROR|VT_BYREF:
                     //   *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pscode) = va_arg(argList, SCODE*);
                     //   break;
                     case VT_DATE|VT_BYREF:
                        *((&(params->rgvarg[iArg-i]))->n1.n2.n3.pdate)    = (DATE) (double) (hb_itemGetDL(pItemArray[i-1])-2415019 );
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

                  } // EOF switch( (&(params->rgvarg[iArg-i]))->n1.n2.vt )

               } // EOF if( (&(params->rgvarg[iArg-i]))->n1.n2.vt & VT_BYREF == VT_BYREF )

            } // EOF for( i=iArg; i > 0; i-- )

            hb_vmPopState();

         } // EOF if ( pExec )

      }  // EOF If Scan

      hb_itemRelease( Key );

      return S_OK;

   }  // EOF invoke

   //------------------------------------------------------------------------------
   // Here's IEventHandler's VTable. It never changes so we can declare it static
   static const IEventHandlerVtbl IEventHandler_Vtbl = {
      QueryInterface,
      AddRef,
      Release,
      GetTypeInfoCount,
      GetTypeInfo,
      GetIDsOfNames,
      Invoke
   };

   //------------------------------------------------------------------------------
   // constructor
   // params:
   // device_interface        - refers to the interface type of the COM object (whose event we are trying to receive).
   // device_event_interface  - indicates the interface type of the outgoing interface supported by the COM object.
   //                           This will be the interface that must be implemented by the Sink object.
   //                           is essentially derived from IDispatch, our Sink object (this IEventHandler)
   //                           is also derived from IDispatch.

   typedef IEventHandler device_interface;

   // Hash  // SetupConnectionPoint( oOle:hObj, @hSink, hEvents )             -> nError
   // Array // SetupConnectionPoint( oOle:hObj, @hSink, aEvents, aExecEvent ) -> nError

   HB_FUNC( SETUPCONNECTIONPOINT )
   {
      IConnectionPointContainer*  pIConnectionPointContainerTemp = NULL;
      IUnknown*                   pIUnknown = NULL;
      IConnectionPoint*           m_pIConnectionPoint;
      IEnumConnectionPoints*      m_pIEnumConnectionPoints;
      HRESULT                     hr; //,r;
      IID                         rriid;
      register IEventHandler *    thisobj;
      DWORD                       dwCookie = 0;

      device_interface*           pdevice_interface = (device_interface*) hb_parnl( 1 );
      MyRealIEventHandler*        pThis;

      // Allocate our IEventHandler object (actually a MyRealIEventHandler)
      // intentional misrepresentation of size

      thisobj = ( IEventHandler *) GlobalAlloc( GMEM_FIXED, sizeof( MyRealIEventHandler ) );

      if ( ! thisobj )
      {
         hr = E_OUTOFMEMORY;
      }
      else
      {
         // Store IEventHandler's VTable in the object
         thisobj->lpVtbl = (IEventHandlerVtbl *) &IEventHandler_Vtbl;

         // Increment the reference count so we can call Release() below and
         // it will deallocate only if there is an error with QueryInterface()
         ((MyRealIEventHandler *) thisobj)->count = 0;

         //((MyRealIEventHandler *) thisobj)->device_event_interface_iid = &riid;
         ((MyRealIEventHandler *) thisobj)->device_event_interface_iid = IID_IDispatch;

         // Query this object itself for its IUnknown pointer which will be used
         // later to connect to the Connection Point of the device_interface object.
         hr = thisobj->lpVtbl->QueryInterface( thisobj, &IID_IUnknown, (void**) &pIUnknown );
         if ( hr == S_OK && pIUnknown )
         {

            // Query the pdevice_interface for its connection point.
            hr = pdevice_interface->lpVtbl->QueryInterface( pdevice_interface,
               &IID_IConnectionPointContainer, (void**) &pIConnectionPointContainerTemp );

            if ( hr == S_OK && pIConnectionPointContainerTemp )
            {
               // start uncomment
               hr = pIConnectionPointContainerTemp->lpVtbl->EnumConnectionPoints( pIConnectionPointContainerTemp, &m_pIEnumConnectionPoints );

               if ( hr == S_OK && m_pIEnumConnectionPoints )
               {
                  do
                  {
                     hr = m_pIEnumConnectionPoints->lpVtbl->Next( m_pIEnumConnectionPoints, 1, &m_pIConnectionPoint , NULL);
                     if( hr == S_OK )
                     {
                        if ( m_pIConnectionPoint->lpVtbl->GetConnectionInterface( m_pIConnectionPoint, &rriid ) == S_OK )
                        {
                           break;
                        }
                     }

                  } while( hr == S_OK );
                  m_pIEnumConnectionPoints->lpVtbl->Release(m_pIEnumConnectionPoints);
               }
               // end uncomment

               //hr = pIConnectionPointContainerTemp ->lpVtbl->FindConnectionPoint(pIConnectionPointContainerTemp ,  &IID_IDispatch, &m_pIConnectionPoint);
               pIConnectionPointContainerTemp->lpVtbl->Release( pIConnectionPointContainerTemp );
               pIConnectionPointContainerTemp = NULL;
            }

            if ( hr == S_OK && m_pIConnectionPoint )
            {
               //OutputDebugString("getting iid");
               //Returns the IID of the outgoing interface managed by this connection point.
               //hr = m_pIConnectionPoint->lpVtbl->GetConnectionInterface(m_pIConnectionPoint, &rriid );
               //OutputDebugString("called");

               if( hr == S_OK )
               {
                  ((MyRealIEventHandler *) thisobj)->device_event_interface_iid = rriid;
               }
               else
                  OutputDebugString("error getting iid");

               //OutputDebugString("calling advise");
               hr = m_pIConnectionPoint->lpVtbl->Advise( m_pIConnectionPoint, pIUnknown, &dwCookie );
               ((MyRealIEventHandler *) thisobj)->pIConnectionPoint = m_pIConnectionPoint;
               ((MyRealIEventHandler *) thisobj)->dwEventCookie = dwCookie;

            }

            pIUnknown->lpVtbl->Release(pIUnknown);
            pIUnknown = NULL;

         }
      }

      if( thisobj )
      {
         pThis = (void*) thisobj;

#ifndef __USEHASHEVENTS
         pThis->pEventsExec = hb_itemNew( hb_param( 4, HB_IT_ANY ) );
#endif

         pThis->pEvents     = hb_itemNew( hb_param( 3, HB_IT_ANY ) );
         hb_stornl( (LONG) pThis, 2 );

      }

      HWNDret( hr );

   }

//------------------------------------------------------------------------------
HB_FUNC( SHUTDOWNCONNECTIONPOINT )
{
   MyRealIEventHandler *this = ( MyRealIEventHandler * ) hb_parnl( 1 );
   if( this->pIConnectionPoint )
   {
      this->pIConnectionPoint->lpVtbl->Unadvise( this->pIConnectionPoint, this->dwEventCookie );
      this->dwEventCookie = 0;
      this->pIConnectionPoint->lpVtbl->Release( this->pIConnectionPoint );
      this->pIConnectionPoint = NULL;
   }
}

//------------------------------------------------------------------------------
HB_FUNC( RELEASEDISPATCH )
{
   IDispatch * pObj;
   pObj = ( IDispatch * ) HWNDparam( 1 );
   pObj->lpVtbl->Release( pObj );
}
