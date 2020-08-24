\ 24-05-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������ � ������� � ������������� ������

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f
 REQUIRE >DIGIT    devel\~moleg\lib\spf_print\pad.f
 REQUIRE R+        devel\~moleg\lib\util\rstack.f
 REQUIRE UD/       devel\~moleg\lib\math\math.f

       8 VALUE places   \ ���������� ������������ �������� ����� �������

\ �������� ��������� �����
: $ ( n --> n*base ) BASE @ UM* >DIGIT KEEP ;

\ ������������� �����
: $S ( n --> )
     places HLD @ OVER CHARS - HLD !
     HLD @ >R
      >R BEGIN R@ WHILE $ -1 R+ REPEAT RDROP DROP
     R> HLD ! ;

\ ������������� ����� � ������������� ������.
: (N.P) ( p n --> asc # )
        DUP >R DABS SWAP 1 + <# $S comma HOLD 0 #S R> SIGN #> ;

\ ����������� ����� � ������������� ������
: N.P ( n p --> ) (N.P) TYPE SPACE ;

\ ������������� ������ � ������������� ����� ����� ���������� �����
: >FRACT ( asc # --> p TRUE | FALSE )
         0 >R  SWAP char - TUCK +
         BEGIN 2DUP <> WHILE
               DUP C@ BASE @ DIGIT WHILE
               R> SWAP BASE @ UD/ DROP >R
             char -
           REPEAT 2DROP RDROP FALSE EXIT
         THEN 2DROP R> TRUE ;

\ ������������� ������ ���� " 123,345" � ����� � ������������� ������
: pNUMBER ( asc # --> n p TRUE | FALSE )
          0 0 2SWAP >NUMBER
          DUP IF OVER C@ comma =
                 IF SKIP1 >FRACT
                    IF NIP SWAP TRUE EXIT THEN
                 THEN
              THEN
          2DROP 2DROP FALSE ;

\ �������� ��� ������������� ����� ������� ����� ���� �� �����
: UD* ( uda udb --> udab )
      ROT >R OVER >R >R OVER >R UM* 2R> * 2R> * + + ;

\ ��� ������� ����� ������� ��������������, ���� �� ������������ �������
: 2dsign ( da da --> uda uda signab )
         DUP >R DABS 2SWAP DUP >R DABS 2SWAP 2R> XOR ;

\ �������� ��� ����� ������� ����� ���� �� �����
: D* ( da db --> dab ) 2dsign >R UD* R> 0 < IF DNEGATE THEN ;

\ �������� ��� ����������� ����� � ������������� ������
\ �������� ������������ �����������
: UP* ( upa upb --> upab )
      DUP >R ROT DUP >R >R OVER >R >R SWAP DUP >R
      UM* NIP S>D 2R> UM* D+  2R> UM* D+ 2R> * + ;

\ �������� ��� �������� ����� � ������������� ������
: P* ( p1 p2 --> p ) 2dsign >R UP* R> 0 < IF DNEGATE THEN ;


?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ S" 12,345" pNUMBER 0= THROW
         1481763717 12 D= 0= THROW
  S" passed" TYPE
}test

\EOF
����� � ������������� ������. ���� ������ �� ����� ������ ��������� ���
����� ����� �����, ������ ��� �������. ����� � ������������� ������
������������ �� �������������� �������: 0,123 1,345 � ���� ��������.
� ����������� 4������� cell ������ ����� 9 ���������� �������� - ����������
places ���������� ������� ����� ����� ������� ����� �����������.
����������� ��������� �������� � � 10 � � 16 �������.

\ 23-06-2007  ������� ��������� ����� � ������������� ������