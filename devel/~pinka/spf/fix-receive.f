\ 07.Dec.2006
\ used by fix-refill.f
\ $Id: fix-receive.f,v 1.3 2007/11/03 18:02:33 ruv Exp $

MODULE: CORE_OF_REFILL

: readout ( a u1 -- a u2 ior )
  SOURCE-ID READOUT-FILE
;
: VARIABLE USER ; \ (!!!)
' readout S" next-line.proto.f" Included

5 1024 *  C/L CELL+  UMAX  VALUE /BUF

EXPORT

: READOUT-SOURCE ( addr u1 -- addr u2 )
\ ������ �������� ������ �� �������� ������ 
\ ��, ��� ��� ���� REFILL, ��� ����������.
  SOURCE-ID 0 > IF READOUT EXIT THEN
  SOURCE-ID 0= IF READOUT-STDIN EXIT THEN
  DROP 0
;

: SAVE-SOURCE ( -- i*x i )
  SAVE-SOURCE >R
  B0 @ R @ W @ B9 @  4 R> +
;
: RESTORE-SOURCE ( i*x i  -- )
  4 - >R  B9 ! W ! R ! B0 !
  R> RESTORE-SOURCE
;

' RECEIVE-WITH \ ������������ � DECODE-ERROR, ������� ���� � ������ ������� ���������

: RECEIVE-WITH  ( i*x source xt -- j*x ior )
  SAVE-SOURCE N>R
  SWAP TO SOURCE-ID
  /BUF DUP ALLOCATE THROW DUP >R SWAP BUF!
  REST SOURCE! CURSTR 0!  0 TO SOURCE-ID-XT
  CATCH  DUP IF PROCESS-ERR ( err -- err ) THEN
  R> FREE THROW
  NR> RESTORE-SOURCE
;

' RECEIVE-WITH SWAP REPLACE-WORD

\ RECEIVE-WITH-XT  �������� ������, ��� ����� ��� ������

: (?SET-SOURCE) ( a u true -- true || false -- false )
  IF SOURCE! CURSTR 1+! <PRE> TRUE EXIT THEN FALSE
;

: REFILL_new ( -- flag )
  SOURCE-ID DUP -1 = IF DROP FALSE EXIT THEN
  0= IF NEXT-LINE-STDIN (?SET-SOURCE) EXIT THEN

  B0 @ 0=  SOURCE-ID-XT OR
  IF [ ' REFILL BEHAVIOR COMPILE, ] EXIT THEN
  \ workaround for current files

  NEXT-LINE (?SET-SOURCE)
;

: INCLUDE-FILE_new ( i*x fileid -- j*x ) \ 94 FILE
  BLK 0!  DUP >R
  ['] TranslateFlow RECEIVE-WITH
  R> CLOSE-FILE THROW
  THROW
;

;MODULE

' INCLUDE-FILE_new ' INCLUDE-FILE REPLACE-WORD
' REFILL_new TO REFILL