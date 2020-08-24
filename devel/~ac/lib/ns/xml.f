( ~ac 20.08.2005
  $Id: xml.f,v 1.7 2007/08/01 09:37:22 spf Exp $

  ����������� ������� XML-������ [�� ����� ����� ��� URL] �
  �������� ������������ ����-�������. � ���������� �����, 
  ������������ ����������, �������� ����� � XML-�����  
  ������������ ����� ��������������� �����, ��� ������������� 
  ������������� XMLDOM � ������ XML-����������� API.

  �������������:
  ALSO XML_DOC NEW: http://forth.org.ru/rss.xml
  - ������� �������, ����������� � ���������� URL � �������
  �� �� ���, � ��������� ���� ������� � �������� ������.
  ����� ���������� ����� ����� ������������ ��������� ����� -
  ���� XML ������������� ���������� � ����� �� ��� ����� �����
  ������������� ���, ��� ���� �� ��� ��� "����������" ����-�������.
  ���������� ���������� ���� �������� ������� ������� ���������
  ������ �� ��������� ���� � ��������� [��� ���� �� �� ��� ���
  ��������� ����� VOCABULARY], � ���������� ����� ����� �������,
  ������� � ����. ����� ������� �������� ������:
  http://forth.org.ru/rss.xml /rss channel title
  ������� � �������� ���������� ������ ��� �� ����, ��� �
  XPath-��������� /rss/channel/title.
  ����� "@" � "." � ���� ���������� �������������� ��� ����������
  � ������ ��������� �������� "����������� �����" ��������������.

  ���������� ��� � ���������, ������� ������� � ����� �� ���������.
)

REQUIRE XML_READ_DOC_ROOT ~ac/lib/lin/xml/xml.f 
REQUIRE ForEachDirWRstr   ~ac/lib/ns/iter.f

<<: FORTH XML_NODE

: CAR { node -- node }
  node OBJ-DATA@ DUP
  IF 1stNode
     DUP node OBJ-DATA! 0= IF 0 ELSE node THEN
  THEN
;
: CDR { node -- node }
  node OBJ-DATA@ DUP 
  IF nextNode
     DUP node OBJ-DATA! 0= IF 0 ELSE node THEN 
  THEN
;
: NAME ( node -- addr u )
  OBJ-DATA@ DUP x.type @ XML_ELEMENT_NODE =
  IF
    x.name @ ASCIIZ>
  ELSE DROP S" noname" THEN
;
: ?VOC DROP TRUE ; \ OBJ-DATA@ x.children @ 0<> ;

: >WID ( node -- node )
  ALSO CONTEXT !
  CONTEXT @ OBJ-DATA@ x.children @
  VOC-CLONE CONTEXT @ OBJ-DATA!
  CONTEXT @ PREVIOUS PREVIOUS
;

: SHEADER ( addr u -- )
\ �������� xml-���� � ������ addr u � ������� xml-���� "����������"
  GET-CURRENT OBJ-DATA@ XML_NEW_NODE DROP
;
: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }
\ ����� ���� � ������ c-addr u � xml-���� oid

  oid OBJ-DATA@ DUP \ node
  IF c-addr u ROT node@ DUP 
     IF \ ������ ���� � �������� ������
        ( ������ � oid ��� � CONTEXT ?! - ������ �������� �������� ...)
        \ oid
        CONTEXT @
        OBJ-DATA! ['] NOOP 1
     THEN
  THEN
  DUP 0=
  IF \ �� ������ � "��������� �������", ������ � "������� ������"
     DROP c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST
  THEN
;
: setNode CONTEXT @ OBJ-DATA! ;
: getNode CONTEXT @ OBJ-DATA@ ;
: @ getNode text@ ;
: . @ TYPE ;
: WORDS getNode XML_NLIST ;
: SAVE ( addr u -- ) GET-CURRENT OBJ-DATA@ NODE>DOC XML_DOC_SAVE ;

>> CONSTANT XML_NODE-WL

: DOC>NODE
  CONTEXT @ OBJ-DATA@ XML_DOC_ROOT
  TEMP-WORDLIST >R
  R@ OBJ-DATA!
  XML_NODE-WL R@ CLASS!
  R> CONTEXT !
;

<<: FORTH XML_DOC

: CAR { doc -- node }
  doc OBJ-DATA@ \ ���� �� �������� - ��������
  0= IF doc OBJ-NAME@ " {s}" STR@ XML_READ_DOC doc OBJ-DATA! THEN
  
  doc OBJ-DATA@ DUP
  IF  ALSO NEW CONTEXT @ OBJ-DATA! DOC>NODE CONTEXT @ PREVIOUS THEN
;
: CDR ( node -- node )
  DROP 0 \ �������� ���� ������ ����
;
: ?VOC ( node -- flag )
  DROP TRUE
;
: NAME ( node -- addr u )
  XML_NODE::NAME
;
: >WID ( node -- node )
  XML_NODE::>WID
;
: SAVE ( addr u -- ) GET-CURRENT OBJ-DATA@ XML_DOC_SAVE ;

: SEARCH-WORDLIST { c-addr u oid -- 0 | xt 1 | xt -1 }

\ ������� ���� � ������� ������
  c-addr u [ GET-CURRENT ] LITERAL SEARCH-WORDLIST ?DUP IF EXIT THEN

  c-addr C@ [CHAR] / <> IF 0 EXIT THEN \ � ��������� ���� ������ ������

  oid OBJ-DATA@ \ doc; ���� �� �������� - ��������
  0= IF oid OBJ-NAME@ " {s}" STR@ XML_READ_DOC oid OBJ-DATA! THEN

  oid OBJ-DATA@ DUP
  IF \ ������� ��������� xml, ������ ����� ������ xt,
     \ ������� ������� �������� ��������� �� �������� ��������� ����
     DROP ['] DOC>NODE 1
  THEN
;
: WORDS "" ['] swid. CONTEXT @ ForEachDirWRstr ;
:>>

\ ���� ����� << XML_DOC libxml-parser.html , �� ��� ����������� DEFINITIONS

1000 TO WL_SIZE

\EOF

ALSO XML_DOC NEW: libxml-parser.html
libxml-parser.html / head title .
libxml-parser.html / head style .
libxml-parser.html WORDS
PREVIOUS
\EOF

ALSO XML_DOC NEW: eserv.xml
eserv.xml / head link @ FORTH::TYPE
PREVIOUS

ALSO XML_DOC NEW: http://forth.org.ru/
/html head title . CR
http://forth.org.ru/ /html head link @href . CR
\ http://forth.org.ru/ /html head getNode listNodes
PREVIOUS

ALSO XML_DOC NEW: http://forth.org.ru/rss.xml
/rss channel VOC-CLONE
title . CR ( channel/title �������� � ����� )
copyright . CR ( channel/copyright �������� � ��������� )
getNode 1 libxml2.dll::xmlGetNodePath ASCIIZ> TYPE CR
PREVIOUS ( ������ ���� )
getNode 1 libxml2.dll::xmlGetNodePath ASCIIZ> TYPE CR
PREVIOUS ( ������ �������� )

ALSO http://forth.org.ru/rss.xml /rss channel WORDS PREVIOUS

ORDER

ALSO http://forth.org.ru/rss.xml
/rss DEFINITIONS
VOCABULARY TEST
S" ctest.xml" SAVE
