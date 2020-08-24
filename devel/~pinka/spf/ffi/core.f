\ 03.Aug.2008

REQUIRE DLOPEN          ~ac/lib/ns/dlopen.f
REQUIRE NAMING-         ~pinka/spf/compiler/native-wordlist.f
REQUIRE AsQName         ~pinka/samples/2006/syntax/qname.f \ ������� ����������� ����� � ���� `abc
REQUIRE STHROW          ~pinka/spf/sthrow.f

\ MODULE: ffi-support

\ some code from ~pinka/model/codegen/spf4-ffi.f.xml
\ see also ~ac/lib/ns/ns.f

: DLOPEN-SURE ( a u -- h ) 
  2DUP DLOPEN DUP IF  NIP NIP EXIT THEN 
  DROP CR TYPE CR `#lib-not-found STHROW
; 
: DLSYM-SURE ( a u h -- a ) 
  >R 2DUP R> DLSYM DUP IF  NIP NIP EXIT THEN 
  DROP CR TYPE CR `#func-not-found STHROW
; 
: FIND-DL-LIB ( d-lib x -- d-lib FALSE | entry TRUE )
  DROP \ parameter is reserved, must be 0
  2DUP DLOPEN DUP IF  NIP NIP TRUE EXIT THEN ( a u false )
;
: FIND-DL-FUNC ( d-func h -- d-func FALSE | entry TRUE )
  >R 2DUP R> DLSYM DUP IF NIP NIP TRUE EXIT THEN ( a u false )
;
: HAS-DL-LIB ( d-lib x -- flag )
  DROP \ parameter is reserved, must be 0
  DLOPEN 0<>
;
: HAS-DL-FUNC ( d-func h -- flag )
  DLSYM 0<>
;


: EXEC-FOREIGN-C1 ( i*x n-in entry-point -- x ) 
  SWAP DUP 2+ CELLS DRMOVE R> 0 R> EXECUTE (  [ n-in x ]  ) 
  SWAP RFREE
; 
: EXEC-FOREIGN-P1 ( i*x n-in entry-point -- x ) 
  SWAP 1+ CELLS DRMOVE 0 R> EXECUTE (  [ x ]  ) 
; 
( ����������:
  'EXEC'        -- �� ������� EXECUTE -- ���������;
  'FOREIGN'     -- ����� �����, �� ����;
  'P', 'C'      -- ������ ������ � ����������� ������;
  '1'           -- �� ������ ���� �������� [�������, ������� C � P ����� � �� �������������, 
                   �������, ����� ���� �������].
)


: CREATED-DLPOINT ( parent -- p )
  ALIGN HERE >R
  0 , \ handler (need to be erased on startup or before save)
    , \ parent
  0 , \ ref to name
  R>
;
: DLPOINT-NAME! ( c-addr p -- )  2 CELLS + ! ;
: DLPOINT-NAME@ ( p -- c-addr )  2 CELLS + @ ;
: DLPOINT-NAME ( p -- a u ) DLPOINT-NAME@ DUP IF COUNT EXIT THEN 0 ;
: DLPOINT-PARENT ( p1 -- p2 ) CELL+ @ ;
: SET-DLPOINT-NAME ( a u p -- ) ALIGN HERE SWAP DLPOINT-NAME! S", 0 C, ;
( �����, 
  ��������, ����� ������� XCOUNT, �� ��������� � ������, ������ COUNT,
  ������������ 255 �������� [ MAX_PATH ����� �������� 256, � URL -- ���� 2 Kb ]
)

: CACHE-DL ( p -- )
  DUP DLPOINT-NAME DLOPEN-SURE SWAP !
;
: DLPOINT-LIB ( p -- h )
  DUP @ DUP IF NIP EXIT THEN DROP
  DUP CACHE-DL @
;
: CACHE-DL-FUNC ( p -- )
  DUP >R DLPOINT-NAME R@ DLPOINT-PARENT DLPOINT-LIB DLSYM-SURE R> !
;
: DLPOINT-FUNC ( p -- a )
  DUP @ DUP IF NIP EXIT THEN DROP
  DUP CACHE-DL-FUNC @
;


: EXEC-DLPOINT-C1 ( i*x i p -- x )
  DLPOINT-FUNC EXEC-FOREIGN-C1
;
: EXEC-DLPOINT-P1 ( i*x i p -- x )
  DLPOINT-FUNC EXEC-FOREIGN-P1
;
\ ��������, ����� ������ ������ ������ ����� � DLPOINT?
\ (�� �����, ������ �� �� ������ � ���� ����� �������� ����������?)


\ ;MODULE



REQUIRE /TEST ~profit/lib/testing.f
/TEST

\ test
\ ���������� ����� "WAPI:" �� ������������ ���� ����.

: CREATE-WAPI ( d-func d-lib -- )
  0  CREATED-DLPOINT DUP >R SET-DLPOINT-NAME
  R> CREATED-DLPOINT DUP >R SET-DLPOINT-NAME
  :NONAME R@ LIT, ['] EXEC-DLPOINT-P1 COMPILE, POSTPONE ;
  R> DLPOINT-NAME NAMING-
;
: WAPI:
  NextWord NextWord CREATE-WAPI
;  

\ ��������� � ������

WAPI: MessageBoxA  user32.dll
0 S" test" DROP S" test passed" DROP 0  4 MessageBoxA . CR

\EOF
\ � ��� �������� �� �������
WINAPI: MessageBoxA  user32.dll
0 S" test" DROP S" test passed" DROP 0   MessageBoxA . CR


\EOF
todo: ������ ��������� ��������������
  ������ ���������� ������������ ������ � �� �������, ��� ��������
  memory management functions in the libxml2 (xmlFree & Co.)
    -- http://mail.gnome.org/archives/xml/2002-August/msg00107.html
  
  ��� PcreFree �� pcre.dll
    -- ��. ~ac/lib/string/regexp.f
  
  � ������ xmlFree "����� �����" ������������ �� ���� ��������� �� �������,
  ������� ����� ���� ������� ��������� �������:
    ( addr-to-be-freed ) 1
    `xmlFree `libxml2 DLOPEN-SURE DLSYM-SURE
    @
    EXEC-FOREIGN-C1
    1 <> THROW
