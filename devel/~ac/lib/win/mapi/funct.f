\ Simple MAPI
WINAPI: MAPILogon          MAPI32.DLL
WINAPI: MAPILogoff         MAPI32.DLL
WINAPI: MAPIFindNext       MAPI32.DLL
WINAPI: MAPIReadMail       MAPI32.DLL

\ Extended MAPI
WINAPI: MAPIInitialize     MAPI32.DLL
WINAPI: MAPIUninitialize   MAPI32.DLL
WINAPI: MAPILogonEx        MAPI32.DLL

WINAPI: HrQueryAllRows@24  MAPI32.DLL
\ WINAPI: HrMAPIOpenFolderEx MAPI32.DLL \ �� EDK, �� ��������������� � ��������

WINAPI: WrapCompressedRTFStream MAPI32.DLL \ html � MAPI �������� ��� ������ RTF
\ WINAPI: WrapCompressedRTFStreamEx MAPI32.DLL \ � Outlook 2002 ���

WINAPI: OpenStreamOnFile   MAPI32.DLL
