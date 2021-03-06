REQUIRE CONST ~micro/lib/const/const.f
REQUIRE WINCONST lib/win/const.f

: SETMOD
\ ��⠭���� ०��� ���᮫�
  H-STDIN STREAM-FILE SetConsoleMode ERR ABORT" Wrong console mode."
;

WINAPI: PeekConsoleInputA KERNEL32.DLL
WINAPI: ReadConsoleA kernel32.dll

: PeekCon
\ ����� ᮡ�⨥ �� ���� ���᮫� � ��⠢��� ��� � ����
  NumberOfRecordsRead 1 INPUT_RECORD H-STDIN STREAM-FILE PeekConsoleInputA ERR THROW
;

: ReadCon
\ ����� ᮡ�⨥ �� ���� ���᮫� � 㤠���� ��� �� ����
  NumberOfRecordsRead 1 INPUT_RECORD H-STDIN STREAM-FILE ReadConsoleInputA ERR THROW
;

: ~ DUP 2* SWAP ;
: ` DUP ;
256
CONST ����� ᮡ�⨩ ���᮫� (������ �� ॠ����樨)
  KEYFLAG_KEY_EVENT ~
  KEYFLAG_MOUSE_EVENT ~
  KEYFLAG_MOUSE_LBUTTON `
  KEYFLAG_KEY_DOWN ~
  KEYFLAG_MOUSE_RBUTTON `
  KEYFLAG_CHAR_KEY ~
  KEYFLAG_MOUSE_MOVE ~
  KEYFLAG_MOUSE_DBLCLICK ~
; DROP

: ~ OVER + ;
INPUT_RECORD
CONST ���� � �� ���祭�� � ������� INPUT_RECORD
  EventType 0 ~
    MOUSE_EVENT 2
    KEY_EVENT 1
  KKeyDown 4 ~
  MMouseX 4 ~
  MMouseY 6 ~
  KRepeatCount 8 ~
  MButtonState 8 ~
    LBUTTON 1
    RBUTTON 2
  KVirtualKeyCode 10 ~
  KVirtualScanCode 12 ~
  MControlKeyState 12 ~
    RIGHT_ALT_PRESSED 0x01
    LEFT_ALT_PRESSED 0x02
    RIGHT_CTRL_PRESSED 0x04
    LEFT_CTRL_PRESSED 0x08
    CAPSLOCK_ON 0x80
    ENHANCED_KEY 0x100
    NUMLOCK_ON 0x20
    SCROLLLOCK_ON 0x40
    SHIFT_PRESSED 0x10
  KAsciiCode 14 ~
  KControlKeyState 16 ~
  MEventFlag 16 ~
    MOUSE_MOVED 1
    DOUBLE_CLICK 2
; DROP

: EKEY? ( -- flag ) \ 93 FACILITY EXT
\ �஢�ઠ ������ ᮡ�⨩ ���᮫�
  0 SP@ H-STDIN STREAM-FILE 
\ � ��諮� ���ᨨ १���� ����ᨫ�� � ��६�����. �����? �� �� ����� ��
\ �ᯮ������. ����� ���� �ࠧ� � �⥪!
  GetNumberOfConsoleInputEvents ERR THROW
  0<>
;

VARIABLE KEY_RECORD_ASCII
\ ASCII-��� ᨬ���쭮� ������. ���������� EKEY, � �� ����室�����
\ �����������. ����室���, ⠪ ��� EKEY 㤠��� ᮡ�⨥.

: EKEY ( -- u )
\ �⥭�� ᮡ��� ���᮫�. �⫨�� �� ����襩�� ���ᨨ: ����������� ����祭��
\ �������� ������ ���ଠ樨 � ᮡ�⨨, ���४⭮� �⥭�� ᨬ������ ������,
\ � ⮬ �᫥ �� ��४��祭�� �몠.
\ �����頥� ����㠫�� ��� ������ (����⠭�� vk_*) � 䫠�� KEYFLAG_*
  0 KEY_RECORD_ASCII !
  EKEY? IF
    PeekCon
\ ����ਬ ���᮫�
    EventType W@ KEY_EVENT = IF
\ �᫨ ��������୮� ᮡ�⨥
      KVirtualKeyCode W@
      KEYFLAG_KEY_EVENT OR
      KKeyDown W@ IF
        KEYFLAG_KEY_DOWN OR
      THEN
      KAsciiCode W@ IF
        KEYFLAG_CHAR_KEY OR
        DUP KEYFLAG_KEY_DOWN AND IF
\ �᫨ �� ᨬ���쭠� ������, � �ந��諮 ����⨥, � ����� �᫮������:
\ �� ����� ������ �१ �㭪�� ReadConsole - ⮣�� ᨬ��� ���������
\ � �㦭�� ॣ���� � �몥. ���樠�쭮 ��� �⮣� ��� �ᯮ�짮������
\ PeekCon ����� ReadCon.
          17 SETMOD
\ ��⠭�������� ०��, �� ���஬ ������� ᨬ��� �㤥� ������� �ࠧ�,
\ � �� ��᫥ ������ <ENTER>.
          0 NumberOfRecordsRead 1 KEY_RECORD_ASCII H-STDIN STREAM-FILE 
          ReadConsoleA DROP
\ ���������� � KEY_RECORD_ASCII, ⠪ ��� ᥩ�� ��� �㦥� ⮫쪮 ᪠�-���.
          23 SETMOD
\ ����⠭�������� ०�� ���᮫�.
        ELSE
          ReadCon
\ ���, ᮡ�⨥ ����� �� �㦭�.
        THEN
      ELSE
\ ��� ���� �᪫��⥫쭠� ����� - <ESC> �� �ᯮ������� ��� ᨬ���쭠�
\ ������. ��������㥬 vk-���.
        ReadCon
        DUP 0xFF AND 0x1B = IF
          KEYFLAG_CHAR_KEY OR
          DUP KEYFLAG_KEY_DOWN AND IF
\ �᫨ �� vk-��� <ESC> � ����⨥, � ��⠭�������� 䫠� ᨬ���쭮� ������
            0x1B KEY_RECORD_ASCII !
\ � ����������.
          THEN
        THEN
      THEN
    ELSE
\ �᫨ ᮡ�⨥ �� ��������୮�
      ReadCon
      EventType W@ MOUSE_EVENT = IF
\ ����� �� ���?
        KEYFLAG_MOUSE_EVENT
        MEventFlag W@ MOUSE_MOVED AND IF
          KEYFLAG_MOUSE_MOVE OR
        THEN
        MEventFlag W@ DOUBLE_CLICK AND IF
          KEYFLAG_MOUSE_DBLCLICK OR
        THEN
        MButtonState W@ LBUTTON AND IF
          KEYFLAG_MOUSE_LBUTTON OR
        THEN
        MButtonState W@ RBUTTON AND IF
          KEYFLAG_MOUSE_RBUTTON OR
        THEN
\ �᫨ ⠪, � �⠢�� ᮮ⢥�����騥 䫠��
      ELSE
        0
\ ���� - ��祣� �� �ந��諮.
      THEN
    THEN
  ELSE
    0
  THEN
;

: EKEY>CHAR ( u -- u 0 | c -1 )
\ �᫨ vk-��� u ᮮ⢥����� ����⮩ ᨬ���쭮� ������, � ������ �� ASCII
\ ��� � true, ���� ��� � false
  KEY_RECORD_ASCII @ DUP IF
    NIP -1
  THEN
;

VARIABLE KEY?_WAS 0 KEY?_WAS !
\ �� �맢�� KEY? �� KEY. ����室��� ��� ⮣�, �⮡� KEY ����� �� ��뢠� KEY?.
VARIABLE KEY?_FLAG
\ ������� �맮�� KEY?.

: KEY? ( -- f )
  EKEY EKEY>CHAR NIP
  -1 KEY?_WAS !
  DUP KEY?_FLAG !
;

: KEY ( -- c )
  KEY?_WAS @ 0= IF
    BEGIN KEY? 0 KEY?_WAS ! UNTIL
  THEN
  KEY_RECORD_ASCII W@
;
\ ��������!!! EKEY �� ᮢᥬ �⠭���⭮�. ��� 㤠��� ᮡ�⨥. ���������
\ �⮬� ����� ᤥ���� ⠪:
\ BEGIN DO_SOMETHING KEY? UNTIL KEY
