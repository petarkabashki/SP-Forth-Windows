WARNING @ WARNING 0!
REQUIRE SO            ~ac/lib/ns/so-xt.f
REQUIRE STR@          ~ac/lib/str5.f
REQUIRE GET-FILE      ~ac/lib/lin/xml/xml.f
REQUIRE UNICODE>UTF8  ~ac/lib/win/com/com.f
WARNING !

ALSO SO NEW: libxslt.dll
ALSO SO NEW: libxslt.so.1
ALSO libxml2.dll

: XmlMemFree ( ptr 1 -- res )
  \ ������ ��� xmlMemFree, ������� ������������� � windows-������ libxml ����� xmlMemSetup
  PAD 12 + PAD 8 + PAD 4 + PAD 4 xmlMemGet DROP PAD @ C-EXEC
;
: XSLT { xaddr xu saddr su \ style doc res len str -- addr u }
\ ������������� XML-���� � ������/url xaddr xu � �������������� XSL-����� saddr su
  saddr 1 xsltParseStylesheetFile DUP -> style 0= IF 60002 THROW THEN
  xaddr xu XML_READ_DOC DUP -> doc 0= IF 60003 THROW THEN
  0 doc style 3 xsltApplyStylesheet DUP -> res 0= IF 60004 THROW THEN
  style res ^ len ^ str 4 xsltSaveResultToString DROP str len " {s}" STR@
\  0 style res S" test11.xml" DROP 4 xsltSaveResultToFilename .
  str 1 XmlMemFree DROP
  style 1 xsltFreeStylesheet DROP
  res 1 xmlFreeDoc DROP
  doc 1 xmlFreeDoc DROP
\  0 xsltCleanupGlobals DROP
\  0 xmlCleanupParser DROP
;
: XSLTm { xaddr xu saddr su \ style doc res len str -- addr u }
\ ������������� XML-������ xaddr xu � �������������� XSL-����� saddr su
  saddr 1 xsltParseStylesheetFile DUP -> style 0= IF 60002 THROW THEN
  xaddr xu XML_READ_DOC_MEM DUP -> doc 0= IF 60005 THROW THEN
  0 doc style 3 xsltApplyStylesheet DUP -> res 0= IF 60004 THROW THEN
  style res ^ len ^ str 4 xsltSaveResultToString DROP str len " {s}" STR@
\  0 style res S" test11.xml" DROP 4 xsltSaveResultToFilename .
  str 1 XmlMemFree DROP
  style 1 xsltFreeStylesheet DROP
  res 1 xmlFreeDoc DROP
  doc 1 xmlFreeDoc DROP
\  0 xsltCleanupGlobals DROP
\  0 xmlCleanupParser DROP
;
: XSLTmm { xaddr xu saddr su \ sdoc style doc res len str -- addr u }
\ ������������� XML-������ xaddr xu � �������������� XSL-������ saddr su
  saddr su XML_READ_DOC_MEM DUP -> sdoc 0= IF 60006 THROW THEN
  sdoc 1 xsltParseStylesheetDoc DUP -> style 0= IF 60002 THROW THEN
  xaddr xu XML_READ_DOC_MEM DUP -> doc 0= IF 60005 THROW THEN
  0 doc style 3 xsltApplyStylesheet DUP -> res 0= IF 60004 THROW THEN
  style res ^ len ^ str 4 xsltSaveResultToString DROP str len " {s}" STR@
  str 1 XmlMemFree DROP
  style 1 xsltFreeStylesheet DROP
  res 1 xmlFreeDoc DROP
  doc 1 xmlFreeDoc DROP
\  sdoc 1 xmlFreeDoc DROP
\  0 xsltCleanupGlobals DROP
\  0 xmlCleanupParser DROP
;
PREVIOUS PREVIOUS PREVIOUS

\ S" 1.xml" S" 1.xsl" XSLT
\ ����� ������ ���:������ �������������� ����� curl, � ��� libxml �� �����.
\ � ������ XSL-������ � document() ���:������ �� ��������.
\ S" http://name:pass@localhost/rep/Domains.xml" S" dbtable.xsl" XSLT TYPE
