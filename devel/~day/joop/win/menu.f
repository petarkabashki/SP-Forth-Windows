\ ��������������� ��������� ����
\ ��������� �������, Windows ����������...

\ ��� ������ ��������� ��������� ���� � ����������������
\ ����� ��������� ������ ���� M: ID_OPEN .... ;
\ c������ ����, WM_COMMAND ������������ �����

REQUIRE RegisterClassExA  ~day\joop\win\wfunc.f
REQUIRE Stack ~day\joop\lib\stack.f
REQUIRE { lib\ext\locals.f

USER-VALUE PopupStack

: MENU ( -- )
    Stack :new TO PopupStack
    CreateMenu
    PopupStack :push
;

: POPUPMENU
    Stack :new TO PopupStack
    CreatePopupMenu
    PopupStack :push
;

: POPUP
    CreateMenu
    PopupStack :push    
;

: MENUITEM { c-addr u id -- }
    c-addr id MF_STRING PopupStack :top
    AppendMenuA DROP
;

: MENUSEPARATOR
    0 0 MF_SEPARATOR PopupStack :top
    AppendMenuA DROP    
;

: END-POPUP ( c-addr u -- )
   DROP PopupStack :top
   MF_POPUP
   PopupStack :drop
   PopupStack :top
   AppendMenuA DROP
;

: END-MENU
    PopupStack :base @
    PopupStack :free
;

(
: :createMenu \ -- h
    MENU
       S" test" 101 MENUITEM
       S" test2" 101 MENUITEM
       POPUP
          S" test" 101 MENUITEM
          S" test2" 101 MENUITEM
       S" open" END-POPUP    
    END-MENU
    DUP menu !
;    
: :createPopup \ -- h
    POPUPMENU
       S" test" 101 MENUITEM
       S" test2" 101 MENUITEM
       POPUP
          S" test" 101 MENUITEM
          S" test2" 101 MENUITEM
       S" open" END-POPUP    
    END-MENU
    DUP popupMenu !
;

)