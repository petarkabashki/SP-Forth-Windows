\ $Id: mem2.f,v 1.4 2008/11/21 00:27:27 ruv Exp $
\ 03.Oct.2003  Ruv
\ 02.Aug.2004 ��� ��������� �� mem.f � mem2.f

( ���������� SPF4
  �������� ��������� ���� ALLOCATE FREE RESIZE
  �� ������� ����� HEAP-ID
  - ���� �� ���������� �� 0, �������� � ��� ��� � �����,
  ����� � ����� ������ THREAD-HEAP -- ������ ���������.
)

REQUIRE [UNDEFINED] lib/include/tools.f

USER-VALUE HEAP-ID

: HEAP-ID! ( heap -- ) TO HEAP-ID ;

\ 8 = HEAP_ZERO_MEMORY 
\ 1 = HEAP_NO_SERIALIZE
\ 9 = HEAP_ZERO_MEMORY HEAP_NO_SERIALIZE OR
\ ����� �������, ������������� ��� ������� �� ������ ������� � ������ ����
\  �� ������� ���������� ���������: ���� ��������� ����� ���
\  � ��������������� ������, ���� ������������ ������� ���������
\  ���������� (����������� ������, �������, � �.�.).
\ ������ � ���� �������� �������� ���������������� � ���� ��� ���������,
\  ���������� �� ����� ������������� � HeapAlloc & Co.

: ALLOCATE2 ( u -- a-addr ior ) \ 94 MEMORY
  CELL+ 9 ( HEAP_ZERO_MEMORY HEAP_NO_SERIALIZE OR )
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapAlloc
  DUP IF R@ OVER ! CELL+ 0 ELSE -300 THEN
;
: FREE2 ( a-addr -- ior ) \ 94 MEMORY
  CELL- 1 ( HEAP_NO_SERIALIZE )
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapFree ERR
;
: RESIZE2 ( a-addr1 u -- a-addr2 ior ) \ 94 MEMORY
  CELL+ SWAP CELL- 9 ( HEAP_ZERO_MEMORY HEAP_NO_SERIALIZE OR )
  HEAP-ID ?DUP 0= IF THREAD-HEAP @ THEN
  HeapReAlloc
  DUP IF CELL+ 0 ELSE -300 THEN
;

WARNING @ WARNING 0!
[UNDEFINED] ALLOCATE1 [IF] ( �������� ��������, ���� �� �� ���� )

' ALLOCATE  VECT ALLOCATE
' FREE      VECT FREE    
' RESIZE    VECT RESIZE  
( xt-orig-ALLOCATE xt-orig-FREE xt-orig-RESIZE )

[THEN]

' ALLOCATE2 TO ALLOCATE
' FREE2     TO FREE
' RESIZE2   TO RESIZE

[UNDEFINED] ALLOCATE1 [IF] ( �������� ������������ ����, ���� �� ���� ��������)
REQUIRE REPLACE-WORD lib/ext/patch.f

' RESIZE    SWAP REPLACE-WORD
' FREE      SWAP REPLACE-WORD
' ALLOCATE  SWAP REPLACE-WORD

[THEN]
WARNING !

\ ===

: HEAP-GLOBAL ( -- )
  GetProcessHeap HEAP-ID!
;
: HEAP-DEFAULT ( -- ) \ or HEAP-LOCAL  or HEAP-USER
  0 HEAP-ID!
;
