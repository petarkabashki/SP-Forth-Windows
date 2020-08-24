\ 23-11-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������ ����� � ���������� ���� �������������
\ ���������� xWord.f, �� � ������� ����� ������� �����������

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
 REQUIRE s"       devel\~moleg\lib\strings\string.f
 REQUIRE B@       devel\~moleg\lib\util\bytes.f

\ ��������� �������-������ ������������
: +delimiters ( asc # addr --> )
              >R SWAP
              BEGIN OVER WHILE
                    TRUE OVER B@ R@ + B!
                -1 0 D+
              REPEAT
              2DROP RDROP ;

\ ������� ������ ������������, ��������:
\ s" ������ ������������� � ������\n\t\000" Delimiter: name
: Delimiter: ( asc # --> )
             CREATE HERE DUP 256 DUP ALLOT ERASE
             +delimiters
             ( --> addr )
             DOES> ;

\ �������� �������, ������������ ����� �� �������������,
\ ��������� � ������� Delimiter:
: xWord ( delim --> ASC # )
        CharAddr >R
        BEGIN GetChar WHILE
              OVER + C@ 0= WHILE
              >IN 1+!
          REPEAT DUP
        THEN 2DROP
        R> CharAddr OVER - ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ ���� �� ��������������.
  S" passed" TYPE
}test

\EOF ������ �������������:

\ ������� ������, � ������� ����������� ������������
\ ������ ���������� ������ s" (� �� S"), ����������� " (������� ��������)
s"  \r\n\"[]:;\000" 2DUP DUMP Delimiter: proba

\ ������ �������������
: test BEGIN proba xWord DUP WHILE
             CR ." �������: " TYPE
                8 SPACES ." �����������: "
                PeekChar EMIT
                >IN 1+!
       REPEAT 2DROP CR ;

\ ������ ������ � ������������� �������������:
test as[asda"sd]dasdv;vkjjl:vlkj;l

