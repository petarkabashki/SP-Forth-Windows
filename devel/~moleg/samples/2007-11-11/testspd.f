\ 28-10-2007 ~mOleg
\ ��������� �������� ������ ���������

 REQUIRE FOR  devel\~mOleg\lib\util\for-next.f
 REQUIRE own  devel\~moleg\lib\util\priority.f

                                   DECIMAL

 16000 CONSTANT #array   \ ������ ������� � �������

       CREATE array      \ ��� ������ ���������� ������
            #array CELLS ALLOT

 \ �������� ����������� ������:
 HEX 12345678 SP@ 1 revarr 1E6A2C48 <> THROW
     87654321 SP@ 1 revarr 84C2A6E1 <> THROW
 DECIMAL

 REQUIRE ?DEFINED       devel\~moleg\lib\util\ifdef.f
 REQUIRE RANDOM         devel\~day\common\RND.F

\ ��������� ������ ���������� �������
: filarr ( --> ) array #array FOR RANDOM OVER ! CELL + TILL DROP ;

\ ��� ������ ��������
 REQUIRE ResetProfiles  devel\~pinka\lib\Tools\profiler.f

\ ������ ������� ��� ��� ������ ������ �������
: sample ( --> ) array #array revarr ;

realtime own 0= THROW \ �� ���� ���������� ���������

: test ( --> )
       filarr
         ResetProfiles
         100 FOR sample TILL
        CR .AllStatistic ;

normal own DROP
