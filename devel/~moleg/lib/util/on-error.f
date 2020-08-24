\ 20-04-2007 ~mOleg ��� SPF4.18
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ��������� ����������� ������.

\    ������ ���������� ��������� ������������ �������� ������������,
\ �� ���� � ������ ������ ��������� ����� ������������, ��������,
\ ���������� ����������, ��������, ������� �������, ������� ��������
\ ���� � ���� �������� ���� � ��� ���� ��� ������� �����������
\ ��������������� CATCH THROW ����������...

 REQUIRE ADDR     devel\~moleg\lib\util\addr.f

\ ---------------------------------------------------------------------------

        \ ���������� ��������� ������������ �� ����� ���������.
        0x20 VALUE #err-handlers

  \ ������� ���� ������
  USER-CREATE ERRORS  #err-handlers CELLS USER-ALLOT

  \ ��������� �� ������� ������
  USER-VALUE cur-err-h

\ ��� ������ ��� ����������� ������������� �� ����� � �����������.
\ � ����� ���� ����� ������������ ������ ��������� ����������� �������
\ ����������.

\ ������� ���������� ������ �������� �� ������ addr
: err-handler ( --> addr ) cur-err-h ADDR * ERRORS + ;

\ ���������� ������� � ������� ������ ������������
: ON-ERROR   ( 'cfa --> )
             cur-err-h 1 + #err-handlers MIN TO cur-err-h
             err-handler A! ;

\ ���������� ���������� �� �����
\ ����� ������ ���������� �� ������������� �������
: EXIT-ERROR ( --> ) cur-err-h 1 - 0 MAX TO cur-err-h ;

\ ��� ������������� ������ �� ���� ���������� �������� ��������������
\ ������� ������������.
: IS-ERROR ( err-num --> )
           BEGIN cur-err-h WHILE
                 err-handler A@ EXECUTE
               EXIT-ERROR
           REPEAT
           err-handler A@ EXECUTE ;

\ ��������� ����������� - ������ ����������� ���� ��� �� �����:
        ' ERROR2 err-handler !
        ' IS-ERROR TO ERROR

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ : sample DROP BYE ;
      : simple S" passed" TYPE CR ;
      : error CR S" can't perform EXIT-ERROR" TYPE ;
      ' sample ON-ERROR
      ' simple ON-ERROR
      ' error ON-ERROR
      EXIT-ERROR
      alskjfl   \ ��� ������
}test

\EOF -- �������� ������ -----------------------------------------------------

: 3st-err ." first error handler: " ." error number - " DUP . CR ;
: 2st-err ." second error handler " CR ;
: 1st-err DROP FORTH_ERROR ; \ ���, ����� ������� �� �������� �� ������.

' 1st-err ON-ERROR
' 2st-err ON-ERROR
' 3st-err ON-ERROR

 adfasdf  \ ��� ������ 8)
\ ����� ��������� ������ � ����� ������������ �������� ���� ���� ���������




