USER CREATING-CLASS
USER WAS-CURRENT
USER ALSO-FOR-ONE

\ ===============  ���ᠭ�� ����ᮢ  =================

: ?PREVIOUS
  ALSO-FOR-ONE @ IF
    PREVIOUS
    ALSO-FOR-ONE 0!
  THEN
;

: |CLASS
  ?PREVIOUS
; IMMEDIATE

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
  ?PREVIOUS
  ALSO
  @ CONTEXT !
  1 ALSO-FOR-ONE !
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
  ?PREVIOUS
  ' EXECUTE
  ALSO-FOR-ONE 0!
; IMMEDIATE

: ENDWITH
  ?PREVIOUS
  PREVIOUS
; IMMEDIATE

\ ======================  ��᫥�������  ========================

: CHILD: ( -- size )
  ' >BODY ( parent )
  CLASS: SWAP ( size parent )
  DUP @ @
  CREATING-CLASS @ @ !
  CELL+ @ +
;
