REQUIRE EMBODY    ~pinka/spf/forthml/index.f

`stream-mem.L1.f.xml EMBODY

( ������� ������� ����� ������ � ����������� �������������� ������.
  ��� ���������� ���������� ����� ������ ��������� ����� ����,
  ����� ����������� � ������. ������ ������� ���������� �����
  ������������ ��� ����� ������ ��� ���������� ������ ����� ������.
  ��� ������ ��������� ���������� ����� �������������.
  ����� ������ ������ ������ -- ����� ������������ 0.
)


 \ stream-mem-hidden ALSO!

 S" abc" write
 HERE 100 readout TYPE CR

 HERE 10000 write
 HERE 10000 write
 HERE 50000 readout SWAP . . CR
 HERE 50000 readout SWAP . . CR
 HERE 50000 readout SWAP . . CR
 HERE 50000 readout SWAP . . CR
 CR
 HERE 10000 write
 HERE 10000 write
 next-chunk SWAP . . CR
 next-chunk SWAP . . CR
 next-chunk SWAP . . CR



(  �, �������� �������� �� ������� ����:
    http://article.gmane.org/gmane.comp.lang.forth.spf/733/ 
    -- ������ �� ~yz � spf-dev@ �� 2006-05-10
      http://blogs.msdn.com/larryosterman/archive/2004/04/19/116084.aspx
      -- �������� ���������� ����� � ������ ����� ��������
      FILE_ATTRIBUTE_TEMPORARY | FILE_FLAG_DELETE_ON_CLOSE
)
