\ 15-01-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������� ���� � ������� ������� �������.

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f

\ ������ ����� ������� ����������.

        0 VALUE standoff \ ���-�� �������� �� ������ ������
        6 VALUE maxdepth \ ������������ ���-�� ������������
                         \ ���������� �� ����� ������

\ ������� ������, ��������� �������� ������� ��� ���������� �����
: indent> ( --> )
          standoff SPACES TYPE
          standoff 1+ TO standoff ;

\ ������� �������� ��� ������� ����� �� ���� �������
: <indent ( --> ) standoff 1- 0 MAX TO standoff ;

\ ���������� ���������� ����� ������
\ ����� maxdepth ��������� ������ �� �����
: ~stack SPACE DEPTH maxdepth MIN 0 MAX ." -->  " .SN ;

\ ������ ��������� ��� ����� � �����
: ~about ( asc # --> ) CR indent> ~stack ;

\ ��������� ��� ������ �� �����
: backlv ( --> ) ."  �" <indent ;

\ ����������� ��������������� ��� � ������ ����������� �����������
: say ( --> )
      LATEST COUNT
      [COMPILE] 2LITERAL
      POSTPONE ~about ;

\ ���������� ����� �� �����������
: EXIT ( --> ) POSTPONE backlv [COMPILE] EXIT ; IMMEDIATE

\ ���������� �����������
: :NONAME ( --> ' )
          :NONAME S" NONAME" [COMPILE] 2LITERAL
          POSTPONE ~about ;

\ ��������� ����������� ';'
: ; ( --> ) POSTPONE backlv [COMPILE] ;  ; IMMEDIATE

\ ��������� ����������� ':'
: : ( --> ) : say ;

\ ��� ���������� ������ � ����� ����� ������� ��������������� ���������
\ ������ �� STARTLOG ������
?DEFINED test{ \EOF

test{ \ ���� ������ ���� �� ��������������.
  S" passed" TYPE
}test \EOF

\ ������ ��� ������������ ��������� � spf.log
STARTLOG

\ ����� ���� �� ��������� ������?
\ samples\bench\bubble.f  MAIN

\ EOF ������� ������ �������������

: simple  ;
: first   ." first" EXIT ." other" ;

: second  IF simple ELSE first THEN ;
: thrid   0 second 1 second ;
:NONAME ." noname sample" ; ->VECT X
: fourth  3 0 DO thrid LOOP ;
: fifth   X 9 7 DO fourth LOOP ;

fifth
