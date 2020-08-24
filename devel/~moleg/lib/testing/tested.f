\ 06-06-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ����������� ���������� � ������ ������������
\ � �������������� ��������� ��������� ������������ � �������
\ ����� ����������� ��������� ����������.

 REQUIRE ?DEFINED  devel\~moleg\lib\util\ifdef.f
 REQUIRE MARKERS   devel\~mOleg\lib\util\marks.f
 REQUIRE TILL      devel\~mOleg\lib\util\for-next.f

\ ��������� ������ asc # �� u �������� �� ������
: SKIPn ( asc # u --> asc+u #-u ) OVER MIN TUCK - >R + R> ;

\ ����������� ������ � ���� ������� l ��������,
\ ���� ������ ������� l, �������� ����� ������ ������ � l ��������
: TYPE] ( asc # l --> )
        2DUP >
        IF OVER SWAP - SKIPn TYPE
         ELSE OVER - 0 MAX >R TYPE R> SPACES
        THEN ;

\ ������� FALSE ���� ���������� �������� ��� ����� �� �����
: cmparr ( [a1] # [a2] # --> flag )
         SP@ OVER 1 + CELLS 2DUP 2>R +
         2R> TUCK COMPARE 0= ;

FALSE WARNING ! \ -----------------------------------------------------------

        USER TESTING      \ ��������� ������ ������������

\ ���������������� ��������� ����, ���� � ��������� �� ������� ����� key
\ ����� ������������ ������������ ��� ���� ��������� ������.
: REQUIRE ( / key file --> )
          FALSE TESTING change >R
                REQUIRE
          R> TESTING ! ;

\ ���������������� ����, ��� �������� ���������������� ������� ascZ #
\ ����� ������������ ������������ ��� ���� ��������� ������
: INCLUDED ( ascZ # --> )
           FALSE TESTING change >R
                 INCLUDED
           R> TESTING ! ;

\ ���������� ���������� ���� � ������ ������������
: (TESTED) ( asc # --> flag )
           TRUE TESTING !
           CR ." Testing: " 2DUP 0x46 OVER - 0 MAX TYPE]
           ['] (INCLUDED) CATCH
           DUP IF CR ."          can't compile library"
                  CR ERR-STRING TYPE CR
               THEN ;

        USER last-base    \ ���������� ��� �������� ��������� ��������� BASE
        USER last-current \ ���������� ��� �������� ��������� CURRENT
        USER last-context \ ��������� �� ����� ���������

\ ���������, ���� �� ��������� �� ������� ����� ������
: ?DepthChanges ( ?? )
          TestMoment
          IFNOT CR    ."          stack leaking"
                ValidMark
                IF CR ."          superfluous values: "
                   CountToMark .SN ClearToMark
                 ELSE
                   CR ."          stack underflow for "
                   ForgetMark CountToMark 10 SWAP - . ." cells"
                THEN ClearToMark
            RDROP EXIT
          THEN ForgetMark ;

\ ��������� ��������� ������� ������� ����������
: ?base ( --> )
        BASE @ last-base @ <>
        IF 0 last-base change BASE !
           CR S"          BASE changed" TYPE
        THEN ;

\ ������� �� ������� �������?
: ?current ( --> )
           GET-CURRENT last-current @ <>
           IF last-current @ SET-CURRENT
              CR S"          CURRENT changed" TYPE
           THEN ;

\ ��� �� ����� � ������������ ����� ���������
: ?state ( --> )
         STATE @
         IF FALSE STATE !
            CR S"          STATE was ON" TYPE
         THEN ;

\ ���� �� ��������� � ���������
: ?context ( --> )
           GET-ORDER last-context @ GetFrom cmparr
           IFNOT CR S"          CONTEXT was changed" TYPE
                 SET-ORDER
            ELSE nDROP
           THEN nDROP
           last-context @ KillStack ;

\ ������ ��� ������������
: TestArray ( --> [arr] # ) 10 FOR R@ TILL ;

\ ���������, ���� �� ��������� ��� �������� ����� ������
: ?InternalCanges ( ?? )
                  CountToMark MarkMoment TestArray CountToMark cmparr
                  IFNOT ClearToMark CR S"          " TYPE .SN ."  <--"
                   ELSE ClearToMark
                  THEN ;

\ ���������� ��������� ���� � ������ ������������
: TESTED  ( ascZ # --> )
          last-base @ IF CR ." nested testing unsupported" -1 THROW THEN

          BASE @ last-base !          \ ��������� ������� ������� ����������
          GET-CURRENT last-current !  \ ��������� ������� �������

          \ ��������� ������� ��������
          GET-ORDER 0x10 NewStack DUP last-context ! MoveTo

          \ ��������� ������� ��������� ������� ����� ������
          2>R  init-markers MarkMoment

          \ �������� 10 ����� �� 1 �� 10 �� ������� ����� ������,
          \ ��������� ������� �������
          TestArray MarkMoment

          \ ���������� ����������� ����
          2R> (TESTED)
          IF \ ���� ������, ��������������� ���:
             0 last-base change BASE !     \ ������� ����������
             last-current @ SET-CURRENT    \ ������� �������
             FALSE STATE !                 \ ����� �������������
             ForgetMark ClearToMark        \ ������ ���� ������
                                           \ ��������������� ��������
             last-context @ DUP GetFrom SET-ORDER
                            KillStack      \ ������� ��������� ����
            EXIT  \ � �������. ��������������� HERE �� ����� ������
          THEN

          ?base
          ?current
          ?context
          ?state
          ?DepthChanges
          ?InternalCanges ClearToMark

          ."  passed" ;

TRUE WARNING ! \ ------------------------------------------------------------

?DEFINED test{ \EOF

test{ \ ������ ���� �� ��������������.
  S" passed" TYPE
}test \EOF











