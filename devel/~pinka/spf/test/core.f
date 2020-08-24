\ 17.Nov.2008
\ $Id: core.f,v 1.2 2008/11/17 21:01:01 ruv Exp $

REQUIRE Wait ~pinka/lib/multi/Synchr.f
REQUIRE TESTCASES ~ygrek/lib/testcase.f

TESTCASES EXC-NO-FRAME

: demark-frame ( -- flag )
\ ����������� "�������" � ����� ������, ����� �� ��� �� ������ � "(EXC)"
  0 FS@
  DUP CELL- @ ['] DROP-EXC-HANDLER <> IF DROP FALSE EXIT THEN
  CELL- 1+!
  TRUE
;

: ttt CR demark-frame  0 / ; ' ttt TASK: tt

: t 0 tt START DUP >R 1000 Wait R> CloseHandle DROP ;

(( demark-frame -> TRUE ))
(( t -> TRUE ))

END-TESTCASES
