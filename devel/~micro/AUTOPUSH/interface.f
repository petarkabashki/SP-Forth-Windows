\ ����� ����䥩�

REQUIRE WindowSearch ~micro/autopush/core.f
\ ᫮�� ��

: GetLastChar ( addr u -- c )
\ ������ ��᫥���� ᨬ��� ��ப� addr u
  + 1- C@
;

: WindowSearcher
\ WindowSearcher <name>
\ ᮧ���� ᫮��-�᪠⥫� ����
\ <name> caption<ࠧ����⥫� ��ப�>
\ ��� <ࠧ����⥫� ��ப�> ���� ��᫥���� ᨬ����� <name>
  CREATE
  IMMEDIATE
  LATEST COUNT GetLastChar
  ,
  DOES>
  @ PARSE
  POSTPONE SLITERAL
  POSTPONE WindowSearch
;

WindowSearcher ->"
