\ 20-12-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������塞 � ��� ᫮���� ROOT
\ ⥬, �� ࠡ�⠫ � smal32 ����⭮, �� ᪮�쪮 �� 㤮���!

 REQUIRE ALIAS    devel\~moleg\lib\util\alias.f
 REQUIRE THIS     devel\~moleg\lib\util\useful.f

VOCABULARY ROOT

 \ ��⠢��� � ���⥪�� ��� ᫮���� ROOT FORTH
 : ONLY ( --> ) ONLY ROOT ALSO FORTH ;

ALSO ROOT DEFINITIONS

 ALIAS FORTH      FORTH
 ALIAS VOCABULARY VOCABULARY
 ALIAS ALSO       ALSO
 ALIAS ONLY       ONLY
 ALIAS PREVIOUS   PREVIOUS
 ALIAS ORDER      ORDER
 ALIAS WORDS      WORDS
 ALIAS WARNING    WARNING
 ALIAS WITH       WITH
 ALIAS THIS       THIS
 ALIAS SEAL       SEAL
 ALIAS UNDER      UNDER
 ALIAS RECENT     RECENT

ONLY DEFINITIONS

?DEFINED test{ \EOF -- ��⮢�� ᥪ�� ---------------------------------------

test{ \ ��� ���� �஢�ઠ �� ᮡ�ࠥ�����.
  S" passed" TYPE
}test

\EOF
 ��᫥ ������祭�� �⮩ �������窨 � ���⥪�� �㤥� ��室�����
 ������ ��� ᫮����: ROOT FORTH
 ����� ���室 㤮��� ⥬, �� ��砩��� 㯮������� ����� �ந����쭮��
 ᫮���� ��� �।�����饣� ALSO �� �ਢ���� � ��������᪨� ��᫥��⢨�,
 �� ������ ����� ��� ⮫쪮 �� ctrl+c, ⠪ ��� � ���⥪�� �㤥�
 �ᥣ�� ��室����� �� ���� ᫮����, � ���஬ ��室���� �� ᫮��,
 ����室��� ��� ����⠭������� �ࠢ��쭮�� ORDER-a ᫮��३.
 ����� ONLY ��᫥ ������祭�� ������ �������窨 ��⠢��� � ���⥪��
 �� ����, � ��� ᫮����!!!
