\ 03.Oct.2003 Ruv
\ 02.Aug.2004 перенес код с переопределениями в mem2.f, 
\             тут оставил вариант без дополнительной ячейки для HEAP-ID
\
\ $Id: mem.f,v 1.6 2008/06/01 14:58:09 ruv Exp $


REQUIRE [DEFINED] lib/include/tools.f

: HEAP-ID! ( heap -- )
\ установить хип, с которым будут работать ALLOCATE/FREE
  THREAD-HEAP !
;
: HEAP-ID ( -- heap )
\ дать установленный ранее хип для ALLOCATE/FREE
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
