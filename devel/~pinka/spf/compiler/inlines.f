\ 18.Feb.2007 Sun 18:31
\ $Id: inlines.f,v 1.9 2008/08/13 23:33:06 ruv Exp $
\ see also src/compiler/spf_inline.f
\ NON-OPT-WL contains five words: EXECUTE  ?DUP  R>  >R  RDROP


REQUIRE AsQName   ~pinka/samples/2006/syntax/qname.f \ ������� ����������� ����� � ���� `abc

MODULE: fix-inlines-support

REQUIRE BIND-NODE ~pinka/samples/2006/lib/plain-list.f 

VARIABLE h-compilers

EXPORT

: ADVICE-COMPILER ( xt-compiler xt -- )
  0 , HERE SWAP , SWAP , h-compilers BIND-NODE
;
: GET-COMPILER? ( xt -- xt-compiler true | xt false )
  DUP h-compilers FIND-NODE IF NIP CELL+ @ TRUE EXIT THEN FALSE
;
\ ��, ��� ��� :)  � �� ���� ������� �������������� ����� � ������ ���������.
\ -----

: COMPILE(?DUP)
  HERE TO :-SET ['] C-?DUP  INLINE, HERE TO :-SET \ ����� ��� � THEN
;
: COMPILE(EXECUTE)
  ['] C-EXECUTE INLINE,
;

' COMPILE(?DUP)         ' ?DUP    ADVICE-COMPILER
' COMPILE(EXECUTE)      ' EXECUTE ADVICE-COMPILER
`RDROP   SFIND 0= THROW ' RDROP   ADVICE-COMPILER
`R>      SFIND 0= THROW ' R>      ADVICE-COMPILER
`>R      SFIND 0= THROW ' >R      ADVICE-COMPILER

\ hint: ' (���) ���� c NON-OPT-WL �� �������, 
\ ������� ����� ����� ����������� ����� SFIND

\ I-NATIVE �� ���� � NON-OPT-WL, � ������ �����
\ �������� ����������� ��� ��� ���� �� ������� FORTH:

' COMPILE(?DUP)         `?DUP    SFIND 0= THROW ADVICE-COMPILER
' COMPILE(EXECUTE)      `EXECUTE SFIND 0= THROW ADVICE-COMPILER

\ "���� ����" �����������:
`RDROP   SFIND 0= THROW  DUP  ADVICE-COMPILER
`R>      SFIND 0= THROW  DUP  ADVICE-COMPILER
`>R      SFIND 0= THROW  DUP  ADVICE-COMPILER


\ ��������-�������� � ������ immediate
\ -- �� � ��� ���� ����������� ����������,
\ � immediate -- ����� �� ������� � forthml
WARNING @ WARNING 0!
`CHARS  SFIND DUP 0= THROW NIP 1 = [IF] : CHARS  ; [THEN]
`>CHARS SFIND DUP 0= THROW NIP 1 = [IF] : >CHARS ; [THEN]
WARNING !


\ ��� ����, �������������� � ������ ����� ���������, ������ ������ ��������� �����������.
\ ���������� ����������� ���������� ��� ����� "2R>", ����� �������� ������ ���
\ ��� ���� ���� ��� ���������� ��������� ����������� ("?C-JMP").

: COMPILE(2R>)
  ['] 2R> COMPILE,
  HERE TO :-SET
;

' COMPILE(2R>) ' 2R> ADVICE-COMPILER

;MODULE
