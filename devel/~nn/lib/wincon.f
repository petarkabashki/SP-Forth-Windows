\ MARKER WC
\ ������������� Win32 �������� �� wincon.dll. ��� ��-��-����� ������������ � ������������� Win32Forth.
\ ���� ����� ��������� wincon.dll ��� http://www.forth.org.ru/~ilya/Lib/wincon.dll
.( Loading WINCON extension...)
ALSO FORTH DEFINITIONS
DECIMAL

WINAPI: FindWin32Constant WINCON.DLL
WINAPI: EnumWin32Constants WINCON.DLL

\ WINAPI: EnumWin32ConstantValues WINCON.DLL
\ BOOL APIENTRY FindWin32Constant(char *addr, int len, int *value)
\ typedef int (WINAPI *ENUMPROC)(char*, int, int);
\ int APIENTRY EnumWin32Constants(char *addr, int len, ENUMPROC callback)


: ?WIN-CONST-SLITERAL ( addr u --)
    2>R 0 SP@ 2R> SWAP FindWin32Constant
    0=  IF DROP -321 THROW THEN
    [COMPILE] LITERAL
;

: ?WIN-CONST-LITERAL ( c-addr --)  COUNT ?WIN-CONST-SLITERAL ;
WARNING @ WARNING 0!
: NOTFOUND
    2DUP 2>R ['] ?WIN-CONST-SLITERAL CATCH
    IF 2DROP 2R>
       NOTFOUND
    ELSE
        2R> 2DROP
    THEN ;

WARNING !

10 VALUE WCONST-BASE

: ?SPACES DUP 0 > 0= IF DROP 1 THEN SPACES ;

: (WIN-SHOW-CONST) ( Value Len Addr -- ?)
    WCONST-BASE BASE !
    OVER TYPE 40 SWAP - ?SPACES
    . CR
    KEY? IF KEY BL =
            IF KEY BL =
            ELSE FALSE THEN
         ELSE TRUE THEN
;

' (WIN-SHOW-CONST) WNDPROC: WIN-SHOW-CONST

: WCONSTS  ['] WIN-SHOW-CONST BL WORD COUNT SWAP EnumWin32Constants DROP ;
\ : WVALUE  ( n -- ) ['] WIN-SHOW-CONST SWAP EnumWin32ConstantValues DROP ;
PREVIOUS DEFINITIONS
\EOF
.( Ok.) CR
\ WCONSTS MB_

( \ TEST1
INFINITE . CR
SW_HIDE . CR
SW_MINIMIZE . CR
SW_MAXIMIZE . CR

: XX ." SW_MINIMIZE is " SW_MINIMIZE . CR ;
XX
)
( \ TEST2
VARIABLE CONST-VALUE
: T CONST-VALUE BL WORD COUNT SWAP FindWin32Constant
    IF ." is " CONST-VALUE @ . ELSE ." Not found" THEN CR ;
)