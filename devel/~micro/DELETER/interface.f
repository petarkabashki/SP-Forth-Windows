S" ~micro\deleter\core.f" INCLUDED
\ ���

: del
\ del <��⠫��>
\ ��������� �ணࠬ�� 㤠���� 䠩��� �� ��⠫���
  NextWord
  POSTPONE SLITERAL
  POSTPONE DeleteFromDir
; IMMEDIATE

: arch
\ arch <��⠫��> <䠩�>
\ ��������� �ணࠬ�� ��� 䠩��� �� ��⠫��� � 䠩�
  NextWord POSTPONE SLITERAL 
  NextWord POSTPONE SLITERAL
  POSTPONE Arch
; IMMEDIATE

