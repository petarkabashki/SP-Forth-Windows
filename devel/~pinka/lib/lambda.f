\ ������-�����������.
\ ��� ��� SPF
\ ����:  SU.FORTH, �� Piter Sovietov
\ Ruvim,  06.01.2000
\ 14.May.2007 ��������� ��������� LAST-NON ��� RECURSE (true-grue, ygrek)

REQUIRE AHEAD lib/include/tools.f 

: LAMBDA{  ( -- )
\ ����� ����������  ( -- orig1 xt )
   LAST-NON
   POSTPONE  AHEAD
   HERE 
   DUP TO LAST-NON
; IMMEDIATE

: }        ( -- xt )
\ ����� ����������  ( orig1 xt -- )
\ ��� ������ ����������� LAMBDA{  } �� �����������, ������������ xt �� ���� ���.
   >R
   POSTPONE EXIT
   POSTPONE THEN
   R> POSTPONE LITERAL
   TO LAST-NON
; IMMEDIATE


( ��� �����  LAMBDA{ ... }   �������� ��� � ��������� �����.
  ������� ��� ����. ���������� ������� � ��������� ���������� �� �����.
)