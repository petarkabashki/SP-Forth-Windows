\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   heap for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� ��� ࠡ��� � ��祩
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|  v 1.0
\ -----------------------------------------------------------------------------
MODULE: _HEAP

WINAPI: HeapLock		KERNEL32.DLL
WINAPI: HeapUnlock		KERNEL32.DLL
WINAPI: HeapValidate		KERNEL32.DLL
WINAPI: HeapCompact		KERNEL32.DLL
WINAPI: HeapSize		KERNEL32.DLL

EXPORT

\ ������� ���ਯ�� ��� ��뢠�饣� �����
: Heap ( -> handle )
	GetProcessHeap ;

\ ������� ���� ( 0 - �訡�� )
: HeapNew ( -> handle )
	0 4096 4 HeapCreate ;

\ ������� ���� ( 0 - �訡�� )
: HeapDel ( handle -> flag )
        HeapDestroy ;

\ ������� ���� 
: HeapZip ( handle -> )
	1 SWAP HeapCompact DROP ;

\ �����஢��� ����� � ��� ��� ��㣨� ��⮪��
: HeapLK ( handle -> )
	HeapLock DROP ;

\ ��������஢��� ����� � ��� ��� ��㣨� ��⮪��
: HeapUL ( handle -> )
	HeapUnlock DROP ;

\ �஢���� ���� �� �訡��
: HeapTest ( handle -> flag )
	0 1 ROT HeapValidate ;

\ �뤥��� ������ �� ���
: MemNew ( n handle -> addr )
	9 SWAP HeapAlloc ;

\ ������ �뤥������ ������ �� ��� ( 0 - �訡�� )
: MemDel ( addr handle -> flag ) 
	1 SWAP HeapFree ;

\ ������� ࠧ��� �뤥������ �����
: MemSize ( addr handle -> n )
	1 SWAP HeapSize ;

\ �������� ࠧ��� �뤥������ �����
: MemResize ( n addr handle -> addr )
	9 SWAP HeapReAlloc ;

\ �஢���� �뤥������ ������ �� �訡��
: MemTest ( addr handle -> flag )
	1 SWAP HeapValidate ;

;MODULE

\EOF

Heap 		( -> handle ) - ������� ���ਯ�� ��� ��뢠�饣� �����
HeapNew		( -> handle ) - ᮧ���� ���� ( 0 - �訡�� )
HeapDel		( handle -> flag ) - 㤠���� ���� ( 0 - �訡�� )
HeapZip		( handle -> ) - ᦨ���� ����
HeapLK		( handle -> ) - �����஢��� ����� � ��� ��� ��㣨� ��⮪��
HeapUL		( handle -> ) - ࠧ�����஢��� ����� � ��� ��� ��㣨� ��⮪��
HeapTest	( handle -> flag ) - �஢���� ���� �� �訡�� ( 0 - �訡�� )
MemNew		( n handle -> addr ) - �뤥��� ������ �� ���
MemDel		( addr handle -> flag ) - 㤠��� �뤥������ ������ �� ���
MemSize		( addr handle -> n ) - ������� ࠧ��� �뤥������ �����
MemResize	( n addr handle -> addr ) - �������� ࠧ��� �뤥������ �����
MemTest		( addr handle -> flag ) - �஢���� �뤥������ ������ �� �訡�� ( 0 - �訡�� )
