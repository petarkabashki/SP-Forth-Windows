\ ࠡ�� � ������

WINAPI: GetWindowRect user32.dll
WINAPI: GetDesktopWindow user32.dll
WINAPI: GetWindow user32.dll
WINAPI: GetWindowTextA USER32.DLL
WINAPI: GetClassNameA user32.dll
WINAPI: FindWindowExA user32.dll

REQUIRE WTHROW lib/win/winerr.f
REQUIRE WINCONST lib/win/const.f

: WindowRect@ ( hwnd -- bottom right top left )
\ ������� ���न���� 㣫�� ����
  >R
  0 0 0 0 SP@
  R>
  GetWindowRect WTHROW DROP
;

: GetWindowChild ( hwnd -- childhwnd )
\ ������� ��ࢮ� ���୥� ����
  GW_CHILD SWAP GetWindow
;

: GetWindowNext ( hwnd -- childhwnd )
\ ������� ᫥���饥 ���୥� ����
  GW_HWNDNEXT SWAP GetWindow
;

: GetWindowOwner ( hwnd -- childhwnd )
\ ������� �������� ����
  GW_OWNER SWAP GetWindow
;

: GetWindowChilds ( hwnd -- h1 ... hn n )
\ ������� �� ���୨� ����, n - �� ������⢮
  GetWindowChild
  DUP IF
    1
    BEGIN
      OVER
      GetWindowNext ?DUP
    WHILE
      SWAP 1+
    REPEAT
  THEN
;

USER-CREATE WinText 257 USER-ALLOT

: GetWindowText ( hwnd -- addr u )
\ ������� ⥪�� ���� 
  256 SWAP WinText SWAP GetWindowTextA WinText SWAP
;

USER-CREATE WinClass 257 USER-ALLOT

: GetWindowClass ( hwnd -- addr u )
\ ������� ����� ����
  256 SWAP WinClass SWAP GetClassNameA WinClass SWAP
;

: FindChildByClass ( h1 addr u -- h2 )
\ ���� ���୥� ���� �� ��� ������
  DROP
  SWAP >R
  0 SWAP
  0 R> FindWindowExA
;
  
