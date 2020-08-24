\ Dmitry Yakimov 13.03.2000
\ ftech@tula.net

\ ���� ����� �� Win32Forth
\ ������ ������ ������:
\ 4 - ��������� �� ���������� ����
\ n - ������ ����
\ ������ ������������ ������ ����������, �������� �����
\ ���������� ����


\ ����� ���������� ����� ����� ����������� ����� �������������� ������
\ ��������, 
\ LINK,
\ 123 ,

: LINK,     ( list -- )    \ �������������� ����� � ���������� �����
         HERE  OVER @ ,  SWAP !  ;


\ �� ������ ���� ������ ����� - ��������� �� ����������� �����                
: DO-LIST ( list -- )
                BEGIN   @ ?DUP
                WHILE   DUP CELL+ @ EXECUTE
                REPEAT  ;

\ ��������� xt � ���������� `��������� �� ������ �����`
\ ���� xt ��������� -1 �� ����������� ��������, ���� 0 - ����������
: ITERATE-LIST ( list xt -- )
    >R
    BEGIN @ ?DUP
    WHILE DUP CELL+ R@ EXECUTE IF R> 2DROP EXIT THEN
    REPEAT RDROP
;

\ ���������� �������� ���� xt �������� ��������� �� ������
: ITERATE-LIST2 ( list xt -- f )
    >R
    BEGIN @ ?DUP
    WHILE DUP CELL+ R@ 
          ROT >R
          EXECUTE IF 2R> 2DROP TRUE EXIT 
                  ELSE R>
                  THEN
    REPEAT RDROP 0
;

VARIABLE CHAINS

\ �������������� ���������� CHAINS � 4 + � DOES> ��� ����, �����
\ ��� CHAINS ���� ����� �� ������� ���������, ��� � ��� ������
\ �������

: CHAIN ( "name" -- )
   CREATE
       CHAINS LINK,    
       0 ,
   DOES> CELL+
;

\ ������� ����� ������, �� ��������� ����������
: INHERITH-CHAIN ( list "name" -- )
   CREATE
       CHAINS LINK,    
       , ['] NOOP ,
   DOES> CELL+
;

\ sas

: ADD-LINK ( list "name" -- )
    LINK,
    ' ,
;

(
CHAIN test

: t1 2 . ;
: t2 3 . ;


test ADD-LINK t1
test ADD-LINK t2
test DO-LIST )