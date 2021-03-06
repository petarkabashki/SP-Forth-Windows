( str_list.f - ���������� ������� �������, � ��������� ������� �����.
  DoList, NodeValue, AddNode, FreeList �������� � ������������
  ��������. ������ ������� ������ ������ �������� value [������]
  � ��������� �� ��������� �������. �.�. ��� �� ����������� ������.
  ������ inList �������, ��� �������� value ������ �������� 
  ������� xcount-������.
)

: XCOUNT ( addr -- addr1 u1 )
\ �������� ������ addr1 u1 �� ������ �� ��������� addr
\ ������� - �������, � �� ����, � ������� �� �������� COUNT
  DUP @ SWAP CELL+ SWAP
;
: NodeValue ( node -- value )
\ �������� �������� �������� ������
  CELL+ @
;
: NextNode ( node1 -- node2 | 0 )
  @
;
: FirstNode ( list -- node )
  @
;
: DoList ( xt list -- )
\ ��������� ����� xt ��� ������� �������� (node, � �� value) ������ list
\ xt ( node -- )
  SWAP >R FirstNode
  BEGIN
    DUP
  WHILE
    DUP NextNode SWAP R@ EXECUTE
  REPEAT R> 2DROP
;

: inList ( addr u list -- flag )
\ ���������, ��������� �� ������ addr u � ������ ����� list
  ROT ROT 2>R FirstNode
  BEGIN
    DUP
  WHILE
    DUP NodeValue XCOUNT 2R@ COMPARE 0= IF DROP 2R> 2DROP TRUE EXIT THEN
    NextNode
  REPEAT 2R> 2DROP
;
: FreeNode ( node -- )
  FREE THROW
;
: FreeList ( list -- )
\ ����������� ������������ ������, ���������� ����������� ������.
\ �� ����������� ������, ���������� ��������� ������, ���� ���
\ �������� - ������� ��������, �������� ������.
  ['] FreeNode OVER DoList 0!
;
: AddNode ( value list -- )
\ ��������� value � ������ list
  2 CELLS ALLOCATE THROW >R
  SWAP R@ CELL+ !
  DUP @ R@ !
  R> SWAP !
;
: ReverseList ( list -- )
\ ���������� ������� ��������� � ������ �� ��������
  DUP >R 0 >R RP@ >R
  FirstNode
  BEGIN
    DUP
  WHILE
    DUP NextNode SWAP DUP NodeValue R@ AddNode FreeNode
  REPEAT DROP
  RDROP R> R> !
;