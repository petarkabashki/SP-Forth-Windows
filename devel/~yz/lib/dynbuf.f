\ �������᪨� ����: �������� �� ��� ����室�����
\ �. �������, 13.04.2003

MODULE: DYNBUF

0
\ ᬥ饭�� �� ��砫� ������
CELL -- :dynptr  \ ⥪�騩 㪠��⥫�
CELL -- :dynsize \ ⥪�騩 ࠧ��� ����
== /dynbufheader

EXPORT

: CREATE-DYNBUF ( initsize -- dyn)
  DUP /dynbufheader + GETMEM >R
  R@ :dynptr 0!
  R@ :dynsize !
  R> /dynbufheader + ;

: DEL-DYNBUF ( dyn -- ) /dynbufheader - FREEMEM ;

: DYNSIZE ( dyn -- size) /dynbufheader - :dynptr @ ;

: DYNALLOC ( size dyn -- dataptr newdyn) /dynbufheader - >R
  ( size) R@ :dynptr @ OVER + R@ :dynsize @ > IF
    \ �����塞 ࠧ��� ����, �������� � ���� size*5 ����
    ( size) DUP 5 * DUP R@ :dynsize +! R> SWAP RESIZE THROW >R
  THEN
  ( size) R@ :dynptr @ R@ + /dynbufheader + 
  SWAP R@ :dynptr +! R> /dynbufheader + ;

;MODULE
