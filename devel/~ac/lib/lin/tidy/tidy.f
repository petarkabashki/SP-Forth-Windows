( ����������� HTML ����� ���������� TIDY
  $Id: tidy.f,v 1.8 2008/12/14 18:28:40 spf Exp $

  ��� ���������� ����� tidy.dll.
  http://dev.int64.org/tidy.html
  ���������������� � PAS-������.
)  
  
WARNING @ WARNING 0!
REQUIRE STR@          ~ac/lib/str5.f
REQUIRE UNICODE>UTF8  ~ac/lib/win/com/com.f
REQUIRE DelXmlDecl    ~ac/lib/lin/tidy/delxmldecl.f
REQUIRE [IF]          lib/include/tools.f
WARNING !

[DEFINED] WINAPI: [IF]
  REQUIRE DLL           ~ac/lib/ns/dll-xt.f
  ALSO DLL NEW: tidy.dll
[ELSE]
  REQUIRE SO            ~ac/lib/ns/so-xt.f
  ALSO  SO NEW: libtidy.so
[THEN]

23 CONSTANT TidyXhtmlOut
25 CONSTANT TidyXmlDecl
37 CONSTANT TidyNumEntities
64 CONSTANT TidyForceOutput
 4 CONSTANT TidyCharEncoding
 5 CONSTANT TidyInCharEncoding
 6 CONSTANT TidyOutCharEncoding
 8 CONSTANT TidyDoctypeMode

: TIDY_CYR_HTML { addr u \ doc  _buf0 buf0 errlen errbuf  _buf1 buf1 len buf  _buf2 buf2 ilen ibuf -- addr2 u2 }
  tidyCreate -> doc
  1 TidyXhtmlOut doc tidyOptSetBool DROP
  1 TidyXmlDecl doc tidyOptSetBool DROP
  1 TidyNumEntities doc tidyOptSetBool DROP
  0 TidyDoctypeMode doc tidyOptSetInt DROP
  S" utf16le" DROP TidyInCharEncoding doc tidyOptSetValue DROP
  S" utf8" DROP TidyOutCharEncoding doc tidyOptSetValue DROP
  ^ errbuf doc tidySetErrorBuffer DROP
\ Tidy �� ����� �������� � ����������, ������� ������������ � ������.
  addr u DelXmlDecl >UNICODE
  DUP -> ilen 2+ -> buf2 -> ibuf ^ ibuf doc tidyParseBuffer DROP
  doc tidyCleanAndRepair DROP
  doc tidyRunDiagnostics DROP
  1 TidyForceOutput doc tidyOptSetBool DROP
  ^ buf doc tidySaveBuffer DROP
\  errbuf errlen TYPE CR
  ^ errbuf tidyBufFree DROP
  buf len " {s}" STR@
  ^ buf tidyBufFree DROP
  doc tidyRelease DROP
;
: TIDY_CYR_HTML_SAVE { addr u fa fu \ h _buf1 buf1 len buf -- }
  fa fu R/W CREATE-FILE THROW -> h
  addr u TIDY_CYR_HTML 2DUP DUP -> len -> buf1 -> buf
\  UTF8>UNICODE UNICODE>
  h WRITE-FILE THROW
  h CLOSE-FILE THROW
\  ^ buf tidyBufFree DROP
;
: TIDY_HTML { addr u \ doc  _buf0 buf0 errlen errbuf  _buf1 buf1 len buf  _buf2 buf2 ilen ibuf -- addr2 u2 }
  tidyCreate -> doc
  1 TidyXhtmlOut doc tidyOptSetBool DROP
  1 TidyXmlDecl doc tidyOptSetBool DROP
  1 TidyNumEntities doc tidyOptSetBool DROP
  0 TidyDoctypeMode doc tidyOptSetInt DROP
  S" utf16le" DROP TidyInCharEncoding doc tidyOptSetValue DROP
  S" utf8" DROP TidyOutCharEncoding doc tidyOptSetValue DROP
  ^ errbuf doc tidySetErrorBuffer DROP
\ Tidy �� ����� �������� � ����������, ������� ������������ � ������.
  addr u DelXmlDecl
  DUP -> ilen 2+ -> buf2 -> ibuf ^ ibuf doc tidyParseBuffer DROP
  doc tidyCleanAndRepair DROP
  doc tidyRunDiagnostics DROP
  1 TidyForceOutput doc tidyOptSetBool DROP
  ^ buf doc tidySaveBuffer DROP
\  errbuf errlen TYPE CR
  ^ errbuf tidyBufFree DROP
  buf len " {s}" STR@
  ^ buf tidyBufFree DROP
  doc tidyRelease DROP
;
: TIDY_HTML_SAVE { addr u fa fu \ h _buf1 buf1 len buf -- }
  fa fu R/W CREATE-FILE THROW -> h
  addr u TIDY_HTML 2DUP DUP -> len -> buf1 -> buf
  h WRITE-FILE THROW
  h CLOSE-FILE THROW
\  ^ buf tidyBufFree DROP
;

\ S" <title>Foo</title><p>� ���!" TIDY_CYR_HTML TYPE
\ S" <title>Foo</title><p>� ���!" S" test.xml" TIDY_CYR_HTML_SAVE
\ S" test.xml" FILE S" test2.xml" TIDY_CYR_HTML_SAVE
\ S" D:\ac\xml\antispamnews.html" FILE S" test3.xml" TIDY_CYR_HTML_SAVE
\ S" D:\Eserv3\CommonPlugins\plugins\groups_e2\ru\docs.html" FILE S" test4.html" TIDY_CYR_HTML_SAVE
\ S" D:\ac\05cs2.html" FILE S" cs2.html" TIDY_CYR_HTML_SAVE

PREVIOUS

\ ALSO tidy.dll DEFINITIONS : TEST ; \ ������ ������� 5 THROW
