REQUIRE TIME&DATE lib/include/facil.f

CREATE ����������� 31 C, 28 C, 31 C,  30 C, 31 C, 30 C,  31 C, 31 C, 30 C,  31 C, 30 C, 31 C,

: ������������������
  1- 0 MAX  0 SWAP 0 ?DO ����������� I + C@ + LOOP
;
: ����������������
  1900 - DUP 3 + 4 / SWAP 365 * +
;
: ?����������
  4 MOD 0=
;
: >���� ( ���� ����� ��� -- ����� )
  DUP ?���������� IF 29 ELSE 28 THEN ����������� 1+ C!
  ����������������
  SWAP ������������������ + +
  1+ \ ��� ������������� � MS Access ������� ���� � 30.12.1899
;
: ���������
  1+
  12 0 DO
       ����������� I + C@
       -
       DUP 0 > 0= IF ����������� I + C@ + I 1+ UNLOOP EXIT THEN
       LOOP 0
;
: ����> ( ����� -- ���� ����� ��� )
  2- DUP
  100 36525 */ ( ���-1900 )
  1900 + DUP >R
  DUP ?���������� IF 29 ELSE 28 THEN ����������� 1+ C!
  ���������������� -
  ��������� R>
;
: ����>S ( ���� -- addr u )
  ����> S>D <# # # # # [CHAR] . HOLD
               >R + R> # # [CHAR] . HOLD
               >R + R> # # #>
;
: >����:
  BL SKIP [CHAR] . WORD ?LITERAL [CHAR] . WORD ?LITERAL BL WORD ?LITERAL
  >����
;
: �����������
  TIME&DATE >���� NIP NIP NIP
;
: ����.
  ����>S TYPE
;
: �����������.
  ����������� ����.
;
: ������������.
  TIME&DATE 2DROP DROP
  0 <# [CHAR] : HOLD # # #> TYPE
  0 <# [CHAR] : HOLD # # #> TYPE
  0 <# # # #> TYPE
;
: >Date ( addr u -- date )
  TIB >R >IN @ >R #TIB @ >R
  #TIB ! >IN 0! TO TIB ['] >����: CATCH
  R> #TIB ! R> >IN ! R> TO TIB
  THROW
;