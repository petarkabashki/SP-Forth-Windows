\ ��. ~af/lib/locstack.f
\ ������ ������ ������� ���� � CATCH/THROW

REQUIRE /TEST ~profit/lib/testing.f

USER-VALUE LSP@
USER-CREATE S-LSP  64 CELLS USER-ALLOT
: LS-INIT S-LSP TO LSP@ ;
LS-INIT
..: AT-THREAD-STARTING LS-INIT ;..

: +LSP ( -- )    \ �������� �������
  LSP@ CELL+ TO LSP@ ;

: -LSP ( -- )    \ ������ �������
  LSP@ 1 CELLS - TO LSP@ ;

: >L ( n -- ) ( l: -- n ) \ ��������� ����� �� ����� ������ �� ��������� ����
  LSP@ ! +LSP ;

: L> ( -- n ) ( l: n -- ) \ ��������� ����� � ���������� ����� �� ���� ������
  -LSP LSP@ @ ;

: L@ ( -- n ) \ �������� ������� ����� � ���������� ����� �� ���� ������
  LSP@ 1 CELLS - @ ;

: LPICK ( n1 -- n2)
  LSP@ SWAP 1+ CELLS - @ ;

: LDROP ( l: n -- )  -LSP ;

: 2>L ( x1 x2 -- ) ( l: -- x1 x2 ) \ �������� ��� ����� �� ���. ����
  SWAP >L >L ;

: 2L> ( -- x1 x2 ) ( l: x1 x2 -- )
  L> L> SWAP ;

: 2L@ ( -- x1 x2 )
  1 LPICK L@ ;

/TEST
$> 1 >L  2 >L  L> . L> .