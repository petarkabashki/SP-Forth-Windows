( �������� email ������ - ����� ������, ������ ������ ������, ����� htmlview )

REQUIRE WL-MODULES ~day\lib\includemodule.f
NEEDS ~day\wfl\wfl.f
NEEDS ~day\wfl\controls\splitter.f

CFrameWindow SUBCLASS CSplitterViewDemo

       CSplitterController OBJ hsplitter
       CSplitterController OBJ vsplitter
       CWebBrowser         OBJ htmlView
       CTreeView           OBJ treeView
       CListView           OBJ listView
       CPanel              OBJ rightPane

: fillListView
    listView getClientRect 2DROP NIP 2/

    0 OVER S" column1" listView insertColumn
    1 SWAP S" column2" listView insertColumn

    0 S" Test string1" listView insertString
    0 S" Test string2" listView insertString
;

: fillTreeView
   S" Root" TVI_ROOT treeView insertString DUP
   S" Child1" ROT treeView insertString DUP
   S" Child2" ROT treeView insertString DROP

   treeView expand
   treeView expand
;

\ OnDocumentComplete
H: 0x103
    0 S" ���������" listView insertString
;

W: WM_CREATE
   \ ��������� ������ ����� ���������
   LVS_REPORT listView style OR!
   TVS_HASBUTTONS TVS_HASLINES OR TVS_LINESATROOT OR treeView style OR!
   WS_EX_CLIENTEDGE htmlView exStyle OR!

    \ �� �������� �� �������� � �������� �������� �������
     \ ���������� �������� �� ������������� ������� (�������� win ����)

   treeView this SELF vsplitter setLeftPane
   rightPane this SELF vsplitter setRightPane
   SELF vsplitter createSplitter
   
   \ ��������� ������ ������
   30 vsplitter setPercent 

   hsplitter setHorizontal
   rightPane this
   listView this OVER hsplitter setUpperPane
   htmlView this OVER hsplitter setBottomPane
   hsplitter createSplitter

   \ ���� �������������

   fillListView
   fillTreeView 
   S" http://www.ya.ru/" htmlView navigate
   0
;

W: WM_DESTROY ( -- n )
   0 PostQuitMessage DROP
   0
;

;CLASS

: winTest ( -- n )
  StartCOM
  || CSplitterViewDemo wnd CMessageLoop loop ||

  0 0 wnd create DROP
  SW_SHOW wnd showWindow

  loop run
  EndCOM
;

\ winTest

\ EOF
TRUE  TO ?GUI
FALSE TO ?CONSOLE
FALSE TO TRACE-WINMESSAGES

: winTest
   winTest BYE
;

' winTest MAINX !
   ( �������� � ���������� ����� )
   S" splitter2.exe" S" splitter2.fres " devel\~af\lib\save.f
    BYE