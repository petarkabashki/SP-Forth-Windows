\ ������� ��� sprintf 
\ ���������� �.�.
\ 15.11.05�.

USER-VALUE _sp

WINAPI: sprintf MSVCRT.DLL 

\ ���� �� float-����� �����
: F>ST 0. SP@ DF! ;

\ ����������� ������ � C �����
\ ���: 	i*x - ������ �� ����� ������
\		adr - ��������� Z- ������ ���� " %s%8.2f"
: printf  ( i*x adr -- c-adr n )
		PAD sprintf DUP 0 < THROW 
		>R 
		_sp SP!
		R>
	PAD SWAP ;
: ]> DROP printf ;

: printf<[ 
SP@ TO _sp
;

\EOF
\ ������
printf<[ 12.0345e F>ST S" stroka" DROP 333 S" Number:%d String:%s Float:%f" ]> CR TYPE


