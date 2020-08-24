\ -----------------------------------------------------------------------------
\ __          ___       ____ ___
\ \ \        / (_)     |___ \__ \   Rnd for Windows
\  \ \  /\  / / _ _ __   __) | ) |  pi@alarmomsk.ru
\   \ \/  \/ / | | '_ \ |__ < / /   ������⥪� ��� �����樨 ��砩��� �ᥫ
\    \  /\  /  | | | | |___) / /_   Pretorian 2007
\     \/  \/   |_|_| |_|____/____|  v 1.0
\ -----------------------------------------------------------------------------

MODULE: _RND

WINAPI: GetTickCount KERNEL32.DLL
0 VALUE RndNum \ ��᫮ ��� ���� ��砩���� �᫠

EXPORT

0 VALUE RndEnd \ ������ �࠭�� ��砩���� �᫠

\ ��⠭����� ���祭�� � ���稪 ��� �����樨 �ᥢ����砩��� �ᥫ
: Seed ( u -> )
	TO RndNum ;

\ ���樠����஢��� ������� ��砩��� �ᥫ (���樠����஢�� �� 㬮�砭��)
: RndInit ( -> )
	4294967295 TO RndEnd GetTickCount Seed ;

\ ������� 32 ��⭮� ��砩��� �᫮
: Random32 ( -> u )
	RndNum 0x8088405 * 1+ DUP TO RndNum ;

\ ������� ��砩��� �᫮
: Random ( -> u )
	RndEnd Random32 UM* NIP ;

\ ������� ��砩��� �᫮ �� 0 �� 㪠������� ���������
: Choose ( u -> u )
	Random32 UM* NIP ;

;MODULE

RndInit

\EOF

---�����⢠ ��砩���� �᫠---
RndEnd		( -> n ) - ������ �࠭�� ��砩���� �᫠

---��⮤� ��砩���� �᫠---
RndInit		( -> ) - ���樠����஢��� ������� ��砩��� �ᥫ
Seed		( u -> ) - ��⠭����� ���祭�� � ���稪 ��� �����樨
		�ᥢ����砩��� �ᥫ
Random32	( -> u ) - ������� 32 ��⭮� ��砩��� �᫮
Random		( -> u ) - ������� ��砩��� �᫮
Choose		( u -> u ) - ������� ��砩��� �᫮ �� 0 �� 㪠������� ���������



