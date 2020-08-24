\ 15-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� ���������� ��������� ������

 REQUIRE SEAL      devel\~moleg\lib\util\useful.f
 REQUIRE cmdline>  devel\~mOleg\lib\util\parser.f
 REQUIRE VLIST     devel\~mOleg\lib\util\words.f

  VOCABULARY SPELLS  \ ������� ��� �������� ����� ��������� ������
  VOCABULARY SECRET  \ �������, � ������� �������� ��������� �����

\ ������ �������� ����������
: SPELL: ( --> ) ALSO SPELLS DEFINITIONS : PREVIOUS ;

\ ������ �������� ���������� ����������
: SECRET: ( --> ) ALSO SECRET DEFINITIONS : PREVIOUS ;

\ ��������� �������� ����������
: ;S ( --> ) [COMPILE] ; DEFINITIONS ; IMMEDIATE

\ -- ������� ���������� -----------------------------------------------------

\ ������ ������� ����� ������� � �������
\ SECRET: ~ ( --> ) ONLY ." My Master" CR QUIT BYE ;S

\ ���� ����� �� �������� - ���������� ������ � ����� ������
SECRET: NOTFOUND ( asc # --> ) ." invalid spell: " TYPE BYE ;S

\ -- �������� ���������� ----------------------------------------------------

\ ���������� ������ ����������
SPELL: -? ( --> ) ." spells are: " CONTEXT @ 1 VLIST BYE ;S

\ ��������� ��� ����������� ����������
\ SPELL: --help ( --> ) ." add any spells you need." CR ;S

\ ---------------------------------------------------------------------------

\ ���������� ����� ��������� ������
: options ( --> )
          SECRET SEAL ALSO SPELLS cmdline>
          SeeForw IF DROP ['] INTERPRET CATCH ELSE DROP TRUE THEN

          ( --> err|0 )
          \ ��� ������ ���� ����� �������� �����, ���� ������ ���
          \ �� ����������� �� NOTFOUND ��� ������.

\        BYE
         ;

\ ' options MAINX ! S" sample.exe" SAVE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{
  S" passed" TYPE
}test

