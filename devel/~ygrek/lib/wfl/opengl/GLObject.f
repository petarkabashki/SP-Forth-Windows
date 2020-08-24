\ $Id: GLObject.f,v 1.11 2008/12/11 09:58:48 ygreks Exp $
\
\ ��� ������� ���� ���������� ������������(�����������) ����� CGLObject
\ ������� ������������ ����� ������ �������������� �� GL-�������
\ �������� : ����, �����
\ �������� : �������, ����������
\
\ CGLCube CGLPyramid
\ CGLObjectList - ������ �������� ��� ���� ������
\ CGLSimpleModel - �������� �� �������������

REQUIRE WL-MODULES ~day/lib/includemodule.f

NEEDS ~ygrek/lib/wfl/opengl/common.f
NEEDS ~day/hype3/locals.f
NEEDS ~pinka/lib/lambda.f
NEEDS ~ygrek/lib/hype/timer.f
NEEDS ~ygrek/lib/hype/point.f
NEEDS ~ygrek/lib/list/ext.f
NEEDS ~ygrek/lib/float.f

\ -----------------------------------------------------------------------

CPoint4f SUBCLASS CGLPoint

: :getf ( -- D: z y x ) SUPER :z@ float  SUPER :y@ float  SUPER :x@ float ;

: :vertex SUPER :getv glVertex3fv DROP ;
: :normal SUPER :getv glNormal3fv DROP ;

;CLASS

NEEDS ~ygrek/lib/wfl/opengl/Model.f

\ -----------------------------------------------------------------------

\ ��� ������� ������� �������� � GL-���� ������ ������������� ����� ���������
CLASS (CGLObject)

: :draw ;

;CLASS

\ -----------------------------------------------------------------------

\ ������� ������
\ 
(CGLObject) SUBCLASS CGLObject

     CGLPoint OBJ angle \ �������
     CGLPoint OBJ angle.speed \ �������� ��������
     CGLPoint OBJ shift \ �����
     CGLPoint OBJ scale \ ������-����������
     CELL PROPERTY <visible

: :print
  CR ." CGLObject :print"
  CR ." angle : " angle :print
  CR ." angle.speed : " angle.speed :print
  CR ." shift : " shift :print
  CR ." scale : " scale :print
  CR ." <visible : " <visible @ .
;

: :draw
   <visible@ 0= IF 0e float 0e float 0e float glScalef DROP EXIT THEN

   shift :getf glTranslatef DROP 
   scale :getf glScalef DROP 

   1e float 0e float 0e float
   angle :x@ float glRotatef DROP  

   0e float 1e float 0e float
   angle :y@ float glRotatef DROP

   0e float 0e float 1e float
   angle :z@ float glRotatef DROP
;

: :prepare ;

init: 1e 1e 1e scale :set TRUE <visible! ;
dispose: ;

: :setAngle ( F: x y z -- ) angle :set ;
: :getAngle ( -- F: x y z ) angle :get ;
: :setAngleSpeed ( F: x y z -- ) angle.speed :set ;
: :getAngleSpeed ( -- F: x y z ) angle.speed :get ;
: :setShift ( F: x y z -- ) shift :set ;
: :getShift ( -- F: x y z ) shift :get ;
: :setScale ( F: x y z -- ) scale :set ;
: :getScale ( -- F: x y z ) scale :get ;
: :resize ( F: f -- ) FDUP FDUP :setScale ;

: :rotate
   \ ." Rotate "
   angle :x@ angle.speed :x@ F+ angle :x!
   angle :y@ angle.speed :y@ F+ angle :y!
   angle :z@ angle.speed :z@ F+ angle :z!
;

;CLASS

\ -----------------------------------------------------------------------

\ ����� - ������ �������� ��� ���� ������ ��� ���������
CGLObject SUBCLASS CGLObjectList

VAR _list

init: list::nil _list ! ;
dispose:
    _list @ LAMBDA{ => dispose } list::free-with \ ������ ��� ������� � ������ � ��� ������
;

: :add ( obj -- ) _list @ list::cons _list ! ;

: :draw ( -- )
   SUPER :draw
   _list @ 
   LAMBDA{
     glPushMatrix DROP
       => :draw
     glPopMatrix DROP
   }
   list::iter ;

: :rotate ( -- ) SUPER :rotate _list @ LAMBDA{ => :rotate } list::iter ;

: :prepare SUPER :prepare _list @ LAMBDA{ => :prepare } list::iter ;

;CLASS

\ -----------------------------------------------------------------------

: SetColor ( F: r g b -- ) float float float ( b g r ) glColor3f DROP ;
: Red    1e 0e 0e ;
: Green  0e 1e 0e ;
: Blue   0e 0e 1e ;
: Yellow 1e 1e 0e ;
: Magenta 1e 0e 1e ;
: Orange 1e 0.5e 0e ;
: White  1e 1e 1e ;
: Black  0e 0e 0e ;

\ -----------------------------------------------------------------------

\ ��������
CGLObject SUBCLASS CGLPyramid

   CGLPoint OBJ top
   CGLPoint OBJ a1
   CGLPoint OBJ a2
   CGLPoint OBJ a3
   CGLPoint OBJ a4

: :draw

  SUPER :draw

  GL_TRIANGLES glBegin DROP \ Drawing Using Triangles
         Red SetColor
           top :vertex   a1 :vertex   a2 :vertex
         Yellow SetColor
           top :vertex   a2 :vertex   a3 :vertex
         Blue SetColor
           top :vertex   a3 :vertex   a4 :vertex
         Green SetColor
           top :vertex   a4 :vertex   a1 :vertex
   glEnd DROP   \ Finished Drawing

   GL_QUADS glBegin DROP
      Magenta SetColor
           a1 :vertex   a2 :vertex   a3 :vertex   a4 :vertex
   glEnd DROP
;

init:
  +0E +1E +0E  top :set
  +1E -1E -1E   a1 :set
  +1E -1E +1E   a2 :set
  -1E -1E +1E   a3 :set
  -1E -1E -1E   a4 :set
  ( ." GLPyramid init. ")
;

;CLASS

\ -----------------------------------------------------------------------

\ ����� ������������
CGLObject SUBCLASS CGLCube

   CGLPoint OBJ a1  CGLPoint OBJ b1
   CGLPoint OBJ a2  CGLPoint OBJ b2
   CGLPoint OBJ a3  CGLPoint OBJ b3
   CGLPoint OBJ a4  CGLPoint OBJ b4

: :draw
  SUPER :draw

  GL_QUADS glBegin DROP \ Drawing Using Squares

     \ -y
     Red SetColor
     0f -1f 0f glNormal3f DROP
     a1 :vertex   a2 :vertex   a3 :vertex   a4 :vertex
     \ +x
     Yellow SetColor
     0f 0f 1f glNormal3f DROP
     a1 :vertex   b1 :vertex   b2 :vertex   a2 :vertex
     \ +z
     Blue SetColor
     1f 0f 0f glNormal3f DROP
     a3 :vertex   a2 :vertex   b2 :vertex   b3 :vertex
     \ -x
     Green SetColor
     0f 0f -1f glNormal3f DROP
     a3 :vertex   b3 :vertex   b4 :vertex   a4 :vertex
     \ -z
     Orange SetColor
     -1f 0f 0f glNormal3f DROP
     b4 :vertex   b1 :vertex   a1 :vertex   a4 :vertex
     \ +y
     Magenta SetColor
     0f 1f 0f glNormal3f DROP
     b4 :vertex   b3 :vertex   b2 :vertex   b1 :vertex

  glEnd  DROP   \ Finished Drawing
;


init:
  +1E -1E -1E   a1 :set      +1E +1E -1E   b1 :set
  +1E -1E +1E   a2 :set      +1E +1E +1E   b2 :set
  -1E -1E +1E   a3 :set      -1E +1E +1E   b3 :set
  -1E -1E -1E   a4 :set      -1E +1E -1E   b4 :set
  ( ." GLCube init. ")
;

;CLASS

\ -----------------------------------------------------------------------

CGLObject SUBCLASS CGLSimpleModel

 CSimpleModel OBJ model
 CGLPoint OBJ color
 CTimer OBJ timer
 VAR _list
 VAR _init

: :setColor color :set ;
: :model model this ;

init: 0.5e 0.5e 0.5e :setColor FALSE _init ! ;
dispose: timer :ms@ CR ." Time in " SUPER name TYPE ."  = " . ;

: :draw-model { | t }
   GL_TRIANGLES glBegin DROP

   model :faces 0 ?DO

    I model :tnth TO t
    t :: CTri.n1@ model :nnth :: CGLPoint.:normal
    t :: CTri.v1@ model :vnth :: CGLPoint.:vertex

    t :: CTri.n2@ model :nnth :: CGLPoint.:normal
    t :: CTri.v2@ model :vnth :: CGLPoint.:vertex

    t :: CTri.n3@ model :nnth :: CGLPoint.:normal
    t :: CTri.v3@ model :vnth :: CGLPoint.:vertex
   LOOP

   glEnd DROP
;

: :prepare
   1 glGenLists _list !
   gl-status
   GL_COMPILE _list @ glNewList DROP
    color :get SetColor
    :draw-model
   glEndList DROP ;

: :draw
   _init @ NOT IF :prepare TRUE _init ! THEN
   SUPER :draw
   timer :start
   \ color :get SetColor
   _list @ glCallList DROP
\   :draw-model
   timer :stop
;

: :xmax model :xmax ;
: :ymax model :ymax ;
: :zmax model :zmax ;

;CLASS

\ -----------------------------------------------------------------------
\EOF
: (x,y) ( addr -- addr+16   F: x y )
  DUP DF@ 8 + DUP DF@ 8 +
;
: (x,y)! ( addr F: x y -- addr+16 )
  FSWAP DUP DF! 8 + DUP DF! 8 +
;

: Vertex3f ( F: x y z -- ) float float float glVertex3f DROP ;

CLASS CPlot2D
  CELL VAR data  \ ����� ������ � ������ ����� x,y
  CELL VAR ndata \ ���-�� �����
  CELL VAR cur   \ ������� ����� � ������� �����
 CGLPoint OBJ min
 CGLPoint OBJ max
 CGLPoint OBJ color

: :data! DUP cur ! data ! ndata ! ;
: :points! DUP 2 * 8 * ALLOCATE THROW own :data! ;
: :point!
     FSWAP cur @ DF!  cur @ 8 + cur !
           cur @ DF!  cur @ 8 + cur !
;

: :init
  White color :set
  0 0 own :data!
;

: :free
   data @ FREE THROW
   own :free
;

\ ��������� ������� �������
: :findScale
  \ ��������� ��������
  data @
   (x,y) FDUP max :y! min :y!
         FDUP max :x! min :x!
  \ ���� ������� �������
  ndata @ 1- 0 DO
   (x,y) FDUP
     max :y FSWAP F< IF FDUP max :y! THEN
     FDUP min :y F< IF min :y! ELSE FDROP THEN
    FDUP
     max :x FSWAP F< IF FDUP max :x! THEN
     FDUP min :x F< IF min :x! ELSE FDROP THEN
  LOOP
  DROP
 \ min :print SPACE max :print CR
;

: :makeScale
  min :x max :x F- FABS 1e-5 F<
   IF min :x 1e-5 F+ max :x!   min :x 1e-5 F- max :x!  THEN
  min :y max :y F- FABS 1e-5 F<
   IF min :y 1e-5 F+ max :y!   min :y 1e-5 F- max :y!  THEN

 data @
  ndata @ 0 DO   \ ������������
   DUP (x,y) DROP
   min :y F-
   max :y min :y F- F/
   FSWAP
   min :x F-
   max :x min :x F- F/
   FSWAP
   (x,y)!
  LOOP
;

\ ������� ���������� �������
: :setScale ( min.x max.x min.y max.y -- )
  max :y! min :y! max :x! min :x!
;

: :getScale ( -- min.x max.x min.y max.y )
  min :x max :x min :y max :y
;

: :draw
\  own :draw
   ndata @ 0= IF EXIT THEN

  GL_LINE_STRIP glBegin DROP
   color :get SetColor
   data @
    ndata @ 0 DO (x,y) 0e Vertex3f LOOP
   DROP
  glEnd DROP
;

;CLASS

\ : each.show <data @ :show 0 ;

\ ==============================================

pvar: <min
pvar: <max
CLASS: GLPlot2D <SUPER GLObject
     Point OBJ max
     Point OBJ min    \ ������� ����
      List OBJ graphs \ �������
  Iterator OBJ iter

: :init
  own :init

  -0.7e -0.5e -1.5e shift :set \ ��� �������������� GL ����
  0e 0e 0e angle.speed :set

  graphs iter :set
  ( ." GLPlot init. ")
;

: :draw
  own :draw

  \ ������������ ����
  GL_LINE_STRIP glBegin DROP \ Drawing Using Lines
    Green SetColor
    -0.05e -0.05e 0e Vertex3f
     1.05e -0.05e 0e Vertex3f
     1.05e  1.05e 0e Vertex3f
    -0.05e  1.05e 0e Vertex3f
    -0.05e -0.05e 0e Vertex3f
   glEnd DROP

   iter :first
   BEGIN
    iter :next IF <data @ :draw 0 ELSE -1 THEN
   UNTIL
;

: :setScale  max :y! min :y! max :x! min :x! ;
: :getScale  min :x max :x min :y max :y ;
: :scaleLast own :getScale graphs <last @ <data @ DUP :setScale :makeScale ;

: :add graphs :addObject ;

: :maxScale ( min.x max.x min.y max.y -- )
  FDUP max :y F< IF FDROP ELSE max :y! THEN
  FDUP min :y F< IF min :y! ELSE FDROP THEN
  FDUP max :x F< IF FDROP ELSE max :x! THEN
  FDUP min :x F< IF min :x! ELSE FDROP THEN
;

: :autoScale
  iter :first
  BEGIN
    iter :next IF <data @ DUP :findScale :getScale own :maxScale 0
             ELSE -1 THEN
  UNTIL
  iter :first
  BEGIN
    iter :next IF own :getScale <data @ DUP :setScale :makeScale 0
             ELSE -1 THEN
  UNTIL
;

( : :free
  \ iter :free
  \ graphs :free
  own :free
; )

;CLASS
HERE SWAP - .( Size of GLObject class is ) . .( bytes) CR
