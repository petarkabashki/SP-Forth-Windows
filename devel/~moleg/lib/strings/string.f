\ 21-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� �������� � ���������� �������� ����������� \n \r \t \\ \" \123

 REQUIRE KEEP     devel\~moleg\lib\spf_print\pad.f
 REQUIRE SkipChar devel\~mOleg\lib\util\parser.f
 REQUIRE COMPILE  devel\~mOleg\lib\util\compile.f

\ ������������� ������ \123 � ��� �������
: CharCode ( asc # --> char )
           BASE @ >R DECIMAL
            0 0 2SWAP >NUMBER IF -1 THROW ELSE 2DROP THEN
           R> BASE ! ;

\ ������������� ���������� ������������������ \? � ������
\ ���� �� ��������� ��������� ������������������ - ����������� ���
\ ������������� �������.
: expose ( --> char )
         PeekChar SkipChar
          [CHAR] t OVER = IF DROP 0x09 EXIT THEN  \ tab
          [CHAR] n OVER = IF DROP 0x0A EXIT THEN  \ cr
          [CHAR] r OVER = IF DROP 0x0D EXIT THEN  \ lf
       \ ����������� ������� ���� ����� ��������� ������ ����������� ��������
          DUP 0x0A DIGIT                          \ \XXX
          IF 2DROP CharAddr char - 3 CHARS CharCode 2 CHARS >IN +! EXIT THEN
         ;

\ ������� ��������� ������ � ������ ����������� �����������
: IfChar ( char --> char ) [CHAR] \ OVER = IF DROP expose THEN ;

\ ����������� ������, ����������� ��������� ��������
: CookLine ( char --> asc # )
           <| BEGIN NextChar 0= WHILE
                    2DUP <> WHILE
                    IfChar KEEP
                 REPEAT 2DROP |> EXIT
              THEN -1 THROW ;

\ �������� ����������� ������ � ����������� (���� ������ ������� ������)
: s" ( / name" --> ) [CHAR] " CookLine [COMPILE] SLITERAL ; IMMEDIATE

\ �������� ������, ������������ �������� " �� �������� ������,
\ ������������� � ������� ����� ���, ��������� ������ �� ����� ���������
: ." ( --> ) ?COMP [COMPILE] s" COMPILE TYPE ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ --------------------------------------

test{ \ ���� ������ ���� �� ��������������.
  S" passed" TYPE
}test

\EOF

: test s" \tSimple\nsample\n\"text\" \nwith\123codes\125" TYPE ;
test
