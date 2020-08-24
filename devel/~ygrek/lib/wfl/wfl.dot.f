\ ��������� ������� wfl
\ �� ������ dot-���� ��� GraphViz
\ "C:\Program Files\ATT\Graphviz\bin\dot.exe" -Tpng wfl.dot -owfl.png
\ ��������������� �������� - http://forth.org.ru/~ygrek/files/wfl.png

REQUIRE WL-MODULES ~day/lib/includemodule.f
NEEDS ~day/hype3/hype3.f
NEEDS ~ygrek/lib/dot.f
NEEDS ~ygrek/lib/parse.f

\ �������������� ������������ ��� Hype3
\ �������� ���� � ������ ����� ��������
: SUBCLASS
   DUP HYPE::.nfa @ COUNT PICK-NAME DOT-LINK

   SUBCLASS ;

S" wfl.dot" dot{

 S" node" S" filled" S" style" DOT-ATTRIBUTE
 S" node" S" black" S" color" DOT-ATTRIBUTE

 S" green" DOT-FILLCOLOR
 NEEDS ~day/wfl/wfl.f
 S" yellow" DOT-FILLCOLOR
 NEEDS ~ygrek/lib/wfl/opengl/GLWindow.f
 NEEDS ~profit/lib/wfl/openGL/GLImage.f
 S" grey" DOT-FILLCOLOR
 NEEDS ~day/wfl/controls/urllabel.f
 NEEDS ~day/wfl/controls/splitter.f
 NEEDS ~day/wfl/controls/scintilla/scintilla.f
}dot

CR .( DONE)
BYE
