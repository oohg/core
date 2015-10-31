/*
 * $Id: TStreamSerial.prg,v 1.5 2015-10-31 17:07:44 fyurisich Exp $
 */
/*
 * TStreamSerial
 *
 * Data stream from serial port management class.
 */

#include "hbclass.ch"

#pragma BEGINDUMP

#ifdef __WIN32__
   #include <windows.h>

   #define PORTHANDLE HANDLE
   #define PORTparam(n)     ( ( PORTHANDLE ) hb_parnl( n ) )
#else
   #include <sys/types.h>
   #include <sys/stat.h>
   #include <fcntl.h>
   #include <termios.h>

   #define PORTHANDLE int
   #define PORTparam(n)     ( ( PORTHANDLE ) hb_parnl( n ) )
#endif

#include <hbapi.h>
#include <hbapifs.h>

#ifndef __XHARBOUR__
   #define ISCHAR( n )           HB_ISCHAR( n )
   #define ISNUM( n )            HB_ISNUM( n )
#endif

#pragma ENDDUMP

CLASS TStreamSerial FROM TStreamBase
   DATA nPort INIT 0

   METHOD New
   METHOD IsConnected
   //
   METHOD RealFill
   METHOD Disconnect
   //
   METHOD Write
   //
   METHOD Speed       SETGET
   METHOD DataBits    SETGET
   METHOD Parity      SETGET
   METHOD StopBits    SETGET
ENDCLASS

METHOD New( cPort, nSpeed, nDataBits, cParity, nStop ) CLASS TStreamSerial
   ::Close()
   #ifdef __PLATFORM__Windows
      cPort := "\\.\" + ALLTRIM( cPort)
      IF RIGHT( cPort, 1 ) == ":"
         cPort := LEFT( cPort, LEN( cPort ) - 1 )
      ENDIF
   #endif
   ::nPort := HB_INLINE( cPort ){
      PORTHANDLE iPort;
      #ifdef __WIN32__
         COMMTIMEOUTS to;

         iPort = CreateFile( hb_parc( 1 ), GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL );
         if( iPort == INVALID_HANDLE_VALUE )
         {
            iPort = 0;
         }
         else
         {
            memset( &to, 0, sizeof( to ) );
            to.ReadIntervalTimeout = MAXDWORD;
            SetCommTimeouts( iPort, &to );
         }
      #else
         struct termios sTerm;

         iPort = open( hb_parc( 1 ), O_RDWR | O_NOCTTY | O_NONBLOCK );
         if( iPort > 0 )
         {
//            tcgetattr( iPort, &sTerm );
            memset( &sTerm, 0, sizeof( sTerm ) );
            sTerm.c_cflag = B38400 | CS8 | CLOCAL | CREAD;
            sTerm.c_iflag = 0;
            sTerm.c_oflag = 0;
            sTerm.c_lflag = 0;
            sTerm.c_cc[ VTIME ] = 0;
            sTerm.c_cc[ VMIN ] = 0;
            tcflush( iPort, TCIFLUSH );
            tcsetattr( iPort, TCSANOW, &sTerm );
            fcntl( iPort, F_SETFL, FNDELAY );
         }
      #endif
//
      hb_retnl( ( long ) iPort );
   }
   IF ::nPort > 0
      ::ReSize( ::nMax )
      ::Speed    := nSpeed
      ::DataBits := nDataBits
      ::Parity   := cParity
      ::StopBits := nStop
   ENDIF
RETURN Self

METHOD IsConnected() CLASS TStreamSerial
RETURN ( ::nPort > 0 )

METHOD RealFill( pBuffer, nPos, nCount ) CLASS TStreamSerial
RETURN HB_INLINE( pBuffer, ::nPort, nPos, nCount ){
   char * pBuffer;
   PORTHANDLE iPort;
   int iRead = 0;

   pBuffer = ( char * ) hb_parptr( 1 );
   iPort = PORTparam( 2 );

   if( pBuffer && iPort != ( PORTHANDLE ) 0 && iPort != ( ( PORTHANDLE ) ~0 ) )
   {
      #ifdef __WIN32__
         DWORD dwCount;

         iRead = -1;
         dwCount = 0;
         if( ReadFile( iPort, pBuffer + hb_parni( 3 ) - 1, hb_parni( 4 ), &dwCount, NULL ) )
         {
            iRead = ( int ) dwCount;
         }
      #else
         iRead = read( iPort, pBuffer + hb_parni( 3 ) - 1, hb_parni( 4 ) );
      #endif
   }

   hb_retni( iRead );
}

METHOD Disconnect() CLASS TStreamSerial
   IF ::nPort > 0
      HB_INLINE( ::nPort ){
         #ifdef __WIN32__
            CloseHandle( PORTparam( 1 ) );
         #else
            close( PORTparam( 1 ) );
         #endif
      }
      ::nPort := 0
   ENDIF
RETURN ::Super:Disconnect()

METHOD Write( cBuffer ) CLASS TStreamSerial
LOCAL nWrite := 0
   IF ::IsConnected()
      IF VALTYPE( cBuffer ) $ "CM" .AND. LEN( cBuffer ) > 0
         nWrite := HB_INLINE( ::nPort, cBuffer ){
            int iWrite;

            #ifdef __WIN32__
               DWORD dwCount;

               iWrite = -1;
               dwCount = 0;
               if( WriteFile( PORTparam( 1 ), hb_parc( 2 ), hb_parclen( 2 ), &dwCount, NULL ) )
               {
                  iWrite = ( int ) dwCount;
               }
            #else
               iWrite = write( PORTparam( 1 ), hb_parc( 2 ), hb_parclen( 2 ) );
            #endif

            hb_retni( iWrite );
         }
         IF nWrite < 0
            ::Disconnect()
         ELSE
            // Must read after write
            ::Fill()
         ENDIF
      ENDIF
   ENDIF
RETURN nWrite

#pragma BEGINDUMP
#ifndef __WIN32__

int modem_speed_table[][2] = { { 50, B50 },     { 75, B75 },     { 110, B110 },
                               { 134, B134 },   { 150, B150 },   { 200, B200 },
                               { 300, B300 },   { 600, B600 },   { 1200, B1200 },
                               { 1800, B1800 }, { 2400, B2400 }, { 4800, B4800 },
                               { 9600, B9600 },
#ifdef B19200
     { 19200, B19200 },
#endif
#ifdef B28800
     { 28800, B28800 },
#endif
#ifdef B38400
     { 38400, B38400 },
#endif
#ifdef B57600
     { 57600, B57600 },
#endif
#ifdef B76800
     { 76800, B76800 },
#endif
#ifdef B115200
     { 115200, B115200 },
#endif
#ifdef B230400
     { 230400, B230400 },
#endif
#ifdef B460800
     { 460800, B460800 },
#endif
                           { 0, 0 } };

static int modem_speed( int iValue, int iType )
{
   int iPos, iConvert;
   iConvert = -1;

   iPos = 0;
   while( modem_speed_table[ iPos ][ 0 ] != 0 )
   {
      if( modem_speed_table[ iPos ][ iType ] == iValue )
      {
         iConvert = modem_speed_table[ iPos ][ 1 - iType ];
      }
      iPos++;
   }

   return iConvert;
}

#endif
#pragma ENDDUMP

METHOD Speed( nSpeed ) CLASS TStreamSerial
LOCAL nValue := 0
   IF ::nPort > 0
      nValue := HB_INLINE( ::nPort, nSpeed ){
         int iValue;
         PORTHANDLE iPort = PORTparam( 1 );
         int iSpeed = ISNUM( 2 ) ? hb_parni( 2 ) : -1;

         #ifdef __WIN32__
            DCB dcb;

            GetCommState( iPort, &dcb );
            iValue = dcb.BaudRate;
            if( iSpeed > 0 )
            {
               dcb.BaudRate = iSpeed;
               if( SetCommState( iPort, &dcb ) )
               {
                  iValue = dcb.BaudRate;
               }
            }
         #else
            struct termios sTerm;

            tcgetattr( iPort, &sTerm );
            iValue = cfgetispeed( &sTerm );
            iSpeed = modem_speed( iSpeed, 0 );
            if( iSpeed > 0 && cfsetispeed( &sTerm, iSpeed ) == 0 && cfsetospeed( &sTerm, iSpeed ) == 0 )
            {
               iValue = cfgetispeed( &sTerm );
               tcflush( iPort, TCIFLUSH );
               tcsetattr( iPort, TCSANOW, &sTerm );
            }
            iValue = modem_speed( iValue, 1 );
         #endif

         hb_retni( iValue );
      }
   ENDIF
RETURN nValue

METHOD DataBits( nBits ) CLASS TStreamSerial
LOCAL nValue := 0
   IF ::nPort > 0
      nValue := HB_INLINE( ::nPort, nBits ){
         int iValue;
         PORTHANDLE iPort = PORTparam( 1 );
         int iBits = ISNUM( 2 ) ? hb_parni( 2 ) : -1;

         #ifdef __WIN32__
            DCB dcb;

            GetCommState( iPort, &dcb );
            iValue = dcb.ByteSize;
            if( iBits > 0 )
            {
               dcb.ByteSize = iBits;
               if( SetCommState( iPort, &dcb ) )
               {
                  iValue = dcb.ByteSize;
               }
            }
         #else
            struct termios sTerm;

            tcgetattr( iPort, &sTerm );
            iValue = sTerm.c_cflag & CSIZE;
            if( iBits >= 5 && iBits <= 8 )
            {
               if( iBits == 5 ) iBits = CS5;
               if( iBits == 6 ) iBits = CS6;
               if( iBits == 7 ) iBits = CS7;
               if( iBits == 8 ) iBits = CS8;
               sTerm.c_cflag = ( sTerm.c_cflag & ( ~CSIZE ) ) | iBits;
               tcflush( iPort, TCIFLUSH );
               if( tcsetattr( iPort, TCSANOW, &sTerm ) )
               {
                  iValue = sTerm.c_cflag & CSIZE;
               }
            }
            if( iValue == CS5 ) iValue = 5;
            if( iValue == CS6 ) iValue = 6;
            if( iValue == CS7 ) iValue = 7;
            if( iValue == CS8 ) iValue = 8;
         #endif

         hb_retni( iValue );
      }
   ENDIF
RETURN nValue

METHOD Parity( cParity ) CLASS TStreamSerial
LOCAL cValue := " "
   IF ::nPort > 0
      cValue := HB_INLINE( ::nPort, cParity ){
         char cValue;
         PORTHANDLE iPort = PORTparam( 1 );
         int iValue, iParity;
         char cParity = ( ISCHAR( 2 ) && hb_parclen( 2 ) >= 1 ) ? ( *( hb_parc( 2 ) ) | 0x20 ) : 0;

         #ifdef __WIN32__
            DCB dcb;

            GetCommState( iPort, &dcb );
            iValue = dcb.Parity;

            iParity = -1;
            if( cParity == 'n' ) iParity = NOPARITY;      // 0
            if( cParity == 'o' ) iParity = ODDPARITY;     // 1
            if( cParity == 'e' ) iParity = EVENPARITY;    // 2
            if( cParity == 'm' ) iParity = MARKPARITY;    // 3
            if( cParity == 's' ) iParity = SPACEPARITY;   // 4
            if( iParity >= 0 )
            {
               dcb.Parity = iParity;
               if( SetCommState( iPort, &dcb ) )
               {
                  iValue = dcb.Parity;
               }
            }
            cValue = ' ';
            if( iValue == NOPARITY    ) cValue = 'N';
            if( iValue == ODDPARITY   ) cValue = 'O';
            if( iValue == EVENPARITY  ) cValue = 'E';
            if( iValue == MARKPARITY  ) cValue = 'M';
            if( iValue == SPACEPARITY ) cValue = 'S';
         #else
            struct termios sTerm;

            tcgetattr( iPort, &sTerm );
            iValue = sTerm.c_cflag & ( PARENB | PARODD );

            iParity = -1;
            if( cParity == 'n' ) iParity = 0;
            if( cParity == 'o' ) iParity = PARENB | PARODD;
            if( cParity == 'e' ) iParity = PARENB;
            if( iParity >= 0 )
            {
               sTerm.c_cflag = ( sTerm.c_cflag & ( ~( PARENB | PARODD ) ) ) | iParity;
               tcflush( iPort, TCIFLUSH );
               if( tcsetattr( iPort, TCSANOW, &sTerm ) )
               {
                  iValue = sTerm.c_cflag & ( PARENB | PARODD );
               }
            }
            cValue = ' ';
            if( iValue ==   0                 ) cValue = 'N';
            if( iValue == ( PARENB | PARODD ) ) cValue = 'O';
            if( iValue ==   PARENB            ) cValue = 'E';
         #endif

         hb_retclen( &cValue, 1 );
      }
   ENDIF
RETURN cValue

METHOD StopBits( nBits ) CLASS TStreamSerial
LOCAL nValue := 0
   IF ::nPort > 0
      nValue := HB_INLINE( ::nPort, IF( HB_IsNumeric( nBits ), nBits * 2, 0 ) ){
         int iValue;
         PORTHANDLE iPort = PORTparam( 1 );
         int iBits = ISNUM( 2 ) ? hb_parni( 2 ) : -1;

         #ifdef __WIN32__
            DCB dcb;

            GetCommState( iPort, &dcb );
            iValue = dcb.StopBits;
            if( iBits >= 2 && iBits <= 4 )
            {
               dcb.StopBits = iBits - 2;
               if( SetCommState( iPort, &dcb ) )
               {
                  iValue = dcb.StopBits;
               }
            }
            iValue = iValue + 2;
         #else
            struct termios sTerm;

            tcgetattr( iPort, &sTerm );
            iValue = sTerm.c_cflag & CSTOPB;
            if( iBits == 2 || iBits == 4 )
            {
               iBits = ( iBits == 2 ) ? 0 : CSTOPB;
               sTerm.c_cflag = ( sTerm.c_cflag & ( ~CSTOPB ) ) | iBits;
               tcflush( iPort, TCIFLUSH );
               if( tcsetattr( iPort, TCSANOW, &sTerm ) )
               {
                  iValue = sTerm.c_cflag & CSTOPB;
               }
            }
            iValue = ( iValue == CSTOPB ) ? 4 : 2;
         #endif

         hb_retni( iValue );
      } / 2
   ENDIF
RETURN nValue
