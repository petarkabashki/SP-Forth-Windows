( ��������������� ����� ��� ��������� �������� ����� ��� )
: _2POWER
   CREATE ( n - )   1 DUP , SWAP  0 ?DO  2* DUP ,  LOOP  DROP
   DOES> ( n - 2^n )  SWAP CELLS + @ ;

( ������� ������ �� 2^0 �� 2^31 )
32 _2POWER  2POWER

( ��������� ������� �����)
: REVCELL ( # - # )
   DUP IF  0 SWAP  32 0 ?DO  DUP 0< IF  SWAP I 2POWER + SWAP  THEN  2*  LOOP  DROP
   THEN ;

: revarr ( addr # -  )
   0 ?DO  DUP @  REVCELL OVER !  CELL+  LOOP  DROP ;