\ ForthCPU/VM emulator by WingLion 

\ ������� ������������� ����� (����������, ����� REQUIRE)
REQUIRE AT-XY ~day/common/console.f

REQUIRE ������� ~profit/lib/chartable.f

BASE @ HEX \ �������� ������� ��������� ����� ���������

CLS 0 0 AT-XY 

\ �������� ����� � �� ������� ��������� 3-4 �������! 
\ ������ � SPF ��� ����� H. - �� ���� 

: H. BASE @ SWAP HEX 
  S>D <# # # # # # # # # #> TYPE SPACE 
  BASE ! 
; 

: FALSE! FALSE SWAP ! ; 
: TRUE! TRUE SWAP ! ; 
\ : 1+! 1 +! ; \ ��� ������� � ��� ���� 
: 1-! -1 +! ; \ � ���� � SPF �� ��������� 

\ *********************** ��, ������ � ����� ���������� ��� ����������� 
\ ������ ����������� ��� �� 

\ ���������� ��������� 
1000 CONSTANT MemSize \ ������ ������ �� (� ������) 
10 CONSTANT DStS \ ������� ����� ������  (� ������) 
10 CONSTANT RStS \ ������� ����� ��������� (� ������) 

\ ����� �� 
VARIABLE PC  \ ������� ������ 
VARIABLE RAD \ ������� ������/������ 
VARIABLE CMD \ ������� ������� 
VARIABLE RADF \ ���� �������� �������������� ��� RAD 
\ TRUE - RStack -> RAD 
\ FALSE - DStack ->RAD 
VARIABLE RStF \ ���� �������� �������������� ��� RStack 
\ TRUE - PC+1 ->RStack 
\ FALSE - RAD ->RStack 

VARIABLE DStP \ ������� D-����� 
CREATE DStack DStS CELLS ALLOT \ ���� ������ 
VARIABLE DStDO \ ������� ������� ����� ������ (���. ������� �����) 

VARIABLE RStP \ ������� R-����� 
CREATE RStack RStS CELLS ALLOT \ ���� ��������� 
VARIABLE RStDO \ ������� ������� ����� ��������� (���. ������� �����) 

CREATE MEM MemSize ALLOT  \ ������ �� 
MemSize 1- CONSTANT MASK \ ������������ ������ �� 

\ **************************** 

: -1OO! 1- OVER OVER C! NIP ; 
: init_MEM 
 MEM MemSize ERASE 

\ �����-DUMP ������ �� 

 00 00 00 00  \ nop nop 
 01 10 00 00 00 \ call 0010 
 03 55 AA 00 00 \ lit AA55 
 00 00  \ nop nop 
 01 08 00 00 00 \ call 0008 

 MEM 15 + 
 15 0 DO -1OO! LOOP 

\ 10 0 DO I DUP MEM + C! LOOP 
; 

: reset PC 0! DStP 0! RStP 0! RADF FALSE! RStF TRUE! ; 

reset init_MEM 

\ **************************** 

: OUTMST \ ����� ��������� ������ � ������ 
   CR ." DataStack:" DStP @ H. 
   DStack 8 DUMP 
   CR ." RetStack:" RStP @ H. 
   RStack 8 DUMP CR 
   \ ������ 
   CR ." Memory:" CR 
   MEM 40 DUMP 
; 

: OUTSTR \ ����� ��������� ��������� 
   \ �������� 
   \   0 0 AT-XY 
   CR 
   ."  PC: " PC @ H.    \ ������� ������ 
   ."  RAD " RAD @ H.   \ ������� ������/������ 
   ."  CMD " CMD @ H.   \ ������� ������� 
   ."  DSt " DStDO @ H. \ ������� ����� ������ 
   ."  RSt " RStDO @ H. \ ������� ����� ��������� 
; 

: OUTST \ ����� ��������� �� 
\    0 0 AT-XY 
    OUTSTR 
\    OUTMST 
; 

\ **************************** 
\ ������ �� 
\ **************************** 
\ ������������ 
: PC++ PC 1+! ; 
: MPC@ MEM PC @ MASK AND + @ ; 
\ ������ ������ �� ������ �� �� ������ PC -- ���(PC) 
: MPC! MEM PC @ MASK AND + RAD @ SWAP ! ; 
\ �������� ������ �� RAD �� ������ � PC 
\ ��� ��� ����������� � ������� ������ �� 

: GetLit MPC@ PC @ 4 + PC ! ; \ �������� ������� 
: RdCMD MPC@ CMD C! PC++ ; \ ������ ������� 
\ ��� ����� ���� � �����-������ ���������� � ���. ������-������ 

\ **************************** 
\ ������ �� ������ ��������� 
\ **************************** 

: RStA RStP @ RStS 1- AND CELLS RStack + ; \ �������� ����� ������� 

: RNOP RStA @ RStDO ! RStF TRUE! ; \ ��������� ������� ����� ��������� 

: RSWAP RNOP RStF @ IF PC @ 1+ ELSE RAD @ THEN RStA ! ; 
\ �������� �������� PC+1 ��� RAD � ���� ��������� � ����. ����.������� 

: RPUSH RStP 1+! RSWAP RNOP ; 
\ �������� ����� �������� � ���� ��������� � ������� ����� ������� 

: RPOP RStP 1-! RNOP ; \ ����� �� ����� ��������� ���� �������� 

\ **************************** 
\ ������ �� ������ ������ 
\ **************************** 

: DStA RStP @ DStS 1- AND CELLS DStack + ; \ �������� ����� ������� 

: DNOP DStA @ DUP DStDO ! ; \ ��������� ������� ����� ��������� 

: DSWAP DNOP RAD @ DStA ! ; 
\ �������� �������� RAD � ���� ��������� � ������� ������ ������� 

: DPUSH DStP 1+! DSWAP DNOP ; 
\ �������� �������� RAD � ���� ��������� � ������� ����� ������� 

: DPOP DStP 1-! DNOP ; \ ����� �� ����� ��������� ���� �������� 

\ **************************** 
\ ������ � RAD 

: >RAD RADF @ IF RStDO ELSE DStDO THEN @ RAD ! RADF FALSE! ; 
: ALU>RAD ; \ ALU-�������� 
: nRAD ; \ ������ �� ������ � RAD 

\ **************************** 
\ �������-�������-������� 
\ **************************** 

: advance  RdCMD RNOP DNOP nRAD ; \ ������� � ��������� �������
: call MPC@ PC++ RPUSH PC ! ;
: if GetLit RAD @ IF PC ! ELSE PC++ THEN ;
: lit DPUSH GetLit RAD ! ;
: ret RPOP RStDO @ PC ! ;

\ ��������������� ���������� ������ ����� ������� 
10 ������� CMD-TAB
\ 0 - nop 
0 ���������: ; 
\ 1 - call 
1 ���������: call ;
\ 2 - if 
2 ���������: if ;
\ 3 - lit 
3 ���������: lit ;
\ 4 - >R 
4 ���������: RStF FALSE! RPUSH DPOP RADF FALSE! >RAD  ; 
\ 5 - R> 
5 ���������: RPOP DPUSH RADF TRUE! >RAD ; 
\ 6 - ret 
6 ���������:  ret ;
\ 7 - dup 
7 ���������: DPUSH >RAD ; 
\ 8 - drop 
8 ���������: DPOP >RAD ; 
\ 9 - over 
9 ���������: DPOP DSWAP >RAD DPUSH DSWAP >RAD ; 
\ A - swap 
A ���������: DSWAP >RAD ; 
\ B - pre: 
B ���������: ;
\ C - user: 
C ���������: ;
\ D - sys: 
D ���������: ; 
\ E - fetch ( @ ) 
E ���������: 
  RPUSH RAD @ PC ! MPC@ RAD ! ret ; 
\ F - store ( ! ) 
F ���������: 
  RPUSH RAD @ PC ! DPOP >RAD MPC! ret ; 

\ ****************************** 

: CMD@  CMD @ 0F AND ;  \ ������ ������� ������� 

: STEP CMD@ CMD-TAB advance ;

\ ������� ���� 
: pp CLS 
  0 0 AT-XY  S" [ESC] - �����" TYPE 
  OUTMST CR 
  BEGIN 100 PAUSE  OUTST STEP KEY? IF KEY 1B = IF EXIT THEN THEN AGAIN ; 


BASE ! \ ��������������� ������� ���������

pp 

\ 1000 PAUSE

\ BYE