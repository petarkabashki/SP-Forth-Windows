REQUIRE HEAP-COPY ~ac/lib/ns/heap-copy.f

: EVALUATE, ( addr u -- ) \ ����������� ������ � �������
TRUE STATE ! \ �������� ����������
EVALUATE \ ��������� ������-��������
RET, \ ����������� �����������
STATE 0! \ ��������� ����������
;

: EVALUATED ( addr u -- addr-xt u-xt ) \ ����������� ������ � �������
\ ����� ����� � ����� ���������������� ������ ����,
\ ���������� ������� � �������� ���������
HERE >R
EVALUATE,
HERE \ ������� �������� HERE, ����� ����������
R@ DP ! \ ��������������� HERE � ������������ ��������
R@ \ ������ �������� HERE, ����� ���
( ����� ������ )
- ( �����-������ ) \ ������������ ����� ���������������� ������������������
R> SWAP ;

: COPY-CODE ( xt dest -- ) HERE SWAP DP ! SWAP INLINE, RET, DP ! ;

: EVALUATED-HEAP ( addr u -- xt ) \ ����������� ������ � ��������� ������� � ����
EVALUATED ALLOCATE THROW TUCK COPY-CODE ;

\EOF
REQUIRE SEE lib/ext/disasm.f

: r 1 S" LITERAL SFIND RECURSE " EVALUATED-HEAP REST ; r