( It sample for sortings in forth /SPF3.75/.   comments - RUS, CP-1251 )

\ 02.10.99�. 16:53:36
\ 18.05.2000
\ 24.05.2000
\ 18.11.2000 ver. 1.0. ������ � ���� ������������������ �������.  
\ Ruvim Pinka (ruvim@forth.org.ru)

REQUIRE {       lib/ext/locals.f

\ ==================================================================
( QuickSort - ������� ����������. ������������� ���������� /-����� �����/.
  ������� ������� ����  
    []exch[] [ a b -- ]     \ �������� ����� ��������� i � j
    []>[]  [ i j -- flag ]  \ flag=true, ����  i_key > j_key
    []<[]  [ i j -- flag ]  \ flag=true, ����  i_key < j_key
\ ������� ���������� �������� ������� ��������� ( []>[] � []<[] )


: sort23 { il ir -- }  \  ���������� ���� ��� ���� ���������
  il ir  = IF EXIT THEN
  il ir  []>[] IF il ir []exch[] THEN
  il 1+ DUP ir <> IF ( i )
      DUP il []<[] IF DUP il []exch[] ELSE
      DUP ir []>[] IF DUP ir []exch[] THEN
  THEN THEN DROP
;

\ �����������
: quick_sort ( left right -- )  \ left <= rigth
  { il ir \ mid }
    ir il -  3 < IF   il ir  sort23
    ELSE
      il ir 2DUP + 2/  -> mid \ ����������� ������ �������� �����
      BEGIN  ( left right )
        BEGIN  il mid []<[] WHILE il 1+ -> il REPEAT
        BEGIN  mid ir []<[] WHILE ir 1- -> ir REPEAT
        il ir >  0=  IF \ ����� �� ������ �������
           il mid = IF ir -> mid ELSE
           ir mid = IF il -> mid THEN
           THEN
           il ir []exch[]  il 1+ -> il ir 1- -> ir
        THEN
        il ir >
      UNTIL  ( left right )
      il SWAP   RECURSE
      ir        RECURSE
    THEN
;
