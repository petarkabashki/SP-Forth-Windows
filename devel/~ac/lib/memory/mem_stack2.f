( "��������" ���������� �������.
  ���������������� ����� ALLOCATE, FREE � HEAP-COPY ��� �������
  ���������� [����� ��] ������ ���������� � ���� ������.

  �������������:

  MARK_MEM 
  ������ � �����
  FREE_MEM

  MARK_MEM ������������� "�������" � ����. 
  FREE_MEM ������� ��� ��������������� ���������� ����� ������ 
  �� ��������� �� ������� MARK_MEM. ��������� FREE_MEM ���������
  �� ������� ����������� MARK_MEM, � �.�. ���� ������� �� ����,
  �� FREE_MEM ����������� ��� ������, ���������� ������� � �������
  ����������� ���������� ��� � ������� ������������� MEM_STACK_PTR
  [��� ������ ������, ��������]

  ��� MEM_DEBUG ON ��������� ����������� ������������� ������.

)

: ALLOCATE ( u -- a-addr ior ) \ 94 MEMORY
\ ������������ u ���� ������������ ������������ ������. ��������� ������������ 
\ ������ �� ���������� ���� ���������. �������������� ���������� ����������� 
\ ������� ������ ������������.
\ ���� ������������� �������, a-addr - ����������� ����� ������ �������������� 
\ ������� � ior ����.
\ ���� �������� �� ������, a-addr �� ������������ ���������� ����� � ior - 
\ ��������� �� ���������� ��� �����-������.

\ SPF: ALLOCATE �������� ���� ������ ������ ����� �������� ������
\ ��� "��������� �����" (��������, �������� ������ ���������� �������)
\ �� ��������� ����������� ������� ���� ���������, ��������� ALLOCATE

  CELL+ 8 ( HEAP_ZERO_MEMORY) THREAD-HEAP @ HeapAlloc
  DUP IF 557 OVER ! CELL+ 0 ELSE -310 THEN
;

: FREE ( a-addr -- ior ) \ 94 MEMORY
\ ������� ����������� ������� ������������ ������, ������������ a-addr, ������� 
\ ��� ����������� �������������. a-addr ������ ������������ ������� 
\ ������������ ������, ������� ����� ���� �������� �� ALLOCATE ��� RESIZE.
\ ��������� ������������ ������ �� ���������� ������ ���������.
\ ���� �������� �������, ior ����. ���� �������� �� ������, ior - ��������� �� 
\ ���������� ��� �����-������.
  CELL- DUP @ 557 <> IF ." �������� ���" DROP 302 EXIT THEN
  DUP 0!
  0 THREAD-HEAP @ HeapFree ERR
;
: RESIZE ( a-addr1 u -- a-addr2 ior ) \ 94 MEMORY
\ �������� ������������� ������������ ������������ ������, ������������� � 
\ ������ a-addr1, ����� ��������������� �� ALLOCATE ��� RESIZE, �� u ����.
\ u ����� ���� ������ ��� ������, ��� ������� ������ �������.
\ ��������� ������������ ������ �� ���������� ������ ���������.
\ ���� �������� �������, a-addr2 - ����������� ����� ������ u ���� 
\ �������������� ������ � ior ����. a-addr2 �����, �� �� ������, ���� ��� �� 
\ �����, ��� � a-addr1. ���� ��� �����������, ��������, ������������ � ������� 
\ a-addr1, ���������� � a-addr2 � ���������� ������������ �� �������� ���� 
\ ���� ��������. ���� ��� ���������, ��������, ������������ � �������, 
\ ����������� �� ������������ �� u ��� ��������������� �������. ���� a-addr2 �� 
\ ��� ��, ��� � a-addr1, ������� ������ �� a-addr1 ������������ ������� 
\ �������� �������� FREE.
\ ���� �������� �� ������, a-addr2 ����� a-addr1, ������� ������ a-addr1 �� 
\ ����������, � ior - ��������� �� ���������� ��� �����-������.
  CELL+ SWAP CELL- DUP @ 557 <> IF ." �������� ���" DROP 303 EXIT THEN
  DUP 0!
  8 ( HEAP_ZERO_MEMORY) THREAD-HEAP @ HeapReAlloc
  DUP IF 557 OVER ! CELL+ 0 ELSE -320 THEN
;

USER MEM_STACK_PTR
VARIABLE MEM_DEBUG

: STACK_MEM ( addr -- )
  2 CELLS ALLOCATE THROW >R
  ( addr ) R@ CELL+ !
  MEM_STACK_PTR @ R@ !
  R> MEM_STACK_PTR !
;
: ALLOCATE ( size -- addr ior )
  ALLOCATE DUP IF EXIT THEN
  OVER STACK_MEM
  MEM_DEBUG @
  IF
   ." <m"  OVER .
   ." (" R@ WordByAddr TYPE ." ):"
  THEN
;
: MS_FREE 
  MEM_DEBUG @
  IF
   ." :(" R@ WordByAddr TYPE ." )"
   SPACE DUP . ." M!>" CR
  THEN
  FREE
;

: FREE ( addr -- ior )
  MEM_DEBUG @
  IF
   ." :(" R@ WordByAddr TYPE ." <-" R> R@ WordByAddr TYPE >R ." )"
   SPACE DUP . ." m>" CR
  THEN
  >R
  MEM_STACK_PTR
  BEGIN
    DUP @ \ ���������� ����� ����� �� ����� ��������, � ��������� �� �����
  WHILE
    DUP @ CELL+ @ R@ =
    IF R> FREE >R
       DUP @ DUP >R @ SWAP ! \ ��������� �� ������ ������� ����.��������
       R> FREE THROW
       R> EXIT
    THEN
    @
  REPEAT DROP RDROP
  301 \ �������, ������� ������ ����������, �� ��� �������
;
: RESIZE ( a-addr1 u -- a-addr2 ior ) \ 94 MEMORY
  MEM_DEBUG @
  IF
   ." :RS(" R@ WordByAddr TYPE ." )"
   SPACE OVER . ." m>" CR
  THEN
  >R >R
  MEM_STACK_PTR
  BEGIN
    DUP @ \ ���������� ����� ����� �� ����� ��������, � ��������� �� �����
  WHILE
    DUP @ CELL+ @ R@ =
    IF R> R> RESIZE 2>R
       DUP @ DUP >R @ SWAP ! \ ��������� �� ������ ������� ����.��������
       R> MS_FREE THROW
       2R> OVER STACK_MEM EXIT
    THEN
    @
  REPEAT DROP R> RDROP
  301 \ �������, ������� ������ ����������, �� ��� �������
;
: HEAP-COPY ( addr u -- addr1 ) \ ���������� ������, �.�. ����� ��������������
\ ����������� ������ � ��� � ������� � ����� � ����
  DUP 0< IF 8 THROW THEN
  DUP 1+ ALLOCATE THROW DUP >R
  SWAP DUP >R MOVE
  0 R> R@ + C! R>
;
: MARK_MEM ( -- )
  73 STACK_MEM
;
: FREE_MEM ( -- )
  MEM_STACK_PTR @
  BEGIN
    DUP
  WHILE
    DUP CELL+ @ 73 = \ �������� �������?
    IF DUP @ MEM_STACK_PTR ! MS_FREE THROW EXIT THEN
    \ �� �������� - ����������� ������� � ����������
    DUP CELL+ @ MS_FREE THROW
    DUP @ SWAP MS_FREE THROW
  REPEAT \ ���������� ���� ������, �� �� ����� �������!
  MEM_STACK_PTR !
;

\ TRUE MEM_DEBUG !
