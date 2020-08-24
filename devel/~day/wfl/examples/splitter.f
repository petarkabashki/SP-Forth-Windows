( The very simple example )

REQUIRE WL-MODULES ~day\lib\includemodule.f
NEEDS ~day\wfl\wfl.f
NEEDS ~day\wfl\controls\splitter.f

( ������ � ������� ��������� ������ )

CPanel SUBCLASS CPercentPanel

: drawPercent ( dc )
    || R: dc CRect r ||
    SUPER getClientRect r !

    DT_VCENTER DT_CENTER OR DT_SINGLELINE OR
    r addr
    SUPER getPercent 100 / S>D <# [CHAR] % HOLD #S #> SWAP
    dc @
    DrawTextA SUPER -wthrow
;

W: WM_PAINT
    || CPaintDC dc ||
    SUPER hWnd @ dc createDC
    DUP TRANSPARENT SWAP SetBkMode SUPER -wthrow
    drawPercent
    0
;

;CLASS

CFrameWindow SUBCLASS CVerySimpleWindow

       CSplitterController OBJ hsplitter
       CSplitterController OBJ vsplitter
       CPercentPanel       OBJ leftPane
       CPercentPanel       OBJ rightPane

W: WM_CREATE
   hsplitter setHorizontal

   \ �� �� ��������� ����� WS_EX_CLIENTEDGE �������, ��� � complexsplitter
    \ �������, ������ �� ������ ���������� �������� ����
   TRUE hsplitter drawSplitter? !
   TRUE vsplitter drawSplitter? !

   \ �������� ������� ������
   6 hsplitter splitWidth !
   6 vsplitter splitWidth !

   \ ������� �������� �������
    \ ���������� ��� ������� � ������ ������

   SELF hsplitter createPanels
   SELF hsplitter createSplitter

   \ ����� �������
    \ �� �������� �� �������� � �������� �������� �������
     \ ���������� �������� �� ������������� ������� (�������� win ����)
   
   hsplitter getUpperPane ( �������� )
   leftPane this OVER vsplitter setLeftPane
   rightPane this OVER vsplitter setRightPane

   vsplitter createSplitter
   0
;

W: WM_DESTROY ( -- n )
   0 PostQuitMessage DROP
   0
;

;CLASS

: winTest ( -- n )
  || CVerySimpleWindow wnd CMessageLoop loop ||

  0 0 wnd create DROP
  SW_SHOW wnd showWindow

  loop run
;

winTest