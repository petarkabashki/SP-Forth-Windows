\ 28-10-2007 ~mOleg
\ ��������� �������� ������ ���������

 REQUIRE FOR  devel\~mOleg\lib\util\for-next.f
 REQUIRE own  devel\~moleg\lib\util\priority.f

                                   DECIMAL

\ ��� ������ ��������
 REQUIRE ResetProfiles  devel\~pinka\lib\Tools\profiler.f

\ �������� �������� ������ ��������� ���������
: sample ( --> ) 0x88888888 combs 2DROP ;

realtime own 0= THROW \ �� ���� ���������� ���������

\ �������� �������� ������ ���������
: test ( --> )
       ResetProfiles
         100 FOR sample TILL
       CR .AllStatistic ;


