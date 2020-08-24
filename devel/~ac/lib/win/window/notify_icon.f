\ 21.07.08: ��������� � ���������� API ����� 99�� ����
\ fixme: ��������� �������� ������ �� Vista...

REQUIRE Window    ~ac/lib/win/window/window.f
REQUIRE LoadIcon  ~ac/lib/win/window/image.f
REQUIRE TrackMenu ~ac/lib/win/window/popupmenu.f

WINAPI: Shell_NotifyIcon SHELL32.DLL

0 CONSTANT NIM_ADD
1 CONSTANT NIM_MODIFY
2 CONSTANT NIM_DELETE

1 CONSTANT NIF_MESSAGE
2 CONSTANT NIF_ICON
4 CONSTANT NIF_TIP
0x00000010 CONSTANT NIF_INFO

0x00000004 CONSTANT NIIF_USER
0x00000001 CONSTANT NIIF_INFO

0
4 -- cbSize
4 -- hWnd
4 -- uID
4 -- uFlags
4 -- uCallbackMessage
4 -- hIcon
128 -- szTip \ �� W2K ���� 64
  4 -- dwState
  4 -- dwStateMask
256 -- szInfo
  4 -- uTimeout/Version
 64 -- szInfoTitle
  4 -- dwInfoFlags
 16 -- guidItem     \ XP
  4 -- hBalloonIcon \ Vista
CONSTANT /NOTIFYICONDATA

HERE CONSTANT IconID

CREATE IconData /NOTIFYICONDATA ALLOT
  /NOTIFYICONDATA IconData cbSize !
  IconID IconData uID !
  NIF_MESSAGE NIF_ICON OR NIF_TIP OR NIF_INFO OR IconData uFlags !
  10000 IconData uTimeout/Version !
  NIIF_INFO DROP NIIF_USER IconData dwInfoFlags !

: TrayIconSetTitle ( addr u -- )
\ ���������� ��������� balloon tooltip'� (����� ������� ��������� ������)
  IconData szInfoTitle SWAP 1+ MOVE
;
S" SPF" TrayIconSetTitle

: TrayIconDelete ( -- )
  IconData NIM_DELETE Shell_NotifyIcon DROP
;
: TrayIconCreate ( addr u icona iconu cmd hwnd -- )
  || a u ia iu cmd h mem || (( a u ia iu cmd h ))
  IconData -> mem
  h mem hWnd !
  cmd mem uCallbackMessage !
  ia iu LoadIcon mem hIcon !
  mem szTip 128 ERASE a mem szTip u 127 MIN MOVE
  TrayIconDelete
  mem NIM_ADD Shell_NotifyIcon DROP
;
: TrayIconCreateFromResource ( addr u iconid cmd hwnd -- )
  || a u id cmd h mem || (( a u id cmd h ))
  IconData -> mem
  h mem hWnd !
  cmd mem uCallbackMessage !
  id LoadIconResource16 DUP mem hIcon ! mem hBalloonIcon !
  mem szTip 128 ERASE a mem szTip u 127 MIN MOVE
  mem szInfo 256 ERASE a mem szInfo u 255 MIN MOVE
  TrayIconDelete
  mem NIM_ADD Shell_NotifyIcon DROP
;
: TrayIconMessage ( addr u -- )
\ �������� ��������� � ��������� ���������� � tray ������
  || a u mem || (( a u ))
  IconData -> mem
  mem szTip 128 ERASE a mem szTip u 127 MIN MOVE
  mem szInfo 256 ERASE a mem szInfo u 255 MIN MOVE
  mem NIM_MODIFY Shell_NotifyIcon DROP
;
: TrayIconModify ( addr u icona iconu cmd hwnd -- )
  || a u ia iu cmd h mem || (( a u ia iu cmd h ))
  IconData -> mem
  h mem hWnd !
  cmd mem uCallbackMessage !
  ia iu LoadIcon DUP mem hIcon ! mem hBalloonIcon !
  mem szTip 128 ERASE a mem szTip u 127 MIN MOVE
  mem szInfo 256 ERASE a mem szInfo u 255 MIN MOVE
  mem NIM_MODIFY Shell_NotifyIcon DROP
;
: TrayIconModifyText ( addr u cmd hwnd -- )
  || a u cmd h mem || (( a u cmd h ))
  IconData -> mem
  h mem hWnd !
  cmd mem uCallbackMessage !
  mem szTip 128 ERASE a mem szTip u 127 MIN MOVE
  mem szInfo 256 ERASE a mem szInfo u 255 MIN MOVE
  mem NIM_MODIFY Shell_NotifyIcon DROP
;

\ S" ��� ������" S" ico\mail10.ico" 1997 S" STATIC" 0 0 Window TrayIconCreate KEY DROP TrayIconDelete

\EOF
S" ��� ������" 1 1 S" STATIC" 0 0 Window TrayIconCreateFromResource 
3000 PAUSE
S" ��� �����������" TrayIconMessage KEY DROP TrayIconDelete
