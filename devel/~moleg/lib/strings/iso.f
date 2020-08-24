\ 2008-03-19 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ ������ � iso ���������

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f
 REQUIRE B@        devel\~mOleg\lib\util\bytes.f
 REQUIRE /chartype devel\~mOleg\lib\strings\chars.f

\ ������ ������ � ISO ���������:
: CHAR@ ( addr --> char ) B@ ;
: CHAR! ( char addr --> ) B! ;
: CHAR# ( addr --> # ) DROP 1 ;
\ : CHAR+ ( addr --> addr ) 1 + ; \ ��� ���� � ���
: <CHAR ( addr --> addr ) 1 - ;

\ ������� ������ ����, ���������� � ���������
: ISO> ( --> '@ '! '+ 'char# )
       ['] CHAR@  ['] CHAR!  ['] CHAR+  ['] CHAR# ['] <CHAR ;

?DEFINED test{ \EOF -- �������� ������ -----------------------------------------

test{
      ISO> INPUT-STREAM
      S" ABC" DROP C@ 0x41 <> THROW
      0xFB DUP HERE C! HERE C@ <> THROW
      HERE 0xFF DUP C, SWAP C@ <> THROW
  S" passed" TYPE
}test
