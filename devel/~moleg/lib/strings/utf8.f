\ 07-10-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � utf8: �������� �������� 0 -- 0x7FFFFFFF

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f
 S" devel\~mOleg\lib\util\bytes.f" INCLUDED  \ ����� �� �������� � C@
 REQUIRE WHILENOT  devel\~moleg\lib\util\ifnot.f
 REQUIRE /chartype devel\~moleg\lib\strings\chars.f

\ ------------------------------------------------------------------------------

CREATE utf8cnt \ �������� ��� ����������� ����� ������� � utf8 ���������
               0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B,
               0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B,
               0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B,
               0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B,
               0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B,
               0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B, 0x01 B,
               0x02 B, 0x02 B, 0x02 B, 0x02 B, 0x02 B, 0x02 B, 0x02 B, 0x02 B,
               0x03 B, 0x03 B, 0x03 B, 0x03 B, 0x04 B, 0x04 B, 0x05 B, 0x06 B,

\ ���������� ����� �������.
\ �� ����� �����, ��� ������ �����, �� ������ ��� �����
: CHAR# ( 'char --> # ) B@ 2 RSHIFT [ utf8cnt ] LITERAL + B@ ;

CREATE utf8hdr \ ����� ��� ��������� ������ �� ������� �����
               0x7F B, 0x3F B, 0x1F B, 0x0F B, 0x07 B, 0x03 B, 0x01 B,

\ ������� ������ �� ��������� �������.
\ �� ����� �����, �� �������� �������� ������, �� ������ ��� 32 ������ ��������
: CHAR@ ( 'char --> char )
        DUP B@ DUP 0x80 < IF NIP EXIT THEN
        OVER CHAR# [ utf8hdr ] LITERAL + B@ AND
        BEGIN SWAP 1 + TUCK
              B@ DUP 0xC0 AND 0x80 = WHILE
              0x3F AND  SWAP 6 LSHIFT  OR
        REPEAT DROP NIP ;

CREATE utf8hhh \ ����� ��� ���������� �������� � ������ �����
               0x00 B, 0x00 B, 0xC0 B, 0xE0 B, 0xF0 B, 0xF8 B, 0xFC B,

\ ������������� ������� ������ � ������������������ utf8 ����.
\ �� ����� ����� ����� � �������� �������.
: charr ( char --> [ 1 .. n ] )
        0 BEGIN OVER WHILE
                OVER 0x3F AND 0x80 OR
                ROT 6 RSHIFT
                ROT 1 +
          REPEAT NIP
        [ utf8hhh ] LITERAL + B@ OR ;

\ ��������� ������ char � utf8 ��������� �� ���������� ������.
: CHAR! ( char addr --> )
        OVER 0x80 U< IF B! EXIT THEN
        >R 0 SWAP charr
        R> BEGIN OVER WHILE
                 TUCK B! 1 +
           REPEAT 2DROP ;

\ ������������� utf8 ������ �� ������� ��������
\ : CHAR, ( char --> ) HERE TUCK CHAR! CHAR# ALLOT ;

\ �������� �� ����� utf8 ������������.
\ �� ����� ����� ������ ������.
: ?utf8 ( addr --> flag ) @ 0xFFFFFF AND 0xBFBBEF = ;

\ �������� �� ������ utf8 �������� ������ �� ���� �� ����� ����
\ ����� ������ ��������� �� ������ �������.
: ?utf8char ( addr --> flag )
            DUP B@ 0xE0 OVER AND 0xC0 = SWAP
                   0xF0 OVER AND 0xE0 = SWAP
                   0xF8 OVER AND 0xF0 = SWAP
                   0xFC OVER AND 0xF8 = SWAP
                   0xFE AND 0xFC = OR OR OR OR
            SWAP 1+ B@ 0xC0 AND 0x80 = AND ;

\ �������� �� �������� ������ utf8 ������(�)
: isUTF8 ( asc # --> flag )
         OVER ?utf8 IF 2DROP TRUE EXIT THEN \ ?���������
         OVER + SWAP
         BEGIN 2DUP <> WHILE   \ ���� ������ ���� � ����� ��������� �������
               DUP B@ DUP 0x7F < SWAP 0xC0 AND 0x80 = OR WHILE
             1 +
           REPEAT NIP ?utf8char EXIT
         THEN 2DROP FALSE ;

\ ��������� ��������� addr �� 1 ������
: <CHAR ( addr --> addr )
        BEGIN 1 - DUP B@ DUP 0x80 AND WHILE
                         0x40 AND WHILENOT
          REPEAT EXIT
        THEN DROP ;

\ ������� ������ ����, ���������� � ���������
: UTF8> ( --> '@ '! '+ 'char# )
        ['] CHAR@  ['] CHAR!  ['] CHAR+  ['] CHAR#  ['] <CHAR ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ : CHAR, ( char --> ) HERE TUCK CHAR! CHAR# ALLOT ;
0x7F HERE CHAR!  HERE CHAR@ 0x7F <> THROW
0x80 HERE CHAR!  HERE CHAR@ 0x80 <> THROW
HERE ?utf8char INVERT THROW
0x7FF HERE CHAR!  HERE CHAR@ 0x7FF <> THROW
0xFFFF HERE CHAR!  HERE CHAR@ 0xFFFF <> THROW
0x7FFFFFFF HERE CHAR!  HERE CHAR@ 0x7FFFFFFF <> THROW
HERE CHAR# 6 <> THROW
CREATE proba 0xBFBBEF , 0x45 CHAR, 0x7FD CHAR, 0xFFFF CHAR, 0x7FFFFFFF CHAR, 0 B,
proba ?utf8 INVERT THROW
proba HERE OVER - isUTF8 INVERT THROW
proba HERE OVER - 1 -1 D+ isUTF8 INVERT THROW
proba HERE OVER - 3 -3 D+ isUTF8 INVERT THROW

S" passed" TYPE
}test
