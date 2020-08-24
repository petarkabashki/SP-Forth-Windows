\ 04-06-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �������������� ����� ��� ������ � ��������

 REQUIRE WHILENOT devel\~mOleg\lib\util\ifnot.f

?DEFINED char  1 CHARS CONSTANT char

\ ����� ���������� >IN �����, �� ������ ���������� ����� asc #
: <back ( asc # --> ) DROP TIB - >IN ! ;

\ ���������� ���� ������ �� ������� ������
: SkipChar ( --> )  >IN @ char + >IN ! ;

\ ����� ��������� ������ �� �������� ������
: NextChar ( --> char flag ) EndOfChunk PeekChar SWAP SkipChar ;

\ ������� ����� � ������ ��� �� ��������������������� ����� �������� ������.
: REST ( --> asc # ) SOURCE >IN @ DUP NEGATE D+ 0 MAX ;

\ ��������� ������ �� ������� ������
: SeeForw ( --> asc # ) >IN @ NextWord ROT >IN ! ;

\ �� �������� ������ �������� ��� �����
: ParseFileName ( --> asc # )
                PeekChar [CHAR] " =
                IF [CHAR] " SkipChar
                 ELSE BL
                THEN PARSE
                2DUP + 0 SWAP C! ;

\ ���������� SOURCE �� ������ ���������� �
: cmdline> ( --> )
           -1 TO SOURCE-ID
           GetCommandLineA ASCIIZ> SOURCE!
           ParseFileName 2DROP ;

\ ����� ����� ��������� ������� �� �������� ������ �� ��� ���, ���� ��
\ �� �����������.
: NEXT-WORD ( --> asc # | asc 0 )
            BEGIN NextWord DUP WHILENOT
                  DROP REFILL DUP WHILE
                  2DROP
               REPEAT
            THEN ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
  S" passed" TYPE
}test
