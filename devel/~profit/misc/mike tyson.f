REQUIRE NOT ~profit/lib/logic.f

MODULE: tyson

\ ��� ������ ���� �����
\ ������ � ������ �������
\ �� �� ���.. (����?)

VARIABLE r

r 0!

EXPORT

: move ( -- flag ) r @ NOT DUP r ! ;
: board ( state -- ) DROP ;

;MODULE

\ ������ ��������: "��������", ������-�����, ������-�����.