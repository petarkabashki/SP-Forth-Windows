\ 30-11-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������� � �������� �� ������ http://fforum.winglion.ru/viewtopic.php?t=1048

 REQUIRE >CIPHER   devel\~moleg\lib\parsing\number.f
 REQUIRE cmdline>  devel\~mOleg\lib\util\parser.f
 REQUIRE SPELLS    devel\~moleg\lib\util\spells.f
 REQUIRE s"        devel\~moleg\lib\strings\string.f
 REQUIRE onward    devel\~moleg\lib\strings\subst.f
 REQUIRE xWord     devel\~moleg\lib\parsing\xWordn.f

      0 VALUE sourceid   \ id ����� ���������
      0 VALUE 'source
      0 VALUE #source
      0 VALUE collector  \ id ����� ���������
      0 VALUE colbuf
      0 VALUE ^collector

\ ������ �� �������������
SPELL: /? ( --> )
          s" \tusage: transttf.exe test.ttf [test2.bin]\n\r" TYPE
          BYE ;S

\ ������ ���. ������, �������� ������
SECRET: NOTFOUND ( asc # --> )
                 <back ParseFileName 2DUP FILE-EXIST
                 IFNOT ." \tInvalid source file: " TYPE CR BYE THEN
                 2DUP R/O OPEN-FILE IF ." \tCan't open source file: " TYPE CR EXIT THEN
                 TO sourceid
                 SeeForw NIP IF 2DROP ParseFileName
                              ELSE S" *.bin" onward
                             THEN 2DUP
                 W/O CREATE-FILE IF ." \tCan't create result file: " TYPE CR EXIT THEN
                 TO collector 2DROP
                 [COMPILE] \ ;S

\ ������ ���� �������� � ������.
: ReadSource ( --> )
             sourceid FILE-SIZE 2DROP \ �������, ��� ������ ����� ������ 4 G
             DUP TO #source
             ALLOCATE THROW TO 'source \ ������� ��� ����������
             'source #source sourceid READ-FILE THROW
             #source <> THROW ;

\ �������� ����� ��� �������������� ������
: InitReceiver ( --> )
               #source 2/ ALLOCATE THROW DUP TO colbuf TO ^collector
               ;

\ ��������� ���������
: SaveBuf ( --> ) colbuf ^collector OVER - collector WRITE-FILE THROW ;


 s" \000\t\n\r, " Delimiter: delimiters

\ �������������� ��������� ������
: Transform ( --> )
            'source #source SOURCE!
            BEGIN EndOfChunk WHILENOT

               BEGIN delimiters xWord DUP WHILENOT
                     2DROP EndOfChunk WHILENOT
                     >IN 1+!
                 REPEAT EXIT
               THEN

               0 0 2SWAP >NUMBER IF -1 THROW ELSE 2DROP THEN
               ^collector TUCK B! 1 + TO ^collector

            REPEAT ;

\ ������� ����� ���������
: transttf ( --> )
           options
           sourceid IFNOT [ ALSO SPELLS ] /? [ PREVIOUS ] BYE THEN
           ReadSource  InitReceiver  Transform  SaveBuf
           sourceid CLOSE-FILE DROP collector CLOSE-FILE DROP
           BYE ;

\ ���������� ���������� � ��������� ����:

' transttf MAINX !

S" transttf.exe" SAVE



