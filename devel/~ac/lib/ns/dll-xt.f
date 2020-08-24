( ~ac 16.08.2005
  $Id: dll-xt.f,v 1.8 2008/03/27 20:50:18 spf Exp $

  �������� ���� ns.f � ����� ���������� ������������� ������������� 'WINAPI:'
  ������ ����� ������� DLL ����� ������������ � ������ �������������
  �����������. ��� ���� � ��� �������������� ���������� ������ � ����� 
  ������� �� DLL, � SFIND ������ ����� NOOP.

  �� ���� �� ������������ ����� ���� �� ������������� � ������������� -
  ��� ��� �������� �� ������ [DL NEW:] ��� ��������� ���������� �����������.
  ��. ������� � ����� �����.

  ���������, ������������� � ��������� ������ ��� �����������
  ���������� ������� DLL [������ ���� inline WINAPI]

  CALL DLL-CALL
  1. ������_���������_�������_asciiz_���_�������
                                             \ ������ �� __WIN:
  2. ���_�����_�������_�_dll                 \ = address of winproc
  3. dll_wid                                 \ ������ address of library name
  4. ������_��_asciiz_���_�������            \ = address of function name
  5. �����_����������_����_��������_�����_-1 \ # of parameters
  6. ������_��_����������_��������_���������_������� \ WINAPLINK
  asciiz_���_�������

  ���������:

  ������_���������_�������_asciiz_���_�������:
  - ������� ���� �������� � RP ��� �������� � ��������� ����������,
  �.�. 6 CELLS ���� ����� ����� ������� ���� 1 [������� ���������� asciiz]

  ���_�����_�������_�_dll:
  - ����� ������� ��� �������� � API-CALL; ������ ���� ������� ���
  ���������� EXE ��� ��� ������ EXE � ��� ����� ���������-��������� DLL

  dll_wid:
  - ������ �� �������, ���������� �����������-��������� ������ DLL

  ������_��_asciiz_���_�������:
  - � ������ ������ ������ ������, �� ������������ ��� ������������� � __WIN:

  �����_����������_����_��������_�����_-1:
  - � ����������� �� ��������������� ������� ����� ���� �������� ����� ����������...

  !!! � ������� ������ "����� ����������" �� ������������, �������� API-CALL

  ������_��_����������_��������_���������_�������:
  - winaplink, ���������� ��� ������ �������� ��� ���������
  ������������ ������� ���_�����_�������_�_dll

  asciiz_���_�������:
  - ��� ������� � ����� �� ����� ��� �������� � DLSYM
)

WARNING @ WARNING 0!
REQUIRE NEW: ~ac/lib/ns/ns.f

: DLL-INIT ( addr -- )
  DUP >R 6 CELLS + ASCIIZ> R@ CELL+ CELL+ @
  [ ALSO DL ] SEARCH-WORDLIST [ PREVIOUS ]
\  S" SEARCH-WORDLIST-I" INVOKE ( �� �� �����, �� ��������� :)
  0= IF -2010 THROW THEN R> CELL+ !
;
: DLL-CALL ( �� ����� ��������� ����� ��������� ������� ���������� ������� )
  R@ CELL+ @
  DUP 0= IF DROP R@ DLL-INIT R@ CELL+ @ THEN
  R@ @ R> + >R API-CALL
;
: DLL-CALL, ( funa funu n dll-wid xt -- addr )
  ['] DLL-CALL _COMPILE,

  HERE >R
  0 , \ size
    , \ address of winproc
    , \ address of library name
  HERE CELL+ CELL+ CELL+ , \ address of function name
    , \ # of parameters
  IS-TEMP-WL 0=
  IF
    HERE WINAPLINK @ , WINAPLINK ! ( ����� )
  ELSE 0 , THEN
  HERE SWAP DUP ALLOT MOVE 0 C, \ ��� �������
  HERE R@ - R@ !
  R>
;

\ S" function" 5 0xDDD 0xCCC DLL-CALL, 80 DUMP

<<: FORTH DLL
ALSO DL

: ?VOC DROP FALSE ;
: CAR ( wid -- item )
  ." DLL exports enumeration isn't supported now." CR
  DROP 0
;
: SHEADER ( addr u -- )
  ." Can't insert " TYPE ."  into " GET-CURRENT VOC-NAME. ."  DLL ;)" CR
  5 THROW
;
: SEARCH-WORDLIST ( c-addr u oid -- 0 | xt 1 | xt -1 )
  >R 2DUP ( c-addr u c-addr u )
  0 ROT ROT R@ ROT ROT R> ( c-addr u 0 oid  c-addr u oid )
  SEARCH-WORDLIST
  ?DUP
  IF ( c-addr u 0 oid xt [-]1 )
     >R HERE >R DLL-CALL, DROP 
     STATE @ 0= IF RET, THEN
     R> STATE @ IF DROP ['] NOOP THEN
     R>
  ELSE 2DROP 2DROP 0 THEN
;

PREVIOUS
>> CONSTANT DLL-WL

: ERASE-DLL-HANDLES
  VOC-LIST @
  BEGIN
    DUP
  WHILE
    DUP CELL+ DUP CLASS@ DLL-WL =
              IF 0 OVER OBJ-DATA! THEN DROP
    @
  REPEAT DROP
;

GET-CURRENT FORTH-WORDLIST SET-CURRENT
: SAVE
  ERASE-DLL-HANDLES SAVE
;
SET-CURRENT

WARNING !

( ������.
DLL NEW: libxml2.dll

S" text.xml" DROP xmlRecoverFile

: TEST
  S" text.xml" DROP xmlRecoverFile
;
)