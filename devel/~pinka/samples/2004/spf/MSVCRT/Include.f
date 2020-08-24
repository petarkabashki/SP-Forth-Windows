\ 19.Jan.2004   Ruv
\ $Id: Include.f,v 1.1 2004/03/22 12:25:07 ruv Exp $

( ���������� SPF
  ������� ����������� ������
    �� ���� ������ ����� ����� fgets �� MSVCRT.DLL

  �����������:
    - ��������� �� ������ ��������, ��� SOURCE-ID == fileid
    - � ��������, ������������� SOURCE-ID 
     ������ ��������� ����������� �������� ������� SPF
)
\ �������� �������� ������� (INCLUDED)
\ ��� ������ � ��������� � �������  MsvcrtIncluding
\ � ������� ������� ���� ������ ����� MsvcrtIncluding

\ some from  ~ac\lib\win\file\stream.f 

REQUIRE CAPI: lib\win\api-call\capi.f 

WARNING @  WARNING 0!

MODULE: MsvcrtIncluding

2 CAPI: fopen   MSVCRT.DLL
1 CAPI: fclose  MSVCRT.DLL
1 CAPI: ferror  MSVCRT.DLL
3 CAPI: fgets   MSVCRT.DLL

: chop ( addr -- u )
  ASCIIZ> 2DUP + 1- C@ 10 = IF LTL @ - THEN NIP
;
: R/O S" r" DROP ;

: OPEN-FILE ( addr u mode -- file ior )
  NIP SWAP fopen  DUP 0=
;
: CLOSE-FILE ( file -- ior )
  fclose
;
: OPEN-FILE-SHARED ( c-addr u fam -- fileid ior )
  OPEN-FILE
;
: READ-LINE ( addr u file -- u2 flag ior )
  SWAP ROT fgets  ( res )
  DUP IF chop TRUE 0 EXIT THEN
  DROP 0 FALSE 0
;
: RECEIVE-WITH  ( i*x source xt -- j*x ior )
  ['] READ-LINE SWAP RECEIVE-WITH-XT
;
: INCLUDE-FILE ( i*x fileid -- j*x ) \ 94 FILE
  BLK 0!  DUP >R  
  ['] TranslateFlow RECEIVE-WITH
  R> CLOSE-FILE THROW
  THROW
;
: (INCLUDED2) ( i*x a u -- j*x )
  R/O OPEN-FILE-SHARED THROW
  INCLUDE-FILE
;
' (INCLUDED2) TO (INCLUDED)

;MODULE

WARNING !
