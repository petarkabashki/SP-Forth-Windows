\ ������ ���������� ������������ ������� �������� ��������� ��������
\ ������ ���������� ������ �����, ������ - ���� ��������
\ ��� ��� �� ��������� �������, ������ ���������� � �������� ��������

\ �� ���� ����� ����� static ����� ������� � ������ static ��� ��������������
\ ������������ - ��� � ��� ���� ������������

\ ����� ����� ����� ���� �� ������� ������� ����� - ��� ������������
\ � ������ CMyStatic, ��������, �� ��� ����������� ����� 
\ ������������ � ������� �������� ��� ���� ������������ �������������
\ ���� ������� �� �������� ����� ����� ����� ������������� (�������� splitter)

REQUIRE WL-MODULES ~day\lib\includemodule.f
NEEDS ~day\wfl\wfl.f

100 CONSTANT CUSTOM_STATIC

0 0 100 50
WS_POPUP WS_SYSMENU OR WS_CAPTION OR DS_MODALFRAME OR
DS_SETFONT OR DS_CENTER OR

DIALOG: Dialog1 Customized static

      8 0 FONT MS Sans Serif

      CUSTOM_STATIC  25  15  50 15  WS_GROUP LTEXT Static1

DIALOG;

\ ���� ���������� ����� ������ ���������� WM_CTLCOLOR ���������
CMsgController SUBCLASS CColorController

       CBrush OBJ brush

init:
    0xFF 0xFF 0 rgb brush createSolid SUPER -wthrow
;

\ Note - it is R: for reflected message, not W:

R: WM_CTLCOLORSTATIC ( -- n )
    SUPER msg wParam @
    TRANSPARENT SWAP SetBkMode DROP
    brush handle @

    \ ��� �� ����������� � �� ��������� ��� ��������. 
    \ ������ ������������ FALSE SetHandled
    \ ���� �� ����� ����� ������ Win ��������� ������������ ����������
    \ ������������� (� ����� ����� ����������-�����) � �������

    TRUE SUPER SetHandled 
;

;CLASS

CMsgController SUBCLASS CFontController

      CFont OBJ m_font

\ ���� ����� ���������� ������ ��� ����� ���������� ��������� � ����
 \ (� ��� ����� � � attach ������)
: onAttached
    -18 FW_BOLD S" Tahoma" m_font createFont
    0 SUPER parent-obj@ ^ setFont
;

;CLASS

\ �������� ����� ����� ������� - ��� ���� ����� ���������������� ������
\ � WM_INITDIALOG

CDialog SUBCLASS CMyDialog

    CFontController OBJ m_fontController
    CColorController OBJ m_colorController
    CStatic OBJ m_static

\ ��������� ����������� ������� �������� �����
REFLECT_NOTFICATIONS

W: WM_INITDIALOG ( -- res )
    \ ���������� ��������� CStatic � ������ ���� static
    CUSTOM_STATIC SUPER getDlgItem m_static attach

    \ ��������� ����������� � ���������� ������ static
     \ �� ��������� ���������� ���������� ��� inject ����� ������
      \ � ���������� � �� ������� hWnd
    m_colorController this m_static injectMsgController
    m_fontController this m_static injectMsgController

    0
;

;CLASS

CMyDialog NEW dlg1

Dialog1 0 dlg1 showModal DROP