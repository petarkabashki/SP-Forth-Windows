\ ����������� ������.
\ ����� ��������� ��� ������, ��� � �������� c ��������
\ ���� ��������� ������ ��� ������, �� ��� ����������� ������ ����
\ ����� ����������

REQUIRE Object ~day\joop\oop.f
REQUIRE {      lib\ext\locals.f
 
pvar: <next
pvar: <previous
pvar: <data
pvar: <freeproc

<< :delete

CLASS: ListNode <SUPER Object

        CELL VAR next
        CELL VAR previous
        CELL VAR data
        CELL VAR freeproc \ ��������� �����������

: :free
    data @ freeproc @ EXECUTE \ ������� ������
    own :free
;

\ ������� � ����������
: :delete { \ n p -- }
    previous @ -> p
    next @ -> n
    n IF 
        p n <previous !
        p IF n p <next ! THEN
      THEN
    own :free
;

;CLASS

: mfree FREE THROW ;
: FreeNode ( node -- f)
   :free 0
;


<< :addNode
<< :addValue
<< :addObject
<< :addArray
<< :doEach

pvar: <first
pvar: <last

CLASS: List <SUPER Object


        CELL VAR first
        CELL VAR last

: :addNode { node -- }
     last @ node <previous !
     last @ IF node last @ <next ! THEN
     node last !
     first @ 0= IF node first ! THEN
;

: :addObject  { obj \ node -- }
     ListNode :new -> node
     obj node <data !
     ['] :free node <freeproc !
     node own :addNode
;

: :addValue ( u --)
     ListNode :new
     SWAP OVER <data !
     ['] DROP OVER <freeproc !
     own :addNode
;

: :addArray ( addr --)
     ListNode :new
     SWAP OVER <data !
     ['] mfree OVER <freeproc !
     own :addNode
;

\ xt ( ... node -- ... bool )
\ xt ������ ���������� -1 ����� ��������� �������� � 0 ����� ����������
\ ... - ��������� ������������

: :doEach { xt -- }
  first @
  BEGIN
    DUP
  WHILE
    DUP <next @ >R
    xt EXECUTE IF R> EXIT THEN
    R>
  REPEAT DROP
;

: :free
    ['] FreeNode own :doEach
    own :free
;

;CLASS

\ �������� ��� ������ - ����� ���� �������� �� ����� ���� callback �����
\ (����� :doEach ������ List)

pvar: <current

<< :set
<< :next
<< :first
<< :last
<< :previous
<< :re

CLASS: Iterator <SUPER Object

        CELL VAR current  
        CELL VAR collection

: :set
   DUP collection !
   <first @ current !
;
: :re
   collection @ <first @ current !
;

\ ���������� ������� ���� � ��������� �� ���������
\ f = true ���� ���� ���������
: :next ( - node f)
    current @ DUP IF DUP <next @ current ! -1 ELSE DROP 0 THEN
;                  
: :previous ( - node f)
    current @ DUP IF DUP <previous @ current ! -1 ELSE DROP 0 THEN
;
: :first collection @ <first @ current ! ;

: :last collection @ <last @ current ! ;

;CLASS

 \EOF

~ac\lib\memory\heap_enum.f

List :new VALUE tt

1 tt :addValue
2 tt :addValue
Object :new tt :addObject

\ ��� �������, ������ ����� ������ ���������� ��� � free-tt
\ ��� ����� :doEach ��� � ������ :free ������ List
: free-tt { \ it }
   Iterator :new -> it
   tt it :set
   BEGIN
     it :next IF :delete 0 ELSE -1 THEN
   UNTIL
   it :free
   tt <first 0!
   tt :free
;

\ free-tt

tt :free
