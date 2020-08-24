REQUIRE ParseMime              ~ac/lib/lin/mime/mime.f 
REQUIRE StripLwsp              ~ac/lib/string/mime-decode.f 
\ REQUIRE UNICODE>UTF8           ~ac/lib/win/com/com.f
REQUIRE iso-8859-5>UNICODE     ~ac/lib/lin/iconv/iconv.f 

\ ================================= subject decoding ==================

GET-CURRENT ALSO CHARSET-DECODERS DEFINITIONS
: UTF-8 UTF8> ;
: Utf-8 UTF8> ;
: utf-8 UTF8> ; \ UTF8>UNICODE " {s}" STR@ UNICODE> ;
: iso-8859-5 iso-8859-5>UNICODE " {s}" STR@ UNICODE> ;
PREVIOUS SET-CURRENT

REQUIRE { ~ac/lib/locals.f

: ">BL ( addr u -- )
  0 ?DO DUP C@ DUP [CHAR] " = SWAP [CHAR] ' = OR 
  IF BL OVER C! THEN 1+ LOOP DROP
;
: ,>BL ( addr u -- )
  0 ?DO DUP C@ [CHAR] , =
  IF BL OVER C! THEN 1+ LOOP DROP
;
\ ====== ���������� ����� � Email �� From ������ �������� ==

: SOURCE/
  SOURCE SWAP >IN @ + SWAP >IN @ - 0 MAX
;
: ?DupEmail ( addr1 u1 addr2 u2 -- addr1 u1 addr2 u2 )
\  2SWAP DUP IF 2SWAP EXIT THEN 2DROP 2DUP
;
: (Strip<) ( -- addr u )
  BL SKIP PeekChar [CHAR] < = IF >IN 1+! THEN
  [CHAR] > PARSE
;
: Strip< ( addr u -- addr2 u2 ) \ ��. ����� ������ � conv.f
  DUP IF ['] (Strip<) EVALUATE-WITH THEN
;
: FromNameEmail1 ( addr1 u1 addr2 u2 -- addr1 u1 addr2 u2 )
  -TRAILING 2SWAP -TRAILING Strip< ?DupEmail
;
: FromNameEmail2 ( -- addr1 u1 addr2 u2 )
  TIB >IN @ -TRAILING SOURCE/ -TRAILING ?DupEmail
;
: (FromNameEmail) ( -- addr1 u1 addr2 u2 )
  SOURCE ">BL BL SKIP
  SOURCE/ S" <" SEARCH
  IF DUP SOURCE/ ROT - FromNameEmail1 EXIT THEN 2DROP
  SOURCE/ S" (" SEARCH
  IF DUP SOURCE/ ROT - FromNameEmail1 EXIT THEN 2DROP
  BEGIN
    >IN @
    NextWord DUP
  WHILE
    S" @" SEARCH NIP NIP
    IF >IN ! FromNameEmail2 EXIT THEN
    DROP
  REPEAT 2DROP DROP
  >IN 0! BL SKIP SOURCE/ -TRAILING S" unknown@email"
;
: FromNameEmail ( addr u -- addr1 u1 addr2 u2 )
  ['] (FromNameEmail) EVALUATE-WITH
  2DUP S" @" SEARCH NIP NIP 0= >R
  2SWAP 2DUP S" @" SEARCH NIP NIP R> AND
  IF EXIT ELSE 2SWAP THEN
;
\ ==========================================================
: (Strip")
\  [CHAR] " PARSE 2DROP [CHAR] " PARSE
  SOURCE ">BL BL SKIP 1 PARSE -TRAILING
;
: (Strip')
\  [CHAR] ' PARSE 2DROP [CHAR] ' PARSE
  SOURCE ">BL BL SKIP 1 PARSE -TRAILING
;
CREATE _Quo CHAR " C,
: Strip"
  2DUP _Quo 1 SEARCH NIP NIP
  IF ['] (Strip") EVALUATE-WITH EXIT THEN
  2DUP S" '" SEARCH NIP NIP
  IF ['] (Strip') EVALUATE-WITH EXIT THEN
;
: (Strip2<)
  [CHAR] < PARSE 2DROP [CHAR] > PARSE
;
: Strip2<
  2DUP S" <" SEARCH NIP NIP
  IF ['] (Strip2<) EVALUATE-WITH THEN
  Strip"
;
: ParseRcpt1 { xt i -- }

  SOURCE FromNameEmail i xt EXECUTE EXIT

\ ------------
  BEGIN
    >IN @ >R
    NextWord DUP
  WHILE
    2DUP S" @" SEARCH NIP NIP
    IF SOURCE DROP R> Strip"
       2SWAP Strip2< i xt EXECUTE EXIT
    ELSE 2DROP RDROP THEN
  REPEAT 2DROP RDROP
;
: ParseRcpt2 { xt i -- i }
  BEGIN
    [CHAR] , PARSE DUP
  WHILE
    i 1+ -> i
    xt i 2SWAP
    ['] ParseRcpt1 EVALUATE-WITH
  REPEAT 2DROP i
;
: ParseRcptXt ( addr u xt -- n )
  0 2SWAP
  ['] ParseRcpt2 EVALUATE-WITH
;


: Is8Bit ( addr u -- flag )
  2DUP S" =?" SEARCH NIP NIP IF 2DROP FALSE EXIT THEN \ ��� ������������
  0 ?DO DUP I + C@ 127 > IF DROP TRUE UNLOOP EXIT THEN LOOP
  DROP FALSE
;
USER uStripCRLFtemp
: (StripCRLF)
  BEGIN
    13 PARSE DUP
  WHILE
    uStripCRLFtemp @ STR+
    >IN 1+! >IN 1+! \ ���������� LF � TAB
\    S"  " uStripCRLFtemp @ STR+
  REPEAT 2DROP
;
: StripCRLF ( addr u -- addr u )
  2DUP CRLF SEARCH NIP NIP 0= IF EXIT THEN
  "" uStripCRLFtemp !
  ['] (StripCRLF) EVALUATE-WITH
  uStripCRLFtemp @ STR@
;
: AddDefEncoding ( addr u ) { mp -- addr u }
\  StripCRLF
  StripLwsp
  2DUP Is8Bit 0= IF EXIT THEN
  S" Content-Type" mp FindMimeHeader 2DUP
  S" indows-1251" SEARCH NIP NIP
  IF 2DROP base64 OVER >R " =?windows-1251?B?{s}?=" STR@ R> FREE DROP
  ELSE
     S" -8" SEARCH NIP NIP
     IF base64 OVER >R " =?UTF-8?B?{s}?=" STR@ R> FREE DROP
     ELSE ( addr u ) \ ���� � ��������� ��������� �� �������, ��������� ����� � � ������ mime-�����
        mp S" 1" ROT GetMimePartMp S" Content-Type" ROT FindMimeHeader  2DUP
        S" indows-1251" SEARCH NIP NIP
        IF 2DROP base64 OVER >R " =?windows-1251?B?{s}?=" STR@ R> FREE DROP
        ELSE
           S" -8" SEARCH NIP NIP
           IF base64 OVER >R " =?UTF-8?B?{s}?=" STR@ R> FREE DROP THEN
        THEN
     THEN
  THEN
;
: GetSubject { mp -- addr u }
  S" Subject" mp FindMimeHeader mp AddDefEncoding
;
: GetFromLine { mp -- addr u }
  S" From" mp FindMimeHeader mp AddDefEncoding
;
: GetToLine { mp -- addr u }
  S" To" mp FindMimeHeader mp AddDefEncoding
;
: GetCcLine { mp -- addr u }
  S" Cc" mp FindMimeHeader mp AddDefEncoding
;
\ ================================= /subject decoding ==================

\ ================================= message decoding ================
: GetFrom { mp -- addr1 u1 addr2 u2 }
  S" From" mp FindMimeHeader DUP 0=
  IF 2DROP S" Reply-To" mp FindMimeHeader THEN
  mp AddDefEncoding
  MimeValueDecode ( ** add bregexp) FromNameEmail
;
CREATE CRLF.CRLF 13 C, 10 C, CHAR . C, 13 C, 10 C,

: StripTrailingEmptyLines { addr u -- addr u }
  addr u + 5 - 5 CRLF.CRLF 5 COMPARE 0= IF u 3 - -> u THEN
  BEGIN
    u 4 > IF addr u + 4 - 4 CRLF.CRLF 5 COMPARE 0=
          ELSE FALSE THEN
  WHILE
    u 2 - -> u
  REPEAT
  addr u
;
: StripLeadingEmptyLines { addr u -- addr u }
  BEGIN
    u 4 > IF addr 2 CRLF COMPARE 0=
          ELSE FALSE THEN
  WHILE
    addr 2 + -> addr
    u 2 - -> u
  REPEAT
  addr u
;
: _>BL ( addr u -- )
  0 ?DO DUP I + C@ 154 = ( OVER I + 1+ C@ 13 = AND) IF BL OVER I + C! THEN LOOP DROP
;
: CR>BR
  StripLeadingEmptyLines
  StripTrailingEmptyLines
\  DUP
\  IF
\    S" s/(<)/&lt;/g" BregexpReplace DROP
\    " {s}" STR@ BregexpFree
\    S" s/\n/<br>/g" BregexpReplace DROP
\    " {s}" STR@ BregexpFree
\  THEN
;
CREATE dbCRLFCRLF 13 C, 10 C, 13 C, 10 C,

: debase64_3 ( addr u -- addr1 u1 ) { \ i }
\ ������, ������������ ���������� ������� ������ �������� ������
\ � ������������ ��� �������� google

\ �������� ����� �������� ����� base64-�����, ������� ������ ����������� ������������ �����
  2DUP dbCRLFCRLF 4 SEARCH IF NIP - ELSE 2DROP THEN

  DUP 0= IF 2DROP 4 ALLOCATE THROW abase ! abase @ 0 EXIT THEN
  0 SWAP DUP 4 / 3 * CELL+ ALLOCATE THROW abase ! lbase 0! nbase 0!
  0 ?DO
    OVER I + C@ 32 >
    IF
      OVER I + C@ DUP [CHAR] = =
      IF DROP 0 nbase 1+! ELSE -AL64 DROP THEN 3 i 4 MOD - 0 ?DO 64 * LOOP +
      i 4 MOD 3 = IF abase @ lbase @ + DUP >R !
      R@ C@ R@ 2 CHARS + C@ R@ C! R> 2 CHARS + C!
      3 lbase +! 0 THEN
      i 1+ -> i
    THEN
  LOOP
  NIP ?DUP
  IF \ ��� �������� google - �� ��������� == � �����
    8 RSHIFT DUP abase @ lbase @ + DUP >R 1+ C!
    8 RSHIFT R> C!
    2 lbase +!
  THEN
  abase @ lbase @ nbase @ - 0 MAX
;
' debase64_3 TO debase64

USER _LASTMSGHTML

: MessageHtml { mp s \ tf_dq tf_db tf_pl -- addr u }

\ ��������! ��� ��-windows-1251 ���������� ��������� �������������� ��
\ ����� (�� ��������� � ��������� �� ��������), ������� ������ ��� ������ mp
\ �������� MessageHtml ������, ���� ������������ LastMsgHtml (��. ����).

\  mp GetFrom DUP IF 2DUP S" unknown@email" COMPARE
\                    IF 2SWAP " <h4>{s} [{s}]</h4>" s S+ ELSE 2DROP 2DROP THEN
\                 ELSE 2DROP 2DROP THEN
\  mp GetSubject ?DUP IF MimeValueDecode " <h4>{s}</h4>" s S+ ELSE DROP THEN
\  S" Date" mp FindMimeHeader ?DUP IF  MimeValueDecode " <h4>{s}</h4>" s S+ ELSE DROP THEN
  " <table border='1'>" s S+
  BEGIN
    " <tr><td>" s S+
    mp mpIsMultipart @ mp mpIsMessage OR mp mpParts @ AND
    IF mp mpParts @ s RECURSE 2DROP
    ELSE mp mpTypeAddr @ mp mpTypeLen @ 2DUP
         S" text" COMPARE-U 0= ROT ROT S" message" COMPARE-U 0= OR
         IF
           mp mpBodyAddr @ mp mpBodyLen @

           0 -> tf_dq 0 -> tf_db
           S" Content-Transfer-Encoding" mp FindMimeHeader S" quoted-printable"
           COMPARE-U 0= IF dequotep OVER -> tf_dq THEN
           S" Content-Transfer-Encoding" mp FindMimeHeader S" base64"
           COMPARE-U 0= IF debase64 OVER -> tf_db THEN
\           2DUP _>BL ( ���������: ������ unicode-����� "�" )
           mp mpCharsetAddr @ mp mpCharsetLen @ ?DUP
           IF CHARSET-DECODERS-WL SEARCH-WORDLIST IF EXECUTE THEN ELSE DROP THEN

           0 -> tf_pl
           mp mpSubTypeAddr @ mp mpSubTypeLen @ S" plain" COMPARE-U 0=
           IF CR>BR " <pre class='plain'>{s}</pre>" DUP -> tf_pl STR@ THEN
           s STR+
           tf_dq ?DUP IF FREE DROP THEN tf_db ?DUP IF FREE DROP THEN
           tf_pl ?DUP IF STRFREE THEN
         ELSE mp mpTypeAddr @ mp mpTypeLen @ s STR+ THEN
    THEN
    mp mpNextPart @ DUP -> mp 0=
    " </td></tr>" s S+
  UNTIL
  " </table>" s S+
  s DUP _LASTMSGHTML ! STR@
;
: LastMsgHtml
  _LASTMSGHTML @ ?DUP IF STR@ ELSE S" " THEN
;
: LastMsgHtmlFree
  _LASTMSGHTML @ ?DUP IF STRFREE _LASTMSGHTML 0! THEN
;

\ ================================= message decoding ================
\EOF

REQUIRE STR@             ~ac/lib/str2.f

: TTCR ( namea nameu emaila emailu i -- )
  .
  TYPE CR
  TYPE CR
;
"  'Andrey Cherezov'  <ac@eserv.ru> , 
{''}Eserv Support{''} support@eserv.ru " STR@ ' TTCR ParseRcptXt .
