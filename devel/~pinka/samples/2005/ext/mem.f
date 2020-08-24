\ 22.Mar.2004 
\ $Id: mem.f,v 1.1 2006/02/10 15:12:56 ruv Exp $

\ [UNDEFINED] HEAP-GLOBAL [IF] [THEN]

\ REQUIRE HEAP-ID! ~pinka\spf\mem.f
( ������� ��������� HEAP-ID -- ���������� ���� )

: NEW-HEAP ( -- h ior )
  0 8000 0 HeapCreate DUP ERR
;
: DEL-HEAP ( h -- ior )
  HeapDestroy ERR
;
: WITH-HEAP   ( xt heap -- )  \ xt WITH HEAP heap 
  HEAP-ID >R  HEAP-ID!
  CATCH   R> HEAP-ID!
  THROW
;
: WITHIN-HEAP ( heap xt -- ) \ heap xt WITHIN-HEAP 
  SWAP WITH-HEAP
;
\ EXECUTE-WITH-HEAP
: EXECUTE-SEPARATE ( ... xt -- ... )
  NEW-HEAP THROW DUP >R
  ['] WITH-HEAP CATCH
  R> DEL-HEAP   SWAP THROW THROW \ ������� �� CATCH
;

: WITH-HEAP-CATCH   ( xt heap -- 0 | ior )  \ xt WITHIN HEAP heap 
  HEAP-ID >R  HEAP-ID!
  CATCH   R> HEAP-ID!
;
: EXECUTE-SEPARATE-CATCH ( i*x  xt -- j*x 0 | i*x  ior )
  NEW-HEAP ?DUP IF NIP EXIT THEN DUP >R
  WITH-HEAP-CATCH
  R> DEL-HEAP OVER IF DROP ELSE NIP THEN \ ������������ ior �� ������ xt
;
