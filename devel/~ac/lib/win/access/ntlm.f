\ ��������� ��������� NTLM (���������� ����� �������� � �������� ��� �����������)

REQUIRE {          lib/ext/locals.f
REQUIRE debase64   ~ac/lib/string/conv.f
REQUIRE LocalLogon ~ac/lib/win/access/sspi_logon.f 

\ NTLM_mes1 NEGOTIATE_MESSAGE �� ������� �������
0
8 -- ntlm_protocol \ asciiz "NTLMSSP"
1 -- ntlm_type     \ 0x01
3 -- ntlm_zero1    \ ����
2 -- ntlm_flags1   \ 0xB203 ��� 0xB207 ��� x8207
2 -- ntlm_flags2   \ 0xA208 ��� 0x0008
2 -- ntlm_domlen1  \ ����� ����� ������ ��� ������� ������ (�� asciiz)
2 -- ntlm_domlen2  \ �� �� (maxlen)
4 -- ntlm_domoffs  \ �������� ����� ������
2 -- ntlm_hostlen1 \ ����� ����� ����� (WorkstationLen)
2 -- ntlm_hostlen2 \ �� �� (maxlen)
4 -- ntlm_hostoffs \ �������� ����� �����
1 -- ntlm_wprodmaj \ ProductMajorVersion (Windows - 6 ��� 5)
1 -- ntlm_wprodmin \ ProductMinorVersion (Windows - 0..2)
2 -- ntlm_wbuild   \ ProductBuild
3 -- ntlm_reserved \ ����
1 -- ntlm_revision \ NTLMSSP_REVISION_W2K3=0x0F, NTLMSSP_REVISION_W2K3_RC1=0x0A
\ ����� ���������� ��� ����� � ������
CONSTANT /NTLM_mes1

\ NTLM_mes2 CHALLENGE_MESSAGE �� ������� �������
0
8 -- ntlm2_protocol \ asciiz "NTLMSSP"
1 -- ntlm2_type     \ 0x02
3 -- ntlm2_zero4    \ ����
2 -- ntlm2_targlen1 \ ����� TargetName (�����) ��� ����
2 -- ntlm2_targlen2 \ �� ��
4 -- ntlm2_targoffs \ �������� TargetName ��� 0x28 (/NTLM_mes2), ���� ��� ���
2 -- ntlm2_flags1   \ 0x8205 ��� 0x8201, ���� TargetName ���
2 -- ntlm2_flags2   \ ... ��� ����
8 -- ntlm2_mes      \ 64-bit challenge
8 -- ntlm2_reserv1  \ ����������� ����

2 -- ntlm2_tinflen1 \ ����� TargetInfo, ���� ����, ���� ���� NTLMSSP_NEGOTIATE_TARGET_INFO
2 -- ntlm2_tinflen2 \ �� ��
4 -- ntlm2_tinfoffs \ �������� TargetInfo

1 -- ntlm2_wprodmaj \ ProductMajorVersion (Windows - 6 ��� 5)
1 -- ntlm2_wprodmin \ ProductMinorVersion (Windows - 0..2)
2 -- ntlm2_wbuild   \ ProductBuild
3 -- ntlm2_reserved \ ����
1 -- ntlm2_revision \ NTLMSSP_REVISION_W2K3=0x0F, NTLMSSP_REVISION_W2K3_RC1=0x0A

CONSTANT /NTLM_mes2

CREATE NTLM_mes2 CHAR N C, CHAR T C, CHAR L C, CHAR M C, CHAR S C, CHAR S C, CHAR P C, 0 C,
2 , 0 , 40 , 0x8201 , 0 , 0 , 0 , 0 , 

\ challenge-��������� ������� � ������, ���� �� ������� �� �������� SSPI
\ ��� ������ � ������ � ������ �������, � ������ �����, ��� ��-windows-����
: BNTLM_mes2 NTLM_mes2 0x28 ( /NTLM_mes2 ) base64 ;

\ NTLM_mes3 AUTHENTICATE_MESSAGE �� ������� �������
0
8 -- ntlm3_protocol \ asciiz "NTLMSSP"
1 -- ntlm3_type     \ 0x03 (NtLmAuthenticate)
3 -- ntlm3_zero8    \ ����
2 -- ntlm3_resplen1 \ ����� ������ LanManager (0x18)
2 -- ntlm3_resplen2 \ �� ��
4 -- ntlm3_respoffs \ �������� ������ LanManager
2 -- ntlm3_ntrespl1 \ ����� ������ NT (0x38 ��� 0x18)
2 -- ntlm3_ntrespl2 \ �� ��
4 -- ntlm3_ntrespof \ �������� ������ NT
2 -- ntlm3_domlen1  \ ����� ������ � ������,
                    \ ��� ����� � ���� unicode (������ ������� ������ ��� ����� ���������)
2 -- ntlm3_domlen2  \ �� ��
4 -- ntlm3_domoffs  \ �������� ����� ������
2 -- ntlm3_userlen1 \ ����� ������ � ������ (��� ����� � unicode = UTF-16LE)
2 -- ntlm3_userlen2 \ �� ��
4 -- ntlm3_useroffs \ �������� ������
2 -- ntlm3_hostlen1 \ ����� ����� � ������ (��� � unicode ����������)
2 -- ntlm3_hostlen2 \ �� ��
4 -- ntlm3_hostoffs \ �������� ����� �����
2 -- ntlm3_seskeyl1 \ ����� ����������� ����� (�� �������� 0)
2 -- ntlm3_seskeyl2 \ �� ��
4 -- ntlm3_keyoffs  \ �������� ����� (�� �������� ����� ����� ���� ���������!)
2 -- ntlm3_flags1   \ 0x8205 ��� 0x8201
2 -- ntlm3_flags2   \ 0x0200
1 -- ntlm3_wprodmaj \ ProductMajorVersion (Windows - 6 ��� 5)
1 -- ntlm3_wprodmin \ ProductMinorVersion (Windows - 0..2)
2 -- ntlm3_wbuild   \ ProductBuild
3 -- ntlm3_reserved \ ����
1 -- ntlm3_revision \ NTLMSSP_REVISION_W2K3=0x0F, NTLMSSP_REVISION_W2K3_RC1=0x0A
\ ����� ����������� ����� (16 ���� �� ���� ���������)
\ ����� �����, �����, ����, LM-�����, NT-�����
CONSTANT /NTLM_mes3

1 CONSTANT NtLmNegotiate
3 CONSTANT NtLmAuthenticate
