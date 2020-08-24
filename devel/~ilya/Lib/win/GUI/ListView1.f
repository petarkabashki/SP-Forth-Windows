
\ 
\ ���������� ������ ListView �� ~nn
\ 29.03.2005�. ���������� �.�.
S" lib/ext/struct.f" INCLUDED
REQUIRE ListView  ~nn/lib/win/controls/listview.f
\ typedef struct tagNMLISTVIEW {
\ 0

\ CONSTANT /NMLISTVIEW
	STRUCT: POINT
		2 -- x 
		2 -- y
	;STRUCT

	STRUCT: NMHDR 
		CELL -- hwndFrom
		CELL -- idFrom
		CELL -- code
	;STRUCT

	STRUCT: NMLISTVIEW
		NMHDR::/SIZE -- hdr
		CELL -- iItem
		CELL -- iSubItem
		CELL -- uNewState
		CELL -- uOldState
		CELL -- uChanged
		POINT::/SIZE -- ptAction
		CELL -- lParam
	;STRUCT			\ ����� ! ���� ���������� ������ 3-� ����



ListView REOPEN
	var vSelectedSubItem	\ ��������� ����������
	
\ ������� �� 2-� ����
N: NM_DBLCLK 
        lparam @ 3 CELLS + @ ( DUP . CR) vSelectedItem !
		lparam @ 4 CELLS + @ vSelectedSubItem !
        OnDoubleClick GoParent ;
N: NM_CLICK 
        lparam @ 3 CELLS + @ ( DUP . CR) vSelectedItem !
		lparam @ 4 CELLS + @ vSelectedSubItem !
        OnClick GoParent ;		

\ ������� ��������� �������� ��������
\ ���: adr u - ��������� � ������ ������
\
M: GetItem { row col adr u \ item -- }
0 adr u row LVItem NEW TO item 
 col item ->CLASS LVItem iSubItem ! 
item row LVM_GETITEMTEXTA SendMessage DROP
item ->CLASS LVItem pszText @ 
\ item ->CLASS LVItem cchTextMax @ 
ASCIIZ>
item DELETE
;

M: DeleteItem ( item -- )
0 SWAP LVM_DELETEITEM SendMessage DROP
;

M: GetItemState ( mask i  -- state )
	LVM_GETITEMSTATE SendMessage 
;

M: SetItemState { state i \ item -- } ( state i -- )
0 0 0 0 LVItem NEW TO item 
	LVIS_OVERLAYMASK item ->CLASS LVItem stateMask !
	state item ->CLASS LVItem state !
	item i LVM_SETITEMSTATE SendMessage DROP 
item DELETE
;

\ ������������� ���� "����������"
M: SetBkColor ( coloref -- )
0 LVM_SETBKCOLOR SendMessage DROP
;
\ ������������� ���� "����������" ������
M: SetTxtBkColor ( coloref -- )
0 LVM_SETTEXTBKCOLOR SendMessage DROP
;
\ ������������� ���� ������
M: SetTxtColor ( coloref -- )
0 LVM_SETTEXTCOLOR SendMessage DROP
;
\ ������ ���� "����������"
M: GetBkColor ( -- coloref )
0 0 LVM_GETBKCOLOR SendMessage 
;
\ ������ ���� "����������" ������
M: GetTxtBkColor ( -- coloref )
0 0 LVM_GETTEXTBKCOLOR SendMessage 
;
\ ������ ���� ������
M: GetTxtColor ( -- coloref )
0 0 LVM_GETTEXTCOLOR SendMessage 
;

\ 
M: ScrollXY ( x y -- )
 SWAP LVM_SCROLL SendMessage DROP
;

M: GetColumn ( a u width iCol --  LVColumn )
>R SWAP 1+ SWAP LVColumn NEW DUP R> LVM_GETCOLUMNA SendMessage DROP 
;

M: SetColumn ( LVColumn iCol -- )
OVER >R LVM_SETCOLUMNA SendMessage DROP R> DELETE
;

M: GetCount ( -- n )
0 0 LVM_GETITEMCOUNT SendMessage 
;

M: GetSelectedCount ( -- n )
0 0 LVM_GETSELECTEDCOUNT SendMessage
;

;CLASS

