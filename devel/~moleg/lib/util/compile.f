\ 21-02-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �����, �������� ��� �� ������� � ����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ ������ �� ��, ��� � ['] name COMPILE,
\ �� ������� ����� �����������, ��� POSTPONE
: COMPILE ( --> ) ?COMP ' LIT, ['] COMPILE, COMPILE, ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{
      : sample 1234 ;
      : tst ['] sample COMPILE, ; IMMEDIATE
      : ts1 COMPILE sample ; IMMEDIATE
      : testing tst ts1 <> THROW ; testing
    S" passed" TYPE
}test
