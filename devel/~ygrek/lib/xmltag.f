\ $Id: xmltag.f,v 1.4 2008/12/12 14:27:25 ygreks Exp $
\
\ ����� XML ����� ������������
\
\ �� ������ ���� ��������� ����������� ���, ��� ������ - �����������.

REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE STR@ ~ac/lib/str5.f
REQUIRE /TEST ~profit/lib/testing.f
REQUIRE list-ext ~ygrek/lib/list/ext.f
REQUIRE list-make ~ygrek/lib/list/make.f
REQUIRE XMLSAFE ~ygrek/lib/xmlsafe.f

\ : << POSTPONE START{ ; IMMEDIATE
\ : >> POSTPONE }EMERGE ; IMMEDIATE
\ : quote [CHAR] " EMIT ;
\ : enquote-> PRO quote CONT quote ;

MODULE: xmltag

USER indent

: indent_spaces indent @ SPACES ;

{{ list
: attributes ( l -- )
  LAMBDA{ SPACE DUP car STYPE ." =" [CHAR] " EMIT DUP cdar XMLSAFE::STYPE [CHAR] " EMIT free } 
  free-with ;
}}

: prepare-tag ( attr-l a u -- ) CR indent_spaces ." <" TYPE attributes ;

EXPORT

\ open tag with attributes, close tag when backtracking
: atag ( attr-l a u --> \ <-- )
   PRO
   BACK " </{s}>" STYPE TRACKING
   2RESTB
   prepare-tag [CHAR] > EMIT
   indent KEEP
   indent 1+!
   CONT ;

\ open tag, close on backtracking
: tag ( a u --> \ <-- ) PRO list::nil -ROT atag CONT ;

\ emit closed tag with attributes
: /atag ( attr-l a u -- ) prepare-tag ." />" ;

\ emit closed tag
: /tag ( a u -- ) list::nil -ROT /atag ;

;MODULE

: PARSE-SLITERAL PARSE-NAME POSTPONE SLITERAL ;

: atag: PARSE-SLITERAL POSTPONE atag ; IMMEDIATE
: tag: PARSE-SLITERAL POSTPONE tag ; IMMEDIATE
: /atag: PARSE-SLITERAL POSTPONE /atag ; IMMEDIATE
: /tag: PARSE-SLITERAL POSTPONE /tag ; IMMEDIATE

\ handy shortcut for name value pair
\ `value `name $$
: $$ %[ >STR % >STR % ]% % ;

/TEST \ Example

0 VALUE counter

: inner=> PRO 
   3 0 DO
   counter " inner{n}" DUP STR@ CONT STRFREE
   counter 1+ TO counter 
   LOOP
;

: sub=> PRO S" sub1" CONT S" sub2" CONT ;

: test1
   S" start" tag
     sub=> tag inner=> tag " {counter DUP *}" STYPE ;

REQUIRE AsQName ~pinka/samples/2006/syntax/qname.f

: test2
   `html tag
   START{
     `head tag
     `title tag
     S" hello world!" TYPE
   }EMERGE
   `body tag
   `p tag
   S" Test" TYPE ;

test1
CR
test2

\EOF

������ S" a" tag S" b" tag S" c" tag ����������� ��������� ���� 
 <a><b><c></c></b></a>
����� �������� ���� �� ����� ������ �� ���� ���������� � ������� *> <*> <* ��� PRO CONT 
 S" a" tag PRO S" b" tag CONT S" c" CONT
���
 S" a" tag *> S" b" tag <*> S" c" <*
����
 <a><b></b><c></c></a> 

��� ���� ����� ���������� ������� ������� ����� ����� ������������ START{ }EMERGE
