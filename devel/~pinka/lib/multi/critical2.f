\ 18.Jan.2004  ~ruv
\ $Id: critical2.f,v 1.2 2008/12/14 12:24:27 ruv Exp $

REQUIRE WinNT?      ~ac\lib\win\winver.f
REQUIRE ENTER-CS    ~pinka\lib\multi\critical.f

WINAPI: TryEnterCriticalSection    KERNEL32.DLL

VECT ENTER-CS?  ( cs -- flag )
\ ���� ������ cs ��������, ��������� �� � ������� true,
\ ����� ������� false

' TryEnterCriticalSection TO ENTER-CS?

: ENTER-CS?(notNT) ( cs -- flag )
  ENTER-CS -1
;
: 0TRYENTERCS ( -- )
  WinNT? IF  ['] TryEnterCriticalSection
  ELSE       ['] ENTER-CS?(notNT)
  THEN        TO ENTER-CS?
;

..: AT-PROCESS-STARTING   0TRYENTERCS ;..


: ENTER-CRIT? ENTER-CS? ;
