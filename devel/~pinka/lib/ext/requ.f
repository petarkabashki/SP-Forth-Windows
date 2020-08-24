\ 31.Mar.2002 Sun 13:57 
\ 28.Jun.2002 Fri 16:01 ��� Eproxy (�.�., � ������� � �� spf3)
\ 19.Aug.2004 Thu 23:21 ������� ������  spf4 compatible,
\                       ���� � ����������� cvs  (����� ���� ��� ����!).
\ $Id: requ.f,v 1.2 2004/08/26 03:23:59 ruv Exp $

( ����� Included Include Required Require
  ������ ����� ������������� ����� �� ������ �������������� �������������� �����.

  ���������� ����������, ��� ������ � html - ���� ������ �������������,
  �� �� ������ ��� ����������� �� ������ ���� ����������� �� ���������.

  ������� ���������, ��� ���� ������������ ���������� ���� ����,
  �� _������_ �� ��������, ����� ���� ����� ���������������
  �� ����� �� ���������� �, ������, ����� ��������� ����.
)

REQUIRE [DEFINED] lib\include\tools.f

\ WARNING @ WARNING 0!

[UNDEFINED] SOURCE-NAME! [IF]

: SOURCE-NAME! ( addr u -- )
  HEAP-COPY CURFILE !
;
[THEN]
[UNDEFINED] path_delimiter [IF]

CHAR \ VALUE path_delimiter

[THEN]

: +Path ( addr u path-a path-u -- addr2 u2 )
\ ������� ����\���  � PAD
  DUP IF 2DUP + 1- C@ is_path_delimiter 0= ELSE 0 THEN >R
  2SWAP
  <# HOLDS R> IF path_delimiter HOLD THEN HOLDS 0. #>
  2DUP + 0!
;
: +SourcePath ( addr u -- addr2 u2 )
  SOURCE-NAME CUT-PATH +Path
;
: FIND-FULLNAME2 ( a1 u1 -- a u )
  2DUP +SourcePath      2DUP FILE-EXIST IF 2SWAP 2DROP EXIT THEN 2DROP
  2DUP FILE-EXIST IF EXIT THEN
[DEFINED] +LibraryDirName [IF]
  2DUP +LibraryDirName  2DUP FILE-EXIST IF 2SWAP 2DROP EXIT THEN 2DROP
[THEN]
  2DUP +ModuleDirName   2DUP FILE-EXIST IF 2SWAP 2DROP EXIT THEN 2DROP
  2 ( ERROR_FILE_NOT_FOUND ) THROW
;
[DEFINED] INCLUDED_STD [IF]
: Included ( i*x c-addr u -- j*x ) \ 94 FILE
  FIND-FULLNAME2 INCLUDED_STD
;
[ELSE]
: Included ( i*x c-addr u -- j*x ) \ 94 FILE
  FIND-FULLNAME2 INCLUDED
;
[THEN]

: Include ( i*x "filename" -- j*x )
  NextWord 2DUP + 0 SWAP C! Included
;
\ =======================================
\ ����������� � ��������� �� ��������� �����
\ ��� �������������� ��������� ���������

: Required ( waddr wu laddr lu -- )
  2SWAP SFIND IF DROP 2DROP EXIT THEN 2DROP
  Included
;
: Require ( "word" "libpath" -- )
  NextWord NextWord 2DUP + 0 SWAP C!
  Required
;

\ WARNING !
