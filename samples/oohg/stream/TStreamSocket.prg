/*
 * $Id: TStreamSocket.prg,v 1.2 2011-09-05 17:20:16 guerra000 Exp $
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
   #else
      #include <netdb.h>
      #include <sys/socket.h>
      #include <sys/ioctl.h>
      #include <netinet/in.h>

      typedef int SOCKET;
      typedef struct sockaddr_in SOCKADDR_IN;
      typedef struct sockaddr * LPSOCKADDR;
      typedef struct hostent * LPHOSTENT;

      #define WSAENOBUFS       ENOBUFS
      #define INVALID_SOCKET   -1
      #define SOCKET_ERROR     -1
   #endif
   #include <hbapi.h>
   #include <errno.h>

   #define SOCKparam( x )   ( ( SOCKET ) hb_parnl( x ) )
   #define SOCKret( x )     ( hb_retnl( ( long ) x ) )

   int NonBlockingSocket( SOCKET sock );

#pragma ENDDUMP

CLASS TStreamSocket FROM TStreamBase
   DATA nSocket INIT 0

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
ENDCLASS

METHOD New( cHost, nPort, nSocket ) CLASS TStreamSocket
   ::Close()
   _s_InicSocket()
   IF HB_ISNUMERIC( nSocket ) .AND. nSocket > 0
      ::nSocket := nSocket
   ELSE
      ::nSocket := HB_INLINE( cHost, nPort ){
         SOCKET sock;
         SOCKADDR_IN sin;
         LPHOSTENT lpHost;
         int err;

         sock = socket( PF_INET, SOCK_STREAM, 0 );
         if( sock != INVALID_SOCKET )
         {
            // Gets host's IP address
            lpHost = gethostbyname( ( char * ) hb_parc( 1 ) );
            if( lpHost != NULL )
            {
               // Conecta al host
               sin.sin_family = PF_INET;
               memcpy( &sin.sin_addr, lpHost->h_addr_list[ 0 ], lpHost->h_length );
               sin.sin_port = htons( hb_parni( 2 ) );
               err = connect( sock, ( LPSOCKADDR ) &sin, sizeof( sin ) );
               if( err == 0 )
               {
                  NonBlockingSocket( sock );
               }
               else
               {
                  sock = 0;
               }
            }
            else
            {
               sock = 0;
            }
         }

         SOCKret( sock );
      }
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

METHOD Listen( nPort, nQueue ) CLASS TStreamSocket
LOCAL nSocket
   nSocket := HB_INLINE( nPort, nQueue ){
         SOCKET sock;
         SOCKADDR_IN sin;
         int err;

         sock = socket( PF_INET, SOCK_STREAM, 0 );
         if( sock != INVALID_SOCKET )
         {
            memset( &sin, 0, sizeof( sin ) );
            sin.sin_family = PF_INET;
            sin.sin_port = htons( hb_parni( 1 ) );
            err = bind( sock, ( LPSOCKADDR ) &sin, sizeof( sin ) );
            if( err == 0 )
            {
               listen( sock, hb_parni( 2 ) );
               NonBlockingSocket( sock );
            }
            else
            {
               sock = 0;
            }
         }

         SOCKret( sock );
      }
   IF nSocket > 0
      ::nSocket := nSocket
   ENDIF
RETURN ( nSocket > 0 )

METHOD Accept() CLASS TStreamSocket
LOCAL nSocket, oSocket := NIL
   IF ::nSocket != 0
      nSocket := HB_INLINE( ::nSocket ){
            SOCKET sock;
            SOCKADDR_IN sin;
            int l;

            memset( &sin, 0, sizeof( sin ) );
            sin.sin_family = AF_INET;
            l = sizeof( sin );
            sock = accept( SOCKparam( 1 ), ( LPSOCKADDR ) &sin, &l );
            if( sock == -1 )
            {
               sock = 0;
            }
            if( sock != 0 )
            {
               NonBlockingSocket( sock );
            }

            SOCKret( sock );
         }
      IF nSocket > 0
         // oSocket := TStreamSocket():New( nSocket )
         oSocket := __clsInst( ::ClassH ):New( ,, nSocket )
      ENDIF
   ENDIF
RETURN oSocket

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
