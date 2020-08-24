\ diffsec ( thi1 tlo1 thi2 tlo2 -- sec )
\ ���� �������� ����� ��������� �������: t2-t1  � ��������.
( ���� �������� ����� ~136 ���, �������� ������������,
  �.�. � 32 ���� ��������� ������ ����� ������ � 136 �����.
  NowFTime [� FILETIME] ����������� �������� �� 1601 ����.
)

\ 15.Apr.2001  ruv
\ 16. ������� ������� �������� �� �����... 
\       ����� 2! ( thi tlo ) ���������� � ������� FILETIME 
\ 25.Jul.2001 Wed 12:37 
\ * diffsec ����� �������� �� ������.
\ + SecondsToTimeDate ( sec -- sec min hr day mt year )
\ + TimeDateToSeconds ( sec min hr day mt year -- sec )

\ 20.Oct.2001 Sat 21:40
\ ������, ����� ������� ������� ;)
\ + !FTime @FTime  ( tlo thi )

\ 13.Nov.2001 Tue 21:07
\ * NowFTime ���� UTC (��� � ��������  ���� ������ )
\ + >UTC  UTC> ( tlo thi -- tlo1 thi1 )
\ + TimeDateToFTime ( sec min hr day mt year -- tlo thi )
\ + FTimeToTimeDate ( tlo thi -- sec min hr day mt year )

\ 12.Mar.2002 Tue 02:50
\ * NowFTime \ ����������� GetSystemTimeAsFileTime,
\              ������ GetSystemTime � SystemTimeToFileTime
\              ����� ����� �������� � 10 ��� �������.
\ 20.Jul.2002 Sat 14:00 TimeDate instead of DateTime
\ 26.May.2003 Mon 19:20 + addsec

REQUIRE [UNDEFINED] lib\include\tools.f

[UNDEFINED] >CELLS   [IF]
: >CELLS ( n1 -- n2 ) \ "to-cells" \ see: http://forth.sourceforge.net/word/to-cells/
  2 RSHIFT
;                    [THEN]
[UNDEFINED] ?WINAPI: [IF]
: ?WINAPI: ( -- ) \
  >IN @
  POSTPONE [UNDEFINED]
  IF   >IN ! WINAPI: 
  ELSE DROP NextWord 2DROP 
  THEN
;                    [THEN]

\ reference:
( typedef struct _FILETIME { // ft 
    DWORD dwLowDateTime; 
    DWORD dwHighDateTime; 
} FILETIME; )
\ 64-bit value representing the number of 100-nanosecond intervals 
\ since January 1, 1601. 

( typedef struct _SYSTEMTIME {  // st 
    WORD wYear; 
    WORD wMonth; 
    WORD wDayOfWeek; 
    WORD wDay; 
    WORD wHour; 
    WORD wMinute; 
    WORD wSecond; 
    WORD wMilliseconds; 
} SYSTEMTIME;  )


?WINAPI: GetSystemTimeAsFileTime KERNEL32.DLL
( LPFILETIME:lpSystemTimeAsFileTime \ pointer to a file time structure  
   -- VOID )    \ ���������� ������ �����-�� �����.

?WINAPI: SystemTimeToFileTime KERNEL32.DLL
(   lpFileTime   \ LPFILETIME   \ address of buffer for converted file time 
    lpSystemTime \ LPSYSTEMTIME \ address of system time to convert 
  -- BOOL )

?WINAPI: FileTimeToSystemTime  KERNEL32.DLL
(   lpSystemTime  \ pointer to structure to receive system time  
    lpFileTime    \ pointer to file time to convert 
  -- BOOL )

?WINAPI: FileTimeToLocalFileTime KERNEL32.DLL
(   LPFILETIME lpLocalFileTime  // pointer to converted file time 
    CONST FILETIME *lpFileTime, // pointer to UTC file time to convert  
  -- BOOL )   

?WINAPI: LocalFileTimeToFileTime KERNEL32.DLL
(   LPFILETIME lpFileTime   // address of converted file time
    CONST FILETIME *lpLocalFileTime,    // address of local file time to convert
  -- BOOL )

\ (
[UNDEFINED] /SYSTEMTIME [IF]
0 \ _SYSTEMTIME
2 -- wYear
2 -- wMonth
2 -- wDayOfWeek
2 -- wDay
2 -- wHour
2 -- wMinute
2 -- wSecond
2 -- wMilliseconds
CONSTANT /SYSTEMTIME     [THEN]
\ CREATE SYSTEMTIME /SYSTEMTIME ALLOT
\ )

: !FTime ( tlo thi a -- )
  -ROT SWAP ROT 2!
;
: @FTime ( a -- tlo thi )
  2@ SWAP
;

: diffsec ( tlo1 thi1 tlo2 thi2 -- sec )
\ ���� �������� �� ������ ����� ��������� �������: t1-t2  � ��������.
  ( D- ) DNEGATE D+ DABS
  10000000 UM/MOD NIP  \ �� ������� ����� ����������� � �������
; \ 10 000 000

: addsec ( tlo1 thi1  sec -- tlo2 thi2 )
\ ���� ����������� ftime, �� sec 
  10000000 UM* D+
;

[DEFINED] ?C-JMP [IF]  \ for macroopt.f
?C-JMP
FALSE TO ?C-JMP  [THEN]

: FTimeToTimeDate ( tlo thi -- sec min hr day mt year )
  SWAP SP@  ( filetime )
  /SYSTEMTIME >CELLS RALLOT DUP /SYSTEMTIME ERASE DUP >R
  SWAP
  FileTimeToSystemTime DROP
  2DROP
     R@ wSecond W@
     R@ wMinute W@
     R@ wHour   W@
     R@ wDay    W@
     R@ wMonth  W@
     R@ wYear   W@
  RDROP /SYSTEMTIME >CELLS RFREE
;
: TimeDateToFTime ( sec min hr day mt year -- tlo thi )
  /SYSTEMTIME >CELLS RALLOT DUP /SYSTEMTIME ERASE >R
     R@ wYear   W!
     R@ wMonth  W!
     R@ wDay    W!
     R@ wHour   W!
     R@ wMinute W!
     R@ wSecond W!
  0. SP@ R@ SystemTimeToFileTime DROP SWAP
  RDROP /SYSTEMTIME >CELLS RFREE
;

[DEFINED] ?C-JMP [IF]
TO ?C-JMP        [THEN]


: NowFTime ( -- tlo thi ) \ expressed in Coordinated Universal Time (UTC). 
\ ���� ������� ������ ������� ( ~ � ������� FILETIME)
  0. SP@ ( filet )
  GetSystemTimeAsFileTime DROP SWAP
;

\ UTC is Coordinated Universal Time
: >UTC ( tlo thi -- tlo1 thi1 )
  SWAP
  SP@ DUP LocalFileTimeToFileTime DROP
  SWAP
;
: UTC> ( tlo thi -- tlo1 thi1 )
  SWAP
  SP@ DUP FileTimeToLocalFileTime DROP
  SWAP
;

( ����� ����� ���� �� �� ������������� � thi tlo �� ����� ?
  �.�. ������ ������ � �������� �������� ���� FILETIME.
)

\ =======================================================
\ ����� ��� �������� ���������� �������, ���������� � ��������.

: SecondsToTimeDate ( sec -- sec min hr day mt year )
  0 60 UM/MOD
  60  /MOD
  24  /MOD
  30  /MOD
  12  /MOD
;
: TimeDateToSeconds ( sec min hr day mt year -- sec )
  31104000 *    SWAP
  2592000  * +  SWAP
  86400    * +  SWAP
  3600     * +  SWAP
  60       * +  SWAP
             +
;

