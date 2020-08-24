\ 12-12-200 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������� � �������� �� ������: http://fforum.winglion.ru/viewtopic.php?t=1068

 REQUIRE TILL devel\~moleg\lib\util\for-next.f

\ ������� ���������� ��� � ����������� ������
: bits/cell ( --> u ) 0 -1 BEGIN TUCK WHILE 1+ SWAP 2* REPEAT NIP ;

        0 VALUE buffer \ ����� �����, ��� �������� �������������� ������

\ ��������� ������ ��� ������ � ��� �������������
bits/cell 4 / 1 SWAP LSHIFT CELLS CELL + ALLOCATE THROW DUP TO buffer 0!

\ ��������� ����� �������
: aCount ( addr --> addr # ) DUP CELL + SWAP @ ;

\ ��������� �������� � �����
: ->buf ( u --> )
        buffer aCount + !
        CELL buffer +! ;

\ ��������� �������� �������� u � ��������� �������, �������� ����� um
: increment ( um u --> um u++ ) OVER INVERT OR 1 + OVER AND ;

\ ����� ��� ��������� ���������� ��� ������ ����� um
\ ������� ����� � ����� ������������� �������
: combs ( um --> addr # )
        0 buffer !
        0 BEGIN DUP ->buf      \ ��������� ��������� � �����
                2DUP <> WHILE  \ ���� �� ��������� ������ �����
                increment      \ ��������� �������� ��������
          REPEAT 2DROP
        buffer aCount ;

\EOF
: ~combs buffer DUP @ CELL / FOR CELL + DUP @ . SPACE TILL DROP ;