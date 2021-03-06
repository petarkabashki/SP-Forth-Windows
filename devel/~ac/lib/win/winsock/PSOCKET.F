( ������ � �������� � ����� PHP.  Andrey Cherezov 30.Mar.2000

  fsockopen < server port -- socketline >
    ��������: " www.forth.org.ru" 80 fsockopen -> s
    - ����������� � �������� server �� ����� port � ������� ����������� �����.

  fclose < socketline -- >
    - ������� ����� � �������������� ��������� ��� ����������
    - ��� ��� ������� ��� ����� graceful close, �.�. ���������� ��������

  fputs < str socketline -- >
    �������� " MAIL FROM:<ac@forth.org.ru>{CRLF}" s fputs
    - ��������� ������ str � ����� socketline

  fgets < socketline -- str >
    - �������� ������ �� ������

  ��� ����� throwable - � ������ ����� ������ ����������� THROW.
  ���� �������� ������ �� ������� ���������� ���������.

  �������������� ������ TEST � ����� ������.

)

REQUIRE CreateSocket ~ac/lib/win/winsock/sockets.f
REQUIRE SocketLine   ~ac/lib/win/winsock/socketline2.f
REQUIRE STR@         ~ac/lib/str5.f

\ socketline - ������ ������ �� ���� ���������
\ ����������� ���������, �������� ���.������ ��� �����������

: fsock ( socketline -- socket )
  sl_socket @
;
: fsockopen_old ( server port -- socketline )
  { server port \ sock ip }
  server STR@ GetHostIP THROW -> ip
  CreateSocket THROW -> sock
  ( 60000) TIMEOUT @ DUP 0= IF DROP 60000 THEN
  sock SetSocketTimeout THROW
  ip port sock ConnectSocket 
  ?DUP IF sock CloseSocket DROP THROW THEN
  sock SocketLine
;
: fsockopen ( server port -- socketline )
  SWAP STR@ ROT ConnectHost THROW
  SocketLine
;
\ : fclose ( socketline -- )
\   fsock CloseSocket THROW
\ ;
: fclose ( socketline -- )
\ fixed by Sergey Shisminzev [sergey@michint.kiev.ua]
  DUP fsock CloseSocket THROW  \ ����� DROP
  FREE THROW
;
: fast-fclose ( socketline -- )
\ fixed by Sergey Shisminzev [sergey@michint.kiev.ua]
  DUP fsock FastCloseSocket THROW  \ ����� DROP
  FREE THROW
;
: fputs ( str socketline -- )
  { str sock }
  str STR@
  sock fsock WriteSocket THROW
;
\ : fgets ( socketline -- str )
\   { sock \ str }
\   "" -> str
\   sock SocketReadLine str STR!
\   str
\ ;
: fgets ( socketline -- str ) \ ~ruv 13.02.2002
  { sock \ str }
  sock SocketReadLine
  "" -> str  str STR!
  str
;


( \ ������: ��������� � ���������� ���-������� � ������ 20 ����� ������

: TEST
  { \ s }
  SocketsStartup THROW
  " localhost" 80 fsockopen -> s
" GET / HTTP/1.0
Connection: close

" s fputs
  20 0 DO s fgets STYPE CR LOOP
  s fclose
;
)