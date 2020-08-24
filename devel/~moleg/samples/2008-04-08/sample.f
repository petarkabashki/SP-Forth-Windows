\ 2008-04-08 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ �������� ���������� ���� ������
\ ������� ������� ��� �������� http://fforum.winglion.ru/viewtopic.php?t=1228

  10 CONSTANT basedigits

\ �� ���������� �������� ����
 CREATE �iphers basedigits CELLS ALLOT

\ ������� ���������� �������
: init ( --> ) �iphers basedigits CELLS ERASE ;

\ ����� ���� � �������, ��������������� �����
: cstat ( char --> ) [CHAR] 0 - CELLS �iphers + ;

\ ����������� ������
: prep ( asc # --> )
       OVER + SWAP
       BEGIN 2DUP <> WHILE
             DUP C@ cstat 1+!
           1 +
       REPEAT 2DROP ;

\ �������������� �������� ������
: transf ( asc # --> )
         OVER +
         <# BEGIN 2DUP <> WHILE 1 -
                  DUP C@ DUP HOLD
                         DUP cstat @
                         2 MOD IF DUP HOLD cstat 1+! ELSE DROP THEN
            REPEAT
          #> ;

\ ����������, ������� �����
: sample ( asc # --> ) init 2DUP prep transf TYPE ;

S" 874205257" sample CR
