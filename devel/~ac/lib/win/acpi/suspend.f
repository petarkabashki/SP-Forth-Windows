\ ����������� ��������� ������

REQUIRE SetPrivilege ~ac/lib/win/access/nt_privelege.f 

WINAPI: IsPwrSuspendAllowed PowrProf.dll
WINAPI: SetSystemPowerState Kernel32.dll

: GetShutdownPrivilege ( -- )
  TRUE S" SeShutdownPrivilege" GetProcessToken THROW SetPrivilege THROW
;
: AcpiSuspend ( -- ior )

  \ ���� �� ��������� �����, �� SetSystemPowerState ������ 1314
  ['] GetShutdownPrivilege CATCH ?DUP IF EXIT THEN  \ ��� ������������ ����� Se - ���������� exception ������ LookupPrivilegeValueA !!!

  IsPwrSuspendAllowed 1 =
  IF 0 1 SetSystemPowerState ERR ELSE 5 THEN \ ������� �� ������� ���������� ��� ������ �� ���
;
\ AcpiSuspend .
