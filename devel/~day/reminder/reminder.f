\ (c) Dmitry Yakimov aka DAY 20.03.2000
\ ������� ������������ ����, ��� ��� ������.
\ ������������� �������� � ������������

REQUIRE TIME&DATE lib\include\facil.f

WINAPI: MessageBoxA USER32.DLL
HEX
 00001000 CONSTANT MB_SYSTEMMODAL
DECIMAL 
 
\ ������� ������� ����� ��� �������� �� 22:00
\ ������� ����� ����� ��� ����� ��������� ���������

22 CONSTANT Hours
00 CONSTANT Minutes
 5 CONSTANT �����  \ � �������
        
: ShowMessage ( addr u -- )
   DROP >R MB_SYSTEMMODAL S" ��� ��������� :)" DROP R>  0 MessageBoxA DROP
;

: ���������
   S" ����� ������ ������ ��������!"
   ShowMessage
;

: OneMore
   S" � ����������� ���������� ����� �� ������������� :)"
   ShowMessage
;

: ����������
    0 Minutes Hours
    60 * + 60 * +
;

: ����������� ( -- sec )
    TIME&DATE 2DROP DROP
    60 * + 60 * +
;

VARIABLE Kind

: Remind
   BEGIN
     ����� 60000 * Sleep
     ���������� ����������� - 
     DUP 0 < IF Kind @
                IF OneMore Kind 0!
                ELSE ��������� Kind 1+!
                THEN
             THEN
   AGAIN
;

   HERE IMAGE-BASE - 10000 + TO IMAGE-SIZE
   TRUE  TO ?GUI
    FALSE TO ?CONSOLE
     ' Remind MAINX !
        S" reminder.exe" SAVE
         BYE

