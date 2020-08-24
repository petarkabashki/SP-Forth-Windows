\ 25-08-2006 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ��������� (�� �������� � .\description)

 REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f

        VOCABULARY msg
                        ALSO msg DEFINITIONS

        0 VALUE handle

\ ��� ��������� � ���� ������ -----------------------------------------------

\ �� ��������� ��� ��������� �� �����
:NONAME TYPE CR ;  ->VECT ~msg
\ �� ��������� �������� ������� �� ��������������
:NONAME ."  press a key" KEY DROP ; ->VECT mwait
\ ��� �������� �������� �����
:NONAME S" .\message." ; ->VECT file

\ ---------------------------------------------------------------------------

\ �������� ����� ������������ ����� PAD
: temp PAD 0x200 ;

\ ����������� ��������� ������� � �����
: goto   ( d --> ) handle REPOSITION-FILE THROW ;
: go-up  ( --> ) 0 0 goto ;
: go-end ( --> ) handle FILE-SIZE THROW goto ;

\ ������ � ��������
: write ( asc # --> ) handle WRITE-LINE THROW ;
: read  ( --> asc # flag ) temp OVER SWAP handle READ-LINE THROW ;

\ ����� ����� � file
: count ( --> n ) go-up 0 BEGIN read WHILE 2DROP 1+ REPEAT 2DROP ;

\ ������� ��������� �� ����� � ������� n
\ ���� ��������� � ����� ������� ���, ������� ������ � ������� ������
: nfind ( n --> asc # )
        go-up
        BEGIN DUP WHILE
              read WHILE
              2DROP
           1-
         REPEAT <# #S S" message = " HOLDS #> EXIT
        THEN DROP read DROP ;

\ �������� ����� ��������� � ����� ������,
\ ������� ���������� ����� ���������
: new ( asc # --> n ) count -ROT write ;

\ ������������� ������ ������
: init  ( --> )
        file FILE-EXIST
        IF file R/W OPEN-FILE
         ELSE file R/W CREATE-FILE
        THEN THROW TO handle ;

\ ����� ����������� ������ � �����
: search ( asc # --> n true | asc # false )
         handle IF ELSE init THEN

         go-up 0 >R
         BEGIN read WHILE
               2OVER COMPARE WHILE
               R> 1+ >R
          REPEAT 2DROP R> TRUE EXIT
         THEN RDROP 2DROP FALSE ;

\ ������� ����� ���������
: add ( asc # --> n | false ) search IF EXIT ELSE new THEN ;

\ �������� ��������� �� ������ ����������� ������
: emsg   ER-U ! ER-A ! -2 THROW ;

\ ---------------------------------------------------------------------------

PREVIOUS DEFINITIONS

ALSO msg

: Error" [CHAR] " PARSE add
         POSTPONE LITERAL  POSTPONE nfind POSTPONE emsg
       ; IMMEDIATE

: ?Error"
         [COMPILE] IF
         [CHAR] " PARSE add
         POSTPONE LITERAL  POSTPONE nfind POSTPONE emsg
         [COMPILE] THEN
       ; IMMEDIATE


\ ������ ������� ���������
: Message" [CHAR] " PARSE add
           POSTPONE LITERAL POSTPONE nfind
           POSTPONE ~msg
           ; IMMEDIATE

\ ������� ��������� � ��������� �������
: Warning" [CHAR] " PARSE add
           POSTPONE LITERAL  POSTPONE nfind
           POSTPONE ~msg POSTPONE mwait
           ; IMMEDIATE

PREVIOUS

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ���� ������ ���� �� ��������������.
  S" passed" TYPE
}test

\EOF �������� ������ --------------------------------------------------------

: mes ONLY FORTH ALSO msg DEFINITIONS ;

: tst0 Message" message number one" ;
: tst1 Warning" warning number two" ;
: tst2 Error" error number three" ;
: tst3 Error" message number one" ;

\EOF ------------------------------------------------------------------------
