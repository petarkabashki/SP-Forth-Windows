\ MEM% - ������� ��������� ���������� ������ ������

WINAPI: GlobalMemoryStatus KERNEL32.DLL

: MEM% ( -- n )
  PAD GlobalMemoryStatus DROP PAD CELL+ @
;