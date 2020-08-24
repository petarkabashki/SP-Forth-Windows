( ���������� ������ � DNS-���������.
  �������� DNS ������ � RFC1035

  ���������� 19.01.2003:
  ��������� ����� GetRRs, ���������� �������� ��������� 
  DNS-�������� ������ ������� ����� ���� ������������������.
  "�������" ������ ����� ���� � �������� ���������� ����� GetRRs :->

  �������������:
  S" domain.name" dns-record-type GetRRs
  ��������:
  S" forth.org.ru" TYPE-MX GetRRs

  ��������� GetRRs - ����� ���������� �������.
  "����������" ������ - 0,1,2 � �.�. ��������������� �����.
  ������ ������:
  -1 - ������� �������� [���������� ����� UDP-��������]
     ��� ����� ���� ���������� ���������� �������� �����, ��������,
     �.�. ������ ���������� ������� ������. ��� ���������� ����� ����� DNS-��������.
  -2 - ����� ����� ����, �� ������ �� �������� � 6 ������� - ������ 
     ����� ����� ������� ��������
  -3 - ��������� ����� "�� ���������� � �������"
  -5 - DNS-������ �� ����� ��������� ���� ������� [����� ������, ��������]

  ���������� 04.04.2007:
  -6 - ������ �� ���� DNS-�������� ������ [������ GetMXs]
  -7 - ������ DNS-������� [������ NS-������� �������������� ������]

  ���������� 28.02.2008:
  -8 - ������ � ������� DNS-������

  GetRRn ���������� �� GetRRs ���, ��� �� ��������� ������
  ���������� �������, � ������ �������� �� �����, �.�. ��������
  ����� � ������, ���� �� ����� ���������� ������ �������. 
  ������ ��� �� ��.

  ������������� ���� � ����� ����������� DNS-������� ����������
  ���������� ���� ��� ������ �������������. �� ����� ������� ��������
  DNS-������ ������ "-s ������".

  ��� �������� �����:
  DnsValidateDomain      [ domaina domainu -- flag ]
  DnsValidateEmailDomain [ emaila emailu -- flag ]
  ���������, �������� �� ����� �������� �������� �������,
  �.�. ����� �� �� ���� ���������� �����. ��� �������� ��������
  MX- � A-������� ��� ����� ������. ���� ���� ���� �� ����, ��
  ��������� ��������. ������������� ����� user@ � ������ ������
  �� �����������, � "������������" ��������� �������� ��������
  ����� �� ����������� - �.�. ���������� ������� �������� ������ ��
  ��������. ������������� ������ GetRR ���������� ��� "����������
  �����". �.�. ������������ ��� ����� ����� ������ ��� ������� DNS.
  
  DnsDomainExists [ domaina domainu -- flag ]
  ���� GetRRn ���������� -3, �� ������ ����� ���. ��� ���������
  ������, � �.�. ������������� ���������� ��� "����", ����������
  �� ���� "���� ��� ���������� ��������� ��-�� ������� DNS ��� ����".
  ���� � ������ ��� MX- � A-�������, �� �� ����� ��������� ��������������.

  NextMX [ -- servera serveru true | false ]

  �������� �������� MX-������� �� ����������� ��� ������� �������� �����.
  S" domain" GetMXs 0 MAX 0 ?DO NextMX ... LOOP

  DnsDomainExists ���������� �� DnsValidateDomain ���������� �
  ������� DNS. DnsDomainExists ��� ������� �� ��������� �����,
  � DnsValidateDomain ���������. ��� ������� DNS ��� ����������.
)

REQUIRE GetDNS  ~ac/lib/win/winsock/get_dns.f
REQUIRE WriteTo ~ac/lib/win/winsock/sockname.f

\  +---------------------+
\  |        Header       |
\  +---------------------+
\  |       Question      | the question for the name server
\  +---------------------+
\  |        Answer       | RRs answering the question
\  +---------------------+
\  |      Authority      | RRs pointing toward an authority
\  +---------------------+
\  |      Additional     | RRs holding additional information
\  +---------------------+
\ RR = "resource record"

0
2 -- HeaderID       \ "����� �������" (� ������ ����� �� ��)
2 -- HeaderBits     \ ����� ������� ������
2 -- HeaderQDCOUNT  \ number of entries in the question section.
2 -- HeaderANCOUNT  \ number of resource records in the answer section
2 -- HeaderNSCOUNT  \ number of name server resource records in the authority records section.
2 -- HeaderARCOUNT  \ number of resource records in the additional records section.
CONSTANT /Header

USER DNSQUERY
USER DNSREPLY
USER QID
USER DDP
USER REP
USER BS
USER IS-SUCCESS
USER ATTEMPTS
USER RLIST
USER CURRENT-R
VARIABLE DnsDebug
   3 VALUE vDnsAttempts \ ���� 6
4000 VALUE vDnsTimeout  \ ���� 8000

VARIABLE DnsPort  53 DnsPort !
   USER uDnsPort

  1 CONSTANT TYPE-A
  2 CONSTANT TYPE-NS
  5 CONSTANT TYPE-CNAME
  6 CONSTANT TYPE-SOA
 12 CONSTANT TYPE-PTR
 15 CONSTANT TYPE-MX
 16 CONSTANT TYPE-TXT
252 CONSTANT QTYPE-AXFR
  1 CONSTANT CLASS-IN
255 CONSTANT QCLASS-ANY
10000 CONSTANT /DNSREPLY

: >B<
  256 /MOD SWAP 256 * +
;

: TOKEN, ( addr u -- )
  DUP DDP @ C! DDP 1+!
  DDP @ SWAP DUP DDP +! MOVE
;

: WT, ( x -- )
  >B< DDP @ W! DDP 1+! DDP 1+!
;

\ HOLDS � ����

\ : HOLDS ( addr u -- )
\   1024 MIN
\   SWAP OVER + SWAP 0 ?DO DUP I - 1- C@ HOLD LOOP DROP
\ ;

0
4 -- RLnext
4 -- RLname
4 -- RLtype
4 -- RLhost
4 -- RLparam1
CONSTANT /RL

: XCOUNT
  DUP @ SWAP CELL+ SWAP
;

: FreeField ( af -- )
  DUP @ ?DUP IF FREE THROW THEN 0!
;

: GetFieldData ( af -- addr u )
  @ ?DUP IF XCOUNT ELSE S" " THEN
;

: SetFieldData ( addr u af -- )
  { a u af \ mem }
  af FreeField
  u CELL+ CHAR+ ALLOCATE THROW -> mem
  u mem ! a mem CELL+ u MOVE
  mem af !
;

: AddName ( addr u -- )
  /RL ALLOCATE THROW >R
  R@ /RL ERASE
  R@ RLname SetFieldData
  RLIST @ R@ RLnext !
  R@ RLIST !
  R> CURRENT-R !
;
: FreeRlist
  RLIST @
  BEGIN
    DUP
  WHILE
    DUP RLnext @ SWAP FREE DROP
  REPEAT RLIST !
;
: PrintRL ( addr -- )
  >R
  ." Name=" R@ RLname GetFieldData TYPE SPACE
  ." Type=" R@ RLtype @ DUP TYPE-MX = IF DROP ." MX " ELSE . THEN
  ." Host=" R@ RLhost GetFieldData TYPE SPACE
  ." Param=" R@ RLparam1 @ .
  R> DROP
;
: PrintRLIST ( -- )
  RLIST @
  BEGIN
    DUP
  WHILE
    DUP PrintRL CR
    RLnext @
  REPEAT DROP
;
: PrintReceivedRDs ( type -- )
  >R
  RLIST @
  BEGIN
    DUP
  WHILE
    DUP RLtype @ R@ =
    IF DUP PrintRL CR THEN
    RLnext @
  REPEAT DROP
  R> DROP
;

: PrintReceivedMXs ( -- )
  TYPE-MX PrintReceivedRDs
;
: EnumReceivedRDs ( type -- n )
\ ����� ����� ������ ���� ������ ���������� �� �� GetRRs,
\ � ������ ��������. ��� GetRRs ������ � ��� �������� ������ ������
\ ������ (����������� :) ����
  0 >R
  RLIST @
  BEGIN
    DUP
  WHILE
    2DUP RLtype @ =
    IF R> 1+ >R THEN
    RLnext @
  REPEAT 2DROP
  R>
;
: EnumReceivedMXs ( -- n )
  TYPE-MX EnumReceivedRDs
;

: PrepareDnsQuery ( qtype addr u -- )
  DNSQUERY @ 0= IF 1500 ALLOCATE THROW DNSQUERY ! THEN
  DNSQUERY @ 1500 ERASE
\  DNSREPLY @ ?DUP IF /DNSREPLY ERASE THEN

  FreeRlist
  QID 1+! QID W@ >B< DNSQUERY @ HeaderID W!

  \ HeaderBits =0 � ������� ������������� ��������
  1 DNSQUERY @ HeaderBits C! \ RD - recurse desired

  1 >B< DNSQUERY @ HeaderQDCOUNT W!

  \ ������ � ������� ��� ������
  \ ������ �� ���������� ���� QNAME QTYPE QCLASS

  DNSQUERY @ /Header + DDP !
  BEGIN
    0 MAX 128 MIN
    DUP
  WHILE
    2DUP S" ." SEARCH
    IF ( addr u addr-d u-rem )
       1- >R NIP ( addr addr-d  R: u-rem-1 )
       DUP 1+ >R
       OVER - ( ����� �����_������_�����    R: �����_������� �����_������� )
       TOKEN,
       R> R>
    ELSE 2DROP TOKEN, PAD ( HERE) 0 THEN
  REPEAT TOKEN,
  WT,
\  QCLASS-ANY WT,
  CLASS-IN WT,
;

: BsStartup
  SocketsStartup DROP
  CreateUdpSocket THROW BS !
  vDnsTimeout BS @ SetUdpSocketTimeout THROW
  DNS-SERVER @ 0= IF DNS-SERVERS @ DNS-SERVER ! THEN
;
: BsCloseSocket
  BS @ ?DUP IF CloseSocket DROP BS 0! THEN
;
: BsReopen \ ������� ����� �����, ����� ��� ������������ DNS ��� �����������
           \ ��� ����� �� �������� ������������ ������ �� ������ �������!
  CreateUdpSocket THROW
  vDnsTimeout OVER SetUdpSocketTimeout THROW
  BsCloseSocket
  BS !
;
: SendDnsQuery
  DNS-SERVERS @ 0= DNS-SERVER @ 0= AND
  IF GetDNS ?DUP 
            IF DNS-SERVER !
               \ DNS-COUNT @ 1 > IF COUNT + 1+ THEN DNS-SERVER !
            ELSE -11001 THROW THEN \ �� ������ DNS-������
  THEN
  BS @ 0= IF BsStartup THEN

  DnsDebug @ IF ."  SendQuery(" DNS-SERVER @ COUNT TYPE ." ):" CR THEN

  DNS-SERVER @ COUNT GetHostIP THROW
  uDnsPort @ 0= IF DnsPort @ uDnsPort ! THEN uDnsPort @
  DNSQUERY @ DDP @ OVER - \ 2DUP DUMP
  BS @ WriteTo
;

USER uDnsPNRL \ �������� ������� �������� - ������ �� �������� ������� ��������

: PrintName1
  uDnsPNRL 1+!
  BEGIN
     REP @ C@ DUP 0 > DEPTH 30 < AND uDnsPNRL @ 10 < AND
  WHILE
    64 > 
    IF REP @ DUP >R W@ >B< 255 AND DNSREPLY @ + REP ! RECURSE R> REP ! 2 REP +!
       EXIT
    ELSE REP @ COUNT 2DUP + REP ! TYPE ." ." THEN
  REPEAT DROP
  SPACE REP 1+!
  uDnsPNRL @ 1- uDnsPNRL !
;
: PrintName
  uDnsPNRL 0! PrintName1
;
: ParseName1 ( -- ... )
  uDnsPNRL 1+!
  BEGIN
     REP @ C@ DUP 0 > DEPTH 30 < AND uDnsPNRL @ 10 < AND
  WHILE
    64 > 
    IF REP @ DUP >R W@ >B< 255 AND DNSREPLY @ + REP ! RECURSE R> REP ! 2 REP +!
       EXIT
    ELSE REP @ COUNT 2DUP + REP ! THEN
  REPEAT DROP
  REP 1+!
  uDnsPNRL @ 1- uDnsPNRL !
;
: ParseName ( -- addr u )
  PAD ( HERE) 0
  uDnsPNRL 0! ParseName1
  0 0 <# 2DROP
  BEGIN
    DUP
  WHILE
    HOLDS [CHAR] . HOLD
  REPEAT
  #>
  1- SWAP 1+ SWAP 0 MAX
;
: ParseAddName ( -- )
  ParseName AddName
;

: PrintType
  ." Type=" REP @ W@ >B<
  DUP 16 ( TXT) > ABORT" DNS reply format error (type)"
  . 2 REP +!
;

: ParseType
  REP @ W@ >B<
  DUP 16 ( TXT) > ABORT" DNS reply format error (type)"
  2 REP +!
  CURRENT-R @ ?DUP IF RLtype ! ELSE DROP THEN
;

: PrintClass
  ." Class=" REP @ W@ >B<
  DUP 255 <> ( ANY) OVER 1 ( INternet) <> AND ABORT" DNS reply format error (class)"
  . 2 REP +!
;

: ParseClass
  REP @ W@ >B<
  DUP 255 <> ( ANY) SWAP 1 ( INternet) <> AND ABORT" DNS reply format error (class)"
  2 REP +!
;

: PrintTTL
  ." TTL=" REP @ @ . 4 REP +!
;

: ParseTTL
  4 REP +!
;

: NextRD
  REP @ W@ >B< 2 + REP +!
;

: PrintRD
  CR ." RD="
  REP @ 8 - W@ >B< TYPE-MX =

  IF ." MX Pref="
     REP @ 2 + W@ >B< . ." Host="
     REP @ DUP >R 4 + REP ! PrintName R> REP ! CR
     NextRD EXIT
  THEN

  REP @ 8 - W@ >B< TYPE-A =
  IF ." A IP="
     REP @ 2 + @ NtoA TYPE CR NextRD EXIT
  THEN

  REP @ 8 - W@ >B< TYPE-NS =
  IF ." NS Host="
     REP @ DUP >R 2 + REP ! PrintName R> REP ! CR
     NextRD EXIT
  THEN

  REP @ W@ >B< DUP . 2 REP +!
  REP @ OVER 1500 MIN CR DUMP CR
  DUP 1500 > ABORT" DNS reply format error (RD size)"
  REP +! \ 1500 MIN - ������ �� �������� ������� ��������
;

: ParseRD

  REP @ 8 - W@ >B< TYPE-MX =
  IF 
     REP @ 2 + W@ >B< CURRENT-R @ RLparam1 ! 
     REP @ DUP >R 4 + REP ! ParseName CURRENT-R @ RLhost SetFieldData
     R> REP !
     NextRD EXIT
  THEN


  REP @ 8 - W@ >B< TYPE-A =
  IF 
     REP @ 2 + @ NtoA CURRENT-R @ RLhost SetFieldData
     NextRD EXIT
  THEN

  REP @ 8 - W@ >B< TYPE-NS =
  IF
     REP @ DUP >R 2 + REP ! ParseName CURRENT-R @ RLhost SetFieldData
     R> REP !
     NextRD EXIT
  THEN

  REP @ 8 - W@ >B< TYPE-PTR =
  IF
     REP @ DUP >R 2 + REP ! ParseName CURRENT-R @ RLhost SetFieldData
     R> REP !
     NextRD EXIT
  THEN

\  NextRD

  REP @ W@ >B< 2 REP +!
  REP @ OVER 1500 MIN CURRENT-R @ RLhost SetFieldData
  REP +! \ 1500 MIN - ������ �� �������� ������� ��������

;

: PrintDnsQuestions ( n -- )
  ." Questions:" CR
  0 DO
    PrintName
    PrintType
    PrintClass CR
  LOOP CR
;
: ParseDnsQuestions ( n -- )
  0 DO
    ParseName 2DROP
    ParseType
    ParseClass
  LOOP
;

: PrintDnsAnswers ( n -- )
  0 DO
    PrintName
    PrintType
    PrintClass
    PrintTTL
    PrintRD CR
  LOOP CR
;
: ParseDnsAnswers ( n -- )
  0 DO
    ParseAddName
    ParseType
    ParseClass
    ParseTTL
    ParseRD
  LOOP
;

: PrintDnsReply
  DNSREPLY @ >R
  R@ HeaderID W@ >B< QID W@ <> IF ." ID mismatch." CR R> DROP EXIT THEN
  CR
  ." ReplyBits: " R@ HeaderBits W@ >B< 2 BASE ! U. 10 BASE ! CR
  ." Questions: " R@ HeaderQDCOUNT W@ >B< . CR \ number of entries in the question section.
  ." Answers: " R@ HeaderANCOUNT W@ >B< . CR \ number of resource records in the answer section
  ." NS RRs: " R@ HeaderNSCOUNT W@ >B< . CR \ number of name server resource records in the authority records section.
  ." Additional: " R@ HeaderARCOUNT W@ >B< . CR \ number of resource records in the additional records section.
  R@ /Header + REP !
  R@ HeaderQDCOUNT W@ >B< ?DUP IF PrintDnsQuestions THEN
  R@ HeaderANCOUNT W@ >B< ?DUP IF ." Answers:" CR PrintDnsAnswers THEN
  R@ HeaderNSCOUNT W@ >B< ?DUP IF ." NS RRs:" CR PrintDnsAnswers THEN
  R@ HeaderARCOUNT W@ >B< ?DUP IF ." Additional:" CR PrintDnsAnswers THEN
  R> DROP
;
: ParseDnsReply \ ���� ������������ �����, ������� ��������������,
  ( RLIST 0!) FreeRlist CURRENT-R 0!
  DNSREPLY @ >R
  R@ /Header + REP !
  R@ HeaderQDCOUNT W@ >B< ?DUP IF ParseDnsQuestions THEN
  R@ HeaderANCOUNT W@ >B< ?DUP IF ParseDnsAnswers THEN
  R@ HeaderNSCOUNT W@ >B< ?DUP IF ParseDnsAnswers THEN
  R@ HeaderARCOUNT W@ >B< ?DUP IF ParseDnsAnswers THEN
  R> DROP
;
: ParseAnswer \ ������ ����� ������
  ( RLIST 0!) FreeRlist CURRENT-R 0!
  DNSREPLY @ >R
  R@ /Header + REP !
  R@ HeaderQDCOUNT W@ >B< ?DUP IF ParseDnsQuestions THEN
  R@ HeaderANCOUNT W@ >B< ?DUP IF ParseDnsAnswers THEN
  R> DROP
;

: RecvDnsReplyIdMismatch
  DnsDebug @ 
  IF ." QID mismatch." DNSREPLY @ HeaderID W@ >B< . 
     QID W@ . CR
  THEN
;
: RecvDnsReply
  DNSREPLY @ 0=
  IF /DNSREPLY ALLOCATE THROW DNSREPLY ! THEN
  BEGIN
    DNSREPLY @ /DNSREPLY ERASE
    DNSREPLY @ /DNSREPLY BS @ ReadFrom
    DNSREPLY @ HeaderID W@ >B< QID W@ =
    DUP 0= IF RecvDnsReplyIdMismatch THEN
  UNTIL
  DnsDebug @ 0=
  IF 2DROP DROP 
  ELSE . . DNSREPLY @ SWAP ( 23 16 *) /DNSREPLY MIN DUMP CR 
       PrintDnsReply CR 
  THEN
;
: NextDNS ( -- flag )
  DNS-SERVERS @ 0= IF GetDNS DUP 
                      IF DUP DNS-SERVER ! DnsDebug @ 
                         IF ." System DNS: " DNS-SERVER @ COUNT TYPE CR THEN
                      THEN EXIT
                   THEN
  BsReopen
  DNS-SERVER @ COUNT + 1+
  DUP COUNT NIP 0= IF DROP FALSE DNS-SERVERS @ DNS-SERVER !
                      \ � ���� ����� ������ "������ ���", � ���������� ���������
                      EXIT
                   THEN
  DnsDebug @ IF ." Next DNS: " DUP COUNT TYPE CR THEN
  DNS-SERVER ! TRUE
;
: DNS-SERVER.
  DNS-SERVER @ 0= IF DNS-SERVERS @ ?DUP IF DNS-SERVER ! THEN THEN
  DNS-SERVER @ ?DUP 
  IF COUNT TYPE
  ELSE NextDNS IF RECURSE THEN THEN
;
: GetRRs { hosta hostu type \ attempts -- n }
  DnsDebug @ IF ." GetRRs: " hosta hostu TYPE CR THEN
  1 -> attempts
  type hosta hostu PrepareDnsQuery
  BEGIN
  BEGIN
    DnsDebug @ IF attempts type hosta hostu ." DNS-QUERY(" DNS-SERVER. ." ): " TYPE ." , type=" . ." , attempt=" . CR THEN
    ['] SendDnsQuery CATCH IF -1 EXIT THEN  \ network problem
    ['] RecvDnsReply CATCH 
    ?DUP IF 10060 <> IF -1 EXIT THEN FALSE ELSE TRUE THEN
    IF 
      DNSREPLY @ HeaderBits W@ >B< 15 AND
      DUP ( RCODE) 3 = IF DROP -3 EXIT THEN \ domain not exist (authoritative!)
      DUP ( RCODE) 5 = IF DROP -5 EXIT THEN \ refused operation
      DUP ( RCODE) 2 = IF DROP -7 EXIT THEN \ name server failure
      0=
      DNSREPLY @ HeaderID W@ >B< QID W@ = AND
      IF
        ['] ParseAnswer CATCH IF -8 EXIT THEN \ format error
        DnsDebug @ IF PrintRLIST THEN
        type EnumReceivedRDs
        DUP 0=
        IF
          DNSREPLY @ HeaderBits W@ >B< 128 AND \ RA - recurse available
          0= IF 
               DROP -5 \ ������ �� ��� �����, �.�. �� �������� ����� ������
                       \ � ����������� ������ ������ �� �����,
                       \ �.�. ������ ����� ����� ����� DNS-������
             THEN
        THEN
        EXIT
      THEN
    THEN
    attempts 1+ DUP -> attempts
    vDnsAttempts >
    BsReopen
  UNTIL
  NextDNS 0=
  UNTIL
  -2 \ timeouts or DNS-server failure
;
\ HeaderANCOUNT W@ >B<

: GetRRn { hosta hostu type \ attempts -- n }
  DnsDebug @ IF ." GetRRn: " hosta hostu TYPE CR THEN
  1 -> attempts
  type hosta hostu PrepareDnsQuery
  BEGIN
  BEGIN
    DnsDebug @ IF attempts type hosta hostu ." DNS-QUERY(" DNS-SERVER. ." ): " TYPE ." , type=" . ." , attempt=" . CR THEN
    ['] SendDnsQuery CATCH IF -1 EXIT THEN  \ network problem or DNS-server not detected
    ['] RecvDnsReply CATCH 
    ?DUP IF 10060 <> IF -1 EXIT THEN FALSE ELSE TRUE THEN
    IF 
      DNSREPLY @ HeaderBits W@ >B< 15 AND
      DUP ( RCODE) 3 = IF DROP -3 EXIT THEN \ domain not exist (authoritative!)
      DUP ( RCODE) 5 = IF DROP -5 EXIT THEN \ refused operation
      DUP ( RCODE) 2 = IF DROP -7 EXIT THEN \ name server failure
      0=
      DNSREPLY @ HeaderID W@ >B< QID W@ = AND
      IF
        DNSREPLY @ HeaderANCOUNT W@ >B<
        DUP 0=
        IF
          DNSREPLY @ HeaderBits W@ >B< 128 AND \ RA - recurse available
          0= IF 
               DROP -5 \ ������ �� ��� �����, �.�. �� �������� ����� ������
                       \ � ����������� ������ ������ �� �����,
                       \ �.�. ������ ����� ����� ����� DNS-������
             THEN
        THEN
        EXIT
      THEN
    THEN
    attempts 1+ DUP -> attempts
    vDnsAttempts >
    BsReopen
  UNTIL
  NextDNS 0=
  UNTIL
  -2 \ timeouts or DNS-server failure
;

: GetDomainFromEmail
  S" @" SEARCH
  IF 1- SWAP 1+ SWAP ELSE 2DROP S" " THEN
;
: GetUserFromEmail
  2DUP S" @" SEARCH
  IF NIP - ELSE 2DROP THEN
;
: DnsValidateDomain ( domaina domainu -- flag )
  DUP 4 < IF 2DROP FALSE EXIT THEN
  2DUP TYPE-MX GetRRn 0 > IF 2DROP TRUE EXIT THEN
       TYPE-A  GetRRn 0 > IF TRUE EXIT THEN
  FALSE
;
: DnsValidateEmailDomain ( emaila emailu -- flag )
  DUP 7 < IF 2DROP FALSE EXIT THEN
  GetDomainFromEmail DnsValidateDomain
;

: DnsValidateList ( addr u -- )
  SocketsStartup DROP
  CreateUdpSocket THROW BS !
  vDnsTimeout BS @ SetUdpSocketTimeout THROW
  R/O OPEN-FILE THROW >R
  BEGIN
    TIB C/L R@ READ-LINE THROW
  WHILE
    #TIB ! >IN 0!
\    [CHAR] @ WORD DROP
    NextWord 2DUP TYPE SPACE
    DnsValidateEmailDomain . CR
  REPEAT DROP
  R> CLOSE-FILE THROW
;

: GetMXs_old ( domaina domainu -- n )
  TYPE-MX GetRRs
;
: GetMXs ( domaina domainu -- n )
  5 0 DO
    2DUP TYPE-MX GetRRs DUP 0<
    IF DnsDebug @ IF ." GetRRs error=" . CR ELSE DROP THEN
       NextDNS DROP 
    ELSE NIP NIP UNLOOP EXIT THEN
  LOOP
  2DROP -6
;
: NextMX ( -- servera serveru true | false )
  { \ pref mx }
  70000 -> pref
  RLIST @
  BEGIN
    DUP
  WHILE
    DUP RLtype @ TYPE-MX =
    IF
      DUP RLparam1 @ DUP pref < IF -> pref DUP -> mx ELSE DROP THEN
    THEN
    RLnext @
  REPEAT DROP
  pref 70000 = IF FALSE EXIT THEN
  70001 mx RLparam1 !
  mx RLhost GetFieldData TRUE
;
: DnsDomainExistsOld ( domaina domainu -- flag )
  2DUP TYPE-MX GetRRn DUP 0 > IF DROP 2DROP TRUE EXIT THEN
  DUP -3 = IF DROP 2DROP FALSE EXIT THEN
\ �� ���� �����, ���� ��� MX-������, �� � ��� ������ "��� ������"
  -2 = \ ������� - ������ �������� ��������� DNS
  IF 2DROP TRUE EXIT THEN
  TYPE-A GetRRn 0= IF FALSE EXIT THEN \ ��� MX � A, ������� ����� ��������
  TRUE \ ����� ����, ���� ������� ��������� DNS, ������ ���������� ������
\  TYPE-NS GetRRn -3 <>
;
: DnsDomainExists { domaina domainu -- flag }
  domaina domainu TYPE-MX GetRRn DUP 0 > IF DROP TRUE EXIT THEN
  DUP -3 = IF DROP FALSE EXIT THEN
\ �� ���� �����, ���� ��� MX-������, �� � ��� ������ "��� ������"
  -2 = \ ������� - ������ �������� ��������� DNS
  IF TRUE EXIT THEN
  domaina domainu TYPE-A GetRRn 0= IF FALSE EXIT THEN \ ��� MX � A, ������� ����� ��������
  TRUE \ ����� ����, ���� ������� ��������� DNS, ������ ���������� ������
\  TYPE-NS GetRRn -3 <>
;

(
\ TRUE DnsDebug !
\ -s 10.1.1.2
S" eserv.ru" DnsDomainExists . \ ���� MX
S" poil.usinsk.ru" DnsDomainExists . \ ��� MX, ���� A
S" co.nz" DnsDomainExists . \ ��� MX � ��� A
S" hotamil.com" DnsDomainExists . \ ��� MX � ��� A
S" non_existent_domain.com" DnsDomainExists . \ ��� ������
)

\ TYPE-MX host main.svlm.com swr.da.ru

\ -s ns1.granitecanyon.com
\ -s eserv.ru

\ TRUE DnsDebug !
\ S" enet.ru" TYPE-MX GetRRs PrintRLIST .
\ .( ------------) CR
\ S" enet.ru" TYPE-A GetRRs PrintRLIST .
\ .( ------------) CR
\ S" eserv.ru" TYPE-MX GetRRs PrintRLIST .
\ .( ------------) CR
\ S" non.existent.domain" TYPE-SOA GetRRs PrintRLIST .
\ S" C:\eserv2\mail\lists\eserv_drweb.txt" DnsValidateList
\ S" ac@non.exist.domain" GetDomainFromEmail DnsDomainExists .
\ S" ac@whois.eserv.ru" GetDomainFromEmail DnsDomainExists .
\ S" eserv.ru" TYPE-SOA GetRRs PrintRLIST .

\ REQUIRE STR@         ~ac/lib/str2.f

\ : TXT@ ( addr u -- addr2 u2 )
\   OVER C@ OVER < 0= IF DROP COUNT EXIT THEN
\   DROP COUNT 2DUP + COUNT 2SWAP " {s}{s}" STR@
\ ;
\ S" s1024._domainkey.yahoo.com" TYPE-TXT GetRRs . 
\ RLIST @ RLhost GetFieldData TXT@ TYPE

\ PrintRLIST .

\ =================== ���������� � ����������� ~pig (23.06.2006) =======

\ �������������� �������� ������ DNS
\ ������ ������� A-�������

: GetHosts ( namea nameu -- n ) TYPE-A GetRRs ;

\ ������� ��������� ������ ��������� ���� (���� MX, �� � ������ ����������)
\ (�� ����� ���� ��������� ��������� ������, ������ ������ ��-MX ��� ������ ���������� ����������)

: NextRR ( type -- hosta hostu true | false )
  { type \ pref rr }
  70000 -> pref					\ ���������� ���������
  RLIST @					\ ������ ������
  BEGIN
    DUP						\ ��� �� �����?
  WHILE
    DUP RLtype @ type =				\ ������ �������� ����?
    IF
      DUP RLparam1 @ DUP pref <			\ ������������ ��������?
      IF
        -> pref					\ �� - ������������� ����� ���������
        DUP -> rr				\ � ������� ������
      ELSE
        DROP					\ ��������� �� �����
      THEN
    THEN
    RLnext @					\ ��������� ������
  REPEAT
  DROP						\ ������ �� ����� �����
  pref 70000 =					\ ���� ��������� �� ���������
  IF FALSE EXIT THEN				\ ������ �� �������
  70001 rr RLparam1 !				\ ��� ������ ���������� - ������ �� ����������
  rr RLhost GetFieldData TRUE			\ ������� ��� ����� � ������� ������� ������
;

\ ������� ���������� �����

: NextHost ( -- hosta hostu true | false ) TYPE-A NextRR ;

\ �������� ������������ �������������� ����� IP-������
\ � ������ ��������� ��������������� IP-�������, ���������� �� ���

: IsNameMatchesIp ( namea nameu ip -- err false | true )
  { namea nameu ip \ sflg err }
  namea nameu GetHosts 0 MAX			\ �������� ������ A-������� ��� �����
  IF
    -1 -> sflg					\ ���� ���������� �������� �������
    BEGIN
      NextHost					\ �������� ��������� ������
    WHILE
      GetHostIP DUP				\ �������� ������ � �����
      IF
        -> err DROP				\ ��������� ��� ������ � �������� �������� ��������
      ELSE
        -> sflg					\ �������� ����� ��������� IP
        ip =					\ ���� ����������?
        IF TRUE EXIT THEN			\ �� - ������ ����� �� ������
      THEN
    REPEAT
    err sflg AND				\ ������������ ��� ������
  ELSE
    namea nameu GetHostIP ?DUP			\ ������� �������� ����� ������� ��������
    IF
      NIP					\ ��� ������ ������, � �� ���
    ELSE
      ip =					\ ����� ������� - ��������
      IF TRUE EXIT THEN				\ �������
      0						\ ������ ���
    THEN
  THEN
  FALSE						\ ����������� ��� ������
;
