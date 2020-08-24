: FirstWord ( addr u -- addr1 u1 )
  >IN @ >R #TIB @ >R TIB >R
    #TIB ! TO TIB >IN 0!

    NextWord
  R> TO TIB R> #TIB ! R> >IN !
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

