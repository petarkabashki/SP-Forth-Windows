WARNING 0!
WINAPI: ReadConsoleA kernel32.dll
WINAPI: GetConsoleMode kernel32.dll
WINAPI: SetConsoleMode kernel32.dll
WINAPI: GetConsoleScreenBufferInfo KERNEL32.DLL
WINAPI: SetConsoleCursorPosition KERNEL32.DLL
WINAPI: GetConsoleCursorInfo KERNEL32.DLL
WINAPI: SetConsoleCursorInfo KERNEL32.DLL

REQUIRE CASE LIB\EXT\CASE.F
S" ~MICRO\LIB\KEY\KEYS.F" INCLUDED
\ REQUIRE VK_END ~MICRO\LIB\CONST\VK_.F
REQUIRE WINCONST lib/win/const.f

: COORD ( x y -- COORD )
  65536 * +
;

: GotoXY ( x y -- )
\ ��������� ���������� ������� � �������.
  COORD H-STDOUT SetConsoleCursorPosition ERR THROW
;

CREATE CONSOLE_SCREEN_BUFFER_INFO 22 ALLOT

: WhereXY ( -- x y )
\ ����������� ���������� �������
  CONSOLE_SCREEN_BUFFER_INFO H-STDOUT GetConsoleScreenBufferInfo DROP
  CONSOLE_SCREEN_BUFFER_INFO 4 + DUP W@ SWAP 2+ W@ ;

CREATE CONSOLE_CURSOR_INFO 8 ALLOT

: HideCursor
\ �������� ������
  CONSOLE_CURSOR_INFO H-STDIN STREAM-FILE GetConsoleCursorInfo DROP
  0 CONSOLE_CURSOR_INFO 4 + !
  CONSOLE_CURSOR_INFO H-STDIN STREAM-FILE SetConsoleCursorInfo DROP
;

: ShowCursor
\ �������� ������
  CONSOLE_CURSOR_INFO H-STDIN STREAM-FILE GetConsoleCursorInfo DROP
  1 CONSOLE_CURSOR_INFO 4 + !
  CONSOLE_CURSOR_INFO H-STDIN STREAM-FILE SetConsoleCursorInfo DROP
;

: PICK 1+ 4 * SP@ + @ ;

: PrintedChar
  31 >
;

: BEEP 7 EMIT ;

: ACCEPTPosCursor ( sx sy addr u len x )
  5 PICK OVER + 5 PICK GotoXY
;

: ACCEPTShowString
  HideCursor
  5 PICK 5 PICK GotoXY
  3 PICK 2 PICK TYPE
  ShowCursor
;

: ACCEPTShowStringFull ( sx sy addr u len x -- sx sy addr u len x )
\ ����������� ������. �� ������� ����������� ������� �� ������������ �����
\ ������ (u)
  HideCursor
  5 PICK 5 PICK GotoXY
  3 PICK 2 PICK TYPE
  2 PICK 2 PICK - SPACES
  ACCEPTPosCursor
  ShowCursor
;

: ACCEPTInsChar ( addr u len x ch -- addr u len+1 x+1 | addr u len x )
\ ������� �������
  3 PICK 3 PICK <> IF
    4 PICK 2 PICK + DUP 1+ ( addr u len x ch addr+x addr+x+1 )
    4 PICK 4 PICK - MOVE
    4 PICK 2 PICK + C! ( addr u len x )
    1+ SWAP 1+ SWAP
    ACCEPTShowString ACCEPTPosCursor
  ELSE
    DROP
    BEEP
  THEN
;

: ACCEPTBackspace ( addr u len x -- addr u len-1 x-1 | addr u len x )
\ ��������� Backspase
  DUP IF
    3 PICK 1 PICK + DUP 1- ( addr u len x addr+x addr+x-1 )
    3 PICK 3 PICK - MOVE
    1- SWAP 1- SWAP
    ACCEPTShowString SPACE ACCEPTPosCursor
  ELSE
    BEEP
  THEN
;

: ACCEPTLeft ( sx sy addr u len x )
\ ���������� ������� �����
  DUP IF 1- ACCEPTPosCursor ELSE BEEP THEN
;

: ACCEPTRight ( sx sy addr u len x )
\ ���������� ������� ������
  DUP 2 PICK <> IF 1+ ACCEPTPosCursor ELSE BEEP THEN
;

: ACCEPTDel
\ ��������� ������� Delete
  DUP 2 PICK <> IF 1+ ACCEPTBackspace ELSE BEEP THEN
;

: ACCEPTEsc
\ ������� ������
  2DROP 0 0 ACCEPTShowStringFull
;

\ ����������� history. ������� ����� �� �������� ������������� ������������ ������
80 CONSTANT ACCEPTHStrLen   \ ������������ ����� ������ � history. � �� ������
\ ���� ���� ��� ����� ������. �� ����� ���� ������ 256
50 CONSTANT ACCEPTHStrings  \ ����� ����� � history
\ CREATE ACCEPTHistory ACCEPTHStrLen ACCEPTHStrings * ALLOT
0 VALUE ACCEPTHistory
VARIABLE ACCEPTHEnd \ � ��������� ������
VARIABLE ACCEPTHCur \ � ������� ��������������� ������

: ACCEPT>H ( addr u -- )
\ ����� ������ � history. ���� � ����� ������ ����������� �����������,
\ ��� �������������. ������ ������� � ������ �0 � history, ���������
\ ���������� ����, ��������� ��������.
  ACCEPTHEnd @ -1 = 0= IF          
    ACCEPTHistory DUP
    ACCEPTHEnd @ 1+ ACCEPTHStrings 1- MIN
    ACCEPTHStrLen * SWAP ACCEPTHStrLen + SWAP
    MOVE
  THEN
  ACCEPTHStrLen 1- MIN DUP
  ACCEPTHistory C!
  ACCEPTHistory 1+ SWAP MOVE
  ACCEPTHEnd @ 1+ ACCEPTHStrings 1- MIN ACCEPTHEnd !
;

: ACCEPTH> ( addr u1 n -- u2 )
\ ���� ������ �n � addr. ���� ����� ������ ������ ������ u1, �� ��� ����������
\ �� u1. ������������ ����� ������ ������.
  ACCEPTHStrLen * ACCEPTHistory +   ( addr u1 haddr )
  DUP C@ ROT MIN                    ( addr haddr u2 )
  DUP 2SWAP ( u2 u2 addr haddr )
  1+
  SWAP ROT ( u2 haddr addr u2 )
  MOVE
;

: ACCEPTUp ( sx sy addr u len x )
\ ��������� ������� Up
  ACCEPTHCur @ DUP ACCEPTHEnd @ < IF
    1+ ACCEPTHCur !
    2OVER ACCEPTHCur @ ACCEPTH> NIP NIP DUP
    ACCEPTShowStringFull
  ELSE
    DROP
  THEN
;

: ACCEPTDown
\ ��������� ������� Down
  ACCEPTHCur @ DUP 0 > IF
    1- ACCEPTHCur !
    2OVER ACCEPTHCur @ ACCEPTH> NIP NIP DUP
    ACCEPTShowStringFull
  ELSE
    DROP
  THEN
;

VECT ACCEPTUnknownEvent ( sx sy addr u len x u -- sx sy addr u len x enter )
\ ����������, ���� ������� ������� �� �������� ACCEPT-��.
\ u - ��������� EKEY-�
: ACCEPTUnknownEvent1
  DROP 0
;

WINAPI: WaitForSingleObject KERNEL32.DLL

: ACCEPT1 ( addr u -- u )
\ ������ ������ � ����������, ������������ ����� �������� ��������
\ ����� � �����: sx, sy - ���������� ������ ������
\ addr, u - ����� � ������������ (��������) ����� ������
\ len - ������� ����� ������
\ x - ��������� �������
\ enter - =1, ���� ����� Enter
\ �� �����������, ��� ��� ����� � ��� �� ���������.
\ !!! ������ �� ������ ������� �� ���� ������.
  79 MIN
  -1 ACCEPTHCur !
  WhereXY 2SWAP ( sx sy addr u )
  0 0 ( sx sy addr u len x )
  BEGIN
    \ BEGIN EKEY? UNTIL
    -1 -10 GetStdHandle WaitForSingleObject DROP
    EKEY EKEY>CHAR
    IF
      DUP PrintedChar IF
        ACCEPTInsChar 0
      ELSE
        CASE ( sx sy addr u len x )
          VK_BACK OF ACCEPTBackspace 0 ENDOF
          VK_RETURN OF 1 ENDOF
          VK_ESCAPE OF ACCEPTEsc 0 ENDOF
         ( 7 OF 0 ENDOF )     \ ���� ��� ����������� ������, �� ����� �����
         ( 9 OF 0 ENDOF )     \ ��������� � ������ ������� � ������ <32
         ( ACCEPTInsChar )    \ ��� Ctrl+<a..z>
          DROP                \ ����� ��� ���� ��������������
          0 0
        ENDCASE
      THEN
    ELSE
      DUP
      KEYFLAG_KEY_EVENT KEYFLAG_KEY_DOWN OR
      DUP ROT AND =
      IF
        255 AND
        CASE ( sx sy addr u len x )
          VK_RIGHT OF ACCEPTRight ENDOF
          VK_LEFT OF ACCEPTLeft ENDOF
          VK_HOME OF DROP 0 ACCEPTPosCursor ENDOF
          VK_END OF DROP DUP ACCEPTPosCursor ENDOF
          VK_DELETE OF ACCEPTDel ENDOF
          VK_UP OF ACCEPTUp ENDOF
          VK_DOWN OF ACCEPTDown ENDOF
        ENDCASE
        0
      ELSE
        ACCEPTUnknownEvent
      THEN
    THEN ( sx sy addr u len x enter )
  UNTIL
  DROP SWAP DROP
  2DUP ACCEPT>H
  >R DROP 2DROP
  CR
  R>
;

: ACCEPTInit
  ACCEPTHStrLen ACCEPTHStrings * ALLOCATE THROW TO ACCEPTHistory
  -1 ACCEPTHEnd !
  -1 ACCEPTHCur !
  ['] ACCEPTUnknownEvent1 TO ACCEPTUnknownEvent
  ['] ACCEPT1 TO ACCEPT
  ACCEPT
;
