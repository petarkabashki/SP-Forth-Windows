\ 07.Jul.2001 Sat 02:13  Ruv
\ ������� ��������� � ������������� � ������ ���������.

REQUIRE GetMessageA  ~pinka\lib\Multi\messages.f 

[UNDEFINED] PM_REMOVE [IF]
1 CONSTANT PM_REMOVE
\ 0 CONSTANT PM_NOREMOVE
                      [THEN]

[UNDEFINED] MSG.uint [IF]
0
4 -- MSG.hwnd
4 -- MSG.uint
4 -- MSG.wparam
4 -- MSG.lparam
4 -- MSG.time
8 -- MSG.pt
CONSTANT /MSG        [THEN]

WM_USER 0x50 + CONSTANT m_receipt

[UNDEFINED] -ROT [IF]
: -ROT ROT ROT ; [THEN]

: MessageWithAck! (  x msg_num target_thread_id -- )
\ ������� ���������
\      lparam - �������� x
\      wparam - tid
\ ��������� ��������� � ������ ��������� ���������
  GetCurrentThreadId -ROT PostThreadMessageA  ERR THROW

  m_receipt DUP 0 /MSG RALLOT GetMessageA
  -1 = IF GetLastError THROW THEN
  /MSG RFREE
;

: SendMsgAck ( tid -- )
   >R  0 0  m_receipt  R> PostThreadMessageA ERR THROW
;

: ExistMsg ( msg_num_min msg_num_max 'msg -- true | false )
\ ���� ���� ��������� � ��������� ���������, ������� ��� � msg
\ � ������� true, ����� ������� false.
\ � ��������� �� MessageWithAck!
\      lparam - �������� x
\      wparam - tid
  >R SWAP PM_REMOVE -ROT  -1  R> PeekMessageA 0<>
;

: WaitMsgAck ( -- )
  m_receipt m_receipt 0 /MSG RALLOT
  GetMessageA -1 = IF GetLastError THROW THEN
  /MSG RFREE
;

: MessageWithAck@ ( msg_num_min msg_num_max --  x msg_num )
\ �������� ���������
\ ��������� ���������-���������.
   SWAP
   0 /MSG RALLOT DUP >R   GetMessageA
   -1 = IF GetLastError THROW THEN
   R@ MSG.wparam @ SendMsgAck 
   R@ MSG.lparam @
   R> MSG.uint   @
   /MSG RFREE
;


 ( Test
0 VALUE s
: _test
  GetCurrentThreadId TO s
  s . CR
  /MSG RALLOT >R
  BEGIN
    ." wait message... " CR
    0 0 MessageWithAck@
    ." received: " . . ." st: " .S CR
    WaitMessage DROP
    0 0 R@ ExistMsg IF 
      ." r2 " CR 
      R@ MSG.wparam @  SendMsgAck
                    THEN
  AGAIN
;
' _test TASK: t
: test 
  0 t START DROP
;  
 test 
 10 PAUSE \ ����� ����� ����� ���������� � ��������� s
: t  -11 10  s MessageWithAck! ; \ t t t t 
\ )
