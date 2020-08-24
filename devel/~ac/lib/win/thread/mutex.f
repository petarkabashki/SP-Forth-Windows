REQUIRE STR@         ~ac/lib/str5.f
REQUIRE CreateEveryoneACL ~ac/lib/win/access/nt_access.f 
REQUIRE CREATE-MUTEX  lib/win/mutex.f
REQUIRE WinNT?        ~ac/lib/win/winver.f

\ �������� � ��������� (~pig)
\ ������� ������
\ name - ��� �������
\ mut - ����� ��������� ��� �������� ������
: CREATE-MUTEX-EX ( S" name" mut -- )
  DUP @						\ ����� ��� ��������?
  IF DROP 2DROP EXIT THEN			\ �������� �� ���������
  -ROT " {s}" STR@ FALSE CREATE-MUTEX THROW	\ ������� ������
  OVER !					\ ��������� �����
  WinNT?					\ ���� Windows NT, ��������� �������� ����
  IF
    CreateEveryoneACL ?DUP			\ ������� ACL ��� ������ Everyone
    IF
      NIP " ACL: {n}" STYPE CR			\ �� ���������� - ���������� � �������� ���
    ELSE
      OVER @ SetObjectACL DROP			\ ������ ����� ������� � �������
    THEN
  THEN
  DROP						\ ������ ������ �� �����
;
\ ������������� ����������� �������
\ xt - ����� ����������������� �����
\ mut - ����� ����������, ��� �������� (��� �� ��������) ����� �������
: SYNC-MUTEX ( xt mut -- )
  @ DUP >R					\ ������ �������?
  IF -1 R@ WAIT THROW DROP THEN			\ �� - ���������
  CATCH						\ ��������� ���������� ��������
  R> ?DUP					\ ������ �������?
  IF RELEASE-MUTEX DROP THEN			\ �� - ����������
  THROW						\ �������� ������ ������
;
