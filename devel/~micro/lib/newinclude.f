: IsAnySlash ( c -- f )
\ f=TRUE, �᫨ c ���� ��襬 (������� �����)
  DUP [CHAR] \ = IF
    DROP TRUE
  ELSE
    [CHAR] / =
  THEN
;

: SelectPath  ( addr -- addr1 u )
\ ������ ���� (����� � ��襬) �� ������� ����� 䠩��
\ addr - null-terminated ������ ���
  DUP >R
  BEGIN
    DUP C@
  WHILE
    1+
  REPEAT
  R@ OVER = IF
    RDROP 0
  ELSE
    BEGIN
      DUP C@ IsAnySlash 0=
      OVER R@ = 0= AND
    WHILE
      1-
    REPEAT
    R> SWAP OVER -
    2DUP + C@ IsAnySlash IF 1+ THEN
  THEN
;

: SAVE-CURFILE ( addr u -- lastaddr )
\ ������� addr u � CURFILE, � ������ ��� ��஥ ���祭��
  CURFILE @ ROT ROT
  HEAP-COPY CURFILE !
;

: RESTORE-CURFILE ( lastaddr -- )
\ ����⠭����� CURRFILE
  CURFILE @ FREE THROW
  CURFILE !
;

: INCLUDED-CURRPATH ( i*x addr u -- ior j*x )
\ addr u - ����� ���� ��� �⭮�⥫쭮 ⥪�饩 ��४�ਨ.
  2DUP
  SAVE-CURFILE >R
    INCLUDE-PROBE
  R> RESTORE-CURFILE
;

: MOVE-TO ( addr-src size addr-dst -- )
\ ���� ��⮢��������� ������
  SWAP MOVE
;

: CONCAT-TO ( addr1 u1 addr2 u2 addr -- )
\ ᮥ������ ��ப� addr1-u1 � addr2-u2, ������� १���� � addr
  >R
  2SWAP ( addr2 u2 addr1 u1 )
  SWAP OVER ( addr2 u2 u1 addr1 u1 )
  R@ MOVE-TO ( addr2 u2 u1 )
  R> + MOVE-TO
;

: CONCAT ( addr1 u1 addr2 u2 -- addr u )
\ ᮥ������ ��ப� addr1-u1 � addr2-u2, ������ �������᪨
\ �뤥������ ������� ����� � १���⮬. ࠧ���� -
\ null-terminaated
  2OVER NIP OVER + DUP >R 1+
  ALLOCATE THROW DUP >R
  CONCAT-TO
  R> R> 2DUP + 0 SWAP C!
;

: INCLUDED-LASTPATH ( i*x addr u -- ior j*x )
\ addr u - ���� � 䠩�� �⭮�⥫쭮 ��� � ⥪�饬� �������㥬��� 䠩��
  CURFILE @ ?DUP IF
    SelectPath
    2SWAP CONCAT
    OVER >R
    INCLUDED-CURRPATH
    R> FREE THROW
  ELSE
    2DROP
    3
  THEN
;

: INCLUDED-SPF ( i*x addr u -- ior j*x )
\ addr u - ���� � 䠩�� �⭮�⥫쭮 ���������饣� ��� ��譨��
  +ModuleDirName INCLUDED-CURRPATH
;

: INCLUDED ( i*x addr u -- j*x ) 
  2DUP INCLUDED-LASTPATH IF
    2DUP INCLUDED-SPF IF
      INCLUDED-CURRPATH THROW
    ELSE
      2DROP
    THEN
  ELSE
    2DROP
  THEN
;

S" ~ac/lib/require.f" INCLUDED

REQUIRE COMMENT> ~micro/lib/comment.f

COMMENT>

���������� ��⥩ ���᪠ � INCLUDED � REQUIRE
�᫨ � 䠩�� \prj1\main.f ����������� INCLUDED, � ��� ���᪠:
1. prj1\ (SPF3.75 �� ⠪��� ��� �� ���)
2. spf\ (�� exe譨��, �᫨ �筥�)
3. ����騩
REQUIRE ������������ ������ �� ~ac/lib/require.f