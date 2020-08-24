REQUIRE EMBODY    ~pinka/spf/forthml/index.f

`envir.f.xml            FIND-FULLNAME2 EMBODY  xml-struct-hidden::start
`spf4-64.f.xml          FIND-FULLNAME2 EMBODY

\ ����-��������� 64x �������� � ������� emu64
\ ��������� ��� ���������� �������:
GET-CURRENT emu64 SET-CURRENT

: EXECUTE DROP EXECUTE ;
: CATCH DROP CATCH S>D ;
: THROW DROP THROW ;
: ABORT ABORT ;
: ALLOCATED DROP ALLOCATED 0 TUCK ;
: TYPE DROP NIP TYPE ;
: NEXT-LINE-STDIN ( -- a u true | false ) NEXT-LINE-STDIN IF 0 TUCK -1. EXIT THEN 0. ;
: ?STACK ?STACK ;
: OK OK ;
: BYE BYE ;

SET-CURRENT

\ ���-������ ���� � ������� emu64, ��� �����, �������� "��������������",
\ ��� ���� wid ��������� �������, �.�. ������� ������� (����������������)
\ ��������������� � ������ ���� ���������� � ������� �����������
\ (� ��� ��������� TC-WL, doubling-hidden, dataspace-hidden � �.�.)
\ ����� �� �� ��������� �� emu64


`envir64.f.xml          FIND-FULLNAME2 EMBODY
\ ������������� � ��������� ����� ����������� 64x ����������.

\ ��.
\ emu64 NLIST
\ emu64::TC-WL NLIST
\ ����� ���� f:init, f:text � �.�. ������ ������ ��� ������ ���� � �������������.
\ ������� �� �������� xi:* ��. ����� xml-struct-hidden NLIST


\ GET-CURRENT GET-ORDER \ �� �����������, �.�. � ��� ������.
EMU64 \ ������������ �� �������� ��������� 64x forthproc  
\ + ������� ����� host-tools  (����� '\' ��� ��� IMMEDIATE-�����)
\ ����� ORDER ����
\ Context>: host-tools emu64
\ Current: emu64

`spf4-host64.f.xml      FIND-FULLNAME2 EMBODY \ ���������� 64x ����������.
\ ���������� ������������� � ������������� � ������ ���������, ����� ��������
\ �� ����� �����-�� ����� �� ���������������� �������; 
\ ��� �� � ���������������� ����������.

SPF4 \ ��������� � �������� �������� ���������������� �������
\ SET-ORDER SET-CURRENT 

emu64::QUIT
\ ��������� 64x ���������� plainForth
\ ����� OK �������� �� ���������������� �������, ������������ ������� �������� �� �����.
\ ������� � ���������������� ������� �������� �� Ctrl+Z,Enter -- "����� �������� ������"
