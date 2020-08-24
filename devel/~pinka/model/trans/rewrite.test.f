REQUIRE EMBODY    ~pinka/spf/forthml/index.f
REQUIRE STHROW    ~pinka/spf/sthrow.f

\ ����������
`../data/list-plain.f.xml EMBODY
`../data/event-plain.f.xml EMBODY

\ �������
`../data/events-common.f.xml EMBODY \ ������ ������� ����� �������

`rewrite.L2.f.xml EMBODY \ ������ ��������� �������

  ( �������� ������� ������� ������ �������������� �����������.
  ��� ������������� ������ ������ ������� ����� ���� ��������� �������,
  ��� ����� ������ �� ��������� ����������� �� ����,
  ��� ���������� � ������� ������� � �������� ��������� ������
  -- � ����������� �� ��������� �����.
  )
  
  `abc rewrite TYPE CR  \ --> abc  \ �.�. ������ ��� ����, �� ��������� � ��� startup
  
  `C:/WinXP/system32/           `spf://win32-dll/             advice-rewrite-head
  
  `spf://win32-dll/libxml2.dll  `http://xmlsoft.org/libxml2   advice-rewrite-head
  `spf://win32-dll/libxslt.dll  `http://xmlsoft.org/libxslt   advice-rewrite-head
  
  \ "rewrite-head" ������� � ���, ��� �������������� ������ ������ (������). 
  \ ����� �������:  ( �������� ���� ), -- ����� ��, ��� � ���� "!", "HASH!"
  \ ����� ��� ������� ( ���� �������� ) ����� "advice-rewrite-head-"
  
  
  startup FIRE-EVENT 
  \ ������ rewrite ��������� � ������� ���������,
  \ ������������ ������� ������ ��� ��� ������

  `http://xmlsoft.org/libxml2 rewrite TYPE CR
  `http://xmlsoft.org/libxslt rewrite TYPE CR
  `abc rewrite TYPE CR \ ������������ ��� ���������, �.�. ������� ������� �� ���������.
  
  cleanup FIRE-EVENT 
  \ ������� ����� ����������� � ������ � ���������� �������������
  