\ �������� AutoPusher-�

S" ~micro/autopush/interface.f" INCLUDED
\ ����䥩�
S" ~micro/autopush/sheduler.f" INCLUDED
\ ᮡ�⢥���� �����窠 � �������஬ ���䨣�
S" ~micro/autopush/add.f" INCLUDED

:NONAME
  ['] MyOk TO OK
  GetDesktopWindow CurrentWindow !
  Lines LinesLeft !
  loadlist
  0 run START DROP
  OK
; MAINX !
S" autopush.exe" SAVE
BYE