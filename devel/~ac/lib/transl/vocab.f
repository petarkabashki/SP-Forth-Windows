( 03.Mar.2000 Andrey Cherezov )

( ���������� ������:
  VOCABULARY TextMbox
  GET-CURRENT ALSO TextMbox DEFINITIONS
  ...
  PREVIOUS SET-CURRENT

  ������ ����� ������ ���:
  InVoc{ TextMbox
  ...
  }PrevVoc

  ����� ����� ������������ �����
  Public{
  : WORD1 ... ;
  }Public
  ��� "��������" ����������� �� ������� �������
)

: InVoc{ ( "vocabulary" -- current )
\ ��������� ����� ����� ��������������� � ������� "vocabulary"

  >IN @ ['] ' CATCH
  IF >IN ! VOCABULARY GET-CURRENT
     ALSO LATEST NAME> EXECUTE DEFINITIONS
  ELSE 
     NIP GET-CURRENT SWAP ALSO EXECUTE DEFINITIONS
  THEN
;

: }PrevVoc ( current -- )
\ ������� ORDER � ��������� ����� InVoc

  PREVIOUS SET-CURRENT
;

: Public{ ( current1 -- current1 current2 )
\ ��������� ����� ����� ����� ����� �������� ������� (� ������������ �������)

  GET-CURRENT OVER SET-CURRENT
;

: }Public ( curren1 current2 -- current1 )

  SET-CURRENT
;