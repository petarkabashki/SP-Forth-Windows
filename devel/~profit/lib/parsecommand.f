REQUIRE ��������� ~profit\lib\chartable.f

��������� �-���������-������
��������� �-��������
��������� ����������-�������

����������-�������
���:  �������-����� �-���������-������ ;
�����������:  ;

�-���������-������
��-�����:  ������ ������-������ ;
���: ������-������ ;
������: " �-�������� ;
�����������:  ����������-������� ;
0 ���������:  ����������-�������  �������-����� ;

�-��������
��-�����:  ������ ������-������ ;
���: ������-������ ;
0 ���������: ����������-�������  �������-����� ;
������: " ����������-������� ;

: ������-������������-���������-������ ( str -- )
���������-������  1 TO ������-������� ;

: �����-�������� ( -- a u )
����������-�������
-1 ���������
�����-���������� 2@
;

\EOF
: ����������-���-���������-������ ( str -- ) 
������-������������-���������-������
BEGIN
�����-�������� CR TYPE
������ C@ 0=
UNTIL ;

CREATE str 2000 ALLOT
: r 
str 2000 ACCEPT  str ������-�-������ ! str + 0 SWAP C!
str ����������-���������-������ ; r