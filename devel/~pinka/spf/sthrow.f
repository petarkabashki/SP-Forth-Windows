\ 2008 

: LAST-ERROR-MSG ( -- a u )
  ER-A @ ER-U @
;
: LAST-ERROR-MSG! ( a u -- )
  ER-U ! ER-A !
;

: STHROW ( addr u -- )  ER-U ! ER-A ! -2 THROW ;

: SCATCH ( -- addr u true | false ) 
  CATCH
  DUP 0= IF EXIT THEN
  DUP -2 <> IF THROW THEN
  DROP LAST-ERROR-MSG TRUE
;

\ ����������� ����������� ������ ���� ��� ���� ����!
