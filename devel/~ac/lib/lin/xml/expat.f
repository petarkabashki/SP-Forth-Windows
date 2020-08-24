\ $Id: expat.f,v 1.6 2008/07/21 11:28:15 spf Exp $
\ ���������� ����������� ���������� XML-������ �� ���� SAX-���������� Expat
\ ��� ���������� � ������ ��������� libexpat.dll (������������� � ������� 2.0)
\ ������� ������������� - � ����� �����.

\ �������� ����� - XML_NewEvaluator � XML_Evaluate.
\ XML_Evaluate �������� ������� ��������� ������ xml-�����. ������ �����������
\ ��������� ����� - �������� �������, ��� �������� ��������� � ������� �����,
\ ����� ����� ��������� � ������� �����, ����������� � ������� ��������� �����
\ ���� xml, � .CDATA ��� ��������� ������. ��� �������� ���� ���������� �����
\ .CLOSE �������� ���������. �.�. ��� ��������� �������� xml-��������� ����������
\ ������� ��������������� ��������� ��������� � �����, � "���������" XML � 
\ ���� ���������.

\ ��� ���������� ��������� ������������ ���� �� ���� ����������� ��� ��������,
\ �� ��������� �������� ����� �����, ��� � xml.f. ����� ����� �������� �������
\ � ��������� �������� � ������������/�����������, � ������� ���������� 
\ ���������������� ��������� xml-���������. � � ��������� ������� (����� �������
\ XML-�����, �� ������������ � ������, ��� "�������������" ��������� ���� XMPP
\ ���������) ���� SAX-����� �������� ������������ ���������� ��������.


WARNING @ WARNING 0!
REQUIRE SO            ~ac/lib/ns/so-xt.f
REQUIRE STR@          ~ac/lib/str5.f
WARNING !

ALSO SO NEW: libexpat.dll
ALSO SO NEW: libexpat.so

\ ===== ����������� �����, ������������ ������ �������� "�����������" XML ====

USER XML_Nest

: XML_DumpAttrs ( addr -- )
  BEGIN
    DUP @
  WHILE
\    DUP @ ASCIIZ> ." : " TYPE ."  S" [CHAR] " EMIT SPACE CELL+
\    DUP @ ASCIIZ> TYPE [CHAR] " EMIT ."  ;" CR CELL+
    DUP @ ASCIIZ> ."  : " TYPE ."  ( S" [CHAR] " EMIT SPACE CELL+
    DUP @ ASCIIZ> TYPE [CHAR] " EMIT ." ) TYPE CR ; " CELL+
  REPEAT DROP
;
:NONAME ( **attrs *name *userData -- )
  TlsIndex@ >R DUP TlsIndex!
\  ." VOCABULARY " OVER ASCIIZ> 2DUP TYPE ."  ALSO " TYPE ."  DEFINITIONS" CR
  XML_Nest @ 4 * SPACES ." X{ " OVER ASCIIZ> TYPE \ CR
  XML_Nest 1+!
  2 PICK XML_DumpAttrs
  0 CR
  R> TlsIndex!
; 3 CELLS CALLBACK: XML_StartElementHandler_Gen

:NONAME ( *name *userData -- )
  TlsIndex@ >R DUP TlsIndex!
\  ." PREVIOUS DEFINITIONS ( " OVER ASCIIZ> TYPE ."  )"
  XML_Nest @ 1- XML_Nest !
  XML_Nest @ 4 * SPACES ." }X " OVER ASCIIZ> TYPE
  0 CR
  R> TlsIndex!
; 2 CELLS CALLBACK: XML_EndElementHandler_Gen

:NONAME ( len *s *userData -- )
  TlsIndex@ >R DUP TlsIndex!
\  ." :NONAME S" [CHAR] " EMIT SPACE OVER 3 PICK TYPE [CHAR] " EMIT ."  ;"
  OVER 3 PICK -TRAILING NIP 0 >
  IF
    XML_Nest @ 4 * SPACES  ." : .CDATA ( S" [CHAR] " EMIT SPACE OVER 3 PICK TYPE [CHAR] " EMIT ." ) TYPE CR ;" CR
  THEN
  0
  R> TlsIndex!
; 3 CELLS CALLBACK: XML_CharacterDataHandler_Gen

\ ===== ����������� �����, "�����������" XML ==================================

: SEARCH-ATTRIBUTE ( a u wid -- 0 | xt true ) \ ~ruv (���� �� ������������)
  { a u wid \ [ 256 ] buf }
  u 250 U> IF 0 EXIT THEN
  [CHAR] @ buf C!
  a buf CHAR+ u MOVE
  buf u CHAR+ wid SEARCH-WORDLIST
;
: XML_ExecAttrs ( addr -- )
  BEGIN
    DUP @
  WHILE
    DUP @ ASCIIZ> CONTEXT @ SEARCH-WORDLIST DUP IF DROP THEN >R CELL+
    DUP @ R@ IF ASCIIZ> R> EXECUTE ELSE R> 2DROP THEN CELL+
  REPEAT DROP
;
\ : >NAME  ( xt -- NFA )  \ ~ruv: ����������� ������� �� ����������!
\ � � ���� ������ SPF �� ��������, ������� ����� ~mak:

\ : >NAME  4 - DUP BEGIN 1- 2DUP COUNT + U< 0= UNTIL NIP ;
\ � ���������

: >NAME
  4 - DUP
  BEGIN
    1- DUP C@ 0<> DUP
    IF DROP 2DUP
      COUNT + U< 0=
    THEN
  UNTIL NIP
;

USER XML_ParseDebug

:NONAME ( **attrs *name *userData -- )
  TlsIndex@ >R DUP TlsIndex!
  S0 @ >R SP@ CELL+ CELL+ CELL+ S0 !
  OVER ASCIIZ> 
  XML_ParseDebug @ IF CR ." X{ " 2DUP TYPE SPACE THEN
  CONTEXT @ SEARCH-WORDLIST-NFA
  IF DUP NAME> SWAP ?VOC \ ������������� ��������� ���������� � ��������� ��������
     IF
       XML_ParseDebug @ IF ." found! " THEN
       ALSO EXECUTE
       2 PICK XML_ExecAttrs
     ELSE
       XML_ParseDebug @ IF ." isn't voc! " THEN
       DROP
       S" .NOTFOUND" CONTEXT @ SEARCH-WORDLIST
       IF 2 PICK ASCIIZ> ROT EXECUTE THEN
     THEN
  ELSE S" .NOTFOUND" CONTEXT @ SEARCH-WORDLIST
       IF 2 PICK ASCIIZ> ROT EXECUTE THEN
  THEN
  0
  R> S0 ! R> TlsIndex!
; 3 CELLS CALLBACK: XML_StartElementHandler

: VOC-NAME ( wid -- addr u ) \ ��� ������ ����, ���� �� ��������
  DUP FORTH-WORDLIST = IF DROP S" FORTH" EXIT THEN
  DUP CELL+ @ DUP IF NIP COUNT ELSE 2DROP S" <NONAME>" THEN
;
:NONAME ( *name *userData -- )
  TlsIndex@ >R DUP TlsIndex!
  S0 @ >R SP@ CELL+ CELL+ S0 !
  \ ����� DEPTH �������������� ���������������� �������������� �� ����� USER �� �� ����� ������ �������
  OVER ASCIIZ> CONTEXT @ VOC-NAME COMPARE 0=
  \ ���� � ������� �� �������, �� PREVIOUS ������������ ��������
  IF
    OVER ASCIIZ> S" .CLOSE" CONTEXT @ SEARCH-WORDLIST
    IF EXECUTE ELSE 2DROP THEN
    PREVIOUS
  THEN 0
  R> S0 ! R> TlsIndex!
; 2 CELLS CALLBACK: XML_EndElementHandler

:NONAME ( len *s *userData -- )
  TlsIndex@ >R DUP TlsIndex!
  S0 @ >R SP@ CELL+ CELL+ CELL+ S0 !
  OVER 3 PICK S" .CDATA" CONTEXT @ SEARCH-WORDLIST
  IF EXECUTE ELSE 2DROP THEN 0
  R> S0 ! R> TlsIndex!
; 3 CELLS CALLBACK: XML_CharacterDataHandler

\ ===== ��������� ����������� =====

: XML_NewParserGenerator { \ p -- p }
  0 1 XML_ParserCreate -> p
  ['] XML_EndElementHandler_Gen ['] XML_StartElementHandler_Gen p 3 XML_SetElementHandler DROP
  ['] XML_CharacterDataHandler_Gen p 2 XML_SetCharacterDataHandler DROP
  TlsIndex@ p 2 XML_SetUserData DROP
  p
;
: XML_DumpError { p -- }
  p 1 XML_GetErrorCode DUP >R 1 XML_ErrorString ASCIIZ> TYPE ."  ("
  p 1 XML_GetCurrentLineNumber . ." :"
  p 1 XML_GetCurrentColumnNumber . ." )" R> 7000 + THROW
;
: XML_PFree ( p -- )
  1 XML_ParserFree DROP
;
: XML_Generate { islast addr u p -- }
  islast u addr p 4 XML_Parse
  0= IF p XML_DumpError THEN
  islast IF p XML_PFree THEN \ XML_ParserReset
;
: XML_NewEvaluator { \ p -- p }
  0 1 XML_ParserCreate -> p
  ['] XML_EndElementHandler ['] XML_StartElementHandler p 3 XML_SetElementHandler DROP
  ['] XML_CharacterDataHandler p 2 XML_SetCharacterDataHandler DROP
  TlsIndex@ p 2 XML_SetUserData DROP
  p
;
: XML_Evaluate { islast addr u p -- }
  islast u addr p 4 XML_Parse
  0= IF p 1 XML_GetErrorCode 7000 + THROW THEN
  islast IF p XML_PFree THEN \ XML_ParserReset
;

\ "�������" �������� ��������
: X{ GET-CURRENT >IN @ VOCABULARY >IN ! ALSO ' EXECUTE DEFINITIONS ;
: }X PREVIOUS SET-CURRENT ;

PREVIOUS
PREVIOUS

\EOF ============== ������� ==================


\ ������ ��������� ������� ������������

: TEST_GEN
  XML_NewParserGenerator >R
  1 S" reference.html" FILE R@ XML_Generate
  RDROP
;
\ TEST_GEN

\ ������ ������ ���� src � href ��������� � ���������:

X{ img
   : src TYPE CR ;
}X

X{ a
   : href TYPE CR ;
}X

\ : .NOTFOUND ." Unknown tag:" TYPE CR ;

: TEST_EVAL
  XML_NewEvaluator >R
  1 S" reference.html" FILE R@ XML_Evaluate
  RDROP
;
TEST_EVAL

