\ ����������� FOR .. NEXT � DO .. LOOP , �� ���������� ���� ���������

REQUIRE >L ~profit/lib/lstack.f

: REF@ @ ; \ REF -- ����. ��� ��� ������ ��������, ��. ������ ���������
: REF! ! ;
: REF+ CELL+ ;

: >MARK ( -- dest ) 	HERE 0 , ;
: >RESOLVE ( dest -- )	HERE SWAP REF! ;

: <MARK ( -- org )	HERE ;
: <RESOLVE ( org -- )	, ;


: (DO) ( b a -- ) \ �� � �� b
   SWAP >L >L ; \ �������� �� L-���� ������ � ������� ��������

: (LOOP) L> 1+  L>
2DUP = IF  2DROP R> REF+ ELSE \ ���� �����, ������ ������
  >L >L   R> REF@ THEN  >R ; \ ���� ���, ������� �� ������

: DO  POSTPONE (DO) <MARK ; IMMEDIATE
: LOOP POSTPONE (LOOP) <RESOLVE ; IMMEDIATE
:  I L@ ;

: FOR POSTPONE >L <MARK ;  IMMEDIATE
: (NEXT) L> 1-
?DUP IF >L R> REF@ ELSE R> REF+ THEN  >R ;
: NEXT POSTPONE (NEXT) <RESOLVE ;  IMMEDIATE