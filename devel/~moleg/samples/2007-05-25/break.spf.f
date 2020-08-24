\ 25-05-2007 ~mOleg
\ Copyright [C] 2007 mOleg mininoleg@yahoo.com
\ ������� ������ � �������� ��������� �� ������
\ ��������� ����������� ������� ��������� ���� �� ���������
\ ������� ��� ���4.18

  REQUIRE ?DEFINED devel\~moleg\lib\util\ifdef.f
  REQUIRE s"       devel\~moleg\lib\strings\string.f
  REQUIRE onward   devel\~moleg\lib\strings\subst.f
  REQUIRE RECENT   devel\~moleg\lib\util\useful.f

\ ���������� SOURCE �� ������ ���������� �
: cmdline> ( --> )
           -1 TO SOURCE-ID
           GetCommandLineA ASCIIZ> SOURCE!
           ParseFileName 2DROP ;

\ ������������� ������� ����� �� ������� ���������
: D, ( d --> ) HERE 2 CELLS ALLOT 2! ;

\ ������� ���������� ���������� ��� �������� �������� �����
: dVar ( / name --> ) CREATE 0 0 D, DOES> ;

        VARIABLE ResultFile# \ ������ ��������������� ����� � ������
        VARIABLE parts       \ ���������� ������, �� ������� ���� ������� ����

\ ������������� ��������� ����� �������� � ���-�� ����
: kBytes ( u --> d ) 1024 * ;

\ ������������� ��������� ����� �������� � ���-�� ����
: mBytes ( n --> d ) kBytes kBytes ;

 64 kBytes ResultFile# !  \ ����������������� ������ 64 ��

        VECT ?waiting
: BYE ?waiting BYE ;

\ ������������ ������ ��������������� ����� �� ����� ��������� 4G

        VARIABLE b|n

\ ��� ������� �������� �����?
: ?alone ( --> )
         b|n @ IF ." Must be only one spell: -n or -b\n\r" BYE
                ELSE TRUE b|n !
               THEN ;

\ ������������� �����
: ?numb ( / numb --> d )
        0 0 NextWord >NUMBER IF ." \n\r Invaid number." BYE THEN DROP D>S ;

      0 VALUE SourceFile \ ��� ��������� �����
      0 VALUE FileMask   \ �����
      0 VALUE Prototype \ ��������� �������������� ����� ����� � ������� �����

\ ��������� ������ � ����, ������� ����� ������
: SaveString  ( asc # --> addr )
              DUP CELL + char + ALLOCATE THROW
              2DUP ! DUP >R CELL + SWAP 2DUP
              2>R CMOVE 2R> + 0 SWAP C! R> ;

\ �� ������ ������ �������� �� ������ � ������
: string> ( addr --> asc # ) DUP CELL + SWAP @ ;

\ �������� >IN �����, �� ������ ���������� �����
: <back ( ASC # --> ) DROP TIB - >IN ! ;

   TRUE VALUE part-name-add  \ ��������� �� ��� ����� � ������ �����

\ ���� �������� ��������� 8)
\ ������-�� �� ������������ ����.
CREATE s-progress S"  ���oO0Oo��" S",   VARIABLE iter
: ~progress ( --> )
            s-progress COUNT iter @ SWAP MOD + C@ EMIT 0x08 EMIT
            1 iter +! ;

\ -- ����� ��������� ������ --------------------------------------------------

\ ��� �� ������, ���� ��� ����� �� ���������� ������ -s
VOCABULARY expand
           ALSO expand DEFINITIONS

\ ������� ������ ����������, ��� ��� �����.
: NOTFOUND ( asc # --> )
           OVER C@ [CHAR] " =
           IF <back ParseFileName THEN

           SeeForw NIP IF ." \n\rInvalid option: " TYPE BYE THEN
           SourceFile IF ." \n\rSuperfluous parameter: " TYPE BYE THEN
           SaveString TO SourceFile ;
RECENT

VOCABULARY COMMANDS
           ALSO COMMANDS DEFINITIONS

  \ ��������� - ���� ����������� � ��������� ������ - ���������� ���������
  \ �����������, ��������� ������
  : -h ( --> )
       ." \r command line options are:"
       ." \n\t -h & /h  this help"
       ." \n\t /? & -?  spell list"
       ." \n\t -b num   result file size specificator"
       ." \n\t -f mask  result files naming rules"
       ." \n\t -s file  source file name"
       ." \n\t -n num   result file count rules"
       ." \n\t -p       don't write part name at start of file"
       ." \n\nSample: break.exe -n 10 -f *##.* [-s] FileName"
       ;
  : /h ( --> ) -h ;

  \ ��������� �� ������
  : /? ( --> )
       ." \r spells are: "
       GET-ORDER SWAP NLIST BYE ;
  : -? /? ;

  \ ��������� ������ ������, �� ������� ���� ��������� ��������
  : -b  ( / numb --> ) ?alone ?numb ResultFile# ! ;
  : -kb ( / numb --> ) ?alone ?numb kBytes ResultFile# ! ;
  : -mb ( / numb --> ) ?alone ?numb mBytes ResultFile# ! ;

  \ �� ����� ���-�� ������ ���� ������� �������� ����
  : -n ( / numb --> ) ?alone ?numb parts ! ;

  \ ������� ���������� �������������� ������
  : -f ( / mask --> )
       FileMask IF FileMask FREE DROP THEN \ ���������� -f �� �����������
       ParseFileName SaveString TO FileMask ;

  \ ��� ��������� �����.
  : -s ( / filename --> )
       SourceFile IF SourceFile FREE DROP THEN \ ���������� -s �� �����������
       ParseFileName SaveString TO SourceFile ;

  \ ����� ��� ���������� ���������� ���� � ������ ������ �����
  : -p ( --> ) 0 TO part-name-add ;

RECENT

\ ----------------------------------------------------------------------------

\ ��������� ������� ��������� �����
: ?source ( --> flag )
          SourceFile DUP IFNOT ." \n\r source file missing." BYE THEN
          string> FILE-EXIST ;

      0 VALUE sourceId     \ �������� ��������� �����
        dVar  SourceFile#  \ ������ ��������� �����

\ ������� �������� ���� �� ������
: open-source ( --> )
              ?source IFNOT ." \n\rInvalid source file name: "
                            SourceFile string> ANSI>OEM TYPE BYE
                      THEN
              SourceFile string> R/O OPEN-FILE
              IF ." \n\r Can't open file." BYE THEN DUP TO sourceId
              FILE-SIZE THROW SourceFile# 2! ;

\ ������������ ��� ��������������� �����
: outname ( --> )
          SourceFile string> FileMask string>
          onward SaveString TO Prototype ;

        VARIABLE volume \ ����� �������� ����
      0 VALUE part#     \ ������ �������� ������������ �����

\ ������� ����� ���
: new-file ( --> handle )
           volume DUP @ SWAP 1+!
           Prototype string> ROT partnum
           2DUP 2>R W/O CREATE-FILE THROW
           part-name-add IF 2R@ DUP 2 CHARS + TO part#
                            ROT DUP >R WRITE-LINE THROW R>
                          ELSE 0 TO part#
                         THEN
           2R> ." \r In progress: " ANSI>OEM TYPE ;

\ ��������� ������ ����������� ����� ������ �� ���������� ������.
: measure ( --> )
          SourceFile# 2@ parts @ UM/MOD + DUP 100 / +
          ResultFile# ! ;

\ ������ �������� ������ ?
: ?eol ( addr --> flag ) C@ 0x0A = ;

\ ����� ��������� ������� ������ � ������
: ScanBack ( start end --> addr TRUE|FALSE )
           OVER UMAX
           BEGIN 2DUP <> WHILE
                 DUP ?eol WHILENOT
                 char -
              REPEAT NIP char + TRUE EXIT
           THEN 2DROP FALSE ;

      0 VALUE buffer   \ ����� ������ ���������� ������
      0 VALUE ^start   \ ����� ������
      0 VALUE ^end     \ ��������� �� ����� ������

\ ������� ����� � ����� ������� ����������� �������� ������
: _rest> ( --> asc # ) ^start ^end OVER - ;

\ �������� ������� ����������� ������ �� ����
: save-rest ( dest-id --> )
            >R _rest> TUCK
            IF OVER R> WRITE-FILE THROW
             ELSE R> 2DROP
            THEN part# + TO part# ;

\ ���������� ������ ������ ���� �������� ��� �� ����� �����
\ � �������� ����� �������� ������� �����, �� ���� 3G �����
\ �������� �� ��������� ��������...
100 kBytes CONSTANT buff-limit

\ ��������� ������� �����
: revive ( --> flag )
         ~progress
         buffer DUP TO ^start ResultFile# @ buff-limit UMIN
         sourceId READ-FILE THROW
         DUP buffer + TO ^end ;

\ ��������� ����, ������������ ������ �������� �������� ������.
: save-block ( file-id --> )
             >R ^start DUP ResultFile# @ part# - + char -
             2DUP ScanBack IF NIP THEN TO ^start
             ^start OVER - R> WRITE-FILE THROW ;

\ ��������� ������ � ����
: save-data ( dest-id --> flag )
            ResultFile# @ _rest> NIP - 100 <
            IF save-block TRUE EXIT THEN

            BEGIN DUP save-rest revive WHILE
                  _rest> NIP part# + ResultFile# @ < WHILE
              REPEAT save-block TRUE EXIT
            THEN save-rest FALSE ;

\ ������� ������ ��� �������������� �������� ������ �����
: arise ( # --> addr )
        ResultFile# @ buff-limit UMIN
        ALLOCATE THROW ;

\ �������� ���� ���������
: PROCESS-FILES ( --> )
                open-source
                 parts @ IF measure THEN
                 outname 1 volume !
                 arise TO buffer
                  BEGIN new-file DUP >R save-data WHILE
                        R> CLOSE-FILE DROP
                  REPEAT R> CLOSE-FILE
                 buffer FREE DROP
                sourceId CLOSE-FILE DROP ;

\ ������������� ����� ��������� ������
: init ( --> )
       cmdline> COMMANDS SEAL ALSO expand UNDER
       S" name.####.*" SaveString TO FileMask
       SOURCE DROP C@ [CHAR] " = IF ['] KEY TO ?waiting THEN
       ;

\ ������� �����
: break ( --> )
        init SeeForw NIP
        IFNOT [ ALSO COMMANDS ] -h [ PREVIOUS ]
         ELSE ['] INTERPRET CATCH
              IF ."  .\n\rInternal error."
               ELSE ['] PROCESS-FILES CATCH DROP
              THEN
        THEN BYE ;

\ -- ���������� � ���� -------------------------------------------------------

' break MAINX !

S" break.exe" SAVE

