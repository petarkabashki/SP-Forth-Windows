\ NOTFOUND ��� SPF/Linux

\ ���� ����� ��� ��������� - ������
' NOOP ' \EOF C" NOTFOUND" FIND NIP 1+ PICK  NIP NIP EXECUTE

: NOTFOUND ( a u -- )
\ ��������� � ������ � �������� � ����  vocname1::wordname
\ ��� vocname1::vocname2::wordname � �.�.
\ ��� vocname1:: wordname
  2DUP 2>R ['] ?SLITERAL CATCH ?DUP IF NIP NIP 2R>
  2DUP S" ::" SEARCH 0= IF 2DROP 2DROP THROW  THEN \ ������ ���� :: ?
  2DROP ROT DROP
  GET-ORDER  N>R
                         BEGIN ( a u )
    2DUP S" ::" SEARCH   WHILE ( a1 u1 a3 u3 )
    2 -2 D+ ( ������� ����������� :: )  2>R
    R@ - 2 - SFIND              IF
    SP@ >R
    ALSO EXECUTE SP@ R> - 0=
    IF CONTEXT ! THEN
                                ELSE  ( a1 u' )
    RDROP RDROP
    NR>  SET-ORDER
    -2011 THROW                 THEN
    2R>                  REPEAT
  NIP 0= IF 2DROP NextWord THEN
  ['] EVAL-WORD CATCH
  NR> SET-ORDER THROW
 ELSE RDROP RDROP THEN
;
