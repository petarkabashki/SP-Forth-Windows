\ 10-04-2007 ~mOleg
\ Copyright [C] 2006-2007 mOleg mininoleg@yahoo.com
\ ������ ����� ������� ��������� �����.

VOCABULARY process
           ALSO process DEFINITIONS

      \ � �� ����� NOTFOUND, �� � ������ ������� �� ������.
      : NOTFOUND ( asc # --> ) 2DROP
                 0 >IN !
                 0x0D PARSE
                 TYPE CR ;

PREVIOUS DEFINITIONS

\ ��-��������� ��������� � STDLOG
: sample ( srcZ # --> )
         ONLY process
         GetCommandLineA ASCIIZ> SOURCE! NextWord 2DROP
         NextWord INCLUDED
         KEY DROP BYE ;

' sample MAINX !

S" sample.exe" SAVE CR S" passed " CR BYE

\ ������ �������������:
\ sample file.name >result.file

\ �������� ����������� ������������������ ������ 0x0D 0x0D 0x0A
\ �� �������� � ������ �� ( ��� win ��������� 0x0D 0x0A ��� linux - 0x0A )
\ ������ ������ ���������.
