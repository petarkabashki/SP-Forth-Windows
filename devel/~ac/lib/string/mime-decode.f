( rfc2231:

  charset := <registered character set name>
  language := <registered language tag [RFC-1766]>
  The ABNF given in RFC 2047 for encoded-words is:
  encoded-word := "=?" charset "?" encoding "?" encoded-text "?="
  This specification changes this ABNF to:
  encoded-word := "=?" charset ["*" language] "?" encoded-text "?="
  encoded-text = 1*<Any printable ASCII character other than "?" or SPACE>
                  ; but see "Use of encoded-words in message
                  ; headers", section 5


  rfc2045: base64, quotted printable
)

REQUIRE {             ~ac/lib/locals.f
REQUIRE STR@          ~ac/lib/str5.f
REQUIRE base64        ~ac/lib/string/conv.f
REQUIRE COMPARE-U     ~ac/lib/string/compare-u.f
REQUIRE SPLIT-        ~pinka/samples/2005/lib/split.f 
REQUIRE UPPERCASE     ~ac/lib/string/uppercase.f 

VOCABULARY CHARSET-DECODERS 
GET-CURRENT ALSO CHARSET-DECODERS DEFINITIONS
: windows-1251 ;
: koi8-r KOI>WIN ;
: Koi8-r KOI>WIN ;
: KOI8-R KOI>WIN ;
GET-CURRENT
PREVIOUS SWAP SET-CURRENT CONSTANT CHARSET-DECODERS-WL

: dequotep ( addr u -- addr2 u2 ) { \ s c }
  "" -> s
  BASE @ >R HEX
  2DUP + >R DROP
  BEGIN
    DUP R@ <
  WHILE
    DUP C@ DUP [CHAR] = = 
        IF DROP 1+ DUP 2+ SWAP 2 0 0 2SWAP 2DUP UPPERCASE >NUMBER 2DROP D>S
           ?DUP IF -> c ^ c 1 s STR+ THEN
        ELSE -> c 
             c [CHAR] _ = IF BL -> c THEN
             ^ c 1 s STR+ 1+
        THEN
  REPEAT DROP R> DROP
  R> BASE ! s STR@
;
USER uMimeValueDecodeCnt
VECT vDefaultMimeCharset \ ��������� �������� ������ �� ���������,
                         \ ���� ��� �� ������� � ����� ������ =?...?

: DefaultMimeCharset1 S" koi8-r" ; ' DefaultMimeCharset1 TO vDefaultMimeCharset

: MimeValueDecode1 ( encoding-a encoding-u text-a text-u flag -- addr u )
\ flag=true, ���� text ����������� base64
  IF debase64 ELSE dequotep THEN
  2SWAP CHARSET-DECODERS-WL SEARCH-WORDLIST IF EXECUTE THEN
  uMimeValueDecodeCnt 1+!
;
: MimeValueDecode { addr u \ ta tu s b -- addr2 u2 }
  "" -> s
  uMimeValueDecodeCnt 0!
  BEGIN
    addr u S" =?" SEARCH
  WHILE
    -> tu -> ta
    addr ta OVER - s STR+                                  \ �������������� �����
    ta 2+ tu 2- S" ?" SEARCH 0= IF s STR+ s STR@ EXIT THEN \ ������ encoder'�
    -> tu ta 2+ SWAP DUP -> ta OVER - \ encoding
    tu 5 < IF 2DROP ta tu s STR+ s STR@ EXIT THEN                \ ������ encoder'�
    ta 3 S" ?B?" COMPARE-U 0= -> b
    ta 3 + tu 3 - S" ?=" SEARCH 0=
    IF \ s STR+ 2DROP s STR@ EXIT THEN
       \ ������������ ������ �� ����������� "?=", ���������� ������
       2DUP + -> addr 0 -> u
    ELSE
      2- -> u DUP 2+ -> addr
      ta 3 + SWAP OVER - \ text
    THEN
    b MimeValueDecode1 s STR+
    BEGIN addr C@ IsDelimiter u 0 > AND    \ ���������� lwsp ����� '?=', �� ��������� ����...
    WHILE addr 1+ -> addr u 1- -> u
    REPEAT
  REPEAT                                   \ ������� ������ �� ���������
  s STR+ s STR@
  uMimeValueDecodeCnt @ 0=
  IF \ MimeValueDecode1 �� ����������, �.�. � ������ �� ���� ������� ���������
     \ ������� ���������� �� ��������� �� ���������
     vDefaultMimeCharset CHARSET-DECODERS-WL SEARCH-WORDLIST IF EXECUTE THEN
  THEN
;
: StripLwsp1_old { \ s }
  "" -> s
  BEGIN
    13 PARSE DUP
  WHILE
    s STR+
\    PeekChar IsDelimiter IF 2 >IN +! THEN
    PeekChar 10 = IF >IN 1+! THEN
    CharAddr DUP C@ 9 = IF BL SWAP C! ELSE DROP THEN
    s STR@ + 1- C@ [CHAR] = =  PeekChar IsDelimiter AND IF >IN 1+! THEN
  REPEAT 2DROP
  s STR@
;
\ ~pig: 15.02.2007
\ - �� ��������� ������ �� {CRLF}{CRLF}
\ - �� ����� ����������� ������� �� ���� �����������, � ��� �������, ������� �� ��� ���� (��������� �������� �������, ������� ���������, ����� �� ������ ���������, � ����� ��������, � ���������� ���������� �����)
\ - ����������� ����� (���� ����� � ���������� ���������� �������������) ���� {CRLF}, � �� �������� �������� ������ (�������� ������� ������� ����� PARSE)

: StripLwsp1 ( "text" -- addr u )
  "" >R						\ ��������� ��������
  BEGIN
    EndOfChunk 0=				\ ������ �� ����� ������
  WHILE
    13 PARSE					\ �������� �� ����� ������
    R@ STR+					\ �������� � �����
    CharAddr 1- C@ 13 =				\ ��� �� ������� �������?
    IF
      10 SKIP					\ �� - ���������� ������� ������
      OnDelimiter				\ ��������� ������ ���������� � �����������?
      GetChar SWAP 13 <> AND AND		\ �� �� � �������� ������� (�� ������)
      IF
        SkipDelimiters				\ ���������� ��� ������� ����������� ��������� ������
      ELSE
        CRLF R@ STR+				\ ��� �������� ����� ������ - �������� �����������
      THEN
    THEN
  REPEAT
  R> STR@					\ ��������� ������
;

: StripLwsp ( addr u -- addr2 u2 )
\ ������ �� ������ ��������� ������� CRLFLWSP
\ �.�. �������� ����� � ������������ �����������
\ ���������, ���������� ������� ������� ������
  ['] StripLwsp1_old EVALUATE-WITH
;

: -LEADING ( addr u -- addr1 u1 ) \ ~pig
\ ���������� ������� � ������ ����������� � ������ ������
\
  BEGIN
    DUP DUP					\ ���� ������ �� ���������
    IF DROP OVER C@ IsDelimiter THEN		\ � ���� ��� ���������� � �����������
  WHILE
    SKIP1					\ ���������� ���
  REPEAT
;

\ ~pig: 15.02.2007
\ �������������� ������� ���������� StripLwsp
\ ���������� ����� SPLIT- � -LEADING

: StripLwsp2 ( addr u -- addr1 u1 )
  "" >R						\ ��������� ��������
  BEGIN
    DUP						\ � ������ ���-������ ����?
    IF
      CRLF SPLIT- -ROT				\ �������� ��������� ������
      R@ STR+					\ �������� � �����
      IF
        OVER C@ DUP IsDelimiter SWAP LT C@ <> AND OVER 0<> AND	\ ��������� ������ ���������� � �����������?
        IF
          -LEADING				\ �� - ������ ������� �����������
        ELSE
          CRLF R@ STR+				\ ��� �������� ����� ������ - �������� �����������
        THEN
        FALSE					\ ����� �� ��������� ����
      ELSE
        TRUE					\ ������ ����� ���, ���������
      THEN
    ELSE
      2DROP TRUE				\ � ������ ������� ������ ������
    THEN
  UNTIL
  R> STR@					\ ��������� ������
;


(
" Subject: =?windows-1251?B?UmU6IFtlc2Vydl0gze7i++kg8ffl8iBFLTE5NDEg7vIgMjguMDEuMg==?=
	=?windows-1251?B?MDAz?=
Subject: =?koi8-r?B?W0V0eXBlXSDJzsbP0s3Bw8nRIM8g0MXSxdLZ18Ug09fR2skgMTUg0c7XwdLR?=
Subject: =?Windows-1251?B?0SDN7uL77CDD7uTu7CEg1e7y/CDxIO7v4Ofk4O3o5ewsIO3uIOLx5SDm?=
	=?Windows-1251?B?5SAlKQ==?=
From: =?koi8-r?Q?=EF=CC=D8=C7=C1=20=F0=C1=D7=CC=CF=D7=C1?=
Subject: =?koi8-r?Q?RE:_FIG_Taiwan_+_Russian+_clf_=C4=CF_=CB=D5=DE=C9?=
Subject: =?windows-1251?Q?=EF=EE_=EF=EE=E2=EE=E4=F3_Eserv?=
" STR@ StripLwsp MimeValueDecode ANSI>OEM TYPE

" =?koi8-r?Q?=EF=D4=CD=C5=CE=C5=CE=CF________=E9=FA=F7=E5=FD=E5=EE?=
 =?koi8-r?Q?=E9=E5=2E_=E9=EE=F4=E5=F2=EE=E5=F4_=FA=E1=EB=E1=FA_20638935?=
 =?koi8-r?Q?_=E9=EE=F7=EF=EA=F3_40620100_=E7=EF=F4=EF=F7_=EB_=F7=F9=E4=E1?=
 =?koi8-r?Q?=FE=E5__=C4=C1=D4=C1_=CD=CF=C4=C9=C6=C9=CB=C1=C3=C9=C9=3A_1?=
     =?koi8-r?Q?7=2E12=2E2003_=28=29?=
" STR@ StripLwsp MimeValueDecode ANSI>OEM TYPE

CR S" ��� ���� � ��������� koi8-r ��� mime-�����������" MimeValueDecode ANSI>OEM TYPE CR

" Subject: =?windows-1251?Q?=ce=ef=f0=e5=e4=e5=eb=e5=ed=e8=e5 =ea=f0=e8=f2=e5=f0=e8=e5=e2 =f3=f1=ef=e5=f8=ed=ee=f1=f2=e8  =e2=ed=f3=f2=f0=e5=ed=ed?=
	=?windows-1251?Q?=e5=e3=ee =e8 =e2=ed=e5=f8=ed=e5=e3=ee =ee=e1=f3=f7=e5=ed=e8=ff =ef=e5=f0=f1=ee=ed=e0=eb=e0?=" STR@ StripLwsp MimeValueDecode ANSI>OEM TYPE CR

\ ������ ��������� ��������� ��������� � ����-���������, ����������� � ���:
S" Subject: =?windows-1251?b?zvLr6Pft++kg7+7k4PDu6iDh8/Xj4Ovy5fDzLCDv8OXk7/Do7ejs4PLl6/4sIODz5Ojy7vDzLgA=" StripLwsp MimeValueDecode ANSI>OEM TYPE CR

)