WINAPI: CreateIoCompletionPort     KERNEL32.DLL
WINAPI: GetQueuedCompletionStatus  KERNEL32.DLL
WINAPI: PostQueuedCompletionStatus KERNEL32.DLL

: CREATE-CP ( max-threads -- h ior )
  0 0 INVALID_HANDLE_VALUE CreateIoCompletionPort
  DUP ERR
;
USER ucpOver
USER ucpKey
USER ucpBytes

258 CONSTANT WAIT_TIMEOUT

: GET-CP ( time h -- flag ior )
  \ ���������� ior=0, ���� ��� ������. ��� ���� flag=true, ���� ��� 
  \ ������� �������� (�� ���� ������� �� time ms)
  \ ��� ����� ������� ior<>0, � flag �� ���������.

  >R ucpOver ucpKey ucpBytes R> GetQueuedCompletionStatus
  0= IF \ ������� ��� ������
        GetLastError DUP WAIT_TIMEOUT =
        IF DROP TRUE 0 ELSE 0 SWAP THEN
     ELSE 0 0 THEN
;
: POST-CP ( over key bytes h -- ior )
  \ � ������ ior ������ =0, ���� ������� ������������ �������
  \ (�� ����������� ����� WAIT-CP) �� ���������� "�������" :)
  \ ��. TEST1
  \ ������ ����� �������� 3 ���������, �������� over key bytes
  \ �� � ���� �� ���������, ���� ���� �� � ������.

  PostQueuedCompletionStatus ERR
;
\EOF

\ ���������� ����, ������������, ��� ������� �������� �����
\ ��������� ��������������� (1000 - �� ��������). � ��������
\ ���������� � ��� �� �������, � ������� ����������.

: TEST1
  10 CREATE-CP THROW >R

  1000 BEGIN
    DUP 2 3 R@ POST-CP ." post:" .
  1- DUP 0= UNTIL DROP

  BEGIN
    5000 R@ GET-CP THROW 0=
  WHILE
    ucpOver @ .
  REPEAT ." timeout" 
  R> CLOSE-FILE THROW
;

WINAPI: GetCurrentThreadId KERNEL32.DLL

:NONAME ( cp -- ior )
  >R
  BEGIN
    BEGIN
      -1 R@ GET-CP THROW
    WHILE
\      CR GetCurrentThreadId . ." idle..."
    REPEAT
    CR GetCurrentThreadId . ." :" ucpOver @ .
  AGAIN
  RDROP
; TASK: CP-READER

: TEST2
  10 CREATE-CP THROW
  10 0 DO
    DUP CP-READER START CLOSE-FILE THROW 100 PAUSE
  LOOP
  >R
  1000 BEGIN
    DUP 2 3 R@ POST-CP THROW
    1 PAUSE
  1- DUP 0= UNTIL DROP
  RDROP
;
