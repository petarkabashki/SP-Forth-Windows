\ 23.Dec.2006 Sat 21:59

\ from quick-swl3.f

: ENUM-VOCS ( xt -- )
\ xt ( wid -- )
  >R VOC-LIST @ BEGIN DUP WHILE
    DUP CELL+ ( a wid ) R@ ROT >R
    EXECUTE R> @
  REPEAT DROP RDROP
;

: IS-CLASS-FORTH ( wid -- flag )
  CLASS@ DUP 0= SWAP FORTH-WORDLIST = OR
;

: ENUM-VOCS-FORTH ( xt -- )
\ ������� ������ ������� ����-�������� (� ������� CLASS ����� 0 ��� FORTH-WORDLIST )
\ xt ( wid -- )
  >R VOC-LIST @ BEGIN DUP WHILE
    DUP CELL+ ( a wid ) 
    DUP IS-CLASS-FORTH
    IF R@ ROT >R  EXECUTE R> ELSE DROP THEN
    @
  REPEAT DROP RDROP
;
