\ ��������

\ ������� ���������� TranslateWord ( �.�. 12.01.2001 )

( �� �������� � ������� ������������ �� SPF/3.7x ����� �������, 
  ��� ��� �� ���� 'evaluator' ����� ������ �� ����� � ����������,
  ��� ���������� ��� "����������� ����������" _�����������_ ����.
  ���������� ����� ������ ��������� ������ ��������� �����, ��
  ����� �� ��� ���� IMMEDIATE � �� ����� �� ���������� STATE.
  STATE � ���� IMMEDIATE ����� ������ �� _�����_ ����� [��������,
  �� �������� ������], � �� �� ������ ��������� ����������� ���
  ������ xt. � �� SPF/3.7x � ��������� ���������� ������������
  ������ ������ �������� [� ������ �������� ����������� ��� ���],
  STATE �� ��������...
)

: NAME>XT ( nfa -- x xt )
  DUP NAME> SWAP 
  ?IMMEDIATE 0= STATE @ AND 
  IF ['] COMPILE, ELSE ['] EXECUTE THEN
;
: SearchInWordlist ( addr u wid -- x xt flag )
  ROT ROT 2>R
  @
  BEGIN
    DUP
  WHILE
    DUP COUNT 2R@ COMPARE 0= 
        IF NAME>XT TRUE 2R> 2DROP EXIT THEN
    CDR
  REPEAT 2R> 2DROP FALSE
;
: SearchWord ( addr u -- x xt )
  SP@ >R 2>R
  GET-ORDER
  BEGIN
    DUP
  WHILE
    SWAP 2R@ ROT SearchInWordlist
    IF 2R> 2DROP R> ROT ROT 2>R SP! 2DROP 2R> EXIT THEN
    1-
  REPEAT -2 THROW
;
: ExecuteToken EXECUTE ;

: TranslateWord ( addr u -- | ... ) \ throwable
  SearchWord ExecuteToken
;
