\ ����������� ����������, ���������� ��������������� � ����� ���� �����������.
\ � ���������� � ������ KEEP ��� KEEP! (����� LOCAL, ��. ������ �����) ����� 
\ ������������ ��� ��������� bac4th-����������� ��������� ����������.
\ �������� � ����������: http://fforum.winglion.ru/viewtopic.php?t=409

\ ��� ������������� � bac4th-������, LOCAL ���� ���������
\ *�����* PRO

\ STATIC � LOCAL ���������� ���������� � ����

\ TODO: ������� ������ �������� ���������� �������� � �� �� ������

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE KEEP ~profit/lib/bac4th.f
REQUIRE NOT ~profit/lib/logic.f

MODULE: static

USER widLocals
widLocals 0!

USER widHere
USER widCurrent

: ADD-ORDER ( wid -- ) ALSO CONTEXT ! ;

: END-STATIC widLocals @  IF           \ �������� �� ������� ���������� ������� ������� �� ������ �������� (���� ��?)
HERE PREVIOUS widCurrent @ SET-CURRENT \ ��������������� ���� �������� � CURRENT
widLocals @ FREE-WORDLIST
DP ! widLocals 0!         THEN ;

: (;) ?COMP END-STATIC S" ;" EVAL-WORD ;

: CREATE-LOCAL-WORDLIST ( -- )      \ ������ ������� ��������� ����������
GET-CURRENT widCurrent !            \ ���������� CURRENT
TEMP-WORDLIST ADD-ORDER DEFINITIONS \ ������ ��������� �������, ������ ��� �������
S" ;" CREATED IMMEDIATE             \ ��������� � ������� ����� ; ������� ����� ����������� ������ ���. ����������
DOES> DROP (;) ;

: LOCAL-WORDLIST widLocals @ NOT IF     \ ��������� �� ��������� ������� ���. ����������.
CREATE-LOCAL-WORDLIST                   \ ���� � ������ ���, �� �� �������� � ��������������� ��� �������
CONTEXT @ widLocals !            ELSE
widHere @ DP !  DEFINITIONS      THEN ; \ ���� ������� ��� ������, �� ��������� �������� HERE � �������� ����� ������ � ���� �����


: STATIC=>
HERE LATEST NAME> =                \ �� ��������� � �����, � ������� ��� ������ �� ��������������� 
IF R> EXECUTE HERE LATEST NAME>C ! \ ����� ������, �������� ���� ����
ELSE                               \ ����� ��� ��� ����, ����� ������ ��������
0 BRANCH, >MARK                    \ jmp HERE+������ , ������������� ������ 
R> EXECUTE                         \ ����� ������ ���������� ���������� (-��)
1 >RESOLVE THEN                    \ ������ ������ jmp �� ���� 
LAST @ HERE                        \ �������� HERE ������ �����������, ��������� LAST
CURRENT @  WARNING @  WARNING 0!   \ ��������� �� ������ ���������� 
LOCAL-WORDLIST                     \ ������ ��� ��������� �� ��������� ������� ��������� ���������� 
CREATE IMMEDIATE                   \ ������ � ��������� ������� ��� ��������� ���������� 
WARNING !
OVER CELL - ,                      \ ����������� ����� ���������� ������� ������ 
HERE widHere !                     \ �������� HERE ������ ������� 
SET-CURRENT 
DP ! LAST !                        \ ��������� HERE ������ �����������, ��������������� LAST
DOES> @ LIT, ;

VARIABLE staticLen

: >numb 0. 2SWAP >NUMBER 2DROP D>S ;

: lastLocal  ( -- xt ) widLocals @ @ NAME>  ;

EXPORT
: STATIC ( "name -- ) ?COMP 
STATIC=>
\ ALIGN                          \ ������������� ��� ����� �� ����������, ���� �������� �����... 
0 ,                              \ ���� ������, ����� ���� 
; IMMEDIATE

: STATIC# ( len "name -- ) ?COMP
NextWord >numb staticLen !  \ ���������� ����� ������������ ������� (� �������!)
STATIC=> staticLen @ 0 DO 0 , LOOP \ ���������� ������
; IMMEDIATE


: LOCAL ( "name -- ) [COMPILE] STATIC
lastLocal EXECUTE
POSTPONE KEEP ; IMMEDIATE

: LPARAMETER ( "name -- ) [COMPILE] STATIC
lastLocal EXECUTE
POSTPONE KEEP
lastLocal EXECUTE
POSTPONE ! ; IMMEDIATE

;MODULE

/TEST
: previousValue
STATIC a
a @
SWAP a ! ;

REQUIRE SEE lib/ext/disasm.f
$> SEE previousValue

\ 559330 E904000000       JMP     559339  ( previousValue+9  )
\ 559335 0000             ADD     [EAX] , AL
\ 559337 0000             ADD     [EAX] , AL
\ 559339 8BD0             MOV     EDX , EAX
\ 55933B A135935500       MOV     EAX , 559335  ( previousValue+5  )
\ 559340 891535935500     MOV     559335  ( previousValue+5  ) , EDX
\ 559346 C3               RET     NEAR

$> 1 previousValue .
$> 2 previousValue .
$> 3 previousValue .
$> 10 previousValue .


: fact ( n -- n! ) \ �� ����� ������� ������, ��������.
DUP 0=      IF     \ �� ��� �� ����� ���������� ��� ����������� ���������
DROP 1      ELSE   \ �������� � ����������� ����������
LOCAL n            \ ���� ����� ��� � STATIC n  n KEEP
DUP n !
1- RECURSE
n @ *       THEN ;

$> 10 fact .

\ ���������� �������� ��������� ����������,
\ "������" ��� LOCAL par par !
\ ��� � LOCAL -- ������ ��� STATIC# 1 par par KEEP
: localsTest ( a b -- sum )
LPARAMETER b  LPARAMETER a \ � ��������������� � �������� ������� �������
\ �� ���� �������� ������������ �� �����
a @ 0= IF 0 EXIT THEN
a @ b @ 0 0 RECURSE + + . ;
$> 3 4 localsTest
SEE localsTest

0
CELL -- a
CELL -- b
CELL -- c
DROP

: sum ( a b -- )
STATIC# 3 s \ �������� � ����� ���� ������������ � 3 ������ � 
\ ��� �� ��� s

s a ! s b !

s a @
s b @ + 
s c !
s c @ ;

$> 1 3 sum .

: rr LOCAL s 
10 s ! 
s @ . ;
CR CR rr