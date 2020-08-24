\ 10-04-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������ � ���������� ��������� � ����� ������.

 REQUIRE FRAME       devel\~moleg\lib\util\stackadd.f
 REQUIRE WHILENOT    devel\~moleg\lib\util\ifnot.f

\ �������� �� ����� ����� ��� ������ ��� �������������
: array ( # --> [array] # ) FRAME ;

\ �������� ����� ������ ������� � ��� ������
: get-array ( [array] # --> [array] # addr #bytes )
            >R SP@ R> SWAP OVER CELLS ;

\ �������� ����� ��� ������ �� ����� ������, ��������� ������������ ������
: 0array ( # --> [000] # ) array get-array ERASE ;

\ ������� ������ ������ � ����������
: dismiss ( [array] # --> ) get-array + SP! ;

\ ������� ����� �������
: reply ( [array] # --> [array] # [array] # )
        get-array >R >R DUP array
        get-array DROP R> SWAP R>
        MOVE ;

\ ���������� ��������� ������� � ����
: combine ( [arr] m [ay] n --> [array] m+n )
          get-array 2DUP + @ >R OVER CELL + SWAP CMOVE> R> + NIP ;

\ ������� ���� ������ �� ���.
\ ���� n ������ m ����� ������� ��� �������:
\ ���� ������� ������, ������ ������ ����� �������������.
: break ( [array] m n --> [arr] m-n [ay] n )
        OVER UMIN 2DUP - >R >R
        get-array DROP DUP CELL - R@ CELLS MOVE
        R> get-array + R> SWAP ! ;

\ ���������� ������ � ������ ������ �� ���������
: move-to ( [array] # addr --> )
          >R get-array CELL + SWAP CELL - SWAP R> SWAP MOVE dismiss ;

\ ���������� ������ �� ������ �� ���� ������
: get-from ( addr --> [array] # )
           DUP >R @ array get-array R> CELL + -ROT MOVE ;

\ �������� ������� � ��������� ������� �� �������
\ �������� ������ �� ������ ������� �� ������������.
\ ������� ���������� � 0
: [i]@ ( [array] # i --> [array] # n ) 1 + PICK ;

\ ��������� �������� n � ������ array � ������� � �������� i
\ �������� ������ �� ������ ������� �� ������������
\ ������� ���������� � 0
: [i]! ( [array] # n i --> [array] # ) 1 + CELLS 2>R SP@ R> + R> SWAP ! ;

\ ������� FALSE ���� ���������� �������� ��� ����� �� �����
: cmparr ( [a1] # [a2] # --> flag )
         SP@ OVER 1 + CELLS 2DUP 2>R +
         2R> TUCK COMPARE 0= ;

\ ������� �������� �, ���� ��� ������������ � ������ [ a b c .. ]
: anyof ( [ a b c .. ] # x --> x | false )
        >R BEGIN DUP WHILE 1 -
                 SWAP R@ = WHILENOT
             REPEAT nDROP R> EXIT
           THEN RDROP ;

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ �������� �����������

  S" passed" TYPE
}test
\EOF -- �������� ������ ------------------------------------------------------

1 CHARS CONSTANT char

\ ������������� ������ � ������
: s>arr ( asc # --> [a s c] # )
        OVER + 2>R
        0 BEGIN 2R@ <> WHILE
                1 + R> char - DUP >R C@ SWAP
          REPEAT RDROP RDROP ;

\ ����������� ���������� ������� ��� ������
: .array ( [arr] # --> ) 0 ?DO EMIT LOOP ;

\ ��� ������� ������:
CR S" sample text" s>arr .array
CR S" sample" s>arr S" text " s>arr combine .array
CR S" sample text" s>arr 7 break .array CR .array
CR S" sample " s>arr reply combine .array
CR S" sample text" s>arr 7 break dismiss .array
   S" sample text" s>arr HERE move-to HERE DUP @ CELLS DUMP
CR HERE get-from .array
CR S" sample" s>arr 51 3 [i]! 48 0 [i]! .array
CR mark 57 56 55 54 53 52 51 50 49 countto .array
