\ � �������� ������� ����� �� ����� (http://fforum.winglion.ru/viewtopic.php?p=7587#7587)

\ ������ ����������� �� �������
\ ������ ������ (��. ����� ����� /TEST ) -- ������ ������
\ ������ -- ������� ������� ���������� ����� in.txt � �������


\ ��� ������� ����� ����������� SPF:
\ http://sourceforge.net/project/showfiles.php?group_id=17919

\ � ���������� ����������:
\ http://sourceforge.net/project/shownotes.php?release_id=497972&group_id=17919

REQUIRE /TEST ~profit/lib/testing.f
REQUIRE HEAP-COPY ~ac/lib/ns/heap-copy.f
REQUIRE FILE ~ac/lib/str5.f
REQUIRE split ~profit/lib/bac4th-str.f
REQUIRE LOCAL ~profit/lib/static.f

: COPY-ARR ( addr1 u1 -- addr2 u2 ) DUP >R HEAP-COPY R> ; 


: tabs>spaces ( addr1 u1 n -- addr2 u2 )
LOCAL tabs tabs !
LOCAL res-addr
LOCAL res-len

START{
concat{ byRows split notEmpty DUP STR@ \ ����� ������ �� ��������� ������
concat{ 9 byChar split \ ����� ������ �� �����������
*> <*> \ �������� "�����" -- ������� ����� ���� ������ ���������� �� �����������
\ � ����� ����� ������ ������������ �� �������� ������ ��� ��������� �� ������� ���������
concat{ \ ���� ������������ ������� ���-�� ��������
START{ PRO DUP STR@ NIP \ ����� ������ ��� ������ ������ ���������� �� �����������
tabs @ MOD tabs @ SWAP - \ ���������� ������ ���-�� ��������
0 ?DO S"  " CONT LOOP }EMERGE \ ���������� ������� �������-�� ���
}concat \ ��� ������� ����� � ���� ������
<* DUP STR@ ( addr u ) }concat DUP STR@ \ ���������� ���� ������: ������� ��� �����: �������-�������-�������-�������-...
\ � ����� �����: ������� ����� ������, ����� -- ������� ������
*> <*> LT LTL @ <* }concat DUP STR@ \ �������� �� ������
COPY-ARR res-len ! res-addr ! }EMERGE \ �������� � ����
\ ����������� concat{  }concat �� ��������� ������ ������� ������ ������� ������, ������� ���������� ����� ����
res-addr @ res-len @ ;

\ ����������� ��� ��� ������������:
\ : tabs>spaces ( addr1 u1 n -- addr2 u2 )
\ LOCAL tabs tabs !
\ LOCAL res-addr
\ LOCAL res-len

\ START{
\ concat{ byRows split notEmpty DUP STR@
\ concat{ 9 byChar split
\ *> <*>
\ concat{ START{ PRO DUP STR@ NIP tabs @ MOD tabs @ SWAP - 0 ?DO S"  " CONT LOOP }EMERGE }concat
\ <* DUP STR@ ( addr u ) }concat DUP STR@ *> <*> LT LTL @ <* }concat DUP STR@
\ COPY-ARR res-len ! res-addr ! }EMERGE
\ res-addr @ res-len @ ;

/TEST
" 	ab	beac	core d
	def	eres	f"
STR@ 7 tabs>spaces TYPE

CR CR

S" in.txt" FILE 7 tabs>spaces TYPE