\ 16-02-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ �������������� �������� ��������� ��� �������������.

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

\ ��������� ����� ������� ������ �� ���������
?DEFINED DU* : DU* ( d u --> d ) TUCK * >R UM* R> + ;

\ ������������� ������ � ����� �
: >CIPHER ( c --> u|-1 )
          DUP [CHAR] 0 [CHAR] : WITHIN IF 48 - EXIT THEN
          DUP [CHAR] A [CHAR] [ WITHIN IF 55 - EXIT THEN
          DUP [CHAR] a [CHAR] { WITHIN IF 87 - EXIT THEN
          DROP -1 ;

\ �������� ����� x � ����� d*base �
: CIPHER ( d x --> d ) U>D 2SWAP BASE @ DU* D+ ;

\ ���������� ������������� ������ char � �����,
\ � ������� ����������, ������������ base �
: DIGIT ( char base --> u TRUE | FALSE )
        SWAP >CIPHER TUCK U>
        IF TRUE ELSE DROP FALSE THEN ;

\ ��������� ���������� ������������� ����� �� ���������� ( �������� ) �
\ �������������� ������� �� ����� ������ ��� �� ������� ����������������
\ �������. ���� #2 ����� ���� �������������� �������.
: >NUMBER ( ud1 asc1 #1 --> ud2 asc2 #2 )
          BEGIN DUP WHILE               \ ���� �� ����� ������
            OVER C@ BASE @ DIGIT WHILE  \ �� ������ ��������������� �����
            -ROT SKIP1 2>R CIPHER 2R>   \ �������� �����
           REPEAT
          THEN ;

\ ���������� ����� ��������� ����� � ���� ������ �� ��������� � �������
\ ������� ����������, ���� � �����������������, ���� ���� ������� '0x'
: VAL ( asc # --> n )
      BASE @ >R
       OVER C@ [CHAR] - = DUP >R IF SKIP1 THEN
       OVER W@ [ S" 0x" DROP W@ ] LITERAL = IF SKIP1 SKIP1 HEX THEN
       0 0 2SWAP >NUMBER IF -1 THROW THEN DROP D>S
       R> IF NEGATE THEN
      R> BASE ! ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{  : CHAR" CHAR ;
       CHAR" / >CIPHER -1 <> THROW  CHAR" 0 >CIPHER  0 <> THROW
       CHAR" 9 >CIPHER  9 <> THROW  CHAR" : >CIPHER -1 <> THROW
       CHAR" A >CIPHER 10 <> THROW  CHAR" a >CIPHER 10 <> THROW
       CHAR" Z >CIPHER 35 <> THROW  CHAR" z >CIPHER 35 <> THROW
       CHAR" [ >CIPHER -1 <> THROW  CHAR" � >CIPHER -1 <> THROW

      0 0 S" 123" >NUMBER 0<> THROW DROP D>S 123 <> THROW
  S" passed" TYPE
}test
