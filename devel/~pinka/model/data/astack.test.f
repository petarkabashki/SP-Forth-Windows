REQUIRE EMBODY    ~pinka/spf/forthml/index.f
REQUIRE STHROW    ~pinka/spf/sthrow.f

\ libs
`../data/list-plain.f.xml EMBODY
`../data/event-plain.f.xml EMBODY

\ objects
HERE 
`events-common.f.xml EMBODY
`astack.f.xml EMBODY
HERE SWAP - .( object size: ) . CR

  ( ����� �� �������� � ������ ������ -- 3 Kb ���������� ����,
  ������� ���������� �� ~50 �� ������, � �������� �� ��������.
  �������� 6% -- ������ ������ ;)
 
  startup FIRE-EVENT 
 
  `aaa `A push-pair
  `A find-pair . TYPE CR
  `B find-pair . TYPE CR
  `bbb `B push-pair
  `AAA `A push-pair
  `B find-pair . TYPE CR
  `A find-pair . TYPE CR
  drop-pair
  `A find-pair . TYPE CR
 
  cleanup FIRE-EVENT 
  `A find-pair . TYPE CR
  