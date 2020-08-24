\ ���������� string.f
\ � �������� ���������...

REQUIRE SADD ~day\lib\string.f
REQUIRE {    lib\ext\locals.f

(
��������� ������:
- ����� � �������� ����� � ������
- ����� ������� ������� ������� � ������
- �������� ��������� �� ��� � �� ��� ��� ����� ������
- ������� ������ 1 � ������� �����-�� � ������ 2
- ������������� ������ � UNICODE
- ������������� ������ �� UNICODE
)

: StrLChar ( c addr -- addr1 f )
\ ����� ������ c � ������ �� ������� ����� �����, ������ ������� � u,
\ ���������� ������� u1 ������� ������� � 0 � TRUE,
\ ����� u1 ������������, f=FALSE
;

: StrRChar ( c addr -- addr1 f )
;

: StrSub ( u1 u2 S: s -- S: s s1 )
;

: StrPutDown ( addr u u1 S: s1 -- S: s2 )
;

: StrLReplace ( addr1 u1 addr2 u2 u3 -- u4 f )
;

: StrRReplace ( addr1 u1 addr2 u2 u3 S: s -- u4 f S: s1 )
;

: Str2Unicode
;

: Str2Plain
;

: StrCmp ( addr u addr1 -- f )
\ ���������� � ������ addr1
;

: StrSearch ( addr u addr1 -- c-addr3 u3 flag )
\ ������ � ������ addr1
;

: StrCopy ( addr u )
\ ���������� ������ addr u � ������ �� ������� ����� �����
\ ���� ����� ����� ������ ��� ����� ��������, ��������� ����� ������
;

: StrUpper ( S: s -- S: s1 )
;

: StrLower ( S: s -- S: s1 )
;