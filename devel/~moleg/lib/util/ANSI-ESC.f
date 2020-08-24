\ 25-06-2005 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������ � �������� ����� ANSY ��������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

 \ ��� �������� ANSI ESCAPE ������������������
 CREATE esc 2 C, 0x1B C, CHAR [ C,

\ �� ��, ��� [CHAR] n HOLD
: hld" [COMPILE] [CHAR] POSTPONE HOLD ; IMMEDIATE

\ �� ��, ��� 0x1B HOLD [CHAR] [ HOLD
: ESC  [ esc COUNT ] 2LITERAL HOLDS ;

: PRINT COUNT TYPE ;

\ S" ��� ����, ���������� "
: S~ [CHAR] ~ PARSE [COMPILE] SLITERAL ; IMMEDIATE

: ESC: S~ CREATE NextWord S", DOES> esc PRINT~ EVALUATE ; IMMEDIATE

\ ---------------------------------------------------------------------------

\ escape ������������������ ��� ����������
: esc-0 ESC: PRINT ;

esc-0 page 2J   \ �������� �����, ������ � 0,0
esc-0 !csr s    \ ��������� ��������� �������
esc-0 @csr u    \ ������������ ����������� ��������� �������
esc-0 clrl K    \ �������� �� ������� �� ����� ������

\ ---------------------------------------------------------------------------

\ escape ������������������ � ����� ���������� � '=' ����� esc
: esc-k ESC: <# COUNT HOLDS 0 # # # hld" = #> TYPE ;

esc-k mode h    \ ����� ������ ������ �������
esc-k resm I    \ ����� ������ ������ �������

\ � microsoft ������� ����� ������
0 CONSTANT 40*25bw
1 CONSTANT 40*25clr
2 CONSTANT 80*25bw
3 CONSTANT 80*25clr
4 CONSTANT 320*200clr
5 CONSTANT 320*200bw
6 CONSTANT 640*200bw

\ escape ������������������ � ����� ����������
: esc-1 ESC: <# COUNT HOLDS 0 # # # #> TYPE ;

esc-1 cuu A     \ ������ ����� �� # �����
esc-1 cud B     \ ������ ���� �� # �����
esc-1 cuf C     \ ������ ������ �� # �������
esc-1 cub D     \ ������ ����� �� # �������

\ ---------------------------------------------------------------------------

\ ������������������ � ����� �����������
: esc-2 ESC: <# COUNT HOLDS 0 # # # hld" ; NIP # # # #> TYPE ;

esc-2 XY! H

\ ---------------------------------------------------------------------------

\ ������������������ � ����� ������������� ����������
: esc-x ( n | name p --> )
        CREATE NextWord <# HOLDS 0 # # # ESC #> S",
        DOES> PRINT ;

7 esc-x invscr m
0 esc-x atroff m
1 esc-x boldon m
5 esc-x blink  m
8 esc-x concea m

0 CONSTANT black
1 CONSTANT red
2 CONSTANT green
3 CONSTANT yellow
4 CONSTANT blue
5 CONSTANT magenta
6 CONSTANT cyan
7 CONSTANT white

esc-1 setprm m

\ ���������� ����
: color 30 + setprm 40 + setprm ;

\ ---------------------------------------------------------------------------

\ ������ ��������� �������
esc-0 xy? 6n

\ ������������� �����
: >num ( asc # --> n  )
       0 0 2SWAP >NUMBER 2DROP DROP ;

\ �������� �� ������������������ �������� �� addr ESCAPE �������������������
: ?esc[ ( addr --> flag ) W@ esc 1+ W@ = ;

\ ��������� ������� ������� ANSY
: check-ANSI ( --> )
             xy? REFILL
             IF CharAddr ?esc[ #TIB >IN !
              ELSE FALSE
             THEN ;

\ �������� ��������� �������
: XY@ xy? REFILL DROP 2 >IN +!
      [CHAR] ; PARSE >num
      [CHAR] R PARSE >num ;

\ �������� ������� ������� �����������
: [XY] !csr 99 cuf 99 cud XY@ @csr ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
    S" passed" TYPE
}test


