REQUIRE ShowStatusLine ~micro/autopush/console.f
\ ࠡ�� � ���᮫��

: INCLUDED-SCRIPT
\ ����㧪� �ணࠬ�� � �஢�મ� ������ �⥪�
  DEPTH 2- >R
  ['] INCLUDED CATCH
  DEPTH 1- R> <> OR
  ABORT" �訡�� � �ਯ�"
;

0 VALUE Delay
\ ����প� ����� ᪠��஢���ﬨ ���� � 楫�� ���� ���室�饥 � ��
VECT scan
\ ᪠��஢���

: scanner
\ ��砫� ᯨ᪠ ᪠��஢����
  :NONAME
;

: ;scanner
\ ����� ᯨ᪠
  POSTPONE ;
  TO scan
; IMMEDIATE

:NONAME
\ ������ 横�
  DROP
  BEGIN
    scan
    ShowStatusLine
    Delay PAUSE
  AGAIN
; TASK: run
\ �����

: loadlist
\ ����㧨�� ᯨ᮪.
  S" autopush.cfg" INCLUDED-SCRIPT
;

100 TO Delay
