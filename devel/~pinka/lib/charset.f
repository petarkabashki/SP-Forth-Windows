\ <INTRODUCTION>
\ ��������� ��������
\ ver 0.2 ( 27.04.2000)

\ (c) 1999-2000 Ruvim Pinka
\ </INTRODUCTION>

\ <HISTORY>
\ 09.04.99�. 04:36:16 - �������.
\   ... ��� ��� ���������
\ 03.01.2000
\   �������� ��������.
\ 27.04.2000
\   ������ ��������� ��� ( addr value )
\   ��������, ������ ������ �� �������� �� ������� !  +!  ( value addr )
\ </HISTORY>

\ <BODY>

REQUIRE CREATED  ~pinka\lib\EXT_my.f 


\ 256 ��� = 8 ��� * 32  = 32 �����
\    = 32 bit * 8 = 8 cells
32 CONSTANT /set


: created-set  ( a u  -- )
    CREATED    HERE  /set ALLOT  /set ERASE
;

: create-set ( -- )  \ name
\ ������� ������ ��������� � �������
    NextWord  created-set
;

\ ����������� ������� ������ ���������. ������������ �� FREE
: new-set ( -- a-set )
    /set ALLOCATE THROW  DUP /set ERASE
;


\  /MOD ( ������� �������� -- ������� ������� )

: getmask ( char a-set -- a-byte byte-mask )
    >R  8 /MOD R> +  SWAP ( a-byte bits-offs )
    1 SWAP LSHIFT
;

\ ��������� �������
: belong ( char a-set -- f )
    getmask  >R  C@ R@ AND  R> =
;
\ �������� �������
: set+   ( char a-set -- )
    getmask  SWAP DUP >R C@  OR  R> C!
;
\ ��������� �������
: set-   ( char a-set -- )
    getmask 255 XOR    SWAP DUP >R C@ AND R> C!
;

\ �������� ��� ������� �� �������� ������ �� ���������
: set-str+  ( addr u  a-set -- )
    >R
    OVER +  SWAP ( a2 a1 )
    BEGIN
        2DUP <> 
    WHILE
        DUP C@ R@ set+  1+
    REPEAT 2DROP RDROP
;

: set. ( a-set -- )
    256 0 DO  I OVER belong IF  I EMIT THEN LOOP DROP
;

\ </BODY>
