\ Name: vararr.f
\ "������ � Variant-���������"
\ �������� ��� Automate.f (c) ~yz 
\ ���������� �.�. ilya@forth.org.ru
\ v1.0 - 14.07.2005�.
\ v1.1 - 17.07.2005�.



WINAPI: SafeArrayGetElement OLEAUT32.DLL
WINAPI: SafeArrayGetDim OLEAUT32.DLL
WINAPI: SafeArrayGetElemsize OLEAUT32.DLL
WINAPI: SafeArrayGetIID OLEAUT32.DLL
WINAPI: SafeArrayGetVartype OLEAUT32.DLL
WINAPI: SafeArrayCreateVector OLEAUT32.DLL
WINAPI: SafeArrayCreate   OLEAUT32.DLL
WINAPI: SafeArrayCopy   OLEAUT32.DLL
WINAPI: SafeArrayCopyData   OLEAUT32.DLL
WINAPI: SafeArrayDestroy   OLEAUT32.DLL
WINAPI: SafeArrayGetLBound   OLEAUT32.DLL
WINAPI: SafeArrayGetUBound   OLEAUT32.DLL
WINAPI: SafeArrayAccessData   OLEAUT32.DLL
WINAPI: SafeArrayUnaccessData   OLEAUT32.DLL


0
CELL -- cElements
CELL -- lLbound
CONSTANT /SAFEARRAYBOUND

0
2 -- cDims
2 -- fFeatures
2 -- cbElements
2 -- cLocks
CELL -- handle
4 -- pvData
CELL -- rgsabound
CONSTANT /SAFEARRAY


CREATE SAFEARRAYBOUND /SAFEARRAYBOUND 10 * ALLOT

VARIABLE psa			\ ���������� SAFEARRAY �������
VARIABLE c_arr			\ �������� �� ������ � "�++" �������
VARIABLE colMax			\ ���-�� �������� � �������
VARIABLE rowMax			\ ���-�� ����� � �������
VARIABLE varrType		\ ��� �������

: create-arr SafeArrayCreate DUP 0= ABORT" Not Create Array !" ;
: destroy-arr SafeArrayDestroy  ABORT" Not Destroy Array !" ;

: copy-arr ( psaOut psa -- ) SafeArrayCopy ABORT" Not Copy Array !" ;

\ �������� ������ � ������ (� ������� C++) �� ������� ������������� psa
: acc-arr ( psa -- ) c_arr SWAP SafeArrayAccessData ABORT" Not Access Array !" ;
\ ��������� ������ � ������ (� ������� C++) �� ������� ������������� psa
: unacc-arr ( psa -- ) SafeArrayUnaccessData ABORT" Not Unaccess Array !" ;

\ �������� ���������� ����� � �������� � �������
: get-range
	rowMax 1 psa @ SafeArrayGetUBound DROP
	colMax 2 psa @ SafeArrayGetUBound DROP
;

\ �������� �� ������������ ��������
: check-index ( row col -- )
	get-range
	OVER colMax @ 1- > IF ABORT" Column Index Out of Range !" THEN
	DUP rowMax @ 1- > IF  ABORT" Row Index Out of Range !" THEN
;

\ �������� n-� ������� �� 2-� ������� ������� (� ������� C++) 
: _getel-arr ( n - value/dvalue type )
	4 CELLS * c_arr @ +
	variant@ 
;

\ �������� ������� ������������ row,col �� 2-� ������� ������� (� ������� C++)
: getel-arr ( col row -- value/dvalue type) \ { \ rowMax colMax -- }
	check-index
	SWAP rowMax @ * +  _getel-arr
;

\ ��������� � ������ n-� �������
: _putel-arr
	4 CELLS * c_arr @ +
	variant!
;

\ ��������� ������� ������������ row,col � 2-� ������ ������ (� ������� C++)
: putel-arr ( value/dvalue type col row -- ) \ { \ rowMax colMax -- }
	check-index
	SWAP rowMax @ * +  _putel-arr
;

: _ARR-SAVE { \ psain -- }
@ DUP TO psain 
		\ ������ ����� (������) ������ � �������� � ����� ��������� �������
		SafeArrayGetDim DUP CR ." DIM=" .H
		psain W@ .H
		\ tmp 1 psain SafeArrayGetUBound 0= IF CR ." UBound=" tmp @ . THEN
		\ tmp 2 psain SafeArrayGetUBound 0= IF CR ." UBound=" tmp @ . THEN
		0 SAFEARRAYBOUND cElements !
		SAFEARRAYBOUND SWAP
		varrType psain SafeArrayGetVartype DROP varrType @ CR ." =>" .S ." <=" create-arr psa ! 
		\ �������� �������� ������ �� ����� ���������
		psa psain copy-arr
		psa @	\ �� ������ ����� ��������� �� ���������� �������
;
' _ARR-SAVE TO ARR-SAVE