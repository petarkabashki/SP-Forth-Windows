\ ------- parser begin ------

: EndOfChunk ( -- flag )
  >IN @ SOURCE NIP < 0=        \ >IN �� ������, ��� ����� �����
;

: CharAddr ( -- c-addr )
  SOURCE DROP >IN @ +
;

: PeekChar ( -- char )
  CharAddr C@       \ ������ �� �������� �������� >IN
;

: IsDelimiter ( char -- flag )
  BL 1+ <
;

: GetChar ( -- char flag )
  EndOfChunk
  IF 0 FALSE
  ELSE PeekChar TRUE THEN
;

: OnDelimiter ( -- flag )
  GetChar SWAP IsDelimiter AND
;

: SkipDelimiters ( -- ) \ ���������� ���������� �������
  BEGIN
    OnDelimiter
  WHILE
    >IN 1+!
  REPEAT
;

: OnNotDelimiter ( -- flag )
  GetChar SWAP IsDelimiter 0= AND
;

: SkipWord ( -- ) \ ���������� ������������ �������
  BEGIN
    OnNotDelimiter
  WHILE
    >IN 1+!
  REPEAT
;

: ParseWord ( -- c-addr u )
  CharAddr >IN @
  SkipWord
  >IN @ SWAP -
;

: NextWord ( -- c-addr u )
  SkipDelimiters ParseWord
;

\ ------- parser end ------

: TEST ( -- )
  BEGIN
    NextWord ?DUP
  WHILE
    TYPE SPACE
  REPEAT DROP
;
