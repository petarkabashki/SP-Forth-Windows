\ 21-01-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ����� ����� � ��������� ������ ��������

 REQUIRE WHILENOT devel\~moleg\lib\util\control.f
 REQUIRE FRAME    devel\~mOleg\lib\util\stackadd.f

    -1 CONSTANT std_word ( const - ����� ����� ������������� )
     1 CONSTANT imm_word ( const - ����� ����� ��������� )

\ ����� � ������ �������� ����� ����� ������ �����.
CREATE word-to-find 2 CELLS ALLOT ( --> addr )

\ ����� ����� � ��������� ������ ��������
\ ��� xt ����� ���������� ������ ����� ������
\ ������������ ���������� ����������
: sFindIn ( asc #  vidn ... vidb vida #  --> asc # false | ?? xt imm )
          N>R word-to-find 2!
          BEGIN R@ WHILE
                word-to-find 2@  2R> 1 - >R
                SEARCH-WORDLIST DUP WHILENOT
               DROP
            REPEAT NR> nDROP EXIT
          THEN RDROP
          word-to-find 2@ FALSE ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
  S" passed" TYPE
}test
