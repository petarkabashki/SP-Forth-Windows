\ 02-05-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �������� ���

CREATE psevdoregs

\ ���������� ��� ��������������� ������ ����.
\ ESP - ��������� ����� ���������
\ EBP - ��������� ����� ������
\ EDI - ����������� ������� [��������� ������ ������ � SPF]

\ -- �������� �������� ------------------------------------------------------
MACRO: tos          EAX   ENDM \ ������� ����� ������
MACRO: tos-byte     AL    ENDM \ ������� ���� tos
MACRO: tos-word     AX    ENDM \ ������� ��� ����� tos
MACRO: [tos]        [EAX] ENDM
MACRO: [tos*CELL]   [EAX*4] ENDM
MACRO: top          EBP   ENDM \ ��������� �� ������� ����� ������
MACRO: [top]        [EBP] ENDM
MACRO: subtop       [EBP] ENDM \ ���������� ����� ������
MACRO: rtop         ESP   ENDM \ ������� ����� ��������� - ���������
MACRO: [rtop]       [ESP] ENDM
MACRO: tls          EDI   ENDM \ ������� �������� ������� ������ ������
MACRO: [tls]        [EDI] ENDM

\ -- �������������� �������� ------------------------------------------------
MACRO: addr         EBX   ENDM \ ������������ ��� ���������� �������� �������
MACRO: [addr]       [EBX] ENDM \
MACRO: temp         EDX   ENDM \ ��� ���������� �������� ������
MACRO: temp-byte    DL    ENDM \
MACRO: temp-word    DX    ENDM \
MACRO: templ        ESI   ENDM \ ��� ���� ��������� �������
MACRO: cntr         ECX   ENDM \ ��������� ������� ��� �������� ��������
