\ ��������� ������� ������ ����� �������, ���
\ �������� ������ ����� ��� ����������� �������� �,
\ ���� ������� ��������� � ������ �
\ ���� �� ������������, ������� ��������� ������� �� �����

: WITHOUT-QUOTES ( addr u c -- addr2 u2 )
   >R
   DUP
   IF
     OVER C@ R@ =
     IF
        1- SWAP 1+ SWAP
     THEN
     DUP IF
            2DUP + 1- C@ R@ =
            IF
              1-
            THEN
          THEN
   THEN
   R> DROP
;

VARIABLE PARAM-#TIB
USER-VALUE PARAM-TIB
USER PARAM->IN

: INIT-PARAM
   PARAM->IN 0!
   GetCommandLineA ASCIIZ>
   PARAM-#TIB !
   TO PARAM-TIB
;

\ ���� PARAM-TIB ����, ������������������� ���.
\ ���������� ��������� �������� � ��������� ������.
\ ������� �������� � user ���������� PARAM->IN.
\ �������� ����� �� ���� ���������� 0, ����� Windows ������������
\ ��������� ����� ������.
\ ���� �������� �������� � �������, ���� ���� � ��� ���� �������,
\ ����� ���������� ����� � ��������.
\ ������ ���� NEXT-PARAM ���������� �� NextWord.
\ ������ ������� - ���� ����������� �����, �������� � ������� WITHOUT-QUOTES

: NEXT-PARAM ( -- addr u )
   PARAM-TIB 0= IF INIT-PARAM THEN
   TIB >R #TIB @ >R >IN @ >R   
   PARAM-#TIB @ #TIB !
   PARAM-TIB TO TIB
   PARAM->IN @ >IN !
   BL SKIP 0 SKIP
   TIB >IN @ + C@
   [CHAR] " = IF >IN 1+! 1 2 [CHAR] " ELSE 0 0 BL THEN
   PARSE ROT + >R SWAP - R>  \ ��������� ������� (����� ����-������ �����)
   >IN @ PARAM->IN !
   R> >IN ! R> #TIB ! R> TO TIB
   2DUP + 0 SWAP C!
;

( \ example
: run
   NEXT-PARAM TYPE CR
   NEXT-PARAM TYPE CR
   NEXT-PARAM TYPE CR   
   BYE
;

' run MAINX !
S" clparam.exe" SAVE BYE
)   