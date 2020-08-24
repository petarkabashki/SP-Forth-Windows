\ http://fforum.winglion.ru//viewtopic.php?t=465
\ ������� ���-�� ����� � ����, �������� bac4th'��

REQUIRE +{ ~profit/lib/bac4th.f
REQUIRE iterateBy ~profit/lib/bac4th-iterators.f
REQUIRE arr{ ~profit/lib/bac4th-sequence.f
REQUIRE time-reset ~af/lib/elapse.f
REQUIRE GENRAND ~ygrek/lib/neilbawd/mersenne.f
REQUIRE memoize: ~ygrek/lib/fun/memoize.f
REQUIRE CODE lib/ext/spf-asm-tmp.f

GetTickCount SGENRAND \ �������� �������

: countBitsInBytes ( byte -- un ) \ ~af
0      OVER     1 AND IF 1+ THEN
       OVER     2 AND IF 1+ THEN
       OVER     4 AND IF 1+ THEN
       OVER     8 AND IF 1+ THEN
       OVER    16 AND IF 1+ THEN
       OVER    32 AND IF 1+ THEN
       OVER    64 AND IF 1+ THEN
       SWAP   128 AND IF 1+ THEN ;

: countBitsInCell ( cell -- un ) \ ~mak
   DUP 0x55555555 AND SWAP 0xAAAAAAAA AND 1 RSHIFT + 
   DUP 0x33333333 AND SWAP 0xCCCCCCCC AND 2 RSHIFT + 
   DUP 0x0F0F0F0F AND SWAP 0xF0F0F0F0 AND 4 RSHIFT + 
   DUP 0x00FF00FF AND SWAP 0xFF00FF00 AND 8 RSHIFT + 
   DUP 0x0000FFFF AND SWAP 0xFFFF0000 AND 16 RSHIFT + ;

: BITS-WORD ( w -- un ) \ chess
DUP 0x5555 AND SWAP 0xAAAA AND 1 RSHIFT + 
DUP 0x3333 AND SWAP 0xCCCC AND 2 RSHIFT + 
DUP 0x0F0F AND SWAP 0xF0F0 AND 4 RSHIFT + 
DUP 0x00FF AND SWAP 0xFF00 AND 8 RSHIFT + ;

CODE ?bits ( cell -- un )  \ mOleg
           XOR EBX, EBX 
      @@1: OR EAX, EAX 
           JZ @@2
           MOV EDX, EAX 
           AND EDX, # 1 
           ADD EBX, EDX 
           SHR EAX, # 1 
           JMP @@1
      @@2: MOV EAX, EBX 
           RET
END-CODE

: bc ( n � c ) \ forther
    -1 0 DO
        DUP 0= IF DROP I LEAVE THEN 
        DUP 1- AND 
    LOOP ;

\ ----- Testing ------ 
    1024 CONSTANT KB 
 KB KB * CONSTANT MB 

10 MB * CONSTANT BytesInArray \ 10 ��, ���� ������ -- ������� ������

\ ��������� ��������� ������� 
USER Array
BytesInArray ALLOCATE THROW Array !

: arr Array @ BytesInArray ;

: fillArray arr  1 iterateBy  256 GENRANDMAX OVER C! ;
fillArray
.( Array allocated and filled) CR

\ ���������� ������� ���������� ����� �����
: af     ( addr u -- un ) +{    1 iterateBy DUP C@ countBitsInBytes }+ ;

\ ��������� ������� ���������� ����� �����
: chess  ( addr u -- un ) +{    2 iterateBy DUP W@ BITS-WORD        }+ ;

\ ������� ���������� ����� ����� �� ������� (������� ������� �� �����)
: mak    ( addr u -- un ) +{ CELL iterateBy DUP @  countBitsInCell  }+ ;

\ ������� ���������� ����� ����� �� ������� (������� ����� �� ����������)
: mOleg  ( addr u -- un ) +{ CELL iterateBy DUP @  ?bits            }+ ;

: forther ( addr u -- un ) +{ CELL iterateBy DUP @  bc            }+ ;

\ ����� ����� � �������������� �������������� ������� ���� �������� �����������
: af-arr ( addr u -- un ) LOCAL f
arr{ 0 256 1 iterateBy DUP countBitsInBytes DROPB }arr \ ���������� ������ ����������� ��� ���� �������� ��������
DROP
" CELLS LITERAL + @ " STRcompiledCode  f ! \ ���������� ������� ������� � ������� ���������� �����������
+{    1 iterateBy DUP C@ f @ ENTER }+ ; \ ���� ����������, ����������

\ ����� ����� � �������������� �������������� ������� ���� ����������� �����������
: chess-arr ( addr u -- un ) LOCAL f
arr{ 0 256 DUP * 1 iterateBy DUP BITS-WORD DROPB }arr \ ���������� ������ ����������� ��� ���� ����������� ��������
DROP
time-reset \ ��������� ������� � 64 �������� ����� ����� ������ ��������� �����, ������� ������� ��� �� �������
\ � ����� ��������� ��������� �������������� ������� �������, ������ ���� ��������..
" CELLS LITERAL + @ " STRcompiledCode  f ! \ ���������� ������� ������� � ������� ���������� �����������
+{    2 iterateBy DUP W@ f @ ENTER }+ ; \ ���� ����������, ����������

CR CR
.(         -={ Let Mortal Kombat begin!! }=-) CR

time-reset .( af:        ) arr af        . .elapsed CR
time-reset .( chess:     ) arr chess     . .elapsed CR
time-reset .( mak:       ) arr mak       . .elapsed CR
time-reset .( mOleg:     ) arr mOleg     . .elapsed CR
time-reset .( forther:   ) arr forther   . .elapsed CR
time-reset .( af-arr:    ) arr af-arr    . .elapsed CR
time-reset .( chess-arr: ) arr chess-arr . .elapsed CR

WARNING @ WARNING 0!
memoize: countBitsInBytes \ ��������������� ������� �� �����
: af-mmz ( addr u -- un ) +{    1 iterateBy DUP C@ countBitsInBytes }+ ;
time-reset .( af-mmz:    ) arr af-mmz    . .elapsed CR
WARNING !

\ memoize: countBitsInBytes
\ memoize: BITS-WORD
\ \ memoize: countBitsInCell \ ��, ����� ������ ����� �� ���������...

\ memoize ��� ������ �������� ����... ������, �� ���� ��� ���� �������
\ ������������ ������ � "�������" ���������� �� ����������� � �����
\ �� �� ���� �������� ������ �������, ������ "����������", �������,
\ ���������� �������.