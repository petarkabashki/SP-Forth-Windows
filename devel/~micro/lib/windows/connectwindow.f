REQUIRE ->" ~micro/autopush/interface.f

MODULE: ConnectWindow
  : hwnd ( -- hwnd | 0 )
    desktop ->" ����������� ����� � 8-180"
  ;
  : IsConnect ( -- f )
    hwnd 0<>
  ;
  : Disconnect ( -- )
    hwnd ->" �����&���� �����" push
  ;
;MODULE