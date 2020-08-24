WARNING 0!
\ --------- ������ ActiveX-������� ----------------
\ ��. �������� ������� samples\com-sample4.f

REQUIRE Class:  ~ac/lib/win/com/com_server.f
REQUIRE params@ ~ac/lib/win/com/variant.f 

VARIABLE ForthComClassObject

VARIABLE LOCKCNT

VECT vSPF.Application
VECT vSPF.IDispatch


\ ===================== ������� ����� IUnknown ========================
IID_IUnknown
Class: SPF.IUnknown {C6DFBA32-DF7B-4829-AA3B-EE4F90ED5961}

: ::QueryInterface ( ppvObject iid oid - hresult )
  SP@ 12 + S0 !
  COM-DEBUG @ IF Class. SPACE THEN
  OVER 0= IF 2DROP DROP E_NOINTERFACE EXIT THEN \ ��, ���� ��...
  DUP (AddRef) DROP
  2DUP ComClassIID 16 SWAP 16 COMPARE 0= IF NIP SWAP ! 0 EXIT THEN \ � ��� ���� ���������
  OVER 16 IID_IUnknown 16 COMPARE 0= 
          IF COM-DEBUG @ IF ." QI:Unknown," THEN 2DROP SPF.IUnknown SWAP ! 0 EXIT THEN
  OVER 16 IID_IClassFactory 16 COMPARE 0= 
          IF COM-DEBUG @ IF ." QI:IClassFactory," THEN 2DROP vSPF.Application SWAP ! 0 EXIT THEN
  OVER 16 IID_IDispatch 16 COMPARE 0= 
          IF COM-DEBUG @ IF ." QI:IDispatch," THEN 2DROP vSPF.IDispatch SWAP ! 0 EXIT THEN
  OVER 16 vSPF.Application Class 16 COMPARE 0= 
          IF COM-DEBUG @ IF ." QI:IForth," THEN 2DROP vSPF.Application SWAP ! 0 EXIT THEN
  COM-DEBUG @ IF ." QI:EXT:" THEN
  OVER CLSID>String THROW UNICODE>
  SFIND IF ( ppvObject iid oid ) EXECUTE EXIT THEN \ ��� ��������������� ����� �����������
  COM-DEBUG @ IF TYPE ." ;" ELSE 2DROP THEN
  (Release) DROP
  DROP 0!
  E_NOINTERFACE
; METHOD

: ::AddRef ( oid -- cnt )
\ ����� ���� �� �� ������ ::QueryInterface ��������� ������ (�������� � ����)
\ �� ������� �� ��������� ������ �������� ����������� (������) ���������, 
\ � ����� ����� ������ ������� � ���, �� ��� �������� ������������� ��� ������.
  COM-DEBUG @ IF CR Class. THEN
  (AddRef)
  COM-DEBUG @ IF ." ar=" DUP . THEN
; METHOD

: ::Release ( oid -- cnt )
  COM-DEBUG @ IF Class. THEN
  (Release)
  COM-DEBUG @ IF ." re:" DUP . THEN
; METHOD

Class;

\ ===================== IClassFactory ===================================
IID_IClassFactory
Class: SPF.Application {C6DFBA32-DF7B-4829-AA3B-EE4F90ED5961} \ ���� clsid �����
Extends SPF.IUnknown


: ::CreateInstance ( ppvObject riid pUnkOuter oid -- hresult )
\ ��. ����������� � ::AddRef ����.
  COM-DEBUG @ IF Class. THEN
  DROP DROP DROP ( ForthIForth) SPF.Application SWAP ! 0
; METHOD

: ::LockServer ( fLock oid -- hresult )
  COM-DEBUG @ IF Class. THEN
  DROP
  IF LOCKCNT 1+! ELSE LOCKCNT @ 1- LOCKCNT ! THEN
  0
; METHOD

Class;

' SPF.Application TO vSPF.Application

USER uSPInvoke
USER uExcep
USER uFlags
USER uOID

: IsVariable@ ( xt -- flag )
  DUP 1+ @ + CFL + ['] _CREATE-CODE =
  uFlags @ DISPATCH_PROPERTYPUT AND 0= AND
  DUP IF COM-DEBUG @ IF ."  VARIABLE@ " THEN THEN
;

VECT vExecuteByID

: DropXtParams ( ... idxt -- )
  \ ��� ������ ������������ id, �������� ���������������� events
  \ ������ ������� ��������� � �������, ����� ����� ������� �����������
  uSPInvoke @ SP!  
; \ ' DropXtParams TO vExecuteByID

: IINVOKE ( ... oid addr u -- ... )
\ ��������� ����� � ������ addr u ��� ������� oid
\ ����� OID - �� COM-oid (��������� �� ��������� �� VTABLE),
\ � �������� WID:
\ ��� ���������� ���������� INVOKE �� ~ac/lib/ns/ns.f, ��� ������ �� �������.
  ROT ( addr u oid )
  DUP 0= ABORT" Invalid IINVOKE call"
  CLASS@ DUP 0= IF DROP FORTH-WORDLIST THEN ( addr u class-oid )
  SEARCH-WORDLIST
  IF EXECUTE ELSE -3004 THROW THEN
;
: ExecuteByID1 ( ... idxt -- )
\  uOID @ SpfClassWid NLIST CR
  uOID @ SpfClassWid S" EXECUTE-BY-ID" IINVOKE
; ' ExecuteByID1 TO vExecuteByID

: EXECUTE-BY-ID ( ... idxt -- res ) \ ���������� �� ���������
  >R
  uOID @ SpfClassWid @
  BEGIN
    DUP
  WHILE
    DUP NAME> >BODY @ R@ = IF RDROP NAME> EXECUTE EXIT THEN
    CDR
  REPEAT DROP DropXtParams R> CR ." ID:" . ." - not found" CR
;
: ID: \ ID: DISPID_DOCUMENTCOMPLETE     259
  CREATE NextWord EVALUATE , HERE 0 , :NONAME SWAP !
  DOES> CELL+ @ EXECUTE
;
: EXECUTE-COM ( ... xt -- ... )
  DUP IMAGE-BASE < IF vExecuteByID EXIT THEN
  DUP HERE >       IF vExecuteByID EXIT THEN
  DUP WordByAddr COM-DEBUG @ IF ." Method=" 2DUP TYPE CR THEN
  DROP 2 S" <?" COMPARE 0= IF vExecuteByID EXIT THEN
  DUP IsVariable@ IF EXECUTE @ EXIT THEN
  EXECUTE
;
USER INVOKE_VOID

\ ===================== IDispatch ===================================

IID_IDispatch
Class: SPF.IDispatch {C6DFBA32-DF7B-4829-AA3B-EE4F90ED5961}
Extends SPF.IUnknown

: ::GetTypeInfoCount ( pctinfo oid -- 0 | 1 )
  COM-DEBUG @ IF Class. THEN
  2DROP 0
; METHOD

: ::GetTypeInfo      ( ppTInfo lcid iTInfo oid -- hresult )
  COM-DEBUG @ IF Class. THEN
  2DROP 2DROP 1
; METHOD

: ::GetIDsOfNames    ( rgDispId lcid cNames rgszNames riid oid -- hresult )
  COM-DEBUG @ IF Class. THEN
  2DROP
  ( ." rgszNames=") @ UASCIIZ> UNICODE> ( 2DUP) 2>R ( TYPE)
\  ."  cNames=" .
DROP
\  ." lcid=" .
DROP
\  ." rgDispId=" DUP .
  2R> SFIND 
  IF SWAP ! 0 
  ELSE 2DROP -1 SWAP ! DISP_E_UNKNOWNNAME THEN
; METHOD

: ::Invoke           ( puArgErr pExcepInfo pVarResult pDispParams wFlags lcid riid dispIdMember oid -- hresult )
  COM-DEBUG @ IF Class. THEN
  COM-DEBUG @ IF ." oid=" DUP . ." class=" DUP SpfClassName TYPE CR THEN uOID !
  COM-DEBUG @ IF ." dispIdMember=" DUP . THEN >R
  DROP ( reserved)
  COM-DEBUG @ IF ." lcid=" . ELSE DROP THEN
  COM-DEBUG @ IF ." wFlags=" DUP . THEN uFlags !
  COM-DEBUG @ IF ." pDispParams=" DUP . CR THEN >R \ R@ 20 DUMP
  COM-DEBUG @ IF ." pVarResult=" DUP . THEN
  DUP 0= IF DROP INVOKE_VOID THEN 2R> ROT >R 2>R
  COM-DEBUG @ IF ." pExcepInfo=" DUP . THEN uExcep !
  COM-DEBUG @ IF ." puArgErr=" . ELSE DROP THEN
  SP@ DUP uSPInvoke ! S0 !
  R> params@
  R> ['] EXECUTE-COM CATCH ?DUP 
     IF ( DUP .) uExcep @ W! S" FORTH" >BSTR uExcep @ CELL+ !
        uSPInvoke @ SP! RDROP
        DISP_E_EXCEPTION EXIT
     THEN
  SP@ uSPInvoke @ -   COM-DEBUG @ IF ." DD=" DUP . THEN
  DUP -4 = IF DROP
              3 R@ ! ( uFlags @ 3 = IF @ THEN) \ ������ �� ������ ������� ����� method � property_get
              R> 2 CELLS + ! 0 EXIT
           THEN \ �����
  DUP -8 = IF DROP
              uFlags @ DISPATCH_PROPERTYPUT AND 
              IF ! RDROP 0 EXIT THEN \ ���������� ���������� �����
              8 R@ ! >BSTR R> 2 CELLS + ! 0 EXIT
           THEN \ ������
  0 = IF RDROP 0 EXIT THEN \ ��� �����������
  uSPInvoke @ SP! RDROP 
  DISP_E_BADPARAMCOUNT COM-DEBUG @ IF ." res=DISP_E_BADPARAMCOUNT" CR THEN
; METHOD

Class;

' SPF.IDispatch TO vSPF.IDispatch

: ComRegisterForth ( -- ior )
  ForthComClassObject
  REGCLS_MULTIPLEUSE
  CLSCTX_LOCAL_SERVER
  SPF.Application
  SPF.Application Class
  CoRegisterClassObject
;

: RUN
  ComInit 0=
  IF
    ComRegisterForth DROP \ HEX U. DECIMAL
  THEN
  ?GUI IF -1 PAUSE ELSE MAIN1 THEN
;
\ : -Embedding RUN ;
: -Embedding ;

\EOF
REQUIRE KoiWin ~ac/lib/string/conv2.f

FALSE TO SPF-INIT?
TRUE TO ?GUI
\ FALSE TO ?CONSOLE
' RUN TO <MAIN>
\ ' RUN MAINX !
S" spfcs.exe" SAVE BYE
