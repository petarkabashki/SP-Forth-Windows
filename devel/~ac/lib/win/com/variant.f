\ $Id: variant.f,v 1.4 2008/07/23 17:19:45 spf Exp $
\ ���������, ���������, ������� � ������� ��� ������ � IDispatch.
\ ��������� ������ ��������� ~yz/automat*.f, �� ��� ������ ����������,
\ � ���, �� 10�� ������ (bin).
\ ������������ � �������� ~ac/lib/ns/com-xt.f

REQUIRE CLSID,  ~ac/lib/win/com/com.f

     0 CONSTANT VT_EMPTY
     1 CONSTANT VT_NULL
     2 CONSTANT VT_I2
     3 CONSTANT VT_I4
     4 CONSTANT VT_R4
     5 CONSTANT VT_R8
     6 CONSTANT VT_CY
     7 CONSTANT VT_DATE
     8 CONSTANT VT_BSTR
     9 CONSTANT VT_DISPATCH
    10 CONSTANT VT_ERROR
    11 CONSTANT VT_BOOL
    12 CONSTANT VT_VARIANT
    13 CONSTANT VT_UNKNOWN
    14 CONSTANT VT_DECIMAL
    16 CONSTANT VT_I1
    17 CONSTANT VT_UI1
    18 CONSTANT VT_UI2
    19 CONSTANT VT_UI4
    20 CONSTANT VT_I8
    21 CONSTANT VT_UI8
    22 CONSTANT VT_INT
    23 CONSTANT VT_UINT
    24 CONSTANT VT_VOID
    25 CONSTANT VT_HRESULT
    26 CONSTANT VT_PTR
    27 CONSTANT VT_SAFEARRAY
    28 CONSTANT VT_CARRAY
    29 CONSTANT VT_USERDEFINED
    30 CONSTANT VT_LPSTR
    31 CONSTANT VT_LPWSTR
    36 CONSTANT VT_RECORD
    37 CONSTANT VT_INT_PTR
    38 CONSTANT VT_UINT_PTR
    64 CONSTANT VT_FILETIME
    65 CONSTANT VT_BLOB
    66 CONSTANT VT_STREAM
    67 CONSTANT VT_STORAGE
    68 CONSTANT VT_STREAMED_OBJECT
    69 CONSTANT VT_STORED_OBJECT
    70 CONSTANT VT_BLOB_OBJECT
    71 CONSTANT VT_CF
    72 CONSTANT VT_CLSID
    73 CONSTANT VT_VERSIONED_STREAM
 0xFFF CONSTANT VT_BSTR_BLOB
0x1000 CONSTANT VT_VECTOR
0x2000 CONSTANT VT_ARRAY
0x4000 CONSTANT VT_BYREF
0x8000 CONSTANT VT_RESERVED
0xFFFF CONSTANT VT_ILLEGAL
 0xFFF CONSTANT VT_ILLEGALMASKED
 0xFFF CONSTANT VT_TYPEMASK

USER uParams
USER-CREATE uCRes 16 USER-ALLOT
USER-CREATE uCExc 32 USER-ALLOT
USER-CREATE uCPar 16 USER-ALLOT
USER uCErr

: NVAR ( val type -- variant )
  16 ALLOCATE THROW >R
  R@ ! R@ 8 + !
  R>
;
: NSTR ( addr u -- variant )
  >BSTR VT_BSTR NVAR
;
: >VBSTR ( addr u -- var type )
\ ���������� ������������ ��� ��������������� ������ ����������
  >BSTR VT_BSTR
;
: param@ ( variant -- ... )
\ ���������� �� ������ ���������� (������� FORTH.NEGATE(VAR)) ����������
\ ���������������, ��� ���� �� ���� �������� ��������.
\ ��� ������ ��������� ������������, �� ���� ��������� ����,
\ � ������� ������������.
  >R
  COM-DEBUG @ IF CR ." TYPE=" R@ W@ . THEN
  R@ W@ 0 = IF R> 2 CELLS + @ COM-DEBUG @ IF DUP . ." -0," THEN EXIT THEN
  R@ W@ 2 = IF R> 2 CELLS + @ COM-DEBUG @ IF DUP . ." ," THEN EXIT THEN
  R@ W@ 3 = IF R> 2 CELLS + @ COM-DEBUG @ IF DUP . ." ," THEN EXIT THEN
  R@ W@ 11 = IF R> 2 CELLS + @ COM-DEBUG @ IF DUP . ." -b," THEN EXIT THEN \ bool
  R@ W@ 9 = IF R> 2 CELLS + @ COM-DEBUG @ IF DUP . ." -d," THEN EXIT THEN \ idisp
  R@ W@ 13 = IF R> 2 CELLS + @ COM-DEBUG @ IF DUP . ." -u," THEN EXIT THEN \ iunk
  R@ W@ 8 = IF R> 2 CELLS + @ BSTR> COM-DEBUG @ IF 2DUP ." (" TYPE ." )," THEN EXIT THEN
  R@ W@ 0x400B = IF R> 2 CELLS + @ COM-DEBUG @ IF DUP . ." in/out bool by ref," THEN EXIT THEN
  R@ W@ 0x400C = IF R> 2 CELLS + @ COM-DEBUG @ IF ." recurse variant:" THEN RECURSE EXIT THEN
  R@ W@ 0x4009 = IF R> 2 CELLS + @ COM-DEBUG @ IF ." disp by ref:" THEN EXIT THEN
  R@ W@ 0x2011 = IF R> 2 CELLS + @ COM-DEBUG @ IF DUP . ." array," THEN EXIT THEN
  COM-DEBUG @ IF ." UNKNOWN PTYPE=" R@ W@ . R> 2 CELLS + @ 16 DUMP THEN
  RDROP
;
: params@ ( varr -- ... )
  COM-DEBUG @ IF ." params=" THEN
  DUP @ uParams ! 2 CELLS + @ COM-DEBUG @ IF DUP . THEN 0 ?DO
    COM-DEBUG @ IF CR ." par" I . THEN
    uParams @ I 4 * CELLS + param@
  LOOP
;

\ ����� ������ �� �����:
\ GetIDsOfNames(IID_NULL, &pszName, 1, LOCALE_SYSTEM_DEFAULT, &dispid)
\ pdisp->Invoke(dispid, IID_NULL, LOCALE_SYSTEM_DEFAULT, wFlags, &dispparams, pvRet, pexcepinfo, pnArgErr);
\ wFlags:
\ 1 ��� 3 = CP@; par � res ������ ��������� �� ������ ���������, ����� ������� E_NOTIMPL
\ 4 ��� 5 = CP!; par ������ ��������� ������ DISPPARAMS � ����� ����� ����������, ����� E_NOTIMPL

: NEWVARR ( ... params# -- varr )
\ ������������ ������� variant'�� � ������� DISPPARAMS.
\ �� ����� �������� ���� value type � ����� params# ����� ���.
\ �� ������ DISPPARAMS, ������� ���� ����������� �� FREE ����� �������������.
  DUP 1+ 16 * ALLOCATE THROW >R
  R@ 16 + R@ !
  DUP R@ 8 + !
  R@ 16 + uCPar !
  0 ?DO
    ( value type) uCPar @ ! uCPar @ 8 + !
    uCPar @ 16 + uCPar !
  LOOP R>
;
: CP@ ( propa propu oid -- ... ) \ COM Proprety get
\ S" title" doc2 CP@ TYPE CR

  DUP >R
  ROT ROT GetIdOfName ?DUP IF RDROP THROW THEN ( id )
  >R
  uCErr 0! uCExc 32 ERASE uCRes 16 ERASE

  uCErr uCExc uCRes uCPar 2 0 IID_NULL R> R> ::Invoke THROW
  uCRes param@
;
: CP! ( ... params# propa propu oid -- ) \ COM Property put
\ ������: S" New TITLE" >BSTR VT_BSTR 1 S" title" doc2 CP!

  DUP >R
  ROT ROT GetIdOfName ?DUP IF RDROP THROW THEN ( ... params# id )
  >R
  uCErr 0! uCExc 32 ERASE uCRes 16 ERASE
  ( ... params#) NEWVARR uCPar !
  uCErr uCExc uCRes uCPar @ 4 0 IID_NULL R> R> ::Invoke ( ior )
  uCPar @ FREE THROW
  THROW
;
: CNEXEC ( ... params# proca procu oid -- ... ) \ COM Name Execute
\ �������:
\ 0 S" releaseCapture" doc3 CNEXEC DROP
\ S" <H1>TEST</H1>" >VBSTR 1 S" write" doc2 CNEXEC DROP

  DUP >R
  ROT ROT GetIdOfName ?DUP IF RDROP THROW THEN ( ... params# id )
  >R
  uCErr 0! uCExc 32 ERASE uCRes 16 ERASE
  ( ... params#) NEWVARR uCPar !
  uCErr uCExc uCRes uCPar @ 1 0 IID_NULL R> R> ::Invoke ( ior )
  uCPar @ FREE THROW
  THROW
  uCRes param@
;
: ID@ ( dispid oid -- ... ) \ COM Proprety get by dispid
\ ������ idispatch-���������� ��������� ��������� "�����������" ������
\ � ������ ��������� ID, ������� ������ ��������� �� ����� -
\ ��������� ����� IID ����������� ����������, � �������� � vmt, �������
\ "������� ����������" (��� ������������ ������� ����������) ����������
\ ����� ��� ����� ����� �� ������ (dispid), ������� ��� "�����������" �������.
\ ���, ��������, ���� ����������� �������� �������
\  ^ en IID_������������������� elcol ::QueryInterface THROW
\  ^ enu en ::get__newEnum(�������������������) THROW enu
\ ��
\ DISPID_NEWENUM col ID@
\ ������� ��. � collections.f, ����������� dispid � OAIdl.h.

  >R >R
  uCErr 0! uCExc 32 ERASE uCRes 16 ERASE

  uCErr uCExc uCRes uCPar 2 0 IID_NULL R> R> ::Invoke THROW
  uCRes param@
;
WINAPI: SafeArrayCreateVector OLEAUT32.DLL
WINAPI: SafeArrayAccessData   OLEAUT32.DLL
WINAPI: SafeArrayUnaccessData OLEAUT32.DLL
WINAPI: SafeArrayDestroy      OLEAUT32.DLL

: >SARR ( addr u -- sarr ) \ ������� ����� �� SafeArrayDestroy
\ ������: S" <H1>TEST</H1>" >SARR doc2 ::write DROP
  >BSTR 
  1 0 VT_VARIANT SafeArrayCreateVector DUP >R
  0 >R RP@ SWAP SafeArrayAccessData THROW ( bstr, R: sarr ppvData)
  R@ .
  VT_BSTR R@ ! R> 8 + !
  R@ SafeArrayUnaccessData THROW
  R>
;
