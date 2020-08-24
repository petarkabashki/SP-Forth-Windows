\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   systime for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ����祭�� �����쭮�� �६���
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|  v 1.0
\ -----------------------------------------------------------------------------
MODULE: _SYSTIME

WINAPI: GetLocalTime		KERNEL32.DLL

: tTime ( n -> )
	HERE DUP GetLocalTime DROP + W@ ;

EXPORT

\ ����騩 ���
: Year ( -> n ) 0 tTime ;
	

\ ����騩 �����
: Month ( -> n ) 2 tTime ;

\ ����騩 ���� ������ ����ᥭ�-0, �������쭨�-1 ...
: DayOfWeek  ( -> n ) 4 tTime ;

\ ����騩 ���� �����
: Day ( -> n ) 6 tTime ;

\ ����騩 ��
: Hour ( -> n ) 8 tTime ;

\ ������ �����
: Minute ( -> n ) 10 tTime ;

\ ������ ᥪ㭤�
: Second ( -> n ) 12 tTime ;

\ ������ �����ᥪ㭤�
: Millisecond ( -> n ) 14 tTime ;

\ �뢥�� �� ���᮫� ⥪���� ����
: .DATE ( -> )
	Day 2 .0 0x2E EMIT Month 2 .0 0x2E EMIT Year . ;

\ �뢥�� �� ���᮫� ⥪�饥 �६�
: .TIME ( -> )
	Hour 2 .0 0x3A EMIT Minute 2 .0 0x3A EMIT Second 2 .0 ;

\ �뢥�� �� ���᮫� ⥪���� ���� � �६�
: .DATETIME ( -> )
	.DATE .TIME ;

;MODULE


\EOF

Year 		( -> n ) - ⥪�騩 ���
Month 		( -> n ) - ⥪�騩 �����
DayOfWeek	( -> n ) - ⥪�騩 ���� ������ ����ᥭ�-0, �������쭨�-1 ...
Day		( -> n ) - ⥪�騩 ���� �����
Hour		( -> n ) - ⥪�騩 ��
Minute		( -> n ) - ⥪��� �����
Second		( -> n ) - ⥪��� ᥪ㭤�
Millisecond	( -> n ) - ⥪��� �����ᥪ㭤�
.DATE		( -> ) - �뢥�� �� ���᮫� ⥪���� ����
.TIME		( -> ) - �뢥�� �� ���᮫� ⥪�饥 �६�
.DATETIME	( -> ) - �뢥�� �� ���᮫� ⥪���� ���� � �६�
