\ ������ � �������
\ �. �������, 2002

REQUIRE ZMOVE ~yz/lib/common.f

USER ptr
: init->> ( a -- )
  ptr ! ;
: push->> ( -- n)
  ptr @ ;
: pop->> ( n -- )
  ptr ! ;
: >> ( n -- )
  ptr @ !  CELL ptr +! ;
: W>> ( w -- )
  ptr @ W!  2 ptr +! ;
: C>> ( c -- )
  ptr @ C!  ptr 1+! ;
: 0>> ( -- ) 0 C>> ;
: 2>> ( d -- )
  ptr @ 2!  2 CELLS ptr +! ;
: N>> ( adr n -- )
  >R ptr @ R@ CMOVE R> ptr +! ;
: Z>> ( z -- )
  DUP ptr @ ZMOVE ZLEN 1+ ptr +! ;
\ ���������� ������, �� ��� ������������ ����
: z>> ( z -- )
  DUP ptr @ ZMOVE ZLEN ptr +! ;
: zeroes>> ( n -- ) 0 ?DO 0 >> LOOP ;
: S>> ( a u -- )
  >R ptr @ R@ CMOVE R> ptr +!
;


: (DATA) ( -- a)
  R> DUP DUP @ + >R CELL+ ;
: DATA[ ( -- a)
  ?COMP POSTPONE (DATA)
  HERE 0 , ( ����� ������) [COMPILE] [ ; IMMEDIATE
: ]DATA ( a -- )
  DUP HERE SWAP - SWAP ! ] ; IMMEDIATE


USER ((-stack-begin

: (( ( -- ) SP@ ((-stack-begin ! ;
: )) ( ... -- end begin ) SP@ ((-stack-begin @ CELL- ;
: remove-stack-block  ((-stack-begin @ SP! ;
