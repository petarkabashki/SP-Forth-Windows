\ 24-10-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������� � �������� ������ http://fforum.winglion.ru/index.php
\ http://fforum.winglion.ru/viewtopic.php?t=994

\ � ������� ����������� ������� (CONTEXT) ������� ����� ��� �����
\ ����, ������������ � ����� ����� (�� ���� ������� �����). C����
\ ����� ���������� �� ������ (�� ���� ������) ���� �� �����������
\ (� ����� ���������� �������).

\ ������� � ������� ����� ��������� ����� ����������
\ ���� ����� �������� ��������������� ����� ���������������� ���������� ������
: nDrop ( [ .. ] n --> ) 1 + CELLS SP@ + ( S0 @ MIN) SP! ;

\ �������� ��������� �����, � ������������ �� ������� ����� ���������
: R+ ( r: a d: b --> r: a+b ) 2R> -ROT + >R >R ;

\ �������� ��� �������, ����������� �� ��������� �������
\ ������� ���������, ��������� �� ���� ������ ������, � ����
: (comp) ( 'asc1 'asc2 --> 'asc1++ 'asc2++ flag )
         2DUP 1 1 D+
         2SWAP C@ SWAP C@ = ;

\ �������� ��� ������ ���������� �����,
\ ������ true, ���� �������� �� �����, ��� � ���� ������
: ?like ( asc1 asc2 # --> flag )
        >R BEGIN R@ WHILE
                 -1 R+
                 (comp) WHILE
             REPEAT
               BEGIN R@ WHILE   \ ����� �� �������� �� ��������� ������������
                     -1 R+
                     (comp) WHILE
                 REPEAT
                   RDROP 2DROP FALSE EXIT
               THEN
           THEN
        RDROP 2DROP TRUE ;

\ �������� �� ������� ������ �������� ��� ���������?
: ?substr ( asc1 asc2 #2 #1 --> flag )
          2DUP < IF -ROT ELSE -ROT 2SWAP THEN
          SEARCH NIP NIP ;

\ �������� ��� ������ �� ���������
: ?resemble ( asc1 # asc2 # --> flag )
            ROT 2DUP - DUP
            IF -1 2 WITHIN
               IF ?substr
                ELSE 4 nDrop FALSE
               THEN
             ELSE 2DROP ?like
            THEN ;

\ ��� ��������� ����� asc # ����� ��� ����� � ������� �����������
\ �������, ������������ �� ��������� ����� � ����� ����������
\ �������. ��������� ������� �� �����.
: similar ( asc # --> )
          CONTEXT @ @ >R
          BEGIN R@ WHILE
                2DUP R@ COUNT ?resemble
                IF R@ ID. SPACE THEN
            R> CDR >R
          REPEAT RDROP 2DROP ;

S" LOOP" similar \ ������ �������������

\ ����� � ������� ����������� ������� ��� ������� �����
\ �� ���� ��� ������� ����� � ������� ����� ��� �����, ����������� � ����
\ �� �������, ������������ �� ���������� � ����� ���������� �������.
: alll ( --> )
       CONTEXT @ @ >R
       BEGIN R@ WHILE
             CR R@ COUNT similar
         R> CDR >R
       REPEAT RDROP ;

\ ��� ��������� ���� ������� � ������� FORTH �������� � ��������� ������
\ spf4.exe smp.f alll BYE >smp.log
