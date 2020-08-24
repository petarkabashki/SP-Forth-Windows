\ 2008-08-19 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ ������������� ���������, ��������� �� �����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE WHILENOT devel\~moleg\lib\util\control.f
 REQUIRE B,       devel\~mOleg\lib\util\bytes.f

\ ������ �������� �� �������� ������ �� ����������.
?DEFINED atod : atod ( addr --> disp )  HERE CELL+ - ;

\ �������� ��������� �� FALSE ��� �������� �����
: *BRANCH, ( ADDR --> )
           0x0B B, 0xC0 B,         \ or eax, eax
           0x0F B, 0x84 B,         \ je #
           atod A, ;

\ �������� ��������� ���� ����� ������ ���� ��� �������� �����
: -BRANCH, ( ADDR --> )
           0x83 B, 0xF8 B, 0x00 B,  \ cmp tos, # 0
           0x0F B, 0x89 B,          \ js #
           atod A, ;

\ ��������� �� �������������� �������� �� ������� �����, �������� �� ���������
: -IF ( value --> value )
      STATE @ IFNOT init: THEN
      2 controls +!
      HERE -BRANCH, >MARK 1
      ; IMMEDIATE

\ ���������� �������� IF �� ����������� ����, ��� �� ������� �������� �����
: *IF ( value --> value )
      STATE @ IFNOT init: THEN
      2 controls +!
      HERE *BRANCH, >MARK 1 ; IMMEDIATE

\ ���������� �������� WHILE, �� �� ������� ���� � ������� ����� ������
: *WHILE ( value --> value )
         ?COMP 2 controls +!
         HERE *BRANCH, >MARK 1 2SWAP
         ; IMMEDIATE

\ ���������� �������� UNTIL, �� �� ������� ���� c ������� ����� ������
: *UNTIL ( value --> value )
        ?COMP -2 controls +!
        3 = IFNOT -2004 THROW THEN *BRANCH,
        controls @ IFNOT [COMPILE] ;stop THEN
        ; IMMEDIATE


?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{  0 -IF 24542857 ELSE 67029874 THEN 67029874 <> THROW THROW
      10 -IF 24542857 ELSE 67029874 THEN 67029874 <> THROW 10 <> THROW
      -1 -IF 24542857 ELSE 67029874 THEN 24542857 <> THROW 1 + THROW

       0 *IF 24542857 ELSE 67029874 THEN 67029874 <> THROW THROW
      -1 DUP *IF 24542857 ELSE 67029874 THEN 24542857 <> THROW <> THROW
     123 DUP *IF 24542857 ELSE 67029874 THEN 24542857 <> THROW <> THROW

       3 BEGIN *WHILE 1 - REPEAT THROW
       3 BEGIN 1 - *UNTIL 2 <> THROW

  S" passed" TYPE
}test































































\
