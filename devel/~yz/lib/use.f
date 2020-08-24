\ ������祭�� ��楤�� �� �������᪨� ������⥪
\ ��� �ᯮ�짮����� WINAPI: 
\ �. �������, 11.04.2003

REQUIRE "              ~yz/lib/common.f
REQUIRE LOAD-NAMETABLE ~yz/lib/nametable.f
REQUIRE DYNSIZE        ~yz/lib/dynbuf.f

MODULE: USEDLL

\ ��ଠ� 䠩�� ����. �������⥫�� �����:
\ CELL ��뫪� �� ����� ��⠫��� ������
\ ...  ��� ������⥪�
\ � ���� ������� ����� ������� ��譨� �㫥��� ����
\ (�⮡� �� �������� � �८�ࠧ������� ��ப)

VARIABLE import-chain  import-chain 0!

VECT prevNOTFOUND

\ ----------------------------------
: >footer DUP CELL+ @ + ;

EXPORT

0 VALUE IMPORT-DIR
0 VALUE IMPORT-RELOC

0
CELL -- :idlist1    \ ��������: ᯨ᮪ ��뫮� �� �����
CELL -- :iddatetime \ ��������: ���稪 ����㦥���� �㭪権
CELL -- :idfwdchain \ ��������: ���ਯ�� ������⥪�
CELL -- :idlibname  \ ��������: ��뫪� �� ����㦥��� .names 䠩�
CELL -- :idlist2    \ ��������: ᯨ᮪ ����㦥���� �㭪権
CONSTANT /importdir

\ �ଠ� �맮��: hiword - ����� ������⥪� � ��⠫���, 
\ loword - ����� �㭪樨 � ��襬 ᯨ᪥ ����㦥���� ��楤�� (�� �न���)

: DLLGetAddrLoc ( procid -- addr) 
  DUP HIWORD /importdir * IMPORT-DIR + :idlist2 @ IMPORT-RELOC +
  SWAP LOWORD CELLS + ;

: DLLCALL ( ... n -- res ) DLLGetAddrLoc @ API-CALL ;

: USE ( ->bl; -- )
  IMPORT-DIR 0= IF /importdir 5 * CREATE-DYNBUF TO IMPORT-DIR THEN
  \ ��������㥬 ��� 䠩�� ⠡���� ���� � ��㧨� ���
  HERE 0 ModuleDirName SAPPEND S" devel\~yz\dll\" SAPPEND
  BL PARSE SAPPEND S" .names" 1+ SAPPEND LOAD-NAMETABLE 
  \ ��訢��� 楯� ��⠫���� ������
  DUP import-chain STITCH-NAMETABLE-CHAIN 
  \ ������� ���� ��⠫�� ������
  ( nt) /importdir IMPORT-DIR DYNALLOC TO IMPORT-DIR >R
  \ �⠢�� � ⠡��� ������ ��뫪� �� ��⠫�� ������
  ( nt) R@ OVER >footer !
  \ ������塞 ��⠫�� ������
  ( nt) R@ :idlibname !
  20 CELLS CREATE-DYNBUF R@ :idlist1 !
  20 CELLS CREATE-DYNBUF R@ :idlist2 !
  R@ :idlibname @ >footer CELL+ LoadLibraryA
  ?DUP 0= ABORT" �� ���� ����㧨�� ���������� ������⥪�"
  R> :idfwdchain ! ;

: bind-proc ( namerec-a -- procid ) 
  >R THIS-NAMETABLE >footer @ ( idir) >R
  \ � ���� ᯨ᮪ �⠢�� ��뫪� �� ��� ��楤���
  CELL R@ :idlist1 @ DYNALLOC R@ :idlist1 ! 
  ( 2-� ����� �⥪� �����⮢ - ���� ����� � ������)
  RP@ CELL+ @ CELL+ 1+ DUP >R SWAP !
  \ �� ��ன ᯨ᮪ �⠢�� ॠ��� ���� ����㦥���� ��楤���
  R> R@ :idfwdchain @ GetProcAddress
  ?DUP 0= ABORT" �� ���� ����㧨�� ��楤���"
  CELL R@ :idlist2 @ DYNALLOC R@ :idlist2 ! !
  \ 㧭��� ����� ��⠫��� � ⠡��� ������
  R@ IMPORT-DIR - /importdir /
  \ ��������㥬 ��� ��楤���
  16 LSHIFT R@ :iddatetime @ OR
  \ 㢥��稢��� ���稪 ��楤��
  R> :iddatetime 1+!
  \ ���������� ��� ��楤��� � ����� ⠡���� ����
  DUP R> ! ;

: DLLProcID ( name-a name-n -- procid/-1)
  import-chain @ -ROT SEARCH-NAMETABLE-CHAIN
  ?DUP 0= IF -1 EXIT THEN
  DUP @ DUP -1 = IF DROP bind-proc ELSE PRESS THEN ;

' NOTFOUND TO prevNOTFOUND

WARNING 0!

: NOTFOUND ( a n -- )
  2DUP DLLProcID 
  DUP -1 = IF 
    DROP prevNOTFOUND
  ELSE
    PRESS PRESS STATE @ IF [COMPILE] LITERAL POSTPONE DLLCALL ELSE DLLCALL THEN
  THEN
; IMMEDIATE

TRUE WARNING !

\ �������� ��� �㭪樨, ����� �ॡ����� ��� �ࠢ��쭮� ࠡ��� WINAPI:
\ ���, ����筮, � ��� ��� ����㦥��, �� ���ॡ����� � ��࠭����� ��-䠩��

USE KERNEL32
S" LoadLibraryA" DLLProcID DROP
S" GetProcAddress" DLLProcID DROP

;MODULE
