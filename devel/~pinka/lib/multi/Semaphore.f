\ 10.Feb.2001
\ semaphores
\ Wait � Release* �� ���������� ior. ��� ������ �������� THROW ������.

WINAPI: CreateSemaphoreA KERNEL32.DLL
WINAPI: ReleaseSemaphore KERNEL32.DLL

\ CreateSemaphore
( S:  az-name|0 MaximumCount InitialCount lpSemaphoreAttributes|0  -- HANDLE )
( az-name can contain any character except the backslash [\] path-separator character. 
  Name comparison is case sensitive. 
  event, mutex, semaphore, and file-mapping objects share the same name space. 
)

\ ReleaseSemaphore
( S: lplPreviousCount|0  cReleaseCount   hSemaphore -- BOOL )
( lplPreviousCount - Points to a 32-bit variable to receive 
the previous count for the semaphore.
  cReleaseCount - Specifies the amount by which the semaphore 
object's current count is to be increased.
  If the function succeeds, the return value is TRUE /=1/
  If the function fails, the return value is FALSE /=0/ 
)

: CreateSem ( addr u MaxCount InitCount -- handle ior )
\ ������� �������. ���� InitCount=0, �� ��������� ������ �����.
\ �������� Wait ��������� ������� �� 1.
\ ������� Max Init - ��� � DO...LOOP ;)
\ addr u - ��� (��� 0 0)
  ROT DROP \ ������ �����
  0 \ default security descriptor,  the resulting handle is not inheritable.
  CreateSemaphoreA  DUP  ERR
;
: NReleaseSem ( n handle -- )
\ ������� ������������� �� n
  0 ROT ROT
  ReleaseSemaphore ERR THROW
;
: ReleaseSem ( handle -- )
\ ������� ������������� �� 1
  0 1 ROT
  ReleaseSemaphore ERR THROW
;

: CloseSem ( handle -- ior )
  CloseHandle ERR
;

REQUIRE Wait ~pinka\lib\Multi\Synchr.f

: SemState ( handle -- n )
  DUP 0 Wait                    IF
  >R 0 SP@ 1 R>
  ReleaseSemaphore ERR THROW 1+ ELSE
  DROP 0                        THEN
;
