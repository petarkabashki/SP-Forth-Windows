\ File Name: tm_com.f
\ ������ ����� COM � ������������� "���������"
\ ���������� �.�.
\ v 0.7	�� 29.09.2004�.
\ v 0.8	�� 07.10.2004�.
\ + � tmTUp � tmTUe ��������� ����� ��������� ������ ������
\ v 0.9 �� 05.01.2005�. 
\ + ��������� ����� SETCOMMMASK � WAITCOMMEVENT
\ v 1.0 �� 16.11.2005�.
\ ! ��������� � ������ COM-WRITE ������ THROW ����� DROP
\ 	COM-READ-L ������ THROW ����� IF DROP 0 TO cbr ELSE TO cbr THEN
\ v 1.1 �� 22.11.2005�.
\ ! ��������� � ����� COM-WRITE ������ DROP �������� IF PurgeTrs THEN, �.� 
\ ������ ����� �������� ��� ������ ������
S" ~ilya\lib\winmodem.f" INCLUDED

WINAPI: CreateEventA KERNEL32.DLL 
WINAPI: WaitForSingleObject KERNEL32.DLL 
WINAPI: GetOverlappedResult KERNEL32.DLL 
VARIABLE CBR
0 VALUE _brk-com-read	\ ���� �� ����������� �������� � ����� COM-READ-NL 
VARIABLE MASK

: SETCOMMMASK ( mask -- ) com-handle SetCommMask DROP ;
: WAITCOMMEVENT 0  com_event com-handle WaitCommEvent DROP ;
: GETCOMMMASK  MASK com-handle GetCommMask DROP MASK @ ;

0
    WORD1  wPacketLength       \ packet size, in bytes 
    WORD1  wPacketVersion      \ packet version 
    DWORD dwServiceMask       \ services implemented 
    DWORD dwReserved1         \ reserved 
    DWORD dwMaxTxQueue        \ max Tx bufsize, in bytes 
    DWORD dwMaxRxQueue        \ max Rx bufsize, in bytes 
    DWORD dwMaxBaud           \ max baud rate, in bps 
    DWORD dwProvSubType       \ specific provider type 

    DWORD dwProvCapabilities  \ capabilities supported 
    DWORD dwSettableParams    \ changable parameters 
    DWORD dwSettableBaud      \ allowable baud rates 
    WORD1  wSettableData       \ allowable byte sizes 
    WORD1  wSettableStopParity \ stop bits/parity allowed 
    DWORD dwCurrentTxQueue    \ Tx buffer size, in bytes 
    DWORD dwCurrentRxQueue    \ Rx buffer size, in bytes 
    DWORD dwProvSpec1         \ provider-specific data 
    DWORD dwProvSpec2         \ provider-specific data 

    1 -- wcProvChar       \ provider-specific data 
     CONSTANT _COMMPROP 
 CREATE COMMPROP _COMMPROP ALLOT


: PurgeRcv
\ PURGE_TXCLEAR com-handle PurgeComm
PURGE_RXCLEAR com-handle PurgeComm DROP
;
: PurgeTrs
PURGE_TXCLEAR com-handle PurgeComm DROP
\ PURGE_RXCLEAR com-handle PurgeComm DROP
;


\ ����� ������� �� �����
: CommIn ( -- char ) \ WaitComm
\ SETRTS com-handle EscapeCommFunction DROP
\ WAITCOMMEVENT
ComReadBuffer 1 com-handle  READ-FILE THROW  ComReadBuffer C@
\ CLRRTS com-handle EscapeCommFunction DROP
;

	
: Com-Read \ { addr n  -- }
0 TO cbr
 \ EV_RLSD ( EV_CTS OR ) SETCOMMMASK
 OVER + SWAP ?DO
CommIn I C! DROP
cbr 1+ TO cbr
\ 30 10 AT-XY ." I=" I .
LOOP

;
: OPEN-FILE-OVER ( c-addr u fam -- fileid ior ) \ 94 FILE
\ ������� ���� � ������, �������� ������� c-addr u, � ������� ������� fam.
\ ����� �������� fam ��������� �����������.
\ ���� ���� ������� ������, ior ����, fileid ��� �������������, � ����
\ �������������� �� ������.
\ ����� ior - ������������ ����������� ��� ���������� �����/������,
\ � fileid �����������.


  NIP SWAP >R >R
  0 FILE_FLAG_OVERLAPPED
  OPEN_EXISTING
  0 ( secur )
  0 ( share )  
  R> ( access=fam )
  R> ( filename )
  CreateFileA DUP -1 = IF GetLastError ELSE 0 THEN
  CR ." Open OK" .S CR
;
: READ-FILE-OVER ( c-addr u1 fileid -- u2 ior ) \ 94 FILE
\ �������� u1 �������� � c-addr �� ������� ������� �����,
\ ����������������� fileid.
\ ���� u1 �������� ��������� ��� ����������, ior ���� � u2 ����� u1.
\ ���� ����� ����� ��������� �� ��������� u1 ��������, ior ����
\ � u2 - ���������� ������� ����������� ��������.
\ ���� �������� ������������ ����� ��������, ������������
\ FILE-POSITION ����� ��������, ������������� FILE-SIZE ��� �����
\ ����������������� fileid, ior � u2 ����.
\ ���� �������� �������������� ��������, �� ior - ������������ �����������
\ ��� ���������� �����/������, � u2 - ���������� ��������� ���������� �
\ c-addr ��������.
\ �������������� �������� ���������, ���� �������� �����������, �����
\ ��������, ������������ FILE-POSITION ������ ��� ��������, ������������
\ FILE-SIZE ��� �����, ����������������� fileid, ��� ��������� ��������
\ �������� �������� ������������ ����� �����.
\ ����� ���������� �������� FILE-POSITION ��������� ��������� �������
\ � ����� ����� ���������� ������������ �������.
S" com-event" DROP 0 0 0 CreateEventA
overlap hEvent !
  >R 2>R
overlap lpNumberOfBytesRead R> R> R@ 
  ReadFile CR ." Read=>" CR .S CR  ERR
  0xFFFF overlap hEvent @ WaitForSingleObject .
  \ lpNumberOfBytesRead @ SWAP
  TRUE CBR overlap R> GetOverlappedResult CR ." Rez=" .
  CBR @ FALSE
;

: WRITE-FILE-OVER ( c-addr u fileid -- ior ) \ 94 FILE
\ �������� u �������� �� c-addr � ����, ���������������� fileid,
\ � ������� �������.
\ ior - ������������ ����������� ��� ���������� �����-������.
\ ����� ���������� �������� FILE-POSITION ���������� ���������
\ ������� � ����� �� ��������� ���������� � ���� ��������, �
\ FILE-SIZE ���������� �������� ������� ��� ������ ��������,
\ ������������� FILE-POSITION.
 \ OVER >R
  >R 2>R
S" com-event" DROP 0 0 0 CreateEventA
overlap hEvent !

overlap lpNumberOfBytesWritten R> R> R> DUP ." hand=" .
  WriteFile CR DUP . ." write=>" .lerr ERR ( ior )
   0xFFFF overlap hEvent @ WaitForSingleObject .
   FALSE
   CR ." After write" .S ." <=" CR
  \ ?DUP IF RDROP EXIT THEN
  \ lpNumberOfBytesWritten @ R> <>
  ( ���� ���������� �� �������, ������� �����������, �� ���� ������ )
;

\ ������� ��� ����
: COM-OPEN ( cadr cn -- )
R/W OPEN-FILE THROW TO com-handle
;
\ ������� ��� ����
: COM-OPEN-OVER ( cadr cn -- )
R/W OPEN-FILE-OVER THROW TO com-handle
;
: COM-CLOSE
	com-handle CLOSE-FILE THROW
	\ esc-buf-size 0= IF ELSE esc-buf FREEMEM THEN
;

\ �������� � ��� ���� n - ���� ������� � ������ adr
: COM-WRITE ( adr n -- ior )
\ DROP
EV_RXCHAR EV_TXEMPTY OR SETCOMMMASK
esc-buf cbs com-handle WRITE-FILE  IF PurgeTrs THEN 
10000 0 DO
\ 1 PAUSE
GETCOMMMASK EV_TXEMPTY AND
IF LEAVE THEN
LOOP
;

\ �������� � ��� ���� n - ���� ������� � ������ adr
: COM-WRITE-OVER ( adr n -- ior )
esc-buf cbs com-handle WRITE-FILE-OVER  THROW 
;

\ ��������� �� ��� ����� n - ���� �� ������ adr
\ � ����-�����
: COM-READ-L	{ n -- } ( n -- ior )
\ EV_RXCHAR SETCOMMMASK
EV_RXCHAR EV_TXEMPTY OR SETCOMMMASK
\ S" com-event" DROP 0 0 0 CreateEventA DROP
\ GetTickCount
\ WAITCOMMEVENT GetTickCount SWAP - CR ." com_event=" com_event @ . .
10000 0 DO
\ 1 PAUSE
GETCOMMMASK EV_RXCHAR AND
IF LEAVE THEN
LOOP
10000
BEGIN
\ 1 PAUSE
CLEARCOMMERROR
\ LPCOMSTAT fBinState @ CR ." fBinState=" .H
LPCOMSTAT  cbInQue @ \ DUP  ." cbInQue=" .   \ DUP CR n . ." cbInQue=" . CR
n 1- >  SWAP 1- SWAP OVER 0= OR
UNTIL
DROP
rcv-buf
n com-handle  READ-FILE  IF  DROP 0 TO cbr ELSE TO cbr THEN 
;

\ ��������� �� ��� ����� n - ���� �� ������ adr
\ ��� ����-����
: COM-READ-NL	{ n -- } ( n -- ior )
0 TO _brk-com-read
BEGIN
\ 1 PAUSE
CLEARCOMMERROR
\ LPCOMSTAT fBinState @ CR ." fBinState=" .H
LPCOMSTAT  cbInQue @  \ DUP CR n . ." cbInQue=" . CR
n 1- > _brk-com-read OR
UNTIL
rcv-buf
n com-handle  READ-FILE THROW TO cbr
;

VECT COM-READ
' COM-READ-L TO COM-READ

\ ��������� �� ��� ����� n - ���� �� ������ adr
: COM-READ-OVER	( n -- ior )
rcv-buf SWAP 
com-handle  READ-FILE-OVER CR ." st=" .S THROW TO cbr
;

: COM-INIT1 { sp -- }
	( S" COM1") COM-OPEN
	200 com-handle SetTimeOut THROW
	( 38400) sp 8 2 0 com-handle SetModemParameters THROW
	
;

: ModemStatus ( adr -- )
com-handle GetCommModemStatus 0= IF 1 THROW THEN
;



: PurgeSnd
( PURGE_RXCLEAR) PURGE_TXABORT	 com-handle PurgeComm DROP
;
: SetCommBreak com-handle SetCommBreak DROP ;
: ClearCommBreak com-handle ClearCommBreak DROP ;
