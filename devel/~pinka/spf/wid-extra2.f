\ 26.Jul.2007
\ ��������� ������-����� hash-table � storage-id
\ (�������, ������������ WID-EXTRA �� ����)

MODULE: WidExtraSupport

3 CELLS CONSTANT /THIS-EXTR   \ [ hash-table | storage-id | free cell ]

: MAKE-EXTR ( wid -- )
  HERE DUP /THIS-EXTR DUP ALLOT ERASE
  ( wid here )
  SWAP WID-EXTRA !
;

: WID-CACHEA ( wid -- a )
  WID-EXTRA @ 
;
: WID-STORAGEA ( wid -- a )
  WID-EXTRA @ CELL+
;

EXPORT

WARNING @  WARNING 0!

: WID-EXTRA ( wid -- a )  \ ����� ��������� ��� ������ ���������� ������
  WID-EXTRA @ 2 CELLS +  \ ����������� ��� ��� ��������� ������� :)
;

..: AT-WORDLIST-CREATING DUP MAKE-EXTR ;..

\ TEMP-WORDLIST �� ���������� WORDLIST (��� ������� AT-WORDLIST-CREATING)
\ � ���� �� ������������ � ����. �������, ���������� � ���������� ��������������:
: TEMP-WORDLIST ( -- wid )
  TEMP-WORDLIST GET-CURRENT >R  DUP SET-CURRENT DUP MAKE-EXTR R> SET-CURRENT
  \ ���������� ��������� ����� ������ ������ ���� � ��� �� ��������� ���������
;

' MAKE-EXTR ENUM-VOCS-FORTH \ ���� ������������ �������� (!!!)

WARNING !

;MODULE
