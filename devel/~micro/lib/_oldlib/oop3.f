USER CREATING-CLASS
WORDLIST CONSTANT CLASS-DEFINITIONS
ALSO CLASS-DEFINITIONS CONTEXT !
CURRENT @ CLASS-DEFINITIONS CURRENT !

: CREATE-PROTOTYPE ( "<method>" -- )
  >IN @
  CREATE
  >IN !
  NextWord DUP 2+ C,
  S" m_" HERE SWAP MOVE
  HERE SWAP MOVE
  DOES> ( class name )
  SWAP >CLASSWID ALSO CONTEXT !
  COUNT SFIND ?DUP IF
    STATE @ =
    IF COMPILE, ELSE EXECUTE THEN
  ELSE
    PREVIOUS
    ABORT" Method not found"
  THEN
  PREVIOUS
;

: ?CREATE-PROTOTYPE ( "<method>" -- )
  >IN @
  NextWord
  SFIND
  IF
    DROP
  ELSE
    2DROP
    >IN !
    CREATE-PROTOTYPE
  THEN
;

: CREATE-METHOD ( "<method>" -- )
  ?CREATE-PROTOTYPE
;


: --

;

CURRENT !
PREVIOUS

: >CLASSWID
;

: >CLASSSIZE
  CELL+
;

: CLASS: ( -- size )
\ ������� �����. ����� - ᫮�� ⨯� CREATE DOES>. � ���� ��ࠬ��஢ 2 CELL-�:
\ wid ᫮���� � ࠧ��� ��������. ����� ����� �ਧ��� IMMEDIATE.
  WORDLIST
  CREATE IMMEDIATE
  HERE CREATING-CLASS !
  ,
  0 ,
  0
  ALSO CLASS-DEFINITIONS CONTEXT !
;

: ;CLASS ( size -- )
\ �����襭�� ���ᠭ�� �����
  CREATING-CLASS @ CELL+ !
  PREVIOUS
;

