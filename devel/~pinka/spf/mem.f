\ 03.Oct.2003 Ruv
\ 02.Aug.2004 ������� ��� � ����������������� � mem2.f, 
\             ��� ������� ������� ��� �������������� ������ ��� HEAP-ID
\
\ $Id: mem.f,v 1.6 2008/06/01 14:58:09 ruv Exp $


REQUIRE [DEFINED] lib/include/tools.f

: HEAP-ID! ( heap -- )
\ ���������� ���, � ������� ����� �������� ALLOCATE/FREE
  THREAD-HEAP !
;
: HEAP-ID ( -- heap )
\ ���� ������������� ����� ��� ��� ALLOCATE/FREE
  THREAD-HEAP @
;

\ ===

[DEFINED] GetProcessHeap [IF]

: HEAP-GLOBAL ( -- )
  GetProcessHeap HEAP-ID!
;

[ELSE]

: HEAP-GLOBAL ; \ for linux

[THEN]
