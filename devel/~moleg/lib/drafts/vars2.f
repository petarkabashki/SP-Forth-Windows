\ 28-11-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ���������, vect � value ����������, ������ � ����.
\ ������ �������.

 REQUIRE [IF]     lib\include\tools.f
 REQUIRE PERFORM  devel\~moleg\lib\util\useful.f
 REQUIRE COMPILE  devel\~moleg\lib\util\compile.f
 REQUIRE ADDR     devel\~moleg\lib\util\addr.f

\ �������� ������ �� VARIABLE ���������� ����� � ��� �������������
\ ������� �������� ����������, �� ��� ���� CFA ����� ������ ��� �����
: VARIABLE ( / NAME --> )
          CREATE 0 , IMMEDIATE
          DOES> STATE @ IF [COMPILE] LITERAL THEN ;

\ �������� ��������� ������������� � ��� ��� �������!
\ ��� ������, ��� ��������� �������� ��������� ������
: CONSTANT ( n / name --> )
           CREATE , IMMEDIATE
           DOES> @  STATE @ IF [COMPILE] LITERAL THEN ;

\ �������� ������������ tls ������������� ����� � ��� �����
: USER ( / name --> )
       CREATE USER-HERE , CELL USER-ALLOT IMMEDIATE
       DOES> @  STATE @ IF 0x8D C, 0x6D C, 0xFC C,   \ dpush tos
                           0x89 C,  0x45 C, 0x00 C,
                           0x8D C, 0x87 C, ,         \ lea eax, [tls] # udisp
                         ELSE TlsIndex@ +
                        THEN ;

\ ���������� - ��������.
: VALUE ( n / name --> )
        CREATE , IMMEDIATE
        DOES> STATE @ IF LIT, COMPILE @
                       ELSE @
                      THEN ;

\ ������� ����������-�������� � ���������������� ������� ��������
: USER-VALUE ( / name --> )
             CREATE USER-HERE , CELL USER-ALLOT IMMEDIATE
             DOES> @  STATE @ IF 0x8D C, 0x6D C, 0xFC C,   \ dpush tos
                                 0x89 C, 0x45 C, 0x00 C,
                                 0x8D C, 0x97 C, ,         \ lea addr, [tls] + udisp
                                 0x8B C, 0x02 C,           \ mov eax , [addr]
                               ELSE TlsIndex@ + @
                              THEN ;

\ ������� �����, �������� ����� �����, ������� ����� ����
\ ��������� ��� ���������� name. ����� ����� ���� �������
\ � ������� ����� IS
: VECT ( / name --> )
       CREATE ['] NOOP A,
       DOES> STATE @ IF LIT, COMPILE PERFORM
                      ELSE PERFORM
                     THEN ;

\ �������, ������������� �������� ������
: USER-VECT ( / name --> )
            CREATE USER-HERE , ADDR USER-ALLOT IMMEDIATE
            DOES> @  STATE @ IF 0x8D C, 0x97 C, , \ LEA addr , [tls] + disp
                                0xFF C, 0x12 C,   \ CALL [addr]
                              ELSE TlsIndex@ + PERFORM
                             THEN ;

\ ����� ��������� ���������� ��� ���������� (��� TO � IS)
VECT _vcsmpl USER-VECT _uvcsmpl 0 VALUE _vlsmpl USER-VALUE _uvlsmpl

\ ��������� ����� ���� USER-VECT ����������
: (uisvect) ( addr / name --> )
            CFL + @
            STATE @ IF 0x8D C, 0x97 C, ,
                       0x89 C, 0x02 C,         \ MOV [addr] , tos
                       0x8B C, 0x45 C, 0x00 C,
                       0x8D C, 0x6D C, 0x04 C, \ drop
                     ELSE TlsIndex@ + A!
                    THEN ;

\ �������� ���������� ���������� - �������
: (isvect) ( addr / name --> )
           CFL +
           STATE @ IF LIT, COMPILE A!
                    ELSE A!
                   THEN ;

\ �������� �������� VALUE ����������
: (tovalue) ( n addr --> )
     CFL +
     STATE @ IF LIT, COMPILE !
              ELSE !
             THEN ;

\ ��������� �������� USER-VALUE ����������
: (touvalue) ( n addr --> )
      CFL + @
      STATE @ IF 0x8D C, 0x97 C, ,
                 0x89 C, 0x02 C,
                 0x8B C, 0x45 C, 0x00 C,
                 0x8D C, 0x6D C, 0x04 C,
                ELSE TlsIndex@ + !
               THEN ;

\ ����� ����� ������ ����� �� ������ �� CFA �� ����
: raddr ( ' --> addr ) DUP 1+ @ + ;

\ ����� IS ������� � � USER-VECT � c VECT �����������
: IS ( addr / name --> )
     ' DUP raddr
     [ ' _vcsmpl raddr  ] LITERAL OVER = IF DROP (isvect) EXIT THEN
     [ ' _uvcsmpl raddr ] LITERAL      = IF (uisvect) EXIT THEN
     ." ��������� ����� �� �������� ��������!" CR -1 THROW ; IMMEDIATE

\ ��������� �������� VALUE USER-VALUE VECT ��� USER-VECT ����������
: TO ( n / name --> )
     ' DUP raddr
     [ ' _vlsmpl  raddr ] LITERAL OVER = IF DROP (tovalue) EXIT THEN
     [ ' _uvlsmpl raddr ] LITERAL OVER = IF DROP (touvalue) EXIT THEN
     [ ' _vcsmpl  raddr ] LITERAL OVER = IF DROP (isvect) EXIT THEN
     [ ' _uvcsmpl raddr ] LITERAL      = IF DROP (uisvect) EXIT THEN
     9 + STATE @ IF COMPILE, ELSE EXECUTE THEN ; IMMEDIATE

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ \ ��� ������ �������� �� ������������.
  S" passed" TYPE
}test
