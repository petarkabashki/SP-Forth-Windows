\ $Id: rss.f,v 1.6 2009/01/20 21:05:25 ygreks Exp $
\
\ ������ � RSS ����������� (� �������������� bac4th)
\
\ - �������� �� ���� �������� ������� XML ����
\ - ������ �� ����� ����
\ - �������� �� ���� ������� RSS
\ - �������� �� "�����" �������

REQUIRE XML_DOC_ROOT ~ac/lib/lin/xml/xml.f
REQUIRE NUMBER ~ygrek/lib/parse.f
REQUIRE parse-unixdate ~ygrek/lib/spec/sdate.f
REQUIRE parse-num-unixdate ~ygrek/lib/spec/sdate2.f
REQUIRE PRO ~profit/lib/bac4th.f
REQUIRE STATIC ~profit/lib/static.f

\ BUG Memory leak in text@
\ ����� ����
: xml.text ( node -- a u ) DUP IF text@ ELSE DROP S" " THEN ;

\ ������������ ������ ��� ������� ������� �������� node
: xml.children=> ( node --> node2 \ <-- node2 )
   DUP 0= IF DROP EXIT THEN
   PRO
    x.children @
    BEGIN
     DUP
    WHILE
     DUP x.type @ XML_ELEMENT_NODE = IF CONT THEN
     x.next @
    REPEAT DROP ;

\ ��� ����
: xml.name@ ( node -- a u ) x.name @ ASCIIZ> ;

\ ���������� ������ �������� � ������ a u
: //name= ( node a u --> node )
    PRO
     2>R DUP xml.name@ 2R>
     COMPARE 0= ONTRUE CONT ;

\ timestamp RSS-������
\ ����������� �������� pubDate � � ������ ������� - date
: rss.item.timestamp { node -- timestamp|0 }
   S" pubDate" node nodeText DUP IF parse-unixdate EXIT THEN 
   2DROP
   S" date" node nodeText DUP IF parse-num-unixdate EXIT THEN
   2DROP
   0 ;

\ ��������� rss-������
: rss.item.title ( node -- a u ) S" title" ROT node@ xml.text ;
\ ������ rss-������
: rss.item.link  ( node -- a u ) S" link"  ROT node@ xml.text ;

\ ����� rss-������
: rss.item.author ( node -- a u )
   >R
   S" creator" R@ nodeText DUP IF RDROP EXIT THEN
   2DROP
   S" contributor" R@ nodeText DUP IF RDROP EXIT THEN
   2DROP
   S" author" R@ nodeText DUP IF RDROP EXIT THEN
   2DROP
   RDROP S" " ;


ALSO libxml2.dll
ALSO libxml2.so.2

  \ ���������� ������ ���������� xml ����������
  : XML_FREE_DOC ( doc -- ) 1 xmlFreeDoc DROP ;

PREVIOUS
PREVIOUS

\ ��������� XML �������� �� ������ ( a u ) � ������������� �����
\ ������� �������� ��� ������
: xml.load=> ( a u --> doc \ <-- doc )
  PRO
  BACK XML_FREE_DOC TRACKING
  XML_READ_DOC_MEM RESTB 
  CONT DROP ;

\ ��� RSS ��������� a u ������ ��� ��������-������
: rss.items=> ( a u --> node \ <-- node )
   PRO
   xml.load=> DUP
   XML_DOC_ROOT ?DUP ONTRUE \ ������ - ������ ���� rss, �� �� ���������...
   ( node )
   DUP
   S" channel" ROT node@ \ ������� channel
   START{
     xml.children=> S" item" //name=
     CONT \ ������ ��� �������� /channel/item
   }EMERGE 
   ( node )
   START{
     xml.children=> S" item" //name=
     CONT \ ������ ��� �������� /item (� ForthWiki ����� rss)
   }EMERGE
   ;

\ ������ ��� ������ RSS ��������� a u ������� ����� ��� ������� ������� stamp
: rss.items-new=> ( doc stamp --> node \ <-- node )
    STATIC stamp
    stamp !
    PRO
    START{
    rss.items=> 
     DUP rss.item.timestamp stamp @ > ONTRUE CONT 
   }EMERGE ;

\ ���������� ������� ������� ����� ������ ������ RSS ��������� a u
: rss.items-newest ( a u -- max-timestamp )
    STATIC newest
    0 newest !
    START{
    rss.items=>
     DUP rss.item.timestamp DUP newest @ > IF newest ! ELSE DROP THEN 
    }EMERGE
    newest @ ;

\ \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

/TEST \ �������

REQUIRE load-file ~profit/lib/bac4th-str.f

\ ��� ������ Win ��������� � �������
[DEFINED] ANSI>OEM [IF]
' ANSI>OEM TO ANSI><OEM
[THEN]

: show ( node -- )
     >R
      R@ rss.item.timestamp CR DUP . ." === " Num>DateTime DateTime>PAD TYPE
      \ S" pubDate" R@ node@ xml.text CR TYPE
      R@ rss.item.link CR TYPE
      R@ rss.item.title CR TYPE
     RDROP ;

: test1
    load-file 2DUP
    0 0 20 26 1 2007 DateTime>Num
    rss.items-new=> DUP show ;

: test2 load-file 2DUP rss.items=> DUP show ;

: newest 
 load-file 2DUP
 CR 
 CR S" Newest : " TYPE
 rss.items-newest Num>DateTime DateTime>PAD TYPE ;

: xml-load-only load-file 2DUP rss.items=> ;
: test-memory 1000 0 DO S" rss.xml" xml-load-only LOOP ;

S" rss.xml" test2
S" rss.xml" newest
\ S" rss.xml" test1
