\ ����� �������� ����� ����� � �������� ��������� ���� ���������� z-������
\ program-name

REQUIRE MsgBox ~yz/lib/msgbox.f

: msg ( z --) program-name SWAP msgbox ;
: err ( z --) program-name SWAP 0x30 ( mb_IconastExclaim) MsgBox DROP ;
