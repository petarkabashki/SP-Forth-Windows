\ 10.Feb.2006 Fri 20:05 ruv
\ $Id: qname.core.f,v 1.4 2008/06/15 08:33:28 ygreks Exp $

REQUIRE /CHAR  ~pinka/samples/2005/ext/size.f
REQUIRE T-SLIT ~pinka/samples/2006/core/trans/common.f
REQUIRE TAIL   ~pinka/samples/2006/lib/head-tail.f

: I-QName ( a-text u-text -- a1 u1 true | a u false )
\ �������� ���������������� text ��� ������������� �������� ����� ��� "`name" (quoted name)
\ ���� ��� (��� ������) ��� ������.
  DUP /CHAR U> IF
    OVER C@  [CHAR] ` = IF TAIL TRUE EXIT THEN
  THEN FALSE
;
: AsQName ( a-text u-text -- i*x true | a u false )  \ T-QName
\ �������� ������������� ��� ������������� ���(������), ������������� �������� �����
  I-QName IF T-SLIT TRUE EXIT THEN
  FALSE
;
