\ $Id: bunny.f,v 1.6 2007/12/25 09:59:08 ygreks Exp $
\
\ ����� ������� ������� - ������ ����� ��� : http://www.forth.org.ru/~ygrek/files/bun_zipper.7z
\ ����������� � �������� �����

REQUIRE WL-MODULES ~day/lib/includemodule.f

WINAPI: gluSphere GLU32.DLL
WINAPI: gluNewQuadric GLU32.DLL
WINAPI: glMaterialfv OpenGL32.DLL

NEEDS ~day/wfl/wfl.f
NEEDS ~ygrek/lib/wfl/opengl/GLWindow.f
NEEDS ~day/common/clparam.f
NEEDS ~ygrek/lib/neilbawd/mersenne.f
NEEDS ~ygrek/lib/float.f

: FGENRANDMAX ( F: max -- f ) FGENRAND F* ;
: FGENRANDABS ( F: abs -- f ) 2e F* FGENRAND 0.5e F- F* ;

: SetLight
   || CGLPoint p ||

   GL_NORMALIZE glEnable DROP
   GL_SMOOTH glShadeModel DROP

   GL_COLOR_MATERIAL glEnable DROP  \ The color is treated as the material color
   GL_DEPTH_TEST glEnable DROP

   GL_LIGHT0 glDisable DROP
   GL_LIGHTING glEnable DROP \ Enable lighting in general
   GL_LIGHT1 glEnable DROP \ Enable our light source

   0.2e 0.2e 0.2e 1.0e p :set4
   p :getv GL_AMBIENT GL_LIGHT1 glLightfv DROP
   0.5e 0.5e 0.5e 1.0e p :set4
   p :getv GL_DIFFUSE GL_LIGHT1 glLightfv DROP
   1.0e 1.0e 1.0e 1.0e p :set4
   p :getv GL_SPECULAR GL_LIGHT1 glLightfv DROP
   0.0e 0.0e 1.0e 0.0e p :set4
   p :getv GL_POSITION GL_LIGHT1 glLightfv DROP
    
\  draw sphere to track the position of the light source
\
\   glPushMatrix DROP
\     p :get float float float glTranslatef DROP
\     50 50 2.0e double gluNewQuadric gluSphere DROP
\   glPopMatrix DROP

;


CGLSimpleCanvas SUBCLASS CGLMyScene

 CGLObjectList OBJ _list
 CGLSimpleModel OBJ _model
 CModelLoaderPLY2 OBJ _ply2

: make-cubes { | K }
  0 -> K
  BEGIN
   K 1 <
  WHILE
    10 0 DO
      10 0 DO
       \ CR I . J . K .
       CGLCube NewObj
       DUP 0.75e :: CGLCube.:resize
       DUP 0e I DS>F 3e F* F+ 0e J DS>F 3e F* F+ 0e K DS>F 3e F* F- :: CGLObject.:setShift
       DUP 5e FGENRANDABS 5e FGENRANDABS 5e FGENRANDABS :: CGLObject.:setAngleSpeed
           _list :add
      LOOP
    LOOP
    K 1+ TO K
  REPEAT ;

: make-bunny
  S" bun_zipper.ply2" _model :model _ply2 :load

  \ ������� ������ � ����� ������� � ��� (��������� ����� ��������)
  10e 0e 10e _model :setShift 
  0e 1e 0e _model :setAngleSpeed
  0e 90e 0e _model :setAngle
  10e _model :resize 

  0.7e 0.7e 0.7e _model :setColor
  ;

init: make-bunny make-cubes ;

: :display
   SUPER :display 

  -50f -15f -15f glTranslatef DROP \ ������� ��� �����

   GL_SPECULAR GL_FRONT_AND_BACK glColorMaterial DROP
   0f 0f 0f glColor3f DROP \ ������ �� �������� specular ����
   GL_AMBIENT_AND_DIFFUSE GL_FRONT_AND_BACK glColorMaterial DROP
   \ ��� SetColor ��� ������� ������ ����� ������ �� diffuse&ambient

   _list :draw
   _list :rotate

   GL_SPECULAR GL_FRONT_AND_BACK glColorMaterial DROP
   1.0f 1.0f 1.0f glColor3f DROP \ specular ���� �������

   GL_AMBIENT_AND_DIFFUSE GL_FRONT_AND_BACK glColorMaterial DROP
   \ ����� ����� ������ _model ����� ������ �� diffuse&ambient ����

   100f GL_SHININESS GL_FRONT_AND_BACK glMaterialf DROP 

   _model :draw
   _model :rotate

   200f GL_SHININESS GL_FRONT_AND_BACK glMaterialf DROP

   glLoadIdentity DROP \ ��������� ���� � ������� ���������

   SetLight \ � �������� ��� ���������� ������� ���� ���
   ;

;CLASS

\ -----------------------------------------------------------------------

: test ( -- n )
  || CGLWindow aa CGLMyScene scene CMessageLoop loop CTimer timer ||

  scene this aa canvas!
  0 0 aa create DROP

  TRUE 300 400 200 200 aa moveWindow

  SW_SHOW aa showWindow

  timer :start
  loop run
  timer :stop
  timer :ms@ CR ." Total time = " .
;

test

: save
   FALSE TO SPF-INIT?
   ['] ANSI>OEM TO ANSI><OEM
   TRUE TO ?GUI
   ['] test TO <MAIN>
   S" bunny.exe" SAVE ;

