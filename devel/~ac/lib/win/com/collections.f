REQUIRE params@       ~ac/lib/win/com/variant.f 
REQUIRE {             lib/ext/locals.f

-4 CONSTANT DISPID_NEWENUM

IID_IUnknown Interface: IID_IEnumVariant {00020404-0000-0000-C000-000000000046}
  Method: ::Next  ( count *var *returned -- hres )
  Method: ::Skip  ( count -- hres)
  Method: ::Reset ( -- hres )
  Method: ::Clone ( *enum )
Interface;

: EnumVariant { xt ienum \ vax1 vav vax2 var n -- n }
\ vax1 vav vax2 var - ��� ������, ���� ::Next ���������� variant.
\ ����� � var ������� ��� VT_* (variant.f), � � vav - ��������
  BEGIN
    0 ^ var 1 ienum ::Next 0=
  WHILE
    vav var xt EXECUTE
    n 1+ -> n
  REPEAT
  n
;
: EnumCollection { xt col \ enu enum -- n }
\ col - ��������� "���������", ������������ ������� ��������, �������������
\ ������� �� ��������� �����������.
\ xt ( vav var -- )
\ ����������� ��� ������������ (� �� ������������� � �������) FOREACH..NEXT ~yz, 
\ �� ��� ������������� ����-����������.
  DISPID_NEWENUM col ID@ DUP 0= IF EXIT THEN -> enu
  ^ enum IID_IEnumVariant enu ::QueryInterface 0<> enum 0= OR IF 0 EXIT THEN
  xt enum EnumVariant
;
