\ ������ �� ��������, ������� ������������� ����������� � ����,
\ � ������������� (��� ������) � �� ���������
\ bac4th strings AKA "���������� �����". ��� ��������� �����
\ ~mlg �� ����������� ����� � �� ��������
\ ��. http://fforum.winglion.ru/viewtopic.php?t=167

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE CONT ~profit/lib/bac4th.f
REQUIRE FREEB ~profit/lib/bac4th-mem.f
REQUIRE iterateByBytes ~profit/lib/bac4th-iterators.f
REQUIRE compiledCode ~profit/lib/bac4th-closures.f
REQUIRE STR@ ~ac/lib/str4.f
REQUIRE { ~ac/lib/locals.f
REQUIRE LOCAL ~profit/lib/static.f
MODULE: bac4th-str

: ?PAIRS <> ABORT" unpaired" ;
: >RESOLVE2 ( dest -- ) HERE SWAP ! ;


: concat-sum ( addr u var -- ) @ STR+ ;
: concat-suc ( var <--> s ) @  R> ENTER  STRFREE ;

EXPORT

: S> ( a u -- s ) "" DUP >R STR+ R> ;
: S>STR ( a u --> s \ <-- s ) PRO S> CONT STRFREE ;
: S>STR2 ( a u --> s \ <-- )  PRO S> BACK STRFREE TRACKING RESTB CONT ;

: copy-patch { a u i l \ e t -- a+i l }
a u + TO e
a i + e MIN TO t
t l + e MIN
t - t SWAP ;

: copy ( a u i l --> s \ <-- s ) PRO copy-patch S>STR CONT ;

\ ���������� ������� ������������ �� ��������� � ������
: byChar ( c <--> xt )  PRO S" C@ LITERAL =" compiledCode CONT ;
\ �������� �������� -----------^
\ ������ ������� ����������� � ������������ ��� ������� ������� find , split � ������
\ ����� �������, ���������� ��������� ������������ �� �� ������ ��� ������ � �������� 
\ ����������� �������� �� �, � ��������, � ������� � UTF-8... �, � iterateByBytes ?.!. ��...
\ �����... ���� ��������.

\ ������� ��������� ������� �� ������� ������
\ : byRows ( <--> xt ) PRO S" 2* 23 - ABS 3 ="  compiledCode CONT ;
\ : byRows ( -- xt ) (: 2* 23 - ABS 3 = ;) ;
:NONAME C@ 2* 23 - ABS 3 = ; \ 13 ��� 10
CONSTANT byRows

\ ������� ��������� ������� �� "�������", �. �. ��� ������, ��� ��������� ��� ��� ���...
:NONAME C@ 33 < ; \ ������ ��� ����� 32-�, �� ���� ���� ������ -- �����������.
CONSTANT byWhites

\ ������� ��������� ������� �� ��-"�������"
:NONAME C@ 32 > ; \ ������ 32-�, �� ���� ���� ������ �� �������� ������������.
CONSTANT byNotWhites

: find ( a u f <--> a1 )
\ ������� � ������ a u ��� �������, �� ������� ������� f ���� TRUE � ���������� ������ ��� ������� �������
\ ������� f ( � -- 0|-1 ) �������� �� ����� �������� ������� � ������� ���������� ��������
PRO LOCAL f f !
iterateByBytes DUP f @ EXECUTE IF CONT THEN ;

: split-patch ( a u f <--> addr u  )
\ ��������� ������ a u ���������, �� ������� ������� f ���� TRUE � ���������� 
\ ����� ��� ������� *�������* � ������ a u
PRO LOCAL f f !
OVER LOCAL p p ! \ p -- ����. �������, ����� �������� ����� ����� ������ ������
2DUP + LOCAL e e ! \ ��������� ������, ��� �������� ���������� �������
START{
f @ find ( addr ) \ �������� ������ ��� ������� �������
DUP p @ -  p @ SWAP CONT 2DROP \ �� ����������� �� �������� ���������� ������� ������ �������
DUP 1+ p ! }EMERGE

p @  e @ OVER - \ ���������� � ��������� �������, �� ����������� �� char
?DUP IF CONT 2DROP ELSE DROP THEN \ ���� �� ����
;

: first-patch ( a u f -- addr u ) LOCAL f f !
LOCAL len  DUP len !
LOCAL start  OVER start !
START{
S| CUT: f @ split-patch len ! start ! -CUT
}EMERGE
2DROP      \ S| ��������������� ��� �������� �� �����, ��� ���� �� ������� S| , ����� �� ������
start @ len @ ; \ ����� �������� �� "�������" ������ ���� ��������
\ ��������: ��� ����� �� �������� �����������, ��� ������� �����

: first ( a u f <--> s ) PRO first-patch S>STR CONT ;

: divide-patch ( a u f -- addr1 u1 addr2 u2 )     \ ������ ������ -- ������� *�����* ������� ������� �� ������� ��������� f
OVER >R first-patch 2DUP + OVER R> SWAP - 2SWAP ; \ ������ -- ��. ���� "��������" ������� ����� ��� ���� �����,
                                                  \ ��� ������� �������������� ������ �������� *��* ���� ���� �� �����.

: divide ( a u f --> s1 s2 \ <-- s1 s2 ) PRO LOCAL start LOCAL len
divide-patch 2SWAP len ! start !  S>STR  start @ len @ S>STR CONT ;

: split ( a u f <--> s1  )
\ ��������� ������ a u ���������, �� ������� ������� f ���� TRUE � ���������� ����� ��� 
\ ������ ������������������ ����� ����� ��������� � �������������� ���������� � ������� ������
PRO split-patch 2DUP S>STR CONT ;

: last-patch ( a u f <--> addr u ) PRO LOCAL a LOCAL len
START{ split-patch DUP len ! OVER a ! }EMERGE a @ len @ CONT 2DROP ;

: last ( a u f <--> s1  )
PRO last-patch 2DUP S>STR CONT ;

: notEmpty ( s <--> s ) PRO DUP STR@ NIP ONTRUE CONT ; \ ��������������� ������ ������

\ ����������� ... concat{ ���������-����� ( addr u ) }concat ( s <-> s ) ...
: concat{  ?COMP POSTPONE "" agg{ ; IMMEDIATE
: }concat  ?COMP ['] concat-sum ['] concat-suc }agg ; IMMEDIATE

: load-file ( addr u <--> addr1 u1 ) \ ��������� ����
PRO FILE CONT IF FREE THROW ELSE DROP THEN ;

: iterateStrings ( addr u <--> s ) PRO \ ������� ���� �� ������� �����
load-file 2DUP byRows ( ������� �������� �� ������� ������)
split notEmpty CONT ;

;MODULE

/TEST
: copy3-2 3 2 copy DUP STR@ TYPE ;
$> S" forth" copy3-2

: r S" mary has sheep" [CHAR] a byChar find DUP C@ EMIT ;
\ ������� ��� ������� 'a'
\ CR r

: split2Words BL byChar split notEmpty ."  [" DUP STR@ TYPE ." ]" ;
\ ����� �� �����. ������ ����� -- �� ������� �� ������� ������, �� �������� � ���� 
\ � ������������� ��� ������ ����� �� ���� ���������
\ �����: [mary] [has] [a] [sheep]
$> S"  mary  has a  sheep" split2Words

: split2WordsAndByA BL byChar split DUP STR@ [CHAR] a byChar split notEmpty ."  [" DUP STR@ TYPE ." ]" ;
\ ����� �� ����� � �� ������� ����� ������ 'a' � ������.
\ �����: [ntigu] [l] [br] [dor] [br] [c] [d] [br]
$> S" antigua labrador abracadabra" split2WordsAndByA

: firstWord BL byChar 2DROPB DROPB S| CUT: split -CUT ."  [" DUP STR@ TYPE ." ]" ;
\ ������ ������ ��������������� ������������������
\ �����: [antigua]
\ ��������, � ���� ������� �� ����� ������� �����, �� ������ ��� � ��� ��� �� ��������� �� ������
\ ��� ��� CUT ������� ������������ ������ ������� ������ split �� ����� ���������
\ ����� ������� �������� ���������: 2DROPB DROPB S|
$> S" antigua labrador abracadabra" firstWord

: "2"+"*2"+"=4"+"?" concat{ *> concat{ *> S" 2" <*> S" *2" <* }concat DUP STR@ <*> S" =4" <*> S" ?" <* }concat DUP STR@ TYPE ;
$> "2"+"*2"+"=4"+"?"

\ �����: 2*2=4?

: splitNmerge concat{ BL byChar split notEmpty DUP STR@ }concat ."  [" DUP STR@ TYPE ." ]" ;
\ ������� ��� ������� � ������
\ �����: [maryhasasheep]
$> S"   mary   has  a  sheep" splitNmerge

: divideBy= [CHAR] = byChar divide-patch 2SWAP TYPE SPACE TYPE ;
\ ��������� ������ �� ��� �����
\ �����: [a1] [123==456]
$> S" a1=123==456" divideBy=

: printFile  S" C:\lang\spf\devel\~profit\lib\bac4th-str.f" iterateStrings DUP STR@ CR TYPE ;
\ ����� ����� �� ������