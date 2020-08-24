\ colorlessForth ��� �����. ���� -- Chuck Moore � Terry Loveall.
\ �� ���� ��� ��� ����������� ������ ������������ �������� � 
\ ������� (��� ���� ������� �������� ����� ��������� �������
\ control-flow ������).

\ �� ������ colorforth'� ������ ��. ������������ ������:
\ http://forth.org.ru/~profit/COLOR4th.pdf

\ ������ ������ ��������� ��������� ����������� ������������
\ ������� ���� � SPF:
\ 1. ��������� ������� �� ��������� (~profit/lib/colorForth/cascaded.f)
\ 2. ����������� ��������� ��������
\ 3. ����������� ������ �������������/���������� �� ���������� (� ������
\ ������ -- ����� ��������� ��������)

\ 4. ����� ������� ��������� ��������� ���������� ����������� ����������
\ (� ���� ����� �� ����).
\ 5. ������� ������� ������� ���� � ���������� ���� (�����).

\ ������������� ��� ���������.

\ ���� ������ ���������� � �������, ������ � ����� ���������.

\ ���� ������ ���������� � ���������, �� ����������� � � ��������� 
\ �������� �� ������� ��������� ��� ��������������� �������.
\ ����������� �������� � ������� ���������.
\ ���� ����������� ���, �� ��������� ��� �������� � �������.
\ ���� ���� ���� -- �� ���, ����� �������, ���� ��� -- �� ���,
\ ����� ������� � ������� � �.�.

\ �������� � ������ ��������� ���������� control-flow �����
\ ��� ��������� ��� �������� "��" � ������ �� ������� �������
\ ������� ��������� ��� �������� "�����".

\ �� ���� ��������� ������� ������ ��������� ������������, �����
\ �� ������ ������ ������ ����� � �������� ��� ���� ��������� 
\ ������, ������ ����� ������ ������������.

\ ��� ���� ����������� ����������� ������ �� ����� ��� ������ 
\ ������. ���� ����, ������ ��� -- "�������" �����, ��� ����� �
\ �������. ���� �� ����, �� ��� ����� "����������" (�����), � 
\ ��������� ��� � ������� innerWords, ������� ��� ������ �����������
\ ���������� "��������" ����� ����� �����. ������ � ���������������
\ �������� ��� "����������" � "�������" ����.

\ ������� ��� ��� ��� ����� ������ "����������" ������ ������,
\ ����� � ������ ���� ������ ����������� ������ ����� �����������
\ � ��� ��������� ���������� (������� ���� �����������) ����� 
\ ����������� ��������-���������� ���.

\ ������, ��� ������ �������� ����� ��� �� ����� ��������... ��� �
\ ���� �����-�� ������ ����������, ������-������ ����� ��������
\ �������� "�� ����� ��������" (�)...

\ ������: ��������, ����� ����������������� ���������� ����� ������
\ ����� �����... ��������, ������ # ������� ������ (���� �� ����������
\ �������������, �� ������-���-������...).

\ �����������. ���� � �� ���������� ������� � �������, ��� ���
\ � ���� �������������� ��� ��� control-flow ������������� ������
\ ���������� ����� ���� ������ ������������

\ TODO: ������� ����������� ��������� ����������� ����� �������
\ TODO: ������� �������� ������������� ����������� ���� SPF � Photon'�
\ TODO: ����� �� ��������� WARNING ?
\ TODO: ������� ���������� �������� innerWords ��� ����� ������ ������
\ ��-�� ����� ������ ����� �� ����� ���� ������ ������ (���� �������,
\ �� ����� �������� � �������). ���������� �� ���?..

REQUIRE >L ~profit/lib/lstack.f
REQUIRE NOT ~profit/lib/logic.f
REQUIRE FOR ~profit/lib/for-next.f
REQUIRE cascaded ~profit/lib/colorForth/cascaded.f


MODULE: photon

40 CONSTANT maxTabs
CREATE tabsArr \ ������ �������� ���������
maxTabs CELLS ALLOT

: clearTabs  tabsArr maxTabs CELLS OVER + SWAP DO
['] NOOP I ! \ ��� ������ ��������, �.�. ������� ��������
CELL +LOOP ;
clearTabs

: flushTabs ( i -- )
CELLS tabsArr +  tabsArr maxTabs CELLS +  ( tabsArr[i] end )
BEGIN
2DUP <= WHILE
DUP @ EXECUTE
['] NOOP OVER !
CELL-
REPEAT
2DROP ;

: setTab ( xt i -- )  CELLS tabsArr + ! ;

: OnTabulation ( -- flag ) GetChar SWAP 9 = AND ;
: OnBlank ( -- flag ) EndOfChunk ;

VARIABLE curTab
curTab 0!

: tabsCount ( -- n ) 0  BEGIN OnTabulation WHILE 1+  1 >IN +! REPEAT ;

: control-flow ( xt-before xt-after -- )
\ ����������: ( -- xt-after )
CREATE IMMEDIATE
SWAP , ,
DOES> [COMPILE] \ 2@ EXECUTE curTab @ setTab ;

EXPORT

:NONAME [COMPILE] DO >L >L  ;
:NONAME L> L> [COMPILE] LOOP ;
control-flow do

:NONAME [COMPILE] FOR >L ;
:NONAME L> [COMPILE] NEXT ;
control-flow for


:NONAME [COMPILE] IF DROP >L ;
:NONAME L> 1 [COMPILE] THEN ;
control-flow if

:NONAME HERE 5 - C@ 0xE8 = IF 0xE9 HERE 5 - C! \ �������� CALL �� JMP
ELSE RET, \ ��� ������� EXIT
THEN ; 
:NONAME ;
control-flow return



ALSO cascaded
\ ����� ��������� ����������� ���������� ��������� ���������
\ �� ���������

NEW: photonWords
\ ������� ����� ������� ��� ���� Photon'�
PREVIOUS

DEFINITIONS

ALSO cascaded NEW: innerWords
\ ������� ������� ��� "����������" ���� (�� ������ �� ������� macro,
\ ��� ����� ��� � ���� macro ���)
PREVIOUS

' innerWords >BODY @ CONSTANT innerWid

VARIABLE savedWid

: saveWid   GET-CURRENT DUP innerWid <> IF savedWid ! ELSE DROP THEN ;
: restoreWid  savedWid @ SET-CURRENT ;

{{ dontHide \ ����� ���������� ������ :

:NONAME ( -- )
OnBlank        IF innerWid FORGET-ALL  restoreWid  EXIT THEN
OnTabulation   IF tabsCount DUP curTab ! flushTabs [COMPILE] ] INTERPRET_ EXIT THEN
OnDelimiter    IF [COMPILE] [ INTERPRET_ EXIT THEN
[COMPILE] : \ ��������� �� ������� dontHide
saveWid
innerWid SET-CURRENT
[COMPILE] \ ;
CONSTANT photonInterpreter \ xt ������ ��������������
}}

EXPORT

: startPhoton
ALSO photonWords DEFINITIONS \ �������� ��������� �����������, �������� �������
saveWid  ALSO innerWords \ ������� �����
photonInterpreter &INTERPRET ! \ �������� ����������� �������������
;

;MODULE


/TEST
REQUIRE SEE lib/ext/disasm.f
startPhoton
 \ ˸���� ��������� ���� ���� ������������...
 \ ������������ ����... ���� ������������... 
 \ � ������� ����-�����!..
 \ ====================== ����� ���������� ��� =====================

2x2.
	2 2 * . return      �������� �������� ��� ����� ���� control-flow ����� ������ �� ��� ������...

 CR .( 2x2. ) 2x2.


test
	DUP 2 MOD 0= if    ׸���� ����� �������, �������� -- ����������
			DUP .
	DROP
	return

 CR .( 1 test ) 1 test
 CR .( 2 test ) 2 test

5stars ( -- )                   ���������� ���� ��������
	5 for			��������� 5 ���
		." *"
	return

 CR .( 5stars ) 5stars


1-10. ( -- )                    ���������� ����� �� 1 �� 10-�
	10 0 do			���� �� ������ �� ������
		I 2 MOD 0= if	׸�-�����
				I .
	return

 CR .( 1-10. ) 1-10.

 \ ����������� �������:
fact ( n -- fact(n)
	?DUP 0= if
		1 return
	DUP 1- fact * return

 CR 5 DUP .  .( fact=) fact .

 \ ��������� �� �����. ���� � colorForth'�� ����� 
 \ ����������� � ��������� if'� (���� ��� else),
 \ ��������� ����������� (��� �� -- GOTO) �
 \ ��������� ����������� (��� �� -- �����).
 \ ������ ����� � �������...

fact ( n -- fact(n)
	1 SWAP                \  ������ ����������� �� ���� ���������� �������
$0 ( acc n )                  �����
	?DUP 0= if            ������� ������ "��������" (�� �� ������� ������ �� �����)
		return
	TUCK * SWAP 1-
	$0 return             ��� GOTO $0 , ��-����

 SEE fact

 CR 6 DUP .  .( fact=) fact .

array                DOES>-�������� ��� ��������
	R>
	return

Arr ( -- arr )       �������, ��� ��������� � colorForth'�� ��� DOES>
	array  \ <-- ��� � ���� DOES>-��������
 11 , 22 , 33 , 44 , 55 ,

 \ �� ����: ...-CODE-�������� �� ����������� �������

getArr ( i -- arr[i] )
	1- CELLS  Arr +
	return

 CR 4 DUP . .( arr=) getArr @ .