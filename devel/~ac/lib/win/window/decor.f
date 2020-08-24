\ ��� ���, ��� �� ����� �������� �� ������� ����.
\ WindowRC ���������� ���� ���� � ����� GoogleTalk (��� ����� :)
\ WindowTransp ������������� ������������ � ����� Miranda.
\ WindowShadow ����������� ���� (�� ��� ���� � �����, � ��� ��������� popup'�).
\ ��. ������ � ����������� ����.

REQUIRE {             lib/ext/locals.f
REQUIRE Window        ~ac/lib/win/window/window.f

#define WS_EX_LAYERED 0x00080000
#define LWA_ALPHA     0x00000002
#define CS_DROPSHADOW 0x00020000
-26 CONSTANT GCL_STYLE

WINAPI: SetLayeredWindowAttributes USER32.DLL
WINAPI: CreateRoundRectRgn         GDI32.DLL
WINAPI: GetWindowRect              USER32.DLL
WINAPI: SetWindowRgn               USER32.DLL
WINAPI: RedrawWindow               USER32.DLL
WINAPI: GetClassLongA              USER32.DLL

: WindowTransp { val hwnd -- }
  GWL_EXSTYLE hwnd GetWindowLongA WS_EX_LAYERED OR GWL_EXSTYLE hwnd SetWindowLongA DROP
  LWA_ALPHA val 0 hwnd SetLayeredWindowAttributes DROP
;
: WindowGetSize { hwnd \ [ 4 CELLS ] rect -- dx dy }
  rect hwnd GetWindowRect DROP
  rect 3 CELLS + @ rect CELL+ @ - rect 2 CELLS + @ rect @ -
  SWAP
;
: WindowRC { rx ry hwnd -- }
\ rx ry - ������� ���������� ��������
  ry rx
  hwnd WindowGetSize SWAP
  0 0 
  CreateRoundRectRgn TRUE SWAP hwnd SetWindowRgn DROP
;
: WindowShadow { hwnd -- }
  GCL_STYLE hwnd GetClassLongA CS_DROPSHADOW OR GCL_STYLE hwnd SetClassLongA DROP
;

\EOF

: TEST
  || h ||

  S" RichEdit20A" WS_POPUP 0 Window -> h

  400 200 h WindowPos
  150 250 h WindowSize
  11   11 h WindowRC \ ��������� � ��������� ��������� ������� wdm �����,
                     \ ��� ��� RC ����� ����� ������ ��� ���� ��� ����������
      h WindowShadow
  128 h WindowTransp \ ����� �� �������� � ���������� control'���, 
                     \ ��� � ���� �������, �.�. ������������� ��� ��-��������
                     \ ����, �� � ���� � ����� ��������...
  h WindowShow
  h MessageLoop
  h WindowDelete
;
TEST