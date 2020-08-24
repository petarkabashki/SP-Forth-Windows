\ ���������� ������ THROW.
\ ������������� �������� ���. ���� ��� ������� ���������
\ ��� ������������� ���������� ����� � ���. ���� ��. ����������:
\ - ����� ����������
\ - �������� ������ � ������� ��������� ����������
\ - ������������ ���� ��� ����������, � ������� ��������� ����������

..: AT-PROCESS-STARTING STARTLOG ;.. \ �������� ���� Scattered colons!

GET-CURRENT
ALSO NON-OPT-WL CONTEXT ! DEFINITIONS

: THROW THROW ; \ ���� �� ['] ����� ���������...

PREVIOUS SET-CURRENT

: HOLDS ( addr u -- ) \ from eserv src
  SWAP OVER + SWAP 0 ?DO DUP I - 1- C@ HOLD LOOP DROP
;

: (DTHROW) ( u1 u2 c-addr u3 -- )
\ u1 - ����� exeption
\ u2 - ����� ������, ��� ��� ���������
  BASE @ >R DECIMAL
  2>R
  OVER IF
   OVER DUP >R ABS 0
   <# #S R> SIGN S" exeption: " HOLDS #> TO-LOG
   0 <# #S S"  line: " HOLDS 2R> HOLDS S"  file: " HOLDS #> TO-LOG
   LT 2 TO-LOG
       ELSE
   2R> 2DROP DROP      
       THEN
  R> BASE !
  THROW
;

: THROW STATE @ IF
                  CURSTR @ LIT, CURFILE @ ?DUP
                  IF
                    ASCIIZ> 
                  ELSE PAD 0
                  THEN [COMPILE] SLITERAL
                  POSTPONE (DTHROW)
                ELSE THROW
                THEN
; IMMEDIATE

WINAPI: FormatMessageA KERNEL32.DLL
WINAPI: SetLastError   KERNEL32.DLL

HEX

00000100 CONSTANT FORMAT_MESSAGE_ALLOCATE_BUFFER
00001000 CONSTANT FORMAT_MESSAGE_FROM_SYSTEM

00 CONSTANT LANG_NEUTRAL
01 CONSTANT SUBLANG_DEFAULT

DECIMAL

: MAKELANGID ( p s -- langid )
  10 LSHIFT OR
;
\       ((((WORD  )(s)) << 10) | (WORD  )(p))

USER EMBUF

: ErrorMessage ( errcode -- addr u )
  >R
  0 0 EMBUF
  LANG_NEUTRAL SUBLANG_DEFAULT MAKELANGID
  R> 0
  FORMAT_MESSAGE_ALLOCATE_BUFFER  FORMAT_MESSAGE_FROM_SYSTEM OR
  FormatMessageA
  ?DUP IF EMBUF @ SWAP ELSE HERE 0 THEN
;

\ ���� �� ����������� ��� ����������, �� ����������:
\ : WINERR ; IMMEDIATE

: (WINERR) ( u1 c-addr u -- )
   GetLastError ?DUP
   IF
     ErrorMessage
     S" WinERR: " TO-LOG TO-LOG
     2>R 0
     <# #S S"  line: " HOLDS 2R> HOLDS S" winerror file: " HOLDS #> TO-LOG
     LT 2 TO-LOG
     0 SetLastError DROP
   ELSE
    2DROP DROP
   THEN
;

: WINERR
\ ������� � ��� ���������, ��������������� ��������� (!) Windows error
\ � ����� ����� ������ � ����, ��� ������ ����� ���� ��������������,
\ �������� ��������� ������ � Windows.
\ ������� ��������, ��� ������ ���������, ������ ����� ���� ���������
\ �� ������ WinAPI ������.

STATE @ IF
          CURSTR @ LIT, CURFILE @ ?DUP
          IF
             ASCIIZ> 
          ELSE PAD 0
          THEN [COMPILE] SLITERAL
          POSTPONE (WINERR)
        ELSE CURFILE @ ?DUP IF CURSTR @ SWAP ASCIIZ> (WINERR)
                            ELSE 0 S" H-STDIN" (WINERR)
                            THEN
        THEN
; IMMEDIATE

STARTLOG
