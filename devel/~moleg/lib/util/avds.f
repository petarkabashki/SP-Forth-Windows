\ 29-11-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������������ �����, ��������� �����������, ������������ ����� ����

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ ������� ���������� �����, ������������� ����� ������ ����
: :> ( / name --> )
     CREATE ] HIDE IMMEDIATE
     ( --> 'name )
     DOES> STATE @ IF LIT, THEN ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ :> sample 57984072 ; sample EXECUTE 57984072 <> THROW
      : test sample EXECUTE ; test 57984072 <> THROW
  S" passed" TYPE
}test

