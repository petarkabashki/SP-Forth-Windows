\ � �������� ������� ����� �� ����� (http://fforum.winglion.ru/viewtopic.php?p=7587#7587) 

\ ������ ����������� �� �������-2 
\ ������ ������ (��. ����� ����� /TEST ) -- ������ ������ 
\ ������ -- ������� ������� ���������� ����� in.txt � ������� 


\ ��� ������� ����� ����������� SPF: 
\ http://sourceforge.net/project/showfiles.php?group_id=17919 

\ � ���������� ����������: 
\ http://sourceforge.net/project/shownotes.php?release_id=497972&group_id=17919 

REQUIRE /TEST ~profit/lib/testing.f 
REQUIRE ��������� ~profit/lib/chartable.f 
REQUIRE (: ~yz/lib/inline.f 
REQUIRE FILE ~ac/lib/str5.f 
REQUIRE TYPE>STR ~ygrek/lib/typestr.f 

MODULE: tabsspaces2 

������ �����������-����� \ ���� ������� ����� ������ 

VARIABLE ������-���������� 

EXPORT 

��������� ������-���������� 
��-�����:  ������ ������-������ ; \ ������ ������� 

���:  ������-������ ; 

�������-������: 
�����������-����� 2@ TYPE CR 
������-���������� ; 

9 asc: 
�����������-����� ��������� 
�����������-����� 2@ TYPE 
�����������-����� ����� ������-���������� @ TUCK MOD - SPACES 
������-���������� ; 

������-���������: �����������-����� ���������  �����������-����� 2@ TYPE ;


: tabs>spaces ( addr1 u1 n -- addr2 u2 ) 
������-���������� ! 

1 TO ������-������� SWAP ���������-������ 
(: ������-���������� -��������-���������� ;) TYPE>STR STR@ ; 

;MODULE 


/TEST 
" sds"
STR@ 7 tabs>spaces TYPE

CR CR 

S" in.txt" FILE 7 tabs>spaces TYPE