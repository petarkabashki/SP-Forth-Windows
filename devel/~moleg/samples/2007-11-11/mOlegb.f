\ 11-11-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ ������� ������� � ������
\ http://fforum.winglion.ru/viewtopic.php?t=1022&start=0&postdays=0&postorder=asc&highlight=

 REQUIRE FOR            devel\~mOleg\lib\util\for-next.f
 REQUIRE B@             devel\~mOleg\lib\util\bytes.f

\ ���������� ������ ��� ���������� �����
: revbyte ( b --> b )
          0 8 FOR 2* OVER 1 AND OR
                  SWAP 2/ SWAP
              TILL NIP ;

\ ������ � ���������������� �������
CREATE brarr  256 FOR 256 R@ - revbyte B, TILL

\ ���������� ������ ������
: revcell ( u --> u )
          0 4 FOR 8 LSHIFT
                  OVER 0xFF AND brarr + B@ OR
                  SWAP 8 RSHIFT SWAP
              TILL NIP ;

\ ��� ������� addr # ���������� ������� ������
: revarr ( addr # --> ) FOR DUP @ revcell OVER ! CELL + TILL DROP ;
