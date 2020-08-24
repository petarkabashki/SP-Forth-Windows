\ 08-10-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � utf16 : �������� �� 0 �� 0xD7FF � �� 0xE000 �� 0xFFFFF.

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f
 REQUIRE /chartype devel\~moleg\lib\strings\chars.f

?DEFINED IS : IS POSTPONE TO ; IMMEDIATE

\ ------------------------------------------------------------------------------

\ �������� ������� ��� ����� �����
: BSWAP ( W[B|L] --> W[L|B] ) DUP 8 LSHIFT SWAP 8 RSHIFT OR 0xFFFF AND ;

\ ��������, ��������� ������������ �������� � �������� �������� ���������� ����
\ �� ��������� �� ������ �����������
: W@' ( addr --> w ) W@ BSWAP ;
: W!' ( w addr --> ) >R BSWAP R> W! ;

\ ��������� ���� ����, ������������ � ���������� ������
\ ��� ��� ������� ���� ������� �� ����������� � �� ������
\ � ���������� ������������ ��(����) W@ ���� W@ BSWAP
  USER-VECT WN@ ( addr --> W )
  USER-VECT WN! ( w addr --> )
            ' W@ IS WN@
            ' W! IS WN!

\ ���������� ������ �������
\ ���� ������������ ������� ��������� � ��������� 0xD800-0xDFFF
\ ������ �������� 4 �����, ����� ���.
: CHAR# ( addr --> # ) WN@ 0xDC00 AND 0xD800 = IF 4 ELSE 2 THEN ;

\ ������� �������� �������, ����������� �� ���������� ������ addr
: CHAR@ ( addr --> char )
        DUP WN@ 0xD800 2DUP AND =
        IF SWAP 2 + WN@
           0x03FF AND 10 LSHIFT SWAP 0x03FF AND OR 0x10000 +
         ELSE NIP
        THEN ;

\ ��������� ������ char �� ���������� ������ addr
\ ������� � ����������� ��������� 0xD800 0xDFFF �������, ��� ������
\ ����� ����������� �������� � ��� ���� �������� �����, ��� �������, �� ������
: CHAR! ( char addr --> )
        OVER 0xFFFF >
        IF >R 0x10000 - DUP 10 RSHIFT  \ l h
           0x3FF AND 0xDC00 OR R@ 2 + WN!
           0x3FF AND 0xD800 OR R> WN!
         ELSE WN!
        THEN ;

\ ������������� utf16 ������ �� ������� ��������
\ ��������, ������� �����, ����� �������� � ������� ALLOT
\ : CHAR, ( char --> ) HERE TUCK CHAR! CHAR# ALLOT ;

\ �������� �� ����� utf16 ������������.
\ �� ����� ����� ������ ������.
: ?utf16 ( addr --> flag ) W@ 0xFEFF OVER 0xFFFE = -ROT = OR ;

\ �������� �� ������ �� ���������� ������ utf16 ��������
\ ��������� ����� �������� ������ ������� ������, ��� ���������
\ ������ ������ �������� ��������� �����.
: ?utf16char ( addr --> flag )
            DUP WN@ DUP 0xD800 0xDFFF WITHIN
                    IF SWAP 2 + WN@ AND 0xD800 AND 0xD800 =
                     ELSE 2DROP FALSE
                    THEN ;

\ �������� �� �������� ������ utf16 ������(�)
\ � �����������, ��� ���������������, ��� ����� � utf16 ��������� ������
\ ���������� � ������� ������, � ����� ������ ������ ���������� � �������
\ ������.
: isUTF16 ( asc # --> flag )
          OVER ?utf16 IF 2DROP TRUE EXIT THEN
          OVER ?utf16char IF 2DROP TRUE EXIT THEN
         \ ������ ������������, ��� ������ ������� ���� �� �� ���� ��������,
         \ ����������� � ����� ������� ��������
         6 < IF DROP FALSE EXIT THEN
         DUP CHAR# OVER +
         DUP CHAR# DUP 4 = IF DROP NIP ?utf16char EXIT THEN OVER +
         DUP CHAR# 4 = IF NIP NIP ?utf16char EXIT THEN
         WN@ 0xFF00 AND ROT WN@ 0xFF00 AND ROT WN@ 0xFF00 AND
         OVER = >R = R> AND
         ;

\ ��������� addr �� ����� ������ �������
: <CHAR ( addr --> addr )
        BEGIN 2 - DUP WN@ 0xD000 TUCK AND = WHILE REPEAT ;


\ ������� ������ ����, ���������� � ���������
: UTF16> ( --> '@ '! '+ 'char# )
         ['] CHAR@  ['] CHAR!  ['] CHAR+  ['] CHAR#  ['] <CHAR ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ : CHAR, ( char --> ) HERE TUCK CHAR! CHAR# ALLOT ;
      0x2315 DUP HERE CHAR! HERE CHAR@ <> THROW
      0x12315 DUP HERE CHAR! HERE CHAR@ <> THROW
      HERE 0xFFFE W, 0x2315 CHAR, 0x2316 CHAR, 0x23FF CHAR, 0x12432 CHAR,
                     0x2320 CHAR, 0x238F CHAR,
      DUP 14 isUTF16 0= THROW
      2 + DUP 12 isUTF16 0= THROW
      2 + DUP 10 isUTF16 0= THROW
      2 + DUP 8  isUTF16 0= THROW
      2 + DUP 6  isUTF16 0= THROW
      2 + 4  isUTF16 THROW
S" passed" TYPE
}test
