\ 2008-04-16 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ 㤢����� 㭨������ ��� ��ப�
\ �襭�� ����窨 ��� ������� http://fforum.winglion.ru/viewtopic.php?t=1228

\ �⮡� �� ��������� ������ ����:
\ �८�ࠧ����� ᨬ��� � ����
: >CIPHER ( c --> u|-1 )
          DUP [CHAR] 0 [CHAR] : WITHIN IF 48 - EXIT THEN
          DUP [CHAR] A [CHAR] [ WITHIN IF 55 - EXIT THEN
          DUP [CHAR] a [CHAR] { WITHIN IF 87 - EXIT THEN
          DROP -1 ;

\ �८�ࠧ����� �᫮ � ᨬ��� �
\ �᫮ �� ������ �ॢ���� ���祭�� ��室�饥�� � BASE
: >DIGIT ( u --> char ) DUP 0x09 > IF 7 + THEN 0x30 + ;

\ ----------------------------------------------------------------------------------
        USER-VALUE digits \ ����� ᯨ᪠ ���� �᫮

\ ������ ���� 㪠������ ���� � ���� ��� ��� ���
: m&m ( char --> u u ) >CIPHER 1 SWAP LSHIFT digits ;

\ ᪠��஢��� ��ப� ��� (�������� � ᨬ�����) ᮡ���� ����⨪�
: scan ( asc # --> )
       OVER + SWAP
       BEGIN 2DUP <> WHILE
             DUP C@ m&m XOR TO digits
         1 +
       REPEAT 2DROP ;

\ �८�ࠧ������ ��室��� ��ப� ᮣ��᭮ ��
: transf ( asc # --> asc # )
         <# HOLDS
            0 digits 0x3FF AND
            BEGIN DUP WHILE
                  DUP 1 AND IF OVER >DIGIT HOLD THEN
              2/ SWAP 1 + SWAP
            REPEAT
          #> ;

\ ᮡ�⢥���, ������� ᫮��
: sample ( asc # --> )
         0 TO digits
         2DUP scan transf
         TYPE ;