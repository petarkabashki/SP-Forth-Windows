\ ������� ����
\ �. �������, http://www.forth.org.ru/~yz, 8.04.2003

\ ��ଠ� 䠩�� ⠡���� (�� ᬥ饭�� �� ��砫� 䠩��):

\ ���������
\ --------------------
\  +0 ������� 䠩��
\  +4 㪠��⥫� �� ���. ����� (�᫨ ����)
\  +4 �᫮ ����⠭� N
\ N*4 ���� ����⠭� � ��䠢�⭮� ���浪�

\ ���祭�� ����⠭�...
\ --------------------
\ 4  ���祭�� ����⠭��
\ 1  ����� ��ப� s. ���� �����뢠�� �.
\ s  ��ப�

\ �������⥫�� ����� 
\ ---------------------
\ ����ঠ��� ������ �� �����⭮�� ⨯� ⠡����. 
\ ����� ������⢮����.

MODULE: NAMETABLE

0 VALUE h
CREATE source 2 CELLS ALLOT
0 VALUE offsettable

: swhere[] ( i -- astr)
  CELLS offsettable + @ offsettable + 3 CELLS - ;

: compare ( i -- ?)
  swhere[] CELL+ COUNT  \ 2DUP ." i=" TYPE
  source 2@  ( 2DUP ."  key=" TYPE) 2SWAP COMPARE  ( ." :" DUP . CR) ;

: binsearch ( lo hi -- a/0)
  ( 2DUP SWAP ." lo=". ." hi=" . CR)
  2DUP = IF
    DROP ( lo) DUP compare 0=
    IF swhere[] ELSE DROP 0 THEN
    EXIT
  THEN
  ( lo hi)
  2DUP + 2/ ( lo hi middle)
  DUP compare DUP 0= IF ( lo hi middle ?) DROP NIP NIP swhere[] EXIT THEN
  0< IF NIP ELSE ROT DROP 1+ SWAP THEN RECURSE ;

EXPORT

0 VALUE THIS-NAMETABLE

: LOAD-NAMETABLE ( �-namefile n-namefile -- content )
  R/O OPEN-FILE ABORT" ���� �� ������" TO h
  h FILE-SIZE THROW DROP DUP ALLOCATE THROW
  ( # a) SWAP >R DUP R> h READ-FILE THROW DROP
  h CLOSE-FILE THROW ;

: REMOVE-NAMETABLE-CHAIN ( chain -- )
  BEGIN ?DUP WHILE
    ( a) DUP @ SWAP FREE THROW
  REPEAT ;

: STITCH-NAMETABLE-CHAIN ( nt var -- )
  DUP >R @ ( adr last) OVER ! R> ! ;

: SEARCH-NAMETABLE-CHAIN ( chain a-word n-word -- a/0)
  source 2!
  BEGIN ?DUP WHILE
    ( a) DUP TO THIS-NAMETABLE DUP @ SWAP
    2 CELLS + DUP CELL+ TO offsettable
    @ 1- 0 SWAP binsearch
    ?DUP IF NIP EXIT THEN
  REPEAT
  0 ;

WINAPI: CharUpperBuffA USER32.DLL

: UPPERCASE ( as ns -- ) SWAP CharUpperBuffA DROP ;

;MODULE
