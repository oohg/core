/*
 * $Id: TStreamSocket.prg,v 1.3 2015-12-08 06:01:18 guerra000 Exp $
 */
/*
 * Data stream from network socket management class.
 *
 * TStreamSocket.  Reads/writes data from a network socket.
 * TStreamWSocket. Reads/writes data from a network socket,
 *                 approaching Windows' events for reduce
 *                 CPU usage.
 */

#include "hbclass.ch"

#pragma BEGINDUMP
   #ifdef __WIN32__
//      #include <windows.h>
      #include <winsock.h>

      WSADATA *__Socket_Data = 0;

      #ifndef AF_BTH
         #define AF_BTH           32
      #endif
      #ifndef BTHPROTO_RFCOMM
         #define BTHPROTO_RFCOMM  3
      #endif
   #else
      #include <netdb.h>
      #include <sys/socket.h>
      #include <sys/ioctl.h>
      #include <netinet/in.h>
      #include <bluetooth/bluetooth.h>
      #include <bluetooth/rfcomm.h>

      typedef int SOCKET;
      typedef struct sockaddr_in SOCKADDR_IN;
      typedef struct sockaddr * LPSOCKADDR;
      typedef struct hostent * LPHOSTENT;

      #define WSAENOBUFS       ENOBUFS
      #define INVALID_SOCKET   -1
      #define SOCKET_ERROR     -1

      #define AF_BTH           AF_BLUETOOTH
   #endif
   #include <hbapi.h>
   #include <errno.h>

   #define SOCKparam( x )   ( ( SOCKET ) hb_parnl( x ) )
   #define SOCKret( x )     ( hb_retnl( ( long ) x ) )

   int NonBlockingSocket( SOCKET sock );

   #ifdef __XHARBOUR__
      #ifndef HB_ISCHAR
         #define HB_ISCHAR( n )         ISCHAR( n )
      #endif
      #ifndef HB_ISNUM
         #define HB_ISNUM( n )          ISNUM( n )
      #endif
      //
      #define HB_STORNI2( n, x )        hb_storni( n, x )
      #define HB_STORCLEN( n, x, y )    hb_storclen( n, x, y )
   #else
      #define HB_STORNI2( n, x )        hb_storvni( n, x )
      #define HB_STORCLEN( n, x, y )    hb_storvclen( n, x, y )
   #endif

#pragma ENDDUMP

CLASS TStreamSocket FROM TStreamBase
   DATA nSocket           INIT 0     // SOCKET number
   DATA nSocketType       INIT 0     // Type of socket ( see ::SockAddr() )
   DATA nProtocolFamily   INIT 0     // Address family AF_ / protocol family PF_
   DATA nProtocolSocket   INIT 0     // Protocol for socket()
   DATA cSockAddr_In      INIT ""    // SOCKADDR_IN structure

   METHOD New
   METHOD IsConnected
   //
   METHOD RealFill
   METHOD Disconnect
   //
   METHOD Write
   //
   METHOD Listen
   METHOD Accept
   METHOD SockAddr
ENDCLASS

METHOD New( cHost, nPort, nSocket, nSocketType, cClassId ) CLASS TStreamSocket
LOCAL cSockAddr_In
   ::Close()
   _s_InicSocket()
   IF HB_ISNUMERIC( nSocket ) .AND. nSocket > 0
      ::nSocket := nSocket
   ELSE
      IF ::SockAddr( nSocketType, nPort, cHost, cClassId ) == nil
         ::nSocket := 0
      ELSE
         cSockAddr_In := ::cSockAddr_In
         ::nSocket := HB_INLINE( ::nProtocolFamily, ::nProtocolSocket, @cSockAddr_In ){
               SOCKET sock;
               LPSOCKADDR sin;
               int err, iSockAddr_Len;

               sock = socket( hb_parni( 1 ), SOCK_STREAM, hb_parni( 2 ) );
               if( sock != INVALID_SOCKET )
               {
                  iSockAddr_Len = hb_parclen( 3 );
                  sin = ( LPSOCKADDR ) hb_xgrab( iSockAddr_Len + 1 );
                  memcpy( sin, hb_parc( 3 ), iSockAddr_Len );
                  // Connect to host
                  err = connect( sock, ( LPSOCKADDR ) sin, iSockAddr_Len );
                  if( err == 0 )
                  {
                     NonBlockingSocket( sock );
                  }
                  else
                  {
                     sock = 0;
                  }
                  HB_STORCLEN( ( char * ) sin, iSockAddr_Len, 3 );
                  hb_xfree( sin );
               }
               else
               {
                  sock = 0;
               }

               SOCKret( sock );
            }
         ::cSockAddr_In := cSockAddr_In
      ENDIF
   ENDIF
   IF ::nSocket > 0
      ::ReSize( ::nMax )
   ENDIF
RETURN Self

METHOD IsConnected() CLASS TStreamSocket
RETURN ( ::nSocket > 0 )

METHOD RealFill( pBuffer, nPos, nCount ) CLASS TStreamSocket
RETURN HB_INLINE( pBuffer, ::nSocket, nPos, nCount ){
          char * pBuffer;
          SOCKET sSocket;
          int err, iRead = 0;
          struct timeval tv;
          fd_set InSet;

          pBuffer = ( char * ) hb_parptr( 1 );
          sSocket = SOCKparam( 2 );
          if( pBuffer && sSocket > 0 )
          {
             // Use select() for check if there's any data
             tv.tv_sec = 0;
             tv.tv_usec = 100;
             FD_ZERO( &InSet );
             FD_SET( sSocket, &InSet );
             err = select( sSocket + 1, &InSet, NULL, NULL, &tv );
             if( err == SOCKET_ERROR )
             {
                iRead = SOCKET_ERROR;
             }
             else if( err == 0 )
             {
                iRead = 0;     // No pending data
             }
             else
             {
                iRead = recv( sSocket, pBuffer + hb_parni( 3 ) - 1, hb_parni( 4 ), 0 );
                if( iRead == 0 )
                {
                   iRead = SOCKET_ERROR;
                }
             }
          }

          hb_retni( iRead );
       }

METHOD Disconnect() CLASS TStreamSocket
   IF ::nSocket > 0
      HB_INLINE( ::nSocket ){
         #ifdef __WIN32__
            closesocket( SOCKparam( 1 ) );
         #else
            close( SOCKparam( 1 ) );
         #endif
      }
      ::nSocket := 0
   ENDIF
RETURN ::Super:Disconnect()

METHOD Write( cBuffer ) CLASS TStreamSocket
LOCAL nWrite := 0
   IF ::IsConnected()
      IF VALTYPE( cBuffer ) $ "CM" .AND. LEN( cBuffer ) > 0
         nWrite := HB_INLINE( ::nSocket, cBuffer ){
            int iRet, iLen;

            iLen = hb_parclen( 2 );
            iRet = send( SOCKparam( 1 ), ( char * ) hb_parc( 2 ), iLen, 0 );
            if( iRet != iLen )
            {
               if( iRet < 0 && errno == WSAENOBUFS )
               {
                  iRet = 0;
               }
            }

            hb_retni( iRet );
         }
         IF nWrite < 0
            ::Disconnect()
         ENDIF
      ENDIF
   ENDIF
RETURN nWrite

METHOD Listen( nPort, nQueue, nSocketType ) CLASS TStreamSocket
LOCAL nSocket, cSockAddr_In
   IF ::SockAddr( nSocketType, nPort ) == nil
      nSocket := 0
   ELSE
      cSockAddr_In := ::cSockAddr_In
      nSocket := HB_INLINE( ::nProtocolFamily, ::nProtocolSocket, @cSockAddr_In, nQueue ){
            SOCKET sock;
            LPSOCKADDR sin;
            int err, iSockAddr_Len;

            sock = socket( hb_parni( 1 ), SOCK_STREAM, hb_parni( 2 ) );
            if( sock != INVALID_SOCKET )
            {
               iSockAddr_Len = hb_parclen( 3 );
               sin = ( LPSOCKADDR ) hb_xgrab( iSockAddr_Len + 1 );
               memcpy( sin, hb_parc( 3 ), iSockAddr_Len );
               // Connect to host
               err = bind( sock, ( LPSOCKADDR ) sin, iSockAddr_Len );
               if( err == 0 )
               {
                  listen( sock, hb_parni( 4 ) );
                  NonBlockingSocket( sock );
               }
               else
               {
                  sock = 0;
               }
               HB_STORCLEN( ( char * ) sin, iSockAddr_Len, 3 );
               hb_xfree( sin );
            }
            else
            {
               sock = 0;
            }

            SOCKret( sock );
         }
      ::cSockAddr_In := cSockAddr_In
   ENDIF
   IF nSocket > 0
      ::nSocket := nSocket
   ENDIF
RETURN ( nSocket > 0 )

METHOD Accept() CLASS TStreamSocket
LOCAL nSocket, cSockAddr_In, oSocket := NIL
   IF ::nSocket != 0
      IF ::SockAddr() == nil
         nSocket := 0
      ELSE
         cSockAddr_In := ::cSockAddr_In
         nSocket := HB_INLINE( ::nProtocolFamily, @cSockAddr_In, ::nSocket ){
               SOCKET sock;
               LPSOCKADDR sin;
               int l, iSockAddr_Len;

               iSockAddr_Len = hb_parclen( 2 );
               sin = ( LPSOCKADDR ) hb_xgrab( iSockAddr_Len + 1 );
               memcpy( sin, hb_parc( 2 ), iSockAddr_Len );
               //
               l = iSockAddr_Len;
               sock = accept( SOCKparam( 3 ), ( LPSOCKADDR ) sin, &l );
               if( sock == -1 )
               {
                  sock = 0;
               }
               if( sock != 0 )
               {
                  NonBlockingSocket( sock );
               }
               HB_STORCLEN( ( char * ) sin, iSockAddr_Len, 2 );
               hb_xfree( sin );

               SOCKret( sock );
            }
      ENDIF
      IF nSocket > 0
         // oSocket := TStreamSocket():New( nSocket )
         oSocket := __clsInst( ::ClassH )
         oSocket:nSocketType := ::nSocketType
         oSocket:nProtocolFamily := ::nProtocolFamily
         oSocket:cSockAddr_In := cSockAddr_In
         oSocket:New( ,, nSocket )
      ENDIF
   ENDIF
RETURN oSocket

METHOD SockAddr( nSocketType, xParam1, xParam2, xParam3 ) CLASS TStreamSocket
LOCAL nProtocolFamily, nProtocolSocket
LOCAL nPos, cBtAddr, nDigit
   IF EMPTY( nSocketType )
      nSocketType := ::nSocketType
   ENDIF
   IF     nSocketType == 2     // IPv6
*
   ELSEIF nSocketType == 3     // IrDA
/*
      ::cSockAddr_In := HB_INLINE( @nProtocolFamily, @nProtocolSocket, xParam1, xParam2 ){   // cServiceName, cDeviceId
            #ifdef __WIN32__
               struct {
                  u_short    sir_family;        // irdaAddressFamily;
                  u_char     sir_addr[ 4 ];     // irdaDeviceID[4];
                  char       sir_name[ 25 ];    // irdaServiceName[25];
               } sin;
            #else
               struct sockaddr_irda sin;
            #endif
            int iLen;
            //
            HB_STORNI2( AF_IRDA, 1 );
            HB_STORNI2( 0, 2 );
            memset( &sin, 0, sizeof( sin ) );
            sin.sir_family = AF_IRDA;
            //
            if( HB_ISCHAR( 3 ) )
            {
               iLen = hb_parclen( 3 );
               iLen = ( iLen > 24 ) ? 24 : iLen;
               memcpy( &sin.sir_name, hb_parc( 3 ), iLen );
               if( HB_ISCHAR( 4 ) )
               {
                  iLen = hb_parclen( 4 );
                  iLen = ( iLen > 4 ) ? 4 : iLen;
                  memcpy( &sin.sir_addr, hb_parc( 4 ), iLen );
               }
            }
            //
            hb_retclen( ( char * ) &sin, sizeof( sin ) );
         }
*/
   ELSEIF nSocketType == 4     // Bluetooth
      IF PCOUNT() == 2 .AND. EMPTY( xParam1 )
         // For use with ::Listen(), BT_PORT_ANY to locate an available port
         xParam1 := -1
      ENDIF
      IF HB_IsString( xParam2 )
         nPos := 1
         cBtAddr := ""
         DO WHILE nPos <= LEN( xParam2 )
            IF ! UPPER( xParam2[ nPos ] ) $ "0123456789ABCDEF"
               cBtAddr := ""
               EXIT
            ENDIF
            nDigit := 0
            DO WHILE nPos <= LEN( xParam2 ) .AND. UPPER( xParam2[ nPos ] ) $ "0123456789ABCDEF"
               nDigit := ( nDigit * 16 ) + ;
                         AT( UPPER( xParam2[ nPos ] ), "0123456789ABCDEF" ) - 1
               nPos++
            ENDDO
            IF nDigit > 255 .OR. nPos == LEN( xParam2 ) .OR. ( nPos < LEN( xParam2 ) .AND.  xParam2[ nPos ] != ":" )
               cBtAddr := ""
               EXIT
            ENDIF
            cBtAddr := CHR( nDigit ) + cBtAddr
            nPos++
         ENDDO
         IF LEN( cBtAddr ) == 6
            xParam2 := cBtAddr+chr(0)+chr(0)
         ENDIF
      ENDIF
      ::cSockAddr_In := HB_INLINE( @nProtocolFamily, @nProtocolSocket, xParam1, xParam2, xParam3 ){   // nPort_ServiceChannel, cbtAddr, cserviceClassId
            #ifdef __WIN32__
               struct {
                  USHORT     rc_family;         // addressFamily;
                  char       rc_bdaddr[ 8 ];    // btAddr;
                  char       serviceClassId[ 16 ];
                  char       rc_channel[ 4 ];   // port;
               } sin;
            #else
               struct sockaddr_rc sin;
            #endif
            int iLen;
            //
            HB_STORNI2( AF_BTH, 1 );
            HB_STORNI2( BTHPROTO_RFCOMM, 2 );
            memset( &sin, 0, sizeof( sin ) );
            sin.rc_family = AF_BTH;
            //
            if( HB_ISNUM( 3 ) )
            {
               *( ( ULONG * )( &sin.rc_channel ) ) = hb_parni( 3 );
               if( HB_ISCHAR( 4 ) )
               {
                  iLen = hb_parclen( 4 );
                  iLen = ( iLen > 8 ) ? 8 : iLen;
                  memcpy( &sin.rc_bdaddr, hb_parc( 4 ), iLen );
                  #ifdef __WIN32__
                     if( HB_ISCHAR( 5 ) )   // cserviceClassId
                     {
                        iLen = hb_parclen( 5 );
                        iLen = ( iLen > 16 ) ? 16 : iLen;
                        memcpy( &sin.serviceClassId, hb_parc( 5 ), iLen );
                     }
                  #endif
               }
            }
            //
            hb_retclen( ( char * ) &sin, sizeof( sin ) );
         }
   ELSE // IF nSocketType == 1 // IPv4 (default)
      ::nSocketType := 1 // Forces default value
      ::cSockAddr_In := HB_INLINE( @nProtocolFamily, @nProtocolSocket, xParam1, xParam2 ){   // nPort, cHostName
            SOCKADDR_IN sin;
            LPHOSTENT lpHost;
            //
            HB_STORNI2( AF_INET, 1 );
            HB_STORNI2( 0, 2 );
            memset( &sin, 0, sizeof( sin ) );
            sin.sin_family = AF_INET;
            //
            if( HB_ISNUM( 3 ) )
            {
               sin.sin_port = htons( hb_parni( 3 ) );
               if( HB_ISCHAR( 4 ) )
               {
                  lpHost = gethostbyname( ( char * ) hb_parc( 4 ) );
                  if( lpHost != NULL )
                  {
                     memcpy( &sin.sin_addr, lpHost->h_addr_list[ 0 ], lpHost->h_length );
                  }
                  else
                  {
                     hb_ret();
                     return;
                  }
               }
            }
            //
            hb_retclen( ( char * ) &sin, sizeof( sin ) );
         }
   ENDIF
   ::nProtocolFamily := nProtocolFamily
   ::nProtocolSocket := nProtocolSocket
RETURN ::cSockAddr_In

////////////////////////////////////////////////////////////// Miscelaneous

#pragma BEGINDUMP

int NonBlockingSocket( SOCKET sock )
{
   ULONG l;
   int err;

   // Sets socket to non-blocking mode
   l = 1L;
   #ifdef __WIN32__
      err = ioctlsocket( sock, FIONBIO, &l );
   #else
      err = ioctl( sock, FIONBIO, &l );
   #endif

   return err;
}

#pragma ENDDUMP

INIT PROCEDURE __SOCKET__()
   _s_InicSocket()
RETURN

STATIC PROCEDURE _s_InicSocket()
   HB_INLINE(){
      #ifdef __WIN32__
         if( ! __Socket_Data )
         {
            __Socket_Data = malloc( sizeof( WSADATA ) );
            if( ! WSAStartup( MAKEWORD( 1, 1 ), __Socket_Data ) )
            {
               free( __Socket_Data );
               __Socket_Data = 0;
            }
         }
      #endif

      hb_ret();
   }
RETURN

PROCEDURE FINSOCKET()
   HB_INLINE(){
      #ifdef __WIN32__
         if( __Socket_Data )
         {
            WSACleanup();
            free( __Socket_Data );
            __Socket_Data = 0;
         }
      #endif

      hb_ret();
   }
RETURN

#ifndef __STREAM_WIN__
   #ifdef __PLATFORM__Windows
      #define __STREAM_WIN__
   #endif
#endif

#ifndef __STREAM_WIN__
   #ifdef __PLATFORM__WINDOWS
      #define __STREAM_WIN__
   #endif
#endif

#ifdef __STREAM_WIN__

////////////////////////////////////////////////////////////// WINDOWS ///////

#define WM_USER                 0x400
#define FD_READ                 1
#define FD_WRITE                2
#define FD_OOB                  4
#define FD_ACCEPT               8
#define FD_CONNECT              16
#define FD_CLOSE                32

#define WSABASEERR              10000
#define WSAEWOULDBLOCK          ( WSABASEERR + 35 )
#define WSAENOBUFS              ( WSABASEERR + 55 )
#define EWOULDBLOCK             WSAEWOULDBLOCK

CLASS TStreamWSocket FROM TStreamSocket
   DATA bRead                      INIT nil
   DATA bWrite                     INIT nil
   DATA bOOB                       INIT nil
   DATA bConnect                   INIT nil
   DATA bAccept                    INIT nil
   DATA bClose                     INIT nil

   DATA CanWrite                   INIT .T.

   METHOD Async
   METHOD Events
   METHOD CanWaitForBuffer
ENDCLASS

METHOD Async( hWnd ) CLASS TStreamWSocket
   IF ::nSocket != 0
      HB_INLINE( ::nSocket, hWnd, WM_USER+256, FD_READ + FD_WRITE + FD_OOB + FD_CONNECT + FD_ACCEPT + FD_CLOSE ){
         WSAAsyncSelect( hb_parni( 1 ), ( HWND ) hb_parni( 2 ), hb_parni( 3 ), hb_parnl( 4 ) );
      }
      StoreSocket( Self )
   ENDIF
RETURN .T.

#define DoBlock(bBlock,oSocket)   IIF( VALTYPE(bBlock)=="B" , EVAL((bBlock),(oSocket)) , NIL )

METHOD Events( lParam ) CLASS TStreamWSocket
LOCAL nEvent, nPos, nError
   nEvent := HB_INLINE( lParam ){
                hb_retni( WSAGETSELECTEVENT( hb_parnl( 1 ) ) );
             }
   nError := HB_INLINE( lParam ){
                hb_retni( WSAGETSELECTERROR( hb_parnl( 1 ) ) );
             }
   DO CASE
      CASE nEvent == FD_CLOSE
         StoreSocket( ::nSocket, .T. )
         IF VALTYPE( ::bClose ) == "B"
           EVAL( ::bClose, Self, nError )
         ENDIF
      CASE nError != 0
      CASE nEvent == FD_READ
         ::Fill()
         DoBlock( ::bRead,    Self )
      CASE nEvent == FD_WRITE
         ::CanWrite := .T.
         IF LEN( ::cDataToWrite ) != 0
            ::WriteBuffer( "" )
         ENDIF
         DoBlock( ::bWrite,   Self )
      CASE nEvent == FD_OOB
         DoBlock( ::bOOB,     Self )
      CASE nEvent == FD_CONNECT
         DoBlock( ::bConnect, Self )
      CASE nEvent == FD_ACCEPT
         DoBlock( ::bAccept,  Self )
   ENDCASE
RETURN 0

METHOD CanWaitForBuffer() CLASS TStreamWSocket
RETURN HB_INLINE(){
          int iRet;

          iRet = ( WSAGetLastError() == WSAENOBUFS );
          if( iRet )
          {
             WSASetLastError( 0 );
          }

          hb_retl( iRet );
       }

FUNCTION SocketEvents( hWnd, nMsg, wParam, lParam )
LOCAL oSocket, nRet := NIL
   IF nMsg == WM_USER + 256
      oSocket := StoreSocket( wParam )
      IF oSocket != NIL
         nRet := oSocket:Events( lParam )
      ENDIF
   ENDIF
RETURN nRet

STATIC FUNCTION StoreSocket( xSocket, lDelete )
STATIC aSocketObjects := {}, aSocketNumbers := {}
LOCAL nPos, oSocket
   IF VALTYPE( xSocket ) == "O"
      oSocket := xSocket
      nPos := ASCAN( aSocketNumbers, xSocket:nSocket )
      IF nPos > 0
         aSocketObjects[ nPos ] := xSocket
      ELSE
         AADD( aSocketNumbers, xSocket:nSocket )
         AADD( aSocketObjects, xSocket )
      ENDIF
   ELSE
      nPos := ASCAN( aSocketNumbers, xSocket )
      IF nPos > 0
         oSocket := aSocketObjects[ nPos ]
         IF HB_ISLOGICAL( lDelete ) .AND. lDelete
            ADEL( aSocketObjects, nPos )
            ASIZE( aSocketObjects, LEN( aSocketObjects ) - 1 )
            ADEL( aSocketNumbers, nPos )
            ASIZE( aSocketNumbers, LEN( aSocketNumbers ) - 1 )
         ENDIF
      ELSE
         oSocket := NIL
      ENDIF
   ENDIF
RETURN oSocket

#endif
