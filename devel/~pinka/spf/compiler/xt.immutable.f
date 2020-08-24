\ Oct.2006, Feb.2007

\ ������� ���� GERM � GERM!

: CONCEIVE ( -- )
  ?CSP GERM >CS
  ALIGN HERE GERM!
;
: BIRTH ( -- xt )
  RET, GERM  CS> GERM!
  ClearJpBuff \ for OPT
  \ AT-BIRTH ( xt -- xt ) \ is event
  [DEFINED] UNUSED [IF] \ � ���� ��� ����� UNUSED
  UNUSED 250 < IF -8 THROW  THEN \ dictionary overflow
  \ ��������� � ������ �����,
  \ �.�. "��������� �����" ����� ����� � ������������� ���������.
  [THEN]
;
: MAKE-CONST ( x -- xt ) \ xt ( -- x )
  CONCEIVE LIT, BIRTH
;

\EOF
\ �������������� (� �������� ������ �����), ���� �� ������������:

: MAKE-LIT ( x -- xt ) \ xt ( -- x )
  CONCEIVE LIT, BIRTH
;
: MAKE-SLIT ( c-addr u -- xt ) \ xt ( -- c-addr2 u )
  CONCEIVE SLIT, BIRTH
;
: MAKE-SLOT ( -- xt )  \ xt ( -- addr )
  ALIGN HERE 0 , MAKE-LIT
;
