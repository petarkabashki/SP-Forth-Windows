\ ����������� � ����������� ���������� 7-zip
\ ����������� � ������������� ZIP � 7z


\ 7-zip32.dll ����� ����� �� ������:
\ http://www.csdinc.co.jp/archiver/lib/7-zip32.html#download
\ ��� �� ��������, �� ����� ����������...


REQUIRE ZPLACE ~nn/lib/az.f

WINAPI: SevenZip 7-zip32.dll

MODULE: 7zip

100 CONSTANT maxOutputLen

CREATE input 200 ALLOT \ ����� ��� ������� ������ ����������
CREATE output maxOutputLen ALLOT \ �������� �����


CREATE quote CHAR " C, 0 C, \ ������� �������

\ ������������ ����� �������� �� ������� �����:
: quotedInput ( addr u -- ) quote 1 input +ZPLACE  input +ZPLACE  quote 1 input +ZPLACE ;


EXPORT

\ ��������� ������� ��������� � input, � ����������� �������� � output
\ ������� ��� ���� ����� �� ��� � ��� ������ 7z.exe � �������� ������,
\ �� ���� x a e � ������ (��. ������� �� 7-zip)
: 7zcommand maxOutputLen output input 0 SevenZip \ input ASCIIZ> CR TYPE 
;

\ ��� (what) �� ����� ����������� ���� (where), � ����� �����
\ f -- ���� ������, =0 ���� �� ������
: zip-extract ( where what -- f ) \ ���������� ��� ����������
S" x " input ZPLACE
quotedInput
S"  -hide -aoa -o" input +ZPLACE \ hide ����� ��� ���� ����� �������� ������ � ��������
quotedInput
7zcommand ;

\ ��� (what) �� ����� ����������� ���� (toWhere), � ����� zip-�����
\ f -- ���� ������, =0 ���� �� ������
: zip-pack ( what toWhere arc -- f )
S" a " input ZPLACE
quotedInput
S"  -hide -tzip -r " input +ZPLACE
quotedInput
7zcommand ;

\ ��� (what) �� ����� (��, ����� ��������� �����) ����������� ���� (toWhere), � ����� 7z-�����
\ f -- ���� ������, =0 ���� �� ������
: 7zip-pack ( what toWhere arc -- f )
S" a " input ZPLACE
quotedInput
S"  -hide -t7z -r " input +ZPLACE
quotedInput
7zcommand ;

;MODULE

\EOF

S" 7zip-dll.f" S" r.zip" zip-pack CR .
S" 7zip-dll.f" S" r.7z" 7zip-pack CR .

S" r" S" r.zip" zip-extract CR .
S" r" S" r.7z" zip-extract CR .