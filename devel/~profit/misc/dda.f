REQUIRE ��������� ~profit/lib/chartable.f
REQUIRE �����-�������� ~profit/lib/parsecommand.f
REQUIRE FILE ~ac/lib/str5.f
REQUIRE 2VARIABLE lib/include/double.f
S" lib/include/ansi-file.f" INCLUDED

��������� ����������-��������

���: ������ EMIT ;
�������-������: 13 EMIT CR ;

: ��������-�������� ( addr u -- )
FILE SWAP ���������-������
����������-��������
-��������-���������� ;

VARIABLE ������-����������
2VARIABLE �������-����

:NONAME
11 .
������-������������-���������-������
22 .
������-���������� 0!
33 .
BEGIN
35 .
�����-�������� ( addr u )
2DUP CR TYPE CR
44 .
������-���������� @ 0= IF
41 .
�������-���� 2!
ELSE
42 .
������-���������� @ 1 = IF
2DUP ." [" TYPE CR
W/O CREATE-FILE-SHARED THROW TO H-STDLOG

�������-���� 2@  ��������-��������
ELSE 43 . 2DROP THEN THEN

45 .
������-���������� 1+!
55 .
������ C@ 0=
UNTIL 66 .
BYE ;
MAINX !  0 TO SPF-INIT?  FALSE TO ?GUI  S" c:\DDA.exe" SAVE \ BYE