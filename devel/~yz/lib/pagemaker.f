\ ��������������� ������� - ������������� � PageMaker
REQUIRE dde-connect ~yz/lib/ddeclient.f
REQUIRE msgbox      ~yz/lib/msgbox.f
REQUIRE PARSE...    ~yz/lib/parse.f

USER-VALUE pmaker
USER-CREATE request 5000 USER-ALLOT

: PMconnect ( -- ?)
  dde-init DROP
  " PageMaker" " notopic" dde-connect
  IF 0 EXIT THEN \ ��������� ������ ��� �����������
  DUP TO pmaker ; 

: PMdisconnect ( -- )
  pmaker dde-disconnect DROP
  dde-destroy ;

USER-CREATE request-str 128 USER-ALLOT

WINAPI: DdeQueryConvInfo USER32.DLL
WINAPI: DdeGetLastError  USER32.DLL

\ : ddeinfo ( hconv -- )
\  16 CELLS HERE !
\  HERE -1 ROT DdeQueryConvInfo ." info=" .
\ ;

: PMrequest-loop { z -- z/0 }
  BEGIN
    z pmaker dde-request ( -- z 0 / 0 0 / err)
    ?DUP IF
      0x4002 ( ddedatatimeout) <>
      IF 0 EXIT THEN \ ��������� ������, �� �� ����-��� 
    ELSE
      \ �������� ���������� ������
      ?DUP IF EXIT THEN
    THEN
    1000 PAUSE
  AGAIN ;

: last-pm-error ( -- )
   " GetLastErrorStr" PMrequest-loop
  >R
  R@ DUP ZLEN " \q \q" DUP ZLEN COMPARE
  IF " PageMaker �������� �� ������" R@ msgbox THEN
  R> FREEMEM
;

: PMrequest ( z -- z/0 ) 
  PMrequest-loop DUP IF
    DUP request ZMOVE FREEMEM request
  ELSE
    500 PAUSE
    last-pm-error
  THEN
;

\ ��� PM ������ ����� ��������
: PMexecute ( z -- )  PMrequest DROP ;

\ ������ �����, ������������ PageMaker

: parsed ( -- n / a #)
  PeekChar c: " = IF
    c: " WORD COUNT c: , SKIP
  ELSE
    c: , WORD COUNT DUP IF EVALUATE THEN
  THEN
;
