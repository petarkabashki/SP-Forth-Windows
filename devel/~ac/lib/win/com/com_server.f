REQUIRE CLSID, ~ac/lib/win/com/com.f

0x80020006 CONSTANT DISP_E_UNKNOWNNAME
0x8002000E CONSTANT DISP_E_BADPARAMCOUNT
0x80020009 CONSTANT DISP_E_EXCEPTION
         4 CONSTANT DISPATCH_PROPERTYPUT

VARIABLE FCNT \ ���������� ������� AddRef/Release, �.�. ������� ����� ��������

: Class. ( oid -- oid )
  CR DUP @ WordByAddr TYPE R@ WordByAddr TYPE SPACE
;

: Class: ( implement_interface "name" "clsid" -- current class_int )
  CREATE 
    HERE SWAP
    BL WORD COUNT CLSID, 
    DUP ,               \ ������ (������ IID ������������ ����������)
    Methods#            \ �-�� ������� ������
    DUP ,               \ ���� ������ (�-��)
    LATEST ,            \ ��� ���
    HERE CELL+ ,        \ oid ������ (��������� �� Vtable)
    1+ CELLS HERE SWAP DUP ALLOT ERASE     \ VTABLE
    -1 ,
    GET-CURRENT WORDLIST
    LATEST OVER VOC-NAME! \ ��� ������������ ������������� � ORDER
    SET-CURRENT SWAP
  DOES> 7 CELLS + ( oid )
;

: Class; DROP SET-CURRENT ;

: Class ( oid -- class_int ) 7 CELLS - ;

: SpfClassName ( oid -- addr u )
  \ ����� oid - com'������ ��������� �� ��������� vtable
  \ �.�. ���, ��� ������ ���������� � �������
  @ 2 CELLS - @ COUNT
;
: SpfClassWid ( oid -- wid )
  @ DUP 3 CELLS - @ \ methods#
  1+ CELLS + \ ���������� vtable
  CELL+ \ ���������� -1 � ��������� Class: ����
  CELL+ \ ���������� voc-list
;
: ComClassIID ( oid -- addr u )
  @ 4 CELLS - @
;

0
CELL -- c.VTBL
CELL -- c.MAGIC  \ SPFR
CELL -- c.REFCNT \ ������� ������ AddRef/Release
CONSTANT /COM_OBJ \ ����� �����-������ �������� ��������� ����.���.

: NewComObj ( extra_size class_oid -- oid )
\ ������� ������ ��������� ������ � �������������� ������� ������� size.
\ ���������� ������� COM-������ (extra_size=0) ������� ������ ������
\ ��� ��������� �� vmt (������� ��� �� ��� � � ������ ������� "�����").
\ �������: /BROWSER SPF.IWebBrowserEvents2 NewComObj
( �� ����� ��������� �������� ������� ������ ��� �������, ���������� �������
  ��������� � ����� ���������, �.�. ��� ������� �������� COM-��������.)
  @ SWAP /COM_OBJ + ALLOCATE THROW DUP >R c.VTBL !
  S" SPFR" DROP @ R@ c.MAGIC !
  R>
;
: IsMyComObject? ( oid -- flag )
  c.MAGIC @ S" SPFR" DROP @ =
;
: (AddRef) ( oid -- cnt )
  DUP IsMyComObject?
  IF DUP c.REFCNT 1+! c.REFCNT @
     FCNT 1+!
  ELSE DROP FCNT 1+! FCNT @ THEN
;
: (Release) ( oid -- cnt )
  DUP IsMyComObject?
  IF DUP c.REFCNT @ 1- DUP ROT c.REFCNT !
     FCNT @ 1- FCNT ! \ ������������, ���� ���������� ������� �������� � ����, �� com-������ ����� �����������
  ELSE DROP FCNT @ 1- DUP FCNT ! THEN \ �� ���������� ����������, ��� �� ������ � ������������� ;)
;
: Extends ( class_int -- class_int )
  DUP
  ' EXECUTE             \ oid ������, �� �������� �������� VTABLE
  DUP 2 CELLS - @ CELLS \ ������� ����������
  ( class_int class_int oid n )
  SWAP @                \ ������ ����������
  ROT 8 CELLS +         \ ����
  ROT MOVE
;

: ToVtable ( class_int xt -- class_int )
  OVER >R
  LAST @ FIND
  IF >BODY @ ( ����� ������ � VTABLE )
     8 + \ �������� VTABLE � ����������� ������
     CELLS R> + !
  ELSE -321 THROW THEN
;
: METHOD ( class_int -- class_int )
  LAST @ NAME> TASK ToVtable
;
