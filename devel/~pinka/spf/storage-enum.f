\ 26.Jul.2007 ���������� �� exc-dump.f
\ $Id: storage-enum.f,v 1.3 2008/09/03 12:15:14 ruv Exp $
( ������ ������������� ENUM-STORAGES � ��������� WordByAddr ��� ��������� ��������.
)

REQUIRE NEW-STORAGE  ~pinka/spf/storage.f
REQUIRE [UNDEFINED] lib/include/tools.f

MODULE: storage-support

REQUIRE BIND-NODE ~pinka/samples/2006/lib/plain-list.f

USER STORAGE-LIST \ ������ ��������, ��������� �������

: excide-this ( -- ) \ ��������
  STORAGE-ID STORAGE-LIST FIND-LIST IF UNBIND-NODE DROP THEN
;
: enroll-this ( -- ) \ �������
  excide-this
  0 , HERE STORAGE-ID , STORAGE-LIST BIND-NODE
;

..: AT-FORMATING         enroll-this  ;..
..: AT-STORAGE-DELETING  excide-this  ;..

: (WITHIN-STORAGE) ( xt h -- xt ) \ for inner purpose only
  \ OVER DISMOUNT 2>R MOUNT EXECUTE 2R> MOUNT
  OVER STORAGE @ 2>R STORAGE ! CATCH R> STORAGE ! THROW R>
;

EXPORT

: ENUM-STORAGES ( xt -- ) \ xt ( h -- )
  >R FORTH-STORAGE R@ EXECUTE
  R> STORAGE-LIST FOREACH-LIST-VALUE
;

DEFINITIONS

: ENUM-STORAGES-WITHIN ( xt -- ) \ xt ( -- ) \ for inner purpose only
  ['] (WITHIN-STORAGE) ENUM-STORAGES DROP
;

\ EXPORT

: (NEAREST_STOR) ( addr nfa1|0 -- addr nfa2|0 )
  [ ' (NEAREST-NFA) BEHAVIOR LIT, ]  ENUM-STORAGES-WITHIN
  CONTEXT @ DUP 0= IF DROP EXIT THEN WL-STORAGE
  DUP STORAGE-ID = IF DROP EXIT THEN ( h )
  [ ' (NEAREST-NFA) BEHAVIOR LIT, ] SWAP (WITHIN-STORAGE) DROP
;

' (NEAREST_STOR) TO (NEAREST-NFA)

;MODULE

Require VOCS vocs.f
