\ 31-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ �������������� ������ �������� ��������� �����

 REQUIRE KEEPS    devel\~moleg\lib\spf_print\pad.f
 REQUIRE R+        devel\~moleg\lib\util\rstack.f
 REQUIRE SKIPn    devel\~moleg\lib\strings\stradd.f

\ ----------------------------------------------------------------------------

\ ����������� ������ �� ��������� ���������
: asc>temp ( asc # --> asc # ) TUCK char + PAD SWAP CMOVE PAD SWAP ;

\ ��������� � ������ src # ��� ������� '#' �� ����� ����� u
\ ��������� �������� �� ��������� ����� ����� � ����� ���������� �������
: partnum ( src # u --> res # )
          >R asc>temp
          R> 0 <# # # # # # # # # # # #>
          2OVER BEGIN DUP WHILE char -
                      2DUP + C@ [CHAR] # =
                      IF 2SWAP char - 2DUP + C@ >R
                         2SWAP 2DUP + R> SWAP C!
                      THEN
                REPEAT 2DROP 2DROP
          2DUP + 0 SWAP C! ;

\ ���������� ��� ������� �� �������������� ����� ������� �����
: skip-fld ( src # --> pos. )
           0 >R BEGIN R@ OVER <> WHILE
                      OVER R@ + C@ [CHAR] . <> WHILE
                   char R+
                  REPEAT
                THEN 2DROP R> ;

\ �� ������ src # ����� ��� ������� �� ������� '.' ��� �� ����� ������
: get-fld ( asc # --> pos ) OVER SWAP skip-fld TUCK KEEPS ;

\ �������� �������� ��� �������� �����������
: onchar ( asc # pos char --> asc # pos )
         [CHAR] ? OVER = IF DROP OVER MIN >R OVER R@ +
                            C@ KEEP R> char + EXIT
                         THEN
         [CHAR] * OVER = IF DROP >R 2DUP get-fld R> + EXIT THEN
         [CHAR] . OVER = IF KEEP DROP 2DUP skip-fld char +  SKIPn 0 EXIT THEN
         KEEP char + ;

\ ������� ����������� � ��������� * ? - # ����������
: onward ( src # masc # --> res # )
          OVER + SWAP  0 >R
         <| BEGIN 2DUP <> WHILE \ ���� �� ����� �����
                  DUP char + SWAP C@ >R
                  2SWAP 2R> onchar >R 2SWAP
            REPEAT RDROP 2DROP 2DROP
          |> ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ ���� �� ��������������.
  S" passed" TYPE
}test

\EOF -- �������� ������ -----------------------------------------------------

S" must be: ab2-01.pt6   ?= " TYPE S" ab#-##.pt#" 2016 partnum TYPE CR
S" must be: abcabc.de.n  ?= " TYPE S" abc.def" S" **.??.n" onward TYPE CR

\EOF
������ ����������� ������������� ��� ������������ ������ �� �������� �������.
����� onward �������� ������������ ������ � ������, �������� �������� ������
����������� ��������� �������:
     ���� �������� ������ '*' - �� ��� ���������� ������ �� ������ �� ������
       ����� (���� �� ����� �� ��������� �����) ����������� � ��������������
       ������;
     ���� �������� ������ '?' - �� ������ �� ���� ������� (������� � ������
       �������� ������ ��� �� ���������� �����) ���������� �� ����� ����� ?;
     ���� �������� ������ '.' - �� ������� ������ �������� ������ ���������
       � �������, ������������ �� ������.
��� �������� ����� partnum , �� ��� �������� � �������� ������ ��� �������
'#' �� ������� �����, ����������� �� ��������� n � ������� ������� ����������
� �������� �������, �� ���� � ����� ������:
  S" a#bcd#-e##" 1234 partnum TYPE ������ ������: a1bdc2-e34.



