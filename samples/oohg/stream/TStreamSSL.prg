/*
 * $Id: TStreamSSL.prg,v 1.2 2017-07-09 20:16:20 guerra000 Exp $
 */
/*
 * Data stream from (((compress/)))uncompress management class.
 *
 * TStreamSSL. Reads/writes data over a SSL connection.
 *             It requires OpenSSL library.
 *
 * Some info about openssl DLL:
 * Embarcadero: http://docwiki.embarcadero.com/RADStudio/Tokyo/en/OpenSSL
 * ZIP files: http://indy.fulgan.com/SSL/
 *
 * Version 0.9.8zh worked OK
 * Version 1.0.2k generates GPF
*/

#include "hbclass.ch"

#pragma BEGINDUMP

#include <hbapi.h>

/////////////////////////// Own #include <openssl/ssl.h> :
//#include "openssl/ssl.h"
// Structures
typedef struct __CTX { void *v; } SSL_CTX;
typedef struct __SSL { void *v; } SSL;
typedef struct __BIO { void *v; } BIO;
typedef struct __SSL_METHOD { void *v; } SSL_METHOD;
// Functions
extern int          SSL_library_init( void );
extern void         SSL_load_error_strings( void );
extern SSL_METHOD * SSLv23_method( void );
extern SSL_CTX    * SSL_CTX_new( SSL_METHOD * );
extern SSL        * SSL_new( SSL_CTX * );
extern BIO        * BIO_new_socket( int, int );
extern void         SSL_set_bio( SSL *, BIO *, BIO * );
extern int          SSL_connect( SSL * );
extern int          SSL_get_error( SSL *, int );
extern int          SSL_shutdown( SSL * );
extern void         SSL_free( SSL * );
extern int          BIO_free( BIO * );
extern void         SSL_CTX_free( SSL_CTX * );
extern int          SSL_read( SSL *, void *, int );
extern int          SSL_write( SSL *, void *, int );
// Constants
#define SSL_ERROR_NONE             0
#define SSL_ERROR_SSL              1
#define SSL_ERROR_WANT_READ        2
#define SSL_ERROR_WANT_WRITE       3
#define BIO_NOCLOSE                0
#define BIO_CLOSE                  1

int bInit = 0;

HB_FUNC( SSL_CTX_NEW )
{
   SSL_CTX *pCtx;

   if( ! bInit )
   {
      SSL_library_init();
      SSL_load_error_strings();
      bInit = 1;
   }

   pCtx = SSL_CTX_new( SSLv23_method() );

   hb_retptr( pCtx );
}

HB_FUNC( SSL_NEW )   // ( pCtx )
{
   hb_retptr( SSL_new( ( SSL_CTX * ) hb_parptr( 1 ) ) );
}

HB_FUNC( BIO_NEW_SOCKET )   // ( nSocket )
{
   hb_retptr( BIO_new_socket( hb_parni( 1 ), BIO_NOCLOSE ) );
}

HB_FUNC( SSL_SET_CONNECT )   // ( pSsl, pBio )
{
   SSL *pSsl;
   int iErr, ii, iSw;

   pSsl = ( SSL * ) hb_parptr( 1 );

// HB_FUNC( SSL_SET_BIO )
   SSL_set_bio( pSsl, ( BIO * ) hb_parptr( 2 ), ( BIO * ) hb_parptr( 2 ) );

// HB_FUNC( SSL_CONNECT )
   iSw = 1;
   while( iSw )
   {
      ii = SSL_connect( pSsl );
      if( ii < 0 )
      {
         iErr = SSL_get_error( pSsl, ii );
         if( iErr != SSL_ERROR_WANT_READ )
         {
            iSw = 0;
         }
      }
      else
      {
         iSw = 0;
      }
   }

   // if( require_server_auth )     check_cert( pSsl, cHost );

}

HB_FUNC( SSL_SHUTDOWN )   // ( pSsl )
{
// HB_FUNC( SSL_SHUTDOWN )
   SSL_shutdown( ( SSL * ) hb_parptr( 1 ) );
   SSL_shutdown( ( SSL * ) hb_parptr( 1 ) );

// HB_FUNC( SSL_FREE )
   SSL_free( ( SSL * ) hb_parptr( 1 ) );
}

HB_FUNC( BIO_FREE )   // ( pBio )
{
   // It's already freed by SSL_Shutdown
   // BIO_free( ( BIO * ) hb_parptr( 1 ) );
}

HB_FUNC( SSL_CTX_FREE )   // ( pCtx )
{
   SSL_CTX_free( ( SSL_CTX * ) hb_parptr( 1 ) );
}

#pragma ENDDUMP

CLASS TStreamSSL FROM TStreamSocket
   DATA pCtx    INIT nil
   DATA pSsl    INIT nil
   DATA pBio    INIT nil

   METHOD New
   METHOD IsConnected
   //
   METHOD RealFill
   METHOD Disconnect
   //
   METHOD Write
ENDCLASS

METHOD New( cHost, nPort, nSocket ) CLASS TStreamSSL
LOCAL pCtx
   ::Close()
   pCtx := SSL_CTX_NEW()
   IF ! EMPTY( pCtx )
      ::Super:New( cHost, nPort, nSocket )
      ::pCtx := pCtx
      IF ::nSocket > 0
         ::pSsl := SSL_new( ::pCtx )
         ::pBio := BIO_new_socket( ::nSocket )
         IF ! EMPTY( ::pSsl ) .AND. ! EMPTY( ::pBio )
            SSL_SET_CONNECT( ::pSsl, ::pBio )
         ELSE
            ::Close()
         ENDIF
      ENDIF
   ENDIF
   IF ! ::IsActive()
      ::Close()
   ENDIF
RETURN Self

METHOD IsConnected() CLASS TStreamSSL
RETURN ( ::nSocket > 0 .AND. ! EMPTY( ::pSsl ) )

METHOD RealFill( pBuffer, nPos, nCount ) CLASS TStreamSSL
RETURN StreamSSL_Read( pBuffer, ::pSsl, nPos, nCount )

METHOD Disconnect() CLASS TStreamSSL
   IF ! EMPTY( ::pSsl )
      SSL_shutdown( ::pSsl )
      // SSL_free( ::pSsl )
      ::pSsl := NIL
   ENDIF
   IF ! EMPTY( ::pBio )
      BIO_free( ::pBio )
      ::pBio := NIL
   ENDIF
   IF ! EMPTY( ::pCtx )
      SSL_CTX_free( ::pCtx )
      ::pCtx := NIL
   ENDIF
RETURN ::Super:Disconnect()

METHOD Write( cBuffer ) CLASS TStreamSSL
LOCAL nWrite := 0
   IF ::IsConnected()
      IF VALTYPE( cBuffer ) $ "CM" .AND. LEN( cBuffer ) > 0
         nWrite := StreamSSL_Write( ::pSsl, cBuffer )
         IF nWrite < 0
            ::Disconnect()
         ENDIF
      ENDIF
   ENDIF
RETURN nWrite

#pragma BEGINDUMP

HB_FUNC( STREAMSSL_READ )   // ( pBuffer, pSsl, nStart, nCount )
{
   char *pBuffer;
   SSL *pSsl;
   int iRead = 0;
   int iErr;

   pBuffer = ( char * ) hb_parptr( 1 );
   pSsl = ( SSL * ) hb_parptr( 2 );
   if( pBuffer && pSsl )
   {
      iRead = SSL_read( pSsl, pBuffer + hb_parni( 3 ) - 1, hb_parni( 4 ) );
      iErr = SSL_get_error( pSsl, iRead );
      if( iErr != SSL_ERROR_NONE && iErr != SSL_ERROR_WANT_READ )
      // if( iErr != SSL_ERROR_NONE )
      {
         iRead = -1;
      }
      else if( iRead == -1 )
      {
         iRead = 0;
      }
   }

   hb_retni( iRead );
}

HB_FUNC( STREAMSSL_WRITE )   // ( pSsl, cBuffer )
{
   int iWrite = 0;
   SSL *pSsl;

   pSsl = ( SSL * ) hb_parptr( 1 );
   if( pSsl && hb_parclen( 2 ) )
   {
      iWrite = SSL_write( pSsl, ( void * ) hb_parc( 2 ), hb_parclen( 2 ) );
      if( SSL_get_error( pSsl, iWrite ) != SSL_ERROR_NONE )
      {
         iWrite = -1;
      }
   }

   hb_retni( iWrite );
}

#pragma ENDDUMP
