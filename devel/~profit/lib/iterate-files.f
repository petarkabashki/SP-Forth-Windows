REQUIRE /TEST ~profit/lib/testing.f
REQUIRE FIND-FILES-R ~ac/lib/win/file/findfile-r.f
REQUIRE KEEP! ~profit/lib/bac4th.f

\ �������� �� ������ � ����� ��������� addr u , ������������ ������� -- depth
: ITERATE-FILES ( addr u depth --> addr1 u1 data flag \ <-- ) R> SWAP FIND-FILES-DEPTH KEEP!  FIND-FILES-R ;
\ ��� ������ �������� �����:
\ addr u - ���� � ��� ����� ��� �������� (������ ��� open-file, etc)
\ flag=true, ���� �������, false ���� ����
\ data - ����� ��������� � ������� � ����� ��� ��������
\ ���� ��������� ������� � ~ac/lib/win/file/findfile.f:
\  0
\  4 -- dwFileAttributes
\  8 -- ftCreationTime
\  8 -- ftLastAccessTime
\  8 -- ftLastWriteTime
\  4 -- nFileSizeHigh
\  4 -- nFileSizeLow
\  4 -- dwReserved0
\  4 -- dwReserved1
\ 256 -- cFileName          \ [ MAX_PATH ]
\  14 -- cAlternateFileName \ [ 14 ]
\ 100 + CONSTANT /WIN32_FIND_DATA

\ ����� ������ �������� ������ addr � ��������� data �������������,
\ �������, ���� ��� ������ ����� ���������, �� ���� ����������.
\ �������� ����� �������� �� ����: ������ �������� �� ��������� �����
\ ��������� ������



\ ����������� ITERATE-FILES �����, �� ��� ����� ������ ����� 
\ � addr u � �������� �������� depth. � ������� �� ITERATE-FILES 
\ ����� ��� �������� ������ ������, ��� ��� flag ��� ������ ��������
\ ������ ���� ����� true
: ITERATE-DIRS ( addr u depth --> addr1 u1 data \ <--  ) PRO ITERATE-FILES ONTRUE CONT ;
\ ����� ���� ������������ � ������� FIND-DIRS-R �� ~ac/lib/win/file/findfile-r.f ...

/TEST
: allFilesInC S" c:" 1 ITERATE-FILES ( addr u data flag --> \ <-- ) 2DROP CR TYPE ;
allFilesInC