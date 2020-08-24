REQUIRE WFL ~day/wfl/wfl.f
REQUIRE CGLWindow ~ygrek/lib/wfl/opengl/GLWindow.f
REQUIRE CBMP24 ~ygrek/lib/spec/bmp.f
REQUIRE CGLImage ~profit/lib/wfl/openGL/GLImage.f
REQUIRE " ~ac/lib/str5.f

\ ������� ���� �� ������������ ��������
\ ���� ���� ������������� �� ������������ SPF
\ ���� ����������
: picture S" ALLUSERSPROFILE" ENVIRONMENT? IF " {s}\Application Data\Microsoft\User Account Pictures\Default Pictures\frog.bmp" STR@ ELSE 2 THROW THEN ;
\ �������� ������ ���� � ������� BMP 24bit
 
0 VALUE list1
0 VALUE canvas
0 VALUE bmp

: test ( -- n )
|| CGLWindow aa CMessageLoop loop ||

CGLObjectList NewObj TO list1
CGLImage NewObj TO bmp
CGLSimpleScene NewObj TO canvas
bmp canvas => :add

picture bmp :: CGLImage.:load-image

0 0 200 bmp :: CGLImage.:set-color
20 0 DO
10 0 DO J I bmp => :pixel LOOP LOOP

canvas aa canvas!
0 0 aa create DROP
SW_SHOW aa showWindow

loop run ;

test BYE

\EOF
 
: save
   0 TO SPF-INIT?
   ['] ANSI>OEM TO ANSI><OEM
   TRUE TO ?GUI
   ['] test TO <MAIN>
   ['] test MAINX !
   S" wflgl.exe" SAVE ;