\ 03-02-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ���������� ������ ���� (�������������� �������)

 REQUIRE ROUND     devel\~moleg\lib\util\stackadd.f
 REQUIRE R+        devel\~moleg\lib\util\rstack.f
 REQUIRE BLANKS    devel\~moleg\lib\spf_print\pad.f

        \ ���-�� ������������ � ������ �������� �
        USER-VALUE line# ( --> n )

        \ ���-�� ������������ ����� �� ������
        USER lines ( --> n )

      25 CONSTANT block_ ( const - ���-�� ������������ �� ���� ��� ����� )

\ ���� ��������� ����� ������� �� ������� ������ ������ CRLF, ���������
\ �� 1 ���������� lines �
: ?newline ( # --> )
           DUP line# + DUP 80 <
           IF NIP ELSE CR DROP lines 1+! THEN TO line# ;

\ ���� ������� ESC ������ ������ ���� FALSE
: ?escape ( --> flag )
          lines @ block_ / IF 0 lines ! KEY 0x1B <> CR ELSE TRUE THEN ;

\ ���������� ������ ���� � ��������� �������
: VLIST ( vid # --> u )
        \ �������� ����� ����������. ������-�� ��� ����� �����.
        BEGIN KEY? WHILE ." ." KEY DROP REPEAT

         0 TO line#  0 lines ! >R

         0 >R \ �������������� ������� ����
         @
         BEGIN DUP WHILE  1 R+
               DUP COUNT 1 +
               <# 2DUP DUP 2R@ DROP ROUND OVER - BLANKS BLANK 1 - HOLDS #>
               DUP ?newline  ?escape WHILE
                   TYPE
            CDR
          REPEAT 2DROP
         THEN DROP 2R> NIP ;

\ ���������� ������ ����� � ��������� �������
: NLIST ( vid --> )
        DUP ." in vocabulary " VOC-NAME. ."  words are: " CR
        0x0F VLIST CR ." total: " . ." words." CR ;

\ ����������� ������ ���� �� �������� ������������ �������
: WORDS ( --> ) GET-ORDER OVER NLIST  nDROP ;

\ ����������� ��� ����� � ��������� � ������� ���������� ��������
: ALLWORDS ( --> )
           GET-ORDER
           BEGIN DUP WHILE
                 SWAP NLIST
              1 - CR
           REPEAT DROP ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{
  S" passed" TYPE
}test

\EOF
� ������� �� ������������ WORDS, �� ����� ������ ������, ����� ����������
���������� ������ ����. ����� ����, ��������� ����� ����� VLIST , �������
����� ���������� ������ ���� ��� ������ ���������.