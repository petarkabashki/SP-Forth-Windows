VARIABLE DeleteTime
\ �६� ����� 㤠����ﬨ � ��

: Time
\ ������� �६��� ����� 㤠����ﬨ
  0.
  NextWord
  >NUMBER ABORT" Bad number"
  DROP
  D>S
  DeleteTime !
; IMMEDIATE

: ms ; IMMEDIATE
: sec DeleteTime @ 1000 * DeleteTime ! ; IMMEDIATE
: min DeleteTime @ 60000 * DeleteTime ! ; IMMEDIATE
\ ����⠡�஢���� � ���⮬ ������� ����७��

: Wait
\ ��⠭���� �� �������� �६�
  DeleteTime @ PAUSE
;

: LoadList ( -- xt )
\ ����㧪� ���䨣�
  :NONAME
  POSTPONE BEGIN
  S" deleter.cfg" INCLUDED
  POSTPONE Wait
  POSTPONE AGAIN
  POSTPONE ;
;

