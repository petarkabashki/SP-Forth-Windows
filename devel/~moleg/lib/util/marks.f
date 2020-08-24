\ 05-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ����-������ �������� ������ �� ������. �������.

 REQUIRE NewStack  devel\~mOleg\lib\util\stack.f

        USER-VALUE MARKERS  \ ������ ��������� �� ���� ��������

        0x10 CONSTANT #marks \ ������� ����� ��������

\ ������������� ����� �������� - ���������� ��������� ���� ��� �� �����
\ ��������� ���������� �������� � ��������� ���� ����� ����������� ��������
: init-markers ( --> )
               MARKERS DUP IF KillStack ELSE DROP THEN
               #marks NewStack TO MARKERS ;

\ ��������� ������� ��������� ����� ������ � ����� ��������
: MarkMoment ( --> ) SP@ MARKERS PushTo ;

\ ���������, ���� �� ��������� ������� ����� � ���������� ������������ �������
: TestMoment ( --> flag ) SP@ MARKERS ReadTop = ;

\ ������, ������� �������� �������� �� ����� ��������
: Marks# ( --> # ) MARKERS StackDepth ;

\ ���������, �������� �� ������� ������ �����������
: ValidMark ( --> flag ) Marks# DUP IF DROP SP@ MARKERS ReadTop > 0= THEN ;

\ ���������� ��������� ����� ������ �� ������ ������������ �� MarkMoment
\ ��������� ����������� ������ ������������� ���������
: ClearToMark ( xj --> )
              ValidMark IF MARKERS PopFrom SP!
                         ELSE -1 THROW
                        THEN ;

\ ��������� ���������� ��������� �� ����� ������, ����������� � �������
\ ������������ � ������� MarkMoment
: CountToMark ( --> n )
              ValidMark IF SP@ MARKERS ReadTop SWAP - CELL /
                         ELSE -1 THROW
                        THEN ;

\ ������� ����������� �������� � ������� ����� ��������
: ForgetMark ( --> ) MARKERS PopFrom DROP ;

\ ������� ��� ������� �� ����� ��������
: ClearMarks ( --> ) 0 MARKERS MoveTo ;

\ �������� ��� ������� �� ���� ������
: AllMarks ( --> [ a b c .. z ] # ) MARKERS GetFrom ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ init-markers
      1 2 MarkMoment 3 4 5 ClearToMark 1 2 D= 0= THROW
      ValidMark THROW
      MarkMoment ValidMark 0= THROW
      1 2 3 4 CountToMark 4 <> THROW
      ClearToMark
  S" passed" TYPE
}test

\EOF ���, ��-������, ������ ������ � ������������ ~mOleg\lib\util\stack.f ,
     � ��-������, ����� ���������� ���������� ����� ������.






