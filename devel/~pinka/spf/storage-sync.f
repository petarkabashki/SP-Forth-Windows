\ Nov.2008

REQUIRE FORTH-STORAGE   ~pinka/spf/storage.f
REQUIRE CREATE-CS       ~pinka/lib/multi/Critical.f

CREATE-CS _CS-FORTH-STORAGE \ ��� ����������������� ������� � �������� ���������

: (WITHIN-FORTH-STORAGE-EXCLUSIVE) ( xt -- )
  FORTH-STORAGE MOUNT EXECUTE
;
: WITHIN-FORTH-STORAGE-EXCLUSIVE ( i*x  xt --  j*x ) \ ��.. �� ������� �� ������� ��� ;)
  _CS-FORTH-STORAGE ENTER-CS
  DISMOUNT >R 
  ['] (WITHIN-FORTH-STORAGE-EXCLUSIVE) CATCH ( ior )
  R> MOUNT
  _CS-FORTH-STORAGE LEAVE-CS
  ( ior ) THROW
;

(  FORTH-STORAGE -- ��� ������� ���������, ���������� ����,
 ��� FORTH-WORDLIST -- �������� ������ ����.
 ����� ����������� ��� � ������� ��������� �� �������� �������,
 ��������� ����� ������ ���������� ������� ����� �� ��������
 ������� ���������� ������ DISMOUNT DROP
)
