
make-xslt.cmd      -- ������� ��������� ������ ForthML �� ���� XSLT
make-core-forth.cmd  -- ������� ��������� ������� ������������ ��� ������ ForthML �� ���� ����-�������
make-all.cmd       -- �������� ��� ����-����������
clear-all.cmd      -- ������� ���������� ����� (����� forthml-rules.f)

�������� �����:
  tmp/             -- ��������� �����, ��� ������� ��� �������� ;)
  forthml.xsl      -- ���������� �� ForthML � ���������� ����-�����,
  forthml-core.f   -- ������ ForthML (����� ������) �� ���������� �����.

�������������� �������� -- ��. src/rules-*.xml

SaxonB8 ������� �� saxon.sourceforge.net

saxonB8.cmd -- ������ ����
  @java -cp \your\path\saxon8.jar net.sf.saxon.Transform %*
(�������� ��� ����-������ � %PATH% )
