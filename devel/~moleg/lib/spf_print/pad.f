\ 04-06-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �������������� ����� ��� ������� ������ � ������� PAD

 REQUIRE ADDR     devel\~moleg\lib\util\addr.f

?DEFINED char  1 CHARS CONSTANT char

        0x0D    CONSTANT cr_
        0x0A    CONSTANT lf_
        0x09    CONSTANT tab_
        CHAR .  CONSTANT point
        CHAR ,  CONSTANT comma

\ ������������� ����� � ������
: >DIGIT ( N --> Char ) DUP 0x0A > IF 0x07 + THEN 0x30 + ;

\ �������� ������ � PAD
: BLANK ( --> ) BL HOLD ;

\ �������� ��������� ���-�� �������� � PAD
: BLANKS ( n --> ) 0 MAX BEGIN DUP WHILE BLANK 1 - REPEAT DROP ;

\ ������������� ������ ������� �������������� �
: <| ( --> ) SYSTEM-PAD HLD A! ;

\ �������� ������ � ����� PAD �
\ ������� �� HOLD � ���, ��� ������ ����������� � ����� ����������� ������
\ � �� � �� ������.
: KEEP ( char --> ) HLD A@ C! char HLD +! ;

\ ������� �������������� ������ �
: |> ( --> asc # ) 0 KEEP SYSTEM-PAD HLD A@ OVER - char - ;

\ �������� ������ � ����� PAD �
\ �������� ���������� HOLDS �� ����������� ����, ��� ������ �����������
\ � ����� ����������� ������, � �� � �� ������.
: KEEPS ( asc # --> ) HLD A@ OVER HLD +! SWAP CMOVE ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ �������� ���������������.

  S" passed" TYPE
}test
