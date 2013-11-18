/*
 * $Id: MpmAso.prg,v 1.1 2013-11-18 20:40:25 migsoft Exp $
 */

#include "oohg.ch"

*---------------------------------------------------------------------*
PROCEDURE ShowAssociation(cExt)
*---------------------------------------------------------------------*

  LOCAL cKey
  LOCAL cVal

  BEGIN SEQUENCE
    cKey := 'Software\CLASSES\' + cExt
    IF !IsRegistryKey(HKEY_LOCAL_MACHINE, cKey)
      BREAK
    ENDIF
    cVal := GetRegistryValue(HKEY_LOCAL_MACHINE, cKey)
    IF EMPTY(cVal)
      BREAK
    ENDIF
    cKey := 'Software\CLASSES\' + cVal + '\Shell\Open\command'
    IF !IsRegistryKey(HKEY_LOCAL_MACHINE, cKey)
      BREAK
    ENDIF
    cVal := GetRegistryValue(HKEY_LOCAL_MACHINE, cKey)
    IF EMPTY(cVal)
      BREAK
    ENDIF
    IF UPPER(cVal) == UPPER(GETEXEFILENAME())
      MsgInfo(UPPER(cExt) + ' files are currently associated with MPM.')
    ELSE
      MsgInfo(UPPER(cExt) + ' files are currently associated with ' + ;
        cVal + '.')
    ENDIF
  RECOVER
    MsgInfo(UPPER(cExt) + ;
      ' files are not currently associated with any program.')
  END SEQUENCE

RETURN

*---------------------------------------------------------------------*
FUNCTION IsAssociated(cExt, lInit)
*---------------------------------------------------------------------*

  LOCAL cKey
  LOCAL cVal
  LOCAL lAssoc

  BEGIN SEQUENCE
    cKey := 'Software\CLASSES\' + cExt
    IF !IsRegistryKey(HKEY_LOCAL_MACHINE, cKey)
      BREAK
    ENDIF
    cVal := GetRegistryValue(HKEY_LOCAL_MACHINE, cKey)
    IF EMPTY(cVal)
      BREAK
    ENDIF
    cKey := 'Software\CLASSES\' + cVal + '\Shell\Open\command'
    IF !IsRegistryKey(HKEY_LOCAL_MACHINE, cKey)
      BREAK
    ENDIF
    cVal := GetRegistryValue(HKEY_LOCAL_MACHINE, cKey)
    IF EMPTY(cVal)
      BREAK
    ENDIF
    cVal   := ALLTRIM(STRTRAN(STRTRAN(cVal, '"'), '%1'))
    lAssoc := (UPPER(cVal) == UPPER(GETEXEFILENAME()))
  RECOVER
    lAssoc := !EMPTY(lInit)
  END SEQUENCE

RETURN lAssoc

*---------------------------------------------------------------------*
PROCEDURE ChangeAssociation(cExt, lSet)
*---------------------------------------------------------------------*

  LOCAL lAssoc := IsAssociated(cExt)
  LOCAL cKey

  DO CASE
  CASE lSet .AND. !lAssoc
    BEGIN SEQUENCE
      cKey := 'Software\CLASSES\' + cExt
      IF !CreateRegistryKey(HKEY_LOCAL_MACHINE, cKey)
        BREAK
      ENDIF
      IF !SetRegistryValue(HKEY_LOCAL_MACHINE, cKey,, 'mpmfile')
        BREAK
      ENDIF
      cKey := 'Software\CLASSES\mpmfile\Shell\Open\command'
      IF !CreateRegistryKey(HKEY_LOCAL_MACHINE, cKey)
        BREAK
      ENDIF
      IF !SetRegistryValue(HKEY_LOCAL_MACHINE, cKey,, ;
        AddQuote(GETEXEFILENAME()) + ' "%1"')
        BREAK
      ENDIF
    RECOVER
      MsgStop('Unable to associate ' + cExt + ' files with MPM.')
    END SEQUENCE
  CASE !lSet .AND. lAssoc
    BEGIN SEQUENCE
      cKey := 'Software\CLASSES'
      IF !DeleteRegistryKey(HKEY_LOCAL_MACHINE, cKey, cExt)
        BREAK
      ENDIF
    RECOVER
      MsgStop('Unable to disassociate ' + cExt + ' files from MPM.')
    END SEQUENCE
  ENDCASE

RETURN

* ============================================================================
*                    Registry Functions
* ============================================================================
FUNCTION IsRegistryKey( nKey, cRegKey )

   LOCAL oReg   := TReg32():New( nKey, cRegKey, .F. )
   LOCAL lExist := !oReg:lError

   oReg:Close()

RETURN lExist


FUNCTION CreateRegistryKey( nKey, cRegKey )

   LOCAL oReg     := TReg32():Create( nKey, cRegKey, .F. )
   LOCAL lSuccess := !oReg:lError

   oReg:Close()

RETURN lSuccess


FUNCTION GetRegistryValue( nKey, cRegKey, cRegVar, cType )

   LOCAL oReg     := TReg32():New( nKey, cRegKey, .F. )
   LOCAL lSuccess := !oReg:lError
   LOCAL uVal     := NIL

   DEFAULT cRegVar TO '', cType TO 'C'

   IF lSuccess

      DO CASE
      CASE cType == 'N'
        uVal := 0
      CASE cType == 'D'
        uVal := CTOD( '' )
      CASE cType == 'L'
        uVal := .F.
      OTHERWISE
        uVal := ''
      ENDCASE

      uVal := oReg:Get( cRegVar, uVal )
      IF oReg:nError < 0
        uVal := NIL
      ENDIF

   ENDIF

   oReg:Close()

RETURN uVal


FUNCTION SetRegistryValue( nKey, cRegKey, cRegVar, uVal )

   LOCAL oReg     := TReg32():New( nKey, cRegKey, .F. )
   LOCAL lSuccess := !oReg:lError

   DEFAULT cRegVar TO ''

   IF lSuccess
     oReg:Set( cRegVar, uVal )
     lSuccess := ( oReg:nError == 0 )
   END
   oReg:Close()

RETURN lSuccess


FUNCTION DeleteRegistryVar( nKey, cRegKey, cRegVar )

   LOCAL oReg     := TReg32():New( nKey, cRegKey, .F. )
   LOCAL lSuccess := !oReg:lError

   DEFAULT cRegVar TO ''

   IF lSuccess
     oReg:Delete( cRegVar )
     lSuccess := ( oReg:nError == 0 )
   END
   oReg:Close()

RETURN lSuccess


FUNCTION DeleteRegistryKey( nKey, cRegKey, cSubKey )

   LOCAL oReg     := TReg32():New( nKey, cRegKey, .F. )
   LOCAL lSuccess := !oReg:lError

   IF lSuccess
     oReg:KeyDelete( cSubKey )
     lSuccess := ( oReg:nError == 0 )
   END
   oReg:Close()

RETURN lSuccess
