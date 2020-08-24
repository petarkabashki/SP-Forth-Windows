\ 26-06-2005 ~mOleg
\ ������ � �������

\ x - �������� �� ������ a-addr.
CODE @ ( a-addr --> x )
       MOV tos , [tos]
     exit
  END-CODE

\ �������� x �� ������ a-addr.
CODE ! ( x a-addr --> )
       MOV temp , subtop
       MOV [tos] , temp
       MOV tos , CELL [top]
       dheave 2 CELLS
     exit
  END-CODE

\ �������� byte �� ������ c-addr.
\ ���������� ������� ���� ������ �������.
CODE B@ ( c-addr --> char )
        MOVZX tos , BYTE [tos]
      exit
   END-CODE

\ �������� byte �� ������ a-addr.
CODE B! ( char c-addr --> )
        MOV temp , subtop
        MOV BYTE [tos] , temp-byte
        MOV tos , CELL [top]
        dheave 2 CELLS
      exit
   END-CODE

\ �������� ������ �� ������ c-addr.
\ ���������� ������� ���� ������ �������.
CODE C@ ( c-addr --> char )
        MOVZX tos , BYTE [tos]
      exit
   END-CODE

\ �������� char �� ������ a-addr.
CODE C! ( char c-addr --> )
        MOV temp , subtop
        MOV BYTE [tos] , temp-byte
        MOV tos , CELL [top]
        dheave 2 CELLS
      exit
   END-CODE

\ �������� word �� ������ c-addr. ���������� ������� ���� ������ �������.
CODE W@ ( c-addr --> word )
        MOVZX tos , WORD [tos]
      exit
   END-CODE

\ �������� word �� ������ a-addr.
CODE W! ( word c-addr --> )
        MOV temp , subtop
        MOV WORD [tos] , temp-word
        MOV tos , CELL [top]
        dheave 2 CELLS
      exit
   END-CODE

\ ������� ����� ������� �������� �� ������ �� ������ addr
CODE 2@ ( addr --> d )
        MOV temp , CELL [tos]
        dpush temp
        MOV tos , [tos]
      exit
   END-CODE

\ ��������� ����� ������� �������� � ������ �� ������ addr
CODE 2! ( d addr --> )
        MOV temp , subtop
        MOV [tos] , temp
        MOV temp , CELL [top]
        MOV CELL [tos] , temp
        dheave 3 CELLS
        MOV tos , -CELL [top]
      exit
   END-CODE

\ ��������� �������� �� ������ addr
CODE 1+! ( addr --> )
         INC DWORD [tos]
         dpop tos
      exit
    END-CODE

\ ��������� ����� n � ����� ����������� � ������ �� ������ addr
CODE +! ( n addr --> )
        MOV temp , subtop
        ADD [tos] , temp
        MOV tos , CELL [top]
        dheave 2 CELLS
      exit
   END-CODE

\ � ����������...
\ ����� � ���, ��� ����������� �������� ������ ����� �� ��������� �
\ ������������ ������, �� ���� ����� ���� ������ ��� ����� � ������ ������.

\ ������� �����
CODE A@ ( a-addr --> x )
        MOV tos , [tos]
      exit
   END-CODE

\ ��������� �����
CODE A! ( x a-addr --> )
        MOV temp , subtop
        MOV [tos] , temp
        MOV tos , CELL [top]
        dheave 2 CELLS
      exit
   END-CODE

\ �������� �������� �� ���������� ������ �� new - ������ �������
CODE ACHANGE ( new addr --> old )
             dpop temp
             MOV addr , tos
             MOV tos , [addr]
             MOV [addr] , temp
           exit
       END-CODE
