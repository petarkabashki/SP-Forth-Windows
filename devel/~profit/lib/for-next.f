\ ���� FOR ... NEXT. ����� ������ ���� ���������� �����,
\ ������� �� ���������� �������� ��������� � ���� � ����� �������

\ ��-�� ���������� ����� I � SPF ����� �������� �������� ����������
\ ��� �� ������ I �� ���������, ���� ����� ����� R@

REQUIRE /TEST ~profit/lib/testing.f

: FOR POSTPONE >R HERE ;  IMMEDIATE

: NEXT  ?COMP
POSTPONE R> POSTPONE DUP POSTPONE 1- POSTPONE >R
POSTPONE 0= ?BRANCH,
POSTPONE RDROP
;  IMMEDIATE
DECIMAL

/TEST


REQUIRE TESTCASES ~ygrek/lib/testcase.f
REQUIRE TYPE>STR ~ygrek/lib/typestr.f


TESTCASES for next

:NONAME 10 ." [" FOR R@ . NEXT ." ]" ; TYPE>STR STR@
S" [10 9 8 7 6 5 4 3 2 1 0 ]" TEST-ARRAY

END-TESTCASES

\EOF

: r 10 FOR R@ . NEXT ;

REQUIRE SEE lib/ext/disasm.f
SEE r

r