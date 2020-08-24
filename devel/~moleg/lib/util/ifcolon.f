\ 31-01-2007 ~mOleg ( mail to: mininoleg@yahoo.com )
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ���������� ������ ���������� ���� � �������

\ �������� ����� ?: �� ���������� ���������� - ����� ����������� � �������
\ �������, ������ ���� ��� � ����� �� ������ � ���������.
\ !!! ������������ � ����� ������ �� ���� 4.18 !!!
\ ver 1.2 - ��������� ������� �� ��������� ���������� WARNING.

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

VOCABULARY recoil \ ��� ������������� ����� ��������� � ����������� �������
           ALSO recoil DEFINITIONS

        \ ����������� ������� ��� ������ � ������� �� ����
        USER unique-flag

        \ ��������� ������� sheader �������
        ' SHEADER BEHAVIOR ->VECT std-sheader

\ ������� ��������� ������������ ����� �� �������� ������
: unlink ( --> ) LATEST CDR GET-CURRENT ! ;

\ ���� ��������� ����� ����� �������� - �������� ���.
: ?cut ( --> )
       unique-flag @
       IF unlink
          unique-flag @ HERE - ALLOT
          unique-flag 0!
       THEN ;

\ ������� ����� ���������, ���� ����������, �������� ������ �����
: (sHeader) ( asc # --> ) ?cut std-sheader ;

\ ���� ����� ��������� - ������� 0 � ����� ������
\ ����� ������� ����� ��� ������, � ����� ������ ������.
: ?namex ( / name --> here|0 asc # )
         NextWord SFIND
         IF DROP S" _" HERE  ELSE FALSE  THEN
         -ROT ;

ALSO FORTH DEFINITIONS \ ������ ����� ���� � ������� ������� SPF

\ �� �� ��� � : ������ ��� �������� �� ������� ����� ������
\ � ���� ������ �� ���������. ������:  S" name" S: ��� ����� ;
?DEFINED S: : S: ( asc # --> ) SHEADER ] HIDE ;

\ �������� ����� � ������� �������, ������ ���� � ��������� ��� �����
\ � ����� �� ������.
: ?: ( --> )
     WARNING @ IF ?namex ELSE FALSE NextWord THEN
     S:   unique-flag ! ;

 ' (sHeader) TO SHEADER  \ ������ ������������ ������

PREVIOUS PREVIOUS

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{  TRUE WARNING !
       ?: simple 871654 ; 871654 simple <> THROW
       ?: simple 672098 ; 871654 simple <> THROW
     FALSE WARNING !
       ?: simple 672098 ; 672098 simple <> THROW
  S" passed" TYPE
}test

\EOF -- �������� ������ -----------------------------------------------------

                           TRUE WARNING !
VOCABULARY testing
           ALSO testing DEFINITIONS

?: test ( --> ) ."  first test sample" CR ;
?: test ( --> ) ."  second test sample" CR ;
    CREATE sample
?: test ( --> ) ."  thrid test sample" CR ;
 : eotest ( --> )
          ." ������ ���� ����� ��� ����� � �������: test, eotest � sample" CR
          WORDS
          ." ������ ���� �������� ������ test : "
          test
          ; eotest

                        PREVIOUS DEFINITIONS
CR CR
                              WARNING 0!

VOCABULARY testing
           ALSO testing DEFINITIONS

?: test ( --> ) ."  first test sample" CR ;
?: test ( --> ) ."  second test sample" CR ;
    CREATE sample
?: test ( --> ) ."  thrid test sample" CR ;
 : eotest ( --> )
          ." ������ ���� ��� ���� ���� � ������� �������" CR
          WORDS
          ." ������ ���� �������� ������ test : "
          test
          ; eotest


\EOF
     ������ ����� ��������� ����� ����, ������� ����� ���� � �������,
� ����� � �� ����, � ���������� �������������� ����� �� �������...

� ����� ������ ��������� ��������� �������: ���������� ������ ���� 8),
��� ������������ ����� �������� �� � : � � ?: � ���!!!  �8)

������, ��� ����� ������������ � :? ��������, �� ����� ��������� 8)
����, ������� � ������� ��� ���� ����� � ����� ������, � ���� ���
������ �����, �� �����, ��������������, ���������. ��� ������, ���
�� ������ ����� ������������ ������ IMMEDIATE ����� ; !!!
������ ��� ��������� �����, ��� ������������ [UNDEFINED] ��� REQUIRE.

��, ����� ���������� ������, ����� �������� ������������ ���������.

��������� ���� ���������� ����� ��������� � ������� ��������� ����������
WARNING - ��� ��������� ���� ���������� ��������� ����������� �����
          �����������, � ��� ������������� � 0 ��������������� ����������.
