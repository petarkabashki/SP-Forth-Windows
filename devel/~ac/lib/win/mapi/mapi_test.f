REQUIRE MapiLogon        ~ac/lib/win/mapi/exmapi.f
REQUIRE MapiListMessage  ~ac/lib/win/mapi/list.f

HEX
\ S" MGW" S" password" MapiLogon THROW  MapiGetStores
\ S" Outlook" S" password" MapiLogon THROW  MapiGetStores
\ ������� �� ���������:
0 0 0 0 MapiLogon THROW  MapiGetStores

\ CR MapiStoresRS DumpRowSet
\ CR MapiStoresRS PR_PROVIDER_DISPLAY S" MAPILab Group Folders" MapiRow@ 
\ PR_DISPLAY_NAME MapiRowProp@ 2DROP ASCIIZ> ANSI>OEM TYPE CR

MapiOpenDefaultStore
\ S" MAPILab Group Folders" MapiOpenProvStore
\ S" RAINBOW:������ �����" MapiOpenStore
\ S" Personal Folders" MapiOpenStore
\ S" ������ �����" MapiOpenStore

MapiGetRootFolderId MapiOpenFolder DROP
DUP ( folder ) PR_DISPLAY_NAME  MapiProp@ ANSI>OEM TYPE CR \ ���� "������ ������ �����"
    ( folder ) ' MapiListFolder MapiEnumSubfolders

\ MapiOpenInbox DUP uMapiFolder ! ' MapiListMessage MapiEnumContent
MapiOpenInbox uMapiFolder !

\ S" ��������/test" MapiOpenFolderPath DUP uMapiFolder ! ' MapiListMessage MapiEnumContent

\ S" IPF.Task" MapiGetIPF MapiOpenFolder DROP 
\ DUP ( folder ) PR_DISPLAY_NAME  MapiProp@ ANSI>OEM TYPE CR \ ���� "������ ������ �����"
\     ( folder ) DUP uMapiFolder ! ' MapiListMessage MapiEnumContent

S" IPM.Task" MapiNewMessage

S" test.eml" MapiImportMime

\ ����������� ���� ���������������� ������ ������� �����
MapiMessage PR_CREATION_TIME MapiProp@ ( x1 x2 )
MapiMessage PR_MESSAGE_DELIVERY_TIME MapiProp! \ ��� ���� ������������ � "��������"
S" IPM.Task" MapiMessage PR_MESSAGE_CLASS MapiProp!


S" Test subject 99" MapiSubject!
S" tester@forth.org.ru" S" AYC88" MapiSender!
\ S" ��� ���� 10" MapiBody!
\ " X-MapiLib: LibMapi/$Id: mapi_test.f,v 1.5 2007/11/09 17:46:03 spf Exp $/eserv.ru
\ " STR@ MapiHeaders!

S" ac@eserv.ru" S" Andrey Cherezov" MapiAddRcpt
S" ac@forth.org.ru" S" Andrey SPF" MapiAddRcpt
S" dev@forth.org.ru" S" SPF DEV" MapiAddRcptCc
S" arc@forth.org.ru" S" SPF ARC" MapiAddRcptBcc

S" 1.html" FILE S" 1.html" S" text/html" MapiAddAtt .
S" 12346" S" file.txt" S" text/plain" MapiAddAtt .
S" mapi4.rar" FILE S" mapi4.rar" S" application/octet-stream" MapiAddAtt .
\ S" C:\Eserv3\EservEproxy332_nas-setup.exe"  FILE S" EservEproxy332_nas-setup.exe" S" application/octet-stream" MapiAddAtt .

S" exported.eml" MapiExportMime
MapiSave

MAPIUninitialize THROW

