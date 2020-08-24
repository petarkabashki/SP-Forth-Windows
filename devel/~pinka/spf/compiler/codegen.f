\ 03.Feb.2007 ruv
\ 30.Jan.2008 -- moved from index.f

S" ALLOT" GET-CURRENT SEARCH-WORDLIST [IF] DROP [ELSE]
\ ����������, ����� ���� �������� �������������� ��� � ����� ������

: ,      , ;
: C,    C, ;
: S,    S, ;
: ALLOT ALLOT ;
: HERE  HERE  ;

: SXZ,  SXZ, ;
: SCZ,  SCZ, ;

: LIT,  LIT,  ;
: SLIT, SLIT, ;

[THEN]

: CALL, ( entry-point -- )
  COMPILE,
;

: ZBRANCH, ( addr -- )
  ?BRANCH,
;
: NZBRANCH, ( addr -- )
  ['] 0= CALL, ZBRANCH,
;

: DEFER-LIT, ( -- addr )
  -1 LIT,  \  �.�. ��� 0  ����������� �������  XOR  EAX, EAX
  HERE 3 - CELL-
;
: EXEC, ( xt -- )
  GET-COMPILER? IF EXECUTE EXIT THEN CALL,
;
\ ��� ����� ����� ������ ���� "EXEC,", <exec/> �  "CALL," <call/>
\ ��������, ����� ����������� �� ������ �������.

: EXIT, ( -- )
  RET,
;

: 2LIT, ( x x -- )
  SWAP LIT, LIT,
;


\ � spf4 ���������� ��������� "POSTPONE EXECUTE"
\ �������� �� ������� � ������ ���������� � � ������ ����������.
\ ��������� ����� �������� ����������:

: EXECUTE, ( -- )
  ['] EXECUTE EXEC,
;

\ ��� ����������� "@EXECUTE" � "PERFORM" � ���������� "@ EXECUTE"
\ �� ����, ����� ������ ����������� ��� ����� ����������.


USER GERM-A

: GERM  GERM-A @ ;
: GERM! GERM-A ! ;

S" xt.immutable.f" Included

: BFW, ( -- ) ( CS: -- a )
  0 BRANCH, >MARK >CS
;
: BFW2, ( -- ) ( CS: a1 -- a2 a1 )
  CS> BFW, >CS
;
: ZBFW, ( -- ) ( CS: -- a )
  0 ZBRANCH, >MARK >CS
;
: NZBFW, ( -- ) ( CS: -- a )
  0 NZBRANCH, >MARK >CS
;
: ZBFW2, ( -- ) ( CS: a1 -- a2 a1 )
  CS> ZBFW, >CS
;
: RFW ( -- ) ( CS: a -- )
  CS> >RESOLVE1
;

: MBW ( -- ) ( CS: -- a )
  HERE >CS
;
: BBW, ( -- ) ( CS: a -- )
  CS> BRANCH,
;
: ZBBW, ( -- ) ( CS: a -- )
  CS> ZBRANCH,
;

WARNING @ WARNING 0!

: SLIT, ( addr u -- ) \ ������ ����������� ����� � 255
  BFW,
    HERE OVER 2SWAP S, 0 C,
  RFW 2LIT,
;

WARNING !
