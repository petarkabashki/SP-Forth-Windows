\ 18-12-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������������� ���������� � ����� ��
\ � ������������ ������������ �����������

 REQUIRE ROOT      devel\~moleg\lib\util\root.f
 REQUIRE sFindIn   devel\~moleg\lib\newfind\search.f
 REQUIRE CS>       devel\~moleg\lib\util\csp.f
 REQUIRE ALIAS     devel\~moleg\lib\util\alias.f

 ?DEFINED IS   ALIAS TO IS

ALSO ROOT DEFINITIONS

   VECT \* IMMEDIATE
   VECT *\ IMMEDIATE

RECENT

\ ������ ����� � ������� ROOT, ���� �������, ������� ��� wid
\ ��������� ����� ������ ���� immediate
: qfnd ( --> wid | 0 )
       SP@ >R
       NEXT-WORD [ ALSO ROOT CONTEXT @ PREVIOUS ] LITERAL 1 sFindIn
       imm_word = IFNOT R> SP! FALSE ELSE RDROP THEN ;

\ ���������� ��� ����� �� ������� ������
\ ������ �� ������ �� ���� ��������� 'a 'b
: skipto'' ( 'a 'b / .... a|b --> ' )
           2>R BEGIN 2R@ qfnd TUCK = WHILENOT \ ?a
                                   = WHILENOT \ ?b
                 REPEAT RDROP R> EXIT
               THEN 2DROP R> RDROP ;

\ ���������� ���� ����� �� ������������ ����� *\
\ ������ ����� *\ ����������
: _\* ( / ... *\ --> )
      ['] \* >CS
      ['] \* ['] *\ skipto'' EXECUTE ;

\ ���������� �������������� ����������
: _*\ ( --> )
      CS@ ['] \* =
      IF CSDrop
         CS@ ['] \* = IF ['] \* ['] *\ skipto'' EXECUTE THEN
       ELSE -1 THROW
      THEN ;

 ' _\* IS \*
 ' _*\ IS *\

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------
test{
 \* ����� ������� \* ���� *\ ����������������� *\
  S" passed" TYPE
}test
