( 02.08.1999 ������� �. )

( ���������� ��-����� ��������� �������� ��������� �� ���������������
  ��� SPF �����.
  
  REQUIRE �����_��_���������� ~�����/����/�/����������
  ���
  S" �����_��_����������" S" ~�����/����/�/����������" REQUIRED

  ������������������. ������� require �������� ��������� ����������
  �� ��������� ����, ������ ��� ������ ����� � ����������. ������ ���
  ������ ���������. � ������ ������� �������� ������� ��������� ��
  ���� LocalLibPath~�����/����/�/����������. � ������ ������� - ������
  ����������� [� ������������ ��������] WebLibPath~�����/����/�/����������
  �� ��� ����������� ���� �� ����������� [��� �� ������, �� �������� �
  ������ �� ����� ������, ��� ������� ���������� ��������� - � ���� �� 
  ����� :^]
)

CREATE LocalLibPath C" e:\eserv2-forth\forth\wwwroot\" ",
CREATE WebLibPath   C" http://www.forth.org.ru/" ",

: FindWord ( addr u -- 0 | xt 1 | xt -1 )
  DUP HERE C! HERE 1+ SWAP MOVE HERE FIND  \ �� � ��������� ��� "c-addr" ;)
  ?DUP IF EXIT THEN
  DROP 0
;
: LibName ( addr u -- addr2 u2 )
  DUP >R PAD SWAP MOVE
  PAD R@ + SWAP R> OVER + >R MOVE
  PAD R@ + 0! PAD R>
;
: LocalLibName ( addr u -- addr2 u2 )
  LocalLibPath COUNT LibName
;
: WebLibName ( addr u -- addr2 u2 )
  WebLibPath COUNT LibName
;
: WEB-INCLUDED ( addr u -- )
  TYPE ." - WebIncluded is'n implemented." CR -5002 THROW
;
: IncludeLib ( addr u -- ... )
  2>R
  2R@ + 0 SWAP C!
  2R@              ['] INCLUDED CATCH 0= IF 2R> 2DROP EXIT THEN 
  \ ���������� ������� ����
  2DROP \ ��� �� ��� ����������, � ����� ����� "������������" � CATCH �����
  2R@ LocalLibName ['] INCLUDED CATCH 0= IF 2R> 2DROP EXIT THEN
  2DROP
  2R@ WebLibName   ['] WEB-INCLUDED CATCH 0= IF 2R> 2DROP EXIT THEN
  2DROP
  2R> TYPE ." - can't find library." -5001 THROW
;
: REQUIRED ( waddr wu laddr lu -- )
  2SWAP FindWord
  IF DROP 2DROP EXIT
  ELSE IncludeLib THEN
;
: REQUIRE ( "word" "libpath" -- )
  BL SKIP BL PARSE
  BL SKIP BL PARSE
  REQUIRED
;

\ �������:

\ REQUIRE RG_OpenKey /~ac/lib/win/registry.f

\ S" RG_OpenKey" S" /~ac/lib/win/registry.f" REQUIRED