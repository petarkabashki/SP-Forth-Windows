MODULE: COFFRESOURCES

0 VALUE h
0 VALUE #sections
0 VALUE start

: lseek ( offset --)
  S>D h REPOSITION-FILE ABORT" �訡�� �����-�뢮��" ;
: read ( adr # --)
  h READ-FILE ABORT" �訡�� �����-�뢮��" DROP ;
: wordat ( offset -- w)
  lseek 0 >R  RP@ 2 read R> ;
: cellat ( offset -- n)
  lseek 0 >R  RP@ 4 read R> ;

: find-rsrc ( offset -- offset)
  BEGIN #sections WHILE
    DUP cellat 0x7273722E ( .rsr) = OVER CELL+ cellat 0x00000063 ( s\0\0\0) 
    = AND IF EXIT THEN \ ��諨 ᥪ��
    40 + ( ����� ��������� ᥪ樨) 
    #sections 1- TO #sections
  REPEAT 
  ABORT" � 䠩�� ��������� ᥪ�� .rsrc" ;

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

: COFFRESOURCES: ( ->eol; -- )
  1 WORD COUNT R/O OPEN-FILE ABORT" ���� ����ᮢ �� ������" TO h
  2 wordat TO #sections \ �᫮ ᥪ権 � 䠩��
  20 ( ����� ���������) 16 wordat ( ����� �ᯮ����⥫쭮�� ���������) +
  find-rsrc DUP 20 + cellat ( ��砫� ᥪ樨 � 䠩��) >R
  16 + cellat ( ����� ᥪ樨 ����ᮢ)
  HERE DUP TO start IMAGE-BASE - RESOURCES-RVA ! R> lseek
  DUP ALLOT DUP RESOURCES-SIZE ! start SWAP read
  start ['] relocate1 relocate \ �������� �� �ᥬ ���ᠬ ����ᮢ RESOURCES-RVA
  h CLOSE-FILE DROP
;

;MODULE
