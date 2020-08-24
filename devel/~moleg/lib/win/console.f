\ 08-12-2007 ~mOleg
\ �opyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������ � ��������: page setxy getxy screen# ~chars

 REQUIRE ?DEFINED     devel\~moleg\lib\util\ifdef.f
 REQUIRE THIS         devel\~moleg\lib\util\useful.f

?DEFINED GetConsoleScreenBufferInfo  WINAPI: GetConsoleScreenBufferInfo  kernel32.dll
?DEFINED SetConsoleCursorPosition    WINAPI: SetConsoleCursorPosition    kernel32.dll
?DEFINED FillConsoleOutputCharacterA WINAPI: FillConsoleOutputCharacterA kernel32.dll
?DEFINED SetConsoleTitleA            WINAPI: SetConsoleTitleA            kernel32.dll

VOCABULARY Console
           ALSO Console DEFINITIONS

 0 2 -- off_x
   2 -- off_y
   CONSTANT /coord

 0 2 -- Left
   2 -- Top
   2 -- Right
   2 -- Bottom
   CONSTANT /rect

 0 /coord -- Size
   /coord -- Position
        2 -- Attrib
   /rect  -- Window
   /coord -- Dimensions
   CONSTANT /buffer

CREATE buffer /buffer ALLOT

\ ������� ���������� ���� coord
: xy@ ( addr --> x y ) DUP off_x W@ SWAP off_y W@ ;

ALSO FORTH THIS

\ �������� ������� ��������� �������
: getxy ( --> x y )
        buffer H-STDOUT GetConsoleScreenBufferInfo DROP
        buffer Position xy@ ;

\ ���������� ������ � ��������� �������
: setxy ( x y --> )
        16 LSHIFT OR H-STDOUT SetConsoleCursorPosition DROP ;

\ �������� ������� �������
: screen# ( --> x y )
          buffer H-STDOUT GetConsoleScreenBufferInfo DROP
          buffer Dimensions xy@ ;

\ ������� # ������� char ������� � ������� �������
\ ������� ������� �� ���������.
: ~chars ( char # --> )
         SP@ getxy 16 LSHIFT OR 2SWAP SWAP H-STDOUT
         FillConsoleOutputCharacterA DROP ;

\ �������� ���������� ������
: page ( --> ) 0 0 setxy BL screen# * ~chars ;

\ ���������� �������� ����
: ~title ( asc # --> ) DROP SetConsoleTitleA DROP ;

RECENT

?DEFINED test{ \EOF -- �������� ������ ---------------------------------------

test{ getxy * 0 < THROW
      screen# * getxy * < THROW
  S" passed" TYPE
}test
