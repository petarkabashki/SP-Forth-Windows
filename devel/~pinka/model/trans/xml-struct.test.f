REQUIRE EMBODY    ~pinka/spf/forthml/index.f


`../data/list-plain.f.xml       EMBODY
\ `../data/event-plain.f.xml      EMBODY
\ `../data/events-common.f.xml    EMBODY

`xml-struct.f.xml EMBODY

  
  \ startup FIRE-EVENT
  xml-struct-hidden::start

  `xml-struct.test.f.xml EMBODY

\EOF

ToDo
  � ��������� ���������� xi:model �������� � �������� ������ 
  ������������� ��������, � ����� -- ������ � �������� 
  ��������� f:forth, xi:include � xi:model (������� ���������
  ������� �� ������� �� ������ _list). 
  ���� �� ���������� (��������� ������ � ������������� ��������),
  ��� �������� �����������.

  ��������� �������� advice ��� xi:model
  