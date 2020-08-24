REQUIRE CONT ~profit/lib/bac4th.f

\ ���������� nfa ���� ���� �� ������ wid
: NFA=> ( wid --> nfa )
  PRO
  @
  BEGIN
    DUP
  WHILE 
    ( nfa ) CONT ( nfa )
    CDR ( nfa2 )
  REPEAT
  DROP ;

: VOC> ( xt -- wid ) ALSO EXECUTE CONTEXT @ PREVIOUS ;

\ ���������� ������������� �������
\ ���� vocname �� ������� - ��������� �� ���������
: [WID] ( "vocname" -- wid ) ' VOC> POSTPONE LITERAL ; IMMEDIATE

\EOF

\ REQUIRE [IF] ib/include/tools.f

: search-nfa2 ( a u wid -- 0 | nfa ) 
\ ����� ��������� ������ ��� ��������� ����� � ������ wid
\ ������� ��� NFA
  START{
    CUT:
    NFA=> 
    >R 2DUP R@ -ROT ( a u nfa a u )
    R> COUNT 2DUP CR TYPE
    COMPARE 0= IF CR ." FOUND" -CUT THEN 
  }EMERGE 
  2DROP ;

: search-nfa 
  @
  BEGIN
    DUP
  WHILE 
    >R 2DUP R@ COUNT COMPARE R> SWAP
  WHILE
    CDR ( nfa2 )
  REPEAT THEN
  >R 2DROP R> ;
