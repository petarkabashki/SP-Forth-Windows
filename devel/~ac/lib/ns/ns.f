\ DLL/SO - �������

REQUIRE HEAP-COPY ~ac/lib/ns/heap-copy.f
REQUIRE DLOPEN    ~ac/lib/ns/dlopen.f
REQUIRE NOTFOUND  ~ac/lib/ns/notfound.f

: OBJ-DATA@ ( oid -- data )
\ ������ ������� (instance).
\ ��� ����-�������� ���������� ��������� �� ��� ���������� ����� � ������ (�����),
\ ��� dll - ����� �� LoadLibrary
  @
;
: OBJ-DATA! ( data oid -- )
  !
;
: OBJ-NAME@ ( oid -- addr-u )
\ "������" ��� �������, ����������� VOCABULARY (� ������ namespaces ����� ����
\ ��� ������ ������.)
  CELL+ @ ?DUP IF COUNT ELSE S" FORTH" THEN
;
: HEAP-COPY-C ( addr u -- addr1 )
\ ����������� ������ � ��� � ������� � ����� � ����
  DUP 0< IF 8 THROW THEN
  DUP 2+ ALLOCATE THROW DUP >R 1+
  SWAP DUP >R MOVE
  R> 0 OVER R@ + 1+ C! 
  R@ C!
  R>
;
: OBJ-NAME! ( addr u oid -- )
  >R HEAP-COPY-C R> CELL+ !
;
: CLASS.
  CLASS@ ?DUP IF VOC-NAME. ELSE ." FORTH" THEN
;

' SEARCH-WORDLIST BEHAVIOR  CONSTANT SWL_PREVNS

: SEARCH-WORDLIST-R ( c-addr u oid -- 0 | xt 1 | xt -1 )
\ ������ � ������� ������� � � ��������-�������, ��� � ������ ��-94.
\ �� �������������� ����� ������ ��� "���������" ������� - INVOKE,
\ �� ����������� � ������� �������.

  DUP >R FORTH-WORDLIST = >R 2DUP S" SEARCH-WORDLIST" COMPARE 0= R> AND
  IF 2DROP RDROP SWL_PREVNS -1 EXIT THEN \ ����� �������� �������� �� ������ SEARCH-WORDLIST ����� SEARCH-WORDLIST :)
  R>

  >R 2DUP R@ SWL_PREVNS EXECUTE ?DUP IF 2SWAP 2DROP RDROP EXIT THEN
  R> DUP FORTH-WORDLIST = IF DROP 2DROP 0 EXIT THEN \ ���� ������ ������
  CLASS@ DUP 0= IF DROP FORTH-WORDLIST THEN RECURSE \ ���� ���� �� ����� ������������
;

: INVOKE ( ... oid addr u -- ... )
\ ��������� ����� � ������ addr u ��� ������� oid
  ROT ( addr u oid )
  DUP 0= ABORT" Invalid INVOKE call"
  CLASS@ DUP 0= IF DROP FORTH-WORDLIST THEN ( addr u class-oid )
  SEARCH-WORDLIST-R
  IF EXECUTE ELSE -3004 THROW THEN
;
: .. ( -- )
  CONTEXT @ PAR@ ?DUP IF CONTEXT ! THEN
;

: SEARCH-WORDLIST-V ( c-addr u wid -- 0 | xt 1 | xt -1 ) \ 94 SEARCH
\ ����� �����������, �������� ������� c-addr u � ������ ����, ���������������� 
\ wid. ���� ����������� �� �������, ������� ����.
\ ���� ����������� �������, ������� ���������� ����� xt � ������� (1), ���� 
\ ����������� ������������ ����������, ����� ����� ������� (-1).
  DUP CLASS@ DUP 0= SWAP FORTH-WORDLIST = OR
  IF SWL_PREVNS EXECUTE
  ELSE DUP S" SEARCH-WORDLIST" INVOKE THEN
;
' SEARCH-WORDLIST-V TO SEARCH-WORDLIST

: SHEADER-V ( addr u -- )
\ ������� ��������� ������ ����������� ��������, ��������� ��
\ �������� ������� ����������.
  GET-CURRENT CLASS@ DUP 0= SWAP FORTH-WORDLIST = OR
  IF [ ' SHEADER BEHAVIOR COMPILE, ]
  ELSE GET-CURRENT S" SHEADER" INVOKE THEN
;
' SHEADER-V TO SHEADER

USER _PAS-EXEC \ ��� ��������� ���������� �������� ;)
: PAS-EXEC ( ... n dll-xt -- x )
\ n - ����� ���������� �� ����� ��� dll-�������
\ ��������� ������� ����������.
  _PAS-EXEC !
  ?DUP IF N>R RDROP THEN
  0 _PAS-EXEC @ EXECUTE
;
USER _C-EXEC
: C-EXEC ( ... n dll-xt -- x )
\ n - ����� ���������� �� ����� ��� dll/so-�������
\ ��������� ������� ����������.
  _PAS-EXEC ! DUP _C-EXEC !
  ?DUP IF N>R RDROP THEN
  _C-EXEC @ 0 _PAS-EXEC @ EXECUTE
  SWAP BEGIN DUP WHILE RDROP 1- REPEAT DROP
;
\ ���� �� ����� ������ ����� ������� � ���������,
\ �� ����� ���������� ����� ��������� ���������.

: SPAS-EXEC ( dll-xt ... -- x )
  DEPTH 1- N>R RDROP 0 SWAP EXECUTE
;
: SC-EXEC ( dll-xt ... -- x )
  DEPTH 1- _C-EXEC !
  DEPTH 1- N>R RDROP _C-EXEC @ 0 ROT EXECUTE
  SWAP BEGIN DUP WHILE RDROP 1- REPEAT DROP
;

: VOC-CLONE
  TEMP-WORDLIST >R
  CONTEXT @ CELL- R@ CELL- WL_SIZE MOVE
  ALSO R> CONTEXT !
;
: NEW:
\ ������� ����� ���������� �������, class �������� ����� ����� 
\ �������� ������������ �������. �.�. ������� ������ - ���������
\ �������� ������.
\ � ���������� ��� ����������� �������� (������ �������-������).
  >IN @ VOCABULARY >IN !
  CONTEXT @ ( ALSO) ' EXECUTE CONTEXT @ CLASS!
;
\ NEW: KERNEL32.DLL ������������� ������ ����:
\ VOCABULARY KERNEL32.DLL
\ ( ALSO) KERNEL32.DLL
\ CONTEXT @ CLASS!

: NEW
\ ������� ����� ������������ �������, class �������� ����� ����� 
\ �������� ������������ �������. �.�. ������� ������ - ���������
\ �������� ������.
\ � ���������� ��� ����������� �������� (������ �������-������).
  CONTEXT @ WORDLIST DUP CONTEXT ! CLASS!
;

: new
\ ������� ����� ������������ ��������� �������, class �������� ����� ����� 
\ �������� ������������ �������. �.�. ������� ������ - ���������
\ �������� ������.
\ � ���������� ��� ����������� �������� (������ �������-������).
  CONTEXT @ TEMP-WORDLIST DUP CONTEXT ! CLASS!
;
: new:
\ ������� ����� ���������� ��������� �������, class �������� ����� ����� 
\ �������� ������������ �������. �.�. ������� ������ - ���������
\ �������� ������.
\ � ���������� ��� ����������� �������� (������ �������-������).
  CONTEXT @ TEMP-WORDLIST DUP CONTEXT ! CLASS!
  NextWord CONTEXT @ OBJ-NAME!
;
: VOC: ( name-a name-u class-xt "word-name" -- )
\ ������� ���������� ������� � ������ "word-name" � ������� �������.
\ ���������� ��� ����� ������ "class-xt EXECUTE", � "����������" ��� name
\ �������� �� ������.
\ ��������: S" http://forth.org.ru/rss.xml" ' XML_DOC VOC: FORTH_NEWS

  >IN @ VOCABULARY >IN ! ALSO ' EXECUTE
  ALSO EXECUTE CONTEXT @ PREVIOUS CONTEXT @ CLASS! 
  CONTEXT @ OBJ-NAME!
  PREVIOUS
;
: TEMP-VOCABULARY ( "<spaces>name" -- )
\ ������� ��������� ������ ���� � ������ name. ���������� name ������� ������ 
\ ������ � ������� ������ �� ������ � ������ name.
  TEMP-WORDLIST DUP
  CREATE
  ,
  LATEST OVER CELL+ ! ( ������ �� ��� ������� )
  GET-CURRENT SWAP PAR! ( �������-������ )
\  FORTH-WORDLIST SWAP CLASS! ( ����� )
  VOC
  DOES> @ CONTEXT !
;
: voc: ( name-a name-u class-xt "word-name" -- )
\ ������� ��������� ������� � ������ "word-name" � ������� �������.
\ ���������� ��� ����� ������ "class-xt EXECUTE", � "����������" ��� name
\ �������� �� ������.
\ ��������: S" http://forth.org.ru/rss.xml" ' XML_DOC voc: FORTH_NEWS

  >IN @ TEMP-VOCABULARY >IN ! ALSO ' EXECUTE
  ALSO EXECUTE CONTEXT @ PREVIOUS CONTEXT @ CLASS! 
  CONTEXT @ OBJ-NAME!
  PREVIOUS
;
\ "�������" ��� ��������� ������
: << ( "name" -- cwid )
  GET-CURRENT ALSO ' EXECUTE new DEFINITIONS
;
: <<: ( "class-name" "obj-name" -- cwid )
  GET-CURRENT ALSO ' EXECUTE NEW: DEFINITIONS
;
: >> ( cwid -- wid ) SET-CURRENT CONTEXT @ PREVIOUS ;
: :>> ( cwid -- ) SET-CURRENT PREVIOUS ;

VECT vDLOPEN ' DLOPEN TO vDLOPEN

<<: FORTH DL

: ?VOC DROP FALSE ;
: CAR ( wid -- item )
  ." DL exports enumeration isn't supported now." CR
  DROP 0
;
: SHEADER ( addr u -- )
  ." Can't insert " TYPE ."  into " GET-CURRENT VOC-NAME. ."  DL ;)" CR 5 THROW
;
: HEAP-COPY-U
  DUP >R HEAP-COPY R>
;
: SEARCH-WORDLIST ( c-addr u oid -- 0 | xt 1 | xt -1 )
  DUP OBJ-DATA@ ?DUP
  IF NIP ROT ROT HEAP-COPY-U OVER >R ROT DLSYM R> FREE THROW
     DUP IF 1 THEN
  ELSE
     DUP OBJ-NAME@ HEAP-COPY-U OVER >R vDLOPEN R> FREE THROW
     ?DUP IF ( addr u oid h ) OVER OBJ-DATA! RECURSE
          ELSE DROP 2DROP 0 THEN \ �� ������� ��������� DLL/SO
  THEN
;
:>>

\EOF �������:

: NOTFOUND \ ������ ��� ���������� asciiz ��������� "zzz" = S" zzz" DROP
  OVER C@ [CHAR] " = 
  IF NIP >IN @ SWAP - 0 MAX >IN !
     POSTPONE S" STATE @ IF POSTPONE DROP ELSE DROP THEN
  ELSE NOTFOUND THEN
;

ALSO \ ����� ���� ������� :-]
(
\ ===========================
DL NEW: KERNEL32.DLL

0 ' GetTickCount PAS-EXEC . CR
0 ' GetCurrentProcessId PAS-EXEC . CR
1000 PAD S" OS" DROP 3 ' GetEnvironmentVariableA PAS-EXEC PAD SWAP TYPE CR
' GetEnvironmentVariableA 1000 PAD "OS" SPAS-EXEC PAD SWAP TYPE CR

\ ===========================
DL NEW: USER32.DLL

0 ' GetDesktopWindow PAS-EXEC . CR

\ ===========================
DL NEW: libcrypt.dll

"zz" "pass" 2 ' crypt C-EXEC ASCIIZ> TYPE CR
' crypt "zz" "pass" SC-EXEC ASCIIZ> TYPE CR

\ ===========================
KERNEL32.DLL ' GetEnvironmentVariableA 
1000 PAD "USERNAME" SPAS-EXEC PAD SWAP TYPE CR

' GetCurrentThreadId SPAS-EXEC . CR
ORDER

\ ===========================
DL NEW: libcurl.dll
VARIABLE CURLH
CREATE URL S" http://xmlsearch.yandex.ru/xmlsearch?query=sp-forth" HERE SWAP DUP ALLOT MOVE 0 C,
\ curl �� �������� ������ ����
)
\ 0 ' curl_easy_init C-EXEC DUP . CURLH !
\ URL 10002 ( CURLOPT_URL) CURLH @ 3 ' curl_easy_setopt C-EXEC .
\ CURLH @ 1 ' curl_easy_perform C-EXEC .

DL NEW:  sqlite3.dll
VARIABLE SQH
PAD "D:\Program Files\SQLiteSpy_1.1\world.db3" 2 ' sqlite3_open C-EXEC . PAD @ SQH !
