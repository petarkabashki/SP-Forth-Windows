REQUIRE /TEST ~profit/lib/testing.f
\ ������������ ����������, ������� � ���������

: INTERPRET_ONE_ROW ( -> )
HERE
] INTERPRET_
RET, EXECUTE ;

' INTERPRET_ONE_ROW  &INTERPRET !

/TEST

." 1-10: "
10 0 DO I . LOOP