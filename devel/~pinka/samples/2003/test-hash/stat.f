\ 01.Nov.2003

10 CONSTANT #STAT

#STAT 1+ CELLS CONSTANT /STATTBL

CREATE STATTBL  /STATTBL ALLOT   STATTBL  /STATTBL ERASE

: INIT-STAT ( -- )
  STATTBL  /STATTBL ERASE
;
: STAT+ ( i -- ) 
  #STAT UMIN  CELLS STATTBL +  1+!
;
: STAT. ( -- )
  STATTBL /STATTBL + STATTBL DO
  I @ S>D <# # # # #> TYPE SPACE
                            CELL +LOOP
;

\ STAT+ ( i -- )  
\  ���� i < #STAT,  ����������� �������� i-�� �������� �� 1
\  ����� ����������� �������� ���������� ��������
