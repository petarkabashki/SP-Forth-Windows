USER CREATING-CLASS
USER WAS-CURRENT
USER ALSO-FOR-ONE
USER SIZE-ADDR

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

: ALSO-IT ( wid )
  ALSO
  CONTEXT !
  1 ALSO-FOR-ONE !
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
  SP@ SIZE-ADDR !
  DOES>
  ?PREVIOUS
  @ ALSO-IT
;

: VREST
  PREVIOUS
  WAS-CURRENT @ CURRENT !
;

: MYSIZE
  SIZE-ADDR @ @ POSTPONE LITERAL
; IMMEDIATE

: ;CLASS ( size -- )
\ �����襭�� ���ᠭ�� �����
  ?PREVIOUS
  CREATING-CLASS @ CELL+ !
  VREST
;

: >SIZEOF
  >BODY CELL+ ;

: SIZEOF
\ ��।������ ࠧ��� ������� ������� �����
  ' >SIZEOF @ POSTPONE LITERAL
; IMMEDIATE

: >WIDOF
  >BODY ;


: WIDOF
\ wid ᫮���� �����
  ' >WIDOF @ POSTPONE LITERAL
; IMMEDIATE

: INST
  ' >SIZEOF @ CREATE HERE OVER ALLOT SWAP ERASE
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
