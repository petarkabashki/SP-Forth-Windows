\ $Id: split-test.f,v 1.3 2005/03/27 15:06:55 ruv Exp $
\ see also split.f

: SPLIT0 ( a u a1 u1 -- a3 u3 a2 u2 true | a u false )
\ ��������� ������ a u �� ����� ����� (a2 u2) �� ��������� a1 u1
\ � �� ����� ������ (a3 u3) �� ���� ���������.

  2OVER DROP >R DUP >R ( R: a u1 )
  SEARCH   IF  ( aa uu )
  OVER R@ + SWAP R> - \ aa+u1 uu-u1  - right part
  ROT R@ - R> SWAP    \ a aa-a       - left part
  TRUE               ELSE
  2R> 2DROP FALSE    THEN
;

REQUIRE { lib/ext/locals.f

: SPLIT1 ( a u a1 u1 -- a3 u3 a2 u2 true | a u false )
\ ��������� ������ a u �� ����� ����� (a2 u2) �� ��������� a1 u1
\ � �� ����� ������ (a3 u3) �� ���� ���������.

  { a u a1 u1 \ aa uu }
  a u a1 u1 SEARCH   IF
  -> uu -> aa
  aa u1 + uu u1 -
  a  aa a -
  TRUE               ELSE
  FALSE              THEN
;

~pinka\lib\Tools\profiler.f

: t0-(no_locals)
  1000000 0 DO
  S" aaaaaaa|bb|cccccccc" S" bb" SPLIT0 DROP 2DROP 2DROP
  LOOP
;
: t1-(with_locals)
  1000000 0 DO
  S" aaaaaaa|bb|cccccccc" S" bb" SPLIT1 DROP 2DROP 2DROP
  LOOP
;
profile off
: test
  \ t1 t0 \ t1
  t0-(no_locals)
  t1-(with_locals)
  .AllStatistic
;
