

REQUIRE BEGIN-CODE  ~day\common\code.f 

(  � Pentium'� �������������� ���� ������� ������� RDTSC, ������������ �����
������ ��������� � ������� ������ �� ���� ����������. ��� ���� ������� $0F $31.
������� ���������� ������������� ����� � ��������� EDX:EAX. 
)

BEGIN-CODE
ALSO ASSEMBLER

CODE GetTicks  (  -- tlo thi )
     RDTSC
     SUB EBP, # 8
     MOV [EBP], EDX
     MOV 4 [EBP], EAX
     RET
END-CODE

PREVIOUS
CLOSE-CODE

BYE
