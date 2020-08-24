\ $Id: GLCanvas.f,v 1.8 2007/11/28 20:48:25 ygreks Exp $

REQUIRE WL-MODULES ~day/lib/includemodule.f

NEEDS ~day/wfl/wfl.f
NEEDS ~ygrek/lib/wfl/opengl/common.f
NEEDS lib/include/float2.f
NEEDS ~ygrek/lib/wfl/opengl/GLObject.f

\ -----------------------------------------------------------------------

\ ������� ��� ��������� � ����� ������ ������������
CLASS CGLCanvas

\ �������� ��� ��������� ������� (�������������� viewport, projection)
: :resize ( width height -- ) 2DROP ;

\ �������� ��� ��������� ������� ����� (modelview)
: :display ;

;CLASS

\ -----------------------------------------------------------------------

\ ������ ��� ������������ canvas
\ �������� ��� ������� �������
CGLCanvas SUBCLASS CGLSimpleCanvas

: :resize { w h -- }
    \ CR w . h .

    h w 0 0 glViewport DROP    \ Reset The Current Viewport

    GL_PROJECTION glMatrixMode DROP \ Select The Projection Matrix
    glLoadIdentity  DROP            \ Reset The Projection Matrix
    \ Calculate The Aspect Ratio Of The Window
    100e double \ far clipping plane
    0.1e double \ near clipping plane
    w DS>F h DS>F F/ double \ aspect ratio
    45e double  \ Field of View Y-coordinate
    gluPerspective DROP

   1E double glClearDepth DROP      \ Depth Buffer Setup
   GL_DEPTH_TEST glEnable DROP      \ Enables Depth Testing

\   GL_LEQUAL glDepthFunc  DROP      \ The Type Of Depth Testing To Do
\   GL_SMOOTH glShadeModel DROP \ Enable Smooth Shading
\   GL_NICEST GL_PERSPECTIVE_CORRECTION_HINT glHint DROP
                   \ Really Nice Perspective Calculations
\
\   GL_FRONT_AND_BACK GL_SHININESS 100e float glMaterialf DROP
\   GL_FRONT_AND_BACK GL_SPECULAR glColorMaterial DROP
\   GL_FRONT_AND_BACK GL_AMBIENT_AND_DIFFUSE glColorMaterial DROP
\
\   GL_SCISSOR_TEST glDisable DROP
;

: :display ( -- )
    0E float 0E float 0E float 0E float glClearColor DROP \ Black Background

    GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT OR glClear DROP

    GL_MODELVIEW glMatrixMode DROP
    glLoadIdentity DROP
;

;CLASS

\ -----------------------------------------------------------------------

CGLSimpleCanvas SUBCLASS CGLSimpleScene

 CGLObjectList OBJ _scene

: :display
   SUPER :display 
   _scene :draw
   _scene :rotate ;

: :add _scene :add ;
: :setShift _scene :setShift ;
: :setAngleSpeed _scene :setAngleSpeed ;
 
;CLASS

\ -----------------------------------------------------------------------
