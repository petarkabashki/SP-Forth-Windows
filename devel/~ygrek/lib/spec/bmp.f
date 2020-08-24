\ $Id: bmp.f,v 1.2 2007/06/17 15:17:14 ygreks Exp $
\ Hype3 ����� ������� ��������� �� ����� � ������ ����������� � ������� BMP � 24-������ ������

REQUIRE CLASS ~day/hype3/hype3.f
REQUIRE BMPINFO ~ygrek/lib/data/bmp.f

\ ������� ����������� n2 > n1 ����� ��� n2 mod x = 0
: align ( n1 x -- n2 )
   2DUP MOD DUP 0= IF DROP DROP EXIT THEN
   - + ;

\ -----------------------------------------------------------------------

\ NB: ������ ������ ����������� ���������� � ������ ������������ �� 4
CLASS CBMP24

 VAR sizeX \ ������ X � ��������
 VAR sizeY \ ������ Y � ��������
 VAR data  \ ������ �����������

init: 0 sizeX ! 0 sizeY ! 0 data ! ;
dispose: data @ IF data @ FREE THROW THEN ;

\ ����� ���� ���������� ����� ������� �����������
: :getLineSize ( -- n ) sizeX @ 3 * 4 align ;

\ ����� ����� ��������������� ����������� x y
: pixel-address ( x y -- addr ) :getLineSize * SWAP 3 * + data @ + ;

: _rgb ( addr - r g b )
  >R
  R@ 0 + C@
  R@ 1 + C@
  R> 2 + C@ ;

\ ������ �����������
: :size ( -- x y ) sizeX @ sizeY @ ;

\ �������� ���������� ����� ������� � ������������ x y
: :rgb ( x y -- r g b ) pixel-address _rgb ;

\ ��������� ����������� �� ����� a u
\ � ������ ������ - ������������ ����������
: :load-file ( a u -- )
   2DUP FILE-EXIST 0= S" file not found" SUPER abort

   R/O OPEN-FILE THROW { f | info }
   f FILE-SIZE THROW DROP BMPINFO::/SIZE < S" too small file" SUPER abort
   BMPINFO::/SIZE ALLOCATE THROW TO info
   info BMPINFO::/SIZE f READ-FILE THROW BMPINFO::/SIZE <> S" No header" SUPER abort
   info BMPINFO::fType W@ 0x4D42 <> S" No BM sig " SUPER abort
   info BMPINFO::bSize @ 0x028 <> S" Size of structure <> 28h" SUPER abort
   info BMPINFO::fSize @ f FILE-SIZE THROW DROP <> S" Bad structure" SUPER abort
   info BMPINFO::bBitCount W@ 24 <> S" Not a 24bpp image" SUPER abort
\   inf BMPINFO::fOffset @ f REPOSITION-FILE THROW

   info BMPINFO::fSize @ info BMPINFO::fOffset @ -
   DUP DUP ALLOCATE THROW data !
   data @ SWAP f READ-FILE THROW <> S" Read failed" SUPER abort
   f CLOSE-FILE THROW

   info BMPINFO::bWidth @ sizeX !
   info BMPINFO::bHeight @ sizeY !
   info FREE THROW ;

;CLASS

\EOF

CBMP24 NEW a
S" 7.bmp" a :load-file
a :size SWAP . .
