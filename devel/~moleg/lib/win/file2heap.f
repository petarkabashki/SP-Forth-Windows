\ 06.12.2008 ~mOleg
\ �opyright [C] 2008 mOleg mininoleg@yahoo.com
\ ���������� ���������� ����� � ���

 REQUIRE ?DEFINED     devel\~moleg\lib\util\ifdef.f

?DEFINED GetFileSize  WINAPI: GetFileSize    KERNEL32.DLL ( addr fid --> # )

\ ��������� ���������� ����� Asc # � ������,
\ ������� ����� ������ ����� ������ � ��� �����
: FILE>HEAP ( asc # --> addr # true | false )
            R/O OPEN-FILE DUP IF 2DROP FALSE EXIT THEN DROP >R
            0 R@ GetFileSize DUP
            ALLOCATE IF 2DROP R> CLOSE-FILE DROP FALSE EXIT THEN DUP >R
            SWAP 2R@ DROP READ-FILE  2R> SWAP CLOSE-FILE DROP
            SWAP IF FREE 2DROP FALSE ELSE SWAP TRUE THEN ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ������ �������� ������
  S" passed" TYPE
}test
