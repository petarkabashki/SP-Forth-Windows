\ ��������� ��������� (����� ��� ����������)
\ ��������� ������ �� in.txt � ������� ���������� �����,
\ � ��������� �� � ���������� ������� ������������� �����������
\ ����� ���� �� � �������: ~pinka/samples/2003/common/qsort.f

\ ����������: hsort.f , binary-search.f , arr{ , STRcompiledCode

\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE 2VARIABLE lib/include/double.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE arr{ ~profit/lib/bac4th-sequence.f
REQUIRE split-patch ~profit/lib/bac4th-str.f
REQUIRE iterateBy ~profit/lib/bac4th-iterators.f
REQUIRE HeapSort ~mlg/SrcLib/hsort.f
REQUIRE binary-search.f ~profit/lib/binary-search.f

: TAKE-TWO PRO *> <*> BSWAP <* CONT ;
: TAKE-THREE PRO *> <*> BSWAP <*> ROT BACK -ROT TRACKING <* CONT ;

: TAKE-FOUR PRO                      *>
                                    <*>
BSWAP                               <*>
ROT BACK -ROT TRACKING              <*>
2SWAP SWAP BACK SWAP 2SWAP TRACKING <*  CONT ;

2VARIABLE tmp

:NONAME
['] ANSI>OEM TO ANSI><OEM \ ��������� ������ � �������

LOCAL arrLen LOCAL arrBeg

S" in.txt" load-file ( addr u ) 2DUP \ ��������: ������ ������ ����� ������� *�������* arr{
\ ���� �� ���� ������� ������, �� ����� ��� �� ��������� �� ������ �� arr{ ... }arr
\ , ��� ��� �� ����, ��� ��� � ��� � ������� *�������* �� ����� ������

arr{
BL byChar split-patch 2DUP \ ����������� ������� ������ ����� �� �������, � ����� -- �� ������,
byRows split-patch         \ ��� ��� BL byChar ��� ������ ������ ��� ���������� �������
DUP ONTRUE \ ������ ������ ���������
TAKE-TWO \ �������� ��� ��������
}arr
arrLen !
arrBeg !

arrLen @ CELL / 2/ TO PyrN
arrBeg @ \ ������������� � �������� ����������� ������� ��������
" 2DUP SWAP
    CELLS 2* [ DUP ] LITERAL + 2@
ROT CELLS 2*         LITERAL + 2@
COMPARE 0< "
STRcompiledCode TO []<[]

arrBeg @
" 2DUP
CELLS 2* [ DUP ] LITERAL  + 2@                                       tmp 2!
CELLS 2* [ DUP ] LITERAL  + 2@  2OVER SWAP >R CELLS 2* [ DUP ] LITERAL + 2!
tmp 2@                                     R> CELLS 2*         LITERAL + 2! "
STRcompiledCode TO []exch[]


HeapSort

0 PyrN 1-
S" ����" \ ������� �����
arrBeg @
" CELLS 2* LITERAL + 2@ ( 2DUP CR TYPE )
2LITERAL COMPARE NEGATE " STRcompiledCode
binary-search . . KEY DROP

START{ arrBeg @ arrLen @ 2 CELLS iterateBy DUP 2@ CR TYPE }EMERGE
; EXECUTE
\ MemReport