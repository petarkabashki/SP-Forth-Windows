\ 2008-01-29 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ ������ � ��������� �������� �����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE ADDR     devel\~moleg\lib\util\addr.f

0 \ ������ ���������, ����������� ������� ���������� �����
  ADDR -- off_char+  \ ����� �������� � ���������� �������
  ADDR -- off_char@  \ ����� ���������� �������
  ADDR -- off_char!  \ ����� ���������� �������
  ADDR -- off_char#  \ ���������� ������ �������, ��������, ��� utf-8 = 6
  ADDR -- off_<char  \ ����������� ��������� �� ���� ������ �����
 CONSTANT /chartype

\ ������ ��� ������ � ���������
: (C@) ( addr 'stream --> char ) off_char@ @ EXECUTE ;
: (C+) ( addr 'stream --> addr ) off_char+ @ EXECUTE ;
: (C!) ( char addr 'stream --> ) off_char! @ EXECUTE ;
: (C#) ( addr --> # )            off_char# @ EXECUTE ;
: (<C) ( addr --> addr )         off_<char @ EXECUTE ;

\ ������� �������� ������ � ������� ������� �������
: stream-type ( '@ '! '+ ', char# '<C 'strrec --> )
              DUP >R off_<char A!
                  R@ off_char# A!
                  R@ off_char+ A!
                  R@ off_char! A!
                  R> off_char@ A! ;

\ -- ������ � ��������� �������� ������ ----------------------------------------

        \ ��������� ��� ��������� ����������� ������� ���������� �����
        USER-CREATE CSTREAM /chartype USER-ALLOT

\ ������ ��� ������ � ��������� �������� �������� ������
: C@ ( addr --> char ) CSTREAM (C@) ;
: C! ( char addr --> ) CSTREAM (C!) ;
: C+ ( addr --> addr ) CSTREAM (C+) ;
: C# ( addr --> # )    CSTREAM (C#) ;
: <C ( addr --> addr ) CSTREAM (<C) ;
: C, ( char --> ) HERE TUCK C! C# ALLOT ;

\ ���������� ��������� �������� ������
: INPUT-STREAM ( '@ '! '+ ' # --> ) CSTREAM stream-type ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{
       : char# DROP CELL ;
       ' @ ' ! ' CELL+ ' char# ' CELL- INPUT-STREAM
       0x12345678 DUP HERE C! HERE C@ <> THROW
       HERE 0x23456789 DUP C, SWAP C@ <> THROW
  S" passed" TYPE
}test
