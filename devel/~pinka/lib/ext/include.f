\ 30.Mar.2004 Tue 23:26 ruv
\ 19.Aug.2004 Thu 21:30 �����������.
\ $Id: include.f,v 1.5 2004/08/21 09:39:18 ruv Exp $

\ ���������� ����  -WITH  ��.:
\ From: Michael Gassanenko <mlg@forth.org>
\ To: sp-forth@egroups.com
\ Date: Sat, 23 Dec 2000 07:52:01 +0300
\ Subject: Re: [sp-forth] EVALUATE-WITH (filtered)
\ Message-ID: <3A442F71.8C7830DC@forth.org>

REQUIRE [UNDEFINED]  lib\include\tools.f

[UNDEFINED] INCLUDED-WITH [IF]

\  �� �������� �� ������� INCLUDED � EVALUATE-WITH 

: INCLUDED-WITH ( a u  xt  -- )
\ ��������� ������������ ������� �������� ������.
\ ���������� ������� ����� � ������������ � ��������������� ��������� a u
\ (��� ������, ��� REFILL ����� ������ �� ���������� ���������).
\ ��������� xt.
\ ������������ ������������ �������� ������.
\ ������ ��������� ����� ������������ �������� xt ������.
\ ���� ��������� ����������, ������������ �������� ������
\ ������ ���� ������ ��, ��� �� ������ ����� �����.
  -ROT
  CURFILE @ >R
  2DUP R/O OPEN-FILE-SHARED THROW >R
  HEAP-COPY CURFILE !
  R@ SWAP RECEIVE-WITH ( fileid xt -- ior )
  R> CLOSE-FILE     SWAP
  CURFILE @ FREE    SWAP
  R> CURFILE !      THROW THROW THROW
;
[THEN]

[UNDEFINED] INCLUDED-LINES-WITH [IF]
: TranslateFlowWith ( xt -- )
  >R BEGIN REFILL WHILE R@ EXECUTE REPEAT RDROP
;
: INCLUDED-LINES-WITH ( a u  xt  -- )
\ �����, ��� INCLUDED-WITH,
\ �� ��������� xt ����� ������� ���������� �������� ������.
  -ROT ['] TranslateFlowWith INCLUDED-WITH
;
[THEN]

[UNDEFINED] INCLUDE-FILE-WITH [IF]

\ �� �������� �� ������ INCLUDE-FILE 

: INCLUDE-FILE-WITH ( i*x fileid xt -- j*x )
  OVER >R  RECEIVE-WITH
  R> CLOSE-FILE SWAP THROW THROW
;
[THEN]


\ ===
\ ��������� ������ ���� ���� ����  (discouraged words)
\ - ������ ��� �������������! 

[UNDEFINED] INCLUDE-WITH [IF]
: INCLUDE-WITH INCLUDED-WITH ;
[THEN]
[UNDEFINED] INCLUDE-LIENS-WITH [IF]
: INCLUDE-LINES-WITH INCLUDED-LINES-WITH ;
[THEN]
[UNDEFINED] INCLUDE-SFILE-WITH [IF]
: INCLUDE-SFILE-WITH INCLUDED-WITH ;
[THEN]
