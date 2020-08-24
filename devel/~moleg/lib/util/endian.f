\ 09-10-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��।������, � ����� ���⥪��ன ����� ����:
\ big endian ��� little endian

 REQUIRE B@        devel\~mOleg\lib\util\bytes.f

\ ��।����� ࠧ�來���� ������� ����㥬�� ������� ��� ������ ���⥪����.
\ �।����������, �� ���訩 ��� �᫠ �������, � ����樨 ᤢ��� �����
\ �����᪨�.
: ?CELL# ( --> bits )
         -1 0 BEGIN OVER WHILE
                    1 + SWAP 1 RSHIFT SWAP
              REPEAT NIP ;

\ ������� 㭨���쭮� ��� ������ ࠧ�來��� �᫮
\ ����訥 ࠧ��� �᫠ ��������� ��� �� ࠧ�來���.
: unnum ( --> n )
        ?CELL# 4 -
        1 BEGIN OVER 0 > WHILE
                DUP DUP + 4 LSHIFT OR
                SWAP 4 - SWAP
          REPEAT NIP ;

\ ���� ��� �࠭���� �᫠, �� ���஬� ��।��塞 ⨯ ��設�
CREATE archtag unnum ,

\ TRUE �᫨ ���冷� �࠭���� ���� � ����� �� ����襣� � ���襬� (ix86)
: ?LITTLE-ENDIAN ( --> flag ) archtag B@ 0x21 = ;

\ TRUE �᫨ ���冷� �࠭���� ���� � ����� �����,
\ � ���� ᭠砫� ���襥 ���祭��, ��⥬ ����襥.
: ?BIG-ENDIAN ( --> flag ) archtag B@ 0x21 <> ;

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{ ?CELL# 32 <> THROW      \ ��� ᥩ�� 32 ����
      ?LITTLE-ENDIAN 0= THROW \ ix86 ������ �࠭�� ����� � ���⭮� ���浪�
      ?BIG-ENDIAN THROW       \ �� ���� �� �� ���������
S" passed" TYPE
}test
