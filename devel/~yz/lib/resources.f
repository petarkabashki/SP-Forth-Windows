MODULE: RESOURCES

0 VALUE h
0 VALUE start

: relocate ( adr xt -- ) 
\ �ਬ����� �� �ᥬ ����⠬ ��⠫��� adr ᫮�� xt
  >R
  DUP 12 + W@ ( ���������� �����) OVER 14 + W@ ( ������������ �����) +
  SWAP 16 + SWAP
  BEGIN ( adr #) DUP WHILE
    OVER CELL+ @ 0x7FFFFFFF AND start + R@ EXECUTE
  SWAP 2 CELLS + ( ����� �����) SWAP 1-
  REPEAT 2DROP
  RDROP
;

: relocate3 ( leaf --) RESOURCES-RVA @ SWAP +! ;
: relocate2 ( dir -- ) ['] relocate3 relocate ;
: relocate1 ( dir -- ) ['] relocate2 relocate ;

EXPORT

: RESOURCES: ( ->eol; -- )
  1 WORD COUNT R/O OPEN-FILE ABORT" ���� ����ᮢ �� ������" TO h
  512 ALIGN-BYTES ! ALIGN 4 ALIGN-BYTES !
  HERE DUP TO start IMAGE-BASE - RESOURCES-RVA !
  start h FILE-SIZE 2DROP h READ-FILE ABORT" �訡�� �⥭��"
  DUP ALLOT RESOURCES-SIZE ! 
  start ['] relocate1 relocate \ �������� �� �ᥬ ���ᠬ ����ᮢ RESOURCES-RVA
  h CLOSE-FILE DROP
;

;MODULE
