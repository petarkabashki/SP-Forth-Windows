( 25.04.2001 [C] Andrey Cherezov mailto:spf@users.sourceforge.net )
( ForEachIP - ���������� ��������� �������� ��� ������� IP �����,
              �� ������� ��� �����������. ���������, �����������
              ���� ������, ������ ����� ������� 3 IP:
              127.0.0.1     [������] - localhost
              10.1.1.1      [������] - ����� LAN-����������
              194.186.20.62 [������] - ����� WAN-����������
)
\ ��������� 23.01.2002: �������� ExternIP ��� ��� ����������,
\ ��� �������� �� NAT-proxy, �� ����� ������� ��� IP �����

\ ��������� 30.10.2008: �������� ExternIPs ��� ��� ����������,
\ � ���� ������� IP �� ����� ������, �� ���������� ������ �� NAT'��.

REQUIRE {            ~ac/lib/locals.f
REQUIRE CreateSocket ~ac/lib/win/winsock/sockets.f

VARIABLE ExternIP
VARIABLE ExternIPs

: ExternIP:
  NextWord 2DUP + 0 SWAP C!
  GetHostIP IF DROP 0 THEN
  ExternIP !
;
: EIP,
  ExternIPs @ 0= 
  IF HERE ExternIPs ! THEN
  2DUP + 0 SWAP C!
  GetHostIP IF DROP EXIT THEN
  ,
;
: ExternIPs:
  BEGIN
    BL WORD DUP C@
  WHILE
    COUNT EIP,
  REPEAT DROP 0 ,
;

: ForEachIP { xt \ addr -- ior }
\ xt - ��������� ( IP -- ), ����������� ��� ������� IP
  255 PAD gethostname 0=
  IF \ PAD ASCIIZ> TYPE ."  - localhost name" CR
     PAD gethostbyname
     DUP IF -> addr
            \ addr @ ASCIIZ> TYPE ."  - domain name" CR
            0
            addr @
            addr CELL+ CELL+ CELL+ @ @
            DO I @ 4 +LOOP
            0x0100007F xt EXECUTE \ localhost
            ExternIP @ ?DUP IF xt EXECUTE THEN
            ExternIPs @ ?DUP IF BEGIN DUP @ WHILE DUP @ xt EXECUTE CELL+ REPEAT DROP THEN
            BEGIN
              DUP
            WHILE
              \ HostName. CR
              xt EXECUTE
            REPEAT
         ELSE DROP WSAGetLastError THEN
  ELSE WSAGetLastError THEN
;
: IsLocalhost ( ip -- flag )
  0xFF AND 0x7F =
;
: IsMyIP { ip \ addr sp -- flag }
  ip ( 0x0100007F =) IsLocalhost IF TRUE EXIT THEN
  ExternIP @ ?DUP IF ip = IF TRUE EXIT THEN THEN
  ExternIPs @ ?DUP IF BEGIN DUP @ WHILE DUP @ ip = IF DROP TRUE EXIT THEN CELL+ REPEAT DROP THEN
  255 PAD gethostname 0=
  IF 
     PAD gethostbyname
     DUP IF -> addr
            SP@ -> sp
            0
            addr @
            addr CELL+ CELL+ CELL+ @ @
            DO I @ 4 +LOOP
            BEGIN
              DUP
            WHILE
              ip = IF sp SP! TRUE EXIT THEN
            REPEAT
         ELSE DROP FALSE THEN
  ELSE FALSE THEN
;
: IsMyHostname ( addr u -- flag )
  GetHostIP IF DROP FALSE EXIT THEN
  IsMyIP
;
: IsMyHostnameAndNotLocalhost ( addr u -- flag )
  GetHostIP IF DROP FALSE EXIT THEN
  DUP 0xFF AND 0x7F = IF DROP FALSE EXIT THEN
  IsMyIP
;

\EOF
SocketsStartup . CR 
ExternIP: 194.186.20.1
ExternIPs: 195.135.212.210 195.135.212.211 195.135.212.212 195.135.212.6
: TEST NtoA TYPE SPACE ; ' TEST ForEachIP CR . CR
:NONAME SOURCE TYPE ." =>" ; TO <PRE>
1 IsMyIP . CR
S" 127.0.0.1" GetHostIP THROW IsMyIP . CR
S" 127.0.0.5" GetHostIP THROW IsMyIP . CR
S" 10.1.1.1" GetHostIP THROW IsMyIP . CR
S" ac" IsMyHostname . CR
S" rainbow" IsMyHostname . CR
S" localhost" IsMyHostname . CR
S" somehost.com" IsMyHostname . CR
S" rainbow.koenig.ru" IsMyHostname . CR
S" 194.186.20.1" IsMyHostname . CR
S" 195.135.212.212" IsMyHostname . CR
S" ns.enet.ru" IsMyHostname . CR
0 IsMyIP . CR
