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

: CLASS: ( -- size )
\ ������� �����. ����� - ᫮�� ⨯� CREATE DOES>. � ���� ��ࠬ��஢ 2 CELL-�:
\ wid ᫮���� � ࠧ��� ��������. ����� ����� �ਧ��� IMMEDIATE.
  CURRENT @ WAS-CURRENT !
  WORDLIST
  CREATE IMMEDIATE
  HERE CREATING-CLASS !
  DUP ,
  0 ,
  ALSO CONTEXT ! DEFINITIONS 0
  DOES>
  @ INTERPRET-METHOD
;

: VREST
  PREVIOUS
  WAS-CURRENT @ CURRENT !
;

: ;CLASS ( size -- )
\ �����襭�� ���ᠭ�� �����
  CREATING-CLASS @ CELL+ !
  VREST
;

: >SIZEOF
  >BODY CELL+ ;

: SIZEOF
\ ��।������ ࠧ��� ������� ������� �����
  ' >SIZEOF @
;

: >WIDOF
  >BODY ;


: WIDOF
\ wid ᫮���� �����
  ' >WIDOF @
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

\ ======================  ��᫥�������  ========================

: CHILD ( -- size )
  ' >BODY ( parent )
  CLASS: SWAP ( size parent )
  DUP @ @
  CREATING-CLASS @ @ !
  CELL+ @ +
;
