\ �. �������, http://www.forth.org.ru/~yz
\ ����㦠��� ⠡���� ����⠭� 1.04

\ LOAD-CONSTANT   ��ࠢ���� ��堨��� ���ᨬ���

REQUIRE LOAD-NAMETABLE ~yz/lib/nametable.f

MODULE: WINCONS

VARIABLE wincons-chain   wincons-chain 0!

EXPORT

: FIND-CONSTANT ( name-a name-n -- n T / F)
  2DUP UPPERCASE
  wincons-chain @ -ROT SEARCH-NAMETABLE-CHAIN
  DUP IF @ TRUE THEN ;

: FIND-CONSTANT2 ( name-a name-n -- n)
  FIND-CONSTANT 0= ABORT" ����⠭� �� �������" ;

: W: ( ->bl)  BL PARSE FIND-CONSTANT2
  STATE @ IF [COMPILE] LITERAL THEN ; IMMEDIATE

: (* \ ������ ��������� �� ����� ��ப�
  0
  BEGIN
    BL PARSE 2DUP S" *)" COMPARE
  WHILE
    FIND-CONSTANT2 OR
  REPEAT 2DROP
  STATE @ IF [COMPILE] LITERAL THEN ; IMMEDIATE

  : LOAD-CONSTANTS ( file-a file-n -- )
  >R HERE R@ CMOVE  HERE R> 2DUP + 0! +LibraryDirName
  LOAD-NAMETABLE wincons-chain STITCH-NAMETABLE-CHAIN ;

: REMOVE-ALL-CONSTANTS
  wincons-chain @ REMOVE-NAMETABLE-CHAIN
  wincons-chain 0! ;

\ -------------------------------------

;MODULE
