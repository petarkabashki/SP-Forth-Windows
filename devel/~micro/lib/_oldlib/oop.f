USER CREATING-CLASS
USER WAS-CURRENT

\ ===============  ���ᠭ�� ����ᮢ  =================

: INTERPRET-METHOD ( wid -- )
\ ���������� ��� �ᯮ���� ᫮�� �� ᫮���� wid
 NextWord ROT
  SEARCH-WORDLIST IF
    STATE @ IF
      COMPILE,
    ELSE
      EXECUTE
    THEN
  ELSE
    ABORT" Unknown field or method."
  THEN
;

: CLASS: ( -- addr )
\ ������� �����. ����� - ᫮�� ⨯� CREATE DOES>. � ���� ��ࠬ��஢ 2 CELL-�:
\ wid ᫮���� � ࠧ��� ��������. ����� ����� �ਧ��� IMMEDIATE.
  CURRENT @ WAS-CURRENT !
  WORDLIST
  CREATE IMMEDIATE
  HERE CREATING-CLASS !
  DUP ,
  0 ,
  ALSO CONTEXT ! DEFINITIONS
  DOES>
  @ INTERPRET-METHOD
;

: ;CLASS ( addr -- )
\ �����襭�� ���ᠭ�� �����
  PREVIOUS
  WAS-CURRENT @ CURRENT !
;

: SIZEOF
\ ��।������ ࠧ��� ������� ������� �����
  ' >BODY CELL+ @
;

: WIDOF
\ wid ᫮���� �����
  ' >BODY @
;

: INST
  SIZEOF CREATE HERE OVER ALLOT SWAP ERASE
;

\ ================  ������� ����� �� 㬮�砭��  =================

: WITH
  ' >BODY @ ALSO CONTEXT !
; IMMEDIATE

: ENDWITH
  PREVIOUS
; IMMEDIATE

\ =================  ���ᠭ�� �����  ====================

: FIELDS
  0
  BEGIN
    REFILL 0= ABORT" Structure not closed by ';'"
    NextWord S" ;" COMPARE
  WHILE
    INTERPRET
    0 >IN ! --
  REPEAT
  CREATING-CLASS @ CELL+ +!
;

\ ============  ���ᠭ�� ����� �������, ��� ��⮤��  ===============

: STRUCT:
  CLASS:
  FIELDS
  ;CLASS
;

\ ======================  ��᫥�������  ========================

: CHILD
  ' >BODY ( parent )
  CLASS: ( parent )
  DUP CELL+ @
  CREATING-CLASS @ CELL+ !
  @ @
  CREATING-CLASS @ @ !
;

\ ==================  ���ᠭ�� ��ꥪ�  ==================

: OBJECT
  ' >BODY
  CREATE
  DUP @ , CELL+ @ ALLOT
  DOES>
  DUP CELL+ SWAP @
  INTERPRET-METHOD
;

\ ======================  Debug  =========================

: SHOWCLASS
  >IN @
  WIDOF NLIST
  >IN !
  SIZEOF ." Size=" .
;
