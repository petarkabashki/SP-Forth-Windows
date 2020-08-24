\ 18.Jan.2004  ~ruv
\ $Id: critical.f,v 1.6 2008/12/14 12:24:27 ruv Exp $

( ENTER-CS ����� ������� � ������ ��������� ���,
  ����� ������� �� LEAVE-CS.
  ���� ������ ������ - ������ ����� �� ������,
  ���� ������� ������ - ����� ����� �����
  ������ ����� ���������� ActivateCSs
  /WinXP/
)

WINAPI: InitializeCriticalSection  KERNEL32.DLL
WINAPI: EnterCriticalSection       KERNEL32.DLL
WINAPI: LeaveCriticalSection       KERNEL32.DLL
WINAPI: DeleteCriticalSection      KERNEL32.DLL

\ CS == Critical Section

CREATE CS-LIST 0 ,

: MAKE-CS, ( -- )  \  make on HERE
  HERE
  6 CELLS ALLOT
  DUP  InitializeCriticalSection DROP
  CS-LIST @ ,
  CS-LIST !
;
: CREATED-CS ( name-a name-u -- )  \  name ( -- cs )
  CREATED MAKE-CS,
;
: CREATE-CS ( "name" -- )  \  name ( -- cs )
\ ������� ����������� ������ � ������ name
  CREATE MAKE-CS,
;

: ActivateCSs ( -- )
  CS-LIST @     BEGIN
  DUP           WHILE
  DUP  InitializeCriticalSection DROP
  6 CELLS + @   REPEAT DROP
;
: DeactivateCSs ( -- )
  CS-LIST @     BEGIN
  DUP           WHILE
  DUP  DeleteCriticalSection DROP
  6 CELLS + @   REPEAT DROP
;
..: AT-PROCESS-STARTING   ActivateCSs    ;..
..: AT-PROCESS-FINISHING  DeactivateCSs  ;..

: ENTER-CS ( cs -- )
\ ����� (���������) � ����������� ������ cs 
\ ���� �����-���� ����� ������� ����������� �������, 
\  ��������� ����� ����� ������ ENTER-CS
    EnterCriticalSection DROP
;
: LEAVE-CS ( cs -- )
\ �������� (����������) ����������� ������ cs
    LeaveCriticalSection DROP
;

: NEW-CS ( -- cs )
  6 CELLS ALLOCATE THROW
  DUP  InitializeCriticalSection DROP
;
: DEL-CS ( cs -- )
  DUP  DeleteCriticalSection DROP
  FREE THROW
;


: MAKE-CRIT,    MAKE-CS,   ;
: CREATED-CRIT  CREATED-CS ;
: CREATE-CRIT   CREATE-CS  ;

: ENTER-CRIT ENTER-CS ;
: LEAVE-CRIT LEAVE-CS ;
: NEW-CRIT   NEW-CS   ;
: DEL-CRIT   DEL-CS   ;
