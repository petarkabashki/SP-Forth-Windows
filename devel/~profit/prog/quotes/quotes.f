\ bac4th'���� ������ ~ygrek/prog/web/irc/quotes.f
\ ������ �� ��������� ��� ������� ����������� ��� ����������...
\ � ���� ��� ���������� ������������� ���������� � ��������� --
\ ��������, thQuote ����� ������ ������������� ���� ����, ����
\ ���� ���� ��� ����� ������ ������� (������ ������������, ����
\ � ��������...). � ����� ��� ��������� ������������ ���� �����,
\ �. �. �� ������ ������ "� ���", � ���� ��� ����������� ���-��
\ ����� ��� ������ ���������� �����.

\ �� ��� �������� ��� ��� ��������� -- ������, ����� ���������
\ ��� ����� ������������ � ���� ��������� �������� ����� ������
\ ������ ����.

\ REQUIRE MemReport ~day/lib/memreport.f
REQUIRE FILE ~ac/lib/str4.f
REQUIRE ULIKE ~pinka/lib/like.f
REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE LOCAL ~profit/lib/static.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
REQUIRE arr{ ~profit/lib/bac4th-sequence.f
REQUIRE split-patch ~profit/lib/bac4th-str.f
REQUIRE GENRAND ~ygrek/lib/neilbawd/mersenne.f
REQUIRE ATTACH-LINE-CATCH ~pinka/samples/2005/lib/append-file.f

' ANSI>OEM TO ANSI><OEM \ ��������� ������ � �������



: LOAD-FILE ( addr u -- addr u ) PRO FILE OVER FREEB DROP CONT ; \ ������ ����
: TAKE-TWO PRO *> <*> BSWAP <* CONT ; \ �������� �������


: DCELL/ ( u1 -- u2 ) 2/ CELL / ;

: DCELL[] ( addr u i -- d )        \ addr u -- ����� � ����� ������� ������� ��������
LOCAL i i !                        \ i -- ������ �������� ������� ���� ����� �� ����� �������
DUP DCELL/ i @ <                   \ ��������� ���������� �������
SWAP 0=                            \ � ������� �������
OR IF DROP S" no quotes found" EXIT THEN \ ��� ����� ������� ������� -- ���� ������
i @ 2* CELLS + 2@ ;



WINAPI: GetTickCount KERNEL32.DLL
GetTickCount SGENRAND \ �������� �������


: randomDCELL[] ( addr u -- d ) DUP DCELL/ GENRANDMAX DCELL[] ;
\ �� ������� ������� �������� ���� ������� �� ��������� ��������

: qF S" .\quotes.txt" ;

: quotes ( -- list-xt ) \ list-xt - ��������-������ ������� ��������
PRO qF LOAD-FILE
seq{
byRows split-patch \ ����� �� ������
DUP ONTRUE \ ������ ������ �������
}seq2 CONT ;

: quotesLen ( -- len ) \ ������� ���-�� ������� � �����
+{ quotes ENTER  1 }+ ;

: quotesArr ( --> addr u \ <-- ) PRO quotes arr{ ENTER TAKE-TWO }arr CONT ;

: thQuote ( n --> addr u \ <-- ) PRO \ n-�� ������ �� �����
quotesArr ROT DCELL[] CONT ;

: randomQuote ( --> addr u \ <-- ) \ ������� ��������� ������� (������) �� �����
PRO quotesArr randomDCELL[] CONT ;

\ : FOUND ( addr1 u1 addr2 u2 -- f ) " *{s}*" DUP >R STR@ ULIKE R> STRFREE ;
\ � �� ����� �� �������� ���� � ULIKE ���������������������, �������� ������� ����...
: FOUND ( addr1 u1 addr2 u2 -- f ) SEARCH NIP NIP ;


: searchQuote ( addr u --> addr1 u1 \ <-- ) PRO LOCAL sLen sLen ! LOCAL sAddr sAddr !
quotes arr{ ENTER 2DUP sAddr @ sLen @ FOUND ONTRUE TAKE-TWO }arr ( addr u )
\ ���������� ��� �������� ������ ���������� � ������
randomDCELL[] CONT ; \ � �� ������� ������������ ��������� �������

: addQuote ( addr u -- ) qF ATTACH-LINE-CATCH THROW ;

\EOF
S" Doh! [Homer]" addQuote


REQUIRE iterateBy ~profit/lib/bac4th-iterators.f

: r 1 10  1 iterateBy  \ ������ ���
randomQuote CR TYPE ; \ ����������� ��������� ������
r

: r2 1 4  1 iterateBy \ ������ ����
S" ���" searchQuote CR TYPE ; \ �������� ������ � "��"
CR r2
\ MemReport