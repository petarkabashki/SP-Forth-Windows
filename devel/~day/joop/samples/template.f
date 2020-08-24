\ ��������� ��� �������� Windows ����������.
\ �� ���� ����������� ����� ���� gui ���������� ������
\ ���������� � ���� ���������

REQUIRE FrameWindow ~day\joop\win\framewindow.f
REQUIRE Button ~day\joop\win\control.f
REQUIRE Font ~day\joop\win\font.f
\ REQUIRE OpenDialog ~day\joop\win\filedialogs.f
REQUIRE MENUITEM ~day\joop\win\menu.f


CLASS: AppWindow <SUPER FrameWindow

        \ ����� ����� ������� ��������, ���� Button OBJ MyButton
        
: :createPopup ( -- hMenu)
   0 \ ������ 0 �������� �����-�������� ������������ ���� 
;
        
: :createMenu
   0 \ ����������, �� ��� ���� ����������
;

: :init
   own :init
   \ ����� �������� ����� ��������� ���� �-�� CreateWindowEx
;

: :create
  \ ����� �������� ����� ��������� ���� �-�� CreateWindowEx
  own :create
  \ ����� �������� � ������������� �������� etc
;

;CLASS


: RUN { \ w }
   AppWindow :new -> w
   0 w :create
   S" ����� ��� caption" w :setText
   100 50 200 160 w :move
   w :show
   w :run 
   w :free
   BYE
;

HERE IMAGE-BASE - 10000 + TO IMAGE-SIZE \ ������ 10000 ���� ��������
' RUN MAINX !
TRUE TO ?GUI
S" yourapp.exe" SAVE BYE
