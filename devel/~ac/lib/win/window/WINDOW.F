( 27.08.1999 ������� �. )

( ������ � ������ Windows )

REQUIRE ||             ~ac/lib/temps.f
REQUIRE CW_USEDEFAULT  ~ac/lib/win/window/winconst.f

WINAPI: CreateWindowExA      USER32.DLL
WINAPI: DestroyWindow        USER32.DLL
WINAPI: SetWindowPos         USER32.DLL
WINAPI: SetWindowTextA       USER32.DLL
WINAPI: BringWindowToTop     USER32.DLL
WINAPI: SetActiveWindow      USER32.DLL
WINAPI: SetForegroundWindow  USER32.DLL
WINAPI: GetForegroundWindow  USER32.DLL
WINAPI: ShowWindow           USER32.DLL
WINAPI: CloseWindow          USER32.DLL
WINAPI: SetWindowLongA       USER32.DLL
WINAPI: GetWindowLongA       USER32.DLL
WINAPI: GetMessageA          USER32.DLL
WINAPI: TranslateMessage     USER32.DLL
WINAPI: DispatchMessageA     USER32.DLL
WINAPI: IsWindow             USER32.DLL
WINAPI: PostMessageA         USER32.DLL
WINAPI: SendMessageA         USER32.DLL
WINAPI: CallWindowProcA      USER32.DLL
WINAPI: GetCursorPos         USER32.DLL
WINAPI: EnableWindow         USER32.DLL
WINAPI: GetParent            USER32.DLL \ owner
WINAPI: GetAncestor          USER32.DLL
WINAPI: SetClassLongA        USER32.DLL
WINAPI: GetClientRect        USER32.DLL
WINAPI: FillRect             USER32.DLL

WINAPI: InitCommonControlsEx COMCTL32.DLL

VARIABLE DEBUG

\ ----------------------------------------------
\ ���������� ���� ����������, �� �������� ��� ����� ��������

VARIABLE CC_INIT \ ����������� ������������� CommonControls
CREATE   CC_INITS 8 , BASE @ HEX FFFF , BASE !

: InitControls
  CC_INIT @ IF EXIT THEN
  CC_INITS InitCommonControlsEx DROP
  S" RICHED32.DLL" DROP LoadLibraryA DROP
  S" RICHED20.DLL" DROP LoadLibraryA DROP
  TRUE CC_INIT !
;

\ ----------------------------------------------
\ �������� ������� ����������

: Window ( class-a class-u style parent-hwnd -- hwnd )  \ 0 - ������
         \ ������� ���� ���������� ������ � �������� ��������� ��� parent
         \ ���� parent=0, �� ��������� ������������� ����
  || ca cu style par || (( ca cu style par ))
  InitControls
  0 0 0 par CW_USEDEFAULT CW_USEDEFAULT CW_USEDEFAULT CW_USEDEFAULT
  style par IF WS_CHILD OR THEN
  0 ca 0 CreateWindowExA
;
\ ������: S" RichEdit" WS_OVERLAPPEDWINDOW 0 Window


: WindowDelete ( hwnd -- )
               \ ������� ����
  DestroyWindow DROP
;


: WindowPos ( x y hwnd -- )
            \ ���������� ������� ����
  || x y hwnd || (( x y hwnd ))
  SWP_NOZORDER SWP_NOSIZE OR 0 0 y x 0 hwnd SetWindowPos DROP
;


: WindowSize ( dx dy hwnd -- )
             \ ���������� ������� ����
  || dx dy hwnd || (( dx dy hwnd ))
  SWP_NOZORDER SWP_NOMOVE OR dy dx 0 0 0 hwnd SetWindowPos DROP
;


: WindowToTop ( hwnd -- )
              \ ��������� ���� ������ ������ 
              \ �� �� ������ �� ���������� ���� � ������ ����������
  BringWindowToTop DROP
;


: WindowActivate ( hwnd -- )
                 \ �������������� ����
  SetActiveWindow DROP
;


: WindowToForeground ( hwnd -- )
                     \ �������� �������� ����� ���������� ���� :)
                     \ ������������� ������ ��� ����������� ���������
                     \ �� � Windows 2000 ����� SetActiveWindow+FlashWindowEx
  SetForegroundWindow DROP
;

: WindowShow ( hwnd -- )
             \ �������� ����
  SW_SHOW SWAP ShowWindow DROP
;


: WindowHide ( hwnd -- )
             \ �������� ���� (������� ���������, �� �� ����������)
  SW_HIDE SWAP ShowWindow DROP
;

: WindowEnable ( hwnd -- )
             \ ��������� ����
  1 SWAP EnableWindow DROP
;


: WindowDisable ( hwnd -- )
             \ ��������� ���� (�� ����� �������� ����� �����)
  0 SWAP EnableWindow DROP
;

: WindowMinimize ( hwnd -- )
                 \ �������� ����
  CloseWindow DROP
;


: WindowRestore ( hwnd -- )
                \ ���������� ���� �����
  SW_RESTORE SWAP ShowWindow DROP
;


: WindowStyle ( ws hwnd -- )
              \ ���������� ����� ����
              \ �� ������ ����� ����� ���������� ����� �������� ���� :(
  GWL_STYLE SWAP SetWindowLongA DROP
;


: WindowExStyle ( ws hwnd -- )
                \ ���������� �������������� ����� ����
  GWL_EXSTYLE SWAP SetWindowLongA DROP
;

: MessageLoop ( wnd -- )
              \ ��������� ���������, ����������� � ������� ����
  || wnd mem || (( wnd ))
  /MSG ALLOCATE THROW -> mem
  BEGIN
    wnd IsWindow
    IF
      0 0 wnd mem GetMessageA 0 >
      mem CELL+ @ WM_CLOSE <> AND
      mem CELL+ @ WM_QUIT <> AND
    ELSE FALSE THEN
  WHILE
    DEBUG @ IF mem CELL+ @ WM_SYSTIMER <> IF mem 16 DUMP CR THEN THEN
    mem TranslateMessage DROP
    mem DispatchMessageA DROP
  REPEAT
  mem FREE THROW
;
: WindowSubclass ( xt wnd -- )
  || xt wnd || (( xt wnd ))
  xt GWL_WNDPROC wnd SetWindowLongA
  GWL_USERDATA wnd SetWindowLongA DROP
;
: WindowOrigProc ( ... wnd -- )
  GWL_USERDATA SWAP GetWindowLongA CallWindowProcA
;

( ������ 
: TEST
  || h ||

  S" RichEdit20A" SPF_STDEDIT 0 Window -> h
  500000 0 EM_EXLIMITTEXT h PostMessageA DROP

  400 200 h WindowPos
  150 250 h WindowSize
  h WindowShow
  h WindowMinimize
  h WindowRestore
  h MessageLoop
  h WindowDelete
;
)