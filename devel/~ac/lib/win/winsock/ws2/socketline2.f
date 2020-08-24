( ���������� ��� ����������� ����������������� ������ �� ������.
  Copyright 1996-1999 A.Cherezov ac@eserv.ru
)

REQUIRE { ~ac/lib/locals.f
REQUIRE CreateSocket ~ac/lib/win/winsock/ws2/sockets.f

10000 VALUE LINE_BUFF_SIZE         \ ������ ������

0                                  \ ��������� "�������� �����"
4 -- sl_socket                     \ �������� �����
4 -- sl_point                      \ �������� � ������ ������� ������� ������
4 -- sl_last                       \ ����� � ������ ������� ������� �������
CONSTANT /sl


\ SocketLine �������������� ����� ��� ����������� ������ ��������� ������
\ � ���������� ����� ���� ���������

: SocketLine ( socket -- addr-S )
  { \ addr }
  LINE_BUFF_SIZE /sl + ALLOCATE THROW -> addr
  addr sl_socket !
  addr sl_point 0!
  addr /sl + addr sl_last !
  addr
;

\ SocketGetPending �������� �� ������ ��, ��� ��� ��������,
\ �� ����� ���������� � ������

: SocketGetPending ( addr-S -- addr1 u1 )
  { addr }
  addr sl_last @
  addr /sl + addr sl_point @ + OVER - 0 MAX
;

\ SocketReadFromPending �������� �� ���������� � ������ ������
\ �� ����� u1 ����
\ ��������� ����������, �.�. ��� ������ "���������" �� ������.

: SocketReadFromPending ( u1 addr-S -- addr1 u2 ) \ u2 <= u1
  { u1 addr }
  addr SocketGetPending NIP u1 > 0=
  IF addr SocketGetPending
     addr sl_point 0!
     addr /sl + addr sl_last !
  ELSE
     addr SocketGetPending u1 MIN
     addr sl_last @ OVER + addr sl_last !
  THEN
;

\ SocketContRead
\

: SocketContRead1 ( addr-S -- )
  { addr \ a u }
  addr SocketGetPending
  OVER C@ 10 ( LF ) = OVER 0 > AND IF 1- SWAP 1+ SWAP THEN -> u -> a
  a addr /sl + u MOVE
  addr /sl + addr sl_last !

  addr /sl + u +
  LINE_BUFF_SIZE u -
  DUP 0 > 
  IF
    addr sl_socket @ ReadSocket THROW
    u + addr sl_point !
  ELSE 2DROP THEN
;
: SocketContRead ( addr-S -- )
  { addr \ a u }
  addr SocketGetPending -> u -> a
  a addr /sl + u MOVE
  addr /sl + addr sl_last !

  addr /sl + u +
  LINE_BUFF_SIZE u -
  addr sl_socket @ ReadSocket
\  DUP 10060 = IF a u DUMP CCR THEN
  THROW
  u + addr sl_point !
;

\ SocketReadLine ������ ������, ������������ LF ��� CRLF
\ ��� ������������ � ������������ ������ �� ����������.
\ ���� ������ �������� ������� ������, �� ����������� ��
\ ������, �� ������ ������� �� ������� �����. ������� �����
\ ���������� ���������� �������� ���� �������.
\ ���� ����������� �� ������, � � ������ ��� ���� ����
\ ������, �� ������������ �������� ������ �� ������ 
\ (�������� �����������). ����� ����� ������� ����������
\ ���������� ���� � ���� ��� �������� ������� �����������, � �.�.
\ ���� ����� �������, � ������ �� ������ ���������� ������� 
\ ��������, �� �������� ������� ������� ����������� �������...

: SocketReadLine ( addr -- addr1 u1 )
  { addr \ pa1 pu1 acr }
  addr SocketGetPending -> pu1 -> pa1
  pa1 pu1 LT 1+ 1 SEARCH
  IF
      DROP -> acr
      acr 1+ addr sl_last !
      pa1 acr OVER - 2DUP + 1- C@ 13 = IF 1- 0 MAX THEN
  ELSE
     2DROP
     pu1 LINE_BUFF_SIZE = 
     IF
        addr sl_point 0!
        addr /sl + addr sl_last !
        pa1 pu1 EXIT
     THEN
     addr SocketContRead addr RECURSE
  THEN
;
: CreateServerSocket ( port -- socket )
  { port \ s }
  CreateSocket THROW -> s
  port s BindSocket THROW
  s ListenSocket THROW
  s
;
