\ ������� ��������� �� ������ ����� � ����������� :)
\ ����� ������� � yz ���� ����� ����� 60 ����� ��������
\ ��� ��������?...

\ infile - windows.const
\ outfile - stealconst.f

REQUIRE { lib\ext\locals.f

: steal { \ file const }
   S" windows.const" R/O OPEN-FILE THROW
   -> file
   file FILE-SIZE THROW DROP DUP ALLOCATE THROW 
   -> const
   const SWAP file READ-FILE THROW DROP
   S" stealconst.f" W/O CREATE-FILE THROW TO H-STDOUT
   const CELL+ @ 0
   DO
     I 2 + CELLS const + @
     const + DUP @ . ." CONSTANT "
     CELL+ COUNT TYPE CR
   LOOP
   H-STDOUT CLOSE-FILE THROW
   file CLOSE-FILE THROW
   const FREE THROW
   BYE
;

steal