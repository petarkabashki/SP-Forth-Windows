REQUIRE CODE lib/ext/spf-asm-tmp.f

\ ������� ��������� ��������� ������ � ������
CODE last-character ( z � -- z'/0)
\ AL - ������
\ EBX - ������� ���������
\ ECX - ������ ������
     MOV EBX, [EBP]
     MOV ECX, EBX
     LEA EBP, 4 [EBP]
\ ������� ����� ������
@@2: CMP BYTE [EBX], # 0
     JE SHORT @@3
     INC EBX
     JMP SHORT @@2

@@3: CMP BYTE [EBX], AL
     JE SHORT @@4
     CMP EBX, ECX
     JE SHORT @@5
     DEC EBX
     JMP SHORT @@3
\ �����
@@4: MOV EAX, EBX
     RET
\ �� �����
@@5: XOR EAX, EAX
     RET
END-CODE

\ �������� ��������� ��������� ������ � ������ �� 0
: -trail ( z c -- )
  2DUP last-character ?DUP IF 
    ( z c z1) 0 SWAP C! 2DROP 
  ELSE
    ( z � ) DROP
  THEN 
;
