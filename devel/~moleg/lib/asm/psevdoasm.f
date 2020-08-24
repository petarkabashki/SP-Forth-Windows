\ 02-05-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������� ��� ����������� ����������������

 REQUIRE ?DEFINED   devel\~moleg\lib\util\ifdef.f
 REQUIRE ASSEMBLER  lib\ext\spf-asm.f
 REQUIRE psevdoregs devel\~mOleg\lib\asm\registers.f

CREATE psevdoasm

: -CELL CELL NEGATE ;
: param  NextWord EVALUATE ;

\ ����� �� ������������� ���������.
MACRO: exit RET ENDM

\ -- ������ �� ������� ------------------------------------------------------

\ �������� ��������� ����� ������ �� ��������� ���-�� ����
MACRO: dheave LEA top , [top] ENDM

\ �������� ��������� ����� ��������� �� ��������� ���-�� ����
MACRO: rheave LEA rtop , [rtop] ENDM

\ �������� ���������� ���������� �������� �� ������� ����� ������
MACRO: dpush  dheave -CELL  MOV subtop , ENDM
\ ��������� ��������� ������� ���������� ���������� ����� ������
MACRO: dpop   MOV param , subtop dheave CELL  ENDM

\ ������� ���������� ������� ����� ��������� � ��������� �������
MACRO: rpop   POP  ENDM
\ ��������� ���������� ���������� �������� �� ������� ����� ���������
MACRO: rpush  PUSH ENDM

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{

  S" passed" TYPE
}test
